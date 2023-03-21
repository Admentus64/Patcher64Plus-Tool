function CreateSceneEditorDialog([int32]$Width, [int32]$Height, [string]$Game=$GameType.mode, [string]$Checksum) {
    
    $global:SceneEditor     = @{}
    $Files.json.sceneEditor = SetJSONFile ($Paths.Games + "\" + $Game + "\Scene Editor.json")
    $SceneEditor.FirstLoad = $True
    $SceneEditor.Resetting = $False



    # Create Dialog
    $SceneEditor.Dialog           = CreateDialog -Width (DPISize 1300) -Height (DPISize 700)
    $SceneEditor.Dialog.Icon      = $Files.icon.additional
    $SceneEditor.Dialog.BackColor = 'AntiqueWhite'



    # Groups
    $SceneEditor.TopGroup                             = CreateGroupBox -X (DPISize 10) -Y (DPISize 5)                                  -Width ($SceneEditor.Dialog.Width      - (DPISize 30)) -Height (DPISize 70)                                      -AddTo $SceneEditor.Dialog
    $SceneEditor.BottomGroup                          = CreateGroupBox -X (DPISize 10) -Y ($SceneEditor.TopGroup.Bottom + (DPISize 5)) -Width ($SceneEditor.Dialog.Width      - (DPISize 30)) -Height ($SceneEditor.Dialog.Height      - (DPISize 190)) -AddTo $SceneEditor.Dialog
    
    $SceneEditor.BottomPanelActors                    = CreatePanel    -X (DPISize 5)  -Y (DPISize 10)                                 -Width ($SceneEditor.BottomGroup.Width - (DPISize 10)) -Height ($SceneEditor.BottomGroup.Height - (DPISize 15))  -AddTo $SceneEditor.BottomGroup
    $SceneEditor.BottomPanelActors.AutoScroll         = $True
    $SceneEditor.BottomPanelActors.AutoScrollMargin   = New-Object System.Drawing.Size(0, 0)
    $SceneEditor.BottomPanelActors.AutoScrollMinSize  = New-Object System.Drawing.Size(0, 0)

    $SceneEditor.BottomPanelObjects                   = CreatePanel -X $SceneEditor.BottomPanelActors.Left  -Y $SceneEditor.BottomPanelActors.Top -Width $SceneEditor.BottomPanelActors.Width -Height $SceneEditor.BottomPanelActors.Height -AddTo $SceneEditor.BottomGroup
    $SceneEditor.BottomPanelObjects.AutoScroll        = $True
    $SceneEditor.BottomPanelObjects.AutoScrollMargin  = New-Object System.Drawing.Size(0, 0)
    $SceneEditor.BottomPanelObjects.AutoScrollMinSize = New-Object System.Drawing.Size(0, 0)

    $SceneEditor.BottomPanelMapPreview                = CreatePanel -X $SceneEditor.BottomPanelActors.Left  -Y $SceneEditor.BottomPanelActors.Top -Width $SceneEditor.BottomPanelActors.Width -Height $SceneEditor.BottomPanelActors.Height -AddTo $SceneEditor.BottomGroup
    $SceneEditor.MapPreviewImage                      = CreateForm  -X (DPISize 50) -Y (DPISize 5) -Width (DPISize 1152) -Height (DPISize 648) -Form (New-Object Windows.Forms.PictureBox) -AddTo $SceneEditor.BottomPanelMapPreview
    $file                                             = $Paths.Games + "\" + $Game + "\Maps\default.jpg"
    if (TestFile $file) { SetBitMap -Path $file -Box $SceneEditor.MapPreviewImage } else { $SceneEditor.MapPreviewImage.Image = $null }



    # Actors Button
    $ActorsButton           = CreateButton -X ($SceneEditor.TopGroup.Right - (DPISize 300)) -Y (DPISize 15) -Width (DPISize 80) -Height (DPISize 35) -Text "Actors" -AddTo $SceneEditor.TopGroup
    $ActorsButton.BackColor = "White"
    $ActorsButton.Add_Click({
        $SceneEditor.BottomPanelActors.Show()
        $SceneEditor.BottomPanelObjects.Hide()
        $SceneEditor.BottomPanelMapPreview.Hide()
    })



    # Objects Button
    $ObjectsButton           = CreateButton -X ($ActorsButton.Right + (DPISize 15)) -Y $ActorsButton.Top -Width $ActorsButton.Width -Height $ActorsButton.Height -Text "Objects" -AddTo $SceneEditor.TopGroup
    $ObjectsButton.BackColor = "White"
    $ObjectsButton.Add_Click({
        $SceneEditor.BottomPanelActors.Hide()
        $SceneEditor.BottomPanelObjects.Show()
        $SceneEditor.BottomPanelMapPreview.Hide()
    })

    $SceneEditor.DeleteActor  = CreateButton -X $ActorsButton.Left              -Y $ActorsButton.Bottom          -Width (DPISize 40) -Height (DPISize 17) -Font $Fonts.SmallBold -Text "-" -AddTo $SceneEditor.TopGroup -BackColor "Red"   -ForeColor "White"
    $SceneEditor.InsertActor  = CreateButton -X $SceneEditor.DeleteActor.Right  -Y $SceneEditor.DeleteActor.Top  -Width (DPISize 40) -Height (DPISize 17) -Font $Fonts.SmallBold -Text "+" -AddTo $SceneEditor.TopGroup -BackColor "Green" -ForeColor "White"
    $SceneEditor.DeleteObject = CreateButton -X $ObjectsButton.Left             -Y $ObjectsButton.Bottom         -Width (DPISize 40) -Height (DPISize 17) -Font $Fonts.SmallBold -Text "-" -AddTo $SceneEditor.TopGroup -BackColor "Red"   -ForeColor "White"
    $SceneEditor.InsertObject = CreateButton -X $SceneEditor.DeleteObject.Right -Y $SceneEditor.DeleteObject.Top -Width (DPISize 40) -Height (DPISize 17) -Font $Fonts.SmallBold -Text "+" -AddTo $SceneEditor.TopGroup -BackColor "Green" -ForeColor "White"

    $SceneEditor.DeleteActor.Enabled = $SceneEditor.InsertActor.Enabled = $SceneEditor.DeleteObject.Enabled = $SceneEditor.InsertObject.Enabled = $False
    $SceneEditor.DeleteActor.Add_Click(  { DeleteActor  } )
    $SceneEditor.InsertActor.Add_Click(  { InsertActor  } )
    $SceneEditor.DeleteObject.Add_Click( { DeleteObject } )
    $SceneEditor.InsertObject.Add_Click( { InsertObject } )



    # Map Preview Button
    $MapPreviewButton           = CreateButton -X ($ObjectsButton.Right + (DPISize 15)) -Y $ObjectsButton.Top -Width $ObjectsButton.Width -Height $ObjectsButton.Height -Text "Preview Map" -AddTo $SceneEditor.TopGroup
    $MapPreviewButton.BackColor = "White"
    $MapPreviewButton.Add_Click({
        $SceneEditor.BottomPanelActors.Hide()
        $SceneEditor.BottomPanelObjects.Hide()
        $SceneEditor.BottomPanelMapPreview.Show()
    })



    # Close Button
    $X = $SceneEditor.Dialog.Left + ($SceneEditor.Dialog.Width / 3)
    $Y = $SceneEditor.Dialog.Height - (DPISize 90)
    $CloseButton           = CreateButton -X $X -Y $Y -Width (DPISize 90) -Height (DPISize 35) -Text "Close" -AddTo $SceneEditor.Dialog
    $CloseButton.BackColor = "White"
    $CloseButton.Add_Click({ $SceneEditor.Dialog.Hide() })



    # Extract Button
    $ExtractButton           = CreateButton -X ($CloseButton.Right + (DPISize 15)) -Y $CloseButton.Top -Width $CloseButton.Width -Height $CloseButton.Height -Text "Extract Scenes" -AddTo $SceneEditor.Dialog
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
    $SceneEditor.ResetMapButton           = CreateButton -X ($ExtractButton.Right + (DPISize 15)) -Y $ExtractButton.Top -Width $ExtractButton.Width -Height $ExtractButton.Height -Text "Reset Map" -AddTo $SceneEditor.Dialog
    $SceneEditor.ResetMapButton.BackColor = "White"
    $SceneEditor.ResetMapButton.Enabled   = $False
    $SceneEditor.ResetMapButton.Add_Click({
        $lastMessage = $StatusLabel.Text
        EnableGUI $False
        RunAllScenes -Current
        EnableGUI $True
        PlaySound $Sounds.done
        Cleanup
        UpdateStatusLabel $lastMessage
    })



    # Reset Quest Button
    if ($Files.json.sceneEditor.quest -is [array] -and $Files.json.sceneEditor.quest.Count -gt 0) {
        $ResetQuestButton           = CreateButton -X ($SceneEditor.ResetMapButton.Right + (DPISize 15)) -Y $SceneEditor.ResetMapButton.Top -Width $SceneEditor.ResetMapButton.Width -Height $SceneEditor.ResetMapButton.Height -Text "Reset Quest" -AddTo $SceneEditor.Dialog
        $ResetQuestButton.BackColor = "White"
        $ResetQuestButton.Add_Click({
            $SceneEditor.Quests[0].Checked = $True

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
        $lastX = $ResetQuestButton.Right
    }
    else { $lastX = $SceneEditor.ResetMapButton.Right }



    # Patch Scenes Button
    $PatchButton           = CreateButton -X ($lastX + (DPISize 15)) -Y $SceneEditor.ResetMapButton.Top -Width $SceneEditor.ResetMapButton.Width -Height $SceneEditor.ResetMapButton.Height -Text "Patch Scenes" -AddTo $SceneEditor.Dialog
    $PatchButton.BackColor = "White"
    $PatchButton.Add_Click({
        SaveMap -Scene $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex] -Index $SceneEditor.Maps.SelectedIndex
        $lastMessage = $StatusLabel.Text
        EnableGUI $False
        RunAllScenes -Patch
        EnableGUI $True
        PlaySound $Sounds.done
        Cleanup
        UpdateStatusLabel $lastMessage
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
    $SceneEditor.Tabs += CreateButton -X ($SceneEditor.DeleteActor.Right - (DPISize 300)) -Y $SceneEditor.Headers.Top -Width (DPISize 50)               -Height (DPISize 20)                -Text "1-50"    -BackColor "Red" -ForeColor "White" -AddTo $SceneEditor.TopGroup
    $SceneEditor.Tabs += CreateButton -X ($SceneEditor.Tabs[0].Right     + (DPISize 1))   -Y $SceneEditor.Tabs[0].Top -Width $SceneEditor.Tabs[0].width -Height $SceneEditor.Tabs[0].height -Text "51-100"  -BackColor "Red" -ForeColor "White" -AddTo $SceneEditor.TopGroup
    $SceneEditor.Tabs += CreateButton -X ($SceneEditor.Tabs[1].Right     + (DPISize 1))   -Y $SceneEditor.Tabs[0].Top -Width $SceneEditor.Tabs[0].width -Height $SceneEditor.Tabs[0].height -Text "101-150" -BackColor "Red" -ForeColor "White" -AddTo $SceneEditor.TopGroup
    $SceneEditor.Tabs += CreateButton -X ($SceneEditor.Tabs[2].Right     + (DPISize 1))   -Y $SceneEditor.Tabs[0].Top -Width $SceneEditor.Tabs[0].width -Height $SceneEditor.Tabs[0].height -Text "151-200" -BackColor "Red" -ForeColor "White" -AddTo $SceneEditor.TopGroup
    $SceneEditor.Tabs += CreateButton -X ($SceneEditor.Tabs[3].Right     + (DPISize 1))   -Y $SceneEditor.Tabs[0].Top -Width $SceneEditor.Tabs[0].width -Height $SceneEditor.Tabs[0].height -Text "201-255" -BackColor "Red" -ForeColor "White" -AddTo $SceneEditor.TopGroup
    
    $SceneEditor.Tabs[0].Add_Click({ LoadTab -Tab 1 })
    $SceneEditor.Tabs[1].Add_Click({ LoadTab -Tab 2 })
    $SceneEditor.Tabs[2].Add_Click({ LoadTab -Tab 3 })
    $SceneEditor.Tabs[3].Add_Click({ LoadTab -Tab 4 })
    $SceneEditor.Tabs[4].Add_Click({ LoadTab -Tab 5 })


    if ($Files.json.sceneEditor.quest -is [array] -and $Files.json.sceneEditor.quest.Count -gt 0) {
        $SceneEditor.QuestLabels = @()
        $SceneEditor.Quests      = @()

        $SceneEditor.QuestLabels += CreateLabel    -X ($SceneEditor.Scenes.Right         + (DPISize 15) ) -Y (DPISize 15) -Height (DPISize 15) -Font $Fonts.SmallBold -Text "Original:" -AddTo $SceneEditor.TopGroup
        $SceneEditor.Quests      += CreateCheckBox -X ($SceneEditor.QuestLabels[0].Right + (DPISize 5) )  -Y (DPISize 13) -IsRadio                                                      -AddTo $SceneEditor.TopGroup -Checked $True
        $SceneEditor.QuestLabels[0].Visible = $SceneEditor.Quests[0].Visible = $False

         $SceneEditor.Quests[0].Add_CheckedChanged( {
            if ($SceneEditor.Quests[0].Visible -and $SceneEditor.Quests[0].Enabled -and $SceneEditor.Quests[0].Checked) {
                $Settings["Dungeon"][$SceneEditor.Scenes.Text] = 1
                LoadScene $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex] -Keep
            }
        } )

        foreach ($quest in $Files.json.sceneEditor.quest) {
            $SceneEditor.QuestLabels += CreateLabel    -X ($SceneEditor.Quests[$SceneEditor.Quests.Count-1].Right           + (DPISize 15) ) -Y (DPISize 15) -Height (DPISize 15) -Font $Fonts.SmallBold -Text ($quest + ":") -AddTo $SceneEditor.TopGroup
            $SceneEditor.Quests      += CreateCheckBox -X ($SceneEditor.QuestLabels[$SceneEditor.QuestLabels.Count-1].Right + (DPISize 5) )  -Y (DPISize 13) -IsRadio                                                         -AddTo $SceneEditor.TopGroup
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

        LoadScene $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex]
    })



    # Select Map
    if (IsSet ($Settings["Core"]["Editor.Map." + $Files.json.sceneEditor.parse]) -and $SceneEditor.Maps.Items.Count -gt 0) {
        if ([byte]$Settings["Core"]["Editor.Map." + $Files.json.sceneEditor.parse] -le $SceneEditor.Maps.Items.Count) {
            $SceneEditor.Maps.SelectedIndex = $Settings["Core"]["Editor.Map." + $Files.json.sceneEditor.parse] - 1
        }
    }

    if ($SceneEditor.Maps.SelectedIndex -lt 0 -and $SceneEditor.Maps.Items.Count -gt 0) { $SceneEditor.Maps.SelectedIndex = 0 }
    LoadMap -Scene $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex]
    $SceneEditor.DropMap   = $SceneEditor.Maps.SelectedIndex
    $SceneEditor.LastScene = $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex]
    $SceneEditor.LastMap   = $SceneEditor.Maps.SelectedIndex

    $SceneEditor.Maps.Add_SelectedIndexChanged({
        if ($this.SelectedIndex -eq $SceneEditor.DropMap) { return }
        $SceneEditor.DropMap = $this.SelectedIndex
        if (!$SceneEditor.Resetting) { SaveMap -Scene $SceneEditor.LastScene -Index $SceneEditor.LastMap }
        LoadMap -Scene $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex]
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
    LoadHeader -Scene $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex]
    $SceneEditor.DropHeader = $SceneEditor.Headers.SelectedIndex

    $SceneEditor.Headers.Add_SelectedIndexChanged({
        if ($this.SelectedIndex -eq $SceneEditor.DropHeader) { return }
        $SceneEditor.DropHeader = $this.SelectedIndex

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
function RunSceneEditor([string]$Game=$GameType.mode, [string]$Checksum) {
    
    $LastGame    = $GameType
    $LastConsole = $GameConsole

    if     ($Game -eq "Ocarina of Time")   { $global:GameType = $Files.json.games[0] }
    elseif ($Game -eq "Majora's Mask")     { $global:GameType = $Files.json.games[1] }
    else                                   { $global:GameType = $null                }
    $global:GameConsole = $Files.json.consoles[0]

    CreateSceneEditorDialog -Game $Game
    $SceneEditor.Dialog.ShowDialog()

    if ($SceneEditor.Maps.Items.Count -gt 0) {
        SaveMap -Scene $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex] -Index $SceneEditor.Maps.SelectedIndex
        $Settings["Core"]["Editor.Map."    + $Files.json.sceneEditor.parse] = $SceneEditor.Maps.SelectedIndex    + 1
        $Settings["Core"]["Editor.Header." + $Files.json.sceneEditor.parse] = $SceneEditor.Headers.SelectedIndex + 1
        if ($SceneEditor.Tab -ge 1 -and $SceneEditor.Tab -le $SceneEditor.Tabs.Count) { $Settings["Core"]["Editor.Tab." + $Files.json.sceneEditor.parse] = $SceneEditor.Tab }
    }

    $global:ByteScriptArray = $global:ByteTableArray = $Files.json.sceneEditor = $global:SceneEditor = $null
    $global:GameType        = $LastGame
    $global:GameConsole     = $LastConsole

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
    CreateTextBox -X (DPISize 40) -Y (DPISize 30) -Width ($Dialog.Width - (DPISize 100)) -Height ($CloseButton.Top - (DPISize 40)) -Text $text -ReadOnly -Multiline -AddTo $Dialog
    AddTextFileToTextbox -TextBox $textbox -File ($Paths.Games + "\" + $GameType.mode + "\Guide Scene Editor.txt")

    # Show Dialog
    $Dialog.ShowDialog()

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
    $global:CheckHashSum  = $Files.json.sceneEditor.hash
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

    $SceneEditor.Resetting = $True

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

        if ($Files.json.sceneEditor.quest -is [array] -and $Files.json.sceneEditor.quest.Count -gt 0) {
            $vanilla = $True
            for ($i=0; $i -lt $Files.json.sceneEditor.quest.Count; $i++) {
                if ($SceneEditor.Quests[$i+1].Visible -and $SceneEditor.Quests[$i+1].Checked) {
                    $vanilla = $False
                    $file    = $Files.json.sceneEditor.quest[$i].ToLower()
                    while ($file -like "* *" ) { $file = $file.Replace(" ", "_") }
                    ApplyPatch -File $GetROM.decomp -Patch ("Games\" + $GameType.mode + "\Decompressed\Dungeons\" + $file + ".bps") -FilesPath
                    ExtractAllScenes -Current -Quest $Files.json.sceneEditor.quest[$i]
                }
            }
            if ($vanilla) { ExtractAllScenes -Current }
        }
        else { ExtractAllScenes -Current }

        UpdateStatusLabel -Text "Success! The map has been reset." -Editor
        LoadMap $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex]
    }
    else {
        UpdateStatusLabel -Text "Extracting all scenes..." -Editor
        Copy-Item -LiteralPath $GetROM.decomp -Destination $GetROM.cleanDecomp -Force
        ExtractAllScenes

        if ($Files.json.sceneEditor.quest -is [array] -and $Files.json.sceneEditor.quest.Count -gt 0) {
            foreach ($quest in $Files.json.sceneEditor.quest) {
                $file = $quest.ToLower()
                while ($file -like "* *") { $file = $file.Replace(" ", "_") }
                if (TestFile -Path ($Paths.Games + "\" +$GameType.mode  + "\Decompressed\Dungeons\" + $file +".bps") ) {
                    ApplyPatch -File $GetROM.cleanDecomp -Patch ("Games\" + $GameType.mode + "\Decompressed\Dungeons\" + $file + ".bps") -FilesPath -New $GetROM.decomp
                    ExtractAllScenes -Quest $quest
                }
            }
        }

        UpdateStatusLabel -Text "Success! The scenes have been extracted." -Editor
        $SceneEditor.DropScene = $null
        LoadScene $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex]
        $SceneEditor.DropScene = $SceneEditor.Scenes.SelectedIndex
    }

    $SceneEditor.Resetting = $False
    Cleanup

}


#==============================================================================================================================================================================================
function ExtractAllScenes([switch]$Current, [String]$Quest="Normal Quest") {
    
    $global:ByteArrayGame = [System.IO.File]::ReadAllBytes($GetROM.decomp)

    if (!$Current -and $SceneEditor.PatchAll.Checked) {
        RemovePath    ($Paths.Games + "\" + $GameType.mode + "\Editor\Scenes")
        CreateSubPath ($Paths.Games + "\" + $GameType.mode + "\Editor\Scenes")
    }

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

    if (!$Current) { ExportBytes -Offset $Offset -End $End -Output ($Path + "\table.dma") }
    
    for ($i=0; $i -le $Length; $i++) {
        $Start = (Get8Bit $Table[($i*16)+0]) + (Get8Bit $Table[($i*16)+1]) + (Get8Bit $Table[($i*16)+2]) + (Get8Bit $Table[($i*16)+3])
        $End   = (Get8Bit $Table[($i*16)+4]) + (Get8Bit $Table[($i*16)+5]) + (Get8Bit $Table[($i*16)+6]) + (Get8Bit $Table[($i*16)+7])

        if ($Current -and ($i-1) -ne $SceneEditor.Maps.SelectedIndex) { continue }

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

    if (!(IsChecked $SceneEditor.ShiftScenes)) { return }

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
            if ($Settings["Dungeon"][$Scene.Name] -eq $i+2) { $path += "\" + $Files.json.sceneEditor.quest }
        }
    }

    if (!(TestFile -Path ($Paths.Games + "\" + $GameType.mode + "\Editor\" + $Path) -Container)) { return $False }

    $Start = Get24Bit ( (GetDecimal $Offset) )
    $End   = Get24Bit ( (GetDecimal $Start) + ($Length * 16) + 16)

    if (IsChecked $SceneEditor.ShiftScenes) {
        $dmaArray = [System.IO.File]::ReadAllBytes(($Paths.Games + "\" + $GameType.mode + "\Editor\" + $Path + "\table.dma"))
        for ($i=0; $i -lt $dmaArray.Count; $i++) { $ByteArrayGame[(GetDecimal $Start) + $i] = $dmaArray[$i] }
    }

    $table = $ByteArrayGame[(GetDecimal $Start)..(GetDecimal $End)]
    for ($i=0; $i -le $Length; $i++) {
        $offset = (Get8Bit $table[($i*16)+0]) + (Get8Bit $table[($i*16)+1]) + (Get8Bit $table[($i*16)+2]) + (Get8Bit $table[($i*16)+3])
        if ($i -eq 0)   { PatchBytes -Offset $offset -Patch ($Path + "\scene.zscene")             -Editor }
        else            { PatchBytes -Offset $offset -Patch ($Path + "\room_" + ($i-1) + ".zmap") -Editor }
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

    $dma  = $map     + "\table.dma"
    $file = $map     + "\scene.zscene"
    $map += "\room_" + $Index + ".zmap"

    if (!(TestFile -Path $map) -or !(TestFile -Path $file) -or !(TestFile -Path $dma)) { return }

    if (!(IsChecked $SceneEditor.ShiftScenes)) {
        [System.IO.File]::WriteAllBytes($map,  $SceneEditor.MapArray)
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

    [System.IO.File]::WriteAllBytes($map,  $SceneEditor.MapArray)
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
function ShiftMap([uint32]$Offset, [byte]$Add=0, [byte]$Subtract=0) {
    
    if ($Add -gt 0) {
        if ($SceneEditor.MapArray[$Offset+2] + $Add -gt 255) {
            if ($SceneEditor.MapArray[$Offset+1] + 1 -gt 255) {
                $SceneEditor.MapArray[$Offset]   += 1
                $SceneEditor.MapArray[$Offset+1]  = 0
                $SceneEditor.MapArray[$Offset+2] += $Add - 256
            }
            else {
                $SceneEditor.MapArray[$Offset+1]++
                $SceneEditor.MapArray[$Offset+2] += $Add - 256
            }
        }
        else { $SceneEditor.MapArray[$Offset+2] += $Add }
    }
    elseif ($Subtract -gt 0) {
        if ($SceneEditor.MapArray[$Offset+2] - $Subtract -lt 0) {
            if ($SceneEditor.MapArray[$Offset+1] - 1 -lt 0) {
                $SceneEditor.MapArray[$Offset]   -= 1
                $SceneEditor.MapArray[$Offset+1]  = 0
                $SceneEditor.MapArray[$Offset+2] += 256 - $Subtract
            }
            else {
                $SceneEditor.MapArray[$Offset+1]--
                $SceneEditor.MapArray[$Offset+2] += 256 - $Subtract
            }
        }
        else { $SceneEditor.MapArray[$Offset+2] -= $Subtract }
    }

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
        $SceneEditor.BottomPanelActors.Controls.Clear()
        $SceneEditor.BottomPanelObjects.Controls.Clear()
        
        [System.Collections.ArrayList]$SceneEditor.Actors = @()
        [System.Collections.ArrayList]$SceneEditor.Objects = @()

        return
    }

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
    else { LoadMap $Files.json.sceneEditor.scenes[$SceneEditor.Scenes.SelectedIndex] }



    # Load scene file #
    $headerSize = 104
    [System.Collections.ArrayList]$SceneEditor.SceneArray = [System.IO.File]::ReadAllBytes($file)
    $SceneEditor.SceneOffsets          = @()
    $SceneEditor.SceneOffsets         += @{}
    $SceneEditor.SceneOffsets[0].Header= 0

    for ($i=0; $i -lt $headerSize; $i+=8) {
        if ($SceneEditor.SceneArray[$i] -eq 20) { break }

        elseif ($SceneEditor.SceneArray[$i] -eq 0) { # Start Positions List
            $SceneEditor.SceneOffsets[0].PositionsCount      = $SceneEditor.SceneArray[$i + 1]
            $SceneEditor.SceneOffsets[0].PositionsStart      = $SceneEditor.SceneArray[$i + 5] * 65536 + $SceneEditor.SceneArray[$i + 6] * 256 + $SceneEditor.SceneArray[$i + 7]
            $SceneEditor.SceneOffsets[0].PositionsCountIndex = $i + 1
            $SceneEditor.SceneOffsets[0].PositionsIndex      = $i + 5
        }
        elseif ($SceneEditor.SceneArray[$i] -eq 4) { # Map List
            $SceneEditor.SceneOffsets[0].MapCount            = $SceneEditor.SceneArray[$i + 1]
            $SceneEditor.SceneOffsets[0].MapStart            = $SceneEditor.SceneArray[$i + 5] * 65536 + $SceneEditor.SceneArray[$i + 6] * 256 + $SceneEditor.SceneArray[$i + 7]
            $SceneEditor.SceneOffsets[0].MapCountIndex       = $i + 1
            $SceneEditor.SceneOffsets[0].MapIndex            = $i + 5
        }
        elseif ($SceneEditor.SceneArray[$i] -eq 24) { # Alternate Headers
            $SceneEditor.SceneOffsets[0].AlternateStart      = $SceneEditor.SceneArray[$i + 5] * 65536 + $SceneEditor.SceneArray[$i + 6] * 256 + $SceneEditor.SceneArray[$i + 7]
            $SceneEditor.SceneOffsets[0].AlternateIndex      = $i + 5
        }
    }

    if (IsSet $SceneEditor.SceneOffsets[0].AlternateStart) {
        for ($i=$SceneEditor.SceneOffsets[0].AlternateStart; $i -lt $SceneEditor.SceneOffsets[0].PositionsStart; $i+=4) {
            if ($SceneEditor.SceneArray[$i] -ne 2) { continue }

            $SceneEditor.SceneOffsets += @{}
            $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].Header = $SceneEditor.SceneArray[$i + 1] * 65536 + $SceneEditor.SceneArray[$i + 2] * 256 + $SceneEditor.SceneArray[$i + 3]

            for ($j=$SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].Header; $j -lt ($SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].Header + $headerSize); $j+=8) {
                if ($SceneEditor.SceneArray[$j] -eq 20) { break }

                elseif ($SceneEditor.SceneArray[$j] -eq 4) { # Map List
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].MapCount      = $SceneEditor.SceneArray[$j + 1]
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].MapStart      = $SceneEditor.SceneArray[$j + 5] * 65536 + $SceneEditor.SceneArray[$j + 6] * 256 + $SceneEditor.SceneArray[$j + 7]
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].MapCountIndex = $j + 1
                    $SceneEditor.SceneOffsets[$SceneEditor.SceneOffsets.Count-1].MapIndex      = $j + 5
                }
            }
        }
    }

}



#==============================================================================================================================================================================================
function LoadMap([object[]]$Scene) {
    
    $headerSize = 80
    $map = $Paths.Games + "\" + $Files.json.sceneEditor.game + "\Editor\Scenes\" + $Scene.name + "\room_" + $SceneEditor.Maps.SelectedIndex + ".zmap"
    
    if ($Files.json.sceneEditor.quest -is [array] -and $Files.json.sceneEditor.quest.Count -gt 0 -and $Scene.Dungeon -eq 1) {
        for ($i=0; $i -lt $Files.json.sceneEditor.quest.Count; $i++) {
            if ($SceneEditor.Quests[$i+1].Checked) { $map = $Paths.Games + "\" + $Files.json.sceneEditor.game + "\Editor\Scenes\" + $Scene.name + "\" + $Files.json.sceneEditor.quest[$i] + "\room_" + $SceneEditor.Maps.SelectedIndex + ".zmap" }
        }
    }

    if (!(TestFile -Path $map)) { return }

    [System.Collections.ArrayList]$SceneEditor.MapArray = [System.IO.File]::ReadAllBytes($map)
    $items                                              = @("Stage 1")
    $SceneEditor.Offsets                                = @()
    $SceneEditor.Offsets                               += @{}
    $SceneEditor.Offsets[0].Header                      = 0
    $SceneEditor.Offsets[0].FoundActors                 = $False
    $SceneEditor.Offsets[0].FoundObjects                = $False

    for ($i=0; $i -lt $headerSize; $i+=8) {
        if ($SceneEditor.MapArray[$i] -eq 20) { break }

        elseif ($SceneEditor.MapArray[$i] -eq 1) { # Actor List
            $SceneEditor.Offsets[0].ActorCount       = $SceneEditor.MapArray[$i + 1]
            $SceneEditor.Offsets[0].ActorStart       = $SceneEditor.MapArray[$i + 5] * 65536 + $SceneEditor.MapArray[$i + 6] * 256 + $SceneEditor.MapArray[$i + 7]
            $SceneEditor.Offsets[0].ActorCountIndex  = $i + 1
            $SceneEditor.Offsets[0].ActorIndex       = $i + 5
            $SceneEditor.Offsets[0].FoundActors      = $True
        }
        elseif ($SceneEditor.MapArray[$i] -eq 11) { # Objects List
            $SceneEditor.Offsets[0].ObjectCount      = $SceneEditor.MapArray[$i + 1]
            $SceneEditor.Offsets[0].ObjectStart      = $SceneEditor.MapArray[$i + 5] * 65536 + $SceneEditor.MapArray[$i + 6] * 256 + $SceneEditor.MapArray[$i + 7]
            $SceneEditor.Offsets[0].ObjectCountIndex = $i + 1
            $SceneEditor.Offsets[0].ObjectIndex      = $i + 5
            $SceneEditor.Offsets[0].FoundObjects     = $True
        }
        elseif ($SceneEditor.MapArray[$i] -eq 10) { # Mesh List
            $SceneEditor.Offsets[0].MeshStart        = $SceneEditor.MapArray[$i + 5] * 65536 + $SceneEditor.MapArray[$i + 6] * 256 + $SceneEditor.MapArray[$i + 7]
            $SceneEditor.Offsets[0].MeshIndex        = $i + 5
        }
        elseif ($SceneEditor.MapArray[$i] -eq 24) { # Alternate Headers
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

            $SceneEditor.Offsets += @{}
            $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].Header       = $SceneEditor.MapArray[$i + 1] * 65536 + $SceneEditor.MapArray[$i + 2] * 256 + $SceneEditor.MapArray[$i + 3]
            $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].FoundActors  = $False
            $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].FoundObjects = $False

            for ($j=$SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].Header; $j -lt ($SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].Header + $headerSize); $j+=8) {
                if ($SceneEditor.MapArray[$j] -eq 20) { break }

                elseif ($SceneEditor.MapArray[$j] -eq 1) { # Actor List
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].ActorCount       = $SceneEditor.MapArray[$j + 1]
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].ActorStart       = $SceneEditor.MapArray[$j + 5] * 65536 + $SceneEditor.MapArray[$j + 6] * 256 + $SceneEditor.MapArray[$j + 7]
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].ActorCountIndex  = $j + 1
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].ActorIndex       = $j + 5
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].FoundActors      = $True
                }
                elseif ($SceneEditor.MapArray[$j] -eq 11) { # Objects List
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].ObjectCount      = $SceneEditor.MapArray[$j + 1]
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].ObjectStart      = $SceneEditor.MapArray[$j + 5] * 65536 + $SceneEditor.MapArray[$j + 6] * 256 + $SceneEditor.MapArray[$j + 7]
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].ObjectCountIndex = $j + 1
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].ObjectIndex      = $j + 5
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].FoundObjects     = $True
                }
                elseif ($SceneEditor.MapArray[$j] -eq 10) { # Mesh List
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].MeshStart        = $SceneEditor.MapArray[$j + 5] * 65536 + $SceneEditor.MapArray[$j + 6] * 256 + $SceneEditor.MapArray[$j + 7]
                    $SceneEditor.Offsets[$SceneEditor.Offsets.Count-1].MeshIndex        = $j + 5
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



