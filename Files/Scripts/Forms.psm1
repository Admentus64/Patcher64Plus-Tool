function CreateForm([uint16]$X=0, [uint16]$Y=0, [uint16]$Width=0, [uint16]$Height=0, [string]$Name, [string]$Tag, [object]$Form, [boolean]$IsGame, [object]$AddTo) {
    
    $Form.Size = New-Object System.Drawing.Size($Width, $Height)
    $Form.Location = New-Object System.Drawing.Size($X, $Y)
    if ( ($Tag -ne "") -or ($Tag -ne $null) ) { $Form.Tag = $Tag }
    if (IsSet $AddTo) { $AddTo.Controls.Add($Form) }

    if (IsSet $Name) {
        $Form.Name = $Name
        if     (IsSet $Last.Extend)   { Add-Member -InputObject $Form -NotePropertyMembers @{ Section = $Last.Extend } }
        elseif (!$IsGame)             { Add-Member -InputObject $Form -NotePropertyMembers @{ Section = "Core"       } }
        if     ( $IsGame) {
            $Redux[$Last.Extend][$Name] = $Form
            if (-not ($Redux.Sections -contains $Last.Extend) ) { $Redux.Sections += $Last.Extend }
        }
    }
    Add-Member -InputObject $Form -NotePropertyMembers @{ Active = $True }

    return $Form

}



#==============================================================================================================================================================================================
function CreateDialog([uint16]$Width=0, [uint16]$Height=0, [string]$Icon) {
    
    # Create the dialog that displays more info.
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
    if (IsSet $Icon) { $Dialog.Icon = $Icon }
    return $Dialog

}



#==============================================================================================================================================================================================
function CreateColorDialog([string]$Color="000000", [string]$Name, [switch]$IsGame, [object]$Button) {
    
    $ColorDialog = New-Object System.Windows.Forms.ColorDialog
    $ColorDialog.Color = "#" + $Color

    if ($IsGame -and (IsSet -Elem $Name) )   { $Redux[$Last.Extend][$Name] = $ColorDialog }
    if (IsSet $Name)                         { $ColorDialog.Tag = $Name }
    
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

    Add-Member -InputObject $ColorDialog -NotePropertyMembers @{ Default = $Color }
    Add-Member -InputObject $ColorDialog -NotePropertyMembers @{ Button  = $Button }
    return $ColorDialog

}



#==============================================================================================================================================================================================
function CreateGroupBox([uint16]$X, [uint16]$Y, [uint16]$Width, [uint16]$Height, [string]$Name, [string]$Tag, [string]$Text, [object]$AddTo=$Last.Panel) {
    
    $Last.Group = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -Form (New-Object System.Windows.Forms.GroupBox) -AddTo $AddTo
    $Last.Hide  = $False
    $Last.Group.Font = $Fonts.Small
    if (IsSet $Text) { $Last.Group.Text = (" " + $Text + " ") }
    $Last.GroupName = $Name
    return $Last.Group

}



#==============================================================================================================================================================================================
function CreatePanel([uint16]$X, [uint16]$Y, [uint16]$Width, [uint16]$Height, [string]$Name, [string]$Tag, [boolean]$Hide, [object]$AddTo=$MainDialog) {
    
    $Last.Panel = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -Form (New-Object System.Windows.Forms.Panel) -AddTo $AddTo
    if ($Hide) { $Last.Panel.Hide() }
    return $Last.Panel

}



#==============================================================================================================================================================================================
function CreateTextBox([uint16]$X=0, [uint16]$Y=0, [uint16]$Width=0, [uint16]$Height=0, [uint16]$Length=10, [string]$Name, [string]$Tag, [switch]$ReadOnly, [switch]$Multiline, [string]$Text="", [string]$Info, [switch]$IsGame, [switch]$TextFileFont, [object]$AddTo=$Last.Group) {
    
    $TextBox = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -IsGame $IsGame -Form (New-Object System.Windows.Forms.TextBox) -AddTo $AddTo
    $TextBox.Text = $Text
    if ($TextFileFont)   { $TextBox.Font = $Fonts.TextFile }
    else                 { $TextBox.Font = $Fonts.Small    }
    $TextBox.MaxLength = $Length

    if ($ReadOnly) {
        $TextBox.ReadOnly = $True
        $TextBox.Cursor = 'Default'
        $TextBox.ShortcutsEnabled = $False
        $TextBox.BackColor = "White"
        $TextBox.Add_Click({ $this.SelectionLength = 0 })
    }

    if ($Multiline) {
        $TextBox.Multiline = $True
        $TextBox.Scrollbars = 'Vertical'
        $TextBox.WordWrap = $False
        $TextBox.TabStop = $False
    }

    if (IsSet $TextBox.Name) {
        if ($IsGame) {
            if (IsSet $GameSettings[$TextBox.Section][$TextBox.Name])   { $TextBox.Text = $GameSettings[$TextBox.Section][$TextBox.Name] }
            else                                                        { $GameSettings[$TextBox.Section][$TextBox.Name] = $TextBox.Text }
            $TextBox.Add_TextChanged({ $GameSettings[$this.Section][$this.Name] = $this.Text })
        }
        else {
            if (IsSet $Settings["Core"][$TextBox.Name])   { $TextBox.Text = $Settings["Core"][$TextBox.Name] }
            else                                          { $Settings["Core"][$TextBox.Name] = $TextBox.Text }
            $TextBox.Add_TextChanged({ $Settings["Core"][$this.Name] = $this.Text })
        }
    }
    
    Add-Member -InputObject $TextBox -NotePropertyMembers @{ Default = $Text }
    $ToolTip = CreateToolTip -Form $TextBox -Info $Info
    return $TextBox

}



