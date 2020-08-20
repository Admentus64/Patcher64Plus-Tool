function CreateForm([int]$X=0, [int]$Y=0, [int]$Width=0, [int]$Height=0, [String]$Name, [Object]$Object, [Object]$AddTo) {
    
    $Form = $Object
    $Form.Size = New-Object System.Drawing.Size($Width, $Height)
    $Form.Location = New-Object System.Drawing.Size($X, $Y)
    if ($Name -ne $null) { $Form.Name = $Name }
    $AddTo.Controls.Add($Form)
    return $Form

}



#==============================================================================================================================================================================================
function CreateDialog([int]$Width=0, [int]$Height=0, [Object]$Icon) {
    
    # Create the dialog that displays more info.
    $Dialog = New-Object System.Windows.Forms.Form
    $Dialog.Text = $ScriptName
    $Dialog.Size = New-Object System.Drawing.Size($Width, $Height)
    $Dialog.MaximumSize = $Dialog.Size
    $Dialog.MinimumSize = $Dialog.Size
    $Dialog.MaximizeBox = $True
    $Dialog.MinimizeBox = $True
    $Dialog.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Inherit
    $Dialog.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $Dialog.StartPosition = "CenterScreen"
    if (IsSet -Elem $Icon) { $Dialog.Icon = $Icon }
    return $Dialog

}



#==============================================================================================================================================================================================
function CreateColorDialog([String]$Color="000000", [String]$Name, [Switch]$IsGame) {
    
    $ColorDialog = New-Object System.Windows.Forms.ColorDialog
    if (IsSet -Elem $Name) { $ColorDialog.Tag = $Name }
    $ColorDialog.Color = "#" + $Color

    if (IsSet -Elem $ColorDialog.Tag) {
        if ($IsGame) {
            if (IsSet $Settings[$GameType.mode][$ColorDialog.Tag]) {
                if ($Settings[$GameType.mode][$ColorDialog.Tag] -match "^[0-9A-F]+$")   { $ColorDialog.Color = "#" + $Settings[$GameType.mode][$ColorDialog.Tag] }
                else                                                                    { $ColorDialog.Color = $Settings[$GameType.mode][$ColorDialog.Tag] }
            }
            else { $Settings[$GameType.mode][$ColorDialog.Tag] = $ColorDialog.Color.Name }
        }
        else {
            if (IsSet $Settings["Core"][$ColorDialog.Tag]) {
                if ($Settings["Core"][$ColorDialog.Tag] -match "^[0-9A-F]+$")           { $ColorDialog.Color = "#" + $Settings["Core"][$ColorDialog.Tag] }
                else                                                                    { $ColorDialog.Color = $Settings[$GameType.mode][$ColorDialog.Tag] }
            }
            else { $Settings["Core"][$ColorDialog.Tag] = $ColorDialog.Color.Name }
        }
    }

    return $ColorDialog

}



#==============================================================================================================================================================================================
function CreateGroupBox([int]$X, [int]$Y, [int]$Width, [int]$Height, [String]$Name, [String]$Text, [Object]$AddTo) {
    
    $GroupBox = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.GroupBox) -AddTo $AddTo
    if ($Text -ne $null -and $Text -ne "") { $GroupBox.Text = (" " + $Text + " ") }
    return $GroupBox

}



#==============================================================================================================================================================================================
function CreatePanel([int]$X, [int]$Y, [int]$Width, [int]$Height, [String]$Name, [Boolean]$Hide, [Object]$AddTo) {
    
    $Panel = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.Panel) -AddTo $AddTo
    if ($Hide) { $Panel.Hide() }
    return $Panel

}



#==============================================================================================================================================================================================
function CreateTextBox([int]$X=0, [int]$Y=0, [int]$Width=0, [int]$Height=0, [int]$Length=10, [String]$Name, [Switch]$ReadOnly, [Switch]$Multiline, [String]$Text="", [Switch]$IsGame, [Object]$AddTo) {
    
    $TextBox = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.TextBox) -AddTo $AddTo
    $TextBox.Text = $Text
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

    if (IsSet -Elem $TextBox.Name) {
        if ($IsGame) {
            if (IsSet $Settings[$GameType.mode][$TextBox.Name])   { $TextBox.Text = $Settings[$GameType.mode][$TextBox.Name] }
            else                                                  { $Settings[$GameType.mode][$TextBox.Name] = $TextBox.Text }
            $TextBox.Add_TextChanged({ $Settings[$GameType.mode][$this.Name] = $this.Text })
        }
        else {
            if (IsSet $Settings["Core"][$TextBox.Name])           { $TextBox.Text = $Settings["Core"][$TextBox.Name] }
            else                                                  { $Settings["Core"][$TextBox.Name] = $TextBox.Text }
            $TextBox.Add_TextChanged({ $Settings["Core"][$this.Name] = $this.Text })
        }
    }
    
    return $TextBox

}