#==============================================================================================================================================================================================
function GetHeader()             { return $SceneEditor.Offsets[$SceneEditor.Headers.SelectedIndex].Header                                                                                   }
function GetActorCount()         { return $SceneEditor.Offsets[$SceneEditor.Headers.SelectedIndex].ActorCount                                                                               }
function GetActorStart()         { return $SceneEditor.Offsets[$SceneEditor.Headers.SelectedIndex].ActorStart                                                                               }
function GetActorEnd()           { return $SceneEditor.Offsets[$SceneEditor.Headers.SelectedIndex].ActorStart + ($SceneEditor.Offsets[$SceneEditor.Headers.SelectedIndex].ActorCount * 16)  }
function GetActorCountIndex()    { return $SceneEditor.Offsets[$SceneEditor.Headers.SelectedIndex].ActorCountIndex                                                                          }
function GetActorIndex()         { return $SceneEditor.Offsets[$SceneEditor.Headers.SelectedIndex].ActorIndex                                                                               }
function GetObjectCount()        { return $SceneEditor.Offsets[$SceneEditor.Headers.SelectedIndex].ObjectCount                                                                              }
function GetObjectStart()        { return $SceneEditor.Offsets[$SceneEditor.Headers.SelectedIndex].ObjectStart                                                                              }
function GetObjectEnd()          { return $SceneEditor.Offsets[$SceneEditor.Headers.SelectedIndex].ObjectStart + ($SceneEditor.Offsets[$SceneEditor.Headers.SelectedIndex].ObjectCount * 2) }
function GetObjectCountIndex()   { return $SceneEditor.Offsets[$SceneEditor.Headers.SelectedIndex].ObjectCountIndex                                                                         }
function GetObjectIndex()        { return $SceneEditor.Offsets[$SceneEditor.Headers.SelectedIndex].ObjectIndex                                                                              }
function GetMeshStart()          { return $SceneEditor.Offsets[$SceneEditor.Headers.SelectedIndex].MeshStart                                                                                }
function GetMeshIndex()          { return $SceneEditor.Offsets[$SceneEditor.Headers.SelectedIndex].MeshIndex                                                                                }
function GetFoundActors()        { return $SceneEditor.Offsets[$SceneEditor.Headers.SelectedIndex].FoundActors                                                                              }
function GetFoundObjects()       { return $SceneEditor.Offsets[$SceneEditor.Headers.SelectedIndex].FoundObjects                                                                             }

