function CreateSceneEditorDialog() {
    
    $Files.json.sceneEditor   = SetJSONFile ($Paths.Games + "\" + $SceneEditor.GameType.mode   + "\Scene Editor.json")
    $Files.json.music         = SetJSONFile ($Paths.Games + "\" + $Files.json.sceneEditor.game + "\Music.json")
    $SceneEditor.FirstLoad    = $True
    $SceneEditor.Resetting    = $False
    $SceneEditor.GUI          = $True
    $SceneEditor.LoadedHeader = 0



    # Create Dialog
    $SceneEditor.Dialog           = CreateDialog -Width (DPISize 1300) -Height (DPISize 700)
    $SceneEditor.Dialog.Icon      = $Files.icon.additional
    $SceneEditor.Dialog.BackColor = 'AntiqueWhite'
    $SceneEditor.Dialog.Add_FormClosing({ param($sender, $e) $e.Cancel = $True; CloseSceneEditor })



    # Groups
    $SceneEditor.TopGroup                                          = CreateGroupBox -X (DPISize 10) -Y (DPISize 5)                                  -Width ($SceneEditor.Dialog.Width - (DPISize 30)) -Height (DPISize 70)                                 -AddTo $SceneEditor.Dialog
    $SceneEditor.BottomGroup                                       = CreateGroupBox -X (DPISize 10) -Y ($SceneEditor.TopGroup.Bottom + (DPISize 5)) -Width ($SceneEditor.Dialog.Width - (DPISize 30)) -Height ($SceneEditor.Dialog.Height - (DPISize 190)) -AddTo $SceneEditor.Dialog
    
    $SceneEditor.BottomPanelMapSettings                            = CreatePanel -X (DPISize 5) -Y (DPISize 10) -Width ($SceneEditor.BottomGroup.Width - (DPISize 10)) -Height ($SceneEditor.BottomGroup.Height - (DPISize 15)) -AddTo $SceneEditor.BottomGroup
    $SceneEditor.BottomPanelMapSettings.AutoScroll                 = $SceneEditor.BottomPanelMapSettings.HorizontalScroll.Enabled = $SceneEditor.BottomPanelMapSettings.HorizontalScroll.Visible = $False
    $SceneEditor.BottomPanelMapSettings.HorizontalScroll.Maximum   = 0
    $SceneEditor.BottomPanelMapSettings.AutoScroll                 = $True
    $SceneEditor.BottomPanelMapSettings.AutoScrollMargin           = $SceneEditor.BottomPanelMapSettings.AutoScrollMinSize = New-Object System.Drawing.Size(0, 0)
    $SceneEditor.BottomPanelMapSettings.Hide()

    $SceneEditor.BottomPanelSceneSettings                          = CreatePanel -X $SceneEditor.BottomPanelMapSettings.Left   -Y $SceneEditor.BottomPanelMapSettings.Top    -Width $SceneEditor.BottomPanelMapSettings.Width   -Height $SceneEditor.BottomPanelMapSettings.Height   -AddTo $SceneEditor.BottomGroup
    $SceneEditor.BottomPanelSceneSettings.AutoScroll               = $SceneEditor.BottomPanelSceneSettings.HorizontalScroll.Enabled = $SceneEditor.BottomPanelSceneSettings.HorizontalScroll.Visible = $False
    $SceneEditor.BottomPanelSceneSettings.HorizontalScroll.Maximum = 0
    $SceneEditor.BottomPanelSceneSettings.AutoScroll               = $True
    $SceneEditor.BottomPanelSceneSettings.AutoScrollMargin         = $SceneEditor.BottomPanelSceneSettings.AutoScrollMinSize = New-Object System.Drawing.Size(0, 0)
    $SceneEditor.BottomPanelSceneSettings.Hide()

    $SceneEditor.BottomPanelActors                                 = CreatePanel -X $SceneEditor.BottomPanelSceneSettings.Left -Y $SceneEditor.BottomPanelSceneSettings.Top  -Width $SceneEditor.BottomPanelSceneSettings.Width -Height $SceneEditor.BottomPanelSceneSettings.Height -AddTo $SceneEditor.BottomGroup
    $SceneEditor.BottomPanelActors.AutoScroll                      = $SceneEditor.BottomPanelActors.HorizontalScroll.Enabled = $SceneEditor.BottomPanelActors.HorizontalScroll.Visible = $False
    $SceneEditor.BottomPanelActors.HorizontalScroll.Maximum        = 0
    $SceneEditor.BottomPanelActors.AutoScroll                      = $True
    $SceneEditor.BottomPanelActors.AutoScrollMargin                = $SceneEditor.BottomPanelActors.AutoScrollMinSize = New-Object System.Drawing.Size(0, 0)

    $SceneEditor.BottomPanelObjects                                = CreatePanel -X $SceneEditor.BottomPanelActors.Left        -Y $SceneEditor.BottomPanelActors.Top         -Width $SceneEditor.BottomPanelActors.Width        -Height $SceneEditor.BottomPanelActors.Height        -AddTo $SceneEditor.BottomGroup
    $SceneEditor.BottomPanelObjects.AutoScroll                     = $SceneEditor.BottomPanelObjects.HorizontalScroll.Enabled = $SceneEditor.BottomPanelObjects.HorizontalScroll.Visible = $False
    $SceneEditor.BottomPanelObjects.HorizontalScroll.Maximum       = 0
    $SceneEditor.BottomPanelObjects.AutoScroll                     = $True
    $SceneEditor.BottomPanelObjects.AutoScrollMargin               = $SceneEditor.BottomPanelObjects.AutoScrollMinSize = New-Object System.Drawing.Size(0, 0)
    $SceneEditor.BottomPanelObjects.Hide()

    $SceneEditor.BottomPanelMapPreview                             = CreatePanel -X $SceneEditor.BottomPanelActors.Left        -Y $SceneEditor.BottomPanelActors.Top         -Width $SceneEditor.BottomPanelActors.Width        -Height $SceneEditor.BottomPanelActors.Height        -AddTo $SceneEditor.BottomGroup
    $SceneEditor.MapPreviewImage                                   = CreateForm  -X (DPISize 50) -Y (DPISize 5) -Width (DPISize 1152) -Height (DPISize 648) -Form (New-Object Windows.Forms.PictureBox) -AddTo $SceneEditor.BottomPanelMapPreview
    $SceneEditor.BottomPanelMapPreview.Hide()
    $file                                                          = $Paths.Games + "\" + $Files.json.sceneEditor.game + "\Maps\default.jpg"
    if (TestFile $file) { SetBitMap -Path $file -Box $SceneEditor.MapPreviewImage } else { $SceneEditor.MapPreviewImage.Image = $null }


    # Map Settings Button
    $MapSettingsButton           = CreateButton -X ($SceneEditor.TopGroup.Right - (DPISize 350)) -Y (DPISize 10) -Width (DPISize 80) -Height (DPISize 35) -Text "Map Settings" -AddTo $SceneEditor.TopGroup
    $MapSettingsButton.BackColor = "White"
    $MapSettingsButton.Add_Click({
        $SceneEditor.BottomPanelMapSettings.Show()
        $SceneEditor.BottomPanelSceneSettings.Hide()
        $SceneEditor.BottomPanelActors.Hide()
        $SceneEditor.BottomPanelObjects.Hide()
        $SceneEditor.BottomPanelMapPreview.Hide()
    })

    # Scene Settings Button
    $SceneSettingsButton           = CreateButton -X ($MapSettingsButton.Right + (DPISize 5)) -Y $MapSettingsButton.Top -Width $MapSettingsButton.Width -Height $MapSettingsButton.Height -Text "Scene Settings" -AddTo $SceneEditor.TopGroup
    $SceneSettingsButton.BackColor = "White"
    $SceneSettingsButton.Add_Click({
        $SceneEditor.BottomPanelMapSettings.Hide()
        $SceneEditor.BottomPanelSceneSettings.Show()
        $SceneEditor.BottomPanelActors.Hide()
        $SceneEditor.BottomPanelObjects.Hide()
        $SceneEditor.BottomPanelMapPreview.Hide()
    })

    # Actors Button
    $ActorsButton           = CreateButton -X ($SceneSettingsButton.Right + (DPISize 5)) -Y $SceneSettingsButton.Top -Width $SceneSettingsButton.Width -Height $SceneSettingsButton.Height -Text "Actors" -AddTo $SceneEditor.TopGroup
    $ActorsButton.BackColor = "White"
    $ActorsButton.Add_Click({
        $SceneEditor.BottomPanelMapSettings.Hide()
        $SceneEditor.BottomPanelSceneSettings.Hide()
        $SceneEditor.BottomPanelActors.Show()
        $SceneEditor.BottomPanelObjects.Hide()
        $SceneEditor.BottomPanelMapPreview.Hide()
    })

    # Objects Button
    $ObjectsButton           = CreateButton -X ($ActorsButton.Right + (DPISize 5)) -Y $ActorsButton.Top -Width $ActorsButton.Width -Height $ActorsButton.Height -Text "Objects" -AddTo $SceneEditor.TopGroup
    $ObjectsButton.BackColor = "White"
    $ObjectsButton.Add_Click({
        $SceneEditor.BottomPanelMapSettings.Hide()
        $SceneEditor.BottomPanelSceneSettings.Hide()
        $SceneEditor.BottomPanelActors.Hide()
        $SceneEditor.BottomPanelObjects.Show()
        $SceneEditor.BottomPanelMapPreview.Hide()
    })

    # Map Preview Button
    $MapPreviewButton           = CreateButton -X ($ObjectsButton.Right + (DPISize 5)) -Y $ObjectsButton.Top -Width $ObjectsButton.Width -Height $ObjectsButton.Height -Text "Preview Map" -AddTo $SceneEditor.TopGroup
    $MapPreviewButton.BackColor = "White"
    $MapPreviewButton.Add_Click({
        $SceneEditor.BottomPanelMapSettings.Hide()
        $SceneEditor.BottomPanelSceneSettings.Hide()
        $SceneEditor.BottomPanelActors.Hide()
        $SceneEditor.BottomPanelObjects.Hide()
        $SceneEditor.BottomPanelMapPreview.Show()
    })

    $SceneEditor.DeleteActor  = CreateButton -X $ActorsButton.Left              -Y $ActorsButton.Bottom          -Width (DPISize 40) -Height (DPISize 17) -Font $Fonts.SmallBold -Text "-" -AddTo $SceneEditor.TopGroup -BackColor "Red"   -ForeColor "White"
    $SceneEditor.InsertActor  = CreateButton -X $SceneEditor.DeleteActor.Right  -Y $SceneEditor.DeleteActor.Top  -Width (DPISize 40) -Height (DPISize 17) -Font $Fonts.SmallBold -Text "+" -AddTo $SceneEditor.TopGroup -BackColor "Green" -ForeColor "White"
    $SceneEditor.DeleteObject = CreateButton -X $ObjectsButton.Left             -Y $ObjectsButton.Bottom         -Width (DPISize 40) -Height (DPISize 17) -Font $Fonts.SmallBold -Text "-" -AddTo $SceneEditor.TopGroup -BackColor "Red"   -ForeColor "White"
    $SceneEditor.InsertObject = CreateButton -X $SceneEditor.DeleteObject.Right -Y $SceneEditor.DeleteObject.Top -Width (DPISize 40) -Height (DPISize 17) -Font $Fonts.SmallBold -Text "+" -AddTo $SceneEditor.TopGroup -BackColor "Green" -ForeColor "White"

    $SceneEditor.DeleteActor.Enabled = $SceneEditor.InsertActor.Enabled = $SceneEditor.DeleteObject.Enabled = $SceneEditor.InsertObject.Enabled = $False
    $SceneEditor.DeleteActor.Add_Click(  { DeleteActor  } )
    $SceneEditor.DeleteObject.Add_Click( { DeleteObject } )
    $SceneEditor.InsertObject.Add_Click( { InsertObject -ID "0000" } )
    
    $SceneEditor.InsertActor.Add_Click( {
        if     ($Files.json.sceneEditor.game -eq "Ocarina of Time")   { InsertActor -ID "0002" }
        elseif ($Files.json.sceneEditor.game -eq "Majora's Mask")     { InsertActor -ID "0019" }
        else                                                          { InsertActor            }
    } )
    


    # Close Button
    $X = $SceneEditor.Dialog.Left + $SceneEditor.Dialog.Width / 3
    $Y = $SceneEditor.Dialog.Height - (DPISize 90)
    $CloseButton           = CreateButton -X $X -Y $Y -Width (DPISize 90) -Height (DPISize 35) -Text "Close" -AddTo $SceneEditor.Dialog
    $CloseButton.BackColor = "White"
    $CloseButton.Add_Click({ CloseSceneEditor })



    # Extract Button
    $ExtractButton           = CreateButton -X ($CloseButton.Right + (DPISize 15)) -Y $CloseButton.Top -Width $CloseButton.Width -Height $CloseButton.Height -Text "Extract Scenes" -AddTo $SceneEditor.Dialog
    $ExtractButton.BackColor = "White"
    $ExtractButton.Add_Click({
        RefreshScripts
        if ($Settings.Debug.ClearLog -eq $True) { Clear-Host }
        SetSceneEditorTypes
        EnableGUI $False
        RunAllScenes
        EnableGUI $True
        PlaySound $Sounds.done
        ResetSceneEditorTypes
        Cleanup
    })



    # Reset Map Button
    $SceneEditor.ResetMapButton           = CreateButton -X ($ExtractButton.Right + (DPISize 15)) -Y $ExtractButton.Top -Width $ExtractButton.Width -Height $ExtractButton.Height -Text "Reset Map" -AddTo $SceneEditor.Dialog
    $SceneEditor.ResetMapButton.BackColor = "White"
    $SceneEditor.ResetMapButton.Enabled   = $False
    $SceneEditor.ResetMapButton.Add_Click({
        RefreshScripts
        if ($Settings.Debug.ClearLog -eq $True) { Clear-Host }
        SetSceneEditorTypes
        EnableGUI $False
        RunAllScenes -Current
        EnableGUI $True
        PlaySound $Sounds.done
        ResetSceneEditorTypes
        Cleanup
    })



    # Reset Quest Button
    if ($Files.json.sceneEditor.quest -is [array] -and $Files.json.sceneEditor.quest.Count -gt 0) {
        $ResetQuestButton           = CreateButton -X ($SceneEditor.ResetMapButton.Right + (DPISize 15)) -Y $SceneEditor.ResetMapButton.Top -Width $SceneEditor.ResetMapButton.Width -Height $SceneEditor.ResetMapButton.Height -Text "Reset Quest" -AddTo $SceneEditor.Dialog
        $ResetQuestButton.BackColor = "White"
        $ResetQuestButton.Add_Click({
            $SceneEditor.Quests[0].Checked = $True

            if ($Files.json.sceneEditor.game -eq "Ocarina of Time") {
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
            UpdateStatusLabel "All dungeons have been set to Normal Quest again"
        })
        $lastX = $ResetQuestButton.Right
    }
    else { $lastX = $SceneEditor.ResetMapButton.Right }



    # Patch Scenes Button
    $PatchButton           = CreateButton -X ($lastX + (DPISize 15)) -Y $SceneEditor.ResetMapButton.Top -Width $SceneEditor.ResetMapButton.Width -Height $SceneEditor.ResetMapButton.Height -Text "Patch Scenes" -AddTo $SceneEditor.Dialog
    $PatchButton.BackColor = "White"
    $PatchButton.Add_Click({
        RefreshScripts
        if ($Settings.Debug.ClearLog -eq $True) { Clear-Host }
        SetSceneEditorTypes
        SaveMap   -Scene $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex] -Index $SceneEditor.Maps.SelectedIndex
        SaveScene -Scene $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex]
        EnableGUI $False
        RunAllScenes -Patch
        EnableGUI $True
        PlaySound $Sounds.done
        ResetSceneEditorTypes
        Cleanup
    })

    $name                      = "Editor.PatchScenes." + $Files.json.sceneEditor.parse
    $label                     = CreateLabel    -X ($PatchButton.Right + (DPISize 15) )          -Y ($PatchButton.Top - (DPISize 10) ) -Width 180 -Height 30 -AddTo $SceneEditor.Dialog -Font $Fonts.SmallBold -Text "All Scenes:"
    $SceneEditor.PatchAll      = CreateCheckBox -X ($label.Right       + (DPISize 5)  )          -Y ($PatchButton.Top - (DPISize 12) ) -IsRadio              -AddTo $SceneEditor.Dialog -Checked $True -Name $name -SaveTo $name -SaveAs 1 -Max 3
    $label                     = CreateLabel    -X ($PatchButton.Right + (DPISize 15) )          -Y ($PatchButton.Top + (DPISize 10) ) -Width 180 -Height 30 -AddTo $SceneEditor.Dialog -Font $Fonts.SmallBold -Text "Dungeons Only:"
    $SceneEditor.PatchDungeons = CreateCheckBox -X ($label.Right       + (DPISize 5)  )          -Y ($PatchButton.Top + (DPISize 8)  ) -IsRadio              -AddTo $SceneEditor.Dialog -Disable $True -Name $name -SaveTo $name -SaveAs 2 -Max 3
    $label                     = CreateLabel    -X ($PatchButton.Right + (DPISize 15) )          -Y ($PatchButton.Top + (DPISize 30) ) -Width 180 -Height 30 -AddTo $SceneEditor.Dialog -Font $Fonts.SmallBold -Text "Current Scene:"
    $SceneEditor.PatchCurrent  = CreateCheckBox -X ($label.Right       + (DPISize 5)  )          -Y ($PatchButton.Top + (DPISize 28) ) -IsRadio              -AddTo $SceneEditor.Dialog -Disable $True -Name $name -SaveTo $name -SaveAs 3 -Max 3

    if     ($SceneEditor.PatchDungeons.Checked -and !$SceneEditor.PatchDungeons.Enabled)   { $SceneEditor.PatchAll.Checked = $True }
    elseif ($SceneEditor.PatchCurrent.Checked  -and !$SceneEditor.PatchCurrent.Enabled)    { $SceneEditor.PatchAll.Checked = $True }

    $name                      = "Editor.ShiftScenes." + $Files.json.sceneEditor.parse
    $label                     = CreateLabel    -X ($SceneEditor.PatchAll.Right + (DPISize 15) ) -Y ($PatchButton.Top - (DPISize 10) ) -Width 180 -Height 30 -AddTo $SceneEditor.Dialog -Font $Fonts.SmallBold -Text "Shift Scenes:" 
    $SceneEditor.ShiftScenes   = CreateCheckBox -X ($label.Right                + (DPISize 5)  ) -Y ($PatchButton.Top - (DPISize 12) )                       -AddTo $SceneEditor.Dialog -Checked $True -Name $name



    # Status Panel
    $SceneEditor.StatusPanel = CreatePanel -X (DPISize 10) -Y ( ($CloseButton.Top) + (DPISize 5) ) -Width (DPISize 300)                                    -Height (DPISize 25)                            -AddTo $SceneEditor.Dialog
    $SceneEditor.StatusLabel = CreateLabel -X (DPISize 10) -Y (DPISize 3)                          -Width ($SceneEditor.StatusPanel.Width - (DPISize 5)  ) -Height (DPISize 15) -Text "Awaiting action..." -AddTo $SceneEditor.StatusPanel
    $SceneEditor.StatusPanel.BackColor = 'White'
    


    # Help Window
    $button = CreateButton -X ($SceneEditor.StatusPanel.Right + (DPISize 5)) -Y ($SceneEditor.StatusPanel.Top - (DPISize 1)) -Width (DPISize 26) -Height (DPISize 26) -Font $Fonts.Medium -Text "?" -BackColor "White" -AddTo $SceneEditor.Dialog
    $button.Add_Click({ OpenHelpDialog })



    $name = "Editor.Scene." + $Files.json.sceneEditor.parse
    $label               = CreateLabel    -X (DPISize 10)                              -Y (DPISize 17)                                 -Width (DPISize 40)  -Height (DPISize 15) -Font $Fonts.SmallBold -Text "Scene:"      -AddTo $SceneEditor.TopGroup
    $SceneEditor.Scenes  = CreateComboBox -X ($label.Right + (DPISize 15) )            -Y ($label.Top - (DPISize 2) )                  -Width (DPISize 260) -Height (DPISize 20) -Items $Files.json.sceneEditor.scenes.Name -AddTo $SceneEditor.TopGroup -Name $name
    $label               = CreateLabel    -X (DPISize 10)                              -Y ($SceneEditor.Scenes.Bottom + (DPISize 12) ) -Width (DPISize 40)  -Height (DPISize 15) -Font $Fonts.SmallBold -Text "Map:"        -AddTo $SceneEditor.TopGroup
    $SceneEditor.Maps    = CreateComboBox -X ($label.Right + (DPISize 15) )            -Y ($label.Top - (DPISize 2) )                  -Width (DPISize 260) -Height (DPISize 20)                                            -AddTo $SceneEditor.TopGroup
    $SceneEditor.Headers = CreateComboBox -X ($SceneEditor.Maps.Right + (DPISize 15) ) -Y $SceneEditor.Maps.Top                        -Width (DPISize 260) -Height (DPISize 20)                                            -AddTo $SceneEditor.TopGroup

    $SceneEditor.Tabs  = @()
    $SceneEditor.Tabs += CreateButton -X ($SceneEditor.DeleteActor.Right - (DPISize 300) ) -Y ($SceneEditor.Headers.Top + (DPISize 5) ) -Width (DPISize 50)               -Height (DPISize 20)                -Text "1-50"    -BackColor "Red" -ForeColor "White" -AddTo $SceneEditor.TopGroup
    $SceneEditor.Tabs += CreateButton -X ($SceneEditor.Tabs[0].Right     + (DPISize 1)   ) -Y $SceneEditor.Tabs[0].Top                  -Width $SceneEditor.Tabs[0].width -Height $SceneEditor.Tabs[0].height -Text "51-100"  -BackColor "Red" -ForeColor "White" -AddTo $SceneEditor.TopGroup
    $SceneEditor.Tabs += CreateButton -X ($SceneEditor.Tabs[1].Right     + (DPISize 1)   ) -Y $SceneEditor.Tabs[0].Top                  -Width $SceneEditor.Tabs[0].width -Height $SceneEditor.Tabs[0].height -Text "101-150" -BackColor "Red" -ForeColor "White" -AddTo $SceneEditor.TopGroup
    $SceneEditor.Tabs += CreateButton -X ($SceneEditor.Tabs[2].Right     + (DPISize 1)   ) -Y $SceneEditor.Tabs[0].Top                  -Width $SceneEditor.Tabs[0].width -Height $SceneEditor.Tabs[0].height -Text "151-200" -BackColor "Red" -ForeColor "White" -AddTo $SceneEditor.TopGroup
    $SceneEditor.Tabs += CreateButton -X ($SceneEditor.Tabs[3].Right     + (DPISize 1)   ) -Y $SceneEditor.Tabs[0].Top                  -Width $SceneEditor.Tabs[0].width -Height $SceneEditor.Tabs[0].height -Text "201-255" -BackColor "Red" -ForeColor "White" -AddTo $SceneEditor.TopGroup
    
    $SceneEditor.Tabs[0].Add_Click({ LoadTab 1 })
    $SceneEditor.Tabs[1].Add_Click({ LoadTab 2 })
    $SceneEditor.Tabs[2].Add_Click({ LoadTab 3 })
    $SceneEditor.Tabs[3].Add_Click({ LoadTab 4 })
    $SceneEditor.Tabs[4].Add_Click({ LoadTab 5 })


    if ($Files.json.sceneEditor.quest -is [array] -and $Files.json.sceneEditor.quest.Count -gt 0) {
        $SceneEditor.QuestLabels = @()
        $SceneEditor.Quests      = @()

        $SceneEditor.QuestLabels += CreateLabel    -X ($SceneEditor.Scenes.Right         + (DPISize 15) ) -Y (DPISize 15) -Height (DPISize 15) -Font $Fonts.SmallBold -Text "Original:" -AddTo $SceneEditor.TopGroup
        $SceneEditor.Quests      += CreateCheckBox -X ($SceneEditor.QuestLabels[0].Right + (DPISize 5)  ) -Y (DPISize 13) -IsRadio                                                      -AddTo $SceneEditor.TopGroup -Checked $True
        $SceneEditor.QuestLabels[0].Visible = $SceneEditor.Quests[0].Visible = $False

         $SceneEditor.Quests[0].Add_CheckedChanged( {
            if ($SceneEditor.Quests[0].Visible -and $SceneEditor.Quests[0].Enabled -and $SceneEditor.Quests[0].Checked) {
                $Settings["Dungeon"][$SceneEditor.Scenes.Text] = 1
                LoadScene $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex] -Keep
            }
        } )

        foreach ($quest in $Files.json.sceneEditor.quest) {
            $SceneEditor.QuestLabels += CreateLabel    -X ($SceneEditor.Quests[$SceneEditor.Quests.Count-1].Right           + (DPISize 15) ) -Y (DPISize 15) -Height (DPISize 15) -Font $Fonts.SmallBold -Text ($quest + ":") -AddTo $SceneEditor.TopGroup
            $SceneEditor.Quests      += CreateCheckBox -X ($SceneEditor.QuestLabels[$SceneEditor.QuestLabels.Count-1].Right + (DPISize 5)  ) -Y (DPISize 13) -IsRadio                                                         -AddTo $SceneEditor.TopGroup
            $SceneEditor.QuestLabels[$SceneEditor.QuestLabels.Count-1].Visible = $SceneEditor.Quests[$SceneEditor.Quests.Count-1].Visible = $False

            Add-Member -InputObject $SceneEditor.Quests[$SceneEditor.Quests.Count-1] -NotePropertyMembers @{ Value = $SceneEditor.Quests.Count }
            $SceneEditor.Quests[$SceneEditor.Quests.Count-1].Add_CheckedChanged( {
                if ($this.Visible -and $this.Enabled -and $this.Checked) {
                    $Settings["Dungeon"][$SceneEditor.Scenes.Text] = $this.Value
                    LoadScene -Scene $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex] -Keep
                }
            } )
        }
    }



    # Select Scene
    if ($SceneEditor.Scenes.SelectedIndex -lt 0 -and $SceneEditor.Scenes.Items.Count -gt 0) { $SceneEditor.Scenes.SelectedIndex = 0 }
    LoadScene $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex]
    $SceneEditor.DropScene = $SceneEditor.Scenes.SelectedIndex

    $SceneEditor.Scenes.Add_SelectedIndexChanged({
        if ($this.SelectedIndex -eq $SceneEditor.DropScene) { return }
        $SceneEditor.DropScene = $this.SelectedIndex
        if (!$SceneEditor.Resetting) { SaveScene -Scene $SceneEditor.LastScene }
        LoadScene $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex]
    })



    # Select Map
    if (IsSet ($Settings["Core"]["Editor.Map." + $Files.json.sceneEditor.parse]) -and $SceneEditor.Maps.Items.Count -gt 0) {
        if ([byte]$Settings["Core"]["Editor.Map." + $Files.json.sceneEditor.parse] -le $SceneEditor.Maps.Items.Count) {
            $SceneEditor.Maps.SelectedIndex = $Settings["Core"]["Editor.Map." + $Files.json.sceneEditor.parse] - 1
        }
    }

    if ($SceneEditor.Maps.SelectedIndex -lt 0 -and $SceneEditor.Maps.Items.Count -gt 0) { $SceneEditor.Maps.SelectedIndex = 0 }
    LoadMap -Scene $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex] -Map 0
    $SceneEditor.DropMap   = $SceneEditor.Maps.SelectedIndex
    $SceneEditor.LastScene = $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex]
    $SceneEditor.LastMap   = $SceneEditor.Maps.SelectedIndex

    $SceneEditor.Maps.Add_SelectedIndexChanged({
        if ($this.SelectedIndex -eq $SceneEditor.DropMap) { return }
        $SceneEditor.DropMap = $this.SelectedIndex
        if (!$SceneEditor.Resetting) { SaveMap   -Scene $SceneEditor.LastScene -Index $SceneEditor.LastMap }
        LoadMap -Scene $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex] -Map 0
        $SceneEditor.LastScene  = $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex]
        $SceneEditor.LastMap    = $SceneEditor.Maps.SelectedIndex
        $SceneEditor.DropHeader = $null
    })

    

    # Select Header
    if (IsSet ($Settings["Core"]["Editor.Header." + $Files.json.sceneEditor.parse]) -and $SceneEditor.Headers.Items.Count -gt 0) {
        if ([byte]$Settings["Core"]["Editor.Header." + $Files.json.sceneEditor.parse] -le $SceneEditor.Headers.Items.Count) {
            $SceneEditor.Headers.SelectedIndex = $Settings["Core"]["Editor.Header." + $Files.json.sceneEditor.parse] - 1
        }
    }

    if ($SceneEditor.Headers.SelectedIndex -lt 0 -and $SceneEditor.Headers.Items.Count -gt 0) { $SceneEditor.Headers.SelectedIndex = 0 }
    $SceneEditor.DropHeader   = $SceneEditor.Headers.SelectedIndex
    $SceneEditor.LoadedHeader = $SceneEditor.Headers.SelectedIndex
    LoadHeader -Scene $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex]

    $SceneEditor.Headers.Add_SelectedIndexChanged({
        if ($this.SelectedIndex -eq $SceneEditor.DropHeader) { return }
        $SceneEditor.DropHeader   = $this.SelectedIndex
        $SceneEditor.LoadedHeader = $this.SelectedIndex
        LoadHeader -Scene $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex]
    })

}



#==============================================================================================================================================================================================
function LoadTab([byte]$Tab) {
    
    if ($Tab -lt 1 -or $Tab -gt $SceneEditor.Tabs.Count -or $Tab -eq $SceneEditor.Tab) { return }

    foreach ($elem in $SceneEditor.Tabs) { $elem.BackColor = "Red" }
    $SceneEditor.Tabs[$Tab-1].BackColor = "Green"
    $SceneEditor.Tab = $Tab
    LoadActors

}



#==============================================================================================================================================================================================
function RunSceneEditor([object]$Game=$null) {
    
    $global:SceneEditor      = @{}
    $SceneEditor.GameConsole = $Files.json.consoles[0]
    $SceneEditor.GameType    = $Game
    CreateSceneEditorDialog
    $SceneEditor.Dialog.Show()

}



#==============================================================================================================================================================================================
function CloseSceneEditor() {
    
    if ($SceneEditor.Dialog -eq $null) { return }
    $SceneEditor.Dialog.Hide()

    if ($SceneEditor.Maps.Items.Count -gt 0) {
        SaveMap   -Scene $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex] -Index $SceneEditor.Maps.SelectedIndex
        SaveScene -Scene $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex]
        $Settings["Core"]["Editor.Map."    + $Files.json.sceneEditor.parse] = $SceneEditor.Maps.SelectedIndex    + 1
        $Settings["Core"]["Editor.Header." + $Files.json.sceneEditor.parse] = $SceneEditor.Headers.SelectedIndex + 1
        if ($SceneEditor.Tab -ge 1 -and $SceneEditor.Tab -le $SceneEditor.Tabs.Count) { $Settings["Core"]["Editor.Tab." + $Files.json.sceneEditor.parse] = $SceneEditor.Tab }
    }

    $global:ByteScriptArray = $global:ByteTableArray = $Files.json.sceneEditor = $global:SceneEditor = $null
    if (TestFile ($GameFiles.base + "\Music.json")) { $Files.json.music = SetJSONFile ($GameFiles.base + "\Music.json") } else { $Files.json.music = $null }

}



#==============================================================================================================================================================================================
function SetSceneEditorTypes() {
    
    $SceneEditor.LastGameType    = $global:GameType
    $SceneEditor.LastGameConsole = $global:GameConsole
    $global:GameType             = $SceneEditor.GameType
    $global:GameConsole          = $SceneEditor.GameConsole

}



#==============================================================================================================================================================================================
function ResetSceneEditorTypes() {

    $global:GameType          = $SceneEditor.LastGameType
    $global:GameConsole       = $SceneEditor.LastGameConsole
    $SceneEditor.LastGameType = $SceneEditor.LastGameConsole = $null

}



