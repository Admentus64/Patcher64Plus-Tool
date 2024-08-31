function CreateForm([uint16]$X=0, [uint16]$Y=0, [uint16]$Width=0, [uint16]$Height=0, [string]$Name="", [string]$Tag="", [object]$Form, [boolean]$IsGame=$False, [object]$AddTo=$null) {
    
    $Form.Size     = New-Object System.Drawing.Size($Width, $Height)
    $Form.Location = New-Object System.Drawing.Size($X, $Y)
    if ($Tag   -ne "")      { $Form.Tag = $Tag }
    if ($AddTo -ne $null)   { $AddTo.Controls.Add($Form) }

    if ($Name -ne "") {
        $Form.Name = $Name
        if     (IsSet $Last.Extend)   { Add-Member -InputObject $Form -NotePropertyMembers @{ Section = $Last.Extend } }
        elseif (!$IsGame)             { Add-Member -InputObject $Form -NotePropertyMembers @{ Section = "Core"       } }
        if     ( $IsGame) {
            $Redux[$Last.Extend][$Name] = $Form
            if (-not ($Redux.Sections -contains $Last.Extend) ) { $Redux.Sections += $Last.Extend }
        }
    }
    Add-Member -InputObject $Form -NotePropertyMembers @{ Active = $True; Hidden = $False }

    return $Form

}



#==============================================================================================================================================================================================
function CreateDialog([uint16]$Width=0, [uint16]$Height=0, [string]$Icon) {
    
    # Create the dialog that displays more info
    $Dialog = New-Object System.Windows.Forms.Form
    $Dialog.Text = $Patcher.Title
    $Dialog.Size = New-Object System.Drawing.Size($Width, $Height)
    $Dialog.MaximumSize = $Dialog.Size
    $Dialog.MinimumSize = $Dialog.Size
    $Dialog.MaximizeBox = $True
    $Dialog.MinimizeBox = $True
    $Dialog.AutoScale = $True
    $Dialog.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Inherit
    $Dialog.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $Dialog.StartPosition = "CenterScreen"
    if (IsSet $Icon) {
        if ($IsFoolsDay)   { $Dialog.Icon = $Files.icon.jason }
        else               { $Dialog.Icon = $Icon             }
    }

    return $Dialog

}



#==============================================================================================================================================================================================
function CreateColorDialog([string]$Color="000000", [string]$Name="", [switch]$IsGame, [object]$Button=$null) {
    
    $ColorDialog = New-Object System.Windows.Forms.ColorDialog
    $ColorDialog.Color = "#" + $Color

    if ($IsGame -and $Name -ne "")   { $Redux[$Last.Extend][$Name] = $ColorDialog }
    if ($Name -ne "")                { $ColorDialog.Tag = $Name }
    
    if (IsSet $ColorDialog.Tag) {
        if ($IsGame) {
            if (IsSet $GameSettings["Colors"][$ColorDialog.Tag]) {
                if ($GameSettings["Colors"][$ColorDialog.Tag] -match "^[0-9A-F]+$")   { $ColorDialog.Color = "#" + $GameSettings["Colors"][$ColorDialog.Tag] }
                else                                                                  { $ColorDialog.Color = $GameSettings["Colors"][$ColorDialog.Tag] }
            }
            else { $GameSettings["Colors"][$ColorDialog.Tag] = $ColorDialog.Color.Name }
        }
        else {
            if (IsSet $Settings["Colors"][$ColorDialog.Tag]) {
                if ($Settings["Colors"][$ColorDialog.Tag] -match "^[0-9A-F]+$")   { $ColorDialog.Color = "#" + $Settings["Colors"][$ColorDialog.Tag] }
                else                                                              { $ColorDialog.Color = $Settings["Colors"][$ColorDialog.Tag] }
            }
            else { $Settings["Colors"][$ColorDialog.Tag] = $ColorDialog.Color.Name }
        }
    }

    Add-Member -InputObject $ColorDialog -NotePropertyMembers @{ Default = $Color; Button  = $Button }
    return $ColorDialog

}



#==============================================================================================================================================================================================
function CreateGroupBox([uint16]$X=0, [uint16]$Y=0, [uint16]$Width=0, [uint16]$Height=0, [string]$Name="", [string]$Tag="", [string]$Text, [object]$AddTo=$Last.Panel) {
    
    $Last.Group      = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -Form (New-Object System.Windows.Forms.GroupBox) -AddTo $AddTo
    $Last.Hide       = $False
    $Last.Group.Font = $Fonts.Small
    $Last.SaveAs     = 0
    if ($Text -ne "") {
        while ($Text -like "* & *") { $Text = $Text.Replace("&", "&&") }
        $Last.Group.Text = (" " + $Text + " ")
    }
    return $Last.Group

}



#==============================================================================================================================================================================================
function CreatePanel([uint16]$X=0, [uint16]$Y=0, [uint16]$Width=0, [uint16]$Height=0, [string]$Name="", [string]$Tag="", [boolean]$Hide=$False, [object]$AddTo=$MainDialog) {
    
    $Last.Panel = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -Form (New-Object System.Windows.Forms.Panel) -AddTo $AddTo
    $Last.Group = $null
    $Last.Half  = $False
    if ($Hide) { $Last.Panel.Hide() }
    return $Last.Panel

}



