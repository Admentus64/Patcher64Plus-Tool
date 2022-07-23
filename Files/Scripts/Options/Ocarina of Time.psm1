function PrePatchOptions() {
    
    # GRAPHICS #

    if (IsChecked $Redux.Graphics.Widescreen) {
        ApplyPatch -Patch "Decompressed\Optional\widescreen_minimum.ppf"
        if ($GamePatch.options -eq 1) { ApplyPatch -Patch "Decompressed\Optional\widescreen_hide_geometry.ppf" }
    }

}



#==============================================================================================================================================================================================
function PrePatchReduxOptions() {
    
    # GRAPHICS #

    if (IsChecked $Redux.Graphics.Widescreen) { ApplyPatch -Patch "Decompressed\Optional\widescreen_redux_hotfix.ppf" }

}



#==============================================================================================================================================================================================
function PatchOptions() {
    
    # MODELS #

    if (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Original" -Not) {
        $file = "\Child\" + $Redux.Graphics.ChildModels.Text.replace(" (default)", "") + ".ppf" 
        if (TestFile ($GameFiles.models + $file))       { ApplyPatch -Patch ($GameFiles.models + $file) -FullPath }
    }
    
    if (IsIndex -Elem $Redux.Graphics.AdultModels -Text "Original" -Not) {
        $file = "\Adult\" + $Redux.Graphics.AdultModels.Text.replace(" (default)", "") + ".ppf"
        if (TestFile ($GameFiles.models + $file))       { ApplyPatch -Patch ($GameFiles.models + $file) -FullPath }
    }

    if ( ( (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Original") -or (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Majora's Mask Eyes") ) -and ( (IsIndex -Elem $Redux.Unlock.MegatonHammer -Index 3) -or (IsIndex -Elem $Redux.Unlock.MegatonHammer -Index 4) ) ) {
        ApplyPatch -Patch "Decompressed\Optional\vanilla_child_megaton_hammer.ppf"
    }

    if (IsChecked $Redux.Animation.Feminine)            { ApplyPatch -Patch "Decompressed\Optional\feminine_animations.ppf" }



    # DIFFICULTY #

    if (IsChecked $Redux.Hero.HarderChildBosses)        { ApplyPatch -Patch "Decompressed\Optional\harder_child_bosses.ppf" }
    


    # MM PAUSE SCREEN #

    if (IsChecked $Redux.Text.PauseScreen)              { ApplyPatch -Patch "Decompressed\Optional\mm_pause_screen.ppf" }
    
}



#==============================================================================================================================================================================================
function ByteOptions() {
    
    if     ($GamePatch.title -like "*Master of Time*")   { $ChildModel = @{}; $ChildModel.deku_shield   = 1; $ChildModel.hylian_shield = 1 }
    elseif ($GamePatch.title -like "*Dawn & Dusk*")      { $AdultModel = @{}; $AdultModel.hylian_shield = 1; $AdultModel.mirror_shield = 1 }



    # GAMEPLAY #

    if (IsIndex $Redux.Gameplay.FasterBlockPushing -Index 1 -Not) {
        ChangeBytes -Offset "DD2B87" -Values "80";       ChangeBytes -Offset "DD2D27" -Values "03" # Block Speed, Delay
        ChangeBytes -Offset "DD9683" -Values "80";       ChangeBytes -Offset "DD981F" -Values "03" # Milk Crate Speed, Delay
        ChangeBytes -Offset "C77CA8" -Values "40800000"; ChangeBytes -Offset "C770C3" -Values "01" # Fire Block Speed, Delay
        ChangeBytes -Offset "CC5DBF" -Values "01";       ChangeBytes -Offset "DBCF73" -Values "01" # Forest Basement Puzzle Delay / spirit Cobra Mirror Delay
        ChangeBytes -Offset "DBA233" -Values "19";       ChangeBytes -Offset "DBA3A7" -Values "00" # Truth Spinner Speed, Delay
        if (IsIndex $Redux.Gameplay.FasterBlockPushing -Index 3) { ChangeBytes -Offset "CE1BD0" -Values "40800000"; ChangeBytes -Offset "CE0F0F" -Values "03" } # Amy Puzzle Speed, Delay
    }

    if (IsChecked $Redux.Gameplay.ClimbAnything) {
        <#for ($i=0; $i -lt 128; $i+=4) {
            if ($i -eq 8) { continue }
            ChangeBytes -Offset (AddToOffset "B61F80" -Add (Get8Bit $i)) -Values "00000008"
        }#>
        ChangeBytes -Offset "AAA394" -Values "34020004"
    }

    if (IsChecked $Redux.Gameplay.Medallions)               { ChangeBytes -Offset "E2B454" -Values "80EA00A72401003F314A003F00000000"                          }
    if (IsChecked $Redux.Gameplay.RutoNeverDisappears)      { ChangeBytes -Offset "D01EA3" -Values "00"                                                        }
    if (IsChecked $Redux.Gameplay.ReturnChild)              { ChangeBytes -Offset "CB6844" -Values "35";       ChangeBytes -Offset "253C0E2" -Values "03"      }
    if (IsChecked $Redux.Gameplay.DistantZTargeting)        { ChangeBytes -Offset "A987AC" -Values "00000000"                                                  }
    if (IsChecked $Redux.Gameplay.ManualJump)               { ChangeBytes -Offset "BD78C0" -Values "04C1";     ChangeBytes -Offset "BD78E3" -Values "01"       }
    if (IsChecked $Redux.Gameplay.NoKillFlash)              { ChangeBytes -Offset "B11C33" -Values "00"                                                        }
    if (IsChecked $Redux.Gameplay.NoShieldRecoil)           { ChangeBytes -Offset "BD416C" -Values "2400"                                                      }
    if (IsChecked $Redux.Gameplay.RunWhileShielding)        { ChangeBytes -Offset "BD7DA0" -Values "10000055"; ChangeBytes -Offset "BD01D4" -Values "00000000" }
    if (IsChecked $Redux.Gameplay.PushbackAttackingWalls)   { ChangeBytes -Offset "BDEAE0" -Values "2624000024850000"                                          }
    if (IsChecked $Redux.Gameplay.RemoveCrouchStab)         { ChangeBytes -Offset "BDE374" -Values "1000000D"                                                  }
    if (IsChecked $Redux.Gameplay.RemoveQuickSpin)          { ChangeBytes -Offset "C9C9E8" -Values "1000000E"                                                  }
    if (IsChecked $Redux.Gameplay.ResumeLastArea)           { ChangeBytes -Offset "B06348" -Values "0000";     ChangeBytes -Offset "B06354" -Values "0000"     }
    if (IsChecked $Redux.Gameplay.SpawnLinksHouse)          { ChangeBytes -Offset "B06332" -Values "00BB"                                                      }
    if (IsChecked $Redux.Gameplay.AllowWarpSongs)           { ChangeBytes -Offset "B6D3D2" -Values "00";       ChangeBytes -Offset "B6D42A" -Values "00"       }
    if (IsChecked $Redux.Gameplay.AllowFaroreWind)          { ChangeBytes -Offset "B6D3D3" -Values "00";       ChangeBytes -Offset "B6D42B" -Values "00"       }
    if (IsChecked $Redux.Gameplay.OpenBombchuShop)          { ChangeBytes -Offset "C6CEDC" -Values "340B0001"                                                  }
    if (IsChecked $Redux.Gameplay.HookshotAnything)         { ChangeBytes -Offset "D3BA30"  -Values "00000000"                                                 }
    if (IsChecked $Redux.Gameplay.NoMagicArrowCooldown)     { ChangeBytes -Offset "AE85C9"  -Values "62"                                                       }

    if (IsIndex $Redux.Gameplay.SpawnChild -Index 1 -Not) { ChangeBytes -Offset "B0631E" -Values (GetOoTEntranceIndex $Redux.Gameplay.SpawnChild.Text) }
    if (IsIndex $Redux.Gameplay.SpawnAdult -Index 2 -Not) { ChangeBytes -Offset "B06332" -Values (GetOoTEntranceIndex $Redux.Gameplay.SpawnAdult.Text) }



    # RESTORE #

    if (IsChecked $Redux.Restore.RupeeColors) {
        ChangeBytes -Offset "F47EB0" -Values "70 6B BB 3F FF FF EF 3F 68 AD C3 FD E6 BF CD 7F 48 9B 91 AF C3 7D BB 3D 40 0F 58 19 88 ED 80 AB" # Purple
        ChangeBytes -Offset "F47ED0" -Values "D4 C3 F7 49 FF FF F7 E1 DD 03 EF 89 E7 E3 E7 DD A3 43 D5 C3 DF 85 E7 45 7A 43 82 83 B4 43 CC 83" # Gold
    }

    if (IsChecked $Redux.Restore.FireTemple) {
        ChangeBytes -Offset "7465"   -Values "03 91 30"                         # DMA Table, Pointer to Audiobank
        ChangeBytes -Offset "7471"   -Values "03 91 30 00 08 8B B0 00 03 91 30" # DMA Table, Pointer to Audioseq
        ChangeBytes -Offset "7481"   -Values "08 8B B0 00 4D 9F 40 00 08 8B B0" # DMA Table, Pointer to Audiotable
        ChangeBytes -Offset "B2E82F" -Values "04 24 A5 91 30"                   # MIPS assembly that loads Audioseq
        ChangeBytes -Offset "B2E857" -Values "09 24 A5 8B B0"                   # MIPS assembly that loads Audiotable
        PatchBytes  -Offset "B896A0" -Patch "Fire Temple Theme\audiobank_pointers.bin"
        PatchBytes  -Offset "B89AD0" -Patch "Fire Temple Theme\audioseq_pointers.bin"
        PatchBytes  -Offset "B8A1C0" -Patch "Fire Temple Theme\audiotable_pointers.bin"
        ExportAndPatch -Path "audiobank_fire_temple" -Offset "D390" -Length "4CCBB0"
    }

    if ( (IsIndex -Elem $Redux.Restore.Blood -Index 2) -or (IsIndex -Elem $Redux.Restore.Blood -Index 4) ) {
        ChangeBytes -Offset "B65A40" -Values "04"; ChangeBytes -Offset "B65A44" -Values "04"; ChangeBytes -Offset "B65A4C" -Values "04"; ChangeBytes -Offset "B65A50" -Values "04"
    }
    if ( (IsIndex -Elem $Redux.Restore.Blood -Index 3) -or (IsIndex -Elem $Redux.Restore.Blood -Index 4) ) {
        ChangeBytes -Offset "D8D590" -Values "00 78 00 FF 00 78 00 FF"; ChangeBytes -Offset "E8C424" -Values "00 78 00 FF 00 78 00 FF"
    }

    if (IsChecked $Redux.Restore.CowNoseRing)           { ChangeBytes -Offset "EF3E68" -Values "00 00"        }
    if (IsChecked $Redux.Restore.CenterTextboxCursor)   { ChangeBytes -Offset "B5883B" -Values "04" -Subtract }
    if (IsChecked $Redux.Restore.RedBlood)              { ChangeBytes -Offset "B65A40" -Values "04"; ChangeBytes -Offset "B65A44" -Values "04"; ChangeBytes -Offset "B65A4C" -Values "04"; ChangeBytes -Offset "B65A50" -Values "04" }
    


    # OTHER #

    if (IsChecked $Redux.Fixes.NaviTarget) {
        $offset = SearchBytes -Start "2ADE000" -End "2BEAA20" -Values "61 00 06 00 05 00 00 3C 24 01 11 FD A8 01 4D FB"; ChangeBytes -Offset $offset -Values "7E" # Spirit Temple
        ChangeBytes -Offset "283B14B" -Values "5C FA F3 FD AC"       # Shadow Temple
        ChangeBytes -Offset "236C059" -Values "4B FD 31 00 1E 00 16" # Fire Temple
        ChangeBytes -Offset "2C1906D" -Values "18 00 00 00 00"       # Ice Cavern
    }

    if (IsChecked $Redux.Fixes.PauseScreenDelay)      { ChangeBytes -Offset "B15DD0" -Values "00000000"                                                  } # Pause Screen Anti-Aliasing
    if (IsChecked $Redux.Fixes.PauseScreenCrash)      { ChangeBytes -Offset "B12947" -Values "03"                                                        } # Pause Screen Delay Speed
    if (IsChecked $Redux.Fixes.SpiritTempleMirrors)   { ChangeBytes -Offset "E45678" -Values "0000"; ChangeBytes -Offset "0E4567B" -Values "00"          }
    if (IsChecked $Redux.Fixes.RemoveFishingPiracy)   { ChangeBytes -Offset "DBEC80" -Values "34020000"                                                  }
    if (IsChecked $Redux.Fixes.PoacherSaw)            { ChangeBytes -Offset "AE72CC" -Values "00000000"                                                  }
    if (IsChecked $Redux.Fixes.Boomerang)             { ChangeBytes -Offset "F0F718" -Values "FC41C7FFFFFFFE38"                                          }
    if (IsChecked $Redux.Fixes.FortressMinimap)       { CopyBytes   -Offset "96E068" -Length "D48" -Start "974600"                                       }
    if (IsChecked $Redux.Fixes.AlwaysMoveKingZora)    { ChangeBytes -Offset "E55BB0" -Values "85CE8C3C"; ChangeBytes -Offset "E55BB4" -Values "844F0EDA" }
    if (IsChecked $Redux.Fixes.DeathMountainOwl)      { ChangeBytes -Offset "E304F0" -Values "240E0001"                                                  }



    # OTHER #

    if ( (IsIndex -Elem $Redux.Other.MapSelect -Text "Translate Only") -or (IsIndex $Redux.Other.MapSelect -Text "Translate and Enable") ) { ExportAndPatch -Path "map_select" -Offset "B9FD90" -Length "EC0" }
    if ( (IsIndex -Elem $Redux.Other.MapSelect -Text "Enable Only")    -or (IsIndex $Redux.Other.MapSelect -Text "Translate and Enable") ) {
        ChangeBytes -Offset "A94994" -Values "00 00 00 00 AE 08 00 14 34 84 B9 2C 8E 02 00 18 24 0B 00 00 AC 8B 00 00"
        ChangeBytes -Offset "B67395" -Values "B9 E4 00 00 BA 11 60 80 80 09 C0 80 80 37 20 80 80 1C 14 80 80 1C 14 80 80 1C 08"
    }

    if (IsChecked $Redux.Other.MuteOwls) {
        ChangeBytes -Offset "1FE30CF" -Values "00";    ChangeBytes -Offset "1FE30DF" -Values "00";    ChangeBytes -Offset "1FE30EE" -Values "00 00"; ChangeBytes -Offset "1FE30FE" -Values "00 00"
        ChangeBytes -Offset "205909E" -Values "00 00"; ChangeBytes -Offset "21630CE" -Values "00 00"; ChangeBytes -Offset "217F0DE" -Values "00 00"; ChangeBytes -Offset "21A008E" -Values "00 00"; ChangeBytes -Offset "220F073" -Values "00"
    }

    if (IsChecked $Redux.Other.RemoveNaviPrompts)    { ChangeBytes -Offset "DF8B84" -Values "00 00 00 00"                                                     }
    if (IsChecked $Redux.Other.RemoveNaviTimer)      { ChangeBytes -Offset "C26C14" -Values "10 00 00 13"; ChangeBytes -Offset "C26C1C" -Values "10 00 00 13" }
    if (IsChecked $Redux.Other.DefaultZTargeting)    { ChangeBytes -Offset "B71E6D" -Values "01"                                                              }
    if (IsChecked $Redux.Other.InstantClaimCheck)    { ChangeBytes -Offset "ED4470" -Values "00 00 00 00"; ChangeBytes -Offset "ED4498" -Values "00 00 00 00" }
    if (IsChecked $Redux.Other.ItemSelect)           { ExportAndPatch -Path "inventory_editor" -Offset "BCBF64" -Length "C8"                                  }
    if (IsChecked $Redux.Other.DiskDrive)            { ChangeBytes -Offset "BAF1F1" -Values "26";          ChangeBytes -Offset "E6D83B" -Values "04"          }

    if ( (IsIndex   -Elem $Redux.Other.SkipIntro -Text "Skip Logo")         -or (IsIndex -Elem $Redux.Other.SkipIntro -Text "Skip Logo and Title Screen") )   { ChangeBytes -Offset "B9DAAC" -Values "00 00 00 00"                     }
    if ( (IsIndex   -Elem $Redux.Other.SkipIntro -Text "Skip Title Screen") -or (IsIndex -Elem $Redux.Other.SkipIntro -Text "Skip Logo and Title Screen") )   { ChangeBytes -Offset "B17237" -Values "30"                              }
    if   (IsDefault -Elem $Redux.Other.Skybox    -Not)                                                                                                        { ChangeBytes -Offset "B67722" -Values $Redux.Other.Skybox.SelectedIndex }



    # SPEED #

    if (IsValue -Elem $Redux.Gameplay.MovementSpeed -Not) { ChangeBytes -Offset "B6D5BA" -Values (Get16Bit $Redux.Gameplay.MovementSpeed.Value) }



    # GRAPHICS #

    if (IsChecked $Redux.Graphics.WidescreenAlt) {
        # 16:9 Widescreen
        if ($IsWiiVC ) { ChangeBytes -Offset "B08038" -Values "3C 07 3F E3" }
        if ($GamePatch.title -like "*Master of Time*" -or $GamePatch.title -like "*Dusk & Dusk*") { return }

        # 16:9 Textures
        if ($GamePatch.options -eq 1) {
            PatchBytes -Offset "28E7FB0" -Length "3A57" -Texture -Patch "Widescreen\bazaar.jpeg"
            PatchBytes -Offset "2DDB160" -Length "38B8" -Texture -Patch "Widescreen\bombchu_shop.jpeg"
            PatchBytes -Offset "2D339D0" -Length "3934" -Texture -Patch "Widescreen\goron_shop.jpeg"
            PatchBytes -Offset "2CD0DA0" -Length "37CF" -Texture -Patch "Widescreen\gravekeepers_hut.jpeg"
            PatchBytes -Offset "3412E40" -Length "4549" -Texture -Patch "Widescreen\happy_mask_shop.jpeg"
            PatchBytes -Offset "2E30EF0" -Length "4313" -Texture -Patch "Widescreen\impas_house.jpeg"
            PatchBytes -Offset "2C8A7C0" -Length "31C6" -Texture -Patch "Widescreen\kakariko_house.jpeg"
            PatchBytes -Offset "300CD80" -Length "43AC" -Texture -Patch "Widescreen\kakariko_house_3.jpeg"
            PatchBytes -Offset "2D89660" -Length "3E49" -Texture -Patch "Widescreen\kakariko_potion_shop.jpeg"
            PatchBytes -Offset "268D430" -Length "5849" -Texture -Patch "Widescreen\kokiri_know_it_all_brothers_house.jpeg"
            PatchBytes -Offset "2592490" -Length "410F" -Texture -Patch "Widescreen\kokiri_shop.jpeg"
            PatchBytes -Offset "2AA90C0" -Length "5D69" -Texture -Patch "Widescreen\kokiri_twins_House.jpeg"
            PatchBytes -Offset "2560480" -Length "5B1E" -Texture -Patch "Widescreen\links_house.jpeg"
            PatchBytes -Offset "2C5DA50" -Length "4B12" -Texture -Patch "Widescreen\lon_lon_ranch_stables.jpeg"
            PatchBytes -Offset "2E037A0" -Length "3439" -Texture -Patch "Widescreen\mamamu_yans_house.jpeg"
            PatchBytes -Offset "2946120" -Length "4554" -Texture -Patch "Widescreen\market_back_alley_1_day.jpeg"
            PatchBytes -Offset "2A2A110" -Length "2F31" -Texture -Patch "Widescreen\market_back_alley_1_night.jpeg"
            PatchBytes -Offset "296B920" -Length "41ED" -Texture -Patch "Widescreen\market_back_alley_2_day.jpeg"
            PatchBytes -Offset "2A4F910" -Length "3015" -Texture -Patch "Widescreen\market_back_alley_2_night.jpeg"
            PatchBytes -Offset "2991120" -Length "4AC4" -Texture -Patch "Widescreen\market_back_alley_3_day.jpeg"
            PatchBytes -Offset "2A75110" -Length "366B" -Texture -Patch "Widescreen\market_back_alley_3_night.jpeg"
            PatchBytes -Offset "2718370" -Length "62CE" -Texture -Patch "Widescreen\market_entrance_day.jpeg"
            PatchBytes -Offset "2A02360" -Length "54CC" -Texture -Patch "Widescreen\market_entrance_future.jpeg"
            PatchBytes -Offset "29DB370" -Length "4144" -Texture -Patch "Widescreen\market_entrance_night.jpeg"
            PatchBytes -Offset "2DB1430" -Length "39DF" -Texture -Patch "Widescreen\market_potion_shop.jpeg"
            PatchBytes -Offset "2F7B0F0" -Length "669B" -Texture -Patch "Widescreen\midos_house.jpeg"
            PatchBytes -Offset "2FB60E0" -Length "5517" -Texture -Patch "Widescreen\sarias_house.jpeg"
            PatchBytes -Offset "307EAF0" -Length "428D" -Texture -Patch "Widescreen\temple_of_time_entrance_day.jpeg"
            PatchBytes -Offset "3142AF0" -Length "3222" -Texture -Patch "Widescreen\temple_of_time_entrance_future.jpeg"
            PatchBytes -Offset "30EDB10" -Length "2C02" -Texture -Patch "Widescreen\temple_of_time_entrance_night.jpeg"
            PatchBytes -Offset "30A42F0" -Length "5328" -Texture -Patch "Widescreen\temple_of_time_path_day.jpeg"
            PatchBytes -Offset "31682F0" -Length "3860" -Texture -Patch "Widescreen\temple_of_time_path_future.jpeg"
            PatchBytes -Offset "3113310" -Length "3BC7" -Texture -Patch "Widescreen\temple_of_time_path_night.jpeg"
            PatchBytes -Offset "2E65EA0" -Length "49E0" -Texture -Patch "Widescreen\tent.jpeg"
            PatchBytes -Offset "2D5B9E0" -Length "4119" -Texture -Patch "Widescreen\zora_shop.jpeg"
        }
        PatchBytes -Offset "F21810"  -Length "1000" -Texture -Patch "Widescreen\lens_of_truth.bin"
    }

    if (IsChecked $Redux.Graphics.OverworldSkyboxes) {
        ChangeBytes -Offset "206F054" -Values "01"; ChangeBytes -Offset "207BC4C" -Values "01"; ChangeBytes -Offset "207BF5C" -Values "01"; ChangeBytes -Offset "207C264" -Values "01"; ChangeBytes -Offset "207C394" -Values "01" # Kokiri Forest
        ChangeBytes -Offset "207C4B4" -Values "01"; ChangeBytes -Offset "207C5DC" -Values "01"; ChangeBytes -Offset "207C78C" -Values "01"; ChangeBytes -Offset "207C93C" -Values "01"; ChangeBytes -Offset "207CAE4" -Values "01" # Kokiri Forest
        ChangeBytes -Offset "207CBC4" -Values "01"; ChangeBytes -Offset "207CCA4" -Values "01"; ChangeBytes -Offset "207CE74" -Values "01"                                                                                         # Kokiri Forest
        ChangeBytes -Offset "214604C" -Values "01"; ChangeBytes -Offset "2151D4C" -Values "01"; ChangeBytes -Offset "21520E4" -Values "01"                                                                                         # Lost Woods
        ChangeBytes -Offset "20AC044" -Values "01"; ChangeBytes -Offset "20B2814" -Values "01"; ChangeBytes -Offset "20B2A3C" -Values "01"; ChangeBytes -Offset "20B2B1C" -Values "01"                                             # Sacred Meadow
        ChangeBytes -Offset "2110044" -Values "01"; ChangeBytes -Offset "21143AC" -Values "01"; ChangeBytes -Offset "211458C" -Values "01"                                                                                         # Zora's Fountain
        ChangeBytes -Offset "21DC04C" -Values "03"                                                                                                                                                                                 # Haunted Wasteland
    }

    if (IsChecked $Redux.Graphics.ExtendedDraw)      { ChangeBytes -Offset "A9A970" -Values "00 01" }
    if (IsChecked $Redux.Graphics.ForceHiresModel)   { ChangeBytes -Offset "BE608B" -Values "00"    }



    # INTERFACE #

    if ( (IsChecked $Redux.UI.ButtonPositions) -or (IsChecked $Redux.UI.HUD)) {
        ChangeBytes -Offset "B57F03" -Values "04" -Add # A Button / Text - X position (BA -> BE, +04)
        ChangeBytes -Offset "B586A7" -Values "0E" -Add # A Button / Text - Y position (09 -> 17, +0E)
        ChangeBytes -Offset "B57EEF" -Values "07" -Add # B Button        - X position (A0 -> A7, +07)
        ChangeBytes -Offset "B589EB" -Values "07" -Add # B Text          - X position (94 -> 9B, +07)
    }

    if (IsChecked $Redux.UI.GCScheme) { # Z to L + L to D-Pad textures
        if (IsLanguage $Redux.Text.PauseScreen)   { PatchBytes -Offset "844540"  -Texture -Patch "GameCube\l_pause_screen_button_mm.bin" }
        else                                      { PatchBytes -Offset "844540"  -Texture -Patch "GameCube\l_pause_screen_button.bin" }
        PatchBytes -Offset "92C100"  -Texture -Patch "GameCube\dpad_text_icon.bin"
        PatchBytes -Offset "92C200"  -Texture -Patch "GameCube\l_text_icon.bin"
        if (TestFile ($GameFiles.textures + "\GameCube\l_targeting_" + $LanguagePatch.code + ".bin")) {
            if ($LanguagePatch.l_target_jpn -eq 1)   { $offset = "1A0B300" }
            else                                     { $offset = "1A35680" }
            PatchBytes -Offset $offset -Texture -Patch ("GameCube\l_targeting_" + $LanguagePatch.code + ".bin")
        }
    }

    if ( !((IsIndex -Elem $Redux.UI.ButtonSize -Text "Large") -and (IsIndex -Elem $Redux.UI.ButtonStyle -Text "Ocarina of Time")) ) {
        PatchBytes -Offset "1A3CA00" -Shared -Patch ("Buttons\" + $Redux.UI.ButtonSize.Text.replace(" (default)", "") + "\" + $Redux.UI.ButtonStyle.Text.replace(" (default)", "") + ".bin")
    }

    if ( (IsIndex -Elem $Redux.UI.BlackBars -Index 2) -or (IsIndex -Elem $Redux.UI.BlackBars -Index 4) ) { ChangeBytes -Offset "B0F680" -Values "00 00 00 00" }
    if ( (IsIndex -Elem $Redux.UI.BlackBars -Index 3) -or (IsIndex -Elem $Redux.UI.BlackBars -Index 4) ) {
        ChangeBytes -Offset "B0F5A4" -Values "00 00 00 00"
        ChangeBytes -Offset "B0F5D4" -Values "00 00 00 00"
        ChangeBytes -Offset "B0F5E4" -Values "00 00 00 00"
        ChangeBytes -Offset "B0F688" -Values "00 00 00 00"
    }

    if ( (IsChecked $Redux.UI.HUD) -or (IsChecked $Redux.UI.DungeonIcons) ) {
        PatchBytes -Offset "85F980"  -Shared -Patch "HUD\Dungeon Map Link\Majora's Mask.bin"
        PatchBytes -Offset "85FB80"  -Shared -Patch "HUD\Dungeon Map Skull\Majora's Mask.bin"
        PatchBytes -Offset "1A3E580" -Shared -Patch "HUD\Dungeon Map Chest\Majora's Mask.bin"
    }

    if   (IsChecked $Redux.UI.CenterNaviPrompt)                              { ChangeBytes -Offset "B582DF"  -Values "01" -Subtract }
    if ( (IsChecked $Redux.UI.HUD) -or (IsChecked $Redux.UI.Rupees)      )   { PatchBytes  -Offset "1A3DF00" -Shared -Patch "HUD\Rupees\Majora's Mask.bin" }
    if ( (IsChecked $Redux.UI.HUD) -or (IsChecked $Redux.UI.DungeonKeys) )   { PatchBytes  -Offset "1A3DE00" -Shared -Patch "HUD\Keys\Majora's Mask.bin"   }
    if   (IsDefault $Redux.UI.Hearts -Not)                                   { PatchBytes  -Offset "1A3C000" -Shared -Patch ("HUD\Hearts\" + $Redux.UI.Hearts.Text.replace(" (default)", "") + ".bin") }
    if   (IsDefault $Redux.UI.Magic  -Not)                                   { PatchBytes  -Offset "1A3F8C0" -Shared -Patch ("HUD\Magic\"  + $Redux.UI.Magic.Text.replace(" (default)", "")  + ".bin") }
    if   (IsChecked $Redux.UI.HUD)                                           { PatchBytes  -Offset "1A3C000" -Shared -Patch "HUD\Hearts\Majora's Mask.bin"; PatchBytes -Offset "1A3F8C0" -Shared -Patch "HUD\Magic\Majora's Mask.bin" }



    # HIDE HUD #

    if ( (IsChecked $Redux.Hide.AButton) -or (IsChecked $Redux.Hide.Everything) ) {
        ChangeBytes -Offset "B586B0" -Values "00 00 00 00" # A Button (scale)
        ChangeBytes -Offset "AE7D0E" -Values "03 10"       # A Button - Text (DMA)
        ChangeBytes -Offset "7540"   -Values "03 10 00 00 03 10 57 00 03 10 00 00"
    } 

    if ( (IsChecked $Redux.Hide.BButton)      -or (IsChecked $Redux.Hide.Everything) )   { ChangeBytes -Offset "B57EEC" -Values "24 02 03 A0"; ChangeBytes -Offset "B57EFC" -Values "24 0A 03 A2"; ChangeBytes -Offset "B589D4" -Values "24 0F 03 97"; ChangeBytes -Offset "B589E8" -Values "24 19 03 94" } # B Button -> Icon / Ammo / Japanese / English
    if ( (IsChecked $Redux.Hide.StartButton)  -or (IsChecked $Redux.Hide.Everything) )   { ChangeBytes -Offset "B584EC" -Values "24 19 03 84"; ChangeBytes -Offset "B58490" -Values "24 18 03 7A"; ChangeBytes -Offset "B5849C" -Values "24 0E 03 78" } # Start Button   -> Button / Japanese / English
    if ( (IsChecked $Redux.Hide.CupButton)    -or (IsChecked $Redux.Hide.Everything) )   { ChangeBytes -Offset "B584C0" -Values "24 19 03 FE"; ChangeBytes -Offset "B582DC" -Values "24 0E 03 F7"                                                     } # C-Up Button    -> Button / Navi Text
    if ( (IsChecked $Redux.Hide.CLeftButton)  -or (IsChecked $Redux.Hide.Everything) )   { ChangeBytes -Offset "B58504" -Values "24 19 03 E3"; ChangeBytes -Offset "B5857C" -Values "24 19 03 E3"; ChangeBytes -Offset "B58DC4" -Values "24 0E 03 E4" } # C-Left Button  -> Button / Icon / Ammo
    if ( (IsChecked $Redux.Hide.CDownButton)  -or (IsChecked $Redux.Hide.Everything) )   { ChangeBytes -Offset "B58510" -Values "24 0F 03 F9"; ChangeBytes -Offset "B58588" -Values "24 0F 03 F9"; ChangeBytes -Offset "B58C40" -Values "24 06 02 FA" } # C-Down Button  -> Button / Icon / Ammo
    if ( (IsChecked $Redux.Hide.CRightButton) -or (IsChecked $Redux.Hide.Everything) )   { ChangeBytes -Offset "B5851C" -Values "24 19 03 0F"; ChangeBytes -Offset "B58594" -Values "24 19 03 0F"; ChangeBytes -Offset "B58DE0" -Values "24 19 03 10" } # C-Right Button -> Button / Icon / Ammo
    if ( (IsChecked $Redux.Hide.AreaTitle)    -or (IsChecked $Redux.Hide.Everything) )   { ChangeBytes -Offset "BE2B10" -Values "24 07 03 A0" } # Area Titles
    if ( (IsChecked $Redux.Hide.DungeonTitle) -or (IsChecked $Redux.Hide.Everything) )   { ChangeBytes -Offset "AC8828" -Values "24 07 03 A0" } # Dungeon Titles
    if ( (IsChecked $Redux.Hide.Carrots)      -or (IsChecked $Redux.Hide.Everything) )   { ChangeBytes -Offset "B58348" -Values "24 0F 03 6E" } # Epona Carrots    
    if ( (IsChecked $Redux.Hide.Hearts)       -or (IsChecked $Redux.Hide.Everything) )   { ChangeBytes -Offset "ADADEC" -Values "10 00"       } # Disable Hearts Render

    if ( (IsChecked $Redux.Hide.Magic) -or (IsChecked $Redux.Hide.Everything) ) {
        ChangeBytes -Offset "B587C0" -Values "24 0F 03 1A"; ChangeBytes -Offset "B587A0" -Values "24 0E 01 22"; ChangeBytes -Offset "B587B4" -Values "24 19 01 2A" # Magic Meter / Magic Bar - Small (Y pos) / Magic Bar - Large (Y pos)
    }

    if ( (IsChecked $Redux.Hide.Icons) -or (IsChecked $Redux.Hide.Everything) ) {
        ChangeBytes -Offset "B58CFC" -Values "24 0F 00 00" # Clock - Digits (scale)
        $Values = @();     for ($i=0; $i -lt 256; $i++) { $Values += 0 };     ChangeBytes -Offset "1A3E000" -Values $Values     # Clock - Icon
        $Values = @();     for ($i=0; $i -lt 768; $i++) { $Values += 0 };     ChangeBytes -Offset "1A3E600" -Values $Values     # Score Counter - Icon
    }

    <#if ( (IsChecked $Redux.Hide.Minimaps) -or (IsChecked $Redux.Hide.Everything) ) {
        $Values = @(); for ($i=0; $i -lt 20; $i++) { $Values += 3 }; ChangeBytes -Offset "B6C814" -Values $values -Interval 2 # Minimaps
        $Values = @(); for ($i=0; $i -lt 20; $i++) { $Values += 8 }; ChangeBytes -Offset "B6C878" -Values $values -Interval 8 # Arrows
        $Values = @(); for ($i=0; $i -lt 24; $i++) { $Values += 3 }; ChangeBytes -Offset "B6C9FA" -Values $values -Interval 2 # Dungeon Icons
        ChangeBytes -Offset "58AF0"  -Values "03" # Dungeon Map
        ChangeBytes -Offset "B6C87A" -Values "03" # Dungeon Icon - Bottom of the Well   ChangeBytes -Offset "B6CA00" -Values "03" # Dungeon Icon - Inside the Deku Tree       ChangeBytes -Offset "B6CA02" -Values "03" # Dungeon Icon - Forest Temple
        ChangeBytes -Offset "B6CA04" -Values "03" # Dungeon Icon - ?                    ChangeBytes -Offset "B6CA08" -Values "03" # Dungeon Icon - Inside Jabu-Jabu's Belly   ChangeBytes -Offset "B6CA0E" -Values "03" # Dungeon Icon - Spirit Temple
        ChangeBytes -Offset "B6CA16" -Values "03" # Dungeon Icon - Dodongo's Cavern     ChangeBytes -Offset "B6CA18" -Values "03" # Dungeon Icon - Fire Temple                ChangeBytes -Offset "B6CA1E" -Values "03" # Dungeon Icon - Ganon's Castle
        ChangeBytes -Offset "B6CA20" -Values "03" # Dungeon Icon - Shadow Temple        ChangeBytes -Offset "B6CA22" -Values "03" # Dungeon Icon - Water Temple               ChangeBytes -Offset "B6CA26" -Values "03" # Dungeon Icon - ?
    }#>

    if ( (IsChecked $Redux.Hide.Rupees)      -or (IsChecked $Redux.Hide.Everything) )   { ChangeBytes -Offset "AEB7B0" -Values "24 0C 03 1A"; ChangeBytes -Offset "AEBC48" -Values "24 0D 01 CE" } # Rupees - Icon / Rupees - Text (Y pos)
    if ( (IsChecked $Redux.Hide.DungeonKeys) -or (IsChecked $Redux.Hide.Everything) )   { ChangeBytes -Offset "AEB8AC" -Values "24 0F 03 1A"; ChangeBytes -Offset "AEBA00" -Values "24 19 01 BE" } # Key    - Icon / Key    - Text (Y pos)
    if   (IsChecked $Redux.Hide.Credits)                                                { PatchBytes  -Offset "966000" -Patch "Message\credits.bin" }




    # STYLES #

    if (IsDefault $Redux.Styles.HairColor -Not) {
        $offsetChild = -1; $folderChild = "" 
        $offsetAdult = -1; $folderAdult = ""

        if     (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Original")                      { $offsetChild = "F04A40"; $folderChild = "Ocarina of Time" }
        elseif (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Majora's Mask Eyes")            { $offsetChild = "F04A40"; $folderChild = "Ocarina of Time" }
        elseif (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Sashed")                        { $offsetChild = "F04A40"; $folderChild = "Ocarina of Time" }
        elseif (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Majora's Mask Eyes + Sashed")   { $offsetChild = "F04A40"; $folderChild = "Ocarina of Time" }
        elseif (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Majora's Mask")                 { $offsetChild = "FC3400"; $folderChild = "Majora's Mask"   }
        elseif (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Majora's Mask + OoT Eyes")      { $offsetChild = "FC3400"; $folderChild = "Majora's Mask"   }

        if     (IsIndex -Elem $Redux.Graphics.AdultModels -Text "Original")        { $offsetAdult = "F04A40"; $folderAdult = "Ocarina of Time" }
      # elseif (IsIndex -Elem $Redux.Graphics.AdultModels -Text "Majora's Mask")   { $offsetAdult = "F8DF00"; $folderAdult = "Adult Link (MM)" }

        if ($offsetChild -ne $offsetAdult) {
            if ($offsetChild -gt -1) { PatchBytes -Offset $offsetChild -Shared -Patch ("Hair\" + $folderChild + "\" + $Redux.Styles.HairColor.Text + ".bin") }
            if ($offsetAdult -gt -1) { PatchBytes -Offset $offsetAdult -Shared -Patch ("Hair\" + $folderAdult + "\" + $Redux.Styles.HairColor.Text + ".bin") }
        }
        elseif ($offsetChild -gt -1) { PatchBytes -Offset $offsetChild -Shared -Patch ("Hair\" + $folderChild + "\" + $Redux.Styles.HairColor.Text + ".bin") }
    }

    if (IsDefault $Redux.Styles.RegularChests -Not)   { PatchBytes -Offset "FEC798" -Shared -Patch ("Chests\" + $Redux.Styles.RegularChests.Text + ".front"); PatchBytes -Offset "FED798" -Shared -Patch ("Chests\" + $Redux.Styles.RegularChests.Text + ".back") }
    if (IsDefault $Redux.Styles.BossChests    -Not)   { PatchBytes -Offset "FEE798" -Shared -Patch ("Chests\" + $Redux.Styles.BossChests.Text    + ".front"); PatchBytes -Offset "FEDF98" -Shared -Patch ("Chests\" + $Redux.Styles.BossChests.Text    + ".back") }
    if (IsDefault $Redux.Styles.Crates        -Not)   { PatchBytes -Offset "F7ECA0" -Shared -Patch ("Crates\" + $Redux.Styles.Crates.Text        + ".bin") }
    if (IsDefault $Redux.Styles.Pots          -Not)   { PatchBytes -Offset "F7D8A0" -Shared -Patch ("Pots\"   + $Redux.Styles.Pots.Text          + ".bin") }


    # SOUNDS / VOICES #

    if ($GamePatch.options -eq 1) {
        if (IsChecked $Redux.Restore.FireTemple) { $offset = "1EF340" } else { $offset = "1DFC00" }
        $file = "Voices Child\" + $Redux.Sounds.ChildVoices.Text.replace(" (default)", "") + ".bin"
        if (TestFile ($GameFiles.binaries + "\" + $file)) { PatchBytes -Offset $offset -Patch ($file) }

        if (IsChecked $Redux.Restore.FireTemple) { $offset = "19D920" } else { $offset = "18E1E0" }
        $file = "Voices Adult\" + $Redux.Sounds.AdultVoices.Text.replace(" (default)", "") + ".bin"
        if (TestFile ($GameFiles.binaries + "\" + $file)) { PatchBytes -Offset $offset -Patch ($file) }
    }
    elseif ($GamePatch.title -like "*Master of Time*") {
        $file = "Voices Adult\" + $Redux.Sounds.AdultVoices.Text.replace(" (default)", "") + ".bin"
        if (TestFile ($GameFiles.binaries + "\" + $file)) { PatchBytes -Offset "18E1E0" -Patch ($file) }
    }
    elseif ($GamePatch.title -like "*Dusk & Dusk*") {
        $file = "Voices Child\" + $Redux.Sounds.ChildVoices.Text.replace(" (default)", "") + ".bin"
        if (TestFile ($GameFiles.binaries + "\" + $file)) { PatchBytes -Offset "1DFC00" -Patch ($file) }
    }

    if (IsIndex -Elem $Redux.Sounds.Instrument -Not) { ChangeBytes -Offset "B53C7B" -Values ($Redux.Sounds.Instrument.SelectedIndex+1); ChangeBytes -Offset "B4BF6F" -Values ($Redux.Sounds.Instrument.SelectedIndex+1) }



    # SFX SOUND EFFECTS #

    if (IsIndex -Elem $Redux.SFX.Navi -Not) {
        ChangeBytes -Offset "AE7EF2" -Values (GetSFXID $Redux.SFX.Navi.Text)
        ChangeBytes -Offset "C26C7E" -Values (GetSFXID $Redux.SFX.Navi.Text)
    }

    if (IsIndex -Elem $Redux.SFX.Nightfall -Not) {
        ChangeBytes -Offset "AD3466" -Values (GetSFXID $Redux.SFX.Nightfall.Text)
        ChangeBytes -Offset "AD7A2E" -Values (GetSFXID $Redux.SFX.Nightfall.Text)
    }

    if (IsIndex -Elem $Redux.SFX.Horse -Not) {
        ChangeBytes -Offset "C18832" -Values (GetSFXID $Redux.SFX.Horse.Text);   ChangeBytes -Offset "C18C32" -Values (GetSFXID $Redux.SFX.Horse.Text);   ChangeBytes -Offset "C19A7E" -Values (GetSFXID $Redux.SFX.Horse.Text);
        ChangeBytes -Offset "C19CBE" -Values (GetSFXID $Redux.SFX.Horse.Text);   ChangeBytes -Offset "C1A1F2" -Values (GetSFXID $Redux.SFX.Horse.Text);   ChangeBytes -Offset "C1A3B6" -Values (GetSFXID $Redux.SFX.Horse.Text);
        ChangeBytes -Offset "C1B08A" -Values (GetSFXID $Redux.SFX.Horse.Text);   ChangeBytes -Offset "C1B556" -Values (GetSFXID $Redux.SFX.Horse.Text);   ChangeBytes -Offset "C1C28A" -Values (GetSFXID $Redux.SFX.Horse.Text);
        ChangeBytes -Offset "C1CC36" -Values (GetSFXID $Redux.SFX.Horse.Text);   ChangeBytes -Offset "C1EB4A" -Values (GetSFXID $Redux.SFX.Horse.Text);   ChangeBytes -Offset "C1F18E" -Values (GetSFXID $Redux.SFX.Horse.Text);
        ChangeBytes -Offset "C6B136" -Values (GetSFXID $Redux.SFX.Horse.Text);   ChangeBytes -Offset "C6BBA2" -Values (GetSFXID $Redux.SFX.Horse.Text);   ChangeBytes -Offset "C1E93A" -Values (GetSFXID $Redux.SFX.Horse.Text)
        ChangeBytes -Offset "C6B366" -Values (GetSFXID $Redux.SFX.Horse.Text);   ChangeBytes -Offset "C6B562" -Values (GetSFXID $Redux.SFX.Horse.Text)
    }

    if (IsIndex -Elem $Redux.SFX.FileCursor -Not) {
        ChangeBytes -Offset "BA165E" -Values (GetSFXID $Redux.SFX.FileCursor.Text);   ChangeBytes -Offset "BA1C1A" -Values (GetSFXID $Redux.SFX.FileCursor.Text);   ChangeBytes -Offset "BA2406" -Values (GetSFXID $Redux.SFX.FileCursor.Text);
        ChangeBytes -Offset "BA327E" -Values (GetSFXID $Redux.SFX.FileCursor.Text);   ChangeBytes -Offset "BA3936" -Values (GetSFXID $Redux.SFX.FileCursor.Text);   ChangeBytes -Offset "BA77C2" -Values (GetSFXID $Redux.SFX.FileCursor.Text);
        ChangeBytes -Offset "BA7886" -Values (GetSFXID $Redux.SFX.FileCursor.Text);   ChangeBytes -Offset "BA7A06" -Values (GetSFXID $Redux.SFX.FileCursor.Text);   ChangeBytes -Offset "BA7A6E" -Values (GetSFXID $Redux.SFX.FileCursor.Text);
        ChangeBytes -Offset "BA7AE6" -Values (GetSFXID $Redux.SFX.FileCursor.Text);   ChangeBytes -Offset "BA7D6A" -Values (GetSFXID $Redux.SFX.FileCursor.Text);   ChangeBytes -Offset "BA8186" -Values (GetSFXID $Redux.SFX.FileCursor.Text);
        ChangeBytes -Offset "BA822E" -Values (GetSFXID $Redux.SFX.FileCursor.Text);   ChangeBytes -Offset "BA82A2" -Values (GetSFXID $Redux.SFX.FileCursor.Text);   ChangeBytes -Offset "BAA11E" -Values (GetSFXID $Redux.SFX.FileCursor.Text);
        ChangeBytes -Offset "BAE7C6" -Values (GetSFXID $Redux.SFX.FileCursor.Text)
    }

    if (IsIndex -Elem $Redux.SFX.FileSelect -Not) {
        ChangeBytes -Offset "BA1BBE" -Values (GetSFXID $Redux.SFX.FileSelect.Text);   ChangeBytes -Offset "BA23CE" -Values (GetSFXID $Redux.SFX.FileSelect.Text);   ChangeBytes -Offset "BA2956" -Values (GetSFXID $Redux.SFX.FileSelect.Text);
        ChangeBytes -Offset "BA321A" -Values (GetSFXID $Redux.SFX.FileSelect.Text);   ChangeBytes -Offset "BA72F6" -Values (GetSFXID $Redux.SFX.FileSelect.Text);   ChangeBytes -Offset "BA8106" -Values (GetSFXID $Redux.SFX.FileSelect.Text);
        ChangeBytes -Offset "BA82EE" -Values (GetSFXID $Redux.SFX.FileSelect.Text);   ChangeBytes -Offset "BA9DAE" -Values (GetSFXID $Redux.SFX.FileSelect.Text);   ChangeBytes -Offset "BA9EAE" -Values (GetSFXID $Redux.SFX.FileSelect.Text);
        ChangeBytes -Offset "BA9FD2" -Values (GetSFXID $Redux.SFX.FileSelect.Text);   ChangeBytes -Offset "BAE6D6" -Values (GetSFXID $Redux.SFX.FileSelect.Text)
    }

    if (IsIndex -Elem $Redux.SFX.ZTarget    -Not)   { ChangeBytes -Offset "AE7EC6" -Values (GetSFXID $Redux.SFX.ZTarget.Text) }
    if (IsIndex -Elem $Redux.SFX.LowHP      -Not)   { ChangeBytes -Offset "ADBA1A" -Values (GetSFXID $Redux.SFX.LowHP.Text) }
    if (IsIndex -Elem $Redux.SFX.HoverBoots -Not)   { ChangeBytes -Offset "BDBD8A" -Values (GetSFXID $Redux.SFX.HoverBoots.Text) }
    


    # MUSIC #

    if ($GamePatch.options -eq 1) {
        if (IsAdvanced) {
            if (IsChecked $Redux.Restore.FireTemple) {
                PatchReplaceMusic -bankPointerTableStart "B899EC" -BankPointerTableEnd "B89AD0" -PointerTableStart "B89AE0" -PointerTableEnd "B8A1C0" -SeqStart "39130" -SeqEnd "88BB0"
                PatchMuteMusic -SequenceTable "B89AE0" -Sequence "29DE0" -Length 108
            }
            else {
                PatchReplaceMusic -bankPointerTableStart "B899EC" -BankPointerTableEnd "B89AD0" -PointerTableStart "B89AE0" -PointerTableEnd "B8A1C0" -SeqStart "29DE0" -SeqEnd "79470"
                PatchMuteMusic -SequenceTable "B89AE0" -Sequence "29DE0" -Length 108
            }
        }

        if (IsIndex -Elem $Redux.Music.FileSelect -Text $Redux.Music.FileSelect.default -Not) {
            foreach ($track in $Files.json.music.tracks) {
                if ($Redux.Music.FileSelect.Text -eq $track.title) {
                    ChangeBytes -Offset "BAFEE3" -Values $track.id
                    break
                }
            }
        }
    }
    


    # HERO MODE #

    if (IsIndex -Elem $Redux.Hero.MonsterHP -Index 3 -Not) { # Monsters
        if     (IsIndex -Elem $Redux.Hero.MonsterHP)   { $multi = 0   }
        else                                           { [float]$multi = [float]$Redux.Hero.MonsterHP.text.split('x')[0] }

        MultiplyBytes -Offset "D74393" -Factor $multi; MultiplyBytes -Offset "C2F97F" -Factor $multi; MultiplyBytes -Offset "C0DEF8" -Factor $multi # Like-Like, Peehat, Octorok
        MultiplyBytes -Offset "D463BF" -Factor $multi; MultiplyBytes -Offset "CA85DC" -Factor $multi; MultiplyBytes -Offset "DADBAF" -Factor $multi # Shell Blade, Mad Scrub, Spike
        MultiplyBytes -Offset "C83647" -Factor $multi; MultiplyBytes -Offset "C83817" -Factor $multi; MultiplyBytes -Offset "C836AB" -Factor $multi # Moblin, Moblin (Spear), Moblin (Club)
        MultiplyBytes -Offset "C5F69C" -Factor $multi; MultiplyBytes -Offset "CAAF9C" -Factor $multi; MultiplyBytes -Offset "C55A78" -Factor $multi # Biri, Bari, Shabom
        MultiplyBytes -Offset "CD724F" -Factor $multi; MultiplyBytes -Offset "EDC597" -Factor $multi; MultiplyBytes -Offset "C0B804" -Factor $multi # ReDead / Gibdo, Stalchild, Poe
        MultiplyBytes -Offset "C6471B" -Factor $multi; MultiplyBytes -Offset "C51A9F" -Factor $multi # Torch Slug, Gohma Larva
        MultiplyBytes -Offset "CB1903" -Factor $multi; MultiplyBytes -Offset "CB2DD7" -Factor $multi # Blue Bubble, Red Blue
        MultiplyBytes -Offset "D76A07" -Factor $multi; MultiplyBytes -Offset "C5FC3F" -Factor $multi # Tentacle, Tailpasaran
        MultiplyBytes -Offset "C693CC" -Factor $multi; MultiplyBytes -Offset "EB797C" -Factor $multi # Stinger (Land), Stinger (Water)
        MultiplyBytes -Offset "C2B183" -Factor $multi; MultiplyBytes -Offset "C2B1F7" -Factor $multi # Red Tektite, Blue Tektite
        MultiplyBytes -Offset "C1097C" -Factor $multi; MultiplyBytes -Offset "CD582C" -Factor $multi # Wallmaster, Floormaster
        MultiplyBytes -Offset "C2DEE7" -Factor $multi; MultiplyBytes -Offset "C2DF4B" -Factor $multi # Leever (Green / Purple)
        MultiplyBytes -Offset "CC6CA7" -Factor $multi; MultiplyBytes -Offset "CC6CAB" -Factor $multi # Beamos

        MultiplyBytes -Offset "C11177" -Factor $multi; MultiplyBytes -Offset "C599BC" -Factor $multi # Dodongo, Baby Dodongo
        MultiplyBytes -Offset "CE60C4" -Factor $multi                                                # Skullwalltula (Gold)
        
        if ($multi -ge 2) {
            ChangeBytes -Offset "B65660" -Values "10 01 01 01 10 02 01 01 01 01 01 02 02 02 00 00 00 01 01 00 00 00 01 01 01 01 01 01 00 00 00 00" # Skulltula
            ChangeBytes -Offset "DFE767" -Values "F1 F0 F0 F1 F1 F0 F1 F2 22 F0 F0 F0 F0 F0 22 00 00 00 00 F0 F2 F1 F0 F4 F2"                      # Freezard
            
        }

      # MultiplyBytes -Offset "EEF780" -Factor $multi # Guay
      # MultiplyBytes -Offset "xxxxxx" -Factor $multi # Peehat Larva                       (HP: 01)   C2F8D0 -> C32FD0 (Length: 3700) (ovl_En_Peehat)
      # MultiplyBytes -Offset "xxxxxx" -Factor $multi # Anubis                             (HP: 01)   D79240 -> D7A4F0 (Length: 12B0) (ovl_En_Anubice)
      # MultiplyBytes -Offset "DFC9A3" -Factor $multi; MultiplyBytes -Offset "DFDE43" -Factor $multi # Freezard
      # MultiplyBytes -Offset "C96A5B" -Factor $multi; MultiplyBytes -Offset "C96B0C" -Factor $multi # Armos
      # MultiplyBytes -Offset "C6417C" -Factor $multi; MultiplyBytes -Offset "C15814" -Factor $multi; MultiplyBytes -Offset "CB1BCB" -Factor $multi  # Skulltula, Keese, Green Bubble
      # MultiplyBytes -Offset "CE39AF" -Factor $multi                                                                                                # Skullwalltula
    }

    if (IsIndex -Elem $Redux.Hero.MiniBossHP -Index 3 -Not) { # Mini-Bosses
        if (IsIndex -Elem $Redux.Hero.MiniBossHP)   { $multi = 0   }
        else                                        { [float]$multi = [float]$Redux.Hero.MiniBossHP.text.split('x')[0] }

        MultiplyBytes -Offset "BFADAB" -Factor $multi; MultiplyBytes -Offset "D09283" -Factor $multi; MultiplyBytes -Offset "CDE1FC" -Factor $multi # Stalfos, Dead Hand, Poe Sisters
        MultiplyBytes -Offset "C3452F" -Factor $multi; MultiplyBytes -Offset "C3453B" -Factor $multi # Lizalfos, Dinolfos
        MultiplyBytes -Offset "ED80EB" -Factor $multi # Wolfos
        MultiplyBytes -Offset "EBC8B7" -Factor $multi # Gerudo Fighter
        MultiplyBytes -Offset "CF2667" -Factor $multi # Flare Dancer
        MultiplyBytes -Offset "DEF87F" -Factor $multi # Skull Kid
        MultiplyBytes -Offset "D49F50" -Factor $multi # Big Octo

        if ($multi -eq 255 -and !$multiply) { ChangeBytes -Offset "DE9A1B" -Values "FF" ChangeBytes -Offset "DEB367" -Values "7F"; ChangeBytes -Offset "DEB34F" -Values "7F" } # Iron Knuckle (phase 1), Iron Knuckle (phase 2)
        elseif ($multi -gt 0) {
            MultiplyBytes -Offset "DE9A1B" -Factor $multi                                      # Iron Knuckle (phase 1)
            $value = $ByteArrayGame[(GetDecimal "DEB367")]; $value--; $value *= $multi; $value++;
            ChangeBytes -Offset "DEB367" -Values $value; ChangeBytes -Offset "DEB34F" -Values $value # Iron Knuckle (phase 2)
        }
        else { ChangeBytes -Offset "DE9A1B" -Values "01"; ChangeBytes -Offset "DEB367" -Values "01"; ChangeBytes -Offset "DEB34F" -Values "01" } # Iron Knuckle (phase 1), Iron Knuckle (phase 2)
    }
    
    if (IsIndex -Elem $Redux.Hero.BossHP -Index 3 -Not) { # Bosses
        if (IsIndex -Elem $Redux.Hero.BossHP)   { $multi = 0   }
        else                                    { [float]$multi = [float]$Redux.Hero.BossHP.text.split('x')[0] }

        MultiplyBytes -Offset "C44F2B" -Factor $multi; ChangeBytes -Offset "C486CC" -Values "00 00 00 00" # Gohma
        MultiplyBytes -Offset "D258BB" -Factor $multi; MultiplyBytes  -Offset "D25B0B" -Factor $multi # Barinade
        MultiplyBytes -Offset "D64EFB" -Factor $multi; MultiplyBytes  -Offset "D6223F" -Factor $multi # Twinrova
        MultiplyBytes -Offset "C3B9FF" -Factor $multi # King Dodongo
        MultiplyBytes -Offset "CE6D2F" -Factor $multi # Volvagia
        MultiplyBytes -Offset "D3B4A7" -Factor $multi # Morpha
        MultiplyBytes -Offset "DAC824" -Factor $multi # Bongo Bongo
        MultiplyBytes -Offset "D7FDA3" -Factor $multi # Ganondorf 
        
        if ($multi -gt 0) {
            MultiplyBytes -Offset "C91F8F" -Factor $multi # Phantom Ganon (phase 1)
            $value = $ByteArrayGame[(GetDecimal "C91F8F")]; $value -= (2 * 3 * $multi); $value++
            ChangeBytes -Offset "CAFF33" -Values $value # Phantom Ganon (phase 2)

            MultiplyBytes -Offset "E82AFB" -Factor $multi # Ganon (phase 1)
            $value = $ByteArrayGame[(GetDecimal "E87F2F")]; $value--; $value *= $multi; $value++;
            ChangeBytes -Offset "E87F2F" -Values $value # Ganon (phase 2)
        }
        else {
            ChangeBytes -Offset "C91F8F" -Values "04"; ChangeBytes -Offset "CAFF33" -Values "03" # Phantom Ganon (phase 1), Phantom Ganon (phase 2)
            ChangeBytes -Offset "E82AFB" -Values "04"; ChangeBytes -Offset "E87F2F" -Values "03" # Ganon (phase 1), Ganon (phase 2)
        }
    }
    
    if     (IsText -Elem $Redux.Hero.Damage -Compare "2x Damage")   { ChangeBytes -Offset "BD35FA" -Values "2B C3" }
    elseif (IsText -Elem $Redux.Hero.Damage -Compare "4x Damage")   { ChangeBytes -Offset "BD35FA" -Values "2B 83" }
    elseif (IsText -Elem $Redux.Hero.Damage -Compare "8x Damage")   { ChangeBytes -Offset "BD35FA" -Values "2B 43" }
    elseif (IsText -Elem $Redux.Hero.Damage -Compare "OHKO Mode")   { ChangeBytes -Offset "BD35FA" -Values "2A 03" }

    if     (IsText -Elem $Redux.Hero.MagicUsage -Compare "2x Magic Usage")   { ChangeBytes -Offset "AE84FA" -Values "2C","40" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "4x Magic Usage")   { ChangeBytes -Offset "AE84FA" -Values "2C","80" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "8x Magic Usage")   { ChangeBytes -Offset "AE84FA" -Values "2C","C0" }

    if (IsChecked $Redux.Hero.GraveyardKeese) {
        ChangeBytes -Offset "202F389" -Values "0E"; ChangeBytes -Offset "202F3BB" -Values "0D"; ChangeBytes -Offset "202F3DD" -Values "13"; ChangeBytes -Offset "202F3EB" -Values "03"; ChangeBytes -Offset "202F3ED" -Values "13"; ChangeBytes -Offset "202F3FB" -Values "03"
        ChangeBytes -Offset "202F3FD" -Values "13"; ChangeBytes -Offset "202F40B" -Values "03"; ChangeBytes -Offset "202F40D" -Values "13"; ChangeBytes -Offset "202F41B" -Values "03"; ChangeBytes -Offset "202F41D" -Values "13"; ChangeBytes -Offset "202F42B" -Values "03"
        ChangeBytes -Offset "202F779" -Values "0E"; ChangeBytes -Offset "202F7AB" -Values "0D"; ChangeBytes -Offset "202F7CD" -Values "13"; ChangeBytes -Offset "202F7DB" -Values "03"; ChangeBytes -Offset "202F7DD" -Values "13"; ChangeBytes -Offset "202F7EB" -Values "03"
        ChangeBytes -Offset "202F7ED" -Values "13"; ChangeBytes -Offset "202F7FB" -Values "03"; ChangeBytes -Offset "202F7FD" -Values "13"; ChangeBytes -Offset "202F80B" -Values "03"; ChangeBytes -Offset "202F80D" -Values "13"; ChangeBytes -Offset "202F81B" -Values "03"
    }

    if (IsChecked $Redux.Hero.AddLostWoodsOctorok) {
        ChangeBytes -Offset "2150C95" -Values "07 E1" # Child
        ChangeBytes -Offset "2157031" -Values "0C"; ChangeBytes -Offset "215706F" -Values "07"; ChangeBytes -Offset "21570F1" -Values "07"; ChangeBytes -Offset "215A031" -Values "0C"; ChangeBytes -Offset "215A06F" -Values "07"; ChangeBytes -Offset "215A151" -Values "07" # Child
        ChangeBytes -Offset "2163031" -Values "0C"; ChangeBytes -Offset "216306F" -Values "07"; ChangeBytes -Offset "2163151" -Values "07"; ChangeBytes -Offset "2168031" -Values "0C"; ChangeBytes -Offset "216806F" -Values "07"; ChangeBytes -Offset "2168191" -Values "07" # Child
        ChangeBytes -Offset "216E031" -Values "0C"; ChangeBytes -Offset "216E06F" -Values "07"; ChangeBytes -Offset "216E0F1" -Values "07"; ChangeBytes -Offset "2171031" -Values "0C"; ChangeBytes -Offset "217106F" -Values "07"; ChangeBytes -Offset "2171121" -Values "07" # Child
        ChangeBytes -Offset "2178031" -Values "0C"; ChangeBytes -Offset "217806F" -Values "07"; ChangeBytes -Offset "2178141" -Values "07"; ChangeBytes -Offset "217C031" -Values "0C"; ChangeBytes -Offset "217C06F" -Values "07"; ChangeBytes -Offset "217C131" -Values "07" # Adult
        ChangeBytes -Offset "217F031" -Values "0C"; ChangeBytes -Offset "217F06F" -Values "07"; ChangeBytes -Offset "217F161" -Values "07"; ChangeBytes -Offset "2182031" -Values "0C"; ChangeBytes -Offset "218206F" -Values "07"; ChangeBytes -Offset "21820F1" -Values "07" # Adult
    }

    if (IsChecked $Redux.Hero.NoItemDrops) {
        $Values = @()
        for ($i=0; $i -lt 80; $i++) { $Values += 0 }
        ChangeBytes -Offset "B5D6B0" -Values $Values
    }

    if   ( (IsChecked $Redux.Hero.NoRecoveryHearts) -or (IsValue $Redux.Recovery.Hearts -Value 0) )   { ChangeBytes -Offset "A895B7"  -Values "2E"          }
    if     (IsChecked $Redux.Hero.NoBottledFairy)                                                     { ChangeBytes -Offset "BF0264"  -Values "00 00 00 00" }
    if     (IsChecked $Redux.Hero.Arwing)                                                             { ChangeBytes -Offset "2081086" -Values "00 02"; ChangeBytes -Offset "2081114" -Values "01 3B"; ChangeBytes -Offset "2081122" -Values "00 00" }
    elseif (IsChecked $Redux.Hero.LikeLike)                                                           { ChangeBytes -Offset "2081086" -Values "00 D4"; ChangeBytes -Offset "2081114" -Values "00 DD"; ChangeBytes -Offset "2081122" -Values "00 00" }



    # RECOVERY #

    if (IsDefault $Redux.Recovery.Heart       -Not)   { ChangeBytes -Offset "AE6FC6" -Values (Get16Bit $Redux.Recovery.Heart.Text       ) }
    if (IsDefault $Redux.Recovery.Fairy       -Not)   { ChangeBytes -Offset "BEAA4A" -Values (Get16Bit $Redux.Recovery.Fairy.Text       ) }
    if (IsDefault $Redux.Recovery.FairyRevive -Not)   { ChangeBytes -Offset "BDF65A" -Values (Get16Bit $Redux.Recovery.FairyRevive.Text ) }
    if (IsDefault $Redux.Recovery.Milk        -Not)   { ChangeBytes -Offset "BEA64A" -Values (Get16Bit $Redux.Recovery.Milk.Text        ) }
    if (IsDefault $Redux.Recovery.RedPotion   -Not)   { ChangeBytes -Offset "BEA616" -Values (Get16Bit $Redux.Recovery.RedPotion.Text   ) }
    


    # MINIGAMES #

    if ($GamePatch.options -eq 1) {
        if ( (IsChecked $Redux.Minigames.EasierMinigames) -or  (IsChecked $Redux.Minigames.Ocarina) )   { ChangeBytes -Offset "DF2204" -Values "24 03 00 02" } # Skullkid Ocarina
        if ( (IsChecked $Redux.Minigames.EasierMinigames) -or  (IsChecked $Redux.Minigames.Dampe) )     { ChangeBytes -Offset "CC4024" -Values "00 00 00 00" } # Dampe's Digging Game
    }
    
    if ( (IsChecked $Redux.Minigames.EasierMinigames) -or  (IsChecked $Redux.Minigames.Fishing) ) {
        ChangeBytes -Offset "DBF428" -Values "0C 10 07 7D 3C 01 42 82 44 81 40 00 44 98 90 00 E6 52"           # Easier Fishing
        ChangeBytes -Offset "DBF484" -Values "00 00 00 00"; ChangeBytes -Offset "DBF4A8" -Values "00 00 00 00" # Easier Fishing
        ChangeBytes -Offset "DCBEAB" -Values "48";          ChangeBytes -Offset "DCBF27" -Values "48"          # Adult Fish size requirement
        ChangeBytes -Offset "DCBF33" -Values "30";          ChangeBytes -Offset "DCBF9F" -Values "30"          # Child Fish size requirement
    }
    if (IsChecked $Redux.Minigames.EasierMinigames) { ChangeBytes -Offset "E2E697" -Values "64"; ChangeBytes -Offset "E2E69B" -Values "28"; ChangeBytes -Offset "E2E69F" -Values "58"; ChangeBytes -Offset "E2E6A3" -Values "4C"; ChangeBytes -Offset "E2E6A7" -Values "4C"; ChangeBytes -Offset "E2D440" -Values "24 19 00 00" }
    elseif (IsChecked $Redux.Minigames.Bowling) {
        ChangeBytes -Offset "E2E697" -Values $Redux.Minigames.Bowling1.value; ChangeBytes -Offset "E2E69B" -Values $Redux.Minigames.Bowling2.value; ChangeBytes -Offset "E2E69F" -Values $Redux.Minigames.Bowling3.value
        ChangeBytes -Offset "E2E6A3" -Values $Redux.Minigames.Bowling4.value; ChangeBytes -Offset "E2E6A7" -Values $Redux.Minigames.Bowling5.value; ChangeBytes -Offset "E2D440" -Values "24 19 00 00"
    }
    


    # EASY MODE #

    if (IsChecked $Redux.EasyMode.NoShieldSteal)         { ChangeBytes -Offset "D74910"  -Values "1000000B"                                          }
    if (IsChecked $Redux.EasyMode.NoTunicSteal)          { ChangeBytes -Offset "D74964"  -Values "1000000A"                                          }
    if (IsChecked $Redux.EasyMode.SkipStealthSequence)   { ChangeBytes -Offset "21F60DE" -Values "05F0"                                              }
    if (IsChecked $Redux.EasyMode.SkipTowerEscape)       { ChangeBytes -Offset "D82A12"  -Values "0517"; ChangeBytes -Offset "B139A2" -Values "0517" }



    # VANILLA DUNGEON ADJUSTMENTS #

    if (IsChecked $Redux.Scenes.WaterTempleActors) {
        $offset = SearchBytes -Start "2634000" -End "263AFB0" -Values "01 CC 01 79"; ChangeBytes -Offset $offset -Values "03 5C" # 263507C
        $offset = AddToOffset -Hex $offset -Add "10";                                ChangeBytes -Offset $offset -Values "03 5C" # 263508C
        $offset = AddToOffset -Hex $offset -Add "10";                                ChangeBytes -Offset $offset -Values "03 5C" # 263509C: Three out of bounds pots
        ChangeBytes -Offset "25CE08F" -Values "51";                ChangeBytes -Offset "25C7221" -Values "0B";          ChangeBytes -Offset "25C7231" -Values "0B" # Unreachable hookshot spot in room 22
        ChangeBytes -Offset "25CE092" -Values "00";                ChangeBytes -Offset "25CE082" -Values "00";          ChangeBytes -Offset "25CE055" -Values "0D" # Restore two keese in room 1
        ChangeBytes -Offset "25CE07A" -Values "FE 39 03 0C FE 51"; ChangeBytes -Offset "25CE08A" -Values "00 4A 03 0C"
    }

    if (IsChecked $Redux.Scenes.RemoveDisruptiveText) {
        ChangeBytes -Offset "27C00BC" -Values "FB"; ChangeBytes -Offset "27C00CC" -Values "FB"; ChangeBytes -Offset "27C00DC" -Values "FB"; ChangeBytes -Offset "27C00EC" -Values "FB"
        ChangeBytes -Offset "27C00FC" -Values "FB"; ChangeBytes -Offset "27C010C" -Values "FB"; ChangeBytes -Offset "27C011C" -Values "FB"; ChangeBytes -Offset "27C012C" -Values "FB"
        ChangeBytes -Offset "27CE080" -Values "FB"; ChangeBytes -Offset "27CE090" -Values "FB"
        ChangeBytes -Offset "2887070" -Values "FB"; ChangeBytes -Offset "2887080" -Values "FB"; ChangeBytes -Offset "2887090" -Values "FB"
        ChangeBytes -Offset "2897070" -Values "FB"; ChangeBytes -Offset "28C7134" -Values "FB"; ChangeBytes -Offset "28D91BC" -Values "FB"; ChangeBytes -Offset "28A60F4" -Values "FB"; ChangeBytes -Offset "28AE084" -Values "FB"; ChangeBytes -Offset "28B9174" -Values "FB"
        ChangeBytes -Offset "28BF168" -Values "FB"; ChangeBytes -Offset "28BF178" -Values "FB"; ChangeBytes -Offset "28BF188" -Values "FB"; ChangeBytes -Offset "28A1144" -Values "FB"; ChangeBytes -Offset "28A6104" -Values "FB"; ChangeBytes -Offset "28D0094" -Values "FB"
    }

    if (IsChecked $Redux.Scenes.DodongosCavernGossipStone) { ChangeBytes -Offset "1F281FE" -Values "38" }



    # SCENE ADJUSTMENTS #

    if (IsChecked $Redux.Scenes.CorrectTimeDoor) {
        ChangeBytes -Offset "25540C6" -Values "FF FC"; ChangeBytes -Offset "2554226" -Values "FF FC"; ChangeBytes -Offset "255429A" -Values "FF FC"; ChangeBytes -Offset "2554326" -Values "FF FC"; ChangeBytes -Offset "2554446" -Values "FF FC"; ChangeBytes -Offset "25544CE" -Values "FF FC"
        ChangeBytes -Offset "255458E" -Values "FF FC"; ChangeBytes -Offset "255463E" -Values "FF FC"; ChangeBytes -Offset "25546EE" -Values "FF FC"; ChangeBytes -Offset "25547A2" -Values "FF FC"; ChangeBytes -Offset "2554862" -Values "FF FC"; ChangeBytes -Offset "2554902" -Values "FF FC"
    }

    

    if (IsChecked $Redux.Scenes.Graves)               { ChangeBytes -Offset "202039D" -Values "20"; ChangeBytes -Offset "202043C" -Values "24"  }
    if (IsChecked $Redux.Scenes.VisibleGerudoTent)    { ChangeBytes -Offset "D215CB"  -Values "11"                                              }
    if (IsChecked $Redux.Scenes.OpenTimeDoor)         { ChangeBytes -Offset "AC8608"  -Values "00902025848E00A4340100430000000000000000"        }
    if (IsChecked $Redux.Scenes.ChildColossusFairy)   { ChangeBytes -Offset "21A026F" -Values "DD"                                              }
    if (IsChecked $Redux.Scenes.CreaterFairy)         { ChangeBytes -Offset "225E7DC" -Values "00B5000000000000000000000000FFFF"                }
    


    
    # EQUIPMENT COLORS #

    if (IsSet $Redux.Colors.SetEquipment) {
        if (IsDefaultColor -Elem $Redux.Colors.SetEquipment[0] -Not) { # Kokiri Tunic
            ChangeBytes -Offset "B6DA38" -Values @($Redux.Colors.SetEquipment[0].Color.R, $Redux.Colors.SetEquipment[0].Color.G, $Redux.Colors.SetEquipment[0].Color.B)
            if ( (IsText -Elem $Redux.Colors.Equipment[0] -Compare "Randomized" -Not) -and (IsText -Elem $Redux.Colors.Equipment[0] -Compare "Custom" -Not) ) { PatchBytes -Offset "7FE000" -Texture -Patch ("Tunic\" + $Redux.Colors.Equipment[0].text.replace(" (default)", "") + ".bin") }
        }

        if (IsDefaultColor -Elem $Redux.Colors.SetEquipment[1] -Not) { # Goron Tunic
            ChangeBytes -Offset "B6DA3B"  -Values @($Redux.Colors.SetEquipment[1].Color.R, $Redux.Colors.SetEquipment[1].Color.G, $Redux.Colors.SetEquipment[1].Color.B) # Outfit
            ChangeBytes -Offset "16394EC" -Values @($Redux.Colors.SetEquipment[2].Color.R, $Redux.Colors.SetEquipment[2].Color.G, $Redux.Colors.SetEquipment[2].Color.B) # Shop / obtain model
            ChangeBytes -Offset "16394F4" -Values @($Redux.Colors.SetEquipment[2].Color.R, $Redux.Colors.SetEquipment[2].Color.G, $Redux.Colors.SetEquipment[2].Color.B)
            ChangeBytes -Offset "163952C" -Values @($Redux.Colors.SetEquipment[2].Color.R, $Redux.Colors.SetEquipment[2].Color.G, $Redux.Colors.SetEquipment[2].Color.B)
            ChangeBytes -Offset "1639534" -Values @($Redux.Colors.SetEquipment[2].Color.R, $Redux.Colors.SetEquipment[2].Color.G, $Redux.Colors.SetEquipment[2].Color.B)
            if ( (IsText -Elem $Redux.Colors.Equipment[1] -Compare "Randomized" -Not) -and (IsText -Elem $Redux.Colors.Equipment[1] -Compare "Custom" -Not) ) { PatchBytes -Offset "7FF000" -Texture -Patch ("Tunic\" + $Redux.Colors.Equipment[1].text.replace(" (default)", "") + ".bin") }
        }

        if (IsDefaultColor -Elem $Redux.Colors.SetEquipment[2] -Not) { # Zora Tunic
            ChangeBytes -Offset "B6DA3E"  -Values @($Redux.Colors.SetEquipment[2].Color.R, $Redux.Colors.SetEquipment[2].Color.G, $Redux.Colors.SetEquipment[2].Color.B) # Outfit
            ChangeBytes -Offset "163950C" -Values @($Redux.Colors.SetEquipment[2].Color.R, $Redux.Colors.SetEquipment[2].Color.G, $Redux.Colors.SetEquipment[2].Color.B) # Shop / obtain model
            ChangeBytes -Offset "1639514" -Values @($Redux.Colors.SetEquipment[2].Color.R, $Redux.Colors.SetEquipment[2].Color.G, $Redux.Colors.SetEquipment[2].Color.B)
            ChangeBytes -Offset "163954C" -Values @($Redux.Colors.SetEquipment[2].Color.R, $Redux.Colors.SetEquipment[2].Color.G, $Redux.Colors.SetEquipment[2].Color.B)
            ChangeBytes -Offset "1639554" -Values @($Redux.Colors.SetEquipment[2].Color.R, $Redux.Colors.SetEquipment[2].Color.G, $Redux.Colors.SetEquipment[2].Color.B)
            if ( (IsText -Elem $Redux.Colors.Equipment[2] -Compare "Randomized" -Not) -and (IsText -Elem $Redux.Colors.Equipment[2] -Compare "Custom" -Not) ) { PatchBytes -Offset "800000" -Texture -Patch ("Tunic\" + $Redux.Colors.Equipment[2].text.replace(" (default)", "") + ".bin") }
        }

        if (IsDefaultColor -Elem $Redux.Colors.SetEquipment[3] -Not)   { ChangeBytes -Offset "B6DA44" -Values @($Redux.Colors.SetEquipment[3].Color.R, $Redux.Colors.SetEquipment[3].Color.G, $Redux.Colors.SetEquipment[3].Color.B) } # Silver Gauntlets
        if (IsDefaultColor -Elem $Redux.Colors.SetEquipment[4] -Not)   { ChangeBytes -Offset "B6DA47" -Values @($Redux.Colors.SetEquipment[4].Color.R, $Redux.Colors.SetEquipment[4].Color.G, $Redux.Colors.SetEquipment[4].Color.B) } # Golden Gauntlets
        if ( (IsDefaultColor -Elem $Redux.Colors.SetEquipment[5] -Not) -and $AdultModel.mirror_shield -ne 0) { # Mirror Shield Frame
            $offset = "F86000"
            do {
                $offset = SearchBytes -Start $offset -End "FBD800" -Values "FA 00 00 00 D7 00 00"
                if ($offset -ge 0) {
                    $Offset = ( Get24Bit ( (GetDecimal $offset) + (GetDecimal "4") ) )
                    if (!(ChangeBytes -Offset $offset -Values @($Redux.Colors.SetEquipment[5].Color.R, $Redux.Colors.SetEquipment[5].Color.G, $Redux.Colors.SetEquipment[5].Color.B))) { break }
                }
            } while ($Offset -ge 0)
        }
    }

    

    # MAGIC SPIN ATTACK COLORS #

    if (IsSet $Redux.Colors.SetSpinAttack) {
        if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[0] -Not)   { ChangeBytes -Offset "F15AB4" -Values @($Redux.Colors.SetSpinAttack[0].Color.R, $Redux.Colors.SetSpinAttack[0].Color.G, $Redux.Colors.SetSpinAttack[0].Color.B) } # Blue Spin Attack
        if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[1] -Not)   { ChangeBytes -Offset "F15BD4" -Values @($Redux.Colors.SetSpinAttack[1].Color.R, $Redux.Colors.SetSpinAttack[1].Color.G, $Redux.Colors.SetSpinAttack[1].Color.B) } # Blue Spin Attack
        if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[2] -Not)   { ChangeBytes -Offset "F16034" -Values @($Redux.Colors.SetSpinAttack[2].Color.R, $Redux.Colors.SetSpinAttack[2].Color.G, $Redux.Colors.SetSpinAttack[2].Color.B) } # Red Spin Attack
        if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[3] -Not)   { ChangeBytes -Offset "F16154" -Values @($Redux.Colors.SetSpinAttack[3].Color.R, $Redux.Colors.SetSpinAttack[3].Color.G, $Redux.Colors.SetSpinAttack[3].Color.B) } # Red Spin Attack
    }



    # SWORD TRAIL COLORS #

    if (IsSet $Redux.Colors.SetSwordTrail) {
        if (IsDefaultColor -Elem $Redux.Colors.SetSwordTrail[0] -Not)       { ChangeBytes -Offset "BEFF7C" -Values @($Redux.Colors.SetSwordTrail[0].Color.R, $Redux.Colors.SetSwordTrail[0].Color.G, $Redux.Colors.SetSwordTrail[0].Color.B) }
        if (IsDefaultColor -Elem $Redux.Colors.SetSwordTrail[1] -Not)       { ChangeBytes -Offset "BEFF84" -Values @($Redux.Colors.SetSwordTrail[1].Color.R, $Redux.Colors.SetSwordTrail[1].Color.G, $Redux.Colors.SetSwordTrail[1].Color.B) }
        if (IsIndex -Elem $Redux.Colors.SwordTrailDuration -Not -Index 2)   { ChangeBytes -Offset "BEFF8C" -Values (($Redux.Colors.SwordTrailDuration.SelectedIndex) * 5) }
    }
    


    # FAIRY COLORS #

    if (IsChecked -Elem $Redux.Colors.BetaNavi) { ChangeBytes -Offset "A96110" -Values "34 0F 00 60" }
    elseif (IsSet $Redux.Colors.SetFairy) {
        if ( (IsDefaultColor -Elem $Redux.Colors.SetFairy[0] -Not) -or (IsDefaultColor -Elem $Redux.Colors.SetFairy[1] -Not) ) { # Idle
            ChangeBytes -Offset "B5E184"  -Values @($Redux.Colors.SetFairy[0].Color.R, $Redux.Colors.SetFairy[0].Color.G, $Redux.Colors.SetFairy[0].Color.B, 255, $Redux.Colors.SetFairy[1].Color.R, $Redux.Colors.SetFairy[1].Color.G, $Redux.Colors.SetFairy[1].Color.B, 0)
        }
        if ( (IsDefaultColor -Elem $Redux.Colors.SetFairy[2] -Not) -or (IsDefaultColor -Elem $Redux.Colors.SetFairy[3] -Not) ) { # Interact
            ChangeBytes -Offset "B5E174" -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E17C" -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E18C" -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E1A4" -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E1AC" -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E1B4" -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E1C4" -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E1CC" -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E1D4" -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
        }
        if ( (IsDefaultColor -Elem $Redux.Colors.SetFairy[4] -Not) -or (IsDefaultColor -Elem $Redux.Colors.SetFairy[5] -Not) ) { # NPC
            ChangeBytes -Offset "B5E194" -Values @($Redux.Colors.SetFairy[4].Color.R, $Redux.Colors.SetFairy[4].Color.G, $Redux.Colors.SetFairy[4].Color.B, 255, $Redux.Colors.SetFairy[5].Color.R, $Redux.Colors.SetFairy[5].Color.G, $Redux.Colors.SetFairy[5].Color.B, 0)
        }
        if ( (IsDefaultColor -Elem $Redux.Colors.SetFairy[6] -Not) -or (IsDefaultColor -Elem $Redux.Colors.SetFairy[7] -Not) ) { # Enemy, Boss
            ChangeBytes -Offset "B5E19C" -Values @($Redux.Colors.SetFairy[6].Color.R, $Redux.Colors.SetFairy[6].Color.G, $Redux.Colors.SetFairy[6].Color.B, 255, $Redux.Colors.SetFairy[7].Color.R, $Redux.Colors.SetFairy[7].Color.G, $Redux.Colors.SetFairy[7].Color.B, 0)
            ChangeBytes -Offset "B5E1BC" -Values @($Redux.Colors.SetFairy[6].Color.R, $Redux.Colors.SetFairy[6].Color.G, $Redux.Colors.SetFairy[6].Color.B, 255, $Redux.Colors.SetFairy[7].Color.R, $Redux.Colors.SetFairy[7].Color.G, $Redux.Colors.SetFairy[7].Color.B, 0)
        }
    }



    # RUPEE ICON COLORS #

    if ($Patches.Redux.Checked -and (IsChecked $Redux.Hooks.RupeeIconColors) ) {
        $Symbols = SetJSONFile ($GameFiles.base + "\symbols.json")
        if (IsDefaultColor -Elem $Redux.Colors.SetRupee[0] -Not)   { ChangeBytes -Offset (AddToOffset -Hex $Symbols.rupee_colors -Add 0) -Values @($Redux.Colors.SetRupee[0].Color.R, $Redux.Colors.SetRupee[0].Color.G, $Redux.Colors.SetRupee[0].Color.B) } # Base wallet 
        if (IsDefaultColor -Elem $Redux.Colors.SetRupee[1] -Not)   { ChangeBytes -Offset (AddToOffset -Hex $Symbols.rupee_colors -Add 3) -Values @($Redux.Colors.SetRupee[1].Color.R, $Redux.Colors.SetRupee[1].Color.G, $Redux.Colors.SetRupee[1].Color.B) } # Adult's Wallet
        if (IsDefaultColor -Elem $Redux.Colors.SetRupee[2] -Not)   { ChangeBytes -Offset (AddToOffset -Hex $Symbols.rupee_colors -Add 6) -Values @($Redux.Colors.SetRupee[2].Color.R, $Redux.Colors.SetRupee[2].Color.G, $Redux.Colors.SetRupee[2].Color.B) } # Giant's Wallet
        if (IsDefaultColor -Elem $Redux.Colors.SetRupee[3] -Not)   { ChangeBytes -Offset (AddToOffset -Hex $Symbols.rupee_colors -Add 9) -Values @($Redux.Colors.SetRupee[3].Color.R, $Redux.Colors.SetRupee[3].Color.G, $Redux.Colors.SetRupee[3].Color.B) } # Tycoon's Wallet
        $Symbols = $null
    }
    elseif ($Redux.Colors.RupeeVanilla.Active -and (IsDefaultColor -Elem $Redux.Colors.SetRupeeVanilla -Not) ) {
        ChangeBytes -Offset "AEB766" -Values @($Redux.Colors.SetRupeeVanilla.Color.R, $Redux.Colors.SetRupeeVanilla.Color.G)
        ChangeBytes -Offset "AEB77A" -Values $Redux.Colors.SetRupeeVanilla.Color.B
    }



    # MISC COLORS #

   <# if (IsChecked $Redux.Colors.BoomerangTrail) {
        ChangeBytes -Offset "C5A8FB" -Values "BB BB BB BB BB"          -Interval 4
        ChangeBytes -Offset "C5A923" -Values "BB BB BB BB BB BB BB BB" -Interval 4
    } #>

    if (IsChecked $Redux.Colors.PauseScreenColors) {
        ChangeBytes -Offset "BBF88E" -Values "97 8B" # Menu Title Background
        ChangeBytes -Offset "BBF892" -Values "61" # Menu Title Background
        ChangeBytes -Offset "BBF97E" -Values "97 8B" # Z
        ChangeBytes -Offset "BBF982" -Values "61 FF" # R
        ChangeBytes -Offset "BBFC7E" -Values "FF FF" # Unavailable Menu Title
        ChangeBytes -Offset "BBFC82" -Values "FF" # Unavailable Menu Title
        ChangeBytes -Offset "BC793D" -Values "97" # Z/R Highlight
        ChangeBytes -Offset "BC793F" -Values "8B" # Z/R Highlight
        ChangeBytes -Offset "BC7941" -Values "61" # Z/R Highlight
        ChangeBytes -Offset "BC7945" -Values "97" # Z/R Highlight
        ChangeBytes -Offset "BC7947" -Values "8B" # Z/R Highlight
        ChangeBytes -Offset "BC7949" -Values "61" # Z/R Highlight
        ChangeBytes -Offset "BC7994" -Values "B4 B4 B4 B4 78 B4 B4 B4 B4 B4 B4 B4 78 B4 B4 B4 B4 B4 B4 B4 B4 B4 B4 B4 B4 B4 B4 B4 78 B4 B4 B4 B4 B4 B4 B4 78 B4 B4 B4 B4 B4 B4 B4 B4 B4 B4 B4 78 78 78 78 46 78 78 78 78 78 78 78 46 78 78 78 78 78 78 78 78 78 78 78" # Background
    }



    # STARTING EQUIPMENT #

    if (IsChecked $Redux.Save.KokiriSword)     { ChangeBytes -Offset "B71EF8" -Values "00 01" -Add }
    if (IsChecked $Redux.Save.MasterSword)     { ChangeBytes -Offset "B71EF8" -Values "00 02" -Add }
    if (IsChecked $Redux.Save.GiantsKnife)     { ChangeBytes -Offset "B71EF8" -Values "00 04" -Add }
    if (IsChecked $Redux.Save.BiggoronSword)   { ChangeBytes -Offset "B71EF8" -Values "00 04" -Add; ChangeBytes -Offset "B71E9A" -Values "01" }
    if (IsChecked $Redux.Save.DekuShield)      { ChangeBytes -Offset "B71EF8" -Values "00 10" -Add }
    if (IsChecked $Redux.Save.HylianShield)    { ChangeBytes -Offset "B71EF8" -Values "00 20" -Add }
    if (IsChecked $Redux.Save.MirrorShield)    { ChangeBytes -Offset "B71EF8" -Values "00 40" -Add }
    if (IsChecked $Redux.Save.GoronTunic)      { ChangeBytes -Offset "B71EF8" -Values "02 00" -Add }
    if (IsChecked $Redux.Save.ZoraTunic)       { ChangeBytes -Offset "B71EF8" -Values "04 00" -Add }
    if (IsChecked $Redux.Save.IronBoots)       { ChangeBytes -Offset "B71EF8" -Values "20 00" -Add }
    if (IsChecked $Redux.Save.HoverBoots)      { ChangeBytes -Offset "B71EF8" -Values "40 00" -Add }



    # STARTING ITEMS #

    if (IsChecked $Redux.Save.DekuStick)                { ChangeBytes -Offset "B71ED0" -Values "00" }
    if (IsChecked $Redux.Save.DekuNut)                  { ChangeBytes -Offset "B71ED1" -Values "01" }
    if (IsChecked $Redux.Save.Bomb)                     { ChangeBytes -Offset "B71ED2" -Values "02" }
    if (IsChecked $Redux.Save.FairyBow)                 { ChangeBytes -Offset "B71ED3" -Values "03" }
    if (IsChecked $Redux.Save.FireArrow)                { ChangeBytes -Offset "B71ED4" -Values "04" }
    if (IsChecked $Redux.Save.DinsFire)                 { ChangeBytes -Offset "B71ED5" -Values "05" }
    if (IsChecked $Redux.Save.FairySlingshot)           { ChangeBytes -Offset "B71ED6" -Values "06" }
    if (IsChecked $Redux.Save.FairyOcarina)             { ChangeBytes -Offset "B71ED7" -Values "07" }
    if (IsChecked $Redux.Save.OcarinaOfTime)            { ChangeBytes -Offset "B71ED7" -Values "08" }
    if (IsChecked $Redux.Save.Bombchu)                  { ChangeBytes -Offset "B71ED8" -Values "09"; ChangeBytes -Offset "B71EF0" -Values "32" }
    if (IsChecked $Redux.Save.Hookshot)                 { ChangeBytes -Offset "B71ED9" -Values "0A" }
    if (IsChecked $Redux.Save.LongShot)                 { ChangeBytes -Offset "B71ED9" -Values "0B" }
    if (IsChecked $Redux.Save.IceArrow)                 { ChangeBytes -Offset "B71EDA" -Values "0C" }
    if (IsChecked $Redux.Save.FaroresWind)              { ChangeBytes -Offset "B71EDB" -Values "0D" }
    if (IsChecked $Redux.Save.Boomerang)                { ChangeBytes -Offset "B71EDC" -Values "0E" }
    if (IsChecked $Redux.Save.LensOfTruth)              { ChangeBytes -Offset "B71EDD" -Values "0F" }
    if (IsChecked $Redux.Save.MagicBean)                { ChangeBytes -Offset "B71EDE" -Values "10"; ChangeBytes -Offset "B71EF6" -Values "0F" }
    if (IsChecked $Redux.Save.MegatonHammer)            { ChangeBytes -Offset "B71EDF" -Values "11" }
    if (IsChecked $Redux.Save.LightArrow)               { ChangeBytes -Offset "B71EE0" -Values "12" }
    if (IsChecked $Redux.Save.NayrusLove)               { ChangeBytes -Offset "B71EE1" -Values "13" }
    if (IsChecked $Redux.Save.Bottle1)                  { ChangeBytes -Offset "B71EE2" -Values "14" }
    if (IsChecked $Redux.Save.Bottle2)                  { ChangeBytes -Offset "B71EE3" -Values "14" }
    if (IsChecked $Redux.Save.Bottle3)                  { ChangeBytes -Offset "B71EE4" -Values "14" }
    if (IsChecked $Redux.Save.Bottle4)                  { ChangeBytes -Offset "B71EE5" -Values "14" }

    if (IsIndex   $Redux.Save.TradeSequenceItem -Not)   { $value = Get8Bit ($Redux.Save.TradeSequenceItem.SelectedIndex + 44); ChangeBytes -Offset "B71EE6" -Values $value }
    if (IsIndex   $Redux.Save.Mask              -Not)   { $value = Get8Bit ($Redux.Save.Mask.SelectedIndex + 32);              ChangeBytes -Offset "B71EE7" -Values $value }



    # STARTING SONGS #

    if (IsChecked $Redux.Save.ZeldasLullaby)      { ChangeBytes -Offset "B71F00" -Values "00 00 10 00" -Add }
    if (IsChecked $Redux.Save.EponasSong)         { ChangeBytes -Offset "B71F00" -Values "00 00 20 00" -Add }
    if (IsChecked $Redux.Save.SariasSong)         { ChangeBytes -Offset "B71F00" -Values "00 00 40 00" -Add }
    if (IsChecked $Redux.Save.SunsSong)           { ChangeBytes -Offset "B71F00" -Values "00 00 80 00" -Add }
    if (IsChecked $Redux.Save.SongOfTime)         { ChangeBytes -Offset "B71F00" -Values "00 01 00 00" -Add }
    if (IsChecked $Redux.Save.SongOfStorms)       { ChangeBytes -Offset "B71F00" -Values "00 02 00 00" -Add }
    if (IsChecked $Redux.Save.MinuetOfForest)     { ChangeBytes -Offset "B71F00" -Values "00 00 00 40" -Add }
    if (IsChecked $Redux.Save.BoleroOfFire)       { ChangeBytes -Offset "B71F00" -Values "00 00 00 80" -Add }
    if (IsChecked $Redux.Save.SerenadeOfWater)    { ChangeBytes -Offset "B71F00" -Values "00 00 01 00" -Add }
    if (IsChecked $Redux.Save.RequiemOfSpirit)    { ChangeBytes -Offset "B71F00" -Values "00 00 02 00" -Add }
    if (IsChecked $Redux.Save.NocturneOfShadow)   { ChangeBytes -Offset "B71F00" -Values "00 00 04 00" -Add }
    if (IsChecked $Redux.Save.PreludeOfLight)     { ChangeBytes -Offset "B71F00" -Values "00 00 08 00" -Add }



    # STARTING UPGRADES #

    if (IsChecked $Redux.Save.DekuStick)        { $value = Get8Bit (($Redux.Save.DekuSticks.SelectedIndex + 1) * 2);  ChangeBytes -Offset "B71EFD" -Values @($value, "00", "00") -Add; ChangeBytes -Offset "B71EE8" -Values $Redux.Capacity["DekuSticks" + ($Redux.Save.DekuSticks.SelectedIndex + 1)].Default }
    if (IsChecked $Redux.Save.DekuNut)          { $value = Get8Bit (($Redux.Save.DekuNuts.SelectedIndex   + 1) * 16); ChangeBytes -Offset "B71EFD" -Values @($value, "00", "00") -Add; ChangeBytes -Offset "B71EE9" -Values $Redux.Capacity["DekuNuts"   + ($Redux.Save.DekuNuts.SelectedIndex   + 1)].Default }
    if (IsChecked $Redux.Save.FairySlingShot)   { $value = Get8Bit (($Redux.Save.BulletBag.SelectedIndex  + 1) * 64); ChangeBytes -Offset "B71EFD" -Values @("00", $value, "00") -Add; ChangeBytes -Offset "B71EEE" -Values $Redux.Capacity["BulletBag"  + ($Redux.Save.BulletBag.SelectedIndex  + 1)].Default }
    if (IsChecked $Redux.Save.FairyBow)         { $value = Get8Bit (($Redux.Save.Quiver.SelectedIndex     + 1) * 1);  ChangeBytes -Offset "B71EFD" -Values @("00", "00", $value) -Add; ChangeBytes -Offset "B71EEB" -Values $Redux.Capacity["Quiver"     + ($Redux.Save.Quiver.SelectedIndex     + 1)].Default }
    if (IsChecked $Redux.Save.Bomb)             { $value = Get8Bit (($Redux.Save.BombBag.SelectedIndex    + 1) * 8);  ChangeBytes -Offset "B71EFD" -Values @("00", "00", $value) -Add; ChangeBytes -Offset "B71EEA" -Values $Redux.Capacity["BombBag"    + ($Redux.Save.BombBag.SelectedIndex    + 1)].Default }
    if (IsIndex   $Redux.Save.Strength -Not)    { $value = Get8Bit ($Redux.Save.Strength.SelectedIndex         * 64); ChangeBytes -Offset "B71EFD" -Values @("00", "00", $value) -Add }
    if (IsIndex   $Redux.Save.Scale    -Not)    { $value = Get8Bit ($Redux.Save.Scale.SelectedIndex            * 2);  ChangeBytes -Offset "B71EFD" -Values @("00", $value, "00") -Add }
    if (IsIndex   $Redux.Save.Wallet   -Not)    { $value = Get8Bit ($Redux.Save.Wallet.SelectedIndex           * 16); ChangeBytes -Offset "B71EFD" -Values @("00", $value, "00") -Add }

    if (IsChecked $Redux.Capacity.EnableAmmo) {
        ChangeBytes -Offset "B71EE8" -Values (Get8Bit ($Redux.Capacity["DekuSticks" + ($Redux.Save.DekuSticks.SelectedIndex + 1)].Text) ) # Deku Sticks
        ChangeBytes -Offset "B71EE9" -Values (Get8Bit ($Redux.Capacity["DekuNuts"   + ($Redux.Save.DekuNuts.SelectedIndex   + 1)].Text) ) # Deku Nuts
        ChangeBytes -Offset "B71EEE" -Values (Get8Bit ($Redux.Capacity["BulletBag"  + ($Redux.Save.BulletBag.SelectedIndex  + 1)].Text) ) # Bullet Seeds
        ChangeBytes -Offset "B71EEB" -Values (Get8Bit ($Redux.Capacity["Quiver"     + ($Redux.Save.Quiver.SelectedIndex     + 1)].Text) ) # Arrows
        ChangeBytes -Offset "B71EEA" -Values (Get8Bit ($Redux.Capacity["BombBag"    + ($Redux.Save.BombBag.SelectedIndex    + 1)].Text) ) # Bombs
    }

    if (IsDefault $Redux.Save.Hearts   -Not)   {
        $value = Get16Bit ([int]$Redux.Save.Hearts.Text * 16); ChangeBytes -Offset "B71E8A" -Values $value; ChangeBytes -Offset "B71E8C" -Values $value;  ChangeBytes -Offset "B0635E" -Values $value; ChangeBytes -Offset "B06366" -Values $value
        if ([int]$Redux.Save.Hearts.Text -lt 3) { ChangeBytes -Offset "BC6286" -Values $value }
    }

    if (IsChecked $Redux.Save.DoubleDefense)   { ChangeBytes -Offset "B71E99" -Values "01"; ChangeBytes -Offset "B71F2B" -Values $Redux.Save.Hearts.Text }
    if (IsChecked $Redux.Save.Magic)           { ChangeBytes -Offset "B71E96" -Values "01"                                                               }
    if (IsChecked $Redux.Save.DoubleMagic)     { ChangeBytes -Offset "B71E98" -Values "01"; ChangeBytes -Offset "B71E8F" -Values "60"                    }



    # STARTING QUEST #

    if (IsChecked $Redux.Save.KokiriEmerald)         { ChangeBytes -Offset "B71F00" -Values "00 04 00 00" -Add }
    if (IsChecked $Redux.Save.GoronRuby)             { ChangeBytes -Offset "B71F00" -Values "00 08 00 00" -Add }
    if (IsChecked $Redux.Save.ZoraSapphire)          { ChangeBytes -Offset "B71F00" -Values "00 10 00 00" -Add }
    if (IsChecked $Redux.Save.ForestMedallion)       { ChangeBytes -Offset "B71F00" -Values "00 00 00 01" -Add }
    if (IsChecked $Redux.Save.FireMedallion)         { ChangeBytes -Offset "B71F00" -Values "00 00 00 02" -Add }
    if (IsChecked $Redux.Save.WaterMedallion)        { ChangeBytes -Offset "B71F00" -Values "00 00 00 04" -Add }
    if (IsChecked $Redux.Save.ShadowMedallion)       { ChangeBytes -Offset "B71F00" -Values "00 00 00 08" -Add }
    if (IsChecked $Redux.Save.SpiritMedallion)       { ChangeBytes -Offset "B71F00" -Values "00 00 00 10" -Add }
    if (IsChecked $Redux.Save.LightMedallion)        { ChangeBytes -Offset "B71F00" -Values "00 00 00 20" -Add }
    if (IsChecked $Redux.Save.GerudoCard)            { ChangeBytes -Offset "B71F00" -Values "00 40 00 00" -Add }
    if (IsChecked $Redux.Save.StoneOfAgony)          { ChangeBytes -Offset "B71F00" -Values "00 20 00 00" -Add }
    if (IsDefault $Redux.Save.GoldSkulltulas -Not)   { ChangeBytes -Offset "B71F2C" -Values (Get8Bit $Redux.Save.GoldSkulltulas.Text) }



    # STARTING DEBUG #

    if (IsChecked $Redux.Save.NoDungeonItems)   { ChangeBytes -Offset "B71FC0" -Values "00 00 00 00 00 00 00 00 00 00" }
    if (IsChecked $Redux.Save.NoDungeonKeys)    { ChangeBytes -Offset "B71FD4" -Values "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00" }
    if (IsChecked $Redux.Save.NoQuestStatus)    { ChangeBytes -Offset "B71FBC" -Values "00 00 00 00" }
    if (IsChecked $Redux.Save.NoItems)          { ChangeBytes -Offset "B71F8C" -Values "FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF" }
    if (IsChecked $Redux.Save.NoEquipment)      { ChangeBytes -Offset "B71FB4" -Values "11 00" }
    if (IsChecked $Redud.Save.NoUpgrades)       { ChangeBytes -Offset "B71FB9" -Values "00 00 00" }



    # AMMO CAPACITY #

    if (IsChecked $Redux.Capacity.EnableAmmo) {
        ChangeBytes -Offset "B6EC2F" -Values @( (Get8Bit $Redux.Capacity.Quiver1.Text),     (Get8Bit $Redux.Capacity.Quiver2.Text),     (Get8Bit $Redux.Capacity.Quiver3.Text)     ) -Interval 2
        ChangeBytes -Offset "B6EC37" -Values @( (Get8Bit $Redux.Capacity.BombBag1.Text),    (Get8Bit $Redux.Capacity.BombBag2.Text),    (Get8Bit $Redux.Capacity.BombBag3.Text)    ) -Interval 2
        ChangeBytes -Offset "B6EC57" -Values @( (Get8Bit $Redux.Capacity.BulletBag1.Text),  (Get8Bit $Redux.Capacity.BulletBag2.Text),  (Get8Bit $Redux.Capacity.BulletBag3.Text)  ) -Interval 2
        ChangeBytes -Offset "B6EC5F" -Values @( (Get8Bit $Redux.Capacity.DekuSticks1.Text), (Get8Bit $Redux.Capacity.DekuSticks2.Text), (Get8Bit $Redux.Capacity.DekuSticks3.Text) ) -Interval 2
        ChangeBytes -Offset "B6EC67" -Values @( (Get8Bit $Redux.Capacity.DekuNuts1.Text),   (Get8Bit $Redux.Capacity.DekuNuts2.Text),   (Get8Bit $Redux.Capacity.DekuNuts3.Text)   ) -Interval 2

        # Initial Ammo
      # ChangeBytes -Offset ""       -Values (Get8Bit $Redux.Capacity.Quiver1.Text)
      # ChangeBytes -Offset ""       -Values (Get8Bit $Redux.Capacity.BombBag1.Text)
        ChangeBytes -Offset "AE6D03" -Values (Get8Bit $Redux.Capacity.BulletBag1.Text)
      # ChangeBytes -Offset ""       -Values (Get8Bit $Redux.Capacity.DekuSticks1.Text)
      # ChangeBytes -Offset ""       -Values (Get8Bit $Redux.Capacity.DekuNuts1.Text)
    }



    # WALLET CAPACITY #
    
    if (IsChecked $Redux.Capacity.EnableWallet) {
        $Wallet1 = Get16Bit $Redux.Capacity.Wallet1.Text; $Wallet2 = Get16Bit $Redux.Capacity.Wallet2.Text; $Wallet3 = Get16Bit $Redux.Capacity.Wallet3.Text; $Wallet4 = Get16Bit $Redux.Capacity.Wallet4.Text
        ChangeBytes -Offset "B6EC4C" -Values @($Wallet1.Substring(0, 2), $Wallet1.Substring(2) )
        ChangeBytes -Offset "B6EC4E" -Values @($Wallet2.Substring(0, 2), $Wallet2.Substring(2) )
        ChangeBytes -Offset "B6EC50" -Values @($Wallet3.Substring(0, 2), $Wallet3.Substring(2) )
        ChangeBytes -Offset "B6EC52" -Values @($Wallet4.Substring(0, 2), $Wallet4.Substring(2) )

        if ($Redux.Capacity.Wallet1.Text.Length -gt 3 -or $Redux.Capacity.Wallet2.Text.Length -gt 3 -or $Redux.Capacity.Wallet3.Text.Length -gt 3 -or $Redux.Capacity.Wallet4.Text.Length -gt 3) {
            $Max = 4
            ChangeBytes -Offset "AEBB60" -Values "FE E0 02 30 24 0B 00 00 00 00 00 00 86 AE 00 34 A6 EE 02 36 86 E2 02 36 28 41 03 E8 14 01 00 05 25 6B 00 01 24 42 FC 18 A6 E4 02 36 10 00 FF FA A6 EB 02 30"
            ChangeBytes -Offset "AEBC23" -Values "30"
        }
        else { $Max = 3 }
        ChangeBytes -Offset "B6D571" -Values @( ($Max - $Redux.Capacity.Wallet1.Text.Length), ($Max - $Redux.Capacity.Wallet2.Text.Length), ($Max - $Redux.Capacity.Wallet3.Text.Length), ($Max - $Redux.Capacity.Wallet4.Text.Length) ) -Interval 2
        ChangeBytes -Offset "B6D579" -Values @($Redux.Capacity.Wallet1.Text.Length, $Redux.Capacity.Wallet2.Text.Length, $Redux.Capacity.Wallet3.Text.Length, $Redux.Capacity.Wallet4.Text.Length)                                       -Interval 2

        if ($Redux.Capacity.Wallet4.Text -lt $Redux.Capacity.Wallet3.Text)   { ChangeBytes -Offset "E5088A" -Values @($Wallet3.Substring(0, 2), $Wallet3.Substring(2) ) }
        else                                                                 { ChangeBytes -Offset "E5088A" -Values @($Wallet4.Substring(0, 2), $Wallet4.Substring(2) ) }
    }



    # ITEM DROPS QUANTITY #

    if (IsChecked $Redux.Capacity.EnableDrops) {
        ChangeBytes -Offset "B6D4D1" -Values @($Redux.Capacity.Arrows1x.Text,  $Redux.Capacity.Arrows2x.Text, $Redux.Capacity.Arrows3x.Text)                              -Interval 2
        ChangeBytes -Offset "AE6D43" -Values $Redux.Capacity.BulletSeeds.Text
        ChangeBytes -Offset "AE6DCF" -Values $Redux.Capacity.BulletSeedsShop.Text
        ChangeBytes -Offset "AE675B" -Values $Redux.Capacity.DekuSticks.Text
        ChangeBytes -Offset "B6D4C9" -Values ($Redux.Capacity.Bombs1x.Text,    $Redux.Capacity.Bombs2x.Text,  $Redux.Capacity.Bombs3x.Text, $Redux.Capacity.Bombs4x.Text) -Interval 2
        ChangeBytes -Offset "B6D4D9" -Values ($Redux.Capacity.DekuNuts1x.Text, $Redux.Capacity.DekuNuts2x.Text)                                                           -Interval 2
        $RupeeG = Get16Bit $Redux.Capacity.RupeeG.Text; $RupeeB = Get16Bit $Redux.Capacity.RupeeB.Text; $RupeeR = Get16Bit $Redux.Capacity.RupeeR.Text; $RupeeP = Get16Bit $Redux.Capacity.RupeeP.Text; $RupeeO = Get16Bit $Redux.Capacity.RupeeO.Text
        ChangeBytes -Offset "B6D4DC" -Values ($RupeeG + $RupeeB + $RupeeR + $RupeeP + $RupeeO)
    }



    # EQUIPMENT #

    if (IsChecked $Redux.Equipment.HerosBow) {
        PatchBytes -Offset "7C0000" -Texture -Patch "Equipment\Bow\heros_bow.icon"
        PatchBytes -Offset "7F5000" -Texture -Patch "Equipment\Bow\heros_bow_fire.icon"
        PatchBytes -Offset "7F6000" -Texture -Patch "Equipment\Bow\heros_bow_ice.icon"
        PatchBytes -Offset "7F7000" -Texture -Patch "Equipment\Bow\heros_bow_light.icon"
        if (TestFile ($GameFiles.textures + "\Equipment\Bow\heros_bow." + $LanguagePatch.code + ".label")) { PatchBytes -Offset "89F800" -Texture -Patch ("Equipment\Bow\heros_bow." + $LanguagePatch.code + ".label") }
    }

    if (IsChecked $Redux.Equipment.FireProofDekuShield)   { ChangeBytes -Offset "BD3C5B" -Values "00" }
    if (IsChecked $Redux.Equipment.UnsheathSword)         { ChangeBytes -Offset "BD04A0" -Values "28 42 00 05 14 40 00 05 00 00 10 25" }
    if (IsChecked $Redux.Equipment.Hookshot)              { PatchBytes  -Offset "7C7000" -Texture -Patch "Equipment\Hookshot\termina_hookshot.icon" }
    if (IsChecked $Redux.Equipment.GoronBracelet)         { ChangeBytes -Offset "BB66DD" -Values "C0"; ChangeBytes -Offset "BC780C" -Values "09"    }



    
    # SWORDS AND SHIELDS #

    if (TestFile ($GameFiles.textures + "\Equipment\Kokiri Sword\" + $Redux.Equipment.KokiriSword.text + ".icon"))                                  { PatchBytes -Offset "7F8000" -Texture -Patch ("Equipment\Kokiri Sword\" + $Redux.Equipment.KokiriSword.text + ".icon") }
    if (TestFile ($GameFiles.textures + "\Equipment\Kokiri Sword\" + $Redux.Equipment.KokiriSword.text + "." + $LanguagePatch.code + ".label"))     { PatchBytes -Offset "8AD800" -Texture -Patch ("Equipment\Kokiri Sword\" + $Redux.Equipment.KokiriSword.text + "." + $LanguagePatch.code + ".label") }

    if (TestFile ($GameFiles.textures + "\Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text + ".icon"))                                  { PatchBytes -Offset "7F9000" -Texture -Patch ("Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text + ".icon") }
    if (TestFile ($GameFiles.textures + "\Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text + "." + $LanguagePatch.code + ".label"))     { PatchBytes -Offset "8ADC00" -Texture -Patch ("Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text + "." + $LanguagePatch.code + ".label") }

    if ($ChildModel.deku_shield -ne 0) {
        if (TestFile ($GameFiles.textures + "\Equipment\Deku Shield\" + $Redux.Equipment.DekuShield.text + ".front") ) {
            $Offset = SearchBytes -Start "FBE000" -End "FEAF80" -Values "CC 99 E5 E5 DD A3 EE 2B DD A5 E6 29 DD A5 D4 DB"
            if ($Offset -gt 0)                                                                                                                      { PatchBytes -Offset $Offset  -Texture -Patch ("Equipment\Deku Shield\"   + $Redux.Equipment.DekuShield.text + ".front") }
        }
        if (TestFile ($GameFiles.textures + "\Equipment\Deku Shield\" + $Redux.Equipment.DekuShield.text + ".back") ) {
            $Offset = SearchBytes -Start "FBE000" -End "FEAF80" -Values "DC 11 F5 17 F5 19 DC 57 D4 59 E4 DB E4 DB DC 97"
            if ($Offset -gt 0)                                                                                                                      { PatchBytes -Offset $Offset  -Texture -Patch ("Equipment\Deku Shield\"   + $Redux.Equipment.DekuShield.text + ".back") }
        }
    }
    if (TestFile ($GameFiles.textures + "\Equipment\Deku Shield\" + $Redux.Equipment.DekuShield.text + ".icon"))                                    { PatchBytes -Offset "7FB000" -Texture -Patch ("Equipment\Deku Shield\"   + $Redux.Equipment.DekuShield.text + ".icon") }
    if (TestFile ($GameFiles.textures + "\Equipment\Deku Shield\" + $Redux.Equipment.DekuShield.text + "." + $LanguagePatch.code + ".label"))       { PatchBytes -Offset "8AE400" -Texture -Patch ("Equipment\Deku Shield\"   + $Redux.Equipment.DekuShield.text + "." + $LanguagePatch.code + ".label") }

    if ($ChildModel.hylian_shield -ne 0 -and $AdultModel.hylian_shield -ne 0 -and (TestFile ($GameFiles.textures + "\Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".bin"))) {
        PatchBytes -Offset "F03400" -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".bin")
        $Offset = SearchBytes -Start "FBE000" -End "FEAF80" -Values "BE 35 BE 77 C6 B9 CE FB D6 FD D7 3D DF 3F DF 7F"
        if ($Offset -gt 0)                                                                                                                          { PatchBytes -Offset $Offset  -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".bin") }
    }
    if (TestFile ($GameFiles.textures + "\Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".icon"))                                { PatchBytes -Offset "7FC000" -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".icon") }
    if (TestFile ($GameFiles.textures + "\Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + "." + $LanguagePatch.code + ".label"))   { PatchBytes -Offset "8AE800" -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + "." + $LanguagePatch.code + ".label") }

    if ($AdultModel.mirror_shield -ne 0 -and (TestFile ($GameFiles.textures + "\Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".bin"))) {
        $Offset = SearchBytes -Start "F86000" -End "FBD800" -Values "90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90"
        PatchBytes -Offset $Offset -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".bin")
        if (TestFile ($GameFiles.textures + "\Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".chest"))                           { PatchBytes -Offset "1616000" -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".chest") }
        if (TestFile ($GameFiles.textures + "\Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".reflection"))                      { PatchBytes -Offset "1456388" -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".reflection") }
    }
    if (TestFile ($GameFiles.textures + "\Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".icon"))                                { PatchBytes -Offset "7FD000"  -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".icon") }
    if (TestFile ($GameFiles.textures + "\Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + "." + $LanguagePatch.code + ".label"))   { PatchBytes -Offset "8AEC00"  -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + "." + $LanguagePatch.code + ".label") }

    if     (IsChecked $Redux.Graphics.ListAdultMaleModels)            { $file = "Adult Male\"   + $Redux.Graphics.AdultMaleModels.Text.replace(" (default)", "")   }
    elseif (IsChecked $Redux.Graphics.ListAdultFeMaleModels)          { $file = "Adult Female\" + $Redux.Graphics.AdultFemaleModels.Text.replace(" (default)", "") }
    if     (TestFile ($GameFiles.models + "\" + $file + ".master"))   { PatchBytes -Offset "7F9000" -Models -Patch ($file + ".master") }
    if     (TestFile ($GameFiles.models + "\" + $file + ".hylian"))   { PatchBytes -Offset "7FC000" -Models -Patch ($file + ".hylian") }
    if     (TestFile ($GameFiles.models + "\" + $file + ".mirror"))   { PatchBytes -Offset "7FD000" -Models -Patch ($file + ".mirror") }

    

    # HITBOX #

    if (IsValue -Elem $Redux.Hitbox.KokiriSword       -Not)   { ChangeBytes -Offset "B6DB18" -Values (ConvertFloatToHex $Redux.Hitbox.KokiriSword.Value)       }
    if (IsValue -Elem $Redux.Hitbox.MasterSword       -Not)   { ChangeBytes -Offset "B6DB14" -Values (ConvertFloatToHex $Redux.Hitbox.MasterSword.Value)       }
    if (IsValue -Elem $Redux.Hitbox.GiantsKnife       -Not)   { ChangeBytes -Offset "B6DB1C" -Values (ConvertFloatToHex $Redux.Hitbox.GiantsKnife.Value)       }
    if (IsValue -Elem $Redux.Hitbox.BrokenGiantsKnife -Not)   { ChangeBytes -Offset "B7E8CC" -Values (ConvertFloatToHex $Redux.Hitbox.BrokenGiantsKnife.Value) }
    if (IsValue -Elem $Redux.Hitbox.MegatonHammer     -Not)   { ChangeBytes -Offset "B6DB24" -Values (ConvertFloatToHex $Redux.Hitbox.MegatonHammer.Value)     }
    if (IsValue -Elem $Redux.Hitbox.ShieldRecoil      -Not)   { ChangeBytes -Offset "BD4162" -Values (Get16Bit ($Redux.Hitbox.ShieldRecoil.Value + 45000))     }
    if (IsValue -Elem $Redux.Hitbox.Hookshot          -Not)   { ChangeBytes -Offset "CAD3C7" -Values (Get8Bit $Redux.Hitbox.Hookshot.Value)                    }
    if (IsValue -Elem $Redux.Hitbox.Longshot          -Not)   { ChangeBytes -Offset "CAD3B7" -Values (Get8Bit $Redux.Hitbox.Longshot.Value)                    }



    # UNLOCK CHILD RESTRICTIONS #

    if ( (IsIndex -Elem $Redux.Unlock.MegatonHammer -Index 2) -or (IsIndex -Elem $Redux.Unlock.MegatonHammer -Index 4) ) { ChangeBytes -Offset "BC77A3" -Values "09 09" -Interval 42 }

    if (IsChecked $Redux.Unlock.Tunics)          { ChangeBytes -Offset "BC77B6" -Values "09 09"; ChangeBytes -Offset "BC77FE" -Values "09 09" }
    if (IsChecked $Redux.Unlock.MasterSword)     { ChangeBytes -Offset "BC77AE" -Values "09 09" -Interval 74 }
    if (IsChecked $Redux.Unlock.GiantsKnife)     { ChangeBytes -Offset "BC77AF" -Values "09 09" -Interval 74 ; ChangeBytes -Offset "BC7811" -Values "09" }
    if (IsChecked $Redux.Unlock.MirrorShield)    { ChangeBytes -Offset "BC77B3" -Values "09 09" -Interval 73 } # ChangeBytes -Offset "BC77B2" -Values "00 00" -Interval 73 # Lock Hylian Shield
    if (IsChecked $Redux.Unlock.Boots)           { ChangeBytes -Offset "BC77BA" -Values "09 09"; ChangeBytes -Offset "BC7801" -Values "09 09" }
    if (IsChecked $Redux.Unlock.Gauntlets)       { ChangeBytes -Offset "AEFA6C" -Values "24 08 00 00" }
    
    

    
    # UNLOCK ADULT RESTRICTIONS #
    
    if (IsChecked $Redux.Unlock.KokiriSword)      { ChangeBytes -Offset "BC77AD" -Values "09 09" -Interval 74 }
    if (IsChecked $Redux.Unlock.DekuShield)       { ChangeBytes -Offset "BC77B1" -Values "09 09" -Interval 73 }
    if (IsChecked $Redux.Unlock.FairySlingshot)   { ChangeBytes -Offset "BC779A" -Values "09 09" -Interval 40 }
    if (IsChecked $Redux.Unlock.Boomerang)        { ChangeBytes -Offset "BC77A0" -Values "09 09" -Interval 42 }
    if (IsChecked $Redux.Unlock.DekuSticks)       { ChangeBytes -Offset "BC7794" -Values "09 09" -Interval 40 }
    if (IsChecked $Redux.Unlock.CrawlHole)        { ChangeBytes -Offset "BDAB13" -Values "00"                 }



    # CUTSCENES #

    if (IsChecked $Redux.Skip.RegularSongs) {
        # Zelda's Lullaby
        ChangeBytes -Offset "2E8E90C" -Values "00 00 03 E8 00 00 00 01 00 73 00 3B 00 3C 00 3C"
        ChangeBytes -Offset "2E8E91C" -Values "00 00 00 13 00 00 00 0C 00 17 00 00 00 10 00 02 08 8B FF FF 00 D4 00 11 00 20 00 00 FF FF FF FF"

        # Sun's Song
        ChangeBytes -Offset "332A4A4" -Values "00 00 00 3C"
        ChangeBytes -Offset "332A868" -Values "00 00 00 13 00 00 00 08 00 18 00 00 00 10 00 02 08 8B FF FF 00 D3 00 11 00 20 00 00 FF FF FF FF"

        # Saria's Song
        ChangeBytes -Offset "20B1734" -Values "00 00 00 3C"
        ChangeBytes -Offset "20B1DA8" -Values "00 00 00 13 00 00 00 0C 00 15 00 00 00 10 00 02 08 8B FF FF 00 D1 00 11 00 20 00 00 FF FF FF FF"
        ChangeBytes -Offset "20B19C0" -Values "00 00 00 0A 00 00 00 06"; ChangeBytes -Offset "20B19C8" -Values "00 11 00 00 00 10 00 00"
        ChangeBytes -Offset "20B19F8" -Values "00 3E 00 11 00 20 00 00 80 00 00 00 00 00 00 00 00 00 01 D4 FF FF F7 31 00 00 00 00 00 00 01 D4 FF FF F7 12"

        # Epona's Song
        ChangeBytes -Offset "29BEF60" -Values "00 00 03 E8 00 00 00 01 00 5E 00 0A 00 0B 00 0B"
        ChangeBytes -Offset "29BECB0" -Values "00 00 00 13 00 00 00 02 00 D2 00 00 00 09 00 00 FF FF FF FF FF FF 00 0A 00 3C FF FF FF FF FF FF"

        # Song of Time
        ChangeBytes -Offset "252FB98" -Values "00 00 03 E8 00 00 00 01 00 35 00 3B 00 3C 00 3C"
        ChangeBytes -Offset "252FC80" -Values "00 00 00 13 00 00 00 0C 00 19 00 00 00 10 00 02 08 8B FF FF 00 D5 00 11 00 20 00 00 FF FF FF FF"
        ChangeBytes -Offset "1FC3B84" -Values "FF FF FF FF"

        # Song of Storms
        ChangeBytes -Offset "3041084" -Values "00 00 00 0A"
        ChangeBytes -Offset "3041088" -Values "00 00 00 13 00 00 00 02 00 D6 00 00 00 09 00 00 FF FF FF FF FF FF 00 BE 00 C8 FF FF FF FF FF FF"
    }

    if (IsChecked $Redux.Skip.WarpSongs) {
        # Minuet of Forest
        ChangeBytes -Offset "20AFF84" -Values "00 00 00 3C"
        ChangeBytes -Offset "20B0800" -Values "00 00 00 13 00 00 00 0A 00 0F 00 00 00 10 00 02 08 8B FF FF 00 73 00 11 00 20 00 00 FF FF FF FF"
        ChangeBytes -Offset "20AFF88" -Values "00 00 00 0A 00 00 00 05"; ChangeBytes -Offset "20AFF90" -Values "00 11 00 00 00 10 00 00"; ChangeBytes -Offset "20AFFC1" -Values "00 3E 00 11 00 20 00 00"

        # Bolero of Fire
        ChangeBytes -Offset "224B5D4" -Values "00 00 00 3C"
        ChangeBytes -Offset "224D7E8" -Values "00 00 00 13 00 00 00 0A 00 10 00 00 00 10 00 02 08 8B FF FF 00 74 00 11 00 20 00 00 FF FF FF FF"
        ChangeBytes -Offset "224B5D8" -Values "00 00 00 0A 00 00 00 0B"; ChangeBytes -Offset "224B5E0" -Values "00 11 00 00 00 10 00 00"
        ChangeBytes -Offset "224B610" -Values "00 3E 00 11 00 20 00 00"; ChangeBytes -Offset "224B7F0" -Values "00 00 00 2F 00 00 00 0E"
        ChangeBytes -Offset "224B7F8" -Values "00 00";                   ChangeBytes -Offset "224B828" -Values "00 00"
        ChangeBytes -Offset "224B858" -Values "00 00";                   ChangeBytes -Offset "224B888" -Values "00 00"

        # Serenade of Water
        ChangeBytes -Offset "2BEB254" -Values "00 00 00 3C"
        ChangeBytes -Offset "2BEC880" -Values "00 00 00 13 00 00 00 10 00 11 00 00 00 10 00 02 08 8B FF FF 00 75 00 11 00 20 00 00 FF FF FF FF"
        ChangeBytes -Offset "2BEB258" -Values "00 00 00 0A 00 00 00 0F"; ChangeBytes -Offset "2BEB260" -Values "00 11 00 00 00 10 00 00"
        ChangeBytes -Offset "2BEB290" -Values "00 3E 00 11 00 20 00 00"; ChangeBytes -Offset "2BEB530" -Values "00 00 00 2F 00 00 00 06"
        ChangeBytes -Offset "2BEB538" -Values "00 00 00 00 01 8A 00 00 1B BB 00 00 FF FF FB 10 80 00 01 1A 00 00 03 30 FF FF FB 10 80 00 01 1A 00 00 03 30"
        ChangeBytes -Offset "2BEC848" -Values "00 00 00 56 00 00 00 01 00 59 00 21 00 22 00 00"

        # Nocturne of Shadow
        ChangeBytes -Offset "1FFE458" -Values "00 00 03 E8 00 00 00 01 00 2F 00 01 00 02 00 02"
        ChangeBytes -Offset "1FFFDF4" -Values "00 00 00 3C"
        ChangeBytes -Offset "2000FD8" -Values "00 00 00 13 00 00 00 0E 00 13 00 00 00 10 00 02 08 8B FF FF 00 77 00 11 00 20 00 00 FF FF FF FF"
        ChangeBytes -Offset "2000128" -Values "00 00 03 E8 00 00 00 01 00 32 00 3A 00 3B 00 3B"

        # Requiem of Spirit
        ChangeBytes -Offset "218AF14" -Values "02 18 AF 14"
        ChangeBytes -Offset "218C574" -Values "00 00 00 13 00 00 00 08 00 12 00 00 00 10 00 02 08 8B FF FF 00 76 00 11 00 20 00 00 FF FF FF FF"
        ChangeBytes -Offset "218B478" -Values "00 00 03 E8 00 00 00 01 00 30 00 3A 00 3B 00 3B"
        ChangeBytes -Offset "218AF18" -Values "00 00 00 0A 00 00 00 0B"
        ChangeBytes -Offset "218AF20" -Values "00 11 00 00 00 10 00 00 40 00 00 00 FF FF FA F9 00 00 00 08 00 00 00 01 FF FF FA F9 00 00 00 08 00 00 00 01 0F 67 14 08 00 00 00 00 00 00 00 01"
        ChangeBytes -Offset "218AF50" -Values "00 3E 00 11 00 20 00 00"

        # Prelude of Light
        ChangeBytes -Offset "252FD24" -Values "00 00 00 4A"
        ChangeBytes -Offset "2531320" -Values "00 00 00 13 00 00 00 0E 00 14 00 00 00 10 00 02 08 8B FF FF 00 78 00 11 00 20 00 00 FF FF FF FF"
        ChangeBytes -Offset "252FF10" -Values "00 00 00 2F 00 00 00 09"; ChangeBytes -Offset "252FF18" -Values "00 06 00 00 00 00 00 00"
        ChangeBytes -Offset "25313D0" -Values "00 00 00 56 00 00 00 01 00 3B 00 21 00 22 00 00"
    }

    if (IsChecked $Redux.Skip.DungeonOutro) {
        ChangeBytes -Offset "2077E20" -Values "00 07 00 01 00 02 00 02"; ChangeBytes -Offset "2078A10" -Values "00 0E 00 1F 00 20 00 20"; ChangeBytes -Offset "2079570" -Values "00 80 00 00 00 1E 00 00 FF FF FF FF FF FF 00 1E 00 28 FF FF FF FF FF FF"                  # Inside the Deku Tree
        ChangeBytes -Offset "2221E88" -Values "00 0C 00 3B 00 3C 00 3C"; ChangeBytes -Offset "2223308" -Values "00 81 00 00 00 3A 00 00"                                                                                                                                   # Dodongo's Cavern
        ChangeBytes -Offset "CA3530"  -Values "00 00 00 00";             ChangeBytes -Offset "2113340" -Values "00 0D 00 3B 00 3C 00 3C"; ChangeBytes -Offset "2113C18" -Values "00 82 00 00 00 3A 00 00"; ChangeBytes -Offset "21131D0" -Values "00 01 00 00 00 3C 00 3C" # Inside Jabu-Jabu's Belly
        ChangeBytes -Offset "D4ED68"  -Values "00 45 00 3B 00 3C 00 3C"; ChangeBytes -Offset "D4ED78"  -Values "00 3E 00 00 00 3A 00 00"; ChangeBytes -Offset "207B9D4" -Values "FF FF FF FF"                                                                              # Forest Temple
        ChangeBytes -Offset "2001848" -Values "00 1E 00 01 00 02 00 02"; ChangeBytes -Offset "D100B4"  -Values "00 62 00 3B 00 3C 00 3C"; ChangeBytes -Offset "D10134"  -Values "00 3C 00 00 00 3A 00 00"                                                                  # Fire Temple
        ChangeBytes -Offset "D5A458"  -Values "00 15 00 3B 00 3C 00 3C"; ChangeBytes -Offset "D5A3A8"  -Values "00 3D 00 00 00 3A 00 00"; ChangeBytes -Offset "20D0D20" -Values "00 29 00 C7 00 C8 00 C8"                                                                  # Water Temple
        ChangeBytes -Offset "D13EC8"  -Values "00 61 00 3B 00 3C 00 3C"; ChangeBytes -Offset "D13E18"  -Values "00 41 00 00 00 3A 00 00"                                                                                                                                   # Shadow Temple
        ChangeBytes -Offset "D3A0A8"  -Values "00 60 00 3B 00 3C 00 3C"; ChangeBytes -Offset "D39FF0"  -Values "00 3F 00 00 00 3A 00 00"                                                                                                                                   # Spirit Temple
    }

    if (IsChecked $Redux.Skip.LightArrow) {
        ChangeBytes -Offset "2531B40" -Values "00 28 00 01 00 02 00 02"; ChangeBytes -Offset "2532FBC" -Values "00 75";          ChangeBytes -Offset "2532FEA" -Values "00 75 00 80"; ChangeBytes -Offset "2533115" -Values "05"; ChangeBytes -Offset "2533141" -Values "06 00 06 00 10"
        ChangeBytes -Offset "2533171" -Values "0F 00 11 00 40";          ChangeBytes -Offset "25331A1" -Values "07 00 41 00 65"; ChangeBytes -Offset "2533642" -Values "00 50";       ChangeBytes -Offset "253389D" -Values "74"; ChangeBytes -Offset "25338A4" -Values "00 72 00 75 00 79"
        ChangeBytes -Offset "25338BC" -Values "FF FF";                   ChangeBytes -Offset "25338C2" -Values "FF FF FF FF FF FF"
        ChangeBytes -Offset "25339C2" -Values "00 75 00 76";             ChangeBytes -Offset "2533830" -Values "00 31 00 81 00 82 00 82"
    }
    
    if (IsChecked $Redux.Skip.RoyalTomb) {
        ChangeBytes -Offset "2025026" -Values "00 01"; ChangeBytes -Offset "2025159" -Values "02"; ChangeBytes -Offset "2023C86" -Values "00 01"; ChangeBytes -Offset "2023E19" -Values "02"
    }
    
    if (IsChecked $Redux.Skip.DekuSeedBag) {
        ChangeBytes -Offset "ECA900" -Values "24 03 C0 00"; ChangeBytes -Offset "ECAE90" -Values "27 18 FD 04"; ChangeBytes -Offset "ECB618" -Values "25 6B 00 D4"
        ChangeBytes -Offset "ECAE70" -Values "00 00 00 00"; ChangeBytes -Offset "E5972C" -Values "24 08 00 01"
    }

    if (IsChecked $Redux.Speedup.KakarikoGate) {
        ChangeBytes -Offset "DD3686" -Values "40000000000000000000"; ChangeBytes -Offset "DD367E" -Values "4000"; ChangeBytes -Offset "DD366F" -Values "D0"
        ChangeBytes -Offset "DD375E" -Values "40000000000000000000"; ChangeBytes -Offset "DD3756" -Values "4000"; ChangeBytes -Offset "DD3747" -Values "D0"
    }

    if (IsChecked $Redux.Speedup.Bosses) {
        ChangeBytes -Offset "C944D8"  -Values "00 00 00 00";  ChangeBytes -Offset "C94548" -Values "00 00 00 00";  ChangeBytes -Offset "C94730" -Values "00 00 00 00";  ChangeBytes -Offset "C945A8" -Values "00 00 00 00"; ChangeBytes -Offset "C94594" -Values "00 00 00 00"                                     # Phantom Ganon
        ChangeBytes -Offset "2F5AF84" -Values "00 00 00 05";  ChangeBytes -Offset "2F5C7DA" -Values "00 01 00 02"; ChangeBytes -Offset "2F5C7A2" -Values "00 03 00 04"; ChangeBytes -Offset "2F5B369" -Values "09";         ChangeBytes -Offset "2F5B491" -Values "04"; ChangeBytes -Offset "2F5B559" -Values "04" # Nabooru
        ChangeBytes -Offset "2F5B621" -Values "04";           ChangeBytes -Offset "2F5B761" -Values "07";          ChangeBytes -Offset "2F5B840" -Values "00 05 00 01 00 05 00 05"                                                                                                                                 # Shorten white flash
        ChangeBytes -Offset "D67BA4"  -Values "10 00";        ChangeBytes -Offset "D678CC" -Values "24 01 03 A2 A6 01 01 42"                                                                                                                                                                                       # Twinrova
        ChangeBytes -Offset "D82047"  -Values "09"                                                                                                                                                            # Ganondorf
        ChangeBytes -Offset "D82AB3"  -Values "66";           ChangeBytes -Offset "D82FAF" -Values "65";           ChangeBytes -Offset "D82D2E" -Values "04 1F"; ChangeBytes -Offset "D83142" -Values "00 6B" # Zelda Descend
        ChangeBytes -Offset "D82DD8"  -Values "00 00 00 00";  ChangeBytes -Offset "D82ED4" -Values "00 00 00 00";  ChangeBytes -Offset "D82FDF" -Values "33"                                                  # Zelda Descend
        ChangeBytes -Offset "E82E0F"  -Values "04"                                                                                                                                                            # After Tower Collapse
        ChangeBytes -Offset "E83D28"  -Values "00 00 00 00";  ChangeBytes -Offset "E83B5C" -Values "00 00 00 00";  ChangeBytes -Offset "E84C80" -Values "10 00"                                               # Ganon Intro
    }

    if (IsChecked $Redux.Speedup.FairyOcarina) {
        ChangeBytes -Offset "2151230" -Values "00 72 00 3C 00 3D 00 3D"
        ChangeBytes -Offset "2151240" -Values "00 4A 00 00 00 3A 00 00 FF FF FF FF FF FF 00 3C 00 81 FF FF"
        ChangeBytes -Offset "2150E20" -Values "FF FF FA 4C"
    }

    if (IsChecked $Redux.Speedup.RainbowBridge) {
        ChangeBytes -Offset "292D644" -Values "00 00 00 A0"; ChangeBytes -Offset "292D680" -Values "00 02 00 0A 00 6C 00 00"; ChangeBytes -Offset "292D6E8" -Values "00 27"
        ChangeBytes -Offset "292D718" -Values "00 32";       ChangeBytes -Offset "292D810" -Values "00 02 00 3C";             ChangeBytes -Offset "292D924" -Values "FF FF 00 14 00 96 FF FF"
    }

    if (IsChecked $Redux.Speedup.GanonTrials) {
        ChangeBytes -Offset "31A8090" -Values "00 6B 00 01 00 02 00 02"; ChangeBytes -Offset "31A9E00" -Values "00 6E 00 01 00 02 00 02"; ChangeBytes -Offset "31A8B18" -Values "00 6C 00 01 00 02 00 02"
        ChangeBytes -Offset "31A9430" -Values "00 6D 00 01 00 02 00 02"; ChangeBytes -Offset "31AB200" -Values "00 70 00 01 00 02 00 02"; ChangeBytes -Offset "31AA830" -Values "00 6F 00 01 00 02 00 02"
    }

    

    if (IsChecked $Redux.Skip.OpeningCutscene)       { ChangeBytes -Offset "B06BBA"  -Values "0000"                                                                       }
    if (IsChecked $Redux.Skip.DaruniaDance)          { ChangeBytes -Offset "22769E4" -Values "FFFFFFFF"                                                                   }
    if (IsChecked $Redux.Skip.ZeldaEscape)           { ChangeBytes -Offset "1FC0CF8" -Values "000000010021000100020002"                                                   }
    if (IsChecked $Redux.Skip.JabuJabu)              { ChangeBytes -Offset "CA0784"  -Values "0018000100020002"                                                           }
    if (IsChecked $Redux.Skip.GanonTower)            { ChangeBytes -Offset "33FB328" -Values "0076000100020002"                                                           }
    if (IsChecked $Redux.Skip.Medallions)            { ChangeBytes -Offset "2512680" -Values "0076000100020002"                                                           }
    if (IsChecked $Redux.Skip.AllMedallions)         { ChangeBytes -Offset "ACA409"  -Values "AD";               ChangeBytes -Offset "ACA49D"  -Values "CE"               }
    if (IsChecked $Redux.Speedup.OpeningChests)      { ChangeBytes -Offset "BDA2E8"  -Values "240AFFFF"                                                                   }
    if (IsChecked $Redux.Speedup.KingZora)           { ChangeBytes -Offset "E56924"  -Values "00000000"                                                                   }
    if (IsChecked $Redux.Speedup.OwlFlights)         { ChangeBytes -Offset "20E60D2" -Values "0001";             ChangeBytes -Offset "223B6B2" -Values "0001"             }
    if (IsChecked $Redux.Speedup.EponaRace)          { ChangeBytes -Offset "29BE984" -Values "00000002";         ChangeBytes -Offset "29BE9CA" -Values "00010002"         }
    if (IsChecked $Redux.Speedup.EponaEscape)        { ChangeBytes -Offset "1FC8B36" -Values "002A"                                                                       }
    if (IsChecked $Redux.Speedup.HorsebackArchery)   { ChangeBytes -Offset "21B2064" -Values "00000002";         ChangeBytes -Offset "21B20AA" -Values "00010002"         }
    if (IsChecked $Redux.Speedup.DrainingTheWell)    { ChangeBytes -Offset "E0A010"  -Values "002A000100020002"; ChangeBytes -Offset "2001110" -Values "002B00B700B800B8" }
    if (IsChecked $Redux.Speedup.DoorOfTime)         { ChangeBytes -Offset "E0A176"  -Values "0002";             ChangeBytes -Offset "E0A35A"  -Values "00010002"         }



    # RESTORE CUTSCENES #

    if (IsChecked $Redux.Restore.OpeningCutscene)   { ChangeBytes -Offset "1FB8076" -Values "23 40" }



    # ANIMATIONS #

    if     (IsChecked $Redux.Animation.WeaponIdle)        { ChangeBytes -Offset "BEF5F2" -Values "34 28"                                                                                                           }
    if     (IsChecked $Redux.Animation.WeaponCrouch)      { ChangeBytes -Offset "BEF38A" -Values "2A 10"                                                                                                           }
    if     (IsChecked $Redux.Animation.WeaponAttack)      { ChangeBytes -Offset "BEFB62" -Values "2B D8";               ChangeBytes -Offset "BEFB66" -Values "2B E0"; ChangeBytes -Offset "BEFB6A" -Values "2B E0" }
    if     (IsChecked $Redux.Animation.HoldShieldOut)     { ChangeBytes -Offset "B6D6D7" -Values "02 0A 0A 10"                                                                                                     }
    if     (IsChecked $Redux.Animation.BombBag)           { ChangeBytes -Offset "BEF3DA" -Values "25 00";               ChangeBytes -Offset "BEF3F2" -Values "25 08"                                               }
    if     (IsChecked $Redux.Animation.BackflipAttack)    { ChangeBytes -Offset "BEFB12" -Values "29 D0"                                                                                                           }
    elseif (IsChecked $Redux.Animation.FrontflipAttack)   { ChangeBytes -Offset "BEFB12" -Values "2A 60"                                                                                                           }
    if     (IsChecked $Redux.Animation.FrontflipJump)     { PatchBytes  -Offset "70BB00" -Patch "Jumps\frontflip.bin"                                                                                              }
    elseif (IsChecked $Redux.Animation.SomarsaultJump)    { PatchBytes  -Offset "70BB00" -Patch "Jumps\somarsault.bin"; ChangeBytes -Offset "F06149" -Values "0E"                                                  }
    if     (IsChecked $Redux.Animation.SideBackflip)      { ChangeBytes -Offset "BEF5D6" -Values "29 88"                                                                                                           }


    # MASTER QUEST #

    if ($GamePatch.title -like "*Ocarina*") { $dungeons = PatchDungeonsOoTMQ }



    # CENSOR GERUDO TEXTURES #

    if (IsChecked $Redux.Restore.GerudoTextures) {
        PatchBytes -Offset "E68CE8"  -Texture -Patch "Gerudo Symbols\ganondorf_cape.bin"
        PatchBytes -Offset "15B1000" -Texture -Patch "Gerudo Symbols\gerudo_membership_card.bin"

        # Blocks / Switches
        PatchBytes -Offset "F70350"  -Texture -Patch "Gerudo Symbols\pushing_block.bin"
        PatchBytes -Offset "F70B50"  -Texture -Patch "Gerudo Symbols\silver_gauntlets_block.bin"
        PatchBytes -Offset "13B4000" -Texture -Patch "Gerudo Symbols\golden_gauntlets_pillar.bin"
        PatchBytes -Offset "F748A0"  -Texture -Patch "Gerudo Symbols\floor_switch.bin"
        PatchBytes -Offset "F7A8A0"  -Texture -Patch "Gerudo Symbols\rusted_floor_switch.bin"
        PatchBytes -Offset "F80CB0"  -Texture -Patch "Gerudo Symbols\crystal_switch.bin"

        # Dungeons / Areas
        PatchBytes -Offset "3045248" -Texture -Patch "Gerudo Symbols\dampe.bin"
        PatchBytes -Offset "21B8678" -Texture -Patch "Gerudo Symbols\gerudo_valley.bin"
        PatchBytes -Offset "F71350"  -Texture -Patch "Gerudo Symbols\forest_temple_room_11_block.bin"
        PatchBytes -Offset "2464D88" -Texture -Patch "Gerudo Symbols\forest_temple_room_11_hole.bin"
        PatchBytes -Offset "12985F0" -Texture -Patch "Gerudo Symbols\shadow_temple_room_0.bin"
        PatchBytes -Offset "2F64E38" -Texture -Patch "Gerudo Symbols\spirit_temple_boss.bin"
        PatchBytes -Offset "2F73700" -Texture -Patch "Gerudo Symbols\spirit_temple_boss.bin"
        PatchBytes -Offset "2B5CDA0" -Texture -Patch "Gerudo Symbols\spirit_temple_room_10.bin"
        PatchBytes -Offset "2B9BDB8" -Texture -Patch "Gerudo Symbols\spirit_temple_room_10.bin"
        PatchBytes -Offset "2BE7920" -Texture -Patch "Gerudo Symbols\spirit_temple_room_10.bin"
        PatchBytes -Offset "1636940" -Texture -Patch "Gerudo Symbols\spirit_temple_room_0_elevator.bin"
        $Offset = SearchBytes -Start "2AF8000" -End "2B08F40" -Values "00 05 00 11 06 00 06 4E 06 06 06 06 11 11 06 11"
        PatchBytes -Offset $Offset -Texture -Patch "Gerudo Symbols\spirit_temple_room_0_pillars.bin"
        PatchBytes -Offset "289CA90" -Texture -Patch "Gerudo Symbols\gerudo_training_ground_ceiling_frame.bin"
        PatchBytes -Offset "28BBCD8" -Texture -Patch "Gerudo Symbols\gerudo_training_ground_room_5.bin"
        PatchBytes -Offset "28CA728" -Texture -Patch "Gerudo Symbols\gerudo_training_ground_room_5.bin"
        PatchBytes -Offset "11FB000" -Texture -Patch "Gerudo Symbols\gerudo_training_ground_door.bin"
    }



    # SCRIPT #

    if (IsChecked $Redux.Text.KeatonMaskFix) {
        if (TestFile ($GameFiles.textures + "\Text Labels\keaton_mask." + $LanguagePatch.code + ".label"))   { PatchBytes -Offset "8A7C00" -Texture -Patch ("Text Labels\keaton_mask." + $LanguagePatch.code + ".label") }
    }

    if (IsChecked $Redux.Text.Fairy) {
        if (TestFile ($GameFiles.textures + "\Text Labels\fairy." + $LanguagePatch.code + ".label"))         { PatchBytes -Offset "8A4C00" -Texture -Patch ("Text Labels\fairy." + $LanguagePatch.code + ".label") }
    }

    if (IsChecked $Redux.Text.Milk) {
        if (TestFile ($GameFiles.textures + "\Text Labels\milk." + $LanguagePatch.code + ".label"))          { PatchBytes -Offset "8A5400" -Texture -Patch ("Text Labels\milk."      + $LanguagePatch.code + ".label") }
        if (TestFile ($GameFiles.textures + "\Text Labels\milk_half." + $LanguagePatch.code + ".label"))     { PatchBytes -Offset "8A6800" -Texture -Patch ("Text Labels\milk_half." + $LanguagePatch.code + ".label") }
    }

    if (IsDefault -Elem $Redux.Text.NaviPrompt -Not) {
        ChangeBytes -Offset "AE7CD8" -Values "00 00 00 00"
        PatchBytes  -Offset "8E3A80" -Texture -Patch ("Action Prompts\Navi\" + $Redux.Text.NaviPrompt.text + ".prompt")
    }

    if (IsChecked $Redux.Text.CheckPrompt)    { PatchBytes -Offset "8E2D00"  -Texture -Patch "Action Prompts\check.de.prompt" }
    if (IsChecked $Redux.Text.DivePrompt)     { PatchBytes -Offset "8E3600"  -Texture -Patch "Action Prompts\dive.de.prompt"  }
    if (IsDefault $Redux.Text.NaviCUp -Not)   { PatchBytes -Offset "1A3EFC0" -Texture -Patch ("Action Prompts\Navi\" + $Redux.Text.NaviCUp.text + ".cup") }

}



#==============================================================================================================================================================================================
function RevertReduxOptions() {
    
    $Symbols = SetJSONFile ($GameFiles.base + "\symbols.json")
    $payload = $Symbols.PAYLOAD_START + $Symbols.PAYLOAD_END + $Symbols.PAYLOAD_START

    if ($GamePatch.title -like "*Master of Time*") {
        ChangeBytes -Offset "CA80" -Values $payload
        ChangeBytes -Offset "D1B0" -Values "034710000347140003471000"
    }
    
    if (IsRevert $Redux.Hooks.ShowFileSelectIcons) {
        ChangeBytes -Offset "BA18C4" -Values "272CFFE7"; ChangeBytes -Offset "BA1980" -Values "2728FFE7"; ChangeBytes -Offset "BA19DC" -Values "A5404A6C"; ChangeBytes -Offset "BA1E20" -Values "258D";     ChangeBytes -Offset "BA1E22" -Values "0019"
        ChangeBytes -Offset "BA34DC" -Values "25F8FFE7"; ChangeBytes -Offset "BA3654" -Values "A5C04A6C"; ChangeBytes -Offset "BA39D0" -Values "258D0019"; ChangeBytes -Offset "BAC064" -Values "858F4A7E"; ChangeBytes -Offset "BAC1BC" -Values "858F4A7E"
        ChangeBytes -Offset "BAC3EC" -Values "85794A7E"; ChangeBytes -Offset "BAC94C" -Values "8739CA7E"; ChangeBytes -Offset "BAE5A4" -Values "A46D";     ChangeBytes -Offset "BAE5C8" -Values "A4604A6C"; ChangeBytes -Offset "BAE864" -Values "A46D4A6C"
        ChangeBytes -Offset "BB05FE" -Values "FFD0"    ; ChangeBytes -Offset "BB0600" -Values "FFD0FFC0"
        ChangeBytes -Offset "BAF738" -Values "3C198010330B00FFAC4B00048D4202C03C0B80103C01F600244C0008AD4C02C08F39E5008D6BE504AC400004272DFFFF31AE03FF256CFFFF319903FF000E7B8001E1C02500196880030D7025AC4E00008FBF001C8FB0001827BD008803E00008"
    }

    if (IsRevert $Redux.Hooks.GoldGauntletsSpeedUp) {
        ChangeBytes -Offset "BD5C58" -Values "0301C825AE19066C"; ChangeBytes -Offset "BE1BC8" -Values "AFA50034260501A4"; ChangeBytes -Offset "BE1C9A" -Values "4220"; ChangeBytes -Offset "CDF3EC" -Values "0C01ADBF"; ChangeBytes -Offset "CDF404" -Values "0C01ADBF"
        ChangeBytes -Offset "CDF420" -Values "0C01ADBF";         ChangeBytes -Offset "CDF638" -Values "E7A40034C606000C"; ChangeBytes -Offset "CDF792" -Values "03E7"
    }

    if (IsRevert $Redux.Speedup.DoorOfTime)           { ChangeBytes -Offset "CCE9A4" -Values "3C013F8044813000"                                                                                                                   }
    if (IsRevert $Redux.Hooks.BlueFireArrow)          { ChangeBytes -Offset "DB32C8" -Values "240100F0"                                                                                                                           }
    if (IsRevert $Redux.Hooks.RupeeIconColors)        { ChangeBytes -Offset "AEB764" -Values "3C01C8FF26380008AE9802B0"; ChangeBytes -Offset "AEB778" -Values "34216400"                                                          }
    if (IsRevert $Redux.Hooks.StoneOfAgony)           { ChangeBytes -Offset "BE4A14" -Values "4602003C";                 ChangeBytes -Offset "BE4A40" -Values "4606203C"; ChangeBytes -Offset "BE4A60" -Values "27BD002003E00008" }
    if (IsRevert $Redux.Hooks.EmptyBombFix)           { ChangeBytes -Offset "C0E77C" -Values "AC400428AC4D066C"                                                                                                                   }
    if (IsRevert $Redux.Hooks.WarpSongsSpeedup)       { ChangeBytes -Offset "B10CC0" -Values "3C0100013421241C";         ChangeBytes -Offset "BEA045"  -Values "009444E7A00010"                                                   }
    if (IsRevert $Redux.Hooks.BiggoronFix)            { ChangeBytes -Offset "ED645C" -Values "1000000DAC8E0180"                                                                                                                   }
    if (IsRevert $Redux.Hooks.DampeFix)               { ChangeBytes -Offset "CC4038" -Values "240C0004304A1000";         ChangeBytes -Offset "CC453E" -Values "0006"                                                              }
    if (IsRevert $Redux.Hooks.HyruleGuardsSoftlock)   { ChangeBytes -Offset "E24E7C" -Values "0C00863B24060001"                                                                                                                   }
    if (IsRevert $Redux.Hooks.TalonSkip)              { ChangeBytes -Offset "CC0038" -Values "8FA4001824090041"                                                                                                                   }
    if (IsRevert $Redux.Misc.SkipCutscenes)           { ChangeBytes -Offset "B06C2C" -Values "A2280020A2250021"                                                                                                                   }
    
    $Symbols = $payload = $null

}



#==============================================================================================================================================================================================
function ByteReduxOptions() {
    
    $Symbols = SetJSONFile ($GameFiles.base + "\symbols.json")
    

    # WIDESCREEN #

    if (IsChecked $Redux.Graphics.Widescreen) {
        $offset = SearchBytes -Start $Symbols.PAYLOAD_START -End (AddToOffset -Hex $Symbols.PAYLOAD_START -Add "1000") -Values "01 40"
        if ($offset -ge 0) {
            ChangeBytes -Offset $offset         -Values "01 A8"
            ChangeBytes -Offset $Symbols.CFG_WS -Values "01"
        }
    }



    # DPAD #

    if     (IsChecked $Redux.DPad.Disable)       { ChangeBytes -Offset $Symbols.CFG_DPAD_ENABLED -Values "00" }
    else {
        if (IsChecked $Redux.DPad.DualSet)       { ChangeBytes -Offset $Symbols.CFG_DPAD_ENABLED -Values "02" }
        else                                     { ChangeBytes -Offset $Symbols.CFG_DPAD_ENABLED -Values "01" }
        if (IsChecked $Redux.DPad.Hide)          { ChangeBytes -Offset $Symbols.CFG_DISPLAY_DPAD -Values "00" }
        if (IsChecked $Redux.DPad.LayoutRight)   { ChangeBytes -Offset $Symbols.CFG_DISPLAY_DPAD -Values "02" }

        if (IsSet $Redux.DPad.Left1 )   { ChangeBytes -Offset $Symbols.CFG_DPAD_CHILD_SET1_LEFT  -Values (Get8Bit $Redux.DPad.Left1.SelectedIndex)  }
        if (IsSet $Redux.DPad.Down1)    { ChangeBytes -Offset $Symbols.CFG_DPAD_CHILD_SET1_DOWN  -Values (Get8Bit $Redux.DPad.Down1.SelectedIndex)  }
        if (IsSet $Redux.DPad.Right1)   { ChangeBytes -Offset $Symbols.CFG_DPAD_CHILD_SET1_RIGHT -Values (Get8Bit $Redux.DPad.Right1.SelectedIndex) }
        if (IsSet $Redux.DPad.Up1)      { ChangeBytes -Offset $Symbols.CFG_DPAD_CHILD_SET1_UP    -Values (Get8Bit $Redux.DPad.Up1.SelectedIndex)    }

        if (IsSet $Redux.DPad.Left2)    { ChangeBytes -Offset $Symbols.CFG_DPAD_CHILD_SET2_LEFT  -Values (Get8Bit $Redux.DPad.Left2.SelectedIndex)  }
        if (IsSet $Redux.DPad.Down2)    { ChangeBytes -Offset $Symbols.CFG_DPAD_CHILD_SET2_DOWN  -Values (Get8Bit $Redux.DPad.Down2.SelectedIndex)  }
        if (IsSet $Redux.DPad.Right2)   { ChangeBytes -Offset $Symbols.CFG_DPAD_CHILD_SET2_RIGHT -Values (Get8Bit $Redux.DPad.Right2.SelectedIndex) }
        if (IsSet $Redux.DPad.Up2)      { ChangeBytes -Offset $Symbols.CFG_DPAD_CHILD_SET2_UP    -Values (Get8Bit $Redux.DPad.Up2.SelectedIndex)    }

        if (IsSet $Redux.DPad.Left3)    { ChangeBytes -Offset $Symbols.CFG_DPAD_ADULT_SET1_LEFT  -Values (Get8Bit $Redux.DPad.Left3.SelectedIndex)  }
        if (IsSet $Redux.DPad.Down3)    { ChangeBytes -Offset $Symbols.CFG_DPAD_ADULT_SET1_DOWN  -Values (Get8Bit $Redux.DPad.Down3.SelectedIndex)  }
        if (IsSet $Redux.DPad.Right3)   { ChangeBytes -Offset $Symbols.CFG_DPAD_ADULT_SET1_RIGHT -Values (Get8Bit $Redux.DPad.Right3.SelectedIndex) }
        if (IsSet $Redux.DPad.Up3)      { ChangeBytes -Offset $Symbols.CFG_DPAD_ADULT_SET1_UP    -Values (Get8Bit $Redux.DPad.Up3.SelectedIndex)    }

        if (IsSet $Redux.DPad.Left4)    { ChangeBytes -Offset $Symbols.CFG_DPAD_ADULT_SET2_LEFT  -Values (Get8Bit $Redux.DPad.Left4.SelectedIndex)  }
        if (IsSet $Redux.DPad.Down4)    { ChangeBytes -Offset $Symbols.CFG_DPAD_ADULT_SET2_DOWN  -Values (Get8Bit $Redux.DPad.Down4.SelectedIndex)  }
        if (IsSet $Redux.DPad.Right4)   { ChangeBytes -Offset $Symbols.CFG_DPAD_ADULT_SET2_RIGHT -Values (Get8Bit $Redux.DPad.Right4.SelectedIndex) }
        if (IsSet $Redux.DPad.Up4)      { ChangeBytes -Offset $Symbols.CFG_DPAD_ADULT_SET2_UP    -Values (Get8Bit $Redux.DPad.Up4.SelectedIndex)    }
    }



    # HUD LAYOUT #

    if (IsDefault $Redux.UI.Layout -Not) {
        ChangeBytes -Offset $Symbols.CFG_HUD_LAYOUT -Values (Get8Bit $Redux.UI.Layout.SelectedIndex)
        if ($Redux.UI.Layout.SelectedIndex -eq 2) { # Nintendo
            [uint16]$value = ($ByteArrayGame[(GetDecimal "BC7178")] * 256) + $ByteArrayGame[(GetDecimal "BC7179")]; $value += [math]::Round(14 * 12.5); ChangeBytes -Offset "BC7178" -Values (Get16Bit $value) # C-Left  (X-pos)
            [uint16]$value = ($ByteArrayGame[(GetDecimal "BC717A")] * 256) + $ByteArrayGame[(GetDecimal "BC717B")]; $value += [math]::Round(30 * 12.5); ChangeBytes -Offset "BC717A" -Values (Get16Bit $value) # C-Down  (X-pos)
            [uint16]$value = ($ByteArrayGame[(GetDecimal "BC7182")] * 256) + $ByteArrayGame[(GetDecimal "BC7183")]; $value += [math]::Round(20 * 12.5); ChangeBytes -Offset "BC7182" -Values (Get16Bit $value) # C-Down  (Y-pos)
            [uint16]$value = ($ByteArrayGame[(GetDecimal "BC717C")] * 256) + $ByteArrayGame[(GetDecimal "BC717D")]; $value -= [math]::Round(54 * 12.5); ChangeBytes -Offset "BC717C" -Values (Get16Bit $value) # C-Right (X-pos)
            [uint16]$value = ($ByteArrayGame[(GetDecimal "BC7184")] * 256) + $ByteArrayGame[(GetDecimal "BC7185")]; $value -= [math]::Round(20 * 12.5); ChangeBytes -Offset "BC7184" -Values (Get16Bit $value) # C-Right (Y-pos)
            $value = $null
        }
        elseif ($Redux.UI.Layout.SelectedIndex -eq 3) { # Modern
            [uint16]$value = ($ByteArrayGame[(GetDecimal "BC7178")] * 256) + $ByteArrayGame[(GetDecimal "BC7179")]; $value -= [math]::Round(10 * 12.5); ChangeBytes -Offset "BC7178" -Values (Get16Bit $value) # C-Left  (X-pos)
            [uint16]$value = ($ByteArrayGame[(GetDecimal "BC7180")] * 256) + $ByteArrayGame[(GetDecimal "BC7181")]; $value -= [math]::Round(20 * 12.5); ChangeBytes -Offset "BC7180" -Values (Get16Bit $value) # C-Left  (Y-pos)
            [uint16]$value = ($ByteArrayGame[(GetDecimal "BC717A")] * 256) + $ByteArrayGame[(GetDecimal "BC717B")]; $value += [math]::Round(30 * 12.5); ChangeBytes -Offset "BC717A" -Values (Get16Bit $value) # C-Down  (X-pos)
            [uint16]$value = ($ByteArrayGame[(GetDecimal "BC7182")] * 256) + $ByteArrayGame[(GetDecimal "BC7183")]; $value += [math]::Round(20 * 12.5); ChangeBytes -Offset "BC7182" -Values (Get16Bit $value) # C-Down  (Y-pos)
            [uint16]$value = ($ByteArrayGame[(GetDecimal "BC717C")] * 256) + $ByteArrayGame[(GetDecimal "BC717D")]; $value -= [math]::Round(30 * 12.5); ChangeBytes -Offset "BC717C" -Values (Get16Bit $value) # C-Right (X-pos)
            $value = $null
        }
        elseif ($Redux.UI.Layout.SelectedIndex -eq 4) { # GameCube (Original)
            [uint16]$value = ($ByteArrayGame[(GetDecimal "BC7178")] * 256) + $ByteArrayGame[(GetDecimal "BC7179")]; $value += [math]::Round(24 * 12.5); ChangeBytes -Offset "BC7178" -Values (Get16Bit $value) # C-Left  (X-pos)
            [uint16]$value = ($ByteArrayGame[(GetDecimal "BC7180")] * 256) + $ByteArrayGame[(GetDecimal "BC7181")]; $value += [math]::Round(10 * 12.5); ChangeBytes -Offset "BC7180" -Values (Get16Bit $value) # C-Left  (Y-pos)
            [uint16]$value = ($ByteArrayGame[(GetDecimal "BC717A")] * 256) + $ByteArrayGame[(GetDecimal "BC717B")]; $value += [math]::Round(30 * 12.5); ChangeBytes -Offset "BC717A" -Values (Get16Bit $value) # C-Down  (X-pos)
            [uint16]$value = ($ByteArrayGame[(GetDecimal "BC7182")] * 256) + $ByteArrayGame[(GetDecimal "BC7183")]; $value += [math]::Round(20 * 12.5); ChangeBytes -Offset "BC7182" -Values (Get16Bit $value) # C-Down  (Y-pos)
            [uint16]$value = ($ByteArrayGame[(GetDecimal "BC717C")] * 256) + $ByteArrayGame[(GetDecimal "BC717D")]; $value += [math]::Round(11 * 12.5); ChangeBytes -Offset "BC717C" -Values (Get16Bit $value) # C-Right (X-pos)
            [uint16]$value = ($ByteArrayGame[(GetDecimal "BC7184")] * 256) + $ByteArrayGame[(GetDecimal "BC7185")]; $value -= [math]::Round(25 * 12.5); ChangeBytes -Offset "BC7184" -Values (Get16Bit $value) # C-Right (Y-pos)
            $value = $null
        }
        elseif ($Redux.UI.Layout.SelectedIndex -eq 5) { # GameCube (Modern)
            [uint16]$value = ($ByteArrayGame[(GetDecimal "BC7178")] * 256) + $ByteArrayGame[(GetDecimal "BC7179")]; $value += [math]::Round(55 * 12.5); ChangeBytes -Offset "BC7178" -Values (Get16Bit $value) # C-Left  (X-pos)
            [uint16]$value = ($ByteArrayGame[(GetDecimal "BC7180")] * 256) + $ByteArrayGame[(GetDecimal "BC7181")]; $value -= [math]::Round(25 * 12.5); ChangeBytes -Offset "BC7180" -Values (Get16Bit $value) # C-Left  (Y-pos)
            [uint16]$value = ($ByteArrayGame[(GetDecimal "BC717A")] * 256) + $ByteArrayGame[(GetDecimal "BC717B")]; $value += [math]::Round(30 * 12.5); ChangeBytes -Offset "BC717A" -Values (Get16Bit $value) # C-Down  (X-pos)
            [uint16]$value = ($ByteArrayGame[(GetDecimal "BC7182")] * 256) + $ByteArrayGame[(GetDecimal "BC7183")]; $value += [math]::Round(20 * 12.5); ChangeBytes -Offset "BC7182" -Values (Get16Bit $value) # C-Down  (Y-pos)
            [uint16]$value = ($ByteArrayGame[(GetDecimal "BC717C")] * 256) + $ByteArrayGame[(GetDecimal "BC717D")]; $value -= [math]::Round(20 * 12.5); ChangeBytes -Offset "BC717C" -Values (Get16Bit $value) # C-Right (X-pos)
            [uint16]$value = ($ByteArrayGame[(GetDecimal "BC7184")] * 256) + $ByteArrayGame[(GetDecimal "BC7185")]; $value += [math]::Round(10 * 12.5); ChangeBytes -Offset "BC7184" -Values (Get16Bit $value) # C-Right (Y-pos)
            $value = $null
        }
    }
    


    # MISC #
    
    if (IsDefault $Redux.Misc.SkipCutscenes -Not) {
        ChangeBytes -Offset "1FE30CE" -Values "014B"; ChangeBytes -Offset "1FE30DE" -Values "014B"; ChangeBytes -Offset "1FE30EE" -Values "014B"; ChangeBytes -Offset "205909E" -Values "003F"; ChangeBytes -Offset "2059094" -Values "80"; ChangeBytes -Offset "DD3538" -Values "34190000"
        $values = "0165000109B600080A2400800A4200400ACE00010ACF00800AE800800B3F00200ED400100ED500200ED600180EDA00080EDC00800EDD00200EE000800EE700300EED00A10EF900010F0A00040F0F00400F2100060EE200010EE300FF0EE800010EE900FB0EEA00070EEB00FF0F08000800A70020"
        if (IsIndex $Redux.Misc.SkipCutscenes -Index 3) {
            $values += "012C00080F1A0004"
        }
        ChangeBytes -Offset $Symbols.INITIAL_SAVE_DATA -Values $values
        $values = $null
    }

    if (IsChecked $Redux.Misc.FastBunnyHood)        { ChangeBytes -Offset $Symbols.FAST_BUNNY_HOOD_ENABLED -Values "01" }
    if (IsChecked $Redux.Misc.ItemsSwap)            { ChangeBytes -Offset $Symbols.CFG_KEEP_MASK           -Values "01" }
    if (IsChecked $Redux.Misc.BombchuDrops)         { ChangeBytes -Offset $Symbols.BOMBCHUS_IN_LOGIC       -Values "01" }
    if (IsChecked $Redux.Misc.FPS)                  { ChangeBytes -Offset $Symbols.CFG_FPS_ENABLED         -Values "01" }
    


    # CODE HOOKS FEATURES #
    
    if (IsChecked $Redux.Hooks.BlueFireArrow)    { ChangeBytes -Offset "C230C1" -Values "29"; ChangeBytes -Offset "DB38FE" -Values "EF"; ChangeBytes -Offset "C9F036" -Values "10"; ChangeBytes -Offset "DB391B" -Values "50"; ChangeBytes -Offset "DB3927" -Values "5A" }
    


    # BUTTON ACTIVATIONS #

    if (IsChecked $Redux.Misc.HUDToggle)         { ChangeBytes -Offset $Symbols.CFG_HIDE_HUD_ENABLED         -Values "01" }
    if (IsChecked $Redux.Misc.InventoryEditor)   { ChangeBytes -Offset $Symbols.CFG_INVENTORY_EDITOR_ENABLED -Values "01" }
    if (IsChecked $Redux.Misc.GearUnequip)       { ChangeBytes -Offset $Symbols.CFG_UNEQUIP_GEAR_ENABLED     -Values "01" }
    if (IsChecked $Redux.Misc.ItemsUnequip)      { ChangeBytes -Offset $Symbols.CFG_UNEQUIP_ITEM_ENABLED     -Values "01" }
    if (IsChecked $Redux.Misc.ItemsOnB)          { ChangeBytes -Offset $Symbols.CFG_B_BUTTON_ITEM_ENABLED    -Values "01" }
    if (IsChecked $Redux.Misc.ItemsSwap)         { ChangeBytes -Offset $Symbols.CFG_SWAP_ITEM_ENABLED        -Values "01" }



    # AGE RESTRICTIONS #

    if (IsChecked $Redux.Unlock.KokiriSword)    { ChangeBytes -Offset $Symbols.CFG_ALLOW_KOKIRI_SWORD  -Values "01" }
    if (IsChecked $Redux.Unlock.MasterSword)    { ChangeBytes -Offset $Symbols.CFG_ALLOW_MASTER_SWORD  -Values "01" }
    if (IsChecked $Redux.Unlock.GiantsKnife)    { ChangeBytes -Offset $Symbols.CFG_ALLOW_GIANTS_KNIFE  -Values "01" }
    if (IsChecked $Redux.Unlock.DekuShield)     { ChangeBytes -Offset $Symbols.CFG_ALLOW_DEKU_SHIELD   -Values "01" }
    if (IsChecked $Redux.Unlock.MirrorShield)   { ChangeBytes -Offset $Symbols.CFG_ALLOW_MIRROR_SHIELD -Values "01" }
    if (IsChecked $Redux.Unlock.Boots)          { ChangeBytes -Offset $Symbols.CFG_ALLOW_BOOTS         -Values "01" }
    if (IsChecked $Redux.Unlock.Tunics)         { ChangeBytes -Offset $Symbols.CFG_ALLOW_TUNIC         -Values "01" }



    # RAINBOW COLORS #

    if (IsChecked $Redux.Rainbow.Sword)       { ChangeBytes -offset $Symbols.CFG_RAINBOW_SWORD_INNER_ENABLED         -Values "01 01"                   }
    if (IsChecked $Redux.Rainbow.Boomerang)   { ChangeBytes -offset $Symbols.CFG_RAINBOW_BOOM_TRAIL_INNER_ENABLED    -Values "01 01"                   }
    if (IsChecked $Redux.Rainbow.Bombchu)     { ChangeBytes -offset $Symbols.CFG_RAINBOW_BOMBCHU_TRAIL_INNER_ENABLED -Values "01 01"                   }
    if (IsChecked $Redux.Rainbow.Navi)        { ChangeBytes -offset $Symbols.CFG_RAINBOW_NAVI_IDLE_INNER_ENABLED     -Values "01 01 01 01 01 01 01 01" }



     # BUTTON COLORS #

     if (IsDefaultColor -Elem $Redux.Colors.SetButtons[0] -Not) { # A Button
        $values = (Get16Bit $Redux.Colors.SetButtons[0].Color.R) + (Get16Bit $Redux.Colors.SetButtons[0].Color.G) + (Get16Bit $Redux.Colors.SetButtons[0].Color.B); ChangeBytes -Offset $Symbols.CFG_A_BUTTON_COLOR -Values $values # A Button Color
        $values = (Get16Bit $Redux.Colors.SetButtons[0].Color.R) + (Get16Bit $Redux.Colors.SetButtons[0].Color.G) + (Get16Bit $Redux.Colors.SetButtons[0].Color.B); ChangeBytes -Offset $Symbols.CFG_A_NOTE_COLOR   -Values $values # Note Button
        $values = $null

        # A Button - Text Cursor
        ChangeBytes -Offset "B88E81"  -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) -Interval 4

        # A Button - Pause Menu Cursor
        ChangeBytes -Offset "BC7849"  -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) -Interval 2
        ChangeBytes -Offset "BC78A9"  -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) -Interval 2
        ChangeBytes -Offset "BC78BB"  -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) -Interval 2

        # A Button - Pause Menu Icon
        ChangeBytes -Offset "845754"  -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)

        # A Button - Save/Death Cursor
        ChangeBytes -Offset "BBEBC2"  -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G) # Red + Green
        ChangeBytes -Offset "BBEBD6"  -Values   $Redux.Colors.SetButtons[0].Color.B # Blue
        ChangeBytes -Offset "BBEDDA"  -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G) # Red + Green
        ChangeBytes -Offset "BBEDDE"  -Values   $Redux.Colors.SetButtons[0].Color.B # Blue

        # A Button - Note
        ChangeBytes -Offset "BB299A"  -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G) # Red + Green
        ChangeBytes -Offset "BB299E"  -Values   $Redux.Colors.SetButtons[0].Color.B # Blue
        ChangeBytes -Offset "BB2C8E"  -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G) # Red + Green
        ChangeBytes -Offset "BB2C92"  -Values   $Redux.Colors.SetButtons[0].Color.B # Blue
        ChangeBytes -Offset "BB2F8A"  -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G) # Red + Green
        ChangeBytes -Offset "BB2F96"  -Values   $Redux.Colors.SetButtons[0].Color.B # Blue
    }

    if (IsDefaultColor -Elem $Redux.Colors.SetButtons[1] -Not) {
        $values = (Get16Bit $Redux.Colors.SetButtons[1].Color.R) + (Get16Bit $Redux.Colors.SetButtons[1].Color.G) + (Get16Bit $Redux.Colors.SetButtons[1].Color.B); ChangeBytes -Offset $Symbols.CFG_B_BUTTON_COLOR -Values $values # B Button 
        $values = $null
    } 

    if (IsDefaultColor -Elem $Redux.Colors.SetButtons[2] -Not) { # C Buttons
        $values = (Get16Bit $Redux.Colors.SetButtons[2].Color.R) + (Get16Bit $Redux.Colors.SetButtons[2].Color.G) + (Get16Bit $Redux.Colors.SetButtons[2].Color.B); ChangeBytes -Offset $Symbols.CFG_C_BUTTON_COLOR -Values $values
        if ($Redux.Colors.Buttons.Text -eq "Randomized" -or $Redux.Colors.Buttons.Text -eq "Custom") {
            # C Buttons - Pause Menu Cursor
            ChangeBytes -Offset "BC7843" -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) -Interval 2
            ChangeBytes -Offset "BC7891" -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) -Interval 2
            ChangeBytes -Offset "BC78A3" -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) -Interval 2

            # C Buttons - Pause Menu Icon
            ChangeBytes -Offset "8456FC" -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B)

            # C Buttons - Note Color
            ChangeBytes -Offset "BB2996" -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G) # Red + Green
            ChangeBytes -Offset "BB29A2" -Values   $Redux.Colors.SetButtons[2].Color.B # Blue
            ChangeBytes -Offset "BB2C8A" -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G) # Red + Green
            ChangeBytes -Offset "BB2C96" -Values   $Redux.Colors.SetButtons[2].Color.B # Blue
            ChangeBytes -Offset "BB2F86" -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G) # Red + Green
            ChangeBytes -Offset "BB2F9A" -Values   $Redux.Colors.SetButtons[2].Color.B # Blue
            $values = (Get16Bit $Redux.Colors.SetButtons[2].Color.R) + (Get16Bit $Redux.Colors.SetButtons[2].Color.G) + (Get16Bit $Redux.Colors.SetButtons[2].Color.B); ChangeBytes -Offset $Symbols.CFG_C_NOTE_COLOR -Values $values
        }
        $values = $null
    }

    if (IsDefaultColor -Elem $Redux.Colors.SetButtons[3] -Not) { # Start Button
        ChangeBytes -Offset "AE9EC6" -Values @($Redux.Colors.SetButtons[3].Color.R, $Redux.Colors.SetButtons[3].Color.G) # Red + Green
        ChangeBytes -Offset "AE9ED8" -Values @(53, 238, $Redux.Colors.SetButtons[3].Color.B) # Blue
    }
    


    # TRAIL COLORS #

    if (IsSet $Redux.Colors.SetBoomerang) {
        if (IsDefaultColor -Elem $Redux.Colors.SetBoomerang[0] -Not)   { ChangeBytes -Offset $Symbols.CFG_BOOM_TRAIL_INNER_COLOR -Values @($Redux.Colors.SetBoomerang[0].Color.R, $Redux.Colors.SetBoomerang[0].Color.G, $Redux.Colors.SetBoomerang[0].Color.B) }
        if (IsDefaultColor -Elem $Redux.Colors.SetBoomerang[1] -Not)   { ChangeBytes -Offset $Symbols.CFG_BOOM_TRAIL_OUTER_COLOR -Values @($Redux.Colors.SetBoomerang[1].Color.R, $Redux.Colors.SetBoomerang[1].Color.G, $Redux.Colors.SetBoomerang[1].Color.B) }
    }

    if (IsSet $Redux.Colors.SetBombchu) {
        if (IsDefaultColor -Elem $Redux.Colors.SetBombchu[0] -Not)     { ChangeBytes -Offset $Symbols.CFG_BOMBCHU_TRAIL_INNER_COLOR -Values @($Redux.Colors.SetBombchu[0].Color.R, $Redux.Colors.SetBombchu[0].Color.G, $Redux.Colors.SetBombchu[0].Color.B) }
        if (IsDefaultColor -Elem $Redux.Colors.SetBombchu[1] -Not)     { ChangeBytes -Offset $Symbols.CFG_BOMBCHU_TRAIL_OUTER_COLOR -Values @($Redux.Colors.SetBombchu[1].Color.R, $Redux.Colors.SetBombchu[1].Color.G, $Redux.Colors.SetBombchu[1].Color.B) }
    }



    # HUD COLORS #

    if (IsSet $Redux.Colors.SetHUDStats) {
        if (IsDefaultColor -Elem $Redux.Colors.SetHUDStats[0] -Not)    { $values = (Get16Bit $Redux.Colors.SetHUDStats[0].Color.R) + (Get16Bit $Redux.Colors.SetHUDStats[0].Color.G) + (Get16Bit $Redux.Colors.SetHUDStats[0].Color.B); ChangeBytes -Offset $Symbols.CFG_HEART_COLOR -Values $values } # Hearts
        if (IsDefaultColor -Elem $Redux.Colors.SetHUDStats[1] -Not)    { $values = (Get16Bit $Redux.Colors.SetHUDStats[1].Color.R) + (Get16Bit $Redux.Colors.SetHUDStats[1].Color.G) + (Get16Bit $Redux.Colors.SetHUDStats[1].Color.B); ChangeBytes -Offset $Symbols.CFG_MAGIC_COLOR -Values $values } # Magic
        $values = $null
    }

    if (IsChecked $Redux.UI.GCScheme) {
        ChangeBytes -Offset $Symbols.CFG_TEXT_CURSOR_COLOR -Values "00 00 00 C8 00 50" # Text Cursor
        ChangeBytes -Offset $Symbols.CFG_SHOP_CURSOR_COLOR -Values "00 00 00 FF 00 50" # Shop Cursor
    }
    else {
        if (IsDefaultColor -Elem $Redux.Colors.SetText[0] -Not)    { $values = (Get16Bit $Redux.Colors.SetText[0].Color.R) + (Get16Bit $Redux.Colors.SetText[0].Color.G) + (Get16Bit $Redux.Colors.SetText[0].Color.B); ChangeBytes -Offset $Symbols.CFG_TEXT_CURSOR_COLOR -Values $values } # Text Cursor
        if (IsDefaultColor -Elem $Redux.Colors.SetText[1] -Not)    { $values = (Get16Bit $Redux.Colors.SetText[1].Color.R) + (Get16Bit $Redux.Colors.SetText[1].Color.G) + (Get16Bit $Redux.Colors.SetText[1].Color.B); ChangeBytes -Offset $Symbols.CFG_SHOP_CURSOR_COLOR -Values $values } # Shop Cursor
        $values = $null
    } 



    $Symbols = $null
    
}



#==============================================================================================================================================================================================
function CheckLanguageOptions() {
    
    if     ( (IsChecked  $Redux.Text.Vanilla -Not)   -or (IsChecked  $Redux.Text.Speed1x  -Not) -or (IsChecked  $Redux.UI.GCScheme)         -or (IsDefault  $Redux.Text.NaviScript -Not)  )   { return $True }
    elseif ( (IsLanguage $Redux.Unlock.Tunics)       -or (IsLanguage $Redux.Equipment.HerosBow) -or (IsLanguage $Redux.Capacity.EnableAmmo) -or (IsLanguage $Redux.Capacity.EnableWallet) )   { return $True }
    elseif ( (IsChecked  $Redux.Text.FemalePronouns) -or (IsChecked  $Redux.Text.TypoFixes)     -or (IsChecked  $Redux.Text.GoldSkulltula)  -or (IsChecked  $Redux.Text.Instant) )            { return $True }
    
    if ($Redux.Language[0].Checked) {
        if     ( (IsDefault $Redux.Equipment.KokiriSword  -Not) -or (IsDefault $Redux.Equipment.MasterSword  -Not) )                         { return $True }
        elseif ( (IsDefault $Redux.Equipment.DekuShield   -Not) -and $ChildModel.deku_shield -ne 0)                                          { return $True }
        elseif ( (IsDefault $Redux.Equipment.HylianShield -Not) -and $ChildModel.hylian_shield -ne 0 -and $AdultModel.hylian_shield -ne 0)   { return $True }
    }

}



#==============================================================================================================================================================================================
function WholeLanguageOptions([string]$Script, [string]$Table) {
    
    if (IsChecked $Redux.Text.MMoT) {
        ApplyPatch -File $Script -Patch "\Export\Message\malon_master_of_Time_static.bps"
        ApplyPatch -File $Table  -Patch "\Export\Message\malon_master_of_time_table.bps"
    }
    elseif (IsChecked $Redux.Text.Restore) {
        ApplyPatch -File $Script -Patch "\Export\Message\restore_static.bps"
        ApplyPatch -File $Table  -Patch "\Export\Message\restore_table.bps"
    }
    elseif (IsChecked $Redux.Text.Beta) {
        ApplyPatch -File $Script -Patch "\Export\Message\ura_static.bps"
        ApplyPatch -File $Table  -Patch "\Export\Message\ura_table.bps"
    }
    elseif (IsChecked $Redux.Text.Custom) {
        if ( (TestFile ($Gamefiles.editor + "\message_data_static." + $LanguagePatch.code + ".bin") ) -and (TestFile ($Gamefiles.editor + "\message_data." + $LanguagePatch.code + ".tbl") ) ) {
            Copy-Item -LiteralPath ($Gamefiles.editor + "\message_data_static." + $LanguagePatch.code + ".bin") -Destination $Script -Force
            Copy-Item -LiteralPath ($Gamefiles.editor + "\message_data."        + $LanguagePatch.code + ".tbl") -Destination $Table  -Force
        }
        else { WriteToConsole "Custom Text could not be found." }
    }

}



#==============================================================================================================================================================================================
function ByteLanguageOptions() {
    
    if ($GamePatch.title -like "*Ocarina*") {
        if ( (IsChecked $Redux.Text.Speed3x) -or (IsLanguage $Redux.Text.Instant) ) {
            ChangeBytes -Offset "B5006F" -Values "03"               # Text Speed
            SetMessage -ID "4046" -Text "1A"   -Replace "1A1401"    # Correct Ruto Confession Textbox
            SetMessage -ID "108E" -Text "0C3C" -Replace "0C76" -All # Correct Phantom Ganon Defeat Textbox (Delay)
            SetMessage -ID "108E" -Text "0E3C" -Replace "0E70"      # Correct Phantom Ganon Defeat Textbox (Fade)

            # Correct Learning Song Textboxes
            SetMessage -ID "086D" -Text "<W>.<Y><N><W><N><N><DC>" -Replace "<DC><W>.<Y><N><W><N><N>" # Play using ...
            SetMessage -ID "086E" -Text ".<N><N><N><DC>"          -Replace "<DC>.<N><N><N>"          # Play using ...
            SetMessage -ID "086F" -Text "<N><N><Ocarina>"         -Replace "<Ocarina><N><N>"         # Play using ...
            SetMessage -ID "0870" -Text "!<G><N><N><N><W><DC>"    -Replace "<DC>!<G><N><N><N><W>"    # Minuet of Forest
            SetMessage -ID "0871" -Text "!<N><N><N><DC>"          -Replace "<DC>!<N><N><N>"          # Bolero of Fire
            SetMessage -ID "0872" -Text "!<N><N><N><DC>"          -Replace "<DC>!<N><N><N>"          # Senerade of Water
            SetMessage -ID "0873" -Text "<DI><Shift:15>"          -Replace "<NS><Shift:15>"          # Requiem of Spirit
            SetMessage -ID "0873" -Text "!<N><N><N><DC>"          -Replace "<DC>!<N><N><N>"          # Requiem of Spirit
            SetMessage -ID "0874" -Text "!<N><N><N><DC>"          -Replace "<DC>!<N><N><N>"          # Nocturne of Shadow
            SetMessage -ID "0875" -Text "!<N><N><N><DC>"          -Replace "<DC>!<N><N><N>"          # Prelude of Light
            SetMessage -ID "0876" -Text "!<N><N><N><DC>"          -Replace "<DC>!<N><N><N>"          # Follow along with Saria's Song
            SetMessage -ID "0877" -Text ".<N><N><N><DC>"          -Replace "<DC>.<N><N><N>"          # Ok? This is the Song
            SetMessage -ID "0878" -Text ".<N><N><N><DC>"          -Replace "<DC>.<N><N><N>"          # Memorize this song
            SetMessage -ID "0879" -Text ".<N><N><N><DC>"          -Replace "<DC>.<N><N><N>"          # Keep the Sun's Song in your heart
            SetMessage -ID "087A" -Text ".<N><N><N><DC>"          -Replace "<DC>.<N><N><N>"          # This song opens the Door of Time
            SetMessage -ID "087B" -Text "!<N><N><N><DC>"          -Replace "<DC>!<N><N><N>"          # I'll never forget this song
            SetMessage -ID "087C" -Text ".<N><N><N><DC>"          -Replace "<DC>.<N><N><N>"          # Play using ...
        }
        elseif ( (IsChecked $Redux.Text.Speed2x) -or (IsChecked $Redux.Text.Instant) ) {
            ChangeBytes -Offset "B5006F" -Values "02"               # Text Speed
            SetMessage -ID "4046" -Text "1A"   -Replace "1A1401"    # Correct Ruto Confession Textbox
            SetMessage -ID "108E" -Text "0C3C" -Replace "0C66" -All # Correct Phantom Ganon Defeat Textbox (Delay)
            SetMessage -ID "108E" -Text "0E3C" -Replace "0E60"      # Correct Phantom Ganon Defeat Textbox (Fade)
        }

        if (IsChecked $Redux.UI.GCScheme) {
            SetMessage -ID "0103" -Text "<B><A Button>"  -Replace "<G><A Button>";  SetMessage -ID "0103" -Text "<B>Icon" -Replace "<G>Icon"; SetMessage -ID "0103" -Text "<B>blue" -Replace "<B>green" # Deku Tree - Opening a door
            SetMessage -ID "0337" -Text 'Hole of "Z"'    -Replace 'Hole of "L"'
            SetMessage -ID "1035" -Text "blue icon"      -Replace "green icon";     SetMessage -ID "1037"
            SetMessage -ID "1037" -Text "<B>Action Icon" -Replace "<G>Action Icon"; SetMessage -ID "1037" -Text "<B><A Button>" -Replace "<G><A Button>"

            SetMessage -ID "0066" -Text "05415354415254" -Replace "05445354415254"; SetMessage -ID "1039"; SetMessage -ID "103A"; SetMessage -ID "103B"; SetMessage -ID "103D"-Last; SetMessage -ID "2065"; SetMessage -ID "2071"; SetMessage -ID "405A" # START

            SetMessage -ID "002E" -Text "0542A0" -Replace "0541A0"; SetMessage -ID "004A"; SetMessage -ID "004B"; SetMessage -ID "00DD"; SetMessage -ID "00DD"; SetMessage -ID "00DD"; SetMessage -ID "0336" # B Button
            SetMessage -ID "0338"; SetMessage -ID "0401"; SetMessage -ID "086E"; SetMessage -ID "087C"; SetMessage -ID "103B"; SetMessage -ID "1072"; SetMessage -ID "407F"; SetMessage -ID "407F"

            SetMessage -ID "0108" -Text "0543416374696F6E" -Replace "0544416374696F6E"; SetMessage -ID "0337"; SetMessage -ID "0337" # Action

            SetMessage -ID "0037" -Text "05439F" -Replace "05429F"; SetMessage -ID "004A"; SetMessage -ID "004C"; SetMessage -ID "004D"; SetMessage -ID "005B"; SetMessage -ID "005C"; SetMessage -ID "0079"; SetMessage -ID "00A4"; SetMessage -ID "00CD"; SetMessage -ID "00CE"; SetMessage -ID "0108"; SetMessage -ID "0218" # A Button
            SetMessage -ID "0337"; SetMessage -ID "086D"; SetMessage -ID "086E"; SetMessage -ID "087C"; SetMessage -ID "1004"; SetMessage -ID "1007"; SetMessage -ID "103A"; SetMessage -ID "103D"; SetMessage -ID "2035"; SetMessage -ID "2037"; SetMessage -ID "300C"; SetMessage -ID "301C"; SetMessage -ID "3022"
            SetMessage -ID "302B"; SetMessage -ID "407F"; SetMessage -ID "4081"; SetMessage -ID "7004"; SetMessage -ID "0108"; SetMessage -ID "1004"; SetMessage -ID "1007"; SetMessage -ID "2035"; SetMessage -ID "302B"; SetMessage -ID "407F"; SetMessage -ID "7004"; SetMessage -ID "0108"; SetMessage -ID "1007"
            SetMessage -ID "1007"; SetMessage -ID "407F"; SetMessage -ID "407F"; SetMessage -ID "010C" -Text "0543209F" -Replace "0542209F"
        }

        if (IsLanguage $Redux.Unlock.Tunics) {
            SetMessage -ID "0050" -Text "adult size, so it won't fit a kid..." -Replace "unisize, so it fits an adult and kid"   # Goron Tunic
            SetMessage -ID "0051" -Text "adult size,<N>so it won't fit a kid." -Replace "unisize,<N>so it fits an adult and kid" # Zora Tunic
            SetMessage -ID "00AA" -Text "Adult" -Replace "Uni-"; SetMessage -ID "00AB"  # Tunic
        }

        if (IsIndex -Elem $Redux.Text.NaviScript -Not) {
            SetMessage -ID "1000" -Text "4E617669" -Replace $Redux.Text.NaviScript.text -NoParse; SetMessage -ID "1015"; SetMessage -ID "1017"; SetMessage -ID "1017"; SetMessage -ID "1017"; SetMessage -ID "103F"
            SetMessage -ID "103F";                                                                SetMessage -ID "1099"; SetMessage -ID "1099"; SetMessage -ID "109A"; SetMessage -ID "109A"; SetMessage -ID "109A"
        }
    }
    elseif (IsChecked $Redux.Text.Speed2x) { ChangeBytes -Offset "B5006F" -Values "02" }

    if (IsLanguage $Redux.Text.TypoFixes) {
        SetMessage "4013" -Text " Princess Ruto has gone to the <N>temple of Lake Hylia and has not<N>come back... I'm so worried...again!" -Replace "Princess Ruto has gone to Lake<N>Hylia and has not come back...<N>I'm so worried...again!"
        SetMessage "507B" -Text @(1, 1) -Replace @(1)
        SetMessage "6041" -Text "again "
    }

    if ( (IsChecked $Redux.Text.Restore) -or (IsChecked $Redux.Text.GoldSkulltula) ) { ChangeBytes -Offset "EC68CF" -Values "00"; ChangeBytes -Offset "EC69BF" -Values "00"; ChangeBytes -Offset "EC6A2B" -Values "00" }
    if (IsChecked $Redux.Text.GoldSkulltula) {
        if     ($LanguagePatch.code -eq "en")   { SetMessage -ID "00B4" -Replace "You got a <R>Gold Skulltula Token<W>!<N>You've collected <R><Gold Skulltulas><W> tokens in total.<Fade:28>"        }
        elseif ($LanguagePatch.code -eq "de")   { SetMessage -ID "00B4" -Replace "Du erhältst ein <R>Skulltula-Symbol<W>. Du<N>hast insgesamt <R><Gold Skulltulas><W> Skulltulas zerstört.<Fade:28>" }
        else                                    { SetMessage -ID "00B4" -Replace @(14, 40) -Append }
   }

    if (IsLanguage $Redux.Capacity.EnableAmmo) {
        if ($GamePatch.title -like "*Master of Time*")   { $arrow3 = "99" }   else                                                 { $arrow3 = "50" }
        if ($GamePatch.title -like "*Gold Quest*")       { $bomb1  = "10" }   elseif ($GamePatch.title -like "*Master of Time*")   { $bomb1  = "15" }   else   { $bomb1 = "20" }
        if ($GamePatch.title -like "*Gold Quest*")       { $bomb3  = "50" }   elseif ($GamePatch.title -like "*Master of Time*")   { $bomb3  = "99" }   else   { $bomb3 = "40" }
        if ($GamePatch.title -like "*Master of Time*")   { $nut3   = "99" }   else                                                 { $nut3   = "40" }

        SetMessage -ID "0056" -ASCII -Text "40"   -Replace $Redux.Capacity.Quiver2.text;   SetMessage -ID "0057" -ASCII -Text $arrow3 -Replace $Redux.Capacity.Quiver3.text
        SetMessage -ID "0058" -ASCII -Text $bomb1 -Replace $Redux.Capacity.BombBag1.text;  SetMessage -ID "0059" -ASCII -Text "30"    -Replace $Redux.Capacity.BombBag2.text;    SetMessage -ID "005A" -Text $bomb3 -Replace $Redux.Capacity.BombBag3.text
        SetMessage -ID "00A7" -ASCII -Text "30"   -Replace $Redux.Capacity.DekuNuts2.text; SetMessage -ID "00A8" -ASCII -Text $nut3   -Replace $Redux.Capacity.DekuNuts3.text

        if ($GamePatch.title -notlike "*Master of Time*") {
            SetMessage -ID "0007" -ASCII -Text "40" -Replace $Redux.Capacity.BulletBag2.text;  SetMessage -ID "006C" -ASCII -Text "50" -Replace $Redux.Capacity.BulletBag3.text
            SetMessage -ID "0037" -ASCII -Text "10" -Replace $Redux.Capacity.DekuSticks1.text; SetMessage -ID "0090" -ASCII -Text "20" -Replace $Redux.Capacity.DekuSticks2.text; SetMessage -ID "0091" -Text "30" -Replace $Redux.Capacity.DekuSticks3.text
        }

        $arrow3 = $bomb1 = $bomb3 = $nut3 = $null
    }

    if (IsLanguage $Redux.Capacity.EnableWallet) {
        if ($GamePatch.title -like "Master of Time*") { $wallet2 = "250" } else { $wallet2 = "200" }
        if ($GamePatch.title -notlike "Ocarina*")     { $wallet3 = "999" } else { $wallet3 = "500" }
        SetMessage -ID "005E" -ASCII -Text $wallet2 -Replace $Redux.Capacity.Wallet2.Text -NoParse; SetMessage -ID "005F" -ASCII -Text $wallet3 -Replace $Redux.Capacity.Wallet3.Text -NoParse
        $wallet2 = $wallet3 = $null
    }

    if (IsLanguage $Redux.Equipment.HerosBow) { SetMessage -ID "0031" -Text "Fairy Bow" -Replace "Hero's Bow" }

    if     (IsLangText -Elem $Redux.Equipment.KokiriSword -Compare "Knife"       -and $GamePatch.title -notlike "*Master of Time*")   { SetMessage -ID "00A4" -Text "Kokiri Sword" -Replace "Knife"       -NoParse; SetMessage -ID "10D2" }
    elseif (IsLangText -Elem $Redux.Equipment.KokiriSword -Compare "Razor Sword" -and $GamePatch.title -notlike "*Master of Time*")   { SetMessage -ID "00A4" -Text "Kokiri Sword" -Replace "Razor Sword" -NoParse; SetMessage -ID "10D2" }

    if ( (IsDefault $Redux.Equipment.MasterSword -Not) -and $Redux.Language[0].Checked) {
        $replace = "Master Sword"
        if     (IsLangText -Elem $Redux.Equipment.MasterSword -Compare "Gilded Sword")          { $replace = "Gilded Sword"        }
        elseif (IsLangText -Elem $Redux.Equipment.MasterSword -Compare "Great Fairy's Sword")   { $replace = "Great Fairy's Sword" }
        elseif (IsLangText -Elem $Redux.Equipment.MasterSword -Compare "Double Helix Sword")    { $replace = "Double Helix Sword"  }
        if ($replace -ne "Master Sword") { SetMessage -ID "600C" -Text "Master Sword" -Replace $replace -NoParse; SetMessage -ID "704F"; SetMessage -ID "7051"; SetMessage -ID "7059"; SetMessage -ID "706D"; SetMessage -ID "7075"; SetMessage -ID "7081"; SetMessage -ID "7088"; SetMessage -ID "7091"; SetMessage -ID "70E8" }
        $replace = $null
    }

    if ( (IsLangText -Elem $Redux.Equipment.DekuShield -Compare "Iron Shield") -and $ChildModel.deku_shield -ne 0 -and $GamePatch.title -notlike "*Master of Time*") {
        SetMessage -ID "004C" -Text "Deku Shield" -Replace "Iron Shield" -NoParse; SetMessage -ID "0089"; SetMessage -ID "009F"; SetMessage -ID "0611" SetMessage -ID "103D"-Last; SetMessage -ID "1052"; SetMessage -ID "10CB"; SetMessage -ID "10D2"
    }

    if ($ChildModel.hylian_shield -ne 0 -and $AdultModel.hylian_shield -ne 0) {
        if     (IsLangText -Elem $Redux.Equipment.HylianShield -Compare "Hero's Shield")   { SetMessage -ID "004D" -Text "Hylian Shield" -Replace "Hero's Shield" -NoParse; SetMessage -ID "0092"; SetMessage -ID "009C"; SetMessage -ID "00A9"; SetMessage -ID "7013"; SetMessage -ID "7121" }
        elseif (IsLangText -Elem $Redux.Equipment.HylianShield -Compare "Red Shield")      { SetMessage -ID "004D" -Text "Hylian Shield" -Replace "Red Shield"    -NoParse; SetMessage -ID "0092"; SetMessage -ID "009C"; SetMessage -ID "00A9"; SetMessage -ID "7013"; SetMessage -ID "7121" }
        elseif (IsLangText -Elem $Redux.Equipment.HylianShield -Compare "Metal Shield")    { SetMessage -ID "004D" -Text "Hylian Shield" -Replace "Metal Shield"  -NoParse; SetMessage -ID "0092"; SetMessage -ID "009C"; SetMessage -ID "00A9"; SetMessage -ID "7013"; SetMessage -ID "7121" }
    }

    if (IsChecked $Redux.Text.FemalePronouns) {
        SetMessage -ID "10B2" -Text "You must be a nice guy!"                                                                        -Replace "You must be a nice gal!"
        SetMessage -ID "10B2" -Text "Mr. Nice Guy"                                                                                   -Replace "Ms. Nice Gal"
        SetMessage -ID "2086" -Text "How'd you like to marry Malon?"                                                                 -Replace "How'd you like to come work for us?"
        SetMessage -ID "301C" -Text "fella"                                                                                          -Replace "lass"
        SetMessage -ID "3039" -Text "man-to-man"                                                                                     -Replace "man-to-woman"
        SetMessage -ID "3042" -Text "a<N>strong man like you"                                                                        -Replace "<N>strong like you"
        SetMessage -ID "4027" -Text @(6, 69); SetMessage -ID "4027" -Text "All right!"                                               -Replace "You're no man, so let's make<N>this our little secret, ok?"
        SetMessage -ID "403E" -Text "You're a terrible man to have <N>kept me waiting for these seven<N>long years..."               -Replace "You're a terrible betrothed<N>to have kept me waiting for<N>these seven long years..."
        SetMessage -ID "4041" -Text "man I chose to be my<N>husband"                                                                 -Replace "woman I chose to be my<>best friend"
        SetMessage -ID "404E" -Text "If you're a man, act like one!"                                                                 -Replace "If you're supposed to save me, act like it!"
        SetMessage -ID "507C" -Text "There he is! It's him!<N>He"                                                                    -Replace "There she is! It's her!<N>She"
        SetMessage -ID "6036" -Text "handsome man...<Delay:50>I should have kept the promise<N>I made back then..."                  -Replace "beautiful woman...<Delay:50>I should have had let you<N>join us back then..."
        SetMessage -ID "70F4" -Text "handsome"                                                                                       -Replace "pretty"

        SetMessage -ID "00E7" -Text "boy"      -Replace "girl";       SetMessage -ID "0408"; SetMessage -ID "1058" -All; SetMessage -ID "105B"; SetMessage -ID "1065"; SetMessage -ID "1096"; SetMessage -ID "109A"; SetMessage -ID "109F"; SetMessage -ID "2000"; SetMessage -ID "2043"
        SetMessage -ID "2047" -All;                                   SetMessage -ID "2048"; SetMessage -ID "204A";      SetMessage -ID "2086"; SetMessage -ID "40AC"; SetMessage -ID "5022"; SetMessage -ID "5036"; SetMessage -ID "505B"; SetMessage -ID "505D"; SetMessage -ID "6024"
        SetMessage -ID "605D" -All;                                   SetMessage -ID "6079"; SetMessage -ID "7007" -All; SetMessage -ID "7023"; SetMessage -ID "7090"; SetMessage -ID "7174"

        SetMessage -ID "00BE" -Text "man"      -Replace "lady";       SetMessage -ID "0168"; SetMessage -ID "021C";      SetMessage -ID "2025"; SetMessage -ID "2030"; SetMessage -ID "2037"; SetMessage -ID "2085"; SetMessage -ID "407D"; SetMessage -ID "4088"; SetMessage -ID "502D"
        SetMessage -ID "502E";                                        SetMessage -ID "5041"; SetMessage -ID "505B" -All; SetMessage -ID "5081"; SetMessage -ID "6066"; SetMessage -ID "7011"; SetMessage -ID "70F4"; SetMessage -ID "70F5"; SetMessage -ID "70F7"; SetMessage -ID "70F8"

        SetMessage -ID "6035" -Text "man"      -Replace "woman";      SetMessage -ID "70A1"
        SetMessage -ID "102F" -Text "real man" -Replace "real woman"; SetMessage -ID "10D7"; SetMessage -ID "301C"; SetMessage -ID "301D"; SetMessage -ID "303C"
        SetMessage -ID "301E" -Text "Brother"  -Replace "Sister";     SetMessage -ID "3027"; SetMessage -ID "3039"; SetMessage -ID "303C"; SetMessage -ID "3041"; SetMessage -ID "3045"; SetMessage -ID "3046"; SetMessage -ID "3068" -All
        SetMessage -ID "3006" -Text "brother"  -Replace "sister";     SetMessage -ID "70E1"
        SetMessage -ID "3000" -Text "Brother"  -Replace "Sibling";    SetMessage -ID "3001"; SetMessage -ID "3004"; SetMessage -ID "303D"
        SetMessage -ID "102F" -Text "Mr."      -Replace "Ms.";        SetMessage -ID "200A"; SetMessage -ID "2010"; SetMessage -ID "2011"; SetMessage -ID "2015"; SetMessage -ID "2020"; SetMessage -ID "5068"; SetMessage -ID "712D"
        SetMessage -ID "4018" -Text "son"      -Replace "lass";       SetMessage -ID "5063"; SetMessage -ID "5066"
        SetMessage -ID "708A" -Text "sonny"    -Replace "lassie";     SetMessage -ID "7148"; SetMessage -ID "714A"
        SetMessage -ID "2060" -Text "lad"      -Replace "lass";       SetMessage -ID "40A9"; SetMessage -ID "5025"
        SetMessage -ID "101A" -Text "master"   -Replace "mistress";   SetMessage -ID "109B"
        SetMessage -ID "1052" -Text "mister"   -Replace "miss";       SetMessage -ID "1053"; SetMessage -ID "1055"; SetMessage -ID "1057"; SetMessage -ID "1058"; SetMessage -ID "105A"; SetMessage -ID "105D"; SetMessage -ID "1073"; SetMessage -ID "1076"; SetMessage -ID "4093"
        SetMessage -ID "105B" -Text "Mister"   -Replace "Miss"
        SetMessage -ID "0012" -Text "guy"      -Replace "gal";        SetMessage -ID "0058"; SetMessage -ID "00F7"; SetMessage -ID "1074"; SetMessage -ID "10B4"; SetMessage -ID "10B6"; SetMessage -ID "607D"; SetMessage -ID "701F" -All; SetMessage -ID "7190"
        SetMessage -ID "0420" -Text "he"       -Replace "she";        SetMessage -ID "1075"; SetMessage -ID "5034"; SetMessage -ID "508A"; SetMessage -ID "602B"
        SetMessage -ID "105B" -Text "He"       -Replace "She";        SetMessage -ID "2010"; SetMessage -ID "6048"
        SetMessage -ID "109A" -Text "his"      -Replace "her";        SetMessage -ID "604A"
        SetMessage -ID "1065" -Text "him"      -Replace "her";        SetMessage -ID "1068"; SetMessage -ID "1070"; SetMessage -ID "1071" -All; SetMessage -ID "109A"; SetMessage -ID "10D6" -All; SetMessage -ID "5034"; SetMessage -ID "6048"; SetMessage -ID "6049"; SetMessage -ID "604A" #>
    }

    if (IsChecked $Redux.Text.Instant) {
        WriteToConsole "Starting Generating Instant Text"
        :outer foreach ($h in $DialogueList.GetEnumerator()) {
            if     ($h.name -eq "108E" -or $h.name -eq "403E" -or $h.name -eq "605A" -or $h.name -eq "706C" -or $h.name -eq "70DD" -or $h.name -eq "706F" -or $h.name -eq "7091" -or $h.name -eq "7092" -or $h.name -eq "7093" -or $h.name -eq "7094" -or $h.name -eq "7095" -or $h.name -eq "7070") { continue }
            elseif ( (GetDecimal $h.name) -ge 2157 -and (GetDecimal $h.name) -le 2172) { continue } # Learning Songs

            if ($h.name -ne "00B4") {
                for ($i=0; $i -lt $DialogueList[$h.name].msg.count-1; $i++) {
                    if ($DialogueList[$h.name].msg[$i] -eq 14) {
                        if ($i -eq 0) { $h.name; continue outer }
                        elseif ($i -ge 2) {
                            if     ($DialogueList[$h.name].msg[$i-2] -eq 7 -or $DialogueList[$h.name].msg[$i-2] -eq 8)                                                                                                                                        { continue }
                            elseif ($DialogueList[$h.name].msg[$i-1] -eq 6 -or $DialogueList[$h.name].msg[$i-1] -eq 12 -or $DialogueList[$h.name].msg[$i-1] -eq 17 -or $DialogueList[$h.name].msg[$i-1] -eq 19 -or $DialogueList[$h.name].msg[$i-1] -eq 20)   { continue }
                            else { continue outer }
                        }
                        else {
                            if     ($DialogueList[$h.name].msg[$i-1] -eq 6 -or $DialogueList[$h.name].msg[$i-1] -eq 12 -or $DialogueList[$h.name].msg[$i-1] -eq 17 -or $DialogueList[$h.name].msg[$i-1] -eq 19 -or $DialogueList[$h.name].msg[$i-1] -eq 20)   { continue }
                            else { continue outer }
                        }
                    }
                }
            }

            SetMessage -ID $h.name -Text @(8)                              -Silent -All    # Remove all <DI>
            SetMessage -ID $h.name -Text @(9)                              -Silent -All    # Remove all <DC>
            SetMessage -ID $h.name -Text @(20, 0)                          -Silent -All    # Remove all <Wait:00>
            SetMessage -ID $h.name -Text @(20, 1)                          -Silent -All    # Remove all <Wait:01>
            SetMessage -ID $h.name -Text @(20, 2)                          -Silent -All    # Remove all <Wait:02>
            SetMessage -ID $h.name                  -Replace @(8)          -Silent -Insert # Insert <DI> to start
            SetMessage -ID $h.name -Text @(4)       -Replace @(4, 8)       -Silent -All    # Add <DI> after <New Box>
            SetMessage -ID $h.name -Text @(12, 10)  -Replace @(12, 10,  8) -Silent -All    # Add <DI> after <Delay:0A>
            SetMessage -ID $h.name -Text @(12, 20)  -Replace @(12, 20,  8) -Silent -All    # Add <DI> after <Delay:14>
            SetMessage -ID $h.name -Text @(12, 30)  -Replace @(12, 30,  8) -Silent -All    # Add <DI> after <Delay:1E>
            SetMessage -ID $h.name -Text @(12, 40)  -Replace @(12, 40,  8) -Silent -All    # Add <DI> after <Delay:28>
            SetMessage -ID $h.name -Text @(12, 60)  -Replace @(12, 60,  8) -Silent -All    # Add <DI> after <Delay:3C>
            SetMessage -ID $h.name -Text @(12, 70)  -Replace @(12, 70,  8) -Silent -All    # Add <DI> after <Delay:46>
            SetMessage -ID $h.name -Text @(12, 80)  -Replace @(12, 80,  8) -Silent -All    # Add <DI> after <Delay:50>
            SetMessage -ID $h.name -Text @(12, 90)  -Replace @(12, 90,  8) -Silent -All    # Add <DI> after <Delay:5A>
        }
        WriteToConsole "Finished Generating Instant Text"
    }

}



#==============================================================================================================================================================================================
function AdjustGUI() {
    
    EnableElem -Elem $Redux.Unlock.DekuSticks -Active $Patches.Redux.Checked

    if ($Patches.Redux.Checked) {
        EnableElem -Elem $Redux.UI.Buttonpositions   -Active ($Redux.UI.Layout.SelectedIndex -eq 0)
        EnableElem -Elem $Redux.Colors.RupeesVanilla -Active (!$Redux.Hooks.RupeeIconColors.Checked)
        EnableForm -Form $Redux.Box.TextColors       -Enable (!$Redux.UI.GCScheme.Checked)
    }

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    if ($GamePatch.title -like "*Ocarina*") { $tabs = @("Main", "Graphics", "Audio", "Difficulty", "Scenes") } else { $tabs = @("Main", "Graphics", "Audio", "Difficulty") }
    if (IsSimple)   { CreateOptionsDialog -Columns 6 -Height 550 -Tabs ($tabs + @("Equipment", "Animations")) }
    else            { CreateOptionsDialog -Columns 6 -Height 600 -Tabs ($tabs + @("Colors", "Equipment", "Capacity", "Animations")) }
    $tabs = $null

}



#==============================================================================================================================================================================================
function CreateTabMain() {

    # GAMEPLAY #

    CreateReduxGroup    -Tag  "Gameplay" -Text "Gameplay" 
    if ($GamePatch.title -notlike "*Gold Quest*") {
        CreateReduxComboBox -Name "FasterBlockPushing"   -Text "Faster Block Pushing"      -Default 3 -Info "All blocks are pushed faster" -Items @("Disabled", "Exclude Time-Based Puzzles", "Fully Enabled")                                                                            -Credits "GhostlyDark (Ported from Redux)"
    }
    if ($GamePatch.title -like "*Ocarina*") {
        CreateReduxCheckBox -Name "ReturnChild"          -Text "Can Always Return"                    -Info "You can always go back to being a child again before clearing the boss of the Forest Temple`nOut of the way Sheik!"                                                          -Credits "Ported from Redux"
    }
    CreateReduxCheckBox -Name "DistantZTargeting"        -Text "Distant Z-Targeting"        -Advanced -Info "Allow to use Z-Targeting on enemies, objects and NPC's from any distance"                                                                                                    -Credits "Admentus"
    CreateReduxCheckBox -Name "ManualJump"               -Text "Manual Jump"                -Advanced -Info "Press Z + A to do a Manual Jump instead of a Jump Attack`nPress B mid-air after jumping to do a Jump Attack"                                                                 -Credits "Admentus (ROM) & CloudModding (GameShark)"
    CreateReduxCheckBox -Name "NoKillFlash"              -Text "No Kill Flash"              -Advanced -Info "Disable the flash effect when killing certain enemies such as the Guay or Skullwalltula"                                                                                     -Credits "Chez Cousteau"
    CreateReduxCheckBox -Name "NoShieldRecoil"           -Text "No Shield Recoil"           -Advanced -Info "Disable the recoil when being hit while shielding"                                                                                                                           -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxCheckBox -Name "RunWhileShielding"        -Text "Run While Shielding"        -Advanced -Info "Press R to shield will no longer prevent Link from moving around" -Link $Redux.Gameplay.NoShieldRecoil                                                                       -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxCheckBox -Name "PushbackAttackingWalls"   -Text "Pushback Attacking Walls"   -Advanced -Info "Link is getting pushed back a bit when hitting the wall with the sword"                                                                                                      -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxCheckBox -Name "RemoveCrouchStab"         -Text "Remove Crouch Stab"         -Advanced -Info "The Crouch Stab move is removed"                                                                                                                                             -Credits "Garo-Mastah"
    CreateReduxCheckBox -Name "RemoveQuickSpin"          -Text "Remove Magic Quick Spin"    -Advanced -Info "The magic Quick Spin Attack move is removed`nIt's a regular Quick Spin Attack now instead"                                                                                   -Credits "Admentus & Three Pendants"
    CreateReduxCheckBox -Name "ClimbAnything"            -Text "Climb Anything"                       -Info "Climb most walls in the game" -Warning "Prone to softlocks, be careful"                                                                                            -Advanced -Credits "Ported from Rando"
    if ($GamePatch.title -notlike "*Dawn & Dusk*") {
        CreateReduxCheckBox -Name "OpenBombchuShop"      -Text "Open Bombchu Shop"                    -Info "The Bombchu Shop is open right away without the need to defeat King Dodongo"                                                                                                 -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "HookshotAnything"     -Text "Hookshot Anything"                    -Info "Be able to hookshot most surfaces" -Warning "Prone to softlocks, be careful"                                                                                       -Advanced -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "NoMagicArrowCooldown" -Text "No Magic Arrow Cooldown"              -Info "Be able to shoot magic arrows without delay inbetween" -Warning "Prone to crashes if switching arrow types too quickly"                                            -Advanced -Credits "Ported from Rando"
    }
    if ($GamePatch.options -eq 1) {
        CreateReduxCheckBox -Name "Medallions"           -Text "Require All Medallions"               -Info "All six medallions are required for the Rainbow Bridge to appear before Ganon's Castle`nThe vanilla requirements were the Shadow and Spirit Medallions and the Light Arrows" -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "RutoNeverDisappears"  -Text "Ruto Never Disappears"                -Info "Ruto never disappears in Jabu Jabu's Belly and will remain in place when leaving the room"                                                                                   -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "ResumeLastArea"       -Text "Resume From Last Area"                -Info "Resume playing from the area you last saved in" -Warning "Don't save in Grottos"                                                                                             -Credits "Admentus (ROM) & Aegiker (GameShark)"
        CreateReduxCheckBox -Name "SpawnLinksHouse"      -Text "Adult Spawns in Link's House" -Simple -Info "Saving the game anywhere outside of a dungeon will make Adult start the session in Link's House instead of the Temple of Time"                                               -Credits "GhostlyDark"
        CreateReduxCheckBox -Name "AllowWarpSongs"       -Text "Allow Warp Songs"                     -Info "Allow warp songs in Gerudo Training Ground and Ganon's Castle"                                                                                                               -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "AllowFaroreWind"      -Text "Allow Farore's Wind"                  -Info "Allow Farore's Wind in Gerudo Training Ground and Ganon's Castle"                                                                                                            -Credits "Ported from Rando"
        CreateReduxComboBox -Name "SpawnChild" -Text "Child Starting Location" -Advanced -Default 1 -Items ("Link's House", "Temple of Time", "Hyrule Field", "Kakariko Village", "Inside the Deku Tree", "Dodongo's Cavern", "Inside Jabu-Jabu's Belly", "Forest Temple", "Fire Temple", "Water Temple", "Shadow Temple", "Spirit Temple", "Ice Cavern", "Bottom of the Well", "Thieves' Hideout", "Gerudo's Training Ground", "Inside Ganon's Castle", "Ganon's Tower") -Credits "Admentus & GhostlyDark"
        CreateReduxComboBox -Name "SpawnAdult" -Text "Adult Starting Location" -Advanced -Default 2 -Items ("Link's House", "Temple of Time", "Hyrule Field", "Kakariko Village", "Inside the Deku Tree", "Dodongo's Cavern", "Inside Jabu-Jabu's Belly", "Forest Temple", "Fire Temple", "Water Temple", "Shadow Temple", "Spirit Temple", "Ice Cavern", "Bottom of the Well", "Thieves' Hideout", "Gerudo's Training Ground", "Inside Ganon's Castle", "Ganon's Tower") -Credits "Admentus & GhostlyDark"
    }



    # RESTORE #

    CreateReduxGroup    -Tag  "Restore"             -Text "Restore / Correct / Censor"
    CreateReduxCheckBox -Name "RupeeColors"         -Text "Correct Rupee Colors"   -Info "Corrects the colors for the Purple (50) and Golden (200) Rupees"                                                                                                          -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "CowNoseRing"         -Text "Restore Cow Nose Ring"  -Info "Restore the rings in the noses for Cows as seen in the Japanese release"                                                                                                  -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "CenterTextboxCursor" -Text "Center Textbox Cursor"  -Info "Aligns the textbox cursor to the center of the screen"                                                                                                                    -Credits "Username0713"
    if ($GamePatch.options -eq 1) {
        CreateReduxCheckBox -Name "FireTemple"      -Text "Censor Fire Temple"     -Info "Censor Fire Temple theme as used in the Rev 2 ROM"                                                                                                                        -Credits "ShadowOne333"
        CreateReduxCheckBox -Name "GerudoTextures"  -Text "Censor Gerudo Textures" -Info "Censor Gerudo symbol textures used in the GameCube / Virtual Console releases`n- Disable the option to uncensor the Gerudo Texture used in the Master Quest dungeons`n- Player model textures such as the Mirror Shield might not get restored for specific custom models" -Credits "GhostlyDark & ShadowOne333"
        CreateReduxComboBox -Name "Blood"           -Text "Blood Color"            -Info "Change the color of blood used for several monsters, Ganondorf and Ganon" -Items @("Default", "Red blood for monsters", "Green blood for Ganondorf/Ganon", "Change both") -Credits "ShadowOne333 & Admentus"
    }
    else { CreateReduxCheckBox -Name "RedBlood"     -Text "Red Blood"              -Info "Change the color of blood used for several monsters to red" -Credits "Admentus" }



    # FIXES #

    if ($GamePatch.title -notlike "*Master of Time*") {
        CreateReduxGroup    -Tag  "Fixes"                -Text "Fixes"
        if ($GamePatch.title -like "*Ocarina*") {
            CreateReduxCheckBox -Name "NaviTarget"           -Text "Navi Targettable Spots"    -Advanced -Info "Fix several spots in dungeons which Navi could not target for Link"                                                                                   -Credits "Chez Cousteau"
            CreateReduxCheckBox -Name "SpiritTempleMirrors"  -Text "Spirit Temple Mirrors"               -Info "Fix a broken effect with the mirrors in the Spirit Temple"                                                                                            -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool) & GhostlyDark (ported)"
        }
        if ($GamePatch.title -notlike "*Master of Time*") {
            CreateReduxCheckBox -Name "PauseScreenDelay"     -Text "Pause Screen Delay"         -Checked -Info "Removes the delay when opening the Pause Screen by removing the anti-aliasing" -Native                                                                -Credits "zel"
            CreateReduxCheckBox -Name "PauseScreenCrash"     -Text "Pause Screen Crash Fix"     -Checked -Info "Prevents the game from randomly crashing emulating a decompressed ROM upon pausing"                                                                   -Credits "zel"
        }
        if ($GamePatch.title -notlike "*Dawn & Dusk*") {
            CreateReduxCheckBox -Name "RemoveFishingPiracy"  -Text "Remove Fishing Anti-Piracy" -Checked -Info "Removes the anti-piracy check for fishing that can cause the fish to always let go after 51 frames"                                                   -Credits "Ported from Rando"
            CreateReduxCheckBox -Name "PoacherSaw"           -Text "Poacher's Saw"              -Checked -Info "Obtaining the Poacher's Saw no longer prevents Link from obtaining the second Deku Nut upgrade"                                                       -Credits "Ported from Rando"
            CreateReduxCheckBox -Name "Boomerang"            -Text "Boomerang"                           -Info "Fix the gem color on the thrown boomerang"                                                                                                            -Credits "Aria"
            CreateReduxCheckBox -Name "FortressMinimap"      -Text "Gerudo Fortress Minimap"             -Info "Display the complete minimap for the Gerudo Fortress during the Child era"                                                                            -Credits "GhostlyDark"
            CreateReduxCheckBox -Name "AlwaysMoveKingZora"   -Text "Always Move King Zora"     -Advanced -Info "King Zora will move aside even if the Zora Sapphire is in possession"                                                                                 -Credits "Ported from Rando"
            CreateReduxCheckBox -Name "DeathMountainOwl"     -Text "Death Mountain Owl"        -Advanced -Info "The Owl on top of the Death Mountain will always carry down Link regardless of having magic"                                                          -Credits "Ported from Rando"
        }
    }



    # OTHER #

    CreateReduxGroup    -Tag  "Other"                 -Text "Other"
    if ($GamePatch.title -like "*Gold Quest*") { $val = 3 } else { $val = 4 }
    CreateReduxComboBox -Name "MapSelect"             -Text "Enable Map Select"        -Items @("Disable", "Translate Only", "Enable Only", "Translate and Enable") -Info "Enable the Map Select menu like in the Debug ROM`nThe File Select menu now opens the Map Select menu instead`nA separate debug save file is used" -Credits "Jared Johnson (translated by Zelda Edit)"
    if ($GamePatch.title -like "*Gold Quest*") { $val = 2 } else { $val = 1 }
    CreateReduxComboBox -Name "SkipIntro"             -Text "Skip Intro" -Default $val -Items @("Don't Skip", "Skip Logo", "Skip Title Screen", "Skip Logo and Title Screen")                               -Info "Skip the logo, title screen or both"           -Credits "Aegiker"
    if ($GamePatch.title -like "*Gold Quest*") { $val = 3 } else { $val = 4 }
    CreateReduxComboBox -Name "Skybox"                -Text "Skybox"     -Default $val -Items @("Dawn", "Day", "Dusk", "Night", "Darkness (Dawn)", "Darkness (Day)", "Darkness (Dusk)", "Darkness (Night)") -Info "Set the skybox theme for the File Select menu" -Credits "Admentus"
    if ($GamePatch.title -like "*Ocarina*") {
        CreateReduxCheckBox -Name "MuteOwls"             -Text "Mute Owls"                          -Info "Kaepora Gaebora the owl will no longer interrupt Link with tutorials"                                                                                  -Credits "Chez Cousteau"
        CreateReduxCheckBox -Name "RemoveNaviPrompts"    -Text "Remove Navi Prompts"                -Info "Navi will no longer interrupt you with tutorial text boxes in dungeons"                                                                                -Credits "Ported from Redux"
    }
    CreateReduxCheckBox -Name "DefaultZTargeting"        -Text "Default Hold Z-Targeting" -Advanced -Info "Change the Default Z-Targeting option to Hold instead of Switch"                                                                                       -Credits "Ported from Redux"
    if ($GamePatch.options -eq 1) {
        CreateReduxCheckBox -Name "RemoveNaviTimer"      -Text "Remove Navi Timer"                  -Info "Navi will no longer pop up with text messages during gameplay"                                                                                         -Credits "Admentus"
        CreateReduxCheckBox -Name "InstantClaimCheck"    -Text "Instant Claim Check"                -Info "Remove the check for waiting until the Biggoron Sword can be claimed through the Claim Check"                                                          -Credits "Ported from Rando"
    }
    CreateReduxCheckBox -Name "ItemSelect"                -Text "Translate Item Select"             -Info "Translates the Debug Inventory Select menu into English"                                                                                               -Credits "GhostlyDark"
    if ($GamePatch.title -notlike "*Dawn & Dusk*") {
        CreateReduxCheckBox -Name "DiskDrive"             -Text "Enable Disk Drive Saves" -Advanced -Info "Use the Disk Drive for Save Slots" -Warning "This option disables the use of non-Disk Drive save slots"                                                -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool) & GhostlyDark (ported)"
    }

    


    # SPEED #

    CreateReduxGroup  -Tag  "Gameplay" -Text "Speed" -Height 1.2
    if ($GamePatch.title -like "*Gold Quest*") { $val = 650 } else { $val = 600 }
    CreateReduxSlider -Name "MovementSpeed" -Default $val  -Min 300 -Max 1200 -Freq 50 -Small 25 -Large 50 -Text "Link's Speed" -Info "Adjust the movement speed for Link" -Credits "AndiiSyn"

    $val = $null

}



#==============================================================================================================================================================================================
function CreateTabRedux() {
    
    # D-PAD #

    CreateReduxGroup       -Tag  "Dpad"        -Text "D-Pad Layout"
    CreateReduxPanel -Columns 4
    CreateReduxRadioButton -Name "Disable"     -SaveTo "Layout" -Column 1          -Text "Disable"    -Info "Completely disable the D-Pad"                      -Credits "Admentus"
    CreateReduxRadioButton -Name "Hide"        -SaveTo "Layout" -Column 2          -Text "Hidden"     -Info "Hide the D-Pad icons, while they are still active" -Credits "Admentus"
    CreateReduxRadioButton -Name "LayoutLeft"  -SaveTo "Layout" -Column 3 -Checked -Text "Left Side"  -Info "Show the D-Pad icons on the left side of the HUD"  -Credits "Admentus"
    CreateReduxRadioButton -Name "LayoutRight" -SaveTo "Layout" -Column 4          -Text "Right Side" -Info "Show the D-Pad icons on the right side of the HUD" -Credits "Admentus"
    if ($GamePatch.title -notlike "*Dawn & Dusk*") { CreateReduxCheckBox -Name "DualSet" -Text "Dual Set" -Info "Allow switching between two different D-Pad sets" -Credits "Admentus" -Link $Redux.Dpad.Disable }

    $items = @("Disabled", "Swords", "Boots", "Shields", "Tunics", "Arrows", "Iron Boots", "Hover Boots", "Child Trade", "Ocarina")
    if ($GamePatch.options -eq 1) {
        CreateReduxGroup    -Tag  "Dpad"   -Text "Child Set 1"
        CreateReduxComboBox -Name "Left1"  -Column 1   -Row 1 -Text "Left"  -Shift (-60) -Length 140 -Items $items -Default "Disabled"    -Info "Set the quick slot item for the D-Pad Left button"  -Credits "Admentus"
        CreateReduxComboBox -Name "Down1"  -Column 2.5 -Row 1 -Text "Down"  -Shift (-60) -Length 140 -Items $items -Default "Ocarina"     -Info "Set the quick slot item for the D-Pad Down button"  -Credits "Admentus"
        CreateReduxComboBox -Name "Right1" -Column 4   -Row 1 -Text "Right" -Shift (-60) -Length 140 -Items $items -Default "Child Trade" -Info "Set the quick slot item for the D-Pad Right button" -Credits "Admentus"
        CreateReduxComboBox -Name "Up1"    -Column 5.5 -Row 1 -Text "Up"    -Shift (-60) -Length 140 -Items $items -Default "Disabled"    -Info "Set the quick slot item for the D-Pad Up button"    -Credits "Admentus"

        CreateReduxGroup    -Tag  "Dpad"   -Text "Child Set 2"
        CreateReduxComboBox -Name "Left2"  -Column 1   -Row 1 -Text "Left"  -Shift (-60) -Length 140 -Items $items -Default "Tunics"      -Info "Set the quick slot item for the D-Pad Left button"  -Credits "Admentus"
        CreateReduxComboBox -Name "Down2"  -Column 2.5 -Row 1 -Text "Down"  -Shift (-60) -Length 140 -Items $items -Default "Shields"     -Info "Set the quick slot item for the D-Pad Down button"  -Credits "Admentus"
        CreateReduxComboBox -Name "Right2" -Column 4   -Row 1 -Text "Right" -Shift (-60) -Length 140 -Items $items -Default "Boots"       -Info "Set the quick slot item for the D-Pad Right button" -Credits "Admentus"
        CreateReduxComboBox -Name "Up2"    -Column 5.5 -Row 1 -Text "Up"    -Shift (-60) -Length 140 -Items $items -Default "Swords"      -Info "Set the quick slot item for the D-Pad Up button"    -Credits "Admentus"
    }
    elseif ($GamePatch.title -like "*Dawn & Dusk*") {
        CreateReduxGroup    -Tag  "Dpad"   -Text "Child Set 1"
        CreateReduxComboBox -Name "Left1"  -Column 1   -Row 1 -Text "Left"  -Shift (-60) -Length 140 -Items $items -Default "Tunics"      -Info "Set the quick slot item for the D-Pad Left button"  -Credits "Admentus"
        CreateReduxComboBox -Name "Down1"  -Column 2.5 -Row 1 -Text "Down"  -Shift (-60) -Length 140 -Items $items -Default "Shields"     -Info "Set the quick slot item for the D-Pad Down button"  -Credits "Admentus"
        CreateReduxComboBox -Name "Right1" -Column 4   -Row 1 -Text "Right" -Shift (-60) -Length 140 -Items $items -Default "Disabled"    -Info "Set the quick slot item for the D-Pad Right button" -Credits "Admentus"
        CreateReduxComboBox -Name "Up1"    -Column 5.5 -Row 1 -Text "Up"    -Shift (-60) -Length 140 -Items $items -Default "Disabled"    -Info "Set the quick slot item for the D-Pad Up button"    -Credits "Admentus"
    }

    if ($GamePatch.title -notlike "*Dawn & Dusk*") {
        CreateReduxGroup    -Tag  "Dpad"   -Text "Adult Set 1"
        CreateReduxComboBox -Name "Left3"  -Column 1   -Row 1 -Text "Left"  -Shift (-60) -Length 140 -Items $items -Default "Hover Boots" -Info "Set the quick slot item for the D-Pad Left button"  -Credits "Admentus"
        CreateReduxComboBox -Name "Down3"  -Column 2.5 -Row 1 -Text "Down"  -Shift (-60) -Length 140 -Items $items -Default "Ocarina"     -Info "Set the quick slot item for the D-Pad Down button"  -Credits "Admentus"
        CreateReduxComboBox -Name "Right3" -Column 4   -Row 1 -Text "Right" -Shift (-60) -Length 140 -Items $items -Default "Iron Boots"  -Info "Set the quick slot item for the D-Pad Right button" -Credits "Admentus"
        CreateReduxComboBox -Name "Up3"    -Column 5.5 -Row 1 -Text "Up"    -Shift (-60) -Length 140 -Items $items -Default "Arrows"      -Info "Set the quick slot item for the D-Pad Up button"    -Credits "Admentus"

        CreateReduxGroup    -Tag  "Dpad"   -Text "Adult Set 2"
        CreateReduxComboBox -Name "Left4"  -Column 1   -Row 1 -Text "Left"  -Shift (-60) -Length 140 -Items $items -Default "Tunics"      -Info "Set the quick slot item for the D-Pad Left button"  -Credits "Admentus"
        CreateReduxComboBox -Name "Down4"  -Column 2.5 -Row 1 -Text "Down"  -Shift (-60) -Length 140 -Items $items -Default "Shields"     -Info "Set the quick slot item for the D-Pad Down button"  -Credits "Admentus"
        CreateReduxComboBox -Name "Right4" -Column 4   -Row 1 -Text "Right" -Shift (-60) -Length 140 -Items $items -Default "Boots"       -Info "Set the quick slot item for the D-Pad Right button" -Credits "Admentus"
        CreateReduxComboBox -Name "Up4"    -Column 5.5 -Row 1 -Text "Up"    -Shift (-60) -Length 140 -Items $items -Default "Swords"      -Info "Set the quick slot item for the D-Pad Up button"    -Credits "Admentus"
    }
    $items = $null


    # Layout

    CreateReduxGroup    -Tag  "UI"     -Text "HUD Layout"
    CreateReduxComboBox -Name "Layout" -Text "Buttons Layout" -Items @("Ocarina of Time", "Majora's Mask", "Nintendo", "Modern", "GameCube (Original)", "GameCube (Modern)") -Info "Set a layout for the HUD buttons interface" -Credits "Admentus"
    $Redux.UI.Layout.Add_SelectedIndexChanged({ EnableElem -Elem $Redux.UI.Buttonpositions -Active ($this.SelectedIndex -eq 0) })

    $Last.Group.Height = (DPISize 140)

    CreateImageBox -x 350 -y 10 -w 208 -h 120 -Name "LayoutPreview"
    $Redux.UI.Layout.Add_SelectedIndexChanged( {
        $file = $Paths.Shared + "\HUD\Layouts\" + $this.text.replace(" (default)", "") + ".png"
        if (TestFile $file) { SetBitMap -Path $file -Box $Redux.UI.LayoutPreview } else { $Redux.UI.LayoutPreview.Image = $null }

    } );
    $file = $Paths.Shared + "\HUD\Layouts\" + $Redux.UI.Layout.text.replace(" (default)", "") + ".png"
    if (TestFile $file) { SetBitMap -Path $file -Box $Redux.UI.LayoutPreview } else { $Redux.UI.LayoutPreview.Image = $null }



    # MISC #

    if ($GamePatch.title -notlike "*Dawn & Dusk*") {
        CreateReduxGroup    -Tag  "Misc"          -Text "Misc Options"
        CreateReduxCheckBox -Name "FastBunnyHood" -Text "Fast Bunny Hood"       -Info "The Bunny Hood makes Link run faster just like in Majora's Mask"        -Checked -Credits "Ported from Redux"
        CreateReduxCheckBox -Name "KeepMask"      -Text "Keep Mask"             -Info "Keep the mask equipped when changing areas"                             -Checked -Credits "Admentus"
        CreateReduxCheckBox -Name "BombchuDrops"  -Text "Bombchu Drops"         -Info "Bombchus can now drop from defeated enemies, cutting grass and broken jars"      -Credits "Ported from Redux"
        CreateReduxCheckBox -Name "FPS"           -Text "30 FPS (Experimental)" -Info "Experimental 30 FPS support`nUse L + Z to toggle between 20 FPS and 30 FPS mode" -Credits "Admentus" -Warning "30 FPS mode will have issues that prevent you from completing the game and certain challenges`nSwitch back to 20 FPS mode to continue these sections before returning to 30 FPS mode"
        CreateReduxComboBox -Name "SkipCutscenes" -Text "Skip Cutscenes" -Items @("Disabled", "Useful Cutscenes Excluded", "All") -Info "Skip Cutscenes`nUseful Cutscenes Excluded keeps cutscenes intact which are useful for performing glitches`nRequires a new save to take effect" -Credits "Ported from Rando"
    }


    # CODE HOOKS FEATURES #

    CreateReduxGroup    -Tag  "Hooks"                            -Text "Code Hook Features"
    CreateReduxCheckBox -Name "RupeeIconColors"         -Checked -Text "Rupee Icon Colors"        -Info "The color of the Rupees counter icon changes depending on your wallet size"                            -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "EmptyBombFix"            -Checked -Text "Empty Bomb Fix"           -Info "Fixes Empty Bomb Glitch"                                                                               -Credits "Ported from Redux"
    if ($GamePatch.title -notlike "*Dawn & Dusk*") {
        CreateReduxCheckBox -Name "BlueFireArrow"                -Text "Blue Fire Arrows"         -Info "Ice Arrows have the same attributes as Blue Fire, thus the ability to melt Blue Ice and bombable walls" -Credits "Ported from Redux"
    }
    if ($GamePatch.options -eq 1) {
        CreateReduxCheckBox -Name "ShowFileSelectIcons" -Checked -Text "Show File Select Icons"   -Info "Show icons on the File Select screen to display your save file progress"                               -Credits "Ported from Redux"
        CreateReduxCheckBox -Name "GoldGauntletsSpeedup"         -Text "Gold Gauntlets Speedup"   -Info "Cutscene speed-up for throwing pillars that require Golden Gauntlets"                                  -Credits "Ported from Redux"
        CreateReduxCheckBox -Name "StoneOfAgony"        -Checked -Text "Stone of Agony Indicator" -Info "The Stony of Agony uses a visual indicator in addition to rumble"                                      -Credits "Ported from Redux"
        CreateReduxCheckBox -Name "WarpSongsSpeedup"             -Text "Warp Songs Speedup"       -Info "Speedup the warp songs warping sequences"                                                              -Credits "Ported from Redux"
        CreateReduxCheckBox -Name "BiggoronFix"                  -Text "Big Goron Fix"            -Info "Fix bug when trying to trade in the Biggoron Sword"                                                    -Credits "Ported from Redux"
        CreateReduxCheckBox -Name "DampeFix"                     -Text "Dampé Fix"                -Info "Prevent the heart piece of the Gravedigging Tour from being missable"                                  -Credits "Ported from Redux"
        CreateReduxCheckBox -Name "HyruleGuardsSoftlock"         -Text "Hyrule Guards Softlock"   -Info "Fix a potential softlock when culling Hyrule Guards"                                                   -Credits "Ported from Redux"
        CreateReduxCheckBox -Name "TalonSkip"                    -Text "Skip Talon Cutscene"      -Info "Skip the cutscene after waking up Talon before entering the Castle Courtyard"                          -Credits "Ported from Redux"
    }
    else { CreateReduxCheckBox -Name "ShowFileSelectIcons"       -Text "Show File Select Icons"   -Info "Show icons on the File Select screen to display your save file progress"                               -Credits "Ported from Redux" }

    # BUTTON ACTIVATIONS #

    CreateReduxGroup    -Tag  "Misc"            -Text "Button Activations"
    CreateReduxCheckBox -Name "HUDToggle"       -Text "HUD Toggle"        -Info "Toggle the HUD by using the L button`nPress L in the Pause Screen to toggle it in its entirety`nPress L ingame to toggle the essential display" -Credits "Admentus"
    CreateReduxCheckBox -Name "InventoryEditor" -Text "Inventory Editor"  -Info "Press D-Pad Right in the Pause Screen to open the Inventory Editor"                                                                        -Credits "Admentus"
    CreateReduxCheckBox -Name "GearUnequip"     -Text "Unequip Gear"      -Info "Press D-Pad Up on an equipped sword or shield to unequip it"                                                                               -Credits "Admentus"
    CreateReduxCheckBox -Name "ItemsUnequip"    -Text "Unequip Items"     -Info "Press D-Pad Up on an equipped C Button item to unequip it from the assigned C Button"                                                              -Credits "Admentus"
    CreateReduxCheckBox -Name "ItemsOnB"        -Text "Items on B Button" -Info "Press the A Button on an item in the SELECT ITEM subscreen to equip it on the B button`nSome items are excluded"                           -Credits "Admentus"
    CreateReduxCheckBox -Name "ItemsSwap"       -Text "Swap Items"        -Info "Press D-Pad Down on the Two-Handed Sword, Ocarina or Hookshot to change it to the other version`nYou must have obtained both versions"     -Credits "Admentus"



    # RAINBOW COLORS #

    CreateReduxGroup    -Tag  "Rainbow"       -Text "Rainbow Colors"
    CreateReduxCheckBox -Name "Sword"         -Text "Sword Trail"     -Info "Cycle through random colors for the Sword Trail"     -Credits "Ported from Redux"
    if ($GamePatch.title -notlike "*Dawn & Dusk*") {
        CreateReduxCheckBox -Name "Boomerang" -Text "Boomerang Trail" -Info "Cycle through random colors for the Boomerang Trail" -Credits "Ported from Redux"
        CreateReduxCheckBox -Name "Bombchu"   -Text "Bombchu Trail"   -Info "Cycle through random colors for the Bombchu Trail"   -Credits "Ported from Redux"
    }
    CreateReduxCheckBox -Name "Navi"          -Text "Navi"            -Info "Cycle through random colors for Navi"                -Credits "Ported from Redux"



    # COLORS #

    CreateButtonColorOptions
    if ( IsSimple) { return }
    CreateBoomerangColorOptions
    CreateRupeeColorOptions
    CreateBombchuColorOptions
    CreateHUDColorOptions
    $Last.Half = $False; CreateTextColorOptions; $Redux.Box.TextColors = $Last.Group

    $Redux.Hooks.RupeeIconColors.Add_CheckStateChanged( { EnableElem -Elem $Redux.Colors.RupeesVanilla -Active (!$this.checked) } )
    $Redux.UI.GCScheme.Add_CheckStateChanged(           { EnableForm -Form $Redux.Box.TextColors       -Enable (!$this.checked) } )
    
}



#==============================================================================================================================================================================================
function CreateTabLanguage() {
    
    if ($GamePatch.title -like "*Ocarina*") { CreateLanguageContent }



    # TEXT SPEED #

    CreateReduxGroup -Tag "Text" -Text "Text Speed"
    CreateReduxPanel
    if ($GamePatch.title -like "*Ocarina*") { $max = 4 } else { $max = 2 }
    CreateReduxRadioButton     -Name "Speed1x" -Max $max -SaveTo "Speed" -Text "1x Text Speed" -Info "Leave the dialogue text speed at normal"               -Checked
    CreateReduxRadioButton     -Name "Speed2x" -Max $max -SaveTo "Speed" -Text "2x Text Speed" -Info "Set the dialogue text speed to be twice as fast"       -Credits "Ported from Redux"
    if ($GamePatch.title -like "*Ocarina*") {
        CreateReduxRadioButton -Name "Speed3x" -Max $max -SaveTo "Speed" -Text "3x Text Speed" -Info "Set the dialogue text speed to be three times as fast" -Credits "Ported from Redux"
        CreateReduxRadioButton -Name "Instant" -Max $max -SaveTo "Speed" -Text "Instant Text"  -Info "Most text will be shown instantly"                     -Credits "Admentus"
    }
    


    # DIALOGUE #

    $Redux.Box.Dialogue = CreateReduxGroup -Tag "Text" -Text "Dialogue"
    CreateReduxPanel
    if ($GamePatch.title -like "*Ocarina*") { $max = 4 } elseif ($GamePatch.title -like "*Master of Time*") { $max = 3 } else { $max = 2 }
    CreateReduxRadioButton -Name "Vanilla"     -Max $max -SaveTo "Dialogue" -Checked -Text "Vanilla Text"           -Info "Keep the text as it is"
    if ($GamePatch.title -like "*Ocarina*") {
        CreateReduxRadioButton -Name "Restore" -Max $max -SaveTo "Dialogue"          -Text "Restore Text"           -Info ("Restores the text used from the GC revision and applies grammar and typo fixes`nCorrects some icons in the text and includes the changes from" + ' "Redux Text"') -Credits "Redux"
        CreateReduxRadioButton -Name "Beta"    -Max $max -SaveTo "Dialogue"          -Text "Beta Text"              -Info "Restores the text as was used in the Ura Quest Beta version"                                                                                                       -Credits "ZethN64, Sakura, Frostclaw & Steve(ToCoool)"
    }
    elseif ($GamePatch.title -like "*Master of Time*") {
        CreateReduxRadioButton -Name "MMoT"    -Max $max -SaveTo "Dialogue"          -Text "Malon's Master of Time" -Info "Use the script dialogue from the Malon's Master of Time version"                                                                                                   -Credits "Luna Romana"
    }
    CreateReduxRadioButton -Name "Custom"      -Max $max -SaveTo "Dialogue"          -Text "Custom"                 -Info 'Insert custom dialogue found from "..\Patcher64+ Tool\Files\Games\Ocarina of Time\Custom Text"' -Warning "ROM crashes if the script is not proper`n[!] Won't be applied if the custom script is missing"
    if ($GamePatch.title -like "*Ocarina*") {
        $Last.Row++; $Last.Column = 1
        CreateReduxCheckBox -Name "FemalePronouns"                                   -Text "Female Pronouns"        -Info "Refer to Link as a female character"                                                                                                                               -Credits "Admentus & Mil"
        CreateReduxCheckBox -Name "TypoFixes"                                        -Text "Typo Fixes"             -Info "Include the typo fixes from the Redux script"                                                                                                                      -Credits "Ported from Redux"
        CreateReduxCheckBox -Name "GoldSkulltula"                                    -Text "Gold Skulltula"         -Info "The textbox for obtaining a Gold Skulltula will no longer interrupt the gameplay`nThe English & German scripts also shows the total amount you got so far"         -Credits "Ported from Redux"
    }
    $max = $null



    # OTHER ENGLISH OPTIONS #

    CreateReduxGroup    -Tag  "Text"              -Text "Other English Options"
    CreateReduxCheckBox -Name "Fairy"             -Text "MM Fairy Text"        -Info ("Changes " + '"Bottled Fairy" to "Fairy"' + " as used in Majora's Mask") -Credits "GhostlyDark (ported)"
    if ($GamePatch.options -eq 1) {
        CreateReduxCheckBox -Name "Milk"          -Text "MM Milk Text"         -Info ("Changes " + '"Lon Lon Milk" to "Milk"' + " as used in Majora's Mask")   -Credits "GhostlyDark (ported)"
        CreateReduxCheckBox -Name "KeatonMaskFix" -Text "Keaton Mask Text Fix" -Info 'Fixes the grammatical typo for the "Keaton Mask"'                        -Credits "Redux"
        CreateReduxCheckBox -Name "PauseScreen"   -Text "MM Pause Screen"      -Info "Replaces the Pause Screen textures to be styled like Majora's Mask"      -Credits "CM & GhostlyDark"
    }



    # OTHER GERMAN OPTIONS #

    if ($GamePatch.title -like "*Ocarina*") {
        CreateReduxGroup    -Tag  "Text"        -Text "Other German Options"
        CreateReduxCheckBox -Name "CheckPrompt" -Text "Read Action Prompt" -Info 'Replace the "Lesen" Action Prompt with "Ansehen"'     -Credits "Admentus, GhostlyDark & Ticamus"
        CreateReduxCheckBox -Name "DivePrompt"  -Text "Dive Action Prompt" -Info 'Replace the "Tauchen" Action Prompt with "Abtauchen"' -Credits "Admentus, GhostlyDark & Ticamus"
    }



    # OTHER TEXT OPTIONS #

    CreateReduxGroup    -Tag  "Text"        -Text "Other Text Options"
    if ($GamePatch.title -like "*Master of Time*") { $val = "Nite" } else { $val = "Navi" }
    CreateReduxComboBox -Name "NaviPrompt"  -Text "Navi A Button Prompt" -Items @("Hidden", "Navi")            -Ext "prompt"            -FilePath ($GameFiles.textures + "\Action Prompts\Navi") -Info "Replace the A Button prompt for Navi"                     -Credits "Aegiker & GhostlyDark (texture fix, injects)"
    CreateReduxComboBox -Name "NaviCUp"     -Text "Navi C-Up Prompt"     -Items @("Navi")                      -Ext "cup" -Default $val -FilePath ($GameFiles.textures + "\Action Prompts\Navi") -Info "Replace the C-Up Buttn prompt for Navi`nNot for Japanese" -Credits "GhostlyDark (injects)"
    CreateReduxComboBox -Name "NaviScript"  -Text "Navi Text"            -Items @("Navi", "Tatl", "Tael", "Taya", "Nite") -Default $val                                                          -Info "Change the name for Navi in the dialogue script"          -Credits "Admentus"



    if ($GamePatch.title -like "*Ocarina*") {
        foreach ($i in 0.. ($Files.json.languages.length-1)) { $Redux.Language[$i].Add_CheckedChanged({ UnlockLanguageContent }) }
        UnlockLanguageContent
    }

}



#==============================================================================================================================================================================================
function UnlockLanguageContent() {
    
    # English options
    EnableElem -Elem $Redux.Text.Restore        -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.Beta           -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.FemalePronouns -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.TypoFixes      -Active $Redux.Language[0].Checked
    
    EnableElem -Elem $Redux.Text.KeatonMaskFix  -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.Fairy          -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.Milk           -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.PauseScreen    -Active $Redux.Language[0].Checked

    if (!$Redux.Language[0].Checked -and !$Redux.Text.Vanilla.Checked -and !$Redux.Text.Custom.Checked) { $Redux.Text.Vanilla.Checked = $True }

    # German options
    EnableElem -Elem $Redux.Text.CheckPrompt    -Active $Redux.Language[1].Checked
    EnableElem -Elem $Redux.Text.DivePrompt     -Active $Redux.Language[1].Checked

    # Set max text speed in each language
    foreach ($i in 0.. ($Files.json.languages.length-1)) {
        if ($Redux.Language[$i].checked) {
            if ($Files.json.languages[$i].max_text_speed -eq 1) {
                EnableElem -Elem @($Redux.Text.Speed2x, $Redux.Text.Speed3x) -Active $False
                $Redux.Text.Speed1x.checked = $True
            }
            elseif ($Files.json.languages[$i].max_text_speed -eq 2) {
                EnableElem -Elem $Redux.Text.Speed2x -Active $True
                EnableElem -Elem $Redux.Text.Speed3x -Active $False
                if ($Redux.Text.Speed3x.checked -eq $True) { $Redux.Text.Speed2x.checked = $True }
            }
            else { EnableElem -Elem @($Redux.Text.Speed2x, $Redux.Text.Speed3x) -Active $True }
            EnableElem -Elem @($Redux.Text.Instant, $Redux.Text.GoldSkulltula, $Redux.Text.NaviPrompt, $Redux.Text.NaviCUp, $Redux.Text.NaviScript) -Active ($Files.json.languages[$i].region -ne "J")
        }
    }

}



#==============================================================================================================================================================================================
function CreateTabGraphics() {
    
    # GRAPHICS #

    CreateReduxGroup    -Tag  "Graphics"              -Text "Graphics"                     -Columns 4 -Height 3
    CreateReduxCheckBox -Name "Widescreen"            -Text "16:9 Widescreen (Advanced)"   -Info "Patch the game to be in true 16:9 widescreen with the HUD pushed to the edges"                       -Native -Credits "Widescreen Patch by gamemasterplc, enhanced and ported by GhostlyDark"
    CreateReduxCheckBox -Name "WidescreenAlt"         -Text "16:9 Widescreen (Simplified)" -Info "Apply 16:9 Widescreen adjusted backgrounds and textures (as well as 16:9 Widescreen for the Wii VC)" -Credits "Aspect Ratio Fix by Admentus`n16:9 backgrounds by GhostlyDark, ShadowOne333 & CYB3RTRON" -Link $Redux.Graphics.Widescreen
    CreateReduxCheckBox -Name "ExtendedDraw"          -Text "Extended Draw Distance"       -Info "Increases the game's draw distance for objects`nDoes not work on all objects"                        -Credits "Admentus"
    CreateReduxCheckBox -Name "ForceHiresModel"       -Text "Force Hires Link Model"       -Info "Always use Link's High Resolution Model when Link is too far away"                                   -Credits "GhostlyDark"
    if ($GamePatch.title -like "*Ocarina*") {
        CreateReduxCheckBox -Name "OverworldSkyboxes" -Text "Overworld Skyboxes"           -Info "Use day and night skyboxes for all overworld areas lacking one" -Advanced                            -Credits "Admentus (ported) & BrianMp16 (AR Code)"
    }

    EnableElem -Elem @($Redux.Fixes.PauseScreenDelay, $Redux.Fixes.PauseScreenCrash) -Active (!$Redux.Graphics.Widescreen.Checked)
    $Redux.Graphics.Widescreen.Add_CheckStateChanged({ EnableElem -Elem @($Redux.Fixes.PauseScreenDelay, $Redux.Fixes.PauseScreenCrash) -Active (!$this.Checked) })

    $Last.Column = 1; $Last.Row = 3
    if ($GamePatch.title -notlike "*Master of Time*") {
        $models = LoadModelsList -Category "Child"
        CreateReduxComboBox -Name "ChildModels" -Text "Child Model" -Items (@("Original") + $models) -Default "Original" -Info "Replace the child model used for Link"
    }
    if ($GamePatch.title -notlike "*Dawn & Dusk*") {
        $models = LoadModelsList -Category "Adult"
        CreateReduxComboBox -Name "AdultModels" -Text "Adult Model" -Items (@("Original") + $models) -Default "Original" -Info "Replace the adult model used for Link"
    }

    $info = $models = $null



    # MODELS PREVIEW #

    $Redux.Graphics.ModelPreviews = CreateReduxGroup -Tag "Graphics" -Text "Model Previews"
    $Last.Group.Height = (DPISize 252)

    if ($GamePatch.title -notlike "*Master of Time*") { CreateImageBox -x 20  -y 20 -w 154 -h 220 -Name "ModelsPreviewChild" }
    CreateImageBox -x 210 -y 20 -w 154 -h 220 -Name "ModelsPreviewAdult"
    $global:PreviewToolTip = CreateToolTip
    ChangeModelsSelection
    


    # INTERFACE #

    CreateReduxGroup    -Tag  "UI" -Text "Interface" -Height 4
    $Last.Group.Width = $Redux.Groups[$Redux.Groups.Length-3].Width; $Last.Group.Top = $Redux.Groups[$Redux.Groups.Length-3].Bottom + 5; $Last.Width = 4;
    CreateReduxCheckBox -Name "HUD"              -Text "MM HUD Icons"                                                                                             -Info "Replace the HUD icons with that from Majora's Mask"                                      -Simple   -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "Rupees"           -Text "MM Rupee Icon"                                                                                            -Info "Replace the rupees icon with that from Majora's Mask"                                    -Advanced -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "DungeonKeys"      -Text "MM Key Icon"                                                                                              -Info "Replace the key icon with that from Majora's Mask"                                       -Advanced -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "DungeonIcons"     -Text "MM Dungeon Icons"                                                                                         -Info "Replace the dungeon map icons with those from Majora's Mask"                             -Advanced -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "ButtonPositions"  -Text "MM Button Positions"                                                                                      -Info "Positions the A and B buttons like in Majora's Mask"                                     -Advanced -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "CenterNaviPrompt" -Text "Center Navi Prompt"                                                                                       -Info 'Centers the "Navi" prompt shown in the C-Up button'                                                -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "GCScheme"         -Text "GC Scheme"                                                                                                -Info "Replace and change the textures, dialogue and text colors to match the GameCube's scheme"          -Credits "Admentus, GhostlyDark, ShadowOne333 & Ported from Redux"
    CreateReduxComboBox -Name "BlackBars"        -Text "Black Bars"  -Items @("Enabled", "Disabled for Z-Targeting", "Disabled for Cutscenes", "Always Disabled") -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes" -Credits "Admentus"
    CreateReduxComboBox -Name "ButtonSize"       -Text "HUD Buttons"                                           -FilePath ($Paths.shared + "\Buttons")    -Ext $null -Default "Large"           -Info "Set the size for the HUD buttons"                                     -Credits "GhostlyDark (ported)"
    $path = $Paths.shared + "\Buttons" + "\" + $Redux.UI.ButtonSize.Text.replace(" (default)", "")
    if ($GamePatch.title -like "*Gold Quest*") { $val = "Gold Quest" } else { $val = "Ocarina of Time" }
    CreateReduxComboBox -Name "ButtonStyle"      -Text "HUD Buttons" -Items "Ocarina of Time" -FilePath $path                           -Ext "bin" -Default $val              -Info "Set the style for the HUD buttons"           -Credits "GhostlyDark, Pizza (HD), Djipi, Community, Nerrel, Federelli, AndiiSyn"
    CreateReduxComboBox -Name "Hearts"           -Text "Heart Icons" -Items "Ocarina of Time" -FilePath ($Paths.shared + "\HUD\Hearts") -Ext "bin" -Default $val              -Info "Set the style for the heart icons" -Advanced -Credits "Ported by GhostlyDark & AndiiSyn"
    CreateReduxComboBox -Name "Magic"            -Text "Magic Bar"   -Items "Ocarina of Time" -FilePath ($Paths.shared + "\HUD\Magic")  -Ext "bin" -Default "Ocarina of Time" -Info "Set the style for the magic meter" -Advanced -Credits "GhostlyDark, Pizza, Nerrel (HD), Zeth Alkar"
    
    $path = $null

    

    # HIDE HUD #
    
    CreateReduxGroup    -Tag  "Hide"         -Text "Hide HUD"
    CreateReduxCheckBox -Name "Everything"   -Text "Hide Interface"          -Info "Hide the whole interface"                                     -Credits "Admentus" -Simple
    CreateReduxCheckBox -Name "AButton"      -Text "Hide A Button"           -Info "Hide the A Button"                                            -Credits "Admentus" -Advanced
    CreateReduxCheckBox -Name "BButton"      -Text "Hide B Button"           -Info "Hide the B Button"                                            -Credits "Admentus" -Advanced
    CreateReduxCheckBox -Name "StartButton"  -Text "Hide Start Button"       -Info "Hide the Start Button"                                        -Credits "Admentus" -Advanced
    CreateReduxCheckBox -Name "CUpButton"    -Text "Hide C-Up Button"        -Info "Hide the C-Up Button"                                         -Credits "Admentus" -Advanced
    CreateReduxCheckBox -Name "CLeftButton"  -Text "Hide C-Left Button"      -Info "Hide the C-Left Button"                                       -Credits "Admentus" -Advanced
    CreateReduxCheckBox -Name "CDownButton"  -Text "Hide C-Down Button"      -Info "Hide the C-Down Button"                                       -Credits "Admentus" -Advanced
    CreateReduxCheckBox -Name "CRightButton" -Text "Hide C-Right Button"     -Info "Hide the C-Right Button"                                      -Credits "Admentus" -Advanced
    CreateReduxCheckBox -Name "Hearts"       -Text "Hide Hearts"             -Info "Hide the Hearts display"                                      -Credits "Admentus" -Advanced
    CreateReduxCheckBox -Name "Magic"        -Text "Hide Magic"              -Info "Hide the Magic display"                                       -Credits "Admentus" -Advanced
    CreateReduxCheckBox -Name "Rupees"       -Text "Hide Rupees"             -Info "Hide the the Rupees display"                                  -Credits "Admentus" -Advanced
    CreateReduxCheckBox -Name "DungeonKeys"  -Text "Hide Keys"               -Info "Hide the Keys display shown in several dungeons and areas"    -Credits "Admentus" -Advanced
    CreateReduxCheckBox -Name "Carrots"      -Text "Hide Epona Carrots"      -Info "Hide the Epona Carrots display"                               -Credits "Admentus" -Advanced
    CreateReduxCheckBox -Name "AreaTitle"    -Text "Hide Area Title Card"    -Info "Hide the area title that displays when entering a new area"   -Credits "Admentus" -Advanced
    CreateReduxCheckBox -Name "DungeonTitle" -Text "Hide Dungeon Title Card" -Info "Hide the dungeon title that displays when entering a dungeon" -Credits "Admentus" -Advanced
    CreateReduxCheckBox -Name "Icons"        -Text "Hide Icons"              -Info "Hide the Clock and Score Counter icons display"               -Credits "Admentus" -Advanced
  # CreateReduxCheckBox -Name "Minimaps"     -Text "Hide Minimaps"           -Info "Hide the Minimap that displays in the overworld and dungeons" -Credits "Admentus" -Advanced
    if ($GamePatch.title -notlike "*Master of Time*") { CreateReduxCheckBox -Name "Credits" -Text "Hide Credits" -Info "Hide the credits text during the credits sequence" -Credits "Admentus" }

    

    # STYLES #

    CreateReduxGroup    -Tag  "Styles"        -Text "Styles"         -Columns 4
    if ($GamePatch.title -like "*Gold Quest*") { $val = "Gold Quest" } else { $val = "Regular" }
    CreateReduxComboBox -Name "RegularChests" -Text "Regular Chests" -Info "Use a different style for regular treasure chests"                                           -FilePath ($Paths.shared + "\Chests") -Default $val -Ext "front" -Items "Regular"              -Credits "AndiiSyn & Rando"
    CreateReduxComboBox -Name "BossChests"    -Text "Boss Chests"    -Info "Use a different style for Boss Key treasure chests"                                          -FilePath ($Paths.shared + "\Chests")               -Ext "front" -Items "Boss OoT"             -Credits "AndiiSyn & Rando"
    CreateReduxComboBox -Name "Crates"        -Text "Small Crates"   -Info "Use a different style for small liftable crates"                                             -FilePath ($Paths.shared + "\Crates")               -Ext "bin"   -Items "Regular"              -Credits "Rando"
    CreateReduxComboBox -Name "Pots"          -Text "Pots"           -Info "Use a different style for throwable pots"                                                    -FilePath ($Paths.shared + "\Pots")                 -Ext "bin"   -Items "Regular"              -Credits "Rando"
    CreateReduxComboBox -Name "HairColor"     -Text "Hair Color"     -Info "Use a different hair color style for Link`nOnly for Ocarina of Time or Majora's Mask models" -FilePath ($Paths.shared + "\Hair\Ocarina of Time") -Ext "bin"   -Items @("Default", "Blonde") -Credits "Third M & AndiiSyn"



    # HUD PREVIEWS #

    CreateReduxGroup -Tag "UI" -Text "HUD Previews"
    $Last.Group.Height = (DPISize 140)

    CreateImageBox -x 40  -y 30 -w 90  -h 90 -Name "ButtonPreview";      $Redux.UI.ButtonSize.Add_SelectedIndexChanged( { ShowHUDPreview -IsOoT } );   $Redux.UI.ButtonStyle.Add_SelectedIndexChanged( { ShowHUDPreview -IsOoT } )
    CreateImageBox -x 160 -y 35 -w 40  -h 40 -Name "HeartsPreview";      if (IsAdvanced) { $Redux.UI.Hearts.Add_SelectedIndexChanged(   { ShowHUDPreview -IsOoT } ) }
    CreateImageBox -x 220 -y 35 -w 40  -h 40 -Name "RupeesPreview";      if (IsAdvanced) { $Redux.UI.Rupees.Add_CheckStateChanged(      { ShowHUDPreview -IsOoT } ) }
    CreateImageBox -x 280 -y 35 -w 40  -h 40 -Name "DungeonKeysPreview"; if (IsAdvanced) { $Redux.UI.DungeonKeys.Add_CheckStateChanged( { ShowHUDPreview -IsOoT } ) }
    CreateImageBox -x 140 -y 85 -w 200 -h 40 -Name "MagicPreview";       if (IsAdvanced) { $Redux.UI.Magic.Add_SelectedIndexChanged(    { ShowHUDPreview -IsOoT } ) }
    
    ShowHUDPreview -IsOoT
    if (IsSimple) { $Redux.UI.HUD.Add_CheckStateChanged( { ShowHUDPreview -IsOoT } ) }

}




#==============================================================================================================================================================================================
function CreateTabAudio() {
    
    # SOUNDS / VOICES #

    CreateReduxGroup    -Tag  "Sounds" -Text "Sounds / Voices"
    if ($GamePatch.title -notlike "*Master of Time*") {
        CreateReduxComboBox -Name "ChildVoices" -Text "Child Voice" -Default "Original" -Items @("Original") -FilePath ($GameFiles.binaries + "\Voices Child")   -Info "Replace the voice used for the Child Link Model"    -Credits "`nMajora's Mask: Korey Cryderman (ported) & GhostlyDark (corrected)`nMelee Zelda: Thiago Alcântara 6 & theluigidude2007 (edits)`nAmara: Amara (ripping) & theluigidude2007 (edits)"
    }
    if ($GamePatch.title -notlike "*Dawn & Dusk*") {
        CreateReduxComboBox -Name "AdultVoices" -Text "Adult Voice" -Default "Original" -Items @("Original") -FilePath ($GameFiles.binaries + "\Voices Adult")   -Info "Replace the voice used for the Adult Link Model"    -Credits "`nMajora's Mask: Korey Cryderman (ported) & GhostlyDark (corrected)`nMelee Zelda: Thiago Alcântara 6 & theluigidude2007 (edits)`nAmara: Amara (ripping) & theluigidude2007`nPeach: theluigidude2007"
    }
    CreateReduxComboBox -Name "Instrument"  -Text "Instrument"                      -Items @("Ocarina", "Female Voice", "Whistle", "Harp", "Organ", "Flute") -Info "Replace the sound used for playing the Ocarina of Time" -Credits "Ported from Rando"



    # SFX SOUND EFFECTS #

    $SFX1 = @("Default", "Disabled", "Soft Beep", "Bark", "Bomb Bounce", "Bongo Bongo Low", "Bow Twang", "Business Scrub", "Carrot Refill", "Cluck", "Great Fairy", "Drawbridge Set", "Guay", "Horse Trot", "HP Recover", "Iron Boots", "Moo", "Mweep!", 'Navi "Hey!"', "Navi Random", "Notification", "Pot Shattering", "Ribbit", "Rupee (Silver)", "Switch", "Sword Bonk", "Tambourine", "Timer", "Zelda Gasp (Adult)")
    $SFX2 = @("Default",  "Disabled", "Soft Beep", "Bark", "Business Scrub", "Carrot Refill", "Cluck", "Cockadoodledoo", "Dusk Howl", "Exploding Crate", "Explosion", "Great Fairy", "Guay", "Horse Neigh", "HP Low", "HP Recover", "Ice Shattering", "Moo", "Meweep!", 'Navi "Hello!"', "Notification", "Pot Shattering", "Redead Scream", "Ribbit", "Ruto Giggle", "Skulltula", "Tambourine", "Timer", "Zelda Gasp (Adult)")
    $SFX3 = @("Default", "Disabled", "Soft Beep", "Bark", "Bomb Bounce", "Bongo Bongo High", "Bongo Bongo Low", "Bottle Cork", "Bow Twang", "Bubble Laugh", "Carrot Refill", "Change Item", "Child Pant", "Cluck", "Deku Baba", "Drawbridge Set", "Dusk Howl", "Fanfare (Light)", "Fanfare (Medium)", "Field Shrub", "Flare Dancer Startled",
    'Ganondorf "Teh"', "Gohma Larva Croak", "Gold Skull Token", "Goron Wake", "Guay", "Gunshot", "Hammer Bonk", "Horse Trot", "HP Low", "HP Recover", "Iron Boots", "Iron Knuckle", "Moo", "Mweep!", "Notification", "Phantom Ganon Laugh", "Plant Explode", "Pot Shattering", "Redead Moan", "Ribbit", "Rupee", "Rupee (Silver)", "Ruto Crash",
    "Ruto Lift", "Ruto Thrown", "Scrub Emerge", "Shabom Bounce", "Shabom Pop", "Shellblade", "Skulltula", "Spit Nut", "Switch", "Sword Bonk", 'Talon "Hmm"', "Talon Snore", "Talon WTF", "Tambourine", "Target Enemy", "Target Neutral", "Thunder", "Timer", "Zelda Gasp (Adult)")
    
    CreateReduxGroup    -Tag "SFX" -Text "SFX Sound Effects"   -Simple
    CreateReduxComboBox -Name "LowHP" -Text "Low HP" -Items $SFX2 -Info "Set the sound effect for the low HP beeping" -Credits "Ported from Rando"
    
    CreateReduxGroup    -Tag "SFX" -Text "SFX Sound Effects"   -Advanced
    CreateReduxComboBox -Name "LowHP"      -Text "Low HP"      -Items $SFX1                                                                                                                                   -Info "Set the sound effect for the low HP beeping"                             -Credits "Ported from Rando"
    CreateReduxComboBox -Name "Navi"       -Text "Navi"        -Items $SFX2                                                                                                                                   -Info "Replace the sound used for Navi when she wants to tell something"        -Credits "Ported from Rando"
    CreateReduxComboBox -Name "ZTarget"    -Text "Z-Target"    -Items $SFX2                                                                                                                                   -Info "Replace the sound used for Z-Targeting enemies"                          -Credits "Ported from Rando"
    CreateReduxComboBox -Name "HoverBoots" -Text "Hover Boots" -Items @("Default", "Disabled", "Bark", "Cartoon Fall", "Flare Dancer Laugh", "Mweep!", "Shabom Pop", "Tambourine")                            -Info "Replace the sound used for the Hover Boots"                              -Credits "Ported from Rando" 
    CreateReduxComboBox -Name "Horse"      -Text "Horse Neigh" -Items @("Default", "Disabled", "Armos", "Child Scream", "Great Fairy", "Moo", "Mweep!", "Redead Scream", "Ruto Wiggle", "Stalchild Attack")   -Info "Replace the sound for horses when neighing"                              -Credits "Ported from Rando"
    CreateReduxComboBox -Name "Nightfall"  -Text "Nightfall"   -Items @("Default", "Disabled", "Cockadoodledoo", "Gold Skull Token", "Great Fairy", "Moo", "Mweep!", "Redead Moan", "Talon Snore", "Thunder") -Info "Replace the sound used when Nightfall occurs"                            -Credits "Ported from Rando" 
    CreateReduxComboBox -Name "FileCursor" -Text "File Cursor" -Items $SFX3                                                                                                                                   -Info "Replace the sound used when moving the cursor in the File Select menu"   -Credits "Ported from Rando"
    CreateReduxComboBox -Name "FileSelect" -Text "File Select" -Items $SFX3                                                                                                                                   -Info "Replace the sound used when selecting something in the File Select menu" -Credits "Ported from Rando"
    
    $SFX1 = $SFX2 = $SFX3 = $null



    # MUSIC #

    if ($GamePatch.options -eq 1) { MusicOptions -Default "Great Fairy's Fountain" }
    
}



#==============================================================================================================================================================================================
function CreateTabDifficulty() {
    
    # HERO MODE #

    $items1 = @("1 Monster HP","0.5x Monster HP", "1x Monster HP", "1.5x Monster HP", "2x Monster HP", "2.5x Monster HP", "3x Monster HP", "3.5x Monster HP", "4x Monster HP", "5x Monster HP")
    $items2 = @("1 Mini-Boss HP", "0.5x Mini-Boss HP", "1x Mini-Boss HP", "1.5x Mini-Boss HP", "2x Mini-Boss HP", "2.5x Mini-Boss HP", "3x Mini-Boss HP", "3.5x Mini-Boss HP", "4x Mini-Boss HP", "5x Mini-Boss HP")
    $items3 = @("1 Boss HP", "0.5x Boss HP", "1x Boss HP", "1.5x Boss HP", "2x Boss HP", "2.5x Boss HP", "3x Boss HP", "3.5x Boss HP", "4x Boss HP", "5x Boss HP")

    CreateReduxGroup        -Tag  "Hero" -Text "Hero Mode"
    CreateReduxComboBox     -Name "MonsterHP"         -Text "Monster HP"   -Items $items1 -Default 3                                                        -Info "Set the amount of health for monsters"                                       -Credits "Admentus" -Warning "Half of the enemies are missing"
    CreateReduxComboBox     -Name "MiniBossHP"        -Text "Mini-Boss HP" -Items $items2 -Default 3                                                        -Info "Set the amount of health for elite monsters and mini-bosses"                 -Credits "Admentus" -Warning "Big Octo and Dark Link are missing"
    CreateReduxComboBox     -Name "BossHP"            -Text "Boss HP"      -Items $items3 -Default 3                                                        -Info "Set the amount of health for bosses"                                         -Credits "Admentus & Marcelo20XX"
    CreateReduxComboBox     -Name "Damage"            -Text "Damage"       -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage", "OHKO Mode")        -Info "Set the amount of damage you receive`nOHKO Mode = You die in one hit"        -Credits "Admentus"
    CreateReduxComboBox     -Name "MagicUsage"        -Text "Magic Usage"  -Items @("1x Magic Usage", "2x Magic Usage", "4x Magic Usage", "8x Magic Usage") -Info "Set the amount of times magic is consumed at"                                -Credits "Admentus"
    if ($GamePatch.title -like "*Ocarina*") {
        CreateReduxCheckBox -Name "Arwing"            -Text "Arwing"             -Advanced                                                                  -Info "Replaces the Rock-Lifting Kokiri Kid with an Arwing in Kokiri Forest"        -Credits "Admentus"
        CreateReduxCheckBox -Name "LikeLike"          -Text "Like-Like"          -Advanced                                                                  -Info "Replaces the Rock-Lifting Kokiri Kid with a Like-Like in Kokiri Forest"      -Credits "Admentus" -Link $Redux.Hero.Arwing
        CreateReduxCheckBox -Name "GraveyardKeese"    -Text "Graveyard Keese"                                                                               -Info "Extends the object list for Adult Link so the Keese appear at the Graveyard" -Credits "salvador235"
        CreateReduxCheckBox -Name "LostWoodsOctorok"  -Text "Lost Woods Octorok"                                                                            -Info "Add an Octorok actor in the Lost Woods area which leads to Zora's River"     -Credits "Chez Cousteau"
        CreateReduxCheckBox -Name "HarderChildBosses" -Text "Harder Child Bosses"                                                                           -Info "Replace objects in the Child Dungeon Boss arenas with additional monsters"   -Credits "BilonFullHDemon"
    }
    CreateReduxCheckBox     -Name "NoRecoveryHearts"  -Text "No Recovery Heart Drops"                                                                       -Info "Disable Recovery Hearts from spawning from item drops"                       -Credits "Ported from Rando"
    CreateReduxCheckBox     -Name "NoBottledFairy"    -Text "No Bottled Fairies"                                                                            -Info "Fairies can no longer be put into a bottle"                                  -Credits "Admentus & Three Pendants"
    CreateReduxCheckBox     -Name "NoItemDrops"       -Text "No Item Drops"                                                                                 -Info "Disable all items from spawning"                                             -Credits "Admentus & BilonFullHDemon"
    
    $items1 = $items2= $items3 = $null
    

    
    # RECOVERY #

    CreateReduxGroup   -Tag  "Recovery"    -Text "Recovery" -Height 1.6
    CreateReduxTextBox -Name "Heart"       -Text "Recovery Heart" -Value 16  -Min 0 -Max 320 -Length 3 -Info "Set the amount of HP that Recovery Hearts will replenish`nRecovery Heart drops are removed if set to 0" -Credits "Admentus, Three Pendants & Rando (No Heart Drops)"
    CreateReduxTextBox -Name "Fairy"       -Text "Fairy (Bottle)" -Value 320 -Min 0 -Max 320 -Length 3 -Info "Set the amount of HP that a Bottled Fairy will replenish"                                               -Credits "Admentus & Three Pendants"
    CreateReduxTextBox -Name "FairyRevive" -Text "Fairy (Revive)" -Value 320 -Min 0 -Max 320 -Length 3 -Info "Set the amount of HP that a Bottled Fairy will replenish after Link died"                               -Credits "Admentus & Three Pendants"
    CreateReduxTextBox -Name "Milk"        -Text "Milk"           -Value 80  -Min 0 -Max 320 -Length 3 -Info "Set the amount of HP that Milk will replenish"                                                          -Credits "Admentus & Three Pendants"
    CreateReduxTextBox -Name "RedPotion"   -Text "Red Potion"     -Value 320 -Min 0 -Max 320 -Length 3 -Info "Set the amount of HP that a Red Potion will replenish"                                                  -Credits "Admentus & Three Pendants"

    $Redux.Recovery.HeartLabel       = CreateLabel -X $Redux.Recovery.Heart.Left       -Y ($Redux.Recovery.Heart.Bottom + (DPISize 6))       -Text ("(" + [math]::Round($Redux.Recovery.Heart.text/16, 1) + " Hearts)")       -AddTo $Last.Group
    $Redux.Recovery.FairyLabel       = CreateLabel -X $Redux.Recovery.Fairy.Left       -Y ($Redux.Recovery.Fairy.Bottom + (DPISize 6))       -Text ("(" + [math]::Round($Redux.Recovery.Fairy.text/16, 1) + " Hearts)")       -AddTo $Last.Group
    $Redux.Recovery.FairyReviveLabel = CreateLabel -X $Redux.Recovery.FairyRevive.Left -Y ($Redux.Recovery.FairyRevive.Bottom + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.FairyRevive.text/16, 1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.MilkLabel        = CreateLabel -X $Redux.Recovery.Milk.Left        -Y ($Redux.Recovery.Milk.Bottom + (DPISize 6))        -Text ("(" + [math]::Round($Redux.Recovery.Milk.text/16, 1) + " Hearts)")        -AddTo $Last.Group
    $Redux.Recovery.RedPotionLabel   = CreateLabel -X $Redux.Recovery.RedPotion.Left   -Y ($Redux.Recovery.RedPotion.Bottom + (DPISize 6))   -Text ("(" + [math]::Round($Redux.Recovery.RedPotion.text/16, 1) + " Hearts)")   -AddTo $Last.Group
    $Redux.Recovery.Heart.Add_TextChanged(       { if ($this.text -eq "16") { $Redux.Recovery.HeartLabel.Text       = "(1 Heart)" } else { $Redux.Recovery.HeartLabel.Text       = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )
    $Redux.Recovery.Fairy.Add_TextChanged(       { if ($this.text -eq "16") { $Redux.Recovery.FairyLabel.Text       = "(1 Heart)" } else { $Redux.Recovery.FairyLabel.Text       = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )
    $Redux.Recovery.FairyRevive.Add_TextChanged( { if ($this.text -eq "16") { $Redux.Recovery.FairyReviveLabel.Text = "(1 Heart)" } else { $Redux.Recovery.FairyReviveLabel.Text = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )
    $Redux.Recovery.Milk.Add_TextChanged(        { if ($this.text -eq "16") { $Redux.Recovery.MilkLabel.Text        = "(1 Heart)" } else { $Redux.Recovery.MilkLabel.Text        = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )
    $Redux.Recovery.RedPotion.Add_TextChanged(   { if ($this.text -eq "16") { $Redux.Recovery.RedPotionLabel.Text   = "(1 Heart)" } else { $Redux.Recovery.RedPotionLabel.Text   = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )



    # MINIGAMES #

    if ($GamePatch.title -like "*Dawn & Dusk*") { return }

    CreateReduxGroup    -Tag  "Minigames" -Text "Minigames" -Advanced
    if ($GamePatch.options -eq 1) {
        CreateReduxCheckBox -Name "Dampe"   -Text "Dampe's Digging"                                                                                                       -Info "Dampe's Digging Game is always first try"                           -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "Ocarina" -Text "Skullkid Ocarina"                                                                                                      -Info "You only need to clear the first round to get the Piece of Heart"   -Credits "Ported from Rando"
    }
    CreateReduxCheckBox -Name "Fishing"     -Text "Fishing"                                                                                                               -Info "Fishing is less random and has less demanding requirements"         -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "Bowling"     -Text "Bombchu Bowling"                                                                                                       -Info "Bombchu Bowling prizes now appear in fixed order instead of random" -Credits "Ported from Rando"
    CreateReduxComboBox -Name "Bowling1"    -Text "Bowling Reward #1" -Items ("Piece of Heart", "Bomb Bag", "Purple Rupee", "Bombchus") -Values @("64", "28", "4C", "58") -Info "Set the first reward for the Bombchu Bowling Minigame"              -Credits "Ported from Rando" -Default 1 -Column 1 -Row 2
    CreateReduxComboBox -Name "Bowling2"    -Text "Bowling Reward #2" -Items ("Piece of Heart", "Bomb Bag", "Purple Rupee", "Bombchus") -Values @("64", "28", "4C", "58") -Info "Set the second reward for the Bombchu Bowling Minigame"             -Credits "Ported from Rando" -Default 2
    CreateReduxComboBox -Name "Bowling3"    -Text "Bowling Reward #3" -Items ("Piece of Heart", "Bomb Bag", "Purple Rupee", "Bombchus") -Values @("64", "28", "4C", "58") -Info "Set the third reward for the Bombchu Bowling Minigame"              -Credits "Ported from Rando" -Default 4
    CreateReduxComboBox -Name "Bowling4"    -Text "Bowling Reward #4" -Items ("Piece of Heart", "Bomb Bag", "Purple Rupee", "Bombchus") -Values @("64", "28", "4C", "58") -Info "Set the fourth reward for the Bombchu Bowling Minigame"             -Credits "Ported from Rando" -Default 3
    CreateReduxComboBox -Name "Bowling5"    -Text "Bowling Reward #5" -Items ("Piece of Heart", "Bomb Bag", "Purple Rupee", "Bombchus") -Values @("64", "28", "4C", "58") -Info "Set the fifth reward for the Bombchu Bowling Minigame"              -Credits "Ported from Rando" -Default 3

    if (IsAdvanced) {
        $Redux.Minigames.Bowling.Add_CheckedChanged({ $Redux.Minigames.Bowling1.enabled = $Redux.Minigames.Bowling2.enabled = $Redux.Minigames.Bowling3.enabled = $Redux.Minigames.Bowling4.enabled = $Redux.Minigames.Bowling5.enabled = $this.checked })
        $Redux.Minigames.Bowling1.enabled = $Redux.Minigames.Bowling2.enabled = $Redux.Minigames.Bowling3.enabled = $Redux.Minigames.Bowling4.enabled = $Redux.Minigames.Bowling5.enabled = $Redux.Minigames.Bowling.checked
    }

    CreateReduxGroup    -Tag  "Minigames"       -Text "Minigames" -Simple
    CreateReduxCheckBox -Name "EasierMinigames" -Text "Easier Minigames" -Info "Certain minigames are made easier and faster`n- Dampe's Digging Game is first try always`n- Fishing is less random and has less demanding requirements`n- Bombchu Bowling prizes now appear in fixed order instead of random" -Credits "Ported from Rando"



    # EASY MODE #

    CreateReduxGroup    -Tag  "EasyMode" -Text "Easy Mode"
    CreateReduxCheckbox     -Name "NoShieldSteal"       -Text "No Shield Steal"       -Info "Like-Likes will no longer steal the Deku Shield or Hylian Shield from Link"                      -Credits "Admentus"
    CreateReduxCheckbox     -Name "NoTunicSteal"        -Text "No Tunic Steal"        -Info "Like-Likes will no longer steal the Goron Tunic or Zora Tunic from Link"                         -Credits "GhostlyDark (ported from Redux)"
    if ($GamePatch.options -eq 1) {
        CreateReduxCheckBox -Name "SkipStealthSequence" -Text "Skip Stealth Sequence" -Info "Skip the Castle Courtyard Stealth Sequence and allows you to go straight to the Inner Courtyard" -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "SkipTowerEscape"     -Text "Skip Tower Escape"     -Info "Skip the Ganon's Tower Escape Sequence and allows you to go straight to the Ganon boss fight"    -Credits "Ported from Rando"
    }
    
}


#==============================================================================================================================================================================================
function CreateTabScenes() {

    # MASTER QUEST #

    CreateReduxGroup -Tag "MQ" -Text "Dungeons"
    CreateReduxPanel
    CreateReduxRadioButton -Name "Disable"   -Max 5 -SaveTo "Dungeons" -Text "Vanilla"      -Info "All dungeons remain vanilla" -Checked
    CreateReduxRadioButton -Name "EnableMQ"  -Max 5 -SaveTo "Dungeons" -Text "Master Quest" -Info "Patch in all Master Quest dungeons"                  -Credits "ShadowOne333"
    CreateReduxRadioButton -Name "EnableUra" -Max 5 -SaveTo "Dungeons" -Text "Ura Quest"    -Info "Patch in all Ura (Disk Drive) Master Quest dungeons" -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool) & Admentus"
    CreateReduxRadioButton -Name "Select"    -Max 5 -SaveTo "Dungeons" -Text "Select"       -Info "Select which dungeons you want from which version"   -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), ShadowOne333 & Admentus"
    CreateReduxRadioButton -Name "Randomize" -Max 5 -SaveTo "Dungeons" -Text "Randomize"    -Info "Randomize the amount of dungeons from all versions"  -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), ShadowOne333 & Admentus"



    # MASTER QUEST LOGO #

    CreateReduxGroup -Tag "MQ" -Text "Title Screen Logo"
    CreateReduxPanel
    CreateReduxRadioButton -Name "VanillaLogo"          -Max 4 -SaveTo "Logo" -Text "Vanilla" -Checked     -Info "Keep the original title screen logo"
    CreateReduxRadioButton -Name "MasterQuestLogo"      -Max 4 -SaveTo "Logo" -Text "Master Quest"         -Info "Use the Master Quest title screen logo"            -Credits "ShadowOne333, GhostlyDark & Admentus"
    CreateReduxRadioButton -Name "UraQuestLogo"         -Max 4 -SaveTo "Logo" -Text "Ura Quest"            -Info "Use the Ura Quest title screen logo"               -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), GhostlyDark & Admentus"
    CreateReduxRadioButton -Name "UraQuestSubtitleLogo" -Max 4 -SaveTo "Logo" -Text "Ura Quest + Subtitle" -Info "Use the Ura Quest title screen logo with subtitle" -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), GhostlyDark, Admentus & ShadowOne"



    # MASTER QUEST DUNGEONS #

    $Redux.Box.SelectMQ = CreateReduxGroup -Tag "MQ" -Text "Select - Dungeons"
    CreateReduxComboBox -Name "InsideTheDekuTree"    -Text "Inside the Deku Tree"     -Items @("Vanilla", "Master Quest", "Ura Quest") -NoDefault -Info "Patch Inside the Deku Tree to Master Quest"     -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), ShadowOne333 & Admentus"
    CreateReduxComboBox -Name "DodongosCavern"       -Text "Dodongo's Cavern"         -Items @("Vanilla", "Master Quest", "Ura Quest") -NoDefault -Info "Patch Dodongo's Cavern to Master Quest"         -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), ShadowOne333 & Admentus"
    CreateReduxComboBox -Name "InsideJabuJabusBelly" -Text "Inside Jabu-Jabu's Belly" -Items @("Vanilla", "Master Quest", "Ura Quest") -NoDefault -Info "Patch Inside Jabu-Jabu's Belly to Master Quest" -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), ShadowOne333 & Admentus"
    CreateReduxComboBox -Name "ForestTemple"         -Text "Forest Temple"            -Items @("Vanilla", "Master Quest", "Ura Quest") -NoDefault -Info "Patch Forest Temple to Master Quest"            -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), ShadowOne333 & Admentus"
    CreateReduxComboBox -Name "FireTemple"           -Text "Fire Temple"              -Items @("Vanilla", "Master Quest", "Ura Quest") -NoDefault -Info "Patch Fire Temple to Master Quest"              -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), ShadowOne333 & Admentus"
    CreateReduxComboBox -Name "WaterTemple"          -Text "Water Temple"             -Items @("Vanilla", "Master Quest", "Ura Quest") -NoDefault -Info "Patch Water Temple to Master Quest"             -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), ShadowOne333 & Admentus"
    CreateReduxComboBox -Name "ShadowTemple"         -Text "Shadow Temple"            -Items @("Vanilla", "Master Quest", "Ura Quest") -NoDefault -Info "Patch Shadow Temple to Master Quest"            -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), ShadowOne333 & Admentus"
    CreateReduxComboBox -Name "SpiritTemple"         -Text "Spirit Temple"            -Items @("Vanilla", "Master Quest", "Ura Quest") -NoDefault -Info "Patch Spirit Temple to Master Quest"            -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), ShadowOne333 & Admentus"
    CreateReduxComboBox -Name "IceCavern"            -Text "Ice Cavern"               -Items @("Vanilla", "Master Quest", "Ura Quest") -NoDefault -Info "Patch Ice Cavern to Master Quest"               -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), ShadowOne333 & Admentus"
    CreateReduxComboBox -Name "BottomOfTheWell"      -Text "Bottom of the Well"       -Items @("Vanilla", "Master Quest", "Ura Quest") -NoDefault -Info "Patch Bottom of the Well to Master Quest"       -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), ShadowOne333 & Admentus"
    CreateReduxComboBox -Name "GerudoTrainingGround" -Text "Gerudo Training Ground"   -Items @("Vanilla", "Master Quest", "Ura Quest") -NoDefault -Info "Patch Gerudo Training Ground to Master Quest"   -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), ShadowOne333 & Admentus"
    CreateReduxComboBox -Name "InsideGanonsCastle"   -Text "Inside Ganon's Castle"    -Items @("Vanilla", "Master Quest", "Ura Quest") -NoDefault -Info "Patch Inside Ganon's Castle to Master Quest"    -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), ShadowOne333 & Admentus"



    # VANILLA DUNGEON ADJUSTMENTS #

    $Redux.Box.VanillaDungeons = CreateReduxGroup -Tag "Scenes" -Text "Vanilla Dungeon Adjustements" -Advanced
    CreateReduxCheckBox -Name "DodongosCavernGossipStone" -Text "Dodongo's Cavern Gossip Stone" -Info "Fix the Gossip Stones in Dodongo's Cavern so that a fairy can be spawned from them"                                                  -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "WaterTempleActors"         -Text "Add Water Temple Actors"       -Info "Add several actors in the Water Temple`nUnreachable hookshot spot in room 22, three out of bounds pots, restore two Keese in room 1" -Credits "Chez Cousteau"
    CreateReduxCheckBox -Name "RemoveDisruptiveText"      -Text "Remove Disruptive Text"        -Info "Remove disruptive text from Gerudo Training Ground and early Shadow Temple"                                                          -Credits "Ported from Rando"



    # SCENE ADJUSTMENTS #

    CreateReduxGroup    -Tag  "Scenes"             -Text "Scene Adjustements" -Advanced
    CreateReduxCheckBox -Name "Graves"             -Text "Graveyard Graves"             -Info "The grave holes in Kakariko Graveyard behave as in the Rev 1 revision`nThe edges no longer force Link to grab or jump over them when trying to enter" -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "VisibleGerudoTent"  -Text "Visible Gerudo Tent"          -Info "Make the tent in the Gerudo Valley during the Child era visible`nThe tent was always accessible, just invisible"                                      -Credits "Chez Cousteau" -Warning "Makes the bridge for Child Link broken"
    CreateReduxCheckBox -Name "CorrectTimeDoor"    -Text "Correct Door of Time Coords"  -Info "Fix the positioning of the Temple of Time door, so you can not skip past it"                                                                          -Credits "Chez Cousteau"
    CreateReduxCheckBox -Name "OpenTimeDoor"       -Text "Fix Door of Time Unlock"      -Info "Fix Door of Time not opening on first visit"                                                                                                          -Credits "Rando"
    CreateReduxCheckBox -Name "ChildColossusFairy" -Text "Fix Child Colossus Fairy"     -Info 'Fix "...???" textbox outside Child Colossus Fairy to use the right flag and disappear once the wall is destroyed'                                     -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "CraterFairy"        -Text "Fix Crater Fairy"             -Info 'Remove the "...???" textbox outside the Crater Fairy'                                                                                                 -Credits "Ported from Rando"



    # RANDOMIZE MASTER QUEST DUNGEONS #

    $Redux.Box.RandomizeMQ = CreateReduxGroup -Tag "MQ" -Text "Randomize - Dungeons"
    $Items = @("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12")
    CreateReduxComboBox -Name "Minimum" -Text "Minimum" -Default 1            -Items $Items
    CreateReduxComboBox -Name "Maximum" -Text "Maximum" -Default $Items.Count -Items $Items

    $Redux.MQ.Disable.Add_CheckedChanged({ EnableForm $Redux.Box.VanillaDungeons -Enable $this.Checked })
    EnableForm $Redux.Box.VanillaDungeons -Enable $Redux.MQ.Disable.Checked

    $Redux.MQ.Minimum.Add_SelectedIndexChanged({
        if ($Redux.MQ.Maximum.SelectedIndex -lt $Redux.MQ.Minimum.SelectedIndex) { $Redux.MQ.Maximum.SelectedIndex = $Redux.MQ.Minimum.SelectedIndex }
    })
    $Redux.MQ.Maximum.Add_SelectedIndexChanged({
        if ($Redux.MQ.Maximum.SelectedIndex -lt $Redux.MQ.Minimum.SelectedIndex) { $Redux.MQ.Maximum.SelectedIndex = $Redux.MQ.Minimum.SelectedIndex }
    })
    if ($Redux.MQ.Maximum.SelectedIndex -lt $Redux.MQ.Minimum.SelectedIndex) { $Redux.MQ.Maximum.SelectedIndex = $Redux.MQ.Minimum.SelectedIndex }

    EnableForm -Form $Redux.Box.SelectMQ -Enable $Redux.MQ.Select.Checked
    $Redux.MQ.Select.Add_CheckedChanged({ EnableForm -Form $Redux.Box.SelectMQ -Enable $Redux.MQ.Select.Checked })
    EnableForm -Form $Redux.Box.RandomizeMQ -Enable $Redux.MQ.Randomize.Checked
    $Redux.MQ.Randomize.Add_CheckedChanged({ EnableForm -Form $Redux.Box.RandomizeMQ -Enable $Redux.MQ.Randomize.Checked })

}



#==============================================================================================================================================================================================
function CreateTabColors() {

    # EQUIPMENT COLORS #

    CreateReduxGroup -Tag "Colors" -Text "Equipment Colors"
    $Redux.Colors.Equipment = @()
    $items = @("Kokiri Green", "Goron Red", "Zora Blue"); $postItems = @("Randomized", "Custom"); $Files = ($GameFiles.Textures + "\Tunic"); $Randomize = '"Randomized" fully randomizes the colors each time the patcher is opened'
    if ($GamePatch.title -like "*Gold Quest*") { $items = @("Gold Quest Gold", "Gold Quest Purple", "Gold Quest White") + $items }
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "KokiriTunic" -Column 1 -Row 1 -Text "Kokiri Tunic Color" -Default 1 -Length 230 -Shift 40 -Items $items -PostItems $postItems -FilePath $Files -Info ("Select a color scheme for the Kokiri Tunic`n" + $Randomize) -Credits "Ported from Rando"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "GoronTunic"  -Column 1 -Row 2 -Text "Goron Tunic Color"  -Default 2 -Length 230 -Shift 40 -Items $items -PostItems $postItems -FilePath $Files -Info ("Select a color scheme for the Goron Tunic`n"  + $Randomize) -Credits "Ported from Rando"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "ZoraTunic"   -Column 1 -Row 3 -Text "Zora Tunic Color"   -Default 3 -Length 230 -Shift 40 -Items $items -PostItems $postItems -FilePath $Files -Info ("Select a color scheme for the Zora Tunic`n"   + $Randomize) -Credits "Ported from Rando"
    $Items = @("Silver", "Gold", "Black", "Green", "Blue", "Bronze", "Red", "Sky Blue", "Pink", "Magenta", "Orange", "Lime", "Purple", "Randomized", "Custom")
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "SilverGauntlets"   -Column 4 -Row 1 -Text "Silver Gauntlets Color"    -Default 1 -Length 230 -Shift 40 -Items $Items -Info ("Select a color scheme for the Silver Gauntlets`n" + $Randomize) -Credits "Ported from Rando"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "GoldenGauntlets"   -Column 4 -Row 2 -Text "Golden Gauntlets Color"    -Default 2 -Length 230 -Shift 40 -Items $Items -Info ("Select a color scheme for the Golden Gauntlets`n" + $Randomize) -Credits "Ported from Rando"
    $Items =  @("Red", "Green", "Blue", "Yellow", "Cyan", "Magenta", "Orange", "Gold", "Purple", "Pink", "Randomized", "Custom")
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "MirrorShieldFrame" -Column 4 -Row 3 -Text "Mirror Shield Frame Color" -Default 1 -Length 230 -Shift 40 -Items $Items -Info ("Select a color scheme for the Mirror Shield Frame`n" + $Randomize) -Warning "This option might not work for every custom player model" -Credits "Ported from Rando"
    $items = $null

    # Equipment Colors - Buttons
    $Buttons = @()
    $Buttons += CreateReduxButton -Column 3 -Row 1 -Tag $Buttons.Count -Width 100 -Text "Kokiri Tunic"     -Info "Select the color you want for the Kokiri Tunic"               -Credits "Ported from Rando"
    $Buttons += CreateReduxButton -Column 3 -Row 2 -Tag $Buttons.Count -Width 100 -Text "Goron Tunic"      -Info "Select the color you want for the Goron Tunic"                -Credits "Ported from Rando"
    $Buttons += CreateReduxButton -Column 3 -Row 3 -Tag $Buttons.Count -Width 100 -Text "Zora Tunic"       -Info "Select the color you want for the Zora Tunic"                 -Credits "Ported from Rando"
    $Buttons += CreateReduxButton -Column 6 -Row 1 -Tag $Buttons.Count -Width 100 -Text "Silver Gaunlets"  -Info "Select the color you want for the Silver Gauntlets"           -Credits "Ported from Rando"
    $Buttons += CreateReduxButton -Column 6 -Row 2 -Tag $Buttons.Count -Width 100 -Text "Golden Gauntlets" -Info "Select the color you want for the Golden Gauntlets"           -Credits "Ported from Rando"
    $Buttons += CreateReduxButton -Column 6 -Row 3 -Tag $Buttons.Count -Width 100 -Text "Mirror Shield"    -Info "Select the color you want for the frame of the Mirror Shield" -Credits "Ported from Rando"

    # Equipment Colors - Dialogs
    $Redux.Colors.SetEquipment = @()
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "1E691B" -Name "SetKokiriTunic"       -IsGame -Button $Buttons[0]
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "641400" -Name "SetGoronTunic"        -IsGame -Button $Buttons[1]
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "003C64" -Name "SetZoraTunic"         -IsGame -Button $Buttons[2]
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "FFFFFF" -Name "SetSilverGauntlets"   -IsGame -Button $Buttons[3]
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "FECF0F" -Name "SetGoldenGauntlets"   -IsGame -Button $Buttons[4]
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "D70000" -Name "SetMirrorShieldFrame" -IsGame -Button $Buttons[5]

    # Equipment Colors - Labels
    $Redux.Colors.EquipmentLabels = @()
    for ($i=0; $i -lt $Buttons.length; $i++) {
        $Buttons[$i].Add_Click({ $Redux.Colors.SetEquipment[[uint16]$this.Tag].ShowDialog(); $Redux.Colors.Equipment[[uint16]$this.Tag].Text = "Custom"; $Redux.Colors.EquipmentLabels[[uint16]$this.Tag].BackColor = $Redux.Colors.SetEquipment[[uint16]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetEquipment[[uint16]$this.Tag].Tag] = $Redux.Colors.SetEquipment[[uint16]$this.Tag].Color.Name })
        $Redux.Colors.EquipmentLabels += CreateReduxColoredLabel -Link $Buttons[$i]  -Color $Redux.Colors.SetEquipment[$i].Color
    }

    $Redux.Colors.Equipment[0].Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[0] -Dialog $Redux.Colors.SetEquipment[0] -Label $Redux.Colors.EquipmentLabels[0] })
    SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[0] -Dialog $Redux.Colors.SetEquipment[0] -Label $Redux.Colors.EquipmentLabels[0]
    $Redux.Colors.Equipment[1].Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[1] -Dialog $Redux.Colors.SetEquipment[1] -Label $Redux.Colors.EquipmentLabels[1] })
    SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[1] -Dialog $Redux.Colors.SetEquipment[1] -Label $Redux.Colors.EquipmentLabels[1]
    $Redux.Colors.Equipment[2].Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[2] -Dialog $Redux.Colors.SetEquipment[2] -Label $Redux.Colors.EquipmentLabels[2] })
    SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[2] -Dialog $Redux.Colors.SetEquipment[2] -Label $Redux.Colors.EquipmentLabels[2]

    $Redux.Colors.Equipment[3].Add_SelectedIndexChanged({ SetGauntletsColorsPreset -ComboBox $Redux.Colors.Equipment[3] -Dialog $Redux.Colors.SetEquipment[3] -Label $Redux.Colors.EquipmentLabels[3] })
    SetGauntletsColorsPreset -ComboBox $Redux.Colors.Equipment[5] -Dialog $Redux.Colors.SetEquipment[5] -Label $Redux.Colors.EquipmentLabels[5]
    $Redux.Colors.Equipment[4].Add_SelectedIndexChanged({ SetGauntletsColorsPreset -ComboBox $Redux.Colors.Equipment[4] -Dialog $Redux.Colors.SetEquipment[4] -Label $Redux.Colors.EquipmentLabels[4] })
    SetGauntletsColorsPreset -ComboBox $Redux.Colors.Equipment[4] -Dialog $Redux.Colors.SetEquipment[4] -Label $Redux.Colors.EquipmentLabels[4]

    $Redux.Colors.Equipment[5].Add_SelectedIndexChanged({ SetMirrorShieldFrameColorsPreset -ComboBox $Redux.Colors.Equipment[5] -Dialog $Redux.Colors.SetEquipment[5] -Label $Redux.Colors.EquipmentLabels[5] })
    SetMirrorShieldFrameColorsPreset -ComboBox $Redux.Colors.Equipment[5] -Dialog $Redux.Colors.SetEquipment[5] -Label $Redux.Colors.EquipmentLabels[5]



    # COLORS #

    CreateSpinAttackColorOptions
    CreateSwordTrailColorOptions



    # FAIRY COLORS #

    CreateFairyColorOptions -Name "Navi"

    CreateReduxCheckBox -Name "BetaNavi" -Text "Beta Navi Colors" -Info "Use the Beta colors for Navi" -Column 1 -Row 2
    $Redux.Colors.BetaNavi.Add_CheckedChanged({ EnableElem -Elem $Redux.Colors.Fairy -Active (!$this.checked) })
    EnableElem -Elem $Redux.Colors.Fairy -Active (!$Redux.Colors.BetaNavi.Checked)



    # RUPEE ICON COLOR #

    if ($GamePatch.title -like "*Gold Quest*") { $preset = 5; $color = "FFFF00" } else { $preset = 1; $color = "C8FF64" }
    CreateRupeeVanillaColorOptions -Preset $preset -Color $color
    $preset = $color = $null



    # MISC COLORS #

    CreateReduxGroup -Tag "Colors" -Text "Misc Colors"

  # CreateReduxCheckBox -Name "BoomerangTrail"    -Text "Silver Boomerang Trail" -Info "Turn the Boomerang Trail into silver"                 -Credits "AndiiSyn"
    CreateReduxCheckBox -Name "PauseScreenColors" -Text "MM Pause Screen Colors" -Info "Use the Pause Screen color scheme from Majora's Mask" -Credits "Garo-Mastah"

}



#==============================================================================================================================================================================================
function CreateTabEquipment() {
    
    # EQUIPMENT #

    CreateReduxGroup    -Tag  "Equipment"           -Text "Equipment Adjustments"
    CreateReduxCheckBox -Name "UnsheathSword"       -Text "Unsheath Sword"              -Info "The sword is unsheathed first before immediately swinging it"                                  -Credits "Admentus"
    CreateReduxCheckBox -Name "FireproofDekuShield" -Text "Fireproof Deku Shield"       -Info "The Deku Shield turns into an fireproof shield, which will not burn up anymore"                -Credits "Admentus (ported) & Three Pendants (ROM patch)"
    CreateReduxCheckBox -Name "HerosBow"            -Text "Hero's Bow"                  -Info "Replace the Fairy Bow icon and text with the Hero's Bow"                                       -Credits "GhostlyDark (ported textures) & Admentus (dialogue)"
    CreateReduxCheckBox -Name "Hookshot"            -Text "Termina Hookshot"            -Info "Replace the Hyrule Hookshot icon with the Termina Hookshot"                                    -Credits "GhostlyDark (ported textures)"
    CreateReduxCheckBox -Name "GoronBracelet"       -Text "Keep Goron's Bracelet Color" -Info "Prevent grayscale on Goron's Bracelet, as Adult Link isn't able to push big blocks without it" -Credits "Ported from Redux"
    
    CreateReduxGroup    -Tag  "Equipment" -Text "Swords and Shields"
    CreateReduxComboBox -Name "KokiriSword"   -Text "Kokiri Sword"  -Items @("Kokiri Sword")  -FilePath ($GameFiles.Textures + "\Equipment\Kokiri Sword")  -Ext @("icon", "bin")   -Info "Select an alternative for the appearence of the Kokiri Sword"  -Credits "Admentus & GhostlyDark (injects) & CYB3RTR0N (beta icon)"
    CreateReduxComboBox -Name "MasterSword"   -Text "Master Sword"  -Items @("Master Sword")  -FilePath ($GameFiles.Textures + "\Equipment\Master Sword")  -Ext @("icon", "bin")   -Info "Select an alternative for the appearence of the Master Sword"  -Credits "Admentus & GhostlyDark (injects) & CYB3RTR0N (beta icon)"
    CreateReduxComboBox -Name "DekuShield"    -Text "Deku Shield"   -Items @("Deku Shield")   -FilePath ($GameFiles.Textures + "\Equipment\Deku Shield")   -Ext @("icon", "front") -Info "Select an alternative for the appearence of the Deku Shield"   -Credits "Admentus & GhostlyDark (injects) & ZombieBrainySnack (textures)" -Column 1 -Row 2
    CreateReduxComboBox -Name "HylianShield"  -Text "Hylian Shield" -Items @("Hylian Shield") -FilePath ($GameFiles.Textures + "\Equipment\Hylian Shield") -Ext @("icon", "bin")   -Info "Select an alternative for the appearence of the Hylian Shield" -Credits "Admentus & GhostlyDark (injects), CYB3RTR0N (icons) & sanguinetti (Beta / Red Shield textures)"
    CreateReduxComboBox -Name "MirrorShield"  -Text "Mirror Shield" -Items @("Mirror Shield") -FilePath ($GameFiles.Textures + "\Equipment\Mirror Shield") -Ext @("icon", "bin")   -Info "Select an alternative for the appearence of the Mirror Shield" -Credits "Admentus & GhostlyDark (injects)"



    # HITBOX #

    CreateReduxGroup  -Tag  "Hitbox" -Text "Sliders" -Height 4.2
    if ($GamePatch.title -like "*Gold Quest*") { $val = 104 } else { $val = 26 }
    CreateReduxSlider -Name "KokiriSword"       -Column 1 -Row 1 -Default 3000  -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Kokiri Sword"    -Info "Set the length of the hitbox of the Kokiri Sword"                   -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "MasterSword"       -Column 3 -Row 1 -Default 4000  -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Master Sword"    -Info "Set the length of the hitbox of the Master Sword"                   -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "GiantsKnife"       -Column 5 -Row 1 -Default 5500  -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Giant's Knife"   -Info "Set the length of the hitbox of the Giant's Knife / Biggoron Sword" -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "BrokenGiantsKnife" -Column 1 -Row 2 -Default 1500  -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Broken Knife"    -Info "Set the length of the hitbox of the Broken Giant's Knife"           -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "MegatonHammer"     -Column 3 -Row 2 -Default 2500  -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Megaton Hammer"  -Info "Set the length of the hitbox of the Megaton Hammer"                 -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "ShieldRecoil"      -Column 5 -Row 2 -Default 4552  -Min 0   -Max 8248 -Freq 512 -Small 256 -Large 512 -Text "Shield Recoil"   -Info "Set the pushback distance when getting hit while shielding"         -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxSlider -Name "Hookshot"          -Column 1 -Row 3 -Default 13    -Min 0   -Max 255  -Freq 16  -Small 8   -Large 16  -Text "Hookshot Length" -Info "Set the length of the Hookshot"                                     -Credits "AndiiSyn"
    CreateReduxSlider -Name "Longshot"          -Column 3 -Row 3 -Default $val  -Min 0   -Max 255  -Freq 16  -Small 8   -Large 16  -Text "Longshot Length" -Info "Set the length of the Longshot"                                     -Credits "AndiiSyn"



    # EQUIPMENT PREVIEWS #

    if (IsSimple) { return }

    CreateReduxGroup -Tag "Equipment" -Text "Equipment Previews"
    $Last.Group.Height = (DPISize 140)

    CreateImageBox -x 40  -y 30 -w 80 -h 80  -Name "DekuShieldIconPreview"
    CreateImageBox -x 160 -y 10 -w 80 -h 120 -Name "DekuShieldPreview";      $Redux.Equipment.DekuShield.Add_SelectedIndexChanged(   { ShowEquipmentPreview } )
    CreateImageBox -x 320 -y 30 -w 80 -h 80  -Name "HylianShieldIconPreview"
    CreateImageBox -x 440 -y 10 -w 80 -h 120 -Name "HylianShieldPreview";    $Redux.Equipment.HylianShield.Add_SelectedIndexChanged( { ShowEquipmentPreview } )
    CreateImageBox -x 600 -y 30 -w 80 -h 80  -Name "MirrorShieldIconPreview"
    CreateImageBox -x 720 -y 10 -w 80 -h 120 -Name "MirrorShieldPreview";    $Redux.Equipment.MirrorShield.Add_SelectedIndexChanged( { ShowEquipmentPreview } )
    CreateImageBox -x 840 -y 30 -w 80 -h 80  -Name "KokiriSwordIconPreview"; $Redux.Equipment.KokiriSword.Add_SelectedIndexChanged(  { ShowEquipmentPreview } )
    CreateImageBox -x 960 -y 30 -w 80 -h 80  -Name "MasterSwordIconPreview"; $Redux.Equipment.MasterSword.Add_SelectedIndexChanged(  { ShowEquipmentPreview } )
    ShowEquipmentPreview

    
     # STARTING UPGRADES #

    CreateReduxGroup    -Tag  "Save"          -Text "Starting Upgrades" -Advanced
    CreateReduxComboBox -Name "DekuSticks"    -Text "Deku Sticks"     -Items ("Standard", "Big", "Biggest")                                         -Info "Set the starting capacity upgrade level for the Deku Sticks"
    CreateReduxComboBox -Name "DekuNuts"      -Text "Deku Nuts"       -Items ("Standard", "Big", "Biggest")                                         -Info "Set the starting capacity upgrade level for the Deku Nuts"
    CreateReduxComboBox -Name "BulletBag"     -Text "Bullet Seed Bag" -Items ("Standard", "Big", "Biggest")                                         -Info "Set the starting capacity upgrade level for the Bullet Seed Bag"
    CreateReduxComboBox -Name "Quiver"        -Text "Quiver"          -Items ("Standard", "Big", "Biggest")                                         -Info "Set the starting capacity upgrade level for the Quiver"
    CreateReduxComboBox -Name "BombBag"       -Text "Bomb Bag"        -Items ("Standard", "Big", "Biggest")                                         -Info "Set the starting capacity upgrade level for the Bomb Bag"
    CreateReduxComboBox -Name "Strength"      -Text "Strength"        -Items ("None", "Goron's Bracelet", "Silver Gauntlets", "Golden Gauntlets")   -Info "Set the starting capacity upgrade level for the Bracelet / Gauntlets"
    CreateReduxComboBox -Name "Scale"         -Text "Scale"           -Items ("None", "Silver Scale", "Golden Scale")                               -Info "Set the starting capacity upgrade level for the Scale"
    CreateReduxComboBox -Name "Wallet"        -Text "Wallet"          -Items ("Base Wallet", "Adult's Wallet", "Giant's Wallet", "Tycoon's Wallet") -Info "Set the starting capacity upgrade level for the Wallet" -Warning 'The "Tycoon Wallet" is unused and has issues'

    if ($GamePatch.title -like "*Gold Quest*") { $val = 2 } else { $val = 3 }
    CreateReduxTextBox  -Name "Hearts"        -Text "Hearts" -Value $val -Min 1 -Max 20 -Info "Start a new save file with the chosen amount of hearts"
    CreateReduxCheckBox -Name "DoubleDefense" -Text "Double Defense"                    -Info "Start a new save file with the double defense upgrade"
    CreateReduxCheckBox -Name "Magic"         -Text "Magic"                             -Info "Start a new save file with the magic meter"
    CreateReduxCheckBox -Name "DoubleMagic"   -Text "Double Magic"                      -Info "Start a new save file with the double magic upgrade"



    # STARTING QUEST #

    CreateReduxGroup    -Tag  "Save"            -Text "Starting Quest Items" -Advanced
    CreateReduxCheckBox -Name "KokiriEmerald"   -Text "Kokiri Emerald"           -Info "Start a new save file with Kokiri Emerald"
    CreateReduxCheckBox -Name "GoronRuby"       -Text "Goron Ruby"               -Info "Start a new save file with Goron Ruby"
    CreateReduxCheckBox -Name "ZoraSapphire"    -Text "Zora Sapphire"            -Info "Start a new save file with Zora Sapphire"
    CreateReduxCheckBox -Name "ForestMedallion" -Text "Forest Medallion"         -Info "Start a new save file with the Forest Medallion"
    CreateReduxCheckBox -Name "FireMedallion"   -Text "Fire Medallion"           -Info "Start a new save file with the Fire Medallion"
    CreateReduxCheckBox -Name "WaterMedallion"  -Text "Water Medallion"          -Info "Start a new save file with the Water Medallion"
    CreateReduxCheckBox -Name "ShadowMedallion" -Text "Shadow Medallion"         -Info "Start a new save file with the Shadow Medallion"
    CreateReduxCheckBox -Name "SpiritMedallion" -Text "Spirit Medallion"         -Info "Start a new save file with the Spirit Medallion"
    CreateReduxCheckBox -Name "LightMedallion"  -Text "Light Medallion"          -Info "Start a new save file with the Light Medallion"
    CreateReduxCheckBox -Name "GerudoCard"      -Text "Gerudo Card"              -Info "Start a new save file with the Gerudo Card"
    CreateReduxCheckBox -Name "StoneOfAgony"    -Text "Stone of Agony"           -Info "Start a new save file with the Stone of Agony"
    CreateReduxTextBox  -Name "GoldSkulltulas"  -Text "Gold Skulltulas" -Max 100 -Info "Start a new save file with the chosen amount of Gold Skulltulas"
    


    # STARTING DEBUG #

    CreateReduxGroup    -Tag  "Save"           -Text "Starting Debug Items" -Advanced
    CreateReduxCheckBox -Name "NoDungeonItems" -Text "No Dungeon Items" -Info "Starting a new debug save file no longer grants the Dungeon Map, Compass and Boss Key for dungeons"
    CreateReduxCheckBox -Name "NoDungeonKeys"  -Text "No Dungeon Keys"  -Info "Starting a new debug save file no longer grants any small keys for dungeons"
    CreateReduxCheckBox -Name "NoQuestStatus"  -Text "No Quest Status"  -Info "Starting a new debug save file no longer grants any items from the Quest Status subscreen"
    CreateReduxCheckBox -Name "NoItems"        -Text "No Inventory"     -Info "Starting a new debug save file no longer grants any items from the Select Item subscreen"
    CreateReduxCheckBox -Name "NoEquipment"    -Text "No Equipment"     -Info "Starting a new debug save file no longer grants any items from the Equipment subscreen"
    CreateReduxCheckBox -Name "NoUpgrades"     -Text "No Equipment"     -Info "Starting a new debug save file no longer grants any upgrades from the Equipment subscreen"



    # UNLOCK CHILD RESTRICTIONS #

    if ($GamePatch.title -notlike "*Master of Time*") {
        CreateReduxGroup    -Tag  "Unlock" -Text "Unlock Child Restrictions"
        CreateReduxCheckBox -Name "Tunics"        -Text "Unlock Tunics"        -Info "Child Link is able to use the Goron Tunic and Zora Tunic`nSince you might want to walk around in style as well when you are young`nThe dialogue script will be adjusted to reflect this (only for English)" -Credits "GhostlyDark"
        CreateReduxCheckBox -Name "MasterSword"   -Text "Unlock Master Sword"  -Info "Child Link is able to use the Master Sword`nThe Master Sword does twice as much damage as the Kokiri Sword"                                          -Credits "GhostlyDark"
        CreateReduxCheckBox -Name "GiantsKnife"   -Text "Unlock Giant's Knife" -Info "Child Link is able to use the Giant's Knife / Biggoron Sword`nThe Giant's Knife / Biggoron Sword does four times as much damage as the Kokiri Sword" -Credits "GhostlyDark" -Warning "The Giant's Knife / Biggoron Sword appears as if Link if thrusting the sword through the ground"
        CreateReduxCheckBox -Name "MirrorShield"  -Text "Unlock Mirror Shield" -Info "Child Link is able to use the Mirror Shield"                                                                                                         -Credits "GhostlyDark" -Warning "The Mirror Shield appears as invisible but can still reflect magic or sunlight"
        CreateReduxCheckBox -Name "Boots"         -Text "Unlock Boots"         -Info "Child Link is able to use the Iron Boots and Hover Boots"                                                                                            -Credits "GhostlyDark" -Warning "The Iron and Hover Boots appears as the Kokiri Boots"
        CreateReduxCheckBox -Name "Gauntlets"     -Text "Unlock Gauntlets"     -Info "Child Link is able to use the Silver and Golden Gauntlets"                                                                                           -Credits "Admentus (ROM) & Aegiker (GameShark)"
        CreateReduxComboBox -Name "MegatonHammer" -Text "Unlock Hammer"        -Info "Child Link is able to use the Megaton Hammer" -Items @("Disabled", "Unlock Only", "Show Only", "Unlock and Show")                                    -Credits "GhostlyDark" -Warning "The Megaton Hammer appears as invisible on custom models"
    }


    # UNLOCK ADULT RESTRICTIONS #

    if ($GamePatch.title -notlike "*Dawn & Dusk*") {
        CreateReduxGroup    -Tag  "Unlock" -Text "Unlock Adult Restrictions"
        CreateReduxCheckBox -Name "KokiriSword"    -Text "Unlock Kokiri Sword" -Info "Adult Link is able to use the Kokiri Sword`nThe Kokiri Sword does half as much damage as the Master Sword" -Credits "GhostlyDark"
        CreateReduxCheckBox -Name "DekuShield"     -Text "Unlock Deku Shield"  -Info "Adult Link is able to use the Deku Shield"                                                                 -Credits "GhostlyDark" -Warning "The Deku Shield appears as invisible but can still be burned up by fire"
        CreateReduxCheckBox -Name "FairySlingshot" -Text "Unlock Slingshot"    -Info "Adult Link is able to use the Fairy Slingshot"                                                             -Credits "GhostlyDark" -Warning "The Fairy Slingshot appears as the Fairy Bow"
        CreateReduxCheckBox -Name "Boomerang"      -Text "Unlock Boomerang"    -Info "Adult Link is able to use the Boomerang"                                                                   -Credits "GhostlyDark" -Warning "The Boomerang appears as invisible"
        CreateReduxCheckBox -Name "DekuSticks"     -Text "Unlock Deku Sticks"  -Info "Adult Link is able to use the Deku Sticks"                                                                 -Credits "GhostlyDark"
        CreateReduxCheckBox -Name "CrawlHole"      -Text "Unlock Crawl Hole"   -Info "Adult Link can now crawl through holes"                                                  -Advanced -Native -Credits "Admentus"
    }



    if (IsSimple) { return }
    
    # STARTING EQUIPMENT #

    CreateReduxGroup    -Tag  "Save"          -Text "Starting Equipment"
    CreateReduxCheckBox -Name "KokiriSword"   -Text "Kokiri Sword"   -Info "Start a new save file with the Kokiri Sword"
    CreateReduxCheckBox -Name "MasterSword"   -Text "Master Sword"   -Info "Start a new save file with the Master Sword"
    CreateReduxCheckBox -Name "GiantsKnife"   -Text "Giant's Knife"  -Info "Start a new save file with the Giant's Knife"
    CreateReduxCheckBox -Name "BiggoronSword" -Text "Biggoron Sword" -Info "Start a new save file with the Biggoron Sword instead of the Giant's Knife" -Link $Redux.Save.GiantsKnife
    CreateReduxCheckBox -Name "DekuShield"    -Text "Deku Shield"    -Info "Start a new save file with the Deku Shield"
    CreateReduxCheckBox -Name "HylianShield"  -Text "Hylian Shield"  -Info "Start a new save file with the Hylian Shield"
    CreateReduxCheckBox -Name "MirrorShield"  -Text "Mirror Shield"  -Info "Start a new save file with the Mirror Shield"
    CreateReduxCheckBox -Name "GoronTunic"    -Text "Goron Tunic"    -Info "Start a new save file with the Goron Tunic"
    CreateReduxCheckBox -Name "ZoraTunic"     -Text "Zora Tunic"     -Info "Start a new save file with the Zora Tunic"
    CreateReduxCheckBox -Name "IronBoots"     -Text "Iron Boots"     -Info "Start a new save file with the Iron Boots"
    CreateReduxCheckBox -Name "HoverBoots"    -Text "Hover Boots"    -Info "Start a new save file with the Hover Boots"



    # STARTING ITEMS #

    CreateReduxGroup    -Tag  "Save"              -Text "Starting Items"
    CreateReduxCheckBox -Name "DekuStick"         -Text "Deku Stick"          -Info "Start a new save file with Deku Sticks"
    CreateReduxCheckBox -Name "DekuNut"           -Text "Deku Nut"            -Info "Start a new save file with Deku Nuts"
    CreateReduxCheckBox -Name "Bomb"              -Text "Bomb"                -Info "Start a new save file with Bombs"
    CreateReduxCheckBox -Name "FairyBow"          -Text "Fairy Bow"           -Info "Start a new save file with the Fairy Bow"
    CreateReduxCheckBox -Name "FireArrow"         -Text "Fire Arrow"          -Info "Start a new save file with the Fire Arrow"
    CreateReduxCheckBox -Name "DinsFire"          -Text "Din's Fire"          -Info "Start a new save file with Din's Fire"

    CreateReduxCheckBox -Name "FairySlingshot"    -Text "Fairy Slingshot"     -Info "Start a new save file with the Fairy Slingshot"
    CreateReduxCheckBox -Name "FairyOcarina"      -Text "Fairy Ocarina"       -Info "Start a new save file with the Fairy Ocarina"
    CreateReduxCheckBox -Name "Bombchu"           -Text "Bombchu"             -Info "Start a new save file with Bombchus"
    CreateReduxCheckBox -Name "Hookshot"          -Text "Hookshot"            -Info "Start a new save file with the Hookshot"
    CreateReduxCheckBox -Name "IceArrow"          -Text "Ice Arrow"           -Info "Start a new save file with the Ice Arrow"
    CreateReduxCheckBox -Name "FaroresWind"       -Text "Farore's Wind"       -Info "Start a new save file with Farore's Wind"

    CreateReduxCheckBox -Name "Boomerang"         -Text "Boomerang"           -Info "Start a new save file with Boomerang"
    CreateReduxCheckBox -Name "LensOfTruth"       -Text "Lens of Truth"       -Info "Start a new save file with Lens of Truth"
    CreateReduxCheckBox -Name "MagicBean"         -Text "Magic Bean"          -Info "Start a new save file with Magic Beans"
    CreateReduxCheckBox -Name "MegatonHammer"     -Text "Megaton Hammer"      -Info "Start a new save file with the Megaton Hammer"
    CreateReduxCheckBox -Name "LightArrow"        -Text "Light Arrow"         -Info "Start a new save file with the Light Arrow"
    CreateReduxCheckBox -Name "NayrusLove"        -Text "Nayru's Love"        -Info "Start a new save file with Nayru's Love"

    CreateReduxCheckBox -Name "Bottle1"           -Text "Empty Bottle #1"     -Info "Start a new save file with the first empty bottle"
    CreateReduxCheckBox -Name "Bottle2"           -Text "Empty Bottle #2"     -Info "Start a new save file with the second empty bottle"
    CreateReduxCheckBox -Name "Bottle3"           -Text "Empty Bottle #3"     -Info "Start a new save file with the third empty bottle"
    CreateReduxCheckBox -Name "Bottle4"           -Text "Empty Bottle #4"     -Info "Start a new save file with the fourth empty bottle"

    $Last.Row++; $Last.Column = 1
    CreateReduxComboBox -Name "TradeSequenceItem" -Text "Trade Sequence Item" -Info "Start a new save file with a Trade Sequence Item" -Items @("Empty", "Pocket Egg", "Pocket Cucco", "Cojiro", "Odd Mushroom", "Odd Potion", "Poacher's Saw", "Broken Goron's Sword", "Prescription", "Eyeball Frog", "World's Finest Eye Drops", "Claim Check")
    CreateReduxComboBox -Name "Mask"              -Text "Quest Item / Mask"   -Info "Start a new save file with a  Quest Item or Mask" -Items @("Empty", "Weird Egg", "Pocket Egg", "Zelda's Letter", "Keaton Mask", "Skull Mask", "Spooky Mask", "Bunny Hood", "Goron Mask", "Zora Mask", "Gerudo Mask", "Mask of Truth", "SOLD OUT")
    CreateReduxCheckBox -Name "OcarinaOfTime"     -Text "Ocarina of Time"     -Info "Start a new save file with the Ocarina of Time`nThis item replaces the Fairy Ocarina" -Link $Redux.Save.FairyOcarina
    CreateReduxCheckBox -Name "LongShot"          -Text "Longshot"            -Info "Start a new save file with the Longshot`nThis item replaces the Hookshot"             -Link $Redux.Save.Hookshot



    # STARTING SONGS #

    CreateReduxGroup    -Tag  "Save"             -Text "Starting Songs"
    CreateReduxCheckBox -Name "ZeldasLullaby"    -Text "Zelda's Lullaby"    -Info "Start a new save file with Zelda's Lullaby"
    CreateReduxCheckBox -Name "EponasSong"       -Text "Epona's Song"       -Info "Start a new save file with Epona's Song"
    CreateReduxCheckBox -Name "SariasSong"       -Text "Saria's Song"       -Info "Start a new save file with Saria's Song"
    CreateReduxCheckBox -Name "SunsSong"         -Text "Sun's Song"         -Info "Start a new save file with the Sun's Song"
    CreateReduxCheckBox -Name "SongOfTime"       -Text "Song of Time"       -Info "Start a new save file with the Song of Time"
    CreateReduxCheckBox -Name "SongOfStorms"     -Text "Song of Storms"     -Info "Start a new save file with the Song of Storms"

    CreateReduxCheckBox -Name "MinuetOfForest"   -Text "Minuet of Forest"   -Info "Start a new save file with the Minuet of Forest"
    CreateReduxCheckBox -Name "BoleroOfFire"     -Text "Bolero of Fire"     -Info "Start a new save file with the Bolero of Fire"
    CreateReduxCheckBox -Name "SerenadeOfWater"  -Text "Serenade of Water"  -Info "Start a new save file with the Serenade of Water"
    CreateReduxCheckBox -Name "RequiemOfSpirit"  -Text "Requiem of Spirit"  -Info "Start a new save file with the Requiem of Spirit"
    CreateReduxCheckBox -Name "NocturneOfShadow" -Text "Nocturne of Shadow" -Info "Start a new save file with the Nocturne of Shadow"
    CreateReduxCheckBox -Name "PreludeOfLight"   -Text "Prelude of Light"   -Info "Start a new save file with the Prelude of Light"

}



#==============================================================================================================================================================================================
function CreateTabCapacity() {
    
    # CAPACITY SELECTION #

    CreateReduxGroup    -Tag  "Capacity"     -Text "Capacity Selection"
    CreateReduxCheckBox -Name "EnableAmmo"   -Text "Change Ammo Capacity"       -Info "Enable changing the capacity values for ammo"
    CreateReduxCheckBox -Name "EnableWallet" -Text "Change Wallet Capacity"     -Info "Enable changing the capacity values for the wallets"
    CreateReduxCheckBox -Name "EnableDrops"  -Text "Change Item Drops Quantity" -Info "Enable changing the amount which an item drop provides"



    # AMMO CAPACITY #

    $Redux.Box.Ammo = CreateReduxGroup -Tag "Capacity" -Text "Ammo Capacity Selection"
    if ($GamePatch.title -like "*Master of Time*") { $val = 25 } else { $val = 30 }
    CreateReduxTextBox -Name "Quiver1"      -Text "Quiver (1)"      -Value 30   -Info "Set the capacity for the Quiver (Base)"           -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver2"      -Text "Quiver (2)"      -Value 40   -Info "Set the capacity for the Quiver (Upgrade 1)"      -Credits "GhostlyDark"
    if ($GamePatch.title -like "*Master of Time*") { $val = 99 } else { $val = 50 }
    CreateReduxTextBox -Name "Quiver3"      -Text "Quiver (3)"      -Value 50   -Info "Set the capacity for the Quiver (Upgrade 2)"      -Credits "GhostlyDark"
    if ($GamePatch.title -like "*Ocarina*") {
        CreateReduxTextBox -Name "BombBag1" -Text "Bomb Bag (1)"    -Value 20   -Info "Set the capacity for the Bomb Bag (Base)"         -Credits "GhostlyDark" -Min 20 -Warning "The minimum value has to be 20 or higher in order to be changed`n[!] A few values are excluded to prevent issues and will automatically be set to the next possible value"
    }
    else {
        if ($GamePatch.title -like "*Gold Quest*") { $val = 10 } elseif ($GamePatch.title -like "*Master of Time*") { $val = 15 } else { $val = 20 }
        CreateReduxTextBox -Name "BombBag1" -Text "Bomb Bag (1)"    -Value $val -Info "Set the capacity for the Bomb Bag (Base)"         -Credits "GhostlyDark"
    }
    CreateReduxTextBox -Name "BombBag2"     -Text "Bomb Bag (2)"    -Value 30   -Info "Set the capacity for the Bomb Bag (Upgrade 1)"    -Credits "GhostlyDark"
    if ($GamePatch.title -like "*Gold Quest*") { $val = 50 } elseif ($GamePatch.title -like "*Master of Time*") { $val = 99 } else { $val = 40 }
    CreateReduxTextBox -Name "BombBag3"     -Text "Bomb Bag (3)"    -Value $val -Info "Set the capacity for the Bomb Bag (Upgrade 2)"    -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BulletBag1"   -Text "Bullet Bag (1)"  -Value 30   -Info "Set the capacity for the Bullet Bag (Base)"       -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BulletBag2"   -Text "Bullet Bag (2)"  -Value 40   -Info "Set the capacity for the Bullet Bag (Upgrade 1)"  -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BulletBag3"   -Text "Bullet Bag (3)"  -Value 50   -Info "Set the capacity for the Bullet Bag (Upgrade 2)"  -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuSticks1"  -Text "Deku Sticks (1)" -Value 10   -Info "Set the capacity for the Deku Sticks (Base)"      -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuSticks2"  -Text "Deku Sticks (2)" -Value 20   -Info "Set the capacity for the Deku Sticks (Upgrade 1)" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuSticks3"  -Text "Deku Sticks (3)" -Value 30   -Info "Set the capacity for the Deku Sticks (Upgrade 2)" -Credits "GhostlyDark"
    if ($GamePatch.title -like "*Master of Time*") { $val = 15 } else { $val = 20 }
    CreateReduxTextBox -Name "DekuNuts1"    -Text "Deku Nuts (1)"   -Value $val -Info "Set the capacity for the Deku Nuts (Base)"        -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuNuts2"    -Text "Deku Nuts (2)"   -Value 30   -Info "Set the capacity for the Deku Nuts (Upgrade 1)"   -Credits "GhostlyDark"
    if ($GamePatch.title -like "*Master of Time*") { $val = 99 } else { $val = 40 }
    CreateReduxTextBox -Name "DekuNuts3"    -Text "Deku Nuts (3)"   -Value $val -Info "Set the capacity for the Deku Nuts (Upgrade 2)"   -Credits "GhostlyDark"



    # WALLET CAPACITY #

    $Redux.Box.Wallet = CreateReduxGroup -Tag "Capacity" -Text "Wallet Capacity Selection"
    CreateReduxTextBox -Name "Wallet1" -Length 4 -Text "Wallet (1)" -Value 99   -Info "Set the capacity for the Wallet (Base)"      -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet2" -Length 4 -Text "Wallet (2)" -Value 200  -Info "Set the capacity for the Wallet (Upgrade 1)" -Credits "GhostlyDark"
    if ($GamePatch.title -like "*Gold Quest*") { $val = 999 } else { $val = 500 }
    CreateReduxTextBox -Name "Wallet3" -Length 4 -Text "Wallet (3)" -Value $val -Info "Set the capacity for the Wallet (Upgrade 2)" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet4" -Length 4 -Text "Wallet (4)" -Value $val -Info "Set the capacity for the Wallet (Upgrade 3)" -Credits "GhostlyDark" -Warning "This wallet is not obtained through regular gameplay" -Advanced

    $val = $null



    # ITEM DROPS QUANTITY #

    $Redux.Box.Drops = CreateReduxGroup -Tag "Capacity" -Text "Item Drops Quantity Selection"
    CreateReduxTextBox -Name "Arrows1x"         -Text "Arrows (Single)"     -Value 5   -Info "Set the recovery quantity for picking up or buying Single Arrows"  -Credits "Admentus" -Row 1 -Column 1
    CreateReduxTextBox -Name "Arrows2x"         -Text "Arrows (Double)"     -Value 10  -Info "Set the recovery quantity for buying Double Arrows"                -Credits "Admentus"
    CreateReduxTextBox -Name "Arrows3x"         -Text "Arrows (Triple)"     -Value 30  -Info "Set the recovery quantity for picking up or buying Triple Arrows"  -Credits "Admentus"
    CreateReduxTextBox -Name "BulletSeeds"      -Text "Bullet Seeds"        -Value 5   -Info "Set the recovery quantity for picking up Bullet Seeds"             -Credits "Admentus"
    CreateReduxTextBox -Name "BulletSeedsShop"  -Text "Bullet Seeds (Shop)" -Value 30  -Info "Set the recovery quantity for buying Bullet Seeds"                 -Credits "Admentus"
    CreateReduxTextBox -Name "DekuSticks"       -Text "Deku Sticks"         -Value 1   -Info "Set the recovery quantity for picking up Deku Sticks"              -Credits "Admentus"
    CreateReduxTextBox -Name "Bombs1x"          -Text "Bombs (5)"           -Value 5   -Info "Set the recovery quantity for picking up or buying Bombs (5)"      -Credits "Admentus" -Row 2 -Column 1
    CreateReduxTextBox -Name "Bombs2x"          -Text "Bombs (10)"          -Value 10  -Info "Set the recovery quantity for buying Bombs (10)"                   -Credits "Admentus"
    CreateReduxTextBox -Name "Bombs3x"          -Text "Bombs (15)"          -Value 15  -Info "Set the recovery quantity for buying Bombs (15)"                   -Credits "Admentus"
    CreateReduxTextBox -Name "Bombs4x"          -Text "Bombs (20)"          -Value 20  -Info "Set the recovery quantity for buying Bombs (20)"                   -Credits "Admentus"
    CreateReduxTextBox -Name "DekuNuts1x"       -Text "Deku Nuts (5)"       -Value 5   -Info "Set the recovery quantity for pickung up or buying Deku Nuts (5)"  -Credits "Admentus"
    CreateReduxTextBox -Name "DekuNuts2x"       -Text "Deku Nuts (10)"      -Value 10  -Info "Set the recovery quantity for picking up or buying Deku Nuts (10)" -Credits "Admentus"

    if ($GamePatch.title -like "*Master of Time*") { $b = 2; $r = 5 } else { $b = 5; $r = 20 }
    CreateReduxTextBox -Name "RupeeG" -Length 4 -Text "Rupee (Green)"       -Value 1   -Info "Set the recovery quantity for picking up Green Rupees"             -Credits "Admentus" -Row 3 -Column 1
    CreateReduxTextBox -Name "RupeeB" -Length 4 -Text "Rupee (Blue)"        -Value $b  -Info "Set the recovery quantity for picking up Blue Rupees"              -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeR" -Length 4 -Text "Rupee (Red)"         -Value $r  -Info "Set the recovery quantity for picking up Red Rupees"               -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeP" -Length 4 -Text "Rupee (Purple)"      -Value 50  -Info "Set the recovery quantity for picking up Purple Rupees"            -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeO" -Length 4 -Text "Rupee (Gold)"        -Value 200 -Info "Set the recovery quantity for picking up Gold Rupees"              -Credits "Admentus"
    $b = $r = $null

    EnableForm -Form $Redux.Box.Ammo -Enable $Redux.Capacity.EnableAmmo.Checked
    $Redux.Capacity.EnableAmmo.Add_CheckStateChanged({ EnableForm -Form $Redux.Box.Ammo -Enable $Redux.Capacity.EnableAmmo.Checked })
    EnableForm -Form $Redux.Box.Wallet -Enable $Redux.Capacity.EnableWallet.Checked
    $Redux.Capacity.EnableWallet.Add_CheckStateChanged({ EnableForm -Form $Redux.Box.Wallet -Enable $Redux.Capacity.EnableWallet.Checked })
    EnableForm -Form $Redux.Box.Drops -Enable $Redux.Capacity.EnableDrops.Checked
    $Redux.Capacity.EnableDrops.Add_CheckStateChanged({ EnableForm -Form $Redux.Box.Drops -Enable $Redux.Capacity.EnableDrops.Checked })

    $Redux.Capacity.BombBag1.Add_TextChanged({
        if ($this.Text -eq "30") {
            $cursorPos = $this.SelectionStart
            $this.Text = $this.Text = "31"
            $this.SelectionStart = $cursorPos - 1
            $this.SelectionLength = 0
        }
    })

}



#==============================================================================================================================================================================================
function CreateTabAnimations() {
    
    if ($GamePatch.title -like "*Ocarina*") {
        # SKIP CUTSCENES #

        CreateReduxGroup    -Tag  "Skip"             -Text "Skip Cutscenes"         -Advanced
        CreateReduxCheckBox -Name "OpeningCutscene"  -Text "Opening Cutscene"       -Info "Skip the introduction cutscene, so you can start playing immediately"            -Credits "Ported from Better OoT"
        CreateReduxCheckBox -Name "AllMedallions"    -Text "All Medallions"         -Info "Cutscene for all medallions never triggers when leaving Shadow or Spirit Temple" -Credits "Ported from Better OoT"
        CreateReduxCheckBox -Name "DaruniaDance"     -Text "Darunia Dance"          -Info "Darunia will not dance"                                                          -Credits "Ported from Better OoT"
        CreateReduxCheckBox -Name "ZeldaEscape"      -Text "Zelda's Escape"         -Info "Skip the sequence where Zelda is escaping from Hyrule Castle"                    -Credits "Ported from Better OoT"
        CreateReduxCheckBox -Name "DungeonOutro"     -Text "Dungeon Outro"          -Info "Skip the sequence after clearing a dungeon"                                      -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "LightArrow"       -Text "Light Arrow"            -Info "Skip the sequence where Link obtains the Light Arrow"                            -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "RegularSongs"     -Text "Regular Songs"          -Info "Skip the cutscenes for learning regular songs"                                   -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "WarpSongs"        -Text "Warp Songs"             -Info "Skip the cutscenes for learning warp songs"                                      -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "RoyalTomb"        -Text "Royal Tomb"             -Info "Skip the destruction scene of the Royal Tomb entrance"                           -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "ChamberOfSages"   -Text "Chamber of Sages"       -Info "Skip the Chamber of Sages after each temple"                                     -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "JabuJabu"         -Text "Jabu-Jabu"              -Info "Skip the sequence where the Jabu-Jabu swallows Link"                             -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "GanonTower"       -Text "Ganon's Tower"          -Info "Skip the collapse of Ganon's Tower"                                              -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "DekuSeedBag"      -Text "Deku Seed Bag"          -Info "Skip the sequence after obtaining the Deku Seed Bag upgrade in the Lost Woods"   -Credits "Ported from Rando"
        


        # SPEEDUP CUTSCENES #


        CreateReduxGroup    -Tag  "Speedup"          -Text "Speedup Cutscenes"  -Advanced
        CreateReduxCheckBox -Name "OpeningChests"    -Text "Opening Chests"    -Info "Make all chest opening animations fast by kicking them open"                 -Credits "Ported from Better OoT"
        CreateReduxCheckBox -Name "KakarikoGate"     -Text "Kakariko Gate"     -Info "Speedup the sequences where the Kakariko Gate to Death Mountain Trail opens" -Credits "Ported from Redux"
        CreateReduxCheckBox -Name "KingZora"         -Text "King Zora"         -Info "King Zora moves quickly"                                                     -Credits "Ported from Better OoT"
        CreateReduxCheckBox -Name "OwlFlights"       -Text "Owl Flights"       -Info "Speedup the Owls Flights from Death Mountain Trial and Lake Hylia"           -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "EponaRace"        -Text "Epona Race"        -Info "The Epona race with Ingo starts faster"                                      -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "EponaEscape"      -Text "Epona Escape"      -Info "The Epona escape sequence after you won the races with Ingo"                 -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "HorsebackArchery" -Text "Horseback Archery" -Info "The Horseback Archery mini starts and ends faster"                           -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "DoorOfTime"       -Text "Door of Time"      -Info "The Door of Time in the Temple of Time opens much faster"                    -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "DrainingTheWell"  -Text "Draining the Well" -Info "The well in Kakariko Village drains much faster"                             -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "Bosses"           -Text "Bosses"            -Info "Speedup sequences related to some dungeon bosses"                            -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "RainbowBridge"    -Text "Rainbow Bridge"    -Info "Speedup the sequence where the Rainbow Bridge appears"                       -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "FairyOcarina"     -Text "Fairy Ocarina"     -Info "Speedup the sequence where Link obtains the Fairy Ocarina"                   -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "GanonTrials"      -Text "Ganon's Trials"    -Info "Skip the completion sequence of the Ganon's Castle trials"                   -Credits "Ported from Rando"



        # Restore CUTSCENES #

        CreateReduxGroup    -Tag  "Restore"          -Text "Restore Cutscenes"
        CreateReduxCheckBox -Name "OpeningCutscene"  -Text "Opening Cutscene"       -Info "Restore the beta introduction cutscene" -Link $Redux.Skip.OpeningCutscene        -Credits "Admentus (ROM) & CloudModding (GameShark)"
    }



    # ANIMATIONS #

    $weapons = "`n`nAffected weapons:`n- Giant's Knife`n- Giant's Knife (Broken)`n- Biggoron Sword`n- Deku Stick`n- Megaton Hammer"

    CreateReduxGroup    -Tag  "Animation"        -Text "Link Animations"
    CreateReduxCheckBox -Name "Feminine"         -Text "Feminine Animations"    -Info "Use feminine animations for Link`nThis applies to both models`nIt works best with the Aria model"    -Credits "GhostlyDark (ported) & AriaHiro64 (model)"
    CreateReduxCheckBox -Name "WeaponIdle"       -Text "2-handed Weapon Idle"   -Info ("Restore the beta animation when idly holding a two-handed weapon" + $weapons)                       -Credits "Admentus"
    CreateReduxCheckBox -Name "WeaponCrouch"     -Text "2-handed Weapon Crouch" -Info ("Restore the beta animation when crouching with a two-handed weapon" + $weapons)                     -Credits "Admentus"
    CreateReduxCheckBox -Name "WeaponAttack"     -Text "2-handed Weapon Attack" -Info ("Restore the beta animation when attacking with a two-handed weapon" + $weapons)                     -Credits "Admentus"
    CreateReduxCheckBox -Name "HoldShieldOut"    -Text "Hold Shield Out"        -Info "Restore the beta animation for Link to always holds his shield out even when his sword is sheathed"  -Credits "Admentus"
    CreateReduxCheckBox -Name "BombBag"          -Text "Bomb Bag"               -Info "Restore the beta animation for the bomb bag"                                                         -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxCheckBox -Name "BackflipAttack"   -Text "Backflip Jump Attack"   -Info "Restore the beta animation to turn the Jump Attack into a Backflip Jump Attack"                      -Credits "Admentus"
    CreateReduxCheckBox -Name "FrontflipAttack"  -Text "Frontflip Jump Attack"  -Info "Restore the beta animation to turn the Jump Attack into a Frontflip Jump Attack"                     -Credits "Admentus" -Link $Redux.Animation.BackflipAttack
    CreateReduxCheckBox -Name "FrontflipJump"    -Text "Frontflip Jump"         -Info "Replace the jumps with frontflip jumps"                                                              -Credits "SoulofDeity"
    CreateReduxCheckBox -Name "SomarsaultJump"   -Text "Somarsault Jump"        -Info "Replace the jumps with somarsault jumps"                                                             -Credits "SoulofDeity" -Link $Redux.Animation.FrontflipJump
    CreateReduxCheckBox -Name "SideBackflip"     -Text "Side Backflip"          -Info "Replace the backflip jump with side hop jumps"                                                       -Credits "Username0713"

    $weapons = $null

}