#==============================================================================================================================================================================================
function OpenHelpDialog() {
    
    # Create Dialog
    $Dialog           = CreateDialog -Width (DPISize 600) -Height (DPISize 600)
    $Dialog.Icon      = $Files.icon.additional
    $Dialog.BackColor = 'AntiqueWhite'
    
    # Close Button
    $CloseButton           = CreateButton -X ($Dialog.Left + ($Dialog.Width / 3)) -Y ($Dialog.Height - (DPISize 90)) -Width (DPISize 90) -Height (DPISize 35) -Text "Close" -AddTo $Dialog
    $CloseButton.BackColor = "White"
    $CloseButton.Add_Click({ $Dialog.Hide() })

    # Text Box
    $textbox = CreateTextBox -X (DPISize 40) -Y (DPISize 30) -Width ($Dialog.Width - (DPISize 100)) -Height ($CloseButton.Top - (DPISize 40)) -ReadOnly -Multiline -TextFileFont -AddTo $Dialog
    AddTextFileToTextbox -TextBox $textbox -File ($Paths.Games + "\" + $TextEditor.GameType.mode + "\Guide Scene Editor.txt")

    # Show Dialog
    $Dialog.ShowDialog()

}



#==============================================================================================================================================================================================
function RunAllScenes([switch]$Patch, [switch]$Current) {
    
    if ($GamePath -eq $null) { UpdateStatusLabel -Text "Failed! No ROM path is given." -Error; return }

    UpdateStatusLabel -Text "Preparing ROM..."
    $global:PatchInfo     = @{}
    $PatchInfo.decompress = $True
    $global:CheckHashSum  = $Files.json.sceneEditor.hash
    $global:ROMFile       = SetROMParameters -Path $GamePath
    SetGetROM

    if ($IsWiiVC) {
        if (!(ExtractWADFile))    { return }   # Step A: Extract the contents of the WAD file
        if (!(CheckVCGameID))     { return }   # Step B: Check the GameID to be vanilla
        if (!(ExtractU8AppFile))  { return }   # Step C: Extract "00000005.app" file to get the ROM
        if (!(PatchVCROM))        { return }   # Step D: Do some initial patching stuff for the ROM for VC WAD files
    }

    if (!(Unpack))                                                              { PlaySound $Sounds.done; return }
    if (TestFile $GetROM.run)                                                   { $global:ROMHashSum   = (Get-FileHash -Algorithm MD5 -LiteralPath $GetROM.run).Hash }
    if ($Settings.Debug.IgnoreChecksum -eq $False -and (IsSet $CheckHashsum))   { $PatchInfo.downgrade = $ROMHashSum -ne $CheckHashSum                               }
    if ((Get-Item -LiteralPath $GetROM.run).length/"32MB" -ne 1) {
        UpdateStatusLabel "Failed! The ROM should be 32 MB!" -Error
        return $False
    }

    ConvertROM
    if (!(CompareHashSums))   { return }
    if (!(DecompressROM))     { return }
    $item                  = DowngradeROM
    $SceneEditor.Resetting = $True

    if ($Patch) {
        UpdateStatusLabel -Text "Patching all scenes..."
        Copy-Item -LiteralPath $GetROM.decomp -Destination $GetROM.cleanDecomp -Force

        if (PatchAllScenes) {
            [System.IO.File]::WriteAllBytes($GetROM.decomp, $ByteArrayGame)
            & $Files.tool.flips --create --bps $GetROM.cleanDecomp $GetROM.decomp $GameFiles.scenesPatch
            UpdateStatusLabel -Text "Success! A patch has been generated."
        }
        else { UpdateStatusLabel -Text "Failed! Extracted scenes were missing." -Error }
    }
    elseif ($Current) {
        UpdateStatusLabel -Text "Resetting the map..."

        if ($Files.json.sceneEditor.quest -is [array] -and $Files.json.sceneEditor.quest.Count -gt 0) {
            $vanilla = $True
            for ($i=0; $i -lt $Files.json.sceneEditor.quest.Count; $i++) {
                if ($SceneEditor.Quests[$i+1].Visible -and $SceneEditor.Quests[$i+1].Checked) {
                    $vanilla = $False
                    $file    = $Files.json.sceneEditor.quest[$i].ToLower()
                    while ($file -like "* *" ) { $file = $file.Replace(" ", "_") }
                    ApplyPatch -File $GetROM.decomp -Patch ("Games\" + $Files.json.sceneEditor.game + "\Decompressed\Dungeons\" + $file + ".bps") -FilesPath
                    ExtractAllScenes -Current -Quest $Files.json.sceneEditor.quest[$i]
                }
            }
            if ($vanilla) { ExtractAllScenes -Current }
        }
        else { ExtractAllScenes -Current }

        UpdateStatusLabel -Text "Success! The map has been reset."
        LoadMap -Scene $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex] -Map 0
    }
    else {
        UpdateStatusLabel -Text "Extracting all scenes..."
        Copy-Item -LiteralPath $GetROM.decomp -Destination $GetROM.cleanDecomp -Force
        
        if ($SceneEditor.PatchAll.Checked) {
            RemovePath    ($Paths.Games + "\" + $Files.json.sceneEditor.game + "\Editor\Scenes")
            CreateSubPath ($Paths.Games + "\" + $Files.json.sceneEditor.game + "\Editor\Scenes")
        }
        
        ExtractAllScenes

        if ($Files.json.sceneEditor.quest -is [array] -and $Files.json.sceneEditor.quest.Count -gt 0) {
            foreach ($quest in $Files.json.sceneEditor.quest) {
                $file = $quest.ToLower()
                while ($file -like "* *") { $file = $file.Replace(" ", "_") }
                if (TestFile -Path ($Paths.Games + "\" + $Files.json.sceneEditor.game  + "\Decompressed\Dungeons\" + $file +".bps") ) {
                    ApplyPatch -File $GetROM.cleanDecomp -Patch ("Games\" +$Files.json.sceneEditor.game + "\Decompressed\Dungeons\" + $file + ".bps") -FilesPath -New $GetROM.decomp
                    ExtractAllScenes -Quest $quest
                }
            }
        }

        UpdateStatusLabel -Text "Success! The scenes have been extracted."
        $SceneEditor.DropScene  = $null
        $SceneEditor.SceneArray = $null
        LoadScene $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex]
        $SceneEditor.DropScene = $SceneEditor.Scenes.SelectedIndex
    }

    $SceneEditor.Resetting = $False

}


#==============================================================================================================================================================================================
function ExtractAllScenes([switch]$Current, [String]$Quest="Normal Quest") {
    
    $global:ByteArrayGame = [System.IO.File]::ReadAllBytes($GetROM.decomp)

    if ($Current) {
        foreach ($scene in $Files.json.sceneEditor.scenes) {
            if ($scene.name -eq $SceneEditor.Scenes.Text) { break }
        }
        if ($scene -eq $null) { return }

        if ($scene.dungeon -eq 1 -and $Quest -ne "Normal Quest") {
            CreateSubPath      ($Paths.Games + "\" + $Files.json.sceneEditor.game + "\Editor\Scenes\" + $Scene.name + "\" + $Quest)
            ExtractScene -Path ($Paths.Games + "\" + $Files.json.sceneEditor.game + "\Editor\Scenes\" + $Scene.name + "\" + $Quest) -Offset $scene.dma -Length $scene.length -Current
        }
        elseif ($Quest -eq "Normal Quest") { ExtractScene -Path ($Paths.Games + "\" + $Files.json.sceneEditor.game + "\Editor\Scenes\" + $scene.name) -Offset $scene.dma -Length $scene.length -Current }
    }
    else {
        foreach ($scene in $Files.json.sceneEditor.scenes) {
            if     ($SceneEditor.PatchDungeons.Checked -and $scene.dungeon -ne 1)                          { continue }
            elseif ($SceneEditor.PatchCurrent.Checked  -and $scene.name    -ne $SceneEditor.Scenes.Text)   { continue }

            if ($scene.dungeon -eq 1 -and $Quest -ne "Normal Quest") {
                CreateSubPath      ($Paths.Games + "\" + $Files.json.sceneEditor.game + "\Editor\Scenes\" + $Scene.name + "\" + $Quest)
                ExtractScene -Path ($Paths.Games + "\" + $Files.json.sceneEditor.game + "\Editor\Scenes\" + $Scene.name + "\" + $Quest) -Offset $scene.dma -Length $scene.length
            }
            elseif ($Quest -eq "Normal Quest") { ExtractScene -Path ($Paths.Games + "\" + $Files.json.sceneEditor.game + "\Editor\Scenes\" + $scene.name) -Offset $scene.dma -Length $scene.length }
        }
    }

}



#==============================================================================================================================================================================================
function ExtractScene([switch]$Current, [string]$Path, [string]$Offset, [byte]$Length) {
    
    if (!$Current) { RemovePath $Path }

    $End   = Get24Bit ( (GetDecimal $Offset) + ($Length * 16) + 16)
    $Table = $ByteArrayGame[(GetDecimal $Offset)..(GetDecimal $End)]
    CreateSubPath $Path

    if (!$Current) { ExportBytes -Offset $Offset -End $End -Output ($Path + "\table.dma") -Silent }
    
    for ($i=0; $i -le $Length; $i++) {
        $Start = (Get8Bit $Table[($i*16)+0]) + (Get8Bit $Table[($i*16)+1]) + (Get8Bit $Table[($i*16)+2]) + (Get8Bit $Table[($i*16)+3])
        $End   = (Get8Bit $Table[($i*16)+4]) + (Get8Bit $Table[($i*16)+5]) + (Get8Bit $Table[($i*16)+6]) + (Get8Bit $Table[($i*16)+7])

        if ($Current -and ($i-1) -ne $SceneEditor.Maps.SelectedIndex) { continue }

        if ($i -eq 0 -and !$Current)   { ExportBytes -Offset $Start -End $End -Output ($Path + "\scene.zscene")             -Force -Silent }
        else                           { ExportBytes -Offset $Start -End $End -Output ($Path + "\room_" + ($i-1) + ".zmap") -Force -Silent }
    }

    $dmaArray   = [System.IO.File]::ReadAllBytes($Path + "\table.dma")
    $sceneArray = [System.IO.File]::ReadAllBytes($Path + "\scene.zscene")

    $headerSize     = 104
    $mapStart       = @()

    for ($i=0; $i -lt $headerSize; $i+=8) {
        if     ($sceneArray[$i] -eq 20)   { break }
        elseif ($sceneArray[$i] -eq 0)    { $positionStart  = $sceneArray[$i + 5] * 65536 + $sceneArray[$i + 6] * 256 + $sceneArray[$i + 7] } # Start Positions List
        elseif ($sceneArray[$i] -eq 4)    { $mapStart      += $sceneArray[$i + 5] * 65536 + $sceneArray[$i + 6] * 256 + $sceneArray[$i + 7] } # Map List
        elseif ($sceneArray[$i] -eq 24)   { $alternateStart = $sceneArray[$i + 5] * 65536 + $sceneArray[$i + 6] * 256 + $sceneArray[$i + 7] } # Alternate Headers
    }

    if (IsSet $alternateStart) {
        for ($i=$alternateStart; $i -lt $positionStart; $i+=4) {
            if ($sceneArray[$i] -ne 2) { continue }
            $headerOffset = $sceneArray[$i + 1] * 65536 + $sceneArray[$i + 2] * 256 + $sceneArray[$i + 3]

            for ($j=$headerOffset; $j -lt ($headerOffset + $headerSize); $j+=8) {
                if     ($sceneArray[$j] -eq 20)   { break }
                elseif ($sceneArray[$j] -eq 4)    { $mapStart += $sceneArray[$j + 5] * 65536 + $sceneArray[$j + 6] * 256 + $sceneArray[$j + 7] } # Map List
            }
        }
    }

    if (!(IsChecked $SceneEditor.ShiftScenes) -or !$SceneEditor.GUI) { return }

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

    foreach ($scene in $Files.json.sceneEditor.scenes) {
        if     ($SceneEditor.PatchDungeons.Checked -and $scene.dungeon -ne 1)                          { continue }
        elseif ($SceneEditor.PatchCurrent.Checked  -and $scene.name    -ne $SceneEditor.Scenes.Text)   { continue }

        if (!(PatchScene -Path ("Scenes\" + $Scene.name) -Offset $Scene.dma -Length $Scene.length -Scene $scene)) { return $False }
    }
    return $True
    
}



#==============================================================================================================================================================================================
function PatchScene([string]$Path, [string]$Offset, [byte]$Length, [object]$Scene) {
    
    if ($Scene.Dungeon -eq 1 -and (IsSet $Settings["Dungeon"][$SceneEditor.Scenes.Text]) -and $Files.json.sceneEditor.quest -is [array] -and $Files.json.sceneEditor.quest.Count -gt 0) {
        for ($i=0; $i -lt $Files.json.sceneEditor.quest.Count; $i++) {
            if ($Settings["Dungeon"][$Scene.Name] -eq $i+2) { $path += "\" + $Files.json.sceneEditor.quest[$i] }
        }
    }

    if (!(TestFile -Path ($Paths.Games + "\" + $Files.json.sceneEditor.game + "\Editor\" + $Path) -Container)) { return $False }

    $Start = Get24Bit ( (GetDecimal $Offset) )
    $End   = Get24Bit ( (GetDecimal $Start) + ($Length * 16) + 16)

    if (IsChecked $SceneEditor.ShiftScenes) {
        $dmaArray = [System.IO.File]::ReadAllBytes(($Paths.Games + "\" + $Files.json.sceneEditor.game + "\Editor\" + $Path + "\table.dma"))
        for ($i=0; $i -lt $dmaArray.Count; $i++) { $ByteArrayGame[(GetDecimal $Start) + $i] = $dmaArray[$i] }
    }

    $table = $ByteArrayGame[(GetDecimal $Start)..(GetDecimal $End)]
    for ($i=0; $i -le $Length; $i++) {
        $offset = (Get8Bit $table[($i*16)+0]) + (Get8Bit $table[($i*16)+1]) + (Get8Bit $table[($i*16)+2]) + (Get8Bit $table[($i*16)+3])
        if ($i -eq 0)   { PatchBytes -Offset $offset -Patch ($Path + "\scene.zscene")             -Editor -Silent }
        else            { PatchBytes -Offset $offset -Patch ($Path + "\room_" + ($i-1) + ".zmap") -Editor -Silent }
    }

    return $True

}


#==============================================================================================================================================================================================
function SaveMap([object[]]$Scene, [sbyte]$Index) {
    
    if ($Index -eq -1) { return }
    
    $map = $Paths.Games + "\" + $Files.json.sceneEditor.game + "\Editor\Scenes\" + $Scene.Name
    if ($Scene.Dungeon -eq 1 -and (IsSet $Settings["Dungeon"][$SceneEditor.Scenes.Text]) ) {
        if     ($Settings["Dungeon"][$SceneEditor.Scenes.Text] -eq 2)   { $map += "\Master Quest" }
        elseif ($Settings["Dungeon"][$SceneEditor.Scenes.Text] -eq 3)   { $map += "\Ura Quest"    }
    }
    $map += "\room_" + $Index + ".zmap"
    
    if (TestFile -Path $map) { [System.IO.File]::WriteAllBytes($map, $SceneEditor.MapArray) }
}



#==============================================================================================================================================================================================
function SaveScene([object[]]$Scene) {
    
    $file = $Paths.Games + "\" + $Files.json.sceneEditor.game + "\Editor\Scenes\" + $Scene.Name
    if ($Scene.Dungeon -eq 1 -and (IsSet $Settings["Dungeon"][$SceneEditor.Scenes.Text]) ) {
        if     ($Settings["Dungeon"][$SceneEditor.Scenes.Text] -eq 2)   { $file += "\Master Quest" }
        elseif ($Settings["Dungeon"][$SceneEditor.Scenes.Text] -eq 3)   { $file += "\Ura Quest"    }
    }
    $dma   = $file + "\table.dma"
    $file += "\scene.zscene"

    if (!(TestFile -Path $file) -or !(TestFile -Path $dma)) { return }

    if (!(IsChecked $SceneEditor.ShiftScenes)) {
        [System.IO.File]::WriteAllBytes($file, $SceneEditor.SceneArray)
        return
    }

    [System.Collections.ArrayList]$dmaArray = [System.IO.File]::ReadAllBytes($dma)

    for ($i=0; $i-lt $Scene.length; $i++) {
        $mapStart = $dmaArray[$i*16+4] * 0x1000000 + $dmaArray[$i*16+4+1] * 0x10000 + $dmaArray[$i*16+4+2] * 0x100 + $dmaArray[$i*16+4+3]
        $mapEnd   = $mapStart + $SceneEditor.MapArray.Count
    
        $mapStart = (Get32Bit $mapStart) -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) }
        $mapEnd   = (Get32Bit $mapEnd)   -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) }

        for ($j=0; $j-lt $SceneEditor.Sceneoffsets.MapStart.Count; $j++) {
            $SceneEditor.SceneArray[$SceneEditor.Sceneoffsets[$j].MapStart+0 + $i*8] = $mapStart[0]
            $SceneEditor.SceneArray[$SceneEditor.Sceneoffsets[$j].MapStart+1 + $i*8] = $mapStart[1]
            $SceneEditor.SceneArray[$SceneEditor.Sceneoffsets[$j].MapStart+2 + $i*8] = $mapStart[2]
            $SceneEditor.SceneArray[$SceneEditor.Sceneoffsets[$j].MapStart+3 + $i*8] = $mapStart[3]
            $SceneEditor.SceneArray[$SceneEditor.Sceneoffsets[$j].MapStart+4 + $i*8] = $mapEnd[0]
            $SceneEditor.SceneArray[$SceneEditor.Sceneoffsets[$j].MapStart+5 + $i*8] = $mapEnd[1]
            $SceneEditor.SceneArray[$SceneEditor.Sceneoffsets[$j].MapStart+6 + $i*8] = $mapEnd[2]
            $SceneEditor.SceneArray[$SceneEditor.Sceneoffsets[$j].MapStart+7 + $i*8] = $mapEnd[3]
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

    [System.IO.File]::WriteAllBytes($file, $SceneEditor.SceneArray)
    [System.IO.File]::WriteAllBytes($dma,  $dmaArray)

}



#==============================================================================================================================================================================================
function ChangeMap([string]$Offset, [object]$Values, [switch]$Silent) {
    
    if     ($Values -is [String] -and $Values -Like "* *")              { $ValuesDec = $Values -split ' '           | foreach { [Convert]::ToByte($_, 16) } }
    elseif ($Values -is [String])                                       { $ValuesDec = $Values -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) } }
    elseif ($Values -is [Array]  -and $Values[0] -is [System.String])   { $ValuesDec = $Values                      | foreach { [Convert]::ToByte($_, 16) } }
    else                                                                { $ValuesDec = $Values }

    foreach ($i in 0..($ValuesDec.Length-1)) {
        $SceneEditor.MapArray[(GetDecimal $Offset) + $i] = $ValuesDec[$i]
    }

    if (!$Silent) { WriteToConsole ($Offset + " -> Change values: " + $Values) }

}



#==============================================================================================================================================================================================
function ChangeScene([string]$Offset, [object]$Values, [switch]$Silent) {
    
    if     ($Values -is [String] -and $Values -Like "* *")              { $ValuesDec = $Values -split ' '           | foreach { [Convert]::ToByte($_, 16) } }
    elseif ($Values -is [String])                                       { $ValuesDec = $Values -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) } }
    elseif ($Values -is [Array]  -and $Values[0] -is [System.String])   { $ValuesDec = $Values                      | foreach { [Convert]::ToByte($_, 16) } }
    else                                                                { $ValuesDec = $Values }

    foreach ($i in 0..($ValuesDec.Length-1)) {
        $SceneEditor.SceneArray[(GetDecimal $Offset) + $i] = $ValuesDec[$i]
    }

    if (!$Silent) { WriteToConsole ($Offset + " -> Change values: " + $Values) }

}



#==============================================================================================================================================================================================
function ShiftMap([uint32]$Offset, [int16]$Shift=0) {
    
    $values = @()
    if ($Shift -gt 0) {
        while ($Shift -ne 0) {
            if ($Shift -gt 255) { $values += 255; $Shift -= 255 } else { $values += $Shift; $Shift = 0 }
        }

        foreach ($value in $values) {
            if ($SceneEditor.MapArray[$Offset+2] + $value -gt 255) {
                if ($SceneEditor.MapArray[$Offset+1] + 1 -gt 255) {
                    $SceneEditor.MapArray[$Offset]   += 1
                    $SceneEditor.MapArray[$Offset+1]  = 0
                    $SceneEditor.MapArray[$Offset+2] += $value - 256
                }
                else {
                    $SceneEditor.MapArray[$Offset+1]++
                    $SceneEditor.MapArray[$Offset+2] += $value - 256
                }
            }
            else { $SceneEditor.MapArray[$Offset+2] += $value }
        }
    }
    elseif ($Shift -lt 0) {
        while ($Shift -ne 0) {
            if ($Shift -lt (-255)) { $values += 255; $Shift += 255 } else { $values += (-$Shift); $Shift = 0 }
        }

        foreach ($value in $values) {
            if ($SceneEditor.MapArray[$Offset+2] - $value -lt 0) {
                if ($SceneEditor.MapArray[$Offset+1] - 1 -lt 0) {
                    $SceneEditor.MapArray[$Offset]   -= 1
                    $SceneEditor.MapArray[$Offset+1]  = 0
                    $SceneEditor.MapArray[$Offset+2] += 256 - $value
                }
                else {
                    $SceneEditor.MapArray[$Offset+1]--
                    $SceneEditor.MapArray[$Offset+2] += 256 - $value
                }
            }
            else { $SceneEditor.MapArray[$Offset+2] -= $value }
        }
    }

}



#==============================================================================================================================================================================================
function ShiftScene([uint32]$Offset, [int16]$Shift=0) {
    
    $values = @()
    if ($Shift -gt 0) {
        while ($Shift -ne 0) {
            if ($Shift -gt 255) { $values += 255; $Shift -= 255 } else { $values += $Shift; $Shift = 0 }
        }

        foreach ($value in $values) {
            if ($SceneEditor.SceneArray[$Offset+2] + $value -gt 255) {
                if ($SceneEditor.SceneArray[$Offset+1] + 1 -gt 255) {
                    $SceneEditor.SceneArray[$Offset]   += 1
                    $SceneEditor.SceneArray[$Offset+1]  = 0
                    $SceneEditor.SceneArray[$Offset+2] += $value - 256
                }
                else {
                    $SceneEditor.SceneArray[$Offset+1]++
                    $SceneEditor.SceneArray[$Offset+2] += $value - 256
                }
            }
            else { $SceneEditor.SceneArray[$Offset+2] += $value }
        }
    }
    elseif ($Shift -gt 0) {
        while ($Shift -ne 0) {
            if ($Shift -lt (-255)) { $values += 255; $Shift += 255 } else { $values += (-$Shift); $Shift = 0 }
        }

        foreach ($value in $values) {
            if ($SceneEditor.SceneArray[$Offset+2] - $value -lt 0) {
                if ($SceneEditor.SceneArray[$Offset+1] - 1 -lt 0) {
                    $SceneEditor.SceneArray[$Offset]   -= 1
                    $SceneEditor.SceneArray[$Offset+1]  = 0
                    $SceneEditor.SceneArray[$Offset+2] += 256 - $value
                }
                else {
                    $SceneEditor.SceneArray[$Offset+1]--
                    $SceneEditor.SceneArray[$Offset+2] += 256 - $value
                }
            }
            else { $SceneEditor.SceneArray[$Offset+2] -= $value }
        }
    }

}



#==============================================================================================================================================================================================
function PrepareMap([string]$Scene, [byte]$Map, [byte]$Header, [switch]$Shift) {
    
    $LoadedScene                                       = $null
    [System.Collections.ArrayList]$SceneEditor.Actors  = @()
    [System.Collections.ArrayList]$SceneEditor.Objects = @()

    foreach ($obj in $Files.json.sceneEditor.scenes) {
        if ($obj.name -eq $Scene) {
            $LoadedScene = $obj
            break
        }
    }

    if ($LoadedScene -eq $null) {
        $SceneEditor.LoadedScene = $SceneEditor.LoadedMap = $SceneEditor.LoadedHeader = $null
        WriteToConsole ("Could not load scene file: " + $Scene) -Error
        return
    }

    if ($LoadedScene -ne $SceneEditor.LoadedScene) {
        $SceneEditor.Shift       = $Shift
        $SceneEditor.LoadedScene = $LoadedScene
        $SceneEditor.LoadedMap   = $null
        $SceneEditor.MapShift    = $SceneEditor.SceneMapShift = 0
        $folder                  = $Paths.Temp + "\scene"
        $file                    = $Paths.Temp + "\scene\scene.zscene"
        RemovePath         ($Paths.Temp + "\scene")
        ExtractScene -Path ($Paths.Temp + "\scene") -Offset $LoadedScene.dma -Length $LoadedScene.length
        RunLoadScene -File $file
        [System.Collections.ArrayList]$SceneEditor.QueuedBytes = @()
        if ($Files.json.sceneEditor.parse -eq "oot") {
            ExportBytes -Offset 0xB65C64 -End 0xB65E04 -Output ($Paths.Temp + "\scene\cutscenes.tbl") -Force -Silent
            ExportBytes -Offset 0xB71440 -End 0xB71C24 -Output ($Paths.Temp + "\scene\scenes.tbl")    -Force -Silent
            ExportBytes -Offset 0xB71D4C -End 0xB71DEC -Output ($Paths.Temp + "\scene\textures.tbl")  -Force -Silent
        }
    }

    if ($Map -lt 0 -or $Map -gt $SceneEditor.SceneOffsets[0].MapCount) {
        $SceneEditor.LoadedScene = $SceneEditor.LoadedMap = $SceneEditor.LoadedHeader = $null
        WriteToConsole ("Could not load map index " + $Map + " for scene: " + $Scene) -Error
        return
    }
    
    if ($Map -ne $SceneEditor.LoadedMap) {
        $SceneEditor.MapShift  = 0
        $SceneEditor.LoadedMap = $Map
        LoadMap
    }

    $SceneEditor.LoadedHeader = $Header

    WriteToConsole ("Loaded Scene:            " + $Scene + " with Map Index: " + $Map + " and Header Index: " + $Header)

}



#==============================================================================================================================================================================================
function SaveLoadedMap([switch]$Silent) {
    
    if ($SceneEditor.LoadedScene -eq $null) { return }
    
    if ($SceneEditor.MapShift -ne 0) {
        ShiftMapVtxData -Shift $SceneEditor.MapShift
        $SceneEditor.MapShift = 0
    }

    $map  = $Paths.Temp + "\scene\room_" + $SceneEditor.LoadedMap + ".zmap"
    $dma  = $Paths.Temp + "\scene\table.dma"
    $file = $Paths.Temp + "\scene\scene.zscene"

    [System.Collections.ArrayList]$dmaArray = [System.IO.File]::ReadAllBytes($dma)
    [System.IO.File]::WriteAllBytes($map, $SceneEditor.MapArray)

    $oriEnd  = [System.BitConverter]::GetBytes($dmaArray[4] * 0x1000000 + $dmaArray[5] * 0x10000 + $dmaArray[6] * 0x100 + $dmaArray[7])
    $newEnd  = [System.BitConverter]::GetBytes($SceneEditor.SceneArray.count + $dmaArray[0] * 0x1000000 + $dmaArray[1] * 0x10000 + $dmaArray[2] * 0x100 + $dmaArray[3])

    if (-not !((Compare-Object $oriEnd $newEnd -SyncWindow 0))) {
        $dmaArray[4] = $newEnd[3]
        $dmaArray[5] = $newEnd[2]
        $dmaArray[6] = $newEnd[1]
        $dmaArray[7] = $newEnd[0]
    }

    for ($i=0; $i-lt $SceneEditor.LoadedScene.length; $i++) {
        if ($SceneEditor.Shift)   {
            if ($i -eq 0)   { $mapStart = $dmaArray[ $i * 16]     * 0x1000000 + $dmaArray[ $i * 16 + 1]     * 0x10000 + $dmaArray[ $i * 16 + 2]     * 0x100 + $dmaArray[ $i * 16 + 3] + $SceneEditor.SceneArray.count }
            else            { $mapStart = $dmaArray[ $i * 16 + 4] * 0x1000000 + $dmaArray[ $i * 16 + 4 + 1] * 0x10000 + $dmaArray[ $i * 16 + 4 + 2] * 0x100 + $dmaArray[ $i * 16 + 4 + 3]                             }
        }
        else { $mapStart = $dmaArray[($i + 1) * 16] * 0x1000000 + $dmaArray[($i + 1) * 16 + 1] * 0x10000 + $dmaArray[($i + 1) * 16 + 2] * 0x100 + $dmaArray[($i + 1) * 16 + 3] }
        $mapEnd = $mapStart + (Get-Item ($Paths.Temp + "\scene\room_" + $i + ".zmap")).length

        $mapStart = (Get32Bit $mapStart) -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) }
        $mapEnd   = (Get32Bit $mapEnd)   -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) }

        for ($j=0; $j-lt $SceneEditor.Sceneoffsets.MapStart.Count; $j++) {
            if ($SceneEditor.Shift) {
                $SceneEditor.SceneArray[$SceneEditor.Sceneoffsets[$j].MapStart+0 + $i*8] = $mapStart[0]
                $SceneEditor.SceneArray[$SceneEditor.Sceneoffsets[$j].MapStart+1 + $i*8] = $mapStart[1]
                $SceneEditor.SceneArray[$SceneEditor.Sceneoffsets[$j].MapStart+2 + $i*8] = $mapStart[2]
                $SceneEditor.SceneArray[$SceneEditor.Sceneoffsets[$j].MapStart+3 + $i*8] = $mapStart[3]
            }
            $SceneEditor.SceneArray[$SceneEditor.Sceneoffsets[$j].MapStart+4 + $i*8] = $mapEnd[0]
            $SceneEditor.SceneArray[$SceneEditor.Sceneoffsets[$j].MapStart+5 + $i*8] = $mapEnd[1]
            $SceneEditor.SceneArray[$SceneEditor.Sceneoffsets[$j].MapStart+6 + $i*8] = $mapEnd[2]
            $SceneEditor.SceneArray[$SceneEditor.Sceneoffsets[$j].MapStart+7 + $i*8] = $mapEnd[3]
        }
        
        $j = 16 * $i + 16
        if ($SceneEditor.Shift) {
            $dmaArray[$j + 0] = $dmaArray[$j + 8]  = $mapStart[0]
            $dmaArray[$j + 1] = $dmaArray[$j + 9]  = $mapStart[1]
            $dmaArray[$j + 2] = $dmaArray[$j + 10] = $mapStart[2]
            $dmaArray[$j + 3] = $dmaArray[$j + 11] = $mapStart[3]
        }
        $dmaArray[$j + 4] = $mapEnd[0]
        $dmaArray[$j + 5] = $mapEnd[1]
        $dmaArray[$j + 6] = $mapEnd[2]
        $dmaArray[$j + 7] = $mapEnd[3]
    }

    [System.IO.File]::WriteAllBytes($file, $SceneEditor.SceneArray)
    [System.IO.File]::WriteAllBytes($dma,  $dmaArray)
    if (!$Silent) { WriteToConsole ("Saved scene & map:       " + $SceneEditor.LoadedScene.name + " " + $SceneEditor.LoadedMap) }

}



#==============================================================================================================================================================================================
function PatchLoadedScene([switch]$Silent) {
    
    if ($SceneEditor.LoadedScene -eq $null) { return }
    if (!(TestFile -Path ($Paths.Temp + "\scene") -Container)) { return }

    if ($SceneEditor.SceneMapShift -ne 0) {
        ShiftSceneMapData -Shift $SceneEditor.SceneMapShift
        $SceneEditor.SceneMapShift = 0
    }
    
    $length = $SceneEditor.LoadedScene.length
    $offset = $SceneEditor.LoadedScene.dma
    $start  =  GetDecimal $offset
    $end    = (GetDecimal $start) + ($length * 16) + 16
    $dmaArray = [System.IO.File]::ReadAllBytes(($Paths.Temp + "\scene\table.dma"))

    if ($Files.json.sceneEditor.parse -eq "oot") {
        PatchBytes -Offset 0xB65C64 -Patch ("scene\cutscenes.tbl") -Temp -Silent # Debug: B95394 -> B95534, Rev0: B65C64 -> B65E04
        PatchBytes -Offset 0xB71440 -Patch ("scene\scenes.tbl")    -Temp -Silent # Debug: BA0BB0 -> BA1448, Rev0: B71440 -> B71C24
        PatchBytes -Offset 0xB71D4C -Patch ("scene\textures.tbl")  -Temp -Silent # Debug: BA1498 -> BA1538, Rev0: B71D4C -> B71DEC
    }

    if ($SceneEditor.QueuedBytes.count -gt 0) {
        foreach ($queue in $SceneEditor.QueuedBytes) { ChangeBytes -Offset $queue.offset -Values $queue.value -Add -Silent }
        [System.Collections.ArrayList]$SceneEditor.QueuedBytes = @()
    }

    for ($i=0; $i -lt $dmaArray.Count; $i++) { $ByteArrayGame[$start + $i] = $dmaArray[$i] }

    $table = $ByteArrayGame[$start..$end]
    for ($i=0; $i -le $length; $i++) {
        $offset = (Get8Bit $table[($i*16)+0]) + (Get8Bit $table[($i*16)+1]) + (Get8Bit $table[($i*16)+2]) + (Get8Bit $table[($i*16)+3])
        if ($i -eq 0)   { PatchBytes -Offset $offset -Patch ("scene\scene.zscene")             -Temp -Silent }
        else            { PatchBytes -Offset $offset -Patch ("scene\room_" + ($i-1) + ".zmap") -Temp -Silent }
    }

    if (!$Silent) { WriteToConsole ("Patched scene:           " + $SceneEditor.LoadedScene.name) }

}


#==============================================================================================================================================================================================
function ShiftActors([sbyte]$Shift) {
    
    switch ($SceneEditor.LoadedScene.Name) {
        "Kokiri Forest" {
            $SceneEditor.QueuedBytes.add(@{ offset = 0xE297B7; value = $Shift }) # Saria
            break
        }
        "Graveyard" {
            if ($SceneEditor.LoadedHeader -eq 0) {
                $SceneEditor.QueuedBytes.add(@{ offset = 0xE09D37; value = $Shift }) # Royal Tomb Gravestone
                $SceneEditor.QueuedBytes.add(@{ offset = 0xE09D47; value = $Shift }) # Royal Tomb Gravestone
            }
            break
        }
        "Sacred Forest Meadow" {
            if ($SceneEditor.LoadedHeader -eq 0) {
                $SceneEditor.QueuedBytes.add(@{ offset = 0xE29D63; value = $Shift }) # Saria
                $SceneEditor.QueuedBytes.add(@{ offset = 0xC7BA4F; value = $Shift }) # Sheik
            }
            break
        }
        "Lake Hylia" {
                                                   $SceneEditor.QueuedBytes.add(@{ offset = 0xE31307; value = $Shift })   # Owl
            if ($SceneEditor.LoadedHeader -eq 0) { $SceneEditor.QueuedBytes.add(@{ offset = 0xE9E227; value = $Shift }) } # Fire Array Sun
            break
        }
        "Goron City" {
            if ($SceneEditor.LoadedHeader -eq 0) { $SceneEditor.QueuedBytes.add(@{ offset = 0xCF11D7; value = $Shift }) } # Sheik
            break
        }
        "Death Mountain Crater" {
            if ($SceneEditor.LoadedHeader -eq 0) { $SceneEditor.QueuedBytes.add(@{ offset = 0xC7BC03; value = $Shift }) } # Sheik
            break
        }
    }

}



#==============================================================================================================================================================================================
function ShiftTexturesTable([sbyte]$Shift) {
    
    # Debug: BA1498 -> BA1538
    # Rev0:  B71D4C -> B71DEC

    switch ($SceneEditor.LoadedScene.Name) {
        "Inside the Deku Tree"       { ChangeBytes -File ($Paths.Temp + "\scene\textures.tbl") -Offset (3 + 4 * 0)  -Values $Shift -Repeat 1 -Interval 4 -Add -Silent; break } # 0  - 1
        "Dodongo's Cavern"           { ChangeBytes -File ($Paths.Temp + "\scene\textures.tbl") -Offset (3 + 4 * 2)  -Values $Shift -Repeat 9 -Interval 4 -Add -Silent; break } # 2  - 11
        "Thieves' Hideout"           { ChangeBytes -File ($Paths.Temp + "\scene\textures.tbl") -Offset (3 + 4 * 12) -Values $Shift -Repeat 1 -Interval 4 -Add -Silent; break } # 12 - 13
        "Water Temple"               { ChangeBytes -File ($Paths.Temp + "\scene\textures.tbl") -Offset (3 + 4 * 14) -Values $Shift -Repeat 1 -Interval 4 -Add -Silent; break } # 14 - 15
        "Ice Cavern"                 { ChangeBytes -File ($Paths.Temp + "\scene\textures.tbl") -Offset (3 + 4 * 16) -Values $Shift -Repeat 1 -Interval 4 -Add -Silent; break } # 16 - 17
        "Gerudo's Training Ground"   { ChangeBytes -File ($Paths.Temp + "\scene\textures.tbl") -Offset (3 + 4 * 18) -Values $Shift -Repeat 1 -Interval 4 -Add -Silent; break } # 18 - 19
        "Ranch House & Silo"         { ChangeBytes -File ($Paths.Temp + "\scene\textures.tbl") -Offset (3 + 4 * 20) -Values $Shift -Repeat 1 -Interval 4 -Add -Silent; break } # 20 - 21
        "Guard's House"              { ChangeBytes -File ($Paths.Temp + "\scene\textures.tbl") -Offset (3 + 4 * 22) -Values $Shift -Repeat 1 -Interval 4 -Add -Silent; break } # 22 - 25
        "Forest Temple"              { ChangeBytes -File ($Paths.Temp + "\scene\textures.tbl") -Offset (3 + 4 * 26) -Values $Shift -Repeat 1 -Interval 4 -Add -Silent; break } # 26 - 27
        "Spirit Temple"              { ChangeBytes -File ($Paths.Temp + "\scene\textures.tbl") -Offset (3 + 4 * 28) -Values $Shift -Repeat 1 -Interval 4 -Add -Silent; break } # 28 - 29
        "Kakariko Village"           { ChangeBytes -File ($Paths.Temp + "\scene\textures.tbl") -Offset (3 + 4 * 30) -Values $Shift -Repeat 1 -Interval 4 -Add -Silent; break } # 30 - 31
        "Zora's Domain"              { ChangeBytes -File ($Paths.Temp + "\scene\textures.tbl") -Offset (3 + 4 * 32) -Values $Shift -Repeat 1 -Interval 4 -Add -Silent; break } # 32 - 33
        "Gerudo's Fortress"          { ChangeBytes -File ($Paths.Temp + "\scene\textures.tbl") -Offset (3 + 4 * 34) -Values $Shift -Repeat 1 -Interval 4 -Add -Silent; break } # 34 - 35
        "Goron City"                 { ChangeBytes -File ($Paths.Temp + "\scene\textures.tbl") -Offset (3 + 4 * 36) -Values $Shift -Repeat 1 -Interval 4 -Add -Silent; break } # 36 - 37
        "Lon Lon Ranch"              { ChangeBytes -File ($Paths.Temp + "\scene\textures.tbl") -Offset (3 + 4 * 38) -Values $Shift -Repeat 1 -Interval 4 -Add -Silent; break } # 38 - 39
    }

}



#==============================================================================================================================================================================================
function ShiftCutscenesTable([sbyte]$Shift) {
    
    # Debug: B95394 -> B95534
    # Rev0:  B65C64 -> B65E04

    switch ($SceneEditor.LoadedScene.Name) {
        "Hyrule Field" {
            ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 0)  -Values $Shift -Add -Silent
            ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 8)  -Values $Shift -Add -Silent
            ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 9)  -Values $Shift -Add -Silent
            ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 10) -Values $Shift -Add -Silent
            ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 11) -Values $Shift -Add -Silent
            ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 12) -Values $Shift -Add -Silent
            break
        }
        "Gerudo's Fortress" {
            ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 15) -Values $Shift -Add -Silent
            ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 31) -Values $Shift -Add -Silent
            break
        }
        "Death Mountain Crater" {
            ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 21) -Values $Shift -Add -Silent
            ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 32) -Values $Shift -Add -Silent
            break
        }
        "Inside Ganon's Castle" {
            ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 24) -Values $Shift -Add -Silent
            ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 25) -Values $Shift -Add -Silent
            ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 26) -Values $Shift -Add -Silent
            ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 27) -Values $Shift -Add -Silent
            ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 28) -Values $Shift -Add -Silent
            ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 29) -Values $Shift -Add -Silent
            break
        }
        "Death Mountain Trail"                    { ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 1)  -Values $Shift -Add -Silent; break }
        "Kakariko Village"                        { ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 2)  -Values $Shift -Add -Silent; break }
        "Zora's Domain"                           { ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 3)  -Values $Shift -Add -Silent; break }
        "Hyrule Castle"                           { ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 4)  -Values $Shift -Add -Silent; break }
        "Goron City"                              { ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 5)  -Values $Shift -Add -Silent; break }
        "Temple of Time"                          { ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 6)  -Values $Shift -Add -Silent; break }
        "Inside the Deku Tree"                    { ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 7)  -Values $Shift -Add -Silent; break }
        "Lake Hylia"                              { ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 13) -Values $Shift -Add -Silent; break }
        "Gerudo Valley"                           { ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 14) -Values $Shift -Add -Silent; break }
        "Lon Lon Ranch"                           { ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 16) -Values $Shift -Add -Silent; break }
        "Inside Jabu Jabu's Belly"                { ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 17) -Values $Shift -Add -Silent; break }
        "Graveyard"                               { ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 18) -Values $Shift -Add -Silent; break }
        "Zora's Fountain"                         { ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 19) -Values $Shift -Add -Silent; break }
        "Desert Colossus"                         { ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 20) -Values $Shift -Add -Silent; break }
        "Ganon's Castle Exterior"                 { ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 22) -Values $Shift -Add -Silent; break }
        "Royal Family Tomb"                       { ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 23) -Values $Shift -Add -Silent; break }
        "Twinrova's Lair & Iron Knuckle's Lair"   { ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 30) -Values $Shift -Add -Silent; break }
        "Kokiri Forest"                           { ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 33) -Values $Shift -Add -Silent; break }
        "Sacred Forest Meadow"                    { ChangeBytes -File ($Paths.Temp + "\scene\cutscenes.tbl") -Offset (7 + 8 * 35) -Values $Shift -Add -Silent; break }
    }

}



