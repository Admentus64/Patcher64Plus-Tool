function CreateMainDialog() {
    
    # Initialization
    $margin = (DPISize 10)

    # Create the main dialog that is shown to the user.
    $global:MainDialog          = New-Object System.Windows.Forms.Form
    $MainDialog.Text            = $Patcher.Title
    $MainDialog.Size            = DPISize (New-Object System.Drawing.Size(1330,  $Patcher.WindowHeight))
  # $MainDialog.MaximizeBox     = $False
    $MainDialog.AutoScale       = $True
    $MainDialog.AutoScaleMode   = [Windows.Forms.AutoScaleMode]::None
    $MainDialog.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $MainDialog.StartPosition   = "CenterScreen"
    $MainDialog.KeyPreview      = $True
    if ($IsFoolsDay) { $MainDialog.Icon = $Paths.Main + "\JASON\jason-1.ico" } else { $MainDialog.Icon = $Files.icon.main  }
    $MainDialog.Add_Shown({ $MainDialog.Activate() })
    $global:MainPanel           = CreatePanel -Y (DPISize 25) -Width (DPISize 525) -Height ($MainDialog.Height - (DPISize 25)) -AddTo $MainDialog

    # Load json files
    $Files.json.consoles = SetJSONFile $Files.json.consoles
    $Files.json.games    = SetJSONFile $Files.json.games

    # Addons
    ShowAddonsIcons -Type "Patches" -Index 0
    ShowAddonsIcons -Type "Models"  -Index 1
    ShowAddonsIcons -Type "Music"   -Index 2

    # Menu bar
    $menuBarMain           = New-Object System.Windows.Forms.MenuStrip; $MainDialog.Controls.Add($menuBarMain)

    $menuBarFile           = New-Object System.Windows.Forms.ToolStripMenuItem; $menuBarFile.Text           = "File";               $menuBarMain.Items.Add($menuBarFile)
    $menuBarView           = New-Object System.Windows.Forms.ToolStripMenuItem; $menuBarView.Text           = "View";               $menuBarMain.Items.Add($menuBarView)
    $menuBarEdit           = New-Object System.Windows.Forms.ToolStripMenuItem; $menuBarEdit.Text           = "Edit";               $menuBarMain.Items.Add($menuBarEdit)
    $menuBarEditors        = New-Object System.Windows.Forms.ToolStripMenuItem; $menuBarEditors.Text        = "Editors";            $menuBarMain.Items.Add($menuBarEditors)

    $menuBarUpdate         = New-Object System.Windows.Forms.ToolStripButton;   $menuBarUpdate.Text         = "Update Tool";        $menuBarFile.DropDownItems.Add($menuBarUpdate)
    $menuBarUpdateAddons   = New-Object System.Windows.Forms.ToolStripButton;   $menuBarUpdateAddons.Text   = "Update Addons";      $menuBarFile.DropDownItems.Add($menuBarUpdateAddons)
    $menuBarExit           = New-Object System.Windows.Forms.ToolStripButton;   $menuBarExit.Text           = "Exit";               $menuBarFile.DropDownItems.Add($menuBarExit)

    $menuBarSettings       = New-Object System.Windows.Forms.ToolStripButton;   $menuBarSettings.Text       = "Settings";           $menuBarView.DropDownItems.Add($menuBarSettings)
    $menuBarOptions        = New-Object System.Windows.Forms.ToolStripButton;   $menuBarOptions.Text        = "Additional Options"; $menuBarView.DropDownItems.Add($menuBarOptions)
    $menuBarCredits        = New-Object System.Windows.Forms.ToolStripButton;   $menuBarCredits.Text        = "Credits";            $menuBarView.DropDownItems.Add($menuBarCredits)
    $menuBarChangelog      = New-Object System.Windows.Forms.ToolStripButton;   $menuBarChangelog.Text      = "Changelog";          $menuBarView.DropDownItems.Add($menuBarChangelog)
    $menuBarChecksum       = New-Object System.Windows.Forms.ToolStripButton;   $menuBarChecksum.Text       = "Checksum";           $menuBarView.DropDownItems.Add($menuBarChecksum)
    $menuBarInfo           = New-Object System.Windows.Forms.ToolStripButton;   $menuBarInfo.Text           = "Info";               $menuBarView.DropDownItems.Add($menuBarInfo)
    $menuBarLinks          = New-Object System.Windows.Forms.ToolStripButton;   $menuBarLinks.Text          = "Links";              $menuBarView.DropDownItems.Add($menuBarLinks)
    $menuBarGameID         = New-Object System.Windows.Forms.ToolStripButton;   $menuBarGameID.Text         = "GameID";             $menuBarView.DropDownItems.Add($menuBarGameID)

    $menuBarResetAll       = New-Object System.Windows.Forms.ToolStripButton;   $menuBarResetAll.Text       = "Reset All Settings"; $menuBarEdit.DropDownItems.Add($menuBarResetAll)
    $menuBarResetGame      = New-Object System.Windows.Forms.ToolStripButton;   $menuBarResetGame.Text      = "Reset Current Game"; $menuBarEdit.DropDownItems.Add($menuBarResetGame)
    $menuBarCleanupFiles   = New-Object System.Windows.Forms.ToolStripButton;   $menuBarCleanupFiles.Text   = "Cleanup Files";      $menuBarEdit.DropDownItems.Add($menuBarCleanupFiles)
    $menuBarCleanupScripts = New-Object System.Windows.Forms.ToolStripButton;   $menuBarCleanupScripts.Text = "Cleanup Scripts";    $menuBarEdit.DropDownItems.Add($menuBarCleanupScripts)
    
    $menuBarOoTTextEditor  = New-Object System.Windows.Forms.ToolStripButton;   $menuBarOoTTextEditor.Text  = "OoT Text Editor";    $menuBarEditors.DropDownItems.Add($menuBarOoTTextEditor)
    $menuBarMMTextEditor   = New-Object System.Windows.Forms.ToolStripButton;   $menuBarMMTextEditor.Text   = "MM Text Editor";     $menuBarEditors.DropDownItems.Add($menuBarMMTextEditor)
    $menuBarOoTSceneEditor = New-Object System.Windows.Forms.ToolStripButton;   $menuBarOoTSceneEditor.Text = "OoT Scene Editor";   $menuBarEditors.DropDownItems.Add($menuBarOoTSceneEditor)
    $menuBarMMSceneEditor  = New-Object System.Windows.Forms.ToolStripButton;   $menuBarMMSceneEditor.Text  = "MM Scene Editor";    $menuBarEditors.DropDownItems.Add($menuBarMMSceneEditor)

    $menuBarExit.Add_Click(           { $MainDialog.Close()                 } )
    $menuBarUpdate.Add_Click(         { RefreshScripts; AutoUpdate -Manual  } )
    $menuBarUpdateAddons.Add_Click( {
        RefreshScripts
        foreach ($addon in $Files.json.repo.addons) {
            CheckAddon  -Addon $addon
            UpdateAddon -Addon $addon
        }
    } )
    
    $menuBarSettings.Add_Click(       { RefreshScripts; ShowRightPanel $RightPanel.Settings  } )
    $menuBarOptions.Add_Click(        { RefreshScripts; ShowRightPanel $RightPanel.Options   } )
    $menuBarCredits.Add_Click(        { RefreshScripts; ShowRightPanel $RightPanel.Credits   } )
    $menuBarChangelog.Add_Click(      { RefreshScripts; ShowRightPanel $RightPanel.Changelog } )
    $menuBarInfo.Add_Click(           { RefreshScripts; ShowRightPanel $RightPanel.Info      } )
    $menuBarLinks.Add_Click(          { RefreshScripts; ShowRightPanel $RightPanel.Links     } )
    $menuBarGameID.Add_Click(         { RefreshScripts; ShowRightPanel $RightPanel.GameID    } )
    $menuBarChecksum.Add_Click(       { RefreshScripts; ShowRightPanel $RightPanel.Checksum  } )

    $menuBarResetAll.Add_Click(       { RefreshScripts; ResetTool      } )
    $menuBarResetGame.Add_Click(      { RefreshScripts; ResetGame      } )
    $menuBarCleanupFiles.Add_Click(   { RefreshScripts; CleanupFiles   } )
    $menuBarCleanupScripts.Add_Click( { RefreshScripts; CleanupScripts } )

    $menuBarOoTTextEditor.Add_Click(  { RefreshScripts; RunTextEditor  $Files.json.games[0] } )
    $menuBarMMTextEditor.Add_Click(   { RefreshScripts; RunTextEditor  $Files.json.games[1] } )
    $menuBarOoTSceneEditor.Add_Click( { RefreshScripts; RunSceneEditor $Files.json.games[0] } )
    $menuBarMMSceneEditor.Add_Click(  { RefreshScripts; RunSceneEditor $Files.json.games[1] } )



    # Create a label to show current mode
    $global:CurrentModeLabel = @{}
    $CurrentModeLabel.Mode   = CreateLabel -X (DPISize 150)               -Y (DPISize 5)                                 -Width (DPISize 200)                -Height (DPISize 20)                  -Font $Fonts.Medium -AddTo $MainPanel -Text "Current Mode:"
    $CurrentModeLabel.Game   = CreateLabel -X $CurrentModeLabel.Mode.Left -Y ($CurrentModeLabel.Mode.Top + (DPISize 20)) -Width $CurrentModeLabel.Mode.Width -Height $CurrentModeLabel.Mode.Height -Font $Fonts.Medium -AddTo $MainPanel
    $CurrentModeLabel.Mode.TextAlign = $CurrentModeLabel.Game.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

    # Create a label to show current version
    $text = $Patcher.Version
    if (IsSet $Patcher.Hotfix) { $text += " - #" + $Patcher.Hotfix }
    $text += "`n(" + $Patcher.Date + ")"

    $VersionLabel = CreateLabel -X (DPISize 15) -Y (DPISize 0)  -Width (DPISize 150) -Height (DPISize 30) -Text $text                                     -Font $Fonts.SmallBold -AddTo $MainPanel
    $osLabel      = CreateLabel -X (DPISize 15) -Y (DPISize 30) -Width (DPISize 250) -Height (DPISize 20) -Text ($Patcher.OS + " (" + $Patcher.Bit + ")") -Font $Fonts.SmallBold -AddTo $MainPanel
    if (!([Environment]::Is64BitOperatingSystem)) { $osLabel.text += " NOT SUPPORTED"; $osLabel.ForeColor = "red" }

    # Create Arrays for groups
    $global:InputPaths = @{}; $global:Patches = @{}; $global:CurrentGame = @{}; $global:VC = @{}; $global:CustomHeader = @{}



    #############
    # Game Path #
    #############

    # Create the panel that holds the game path
    $InputPaths.GamePanel = CreatePanel -X $margin -Y (DPISize 50) -Width ($MainPanel.Width - $margin) -Height (DPISize 50) -AddTo $MainPanel

    # Create the groupbox that holds the WAD path
    $InputPaths.GameGroup = CreateGroupBox -Width $InputPaths.GamePanel.Width -Height $InputPaths.GamePanel.Height -Text "Game Path"
    $InputPaths.GameGroup.AllowDrop = $True
    $InputPaths.GameGroup.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputPaths.GameGroup.Add_DragDrop({ RefreshScripts; GamePath_DragDrop })

    # Create a textbox to display the selected WAD
    $InputPaths.GameTextBox = CreateTextBox -X (DPISize 10) -Y (DPISize 20) -Width (DPISize 400) -Height (DPISize 22) -Text "Select your ROM or VC WAD file..." -Name "Path.Game" -ReadOnly $True
    $InputPaths.GameTextBox.AllowDrop = $True
    $InputPaths.GameTextBox.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputPaths.GameTextBox.Add_DragDrop({ RefreshScripts; GamePath_DragDrop })

    # Create a button to allow manually selecting a ROM or WAD
    $InputPaths.GameButton = CreateButton -X ($InputPaths.GameTextBox.Right + (DPISize 5)) -Y (DPISize 18) -Width (DPISize 24) -Height (DPISize 22) -Text "..." -Info "Select your ROM or Wii VC WAD using file explorer"
    $InputPaths.GameButton.Add_Click({ RefreshScripts; GamePath_Button -TextBox $InputPaths.GameTextBox -Description "ROM/WAD Files" -FileNames @('*.wad', '*.z64', '*.n64', '*.v64', '*.sfc', '*.smc', '*.nes', '*.gbc', '*.gba', '*.zip', '*.rar', '*.7z') })
    #"Image Files(*.BMP;*.JPG;*.GIF)|*.BMP;*.JPG;*.GIF|All files (*.*)|*.*"

    # Create a button to clear the game Path
    $InputPaths.ClearGameButton = CreateButton -X ($InputPaths.GameButton.Right + (DPISize 5)) -Y (DPISize 18) -Width ($InputPaths.GameGroup.Right - $InputPaths.GameButton.Right - (DPISize 10)) -Height (DPISize 22) -Text "Clear" -Info "Clear the selected paths (ROM / Wii VC WAD), ROM injection and custom patch"
    $InputPaths.ClearGameButton.Add_Click({
        RefreshScripts
        if (IsSet -Elem $GamePath -MinLength 1) {
            if ($IsWiiVC) { SetWiiVCMode $False }
            $global:GamePath                                = $global:InjectPath = $global:PatchPath = $null
            $Settings["Core"][$InputPaths.GameTextBox.name] = $Settings["Core"][$InputPaths.InjectTextBox.name] = $Settings["Core"][$InputPaths.PatchTextBox.name] = $Settings["Paths"][$GameType.mode] = ""
            $InputPaths.GameTextBox.Text                    = "Select your ROM or Wii VC WAD file..."
            $InputPaths.InjectTextBox.Text                  = "Select your ROM for injection..."
            $InputPaths.PatchTextBox.Text                   = "Select your custom patch file..."
            $global:GameIsSelected                          = $Patches.Button.Enabled = $InputPaths.ClearGameButton.Enabled = $InputPaths.ApplyInjectButton.Enabled = $InputPaths.ApplyPatchButton.Enabled = $False
            EnablePatchButtons
        }
    })
    $InputPaths.ClearGameButton.Enabled = $False



    ###############
    # Inject Path #
    ###############

    # Create the panel that holds the inject path
    $InputPaths.InjectPanel = CreatePanel -X $margin -Width ($MainPanel.Width - $margin) -Height (DPISize 50) -AddTo $MainPanel

    # Create the groupbox that holds the ROM path
    $InputPaths.InjectGroup = CreateGroupBox -Width $InputPaths.InjectPanel.Width -Heigh $InputPaths.InjectPanel.Height -Text "Inject ROM Path"
    $InputPaths.InjectGroup.AllowDrop = $True
    $InputPaths.InjectGroup.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputPaths.InjectGroup.Add_DragDrop({ RefreshScripts; InjectPath_DragDrop })

    # Create a textbox to display the selected ROM
    $InputPaths.InjectTextBox = CreateTextBox -X (DPISize 10) -Y (DPISize 20) -Width (DPISize 400) -Height (DPISize 22) -Text "Select your ROM for injection..." -Name "Path.Inject" -ReadOnly $True
    $InputPaths.InjectTextBox.AllowDrop = $True
    $InputPaths.InjectTextBox.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputPaths.InjectTextBox.Add_DragDrop({ RefreshScripts; InjectPath_DragDrop })

    # Create a button to allow manually selecting a ROM
    $InputPaths.InjectButton = CreateButton -X ($InputPaths.InjectTextBox.Right + (DPISize 5)) -Y (DPISize 18) -Width (DPISize 24) -Height (DPISize 22) -Text "..." -Info "Select your N64, SNES or NES ROM File using file explorer"
    $InputPaths.InjectButton.Add_Click({ RefreshScripts; InjectPath_Button -TextBox $InputPaths.InjectTextBox -Description "ROM Files" -FileNames @('*.z64', '*.n64', '*.v64', '*.sfc', '*.smc', '*.nes', '*.gbc', '*.gba', '*.zip', '*.rar', '*.7z') })

    # Create a button to allow patch the WAD with a ROM file
    $InputPaths.ApplyInjectButton = CreateButton -X ($InputPaths.InjectButton.Right + (DPISize 5)) -Y (DPISize 18) -Width ($InputPaths.InjectGroup.Right - $InputPaths.InjectButton.Right - (DPISize 10)) -Height (DPISize 22) -Text "Inject ROM" -Info "Replace the ROM in your selected WAD File with your selected injection file"
    $InputPaths.ApplyInjectButton.Add_Click({ RefreshScripts; MainFunction -Command "Inject" -PatchedFileName "_injected" })
    $InputPaths.ApplyInjectButton.Enabled = $False



    ##############
    # Patch Path #
    ##############
    
    # Create the panel that holds the patch path
    $InputPaths.PatchPanel = CreatePanel -X $margin -Width ($MainPanel.Width - $margin) -Height (DPISize 50) -AddTo $MainPanel
    
    # Create the groupbox that holds the BPS path
    $InputPaths.PatchGroup = CreateGroupBox -Width $InputPaths.PatchPanel.Width -Height $InputPaths.PatchPanel.Height -Text "Custom Patch Path"
    $InputPaths.PatchGroup.AllowDrop = $True
    $InputPaths.PatchGroup.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputPaths.PatchGroup.Add_DragDrop({ RefreshScripts; PatchPath_DragDrop })
    
    # Create a textbox to display the selected BPS
    $InputPaths.PatchTextBox = CreateTextBox -X (DPISize 10) -Y (DPISize 20) -Width (DPISize 400) -Height (DPISize 22) -Text "Select your custom patch file..." -Name "Path.Patch" -ReadOnly $True
    $InputPaths.PatchTextBox.AllowDrop = $True
    $InputPaths.PatchTextBox.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputPaths.PatchTextBox.Add_DragDrop({ RefreshScripts; PatchPath_DragDrop })

    # Create a button to allow manually selecting a ROM
    $InputPaths.PatchButton = CreateButton -X ($InputPaths.PatchTextBox.Right + (DPISize 5)) -Y (DPISize 18) -Width (DPISize 24) -Height (DPISize 22) -Text "..." -Info "Select your BPS, IPS, UPS, PPF, Xdelta or VCDiff Patch File using file explorer"
    $InputPaths.PatchButton.Add_Click({ RefreshScripts; PatchPath_Button -TextBox $InputPaths.PatchTextBox -Description "Patch Files" -FileNames @('*.bps', '*.ips', '*.ups' , '*.ppf' , '*.xdelta', '*.vcdiff') })
    
    # Create a button to allow patch the WAD with a BPS file
    $InputPaths.ApplyPatchButton = CreateButton -X ($InputPaths.PatchButton.Right + (DPISize 5)) -Y (DPISize 18) -Width ($InputPaths.PatchGroup.Right - $InputPaths.PatchButton.Right - (DPISize 10)) -Height (DPISize 22) -Text "Apply Patch" -Info "Patch the ROM with your selected BPS, IPS, UPS, Xdelta or VCDiff Patch File"
    $InputPaths.ApplyPatchButton.Add_Click({ RefreshScripts; MainFunction -Command "Apply Patch" -PatchedFileName "_bps_patched" })
    $InputPaths.ApplyPatchButton.Enabled = $False



    ################
    # Current Game #
    ################

    # Create the panel that holds the current selected game
    $CurrentGame.Panel = CreatePanel -X $margin -Width ($MainPanel.Width - $margin) -Height (DPISize 50) -AddTo $MainPanel

    # Create the groupbox that holds the current game options
    $CurrentGame.Group = CreateGroupBox -Width $CurrentGame.Panel.Width -Height $CurrentGame.Panel.Height -Text "Current Game Mode"

    # Create a combobox with the list of supported consoles
    $CurrentGame.Console = CreateComboBox -X (DPISize 10) -Y (DPISize 20) -Width (DPISize 170) -Height (DPISize 30) -Name "Selected.Console"
    
    # Create a combobox with the list of supported games
    $CurrentGame.Game = CreateComboBox -X ($CurrentGame.Console.Right + (DPISize 5)) -Y (DPISize 20) -Width (DPISize 240) -Height (DPISize 30) -Name "Selected.Game"

    # Create a combobox with the list of supported games
    $CurrentGame.Rev = CreateLabel -X ($CurrentGame.Game.Right + (DPISize 5)) -Y (DPISize 8) -Width (DPISize 75) -Height (DPISize 40) -Font $Fonts.SmallBold
    $CurrentGame.Rev.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft

    $global:PatchToolTip = CreateToolTip



    #################
    # Custom Header #
    #################

    # Create the panel that holds the Custom Header
    $CustomHeader.Panel = CreatePanel -X $margin -Width ($MainPanel.Width - $margin) -Height (DPISize 80) -AddTo $MainPanel

    # Create the groupbox that holds the Custom Header
    $CustomHeader.Group = CreateGroupBox -Width $CustomHeader.Panel.Width -Height $CustomHeader.Panel.Height -Text "Custom Game Title and GameID"

    # Custom Title Checkbox
    $CustomHeader.EnableHeaderLabel = CreateLabel    -X (DPISize 10)                          -Y (DPISize 22) -Width (DPISize 45) -Height (DPISize 15) -Text "Enable:"                   -Info "Enable in order to change the Game ID and title of the ROM or WAD file"
    $CustomHeader.EnableHeader      = CreateCheckBox -X $CustomHeader.EnableHeaderLabel.Right -Y (DPISize 20) -Width (DPISize 20) -Height (DPISize 20) -Name "CustomHeader.EnableHeader" -Info "Enable in order to change the Game ID and title of the ROM or WAD file"
    $CustomHeader.EnableHeaderLabel.Add_Click({ $CustomHeader.EnableHeader.Checked = !$CustomHeader.EnableHeader.Checked })

    # Custom ROM Title
    $CustomHeader.ROMTitleLabel = CreateLabel   -X $CustomHeader.EnableHeader.Right  -Y (DPISize 22) -Width (DPISize 70)  -Height (DPISize 15) -Text "ROM Title:" -Info "--- WARNING ---`nChanging the Game Title might causes issues with emulation for certain emulators and plugins, such as GlideN64"
    $CustomHeader.ROMTitle      = CreateTextBox -X $CustomHeader.ROMTitleLabel.Right -Y (DPISize 20) -Width (DPISize 250) -Height (DPISize 22) -Length 20         -Info "--- WARNING ---`nChanging the Game Title might causes issues with emulation for certain emulators and plugins, such as GlideN64"

    # Custom ROM GameID (N64 only)
    $CustomHeader.ROMGameIDLabel = CreateLabel   -X ($CustomHeader.ROMTitle.Right + (DPISize 5)) -Y (DPISize 22) -Width (DPISize 50) -Height (DPISize 15) -Text "GameID:" -Info "--- WARNING ---`nRequires four characters for acceptance`nThe fourth character sets the region and refresh rate`nChanging the GameID causes Nintendo 64 emulators to recognize the N64 title as a separate save file and texture pack`n`n--- REGION CODES ---`nE = USA`nJ = Japan`nP = PAL`nK = Korea"
    $CustomHeader.ROMGameID      = CreateTextBox -X $CustomHeader.ROMGameIDLabel.Right           -Y (DPISize 20) -Width (DPISize 55) -Height (DPISize 22) -Length 4       -Info "--- WARNING ---`nRequires four characters for acceptance`nThe fourth character sets the region and refresh rate`nChanging the GameID causes Nintendo 64 emulators to recognize the N64 title as a separate save file and texture pack`n`n--- REGION CODES ---`nE = USA`nJ = Japan`nP = PAL`nK = Korea"
    
    # Custom VC Title 
    $CustomHeader.VCTitleLabel = CreateLabel   -X $CustomHeader.EnableHeader.Right -Y (DPISize 22) -Width (DPISize 70)  -Height (DPISize 15) -Text "Channel Title:"
    $CustomHeader.VCTitle      = CreateTextBox -X $CustomHeader.VCTitleLabel.Right -Y (DPISize 20) -Width (DPISize 250) -Height (DPISize 22) -Length $VCTitleLength

    # Custom VC GameID (N64 only)
    $CustomHeader.VCGameIDLabel = CreateLabel   -X ($CustomHeader.VCTitle.Right + (DPISize 5)) -Y (DPISize 22) -Width (DPISize 50) -Height (DPISize 15) -Text "GameID:" -Info "--- WARNING ---`nRequires four characters for acceptance`nChanging the GameID causes Dolphin to recognize the VC title as a separate save file and texture pack`n`n--- REGION CODES ---`nE = USA`nJ = Japan`nP = PAL`nK = Korea"
    $CustomHeader.VCGameID      = CreateTextBox -X  $CustomHeader.VCGameIDLabel.Right          -Y (DPISize 20) -Width (DPISize 55) -Height (DPISize 22) -Length 4       -Info "--- WARNING ---`nRequires four characters for acceptance`nChanging the GameID causes Dolphin to recognize the VC title as a separate save file and texture pack`n`n--- REGION CODES ---`nE = USA`nJ = Japan`nP = PAL`nK = Korea"

    # Custom Region Checkbox (SNES Only)
    $CustomHeader.EnableRegionLabel = CreateLabel    -X $CustomHeader.EnableHeaderLabel.Left -Y (DPISize 52) -Width (DPISize 45) -Height (DPISize 15) -Text "Enable:"                   -Info "Enable in order to change the Game ID and title of the ROM or WAD file"
    $CustomHeader.EnableRegion      = CreateCheckBox -X $CustomHeader.EnableHeader.Left      -Y (DPISize 50) -Width (DPISize 20) -Height (DPISize 20) -Name "CustomHeader.EnableRegion" -Info "Enable in order to change the Game ID and title of the ROM or WAD file"
    $CustomHeader.EnableRegionLabel.Add_Click({ $CustomHeader.EnableRegion.Checked = !$CustomHeader.EnableRegion.Checked })

    # Custom Region (SNES only)
    $CustomHeader.RegionLabel = CreateLabel -X ($CustomHeader.ROMTitleLabel.Left) -Y (DPISize 50) -Width (DPISize 55) -Height (DPISize 15) -Text "Region:" -Info "--- WARNING ---`nChanging the Region Code can softlock the game"
    $Items = @("Japan (NTSC)", "North America (NTSC)", "Europe (PAL)", "Sweden/Scandinavia (PAL)", "Finland (PAL)", "Denmark (PAL)", "France (SECAM)", "Netherlands (PAL)", "Spain (PAL)", "Germany (PAL)", "Italy (PAL)", "China (PAL)", "Indonesia (PAL)", "Kora (NTSC)", "Global", "Canada (NTSC)", "Brazil (PAL-M)", "Australia (PAL)", "Other (1)", "Other (2)", "Other (3)")
    $CustomHeader.Region = CreateComboBox   -X $CustomHeader.ROMTitle.Left -Y ($CustomHeader.RegionLabel.Top) -Width $CustomHeader.ROMTitle.Width -Height $CustomHeader.ROMTitle.Height -Items $Items -Default 2



    ###############
    # Patch Panel #
    ###############

    # Create a panel to contain everything for patches
    $Patches.Panel = CreatePanel -X $margin -Width ($MainPanel.Width - $margin) -Height (DPISize 90) -AddTo $MainPanel

    # Create a groupbox to show the patching buttons
    $Patches.Group = CreateGroupBox -Width $Patches.Panel.Width -Height $Patches.Panel.Height

    # Create patch button
    $Patches.Button         = CreateButton -X (DPISize 10) -Y (DPISize 45) -Width (DPISize 300) -Height (DPISize 35) -Text "Patch Selected Options"
    $Patches.Button.Font    = $Fonts.SmallBold
    $Patches.Button.Enabled = $False
    $Patches.Button.Add_Click({ RefreshScripts; MainFunction -Command $GamePatch.command -PatchedFileName $GamePatch.output })

    # Create Patches ComboBox
    $Patches.Type        = CreateComboBox -X $Patches.Button.Left -Y ($Patches.Button.Top - (DPISize 25) ) -Width ($Patches.Button.Right - (DPISize 10)) -Height (DPISize 30) -Name "Selected.Patch"
    $global:PatchToolTip = CreateToolTip

    # Additional Options Checkbox
    $Patches.OptionsLabel = CreateLabel    -X ($Patches.Button.Right + (DPISize 10)) -Y ($Patches.Type.Top         + (DPISize 5) ) -Width (DPISize 85) -Height (DPISize 15) -Text "Enable Options:" -Info "Enable options in order to apply a customizable set of features and changes" 
    $Patches.Options      = CreateCheckBox -X ($Patches.OptionsLabel.Right)          -Y ($Patches.OptionsLabel.Top - (DPISize 2) ) -Width (DPISize 20) -Height (DPISize 20)                         -Info "Enable options in order to apply a customizable set of features and changes" -Name "Patches.Options" -Checked $True
    $Patches.OptionsLabel.Add_Click({ $Patches.Options.Checked = !$Patches.Options.Checked })

    # Extend Checkbox
    $Patches.ExtendLabel = CreateLabel    -X ($Patches.Button.Right + (DPISize 10)) -Y ($Patches.OptionsLabel.Bottom + (DPISize 15) ) -Width (DPISize 85) -Height (DPISize 15) -Text "Allow Extend:" -Info "Allows extending the ROM beyond it's regular size`nSome patches will automaticially force an extend of the ROM"
    $Patches.Extend      = CreateCheckBox -X ($Patches.ExtendLabel.Right)           -Y ($Patches.ExtendLabel.Top     - (DPISize 2)  ) -Width (DPISize 20) -Height (DPISize 20)                       -Info "Allows extending the ROM beyond it's regular size`nSome patches will automaticially force an extend of the ROM" -Name "Patches.Extend"
    $Patches.ExtendLabel.Add_Click({ $Patches.Extend.Checked = !$Patches.Extend.Checked })

    # Redux Checkbox
    $Patches.ReduxLabel = CreateLabel    -X ($Patches.Button.Right + (DPISize 10)) -Y ($Patches.OptionsLabel.Bottom + (DPISize 15) ) -Width (DPISize 85) -Height (DPISize 15) -Text "Enable Redux:"
    $Patches.Redux      = CreateCheckBox -X ($Patches.ReduxLabel.Right)            -Y ($Patches.ReduxLabel.Top      - (DPISize 2)  ) -Width (DPISize 20) -Height (DPISize 20) -Name "Patches.Redux" -Checked $True
    $Patches.ReduxLabel.Add_Click({ $Patches.Redux.Checked = !$Patches.Redux.Checked })
    
    $global:ReduxToolTip = CreateToolTip


    ####################
    # Patch VC Options #
    ####################

    # Create a panel to show the patch options.
    $VC.Panel         = CreatePanel -X $margin -Width ($MainPanel.Width - $margin) -Height (DPISize 105) -AddTo $MainPanel
    $VC.Panel.Visible = $False

    # Create a groupbox to show the patch options.
    $VC.Group = CreateGroupBox -Width $VC.Panel.Width -Height $VC.Panel.Height -Text "Virtual Console - Patch Options"

    # Create a label for Patch VC Buttons
    $VC.ActionsLabel = CreateLabel -X (DPISize 10) -Y (DPISize 32) -Width (DPISize 55) -Height (DPISize 15) -Text "Actions:" -Font $Fonts.SmallBold -AddTo $VC.Group

    # Create a button to extract the ROM
    $VC.ExtractROMButton = CreateButton -X ($VC.ActionsLabel.Right + (DPISize 5)) -Y ($VC.ActionsLabel.Top - (DPISize 7)) -Width (DPISize 150) -Height (DPISize 30) -Text "Extract ROM Only" -Info "Only extract the ROM from the WAD file`nUseful for native N64 emulators"
    $VC.ExtractROMButton.Add_Click({ RefreshScripts; MainFunction -Command "Extract" -PatchedFileName "_extracted" })

    # Create a button to show the global settings panel
    $VC.RemapControlsButton = CreateButton -X ($VC.ExtractROMButton.Right + (DPISize 10)) -Y ($VC.ActionsLabel.Top - (DPISize 7)) -Width (DPISize 150) -Height (DPISize 30) -Text "Remap VC Controls" -Info "Open the Virtual Console remap settings panel"
    $VC.RemapControlsButton.Add_Click({ ShowRightPanel $RightPanel.RemapControls })

    # Create a label for Core patches
    $VC.OptionsLabel = CreateLabel -X (DPISize 10) -Y (DPISize 62) -Width (DPISize 55) -Height (DPISize 15) -Text "Options:" -Font $Fonts.SmallBold

    # Remove T64
    $VC.RemoveT64Label = CreateLabel    -X ($VC.OptionsLabel.Right   + (DPISize 5)) -Y  $VC.OptionsLabel.Top -Text "Remove All T64:" -Info "Remove all textures that the Virtual Console replaced in the ROM`nThese replaced textures are known as T64`nThese replaced textures maybe be censored or to make the game look darker more fitting for the Wii"
    $VC.RemoveT64      = CreateCheckBox -X ($VC.RemoveT64Label.Right + (DPISize 5)) -Y ($VC.OptionsLabel.Top - (DPISize 1)) -Width (DPISize 20) -Height (DPISize 20) -Checked $True -Info "Remove all textures that the Virtual Console replaced in the ROM`nThese replaced textures are known as T64`nThese replaced textures maybe be censored or to make the game look darker more fitting for the Wii" -Name "VC.RemoveT64"
    $VC.RemoveT64Label.Add_Click({ $VC.RemoveT64.Checked = !$VC.RemoveT64.Checked })

    # Expand Memory
    $VC.ExpandMemoryLabel = CreateLabel    -X ($VC.RemoveT64.Right         + (DPISize 5)) -Y  $VC.OptionsLabel.Top -Text "Expand Memory:" -Info "Expand the game's memory by 4MB`n`n[!] For some games / patches it can cause the VC emulator to fail to boot"
    $VC.ExpandMemory      = CreateCheckBox -X ($VC.ExpandMemoryLabel.Right + (DPISize 5)) -Y ($VC.OptionsLabel.Top - (DPISize 1)) -Width (DPISize 20) -Height (DPISize 20) -Info "Expand the game's memory by 4MB`n`n[!] For some games / patches it can cause the VC emulator to fail to boot" -Name "VC.ExpandMemory"
    $VC.ExpandMemoryLabel.Add_Click({ $VC.ExpandMemory.Checked = !$VC.ExpandMemory.Checked })

    # Remove Filter
    $VC.RemoveFilterLabel = CreateLabel    -X ($VC.ExpandMemory.Right      + (DPISize 5)) -Y  $VC.OptionsLabel.Top -Text "Remove Filter:" -Info "Remove the dark overlay filter"
    $VC.RemoveFilter      = CreateCheckBox -X ($VC.RemoveFilterLabel.Right + (DPISize 5)) -Y ($VC.OptionsLabel.Top - (DPISize 1)) -Width (DPISize 20) -Height (DPISize 20) -Checked $True -Info "Remove the dark overlay filter" -Name "VC.RemoveFilter"
    $VC.RemoveFilterLabel.Add_Click({ $VC.RemoveFilter.Checked = !$VC.RemoveFilter.Checked })

    # Remove Filter
    $VC.RemapControlsLabel = CreateLabel    -X ($VC.RemoveFilter.Right       + (DPISize 5)) -Y  $VC.OptionsLabel.Top -Text "Remap Controls:" -Info "Allow the remapping of controls"
    $VC.RemapControls      = CreateCheckBox -X ($VC.RemapControlsLabel.Right + (DPISize 5)) -Y ($VC.OptionsLabel.Top - (DPISize 1)) -Width (DPISize 20) -Height (DPISize 20) -Checked $True -Info "Allow the remapping of controls" -Name "VC.RemapControls"
    $VC.RemapControlsLabel.Add_Click({ $VC.RemapControls.Checked = !$VC.RemapControls.Checked })
    $VC.RemapControls.Add_CheckStateChanged({ $VC.RemapControlsButton.Enabled = $this.Checked })
    $VC.RemapControlsButton.Enabled = $VC.RemapControls.Checked



    ################
    # Status Panel #
    ################

    $global:StatusPanel = CreatePanel -X $margin                     -Width ($MainPanel.Width - $margin)         -Height (DPISize 30) -AddTo $MainPanel
    $global:StatusGroup = CreateGroupBox                             -Width  $StatusPanel.Width                  -Height (DPISize 30)
    $global:StatusLabel = CreateLabel -X (DPISize 8) -Y (DPISize 10) -Width ($StatusGroup.Width - (DPISize 20) ) -Height (DPISize 15)



    ##############################
    # Preview / Wii Mode Buttons #
    ##############################

    $Patches.WiiButton = CreateForm -X ($MainPanel.Right - (DPISize 55) ) -Y (DPISize 22) -Width (DPISize 50) -Height (DPISize 28) -Form (New-Object Windows.Forms.PictureBox) -AddTo $MainPanel 
    SetBitmap -Path $Files.icon.WiiDisabled -Box $Patches.WiiButton

    $Patches.PreviewButton = CreateButton -X ($Patches.WiiButton.Left - (DPISize 30)) -Y $Patches.WiiButton.Top -Width (DPISize 28) -Height (DPISize 28) -AddTo $MainPanel
    SetBitmap -Path $Files.icon.PreviewButton -Box $Patches.PreviewButton
    $Patches.PreviewButton.Add_Click( { ToggleDialog -Dialog $OptionsPreviews.Dialog -Panel $OptionsPreviews.Panel })

 

    ####################
    # Main Right Panel #
    ####################

    $global:RightPanel        = @{}
    $RightPanel.Settings      = CreateRightPanel
    $RightPanel.Options       = CreateRightPanel
    $RightPanel.Credits       = CreateRightPanel
    $RightPanel.Changelog     = CreateRightPanel
    $RightPanel.Checksum      = CreateRightPanel
    $RightPanel.Info          = CreateRightPanel
    $RightPanel.GameID        = CreateRightPanel
    $RightPanel.Links         = CreateRightPanel
    $RightPanel.RemapControls = CreateRightPanel
    ShowRightPanel $RightPanel.Options

}



