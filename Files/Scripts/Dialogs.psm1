function CreateOptionsPanel([array]$Tabs=@()) {
    
    WriteToConsole "Creating additional options..."
    RefreshScripts

    if ($RightPanel.Options.Controls.ContainsKey("OptionsPanel")) { $RightPanel.Options.Controls.RemoveByKey("OptionsPanel") }
    $Redux.WindowPanel = CreatePanel -Name "OptionsPanel" -Width $RightPanel.Options.Width -Height $RightPanel.Options.Height -AddTo $RightPanel.Options

    # Options Label
    $OptionsLabel = CreateLabel -Width $Redux.WindowPanel.width -Height (DPISize 15) -Font $Fonts.SmallBold -Text ($GameType.mode + " - Additional Options") -AddTo $Redux.WindowPanel
    $OptionsLabel.AutoSize = $True
    $OptionsLabel.Left = ([Math]::Floor($Redux.WindowPanel.Width / 2) - [Math]::Floor($OptionsLabel.Width / 2))

    CreateTabButtons -Tabs $Tabs

    # Run Preset
    if (IsSet $GamePatch.preset) {
        if (HasCommand ("ApplyPreset" + $GamePatch.preset)) {
            ResetGame
            iex ("ApplyPreset" + $GamePatch.preset)
        }
    }

    if (HasCommand "CreateOptionsPreviews") {
        $global:OptionsPreviews = @{}
        $OptionsPreviews.Dialog = CreateDialog -Icon $Files.icon.preview                          -Width (DPISize 440)                                  -Height (DPISize 300) 
        $OptionsPreviews.Panel  = CreatePanel -Name "PreviewPanel" -X (DPISize 10) -Y (DPISize 5) -Width ($OptionsPreviews.Dialog.Width - (DPISize 25)) -Height ($OptionsPreviews.Dialog.Height - (DPISize 40)) -AddTo $OptionsPreviews.Dialog
        $OptionsPreviews.Panel.AutoScroll = $True
        $OptionsPreviews.Dialog.Add_FormClosing({ param($sender, $e) $e.Cancel = $True; ToggleDialog -Dialog $OptionsPreviews.Dialog -Panel $OptionsPreviews.Panel -Close })
        CreateOptionsPreviews
        if (IsSet $Last.Group) { CreatePanel -Y $Last.Group.Bottom -Width 1 -Height (DPISize 10) -AddTo $OptionsPreviews.Panel }
    }

    HideNativeOptions

}



#==============================================================================================================================================================================================
function CreateTabButtons([string[]]$Tabs) {
    
    if ($Tabs.Count -eq 0 -and (IsSet $GamePatch.redux)) {
        $Tabs        += "Main"
        $Last.TabName = "Main"
    }
    if ( (IsSet $GamePatch.redux)   -and $Tabs -notcontains "Redux")   { $Tabs             += "Redux" }
    if (!(IsSet $GameSettings.Core) -and $Tabs.Length -gt 0)           { $GameSettings.Core = @{}     }

    $Tabs = $Tabs | Select-Object -Unique
    if ($Tabs.Count -eq 1 -and (HasCommand ("CreateTab" + $Tabs[0] -replace '\s',''))) {
        $Last.TabName               = $Tabs[0]
        $Redux.Panels              += CreatePanel -Width $Redux.WindowPanel.Width -Height ($Redux.WindowPanel.Height - (DPISize 70)) -AddTo $Redux.WindowPanel
        $Redux.Panels[0].AutoScroll = $True
        iex ("CreateTab" + $Tabs[0] -replace '\s','')
        return
    }

    $actualTabs = $Tabs.Count

    # Create tabs
    for ($i=0; $i -lt $Tabs.Count; $i++) {
        $name = $Tabs[$i] -replace '\s',''
        if (!(HasCommand ("CreateTab" + $name))) {
            $actualTabs--
            continue
        }

        $button       = CreateButton -X ( (DPISize 20) + ( ( ($Redux.WindowPanel.width - (DPISize 50) ) / $Tabs.Count) * $i) ) -Y (DPISize 20) -Width ( ($Redux.WindowPanel.width - (DPISize 50) ) / $Tabs.Count) -Height (DPISize 25) -ForeColor "White" -BackColor "Gray" -Tag $i -Text $Tabs[$i] -AddTo $Redux.WindowPanel
        $Last.TabName = $name
        $Button.Add_Click({
            foreach ($item in $Redux.Tabs)                 { $item.BackColor = "Gray" }
            for ($i=0; $i -lt $Redux.Panels.Count; $i++)   { $Redux.Panels[$i].Visible = $i -eq $this.Tag }
            $GameSettings["Core"]["LastTab"] = $this.Tag
            $this.BackColor                  = "DarkGray"
        })

        $Redux.Tabs                                    += $Button
        $Redux.Panels                                  += CreatePanel -Y ($Button.Bottom + (DPISize 5) ) -Width $Redux.WindowPanel.Width -Height ($Redux.WindowPanel.Height - $button.Height - (DPISize 75) ) -Name $name -AddTo $Redux.WindowPanel
        $Redux.Panels[$Redux.Panels.Count-1].AutoScroll = $True
        $Last.Half                                      = $False
        iex ("CreateTab" + $name)
    }

    # Restore last tab

    if ($actualTabs -gt 0) {
        if (IsSet -Elem $GameSettings["Core"]["LastTab"] -HasInt) {
            if ($Redux.Tabs.Length -lt $GameSettings["Core"]["LastTab"]) {
                $Redux.Tabs[0].BackColor = "DarkGray"
                for ($i=0; $i -lt $Redux.Panels.Count; $i++) { $Redux.Panels[$i].Visible = $i -eq $Redux.Tabs[0].Tag }
            }
            else {
                if (IsSet $Redux.Tabs[$GameSettings["Core"]["LastTab"]]) {
                    $Redux.Tabs[$GameSettings["Core"]["LastTab"]].BackColor = "DarkGray"
                    for ($i=0; $i -lt $Redux.Panels.Count; $i++) { $Redux.Panels[$i].Visible = $i -eq $Redux.Tabs[$GameSettings["Core"]["LastTab"]].Tag }
                }
                else {
                    $Redux.Tabs[0].BackColor = "DarkGray"
                    for ($i=0; $i -lt $Redux.Panels.Count; $i++) { $Redux.Panels[$i].Visible = $i -eq $Redux.Tabs[0].Tag }
                }
            }
        }
        else {
            for ($i=0; $i -lt $Redux.Panels.Count; $i++) { $Redux.Panels[$i].Visible = $i -eq $Redux.Tabs[0].Tag }
            $GameSettings["Core"]["LastTab"] = 0
            $Redux.Tabs[0].BackColor = "DarkGray"
        }
    }
    else { $Last.TabName = "Main" }

}