#==============================================================================================================================================================================================
function SaveAndPatchLoadedScene([switch]$Silent) {
    
    if ($Silent) { 
        SaveLoadedMap    -Silent
        PatchLoadedScene -Silent
    }
    else {
        SaveLoadedMap
        PatchLoadedScene
    }

}



#==============================================================================================================================================================================================
function ChangeMapFile([object]$Values, [string]$Patch="", [object]$Search, [object]$Start="0") {

    <#$offset = SearchBytes -File ($Paths.Temp + "\scene\room_" + $SceneEditor.LoadedMap + ".zmap") -Values $Search -Start $Start -Decimal
    if ($offset -eq -1) {
        WriteToConsole ("Could not find offset to replace in room " + $SceneEditor.LoadedMap) -Error
        return
    }
    $valuesDec = GetValuesData -Values $Values -Patch $Patch
    foreach ($i in 0..($valuesDec.Length-1)) { $SceneEditor.MapArray[$offset + $i] = $valuesDec[$i] }
    WriteToConsole ("Changed map values at: " + (Get24Bit $offset) )#>

    if     ($Search -is [String] -and $Search -Like "* *")   { $Search = $Search -split ' '           }
    elseif ($Search -is [String])                            { $Search = $Search -split '(..)' -ne '' }
    else {
        WriteToConsole "Search values are not valid to look for map file!" -Error
        $global:WarningError = $True
        return
    }

    [uint32]$Start = GetDecimal $Start
    [uint32]$End   = $SceneEditor.MapArray.Count

    if ($Start -lt 0 -or $End -lt 0) {
        WriteToConsole "Start or end offset is negative for map file!" -Error
        $global:WarningError = $True
        return
    }
    elseif ($Start -gt $SceneEditor.MapArray.Count -or $End -gt $SceneEditor.MapArray.Count) {
        WriteToConsole "Start or end offset is too large for map file!" -Error
        $global:WarningError = $True
        return
    }
    elseif ($Start -gt $End) {
        WriteToConsole "Start offset can not be greater than end offset for map file!" -Error
        $global:WarningError = $True
        return
    }

    foreach ($i in $Start..($End-1)) {
        $found = $True
        foreach ($j in 0..($Search.Count-1)) {
            if ($Search[$j] -ne "") {
                if ($SceneEditor.MapArray[$i + $j] -ne (GetDecimal $Search[$j]) -and $Search[$j] -ne "xx") {
                    $found = $False
                    break
                }
            }
        }
        if ($found -eq $True) {
            $valuesDec = GetValuesData -Values $Values -Patch $Patch
            foreach ($k in 0..($valuesDec.Count-1)) { $SceneEditor.MapArray[$i + $k] = $valuesDec[$k] }
            WriteToConsole ("Changed map values at: " + (Get24Bit $i))
            return
        }
    }

    WriteToConsole "Could not find offset to replace in map" -Error

}



#==============================================================================================================================================================================================
function ChangeSceneFile([object]$Values, [string]$Patch="", [object]$Search, [object]$Start="0") {
    
    if     ($Search -is [String] -and $Search -Like "* *")   { $Search = $Search -split ' '           }
    elseif ($Search -is [String])                            { $Search = $Search -split '(..)' -ne '' }
    else {
        WriteToConsole "Search values are not valid to look for scene file!" -Error
        $global:WarningError = $True
        return
    }

    [uint32]$Start = GetDecimal $Start
    [uint32]$End   = $SceneEditor.SceneArray.Count

    if ($Start -lt 0 -or $End -lt 0) {
        WriteToConsole "Start or end offset is negative for scene file!" -Error
        $global:WarningError = $True
        return
    }
    elseif ($Start -gt $SceneEditor.SceneArray.Count -or $End -gt $SceneEditor.SceneArray.Count) {
        WriteToConsole "Start or end offset is too large for scene file!" -Error
        $global:WarningError = $True
        return
    }
    elseif ($Start -gt $End) {
        WriteToConsole "Start offset can not be greater than end offset for map file!" -Error
        $global:WarningError = $True
        return
    }

    foreach ($i in $Start..($End-1)) {
        $found = $True
        foreach ($j in 0..($Search.Count-1)) {
            if ($Search[$j] -ne "") {
                if ($SceneEditor.SceneArray[$i + $j] -ne (GetDecimal $Search[$j]) -and $Search[$j] -ne "xx") {
                    $found = $False
                    break
                }
            }
        }
        if ($found -eq $True) {
            $valuesDec = GetValuesData -Values $Values -Patch $Patch
            foreach ($k in 0..($valuesDec.Count-1)) { $SceneEditor.SceneArray[$i + $k] = $valuesDec[$k] }
            WriteToConsole ("Changed scene values at: " + (Get24Bit $i))
            return
        }
    }

    WriteToConsole "Could not find offset to replace in scene" -Error

}



#==============================================================================================================================================================================================
function GetValuesData([object]$Values, [string]$Patch="") {

    if     ($Patch   -ne "")                                 { return [IO.File]::ReadAllBytes($GameFiles.textures  + "\" + $Patch)            }
    elseif ($Values -is [String] -and $Values -Like "* *")   { return ($Values -split ' '           | foreach { [Convert]::ToByte($_, 16) } ) }
    elseif ($Values -is [String])                            { return ($Values -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) } ) }
    return $Values

}



#==============================================================================================================================================================================================
function LoadScene([object[]]$Scene, [switch]$Keep) {
    
    $folder = $Paths.Games + "\" + $Files.json.sceneEditor.game + "\Editor\Scenes\" + $Scene.name
    $file   = $Paths.Games + "\" + $Files.json.sceneEditor.game + "\Editor\Scenes\" + $Scene.name + "\scene.zscene"
    $SceneEditor.DropMap = $SceneEditor.DropHeader = $null

    if ($Files.json.sceneEditor.quest -is [array] -and $Files.json.sceneEditor.quest.Count -gt 0) {
        foreach ($elem in $SceneEditor.Quests) {
            $elem.Enabled = $False
            $elem.Visible = $Scene.Dungeon -eq 1
        }
        foreach ($elem in $SceneEditor.QuestLabels) { $elem.Visible = $Scene.Dungeon -eq 1 }
        
        if ($Scene.Dungeon -eq 1) {
            $SceneEditor.Quests[0].Checked = $True
            if (IsSet $Settings["Dungeon"][$SceneEditor.Scenes.Text]) {
                for ($i=0; $i -lt $SceneEditor.Quests.Count; $i++) {
                    if ($Settings["Dungeon"][$SceneEditor.Scenes.Text] -eq $i+1) {
                        $SceneEditor.Quests[$i].Checked = $True
                        if ($i -gt 0) { $folder += "\" + $Files.json.sceneEditor.quest[$i-1] }
                    }
                }
            }
            
            for ($i=1; $i -lt $SceneEditor.Quests.Count; $i++) {
                if ($SceneEditor.Quests[$i].Checked) { $file = $Paths.Games + "\" + $Files.json.sceneEditor.game + "\Editor\Scenes\" + $Scene.name + "\" + $Files.json.sceneEditor.quest[$i-1] + "\scene.zscene" }
            }
        }
    }

    if (!(TestFile -Path $folder -Container) -or !(TestFile -Path $file)) {
        $SceneEditor.Headers.Items.Clear()
        $SceneEditor.BottomPanelMapSettings.Controls.Clear()
        $SceneEditor.BottomPanelSceneSettings.Controls.Clear()
        $SceneEditor.BottomPanelActors.Controls.Clear()
        $SceneEditor.BottomPanelObjects.Controls.Clear()
        [System.Collections.ArrayList]$SceneEditor.Actors  = @()
        [System.Collections.ArrayList]$SceneEditor.Objects = @()
        return
    }
    
    RunLoadScene -File $file

    if (!$Keep) {
        $SceneEditor.Maps.Items.Clear()
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
            $SceneEditor.Maps.Items.Add($title)
        }
        
        $SceneEditor.Maps.SelectedIndex = 0
    }
    else { LoadMap -Scene $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex] -Map 0 }

}



#==============================================================================================================================================================================================
function LoadSceneSettings() {
    
    $SceneEditor.BottomPanelSceneSettings.Controls.Clear()
    $y = (DPISize 10)



    # MUSIC #

    if ($SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].SoundConfig -ne $null) {
        $group = CreateGroupBox -Text "Music" -X (DPISize 10) -Y $y -Width ($SceneEditor.BottomPanelSceneSettings.Width - (DPISize 20)) -Height (DPISize 50) -AddTo $SceneEditor.BottomPanelSceneSettings
        $y     = $group.bottom + (DPISize 10)

        $default = 0
        foreach ($i in 0..($Files.json.music.tracks.Count-1)) {
            if ($Files.json.music.tracks[$i].id -is [Array])   { $id = $Files.json.music.tracks[$i].id[0] }
            else                                               { $id = $Files.json.music.tracks[$i].id    }
            if ($SceneEditor.SceneArray[$SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].MusicSequence] -eq (GetDecimal $id)) {
                $default = $i + 1
                break
            }
        }
                CreateLabel    -X (DPISize 10) -Y (DPISize 18) -Width (DPISize 80)  -Height (DPISize 20) -Text "Music Track:" -AddTo $group
        $elem = CreateComboBox -X (DPISize 90) -Y (DPISize 17) -Width (DPISize 200) -Height (DPISize 20) -Default $default -Items $Files.json.music.tracks.title -AddTo $group
        $elem.Add_SelectedIndexChanged({
            foreach ($track in $Files.json.music.tracks) {
                if ($track.title -eq $this.text) {
                    if ($track.id -is [Array])   { $SceneEditor.SceneArray[$SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].MusicSequence] = GetDecimal $track.id[0] }
                    else                         { $SceneEditor.SceneArray[$SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].MusicSequence] = GetDecimal $track.id    }
                    break
                }
            }
        })

        $default = 0
        foreach ($i in 0..($Files.json.music.nighttime.Count-1)) {
            if ($SceneEditor.SceneArray[$SceneEditor.SceneOffsets[0].NightSequence] -eq (GetDecimal $Files.json.music.nighttime[$i].id)) {
                $default = $i + 1
                break
            }
        }
                CreateLabel    -X (DPISize 310) -Y (DPISize 18) -Width (DPISize 100)  -Height (DPISize 20) -Text "Nighttime Music:" -AddTo $group
        $elem = CreateComboBox -X (DPISize 410) -Y (DPISize 17) -Width (DPISize 200) -Height (DPISize 20) -Default $default -Items $Files.json.music.nighttime.title -AddTo $group
        $elem.Add_SelectedIndexChanged( { $SceneEditor.SceneArray[$SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].NightSequence] = $this.selectedIndex })

                CreateLabel   -X (DPISize 620) -Y (DPISize 18) -Width (DPISize 90) -Height (DPISize 20) -Text "Setting Config:" -AddTo $group
        $elem = CreateTextBox -X (DPISize 710) -Y (DPISize 17) -Width (DPISize 25) -Height (DPISize 20) -Text $SceneEditor.SceneArray[$SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].SoundConfig] -AddTo $group
        $elem.Add_LostFocus({
            if         (($this.Text -as [int]) -eq $null)   { $this.Text = $this.Default }
            elseif ([int]$this.text -lt 0)                  { $this.Text = $this.Default }
            elseif ([int]$this.text -gt 0x11)               { $this.Text = $this.Default }
            $SceneEditor.SceneArray[$SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].SoundConfig] = [int]$this.text
        })
    }



    # SKYBOX #

    if ($SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].Skybox -ne $null) {
        $group = CreateGroupBox -Text "Skybox" -X $group.left -Y $y -Width $group.width -Height (DPISize 50) -AddTo $SceneEditor.BottomPanelSceneSettings
        $y     = $group.bottom + (DPISize 10)

        $default = 0
        foreach ($i in 0..($Files.json.sceneEditor.skyboxes.Count-1)) {
            if ($SceneEditor.SceneArray[$SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].Skybox] -eq (GetDecimal $Files.json.sceneEditor.skyboxes[$i].id)) {
                $default = $i + 1
                break
            }
        }
                CreateLabel    -X (DPISize 10) -Y (DPISize 18) -Width (DPISize 80)  -Height (DPISize 20) -Text "Skybox:" -AddTo $group
        $elem = CreateComboBox -X (DPISize 90) -Y (DPISize 17) -Width (DPISize 150) -Height (DPISize 20) -Default $default -Items $Files.json.sceneEditor.skyboxes.title -AddTo $group
        $elem.Add_SelectedIndexChanged({
            foreach ($skybox in $Files.json.sceneEditor.skyboxes) {
                if ($skybox.title -eq $this.text) {
                    $SceneEditor.SceneArray[$SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].Skybox] = GetDecimal $skybox.id
                    break
                }
            }
        })

                CreateLabel    -X (DPISize 270) -Y (DPISize 18) -Width (DPISize 50)  -Height (DPISize 20) -Text "Cloudy:" -AddTo $group
        $elem = CreateCheckbox -X (DPISize 320) -Y (DPISize 17) -Checked ($SceneEditor.SceneArray[$SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].Cloudy] -eq 1) -AddTo $group
        $elem.Add_CheckStateChanged( {
            if ($this.checked) { $val = 1 } else { $val = 0 }
            $SceneEditor.SceneArray[$SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].Cloudy] = $val
        })

                CreateLabel    -X (DPISize 370) -Y (DPISize 18) -Width (DPISize 100)  -Height (DPISize 20) -Text "Indoor Lightning:" -AddTo $group
        $elem = CreateCheckbox -X (DPISize 470) -Y (DPISize 17) -Checked ($SceneEditor.SceneArray[$SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].LightningControl] -eq 1) -AddTo $group
        $elem.Add_CheckStateChanged( {
            if ($this.checked) { $val = 1 } else { $val = 0 }
            $SceneEditor.SceneArray[$SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].LightningControl] = $val
        })
    }



    # TRANSITION ACTORS #

    if ($SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].ActorIndex -ne $null) {
        $group = CreateGroupBox -Text "Transition Actors" -X $group.left -Y $y -Width $group.width -Height ( (DPISize 95) * (GetTransitionActorCount) + (DPISize 30) ) -AddTo $SceneEditor.BottomPanelSceneSettings
        for ($i=0; $i -lt (GetTransitionActorCount); $i++) { AddTransitionActor -Group $group }
    }

}



#==============================================================================================================================================================================================
function LoadMapSettings() {
    
    $SceneEditor.BottomPanelMapSettings.Controls.Clear()
    $y = (DPISize 10)



    # TIME #

    if ($SceneEditor.Offsets[$SceneEditor.LoadedHeader].Time -ne $null) {
        $group = CreateGroupBox -Text "Time" -X (DPISize 10) -Y $y -Width ($SceneEditor.BottomPanelMapSettings.Width - (DPISize 20)) -Height (DPISize 50) -AddTo $SceneEditor.BottomPanelMapSettings
        $y     = $group.bottom + (DPISize 10)

        $val = $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].Time] * 256 + $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].Time+1]
        if ($val -eq 0xFFFF) { $val = -1 }
                CreateLabel   -X (DPISize 10)  -Y (DPISize 18) -Width (DPISize 90) -Height (DPISize 20) -Text "Reset Time:" -AddTo $group
        $elem = CreateTextBox -X (DPISize 100) -Y (DPISize 17) -Width (DPISize 35) -Height (DPISize 20) -Length 5 -Text $val -AddTo $group
        $elem.Add_LostFocus({
            if         (($this.Text -as [int]) -eq $null)   { $this.Text = $this.Default }
            elseif ([int]$this.text -lt -1)                 { $this.Text = $this.Default }
            elseif ([int]$this.text -gt 0xFFFE)             { $this.Text = $this.Default }
            $val = [int]$this.text
            if ($val -eq -1) { $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].Time] = $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].Time+1] = 0xFF }
            else {
                $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].Time]   = $val -shr 8
                $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].Time+1] = $val % 0x100
            }
        })

        $val = $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].TimeSpeed]
        if ($val -gt 0x7F) { $val = ($val - 0x7F) * -1  }
                CreateLabel   -X (DPISize 150) -Y (DPISize 18) -Width (DPISize 90) -Height (DPISize 20) -Text "Time Speed:" -AddTo $group
        $elem = CreateTextBox -X (DPISize 240) -Y (DPISize 17) -Width (DPISize 30) -Height (DPISize 20) -Length 4 -Text $val -AddTo $group
        $elem.Add_LostFocus({
            if         (($this.Text -as [int]) -eq $null)   { $this.Text = $this.Default }
            elseif ([int]$this.text -lt -128)               { $this.Text = $this.Default }
            elseif ([int]$this.text -gt 127)                { $this.Text = $this.Default }
            $val = [int]$this.text
            if ($val -lt 0) { $val = 0x100 + $val }
            $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].TimeSpeed] = $val
        })
    }



    # WIND #

    if ($SceneEditor.Offsets[$SceneEditor.LoadedHeader].WindWest -ne $null) {
        $group = CreateGroupBox -Text "Wind" -X (DPISize 10) -Y $y -Width ($SceneEditor.BottomPanelMapSettings.Width - (DPISize 20)) -Height (DPISize 50) -AddTo $SceneEditor.BottomPanelMapSettings
        $y     = $group.bottom + (DPISize 10)

                CreateLabel   -X (DPISize 10) -Y (DPISize 18) -Width (DPISize 60) -Height (DPISize 20) -Text "West:" -AddTo $group
        $elem = CreateTextBox -X (DPISize 70) -Y (DPISize 17) -Width (DPISize 25) -Height (DPISize 20) -Length 3 -Text $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WindWest] -AddTo $group
        $elem.Add_LostFocus({
            if         (($this.Text -as [int]) -eq $null)   { $this.Text = $this.Default }
            elseif ([int]$this.text -lt 0)                  { $this.Text = $this.Default }
            elseif ([int]$this.text -gt 0xFF)               { $this.Text = $this.Default }
            $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WindWest] = [int]$this.text
        })

                CreateLabel   -X (DPISize 110) -Y (DPISize 18) -Width (DPISize 60) -Height (DPISize 20) -Text "South:" -AddTo $group
        $elem = CreateTextBox -X (DPISize 170) -Y (DPISize 17) -Width (DPISize 25) -Height (DPISize 20) -Length 3 -Text $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WindSouth] -AddTo $group
        $elem.Add_LostFocus({
            if         (($this.Text -as [int]) -eq $null)   { $this.Text = $this.Default }
            elseif ([int]$this.text -lt 0)                  { $this.Text = $this.Default }
            elseif ([int]$this.text -gt 0xFF)               { $this.Text = $this.Default }
            $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WindSouth] = [int]$this.text
        })

                CreateLabel   -X (DPISize 210) -Y (DPISize 18) -Width (DPISize 60) -Height (DPISize 20) -Text "Vertical:" -AddTo $group
        $elem = CreateTextBox -X (DPISize 270) -Y (DPISize 17) -Width (DPISize 25) -Height (DPISize 20) -Length 3 -Text $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WindVertical] -AddTo $group
        $elem.Add_LostFocus({
            if         (($this.Text -as [int]) -eq $null)   { $this.Text = $this.Default }
            elseif ([int]$this.text -lt 0)                  { $this.Text = $this.Default }
            elseif ([int]$this.text -gt 0xFF)               { $this.Text = $this.Default }
            $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WindVertical] = [int]$this.text
        })

                CreateLabel   -X (DPISize 310) -Y (DPISize 18) -Width (DPISize 60) -Height (DPISize 20) -Text "Strength:" -AddTo $group
        $elem = CreateTextBox -X (DPISize 370) -Y (DPISize 17) -Width (DPISize 25) -Height (DPISize 20) -Length 3 -Text $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WindStrength] -AddTo $group
        $elem.Add_LostFocus({
            if         (($this.Text -as [int]) -eq $null)   { $this.Text = $this.Default }
            elseif ([int]$this.text -lt 0)                  { $this.Text = $this.Default }
            elseif ([int]$this.text -gt 0xFF)               { $this.Text = $this.Default }
            $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WindStrength] = [int]$this.text
        })
    }



    # ROOM BEHAVIOUR #

    if ($SceneEditor.Offsets[$SceneEditor.LoadedHeader].Restrictions -ne $null) {
        $group = CreateGroupBox -Text "Room Behaviour" -X (DPISize 10) -Y $y -Width ($SceneEditor.BottomPanelMapSettings.Width - (DPISize 20)) -Height (DPISize 50) -AddTo $SceneEditor.BottomPanelMapSettings
        $y     = $group.bottom + (DPISize 10)

        $default = $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].Restrictions] + 1
                CreateLabel    -X (DPISize 10) -Y (DPISize 18) -Width (DPISize 80)  -Height (DPISize 20) -Text "Restrictions:" -AddTo $group
        $elem = CreateComboBox -X (DPISize 90) -Y (DPISize 17) -Width (DPISize 200) -Height (DPISize 20) -Default $default -Items @("No Restrictions", "Dungeon", "Room", "Room #2", "Town", "Boss Room") -AddTo $group
        if ($default -eq 0) {
            $elem.Enabled       = $False
            $elem.SelectedIndex = -1
        }
        $elem.Add_SelectedIndexChanged({ $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].Restrictions] = $val })

        $default = $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].IdleAnimation] + 1
                CreateLabel    -X (DPISize 310) -Y (DPISize 18) -Width (DPISize 90)  -Height (DPISize 20) -Text "Idle Animation:" -AddTo $group
        $elem = CreateComboBox -X (DPISize 400) -Y (DPISize 17) -Width (DPISize 200) -Height (DPISize 20) -Default $default -Items @("Normal Weather", "Cold Weather", "Hot Weather", "Trigger Heat Timer", "Warm Weather", "Mild Weather", "Cool Weather", "Gasps for Breath", "Unknown", "Brandishes Sword", "Re-adjusts tunic") -AddTo $group
        if ($default -eq 0) {
            $elem.Enabled       = $False
            $elem.SelectedIndex = -1
        }
        $elem.Add_SelectedIndexChanged({ $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].IdleAnimation] = $this.SelectedIndex })

        if ($Files.json.sceneEditor.game -eq "Ocarina of Time") {
                    CreateLabel    -X (DPISize 620) -Y (DPISize 18) -Width (DPISize 110) -Height (DPISize 20) -Text "Disable Warp Songs:" -AddTo $group
            $elem = CreateCheckbox -X (DPISize 730) -Y (DPISize 17) -Checked (($SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WarpSongs] -shr 4) -band 1) -AddTo $group
            $elem.Add_CheckStateChanged( {
                if ($this.checked)   { $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WarpSongs] += 1 -shl 4 }
                else                 { $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WarpSongs] -= 1 -shl 4 }
            })

                    CreateLabel    -X (DPISize 770) -Y (DPISize 18) -Width (DPISize 120) -Height (DPISize 20) -Text "Hide Invisible Actors:" -AddTo $group
            $elem = CreateCheckbox -X (DPISize 890) -Y (DPISize 17) -Checked ($SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WarpSongs] -band 1) -AddTo $group
            $elem.Add_CheckStateChanged( {
                if ($this.checked)   { $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WarpSongs] += 1 }
                else                 { $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WarpSongs] -= 1 }
            })
        }
        else {
                    CreateLabel    -X (DPISize 620) -Y (DPISize 18) -Width (DPISize 110) -Height (DPISize 20) -Text "Rain / Snow:" -AddTo $group
            $elem = CreateCheckbox -X (DPISize 730) -Y (DPISize 17) -Checked ($SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WarpSongs] -eq 0x10) -AddTo $group
            $elem.Add_CheckStateChanged( {
                if ($this.checked)   { $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WarpSongs] = 0x10 }
                else                 { $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WarpSongs] = 0    }
            })
        }
    }



    # SKYBOX #

    if ($SceneEditor.Offsets[$SceneEditor.LoadedHeader].DisableSkybox -ne $null) {
        $group = CreateGroupBox -Text "Skybox" -X $group.left -Y $y -Width $group.width -Height (DPISize 50) -AddTo $SceneEditor.BottomPanelMapSettings
        $y     = $group.bottom + (DPISize 10)

                CreateLabel    -X (DPISize 10)  -Y (DPISize 18) -Width (DPISize 90) -Height (DPISize 20) -Text "Disable Skybox:" -AddTo $group
        $elem = CreateCheckbox -X (DPISize 100) -Y (DPISize 17) -Checked ($SceneEditor.SceneArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].DisableSkybox] -eq 1) -AddTo $group
        $elem.Add_CheckStateChanged( {
            if ($this.checked) { $val = 1 } else { $val = 0 }
            $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].DisableSkybox] = $val
        })

                CreateLabel    -X (DPISize 140) -Y (DPISize 18) -Width (DPISize 80) -Height (DPISize 20) -Text "Disable Sun:" -AddTo $group
        $elem = CreateCheckbox -X (DPISize 220) -Y (DPISize 17) -Checked ($SceneEditor.SceneArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].DisableSun] -eq 1) -AddTo $group
        $elem.Add_CheckStateChanged( {
            if ($this.checked) { $val = 1 } else { $val = 0 }
            $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].DisableSun] = $val
        })
    }

}


#==============================================================================================================================================================================================
function PrepareAndSetSceneSettings([string]$Scene, [byte]$Map, [byte]$Header, $Music, $NightMusic, $SoundSetting, $Skybox, $Cast, $LightningControl) {
    
    PrepareMap       -Scene $Scene -Map $Map -Header $Header
    SetSceneSettings -Music $Music -NightMusic $NightMusic -SoundSetting $SoundSetting -Skybox $Skybox -Cast $Cast -LightningControl $LightningControl

}



#==============================================================================================================================================================================================
function PrepareAndSetMapSettings([string]$Scene, [byte]$Map, [byte]$Header, $Time, $TimeSpeed, $WindWest, $WindSouth, $WindVertical, $WindStrength, $Restrictions, $IdleAnimation, $DisableWarpSongs, $Rain, $HideInvisibleActors, $DisableSkybox, $DisableSun) {
    
    PrepareMap     -Scene $Scene -Map $Map -Header $Header
    SetMapSettings -Time $Time -TimeSpeed $TimeSpeed -WindWest $WindWest -WindSouth $WindSouth -WindVertical $WindVertical -WindStrength $WindStrength -Restrictions $Restrictions -IdleAnimation $IdleAnimation -DisableWarpSongs $DisableWarpSongs -Rain $Rain -HideInvisibleActors $HideInvisibleActors -DisableSkybox $DisableSkybox -DisableSun $DisableSun

}



#==============================================================================================================================================================================================
function SetSceneSettings($Music, $NightMusic, $SoundSetting, $Skybox, $Cast, $LightningControl) {
    
    if ($Music            -is [int] -and $Music             -ge 0 -and $Music           -le 0x7F)   { $SceneEditor.SceneArray[$SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].MusicSequence]    = $Music            }
    if ($NightMusic       -is [int] -and $NightMusic        -ge 0 -and $NightMusic      -le 0x1F)   { $SceneEditor.SceneArray[$SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].NightSequence]    = $NightMusic       }
    if ($SoundSetting     -is [int] -and $SoundSetting      -ge 0 -and $SoundSetting    -le 0x11)   { $SceneEditor.SceneArray[$SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].SoundConfig]      = $SoundSetting     }
    if ($Skybox           -is [int] -and $Skybox            -ge 0 -and $Skybox          -le 0x22)   { $SceneEditor.SceneArray[$SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].Skybox]           = $Skybox           }
    if ($Cast             -is [int] -and ($Cast             -eq 0 -or $Cast             -eq 1))     { $SceneEditor.SceneArray[$SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].Cloudy]           = $Cast             }
    if ($LightningControl -is [int] -and ($LightningControl -eq 0 -or $LightningControl -eq 1))     { $SceneEditor.SceneArray[$SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].LightningControl] = $LightningControl }

    WriteToConsole "Scene properties have been updated"

}



#==============================================================================================================================================================================================
function ChangeSpawnPoint([byte]$Index=0, $X, $Y, $Z, $XRot, $YRot, $ZRot, $Param) {
    
    if ($Index -ge (GetPositionCountIndex) -or $Index -lt 0) { WriteToConsole ("Spawn point: " + $Index + " does not exist") -Error; return }

    if ($Param -is [string]) {
        if ($Param.length -ne 4) {
            WriteToConsole "Parameter replacement value is not a valid 16-bit hexadecimal length" -Error
            return $False
        }
        if ((GetDecimal $Param) -eq -1) {
            WriteToConsole "Parameter replacement value is not valid hexadecimal value" -Error
            return $False
        }
    }

    $offset = (GetPositionStart) + $Index * 16

    if ($X -is [int] -and $X -ge -32768 -and $X -le 32767) {
        if ($X -lt 0) { $X += 0x10000 }
        $SceneEditor.SceneArray[$offset+2]  = $X -shr 8
        $SceneEditor.SceneArray[$offset+3]  = $X % 0x100
    }

    if ($Y -is [int] -and $Y -ge -32768 -and $Y -le 32767) {
        if ($Y -lt 0) { $Y += 0x10000 }
        $SceneEditor.SceneArray[$offset+4]  = $Y -shr 8
        $SceneEditor.SceneArray[$offset+5]  = $Y % 0x100
    }

    if ($Z -is [int] -and $Z -ge -32768 -and $Z -le 32767) {
        if ($Z -lt 0) { $Z += 0x10000 }
        $SceneEditor.SceneArray[$offset+6]  = $Z -shr 8
        $SceneEditor.SceneArray[$offset+7]  = $Z % 0x100
    }

    if ($XRot -is [int] -and $XRot -ge 0 -and $XRot -le 0xFFFF) {
        $SceneEditor.SceneArray[$offset+8]  = $XRot -shr 8
        $SceneEditor.SceneArray[$offset+9]  = $XRot % 0x100
    }

    if ($YRot -is [int] -and $YRot -ge 0 -and $YRot -le 0xFFFF) {
        $SceneEditor.SceneArray[$offset+10] = $YRot -shr 8
        $SceneEditor.SceneArray[$offset+11] = $YRot % 0x100
    }

    if ($ZRot -is [int] -and $ZRot -ge 0 -and $ZRot -le 0xFFFF) {
        $SceneEditor.SceneArray[$offset+12] = $ZRot -shr 8
        $SceneEditor.SceneArray[$offset+13] = $ZRot % 0x100
    }

    if ($Param -is [string]) {
        $val = $Param -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) }
        $SceneEditor.SceneArray[$offset+14] = $val[0]
        $SceneEditor.SceneArray[$offset+15] = $val[1]
    }


    $SceneEditor.SceneArray[(GetEntranceStart) + $Index * 2]     = $Index
    $SceneEditor.SceneArray[(GetEntranceStart) + $Index * 2 + 1] = $SceneEditor.LoadedMap

    WriteToConsole ("Updated spawn point:     " + $index)

}



#==============================================================================================================================================================================================
function ChangeDoor([byte]$Index=0, $X, $Y, $Z, $YRot, $RoomFront, $RoomBack, $CameraFront, $CameraBack, $Param) {
    
    if ($Index -ge (GetTransitionActorCount) -or $Index -lt 0) { WriteToConsole ("Door: " + $Index + " does not exist") -Error; return }

    if ($Param -is [string]) {
        if ($Param.length -ne 4) {
            WriteToConsole "Parameter replacement value is not a valid 16-bit hexadecimal length" -Error
            return $False
        }
        if ((GetDecimal $Param) -eq -1) {
            WriteToConsole "Parameter replacement value is not valid hexadecimal value" -Error
            return $False
        }
    }

    $offset = (GetTransitionActorStart) + $Index * 16

    if ($RoomFront   -is [int] -and $RoomFront   -ge 0 -and $RoomFront   -le (GetMapCountIndex) )   { $SceneEditor.SceneArray[$offset+0] = $RoomFront   }
    if ($RoomBack    -is [int] -and $RoomBack    -ge 0 -and $RoomBack    -le (GetMapCountIndex) )   { $SceneEditor.SceneArray[$offset+2] = $RoomBack    }
    if ($CameraFront -is [int] -and $CameraFront -ge 0 -and $CameraFront -le 0xFF)                  { $SceneEditor.SceneArray[$offset+1] = $CameraFront }
    if ($CameraBack  -is [int] -and $CameraBack  -ge 0 -and $CameraBack  -le 0xFF)                  { $SceneEditor.SceneArray[$offset+3] = $CameraBack  }

    if ($X -is [int] -and $X -ge -32768 -and $X -le 32767) {
        if ($X -lt 0) { $X += 0x10000 }
        $SceneEditor.SceneArray[$offset+6]  = $X -shr 8
        $SceneEditor.SceneArray[$offset+7]  = $X % 0x100
    }

    if ($Y -is [int] -and $Y -ge -32768 -and $Y -le 32767) {
        if ($Y -lt 0) { $Y += 0x10000 }
        $SceneEditor.SceneArray[$offset+8]  = $Y -shr 8
        $SceneEditor.SceneArray[$offset+9]  = $Y % 0x100
    }

    if ($Z -is [int] -and $Z -ge -32768 -and $Z -le 32767) {
        if ($Z -lt 0) { $Z += 0x10000 }
        $SceneEditor.SceneArray[$offset+10] = $Z -shr 8
        $SceneEditor.SceneArray[$offset+11] = $Z % 0x100
    }

    if ($YRot -is [int] -and $YRot -ge 0 -and $YRot -le 0xFFFF) {
        $SceneEditor.SceneArray[$offset+12] = $YRot -shr 8
        $SceneEditor.SceneArray[$offset+13] = $YRot % 0x100
    }

    if ($Param -is [string]) {
        $val = $Param -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) }
        $SceneEditor.SceneArray[$offset+14] = $val[0]
        $SceneEditor.SceneArray[$offset+15] = $val[1]
    }

    WriteToConsole ("Updated door:            " + $index)

}