#==============================================================================================================================================================================================
function CreateComboBox([int]$X=0, [int]$Y=0, [int]$Width=0, [int]$Height=0, [String]$Name, [Object]$Items, [int]$Default=0, [Object]$ToolTip, [String]$Info, [Switch]$IsGame, [Object]$AddTo) {
    
    $ComboBox = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.ComboBox) -AddTo $AddTo

    if ($Items -ne $null) {
        $ComboBox.Items.AddRange($Items)

        if (IsSet -Elem $ComboBox.Name) {
            if ($IsGame) {
                if (IsSet $Settings[$GameType.mode][$ComboBox.Name])   { $ComboBox.SelectedIndex = $Settings[$GameType.mode][$ComboBox.Name] }
                else                                                   { $Settings[$GameType.mode][$ComboBox.Name] = $Default }
                $ComboBox.Add_SelectedIndexChanged({ $Settings[$GameType.mode][$this.Name] = $this.SelectedIndex })
            }
            else {
                if (IsSet $Settings["Core"][$ComboBox.Name])           { $ComboBox.SelectedIndex = $Settings["Core"][$ComboBox.Name] }
                else                                                   { $Settings["Core"][$ComboBox.Name] = $Default }
                $ComboBox.Add_SelectedIndexChanged({ $Settings["Core"][$this.Name] = $this.SelectedIndex })
            }
        }
        if ($ComboBox.SelectedIndex -eq -1) { $ComboBox.SelectedIndex = $Default }
    }

    $ComboBox.DropDownStyle = "DropDownList"
    if ($ToolTip -ne $null)   { $ToolTip.SetToolTip($ComboBox, $Info) }

    return $ComboBox

}



#==============================================================================================================================================================================================
function CreateCheckBox([int]$X=0, [int]$Y=0, [String]$Name, [Boolean]$Checked=$False, [Boolean]$Disable=$False, [Boolean]$IsRadio=$False, [Object]$ToolTip, [String]$Info="", [Boolean]$IsGame=$False, [Object]$AddTo) {
    
    if ($IsRadio)             { $Checkbox = CreateForm -X $X -Y $Y -Width 20 -Height 20 -Name $Name -Object (New-Object System.Windows.Forms.RadioButton) -AddTo $AddTo }
    else                      { $Checkbox = CreateForm -X $X -Y $Y -Width 20 -Height 20 -Name $Name -Object (New-Object System.Windows.Forms.CheckBox) -AddTo $AddTo }
    if ($ToolTip -ne $null)   { $ToolTip.SetToolTip($Checkbox, $Info) }
    $Checkbox.Enabled = !$Disable

    if (IsSet -Elem $Checkbox.Name) {
        if ($IsGame) {
            if (IsSet $Settings[$GameType.mode][$Checkbox.Name])   { $Checkbox.Checked = $Settings[$GameType.mode][$Checkbox.Name] -eq "True" }
            else                                                   { $Checkbox.Checked = $Settings[$GameType.mode][$Checkbox.Name] = $Checked }
            if ($IsRadio)                                          { $Checkbox.Add_CheckedChanged({ $Settings[$GameType.mode][$this.Name] = $this.Checked }) }
            else                                                   { $Checkbox.Add_CheckStateChanged({ $Settings[$GameType.mode][$this.Name] = $this.Checked }) }
        }
        else {
            if (IsSet $Settings["Core"][$Checkbox.Name])           { $Checkbox.Checked = $Settings["Core"][$Checkbox.Name] -eq "True" }
            else                                                   { $Checkbox.Checked = $Settings["Core"][$Checkbox.Name] = $Checked }
            if ($IsRadio)                                          { $Checkbox.Add_CheckedChanged({ $Settings["Core"][$this.Name] = $this.Checked }) }
            else                                                   { $Checkbox.Add_CheckStateChanged({ $Settings["Core"][$this.Name] = $this.Checked }) }
        }
    }
    else { $Checkbox.Checked = $Checked }

    return $Checkbox

}



#==============================================================================================================================================================================================
function CreateLabel([int]$X=0, [int]$Y=0, [String]$Name, [int]$Width=0, [int]$Height=0, [String]$Text="", [Object]$Font, [Object]$ToolTip, [String]$Info="", [Object]$AddTo) {
    
    $Label = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.Label) -AddTo $AddTo
    $Label.Text = $Text
    if ($Font -ne $null)      { $Label.Font = $Font }
    if ($ToolTip -ne $null)   { $ToolTip.SetToolTip($Label, $Info) }
    return $Label

}



#==============================================================================================================================================================================================
function CreateButton([int]$X=0, [int]$Y=0, [String]$Name, [int]$Width=0, [int]$Height=0, [String]$Text="", [Object]$ToolTip, [String]$Info="", [Object]$AddTo) {
    
    $Button = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Object (New-Object System.Windows.Forms.Button) -AddTo $AddTo
    $Button.Text = $Text
    if ($Font -ne $null)      { $Button.Font = $Font }
    if ($ToolTip -ne $null)   { $ToolTip.SetToolTip($Button, $Info) }
    return $Button

}