#==============================================================================================================================================================================================
function CreateCheckBox([uint16]$X=0, [uint16]$Y=0, [string]$Name, [byte]$SaveAs=1, [string]$SaveTo, [byte]$Max=1, [string]$Tag, [boolean]$Checked=$False, [boolean]$Disable=$False, [switch]$IsRadio, [string]$Info="", [boolean]$IsGame=$False, [boolean]$IsDebug=$False, [object]$AddTo=$Last.Group, [object]$Link) {
    
    if ($IsRadio) {
        $CheckBox = CreateForm -X $X -Y $Y -Width (DPISize 20) -Height (DPISize 20) -Name $Name -Tag $Tag -IsGame $IsGame -Form (New-Object System.Windows.Forms.RadioButton) -AddTo $AddTo
        Add-Member -InputObject $CheckBox -NotePropertyMembers @{ SaveAs = $SaveAs; SaveTo = $SaveTo }
    }
    else { $CheckBox = CreateForm -X $X -Y $Y -Width (DPISize 20) -Height (DPISize 20) -Name $Name -Tag $Tag -IsGame $IsGame -Form (New-Object System.Windows.Forms.CheckBox) -AddTo $AddTo }
    $ToolTip = CreateToolTip -Form $CheckBox -Info $Info
    $CheckBox.Enabled = !$Disable

    if (IsSet $CheckBox.Name) {
        if ($IsGame) {
            if ($IsRadio) {
                if (IsSet -Elem $GameSettings[$CheckBox.Section][$CheckBox.SaveTo] -Max $Max -HasInt)   { $CheckBox.Checked = $GameSettings[$CheckBox.Section][$CheckBox.SaveTo] -eq $Checkbox.SaveAs      }
                elseif ($Checked)                                                                       { $CheckBox.Checked = $True; $GameSettings[$CheckBox.Section][$CheckBox.SaveTo] = $CheckBox.SaveAs }
                $CheckBox.Add_CheckedChanged({ $GameSettings[$this.Section][$this.SaveTo] = $this.SaveAs })
            }
            else {
                if (IsSet $GameSettings[$CheckBox.Section][$CheckBox.Name])                             { $CheckBox.Checked = $GameSettings[$CheckBox.Section][$CheckBox.Name] -eq "True"  }
                else                                                                                    { $CheckBox.Checked = $GameSettings[$CheckBox.Section][$CheckBox.Name] = $Checked  }
                $CheckBox.Add_CheckStateChanged({ $GameSettings[$this.Section][$this.Name] = $this.Checked })
            }
        }
        else {
            if ($IsDebug) { $CheckBox.Section = "Debug" } else { $Checkbox.Section = "Core" }
            if ($IsRadio) {
                if (IsSet -Elem $Settings[$CheckBox.Section][$CheckBox.SaveTo] -Max $Max -HasInt)       { $CheckBox.Checked = $Settings[$CheckBox.Section][$CheckBox.SaveTo] -eq $Checkbox.SaveAs      }
                elseif ($Checked)                                                                       { $CheckBox.Checked = $True; $Settings[$CheckBox.Section][$CheckBox.SaveTo] = $CheckBox.SaveAs }
                $CheckBox.Add_CheckedChanged({ $Settings[$this.Section][$this.SaveTo] = $this.SaveAs })
            }
            else {
                if (IsSet $Settings[$CheckBox.Section][$CheckBox.Name])                                 { $CheckBox.Checked = $Settings[$CheckBox.Section][$CheckBox.Name] -eq "True" }
                else                                                                                    { $CheckBox.Checked = $Settings[$CheckBox.Section][$CheckBox.Name] = $Checked }
                $CheckBox.Add_CheckStateChanged({ $Settings[$this.Section][$this.Name] = $this.Checked })
            }
        }
    }
    else { $CheckBox.Checked = $Checked }

    if (IsSet $Link) {
        Add-Member -InputObject $Checkbox -NotePropertyMembers @{ Link = $Link }
        Add-Member -InputObject $Link     -NotePropertyMembers @{ Link = $Checkbox }

        if ($Checkbox.GetType().Name -eq "Checkbox")   { $Checkbox.Add_CheckStateChanged( { EnableElem -Elem $this.link -Active (!$this.Checked) }) }
        else                                           { $Checkbox.Add_CheckedChanged(    { EnableElem -Elem $this.link -Active (!$this.Checked) }) }
        if ($Link.GetType().Name -eq "Checkbox")       { $Link.Add_CheckStateChanged(     { EnableElem -Elem $this.link -Active (!$this.Checked) }) }
        else                                           { $Link.Add_CheckedChanged(        { EnableElem -Elem $this.link -Active (!$this.Checked) }) }
        EnableElem -Elem $Checkbox -Active (!$Checkbox.link.Checked)
        EnableElem -Elem $Link     -Active (!$Link.link.Checked)
        if ($Checkbox.Enabled -eq $False)   { $Checkbox.Checked = $False }
        if ($Link.Enabled     -eq $False)   { $Link.Checked     = $False }
    }

    Add-Member -InputObject $CheckBox -NotePropertyMembers @{ Default = $Checked }
    return $CheckBox

}



