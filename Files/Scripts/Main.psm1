function CreateMainDialog() {
    
    # Create the main dialog that is shown to the user.
    $global:MainDialog = New-Object System.Windows.Forms.Form
    $MainDialog.Text = $ScriptName
    $MainDialog.Size = DPISize (New-Object System.Drawing.Size(625, 745))
  # $MainDialog.MaximizeBox = $False
    $MainDialog.AutoScale = $True
    $MainDialog.AutoScaleMode = [Windows.Forms.AutoScaleMode]::None
    $MainDialog.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $MainDialog.StartPosition = "CenterScreen"
    $MainDialog.KeyPreview = $True
    $MainDialog.Add_Shown({ $MainDialog.Activate() })
    $MainDialog.Icon = $Files.icon.main

    # Menu bar
    $menuBarMain      = New-Object System.Windows.Forms.MenuStrip; $MainDialog.Controls.Add($menuBarMain)

    $menuBarFile      = New-Object System.Windows.Forms.ToolStripMenuItem; $menuBarFile.Text = "File"; $menuBarMain.Items.Add($menuBarFile)
    $menuBarEdit      = New-Object System.Windows.Forms.ToolStripMenuItem; $menuBarEdit.Text = "Edit"; $menuBarMain.Items.Add($menuBarEdit)
    $menuBarHelp      = New-Object System.Windows.Forms.ToolStripMenuItem; $menuBarHelp.Text = "Help"; $menuBarMain.Items.Add($menuBarHelp)

    $menuBarChecksum  = New-Object System.Windows.Forms.ToolStripButton; $menuBarChecksum.Text  = "Checksum";           $menuBarFile.DropDownItems.Add($menuBarChecksum)
    $menuBarExit      = New-Object System.Windows.Forms.ToolStripButton; $menuBarExit.Text      = "Exit";               $menuBarFile.DropDownItems.Add($menuBarExit)

    $menuBarSettings  = New-Object System.Windows.Forms.ToolStripButton; $menuBarSettings.Text  = "Settings";           $menuBarEdit.DropDownItems.Add($menuBarSettings)
    $menuBarResetAll  = New-Object System.Windows.Forms.ToolStripButton; $menuBarResetAll.Text  = "Reset All Settings"; $menuBarEdit.DropDownItems.Add($menuBarResetAll)
    $menuBarResetGame = New-Object System.Windows.Forms.ToolStripButton; $menuBarResetGame.Text = "Reset Current Game"; $menuBarEdit.DropDownItems.Add($menuBarResetGame)
    $menuBarCleanup   = New-Object System.Windows.Forms.ToolStripButton; $menuBarCleanup.Text   = "Cleanup Files";      $menuBarEdit.DropDownItems.Add($menuBarCleanup)

    $menuBarInfo      = New-Object System.Windows.Forms.ToolStripButton; $menuBarInfo.Text      = "Info";               $menuBarHelp.DropDownItems.Add($menuBarInfo)
    $menuBarLinks     = New-Object System.Windows.Forms.ToolStripButton; $menuBarLinks.Text     = "Links";              $menuBarHelp.DropDownItems.Add($menuBarLinks)
    $menuBarCredits   = New-Object System.Windows.Forms.ToolStripButton; $menuBarCredits.Text   = "Credits";            $menuBarHelp.DropDownItems.Add($menuBarCredits)
    $menuBarGameID    = New-Object System.Windows.Forms.ToolStripButton; $menuBarGameID.Text    = "GameID";             $menuBarHelp.DropDownItems.Add($menuBarGameID)

    $menuBarChecksum.Add_Click(  { foreach ($item in $Credits.Sections) { $item.Visible = $False }; $Credits.Sections[4].Visible = $True; $CreditsDialog.ShowDialog() } )
    $menuBarExit.Add_Click(      { $MainDialog.Close() } )

    $menuBarSettings.Add_Click(  { $SettingsDialog.ShowDialog() } )
    $menuBarResetAll.Add_Click(  { ResetTool } )
    $menuBarResetGame.Add_Click( { ResetGame } )
    $menuBarCleanup.Add_Click(   { CleanupFiles } )

    $menuBarInfo.Add_Click(      { foreach ($item in $Credits.Sections) { $item.Visible = $False }; $Credits.Sections[0].Visible = $True; $CreditsDialog.ShowDialog() } )
    $menuBarLinks.Add_Click(     { foreach ($item in $Credits.Sections) { $item.Visible = $False }; $Credits.Sections[3].Visible = $True; $CreditsDialog.ShowDialog() } )
    $menuBarCredits.Add_Click(   { foreach ($item in $Credits.Sections) { $item.Visible = $False }; $Credits.Sections[1].Visible = $True; $CreditsDialog.ShowDialog() } )
    $menuBarGameID.Add_Click(    { foreach ($item in $Credits.Sections) { $item.Visible = $False }; $Credits.Sections[2].Visible = $True; $CreditsDialog.ShowDialog() } )



    # Create a label to show current mode.
    $global:CurrentModeLabel = CreateLabel -Font $Fonts.Medium -AddTo $MainDialog
    $CurrentModeLabel.AutoSize = $True

    # Create a label to show current version.
    $VersionLabel = CreateLabel -X (DPISize 15) -Y (DPISize 30) -Width (DPISize 130) -Height (DPISize 30) -Text ($Version + "`n(" + $VersionDate + ")") -Font $Fonts.SmallBold -AddTo $MainDialog

    # Create Arrays for groups
    $global:InputPaths = @{}; $global:Patches = @{}; $global:CurrentGame = @{}; $global:VC = @{}; $global:CustomHeader = @{}



    #############
    # Game Path #
    #############

    # Create the panel that holds the game path
    $InputPaths.GamePanel = CreatePanel -X (DPISize 10) -Width (DPISize 590) -Height (DPISize 50)

    # Create the groupbox that holds the WAD path
    $InputPaths.GameGroup = CreateGroupBox -Width $InputPaths.GamePanel.Width -Height $InputPaths.GamePanel.Height -Text "Game Path"
    $InputPaths.GameGroup.AllowDrop = $True
    $InputPaths.GameGroup.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputPaths.GameGroup.Add_DragDrop({ GamePath_DragDrop })

    # Create a textbox to display the selected WAD
    $InputPaths.GameTextBox = CreateTextBox -X (DPISize 10) -Y (DPISize 20) -Width (DPISize 420) -Height (DPISize 22) -Text "Select your ROM or VC WAD file..." -Name "Path.Game" -ReadOnly $True
    $InputPaths.GameTextBox.AllowDrop = $True
    $InputPaths.GameTextBox.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputPaths.GameTextBox.Add_DragDrop({ GamePath_DragDrop })

    # Create a button to allow manually selecting a ROM or WAD
    $InputPaths.GameButton = CreateButton -X ($InputPaths.GameTextBox.Right + (DPISize 6)) -Y (DPISize 18) -Width (DPISize 24) -Height (DPISize 22) -Text "..." -Info "Select your ROM or Wii VC WAD using file explorer"
    $InputPaths.GameButton.Add_Click({ GamePath_Button -TextBox $InputPaths.GameTextBox -Description "ROM/WAD Files" -FileNames @('*.wad', '*.z64', '*.n64', '*.v64', '*.sfc', '*.smc', '*.nes') })
    #"Image Files(*.BMP;*.JPG;*.GIF)|*.BMP;*.JPG;*.GIF|All files (*.*)|*.*"

    # Create a button to clear the WAD Path
    $InputPaths.ClearGameButton = CreateButton -X ($InputPaths.GameButton.Right + (DPISize 15)) -Y (DPISize 18) -Width ($InputPaths.GameGroup.Right - $InputPaths.GameButton.Right - (DPISize 30)) -Height (DPISize 22) -Text "Clear" -Info "Clear the selected paths (ROM / Wii VC WAD), ROM injection and custom patch"
    $InputPaths.ClearGameButton.Add_Click({
        if (IsSet -Elem $GamePath -MinLength 1) {
            $global:GamePath = $global:InjectPath = $global:PatchPath = $null
            $Settings["Core"][$InputPaths.GameTextBox.name] = $Settings["Core"][$InputPaths.InjectTextBox.name] = $Settings["Core"][$InputPaths.PatchTextBox.name] = ""
            $InputPaths.GameTextBox.Text = "Select your ROM or Wii VC WAD file..."
            $InputPaths.InjectTextBox.Text = "Select your ROM for injection..."
            $InputPaths.PatchTextBox.Text = "Select your custom patch file..."
            $global:GameIsSelected = $Patches.Button.Enabled = $CustomHeader.Panel.Enabled = $InputPaths.ClearGameButton.Enabled = $InputPaths.ApplyInjectButton.Enabled = $InputPaths.ApplyPatchButton.Enabled = $InputPaths.PatchPanel.Visible = $False
            if ($IsWiiVC) {
                SetWiiVCMode $False
                ChangeGamesList
            }
            SetMainScreenSize
        }
    })
    $InputPaths.ClearGameButton.Enabled = $False



    ###############
    # Inject Path #
    ###############

    # Create the panel that holds the inject path
    $InputPaths.InjectPanel = CreatePanel -X (DPISize 10) -Width (DPISize 590) -Height (DPISize 50)

    # Create the groupbox that holds the ROM path
    $InputPaths.InjectGroup = CreateGroupBox -Width $InputPaths.InjectPanel.Width -Heigh $InputPaths.InjectPanel.Height -Text "Inject ROM Path"
    $InputPaths.InjectGroup.AllowDrop = $True
    $InputPaths.InjectGroup.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputPaths.InjectGroup.Add_DragDrop({ InjectPath_DragDrop })

    # Create a textbox to display the selected ROM
    $InputPaths.InjectTextBox = CreateTextBox -X (DPISize 10) -Y (DPISize 20) -Width (DPISize 420) -Height (DPISize 22) -Text "Select your ROM for injection..." -Name "Path.Inject" -ReadOnly $True
    $InputPaths.InjectTextBox.AllowDrop = $True
    $InputPaths.InjectTextBox.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputPaths.InjectTextBox.Add_DragDrop({ InjectPath_DragDrop })

    # Create a button to allow manually selecting a ROM
    $InputPaths.InjectButton = CreateButton -X ($InputPaths.InjectTextBox.Right + (DPISize 6)) -Y (DPISize 18) -Width (DPISize 24) -Height (DPISize 22) -Text "..." -Info "Select your N64, SNES or NES ROM File using file explorer"
    $InputPaths.InjectButton.Add_Click({ InjectPath_Button -TextBox $InputPaths.InjectTextBox -Description "ROM Files" -FileNames @('*.z64', '*.n64', '*.v64', '*.sfc', '*.smc', '*.nes') })

    # Create a button to allow patch the WAD with a ROM file
    $InputPaths.ApplyInjectButton = CreateButton -X ($InputPaths.InjectButton.Right + (DPISize 15)) -Y (DPISize 18) -Width ($InputPaths.InjectGroup.Right - $InputPaths.InjectButton.Right - (DPISize 30)) -Height (DPISize 22) -Text "Inject ROM" -Info "Replace the ROM in your selected WAD File with your selected injection file"
    $InputPaths.ApplyInjectButton.Add_Click({ MainFunction -Command "Inject" -PatchedFileName "_injected" })
    $InputPaths.ApplyInjectButton.Enabled = $False



    ##############
    # Patch Path #
    ##############
    
    # Create the panel that holds the patch path.
    $InputPaths.PatchPanel = CreatePanel -X (DPISize 10) -Width (DPISize 590) -Height (DPISize 50)
    $InputPaths.PatchPanel.Visible = $False
    
    # Create the groupbox that holds the BPS path.
    $InputPaths.PatchGroup = CreateGroupBox -Width $InputPaths.PatchPanel.Width -Height $InputPaths.PatchPanel.Height -Text "Custom Patch Path"
    $InputPaths.PatchGroup.AllowDrop = $True
    $InputPaths.PatchGroup.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputPaths.PatchGroup.Add_DragDrop({ PatchPath_DragDrop })
    
    # Create a textbox to display the selected BPS.
    $InputPaths.PatchTextBox = CreateTextBox -X (DPISize 10) -Y (DPISize 20) -Width (DPISize 420) -Height (DPISize 22) -Text "Select your custom patch file..." -Name "Path.Patch" -ReadOnly $True
    $InputPaths.PatchTextBox.AllowDrop = $True
    $InputPaths.PatchTextBox.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputPaths.PatchTextBox.Add_DragDrop({ PatchPath_DragDrop })

    # Create a button to allow manually selecting a ROM.
    $InputPaths.PatchButton = CreateButton -X ($InputPaths.PatchTextBox.Right + (DPISize 6)) -Y (DPISize 18) -Width (DPISize 24) -Height (DPISize 22) -Text "..." -Info "Select your BPS, IPS, UPS, PPF, Xdelta or VCDiff Patch File using file explorer"
    $InputPaths.PatchButton.Add_Click({ PatchPath_Button -TextBox $InputPaths.PatchTextBox -Description "Patch Files" -FileNames @('*.bps', '*.ips', '*.ups' , '*.ppf' , '*.xdelta', '*.vcdiff') })
    
    # Create a button to allow patch the WAD with a BPS file.
    $InputPaths.ApplyPatchButton = CreateButton -X ($InputPaths.PatchButton.Right + (DPISize 15)) -Y (DPISize 18) -Width ($InputPaths.PatchGroup.Right - $InputPaths.PatchButton.Right - (DPISize 30)) -Height (DPISize 22) -Text "Apply Patch" -Info "Patch the ROM with your selected BPS, IPS, UPS, Xdelta or VCDiff Patch File"
    $InputPaths.ApplyPatchButton.Add_Click({ MainFunction -Command "Apply Patch" -PatchedFileName "_bps_patched" })
    $InputPaths.ApplyPatchButton.Enabled = $False



    ################
    # Current Game #
    ################

    # Create the panel that holds the current selected game.
    $CurrentGame.Panel = CreatePanel -Width (DPISize 590) -Height (DPISize 50)

    # Create the groupbox that holds the current game options
    $CurrentGame.Group = CreateGroupBox -Width $CurrentGame.Panel.Width -Height $CurrentGame.Panel.Height -Text "Current Game Mode"

    # Create a combobox with the list of supported consoles
    $CurrentGame.Console = CreateComboBox -X (DPISize 10) -Y (DPISize 20) -Width (DPISize 180) -Height (DPISize 30) -Name "Selected.Console"
    
    # Create a combobox with the list of supported games
    $CurrentGame.Game = CreateComboBox -X ($CurrentGame.Console.Right + (DPISize 5)) -Y (DPISize 20) -Width (DPISize 250) -Height (DPISize 30) -Name "Selected.Game"
    
    # Create combobox
    $CurrentGame.Rev = CreateComboBox -X ($CurrentGame.Game.Right + (DPISize 5)) -Y (DPISize 20) -Width (DPISize 125) -Height (DPISize 30) -Name "Selected.Rev"

    $global:PatchToolTip = CreateToolTip

    $Files.json.consoles = SetJSONFile $Files.json.consoles
    $Files.json.games    = SetJSONFile $Files.json.games



    #################
    # Custom Header #
    #################

    # Create the panel that holds the Custom Header.
    $CustomHeader.Panel = CreatePanel -Width (DPISize 590) -Height (DPISize 80)
    $CustomHeader.Panel.Enabled = $False

    # Create the groupbox that holds the Custom Header.
    $CustomHeader.Group = CreateGroupBox -Width $CustomHeader.Panel.Width -Height $CustomHeader.Panel.Height -Text "Custom Game Title and GameID"

    # Custom Title Checkbox
    $CustomHeader.EnableHeaderLabel = CreateLabel    -X (DPISize 10) -Y (DPISize 22) -Width (DPISize 50) -Height (DPISize 15) -Text "Enable:"                                              -Info "Enable in order to change the Game ID and title of the ROM or WAD file"
    $CustomHeader.EnableHeader      = CreateCheckBox -X ($CustomHeader.EnableHeaderLabel.Right) -Y (DPISize 20) -Width (DPISize 20) -Height (DPISize 20) -Name "CustomHeader.EnableHeader" -Info "Enable in order to change the Game ID and title of the ROM or WAD file"
    $CustomHeader.EnableHeaderLabel.Add_Click({ $CustomHeader.EnableHeader.Checked = !$CustomHeader.EnableHeader.Checked })

    # Custom ROM Title
    $CustomHeader.ROMTitleLabel = CreateLabel   -X ($CustomHeader.EnableHeader.Right)  -Y (DPISize 22) -Width (DPISize 75)  -Height (DPISize 15) -Text "ROM Title:" -Info "--- WARNING ---`nChanging the Game Title might causes issues with emulation for certain emulators and plugins, such as GlideN64"
    $CustomHeader.ROMTitle      = CreateTextBox -X ($CustomHeader.ROMTitleLabel.Right) -Y (DPISize 20) -Width (DPISize 250) -Height (DPISize 22) -Length 20         -Info "--- WARNING ---`nChanging the Game Title might causes issues with emulation for certain emulators and plugins, such as GlideN64"

    # Custom ROM GameID (N64 only)
    $CustomHeader.ROMGameIDLabel = CreateLabel   -X ($CustomHeader.ROMTitle.Right + (DPISize 10)) -Y (DPISize 22) -Width (DPISize 50) -Height (DPISize 15) -Text "GameID:" -Info "--- WARNING ---`nRequires four characters for acceptance`nThe fourth character sets the region and refresh rate`n`n--- REGION CODES ---`nE = USA`nJ = Japan`nP = PAL`nK = Korea"
    $CustomHeader.ROMGameID      = CreateTextBox -X ($CustomHeader.ROMGameIDLabel.Right)          -Y (DPISize 20) -Width (DPISize 55) -Height (DPISize 22) -Length 4       -Info "--- WARNING ---`nRequires four characters for acceptance`nThe fourth character sets the region and refresh rate`n`n--- REGION CODES ---`nE = USA`nJ = Japan`nP = PAL`nK = Korea"
    
    # Custom VC Title 
    $CustomHeader.VCTitleLabel = CreateLabel   -X ($CustomHeader.EnableHeader.Right) -Y (DPISize 22) -Width (DPISize 75)  -Height (DPISize 15) -Text "Channel Title:"
    $CustomHeader.VCTitle      = CreateTextBox -X ($CustomHeader.VCTitleLabel.Right) -Y (DPISize 20) -Width (DPISize 250) -Height (DPISize 22) -Length $VCTitleLength

    # Custom VC GameID (N64 only)
    $CustomHeader.VCGameIDLabel = CreateLabel   -X ($CustomHeader.VCTitle.Right + (DPISize 10)) -Y (DPISize 22) -Width (DPISize 50) -Height (DPISize 15) -Text "GameID:" -Info "--- WARNING ---`nRequires four characters for acceptance`nChanging the GameID causes Dolphin to recognize the VC title as a separate save file`n`n--- REGION CODES ---`nE = USA`nJ = Japan`nP = PAL`nK = Korea"
    $CustomHeader.VCGameID      = CreateTextBox -X ($CustomHeader.VCGameIDLabel.Right)          -Y (DPISize 20) -Width (DPISize 55) -Height (DPISize 22) -Length 4       -Info "--- WARNING ---`nRequires four characters for acceptance`nChanging the GameID causes Dolphin to recognize the VC title as a separate save file`n`n--- REGION CODES ---`nE = USA`nJ = Japan`nP = PAL`nK = Korea"

    # Custom Region Checkbox (SNES Only)
    $CustomHeader.EnableRegionLabel = CreateLabel    -X ($CustomHeader.EnableHeaderLabel.Left) -Y (DPISize 52) -Width (DPISize 50) -Height (DPISize 15) -Text "Enable:"                   -Info "Enable in order to change the Game ID and title of the ROM or WAD file"
    $CustomHeader.EnableRegion      = CreateCheckBox -X ($CustomHeader.EnableHeader.Left)      -Y (DPISize 50) -Width (DPISize 20) -Height (DPISize 20) -Name "CustomHeader.EnableRegion" -Info "Enable in order to change the Game ID and title of the ROM or WAD file"
    $CustomHeader.EnableRegionLabel.Add_Click({ $CustomHeader.EnableRegion.Checked = !$CustomHeader.EnableRegion.Checked })

    # Custom Region (SNES only)
    $CustomHeader.RegionLabel = CreateLabel -X ($CustomHeader.ROMTitleLabel.Left) -Y (DPISize 50) -Width (DPISize 55) -Height (DPISize 15) -Text "Region:" -Info "--- WARNING ---`nChanging the Region Code can softlock the game"
    $Items = @("Japan (NTSC)", "North America (NTSC)", "Europe (PAL)", "Sweden/Scandinavia (PAL)", "Finland (PAL)", "Denmark (PAL)", "France (SECAM)", "Netherlands (PAL)", "Spain (PAL)", "Germany (PAL)", "Italy (PAL)", "China (PAL)", "Indonesia (PAL)", "Kora (NTSC)", "Global", "Canada (NTSC)", "Brazil (PAL-M)", "Australia (PAL)", "Other (1)", "Other (2)", "Other (3)")
    $CustomHeader.Region = CreateComboBox   -X $CustomHeader.ROMTitle.Left -Y ($CustomHeader.RegionLabel.Top) -Width $CustomHeader.ROMTitle.Width -Height $CustomHeader.ROMTitle.Height -Items $Items -Default 2



    ###############
    # Patch Panel #
    ###############

    # Create a panel to contain everything for patches.
    $Patches.Panel = CreatePanel -Width (DPISize 590) -Height (DPISize 90)

    # Create a groupbox to show the patching buttons.
    $Patches.Group = CreateGroupBox -Width $Patches.Panel.Width -Height $Patches.Panel.Height

    # Create patch button
    $Patches.Button = CreateButton -X (DPISize 10) -Y (DPISize 45) -Width (DPISize 200) -Height (DPISize 35) -Text "Patch Selected Options"
    $Patches.Button.Font = $Fonts.SmallBold
    $Patches.Button.Add_Click( { MainFunction -Command $GamePatch.command -PatchedFileName $GamePatch.output } )
    $Patches.Button.Enabled = $False

    # Create editor button
    $Patches.Editor = CreateButton -X ($Patches.Button.right + (DPISize 5)) -Y $Patches.Button.top -Width (DPISize 95) -Height (DPISize 35) -Text "Open Editor" -Info "Open the text editor for adjusting the dialogue of the game"
    $Patches.Editor.Add_Click( {
        if ($global:Editor -eq $null) { CreateEditorDialog -Width 900 -Height 800  }
        $Editor.Dialog.ShowDialog()
    } )

    # Create Patches ComboBox
    $Patches.Type = CreateComboBox -X $Patches.Button.Left -Y ($Patches.Button.Top - (DPISize 25)) -Width ($Patches.Editor.Right - (DPISize 10)) -Height (DPISize 30) -Name "Selected.Patch"
    $global:PatchToolTip = CreateToolTip

    # Additional Options Checkbox
    $Patches.OptionsLabel = CreateLabel -X ($Patches.Editor.Right + (DPISize 10)) -Y ($Patches.Type.Top + (DPISize 5)) -Width (DPISize 85) -Height (DPISize 15) -Text "Enable Options:" -Info "Enable options in order to apply a customizable set of features and changes" 
    $Patches.Options = CreateCheckBox -X ($Patches.OptionsLabel.Right) -Y ($Patches.OptionsLabel.Top - (DPISize 2)) -Width (DPISize 20) -Height (DPISize 20) -Info "Enable options in order to apply a customizable set of features and changes" -Name "Patches.Options" -Checked $True
    $Patches.OptionsLabel.Add_Click({ $Patches.Options.Checked = !$Patches.Options.Checked })

    # Extend Checkbox
    $Patches.ExtendLabel = CreateLabel -X ($Patches.Editor.Right + (DPISize 10)) -Y ($Patches.OptionsLabel.Bottom + (DPISize 15)) -Width (DPISize 85) -Height (DPISize 15) -Text "Allow Extend:" -Info "Allows extending the ROM beyond it's regular size`nSome patches will automaticially force an extend of the ROM"
    $Patches.Extend = CreateCheckBox -X ($Patches.ExtendLabel.Right) -Y ($Patches.ExtendLabel.Top - (DPISize 2)) -Width (DPISize 20) -Height (DPISize 20) -Info "Allows extending the ROM beyond it's regular size`nSome patches will automaticially force an extend of the ROM" -Name "Patches.Extend"
    $Patches.ExtendLabel.Add_Click({ $Patches.Extend.Checked = !$Patches.Extend.Checked })

    # Redux Checkbox
    $Patches.ReduxLabel = CreateLabel -X ($Patches.Editor.Right + (DPISize 10)) -Y ($Patches.OptionsLabel.Bottom + (DPISize 15)) -Width (DPISize 85) -Height (DPISize 15) -Text "Enable Redux:" -Info "Enable the Redux patch which improves game mechanics`nIncludes among other changes the inclusion of the D-Pad for dedicated item buttons"
    $Patches.Redux = CreateCheckBox -X ($Patches.ReduxLabel.Right) -Y ($Patches.ReduxLabel.Top - (DPISize 2)) -Width (DPISize 20) -Height (DPISize 20) -Info "Enable the Redux patch which improves game mechanics`nIncludes among other changes the inclusion of the D-Pad for dedicated item buttons" -Name "Patches.Redux" -Checked $True
    $Patches.ReduxLabel.Add_Click({ $Patches.Redux.Checked = !$Patches.Redux.Checked })

    # Downgrade Checkbox
    $Patches.DowngradeLabel = CreateLabel -X ($Patches.OptionsLabel.Right + (DPISize 50)) -Y ($Patches.ReduxLabel.Top) -Width (DPISize 85) -Height (DPISize 15) -Text "Downgrade:" -Info "Downgrade the ROM to the first original revision"
    $Patches.Downgrade = CreateCheckBox -X ($Patches.DowngradeLabel.Right) -Y ($Patches.DowngradeLabel.Top - (DPISize 2)) -Width (DPISize 20) -Height (DPISize 20) -Info "Downgrade the ROM to the first original revision" -Name "Patches.Downgrade"
    $Patches.DowngradeLabel.Add_Click({ $Patches.Downgrade.Checked = !$Patches.Downgrade.Checked })

    # Patch Options
    $Patches.OptionsButton = CreateButton -X ($Patches.Group.Right - (DPISize 15) - (DPISize 145)) -Y ($Patches.Options.Top - (DPISize 3)) -Width (DPISize 145) -Height (DPISize 25) -Text "Select Options" -Info 'Open the "Additional Options" panel to change preferences'
    $Patches.OptionsButton.Add_Click( { $OptionsDialog.ShowDialog() } )



    ####################
    # Patch VC Options #
    ####################

    # Create a panel to show the patch options.
    $VC.Panel = CreatePanel -Width (DPISize 590) -Height (DPISize 105)

    # Create a groupbox to show the patch options.
    $VC.Group = CreateGroupBox -Width $VC.Panel.Width -Height $VC.Panel.Height -Text "Virtual Console - Patch Options"

    # Create a label for Patch VC Buttons
    $VC.ActionsLabel = CreateLabel -X (DPISize 10) -Y (DPISize 32) -Width (DPISize 55) -Height (DPISize 15) -Text "Actions" -Font $Fonts.SmallBold -AddTo $VC.Group

    # Create a button to extract the ROM
    $VC.ExtractROMButton = CreateButton -X ($VC.ActionsLabel.Right + (DPISize 10)) -Y ($VC.ActionsLabel.Top - (DPISize 7)) -Width (DPISize 150) -Height (DPISize 30) -Text "Extract ROM Only" -Info "Only extract the ROM from the WAD file`nUseful for native N64 emulators"
    $VC.ExtractROMButton.Add_Click({ MainFunction -Command "Extract" -PatchedFileName "_extracted" })

    # Create a button to show the global settings panel
    $VC.RemapControlsButton = CreateButton -X ($VC.ExtractROMButton.Right + (DPISize 10)) -Y ($VC.ActionsLabel.Top - (DPISize 7)) -Width (DPISize 150) -Height (DPISize 30) -Text "Remap VC Controls" -Info "Open the Virtual Console remap settings panel"
    $VC.RemapControlsButton.Add_Click({ $VCRemapDialog.ShowDialog() | Out-Null })

    # Create a label for Core patches
    $VC.OptionsLabel = CreateLabel -X (DPISize 10) -Y (DPISize 62) -Width (DPISize 55) -Height (DPISize 15) -Text "Options" -Font $Fonts.SmallBold

    # Remove T64 description
    $VC.RemoveT64Label = CreateLabel    -X ($VC.OptionsLabel.Right + (DPISize 20)) -Y ($VC.OptionsLabel.Top) -Width (DPISize 95) -Height (DPISize 15) -Text "Remove All T64:" -Info "Remove all textures that the Virtual Console replaced in the ROM`nThese replaced textures are known as T64`nThese replaced textures maybe be censored or to make the game look darker more fitting for the Wii"
    $VC.RemoveT64      = CreateCheckBox -X ($VC.RemoveT64Label.Right) -Y ($VC.OptionsLabel.Top - (DPISize 2)) -Width (DPISize 20) -Height (DPISize 20) -Checked $True -Info "Remove all textures that the Virtual Console replaced in the ROM`nThese replaced textures are known as T64`nThese replaced textures maybe be censored or to make the game look darker more fitting for the Wii" -Name "VC.RemoveT64"
    $VC.RemoveT64Label.Add_Click({ $VC.RemoveT64.Checked = !$VC.RemoveT64.Checked })

    # Expand Memory
    $VC.ExpandMemoryLabel = CreateLabel    -X ($VC.RemoveT64.Right + (DPISize 10)) -Y ($VC.OptionsLabel.Top) -Width (DPISize 95) -Height (DPISize 15) -Text "Expand Memory:" -Info "Expand the game's memory by 4MB`n`n[!] For some games / patches it can cause the VC emulator to fail to boot"
    $VC.ExpandMemory      = CreateCheckBox -X ($VC.ExpandMemoryLabel.Right) -Y ($VC.OptionsLabel.Top - (DPISize 2)) -Width (DPISize 20) -Height (DPISize 20) -Info "Expand the game's memory by 4MB`n`n[!] For some games / patches it can cause the VC emulator to fail to boot" -Name "VC.ExpandMemory"
    $VC.ExpandMemoryLabel.Add_Click({ $VC.ExpandMemory.Checked = !$VC.ExpandMemory.Checked })

    # Remove Filter
    $VC.RemoveFilterLabel = CreateLabel    -X ($VC.ExpandMemory.Right + (DPISize 10)) -Y ($VC.OptionsLabel.Top) -Width (DPISize 95) -Height (DPISize 15) -Text "Remove Filter:" -Info "Remove the dark overlay filter"
    $VC.RemoveFilter      = CreateCheckBox -X ($VC.RemoveFilterLabel.Right) -Y ($VC.OptionsLabel.Top - (DPISize 2)) -Width (DPISize 20) -Height (DPISize 20) -Checked $True -Info "Remove the dark overlay filter" -Name "VC.RemoveFilter"
    $VC.RemoveFilterLabel.Add_Click({ $VC.RemoveFilter.Checked = !$VC.RemoveFilter.Checked })

    # Remove Filter
    $VC.RemapControlsLabel = CreateLabel    -X ($VC.RemoveFilter.Right + (DPISize 10)) -Y ($VC.OptionsLabel.Top) -Width (DPISize 95) -Height (DPISize 15) -Text "Remap Controls:" -Info "Allow the remapping of controls"
    $VC.RemapControls      = CreateCheckBox -X ($VC.RemapControlsLabel.Right) -Y ($VC.OptionsLabel.Top - (DPISize 2)) -Width (DPISize 20) -Height (DPISize 20) -Checked $True -Info "Allow the remapping of controls" -Name "VC.RemapControls"
    $VC.RemapControlsLabel.Add_Click({ $VC.RemapControls.Checked = !$VC.RemapControls.Checked })
    $VC.RemapControls.Add_CheckStateChanged({ $VC.RemapControlsButton.Enabled = $this.Checked })
    $VC.RemapControlsButton.Enabled = $VC.RemapControls.Checked



    ################
    # Status Panel #
    ################

    $global:StatusPanel = CreatePanel -Width (DPISize 625) -Height (DPISize 30)
    $global:StatusGroup = CreateGroupBox -Width (DPISize 590) -Height (DPISize 30)
    $global:StatusLabel = Createlabel -X (DPISize 8) -Y (DPISize 10) -Width (DPISize 570) -Height (DPISize 15)

}