#==============================================================================================================================================================================================
function CreateReduxGroup([int]$Y=0, [int]$Height=0, [Object]$AddTo, [String]$Text="") { return CreateGroupBox -X 15 -Y $Y -Width ($AddTo.Width - 50) -Height ($Height * 30 + 20) -Text $Text -AddTo $AddTo }
function CreateReduxButton([int]$Column=0, [int]$Row=0, [int]$Width=150, [int]$Height=20, [Object]$AddTo, [String]$Text="", [Object]$ToolTip, [String]$Info="") { return CreateButton -X ($Column * 165 + 15) -Y ($Row * 30 - 10) -Width $Width -Height $Height -Text $Text -ToolTip $ToolTip -Info $Info -AddTo $AddTo }



#==============================================================================================================================================================================================
function CreateReduxPanel([int]$Row=0, [int]$Columns, [int]$Rows=1, [Object]$AddTo) {
    
    if (IsSet -Elem $Columns -Min 1)   { $Width = 150 * $Columns }
    else                               { $Width = $AddTo.Width - 20 }
    return CreatePanel -X $AddTo.Left -Y ($Row * 30 + 20) -Width $Width -Height (25 * $Rows) -AddTo $AddTo

}



#==============================================================================================================================================================================================
function CreateReduxTextBox([int]$Column=0, [int]$Row=0, [int]$Length=2, [Object]$AddTo, [String]$Value=0, [String]$Text="", [Object]$ToolTip, [String]$Info="", [String]$Name) {
    
    $Label = CreateLabel -X ($Column * 165 + 15) -Y ($Row * 30 - 10) -Width 100 -Height 15 -Text $Text -ToolTip $ToolTip -Info $Info -AddTo $AddTo
    $TextBox = CreateTextBox -X $Label.Right -Y ($Label.Top - 3) -Width 30 -Height 15 -Length $Length -Text $Value -IsGame $True -Name $Name -AddTo $AddTo
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
    return $TextBox

}



#==============================================================================================================================================================================================
function CreateReduxRadioButton([int]$Column=0, [int]$Row=0, [Object]$AddTo, [Switch]$Checked, [Switch]$Disable, [String]$Text="", [Object]$ToolTip, [String]$Info="", [String]$Name) {
    
    if ($Disable) { $Disable = !$PatchReduxCheckbox.Checked }
    $Radio = CreateCheckbox -X ($Column * 165) -Y ($Row * 30) -Checked $Checked -Disable $Disable  -IsRadio $True -ToolTip $ToolTip -Info $Info -IsGame $True -Name $Name -AddTo $AddTo
    $Label = CreateLabel -X $Radio.Right -Y ($Radio.Top + 3) -Width 135 -Height 15 -Text $Text -ToolTip $ToolTip -Info $Info -AddTo $AddTo
    return $Radio

}



#==============================================================================================================================================================================================
function CreateReduxCheckBox([int]$Column=0, [int]$Row=0, [Object]$AddTo, [Switch]$Checked, [Switch]$Disable, [String]$Text="", [Object]$ToolTip, [String]$Info="", [String]$Name) {
    
    if ($Disable) { $Disable = !$PatchReduxCheckbox.Checked }
    $Checkbox = CreateCheckbox -X ($Column * 165 + 15) -Y ($Row * 30 - 10) -Checked $Checked -Disable $Disable -IsRadio $False -ToolTip $ToolTip -Info $Info -IsGame $True -Name $Name -AddTo $AddTo
    $Label = CreateLabel -X $CheckBox.Right -Y ($CheckBox.Top + 3) -Width 135 -Height 15 -Text $Text -ToolTip $ToolTip -Info $Info -AddTo $AddTo
    return $CheckBox

}



#==============================================================================================================================================================================================
function CreateReduxComboBox([int]$Column, [int]$Row, [int]$Length=160, [Object]$AddTo, [Object]$Items, [int]$Default=0, [String]$Text, [Object]$ToolTip, [String]$Info, [String]$Name) {
    
    if (IsSet -Elem $Text)   { $Width = 80 }
    else                     { $Width = 0 }
    $Label = CreateLabel -X ($Column * 165 + 15) -Y ($Row * 30 - 10) -Width $Width -Height 15 -Text $Text -ToolTip $ToolTip -Info $Info -AddTo $AddTo
    $ComboBox = CreateComboBox -X $Label.Right -Y ($Label.Top - 3) -Width $Length -Height 20 -Items $Items -Default $Default -ToolTip $ToolTip -Info $Info -IsGame $True -Name $Name -AddTo $AddTo
    return $ComboBox

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
Export-ModuleMember -Function CreateRadioButton
Export-ModuleMember -Function CreateCheckbox
Export-ModuleMember -Function CreateComboBox

Export-ModuleMember -Function CreateReduxGroup
Export-ModuleMember -Function CreateReduxPanel
Export-ModuleMember -Function CreateReduxButton
Export-ModuleMember -Function CreateReduxTextBox
Export-ModuleMember -Function CreateReduxRadioButton
Export-ModuleMember -Function CreateReduxCheckbox
Export-ModuleMember -Function CreateReduxComboBox