function GetMapCount()           { return $SceneEditor.SceneOffsets.MapCount                                            }
function GetMapStart()           { return $SceneEditor.SceneOffsets.MapStart                                            }
function GetMapEnd()             { return $SceneEditor.SceneOffsets.MapStart + ($SceneEditor.SceneOffsets.MapCount * 8) }
function GetMapCountIndex()      { return $SceneEditor.SceneOffsets.MapCountIndex                                       }
function GetMapIndex()           { return $SceneEditor.SceneOffsets.MapIndex                                            }

function GetTotalObjects() {

    $objects = 0
    foreach ($offset in $SceneEditor.Offsets) { $objects += $offset.ObjectCount }
    return $objects

}



#==============================================================================================================================================================================================
function LoadHeader([object[]]$Scene) {
    
    $SceneEditor.BottomPanelObjects.Controls.Clear()
    [System.Collections.ArrayList]$SceneEditor.Objects = @()

    if (!(IsSet $SceneEditor.Offsets)) { return }

    if (GetFoundActors) {
        $actorTypes = @("Enemy", "Boss", "NPC", "Animal", "Cutscene", "Object", "Area", "Effect", "Unused", "Other")
        $SceneEditor.ActorList = @{}
        for ($i=0; $i -lt $actorTypes.Count-1; $i++) { $SceneEditor.ActorList[$i]  = $Files.json.sceneEditor.actors  | where { $_.Type -eq $actorTypes[$i] } }
        $SceneEditor.ActorList[$actorTypes.Count-1]  = $Files.json.sceneEditor.actors  | where { $_.Type -eq $null }
    }

    if (GetFoundObjects) {
        $objectTypes = @("Enemy", "Boss", "NPC", "Animal", "Object", "Model", "Area", "Animation", "Unused", "Other")
        $SceneEditor.ObjectList = @{}
        for ($i=0; $i -lt $objectTypes.Count-1; $i++) { $SceneEditor.ObjectList[$i] = $Files.json.sceneEditor.objects | where { $_.Type -eq $objectTypes[$i] } }
        $SceneEditor.ObjectList[$objectTypes.Count-1] = $Files.json.sceneEditor.objects | where { $_.Type -eq $null }

        for ([byte]$i=0; $i -lt (GetObjectCount); $i++) { AddObject }
    }

    $SceneEditor.Tab = $null
    if ( (IsSet $Settings["Core"]["Editor.Tab." + $Files.json.sceneEditor.parse]) -and $SceneEditor.FirstLoad)   { LoadTab -Tab $Settings["Core"]["Editor.Tab." + $Files.json.sceneEditor.parse] }
    else                                                                                                         { LoadTab -Tab 1 }

    $file = $Paths.Games + "\" + $Game + "\Maps\" + $SceneEditor.Scenes.Text + "\Stage " + ($SceneEditor.Headers.SelectedIndex+1) + "\room_" + $SceneEditor.Maps.SelectedIndex + ".jpg"
    if (TestFile $file) { SetBitMap -Path $file -Box $SceneEditor.MapPreviewImage }
    else {
        $file = $Paths.Games + "\" + $Game + "\Maps\" + $SceneEditor.Scenes.Text + "\room_" + $SceneEditor.Maps.SelectedIndex + ".jpg"
        if (TestFile $file) { SetBitMap -Path $file -Box $SceneEditor.MapPreviewImage }
        else {
            $file = $Paths.Games + "\" + $Game + "\Maps\default.jpg"
            if (TestFile $file) { SetBitMap -Path $file -Box $SceneEditor.MapPreviewImage } else { $SceneEditor.MapPreviewImage.Image = $null }
        }
    }

    if ($Files.json.sceneEditor.quest -is [array] -and $Files.json.sceneEditor.quest.Count -gt 0) {
        foreach ($elem in $SceneEditor.Quests) { $elem.Enabled = (GetFoundActors) -or (GetFoundObjects) }
    }

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

    for ([byte]$i=$start; $i -lt $end; $i++) {
        if ($i -ge (GetActorCount)) { break }
        AddActor
    }

    $SceneEditor.BottomPanelActors.AutoScroll        = $True
    $SceneEditor.BottomPanelActors.AutoScrollMargin  = New-Object System.Drawing.Size(0, 0)
    $SceneEditor.BottomPanelActors.AutoScrollMinSize = New-Object System.Drawing.Size(0, 0)

}