#==============================================================================================================================================================================================
function InitializeEvents() {
    
    # Current Game
    $CurrentGame.Console.Add_SelectedIndexChanged({
        $Settings["Core"][$this.Name] = $this.SelectedIndex
        if ($this.Text -ne $GameConsole.title) { ChangeGamesList }
    })

    $CurrentGame.Game.Add_SelectedIndexChanged({
        $Settings["Core"][$this.Name] = $this.SelectedIndex
        if ($this.Text -ne $GameType.title -or $GameType.console -like "*All*") {
            ChangeGameMode
            SetVCPanel
            SetMainScreenSize
        }
    })

    $CurrentGame.Rev.Add_SelectedIndexChanged({
        $Settings["Core"][$this.Name] = $this.SelectedIndex
        ChangeGameRev
    })

    # Custom Header
    $CustomHeader.ROMTitle.Add_TextChanged(  { RunCustomTitleSyntax  -Syntax "[^a-z 0-9]" } )
    $CustomHeader.VCTitle.Add_TextChanged(   { RunCustomTitleSyntax  -Syntax "[^a-z 0-9 \: \- \( \) \' \& \. \!]" } )

    $CustomHeader.RomGameID.Add_TextChanged( { RunCustomGameIDSyntax -Syntax "[^A-Z 0-9]" } )
    $CustomHeader.VCGameID.Add_TextChanged(  { RunCustomGameIDSyntax -Syntax "[^A-Z 0-9]" } )

    # Patch Options
    $Patches.Type.Add_SelectedIndexChanged( {
        $Settings["Core"][$this.Name] = $this.SelectedIndex
        ChangePatch
    } )

    $Patches.Options.Add_CheckStateChanged({
        $Patches.OptionsButton.Enabled = $this.checked
        DisableReduxOptions
    })

    $Patches.Redux.Add_CheckStateChanged({
        GetHeader
        DisableReduxOptions
        if (Get-Command "AdjustGUI" -errorAction SilentlyContinue) { iex "AdjustGUI" }

    })

}



