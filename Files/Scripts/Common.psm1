function SetWiiVCMode([Boolean]$Enable) {
    
    $global:IsWiiVC = $Enable

    if ($IsWiiVC)   { EnablePatchButtons -Enable (IsSet -Elem $Files.WAD) }
    else            { EnablePatchButtons -Enable (IsSet -Elem $Files.Z64) }
    
    $InjectROMButton.Visible = $PatchVCPanel.Visible = $IsWiiVC
    $CustomTitleTextBox.MaxLength = $GameTitleLength[[uint32]$IsWiiVC]
    $ClearWADPathButton.Enabled = (IsSet -Elem $Files.WAD -MinLength 1)

    GetHeader
    SetMainScreenSize
    SetModeLabel
    ChangePatchPanel

}



#==================================================================================================================================================================================================================================================================
function CreateToolTip() {

    # Create ToolTip
    $ToolTip = New-Object System.Windows.Forms.ToolTip
    $ToolTip.AutoPopDelay = 32767
    $ToolTip.InitialDelay = 500
    $ToolTip.ReshowDelay = 0
    $ToolTip.ShowAlways = $True
    return $ToolTip

}



#==============================================================================================================================================================================================
function ChangeGamesList() {
    
    # Reset
    $CurrentGameComboBox.Items.Clear()

    $Items = @()
    Foreach ($Game in $Files.json.games.game) {
        if ( ($IsWiiVC -and $Game.console -eq "Wii VC") -or (!$IsWiiVC -and $Game.console -eq "N64") -or ($Game.console -eq "All") ) { $Items += $Game.title }
    }

    $CurrentGameComboBox.Items.AddRange($Items)

    # Reset last index
    For ($i=0; $i -lt $Items.Length; $i++) {
        if ($GameType.title -eq $Items[$i]) { $CurrentGameComboBox.SelectedIndex = $i }
    }

    if ($Items.Length -gt 0 -and $CurrentGameComboBox.SelectedIndex -eq -1) {
        #$CurrentGameComboBox.SelectedIndex = $Settings["Core"][$CurrentGameComboBox.Name]
        try { $CurrentGameComboBox.SelectedIndex = $Settings["Core"][$CurrentGameComboBox.Name] }
        catch { $CurrentGameComboBox.SelectedIndex = 0 }
    }

}



#==============================================================================================================================================================================================
function ChangePatchPanel() {
    
    # Reset
    $PatchGroup.text = $GameType.mode + " - Patch Options"
    $PatchComboBox.Items.Clear()

    # Set combobox for patches
    $Items = @()
    foreach ($i in $Files.json.patches.patch) {
        if ( ($IsWiiVC -and $i.console -eq "Wii VC") -or (!$IsWiiVC -and $i.console -eq "N64") -or ($i.console -eq "All") ) {
            $Items += $i.title
            if (!(IsSet -Elem $FirstItem)) { $FirstItem = $i }
        }
    }

    $PatchComboBox.Items.AddRange($Items)

    # Reset last index
    For ($i=0; $i -lt $Items.Length; $i++) {
        Foreach ($Item in $Files.json.patches.patch) {
            if ($Item.title -eq $GamePatch.title -and $Item.title -eq $Items[$i]) { $PatchComboBox.SelectedIndex = $i }
        }
    }
    if ($Items.Length -gt 0 -and $PatchComboBox.SelectedIndex -eq -1) {
        try { $PatchComboBox.SelectedIndex = $Settings["Core"][$PatchComboBox.Name] }
        catch { $PatchComboBox.SelectedIndex = 0 }
    }

    #if ($GameType.options)  { $global:ToolTip.SetToolTip($PatchOptionsButton, "Toggle options for the " + $GameType.mode +  " REDUX romhack") }

}



