function CreateMainDialog() {

    # Create the main dialog that is shown to the user.
    $Global:MainDialog = New-Object System.Windows.Forms.Form
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
    $Global:ToolTip = CreateToolTip

    # Create a label to show current mode.
    $Global:CurrentModeLabel = CreateLabel -Font $CurrentModeFont -AddTo $MainDialog
    $CurrentModeLabel.AutoSize = $True

    # Create a label to show current version.
    $VersionLabel = CreateLabel -X 15 -Y 10 -Width 120 -Height 30 -Text ("Version: " + $Version + "`n(" + $VersionDate + ")") -Font $VCPatchFont -AddTo $MainDialog



    ############
    # WAD Path #
    ############

    # Create the panel that holds the WAD path.
    $Global:InputWADPanel = CreatePanel -Width 590 -Height 50 -AddTo $MainDialog

    # Create the groupbox that holds the WAD path.
    $Global:InputWADGroup = CreateGroupBox -Width $InputWADPanel.Width -Height $InputWADPanel.Height -Name "GameWAD" -Text "WAD Path" -AddTo $InputWADPanel
    $InputWADGroup.AllowDrop = $True
    $InputWADGroup.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputWADGroup.Add_DragDrop({ WADPath_DragDrop })

    # Create a textbox to display the selected WAD.
    $Global:InputWADTextBox = CreateTextBox -X 10 -Y 20 -Width 440 -Height 22 -Name "GameWAD" -Text "Select or drag and drop your Virtual Console WAD file..." -ReadOnly $True -AddTo $InputWADGroup
    $InputWADTextBox.AllowDrop = $True
    $InputWADTextBox.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputWADTextBox.Add_DragDrop({ WADPath_DragDrop })

    # Create a button to allow manually selecting a WAD.
    $Global:InputWADButton = CreateButton -X 456 -Y 18 -Width 24 -Height 22 -Name "GameWAD" -Text "..." -ToolTip $ToolTip -Info "Select your VC WAD File using file explorer" -AddTo $InputWADGroup
    $InputWADButton.Add_Click({ WADPath_Button -TextBox $InputWADTextBox -Description 'VC WAD File' -FileName '*.wad' })

    # Create a button to clear the WAD Path
    $Global:ClearWADPathButton = CreateButton -X 495 -Y 18 -Width 80 -Height 22 -Text "Clear" -ToolTip $ToolTip -Info "Clear the selected WAD file" -AddTo $InputWADGroup
    $ClearWADPathButton.Add_Click({
        if (IsSet -Elem $Files.WAD -MinLength 1) {
            $Files.WAD = $null
            $Settings["Core"][$InputWADTextBox.name] = ""
            $InputWADTextBox.Text = "Select or drag and drop your Virtual Console WAD file..."
            ChangeGamesList
            SetWiiVCMode -Enable $False
        }
    })



    ############
    # ROM Path #
    ############

    # Create the panel that holds the ROM path.
    $Global:InputROMPanel = CreatePanel -Width 590 -Height 50 -AddTo $MainDialog

    # Create the groupbox that holds the ROM path.
    $InputROMGroup = CreateGroupBox -Width $InputROMPanel.Width -Heigh $InputROMPanel.Height -Name "GameZ64" -Text "ROM Path" -AddTo $InputROMPanel
    $InputROMGroup.AllowDrop = $True
    $InputROMGroup.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputROMGroup.Add_DragDrop({ Z64Path_DragDrop })

    # Create a textbox to display the selected ROM.
    $Global:InputROMTextBox = CreateTextBox -X 10 -Y 20 -Width 440 -Height 22 -Name "GameZ64" -Text "Select or drag and drop your Z64, N64 or V64 ROM..." -ReadOnly $True -AddTo $InputROMGroup
    $InputROMTextBox.AllowDrop = $True
    $InputROMTextBox.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputROMTextBox.Add_DragDrop({ Z64Path_DragDrop })

    # Create a button to allow manually selecting a ROM.
    $Global:InputROMButton = CreateButton -X 456 -Y 18 -Width 24 -Height 22 -Name "GameZ64" -Text "..." -ToolTip $ToolTip -Info "Select your Z64, N64 or V64 ROM File using file explorer" -AddTo $InputROMGroup
    $InputROMButton.Add_Click({ z64Path_Button -TextBox $InputROMTextBox -Description @('Z64 ROM', 'N64 ROM', 'V64 ROM') -FileName @('*.z64', '*.n64', '*.v64') })
    
    # Create a button to allow patch the WAD with a ROM file.
    $Global:InjectROMButton = CreateButton -X 495 -Y 18 -Width 80 -Height 22 -Text "Inject ROM" -ToolTip $ToolTip -Info "Replace the ROM in your selected WAD File with your selected Z64, N64 or V64 ROM File" -AddTo $InputROMGroup
    $InjectROMButton.Add_Click({ MainFunction -Command "Inject" -PatchedFileName "_injected" })



    ############
    # BPS Path #
    ############
    
    # Create the panel that holds the BPS path.
    $Global:InputBPSPanel = CreatePanel -Width 590 -Height 50 -AddTo $MainDialog

    # Create the groupbox that holds the BPS path.
    $InputBPSGroup = CreateGroupBox -Width $InputBPSPanel.Width -Height $InputBPSPanel.Height -Name "GameBPS" -Text "Custom Patch Path" -AddTo $InputBPSPanel
    $InputBPSGroup.AllowDrop = $True
    $InputBPSGroup.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputBPSGroup.Add_DragDrop({ BPSPath_DragDrop })
    
    # Create a textbox to display the selected BPS.
    $Global:InputBPSTextBox = CreateTextBox -X 10 -Y 20 -Width 440 -Height 22 -Name "GameBPS" -Text "Select or drag and drop your BPS, IPS, Xdelta, VCDiff or PPF Patch File..." -ReadOnly $True -AddTo $InputBPSGroup
    $InputBPSTextBox.AllowDrop = $True
    $InputBPSTextBox.Add_DragEnter({ $_.Effect = [Windows.Forms.DragDropEffects]::Copy })
    $InputBPSTextBox.Add_DragDrop({ BPSPath_DragDrop })

    # Create a button to allow manually selecting a ROM.
    $Global:InputBPSButton = CreateButton -X 456 -Y 18 -Width 24 -Height 22 -Name "GameBPS" -Text "..." -ToolTip $ToolTip -Info "Select your BPS, IPS, Xdelta or VCDiff Patch File using file explorer" -AddTo $InputBPSGroup
    $InputBPSButton.Add_Click({ BPSPath_Button -TextBox $InputBPSTextBox -Description @('BPS Patch File', 'IPS Patch File', 'XDelta Patch File', 'VCDiff Patch File') -FileName @('*.bps', '*.ips', '*.xdelta', '*.vcdiff') })
    
    # Create a button to allow patch the WAD with a BPS file.
    $Global:PatchBPSButton = CreateButton -X 495 -Y 18 -Width 80 -Height 22 -Text "Apply Patch" -ToolTip $ToolTip -Info "Patch the ROM with your selected BPS or IPS Patch File" -AddTo $InputBPSGroup
    $PatchBPSButton.Add_Click({ MainFunction -Command "Apply Patch" -PatchedFileName "_bps_patched" })



    ################
    # Current Game #
    ################

    # Create the panel that holds the current selected game.
    $Global:CurrentGamePanel = CreatePanel -Width 590 -Height 50 -AddTo $MainDialog

    # Create the groupbox that holds the current game options
    $CurrentGameGroup = CreateGroupBox -Width $CurrentGamePanel.Width -Height $CurrentGamePanel.Height -Text "Current Game Mode" -Name "CurrentGame" -AddTo $CurrentGamePanel

    # Create a combox for OoT ROM hack patches
    $Global:CurrentGameComboBox = CreateComboBox -X 10 -Y 20 -Width 440 -Height 30 -Name "CurrentGame" -AddTo $CurrentGameGroup
    $CurrentGameComboBox.Add_SelectedIndexChanged({
        $Settings["Core"][$this.Name] = $this.SelectedIndex
        if ($this.Text -ne $GameType.title) { ChangeGameMode }
    })

    if (Test-Path -LiteralPath $Files.json.games) {
        try { $Files.json.games = Get-Content -Raw -Path $Files.json.games | ConvertFrom-Json }
        catch { CreateErrorDialog -Error "Corrupted JSON" -Exit }
    }
    else { CreateErrorDialog -Error "Corrupted JSON" }



    #################
    # Custom Header #
    #################

    # Create the panel that holds the Custom Header.
    $Global:CustomHeaderPanel = CreatePanel -Width 590 -Height 50 -AddTo $MainDialog

    # Create the groupbox that holds the Custom Header.
    $CustomHeaderGroup = CreateGroupBox -Width $CustomHeaderPanel.Width -Height $CustomHeaderPanel.Height -Text "Custom Channel Title and GameID" -AddTo $CustomHeaderPanel

    # Create a label to show Custom Channel Title description.
    $Global:CustomTitleTextBoxLabel = CreateLabel -X 8 -Y 22 -Width 75 -Height 15 -Text "Channel Title:" -AddTo $CustomHeaderGroup

    # Create a textbox to display the selected Custom Channel Title.
    $Global:CustomTitleTextBox = CreateTextBox -X 85 -Y 20 -Width 260 -Height 22 -AddTo $CustomHeaderGroup
    $CustomTitleTextBox.Add_TextChanged({
        if ($this.Text -match "[^a-z 0-9 \: \- \( \) \' \&] \.") {
            $cursorPos = $this.SelectionStart
            $this.Text = $this.Text -replace "[^a-z 0-9 \: \- \( \) \' \& \.]",''
            $this.SelectionStart = $cursorPos - 1
            $this.SelectionLength = 0
        }
    })

    # Create a label to show Custom GameID description
    $CustomGameIDTextBoxLabel = CreateLabel -X 370 -Y 22 -Width 50 -Height 15 -Text "GameID:" -AddTo $CustomHeaderGroup

    # Create a textbox to display the selected Custom GameID.
    $Global:CustomGameIDTextBox = CreateTextBox -X 425 -Y 20 -Width 55 -Height 22 -Length 4 -AddTo $CustomHeaderGroup
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
    $Global:CustomHeaderCheckbox = CreateCheckBox -X 560 -Y 20 -Width 20 -Height 20 -Name "CustomHeader" -ToolTip $Tooltip -Info "Enable in order to change the Game ID and title of the ROM or WAD file" -AddTo $CustomHeaderGroup



    ###############
    # Patch Panel #
    ###############

    # Create a panel to contain everything for patches.
    $Global:PatchPanel = CreatePanel -Width 590 -Height 90 -AddTo $MainDialog 

    # Create a groupbox to show the patching buttons.
    $Global:PatchGroup = CreateGroupBox -Width $PatchPanel.Width -Height $PatchPanel.Height -AddTo $PatchPanel

    # Create patch button
    $Global:PatchButton = CreateButton -X 10 -Y 45 -Width 300 -Height 35 -Text "Patch Selected Option" -AddTo $PatchGroup
    $PatchButton.Add_Click( { MainFunction -Command $GamePatch.command -PatchedFileName $GamePatch.output } )

    # Create combobox
    $Global:PatchComboBox = CreateComboBox -X $PatchButton.Left -Y ($PatchButton.Top - 25) -Width $PatchButton.Width -Height 30 -Name "Patch" -AddTo $PatchGroup
    $PatchComboBox.Add_SelectedIndexChanged( {
        $Settings["Core"][$this.Name] = $this.SelectedIndex
        foreach ($Item in $Files.json.patches.patch) {
            if ($Item.title -eq $PatchComboBox.Text) {
                if ( ($IsWiiVC -and $Item.console -eq "Wii VC") -or (!$IsWiiVC -and $Item.console -eq "N64") -or ($Item.console -eq "All") ) {
                    $Global:GamePatch = $Item
                    $ToolTip.SetToolTip($PatchButton, ([String]::Format($Item.tooltip, [Environment]::NewLine)))
                }
            }
        }
        CreateLanguagesContent
        DisablePatches
        GetHeader
        if ($GamePatch.options -eq 1)            { $OptionsLabel.text = $GameType.mode + " - Additional Options" }
        if (IsSet -Elem $GamePatch.redux.file)   { $ReduxLabel.text = $GameType.mode + " - Redux Settings" }
    } )

    # Create a checkbox to enable Redux and Options support.
    $Global:PatchReduxLabel = CreateLabel -X ($PatchButton.Right + 10) -Y ($PatchComboBox.Top + 5) -Width 85 -Height 15 -Text "Enable Redux:" -ToolTip $ToolTip -Info "Enable the Redux patch which improves game mechanics`nIncludes among other changes the inclusion of the D-Pad for dedicated item buttons" -AddTo $PatchGroup
    $Global:PatchReduxCheckbox = CreateCheckBox -X $PatchReduxLabel.Right -Y ($PatchReduxLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Enable the Redux patch which improves game mechanics`nIncludes among other changes the inclusion of the D-Pad for dedicated item buttons" -Name "Redux" -AddTo $PatchGroup
    $PatchReduxCheckbox.Add_CheckStateChanged({
        $PatchReduxButton.Enabled = $this.Checked
    })

    $Global:PatchOptionsLabel = CreateLabel -X ($PatchButton.Right + 10) -Y ($PatchReduxLabel.Bottom + 15) -Width 85 -Height 15 -Text "Enable Options:" -ToolTip $ToolTip -Info "Enable options in order to apply a customizable set of features and changes" -AddTo $PatchGroup
    $Global:PatchOptionsCheckbox = CreateCheckBox -X $PatchOptionsLabel.Right -Y ($PatchOptionsLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Enable options in order to apply a customizable set of features and changes" -Name "Options" -AddTo $PatchGroup
    $PatchOptionsCheckbox.Add_CheckStateChanged({
        $PatchOptionsButton.Enabled = $this.Checked
        $Languages.TextBox.Enabled = $this.Checked -and $Languages[0].Checked
    })

    $Global:PatchReduxButton = CreateButton -X ($PatchReduxCheckbox.Right + 5) -Y 20 -Width 70 -Height 25 -Text "Redux" -ToolTip $ToolTip -Info 'Open the "Redux" panel to change the settings for the Redux patch' -AddTo $PatchGroup
    $PatchReduxButton.Add_Click( { $ReduxDialog.ShowDialog() } )
    $PatchReduxButton.Enabled = $False

    $Global:PatchLanguagesButton = CreateButton -X ($PatchReduxButton.Right + 5) -Y 20 -Width 70 -Height 25 -Text "Language" -ToolTip $ToolTip -Info 'Open the "Languages" panel to change the language' -AddTo $PatchGroup
    $PatchLanguagesButton.Add_Click( { $LanguagesDialog.ShowDialog() } )

    $Global:PatchOptionsButton = CreateButton -X $PatchReduxButton.Left -Y ($PatchReduxButton.Bottom + 5) -Width 145 -Height $PatchLanguagesButton.Height -Text "Select Options" -ToolTip $ToolTip -Info 'Open the "Additional Options" panel to change preferences' -AddTo $PatchGroup
    $PatchOptionsButton.Add_Click( { $OptionsDialog.ShowDialog() } )
    $PatchOptionsButton.Enabled = $False



    ####################
    # Patch VC Options #
    ####################

    # Create a panel to show the patch options.
    $Global:PatchVCPanel = CreatePanel -Width 590 -Height 105 -AddTo $MainDialog

    # Create a groupbox to show the patch options.
    $Global:PatchVCGroup = CreateGroupBox -Width $PatchVCPanel.Width -Height $PatchVCPanel.Height -Text "Virtual Console - Patch Options" -AddTo $PatchVCPanel



    # Create a label for Core patches
    $Global:PatchVCCoreLabel = CreateLabel -X 10 -Y 22 -Width 50 -Height 15 -Text "Core" -Font $VCPatchFont -AddTo $PatchVCGroup

    # Remove T64 description
    $Global:PatchVCRemoveT64Label = CreateLabel -X ($PatchVCCoreLabel.Right + 20) -Y $PatchVCCoreLabel.Top -Width 95 -Height 15 -Text "Remove All T64:" -ToolTip $ToolTip -Info "Remove all injected T64 format textures" -AddTo $PatchVCGroup
    $Global:PatchVCRemoveT64 = CreateCheckBox -X $PatchVCRemoveT64Label.Right -Y ($PatchVCCoreLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Remove all injected T64 format textures" -Name "RemoveT64" -AddTo $PatchVCGroup
    $PatchVCRemoveT64.Add_CheckStateChanged({ CheckVCOptions })
    
    # Expand Memory
    $Global:PatchVCExpandMemoryLabel = CreateLabel -X ($PatchVCRemoveT64.Right + 10) -Y $PatchVCCoreLabel.Top -Width 95 -Height 15 -Text "Expand Memory:" -ToolTip $ToolTip -Info "Expand the game's memory by 4MB" -AddTo $PatchVCGroup
    $Global:PatchVCExpandMemory = CreateCheckBox -X $PatchVCExpandMemoryLabel.Right -Y ($PatchVCCoreLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Expand the game's memory by 4MB" -Name "ExpandMemory" -AddTo $PatchVCGroup
    $PatchVCExpandMemory.Add_CheckStateChanged({ CheckVCOptions })

    # Remove Filter
    $Global:PatchVCRemoveFilterLabel = CreateLabel -X ($PatchVCRemoveT64.Right + 10) -Y $PatchVCCoreLabel.Top -Width 95 -Height 15 -Text "Remove Filter:" -ToolTip $ToolTip -Info "Remove the dark overlay filter" -AddTo $PatchVCGroup
    $Global:PatchVCRemoveFilter = CreateCheckBox -X $PatchVCRemoveFilterLabel.Right -Y ($PatchVCCoreLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Remove the dark overlay filter" -Name "RemoveFilter" -AddTo $PatchVCGroup
    $PatchVCRemoveFilter.Add_CheckStateChanged({ CheckVCOptions })

    # Remap D-Pad
    $Global:PatchVCRemapDPadLabel = CreateLabel -X ($PatchVCExpandMemory.Right + 10) -Y $PatchVCCoreLabel.Top -Width 95 -Height 15 -Text "Remap D-Pad:" -ToolTip $ToolTip -Info "Remap the D-Pad to the actual four D-Pad directional buttons instead of toggling the minimap" -AddTo $PatchVCGroup
    $Global:PatchVCRemapDPad = CreateCheckBox -X $PatchVCRemapDPadLabel.Right -Y ($PatchVCCoreLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Remap the D-Pad to the actual four D-Pad directional buttons instead of toggling the minimap" -Name "RemapDPad" -AddTo $PatchVCGroup
    $PatchVCRemapDPad.Add_CheckStateChanged({ CheckVCOptions })

    # Downgrade
    $Global:PatchVCDowngradeLabel = CreateLabel -X ($PatchVCRemapDPad.Right + 10) -Y $PatchVCCoreLabel.Top -Width 95 -Height 15 -Text "Downgrade:" -ToolTip $ToolTip -Info "Downgrade Ocarina of Time from version 1.2 US to 1.0 US" -AddTo $PatchVCGroup
    $Global:PatchVCDowngrade = CreateCheckBox -X $PatchVCDowngradeLabel.Right -Y ($PatchVCCoreLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Downgrade Ocarina of Time from version 1.2 US to 1.0 US" -Name "Downgrade" -AddTo $PatchVCGroup
    $PatchVCDowngrade.Add_CheckStateChanged({ CheckVCOptions })



    # Create a label for Minimap
    $Global:PatchVCMinimapLabel = CreateLabel -X 10 -Y ($PatchVCCoreLabel.Bottom + 5) -Width 50 -Height 15 -Text "Minimap" -Font $VCPatchFont -AddTo $PatchVCGroup

    # Remap C-Down
    $Global:PatchVCRemapCDownLabel = CreateLabel -X ($PatchVCMinimapLabel.Right + 20) -Y $PatchVCMinimapLabel.Top -Width 95 -Height 15 -Text "Remap C-Down:" -ToolTip $ToolTip -Info "Remap the C-Down button for toggling the minimap instead of using an item" -AddTo $PatchVCGroup
    $Global:PatchVCRemapCDown = CreateCheckBox -X $PatchVCRemapCDownLabel.Right -Y ($PatchVCMinimapLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Remap the C-Down button for toggling the minimap instead of using an item" -Name "RemapCDown" -AddTo $PatchVCGroup
    $PatchVCRemapCDown.Add_CheckStateChanged({ CheckVCOptions })

    # Remap Z
    $Global:PatchVCRemapZLabel = CreateLabel -X ($PatchVCRemapCDown.Right + 10) -Y $PatchVCMinimapLabel.Top -Width 95 -Height 15 -Text "Remap Z:" -ToolTip $ToolTip -Info "Remap the Z (GameCube) or ZL and ZR (Classic) buttons for toggling the minimap instead of using an item" -AddTo $PatchVCGroup
    $Global:PatchVCRemapZ = CreateCheckBox -X $PatchVCRemapZLabel.Right -Y ($PatchVCMinimapLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Remap the Z (GameCube) or ZL and ZR (Classic) buttons for toggling the minimap instead of using an item" -Name "RemapZ" -AddTo $PatchVCGroup
    $PatchVCRemapZ.Add_CheckStateChanged({ CheckVCOptions })

    # Leave D-Pad Up
    $Global:PatchVCLeaveDPadUpLabel = CreateLabel -X ($PatchVCRemapZ.Right + 10) -Y $PatchVCMinimapLabel.Top -Width 95 -Height 15 -Text "Leave D-Pad Up:" -ToolTip $ToolTip -Info "Leave the D-Pad untouched so it can be used to toggle the minimap" -AddTo $PatchVCGroup
    $Global:PatchVCLeaveDPadUp = CreateCheckBox -X $PatchVCLeaveDPadUpLabel.Right -Y ($PatchVCMinimapLabel.Top - 2) -Width 20 -Height 20 -ToolTip $ToolTip -Info "Leave the D-Pad untouched so it can be used to toggle the minimap" -Name "LeaveDPadUp" -AddTo $PatchVCGroup
    $PatchVCLeaveDPadUp.Add_CheckStateChanged({ CheckVCOptions })



    # Create a label for Patch VC Buttons
    $Global:ActionsLabel = CreateLabel -X 10 -Y 72 -Width 50 -Height 15 -Text "Actions" -Font $VCPatchFont -AddTo $PatchVCGroup

    # Create a button to patch the VC
    $Global:PatchVCButton = CreateButton -X 80 -Y 65 -Width 150 -Height 30 -Text "Patch VC Emulator Only" -ToolTip $ToolTip -Info "Ignore any patches and only patches the Virtual Console emulator`nDowngrading and channing the Channel Title or GameID is still accepted" -AddTo $PatchVCGroup
    $PatchVCButton.Add_Click({ MainFunction -Command "Patch VC" -PatchedFileName "_vc_patched" })

    # Create a button to extract the ROM
    $Global:ExtractROMButton = CreateButton -X 240 -Y 65 -Width 150 -Height 30 -Text "Extract ROM Only" -ToolTip $ToolTip -Info "Only extract the .Z64 ROM from the WAD file`nUseful for native N64 emulators" -AddTo $PatchVCGroup
    $ExtractROMButton.Add_Click({ MainFunction -Command "Extract" -PatchedFileName "_extracted" })



    ##############
    # Misc Panel #
    ##############

    # Create a panel to contain everything for other.
    $Global:MiscPanel = CreatePanel -Width 590 -Height 75 -AddTo $MainDialog

    # Create a groupbox to show the misc buttons.
    $Global:MiscGroup = CreateGroupBox -Width ($MiscPanel.Width - 5) -Height $MiscPanel.Height -Text "Other Buttons" -AddTo $MiscPanel

    # Create a button to show information about the patches.
    $CreditsButton = CreateButton -X 10 -Y 25 -Width 180 -Height 35 -Text "Info / Credits" -ToolTip $ToolTip -Info ("Open the list with credits and info of all of patches involved and those who helped with the " + $ScriptName) -AddTo $MiscGroup
    $CreditsButton.Add_Click({ $CreditsDialog.ShowDialog() | Out-Null })

    # Create a button to show the global settings panel
    $SettingsButton = CreateButton ($CreditsButton.Right + 10) -Y $CreditsButton.Top -Width $CreditsButton.Width -Height $CreditsButton.Height -Text "Settings" -ToolTip $ToolTip -Info "Open the global settings panel" -AddTo $MiscGroup
    $SettingsButton.Add_Click({ $SettingsDialog.ShowDialog() | Out-Null })

    # Create a button to close the dialog.
    $Global:ExitButton = CreateButton -X ($SettingsButton.Right + 10) -Y $CreditsButton.Top -Width $CreditsButton.Width -Height $CreditsButton.Height -Text "Exit" -ToolTip $ToolTip -Info ("Save all settings and close the " + $ScriptName) -AddTo $MiscGroup
    $ExitButton.Add_Click({ $MainDialog.Close() })



    ##############
    # Misc Panel #
    ##############

    $Global:StatusPanel = CreatePanel -Width 625 -Height 30 -AddTo $MainDialog
    $Global:StatusGroup = CreateGroupBox -Width 590 -Height 30 -AddTo $StatusPanel
    $Global:StatusLabel = Createlabel -X 8 -Y 10 -Width 570 -Height 15 -AddTo $StatusGroup



    ###############
    # Positioning #
    ###############

    $InputWADPanel.Location = New-Object System.Drawing.Size(10, 50)
    $InputROMPanel.Location = New-Object System.Drawing.Size(10, ($InputWADPanel.Bottom + 5))
    $InputBPSPanel.Location = New-Object System.Drawing.Size(10, ($InputROMPanel.Bottom + 5))
    $CurrentGamePanel.Location = New-Object System.Drawing.Size(10, ($InputBPSPanel.Bottom + 5))
    $CustomHeaderPanel.Location = New-Object System.Drawing.Size(10, ($CurrentGamePanel.Bottom + 5))
    $PatchPanel.Location = New-Object System.Drawing.Size(10, ($CustomHeaderPanel.Bottom + 5))

}



#==============================================================================================================================================================================================
function ResetTool() {
    
    $InputWADTextBox.Text = "Select or drag and drop your Virtual Console WAD file..."
    $InputROMTextBox.Text = "Select or drag and drop your Z64, N64 or V64 ROM..."
    $InputBPSTextBox.Text = "Select or drag and drop your BPS, IPS, Xdelta or VCDiff Patch File..."

    RemoveFile -LiteralPath ($Paths.Base + "\Settings.ini")
    GetSettings

    $PatchVCRemoveT64.Checked = $PatchVCExpandMemory.Checked = $PatchVCRemoveFilter.Checked = $PatchVCRemapDPad.Checked = $PatchVCDowngrade.Checked = $PatchVCRemapCDown.Checked = $PatchVCRemapZ.Checked = $PatchVCLeaveDPadUp.Checked = $False
    $PatchReduxCheckbox.Checked = $PatchOptionsCheckbox.Checked = $CustomHeaderCheckbox.Checked = $False
    $CurrentGameComboBox.SelectedIndex = $PatchComboBox.SelectedIndex =  0
    $InjectROMButton.Enabled = $PatchBPSButton.Enabled = $False
    
    RestoreCustomHeader
    ChangeGameMode
    SetWiiVCMode -Enable $False
    EnablePatchButtons -Enable $False

}



#==============================================================================================================================================================================================
function CheckVCOptions() {
    
    if (!$IsWiiVC) { return }

    if (IsChecked -Elem $PatchVCRemoveT64)          { $PatchVCButton.Enabled = $True }
    elseif (IsChecked -Elem $PatchVCExpandMemory)   { $PatchVCButton.Enabled = $True }
    elseif (IsChecked -Elem $PatchVCRemoveFilter)   { $PatchVCButton.Enabled = $True }
    elseif (IsChecked -Elem $PatchVCRemapDPad)      { $PatchVCButton.Enabled = $True }
    elseif (IsChecked -Elem $PatchVCDowngrade)      { $PatchVCButton.Enabled = $True }
    elseif (IsChecked -Elem $PatchVCRemapCDown)     { $PatchVCButton.Enabled = $True }
    elseif (IsChecked -Elem $PatchVCRemapZ)         { $PatchVCButton.Enabled = $True }
    elseif (IsChecked -Elem $PatchLeaveDPadUp)      { $PatchVCButton.Enabled = $True }
    else                                            { $PatchVCButton.Enabled = $False }

}



#==============================================================================================================================================================================================
function DisablePatches() {
    
    $PatchReduxCheckbox.Visible = $PatchReduxLabel.Visible = $PatchReduxButton.Visible = (IsSet -Elem $GamePatch.redux.file)
    $PatchReduxButton.Enabled = (IsSet -Elem $GamePatch.redux.file) -and $PatchReduxCheckbox.Checked

    $PatchOptionsCheckbox.Visible = $PatchOptionsLabel.Visible = $PatchOptionsButton.Visible = $GamePatch.options
    $PatchOptionsButton.Enabled = $GamePatch.options -and $PatchOptionsCheckbox.Checked
    
    $PatchLanguagesButton.Enabled = $PatchLanguagesButton.Visible = (IsSet -Elem $GamePatch.languages)
    $Languages.TextBox.Enabled = $PatchOptionsCheckbox.Checked -and $Languages[0].Checked -and (IsSet -Elem $GamePatch.languages -MinLength 1)

    $PatchVCRemoveFilterLabel.Enabled = $PatchVCRemoveFilter.Enabled = !(StrLike -str $GamePatch.command -val "Patch Boot DOL")

}



#==============================================================================================================================================================================================
function CreateLanguagesContent() {
    
    $Languages.Box.Text = $GameType.mode + " - Languages"
    $PatchLanguagesButton.Visible = $GamePatch.languages -ne $null
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
        $TextPanel                        = CreateReduxPanel                 -Row 0 -AddTo $Languages.TextBox
        $Languages.TextSpeed1x            = CreateReduxRadioButton -Column 0 -Row 0 -AddTo $TextPanel -Checked -Text "1x Text Speed"           -ToolTip $ToolTip -Info "Leave the dialogue text speed at normal"               -Name "TextSpeed1x"
        $Languages.TextSpeed2x            = CreateReduxRadioButton -Column 1 -Row 0 -AddTo $TextPanel          -Text "2x Text Speed"           -ToolTip $ToolTip -Info "Set the dialogue text speed to be twice as fast"       -Name "TextSpeed2x"
        $Languages.TextSpeed3x            = CreateReduxRadioButton -Column 2 -Row 0 -AddTo $TextPanel          -Text "3x Text Speed"           -ToolTip $ToolTip -Info "Set the dialogue text speed to be three times as fast" -Name "TextSpeed3x"
        $Languages.TextRestore            = CreateReduxCheckBox    -Column 0 -Row 2 -AddTo $Languages.TextBox  -Text "Restore Text"            -ToolTip $ToolTip -Info "Restores the text used from the GC revision and applies grammar and typo fixes" -Name "TextRestore"
        $Languages.TextFemalePronouns     = CreateReduxCheckBox    -Column 1 -Row 2 -AddTo $Languages.TextBox  -Text "Female Pronouns"         -ToolTip $ToolTip -Info "Refer to Link as a female character`n- Requires the Restore Text option" -Name "TextFemalePronouns"
        $Languages.TextDialogueColors     = CreateReduxCheckBox    -Column 2 -Row 2 -AddTo $Languages.TextBox  -Text "GC Text Dialogue Colors" -ToolTip $ToolTip -Info "Set the Text Dialogue Colors to match the GameCube's color scheme" -Name "TextDialogueColors"
        $Languages.TextUnisizeTunics      = CreateReduxCheckBox    -Column 0 -Row 3 -AddTo $Languages.TextBox  -Text "Unisize Tunics"          -ToolTip $ToolTip -Info "Adjust the dialogue to mention that the Goron Tunic and Zora Tunic are unisize`n- Useful for the Unlock Tunics option" -Name "TextUnisizeTunics"

        $Languages.TextFemalePronouns.Enabled = $Languages.TextRestore.Checked
        $Languages.TextRestore.Add_CheckedChanged({ $Languages.TextFemalePronouns.Enabled = $this.checked })
    }

    elseif ($GameType.mode -eq "Majora's Mask") {
        $Languages.TextRestore            = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $Languages.TextBox -Text "Restore Text"          -ToolTip $ToolTip -Info "Restores and fixes the following:`n- Restore the area titles cards for those that do not have any`n- Sound effects that do not play during dialogue`n- Grammar and typo fixes" -Name "TextRestore"
        $Languages.CorrectCircusMask      = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $Languages.TextBox -Text "Correct Circus Mask"   -ToolTip $ToolTip -Info "Change the Circus Leader's Mask to Troupe Leader's Mask and all references to it" -Name "CorrectCircusMask"
        $Languages.TextRazorSword         = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $Languages.TextBox -Text "Permanent Razor Sword" -ToolTip $ToolTip -Info "Refer the Razor Sword as no longer being breakable" -Name "TextRazorSword"
    }

    if (IsSet -Elem $GamePatch.languages -MinLength 0) {
        $Languages.TextBox.Enabled = $Languages[0].Checked
        $Languages[0].Add_CheckedChanged({ $Languages.TextBox.Enabled = $this.checked -and $PatchOptionsCheckbox.Checked })
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
function Z64Path_Button([Object]$TextBox, [string[]]$Description, [string[]]$FileName) {
        # Allow the user to select a file.
    $SelectedPath = Get-FileName -Path $Paths.Base -Description $Description -FileName $FileName

    # Make sure the path is not blank and also test that the path exists.
    if (($SelectedPath -ne '') -and (TestPath -LiteralPath $SelectedPath)) {
        # Finish everything up.
        $Settings["Core"][$this.name] = $SelectedPath
        Z64Path_Finish -TextBox $TextBox -VarName $this.Name -Z64Path $SelectedPath
    }

}



#==================================================================================================================================================================================================================================================================
function BPSPath_Button([Object]$TextBox, [string[]]$Description, [string[]]$FileName) {
        # Allow the user to select a file.
    $SelectedPath = Get-FileName -Path $Paths.Base -Description $Description -FileName $FileName

    # Make sure the path is not blank and also test that the path exists.
    if (($SelectedPath -ne '') -and (TestPath -LiteralPath $SelectedPath)) {
        # Finish everything up.
        $Settings["Core"][$this.name] = $SelectedPath
        BPSPath_Finish -TextBox $TextBox -VarName $this.Name -BPSPath $SelectedPath
    }

}



#==================================================================================================================================================================================================================================================================
function WADPath_DragDrop() {
    
    # Check for drag and drop data.
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        # Get the first item in the list.
        $DroppedPath = [String]($_.Data.GetData([Windows.Forms.DataFormats]::FileDrop))
        
        # See if the dropped item is a file.
        if (Test-Path -LiteralPath $DroppedPath -PathType Leaf) {
            # Get the extension of the dropped file.
            $DroppedExtn = (Get-Item -LiteralPath $DroppedPath).Extension

            # Make sure it is a WAD file.
            if ($DroppedExtn -eq '.wad') {
                # Finish everything up.
                $Settings["Core"][$this.name] = $DroppedPath
                WADPath_Finish -TextBox $InputWADTextBox -VarName $this.Name -WADPath $DroppedPath
            }
        }
    }

}



#==================================================================================================================================================================================================================================================================
function Z64Path_DragDrop() {
    
    # Check for drag and drop data.
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        # Get the first item in the list.
        $DroppedPath = [String]($_.Data.GetData([Windows.Forms.DataFormats]::FileDrop))
        
        # See if the dropped item is a file.
        if (Test-Path -LiteralPath $DroppedPath -PathType Leaf) {
            # Get the extension of the dropped file.
            $DroppedExtn = (Get-Item -LiteralPath $DroppedPath).Extension

            # Make sure it is a Z64 ROM.
            if ($DroppedExtn -eq '.z64' -or $DroppedExtn -eq '.n64' -or $DroppedExtn -eq '.v64') {
                # Finish everything up.
                $Settings["Core"][$this.name] = $DroppedPath
                Z64Path_Finish -TextBox $InputROMTextBox -VarName $this.Name -Z64Path $DroppedPath
            }
        }
    }

}



#==================================================================================================================================================================================================================================================================
function BPSPath_DragDrop() {
    
    # Check for drag and drop data.
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        # Get the first item in the list.
        $DroppedPath = [String]($_.Data.GetData([Windows.Forms.DataFormats]::FileDrop))
        
        # See if the dropped item is a file.
        if (Test-Path -LiteralPath $DroppedPath -PathType Leaf) {
            # Get the extension of the dropped file.
            $DroppedExtn = (Get-Item -LiteralPath $DroppedPath).Extension

            # Make sure it is a BPS File.
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