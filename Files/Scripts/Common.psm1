function SetWiiVCMode([boolean]$Enable=!$IsWiiVC) {
    
    if ($Enable -eq $IsWiiVC) { return }

    WriteToConsole "Changing Between Wii VC Mode..."

    $global:IsWiiVC = $Enable
    if ($Enable) { $png = $Files.icon.WiiEnabled } else { $png = $Files.icon.WiiDisabled }
    SetBitmap -Path $png -Box $Patches.WiiButton

    if ($RightPanel.RemapControls.Visible) {
        if ($RightPanel.Options.Controls.ContainsKey("OptionsPanel")) { ShowRightPanel $RightPanel.Options } else { ShowRightPanel $RightPanel.Settings }
    }

    if ( ($GamePatch.console -eq "Native" -and $IsWiiVC) -or ($GamePatch.console -eq "Wii VC" -and !$IsWiiVC) ) {
        if ($GameType.patches -eq 2) { ChangePatchList }
        ChangePatch
    }

    SetVCContent
    if ( (TestFile $GameFiles.controls) -and $GameSettings -ne $null -and $IsWiiVC) { CreateVCRemapPanel }
    SetModeLabel
    HideNativeOptions
    EnablePatchButtons
    SetMainScreenSize

}



#==================================================================================================================================================================================================================================================================
function CreateToolTip($Form, $Info) {

    # Create ToolTip
    $ToolTip              = New-Object System.Windows.Forms.ToolTip
    $ToolTip.AutoPopDelay = 32767
    $ToolTip.InitialDelay = 500
    $ToolTip.ReshowDelay  = 0
    $ToolTip.ShowAlways   = $True
    if ( (IsSet $Form) -and (IsSet $Info) ) { $ToolTip.SetToolTip($Form, $Info) }
    return $ToolTip

}



#==============================================================================================================================================================================================
function ChangeConsolesList() {
    
    WriteToConsole "Loading consoles..."

    # Reset
    $CurrentGame.Console.Items.Clear()
    $Items = $Files.json.consoles.title
    $CurrentGame.Console.Items.AddRange($Items)

    # Reset last index
    foreach ($i in 0..($Items.length-1)) {
        if ($GameConsole.title -eq $Items[$i]) {
            $CurrentGame.Console.SelectedIndex = $i
            break
        }
    }

    if ($Items.Length -gt 0 -and $CurrentGame.Console.SelectedIndex -eq -1) {
        try     { $CurrentGame.Console.SelectedIndex = $Settings["Core"][$CurrentGame.Console.Name] }
        catch   { $CurrentGame.Console.SelectedIndex = 0 }
    }

}



#==============================================================================================================================================================================================
function ChangeGamesList() {
    
    WriteToConsole "Loading games..."

    # Set console
    foreach ($item in $Files.json.consoles) {
        if ($item.title -eq $CurrentGame.Console.Text) {
            $global:GameConsole = $item
            break
        }
    }

    # Reset
    $CurrentGame.Game.Items.Clear()
    if (!$IsWiiVC) { $CustomHeader.ROMTitle.MaxLength = $GameConsole.rom_title_length }

    $items = @()
    foreach ($item in $Files.json.games) {
        if ( ($CurrentGame.Console.Text -eq $GameConsole.title -and $GameConsole.mode -contains $item.console) -or $item.console -contains "All") { $items += $item.title }
    }

    $CurrentGame.Game.Items.AddRange($items)

    # Reset last index
    foreach ($i in 0..($Items.Length-1)) {
        if ($GameType.title -eq $items[$i]) {
            $CurrentGame.Game.SelectedIndex = $i
            break
        }
    }

    if ($items.Length -gt 0 -and $CurrentGame.Game.SelectedIndex -eq -1) {
        try { $CurrentGame.Game.SelectedIndex = $Settings["Core"][$CurrentGame.Game.Name] }
        catch { $CurrentGame.Game.SelectedIndex = 0 }
    }

}



#==============================================================================================================================================================================================
function ChangePatchList() {
    
    $Patches.Panel.Visible = $GameType.patches -gt 0
    if ($GameType.patches -gt 0) {
        WriteToConsole "Loading patches..."

        # Reset
        $Patches.Group.Text = $GameType.mode + " - Patch Options"
        $Patches.Type.Items.Clear()
        $Patches.Type.Items.AddRange(($Files.json.patches.title | Get-Unique))

        # Remove items when in patch mode 2
        if ($GameType.patches -eq 2) {
            foreach ($item in $Files.json.patches) {
                if ( (!$IsWiiVC -and $item.console -eq "Wii VC") -or ($IsWiiVC -and $item.console -eq "Native") ) { $Patches.Type.Items.Remove($item.title) }
            }
        }

        # Reset last index
        foreach ($index in $Patches.Type.Items) {
            foreach ($item in $Files.json.patches) {
                if ($item.title -eq $GamePatch.title -and $item.title -eq $index) {
                    $Patches.Type.Text = $index
                    break
                }
            }
        }

        if ($InputPaths.GameTextBox.Text -notlike '*:\*') { $global:IsActiveGameField = $True }
        if ($Patches.Type.Items.Count -gt 0 -and $Patches.Type.SelectedIndex -lt 0) {
            try { $Patches.Type.SelectedIndex = $Settings["Core"][$Patches.Type.Name] }
            catch { $Patches.Type.SelectedIndex = 0 }
        }
    }

}