#==============================================================================================================================================================================================
function ChangeExit([byte]$Index=0, $Exit) {
    
    if ($Index -ge (GetPositionCount) -or $Index -lt 0) { WriteToConsole ("Exit: " + $Index + " does not exist") -Error; return }

    if ($Exit -is [string]) {
        if ($Exit.length -ne 4)          { WriteToConsole "Exit replacement value is not a valid 16-bit hexadecimal length" -Error; return }
        if ((GetDecimal $Exit) -eq -1)   { WriteToConsole "Exit replacement value is not valid hexadecimal value"           -Error; return }
    }
    else { WriteToConsole "Exit replacement value is not defined as a string" -Error; return }

    $val = $Exit -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) }
    $SceneEditor.SceneArray[(GetExitStart) + $Index * 2]     = $val[0]
    $SceneEditor.SceneArray[(GetExitStart) + $Index * 2 + 1] = $val[1]

    WriteToConsole ("Updated exit:            " + $index + " to value: " + $Exit)

}



#==============================================================================================================================================================================================
function SetMapSettings($Time, $TimeSpeed, $WindWest, $WindSouth, $WindVertical, $WindStrength, $Restrictions, $IdleAnimation, $DisableWarpSongs, $Rain, $HideInvisibleActors, $DisableSkybox, $DisableSun) {
    
    if ($Time -is [int] -and $Time -ge 0 -and $Time -le 0xFFFF) {
        $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].Time]   = $Time -shr 8
        $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].Time+1] = $Time % 0x100
    }

    if ($TimeSpeed -is [int] -and $TimeSpeed -ge -128 -and $TimeSpeed -le 127) {
        if ($TimeSpeed -lt 0) { $TimeSpeed += 0x100 }
        $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].TimeSpeed] = $TimeSpeed
    }

    if ($Files.json.sceneEditor.game -eq "Ocarina of Time") {
        if ($DisableWarpSongs -is [int] -and $DisableWarpSongs -eq 0 -or $DisableWarpSongs -eq 1) {
            if     ($DisableWarpSongs -eq 0 -and ($SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WarpSongs] -shr 4) -band 1)   { $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WarpSongs] -= 1 -shl 4 }
            elseif ($DisableWarpSongs -eq 1 -and ($SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WarpSongs] -shr 4) -band 0)   { $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WarpSongs] += 1 -shl 4 }
        }

        if ($HideInvisibleActors -is [int] -and $HideInvisibleActors -eq 0 -or $HideInvisibleActors -eq 1) {
            if     ( $DisableWarpSongs -eq 0 -and $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WarpSongs] -band 1)   { $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WarpSongs] -= 1 }
            elseif (!$DisableWarpSongs -eq 1 -and $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WarpSongs] -band 0)   { $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WarpSongs] += 1 }
        }
    }
    else {
        if ($Rain -is [int] -and $Rain -eq 0 -or $Rain -eq 1) {
            if     ($Rain -eq 0 -and $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WarpSongs] -eq 0x10)   { $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WarpSongs] = 0    }
            elseif ($Rain -eq 1 -and $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WarpSongs] -eq 0)      { $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WarpSongs] = 0x10 }
        }
    }

    if ($WindWest      -is [int] -and  $WindWest      -ge 0 -and $WindWest      -le 0xFF)   { $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WindWest]      = $WindWest      }
    if ($WindSouth     -is [int] -and  $WindSouth     -ge 0 -and $WindSouth     -le 0xFF)   { $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WindSouth]     = $WindSouth     }
    if ($WindVertical  -is [int] -and  $WindVertical  -ge 0 -and $WindVertical  -le 0xFF)   { $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WindVertical]  = $WindVertical  }
    if ($WindStrength  -is [int] -and  $WindStrength  -ge 0 -and $WindStrength  -le 0xFF)   { $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].WindStrength]  = $WindStrength  }
    if ($Restrictions  -is [int] -and  $Restrictions  -ge 0 -and $Restrictions  -le 5)      { $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].Restrictions]  = $Restrictions  }
    if ($IdleAnimation -is [int] -and  $IdleAnimation -ge 0 -and $IdleAnimation -le 10)     { $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].IdleAnimation] = $IdleAnimation }
    if ($DisableSkybox -is [int] -and ($DisableSkybox -eq 0 -or $DisableSkybox  -eq 1))     { $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].DisableSkybox] = $DisableSkybox }
    if ($DisableSun    -is [int] -and ($DisableSun    -eq 0 -or $DisableSun     -eq 1))     { $SceneEditor.MapArray[$SceneEditor.Offsets[$SceneEditor.LoadedHeader].DisableSun]    = $DisableSun    }

    WriteToConsole "Map properties have been updated"

}



#==============================================================================================================================================================================================
function RunLoadScene([string]$File) {
    
    # Load scene file #
    $headerSize = 0x70
    [System.Collections.ArrayList]$SceneEditor.SceneArray = [System.IO.File]::ReadAllBytes($File)
    $SceneEditor.SceneOffsets                   = @()
    $SceneEditor.SceneOffsets                  += @{}
    $SceneEditor.SceneOffsets[0].Header         = 0
    $SceneEditor.SceneOffsets[0].FoundPaths     = $False
    $SceneEditor.SceneOffsets[0].FoundActors    = $False
    $SceneEditor.SceneOffsets[0].FoundExits     = $False
    $SceneEditor.SceneOffsets[0].FoundCutscenes = $False

    for ($i=0; $i -lt $headerSize; $i+=8) {
        if ($SceneEditor.SceneArray[$i] -eq 0x14) {
            $SceneEditor.SceneOffsets[0].HeaderEnd           = $i
            break
        }
        elseif ($SceneEditor.SceneArray[$i] -eq 0x0) { # Start Positions List
            $SceneEditor.SceneOffsets[0].PositionCount       = $SceneEditor.SceneArray[$i + 1]
            $SceneEditor.SceneOffsets[0].PositionStart       = $SceneEditor.SceneArray[$i + 5] * 65536 + $SceneEditor.SceneArray[$i + 6] * 256 + $SceneEditor.SceneArray[$i + 7]
            $SceneEditor.SceneOffsets[0].PositionCountIndex  = $i + 1
            $SceneEditor.SceneOffsets[0].PositionIndex       = $i + 5
        }
        elseif ($SceneEditor.SceneArray[$i] -eq 0x3) { # Collision Header List
            $SceneEditor.SceneOffsets[0].CollisionStart      = $SceneEditor.SceneArray[$i + 5] * 65536 + $SceneEditor.SceneArray[$i + 6] * 256 + $SceneEditor.SceneArray[$i + 7]
            $SceneEditor.SceneOffsets[0].CollisionIndex      = $i + 5
        }
        elseif ($SceneEditor.SceneArray[$i] -eq 0x4) { # Map List
            $SceneEditor.SceneOffsets[0].MapCount            = $SceneEditor.SceneArray[$i + 1]
            $SceneEditor.SceneOffsets[0].MapStart            = $SceneEditor.SceneArray[$i + 5] * 65536 + $SceneEditor.SceneArray[$i + 6] * 256 + $SceneEditor.SceneArray[$i + 7]
            $SceneEditor.SceneOffsets[0].MapCountIndex       = $i + 1
            $SceneEditor.SceneOffsets[0].MapIndex            = $i + 5
        }
        elseif ($SceneEditor.SceneArray[$i] -eq 0x6) { # Entrance List
            $SceneEditor.SceneOffsets[0].EntranceStart       = $SceneEditor.SceneArray[$i + 5] * 65536 + $SceneEditor.SceneArray[$i + 6] * 256 + $SceneEditor.SceneArray[$i + 7]
            $SceneEditor.SceneOffsets[0].EntranceIndex       = $i + 5
        }
        elseif ($SceneEditor.SceneArray[$i] -eq 0x7) { # Special Objects
            $SceneEditor.SceneOffsets[0].MessageConfig       = $i + 1
            $SceneEditor.SceneOffsets[0].ObjectConfig        = $i + 7
        }
        elseif ($SceneEditor.SceneArray[$i] -eq 0xD) { # Pathways List
            $SceneEditor.SceneOffsets[0].PathStart           = $SceneEditor.SceneArray[$i + 5] * 65536 + $SceneEditor.SceneArray[$i + 6] * 256 + $SceneEditor.SceneArray[$i + 7]
            $SceneEditor.SceneOffsets[0].PathIndex           = $i + 5
            $SceneEditor.SceneOffsets[0].FoundPaths          = $True
        }
        elseif ($SceneEditor.SceneArray[$i] -eq 0xE) { # Transition Actor List
            $SceneEditor.SceneOffsets[0].ActorCount          = $SceneEditor.SceneArray[$i + 1]
            $SceneEditor.SceneOffsets[0].ActorStart          = $SceneEditor.SceneArray[$i + 5] * 65536 + $SceneEditor.SceneArray[$i + 6] * 256 + $SceneEditor.SceneArray[$i + 7]
            $SceneEditor.SceneOffsets[0].ActorCountIndex     = $i + 1
            $SceneEditor.SceneOffsets[0].ActorIndex          = $i + 5
            $SceneEditor.SceneOffsets[0].FoundActors         = $True
        }
        elseif ($SceneEditor.SceneArray[$i] -eq 0xF) { # Lightning Settings List
            $SceneEditor.SceneOffsets[0].LightningCount      = $SceneEditor.SceneArray[$i + 1]
            $SceneEditor.SceneOffsets[0].LightningStart      = $SceneEditor.SceneArray[$i + 5] * 65536 + $SceneEditor.SceneArray[$i + 6] * 256 + $SceneEditor.SceneArray[$i + 7]
            $SceneEditor.SceneOffsets[0].LightningCountIndex = $i + 1
            $SceneEditor.SceneOffsets[0].LightningIndex      = $i + 5
        }
        elseif ($SceneEditor.SceneArray[$i] -eq 0x11) { # Skybox Settings
            $SceneEditor.SceneOffsets[0].Skybox              = $i + 4
            $SceneEditor.SceneOffsets[0].Cloudy              = $i + 5
            $SceneEditor.SceneOffsets[0].LightningControl    = $i + 6
        }
        elseif ($SceneEditor.SceneArray[$i] -eq 0x13) { # Exit List
            $SceneEditor.SceneOffsets[0].ExitStart           = $SceneEditor.SceneArray[$i + 5] * 65536 + $SceneEditor.SceneArray[$i + 6] * 256 + $SceneEditor.SceneArray[$i + 7]
            $SceneEditor.SceneOffsets[0].ExitIndex           = $i + 5
            $SceneEditor.SceneOffsets[0].FoundExits          = $True
        }
        elseif ($SceneEditor.SceneArray[$i] -eq 0x15) { # Sound Settings
            $SceneEditor.SceneOffsets[0].SoundConfig         = $i + 1
            $SceneEditor.SceneOffsets[0].NightSequence       = $i + 6
            $SceneEditor.SceneOffsets[0].MusicSequence       = $i + 7
        }
        elseif ($SceneEditor.SceneArray[$i] -eq 0x17) { # Cutscenes List
            $SceneEditor.SceneOffsets[0].CutsceneStart       = $SceneEditor.SceneArray[$i + 5] * 65536 + $SceneEditor.SceneArray[$i + 6] * 256 + $SceneEditor.SceneArray[$i + 7]
            $SceneEditor.SceneOffsets[0].CutsceneIndex       = $i + 5
            $SceneEditor.SceneOffsets[0].FoundCutscenes      = $True
        }
        elseif ($SceneEditor.SceneArray[$i] -eq 0x18) { # Alternate Headers
            $SceneEditor.SceneOffsets[0].AlternateStart      = $SceneEditor.SceneArray[$i + 5] * 65536 + $SceneEditor.SceneArray[$i + 6] * 256 + $SceneEditor.SceneArray[$i + 7]
            $SceneEditor.SceneOffsets[0].AlternateIndex      = $i + 5
        }

        $SceneEditor.SceneOffsets[0].NextAlternate = $SceneEditor.SceneOffsets[0].PositionStart
    }

    if (IsSet $SceneEditor.SceneOffsets[0].AlternateStart) {
        for ($i=$SceneEditor.SceneOffsets[0].AlternateStart; $i -lt $SceneEditor.SceneOffsets[0].NextAlternate; $i+=4) {
            if ($SceneEditor.SceneArray[$i] -ne 2) { continue }

            $SceneEditor.SceneOffsets                                                  += @{}
            $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].Header         = $SceneEditor.SceneArray[$i + 1] * 65536 + $SceneEditor.SceneArray[$i + 2] * 256 + $SceneEditor.SceneArray[$i + 3]
            $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].FoundPaths     = $False
            $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].FoundActors    = $False
            $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].FoundExits     = $False
            $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].FoundCutscenes = $False

            for ($j=$SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].Header; $j -lt ($SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].Header + $headerSize); $j+=8) {
                if ($SceneEditor.SceneArray[$j] -eq 0x14) {
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].HeaderEnd           = $j
                    break
                }
                elseif ($SceneEditor.SceneArray[$j] -eq 0x0) { # Start Positions List
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].PositionCount       = $SceneEditor.SceneArray[$j + 1]
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].PositionStart       = $SceneEditor.SceneArray[$j + 5] * 65536 + $SceneEditor.SceneArray[$j + 6] * 256 + $SceneEditor.SceneArray[$j + 7]
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].PositionCountIndex  = $j + 1
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].PositionIndex       = $j + 5
                }
                elseif ($SceneEditor.SceneArray[$j] -eq 0x3) { # Collision Header List
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].CollisionStart      = $SceneEditor.SceneArray[$j + 5] * 65536 + $SceneEditor.SceneArray[$j + 6] * 256 + $SceneEditor.SceneArray[$j + 7]
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].CollisionIndex      = $j + 5
                }
                elseif ($SceneEditor.SceneArray[$j] -eq 0x4) { # Map List
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].MapCount            = $SceneEditor.SceneArray[$j + 1]
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].MapStart            = $SceneEditor.SceneArray[$j + 5] * 65536 + $SceneEditor.SceneArray[$j + 6] * 256 + $SceneEditor.SceneArray[$j + 7]
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].MapCountIndex       = $j + 1
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].MapIndex            = $j + 5
                }
                elseif ($SceneEditor.SceneArray[$j] -eq 0x6) { # Entrance List
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].EntranceStart       = $SceneEditor.SceneArray[$j + 5] * 65536 + $SceneEditor.SceneArray[$j + 6] * 256 + $SceneEditor.SceneArray[$j + 7]
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].EntranceIndex       = $j + 5
                }
                elseif ($SceneEditor.SceneArray[$j] -eq 0x7) { # Special Objects
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].MessageConfig       = $j + 1
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].ObjectConfig        = $j + 7
                }
                elseif ($SceneEditor.SceneArray[$j] -eq 0xD) { # Pathways List
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].PathStart           = $SceneEditor.SceneArray[$j + 5] * 65536 + $SceneEditor.SceneArray[$j + 6] * 256 + $SceneEditor.SceneArray[$j + 7]
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].PathIndex           = $j + 5
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].FoundPaths          = $True
                }
                elseif ($SceneEditor.SceneArray[$j] -eq 0xE) { # Transition Actor List
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].ActorCount          = $SceneEditor.SceneArray[$j + 1]
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].ActorStart          = $SceneEditor.SceneArray[$j + 5] * 65536 + $SceneEditor.SceneArray[$j + 6] * 256 + $SceneEditor.SceneArray[$j + 7]
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].ActorCountIndex     = $j + 1
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].ActorIndex          = $j + 5
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].FoundActors         = $True
                }
                elseif ($SceneEditor.SceneArray[$j] -eq 0xF) { # Lightning Settings List
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].LightningCount      = $SceneEditor.SceneArray[$j + 1]
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].LightningStart      = $SceneEditor.SceneArray[$j + 5] * 65536 + $SceneEditor.SceneArray[$j + 6] * 256 + $SceneEditor.SceneArray[$j + 7]
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].LightningCountIndex = $j + 1
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].LightningIndex      = $j + 5
                }
                elseif ($SceneEditor.SceneArray[$j] -eq 0x11) { # Skybox Settings
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].Skybox              = $j + 4
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].Cloudy              = $j + 5
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].LightningControl    = $j + 6
                }
                elseif ($SceneEditor.SceneArray[$j] -eq 0x13) { # Exit List
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].ExitStart           = $SceneEditor.SceneArray[$j + 5] * 65536 + $SceneEditor.SceneArray[$j + 6] * 256 + $SceneEditor.SceneArray[$j + 7]
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].ExitIndex           = $j + 5
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].FoundExits          = $True
                }
                elseif ($SceneEditor.SceneArray[$j] -eq 0x15) { # Sound Settings
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].SoundConfig         = $j + 1
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].NightSequence       = $j + 6
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].MusicSequence       = $j + 7
                }
                elseif ($SceneEditor.SceneArray[$j] -eq 0x17) { # Cutscenes List
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].CutsceneStart       = $SceneEditor.SceneArray[$j + 5] * 65536 + $SceneEditor.SceneArray[$j + 6] * 256 + $SceneEditor.SceneArray[$j + 7]
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].CutsceneIndex       = $j + 5
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].FoundCutscenes      = $True
                }
            }
        }
    }

}



#==============================================================================================================================================================================================
function LoadMap([object[]]$Scene=$SceneEditor.LoadedScene, [byte]$Map=$SceneEditor.LoadedMap) {
    
    $headerSize = 80
    if ($SceneEditor.GUI) {
        $file = $Paths.Games + "\" + $Files.json.sceneEditor.game + "\Editor\Scenes\" + $Scene.name + "\room_" + $SceneEditor.Maps.SelectedIndex + ".zmap"
    
        if ($Files.json.sceneEditor.quest -is [array] -and $Files.json.sceneEditor.quest.Count -gt 0 -and $Scene.Dungeon -eq 1) {
            for ($i=0; $i -lt $Files.json.sceneEditor.quest.Count; $i++) {
                if ($SceneEditor.Quests[$i+1].Checked) { $file = $Paths.Games + "\" + $Files.json.sceneEditor.game + "\Editor\Scenes\" + $Scene.name + "\" + $Files.json.sceneEditor.quest[$i] + "\room_" + $SceneEditor.Maps.SelectedIndex + ".zmap" }
            }
        }
    }
    else { $file = $Paths.Temp + "\scene\room_" + $Map + ".zmap" }

    if (!(TestFile -Path $file)) { return }

    [System.Collections.ArrayList]$SceneEditor.MapArray = [System.IO.File]::ReadAllBytes($file)
    if ($SceneEditor.GUI)                      { $items = @("Stage 1") }
    $SceneEditor.Offsets                                = @()
    $SceneEditor.Offsets                               += @{}
    $SceneEditor.Offsets[0].Header                      = 0
    $SceneEditor.Offsets[0].FoundActors                 = $False
    $SceneEditor.Offsets[0].FoundObjects                = $False

    for ($i=0; $i -lt $headerSize; $i+=8) {
        if ($SceneEditor.MapArray[$i] -eq 0x14) {
            $SceneEditor.Offsets[0].HeaderEnd        = $i
            break
        }
        elseif ($SceneEditor.MapArray[$i] -eq 0x1) { # Actor List
            $SceneEditor.Offsets[0].ActorCount       = $SceneEditor.MapArray[$i + 1]
            $SceneEditor.Offsets[0].ActorStart       = $SceneEditor.MapArray[$i + 5] * 65536 + $SceneEditor.MapArray[$i + 6] * 256 + $SceneEditor.MapArray[$i + 7]
            $SceneEditor.Offsets[0].ActorCountIndex  = $i + 1
            $SceneEditor.Offsets[0].ActorIndex       = $i + 5
            $SceneEditor.Offsets[0].FoundActors      = $True
        }
        elseif ($SceneEditor.MapArray[$i] -eq 0x5) { # Wind
            $SceneEditor.Offsets[0].WindWest         = $i + 4
            $SceneEditor.Offsets[0].WindVertical     = $i + 5
            $SceneEditor.Offsets[0].WindSouth        = $i + 6
            $SceneEditor.Offsets[0].WindStrength     = $i + 7
        }
        elseif ($SceneEditor.MapArray[$i] -eq 0x8) { # Room Behaviour
            $SceneEditor.Offsets[0].Restrictions     = $i + 1
            $SceneEditor.Offsets[0].WarpSongs        = $i + 6
            $SceneEditor.Offsets[0].IdleAnimation    = $i + 7
        }
        elseif ($SceneEditor.MapArray[$i] -eq 0xA) { # Mesh List
            $SceneEditor.Offsets[0].MeshStart        = $SceneEditor.MapArray[$i + 5] * 65536 + $SceneEditor.MapArray[$i + 6] * 256 + $SceneEditor.MapArray[$i + 7]
            $SceneEditor.Offsets[0].MeshIndex        = $i + 5
        }
        elseif ($SceneEditor.MapArray[$i] -eq 0xB) { # Objects List
            $SceneEditor.Offsets[0].ObjectCount      = $SceneEditor.MapArray[$i + 1]
            $SceneEditor.Offsets[0].ObjectStart      = $SceneEditor.MapArray[$i + 5] * 65536 + $SceneEditor.MapArray[$i + 6] * 256 + $SceneEditor.MapArray[$i + 7]
            $SceneEditor.Offsets[0].ObjectCountIndex = $i + 1
            $SceneEditor.Offsets[0].ObjectIndex      = $i + 5
            $SceneEditor.Offsets[0].FoundObjects     = $True
        }
        elseif ($SceneEditor.MapArray[$i] -eq 0x10) { # Time Settings
            $SceneEditor.Offsets[0].Time             = $i + 4
            $SceneEditor.Offsets[0].TimeSpeed        = $i + 6
        }
        elseif ($SceneEditor.MapArray[$i] -eq 0x12) { # Skybox Modifier
            $SceneEditor.Offsets[0].DisableSkybox    = $i + 4
            $SceneEditor.Offsets[0].DisableSun       = $i + 5
        }
        elseif ($SceneEditor.MapArray[$i] -eq 0x18) { # Alternate Headers
            $SceneEditor.Offsets[0].AlternateStart   = $SceneEditor.MapArray[$i + 5] * 65536 + $SceneEditor.MapArray[$i + 6] * 256 + $SceneEditor.MapArray[$i + 7]
            $SceneEditor.Offsets[0].AlternateIndex   = $i + 5
        }

        if     ($SceneEditor.Offsets[0].ObjectStart -gt $SceneEditor.Offsets[0].AlternateStart)   { $SceneEditor.Offsets[0].NextAlternate = $SceneEditor.Offsets[0].ObjectStart }
        elseif ($SceneEditor.Offsets[0].ActorStart  -gt $SceneEditor.Offsets[0].AlternateStart)   { $SceneEditor.Offsets[0].NextAlternate = $SceneEditor.Offsets[0].ActorStart  }
        elseif ($SceneEditor.Offsets[0].MeshStart   -gt $SceneEditor.Offsets[0].AlternateStart)   { $SceneEditor.Offsets[0].NextAlternate = $SceneEditor.Offsets[0].MeshStart   }
    }

    if (IsSet $SceneEditor.Offsets[0].AlternateStart) {
        for ($i=$SceneEditor.Offsets[0].AlternateStart; $i -lt $SceneEditor.Offsets[0].NextAlternate; $i+=4) {
            if ($SceneEditor.MapArray[$i] -ne 3) { continue }

            $SceneEditor.Offsets                                           += @{}
            $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].Header       = $SceneEditor.MapArray[$i + 1] * 65536 + $SceneEditor.MapArray[$i + 2] * 256 + $SceneEditor.MapArray[$i + 3]
            $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].FoundActors  = $False
            $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].FoundObjects = $False

            for ($j=$SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].Header; $j -lt ($SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].Header + $headerSize); $j+=8) {
                if ($SceneEditor.MapArray[$j] -eq 0x14) {
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].HeaderEnd        = $j
                    break
                }
                elseif ($SceneEditor.MapArray[$j] -eq 0x1) { # Actor List
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].ActorCount       = $SceneEditor.MapArray[$j + 1]
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].ActorStart       = $SceneEditor.MapArray[$j + 5] * 65536 + $SceneEditor.MapArray[$j + 6] * 256 + $SceneEditor.MapArray[$j + 7]
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].ActorCountIndex  = $j + 1
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].ActorIndex       = $j + 5
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].FoundActors      = $True
                }
                elseif ($SceneEditor.MapArray[$j] -eq 0x5) { # Wind
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].WindWest         = $j + 4
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].WindVertical     = $j + 5
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].WindSouth        = $j + 6
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].WindStrength     = $j + 7
                }
                elseif ($SceneEditor.MapArray[$j] -eq 0x8) { # Room Behaviour
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].Restrictions     = $j + 1
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].WarpSongs        = $j + 6
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].IdleAnimation    = $j + 7
                }
                elseif ($SceneEditor.MapArray[$j] -eq 0xA) { # Mesh List
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].MeshStart        = $SceneEditor.MapArray[$j + 5] * 65536 + $SceneEditor.MapArray[$j + 6] * 256 + $SceneEditor.MapArray[$j + 7]
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].MeshIndex        = $j + 5
                }
                elseif ($SceneEditor.MapArray[$j] -eq 0xB) { # Objects List
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].ObjectCount      = $SceneEditor.MapArray[$j + 1]
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].ObjectStart      = $SceneEditor.MapArray[$j + 5] * 65536 + $SceneEditor.MapArray[$j + 6] * 256 + $SceneEditor.MapArray[$j + 7]
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].ObjectCountIndex = $j + 1
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].ObjectIndex      = $j + 5
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].FoundObjects     = $True
                }
                elseif ($SceneEditor.MapArray[$j] -eq 0x10) { # Time Settings
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].Time             = $j + 4
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].TimeSpeed        = $j + 6
                }
                elseif ($SceneEditor.MapArray[$j] -eq 0x12) { # Skybox modifier
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].DisableSkybox    = $j + 4
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].DisableSun       = $j + 5
                }
            }

            if ($SceneEditor.GUI) {
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
    }

    if ($SceneEditor.GUI) {
        if ($Scene.stages -is [array]) {
            if ($Scene.stages[0] -ne 0 -and $Scene.stages[0] -ne "") { $items[0] += "     (" + $Scene.stages[0] + ")" }
        }

        if ($SceneEditor.LastScene.name -ne $Scene.name -or $SceneEditor.Headers.Items.Count -eq 0) {
            $SceneEditor.Headers.Items.Clear()
            $SceneEditor.Headers.Items.AddRange($items)
            $SceneEditor.Headers.SelectedIndex = 0
        }
        else { LoadHeader -Scene $Scene }
    }

}



#==============================================================================================================================================================================================
function GetHeader()                      { return $SceneEditor.Offsets[$SceneEditor.LoadedHeader].Header                                                                          }
function GetHeaderEnd()                   { return $SceneEditor.Offsets[$SceneEditor.LoadedHeader].HeaderEnd                                                                       }
function GetActorCount()                  { return $SceneEditor.Offsets[$SceneEditor.LoadedHeader].ActorCount                                                                      }
function GetActorStart()                  { return $SceneEditor.Offsets[$SceneEditor.LoadedHeader].ActorStart                                                                      }
function GetActorEnd()                    { return $SceneEditor.Offsets[$SceneEditor.LoadedHeader].ActorStart  + ($SceneEditor.Offsets[$SceneEditor.LoadedHeader].ActorCount * 16) }
function GetActorCountIndex()             { return $SceneEditor.Offsets[$SceneEditor.LoadedHeader].ActorCountIndex                                                                 }
function GetActorIndex()                  { return $SceneEditor.Offsets[$SceneEditor.LoadedHeader].ActorIndex                                                                      }
function GetFoundActors()                 { return $SceneEditor.Offsets[$SceneEditor.LoadedHeader].FoundActors                                                                     }
function GetObjectCount()                 { return $SceneEditor.Offsets[$SceneEditor.LoadedHeader].ObjectCount                                                                     }
function GetObjectStart()                 { return $SceneEditor.Offsets[$SceneEditor.LoadedHeader].ObjectStart                                                                     }
function GetObjectEnd()                   { return $SceneEditor.Offsets[$SceneEditor.LoadedHeader].ObjectStart + ($SceneEditor.Offsets[$SceneEditor.LoadedHeader].ObjectCount * 2) }
function GetObjectCountIndex()            { return $SceneEditor.Offsets[$SceneEditor.LoadedHeader].ObjectCountIndex                                                                }
function GetObjectIndex()                 { return $SceneEditor.Offsets[$SceneEditor.LoadedHeader].ObjectIndex                                                                     }
function GetFoundObjects()                { return $SceneEditor.Offsets[$SceneEditor.LoadedHeader].FoundObjects                                                                    }
function GetMeshStart()                   { return $SceneEditor.Offsets[$SceneEditor.LoadedHeader].MeshStart                                                                       }
function GetMeshIndex()                   { return $SceneEditor.Offsets[$SceneEditor.LoadedHeader].MeshIndex                                                                       }

function GetSceneHeader()                 { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].Header                                                                                      }
function GetSceneHeaderEnd()              { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].HeaderEnd                                                                                   }
function GetPositionCount()               { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].PositionCount                                                                               }
function GetPositionStart()               { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].PositionStart                                                                               }
function GetPositionEnd()                 { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].PositionStart  + ($SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].PositionCount * 16)  }
function GetPositionCountIndex()          { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].PositionCountIndex                                                                          }
function GetPositionIndex()               { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].PositionIndex                                                                               }
function GetCollisionStart()              { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].CollisionStart                                                                              }
function GetCollisionIndex()              { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].CollisionIndex                                                                              }
function GetMapCount()                    { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].MapCount                                                                                    }
function GetMapStart()                    { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].MapStart                                                                                    }
function GetMapEnd()                      { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].MapStart       + ($SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].MapCount      * 8)   }
function GetMapCountIndex()               { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].MapCountIndex                                                                               }
function GetMapIndex()                    { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].MapIndex                                                                                    }
function GetEntranceStart()               { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].EntranceStart                                                                               }
function GetEntranceEnd()                 { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].EntranceStart  + ($SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].PositionCount * 2)   }
function GetEntranceIndex()               { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].EntranceIndex                                                                               }
function GetTransitionActorCount()        { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].ActorCount                                                                                  }
function GetTransitionActorStart()        { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].ActorStart                                                                                  }
function GetTransitionActorEnd()          { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].ActorStart     + ($SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].ActorCount    * 16)  }
function GetTransitionActorCountIndex()   { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].ActorCountIndex                                                                             }
function GetTransitionActorIndex()        { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].ActorIndex                                                                                  }
function GetFoundTransitionActors()       { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].FoundActors                                                                                 }
function GetLightningCount()              { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].LightningCount                                                                              }
function GetLightningStart()              { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].LightningStart                                                                              }
function GetLightningEnd()                { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].LightningStart + ($SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].LightningCount * 22) }
function GetLightningCountIndex()         { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].LightningCountIndex                                                                         }
function GetLightningIndex()              { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].LightningIndex                                                                              }
function GetExitStart()                   { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].ExitStart                                                                                   }
function GetExitIndex()                   { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].ExitIndex                                                                                   }
function GetFoundExits()                  { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].FoundExits                                                                                  }
function GetPathStart()                   { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].PathStart                                                                                   }
function GetPathIndex()                   { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].PathIndex                                                                                   }
function GetFoundPaths()                  { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].FoundPaths                                                                                  }
function GetCutsceneStart()               { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].CutsceneStart                                                                               }
function GetCutsceneIndex()               { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].CutsceneIndex                                                                               }
function GetFoundCutscenes()              { return $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].FoundCutscenes                                                                              }



#==============================================================================================================================================================================================
function LoadHeader([object[]]$Scene) {
    
    $SceneEditor.BottomPanelObjects.Controls.Clear()
    [System.Collections.ArrayList]$SceneEditor.Objects = @()

    if (!(IsSet $SceneEditor.Offsets)) { return }

    if (GetFoundActors) {
        $actorTypes = @("Enemy", "Boss", "NPC", "Animal", "Cutscene", "Object", "Area", "Effect", "Unused", "Other")
        $SceneEditor.ActorList = @{}
        for ($i=0; $i -lt $actorTypes.Count-1; $i++) { $SceneEditor.ActorList[$i] = $Files.json.sceneEditor.actors  | where { $_.Type -eq $actorTypes[$i] } }
        $SceneEditor.ActorList[$actorTypes.Count-1]  = $Files.json.sceneEditor.actors  | where { $_.Type -eq $null }
    }

    if (GetFoundObjects) {
        $objectTypes = @("Enemy", "Boss", "NPC", "Animal", "Object", "Model", "Area", "Animation", "Unused", "Other")
        $SceneEditor.ObjectList = @{}
        for ($i=0; $i -lt $objectTypes.Count-1; $i++) { $SceneEditor.ObjectList[$i] = $Files.json.sceneEditor.objects | where { $_.Type -eq $objectTypes[$i] } }
        $SceneEditor.ObjectList[$objectTypes.Count-1] = $Files.json.sceneEditor.objects | where { $_.Type -eq $null }

        for ([byte]$i=0; $i -lt (GetObjectCount); $i++) { AddObject }
    }

    if (GetFoundTransitionActors) { [System.Collections.ArrayList]$SceneEditor.TransitionActors = @() }

    $SceneEditor.Tab = $null
    if ( (IsSet $Settings["Core"]["Editor.Tab." + $Files.json.sceneEditor.parse]) -and $SceneEditor.FirstLoad)   { LoadTab -Tab $Settings["Core"]["Editor.Tab." + $Files.json.sceneEditor.parse] }
    else                                                                                                         { LoadTab -Tab 1 }

    $file = $Paths.Games + "\" + $Files.json.sceneEditor.game + "\Maps\" + $SceneEditor.Scenes.Text + "\Stage " + ($SceneEditor.LoadedHeader+1) + "\room_" + $SceneEditor.Maps.SelectedIndex + ".jpg"
    if (TestFile $file) { SetBitMap -Path $file -Box $SceneEditor.MapPreviewImage }
    else {
        $file = $Paths.Games + "\" + $Files.json.sceneEditor.game + "\Maps\" + $SceneEditor.Scenes.Text + "\room_" + $SceneEditor.Maps.SelectedIndex + ".jpg"
        if (TestFile $file) { SetBitMap -Path $file -Box $SceneEditor.MapPreviewImage }
        else {
            $file = $Paths.Games + "\" + $Files.json.sceneEditor.game + "\Maps\default.jpg"
            if (TestFile $file) { SetBitMap -Path $file -Box $SceneEditor.MapPreviewImage } else { $SceneEditor.MapPreviewImage.Image = $null }
        }
    }

    if ($Files.json.sceneEditor.quest -is [array] -and $Files.json.sceneEditor.quest.Count -gt 0) {
        foreach ($elem in $SceneEditor.Quests) { $elem.Enabled = (GetFoundActors) -or (GetFoundObjects) }
    }

    LoadSceneSettings
    LoadMapSettings

    $SceneEditor.ResetMapButton.Enabled = (GetFoundActors) -or (GetFoundObjects)
    $SceneEditor.PatchDungeons.Enabled  = $SceneEditor.PatchCurrent.Enabled = $True
    $SceneEditor.DeleteActor.Enabled    = $SceneEditor.InsertActor.Enabled  = GetFoundActors
    $SceneEditor.DeleteObject.Enabled   = $SceneEditor.InsertObject.Enabled = GetFoundObjects
    $SceneEditor.FirstLoad              = $False
    
}



