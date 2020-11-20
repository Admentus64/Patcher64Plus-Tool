function CreateForm([int]$X=0, [int]$Y=0, [int]$Width=0, [int]$Height=0, [String]$Name, [String]$Tag, [Object]$Object, [Boolean]$IsGame, [Object]$AddTo) {
    
    $Form = $Object
    $Form.Size = New-Object System.Drawing.Size($Width, $Height)
    $Form.Location = New-Object System.Drawing.Size($X, $Y)
    if ( ($Tag -ne "") -or ($Tag -ne $null) ) { $Form.Tag = $Tag }
    $AddTo.Controls.Add($Form)

    if ($IsGame) {
        if ( (IsSet $Last.Extend) -and (IsSet -Elem $Name) ) {
            $Redux[$Last.Extend][$Name] = $Form
            $Name = $Last.Extend + "." + $Name
        }
        elseif (IsSet -Elem $Name) { $Redux[$Name] = $Form }
    }
    if (IsSet -Elem $Name) { $Form.Name = $Name }

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
    $Dialog.AutoScale = $True
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
        if ($IsGame)   { $mode = $GameType.mode }
        else           { $mode = "Core" }
        if (IsSet $Settings[$mode][$ColorDialog.Tag]) {
            if ($Settings[$mode][$ColorDialog.Tag] -match "^[0-9A-F]+$")   { $ColorDialog.Color = "#" + $Settings[$mode][$ColorDialog.Tag] }
            else                                                           { $ColorDialog.Color = $Settings[$mode][$ColorDialog.Tag] }
        }
        else { $Settings[$mode][$ColorDialog.Tag] = $ColorDialog.Color.Name }
    }

    return $ColorDialog

}



#==============================================================================================================================================================================================
function CreateGroupBox([int]$X, [int]$Y, [int]$Width, [int]$Height, [String]$Name, [String]$Tag, [String]$Text, [Object]$AddTo=$Last.Panel) {
    
    $Last.Group = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -Object (New-Object System.Windows.Forms.GroupBox) -AddTo $AddTo
    if (IsSet -Elem $Text) { $Last.Group.Text = (" " + $Text + " ") }
    $Last.GroupName = $Name
    return $Last.Group

}



#==============================================================================================================================================================================================
function CreatePanel([int]$X, [int]$Y, [int]$Width, [int]$Height, [String]$Name, [String]$Tag, [Boolean]$Hide, [Object]$AddTo=$MainDialog) {
    
    $Last.Panel = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -Object (New-Object System.Windows.Forms.Panel) -AddTo $AddTo
    if ($Hide) { $Last.Panel.Hide() }
    return $Last.Panel

}



#==============================================================================================================================================================================================
function CreateTextBox([int]$X=0, [int]$Y=0, [int]$Width=0, [int]$Height=0, [int]$Length=10, [String]$Name, [String]$Tag, [Switch]$ReadOnly, [Switch]$Multiline, [String]$Text="", [Switch]$IsGame, [Object]$AddTo=$Last.Group) {
    
    $TextBox = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -IsGame $IsGame -Object (New-Object System.Windows.Forms.TextBox) -AddTo $AddTo
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
        if ($IsGame)   { $TextBox.Tag = $GameType.mode }
        else           { $TextBox.Tag = "Core" }
        if (IsSet $Settings[$TextBox.Tag][$TextBox.Name])   { $TextBox.Text = $Settings[$TextBox.Tag][$TextBox.Name] }
        else                                                { $Settings[$TextBox.Tag][$TextBox.Name] = $TextBox.Text }
        $TextBox.Add_TextChanged({ $this.Tag; $Settings[$this.Tag][$this.Name] = $this.Text })
    }
    
    return $TextBox

}



#==============================================================================================================================================================================================
function CreateComboBox([int]$X=0, [int]$Y=0, [int]$Width=0, [int]$Height=0, [String]$Name, [String]$Tag, [Object]$Items, [int]$Default=0, [String]$Info, [Switch]$IsGame, [Object]$AddTo=$Last.Group) {
    
    $ComboBox = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -IsGame $IsGame -Object (New-Object System.Windows.Forms.ComboBox) -AddTo $AddTo
    $ComboBox.DropDownStyle = "DropDownList"
    $ToolTip = CreateToolTip -Form $ComboBox -Info $Info

    if (IsSet -Elem $Items) {
        $ComboBox.Items.AddRange($Items)

        if (IsSet -Elem $ComboBox.Name) {
            if ($IsGame)   { $ComboBox.Tag = $GameType.mode }
            else           { $ComboBox.Tag = "Core" }
            if (IsSet $Settings[$ComboBox.Tag][$ComboBox.Name])   { $ComboBox.SelectedIndex = $Settings[$ComboBox.Tag][$ComboBox.Name] }
            else                                                  { $Settings[$ComboBox.Tag][$ComboBox.Name] = $Default }
            $ComboBox.Add_SelectedIndexChanged({ $Settings[$this.Tag][$this.Name] = $this.SelectedIndex })

        }
        if ($ComboBox.SelectedIndex -eq -1) { $ComboBox.SelectedIndex = $Default }
    }

    return $ComboBox

}