#==============================================================================================================================================================================================
function SetMainScreenSize() {
    
    if ($IsWiiVC) {
        $CustomTitleTextBoxLabel.Text = "Channel Title:"
        if ($GameType.patches)   { $PatchVCPanel.Location = New-Object System.Drawing.Size(10, ($PatchPanel.Bottom + 5)) }
        else                     { $PatchVCPanel.Location = New-Object System.Drawing.Size(10, ($CustomGameIDPanel.Bottom + 5)) }
        $MiscPanel.Location = New-Object System.Drawing.Size(10, ($PatchVCPanel.Bottom + 5))
    }

    else {
        $CustomTitleTextBoxLabel.Text = "Game Title:"
        if ($GameType.patches)   { $MiscPanel.Location = New-Object System.Drawing.Size(10, ($PatchPanel.Bottom + 5)) }
        else                     { $MiscPanel.Location = New-Object System.Drawing.Size(10, ($CustomGameIDPanel.Bottom + 5)) }
    }

    $StatusPanel.Location = New-Object System.Drawing.Size(10, ($MiscPanel.Bottom + 5))
    $MainDialog.Height = ($StatusPanel.Bottom + 50)

}


#==============================================================================================================================================================================================
function ChangeGameMode() {
    
    Foreach ($Item in $Files.json.games.game) {
        if ($Item.title -eq $CurrentGameComboBox.text) {
            $global:GameType = $Item
            break
        }
    }

    $GameFiles.base = $Paths.games + "\" + $GameType.mode
    $GameFiles.binaries = $GameFiles.base + "\Binaries"
    $GameFiles.compressed = $GameFiles.base + "\Compressed"
    $GameFiles.decompressed = $GameFiles.base + "\Decompressed"
    $GameFiles.textures = $GameFiles.base + "\Textures"
    $GameFiles.credits = $GameFiles.base + "\Credits.txt"
    $GameFiles.info = $GameFiles.base + "\Info.txt"
    $GameFiles.icon = $GameFiles.base + "\Icon.ico"
    $GameFiles.json = $GameFiles.base + "\Patches.json"

    $Lines = Get-Content -Path $Files.settings
    if ( $Lines -notcontains ("[" + $GameType.mode + "]") ) {
        Out-IniFile -FilePath $Files.settings -InputObject $Settings | Out-Null
        Add-Content -Path $Files.settings -Value ("[" + $GameType.mode + "]") | Out-Null
        $global:Settings = Get-IniContent $Files.settings
    }

    $PatchVCExpandMemoryLabel.Visible = $PatchVCExpandMemory.Visible = $False
    $PatchVCRemoveFilterLabel.Visible = $PatchVCRemoveFilter.Visible = $False
    $PatchVCRemapDPadLabel.Visible = $PatchVCRemapDPad.Visible = $False
    $PatchVCDowngradeLabel.Visible = $PatchVCDowngrade.Visible = $False
    
    $PatchVCMinimapLabel.Hide()
    $PatchVCRemapCDown.Visible = $PatchVCRemapCDownLabel.Visible = $False
    $PatchVCRemapZLabel.Visible = $PatchVCRemapZ.Visible = $False
    $PatchVCLeaveDPadUpLabel.Visible = $PatchVCLeaveDPadUp.Visible = $False

    if (IsSet -Elem $GameType.patches) {
        if (Test-Path -LiteralPath $GameFiles.json) {
            try { $Files.json.patches = Get-Content -Raw -Path $GameFiles.json | ConvertFrom-Json }
            catch { CreateErrorDialog -Error "Corrupted JSON" }
        }
        else { CreateErrorDialog -Error "Missing JSON" }
    }

    # Info
    if (Test-Path -LiteralPath $GameFiles.info -PathType Leaf)       { AddTextFileToTextbox -TextBox $InfoTextbox -File $GameFiles.info }
    else                                                             { AddTextFileToTextbox -TextBox $InfoTextbox -File $null }

    # Credits
    if (Test-Path -LiteralPath $Files.text.credits -PathType Leaf)   { AddTextFileToTextbox -TextBox $CreditsTextBox -File $Files.text.credits }
    if (Test-Path -LiteralPath $GameFiles.credits -PathType Leaf)    { AddTextFileToTextbox -TextBox $CreditsTextBox -File $GameFiles.credits -Add -PreSpace 2 }

    # Icon
    if (Test-Path -LiteralPath $GameFiles.icon -PathType Leaf)       { $LanguagesDialog.Icon = $GameFiles.icon }
    else                                                             { $LanguagesDialog.Icon = $null }

    $CreditsGameLabel.Text = "Current Game: " + $GameType.mode
    $PatchPanel.Visible = $GameType.patches

    if ($GameType.mode -eq "Ocarina of Time") {
        CreateOoTOptionsContent
        CreateOoTReduxContent
    }
    elseif ($GameType.mode -eq "Majora's Mask") {
        CreateMMOptionsContent
        CreateMMReduxContent
    }
    elseif ($GameType.mode -eq "Super Mario 64")   { CreateSM64OptionsContent }

    if ($GameType.downgrade)      { $PatchVCDowngradeLabel.Visible = $PatchVCDowngrade.Visible = $True }
    if ($GameType.patch_vc -eq 2) { $PatchVCRemoveFilterLabel.Visible = $PatchVCRemoveFilter.Visible = $True }
    if ($GameType.patch_vc -eq 4) { $PatchVCLeaveDPadUpLabel.Visible = $PatchVCLeaveDPadUp.Visible = $True }
    if ($GameType.patch_vc -ge 3) {
        $PatchVCExpandMemoryLabel.Visible = $PatchVCExpandMemory.Visible = $True
        $PatchVCRemapDPadLabel.Visible = $PatchVCRemapDPad.Visible = $True
        $PatchVCMinimapLabel.Show() 
        $PatchVCRemapCDownLabel.Visible = $PatchVCRemapCDown.Visible = $True
        $PatchVCRemapZLabel.Visible = $PatchVCRemapZ.Visible = $True
    }

    SetWiiVCMode -Enable $IsWiiVC
    
}