#==============================================================================================================================================================================================
function LoadActors() {
    
    $SceneEditor.BottomPanelActors.Controls.Clear()
    [System.Collections.ArrayList]$SceneEditor.Actors = @()

    if (!(IsSet $SceneEditor.Offsets))   { return }
    if (!(GetFoundActors))               { return }

    $start = ($SceneEditor.Tab - 1) * 50
    $end   = $start + 50
    if ($Tab -eq 5) { $end += 5 }

    $SceneEditor.BottomPanelActors.AutoScroll = $False

    if ($Settings.Debug.SceneEditorChecks -eq $True) {
        $SceneEditor.trackFlag1Values = @()
        $SceneEditor.trackFlag2Values = @()
        $SceneEditor.trackFlag3Values = @()
    }

    for ([byte]$i=$start; $i -lt $end; $i++) {
        if ($i -ge (GetActorCount)) { break }
        AddActor
    }

    if ($Settings.Debug.SceneEditorChecks -eq $True) {
        if ($SceneEditor.trackFlag1Values.count -gt 0 -or $SceneEditor.trackFlag2Values.count -gt 0 -or $SceneEditor.trackFlag3Values.count -gt 0) {
            WriteToConsole ("Current Setup: " + $SceneEditor.Scenes.Text + " - Map: " + $SceneEditor.Maps.SelectedIndex + ", Header: " + $SceneEditor.LoadedHeader)
            if ($SceneEditor.trackFlag1Values.count -gt 0)    { WriteToConsole ("Used Flags:        " + ($SceneEditor.trackFlag1Values | Sort-Object | Get-Unique) ) }
            if ($SceneEditor.trackFlag2Values.count -gt 0)    { WriteToConsole ("Used Switches:     " + ($SceneEditor.trackFlag2Values | Sort-Object | Get-Unique) ) }
            if ($SceneEditor.trackFlag3Values.count -gt 0)    { WriteToConsole ("Used Collectables: " + ($SceneEditor.trackFlag3Values | Sort-Object | Get-Unique) ) }
        }
    }

    $SceneEditor.BottomPanelActors.AutoScroll        = $True
    $SceneEditor.BottomPanelActors.AutoScrollMargin  = New-Object System.Drawing.Size(0, 0)
    $SceneEditor.BottomPanelActors.AutoScrollMinSize = New-Object System.Drawing.Size(0, 0)

}



#==============================================================================================================================================================================================
function ShiftMapHeaderData([int16]$Shift=0x10) {
    
    if (IsSet $SceneEditor.Offsets[0].AlternateStart) {
        for ($i=$SceneEditor.Offsets[0].AlternateStart; $i-lt $SceneEditor.Offsets[0].ObjectStart; $i+= 4) {
            if ($SceneEditor.MapArray[$i] -ne 3) { continue }
            $value = $SceneEditor.MapArray[$i+1] * 65536 + $SceneEditor.MapArray[$i+2] * 256 + $SceneEditor.MapArray[$i+3]
            if ($value -gt (GetHeader)) { ShiftMap -Offset ($i+1) -Shift $Shift }
        }
    }

    for ($i=1; $i -lt $SceneEditor.Offsets.Header.Count; $i++) {
        if ($SceneEditor.Offsets[$i].Header -le (GetHeader)) { continue }

        $SceneEditor.Offsets[$i].Header    += $Shift
        $SceneEditor.Offsets[$i].HeaderEnd += $Shift

        if ($SceneEditor.Offsets[$i].FoundActors) {
            $SceneEditor.Offsets[$i].ActorStart       += $Shift
            $SceneEditor.Offsets[$i].ActorCountIndex  += $Shift
            $SceneEditor.Offsets[$i].ActorIndex       += $Shift
            ShiftMap -Offset $SceneEditor.Offsets[$i].ActorIndex  -Shift $Shift
        }

        if ($SceneEditor.Offsets[$i].FoundObjects) {
            $SceneEditor.Offsets[$i].ObjectStart      += $Shift
            $SceneEditor.Offsets[$i].ObjectCountIndex += $Shift
            $SceneEditor.Offsets[$i].ObjectIndex      += $Shift
            ShiftMap -Offset $SceneEditor.Offsets[$i].ObjectIndex -Shift $Shift
        }

        $SceneEditor.Offsets[$i].MeshIndex            += $Shift
        if ($SceneEditor.LoadedHeader -eq 0) {
            $SceneEditor.Offsets[$i].MeshStart        += $Shift
            ShiftMap -Offset $SceneEditor.Offsets[$i].MeshIndex   -Shift $Shift
        }
    }

    if ($SceneEditor.LoadedHeader -eq 0) {
        $SceneEditor.Offsets[0].MeshStart += $Shift
        ShiftMap -Offset  $SceneEditor.Offsets[0].MeshIndex    -Shift $Shift
        ShiftMap -Offset ($SceneEditor.Offsets[0].MeshStart+5) -Shift $Shift
        ShiftMap -Offset ($SceneEditor.Offsets[0].MeshStart+9) -Shift $Shift
    }

    if ($SceneEditor.GUI) { ShiftMapVtxData -Shift $Shift } else { $SceneEditor.MapShift += $Shift }

}



#==============================================================================================================================================================================================
function ShiftMapVtxData([int16]$Shift=0x10) {
    
    $meshStart = $SceneEditor.MapArray[$SceneEditor.Offsets[0].MeshStart + 5] * 65536 + $SceneEditor.MapArray[$SceneEditor.Offsets[0].MeshStart + 6]  * 256 + $SceneEditor.MapArray[$SceneEditor.Offsets[0].MeshStart + 7]
    $meshEnd   = $SceneEditor.MapArray[$SceneEditor.Offsets[0].MeshStart + 9] * 65536 + $SceneEditor.MapArray[$SceneEditor.Offsets[0].MeshStart + 10] * 256 + $SceneEditor.MapArray[$SceneEditor.Offsets[0].MeshStart + 11]
    $meshes    = @()

    for ($i=$meshStart; $i -lt $meshEnd; $i+= 4) {
        if ($SceneEditor.MapArray[$i] -eq 3) {
            $value = $SceneEditor.MapArray[$i+1] * 65536 + $SceneEditor.MapArray[$i+2] * 256 + $SceneEditor.MapArray[$i+3] + $Shift
            if ($value -gt $SceneEditor.Offsets[$SceneEditor.Offsets.Header.Count-1].Header -and $value -le $SceneEditor.MapArray.Count) {
                ShiftMap -Offset ($i+1) -Shift $Shift
                $meshes += $SceneEditor.MapArray[$i+1] * 65536 + $SceneEditor.MapArray[$i+2] * 256 + $SceneEditor.MapArray[$i+3]
            }
        }
    }

    $meshes = $meshes | Sort-Object
    if ($meshes.count -gt 0) {
        for ($i=$meshes[0]; $i -lt $meshes[0]+512; $i+=4) {
            if ($SceneEditor.MapArray[$i] -eq 3) { $vtx = $SceneEditor.MapArray[$i+1] * 65536 + $SceneEditor.MapArray[$i+2] * 256 + $SceneEditor.MapArray[$i+3]; break }
        }

        for ($i=$SceneEditor.Offsets[$SceneEditor.Offsets.Header.Count-1].HeaderEnd; $i -lt $vtx; $i+=8) {
            if ($SceneEditor.MapArray[$i] -eq 0xD7 -and $SceneEditor.MapArray[$i+1] -eq 0 -and $SceneEditor.MapArray[$i+2] -eq 0 -and $SceneEditor.MapArray[$i+3] -eq 2 -and $SceneEditor.MapArray[$i+4] -eq 0xFF -and $SceneEditor.MapArray[$i+5] -eq 0xFF -and $SceneEditor.MapArray[$i+6] -eq 0xFF -and $SceneEditor.MapArray[$i+7] -eq 0xFF) {
                $vtx = $i; break
            }
        }

        $skip = $blockDF = $False
        for ($i=$vtx; $i -lt $SceneEditor.MapArray.Count; $i+=4) {
            if ($SceneEditor.MapArray[$i+1] -eq 0 -and $SceneEditor.MapArray[$i+2] -eq 0 -and $SceneEditor.MapArray[$i+3] -eq 0) {
                if ($SceneEditor.MapArray[$i] -eq 0xE7 -or  $SceneEditor.MapArray[$i]   -eq 0xFE)   { $skip = $False; $blockDF = $False }
                if ($SceneEditor.MapArray[$i] -eq 0xFF -and $SceneEditor.MapArray[$i-4] -gt 0xF0)   { $skip = $True;  $blockDF = $False }
                if ($SceneEditor.MapArray[$i] -eq 0xDF) {
                    if     ($SceneEditor.MapArray[$i-8] -eq 0xDE -and !$BlockDF)   { $skip = $False; $blockDF = $True  }
                    elseif ($SceneEditor.MapArray[$i+8] -eq 0xDE -and  $BlockDF)   { $skip = $True;  $blockDF = $False }
                }
            }

            if ($SceneEditor.MapArray[$i] -eq 3 -and !$skip) {
                $value = $SceneEditor.MapArray[$i+1] * 65536 + $SceneEditor.MapArray[$i+2] * 256 + $SceneEditor.MapArray[$i+3] + $Shift
                if ($value -gt $SceneEditor.Offsets[$SceneEditor.Offsets.Header.Count-1].Header -and $value -gt $SceneEditor.Offsets[$SceneEditor.Offsets.Header.Count-1].MeshStart -and $value -lt $SceneEditor.MapArray.Count) { ShiftMap -Offset ($i+1) -Shift $Shift }
            }
        }
    }

}



#==============================================================================================================================================================================================
function ShiftSceneHeaderData([int16]$Shift=0x10) {
    
    for ($i=1; $i -lt $SceneEditor.SceneOffsets.Header.Count; $i++) {
        if ($SceneEditor.SceneOffsets[$i].Header -le (GetSceneHeader)) { continue }

        $SceneEditor.SceneOffsets[$i].Header                += $Shift
        $SceneEditor.SceneOffsets[$i].HeaderEnd             += $Shift

        $SceneEditor.SceneOffsets[$i].PositionStart         += $Shift
        $SceneEditor.SceneOffsets[$i].PositionCountIndex    += $Shift
        $SceneEditor.SceneOffsets[$i].PositionIndex         += $Shift
        ShiftScene -Offset $SceneEditor.SceneOffsets[$i].PositionIndex         -Shift $Shift

        $SceneEditor.SceneOffsets[$i].MapStart              += $Shift
        $SceneEditor.SceneOffsets[$i].MapCountIndex         += $Shift
        $SceneEditor.SceneOffsets[$i].MapIndex              += $Shift
        ShiftScene -Offset $SceneEditor.SceneOffsets[$i].MapIndex              -Shift $Shift

        $SceneEditor.SceneOffsets[$i].EntranceStart         += $Shift
        $SceneEditor.SceneOffsets[$i].EntranceIndex         += $Shift
        ShiftScene -Offset $SceneEditor.SceneOffsets[$i].EntranceIndex         -Shift $Shift

        $SceneEditor.SceneOffsets[$i].LightningStart        += $Shift
        $SceneEditor.SceneOffsets[$i].LightningCountIndex   += $Shift
        $SceneEditor.SceneOffsets[$i].LightningIndex        += $Shift
        ShiftScene -Offset $SceneEditor.SceneOffsets[$i].LightningIndex        -Shift $Shift

        if ($SceneEditor.SceneOffsets[$i].FoundPaths) {
            $SceneEditor.SceneOffsets[$i].PathStart         += $Shift
            $SceneEditor.SceneOffsets[$i].PathIndex         += $Shift
            ShiftScene -Offset $SceneEditor.SceneOffsets[$i].PathIndex         -Shift $Shift
            $path = $SceneEditor.SceneOffsets[$i].PathStart
            while ($SceneEditor.SceneArray[$path] -gt 1 -and $SceneEditor.SceneArray[$path] -lt 0x80 -and $SceneEditor.SceneArray[$path+1] -eq 0 -and $SceneEditor.SceneArray[$path+2] -eq 0 -and $SceneEditor.SceneArray[$path+3] -eq 0 -and $SceneEditor.SceneArray[$path+4] -eq 2) {
                ShiftScene -Offset ($path + 5) -Shift $Shift
                if ($SceneEditor.SceneArray[$path+8] -gt 1 -and $SceneEditor.SceneArray[$path+8] -lt 0x80 -and $SceneEditor.SceneArray[$path+9] -eq 0 -and $SceneEditor.SceneArray[$path+10] -eq 0 -and $SceneEditor.SceneArray[$path+11] -eq 0 -and $SceneEditor.SceneArray[$path+12] -eq 2) {
                    $path += 8
                }
                else { $path += $SceneEditor.SceneArray[$path] * 6 }
            }
        }

        if ($SceneEditor.SceneOffsets[$i].FoundActors) {
            $SceneEditor.SceneOffsets[$i].ActorStart        += $Shift
            $SceneEditor.SceneOffsets[$i].ActorCountIndex   += $Shift
            $SceneEditor.SceneOffsets[$i].ActorIndex        += $Shift
            ShiftScene -Offset $SceneEditor.SceneOffsets[$i].ActorIndex        -Shift $Shift
        }

        if ($SceneEditor.SceneOffsets[$i].FoundExits) {
            $SceneEditor.SceneOffsets[$i].ExitStart         += $Shift
            $SceneEditor.SceneOffsets[$i].ExitIndex         += $Shift
            ShiftScene -Offset $SceneEditor.SceneOffsets[$i].ExitIndex         -Shift $Shift
        }

        if ($SceneEditor.SceneOffsets[$i].FoundCutscenes -and $SceneEditor.LoadedHeader -eq 0) {
            $SceneEditor.SceneOffsets[$i].CutsceneStart += $Shift
            $SceneEditor.SceneOffsets[$i].CutsceneIndex += $Shift
            ShiftScene -Offset $SceneEditor.SceneOffsets[$i].CutsceneIndex     -Shift $Shift
        }

        $SceneEditor.SceneOffsets[$i].CollisionIndex        += $Shift
        if ($SceneEditor.LoadedHeader -eq 0) {
            $SceneEditor.SceneOffsets[$i].CollisionStart    += $Shift
            ShiftScene -Offset $SceneEditor.SceneOffsets[$i].CollisionIndex    -Shift $Shift
        }
    }
    
    $lightningEnd = $SceneEditor.SceneOffsets[0].LightningStart + $SceneEditor.SceneOffsets[0].LightningCount * 22
    
    if ($SceneEditor.LoadedHeader -eq 0) {
        $nextHeader = $SceneEditor.SceneArray.Count

        foreach ($header in $SceneEditor.SceneOffsets.Header) {
            if ($header -lt $nextHeader -and $header -gt 0) { $nextHeader = $header }
        }

        for ($i=$SceneEditor.SceneOffsets[0].CollisionStart + 0xC; $i -lt $SceneEditor.SceneOffsets[0].CollisionStart + 0x2C; $i+=4) {
            if ($SceneEditor.SceneArray[$i] -eq 2) {
                $value = $SceneEditor.SceneArray[$i+1] * 65536 + $SceneEditor.SceneArray[$i+2] * 256 + $SceneEditor.SceneArray[$i+3]
                if ( ($value + $Shift) -gt $lightningEnd -and $value -lt $nextHeader) { ShiftScene -Offset ($i+1) -Shift $Shift  }
            }
        }

        for ($i=$SceneEditor.SceneOffsets[0].CollisionStart + 0x2C; $i -lt $nextHeader; $i+=4) {
            if ($SceneEditor.SceneArray[$i] -eq 2) {
                $value = $SceneEditor.SceneArray[$i+1] * 65536 + $SceneEditor.SceneArray[$i+2] * 256 + $SceneEditor.SceneArray[$i+3]
                if ($value -gt $lightningEnd -and $value -lt $nextHeader) { ShiftScene -Offset ($i+1) -Shift $Shift }
            }
        }
    }

    # Camera List
    $collisionStart = $SceneEditor.SceneOffsets[0].CollisionStart + 0x20
    if ($SceneEditor.SceneArray[$collisionStart] -eq 2) {
        $offset = $SceneEditor.SceneArray[$collisionStart + 1] * 0x10000 + $SceneEditor.SceneArray[$collisionStart + 2] * 0x100 + $SceneEditor.SceneArray[$collisionStart + 3]
        $value  = $SceneEditor.SceneArray[$offset + 5] * 0x10000 + $SceneEditor.SceneArray[$offset + 6] * 0x100 + $SceneEditor.SceneArray[$offset + 7]
        
        if ($SceneEditor.LoadedHeader -eq 0) {
            while ($SceneEditor.SceneArray[$offset] -eq 0 -and $SceneEditor.SceneArray[$offset + 2] -eq 0 -and $SceneEditor.SceneArray[$offset + 4] -eq 2) {
                ShiftScene -Offset ($offset + 5) -Shift $Shift
                $offset += 8
            }
        }
    }

    if ($SceneEditor.GUI) { ShiftSceneMapData -Shift $Shift } else { $SceneEditor.SceneMapShift += $Shift }


}



#==============================================================================================================================================================================================
function ShiftSceneMapData([int16]$Shift=0x10) {

    $originalMap = $SceneEditor.LoadedMap
    if ($SceneEditor.GUI) { [System.IO.File]::WriteAllBytes(($Paths.Temp + "\scene\room_" + $SceneEditor.LoadedMap + ".zmap"), $SceneEditor.MapArray) }
    for ($map=0; $map -lt $SceneEditor.SceneOffsets[0].MapCount; $map++) {
        $SceneEditor.LoadedMap = $map
        LoadMap
        
        $meshStart = $SceneEditor.MapArray[(GetMeshStart) + 5] * 65536 + $SceneEditor.MapArray[(GetMeshStart) + 6]  * 256 + $SceneEditor.MapArray[(GetMeshStart) + 7]
        $meshEnd   = $SceneEditor.MapArray[(GetMeshStart) + 9] * 65536 + $SceneEditor.MapArray[(GetMeshStart) + 10] * 256 + $SceneEditor.MapArray[(GetMeshStart) + 11]
        $meshes    = @()

        for ($i=$meshStart; $i -lt $meshEnd; $i+= 4) {
            if ($SceneEditor.MapArray[$i] -eq 3) {
                $value =  $SceneEditor.MapArray[$i+1] * 65536 + $SceneEditor.MapArray[$i+2] * 256 + $SceneEditor.MapArray[$i+3]
                if ($value -gt $SceneEditor.Offsets[$SceneEditor.Offsets.Header.Count-1].Header -and $value -le $SceneEditor.MapArray.Count) {
                    $meshes += $SceneEditor.MapArray[$i+1] * 65536 + $SceneEditor.MapArray[$i+2] * 256 + $SceneEditor.MapArray[$i+3]
                }
            }
        }

        $meshes = $meshes | Sort-Object
        if ($meshes.count -gt 0) {
            for ($i=$meshes[0]; $i -lt $meshes[0]+512; $i+=4) {
                if ($SceneEditor.MapArray[$i] -eq 3) { $vtx = $SceneEditor.MapArray[$i+1] * 65536 + $SceneEditor.MapArray[$i+2] * 256 + $SceneEditor.MapArray[$i+3]; break }
            }

            for ($i=$SceneEditor.Offsets[$SceneEditor.Offsets.Header.Count-1].HeaderEnd; $i -lt $vtx; $i+=8) {
                if ($SceneEditor.MapArray[$i] -eq 0xD7 -and $SceneEditor.MapArray[$i+1] -eq 0 -and $SceneEditor.MapArray[$i+2] -eq 0 -and $SceneEditor.MapArray[$i+3] -eq 2 -and $SceneEditor.MapArray[$i+4] -eq 0xFF -and $SceneEditor.MapArray[$i+5] -eq 0xFF -and $SceneEditor.MapArray[$i+6] -eq 0xFF -and $SceneEditor.MapArray[$i+7] -eq 0xFF) {
                    $vtx = $i; break
                }
            }

            for ($i=$vtx; $i -lt $SceneEditor.MapArray.Count; $i+=8) {
                if ($SceneEditor.MapArray[$i] -eq 0xFD -and $SceneEditor.MapArray[$i+4] -eq 2) {
                    $value = $SceneEditor.MapArray[$i+5] * 65536 + $SceneEditor.MapArray[$i+6] * 256 + $SceneEditor.MapArray[$i+7]
                    if ($value -gt $SceneEditor.SceneOffsets[0].CollisionStart -and $value -gt $SceneEditor.Offsets[$SceneEditor.Offsets.Header.Count-1].Header -and $value -gt $SceneEditor.Offsets[$SceneEditor.Offsets.Header.Count-1].MeshStart -and $value -lt $SceneEditor.SceneArray.Count) { ShiftMap -Offset ($i+5) -Shift $Shift }
                }
            }
        }

        [System.IO.File]::WriteAllBytes(($Paths.Temp + "\scene\room_" + $SceneEditor.LoadedMap + ".zmap"), $SceneEditor.MapArray)
    }

    ShiftCutscenesTable -Shift $Shift
    ShiftTexturesTable  -Shift $Shift
    ShiftActors         -Shift $Shift
    if ($Files.json.sceneEditor.parse -eq "oot") { ChangeBytes -File ($Paths.Temp + "\scene\scenes.tbl") -Offset (7 + 20 * (GetDecimal $SceneEditor.LoadedScene.id)) -Values $Shift -Add -Silent }
    
    $SceneEditor.LoadedMap   = $originalMap
    LoadMap

}



#==============================================================================================================================================================================================
function InsertSpawnPoint([int]$X=0, [int]$Y=0, [int]$Z=0, [uint16]$XRot=0, [uint16]$YRot=0, [uint16]$ZRot=0, [string]$Param="0000") {
    
    if ((GetPositionCount) -eq $null)   { WriteToConsole "No spawn point list defined for this header"       -Error; return $False }
    if ((GetPositionCount) -ge 255)     { WriteToConsole "Reached the max spawn point limit for this header" -Error; return $False }

    # Set 16 bytes of actor data
    $values = @(0, 0)

    if ($X -lt 0) { $X += 0x10000 }
    $values += $X -shr 8
    $values += $X % 0x100

    if ($Y -lt 0) { $Y += 0x10000 }
    $values += $Y -shr 8
    $values += $Y % 0x100

    if ($Z -lt 0) { $Z += 0x10000 }
    $values += $Z -shr 8
    $values += $Z % 0x100

    $values += $XRot -shr 8
    $values += $XRot % 0x100
    $values += $YRot -shr 8
    $values += $YRot % 0x100
    $values += $ZRot -shr 8
    $values += $ZRot % 0x100

    $values += $Param -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 0x10) }

    $SceneEditor.SceneArray.InsertRange((GetPositionEnd), $values)
    $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].PositionCount++
    $SceneEditor.SceneArray[(GetPositionCountIndex)]++

    $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].MapStart          += 0x10
    ShiftScene -Offset (GetMapIndex)                 -Shift 0x10

    $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].EntranceStart     += 0x10
    ShiftScene -Offset (GetEntranceIndex)            -Shift 0x10

    $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].LightningStart    += 0x10
    ShiftScene -Offset (GetLightningIndex)           -Shift 0x10

    if (GetFoundPaths) {
        $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].PathStart     += 0x10
        ShiftScene -Offset (GetPathIndex)            -Shift 0x10
        $path = GetPathStart
        while ($SceneEditor.SceneArray[$path] -gt 1 -and $SceneEditor.SceneArray[$path] -lt 0x80 -and $SceneEditor.SceneArray[$path+1] -eq 0 -and $SceneEditor.SceneArray[$path+2] -eq 0 -and $SceneEditor.SceneArray[$path+3] -eq 0) {
            ShiftScene -Offset ($path + 5)           -Shift 0x10
            if ($SceneEditor.SceneArray[$path+8] -gt 1 -and $SceneEditor.SceneArray[$path+8] -lt 0x80 -and $SceneEditor.SceneArray[$path+9] -eq 0 -and $SceneEditor.SceneArray[$path+10] -eq 0 -and $SceneEditor.SceneArray[$path+11] -eq 0 -and $SceneEditor.SceneArray[$path+12] -eq 2) { $path += 8 }
            else { $path += $SceneEditor.SceneArray[$path] * 6 }
        }
    }

    if (GetFoundTransitionActors) {
        $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].ActorStart    += 0x10
        ShiftScene -Offset (GetTransitionActorIndex) -Shift 0x10
    }

    if (GetFoundExits) {
        $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].ExitStart     += 0x10
        ShiftScene -Offset (GetExitIndex)            -Shift 0x10
    }

    if (GetFoundCutscenes) {
        $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].CutsceneStart += 0x10
        ShiftScene -Offset (GetCutsceneIndex)        -Shift 0x10
    }

    if ($SceneEditor.LoadedHeader -eq 0) {
        $SceneEditor.SceneOffsets[0].CollisionStart                        += 0x10
        ShiftScene -Offset (GetCollisionIndex)       -Shift 0x10
    }

    if (IsSet $SceneEditor.SceneOffsets[0].AlternateStart) {
        for ($i=$SceneEditor.SceneOffsets[0].AlternateStart; $i-lt $SceneEditor.SceneOffsets[0].PositionStart; $i+= 4) {
            if ($SceneEditor.SceneArray[$i] -ne 2) { continue }
            $value = $SceneEditor.SceneArray[$i+1] * 65536 + $SceneEditor.SceneArray[$i+2] * 256 + $SceneEditor.SceneArray[$i+3]
            if ($value -gt (GetSceneHeader)) { ShiftScene -Offset ($i+1) -Shift 0x10 }
        }
    }

    $shift  = 0x10 + (InsertEntrance)
    ShiftSceneHeaderData -Shift $shift

    WriteToConsole ("Inserted spawn point:    " + (GetPositionCount) )
    return $True

}



#==============================================================================================================================================================================================
function InsertEntrance() {
    
    if ((GetEntranceStart) -eq $null) { WriteToConsole "No entrance list defined for this header" -Error; return 0 }

    if ( (GetExitStart) -gt (GetEntranceStart) ) { $end = GetExitStart } else { $end = GetLightningStart } 
    for ($i=(GetEntranceEnd)-2; $i -lt $end; $i+=2) {
        if ($SceneEditor.SceneArray[$i] -eq 0 -and $SceneEditor.SceneArray[$i + 1] -eq 0) {
            $SceneEditor.SceneArray[$i]     = (GetPositionCount) - 1
            $SceneEditor.SceneArray[$i + 1] = $SceneEditor.LoadedMap
            return 0
        }
    }

    $values = @(((GetPositionCount) - 1), $SceneEditor.LoadedMap, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    $SceneEditor.SceneArray.InsertRange((GetEntranceEnd)-2, $values)
        
    $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].LightningStart    += 0x10
    ShiftScene -Offset (GetLightningIndex)      -Shift 0x10

    if (GetFoundPaths) {
        $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].PathStart     += 0x10
        ShiftScene -Offset (GetPathIndex)       -Shift 0x10
        $path = GetPathStart
        while ($SceneEditor.SceneArray[$path] -gt 1 -and $SceneEditor.SceneArray[$path] -lt 0x80 -and $SceneEditor.SceneArray[$path+1] -eq 0 -and $SceneEditor.SceneArray[$path+2] -eq 0 -and $SceneEditor.SceneArray[$path+3] -eq 0) {
            ShiftScene -Offset ($path + 5)     -Shift 0x10
            if ($SceneEditor.SceneArray[$path+8] -gt 1 -and $SceneEditor.SceneArray[$path+8] -lt 0x80 -and $SceneEditor.SceneArray[$path+9] -eq 0 -and $SceneEditor.SceneArray[$path+10] -eq 0 -and $SceneEditor.SceneArray[$path+11] -eq 0 -and $SceneEditor.SceneArray[$path+12] -eq 2) { $path += 8 }
            else { $path += $SceneEditor.SceneArray[$path] * 6 }
        }
    }

    if (GetFoundExits) {
        $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].ExitStart     += 0x10
        ShiftScene -Offset (GetExitIndex)      -Shift 0x10
    }

    if (GetFoundCutscenes) {
        $SceneEditor.SceneOffsets[$SceneEditor.LoadedHeader].CutsceneStart += 0x10
        ShiftScene -Offset (GetCutsceneIndex)  -Shift 0x10
    }

    if ($SceneEditor.LoadedHeader -eq 0) {
        $SceneEditor.SceneOffsets[0].CollisionStart                        += 0x10
        ShiftScene -Offset (GetCollisionIndex) -Shift 0x10
    }

    if (IsSet $SceneEditor.SceneOffsets[0].AlternateStart) {
        for ($i=$SceneEditor.SceneOffsets[0].AlternateStart; $i-lt $SceneEditor.SceneOffsets[0].PositionStart; $i+= 4) {
            if ($SceneEditor.SceneArray[$i] -ne 2) { continue }
            $value = $SceneEditor.SceneArray[$i+1] * 65536 + $SceneEditor.SceneArray[$i+2] * 256 + $SceneEditor.SceneArray[$i+3]
            if ($value -gt (GetSceneHeader)) { ShiftScene -Offset ($i+1) -Shift 0x10 }
        }
    }

    return 0x10

}



#==============================================================================================================================================================================================
function DeleteActor() {
    
    if ((GetActorCount) -eq $null)   { WriteToConsole "No actor list defined for this header"    -Error; return $False }
    if ((GetActorCount) -eq 0)       { WriteToConsole "No actors left to remove for this header" -Error; return $False }

    $SceneEditor.Offsets[$SceneEditor.LoadedHeader].ActorCount--
    $SceneEditor.MapArray[(GetActorCountIndex)]--
    $SceneEditor.MapArray.RemoveRange((GetActorEnd), 0x10)
    ShiftMapHeaderData -Shift (-0x10)

    if ($SceneEditor.GUI) {
        $SceneEditor.Tab = $null
        LoadTab -Tab 1
    }

     return $True

}

#==============================================================================================================================================================================================
function InsertActor([string]$ID="0000", [string]$Name, [int]$X=0, [int]$Y=0, [int]$Z=0, [uint16]$XRot=0, [uint16]$YRot=0, [uint16]$ZRot=0, [switch]$NoXRot, [switch]$NoYRot, [switch]$NoZRot, [string]$Param="0000", [boolean[]]$SpawnTimes=@(1, 1, 1, 1, 1, 1, 1, 1, 1, 1), [byte]$SceneCommand=0x7F) {
    
    if ((GetActorCount) -eq $null)   { WriteToConsole "No actor list defined for this header"       -Error; return $False }
    if ((GetActorCount) -ge 255)     { WriteToConsole "Reached the max actor limit for this header" -Error; return $False }

    if (IsSet $Name) {
        $ID = ""
        foreach ($actor in $Files.json.sceneEditor.actors) {
            if ($actor.name -eq $Name) {
                $ID = $actor.id
                break
            }
        }
        if ($ID -eq "") {
            WriteToConsole "Actor ID by name is not found" -Error
            return $False
        }
    }

    # Set 16 bytes of actor data
    $values = $ID -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 0x10) }

    if ($X -lt 0) { $X += 0x10000 }
    $values += $X -shr 8
    $values += $X % 0x100

    if ($Y -lt 0) { $Y += 0x10000 }
    $values += $Y -shr 8
    $values += $Y % 0x100

    if ($Z -lt 0) { $Z += 0x10000 }
    $values += $Z -shr 8
    $values += $Z % 0x100

    if ($Files.json.sceneEditor.game -eq "Majora's Mask") {
        $arr = @(0, 0, 0)
        if ($SpawnTimes[7])    { $arr[0] = 1 }
        if ($SpawnTimes[8])    { $arr[1] = 1 }
        if ($SpawnTimes[9])    { $arr[2] = 1 }
        if ($XRot -gt 0x1FF)   { $XRot = 0x1FF }
        $XRot    = $arr[0] + ($arr[1] -shl 1) + ($arr[2] -shl 2) + ($XRot -shl 7)
        $values += $XRot -shr 8
        $values += $XRot % 0x100
        
        if ($SceneCommand -gt 0x7F)    { $SceneCommand = 0x7F  }
        if ($YRot         -gt 0x1FF)   { $YRot         = 0x1FF }
        $YRot    = $SceneCommand + ($YRot -shl 7)
        $values += $YRot -shr 8
        $values += $YRot % 0x100

        $arr = @(0, 0, 0, 0, 0, 0, 0)
        if ($SpawnTimes[0])    { $arr[0] = 1 }
        if ($SpawnTimes[1])    { $arr[1] = 1 }
        if ($SpawnTimes[2])    { $arr[2] = 1 }
        if ($SpawnTimes[3])    { $arr[3] = 1 }
        if ($SpawnTimes[4])    { $arr[4] = 1 }
        if ($SpawnTimes[5])    { $arr[5] = 1 }
        if ($SpawnTimes[6])    { $arr[6] = 1 }
        if ($ZRot -gt 0x1FF)   { $ZRot = 0x1FF }
        $ZRot    = $arr[0] + ($arr[1] -shl 1) + ($arr[2] -shl 2) + ($arr[3] -shl 3) + ($arr[4] -shl 4) + ($arr[5] -shl 5) + ($arr[6] -shl 6) + ($ZRot -shl 7)
        $values += $ZRot -shr 8
        $values += $ZRot % 0x100
    }
    else {
        $values += $XRot -shr 8
        $values += $XRot % 0x100
        $values += $YRot -shr 8
        $values += $YRot % 0x100
        $values += $ZRot -shr 8
        $values += $ZRot % 0x100
    }

    $values += $Param -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 0x10) }

    if ($Files.json.sceneEditor.game -eq "Majora's Mask") {
        if ($NoXRot)   { $values[0] += 0x40 }
        if ($NoYRot)   { $values[0] += 0x80 }
        if ($NoZRot)   { $values[0] += 0x20 }
    }
    
    $SceneEditor.MapArray.InsertRange((GetActorEnd), $values)
    $SceneEditor.Offsets[$SceneEditor.LoadedHeader].ActorCount++
    $SceneEditor.MapArray[(GetActorCountIndex)]++
    ShiftMapHeaderData -Shift 0x10
    
    if ($SceneEditor.GUI) {
        $SceneEditor.Tab = $null
        LoadTab -Tab 1
    }

    if (IsSet $Name) { WriteToConsole ("Inserted actor:          " + $Name) } else { WriteToConsole ("Inserted actor with ID:  " + $ID) }

    return $True

}