#==============================================================================================================================================================================================
function DeleteActor() {
    
    if ((GetActorCount) -eq 0) { return }

    $SceneEditor.Offsets[$SceneEditor.Headers.SelectedIndex].ActorCount--
    $SceneEditor.MapArray[(GetActorCountIndex)]--
    $SceneEditor.MapArray.RemoveRange((GetActorEnd), 16)

    for ($i=$SceneEditor.Offsets[0].AlternateStart; $i-lt $SceneEditor.Offsets[0].ObjectStart; $i+= 4) {
        if ($SceneEditor.MapArray[$i] -ne 3) { continue }
        $value = $SceneEditor.MapArray[$i+1] * 65536 + $SceneEditor.MapArray[$i+2] * 256 + $SceneEditor.MapArray[$i+3]
        if ($value -gt (GetHeader)) { ShiftMap -Offset ($i+1) -Subtract 16 }
    }

    for ($i=1; $i -lt $SceneEditor.Offsets.Header.Count; $i++) {
        if ($SceneEditor.Offsets[$i].Header -le (GetHeader)) { continue }

        $SceneEditor.Offsets[$i].Header -= 16

        if ($SceneEditor.Offsets[$i].FoundActors) {
            $SceneEditor.Offsets[$i].ActorStart       -= 16
            $SceneEditor.Offsets[$i].ActorCountIndex  -= 16
            $SceneEditor.Offsets[$i].ActorIndex       -= 16
            ShiftMap -Offset $SceneEditor.Offsets[$i].ActorIndex  -Subtract 16
        }

        if ($SceneEditor.Offsets[$i].FoundObjects) {
            $SceneEditor.Offsets[$i].ObjectStart      -= 16
            $SceneEditor.Offsets[$i].ObjectCountIndex -= 16
            $SceneEditor.Offsets[$i].ObjectIndex      -= 16
            ShiftMap -Offset $SceneEditor.Offsets[$i].ObjectIndex -Subtract 16
        }

        $SceneEditor.Offsets[$i].MeshIndex            -= 16
        if ($SceneEditor.Headers.SelectedIndex -eq 0) {
            $SceneEditor.Offsets[$i].MeshStart        -= 16
            ShiftMap -Offset $SceneEditor.Offsets[$i].MeshIndex   -Subtract 16
        }
        
    }

    if ($SceneEditor.Headers.SelectedIndex -eq 0) {
        $SceneEditor.Offsets[0].MeshStart -= 16
        ShiftMap -Offset $SceneEditor.Offsets[0].MeshIndex     -Subtract 16
        ShiftMap -Offset ($SceneEditor.Offsets[0].MeshStart+5) -Subtract 16
        ShiftMap -Offset ($SceneEditor.Offsets[0].MeshStart+9) -Subtract 16
    }

    $meshStart = $SceneEditor.MapArray[(GetMeshStart) + 5] * 65536 + $SceneEditor.MapArray[(GetMeshStart) + 6]  * 256 + $SceneEditor.MapArray[(GetMeshStart) + 7]
    $meshEnd   = $SceneEditor.MapArray[(GetMeshStart) + 9] * 65536 + $SceneEditor.MapArray[(GetMeshStart) + 10] * 256 + $SceneEditor.MapArray[(GetMeshStart) + 11]
    $meshes    = @()
    
    for ($i=$meshStart; $i -lt $meshEnd; $i+= 16) {
        for ($j=8; $j -le 12; $j+= 4) {
            if ($SceneEditor.MapArray[$i+$j] -eq 3) {
                $value =  $SceneEditor.MapArray[$i+$j+1] * 65536 + $SceneEditor.MapArray[$i+$j+2] * 256 + $SceneEditor.MapArray[$i+$j+3]
                if ($value -gt $SceneEditor.Offsets[$SceneEditor.Offsets.Header.Count-1].Header -or $value -le $SceneEditor.MapArray.Count) {
                    ShiftMap -Offset ($i+$j+1) -Subtract 16
                    $meshes += $SceneEditor.MapArray[$i+$j+1] * 65536 + $SceneEditor.MapArray[$i+$j+2] * 256 + $SceneEditor.MapArray[$i+$j+3]
                }
            }
        }
    }

    $meshes = $meshes | Sort-Object
    for ($i=$meshes[0]; $i -lt $meshes[0]+512; $i+=4) {
            if ($SceneEditor.MapArray[$i] -eq 3) {
                $vtx = $SceneEditor.MapArray[$i+1] * 65536 + $SceneEditor.MapArray[$i+2] * 256 + $SceneEditor.MapArray[$i+3]
                break
            }
        }

    for ($i=$vtx; $i -lt $SceneEditor.MapArray.Count; $i+=4) {
        if ($SceneEditor.MapArray[$i] -eq 3) {
            $value = $SceneEditor.MapArray[$i+1] * 65536 + $SceneEditor.MapArray[$i+2] * 256 + $SceneEditor.MapArray[$i+3]
            if ($value -gt $SceneEditor.Offsets[$SceneEditor.Offsets.Header.Count-1].Header -and $value -lt $SceneEditor.MapArray.Count) { ShiftMap -Offset ($i+1) -Subtract 16 }
        }
    }

    $SceneEditor.Tab = $null
    LoadTab -Tab 1

}