#==============================================================================================================================================================================================
function RunCustomTitleSyntax([string]$Syntax) {
    
    if (!$CustomHeader.EnableHeader.Checked -or !$CustomHeader.EnableHeader.Visible) { return }

    if ($this.Text -match $Syntax) {
        $cursorPos = $this.SelectionStart
        $this.Text = $this.Text -replace $Syntax, ''
        $this.SelectionStart = $cursorPos - 1
        $this.SelectionLength = 0
    }

}



#==============================================================================================================================================================================================
function RunCustomGameIDSyntax([string]$Syntax) {
    
    if (!$CustomHeader.EnableHeader.Checked -or !$CustomHeader.EnableHeader.Visible) { return }

    if ($this.Text -cmatch $Syntax) {
        $this.Text = $this.Text.ToUpper() -replace $Syntax,''
        $this.Select($this.Text.Length, $this.Text.Length)
    }
    if ($this.Text -cmatch " ") {
        $this.Text = $this.Text.ToUpper() -replace " ",''
        $this.Select($this.Text.Length, $this.Text.Length)
    }

}



#==============================================================================================================================================================================================
function SetJSONFile($File) {
    
    if (TestFile $File) {
        try { $File = Get-Content -Raw -LiteralPath $File | ConvertFrom-Json }
        catch {
            Write-Host ("Corrupted JSON File: " + $File)
            CreateErrorDialog -Error "Corrupted JSON"
            return
        }
        return $File
    }
    else {
        Write-Host ("Missing JSON File: " + $File)
        CreateErrorDialog "Missing JSON"
        return $null
    }

}