#==============================================================================================================================================================================================
function ReplaceActor($Index, $ID=$null, $Name, $NewID, $New, $X, $Y, $Z, $XRot, $YRot, $ZRot, [switch]$NoXRot, [switch]$NoYRot, [switch]$NoZRot, $Compare, $CompareX, $CompareY, $CompareZ, $Param) {
    
    if ((GetActorCount) -eq $null) { WriteToConsole "No actor list defined for this header" -Error; return $False }

    $offset  = $null
    $printID = $ID

    if ($Compare -is [string]) {
        if ($Compare.length -ne 4) {
            WriteToConsole "Parameter compare value is not a valid 16-bit hexadecimal length" -Error
            return $False
        }
        if ((GetDecimal $Compare) -eq -1) {
            WriteToConsole "Parameter compare value is not valid hexadecimal value" -Error
            return $False
        }
    }

    if ($Param -is [string]) {
        if ($Param.length -ne 4) {
            WriteToConsole "Parameter replacement value is not a valid 16-bit hexadecimal length" -Error
            return $False
        }
        if ((GetDecimal $Param) -eq -1) {
            WriteToConsole "Parameter replacement value is not valid hexadecimal value" -Error
            return $False
        }
    }

    if ($Index -is [int]) {
        if ($Index -lt 0 -or $Index -ge (GetActorCount)) { WriteToConsole "Actor index is out of range" -Error; return $False }
        $offset = (GetActorStart) + $Index * 0x10
    }
    elseif ($Name -is [string] -or $ID -is [string]) {
        if ($Name -is [string]) {
            foreach ($actor in $Files.json.sceneEditor.actors) {
                if ($actor.name -eq $Name) {
                    $ID = $actor.id
                    break
                }
            }
        }

        if ($ID -eq $null) {
            WriteToConsole "No actor ID is set" -Error
            return $False
        }

        if ($ID.length -ne 4) {
            WriteToConsole "Actor ID is not a valid 16-bit hexadecimal length" -Error
            return $False
        }

        $val = GetDecimal $ID
        if ($val -eq -1) {
            WriteToConsole "Actor ID is not valid hexadecimal value" -Error
            return $False
        }

        $compP = SplitCompare $Compare
        $compX = SplitCompare $CompareX
        $compY = SplitCompare $CompareY
        $compZ = SplitCompare $CompareZ

        for ($i=(GetActorStart); $i -lt (GetActorEnd); $i+=0x10) {
            if ( ( ($SceneEditor.MapArray[$i] * 256 + $SceneEditor.MapArray[$i+1]) -band 4095) -eq $val) {
                if ($compP -is [array])   { if ($SceneEditor.MapArray[$i+14] -ne $compP[0] -or $SceneEditor.MapArray[$i+15] -ne $compP[1])   { continue } }
                if ($compX -is [array])   { if ($SceneEditor.MapArray[$i+2]  -ne $compX[0] -or $SceneEditor.MapArray[$i+3]  -ne $compX[1])   { continue } }
                if ($compY -is [array])   { if ($SceneEditor.MapArray[$i+4]  -ne $compY[0] -or $SceneEditor.MapArray[$i+5]  -ne $compY[1])   { continue } }
                if ($compZ -is [array])   { if ($SceneEditor.MapArray[$i+6]  -ne $compZ[0] -or $SceneEditor.MapArray[$i+7]  -ne $compZ[1])   { continue } }

                $offset = $i
                break
            }
        }
    }

    if ($offset -eq $null) {
        if     ($Index -ne $null)   { WriteToConsole ("Actor based on entry index: " + $Index   + " could not be found") -Error }
        elseif ($Name  -ne $null)   { WriteToConsole ("Actor based on name: "        + $Name    + " could not be found") -Error }
        elseif ($ID    -ne $null)   { WriteToConsole ("Actor based on ID: "          + $printID + " could not be found") -Error }
        else                        { WriteToConsole  "Actor could not be found."                                        -Error }
        return $False
    }

    if ($New -is [string]) {
        $newID = $null
        foreach ($actor in $Files.json.sceneEditor.actors) {
            if ($actor.name -eq $New) {
                $NewID = $actor.id
                break
            }
        }
        if ($NewID -eq $null) {
            WriteToConsole "Actor ID replacement by name is not found" -Error
            return $False
        }
    }

    if ($NewID -is [string]) {
        if ($NewID.length -ne 4) {
            WriteToConsole "Actor ID replacement is not a valid 16-bit hexadecimal length" -Error
            return $False
        }

        if ((GetDecimal $NewID) -eq -1) {
            WriteToConsole "Actor ID replacement is not valid hexadecimal value" -Error
            return $False
        }

        $val = $NewID -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 0x10) }
        if ($Files.json.sceneEditor.game -eq "Majora's Mask") {
            if ($NoXRot)   { $val[0] += 0x40 }
            if ($NoYRot)   { $val[0] += 0x80 }
            if ($NoZRot)   { $val[0] += 0x20 }
        }
        $SceneEditor.MapArray[$offset+0]  = $val[0]
        $SceneEditor.MapArray[$offset+1]  = $val[1]
    }

    if ($X -is [int] -and $X -ge -32768 -and $X -le 32767) {
        if ($X -lt 0) { $X += 0x10000 }
        $SceneEditor.MapArray[$offset+2]  = $X -shr 8
        $SceneEditor.MapArray[$offset+3]  = $X % 0x100
    }

    if ($Y -is [int] -and $Y -ge -32768 -and $Y -le 32767) {
        if ($Y -lt 0) { $Y += 0x10000 }
        $SceneEditor.MapArray[$offset+4]  = $Y -shr 8
        $SceneEditor.MapArray[$offset+5]  = $Y % 0x100
    }

    if ($Z -is [int] -and $Z -ge -32768 -and $Z -le 32767) {
        if ($Z -lt 0) { $Z += 0x10000 }
        $SceneEditor.MapArray[$offset+6]  = $Z -shr 8
        $SceneEditor.MapArray[$offset+7]  = $Z % 0x100
    }

    if ($XRot -is [int] -and $XRot -ge 0 -and $XRot -le 0xFFFF) {
        $SceneEditor.MapArray[$offset+8]  = $XRot -shr 8
        $SceneEditor.MapArray[$offset+9]  = $XRot % 0x100
    }

    if ($YRot -is [int] -and $YRot -ge 0 -and $YRot -le 0xFFFF) {
        $SceneEditor.MapArray[$offset+10] = $YRot -shr 8
        $SceneEditor.MapArray[$offset+11] = $YRot % 0x100
    }

    if ($ZRot -is [int] -and $ZRot -ge 0 -and $ZRot -le 0xFFFF) {
        $SceneEditor.MapArray[$offset+12] = $ZRot -shr 8
        $SceneEditor.MapArray[$offset+13] = $ZRot % 0x100
    }

    if ($Param -is [string]) {
        $val = $Param -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 0x10) }
        $SceneEditor.MapArray[$offset+14] = $val[0]
        $SceneEditor.MapArray[$offset+15] = $val[1]
    }

    if     ($Index -is [int])      { WriteToConsole ("Replaced actor entry:    " + $Index)   }
    elseif ($Name  -is [string])   { WriteToConsole ("Replaced actor:          " + $Name)    }
    elseif ($ID    -is [string])   { WriteToConsole ("Replaced actor with ID:  " + $printID) }
    else                           { WriteToConsole  "Replaced actor"                        }

    return $True

}



#==============================================================================================================================================================================================
function RemoveActor($Index, $ID, $Name, $Compare, $CompareX, $CompareY, $CompareZ) {
    
    if ((GetActorCount) -eq $null)   { WriteToConsole "No actor list defined for this header"    -Error; return $False }
    if ((GetActorCount) -eq 0)       { WriteToConsole "No actors left to remove for this header" -Error; return $False }

    $printID = $ID

    if ($Compare -is [string]) {
        if ($Compare.length -ne 4) {
            WriteToConsole "Parameter compare value is not a valid 16-bit hexadecimal length" -Error
            return $False
        }
        if ((GetDecimal $Compare) -eq -1) {
            WriteToConsole "Parameter compare value is not valid hexadecimal value" -Error
            return $False
        }
    }

    if ($Index -is [int]) {
        if ($Index -lt 0 -or $Index -ge (GetActorCount)) { WriteToConsole "Actor index is out of range" -Error; return $False }
    }
    elseif ($Name -is [string] -or $ID -is [string]) {
        if ($Name -is [string]) {
            foreach ($actor in $Files.json.sceneEditor.actors) {
                if ($actor.name -eq $Name) {
                    $ID = $actor.id
                    break
                }
            }
        }

        if ($ID -eq $null) {
            WriteToConsole "No actor ID is set" -Error
            return $False
        }

        if ($ID.length -ne 4) {
            WriteToConsole "Actor ID is not a valid 16-bit hexadecimal length" -Error
            return $False
        }

        $val = GetDecimal $ID
        if ($val -eq -1) {
            WriteToConsole "Actor ID is not valid hexadecimal value" -Error
            return $False
        }

        $compP = SplitCompare $Compare
        $compX = SplitCompare $CompareX
        $compY = SplitCompare $CompareY
        $compZ = SplitCompare $CompareZ
        $Index = 0;

        for ($i=(GetActorStart); $i -lt (GetActorEnd); $i+=0x10) {
            if ( ( ($SceneEditor.MapArray[$i] * 256 + $SceneEditor.MapArray[$i+1]) -band 4095) -eq $val) {
                if ($compP -is [array])   { if ($SceneEditor.MapArray[$i+14] -ne $compP[0] -or $SceneEditor.MapArray[$i+15] -ne $compP[1])   { $Index++; continue } }
                if ($compX -is [array])   { if ($SceneEditor.MapArray[$i+2]  -ne $compX[0] -or $SceneEditor.MapArray[$i+3]  -ne $compX[1])   { $Index++; continue } }
                if ($compY -is [array])   { if ($SceneEditor.MapArray[$i+4]  -ne $compY[0] -or $SceneEditor.MapArray[$i+5]  -ne $compY[1])   { $Index++; continue } }
                if ($compZ -is [array])   { if ($SceneEditor.MapArray[$i+6]  -ne $compZ[0] -or $SceneEditor.MapArray[$i+7]  -ne $compZ[1])   { $Index++; continue } }
                break
            }
            $Index++
        }
    }
    else { WriteToConsole  "Actor could not be found." -Error; return $False }

    if ($Index -ne (GetActorCount) - 1) {
        for ($i=$Index; $i -lt (GetActorCount); $i++) {
            for ($j=0; $j -lt 0x10; $j++) { $SceneEditor.MapArray[(GetActorStart) + 0x10 * $i + $j] = $SceneEditor.MapArray[(GetActorStart) + 0x10 * $i + $j + 0x10] }
        }
    }
    DeleteActor

    if     ($Index -is [int])      { WriteToConsole ("Removed actor entry:     " + $Index)   }
    elseif ($Name  -is [string])   { WriteToConsole ("Removed actor:           " + $Name)    }
    elseif ($ID    -is [string])   { WriteToConsole ("Removed actor with ID:   " + $printID) }
    else                           { WriteToConsole  "Removed actor"                         }

    return $True

}



#==============================================================================================================================================================================================
function SplitCompare($Compare) {
    
    if ($Compare -is [string]) { return $Compare -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 0x10) }  }
    if ($Compare -is [int] -and $Compare -ge -32768 -and $Compare -le 32767) {
        if ($Compare -lt 0) { $Compare += 0x10000 }
        $comp    = @(0, 0)
        $comp[0] = $Compare -shr 8
        $comp[1] = $Compare % 0x100
        return $comp
    }

}



#==============================================================================================================================================================================================
function ReplaceTransitionActor($Index, $ID, $Name, $NewID, $New, $X, $Y, $Z, $YRot, $MapFront, $MapBack, $CamFront, $CamBack, $Compare, $CompareX, $CompareY, $CompareZ, $Param) {
    
    if ((GetTransitionActorCount) -eq $null) {
        WriteToConsole "No transition actor list defined for this header" -Error
        return $False
    }

    $offset  = $null
    $printID = $ID

    if ($Compare -is [string]) {
        if ($Compare.length -ne 4) {
            WriteToConsole "Parameter compare value is not a valid 16-bit hexadecimal length" -Error
            return $False
        }
        if ((GetDecimal $Compare) -eq -1) {
            WriteToConsole "Parameter compare value is not valid hexadecimal value" -Error
            return $False
        }
    }

    if ($Param -is [string]) {
        if ($Param.length -ne 4) {
            WriteToConsole "Parameter replacement value is not a valid 16-bit hexadecimal length" -Error
            return $False
        }
        if ((GetDecimal $Param) -eq -1) {
            WriteToConsole "Parameter replacement value is not valid hexadecimal value" -Error
            return $False
        }
    }

    if ($Index -is [int]) {
        if ($Index -lt 0 -or $Index -gt (GetTransitionActorCount)) {
            WriteToConsole "Transition Actor index is out of range" -Error
            return $False
        }
        $offset = (GetTransitionActorStart) + $Index * 0x10

        if ($Compare -is [string]) {
            $comp = $Compare -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 0x10) }
            if ($SceneEditor.SceneArray[$offset+14] -ne $comp[0] -and $SceneEditor.SceneArray[$offset+15] -ne $comp[1]) { return $False }
        }
    }
    elseif ($Name -is [string] -or $ID -is [string]) {
        if ($Name -is [string]) {
            foreach ($actor in $Files.json.sceneEditor.transitions) {
                if ($actor.name -eq $Name) {
                    $ID = $actor.id
                    break
                }
            }
        }

        if ($ID -eq $null) {
            WriteToConsole "No transition actor ID is set" -Error
            return $False
        }

        if ($ID.length -ne 4) {
            WriteToConsole "Transition actor ID is not a valid 16-bit hexadecimal length" -Error
            return $False
        }

        $val = GetDecimal $ID
        if ($val -eq -1) {
            WriteToConsole "Transition actor ID is not valid hexadecimal value" -Error
            return $False
        }

        if ($Compare -is [string]) { $compP = $Compare -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 0x10) }  }
        if ($CompareX -is [int] -and $CompareX -ge -32768 -and $CompareX -le 32767) {
            if ($CompareX -lt 0) { $CompareX += 0x10000 }
            $compX    = @(0, 0)
            $compX[0] = $CompareX -shr 8
            $compX[1] = $CompareX % 0x100
        }
        if ($CompareY -is [int] -and $CompareY -ge -32768 -and $CompareY -le 32767) {
            if ($CompareY -lt 0) { $CompareY += 0x10000 }
            $compY    = @(0, 0)
            $compY[0] = $CompareY -shr 8
            $compY[1] = $CompareY % 0x100
        }
        if ($CompareZ -is [int] -and $CompareZ -ge -32768 -and $CompareZ -le 32767) {
            if ($CompareZ -lt 0) { $CompareZ += 0x10000 }
            $compZ    = @(0, 0)
            $compZ[0] = $CompareZ -shr 8
            $compZ[1] = $CompareZ % 0x100
        }

        for ($i=(GetTransitionActorStart); $i -lt (GetTransitionActorEnd); $i+=0x10) {
            if ( ( ($SceneEditor.SceneArray[$i+4] * 256 + $SceneEditor.SceneArray[$i+5]) -band 4095) -eq $val) {
                if ($compP -is [array])   { if ($SceneEditor.SceneArray[$i+14] -ne $compP[0] -or $SceneEditor.SceneArray[$i+15] -ne $compP[1])   { continue } }
                if ($compX -is [array])   { if ($SceneEditor.SceneArray[$i+2]  -ne $compX[0] -or $SceneEditor.SceneArray[$i+3]  -ne $compX[1])   { continue } }
                if ($compY -is [array])   { if ($SceneEditor.SceneArray[$i+4]  -ne $compY[0] -or $SceneEditor.SceneArray[$i+5]  -ne $compY[1])   { continue } }
                if ($compZ -is [array])   { if ($SceneEditor.SceneArray[$i+6]  -ne $compZ[0] -or $SceneEditor.SceneArray[$i+7]  -ne $compZ[1])   { continue } }

                $offset = $i
                break
            }
        }
    }

    if ($offset -eq $null) {
        if     ($Index -ne $null)   { WriteToConsole ("Transition actor based on entry index: " + $Index   + " could not be found") -Error }
        elseif ($Name  -ne $null)   { WriteToConsole ("Transition actor based on name: "        + $Name    + " could not be found") -Error }
        elseif ($ID    -ne $null)   { WriteToConsole ("Transition actor based on ID: "          + $printID + " could not be found") -Error }
        else                        { WriteToConsole  "Transition actor could not be found."                                        -Error }
        return $False
    }

    if ($New -is [string]) {
        foreach ($actor in $Files.json.sceneEditor.transitions) {
            if ($actor.name -eq $New) {
                $NewID = $actor.id
                break
            }
        }
    }

    if ($MapFront -is [int] -and $MapFront -ge 0 -and $MapFront -le 0xFF)   { $SceneEditor.SceneArray[$offset]   = $MapFront }
    if ($CamFront -is [int] -and $CamFront -ge 0 -and $CamFront -le 0xFF)   { $SceneEditor.SceneArray[$offset+1] = $CamFront }
    if ($MapBack  -is [int] -and $MapBack  -ge 0 -and $MapBack  -le 0xFF)   { $SceneEditor.SceneArray[$offset+2] = $MapBack  }
    if ($CamBack  -is [int] -and $CamBack  -ge 0 -and $CamBack  -le 0xFF)   { $SceneEditor.SceneArray[$offset+3] = $CamBack  }

    if ($NewID -is [string]) {
        if ($NewID.length -ne 4) {
            WriteToConsole "Transition actor ID replacement is not a valid 16-bit hexadecimal length" -Error
            return $False
        }

        if ((GetDecimal $NewID) -eq -1) {
            WriteToConsole "Transition actor ID replacement is not valid hexadecimal value" -Error
            return $False
        }

        $val = $NewID -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 0x10) }
        $SceneEditor.SceneArray[$offset+4]  = $val[0]
        $SceneEditor.SceneArray[$offset+5]  = $val[1]
    }

    if ($X -is [int] -and $X -ge -32768 -and $X -le 32767) {
        if ($X -lt 0) { $X += 0x10000 }
        $SceneEditor.SceneArray[$offset+6]  = $X -shr 8
        $SceneEditor.SceneArray[$offset+7]  = $X % 0x100
    }

    if ($Y -is [int] -and $Y -ge -32768 -and $Y -le 32767) {
        if ($Y -lt 0) { $Y += 0x10000 }
        $SceneEditor.SceneArray[$offset+8]  = $Y -shr 8
        $SceneEditor.SceneArray[$offset+9]  = $Y % 0x100
    }

    if ($Z -is [int] -and $Z -ge -32768 -and $Z -le 32767) {
        if ($Z -lt 0) { $Z += 0x10000 }
        $SceneEditor.SceneArray[$offset+10] = $Z -shr 8
        $SceneEditor.SceneArray[$offset+11] = $Z % 0x100
    }

    if ($YRot -is [int] -and $YRot -ge -32768 -and $YRot -le 32767) {
        if ($YRot -lt 0) { $YRot += 0x10000 }
        $SceneEditor.SceneArray[$offset+12] = $YRot -shr 8
        $SceneEditor.SceneArray[$offset+13] = $YRot % 0x100
    }

    if ($Param -is [string]) {
        $val = $Param -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 0x10) }
        $SceneEditor.SceneArray[$offset+14] = $val[0]
        $SceneEditor.SceneArray[$offset+15] = $val[1]
    }

    if     ($Index -is [int])      { WriteToConsole ("Replaced transition actor entry: "   + $Index)   }
    elseif ($Name  -is [string])   { WriteToConsole ("Replaced transition actor: "         + $Name)    }
    elseif ($ID    -is [string])   { WriteToConsole ("Replaced transition actor with ID: " + $printID) }
    else                           { WriteToConsole  "Replaced transition actor"                       }

    return $True

}



#==============================================================================================================================================================================================
function DeleteObject() {
    
    if ((GetObjectCount) -eq $null)   { WriteToConsole "No object list defined for this header" -Error; return $False }
    if ((GetObjectCount) -eq 0)       { return $False }
    
    $SceneEditor.Offsets[$SceneEditor.LoadedHeader].ObjectCount--
    $SceneEditor.MapArray[(GetObjectCountIndex)]--
    if ($SceneEditor.GUI) {
        $SceneEditor.BottomPanelObjects.AutoScroll = $False
        $SceneEditor.BottomPanelObjects.Controls.Remove($SceneEditor.Objects[$SceneEditor.Objects.Count-1].Panel)
        $SceneEditor.Objects.RemoveAt($SceneEditor.Objects.Count-1)
    }
    $SceneEditor.MapArray[(GetObjectEnd)] = $SceneEditor.MapArray[(GetObjectEnd)+1] = 0

    if ($SceneEditor.GUI) {
        $SceneEditor.BottomPanelObjects.AutoScroll        = $True
        $SceneEditor.BottomPanelObjects.AutoScrollMargin  = New-Object System.Drawing.Size(0, 0)
        $SceneEditor.BottomPanelObjects.AutoScrollMinSize = New-Object System.Drawing.Size(0, 0)
    }

    return $True

}



#==============================================================================================================================================================================================
function InsertObject([string]$ID="0000", [string]$Name) {
    
    if ((GetObjectCount) -eq $null)                                 { WriteToConsole "No object list defined for this header"       -Error; return $False }
    if ((GetObjectCount) -ge $Files.json.sceneEditor.max_objects)   { WriteToConsole "Reached the max object limit for this header" -Error; return $False }
    if ($SceneEditor.GUI)                                           { $SceneEditor.BottomPanelObjects.AutoScroll = $False }

    $printID = $ID

    if (IsSet $Name) {
        $ID = ""
        foreach ($obj in $Files.json.sceneEditor.objects) {
            if ($obj.name -eq $Name) {
                $ID = $obj.id
                break
            }
        }
        if ($ID -eq "") {
            WriteToConsole "Object ID by name is not found" -Error
            return $False
        }
    }

    if ( (GetObjectCount) % 4 -eq 0 -and (GetActorStart) -eq $null) {
        if (IsSet $Name)   { WriteToConsole ("Failed inserting object: " + $Name + " (missing actor list)") -Error }
        else               { WriteToConsole ("Failed inserting object: " + $ID   + " (missing actor list)") -Error }
        return $False
    }

    [byte[]]$ID = $ID -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 0x10) }
    $SceneEditor.Offsets[$SceneEditor.LoadedHeader].ObjectCount++
    $SceneEditor.MapArray[(GetObjectCountIndex)]++
    
    $end   = GetObjectEnd
    $start = GetActorStart

    if ( ($end -gt $start -and $start -gt 0) ) {
        $SceneEditor.MapArray.InsertRange((GetActorStart), @(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
        $SceneEditor.Offsets[$SceneEditor.LoadedHeader].ActorStart += 0x10
        ShiftMap -Offset (GetActorIndex) -Shift 0x10
        ShiftMapHeaderData -Shift 0x10
    }

    $SceneEditor.MapArray[(GetObjectEnd) - 2] = $ID[0]
    $SceneEditor.MapArray[(GetObjectEnd) - 1] = $ID[1]

    if ($SceneEditor.GUI) {
        AddObject
        $SceneEditor.BottomPanelObjects.AutoScroll        = $True
        $SceneEditor.BottomPanelObjects.AutoScrollMargin  = New-Object System.Drawing.Size(0, 0)
        $SceneEditor.BottomPanelObjects.AutoScrollMinSize = New-Object System.Drawing.Size(0, 0)
    }

    if (IsSet $Name) { WriteToConsole ("Inserted object:         " + $Name) } else { WriteToConsole ("Inserted object with ID: " + $printID) }

    return $True

}



#==============================================================================================================================================================================================
function ReplaceObject($Index, $ID, $Name, $NewID, $New) {
    
    if ((GetObjectCount) -eq $null) { WriteToConsole "No object list defined for this header" -Error; return $False }

    $offset  = $null
    $printID = $ID

    if ($Index -is [int]) {
        if ($Index -lt 0 -or $Index -ge (GetObjectCount)) { WriteToConsole "Object index is out of range" -Error; return $False }
        $offset = (GetObjectStart) + $Index * 2
    }
    elseif ($Name -is [string] -or $ID -is [string]) {
        if ($Name -is [string]) {
            foreach ($object in $Files.json.sceneEditor.objects) {
                if ($object.name -eq $Name) {
                    $ID = $object.id
                    break
                }
            }
        }

        if ($ID -eq $null) {
            WriteToConsole "Object ID is set" -Error
            return $False
        }

        if ($ID.length -ne 4) {
            WriteToConsole "Object ID is not a valid 16-bit hexadecimal length" -Error
            return $False
        }

        $val = GetDecimal $ID
        if ($val -eq -1) {
            WriteToConsole "Object ID is not valid hexadecimal value" -Error
            return $False
        }

        for ($i=(GetObjectStart); $i -lt (GetObjectEnd); $i+=2) {
            if ( ($SceneEditor.MapArray[$i] * 256 + $SceneEditor.MapArray[$i+1]) -eq $val) {
                $offset = $i
                break
            }
        }
    }

    if ($offset -eq $null) {
        if     ($Index -is [int])      { WriteToConsole ("Object based on entry index: " + $Index   + " could not be found") -Error }
        elseif ($Name  -is [string])   { WriteToConsole ("Object based on name: "        + $Name    + " could not be found") -Error }
        elseif ($ID    -is [string])   { WriteToConsole ("Object based on ID: "          + $printID + " could not be found") -Error }
        else                           { WriteToConsole  "Object could not be found"                                         -Error }
        return $False
    }

    if ($New -is [string]) {
        $NewID = $null
        foreach ($object in $Files.json.sceneEditor.objects) {
            if ($object.name -eq $New) {
                $NewID = $object.id
                break
            }
        }
        if ($NewID -eq $null) {
            WriteToConsole "Object replacement ID by name is not found" -Error
            return $False
        }
    }

    if ($NewID -is [string]) {
        if ($NewID.length -ne 4) {
            WriteToConsole "Object ID replacement is not a valid 16-bit hexadecimal length" -Error
            return $False
        }

        if ((GetDecimal $NewID) -eq -1) {
            WriteToConsole "Object ID replacement is not valid hexadecimal value" -Error
            return $False
        }

        $val = $NewID -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 0x10) }
        $SceneEditor.MapArray[$offset+0]  = $val[0]
        $SceneEditor.MapArray[$offset+1]  = $val[1]
    }

    if     ($Index -is [int])      { WriteToConsole ("Replaced object entry:   " + $Index)   }
    elseif ($Name  -is [string])   { WriteToConsole ("Replaced object:         " + $Name)    }
    elseif ($ID    -is [string])   { WriteToConsole ("Replaced object with ID: " + $printID) }
    else                           { WriteToConsole  "Replaced object"                       }

    return $True

}



#==============================================================================================================================================================================================
function RemoveObject($Index, $ID, $Name) {
    
    if ((GetObjectCount) -eq $null) { WriteToConsole "No object list defined for this header" -Error; return $False }

    $printID = $ID

    if ($Index -is [int]) {
        if ($Index -lt 0 -or $Index -ge (GetObjectCount)) { WriteToConsole "Object index is out of range" -Error; return $False }
    }
    elseif ($Name -is [string] -or $ID -is [string]) {
        if ($Name -is [string]) {
            foreach ($object in $Files.json.sceneEditor.objects) {
                if ($object.name -eq $Name) {
                    $ID = $object.id
                    break
                }
            }
        }

        if ($ID -eq $null) {
            WriteToConsole "No Object ID is set" -Error
            return $False
        }

        if ($ID.length -ne 4) {
            WriteToConsole "Object ID is not a valid 16-bit hexadecimal length" -Error
            return $False
        }

        $val = GetDecimal $ID
        if ($val -eq -1) {
            WriteToConsole "Object ID is not valid hexadecimal value" -Error
            return $False
        }

        $Index = 0;
        for ($i=(GetObjectStart); $i -lt (GetObjectEnd); $i+=2) {
            if ( ($SceneEditor.MapArray[$i] * 256 + $SceneEditor.MapArray[$i+1]) -eq $val) { break }
            $Index++
        }
    }
    else { WriteToConsole  "Object could not be found" -Error; return $False }

    if ($Index -ne (GetObjectCount) - 1) {
        for ($i=$Index; $i -lt (GetObjectCount); $i++) {
            $SceneEditor.MapArray[(GetObjectStart) + 2 * $i + 0] = $SceneEditor.MapArray[(GetObjectStart) + 2 * $i + 2]
            $SceneEditor.MapArray[(GetObjectStart) + 2 * $i + 1] = $SceneEditor.MapArray[(GetObjectStart) + 2 * $i + 3]
        }
    }
    DeleteObject

    if     ($Index -is [int])      { WriteToConsole ("Removed object entry:    " + $Index)   }
    elseif ($Name  -is [string])   { WriteToConsole ("Removed object:          " + $Name)    }
    elseif ($ID    -is [string])   { WriteToConsole ("Removed object with ID:  " + $printID) }
    else                           { WriteToConsole  "Removed object"                        }

    return $True

}



#==============================================================================================================================================================================================
function AddTransitionActor([System.Windows.Forms.GroupBox]$Group) {
    
    $count      = $SceneEditor.TransitionActors.Count
    $index      = (GetTransitionActorStart) + $count * 16
    $default    = 0
    $reset      = "0000"
    $id         = Get16Bit ($SceneEditor.SceneArray[$index + 4] * 256 + $SceneEditor.SceneArray[$index + 5])
    $actor      = @{}
    $SceneEditor.TransitionActors.Add($actor)

    $actor.Panel            = CreatePanel -X (DPISize 5)             -Y ( (DPISize 95) * $count + (DPISize 25) ) -Width ($group.Width - (DPISize 25))  -Height (DPISize 95)              -AddTo $group
    $actor.ParamsPanel      = CreatePanel -X (DPISize 220)                                                       -Width ($group.Width - (DPISize 245)) -Height (DPISize 25)              -AddTo $actor.Panel
    $actor.CoordinatesPanel = CreatePanel -X $actor.ParamsPanel.Left -Y $actor.ParamsPanel.Bottom                -Width $actor.ParamsPanel.Width       -Height $actor.ParamsPanel.Height -AddTo $actor.Panel
    $actor.MapPanel         = CreatePanel -X $actor.ParamsPanel.Left -Y $actor.CoordinatesPanel.Bottom           -Width $actor.ParamsPanel.Width       -Height $actor.ParamsPanel.Height -AddTo $actor.Panel
    $actor.Params           = @()
    $actor.Coordinates      = @()

    foreach ($x in 0..($Files.json.sceneEditor.transitions.Count-1)) {
        if ($Files.json.sceneEditor.transitions[$x].id -eq $id) {
            $default = $x + 1
            break
        }
    }

    if ($Settings.Debug.SceneEditorChecks -eq $True) { $label = CreateLabel -Y (DPISize 28) -Width (DPISize 50)  -Height (DPISize 20) -Text ("ID: " + $id) -AddTo $actor.Panel }
    CreateLabel -Y (DPISize 2) -Width (DPISize 55) -Height (DPISize 20) -Text ("Actor: " + ($count + 1)) -AddTo $actor.Panel

    if ($default -gt 0) {
        $actor.Name += CreateComboBox -X (DPISize 65) -Width (DPISize 155) -Height (DPISize 20) -Default $default -Items $Files.json.sceneEditor.transitions.name -AddTo $actor.Panel
        Add-Member -InputObject $actor.name -NotePropertyMembers @{ Index = $count }
        $actor.Params      = LoadActor                 -Actor $Files.json.sceneEditor.transitions[$x] -Count $count -IsScene
        $actor.Coordinates = LoadTransitionCoordinates -Count $count
    }
    else {
        $actor.Name        += CreateComboBox -X (DPISize 65) -Width (DPISize 155) -Height (DPISize 20) -AddTo $actor.Panel
        $actor.Name.Enabled = $False
        Add-Member -InputObject $actor.name -NotePropertyMembers @{ Index = $count; Label = $label }
        $actor.Coordinates = LoadTransitionCoordinates -Count $count
    }

    $param = $SceneEditor.SceneArray[$index + 14] * 256 + $SceneEditor.SceneArray[$index + 15]
    if ($Settings.Debug.SceneEditorChecks -eq $True) { $label = CreateLabel -X (DPISize 63) -Y (DPISize 28) -Width (DPISize 50) -Height (DPISize 20) -Text ("Init: " + (Get16Bit $param) ) -AddTo $actor.Panel }

    $actor.Map = @()
                  CreateLabel    -X (DPISize 20)  -Y (DPISize 2) -Width (DPISize 70) -Height (DPISize 20) -Text "Map (Front):" -AddTo $actor.MapPanel
    $actor.Map += CreateTextBox  -X (DPISize 95)  -Width (DPISize 40) -Height (DPISize 22) -Text $SceneEditor.SceneArray[$index]     -Length ([string]((GetMapCount) - 1)).length -AddTo $actor.MapPanel
                  CreateLabel    -X (DPISize 170) -Y (DPISize 2) -Width (DPISize 70) -Height (DPISize 20) -Text "Map (Back):"  -AddTo $actor.MapPanel
    $actor.Map += CreateTextBox  -X (DPISize 245) -Width (DPISize 40) -Height (DPISize 22) -Text $SceneEditor.SceneArray[$index + 2] -Length ([string]((GetMapCount) - 1)).length -AddTo $actor.MapPanel

                  CreateLabel    -X (DPISize 320) -Y (DPISize 2) -Width (DPISize 70) -Height (DPISize 20) -Text "Cam (Front):" -AddTo $actor.MapPanel
    $actor.Map += CreateTextBox  -X (DPISize 395) -Width (DPISize 40) -Height (DPISize 22) -Text $SceneEditor.SceneArray[$index + 1] -Length 3 -AddTo $actor.MapPanel
                  CreateLabel    -X (DPISize 470) -Y (DPISize 2) -Width (DPISize 70) -Height (DPISize 20) -Text "Cam (Back):"  -AddTo $actor.MapPanel
    $actor.Map += CreateTextBox  -X (DPISize 545) -Width (DPISize 40) -Height (DPISize 22) -Text $SceneEditor.SceneArray[$index + 3] -Length 3 -AddTo $actor.MapPanel

    Add-Member -InputObject $actor.Map[0] -NotePropertyMembers @{ Index = $count; Offset = 0; Max = (GetMapCount) - 1 }
    Add-Member -InputObject $actor.Map[1] -NotePropertyMembers @{ Index = $count; Offset = 2; Max = (GetMapCount) - 1 }
    Add-Member -InputObject $actor.Map[2] -NotePropertyMembers @{ Index = $count; Offset = 1; Max = 0xFF }
    Add-Member -InputObject $actor.Map[3] -NotePropertyMembers @{ Index = $count; Offset = 3; Max = 0xFF }

    $actor.Name.Add_SelectedIndexChanged({
        if (!$this.Enabled) { return }

        $index  = (GetTransitionActorStart) + $this.Index * 16 + 4
        foreach ($entry in $Files.json.sceneEditor.transition) {
            if ($entry.name -eq $this.text) {
                ChangeScene -Offset (Get24Bit $index) -Values $entry.id
                return
            }
        }
        
    })

    for ($i=0; $i -lt $actor.Map.count; $i++) {
        $actor.Map[$i].Add_LostFocus({
            $offset = (GetTransitionActorStart) + $this.Index * 16 + $this.Offset
            if (!$this.Enabled) { return }
            if     (($this.Text -as [int]) -eq $null)                          { $this.Text = $this.Default }
            elseif ([int]$this.Text -lt 0 -or [int]$this.Text -gt $this.Max)   { $this.Text = $this.Default }
            elseif ([int]$this.Text -eq $offset)                               { return }
            ChangeScene -Offset (Get24Bit $offset) -Values (Get16Bit ([int]$this.Text))
        })
    }

}