#==============================================================================================================================================================================================
function ToggleDialog([System.Windows.Forms.Form]$Dialog, [System.Windows.Forms.Panel]$Panel=$null, [switch]$Close) {
    
    if (!(IsSet $Dialog)) { return }

    if ($Dialog.Visible -or $Close) {
        if ($Panel -ne $null -and $Panel.AutoScroll -eq $True) {
            $Panel.Controls[0].Select()
            $Panel.AutoScrollPosition = 0
        }
        $Dialog.Hide()
    }
    else { $Dialog.Show() }

}



#==============================================================================================================================================================================================
function CreateCreditsPanel() {
    
    # Initialization
    $global:Credits = @{}

    # Create Text Boxes
    $Credits.Info      = CreateTextBox -X (DPISize 10)       -Y (DPISize 10)      -Width ($RightPanel.Info.Width - (DPISize 20)) -Height ($RightPanel.Info.Height - (DPISize 60)) -ReadOnly -Multiline -AddTo $RightPanel.Info      -TextFileFont
    $Credits.Credits   = CreateTextBox -X $Credits.Info.Left -Y $Credits.Info.Top -Width $Credits.Info.Width                     -Height $Credits.Info.Height                     -ReadOnly -Multiline -AddTo $RightPanel.Credits   -TextFileFont
    $Credits.GameID    = CreateTextBox -X $Credits.Info.Left -Y $Credits.Info.Top -Width $Credits.Info.Width                     -Height $Credits.Info.Height                     -ReadOnly -Multiline -AddTo $RightPanel.GameID    -TextFileFont
    $Credits.Changelog = CreateTextBox -X $Credits.Info.Left -Y $Credits.Info.Top -Width $Credits.Info.Width                     -Height $Credits.Info.Height                     -ReadOnly -Multiline -AddTo $RightPanel.Changelog -TextFileFont

    # Support
    $SupportLabel  = CreateLabel -X (DPISize 10)         -Y (DPISize 10)                          -Width (DPISize 200) -Height (DPISize 15) -Font $Fonts.SmallBold      -Text ("--- Support or visit me at ---")   -AddTo $RightPanel.Links

    $Discord1Label = CreateLabel -X (DPISize 10)         -Y ($SupportLabel.Bottom + (DPISize 2))  -Width (DPISize 150) -Height (DPISize 15) -Font $Fonts.SmallBold      -Text ("Discord")                          -AddTo $RightPanel.Links
    $Discord2Label = CreateLabel -X $Discord1Label.Right -Y ($SupportLabel.Bottom + (DPISize 2))  -Width (DPISize 140) -Height (DPISize 15) -Font $Fonts.SmallUnderline -Text ("https://discord.gg/P22GGzz")       -AddTo $RightPanel.Links
    $GitHub1Label  = CreateLabel -X (DPISize 10)         -Y ($Discord1Label.Bottom + (DPISize 2)) -Width (DPISize 150) -Height (DPISize 15) -Font $Fonts.SmallBold      -Text ("GitHub")                           -AddTo $RightPanel.Links
    $GitHub2Label  = CreateLabel -X $GitHub1Label.Right  -Y ($Discord1Label.Bottom + (DPISize 2)) -Width (DPISize 180) -Height (DPISize 15) -Font $Fonts.SmallUnderline -Text ("https://github.com/Admentus64")    -AddTo $RightPanel.Links
    
    $Patreon1Label = CreateLabel -X (DPISize 10)         -Y ($GitHub1Label.Bottom + (DPISize 2))  -Width (DPISize 150) -Height (DPISize 15) -Font $Fonts.SmallBold      -Text ("Patreon")                          -AddTo $RightPanel.Links
    $Patreon2Label = CreateLabel -X $Patreon1Label.Right -Y ($GitHub1Label.Bottom + (DPISize 2))  -Width (DPISize 150) -Height (DPISize 15) -Font $Fonts.SmallUnderline -Text ("www.patreon.com/Admentus")         -AddTo $RightPanel.Links
    $PayPal1Label  = CreateLabel -X (DPISize 10)         -Y ($Patreon1Label.Bottom + (DPISize 2)) -Width (DPISize 150) -Height (DPISize 15) -Font $Fonts.SmallBold      -Text ("PayPal")                           -AddTo $RightPanel.Links
    $PayPal2Label  = CreateLabel -X $PayPal1Label.Right  -Y ($Patreon1Label.Bottom + (DPISize 2)) -Width (DPISize 200) -Height (DPISize 15) -Font $Fonts.SmallUnderline -Text ("www.paypal.com/paypalme/Admentus") -AddTo $RightPanel.Links

    $Discord2Label.add_Click( { [system.Diagnostics.Process]::start("https://discord.gg/P22GGzz") } )
    $GitHub2Label.add_Click(  { [system.Diagnostics.Process]::start("https://github.com/Admentus64") } )
    $Patreon2Label.add_Click( { [system.Diagnostics.Process]::start("https://www.patreon.com/Admentus") } )
    $PayPal2Label.add_Click(  { [system.Diagnostics.Process]::start("https://www.paypal.com/paypalme/Admentus/") } )
    $Discord2Label.ForeColor = $GitHub2Label.ForeColor = $Patreon2Label.ForeColor = $PayPal2Label.ForeColor = "Blue"

    # Support Me QR
    $SwishLabel = CreateLabel -X (DPISize 520) -Y (DPISize 10) -Height (DPISize 15) -Font $Fonts.SmallBold -Text ("Swish") -AddTo $RightPanel.Links
    $PictureBox = New-Object Windows.Forms.PictureBox
    $PictureBox.Location = New-object System.Drawing.Size($SwishLabel.Left, ($SwishLabel.Bottom + (DPISize 5)))
    SetBitmap -Path ($Paths.Main + "\qr.jpg") -Box $PictureBox -Width 250 -Height 280
    $PictureBox.Width  = $PictureBox.Image.Size.Width
    $PictureBox.Height = $PictureBox.Image.Size.Height
    $RightPanel.Links.controls.add($PictureBox)



    # Documentation
    $SourcesLabel    = CreateLabel -X (DPISize 10)           -Y ($PayPal2Label.Bottom   + (DPISize 80)) -Width (DPISize 150) -Height (DPISize 15) -Font $Fonts.SmallBold      -Text ("--- Sources ---")                                                                     -AddTo $RightPanel.Links
    
    $Shadow1Label    = CreateLabel -X (DPISize 10)           -Y ($SourcesLabel.Bottom    + (DPISize 2)) -Width (DPISize 150) -Height (DPISize 15) -Font $Fonts.SmallBold      -Text ("ShadowOne333's GitHub")                                                               -AddTo $RightPanel.Links
    $Shadow2Label    = CreateLabel -X $Shadow1Label.Right    -Y ($SourcesLabel.Bottom    + (DPISize 2)) -Width (DPISize 340) -Height (DPISize 15) -Font $Fonts.SmallUnderline -Text ("https://github.com/ShadowOne333/Zelda64-Redux-Documentation")                         -AddTo $RightPanel.Links
    
    $Malon1Label     = CreateLabel -X (DPISize 10)           -Y ($Shadow1Label.Bottom    + (DPISize 2)) -Width (DPISize 150) -Height (DPISize 15) -Font $Fonts.SmallBold      -Text ("Malon Rose YouTube")                                                                  -AddTo $RightPanel.Links
    $Malon2Label     = CreateLabel -X $Malon1Label.Right     -Y ($Shadow1Label.Bottom    + (DPISize 2)) -Width (DPISize 225) -Height (DPISize 15) -Font $Fonts.SmallUnderline -Text ("https://www.youtube.com/c/MalonRose")                                                 -AddTo $RightPanel.Links

    $Luigi1Label     = CreateLabel -X (DPISize 10)           -Y ($Malon1Label.Bottom     + (DPISize 2)) -Width (DPISize 150) -Height (DPISize 15) -Font $Fonts.SmallBold      -Text ("theluigidude2007 YouTube")                                                            -AddTo $RightPanel.Links
    $Luigi2Label     = CreateLabel -X $Luigi1Label.Right     -Y ($Malon1Label.Bottom     + (DPISize 2)) -Width (DPISize 300) -Height (DPISize 15) -Font $Fonts.SmallUnderline -Text ("www.youtube.com/channel/UC3071imQKR5cEIobsFHLW9Q")                                    -AddTo $RightPanel.Links

    $Shadow2Label.add_Click(    { [system.Diagnostics.Process]::start("https://github.com/ShadowOne333/Zelda64-Redux-Documentation") } )
    $Malon2Label.add_Click(     { [system.Diagnostics.Process]::start("https://www.youtube.com/c/MalonRose") } )
    $Luigi2Label.add_Click(     { [system.Diagnostics.Process]::start("https://www.youtube.com/channel/UC3071imQKR5cEIobsFHLW9Q") } )

    $Shadow2Label.ForeColor = $Malon2Label.ForeColor = $Luigi2Label.ForeColor = "Blue"


    
    # Hash
    $global:VerificationInfo = @{}

    $VerificationInfo.HashText              = CreateLabel -X (DPISize 10) -Y (DPISize 20) -Width (DPISize 120) -Height (DPISize 15) -Font $Fonts.SmallBold -Text "ROM Hashsum:" -AddTo $RightPanel.Checksum
    $VerificationInfo.HashField             = CreateTextBox -X $VerificationInfo.HashText.Right -Y ($VerificationInfo.HashText.Top - (DPISize 3)) -Width ($RightPanel.Checksum.Width - $VerificationInfo.HashText.Width - (DPISize 100)) -Height (DPISize 50) -AddTo $RightPanel.Checksum
    $VerificationInfo.HashField.ReadOnly    = $True

    $VerificationInfo.GameText              = CreateLabel -X (DPISize 10) -Y ($VerificationInfo.HashField.Bottom + (DPISize 10)) -Width (DPISize 120) -Height (DPISize 15) -Font $Fonts.SmallBold -Text "Current Game:" -AddTo $RightPanel.Checksum
    $VerificationInfo.GameField             = CreateTextBox -X $VerificationInfo.GameText.Right -Y ($VerificationInfo.GameText.Top - (DPISize 3)) -Width ($RightPanel.Checksum.Width - $VerificationInfo.GameText.Width - (DPISize 100)) -Height (DPISize 50) -Text "No ROM Selected" -AddTo $RightPanel.Checksum
    $VerificationInfo.GameField.ReadOnly    = $True

    $VerificationInfo.RegionText            = CreateLabel -X (DPISize 10) -Y ($VerificationInfo.GameField.Bottom + (DPISize 10)) -Width (DPISize 120) -Height (DPISize 15) -Font $Fonts.SmallBold -Text "Current Region:" -AddTo $RightPanel.Checksum
    $VerificationInfo.RegionField           = CreateTextBox -X $VerificationInfo.RegionText.Right -Y ($VerificationInfo.RegionText.Top - (DPISize 3)) -Width ($RightPanel.Checksum.Width - $VerificationInfo.RegionText.Width - (DPISize 100)) -Height (DPISize 50) -Text "No ROM Selected" -AddTo $RightPanel.Checksum
    $VerificationInfo.RegionField.ReadOnly  = $True

    $VerificationInfo.RevText               = CreateLabel -X (DPISize 10) -Y ($VerificationInfo.RegionField.Bottom + (DPISize 10)) -Width (DPISize 120) -Height (DPISize 15) -Font $Fonts.SmallBold -Text "Current Revision:" -AddTo $RightPanel.Checksum
    $VerificationInfo.RevField              = CreateTextBox -X $VerificationInfo.RevText.Right -Y ($VerificationInfo.RevText.Top - (DPISize 3)) -Width ($RightPanel.Checksum.Width - $VerificationInfo.RevText.Width - (DPISize 100)) -Height (DPISize 50) -Text "No ROM Selected" -AddTo $RightPanel.Checksum
    $VerificationInfo.RevField.ReadOnly     = $True
    
    $VerificationInfo.SupportText           = CreateLabel -X (DPISize 10) -Y ($VerificationInfo.RevField.Bottom + (DPISize 10)) -Width (DPISize 120) -Height (DPISize 15) -Font $Fonts.SmallBold -Text "Supported ROM:" -AddTo $RightPanel.Checksum
    $VerificationInfo.SupportField          = CreateTextBox -X $VerificationInfo.SupportText.Right -Y ($VerificationInfo.SupportText.Top - (DPISize 3)) -Width ($RightPanel.Checksum.Width - $VerificationInfo.SupportText.Width - (DPISize 100)) -Height (DPISize 50) -Text "No ROM Selected" -AddTo $RightPanel.Checksum
    $VerificationInfo.SupportField.ReadOnly = $True

    AddTextFileToTextbox -TextBox $Credits.GameID    -File $Files.text.gameID
    AddTextFileToTextbox -TextBox $Credits.Changelog -File $Files.text.changelog
    SetCreditsSections
    CalculateHashSum

}