#==============================================================================================================================================================================================
function DisablePatches() {
    
    # Disable boxes if needed
    EnableElem -Elem @($Patches.Extend,    $Patches.ExtendLabel)                          -Active ((IsSet $GamePatch.allow_extend) -and $Settings.Debug.LiteGUI -eq $False -and $GameRev.extend -ne 0) -Hide
    EnableElem -Elem @($Patches.Redux,     $Patches.ReduxLabel)                           -Active ((IsSet $GamePatch.redux.file)   -and $Settings.Debug.LiteGUI -eq $False -and $GameRev.redux  -ne 0) -Hide
    EnableElem -Elem @($Patches.Options,   $Patches.OptionsLabel, $Patches.OptionsButton) -Active ((TestFile $GameFiles.script)    -and ($GamePatch.options -eq 1 -or $Settings.Debug.ForceOptions -ne $False) -and $GameRev.options -ne 0) -Hide
    EnableElem -Elem @($Patches.Downgrade, $Patches.DowngradeLabel)                       -Active ((CheckDowngradable) -and $Settings.Debug.LiteGUI -eq $False) -Hide
    EnableElem -Elem $Patches.OptionsButton                                               -Active $Patches.Options.Checked
    DisableReduxOptions

    # Editor
    EnableElem -Elem $Patches.Editor -Active ($GameType.editor -eq 1 -and $GameRev.editor -ne 0) -Hide
    if ($GameType.editor -eq 1 -and $GameRev.editor -ne 0)   { $Patches.Button.Width = (DPISize 200) }
    else                                                     { $Patches.Button.Width = (DPISize 300) }

}



