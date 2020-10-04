function CreateLanguagesDialog() {

    # Create Dialog
    $global:LanguagesDialog = CreateDialog -Width 560 -Height 310
    $CloseButton = CreateButton -X ($LanguagesDialog.Width / 2 - 40) -Y ($LanguagesDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $LanguagesDialog
    $CloseButton.Add_Click({ $LanguagesDialog.Hide() })

    # Box
    $global:Languages = @{}
    $Languages.Box     = CreateReduxGroup -Y 10 -Height 2 -AddTo $LanguagesDialog -Text "Languages"
    $Languages.Panel   = CreateReduxPanel -Row 0 -Rows 2 -AddTo $Languages.Box
    $Languages.TextBox = CreateReduxGroup -Y ($Languages.Box.Bottom + 5) -Height 3 -AddTo $LanguagesDialog -Text "English Text"

}



#==============================================================================================================================================================================================
function CreateOptionsDialog([int]$Width, [int]$Height) {
    
    # Create Dialog
    if ( (IsSet -Elem $Width) -and (IsSet -Elem $Height) )   { $global:OptionsDialog = CreateDialog -Width $Width -Height $Height }
    else                                                     { $global:OptionsDialog = CreateDialog -Width 900 -Height 640 }

    # Close Button
    $CloseButton = CreateButton -X ($OptionsDialog.Width / 2 - 40) -Y ($OptionsDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $OptionsDialog
    $CloseButton.Add_Click( {$OptionsDialog.Hide() })

    # Options Label
    $global:OptionsLabel = CreateLabel -X 30 -Y 20 -Width 300 -Height 15 -Font $VCPatchFont -AddTo $OptionsDialog

    # Options
    $global:Options = @{}
    $Options.Panel = CreatePanel -Width $OptionsDialog.Width -Height $OptionsDialog.Height -AddTo $OptionsDialog

    # Icon
    if (Test-Path -LiteralPath $GameFiles.icon -PathType Leaf)       { $OptionsDialog.Icon = $GameFiles.icon }
    else                                                             { $OptionsDialog.Icon = $null }

}



#==============================================================================================================================================================================================
function CreateReduxDialog([int]$Width, [int]$Height) {
    
    # Create Dialog
    if ( (IsSet -Elem $Width) -and (IsSet -Elem $Height) )   { $global:ReduxDialog = CreateDialog -Width $Width -Height $Height }
    else                                                     { $global:ReduxDialog = CreateDialog -Width 900 -Height 640 }

    # Close Button
    $CloseButton = CreateButton -X ($ReduxDialog.Width / 2 - 40) -Y ($ReduxDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $ReduxDialog
    $CloseButton.Add_Click( {$ReduxDialog.Hide() })

    # Options Label
    $global:ReduxLabel = CreateLabel -X 30 -Y 20 -Width 300 -Height 15 -Font $VCPatchFont -AddTo $ReduxDialog

    # Options
    $global:Redux = @{}
    $Redux.Panel = CreatePanel -Width $ReduxDialog.Width -Height $ReduxDialog.Height -AddTo $ReduxDialog

    # Icon
    if (Test-Path -LiteralPath $GameFiles.icon -PathType Leaf)       { $ReduxDialog.Icon = $GameFiles.icon }
    else                                                             { $ReduxDialog.Icon = $null }

}



#==============================================================================================================================================================================================
function CreateCreditsDialog() {
    
    # Create Dialog
    $global:CreditsDialog = CreateDialog -Width 650 -Height 550 -Icon $Files.icon.credits
    $CloseButton = CreateButton -X ($CreditsDialog.Width / 2 - 40) -Y ($CreditsDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $CreditsDialog
    $CloseButton.Add_Click({ $CreditsDialog.Hide() })

    # Create a tooltip
    $ToolTip = CreateToolTip

    # Create the current game label.
    $global:CreditsGameLabel = CreateLabel -X 40 -Y 50 -Width 200 -Height 15 -Font $VCPatchFont -AddTo $CreditsDialog

    # Create Switch subpanel buttons
    $CreditsButton = CreateButton 40 -Y 80 -Width 80 -Height 20 -Text "Credits" -ToolTip $ToolTip -Info "Check the credits for this game" -AddTo $CreditsDialog
    $CreditsButton.Add_Click({
        $InfoTextBox.Visible = $GameIDTextBox.Visible = $CreditsMiscPanel.Visible = $CreditsChecksumPanel.Visible = $False
        $CreditsTextBox.Show()
    })
    
    $InfoButton = CreateButton ($CreditsButton.Right + 10) -Y $CreditsButton.Top -Width $CreditsButton.Width -Height $CreditsButton.Height -Text "Info" -ToolTip $ToolTip -Info "Check the info for this game" -AddTo $CreditsDialog
    $InfoButton.Add_Click({
        $CreditsTextBox.Visible = $GameIDTextBox.Visible = $CreditsMiscPanel.Visible = $CreditsChecksumPanel.Visible = $False
        $InfoTextBox.Show()
    })

    $GameIDButton = CreateButton ($InfoButton.Right + 10) -Y $CreditsButton.Top -Width $CreditsButton.Width -Height $CreditsButton.Height -Text "GameID's" -ToolTip $ToolTip -Info "Open the list with official and patched GameID's" -AddTo $CreditsDialog
    $GameIDButton.Add_Click({
        $CreditsTextBox.Visible = $InfoTextBox.Visible = $CreditsMiscPanel.Visible = $CreditsChecksumPanel.Visible = $False
        $GameIDTextBox.Show()
    })

    $MiscButton = CreateButton ($GameIDButton.Right + 10) -Y $CreditsButton.Top -Width $CreditsButton.Width -Height $CreditsButton.Height -Text "Misc" -ToolTip $ToolTip -Info "General credits and info in general" -AddTo $CreditsDialog
    $MiscButton.Add_Click({
        $CreditsTextBox.Visible = $InfoTextBox.Visible = $GameIDTextBox.Visible = $CreditsChecksumPanel.Visible = $False
        $CreditsMiscPanel.Show()
    })

    $ChecksumButton = CreateButton ($MiscButton.Right + 10) -Y $CreditsButton.Top -Width $CreditsButton.Width -Height $CreditsButton.Height -Text "Checksum" -ToolTip $ToolTip -Info "General credits and info in general" -AddTo $CreditsDialog
    $ChecksumButton.Add_Click({
        $CreditsTextBox.Visible = $InfoTextBox.Visible = $GameIDTextBox.Visible = $CreditsMiscPanel.Visible = $False
        $CreditsChecksumPanel.Show()
    })


    # Create the version number and script name label.
    $InfoLabel = CreateLabel -X ($CreditsDialog.Width / 2 - $String.Width - 100) -Y 10 -Width 200 -Height 15 -Font $VCPatchFont -Text ($ScriptName + " " + $Version + " (" + $VersionDate + ")") -AddTo $CreditsDialog

    # Create Text Box
    $global:CreditsTextBox = CreateTextBox -X 40 -Y ($CreditsButton.Bottom + 10) -Width ($CreditsDialog.Width - 100) -Height ($CloseButton.Top - 120) -ReadOnly -Multiline -AddTo $CreditsDialog
    $global:InfoTextBox = CreateTextBox -X $CreditsTextBox.Left -Y $CreditsTextBox.Top -Width $CreditsTextBox.Width -Height $CreditsTextBox.Height -ReadOnly -Multiline -AddTo $CreditsDialog
    $global:GameIDTextBox = CreateTextBox $CreditsTextBox.Left -Y $CreditsTextBox.Top -Width $CreditsTextBox.Width -Height $CreditsTextBox.Height -ReadOnly -Multiline -AddTo $CreditsDialog
    AddTextFileToTextbox -TextBox $GameIDTextBox -File $Files.text.gameID
    $global:CreditsMiscPanel = CreatePanel $CreditsTextBox.Left -Y $CreditsTextBox.Top -Width $CreditsTextBox.Width -Height $CreditsTextBox.Height -AddTo $CreditsDialog
    $global:CreditsChecksumPanel = CreatePanel $CreditsTextBox.Left -Y $CreditsTextBox.Top -Width $CreditsTextBox.Width -Height $CreditsTextBox.Height -AddTo $CreditsDialog

    $InfoTextBox.Hide()



    # Support

    $SupportLabel  = CreateLabel -X 10                   -Y 10                          -Width 200 -Height 15 -Font $VCPatchFont -Text ("--- Support or visit me at ---") -AddTo $CreditsMiscPanel

    $Discord1Label = CreateLabel -X 10                   -Y ($SupportLabel.Bottom + 2)  -Width 150 -Height 15 -Font $VCPatchFont -Text ("Discord")                          -AddTo $CreditsMiscPanel
    $Discord2Label = CreateLabel -X $Discord1Label.Right -Y ($SupportLabel.Bottom + 2)  -Width 140 -Height 15 -Font $URLFont     -Text ("https://discord.gg/P22GGzz")       -AddTo $CreditsMiscPanel
    $GitHub1Label  = CreateLabel -X 10                   -Y ($Discord1Label.Bottom + 2) -Width 150 -Height 15 -Font $VCPatchFont -Text ("GitHub")                           -AddTo $CreditsMiscPanel
    $GitHub2Label  = CreateLabel -X $GitHub1Label.Right  -Y ($Discord1Label.Bottom + 2) -Width 180 -Height 15 -Font $URLFont     -Text ("https://github.com/Admentus64")    -AddTo $CreditsMiscPanel
    
    $Patreon1Label = CreateLabel -X 10                   -Y ($GitHub1Label.Bottom + 2)  -Width 150 -Height 15 -Font $VCPatchFont -Text ("Patreon")                          -AddTo $CreditsMiscPanel
    $Patreon2Label = CreateLabel -X $Patreon1Label.Right -Y ($GitHub1Label.Bottom + 2)  -Width 145 -Height 15 -Font $URLFont     -Text ("www.patreon.com/Admentus")         -AddTo $CreditsMiscPanel
    $PayPal1Label  = CreateLabel -X 10                   -Y ($Patreon1Label.Bottom + 2) -Width 150 -Height 15 -Font $VCPatchFont -Text ("PayPal")                           -AddTo $CreditsMiscPanel
    $PayPal2Label  = CreateLabel -X $PayPal1Label.Right  -Y ($Patreon1Label.Bottom + 2) -Width 190 -Height 15 -Font $URLFont     -Text ("www.paypal.com/paypalme/Admentus") -AddTo $CreditsMiscPanel

    $Discord2Label.add_Click({[system.Diagnostics.Process]::start("https://discord.gg/P22GGzz")})
    $GitHub2Label.add_Click({[system.Diagnostics.Process]::start("https://github.com/Admentus64")})
    $Patreon2Label.add_Click({[system.Diagnostics.Process]::start("https://www.patreon.com/Admentus")})
    $PayPal2Label.add_Click({[system.Diagnostics.Process]::start("https://www.paypal.com/paypalme/Admentus/")})
    $Discord2Label.ForeColor = $GitHub2Label.ForeColor = $Patreon2Label.ForeColor = $PayPal2Label.ForeColor = "Blue"



    # Documentation

    $SourcesLabel  = CreateLabel -X 10                  -Y ($PayPal2Label.Bottom + 10) -Width 150 -Height 15 -Font $VCPatchFont -Text ("--- Sources ---")                                              -AddTo $CreditsMiscPanel
    
    $Shadow1Label  = CreateLabel -X 10                  -Y ($SourcesLabel.Bottom + 2)  -Width 150  -Height 15 -Font $VCPatchFont -Text ("ShadowOne333's GitHub")                                       -AddTo $CreditsMiscPanel
    $Shadow2Label  = CreateLabel -X $Shadow1Label.Right -Y ($SourcesLabel.Bottom + 2)  -Width 330  -Height 15 -Font $URLFont     -Text ("https://github.com/ShadowOne333/Zelda64-Redux-Documentation") -AddTo $CreditsMiscPanel
    
    $Skilar1Label  = CreateLabel -X 10                  -Y ($Shadow1Label.Bottom + 2)  -Width 150  -Height 15 -Font $VCPatchFont -Text ("Skilarbabcock's YouTube")                                     -AddTo $CreditsMiscPanel
    $Skilar2Label  = CreateLabel -X $Skilar1Label.Right -Y ($Shadow1Label.Bottom + 2)  -Width 225  -Height 15 -Font $URLFont     -Text ("https://www.youtube.com/user/skilarbabcock")                  -AddTo $CreditsMiscPanel

    $Shadow2Label.add_Click({[system.Diagnostics.Process]::start("https://github.com/ShadowOne333/Zelda64-Redux-Documentation")})
    $Skilar2Label.add_Click({[system.Diagnostics.Process]::start("https://www.youtube.com/user/skilarbabcock")})
    $Shadow2Label.ForeColor = $Skilar2Label.ForeColor = "Blue"



    # Hash
    $HashSumROMLabel          = CreateLabel   -X 10 -Y 20 -Width 120 -Height 15 -Font $VCPatchFont -Text "N64 ROM Hashsum:" -AddTo $CreditsChecksumPanel
    $global:HashSumROMTextBox = CreateTextBox -X $HashSumROMLabel.Right -Y ($HashSumROMLabel.Top - 3) -Width ($CreditsChecksumPanel.Width -$HashSumROMLabel.Width - 100) -Height 50 -AddTo $CreditsChecksumPanel
    $HashSumROMTextBox.ReadOnly = $True

    # Matching Hash
    $MatchingROMLabel          = CreateLabel   -X 10 -Y ($HashSumROMTextBox.Bottom + 10) -Width 120 -Height 15 -Font $VCPatchFont -Text "Current Z64 ROM:" -AddTo $CreditsChecksumPanel
    $global:MatchingROMTextBox = CreateTextBox -X $MatchingROMLabel.Right -Y ($MatchingROMLabel.Top - 3) -Width ($CreditsChecksumPanel.Width -$MatchingROMLabel.Width - 100) -Height 50 -Text "No ROM Selected" -AddTo $CreditsChecksumPanel
    $MatchingROMTextBox.ReadOnly = $True

}



#==============================================================================================================================================================================================
function CreateSettingsDialog() {
    
    # Create Dialog
    $global:SettingsDialog = CreateDialog -Width 600 -Height 460 -Icon $Files.icon.settings
    $CloseButton = CreateButton -X ($SettingsDialog.Width / 2 - 40) -Y ($SettingsDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $SettingsDialog
    $CloseButton.Add_Click({ $SettingsDialog.Hide() })

    # Create a tooltip
    $ToolTip = CreateToolTip

    # Create the version number and script name label.
    $InfoLabel = CreateLabel -X ($SettingsDialog.Width / 2 - $String.Width - 100) -Y 10 -Width 200 -Height 15 -Font $VCPatchFont -Text ($ScriptName + " " + $Version + " (" + $VersionDate + ")") -AddTo $SettingsDialog

    $global:GeneralSettings = @{}

    # General Settings
    $GeneralSettings.GeneralBox        = CreateReduxGroup -Y 40 -Height 1 -AddTo $SettingsDialog -Text "General Settings"

    $GeneralSettings.Bit64             = CreateSettingsCheckbox -Column 0 -Row 1 -AddTo $GeneralSettings.GeneralBox -Text "Use 64-Bit Tools" -Checked ([Environment]::Is64BitOperatingSystem) -ToolTip $ToolTip -Info "Use 64-bit tools instead of 32-bit tools if available for patching ROMs" -Name "64Bit"
    $GeneralSettings.DoubleClick       = CreateSettingsCheckbox -Column 1 -Row 1 -AddTo $GeneralSettings.GeneralBox -Text "Double Click"     -ToolTip $ToolTip -Info "Allows a PowerShell file to be opened by double-clicking it"
    $GeneralSettings.DoubleClick.Checked = ((Get-ItemProperty -LiteralPath "HKLM:\Software\Classes\Microsoft.PowerShellScript.1\Shell").'(default)' -eq '0')

    # Advanced Settings
    $GeneralSettings.AdvancedBox       = CreateReduxGroup -Y ($GeneralSettings.GeneralBox.Bottom + 10) -Height 1 -AddTo $SettingsDialog -Text "Advanced Settings"
    $GeneralSettings.IgnoreChecksum    = CreateSettingsCheckbox -Column 0 -Row 1 -AddTo $GeneralSettings.AdvancedBox -Text "Ignore Input Checksum" -IsDebug -ToolTip $ToolTip -Info "Do not check the checksum of a ROM or WAD and patch it regardless" -Name "IgnoreChecksum"
    $GeneralSettings.KeepLogo          = CreateSettingsCheckbox -Column 1 -Row 1 -AddTo $GeneralSettings.AdvancedBox -Text "Keep Logo"             -IsDebug -ToolTip $ToolTip -Info "Keep the vanilla title logo instead of the Master Quest title logo" -Name "KeepLogo"

    # Debug Settings
    $GeneralSettings.DebugBox          = CreateReduxGroup -Y ($GeneralSettings.AdvancedBox.Bottom + 10) -Height 3 -AddTo $SettingsDialog -Text "Debug Settings"
    $GeneralSettings.Console           = CreateSettingsCheckbox -Column 0 -Row 1 -AddTo $GeneralSettings.DebugBox -Text "Console"               -IsDebug -ToolTip $ToolTip -Info "Show the console log" -Name "Console"
    $GeneralSettings.Stop              = CreateSettingsCheckbox -Column 1 -Row 1 -AddTo $GeneralSettings.DebugBox -Text "Stop Patching"         -IsDebug -ToolTip $ToolTip -Info "Do not start the patching process and instead show debug information for the console log" -Name "Stop"
    $GeneralSettings.CreateBPS         = CreateSettingsCheckbox -Column 2 -Row 1 -AddTo $GeneralSettings.DebugBox -Text "Create BPS"            -IsDebug -ToolTip $ToolTip -Info "Create compressed and decompressed BPS patches when patching is concluded" -Name "CreateBPS"
    $GeneralSettings.KeepDecompressed  = CreateSettingsCheckbox -Column 0 -Row 2 -AddTo $GeneralSettings.DebugBox -Text "Keep Decompressed"     -IsDebug -ToolTip $ToolTip -Info "Keep the decompressed patched ROM in the output folder" -Name "KeepDecompressed"
    $GeneralSettings.Rev0DungeonFiles  = CreateSettingsCheckbox -Column 1 -Row 2 -AddTo $GeneralSettings.DebugBox -Text "Rev 0 Dungeon Files"   -IsDebug -ToolTip $ToolTip -Info "Extract the dungeon files from the Rev 0 US OoT ROM as well when extracting dungeon files" -Name "Rev0DungeonFiles"
    $GeneralSettings.NoHeaderChange    = CreateSettingsCheckbox -Column 2 -Row 2 -AddTo $GeneralSettings.DebugBox -Text "No Header Change"      -IsDebug -ToolTip $ToolTip -Info "Do not change the title header of the ROM when patching is concluded" -Name "NoHeaderChange"
    $GeneralSettings.NoCRCChange       = CreateSettingsCheckbox -Column 0 -Row 3 -AddTo $GeneralSettings.DebugBox -Text "No CRC Change"         -IsDebug -ToolTip $ToolTip -Info "Do not change the CRC of the ROM when patching is concluded" -Name "NoCRCChange"
    
    $GeneralSettings.Console.Add_CheckStateChanged({ ShowPowerShellConsole -ShowConsole $this.Checked })
    $GeneralSettings.DoubleClick.Add_CheckStateChanged({ TogglePowerShellOpenWithClicks -Enable $this.Checked })

    # Create a button to reset the tool.
    $GeneralSettings.ResetBox          = CreateReduxGroup -Y ($GeneralSettings.DebugBox.Bottom + 10) -Height 2 -AddTo $SettingsDialog -Text "Reset"
    $GeneralSettings.ResetButton       = CreateReduxButton -Column 0 -Row 1 -Width 150 -Height 45 -AddTo $GeneralSettings.ResetBox -Text "Reset All Settings" -ToolTip $ToolTip -Info ("Resets all settings stored in the " + $ScriptName)
    $GeneralSettings.ResetButton.Add_Click({ ResetTool })

    # Disable Stop if no Console
    $GeneralSettings.Console.Add_CheckStateChanged({ $GeneralSettings.Stop.Enabled = $this.Checked })
    $GeneralSettings.Stop.Enabled = $GeneralSettings.Console.Checked

}



#==============================================================================================================================================================================================
function CreateSettingsCheckbox([int]$Column=0, [int]$Row=0, [Object]$AddTo, [Boolean]$Checked, [Switch]$Disable, [String]$Text="", [Object]$ToolTip, [String]$Info="", [String]$Name, [Switch]$IsDebug) {
    
    $Checkbox = CreateCheckbox -X ($Column * 165 + 15) -Y ($Row * 30 - 10) -Checked $Checked -Disable $Disable -IsRadio $False -ToolTip $ToolTip -Info $Info -IsDebug $IsDebug -Name $Name -AddTo $AddTo
    $Label = CreateLabel -X $CheckBox.Right -Y ($CheckBox.Top + 3) -Width 135 -Height 15 -Text $Text -ToolTip $ToolTip -Info $Info -AddTo $AddTo
    
    if (IsSet -Elem $Name) {
        if ($IsDebug) { $Checkbox.Add_CheckStateChanged({ $Settings["Debug"][$this.Name] = $this.Checked }) }
        else          { $Checkbox.Add_CheckStateChanged({ $Settings["Core"][$this.Name] = $this.Checked }) }
    }

    return $CheckBox

}



#==============================================================================================================================================================================================
function CreateErrorDialog([String]$Error, [Switch]$Exit) {
    
    # Create Dialog
    $ErrorDialog = CreateDialog -Width 300 -Height 200 -Icon $null

    $CloseButton = CreateButton -X ($ErrorDialog.Width / 2 - 40) -Y ($ErrorDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $ErrorDialog
    $CloseButton.Add_Click({ $ErrorDialog.Hide() })

    # Create the string that will be displayed on the window.
    $String = $ScriptName + " " + $Version + " (" + $VersionDate + ")" + "{0}{0}"

    if ($Error -eq "Missing Files")         { $String += "Neccessary files are missing.{0}" }
    elseif ($Error -eq "Missing JSON")      { $String += "Games.json or Patches.json files are missing.{0}" }
    elseif ($Error -eq "Corrupted JSON")    { $String += "Games.json or Patches.json files are corrupted.{0}" }
    elseif ($Error -eq "Missing Modules")   { $String += ".PSM1 module files are missing for import.{0}" }

    $String += "{0}"
    $String += "Please download the Patcher64+ Tool again."

    $String = [String]::Format($String, [Environment]::NewLine)

    #Create Label
    $Label = CreateLabel -X 10 -Y 10 -Width ($ErrorDialog.Width-10) -Height ($ErrorDialog.Height - 110) -Text $String -AddTo $ErrorDialog

    if (IsSet -Elem $MainDialog) { $MainDialog.Hide() }
    $ErrorDialog.ShowDialog() | Out-Null
    if ($Exit -eq $True) { Exit }

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function CreateLanguagesDialog
Export-ModuleMember -Function CreateOptionsDialog
Export-ModuleMember -Function CreateReduxDialog
Export-ModuleMember -Function CreateCreditsDialog
Export-ModuleMember -Function CreateSettingsDialog
Export-ModuleMember -Function CreateErrorDialog