#==============================================================================================================================================================================================
function AddActor() {
    
    $index      = $SceneEditor.Actors.Count + ($SceneEditor.Tab-1) * 50
    $default    = 0
    $reset      = "0000"
    $actorTypes = @("Enemy", "Boss", "NPC", "Animal", "Cutscene", "Object", "Area", "Effect", "Unused", "Other")
    $id         = $SceneEditor.MapArray[(GetActorStart) + $index * 16] * 256 + $SceneEditor.MapArray[(GetActorStart) + 1 + $index * 16]
    if ($Files.json.sceneEditor.game -eq "Majora's Mask") { $id = $id -band 4095 }
    $id         = Get16Bit $id

    $actor      = @{}
    $SceneEditor.Actors.Add($actor)

    if ($Files.json.sceneEditor.game -eq "Majora's Mask")   { $height += 25 } else { $height = 0 }
    if ($Settings.Debug.SceneEditorChecks -eq $True)        { $height += 20 }
    $actor.Panel                = CreatePanel -X (DPISize 5)                  -Y ( (DPISize (70 + $height)) * ($SceneEditor.Actors.Count-1) + (DPISize 5) ) -Width ($SceneEditor.BottomPanelActors.Width - (DPISize 25))  -Height (DPISize (70 + $height))       -AddTo $SceneEditor.BottomPanelActors
    $actor.ParamsPanel          = CreatePanel -X (DPISize 220)                                                                                              -Width ($SceneEditor.BottomPanelActors.Width - (DPISize 245)) -Height (DPISize 25)                   -AddTo $actor.Panel
    $actor.CoordinatesPanel     = CreatePanel -X $actor.ParamsPanel.Left      -Y $actor.ParamsPanel.Bottom                                                  -Width $actor.ParamsPanel.Width                               -Height $actor.ParamsPanel.Height      -AddTo $actor.Panel
    if ($Files.json.sceneEditor.game -eq "Majora's Mask") {
        $actor.TimesPanel       = CreatePanel -X $actor.CoordinatesPanel.Left -Y $actor.CoordinatesPanel.Bottom                                             -Width $actor.CoordinatesPanel.Width                          -Height $actor.CoordinatesPanel.Height -AddTo $actor.Panel
    }
    $actor.Params      = @()
    $actor.Coordinates = @()
    $actor.SpawnTimes  = @()

    :outer foreach ($x in 0..($SceneEditor.ActorList.Count-1)) {
        if ($SceneEditor.ActorList[$x] -eq $null) { continue }
        foreach ($y in 0..($SceneEditor.ActorList[$x].Count-1)) {
            if ($SceneEditor.ActorList[$x][$y].id -eq $id) {
                $default = $y + 1
                break outer
            }
        }
    }

    
    $actor.Types += CreateComboBox -X (DPISize 65) -Y (DPISize 25) -Width (DPISize 100) -Height (DPISize 20) -Default ($x + 1) -Items $actorTypes -AddTo $actor.Panel
    if ($Settings.Debug.SceneEditorChecks -eq $True) {
        $label = CreateLabel -Y (DPISize 28) -Width (DPISize 55)   -Height (DPISize 20) -Text ("ID: "    + $id)    -AddTo $actor.Panel
        $value = Get16Bit ($SceneEditor.MapArray[(GetActorStart) + 14 + $index * 16] * 256 + $SceneEditor.MapArray[(GetActorStart) + 15 + $index * 16])
                 CreateLabel -Y (DPISize 48) -Width (DPISize 100)  -Height (DPISize 20) -Text ("Param: " + $value) -AddTo $actor.Panel
    }

    if ($default -gt 0) {
        $actor.Name += CreateComboBox -X (DPISize 65) -Width (DPISize 155) -Height (DPISize 20) -Default $default -Items $SceneEditor.ActorList[$x].name -AddTo $actor.Panel
        Add-Member -InputObject $actor.name -NotePropertyMembers @{ TabEntry = ($SceneEditor.Actors.Count-1); Index = $index; ListIndex = $x; Label = $label }
        $actor.Params      = LoadActor       -Actor $SceneEditor.ActorList[$x][$y] -Count $index
        $actor.Coordinates = LoadCoordinates -Actor $SceneEditor.ActorList[$x][$y] -Count $index
        if ($Files.json.sceneEditor.game -eq "Majora's Mask") { $actor.SpawnTimes = LoadSpawnTimes -Actor $SceneEditor.ActorList[$x][$y] -Count $index }
    }
    else {
        $actor.Name        += CreateComboBox -X (DPISize 65) -Width (DPISize 155) -Height (DPISize 20) -AddTo $actor.Panel
        $actor.Name.Enabled = $False
        
        Add-Member -InputObject $actor.name -NotePropertyMembers @{ TabEntry = ($SceneEditor.Actors.Count-1); Index = $index; ListIndex = 0; Label = $label }
        $actor.Coordinates = LoadCoordinates -Actor $null -Count $index
        if ($Files.json.sceneEditor.game -eq "Majora's Mask") { $actor.SpawnTimes = LoadSpawnTimes -Actor $null -Count $index }
    }

    if ($Settings.Debug.SceneEditorChecks -eq $True) {
        $debugText = ""

        if ($actor.Params.Count -eq 0 -or $default -eq 0) {
            $i     = (GetActorStart) + $index * 16
            $value = Get16Bit ($SceneEditor.MapArray[$i + 14] * 256 + $SceneEditor.MapArray[$i + 15])

            if ( (IsSet $SceneEditor.ActorList[$x][$y].default) -and $default -ne 0) {
                if ($value -ne $SceneEditor.ActorList[$x][$y].default) { $debugText = "Init: " + $value }
            }
            elseif ($value -ne "0000") { $debugText = "Init: " + $value }
            
        }

        if ($Files.json.sceneEditor.game -eq "Majora's Mask") {
            $text  = ""
            $value = $SceneEditor.MapArray[(GetActorStart) + $index * 16]

            $noX = (IsSet $actor.Coordinates[3]) -and $SceneEditor.ActorList[$x][$y].xrot -ne 1 -and $value -band 0x40
            $noY = (IsSet $actor.Coordinates[4]) -and $SceneEditor.ActorList[$x][$y].yrot -ne 1 -and $value -band 0x80
            $noZ = (IsSet $actor.Coordinates[5]) -and $SceneEditor.ActorList[$x][$y].zrot -ne 1 -and $value -band 0x20

            if     ($noX -and $noY -and $noZ)   { $text = "No X-, Y- & Z-Rot" }
            elseif ($noX -and $noY)             { $text = "No X- & Y-Rot"     }
            elseif ($noX -and $noZ)             { $text = "No X- & Z-Rot"     }
            elseif ($noY -and $noZ)             { $text = "No Y- & Z-Rot"     }
            elseif ($noX)                       { $text = "No X-Rot"          }
            elseif ($noY)                       { $text = "No Y-Rot"          }
            elseif ($noZ)                       { $text = "No Z-Rot"          }

            if ($text.Length -gt 0 -and $debugText.Length -gt 0) { $debugText += " \ " }
            $debugText += $text

            if ($actor.spawnTimes.count -ne 1 -and $actor.spawnTimes.count -ne 6) {
                $value = '{0:X}' -f ($SceneEditor.MapArray[(GetActorStart) + $index * 16 + 11] -band 0x7F)
                if ($value -ne "7F") {
                    if ($text.Length -gt 0 -or $debugText.Length -gt 0) { $debugText += " \ " }
                    $debugText += "Scene: " + $value
                }
            }

            if ($actor.spawnTimes.count -ne 5 -and $actor.spawnTimes.count -ne 6) {
                if ( ($SceneEditor.MapArray[(GetActorStart) + $index * 16 + 9] -band 7) * 0x80 + ($SceneEditor.MapArray[(GetActorStart) + $index * 16 + 13] -band 0x7F) -ne 1023) {
                    if ($debugText.Length -gt 0) { $debugText += " \ " }
                    $debugText += "Days"
                }
            }
        }

        if ($debugText.Length -gt 0) { $actor.Values = CreateLabel -Y (DPISize 50) -Width (DPISize 300) -Height (DPISize 20) -Text $debugText -AddTo $actor.Panel }
    }

    CreateLabel -Y (DPISize 2) -Width (DPISize 55) -Height (DPISize 20) -Text ("Actor: " + ($index + 1)) -AddTo $actor.Panel
    Add-Member  -InputObject $actor.types -NotePropertyMembers @{ TabEntry = ($SceneEditor.Actors.Count-1); Index = $index }

    $actor.Types.Add_SelectedIndexChanged({
        $SceneEditor.Actors[$this.TabEntry].Name.Items.Clear()
        $SceneEditor.Actors[$this.TabEntry].Name.Items.AddRange($SceneEditor.ActorList[$this.SelectedIndex].name)
        $SceneEditor.Actors[$this.TabEntry].Name.Enabled       = $True
        $SceneEditor.Actors[$this.TabEntry].Name.ListIndex     = $this.SelectedIndex
        $SceneEditor.Actors[$this.TabEntry].Name.SelectedIndex = 0
    })

    $actor.Name.Add_SelectedIndexChanged({
        $SceneEditor.Actors[$this.TabEntry].ParamsPanel.Controls.Clear()
        $SceneEditor.Actors[$this.TabEntry].CoordinatesPanel.Controls.Clear()
        if ($Files.json.sceneEditor.game -eq "Majora's Mask") { $SceneEditor.Actors[$this.TabEntry].TimesPanel.Controls.Clear() }
        $SceneEditor.Actors[$this.TabEntry].Params      = @()
        $SceneEditor.Actors[$this.TabEntry].Coordinates = @()
        
        foreach ($item in $SceneEditor.ActorList[$this.ListIndex]) {
            if ($item.name -ne $this.text)   { continue }
            if (IsSet $item.default)         { $reset    = $item.default   } else { $reset    = "0000" }
            if (IsSet $item.default_x)       { $defaultX = $item.default_x } else { $defaultX = 0      }
            if (IsSet $item.default_y)       { $defaultY = $item.default_y } else { $defaultY = 0      }
            if (IsSet $item.default_z)       { $defaultZ = $item.default_z } else { $defaultZ = 0      }
            $id              = $item.ID
            if ($Settings.Debug.SceneEditorChecks -eq $True) { $this.Label.Text = "ID: " + $id }

            if ($Files.json.sceneEditor.game -eq "Majora's Mask") {
                $id = GetDecimal $id
                foreach ($band in $item.band) {
                    if ($item.xrot -ne 1 -and $band -like "*rx*")   { $id += 0x4000 }
                    if ($item.yrot -ne 1 -and $band -like "*ry*")   { $id += 0x8000 }
                    if ($item.zrot -ne 1 -and $band -like "*rz*")   { $id += 0x2000 }
                }

                if ($item.xrot -eq 0 -and $id -band 0x4000 -ne 0x4000)   { $id += 0x4000 }
                if ($item.yrot -eq 0 -and $id -band 0x8000 -ne 0x8000)   { $id += 0x8000 }
                if ($item.zrot -eq 0 -and $id -band 0x2000 -ne 0x2000)   { $id += 0x2000 }

                $id = Get16Bit $id
            }

            ChangeMap       -Offset (Get24Bit ((GetActorStart) + 16 * $this.Index) )       -Values $id
            ChangeMap       -Offset (Get24Bit ((GetActorStart) + 16 * $this.Index + 14) )  -Values $reset
            ChangeMap       -Offset (Get24Bit ((GetActorStart) + 16 * $this.Index + 8)  )  -Values (Get16Bit $defaultX)
            ChangeMap       -Offset (Get24Bit ((GetActorStart) + 16 * $this.Index + 10) )  -Values (Get16Bit $defaultY)
            ChangeMap       -Offset (Get24Bit ((GetActorStart) + 16 * $this.Index + 12) )  -Values (Get16Bit $defaultZ)

            $SceneEditor.Actors[$this.TabEntry].Params = LoadActor -Actor $item -Count $this.Index
            $SceneEditor.Actors[$this.TabEntry].Coordinates = LoadCoordinates -Actor $item -Count $this.Index -X $defaultX -Y $defaultY -Z $defaultZ
            if ($Files.json.sceneEditor.game -eq "Majora's Mask") { $SceneEditor.Actors[$this.TabEntry].SpawnTimes = LoadSpawnTimes -Actor $item -Count $this.Index }
            return
        }
    })

}



#==============================================================================================================================================================================================
function AddObject() {
    
    $index       = $SceneEditor.Objects.Count
    $default     = 0
    $id          = Get16Bit ($SceneEditor.MapArray[(GetObjectStart) + $index * 2] * 256 + $SceneEditor.MapArray[(GetObjectStart) + 1 + $index * 2])
    $objectTypes = @("Enemy", "Boss", "NPC", "Animal", "Object", "Model", "Area", "Animation", "Unused", "Other")

    $object      = @{}
    $SceneEditor.Objects.Add($object)
    $object.Panel = CreatePanel -X (DPISize 5) -Y ( (DPISize 30) * $index + (DPISize 15)) -Width ($SceneEditor.BottomPanelObjects.Width - (DPISize 25)) -Height (DPISize 30) -AddTo $SceneEditor.BottomPanelObjects

    if ($id -eq "0000") {
        $object.Types = CreateComboBox -X (DPISize 65)  -Width (DPISize 100) -Height (DPISize 20) -Default ($objectTypes.Count + 1) -Items ($objectTypes + @("Unset")) -AddTo $object.Panel
        $object.Name  = CreateComboBox -X (DPISize 200) -Width (DPISize 300) -Height (DPISize 20)                                                                      -AddTo $object.Panel                      
        $object.Name.Enabled = $False
    }
    else {
        :outer foreach ($x in 0..($SceneEditor.ObjectList.Count - 1)) {
            foreach ($y in 0..($SceneEditor.ObjectList[$x].Count - 1)) {
                if ($SceneEditor.ObjectList[$x][$y].id -eq $id) {
                    $default = $y + 1
                    break outer
                }
            }
        }

        $object.Types = CreateComboBox -X (DPISize 65)  -Width (DPISize 100) -Height (DPISize 20) -Default ($x + 1) -Items $objectTypes                     -AddTo $object.Panel
        $object.Name  = CreateComboBox -X (DPISize 200) -Width (DPISize 300) -Height (DPISize 20) -Default $default -Items $SceneEditor.ObjectList[$x].name -AddTo $object.Panel
    }

    CreateLabel -X (DPISize 0) -Y (DPISize 3) -Width (DPISize 55) -Height (DPISize 20) -Text ("Object: " + ($index + 1)) -AddTo $object.Panel
    Add-Member -InputObject $object.Name  -NotePropertyMembers @{ Index = $index; ID = $id; ListIndex = $x }
    Add-Member -InputObject $object.Types -NotePropertyMembers @{ Index = $index }
        
    $object.Types.Add_SelectedIndexChanged({
        $SceneEditor.Objects[$this.Index].Name.Items.Clear()

        if ($this.text -ne "Unset") { $SceneEditor.Objects[$this.Index].Name.Items.AddRange($SceneEditor.ObjectList[$this.SelectedIndex].name) }
        $SceneEditor.Objects[$this.Index].Name.Enabled   = $SceneEditor.Objects[$this.Index].Name.Items.Count -gt 0
        $SceneEditor.Objects[$this.Index].Name.ListIndex = $this.SelectedIndex

        if ($SceneEditor.Objects[$this.Index].Name.Items.Count -gt 0) { $SceneEditor.Objects[$this.Index].Name.SelectedIndex = 0 }
        else {
            $SceneEditor.Objects[$this.Index].Name.ID = "0000"
            $SceneEditor.ObjectCount--
            ChangeMap -Offset (Get24Bit ((GetObjectStart) + 2 * $this.Index) ) -Values "0000"
            ChangeMap -Offset $SceneEditor.ObjectIndex -Values (Get8Bit (GetObjectCount))
        }
    })

    $object.name.Add_SelectedIndexChanged({
        foreach ($item in $SceneEditor.ObjectList[$this.ListIndex]) {
            if ($item.name -ne $this.text) { continue }
            $this.ID = $item.ID
            ChangeMap -Offset (Get24Bit ((GetObjectStart) + 2 * $this.Index) ) -Values $item.id
            return
        }
    })

}



#==============================================================================================================================================================================================
function LoadActor([object]$Actor, [byte]$Count, [switch]$IsScene) {
    
    if ($Actor.params.Count -eq 0) { return }

    if (!$IsScene) { $index = (GetActorStart) + $Count * 16 + 14 } else { $index = (GetTransitionActorStart) + $Count * 16 + 14 }
    $lastX     = 0
    $lastBandX = 0
    $params    = @()

    foreach ($i in 0..($Actor.params.Count-1)) {
        if     ($Actor.band[$i] -like "*rx*")   { $rotation = 6; $band = GetDecimal $Actor.band[$i].Replace("rx", "") }
        elseif ($Actor.band[$i] -like "*ry*")   { $rotation = 4; $band = GetDecimal $Actor.band[$i].Replace("ry", "") }
        elseif ($Actor.band[$i] -like "*rz*")   { $rotation = 2; $band = GetDecimal $Actor.band[$i].Replace("rz", "") }
        else                                    { $rotation = 0; $band = GetDecimal $Actor.band[$i]                   }

        if (!$IsScene)   { $value = $SceneEditor.MapArray[$index - $rotation] * 256 + $SceneEditor.MapArray[$index + 1 - $rotation] }
        else             { $value = $SceneEditor.SceneArray[$index]           * 256 + $SceneEditor.SceneArray[$index + 1]           }
        $previousX = $LastX
        if ($Files.json.sceneEditor.game -eq "Majora's Mask" -and $rotation -gt 0) { $value = ($value -band 0xFF80) -shr 7 }
        
        if ($Actor.params[$i][0].pos -gt 0) {
            $elem = $params[$Actor.params[$i][0].pos - 1]
            if ($elem -is [System.Windows.Forms.ComboBox])   { $LastX = $elem.left       - (DPISize 15) }
            else                                             { $LastX = $elem.label.left - (DPISize 15) }
        }

        $params += LoadParam -Param $Actor.params[$i] -Value $value -Band $band -LastBandX $lastBandX -LastX $lastX -Count $Count -Rotation $rotation -IsScene $IsScene

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

                if ($elem.HideParam -ne $null) {
                    foreach ($hide in $elem.HideParam[$elem.SelectedIndex]) {
                        if ($hide -gt 0) {
                            $hideElem         = $params[$hide - 1]
                            $hideElem.Enabled = $False
                            $value            = $Actor.params[$hide - 1][0].value
                            if ($value -is [array]) { $value = $value[0] }

                            if ($hideElem -is [System.Windows.Forms.ComboBox]) {
                                if (IsSet $hideElem.Backup) {
                                    $hideElem.Items.Clear()
                                    $hideElem.Items.AddRange($hideElem.Backup)
                                }
                                $hideElem.SelectedIndex = 0
                                
                            }
                            elseif ($hideElem -is [System.Windows.Forms.CheckBox])   { $hideElem.Checked = $False }
                            elseif ($hideElem -is [System.Windows.Forms.TextBox])    { $hideElem.Text    = $value }
                            
                            $hideElem.Value = $value
                            $hideElem.Enabled = $True

                            $hideElem.Hide()
                            if (IsSet $hideElem.Label) { $hideElem.Label.Hide() }
                        }
                    }
                }
            }
        }
        elseif ($params[$i] -is [System.Windows.Forms.CheckBox]) {
            $elem = $params[$i]

            if ($elem.HideParam -ne $null) {
                for ($x=0; $x -le 1; $x++) {
                    if ($x -eq 0 -and  $elem.Checked)   { continue }
                    if ($x -eq 1 -and !$elem.Checked)   { continue }

                    foreach ($hide in $elem.HideParam[$x]) {
                        if ($hide -gt 0) {
                            $params[$hide - 1].Enabled = $False
                            $value                     = $Actor.params[$hide - 1][0].value
                            if ($value -is [array]) { $value = $value[0] }
                            
                            if ($params[$hide - 1] -is [System.Windows.Forms.ComboBox]) {
                                if (IsSet $params[$hide - 1].Backup) {
                                    $params[$hide - 1].Items.Clear()
                                    $params[$hide - 1].Items.AddRange($params[$hide - 1].Backup)
                                }
                                $params[$hide - 1].SelectedIndex = 0
                            }
                            elseif ($params[$hide - 1] -is [System.Windows.Forms.CheckBox])   { $params[$hide - 1].Checked = $False }
                            elseif ($params[$hide - 1] -is [System.Windows.Forms.TextBox])    { $params[$hide - 1].Text    = $value }
                            
                            $params[$hide - 1].Value   = $value
                            $params[$hide - 1].Enabled = $True
                            $params[$hide - 1].Hide()
                            if (IsSet $params[$hide - 1].Label) { $params[$hide - 1].Label.Hide() }
                        }
                    }
                }
            }
        }

    }

    return $params

}