#==============================================================================================================================================================================================
function InsertActor() {
    
    if ((GetActorCount) -ge 255) { return }

    if     ($GameType.mode -eq "Ocarina of Time")   { $SceneEditor.MapArray.InsertRange((GetActorEnd), @(0, 2,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0,   0, 0,   0, 0)) }
    elseif ($GameType.mode -eq "Majora's Mask")     { $SceneEditor.MapArray.InsertRange((GetActorEnd), @(0, 25, 0, 0, 0, 0, 0, 0, 0, 7, 0, 127, 0, 127, 0, 0)) }
    else                                            { $SceneEditor.MapArray.InsertRange((GetActorEnd), @(0, 0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0,   0, 0,   0, 0)) }
    $SceneEditor.Offsets[$SceneEditor.Headers.SelectedIndex].ActorCount++
    $SceneEditor.MapArray[(GetActorCountIndex)]++

    if (IsSet $SceneEditor.Offsets[0].AlternateStart) {
        for ($i=$SceneEditor.Offsets[0].AlternateStart; $i-lt $SceneEditor.Offsets[0].ObjectStart; $i+= 4) {
            if ($SceneEditor.MapArray[$i] -ne 3) { continue }
            $value = $SceneEditor.MapArray[$i+1] * 65536 + $SceneEditor.MapArray[$i+2] * 256 + $SceneEditor.MapArray[$i+3]
            if ($value -gt (GetHeader)) { ShiftMap -Offset ($i+1) -Add 16 }
        }
    }

    for ($i=1; $i -lt $SceneEditor.Offsets.Header.Count; $i++) {
        if ($SceneEditor.Offsets[$i].Header -le (GetHeader)) { continue }

        $SceneEditor.Offsets[$i].Header += 16

        if ($SceneEditor.Offsets[$i].FoundActors) {
            $SceneEditor.Offsets[$i].ActorStart       += 16
            $SceneEditor.Offsets[$i].ActorCountIndex  += 16
            $SceneEditor.Offsets[$i].ActorIndex       += 16
            ShiftMap -Offset $SceneEditor.Offsets[$i].ActorIndex  -Add 16
        }

        if ($SceneEditor.Offsets[$i].FoundObjects) {
            $SceneEditor.Offsets[$i].ObjectStart      += 16
            $SceneEditor.Offsets[$i].ObjectCountIndex += 16
            $SceneEditor.Offsets[$i].ObjectIndex      += 16
            ShiftMap -Offset $SceneEditor.Offsets[$i].ObjectIndex -Add 16
        }

        $SceneEditor.Offsets[$i].MeshIndex            += 16
        if ($SceneEditor.Headers.SelectedIndex -eq 0) {
            $SceneEditor.Offsets[$i].MeshStart        += 16
            ShiftMap -Offset $SceneEditor.Offsets[$i].MeshIndex   -Add 16
        }
        
    }

    if ($SceneEditor.Headers.SelectedIndex -eq 0) {
        $SceneEditor.Offsets[0].MeshStart += 16
        ShiftMap -Offset $SceneEditor.Offsets[0].MeshIndex     -Add 16
        ShiftMap -Offset ($SceneEditor.Offsets[0].MeshStart+5) -Add 16
        ShiftMap -Offset ($SceneEditor.Offsets[0].MeshStart+9) -Add 16
    }

    $meshStart = $SceneEditor.MapArray[(GetMeshStart) + 5] * 65536 + $SceneEditor.MapArray[(GetMeshStart) + 6]  * 256 + $SceneEditor.MapArray[(GetMeshStart) + 7]
    $meshEnd   = $SceneEditor.MapArray[(GetMeshStart) + 9] * 65536 + $SceneEditor.MapArray[(GetMeshStart) + 10] * 256 + $SceneEditor.MapArray[(GetMeshStart) + 11]
    $meshes    = @()

    for ($i=$meshStart; $i -lt $meshEnd; $i+= 16) {
        for ($j=8; $j -le 12; $j+= 4) {
            if ($SceneEditor.MapArray[$i+$j] -eq 3) {
                $value =  $SceneEditor.MapArray[$i+$j+1] * 65536 + $SceneEditor.MapArray[$i+$j+2] * 256 + $SceneEditor.MapArray[$i+$j+3]
                if ($value -gt $SceneEditor.Offsets[$SceneEditor.Offsets.Header.Count-1].Header -or $value -le $SceneEditor.MapArray.Count) {
                    ShiftMap -Offset ($i+$j+1) -Add 16
                    $meshes += $SceneEditor.MapArray[$i+$j+1] * 65536 + $SceneEditor.MapArray[$i+$j+2] * 256 + $SceneEditor.MapArray[$i+$j+3]
                }
            }
        }
    }

    $meshes = $meshes | Sort-Object
    for ($i=$meshes[0]; $i -lt $meshes[0]+512; $i+=4) {
            if ($SceneEditor.MapArray[$i] -eq 3) {
                $vtx = $SceneEditor.MapArray[$i+1] * 65536 + $SceneEditor.MapArray[$i+2] * 256 + $SceneEditor.MapArray[$i+3]
                break
            }
        }

    for ($i=$vtx; $i -lt $SceneEditor.MapArray.Count; $i+=4) {
        if ($SceneEditor.MapArray[$i] -eq 3) {
            $value = $SceneEditor.MapArray[$i+1] * 65536 + $SceneEditor.MapArray[$i+2] * 256 + $SceneEditor.MapArray[$i+3]
            if ($value -gt $SceneEditor.Offsets[$SceneEditor.Offsets.Header.Count-1].Header -and $value -lt $SceneEditor.MapArray.Count) { ShiftMap -Offset ($i+1) -Add 16 }
        }
    }

    $SceneEditor.Tab = $null
    LoadTab -Tab 1

}