#==============================================================================================================================================================================================
function CreateRightPanel() { return CreatePanel -X $MainPanel.Right -Y (DPISize 20) -Width ($FormDistance * 4 + (DPISize 50)) -Height ($MainDialog.Height - (DPISize 20)) -AddTo $MainDialog }



#==============================================================================================================================================================================================
function ShowRightPanel([System.Windows.Forms.Panel]$Panel) {
    
    $RightPanel.getEnumerator() | foreach { $_.value.Visible = $False }
    $Panel.Visible = $True

}



#==============================================================================================================================================================================================
function ShowAddonsIcons([string]$Type, [byte]$Index) {

    $addonTitles = $Files.json.repo.addons | Where-Object { $_.type -eq $Type }
    if ($addonTitles.count -eq 0) { return }

    $tooltip = CreateToolTip
    $text    = $icon = ""

    foreach ($addon in $Files.json.repo.addons | Where-Object { $_.type -eq $Type }) {
        $title = $addon.type + "-" + $addon.title

        if (!(TestFile ($Paths.Addons + "\" + $Type + "\" + $addon.title) -Container)) {
            $icon  = "_missing"
            if ($text -ne "") { $text += "{0}" }
            $text += "`Addon: " + $addon.title + " is missing"
        }

        elseif ($Addons[$title].isUpdated) {
            $icon  = "_updated"
            if ($text -ne "") { $text += "{0}" }
            $text += "Updated version for " + $addon.title +": " + $Addons[$title].date
            if (IsSet $Addon.hotfix) { $text += ", #" + $Addons[$title].hotfix }
        }

        else {
            if ($text -ne "") { $text += "{0}" }
            $text += "Current version for " + $Addon.title + ": " + $Addons[$title].date
            if (IsSet $Addon.hotfix) { $text += ", #" + $Addons[$title].hotfix }
        }
    }

    $box = CreateForm -X ($MainPanel.Width - (DPISize 25) - (DPISize 30) * $Index) -Width (DPISize 20) -Height (DPISize 20) -Form (New-Object Windows.Forms.PictureBox) -AddTo $MainPanel 
    SetBitmap -Path ($Paths.AddonIcons + "\" + $Type + $icon + ".png") -Box $box
    $tooltip.SetToolTip($box, ([string]::Format($text, [Environment]::NewLine)))

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
        if ($this.Text -ne $GameType.title) {
            ChangeGameMode
            SetVCContent
            SetMainScreenSize
        }
    })

    # Custom Header
    $CustomHeader.ROMTitle.Add_TextChanged(  { RunCustomTitleSyntax  -Syntax "[^a-z 0-9]" } )
    $CustomHeader.VCTitle.Add_TextChanged(   { RunCustomTitleSyntax  -Syntax "[^a-z 0-9 \: \- \( \) \' \& \. \!]" } )

    $CustomHeader.RomGameID.Add_TextChanged( { RunCustomGameIDSyntax -Syntax "[^A-Z 0-9]" } )
    $CustomHeader.VCGameID.Add_TextChanged(  { RunCustomGameIDSyntax -Syntax "[^A-Z 0-9]" } )

    # Patch Options
    $Patches.Type.Add_SelectedIndexChanged( {
        if ($this.Text -ne $GamePatch.title) {
            $Settings["Core"][$this.Name] = $this.SelectedIndex
            ChangePatch
        }
    } )

    DisableReduxOptions
    $Patches.Options.Add_CheckStateChanged({ DisableReduxOptions })

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
function SetJSONFile($File, [switch]$Safe) {
    
    if (TestFile $File) {
        try {
            $reader  = New-Object System.IO.StreamReader($File)
            $content = $reader.ReadToEnd() | ConvertFrom-Json
            $reader.Close()
            $reader.Dispose()
        }
        catch {
            Write-Host ("Corrupted JSON File: " + $File)
            if (!$Safe) {
                CreateErrorDialog -Error "Corrupted JSON"
                return $null
            }
        }
        return $content
    }
    else {
        Write-Host ("Missing JSON File: " + $File)
        if (!$Safe) {
            CreateErrorDialog "Missing JSON"
            return $null
        }
    }

}



#=========================================================================================================================================================================================
function CheckDowngradable() {

    foreach ($item in $GameType.revision) { if (IsSet $item.file) { return $True } }
    return $False

}



#==============================================================================================================================================================================================
function DisableReduxOptions() {
    
    if ($Redux.WindowPanel -ne $null) { $Redux.WindowPanel.Enabled = $Patches.Options.Checked }
    if ($Redux.Panels.Count -gt 0) {
        foreach ($panel in $Redux.Panels) {
            if ($panel.Name -eq "Redux")   { EnableElem -Elem $panel -Active $Patches.Redux.Checked }
        }
    }

}



#==================================================================================================================================================================================================================================================================
function GamePath_Button([object]$TextBox, [string]$Description, [String[]]$FileNames) {
    
    if (TestFile $Settings["Core"].LastGamePathFolder) { $lastFolder = $Settings["Core"].LastGamePathFolder } else { $lastFolder = $Paths.Base }
    $path = GetFileName -Path $lastFolder -Description $Description -FileNames $FileNames # Allow the user to select a file
    if ($path -is [system.Array] -and $path.count -eq 2) { $path = $path[1] }
    if (TestFile $path) {                                                                 # Make sure the path is not blank and also test that the path exists
        $Settings["Core"][$this.name] = $Settings["Core"].LastGamePathFolder = $path
        GamePath_Finish -TextBox $TextBox -Path $path                                     # Finish everything up
    }

}



#==================================================================================================================================================================================================================================================================
function InjectPath_Button([object]$TextBox, [string]$Description, [String[]]$FileNames) {
    
    if (TestFile $Settings["Core"].LastInjectPathFolder) { $lastFolder = $Settings["Core"].LastInjectPathFolder } else { $lastFolder = $Paths.Base }
    $path = GetFileName -Path $lastFolder -Description $Description -FileNames $FileNames # Allow the user to select a file
    if ($path -is [system.Array] -and $path.count -eq 2) { $path = $path[1] }
    if (TestFile $path) {                                                                 # Make sure the path is not blank and also test that the path exists
        $Settings["Core"][$this.name] = $Settings["Core"].LastInjectPathFolder = $path
        InjectPath_Finish -TextBox $TextBox -Path $path                                   # Finish everything up
    }

}




#==================================================================================================================================================================================================================================================================
function PatchPath_Button([object]$TextBox, [string]$Description, [String[]]$FileNames) {
    
    if (TestFile $Settings["Core"].LastPatchPathFolder) { $lastFolder = $Settings["Core"].LastPatchPathFolder } else { $lastFolder = $Paths.Base }
    $path = GetFileName -Path $lastFolder -Description $Description -FileNames $FileNames # Allow the user to select a file
    if ($path -is [system.Array] -and $path.count -eq 2) { $path = $path[1] }
    if (TestFile $path) {                                                                 # Make sure the path is not blank and also test that the path exists
        $Settings["Core"][$this.name] = $Settings["Core"].LastPatchPathFolder = $path
        PatchPath_Finish -TextBox $TextBox -Path $path                                    # Finish everything up
    }

}



#==============================================================================================================================================================================================
function GetFileName([string]$Path, [string]$Description, [string[]]$FileNames) {
    
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.InitialDirectory = $Path
    
    $filter = $Description + "|"
    foreach ($i in 0..($FileNames.Count-1)) {
        $filter += $FileNames[$i] + ';'
    }
    $filter += "|All Files|(*.*)"

    $openFileDialog.Filter = $filter.TrimEnd('|')
    $openFileDialog.ShowDialog()
    
    return $openFileDialog.FileName

}




#==================================================================================================================================================================================================================================================================
function GamePath_DragDrop() {
    
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) { # Check for drag and drop data
        $path = [string]($_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)) # Get the first item in the list
        if (TestFile $path) { # See if the dropped item is a file
            $ext = (Get-Item -LiteralPath $path).Extension # Get the extension of the dropped file
            if ($ext -eq ".wad" -or (IsROMFile $ext) -or (IsZipFile $ext) ) { # Make sure it is a ROM or WAD file
                $Settings["Core"][$this.name] = $path
                GamePath_Finish -TextBox $InputPaths.GameTextBox -Path $path # Finish everything up
            }
        }
    }

}