#==============================================================================================================================================================================================
function CreateTextBox([uint16]$X=0, [uint16]$Y=0, [uint16]$Width=0, [uint16]$Height=0, [uint16]$Length=10, [string]$Name="", [string]$Tag="", [switch]$ReadOnly, [switch]$Multiline, [string]$Text="", [string]$Info="", [switch]$IsGame, [switch]$TextFileFont, [object]$AddTo=$Last.Group) {
    
    $textBox = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -IsGame $IsGame -Form (New-Object System.Windows.Forms.TextBox) -AddTo $AddTo
    $textBox.Text = $Text
    if ($TextFileFont)   { $textBox.Font = $Fonts.TextFile }
    else                 { $textBox.Font = $Fonts.Small    }
    $textBox.MaxLength = $Length

    if ($ReadOnly) {
        $textBox.ReadOnly = $True
        $textBox.Cursor = 'Default'
        $textBox.ShortcutsEnabled = $False
        $textBox.BackColor = "White"
        $textBox.Add_Click({ $this.SelectionLength = 0 })
    }

    if ($Multiline) {
        $textBox.Multiline = $True
        $textBox.Scrollbars = 'Vertical'
        $textBox.WordWrap = $False
        $textBox.TabStop = $False
    }

    if ($Name -ne "") {
        if ($IsGame) {
            if (IsSet $GameSettings[$textBox.Section][$textBox.Name])   { $textBox.Text = $GameSettings[$textBox.Section][$textBox.Name] }
            else                                                        { $GameSettings[$textBox.Section][$textBox.Name] = $textBox.Text }
            $textBox.Add_TextChanged({ $GameSettings[$this.Section][$this.Name] = $this.Text })
        }
        else {
            if (IsSet $Settings["Core"][$textBox.Name])   { $textBox.Text = $Settings["Core"][$textBox.Name] }
            else                                          { $Settings["Core"][$TextBox.Name] = $textBox.Text }
            $textBox.Add_TextChanged({ $Settings["Core"][$this.Name] = $this.Text })
        }
    }
    
    Add-Member -InputObject $textBox -NotePropertyMembers @{ Default = $Text }
    $ToolTip = CreateToolTip -Form $textBox -Info $Info
    return $TextBox

}



#==============================================================================================================================================================================================
function CreateCheckBox([uint16]$X=0, [uint16]$Y=0, [byte]$SaveAs=$Last.SaveAs, [string]$SaveTo="", [byte]$Max=1, [string]$Name="", [string]$Tag="", [boolean]$Checked=$False, [boolean]$Disable=$False, [switch]$IsRadio, [string]$Info="", [boolean]$IsGame=$False, [boolean]$IsDebug=$False, [object]$AddTo=$Last.Group, [object]$Link=$null) {
    
    if ($IsRadio) {
        $Last.SaveAs++
        $checkBox = CreateForm -X $X -Y $Y -Width (DPISize 20) -Height (DPISize 20) -Name $Name -Tag $Tag -IsGame $IsGame -Form (New-Object System.Windows.Forms.RadioButton) -AddTo $AddTo
        Add-Member -InputObject $CheckBox -NotePropertyMembers @{ SaveAs = $SaveAs; SaveTo = $SaveTo }
    }
    else { $CheckBox = CreateForm -X $X -Y $Y -Width (DPISize 20) -Height (DPISize 20) -Name $Name -Tag $Tag -IsGame $IsGame -Form (New-Object System.Windows.Forms.CheckBox) -AddTo $AddTo }
    $ToolTip = CreateToolTip -Form $checkBox -Info $Info
    $checkBox.Enabled = !$Disable

    if ($Name -ne "") {
        if ($IsGame) {
            if ($IsRadio) {
                if (IsSet -Elem $GameSettings[$checkBox.Section][$checkBox.SaveTo] -Max $Max -HasInt)   { $checkBox.Checked =        $GameSettings[$checkBox.Section][$checkBox.SaveTo] -eq $checkBox.SaveAs }
                elseif ($Checked)                                                                       { $checkBox.Checked = $True; $GameSettings[$checkBox.Section][$checkBox.SaveTo] =   $checkBox.SaveAs }
                $checkBox.Add_CheckedChanged({ $GameSettings[$this.Section][$this.SaveTo] = $this.SaveAs })
            }
            else {
                if (IsSet $GameSettings[$checkBox.Section][$CheckBox.Name])                             { $checkBox.Checked = $GameSettings[$checkBox.Section][$checkBox.Name] -eq "True"  }
                else                                                                                    { $checkBox.Checked = $GameSettings[$checkBox.Section][$checkBox.Name] = $Checked  }
                $checkBox.Add_CheckStateChanged({ $GameSettings[$this.Section][$this.Name] = $this.Checked })
            }
        }
        else {
            if ($IsDebug) { $checkBox.Section = "Debug" } else { $checkBox.Section = "Core" }
            if ($IsRadio) {
                if (IsSet -Elem $Settings[$CheckBox.Section][$checkBox.SaveTo] -Max $Max -HasInt)       { $checkBox.Checked =        $Settings[$checkBox.Section][$checkBox.SaveTo] -eq $checkBox.SaveAs }
                elseif ($Checked)                                                                       { $checkBox.Checked = $True; $Settings[$checkBox.Section][$checkBox.SaveTo] =   $checkBox.SaveAs }
                $checkBox.Add_CheckedChanged({ $Settings[$this.Section][$this.SaveTo] = $this.SaveAs })
            }
            else {
                if (IsSet $Settings[$checkBox.Section][$checkBox.Name])                                 { $checkBox.Checked = $Settings[$checkBox.Section][$checkBox.Name] -eq "True" }
                else                                                                                    { $checkBox.Checked = $Settings[$checkBox.Section][$checkBox.Name] = $Checked }
                $checkBox.Add_CheckStateChanged({ $Settings[$this.Section][$this.Name] = $this.Checked })
            }
        }
    }
    else { $checkBox.Checked = $Checked }

    if ($Link -ne $null) {
        Add-Member -InputObject $checkBox -NotePropertyMembers @{ Link = $Link     }
        Add-Member -InputObject $Link     -NotePropertyMembers @{ Link = $checkBox }

        if ($checkbox.GetType().Name -eq "Checkbox")   { $checkbox.Add_CheckStateChanged( { EnableElem -Elem $this.Link -Active (!$this.Checked) }) }
        else                                           { $checkbox.Add_CheckedChanged(    { EnableElem -Elem $this.Link -Active (!$this.Checked) }) }
        if ($Link.GetType().Name     -eq "Checkbox")   { $Link.Add_CheckStateChanged(     { EnableElem -Elem $this.Link -Active (!$this.Checked) }) }
        else                                           { $Link.Add_CheckedChanged(        { EnableElem -Elem $this.Link -Active (!$this.Checked) }) }
        EnableElem -Elem $checkBox -Active (!$checkBox.Link.Checked)
        EnableElem -Elem $Link     -Active (!$Link.Link.Checked)
        if ($checkBox.checked -and $checkBox.link.Checked)   { $checkBox.Checked = $False }
        if ($link.checked     -and $Link.link.Checked)       { $Link.Checked     = $False }
    }

    Add-Member -InputObject $CheckBox -NotePropertyMembers @{ Default = $Checked }
    return $CheckBox

}