#=========================================================================================================================================================================================
function CheckDowngradable() {

    foreach ($item in $GameType.version) { if (IsSet $item.file) { return $True } }
    return $False

}


#==============================================================================================================================================================================================
function DisableReduxOptions() {

    if (!(IsSet $Redux.Groups)) { return }
    foreach ($item in $Redux.Groups) {
        if ($item.IsRedux) { EnableElem -Elem $item -Active ($Patches.Options.Checked -and $Patches.Redux.Checked) }
    }

}


#==============================================================================================================================================================================================
function LoadAdditionalOptions(){
    
    # Create options content based on current game
    if (Get-Command "CreateOptions" -errorAction SilentlyContinue) { iex "CreateOptions" }
    [System.GC]::Collect() | Out-Null

}



#==================================================================================================================================================================================================================================================================
function GamePath_Button([object]$TextBox, [string]$Description, [String[]]$FileNames) {
        # Allow the user to select a file
    $SelectedPath = GetFileName -Path $Paths.Base -Description $Description -FileNames $FileNames

    # Make sure the path is not blank and also test that the path exists
    if ($SelectedPath -ne '' -and (TestFile $SelectedPath)) {
        # Finish everything up
        $Settings["Core"][$this.name] = $SelectedPath
        GamePath_Finish -TextBox $TextBox -Path $SelectedPath
    }

}



