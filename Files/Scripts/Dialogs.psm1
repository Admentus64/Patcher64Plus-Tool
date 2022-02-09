function CreateOptionsDialog([byte]$Columns, [int32]$Height, [Array]$Tabs=@()) {
    
    # Create Dialog
    if ( (IsSet $Columns) -and (IsSet $Height) )   { $global:OptionsDialog = CreateDialog -Width ($FormDistance * $Columns + (DPISize 60)) -Height (DPISize $Height) }
    else                                           { $global:OptionsDialog = CreateDialog -Width ($FormDistance * 4        + (DPISize 60)) -Height (DPISize 640) }
    $OptionsDialog.Icon = $Files.icon.additional

    # Close Button
    $X = $OptionsDialog.Width / 2 - (DPISize 40)
    $Y = $OptionsDialog.Height - (DPISize 90)
    $CloseButton = CreateButton -X $X -Y $Y -Width (DPISize 80) -Height (DPISize 35) -Text "Close" -AddTo $OptionsDialog

    $CloseButton.Add_Click( { StopJobs; $OptionsDialog.Hide() })

    # Options Label
    $global:OptionsLabel = CreateLabel -Y (DPISize 15) -Width $OptionsDialog.width -Height (DPISize 15) -Font $Fonts.SmallBold -Text ($GameType.mode + " - Additional Options") -AddTo $OptionsDialog
    $OptionsLabel.AutoSize = $True
    $OptionsLabel.Left = ([Math]::Floor($OptionsDialog.Width / 2) - [Math]::Floor($OptionsLabel.Width / 2))

    # Reset Options
    $Redux.Box = @{}
    $Redux.Groups = @()
    $Last.Group = $Last.Panel = $Last.GroupName = $Last.Hide = $null
    $Last.Half = $False
    $Redux.Panel = CreatePanel -Width $OptionsDialog.Width -Height $OptionsDialog.Height -AddTo $OptionsDialog
    CreateTabButtons $Tabs

    # Lock GUI if needed
    if (Get-Command "AdjustGUI" -errorAction SilentlyContinue) { iex "AdjustGUI" }

}



