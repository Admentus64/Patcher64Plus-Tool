function CreateActorEditorDialog([int32]$Width, [int32]$Height, [string]$Game=$GameType.mode, [string]$Checksum) {
    
    $global:ActorEditor     = @{}
    $Files.json.actorEditor = SetJSONFile ($Paths.Games + "\" + $Game + "\Actor Editor.json")

    # Create Dialog
    $ActorEditor.Dialog           = CreateDialog -Width (DPISize 1300) -Height (DPISize 700)
    $ActorEditor.Dialog.Icon      = $Files.icon.additional
    $ActorEditor.Dialog.BackColor = 'AntiqueWhite'

    # Groups
    $ActorEditor.TopGroup                             = CreateGroupBox -X (DPISize 10) -Y (DPISize 5)                                  -Width ($ActorEditor.Dialog.Width      - (DPISize 30)) -Height (DPISize 70)                                      -AddTo $ActorEditor.Dialog
    $ActorEditor.BottomGroup                          = CreateGroupBox -X (DPISize 10) -Y ($ActorEditor.TopGroup.Bottom + (DPISize 5)) -Width ($ActorEditor.Dialog.Width      - (DPISize 30)) -Height ($ActorEditor.Dialog.Height      - (DPISize 190)) -AddTo $ActorEditor.Dialog
    
    $ActorEditor.BottomPanelActors                    = CreatePanel    -X (DPISize 5)  -Y (DPISize 10)                                 -Width ($ActorEditor.BottomGroup.Width - (DPISize 10)) -Height ($ActorEditor.BottomGroup.Height - (DPISize 15))  -AddTo $ActorEditor.BottomGroup
    $ActorEditor.BottomPanelActors.AutoScroll         = $True
    $ActorEditor.BottomPanelActors.AutoScrollMargin   = New-Object System.Drawing.Size(0, 0)
    $ActorEditor.BottomPanelActors.AutoScrollMinSize  = New-Object System.Drawing.Size(0, 0)

    $ActorEditor.BottomPanelObjects                   = CreatePanel -X $ActorEditor.BottomPanelActors.Left  -Y $ActorEditor.BottomPanelActors.Top -Width $ActorEditor.BottomPanelActors.Width -Height $ActorEditor.BottomPanelActors.Height -AddTo $ActorEditor.BottomGroup
    $ActorEditor.BottomPanelObjects.AutoScroll        = $True
    $ActorEditor.BottomPanelObjects.AutoScrollMargin  = New-Object System.Drawing.Size(0, 0)
    $ActorEditor.BottomPanelObjects.AutoScrollMinSize = New-Object System.Drawing.Size(0, 0)

    $ActorEditor.BottomPanelMapPreview                = CreatePanel -X $ActorEditor.BottomPanelActors.Left  -Y $ActorEditor.BottomPanelActors.Top -Width $ActorEditor.BottomPanelActors.Width -Height $ActorEditor.BottomPanelActors.Height -AddTo $ActorEditor.BottomGroup
    $ActorEditor.MapPreviewImage                      = CreateForm  -X (DPISize 50) -Y (DPISize 5) -Width (DPISize 1152) -Height (DPISize 648) -Form (New-Object Windows.Forms.PictureBox) -AddTo $ActorEditor.BottomPanelMapPreview
    $file                                             = $Paths.Games + "\" + $Game + "\Maps\default.jpg"
    if (TestFile $file) { SetBitMap -Path $file -Box $ActorEditor.MapPreviewImage } else { $ActorEditor.MapPreviewImage.Image = $null }

    # Actors Button
    $ActorsButton           = CreateButton -X ($ActorEditor.TopGroup.Right - (DPISize 300)) -Y (DPISize 15) -Width (DPISize 80) -Height (DPISize 35) -Text "Actors" -AddTo $ActorEditor.TopGroup
    $ActorsButton.BackColor = "White"
    $ActorsButton.Add_Click({
        $ActorEditor.BottomPanelActors.Show()
        $ActorEditor.BottomPanelObjects.Hide()
        $ActorEditor.BottomPanelMapPreview.Hide()
    })

    # Objects Button
    $ObjectsButton           = CreateButton -X ($ActorsButton.Right + (DPISize 15)) -Y $ActorsButton.Top -Width $ActorsButton.Width -Height $ActorsButton.Height -Text "Objects" -AddTo $ActorEditor.TopGroup
    $ObjectsButton.BackColor = "White"
    $ObjectsButton.Add_Click({
        $ActorEditor.BottomPanelActors.Hide()
        $ActorEditor.BottomPanelObjects.Show()
        $ActorEditor.BottomPanelMapPreview.Hide()
    })

    $ActorEditor.DeleteActor  = CreateButton -X $ActorsButton.Left              -Y $ActorsButton.Bottom          -Width (DPISize 40) -Height (DPISize 17) -Font $Fonts.SmallBold -Text "-" -AddTo $ActorEditor.TopGroup -BackColor "Red"   -ForeColor "White"
    $ActorEditor.InsertActor  = CreateButton -X $ActorEditor.DeleteActor.Right  -Y $ActorEditor.DeleteActor.Top  -Width (DPISize 40) -Height (DPISize 17) -Font $Fonts.SmallBold -Text "+" -AddTo $ActorEditor.TopGroup -BackColor "Green" -ForeColor "White"
    $ActorEditor.DeleteObject = CreateButton -X $ObjectsButton.Left             -Y $ObjectsButton.Bottom         -Width (DPISize 40) -Height (DPISize 17) -Font $Fonts.SmallBold -Text "-" -AddTo $ActorEditor.TopGroup -BackColor "Red"   -ForeColor "White"
    $ActorEditor.InsertObject = CreateButton -X $ActorEditor.DeleteObject.Right -Y $ActorEditor.DeleteObject.Top -Width (DPISize 40) -Height (DPISize 17) -Font $Fonts.SmallBold -Text "+" -AddTo $ActorEditor.TopGroup -BackColor "Green" -ForeColor "White"

    $ActorEditor.DeleteActor.Enabled = $ActorEditor.InsertActor.Enabled = $ActorEditor.DeleteObject.Enabled = $ActorEditor.InsertObject.Enabled = $False
    $ActorEditor.DeleteActor.Add_Click(  { DeleteActor  } )
    $ActorEditor.InsertActor.Add_Click(  { InsertActor  } )
    $ActorEditor.DeleteObject.Add_Click( { DeleteObject } )
    $ActorEditor.InsertObject.Add_Click( { InsertObject } )

    # Map Preview Button
    $MapPreviewButton           = CreateButton -X ($ObjectsButton.Right + (DPISize 15)) -Y $ObjectsButton.Top -Width $ObjectsButton.Width -Height $ObjectsButton.Height -Text "Preview Map" -AddTo $ActorEditor.TopGroup
    $MapPreviewButton.BackColor = "White"
    $MapPreviewButton.Add_Click({
        $ActorEditor.BottomPanelActors.Hide()
        $ActorEditor.BottomPanelObjects.Hide()
        $ActorEditor.BottomPanelMapPreview.Show()
    })

    # Close Button
    $X = $ActorEditor.Dialog.Left + ($ActorEditor.Dialog.Width / 3)
    $Y = $ActorEditor.Dialog.Height - (DPISize 90)
    $CloseButton           = CreateButton -X $X -Y $Y -Width (DPISize 90) -Height (DPISize 35) -Text "Close" -AddTo $ActorEditor.Dialog
    $CloseButton.BackColor = "White"
    $CloseButton.Add_Click({ $ActorEditor.Dialog.Hide() })

    # Extract Button
    $ExtractButton           = CreateButton -X ($CloseButton.Right + (DPISize 15)) -Y $CloseButton.Top -Width $CloseButton.Width -Height $CloseButton.Height -Text "Extract Scenes" -AddTo $ActorEditor.Dialog
    $ExtractButton.BackColor = "White"
    $ExtractButton.Add_Click({
        $lastMessage = $StatusLabel.Text
        EnableGUI $False
        RunAllScenes
        EnableGUI $True
        PlaySound $Sounds.done
        Cleanup
        UpdateStatusLabel $lastMessage
    })

    # Reset Map Button
    $ActorEditor.ResetMapButton           = CreateButton -X ($ExtractButton.Right + (DPISize 15)) -Y $ExtractButton.Top -Width $ExtractButton.Width -Height $ExtractButton.Height -Text "Reset Map" -AddTo $ActorEditor.Dialog
    $ActorEditor.ResetMapButton.BackColor = "White"
    $ActorEditor.ResetMapButton.Enabled   = $False
    $ActorEditor.ResetMapButton.Add_Click({
        $lastMessage = $StatusLabel.Text
        EnableGUI $False
        RunAllScenes -Current
        EnableGUI $True
        PlaySound $Sounds.done
        Cleanup
        UpdateStatusLabel $lastMessage
    })

    # Normal Quest Button
    $NormalQuestButton           = CreateButton -X ($ActorEditor.ResetMapButton.Right + (DPISize 15)) -Y $ActorEditor.ResetMapButton.Top -Width $ActorEditor.ResetMapButton.Width -Height $ActorEditor.ResetMapButton.Height -Text "Reset Quest" -AddTo $ActorEditor.Dialog
    $NormalQuestButton.BackColor = "White"
    $NormalQuestButton.Add_Click({
        $ActorEditor.NormalQuest.Checked = $True

        if ($GameType.mode -eq "Ocarina of Time") {
            $Settings["Dungeon"]["Inside the Deku Tree"]     = 1
            $Settings["Dungeon"]["Dodongo's Cavern"]         = 1
            $Settings["Dungeon"]["Inside Jabu-Jabu's Belly"] = 1
            $Settings["Dungeon"]["Forest Temple"]            = 1
            $Settings["Dungeon"]["Fire Temple"]              = 1
            $Settings["Dungeon"]["Water Temple"]             = 1
            $Settings["Dungeon"]["Shadow Temple"]            = 1
            $Settings["Dungeon"]["Spirit Temple"]            = 1
            $Settings["Dungeon"]["Ice Cavern"]               = 1
            $Settings["Dungeon"]["Bottom of the Well"]       = 1
            $Settings["Dungeon"]["Gerudo Training Ground"]   = 1
            $Settings["Dungeon"]["Inside Ganon's Castle"]    = 1
        }

        $lastMessage = $StatusLabel.Text
        UpdateStatusLabel "All dungeons have been set to Normal Quest again" -Editor
        UpdateStatusLabel $lastMessage
    })

    # Patch Scenes Button
    $PatchButton           = CreateButton -X ($NormalQuestButton.Right + (DPISize 15)) -Y $NormalQuestButton.Top -Width $NormalQuestButton.Width -Height $NormalQuestButton.Height -Text "Patch Scenes" -AddTo $ActorEditor.Dialog
    $PatchButton.BackColor = "White"
    $PatchButton.Add_Click({
        SaveMap -Scene $Files.json.actorEditor.scenes[$ActorEditor.Scenes.SelectedIndex] -Index $ActorEditor.Maps.SelectedIndex
        $lastMessage = $StatusLabel.Text
        EnableGUI $False
        RunAllScenes -Patch
        EnableGUI $True
        PlaySound $Sounds.done
        Cleanup
        UpdateStatusLabel $lastMessage
    })

    # Status Panel
    $ActorEditor.StatusPanel = CreatePanel -X (DPISize 10) -Y ( ($CloseButton.Top) + (DPISize 5) ) -Width (DPISize 300)                                    -Height (DPISize 25)                            -AddTo $ActorEditor.Dialog
    $ActorEditor.StatusLabel = CreateLabel -X (DPISize 10) -Y (DPISize 3)                          -Width ($ActorEditor.StatusPanel.Width - (DPISize 5)  ) -Height (DPISize 15) -Text "Awaiting action..." -AddTo $ActorEditor.StatusPanel
    $ActorEditor.StatusPanel.BackColor = 'White'

    $name = "Editor.Scene." + $Files.json.actorEditor.parse
    $Label               = CreateLabel    -X (DPISize 10)                              -Y (DPISize 17)                                 -Width (DPISize 40)  -Height (DPISize 15) -Font $Fonts.SmallBold -Text "Scene:"      -AddTo $ActorEditor.TopGroup
    $ActorEditor.Scenes  = CreateComboBox -X ($Label.Right + (DPISize 15) )            -Y ($Label.Top - (DPISize 2) )                  -Width (DPISize 260) -Height (DPISize 20) -Items $Files.json.actorEditor.scenes.Name -AddTo $ActorEditor.TopGroup -Name $name
    $Label               = CreateLabel    -X (DPISize 10)                              -Y ($ActorEditor.Scenes.Bottom + (DPISize 12) ) -Width (DPISize 40)  -Height (DPISize 15) -Font $Fonts.SmallBold -Text "Map:"        -AddTo $ActorEditor.TopGroup
    $ActorEditor.Maps    = CreateComboBox -X ($Label.Right + (DPISize 15) )            -Y ($Label.Top - (DPISize 2) )                  -Width (DPISize 260) -Height (DPISize 20)                                            -AddTo $ActorEditor.TopGroup
    $ActorEditor.Headers = CreateComboBox -X ($ActorEditor.Maps.Right + (DPISize 15) ) -Y $ActorEditor.Maps.Top                        -Width (DPISize 260) -Height (DPISize 20)                                            -AddTo $ActorEditor.TopGroup

    $ActorEditor.NormalQuestLabel = CreateLabel    -X ($ActorEditor.Scenes.Right           + (DPISize 15) ) -Y (DPISize 15)                      -Width (DPISize 80)  -Height (DPISize 15) -Font $Fonts.SmallBold -Text "Original:"     -AddTo $ActorEditor.TopGroup
    $ActorEditor.NormalQuest      = CreateCheckBox -X ($ActorEditor.NormalQuestLabel.Right + (DPISize 15) ) -Y (DPISize 13)                      -IsRadio                                                                               -AddTo $ActorEditor.TopGroup -Checked $True
    $ActorEditor.MasterQuestLabel = CreateLabel    -X ($ActorEditor.NormalQuest.Right      + (DPISize 15) ) -Y $ActorEditor.NormalQuestLabel.Top -Width (DPISize 80)  -Height (DPISize 15) -Font $Fonts.SmallBold -Text "Master Quest:" -AddTo $ActorEditor.TopGroup
    $ActorEditor.MasterQuest      = CreateCheckBox -X ($ActorEditor.MasterQuestLabel.Right + (DPISize 15) ) -Y $ActorEditor.NormalQuest.Top      -IsRadio                                                                               -AddTo $ActorEditor.TopGroup
    $ActorEditor.uraQuestLabel    = CreateLabel    -X ($ActorEditor.MasterQuest.Right      + (DPISize 15) ) -Y $ActorEditor.NormalQuestLabel.Top -Width (DPISize 80)  -Height (DPISize 15) -Font $Fonts.SmallBold -Text "Ura Quest:"    -AddTo $ActorEditor.TopGroup
    $ActorEditor.UraQuest         = CreateCheckBox -X ($ActorEditor.UraQuestLabel.Right    + (DPISize 15) ) -Y $ActorEditor.NormalQuest.Top      -IsRadio                                                                               -AddTo $ActorEditor.TopGroup
    $ActorEditor.NormalQuest.Visible = $ActorEditor.MasterQuest.Visible = $ActorEditor.UraQuest.Visible = $ActorEditor.NormalQuestLabel.Visible = $ActorEditor.MasterQuestLabel.Visible = $ActorEditor.UraQuestLabel.Visible = $False

    $ActorEditor.NormalQuest.Add_CheckedChanged( {
        if ($ActorEditor.NormalQuest.Visible -and $ActorEditor.NormalQuest.Enabled -and $ActorEditor.NormalQuest.Checked) {
            $Settings["Dungeon"][$ActorEditor.Scenes.Text] = 1
            LoadScene $Files.json.actorEditor.scenes[$ActorEditor.Scenes.SelectedIndex]
        }
    } )
    $ActorEditor.MasterQuest.Add_CheckedChanged( {
        if ($ActorEditor.MasterQuest.Visible -and $ActorEditor.MasterQuest.Enabled -and $ActorEditor.MasterQuest.Checked) {
            $Settings["Dungeon"][$ActorEditor.Scenes.Text] = 2
            LoadScene $Files.json.actorEditor.scenes[$ActorEditor.Scenes.SelectedIndex]
        }
    } )
    $ActorEditor.UraQuest.Add_CheckedChanged( {
        if ($ActorEditor.UraQuest.Visible -and $ActorEditor.UraQuest.Enabled -and $ActorEditor.UraQuest.Checked) {
            $Settings["Dungeon"][$ActorEditor.Scenes.Text] = 3
            LoadScene $Files.json.actorEditor.scenes[$ActorEditor.Scenes.SelectedIndex]
        }
    } )

    $ActorEditor.Scenes.Add_SelectedIndexChanged({ LoadScene $Files.json.actorEditor.scenes[$ActorEditor.Scenes.SelectedIndex] })
    LoadScene $Files.json.actorEditor.scenes[$ActorEditor.Scenes.SelectedIndex]

    $ActorEditor.Maps.Add_SelectedIndexChanged({
        if (IsSet $ActorEditor.LastMap) { SaveMap -Scene $ActorEditor.LastScene -Index $ActorEditor.LastMap }
        LoadMap -Scene $Files.json.actorEditor.scenes[$ActorEditor.Scenes.SelectedIndex]
        $ActorEditor.LastScene = $Files.json.actorEditor.scenes[$ActorEditor.Scenes.SelectedIndex]
        $ActorEditor.LastMap   = $ActorEditor.Scenes.SelectedIndex
    })

    LoadMap    -Scene $Files.json.actorEditor.scenes[$ActorEditor.Scenes.SelectedIndex]
    LoadHeader -Scene $Files.json.actorEditor.scenes[$ActorEditor.Scenes.SelectedIndex]

    $ActorEditor.Headers.Add_SelectedIndexChanged({
        LoadHeader -Scene $Files.json.actorEditor.scenes[$ActorEditor.Scenes.SelectedIndex]
    })

    if (IsSet ($Settings["Core"]["Editor.Map." + $Files.json.actorEditor.parse]) -and $ActorEditor.Maps.Items.Count -gt 0) {
        if ([byte]$Settings["Core"]["Editor.Map." + $Files.json.actorEditor.parse] -le $ActorEditor.Maps.Items.Count) {
            $ActorEditor.Maps.SelectedIndex = $Settings["Core"]["Editor.Map." + $Files.json.actorEditor.parse] - 1
        }
    }

    if (IsSet ($Settings["Core"]["Editor.Header." + $Files.json.actorEditor.parse]) -and $ActorEditor.Headers.Items.Count -gt 0) {
        if ([byte]$Settings["Core"]["Editor.Header." + $Files.json.actorEditor.parse] -le $ActorEditor.Headers.Items.Count) {
            $ActorEditor.Headers.SelectedIndex = $Settings["Core"]["Editor.Header." + $Files.json.actorEditor.parse] - 1
        }
    }

}



#==============================================================================================================================================================================================
function RunActorEditor([string]$Game=$GameType.mode, [string]$Checksum) {
    
    $LastGame    = $GameType
    $LastConsole = $GameConsole

    $GameConsole = $Files.json.consoles[0]
    if     ($Game -eq "Ocarina of Time")   { $global:GameType = $Files.json.games[0] }
    elseif ($Game -eq "Majora's Mask")     { $global:GameType = $Files.json.games[1] }

    CreateActorEditorDialog -Game $Game
    $ActorEditor.Dialog.ShowDialog()

    if ($ActorEditor.Maps.Items.Count -gt 0) {
        SaveMap -Scene $Files.json.actorEditor.scenes[$ActorEditor.Scenes.SelectedIndex] -Index $ActorEditor.Maps.SelectedIndex
        $Settings["Core"]["Editor.Map."    + $Files.json.actorEditor.parse] = $ActorEditor.Maps.SelectedIndex    + 1
        $Settings["Core"]["Editor.Header." + $Files.json.actorEditor.parse] = $ActorEditor.Headers.SelectedIndex + 1
    }

    $global:ByteScriptArray = $global:ByteTableArray = $Files.json.actorEditor = $global:ActorEditor = $null
    $global:GameType        = $LastGame
    $global:GameConsole     = $LastConsole

}



#==============================================================================================================================================================================================
function RunAllScenes([switch]$Patch, [switch]$Current) {
    
    if (!(IsSet $GamePath)) {
        UpdateStatusLabel -Text "Failed! No ROM path is given." -Editor
        return
    }

    UpdateStatusLabel -Text "Preparing ROM..." -Editor
    Cleanup
    $global:PatchInfo     = @{}
    $PatchInfo.decompress = $True
    $global:CheckHashSum  = $Files.json.actorEditor.hash
    $global:ROMFile       = SetROMParameters -Path $GamePath
    SetGetROM

    if ($IsWiiVC) {
        if (!(ExtractWADFile))    { return }   # Step A: Extract the contents of the WAD file
        if (!(CheckVCGameID))     { return }   # Step B: Check the GameID to be vanilla
        if (!(ExtractU8AppFile))  { return }   # Step C: Extract "00000005.app" file to get the ROM
        if (!(PatchVCROM))        { return }   # Step D: Do some initial patching stuff for the ROM for VC WAD files
    }

    if (!(Unpack)) {
        UpdateStatusLabel "Failed! Could not extract ROM."
        return
    }
    if (TestFile $GetROM.run)                                                   { $global:ROMHashSum   = (Get-FileHash -Algorithm MD5 -LiteralPath $GetROM.run).Hash }
    if ($Settings.Debug.IgnoreChecksum -eq $False -and (IsSet $CheckHashsum))   { $PatchInfo.downgrade = ($ROMHashSum -ne $CheckHashSum)                             }
    if ((Get-Item -LiteralPath $GetROM.run).length/"32MB" -ne 1) {
        UpdateStatusLabel "Failed! The ROM should be 32 MB!"
        return $False
    }

    if ($PatchInfo.run) {
        ConvertROM $Command
        if (!(CompareHashSums $Command)) {
            UpdateStatusLabel "Failed! The ROM is an incorrect version or is broken."
            return
        }
    }

    if (!(DecompressROM)) {
        UpdateStatusLabel "Failed! The ROM could not be compressed."
        return
    }
    $item = DowngradeROM
    if ($ROMHashSum -ne $CheckHashSum) {
        UpdateStatusLabel "Failed! The ROM is an incorrect version or is broken."
        return
    }

    if ($Patch) {
        UpdateStatusLabel -Text "Patching all scenes..." -Editor
        Copy-Item -LiteralPath $GetROM.decomp -Destination $GetROM.cleanDecomp -Force

        if (PatchAllScenes) {
            [System.IO.File]::WriteAllBytes($GetROM.decomp, $ByteArrayGame)
            & $Files.tool.flips --create --bps $GetROM.cleanDecomp $GetROM.decomp $GameFiles.scenesPatch | Out-Null
            UpdateStatusLabel -Text "Success! A patch has been generated." -Editor
        }
        else { UpdateStatusLabel -Text "Failed! Extracted scenes were missing." -Editor }
    }
    elseif ($Current) {
        UpdateStatusLabel -Text "Resetting the map..." -Editor

        if ($GameType.mode -eq "Ocarina of Time") {
            if ($ActorEditor.MasterQuest.Visible -and $ActorEditor.MasterQuest.Checked) {
                ApplyPatch -File $GetROM.decomp -Patch ("Games\" + $GameType.mode + "\Decompressed\Dungeons\master_quest.bps") -FilesPath
                ExtractAllScenes -Current -Quest "Master Quest"
            }
            elseif ($ActorEditor.UraQuest.Visible -and $ActorEditor.UraQuest.Checked) {
                ApplyPatch -File $GetROM.decomp -Patch ("Games\" + $GameType.mode + "\Decompressed\Dungeons\ura_quest.bps")    -FilesPath
                ExtractAllScenes -Current -Quest "Ura Quest"
            }
            else { ExtractAllScenes -Current }
        }
        else { ExtractAllScenes -Current }

        UpdateStatusLabel -Text "Success! The map has been reset." -Editor
        LoadMap $Files.json.actorEditor.scenes[$ActorEditor.Scenes.SelectedIndex]
    }
    else {
        UpdateStatusLabel -Text "Extracting all scenes..." -Editor

        if (TestFile -Path ($Paths.Games + "\" + $GameType.mode + "\Editor\Scenes") -Container) { RemovePath ($Paths.Games + "\" + $GameType.mode + "\Editor\Scenes") }
        CreateSubPath ($Paths.Games + "\" + $GameType.mode + "\Editor\Scenes")

        Copy-Item -LiteralPath $GetROM.decomp -Destination $GetROM.cleanDecomp -Force
        ExtractAllScenes

        if ($GameType.mode -eq "Ocarina of Time") {
            if (TestFile -Path ($Paths.Games + "\Ocarina of Time\decompressed\Dungeons\master_quest.bps") ) {
                ApplyPatch -File $GetROM.cleanDecomp -Patch ("Games\" + $GameType.mode + "\Decompressed\Dungeons\master_quest.bps") -FilesPath -New $GetROM.decomp
                ExtractAllScenes -Quest "Master Quest"
            }

            if (TestFile -Path ($Paths.Games + "\Ocarina of Time\decompressed\Dungeons\ura_quest.bps") ) {
                ApplyPatch -File $GetROM.cleanDecomp -Patch ("Games\" + $GameType.mode + "\Decompressed\Dungeons\ura_quest.bps")    -FilesPath -New $GetROM.decomp
                ExtractAllScenes -Quest "Ura Quest"
            }
        }

        UpdateStatusLabel -Text "Success! The scenes have been extracted." -Editor
        LoadScene $Files.json.actorEditor.scenes[$ActorEditor.Scenes.SelectedIndex]
    }

    Cleanup

}


#==============================================================================================================================================================================================
function ExtractAllScenes([switch]$Current, [String]$Quest="Normal Quest") {
    
    $global:ByteArrayGame = [System.IO.File]::ReadAllBytes($GetROM.decomp)

    if ($Current) {
        foreach ($scene in $Files.json.actorEditor.scenes) {
            if ($scene.name -eq $ActorEditor.Scenes.Text) { break }
        }
        if ($scene -eq $null) { return }

        if ($Scene.dungeon -eq 1 -and $Quest -ne "Normal Quest") {
            CreateSubPath      ($Paths.Games + "\" + $GameType.mode + "\Editor\Scenes\" + $Scene.name + "\" + $Quest)
            ExtractScene -Path ($Paths.Games + "\" + $GameType.mode + "\Editor\Scenes\" + $Scene.name + "\" + $Quest) -Offset $scene.dma -Length $scene.length -Current
        }
        elseif ($Quest -eq "Normal Quest") { ExtractScene -Path ($Paths.Games + "\" + $GameType.mode + "\Editor\Scenes\" + $scene.name) -Offset $scene.dma -Length $scene.length -Current }
    }
    else {
        foreach ($scene in $Files.json.actorEditor.scenes) {
            if ($scene.dungeon -eq 1 -and $Quest -ne "Normal Quest") {
                CreateSubPath ($Paths.Games + "\" + $GameType.mode + "\Editor\Scenes\" + $Scene.name + "\" + $Quest)
                ExtractScene -Path ($Paths.Games + "\" + $Files.json.actorEditor.game + "\Editor\Scenes\" + $Scene.name + "\" + $Quest) -Offset $scene.dma -Length $scene.length
            }
            elseif ($Quest -eq "Normal Quest") { ExtractScene -Path ($Paths.Games + "\" + $Files.json.actorEditor.game + "\Editor\Scenes\" + $scene.name) -Offset $scene.dma -Length $scene.length }
        }
    }

}



#==============================================================================================================================================================================================
function ExtractScene([switch]$Current, [string]$Path, [string]$Offset, [byte]$Length) {
    
    $End   = Get24Bit ( (GetDecimal $Offset) + ($Length * 16) + 16)
    $Table = $ByteArrayGame[(GetDecimal $Offset)..(GetDecimal $End)]
    CreateSubPath $Path

    if (!$Current) { ExportBytes -Offset $Offset -End $End -Output ($Path + "\table.dma") }
    
    for ($i=0; $i -le $Length; $i++) {
        $Start = (Get8Bit $Table[($i*16)+0]) + (Get8Bit $Table[($i*16)+1]) + (Get8Bit $Table[($i*16)+2]) + (Get8Bit $Table[($i*16)+3])
        $End   = (Get8Bit $Table[($i*16)+4]) + (Get8Bit $Table[($i*16)+5]) + (Get8Bit $Table[($i*16)+6]) + (Get8Bit $Table[($i*16)+7])

        if ($Current -and ($i-1) -ne $ActorEditor.Maps.SelectedIndex) { continue }

        if ($i -eq 0 -and !$Current)   { ExportBytes -Offset $Start -End $End -Output ($Path + "\scene.zscene")             -Force }
        else                           { ExportBytes -Offset $Start -End $End -Output ($Path + "\room_" + ($i-1) + ".zmap") -Force }
    }

    $dmaArray   = [System.IO.File]::ReadAllBytes($Path + "\table.dma")
    $sceneArray = [System.IO.File]::ReadAllBytes($Path + "\scene.zscene")

    $headerSize     = 104
    $mapStart       = @()

    for ($i=0; $i -lt $headerSize; $i+=8) {
        if     ($sceneArray[$i] -eq 20)   { break }
        elseif ($sceneArray[$i] -eq 0)    { $positionsStart = $sceneArray[$i + 5] * 65536 + $sceneArray[$i + 6] * 256 + $sceneArray[$i + 7] } # Start Positions List
        elseif ($sceneArray[$i] -eq 4)    { $mapStart      += $sceneArray[$i + 5] * 65536 + $sceneArray[$i + 6] * 256 + $sceneArray[$i + 7] } # Map List
        elseif ($sceneArray[$i] -eq 24)   { $alternateStart = $sceneArray[$i + 5] * 65536 + $sceneArray[$i + 6] * 256 + $sceneArray[$i + 7] } # Alternate Headers
    }

    if (IsSet $alternateStart) {
        for ($i=$alternateStart; $i -lt $positionsStart; $i+=4) {
            if ($sceneArray[$i] -ne 2) { continue }
            $headerOffset = $sceneArray[$i + 1] * 65536 + $sceneArray[$i + 2] * 256 + $sceneArray[$i + 3]

            for ($j=$headerOffset; $j -lt ($headerOffset + $headerSize); $j+=8) {
                if     ($sceneArray[$j] -eq 20)   { break }
                elseif ($sceneArray[$j] -eq 4)    { $mapStart += $sceneArray[$j + 5] * 65536 + $sceneArray[$j + 6] * 256 + $sceneArray[$j + 7] } # Map List
            }
        }
    }

    for ($i=0; $i -lt $Length; $i++) {
        $start = $dmaArray[$i*16+4] * 0x1000000 + $dmaArray[$i*16+4+1] * 0x10000 + $dmaArray[$i*16+4+2] * 0x100 + $dmaArray[$i*16+4+3]
        $end   = $start + (Get-Item -Path ($Path + "\room_" + $i + ".zmap")).Length
        
        $start = (Get32Bit $start) -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) }
        $end   = (Get32Bit $end)   -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) }

        for ($j=0; $j -lt $mapStart.Count; $j++) {
            $sceneArray[$mapStart[$j] + (8 * $i) + 0] = $start[0]
            $sceneArray[$mapStart[$j] + (8 * $i) + 1] = $start[1]
            $sceneArray[$mapStart[$j] + (8 * $i) + 2] = $start[2]
            $sceneArray[$mapStart[$j] + (8 * $i) + 3] = $start[3]
            $sceneArray[$mapStart[$j] + (8 * $i) + 4] = $end[0]
            $sceneArray[$mapStart[$j] + (8 * $i) + 5] = $end[1]
            $sceneArray[$mapStart[$j] + (8 * $i) + 6] = $end[2]
            $sceneArray[$mapStart[$j] + (8 * $i) + 7] = $end[3]
        }

        $index = 16 * $i + 16
        $dmaArray[$index + 0] = $dmaArray[$index + 8]  = $start[0]
        $dmaArray[$index + 1] = $dmaArray[$index + 9]  = $start[1]
        $dmaArray[$index + 2] = $dmaArray[$index + 10] = $start[2]
        $dmaArray[$index + 3] = $dmaArray[$index + 11] = $start[3]
        $dmaArray[$index + 4] = $end[0]
        $dmaArray[$index + 5] = $end[1]
        $dmaArray[$index + 6] = $end[2]
        $dmaArray[$index + 7] = $end[3]
    }
    [System.IO.File]::WriteAllBytes(($Path + "\table.dma"),     $dmaArray)
    [System.IO.File]::WriteAllBytes(($Path + "\scene.zscene"),  $sceneArray)
}



#==============================================================================================================================================================================================
function PatchAllScenes() {
    
    $global:ByteArrayGame = [System.IO.File]::ReadAllBytes($GetROM.decomp)

    foreach ($scene in $Files.json.actorEditor.scenes) {
        if (!(PatchScene -Path ("Scenes\" + $Scene.name) -Offset $Scene.dma -Length $Scene.length -Scene $scene)) { return $False }
    }
    return $True
    
}



#==============================================================================================================================================================================================
function PatchScene([string]$Path, [string]$Offset, [byte]$Length, [object]$Scene) {
    
    if ($Scene.Dungeon -eq 1 -and (IsSet $Settings["Dungeon"][$ActorEditor.Scenes.Text]) ) {
        if     ($Settings["Dungeon"][$Scene.Name] -eq 2)   { $path += "\Master Quest" }
        elseif ($Settings["Dungeon"][$Scene.Name] -eq 3)   { $path += "\Ura Quest"    }
    }

    if (!(TestFile -Path ($Paths.Games + "\" + $GameType.mode + "\Editor\" + $Path) -Container)) { return $False }

    $Start = Get24Bit ( (GetDecimal $Offset) )
    $End   = Get24Bit ( (GetDecimal $Start) + ($Length * 16) + 16)

    $dmaArray = [System.IO.File]::ReadAllBytes(($Paths.Games + "\" + $GameType.mode + "\Editor\" + $Path + "\table.dma"))
    for ($i=0; $i -lt $dmaArray.Count; $i++) { $ByteArrayGame[(GetDecimal $Start) + $i] = $dmaArray[$i] }

    $table = $ByteArrayGame[(GetDecimal $Start)..(GetDecimal $End)]
    for ($i=0; $i -le $Length; $i++) {
        $offset = (Get8Bit $table[($i*16)+0]) + (Get8Bit $table[($i*16)+1]) + (Get8Bit $table[($i*16)+2]) + (Get8Bit $table[($i*16)+3])
        if ($i -eq 0)   { PatchBytes -Offset $offset -Patch ($Path + "\scene.zscene")             -Editor }
        else            { PatchBytes -Offset $offset -Patch ($Path + "\room_" + ($i-1) + ".zmap") -Editor }
    }

    return $True

}


#==============================================================================================================================================================================================
function SaveMap([object[]]$Scene, [byte]$Index) {
    
    $map = $Paths.Games + "\" + $Files.json.actorEditor.game + "\Editor\Scenes\" + $Scene.Name

    if ($Scene.Dungeon -eq 1 -and (IsSet $Settings["Dungeon"][$ActorEditor.Scenes.Text]) ) {
        if     ($Settings["Dungeon"][$ActorEditor.Scenes.Text] -eq 2)   { $map += "\Master Quest" }
        elseif ($Settings["Dungeon"][$ActorEditor.Scenes.Text] -eq 3)   { $map += "\Ura Quest"    }
    }

    $dma  = $map + "\table.dma"
    $file = $map + "\scene.zscene"
    $map += "\room_" + $Index + ".zmap"
    
    if (!(TestFile -Path $map) -or !(TestFile -Path $file) -or !(TestFile -Path $dma)) { return }

    [System.Collections.ArrayList]$dmaArray = [System.IO.File]::ReadAllBytes($dma)

    for ($i=0; $i-lt $Scene.length; $i++) {
        $mapStart = $dmaArray[$i*16+4] * 0x1000000 + $dmaArray[$i*16+4+1] * 0x10000 + $dmaArray[$i*16+4+2] * 0x100 + $dmaArray[$i*16+4+3]
        $mapEnd   = $mapStart + $ActorEditor.MapArray.Count
    
        $mapStart = (Get32Bit $mapStart) -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) }
        $mapEnd   = (Get32Bit $mapEnd)   -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) }

        for ($j=0; $j-lt $ActorEditor.Sceneoffsets.MapStart.Count; $j++) {
            $ActorEditor.SceneArray[$ActorEditor.Sceneoffsets[$j].MapStart+0 + $i*8] = $mapStart[0]
            $ActorEditor.SceneArray[$ActorEditor.Sceneoffsets[$j].MapStart+1 + $i*8] = $mapStart[1]
            $ActorEditor.SceneArray[$ActorEditor.Sceneoffsets[$j].MapStart+2 + $i*8] = $mapStart[2]
            $ActorEditor.SceneArray[$ActorEditor.Sceneoffsets[$j].MapStart+3 + $i*8] = $mapStart[3]
            $ActorEditor.SceneArray[$ActorEditor.Sceneoffsets[$j].MapStart+4 + $i*8] = $mapEnd[0]
            $ActorEditor.SceneArray[$ActorEditor.Sceneoffsets[$j].MapStart+5 + $i*8] = $mapEnd[1]
            $ActorEditor.SceneArray[$ActorEditor.Sceneoffsets[$j].MapStart+6 + $i*8] = $mapEnd[2]
            $ActorEditor.SceneArray[$ActorEditor.Sceneoffsets[$j].MapStart+7 + $i*8] = $mapEnd[3]
        }
        
        $j = 16 * $i + 16
        $dmaArray[$j + 0] = $dmaArray[$j + 8]  = $mapStart[0]
        $dmaArray[$j + 1] = $dmaArray[$j + 9]  = $mapStart[1]
        $dmaArray[$j + 2] = $dmaArray[$j + 10] = $mapStart[2]
        $dmaArray[$j + 3] = $dmaArray[$j + 11] = $mapStart[3]
        $dmaArray[$j + 4] = $mapEnd[0]
        $dmaArray[$j + 5] = $mapEnd[1]
        $dmaArray[$j + 6] = $mapEnd[2]
        $dmaArray[$j + 7] = $mapEnd[3]
    }

    [System.IO.File]::WriteAllBytes($map,  $ActorEditor.MapArray)
    [System.IO.File]::WriteAllBytes($file, $ActorEditor.SceneArray)
    [System.IO.File]::WriteAllBytes($dma,  $dmaArray)

}



#==============================================================================================================================================================================================
function ChangeMap([string]$Offset, [object]$Values) {
    
    if     ($Values -is [String] -and $Values -Like "* *")              { $ValuesDec = $Values -split ' '           | foreach { [Convert]::ToByte($_, 16) } }
    elseif ($Values -is [String])                                       { $ValuesDec = $Values -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) } }
    elseif ($Values -is [Array]  -and $Values[0] -is [System.String])   { $ValuesDec = $Values                      | foreach { [Convert]::ToByte($_, 16) } }
    else                                                                { $ValuesDec = $Values }

    $OffsetDec = GetDecimal $Offset

    foreach ($i in 0..($ValuesDec.Length-1)) {
        $ActorEditor.MapArray[$OffsetDec + $i]  = $ValuesDec[$i]
    }

    WriteToConsole ($Offset + " -> Change values: " + $Values)

}



#==============================================================================================================================================================================================
function ShiftMap([uint32]$Offset, [byte]$Add=0, [byte]$Subtract=0) {
    
    if ($Add -gt 0) {
        if ($ActorEditor.MapArray[$Offset+2] + $Add -gt 255) {
            if ($ActorEditor.MapArray[$Offset+1] + 1 -gt 255) {
                $ActorEditor.MapArray[$Offset]   += 1
                $ActorEditor.MapArray[$Offset+1]  = 0
                $ActorEditor.MapArray[$Offset+2] += $Add - 256
            }
            else {
                $ActorEditor.MapArray[$Offset+1]++
                $ActorEditor.MapArray[$Offset+2] += $Add - 256
            }
        }
        else { $ActorEditor.MapArray[$Offset+2] += $Add }
    }
    elseif ($Subtract -gt 0) {
        if ($ActorEditor.MapArray[$Offset+2] - $Subtract -lt 0) {
            if ($ActorEditor.MapArray[$Offset+1] - 1 -lt 0) {
                $ActorEditor.MapArray[$Offset]   -= 1
                $ActorEditor.MapArray[$Offset+1]  = 0
                $ActorEditor.MapArray[$Offset+2] += 256 - $Subtract
            }
            else {
                $ActorEditor.MapArray[$Offset+1]--
                $ActorEditor.MapArray[$Offset+2] += 256 - $Subtract
            }
        }
        else { $ActorEditor.MapArray[$Offset+2] -= $Subtract }
    }

}



#==============================================================================================================================================================================================
function LoadScene([object[]]$Scene) {
    
    $ActorEditor.NormalQuest.Enabled = $ActorEditor.MasterQuest.Enabled = $ActorEditor.UraQuest.Enabled = $False
    $ActorEditor.NormalQuest.Visible = $ActorEditor.MasterQuest.Visible = $ActorEditor.UraQuest.Visible = $ActorEditor.NormalQuestLabel.Visible = $ActorEditor.MasterQuestLabel.Visible = $ActorEditor.UraQuestLabel.Visible = $Scene.Dungeon -eq 1
    
    $folder = $Paths.Games + "\" + $Files.json.actorEditor.game + "\Editor\Scenes\" + $Scene.name
    $file   = $Paths.Games + "\" + $Files.json.actorEditor.game + "\Editor\Scenes\" + $Scene.name + "\scene.zscene"

    if ($Scene.Dungeon -eq 1) {
        if (IsSet $Settings["Dungeon"][$ActorEditor.Scenes.Text]) {
            if ($Settings["Dungeon"][$ActorEditor.Scenes.Text] -eq 1) { $ActorEditor.NormalQuest.Checked = $True }
            elseif ($Settings["Dungeon"][$ActorEditor.Scenes.Text] -eq 2) {
                $ActorEditor.MasterQuest.Checked = $True
                $folder += "\Master Quest"
            }
            elseif ($Settings["Dungeon"][$ActorEditor.Scenes.Text] -eq 3) {
                $ActorEditor.UraQuest.Checked = $True
                $folder += "\Ura Quest"
            }
            else { $ActorEditor.NormalQuest.Checked = $True }
        }
        else { $ActorEditor.NormalQuest.Checked = $True }

        if     ($ActorEditor.MasterQuest.Checked)   { $file = $Paths.Games + "\" + $Files.json.actorEditor.game + "\Editor\Scenes\" + $Scene.name + "\Master Quest\scene.zscene" }
        elseif ($ActorEditor.UraQuest.Checked)      { $file = $Paths.Games + "\" + $Files.json.actorEditor.game + "\Editor\Scenes\" + $Scene.name + "\Ura Quest\scene.zscene"    }
    }

    if (!(TestFile -Path $folder -Container) -or !(TestFile -Path $file)) { return }

    $ActorEditor.Maps.Items.Clear()
    $items = (Get-ChildItem -Path $folder -Filter "*.zmap" -File)

    if ($items.Count -eq 0) { return }

    for ($i=0; $i -lt $items.Count; $i++) {
        $title = "Map " + ($i+1)
        if ($Scene.maps -is [array]) {
            if ($Scene.maps[$i] -ne 0 -and $Scene.maps[$i] -ne "") {
                if ($i -lt 9) { $title += "  " }
                $title += "   (" + $Scene.maps[$i] + ")"
            }
        }
        $ActorEditor.Maps.Items.Add($title)
    }

    $ActorEditor.Maps.SelectedIndex = 0

    # Load scene file #
    $headerSize = 104
    [System.Collections.ArrayList]$ActorEditor.SceneArray = [System.IO.File]::ReadAllBytes($file)
    $ActorEditor.SceneOffsets          = @()
    $ActorEditor.SceneOffsets         += @{}
    $ActorEditor.SceneOffsets[0].Header= 0

    for ($i=0; $i -lt $headerSize; $i+=8) {
        if ($ActorEditor.SceneArray[$i] -eq 20) { break }

        elseif ($ActorEditor.SceneArray[$i] -eq 0) { # Start Positions List
            $ActorEditor.SceneOffsets[0].PositionsCount      = $ActorEditor.SceneArray[$i + 1]
            $ActorEditor.SceneOffsets[0].PositionsStart      = $ActorEditor.SceneArray[$i + 5] * 65536 + $ActorEditor.SceneArray[$i + 6] * 256 + $ActorEditor.SceneArray[$i + 7]
            $ActorEditor.SceneOffsets[0].PositionsCountIndex = $i + 1
            $ActorEditor.SceneOffsets[0].PositionsIndex      = $i + 5
        }
        elseif ($ActorEditor.SceneArray[$i] -eq 4) { # Map List
            $ActorEditor.SceneOffsets[0].MapCount            = $ActorEditor.SceneArray[$i + 1]
            $ActorEditor.SceneOffsets[0].MapStart            = $ActorEditor.SceneArray[$i + 5] * 65536 + $ActorEditor.SceneArray[$i + 6] * 256 + $ActorEditor.SceneArray[$i + 7]
            $ActorEditor.SceneOffsets[0].MapCountIndex       = $i + 1
            $ActorEditor.SceneOffsets[0].MapIndex            = $i + 5
        }
        elseif ($ActorEditor.SceneArray[$i] -eq 24) { # Alternate Headers
            $ActorEditor.SceneOffsets[0].AlternateStart      = $ActorEditor.SceneArray[$i + 5] * 65536 + $ActorEditor.SceneArray[$i + 6] * 256 + $ActorEditor.SceneArray[$i + 7]
            $ActorEditor.SceneOffsets[0].AlternateIndex      = $i + 5
        }
    }

    if (IsSet $ActorEditor.SceneOffsets[0].AlternateStart) {
        for ($i=$ActorEditor.SceneOffsets[0].AlternateStart; $i -lt $ActorEditor.SceneOffsets[0].PositionsStart; $i+=4) {
            if ($ActorEditor.SceneArray[$i] -ne 2) { continue }

            $ActorEditor.SceneOffsets += @{}
            $ActorEditor.SceneOffsets[$ActorEditor.SceneOffsets.Count-1].Header = $ActorEditor.SceneArray[$i + 1] * 65536 + $ActorEditor.SceneArray[$i + 2] * 256 + $ActorEditor.SceneArray[$i + 3]

            for ($j=$ActorEditor.SceneOffsets[$ActorEditor.SceneOffsets.Count-1].Header; $j -lt ($ActorEditor.SceneOffsets[$ActorEditor.SceneOffsets.Count-1].Header + $headerSize); $j+=8) {
                if ($ActorEditor.SceneArray[$j] -eq 20) { break }

                elseif ($ActorEditor.SceneArray[$j] -eq 4) { # Map List
                    $ActorEditor.SceneOffsets[$ActorEditor.SceneOffsets.Count-1].MapCount      = $ActorEditor.SceneArray[$j + 1]
                    $ActorEditor.SceneOffsets[$ActorEditor.SceneOffsets.Count-1].MapStart      = $ActorEditor.SceneArray[$j + 5] * 65536 + $ActorEditor.SceneArray[$j + 6] * 256 + $ActorEditor.SceneArray[$j + 7]
                    $ActorEditor.SceneOffsets[$ActorEditor.SceneOffsets.Count-1].MapCountIndex = $j + 1
                    $ActorEditor.SceneOffsets[$ActorEditor.SceneOffsets.Count-1].MapIndex      = $j + 5
                }
            }
        }
    }

}



#==============================================================================================================================================================================================
function LoadMap([object[]]$Scene) {
    
    $headerSize = 80
    $map = $Paths.Games + "\" + $Files.json.actorEditor.game + "\Editor\Scenes\" + $Scene.name + "\room_" + $ActorEditor.Maps.SelectedIndex + ".zmap"
    if ($Scene.Dungeon -eq 1) {
        if     ($ActorEditor.MasterQuest.Checked)   { $map = $Paths.Games + "\" + $Files.json.actorEditor.game + "\Editor\Scenes\" + $Scene.name + "\Master Quest\room_" + $ActorEditor.Maps.SelectedIndex + ".zmap" }
        elseif ($ActorEditor.UraQuest.Checked)      { $map = $Paths.Games + "\" + $Files.json.actorEditor.game + "\Editor\Scenes\" + $Scene.name + "\Ura Quest\room_"    + $ActorEditor.Maps.SelectedIndex + ".zmap" }
    }

    if (!(TestFile -Path $map)) { return }

    if ($ActorEditor.LastScene.name -ne $Scene.name) { $ActorEditor.Headers.Items.Clear() }
    [System.Collections.ArrayList]$ActorEditor.MapArray = [System.IO.File]::ReadAllBytes($map)
    $items                                              = @("Stage 1")
    $ActorEditor.Offsets                                = @()
    $ActorEditor.Offsets                               += @{}
    $ActorEditor.Offsets[0].Header                      = 0
    $ActorEditor.Offsets[0].FoundActors                 = $False
    $ActorEditor.Offsets[0].FoundObjects                = $False

    for ($i=0; $i -lt $headerSize; $i+=8) {
        if ($ActorEditor.MapArray[$i] -eq 20) { break }

        elseif ($ActorEditor.MapArray[$i] -eq 1) { # Actor List
            $ActorEditor.Offsets[0].ActorCount       = $ActorEditor.MapArray[$i + 1]
            $ActorEditor.Offsets[0].ActorStart       = $ActorEditor.MapArray[$i + 5] * 65536 + $ActorEditor.MapArray[$i + 6] * 256 + $ActorEditor.MapArray[$i + 7]
            $ActorEditor.Offsets[0].ActorCountIndex  = $i + 1
            $ActorEditor.Offsets[0].ActorIndex       = $i + 5
            $ActorEditor.Offsets[0].FoundActors      = $True
        }
        elseif ($ActorEditor.MapArray[$i] -eq 11) { # Objects List
            $ActorEditor.Offsets[0].ObjectCount      = $ActorEditor.MapArray[$i + 1]
            $ActorEditor.Offsets[0].ObjectStart      = $ActorEditor.MapArray[$i + 5] * 65536 + $ActorEditor.MapArray[$i + 6] * 256 + $ActorEditor.MapArray[$i + 7]
            $ActorEditor.Offsets[0].ObjectCountIndex = $i + 1
            $ActorEditor.Offsets[0].ObjectIndex      = $i + 5
            $ActorEditor.Offsets[0].FoundObjects     = $True
        }
        elseif ($ActorEditor.MapArray[$i] -eq 10) { # Mesh List
            $ActorEditor.Offsets[0].MeshStart        = $ActorEditor.MapArray[$i + 5] * 65536 + $ActorEditor.MapArray[$i + 6] * 256 + $ActorEditor.MapArray[$i + 7]
            $ActorEditor.Offsets[0].MeshIndex        = $i + 5
        }
        elseif ($ActorEditor.MapArray[$i] -eq 24) { # Alternate Headers
            $ActorEditor.Offsets[0].AlternateStart   = $ActorEditor.MapArray[$i + 5] * 65536 + $ActorEditor.MapArray[$i + 6] * 256 + $ActorEditor.MapArray[$i + 7]
            $ActorEditor.Offsets[0].AlternateIndex   = $i + 5
        }
    }

    if (IsSet $ActorEditor.Offsets[0].AlternateStart) {
        for ($i=$ActorEditor.Offsets[0].AlternateStart; $i -lt $ActorEditor.Offsets[0].ObjectStart; $i+=4) {
            if ($ActorEditor.MapArray[$i] -ne 3) { continue }

            $ActorEditor.Offsets += @{}
            $ActorEditor.Offsets[$ActorEditor.Offsets.Count-1].Header       = $ActorEditor.MapArray[$i + 1] * 65536 + $ActorEditor.MapArray[$i + 2] * 256 + $ActorEditor.MapArray[$i + 3]
            $ActorEditor.Offsets[$ActorEditor.Offsets.Count-1].FoundActors  = $False
            $ActorEditor.Offsets[$ActorEditor.Offsets.Count-1].FoundObjects = $False

            for ($j=$ActorEditor.Offsets[$ActorEditor.Offsets.Count-1].Header; $j -lt ($ActorEditor.Offsets[$ActorEditor.Offsets.Count-1].Header + $headerSize); $j+=8) {
                if ($ActorEditor.MapArray[$j] -eq 20) { break }

                elseif ($ActorEditor.MapArray[$j] -eq 1) { # Actor List
                    $ActorEditor.Offsets[$ActorEditor.Offsets.Count-1].ActorCount       = $ActorEditor.MapArray[$j + 1]
                    $ActorEditor.Offsets[$ActorEditor.Offsets.Count-1].ActorStart       = $ActorEditor.MapArray[$j + 5] * 65536 + $ActorEditor.MapArray[$j + 6] * 256 + $ActorEditor.MapArray[$j + 7]
                    $ActorEditor.Offsets[$ActorEditor.Offsets.Count-1].ActorCountIndex  = $j + 1
                    $ActorEditor.Offsets[$ActorEditor.Offsets.Count-1].ActorIndex       = $j + 5
                    $ActorEditor.Offsets[$ActorEditor.Offsets.Count-1].FoundActors      = $True
                }
                elseif ($ActorEditor.MapArray[$j] -eq 11) { # Objects List
                    $ActorEditor.Offsets[$ActorEditor.Offsets.Count-1].ObjectCount      = $ActorEditor.MapArray[$j + 1]
                    $ActorEditor.Offsets[$ActorEditor.Offsets.Count-1].ObjectStart      = $ActorEditor.MapArray[$j + 5] * 65536 + $ActorEditor.MapArray[$j + 6] * 256 + $ActorEditor.MapArray[$j + 7]
                    $ActorEditor.Offsets[$ActorEditor.Offsets.Count-1].ObjectCountIndex = $j + 1
                    $ActorEditor.Offsets[$ActorEditor.Offsets.Count-1].ObjectIndex      = $j + 5
                    $ActorEditor.Offsets[$ActorEditor.Offsets.Count-1].FoundObjects     = $True
                }
                elseif ($ActorEditor.MapArray[$j] -eq 10) { # Mesh List
                    $ActorEditor.Offsets[$ActorEditor.Offsets.Count-1].MeshStart        = $ActorEditor.MapArray[$j + 5] * 65536 + $ActorEditor.MapArray[$j + 6] * 256 + $ActorEditor.MapArray[$j + 7]
                    $ActorEditor.Offsets[$ActorEditor.Offsets.Count-1].MeshIndex        = $j + 5
                }
            }
                
            $title = "Stage " + ($items.Count + 1) 
            if ($Scene.stages -is [array]) {
                if ($Scene.stages[$items.Count] -ne 0 -and $Scene.stages[$items.Count] -ne "") {
                if ($items.Count -lt 9) { $title += "  " }
                    $title += "   (" + $Scene.stages[$items.Count] + ")"
                }
            }
            $items += $title
        }
    }

    # $ActorEditor.Offsets = ($ActorEditor.Offsets | Sort-Object { $_.Header })

    if ($Scene.stages -is [array]) {
        if ($Scene.stages[0] -ne 0 -and $Scene.stages[0] -ne "") { $items[0] += "     (" + $Scene.stages[0] + ")" }
    }

    if ($ActorEditor.LastScene.name -ne $Scene.name) {
        $ActorEditor.Headers.Items.AddRange($items)
        $ActorEditor.Headers.SelectedIndex = 0
    }
    else { LoadHeader -Scene $Scene }

}



#==============================================================================================================================================================================================
function GetHeader()             { return $ActorEditor.Offsets[$ActorEditor.Headers.SelectedIndex].Header                                                                                   }
function GetActorCount()         { return $ActorEditor.Offsets[$ActorEditor.Headers.SelectedIndex].ActorCount                                                                               }
function GetActorStart()         { return $ActorEditor.Offsets[$ActorEditor.Headers.SelectedIndex].ActorStart                                                                               }
function GetActorEnd()           { return $ActorEditor.Offsets[$ActorEditor.Headers.SelectedIndex].ActorStart + ($ActorEditor.Offsets[$ActorEditor.Headers.SelectedIndex].ActorCount * 16)  }
function GetActorCountIndex()    { return $ActorEditor.Offsets[$ActorEditor.Headers.SelectedIndex].ActorCountIndex                                                                          }
function GetActorIndex()         { return $ActorEditor.Offsets[$ActorEditor.Headers.SelectedIndex].ActorIndex                                                                               }
function GetObjectCount()        { return $ActorEditor.Offsets[$ActorEditor.Headers.SelectedIndex].ObjectCount                                                                              }
function GetObjectStart()        { return $ActorEditor.Offsets[$ActorEditor.Headers.SelectedIndex].ObjectStart                                                                              }
function GetObjectEnd()          { return $ActorEditor.Offsets[$ActorEditor.Headers.SelectedIndex].ObjectStart + ($ActorEditor.Offsets[$ActorEditor.Headers.SelectedIndex].ObjectCount * 2) }
function GetObjectCountIndex()   { return $ActorEditor.Offsets[$ActorEditor.Headers.SelectedIndex].ObjectCountIndex                                                                         }
function GetObjectIndex()        { return $ActorEditor.Offsets[$ActorEditor.Headers.SelectedIndex].ObjectIndex                                                                              }
function GetMeshStart()          { return $ActorEditor.Offsets[$ActorEditor.Headers.SelectedIndex].MeshStart                                                                                }
function GetMeshIndex()          { return $ActorEditor.Offsets[$ActorEditor.Headers.SelectedIndex].MeshIndex                                                                                }
function GetFoundActors()        { return $ActorEditor.Offsets[$ActorEditor.Headers.SelectedIndex].FoundActors                                                                              }
function GetFoundObjects()       { return $ActorEditor.Offsets[$ActorEditor.Headers.SelectedIndex].FoundObjects                                                                             }

function GetMapCount()           { return $ActorEditor.SceneOffsets.MapCount                                            }
function GetMapStart()           { return $ActorEditor.SceneOffsets.MapStart                                            }
function GetMapEnd()             { return $ActorEditor.SceneOffsets.MapStart + ($ActorEditor.SceneOffsets.MapCount * 8) }
function GetMapCountIndex()      { return $ActorEditor.SceneOffsets.MapCountIndex                                       }
function GetMapIndex()           { return $ActorEditor.SceneOffsets.MapIndex                                            }

function GetTotalObjects() {

    $objects = 0
    foreach ($offset in $ActorEditor.Offsets) { $objects += $offset.ObjectCount }
    return $objects

}



#==============================================================================================================================================================================================
function LoadHeader([object[]]$Scene) {
    
    if (!(IsSet $ActorEditor.Offsets))              { return }
    if (!(GetFoundActors) -or !(GetFoundObjects))   { return }

    $ActorEditor.BottomPanelActors.Controls.Clear()
    $ActorEditor.BottomPanelObjects.Controls.Clear()
    [System.Collections.ArrayList]$ActorEditor.Actors  = @()
    [System.Collections.ArrayList]$ActorEditor.Objects = @()

    $actorTypes  = @("Enemy", "Boss", "NPC", "Object", "Area", "Unused", "Other")
    $ActorEditor.ActorList = @{}
    for ($i=0; $i -lt $actorTypes.Count-1; $i++) { $ActorEditor.ActorList[$i]  = $Files.json.actorEditor.actors  | where { $_.Type -eq $actorTypes[$i] } }
    $ActorEditor.ActorList[$actorTypes.Count-1]  = $Files.json.actorEditor.actors  | where { $_.Type -eq $null }

    $objectTypes = @("Enemy", "NPC", "Object", "Model", "Unused", "Other")
    $ActorEditor.ObjectList = @{}
    for ($i=0; $i -lt $objectTypes.Count-1; $i++) { $ActorEditor.ObjectList[$i] = $Files.json.actorEditor.objects | where { $_.Type -eq $objectTypes[$i] } }
    $ActorEditor.ObjectList[$objectTypes.Count-1] = $Files.json.actorEditor.objects | where { $_.Type -eq $null }

    for ([byte]$i=0; $i -lt (GetActorCount);  $i++)   { AddActor  }
    for ([byte]$i=0; $i -lt (GetObjectCount); $i++)   { AddObject }

    $file = $Paths.Games + "\" + $Game + "\Maps\" + $ActorEditor.Scenes.Text + "\Stage " + ($ActorEditor.Headers.SelectedIndex+1) + "\room_" + $ActorEditor.Maps.SelectedIndex + ".jpg"
    if (TestFile $file) { SetBitMap -Path $file -Box $ActorEditor.MapPreviewImage }
    else {
        $file = $Paths.Games + "\" + $Game + "\Maps\" + $ActorEditor.Scenes.Text + "\room_" + $ActorEditor.Maps.SelectedIndex + ".jpg"
        if (TestFile $file) { SetBitMap -Path $file -Box $ActorEditor.MapPreviewImage }
        else {
            $file = $Paths.Games + "\" + $Game + "\Maps\default.jpg"
            if (TestFile $file) { SetBitMap -Path $file -Box $ActorEditor.MapPreviewImage } else { $ActorEditor.MapPreviewImage.Image = $null }
        }
    }

    $ActorEditor.NormalQuest.Enabled  = $ActorEditor.MasterQuest.Enabled = $ActorEditor.UraQuest.Enabled     = $ActorEditor.ResetMapButton.Enabled = $True 
    $ActorEditor.DeleteActor.Enabled  = $ActorEditor.InsertActor.Enabled = $ActorEditor.DeleteObject.Enabled = $ActorEditor.InsertObject.Enabled   = ((GetFoundActors) -and (GetFoundObjects))

}



#==============================================================================================================================================================================================
function DeleteActor() {
    
    if ((GetActorCount) -eq 0) { return }
    $ActorEditor.BottomPanelActors.AutoScroll = $False

    $ActorEditor.Offsets[$ActorEditor.Headers.SelectedIndex].ActorCount--
    $ActorEditor.MapArray[(GetActorCountIndex)]--
    $ActorEditor.MapArray.RemoveRange((GetActorEnd), 16)
    $ActorEditor.BottomPanelActors.Controls.Remove($ActorEditor.Actors[$ActorEditor.Actors.Count-1].Panel)
    $ActorEditor.Actors.RemoveAt($ActorEditor.Actors.Count-1)

    for ($i=$ActorEditor.Offsets[0].AlternateStart; $i-lt $ActorEditor.Offsets[0].ObjectStart; $i+= 4) {
        if ($ActorEditor.MapArray[$i] -ne 3) { continue }
        $value = $ActorEditor.MapArray[$i+1] * 65536 + $ActorEditor.MapArray[$i+2] * 256 + $ActorEditor.MapArray[$i+3]
        if ($value -gt (GetHeader)) { ShiftMap -Offset ($i+1) -Subtract 16 }
    }

    for ($i=1; $i -lt $ActorEditor.Offsets.Header.Count; $i++) {
        if ($ActorEditor.Offsets[$i].Header -le (GetHeader)) { continue }

        $ActorEditor.Offsets[$i].Header -= 16

        if ($ActorEditor.Offsets[$i].FoundActors) {
            $ActorEditor.Offsets[$i].ActorStart       -= 16
            $ActorEditor.Offsets[$i].ActorCountIndex  -= 16
            $ActorEditor.Offsets[$i].ActorIndex       -= 16
            ShiftMap -Offset $ActorEditor.Offsets[$i].ActorIndex  -Subtract 16
        }

        if ($ActorEditor.Offsets[$i].FoundObjects) {
            $ActorEditor.Offsets[$i].ObjectStart      -= 16
            $ActorEditor.Offsets[$i].ObjectCountIndex -= 16
            $ActorEditor.Offsets[$i].ObjectIndex      -= 16
            ShiftMap -Offset $ActorEditor.Offsets[$i].ObjectIndex -Subtract 16
        }

        $ActorEditor.Offsets[$i].MeshIndex            -= 16
        if ($ActorEditor.Headers.SelectedIndex -eq 0) {
            $ActorEditor.Offsets[$i].MeshStart        -= 16
            ShiftMap -Offset $ActorEditor.Offsets[$i].MeshIndex   -Subtract 16
        }
        
    }

    if ($ActorEditor.Headers.SelectedIndex -eq 0) {
        $ActorEditor.Offsets[0].MeshStart -= 16
        ShiftMap -Offset $ActorEditor.Offsets[0].MeshIndex     -Subtract 16
        ShiftMap -Offset ($ActorEditor.Offsets[0].MeshStart+5) -Subtract 16
        ShiftMap -Offset ($ActorEditor.Offsets[0].MeshStart+9) -Subtract 16
    }

    $meshStart = $ActorEditor.MapArray[(GetMeshStart) + 5] * 65536 + $ActorEditor.MapArray[(GetMeshStart) + 6]  * 256 + $ActorEditor.MapArray[(GetMeshStart) + 7]
    $meshEnd   = $ActorEditor.MapArray[(GetMeshStart) + 9] * 65536 + $ActorEditor.MapArray[(GetMeshStart) + 10] * 256 + $ActorEditor.MapArray[(GetMeshStart) + 11]
    $meshes    = @()
    
    for ($i=$meshStart; $i -lt $meshEnd; $i+= 16) {
        for ($j=8; $j -le 12; $j+= 4) {
            if ($ActorEditor.MapArray[$i+$j] -eq 3) {
                $value =  $ActorEditor.MapArray[$i+$j+1] * 65536 + $ActorEditor.MapArray[$i+$j+2] * 256 + $ActorEditor.MapArray[$i+$j+3]
                if ($value -gt $ActorEditor.Offsets[$ActorEditor.Offsets.Header.Count-1].Header -or $value -le $ActorEditor.MapArray.Count) {
                    ShiftMap -Offset ($i+$j+1) -Subtract 16
                    $meshes += $ActorEditor.MapArray[$i+$j+1] * 65536 + $ActorEditor.MapArray[$i+$j+2] * 256 + $ActorEditor.MapArray[$i+$j+3]
                }
            }
        }
    }
    $meshes = $meshes | Sort-Object

    for ($i=$meshes[0]; $i -lt $ActorEditor.MapArray.Count; $i+=4) {
        if ($ActorEditor.MapArray[$i] -eq 3) {
            $value = $ActorEditor.MapArray[$i+1] * 65536 + $ActorEditor.MapArray[$i+2] * 256 + $ActorEditor.MapArray[$i+3]
            if ($value -gt $ActorEditor.Offsets[$ActorEditor.Offsets.Header.Count-1].Header -and $value -lt $ActorEditor.MapArray.Count) { ShiftMap -Offset ($i+1) -Subtract 16 }
        }
    }

    $ActorEditor.BottomPanelActors.AutoScroll        = $True
    $ActorEditor.BottomPanelActors.AutoScrollMargin  = New-Object System.Drawing.Size(0, 0)
    $ActorEditor.BottomPanelActors.AutoScrollMinSize = New-Object System.Drawing.Size(0, 0)

}



#==============================================================================================================================================================================================
function InsertActor() {
    
    if ((GetActorCount) -ge 255) { return }
    $ActorEditor.BottomPanelActors.AutoScroll = $False

    $ActorEditor.MapArray.InsertRange((GetActorEnd), @(0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    $ActorEditor.Offsets[$ActorEditor.Headers.SelectedIndex].ActorCount++

    $ActorEditor.MapArray[(GetActorCountIndex)]++

    for ($i=$ActorEditor.Offsets[0].AlternateStart; $i-lt $ActorEditor.Offsets[0].ObjectStart; $i+= 4) {
        if ($ActorEditor.MapArray[$i] -ne 3) { continue }
        $value = $ActorEditor.MapArray[$i+1] * 65536 + $ActorEditor.MapArray[$i+2] * 256 + $ActorEditor.MapArray[$i+3]
        if ($value -gt (GetHeader)) { ShiftMap -Offset ($i+1) -Add 16 }
    }

    for ($i=1; $i -lt $ActorEditor.Offsets.Header.Count; $i++) {
        if ($ActorEditor.Offsets[$i].Header -le (GetHeader)) { continue }

        $ActorEditor.Offsets[$i].Header += 16

        if ($ActorEditor.Offsets[$i].FoundActors) {
            $ActorEditor.Offsets[$i].ActorStart       += 16
            $ActorEditor.Offsets[$i].ActorCountIndex  += 16
            $ActorEditor.Offsets[$i].ActorIndex       += 16
            ShiftMap -Offset $ActorEditor.Offsets[$i].ActorIndex  -Add 16
        }

        if ($ActorEditor.Offsets[$i].FoundObjects) {
            $ActorEditor.Offsets[$i].ObjectStart      += 16
            $ActorEditor.Offsets[$i].ObjectCountIndex += 16
            $ActorEditor.Offsets[$i].ObjectIndex      += 16
            ShiftMap -Offset $ActorEditor.Offsets[$i].ObjectIndex -Add 16
        }

        $ActorEditor.Offsets[$i].MeshIndex            += 16
        if ($ActorEditor.Headers.SelectedIndex -eq 0) {
            $ActorEditor.Offsets[$i].MeshStart        += 16
            ShiftMap -Offset $ActorEditor.Offsets[$i].MeshIndex   -Add 16
        }
        
    }

    if ($ActorEditor.Headers.SelectedIndex -eq 0) {
        $ActorEditor.Offsets[0].MeshStart += 16
        ShiftMap -Offset $ActorEditor.Offsets[0].MeshIndex     -Add 16
        ShiftMap -Offset ($ActorEditor.Offsets[0].MeshStart+5) -Add 16
        ShiftMap -Offset ($ActorEditor.Offsets[0].MeshStart+9) -Add 16
    }

    $meshStart = $ActorEditor.MapArray[(GetMeshStart) + 5] * 65536 + $ActorEditor.MapArray[(GetMeshStart) + 6]  * 256 + $ActorEditor.MapArray[(GetMeshStart) + 7]
    $meshEnd   = $ActorEditor.MapArray[(GetMeshStart) + 9] * 65536 + $ActorEditor.MapArray[(GetMeshStart) + 10] * 256 + $ActorEditor.MapArray[(GetMeshStart) + 11]
    $meshes    = @()
    
    for ($i=$meshStart; $i -lt $meshEnd; $i+= 16) {
        for ($j=8; $j -le 12; $j+= 4) {
            if ($ActorEditor.MapArray[$i+$j] -eq 3) {
                $value =  $ActorEditor.MapArray[$i+$j+1] * 65536 + $ActorEditor.MapArray[$i+$j+2] * 256 + $ActorEditor.MapArray[$i+$j+3]
                if ($value -gt $ActorEditor.Offsets[$ActorEditor.Offsets.Header.Count-1].Header -or $value -le $ActorEditor.MapArray.Count) {
                    ShiftMap -Offset ($i+$j+1) -Add 16
                    $meshes += $ActorEditor.MapArray[$i+$j+1] * 65536 + $ActorEditor.MapArray[$i+$j+2] * 256 + $ActorEditor.MapArray[$i+$j+3]
                }
            }
        }
    }
    $meshes = $meshes | Sort-Object

    for ($i=$meshes[0]; $i -lt $ActorEditor.MapArray.Count; $i+=4) {
        if ($ActorEditor.MapArray[$i] -eq 3) {
            $value = $ActorEditor.MapArray[$i+1] * 65536 + $ActorEditor.MapArray[$i+2] * 256 + $ActorEditor.MapArray[$i+3]
            if ($value -gt $ActorEditor.Offsets[$ActorEditor.Offsets.Header.Count-1].Header -and $value -lt $ActorEditor.MapArray.Count) { ShiftMap -Offset ($i+1) -Add 16 }
        }
    }

    AddActor

    $ActorEditor.BottomPanelActors.AutoScroll        = $True
    $ActorEditor.BottomPanelActors.AutoScrollMargin  = New-Object System.Drawing.Size(0, 0)
    $ActorEditor.BottomPanelActors.AutoScrollMinSize = New-Object System.Drawing.Size(0, 0)

}



#==============================================================================================================================================================================================
function DeleteObject() {
    
    if ((GetObjectCount) -eq 0) { return }
    $ActorEditor.BottomPanelObjects.AutoScroll = $False

    $ActorEditor.Offsets[$ActorEditor.Headers.SelectedIndex].ObjectCount--
    $ActorEditor.MapArray[(GetObjectCountIndex)]--
    $ActorEditor.BottomPanelObjects.Controls.Remove($ActorEditor.Objects[$ActorEditor.Objects.Count-1].Panel)
    $ActorEditor.Objects.RemoveAt($ActorEditor.Objects.Count-1)

    if     ((GetObjectCount) % 2 -eq 1) { $ActorEditor.MapArray[(GetObjectEnd)] = $ActorEditor.MapArray[(GetObjectEnd)+1] = 0 }
    elseif ((GetObjectCount) % 2 -eq 0) {
        $ActorEditor.MapArray.RemoveRange((GetObjectEnd), 4)
        $ActorEditor.Offsets[$ActorEditor.Headers.SelectedIndex].ActorStart -= 4
        ShiftMap -Offset (GetActorIndex) -Subtract 4

        for ($i=$ActorEditor.Offsets[0].AlternateStart; $i-lt $ActorEditor.Offsets[0].ObjectStart; $i+= 4) {
            if ($ActorEditor.MapArray[$i] -ne 3) { continue }
            $value = $ActorEditor.MapArray[$i+1] * 65536 + $ActorEditor.MapArray[$i+2] * 256 + $ActorEditor.MapArray[$i+3]
            if ($value -gt (GetHeader)) { ShiftMap -Offset ($i+1) -Subtract 4 }
        }

        for ($i=1; $i -lt $ActorEditor.Offsets.Header.Count; $i++) {
            if ($ActorEditor.Offsets[$i].Header -le (GetHeader)) { continue }

            $ActorEditor.Offsets[$i].Header -= 4

            if ($ActorEditor.Offsets[$i].FoundActors) {
                $ActorEditor.Offsets[$i].ActorStart       -= 4
                $ActorEditor.Offsets[$i].ActorCountIndex  -= 4
                $ActorEditor.Offsets[$i].ActorIndex       -= 4
                ShiftMap -Offset $ActorEditor.Offsets[$i].ActorIndex  -Subtract 4
            }

            if ($ActorEditor.Offsets[$i].FoundObjects) {
                $ActorEditor.Offsets[$i].ObjectStart      -= 4
                $ActorEditor.Offsets[$i].ObjectCountIndex -= 4
                $ActorEditor.Offsets[$i].ObjectIndex      -= 4
                ShiftMap -Offset $ActorEditor.Offsets[$i].ObjectIndex -Subtract 4
            }

            $ActorEditor.Offsets[$i].MeshIndex            -= 4
            if ($ActorEditor.Headers.SelectedIndex -eq 0) {
                $ActorEditor.Offsets[$i].MeshStart        -= 4
                ShiftMap -Offset $ActorEditor.Offsets[$i].MeshIndex   -Subtract 4
            }
        }

        if ($ActorEditor.Headers.SelectedIndex -eq 0) {
            $ActorEditor.Offsets[0].MeshStart -= 4
            ShiftMap -Offset $ActorEditor.Offsets[0].MeshIndex     -Subtract 4
            ShiftMap -Offset ($ActorEditor.Offsets[0].MeshStart+5) -Subtract 4
            ShiftMap -Offset ($ActorEditor.Offsets[0].MeshStart+9) -Subtract 4
        }

        $meshStart = $ActorEditor.MapArray[(GetMeshStart) + 5] * 65536 + $ActorEditor.MapArray[(GetMeshStart) + 6]  * 256 + $ActorEditor.MapArray[(GetMeshStart) + 7]
        $meshEnd   = $ActorEditor.MapArray[(GetMeshStart) + 9] * 65536 + $ActorEditor.MapArray[(GetMeshStart) + 10] * 256 + $ActorEditor.MapArray[(GetMeshStart) + 11]
        $meshes    = @()
        
        for ($i=$meshStart; $i -lt $meshEnd; $i+= 16) {
            for ($j=8; $j -le 12; $j+= 4) {
                if ($ActorEditor.MapArray[$i+$j] -eq 3) {
                    $value =  $ActorEditor.MapArray[$i+$j+1] * 65536 + $ActorEditor.MapArray[$i+$j+2] * 256 + $ActorEditor.MapArray[$i+$j+3]
                    if ($value -gt $ActorEditor.Offsets[$ActorEditor.Offsets.Header.Count-1].Header -or $value -le $ActorEditor.MapArray.Count) {
                        if ((GetTotalObjects) % 4 -eq 3) { ShiftMap -Offset ($i+$j+1) -Subtract 8 }
                        $meshes += $ActorEditor.MapArray[$i+$j+1] * 65536 + $ActorEditor.MapArray[$i+$j+2] * 256 + $ActorEditor.MapArray[$i+$j+3]
                    }
                }
            }
        }

        $meshes = $meshes | Sort-Object
        for ($i=$meshes[0]+32; $i -lt $meshes[0]+512; $i+=4) {
            if ($ActorEditor.MapArray[$i] -eq 3) {
                $vtx = $ActorEditor.MapArray[$i+1] * 65536 + $ActorEditor.MapArray[$i+2] * 256 + $ActorEditor.MapArray[$i+3]
                break
            }
        }

        if     ((GetTotalObjects) % 4 -eq 1) { $ActorEditor.MapArray.InsertRange($vtx-4, @(0, 0, 0, 0)) }
        elseif ((GetTotalObjects) % 4 -eq 3) {
            $ActorEditor.MapArray.RemoveRange($vtx-8, 4)
            $ActorEditor.MapArray.InsertRange($ActorEditor.MapArray.Count, @(0, 0, 0, 0, 0, 0, 0, 0))
            for ($i=$meshes[0]; $i -lt $ActorEditor.MapArray.Count; $i+=4) {
                if ($ActorEditor.MapArray[$i] -eq 3) {
                    $value = $ActorEditor.MapArray[$i+1] * 65536 + $ActorEditor.MapArray[$i+2] * 256 + $ActorEditor.MapArray[$i+3]
                    if ($value -ge $ActorEditor.Offsets[$ActorEditor.Offsets.Header.Count-1].Header -and $value -lt $ActorEditor.MapArray.Count) { ShiftMap -Offset ($i+1) -Subtract 8 }
                }
            }
        }
    }

    $ActorEditor.BottomPanelObjects.AutoScroll        = $True
    $ActorEditor.BottomPanelObjects.AutoScrollMargin  = New-Object System.Drawing.Size(0, 0)
    $ActorEditor.BottomPanelObjects.AutoScrollMinSize = New-Object System.Drawing.Size(0, 0)

}



#==============================================================================================================================================================================================
function InsertObject() {
    
    if ((GetObjectCount) -ge 15) { return }
    $ActorEditor.BottomPanelObjects.AutoScroll = $False

    $ActorEditor.Offsets[$ActorEditor.Headers.SelectedIndex].ObjectCount++
    $ActorEditor.MapArray[(GetObjectCountIndex)]++

    if ((GetObjectCount) % 2 -eq 1) {
        $ActorEditor.MapArray.InsertRange((GetObjectEnd)-4, @(0, 0, 0, 0))
        $ActorEditor.Offsets[$ActorEditor.Headers.SelectedIndex].ActorStart += 4
        ShiftMap -Offset (GetActorIndex) -Add 4

        for ($i=$ActorEditor.Offsets[0].AlternateStart; $i-lt $ActorEditor.Offsets[0].ObjectStart; $i+= 4) {
            if ($ActorEditor.MapArray[$i] -ne 3) { continue }
            $value = $ActorEditor.MapArray[$i+1] * 65536 + $ActorEditor.MapArray[$i+2] * 256 + $ActorEditor.MapArray[$i+3]
            if ($value -gt (GetHeader)) { ShiftMap -Offset ($i+1) -Add 4 }
        }

        for ($i=1; $i -lt $ActorEditor.Offsets.Header.Count; $i++) {
            if ($ActorEditor.Offsets[$i].Header -le (GetHeader)) { continue }

            $ActorEditor.Offsets[$i].Header += 4

            if ($ActorEditor.Offsets[$i].FoundActors) {
                $ActorEditor.Offsets[$i].ActorStart       += 4
                $ActorEditor.Offsets[$i].ActorCountIndex  += 4
                $ActorEditor.Offsets[$i].ActorIndex       += 4
                ShiftMap -Offset $ActorEditor.Offsets[$i].ActorIndex  -Add 4
            }

            if ($ActorEditor.Offsets[$i].FoundObjects) {
                $ActorEditor.Offsets[$i].ObjectStart      += 4
                $ActorEditor.Offsets[$i].ObjectCountIndex += 4
                $ActorEditor.Offsets[$i].ObjectIndex      += 4
                ShiftMap -Offset $ActorEditor.Offsets[$i].ObjectIndex -Add 4
            }

            $ActorEditor.Offsets[$i].MeshIndex            += 4
            if ($ActorEditor.Headers.SelectedIndex -eq 0) {
                $ActorEditor.Offsets[$i].MeshStart        += 4
                ShiftMap -Offset $ActorEditor.Offsets[$i].MeshIndex   -Add 4
            }
        }

        if ($ActorEditor.Headers.SelectedIndex -eq 0) {
            $ActorEditor.Offsets[0].MeshStart += 4
            ShiftMap -Offset $ActorEditor.Offsets[0].MeshIndex     -Add 4
            ShiftMap -Offset ($ActorEditor.Offsets[0].MeshStart+5) -Add 4
            ShiftMap -Offset ($ActorEditor.Offsets[0].MeshStart+9) -Add 4
        }

        $meshStart = $ActorEditor.MapArray[(GetMeshStart) + 5] * 65536 + $ActorEditor.MapArray[(GetMeshStart) + 6]  * 256 + $ActorEditor.MapArray[(GetMeshStart) + 7]
        $meshEnd   = $ActorEditor.MapArray[(GetMeshStart) + 9] * 65536 + $ActorEditor.MapArray[(GetMeshStart) + 10] * 256 + $ActorEditor.MapArray[(GetMeshStart) + 11]
        $meshes    = @()
        
        for ($i=$meshStart; $i -lt $meshEnd; $i+= 16) {
            for ($j=8; $j -le 12; $j+= 4) {
                if ($ActorEditor.MapArray[$i+$j] -eq 3) {
                    $value =  $ActorEditor.MapArray[$i+$j+1] * 65536 + $ActorEditor.MapArray[$i+$j+2] * 256 + $ActorEditor.MapArray[$i+$j+3]
                    if ($value -gt $ActorEditor.Offsets[$ActorEditor.Offsets.Header.Count-1].Header -or $value -le $ActorEditor.MapArray.Count) {
                        if ((GetTotalObjects) % 4 -eq 0) { ShiftMap -Offset ($i+$j+1) -Add 8 }
                        $meshes += $ActorEditor.MapArray[$i+$j+1] * 65536 + $ActorEditor.MapArray[$i+$j+2] * 256 + $ActorEditor.MapArray[$i+$j+3]
                    }
                }
            }
        }

        $meshes = $meshes | Sort-Object
        for ($i=$meshes[0]+32; $i -lt $meshes[0]+512; $i+=4) {
            if ($ActorEditor.MapArray[$i] -eq 3) {
                $vtx = $ActorEditor.MapArray[$i+1] * 65536 + $ActorEditor.MapArray[$i+2] * 256 + $ActorEditor.MapArray[$i+3]
                break
            }
        }

        if ((GetTotalObjects) % 4 -eq 0) {
            $ActorEditor.MapArray.InsertRange($vtx, @(0, 0, 0, 0))
            $ActorEditor.MapArray.RemoveRange($ActorEditor.MapArray.Count-8, 8)
            for ($i=$meshes[0]; $i -lt $ActorEditor.MapArray.Count; $i+=4) {
                if ($ActorEditor.MapArray[$i] -eq 3) {
                    $value = $ActorEditor.MapArray[$i+1] * 65536 + $ActorEditor.MapArray[$i+2] * 256 + $ActorEditor.MapArray[$i+3]
                    if ($value -ge $ActorEditor.Offsets[$ActorEditor.Offsets.Header.Count-1].Header -and $value -lt $ActorEditor.MapArray.Count) { ShiftMap -Offset ($i+1) -Add 8 }
                }
            }
        }
        elseif ((GetTotalObjects) % 4 -eq 2) { $ActorEditor.MapArray.RemoveRange($vtx-8, 4) }
    }

    AddObject

    $ActorEditor.BottomPanelObjects.AutoScroll        = $True
    $ActorEditor.BottomPanelObjects.AutoScrollMargin  = New-Object System.Drawing.Size(0, 0)
    $ActorEditor.BottomPanelObjects.AutoScrollMinSize = New-Object System.Drawing.Size(0, 0)

}



#==============================================================================================================================================================================================
function AddActor() {
    
    $index      = $ActorEditor.Actors.Count
    $default    = 0
    $reset      = "0000"
    $id         = Get16Bit ($ActorEditor.MapArray[(GetActorStart) + $index * 16] * 256 + $ActorEditor.MapArray[(GetActorStart) + 1 + $index * 16])
    $actorTypes = @("Enemy", "Boss", "NPC", "Object", "Area", "Unused", "Other")

    $actor                  = @{}
    $ActorEditor.Actors.Add($actor)

    $actor.Panel            = CreatePanel -X (DPISize 5)             -Y ( (DPISize 80) * $index + (DPISize 15)) -Width ($ActorEditor.BottomPanelActors.Width - (DPISize 25))  -Height (DPISize 80)              -AddTo $ActorEditor.BottomPanelActors
    $actor.ParamsPanel      = CreatePanel -X (DPISize 220)                                                      -Width ($ActorEditor.BottomPanelActors.Width - (DPISize 245)) -Height (DPISize 30)              -AddTo $actor.Panel
    $actor.CoordinatesPanel = CreatePanel -X $actor.ParamsPanel.Left -Y $actor.ParamsPanel.Bottom               -Width $actor.ParamsPanel.Width                               -Height $actor.ParamsPanel.Height -AddTo $actor.Panel
    $actor.Params           = @()
    $actor.Coordinates      = @()

    :outer foreach ($x in 0..($ActorEditor.ActorList.Count-1)) {
        foreach ($y in 0..($ActorEditor.ActorList[$x].Count-1)) {
            if ($ActorEditor.ActorList[$x][$y].id -eq $id) {
                $default = $y + 1
                break outer
            }
        }
    }

    $actor.types += CreateComboBox -X (DPISize 65) -Y (DPISize 30) -Width (DPISize 100) -Height (DPISize 20) -Default ($x + 1) -Items $actorTypes -AddTo $actor.Panel
    $label        = CreateLabel                    -Y (DPISize 33) -Width (DPISize 55)  -Height (DPISize 20) -Text ("ID: " + $id)                 -AddTo $actor.Panel

    if ($default -gt 0) {
        $actor.name += CreateComboBox -X (DPISize 65) -Width (DPISize 150) -Height (DPISize 20) -Default $default -Items $ActorEditor.ActorList[$x].name -AddTo $actor.Panel
        Add-Member -InputObject $actor.name -NotePropertyMembers @{ Index = $index; ListIndex = $x; Label = $label }
        $actor.Params      = LoadActor       -Actor $ActorEditor.ActorList[$x][$y] -Count $index
        $actor.Coordinates = LoadCoordinates -Actor $ActorEditor.ActorList[$x][$y] -Count $index
    }
    else {
        $actor.name  += CreateComboBox -X (DPISize 65) -Width (DPISize 150) -Height (DPISize 20) -AddTo $actor.Panel
        $actor.name.Enabled = $False
        $i            = (GetActorStart) + $index * 16
        $value        = Get16Bit ($ActorEditor.MapArray[$i + 14] * 256 + $ActorEditor.MapArray[$i + 15])
        $actor.values = CreateLabel -X (DPISize 15) -Width (DPISize 200) -Height (DPISize 20) -Text ("Params: " + $value) -AddTo $actor.ParamsPanel

        Add-Member      -InputObject $actor.name -NotePropertyMembers @{ Index = $index; ListIndex = 0; Label = $label }
        $actor.Coordinates = LoadCoordinates -Actor $null -Count $index
    }

    CreateLabel -Y (DPISize 2) -Width (DPISize 55) -Height (DPISize 20) -Text ("Actor: " + ($index + 1)) -AddTo $actor.Panel
    Add-Member  -InputObject $actor.types -NotePropertyMembers @{ Index = $index }

    $actor.types.Add_SelectedIndexChanged({
        $ActorEditor.Actors[$this.Index].Name.Items.Clear()
        $ActorEditor.Actors[$this.Index].Name.Items.AddRange($ActorEditor.ActorList[$this.SelectedIndex].name)
        $ActorEditor.Actors[$this.Index].Name.Enabled       = $True
        $ActorEditor.Actors[$this.Index].Name.ListIndex     = $this.SelectedIndex
        $ActorEditor.Actors[$this.Index].Name.SelectedIndex = 0
    })

    $actor.Name.Add_SelectedIndexChanged({
        $ActorEditor.Actors[$this.Index].ParamsPanel.Controls.Clear()
        $ActorEditor.Actors[$this.Index].CoordinatesPanel.Controls.Clear()
        $ActorEditor.Actors[$this.Index].Params      = @()
        $ActorEditor.Actors[$this.Index].Coordinates = @()
        
        foreach ($item in $ActorEditor.ActorList[$this.ListIndex]) {
            if ($item.name -ne $this.text)   { continue }
            if (IsSet $item.default)         { $reset = $item.default } else { $reset = "0000" }

            $this.Label.Text = "ID: " + $item.ID

            $ActorEditor.Actors[$this.Index].Params      = LoadActor       -Actor $item -Count $this.Index
            ChangeMap       -Offset (Get24Bit ((GetActorStart) + 16 * $this.Index) )      -Values $item.ID
            ChangeMap       -Offset (Get24Bit ((GetActorStart) + 16 * $this.Index + 14) ) -Values $reset
            $ActorEditor.Actors[$this.Index].Coordinates = LoadCoordinates -Actor $item -Count $this.Index
            return
        }
    })

}



#==============================================================================================================================================================================================
function AddObject() {
    
    $index       = $ActorEditor.Objects.Count
    $default     = 0
    $id          = Get16Bit ($ActorEditor.MapArray[(GetObjectStart) + $index * 2] * 256 + $ActorEditor.MapArray[(GetObjectStart) + 1 + $index * 2])
    $objectTypes = @("Enemy", "NPC", "Object", "Model", "Unused", "Other")

    $object      = @{}
    $ActorEditor.Objects.Add($object)
    $object.Panel = CreatePanel -X (DPISize 5) -Y ( (DPISize 30) * $index + (DPISize 15)) -Width ($ActorEditor.BottomPanelObjects.Width - (DPISize 25)) -Height (DPISize 30) -AddTo $ActorEditor.BottomPanelObjects

    if ($id -eq "0000") {
        $object.Types = CreateComboBox -X (DPISize 65)  -Width (DPISize 100) -Height (DPISize 20) -Default ($objectTypes.Count + 1) -Items ($objectTypes + @("Unset")) -AddTo $object.Panel
        $object.Name  = CreateComboBox -X (DPISize 200) -Width (DPISize 300) -Height (DPISize 20)                                                                      -AddTo $object.Panel                      
        $object.Name.Enabled = $False
    }
    else {
        :outer foreach ($x in 0..($ActorEditor.ObjectList.Count - 1)) {
            foreach ($y in 0..($ActorEditor.ObjectList[$x].Count - 1)) {
                if ($ActorEditor.ObjectList[$x][$y].id -eq $id) {
                    $default = $y + 1
                    break outer
                }
            }
        }

        $object.Types = CreateComboBox -X (DPISize 65)  -Width (DPISize 100) -Height (DPISize 20) -Default ($x + 1) -Items $objectTypes                     -AddTo $object.Panel
        $object.Name  = CreateComboBox -X (DPISize 200) -Width (DPISize 300) -Height (DPISize 20) -Default $default -Items $ActorEditor.ObjectList[$x].name -AddTo $object.Panel
    }

    CreateLabel -X (DPISize 0) -Y (DPISize 3) -Width (DPISize 55) -Height (DPISize 20) -Text ("Object: " + ($index + 1)) -AddTo $object.Panel
    Add-Member -InputObject $object.Name  -NotePropertyMembers @{ Index = $index; ID = $id; ListIndex = $x }
    Add-Member -InputObject $object.Types -NotePropertyMembers @{ Index = $index }
        
    $object.Types.Add_SelectedIndexChanged({
        $ActorEditor.Objects[$this.Index].Name.Items.Clear()

        if ($this.text -ne "Unset") { $ActorEditor.Objects[$this.Index].Name.Items.AddRange($ActorEditor.ObjectList[$this.SelectedIndex].name) }
        $ActorEditor.Objects[$this.Index].Name.Enabled   = $ActorEditor.Objects[$this.Index].Name.Items.Count -gt 0
        $ActorEditor.Objects[$this.Index].Name.ListIndex = $this.SelectedIndex

        if ($ActorEditor.Objects[$this.Index].Name.Items.Count -gt 0) { $ActorEditor.Objects[$this.Index].Name.SelectedIndex = 0 }
        else {
            $ActorEditor.Objects[$this.Index].Name.ID = "0000"
            $ActorEditor.ObjectCount--
            ChangeMap -Offset (Get24Bit ((GetObjectStart) + 2 * $this.Index) ) -Values "0000"
            ChangeMap -Offset $ActorEditor.ObjectIndex -Values (Get8Bit (GetObjectCount))
        }
    })

    $object.name.Add_SelectedIndexChanged({
        foreach ($item in $ActorEditor.ObjectList[$this.ListIndex]) {
            if ($item.name -ne $this.text) { continue }
            $this.ID = $item.ID
            ChangeMap -Offset (Get24Bit ((GetObjectStart) + 2 * $this.Index) ) -Values $item.id
            return
        }
    })

}



#==============================================================================================================================================================================================
function LoadActor([object]$Actor, [byte]$Count) {
    
    if ($Actor.params.Count -eq 0) { return }

    $index     = (GetActorStart) + $Count * 16 + 14
    $lastX     = 0
    $lastBandX = 0
    $params    = @()

    foreach ($i in 0..($Actor.params.Count-1)) {
        if     ($Actor.band[$i] -like "*rx*")   { $rotation = 6; $band = GetDecimal $Actor.band[$i].Replace("rx", "") }
        elseif ($Actor.band[$i] -like "*ry*")   { $rotation = 4; $band = GetDecimal $Actor.band[$i].Replace("ry", "") }
        elseif ($Actor.band[$i] -like "*rz*")   { $rotation = 2; $band = GetDecimal $Actor.band[$i].Replace("rz", "") }
        else                                    { $rotation = 0; $band = GetDecimal $Actor.band[$i]                   }

        $value     = $ActorEditor.MapArray[$index - $rotation] * 256 + $ActorEditor.MapArray[$index + 1 - $rotation]
        $previousX = $LastX

        $params += LoadParam -Param $Actor.params[$i] -Value $value -Band $band -LastBandX $lastBandX -LastX $lastX -Count $Count -Rotation $rotation

        $LastX = $params[$i].Right
        if ($i -lt $Actor.params.Count - 1) {
            if ($Actor.band[$i] -eq $Actor.band[$i+1]) {
                if ($params[$i] -is [System.Windows.Forms.ComboBox]) { $lastBandX = 0 } else { $lastBandX = $params[$i].label.width }
                $lastX = $previousX
            }
            else { $lastBandX = 0 }
        }
    }

    if ($Actor.params.Count -lt 2) { return $params }

    foreach ($i in 0..($Actor.params.Count-2)) {
        if ($params[$i] -is [System.Windows.Forms.ComboBox]) {
            for ($j=0; $j -lt $params[$i].Items.Count; $j++) {
                $elem = $params[$i][$j]
                if ($elem.HideParam -is [array]) {
                    if ($elem.HideParam[$elem.SelectedIndex] -gt 0) {
                        $hideElem = $params[$elem.HideParam[$elem.SelectedIndex] - 1]
                        $hideElem.Hide()
                        if (IsSet $hideElem.Label) { $hideElem.Label.Hide() }
                    }
                }
            }
        }
        elseif ($params[$i] -is [System.Windows.Forms.CheckBox]) {
            $elem = $params[$i]
            if ($elem.HideParam -is [array]) {
                if ($elem.Checked -and $elem.HideParam[1] -gt 0) {
                    $params[$elem.HideParam[1] - 1].Hide()
                    if (IsSet $params[$elem.HideParam[1] - 1].Label) { $params[$elem.HideParam[1] - 1].Label.Hide() }
                }
                elseif (!$elem.Checked -and $elem.HideParam[0] -gt 0) {
                    $params[$elem.HideParam[0] - 1].Hide()
                    if (IsSet $params[$elem.HideParam[0] - 1].Label) { $params[$elem.HideParam[0] - 1].Label.Hide() }
                }
            }
        }
    }

    foreach ($param in $ActorEditor.Actors[$Count].Params) {
        if ($param -is [System.Windows.Forms.ComboBox] -and !$param.Visible -and !$param.Enabled) {
            $param.Items.Clear()
            $param.Items.AddRange($param.Param.Name)
            $param.SelectedIndex = 0
            $param.Enabled       = $True
        }
    }

    return $params

}



#==============================================================================================================================================================================================
function LoadParam([object]$Param, [uint16]$Value, [uint16]$Band, [uint16]$LastBandX, [uint16]$LastX, [byte]$Count, [byte]$Rotation) {
    
    $items        = $Param.name
    $default      = 0
    $defaultValue = 0
    $calc         = $Value -band $Band

    :outer foreach ($item in $Param) {
        if ($item.value -is [array]) {
            foreach ($val in $item.value) {
                if ($calc -eq (GetDecimal $val)) {
                    $default = [array]::indexof($items, $item.name) + 1
                    break outer
                }
            }
        }
        else {
            if ($calc -eq (GetDecimal $item.value)) {
                $default = [array]::indexof($items, $item.name) + 1
                break outer
            }
        }
    }

    if ($items.Count -eq 1 -and $Param[0].text -ne 0) { # Text field
        if     (IsSet $Param[0].multi)                                        { $multi = (GetDecimal $Param[0].multi)         }
        elseif ($Band -eq 0xFFF0 -or $Band -eq 0x0FF0 -or $Band -eq 0x00F0)   { $multi = 0x10                                 }
        elseif ($Band -eq 0xFF00 -or $Band -eq 0x0F00)                        { $multi = 0x100                                }
        elseif ($Band -eq 0xF000)                                             { $multi = 0x1000                               }
        elseif ($Band -eq 0xFFFF -or $Band -le 0xFF)                          { $multi = 0x1                                  }
        else                                                                  { $multi = $band / (GetDecimal $Param[0].value) }

        $label        = CreateLabel   -X ($lastX       + (DPISize 20) ) -Y (DPISize 2)           -Height (DPISize 20) -Text ($Param[0].name + ":")         -Width $LastBandX              -AddTo $ActorEditor.Actors[$Count].ParamsPanel
        try {
            $elem     = CreateTextBox -X ($label.Right + (DPISize 5) )  -Y 0 -Width (DPISize 50) -Height (DPISize 22) -Text ('{0:X}' -f ($calc / $multi) ) -Length $Param[0].value.length -AddTo $ActorEditor.Actors[$Count].ParamsPanel
        }
        catch {
            $elem     = CreateTextBox -X ($label.Right + (DPISize 5) )  -Y 0 -Width (DPISize 50) -Height (DPISize 22) -Text "ERROR" -Length 0 -AddTo $ActorEditor.Actors[$Count].ParamsPanel
            $elem.Enabled = $False
            WriteToConsole ("Could not parse Actor (" + $ActorEditor.Actors[$ActorEditor.Actors.Count-1].text + ") Text Field Param (" + $Param[0].name + ") with band: " + (Get16Bit $Band) + ", " + $calc + ", " + $multi )
        }
        $defaultValue = '{0:X}' -f ( (GetDecimal $elem.Text) * $multi)

        Add-Member -InputObject $elem -NotePropertyMembers @{ Label = $label; Max = (GetDecimal $Param[0].value); Multi = $multi }

        $elem.Add_LostFocus({
            $this.Text = $this.Text.ToUpper()
            $text      = GetDecimal $this.Text
            if ($text -lt 0 -or $text -gt $this.Max) {
                $this.Text = $this.Default
                $text      = GetDecimal $this.Default
            }
            $index      = (GetActorStart) + 16 * $this.Index + 14 - $this.Rotation
            $value      = $ActorEditor.MapArray[$index]  * 256 + $ActorEditor.MapArray[$index + 1]
            $value     -= (GetDecimal $this.Value)
            $this.Value = '{0:X}' -f ($text * $this.Multi)
            $value     += (GetDecimal $this.Value)

            ChangeMap -Offset (Get24Bit $index) -Values (Get16Bit $value)
        })
    }

    elseif ($items.Count -eq 2) { # Checkbox
        $label = CreateLabel    -X ($lastX       + (DPISize 20) ) -Y (DPISize 2) -Height (DPISize 20) -Text ($items[1] + ":") -AddTo $ActorEditor.Actors[$Count].ParamsPanel -Width $LastBandX
        $elem  = CreateCheckBox -X ($label.Right + (DPISize 5)  ) -Y 0           -Checked ($default -eq 2)                    -AddTo $ActorEditor.Actors[$Count].ParamsPanel

        if     ($default -eq 2)   { $defaultValue = $ActorEditor.Actors[$Count].Params[1].value }
        elseif ($default -eq 1)   { $defaultValue = $ActorEditor.Actors[$Count].Params[0].value }
        else                      { $defaultValue = 0; $elem.Enabled = $False }
        Add-Member -InputObject $elem -NotePropertyMembers @{ Label = $label }

        :outer foreach ($x in $Param) {
            foreach ($y in $x) {
                if ($y.show -ge 0 -and $y.hide -ge 0) {
                    Add-Member -InputObject $elem -NotePropertyMembers @{ ShowParam = $Param.show }
                    Add-Member -InputObject $elem -NotePropertyMembers @{ HideParam = $Param.hide }

                    $elem.Add_CheckStateChanged({
                        if ($this.Checked) {
                            $param = $ActorEditor.Actors[$this.Index].Params[$this.ShowParam[1] - 1]

                            $index = (GetActorStart) + 16 * $this.Index + 14 - $ActorEditor.Actors[$this.Index].Params[$this.ShowParam[1] - 1].Rotation
                            $value = $ActorEditor.MapArray[$index] * 256 + $ActorEditor.MapArray[$index + 1]

                            if ($this.ShowParam[1] -gt 0) {
                                $ActorEditor.Actors[$this.Index].Params[$this.ShowParam[1] - 1].Show()
                                if (IsSet $ActorEditor.Actors[$this.Index].Params[$this.ShowParam[1] - 1].Label) { $ActorEditor.Actors[$this.Index].Params[$this.ShowParam[1] - 1].Label.Show() }
                            }

                            if ($this.HideParam[1] -gt 0) {
                                $ActorEditor.Actors[$this.Index].Params[$this.HideParam[1] - 1].Hide()
                                if (IsSet $ActorEditor.Actors[$this.Index].Params[$this.HideParam[1] - 1].Label) { $ActorEditor.Actors[$this.Index].Params[$this.HideParam[1] - 1].Label.Hide() }
                            }
                    
                            if ($this.ShowParam[1] -eq 0 -or $this.HideParam[1] -eq 0) { return }

                            $value -= (GetDecimal $ActorEditor.Actors[$this.Index].Params[$this.HideParam[1] - 1].Value)
                            $value += (GetDecimal $ActorEditor.Actors[$this.Index].Params[$this.ShowParam[1] - 1].Value)
                        }
                        else {
                            $index = (GetActorStart) + 16 * $this.Index + 14 - $ActorEditor.Actors[$this.Index].Params[$this.ShowParam[0] - 1].Rotation
                            $value = $ActorEditor.MapArray[$index] * 256 + $ActorEditor.MapArray[$index + 1]

                            if ($this.ShowParam[0] -gt 0) {
                                $ActorEditor.Actors[$this.Index].Params[$this.ShowParam[0] - 1].Show()
                                if (IsSet $ActorEditor.Actors[$this.Index].Params[$this.ShowParam[0] - 1].Label) { $ActorEditor.Actors[$this.Index].Params[$this.ShowParam[0] - 1].Label.Show() }
                            }

                            if ($this.HideParam[0] -gt 0) {
                                $ActorEditor.Actors[$this.Index].Params[$this.HideParam[0] - 1].Hide()
                                if (IsSet $ActorEditor.Actors[$this.Index].Params[$this.HideParam[0] - 1].Label) { $ActorEditor.Actors[$this.Index].Params[$this.HideParam[0] - 1].Label.Hide() }
                            }

                            if ($this.HideParam[0] -eq 0 -or $this.HideParam[0] -eq 0) { return }

                            $value -= (GetDecimal $ActorEditor.Actors[$this.Index].Params[$this.HideParam[0] - 1].Value)
                            $value += (GetDecimal $ActorEditor.Actors[$this.Index].Params[$this.ShowParam[0] - 1].Value)
                        }

                        ChangeMap -Offset (Get24Bit $index) -Values (Get16Bit $value)
                    })

                    break outer
                }
            }
        }

        $elem.Add_CheckStateChanged({
            $index  = (GetActorStart) + 16 * $this.Index + 14 - $this.Rotation
            $value  = $ActorEditor.MapArray[$index] * 256 + $ActorEditor.MapArray[$index + 1]
            $value -= (GetDecimal $this.Value)
            
            if ($this.Param[0].value -is [array]) {
                if ($this.Checked)   { $this.Value = $this.Param[1].value[0] }
                else                 { $this.Value = $this.Param[0].value[0] }
            }
            else {
                if ($this.Checked)   { $this.Value = $this.Param[1].value }
                else                 { $this.Value = $this.Param[0].value }
            }

            $value += (GetDecimal $this.Value)
            ChangeMap -Offset (Get24Bit $index) -Values (Get16Bit $value)
        })
    }

    else { # Combobox
        if ($default -eq 0 -and $ActorEditor.Dialog.Enabled) { $items = @("Unknown: " + '{0:X}' -f $calc) }
        $elem = CreateComboBox -X ($LastX + (DPISize 20) ) -Y 0 -Width (DPISize 165) -Height (DPISize 20) -Default $default -Items $items -AddTo $ActorEditor.Actors[$Count].ParamsPanel
        if ($default -eq 0 -and $ActorEditor.Dialog.Enabled) { $elem.Enabled = $False }

        :outer foreach ($x in $Param) {
            foreach ($y in $x) {
                if ($y.show -ge 0 -and $y.hide -ge 0) {
                    Add-Member -InputObject $elem -NotePropertyMembers @{ ShowParam = $Param.show }
                    Add-Member -InputObject $elem -NotePropertyMembers @{ HideParam = $Param.hide }

                    $elem.Add_SelectedIndexChanged({
                        if (!$this.Enabled) { return }

                        if ($this.ShowParam[$this.SelectedIndex] -gt 0) {
                            $ActorEditor.Actors[$this.Index].Params[$this.ShowParam[$this.SelectedIndex] - 1].Show()
                            if (IsSet $ActorEditor.Actors[$this.Index].Params[$this.ShowParam[$this.SelectedIndex] - 1].Label) { $ActorEditor.Actors[$this.Index].Params[$this.ShowParam[$this.SelectedIndex] - 1].Label.Show() }
                        }

                        if ($this.HideParam[$this.SelectedIndex] -gt 0) {
                            $ActorEditor.Actors[$this.Index].Params[$this.HideParam[$this.SelectedIndex] - 1].Hide()
                            if (IsSet $ActorEditor.Actors[$this.Index].Params[$this.HideParam[$this.SelectedIndex] - 1].Label) { $ActorEditor.Actors[$this.Index].Params[$this.HideParam[$this.SelectedIndex] - 1].Label.Hide() }
                        }

                        if ($this.ShowParam[$this.SelectedIndex] -eq 0 -or $this.HideParam[$this.SelectedIndex] -eq 0) { return }

                        $index  = (GetActorStart) + 16 * $this.Index + 14 - $this.Rotation
                        $value  = $ActorEditor.MapArray[$index] * 256 + $ActorEditor.MapArray[$index + 1]
                        $value -= (GetDecimal $ActorEditor.Actors[$this.Index].Params[$this.HideParam[$this.SelectedIndex] - 1].Value)
                        $value += (GetDecimal $ActorEditor.Actors[$this.Index].Params[$this.ShowParam[$this.SelectedIndex] - 1].Value)
                        ChangeMap -Offset (Get24Bit $index) -Values (Get16Bit $value)
                    })

                    break outer
                }
            }
        }

        foreach ($arr in $Param) {
            if ($arr.name -eq $elem.text) {
                if ($arr.value -is [array])   { $defaultValue = $arr.value[0] }
                else                          { $defaultValue = $arr.value    }
                break
            }
        }

        $elem.Add_SelectedIndexChanged({
            if (!$this.Enabled) { return }

            $index  = (GetActorStart) + 16 * $this.Index + 14 - $this.Rotation
            $value  = $ActorEditor.MapArray[$index] * 256 + $ActorEditor.MapArray[$index + 1]
            $value -= (GetDecimal $this.Value)

            foreach ($param in $this.Param) {
                if ($param.name -eq $this.text) {
                    if ($param.value -is [array])   { $this.Value = $param.value[0] }
                    else                            { $this.Value = $param.value    }
                    break
                }
            }

            $value += (GetDecimal $this.Value)
            ChangeMap -Offset (Get24Bit $index) -Values (Get16Bit $value)
        })
    }

    Add-Member -InputObject $elem -NotePropertyMembers @{ Index = $Count; Param = $Param; Value = $defaultValue; Rotation = $Rotation }
    return $elem

}



#==============================================================================================================================================================================================
function LoadCoordinates([object]$Actor, [byte]$Count) {
    
    $noX = $noY = $noZ = $False
    $coordinates = @()

    if (IsSet $Actor) {
        foreach ($band in $Actor.band) {
            if ($band -like "*rx*")   {  $noX = $True }
            if ($band -like "*ry*")   {  $noY = $True }
            if ($band -like "*rz*")   {  $noZ = $True }
        }
    }

                   $coordinates += SetCoordinates -X 20  -Count $Count -Offset 2 -Text "X-Coords"
                   $coordinates += SetCoordinates -X 170 -Count $Count -Offset 4 -Text "Y-Coords"
                   $coordinates += SetCoordinates -X 320 -Count $Count -Offset 6 -Text "Z-Coords"

    if (!$noX)   { $coordinates += SetCoordinates -X 470 -Count $Count -Offset 8  -Text "X-Rotation" }
    if (!$noY)   { $coordinates += SetCoordinates -X 620 -Count $Count -Offset 10 -Text "Y-Rotation" }
    if (!$noZ)   { $coordinates += SetCoordinates -X 770 -Count $Count -Offset 12 -Text "Z-Rotation" }

    return $coordinates

}



#==============================================================================================================================================================================================
function SetCoordinates($X, [byte]$Count, [byte]$Offset, [string]$Text) {

    $index = (GetActorStart) + $Count * 16
    $value = '{0:X}' -f ($ActorEditor.MapArray[$index + $Offset] * 256 + $ActorEditor.MapArray[$index + $Offset + 1])
    $label = CreateLabel   -X (DPISize $X) -Y (DPISize 2) -Width (DPISize 65) -Height (DPISize 20) -Text ($Text + ":")    -AddTo $ActorEditor.Actors[$Count].CoordinatesPanel
    $elem  = CreateTextBox -X $label.Right -Y (DPISize 0) -Width (DPISize 50) -Height (DPISize 22) -Text $value -Length 4 -AddTo $ActorEditor.Actors[$Count].CoordinatesPanel

    Add-Member -InputObject $elem -NotePropertyMembers @{ Index = $Count; Offset = $Offset; Value = ($ActorEditor.MapArray[(GetActorStart) + 16 * $Count + $Offset] * 256 + $ActorEditor.MapArray[(GetActorStart) + 16 * $Count + $Offset + 1]) }

    $elem.Add_LostFocus({
        $this.Text = $this.Text.ToUpper()
        $value     = GetDecimal $this.Text

        if ($value -eq $this.Value) { return }
        if ($value -lt 0 -or $value -gt 0xFFFF) {
            $this.Text = $this.Default
            $value     = GetDecimal $this.Default
        }

        ChangeMap -Offset (Get24Bit ((GetActorStart) + 16 * $this.Index + $this.Offset) ) -Values (Get16Bit $value)
        $this.Value = $value
    })

    return $elem

}



#==============================================================================================================================================================================================
function ReloadParams([object]$Actor, [byte]$Index) {

    if ($Actor.params.Count -eq 0) { return }

    $value = 0
    foreach ($param in $Actor.params) {
        if ($param[0].value -is [array])   { $value += (GetDecimal $param[0].value[0]) }
        else                               { $value += (GetDecimal $param[0].value)    }
    }

    if     ($value -lt 0)                                             { $value = 0          }
    if     ($Actor.band[0].length -eq 2 -and $value -gt 0xFF)         { $value = 0xFF       }
    elseif ($Actor.band[0].length -eq 4 -and $value -gt 0xFFFF)       { $value = 0xFFFF     }
    elseif ($Actor.band[0].length -eq 6 -and $value -gt 0xFFFFFF)     { $value = 0xFFFFFF   }
    elseif ($Actor.band[0].length -eq 8 -and $value -gt 0xFFFFFFFF)   { $value = 0xFFFFFFFF }

    ChangeMap -Offset (Get24Bit ((GetActorStart) + 16 * $Index + 16 - $Actor.band[0].length / 2) ) -Values (Get16Bit $value)

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function RunActorEditor