#==============================================================================================================================================================================================
function UpdateStatusLabel([String]$Text) {
    
    if ($ExternalScript) { Write-Host $Text }
    $StatusLabel.Text = $Text
    $StatusLabel.Refresh()

}



#==============================================================================================================================================================================================
function SetModeLabel() {
	
    $CurrentModeLabel.Text = "Current  Mode  :  " + $GameType.mode
    if ($IsWiiVC) { $CurrentModeLabel.Text += "  (Wii  VC)" } else { $CurrentModeLabel.Text += "  (N64)" }
    $CurrentModeLabel.Location = New-Object System.Drawing.Size(([Math]::Floor($MainDialog.Width / 2) - [Math]::Floor($CurrentModeLabel.Width / 2)), 10)

}



#==================================================================================================================================================================================================================================================================
function EnablePatchButtons([Boolean]$Enable) {
    
    # Set the status that we are ready to roll... Or not...
    if ($Enable)        { UpdateStatusLabel -Text "Ready to patch!" }
    elseif ($IsWiiVC)   { UpdateStatusLabel -Text "Select your Virtual Console WAD file to continue." }
    else                { UpdateStatusLabel -Text "Select your Nintendo 64 ROM file to continue." }

    if ($IsWiiVC)      {
        $InjectROMButton.Enabled = ($Files.WAD -ne $null -and $Files.Z64 -ne $null)
        $PatchBPSButton.Enabled = ($Files.WAD -ne $null -and $Files.BPS -ne $null) } else { $PatchBPSButton.Enabled = ($Files.Z64 -ne $null -and $Files.BPS -ne $null)
   }
    
    # Enable patcher buttons.
    $PatchPanel.Enabled = $Enable

    # Enable ROM extract
    $ExtractROMButton.Enabled = $Enable

}



