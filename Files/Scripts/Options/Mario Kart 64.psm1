function PatchOptions() {
    
    # GRAPHICS #

    if (IsChecked $Redux.Graphics.WidescreenBackgrounds)   { ApplyPatch -Patch "Compressed\Optional\ws_backgrounds.ips" }



    # AUDIO #

    if (IsChecked $Redux.Audio.JapaneseAudio) { ApplyPatch -Patch "Compressed\Optional\jpn_audio.ips" }



    # GAMEPLAY #

    if (IsChecked $Redux.Gameplay.CPUItems)     { ApplyPatch -Patch "Compressed\Optional\cpu_items.ips" }
    if (IsChecked $Redux.Gameplay.Kamek)        { ApplyPatch -Patch "Compressed\Optional\kamek.ips"     }
}



#==============================================================================================================================================================================================
function ByteOptions() {
    
    # GRAPHICS #

    if (IsChecked $Redux.Graphics.Widescreen) {
        ChangeBytes -Offset "952BB"  -Values "E334E78E39"
        ChangeBytes -Offset "953EF"  -Values "E334E78E39"
        ChangeBytes -Offset "12322D" -Values "E38E393F638E3940638E393FE38E39"
    }

    if (IsChecked $Redux.Graphics.SixtyFrames) {
        ChangeBytes -Offset "2490" -Values "2419000124190001"; ChangeBytes -Offset "1BE3" -Values "00"; ChangeBytes -Offset "20CF" -Values "01"
        ChangeBytes -Offset "2890" -Values "240A0001240A0001"; ChangeBytes -Offset "2638" -Values "2409000124090001"
    }

    
    if (IsChecked $Redux.Graphics.MaxDrawDistance)   { ChangeBytes -Offset "123220" -Values "477DE800" }
    if (IsChecked $Redux.Graphics.LagFix)            { ChangeBytes -Offset "EB2D2"  -Values "0D"       }



    # GAMEPLAY #

    if (IsChecked $Redux.Gameplay.RemoveRubberBanding)   { ChangeBytes -Offset "297AA"  -Values "B49A"                                                     }
    if (IsChecked $Redux.Gameplay.MultiplayerMusic)      { ChangeBytes -Offset "F82BF"  -Values "00";       ChangeBytes -Offset "F8FE7" -Values "00"       }
    if (IsChecked $Redux.Gameplay.NoCameraShake)         { ChangeBytes -Offset "8E018"  -Values "2400"                                                     }
    if (IsChecked $Redux.Gameplay.AlwaysAdvance)         { ChangeBytes -Offset "F8600"  -Values "00000000"                                                 }
    if (IsChecked $Redux.Gameplay.AddBombs)              { ChangeBytes -Offset "1D00C"  -Values "00000000"; ChangeBytes -Offset "A460"  -Values "00000000" }
    if (IsChecked $Redux.Gameplay.RemoveBombs)           { ChangeBytes -Offset "1D00B"  -Values "05"  ;     ChangeBytes -Offset "A45B"  -Values "05"       }
    if (IsChecked $Redux.Gameplay.AlwaysSmallRacers)     { ChangeBytes -Offset "8EF04"  -Values "00000000"; ChangeBytes -Offset "2DA43" -Values "00"       }

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsPanel

    CreateReduxGroup    -Tag  "Graphics"              -Text "Graphics"
    CreateReduxCheckBox -Name "Widescreen"            -Text "16:9 Widescreen"         -Info "Adjust the aspect ratio from 4:3 to 16:9 widescreen"                                                                            -Credits "gamemasterplc"
    CreateReduxCheckBox -Name "WidescreenBackgrounds" -Text "Widescreen Backgrounds"  -Info "Adjust the aspect ratio from 4:3 to 16:9 for the background images"                                                             -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "SixtyFrames"           -Text "60 FPS"                  -Info "Increases the FPS from 30 to 60" -Warning "The menus are sped up, but racing works fine"                                        -Credits "Admentus (ROM) & retroben (GS)"
    CreateReduxCheckBox -Name "MaxDrawDistance"       -Text "Max Draw Distance"       -Info "Renders geometry further"                                                                                                       -Credits "Admentus (ROM) & Gabo (GS)"
    CreateReduxCheckBox -Name "LagFix"                -Text "Lag Fix"                 -Info "Fixes frame rate in areas where game can drop frames and loading becomes faster"                                                -Credits "Admentus (ROM) & Gabo (GS)"

    CreateReduxGroup    -Tag  "Audio"                 -Text "Audio"
    CreateReduxCheckBox -Name "JapaneseAudio"         -Text "Japanese Audio"          -Info "Replaces the US audio with JPN audio"                                                                                           -Credits "GhostlyDark"

    CreateReduxGroup    -Tag  "Gameplay"              -Text "Gameplay"
    CreateReduxCheckBox -Name "CPUItems"              -Text "CPU Use Human Items"     -Info "CPUs can now use all items human players can use too"                                                                           -Credits "Triclon"
    CreateReduxCheckBox -Name "RemoveRubberBanding"   -Text "Remove Rubber Banding"   -Info "Removes the rubber banding from CPU players`nRubber banding causes CPUs to adjust their speed to that of the player's position" -Credits "Admentus (ROM)"
    CreateReduxCheckBox -Name "MultiplayerMusic"      -Text "Multiplayer Music"       -Info "Enable music for 3-Player and 4-Player Mode`nPress L to toggle the music"                                                       -Credits "Zoinkity"
    CreateReduxCheckBox -Name "NoCameraShake"         -Text "No Camera Shake"         -Info "The camera won't shake when using mushrooms"                                                                                    -Credits "Triclon"
    CreateReduxCheckBox -Name "AlwaysAdvance"         -Text "Always Advance"          -Info "You always advance to the next race, even if you end up 5th place or lower"                                                     -Credits "Litronom"
    CreateReduxCheckBox -Name "AddBombs"              -Text "Add Bombs (GP Mode)"     -Info "Add the yellow bombs to the racetrack during Grand Prix mode"                                                                   -Credits "Admentus (ROM) & TheBoy181 (GS)"
    CreateReduxCheckBox -Name "RemoveBombs"           -Text "Remove Bombs (MP Races)" -Info "Removes the yellow bombs from the racetrack during multiplayer races"                                                           -Credits "Admentus (ROM) & TheBoy181 (GS)"
    CreateReduxCheckBox -Name "AlwaysSmallRacers"     -Text "Always Small Racers"     -Info "Always play with mini racers`nLoose the ability to power slide, but gain the ability of a new challenge"                        -Credits "Admentus (ROM) & TheBoy181 (GS)"
    CreateReduxCheckBox -Name "Kamek"                 -Text "Kamek"                   -Info "Replaces Donkey Kong with Kamek"                                                                                                -Credits "Andrat" -Link $Redux.Audio.JapaneseAudio

    EnableElem -Elem $Redux.Gameplay.CPUItems -Active (!$IsWiiVC)

}