#==============================================================================================================================================================================================
function CreateCheckBox([int]$X=0, [int]$Y=0, [String]$Name, [String]$Tag, [Boolean]$Checked=$False, [Boolean]$Disable=$False, [Boolean]$IsRadio=$False, [String]$Info="", [Boolean]$IsGame=$False, [Boolean]$IsDebug=$False, [Object]$AddTo=$Last.Group) {
    
    if ($IsRadio)             { $Checkbox = CreateForm -X $X -Y $Y -Width 20 -Height 20 -Name $Name -Tag $Tag -IsGame $IsGame -Object (New-Object System.Windows.Forms.RadioButton) -AddTo $AddTo }
    else                      { $Checkbox = CreateForm -X $X -Y $Y -Width 20 -Height 20 -Name $Name -Tag $Tag -IsGame $IsGame -Object (New-Object System.Windows.Forms.CheckBox)    -AddTo $AddTo }
    $ToolTip = CreateToolTip -Form $Checkbox -Info $Info
    $Checkbox.Enabled = !$Disable

    if (IsSet -Elem $Checkbox.Name) {
        if ($IsGame)        { $Checkbox.Tag = $GameType.mode }
        elseif ($IsDebug)   { $Checkbox.Tag = "Debug" }
        else                { $Checkbox.Tag = "Core" }
        if (IsSet $Settings[$Checkbox.Tag][$Checkbox.Name])   { $Checkbox.Checked = $Settings[$Checkbox.Tag][$Checkbox.Name] -eq "True" }
        else                                                  { $Checkbox.Checked = $Settings[$Checkbox.Tag][$Checkbox.Name] = $Checked }
        if ($IsRadio)                                         { $Checkbox.Add_CheckedChanged({ $Settings[$this.Tag][$this.Name] = $this.Checked }) }
        else                                                  { $Checkbox.Add_CheckStateChanged({ $Settings[$this.Tag][$this.Name] = $this.Checked }) }
    }
    else { $Checkbox.Checked = $Checked }

    return $Checkbox

}



#==============================================================================================================================================================================================
function CreateLabel([int]$X=0, [int]$Y=0, [String]$Name, [String]$Tag, [int]$Width=0, [int]$Height=0, [String]$Text="", [Object]$Font, [String]$Info="", [Object]$AddTo=$Last.Group) {
    
    $Label = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -Object (New-Object System.Windows.Forms.Label) -AddTo $AddTo
    if (IsSet -Elem $Text)   { $Label.Text = $Text }
    if (IsSet -Elem $Font)   { $Label.Font = $Font }
    $ToolTip = CreateToolTip -Form $Label -Info $Info
    return $Label

}



#==============================================================================================================================================================================================
function CreateButton([int]$X=0, [int]$Y=0, [String]$Name, [String]$Tag, [int]$Width=100, [int]$Height=20, [String]$ForeColor, [String]$BackColor, [String]$Text="", [String]$Info="", [Object]$AddTo=$Last.Group) {
    
    $Button = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -Object (New-Object System.Windows.Forms.Button) -AddTo $AddTo
    if (IsSet -Elem $Text)        { $Button.Text = $Text }
    if (IsSet -Elem $Font)        { $Button.Font = $Font }
    if (IsSet -Elem $ForeColor)   { $Button.ForeColor = $ForeColor }
    if (IsSet -Elem $BackColor)   { $Button.BackColor = $BackColor }
    if (IsSet -Elem $Info)        { $ToolTip = CreateToolTip -Form $Button -Info $Info }
    return $Button

}