#==============================================================================================================================================================================================
function CreateComboBox([uint16]$X=0, [uint16]$Y=0, [uint16]$Width=0, [uint16]$Height=0, [string]$Name="", [string]$Tag="", [string[]]$Items=@(), [byte]$Default=1, [string]$Info, [switch]$IsGame, [object]$AddTo=$Last.Group) {
    
    $comboBox = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -IsGame $IsGame -Form (New-Object System.Windows.Forms.ComboBox) -AddTo $AddTo
    $comboBox.DropDownStyle = "DropDownList"
    $comboBox.Add_Mousewheel({ $_.Handled = $True })
    $comboBox.Font = $Fonts.Small
    $ToolTip = CreateToolTip -Form $comboBox -Info $Info
    if ($Default -lt 1) { $Default = 1 }
    
    if ($Items.Count -gt 0) {
        $comboBox.Items.AddRange($Items)
        if ($comboBox.Name -ne "") {
            if ($IsGame) {
                if (IsSet $GameSettings[$comboBox.Section][$comboBox.Name] -Max $comboBox.Items.Count -HasInt)   { $comboBox.SelectedIndex = ($GameSettings[$ComboBox.Section][$comboBox.Name]-1) }
                else                                                                                             { $GameSettings[$ComboBox.Section][$ComboBox.Name] = $Default }
                $comboBox.Add_SelectedIndexChanged({ $GameSettings[$this.Section][$this.Name] = ($this.SelectedIndex+1) })
            }
            else {
                if (IsSet $Settings["Core"][$comboBox.Name] -Max $comboBox.Items.Count -HasInt)                  { $comboBox.SelectedIndex = ($Settings["Core"][$comboBox.Name]-1) }
                else                                                                                             { $Settings["Core"][$ComboBox.Name] = $Default }
                $comboBox.Add_SelectedIndexChanged({ $Settings["Core"][$this.Name] = ($this.SelectedIndex+1) })
            }
        }
        if ($comboBox.SelectedIndex -lt 0) { $comboBox.SelectedIndex = $Default - 1 }
    }

    Add-Member -InputObject $comboBox -NotePropertyMembers @{ Default = $Default - 1 }
    return $comboBox

}



#==============================================================================================================================================================================================
function CreateSlider([uint16]$X=0, [uint16]$Y=0, [uint16]$Width=0, [uint16]$Height=0, [uint16]$Default=0, [uint16]$Min=0, [uint16]$Max=255, [uint16]$Freq=5, [uint16]$Small=2, [uint16]$Large=3, [string]$Name="", [string]$Tag="", [string]$Info="", [switch]$IsGame, [object]$AddTo=$Last.Group) {
    
    $slider  = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -IsGame $IsGame -Form (New-Object System.Windows.Forms.TrackBar) -AddTo $AddTo
    $ToolTip = CreateToolTip -Form $Slider -Info $Info

    $slider.Minimum       = $Min
    $slider.Maximum       = $Max
    $slider.TickFrequency = $Freq
    $slider.SmallChange   = $Small
    $slider.LargeChange   = $Large

    if ($Name -ne "") {
        if ($IsGame) {
            if (!(IsSet $GameSettings[$Slider.Section][$slider.Name] -Min $Min -Max $Max -HasInt)) { $GameSettings[$slider.Section][$slider.Name] = $Default }
            $slider.Add_ValueChanged({ $GameSettings[$this.Section][$this.Name] = $this.value })
            $slider.value = $GameSettings[$slider.Section][$slider.Name]
        }
        else {
            if (!(IsSet $Settings["Core"][$slider.Name] -Min $Min -Max $Max -HasInt)) { $Settings["Core"][$slider.Name] = $Minimum }
            $slider.Add_ValueChanged({ $Settings["Core"][$this.Name] = $this.value })
            $slider.value = $Settings["Core"][$slider.Name]
        }
    }

    Add-Member -InputObject $slider -NotePropertyMembers @{ Default = $Default }
    $slider.Add_MouseClick({
        if ($_.Button -eq "Right") { $this.value = $this.Default }
    })
    $slider.Add_Mousewheel({ $_.Handled = $True })

    return $slider

}



#==============================================================================================================================================================================================
function CreateListBox([uint16]$X=0, [uint16]$Y=0, [uint16]$Width=0, [uint16]$Height=0, [string[]]$Items, [int]$ItemWidth=100, [boolean]$MultiColumn=$False, [boolean]$MultiSelect=$False, [string]$Name="", [string]$Tag="", [string]$Info="", [switch]$IsGame, [object]$AddTo=$Last.Group) {

    $listBox = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -IsGame $IsGame -Form (New-Object System.Windows.Forms.Listbox) -AddTo $AddTo
    if ($MultiSelect) { $listBox.SelectionMode = 'MultiSimple' }
    if ($MultiColumn) {
        $listBox.MultiColumn = $True
        $listBox.ColumnWidth = DPISize $ItemWidth
    }

    if ($items.count -gt 0) { $listBox.Items.AddRange($items) }

    if ($Name -ne "") {
        if ($IsGame) {
            if ($GameSettings[$listBox.Section][$listBox.Name] -ne "" -and $GameSettings[$listBox.Section][$listBox.Name] -ne $null) {
                $load = $GameSettings[$listBox.Section][$listBox.Name].ToCharArray()
                foreach ($i in 0..($listBox.items.count-1)) { if ($load[$i] -eq "1") { $listBox.SetSelected($i, 1) } }
            }
            
            $listBox.Add_SelectedIndexChanged({
                $save = ""
                foreach ($i in 0..($this.items.count-1)) { if ($this.getSelected($i) -eq $True) { $save += "1" } else { $save += "0" } }
                $GameSettings[$this.Section][$this.Name] = $save
            })
        }
    }

    return $listBox

}


