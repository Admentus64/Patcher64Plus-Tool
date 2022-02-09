function PatchOptions() {
    
    if (IsChecked $Redux.Gameplay.CPUItems)     { ApplyPatch -Patch "Compressed\cpu_items.ppf" }

}



#==============================================================================================================================================================================================
function ByteOptions() {
    
    if (IsChecked $Redux.Gameplay.Widescreen) {
        ChangeBytes -Offset "952BB"  -Values "E3 34 E7 8E 39"
        ChangeBytes -Offset "953EF"  -Values "E3 34 E7 8E 39"
        ChangeBytes -Offset "12322D" -Values "E3 8E 39 3F 63 8E 39 40 63 8E 39 3F E3 8E 39"
    }

    if (IsChecked $Redux.Gameplay.SixtyFrames) {
        ChangeBytes -Offset "2490" -Values "24 19 00 01 24 19 00 01"; ChangeBytes -Offset "1BE3" -Values "00"; ChangeBytes -Offset "20CF" -Values "01"
        ChangeBytes -Offset "2890" -Values "24 0A 00 01 24 0A 00 01"; ChangeBytes -Offset "2638" -Values "24 09 00 01 24 09 00 01"
    }

    if (IsChecked $Redux.Gameplay.RemoveRubberBanding) { ChangeBytes -Offset "297AA" -Values "B49A" }

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsDialog -Columns 4 -Height 190

    CreateReduxGroup    -Tag  "Gameplay"            -Text "Gameplay"
    CreateReduxCheckBox -Name "Widescreen"          -Text "16:9 Widescreen"       -Info "Adjust the aspect ratio from 4:3 to 16:9 widescreen"                                                                            -Credits "gamemasterplc"
    CreateReduxCheckBox -Name "SixtyFrames"         -Text "60 FPS"                -Info "Increases the FPS from 30 to 60" -Warning "The menus are sped up, but racing works fine"                                        -Credits "Admentus (ROM) & retroben (GS)"
    CreateReduxCheckBox -Name "CPUItems"            -Text "CPU Use Human Items"   -Info "CPUs can now use all items human players can use too"                                                                           -Credits "Triclon"
    CreateReduxCheckBox -Name "RemoveRubberBanding" -Text "Remove Rubber Banding" -Info "Removes the rubber banding from CPU players`nRubber banding causes CPUs to adjust their speed to that of the player's position" -Credits "Admentus (ROM)"

    EnableElem -Elem $Redux.Gameplay.CPUItems -Active (!$IsWiiVC)

}