#==================================================================================================================================================================================================================================================================
function InjectPath_Button([object]$TextBox, [string]$Description, [String[]]$FileNames) {
        # Allow the user to select a file
    $SelectedPath = GetFileName -Path $Paths.Base -Description $Description -FileNames $FileNames

    # Make sure the path is not blank and also test that the path exists
    if ($SelectedPath -ne '' -and (TestFile $SelectedPath)) {
        # Finish everything up
        $Settings["Core"][$this.name] = $SelectedPath
        InjectPath_Finish -TextBox $TextBox -Path $SelectedPath
    }

}




#==================================================================================================================================================================================================================================================================
function PatchPath_Button([object]$TextBox, [string]$Description, [String[]]$FileNames) {
        # Allow the user to select a file
    $SelectedPath = GetFileName -Path $Paths.Base -Description $Description -FileNames $FileNames

    # Make sure the path is not blank and also test that the path exists
    if ($SelectedPath -ne '' -and (TestFile $SelectedPath)) {
        # Finish everything up
        $Settings["Core"][$this.name] = $SelectedPath
        PatchPath_Finish -TextBox $TextBox -Path $SelectedPath
    }

}




#==================================================================================================================================================================================================================================================================
function GamePath_DragDrop() {
    
    # Check for drag and drop data
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        # Get the first item in the list.
        $DroppedPath = [string]($_.Data.GetData([Windows.Forms.DataFormats]::FileDrop))
        
        # See if the dropped item is a file
        if (TestFile $DroppedPath) {
            # Get the extension of the dropped file.
            $DroppedExtn = (Get-Item -LiteralPath $DroppedPath).Extension

            # Make sure it is a ROM or WAD file
            if ($DroppedExtn -eq '.wad' -or $DroppedExtn -eq '.z64' -or $DroppedExtn -eq '.n64' -or $DroppedExtn -eq '.v64' -or $DroppedExtn -eq '.sfc' -or $DroppedExtn -eq '.smc' -or $DroppedExtn -eq '.nes') {
                $Settings["Core"][$this.name] = $DroppedPath
                GamePath_Finish -TextBox $InputPaths.GameTextBox -Path $DroppedPath
            }
        }
    }

}