#==================================================================================================================================================================================================================================================================
function WADPath_Finish([Object]$TextBox, [String]$VarName, [String]$WADPath) {
    
    # Set the "GameWAD" variable that tracks the path.
    Set-Variable -Name $VarName -Value $WADPath -Scope 'Global'
    $Files.WAD = Get-Item -LiteralPath $WADPath

    # Update the textbox to the current WAD.
    $TextBox.Text = $WADPath

    ChangeGamesList
    SetWiiVCMode -Enable $True

    # Check if both a .WAD and .Z64 have been provided for ROM injection
    if ($Files.Z64 -ne $null) { $InjectROMButton.Enabled = $true }

    # Check if both a .WAD and .BPS have been provided for BPS patching
    if ($Files.BPS -ne $null) { $PatchBPSButton.Enabled = $true }

}



#==================================================================================================================================================================================================================================================================
function Z64Path_Finish([Object]$TextBox, [String]$VarName, [String]$Z64Path) {
    
    # Set the "Z64 ROM" variable that tracks the path.
    Set-Variable -Name $VarName -Value $Z64Path -Scope 'Global'
    $Files.Z64 = Get-Item -LiteralPath $Z64Path

    # Update hash
    $HashSumROMTextBox.Text = (Get-FileHash -Algorithm MD5 $Z64Path).Hash

    # Verify ROM
    $MatchingROMTextBox.Text = "No Valid ROM Selected"
    Foreach ($Item in $Files.json.games.game) {
        if ($HashSumROMTextBox.Text -eq $Item.hash) {
            $MatchingROMTextBox.Text = $Item.mode + " (Rev 0)"
            break
        }
        for ($i = 0; $i -lt $Item.downgrade.length; $i++) {
            if ($HashSumROMTextBox.Text -eq $Item.downgrade[$i].hash) {
                $MatchingROMTextBox.Text = $Item.mode + " (" +  $Item.downgrade[$i].rev + ")"
                break
            }
        }
    }

    # Update the textbox to the current WAD.
    $TextBox.Text = $Z64Path

    if (!$IsWiiVC) { EnablePatchButtons -Enable $True }
    
    # Check if both a .WAD and .Z64 have been provided for ROM injection or both a .Z64 and .BPS have been provided for BPS patching
    if ($Files.WAD -ne $null -and $IsWiiVC)        { $InjectROMButton.Enabled = $true }
    elseif ($Files.BPS -ne $null -and !$IsWiiVC)   { $PatchBPSButton.Enabled = $true }

}



#==================================================================================================================================================================================================================================================================
function BPSPath_Finish([Object]$TextBox, [String]$VarName, [String]$BPSPath) {
    
    # Set the "BPS File" variable that tracks the path.
    Set-Variable -Name $VarName -Value $BPSPath -Scope 'Global'
    $Files.BPS = Get-Item -LiteralPath $BPSPath

    # Update the textbox to the current WAD.
    $TextBox.Text = $BPSPath

    # Check if both a .WAD and Patch File have been provided for Patch File patching
    if ($Files.WAD -ne $null -and $IsWiiVC)        { $PatchBPSButton.Enabled = $true }
    elseif ($Files.Z64 -ne $null -and !$IsWiiVC)   { $PatchBPSButton.Enabled = $true }

}



#==============================================================================================================================================================================================
function GetHeader() {
    
    if ($IsWiiVC) {
        if (IsSet -Elem $GamePatch.wii_title)    { $CustomTitleTextBox.Text  = $GamePatch.wii_title }
        else                                     { $CustomTitleTextBox.Text  = $GameType.wii_title }
        if (IsSet -Elem $GamePatch.wii_gameID)   { $CustomGameIDTextBox.Text = $GamePatch.wii_gameID }
        else                                     { $CustomGameIDTextBox.Text = $GameType.wii_gameID }
    }
    else {
        if (IsSet -Elem $GamePatch.n64_title)    { $CustomTitleTextBox.Text  = $GamePatch.n64_title }
        else                                     { $CustomTitleTextBox.Text  = $GameType.n64_title }
        if (IsSet -Elem $GamePatch.n64_gameID)   { $CustomGameIDTextBox.Text = $GamePatch.n64_gameID }
        else                                     { $CustomGameIDTextBox.Text = $GameType.n64_gameID }
    }

}