#==============================================================================================================================================================================================
function DeleteObject() {
    
    if ((GetObjectCount) -eq 0) { return }
    $SceneEditor.BottomPanelObjects.AutoScroll = $False

    $SceneEditor.Offsets[$SceneEditor.Headers.SelectedIndex].ObjectCount--
    $SceneEditor.MapArray[(GetObjectCountIndex)]--
    $SceneEditor.BottomPanelObjects.Controls.Remove($SceneEditor.Objects[$SceneEditor.Objects.Count-1].Panel)
    $SceneEditor.Objects.RemoveAt($SceneEditor.Objects.Count-1)

    if     ((GetObjectCount) % 2 -eq 1) { $SceneEditor.MapArray[(GetObjectEnd)] = $SceneEditor.MapArray[(GetObjectEnd)+1] = 0 }
    elseif ((GetObjectCount) % 2 -eq 0) {
        $SceneEditor.MapArray.RemoveRange((GetObjectEnd), 4)
        $SceneEditor.Offsets[$SceneEditor.Headers.SelectedIndex].ActorStart -= 4
        ShiftMap -Offset (GetActorIndex) -Subtract 4

        for ($i=$SceneEditor.Offsets[0].AlternateStart; $i-lt $SceneEditor.Offsets[0].ObjectStart; $i+= 4) {
            if ($SceneEditor.MapArray[$i] -ne 3) { continue }
            $value = $SceneEditor.MapArray[$i+1] * 65536 + $SceneEditor.MapArray[$i+2] * 256 + $SceneEditor.MapArray[$i+3]
            if ($value -gt (GetHeader)) { ShiftMap -Offset ($i+1) -Subtract 4 }
        }

        for ($i=1; $i -lt $SceneEditor.Offsets.Header.Count; $i++) {
            if ($SceneEditor.Offsets[$i].Header -le (GetHeader)) { continue }

            $SceneEditor.Offsets[$i].Header -= 4

            if ($SceneEditor.Offsets[$i].FoundActors) {
                $SceneEditor.Offsets[$i].ActorStart       -= 4
                $SceneEditor.Offsets[$i].ActorCountIndex  -= 4
                $SceneEditor.Offsets[$i].ActorIndex       -= 4
                ShiftMap -Offset $SceneEditor.Offsets[$i].ActorIndex  -Subtract 4
            }

            if ($SceneEditor.Offsets[$i].FoundObjects) {
                $SceneEditor.Offsets[$i].ObjectStart      -= 4
                $SceneEditor.Offsets[$i].ObjectCountIndex -= 4
                $SceneEditor.Offsets[$i].ObjectIndex      -= 4
                ShiftMap -Offset $SceneEditor.Offsets[$i].ObjectIndex -Subtract 4
            }

            $SceneEditor.Offsets[$i].MeshIndex            -= 4
            if ($SceneEditor.Headers.SelectedIndex -eq 0) {
                $SceneEditor.Offsets[$i].MeshStart        -= 4
                ShiftMap -Offset $SceneEditor.Offsets[$i].MeshIndex   -Subtract 4
            }
        }

        if ($SceneEditor.Headers.SelectedIndex -eq 0) {
            $SceneEditor.Offsets[0].MeshStart -= 4
            ShiftMap -Offset $SceneEditor.Offsets[0].MeshIndex     -Subtract 4
            ShiftMap -Offset ($SceneEditor.Offsets[0].MeshStart+5) -Subtract 4
            ShiftMap -Offset ($SceneEditor.Offsets[0].MeshStart+9) -Subtract 4
        }

        $meshStart = $SceneEditor.MapArray[(GetMeshStart) + 5] * 65536 + $SceneEditor.MapArray[(GetMeshStart) + 6]  * 256 + $SceneEditor.MapArray[(GetMeshStart) + 7]
        $meshEnd   = $SceneEditor.MapArray[(GetMeshStart) + 9] * 65536 + $SceneEditor.MapArray[(GetMeshStart) + 10] * 256 + $SceneEditor.MapArray[(GetMeshStart) + 11]
        $meshes    = @()
        
        for ($i=$meshStart; $i -lt $meshEnd; $i+= 16) {
            for ($j=8; $j -le 12; $j+= 4) {
                if ($SceneEditor.MapArray[$i+$j] -eq 3) {
                    $value =  $SceneEditor.MapArray[$i+$j+1] * 65536 + $SceneEditor.MapArray[$i+$j+2] * 256 + $SceneEditor.MapArray[$i+$j+3]
                    if ($value -gt $SceneEditor.Offsets[$SceneEditor.Offsets.Header.Count-1].Header -or $value -le $SceneEditor.MapArray.Count) {
                        if ((GetTotalObjects) % 4 -eq 3) { ShiftMap -Offset ($i+$j+1) -Subtract 8 }
                        $meshes += $SceneEditor.MapArray[$i+$j+1] * 65536 + $SceneEditor.MapArray[$i+$j+2] * 256 + $SceneEditor.MapArray[$i+$j+3]
                    }
                }
            }
        }

        $meshes = $meshes | Sort-Object
        for ($i=$meshes[0]; $i -lt $meshes[0]+512; $i+=4) {
            if ($SceneEditor.MapArray[$i] -eq 3) {
                $vtx = $SceneEditor.MapArray[$i+1] * 65536 + $SceneEditor.MapArray[$i+2] * 256 + $SceneEditor.MapArray[$i+3]
                break
            }
        }

        if     ((GetTotalObjects) % 4 -eq 1) { $SceneEditor.MapArray.InsertRange($vtx-4, @(0, 0, 0, 0)) }
        elseif ((GetTotalObjects) % 4 -eq 3) {
            $SceneEditor.MapArray.RemoveRange($vtx-8, 4)
            $SceneEditor.MapArray.InsertRange($SceneEditor.MapArray.Count, @(0, 0, 0, 0, 0, 0, 0, 0))
            for ($i=$vtx; $i -lt $SceneEditor.MapArray.Count; $i+=4) {
                if ($SceneEditor.MapArray[$i] -eq 3) {
                    $value = $SceneEditor.MapArray[$i+1] * 65536 + $SceneEditor.MapArray[$i+2] * 256 + $SceneEditor.MapArray[$i+3]
                    if ($value -ge $SceneEditor.Offsets[$SceneEditor.Offsets.Header.Count-1].Header -and $value -lt $SceneEditor.MapArray.Count) { ShiftMap -Offset ($i+1) -Subtract 8 }
                }
            }
        }
    }

    $SceneEditor.BottomPanelObjects.AutoScroll        = $True
    $SceneEditor.BottomPanelObjects.AutoScrollMargin  = New-Object System.Drawing.Size(0, 0)
    $SceneEditor.BottomPanelObjects.AutoScrollMinSize = New-Object System.Drawing.Size(0, 0)

}



#==============================================================================================================================================================================================
function InsertObject() {
    
    if ((GetObjectCount) -ge $Files.json.sceneEditor.max_objects) { return }
    $SceneEditor.BottomPanelObjects.AutoScroll = $False

    $SceneEditor.Offsets[$SceneEditor.Headers.SelectedIndex].ObjectCount++
    $SceneEditor.MapArray[(GetObjectCountIndex)]++

    if ((GetObjectCount) % 2 -eq 1) {
        $SceneEditor.MapArray.InsertRange((GetObjectEnd)-4, @(0, 0, 0, 0))
        $SceneEditor.Offsets[$SceneEditor.Headers.SelectedIndex].ActorStart += 4
        ShiftMap -Offset (GetActorIndex) -Add 4

        for ($i=$SceneEditor.Offsets[0].AlternateStart; $i-lt $SceneEditor.Offsets[0].ObjectStart; $i+= 4) {
            if ($SceneEditor.MapArray[$i] -ne 3) { continue }
            $value = $SceneEditor.MapArray[$i+1] * 65536 + $SceneEditor.MapArray[$i+2] * 256 + $SceneEditor.MapArray[$i+3]
            if ($value -gt (GetHeader)) { ShiftMap -Offset ($i+1) -Add 4 }
        }

        for ($i=1; $i -lt $SceneEditor.Offsets.Header.Count; $i++) {
            if ($SceneEditor.Offsets[$i].Header -le (GetHeader)) { continue }

            $SceneEditor.Offsets[$i].Header += 4

            if ($SceneEditor.Offsets[$i].FoundActors) {
                $SceneEditor.Offsets[$i].ActorStart       += 4
                $SceneEditor.Offsets[$i].ActorCountIndex  += 4
                $SceneEditor.Offsets[$i].ActorIndex       += 4
                ShiftMap -Offset $SceneEditor.Offsets[$i].ActorIndex  -Add 4
            }

            if ($SceneEditor.Offsets[$i].FoundObjects) {
                $SceneEditor.Offsets[$i].ObjectStart      += 4
                $SceneEditor.Offsets[$i].ObjectCountIndex += 4
                $SceneEditor.Offsets[$i].ObjectIndex      += 4
                ShiftMap -Offset $SceneEditor.Offsets[$i].ObjectIndex -Add 4
            }

            $SceneEditor.Offsets[$i].MeshIndex            += 4
            if ($SceneEditor.Headers.SelectedIndex -eq 0) {
                $SceneEditor.Offsets[$i].MeshStart        += 4
                ShiftMap -Offset $SceneEditor.Offsets[$i].MeshIndex   -Add 4
            }
        }

        if ($SceneEditor.Headers.SelectedIndex -eq 0) {
            $SceneEditor.Offsets[0].MeshStart += 4
            ShiftMap -Offset $SceneEditor.Offsets[0].MeshIndex     -Add 4
            ShiftMap -Offset ($SceneEditor.Offsets[0].MeshStart+5) -Add 4
            ShiftMap -Offset ($SceneEditor.Offsets[0].MeshStart+9) -Add 4
        }

        $meshStart = $SceneEditor.MapArray[(GetMeshStart) + 5] * 65536 + $SceneEditor.MapArray[(GetMeshStart) + 6]  * 256 + $SceneEditor.MapArray[(GetMeshStart) + 7]
        $meshEnd   = $SceneEditor.MapArray[(GetMeshStart) + 9] * 65536 + $SceneEditor.MapArray[(GetMeshStart) + 10] * 256 + $SceneEditor.MapArray[(GetMeshStart) + 11]
        $meshes    = @()
        
        for ($i=$meshStart; $i -lt $meshEnd; $i+= 16) {
            for ($j=8; $j -le 12; $j+= 4) {
                if ($SceneEditor.MapArray[$i+$j] -eq 3) {
                    $value =  $SceneEditor.MapArray[$i+$j+1] * 65536 + $SceneEditor.MapArray[$i+$j+2] * 256 + $SceneEditor.MapArray[$i+$j+3]
                    if ($value -gt $SceneEditor.Offsets[$SceneEditor.Offsets.Header.Count-1].Header -or $value -le $SceneEditor.MapArray.Count) {
                        if ((GetTotalObjects) % 4 -eq 0) { ShiftMap -Offset ($i+$j+1) -Add 8 }
                        $meshes += $SceneEditor.MapArray[$i+$j+1] * 65536 + $SceneEditor.MapArray[$i+$j+2] * 256 + $SceneEditor.MapArray[$i+$j+3]
                    }
                }
            }
        }

        $meshes = $meshes | Sort-Object
        for ($i=$meshes[0]; $i -lt $meshes[0]+512; $i+=4) {
            if ($SceneEditor.MapArray[$i] -eq 3) {
                $vtx = $SceneEditor.MapArray[$i+1] * 65536 + $SceneEditor.MapArray[$i+2] * 256 + $SceneEditor.MapArray[$i+3]
                break
            }
        }

        if ((GetTotalObjects) % 4 -eq 0) {
            $SceneEditor.MapArray.InsertRange($vtx, @(0, 0, 0, 0))
            $SceneEditor.MapArray.RemoveRange($SceneEditor.MapArray.Count-8, 8)
            for ($i=$vtx; $i -lt $SceneEditor.MapArray.Count; $i+=4) {
                if ($SceneEditor.MapArray[$i] -eq 3) {
                    $value = $SceneEditor.MapArray[$i+1] * 65536 + $SceneEditor.MapArray[$i+2] * 256 + $SceneEditor.MapArray[$i+3]
                    if ($value -ge $SceneEditor.Offsets[$SceneEditor.Offsets.Header.Count-1].Header -and $value -lt $SceneEditor.MapArray.Count) { ShiftMap -Offset ($i+1) -Add 8 }
                }
            }
        }
        elseif ((GetTotalObjects) % 4 -eq 2) { $SceneEditor.MapArray.RemoveRange($vtx-8, 4) }
    }

    AddObject

    $SceneEditor.BottomPanelObjects.AutoScroll        = $True
    $SceneEditor.BottomPanelObjects.AutoScrollMargin  = New-Object System.Drawing.Size(0, 0)
    $SceneEditor.BottomPanelObjects.AutoScrollMinSize = New-Object System.Drawing.Size(0, 0)

}