#==================================================================================================================================================================================================================================================================
function InjectPath_DragDrop() {
    
    # Check for drag and drop data
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        # Get the first item in the list.
        $DroppedPath = [string]($_.Data.GetData([Windows.Forms.DataFormats]::FileDrop))
        
        # See if the dropped item is a file
        if (TestFile $DroppedPath) {
            # Get the extension of the dropped file.
            $DroppedExtn = (Get-Item -LiteralPath $DroppedPath).Extension

            # Make sure it is a ROM
            if ($DroppedExtn -eq '.z64' -or $DroppedExtn -eq '.n64' -or $DroppedExtn -eq '.v64' -or $DroppedExtn -eq '.sfc' -or $DroppedExtn -eq '.smc' -or $DroppedExtn -eq '.nes') {
                $Settings["Core"][$this.name] = $DroppedPath
                InjectPath_Finish -TextBox $InputPaths.InjectTextBox -Path $DroppedPath
            }
        }
    }

}



#==================================================================================================================================================================================================================================================================
function PatchPath_DragDrop() {
    
    # Check for drag and drop data
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        # Get the first item in the list.
        $DroppedPath = [string]($_.Data.GetData([Windows.Forms.DataFormats]::FileDrop))
        
        # See if the dropped item is a file
        if (TestFile $DroppedPath) {
            # Get the extension of the dropped file.
            $DroppedExtn = (Get-Item -LiteralPath $DroppedPath).Extension

            # Make sure it is a patch File
            if ($DroppedExtn -eq '.bps' -or $DroppedExtn -eq '.ips' -or $DroppedExtn -eq '.ups' -or $DroppedExtn -eq '.ppf' -or $DroppedExtn -eq '.xdelta' -or $DroppedExtn -eq '.vcdiff') {
                # Finish everything up.
                $Settings["Core"][$this.name] = $DroppedPath
                PatchPath_Finish -TextBox $InputPaths.PatchTextBox -Path $DroppedPath
            }
        }
    }

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function CreateMainDialog
Export-ModuleMember -Function InitializeEvents
Export-ModuleMember -Function DisablePatches
Export-ModuleMember -Function LoadAdditionalOptions
Export-ModuleMember -Function SetJSONFile
Export-ModuleMember -Function DisableReduxOptions