function PatchOptions() {
    
    if (IsChecked $Redux.Gameplay.CPUItems)     { ApplyPatch -Patch "Compressed\cpu_items.ppf" }

}



#==============================================================================================================================================================================================
function ByteOptions() {
    
    if (IsChecked $Redux.Gameplay.Widescreen) {
        ChangeBytes -Offset "952BB"  -Values "E334E78E39"
        ChangeBytes -Offset "953EF"  -Values "E334E78E39"
        ChangeBytes -Offset "12322D" -Values "E38E393F638E3940638E393FE38E39"
    }

    if (IsChecked $Redux.Gameplay.SixtyFrames) {
        ChangeBytes -Offset "2490" -Values "2419000124190001"; ChangeBytes -Offset "1BE3" -Values "00"; ChangeBytes -Offset "20CF" -Values "01"
        ChangeBytes -Offset "2890" -Values "240A0001240A0001"; ChangeBytes -Offset "2638" -Values "2409000124090001"
    }

    if (IsChecked $Redux.Gameplay.RemoveRubberBanding)   { ChangeBytes -Offset "297AA" -Values "B49A"                                         }
    if (IsChecked $Redux.Gameplay.MultiplayerMusic)      { ChangeBytes -Offset "F82BF" -Values "00"; ChangeBytes -Offset "F8FE7" -Values "00" }
    if (IsChecked $Redux.Gameplay.NoCameraShake)         { ChangeBytes -Offset "8E018" -Values "2400"                                         }
    if (IsChecked $Redux.Gameplay.AlwaysAdvance)         { ChangeBytes -Offset "F8600" -Values "00000000"                                     }

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsDialog -Columns 3 -Height 220

    CreateReduxGroup    -Tag  "Gameplay"            -Text "Gameplay"
    CreateReduxCheckBox -Name "Widescreen"          -Text "16:9 Widescreen"       -Info "Adjust the aspect ratio from 4:3 to 16:9 widescreen"                                                                            -Credits "gamemasterplc"
    CreateReduxCheckBox -Name "SixtyFrames"         -Text "60 FPS"                -Info "Increases the FPS from 30 to 60" -Warning "The menus are sped up, but racing works fine"                                        -Credits "Admentus (ROM) & retroben (GS)"
    CreateReduxCheckBox -Name "CPUItems"            -Text "CPU Use Human Items"   -Info "CPUs can now use all items human players can use too"                                                                           -Credits "Triclon"
    CreateReduxCheckBox -Name "RemoveRubberBanding" -Text "Remove Rubber Banding" -Info "Removes the rubber banding from CPU players`nRubber banding causes CPUs to adjust their speed to that of the player's position" -Credits "Admentus (ROM)"
    CreateReduxCheckBox -Name "MultiplayerMusic"    -Text "Multiplayer Music"     -Info "Enable music for 3-Player and 4-Player Mode`nPress L to toggle the music"                                                       -Credits "Zoinkity"
    CreateReduxCheckBox -Name "NoCameraShake"       -Text "No Camera Shake"       -Info "The camera won't shake when using mushrooms"                                                                                    -Credits "Triclon"
    CreateReduxCheckBox -Name "AlwaysAdvance"       -Text "Always Advance"        -Info "You always advance to the next race, even if you end up 5th place or lower"                                                     -Credits "Litronom"

    EnableElem -Elem $Redux.Gameplay.CPUItems -Active (!$IsWiiVC)

}