#==============================================================================================================================================================================================
function CreateLabel([uint16]$X=0, [uint16]$Y=0, [uint16]$Width=0, [uint16]$Height=20, [string]$Name, [string]$Tag, [string]$Text="", [System.Drawing.Font]$Font=$Fonts.Small, [string]$Info="", [object]$AddTo=$Last.Group) {
    
    $label             = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -Form (New-Object System.Windows.Forms.Label) -AddTo $AddTo
    $label.UseMnemonic = $False
    if ($Text  -ne "")   { $label.Text     = $Text }
    if ($Width -eq 0)    { $label.AutoSize = $True }
    $label.Font = $Font
    $ToolTip = CreateToolTip -Form $label -Info $Info
    return $label

}



#==============================================================================================================================================================================================
function CreateButton([uint16]$X=0, [uint16]$Y=0, [uint16]$Width=(DPISize 100), [uint16]$Height=(DPISize 20), [string]$Name, [string]$Tag, [string]$ForeColor="", [string]$BackColor="", [string]$Text="", [string]$Info="", [System.Drawing.Font]$Font=$Fonts.Small, [object]$AddTo=$Last.Group) {
    
    $button = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -Form (New-Object System.Windows.Forms.Button) -AddTo $AddTo
    if ($Text -ne "")       { $button.Text = $Text }
    $button.Font = $Font
    if ($ForeColor -ne "")   { $button.ForeColor = $ForeColor }
    if ($BackColor -ne "")   { $button.BackColor = $BackColor }
    if ($Info      -ne "")   { $ToolTip = CreateToolTip -Form $button -Info $Info }
    return $button

}




#==============================================================================================================================================================================================
function CreatePreviewGroup([single]$Height=0, [string]$Text="") {

    $Last.Column = $Last.Row = 1

    if ($Height -ne 0) { $Last.Flexible = $False }
    else {
        $Last.Flexible = $True
        $Height = 1
    }
    
    if ($Last.Group -ne $null) { $Y = $Last.Group.Bottom + 5 } else { $Y = 0 }
    $group = CreateGroupBox -Y $Y -Width ($OptionsPreviews.Dialog.Width - (DPISize 50) ) -Height ($Height * (DPISize 30) + (DPISize 20)) -Tag "Previews" -Text $Text -AddTo $OptionsPreviews.Panel
    $group.Tag = "Previews"
    if (!(IsSet $Redux["Previews"]) ) { $Redux["Previews"] = @{} }
    $Last.Extend = "Previews"

    return $group

}



#==============================================================================================================================================================================================
function CreateReduxGroup([single]$X=(DPISize 10), [single]$Y=0, [single]$Height=0, [string]$Name=$Last.TabName, [string]$Tag="", [boolean]$IsGame=$True, [string]$Text="", [single]$Columns=0, [object]$AddTo=$Last.Panel, [Object]$Expose, [Object]$Exclude, [byte]$Base, [switch]$Child, [switch]$Adult, [switch]$Safe) {
    
    if  ($Safe -and $Settings.Core.SafeOptions -eq $True) { return $null }
    if (!(CheckReduxOption -Expose $Expose -Exclude $Exclude -Base $Base -Child $Child -Adult $Adult) ) { return $null }
    $Width = ($AddTo.Width - (DPISize 30))
    $Last.Column = $Last.Row = 1

    if ($Columns -eq 0)   { $Last.Width = [byte][Math]::Round($Last.Panel.Width / $ColumnWidth) }
    else                  { $Last.Width = [byte]$Columns }
    
    $Last.Flexible = $Height -eq 0
    if ($Height -eq 0) { $Height = 1 }

    if ($Name -ne "") {
        if (!$Last.Half -and $Last.Group -ne $null) { $Y = $Last.Group.Bottom + 5 }
        if ($Last.Half) {
            $X             = $Last.Group.Right + (DPISize 5)
            $Y             = $Last.Group.Top
            $Width         = $AddTo.Width - $Last.Group.Right - (DPISize 40)
            $Height        = $Last.Group.Rows
            $Last.Half     = $False
            $Last.Flexible = $False
        }
        if ($Columns -gt 0) {
            $Width     = $FormDistance * $Columns
            $Last.Half = $True
        }
    }

    $group = CreateGroupBox -X $X -Y $Y -Width $Width -Height ($Height * (DPISize 30) + (DPISize 20)) -Name $Name -Tag $Tag -Text $Text -AddTo $AddTo
    
    if (IsSet $Tag) {
        $group.Tag = $Last.Extend = $Tag
        if ($Redux[$Tag] -eq $null) { $Redux[$Tag] = @{} }
    }
    else { $Last.Extend = $null }

    if ($IsGame) {
        $Redux.Groups += $group
        if (!(IsSet $GameSettings[$Tag])) { $GameSettings[$Tag] = @{} }
    }

    Add-Member -InputObject $group -NotePropertyMembers @{ Rows = $Height }
    return $group

}



#==============================================================================================================================================================================================
function CreateReduxButton([single]$Column=$Last.Column, [single]$Row=$Last.Row, [int16]$Width=100, [int16]$Height=20, [string]$Name="", [string]$Tag="", [string]$Text="", [string]$Info="", [string]$Credits="", [object]$AddTo=$Last.Group, [switch]$Native, [Object]$Expose, [Object]$Exclude, [byte]$Base, [switch]$Child, [switch]$Adult, [switch]$Safe) {
    
    if  ($Safe -and $Settings.Core.SafeOptions -eq $True) { return $null }
    if (!(CheckReduxOption -Name $Name -Expose $Expose -Exclude $Exclude -Base $Base -Child $Child -Adult $Adult) -or $Last.Hide -or $Last.Group -eq $null) { return $null }

    if ($Info -ne "" -and $Credits -ne "") { $Info += ("`n`n- Credits: " + $Credits) }
    $button      = CreateButton -X (($Column-1) * $FormDistance + (DPISize 15)) -Y ($Row * (DPISize 30) - (DPISize 13)) -Width (DPISize $Width) -Height (DPISize $Height) -Name $Name -Tag $Tag -Text $Text -Info $Info -AddTo $AddTo
    $Last.Column = [Math]::floor($Column) + 1
    $Last.Row    = [Math]::floor($Row)
    if ($Column -ge $Last.Width) {
        $Last.Column = 1
        $Last.Row++
    }
    if ($Last.Flexible) { $Last.Group.Height = ($Row * (DPISize 30) + (DPISize 20)) }

    if ($Native) { $Redux.NativeOptions += @($button, $label) }
    return $button

}