#==================================================================================================================================================================================================================================================================
function InjectPath_DragDrop() {
    
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) { # Check for drag and drop data
        $path = [string]($_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)) # Get the first item in the list
        if (TestFile $path) { # See if the dropped item is a file
            $ext = (Get-Item -LiteralPath $path).Extension # Get the extension of the dropped file
            if ( (IsROMFile $ext) -or (IsZipFile $ext) ) { # Make sure it is a ROM
                $Settings["Core"][$this.name] = $path
                InjectPath_Finish -TextBox $InputPaths.InjectTextBox -Path $path # Finish everything up
            }
        }
    }

}



#==================================================================================================================================================================================================================================================================
function PatchPath_DragDrop() {
    
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) { # Check for drag and drop data
        $path = [string]($_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)) # Get the first item in the list
        if (TestFile $path) { # See if the dropped item is a file
            $ext = (Get-Item -LiteralPath $path).Extension # Get the extension of the dropped file
            if (IsPatchFile $ext) { # Make sure it is a patch File
                $Settings["Core"][$this.name] = $path
                PatchPath_Finish -TextBox $InputPaths.PatchTextBox -Path $path # Finish everything up
            }
        }
    }

}



#==============================================================================================================================================================================================
function CleanupFiles() {
    
    foreach ($item in $Files.json.games) {
        RemovePath ($Paths.Games + "\" + $item.mode + "\Extracted")
    }

    RemovePath $Paths.cygdrive
    RemovePath $Paths.Temp
    RemovePath $Paths.Cache
    RemoveFile $Files.flipscfg
    RemoveFile $Files.stackdump

    WriteToConsole "All extracted files have been deleted"
    [System.GC]::Collect()

}



#==============================================================================================================================================================================================
function CleanupScripts() {
    
    foreach ($item in $Files.json.games) {
        RemovePath ($Paths.Games + "\" + $item.mode + "\Editor")
    }

    WriteToConsole "All extracted scripts have been deleted"
    [System.GC]::Collect()

}



#==============================================================================================================================================================================================
function ResetTool() {
    
    $InputPaths.GameTextBox.Text   = "Select or drag and drop your ROM or VC WAD file..."
    $InputPaths.InjectTextBox.Text = "Select or drag and drop your NES, SNES or N64 ROM..."
    $InputPaths.PatchTextBox.Text  = "Select or drag and drop your BPS, IPS, Xdelta or VCDiff Patch File..."
    
    foreach ($item in $GeneralSettings) {
        if ($item.GetType() -eq [System.Windows.Forms.CheckBox]) { $item.Checked = $item.Default }
    }

    foreach ($item in $VC.GetEnumerator) {
        if ($item.GetType() -eq [System.Windows.Forms.CheckBox]) { $item.Checked = $item.Default }
    }

    $global:GameIsSelected = $global:GamePath = $global:InjectPath = $global:PatchPath = $null

    $Patches.Redux.Checked             = $Patches.Redux.Default
    $Patches.Options.Checked           = $Patches.Options.Default
    $CustomHeader.EnableHeader.Checked = $CustomHeader.EnableHeader.Default
    $CustomHeader.EnableRegion.Checked = $CustomHeader.EnableRegion.Default
    
    $CurrentGame.Console.SelectedIndex    = $CurrentGame.Console.Default
    $CurrentGame.Game.SelectedIndex       = $CurrentGame.Game.Default
    $Patches.Type.SelectedIndex           = $Patches.Type.Default
    $InputPaths.ApplyInjectButton.Enabled = $InputPaths.ApplyPatchButton.Enabled = $False

    RemoveFile $Paths.Settings
    $global:GameSettingsFile = GetGameSettingsFile
    $global:Settings         = @{}
    $global:GameSettings     = @{}
    $Settings.Core           = @{}
    $Settings.Dungeon        = @{}
    $Settings.Debug          = @{}
    
    SetWiiVCMode $False
    RestoreCustomHeader
    ChangeGameMode
    SetMainScreenSize
    ChangePatch
    EnablePatchButtons

    $Settings.Core.WiiMode = $global:WiiMode = $global:GameIsSelected = $False
    [System.GC]::Collect()

    OutIniFile -FilePath $Files.settings -InputObject $Settings
    if (IsSet $GameSettings) { OutIniFile -FilePath (GetGameSettingsFile) -InputObject $GameSettings }

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
        }
    }

    WriteToConsole "Current selected game options have been reset"
    [System.GC]::Collect()

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function CreateMainDialog
Export-ModuleMember -Function ShowRightPanel
Export-ModuleMember -Function InitializeEvents
Export-ModuleMember -Function SetJSONFile
Export-ModuleMember -Function DisableReduxOptions
Export-ModuleMember -Function ResetGame