#==============================================================================================================================================================================================
function CreateTabButtons([Array]$Tabs, [Object]$AddTo=$Redux.Panel) {
    
    if ($GamePatch.redux.options -eq 1)     { $Tabs += "Redux" }
    if (IsSet -Elem $GamePatch.languages)   { $Tabs += "Language" }
    if ($Tabs.Length -ne 0)                 { $Tabs = ,"Main" + $Tabs }
    $global:ReduxTabs = @()
    $Last.TabName = "Main"

    # Create tabs
    for ($i=0; $i -lt $Tabs.Length; $i++) {
        $Button = CreateButton -X (15 + (($Redux.Panel.width-50)/$Tabs.length*$i)) -Y 40 -Width (($Redux.Panel.width-50)/$Tabs.length) -Height 30 -ForeColor "White" -BackColor "Gray" -Name $Tabs[$i] -Tag $i -Text $Tabs[$i] -AddTo $AddTo
        $Last.TabName = $Tabs[$i]
        $Button.Add_Click({
            $ReduxTabs.GetEnumerator()    | ForEach-Object { $_.BackColor = "Gray" }
            $Redux.Groups.GetEnumerator() | ForEach-Object { $_.Visible = $_.Name -eq $this.Name }
            $this.BackColor = "DarkGray"
            $Settings[$GameType.mode]["LastTab"] = $this.Tag
        })
        $global:ReduxTabs += $Button
        $FunctionTitle = SetFunctionTitle -Function ($Tabs[$i] + $GameType.mode)
        if (Get-Command ("CreateTab" + $FunctionTitle) -errorAction SilentlyContinue) { &("CreateTab" + $FunctionTitle) }
    }

    # Restore last tab
    if ($Tabs.Length -gt 0) {
        if (IsSet -Elem $Settings[$GameType.mode]["LastTab"]) {
            $ReduxTabs[$Settings[$GameType.mode]["LastTab"]].BackColor = "DarkGray"
            $Redux.Groups.GetEnumerator() | ForEach-Object { $_.Visible = $_.Name -eq $ReduxTabs[$Settings[$GameType.mode]["LastTab"]].Name }
        }
        else { $ReduxTabs[0].BackColor = "DarkGray" }
    }

}



#==============================================================================================================================================================================================
function CreateReduxPanel([int]$Row=0, [int]$Columns, [int]$Rows=1,  [String]$Name, [String]$Tag, [Object]$AddTo=$Last.Group) {
    
    if (IsSet -Elem $Columns -Min 1)   { $Width = 150 * $Columns }
    else                               { $Width = $AddTo.Width - 20 }
    return CreatePanel -X $AddTo.Left -Y ($Row * 30 + 20) -Width $Width -Height (25 * $Rows) -Name $Name -Tag $Tag -AddTo $AddTo

}


#==============================================================================================================================================================================================
function CreateReduxGroup([int]$Y=50, [int]$Height=1, [String]$Name=$Last.TabName, [String]$Tag, [Switch]$Hide, [Boolean]$IsGame=$True, [String]$Text="", [Object]$AddTo=$Redux.Panel) {
    
    if (IsSet -Elem $Name) {
        if ($Last.GroupName -eq $Name)     { $Y = $Last.Group.Bottom + 5}
        elseif ($ReduxTabs.length -gt 0)   { $Y = 80 }
        else                               { $Y = 40 }
    }

    $Group = CreateGroupBox -X 15 -Y $Y -Width ($AddTo.Width - 50) -Height ($Height * 30 + 20) -Name $Name -Tag $Tag -Text $Text -AddTo $AddTo
    if ( (IsSet -Elem $Name) -and ($Name -ne "Main") )           { $Group.Visible = $False }
    if (IsSet -Elem $Tag)                                        { $Group.Tag = $Tag }
    if ( (IsSet -Elem $Tag) -and !(IsSet -Elem $Redux[$Tag]) )   { $Redux[$Tag] = @{} }
    if (IsSet -Elem $Tag)                                        { $Last.Extend = $Tag }
    else                                                         { $Last.Extend = $null }
    
    if ($IsGame) { $Redux.Groups += $Group }
    return $Group

}



#==============================================================================================================================================================================================
function CreateReduxButton([int]$Column=1, [int]$Row=1, [int]$Width=150, [int]$Height=20, [String]$Name, [String]$Tag, [String]$Text="", [String]$Info="", [Object]$AddTo=$Last.Group) {
    
    return CreateButton -X (($Column-1) * 165 + 15) -Y ($Row * 30 - 13) -Width $Width -Height $Height -Name $Name -Tag $Tag -Text $Text -Info $Info -AddTo $AddTo

}