#==============================================================================================================================================================================================
function CreateReduxTextBox([single]$Column=$Last.Column, [single]$Row=$Last.Row, [byte]$Length=2, [int16]$Width=35, [int16]$Shift=0,[sbyte]$BoxHeight=-1, [string]$Value=0, [switch]$ASCII, [int]$Min, [int]$Max, [string]$Text="", [string]$Info="", [string]$Warning="", [string]$Credits="", [string]$Name="", [string]$Tag="", [object]$AddTo=$Last.Group, [switch]$Native, [Object]$Expose, [Object]$Exclude, [Object]$Force, [int16]$ForcedValue=0, [byte]$Base, [switch]$Child, [switch]$Adult, [switch]$Safe) {
    
    if  ($Safe -and $Settings.Core.SafeOptions -eq $True)                   { return $null }
    if   (ForceReduxOption -Name $Name -Force $Force -Value $ForcedValue)   { return $null }
    if (!(CheckReduxOption -Name $Name -Expose $Expose -Exclude $Exclude -Base $Base -Child $Child -Adult $Adult) -or $Last.Hide -or $Last.Group -eq $null) { return $null }

    if ($Info -ne "") {
        $Info += "`nDefault value: " + $Value
        if ($Text -Like "*FPS*" -or $Text -Like "*Widescreen*" -or $Text -Like "*Extended Draw Distance*")   { $Info += ("`n[!] "          + "Should not be used on console") }
        if ($Warning -ne "")                                                                                 { $Info += ("`n[!] "          + $Warning)                        }
        if ($Credits -ne "")                                                                                 { $Info += ("`n`n- Credits: " + $Credits)                        }
    }

    if ($Text -ne "") { $Text += ":" }

    $label   = CreateLabel   -X (($Column-1) * $FormDistance + (DPISize 15)) -Y ($Row * (DPISize 30) - (DPISize 10)) -Width (DPISize (105 - $Shift) ) -Height (DPISize 28)                 -Text $Text                                      -Info $Info -AddTo $AddTo
    $textBox = CreateTextBox -X $label.Right                                 -Y ($label.Top + (DPISize $BoxHeight))  -Width (DPISize $Width)          -Height (DPISize 15) -Length $Length -Text $Value -IsGame $True -Name $Name -Tag $Tag -Info $Info -AddTo $AddTo

    if (!$ASCII) {
        $textBox.Add_LostFocus({
            if (($this.Text -as [int]) -eq $null)                           { $this.Text = $this.Default }
            else {
                if (IsSet $this.Min) { if ([int]$this.Text -lt $this.Min)   { $this.Text = $this.Min } }
                if (IsSet $this.Max) { if ([int]$this.Text -gt $this.Max)   { $this.Text = $this.Max } }
            }
        })

        if (IsSet $Min) {
            if ([int]$TextBox.Text -lt $Min) { $textBox.Text = $Min }
            Add-Member -InputObject $textBox -NotePropertyMembers @{ Min = $Min }
        }
        if (IsSet $Max) {
            if ([int]$TextBox.Text -gt $Max) { $textBox.Text = $Max }
            Add-Member -InputObject $textBox -NotePropertyMembers @{ Max = $Max }
        }
    }
    
    $Last.Column = [Math]::floor($Column) + 1
    $Last.Row    = [Math]::floor($Row)
    if ($Column -ge $Last.Width) {
        $Last.Column = 1
        $Last.Row++
    }
    if ($Last.Flexible) { $Last.Group.Height = ($Row * (DPISize 30) + (DPISize 20)) }

    if ($Native) { $Redux.NativeOptions += @($textBox, $label) }
    return $textBox

}



#==============================================================================================================================================================================================
function CreateReduxRadioButton([single]$Column=$Last.Column, [single]$Row=$Last.Row, [switch]$Checked, [switch]$Disable, [string]$Text="", [string]$Info="", [string]$Warning="", [string]$Credits="", [string]$Name="", [object]$Link=$null, [string]$SaveTo="", [byte]$Max, [string]$Tag, [object]$AddTo=$Last.Group, [switch]$Native, [Object]$Expose, [Object]$Exclude, [Object]$Force, [byte]$Base, [switch]$Child, [switch]$Adult, [switch]$Safe) {
    
    if  ($Safe -and $Settings.Core.SafeOptions -eq $True)   { return $null }
    if   (ForceReduxOption -Name $Name -Force $Force)       { return $null }
    if (!(CheckReduxOption -Name $Name -Expose $Expose -Exclude $Exclude -Base $Base -Child $Child -Adult $Adult) -or $Last.Hide -or $Last.Group -eq $null) { return $null }

    if ($Info -ne "") {
        if ($Text -Like "*FPS*" -or $Text -Like "*Widescreen*" -or $Text -Like "*Extended Draw Distance*")   { $Info += ("`n[!] "          + "Should not be used on console") }
        if ($Warning -ne "")                                                                                 { $Info += ("`n[!] "          + $Warning)                        }
        if ($Credits -ne "")                                                                                 { $Info += ("`n`n- Credits: " + $Credits)                        }
    }

    $radio = CreateCheckBox -X (($Column-1) * $FormDistance + (DPISize 15)) -Y ($Row * (DPISize 30) - (DPISize 10)) -Checked $Checked -Disable $Disable -IsRadio -Info $Info -IsGame $True -Name $Name -SaveTo $SaveTo -Max $Max -Tag $Tag -AddTo $AddTo -Link $Link

    if ($Text -ne "") {
        $label = CreateLabel -X $radio.Right -Y ($radio.Top + (DPISize 2)) -Height (DPISize 15) -Text $Text -Info $Info -AddTo $AddTo
        Add-Member -InputObject $label -NotePropertyMembers @{ CheckBox = $radio }
        Add-Member -InputObject $radio -NotePropertyMembers @{ Label    = $Text }
        $Label.Add_Click({
            if ($this.CheckBox.Enabled) { $this.CheckBox.Checked = $True }
        })
    }

    $Last.Column = [Math]::floor($Column) + 1
    $Last.Row    = [Math]::floor($Row)
    if ($Column -ge $Last.Width) {
        $Last.Column = 1
        $Last.Row++
    }
    if ($Last.Flexible) { $Last.Group.Height = ($Row * (DPISize 30) + (DPISize 20)) }

    if ($Native) { $Redux.NativeOptions += @($radio, $label) }
    return $radio

}