#==============================================================================================================================================================================================
function CreateLanguageContent($Columns=[byte][Math]::Round($Redux.Panel.Width / $ColumnWidth)) {
    
    $file = $Files.json.languages

    # Box + Panel
    $Rows = [Math]::Ceiling($file.length / $Columns)
    CreateReduxGroup -Text "Languages" -Tag "Language" -Height $Rows
    $Last.Group.IsLanguage = $True
    CreateReduxPanel -Rows $Rows

    if (IsSet $file) {
        $Row = $Column = 0
        for ($i=0; $i -lt $file.length; $i++) {
            if ($i % $Columns -ne 0) { $Column += 1 }
            else {
                $Column = 0
                $Row += 1
            }
            if (IsSet $file[$i].warning)   { $warning = ([string]::Format($file[$i].warning, [Environment]::NewLine)) }
            else                           { $warning = $null }
            if ($file[$i].default -eq 1)   { $Redux.Language[$i] = CreateReduxRadioButton -Column ($Column+1) -Row $Row -Text $file[$i].title -Info ("Play the game in " + $file[$i].title) -Warning $warning -Name $file[$i].title -Credits $file[$i].credits -SaveTo "Translation" -Checked }
            else                           { $Redux.Language[$i] = CreateReduxRadioButton -Column ($Column+1) -Row $Row -Text $file[$i].title -Info ("Play the game in " + $file[$i].title) -Warning $warning -Name $file[$i].title -Credits $file[$i].credits -SaveTo "Translation" }
        }
    
        $HasDefault = $False
        foreach ($i in 0..($file.Length-1)) {
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

    if ($DisableHighDPIMode) { $width = 830 } else { $width = 810 }
    $global:CreditsDialog = CreateDialog -Width (DPISize $width) -Height (DPISize 500) -Icon $Files.icon.credits
    $CloseButton = CreateButton -X ($CreditsDialog.Width / 2 - (DPISize 40)) -Y ($CreditsDialog.Height - (DPISize 90)) -Width (DPISize 80) -Height (DPISize 35) -Text "Close" -AddTo $CreditsDialog
    $CloseButton.Add_Click({ $CreditsDialog.Hide() })

    # Create Switch subpanel buttons
    $global:Credits = @{}

    # Create the version number and script name label
    $InfoLabel = CreateLabel -X ($CreditsDialog.Width / 2 - $String.Width - (DPISize 100)) -Y (DPISize 10) -Width (DPISize 200) -Height (DPISize 15) -Font $Fonts.SmallBold -Text ($ScriptName + " " + $Version + " (" + $VersionDate + ")") -AddTo $CreditsDialog

    # Create Text Box
    $Credits.Sections = @()
    $Credits.Sections += CreateTextBox -X (DPISize 40) -Y (DPISize 30) -Width ($CreditsDialog.Width - (DPISize 100)) -Height ($CloseButton.Top - (DPISize 40)) -ReadOnly -Multiline -AddTo $CreditsDialog -Tag "Info" -TextFileFont
    $Credits.Sections += CreateTextBox -X $Credits.Sections[0].Left -Y $Credits.Sections[0].Top -Width $Credits.Sections[0].Width -Height $Credits.Sections[0].Height -ReadOnly -Multiline -AddTo $CreditsDialog -Tag "Credits"  -TextFileFont
    $Credits.Sections += CreateTextBox -X $Credits.Sections[0].Left -Y $Credits.Sections[0].Top -Width $Credits.Sections[0].Width -Height $Credits.Sections[0].Height -ReadOnly -Multiline -AddTo $CreditsDialog -Tag "GameID's" -TextFileFont
    AddTextFileToTextbox -TextBox $Credits.Sections[2] -File $Files.text.gameID
    $Credits.Sections += CreatePanel   -X $Credits.Sections[0].Left -Y $Credits.Sections[0].Top -Width $Credits.Sections[0].Width -Height $Credits.Sections[0].Height -AddTo $CreditsDialog -Tag "Misc"
    $Credits.Sections += CreatePanel   -X $Credits.Sections[0].Left -Y $Credits.Sections[0].Top -Width $Credits.Sections[0].Width -Height $Credits.Sections[0].Height -AddTo $CreditsDialog -Tag "Checksum"

    # Support
    $SupportLabel  = CreateLabel -X (DPISize 10)         -Y (DPISize 10)                          -Width (DPISize 200) -Height (DPISize 15) -Font $Fonts.SmallBold      -Text ("--- Support or visit me at ---")   -AddTo $Credits.Sections[3]

    $Discord1Label = CreateLabel -X (DPISize 10)         -Y ($SupportLabel.Bottom + (DPISize 2))  -Width (DPISize 150) -Height (DPISize 15) -Font $Fonts.SmallBold      -Text ("Discord")                          -AddTo $Credits.Sections[3]
    $Discord2Label = CreateLabel -X $Discord1Label.Right -Y ($SupportLabel.Bottom + (DPISize 2))  -Width (DPISize 140) -Height (DPISize 15) -Font $Fonts.SmallUnderline -Text ("https://discord.gg/P22GGzz")       -AddTo $Credits.Sections[3]
    $GitHub1Label  = CreateLabel -X (DPISize 10)         -Y ($Discord1Label.Bottom + (DPISize 2)) -Width (DPISize 150) -Height (DPISize 15) -Font $Fonts.SmallBold      -Text ("GitHub")                           -AddTo $Credits.Sections[3]
    $GitHub2Label  = CreateLabel -X $GitHub1Label.Right  -Y ($Discord1Label.Bottom + (DPISize 2)) -Width (DPISize 180) -Height (DPISize 15) -Font $Fonts.SmallUnderline -Text ("https://github.com/Admentus64")    -AddTo $Credits.Sections[3]
    
    $Patreon1Label = CreateLabel -X (DPISize 10)         -Y ($GitHub1Label.Bottom + (DPISize 2))  -Width (DPISize 150) -Height (DPISize 15) -Font $Fonts.SmallBold             -Text ("Patreon")                   -AddTo $Credits.Sections[3]
    $Patreon2Label = CreateLabel -X $Patreon1Label.Right -Y ($GitHub1Label.Bottom + (DPISize 2))  -Width (DPISize 150) -Height (DPISize 15) -Font $Fonts.SmallUnderline -Text ("www.patreon.com/Admentus")         -AddTo $Credits.Sections[3]
    $PayPal1Label  = CreateLabel -X (DPISize 10)         -Y ($Patreon1Label.Bottom + (DPISize 2)) -Width (DPISize 150) -Height (DPISize 15) -Font $Fonts.SmallBold             -Text ("PayPal")                    -AddTo $Credits.Sections[3]
    $PayPal2Label  = CreateLabel -X $PayPal1Label.Right  -Y ($Patreon1Label.Bottom + (DPISize 2)) -Width (DPISize 200) -Height (DPISize 15) -Font $Fonts.SmallUnderline -Text ("www.paypal.com/paypalme/Admentus") -AddTo $Credits.Sections[3]

    $Discord2Label.add_Click( { [system.Diagnostics.Process]::start("https://discord.gg/P22GGzz") } )
    $GitHub2Label.add_Click(  { [system.Diagnostics.Process]::start("https://github.com/Admentus64") } )
    $Patreon2Label.add_Click( { [system.Diagnostics.Process]::start("https://www.patreon.com/Admentus") } )
    $PayPal2Label.add_Click(  { [system.Diagnostics.Process]::start("https://www.paypal.com/paypalme/Admentus/") } )
    $Discord2Label.ForeColor = $GitHub2Label.ForeColor = $Patreon2Label.ForeColor = $PayPal2Label.ForeColor = "Blue"

    # Support Me QR
    $SwishLabel = CreateLabel -X (DPISize 470) -Y (DPISize 10) -Height (DPISize 15) -Font $Fonts.SmallBold -Text ("Swish") -AddTo $Credits.Sections[3]
    $PictureBox = New-Object Windows.Forms.PictureBox
    $PictureBox.Location = New-object System.Drawing.Size($SwishLabel.Left, ($SwishLabel.Bottom + (DPISize 5)))
    SetBitmap -Path ($Paths.Main + "\qr.png") -Box $PictureBox -Width 125 -Height 125
    $PictureBox.Width  = $PictureBox.Image.Size.Width
    $PictureBox.Height = $PictureBox.Image.Size.Height
    $Credits.Sections[3].controls.add($PictureBox)



    # Documentation
    $SourcesLabel    = CreateLabel -X (DPISize 10)        -Y ($PayPal2Label.Bottom + (DPISize 80)) -Width (DPISize 150) -Height (DPISize 15) -Font $Fonts.SmallBold      -Text ("--- Sources ---")                                                                     -AddTo $Credits.Sections[3]
    
    $Shadow1Label    = CreateLabel -X (DPISize 10)        -Y ($SourcesLabel.Bottom  + (DPISize 2)) -Width (DPISize 150) -Height (DPISize 15) -Font $Fonts.SmallBold      -Text ("ShadowOne333's GitHub")                                                               -AddTo $Credits.Sections[3]
    $Shadow2Label    = CreateLabel -X $Shadow1Label.Right -Y ($SourcesLabel.Bottom  + (DPISize 2)) -Width (DPISize 340) -Height (DPISize 15) -Font $Fonts.SmallUnderline -Text ("https://github.com/ShadowOne333/Zelda64-Redux-Documentation")                         -AddTo $Credits.Sections[3]
    
    $Female1Label    = CreateLabel -X (DPISize 10)        -Y ($Shadow1Label.Bottom  + (DPISize 2)) -Width (DPISize 150) -Height (DPISize 15) -Font $Fonts.SmallBold      -Text ("Feminine Pronouns Script`nBy Mil")                                                    -AddTo $Credits.Sections[3]
    $Female2Label    = CreateLabel -X $Female1Label.Right -Y ($Shadow1Label.Bottom  + (DPISize 2)) -Width (DPISize 470) -Height (DPISize 15) -Font $Fonts.SmallUnderline -Text ("https://docs.google.com/spreadsheets/d/1Ihccm8noxsfHZfN1E3Gkccov1F27WXXxl-rxOuManUk") -AddTo $Credits.Sections[3]

    $Skilar1Label    = CreateLabel -X (DPISize 10)        -Y ($Female1Label.Bottom  + (DPISize 2)) -Width (DPISize 150) -Height (DPISize 15) -Font $Fonts.SmallBold      -Text ("Skilarbabcock's YouTube")                                                             -AddTo $Credits.Sections[3]
    $Skilar2Label    = CreateLabel -X $Skilar1Label.Right -Y ($Female1Label.Bottom  + (DPISize 2)) -Width (DPISize 225) -Height (DPISize 15) -Font $Fonts.SmallUnderline -Text ("https://www.youtube.com/user/skilarbabcock")                                          -AddTo $Credits.Sections[3]

    $Malon1Label     = CreateLabel -X (DPISize 10)        -Y ($Skilar1Label.Bottom  + (DPISize 2)) -Width (DPISize 150) -Height (DPISize 15) -Font $Fonts.SmallBold      -Text ("Malon Rose YouTube")                                                                  -AddTo $Credits.Sections[3]
    $Malon2Label     = CreateLabel -X $Skilar1Label.Right -Y ($Skilar2Label.Bottom  + (DPISize 2)) -Width (DPISize 225) -Height (DPISize 15) -Font $Fonts.SmallUnderline -Text ("https://www.youtube.com/c/MalonRose")                                                 -AddTo $Credits.Sections[3]

    $Luigi1Label     = CreateLabel -X (DPISize 10)        -Y ($Malon1Label.Bottom   + (DPISize 2)) -Width (DPISize 150) -Height (DPISize 15) -Font $Fonts.SmallBold      -Text ("theluigidude2007 YouTube")                                                            -AddTo $Credits.Sections[3]
    $Luigi2Label     = CreateLabel -X $Malon1Label.Right  -Y ($Malon2Label.Bottom   + (DPISize 2)) -Width (DPISize 300) -Height (DPISize 15) -Font $Fonts.SmallUnderline -Text ("www.youtube.com/channel/UC3071imQKR5cEIobsFHLW9Q")                                    -AddTo $Credits.Sections[3]

    $Darunia1Label   = CreateLabel -X (DPISize 10)        -Y ($Luigi1Label.Bottom   + (DPISize 2)) -Width (DPISize 150) -Height (DPISize 15) -Font $Fonts.SmallBold      -Text ("Darunias Joy GitHub")                                                                 -AddTo $Credits.Sections[3]
    $Darunia2Label   = CreateLabel -X $Malon1Label.Right  -Y ($Luigi2Label.Bottom   + (DPISize 2)) -Width (DPISize 275) -Height (DPISize 15) -Font $Fonts.SmallUnderline -Text ("https://github.com/DaruniasJoy/OoT-Custom-Sequences")                                 -AddTo $Credits.Sections[3]

    $Fish1Label      = CreateLabel -X (DPISize 10)        -Y ($Darunia1Label.Bottom + (DPISize 2)) -Width (DPISize 150) -Height (DPISize 15) -Font $Fonts.SmallBold      -Text ("Fish-waffle64's GitHub")                                                              -AddTo $Credits.Sections[3]
    $Fish2Label      = CreateLabel -X $Malon1Label.Right  -Y ($Darunia2Label.Bottom + (DPISize 2)) -Width (DPISize 260) -Height (DPISize 15) -Font $Fonts.SmallUnderline -Text ("https://github.com/Fish-waffle64/Feeshs-MM-Music")                                    -AddTo $Credits.Sections[3]

    $LuigiHero1Label = CreateLabel -X (DPISize 10)        -Y ($Fish1Label.Bottom    + (DPISize 2)) -Width (DPISize 150) -Height (DPISize 15) -Font $Fonts.SmallBold      -Text ("LuigiXHero's GitHub")                                                                 -AddTo $Credits.Sections[3]
    $LuigiHero2Label = CreateLabel -X $Malon1Label.Right  -Y ($Fish2Label.Bottom    + (DPISize 2)) -Width (DPISize 300) -Height (DPISize 15) -Font $Fonts.SmallUnderline -Text ("https://github.com/LuigiXHero/OoT-Randomizer-Music-Pack")                             -AddTo $Credits.Sections[3]

    $Shadow2Label.add_Click(    { [system.Diagnostics.Process]::start("https://github.com/ShadowOne333/Zelda64-Redux-Documentation") } )
    $Female2Label.add_Click(    { [system.Diagnostics.Process]::start("https://docs.google.com/spreadsheets/d/1Ihccm8noxsfHZfN1E3Gkccov1F27WXXxl-rxOuManUk") } )
    $Skilar2Label.add_Click(    { [system.Diagnostics.Process]::start("https://www.youtube.com/user/skilarbabcock") } )
    $Malon2Label.add_Click(     { [system.Diagnostics.Process]::start("https://www.youtube.com/c/MalonRose") } )
    $Luigi2Label.add_Click(     { [system.Diagnostics.Process]::start("https://www.youtube.com/channel/UC3071imQKR5cEIobsFHLW9Q") } )
    $Darunia2Label.add_Click(   { [system.Diagnostics.Process]::start("https://github.com/DaruniasJoy/OoT-Custom-Sequences") } )
    $Fish2Label.add_Click(      { [system.Diagnostics.Process]::start("https://github.com/Fish-waffle64/Feeshs-MM-Music") } )
    $LuigiHero2Label.add_Click( { [system.Diagnostics.Process]::start("https://github.com/LuigiXHero/OoT-Randomizer-Music-Pack") } )

    $Shadow2Label.ForeColor = $Female2Label.ForeColor = $Skilar2Label.ForeColor = $Malon2Label.ForeColor = $Luigi2Label.ForeColor = $Darunia2Label.ForeColor = $Fish2Label.ForeColor = $LuigiHero2Label.ForeColor = "Blue"


    
    # Hash
    $global:VerificationInfo = @{}

    $VerificationInfo.HashText              = CreateLabel -X (DPISize 10) -Y (DPISize 20) -Width (DPISize 120) -Height (DPISize 15) -Font $Fonts.SmallBold -Text "ROM Hashsum:" -AddTo $Credits.Sections[4]
    $VerificationInfo.HashField             = CreateTextBox -X $VerificationInfo.HashText.Right -Y ($VerificationInfo.HashText.Top - (DPISize 3)) -Width ($Credits.Sections[4].Width - $VerificationInfo.HashText.Width - (DPISize 100))  -Height (DPISize 50) -AddTo $Credits.Sections[4]
    $VerificationInfo.HashField.ReadOnly    = $True

    $VerificationInfo.GameText              = CreateLabel -X (DPISize 10) -Y ($VerificationInfo.HashField.Bottom + (DPISize 10)) -Width (DPISize 120) -Height (DPISize 15) -Font $Fonts.SmallBold -Text "Current Game:" -AddTo $Credits.Sections[4]
    $VerificationInfo.GameField             = CreateTextBox -X $VerificationInfo.GameText.Right -Y ($VerificationInfo.GameText.Top - (DPISize 3)) -Width ($Credits.Sections[4].Width - $VerificationInfo.GameText.Width - (DPISize 100)) -Height (DPISize 50) -Text "No ROM Selected" -AddTo $Credits.Sections[4]
    $VerificationInfo.GameField.ReadOnly    = $True

    $VerificationInfo.RegionText            = CreateLabel -X (DPISize 10) -Y ($VerificationInfo.GameField.Bottom + (DPISize 10)) -Width (DPISize 120) -Height (DPISize 15) -Font $Fonts.SmallBold -Text "Current Region:" -AddTo $Credits.Sections[4]
    $VerificationInfo.RegionField           = CreateTextBox -X $VerificationInfo.RegionText.Right -Y ($VerificationInfo.RegionText.Top - (DPISize 3)) -Width ($Credits.Sections[4].Width - $VerificationInfo.RegionText.Width - (DPISize 100)) -Height (DPISize 50) -Text "No ROM Selected" -AddTo $Credits.Sections[4]
    $VerificationInfo.RegionField.ReadOnly  = $True

    $VerificationInfo.RevText               = CreateLabel -X (DPISize 10) -Y ($VerificationInfo.RegionField.Bottom + (DPISize 10)) -Width (DPISize 120) -Height (DPISize 15) -Font $Fonts.SmallBold -Text "Current Revision:" -AddTo $Credits.Sections[4]
    $VerificationInfo.RevField              = CreateTextBox -X $VerificationInfo.RevText.Right -Y ($VerificationInfo.RevText.Top - (DPISize 3)) -Width ($Credits.Sections[4].Width - $VerificationInfo.RevText.Width - (DPISize 100)) -Height (DPISize 50) -Text "No ROM Selected" -AddTo $Credits.Sections[4]
    $VerificationInfo.RevField.ReadOnly     = $True
    
    $VerificationInfo.SupportText           = CreateLabel -X (DPISize 10) -Y ($VerificationInfo.RevField.Bottom + (DPISize 10)) -Width (DPISize 120) -Height (DPISize 15) -Font $Fonts.SmallBold -Text "Supported ROM:" -AddTo $Credits.Sections[4]
    $VerificationInfo.SupportField          = CreateTextBox -X $VerificationInfo.SupportText.Right -Y ($VerificationInfo.SupportText.Top - (DPISize 3)) -Width ($Credits.Sections[4].Width - $VerificationInfo.SupportText.Width - (DPISize 100)) -Height (DPISize 50) -Text "No ROM Selected" -AddTo $Credits.Sections[4]
    $VerificationInfo.SupportField.ReadOnly = $True

    SetCreditsSections
    CalculateHashSum

}



#==============================================================================================================================================================================================
function CreateSettingsDialog() {
    
    # Create Dialog
    $global:SettingsDialog = CreateDialog -Width (DPISize 560) -Height (DPISize 580) -Icon $Files.icon.settings
    $CloseButton = CreateButton -X ($SettingsDialog.Width / 2 - (DPISize 40)) -Y ($SettingsDialog.Height - (DPISize 90)) -Width (DPISize 80) -Height (DPISize 35) -Text "Close" -AddTo $SettingsDialog
    $CloseButton.Add_Click({ $SettingsDialog.Hide() })

    # Create the version number and script name label
    $InfoLabel = CreateLabel -X ($SettingsDialog.Width / 2 - $String.Width - (DPISize 100)) -Y (DPISize 10) -Width (DPISize 220) -Height (DPISize 15) -Font $Fonts.SmallBold -Text ($ScriptName + " " + $Version + " (" + $VersionDate + ")") -AddTo $SettingsDialog

    $global:GeneralSettings = @{}
    
    # General Settings
    $GeneralSettings.Box                 = CreateReduxGroup -Y (DPISize 40) -IsGame $False -Height 2 -AddTo $SettingsDialog -Text "General Settings"
    $GeneralSettings.DoubleClick         = CreateSettingsCheckbox                          -Column 1 -Row 1 -Text "Double Click" -Disable ((GetWindowsVersion) -ge 11) -Info "Allows a PowerShell file to be opened by double-clicking it"
    if ((GetWindowsVersion) -lt 11) { $GeneralSettings.DoubleClick.Checked = ((Get-ItemProperty -LiteralPath "HKLM:\Software\Classes\Microsoft.PowerShellScript.1\Shell").'(default)' -eq '0') }
    $GeneralSettings.ClearType           = CreateSettingsCheckbox -Name "ClearType"        -Column 2 -Row 1 -Text "Use ClearType Font"      -Checked -Info ('Use the ClearType font "Segoe UI" instead of the default font "Microsft Sans Serif"' + "`nThe option will only go in effect when opening the tool`nThis change requires the tool to restart to be applied")
    $GeneralSettings.HiDPIMode           = CreateSettingsCheckbox -Name "HiDPIMode"        -Column 3 -Row 1 -Text "Use Hi-DPI Mode"         -Checked -Info "Enables Hi-DPI Mode suitable for higher resolution displays`nThe option will only go in effect when opening the tool`nThis change requires the tool to restart to be applied"
    $GeneralSettings.ModernStyle         = CreateSettingsCheckbox -Name "ModernStyle"      -Column 1 -Row 2 -Text "Use Modern Visual Style" -Checked -Info "Use a modern-looking visual style for the whole interface of the tool"
    $GeneralSettings.EnableSounds        = CreateSettingsCheckbox -Name "EnableSounds"     -Column 2 -Row 2 -Text "Enable Sound Effects"    -Checked -Info "Enable the use of sound effects, for example when patching is concluded"
    $GeneralSettings.LocalTempFolder     = CreateSettingsCheckbox -Name "LocalTempFolder"  -Column 3 -Row 2 -Text "Use Local Temp Folder"   -Checked -Info "Store all temporary and extracted files within the local Patcher64+ Tool folder`nIf unchecked the temporary and extracted files are kept in the Patcher64+ Tool folder in %AppData%"
    

    # Advanced Settings
    $GeneralSettings.Box                 = CreateReduxGroup -Y ($GeneralSettings.Box.Bottom + (DPISize 10)) -IsGame $False -Height 1 -AddTo $SettingsDialog -Text "Advanced Settings"
    $GeneralSettings.IgnoreChecksum      = CreateSettingsCheckbox -Name "IgnoreChecksum"   -Column 1 -Row 1 -Text "Ignore Input Checksum" -IsDebug -Info "Do not check the checksum of a ROM or WAD and patch it regardless`nDowngrade is no longer forced anymore if the checksum is different than the supported revision`nThis option also skips the maximum ROM size verification`n`nDO NOT REPORT ANY BUGS IF THIS OPTION IS ENABLED!"
    $GeneralSettings.ForceExtract        = CreateSettingsCheckbox -Name "ForceExtract"     -Column 2 -Row 1 -Text "Force Extract"         -IsDebug -Info "Always extract game data required for patching even if it was already extracted on a previous run"
    $GeneralSettings.ForceOptions        = CreateSettingsCheckbox -Name "ForceOptions"     -Column 3 -Row 1 -Text "Force Show Options"    -IsDebug -Info ("Always show the " + '"Additional Options"' + " checkbox if it can be supported`n`nDO NOT REPORT ANY BUGS IF THIS OPTION IS ENABLED!")

    # Debug Settings
    $GeneralSettings.Box                 = CreateReduxGroup -Y ($GeneralSettings.Box.Bottom + (DPISize 10)) -IsGame $False -Height 3 -AddTo $SettingsDialog -Text "Debug Settings"
    $GeneralSettings.Console             = CreateSettingsCheckbox -Name "Console"          -Column 1 -Row 1 -Text "Console"               -IsDebug -Info "Show the console log"
    $GeneralSettings.Stop                = CreateSettingsCheckbox -Name "Stop"             -Column 2 -Row 1 -Text "Stop Patching"         -IsDebug -Info "Do not start the patching process and only show the debug information for the console log or log file"
    $GeneralSettings.Logging             = CreateSettingsCheckbox -Name "Logging"          -Column 3 -Row 1 -Text "Logging"      -Checked -IsDebug -Info "Write all events of Patcher64+ into log files"
    $GeneralSettings.CreateBPS           = CreateSettingsCheckbox -Name "CreateBPS"        -Column 1 -Row 2 -Text "Create BPS"            -IsDebug -Info "Create compressed and decompressed BPS patches when patching is concluded"
    $GeneralSettings.NoCleanup           = CreateSettingsCheckbox -Name "NoCleanup"        -Column 2 -Row 2 -Text "No Cleanup"            -IsDebug -Info "Do not clean up the files after the patching process fails or succeeds"
    $GeneralSettings.NoHeaderChange      = CreateSettingsCheckbox -Name "NoHeaderChange"   -Column 3 -Row 2 -Text "No Header Change"      -IsDebug -Info "Do not change the title header of the ROM when patching is concluded"
    $GeneralSettings.NoChannelChange     = CreateSettingsCheckbox -Name "NoChannelChange"  -Column 1 -Row 3 -Text "No Channel Change"     -IsDebug -Info "Do not change the channel title and channel GameID of the WAD when patching is concluded"
    $GeneralSettings.KeepDowngraded      = CreateSettingsCheckbox -Name "KeepDowngraded"   -Column 2 -Row 3 -Text "Keep Downgraded"       -IsDebug -Info "Keep the downgraded patched ROM in the output folder"
    $GeneralSettings.KeepConverted       = CreateSettingsCheckbox -Name "KeepConverted"    -Column 3 -Row 3 -Text "Keep Converted"        -IsDebug -Info "Keep the converted patched ROM in the output folder"

    # Debug Settings (Nintendo 64)
    $GeneralSettings.Box                 = CreateReduxGroup -Y ($GeneralSettings.Box.Bottom + (DPISize 10)) -IsGame $False -Height 2 -AddTo $SettingsDialog -Text "Debug Settings (Nintendo 64)"
    $GeneralSettings.KeepDecompressed    = CreateSettingsCheckbox -Name "KeepDecompressed" -Column 1 -Row 1 -Text "Keep Decompressed"     -IsDebug -Info "Keep the decompressed patched ROM in the output folder"
    $GeneralSettings.Rev0DungeonFiles    = CreateSettingsCheckbox -Name "Rev0DungeonFiles" -Column 2 -Row 1 -Text "Rev 0 Dungeon Files"   -IsDebug -Info "Extract the dungeon files from the OoT ROM (Rev 0 US) or MM ROM (Rev 0 US) as well when extracting dungeon files"
    $GeneralSettings.NoConversion        = CreateSettingsCheckbox -Name "NoConversion"     -Column 3 -Row 1 -Text "No Conversion"         -IsDebug -Info "Do not attempt to convert the ROM to a proper format"
    $GeneralSettings.NoCRCChange         = CreateSettingsCheckbox -Name "NoCRCChange"      -Column 1 -Row 2 -Text "No CRC Change"         -IsDebug -Info "Do not change the CRC of the ROM when patching is concluded"
    $GeneralSettings.NoCompression       = CreateSettingsCheckbox -Name "NoCompression"    -Column 2 -Row 2 -Text "No Compression"        -IsDebug -Info "Do not attempt to compress the ROM back again when patching is concluded`nThis can cause Wii VC WADs to freeze"

    # Settings preset
    $GeneralSettings.Box                 = CreateReduxGroup -Y ($GeneralSettings.Box.Bottom + (DPISize 10)) -IsGame $False -Height 2 -AddTo $SettingsDialog -Text "Settings Presets"
    $GeneralSettings.PresetsPanel        = CreateReduxPanel -Row 2 -AddTo $GeneralSettings.Box
    $GeneralSettings.Presets = @()
    $GeneralSettings.Presets            += CreateSettingsRadioField -Name "Preset" -SaveAs 1 -Max 6 -NameTextbox "Preset.Label1" -Column 1 -Row 1 -Checked -Text "Preset 1" -Info "Settings preset #1`nAll made settings are stored to this preset`nSettings are retrieved when selecting this preset again"
    $GeneralSettings.Presets            += CreateSettingsRadioField -Name "Preset" -SaveAs 2 -Max 6 -NameTextbox "Preset.Label2" -Column 2 -Row 1          -Text "Preset 2" -Info "Settings preset #2`nAll made settings are stored to this preset`nSettings are retrieved when selecting this preset again"
    $GeneralSettings.Presets            += CreateSettingsRadioField -Name "Preset" -SaveAs 3 -Max 6 -NameTextbox "Preset.Label3" -Column 3 -Row 1          -Text "Preset 3" -Info "Settings preset #3`nAll made settings are stored to this preset`nSettings are retrieved when selecting this preset again" 
    $GeneralSettings.Presets            += CreateSettingsRadioField -Name "Preset" -SaveAs 4 -Max 6 -NameTextbox "Preset.Label4" -Column 1 -Row 2          -Text "Preset 4" -Info "Settings preset #4`nAll made settings are stored to this preset`nSettings are retrieved when selecting this preset again"
    $GeneralSettings.Presets            += CreateSettingsRadioField -Name "Preset" -SaveAs 5 -Max 6 -NameTextbox "Preset.Label5" -Column 2 -Row 2          -Text "Preset 5" -Info "Settings preset #5`nAll made settings are stored to this preset`nSettings are retrieved when selecting this preset again"
    $GeneralSettings.Presets            += CreateSettingsRadioField -Name "Preset" -SaveAs 6 -Max 6 -NameTextbox "Preset.Label6" -Column 3 -Row 2          -Text "Preset 6" -Info "Settings preset #6`nAll made settings are stored to this preset`nSettings are retrieved when selecting this preset again"

    if ((GetWindowsVersion) -lt 11) { $GeneralSettings.DoubleClick.Add_CheckStateChanged( { TogglePowerShellOpenWithClicks $this.Checked } ) }
    $GeneralSettings.ModernStyle.Add_CheckStateChanged(     { SetModernVisualStyle $this.checked } )
    $GeneralSettings.ForceOptions.Add_CheckStateChanged(    { DisablePatches } )
    $GeneralSettings.EnableSounds.Add_CheckStateChanged(    { LoadSoundEffects $this.checked } )
    $GeneralSettings.Logging.Add_CheckStateChanged(         { SetLogging $this.checked } )

    # Local Temp Folder
    $GeneralSettings.LocalTempFolder.Add_CheckStateChanged( {
        if ($this.checked) { $Paths.Temp = $Paths.LocalTemp } else { $Paths.Temp = $Paths.AppDataTemp }
        SetTempFileParameters
    } )

    # Console
    $GeneralSettings.Console.Enabled = $ExternalScript
    $GeneralSettings.Console.Add_CheckStateChanged( { ShowPowerShellConsole $this.Checked } )

    # Presets
    foreach ($item in $GeneralSettings.Presets) {
        $item.Add_CheckedChanged( {
            foreach ($i in 0..($GeneralSettings.Presets.length-1)) {
                if (!$this.checked -and $GeneralSettings.Presets[$i] -eq $this) {
                    if ($GameType.save -gt 0) { Out-IniFile -FilePath ($Paths.Settings + "\" + $GameType.mode + " - " + ($i+1) + ".ini") -InputObject $GameSettings }
                }
            }
            $global:GameSettings = GetSettings -File (GetGameSettingsFile) -IsGame
            LoadAdditionalOptions
            DisableReduxOptions
        } )
    }

}



#==============================================================================================================================================================================================
function ResetTool() {
    
    $InputPaths.GameTextBox.Text = "Select or drag and drop your ROM or VC WAD file..."
    $InputPaths.InjectTextBox.Text = "Select or drag and drop your NES, SNES or N64 ROM..."
    $InputPaths.PatchTextBox.Text = "Select or drag and drop your BPS, IPS, Xdelta or VCDiff Patch File..."
    
    foreach ($item in $GeneralSettings) {
        if ($item.GetType() -eq [System.Windows.Forms.CheckBox]) { $item.Checked = $item.Default }
    }

    foreach ($item in $VC.GetEnumerator) {
        if ($item.GetType() -eq [System.Windows.Forms.CheckBox]) { $item.Checked = $item.Default }
    }

    $Patches.Downgrade.Checked = $Patches.Downgrade.Default
    $Patches.Redux.Checked = $Patches.Redux.Default
    $Patches.Options.Checked = $Patches.Options.Default
    $CustomHeader.EnableHeader.Checked = $CustomHeader.EnableHeader.Default
    $CustomHeader.EnableRegion.Checked = $CustomHeader.EnableRegion.Default
    
    $CurrentGame.Console.SelectedIndex = $CurrentGame.Console.Default
    $CurrentGame.Game.SelectedIndex = $CurrentGame.Game.Default
    $Patches.Type.SelectedIndex = $Patches.Type.Default
    $InputPaths.ApplyInjectButton.Enabled = $InputPaths.ApplyPatchButton.Enabled = $False

    RemoveFile ($Paths.Settings)
    $global:Settings = GetSettings ($Paths.Settings + "\Core.ini")
    $global:GameSettings = GetSettings (GetGameSettingsFile)

    RestoreCustomHeader
    ChangeGameMode
    SetWiiVCMode $False
    EnablePatchButtons $False
    SetMainScreenSize

    $global:GameIsSelected = $False
    [System.GC]::Collect() | Out-Null

}



#==============================================================================================================================================================================================
function ResetGame() {
    
    if (!(IsSet $Redux.Groups)) { return }

    foreach ($item in $Redux.Groups) {
        foreach ($form in $item.controls) {
            if     ($form.GetType() -eq [System.Windows.Forms.CheckBox])      { $form.Checked       = $form.Default }
            elseif ($form.GetType() -eq [System.Windows.Forms.RadioButton])   { $form.Checked       = $form.Default }
            elseif ($form.GetType() -eq [System.Windows.Forms.ComboBox])      { $form.SelectedIndex = $form.Default }
            elseif ($form.GetType() -eq [System.Windows.Forms.TextBox])       { $form.Text          = $form.Default }
            elseif ($form.GetType() -eq [System.Windows.Forms.TrackBar])      { $form.Value         = $form.Default }

            elseif ($form.GetType() -eq [System.Windows.Forms.Panel]) {
                foreach ($subform in $form.controls) {
                    if     ($subform.GetType() -eq [System.Windows.Forms.CheckBox])      { $subform.Checked       = $subform.Default }
                    elseif ($subform.GetType() -eq [System.Windows.Forms.RadioButton])   { $subform.Checked       = $subform.Default }
                    elseif ($subform.GetType() -eq [System.Windows.Forms.ComboBox])      { $subform.SelectedIndex = $subform.Default }
                    elseif ($subform.GetType() -eq [System.Windows.Forms.TextBox])       { $subform.Text          = $subform.Default }
                    elseif ($subform.GetType() -eq [System.Windows.Forms.TrackBar])      { $subform.Value         = $subform.Default }
                }
            }
        }
    }

    WriteToConsole "Current selected game options have been reset"
    [System.GC]::Collect() | Out-Null

}




#==============================================================================================================================================================================================
function CleanupFiles() {
    
    foreach ($item in $Files.json.games) {
        RemovePath ($Paths.Games + "\" + $item.mode + "\Extracted")
    }

    RemovePath $Paths.cygdrive
    RemovePath $Paths.Temp
    RemoveFile $Files.flipscfg
    RemoveFile $Files.stackdump

    WriteToConsole "All extracted files have been deleted"
    [System.GC]::Collect() | Out-Null

}



#==============================================================================================================================================================================================
function CreateSettingsCheckbox([byte]$Column=1, [byte]$Row=1, [switch]$Checked, [boolean]$Disable=$False, [string]$Text="", [string]$Info="", [string]$Name, [switch]$IsDebug) {
    
    $Checkbox = CreateCheckbox -X (($Column-1) * (DPISize 165) + (DPISize 15)) -Y ($Row * (DPISize 30) - (DPISize 10)) -Checked $Checked -Disable $Disable -IsRadio $False -Info $Info -IsDebug $IsDebug -Name $Name
    if (IsSet $Text) {  
        $Label = CreateLabel -X $CheckBox.Right -Y ($CheckBox.Top + (DPISize 3)) -Width (DPISize 135) -Height (DPISize 15) -Text $Text -Info $Info
        Add-Member -InputObject $Label    -NotePropertyMembers @{ CheckBox = $CheckBox }
        Add-Member -InputObject $CheckBox -NotePropertyMembers @{ Label    = $Text }
        $Label.Add_Click({
            if ($this.CheckBox.Enabled) { $this.CheckBox.Checked = !$this.CheckBox.Checked }
        })
    }

    return $CheckBox

}



#==============================================================================================================================================================================================
function CreateSettingsRadioField([byte]$Column=1, [byte]$Row=1, [switch]$Checked, [switch]$Disable, [string]$Text="", [string]$Info="", [string]$Name, [int16]$SaveAs, [int16]$Max, [string]$NameTextbox, [switch]$IsDebug) {
    
    $Checkbox = CreateCheckbox -X (($Column-1) * (DPISize 165) + (DPISize 15)) -Y ($Row * (DPISize 30) - (DPISize 10)) -Checked $Checked -Disable $Disable -IsRadio $True -Info $Info -IsDebug $IsDebug -Name $Name -SaveAs $SaveAs -SaveTo $Name -Max $Max
    $Textbox  = CreateTextBox  -X $Checkbox.Right -Y $Checkbox.Top -Width (DPISize 130) -Height (DPISize 15) -Length 20 -Text $Text -IsDebug $IsDebug -Name $NameTextbox

    return $CheckBox

}



#==============================================================================================================================================================================================
function CreateErrorDialog([string]$Error, [boolean]$Fatal=$True, [boolean]$Once=$False) {
    
    # Create Dialog
    $ErrorDialog = CreateDialog -Width 900 -Height 700 -Icon $null

    $CloseButton = CreateButton -X ($ErrorDialog.Width / 2 - 80) -Y ($ErrorDialog.Height - 170) -Width 160 -Height 80 -Text "Close" -AddTo $ErrorDialog
    $CloseButton.Add_Click({ $ErrorDialog.Hide() })

    # Create the string that will be displayed on the window.
    $String = $ScriptName + " " + $Version + " (" + $VersionDate + ")" + "{0}{0}"

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
        WriteToConsole "Error Level: Fatal"
    }
    else { WriteToConsole "Error Level: Non-Fatal" }
    $ErrorDialog.ShowDialog() | Out-Null

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function CreateLanguagesDialog
Export-ModuleMember -Function CreateOptionsDialog
Export-ModuleMember -Function CreateReduxDialog
Export-ModuleMember -Function CreateCreditsDialog
Export-ModuleMember -Function CreateSettingsDialog
Export-ModuleMember -Function CreateErrorDialog
Export-ModuleMember -Function CreateLanguageContent

Export-ModuleMember -Function ResetTool
Export-ModuleMember -Function ResetGame
Export-ModuleMember -Function CleanupFiles