#==============================================================================================================================================================================================
function CreateComboBox([uint16]$X=0, [uint16]$Y=0, [uint16]$Width=0, [uint16]$Height=0, [string]$Name, [string]$Tag, [string[]]$Items, [byte]$Default=1, [string]$Info, [switch]$IsGame, [object]$AddTo=$Last.Group) {
    
    $ComboBox = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -IsGame $IsGame -Form (New-Object System.Windows.Forms.ComboBox) -AddTo $AddTo
    $ComboBox.DropDownStyle = "DropDownList"
    $ComboBox.Font = $Fonts.Small
    $ToolTip = CreateToolTip -Form $ComboBox -Info $Info
    if ($Default -lt 1) { $Default = 1 }
    
    if (IsSet -Elem $Items) {
        $ComboBox.Items.AddRange($Items)
        if (IsSet $ComboBox.Name) {
            if ($IsGame) {
                if (IsSet $GameSettings[$ComboBox.Section][$ComboBox.Name] -Max $ComboBox.Items.Count -HasInt)   { $ComboBox.SelectedIndex = ($GameSettings[$ComboBox.Section][$ComboBox.Name]-1) }
                else                                                                                             { $GameSettings[$ComboBox.Section][$ComboBox.Name] = $Default }
                $ComboBox.Add_SelectedIndexChanged({ $GameSettings[$this.Section][$this.Name] = ($this.SelectedIndex+1) })
            }
            else {
                if (IsSet $Settings["Core"][$ComboBox.Name] -Max $ComboBox.Items.Count -HasInt)                  { $ComboBox.SelectedIndex = ($Settings[$ComboBox.Section][$ComboBox.Name]-1) }
                else                                                                                             { $Settings["Core"][$ComboBox.Name] = $Default }
                $ComboBox.Add_SelectedIndexChanged({ $Settings["Core"][$this.Name] = ($this.SelectedIndex+1) })
            }
        }
        if ($ComboBox.SelectedIndex -lt 0) { $ComboBox.SelectedIndex = ($Default-1) }
    }

    Add-Member -InputObject $ComboBox -NotePropertyMembers @{ Default = ($Default-1) }
    return $ComboBox

}



#==============================================================================================================================================================================================
function CreateSlider([uint16]$X=0, [uint16]$Y=0, [uint16]$Width=0, [uint16]$Height=0, [uint16]$Default=0, [uint16]$Min=0, [uint16]$Max=255, [uint16]$Freq=5, [uint16]$Small=2, [uint16]$Large=3, [string]$Name, [string]$Tag, [string]$Info, [switch]$IsGame, [object]$AddTo=$Last.Group) {
    
    $Slider = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -IsGame $IsGame -Form (New-Object System.Windows.Forms.TrackBar) -AddTo $AddTo
    $ToolTip = CreateToolTip -Form $Slider -Info $Info

    $Slider.Minimum       = $Min
    $Slider.Maximum       = $Max
    $Slider.TickFrequency = $Freq
    $Slider.SmallChange   = $Small
    $Slider.LargeChange   = $Large

    if (IsSet $Slider.Name) {
        if ($IsGame) {
            if (!(IsSet $GameSettings[$Slider.Section][$Slider.Name] -Min $Min -Max $Max -HasInt)) { $GameSettings[$Slider.Section][$Slider.Name] = $Default }
            $Slider.Add_ValueChanged({ $GameSettings[$this.Section][$this.Name] = $this.value })
            $Slider.value = $GameSettings[$Slider.Section][$Slider.Name]
        }
        else {
            if (!(IsSet $Settings["Core"][$Slider.Name] -Min $Min -Max $Max -HasInt)) { $Settings["Core"][$Slider.Name] = $Minimum }
            $Slider.Add_ValueChanged({ $Settings["Core"][$this.Name] = $this.value })
            $Slider.value = $Settings[$Slider.Section][$Slider.Name]
        }
    }

    Add-Member -InputObject $Slider -NotePropertyMembers @{ Default = $Default }
    $Slider.Add_MouseClick({
        if ($_.Button -eq "Right") { $this.value = $this.Default }
    })

    return $Slider

}