#==============================================================================================================================================================================================
function IsChecked([Object]$Elem, [Switch]$Visible, [Switch]$Enabled, [Switch]$Not) {
    
    if (!(IsSet -Elem $Elem))              { return $False }
    if ($Visible -and !$Elem.Visible)      { return $False }
    if ($Enabled -and !$Elem.Enabled)      { return $False }
    if ($Not -and !$Elem.Checked)          { return $True }
    if (!$Not -and $Elem.Checked)          { return $True }
    return $False

}



#==============================================================================================================================================================================================
function IsText([Object]$Elem, [String]$Text, [Switch]$Visible, [Switch]$Enabled, [Switch]$Not) {
    
    if (!(IsSet -Elem $Elem))              { return $False }
    if ($Visible -and !$Elem.Visible)      { return $False }
    if ($Enabled -and !$Elem.Enabled)      { return $False }
    if ($Not -and $Elem.Text -ne $Text)    { return $True }
    if (!$Not -and $Elem.Text -eq $Text)   { return $True }
    return $False

}



#==============================================================================================================================================================================================
function IsSet([Object]$Elem, [int]$Min, [int]$Max, [int]$MinLength, [int]$MaxLength) {
    
    if ($Elem -eq $null -or $Elem -eq "" -or $Elem -eq 0) { return $False }
    if ($Min -ne $null -and $Min -ne "" -and $Elem -lt $Min) { return $False }
    if ($Max -ne $null -and $Max -ne "" -and $Elem -gt $Max) { return $False }
    if ($MinLength -ne $null -and $MinLength -ne "" -and $Elem.Length -lt $MinLength) { return $False }
    if ($MaxLength -ne $null -and $MaxLength -ne "" -and $Elem.Length -gt $MaxLength) { return $False }

    return $True

}



#==============================================================================================================================================================================================
function AddTextFileToTextbox([Object]$TextBox, [String]$File, [Switch]$Add, [int]$PreSpace, [int]$PostSpace) {
    
    if (!(IsSet -Elem $File)) {
        $TextBox.Text = ""
        return
    }

    if (Test-Path -LiteralPath $File -PathType Leaf) {
        $str = ""
        for ($i=0; $i -lt (Get-Content -Path $File).Count; $i++) {
            if ((Get-Content -Path $File)[$i] -ne "") {
                $str += (Get-Content -Path $File)[$i]
                if ($i -lt  (Get-Content -Path $File).Count-1) { $str += "{0}" }
            }
            else { $str += "{0}" }
        }

        if ($PreSpace -gt 0) {
            for ($i=0; $i -lt $PreSpace; $i++) { $str = "{0}" + $str }
        }
        if ($PostSpace -gt 0) {
            for ($i=0; $i -lt $PostSpace; $i++) { $str = $str + "{0}" }
        }

        $str = [String]::Format($str, [Environment]::NewLine)

        if ($Add) { $TextBox.Text += $str }
        else      { $TextBox.Text = $str }
    }

}



#==============================================================================================================================================================================================
function StrLike([String]$str, [String]$val) {
    
    if ($str.ToLower() -like "*" + $val + "*") { return $True }
    return $False

}