#==============================================================================================================================================================================================
function CreateSettingsPanel() {
    
    $global:GeneralSettings = @{}
    $GeneralSettings.Panel  = CreatePanel -Name "SettingsPanel" -Width ($RightPanel.Settings.Width) -Height ($RightPanel.Settings.Height - (DPISize 40) ) -AddTo $RightPanel.Settings
    $GeneralSettings.Panel.AutoScroll = $True

    # General Settings
    $GeneralSettings.Box             = CreateSettingsGroup -Text "General Settings"
    $GeneralSettings.DoubleClick     = CreateSettingsCheckbox                         -Text "Double Click" -Disable ((GetWindowsVersion) -ge 11) -Info "Allows a PowerShell file to be opened by double-clicking it"
    $GeneralSettings.ClearType       = CreateSettingsCheckbox -Name "ClearType"       -Text "Use ClearType Font"      -Checked -Info ('Use the ClearType font "Segoe UI" instead of the default font "Microsft Sans Serif"' + "`nThe option will only go in effect when opening the tool`nThis change requires the tool to restart to be applied")
    $GeneralSettings.HiDPIMode       = CreateSettingsCheckbox -Name "HiDPIMode"       -Text "Use Hi-DPI Mode"         -Checked -Info "Enables Hi-DPI Mode suitable for higher resolution displays`nThe option will only go in effect when opening the tool`nThis change requires the tool to restart to be applied"
    $GeneralSettings.ModernStyle     = CreateSettingsCheckbox -Name "ModernStyle"     -Text "Use Modern Visual Style" -Checked -Info "Use a modern-looking visual style for the whole interface of the tool"
    $GeneralSettings.SafeOptions     = CreateSettingsCheckbox -Name "SafeOptions"     -Text "Use Safe Options"                 -Info "Hide any options which are not considered safe for Randomizer or the Everdrive"
    $GeneralSettings.PerGameFile     = CreateSettingsCheckbox -Name "PerGameFile"     -Text "Use ROM per Game Mode"            -Info "The last ROM or Wii VC WAD for a chosen Game Mode is stored when switching back to it"
    $GeneralSettings.EnableSounds    = CreateSettingsCheckbox -Name "EnableSounds"    -Text "Enable Sound Effects"    -Checked -Info "Enable the use of sound effects, for example when patching is concluded"
    $GeneralSettings.LocalTempFolder = CreateSettingsCheckbox -Name "LocalTempFolder" -Text "Use Local Temp Folder"   -Checked -Info "Store all temporary and extracted files within the local Patcher64+ Tool folder`nIf unchecked the temporary and extracted files are kept in the Patcher64+ Tool folder in %AppData%"
    $GeneralSettings.UseCache        = CreateSettingsCheckbox -Name "UseCache"        -Text "Use Cache"               -Checked -Info "Enables caching`n- Keep a copy of the downgraded or decompressed ROM to speed up patching for subsequent attempts`n- Store all text messages to patch until the end so they can be applied in sorted order"
    $GeneralSettings.DisableUpdates  = CreateSettingsCheckbox -Name "DisableUpdates"  -Text "Disable Auto-Updater"             -Info "Disable the Auto-Updater that runs when starting the Patcher64+ Tool"
    $GeneralSettings.DisableAddons   = CreateSettingsCheckbox -Name "DisableAddons"   -Text "Disable Addons Updater"           -Info "Disable automatically updating addons (music, models, etc) when starting the Patcher64+ Tool"

    if ((GetWindowsVersion) -lt 11) {
        try {
            $reg = (Get-ItemProperty -LiteralPath "HKLM:\Software\Classes\Microsoft.PowerShellScript.1\Shell").'(default)'
            if ($reg -ne $null)   { $GeneralSettings.DoubleClick.Checked = (Get-ItemProperty -LiteralPath "HKLM:\Software\Classes\Microsoft.PowerShellScript.1\Shell").'(default)' -eq '0' }
            else                  { $GeneralSettings.DoubleClick.Checked = $GeneralSettings.DoubleClick.Enabled = $False                                                                   }
        }
        catch { $GeneralSettings.DoubleClick.Checked = $GeneralSettings.DoubleClick.Enabled = $False }
    }

    # Advanced Settings
    $GeneralSettings.Box                = CreateSettingsGroup    -Text "Advanced Settings"
    $GeneralSettings.Logging            = CreateSettingsCheckbox -Name "Logging"            -Text "Logging"        -Checked -IsDebug -Info "Write all events of Patcher64+ into log files"
    $GeneralSettings.ClearLog           = CreateSettingsCheckbox -Name "ClearLog"           -Text "Clear Log When Patching" -IsDebug -Info "Clear the log when patching a ROM`nDo not enable this option if you want to submit a bug report"
    $GeneralSettings.IgnoreChecksum     = CreateSettingsCheckbox -Name "IgnoreChecksum"     -Text "Ignore Input Checksum"   -IsDebug -Info "Do not check the checksum of a ROM or WAD and patch it regardless`nDowngrade is no longer forced anymore if the checksum is different than the supported revision`nThis option also skips the maximum ROM size verification`n`nDO NOT REPORT ANY BUGS IF THIS OPTION IS ENABLED!"
    $GeneralSettings.ForceExtract       = CreateSettingsCheckbox -Name "ForceExtract"       -Text "Force Extract"           -IsDebug -Info "Always extract game data required for patching even if it was already extracted on a previous run"
    $GeneralSettings.ExtractCleanScript = CreateSettingsCheckbox -Name "ExtractCleanScript" -Text "Extract Clean Script"    -IsDebug -Info "Extract a clean copy of dialogue script for the Text Editor when patching`nvanilla Ocarina of Time or Majora's Mask"
    $GeneralSettings.ExtractFullScript  = CreateSettingsCheckbox -Name "ExtractFullScript"  -Text "Extract Patched Script"  -IsDebug -Info "Extract a fully patched copy of dialogue script for the Text Editor when patching`nvanilla Ocarina of Time or Majora's Mask"
    $GeneralSettings.NoConversion       = CreateSettingsCheckbox -Name "NoConversion"       -Text "No Conversion"           -IsDebug -Info "Do not attempt to convert the ROM to a proper format"
    $GeneralSettings.RefreshScripts     = CreateSettingsCheckbox -Name "RefreshScripts"     -Text "Refresh Scripts"         -IsDebug -Info "Refresh several code scripts prior to running them so that any code changes are included"

    # Debug Settings
    $GeneralSettings.Box                   = CreateSettingsGroup    -Text "Debug Settings"
    $GeneralSettings.Console               = CreateSettingsCheckbox -Name "Console"               -Text "Console"                 -IsDebug -Info "Show the console log"
    $GeneralSettings.Stop                  = CreateSettingsCheckbox -Name "Stop"                  -Text "No Patching"             -IsDebug -Info "Do not start the patching process and only show the debug information for the console log or log file"
    $GeneralSettings.CreateCompressedBPS   = CreateSettingsCheckbox -Name "CreateCompressedBPS"   -Text "Create Compressed BPS"   -IsDebug -Info "Create compressed and decompressed BPS patches when patching is concluded"
    $GeneralSettings.CreateDecompressedBPS = CreateSettingsCheckbox -Name "CreateDecompressedBPS" -Text "Create Decompressed BPS" -IsDebug -Info "Create compressed and decompressed BPS patches when patching is concluded"
    $GeneralSettings.NoCleanup             = CreateSettingsCheckbox -Name "NoCleanup"             -Text "No Cleanup"              -IsDebug -Info "Do not clean up the files after the patching process fails or succeeds"
    $GeneralSettings.NoTitleChange         = CreateSettingsCheckbox -Name "NoTitleChange"         -Text "No ROM Title Change"     -IsDebug -Info "Do not change the title of the ROM when patching is concluded"
    $GeneralSettings.NoGameIDChange        = CreateSettingsCheckbox -Name "NoGameIDChange"        -Text "No GameID Change"        -IsDebug -Info "Do not change the GameID of the ROM when patching is concluded"
    $GeneralSettings.NoChannelTitleChange  = CreateSettingsCheckbox -Name "NoChannelTitleChange " -Text "No Channel Title Change" -IsDebug -Info "Do not change the channel title of the WAD when patching is concluded"
    $GeneralSettings.NoChannelIDChange     = CreateSettingsCheckbox -Name "NoChannelIDChange"     -Text "No Channel ID Change"    -IsDebug -Info "Do not change the channel GameID of the WAD when patching is concluded"
    $GeneralSettings.KeepDowngraded        = CreateSettingsCheckbox -Name "KeepDowngraded"        -Text "Keep Downgraded"         -IsDebug -Info "Keep the downgraded patched ROM in the output folder"
    $GeneralSettings.KeepConverted         = CreateSettingsCheckbox -Name "KeepConverted"         -Text "Keep Converted"          -IsDebug -Info "Keep the converted patched ROM in the output folder"
    $GeneralSettings.SceneEditorChecks     = CreateSettingsCheckbox -Name "SceneEditorChecks"     -Text "Scene Editor Checks"     -IsDebug -Info "Print out extras debug info and perform extra checks for the Scene Editor`nThis may slow down performance a bit"
    $GeneralSettings.OverwriteChecks       = CreateSettingsCheckbox -Name "OverwriteChecks"       -Text "Overwrite Checks"        -IsDebug -Info "Check if during patching data got overwritten and inform if so"
    $GeneralSettings.MissingChecks         = CreateSettingsCheckbox -Name "MissingChecks"         -Text "Missing Checks"          -IsDebug -Info "Check if during patching options did not get patched in and inform if so"

    # Debug Settings (Nintendo 64)
    $GeneralSettings.Box              = CreateSettingsGroup    -Text "Debug Settings (Nintendo 64)"
    $GeneralSettings.NoCompression    = CreateSettingsCheckbox -Name "NoCompression"    -Text "No Compression"         -IsDebug -Info "Do not attempt to compress the ROM back again when patching is concluded`nThis can cause Wii VC WADs to freeze"
    $GeneralSettings.KeepDecompressed = CreateSettingsCheckbox -Name "KeepDecompressed" -Text "Keep Decompressed"      -IsDebug -Info "Keep the decompressed patched ROM in the output folder"
    $GeneralSettings.NoCRCChange      = CreateSettingsCheckbox -Name "NoCRCChange"      -Text "No CRC Change"          -IsDebug -Info "Do not change the CRC of the ROM when patching is concluded"
    $GeneralSettings.Rev0DungeonFiles = CreateSettingsCheckbox -Name "Rev0DungeonFiles" -Text "Rev 0 Dungeon Files"    -IsDebug -Info "Extract the dungeon files from the OoT ROM (Rev 0 US) or MM ROM (Rev 0 US) as well when extracting dungeon files"
    $GeneralSettings.NoTextPatching   = CreateSettingsCheckbox -Name "NoTextPatching"   -Text "Prevent Text Patching"  -IsDebug -Info "Prevents the patching of any dialogue related options for Ocarina of Time or Majora's Mask`nUseful for when patching Randomizer"
    $GeneralSettings.NoScenePatching  = CreateSettingsCheckbox -Name "NoScenePatching"  -Text "Prevent Scene Patching" -IsDebug -Info "Prevents the patching of any scene related options for Ocarina of Time or Majora's Mask`nUseful for when patching Randomizer"

    # Settings preset
    $GeneralSettings.Box      = CreateSettingsGroup -Text "Settings Presets"
    $GeneralSettings.Presets  = @()
    $text                     = "`nAll made settings are stored to this preset`nSettings are retrieved when selecting this preset again"
    $GeneralSettings.Presets += CreateSettingsRadioField -Name "Preset" -SaveAs 1 -Max 8 -NameTextbox "Preset.Label1" -Text "Preset 1" -Info ("Settings preset #1" + $text) -Checked
    $GeneralSettings.Presets += CreateSettingsRadioField -Name "Preset" -SaveAs 2 -Max 8 -NameTextbox "Preset.Label2" -Text "Preset 2" -Info ("Settings preset #2" + $text)
    $GeneralSettings.Presets += CreateSettingsRadioField -Name "Preset" -SaveAs 3 -Max 8 -NameTextbox "Preset.Label3" -Text "Preset 3" -Info ("Settings preset #3" + $text)
    $GeneralSettings.Presets += CreateSettingsRadioField -Name "Preset" -SaveAs 4 -Max 8 -NameTextbox "Preset.Label4" -Text "Preset 4" -Info ("Settings preset #4" + $text)
    $GeneralSettings.Presets += CreateSettingsRadioField -Name "Preset" -SaveAs 5 -Max 8 -NameTextbox "Preset.Label5" -Text "Preset 5" -Info ("Settings preset #5" + $text)
    $GeneralSettings.Presets += CreateSettingsRadioField -Name "Preset" -SaveAs 6 -Max 8 -NameTextbox "Preset.Label6" -Text "Preset 6" -Info ("Settings preset #6" + $text)
    $GeneralSettings.Presets += CreateSettingsRadioField -Name "Preset" -SaveAs 7 -Max 8 -NameTextbox "Preset.Label7" -Text "Preset 7" -Info ("Settings preset #7" + $text)
    $GeneralSettings.Presets += CreateSettingsRadioField -Name "Preset" -SaveAs 8 -Max 8 -NameTextbox "Preset.Label8" -Text "Preset 8" -Info ("Settings preset #8" + $text)

    if ((GetWindowsVersion) -lt 11) { $GeneralSettings.DoubleClick.Add_CheckStateChanged( { TogglePowerShellOpenWithClicks $this.Checked } ) }
    $GeneralSettings.ModernStyle.Add_CheckStateChanged(     { SetModernVisualStyle $this.checked } )
    $GeneralSettings.EnableSounds.Add_CheckStateChanged(    { LoadSoundEffects $this.checked } )
    $GeneralSettings.Logging.Add_CheckStateChanged(         { SetLogging $this.checked } )

    # Local Temp Folder
    $GeneralSettings.LocalTempFolder.Add_CheckStateChanged( {
        if ($this.checked) {
            $Paths.Temp  = $Paths.LocalTemp
            $Paths.Cache = $Paths.LocalCache
        }
        else {
            $Paths.Temp  = $Paths.AppDataTemp
            $Paths.Cache = $Paths.AppDataCache
        }
        SetTempFileParameters
    } )

    # Console
    $GeneralSettings.Console.Enabled = $ExternalScript
    $GeneralSettings.Console.Add_CheckStateChanged( { ShowPowerShellConsole $this.Checked } )

    # Presets
    for ($i=0; $i-lt $GeneralSettings.Presets.Length; $i++) {
        $GeneralSettings.Presets[$i].Add_CheckedChanged( {
            if (!(IsSet $GamePatch.script) -and $GameSettings -ne $null) { return }
            RefreshGameScript

            if (!$this.checked) { Out-IniFile -FilePath $GameSettingsFile -InputObject $GameSettings }
            else {
                $global:GameSettingsFile = GetGameSettingsFile
                $global:GameSettings     = GetSettings $GameSettingsFile
                $global:Redux            = @{}
                $global:OptionsPreviews  = $null
                $Redux.Panels            = $Redux.Sections = $Redux.Groups = $Redux.Tabs = $Redux.NativeOptions = @()
                $Redux.Box               = @{}

                if (HasCommand "CreateOptions") { CreateOptions }
                DisableReduxOptions
                if (HasCommand "CreateOptionsPreviews") { EnableElem -Elem $Patches.PreviewButton -Active $True -Hide } else { EnableElem -Elem $Patches.PreviewButton -Active $False -Hide }
                [System.GC]::Collect(); [System.GC]::WaitForPendingFinalizers(); [System.GC]::Collect()
            }
        } )
    }

    # Safe Options
    $GeneralSettings.SafeOptions.Add_CheckStateChanged({
        if (!(IsSet $GamePatch.script) -or $GameSettings -eq $null -or !(HasCommand "CreateOptions")) { return }
        RefreshGameScript
        Out-IniFile -FilePath $GameSettingsFile -InputObject $GameSettings

        $global:Redux            = @{}
        $global:OptionsPreviews  = $null
        $Redux.Panels            = $Redux.Sections = $Redux.Groups = $Redux.Tabs = $Redux.NativeOptions = @()
        $Redux.Box               = @{}

        if (HasCommand "CreateOptions") { CreateOptions }
        DisableReduxOptions
        if (HasCommand "CreateOptionsPreviews") { EnableElem -Elem $Patches.PreviewButton -Active $True -Hide } else { EnableElem -Elem $Patches.PreviewButton -Active $False -Hide }
        [System.GC]::Collect(); [System.GC]::WaitForPendingFinalizers(); [System.GC]::Collect()
    })

}



