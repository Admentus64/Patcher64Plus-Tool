function CreateForm([uint16]$X=0, [uint16]$Y=0, [uint16]$Width=0, [uint16]$Height=0, [string]$Name, [string]$Tag, [object]$Form, [boolean]$IsGame, [object]$AddTo) {
    
    $Form.Size = New-Object System.Drawing.Size($Width, $Height)
    $Form.Location = New-Object System.Drawing.Size($X, $Y)
    if ( ($Tag -ne "") -or ($Tag -ne $null) ) { $Form.Tag = $Tag }
    if (IsSet $AddTo) { $AddTo.Controls.Add($Form) }

    if (IsSet $Name) {
        $Form.Name = $Name
        if (IsSet $Last.Extend)   { Add-Member -InputObject $Form -NotePropertyMembers @{ Section = $Last.Extend } }
        elseif (!$IsGame)         { Add-Member -InputObject $Form -NotePropertyMembers @{ Section = "Core" } }
        if ($IsGame)              { $Redux[$Last.Extend][$Name] = $Form }
    }
    Add-Member -InputObject $Form -NotePropertyMembers @{ Active = $True }

    return $Form

}



#==============================================================================================================================================================================================
function CreateDialog([uint16]$Width=0, [uint16]$Height=0, [string]$Icon) {
    
    # Create the dialog that displays more info.
    $Dialog = New-Object System.Windows.Forms.Form
    $Dialog.Text = $ScriptName
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
function CreateColorDialog([string]$Color="000000", [string]$Name, [switch]$IsGame) {
    
    $ColorDialog = New-Object System.Windows.Forms.ColorDialog
    $ColorDialog.Color = "#" + $Color

    if ($IsGame -and (IsSet -Elem $Name) )   { $Redux[$Last.Extend][$Name] = $ColorDialog }
    if (IsSet $Name)                   { $ColorDialog.Tag = $Name }
    
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

    return $ColorDialog

}



#==============================================================================================================================================================================================
function CreateGroupBox([uint16]$X, [uint16]$Y, [uint16]$Width, [uint16]$Height, [string]$Name, [string]$Tag, [string]$Text, [object]$AddTo=$Last.Panel) {
    
    $Last.Group = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -Form (New-Object System.Windows.Forms.GroupBox) -AddTo $AddTo
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
function CreateTextBox([uint16]$X=0, [uint16]$Y=0, [uint16]$Width=0, [uint16]$Height=0, [byte]$Length=10, [string]$Name, [string]$Tag, [switch]$ReadOnly, [switch]$Multiline, [string]$Text="", [string]$Info, [switch]$IsGame, [switch]$TextFileFont, [object]$AddTo=$Last.Group) {
    
    $TextBox = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -IsGame $IsGame -Form (New-Object System.Windows.Forms.TextBox) -AddTo $AddTo
    $TextBox.Text = $Text
    if ($TextFileFont)   { $TextBox.Font = $Fonts.TextFile }
    else                 { $TextBox.Font = $Fonts.Small }
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
function CreateCheckBox([uint16]$X=0, [uint16]$Y=0, [string]$Name, [byte]$SaveAs=1, [string]$SaveTo, [byte]$Max=1, [string]$Tag, [boolean]$Checked=$False, [boolean]$Disable=$False, [boolean]$IsRadio=$False, [string]$Info="", [boolean]$IsGame=$False, [boolean]$IsDebug=$False, [object]$AddTo=$Last.Group) {
    
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
                if (IsSet -Elem $GameSettings[$CheckBox.Section][$CheckBox.SaveTo] -Max $Max -HasInt)   { $CheckBox.Checked = $GameSettings[$CheckBox.Section][$CheckBox.SaveTo] -eq $Checkbox.SaveAs }
                elseif ($Checked)                                                                       { $CheckBox.Checked = $True; $GameSettings[$CheckBox.Section][$CheckBox.SaveTo] = $CheckBox.SaveAs }
                $CheckBox.Add_CheckedChanged({ $GameSettings[$this.Section][$this.SaveTo] = $this.SaveAs })
            }
            else {
                if (IsSet $GameSettings[$CheckBox.Section][$CheckBox.Name])                             { $CheckBox.Checked = $GameSettings[$CheckBox.Section][$CheckBox.Name] -eq "True" }
                else                                                                                    { $CheckBox.Checked = $GameSettings[$CheckBox.Section][$CheckBox.Name] = $Checked  }
                $CheckBox.Add_CheckStateChanged({ $GameSettings[$this.Section][$this.Name] = $this.Checked })
            }
        }
        else {
            if ($IsDebug) { $CheckBox.Section = "Debug" }

            if ($IsRadio) {
                if (IsSet -Elem $Settings[$CheckBox.Section][$CheckBox.SaveTo] -Max $Max -HasInt)       { $CheckBox.Checked = $Settings[$CheckBox.Section][$CheckBox.SaveTo] -eq $Checkbox.SaveAs }
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

    Add-Member -InputObject $CheckBox -NotePropertyMembers @{ Default = $Checked }
    return $CheckBox

}



#==============================================================================================================================================================================================
function CreateLabel([uint16]$X=0, [uint16]$Y=0, [uint16]$Width=0, [uint16]$Height=0, [string]$Name, [string]$Tag, [string]$Text="", [System.Drawing.Font]$Font=$Fonts.Small, [string]$Info="", [object]$AddTo=$Last.Group) {
    
    $Label = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -Form (New-Object System.Windows.Forms.Label) -AddTo $AddTo
    if (IsSet $Text)      { $Label.Text = $Text }
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
function CreateTabButtons([string[]]$Tabs, [object]$AddTo=$Redux.Panel) {
    
    if ($Tabs.Count -eq 0) {
        if ( ($GamePatch.redux.options -eq 1 -or (IsSet $GamePatch.languages)) -and $Settings.Debug.LiteGUI -eq $False) {
            $Tabs += "Main"
            $Last.TabName = "Main"
        }
    }

    if ($GamePatch.redux.options -eq 1 -and $Settings.Debug.LiteGUI -eq $False)   { $Tabs += "Redux" }
    if ( (IsSet $GamePatch.languages) -and $Settings.Debug.LiteGUI -eq $False)    { $Tabs += "Language" }
    $global:ReduxTabs = @()
    if (!(IsSet $GameSettings.Core) -and $Tabs.Length -gt 0) { $GameSettings.Core  = @{} }

    # Create tabs
    for ($i=0; $i -lt $Tabs.Count; $i++) {
        $Button = CreateButton -X ((DPISize 15) + (($Redux.Panel.width - (DPISize 50))/$Tabs.length*$i)) -Y (DPISize 40) -Width (($Redux.Panel.width - (DPISize 50))/$Tabs.length) -Height (DPISize 30) -ForeColor "White" -BackColor "Gray" -Name $Tabs[$i] -Tag $i -Text $Tabs[$i] -AddTo $AddTo
        $Last.TabName = $Tabs[$i]
        $Button.Add_Click({
            foreach ($item in $ReduxTabs)      { $item.BackColor = "Gray" }
            foreach ($item in $Redux.Groups)   { $item.Visible = $item.Name -eq $this.Name }
            $GameSettings["Core"]["LastTab"] = $this.Tag
            $this.BackColor = "DarkGray"
        })
        $global:ReduxTabs += $Button
        if (Get-Command ("CreateTab" + $Tabs[$i]) -errorAction SilentlyContinue) { iex ("CreateTab" + $Tabs[$i]) }
    }

    # Restore last tab
    if ($Tabs.Count -gt 0) {
        if (IsSet -Elem $GameSettings["Core"]["LastTab"] -HasInt) {

            if ($ReduxTabs.Length -lt $GameSettings["Core"]["LastTab"]) {
                $ReduxTabs[0].BackColor = "DarkGray"
                foreach ($item in $Redux.Groups) { $item.Visible = $item.Name -eq $ReduxTabs[0].Name }
            }
            else {
                $ReduxTabs[$GameSettings["Core"]["LastTab"]].BackColor = "DarkGray"
                foreach ($item in $Redux.Groups) { $item.Visible = $item.Name -eq $ReduxTabs[$GameSettings["Core"]["LastTab"]].Name }
            }
        }
        else {
            foreach ($item in $Redux.Groups) { $item.Visible = $item.Name -eq $ReduxTabs[0].Name }
            $GameSettings["Core"]["LastTab"] = 0
            $ReduxTabs[0].BackColor = "DarkGray"
        }
    }
    else { $Last.TabName = "Main" }

}



#==============================================================================================================================================================================================
function CreateReduxPanel([single]$Row=0, [single]$Columns, [single]$Rows=1,  [string]$Name, [string]$Tag, [object]$AddTo=$Last.Group) {
    
    $Last.Max = 0
    if (IsSet $Columns -Min 0)   { $Width = (DPISize 150) * $Columns }
    else                         { $Width = $AddTo.Width - (DPISize 20) }
    return CreatePanel -X $AddTo.Left -Y ($Row * (DPISize 30) + (DPISize 20)) -Width $Width -Height ((DPISize 26.5) * $Rows) -Name $Name -Tag $Tag -AddTo $AddTo

}


#==============================================================================================================================================================================================
function CreateReduxGroup([single]$X=(DPISize 15), [single]$Y=(DPISize 50), [single]$Height=1, [string]$Name=$Last.TabName, [string]$Tag, [switch]$Hide, [boolean]$IsGame=$True, [string]$Text="", [switch]$IsRedux, [single]$Columns=0, [object]$AddTo=$Redux.Panel) {
    
    $Width = ($AddTo.Width - (DPISize 50))
    $Last.Column = 1;

    if (IsSet $Name) {
        if (!$Last.Half) {
            if ($Last.GroupName -eq $Name)     { $Y = $Last.Group.Bottom + 5}
            elseif ($ReduxTabs.length -gt 0)   { $Y = (DPISize 80) }
            else                               { $Y = (DPISize 40) }
        }
        if ($Last.Half) {
            $X = $Last.Group.Right + (DPISize 5)
            $Y = $Last.Group.Top
            $Width = $AddTo.Width - $Last.Group.Right - (DPISize 40)
            $Height = $Last.Group.Rows
            $Last.Half = $False
        }
        if ($Columns -gt 0) {
            $Width = (DPISize 165) * $Columns
            $Last.Half = $True
        }
    }

    $Group = CreateGroupBox -X $X -Y $Y -Width $Width -Height ($Height * (DPISize 30) + (DPISize 20)) -Name $Name -Tag $Tag -Text $Text -AddTo $AddTo
    if ( (IsSet $Name) -and ($Name -ne "Main") )     { $Group.Visible = $False }
    if (IsSet $Tag)                                  { $Group.Tag = $Tag }
    if ( (IsSet $Tag) -and !(IsSet $Redux[$Tag]) )   { $Redux[$Tag] = @{} }
    if (IsSet $Tag)                                  { $Last.Extend = $Tag }
    else                                             { $Last.Extend = $null }
    Add-Member -InputObject $Group -NotePropertyMembers @{
        IsRedux = $IsRedux -or $Name -eq "Redux"
        IsLanguage = $False
        Rows = $Height
    }

    if ($IsGame) {
        $Redux.Groups += $Group
        if (!(IsSet $GameSettings[$Tag])) { $GameSettings[$Tag] = @{} }
    }
    return $Group

}



#==============================================================================================================================================================================================
function CreateReduxButton([single]$Column=1, [single]$Row=1, [int16]$Width=150, [int16]$Height=20, [string]$Name, [string]$Tag, [string]$Text="", [string]$Info="", [string]$Credits="", [object]$AddTo=$Last.Group) {
    
    if ( (IsSet $Info ) -and (IsSet $Credits) ) { $Info += ("`n`n- Credits: " + $Credits) }
    return CreateButton -X (($Column-1) * (DPISize 165) + (DPISize 15)) -Y ($Row * (DPISize 30) - (DPISize 13)) -Width (DPISize $Width) -Height (DPISize $Height) -Name $Name -Tag $Tag -Text $Text -Info $Info -AddTo $AddTo

}



#==============================================================================================================================================================================================
function CreateReduxTextBox([single]$Column=$Last.Column, [single]$Row=1, [byte]$Length=2, [string]$Value=0, [string]$Text, [string]$Info, [string]$Warning, [string]$Credits, [string]$Name, [string]$Tag, [object]$AddTo=$Last.Group) {
    
    if (IsSet $Warning) {
        if (IsSet $Info)   { $Info += ("`n[!] " + $Warning) }
        if (IsSet $Text)   { $Text += " [!]" }
    }
    if ( (IsSet $Info ) -and (IsSet $Credits) ) { $Info += ("`n`n- Credits: " + $Credits) }

    $Label = CreateLabel -X (($Column-1) * (DPISize 165) + (DPISize 15)) -Y ($Row * (DPISize 30) - (DPISize 10)) -Width (DPISize 100) -Height (DPISize 15) -Text $Text -Info $Info -AddTo $AddTo
    $TextBox = CreateTextBox -X $Label.Right -Y ($Label.Top - (DPISize 3)) -Width (DPISize 35) -Height (DPISize 15) -Length $Length -Text $Value -IsGame $True -Name $Name -Tag $Tag -Info $Info -AddTo $AddTo

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

    })

    $Last.Column++;
    return $TextBox

}



#==============================================================================================================================================================================================
function CreateReduxRadioButton([single]$Column=$Last.Column, [single]$Row=1, [switch]$Checked, [switch]$Disable, [string]$Text, [string]$Warning, [string]$Info, [string]$Credits, [string]$Name, [string]$SaveTo, [byte]$Max, [string]$Tag, [object]$AddTo=$Last.Panel) {
    
    if ($Disable) { $Disable = !$PatchReduxCheckBox.Checked }
    if (IsSet $Warning) {
        if (IsSet $Info)   { $Info += ("`n[!] " + $Warning) }
        if (IsSet $Text)   { $Text += " [!]" }
    }
    if ( (IsSet $Info ) -and (IsSet $Credits) ) { $Info += ("`n`n- Credits: " + $Credits) }
    $Last.Max++

    $Radio = CreateCheckBox -X (($Column-1) * (DPISize 165)) -Y (($Row-1) * (DPISize 30)) -Checked $Checked -Disable $Disable -IsRadio $True -Info $Info -IsGame $True -Name $Name -SaveAs $Last.Max -SaveTo $SaveTo -Max $Max -Tag $Tag -AddTo $AddTo
    
    if (IsSet $Text) {
        $Label = CreateLabel -X $Radio.Right -Y ($Radio.Top + (DPISize 3)) -Height (DPISize 15) -Text $Text -Info $Info -AddTo $AddTo
        Add-Member -InputObject $Label -NotePropertyMembers @{ CheckBox = $Radio }
        $Label.Add_Click({
            if ($this.CheckBox.Enabled) { $this.CheckBox.Checked = $True }
        })
    }

    $Last.Column++;
    return $Radio

}



#==============================================================================================================================================================================================
function CreateReduxCheckBox([single]$Column=$Last.Column, [single]$Row=1, [switch]$Checked, [switch]$Disable, [string]$Text="", [string]$Info, [string]$Warning, [string]$Credits, [string]$Name, [string]$Tag, [object]$AddTo=$Last.Group) {
    
    if ($Disable) { $Disable = !$PatchReduxCheckBox.Checked }
    if (IsSet $Warning) {
        if (IsSet $Info)   { $Info += ("`n[!] " + $Warning) }
        if (IsSet $Text)   { $Text += " [!]" }
    }
    if ( (IsSet $Info ) -and (IsSet $Credits) ) { $Info += ("`n`n- Credits: " + $Credits) }

    $CheckBox = CreateCheckBox -X (($Column-1) * (DPISize 165) + (DPISize 15)) -Y ($Row * (DPISize 30) - (DPISize 10)) -Checked $Checked -Disable $Disable -IsRadio $False -Info $Info -IsGame $True -Name $Name  -Tag $Tag -AddTo $AddTo
    
    if (IsSet $Text) {
        $Label = CreateLabel -X $CheckBox.Right -Y ($CheckBox.Top + (DPISize 3)) -Height (DPISize 15) -Text $Text -Info $Info -AddTo $AddTo
        Add-Member -InputObject $Label -NotePropertyMembers @{ CheckBox = $CheckBox }
        $Label.Add_Click({
            if ($this.CheckBox.Enabled) { $this.CheckBox.Checked = !$this.CheckBox.Checked }
        })
    }

    $Last.Column++;
    return $CheckBox

}



#==============================================================================================================================================================================================
function CreateReduxComboBox([single]$Column=$Last.Column, [single]$Row=1, [int16]$Length=160, [int]$Shift=0, [string[]]$Items, [byte]$Default=1, [string]$Text, [string]$Info, [string]$Warning, [string]$Credits, [string]$Name, [string]$Tag, [object]$AddTo=$Last.Group) {
    
    if (IsSet $Warning) {
        if (IsSet $Info)   { $Info += ("`n[!] " + $Warning) }
        if (IsSet $Text)   { $Text += " [!]" }
    }
    if ( (IsSet $Info ) -and (IsSet $Credits) ) { $Info += ("`n`n- Credits: " + $Credits) }
    if (IsSet $Text) {
        $Text += ":"
        $Width = (DPISize (80 + $Shift))
    }
    else               { $Width = 0 }
    if ($Items[($Default-1)] -ne "Default" -and $Default -ne 0) {
        $Items = $Items.Clone()
        $Items[($Default-1)] += " (default)"
    }

    $Label = CreateLabel -X (($Column-1) * (DPISize 165) + (DPISize 15)) -Y ($Row * (DPISize 30) - (DPISize 10)) -Width $Width -Height (DPISize 15) -Text $Text -Info $Info -AddTo $AddTo
    $ComboBox = CreateComboBox -X $Label.Right -Y ($Label.Top - (DPISize 3)) -Width (DPISize ($Length - $Shift)) -Height (DPISize 20) -Items $Items -Default $Default -Info $Info -IsGame $True -Name $Name -Tag $Tag -AddTo $AddTo

    $Last.Column++;
    return $ComboBox

}



#==============================================================================================================================================================================================
function CreateReduxColoredLabel([System.Windows.Forms.Button]$Link, [System.Drawing.Color]$Color, [string]$Name, [string]$Tag, [object]$AddTo=$Last.Group) {
    
    $Label = CreateLabel -X ($Link.Right + (DPISize 15)) -Y $Link.Top -Width (DPISize 40) -Height $Link.Height -Name $Name -Tag $Tag -AddTo $AddTo
    if (IsSet $Color) { $Label.BackColor = $Color }
    return $Label

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function CreateForm
Export-ModuleMember -Function CreateDialog
Export-ModuleMember -Function CreateColorDialog
Export-ModuleMember -Function CreateTextBox
Export-ModuleMember -Function CreateLabel
Export-ModuleMember -Function CreateGroupBox
Export-ModuleMember -Function CreatePanel
Export-ModuleMember -Function CreateButton
Export-ModuleMember -Function CreateCheckBox
Export-ModuleMember -Function CreateComboBox

Export-ModuleMember -Function CreateTabButton
Export-ModuleMember -Function CreateTabButtons

Export-ModuleMember -Function CreateReduxGroup
Export-ModuleMember -Function CreateReduxPanel
Export-ModuleMember -Function CreateReduxButton
Export-ModuleMember -Function CreateReduxTextBox
Export-ModuleMember -Function CreateReduxRadioButton
Export-ModuleMember -Function CreateReduxCheckBox
Export-ModuleMember -Function CreateReduxComboBox
Export-ModuleMember -Function CreateReduxColoredLabel