#==============================================================================================================================================================================================
function GetFilePaths() {
    
    if (IsSet $Settings["Core"][$InputWADTextBox.Name]) {
        if (Test-Path -LiteralPath $Settings["Core"][$InputWADTextBox.Name] -PathType Leaf) {
            WADPath_Finish $InputWADTextBox -VarName $InputWADTextBox.Name -WADPath $Settings["Core"][$InputWADTextBox.Name]
        }
        else { $InputWADTextBox.Text = "Select or drag and drop your Virtual Console WAD file..." }
    }

    if (IsSet $Settings["Core"][$InputROMTextBox.Name]) {
        if (Test-Path -LiteralPath $Settings["Core"][$InputROMTextBox.Name] -PathType Leaf) {
            Z64Path_Finish $InputROMTextBox -VarName $InputROMTextBox.Name -Z64Path $Settings["Core"][$InputROMTextBox.Name]
        }
        else { $InputROMTextBox.Text = "Select or drag and drop your Z64, N64 or V64 ROM..." }
    }

    if (IsSet $Settings["Core"][$InputBPSTextBox.Name]) {
        if (Test-Path -LiteralPath $Settings["Core"][$InputBPSTextBox.Name] -PathType Leaf) {	
            BPSPath_Finish $InputBPSTextBox -VarName $InputBPSTextBox.Name -BPSPath $Settings["Core"][$InputBPSTextBox.Name]
        }
        else { $InputBPSTextBox.Text = "Select or drag and drop your BPS, IPS, Xdelta, VCDiff or PPF Patch File..." }
    }

}



#==============================================================================================================================================================================================
function RestoreCustomGameID() {
    
    if (IsChecked $CustomHeaderCheckbox) {
        if (IsSet -Elem $Settings["Core"][$CustomTitleTextBox.Name]) {
            $CustomTitleTextBox.Text  = $Settings["Core"][$CustomTitleTextBox.Name]
        }
        if (IsSet -Elem $Settings["Core"][$CustomGameIDTextBox.Name]) {
            $CustomGameIDTextBox.Text = $Settings["Core"][$CustomGameIDTextBox.Name]
        }
    }
    else { GetHeader }

    $CustomGameIDTextBox.Enabled = $CustomTitleTextBox.Enabled = $CustomHeaderCheckbox.Checked

}



#==============================================================================================================================================================================================
function EnableGUI([Boolean]$Enable) {
    
    $InputWADPanel.Enabled = $InputROMPanel.Enabled = $InputBPSPanel.Enabled = $Enable
    $CurrentGamePanel.Enabled = $CustomGameIDPanel.Enabled = $Enable
    $PatchPanel.Enabled = $MiscPanel.Enabled = $PatchVCPanel.Enabled = $Enable

}



#==============================================================================================================================================================================================
function Get-FileName([String]$Path, [String[]]$Description, [String[]]$FileName) {
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $Path
    
    for($i = 0; $i -lt $FileName.Count; $i++) {
        $FilterString += $Description[$i] + '|' + $FileName[$i] + '|'
    }
    
    $OpenFileDialog.Filter = $FilterString.TrimEnd('|')
    $OpenFileDialog.ShowDialog() | Out-Null
    
    return $OpenFileDialog.FileName

}



#==============================================================================================================================================================================================
function RemovePath([String]$LiteralPath) {
    
    # Make sure the path isn't null to avoid errors.
    if ($LiteralPath -ne '') {
        # Check to see if the path exists.
        if (Test-Path -LiteralPath $LiteralPath) {
            # Remove the path.
            Remove-Item -LiteralPath $LiteralPath -Recurse -Force -ErrorAction 'SilentlyContinue' | Out-Null
        }
    }

}



#==============================================================================================================================================================================================
function CreatePath([String]$LiteralPath) {
    
    # Make sure the path is not null to avoid errors.
    if ($LiteralPath -ne '') {
        # Check to see if the path does not exist.
        if (!(Test-Path -LiteralPath $LiteralPath)) {
            # Create the path.
            New-Item -Path $LiteralPath -ItemType 'Directory' | Out-Null
        }
    }

    # Return the path so it can be set to a variable when creating.
    return $LiteralPath

}



#==============================================================================================================================================================================================
function TestPath([String]$LiteralPath, [String]$PathType = 'Any') {
    
    # Make sure the path is not null to avoid errors.
    if ($LiteralPath -ne '') {
        # Check to see if the path exists.
        if (Test-Path -LiteralPath $LiteralPath -PathType $PathType -ErrorAction 'SilentlyContinue') {
            # The path exists.
            return $True
        }
    }

    # The path is bunk.
    return $False

}