#==============================================================================================================================================================================================
function CreateSettingsGroup([string]$Tag, [string]$Text="") {
    
    $width       = $GeneralSettings.Panel.Width - (DPISize 30)
    $Last.Column = $Last.Row = 1
    $Last.Width  = [byte][Math]::Round($width / $ColumnWidth)
    if ($Last.Group -ne $null) { $Y = $Last.Group.Bottom + 5 } else { $Y = 0 }
    $Group = CreateGroupBox -X (DPISize 10) -Y $Y -Width $width -Height (DPISize 50) -Name "Settings" -Tag $Tag -Text $Text -AddTo $GeneralSettings.Panel
    return $Group

}



#==============================================================================================================================================================================================
function CreateSettingsCheckbox([byte]$Column=$Last.Column, [byte]$Row=$Last.Row, [switch]$Checked, [boolean]$Disable=$False, [string]$Text="", [string]$Info="", [string]$Name, [switch]$IsDebug) {
    
    $Checkbox = CreateCheckbox -X (($Column-1) * $FormDistance + (DPISize 15)) -Y ($Row * (DPISize 30) - (DPISize 10)) -Checked $Checked -Disable $Disable -Info $Info -IsDebug $IsDebug -Name $Name
    if (IsSet $Text) {  
        $Label = CreateLabel -X $CheckBox.Right -Y ($CheckBox.Top + (DPISize 3)) -Width (DPISize 135) -Height (DPISize 15) -Text $Text -Info $Info
        Add-Member -InputObject $Label    -NotePropertyMembers @{ CheckBox = $CheckBox }
        Add-Member -InputObject $CheckBox -NotePropertyMembers @{ Label    = $Text }
        $Label.Add_Click({
            if ($this.CheckBox.Enabled) { $this.CheckBox.Checked = !$this.CheckBox.Checked }
        })
    }

    $Last.Column = $column + 1;
    $Last.Row = $Row;
    if ($Column -ge $Last.Width) {
        $Last.Column = 1
        $Last.Row++
    }
    $Last.Group.Height = ($Row * (DPISize 30) + (DPISize 20))

    return $CheckBox

}