#==============================================================================================================================================================================================
function CreateReduxTextBox([int]$Column=1, [int]$Row=1, [int]$Length=2, [String]$Value=0, [String]$Text="", [String]$Info="", [String]$Name, [String]$Tag, [Object]$AddTo=$Last.Group) {
    
    $Label = CreateLabel -X (($Column-1) * 165 + 15) -Y ($Row * 30 - 10) -Width 100 -Height 15 -Text $Text -Info $Info -AddTo $AddTo
    $TextBox = CreateTextBox -X $Label.Right -Y ($Label.Top - 3) -Width 30 -Height 15 -Length $Length -Text $Value -IsGame $True -Name $Name -Tag $Tag -AddTo $AddTo
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
function CreateReduxRadioButton([int]$Column=1, [int]$Row=1, [Switch]$Checked, [Switch]$Disable, [String]$Text="", [String]$Info="", [String]$Name, [String]$Tag, [Object]$AddTo=$Last.Panel) {
    
    if ($Disable) { $Disable = !$PatchReduxCheckbox.Checked }
    $Radio = CreateCheckbox -X (($Column-1) * 165) -Y (($Row-1) * 30) -Checked $Checked -Disable $Disable  -IsRadio $True -Info $Info -IsGame $True -Name $Name -Tag $Tag -AddTo $AddTo
    $Label = CreateLabel -X $Radio.Right -Y ($Radio.Top + 3) -Width 135 -Height 15 -Text $Text -Info $Info -AddTo $AddTo
    return $Radio

}



#==============================================================================================================================================================================================
function CreateReduxCheckBox([int]$Column=1, [int]$Row=1, [Switch]$Checked, [Switch]$Disable, [String]$Text="", [String]$Info="", [String]$Name, [String]$Tag, [Object]$AddTo=$Last.Group) {
    
    if ($Disable) { $Disable = !$PatchReduxCheckbox.Checked }
    $Checkbox = CreateCheckbox -X (($Column-1) * 165 + 15) -Y ($Row * 30 - 10) -Checked $Checked -Disable $Disable -IsRadio $False -Info $Info -IsGame $True -Name $Name  -Tag $Tag -AddTo $AddTo
    $Label = CreateLabel -X $CheckBox.Right -Y ($CheckBox.Top + 3) -Width 135 -Height 15 -Text $Text -Info $Info -AddTo $AddTo
    return $CheckBox

}



#==============================================================================================================================================================================================
function CreateReduxComboBox([int]$Column=1, [int]$Row=1, [int]$Length=160, [int]$Shift=0, [Object]$Items, [int]$Default=0, [String]$Text, [String]$Info, [String]$Name, [String]$Tag, [Object]$AddTo=$Last.Group) {
    
    if (IsSet -Elem $Text)   { $Width = (80 + $Shift) }
    else                     { $Width = 0 }
    $Label = CreateLabel -X (($Column-1) * 165 + 15) -Y ($Row * 30 - 10) -Width $Width -Height 15 -Text $Text -Info $Info -AddTo $AddTo
    $ComboBox = CreateComboBox -X $Label.Right -Y ($Label.Top - 3) -Width ($Length - $Shift) -Height 20 -Items $Items -Default $Default -Info $Info -IsGame $True -Name $Name -Tag $Tag -AddTo $AddTo
    return $ComboBox

}



#==============================================================================================================================================================================================
function CreateReduxColoredLabel([Object]$Link, [System.Drawing.Color]$Color, [String]$Name, [String]$Tag, [Object]$AddTo=$Last.Group) {
    
    $Label = CreateLabel -X ($Link.Right + 15) -Y $Link.Top -Width 40 -Height $Link.Height -Name $Name -Tag $Tag -AddTo $AddTo
    if (IsSet -Elem $Color) { $Label.BackColor = $Color }
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
Export-ModuleMember -Function CreateRadioButton
Export-ModuleMember -Function CreateCheckbox
Export-ModuleMember -Function CreateComboBox

Export-ModuleMember -Function CreateTabButton
Export-ModuleMember -Function CreateTabButtons

Export-ModuleMember -Function CreateReduxGroup
Export-ModuleMember -Function CreateReduxPanel
Export-ModuleMember -Function CreateReduxButton
Export-ModuleMember -Function CreateReduxTextBox
Export-ModuleMember -Function CreateReduxRadioButton
Export-ModuleMember -Function CreateReduxCheckbox
Export-ModuleMember -Function CreateReduxComboBox
Export-ModuleMember -Function CreateReduxColoredLabel