#==============================================================================================================================================================================================
function RemoveFile([String]$LiteralPath) {
    
    if (!(IsSet -Elem $LiteralPath)) { return }
    if (Test-Path -LiteralPath $LiteralPath -PathType Leaf) { Remove-Item -LiteralPath $LiteralPath -Force }

}



#==============================================================================================================================================================================================
function CreateSubPath([String]$Path) { if (!(Test-Path -LiteralPath $Path -PathType Container)) { New-Item -Path $Path.substring(0, $Path.LastIndexOf('\')) -Name $Path.substring($Path.LastIndexOf('\') + 1) -ItemType Directory | Out-Null } }



#==============================================================================================================================================================================================
function ShowPowerShellConsole([bool]$ShowConsole) {
    
    # Sshows or hide the console window
    switch ($ShowConsole) {
        $True   { [Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 5) | Out-Null }
        $False  { [Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 0) | Out-Null }
    }

}



#==================================================================================================================================================================================================================================================================
function TogglePowerShellOpenWithClicks([Boolean]$Enable) {
    
    # Create a temporary folder to create the registry entry and and set the path to it
    RemovePath -LiteralPath $Paths.Registry
    CreatePath -LiteralPath $Paths.Registry
    $RegFile = $Paths.Registry + "\Double Click.reg"

    # Create the registry file.
    Add-Content -LiteralPath $RegFile -Value 'Windows Registry Editor Version 5.00'
    Add-Content -LiteralPath $RegFile -Value ''
    Add-Content -LiteralPath $RegFile -Value '[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Microsoft.PowerShellScript.1\Shell]'

    # Get the current state of the value in the registry.
    $PS_DC_State = (Get-ItemProperty -LiteralPath "HKLM:\Software\Classes\Microsoft.PowerShellScript.1\Shell").'(default)'

    # Check the current state and add the value to the registry
    switch ($PS_DC_State) {
        # A "0" means that a script won't automatically launch with PowerShell so change it to "Open"
        '0'     { Add-Content -LiteralPath $RegFile -Value '@="Open"' }
        default { Add-Content -LiteralPath $RegFile -Value '@="0"' }
    }

    #if (!$Enable) { Add-Content -LiteralPath $RegFile -Value '@="Open"' }
    #else          { Add-Content -LiteralPath $RegFile -Value '@="0"' }

    # Execute the registry file.
    & regedit /s $RegFile

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function SetWiiVCMode
Export-ModuleMember -Function CreateToolTip
Export-ModuleMember -Function ChangeGamesList
Export-ModuleMember -Function ChangePatchPanel
Export-ModuleMember -Function SetMainScreenSize
Export-ModuleMember -Function ChangeGameMode
Export-ModuleMember -Function UpdateStatusLabel
Export-ModuleMember -Function SetModeLabel
Export-ModuleMember -Function EnablePatchButtons

Export-ModuleMember -Function WADPath_Finish
Export-ModuleMember -Function Z64Path_Finish
Export-ModuleMember -Function BPSPath_Finish

Export-ModuleMember -Function GetHeader
Export-ModuleMember -Function IsChecked
Export-ModuleMember -Function IsText
Export-ModuleMember -Function IsSet
Export-ModuleMember -Function AddTextFileToTextbox
Export-ModuleMember -Function StrLike
Export-ModuleMember -Function GetFilePaths
Export-ModuleMember -Function RestoreCustomGameID
Export-ModuleMember -Function EnableGUI

Export-ModuleMember -Function Get-FileName
Export-ModuleMember -Function RemoveFile
Export-ModuleMember -Function RemovePath
Export-ModuleMember -Function CreatePath
Export-ModuleMember -Function TestPath
Export-ModuleMember -Function RemoveFile
Export-ModuleMember -Function CreateSubPath

Export-ModuleMember -Function ShowPowerShellConsole
Export-ModuleMember -Function TogglePowerShellOpenWithClicks