#==============================================================================================================================================================================================
function CreateSettingsRadioField([byte]$Column=$Last.Column, [byte]$Row=$Last.Row, [switch]$Checked, [switch]$Disable, [string]$Text="", [string]$Info="", [string]$Name, [int16]$SaveAs, [int16]$Max, [string]$NameTextbox, [switch]$IsDebug) {
    
    $Checkbox = CreateCheckbox -X (($Column-1) * $FormDistance + (DPISize 15)) -Y ($Row * (DPISize 30) - (DPISize 10)) -Checked $Checked -Disable $Disable -IsRadio -Info $Info -IsDebug $IsDebug -Name $Name -SaveAs $SaveAs -SaveTo $Name -Max $Max
    $Textbox  = CreateTextBox  -X $Checkbox.Right -Y $Checkbox.Top -Width (DPISize 130) -Height (DPISize 15) -Length 20 -Text $Text -IsDebug $IsDebug -Name $NameTextbox

    $Last.Column = $column + 1;
    $Last.Row = $Row;
    if ($Column -ge $Last.Width) {
        $Last.Column = 1
        $Last.Row++
    }
    $Last.Group.Height = ($Row * (DPISize 30) + (DPISize 20))

    return $CheckBox

}



#==============================================================================================================================================================================================
function CreateErrorDialog([string]$Error, [boolean]$Fatal=$True, [boolean]$Once=$False) {
    
    # Create Dialog
    $ErrorDialog = CreateDialog -Width 900 -Height 700 -Icon $null

    $CloseButton = CreateButton -X ($ErrorDialog.Width / 2 - 80) -Y ($ErrorDialog.Height - 170) -Width 160 -Height 80 -Text "Close" -AddTo $ErrorDialog
    $CloseButton.Add_Click({ $ErrorDialog.Hide() })

    # Create the string that will be displayed on the window.
    $String = $Patcher.Title + " " + $Patcher.Version + " (" + $Patcher.Date + ")" + "{0}{0}"

    ShowPowerShellConsole $True

    if     ($Error -eq "Missing Files")     { $String += "Neccessary files are missing.{0}{0}Please download the Patcher64+ Tool again." }
    elseif ($Error -eq "Missing JSON")      { $String += ".JSON files are missing.{0}{0}Please download the Patcher64+ Tool again." }
    elseif ($Error -eq "Corrupted JSON")    { $String += ".JSON files are corrupted.{0}{0}Please download the Patcher64+ Tool again." }
    elseif ($Error -eq "Missing Modules")   { $String += ".PSM1 module files are missing for import.{0}{0}Please download the Patcher64+ Tool again." }
    elseif ($Error -eq "Restricted")        { $String += "Patcher64+ Tool is being run from a restricted folder:{0}" + $Paths.FullBase + "{0}{0}Please move the Patcher64+ Tool to another folder and run it again.{0}Locations such as Desktop, Downloads or My Documents are restricted.{0}{0}No assistance is given when this warning is shown." }
    elseif ($Error -eq "Forbidden Path")    { $String += "The filepath to the Patcher64+ Tool is illegal.{0}{0}Remove any special symbol characters from the filepath leading to the Patcher64+ Tool and try again.{0}{0}Only letters and numbers are allowed." }
    $String = [string]::Format($String, [Environment]::NewLine)

    #Create Label
    $ErrorFont = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Regular)
    $Label = CreateLabel -X 10 -Y 10 -Width ($ErrorDialog.Width - 10) -Height ($ErrorDialog.Height - 110) -Text $String -AddTo $ErrorDialog -Font $ErrorFont

    if ($Once) { $Settings.Core.DisplayedWarning = $True }
    if ($Fatal) {
        $global:FatalError = $True
        if (IsSet $MainDialog) { $MainDialog.Hide() }
        WriteToConsole "Error Level: Fatal" -Error
    }
    else { WriteToConsole "Error Level: Non-Fatal" -Error }
    $ErrorDialog.ShowDialog()

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function CreateOptionsPanel
Export-ModuleMember -Function CreateCreditsPanel
Export-ModuleMember -Function CreateSettingsPanel
Export-ModuleMember -Function CreateErrorDialog
Export-ModuleMember -Function ToggleDialog