#==============================================================================================================================================================================================
function CreateReduxCheckBox([single]$Column=$Last.Column, [single]$Row=$Last.Row, [switch]$Checked, [switch]$Disable, [string]$Text="", [string]$Info="", [string]$Warning="", [string]$Credits="", [string]$Name="", [string]$Tag="", [object]$Link=$null, [object]$AddTo=$Last.Group, [switch]$Native, [Object]$Expose, [Object]$Exclude, [Object]$Force, [byte]$Base, [switch]$Child, [switch]$Adult, [switch]$Safe) {
    
    if  ($Safe -and $Settings.Core.SafeOptions -eq $True)  { return $null }
    if   (ForceReduxOption -Name $Name -Force $Force)      { return $null }
    if (!(CheckReduxOption -Name $Name -Expose $Expose -Exclude $Exclude -Base $Base -Child $Child -Adult $Adult) -or $Last.Hide -or $Last.Group -eq $null) { return $null }

    if ($Info -ne "") {
        if ($Text -Like "*FPS*" -or $Text -Like "*Widescreen*" -or $Text -Like "*Extended Draw Distance*")   { $Info += ("`n[!] "          + "Should not be used on console") }
        if ($Warning -ne "")                                                                                 { $Info += ("`n[!] "          + $Warning)                        }
        if ($Credits -ne "")                                                                                 { $Info += ("`n`n- Credits: " + $Credits)                        }
    }

    $checkBox = CreateCheckBox -X (($Column-1) * $FormDistance + (DPISize 15)) -Y ($Row * (DPISize 30) - (DPISize 10)) -Checked $Checked -Disable $Disable -Info $Info -IsGame $True -Name $Name -Tag $Tag -AddTo $AddTo -Link $Link

    if ($Text -ne "") {
        $label = CreateLabel -X $checkBox.Right -Y ($checkBox.Top + (DPISize 2)) -Height (DPISize 15) -Text $Text -Info $Info -AddTo $AddTo
        Add-Member -InputObject $label    -NotePropertyMembers @{ CheckBox = $checkBox }
        Add-Member -InputObject $checkBox -NotePropertyMembers @{ Label    = $Text }
        $Label.Add_Click({
            if ($this.CheckBox.Enabled) { $this.CheckBox.Checked = !$this.CheckBox.Checked }
        })
    }

    $Last.Column = [Math]::floor($Column) + 1
    $Last.Row    = [Math]::floor($Row)
    if ($Column -ge $Last.Width) {
        $Last.Column = 1
        $Last.Row++
    }
    if ($Last.Flexible) { $Last.Group.Height = ($Row * (DPISize 30) + (DPISize 20)) }

    if ($Native) { $Redux.NativeOptions += @($checkBox, $label) }
    return $checkBox

}