#==============================================================================================================================================================================================
function LoadParam([object]$Param, [uint16]$Value, [uint16]$Band, [uint16]$LastBandX, [uint16]$LastX, [byte]$Count, [byte]$Rotation=0, [boolean]$IsScene=$False) {
    
    $items        = $Param.name
    $default      = 0
    $defaultValue = 0
    $calc         = $Value -band $Band
    if (!$IsScene) { $TabEntry = $Count - ($SceneEditor.Tab-1) * 50 }

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

    if ($items.Count -eq 1 -and $Param[0].text -ne 0) { # Text Field
        if ($Param[0].multi -ge 0 -and $Param[0].multi -le 15) { $multi = $Param[0].multi }
        else {
            for ($i=0; $i -lt 15; $i++) {
                if ($Band -shr $i -eq (GetDecimal $Param[0].value)) { $multi = $i }
            }
        }

        if (!(IsSet $multi)) {
            if     ($Band -eq 0xFFF0 -or $Band -eq 0x0FF0 -or $Band -eq 0x00F0)   { $multi = 4  }
            elseif ($Band -eq 0xFF00 -or $Band -eq 0x0F00)                        { $multi = 8  }
            elseif ($Band -eq 0xF000)                                             { $multi = 12 }
            else                                                                  { $multi = 0  }
        }

        $val = '{0:X}' -f ($calc -shr $multi)

        if ($Param.auto -eq 1) {
               if (!$IsScene)   { $label = CreateLabel -X ($lastX + (DPISize 20) ) -Y (DPISize 2) -Height (DPISize 20) -Text ($Param[0].name + ":") -AddTo $SceneEditor.Actors[$TabEntry].ParamsPanel        }
               else             { $label = CreateLabel -X ($lastX + (DPISize 20) ) -Y (DPISize 2) -Height (DPISize 20) -Text ($Param[0].name + ":") -AddTo $SceneEditor.TransitionActors[$Count].ParamsPanel }
        }
        else {
            if (!$IsScene)   { $label = CreateLabel -X ($lastX + (DPISize 20) ) -Y (DPISize 2) -Height (DPISize 20) -Text ($Param[0].name + ":") -AddTo $SceneEditor.Actors[$TabEntry].ParamsPanel        -Width $LastBandX }
            else             { $label = CreateLabel -X ($lastX + (DPISize 20) ) -Y (DPISize 2) -Height (DPISize 20) -Text ($Param[0].name + ":") -AddTo $SceneEditor.TransitionActors[$Count].ParamsPanel -Width $LastBandX }
        }
        try {
            if (!$IsScene)   { $elem = CreateTextBox -X ($label.Right + (DPISize 5) ) -Y 0 -Width (DPISize 50) -Height (DPISize 22) -Text $val -Length $Param[0].value.length -AddTo $SceneEditor.Actors[$TabEntry].ParamsPanel        }
            else             { $elem = CreateTextBox -X ($label.Right + (DPISize 5) ) -Y 0 -Width (DPISize 50) -Height (DPISize 22) -Text $val -Length $Param[0].value.length -AddTo $SceneEditor.TransitionActors[$Count].ParamsPanel }
        }
        catch {
            if (!$IsScene)   { $elem = CreateTextBox -X ($label.Right + (DPISize 5) )  -Y 0 -Width (DPISize 50) -Height (DPISize 22) -Text "ERROR" -Length 0 -AddTo $SceneEditor.Actors[$TabEntry].ParamsPanel        }
            else             { $elem = CreateTextBox -X ($label.Right + (DPISize 5) )  -Y 0 -Width (DPISize 50) -Height (DPISize 22) -Text "ERROR" -Length 0 -AddTo $SceneEditor.TransitionActors[$Count].ParamsPanel }

            $elem.Enabled = $False
            WriteToConsole ("Could not parse Actor (" + $SceneEditor.Actors[$SceneEditor.Actors.Count-1].text + ") Text Field Param (" + $Param[0].name + ") with band: " + (Get16Bit $Band) + ", " + $calc + ", " + $multi ) -Error
        }
        $defaultValue = '{0:X}' -f ( (GetDecimal $elem.Text) -shl $multi)
        
        if ($Settings.Debug.SceneEditorChecks -eq $True -and !$IsScene) {
            $name = $Param[0].Name
            if ($name -eq "Flag")          { $SceneEditor.trackFlag1Values += (Get8Bit (GetDecimal $val) ) }
            if ($name -eq "Switch")        { $SceneEditor.trackFlag2Values += (Get8Bit (GetDecimal $val) ) }
            if ($name -eq "Collectable")   { $SceneEditor.trackFlag3Values += (Get8Bit (GetDecimal $val) ) }
        }

        Add-Member -InputObject $elem -NotePropertyMembers @{ Label = $label; Max = (GetDecimal $Param[0].value); Multi = $multi }

        $elem.Add_LostFocus({
            if (!$this.Enabled) { return }

            if ($Files.json.sceneEditor.game -eq "Majora's Mask" -and $this.Rotation -gt 0) { $shift = 7 } else { $shift = 0 }

            $this.Text = $this.Text.ToUpper()
            $text      = GetDecimal $this.Text

            if (('{0:X}' -f ($text -shl $this.Multi)) -eq $this.Value) { return }
            if ($text -lt 0 -or $text -gt $this.Max) {
                $this.Text = $this.Default
                $text      = GetDecimal $this.Default
            }

            if (!$this.IsScene) {
                $index  = (GetActorStart) + 16 * $this.Index + 14 - $this.Rotation
                $value  = $SceneEditor.MapArray[$index] * 256 + $SceneEditor.MapArray[$index + 1]
            }
            else {
                $index  = (GetTransitionActorStart) + 16 * $this.Index + 14
                $value  = $SceneEditor.SceneArray[$index] * 256 + $SceneEditor.SceneArray[$index + 1]
            }
            $value     -= (GetDecimal $this.Value) -shl $shift
            $this.Value = '{0:X}' -f ($text -shl $this.Multi)
            $value     += (GetDecimal $this.Value) -shl $shift

            if (!$this.IsScene)   { ChangeMap   -Offset (Get24Bit $index) -Values (Get16Bit $value) }
            else                  { ChangeScene -Offset (Get24Bit $index) -Values (Get16Bit $value) }
        })
    }

    elseif ($items.Count -eq 2) { # Checkbox
        if (!$IsScene) {
            $label = CreateLabel    -X ($lastX       + (DPISize 20) ) -Y (DPISize 2) -Height (DPISize 20) -Text ($items[1] + ":") -AddTo $SceneEditor.Actors[$TabEntry].ParamsPanel -Width $LastBandX
            $elem  = CreateCheckBox -X ($label.Right + (DPISize 5)  ) -Y 0           -Checked ($default -eq 2)                    -AddTo $SceneEditor.Actors[$TabEntry].ParamsPanel
        }
        else {
            $label = CreateLabel    -X ($lastX       + (DPISize 20) ) -Y (DPISize 2) -Height (DPISize 20) -Text ($items[1] + ":") -AddTo $SceneEditor.TransitionActors[$Count].ParamsPanel -Width $LastBandX
            $elem  = CreateCheckBox -X ($label.Right + (DPISize 5)  ) -Y 0           -Checked ($default -eq 2)                    -AddTo $SceneEditor.TransitionActors[$Count].ParamsPanel
        }

        if     ($default -eq 2)   { $defaultValue = $Param[1].value           }
        elseif ($default -eq 1)   { $defaultValue = $Param[0].value           }
        else                      { $defaultValue = 0; $elem.Enabled = $False }
        Add-Member -InputObject $elem -NotePropertyMembers @{ Label = $label  }

        :outer foreach ($x in $Param) {
            foreach ($y in $x) {
                if ($y.show -ge 0 -or $y.hide -ge 0) {
                    $show = @{}
                    $hide = @{}
                    for ($i=0; $i -lt $Param.Count; $i++) {
                        $show[$i] = $Param[$i].show
                        $hide[$i] = $Param[$i].hide
                    }

                    Add-Member -InputObject $elem -NotePropertyMembers @{ ShowParam = $show }
                    Add-Member -InputObject $elem -NotePropertyMembers @{ HideParam = $hide }

                    $elem.Add_CheckStateChanged({
                        if ($this.ResetParam -gt 0) {
                            if (!$this.IsScene) {
                                if ($SceneEditor.Actors[$this.TabEntry].Params[$this.ResetParam - 1] -is [System.Windows.Forms.ComboBox]) { GetCheckBoxChange -Elem $SceneEditor.Actors[$this.TabEntry].Params[$this.ResetParam - 1] -IsScene $False }
                            }
                            else {
                                if ($SceneEditor.TransitionActors[$this.Index].Params[$this.ResetParam - 1] -is [System.Windows.Forms.ComboBox]) { GetCheckBoxChange -Elem $SceneEditor.TransitionActors[$this.Index].Params[$this.ResetParam - 1] -IsScene $True }
                            }
                        }

                        GetCheckBoxChange -Elem $this -IsScene $this.IsScene
                    })

                    break outer
                }
            }
        }

        $elem.Add_CheckStateChanged({
            if (!$this.Enabled) { return }

            if ($Files.json.sceneEditor.game -eq "Majora's Mask" -and $this.Rotation -gt 0) { $shift = 7 } else { $shift = 0 }

            if (!$this.IsScene) {
                $index  = (GetActorStart) + 16 * $this.Index + 14 - $this.Rotation
                $value  = $SceneEditor.MapArray[$index] * 256 + $SceneEditor.MapArray[$index + 1]
            }
            else {
                $index  = (GetTransitionActorStart) + 16 * $this.Index + 14
                $value  = $SceneEditor.SceneArray[$index] * 256 + $SceneEditor.SceneArray[$index + 1]
            }
            $value -= (GetDecimal $this.Value) -shl $shift

            if ($this.Param[0].value -is [array]) {
                if ($this.Checked)   { $this.Value = $this.Param[1].value[0] }
                else                 { $this.Value = $this.Param[0].value[0] }
            }
            else {
                if ($this.Checked)   { $this.Value = $this.Param[1].value }
                else                 { $this.Value = $this.Param[0].value }
            }

            $value += (GetDecimal $this.Value) -shl $shift
            if (!$this.IsScene)   { ChangeMap   -Offset (Get24Bit $index) -Values (Get16Bit $value) }
            else                  { ChangeScene -Offset (Get24Bit $index) -Values (Get16Bit $value) }
        })
    }

    else { # Combobox
        if ($default -eq 0 -and $SceneEditor.Dialog.Enabled) {
            $backup = $items
            $items  = @("Unknown: " + '{0:X}' -f $calc)
        }
        if (!$IsScene)   { $elem = CreateComboBox -X ($LastX + (DPISize 20) ) -Y 0 -Width (DPISize 165) -Height (DPISize 20) -Default $default -Items $items -AddTo $SceneEditor.Actors[$TabEntry].ParamsPanel        }
        else             { $elem = CreateComboBox -X ($LastX + (DPISize 20) ) -Y 0 -Width (DPISize 165) -Height (DPISize 20) -Default $default -Items $items -AddTo $SceneEditor.TransitionActors[$Count].ParamsPanel }
        if (IsSet $backup) { Add-Member -InputObject $elem -NotePropertyMembers @{ Backup = $backup } }
        if ($default -eq 0 -and $SceneEditor.Dialog.Enabled) { $elem.Enabled = $False }

        :outer foreach ($x in $Param) {
            foreach ($y in $x) {
                if ($y.show -ge 0 -or $y.hide -ge 0) {
                    $show = @{}
                    $hide = @{}
                    for ($i=0; $i -lt $Param.Count; $i++) {
                        $show[$i] = $Param[$i].show
                        $hide[$i] = $Param[$i].hide
                    }

                    Add-Member -InputObject $elem -NotePropertyMembers @{ ShowParam  = $show }
                    Add-Member -InputObject $elem -NotePropertyMembers @{ HideParam  = $hide }
                    Add-Member -InputObject $elem -NotePropertyMembers @{ ResetParam = $x.reset }

                    $elem.Add_SelectedIndexChanged({
                        if ($this.ResetParam -gt 0) {
                            if (!$this.IsScene) {
                                if ($SceneEditor.Actors[$this.TabEntry].Params[$this.ResetParam - 1] -is [System.Windows.Forms.ComboBox]) { GetDropDownChange -Elem $SceneEditor.Actors[$this.TabEntry].Params[$this.ResetParam - 1] -IsScene $False }
                            }
                            else {
                                if ($SceneEditor.TransitionActors[$this.Index].Params[$this.ResetParam - 1] -is [System.Windows.Forms.ComboBox]) { GetDropDownChange -Elem $SceneEditor.TransitionActors[$this.Index].Params[$this.ResetParam - 1] -IsScene $True }
                            }
                        }
                        GetDropDownChange -Elem $this -IsScene $IsScene
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

            if ($Files.json.sceneEditor.game -eq "Majora's Mask" -and $this.Rotation -gt 0) { $shift = 7 } else { $shift = 0 }

            if (!$this.IsScene) {
                $index = (GetActorStart) + 16 * $this.Index + 14 - $this.Rotation
                $value = ($SceneEditor.MapArray[$index] * 256 + $SceneEditor.MapArray[$index + 1])
            }
            else {
                $index = (GetTransitionActorStart) + 16 * $this.Index + 14
                $value = ($SceneEditor.SceneArray[$index] * 256 + $SceneEditor.SceneArray[$index + 1])
            }
            $value -= (GetDecimal $this.Value) -shl $shift

            foreach ($param in $this.Param) {
                if ($param.name -eq $this.text) {
                    if ($param.value -is [array])   { $this.Value = $param.value[0] }
                    else                            { $this.Value = $param.value    }
                    break
                }
            }

            $value += (GetDecimal $this.Value) -shl $shift
            if (!$this.IsScene)   { ChangeMap   -Offset (Get24Bit $index) -Values (Get16Bit $value) }
            else                  { ChangeScene -Offset (Get24Bit $index) -Values (Get16Bit $value) }
        })
    }

    Add-Member -InputObject $elem -NotePropertyMembers @{ TabEntry = ($Count - ($SceneEditor.Tab-1) * 50); Index = $Count; Param = $Param; Value = $defaultValue; Rotation = $Rotation; IsScene = $IsScene }
    return $elem

}



#==============================================================================================================================================================================================
function GetCheckBoxChange([object]$Elem, [boolean]$IsScene=$False) {

    if (!$Elem.Enabled) { return }
                        
    for ($y=0; $y -le 1; $y++) {
        if ($y -eq 0 -and  $Elem.Checked)   { continue }
        if ($y -eq 1 -and !$Elem.Checked)   { continue }

        $index = (GetActorStart) + 16 * $Elem.Index + 14
        if (!$IsScene) {
            $value  = $SceneEditor.MapArray[$index - 0] * 256 + $SceneEditor.MapArray[$index + 1 - 0]
            $valueX = $SceneEditor.MapArray[$index - 6] * 256 + $SceneEditor.MapArray[$index + 1 - 6]
            $valueY = $SceneEditor.MapArray[$index - 4] * 256 + $SceneEditor.MapArray[$index + 1 - 4]
            $valueZ = $SceneEditor.MapArray[$index - 2] * 256 + $SceneEditor.MapArray[$index + 1 - 2]
        }
        else { $value = $SceneEditor.SceneArray[$index] * 256 + $SceneEditor.SceneArray[$index + 1] }

        for ($x=0; $x -lt $Elem.HideParam[$y].Count; $x++) {
            if ($Elem.HideParam[$y][$x] -gt 0) {
                if (!$IsScene)   { $param = $SceneEditor.Actors[$Elem.TabEntry].Params[$Elem.HideParam[$y][$x] - 1]        }
                else             { $param = $SceneEditor.TransitionActors[$Elem.Index].Params[$Elem.HideParam[$y][$x] - 1] }
                if ($param.Visible) {
                    $param.Hide()
                    if ($param.Label -ne $null) { $param.Label.Hide() }
                    if ($Files.json.sceneEditor.game -eq "Majora's Mask" -and $param.Rotation -gt 0) { $shift = 7 } else { $shift = 0 }
                    if     ($param.Rotation -eq 0) { $value  -= (GetDecimal $param.Value)  }
                    elseif ($param.Rotation -eq 6) { $valueX -= (GetDecimal $param.ValueX) -shl $shift }
                    elseif ($param.Rotation -eq 4) { $valueY -= (GetDecimal $param.ValueY) -shl $shift }
                    elseif ($param.Rotation -eq 2) { $valueZ -= (GetDecimal $param.ValueZ) -shl $shift }
                }
            }
        }

        for ($x=0; $x -lt $Elem.ShowParam[$y].Count; $x++) {
            if ($Elem.ShowParam[$y][$x] -gt 0) {
                if (!$IsScene)   { $param = $SceneEditor.Actors[$Elem.TabEntry].Params[$Elem.ShowParam[$y][$x] - 1]        }
                else             { $param = $SceneEditor.TransitionActors[$Elem.Index].Params[$Elem.ShowParam[$y][$x] - 1] }
                if (!$param.Visible) {
                    $param.Show()
                    if ($param.Label -ne $null) { $param.Label.Show() }
                    if ($Files.json.sceneEditor.game -eq "Majora's Mask" -and $param.Rotation -gt 0) { $shift = 7 } else { $shift = 0 }
                    if     ($param.Rotation -eq 0) { $value  += (GetDecimal $param.Value)  }
                    elseif ($param.Rotation -eq 6) { $valueX += (GetDecimal $param.ValueX) -shl $shift }
                    elseif ($param.Rotation -eq 4) { $valueY += (GetDecimal $param.ValueY) -shl $shift }
                    elseif ($param.Rotation -eq 2) { $valueZ += (GetDecimal $param.ValueZ) -shl $shift }
                }
            }
        }

        if (!$IsScene) {
            ChangeMap -Offset (Get24Bit ($index - 0)) -Values (Get16Bit $value)  -Silent
            ChangeMap -Offset (Get24Bit ($index - 6)) -Values (Get16Bit $valueX) -Silent
            ChangeMap -Offset (Get24Bit ($index - 4)) -Values (Get16Bit $valueY) -Silent
            ChangeMap -Offset (Get24Bit ($index - 2)) -Values (Get16Bit $valueZ) -Silent
        }
        else { ChangeScene -Offset (Get24Bit $index) -Values (Get16Bit $value) -Silent }

        WriteToConsole ((Get24Bit $index) + " -> Change values: " + (Get16Bit $value) + ", " + (Get16Bit $valueX) + ", " + (Get16Bit $valueY) + ", " + (Get16Bit $valueZ))
    }

}



#==============================================================================================================================================================================================
function GetDropDownChange([object]$Elem, [boolean]$IsScene=$False) {

    if (!$Elem.Enabled) { return }

    $index = (GetActorStart) + 16 * $Elem.Index + 14
    if (!$IsScene) {
        $value  = $SceneEditor.MapArray[$index - 0] * 256 + $SceneEditor.MapArray[$index + 1 - 0]
        $valueX = $SceneEditor.MapArray[$index - 6] * 256 + $SceneEditor.MapArray[$index + 1 - 6]
        $valueY = $SceneEditor.MapArray[$index - 4] * 256 + $SceneEditor.MapArray[$index + 1 - 4]
        $valueZ = $SceneEditor.MapArray[$index - 2] * 256 + $SceneEditor.MapArray[$index + 1 - 2]
    }
    else { $value = $SceneEditor.SceneArray[$index] * 256 + $SceneEditor.SceneArray[$index + 1] }

    for ($x=0; $x -lt $Elem.HideParam[$Elem.SelectedIndex].Count; $x++) {
        $hide = $Elem.HideParam[$Elem.SelectedIndex][$x]
        if ($hide -gt 0) {
            if (!$IsScene)   { $param = $SceneEditor.Actors[$Elem.TabEntry].Params[$hide - 1]        }
            else             { $param = $SceneEditor.TransitionActors[$Elem.Index].Params[$hide - 1] }
            if ($param.Visible) {
                $param.Hide()
                if ($param.Label -ne $null) { $param.Label.Hide() }
                if ($Files.json.sceneEditor.game -eq "Majora's Mask" -and $param.Rotation -gt 0) { $shift = 7 } else { $shift = 0 }
                if     ($param.Rotation -eq 0) { $value  -= (GetDecimal $param.Value)  }
                elseif ($param.Rotation -eq 6) { $valueX -= (GetDecimal $param.ValueX) -shl $shift }
                elseif ($param.Rotation -eq 4) { $valueY -= (GetDecimal $param.ValueY) -shl $shift }
                elseif ($param.Rotation -eq 2) { $valueZ -= (GetDecimal $param.ValueZ) -shl $shift }
            }
        }
    }

    for ($x=0; $x -lt $Elem.ShowParam[$Elem.SelectedIndex].Count; $x++) {
        $show = $Elem.ShowParam[$Elem.SelectedIndex][$x]
        if ($show -gt 0) {
            if (!$IsScene)   { $param = $SceneEditor.Actors[$Elem.TabEntry].Params[$show - 1]        }
            else             { $param = $SceneEditor.TransitionActors[$Elem.Index].Params[$show - 1] }
            if (!$param.Visible) {
                $param.Show()
                if ($param.Label -ne $null) { $param.Label.Show() }
                if ($Files.json.sceneEditor.game -eq "Majora's Mask" -and $param.Rotation -gt 0) { $shift = 7 } else { $shift = 0 }
                if     ($param.Rotation -eq 0) { $value  += (GetDecimal $param.Value)  }
                elseif ($param.Rotation -eq 6) { $valueX += (GetDecimal $param.ValueX) -shl $shift }
                elseif ($param.Rotation -eq 4) { $valueY += (GetDecimal $param.ValueY) -shl $shift }
                elseif ($param.Rotation -eq 2) { $valueZ += (GetDecimal $param.ValueZ) -shl $shift }
            }
        }
    }

    if (!$IsScene) {
        ChangeMap -Offset (Get24Bit ($index - 0)) -Values (Get16Bit $value)  -Silent
        ChangeMap -Offset (Get24Bit ($index - 6)) -Values (Get16Bit $valueX) -Silent
        ChangeMap -Offset (Get24Bit ($index - 4)) -Values (Get16Bit $valueY) -Silent
        ChangeMap -Offset (Get24Bit ($index - 2)) -Values (Get16Bit $valueZ) -Silent
    }
    else { ChangeScene -Offset (Get24Bit $index) -Values (Get16Bit $value) -Silent }

    WriteToConsole ((Get24Bit $index) + " -> Change values: " + (Get16Bit $value) + ", " + (Get16Bit $valueX) + ", " + (Get16Bit $valueY) + ", " + (Get16Bit $valueZ))

}



#==============================================================================================================================================================================================
function LoadSpawnTimes([object]$Actor, [byte]$Count) {
    
    $spawnTimes = @()
    $x          = 20
    $index      = (GetActorStart) + $Count * 16
    $tabEntry   = $Count - ($SceneEditor.Tab-1) * 50

    # Spawn Times
    if ($Actor.Spawn -eq 1 -or $Actor.Type -eq "Enemy") {
        $value = ($SceneEditor.MapArray[$index + 9] -band 7) * 0x80 + ($SceneEditor.MapArray[$index + 13] -band 0x7F)

        $spawnTimes += SetSpawnTimes -X $x -Count $Count -Value $value -Day 0; $x+= 120
        $spawnTimes += SetSpawnTimes -X $x -Count $Count -Value $value -Day 1; $x+= 120
        $spawnTimes += SetSpawnTimes -X $x -Count $Count -Value $value -Day 2; $x+= 120
        $spawnTimes += SetSpawnTimes -X $x -Count $Count -Value $value -Day 3; $x+= 120
        $spawnTimes += SetSpawnTimes -X $x -Count $Count -Value $value -Day 4; $x+= 120
    }

    # Scene Command
    if ($Actor.Cutscene -eq 1) {
        $value       = $SceneEditor.MapArray[$index + 11] -band 0x7F
        $hexValue    = '{0:X}' -f $value
        $label       = CreateLabel    -X (DPISize $x) -Y (DPISize 2) -Width (DPISize 65) -Height (DPISize 20) -Text "Cutscene:"         -AddTo $SceneEditor.Actors[$tabEntry].TimesPanel; $x+= 150
        $spawnTimes += CreateTextBox  -X $label.Right                -Width (DPISize 50) -Height (DPISize 22) -Text $hexValue -Length 2 -AddTo $SceneEditor.Actors[$tabEntry].TimesPanel

        Add-Member -InputObject $spawnTimes[$spawnTimes.Count-1] -NotePropertyMembers @{ Index = $index; Value = $value }
        $spawnTimes[$spawnTimes.Count-1].Add_LostFocus({
            $this.Text = $this.Text.ToUpper()
            $value     = GetDecimal $this.Text

            if ($value -eq $this.Value) { return }
            if ($value -lt 0 -or $value -gt 0x7F) {
                $this.Text = $this.Default
                $value     = GetDecimal $this.Default
            }

            ChangeMap -Offset (Get24Bit ($this.Index + 11) ) -Values (Get8Bit ($SceneEditor.MapArray[$this.Index + 11] + $value - $this.Value))
            $this.Value = $value
        })
    }

    return $spawnTimes

}



#==============================================================================================================================================================================================
function SetSpawnTimes($X, [byte]$Count, [uint16]$Value, [byte]$Day) {

    $index    = (GetActorStart) + $Count * 16
    $tabEntry = $Count - ($SceneEditor.Tab-1) * 50
    $band     = [Math]::Pow(4, $Day) * 3
    $div      = [Math]::Pow(4, $Day)
    $elem     = CreateComboBox -X (DPISize $X) -Width (DPISize 100) -Height (DPISize 20) -Default (($value -band $band) / $div + 1) -Items @(("No Day " + $Day), ("Night " + $Day), ("Morning " + $Day), ("Whole Day " + $Day)) -AddTo $SceneEditor.Actors[$tabEntry].TimesPanel

    if ($elem.SelectedIndex -lt 0 -or $elem.SelectedIndex -gt 3) { $elem.Enabled = $False }
    Add-Member -InputObject $elem -NotePropertyMembers @{ Index = $index; Value = ($value -band $band); Day = $Day }

    $elem.Add_SelectedIndexChanged({
        $value  = ($SceneEditor.MapArray[$this.Index+9] -band 7) * 0x80 + ($SceneEditor.MapArray[$this.Index + 13] -band 0x7F)
        $band   = [Math]::Pow(4, $this.Day) * 3
        $value -= $this.Value
        $value += $value -band $band
        
        $SceneEditor.MapArray[$this.Index+9]  = ($SceneEditor.MapArray[$this.Index+9]  -band 0x80) + ($value -band 0x380) / 0x80
        $SceneEditor.MapArray[$this.Index+13] = ($SceneEditor.MapArray[$this.Index+13] -band 0x80) + ($value -band 0x7F)
        $this.Value = $value -band $band
        WriteToConsole ( (Get24Bit ($this.Index+9)) + " -> Change values: " + (Get8Bit $SceneEditor.MapArray[$this.Index+9]) + " / " + (Get24Bit ($this.Index+13)) + " -> Change values: " + (Get8Bit $SceneEditor.MapArray[$this.Index+13]) )
    })

    return $elem

}



#==============================================================================================================================================================================================
function LoadCoordinates([object]$Actor, [byte]$Count, [byte]$X=0, [byte]$Y=0, [byte]$Z=0) {
    
    $noX = $noY = $noZ = $False
    $coordinates = @()

    if (IsSet $Actor) {
        foreach ($band in $Actor.band) {
            if ($band -like "*rx*")   { $noX = $True }
            if ($band -like "*ry*")   { $noY = $True }
            if ($band -like "*rz*")   { $noZ = $True }
        }
        if ($Actor.xrot -eq 0)   { $noX = $True }
        if ($Actor.yrot -eq 0)   { $noY = $True }
        if ($Actor.zrot -eq 0)   { $noZ = $True }
    }

                   $coordinates += SetCoordinates -X 20  -Count $Count -Offset 2 -Text "X-Coords"
                   $coordinates += SetCoordinates -X 170 -Count $Count -Offset 4 -Text "Y-Coords"
                   $coordinates += SetCoordinates -X 320 -Count $Count -Offset 6 -Text "Z-Coords"

    if (!$noX)   { $coordinates += SetCoordinates -X 470 -Count $Count -Offset 8  -Text "X-Rotation" -Default $X } else { $coordinates += $null }
    if (!$noY)   { $coordinates += SetCoordinates -X 620 -Count $Count -Offset 10 -Text "Y-Rotation" -Default $Y } else { $coordinates += $null }
    if (!$noZ)   { $coordinates += SetCoordinates -X 770 -Count $Count -Offset 12 -Text "Z-Rotation" -Default $Z } else { $coordinates += $null }

    return $coordinates

}



#==============================================================================================================================================================================================
function SetCoordinates($X, [byte]$Count, [byte]$Offset, [string]$Text, [byte]$Default=0) {

    $index    = (GetActorStart) + $Count * 16
    $tabEntry = $Count - ($SceneEditor.Tab-1) * 50
    
    if ($Default -eq 0) {
        if     ($Files.json.sceneEditor.game -eq "Majora's Mask" -and $offset -ge 8)   { $min = 0;         $max = 0x1FF;  $length = 3; $shift = 7; $value = ( ($SceneEditor.MapArray[$index + $Offset] * 256 + $SceneEditor.MapArray[$index + $Offset + 1]) -band 0xFF80) -shr $shift }
        elseif ($offset -ge 8)                                                         { $min = 0;         $max = 0xFFFF; $length = 4; $shift = 0; $value =    $SceneEditor.MapArray[$index + $Offset] * 256 + $SceneEditor.MapArray[$index + $Offset + 1]                            }
        else                                                                           { $min = -(0x8000); $max = 0x7FFF; $length = 5; $shift = 0; $value =   ($SceneEditor.MapArray[$index + $Offset] * 256 + $SceneEditor.MapArray[$index + $Offset + 1])                           }
    }
    else {
        if     ($Files.json.sceneEditor.game -eq "Majora's Mask" -and $offset -ge 8)   { $min = 0;         $max = 0x1FF;  $length = 3; $shift = 7; $value = $Default -shr $shift }
        elseif ($offset -ge 8)                                                         { $min = 0;         $max = 0xFFFF; $length = 4; $shift = 0; $value = $Default             }
        else                                                                           { $min = -(0x8000); $max = 0x7FFF; $length = 5; $shift = 0; $value = $Default             }
    }

    if ($value -gt $max) { $value -= ($max + 1) * 2 }

    $label = CreateLabel   -X (DPISize $X) -Y (DPISize 2) -Width (DPISize 65) -Height (DPISize 20) -Text ($Text + ":")          -AddTo $SceneEditor.Actors[$tabEntry].CoordinatesPanel
    $elem  = CreateTextBox -X $label.Right                -Width (DPISize 50) -Height (DPISize 22) -Text $value -Length $length -AddTo $SceneEditor.Actors[$tabEntry].CoordinatesPanel

    Add-Member -InputObject $elem -NotePropertyMembers @{ Index = $Index; Offset = $Offset; Value = $value; Min = $min; Max = $max; Shift = $shift }

    $elem.Add_LostFocus({
        if (($this.Text -as [int]) -eq $null)                                   { $this.Text = $this.Default }
        if  ([int]$this.Text -lt $this.Min -or [int]$this.Text -gt $this.Max)   { $this.Text = $this.Default }
        if  ([int]$this.Text -eq $this.Value)                                   { return }

        $wholeValue = $SceneEditor.MapArray[$this.Index + $this.Offset] * 256 + $SceneEditor.MapArray[$this.Index + $this.Offset + 1] + ([int]$this.Text -shl $this.Shift) - ($this.Value -shl $this.Shift);
        $this.Value = [int]$this.Text
        if ($wholeValue -lt 0) { $wholeValue += ($this.$Max + 1) * 2 }
        ChangeMap -Offset (Get24Bit ($this.Index + $this.Offset) ) -Values (Get16Bit $wholeValue)
    })

    return $elem

}



#==============================================================================================================================================================================================
function LoadTransitionCoordinates([byte]$Count) {
    
    $coordinates = @()
    $coordinates += SetTransitionCoordinates -X 20  -Count $Count -Offset 6  -Text "X-Coords"
    $coordinates += SetTransitionCoordinates -X 170 -Count $Count -Offset 8  -Text "Y-Coords"
    $coordinates += SetTransitionCoordinates -X 320 -Count $Count -Offset 10 -Text "Z-Coords"
    $coordinates += SetTransitionCoordinates -X 470 -Count $Count -Offset 12 -Text "Y-Rotation"
    return $coordinates

}



#==============================================================================================================================================================================================
function SetTransitionCoordinates($X, [byte]$Count, [byte]$Offset, [string]$Text) {

    $index = (GetTransitionActorStart) + $Count * 16
    $min = -(0x8000); $max = 0x7FFF; $length = 5; $shift = 0; $value = ($SceneEditor.SceneArray[$index + $Offset] * 256 + $SceneEditor.SceneArray[$index + $Offset + 1])
    if ($value -gt $max) { $value -= ($max + 1) * 2 }

    $label = CreateLabel   -X (DPISize $X) -Y (DPISize 2) -Width (DPISize 65) -Height (DPISize 20) -Text ($Text + ":")          -AddTo $SceneEditor.TransitionActors[$Count].CoordinatesPanel
    $elem  = CreateTextBox -X $label.Right                -Width (DPISize 50) -Height (DPISize 22) -Text $value -Length $length -AddTo $SceneEditor.TransitionActors[$Count].CoordinatesPanel
    Add-Member -InputObject $elem -NotePropertyMembers @{ Index = $Index; Offset = $Offset; Value = $value; Min = $min; Max = $max; Shift = $shift }

    $elem.Add_LostFocus({
        if (($this.Text -as [int]) -eq $null)                                   { $this.Text = $this.Default }
        if  ([int]$this.Text -lt $this.Min -or [int]$this.Text -gt $this.Max)   { $this.Text = $this.Default }
        if  ([int]$this.Text -eq $this.Value)                                   { return }

        $wholeValue = $SceneEditor.SceneArray[$this.Index + $this.Offset] * 256 + $SceneEditor.SceneArray[$this.Index + $this.Offset + 1] + ([int]$this.Text -shl $this.Shift) - ($this.Value -shl $this.Shift);
        $this.Value = [int]$this.Text
        if ($wholeValue -lt 0) { $wholeValue += ($this.$Max + 1) * 2 }
        ChangeScene -Offset (Get24Bit ($this.Index + $this.Offset) ) -Values (Get16Bit $wholeValue)
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
function DoAssertSceneFiles() {
    
    if (TestFile -Path ($Paths.Assert + "\assert") ) {
        if ($GameType.Mode -eq "Ocarina of Time")   { return $True }
        if ($GameType.Mode -eq "Majora's Mask")     { return $True }
    }

    return $False
    
}



#==============================================================================================================================================================================================
function ApplyTestSceneFiles() {
    
    if ($GameType.Mode -eq "Ocarina of Time") {
        ApplyPatch -FullPath -Patch ($Paths.Assert + "\Scenes\Kokiri Forest.ppf")
        ApplyPatch -FullPath -Patch ($Paths.Assert + "\Scenes\Graveyard.ppf")
        ApplyPatch -FullPath -Patch ($Paths.Assert + "\Scenes\Lake Hylia.ppf")
        ApplyPatch -FullPath -Patch ($Paths.Assert + "\Scenes\Death Mountain Crater.ppf")
        ApplyPatch -FullPath -Patch ($Paths.Assert + "\Scenes\Gerudo's Fortress.ppf")

      # ApplyPatch -FullPath -Patch ($Paths.Assert + "\Scenes\Death Mountain Trail.ppf")
      # ApplyPatch -FullPath -Patch ($Paths.Assert + "\Scenes\Inside Ganon's Castle.ppf")
  }

}



#==============================================================================================================================================================================================
function TestScenesFiles() {
    
    if ($GameType.Mode -eq "Ocarina of Time") {
        PrepareMap       -Scene "Kokiri Forest" -Map 1 -Header 0
        InsertSpawnPoint -X 3608 -Y (-179) -Z (-1009) -Param "0DFF" -YRot 0x5555
        SaveAndPatchLoadedScene
        AssertSceneFiles

        PrepareMap       -Scene "Sacred Forest Meadow" -Map 0 -Header 0
        InsertSpawnPoint -X 10 -Y 500 -Z (-2610) -Param "0201"
        SaveAndPatchLoadedScene
        AssertSceneFiles



        PrepareMap   -Scene "Graveyard" -Map 1 -Header 0
        ReplaceActor -Name "Collectable" -Compare "0406" -X (-850)
        InsertActor  -Name "Gravestone" -X (-578) -Y 120 -Z (-336) -Param "0001"
        RemoveActor  -Name "Graveyard"  -CompareX (-578) -CompareY 120 -CompareZ (-336)
        InsertActor  -Name "Uninteractable Objects" -X (-562) -Y 120 -Z (-289)
        InsertActor  -Name "Uninteractable Objects" -X (-578) -Y 120 -Z (-280)
        InsertActor  -Name "Uninteractable Objects" -X (-598) -Y 120 -Z (-287)
        InsertObject -Name "Warp Circle & Rupee Prism"
        InsertActor  -Name "Warp Portal" -X 1140 -Y 340 -Z 85 -Param "0006"
        InsertSpawnPoint -X 1140 -Y 340 -Z 85 -Param "0201" -YRot 0xC71C
        SaveLoadedMap

        PrepareMap   -Scene "Graveyard" -Map 1 -Header 1
        ReplaceActor -Name "Collectable" -Compare "0406" -X (-850)
        InsertActor  -Name "Gravestone" -X (-578) -Y 120 -Z (-336) -Param "0001"
        RemoveActor  -Name "Graveyard"  -CompareX (-578) -CompareY 120 -CompareZ (-336)
        InsertActor  -Name "Uninteractable Objects" -X (-562) -Y 120 -Z (-289)
        InsertActor  -Name "Uninteractable Objects" -X (-578) -Y 120 -Z (-280)
        InsertActor  -Name "Uninteractable Objects" -X (-598) -Y 120 -Z (-287)
        InsertObject -Name "Warp Circle & Rupee Prism"
        InsertActor  -Name "Warp Portal" -X 1140 -Y 340 -Z 85 -Param "0006"
        InsertSpawnPoint -X 1140 -Y 340 -Z 85 -Param "0201" -YRot 0xC71C
        SaveAndPatchLoadedScene

        AssertSceneFiles



        PrepareMap       -Scene "Lake Hylia" -Map 0 -Header 0
        InsertSpawnPoint -X (-1045) -Y (-1223) -Z 7460 -Param "0200" -YRot 0x8000
        SaveAndPatchLoadedScene
        AssertSceneFiles

        PrepareMap       -Scene "Death Mountain Crater" -Map 1 -Header 0
        InsertSpawnPoint -Y 441 -YRot 0x8000 -Param "0200"
        SaveAndPatchLoadedScene
        AssertSceneFiles

        PrepareMap       -Scene "Desert Colossus" -Map 0 -Header 0
        InsertSpawnPoint -X (-850) -Y 20 -Z (-2070) -Param "0200" -YRot 0x1555
        SaveAndPatchLoadedScene
        AssertSceneFiles
        


        PrepareMap   -Scene "Shadow Temple" -Map 2 -Header 0
        InsertObject -Name "Inside Ganon's Castle"
        InsertActor  -Name "Clear Block" -X 34     -Y (-63) -Z 295 -Param "FF01"
        InsertActor  -Name "Clear Block" -X (-142) -Y (-63) -Z 295 -Param "FF01"
        SaveLoadedMap

        PrepareMap   -Scene "Shadow Temple" -Map 6 -Header 0
        ReplaceActor -Name "Spinning Scythe Trap"                   -Y (-563)
        ReplaceActor -Name "Silver Rupee" -CompareZ (-1222) -X 3220 -Y (-543) -Z (-747)
        SaveLoadedMap

        PrepareMap   -Scene "Shadow Temple" -Map 10 -Header 0
        ReplaceActor -Name "Treasure Chest" -Compare "5945" -Param "5D25"
        InsertObject -Name "Hookshot Pillar & Wall Target"
        InsertActor  -Name "Stone Hookshot Target" -X 275 -Y (-1395) -Z 3735  -Param "FF00"
        SaveLoadedMap
	
        PrepareMap   -Scene "Shadow Temple" -Map 11 -Header 0
        InsertObject -Name "Hookshot Pillar & Wall Target"
        InsertActor  -Name "Stone Hookshot Target" -X 2021 -Y (-1385) -Z 1013 -Param "FF00"
        InsertObject -Name "Inside Ganon's Castle"
        InsertActor  -Name "Clear Block"           -X 2084 -Y (-1203) -Z 1160 -Param "FF01" -YRot 0x9A00
        InsertActor  -Name "Clear Block"           -X 2275 -Y (-1203) -Z 869  -Param "FF01"
        InsertActor  -Name "Clear Block"           -X 2750 -Y (-1203) -Z 869  -Param "FF01"
        SaveLoadedMap

        PrepareMap   -Scene "Shadow Temple" -Map 16 -Header 0
        ReplaceActor -Name "Time Block"     -Compare "380A" -Param "B80A"
        ReplaceActor -Name "Treasure Chest" -Compare "6976" -Param "6D36"
        ReplaceActor -Name "Spinning Scythe Trap"  -Y (-1183)
        SaveLoadedMap

        PrepareMap   -Scene "Shadow Temple" -Map 19 -Header 0
        ReplaceActor -Name "Treasure Chest" -Compare "6955" -Param "6D35"
        SaveLoadedMap

        PrepareMap   -Scene "Shadow Temple" -Map 21 -Header 0
        RemoveObject -Name "Pierre & Bonooru"
        RemoveActor  -Name "Pierre the Scarecrow Spawn"
        RemoveActor  -Name "Pierre the Scarecrow Spawn"
        ReplaceActor -Name "Skullwalltula" -X 4981 -Y (-948) -Z (-1435)
        InsertObject -Name "Hookshot Pillar & Wall Target"
        InsertActor  -Name "Stone Hookshot Target" -X 4520 -Y (-1410) -Z (-1506) -Param "FF00"
        ReplaceActor -Name "Time Block" -X (-2465) -Y (-1423) -Z (-804) -Param "B80C"
        SaveAndPatchLoadedScene

        AssertSceneFiles



        PrepareMap   -Scene "Gerudo Valley" -Map 0 -Header 0
        RemoveActor  -Name "Obstacle Fence"
        InsertActor  -Name "Bronze Boulder" -X (-1352) -Y 69  -Z 767     -Param "000B"
        InsertActor  -Name "Bronze Boulder" -X (-1291) -Y 65  -Z 787     -Param "0009"
        InsertActor  -Name "Bronze Boulder" -X (-1416) -Y 59  -Z 778     -Param "000D"
        InsertActor  -Name "Bronze Boulder" -X (-1256) -Y 55  -Z 856     -Param "0010"
        InsertObject -Name "Treasure Chest"
        InsertActor  -Name "Treasure Chest" -X (-1341) -Y 76  -Z 858     -Param "5AA0" -YRot 0xE2D8
        InsertActor  -Name "Skullwalltula"  -X (-1329) -Y 360 -Z 309     -Param "B404" -XRot 0x31C7 -YRot 0xE4FA
        InsertActor  -Name "Skullwalltula"  -X (-1171) -Y 160 -Z (-1225) -Param "B408" -XRot 0x4000
        InsertActor  -Name "Grotto Entrance" -X (-1323) -Y 15  -Z (-969) -Param "01F0" -YRot 0x9555
        SaveAndPatchLoadedScene
        AssertSceneFiles



        PrepareMap       -Scene "Gerudo's Fortress" -Map 0 -Header 0
        InsertSpawnPoint -X 188 -Y 733 -Z (-2919) -Param "0DFF"
        SaveAndPatchLoadedScene
        AssertSceneFiles



        AssertArrays -Array1 ([System.IO.File]::ReadAllBytes($Paths.Temp + "\scene\cutscenes.tbl") ) -Array2 ([System.IO.File]::ReadAllBytes($Paths.Base + "\Assert\cutscenes.tbl") ) -Message1 "Cutscenes table files not equal in size..." -Message2 "Assert cutscenes table files... "
        AssertArrays -Array1 ([System.IO.File]::ReadAllBytes($Paths.Temp + "\scene\scenes.tbl") )    -Array2 ([System.IO.File]::ReadAllBytes($Paths.Base + "\Assert\scenes.tbl")    ) -Message1 "Scenes table files not equal in size... "   -Message2 "Assert scenes table files...    "
    }

    if ($GameType.Mode -eq "Majora's Mask") {
        PrepareMap   -Scene "Mountain Village (Spring)" -Map 0 -Header 0
        InsertObject -Name "Treasure Chest"
        InsertActor  -Name "Treasure Chest" -Param "0D40" -X 310 -Y 463 -Z 700 -YRot 90 -NoXRot -NoZRot
        SaveAndPatchLoadedScene
        AssertSceneFiles
    }

}



#==============================================================================================================================================================================================
function AssertArrays([byte[]]$Array1, [byte[]]$Array2, [string]$Message1, [string]$Message2) {
    
    if ($Array1.count -ne $Array2.count) { WriteToConsole $Message 1; return }
    
    $assert = (-not (Compare-Object $Array1 $Array2 -SyncWindow 0))
    WriteToConsole ($Message2 + $assert)
    
    if ($assert) { return }
    for ($j=0; $j -lt $Array1.count; $j++) {
        if ($Array1[$j] -ne $Array2[$j]) { WriteToConsole ("Offset " + (Get24Bit $j) + " is " + (Get8Bit $Array1[$j]) + ", but expected " + (Get8Bit $Array2[$j])) }
    }

}



#==============================================================================================================================================================================================
function AssertSceneFiles() {
    
    for ($i=0; $i -le $SceneEditor.LoadedScene.length + 1; $i++) {
        if ($i -eq 0) {
            $file1 = $Paths.Temp + "\scene\scene.zscene"
            $file2 = $Paths.Base + "\Assert\" + $SceneEditor.LoadedScene.name + "\scene.zscene"
        }
        elseif ($i -le $SceneEditor.LoadedScene.length) {
            $file1 = $Paths.Temp + "\scene\room_" + ($i-1) + ".zmap"
            $file2 = $Paths.Base + "\Assert\" + $SceneEditor.LoadedScene.name + "\room_" + ($i-1) + ".zmap"
        }
        else {
            $file1 = $Paths.Temp + "\scene\table.dma"
            $file2 = $Paths.Base + "\Assert\" + $SceneEditor.LoadedScene.name + "\table.dma"
        }

        $arr1 = [System.IO.File]::ReadAllBytes($file1)
        $arr2 = [System.IO.File]::ReadAllBytes($file2)

        if ($arr1.count -ne $arr2.count) {
            if     ($i -eq 0)                                 { WriteToConsole ("Scene files not equal in size... "      + (Get24Bit $arr1.count) + " vs " + (Get24Bit $arr2.count) ) }
            elseif ($i -le $SceneEditor.LoadedScene.length)   { WriteToConsole ("Map files not equal in size... "        + (Get24Bit $arr1.count) + " vs " + (Get24Bit $arr2.count) ) }
            else                                              { WriteToConsole ("DMA table files not equal in size... "  + (Get24Bit $arr1.count) + " vs " + (Get24Bit $arr2.count) ) }
            continue
        }

        $assert = (-not (Compare-Object $arr1 $arr2 -SyncWindow 0))
        if     ($i -eq 0)                                 { WriteToConsole ("Assert scene files...           "              + $assert) }
        elseif ($i -le $SceneEditor.LoadedScene.length)   {
            if ($i -le 10)                                { WriteToConsole ("Assert map " + ($i-1) + " files...           " + $assert) }
            else                                          { WriteToConsole ("Assert map " + ($i-1) + " files...          "  + $assert) }
        }
        else                                              { WriteToConsole ("Assert DMA table files...       "              + $assert) }

        if ($assert) { continue }
        for ($j=0; $j -lt $arr1.count; $j++) {
            if ($arr1[$j] -ne $arr2[$j]) { WriteToConsole ("Offset " + (Get24Bit $j) + " is " + (Get8Bit $arr1[$j]) + ", but expected " + (Get8Bit $arr2[$j])) }
        }

    }

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function RunSceneEditor
Export-ModuleMember -Function CloseSceneEditor
Export-ModuleMember -Function PrepareMap
Export-ModuleMember -Function SaveLoadedMap
Export-ModuleMember -Function PatchLoadedScene
Export-ModuleMember -Function SaveAndPatchLoadedScene
Export-ModuleMember -Function ChangeMapFile
Export-ModuleMember -Function ChangeSceneFile

Export-ModuleMember -Function PrepareAndSetSceneSettings
Export-ModuleMember -Function PrepareAndSetMapSettings
Export-ModuleMember -Function SetSceneSettings
Export-ModuleMember -Function ChangeSpawnPoint
Export-ModuleMember -Function ChangeDoor
Export-ModuleMember -Function ChangeExit
Export-ModuleMember -Function SetMapSettings
Export-ModuleMember -Function InsertActor
Export-ModuleMember -Function InsertSpawnPoint
Export-ModuleMember -Function ReplaceActor
Export-ModuleMember -Function RemoveActor
Export-ModuleMember -Function ReplaceTransitionActor
Export-ModuleMember -Function DeleteObject
Export-ModuleMember -Function InsertObject
Export-ModuleMember -Function ReplaceObject
Export-ModuleMember -Function RemoveObject

Export-ModuleMember -Function DoAssertSceneFiles
Export-ModuleMember -Function ApplyTestSceneFiles
Export-ModuleMember -Function TestScenesFiles

Export-ModuleMember -Function GetActorCountIndex
Export-ModuleMember -Function GetMeshIndex

<#
Export-ModuleMember -Function GetHeader
Export-ModuleMember -Function GetHeaderEnd
Export-ModuleMember -Function GetActorCount
Export-ModuleMember -Function GetActorStart
Export-ModuleMember -Function GetActorEnd
Export-ModuleMember -Function GetActorCountIndex
Export-ModuleMember -Function GetActorIndex
Export-ModuleMember -Function GetFoundActors
Export-ModuleMember -Function GetObjectCount
Export-ModuleMember -Function GetObjectStart
Export-ModuleMember -Function GetObjectEnd
Export-ModuleMember -Function GetObjectCountIndex
Export-ModuleMember -Function GetObjectIndex
Export-ModuleMember -Function GetFoundObjects
Export-ModuleMember -Function GetMeshStart
Export-ModuleMember -Function GetMeshIndex
#>

<#
Export-ModuleMember -Function GetSceneHeader
Export-ModuleMember -Function GetSceneHeaderEnd
Export-ModuleMember -Function GetPositionCount
Export-ModuleMember -Function GetPositionStart
Export-ModuleMember -Function GetPositionEnd
Export-ModuleMember -Function GetPositionCountIndex
Export-ModuleMember -Function GetPositionIndex
Export-ModuleMember -Function GetCollisionStart
Export-ModuleMember -Function GetCollisionIndex
Export-ModuleMember -Function GetMapCount
Export-ModuleMember -Function GetMapStart
Export-ModuleMember -Function GetMapEnd
Export-ModuleMember -Function GetMapCountIndex
Export-ModuleMember -Function GetMapIndex
Export-ModuleMember -Function GetEntranceStart
Export-ModuleMember -Function GetEntranceEnd
Export-ModuleMember -Function GetEntranceIndex
Export-ModuleMember -Function GetTransitionActorCount
Export-ModuleMember -Function GetTransitionActorStart
Export-ModuleMember -Function GetTransitionActorEnd
Export-ModuleMember -Function GetTransitionActorCountIndex
Export-ModuleMember -Function GetTransitionActorIndex
Export-ModuleMember -Function GetFoundTransitionActors
Export-ModuleMember -Function GetLightningCount
Export-ModuleMember -Function GetLightningStart
Export-ModuleMember -Function GetLightningEnd
Export-ModuleMember -Function GetLightningCountIndex
Export-ModuleMember -Function GetLightningIndex
Export-ModuleMember -Function GetExitStart
Export-ModuleMember -Function GetExitIndex
Export-ModuleMember -Function GetFoundExits
Export-ModuleMember -Function GetPathStart
Export-ModuleMember -Function GetPathIndex
Export-ModuleMember -Function GetFoundPaths
Export-ModuleMember -Function GetCutsceneStart
Export-ModuleMember -Function GetCutsceneIndex
Export-ModuleMember -Function GetFoundCutscenes
#>