#==============================================================================================================================================================================================
function AddActor() {
    
    $index      = $SceneEditor.Actors.Count + ($SceneEditor.Tab-1) * 50
    $default    = 0
    $id         = Get16Bit ($SceneEditor.MapArray[(GetActorStart) + $index * 16] * 256 + $SceneEditor.MapArray[(GetActorStart) + 1 + $index * 16]) 
    $reset      = "0000"
    $actorTypes = @("Enemy", "Boss", "NPC", "Animal", "Cutscene", "Object", "Area", "Effect", "Unused", "Other")
    $id         = $SceneEditor.MapArray[(GetActorStart) + $index * 16] * 256 + $SceneEditor.MapArray[(GetActorStart) + 1 + $index * 16]
    if ($GameType.mode -eq "Majora's Mask") { $id = $id -band 4095 }
    $id         = Get16Bit $id

    $actor      = @{}
    $SceneEditor.Actors.Add($actor)

    if ($GameType.mode -eq "Majora's Mask") { $height += 25 } else { $height = 0 }
    $actor.Panel                = CreatePanel -X (DPISize 5)                  -Y ( (DPISize (70 + $height)) * ($SceneEditor.Actors.Count-1) + (DPISize 5) ) -Width ($SceneEditor.BottomPanelActors.Width - (DPISize 25))  -Height (DPISize (70 + $height))       -AddTo $SceneEditor.BottomPanelActors
    $actor.ParamsPanel          = CreatePanel -X (DPISize 220)                                                                                              -Width ($SceneEditor.BottomPanelActors.Width - (DPISize 245)) -Height (DPISize 25)                   -AddTo $actor.Panel
    $actor.CoordinatesPanel     = CreatePanel -X $actor.ParamsPanel.Left      -Y $actor.ParamsPanel.Bottom                                                  -Width $actor.ParamsPanel.Width                               -Height $actor.ParamsPanel.Height      -AddTo $actor.Panel
    if ($GameType.mode -eq "Majora's Mask") {
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
    if ($Settings.Debug.SceneEditorChecks -eq $True) { $label = CreateLabel -Y (DPISize 28) -Width (DPISize 55)  -Height (DPISize 20) -Text ("ID: " + $id) -AddTo $actor.Panel }

    if ($default -gt 0) {
        $actor.Name += CreateComboBox -X (DPISize 65) -Width (DPISize 155) -Height (DPISize 20) -Default $default -Items $SceneEditor.ActorList[$x].name -AddTo $actor.Panel
        Add-Member -InputObject $actor.name -NotePropertyMembers @{ TabEntry = ($SceneEditor.Actors.Count-1); Index = $index; ListIndex = $x; Label = $label }
        $actor.Params      = LoadActor       -Actor $SceneEditor.ActorList[$x][$y] -Count $index
        $actor.Coordinates = LoadCoordinates -Actor $SceneEditor.ActorList[$x][$y] -Count $index
        if ($GameType.mode -eq "Majora's Mask") { $actor.SpawnTimes = LoadSpawnTimes -Actor $SceneEditor.ActorList[$x][$y] -Count $index }
    }
    else {
        $actor.Name        += CreateComboBox -X (DPISize 65) -Width (DPISize 155) -Height (DPISize 20) -AddTo $actor.Panel
        $actor.Name.Enabled = $False
        
        Add-Member -InputObject $actor.name -NotePropertyMembers @{ TabEntry = ($SceneEditor.Actors.Count-1); Index = $index; ListIndex = 0; Label = $label }
        $actor.Coordinates = LoadCoordinates -Actor $null -Count $index
        if ($GameType.mode -eq "Majora's Mask") { $actor.SpawnTimes = LoadSpawnTimes -Actor $null -Count $index }
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

        if ($GameType.mode -eq "Majora's Mask") {
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

    $actor.types.Add_SelectedIndexChanged({
        $SceneEditor.Actors[$this.TabEntry].Name.Items.Clear()
        $SceneEditor.Actors[$this.TabEntry].Name.Items.AddRange($SceneEditor.ActorList[$this.SelectedIndex].name)
        $SceneEditor.Actors[$this.TabEntry].Name.Enabled       = $True
        $SceneEditor.Actors[$this.TabEntry].Name.ListIndex     = $this.SelectedIndex
        $SceneEditor.Actors[$this.TabEntry].Name.SelectedIndex = 0
    })

    $actor.Name.Add_SelectedIndexChanged({
        $SceneEditor.Actors[$this.TabEntry].ParamsPanel.Controls.Clear()
        $SceneEditor.Actors[$this.TabEntry].CoordinatesPanel.Controls.Clear()
        if ($GameType.mode -eq "Majora's Mask") { $SceneEditor.Actors[$this.TabEntry].TimesPanel.Controls.Clear() }
        $SceneEditor.Actors[$this.TabEntry].Params      = @()
        $SceneEditor.Actors[$this.TabEntry].Coordinates = @()
        
        foreach ($item in $SceneEditor.ActorList[$this.ListIndex]) {
            if ($item.name -ne $this.text)   { continue }
            if (IsSet $item.default)         { $reset    = $item.default   } else { $reset    = "0000" }
            if (IsSet $item.default_x)       { $defaultX = $item.default_x } else { $defaultX = 0      }
            if (IsSet $item.default_y)       { $defaultY = $item.default_y } else { $defaultY = 0      }
            if (IsSet $item.default_z)       { $defaultZ = $item.default_z } else { $defaultZ = 0      }
            $id              = $item.ID
            $this.Label.Text = "ID: " + $id

            if ($GameType.mode -eq "Majora's Mask") {
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
            if ($GameType.mode -eq "Majora's Mask") { $SceneEditor.Actors[$this.TabEntry].SpawnTimes = LoadSpawnTimes -Actor $item -Count $this.Index }
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

        $value     = $SceneEditor.MapArray[$index - $rotation] * 256 + $SceneEditor.MapArray[$index + 1 - $rotation]
        $previousX = $LastX
        if ($GameType.mode -eq "Majora's Mask" -and $rotation -gt 0) { $value = ($value -band 0xFF80) -shr 7 }
        
        if ($Actor.params[$i][0].pos -gt 0) {
            $elem = $params[$Actor.params[$i][0].pos - 1]
            if ($elem -is [System.Windows.Forms.ComboBox])   { $LastX = $elem.left       - (DPISize 15) }
            else                                             { $LastX = $elem.label.left - (DPISize 15) }
        }

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
function LoadParam([object]$Param, [uint16]$Value, [uint16]$Band, [uint16]$LastBandX, [uint16]$LastX, [byte]$Count, [byte]$Rotation) {
    
    $items        = $Param.name
    $default      = 0
    $defaultValue = 0
    $calc         = $Value -band $Band
    $TabEntry     = $Count - ($SceneEditor.Tab-1) * 50

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

        if ($Param.auto -eq 1) {
               $label = CreateLabel -X ($lastX + (DPISize 20) ) -Y (DPISize 2) -Height (DPISize 20) -Text ($Param[0].name + ":") -AddTo $SceneEditor.Actors[$TabEntry].ParamsPanel
        }
        else { $label = CreateLabel -X ($lastX + (DPISize 20) ) -Y (DPISize 2) -Height (DPISize 20) -Text ($Param[0].name + ":") -AddTo $SceneEditor.Actors[$TabEntry].ParamsPanel -Width $LastBandX }
        try {
            $elem = CreateTextBox -X ($label.Right + (DPISize 5) ) -Y 0 -Width (DPISize 50) -Height (DPISize 22) -Text ('{0:X}' -f ($calc -shr $multi) ) -Length $Param[0].value.length -AddTo $SceneEditor.Actors[$TabEntry].ParamsPanel
        }
        catch {
            $elem     = CreateTextBox -X ($label.Right + (DPISize 5) )  -Y 0 -Width (DPISize 50) -Height (DPISize 22) -Text "ERROR" -Length 0 -AddTo $SceneEditor.Actors[$TabEntry].ParamsPanel
            $elem.Enabled = $False
            WriteToConsole ("Could not parse Actor (" + $SceneEditor.Actors[$SceneEditor.Actors.Count-1].text + ") Text Field Param (" + $Param[0].name + ") with band: " + (Get16Bit $Band) + ", " + $calc + ", " + $multi )
        }
        $defaultValue = '{0:X}' -f ( (GetDecimal $elem.Text) -shl $multi)

        Add-Member -InputObject $elem -NotePropertyMembers @{ Label = $label; Max = (GetDecimal $Param[0].value); Multi = $multi }

        $elem.Add_LostFocus({
            if (!$this.Enabled) { return }

            if ($GameType.mode -eq "Majora's Mask" -and $this.Rotation -gt 0) { $shift = 7 } else { $shift = 0 }

            $this.Text = $this.Text.ToUpper()
            $text      = GetDecimal $this.Text

            if (('{0:X}' -f ($text -shl $this.Multi)) -eq $this.Value) { return }
            if ($text -lt 0 -or $text -gt $this.Max) {
                $this.Text = $this.Default
                $text      = GetDecimal $this.Default
            }
            $index      = (GetActorStart) + 16 * $this.Index + 14 - $this.Rotation
            $value      = $SceneEditor.MapArray[$index] * 256 + $SceneEditor.MapArray[$index + 1]
            $value     -= (GetDecimal $this.Value) -shl $shift
            $this.Value = '{0:X}' -f ($text -shl $this.Multi)
            $value     += (GetDecimal $this.Value) -shl $shift

            ChangeMap -Offset (Get24Bit $index) -Values (Get16Bit $value)
        })
    }

    elseif ($items.Count -eq 2) { # Checkbox
        $label = CreateLabel    -X ($lastX       + (DPISize 20) ) -Y (DPISize 2) -Height (DPISize 20) -Text ($items[1] + ":") -AddTo $SceneEditor.Actors[$TabEntry].ParamsPanel -Width $LastBandX
        $elem  = CreateCheckBox -X ($label.Right + (DPISize 5)  ) -Y 0           -Checked ($default -eq 2)                    -AddTo $SceneEditor.Actors[$TabEntry].ParamsPanel

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
                            if ($SceneEditor.Actors[$this.TabEntry].Params[$this.ResetParam - 1] -is [System.Windows.Forms.ComboBox]) { GetCheckBoxChange $SceneEditor.Actors[$this.TabEntry].Params[$this.ResetParam - 1] }
                        }
                        GetCheckBoxChange $this
                    })

                    break outer
                }
            }
        }

        $elem.Add_CheckStateChanged({
            if (!$this.Enabled) { return }

            if ($GameType.mode -eq "Majora's Mask" -and $this.Rotation -gt 0) { $shift = 7 } else { $shift = 0 }

            $index  = (GetActorStart) + 16 * $this.Index + 14 - $this.Rotation
            $value  = $SceneEditor.MapArray[$index] * 256 + $SceneEditor.MapArray[$index + 1]
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
            ChangeMap -Offset (Get24Bit $index) -Values (Get16Bit $value)
        })
    }

    else { # Combobox
        if ($default -eq 0 -and $SceneEditor.Dialog.Enabled) {
            $backup = $items
            $items  = @("Unknown: " + '{0:X}' -f $calc)
        }
        $elem = CreateComboBox -X ($LastX + (DPISize 20) ) -Y 0 -Width (DPISize 165) -Height (DPISize 20) -Default $default -Items $items -AddTo $SceneEditor.Actors[$TabEntry].ParamsPanel
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
                            if ($SceneEditor.Actors[$this.TabEntry].Params[$this.ResetParam - 1] -is [System.Windows.Forms.ComboBox]) { GetDropDownChange $SceneEditor.Actors[$this.TabEntry].Params[$this.ResetParam - 1] }
                        }
                        GetDropDownChange $this
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

            if ($GameType.mode -eq "Majora's Mask" -and $this.Rotation -gt 0) { $shift = 7 } else { $shift = 0 }

            $index  = (GetActorStart) + 16 * $this.Index + 14 - $this.Rotation
            $value  = ($SceneEditor.MapArray[$index] * 256 + $SceneEditor.MapArray[$index + 1])
            $value -= (GetDecimal $this.Value) -shl $shift

            foreach ($param in $this.Param) {
                if ($param.name -eq $this.text) {
                    if ($param.value -is [array])   { $this.Value = $param.value[0] }
                    else                            { $this.Value = $param.value    }
                    break
                }
            }

            $value += (GetDecimal $this.Value) -shl $shift
            ChangeMap -Offset (Get24Bit $index) -Values (Get16Bit $value)
        })
    }

    Add-Member -InputObject $elem -NotePropertyMembers @{ TabEntry = ($Count - ($SceneEditor.Tab-1) * 50); Index = $Count; Param = $Param; Value = $defaultValue; Rotation = $Rotation }
    return $elem

}