#==============================================================================================================================================================================================
function CreateReduxComboBox([single]$Column=$Last.Column, [single]$Row=$Last.Row, [int16]$Length=170, [sbyte]$Shift=0, [string[]]$Items=$null, [string[]]$Values=@(), [string[]]$PostItems=$null, [string]$FilePath="", $Ext="bin", $Default=1, $TrueDefault=0, [switch]$NoDefault, [string]$Text="", [string]$Info="", [string]$Warning="", [string]$Credits="", [string]$Name="", [string]$Tag="", [object]$AddTo=$Last.Group, [switch]$Native, [Object]$Expose, [Object]$Exclude, [Object]$Force, [byte]$ForcedValue=0, [byte]$Base, [switch]$Child, [switch]$Adult, [switch]$Safe) {
    
    if  ($Safe -and $Settings.Core.SafeOptions -eq $True)                   { return $null }
    if   (ForceReduxOption -Name $Name -Force $Force -Value $ForcedValue)   { return $null }
    if (!(CheckReduxOption -Name $Name -Expose $Expose -Exclude $Exclude -Base $Base -Child $Child -Adult $Adult) -or $Last.Hide -or $Last.Group -eq $null) { return $null }

    if ($Column -eq $Last.Width -and $Column -eq $Last.Column -and $Row -eq $Last.Row) { $Column = 1; $Row++ }

    if ($Info -ne "") {
        if ($Text -Like "*FPS*" -or $Text -Like "*Widescreen*" -or $Text -Like "*Extended Draw Distance*")   { $Info += ("`n[!] "          + "Should not be used on console") }
        if ($Warning -ne "")                                                                                 { $Info += ("`n[!] "          + $Warning)                        }
        if ($Credits -ne "")                                                                                 { $Info += ("`n`n- Credits: " + $Credits)                        }
    }

    if ($Text -ne "") {
        $Text += ":"
        $Width = (DPISize (120 + $Shift))
    }
    else { $Width = 0 }

    if ($FilePath -ne "") {
        foreach ($item in Get-ChildItem $FilePath) {
            if ($Ext -is [system.Array]) {
                foreach ($i in $Ext) {
                    if ($item.extension -eq ("." + $i)) { $Items += $item.BaseName }
                }
            }
            elseif ($item.extension -eq ("." + $Ext) -or $Ext -eq $null) { $Items += $item.BaseName }
        }
    }
    if ($Items.Count -gt 0 -and $PostItems.Count -gt 0) { $Items = $Items + $PostItems }

    if ($Items.Count -gt 0) {
        $Items = $Items | Select-Object -Unique
        if ($Default.GetType().Name     -eq "String")                                  { $Default              = [array]::indexof($Items, $Default)     + 1 }
        if ($TrueDefault.GetType().Name -eq "String")                                  { $TrueDefault          = [array]::indexof($Items, $TrueDefault) + 1 }
        if ($Items[$Default - 1] -ne "Default" -and $Default -gt 0 -and !$NoDefault)   { $Items[$Default - 1] += " (default)"                               }
    }

    if ($Column % 2 -eq 0) { $Column++ }

    $Default  = [byte]$Default
    $label    = CreateLabel    -X (($Column-1) * $FormDistance + (DPISize 15)) -Y ($Row * (DPISize 30) - (DPISize 10)) -Width $Width                       -Height (DPISize 15) -Text $Text -Info $Info -AddTo $AddTo
    $comboBox = CreateComboBox -X $label.Right                                 -Y ($label.Top - (DPISize 2))           -Width (DPISize ($Length - $Shift)) -Height (DPISize 20) -Items $Items -Default $Default -Info $Info -IsGame $True -Name $Name -Tag $Tag -AddTo $AddTo
    if ($TrueDefault -gt 0) { $comboBox.Default = $TrueDefault - 1 }

    if ($Text -ne "") {
        Add-Member -InputObject $label    -NotePropertyMembers @{ ComboBox = $comboBox }
        Add-Member -InputObject $comboBox -NotePropertyMembers @{ Label    = $Text }
    }
    if ($Values.Count -gt 0) {
        Add-Member -InputObject $comboBox -NotePropertyMembers @{
            Values = $Values
            Value  = $Values[$comboBox.selectedIndex]
        }
        $comboBox.Add_SelectedIndexChanged({ $this.Value = $this.Values[$this.selectedIndex] })
    }

    $Last.Column = [Math]::floor($Column) + 2
    $Last.Row    = [Math]::floor($Row)

    if ($Column -ge $Last.Width - 1) {
        $Last.Column = 1
        $Last.Row++
    }
    if ($Last.Flexible) { $Last.Group.Height = $Row * (DPISize 30) + (DPISize 20) }

    if ($Native) { $Redux.NativeOptions += @($comboBox, $label) }
    return $comboBox

}



#==============================================================================================================================================================================================
function CreateReduxSlider([single]$Column=$Last.Column, [single]$Row=$Last.Row, $Default, $Min, $Max, $Freq, $Small, $Large, [string]$Text, [string]$Info="", [string]$Warning="", [string]$Credits="", [string]$Name="", [string]$Tag="", [object]$AddTo=$Last.Group, [switch]$Native, [Object]$Expose, [Object]$Exclude, [Object]$Force, [byte]$ForcedValue=0, [byte]$Base, [switch]$Child, [switch]$Adult, [switch]$Safe) {
    
    if  ($Safe -and $Settings.Core.SafeOptions -eq $True)                   { return $null }
    if   (ForceReduxOption -Name $Name -Force $Force -Value $ForcedValue)   { return $null }
    if (!(CheckReduxOption -Name $Name -Expose $Expose -Exclude $Exclude -Base $Base -Child $Child -Adult $Adult) -or $Last.Hide -or $Last.Group -eq $null) { return $null }

    if ($Default.GetType().Name -eq "String")   { $Default = GetDecimal $Default }
    if ($Min.GetType().Name     -eq "String")   { $Min     = GetDecimal $Min }
    if ($Max.GetType().Name     -eq "String")   { $Max     = GetDecimal $Max }
    if ($Freq.GetType().Name    -eq "String")   { $Freq    = GetDecimal $Freq }
    if ($Small.GetType().Name   -eq "String")   { $Small   = GetDecimal $Small }
    if ($Large.GetType().Name   -eq "String")   { $Large   = GetDecimal $Large }

    $Info = "Right click to reset to default value`n`n" + $Info
    if ($Info -ne "" -and $Credits -ne "") { $Info += ("`n`n- Credits: " + $Credits) }
    if ($Text -ne "") { $Text += ":" }

    $label  = CreateLabel  -X (($Column-1) * $FormDistance + (DPISize 15)) -Y ($Row * (DPISize 45) - (DPISize 25)) -Width (DPISize 105) -Height (DPISize 15) -Text $Text -Info $Info -AddTo $AddTo
    $slider = CreateSlider -X $label.Right -Y ($label.Top - (DPISize 10)) -Width (DPISize 200) -Height (DPISize 10) -Default $Default -Min $Min -Max $Max -Freq $Freq -Small $Small -Large $Large -Info $Info -IsGame $True -Name $Name -Tag $Tag -AddTo $AddTo

    Add-Member -InputObject $label -NotePropertyMembers @{ Slider = $slider }
    $label.Add_MouseClick({
        if ($_.Button -eq "Right") { $this.Slider.value = $this.Slider.Default }
    })

    $Last.Column = [Math]::floor($Column) + 2
    $Last.Row    = [Math]::floor($Row)

    if ($Column -ge $Last.Width - 1) {
        $Last.Column = 1
        $Last.Row++
    }
    if ($Last.Flexible) { $Last.Group.Height = $Row * (DPISize 42) + (DPISize 20) }

    if ($Native) { $Redux.NativeOptions += $slider }
    return $slider

}



