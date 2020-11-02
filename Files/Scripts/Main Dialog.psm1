function CreateMainDialog() {

    # Create the main dialog that is shown to the user.
    $global:MainDialog = New-Object System.Windows.Forms.Form
    $MainDialog.Text = $ScriptName
    $MainDialog.Size = New-Object System.Drawing.Size(625, 745)
    $MainDialog.MaximizeBox = $false
    $MainDialog.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::None
    $MainDialog.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $MainDialog.StartPosition = "CenterScreen"
    $MainDialog.KeyPreview = $true
    $MainDialog.Add_Shown({ $MainDialog.Activate() })
    $MainDialog.Icon = $Files.icon.main

    # Create a tooltip
    $global:ToolTip = CreateToolTip

    # Create a label to show current mode.
    $global:CurrentModeLabel = CreateLabel -Font $CurrentModeFont -AddTo $MainDialog
    $CurrentModeLabel.AutoSize = $True

    # Create a label to show current version.
    $VersionLabel = CreateLabel -X 15 -Y 10 -Width 120 -Height 30 -Text ($Version + "`n(" + $VersionDate + ")") -Font $VCPatchFont -AddTo $MainDialog



    ############
    # WAD Path #
    ############

    # Create the panel that holds the WAD path
    $global:InputWADPanel = CreatePanel -Width 590 -Height 50 -AddTo $MainDialog

    # Create the groupbox that holds the WAD path
    $global:InputWADGroup = CreateGroupBox -Width $InputWADPanel.Width -Height $InputWADPanel.Height -Name "GameWAD" -Text "WAD Path" -AddTo $InputWADPanel
    $InputWADGroup.AllowDrop = $True
    $InputWADGroup.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputWADGroup.Add_DragDrop({ WADPath_DragDrop })

    # Create a textbox to display the selected WAD
    $global:InputWADTextBox = CreateTextBox -X 10 -Y 20 -Width 420 -Height 22 -Name "GameWAD" -Text "Select or drag and drop your Virtual Console WAD file..." -ReadOnly $True -AddTo $InputWADGroup
    $InputWADTextBox.AllowDrop = $True
    $InputWADTextBox.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputWADTextBox.Add_DragDrop({ WADPath_DragDrop })

    # Create a button to allow manually selecting a WAD
    $global:InputWADButton = CreateButton -X ($InputWADTextBox.Right + 6) -Y 18 -Width 24 -Height 22 -Name "GameWAD" -Text "..." -ToolTip $ToolTip -Info "Select your VC WAD File using file explorer" -AddTo $InputWADGroup
    $InputWADButton.Add_Click({ WADPath_Button -TextBox $InputWADTextBox -Description 'VC WAD File' -FileName '*.wad' })

    # Create a button to clear the WAD Path
    $global:ClearWADPathButton = CreateButton -X ($InputWADButton.Right + 15) -Y 18 -Width ($InputWADGroup.Right - $InputWADButton.Right - 30) -Height 22 -Text "Clear" -ToolTip $ToolTip -Info "Clear the selected WAD file" -AddTo $InputWADGroup
    $ClearWADPathButton.Add_Click({
        if (IsSet -Elem $Files.WAD -MinLength 1) {
            $Files.WAD = $null
            $Settings["Core"][$InputWADTextBox.name] = ""
            $InputWADTextBox.Text = "Select or drag and drop your Virtual Console WAD file..."
            SetWiiVCMode -Enable $False
            ChangeGamesList
        }
    })
    $ClearWADPathButton.Enabled = $False



    ############
    # ROM Path #
    ############

    # Create the panel that holds the ROM path
    $global:InputROMPanel = CreatePanel -Width 590 -Height 50 -AddTo $MainDialog

    # Create the groupbox that holds the ROM path
    $InputROMGroup = CreateGroupBox -Width $InputROMPanel.Width -Heigh $InputROMPanel.Height -Name "GameROM" -Text "ROM Path" -AddTo $InputROMPanel
    $InputROMGroup.AllowDrop = $True
    $InputROMGroup.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputROMGroup.Add_DragDrop({ ROMPath_DragDrop })

    # Create a textbox to display the selected ROM
    $global:InputROMTextBox = CreateTextBox -X 10 -Y 20 -Width 420 -Height 22 -Name "GameROM" -Text "Select or drag and drop your N64, SNES or NES ROM..." -ReadOnly $True -AddTo $InputROMGroup
    $InputROMTextBox.AllowDrop = $True
    $InputROMTextBox.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputROMTextBox.Add_DragDrop({ ROMPath_DragDrop })

    # Create a button to allow manually selecting a ROM
    $global:InputROMButton = CreateButton -X ($InputROMTextBox.Right + 6) -Y 18 -Width 24 -Height 22 -Name "GameROM" -Text "..." -ToolTip $ToolTip -Info "Select your N64, SNES or NES ROM File using file explorer" -AddTo $InputROMGroup
    $InputROMButton.Add_Click({ ROMPath_Button -TextBox $InputROMTextBox -Description @('Z64 ROM', 'N64 ROM', 'V64 ROM', 'SFC ROM', 'SMC ROM', 'NES ROM') -FileName @('*.z64', '*.n64', '*.v64', '*.sfc', '*.smc', '*.nes') })
    
    # Create a button to allow patch the WAD with a ROM file
    $global:InjectROMButton = CreateButton -X ($InputROMButton.Right + 15) -Y 18 -Width ($InputWADGroup.Right - $InputROMButton.Right - 30) -Height 22 -Text "Inject ROM" -ToolTip $ToolTip -Info "Replace the ROM in your selected WAD File with your selected ROM File" -AddTo $InputROMGroup
    $InjectROMButton.Add_Click({ MainFunction -Command "Inject" -PatchedFileName "_injected" })
    $InjectROMButton.Visible = $False

    # Create a button to patch th header
    $global:PatchHeaderROMButton = CreateButton -X $InjectROMButton.Left -Y $InjectROMButton.Top -Width $InjectROMButton.Width -Height $InjectROMButton.Height -Text "Patch Header" -ToolTip $ToolTip -Info "Patch the header in the selected ROM file" -AddTo $InputROMGroup
    $PatchHeaderROMButton.Add_Click({ MainFunction -Command "Patch Header" -PatchedFileName "_header_patched" })


    ############
    # BPS Path #
    ############
    
    # Create the panel that holds the BPS path.
    $global:InputBPSPanel = CreatePanel -Width 590 -Height 50 -AddTo $MainDialog

    # Create the groupbox that holds the BPS path.
    $InputBPSGroup = CreateGroupBox -Width $InputBPSPanel.Width -Height $InputBPSPanel.Height -Name "GameBPS" -Text "Custom Patch Path" -AddTo $InputBPSPanel
    $InputBPSGroup.AllowDrop = $True
    $InputBPSGroup.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputBPSGroup.Add_DragDrop({ BPSPath_DragDrop })
    
    # Create a textbox to display the selected BPS.
    $global:InputBPSTextBox = CreateTextBox -X 10 -Y 20 -Width 420 -Height 22 -Name "GameBPS" -Text "Select or drag and drop your BPS, IPS, Xdelta, VCDiff or PPF Patch File..." -ReadOnly $True -AddTo $InputBPSGroup
    $InputBPSTextBox.AllowDrop = $True
    $InputBPSTextBox.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputBPSTextBox.Add_DragDrop({ BPSPath_DragDrop })

    # Create a button to allow manually selecting a ROM.
    $global:InputBPSButton = CreateButton -X ($InputBPSTextBox.Right + 6) -Y 18 -Width 24 -Height 22 -Name "GameBPS" -Text "..." -ToolTip $ToolTip -Info "Select your BPS, IPS, Xdelta or VCDiff Patch File using file explorer" -AddTo $InputBPSGroup
    $InputBPSButton.Add_Click({ BPSPath_Button -TextBox $InputBPSTextBox -Description @('BPS Patch File', 'IPS Patch File', 'XDelta Patch File', 'VCDiff Patch File') -FileName @('*.bps', '*.ips', '*.xdelta', '*.vcdiff') })
    
    # Create a button to allow patch the WAD with a BPS file.
    $global:PatchBPSButton = CreateButton -X ($InputBPSButton.Right + 15) -Y 18 -Width ($InputWADGroup.Right - $InputBPSButton.Right - 30) -Height 22 -Text "Apply Patch" -ToolTip $ToolTip -Info "Patch the ROM with your selected BPS or IPS Patch File" -AddTo $InputBPSGroup
    $PatchBPSButton.Add_Click({ MainFunction -Command "Apply Patch" -PatchedFileName "_bps_patched" })



    ################
    # Current Game #
    ################

    # Create the panel that holds the current selected game.
    $global:CurrentGamePanel = CreatePanel -Width 590 -Height 50 -AddTo $MainDialog

    # Create the groupbox that holds the current game options
    $CurrentGameGroup = CreateGroupBox -Width $CurrentGamePanel.Width -Height $CurrentGamePanel.Height -Text "Current Game Mode" -Name "CurrentGame" -AddTo $CurrentGamePanel

    # Create a combobox with the list of supported consoles
    $global:ConsoleComboBox = CreateComboBox -X 10 -Y 20 -Width 200 -Height 30 -Name "CurrentConsole" -AddTo $CurrentGameGroup
    $ConsoleComboBox.Add_SelectedIndexChanged({
        $Settings["Core"][$this.Name] = $this.SelectedIndex
        if ($this.Text -ne $GameConsole.title) { ChangeGamesList }
    })

    # Create a combobox with the list of supported games
    $global:CurrentGameComboBox = CreateComboBox -X ($ConsoleComboBox.Right + 5) -Y 20 -Width 360 -Height 30 -Name "CurrentGame" -AddTo $CurrentGameGroup
    $CurrentGameComboBox.Add_SelectedIndexChanged({
        $Settings["Core"][$this.Name] = $this.SelectedIndex
        if ($this.Text -ne $GameType.title) { ChangeGameMode }
    })

    $Files.json.consoles = SetJSONFile -File $Files.json.consoles
    $Files.json.games    = SetJSONFile -File $Files.json.games



    #################
    # Custom Header #
    #################

    # Create the panel that holds the Custom Header.
    $global:CustomHeaderPanel = CreatePanel -Width 590 -Height 50 -AddTo $MainDialog

    # Create the groupbox that holds the Custom Header.
    $global:CustomHeaderGroup = CreateGroupBox -Width $CustomHeaderPanel.Width -Height $CustomHeaderPanel.Height -Text "Custom Channel Title and GameID" -AddTo $CustomHeaderPanel

    # Create a label to show Custom Channel Title description.
    $global:CustomTitleTextBoxLabel = CreateLabel -X 8 -Y 22 -Width 75 -Height 15 -Text "Channel Title:" -AddTo $CustomHeaderGroup -Tooltip $Tooltip -Info "--- WARNING ---`nChanging the Game Title might causes issues with emulation for certain emulators and plugins, such as GlideN64"

    # Create a textbox to display the selected Custom Channel Title.
    $global:CustomTitleTextBox = CreateTextBox -X 85 -Y 20 -Width 260 -Height 22 -AddTo $CustomHeaderGroup -Tooltip $Tooltip -Info "--- WARNING ---`nChanging the Game Title might causes issues with emulation for certain emulators and plugins, such as GlideN64"
    $CustomTitleTextBox.Add_TextChanged({
        if ($this.Text -match "[^a-z 0-9 \: \- \( \) \' \&] \.") {
            $cursorPos = $this.SelectionStart
            $this.Text = $this.Text -replace "[^a-z 0-9 \: \- \( \) \' \& \.]",''
            $this.SelectionStart = $cursorPos - 1
            $this.SelectionLength = 0
        }
    })

    # Create a label to show Custom GameID description
    $global:CustomGameIDTextBoxLabel = CreateLabel -X 370 -Y 22 -Width 50 -Height 15 -Text "GameID:" -AddTo $CustomHeaderGroup -Tooltip $Tooltip -Info "--- WARNING ---`nChanging the GameID causes Dolphin to recognize the VC title as a separate save file`nThe fourth character sets the region and refresh rate`n`n--- REGION CODES ---`nE = USA`nJ = Japan`nP = PAL`nK = Korea"

    # Create a textbox to display the selected Custom GameID.
    $global:CustomGameIDTextBox = CreateTextBox -X 425 -Y 20 -Width 55 -Height 22 -Length 4 -AddTo $CustomHeaderGroup -Tooltip $Tooltip -Info "--- WARNING ---`nChanging the GameID causes Dolphin to recognize the VC title as a separate save file`nThe fourth character sets the region and refresh rate`n`n--- REGION CODES ---`nE = USA`nJ = Japan`nP = PAL`nK = Korea"

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

    # Create a label to show Custom GameID description
    $CustomHeaderLabel = CreateLabel -X 510 -Y 22 -Width 50 -Height 15 -Text "Enable:" -ToolTip $Tooltip -Info "Enable in order to change the Game ID and title of the ROM or WAD file" -AddTo $CustomHeaderGroup

    # Create a checkbox to allow Custom Channel Title & GameID.
    $global:CustomHeaderCheckbox = CreateCheckBox -X 560 -Y 20 -Width 20 -Height 20 -Name "CustomHeader" -ToolTip $Tooltip -Info "Enable in order to change the Game ID and title of the ROM or WAD file" -AddTo $CustomHeaderGroup
    $CustomHeaderCheckbox.Add_CheckStateChanged({ $PatchHeaderROMButton.Enabled = $Files.ROM -ne $null -and $this.Checked })



    ###############
    # Patch Panel #
    ###############

    # Create Array for patches
    $global:Patches = @{}

    # Create a panel to contain everything for patches.
    $Patches.Panel = CreatePanel -Width 590 -Height 90 -AddTo $MainDialog 

    # Create a groupbox to show the patching buttons.
    $Patches.Group = CreateGroupBox -Width $Patches.Panel.Width -Height $Patches.Panel.Height -AddTo $Patches.Panel

    # Create patch button
    $Patches.Button = CreateButton -X 10 -Y 45 -Width 300 -Height 35 -Text "Patch Selected Option" -AddTo $Patches.Group
    $Patches.Button.Add_Click( { MainFunction -Command $GamePatch.command -PatchedFileName $GamePatch.output } )

    # Create combobox
    $Patches.ComboBox = CreateComboBox -X $Patches.Button.Left -Y ($Patches.Button.Top - 25) -Width $Patches.Button.Width -Height 30 -Name "Patch" -AddTo $Patches.Group
    $Patches.ComboBox.Add_SelectedIndexChanged( {
        $Settings["Core"][$this.Name] = $this.SelectedIndex
        foreach ($Item in $Files.json.patches.patch) {
            if ($Item.title -eq $Patches.ComboBox.Text) {
                if ( ($IsWiiVC -and $Item.console -eq "Wii VC") -or (!$IsWiiVC -and $Item.console -eq "Native") -or ($Item.console -eq "Both") ) {
                    $global:GamePatch = $Item
                    $ToolTip.SetToolTip($Patches.Button, ([String]::Format($Item.tooltip, [Environment]::NewLine)))
                }
            }
        }
        if (IsSet -Elem $GamePatch.Languages) { CreateLanguagesContent }
        DisablePatches
        GetHeader
        if ( ($GameType.patches -gt 0) -and ($GamePatch.options -gt 0) )            { $OptionsLabel.text = $GameType.mode + " - Additional Options" }
        if ( ($GameType.patches -gt 0) -and ($GamePatch.redux.options -eq 1) )      { $ReduxLabel.text = $GameType.mode + " - Redux Settings" }
    } )

    # Redux Checkbox
    $Patches.ReduxLabel = CreateLabel -X ($Patches.Button.Right + 10) -Y ($Patches.ComboBox.Top + 5) -Width 85 -Height 15 -Text "Enable Redux:" -ToolTip $ToolTip -Info "Enable the Redux patch which improves game mechanics`nIncludes among other changes the inclusion of the D-Pad for dedicated item buttons" -AddTo $Patches.Group
    $Patches.Redux = CreateCheckBox -X $Patches.ReduxLabel.Right -Y ($Patches.ReduxLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Enable the Redux patch which improves game mechanics`nIncludes among other changes the inclusion of the D-Pad for dedicated item buttons" -Name "Redux" -AddTo $Patches.Group -Checked $True
    
    $Patches.Redux.Add_CheckStateChanged({
        $Patches.ReduxButton.Enabled = $this.Checked -and $Patches.Options.Checked
    })

    # Additional Options Checkbox
    $Patches.OptionsLabel = CreateLabel -X ($Patches.Button.Right + 10) -Y ($Patches.ReduxLabel.Bottom + 15) -Width 85 -Height 15 -Text "Enable Options:" -ToolTip $ToolTip -Info "Enable options in order to apply a customizable set of features and changes" -AddTo $Patches.Group
    $Patches.Options = CreateCheckBox -X $Patches.OptionsLabel.Right -Y ($Patches.OptionsLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Enable options in order to apply a customizable set of features and changes" -Name "Options" -AddTo $Patches.Group -Checked $True
    $Patches.Options.Add_CheckStateChanged({
        $Patches.OptionsButton.Enabled = $this.Checked
        $Patches.ReduxButton.Enabled = $this.Checked -and $Patches.Redux.Checked
        $Languages.TextBox.Enabled = $this.Checked -and $Languages[0].Checked
    })

    # Downgrade Checkbox
    $Patches.DowngradeLabel = CreateLabel -X ($Patches.Button.Right + 10) -Y ($Patches.OptionsLabel.Bottom + 15) -Width 85 -Height 15 -Text "Downgrade:" -ToolTip $ToolTip -Info "Downgrade the ROM to the first original revision" -AddTo $Patches.Group
    $Patches.Downgrade = CreateCheckBox -X $Patches.DowngradeLabel.Right -Y ($Patches.DowngradeLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Downgrade the ROM to the first original revision" -Name "Downgrade" -AddTo $Patches.Group

    # Redux Button
    $Patches.ReduxButton = CreateButton -X ($Patches.Redux.Right + 5) -Y 20 -Width 70 -Height 25 -Text "Redux" -ToolTip $ToolTip -Info 'Open the "Redux" panel to change the settings for the Redux patch' -AddTo $Patches.Group
    $Patches.ReduxButton.Add_Click( { $ReduxDialog.ShowDialog() } )
    $Patches.ReduxButton.Enabled = $False

    # Languages Button
    $Patches.LanguagesButton = CreateButton -X ($Patches.ReduxButton.Right + 5) -Y 20 -Width 70 -Height 25 -Text "Language" -ToolTip $ToolTip -Info 'Open the "Languages" panel to change the language' -AddTo $Patches.Group
    $Patches.LanguagesButton.Add_Click( { $LanguagesDialog.ShowDialog() } )

    # Patch Options
    $Patches.OptionsButton = CreateButton -X $Patches.ReduxButton.Left -Y ($Patches.ReduxButton.Bottom + 5) -Width 145 -Height $Patches.LanguagesButton.Height -Text "Select Options" -ToolTip $ToolTip -Info 'Open the "Additional Options" panel to change preferences' -AddTo $Patches.Group
    $Patches.OptionsButton.Add_Click( { $OptionsDialog.ShowDialog() } )
    $Patches.OptionsButton.Enabled = $False



    ####################
    # Patch VC Options #
    ####################

    # Create Array for VC options
    $global:VC = @{}

    # Create a panel to show the patch options.
    $VC.Panel = CreatePanel -Width 590 -Height 105 -AddTo $MainDialog

    # Create a groupbox to show the patch options.
    $VC.Group = CreateGroupBox -Width $VC.Panel.Width -Height $VC.Panel.Height -Text "Virtual Console - Patch Options" -AddTo $VC.Panel



    # Create a label for Patch VC Buttons
    $VC.ActionsLabel = CreateLabel -X 10 -Y 32 -Width 50 -Height 15 -Text "Actions" -Font $VCPatchFont -AddTo $VC.Group

    # Create a button to patch the VC
    $VC.PatchVCButton = CreateButton -X ($VC.ActionsLabel.Right + 20) -Y ($VC.ActionsLabel.Top - 7) -Width 150 -Height 30 -Text "Patch VC Emulator Only" -ToolTip $ToolTip -Info "Ignore any patches and only patches the Virtual Console emulator`nDowngrading and channing the Channel Title or GameID is still accepted" -AddTo $VC.Group
    $VC.PatchVCButton.Add_Click({ MainFunction -Command "Patch VC" -PatchedFileName "_vc_patched" })

    # Create a button to extract the ROM
    $VC.ExtractROMButton = CreateButton -X ($VC.PatchVCButton.Right + 10) -Y ($VC.ActionsLabel.Top - 7) -Width 150 -Height 30 -Text "Extract ROM Only" -ToolTip $ToolTip -Info "Only extract the ROM from the WAD file`nUseful for native N64 emulators" -AddTo $VC.Group
    $VC.ExtractROMButton.Add_Click({ MainFunction -Command "Extract" -PatchedFileName "_extracted" })



    # Create a label for Core patches
    $VC.CoreLabel = CreateLabel -X 10 -Y 62 -Width 50 -Height 15 -Text "Core" -Font $VCPatchFont -AddTo $VC.Group

    # Remove T64 description
    $VC.RemoveT64Label = CreateLabel -X ($VC.CoreLabel.Right + 20) -Y $VC.CoreLabel.Top -Width 95 -Height 15 -Text "Remove All T64:" -ToolTip $ToolTip -Info "Remove all textures that the Virtual Console replaced in the ROM`nThese replaced textures are known as T64`nThese replaced textures maybe be censored or to make the game look darker more fitting for the Wii" -AddTo $VC.Group
    $VC.RemoveT64 = CreateCheckBox -X $VC.RemoveT64Label.Right -Y ($VC.CoreLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Checked $True -Info "Remove all textures that the Virtual Console replaced in the ROM`nThese replaced textures are known as T64`nThese replaced textures maybe be censored or to make the game look darker more fitting for the Wii" -Name "RemoveT64" -AddTo $VC.Group
    $VC.RemoveT64.Add_CheckStateChanged({ CheckVCOptions })
    
    # Expand Memory
    $VC.ExpandMemoryLabel = CreateLabel -X ($VC.RemoveT64.Right + 10) -Y $VC.CoreLabel.Top -Width 95 -Height 15 -Text "Expand Memory:" -ToolTip $ToolTip -Info "Expand the game's memory by 4MB" -AddTo $VC.Group
    $VC.ExpandMemory = CreateCheckBox -X $VC.ExpandMemoryLabel.Right -Y ($VC.CoreLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Expand the game's memory by 4MB" -Name "ExpandMemory" -AddTo $VC.Group
    $VC.ExpandMemory.Add_CheckStateChanged({ CheckVCOptions })

    # Remove Filter
    $VC.RemoveFilterLabel = CreateLabel -X ($VC.RemoveT64.Right + 10) -Y $VC.CoreLabel.Top -Width 95 -Height 15 -Text "Remove Filter:" -ToolTip $ToolTip -Info "Remove the dark overlay filter" -AddTo $VC.Group
    $VC.RemoveFilter = CreateCheckBox -X $VC.RemoveFilterLabel.Right -Y ($VC.CoreLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Checked $True -Info "Remove the dark overlay filter" -Name "RemoveFilter" -AddTo $VC.Group
    $VC.RemoveFilter.Add_CheckStateChanged({ CheckVCOptions })

    # Remap D-Pad
    $VC.RemapDPadLabel = CreateLabel -X ($VC.ExpandMemory.Right + 10) -Y $VC.CoreLabel.Top -Width 95 -Height 15 -Text "Remap D-Pad:" -ToolTip $ToolTip -Info "Remap the D-Pad to the actual four D-Pad directional buttons instead of toggling the minimap" -AddTo $VC.Group
    $VC.RemapDPad = CreateCheckBox -X $VC.RemapDPadLabel.Right -Y ($VC.CoreLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Remap the D-Pad to the actual four D-Pad directional buttons instead of toggling the minimap" -Name "RemapDPad" -AddTo $VC.Group
    $VC.RemapDPad.Add_CheckStateChanged({ CheckVCOptions })

    # Remap L
    $VC.RemapLLabel = CreateLabel -X ($VC.ExpandMemory.Right + 10) -Y $VC.CoreLabel.Top -Width 95 -Height 15 -Text "Remap L Button:" -ToolTip $ToolTip -Info "Remap the L button to the actual L button button" -AddTo $VC.Group
    $VC.RemapL = CreateCheckBox -X $VC.RemapDPadLabel.Right -Y ($VC.CoreLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Remap the L button to the actual L button button" -Name "RemapL" -AddTo $VC.Group
    $VC.RemapL.Add_CheckStateChanged({ CheckVCOptions })



    # Create a label for Minimap
    $VC.MinimapLabel = CreateLabel -X 10 -Y ($VC.CoreLabel.Bottom + 5) -Width 50 -Height 15 -Text "Minimap" -Font $VCPatchFont -AddTo $VC.Group

    # Remap C-Down
    $VC.RemapCDownLabel = CreateLabel -X ($VC.MinimapLabel.Right + 20) -Y $VC.MinimapLabel.Top -Width 95 -Height 15 -Text "Remap C-Down:" -ToolTip $ToolTip -Info "Remap the C-Down button for toggling the minimap instead of using an item" -AddTo $VC.Group
    $VC.RemapCDown = CreateCheckBox -X $VC.RemapCDownLabel.Right -Y ($VC.MinimapLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Remap the C-Down button for toggling the minimap instead of using an item" -Name "RemapCDown" -AddTo $VC.Group
    $VC.RemapCDown.Add_CheckStateChanged({ CheckVCOptions })

    # Remap Z
    $VC.RemapZLabel = CreateLabel -X ($VC.RemapCDown.Right + 10) -Y $VC.MinimapLabel.Top -Width 95 -Height 15 -Text "Remap Z Button:" -ToolTip $ToolTip -Info "Remap the Z (GameCube) or ZL and ZR (Classic) buttons for toggling the minimap instead of using an item" -AddTo $VC.Group
    $VC.RemapZ = CreateCheckBox -X $VC.RemapZLabel.Right -Y ($VC.MinimapLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Remap the Z (GameCube) or ZL and ZR (Classic) buttons for toggling the minimap instead of using an item" -Name "RemapZ" -AddTo $VC.Group
    $VC.RemapZ.Add_CheckStateChanged({ CheckVCOptions })

    # Leave D-Pad Up
    $VC.LeaveDPadUpLabel = CreateLabel -X ($VC.RemapZ.Right + 10) -Y $VC.MinimapLabel.Top -Width 95 -Height 15 -Text "Leave D-Pad Up:" -ToolTip $ToolTip -Info "Leave the D-Pad untouched so it can be used to toggle the minimap" -AddTo $VC.Group
    $VC.LeaveDPadUp = CreateCheckBox -X $VC.LeaveDPadUpLabel.Right -Y ($VC.MinimapLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Leave the D-Pad untouched so it can be used to toggle the minimap" -Name "LeaveDPadUp" -AddTo $VC.Group
    $VC.LeaveDPadUp.Add_CheckStateChanged({ CheckVCOptions })



    ##############
    # Misc Panel #
    ##############

    # Create a panel to contain everything for other.
    $global:MiscPanel = CreatePanel -Width 590 -Height 75 -AddTo $MainDialog

    # Create a groupbox to show the misc buttons.
    $global:MiscGroup = CreateGroupBox -Width ($MiscPanel.Width - 5) -Height $MiscPanel.Height -Text "Other Buttons" -AddTo $MiscPanel

    # Create a button to show information about the patches.
    $CreditsButton = CreateButton -X 10 -Y 25 -Width 180 -Height 35 -Text "Info / Credits" -ToolTip $ToolTip -Info ("Open the list with credits and info of all of patches involved and those who helped with the " + $ScriptName) -AddTo $MiscGroup
    $CreditsButton.Add_Click({ $CreditsDialog.ShowDialog() | Out-Null })

    # Create a button to show the global settings panel
    $SettingsButton = CreateButton ($CreditsButton.Right + 10) -Y $CreditsButton.Top -Width $CreditsButton.Width -Height $CreditsButton.Height -Text "Settings" -ToolTip $ToolTip -Info "Open the global settings panel" -AddTo $MiscGroup
    $SettingsButton.Add_Click({ $SettingsDialog.ShowDialog() | Out-Null })

    # Create a button to close the dialog.
    $global:ExitButton = CreateButton -X ($SettingsButton.Right + 10) -Y $CreditsButton.Top -Width $CreditsButton.Width -Height $CreditsButton.Height -Text "Exit" -ToolTip $ToolTip -Info ("Save all settings and close the " + $ScriptName) -AddTo $MiscGroup
    $ExitButton.Add_Click({ $MainDialog.Close() })



    ##############
    # Misc Panel #
    ##############

    $global:StatusPanel = CreatePanel -Width 625 -Height 30 -AddTo $MainDialog
    $global:StatusGroup = CreateGroupBox -Width 590 -Height 30 -AddTo $StatusPanel
    $global:StatusLabel = Createlabel -X 8 -Y 10 -Width 570 -Height 15 -AddTo $StatusGroup



    ###############
    # Positioning #
    ###############

    $InputWADPanel.Location = New-Object System.Drawing.Size(10, 50)
    $InputROMPanel.Location = New-Object System.Drawing.Size(10, ($InputWADPanel.Bottom + 5))
    $InputBPSPanel.Location = New-Object System.Drawing.Size(10, ($InputROMPanel.Bottom + 5))
    $CurrentGamePanel.Location = New-Object System.Drawing.Size(10, ($InputBPSPanel.Bottom + 5))
    $CustomHeaderPanel.Location = New-Object System.Drawing.Size(10, ($CurrentGamePanel.Bottom + 5))

}



#==============================================================================================================================================================================================
function ResetTool() {
    
    $InputWADTextBox.Text = "Select or drag and drop your Virtual Console WAD file..."
    $InputROMTextBox.Text = "Select or drag and drop your NES, SNES or N64 ROM..."
    $InputBPSTextBox.Text = "Select or drag and drop your BPS, IPS, Xdelta or VCDiff Patch File..."

    RemoveFile -LiteralPath ($Paths.Base + "\Settings.ini")
    GetSettings

    $VC.RemoveT64.Checked = $VC.ExpandMemory.Checked = $VC.RemoveFilter.Checked = $VC.RemapDPad.Checked = $VC.Downgrade.Checked = $VC.RemapCDown.Checked = $VC.RemapZ.Checked = $VC.LeaveDPadUp.Checked = $False
    $PatchReduxCheckbox.Checked = $PatchOptionsCheckbox.Checked = $CustomHeaderCheckbox.Checked = $False
    $ConsoleComboBox.SelectedIndex = $CurrentGameComboBox.SelectedIndex = $PatchComboBox.SelectedIndex =  0
    $InjectROMButton.Enabled = $PatchBPSButton.Enabled = $False
    
    RestoreCustomHeader
    ChangeGameMode
    SetWiiVCMode -Enable $False
    EnablePatchButtons -Enable $False

}



#==============================================================================================================================================================================================
function SetJSONFile($File) {

    if (Test-Path -LiteralPath $File) {
        try { $File = Get-Content -Raw -Path $File | ConvertFrom-Json }
        catch { CreateErrorDialog -Error "Corrupted JSON" -Exit }
        return $File
    }
    else {
        CreateErrorDialog -Error "Corrupted JSON"
        return $null
    }

}



#==============================================================================================================================================================================================
function CheckVCOptions() {
    
    if (!$IsWiiVC) { return }

    if (IsChecked -Elem $VC.RemoveT64)          { $VC.PatchVCButton.Enabled = $True }
    elseif (IsChecked -Elem $VC.ExpandMemory)   { $VC.PatchVCButton.Enabled = $True }
    elseif (IsChecked -Elem $VC.RemoveFilter)   { $VC.PatchVCButton.Enabled = $True }
    elseif (IsChecked -Elem $VC.RemapDPad)      { $VC.PatchVCButton.Enabled = $True }
    elseif (IsChecked -Elem $VC.Downgrade)      { $VC.PatchVCButton.Enabled = $True }
    elseif (IsChecked -Elem $VC.RemapCDown)     { $VC.PatchVCButton.Enabled = $True }
    elseif (IsChecked -Elem $VC.RemapL)         { $VC.PatchVCButton.Enabled = $True }
    elseif (IsChecked -Elem $VC.RemapZ)         { $VC.PatchVCButton.Enabled = $True }
    elseif (IsChecked -Elem $VC.LeaveDPadUp)    { $VC.PatchVCButton.Enabled = $True }
    else                                        { $VC.PatchVCButton.Enabled = $False }

}



#==============================================================================================================================================================================================
function DisablePatches() {
    
    $Patches.Redux.Visible = $Patches.ReduxLabel.Visible = (IsSet -Elem $GamePatch.redux.file)
    $Patches.ReduxButton.Visible = $GamePatch.redux.options -eq 1
    $Patches.ReduxButton.Enabled = (IsSet -Elem $GamePatch.redux.file) -and $Patches.Redux.Checked -and ($GamePatch.redux.options -eq 1) -and $Patches.Options.Checked

    $Patches.Options.Visible = $Patches.OptionsLabel.Visible = $Patches.OptionsButton.Visible = $GamePatch.options
    $Patches.OptionsButton.Enabled = $GamePatch.options -and $Patches.Options.Checked
    
    $Patches.LanguagesButton.Visible = (IsSet -Elem $GamePatch.languages)

    $VC.RemoveFilterLabel.Enabled = $VC.RemoveFilter.Enabled = !(StrLike -str $GamePatch.command -val "Patch Boot DOL")

}



#==============================================================================================================================================================================================
function CreateLanguagesContent() {
    
    $Languages.Box.Text = $GameType.mode + " - Languages"
    $Patches.LanguagesButton.Visible = $GamePatch.languages -ne $null
    $ToolTip = CreateTooltip

    if (IsSet -Elem $GamePatch.languages -MinLength 0) {
        $Languages.Panel.Controls.Clear()
        $Row = -1
        for ($i=0; $i -lt $GamePatch.languages.Length; $i++) {
            if ($i % 3 -eq 1)       { $Column = 1 }
            elseif ($i % 3 -eq 2)   { $Column = 2 }
            else {
                $Column = 0
                $Row += 1
            }

            $Languages[$i] = CreateReduxRadioButton -Column $Column -Row $Row -AddTo $Languages.Panel -Text $GamePatch.languages[$i].title -ToolTip $ToolTip -Info ("Play the game in " + $GamePatch.languages[$i].title) -Name $GamePatch.languages[$i].title
        }
    
        $HasDefault = $False
        for ($i=0; $i -lt $GamePatch.languages.Length; $i++) {
            if ($Languages[$i].Checked) {
                $HasDefault = $True
                break
            }
        }
        if (!$HasDefault) { $Languages[0].Checked = $True }
    }


    
    # OPTIONS #
    $Languages.TextBox.Controls.Clear()
    if ($GameType.mode -eq "Ocarina of Time") {
        $Languages.TextSpeedPanel         = CreateReduxPanel                 -Row 0 -AddTo $Languages.TextBox
        $Languages.TextSpeed1x            = CreateReduxRadioButton -Column 0 -Row 0 -AddTo $Languages.TextSpeedPanel -Checked -Text "1x Text Speed" -ToolTip $ToolTip -Info "Leave the dialogue text speed at normal"               -Name "TextSpeed1x"
        $Languages.TextSpeed2x            = CreateReduxRadioButton -Column 1 -Row 0 -AddTo $Languages.TextSpeedPanel          -Text "2x Text Speed" -ToolTip $ToolTip -Info "Set the dialogue text speed to be twice as fast"       -Name "TextSpeed2x"
        $Languages.TextSpeed3x            = CreateReduxRadioButton -Column 2 -Row 0 -AddTo $Languages.TextSpeedPanel          -Text "3x Text Speed" -ToolTip $ToolTip -Info "Set the dialogue text speed to be three times as fast" -Name "TextSpeed3x"
        $Languages.TextRestore            = CreateReduxCheckBox    -Column 0 -Row 2 -AddTo $Languages.TextBox  -Text "Restore Text"            -ToolTip $ToolTip -Info "Restores the text used from the GC revision and applies grammar and typo fixes`nAlso corrects some icons in the text" -Name "TextRestore"
        $Languages.TextFemalePronouns     = CreateReduxCheckBox    -Column 1 -Row 2 -AddTo $Languages.TextBox  -Text "Female Pronouns"         -ToolTip $ToolTip -Info "Refer to Link as a female character`n- Requires the Restore Text option" -Name "TextFemalePronouns"
        $Languages.TextDialogueColors     = CreateReduxCheckBox    -Column 2 -Row 2 -AddTo $Languages.TextBox  -Text "GC Text Dialogue Colors" -ToolTip $ToolTip -Info "Set the Text Dialogue Colors to match the GameCube's color scheme" -Name "TextDialogueColors"
        $Languages.PauseScreen            = CreateReduxCheckBox    -Column 0 -Row 3 -AddTo $Languages.TextBox  -Text "MM Pause Screen"         -ToolTip $ToolTip -Info "Replaces the Pause Screen textures to be styled like Majora's Mask" -Name "PauseScreen"

        $Languages.TextRestore.Add_CheckedChanged({ $Languages.TextFemalePronouns.Enabled = $this.Checked })
    }
    elseif ($GameType.mode -eq "Majora's Mask") {
        $Languages.TextRestore            = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $Languages.TextBox -Text "Restore Text"        -ToolTip $ToolTip -Info "Restores and fixes the following:`n- Restore the area titles cards for those that do not have any`n- Sound effects that do not play during dialogue`n- Grammar and typo fixes" -Name "TextRestore"
        $Languages.OcarinaIcons           = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $Languages.TextBox -Text "Ocarina Icons (WIP)" -ToolTip $ToolTip -Info "Restore the Ocarina Icons with their text when transformed like in the N64 Beta or 3DS version (Work-In-Progress)`nRequires the Restore Text option" -Name "OcarinaIcons"
        
        $Languages.TextRestore.Add_CheckedChanged({ $Languages.OcarinaIcons.Enabled = $this.checked })
    }

    for ($i=0; $i -lt $GamePatch.languages.Length; $i++) {
            $Languages[$i].Add_CheckedChanged({ UnlockLanguageContent })
    }
    UnlockLanguageContent
        
}



#==============================================================================================================================================================================================
function UnlockLanguageContent() {
    
    # English options
    $Languages.TextBox.Enabled = $Patches.Options.Checked
    $Languages.TextRestore.Enabled = $Languages[0].checked

    if ($GameType.mode -eq "Ocarina of Time") {
        $Languages.TextDialogueColors.Enabled = $Languages.PauseScreen.Enabled = $Languages[0].checked
        $Languages.TextFemalePronouns.Enabled = $Languages[0].checked -and $Languages.TextRestore.Checked

        # Set max text speed in each language
        for ($i=0; $i -lt $GamePatch.languages.Length; $i++) {
            if ($Languages[$i].checked) {
                $Languages.TextSpeed1x.Enabled = $Languages.TextSpeed2x.Enabled = $Languages.TextSpeed3x.Enabled = $True
                if ($GamePatch.languages[$i].max_text_speed -lt 3) {
                    $Languages.TextSpeed3x.Enabled = $False
                    if ($Languages.TextSpeed3x.Checked) { $Languages.TextSpeed2x.checked = $True }
                }
                if ($GamePatch.languages[$i].max_text_speed -lt 2) {
                    $Languages.TextSpeed1x.Enabled = $Languages.TextSpeed2x.Enabled = $False
                }
            }
        }

    }

    elseif ($GameType.mode -eq "Majora's Mask") {
        $Languages.OcarinaIcons.Enabled = $Languages[0].checked -and $Languages.TextRestore.Checked
    }

}



#==================================================================================================================================================================================================================================================================
function WADPath_Button([Object]$TextBox, [string[]]$Description, [string[]]$FileName) {
        # Allow the user to select a file.
    $SelectedPath = Get-FileName -Path $Paths.Base -Description $Description -FileName $FileName

    # Make sure the path is not blank and also test that the path exists.
    if (($SelectedPath -ne '') -and (TestPath -LiteralPath $SelectedPath)) {
        # Finish everything up.
        $Settings["Core"][$this.name] = $SelectedPath
        WADPath_Finish -TextBox $TextBox -VarName $this.Name -WADPath $SelectedPath
    }

}



#==================================================================================================================================================================================================================================================================
function ROMPath_Button([Object]$TextBox, [string[]]$Description, [string[]]$FileName) {
        # Allow the user to select a file
    $SelectedPath = Get-FileName -Path $Paths.Base -Description $Description -FileName $FileName

    # Make sure the path is not blank and also test that the path exists
    if (($SelectedPath -ne '') -and (TestPath -LiteralPath $SelectedPath)) {
        # Finish everything up
        $Settings["Core"][$this.name] = $SelectedPath
        ROMPath_Finish -TextBox $TextBox -VarName $this.Name -ROMPath $SelectedPath
    }

}



#==================================================================================================================================================================================================================================================================
function BPSPath_Button([Object]$TextBox, [string[]]$Description, [string[]]$FileName) {
        # Allow the user to select a file
    $SelectedPath = Get-FileName -Path $Paths.Base -Description $Description -FileName $FileName

    # Make sure the path is not blank and also test that the path exists
    if (($SelectedPath -ne '') -and (TestPath -LiteralPath $SelectedPath)) {
        # Finish everything up
        $Settings["Core"][$this.name] = $SelectedPath
        BPSPath_Finish -TextBox $TextBox -VarName $this.Name -BPSPath $SelectedPath
    }

}



#==================================================================================================================================================================================================================================================================
function WADPath_DragDrop() {
    
    # Check for drag and drop data
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        # Get the first item in the list.
        $DroppedPath = [String]($_.Data.GetData([Windows.Forms.DataFormats]::FileDrop))
        
        # See if the dropped item is a file
        if (Test-Path -LiteralPath $DroppedPath -PathType Leaf) {
            # Get the extension of the dropped file.
            $DroppedExtn = (Get-Item -LiteralPath $DroppedPath).Extension

            # Make sure it is a WAD file
            if ($DroppedExtn -eq '.wad') {
                # Finish everything up.
                $Settings["Core"][$this.name] = $DroppedPath
                WADPath_Finish -TextBox $InputWADTextBox -VarName $this.Name -WADPath $DroppedPath
            }
        }
    }

}



#==================================================================================================================================================================================================================================================================
function ROMPath_DragDrop() {
    
    # Check for drag and drop data
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        # Get the first item in the list.
        $DroppedPath = [String]($_.Data.GetData([Windows.Forms.DataFormats]::FileDrop))
        
        # See if the dropped item is a file
        if (Test-Path -LiteralPath $DroppedPath -PathType Leaf) {
            # Get the extension of the dropped file.
            $DroppedExtn = (Get-Item -LiteralPath $DroppedPath).Extension

            # Make sure it is a ROM
            if ($DroppedExtn -eq '.z64' -or $DroppedExtn -eq '.n64' -or $DroppedExtn -eq '.v64' -or $DroppedExtn -eq '.sfc' -or $DroppedExtn -eq '.smc' -or $DroppedExtn -eq '.nes') {
                # Finish everything up.
                $Settings["Core"][$this.name] = $DroppedPath
                ROMPath_Finish -TextBox $InputROMTextBox -VarName $this.Name -ROMPath $DroppedPath
            }
        }
    }

}



#==================================================================================================================================================================================================================================================================
function BPSPath_DragDrop() {
    
    # Check for drag and drop data
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        # Get the first item in the list.
        $DroppedPath = [String]($_.Data.GetData([Windows.Forms.DataFormats]::FileDrop))
        
        # See if the dropped item is a file
        if (Test-Path -LiteralPath $DroppedPath -PathType Leaf) {
            # Get the extension of the dropped file.
            $DroppedExtn = (Get-Item -LiteralPath $DroppedPath).Extension

            # Make sure it is a BPS File
            if ($DroppedExtn -eq '.bps' -or $DroppedExtn -eq '.ips' -or $DroppedExtn -eq '.xdelta' -or $DroppedExtn -eq '.vcdiff') {
                # Finish everything up.
                $Settings["Core"][$this.name] = $DroppedPath
                BPSPath_Finish -TextBox $InputBPSTextBox -VarName $this.Name -BPSPath $DroppedPath
            }
        }
    }

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function CreateMainDialog
Export-ModuleMember -Function CheckVCOptions
Export-ModuleMember -Function ResetTool