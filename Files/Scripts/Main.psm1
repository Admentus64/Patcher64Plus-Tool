function CreateMainDialog() {

    # Create the main dialog that is shown to the user.
    $global:MainDialog = New-Object System.Windows.Forms.Form
    $MainDialog.Text = $ScriptName
    $MainDialog.Size = DPISize (New-Object System.Drawing.Size(625, 745))
    $MainDialog.MaximizeBox = $false
    $MainDialog.AutoScale = $True
    $MainDialog.AutoScaleMode = [Windows.Forms.AutoScaleMode]::None
    $MainDialog.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $MainDialog.StartPosition = "CenterScreen"
    $MainDialog.KeyPreview = $True
    $MainDialog.Add_Shown({ $MainDialog.Activate() })
    $MainDialog.Icon = $Files.icon.main

    # Create a label to show current mode.
    $global:CurrentModeLabel = CreateLabel -Font $Fonts.Medium -AddTo $MainDialog
    $CurrentModeLabel.AutoSize = $True

    # Create a label to show current version.
    $VersionLabel = CreateLabel -X (DPISize 15) -Y (DPISize 10) -Width (DPISize 120) -Height (DPISize 30) -Text ($Version + "`n(" + $VersionDate + ")") -Font $Fonts.SmallBold -AddTo $MainDialog

    # Create Arrays for groups
    $global:InputPaths = @{}; $global:Patches = @{}; $global:VC = @{}



    #############
    # Game Path #
    #############

    # Create the panel that holds the game path
    $InputPaths.GamePanel = CreatePanel -Width (DPISize 590) -Height (DPISize 50)

    # Create the groupbox that holds the WAD path
    $InputPaths.GameGroup = CreateGroupBox -Width $InputPaths.GamePanel.Width -Height $InputPaths.GamePanel.Height -Text "Game Path"
    $InputPaths.GameGroup.AllowDrop = $True
    $InputPaths.GameGroup.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputPaths.GameGroup.Add_DragDrop({ GamePath_DragDrop })

    # Create a textbox to display the selected WAD
    $InputPaths.GameTextBox = CreateTextBox -X (DPISize 10) -Y (DPISize 20) -Width (DPISize 420) -Height (DPISize 22) -Text "Select or drag and drop your ROM or VC WAD file..." -Name "Path.Game" -ReadOnly $True
    $InputPaths.GameTextBox.AllowDrop = $True
    $InputPaths.GameTextBox.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputPaths.GameTextBox.Add_DragDrop({ GamePath_DragDrop })

    # Create a button to allow manually selecting a ROM or WAD
    $InputPaths.GameButton = CreateButton -X ($InputPaths.GameTextBox.Right + (DPISize 6)) -Y (DPISize 18) -Width (DPISize 24) -Height (DPISize 22) -Text "..." -Info "Select your ROM or VC WAD using file explorer"
    $InputPaths.GameButton.Add_Click({ GamePath_Button -TextBox $InputPaths.GameTextBox -Description "ROM/WAD Files" -FileNames @('*.wad', '*.z64', '*.n64', '*.v64', '*.sfc', '*.smc', '*.nes') })
    #"Image Files(*.BMP;*.JPG;*.GIF)|*.BMP;*.JPG;*.GIF|All files (*.*)|*.*"

    # Create a button to clear the WAD Path
    $InputPaths.ClearGameButton = CreateButton -X ($InputPaths.GameButton.Right + (DPISize 15)) -Y (DPISize 18) -Width ($InputPaths.GameGroup.Right - $InputPaths.GameButton.Right - (DPISize 30)) -Height (DPISize 22) -Text "Clear" -Info "Clear the selected ROM or VC WAD file"
    $InputPaths.ClearGameButton.Add_Click({
        if (IsSet -Elem $GamePath -MinLength 1) {
            $global:GamePath = $null
            $Settings["Core"][$InputPaths.GameTextBox.name] = ""
            $InputPaths.GameTextBox.Text = "Select or drag and drop your ROM or VC WAD file..."
            $global:GameIsSelected = $Patches.Panel.Enabled = $InputPaths.ClearGameButton.Enabled = $InputPaths.PatchPanel.Visible = $False
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
    $InputPaths.InjectPanel = CreatePanel -Width (DPISize 590) -Height (DPISize 50)

    # Create the groupbox that holds the ROM path
    $InputPaths.InjectGroup = CreateGroupBox -Width $InputPaths.InjectPanel.Width -Heigh $InputPaths.InjectPanel.Height -Text "Inject ROM Path"
    $InputPaths.InjectGroup.AllowDrop = $True
    $InputPaths.InjectGroup.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputPaths.InjectGroup.Add_DragDrop({ InjectPath_DragDrop })

    # Create a textbox to display the selected ROM
    $InputPaths.InjectTextBox = CreateTextBox -X (DPISize 10) -Y (DPISize 20) -Width (DPISize 420) -Height (DPISize 22) -Text "Select or drag and drop your NES, SNES or N64 ROM..." -Name "Path.Inject" -ReadOnly $True
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
    $InputPaths.PatchPanel = CreatePanel -Width (DPISize 590) -Height (DPISize 50)
    $InputPaths.PatchPanel.Visible = $False
    
    # Create the groupbox that holds the BPS path.
    $InputPaths.PatchGroup = CreateGroupBox -Width $InputPaths.PatchPanel.Width -Height $InputPaths.PatchPanel.Height -Text "Custom Patch Path"
    $InputPaths.PatchGroup.AllowDrop = $True
    $InputPaths.PatchGroup.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputPaths.PatchGroup.Add_DragDrop({ PatchPath_DragDrop })
    
    # Create a textbox to display the selected BPS.
    $InputPaths.PatchTextBox = CreateTextBox -X (DPISize 10) -Y (DPISize 20) -Width (DPISize 420) -Height (DPISize 22) -Text "Select or drag and drop your BPS, IPS, UPS, Xdelta, VCDiff or PPF Patch File..." -Name "Path.Patch" -ReadOnly $True
    $InputPaths.PatchTextBox.AllowDrop = $True
    $InputPaths.PatchTextBox.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputPaths.PatchTextBox.Add_DragDrop({ PatchPath_DragDrop })

    # Create a button to allow manually selecting a ROM.
    $InputPaths.PatchButton = CreateButton -X ($InputPaths.PatchTextBox.Right + (DPISize 6)) -Y (DPISize 18) -Width (DPISize 24) -Height (DPISize 22) -Text "..." -Info "Select your BPS, IPS, UPS, Xdelta or VCDiff Patch File using file explorer"
    $InputPaths.PatchButton.Add_Click({ PatchPath_Button -TextBox $InputPaths.PatchTextBox -Description "Patch Files" -FileNames @('*.bps', '*.ips', '*.ups' ,'*.xdelta', '*.vcdiff') })
    
    # Create a button to allow patch the WAD with a BPS file.
    $InputPaths.ApplyPatchButton = CreateButton -X ($InputPaths.PatchButton.Right + (DPISize 15)) -Y (DPISize 18) -Width ($InputPaths.PatchGroup.Right - $InputPaths.PatchButton.Right - (DPISize 30)) -Height (DPISize 22) -Text "Apply Patch" -Info "Patch the ROM with your selected BPS, IPS, UPS, Xdelta or VCDiff Patch File"
    $InputPaths.ApplyPatchButton.Add_Click({ MainFunction -Command "Apply Patch" -PatchedFileName "_bps_patched" })
    $InputPaths.ApplyPatchButton.Enabled = $False



    ################
    # Current Game #
    ################

    # Create the panel that holds the current selected game.
    $global:CurrentGamePanel = CreatePanel -Width (DPISize 590) -Height (DPISize 50)

    # Create the groupbox that holds the current game options
    $CurrentGameGroup = CreateGroupBox -Width $CurrentGamePanel.Width -Height $CurrentGamePanel.Height -Text "Current Game Mode"

    # Create a combobox with the list of supported consoles
    $global:ConsoleComboBox = CreateComboBox -X (DPISize 10) -Y (DPISize 20) -Width (DPISize 200) -Height (DPISize 30) -Name "Selected.Console"
    $ConsoleComboBox.Add_SelectedIndexChanged({
        $Settings["Core"][$this.Name] = $this.SelectedIndex
        if ($this.Text -ne $GameConsole.title) { ChangeGamesList }
    })

    # Create a combobox with the list of supported games
    $global:CurrentGameComboBox = CreateComboBox -X ($ConsoleComboBox.Right + (DPISize 5)) -Y (DPISize 20) -Width (DPISize 360) -Height (DPISize 30) -Name "Selected.Game"
    $CurrentGameComboBox.Add_SelectedIndexChanged({
        $Settings["Core"][$this.Name] = $this.SelectedIndex
        if ($this.Text -ne $GameType.title) {
            ChangeGameMode
            SetVCPanel
            SetMainScreenSize
        }
    })

    $Files.json.consoles = SetJSONFile $Files.json.consoles
    $Files.json.games    = SetJSONFile $Files.json.games



    #################
    # Custom Header #
    #################

    # Create the panel that holds the Custom Header.
    $global:CustomHeaderPanel = CreatePanel -Width (DPISize 590) -Height (DPISize 80)

    # Create the groupbox that holds the Custom Header.
    $global:CustomHeaderGroup = CreateGroupBox -Width $CustomHeaderPanel.Width -Height $CustomHeaderPanel.Height -Text "Custom Channel Title and GameID"

    # Custom Channel Title
    $global:CustomTitleTextBoxLabel = CreateLabel -X (DPISize 8) -Y (DPISize 22) -Width (DPISize 75) -Height (DPISize 15) -Text "Channel Title:" -Info "--- WARNING ---`nChanging the Game Title might causes issues with emulation for certain emulators and plugins, such as GlideN64"
    $global:CustomTitleTextBox = CreateTextBox -X (DPISize 85) -Y (DPISize 20) -Width (DPISize 260) -Height (DPISize 22) -Info "--- WARNING ---`nChanging the Game Title might causes issues with emulation for certain emulators and plugins, such as GlideN64"
    $CustomTitleTextBox.Add_TextChanged({
        if ($this.Text -match "[^a-z 0-9 \: \- \( \) \' \&] \.") {
            $cursorPos = $this.SelectionStart
            $this.Text = $this.Text -replace "[^a-z 0-9 \: \- \( \) \' \& \.]",''
            $this.SelectionStart = $cursorPos - 1
            $this.SelectionLength = 0
        }
    })

    # Custom GameID (N64 only)
    $global:CustomGameIDTextBoxLabel = CreateLabel -X (DPISize 370) -Y (DPISize 22) -Width (DPISize 50) -Height (DPISize 15) -Text "GameID:" -Info "--- WARNING ---`nChanging the GameID causes Dolphin to recognize the VC title as a separate save file`nThe fourth character sets the region and refresh rate`n`n--- REGION CODES ---`nE = USA`nJ = Japan`nP = PAL`nK = Korea"
    $global:CustomGameIDTextBox = CreateTextBox -X (DPISize 425) -Y (DPISize 20) -Width (DPISize 55) -Height (DPISize 22) -Length 4 -Info "--- WARNING ---`nChanging the GameID causes Dolphin to recognize the VC title as a separate save file`nThe fourth character sets the region and refresh rate`n`n--- REGION CODES ---`nE = USA`nJ = Japan`nP = PAL`nK = Korea"
    $CustomGameIDTextBox.Add_TextChanged({
        if ($this.Text -cmatch "[^A-Z 0-9]") {
            $this.Text = $this.Text.ToUpper() -replace "[^A-Z 0-9]",''
            $this.Select($this.Text.Length, $this.Text.Length)
        }
        if ($this.Text -cmatch " ") {
            $this.Text = $this.Text.ToUpper() -replace " ",''
            $this.Select($this.Text.Length, $this.Text.Length)
        }
    })

    # Custom Region (SNES only)
    $global:CustomRegionCodeLabel = CreateLabel -X ($CustomTitleTextBoxLabel.Left) -Y (DPISize 50) -Width (DPISize 55) -Height (DPISize 15) -Text "Region:" -Info "--- WARNING ---`nChanging the Region Code can softlock the game"
    $Items = @("Japan (NTSC)", "North America (NTSC)", "Europe (PAL)", "Sweden/Scandinavia (PAL)", "Finland (PAL)", "Denmark (PAL)", "France (SECAM)", "Netherlands (PAL)", "Spain (PAL)", "Germany (PAL)", "Italy (PAL)", "China (PAL)", "Indonesia (PAL)", "Kora (NTSC)", "Global", "Canada (NTSC)", "Brazil (PAL-M)", "Australia (PAL)", "Other (1)", "Other (2)", "Other (3)")
    $global:CustomRegionCodeComboBox = CreateComboBox -X $CustomTitleTextBox.Left -Y ($CustomTitleTextBoxLabel.Bottom + 12) -Width $CustomTitleTextBox.Width -Height $CustomTitleTextBox.Height -Items $Items -Default 2
    
    # Custom Header Checkbox
    $CustomHeaderLabel = CreateLabel -X (DPISize 510) -Y (DPISize 22) -Width (DPISize 50) -Height (DPISize 15) -Text "Enable:" -Info "Enable in order to change the Game ID and title of the ROM or WAD file"
    $global:CustomHeaderCheckbox = CreateCheckBox -X (DPISize 560) -Y (DPISize 20) -Width (DPISize 20) -Height (DPISize 20) -Name "CustomHeader" -Info "Enable in order to change the Game ID and title of the ROM or WAD file"
    $CustomHeaderLabel.Add_Click({ $CustomHeaderCheckbox.Checked = !$CustomHeaderCheckbox.Checked })

    # Create a button to patch the header only
    $global:CustomHeaderPatchButton = CreateButton -X ($InputPaths.ClearGameButton.Left) -Y ($CustomTitleTextBoxLabel.Bottom + (DPISize 12)) -Width ($InputPaths.ClearGameButton.Width) -Height (DPISize 22) -Text "Patch Header" -Info "Patch the header of the selected game only"
    $CustomHeaderPatchButton.Add_Click({ MainFunction -Command "Patch Header" -PatchedFileName "_header_patched" })
    $CustomHeaderPatchButton.Enabled = $False


    ###############
    # Patch Panel #
    ###############

    # Create a panel to contain everything for patches.
    $Patches.Panel = CreatePanel -Width (DPISize 590) -Height (DPISize 90)
    $Patches.Panel.Enabled = $False

    # Create a groupbox to show the patching buttons.
    $Patches.Group = CreateGroupBox -Width $Patches.Panel.Width -Height $Patches.Panel.Height

    # Create patch button
    $Patches.Button = CreateButton -X (DPISize 10) -Y (DPISize 45) -Width (DPISize 300) -Height (DPISize 35) -Text "Patch Selected Option"
    $Patches.Button.Add_Click( { MainFunction -Command $GamePatch.command -PatchedFileName $GamePatch.output } )

    # Create combobox
    $Patches.ComboBox = CreateComboBox -X ($Patches.Button.Left) -Y ($Patches.Button.Top - (DPISize 25)) -Width ($Patches.Button.Width) -Height (DPISize 30) -Name "Selected.Patch"
    $global:PatchToolTip = CreateToolTip
    $Patches.ComboBox.Add_SelectedIndexChanged( {
        if (!$IsActiveGameField) { return }

        $Settings["Core"][$this.Name] = $this.SelectedIndex
        foreach ($Item in $Files.json.patches.patch) {
            if ($Item.title -eq $Patches.ComboBox.Text) {
                if ( ($IsWiiVC -and $Item.console -eq "Wii VC") -or (!$IsWiiVC -and $Item.console -eq "Native") -or ($Item.console -eq "Both") ) {
                    $global:GamePatch = $Item
                    $PatchToolTip.SetToolTip($Patches.Button, ([String]::Format($Item.tooltip, [Environment]::NewLine)))
                    GetHeader
                    LoadAdditionalOptions
                    DisablePatches
                }
            }
        }
    } )

    # Additional Options Checkbox
    $Patches.OptionsLabel = CreateLabel -X ($Patches.Button.Right + (DPISize 10)) -Y ($Patches.ComboBox.Top + (DPISize 5)) -Width (DPISize 85) -Height (DPISize 15) -Text "Enable Options:" -Info "Enable options in order to apply a customizable set of features and changes" 
    $Patches.Options = CreateCheckBox -X ($Patches.OptionsLabel.Right) -Y ($Patches.OptionsLabel.Top - (DPISize 2)) -Width (DPISize 20) -Height (DPISize 20) -Info "Enable options in order to apply a customizable set of features and changes" -Name "Patches.Options" -Checked $True
    $Patches.Options.Add_CheckStateChanged({
        $Patches.OptionsButton.Enabled = $this.checked
        if (!(IsSet $Redux.Groups)) { return }
        $Redux.Groups.GetEnumerator() | ForEach-Object {
            if ($_.IsRedux) { $_.Enabled = $this.Checked -and $Patches.Redux.Checked }
        }
    })
    $Patches.OptionsLabel.Add_Click({ $Patches.Options.Checked = !$Patches.Options.Checked })

    # Redux Checkbox
    $Patches.ReduxLabel = CreateLabel -X ($Patches.Button.Right + (DPISize 10)) -Y ($Patches.OptionsLabel.Bottom + (DPISize 15)) -Width (DPISize 85) -Height (DPISize 15) -Text "Enable Redux:" -Info "Enable the Redux patch which improves game mechanics`nIncludes among other changes the inclusion of the D-Pad for dedicated item buttons"
    $Patches.Redux = CreateCheckBox -X ($Patches.ReduxLabel.Right) -Y ($Patches.ReduxLabel.Top - (DPISize 2)) -Width (DPISize 20) -Height (DPISize 20) -Info "Enable the Redux patch which improves game mechanics`nIncludes among other changes the inclusion of the D-Pad for dedicated item buttons" -Name "Patches.Redux" -Checked $True
    $Patches.Redux.Add_CheckStateChanged({
        if (!(IsSet $Redux.Groups)) { return }
        $Redux.Groups.GetEnumerator() | ForEach-Object {
            if ($_.IsRedux) { $_.Enabled = $this.Checked -and $Patches.Options.Checked }
        }

        $FunctionTitle = SetFunctionTitle -Function $GameType.mode
        if (Get-Command ("AdjustGUI" + $FunctionTitle) -errorAction SilentlyContinue) { &("AdjustGUI" + $FunctionTitle) }

    })
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
    $VC.ActionsLabel = CreateLabel -X (DPISize 10) -Y (DPISize 32) -Width (DPISize 50) -Height (DPISize 15) -Text "Actions" -Font $Fonts.SmallBold -AddTo $VC.Group

    # Create a button to patch the VC
    $VC.PatchVCButton = CreateButton -X ($VC.ActionsLabel.Right + (DPISize 20)) -Y ($VC.ActionsLabel.Top - (DPISize 7)) -Width (DPISize 150) -Height (DPISize 30) -Text "Patch VC Emulator Only" -Info "Ignore any patches and only patches the Virtual Console emulator`nDowngrading and channing the Channel Title or GameID is still accepted"
    $VC.PatchVCButton.Add_Click({ MainFunction -Command "Patch VC" -PatchedFileName "_vc_patched" })

    # Create a button to extract the ROM
    $VC.ExtractROMButton = CreateButton -X ($VC.PatchVCButton.Right + (DPISize 10)) -Y ($VC.ActionsLabel.Top - (DPISize 7)) -Width (DPISize 150) -Height (DPISize 30) -Text "Extract ROM Only" -Info "Only extract the ROM from the WAD file`nUseful for native N64 emulators"
    $VC.ExtractROMButton.Add_Click({ MainFunction -Command "Extract" -PatchedFileName "_extracted" })

    # Create a label for Core patches
    $VC.CoreLabel = CreateLabel -X (DPISize 10) -Y (DPISize 62) -Width (DPISize 50) -Height (DPISize 15) -Text "Core" -Font $Fonts.SmallBold

    # Remove T64 description
    $VC.RemoveT64Label = CreateLabel -X ($VC.CoreLabel.Right + (DPISize 20)) -Y ($VC.CoreLabel.Top) -Width (DPISize 95) -Height (DPISize 15) -Text "Remove All T64:" -Info "Remove all textures that the Virtual Console replaced in the ROM`nThese replaced textures are known as T64`nThese replaced textures maybe be censored or to make the game look darker more fitting for the Wii"
    $VC.RemoveT64 = CreateCheckBox -X ($VC.RemoveT64Label.Right) -Y ($VC.CoreLabel.Top - (DPISize 2)) -Width (DPISize 20) -Height (DPISize 20) -Checked $True -Info "Remove all textures that the Virtual Console replaced in the ROM`nThese replaced textures are known as T64`nThese replaced textures maybe be censored or to make the game look darker more fitting for the Wii" -Name "VC.RemoveT64"
    $VC.RemoveT64.Add_CheckStateChanged({ CheckVCOptions })
    $VC.RemoveT64Label.Add_Click({ $VC.RemoveT64.Checked = !$VC.RemoveT64.Checked })

    # Expand Memory
    $VC.ExpandMemoryLabel = CreateLabel -X ($VC.RemoveT64.Right + (DPISize 10)) -Y ($VC.CoreLabel.Top) -Width (DPISize 95) -Height (DPISize 15) -Text "Expand Memory:" -Info "Expand the game's memory by 4MB"
    $VC.ExpandMemory = CreateCheckBox -X ($VC.ExpandMemoryLabel.Right) -Y ($VC.CoreLabel.Top - (DPISize 2)) -Width (DPISize 20) -Height (DPISize 20) -Info "Expand the game's memory by 4MB" -Name "VC.ExpandMemory"
    $VC.ExpandMemory.Add_CheckStateChanged({ CheckVCOptions })
    $VC.ExpandMemoryLabel.Add_Click({ $VC.ExpandMemory.Checked = !$VC.ExpandMemory.Checked })

    # Remove Filter
    $VC.RemoveFilterLabel = CreateLabel -X ($VC.RemoveT64.Right + (DPISize 10)) -Y ($VC.CoreLabel.Top) -Width (DPISize 95) -Height (DPISize 15) -Text "Remove Filter:" -Info "Remove the dark overlay filter"
    $VC.RemoveFilter = CreateCheckBox -X ($VC.RemoveFilterLabel.Right) -Y ($VC.CoreLabel.Top - (DPISize 2)) -Width (DPISize 20) -Height (DPISize 20) -Checked $True -Info "Remove the dark overlay filter" -Name "VC.RemoveFilter"
    $VC.RemoveFilter.Add_CheckStateChanged({ CheckVCOptions })
    $VC.RemoveFilterLabel.Add_Click({ $VC.RemoveFilter.Checked = !$VC.RemoveFilter.Checked })

    # Remap D-Pad
    $VC.RemapDPadLabel = CreateLabel -X ($VC.ExpandMemory.Right + (DPISize 10)) -Y ($VC.CoreLabel.Top) -Width (DPISize 95) -Height (DPISize 15) -Text "Remap D-Pad:" -Info "Remap the D-Pad to the actual four D-Pad directional buttons instead of toggling the minimap"
    $VC.RemapDPad = CreateCheckBox -X ($VC.RemapDPadLabel.Right) -Y ($VC.CoreLabel.Top - (DPISize 2)) -Width (DPISize 20) -Height (DPISize 20) -Info "Remap the D-Pad to the actual four D-Pad directional buttons instead of toggling the minimap" -Name "VC.RemapDPad"
    $VC.RemapDPad.Add_CheckStateChanged({ CheckVCOptions })
    $VC.RemapDPadLabel.Add_Click({ $VC.RemapDPad.Checked = !$VC.RemapDPad.Checked })

    # Remap L
    $VC.RemapLLabel = CreateLabel -X ($VC.ExpandMemory.Right + (DPISize 10)) -Y ($VC.CoreLabel.Top) -Width (DPISize 95) -Height (DPISize 15) -Text "Remap L Button:" -Info "Remap the L button to the actual L button button"
    $VC.RemapL = CreateCheckBox -X ($VC.RemapDPadLabel.Right) -Y ($VC.CoreLabel.Top - (DPISize 2)) -Width (DPISize 20) -Height (DPISize 20) -Info "Remap the L button to the actual L button button" -Name "VC.RemapL"
    $VC.RemapL.Add_CheckStateChanged({ CheckVCOptions })
    $VC.RemapLLabel.Add_Click({ $VC.RemapL.Checked = !$VC.RemapL.Checked })

    # Create a label for Minimap
    $VC.MinimapLabel = CreateLabel -X (DPISize 10) -Y ($VC.CoreLabel.Bottom + (DPISize 5)) -Width (DPISize 50) -Height (DPISize 15) -Text "Minimap" -Font $Fonts.SmallBold -AddTo $VC.Group

    # Remap C-Down
    $VC.RemapCDownLabel = CreateLabel -X ($VC.MinimapLabel.Right + (DPISize 20)) -Y ($VC.MinimapLabel.Top) -Width (DPISize 95) -Height (DPISize 15) -Text "Remap C-Down:" -Info "Remap the C-Down button for toggling the minimap instead of using an item"
    $VC.RemapCDown = CreateCheckBox -X ($VC.RemapCDownLabel.Right) -Y ($VC.MinimapLabel.Top - (DPISize 2)) -Width (DPISize 20) -Height (DPISize 20) -Info "Remap the C-Down button for toggling the minimap instead of using an item" -Name "VC.RemapCDown"
    $VC.RemapCDown.Add_CheckStateChanged({ CheckVCOptions })
    $VC.RemapCDownLabel.Add_Click({ $VC.RemapCDown.Checked = !$VC.RemapCDown.Checked })

    # Remap Z
    $VC.RemapZLabel = CreateLabel -X ($VC.RemapCDown.Right + (DPISize 10)) -Y ($VC.MinimapLabel.Top) -Width (DPISize 95) -Height (DPISize 15) -Text "Remap Z Button:" -Info "Remap the Z (GameCube) or ZL and ZR (Classic) buttons for toggling the minimap instead of using an item"
    $VC.RemapZ = CreateCheckBox -X ($VC.RemapZLabel.Right) -Y ($VC.MinimapLabel.Top - (DPISize 2)) -Width (DPISize 20) -Height (DPISize 20) -Info "Remap the Z (GameCube) or ZL and ZR (Classic) buttons for toggling the minimap instead of using an item" -Name "VC.RemapZ"
    $VC.RemapZ.Add_CheckStateChanged({ CheckVCOptions })
    $VC.RemapZLabel.Add_Click({ $VC.RemapZ.Checked = !$VC.RemapZ.Checked })

    # Leave D-Pad Up
    $VC.LeaveDPadUpLabel = CreateLabel -X ($VC.RemapZ.Right + (DPISize 10)) -Y ($VC.MinimapLabel.Top) -Width (DPISize 95) -Height (DPISize 15) -Text "Leave D-Pad Up:" -Info "Leave the D-Pad untouched so it can be used to toggle the minimap"
    $VC.LeaveDPadUp = CreateCheckBox -X ($VC.LeaveDPadUpLabel.Right) -Y ($VC.MinimapLabel.Top - (DPISize 2)) -Width (DPISize 20) -Height (DPISize 20) -Info "Leave the D-Pad untouched so it can be used to toggle the minimap" -Name "VC.LeaveDPadUp"
    $VC.LeaveDPadUp.Add_CheckStateChanged({ CheckVCOptions })
    $VC.LeaveDPadUpLabel.Add_Click({ $VC.LeaveDPadUp.Checked = !$VC.LeaveDPadUp.Checked })



    ##############
    # Misc Panel #
    ##############

    # Create a panel to contain everything for other.
    $global:MiscPanel = CreatePanel -Width (DPISize 590) -Height (DPISize 75)

    # Create a groupbox to show the misc buttons.
    $global:MiscGroup = CreateGroupBox -Width ($MiscPanel.Width) -Height ($MiscPanel.Height) -Text "Other Buttons"

    # Create a button to show information about the patches.
    $CreditsButton = CreateButton -X (DPISize 10) -Y (DPISize 25) -Width (DPISize 180) -Height (DPISize 35) -Text "Info / Credits" -Info ("Open the list with credits and info of all of patches involved and those who helped with the " + $ScriptName)
    $CreditsButton.Add_Click({ $CreditsDialog.ShowDialog() | Out-Null })

    # Create a button to show the global settings panel
    $SettingsButton = CreateButton -X ($CreditsButton.Right + (DPISize 10)) -Y ($CreditsButton.Top) -Width ($CreditsButton.Width) -Height ($CreditsButton.Height) -Text "Settings" -Info "Open the global settings panel"
    $SettingsButton.Add_Click({ $SettingsDialog.ShowDialog() | Out-Null })

    # Create a button to close the dialog.
    $global:ExitButton = CreateButton -X  ($SettingsButton.Right + (DPISize 10)) -Y ($CreditsButton.Top) -Width ($CreditsButton.Width) -Height ($CreditsButton.Height) -Text "Exit" -Info ("Save all settings and close the " + $ScriptName)
    $ExitButton.Add_Click({ $MainDialog.Close() })



    ##############
    # Misc Panel #
    ##############

    $global:StatusPanel = CreatePanel -Width (DPISize 625) -Height (DPISize 30)
    $global:StatusGroup = CreateGroupBox -Width (DPISize 590) -Height (DPISize 30)
    $global:StatusLabel = Createlabel -X (DPISize 8) -Y (DPISize 10) -Width (DPISize 570) -Height (DPISize 15)

}



#==============================================================================================================================================================================================
function SetJSONFile($File) {

    if (TestFile $File) {
        try { $File = Get-Content -Raw -Path $File | ConvertFrom-Json }
        catch { CreateErrorDialog -Error "Corrupted JSON" -Exit }
        return $File
    }
    else {
        CreateErrorDialog "Corrupted JSON"
        return $null
    }

}



#==============================================================================================================================================================================================
function CheckVCOptions() {
    
    if (!$IsWiiVC) { return }

    if     (IsChecked $VC.RemoveT64)      { $VC.PatchVCButton.Enabled = $True }
    elseif (IsChecked $VC.ExpandMemory)   { $VC.PatchVCButton.Enabled = $True }
    elseif (IsChecked $VC.RemoveFilter)   { $VC.PatchVCButton.Enabled = $True }
    elseif (IsChecked $VC.RemapDPad)      { $VC.PatchVCButton.Enabled = $True }
    elseif (IsChecked $VC.Downgrade)      { $VC.PatchVCButton.Enabled = $True }
    elseif (IsChecked $VC.RemapCDown)     { $VC.PatchVCButton.Enabled = $True }
    elseif (IsChecked $VC.RemapL)         { $VC.PatchVCButton.Enabled = $True }
    elseif (IsChecked $VC.RemapZ)         { $VC.PatchVCButton.Enabled = $True }
    elseif (IsChecked $VC.LeaveDPadUp)    { $VC.PatchVCButton.Enabled = $True }
    else                                  { $VC.PatchVCButton.Enabled = $False }

}



#==============================================================================================================================================================================================
function DisablePatches() {
    
    EnableElem -Elem @($Patches.Redux, $Patches.ReduxLabel) -Active ((IsSet $GamePatch.redux.file) -and $Settings.Debug.LiteGUI -eq $False) -Hide
    EnableElem -Elem @($Patches.Options, $Patches.OptionsLabel, $Patches.OptionsButton) -Active ($Patches.OptionsButton.Visible = $GamePatch.options) -Hide
    EnableElem -Elem @($Patches.Downgrade, $Patches.DowngradeLabel) -Active ((IsSet $GameType.downgrade) -and $Settings.Debug.LiteGUI -eq $False) -Hide
    #EnableElem -Elem @($VC.RemoveFilter, $VC.RemoveFilterLabel) -Active (!(StrLike -str $GamePatch.command -val "Patch Boot DOL"))
    EnableElem -Elem @($VC.RemapL, $VC.RemapLLabel) -Active (!(StrLike -str $GamePatch.command -val "Multiplayer"))

    # Disable boxes if needed
    EnableElem -Elem $Patches.OptionsButton -Active $Patches.Options.Checked
    if (IsSet $Redux) {
        $Redux.Groups.GetEnumerator() | ForEach-Object {
            if ($_.IsRedux) {  EnableElem -Elem $_ -Active ($Patches.Options.Checked -and $Patches.Redux.Checked) }
        }
    }

}



#==============================================================================================================================================================================================
function LoadAdditionalOptions(){

    # Create options content based on current game
    if ($GamePatch.options -eq 1) {
        $FunctionTitle = SetFunctionTitle -Function $GameType.mode
        if (Get-Command ("CreateOptions" + $FunctionTitle) -errorAction SilentlyContinue)   { &("CreateOptions" + $FunctionTitle) }
        [System.GC]::Collect() | Out-Null
    }

}



#==================================================================================================================================================================================================================================================================
function GamePath_Button([Object]$TextBox, [String]$Description, [String[]]$FileNames) {
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
function InjectPath_Button([Object]$TextBox, [String]$Description, [String[]]$FileNames) {
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
function PatchPath_Button([Object]$TextBox, [String]$Description, [String[]]$FileNames) {
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
        $DroppedPath = [String]($_.Data.GetData([Windows.Forms.DataFormats]::FileDrop))
        
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
        $DroppedPath = [String]($_.Data.GetData([Windows.Forms.DataFormats]::FileDrop))
        
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
        $DroppedPath = [String]($_.Data.GetData([Windows.Forms.DataFormats]::FileDrop))
        
        # See if the dropped item is a file
        if (TestFile $DroppedPath) {
            # Get the extension of the dropped file.
            $DroppedExtn = (Get-Item -LiteralPath $DroppedPath).Extension

            # Make sure it is a BPS File
            if ($DroppedExtn -eq '.bps' -or $DroppedExtn -eq '.ips' -or $DroppedExtn -eq '.ups' -or $DroppedExtn -eq '.xdelta' -or $DroppedExtn -eq '.vcdiff') {
                # Finish everything up.
                $Settings["Core"][$this.name] = $DroppedPath
                PatchPath_Finish -TextBox $InputPaths.PatchTextBox -Path $DroppedPath
            }
        }
    }

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function CreateMainDialog
Export-ModuleMember -Function CheckVCOptions
Export-ModuleMember -Function DisablePatches
Export-ModuleMember -Function LoadAdditionalOptions