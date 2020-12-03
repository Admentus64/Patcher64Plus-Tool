function CreateForm([int]$X=0, [int]$Y=0, [int]$Width=0, [int]$Height=0, [String]$Name, [String]$Tag, [Object]$Object, [Boolean]$IsGame, [Object]$AddTo) {
    
    $Form = $Object
    $Form.Size = New-Object System.Drawing.Size($Width, $Height)
    $Form.Location = New-Object System.Drawing.Size($X, $Y)
    if ( ($Tag -ne "") -or ($Tag -ne $null) ) { $Form.Tag = $Tag }
    if (IsSet -Elem $AddTo) { $AddTo.Controls.Add($Form) }

    if ($IsGame -and (IsSet -Elem $Name) ) {
        if (IsSet $Last.Extend) {
            $Redux[$Last.Extend][$Name] = $Form
            $Name = $Last.Extend + "." + $Name
        }
        else { $Redux[$Name] = $Form }
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
    $ColorDialog.Color = "#" + $Color

    if ($IsGame -and (IsSet -Elem $Name) ) {
        if (IsSet $Last.Extend) {
            $Redux[$Last.Extend][$Name] = $ColorDialog
            $Name = $Last.Extend + "." + $Name
        }
        else { $Redux[$Name] = $ColorDialog }
    }
    if (IsSet -Elem $Name) { $ColorDialog.Tag = $Name }
    
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
    $Last.Group.Font = $Fonts.Small
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
    $TextBox.Font = $Fonts.Small
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
    
    Add-Member -InputObject $TextBox -NotePropertyMembers @{ Default = $Text }
    return $TextBox

}



#==============================================================================================================================================================================================
function CreateComboBox([int]$X=0, [int]$Y=0, [int]$Width=0, [int]$Height=0, [String]$Name, [String]$Tag, [Object]$Items, [int]$Default=1, [String]$Info, [Switch]$IsGame, [Object]$AddTo=$Last.Group) {
    
    $ComboBox = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -IsGame $IsGame -Object (New-Object System.Windows.Forms.ComboBox) -AddTo $AddTo
    $ComboBox.DropDownStyle = "DropDownList"
    $ComboBox.Font = $Fonts.Small
    $ToolTip = CreateToolTip -Form $ComboBox -Info $Info
    if ($Default -lt 1) { $Default = 1 }

    if (IsSet -Elem $Items -HasInt) {
        $ComboBox.Items.AddRange($Items)
        if (IsSet -Elem $ComboBox.Name) {
            if ($IsGame)   { $ComboBox.Tag = $GameType.mode }
            else           { $ComboBox.Tag = "Core" }
            if (IsSet $Settings[$ComboBox.Tag][$ComboBox.Name]) {
                if ([int]($Settings[$ComboBox.Tag][$ComboBox.Name]) -gt $ComboBox.Items.Count -or [int]($Settings[$ComboBox.Tag][$ComboBox.Name]) -lt 1) { $ComboBox.SelectedIndex = ($Default-1) }
                else { $ComboBox.SelectedIndex = [int]($Settings[$ComboBox.Tag][$ComboBox.Name]-1) }
            }
            else { $Settings[$ComboBox.Tag][$ComboBox.Name] = $Default }
            $ComboBox.Add_SelectedIndexChanged({ $Settings[$this.Tag][$this.Name] = ($this.SelectedIndex+1) })
        }
        if ($ComboBox.SelectedIndex -lt 0) { $ComboBox.SelectedIndex = ($Default-1) }
    }

    Add-Member -InputObject $ComboBox -NotePropertyMembers @{ Default = ($Default-1) }
    return $ComboBox

}



#==============================================================================================================================================================================================
function CreateCheckBox([int]$X=0, [int]$Y=0, [String]$Name, [String]$Tag, [Boolean]$Checked=$False, [Boolean]$Disable=$False, [Boolean]$IsRadio=$False, [String]$Info="", [Boolean]$IsGame=$False, [Boolean]$IsDebug=$False, [Object]$AddTo=$Last.Group) {
    
    if ($IsRadio)             { $CheckBox = CreateForm -X $X -Y $Y -Width 20 -Height 20 -Name $Name -Tag $Tag -IsGame $IsGame -Object (New-Object System.Windows.Forms.RadioButton) -AddTo $AddTo }
    else                      { $CheckBox = CreateForm -X $X -Y $Y -Width 20 -Height 20 -Name $Name -Tag $Tag -IsGame $IsGame -Object (New-Object System.Windows.Forms.CheckBox)    -AddTo $AddTo }
    $ToolTip = CreateToolTip -Form $CheckBox -Info $Info
    $CheckBox.Enabled = !$Disable

    if (IsSet -Elem $CheckBox.Name) {
        if ($IsGame)        { $CheckBox.Tag = $GameType.mode }
        elseif ($IsDebug)   { $CheckBox.Tag = "Debug" }
        else                { $CheckBox.Tag = "Core" }
        if (IsSet $Settings[$CheckBox.Tag][$CheckBox.Name])   { $CheckBox.Checked = $Settings[$CheckBox.Tag][$CheckBox.Name] -eq "True" }
        else                                                  { $CheckBox.Checked = $Settings[$CheckBox.Tag][$CheckBox.Name] = $Checked }
        if ($IsRadio)                                         { $CheckBox.Add_CheckedChanged({ $Settings[$this.Tag][$this.Name] = $this.Checked }) }
        else                                                  { $CheckBox.Add_CheckStateChanged({ $Settings[$this.Tag][$this.Name] = $this.Checked }) }
    }
    else { $CheckBox.Checked = $Checked }

    Add-Member -InputObject $CheckBox -NotePropertyMembers @{ Default = $Checked }
    return $CheckBox

}



#==============================================================================================================================================================================================
function CreateLabel([int]$X=0, [int]$Y=0, [String]$Name, [String]$Tag, [int]$Width=0, [int]$Height=0, [String]$Text="", [Object]$Font=$Fonts.Small, [String]$Info="", [Object]$AddTo=$Last.Group) {
    
    $Label = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -Object (New-Object System.Windows.Forms.Label) -AddTo $AddTo
    if (IsSet -Elem $Text)      { $Label.Text = $Text }
    if (!(IsSet -Elem $Width))  { $Label.AutoSize = $True }
    $Label.Font = $Font
    $ToolTip = CreateToolTip -Form $Label -Info $Info
    return $Label

}



#==============================================================================================================================================================================================
function CreateButton([int]$X=0, [int]$Y=0, [String]$Name, [String]$Tag, [int]$Width=100, [int]$Height=20, [String]$ForeColor, [String]$BackColor, [String]$Text="", [Object]$Font=$Fonts.Small, [String]$Info="", [Object]$AddTo=$Last.Group) {
    
    $Button = CreateForm -X $X -Y $Y -Width $Width -Height $Height -Name $Name -Tag $Tag -Object (New-Object System.Windows.Forms.Button) -AddTo $AddTo
    if (IsSet -Elem $Text)        { $Button.Text = $Text }
    $Button.Font = $Font
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
function CreateReduxPanel([Float]$Row=0, [Float]$Columns, [Float]$Rows=1,  [String]$Name, [String]$Tag, [Object]$AddTo=$Last.Group) {
    
    if (IsSet -Elem $Columns -Min 0)   { $Width = 150 * $Columns }
    else                               { $Width = $AddTo.Width - 20 }
    return CreatePanel -X $AddTo.Left -Y ($Row * 30 + 20) -Width $Width -Height (26.5 * $Rows) -Name $Name -Tag $Tag -AddTo $AddTo

}


#==============================================================================================================================================================================================
function CreateReduxGroup([Float]$X=15, [Float]$Y=50, [Float]$Height=1, [String]$Name=$Last.TabName, [String]$Tag, [Switch]$Hide, [Boolean]$IsGame=$True, [String]$Text="", [Switch]$IsRedux, [Float]$Columns=0, [Object]$AddTo=$Redux.Panel) {
    
    $Width = ($AddTo.Width - 50)

    if (IsSet -Elem $Name) {
        if (!$Last.Half) {
            if ($Last.GroupName -eq $Name)     { $Y = $Last.Group.Bottom + 5}
            elseif ($ReduxTabs.length -gt 0)   { $Y = 80 }
            else                               { $Y = 40 }
        }
        if ($Last.Half) {
            $X = $Last.Group.Right + 5
            $Y = $Last.Group.Top
            $Width = $AddTo.Width - $Last.Group.Right - 40
            $Height = $Last.Group.Rows
            $Last.Half = $False
        }
        if ($Columns -gt 0) {
            $Width = 165 * $Columns
            $Last.Half = $True
        }
    }

    $Group = CreateGroupBox -X $X -Y $Y -Width $Width -Height ($Height * 30 + 20) -Name $Name -Tag $Tag -Text $Text -AddTo $AddTo
    if ( (IsSet -Elem $Name) -and ($Name -ne "Main") )           { $Group.Visible = $False }
    if (IsSet -Elem $Tag)                                        { $Group.Tag = $Tag }
    if ( (IsSet -Elem $Tag) -and !(IsSet -Elem $Redux[$Tag]) )   { $Redux[$Tag] = @{} }
    if (IsSet -Elem $Tag)                                        { $Last.Extend = $Tag }
    else                                                         { $Last.Extend = $null }
    Add-Member -InputObject $Group -NotePropertyMembers @{
        IsRedux = $IsRedux -or $Name -eq "Redux"
        IsLanguage = $False
        Rows = $Height
    }

    if ($IsGame) { $Redux.Groups += $Group }
    return $Group

}



#==============================================================================================================================================================================================
function CreateReduxButton([Float]$Column=1, [Float]$Row=1, [int]$Width=150, [int]$Height=20, [String]$Name, [String]$Tag, [String]$Text="", [String]$Info="", [Object]$AddTo=$Last.Group) {
    
    return CreateButton -X (($Column-1) * 165 + 15) -Y ($Row * 30 - 13) -Width $Width -Height $Height -Name $Name -Tag $Tag -Text $Text -Info $Info -AddTo $AddTo

}



#==============================================================================================================================================================================================
function CreateReduxTextBox([Float]$Column=1, [Float]$Row=1, [int]$Length=2, [String]$Value=0, [String]$Text="", [String]$Info="", [String]$Name, [String]$Tag, [Object]$AddTo=$Last.Group) {
    
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
function CreateReduxRadioButton([Float]$Column=1, [Float]$Row=1, [Switch]$Checked, [Switch]$Disable, [String]$Text="", [String]$Info="", [String]$Name, [String]$Tag, [Object]$AddTo=$Last.Panel) {
    
    if ($Disable) { $Disable = !$PatchReduxCheckBox.Checked }
    $Radio = CreateCheckBox -X (($Column-1) * 165) -Y (($Row-1) * 30) -Checked $Checked -Disable $Disable  -IsRadio $True -Info $Info -IsGame $True -Name $Name -Tag $Tag -AddTo $AddTo
    $Label = CreateLabel -X $Radio.Right -Y ($Radio.Top + 3) -Height 15 -Text $Text -Info $Info -AddTo $AddTo

    Add-Member -InputObject $Label -NotePropertyMembers @{ CheckBox = $Radio }
    $Label.Add_Click({ $this.CheckBox.Checked = $True })

    return $Radio

}



#==============================================================================================================================================================================================
function CreateReduxCheckBox([Float]$Column=1, [Float]$Row=1, [Switch]$Checked, [Switch]$Disable, [String]$Text="", [String]$Info="", [String]$Name, [String]$Tag, [Object]$AddTo=$Last.Group) {
    
    if ($Disable) { $Disable = !$PatchReduxCheckBox.Checked }
    $CheckBox = CreateCheckBox -X (($Column-1) * 165 + 15) -Y ($Row * 30 - 10) -Checked $Checked -Disable $Disable -IsRadio $False -Info $Info -IsGame $True -Name $Name  -Tag $Tag -AddTo $AddTo
    $Label = CreateLabel -X $CheckBox.Right -Y ($CheckBox.Top + 3) -Height 15 -Text $Text -Info $Info -AddTo $AddTo

    Add-Member -InputObject $Label -NotePropertyMembers @{ CheckBox = $CheckBox }
    $Label.Add_Click({ $this.CheckBox.Checked = !$this.CheckBox.Checked })

    return $CheckBox

}



#==============================================================================================================================================================================================
function CreateReduxComboBox([Float]$Column=1, [Float]$Row=1, [int]$Length=160, [int]$Shift=0, [Array]$Items, [int]$Default=1, [String]$Text, [String]$Info, [String]$Name, [String]$Tag, [Object]$AddTo=$Last.Group) {
    
    if (IsSet -Elem $Text)   { $Width = (80 + $Shift) }
    else                     { $Width = 0 }
    if ($Items[($Default-1)] -ne "Default") {
        $Items = $Items.Clone()
        $Items[($Default-1)] += " (default)"
    }
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