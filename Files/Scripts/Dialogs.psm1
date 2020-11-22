function CreateOptionsDialog([int]$Width, [int]$Height, [Array]$Tabs=@()) {
    
    # Create Dialog
    if ( (IsSet -Elem $Width) -and (IsSet -Elem $Height) )   { $global:OptionsDialog = CreateDialog -Width $Width -Height $Height }
    else                                                     { $global:OptionsDialog = CreateDialog -Width 900 -Height 640 }
    $OptionsDialog.Icon = $Files.icon.additional

    # Close Button
    $CloseButton = CreateButton -X ($OptionsDialog.Width / 2 - 40) -Y ($OptionsDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $OptionsDialog
    $CloseButton.Add_Click( {$OptionsDialog.Hide() })

    # Options Label
    $global:OptionsLabel = CreateLabel -Y 15 -Width $OptionsDialog.width -Height 15 -Font $VCPatchFont -Text ($GameType.mode + " - Additional Options") -AddTo $OptionsDialog
    $OptionsLabel.AutoSize = $True
    $OptionsLabel.Left = ([Math]::Floor($OptionsDialog.Width / 2) - [Math]::Floor($OptionsLabel.Width / 2))

    # Options
    $global:Redux = @{}
    $Redux.Box = @{}
    $Redux.Groups = @()
    $Redux.Panel = CreatePanel -Width $OptionsDialog.Width -Height $OptionsDialog.Height -AddTo $OptionsDialog

    # Reset
    $Last.Group = $Last.Panel = $Last.GroupName = $null

    CreateTabButtons -Tabs $Tabs

}



#==============================================================================================================================================================================================
function CreateLanguageContent($Columns=3) {
    
    # Box + Panel
    CreateReduxGroup -Text "Languages" -Tag "Language"
    $Last.Group.IsLanguage = $True
    CreateReduxPanel

    if (IsSet -Elem $GamePatch.languages -MinLength 0) {
        $Row = 0
        for ($i=0; $i -lt $GamePatch.languages.Length; $i++) {
            if ($i % $Columns -ne 0) { $Column += 1 }
            else {
                $Column = 0
                $Row += 1
            }
            $Redux.Language[$i] = CreateReduxRadioButton -Column ($Column+1) -Row $Row -Text $GamePatch.languages[$i].title -Info ("Play the game in " + $GamePatch.languages[$i].title) -Name $GamePatch.languages[$i].title
        }
    
        $HasDefault = $False
        for ($i=0; $i -lt $GamePatch.languages.Length; $i++) {
            if ($Redux.Language[$i].Checked) {
                $HasDefault = $True
                break
            }
        }
        if (!$HasDefault) { $Redux.Language[0].Checked = $True }
    }

}



#==============================================================================================================================================================================================
function CreateCreditsDialog() {
    
    # Create Dialog
    $global:CreditsDialog = CreateDialog -Width 650 -Height 550 -Icon $Files.icon.credits
    $CloseButton = CreateButton -X ($CreditsDialog.Width / 2 - 40) -Y ($CreditsDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $CreditsDialog
    $CloseButton.Add_Click({ $CreditsDialog.Hide() })

    # Create the current game label
    $global:CreditsGameLabel = CreateLabel -X 40 -Y 50 -Width 200 -Height 15 -Font $VCPatchFont -AddTo $CreditsDialog

    # Create Switch subpanel buttons
    $global:Credits = @{}
    $Credits.Buttons = @()
    $Credits.Buttons += CreateButton -X 40  -Y 70 -Width 110 -Height 30 -ForeColor "White" -BackColor "Gray" -Text "Credits" -Tag $Credits.Buttons.Count -Info "Check the credits for this game" -AddTo $CreditsDialog
    $Credits.Buttons += CreateButton -X ($Credits.Buttons[0].Right) -Y $Credits.Buttons[0].Top -Width $Credits.Buttons[0].Width -Height $Credits.Buttons[0].Height -ForeColor "White" -BackColor "Gray" -Text "Info"     -Tag $Credits.Buttons.Count -Info "Check the info for this game" -AddTo $CreditsDialog
    $Credits.Buttons += CreateButton -X ($Credits.Buttons[1].Right) -Y $Credits.Buttons[0].Top -Width $Credits.Buttons[0].Width -Height $Credits.Buttons[0].Height -ForeColor "White" -BackColor "Gray" -Text "GameID's" -Tag $Credits.Buttons.Count -Info "Open the list with official and patched GameID's" -AddTo $CreditsDialog
    $Credits.Buttons += CreateButton -X ($Credits.Buttons[2].Right) -Y $Credits.Buttons[0].Top -Width $Credits.Buttons[0].Width -Height $Credits.Buttons[0].Height -ForeColor "White" -BackColor "Gray" -Text "Misc"     -Tag $Credits.Buttons.Count -Info "General credits and info in general" -AddTo $CreditsDialog
    $Credits.Buttons += CreateButton -X ($Credits.Buttons[3].Right) -Y $Credits.Buttons[0].Top -Width $Credits.Buttons[0].Width -Height $Credits.Buttons[0].Height -ForeColor "White" -BackColor "Gray" -Text "Checksum" -Tag $Credits.Buttons.Count -Info "General credits and info in general" -AddTo $CreditsDialog
    
    # Create the version number and script name label
    $InfoLabel = CreateLabel -X ($CreditsDialog.Width / 2 - $String.Width - 100) -Y 10 -Width 200 -Height 15 -Font $VCPatchFont -Text ($ScriptName + " " + $Version + " (" + $VersionDate + ")") -AddTo $CreditsDialog

    # Create Text Box
    $Credits.Sections = @()
    $Credits.Sections += CreateTextBox -X 40 -Y ($Credits.Buttons[0].Bottom + 10) -Width ($CreditsDialog.Width - 100) -Height ($CloseButton.Top - 120) -ReadOnly -Multiline -AddTo $CreditsDialog -Tag "Credits"
    $Credits.Sections += CreateTextBox -X $Credits.Sections[0].Left -Y $Credits.Sections[0].Top -Width $Credits.Sections[0].Width -Height $Credits.Sections[0].Height -ReadOnly -Multiline -AddTo $CreditsDialog -Tag "Info"
    $Credits.Sections += CreateTextBox -X $Credits.Sections[0].Left -Y $Credits.Sections[0].Top -Width $Credits.Sections[0].Width -Height $Credits.Sections[0].Height -ReadOnly -Multiline -AddTo $CreditsDialog -Tag "GameID's"
    AddTextFileToTextbox -TextBox $Credits.Sections[2] -File $Files.text.gameID
    $Credits.Sections += CreatePanel   -X $Credits.Sections[0].Left -Y $Credits.Sections[0].Top -Width $Credits.Sections[0].Width -Height $Credits.Sections[0].Height -AddTo $CreditsDialog -Tag "Misc"
    $Credits.Sections += CreatePanel   -X $Credits.Sections[0].Left -Y $Credits.Sections[0].Top -Width $Credits.Sections[0].Width -Height $Credits.Sections[0].Height -AddTo $CreditsDialog -Tag "Checksum"

    # Initialize Button Events
    for ($i=0; $i -lt $Credits.Buttons.length; $i++) {
        $Credits.Buttons[$i].Add_Click({
            $Credits.Buttons.GetEnumerator()  | ForEach-Object { $_.BackColor = "Gray" }
            $Credits.Sections.GetEnumerator() | ForEach-Object { $_.Visible = $_.Tag -eq $this.Text }
            $this.BackColor = "DarkGray"
            $Settings["Core"]["LastTab"] = $this.Tag
        })
        if ($i -gt 0) { $Credits.Sections[$i].Visible = $False }
    }

    # Set last tab
    if (IsSet -Elem $Settings["Core"]["LastTab"]) {
        $Credits.Buttons[$Settings["Core"]["LastTab"]].BackColor = "DarkGray"
        $Credits.Sections.GetEnumerator() | ForEach-Object { $_.Visible = $_.Tag -eq $Credits.Buttons[$Settings["Core"]["LastTab"]].Text }
    }
    else { $Credits.Buttons[0].BackColor = "DarkGray" }



    # Support
    $SupportLabel  = CreateLabel -X 10                   -Y 10                          -Width 200 -Height 15 -Font $VCPatchFont -Text ("--- Support or visit me at ---")   -AddTo $Credits.Sections[3]

    $Discord1Label = CreateLabel -X 10                   -Y ($SupportLabel.Bottom + 2)  -Width 150 -Height 15 -Font $VCPatchFont -Text ("Discord")                          -AddTo $Credits.Sections[3]
    $Discord2Label = CreateLabel -X $Discord1Label.Right -Y ($SupportLabel.Bottom + 2)  -Width 140 -Height 15 -Font $URLFont     -Text ("https://discord.gg/P22GGzz")       -AddTo $Credits.Sections[3]
    $GitHub1Label  = CreateLabel -X 10                   -Y ($Discord1Label.Bottom + 2) -Width 150 -Height 15 -Font $VCPatchFont -Text ("GitHub")                           -AddTo $Credits.Sections[3]
    $GitHub2Label  = CreateLabel -X $GitHub1Label.Right  -Y ($Discord1Label.Bottom + 2) -Width 180 -Height 15 -Font $URLFont     -Text ("https://github.com/Admentus64")    -AddTo $Credits.Sections[3]
    
    $Patreon1Label = CreateLabel -X 10                   -Y ($GitHub1Label.Bottom + 2)  -Width 150 -Height 15 -Font $VCPatchFont -Text ("Patreon")                          -AddTo $Credits.Sections[3]
    $Patreon2Label = CreateLabel -X $Patreon1Label.Right -Y ($GitHub1Label.Bottom + 2)  -Width 145 -Height 15 -Font $URLFont     -Text ("www.patreon.com/Admentus")         -AddTo $Credits.Sections[3]
    $PayPal1Label  = CreateLabel -X 10                   -Y ($Patreon1Label.Bottom + 2) -Width 150 -Height 15 -Font $VCPatchFont -Text ("PayPal")                           -AddTo $Credits.Sections[3]
    $PayPal2Label  = CreateLabel -X $PayPal1Label.Right  -Y ($Patreon1Label.Bottom + 2) -Width 190 -Height 15 -Font $URLFont     -Text ("www.paypal.com/paypalme/Admentus") -AddTo $Credits.Sections[3]

    $Discord2Label.add_Click({[system.Diagnostics.Process]::start("https://discord.gg/P22GGzz")})
    $GitHub2Label.add_Click({[system.Diagnostics.Process]::start("https://github.com/Admentus64")})
    $Patreon2Label.add_Click({[system.Diagnostics.Process]::start("https://www.patreon.com/Admentus")})
    $PayPal2Label.add_Click({[system.Diagnostics.Process]::start("https://www.paypal.com/paypalme/Admentus/")})
    $Discord2Label.ForeColor = $GitHub2Label.ForeColor = $Patreon2Label.ForeColor = $PayPal2Label.ForeColor = "Blue"



    # Documentation
    $SourcesLabel  = CreateLabel -X 10                  -Y ($PayPal2Label.Bottom + 10) -Width 150 -Height 15 -Font $VCPatchFont -Text ("--- Sources ---")                                              -AddTo $Credits.Sections[3]
    
    $Shadow1Label  = CreateLabel -X 10                  -Y ($SourcesLabel.Bottom + 2)  -Width 150  -Height 15 -Font $VCPatchFont -Text ("ShadowOne333's GitHub")                                       -AddTo $Credits.Sections[3]
    $Shadow2Label  = CreateLabel -X $Shadow1Label.Right -Y ($SourcesLabel.Bottom + 2)  -Width 330  -Height 15 -Font $URLFont     -Text ("https://github.com/ShadowOne333/Zelda64-Redux-Documentation") -AddTo $Credits.Sections[3]
    
    $Skilar1Label  = CreateLabel -X 10                  -Y ($Shadow1Label.Bottom + 2)  -Width 150  -Height 15 -Font $VCPatchFont -Text ("Skilarbabcock's YouTube")                                     -AddTo $Credits.Sections[3]
    $Skilar2Label  = CreateLabel -X $Skilar1Label.Right -Y ($Shadow1Label.Bottom + 2)  -Width 225  -Height 15 -Font $URLFont     -Text ("https://www.youtube.com/user/skilarbabcock")                  -AddTo $Credits.Sections[3]

    $Shadow2Label.add_Click({[system.Diagnostics.Process]::start("https://github.com/ShadowOne333/Zelda64-Redux-Documentation")})
    $Skilar2Label.add_Click({[system.Diagnostics.Process]::start("https://www.youtube.com/user/skilarbabcock")})
    $Shadow2Label.ForeColor = $Skilar2Label.ForeColor = "Blue"



    # Hash
    $HashSumROMLabel          = CreateLabel   -X 10 -Y 20 -Width 120 -Height 15 -Font $VCPatchFont -Text "ROM Hashsum:" -AddTo $Credits.Sections[4]
    $global:HashSumROMTextBox = CreateTextBox -X $HashSumROMLabel.Right -Y ($HashSumROMLabel.Top - 3) -Width ($Credits.Sections[4].Width -$HashSumROMLabel.Width - 100) -Height 50 -AddTo $Credits.Sections[4]
    $HashSumROMTextBox.ReadOnly = $True

    # Matching Hash
    $MatchingROMLabel          = CreateLabel   -X 10 -Y ($HashSumROMTextBox.Bottom + 10) -Width 120 -Height 15 -Font $VCPatchFont -Text "Current ROM:" -AddTo $Credits.Sections[4]
    $global:MatchingROMTextBox = CreateTextBox -X $MatchingROMLabel.Right -Y ($MatchingROMLabel.Top - 3) -Width ($Credits.Sections[4].Width -$MatchingROMLabel.Width - 100) -Height 50 -Text "No ROM Selected" -AddTo $Credits.Sections[4]
    $MatchingROMTextBox.ReadOnly = $True

}



#==============================================================================================================================================================================================
function CreateSettingsDialog() {
    
    # Create Dialog
    $global:SettingsDialog = CreateDialog -Width 600 -Height 460 -Icon $Files.icon.settings
    $CloseButton = CreateButton -X ($SettingsDialog.Width / 2 - 40) -Y ($SettingsDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $SettingsDialog
    $CloseButton.Add_Click({ $SettingsDialog.Hide() })

    # Create the version number and script name label.
    $InfoLabel = CreateLabel -X ($SettingsDialog.Width / 2 - $String.Width - 100) -Y 10 -Width 200 -Height 15 -Font $VCPatchFont -Text ($ScriptName + " " + $Version + " (" + $VersionDate + ")") -AddTo $SettingsDialog

    $global:GeneralSettings = @{}

    # General Settings
    $GeneralSettings.GeneralBox        = CreateReduxGroup -Y 40 -AddTo $SettingsDialog -IsGame $False -Text "General Settings"
    $GeneralSettings.Bit64             = CreateSettingsCheckbox -Column 1 -Text "Use 64-Bit Tools" -Checked ([Environment]::Is64BitOperatingSystem) -Info "Use 64-bit tools instead of 32-bit tools if available for patching ROMs" -Name "Bit64"
    $GeneralSettings.DoubleClick       = CreateSettingsCheckbox -Column 2 -Text "Double Click"                                                      -Info "Allows a PowerShell file to be opened by double-clicking it"
    $GeneralSettings.DoubleClick.Checked = ((Get-ItemProperty -LiteralPath "HKLM:\Software\Classes\Microsoft.PowerShellScript.1\Shell").'(default)' -eq '0')

    # Advanced Settings
    $GeneralSettings.AdvancedBox       = CreateReduxGroup -Y ($GeneralSettings.GeneralBox.Bottom + 10) -IsGame $False -AddTo $SettingsDialog -Text "Advanced Settings"
    $GeneralSettings.IgnoreChecksum    = CreateSettingsCheckbox -Column 1 -Text "Ignore Input Checksum" -IsDebug -Info "Do not check the checksum of a ROM or WAD and patch it regardless" -Name "IgnoreChecksum"
    $GeneralSettings.KeepLogo          = CreateSettingsCheckbox -Column 2 -Text "Keep Logo"             -IsDebug -Info "Keep the vanilla title logo instead of the Master Quest title logo" -Name "KeepLogo"
    $GeneralSettings.ForceExtract      = CreateSettingsCheckbox -Column 3 -Text "Force Extract"         -IsDebug -Info "Always extract game data required for patching even if it was already extracted on a previous run" -Name "ForceExtract"

    # Debug Settings
    $GeneralSettings.DebugBox          = CreateReduxGroup -Y ($GeneralSettings.AdvancedBox.Bottom + 10) -IsGame $False -Height 3 -AddTo $SettingsDialog -Text "Debug Settings"
    $GeneralSettings.Console           = CreateSettingsCheckbox -Column 1 -Row 1 -Text "Console"             -IsDebug -Info "Show the console log" -Name "Console"
    $GeneralSettings.Stop              = CreateSettingsCheckbox -Column 2 -Row 1 -Text "Stop Patching"       -IsDebug -Info "Do not start the patching process and instead show debug information for the console log" -Name "Stop"
    $GeneralSettings.CreateBPS         = CreateSettingsCheckbox -Column 3 -Row 1 -Text "Create BPS"          -IsDebug -Info "Create compressed and decompressed BPS patches when patching is concluded" -Name "CreateBPS"
    $GeneralSettings.KeepDecompressed  = CreateSettingsCheckbox -Column 1 -Row 2 -Text "Keep Decompressed"   -IsDebug -Info "Keep the decompressed patched ROM in the output folder" -Name "KeepDecompressed"
    $GeneralSettings.Rev0DungeonFiles  = CreateSettingsCheckbox -Column 2 -Row 2 -Text "Rev 0 Dungeon Files" -IsDebug -Info "Extract the dungeon files from the Rev 0 US OoT ROM as well when extracting dungeon files" -Name "Rev0DungeonFiles"
    $GeneralSettings.NoCleanup         = CreateSettingsCheckbox -Column 3 -Row 2 -Text "No Cleanup"          -IsDebug -Info "Do not clean up the files after the patching process fails or succeeds" -Name "NoCleanup"
    $GeneralSettings.NoHeaderChange    = CreateSettingsCheckbox -Column 1 -Row 3 -Text "No Header Change"    -IsDebug -Info "Do not change the title header of the ROM when patching is concluded" -Name "NoHeaderChange"
    $GeneralSettings.NoCRCChange       = CreateSettingsCheckbox -Column 2 -Row 3 -Text "No CRC Change"       -IsDebug -Info "Do not change the CRC of the ROM when patching is concluded" -Name "NoCRCChange"
    $GeneralSettings.NoChannelChange   = CreateSettingsCheckbox -Column 3 -Row 3 -Text "No Channel Change"   -IsDebug -Info "Do not change the channel title and channel GameID of the WAD when patching is concluded" -Name "NoChannelChange"

    $GeneralSettings.Console.Add_CheckStateChanged({ ShowPowerShellConsole -ShowConsole $this.Checked })
    $GeneralSettings.DoubleClick.Add_CheckStateChanged({ TogglePowerShellOpenWithClicks -Enable $this.Checked })

    # Create a button to reset the tool.
    $GeneralSettings.ResetBox          = CreateReduxGroup -Y ($GeneralSettings.DebugBox.Bottom + 10) -IsGame $False -Height 2 -AddTo $SettingsDialog -Text "Reset"
    $GeneralSettings.ResetButton       = CreateReduxButton -Width 150 -Height 45 -AddTo $GeneralSettings.ResetBox -Text "Reset All Settings" -Info ("Resets all settings stored in the " + $ScriptName)
    $GeneralSettings.ResetButton.Add_Click({ ResetTool })

    # Disable Stop if no Console
    $GeneralSettings.Console.Add_CheckStateChanged({ $GeneralSettings.Stop.Enabled = $this.Checked })
    $GeneralSettings.Stop.Enabled = $GeneralSettings.Console.Checked

}



#==============================================================================================================================================================================================
function CreateSettingsCheckbox([int]$Column=1, [int]$Row=1, [Boolean]$Checked, [Switch]$Disable, [String]$Text="", [Object]$ToolTip, [String]$Info="", [String]$Name, [Switch]$IsDebug) {
    
    $Checkbox = CreateCheckbox -X (($Column-1) * 165 + 15) -Y ($Row * 30 - 10) -Checked $Checked -Disable $Disable -IsRadio $False -Info $Info -IsDebug $IsDebug -Name $Name
    $Label = CreateLabel -X $CheckBox.Right -Y ($CheckBox.Top + 3) -Width 135 -Height 15 -Text $Text -Info $Info
    
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

    ShowPowerShellConsole -ShowConsole $True

    if ($Error -eq "Missing Files")         { $String += "Neccessary files are missing.{0}" }
    elseif ($Error -eq "Missing JSON")      { $String += ".JSON files are missing.{0}" }
    elseif ($Error -eq "Corrupted JSON")    { $String += ".JSON files are corrupted.{0}" }
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
Export-ModuleMember -Function CreateLanguageContent