#==============================================================================================================================================================================================
function GetCheckBoxChange([object]$Elem) {

    if (!$Elem.Enabled) { return }
                        
    for ($y=0; $y -le 1; $y++) {
        if ($y -eq 0 -and  $Elem.Checked)   { continue }
        if ($y -eq 1 -and !$Elem.Checked)   { continue }

        $index  = (GetActorStart) + 16 * $Elem.Index + 14
        $value  = $SceneEditor.MapArray[$index - 0] * 256 + $SceneEditor.MapArray[$index + 1 - 0]
        $valueX = $SceneEditor.MapArray[$index - 6] * 256 + $SceneEditor.MapArray[$index + 1 - 6]
        $valueY = $SceneEditor.MapArray[$index - 4] * 256 + $SceneEditor.MapArray[$index + 1 - 4]
        $valueZ = $SceneEditor.MapArray[$index - 2] * 256 + $SceneEditor.MapArray[$index + 1 - 2]

        for ($x=0; $x -lt $Elem.HideParam[$y].Count; $x++) {
            if ($Elem.HideParam[$y][$x] -gt 0) {
                $param = $SceneEditor.Actors[$Elem.TabEntry].Params[$Elem.HideParam[$y][$x] - 1]
                if ($param.Visible) {
                    $param.Hide()
                    if (IsSet $param.Label) { $param.Label.Hide() }
                    if ($GameType.mode -eq "Majora's Mask" -and $param.Rotation -gt 0) { $shift = 7 } else { $shift = 0 }
                    if     ($param.Rotation -eq 0) { $value  -= (GetDecimal $param.Value)  }
                    elseif ($param.Rotation -eq 6) { $valueX -= (GetDecimal $param.ValueX) -shl $shift }
                    elseif ($param.Rotation -eq 4) { $valueY -= (GetDecimal $param.ValueY) -shl $shift }
                    elseif ($param.Rotation -eq 2) { $valueZ -= (GetDecimal $param.ValueZ) -shl $shift }
                }
            }
        }

        for ($x=0; $x -lt $Elem.ShowParam[$y].Count; $x++) {
            if ($Elem.ShowParam[$y][$x] -gt 0) {
                $param = $SceneEditor.Actors[$Elem.TabEntry].Params[$Elem.ShowParam[$y][$x] - 1]
                if (!$param.Visible) {
                    $param.Show()
                    if (IsSet $param.Label) { $param.Label.Show() }
                    if ($GameType.mode -eq "Majora's Mask" -and $param.Rotation -gt 0) { $shift = 7 } else { $shift = 0 }
                    if     ($param.Rotation -eq 0) { $value  += (GetDecimal $param.Value)  }
                    elseif ($param.Rotation -eq 6) { $valueX += (GetDecimal $param.ValueX) -shl $shift }
                    elseif ($param.Rotation -eq 4) { $valueY += (GetDecimal $param.ValueY) -shl $shift }
                    elseif ($param.Rotation -eq 2) { $valueZ += (GetDecimal $param.ValueZ) -shl $shift }
                }
            }
        }

        ChangeMap -Offset (Get24Bit ($index - 0)) -Values (Get16Bit $value)  -Silent
        ChangeMap -Offset (Get24Bit ($index - 6)) -Values (Get16Bit $valueX) -Silent
        ChangeMap -Offset (Get24Bit ($index - 4)) -Values (Get16Bit $valueY) -Silent
        ChangeMap -Offset (Get24Bit ($index - 2)) -Values (Get16Bit $valueZ) -Silent

        WriteToConsole ((Get24Bit $index) + " -> Change values: " + (Get16Bit $value) + ", " + (Get16Bit $valueX) + ", " + (Get16Bit $valueY) + ", " + (Get16Bit $valueZ))
    }

}



#==============================================================================================================================================================================================
function GetDropDownChange([object]$Elem) {

    if (!$Elem.Enabled) { return }

    $index  = (GetActorStart) + 16 * $Elem.Index + 14
    $value  = $SceneEditor.MapArray[$index - 0] * 256 + $SceneEditor.MapArray[$index + 1 - 0]
    $valueX = $SceneEditor.MapArray[$index - 6] * 256 + $SceneEditor.MapArray[$index + 1 - 6]
    $valueY = $SceneEditor.MapArray[$index - 4] * 256 + $SceneEditor.MapArray[$index + 1 - 4]
    $valueZ = $SceneEditor.MapArray[$index - 2] * 256 + $SceneEditor.MapArray[$index + 1 - 2]

    for ($x=0; $x -lt $Elem.HideParam[$Elem.SelectedIndex].Count; $x++) {
        $hide = $Elem.HideParam[$Elem.SelectedIndex][$x]
        if ($hide -gt 0) {
            $param = $SceneEditor.Actors[$Elem.TabEntry].Params[$hide - 1]
            if ($param.Visible) {
                $param.Hide()
                if (IsSet $param.Label) { $param.Label.Hide() }
                if ($GameType.mode -eq "Majora's Mask" -and $param.Rotation -gt 0) { $shift = 7 } else { $shift = 0 }
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
            $param = $SceneEditor.Actors[$Elem.TabEntry].Params[$show - 1]
            if (!$param.Visible) {
                $param.Show()
                if (IsSet $param.Label) { $param.Label.Show() }
                if ($GameType.mode -eq "Majora's Mask" -and $param.Rotation -gt 0) { $shift = 7 } else { $shift = 0 }
                if     ($param.Rotation -eq 0) { $value  += (GetDecimal $param.Value)  }
                elseif ($param.Rotation -eq 6) { $valueX += (GetDecimal $param.ValueX) -shl $shift }
                elseif ($param.Rotation -eq 4) { $valueY += (GetDecimal $param.ValueY) -shl $shift }
                elseif ($param.Rotation -eq 2) { $valueZ += (GetDecimal $param.ValueZ) -shl $shift }
            }
        }
    }

    ChangeMap -Offset (Get24Bit ($index - 0)) -Values (Get16Bit $value)  -Silent
    ChangeMap -Offset (Get24Bit ($index - 6)) -Values (Get16Bit $valueX) -Silent
    ChangeMap -Offset (Get24Bit ($index - 4)) -Values (Get16Bit $valueY) -Silent
    ChangeMap -Offset (Get24Bit ($index - 2)) -Values (Get16Bit $valueZ) -Silent

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
        if     ($GameType.mode -eq "Majora's Mask" -and $offset -ge 8)   { $min = 0;         $max = 0x1FF;  $length = 3; $shift = 7; $value = ( ($SceneEditor.MapArray[$index + $Offset] * 256 + $SceneEditor.MapArray[$index + $Offset + 1]) -band 0xFF80) -shr $shift }
        elseif ($offset -ge 8)                                           { $min = 0;         $max = 0xFFFF; $length = 4; $shift = 0; $value =    $SceneEditor.MapArray[$index + $Offset] * 256 + $SceneEditor.MapArray[$index + $Offset + 1]                            }
        else                                                             { $min = -(0x8000); $max = 0x7FFF; $length = 5; $shift = 0; $value =   ($SceneEditor.MapArray[$index + $Offset] * 256 + $SceneEditor.MapArray[$index + $Offset + 1])                           }
    }
    else {
        if     ($GameType.mode -eq "Majora's Mask" -and $offset -ge 8)   { $min = 0;         $max = 0x1FF;  $length = 3; $shift = 7; $value = $Default -shr $shift }
        elseif ($offset -ge 8)                                           { $min = 0;         $max = 0xFFFF; $length = 4; $shift = 0; $value = $Default             }
        else                                                             { $min = -(0x8000); $max = 0x7FFF; $length = 5; $shift = 0; $value = $Default             }
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

Export-ModuleMember -Function RunSceneEditor