#==============================================================================================================================================================================================
function CreateListBox([uint16]$X=0, [uint16]$Y=0, [uint16]$Width=0, [uint16]$Height=0, [string[]]$Items, [boolean]$MultiSelect=$False, [string]$Name, [string]$Tag, [string]$Info, [switch]$IsGame, [object]$AddTo=$Last.Group) {

    $listBox = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -IsGame $IsGame -Form (New-Object System.Windows.Forms.Listbox) -AddTo $AddTo
    if ($MultiSelect) { $listBox.SelectionMode = 'MultiSimple' }

    if ($items.count -gt 0) { $listBox.Items.AddRange($items) }

    if (IsSet $listBox.Name) {
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
    
    $Label = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -Form (New-Object System.Windows.Forms.Label) -AddTo $AddTo
    if (  IsSet $Text)    { $Label.Text     = $Text }
    if (!(IsSet $Width))  { $Label.AutoSize = $True }
    $Label.Font = $Font
    $ToolTip = CreateToolTip -Form $Label -Info $Info
    return $Label

}



#==============================================================================================================================================================================================
function CreateButton([uint16]$X=0, [uint16]$Y=0, [uint16]$Width=(DPISize 100), [uint16]$Height=(DPISize 20), [string]$Name, [string]$Tag, [string]$ForeColor, [string]$BackColor, [string]$Text="", [System.Drawing.Font]$Font=$Fonts.Small, [string]$Info="", [object]$AddTo=$Last.Group) {
    
    $Button = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -Form (New-Object System.Windows.Forms.Button) -AddTo $AddTo
    if (IsSet $Text)        { $Button.Text = $Text }
    $Button.Font = $Font
    if (IsSet $ForeColor)   { $Button.ForeColor = $ForeColor }
    if (IsSet $BackColor)   { $Button.BackColor = $BackColor }
    if (IsSet $Info)        { $ToolTip = CreateToolTip -Form $Button -Info $Info }
    return $Button

}



#==============================================================================================================================================================================================
function CreateTabButtons([string[]]$Tabs, [boolean]$NoLanguages=$False) {
    
    if ($Tabs.Count -eq 0) {
        if ( (($GamePatch.redux.options -eq 1 -and $GameRev.redux -ne 0) -or ((IsSet $Files.json.languages) -and $GameRev.languages -ne 0)) ) {
            $Tabs += "Main"
            $Last.TabName = "Main"
        }
    }

    if ($GamePatch.redux.options -eq 1 -and $GameRev.redux     -ne 0)                      { $Tabs += "Redux" }
    if ( (IsSet $Files.json.languages) -and $GameRev.languages -ne 0 -and !$NoLanguages)   { $Tabs += "Language" }
    $global:ReduxTabs = @()
    if (!(IsSet $GameSettings.Core) -and $Tabs.Length -gt 0) { $GameSettings.Core  = @{} }

    # Create tabs
    for ($i=0; $i -lt $Tabs.Count; $i++) {
        $Button = CreateButton -X ((DPISize 15) + (($OptionsDialog.width - (DPISize 50))/$Tabs.length*$i)) -Y (DPISize 40) -Width (($OptionsDialog.width - (DPISize 50))/$Tabs.length) -Height (DPISize 30) -ForeColor "White" -BackColor "Gray" -Name $Tabs[$i] -Tag $i -Text $Tabs[$i] -AddTo $OptionsDialog
        $Last.TabName = $Tabs[$i]
        $Button.Add_Click({
            $Redux.Panel.AutoScrollPosition = 0
            foreach ($item in $ReduxTabs)      { $item.BackColor = "Gray" }
            foreach ($item in $Redux.Groups)   { if (!$item.ShowAlways) { $item.Visible = $item.Name -eq $this.Name } }
            $GameSettings["Core"]["LastTab"] = $this.Tag
            $this.BackColor = "DarkGray"
        })
        $global:ReduxTabs += $Button
        while ($Tabs[$i].Contains(' ')) { $Tabs[$i] = $Tabs[$i].Replace(' ', '') }
        while ($Tabs[$i].Contains('-')) { $Tabs[$i] = $Tabs[$i].Replace('-', '') }
        if (Get-Command ("CreateTab" + $Tabs[$i]) -errorAction SilentlyContinue) {
            $Last.Half = $False
            iex ("CreateTab" + $Tabs[$i])
        }
    }

    # Restore last tab
    if ($Tabs.Count -gt 0) {
        if (IsSet -Elem $GameSettings["Core"]["LastTab"] -HasInt) {
            if ($ReduxTabs.Length -lt $GameSettings["Core"]["LastTab"]) {
                $ReduxTabs[0].BackColor = "DarkGray"
                foreach ($item in $Redux.Groups) { if (!$item.ShowAlways) { $item.Visible = $item.Name -eq $ReduxTabs[0].Name } }
            }
            else {
                $ReduxTabs[$GameSettings["Core"]["LastTab"]].BackColor = "DarkGray"
                foreach ($item in $Redux.Groups) { if (!$item.ShowAlways) { $item.Visible = $item.Name -eq $ReduxTabs[$GameSettings["Core"]["LastTab"]].Name } }
            }
        }
        else {
            foreach ($item in $Redux.Groups) { if (!$item.ShowAlways) { $item.Visible = $item.Name -eq $ReduxTabs[0].Name } }
            $GameSettings["Core"]["LastTab"] = 0
            $ReduxTabs[0].BackColor = "DarkGray"
        }
    }
    else { $Last.TabName = "Main" }

    return $Tabs

}



#==============================================================================================================================================================================================
function CreateReduxPanel([single]$X=$Last.Group.Left, [single]$Row=0, [single]$Columns, [single]$Rows=1,  [string]$Name, [string]$Tag, [object]$AddTo=$Last.Group, [switch]$Native, [Object]$Expose=@($GameType.mode), [Object]$Exclude, [switch]$Base, [switch]$Alt, [switch]$Child, [switch]$Adult, [switch]$All) {
    
    if (!(CheckReduxOption -Expose $Expose -Exclude $Exclude -Base $Base -Alt $Alt -Child $Child -Adult $Adult -All $All) -or $Last.Hide) { return $null }

    $Last.Max = 0
    $Last.Column = $Last.Row = 1
    if (IsSet $Columns -Min 0)   { $Width = $FormDistance * $Columns }
    else                         { $Width = $AddTo.Width * 0.9 }
    return CreatePanel -X $X -Y ($Row * (DPISize 30) + (DPISize 20)) -Width $Width -Height ((DPISize 26.5) * $Rows) -Name $Name -Tag $Tag -AddTo $AddTo

}



#==============================================================================================================================================================================================
function CreateReduxGroup([single]$X=(DPISize 15), [single]$Y=(DPISize 0), [single]$Height, [string]$Name=$Last.TabName, [string]$Tag, [switch]$ShowAlways, [boolean]$IsGame=$True, [string]$Text="", [switch]$IsRedux, [single]$Columns=0, [object]$AddTo=$Redux.Panel, [switch]$Native, [Object]$Expose=@($GameType.mode), [Object]$Exclude, [switch]$Base, [switch]$Alt, [switch]$Child, [switch]$Adult, [switch]$All) {
    
    if (!(CheckReduxOption -Expose $Expose -Exclude $Exclude -Base $Base -Alt $Alt -Child $Child -Adult $Adult -All $All)) {
        $Last.Hide = $True
        return $null
    }

    $Width = ($AddTo.Width - (DPISize 50))
    $Last.Column = $Last.Row = 1

    if ($Columns -eq 0)   { $Last.Width = [byte][Math]::Round($Redux.Panel.Width / $ColumnWidth) }
    else                  { $Last.Width = [byte]$Columns }
    
    if (IsSet $Height) { $Last.Flexible = $False }
    else {
        $Last.Flexible = $True
        $Height = 1
    }

    if (IsSet $Name) {
        if (!$Last.Half) {
            if ($Last.GroupName -eq $Name)     { $Y = $Last.Group.Bottom + 5}
            elseif ($ReduxTabs.length -gt 0)   { $Y = (DPISize 0)  }
            else                               { $Y = (DPISize 40) }
        }
        if ($Last.Half) {
            $X = $Last.Group.Right + (DPISize 5)
            $Y = $Last.Group.Top
            $Width = $AddTo.Width - $Last.Group.Right - (DPISize 40)
            $Height = $Last.Group.Rows
            $Last.Half = $False
            $Last.Flexible = $False
        }
        if ($Columns -gt 0) {
            $Width = $FormDistance * $Columns
            $Last.Half = $True
        }
    }

    $Group = CreateGroupBox -X $X -Y $Y -Width $Width -Height ($Height * (DPISize 30) + (DPISize 20)) -Name $Name -Tag $Tag -Text $Text -AddTo $AddTo
    if ( (IsSet $Name) -and ($Name -ne "Main") -and !$ShowAlways )   { $Group.Visible = $False }
    if (IsSet $Tag)                                                  { $Group.Tag = $Tag }
    if ( (IsSet $Tag) -and !(IsSet $Redux[$Tag]) )                   { $Redux[$Tag] = @{} }
    if (IsSet $Tag)                                                  { $Last.Extend = $Tag }
    else                                                             { $Last.Extend = $null }
    Add-Member -InputObject $Group -NotePropertyMembers @{
        IsRedux = $IsRedux -or $Name -eq "Redux"
        IsLanguage = $False
        Rows = $Height
        ShowAlways = $ShowAlways
    }

    if ($IsGame) {
        $Redux.Groups += $Group
        if (!(IsSet $GameSettings[$Tag])) { $GameSettings[$Tag] = @{} }
    }

    return $Group

}



#==============================================================================================================================================================================================
function CreateReduxButton([single]$Column=$Last.Column, [single]$Row=$Last.Row, [int16]$Width=150, [int16]$Height=20, [string]$Name, [string]$Tag, [string]$Text="", [string]$Info="", [string]$Credits="", [object]$AddTo=$Last.Group, [switch]$Native, [Object]$Expose=@($GameType.mode), [Object]$Exclude, [switch]$Base, [switch]$Alt, [switch]$Child, [switch]$Adult, [switch]$All) {
    
    if (!(CheckReduxOption -Expose $Expose -Exclude $Exclude -Base $Base -Alt $Alt -Child $Child -Adult $Adult -All $All) -or ($Native -and $IsWiiVC) -or $Last.Hide) { return $null }

    if ( (IsSet $Info ) -and (IsSet $Credits) ) { $Info += ("`n`n- Credits: " + $Credits) }
    return CreateButton -X (($Column-1) * $FormDistance + (DPISize 15)) -Y ($Row * (DPISize 30) - (DPISize 13)) -Width (DPISize $Width) -Height (DPISize $Height) -Name $Name -Tag $Tag -Text $Text -Info $Info -AddTo $AddTo

    $Last.Column = $column + 1;
    $Last.Row = $row;
    if ($Column -ge $Last.Width) {
        $Last.Column = 1
        $Last.Row++
    }
    if ($Last.Flexible) { $Last.Group.Height = ($Row * (DPISize 30) + (DPISize 20)) }

}



#==============================================================================================================================================================================================
function CreateReduxTextBox([single]$Column=$Last.Column, [single]$Row=$Last.Row, [byte]$Length=2, [int]$Width=35, [string]$Value=0, [switch]$ASCII, [int]$Min, [int]$Max, [string]$Text, [string]$Info, [string]$Warning, [string]$Credits, [string]$Name, [string]$Tag, [object]$AddTo=$Last.Group, [switch]$Native, [Object]$Expose=@($GameType.mode), [Object]$Exclude, [switch]$Base, [switch]$Alt, [switch]$Child, [switch]$Adult, [switch]$All) {
    
    if (!(CheckReduxOption -Expose $Expose -Exclude $Exclude -Base $Base -Alt $Alt -Child $Child -Adult $Adult -All $All) -or ($Native -and $IsWiiVC) -or $Last.Hide) { return $null }

    if (IsSet $Info) { $Info += "`nDefault value: " + $Value }
    if (IsSet $Warning) {
        if (IsSet $Info)   { $Info += ("`n[!] " + $Warning) }
        if (IsSet $Text)   { $Text += " [!]" }
    }
    if ( (IsSet $Info ) -and (IsSet $Credits) ) { $Info += ("`n`n- Credits: " + $Credits) }

    if (IsSet $Text) { $Text += ":" }

    $Label   = CreateLabel   -X (($Column-1) * $FormDistance + (DPISize 15)) -Y ($Row * (DPISize 30) - (DPISize 10)) -Width (DPISize 100) -Height (DPISize 15) -Text $Text -Info $Info -AddTo $AddTo
    $TextBox = CreateTextBox -X $Label.Right -Y ($Label.Top - (DPISize 3)) -Width (DPISize $Width) -Height (DPISize 15) -Length $Length -Text $Value -IsGame $True -Name $Name -Tag $Tag -Info $Info -AddTo $AddTo

    if (!$ASCII) {
        $TextBox.Add_TextChanged({
            if ($this.Text -cmatch "[^0-9]") {
                $this.Text = $this.Text.ToUpper() -replace "[^0-9]",''
                $this.Select($this.Text.Length, $this.Text.Length)
            }
            if ($this.Text -cmatch " ") {
                $this.Text = $this.Text.ToUpper() -replace " ",''
                $this.Select($this.Text.Length, $this.Text.Length)
            }

            if ($this.Text -eq "") { $this.Text = 0 }

            if (IsSet $this.Min) { if ([int]$this.Text -lt $this.Min) { $this.Text = $this.Min } }
            if (IsSet $this.Max) { if ([int]$this.Text -gt $this.Max) { $this.Text = $this.Max } }
        })

        if (IsSet $Min) {
            if ([int]$TextBox.Text -lt $Min) { $TextBox.Text = $Min }
            Add-Member -InputObject $TextBox -NotePropertyMembers @{ Min = $Min }
        }
        if (IsSet $Max) {
            if ([int]$TextBox.Text -gt $Max) { $TextBox.Text = $Max }
            Add-Member -InputObject $TextBox -NotePropertyMembers @{ Max = $Max }
        }
    }

    $Last.Column = $column + 1;
    $Last.Row = $row;
    if ($Column -ge $Last.Width) {
        $Last.Column = 1
        $Last.Row++
    }
    if ($Last.Flexible) { $Last.Group.Height = ($Row * (DPISize 30) + (DPISize 20)) }

    return $TextBox

}



#==============================================================================================================================================================================================
function CreateReduxRadioButton([single]$Column=$Last.Column, [single]$Row=$Last.Row, [switch]$Checked, [switch]$Disable, [string]$Text, [string]$Info, [string]$Warning, [string]$Credits, [string]$Name, [object]$Link, [string]$SaveTo, [byte]$Max, [string]$Tag, [object]$AddTo=$Last.Panel, [switch]$Native, [Object]$Expose=@($GameType.mode), [Object]$Exclude, [switch]$Base, [switch]$Alt, [switch]$Child, [switch]$Adult, [switch]$All) {
    
    if (!(CheckReduxOption -Expose $Expose -Exclude $Exclude -Base $Base -Alt $Alt -Child $Child -Adult $Adult -All $All) -or ($Native -and $IsWiiVC) -or $Last.Hide) { return $null }

    if (IsSet $Warning) {
        if (IsSet $Info)   { $Info += ("`n[!] " + $Warning) }
        if (IsSet $Text)   { $Text += " [!]" }
    }
    if ( (IsSet $Info ) -and (IsSet $Credits) ) { $Info += ("`n`n- Credits: " + $Credits) }
    $Last.Max++

    $Radio = CreateCheckBox -X (($Column-1) * $FormDistance) -Y (($Row-1) * (DPISize 30)) -Checked $Checked -Disable $Disable -IsRadio -Info $Info -IsGame $True -Name $Name -SaveAs $Last.Max -SaveTo $SaveTo -Max $Max -Tag $Tag -AddTo $AddTo -Link $Link
    
    if (IsSet $Text) {
        $Label = CreateLabel -X $Radio.Right -Y ($Radio.Top + (DPISize 3)) -Height (DPISize 15) -Text $Text -Info $Info -AddTo $AddTo
        Add-Member -InputObject $Label -NotePropertyMembers @{ CheckBox = $Radio }
        Add-Member -InputObject $Radio -NotePropertyMembers @{ Label    = $Text }
        $Label.Add_Click({
            if ($this.CheckBox.Enabled) { $this.CheckBox.Checked = $True }
        })
    }

    $Last.Column = $column + 1;
    $Last.Row = $row;
    if ($Column -ge $Last.Width) {
        $Last.Column = 1
        $Last.Row++
    }
    if ($Last.Flexible) { $Last.Group.Height = ($Row * (DPISize 30) + (DPISize 20)) }

    return $Radio

}



#==============================================================================================================================================================================================
function CreateReduxCheckBox([single]$Column=$Last.Column, [single]$Row=$Last.Row, [switch]$Checked, [switch]$Disable, [string]$Text="", [string]$Info, [string]$Warning, [string]$Credits, [string]$Name, [object]$Link, [string]$Tag, [object]$AddTo=$Last.Group, [switch]$Native, [Object]$Expose=@($GameType.mode), [Object]$Exclude, [switch]$Base, [switch]$Alt, [switch]$Child, [switch]$Adult, [switch]$All) {
    
    if (!(CheckReduxOption -Expose $Expose -Exclude $Exclude -Base $Base -Alt $Alt -Child $Child -Adult $Adult -All $All) -or ($Native -and $IsWiiVC) -or $Last.Hide) { return $null }

    if (IsSet $Warning) {
        if (IsSet $Info)   { $Info += ("`n[!] " + $Warning) }
        if (IsSet $Text)   { $Text += " [!]" }
    }
    if ( (IsSet $Info ) -and (IsSet $Credits) ) { $Info += ("`n`n- Credits: " + $Credits) }

    $CheckBox = CreateCheckBox -X (($Column-1) * $FormDistance + (DPISize 15)) -Y ($Row * (DPISize 30) - (DPISize 10)) -Checked $Checked -Disable $Disable -Info $Info -IsGame $True -Name $Name -Tag $Tag -AddTo $AddTo -Link $Link
    
    if (IsSet $Text) {
        $Label = CreateLabel -X $CheckBox.Right -Y ($CheckBox.Top + (DPISize 3)) -Height (DPISize 15) -Text $Text -Info $Info -AddTo $AddTo
        Add-Member -InputObject $Label    -NotePropertyMembers @{ CheckBox = $CheckBox }
        Add-Member -InputObject $CheckBox -NotePropertyMembers @{ Label    = $Text }
        $Label.Add_Click({
            if ($this.CheckBox.Enabled) { $this.CheckBox.Checked = !$this.CheckBox.Checked }
        })
    }

    $Last.Column = $column + 1;
    $Last.Row = $row;
    if ($Column -ge $Last.Width) {
        $Last.Column = 1
        $Last.Row++
    }
    if ($Last.Flexible) { $Last.Group.Height = ($Row * (DPISize 30) + (DPISize 20)) }

    return $CheckBox

}



#==============================================================================================================================================================================================
function CreateReduxComboBox([single]$Column=$Last.Column, [single]$Row=$Last.Row, [int16]$Length=170, [int]$Shift=0, [string[]]$Items=$null, [string[]]$Values=$null, [string[]]$PostItems=$null, [string]$FilePath, $Ext="bin", $Default=1, [switch]$NoDefault, [string]$Text, [string]$Info, [string]$Warning, [string]$Credits, [string]$Name, [string]$Tag, [object]$AddTo=$Last.Group, [switch]$Native, [Object]$Expose=@($GameType.mode), [Object]$Exclude, [switch]$Base, [switch]$Alt, [switch]$Child, [switch]$Adult, [switch]$All) {
    
    if (!(CheckReduxOption -Expose $Expose -Exclude $Exclude -Base $Base -Alt $Alt -Child $Child -Adult $Adult -All $All) -or ($Native -and $IsWiiVC) -or $Last.Hide) { return $null }

    if ($Column -eq $Last.Width -and $Column -eq $Last.Column -and $Row -eq $Last.Row) {
        $Column = 1
        $Row++;
    }

    if (IsSet $Warning) {
        if (IsSet $Info)   { $Info += ("`n[!] " + $Warning) }
        if (IsSet $Text)   { $Text += " [!]" }
    }
    if ( (IsSet $Info ) -and (IsSet $Credits) ) { $Info += ("`n`n- Credits: " + $Credits) }
    if (IsSet $Text) {
        $Text += ":"
        $Width = (DPISize (120 + $Shift))
    }
    else { $Width = 0 }

    if (IsSet $FilePath) {
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
        $Items = $Items | select -Unique
        if ($Default.GetType().Name -eq "String") {
            foreach ($i in 0..($Items.length-1)) { if ($Items[$i] -eq $Default) { $Default = ($i +1) } }
            if ($Default.GetType().Name -eq "String") { $Default = 0 }
        }
        if ($Items[($Default-1)] -ne "Default" -and $Default -gt 0 -and !$NoDefault) {
            $Items = $Items.Clone()
            $Items[($Default-1)] += " (default)"
        }
    }

    $Default  = [byte]$Default
    $Label    = CreateLabel    -X (($Column-1) * $FormDistance + (DPISize 15)) -Y ($Row * (DPISize 30) - (DPISize 7)) -Width $Width -Height (DPISize 15) -Text $Text -Info $Info -AddTo $AddTo
    $ComboBox = CreateComboBox -X $Label.Right -Y ($Label.Top - (DPISize 3)) -Width (DPISize ($Length - $Shift)) -Height (DPISize 20) -Items $Items -Default $Default -Info $Info -IsGame $True -Name $Name -Tag $Tag -AddTo $AddTo

    if (IsSet $Text) {
        Add-Member -InputObject $Label    -NotePropertyMembers @{ ComboBox = $ComboBox }
        Add-Member -InputObject $ComboBox -NotePropertyMembers @{ Label    = $Text }
    }
    if (IsSet $Values) {
        Add-Member -InputObject $ComboBox -NotePropertyMembers @{
            Values = $Values
            Value  = $Values[$ComboBox.selectedIndex]
        }
        $ComboBox.Add_SelectedIndexChanged({ $this.Value = $this.Values[$this.selectedIndex] })
    }

    $Last.Column = $column + 2;
    $Last.Row = $row;

    if ($Column -ge $Last.Width - 1) {
        $Last.Column = 1
        $Last.Row++
    }
    if ($Last.Flexible) { $Last.Group.Height = ($Row * (DPISize 30) + (DPISize 20)) }

    return $ComboBox

}



#==============================================================================================================================================================================================
function CreateReduxSlider([single]$Column=$Last.Column, [single]$Row=$Last.Row, $Default, $Min, $Max, $Freq, $Small, $Large, [string]$Text, [string]$Info, [string]$Warning, [string]$Credits, [string]$Name, [string]$Tag, [object]$AddTo=$Last.Group, [switch]$Native, [Object]$Expose=@($GameType.mode), [Object]$Exclude, [switch]$Base, [switch]$Alt, [switch]$Child, [switch]$Adult, [switch]$All) {
    
    if (!(CheckReduxOption -Expose $Expose -Exclude $Exclude -Base $Base -Alt $Alt -Child $Child -Adult $Adult -All $All) -or ($Native -and $IsWiiVC) -or $Last.Hide) { return $null }

    if ($Default.GetType().Name -eq "String")   { $Default = GetDecimal $Default }
    if ($Min.GetType().Name     -eq "String")   { $Min     = GetDecimal $Min }
    if ($Max.GetType().Name     -eq "String")   { $Max     = GetDecimal $Max }
    if ($Freq.GetType().Name    -eq "String")   { $Freq    = GetDecimal $Freq }
    if ($Small.GetType().Name   -eq "String")   { $Small   = GetDecimal $Small }
    if ($Large.GetType().Name   -eq "String")   { $Large   = GetDecimal $Large }

    $Info = "Right click to reset to default value`n`n" + $Info
    if ( (IsSet $Info ) -and (IsSet $Credits) ) { $Info += ("`n`n- Credits: " + $Credits) }
    if (IsSet $Text) { $Text += ":" }

    $Label  = CreateLabel  -X (($Column-1) * $FormDistance + (DPISize 15)) -Y ($Row * (DPISize 45) - (DPISize 25)) -Width (DPISize 105) -Height (DPISize 15) -Text $Text -Info $Info -AddTo $AddTo
    $Slider = CreateSlider -X $Label.Right -Y ($Label.Top - (DPISize 10)) -Width (DPISize 200) -Height (DPISize 10) -Default $Default -Min $Min -Max $Max -Freq $Freq -Small $Small -Large $Large -Info $Info -IsGame $True -Name $Name -Tag $Tag -AddTo $AddTo

    Add-Member -InputObject $Label -NotePropertyMembers @{ Slider = $Slider }
    $Label.Add_MouseClick({
        if ($_.Button -eq "Right") { $this.Slider.value = $this.Slider.Default }
    })

    return $Slider

}



#==============================================================================================================================================================================================
function CreateReduxListBox([single]$Column=$Last.Column, [single]$Row=$Last.Row, [string[]]$Items, $Default=$null, [switch]$MultiSelect, [string]$Text, [string]$Info, [string]$Warning, [string]$Credits, [string]$Name, [string]$Tag, [object]$AddTo=$Last.Group, [switch]$Native, [Object]$Expose=@($GameType.mode), [Object]$Exclude, [switch]$Base, [switch]$Alt, [switch]$Child, [switch]$Adult, [switch]$All) {
    
    if (!(CheckReduxOption -Expose $Expose -Exclude $Exclude -Base $Base -Alt $Alt -Child $Child -Adult $Adult -All $All) -or ($Native -and $IsWiiVC) -or $Last.Hide) { return $null }

    $listBox  = CreateListBox -X (($Column-1) * $FormDistance + (DPISize 15)) -Y ($Row * (DPISize 45) - (DPISize 25)) -Width (DPISize 300) -Height (DPISize 175) -Items $Items -Default $Default -MultiSelect $MultiSelect -Info $Info -IsGame $True -Name $Name -Tag $Tag -AddTo $AddTo
    return $listBox

}



#==============================================================================================================================================================================================
function CreateReduxColoredLabel([System.Windows.Forms.Button]$Link, [System.Drawing.Color]$Color, [string]$Name, [string]$Tag, [object]$AddTo=$Last.Group, [switch]$Native, [Object]$Expose=@($GameType.mode), [Object]$Exclude, [switch]$Base, [switch]$Alt, [switch]$Child, [switch]$Adult, [switch]$All) {
    
    if (!(CheckReduxOption -Expose $Expose -Exclude $Exclude -Base $Base -Alt $Alt -Child $Child -Adult $Adult -All $All) -or ($Native -and $IsWiiVC) -or $Last.Hide) { return $null }

    $label = CreateLabel -X ($Link.Right + (DPISize 15)) -Y $Link.Top -Width (DPISize 40) -Height $Link.Height -Name $Name -Tag $Tag -AddTo $AddTo
    if (IsSet $Color) { $label.BackColor = $Color }
    return $label

}



#==============================================================================================================================================================================================
function CreateImageBox([int]$x, [int]$y, [int]$w, [int]$h, [boolean]$IsGame=$True, [string]$Name, [string]$Tag, [object]$AddTo=$Last.Group, [switch]$Native, [Object]$Expose=@($GameType.mode), [Object]$Exclude, [switch]$Base, [switch]$Alt, [switch]$Child, [switch]$Adult, [switch]$All) {

    if (!(CheckReduxOption -Expose $Expose -Exclude $Exclude -Base $Base -Alt $Alt -Child $Child -Adult $Adult -All $All) -or ($Native -and $IsWiiVC) -or $Last.Hide) { return $null }

    $image          = CreateForm -X $X -Y $Y -Width $Width -Height $Height -IsGame $IsGame -Name $Name -Tag $Tag -Form (New-Object Windows.Forms.PictureBox) -AddTo $AddTo 
    $image.Location = (DPISize (New-object System.Drawing.Size($x, $y)))
    $image.Size     = (DPISize (New-object System.Drawing.Size($w, $h)))

    return $image

}



#==============================================================================================================================================================================================
function CheckReduxOption([Object]$Expose=@($GameType.mode), [Object]$Exclude, [boolean]$Base=$False, [boolean]$Alt=$False, [boolean]$Child=$False, [boolean]$Adult=$False, [boolean]$All=$True) {
    
    if ($Exclude -is [Array]) {
        if ($Exclude.count -gt 0) {
            foreach ($e in $Exclude) {
                if ($GamePatch.title -like "*$e*")   { return $False }
            }
        }
    }
    elseif (IsSet $Exclude) {
        if ($GamePatch.title -like "*$Exclude*")     { return $False }
    }

    if ($All) { return $True }

    if ($Child) {
        if (!(IsSet $GamePatch.age))                { return $True }
        if ($GamePatch.age.toLower() -eq "child")   { return $True }
    }

    if ($Adult) {
        if (!(IsSet $GamePatch.age))                { return $True }
        if ($GamePatch.age.toLower() -eq "adult")   { return $True }
    }
    
    if ($Base) {
        if ($GamePatch.options -eq 1) { return $True }
    }
    elseif ($Alt) {
        if ($GamePatch.options -eq 2) { return $True }
    }
    elseif ($Expose -is [Array]) {
        if ($Expose.count -gt 0) {
            foreach ($e in $Expose) {
                if ($GamePatch.title -like "*$e*")   { return $True }
            }
        }
    }
    elseif (IsSet $Expose) {
        if ($GamePatch.title -like "*$Expose*")      { return $True }
    }

    return $False

}



#==============================================================================================================================================================================================

(Get-Command -Module "Forms") | % { Export-ModuleMember $_ }