#==============================================================================================================================================================================================
function CreateReduxListBox([single]$Column=$Last.Column, [single]$Row=$Last.Row, [single]$Columns=1, [single]$Rows=1, [string[]]$Items, $Default=$null, [int]$ItemWidth=100, [switch]$MultiColumn, [switch]$MultiSelect, [string]$Text="", [string]$Info="", [string]$Warning="", [string]$Credits="", [string]$Name="", [string]$Tag="", [object]$AddTo=$Last.Group, [switch]$Native, [Object]$Expose, [Object]$Exclude, [byte]$Base, [switch]$Child, [switch]$Adult, [switch]$Safe) {
    
    if  ($Safe -and $Settings.Core.SafeOptions -eq $True) { return $null }
    if (!(CheckReduxOption -Name $Name -Expose $Expose -Exclude $Exclude -Base $Base -Child $Child -Adult $Adult) -or $Last.Hide -or $Last.Group -eq $null) { return $null }

    $listBox      = CreateListBox -X (($Column-1) * $FormDistance + (DPISize 15)) -Y ($Row * (DPISize 45) - (DPISize 25)) -Width ($Columns * (DPISize 180)) -Height ($Rows * (DPISize 35)) -Items $Items -Default $Default -ItemWidth $ItemWidth -MultiColumn $MultiColumn -MultiSelect $MultiSelect -Info $Info -IsGame $True -Name $Name -Tag $Tag -AddTo $AddTo
    $Last.Column += [Math]::floor($Columns)
    $Last.Row    += [Math]::floor($Rows)

    if ($Last.Column -ge $Last.Width - 1) {
        $Last.Column = 1
        $Last.Row++
    }
    if ($Last.Flexible) { $Last.Group.Height = ($Last.Row - 1) * (DPISize 30) + (DPISize 20) }
    
    if ($Native) { $Redux.NativeOptions += $listBox }
    return $listBox

}



#==============================================================================================================================================================================================
function CreateReduxColoredLabel([System.Windows.Forms.Button]$Link=$null, [System.Drawing.Color]$Color=$null, [string]$Name="", [string]$Tag="", [object]$AddTo=$Last.Group, [switch]$Native, [Object]$Expose, [Object]$Exclude, [byte]$Base, [switch]$Child, [switch]$Adult, [switch]$Safe) {
    
    if  ($Safe -and $Settings.Core.SafeOptions -eq $True) { return $null }
    if (!(CheckReduxOption -Name $Name -Expose $Expose -Exclude $Exclude -Base $Base -Child $Child -Adult $Adult) -or $Last.Hide -or $Last.Group -eq $null) { return $null }

    $label = CreateLabel -X ($Link.Right + (DPISize 15)) -Y $Link.Top -Width (DPISize 40) -Height $Link.Height -Name $Name -Tag $Tag -AddTo $AddTo
    if ($Color -ne $null) { $label.BackColor = $Color }

    if ($Native) { $Redux.NativeOptions += $label }
    return $label

}



#==============================================================================================================================================================================================
function CreateImageBox([int]$X=0, [int]$Y=0, [int]$W=0, [int]$H=0, [boolean]$IsGame=$True, [string]$Name="", [string]$Tag="", [object]$AddTo=$Last.Group, [switch]$Native, [Object]$Expose, [Object]$Exclude, [byte]$Base, [switch]$Child, [switch]$Adult, [switch]$Safe) {
    
    if  ($Safe -and $Settings.Core.SafeOptions -eq $True) { return $null }
    if (!(CheckReduxOption -Name $Name -Expose $Expose -Exclude $Exclude -Base $Base -Child $Child -Adult $Adult) -or $Last.Hide) { return $null }

    $image          = CreateForm -X $X -Y $Y -Width $Width -Height $Height -IsGame $IsGame -Name $Name -Tag $Tag -Form (New-Object Windows.Forms.PictureBox) -AddTo $AddTo 
    $image.Location = DPISize (New-object System.Drawing.Size($X, $Y))
    $image.Size     = DPISize (New-object System.Drawing.Size($W, $H))

    if ($Native) { $Redux.NativeOptions += $image }
    return $image

}



#==============================================================================================================================================================================================
function CheckReduxOption([string]$Name, [Object]$Expose, [Object]$Exclude, [byte]$Base=0, [boolean]$Child=$False, [boolean]$Adult=$False) {
    
    if ( (IsSet $Last.Extend) -and $Name -ne $null) {
        $section = $Last.Extend
        if (IsSet $Redux.$section.$Name) { return $False }
    }

    if ($Expose -is [Array]) {
        if ($Expose.count -gt 0) {
            foreach ($e in $Expose) {
                if ($GamePatch.title -like "*$e*")       { return $True }
            }
        }
    }
    elseif (IsSet $Expose) {
        if ($GamePatch.title -like "*$Expose*")          { return $True }
    }

    if ($Exclude -is [Array]) {
        if ($Exclude.count -gt 0) {
            foreach ($e in $Exclude) {
                if ($GamePatch.title -like "*$e*")       { return $False }
            }
        }
    }
    elseif (IsSet $Exclude) {
        if ($GamePatch.title -like "*$Exclude*")         { return $False }
    }

    if ($Expose -ne $null -and $Exclude -eq $null -and $Base -eq 0 -and !$Child -and !$Adult) { return $False }

    if (IsSet $GamePatch.age) {
        if ($Child -and !$Adult -and $GamePatch.age.toLower() -eq "adult")   { return $False }
        if ($Adult -and !$Child -and $GamePatch.age.toLower() -eq "child")   { return $False }
    }

    if ($Base -gt 0 -and $Base -lt $GamePatch.base) { return $False }
    return $True

}

#==============================================================================================================================================================================================
function ForceReduxOption([object]$Force, [int]$Value=0) {
    
    if ($Force -is [Array]) {
        if ($Force.count -gt 0) {
            foreach ($e in $Force) {
                if ($GamePatch.title -like "*$e*") {
                    $Redux[$Last.Extend][$Name] = $Value
                    return $True
                }
            }
        }
    }
    elseif (IsSet $Force) {
        if ($GamePatch.title -like "*$Force*") {
            $Redux[$Last.Extend][$Name] = $Value
            return $True
        }
    }

    return $False

}



#==============================================================================================================================================================================================

(Get-Command -Module "Forms") | % { Export-ModuleMember $_ }