#==============================================================================================================================================================================================
function CheckIfScriptOrPatchExists($Item) {
    
    if (IsSet $Item.patch) {
        if (!(TestFile ($GameFiles.base + "\" + $item.patch))) { return $False }
    }
    if (IsSet $Item.script) {
        if ($Item.script -is [system.Array]) {
            foreach ($script in $Item.script) {
                if (!(TestFile ($Paths.Scripts + "\Options\" + $script + ".psm1"))) { return $False }
            }
        }
        elseif (!(TestFile ($Paths.Scripts + "\Options\" + $Item.script + ".psm1"))) { return $False }
    }
    return $True

}



#==============================================================================================================================================================================================
function SetMainScreenSize() {
    
    WriteToConsole "Changing main screen display..."

    # Show / Hide Custom Header
    if ($IsWiiVC)   { $CustomHeader.Group.Text = " Custom Channel Title and GameID " }
    else            { $CustomHeader.Group.Text = " Custom Game Title and GameID " }

    # Set Paths Panels Visibility and sizes
    if ($GameType.inject -eq 1 -and $IsWiiVC) {
        $InputPaths.InjectPanel.Visible = $True
        $InputPaths.InjectPanel.Height  = (DPISize 50)
        $InputPaths.InjectPanel.Top     = $InputPaths.GamePanel.Bottom + (DPISize 5)
    }
    else {
        $InputPaths.InjectPanel.Visible = $False
        $InputPaths.InjectPanel.Height  = 0
    }

    if ($GameType.custom_patch -eq 1) {
        $InputPaths.PatchPanel.Visible = $True;
        $InputPaths.PatchPanel.Height  = (DPISize 50)
        if ($GameType.inject -eq 1 -and $IsWiiVC)   { $InputPaths.PatchPanel.Top = $InputPaths.InjectPanel.Bottom + (DPISize 5) }
        else                                        { $InputPaths.PatchPanel.Top = $InputPaths.GamePanel.Bottom   + (DPISize 5) }
    }
    else {
        $InputPaths.PatchPanel.Visible = $False
        $InputPaths.PatchPanel.Height  = 0
    }

    # Custom Header Panel Visibility and Size
    $CustomHeader.Panel.Visible     = ($GameConsole.rom_title -gt 0) -or ($GameConsole.rom_gameID -gt 0)  -or $IsWiiVC
    $CustomHeader.ROMTitle.Visible  = $CustomHeader.ROMTitleLabel.Visible  = ($GameConsole.rom_title -gt 0)  -and !$IsWiiVC
    $CustomHeader.ROMGameID.Visible = $CustomHeader.ROMGameIDLabel.Visible = ($GameConsole.rom_gameID -eq 1) -and !$IsWiiVC
    $CustomHeader.VCTitle.Visible   = $CustomHeader.VCTitleLabel.Visible   = $CustomHeader.VCGameID.Visible     = $CustomHeader.VCGameIDLabel.Visible     = $IsWiiVC
    $CustomHeader.Region.Visible    = $CustomHeader.RegionLabel.Visible    = $CustomHeader.EnableRegion.Visible = $CustomHeader.EnableRegionLabel.Visible = ($GameConsole.rom_gameID -eq 2)

    if ($GameConsole.rom_gameID -eq 2)   { $CustomHeader.Panel.Height = (DPISize 80) }
    else                                 { $CustomHeader.Panel.Height = (DPISize 50) }
    $CustomHeader.Group.Height = $CustomHeader.Panel.Height

    $InputPaths.InjectPanel.Visible = $VC.Panel.Visible = $IsWiiVC

    # Positioning
    if ($GameType.custom_patch -eq 1)   { $CurrentGame.Panel.Top = $InputPaths.PatchPanel.Bottom + (DPISize 5) }
    else                                { $CurrentGame.Panel.Top = $InputPaths.GamePanel.Bottom  + (DPISize 5) }
    $CustomHeader.Panel.Top = $CurrentGame.Panel.Bottom + (DPISize 5)
    
    # Set VC Panel Size
    if ($GameConsole.t64 -eq 1 -or $GameConsole.expand_memory -eq 1 -or $GameConsole.remove_filter -eq 1 -or (IsSet $Files.json.controls) )   { $VC.Panel.Height = $VC.Group.Height = (DPISize 90) }
    else                                                                                                                                      { $VC.Panel.Height = $VC.Group.Height = (DPISize 70) }

    # Arrange Panels
    if ($IsWiiVC) {
        if ($GameType.patches -gt 0) {
            $Patches.Panel.Top = $CustomHeader.Panel.Bottom + (DPISize 5)
            $VC.Panel.Top      = $Patches.Panel.Bottom      + (DPISize 5)
        }
        else { $VC.Panel.Top   = $CustomHeader.Panel.Bottom + (DPISize 5) }
        $StatusPanel.Top       = $VC.Panel.Bottom           + (DPISize 5)
    }
    else {
        if ( ($GameConsole.rom_title -eq 0) -and ($GameConsole.rom_gameID -eq 0) ) {
            if ($GameType.patches) { $Patches.Panel.Top = $CurrentGame.Panel.Bottom + (DPISize 5) }
            else                   { $StatusPanel.Top   = $CurrentGame.Panel.Bottom + (DPISize 5) }
        }
        else {
            if ($GameType.patches -gt 0)   { $Patches.Panel.Top = $CustomHeader.Panel.Bottom + (DPISize 5) }
            else                           { $StatusPanel.Top   = $CustomHeader.Panel.Bottom + (DPISize 5) }
        }
        if ($GameType.patches -gt 0)       { $StatusPanel.Top   = $Patches.Panel.Bottom      + (DPISize 5) }
    }

    if ($StatusPanel.Bottom -gt ( (DPISize $Patcher.WindowHeight) - (DPISize 25) ) ) {
        $MainDialog.Height = $StatusPanel.Bottom + $MainPanel.Top + (DPISize 45)
        $MainPanel.Height  = $MainDialog.Height  - $MainPanel.Top
    }
    elseif ($StatusPanel.Bottom -lt ( (DPISize $Patcher.WindowHeight) - (DPISize 25) ) ) {
        $MainDialog.Height = DPISize $Patcher.WindowHeight
        $MainPanel.Height  = $MainDialog.Height - $MainPanel.Top
    }
    

}



#==============================================================================================================================================================================================
function SetVCContent() {
    
    # Reset VC panel visibility
    foreach ($item in $VC.Group.Controls) { EnableElem -Elem $item -Active $False -Hide }
    EnableElem -Elem @($VC.ActionsLabel, $VC.ExtractROMButton) -Active $True -Hide
    
    # Enable VC panel visiblity
    if ($IsWiiVC) {
        if ($GameConsole.t64 -eq 1)                                                { EnableElem -Elem @($VC.OptionsLabel, $VC.RemoveT64,     $VC.RemoveT64Label)                              -Active $True -Hide }
        if ($GameConsole.expand_memory -eq 1 -and $GameType.expansion_pak -ne 0)   { EnableElem -Elem @($VC.OptionsLabel, $VC.ExpandMemory,  $VC.ExpandMemoryLabel)                           -Active $True -Hide }
        if ($GameConsole.remove_filter -eq 1 -and $GameType.filter        -ne 0)   { EnableElem -Elem @($VC.OptionsLabel, $VC.RemoveFilter,  $VC.RemoveFilterLabel)                           -Active $True -Hide }
        if (IsSet $Files.json.controls)                                            { EnableElem -Elem @($VC.OptionsLabel, $VC.RemapControls, $VC.RemapControlsLabel, $VC.RemapControlsButton) -Active $True -Hide }
        $VC.RemapControlsButton.Enabled = $VC.RemapControls.checked -and $VC.RemapControls.Active
    }

}



#==============================================================================================================================================================================================
function ChangeGameMode() {
    
    ### LOADING GAME MODE ###

    WriteToConsole "Changing game mode..."

    if ($GameType -ne $null -and $MainDialog.Visible -and $Settings.Core.PerGameFile) { $Settings.Paths[$GameType.mode] = $GamePath.FullName }

    if (IsSet $GamePatch.script) {
        if ($GamePatch.script -is [system.Array]) {
            foreach ($script in $GamePatch.script) {
                if (Get-Module -Name $script) { Remove-Module -Name $script }
            }
        }
        elseif (Get-Module -Name $GamePatch.script) { Remove-Module -Name $GamePatch.script }
    }

    foreach ($item in $Files.json.games) {
        if ($item.title -eq $CurrentGame.Game.Text) {
            $global:GameType = $item
            $global:GamePatch = $null
            break
        }
    }

    if ($GameType -ne $null -and $MainDialog.Visible -and $Settings.Core.PerGameFile) {
        if     ($Settings.Paths[$GameType.mode] -ne $null)   { GamePath_Finish -TextBox $InputPaths.GameTextBox -Path $Settings.Paths[$GameType.mode] }
        elseif ($GamePath -ne $null)                         { $Settings.Paths[$GameType.mode] = $GamePath.FullName                                   }
    }

    $GameFiles.base         = $Paths.Games      + "\" + $GameType.mode
    $GameFiles.binaries     = $GameFiles.Base   + "\Binaries"
    $GameFiles.export       = $GameFiles.Base   + "\Export"
    $GameFiles.compressed   = $GameFiles.Base   + "\Compressed"
    $GameFiles.decompressed = $GameFiles.Base   + "\Decompressed"
    $GameFiles.languages    = $GameFiles.Base   + "\Languages"
    $GameFiles.banks        = $GameFiles.Base   + "\Audio Banks"
    $GameFiles.downgrade    = $GameFiles.Base   + "\Downgrade"
    $GameFiles.textures     = $GameFiles.Base   + "\Textures"
    $GameFiles.editor       = $GameFiles.Base   + "\Editor"
    $GameFiles.customText   = $GameFiles.Base   + "\Custom Text"
    $GameFiles.info         = $GameFiles.Base   + "\Info.txt"
    $GameFiles.patches      = $GameFiles.Base   + "\Patches.json"
    $GameFiles.controls     = $GameFiles.Base   + "\Controls.json"
    $GameFiles.textEditor   = $GameFiles.Base   + "\Text Editor.json"
    $GameFiles.sceneEditor  = $GameFiles.Base   + "\Scene Editor.json"
    $GameFiles.scenesPatch  = $GameFiles.editor + "\scenes.bps"

    # JSON Files
    if ($GameType.patches -gt 0) {
        $Files.json.patches = SetJSONFile $GameFiles.patches
        $Files.json.repo.addons | Where-Object { $_.type -eq "Patches" } | ForEach-Object {
            if (TestFile ($Paths.Patches + "\" + $_.title + "\" + $GameType.mode + "\Patches.json")) { $Files.json.patches += SetJSONFile ($Paths.Patches + "\" + $_.title + "\" + $GameType.mode + "\Patches.json") }
            write-host ($Paths.Patches + "\" + $_.title + "\" + $GameType.mode + "\Patches.json")
        }
    }
    else { $Files.json.patches = $null }

    # Rename patch titles to include version if present
    if ($Files.json.patches -ne $null) {
        for ($i=0; $i -lt $Files.json.patches.Length; $i++) {
            $title   = $Files.json.patches[$i].title
            $version =  $Files.json.patches[$i].version
            if ($version -ne $null) {
                $title += " ("
                if ($version -is [string] -and $version.Length -gt 0) {
                    if ($version.toLower() -ne "demo" -and $version.toLower().Substring(0, 1) -ne 'r' -and $version.toLower().Substring(0, 1) -ne 'v') { $title += 'v' }
                }
                $title += [string]$version + ")"
            }
            $Files.json.patches[$i].title = $title
        }
    }

    if (TestFile ($GameFiles.languages + "\Languages.json"))                       { $Files.json.languages   = SetJSONFile ($GameFiles.languages + "\Languages.json")   } else { $Files.json.languages   = $null }
    if (TestFile ($GameFiles.base      + "\Music.json"))                           { $Files.json.music       = SetJSONFile ($GameFiles.base      + "\Music.json")       } else { $Files.json.music       = $null }
    if (TestFile ($GameFiles.base      + "\Items.json"))                           { $Files.json.items       = SetJSONFile ($GameFiles.base      + "\Items.json")       } else { $Files.json.items       = $null }
    if (TestFile ($GameFiles.base      + "\Moves.json"))                           { $Files.json.moves       = SetJSONFile ($GameFiles.base      + "\Moves.json")       } else { $Files.json.moves       = $null }
    if (TestFile ($GameFiles.base      + "\Blocks.json"))                          { $Files.json.blocks      = SetJSONFile ($GameFiles.base      + "\Blocks.json")      } else { $Files.json.blocks      = $null }
    if (TestFile ($GameFiles.base      + "\Enemies.json"))                         { $Files.json.enemies     = SetJSONFile ($GameFiles.base      + "\Enemies.json")     } else { $Files.json.enemies     = $null }
    if (TestFile ($GameFiles.base      + "\Shop Items.json"))                      { $Files.json.shopItems   = SetJSONFile ($GameFiles.base      + "\Shop Items.json")  } else { $Files.json.shopItems   = $null }

    $Files.json.models = $null

    SetVCContent
    SetCreditsSections
    SetModeLabel
    ChangePatchList

    [System.GC]::WaitForPendingFinalizers(); [System.GC]::Collect()

}



#==============================================================================================================================================================================================
function SetCreditsSections() {
    
    if ($Credits.Info -eq $null -or $Credits.Credits -eq $null) { return }
    
    # Info
    if (TestFile $GameFiles.info)   { AddTextFileToTextbox -TextBox $Credits.Info -File $GameFiles.info }
    else                            { AddTextFileToTextbox -TextBox $Credits.Info -File $null }

    # Credits
    if (TestFile $Files.Text.credits) {
        if ($GameType.mode -ne "Free") {
            AddTextFileToTextbox -TextBox $Credits.Credits -File $Files.Text.credits -MainCredits
            AddTextFileToTextbox -TextBox $Credits.Credits -File $Files.Text.credits -GameCredits -Add
        }
        else { AddTextFileToTextbox -TextBox $Credits.Credits -File $Files.Text.credits -MainCredits }
    }

}



#==============================================================================================================================================================================================
function ChangeGameRev() {
    
    if (!(IsSet $GameType)) { return }

    if (IsSet $GameType.revision)   { $global:GameRev = $GameType.revision[0] }
    else                            { $global:GameRev = $null                 }

    if (IsSet $GamePatch.script) {
        if ($GamePatch.script -is [system.Array]) {
            foreach ($script in $GamePatch.script) {
                if (Get-Module -Name $script) { Remove-Module -Name $script }
            }
        }
        elseif (Get-Module -Name $GamePatch.script) { Remove-Module -Name $GamePatch.script }
    }

    if (IsSet $GamePatch.revision) {
        foreach ($revision in $GameType.revision) {
            if ($revision.name -eq $GamePatch.revision) {
                $global:GameRev = $revision
                break
            }
        }
    }

    if (IsSet $GameRev.Name)   { $CurrentGame.Rev.Text = $GameRev.Name }
    else                       { $CurrentGame.Rev.Text = ""            }

}



#==============================================================================================================================================================================================
function ChangePatch() {
    
    EnableGUI $False
    $lastMessage = $StatusLabel.Text
    UpdateStatusLabel "Changing patch..."

    # Reset Options
    if ($GameSettings -ne $null)                                    { OutIniFile -FilePath $GameSettingsFile -InputObject $GameSettings }
    if ($RightPanel.Options.Controls.ContainsKey("OptionsPanel"))   { $RightPanel.Options.Controls.RemoveByKey("OptionsPanel") }
    ToggleDialog -Dialog $OptionsPreviews.Dialog -Close
    $global:Redux           = @{}
    $global:OptionsPreviews = $null
    $Redux.Panels           = $Redux.Sections = $Redux.Groups = $Redux.Tabs = $Redux.NativeOptions = @()
    $Redux.Box              = @{}
    $global:GameSettings    = $global:GameSettingsFile = $null

    if ($GamePatch.script -ne $null) {
        if ($GamePatch.script -is [system.Array]) {
            foreach ($script in $GamePatch.script) {
                if (Get-Module -Name $script) { Remove-Module -Name $script }
            }
        }
        elseif (Get-Module -Name $GamePatch.script) { Remove-Module -Name $GamePatch.script }
    }

    $global:GamePatch = @{}
    if (!$IsWiiVC) { $Gamepatch.Console = "Wii VC" } else { $Gamepatch.Console = "Native" }

    foreach ($item in $Files.json.patches) {
        if ($item.title -eq $Patches.Type.Text -and ( ($IsWiiVC -and $item.console -eq "Wii VC") -or (!$IsWiiVC -and $item.console -eq "Native") -or ($item.console -eq "Both") -or !(IsSet $item.console) ) ) {
            if ( ($item.console -eq "Native" -and $IsWiiVC) -or ($item.console -eq "Wii VC" -and !$IsWiiVC) ) { continue }

            $global:GamePatch = $item

            if ($item.tooltip -ne $null) {
                $info = $item.tooltip
                if     ($item.version -ne $null -or $item.redux.version -ne $null)   { $info += "{0}"                                          }
                if     ($item.version                                   -ne $null)   { $info += "{0}Patch version: "    + $item.version        }
                if     ($item.redux.version                             -ne $null)   { $info += "{0}Redux version: "    + $item.redux.version  }
                elseif ($item.reborn.version                            -ne $null)   { $info += "{0}Reborn version: "   + $item.reborn.version }
                if     ($item.credits                                   -ne $null)   { $info += "{0}{0}Patch made by: " + $item.credits        }
                $PatchToolTip.SetToolTip($Patches.Button, ([string]::Format($info, [Environment]::NewLine)))
            }
            else { $PatchToolTip.RemoveAll() }

            GetHeader
            GetRegion

            if (IsSet $item.redux) {
                $Patches.ReduxLabel.Text = "Enable Redux:"
                $info                    = "Enable the Redux patch which improves game mechanics"
            }
            elseif (IsSet $item.reborn) {
                $Patches.ReduxLabel.Text = "Enable Reborn:"
                $info                    = "Enable the Reborn patch which improves game mechanics"
            }

            if     ($item.redux.tooltip  -ne $null)   { $info += "{0}"                    + $item.redux.tooltip  }
            elseif ($item.reborn.tooltip -ne $null)   { $info += "{0}"                    + $item.reborn.tooltip }
            if     ($item.redux.version  -ne $null)   { $info += "{0}{0}Redux version: "  + $item.redux.version  }
            elseif ($item.reborn.version -ne $null)   { $info += "{0}{0}Reborn version: " + $item.reborn.version }

            $ReduxToolTip.SetToolTip($Patches.ReduxLabel, ([string]::Format($info, [Environment]::NewLine)))
            $ReduxToolTip.SetToolTip($Patches.Redux,      ([string]::Format($info, [Environment]::NewLine)))
            
            if ( (IsSet $GamePatch.script) -or (TestFile $GameFiles.controls) ) {
                $global:GameSettingsFile = GetGameSettingsFile
                $global:GameSettings     = GetSettings $GameSettingsFile
            }

            $CustomHeader.ROMTitle.Refresh()
            $CustomHeader.ROMGameID.Refresh()
            $CustomHeader.VCTitle.Refresh()
            $CustomHeader.VCGameID.Refresh()

            $global:GamePatch.PSObject.Properties.Remove('LoadedModelsList')
            $global:GamePatch.PSObject.Properties.Remove('LoadedModel')
            $global:GamePatch | Add-Member -MemberType NoteProperty -Name "LoadedModelsList" -Value @{}
            $global:GamePatch | Add-Member -MemberType NoteProperty -Name "LoadedModel"      -Value @{}
            if ($GamePatch.dma_shift -eq $null) { $global:GamePatch | Add-Member -MemberType NoteProperty -Name "dma_shift" -Value 0 }

            ChangeGameRev
            SetGameScript
                
            # If the patch is a preset disable all options buttons
            if (IsSet $GamePatch.preset) {
                EnableElem -Elem @($Patches.Extend, $Patches.ExtendLabel, $Patches.Redux, $Patches.ReduxLabel, $Patches.Options, $Patches.OptionsLabel, $Patches.PreviewButton, $Redux.WindowPanel) -Active $False -Hide
                foreach ($item in $Redux.Groups) {
                    if ($item.IsRedux) { EnableElem -Elem $item -Active $True }
                }
            }
            else { # Patches with additional options when available
                # Disable boxes if needed
                EnableElem -Elem @($Patches.Extend,  $Patches.ExtendLabel)  -Active   (IsSet $GamePatch.allow_extend)                          -Hide
                EnableElem -Elem @($Patches.Redux,   $Patches.ReduxLabel)   -Active ( (IsSet $GamePatch.redux) -or (IsSet $GamePatch.reborn) ) -Hide
                EnableElem -Elem @($Patches.Options, $Patches.OptionsLabel) -Active   (IsSet $GamePatch.script)                                -Hide
                EnableElem -Elem $Redux.WindowPanel                         -Active          $Patches.Options.Checked
                DisableReduxOptions
                if (HasCommand "CreateOptionsPreviews") { EnableElem -Elem $Patches.PreviewButton -Active $True -Hide } else { EnableElem -Elem $Patches.PreviewButton -Active $False -Hide }
            }

            # Create VC controls panel
            if ($RightPanel.RemapControls.Controls.ContainsKey("RemapVCControlsPanel")) { $RightPanel.RemapControls.Controls.RemoveByKey("RemapVCControlsPanel") }
            if ( (TestFile $GameFiles.controls) -and $GameSettings -ne $null) {
                $Files.json.controls = SetJSONFile $GameFiles.controls
                if ($IsWiiVC) { CreateVCRemapPanel } # Create VC remap settings
            }
            else {
                $Files.json.controls  = $null
                if ($RightPanel.RemapControls.Visible) { ShowRightPanel $RightPanel.Options }
            }

            break
        }
    }

    EnableGUI $True
    EnablePatchButtons
    [System.GC]::WaitForPendingFinalizers(); [System.GC]::Collect()

}



#==============================================================================================================================================================================================
function SetGameScript() {

    if (IsSet $GamePatch.script) {
        if ($GamePatch.script -is [system.Array]) {
            foreach ($script in $GamePatch.script) {
                if (Get-Module -Name $script) { Remove-Module -Name $script }
                $file = $Paths.Scripts + "\Options\" + $script + ".psm1"
                if (TestFile $file) { Import-Module -Name $file -Global }
            }
        }
        else {
            if (Get-Module -Name $GamePatch.script) { Remove-Module -Name $GamePatch.script }
            $file = $Paths.Scripts + "\Options\" + $GamePatch.script + ".psm1"
            if (TestFile $file) { Import-Module -Name $file -Global }
        }
        if (HasCommand "CreateOptions") {
            CreateOptions
            if (Get-Command "AdjustGUI" -errorAction SilentlyContinue) { iex "AdjustGUI" } # Lock GUI if needed
        }
    }

}



#==============================================================================================================================================================================================
function UpdateStatusLabel([string]$Text, [switch]$Error, [switch]$NoConsole) {
    
    if (!$NoConsole) {
        if ($Error)   { WriteToConsole -Text $Text -Error }
        else          { WriteToConsole -Text $Text        }
    }

    if ($TextEditor.Dialog -eq $null -and $SceneEditor.Dialog -eq $null) {
        $StatusLabel.Text = $Text
        $StatusLabel.Refresh()
    }
    elseif ($TextEditor.Dialog -ne $null) {
        $TextEditor.StatusLabel.Text = $Text
        $TextEditor.StatusLabel.Refresh()
    }
    elseif ($SceneEditor.Dialog -ne $null) {
        $SceneEditor.StatusLabel.Text = $Text
        $SceneEditor.StatusLabel.Refresh()
    }

}



#==============================================================================================================================================================================================
function WriteToConsole([string]$Text, [switch]$Error) {
    
    if ($ExternalScript) {
        if ($Error)   { Write-Host $Text -ForegroundColor "Red" }
        else          { Write-Host $Text }
    }
    if ($Settings.Debug.Logging  -and !$ExternalScript) {
        if (!(TestFile -Path $Paths.Logs -Container)) { CreatePath $Paths.Logs }
        Add-Content -LiteralPath ($Paths.Logs + "\" + $TranscriptTime + ".log") -Value $Text
    }
    elseif (!$Settings.Debug.Logging -and !$ExternalScript) { $global:ConsoleHistory += $Text }

}



#==============================================================================================================================================================================================
function SetModeLabel() {
	
    $title = $GameType.mode
    if ($IsFoolsDay) {
        if     ($title -like "*Time*")      { $title = $title.replace("Time",    "Jason") }
        elseif ($title -like "*Majora*")    { $title = $title.replace("Majora",  "Jason") }
        elseif ($title -like "*Mario*")     { $title = $title.replace("Mario",   "Jason") }
        elseif ($title -like "*Smash*")     { $title = $title.replace("Smash",   "Jason") }
        elseif ($title -like "*Bomber*")    { $title = $title.replace("Bomber",  "Jason") }
        elseif ($title -like "*Banjo*")     { $title = $title.replace("Banjo",   "Jason") }
        elseif ($title -like "*Diddy*")     { $title = $title.replace("Diddy",   "Jason") }
        elseif ($title -like "*Donkey*")    { $title = $title.replace("Donkey",  "Jason") }
        elseif ($title -like "*Eye*")       { $title = $title.replace("Eye",     "Jason") }
        elseif ($title -like "*Link*")      { $title = $title.replace("Link",    "Jason") }
        elseif ($title -like "*Zelda*")     { $title = $title.replace("Zelda",   "Jason") }
        elseif ($title -like "*Metroid*")   { $title = $title.replace("Metroid", "Jason") }
        elseif ($title -like "*Ages*")      { $title = $title.replace("Ages",    "Jason") }
        elseif ($title -like "*Seasons*")   { $title = $title.replace("Seasons", "Jason") }
        elseif ($title -like "*Free*")      { $title = $title.replace("Free",    "Jason") }
    }

    if ($IsWiiVC) { $CurrentModeLabel.Mode.Text = "Current Mode (Wii VC):" } else { $CurrentModeLabel.Mode.Text = "Current Mode (" + $GameConsole.Mode + "):" }
    $CurrentModeLabel.Game.Text = $title
    $CurrentModeLabel.Mode.Refresh()
    $CurrentModeLabel.Game.Refresh()

}



#==================================================================================================================================================================================================================================================================
function EnablePatchButtons() {
    
    if     ($GamePath -eq $null)                              { $enable = $False }
    elseif ($GamePatch.console -eq "Native" -and  $IsWiiVC)   { $enable = $False }
    elseif ($GamePatch.console -eq "Wii VC" -and !$IsWiiVC)   { $enable = $False }
    elseif ($GameType.support_vc -eq 0 -and $IsWiiVC)         { $enable = $False }
    else                                                      { $enable = ($GamePath.Extension -eq ".wad" -and $IsWiiVC) -or ($GamePath.Extension -ne ".wad" -and !$IsWiiVC) }
    
    if     ($GameType.support_vc -eq 0 -and $IsWiiVC)         { UpdateStatusLabel "This game does not support Wii VC!"       -NoConsole }
    elseif ($GamePatch.console -eq "Native" -and  $IsWiiVC)   { UpdateStatusLabel "This patch does not support Wii VC!"      -NoConsole }
    elseif ($GamePatch.console -eq "Wii VC" -and !$IsWiiVC)   { UpdateStatusLabel "This patch only supports Wii VC!"         -NoConsole }
    elseif ($enable)                                          { UpdateStatusLabel "Ready to patch!"                          -NoConsole } # Set the status that we are ready to roll... Or not...
    elseif ($IsWiiVC)                                         { UpdateStatusLabel "Select your Wii VC WAD file to continue." -NoConsole }
    else                                                      { UpdateStatusLabel "Select your ROM file to continue."        -NoConsole }

    $Patches.Button.Enabled = $CustomHeader.Panel.Enabled = $VC.ExtractROMButton.Enabled = $enable # Enable patcher buttons

}



#==================================================================================================================================================================================================================================================================
function GamePath_Finish([object]$TextBox, [string]$Path) {
    
    $file = $null
    if (TestFile $Path)        { $file = Get-Item -LiteralPath $Path }
    if ($file -eq $GamePath)   { return }

    $global:GameIsSelected = $InputPaths.ClearGameButton.Enabled = ($file -ne $null)
    $global:GamePath       = if ($file -eq $null) { $null } else { $file }
    if ($Settings.Core.PerGameFile) {
        if ($file -eq $null) { $Settings.Paths[$GameType.mode] = $null } else { $Settings.Paths[$GameType.mode] = $path }
    }

    EnablePatchButtons
    CalculateHashSum

    if ($file -ne $null) {
        $TextBox.Text = $GamePath
        WriteToConsole ("Game Path:      " + $GamePath)
        if     ($file.Extension -eq ".wad" -and !$IsWiiVC)   { SetWiiVCMode $True  }
        elseif ($file.Extension -ne ".wad" -and  $IsWiiVC)   { SetWiiVCMode $False }
    }
    else {
        SetWiiVCMode $False
        $InputPaths.GameTextBox.Text = "Select your ROM or Wii VC WAD file..."
    }
    
}



#==================================================================================================================================================================================================================================================================
function CalculateHashSum() {
    
    if ($VerificationInfo -eq $null -or $GamePath -eq $null) {
        $VerificationInfo.HashField.Text = ""
        $VerificationInfo.GameField.Text = $VerificationInfo.RegionField.Text = $VerificationInfo.RevField.Text = $VerificationInfo.SupportField.Text = "No ROM provided for validation"
        return
    }

    if (!$IsWiiVC) { # Calculate checksum if Native Mode
        $VerificationInfo.HashField.Text = (Get-FileHash -Algorithm MD5 -LiteralPath $GamePath).Hash # Update hash
        
        $VerificationInfo.GameField.Text = $VerificationInfo.RegionField.Text = $VerificationInfo.RevField.Text = $VerificationInfo.SupportField.Text = "No Valid ROM Selected" 
        foreach ($item in $Files.json.games) { # Verify ROM
            for ($i=0; $i -lt $item.revision.Count; $i++) {
                if ($VerificationInfo.HashField.Text -eq $item.revision[$i].hash) {
                    $VerificationInfo.GameField.Text   = $item.title
                    $VerificationInfo.RegionField.Text = $item.revision[$i].region
                    $VerificationInfo.RevField.Text    = $item.revision[$i].rev
                    if ($i -eq 0 -or (IsSet $item.revision[$i].downgrade) -or (IsSet $item.revision[$i].upgrade) -or $item.revision[$i].supported -eq 1)   { $VerificationInfo.SupportField.Text = "This ROM is supported"                                                    }
                    else                                                                                                                                   { $VerificationInfo.SupportField.Text = "This ROM is NOT supported! Please use a different ROM that is supported!" }
                    break
                }
            }
        }
    }
    else {
        $VerificationInfo.HashField.Text = ""
        $VerificationInfo.GameField.Text = $VerificationInfo.RegionField.Text = $VerificationInfo.RevField.Text = $VerificationInfo.SupportField.Text = "No validation for WAD files"
    }

}



#==================================================================================================================================================================================================================================================================
function InjectPath_Finish([object]$TextBox, [string]$Path) {
    
    if ( (Get-Item -LiteralPath $Path) -eq $InjectPath) { return }
    $global:InjectPath                    = $Path       # Set the "InjectPath" variable that tracks the path
    $TextBox.Text                         = $InjectPath # Update the textbox to the current injection ROM
    $InputPaths.ApplyInjectButton.Enabled = $True
    WriteToConsole ("Inject Path:   " + $InjectPath)

}



#==================================================================================================================================================================================================================================================================
function PatchPath_Finish([object]$TextBox, [string]$Path) {
    
    if ( (Get-Item -LiteralPath $Path) -eq $PatchPath) { return }
    $global:PatchPath                    = $Path      # Set the "PatchPath" variable that tracks the path
    $TextBox.Text                        = $PatchPath # Update the textbox to the current patch
    $InputPaths.ApplyPatchButton.Enabled = $True
    WriteToConsole ("Patch Path:    " + $PatchPath)

}



#==============================================================================================================================================================================================
function RemoveOptionCheckFromList([object]$Elem) {
    
    if ($OptionsPatchList.Count -gt 0 -and $Elem -ne $null) {
        $target = "$($Elem.Section).$($Elem.Name)"
        $index = $OptionsPatchList.IndexOf($target)
        if ($index -ge 0) { $OptionsPatchList.RemoveAt($index) }
    }

}



#==============================================================================================================================================================================================
function IsDefault([object]$Elem, [byte]$Lang=0, [switch]$Not) {
    
    RemoveOptionCheckFromList $Elem
    if ($Lang -gt 0 -and (IsSet $Redux.Text.Language) ) {
        if ($Redux.Text.Language.SelectedIndex -ne $Lang - 1) { return $False }
    }

    if ($Elem -eq $null) { return $False }
    $type = $Elem.GetType()

    if     ($type -eq [int] -or $type -eq [string])                                                       { $value = $Elem         }
    elseif (!$Patches.Options.Checked -or !$Elem.Active -or $Elem.Hidden)                                 { return $False          }
    elseif ($type -eq [System.Windows.Forms.CheckBox] -or $type -eq [System.Windows.Forms.RadioButton])   { $value = $Elem.Checked }
    elseif ($type -eq [System.Windows.Forms.TrackBar])                                                    { $value = $Elem.Value   }
    else                                                                                                  { $value = $Elem.Text    }

    if ($type -eq [System.Windows.Forms.ComboBox]) {
        if ($Elem.TrueDefault -gt 0) { $default = $Elem.Items[$Elem.TrueDefault - 1] } else { $default = $Elem.Items[$Elem.Default] }
    }
    else { $default = $Elem.Default }

    return ($default -eq $value) -xor $Not

}



#==============================================================================================================================================================================================
function IsChecked([object]$Elem=$null, [byte]$Lang=0, [switch]$Not, [switch]$Redux) {
    
    RemoveOptionCheckFromList $Elem
    if ($Lang -gt 0 -and (IsSet $Redux.Text.Language) ) {
        if ($Redux.Text.Language.SelectedIndex -ne $Lang - 1) { return $False }
    }

    if ($Elem -eq $null) { return $False }
    $type = $Elem.GetType()

    if     ($type -eq [int])                                                                               { return (($Elem -eq (1 - [int]([bool]$Not))) -as [bool]) }
    elseif (!$Patches.Options.Checked -or !$Elem.Active -or $Elem.Hidden)                                  { return $False }
    elseif ($Redux -and !(IsChecked $Patches.Redux) )                                                      { return $False }
    elseif ($type -ne [System.Windows.Forms.CheckBox] -and $type -ne [System.Windows.Forms.RadioButton])   { return $False }
    return $Elem.Checked -xor $Not

}



#==============================================================================================================================================================================================
function GetCheckedValue([object]$Elem=$null) {
    
    if ($Elem.Checked) { return 1 } else { return 0 }

}



#==============================================================================================================================================================================================
function IsRevert([object]$Elem=$null, [int16]$Index=1, [string]$Text="", [string]$Compare="", [string]$Item="", [byte]$Lang=0) {
    
    if ($Elem -eq $null) { return $False }
    $type = $Elem.GetType()

    if     ($type -eq [System.Windows.Forms.CheckBox] -or $type -eq [int])      { return (IsChecked -Elem $Elem                           -Lang $Lang -Not) }
    elseif ($type -eq [System.Windows.Forms.Listbox])                           { return (IsItem    -Elem $Elem -Item $Item               -Lang $Lang -Not) }
    elseif ($type -eq [System.Windows.Forms.ComboBox] -or $type -eq [int])      { return (IsIndex   -Elem $Elem -Index $Index -Text $Text -Lang $Lang     ) }
    elseif ($type -eq [System.Windows.Forms.TextBox]  -or $type -eq [string])   { return (IsText    -Elem $Elem -Compare $Compare         -Lang $Lang -Not) }

    return $False

}



#==============================================================================================================================================================================================
function IsText([object]$Elem=$null, [string]$Compare="", [byte]$Lang=0, [switch]$Not) {
    
    if ($Elem -eq $null) { return $False }
    RemoveOptionCheckFromList $Elem

    if ($Lang -gt 0 -and (IsSet $Redux.Text.Language) ) {
        if ($Redux.Text.Language.SelectedIndex -ne $Lang - 1) { return $False }
    }

    if     ($Elem -is [string])                                             { $Text = $Elem                                }
    elseif (!$Patches.Options.Checked -or !$Elem.Active -or $Elem.Hidden)   { return $False                                }
    else                                                                    { $Text = $Elem.Text.replace(" (default)", "") }
    return ($Text -eq $Compare) -xor $Not

}



#==============================================================================================================================================================================================
function IsItem([object]$Elem=$null, [string]$Item="", [byte]$Lang=0, [switch]$Not) {
    
    if ($Elem -eq $null) { return $False }
    RemoveOptionCheckFromList $Elem

    if ($Lang -gt 0 -and (IsSet $Redux.Text.Language) -and $Redux.Text.Language.SelectedIndex -ne $Lang - 1)   { return $False }
    if (!$Patches.Options.Checked -or !$Elem.Active -or $Elem.Hidden)                                          { return $False }
    return ($Elem.SelectedItems -contains $Item) -xor $Not

}



#==============================================================================================================================================================================================
function IsValue([object]$Elem=$null, [int16]$Value=$null, [byte]$Lang=0, [switch]$Not) {
    
    if ($Elem -eq $null) { return $False }
    RemoveOptionCheckFromList $Elem

    if     ($Lang -gt 0 -and (IsSet $Redux.Text.Language) -and $Redux.Text.Language.SelectedIndex -ne $Lang - 1)   { return $False          }
    elseif ($Elem  -is [int])                                                                                      { $Value = $Elem         }
    elseif (!$Patches.Options.Checked -or !$Elem.Active -or $Elem.Hidden)                                          { return $False          }
    elseif ($Value -eq $null)                                                                                      { $Value = $Elem.Default }

    if ($Elem.GetType() -eq [System.Windows.Forms.TextBox]) { return ([int16]$Elem.Text  -eq $Value) -xor $Not } else { return ([int16]$Elem.Value -eq $Value) -xor $Not }

}



#==============================================================================================================================================================================================
function IsIndex([object]$Elem=$null, [int16]$Index=1, [string]$Text="", [byte]$Lang=0, [switch]$Not) {
    
    if ($Elem -eq $null) { return $False }
    RemoveOptionCheckFromList $Elem

    if     ($Lang -gt 0 -and (IsSet $Redux.Text.Language) -and $Redux.Text.Language.SelectedIndex -ne $Lang - 1)   { return $False  }
    elseif ($Elem.GetType() -ne [System.Windows.Forms.ComboBox] -and $Elem -isnot [int])                           { return $False  }
    elseif ($Elem  -is [int])                                                                                      { $Index = $Elem }
    elseif (!$Patches.Options.Checked -or !$Elem.Active -or $Elem.Hidden)                                          { return $False  }

    if ($Index -lt 1) { $Index = 1 }
    if ($Text -ne "") {
        if ($Elem.Text.replace(" (default)", "") -eq $Text) { return !$Not } else { return $Not }
    }

    if ($Elem.SelectedIndex -eq $Index - 1) { return !$Not } else { return $Not }

}



#==============================================================================================================================================================================================
function IsColor([System.Windows.Forms.ColorDialog]$Elem=$null, [string]$Color="", [byte]$Lang=0, [switch]$Not) {
    
    if ($Elem -eq $null) { return $False }
    RemoveOptionCheckFromList $Elem

    if ($Lang -gt 0 -and (IsSet $Redux.Text.Language) -and ($Redux.Text.Language.SelectedIndex -ne ($Lang - 1)))   { return $False }
    if (!$Patches.Options.Checked)                                                                                 { return $False }

    $Color = if ($Color -eq "") { $Elem.Default } else { $Color }
    $c = '{0:X2}{1:X2}{2:X2}' -f $Elem.Color.R, $Elem.Color.G, $Elem.Color.B
    return (($c -eq $Color) -ne $Not)

}



#==============================================================================================================================================================================================
function IsSet([object]$Elem, [int16]$Min, [int16]$Max, [int16]$MinLength, [int16]$MaxLength, [switch]$HasInt) {
    
    RemoveOptionCheckFromList $Elem
    if ($Elem -eq $null -or $Elem -eq "")                                              { return $False }
    if ($HasInt) {
        if ($Elem -NotMatch "^\d+$" )                                                  { return $False }
        $elemInt = [int16]$Elem
        if ($Min -ne $null -and $Min -ne "" -and $elemInt -lt $Min)                    { return $False }
        if ($Max -ne $null -and $Max -ne "" -and $elemInt -gt $Max)                    { return $False }
    }
    $elemLength = $Elem.Length
    if ($MinLength -ne $null -and $MinLength -ne "" -and $elemLength -lt $MinLength)   { return $False }
    if ($MaxLength -ne $null -and $MaxLength -ne "" -and $elemLength -gt $MaxLength)   { return $False }

    return $True

}



#==============================================================================================================================================================================================
function BoxCheck([object]$Elem)     { if ($Elem -ne $null) { $Elem.Checked = $True          } }
function BoxUncheck([object]$Elem)   { if ($Elem -ne $null) { $Elem.Checked = $False         } }
function BoxToggle([object]$Elem)    { if ($Elem -ne $null) { $Elem.Checked = !$Elem.Checked } }



#==============================================================================================================================================================================================
function CompareArray([array]$Elem, [array]$Compare) {
    
    if ($Elem.length -eq 0 -or $Compare.length -eq 0)   { return $False }
    if ($Elem.length -ne $Compare.length)               { return }

    foreach ($i in 0..($Elem.length-1)) {
        if ($Elem[$i] -ne $Compare[$i]) { return $False }
    }

    return $True

}



#==============================================================================================================================================================================================
function AddTextFileToTextbox([object]$TextBox, [string]$File, [switch]$Add, [switch]$GameCredits, [switch]$MainCredits) {
    
    if (!(IsSet $File) -or !(TestFile $File)) {
        $TextBox.Text = ""
        return
    }
    
    if ($GameCredits -or $MainCredits)   { $Start = $False }
    else                                 { $Start = $True }
    $reader  = New-Object System.IO.StreamReader($File)
    $content = $reader.ReadToEnd()
    $reader.Close()
    $reader.Dispose()

    if ($GameCredits) {
        if (!(IsSet $GameType.mode)) { return }
        $match = "<<< " + $GameType.mode.ToUpper() + " >>>"
    }
    elseif ($MainCredits) { $match = "<<< PATCHER64+ TOOL >>>" }
    if ($GameCredits -or $MainCredits) {
        # Start
        $start = $content.indexOf($match)
        $content = $content.substring($start)

        # End
        $match = "======"
        $end = $content.indexOf($match)
        if ($end -gt 0) { $content = $content.substring(0, $end) }
    }
    if ($GameCredits) {
        if ( ([int]$content[$content.length-2]) -eq 13 -and ([int]$content[$content.length-1]) -eq 10) {
            if ( ([int]$content[$content.length-4]) -eq 13 -and ([int]$content[$content.length-3]) -eq 10) {
                if ( ([int]$content[$content.length-6]) -eq 13 -and ([int]$content[$content.length-5]) -eq 10) {
                    if ( ([int]$content[$content.length-8]) -eq 13 -and ([int]$content[$content.length-7]) -eq 10) {
                        $content = $content.substring(0, $content.length-8)
                    }
                }
            }
        }
    }

    $content = [string]::Format($content, [Environment]::NewLine)
    if ($Add) { $TextBox.Text += $content }
    else      { $TextBox.Text  = $content }
    $content = $null

}



#==============================================================================================================================================================================================
function GetFilePaths() {
    
    if (IsSet $Settings["Core"][$InputPaths.GameTextBox.Name]) {
        if (TestFile $Settings["Core"][$InputPaths.GameTextBox.Name]) {
            GamePath_Finish $InputPaths.GameTextBox -VarName $InputPaths.GameTextBox.Name -Path $Settings["Core"][$InputPaths.GameTextBox.Name]
        }
        else {
            $InputPaths.GameTextBox.Text = "Select your ROM or Wii VC WAD file..."
            if ($IsWiiVC) { SetWiiVCMode $False}
        }
    }

    if (IsSet $Settings["Core"][$InputPaths.InjectTextBox.Name]) {
        if (TestFile $Settings["Core"][$InputPaths.InjectTextBox.Name]) {
            InjectPath_Finish $InputPaths.InjectTextBox -VarName $InputPaths.InjectTextBox.Name -Path $Settings["Core"][$InputPaths.InjectTextBox.Name]
        }
        else { $InputPaths.InjectTextBox.Text = "Select your ROM for injection..." }
    }

    if (IsSet $Settings["Core"][$InputPaths.PatchTextBox.Name]) {
        if (TestFile $Settings["Core"][$InputPaths.PatchTextBox.Name]) {	
            PatchPath_Finish $InputPaths.PatchTextBox -VarName $InputPaths.PatchTextBox.Name -Path $Settings["Core"][$InputPaths.PatchTextBox.Name]
        }
        else { $InputPaths.PatchTextBox.Text = "Select your custom patch file..." }
    }

}



#==============================================================================================================================================================================================
function GetHeader() {
    
    if (IsChecked $CustomHeader.EnableHeader) { return }

    # ROM Title
    if     (IsSet $GamePatch.rom_title)    { $CustomHeader.ROMTitle.Text  = $GamePatch.rom_title  }
    elseif (IsSet $GameType.rom_title)     { $CustomHeader.ROMTitle.Text  = $GameType.rom_title   }
    else                                   { $CustomHeader.ROMTitle.Text  = ""                    }

    # ROM GameID
    if     (IsSet $GamePatch.rom_gameID)   { $CustomHeader.ROMGameID.Text = $GamePatch.rom_gameID }
    elseif (IsSet $GameType.rom_gameID)    { $CustomHeader.ROMGameID.Text = $GameType.rom_gameID  }
    else                                   { $CustomHeader.ROMGameID.Text = ""                    }

    # VC Title
    if     (IsSet $GamePatch.vc_title)     { $CustomHeader.VCTitle.Text   = $GamePatch.vc_title   }
    elseif (IsSet $GameType.vc_title)      { $CustomHeader.VCTitle.Text   = $GameType.vc_title    }
    else                                   { $CustomHeader.VCTitle.Text   = ""                    }

    # VC GameID
    if     (IsSet $GamePatch.vc_gameID)    { $CustomHeader.VCGameID.Text  = $GamePatch.vc_gameID  }
    elseif (IsSet $GameType.vc_gameID)     { $CustomHeader.VCGameID.Text  = $GameType.vc_gameID   }
    else                                   { $CustomHeader.VCGameID.Text  = ""                    }
    
}



#==============================================================================================================================================================================================
function GetRegion() {
    
    if     (IsSet $GamePatch.rom_region)           { $CustomHeader.Region.SelectedIndex = $GamePatch.rom_region }
    elseif (IsSet $GameType.rom_region)            { $CustomHeader.Region.SelectedIndex = $GameType.rom_region }
    elseif (!$CustomHeader.EnableRegion.Checked)   { $CustomHeader.Region.SelectedIndex = 1 }

}



#==============================================================================================================================================================================================
function RestoreCustomHeader() {
    
    if (IsChecked $CustomHeader.EnableHeader) {
        if (IsSet $Settings["Core"]["CustomHeader.ROMTitle"])    { $CustomHeader.ROMTitle.Text  = $Settings["Core"]["CustomHeader.ROMTitle"]  }
        if (IsSet $Settings["Core"]["CustomHeader.ROMGameID"])   { $CustomHeader.ROMGameID.Text = $Settings["Core"]["CustomHeader.ROMGameID"] }
        if (IsSet $Settings["Core"]["CustomHeader.VCTitle"])     { $CustomHeader.VCTitle.Text   = $Settings["Core"]["CustomHeader.VCTitle"]   }
        if (IsSet $Settings["Core"]["CustomHeader.VCGameID"])    { $CustomHeader.VCGameID.Text  = $Settings["Core"]["CustomHeader.VCGameID"]  }
    }
    else { GetHeader }

    $CustomHeader.ROMTitle.Enabled = $CustomHeader.ROMGameID.Enabled = $CustomHeader.VCTitle.Enabled = $CustomHeader.VCGameID.Enabled = $CustomHeader.EnableHeader.Checked

}



#==============================================================================================================================================================================================
function RestoreCustomRegion() {

    if (IsChecked $CustomHeader.EnableRegion) {
        if (IsSet $Settings["Core"]["CustomHeader.Region"]) {
            $CustomHeader.Region.SelectedIndex = $Settings["Core"]["CustomHeader.Region"]
        }
    }
    else { GetRegion }

    $CustomHeader.Region.Enabled = $CustomHeader.EnableRegion.Checked

}



#==============================================================================================================================================================================================
function StrLike([string]$Str, [string]$Val, [switch]$Not) {
    
    if     (!$Not -and $str.ToLower() -like "*"    + $val.ToLower() + "*")   { return $True }
    elseif ( $Not -and $str.ToLower() -notlike "*" + $val.ToLower() + "*")   { return $True }
    return $False

}



#==============================================================================================================================================================================================
function StrStarts([string]$Str, [string]$Val, [switch]$Not) {
    
    if ($Str -eq $null -or $Str -eq "")                              { return $False }
    if     (!$Not -and  $Str.ToLower().StartsWith($Val.ToLower()))   { return $True }
    elseif ( $Not -and !$Str.ToLower().StartsWith($Val.ToLower()))   { return $True }
    return $False

}



#==============================================================================================================================================================================================
function EnableGUI([boolean]$Enable) {
    
    if ($MainDialog -eq $null) { return }
    $RightPanel.getEnumerator() | foreach { $_.value.Enabled = $Enable }
    $MainPanel.Enabled = $Enable
    if (IsSet $TextEditor.Dialog)    { $TextEditor.Dialog.Enabled  = $Enable }
    if (IsSet $SceneEditor.Dialog)   { $SceneEditor.Dialog.Enabled = $Enable }
    SetModernVisualStyle ($Settings.Core.ModernStyle -eq $True)

}



#==============================================================================================================================================================================================
function EnableForm([object]$Form, [boolean]$Enable, [switch]$Not) {
    
    if ($Form -eq $null) { return }

    if ($Not) { $Enable = !$Enable }
    if ($Form.Controls.length -eq $True) {
        foreach ($item in $Form.Controls) { $item.Enabled = $Enable }
    }
    else { $Form.Enabled = $Enable }

}



#==============================================================================================================================================================================================
function EnableElem([object]$Elem, [boolean]$Active=$True, [switch]$Hide) {
    
    if ($Elem -is [system.Array]) {
        foreach ($item in $Elem) {
            if ($item -eq $null) { return }
            $item.Enabled = $item.Active = $Active
            if ($Hide) { $item.Visible = $Active }
        }
    }
    else {
        if ($Elem -eq $null) { return }
        $Elem.Enabled = $Elem.Active = $Active
        if ($Hide) { $Elem.Visible = $Active }
    }

}




#==============================================================================================================================================================================================
function CreatePath([string]$Path="") {
    
    if ($Path -ne "") {                                                                                                # Make sure the path is not null to avoid errors
        if (!(Test-Path -LiteralPath $Path -PathType Container) ) { [void](New-Item -Path $Path -ItemType Directory) } # Check to see if the path does not exist, then create the path
    }

}



#==============================================================================================================================================================================================
function CreateSubPath([string]$Path="") {
    
    if ($Path -ne "") {
        if (!(Test-Path -LiteralPath $Path -PathType Container) ) {
            $subPath = $Path.substring(0, $Path.LastIndexOf('\'))
            $name    = $Path.substring($Path.LastIndexOf('\') + 1)
            [void](New-Item -Path $subPath -Name $name -ItemType Directory)
        }
    }

}



#==============================================================================================================================================================================================
function RemoveFile([string]$Path="") {
    
    if ($Path -ne "") {                                                                            # Make sure the path isn't null to avoid errors
        if (Test-Path -LiteralPath $Path -PathType Leaf) { Remove-Item -LiteralPath $Path -Force } # Check to see if the path exists, and then remove the file
    }

}



#==============================================================================================================================================================================================
function RemovePath([string]$Path="") {
    
    if ($Path -ne "") {                                                                                          # Make sure the path isn't null to avoid errors
        if (Test-Path -LiteralPath $Path -PathType Container) { Remove-Item -LiteralPath $Path -Recurse -Force } # Check to see if the path exists, and then remove the path
    }

}



#==============================================================================================================================================================================================
function TestFile([string]$Path="", [switch]$Container) {
    
    if ($Path -eq "")   { return $False }
    if ($Container)     { return (Test-Path -LiteralPath $Path -PathType Container) }
    else                { return (Test-Path -LiteralPath $Path -PathType Leaf)      }

}



#==============================================================================================================================================================================================
function CountFiles([string]$Path="") {
    
    if ($Path -eq "")                                           { return -1 }
    if (!(Test-Path -LiteralPath $Path -PathType Container) )   { return -1 }
    return (Get-ChildItem -Recurse -File -LiteralPath $Path | Measure-Object).Count

}



#==============================================================================================================================================================================================
function ShowPowerShellConsole([bool]$Show=$True) {
    
    if (!$ExternalScript) { return }

    # Shows or hide the console window
    if ($Show)   { [void]([Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 1)) }
    else         { [void]([Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 0)) }

}



#==================================================================================================================================================================================================================================================================
function TogglePowerShellOpenWithClicks([boolean]$Enable) {
    
    # Create a temporary folder to create the registry entry and and set the path to it
    RemovePath $Paths.Registry
    CreatePath $Paths.Registry
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

    # Execute the registry file.
    & regedit /s $RegFile | Out-Null

}


#==================================================================================================================================================================================================================================================================
function SetModernVisualStyle([boolean]$Enable) {

    if ($Enable) {
        [Windows.Forms.Application]::EnableVisualStyles()
        [Windows.Forms.Application]::VisualStyleState = [Windows.Forms.VisualStyles.VisualStyleState]::ClientAndNonClientAreasEnabled
    }
    else { [Windows.Forms.Application]::VisualStyleState = [Windows.Forms.VisualStyles.VisualStyleState]::NonClientAreaEnabled }

}



#==============================================================================================================================================================================================
function SetLogging([boolean]$Enable) {
    
    if (!$ExternalScript) {
        if ($Enable -and $ConsoleHistory.length -gt 0) {
            if (!(TestFile -Path $Paths.Logs -Container)) { CreatePath $Paths.Logs }
            foreach ($entry in $ConsoleHistory) { Add-Content -LiteralPath ($Paths.Logs + "\" + $TranscriptTime + ".log") -Value $entry }
            $global:ConsoleHistory = @()
        }
        return
    }

    if ($Enable) {
        $global:TranscriptTime = Get-Date -Format yyyy-MM-dd
        if (!(TestFile -Path $Paths.Logs -Container)) { CreatePath $Paths.Logs }

        $file = $Paths.Logs + "\" + $TranscriptTime + ".log"
        if (!(TestFile $file)) { Start-Transcript -LiteralPath $file }
        else {
            Add-Content -LiteralPath $file -Value "`n`n`n"
            Start-Transcript -LiteralPath $file -Append
        }
    }
    else {
        if ($TranscriptTime -ne $null) {
            Stop-Transcript
            $global:TranscriptTime = $null
        }
    }

}



#==================================================================================================================================================================================================================================================================
function SetBitmap($Path, $Box, [int]$Width=0, [int]$Height=0) {
    
    if ($IsFoolsDay) {
        $rand = Get-Random -Minimum 1 -Maximum 10
        $Path = $Paths.Main + "\JASON\jason-" + $rand + ".jpg"
    }

    $imgObject = [Drawing.Image]::FromFile( ( Get-Item $Path ) )

    if ($Width  -eq 0)   { $Width  = $Box.Width      }
    else                 { $Width  = DPISize $Width  }
    if ($Height -eq 0)   { $Height = $Box.Height     }
    else                 { $Height = DPISize $Height }

    $imgBitmap = New-Object Drawing.Bitmap($imgObject, $Width, $Height)
    $imgObject.Dispose()
    $Box.Image = $imgBitmap

}



#==================================================================================================================================================================================================================================================================
function IsRestrictedFolder([string]$Path) {
    
    if ($Path -like ("*" + [Environment]::GetFolderPath("MyDocuments") + "*"))   { return $False }
    if ($Path -like ("*" + $env:APPDATA + "*"))                                  { return $False }
    if ($Path -like "*C:\Users\*")                                               { return $True }
    if ($Path -like "*C:\Program Files\*")                                       { return $True }
    if ($Path -like "*C:\Program Files (x86)\*")                                 { return $True }
    if ($Path -like "*C:\ProgramData\*")                                         { return $True }
    if ($Path -like "*C:\Windows\*")                                             { return $True }
    return $False

}



#==================================================================================================================================================================================================================================================================
function GetWindowsVersion() {

    # Get the current version of windows
    $getWinVersion = ([Environment]::OSVersion.Version).ToString().Split('.')
    $getWinVersion = $GetWinVersion[0] + '.' + $GetWinVersion[1]

    switch ($getWinVersion) { # Set the version of windows, shared versions for Vista/7 and for 8/8.1
        '6.0'   { return 7 } # Windows Vista
        '6.1'   { return 7 } # Windows 7
        '6.2'   { return 8 } # Windows 8
        '6.3'   { return 8 } # Windows 8.1
        '10.0'  {            # Windows 10 / 11
            $WinTitle = ((Get-CimInstance -ClassName CIM_OperatingSystem).Caption).Split(' ') # Get the full name of the operating system and split on the spaces
            return [int]($WinTitle[2])                                                        # Get the version from the split string
        }
        default { return 50 }  # Any other future version
    }

}



#==================================================================================================================================================================================================================================================================
function RefreshScripts() {
    
    if ($Settings.Debug.RefreshScripts -ne $True) { return }

    Remove-Module -Name "Bytes";        Import-Module -Name ($Paths.Scripts + "\Bytes.psm1")        -Global
    Remove-Module -Name "Common";       Import-Module -Name ($Paths.Scripts + "\Common.psm1")       -Global
    Remove-Module -Name "Dialogs";      Import-Module -Name ($Paths.Scripts + "\Dialogs.psm1")      -Global
    Remove-Module -Name "DPI";          Import-Module -Name ($Paths.Scripts + "\DPI.psm1")          -Global
    Remove-Module -Name "Files";        Import-Module -Name ($Paths.Scripts + "\Files.psm1")        -Global
    Remove-Module -Name "Forms";        Import-Module -Name ($Paths.Scripts + "\Forms.psm1")        -Global
    Remove-Module -Name "Main";         Import-Module -Name ($Paths.Scripts + "\Main.psm1")         -Global
    Remove-Module -Name "MQ";           Import-Module -Name ($Paths.Scripts + "\MQ.psm1")           -Global
    Remove-Module -Name "Patch";        Import-Module -Name ($Paths.Scripts + "\Patch.psm1")        -Global
    Remove-Module -Name "Scene Editor"; Import-Module -Name ($Paths.Scripts + "\Scene Editor.psm1") -Global
    Remove-Module -Name "Settings";     Import-Module -Name ($Paths.Scripts + "\Settings.psm1")     -Global
    Remove-Module -Name "Text Editor";  Import-Module -Name ($Paths.Scripts + "\Text Editor.psm1")  -Global
    Remove-Module -Name "Updater";      Import-Module -Name ($Paths.Scripts + "\Updater.psm1")      -Global
    Remove-Module -Name "VC";           Import-Module -Name ($Paths.Scripts + "\VC.psm1")           -Global
    Remove-Module -Name "Zelda 64";     Import-Module -Name ($Paths.Scripts + "\Zelda 64.psm1")     -Global

}



#==================================================================================================================================================================================================================================================================
function RefreshGameScript() {
    
    if ($Settings.Debug.RefreshScripts) {
        if ($GamePatch.script -is [system.Array]) {
            foreach ($script in $GamePatch.script) {
                if ($script -ne $null) {
                    Remove-Module -Name $script
                    Import-Module -Name ($Paths.Scripts + "\Options\" + $script + ".psm1") -Global
                }
            }

        }
        else {
            if ($GamePatch.Script -ne $null) {
                Remove-Module -Name $GamePatch.Script
                Import-Module -Name ($Paths.Scripts + "\Options\" + $GamePatch.Script + ".psm1") -Global
            }
        }
    }

}



#==================================================================================================================================================================================================================================================================
function StopJobs() {
    
    if ( (Get-Process "playsmf" -ea SilentlyContinue) -ne $null) { Stop-Process -Name "playsmf" }
    Get-Job | Stop-Job
    Get-Job | Remove-Job
    [System.GC]::Collect(); [System.GC]::WaitForPendingFinalizers(); [System.GC]::Collect()

}



#==================================================================================================================================================================================================================================================================
function StartJobLoop([string]$Name, [switch]$Output) {
    
    $status = (Get-Job -Name $Name).State
    while ($status -ne "Completed") {
        Start-Sleep -m 10
        $current = Get-Job -Name $Name
        if ($current -eq $null) { break }
        $status = $current.State
        [Windows.Forms.Application]::DoEvents()
    }

    Stop-Job   -Name $Name
    if ($Output) { $result = Receive-Job -Job $current }
    Remove-Job -Name $Name
    if ($Output) { return $result }

}



#==============================================================================================================================================================================================
function HasCommand([string]$Command) {

    if (Get-Command $Command -ErrorAction SilentlyContinue) { return $True }
    return $False

}



#==============================================================================================================================================================================================
function HideNativeOptions() {

    foreach ($option in $Redux.NativeOptions) {
        $option.Visible = !$IsWiiVC
        $option.Hidden  = $IsWiiVC
        if ($IsWiiVC -and $option.Link -ne $null -and $option.Checked) { $option.Checked = $False }
    }

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function SetWiiVCMode
Export-ModuleMember -Function CreateToolTip
Export-ModuleMember -Function ChangeConsolesList
Export-ModuleMember -Function ChangeGamesList
Export-ModuleMember -Function ChangePatchList
Export-ModuleMember -Function SetMainScreenSize
Export-ModuleMember -Function SetVCContent
Export-ModuleMember -Function ChangeGameMode
Export-ModuleMember -Function SetCreditsSections
Export-ModuleMember -Function ChangeGameRev
Export-ModuleMember -Function ChangePatch
Export-ModuleMember -Function UpdateStatusLabel
Export-ModuleMember -Function WriteToConsole
Export-ModuleMember -Function SetModeLabel
Export-ModuleMember -Function EnablePatchButtons

Export-ModuleMember -Function GamePath_Finish
Export-ModuleMember -Function CalculateHashSum
Export-ModuleMember -Function InjectPath_Finish
Export-ModuleMember -Function PatchPath_Finish

Export-ModuleMember -Function IsDefault
Export-ModuleMember -Function IsChecked
Export-ModuleMember -Function GetCheckedValue
Export-ModuleMember -Function IsRevert
Export-ModuleMember -Function IsItem
Export-ModuleMember -Function IsText
Export-ModuleMember -Function IsValue
Export-ModuleMember -Function IsIndex
Export-ModuleMember -Function IsColor
Export-ModuleMember -Function IsSet

Export-ModuleMember -Function BoxCheck
Export-ModuleMember -Function BoxUncheck
Export-ModuleMember -Function BoxToggle

Export-ModuleMember -Function CompareArray
Export-ModuleMember -Function AddTextFileToTextbox
Export-ModuleMember -Function StrLike
Export-ModuleMember -Function StrStarts
Export-ModuleMember -Function GetFilePaths

Export-ModuleMember -Function GetHeader
Export-ModuleMember -Function GetRegion
Export-ModuleMember -Function RestoreCustomHeader
Export-ModuleMember -Function RestoreCustomRegion

Export-ModuleMember -Function EnableGUI
Export-ModuleMember -Function EnableForm
Export-ModuleMember -Function EnableElem

Export-ModuleMember -Function RemoveFile
Export-ModuleMember -Function RemovePath
Export-ModuleMember -Function CreatePath
Export-ModuleMember -Function RemoveFile
Export-ModuleMember -Function TestFile
Export-ModuleMember -Function CountFiles
Export-ModuleMember -Function CreateSubPath

Export-ModuleMember -Function ShowPowerShellConsole
Export-ModuleMember -Function TogglePowerShellOpenWithClicks
Export-ModuleMember -Function SetModernVisualStyle
Export-ModuleMember -Function SetLogging
Export-ModuleMember -Function SetBitmap
Export-ModuleMember -Function IsRestrictedFolder
Export-ModuleMember -Function HasCommand
Export-ModuleMember -Function StopJobs
Export-ModuleMember -Function StartJobLoop
Export-ModuleMember -Function RunJobLoop
Export-ModuleMember -Function GetWindowsVersion
Export-ModuleMember -Function RefreshScripts
Export-ModuleMember -Function RefreshGameScript
Export-ModuleMember -Function HideNativeOptions