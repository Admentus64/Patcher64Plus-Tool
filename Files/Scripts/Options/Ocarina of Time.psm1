function PatchOptions() {
    
    # GRAPHICS #

    if (IsChecked $Redux.Graphics.Widescreen)       { ApplyPatch -Patch "Decompressed\Optional\widescreen.ppf"      }
    if (IsChecked $Redux.Graphics.PointFiltering)   { ApplyPatch -Patch "Decompressed\Optional\point_filtering.ppf" }
    


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
    if (IsChecked $Redux.Graphics.HideEquipment)        { ApplyPatch -Patch "Decompressed\Optional\hide_equipment.ppf"      }



    # DIFFICULTY #

    if (IsChecked $Redux.Hero.HarderChildBosses)        { ApplyPatch -Patch "Decompressed\Optional\harder_child_bosses.ppf" }
    


    # MM PAUSE SCREEN #

    if (IsChecked $Redux.Text.PauseScreen)              { ApplyPatch -Patch "Decompressed\Optional\mm_pause_screen.ppf" }
    
}



#==============================================================================================================================================================================================
function ByteOptions() {
    
    # GAMEPLAY #

    if (IsChecked $Redux.Gameplay.FasterBlockPushing) {
        ChangeBytes -Offset "DD2B87" -Values "80";          ChangeBytes -Offset "DD2D27" -Values "03" # Block Speed, Delay
        ChangeBytes -Offset "DD9683" -Values "80";          ChangeBytes -Offset "DD981F" -Values "03" # Milk Crate Speed, Delay
        ChangeBytes -Offset "CE1BD0" -Values "40 80 00 00"; ChangeBytes -Offset "CE0F0F" -Values "03" # Amy Puzzle Speed, Delay
        ChangeBytes -Offset "C77CA8" -Values "40 80 00 00"; ChangeBytes -Offset "C770C3" -Values "01" # Fire Block Speed, Delay
        ChangeBytes -Offset "CC5DBF" -Values "01";          ChangeBytes -Offset "DBCF73" -Values "01" # Forest Basement Puzzle Delay / spirit Cobra Mirror Delay
        ChangeBytes -Offset "DBA233" -Values "19";          ChangeBytes -Offset "DBA3A7" -Values "00" # Truth Spinner Speed, Delay
    }

    if (IsChecked $Redux.Gameplay.EasierMinigames) {
        ChangeBytes -Offset "CC4024" -Values "00 00 00 00"                                                                                                         # Dampe's Digging Game
        ChangeBytes -Offset "DBF428" -Values "0C 10 07 7D 3C 01 42 82 44 81 40 00 44 98 90 00 E6 52"                                                               # Easier Fishing
        ChangeBytes -Offset "DBF484" -Values "00 00 00 00"; ChangeBytes -Offset "DBF4A8" -Values "00 00 00 00"                                                     # Easier Fishing
        ChangeBytes -Offset "DCBEAB" -Values "48";          ChangeBytes -Offset "DCBF27" -Values "48"                                                              # Adult Fish size requirement
        ChangeBytes -Offset "DCBF33" -Values "30";          ChangeBytes -Offset "DCBF9F" -Values "30"                                                              # Child Fish size requirement
        ChangeBytes -Offset "E2E698" -Values "80 AA E2 64"; ChangeBytes -Offset "E2E6A0" -Values "80 AA E2 4C"; ChangeBytes -Offset "E2D440" -Values "24 19 00 00" # Fixed Bombchu Bowling item order
    }

    if (IsChecked $Redux.Gameplay.Medallions)               { ChangeBytes -Offset "E2B454" -Values "80 EA 00 A7 24 01 00 3F 31 4A 00 3F 00 00 00 00"                 }
    if (IsChecked $Redux.Gameplay.RutoNeverDisappears)      { ChangeBytes -Offset "D01EA3" -Values "00"                                                              }
    if (IsChecked $Redux.Gameplay.AlwaysMoveKingZora)       { ChangeBytes -Offset "E55BB0" -Values "85 CE 8C 3C"; ChangeBytes -Offset "E55BB4" -Values "84 4F 0E DA" }
    if (IsChecked $Redux.Gameplay.ReturnChild)              { ChangeBytes -Offset "CB6844" -Values "35";          ChangeBytes -Offset "253C0E2" -Values "03"         }
    if (IsChecked $Redux.Gameplay.DistantZTargeting)        { ChangeBytes -Offset "A987AC" -Values "00 00 00 00"                                                     }
    if (IsChecked $Redux.Gameplay.ManualJump)               { ChangeBytes -Offset "BD78C0" -Values "04 C1";       ChangeBytes -Offset "BD78E3" -Values "01"          }
    if (IsChecked $Redux.Gameplay.NoKillFlash)              { ChangeBytes -Offset "B11C33" -Values "00"                                                              }
    if (IsChecked $Redux.Gameplay.NoShieldRecoil)           { ChangeBytes -Offset "BD416C" -Values "24 00"                                                           }
    if (IsChecked $Redux.Gameplay.RunWhileShielding)        { ChangeBytes -Offset "BD7DA0" -Values "10 00 00 55"; ChangeBytes -Offset "BD01D4" -Values "00 00 00 00" }
    if (IsChecked $Redux.Gameplay.PushbackAttackingWalls)   { ChangeBytes -Offset "BDEAE0" -Values "26 24 00 00 24 85 00 00"                                         }
    if (IsChecked $Redux.Gameplay.SpawnLinksHouse)          { ChangeBytes -Offset "B06332" -Values "00 BB"                                                           }
    if (IsChecked $Redux.Gameplay.AllowWarpSongs)           { ChangeBytes -Offset "B6D3D2" -Values "00";          ChangeBytes -Offset "B6D42A" -Values "00"          }
    if (IsChecked $Redux.Gameplay.AllowFaroreWind)          { ChangeBytes -Offset "B6D3D3" -Values "00";          ChangeBytes -Offset "B6D42B" -Values "00"          }



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

    if (IsChecked $Redux.Restore.CowNoseRing) { ChangeBytes -Offset "EF3E68" -Values "00 00" }
    


    # OTHER #

    if (IsChecked $Redux.Fixes.TimeDoor) {
        ChangeBytes -Offset "25540C6" -Values "FF FC"; ChangeBytes -Offset "2554226" -Values "FF FC"; ChangeBytes -Offset "255429A" -Values "FF FC"; ChangeBytes -Offset "2554326" -Values "FF FC"; ChangeBytes -Offset "2554446" -Values "FF FC"; ChangeBytes -Offset "25544CE" -Values "FF FC"
        ChangeBytes -Offset "255458E" -Values "FF FC"; ChangeBytes -Offset "255463E" -Values "FF FC"; ChangeBytes -Offset "25546EE" -Values "FF FC"; ChangeBytes -Offset "25547A2" -Values "FF FC"; ChangeBytes -Offset "2554862" -Values "FF FC"; ChangeBytes -Offset "2554902" -Values "FF FC"
    }

    if (IsChecked $Redux.Fixes.NaviTarget) {
        $offset = SearchBytes -Start "2ADE000" -End "2BEAA20" -Values "61 00 06 00 05 00 00 3C 24 01 11 FD A8 01 4D FB"; ChangeBytes -Offset $offset -Values "7E" # Spirit Temple
        ChangeBytes -Offset "283B14B" -Values "5C FA F3 FD AC"       # Shadow Temple
        ChangeBytes -Offset "236C059" -Values "4B FD 31 00 1E 00 16" # Fire Temple
        ChangeBytes -Offset "2C1906D" -Values "18 00 00 00 00"       # Ice Cavern
    }

    if (IsChecked $Redux.Fixes.AddWaterTempleActors) {
        $offset = SearchBytes -Start "2634000" -End "263AFB0" -Values "01 CC 01 79"; ChangeBytes -Offset $offset -Values "03 5C" # 263507C
        $offset = AddToOffset -Hex $offset -Add "10";                                ChangeBytes -Offset $offset -Values "03 5C" # 263508C
        $offset = AddToOffset -Hex $offset -Add "10";                                ChangeBytes -Offset $offset -Values "03 5C" # 263509C: Three out of bounds pots
        ChangeBytes -Offset "25CE08F" -Values "51";                ChangeBytes -Offset "25C7221" -Values "0B";          ChangeBytes -Offset "25C7231" -Values "0B" # Unreachable hookshot spot in room 22
        ChangeBytes -Offset "25CE092" -Values "00";                ChangeBytes -Offset "25CE082" -Values "00";          ChangeBytes -Offset "25CE055" -Values "0D" # Restore two keese in room 1
        ChangeBytes -Offset "25CE07A" -Values "FE 39 03 0C FE 51"; ChangeBytes -Offset "25CE08A" -Values "00 4A 03 0C"
    }

    if (IsChecked $Redux.Fixes.AddLostWoodsOctorok) {
        ChangeBytes -Offset "2150C95" -Values "07 E1" # Child
        ChangeBytes -Offset "2157031" -Values "0C"; ChangeBytes -Offset "215706F" -Values "07"; ChangeBytes -Offset "21570F1" -Values "07"; ChangeBytes -Offset "215A031" -Values "0C"; ChangeBytes -Offset "215A06F" -Values "07"; ChangeBytes -Offset "215A151" -Values "07" # Child
        ChangeBytes -Offset "2163031" -Values "0C"; ChangeBytes -Offset "216306F" -Values "07"; ChangeBytes -Offset "2163151" -Values "07"; ChangeBytes -Offset "2168031" -Values "0C"; ChangeBytes -Offset "216806F" -Values "07"; ChangeBytes -Offset "2168191" -Values "07" # Child
        ChangeBytes -Offset "216E031" -Values "0C"; ChangeBytes -Offset "216E06F" -Values "07"; ChangeBytes -Offset "216E0F1" -Values "07"; ChangeBytes -Offset "2171031" -Values "0C"; ChangeBytes -Offset "217106F" -Values "07"; ChangeBytes -Offset "2171121" -Values "07" # Child
        ChangeBytes -Offset "2178031" -Values "0C"; ChangeBytes -Offset "217806F" -Values "07"; ChangeBytes -Offset "2178141" -Values "07"; ChangeBytes -Offset "217C031" -Values "0C"; ChangeBytes -Offset "217C06F" -Values "07"; ChangeBytes -Offset "217C131" -Values "07" # Adult
        ChangeBytes -Offset "217F031" -Values "0C"; ChangeBytes -Offset "217F06F" -Values "07"; ChangeBytes -Offset "217F161" -Values "07"; ChangeBytes -Offset "2182031" -Values "0C"; ChangeBytes -Offset "218206F" -Values "07"; ChangeBytes -Offset "21820F1" -Values "07" # Adult
    }

    if (IsChecked $Redux.Fixes.PauseScreenDelay)      { ChangeBytes -Offset "B15DD0" -Values "00 00 00 00"              } # Pause Screen Anti-Aliasing
    if (IsChecked $Redux.Fixes.PauseScreenCrash)      { ChangeBytes -Offset "B12947" -Values "03"                       } # Pause Screen Delay Speed
    if (IsChecked $Redux.Fixes.Graves)                { ChangeBytes -Offset "202039D" -Values "20"; ChangeBytes -Offset "202043C" -Values "24" } 
    if (IsChecked $Redux.Other.VisibleGerudoTent)     { ChangeBytes -Offset "D215CB"  -Values "11"                      }
    if (IsChecked $Redux.Fixes.PoacherSaw)            { ChangeBytes -Offset "AE72CC"  -Values "00 00 00 00"             }
    if (IsChecked $Redux.Fixes.Boomerang)             { ChangeBytes -Offset "F0F718"  -Values "FC 41 C7 FF FF FF FE 38" }
    if (IsChecked $Redux.Fixes.FortressMinimap)       { CopyBytes   -Offset "96E068"  -Length "D48" -Start "974600"     }
    if (IsChecked $Redux.Fixes.SpiritTempleMirrors)   { ChangeBytes -Offset "0E45678" -Values "00 00"; ChangeBytes -Offset "0E4567B" -Values "00"  }
    

    # OTHER #

    if ( (IsIndex -Elem $Redux.Other.MapSelect -Text "Translate Only") -or (IsIndex $Redux.Other.MapSelect -Text "Translate and Enable") ) { ExportAndPatch -Path "map_select" -Offset "B9FD90" -Length "EC0" }
    if ( (IsIndex -Elem $Redux.Other.MapSelect -Text "Enable Only")    -or (IsIndex $Redux.Other.MapSelect -Text "Translate and Enable") ) {
        ChangeBytes -Offset "A94994" -Values "00 00 00 00 AE 08 00 14 34 84 B9 2C 8E 02 00 18 24 0B 00 00 AC 8B 00 00"
        ChangeBytes -Offset "B67395" -Values "B9 E4 00 00 BA 11 60 80 80 09 C0 80 80 37 20 80 80 1C 14 80 80 1C 14 80 80 1C 08"
    }

    if (IsChecked $Redux.Other.RemoveOwls) {
        ChangeBytes -Offset "1FE30CF" -Values "00";    ChangeBytes -Offset "1FE30DF" -Values "00";    ChangeBytes -Offset "1FE30EE" -Values "00 00"; ChangeBytes -Offset "1FE30FE" -Values "00 00"
        ChangeBytes -Offset "205909E" -Values "00 00"; ChangeBytes -Offset "21630CE" -Values "00 00"; ChangeBytes -Offset "217F0DE" -Values "00 00"; ChangeBytes -Offset "21A008E" -Values "00 00"; ChangeBytes -Offset "220F073" -Values "00"
    }

    if (IsChecked $Redux.Other.RemoveNaviPrompts)    { ChangeBytes -Offset "DF8B84" -Values "00 00 00 00" }
    if (IsChecked $Redux.Other.DefaultZTargeting)    { ChangeBytes -Offset "B71E6D" -Values "01" }
    if (IsChecked $Redux.Other.InstantClaimCheck)    { ChangeBytes -Offset "ED4470" -Values "00 00 00 00"; ChangeBytes -Offset "ED4498" -Values "00 00 00 00" }
    if (IsChecked $Redux.Other.ItemSelect)           { ExportAndPatch -Path "inventory_editor" -Offset "BCBF64" -Length "C8" }
    if (IsChecked $Redux.Other.DiskDrive)            { ChangeBytes -Offset "BAF1F1" -Values "26"; ChangeBytes -Offset "E6D83B" -Values "04" }

    if ( (IsIndex -Elem $Redux.Other.SkipIntro -Text "Skip Logo")         -or (IsIndex -Elem $Redux.Other.SkipIntro -Text "Skip Logo and Title Screen") )   { ChangeBytes -Offset "B9DAAC" -Values "00 00 00 00" }
    if ( (IsIndex -Elem $Redux.Other.SkipIntro -Text "Skip Title Screen") -or (IsIndex -Elem $Redux.Other.SkipIntro -Text "Skip Logo and Title Screen") )   { ChangeBytes -Offset "B17237" -Values "30" }
    


    # GRAPHICS #

    if (IsChecked $Redux.Graphics.WidescreenAlt) {
        # 16:9 Widescreen
        if ($IsWiiVC ) { ChangeBytes -Offset "B08038" -Values "3C 07 3F E3" }

        # 16:9 Textures
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

    if (IsChecked $Redux.UI.DungeonIcons) {
        PatchBytes -Offset "85F980"  -Shared -Patch "HUD\Dungeon Map Link\Majora's Mask.bin"
        PatchBytes -Offset "85FB80"  -Shared -Patch "HUD\Dungeon Map Skull\Majora's Mask.bin"
        PatchBytes -Offset "1A3E580" -Shared -Patch "HUD\Dungeon Map Chest\Majora's Mask.bin"
    }

    if (IsChecked $Redux.UI.ButtonPositions) {
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
        PatchBytes -Offset "1A3E580" -Shared -Patch "HUD\Dungeon Map Chest\Majora's Mask.bin"; PatchBytes -Offset "85F980" -Shared -Patch "HUD\Dungeon Map Link\Majora's Mask.bin"; PatchBytes -Offset "85FB80" -Shared -Patch "HUD\Dungeon Map Skull\Majora's Mask.bin"
    }

    if (IsChecked $Redux.UI.CenterNaviPrompt)                                { ChangeBytes -Offset "B582DF" -Values "01" -Subtract }
    if ( (IsChecked $Redux.UI.HUD) -or (IsChecked $Redux.UI.Hearts)      )   { PatchBytes -Offset "1A3C100" -Shared -Patch "HUD\Heart\Majora's Mask.bin" }
    if ( (IsChecked $Redux.UI.HUD) -or (IsChecked $Redux.UI.Rupees)      )   { PatchBytes -Offset "1A3DF00" -Shared -Patch "HUD\Rupee\Majora's Mask.bin" }
    if ( (IsChecked $Redux.UI.HUD) -or (IsChecked $Redux.UI.DungeonKeys) )   { PatchBytes -Offset "1A3DE00" -Shared -Patch "HUD\Key\Majora's Mask.bin"   }
    if ( !(IsIndex -Elem $Redux.UI.MagicBar -Text "Ocarina Of Time"))        { PatchBytes -Offset "1A3F8C0" -Shared -Patch ("HUD\Magic\" + $Redux.UI.MagicBar.Text.replace(" (default)", "") + ".bin") }



    # HIDE HUD #

    if ( (IsChecked $Redux.Hide.AButton) -or (IsChecked $Redux.Hide.Interface) ) {
        ChangeBytes -Offset "B586B0" -Values "00 00 00 00" # A Button (scale)
        ChangeBytes -Offset "AE7D0E" -Values "03 10"       # A Button - Text (DMA)
        ChangeBytes -Offset "7540"   -Values "03 10 00 00 03 10 57 00 03 10 00 00"
    } 

    if ( (IsChecked $Redux.Hide.BButton)      -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "B57EEC" -Values "24 02 03 A0"; ChangeBytes -Offset "B57EFC" -Values "24 0A 03 A2"; ChangeBytes -Offset "B589D4" -Values "24 0F 03 97"; ChangeBytes -Offset "B589E8" -Values "24 19 03 94" }  # B Button -> Icon / Ammo / Japanese / English
    if ( (IsChecked $Redux.Hide.StartButton)  -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "B584EC" -Values "24 19 03 84"; ChangeBytes -Offset "B58490" -Values "24 18 03 7A"; ChangeBytes -Offset "B5849C" -Values "24 0E 03 78" }  # Start Button   -> Button / Japanese / English
    if ( (IsChecked $Redux.Hide.CupButton)    -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "B584C0" -Values "24 19 03 FE"; ChangeBytes -Offset "B582DC" -Values "24 0E 03 F7"                                                     }  # C-Up Button    -> Button / Navi Text
    if ( (IsChecked $Redux.Hide.CLeftButton)  -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "B58504" -Values "24 19 03 E3"; ChangeBytes -Offset "B5857C" -Values "24 19 03 E3"; ChangeBytes -Offset "B58DC4" -Values "24 0E 03 E4" }  # C-Left Button  -> Button / Icon / Ammo
    if ( (IsChecked $Redux.Hide.CDownButton)  -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "B58510" -Values "24 0F 03 F9"; ChangeBytes -Offset "B58588" -Values "24 0F 03 F9"; ChangeBytes -Offset "B58C40" -Values "24 06 02 FA" }  # C-Down Button  -> Button / Icon / Ammo
    if ( (IsChecked $Redux.Hide.CRightButton) -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "B5851C" -Values "24 19 03 0F"; ChangeBytes -Offset "B58594" -Values "24 19 03 0F"; ChangeBytes -Offset "B58DE0" -Values "24 19 03 10" }  # C-Right Button -> Button / Icon / Ammo
    if ( (IsChecked $Redux.Hide.AreaTitle)    -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "BE2B10" -Values "24 07 03 A0" } # Area Titles
    if ( (IsChecked $Redux.Hide.DungeonTitle) -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "AC8828" -Values "24 07 03 A0" } # Dungeon Titles
    if ( (IsChecked $Redux.Hide.Carrots)      -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "B58348" -Values "24 0F 03 6E" } # Epona Carrots    
    if ( (IsChecked $Redux.Hide.Hearts)       -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "ADADEC" -Values "10 00"       } # Disable Hearts Render

    if ( (IsChecked $Redux.Hide.Magic) -or (IsChecked $Redux.Hide.Interface) ) {
        ChangeBytes -Offset "B587C0" -Values "24 0F 03 1A"; ChangeBytes -Offset "B587A0" -Values "24 0E 01 22"; ChangeBytes -Offset "B587B4" -Values "24 19 01 2A" # Magic Meter / Magic Bar - Small (Y pos) / Magic Bar - Large (Y pos)
    }

    if ( (IsChecked $Redux.Hide.Icons) -or (IsChecked $Redux.Hide.Interface) ) {
        ChangeBytes -Offset "B58CFC" -Values "24 0F 00 00" # Clock - Digits (scale)
        $Values = @();     for ($i=0; $i -lt 256; $i++) { $Values += 0 };     ChangeBytes -Offset "1A3E000" -Values $Values     # Clock - Icon
        $Values = @();     for ($i=0; $i -lt 768; $i++) { $Values += 0 };     ChangeBytes -Offset "1A3E600" -Values $Values     # Score Counter - Icon
    }

    <#if ( (IsChecked $Redux.Hide.Minimaps) -or (IsChecked $Redux.Hide.Interface) ) {
        $Values = @(); for ($i=0; $i -lt 20; $i++) { $Values += 3 }; ChangeBytes -Offset "B6C814" -Values $values -Interval 2 # Minimaps
        $Values = @(); for ($i=0; $i -lt 20; $i++) { $Values += 8 }; ChangeBytes -Offset "B6C878" -Values $values -Interval 8 # Arrows
        $Values = @(); for ($i=0; $i -lt 24; $i++) { $Values += 3 }; ChangeBytes -Offset "B6C9FA" -Values $values -Interval 2 # Dungeon Icons
        ChangeBytes -Offset "58AF0"  -Values "03" # Dungeon Map
        ChangeBytes -Offset "B6C87A" -Values "03" # Dungeon Icon - Bottom of the Well   ChangeBytes -Offset "B6CA00" -Values "03" # Dungeon Icon - Inside the Deku Tree       ChangeBytes -Offset "B6CA02" -Values "03" # Dungeon Icon - Forest Temple
        ChangeBytes -Offset "B6CA04" -Values "03" # Dungeon Icon - ?                    ChangeBytes -Offset "B6CA08" -Values "03" # Dungeon Icon - Inside Jabu-Jabu's Belly   ChangeBytes -Offset "B6CA0E" -Values "03" # Dungeon Icon - Spirit Temple
        ChangeBytes -Offset "B6CA16" -Values "03" # Dungeon Icon - Dodongo's Cavern     ChangeBytes -Offset "B6CA18" -Values "03" # Dungeon Icon - Fire Temple                ChangeBytes -Offset "B6CA1E" -Values "03" # Dungeon Icon - Ganon's Castle
        ChangeBytes -Offset "B6CA20" -Values "03" # Dungeon Icon - Shadow Temple        ChangeBytes -Offset "B6CA22" -Values "03" # Dungeon Icon - Water Temple               ChangeBytes -Offset "B6CA26" -Values "03" # Dungeon Icon - ?
    }#>

    if ( (IsChecked $Redux.Hide.Rupees)      -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "AEB7B0" -Values "24 0C 03 1A"; ChangeBytes -Offset "AEBC48" -Values "24 0D 01 CE" } # Rupees - Icon / Rupees - Text (Y pos)
    if ( (IsChecked $Redux.Hide.DungeonKeys) -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "AEB8AC" -Values "24 0F 03 1A"; ChangeBytes -Offset "AEBA00" -Values "24 19 01 BE" } # Key    - Icon / Key    - Text (Y pos)
    if ( (IsChecked $Redux.Hide.Credits)     -or (IsChecked $Redux.Hide.Interface) )   { PatchBytes  -Offset "966000" -Patch "Message\credits.bin" }



    # MENU #

    if (IsIndex -Elem $Redux.Menu.Skybox -Index 4 -Not)   { ChangeBytes -Offset "B67722" -Values $Redux.Menu.Skybox.SelectedIndex }



    # SOUNDS / VOICES #

    if (IsChecked $Redux.Restore.FireTemple) { $offset = "1EF340" } else { $offset = "1DFC00" }
    $file = "Voices Child\" + $Redux.Sounds.ChildVoices.Text.replace(" (default)", "") + ".bin"
    if (TestFile ($GameFiles.binaries + "\" + $file)) { PatchBytes -Offset $offset -Patch ($file) }

    if (IsChecked $Redux.Restore.FireTemple) { $offset = "19D920" } else { $offset = "18E1E0" }
    $file = "Voices Adult\" + $Redux.Sounds.AdultVoices.Text.replace(" (default)", "") + ".bin"
    if (TestFile ($GameFiles.binaries + "\" + $file)) { PatchBytes -Offset $offset -Patch ($file) }

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

    PatchReplaceMusic -bankPointerTableStart "B899EC" -BankPointerTableEnd "B89AD0" -PointerTableStart "B89AE0" -PointerTableEnd "B8A1C0" -SeqStart "29DE0" -SeqEnd "79470"
    PatchMuteMusic -SequenceTable "B89AE0" -Sequence "29DE0" -Length 108

    if (IsIndex -Elem $Redux.Music.FileSelect -Text $Redux.Music.FileSelect.default -Not) {
        foreach ($track in $Files.json.music.tracks) {
            if ($Redux.Music.FileSelect.Text -eq $track.title) {
                ChangeBytes -Offset "BAFEE3" -Values $track.id
                break
            }
        }
    }
    


    # HERO MODE #

    if (IsText -Elem $Redux.Hero.Damage -Compare "OHKO Mode") {
        ChangeBytes -Offset "AE8073" -Values "09 04" -Interval 16
        ChangeBytes -Offset "AE8096" -Values "82 00"
        ChangeBytes -Offset "AE8099" -Values "00 00 00"
    }
    elseif ( (IsIndex -Elem $Redux.Hero.Damage -Not) -or (IsIndex -Elem $Redux.Hero.Recovery -Not) -or (IsChecked $Redux.Hero.NoRecoveryHearts) ) {
        ChangeBytes -Offset "AE8073" -Values "09 04" -Interval 16
        if       ( (IsText -Elem $Redux.Hero.Recovery -Compare "0x Recovery") -or (IsChecked $Redux.Hero.NoRecoveryHearts) ) {                
            if     (IsText -Elem $Redux.Hero.Damage   -Compare "1x Damage")   { ChangeBytes -Offset "AE8096" -Values "81 40" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "2x Damage")   { ChangeBytes -Offset "AE8096" -Values "81 80" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "4x Damage")   { ChangeBytes -Offset "AE8096" -Values "81 C0" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "8x Damage")   { ChangeBytes -Offset "AE8096" -Values "82 00" }
            ChangeBytes -Offset "AE8099" -Values "10 81 43"
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Compare "1x Recovery") {                
            if     (IsText -Elem $Redux.Hero.Damage   -Compare "2x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 40" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "4x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 80" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "8x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 C0" }
            ChangeBytes -Offset "AE8099" -Values "00 00 00"
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Compare "1/2x Recovery") {               
            if     (IsText -Elem $Redux.Hero.Damage   -Compare "1x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 40" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "2x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 80" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "4x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 C0" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "8x Damage")   { ChangeBytes -Offset "AE8096" -Values "81 00" }
            ChangeBytes -Offset "AE8099" -Values "10 80 43"
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Compare "1/4x Recovery") {                
            if     (IsText -Elem $Redux.Hero.Damage   -Compare "1x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 80" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "2x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 C0" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "4x Damage")   { ChangeBytes -Offset "AE8096" -Values "81 00" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "8x Damage")   { ChangeBytes -Offset "AE8096" -Values "81 40" }
            ChangeBytes -Offset "AE8099" -Values "10 80 83"
        }
    }

    if     (IsText -Elem $Redux.Hero.MagicUsage -Compare "2x Magic Usage")   { ChangeBytes -Offset "AE84FA" -Values "2C","40" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "4x Magic Usage")   { ChangeBytes -Offset "AE84FA" -Values "2C","80" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "8x Magic Usage")   { ChangeBytes -Offset "AE84FA" -Values "2C","C0" }

    if (IsIndex -Elem $Redux.Hero.MonsterHP -Index 3 -Not) { # Monsters
        if (IsIndex -Elem $Redux.Hero.MonsterHP)   { $multi = 0   }
        else                                       { [float]$multi = [float]$Redux.Hero.MonsterHP.text.split('x')[0] }

        MultiplyBytes -Offset "C83647" -Factor $multi; MultiplyBytes -Offset "C83817" -Factor $multi; MultiplyBytes -Offset "C836AB" -Factor $multi # Moblin, Moblin (Spear), Moblin (Club)
        MultiplyBytes -Offset "C5F69C" -Factor $multi; MultiplyBytes -Offset "CAAF9C" -Factor $multi; MultiplyBytes -Offset "C55A78" -Factor $multi # Biri, Bari, Shabom
        MultiplyBytes -Offset "CD724F" -Factor $multi; MultiplyBytes -Offset "EDC597" -Factor $multi; MultiplyBytes -Offset "C0B804" -Factor $multi; # ReDead / Gibdo, Stalchild, Poe
        MultiplyBytes -Offset "CB1903" -Factor $multi; MultiplyBytes -Offset "CB2DD7" -Factor $multi # Blue Bubble, Red Blue
        MultiplyBytes -Offset "D76A07" -Factor $multi; MultiplyBytes -Offset "C5FC3F" -Factor $multi # Tentacle, Tailpasaran
        MultiplyBytes -Offset "C693CC" -Factor $multi; MultiplyBytes -Offset "EB797C" -Factor $multi # Stinger (Land), Stinger (Water)
        MultiplyBytes -Offset "C2B183" -Factor $multi; MultiplyBytes -Offset "C2B1F7" -Factor $multi # Red Tektite, Blue Tektite
        MultiplyBytes -Offset "C1097C" -Factor $multi; MultiplyBytes -Offset "CD582C" -Factor $multi # Wallmaster, Floormaster
        MultiplyBytes -Offset "C2DEE7" -Factor $multi; MultiplyBytes -Offset "C2DF4B" -Factor $multi # Leever (Green / Purple)
        MultiplyBytes -Offset "CC6CA7" -Factor $multi; MultiplyBytes -Offset "CC6CAB" -Factor $multi # Beamos
        MultiplyBytes -Offset "C11177" -Factor $multi; MultiplyBytes -Offset "C599BC" -Factor $multi # Dodongo, Baby Dodongo
        MultiplyBytes -Offset "CE60C4" -Factor $multi # ChangeBytes -Offset "CE39AF" -Values "80" # Skullwalltula (Regular & Gold), Gold HP Multiplier
        MultiplyBytes -Offset "EEF780" -Factor $multi; MultiplyBytes -Offset "C6471B" -Factor $multi; MultiplyBytes -Offset "C51A9F" -Factor $multi # Guay, Torch Slug, Gohma Larva
        MultiplyBytes -Offset "D74393" -Factor $multi; MultiplyBytes -Offset "C2F97F" -Factor $multi; MultiplyBytes -Offset "C0DEF8" -Factor $multi # Like-Like, Peehat, Octorok
        MultiplyBytes -Offset "D463BF" -Factor $multi; MultiplyBytes -Offset "CA85DC" -Factor $multi; MultiplyBytes -Offset "DADBAF" -Factor $multi # Shell Blade, Mad Scrub, Spike
        
        if ($multi -ge 2) {
            ChangeBytes -Offset "B65660" -Values "10 01 01 01 10 02 01 01 01 01 01 02 02 02 00 00 00 01 01 00 00 00 01 01 01 01 01 01 00 00 00 00" # Skulltula
            ChangeBytes -Offset "DFE767" -Values "F1 F0 F0 F1 F1 F0 F1 F2 22 F0 F0 F0 F0 F0 22 00 00 00 00 F0 F2 F1 F0 F4 F2"                      # Freezard
            
        }

      # MultiplyBytes -Offset "" -Factor $multi # Peehat Larva                       (HP: 01)   C2F8D0 -> C32FD0 (Length: 3700) (ovl_En_Peehat)
      # MultiplyBytes -Offset "" -Factor $multi # Anubis                             (HP: 01)   D79240 -> D7A4F0 (Length: 12B0) (ovl_En_Anubice)
      # MultiplyBytes -Offset "DFC9A3" -Factor $multi; ChangeBytes -Offset "DFDE43" -Factor $multi # Freezard
      # MultiplyBytes -Offset "C96A5B" -Factor $multi; ChangeBytes -Offset "C96B0C" -Factor $multi # Armos
      # MultiplyBytes -Offset "C6417C" -Factor $multi; ChangeBytes -Offset "C15814" -Factor $multi; ChangeBytes -Offset "CB1BCB" -Factor $multi  # Skulltula, Keese, Green Bubble
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

        if ($multi -gt 0) {
            MultiplyBytes -Offset "DE9A1B" -Factor $multi                                      # Iron Knuckle (phase 1)
            $value = $ByteArrayGame[(GetDecimal "DEB367")]; $value--; $value *= $multi; $value++;
            ChangeBytes -Offset "DEB367" -Values $value -IsDec; ChangeBytes -Offset "DEB34F" -Values $value -IsDec # Iron Knuckle (phase 2)
        }
        else { ChangeBytes -Offset "DE9A1B" -Values "01"; ChangeBytes -Offset "DEB367" -Values "01" -IsDec; ChangeBytes -Offset "DEB34F" -Values "01" } # Iron Knuckle (phase 1), Iron Knuckle (phase 2)
    }
    
    if (IsIndex -Elem $Redux.Hero.BossHP -Index 3 -Not) { # Bosses
        if (IsIndex -Elem $Redux.Hero.BossHP)   { $multi = 0   }
        else                                    { [float]$multi = [float]$Redux.Hero.BossHP.text.split('x')[0] }

        MultiplyBytes -Offset "C44F2B" -Factor $multi; MultiplyBytes -Offset "C486CC" -Values "00 00 00 00" # Gohma
        MultiplyBytes -Offset "D258BB" -Factor $multi; MultiplyBytes -Offset "D25B0B" -Factor $multi # Barinade
        MultiplyBytes -Offset "D64EFB" -Factor $multi; MultiplyBytes -Offset "D6223F" -Factor $multi # Twinrova
        MultiplyBytes -Offset "C3B9FF" -Factor $multi # King Dodongo
        MultiplyBytes -Offset "CE6D2F" -Factor $multi # Volvagia
        MultiplyBytes -Offset "D3B4A7" -Factor $multi # Morpha
        MultiplyBytes -Offset "DAC824" -Factor $multi # Bongo Bongo
        MultiplyBytes -Offset "D7FDA3" -Factor $multi # Ganondorf 

        if ($multi -gt 0) {
            ChangeBytes -Offset "C91F8F" -Factor $multi # Phantom Ganon (phase 1)
            $value = $ByteArrayGame[(GetDecimal "C91F8F")]; $value -= (2 * 3 * $multi); $value++
            ChangeBytes -Offset "CAFF33" -Values $value -IsDec # Phantom Ganon (phase 2)

            ChangeBytes -Offset "E82AFB" -Factor $multi # Ganon (phase 1)
            $value = $ByteArrayGame[(GetDecimal "E87F2F")]; $value--; $value *= $multi; $value++;
            ChangeBytes -Offset "E87F2F" -Values $value -IsDec # Ganon (phase 2)
        }
        else {
            ChangeBytes -Offset "C91F8F" -Values "04"; ChangeBytes -Offset "CAFF33" -Values "03" # Phantom Ganon (phase 1), Phantom Ganon (phase 2)
            ChangeBytes -Offset "E82AFB" -Values "04"; ChangeBytes -Offset "E87F2F" -Values "03" # Ganon (phase 1), Ganon (phase 2)
        }
    }

    if (IsChecked $Redux.Hero.GraveyardKeese) {
        ChangeBytes -Offset "202F389" -Values "0E"; ChangeBytes -Offset "202F3BB" -Values "0D"; ChangeBytes -Offset "202F3DD" -Values "13"; ChangeBytes -Offset "202F3EB" -Values "03"; ChangeBytes -Offset "202F3ED" -Values "13"; ChangeBytes -Offset "202F3FB" -Values "03"
        ChangeBytes -Offset "202F3FD" -Values "13"; ChangeBytes -Offset "202F40B" -Values "03"; ChangeBytes -Offset "202F40D" -Values "13"; ChangeBytes -Offset "202F41B" -Values "03"; ChangeBytes -Offset "202F41D" -Values "13"; ChangeBytes -Offset "202F42B" -Values "03"
        ChangeBytes -Offset "202F779" -Values "0E"; ChangeBytes -Offset "202F7AB" -Values "0D"; ChangeBytes -Offset "202F7CD" -Values "13"; ChangeBytes -Offset "202F7DB" -Values "03"; ChangeBytes -Offset "202F7DD" -Values "13"; ChangeBytes -Offset "202F7EB" -Values "03"
        ChangeBytes -Offset "202F7ED" -Values "13"; ChangeBytes -Offset "202F7FB" -Values "03"; ChangeBytes -Offset "202F7FD" -Values "13"; ChangeBytes -Offset "202F80B" -Values "03"; ChangeBytes -Offset "202F80D" -Values "13"; ChangeBytes -Offset "202F81B" -Values "03"
    }

    if (IsChecked $Redux.Hero.NoItemDrops) {
        $Values = @()
        for ($i=0; $i -lt 80; $i++) { $Values += 0 }
        ChangeBytes -Offset "B5D6B0" -Values $Values
    }

    if     (IsChecked $Redux.Hero.NoRecoveryHearts)   { ChangeBytes -Offset "A895B7"  -Values "2E" }
    if     (IsChecked $Redux.Hero.Arwing)             { ChangeBytes -Offset "2081086" -Values "00 02"; ChangeBytes -Offset "2081114" -Values "01 3B"; ChangeBytes -Offset "2081122" -Values "00 00" }
    elseif (IsChecked $Redux.Hero.LikeLike)           { ChangeBytes -Offset "2081086" -Values "00 D4"; ChangeBytes -Offset "2081114" -Values "00 DD"; ChangeBytes -Offset "2081122" -Values "00 00" }

    
    
    # EQUIPMENT COLORS #

    if (IsSet $Redux.Colors.SetEquipment) {
        if (IsDefaultColor -Elem $Redux.Colors.SetEquipment[0] -Not) { # Kokiri Tunic
            ChangeBytes -Offset "B6DA38" -IsDec -Values @($Redux.Colors.SetEquipment[0].Color.R, $Redux.Colors.SetEquipment[0].Color.G, $Redux.Colors.SetEquipment[0].Color.B)
            if ( (IsText -Elem $Redux.Colors.Equipment[0] -Compare "Randomized" -Not) -and (IsText -Elem $Redux.Colors.Equipment[0] -Compare "Custom" -Not) ) { PatchBytes -Offset "7FE000"  -Texture -Patch ("Tunic\" + $Redux.Colors.Equipment[0].text.replace(" (default)", "") + ".bin") }
        }

        if (IsDefaultColor -Elem $Redux.Colors.SetEquipment[1] -Not) { # Goron Tunic
            ChangeBytes -Offset "B6DA3B" -IsDec -Values @($Redux.Colors.SetEquipment[1].Color.R, $Redux.Colors.SetEquipment[1].Color.G, $Redux.Colors.SetEquipment[1].Color.B)
            if ( (IsText -Elem $Redux.Colors.Equipment[1] -Compare "Randomized" -Not) -and (IsText -Elem $Redux.Colors.Equipment[1] -Compare "Custom" -Not) ) { PatchBytes -Offset "7FF000"  -Texture -Patch ("Tunic\" + $Redux.Colors.Equipment[1].text.replace(" (default)", "") + ".bin") }
        }

        if (IsDefaultColor -Elem $Redux.Colors.SetEquipment[2] -Not) { # Zora Tunic
            ChangeBytes -Offset "B6DA3E" -IsDec -Values @($Redux.Colors.SetEquipment[2].Color.R, $Redux.Colors.SetEquipment[2].Color.G, $Redux.Colors.SetEquipment[2].Color.B)
            if ( (IsText -Elem $Redux.Colors.Equipment[2] -Compare "Randomized" -Not) -and (IsText -Elem $Redux.Colors.Equipment[2] -Compare "Custom" -Not) ) { PatchBytes -Offset "800000"  -Texture -Patch ("Tunic\" + $Redux.Colors.Equipment[2].text.replace(" (default)", "") + ".bin") }
        }

        if (IsDefaultColor -Elem $Redux.Colors.SetEquipment[3] -Not)   { ChangeBytes -Offset "B6DA44" -IsDec -Values @($Redux.Colors.SetEquipment[3].Color.R, $Redux.Colors.SetEquipment[3].Color.G, $Redux.Colors.SetEquipment[3].Color.B) } # Silver Gauntlets
        if (IsDefaultColor -Elem $Redux.Colors.SetEquipment[4] -Not)   { ChangeBytes -Offset "B6DA47" -IsDec -Values @($Redux.Colors.SetEquipment[4].Color.R, $Redux.Colors.SetEquipment[4].Color.G, $Redux.Colors.SetEquipment[4].Color.B) } # Golden Gauntlets
        if ( (IsDefaultColor -Elem $Redux.Colors.SetEquipment[5] -Not) -and $AdultModel.mirror_shield -ne 0) { # Mirror Shield Frame
            $offset = "F86000"
            do {
                $offset = SearchBytes -Start $offset -End "FBD800" -Values "FA 00 00 00 D7 00 00"
                if ($offset -ge 0) {
                    $Offset = ( Get24Bit ( (GetDecimal $offset) + (GetDecimal "4") ) )
                    if (!(ChangeBytes -Offset $offset -IsDec -Values @($Redux.Colors.SetEquipment[5].Color.R, $Redux.Colors.SetEquipment[5].Color.G, $Redux.Colors.SetEquipment[5].Color.B))) { break }
                }
            } while ($Offset -ge 0)
        }
    }

    

    # MAGIC SPIN ATTACK COLORS #

    if (IsSet $Redux.Colors.SetSpinAttack) {
        if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[0] -Not)   { ChangeBytes -Offset "F15AB4" -IsDec -Values @($Redux.Colors.SetSpinAttack[0].Color.R, $Redux.Colors.SetSpinAttack[0].Color.G, $Redux.Colors.SetSpinAttack[0].Color.B) } # Blue Spin Attack
        if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[1] -Not)   { ChangeBytes -Offset "F15BD4" -IsDec -Values @($Redux.Colors.SetSpinAttack[1].Color.R, $Redux.Colors.SetSpinAttack[1].Color.G, $Redux.Colors.SetSpinAttack[1].Color.B) } # Blue Spin Attack
        if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[2] -Not)   { ChangeBytes -Offset "F16034" -IsDec -Values @($Redux.Colors.SetSpinAttack[2].Color.R, $Redux.Colors.SetSpinAttack[2].Color.G, $Redux.Colors.SetSpinAttack[2].Color.B) } # Red Spin Attack
        if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[3] -Not)   { ChangeBytes -Offset "F16154" -IsDec -Values @($Redux.Colors.SetSpinAttack[3].Color.R, $Redux.Colors.SetSpinAttack[3].Color.G, $Redux.Colors.SetSpinAttack[3].Color.B) } # Red Spin Attack
    }



    # SWORD TRAIL COLORS #

    if (IsSet $Redux.Colors.SetSwordTrail) {
        if (IsDefaultColor -Elem $Redux.Colors.SetSwordTrail[0] -Not)       { ChangeBytes -Offset "BEFF7C" -IsDec -Values @($Redux.Colors.SetSwordTrail[0].Color.R, $Redux.Colors.SetSwordTrail[0].Color.G, $Redux.Colors.SetSwordTrail[0].Color.B) }
        if (IsDefaultColor -Elem $Redux.Colors.SetSwordTrail[1] -Not)       { ChangeBytes -Offset "BEFF84" -IsDec -Values @($Redux.Colors.SetSwordTrail[1].Color.R, $Redux.Colors.SetSwordTrail[1].Color.G, $Redux.Colors.SetSwordTrail[1].Color.B) }
        if (IsIndex -Elem $Redux.Colors.SwordTrailDuration -Not -Index 2)   { ChangeBytes -Offset "BEFF8C" -IsDec -Values (($Redux.Colors.SwordTrailDuration.SelectedIndex) * 5) }
    }
    

    # FAIRY COLORS #

    if (IsChecked -Elem $Redux.Colors.BetaNavi) { ChangeBytes -Offset "A96110" -Values "34 0F 00 60" }
    elseif (IsSet $Redux.Colors.SetFairy) {
        if ( (IsDefaultColor -Elem $Redux.Colors.SetFairy[0] -Not) -or (IsDefaultColor -Elem $Redux.Colors.SetFairy[1] -Not) ) { # Idle
            ChangeBytes -Offset "B5E184" -IsDec -Values @($Redux.Colors.SetFairy[0].Color.R, $Redux.Colors.SetFairy[0].Color.G, $Redux.Colors.SetFairy[0].Color.B, 255, $Redux.Colors.SetFairy[1].Color.R, $Redux.Colors.SetFairy[1].Color.G, $Redux.Colors.SetFairy[1].Color.B, 0)
        }
        if ( (IsDefaultColor -Elem $Redux.Colors.SetFairy[2] -Not) -or (IsDefaultColor -Elem $Redux.Colors.SetFairy[3] -Not) ) { # Interact
            ChangeBytes -Offset "B5E174" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E17C" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E18C" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E1A4" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E1AC" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E1B4" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E1C4" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E1CC" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E1D4" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
        }
        if ( (IsDefaultColor -Elem $Redux.Colors.SetFairy[4] -Not) -or (IsDefaultColor -Elem $Redux.Colors.SetFairy[5] -Not) ) { # NPC
            ChangeBytes -Offset "B5E194" -IsDec -Values @($Redux.Colors.SetFairy[4].Color.R, $Redux.Colors.SetFairy[4].Color.G, $Redux.Colors.SetFairy[4].Color.B, 255, $Redux.Colors.SetFairy[5].Color.R, $Redux.Colors.SetFairy[5].Color.G, $Redux.Colors.SetFairy[5].Color.B, 0)
        }
        if ( (IsDefaultColor -Elem $Redux.Colors.SetFairy[6] -Not) -or (IsDefaultColor -Elem $Redux.Colors.SetFairy[7] -Not) ) { # Enemy, Boss
            ChangeBytes -Offset "B5E19C" -IsDec -Values @($Redux.Colors.SetFairy[6].Color.R, $Redux.Colors.SetFairy[6].Color.G, $Redux.Colors.SetFairy[6].Color.B, 255, $Redux.Colors.SetFairy[7].Color.R, $Redux.Colors.SetFairy[7].Color.G, $Redux.Colors.SetFairy[7].Color.B, 0)
            ChangeBytes -Offset "B5E1BC" -IsDec -Values @($Redux.Colors.SetFairy[6].Color.R, $Redux.Colors.SetFairy[6].Color.G, $Redux.Colors.SetFairy[6].Color.B, 255, $Redux.Colors.SetFairy[7].Color.R, $Redux.Colors.SetFairy[7].Color.G, $Redux.Colors.SetFairy[7].Color.B, 0)
        }
    }



    # MISC COLORS #

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



    # AMMO CAPACITY #

    if (IsChecked $Redux.Capacity.EnableAmmo) {
        if ([int]$Redux.Capacity.BombBag1.Text -ge 20)   { $BombBag1 = $Redux.Capacity.BombBag1.Text }
        else                                             { $BombBag1 = "20" }

        ChangeBytes -Offset "B6EC2F" -IsDec -Values @($Redux.Capacity.Quiver1.Text,     $Redux.Capacity.Quiver2.Text,     $Redux.Capacity.Quiver3.Text)     -Interval 2
        ChangeBytes -Offset "B6EC37" -IsDec -Values @($BombBag1,                        $Redux.Capacity.BombBag2.Text,    $Redux.Capacity.BombBag3.Text)    -Interval 2
        ChangeBytes -Offset "B6EC57" -IsDec -Values @($Redux.Capacity.BulletBag1.Text,  $Redux.Capacity.BulletBag2.Text,  $Redux.Capacity.BulletBag3.Text)  -Interval 2
        ChangeBytes -Offset "B6EC5F" -IsDec -Values @($Redux.Capacity.DekuSticks1.Text, $Redux.Capacity.DekuSticks2.Text, $Redux.Capacity.DekuSticks3.Text) -Interval 2
        ChangeBytes -Offset "B6EC67" -IsDec -Values @($Redux.Capacity.DekuNuts1.Text,   $Redux.Capacity.DekuNuts2.Text,   $Redux.Capacity.DekuNuts3.Text)   -Interval 2

        # Initial Ammo
      # ChangeBytes -Offset "" -IsDec -Values $Redux.Capacity.Quiver1.Text
      # ChangeBytes -Offset "" -IsDec -Values $BombBag1
        ChangeBytes -Offset "AE6D03" -IsDec -Values $Redux.Capacity.BulletBag1.Text
      # ChangeBytes -Offset "" -IsDec -Values $Redux.Capacity.DekuSticks1.Text
      # ChangeBytes -Offset "" -IsDec -Values $Redux.Capacity.DekuNuts1.Text
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
    }



    # ITEM DROPS QUANTITY #

    if (IsChecked $Redux.Capacity.EnableDrops) {
        ChangeBytes -Offset "B6D4D1" -IsDec -Values @($Redux.Capacity.Arrows1x.Text,  $Redux.Capacity.Arrows2x.Text, $Redux.Capacity.Arrows3x.Text)                              -Interval 2
        ChangeBytes -Offset "AE6D43" -IsDec -Values $Redux.Capacity.BulletSeeds.Text
        ChangeBytes -Offset "AE6DCF" -IsDec -Values $Redux.Capacity.BulletSeedsShop.Text
        ChangeBytes -Offset "AE675B" -IsDec -Values $Redux.Capacity.DekuSticks.Text
        ChangeBytes -Offset "B6D4C9" -IsDec -Values ($Redux.Capacity.Bombs1x.Text,    $Redux.Capacity.Bombs2x.Text,  $Redux.Capacity.Bombs3x.Text, $Redux.Capacity.Bombs4x.Text) -Interval 2
        ChangeBytes -Offset "B6D4D9" -IsDec -Values ($Redux.Capacity.DekuNuts1x.Text, $Redux.Capacity.DekuNuts2x.Text)                                                           -Interval 2
        $RupeeG = Get16Bit $Redux.Capacity.RupeeG.Text; $RupeeB = Get16Bit $Redux.Capacity.RupeeB.Text; $RupeeR = Get16Bit $Redux.Capacity.RupeeR.Text; $RupeeP = Get16Bit $Redux.Capacity.RupeeP.Text; $RupeeO = Get16Bit $Redux.Capacity.RupeeO.Text
        
        Write-Host $RupeeG   $RupeeG.Substring(0, 2)   $RupeeG.Substring(2)
        Write-Host $RupeeB   $RupeeB.Substring(0, 2)   $RupeeB.Substring(2)
        Write-Host $RupeeR   $RupeeR.Substring(0, 2)   $RupeeR.Substring(2)
        Write-Host $RupeeP   $RupeeP.Substring(0, 2)   $RupeeP.Substring(2)
        Write-Host $RupeeO   $RupeeO.Substring(0, 2)   $RupeeO.Substring(2)

        ChangeBytes -Offset "B6D4DC" -Values @($RupeeG.Substring(0, 2), $RupeeG.Substring(2), $RupeeB.Substring(0, 2), $RupeeB.Substring(2), $RupeeR.Substring(0, 2), $RupeeR.Substring(2), $RupeeP.Substring(0, 2), $RupeeP.Substring(2), $RupeeO.Substring(0, 2), $RupeeO.Substring(2) )
    }



    # EQUIPMENT #

    if (IsChecked $Redux.Equipment.IronShield) {
        ChangeBytes -Offset "BD3C5B" -Values "00" # Fireproof
        if ($ChildModel.deku_shield -ne 0) {
            $Offset = SearchBytes -Start "FBE000" -End "FEAF80" -Values "CC 99 E5 E5 DD A3 EE 2B DD A5 E6 29 DD A5 D4 DB"; PatchBytes -Offset $Offset -Texture -Patch "Equipment\Iron Shield\front.bin" # Vanilla: FC5E88
            $Offset = SearchBytes -Start "FBE000" -End "FEAF80" -Values "DC 11 F5 17 F5 19 DC 57 D4 59 E4 DB E4 DB DC 97"; PatchBytes -Offset $Offset -Texture -Patch "Equipment\Iron Shield\back.bin"  # Vanilla: FC5688
            PatchBytes -Offset "7FB000" -Texture -Patch "Equipment\Iron Shield\icon.bin"
            if (TestFile $GameFiles.textures + "\Equipment\Iron Shield\label_" + $LanguagePatch.code + ".bin") { PatchBytes -Offset "8AE400" -Texture -Patch ("Equipment\Iron Shield\label_" + $LanguagePatch.code + ".bin") }
        }
    }

    if (IsChecked $Redux.Equipment.HerosBowIcons) {
        PatchBytes -Offset "7C0000" -Texture -Patch "Equipment\Bow\heros_bow.icon"
        PatchBytes -Offset "7F5000" -Texture -Patch "Equipment\Bow\heros_bow_fire.icon"
        PatchBytes -Offset "7F6000" -Texture -Patch "Equipment\Bow\heros_bow_ice.icon"
        PatchBytes -Offset "7F7000" -Texture -Patch "Equipment\Bow\heros_bow_light.icon"
        if (TestFile ($GameFiles.textures + "\Equipment\Bow\heros_bow" + $LanguagePatch.code + ".label")) { PatchBytes -Offset "89F800" -Texture -Patch ("Equipment\Bow\heros_bow" + $LanguagePatch.code + ".label") }
    }

    if (IsChecked $Redux.Equipment.UnsheathSword)   { ChangeBytes -Offset "BD04A0" -Values "28 42 00 05 14 40 00 05 00 00 10 25" }
    if (IsChecked $Redux.Equipment.HookshotIcon)    { PatchBytes  -Offset "7C7000" -Texture -Patch "Equipment\Hookshot\termina_hookshot.icon" }



    
    # SWORDS AND SHIELDS #

    if (TestFile ($GameFiles.textures + "\Equipment\Kokiri Sword\" + $Redux.Equipment.KokiriSword.text + ".icon"))                                  { PatchBytes -Offset "7F8000" -Texture -Patch ("Equipment\Kokiri Sword\" + $Redux.Equipment.KokiriSword.text + ".icon") }
    if (TestFile ($GameFiles.textures + "\Equipment\Kokiri Sword\" + $Redux.Equipment.KokiriSword.text + "." + $LanguagePatch.code + ".label"))     { PatchBytes -Offset "8AD800" -Texture -Patch ("Equipment\Kokiri Sword\" + $Redux.Equipment.KokiriSword.text + "." + $LanguagePatch.code + ".label") }

    if (TestFile ($GameFiles.textures + "\Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text + ".icon"))                                  { PatchBytes -Offset "7F9000" -Texture -Patch ("Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text + ".icon") }
    if (TestFile ($GameFiles.textures + "\Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text + "." + $LanguagePatch.code + ".label"))     { PatchBytes -Offset "8ADC00" -Texture -Patch ("Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text + "." + $LanguagePatch.code + ".label") }

    if ($ChildModel.hylian_shield -ne 0 -and $AdultModel.hylian_shield -ne 0 -and (TestFile ($GameFiles.textures + "\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".bin"))) {
        PatchBytes -Offset "F03400" -Texture -Patch ("Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".bin")
        $Offset = SearchBytes -Start "FBE000" -End "FEAF80" -Values "BE 35 BE 77 C6 B9 CE FB D6 FD D7 3D DF 3F DF 7F"
        if ($Offset -gt 0)                                                                                                                          { PatchBytes -Offset $Offset  -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".bin") }
    }
    if (TestFile ($GameFiles.textures + "\Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".icon"))                                { PatchBytes -Offset "7FC000" -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".icon") }
    if (TestFile ($GameFiles.textures + "\Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + "." + $LanguagePatch.code + ".label"))   { PatchBytes -Offset "8AE800" -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + "." + $LanguagePatch.code + ".label") }
    # ChangeBytes -Offset "BC77B2" -Values "00 00" -Interval 73 # Lock Hylian Shield

    if ($AdultModel.mirror_shield -ne 0 -and (TestFile ($GameFiles.textures + "\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".bin"))) {
        $Offset = SearchBytes -Start "F86000" -End "FBD800" -Values "90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90"
        PatchBytes -Offset $Offset -Texture -Patch ("Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".bin")
        if (TestFile ($GameFiles.textures + "\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".chest"))                                     { PatchBytes -Offset "1616000" -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".chest") }
        if (TestFile ($GameFiles.textures + "\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".reflection"))                                { PatchBytes -Offset "1456388" -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".reflection") }
    }
    if (TestFile ($GameFiles.textures + "\Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".icon"))                                { PatchBytes -Offset "7FD000"  -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".icon") }
    if (TestFile ($GameFiles.textures + "\Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + "." + $LanguagePatch.code + ".label"))   { PatchBytes -Offset "8AEC00"  -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + "." + $LanguagePatch.code + ".label") }

    if     (IsChecked $Redux.Graphics.ListAdultMaleModels)            { $file = "Adult Male\"   + $Redux.Graphics.AdultMaleModels.Text.replace(" (default)", "")   }
    elseif (IsChecked $Redux.Graphics.ListAdultFeMaleModels)          { $file = "Adult Female\" + $Redux.Graphics.AdultFemaleModels.Text.replace(" (default)", "") }
    if     (TestFile ($GameFiles.models + "\" + $file + ".master"))   { PatchBytes -Offset "7F9000" -Models -Patch ($file + ".master") }
    if     (TestFile ($GameFiles.models + "\" + $file + ".hylian"))   { PatchBytes -Offset "7FC000" -Models -Patch ($file + ".hylian") }
    if     (TestFile ($GameFiles.models + "\" + $file + ".mirror"))   { PatchBytes -Offset "7FD000" -Models -Patch ($file + ".mirror") }

    

    # HITBOX #

    if (IsValue -Elem $Redux.Hitbox.KokiriSword       -Not)   { ChangeBytes -Offset "B6DB18" -Values (ConvertFloatToHex $Redux.Hitbox.KokiriSword.Value) }
    if (IsValue -Elem $Redux.Hitbox.MasterSword       -Not)   { ChangeBytes -Offset "B6DB14" -Values (ConvertFloatToHex $Redux.Hitbox.MasterSword.Value) }
    if (IsValue -Elem $Redux.Hitbox.GiantsKnife       -Not)   { ChangeBytes -Offset "B6DB1C" -Values (ConvertFloatToHex $Redux.Hitbox.GiantsKnife.Value) }
    if (IsValue -Elem $Redux.Hitbox.BrokenGiantsKnife -Not)   { ChangeBytes -Offset "B7E8CC" -Values (ConvertFloatToHex $Redux.Hitbox.BrokenGiantsKnife.Value) }
    if (IsValue -Elem $Redux.Hitbox.MegatonHammer     -Not)   { ChangeBytes -Offset "B6DB24" -Values (ConvertFloatToHex $Redux.Hitbox.MegatonHammer.Value) }
    if (IsValue -Elem $Redux.Hitbox.ShieldRecoil      -Not)   { ChangeBytes -Offset "BD4162" -Values ((Get16Bit ($Redux.Hitbox.ShieldRecoil.Value + 45000)) -split '(..)' -ne '') }



    # UNLOCK CHILD RESTRICTIONS #

    if ( (IsIndex -Elem $Redux.Unlock.MegatonHammer -Index 2) -or (IsIndex -Elem $Redux.Unlock.MegatonHammer -Index 4) ) { ChangeBytes -Offset "BC77A3" -Values "09 09" -Interval 42 }

    if (IsChecked $Redux.Unlock.Tunics)          { ChangeBytes -Offset "BC77B6" -Values "09 09"; ChangeBytes -Offset "BC77FE" -Values "09 09" }
    if (IsChecked $Redux.Unlock.MasterSword)     { ChangeBytes -Offset "BC77AE" -Values "09 09" -Interval 74 }
    if (IsChecked $Redux.Unlock.GiantsKnife)     { ChangeBytes -Offset "BC77AF" -Values "09 09" -Interval 74 }
    if (IsChecked $Redux.Unlock.MirrorShield)    { ChangeBytes -Offset "BC77B3" -Values "09 09" -Interval 73 }
    if (IsChecked $Redux.Unlock.Boots)           { ChangeBytes -Offset "BC77BA" -Values "09 09"; ChangeBytes -Offset "BC7801" -Values "09 09" }
    if (IsChecked $Redux.Unlock.Gauntlets)       { ChangeBytes -Offset "AEFA6C" -Values "24 08 00 00" }
    
    

    
    # UNLOCK ADULT RESTRICTIONS #
    
    if (IsChecked $Redux.Unlock.KokiriSword)               { ChangeBytes -Offset "BC77AD" -Values "09 09" -Interval 74 }
    if (IsChecked $Redux.Unlock.DekuShield)                { ChangeBytes -Offset "BC77B1" -Values "09 09" -Interval 73 }
    if (IsChecked $Redux.Unlock.FairySlingshot)            { ChangeBytes -Offset "BC779A" -Values "09 09" -Interval 40 }
    if (IsChecked $Redux.Unlock.Boomerang)                 { ChangeBytes -Offset "BC77A0" -Values "09 09" -Interval 42 }
    if (IsChecked $Redux.Unlock.CrawlHole)                 { ChangeBytes -Offset "BDAB13" -Values "00"                 }
    if (IsIndex -Elem $Redux.Unlock.DekuSticks -Not)       { ChangeBytes -Offset "AF1818" -Values "00 00 00 00"        }
    if (IsIndex -Elem $Redux.Unlock.DekuSticks -Index 3)   { ChangeBytes -Offset "BC7794" -Values "09 09" -Interval 40 }



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
        # Inside the Deku Tree
        ChangeBytes -Offset "2077E20" -Values "00 07 00 01 00 02 00 02"; ChangeBytes -Offset "2078A10" -Values "00 0E 00 1F 00 20 00 20"; ChangeBytes -Offset "2079570" -Values "00 80 00 00 00 1E 00 00 FF FF FF FF FF FF 00 1E 00 28 FF FF FF FF FF FF"

        # Dodongo's Cavern
        ChangeBytes -Offset "2221E88" -Values "00 0C 00 3B 00 3C 00 3C"; ChangeBytes -Offset "2223308" -Values "00 81 00 00 00 3A 00 00"

        # Inside Jabu-Jabu's Belly
        ChangeBytes -Offset "CA3530"  -Values "00 00 00 00";             ChangeBytes -Offset "2113340" -Values "00 0D 00 3B 00 3C 00 3C"; ChangeBytes -Offset "2113C18" -Values "00 82 00 00 00 3A 00 00"
        ChangeBytes -Offset "21131D0" -Values "00 01 00 00 00 3C 00 3C"

        # Forest Temple
        ChangeBytes -Offset "D4ED68"  -Values "00 45 00 3B 00 3C 00 3C"; ChangeBytes -Offset "D4ED78"  -Values "00 3E 00 00 00 3A 00 00"; ChangeBytes -Offset "207B9D4" -Values "FF FF FF FF"

        # Fire Temple
        ChangeBytes -Offset "2001848" -Values "00 1E 00 01 00 02 00 02"; ChangeBytes -Offset "D100B4"  -Values "00 62 00 3B 00 3C 00 3C"; ChangeBytes -Offset "D10134"  -Values "00 3C 00 00 00 3A 00 00"

        # Water Temple
        ChangeBytes -Offset "D5A458"  -Values "00 15 00 3B 00 3C 00 3C"; ChangeBytes -Offset "D5A3A8"  -Values "00 3D 00 00 00 3A 00 00"; ChangeBytes -Offset "20D0D20" -Values "00 29 00 C7 00 C8 00 C8"

        # Shadow Temple
        ChangeBytes -Offset "D13EC8"  -Values "00 61 00 3B 00 3C 00 3C"; ChangeBytes -Offset "D13E18"  -Values "00 41 00 00 00 3A 00 00"

        # Spirit Temple
        ChangeBytes -Offset "D3A0A8"  -Values "00 60 00 3B 00 3C 00 3C"; ChangeBytes -Offset "D39FF0"  -Values "00 3F 00 00 00 3A 00 00"
    }

    if (IsChecked $Redux.Skip.LightArrow) {
        ChangeBytes -Offset "2531B40" -Values "00 28 00 01 00 02 00 02"; ChangeBytes -Offset "2532FBC" -Values "00 75";          ChangeBytes -Offset "2532FEA" -Values "00 75 00 80"
        ChangeBytes -Offset "2533115" -Values "05";                      ChangeBytes -Offset "2533141" -Values "06 00 06 00 10"; ChangeBytes -Offset "2533171" -Values "0F 00 11 00 40"
        ChangeBytes -Offset "25331A1" -Values "07 00 41 00 65";          ChangeBytes -Offset "2533642" -Values "00 50";          ChangeBytes -Offset "253389D" -Values "74"
        ChangeBytes -Offset "25338A4" -Values "00 72 00 75 00 79";       ChangeBytes -Offset "25338BC" -Values "FF FF";          ChangeBytes -Offset "25338C2" -Values "FF FF FF FF FF FF"
        ChangeBytes -Offset "25339C2" -Values "00 75 00 76";             ChangeBytes -Offset "2533830" -Values "00 31 00 81 00 82 00 82"
    }
    
    if (IsChecked $Redux.Skip.RoyalTomb) {
        ChangeBytes -Offset "2025026" -Values "00 01"; ChangeBytes -Offset "2025159" -Values "02"
        ChangeBytes -Offset "2023C86" -Values "00 01"; ChangeBytes -Offset "2023E19" -Values "02"
    }
    
    if (IsChecked $Redux.Skip.DekuSeedBag) {
        ChangeBytes -Offset "ECA900" -Values "24 03 C0 00"; ChangeBytes -Offset "ECAE90" -Values "27 18 FD 04"; ChangeBytes -Offset "ECB618" -Values "25 6B 00 D4"
        ChangeBytes -Offset "ECAE70" -Values "00 00 00 00"; ChangeBytes -Offset "E5972C" -Values "24 08 00 01"
    }

    if (IsChecked $Redux.Speedup.Bosses) {
        ChangeBytes -Offset "C944D8" -Values "00 00 00 00";  ChangeBytes -Offset "C94548" -Values "00 00 00 00";  ChangeBytes -Offset "C94730" -Values "00 00 00 00" # Phantom Ganon
        ChangeBytes -Offset "C945A8" -Values "00 00 00 00";  ChangeBytes -Offset "C94594" -Values "00 00 00 00"

        ChangeBytes -Offset "2F5AF84" -Values "00 00 00 05"; ChangeBytes -Offset "2F5C7DA" -Values "00 01 00 02"; ChangeBytes -Offset "2F5C7A2" -Values "00 03 00 04" # Nabooru
        ChangeBytes -Offset "2F5B369" -Values "09";          ChangeBytes -Offset "2F5B491" -Values "04";          ChangeBytes -Offset "2F5B559" -Values "04"
        ChangeBytes -Offset "2F5B621" -Values "04";          ChangeBytes -Offset "2F5B761" -Values "07";          ChangeBytes -Offset "2F5B840" -Values "00 05 00 01 00 05 00 05" # Shorten white flash

        ChangeBytes -Offset "D67BA4" -Values "10 00";        ChangeBytes -Offset "D678CC" -Values "24 01 03 A2 A6 01 01 42" # Twinrova

        ChangeBytes -Offset "D82047" -Values "09" # Ganondorf

        ChangeBytes -Offset "D82AB3" -Values "66";           ChangeBytes -Offset "D82FAF" -Values "65";           ChangeBytes -Offset "D82D2E" -Values "04 1F" # Zelda Descend
        ChangeBytes -Offset "D83142" -Values "00 6B";        ChangeBytes -Offset "D82DD8" -Values "00 00 00 00";  ChangeBytes -Offset "D82ED4" -Values "00 00 00 00"
        ChangeBytes -Offset "D82FDF" -Values "33"

        ChangeBytes -Offset "E82E0F" -Values "04" # After Tower Collapse

        ChangeBytes -Offset "E83D28" -Values "00 00 00 00";  ChangeBytes -Offset "E83B5C" -Values "00 00 00 00";  ChangeBytes -Offset "E84C80" -Values "10 00" # Ganon Intro
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

    if (IsChecked $Redux.Skip.OpeningCutscene)       { ChangeBytes -Offset "B06BBA"  -Values "00 00"                                                                                    }
    if (IsChecked $Redux.Skip.DaruniaDance)          { ChangeBytes -Offset "22769E4" -Values "FF FF FF FF"                                                                              }
    if (IsChecked $Redux.Skip.ZeldaEscape)           { ChangeBytes -Offset "1FC0CF8" -Values "00 00 00 01 00 21 00 01 00 02 00 02"                                                      }
    if (IsChecked $Redux.Skip.JabuJabu)              { ChangeBytes -Offset "CA0784"  -Values "00 18 00 01 00 02 00 02"                                                                  }
    if (IsChecked $Redux.Skip.GanonTower)            { ChangeBytes -Offset "33FB328" -Values "00 76 00 01 00 02 00 02"                                                                  }
    if (IsChecked $Redux.Skip.Medallions)            { ChangeBytes -Offset "2512680" -Values "00 76 00 01 00 02 00 02"                                                                  }
    if (IsChecked $Redux.Skip.AllMedallions)         { ChangeBytes -Offset "ACA409"  -Values "AD";                      ChangeBytes -Offset "ACA49D"  -Values "CE"                      }
    if (IsChecked $Redux.Speedup.OpeningChests)      { ChangeBytes -Offset "BDA2E8"  -Values "24 0A FF FF"                                                                              }
    if (IsChecked $Redux.Speedup.KingZora)           { ChangeBytes -Offset "E56924"  -Values "00 00 00 00"                                                                              }
    if (IsChecked $Redux.Speedup.OwlFlights)         { ChangeBytes -Offset "20E60D2" -Values "00 01";                   ChangeBytes -Offset "223B6B2" -Values "00 01"                   }
    if (IsChecked $Redux.Speedup.EponaRace)          { ChangeBytes -Offset "29BE984" -Values "00 00 00 02";             ChangeBytes -Offset "29BE9CA" -Values "00 01 00 02"             }
    if (IsChecked $Redux.Speedup.EponaEscape)        { ChangeBytes -Offset "1FC8B36" -Values "00 2A"                                                                                    }
    if (IsChecked $Redux.Speedup.HorsebackArchery)   { ChangeBytes -Offset "21B2064" -Values "00 00 00 02";             ChangeBytes -Offset "21B20AA" -Values "00 01 00 02"             }
    if (IsChecked $Redux.Speedup.DoorOfTime)         { ChangeBytes -Offset "E0A176"  -Values "00 02";                   ChangeBytes -Offset "E0A35A"  -Values "00 01 00 02"             }
    if (IsChecked $Redux.Speedup.DrainingTheWell)    { ChangeBytes -Offset "E0A010"  -Values "00 2A 00 01 00 02 00 02"; ChangeBytes -Offset "2001110" -Values "00 2B 00 B7 00 B8 00 B8" }



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



    # MASTER QUEST #

    PatchDungeonsOoTMQ



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
        PatchBytes -Offset "289CA90" -Texture -Patch "Gerudo Symbols\gerudo_training_ground_ceiling_frame.bin"
        PatchBytes -Offset "28BBCD8" -Texture -Patch "Gerudo Symbols\gerudo_training_ground_room_5.bin"
        PatchBytes -Offset "28CA728" -Texture -Patch "Gerudo Symbols\gerudo_training_ground_room_5.bin"
        PatchBytes -Offset "11FB000" -Texture -Patch "Gerudo Symbols\gerudo_training_ground_door.bin"

        $Offset = SearchBytes -Start "2AF8000" -End "2B08F40" -Values "00 05 00 11 06 00 06 4E 06 06 06 06 11 11 06 11"
        PatchBytes -Offset $Offset -Texture -Patch "Gerudo Symbols\spirit_temple_room_0_pillars.bin"
    }



    # SCRIPT

    if (IsChecked $Redux.Text.KeatonMaskFix) {
        if (TestFile ($GameFiles.textures + "\Text Labels\keaton_mask" + $LanguagePatch.code + ".label"))   { PatchBytes -Offset "89F800" -Texture -Patch ("Text Labels\keaton_mask" + $LanguagePatch.code + ".label") }
    }

    if (IsChecked $Redux.Text.Fairy) {
        if (TestFile ($GameFiles.textures + "\Text Labels\fairy" + $LanguagePatch.code + ".label"))         { PatchBytes -Offset "8A4C00" -Texture -Patch ("Text Labels\fairy" + $LanguagePatch.code + ".label") }
    }

    if (IsChecked $Redux.Text.Milk) {
        if (TestFile ($GameFiles.textures + "\Text Labels\milk" + $LanguagePatch.code + ".label"))          { PatchBytes -Offset "8A5400" -Texture -Patch ("Text Labels\milk" + $LanguagePatch.code + ".label") }
        if (TestFile ($GameFiles.textures + "\Text Labels\milk_half" + $LanguagePatch.code + ".label"))     { PatchBytes -Offset "8A6800" -Texture -Patch ("Text Labels\milk_half" + $LanguagePatch.code + ".label") }
    }

    if (IsChecked $Redux.Text.CheckPrompt)   { PatchBytes -Offset "8E2D00" -Texture -Patch "Action Prompts\check_de.bin" }
    if (IsChecked $Redux.Text.DivePrompt)    { PatchBytes -Offset "8E3600" -Texture -Patch "Action Prompts\dive_de.bin"  }
    if (IsChecked $Redux.Text.NaviPrompt)    { PatchBytes -Offset "8E3A80" -Texture -Patch "Action Prompts\navi.bin"; ChangeBytes -Offset "AE7CD8" -Values "00 00 00 00" }

}



#==============================================================================================================================================================================================
function ByteReduxOptions() {
    
    # INTERFACE ICONS #

    if (IsChecked $Redux.UI.ShowFileSelectIcons)   { PatchBytes  -Offset "BAF738" -Patch "file_select.bin" }
    if (IsChecked $Redux.UI.DPadLayoutShow)        { ChangeBytes -Offset "348086E" -Values "01" }



     # BUTTON COLORS #

     if (IsDefaultColor -Elem $Redux.Colors.SetButtons[0] -Not) { # A Button
        ChangeBytes -Offset "3480845" -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) -Interval 2
        ChangeBytes -Offset "3480863" -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) -Interval 2 # Note Button

        # A Button - Text Cursor
        ChangeBytes -Offset "B88E81"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) -Interval 4

        # A Button - Pause Menu Cursor
        ChangeBytes -Offset "BC7849"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) -Interval 2
        ChangeBytes -Offset "BC78A9"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) -Interval 2
        ChangeBytes -Offset "BC78BB"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) -Interval 2

        # A Button - Pause Menu Icon
        ChangeBytes -Offset "845754"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)

        # A Button - Save/Death Cursor
        ChangeBytes -Offset "BBEBC2"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G) # Red + Green
        ChangeBytes -Offset "BBEBD6"  -IsDec -Values   $Redux.Colors.SetButtons[0].Color.B # Blue
        ChangeBytes -Offset "BBEDDA"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G) # Red + Green
        ChangeBytes -Offset "BBEDDE"  -IsDec -Values   $Redux.Colors.SetButtons[0].Color.B # Blue

        # A Button - Note
        ChangeBytes -Offset "BB299A"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G) # Red + Green
        ChangeBytes -Offset "BB299E"  -IsDec -Values   $Redux.Colors.SetButtons[0].Color.B # Blue
        ChangeBytes -Offset "BB2C8E"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G) # Red + Green
        ChangeBytes -Offset "BB2C92"  -IsDec -Values   $Redux.Colors.SetButtons[0].Color.B # Blue
        ChangeBytes -Offset "BB2F8A"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G) # Red + Green
        ChangeBytes -Offset "BB2F96"  -IsDec -Values   $Redux.Colors.SetButtons[0].Color.B # Blue
    }

    if (IsDefaultColor -Elem $Redux.Colors.SetButtons[1] -Not) { ChangeBytes -Offset "348084B" -IsDec -Values @($Redux.Colors.SetButtons[1].Color.R, $Redux.Colors.SetButtons[1].Color.G, $Redux.Colors.SetButtons[1].Color.B) -Interval 2 } # B Button 

    if (IsDefaultColor -Elem $Redux.Colors.SetButtons[2] -Not) { # C Buttons
        ChangeBytes -Offset "3480851" -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) -Interval 2
        
        if ($Redux.Colors.Buttons.Text -eq "Randomized" -or $Redux.Colors.Buttons.Text -eq "Custom") {
            # C Buttons - Pause Menu Cursor
            ChangeBytes -Offset "BC7843" -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) -Interval 2
            ChangeBytes -Offset "BC7891" -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) -Interval 2
            ChangeBytes -Offset "BC78A3" -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) -Interval 2

            # C Buttons - Pause Menu Icon
            ChangeBytes -Offset "8456FC" -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B)

            # C Buttons - Note Color
            ChangeBytes -Offset "BB2996" -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G) # Red + Green
            ChangeBytes -Offset "BB29A2" -IsDec -Values   $Redux.Colors.SetButtons[2].Color.B # Blue
            ChangeBytes -Offset "BB2C8A" -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G) # Red + Green
            ChangeBytes -Offset "BB2C96" -IsDec -Values   $Redux.Colors.SetButtons[2].Color.B # Blue
            ChangeBytes -Offset "BB2F86" -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G) # Red + Green
            ChangeBytes -Offset "BB2F9A" -IsDec -Values   $Redux.Colors.SetButtons[2].Color.B # Blue
        }
    }

    if (IsDefaultColor -Elem $Redux.Colors.SetButtons[3] -Not) { # Start Button
        ChangeBytes -Offset "AE9EC6" -IsDec -Values @($Redux.Colors.SetButtons[3].Color.R, $Redux.Colors.SetButtons[3].Color.G) # Red + Green
        ChangeBytes -Offset "AE9ED8" -IsDec -Values @("53", "238", $Redux.Colors.SetButtons[3].Color.B) # Blue
    }



    # HUD COLORS #

    if (IsChecked $Redux.UI.GCScheme) {
        ChangeBytes -Offset "348085F" -Values "FF 00 50" # Cursor
        ChangeBytes -Offset "3480859" -Values "C8 00 50" # Cursor
    }

}



#==============================================================================================================================================================================================
function ByteLanguageOptions() {
    
    if ( (IsChecked -Elem $Redux.Text.Vanilla -Not) -or (IsChecked -Elem $Redux.Text.Speed1x -Not) -or (IsChecked $Redux.UI.GCScheme) -or (IsLanguage $Redux.Unlock.Tunics) -or (IsText -Elem $Redux.Colors.Fairy -Compare "Tatl") -or (IsText -Elem $Redux.Colors.Fairy -Compare "Tael") -or (IsLanguage $Redux.Capacity.EnableAmmo) -or (IsLanguage $Redux.Capacity.EnableWallet)-or (IsLanguage $Redux.Equipment.IronShield -and $ChildModel.deku_shield -ne 0) ) {
        if ( (IsSet $LanguagePatch.script_start) -and (IsSet $LanguagePatch.script_length) ) {
            $script = $GameFiles.extracted + "\message_data_static.bin"
            $table  = $GameFiles.extracted + "\message_data.tbl"
            ExportBytes -Offset $LanguagePatch.script_start -Length $LanguagePatch.script_length -Output $script -Force
            ExportBytes -Offset "B849EC" -Length "43A8" -Output $table -Force
            $lengthDifference = (Get-Item ($GameFiles.extracted + "\message_data_static.bin")).length
        }
        else  { return }
    }
    else { return }

    if (IsChecked $Redux.Text.Redux) { ApplyPatch -File $script -Patch "\Export\Message\redux_static.bps" }
    elseif (IsChecked $Redux.Text.Restore) {
        ChangeBytes -Offset "7596" -Values "52 40"
        ApplyPatch -File $script -Patch "\Export\Message\restore_static.bps"
        ApplyPatch -File $table  -Patch "\Export\Message\restore_table.bps"
    }
    elseif (IsChecked $Redux.Text.Beta) {
        ChangeBytes -Offset "7596" -Values "52 40"
        ApplyPatch -File $script -Patch "\Export\Message\ura_static.bps"
        ApplyPatch -File $table  -Patch "\Export\Message\ura_table.bps"
    }
    elseif (IsChecked $Redux.Text.FemalePronouns) {
        ChangeBytes -Offset "7596" -Values "52 40"
        ApplyPatch -File $script -Patch "\Export\Message\female_pronouns_static.bps"
        ApplyPatch -File $table  -Patch "\Export\Message\female_pronouns_table.bps"
    }
    elseif (IsChecked $Redux.Text.Custom) {
        if ( (TestFile ($Gamefiles.customText + "\message_data_static.bin") ) -and (TestFile ($Gamefiles.customText + "\message_data.tbl") ) ) {
            Copy-Item -LiteralPath ($Gamefiles.customText + "\message_data_static.bin") -Destination ($GameFiles.extracted + "\message_data_static.bin") -Force
            Copy-Item -LiteralPath ($Gamefiles.customText + "\message_data.tbl")        -Destination ($GameFiles.extracted + "\message_data.tbl")        -Force
        }
        else {
            WriteToConsole "Custom Text could not be found. All text changes will be discarded."
            return   
        }
    }

    $lengthDifference = (Get-Item ($GameFiles.extracted + "\message_data_static.bin")).length - $lengthDifference
    if ($lengthDifference -ne 0) {
        $newDma = (Get16Bit ((GetDecimal "5130") + $lengthDifference)) -split '(..)' -ne ''
        ChangeBytes -Offset "7596" -Values $newDma
    }

    if (IsChecked $Redux.Text.Speed2x) {
        ChangeBytes -Offset "B5006F" -Values "02" # Text Speed

        if ($Redux.Language[0].checked) {
            # Correct Ruto Confession Textboxes
            $Offset = SearchBytes -File $script -Values "1A 41 73 20 61 20 72 65 77 61 72 64 2E 2E 2E 01"
            PatchBytes -File $script -Offset $Offset -Patch "Message\ruto_confession.bin"

            # Correct Phantom Ganon Defeat Textboxes
            $Offset = SearchBytes -File $script -Values "0C 3C 42 75 74 20 79 6F 75 20 68 61 76 65 20 64"
            ChangeBytes -File $script -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "01") ) ) -Values "66"
            ChangeBytes -File $script -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "5D") ) ) -Values "66"
            ChangeBytes -File $script -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "BA") ) ) -Values "60"
        }
    }
    elseif (IsChecked $Redux.Text.Speed3x) {
        ChangeBytes -Offset "B5006F" -Values "03" # Text Speed

        # Correct Learning Song Textboxes
        $Offset = SearchBytes -File $script -Values "08 06 3C 50 6C 61 79 20 75 73 69 6E 67 20 05"
        PatchBytes -File $script -Offset $Offset -Patch "Message\songs.bin"

        # Correct Ruto Confession Textboxes
        $Offset = SearchBytes -File $script -Values "1A 41 73 20 61 20 72 65 77 61 72 64 2E 2E 2E 01"
        PatchBytes -File $script -Offset $Offset -Patch "Message\ruto_confession.bin"
        
        # Correct Phantom Ganon Defeat Textboxes
        $Offset = SearchBytes -File $script -Values "0C 3C 42 75 74 20 79 6F 75 20 68 61 76 65 20 64"
        ChangeBytes -File $script -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "01") ) ) -Values "76"
        ChangeBytes -File $script -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "5D") ) ) -Values "76"
        ChangeBytes -File $script -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "BA") ) ) -Values "70"
    }
        
    if (IsChecked $Redux.UI.GCScheme) {
        if (IsChecked $Redux.Language[0]) { # English only
            # Hole of Z
            $Offset = SearchBytes -File $script -Values "48 6F 6C 65 20 6F 66 20 22 5A 22"
            ChangeBytes -File $script -Offset $Offset -Values "48 6F 6C 65 20 6F 66 20 22 4C 22"

            # GC Colors
            $Offset = SearchBytes -File $script -Values "62 6C 75 65 20 69 63 6F 6E 05 40 02 00 00 54 68"
            ChangeBytes -File $script -Offset $Offset -Values "67 72 65 65 6E 20 69 63 6F 6E 05 40 02"
            
            $Offset = SearchBytes -File $script -Values "1A 05 44 59 6F 75 20 63 61 6E 20 6F 70 65 6E 20"
            PatchBytes  -File $script -Offset $Offset -Patch "Message\mq_navi_door.bin"
            
            $Offset = SearchBytes -File $script -Values "62 6C 75 65 20 69 63 6F 6E 20 61 74 20 74 68 65"
            PatchBytes  -File $script -Offset $Offset -Patch "Message\mq_navi_action.bin"
        }

        $offset = 0
        do { # # Color codes
            $offset = SearchBytes -File $script -Start $offset -Values "05" -Suppress
            if ($offset -ge 0) {
                ChangeBytes -File $script -Offset $offset -Match "05 43 9F"                -Values "05 42" # A Button icon
                ChangeBytes -File $script -Offset $offset -Match "05 43 20 9F"             -Values "05 42" # A Button icon
                ChangeBytes -File $script -Offset $offset -Match "05 43 41 63 74 69 6F 6E" -Values "05 42" # Action Button text
                ChangeBytes -File $script -Offset $offset -Match "05 42 A0"                -Values "05 41" # B Button icon
                ChangeBytes -File $script -Offset $offset -Match "05 41 53 54 41 52 54"    -Values "05 44" # Start Button text
                $offset = AddToOffset -Hex $offset -Add "1"
            }
        } while ($offset -ge 0)
    }

    if (IsLanguage $Redux.Unlock.Tunics) {
        $Offset = SearchBytes -File $script -Values "59 6F 75 20 67 6F 74 20 61 20 05 41 47 6F 72 6F 6E 20 54 75 6E 69 63"
        ChangeBytes -File $script -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "39") ) ) -Values "75 6E 69 73 69 7A 65 2C 20 73 6F 20 69 74 20 66 69 74 73 20 61 64 75 6C 74 20 61 6E 64"
        ChangeBytes -File $script -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "B3") ) ) -Values "75 6E 69 73 69 7A 65 2C 01 73 6F 20 69 74 20 66 69 74 73 20 61 64 75 6C 74 20 61 6E 64"

        $Offset = SearchBytes -File $script -Values "41 20 74 75 6E 69 63 20 6D 61 64 65 20 62 79 20 47 6F 72 6F 6E 73"
        ChangeBytes -File $script -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "18") ) ) -Values "55 6E 69 2D 20"
        ChangeBytes -File $script -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "7A") ) ) -Values "55 6E 69 73 69 7A 65 2E 20 20 20"
    }

    if (IsText -Elem $Redux.Colors.Fairy -Compare "Tatl") {
        $offset = 0
        do { # Navi -> Tatl
            $offset = SearchBytes -File $script -Start $offset -Values "4E 61 76 69"
            if ($offset -ge 0) { ChangeBytes -File $script -Offset $offset -Values "54 61 74 6C" }
        } while ($offset -ge 0)
        PatchBytes -Offset "1A3EFC0" -Texture -Patch "HUD\tatl.bin"
    }
    elseif (IsText -Elem $Redux.Colors.Fairy -Compare "Tael") {
        $offset = 0
        do { # Navi -> Tael
            $offset = SearchBytes -File $script -Start $offset -Values "4E 61 76 69"
            if ($offset -ge 0) { ChangeBytes -File $script -Offset $offset -Values "54 61 65 6C" }
        } while ($offset -ge 0)
        PatchBytes -Offset "1A3EFC0" -Texture -Patch "HUD\tael.bin"
    }

    if (IsLanguage $Redux.Capacity.EnableAmmo) {
        ChangeStringIntoDigits -File $script -Search "34 30 20 05 40 69 6E 20 74 6F 74 61 6C"    -Value $Redux.Capacity.Quiver2.Text
        ChangeStringIntoDigits -File $script -Search "35 30 05 40 21 02 00 00 1A 13"             -Value $Redux.Capacity.Quiver3.Text

        if ([int]$Redux.Capacity.BombBag1.Text -ge 20) {
        ChangeStringIntoDigits -File $script -Search "32 30 20 42 6F 6D 62 73"                   -Value $Redux.Capacity.BombBag1.Text }
        ChangeStringIntoDigits -File $script -Search "33 30 05 40 21 02 00 1A 13"                -Value $Redux.Capacity.BombBag2.Text
        ChangeStringIntoDigits -File $script -Search "34 30 05 40 20 42 6F 6D 62 73"             -Value $Redux.Capacity.BombBag3.Text

        ChangeStringIntoDigits -File $script -Search "34 30 05 40 01 73 6C 69 6E 67 73 68 6F 74" -Value $Redux.Capacity.BulletBag2.Text
        ChangeStringIntoDigits -File $script -Search "35 30 05 41 20 05 40 62 75 6C 6C 65 74 73" -Value $Redux.Capacity.BulletBag3.Text

        ChangeStringIntoDigits -File $script -Search "31 30 20 73 74 69 63 6B 73"                -Value $Redux.Capacity.DekuSticks1.Text
        ChangeStringIntoDigits -File $script -Search "32 30 05 40 20 6F 66 20 74 68 65 6D"       -Value $Redux.Capacity.DekuSticks2.Text
        ChangeStringIntoDigits -File $script -Search "33 30 05 40 20 6F 66 20 74 68 65 6D"       -Value $Redux.Capacity.DekuSticks3.Text

        ChangeStringIntoDigits -File $script -Search "33 30 05 40 20 6E 75 74 73"                -Value $Redux.Capacity.DekuNuts2.Text
        ChangeStringIntoDigits -File $script -Search "34 30 05 41 20 05 40 6E 75 74 73"          -Value $Redux.Capacity.DekuNuts3.Text
    }

    if (IsLanguage $Redux.Capacity.EnableWallet) {
        if ($Redux.Capacity.Wallet2.Text.Length -gt 3)   { $Text = "999" }
        else                                             { $Text = $Redux.Capacity.Wallet2.Text }
        ChangeStringIntoDigits -File $script -Search "32 30 30 05 40 20 05 46 52 75 70 65 65 73 05 40 2E 02 00" -Value $Text -Triple

        if ($Redux.Capacity.Wallet3.Text.Length -gt 3)   { $Text = "999" }
        else                                             { $Text = $Redux.Capacity.Wallet3.Text }
        ChangeStringIntoDigits -File $script -Search "35 30 30 05 40 20 05 46 52 75 70 65 65 73 05 40 2E 02 13" -Value $Text -Triple

        $Text = $null
    }

    if (IsLanguage $Redux.Equipment.IronShield -and $ChildModel.deku_shield -ne 0) {
        $offset = 0
        do { # Deku Shield -> Iron Shield
            $offset = SearchBytes -File $script -Start $offset -Values "44 65 6B 75 20 53 68 69 65 6C 64"
            if ($offset -ge 0) { ChangeBytes -File $script -Offset $offset -Values "49 72 6F 6E 20 53 68 69 65 6C 64" }
        } while ($offset -ge 0)
    }

    PatchBytes -Offset $LanguagePatch.script_start -Patch "message_data_static.bin" -Extracted
    PatchBytes -Offset "B849EC"                    -Patch "message_data.tbl"        -Extracted

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    if     (CheckInterfaceMode -Beginner $True)   { CreateOptionsDialog -Columns 6 -Height 520 -Tabs @("Main", "Graphics", "Audio", "Difficulty") }
    elseif (CheckInterfaceMode -Lite     $True)   { CreateOptionsDialog -Columns 6 -Height 630 -Tabs @("Main", "Graphics", "Audio", "Difficulty", "Capacity") }
    elseif (CheckInterfaceMode -Advanced $True)   { CreateOptionsDialog -Columns 6 -Height 720 -Tabs @("Main", "Graphics", "Audio", "Difficulty", "Colors", "Equipment", "Capacity", "Animations") }

    if (CheckInterfaceMode -Beginner $True -Advanced $True) { 
        $Redux.Graphics.Widescreen.Add_CheckStateChanged(    { AdjustGUI } )
        $Redux.Graphics.WidescreenAlt.Add_CheckStateChanged( { AdjustGUI } )
    }

}



#==============================================================================================================================================================================================
function AdjustGUI() {
   
    if (CheckInterfaceMode -Lite $True) { return }

    EnableElem -Elem $Redux.Graphics.Widescreen    -Active (!$Redux.Graphics.WidescreenAlt.Checked -and !$Patches.Redux.Checked -and !$IswiiVC)
    EnableElem -Elem $Redux.Graphics.WidescreenAlt -Active (!$Redux.Graphics.Widescreen.Checked)

    if ($Redux.Graphics.Widescreen.Enabled -eq $False -and $Redux.Graphics.WidescreenAlt.Enabled -eq $False) { EnableElem -Elem $Redux.Graphics.WidescreenAlt -Active $True }
    if (!$Redux.Graphics.Widescreen.Enabled)      { $Redux.Graphics.Widescreen.Checked    = $False }
    if (!$Redux.Graphics.WidescreenAlt.Enabled)   { $Redux.Graphics.WidescreenAlt.Checked = $False }

}



#==============================================================================================================================================================================================
function CreateTabMain() {

    # GAMEPLAY #

    CreateReduxGroup    -Tag  "Gameplay" -Text "Gameplay" 
    CreateReduxCheckBox -Name "FasterBlockPushing" -Checked -Text "Faster Block Pushing"  -Beginner -Advanced -Info "All blocks are pushed faster" -Credits "GhostlyDark (Ported from Redux)"
    CreateReduxCheckBox -Name "EasierMinigames"             -Text "Easier Minigames"      -Beginner -Advanced -Info "Certain minigames are made easier and faster`n- Dampe's Digging Game is first try always`n- Fishing is less random and has less demanding requirements`n- Bombchu Bowling prizes now appear in fixed order instead of random" -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "ReturnChild"                 -Text "Can Always Return"     -Beginner -Advanced -Info "You can always go back to being a child again before clearing the boss of the Forest Temple`nOut of the way Sheik!"            -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "Medallions"                  -Text "Require All Medallions"          -Advanced -Info "All six medallions are required for the Rainbow Bridge to appear before Ganon's Castle`nThe vanilla requirements were the Shadow and Spirit Medallions and the Light Arrows" -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "RutoNeverDisappears"         -Text "Ruto Never Disappears" -Beginner -Advanced -Info "Ruto never disappears in Jabu Jabu's Belly and will remain in place when leaving the room"                                     -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "AlwaysMoveKingZora"          -Text "Always Move King Zora"           -Advanced -Info "King Zora will move aside even if the Zora Sapphire is in possession"                                                          -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "DistantZTargeting"           -Text "Distant Z-Targeting"             -Advanced -Info "Allow to use Z-Targeting on enemies, objects and NPC's from any distance"                                                      -Credits "Admentus"
    CreateReduxCheckBox -Name "ManualJump"                  -Text "Manual Jump"               -Lite -Advanced -Info "Press Z + A to do a Manual Jump instead of a Jump Attack`nPress B mid-air after jumping to do a Jump Attack"                   -Credits "Admentus (ROM hack) & CloudModding (GameShark)"
    CreateReduxCheckBox -Name "NoKillFlash"                 -Text "No Kill Flash"             -Lite -Advanced -Info "Disable the flash effect when killing certain enemies such as the Guay or Skullwalltula"                                       -Credits "Chez Cousteau"
    CreateReduxCheckBox -Name "NoShieldRecoil"              -Text "No Shield Recoil"          -Lite -Advanced -Info "Disable the recoil when being hit while shielding"                                                                             -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxCheckBox -Name "RunWhileShielding"           -Text "Run While Shielding"       -Lite -Advanced -Info "Press R to shield will no longer prevent Link from moving around" -Link $Redux.Gameplay.NoShieldRecoil                         -Credits "Admentus (ported) & Aegiker (Debug)"
    CreateReduxCheckBox -Name "PushbackAttackingWalls"      -Text "Pushback Attacking Walls"  -Lite -Advanced -Info "Link is getting pushed back a bit when hitting the wall with the sword"                                                        -Credits "Admentus (ported) & Aegiker (Debug)"
    CreateReduxCheckBox -Name "SpawnLinksHouse"             -Text "Adult Spawns in Link's House"              -Info "Saving the game anywhere outside of a dungeon will make Adult start the session in Link's House instead of the Temple of Time" -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "AllowWarpSongs"              -Text "Allow Warp Songs"      -Beginner -Advanced -Info "Allow warp songs in Gerudo Training Ground and Ganon's Castle"                                                                 -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "AllowFaroreWind"             -Text "Allow Farore's Wind"   -Beginner -Advanced -Info "Allow Farore's Wind in Gerudo Training Ground and Ganon's Castle"                                                              -Credits "Ported from Rando"


    # RESTORE #

    CreateReduxGroup    -Tag  "Restore" -Text "Restore / Correct / Censor"
    CreateReduxCheckBox -Name "RupeeColors"    -Text "Correct Rupee Colors"             -Info "Corrects the colors for the Purple (50) and Golden (200) Rupees"         -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "CowNoseRing"    -Text "Restore Cow Nose Ring"            -Info "Restore the rings in the noses for Cows as seen in the Japanese release" -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "FireTemple"     -Text "Censor Fire Temple"     -Advanced -Info "Censor Fire Temple theme as used in the Rev 2 ROM" -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "GerudoTextures" -Text "Censor Gerudo Textures" -Advanced -Info "Censor Gerudo symbol textures used in the GameCube / Virtual Console releases`n- Disable the option to uncensor the Gerudo Texture used in the Master Quest dungeons`n- Player model textures such as the Mirror Shield might not get restored for specific custom models" -Credits "GhostlyDark & ShadowOne333"
    CreateReduxComboBox -Name "Blood"          -Text "Blood Color"      -Lite -Advanced -Info "Change the color of blood used for several monsters, Ganondorf and Ganon" -Items @("Default", "Red blood for monsters", "Green blood for Ganondorf/Ganon", "Change both") -Credits "ShadowOne333 & Admentus"
    


    # FIXES #

    CreateReduxGroup    -Tag  "Fixes" -Text "Fixes"
    CreateReduxCheckBox -Name "PauseScreenDelay"     -Text "Pause Screen Delay"      -Checked        -Info "Removes the delay when opening the Pause Screen by removing the anti-aliasing" -Native                                                                -Credits "zel"
    CreateReduxCheckBox -Name "PauseScreenCrash"     -Text "Pause Screen Crash Fix"  -Checked        -Info "Prevents the game from randomly crashing emulating a decompressed ROM upon pausing"                                                                   -Credits "zel"
    CreateReduxCheckBox -Name "Graves"               -Text "Graveyard Graves"                        -Info "The grave holes in Kakariko Graveyard behave as in the Rev 1 revision`nThe edges no longer force Link to grab or jump over them when trying to enter" -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "VisibleGerudoTent"    -Text "Visible Gerudo Tent"     -Lite -Advanced -Info "Make the tent in the Gerudo Valley during the Child era visible`nThe tent was always accessible, just invisible"                                      -Credits "Chez Cousteau"
    CreateReduxCheckBox -Name "PoacherSaw"           -Text "Poacher's Saw"           -Checked        -Info "Obtaining the Poacher's Saw no longer prevents Link from obtaining the second Deku Nut upgrade"                                                       -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "Boomerang"            -Text "Boomerang"               -Lite -Advanced -Info "Fix the gem color on the thrown boomerang"                                                                                                            -Credits "Aria"
    CreateReduxCheckBox -Name "TimeDoor"             -Text "Temple of Time Door"     -Lite -Advanced -Info "Fix the positioning of the Temple of Time door, so you can not skip past it"                                                                          -Credits "Chez Cousteau"
    CreateReduxCheckBox -Name "NaviTarget"           -Text "Navi Targettable Spots"  -Lite -Advanced -Info "Fix several spots in dungeons which Navi could not target for Link"                                                                                   -Credits "Chez Cousteau"
    CreateReduxCheckBox -Name "AddWaterTempleActors" -Text "Add Water Temple Actors"       -Advanced -Info "Add several actors in the Water Temple`nUnreachable hookshot spot in room 22, three out of bounds pots, restore two Keese in room 1"                  -Credits "Chez Cousteau"
    CreateReduxCheckBox -Name "AddLostWoodsOctorok"  -Text "Add Lost Woods Octorok"        -Advanced -Info "Add an Octorok actor in the Lost Woods area which leads to Zora's River"                                                                              -Credits "Chez Cousteau"
    CreateReduxCheckBox -Name "FortressMinimap"      -Text "Gerudo Fortress Minimap" -Lite -Advanced -Info "Display the complete minimap for the Gerudo Fortress during the Child era"                                                                            -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "SpiritTempleMirrors"  -Text "Spirit Temple Mirrors"   -Lite -Advanced -Info "Fix a broken effect with the mirrors in the Spirit Temple"                                                                                            -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool) & GhostlyDark (ported)"



    # OTHER #

    CreateReduxGroup    -Tag  "Other" -Text "Other"
    CreateReduxCheckBox -Name "RemoveOwls"                 -Text "Remove Owls"             -Beginner -Advanced -Info "Kaepora Gaebora the owl will no longer interrupt Link with tutorials"                                                   -Credits "Chez Cousteau"
    CreateReduxCheckBox -Name "RemoveNaviPrompts"          -Text "Remove Navi Prompts"     -Beginner -Advanced -Info "Navi will no longer interrupt you with text boxes in the first dungeon"                                                 -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "DefaultZTargeting"          -Text "Default Hold Z-Targeting"          -Advanced -Info "Change the Default Z-Targeting option to Hold instead of Switch"                                                        -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "InstantClaimCheck"          -Text "Instant Claim Check"     -Beginner -Advanced -Info "Remove the check for waiting until the Biggoron Sword can be claimed through the Claim Check"                           -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "ItemSelect"                 -Text "Translate Item Select"             -Advanced -Info "Translates the Debug Inventory Select menu into English"                                                                -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "DiskDrive"                  -Text "Enable Disk Drive Saves"           -Advanced -Info "Use the Disk Drive for Save Slots" -Warning "This option disables the use of non-Disk Drive save slots"                 -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool) & GhostlyDark (ported)"
    CreateReduxComboBox -Name "MapSelect" -Column 1 -Row 2 -Text "Enable Map Select" -Lite -Advanced -Items @("Disable", "Translate Only", "Enable Only", "Translate and Enable") -Info "Enable the Map Select menu like in the Debug ROM`nThe File Select menu now opens the Map Select menu instead`nA separate debug save file is used" -Credits "Jared Johnson (translated by Zelda Edit)"
    CreateReduxComboBox -Name "SkipIntro"                  -Text "Skip Intro"                        -Items @("Don't Skip", "Skip Logo", "Skip Title Screen", "Skip Logo and Title Screen") -Info "Skip the logo, title screen or both"       -Credits "Aegiker"
    
}



#==============================================================================================================================================================================================
function CreateTabRedux() {
    
    # INTERFACE #

    CreateReduxGroup    -Tag  "UI" -Text "Interface Icons"
    CreateReduxCheckBox -Name "ShowFileSelectIcons" -Checked -Text "Show File Select Icons" -Info "Show icons on the File Select screen to display your save file progress" -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "DPadLayoutShow"      -Checked -Text "Show D-Pad Icon"        -Info "Show the D-Pad icons ingame that display item shortcuts"                 -Credits "Ported from Redux"
    


    # BUTTON COLORS #

    CreateButtonColorOptions

}



#==============================================================================================================================================================================================
function CreateTabLanguage() {
    
    CreateLanguageContent



    # TEXT SPEED #

    CreateReduxGroup       -Tag  "Text" -Text "Text Speed"
    CreateReduxPanel
    CreateReduxRadioButton -Name "Speed1x" -Max 3 -SaveTo "Speed" -Checked -Text "1x Text Speed"   -Info "Leave the dialogue text speed at normal"
    CreateReduxRadioButton -Name "Speed2x" -Max 3 -SaveTo "Speed"          -Text "2x Text Speed"   -Info "Set the dialogue text speed to be twice as fast"       -Credits "Ported from Redux"
    CreateReduxRadioButton -Name "Speed3x" -Max 3 -SaveTo "Speed"          -Text "3x Text Speed"   -Info "Set the dialogue text speed to be three times as fast" -Credits "Ported from Redux"
    


    # ENGLISH DIALOGUE #

    $Redux.Box.Dialogue = CreateReduxGroup -Tag "Text" -Text "English Dialogue"
    CreateReduxPanel
    CreateReduxRadioButton -Name "Vanilla"        -Max 6 -SaveTo "Dialogue"          -Text "Vanilla Text"              -Info "Keep the text as it is"
    CreateReduxRadioButton -Name "Redux"          -Max 6 -SaveTo "Dialogue" -Checked -Text "Redux Text"                -Info "Include the changes from the Redux script such as being able to move during the Gold Skulltula Token textboxes" -Credits "Redux"
    CreateReduxRadioButton -Name "Restore"        -Max 6 -SaveTo "Dialogue"          -Text "Restore Text"              -Info ("Restores the text used from the GC revision and applies grammar and typo fixes`nAlso corrects some icons in the text`n" + 'Includes the changes from "Redux Text" as well') -Credits "Redux"
    CreateReduxRadioButton -Name "Beta"           -Max 6 -SaveTo "Dialogue"          -Text "Beta Text"       -Advanced -Info "Restores the text as was used during the Ura Quest Beta version" -Credits "ZethN64, Sakura, Frostclaw & Steve(ToCoool)"
    CreateReduxRadioButton -Name "FemalePronouns" -Max 6 -SaveTo "Dialogue"          -Text "Female Pronouns"           -Info "Refer to Link as a female character" -Credits "Admentus & Mil`n(includes Restore Text by ShadowOne)"
    CreateReduxRadioButton -Name "Custom"         -Max 6 -SaveTo "Dialogue"          -Text "Custom"          -Advanced -Info 'Insert custom dialogue found from "..\Patcher64+ Tool\Files\Games\Ocarina of Time\Custom Text"' -Warning "Make sure your custom script is proper and correct, or your ROM will crash`n[!] No edit will be made if the custom script is missing"



    # OTHER ENGLISH OPTIONS #

    $Redux.Box.Text = CreateReduxGroup -Tag  "Text" -Text "Other English Options"
    CreateReduxCheckBox    -Name "KeatonMaskFix" -Text "Keaton Mask Text Fix" -Info 'Fixes the grammatical typo for the "Keaton Mask"'                        -Credits "Redux"
    CreateReduxCheckBox    -Name "Fairy"         -Text "MM Fairy Text"        -Info ("Changes " + '"Bottled Fairy" to "Fairy"' + " as used in Majora's Mask") -Credits "GhostlyDark (ported)"
    CreateReduxCheckBox    -Name "Milk"          -Text "MM Milk Text"         -Info ("Changes " + '"Lon Lon Milk" to "Milk"' + " as used in Majora's Mask")   -Credits "GhostlyDark (ported)"
    CreateReduxCheckBox    -Name "PauseScreen"   -Text "MM Pause Screen"      -Info "Replaces the Pause Screen textures to be styled like Majora's Mask"      -Credits "CM & GhostlyDark"



    # OTHER GERMAN OPTIONS #

    $Redux.Box.Text = CreateReduxGroup -Tag  "Text" -Text "Other German Options"
    CreateReduxCheckBox -Name "CheckPrompt" -Text "Read Action Prompt" -Info 'Replace the "Lesen" Action Prompt with "Ansehen"'     -Credits "Admentus, GhostlyDark & Ticamus"
    CreateReduxCheckBox -Name "DivePrompt"  -Text "Dive Action Prompt" -Info 'Replace the "Tauchen" Action Prompt with "Abtauchen"' -Credits "Admentus, GhostlyDark & Ticamus"


    # OTHER TEXT OPTIONS #

    $Redux.Box.Text = CreateReduxGroup -Tag "Text" -Text "Other Text Options"
    CreateReduxCheckBox -Name "NaviPrompt" -Text "Add Navi Prompt" -Info "Empty action prompt for calling Navi turned visible" -Credits "Aegiker & GhostlyDark (texture fix)"



    foreach ($i in 0.. ($Files.json.languages.length-1)) { $Redux.Language[$i].Add_CheckedChanged({ UnlockLanguageContent }) }
    UnlockLanguageContent

}



#==============================================================================================================================================================================================
function UnlockLanguageContent() {
    
    # English options
    EnableElem -Elem $Redux.Text.Vanilla        -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.Redux          -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.Restore        -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.Beta           -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.FemalePronouns -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.Custom         -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.KeatonMaskFix  -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.Fairy          -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.Milk           -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.PauseScreen    -Active $Redux.Language[0].Checked

    # German options
    EnableElem -Elem $Redux.Text.CheckPrompt    -Active $Redux.Language[1].Checked
    EnableElem -Elem $Redux.Text.DivePrompt     -Active $Redux.Language[1].Checked

    # Set max text speed in each language
    foreach ($i in 0.. ($Files.json.languages.length-1)) {
        if ($Redux.Language[$i].checked) {
            EnableElem -Elem @($Redux.Text.Speed1x, $Redux.Text.Speed2x, $Redux.Text.Speed3x) -Active $True
            if ($Files.json.languages[$i].max_text_speed -lt 3) {
                EnableElem -Elem $Redux.Text.Speed3x -Active $False
                if ($Redux.Text.Speed3x.Checked) { $Redux.Text.Speed2x.checked = $True }
            }
            if ($Files.json.languages[$i].max_text_speed -lt 2) {
                EnableElem -Elem @($Redux.Text.Speed1x, $Redux.Text.Speed2x) -Active $False
            }
        }
    }

}



#==============================================================================================================================================================================================
function CreateTabGraphics() {
    
    # GRAPHICS #

    CreateReduxGroup -Tag  "Graphics" -Text "Graphics" -Columns 4

    $Info  = "Patch the game to be in true 16:9 widescreen with the HUD pushed to the edges."
    $Info += "`n`nKnown Issues:"
    $Info += "`n- Backgrounds are 4:3 and centered showing collisions at the sides."
    $Info += "`n- Not compatible with Redux."

    CreateReduxCheckBox -Name "Widescreen"         -Text "16:9 Widescreen (Advanced)"   -Info $Info -Beginner -Advanced                                                                             -Credits "Widescreen Patch by gamemasterplc, enhanced and ported by GhostlyDark"
    CreateReduxCheckBox -Name "WidescreenAlt"      -Text "16:9 Widescreen (Simplified)" -Info "Apply 16:9 Widescreen adjusted backgrounds and textures (as well as 16:9 Widescreen for the Wii VC)" -Credits "Aspect Ratio Fix by Admentus`n16:9 backgrounds by GhostlyDark, ShadowOne333 & CYB3RTRON"
    CreateReduxCheckBox -Name "ExtendedDraw"       -Text "Extended Draw Distance"       -Info "Increases the game's draw distance for objects`nDoes not work on all objects"                        -Credits "Admentus"
    CreateReduxCheckBox -Name "ForceHiresModel"    -Text "Force Hires Link Model"       -Info "Always use Link's High Resolution Model when Link is too far away"                                   -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "HideEquipment"      -Text "Hide Equipment"               -Info "Hide the equipment when it is sheathed"                                                              -Credits "XModxGodX"
    CreateReduxCheckBox -Name "OverworldSkyboxes"  -Text "Overworld Skyboxes"           -Info "Use day and night skyboxes for all overworld areas lacking one" -Lite -Advanced                      -Credits "Admentus (ported) & BrianMp16 (AR Code)"
    CreateReduxCheckBox -Name "PointFiltering"     -Text "Point Filtering"              -Info "Use point filtering instead of the 3-point bilinear filtering"        -Advanced -Native              -Credits "Admentus" -Warning "This option will make the game look worse and more like a PlayStation 1 title"

    $Models = LoadModelsList -Category "Child"
    CreateReduxComboBox -Name "ChildModels" -Text "Child Model" -Items (@("Original") + $Models) -Default "Original" -Info "Replace the child model used for Link" -Row 3 -Column 1
    $Models = LoadModelsList -Category "Adult"
    CreateReduxComboBox -Name "AdultModels" -Text "Adult Model" -Items (@("Original") + $Models) -Default "Original" -Info "Replace the adult model used for Link"



    # MODELS PREVIEW #

    CreateReduxGroup -Tag "Graphics" -Text "Model Previews"
    $Last.Group.Height = (DPISize 252)

    CreateImageBox -x 20  -y 20 -w 154 -h 220 -Name "ModelsPreviewChild"
    CreateImageBox -x 210 -y 20 -w 154 -h 220 -Name "ModelsPreviewAdult"
    $global:PreviewToolTip = CreateToolTip
    ChangeModelsSelection
    


    # INTERFACE #

    CreateReduxGroup    -Tag  "UI" -Text "Interface"
    $Last.Group.Width = $Redux.Groups[$Redux.Groups.Length-3].Width; $Last.Group.Top = $Redux.Groups[$Redux.Groups.Length-3].Bottom + 5; $Last.Width = 4;
    CreateReduxCheckBox -Name "HUD"              -Text "MM HUD Icons"        -Info "Replace the HUD icons with that from Majora's Mask"          -Beginner                    -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "Hearts"           -Text "MM Heart Icons"      -Info "Replace the heart icons with those from Majora's Mask"       -Lite -Advanced              -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "Rupees"           -Text "MM Rupee Icon"       -Info "Replace the rupees icon with that from Majora's Mask"        -Lite -Advanced              -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "DungeonKeys"      -Text "MM Key Icon"         -Info "Replace the key icon with that from Majora's Mask"           -Lite -Advanced              -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "DungeonIcons"     -Text "MM Dungeon Icons"    -Info "Replace the dungeon map icons with those from Majora's Mask" -Lite -Advanced              -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "ButtonPositions"  -Text "MM Button Positions" -Info "Positions the A and B buttons like in Majora's Mask"                                      -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "CenterNaviPrompt" -Text "Center Navi Prompt"  -Info 'Centers the "Navi" prompt shown in the C-Up button'                                       -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "GCScheme"         -Text "GC Scheme"           -Info "Replace and change the textures, dialogue and text colors to match the GameCube's scheme" -Credits "Admentus, GhostlyDark, ShadowOne333 & Ported from Redux" -Warning "Dialogue changes are only available for the English language`n[!] Changing the textbox cursor color requires Redux to be enabled"
    CreateReduxComboBox -Name "ButtonSize"       -Text "HUD Buttons" -Row 3 -Column 1             -FilePath ($Paths.shared + "\Buttons")  -Ext $null -Default "Large"            -Info "Set the size for the HUD buttons" -Credits "GhostlyDark (ported)"
    $path = $Paths.shared + "\Buttons" + "\" + $Redux.UI.ButtonSize.Text.replace(" (default)", "")
    CreateReduxComboBox -Name "ButtonStyle"      -Text "HUD Buttons" -Items @("Ocarina of Time") -FilePath $path                          -Ext "bin" -Default "Ocarina of Time" -Info "Set the style for the HUD buttons" -Credits "GhostlyDark, Djipi, Community, Nerrel, Federelli"
    CreateReduxComboBox -Name "MagicBar"         -Text "Magic Bar"   -Items @("Ocarina of Time") -FilePath ($Paths.shared + "\HUD\Magic") -Ext "bin" -Default "Ocarina of Time" -Info "Set the style for the magic meter" -Credits "GhostlyDark, azred, Nerrel, Zeth Alkar"
    CreateReduxComboBox -Name "BlackBars"        -Text "Black Bars"  -Items @("Enabled", "Disabled for Z-Targeting", "Disabled for Cutscenes", "Always Disabled") -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes" -Credits "Admentus"

    
    
    # HIDE HUD #

    CreateReduxGroup    -Tag  "Hide"         -Text "Hide HUD"                -Columns 4
    CreateReduxCheckBox -Name "Interface"    -Text "Hide Interface"          -Info "Hide the whole interface"                                     -Credits "Admentus" -Beginner
    CreateReduxCheckBox -Name "AButton"      -Text "Hide A Button"           -Info "Hide the A Button"                                            -Credits "Admentus" -Lite -Advanced
    CreateReduxCheckBox -Name "BButton"      -Text "Hide B Button"           -Info "Hide the B Button"                                            -Credits "Admentus" -Lite -Advanced
    CreateReduxCheckBox -Name "StartButton"  -Text "Hide Start Button"       -Info "Hide the Start Button"                                        -Credits "Admentus" -Lite -Advanced
    CreateReduxCheckBox -Name "CUpButton"    -Text "Hide C-Up Button"        -Info "Hide the C-Up Button"                                         -Credits "Admentus" -Lite -Advanced
    CreateReduxCheckBox -Name "CLeftButton"  -Text "Hide C-Left Button"      -Info "Hide the C-Left Button"                                       -Credits "Admentus" -Lite -Advanced
    CreateReduxCheckBox -Name "CDownButton"  -Text "Hide C-Down Button"      -Info "Hide the C-Down Button"                                       -Credits "Admentus" -Lite -Advanced
    CreateReduxCheckBox -Name "CRightButton" -Text "Hide C-Right Button"     -Info "Hide the C-Right Button"                                      -Credits "Admentus" -Lite -Advanced
    CreateReduxCheckBox -Name "Hearts"       -Text "Hide Hearts"             -Info "Hide the Hearts display"                                      -Credits "Admentus" -Lite -Advanced
    CreateReduxCheckBox -Name "Magic"        -Text "Hide Magic"              -Info "Hide the Magic display"                                       -Credits "Admentus" -Lite -Advanced
    CreateReduxCheckBox -Name "Rupees"       -Text "Hide Rupees"             -Info "Hide the the Rupees display"                                  -Credits "Admentus" -Lite -Advanced
    CreateReduxCheckBox -Name "DungeonKeys"  -Text "Hide Keys"               -Info "Hide the Keys display shown in several dungeons and areas"    -Credits "Admentus" -Lite -Advanced
    CreateReduxCheckBox -Name "Carrots"      -Text "Hide Epona Carrots"      -Info "Hide the Epona Carrots display"                               -Credits "Admentus" -Lite -Advanced
    CreateReduxCheckBox -Name "AreaTitle"    -Text "Hide Area Title Card"    -Info "Hide the area title that displays when entering a new area"   -Credits "Admentus" -Lite -Advanced
    CreateReduxCheckBox -Name "DungeonTitle" -Text "Hide Dungeon Title Card" -Info "Hide the dungeon title that displays when entering a dungeon" -Credits "Admentus" -Lite -Advanced
    CreateReduxCheckBox -Name "Icons"        -Text "Hide Icons"              -Info "Hide the Clock and Score Counter icons display"               -Credits "Admentus" -Lite -Advanced
  # CreateReduxCheckBox -Name "Minimaps"     -Text "Hide Minimaps"           -Info "Hide the Minimap that displays in the overworld and dungeons" -Credits "Admentus" -Lite -Advanced
    CreateReduxCheckBox -Name "Credits"      -Text "Hide Credits"            -Info "Hide the credits text during the credits sequence"            -Credits "Admentus"       -Advanced



    # HUD PREVIEWS #

    CreateReduxGroup -Tag "UI" -Text "HUD Previews"
    $Last.Group.Height = (DPISize 140)

    CreateImageBox -x 40  -y 30 -w 90  -h 90 -Name "ButtonPreview";      $Redux.UI.ButtonSize.Add_SelectedIndexChanged( { ShowHUDPreview -IsOoT } );   $Redux.UI.ButtonStyle.Add_SelectedIndexChanged( { ShowHUDPreview -IsOoT } )
    CreateImageBox -x 160 -y 35 -w 40  -h 40 -Name "HeartsPreview";      if (CheckInterfaceMode -Lite $True -Advanced $True) { $Redux.UI.Hearts.Add_CheckStateChanged(      { ShowHUDPreview -IsOoT } ) }
    CreateImageBox -x 220 -y 35 -w 40  -h 40 -Name "RupeesPreview";      if (CheckInterfaceMode -Lite $True -Advanced $True) { $Redux.UI.Rupees.Add_CheckStateChanged(      { ShowHUDPreview -IsOoT } ) }
    CreateImageBox -x 280 -y 35 -w 40  -h 40 -Name "DungeonKeysPreview"; if (CheckInterfaceMode -Lite $True -Advanced $True) { $Redux.UI.DungeonKeys.Add_CheckStateChanged( { ShowHUDPreview -IsOoT } ) }
    CreateImageBox -x 140 -y 85 -w 200 -h 40 -Name "MagicPreview";       $Redux.UI.MagicBar.Add_SelectedIndexChanged( { ShowHUDPreview -IsOoT } )
    
    ShowHUDPreview -IsOoT
    if (CheckInterfaceMode -Beginner $True) { $Redux.UI.HUD.Add_CheckStateChanged( { ShowHUDPreview -IsOoT } ) }


    # MENU #

    CreateReduxGroup    -Tag  "Menu" -Text "Menu" -Lite -Advanced
    CreateReduxComboBox -Name "Skybox" -Text "Skybox" -Default 4 -Items @("Dawn", "Day", "Dusk", "Night", "Darkness (Dawn)", "Darkness (Day)", "Darkness (Dusk)", "Darkness (Night)") -Info "Set the skybox theme for the File Select menu" -Credits "Admentus"

}



#==============================================================================================================================================================================================
function CreateTabAudio() {
    
    # SOUNDS / VOICES #

    CreateReduxGroup    -Tag  "Sounds" -Text "Sounds / Voices"
    CreateReduxComboBox -Name "ChildVoices" -Text "Child Voice"                     -Items @("Original") -FilePath ($GameFiles.binaries + "\Voices Child") -Default "Original" -Info "Replace the voice used for the Child Link Model" -Credits "`nMajora's Mask: Korey Cryderman (ported) & GhostlyDark (corrected)`nMelee Zelda: Thiago Alcântara 6 & theluigidude2007 (edits)`nAmara: Amara (ripping) & theluigidude2007 (edits)"
    CreateReduxComboBox -Name "AdultVoices" -Text "Adult Voice"                     -Items @("Original") -FilePath ($GameFiles.binaries + "\Voices Adult") -Default "Original" -Info "Replace the voice used for the Adult Link Model" -Credits "`nMajora's Mask: Korey Cryderman (ported) & GhostlyDark (corrected)`nMelee Zelda: Thiago Alcântara 6 & theluigidude2007 (edits)`nAmara: Amara (ripping) & theluigidude2007`nPeach: theluigidude2007"
    CreateReduxComboBox -Name "Instrument"  -Text "Instrument"  -Beginner -Advanced -Items @("Ocarina", "Female", "Voice", "Whistle Harp", "Grind-Organ", "Flute") -Info "Replace the sound used for playing the Ocarina of Time" -Credits "Ported from Rando"



    # SFX SOUND EFFECTS #

    CreateReduxGroup    -Tag "SFX" -Text "SFX Sound Effects" -Lite -Advanced
    $SFX = @("Default", "Disabled", "Soft Beep", "Bark", "Bomb Bounce", "Bongo Bongo Low", "Bow Twang", "Business Scrub", "Carrot Refill", "Cluck", "Great Fairy", "Drawbridge Set", "Guay", "Horse Trot", "HP Recover", "Iron Boots", "Moo", "Mweep!", 'Navi "Hey!"', "Navi Random", "Notification", "Pot Shattering", "Ribbit", "Rupee (Silver)", "Switch", "Sword Bonk", "Tambourine", "Timer", "Zelda Gasp (Adult)")
    CreateReduxComboBox -Name "LowHP"      -Text "Low HP"      -Items $SFX -Info "Set the sound effect for the low HP beeping"                      -Credits "Ported from Rando"
    $SFX = @("Default",  "Disabled", "Soft Beep", "Bark", "Business Scrub", "Carrot Refill", "Cluck", "Cockadoodledoo", "Dusk Howl", "Exploding Crate", "Explosion", "Great Fairy", "Guay", "Horse Neigh", "HP Low", "HP Recover", "Ice Shattering", "Moo", "Meweep!", 'Navi "Hello!"', "Notification", "Pot Shattering", "Redead Scream", "Ribbit", "Ruto Giggle", "Skulltula", "Tambourine", "Timer", "Zelda Gasp (Adult)")
    CreateReduxComboBox -Name "Navi"       -Text "Navi"        -Items $SFX -Info "Replace the sound used for Navi when she wants to tell something" -Credits "Ported from Rando"
    CreateReduxComboBox -Name "ZTarget"    -Text "Z-Target"    -Items $SFX -Info "Replace the sound used for Z-Targeting enemies"                   -Credits "Ported from Rando"

    CreateReduxComboBox -Name "HoverBoots" -Text "Hover Boots" -Items @("Default", "Disabled", "Bark", "Cartoon Fall", "Flare Dancer Laugh", "Mweep!", "Shabom Pop", "Tambourine")                            -Info "Replace the sound used for the Hover Boots"   -Credits "Ported from Rando"
    CreateReduxComboBox -Name "Horse"      -Text "Horse Neigh" -Items @("Default", "Disabled", "Armos", "Child Scream", "Great Fairy", "Moo", "Mweep!", "Redead Scream", "Ruto Wiggle", "Stalchild Attack")   -Info "Replace the sound for horses when neighing"   -Credits "Ported from Rando"
    CreateReduxComboBox -Name "Nightfall"  -Text "Nightfall"   -Items @("Default", "Disabled", "Cockadoodledoo", "Gold Skull Token", "Great Fairy", "Moo", "Mweep!", "Redead Moan", "Talon Snore", "Thunder") -Info "Replace the sound used when Nightfall occurs" -Credits "Ported from Rando"
    $SFX = @("Default", "Disabled", "Soft Beep", "Bark", "Bomb Bounce", "Bongo Bongo High", "Bongo Bongo Low", "Bottle Cork", "Bow Twang", "Bubble Laugh", "Carrot Refill", "Change Item", "Child Pant", "Cluck", "Deku Baba", "Drawbridge Set", "Dusk Howl", "Fanfare (Light)", "Fanfare (Medium)", "Field Shrub", "Flare Dancer Startled",
    'Ganondorf "Teh"', "Gohma Larva Croak", "Gold Skull Token", "Goron Wake", "Guay", "Gunshot", "Hammer Bonk", "Horse Trot", "HP Low", "HP Recover", "Iron Boots", "Iron Knuckle", "Moo", "Mweep!", "Notification", "Phantom Ganon Laugh", "Plant Explode", "Pot Shattering", "Redead Moan", "Ribbit", "Rupee", "Rupee (Silver)", "Ruto Crash",
    "Ruto Lift", "Ruto Thrown", "Scrub Emerge", "Shabom Bounce", "Shabom Pop", "Shellblade", "Skulltula", "Spit Nut", "Switch", "Sword Bonk", 'Talon "Hmm"', "Talon Snore", "Talon WTF", "Tambourine", "Target Enemy", "Target Neutral", "Thunder", "Timer", "Zelda Gasp (Adult)")
    CreateReduxComboBox -Name "FileCursor" -Text "File Cursor" -Items $SFX -Info "Replace the sound used when moving the cursor in the File Select menu"   -Credits "Ported from Rando"
    CreateReduxComboBox -Name "FileSelect" -Text "File Select" -Items $SFX -Info "Replace the sound used when selecting something in the File Select menu" -Credits "Ported from Rando"



    # MUSIC #

    if (CheckInterfaceMode -Beginner $True -Advanced $True) { MusicOptions -Default "Great Fairy's Fountain" }
    
}



#==============================================================================================================================================================================================
function CreateTabDifficulty() {
    
    # HERO MODE #

    CreateReduxGroup    -Tag  "Hero" -Text "Hero Mode"
    CreateReduxComboBox -Name "Damage"     -Text "Damage"       -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage", "OHKO Mode")        -Info "Set the amount of damage you receive`nOHKO Mode = You die in one hit"                                   -Credits "Admentus"
    CreateReduxComboBox -Name "Recovery"   -Text "Recovery"     -Items @("1x Recovery", "1/2x Recovery", "1/4x Recovery", "0x Recovery")         -Info "Set the amount health you recovery from Recovery Hearts`nRecovery Heart drops are removed if set to 0x" -Credits "Admentus & Rando (No Heart Drops)"
    CreateReduxComboBox -Name "MagicUsage" -Text "Magic Usage"  -Items @("1x Magic Usage", "2x Magic Usage", "4x Magic Usage", "8x Magic Usage") -Info "Set the amount of times magic is consumed at"                                                           -Credits "Admentus"
    $items1 = @("1 Monster HP","0.5x Monster HP", "1x Monster HP", "1.5x Monster HP", "2x Monster HP", "2.5x Monster HP", "3x Monster HP", "3.5x Monster HP", "4x Monster HP")
    $items2 = @("1 Mini-Boss HP", "0.5x Mini-Boss HP", "1x Mini-Boss HP", "1.5x Mini-Boss HP", "2x Mini-Boss HP", "2.5x Mini-Boss HP", "3x Mini-Boss HP", "3.5x Mini-Boss HP", "4x Mini-Boss HP")
    $items3 = @("1 Boss HP", "0.5x Boss HP", "1x Boss HP", "1.5x Boss HP", "2x Boss HP", "2.5x Boss HP", "3x Boss HP", "3.5x Boss HP", "4x Boss HP")
    CreateReduxComboBox -Name "MonsterHP"  -Text "Monster HP"   -Items $items1 -Default 3 -Info "Set the amount of health for monsters"                       -Credits "Admentus" -Warning "Half of the enemies are missing"
    CreateReduxComboBox -Name "MiniBossHP" -Text "Mini-Boss HP" -Items $items2 -Default 3 -Info "Set the amount of health for elite monsters and mini-bosses" -Credits "Admentus" -Warning "Big Octo and Dark Link are missing"
    CreateReduxComboBox -Name "BossHP"     -Text "Boss HP"      -Items $items3 -Default 3 -Info "Set the amount of health for bosses"                         -Credits "Admentus & Marcelo20XX"
    CreateReduxCheckBox -Name "NoRecoveryHearts"  -Text "No Recovery Heart Drops" -Info "Disable Recovery Hearts from spawning from item drops"                                           -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "NoItemDrops"       -Text "No Item Drops"           -Info "Disable all items from spawning"                                                                 -Credits "Admentus & BilonFullHDemon"
    CreateReduxCheckBox -Name "HarderChildBosses" -Text "Harder Child Bosses"     -Info "Replace objects in the Child Dungeon Boss arenas with additional monsters"   -Beginner -Advanced -Credits "BilonFullHDemon"
    CreateReduxCheckBox -Name "GraveyardKeese"    -Text "Graveyard Keese"         -Info "Extends the object list for Adult Link so the Keese appear at the Graveyard" -Beginner -Advanced -Credits "salvador235"
    CreateReduxCheckBox -Name "Arwing"            -Text "Arwing"                  -Info "Replaces the Rock-Lifting Kokiri Kid with an Arwing in Kokiri Forest"                  -Advanced -Credits "Admentus"
    CreateReduxCheckBox -Name "LikeLike"          -Text "Like-Like"               -Info "Replaces the Rock-Lifting Kokiri Kid with a Like-Like in Kokiri Forest"                -Advanced -Credits "Admentus" -Link $Redux.Hero.Arwing

    $Redux.Hero.Damage.Add_SelectedIndexChanged({ EnableElem -Elem $Redux.Hero.Recovery -Active ($this.text -ne "OHKO Mode") })
    EnableElem -Elem ($Redux.Hero.Recovery) -Active ($Redux.Hero.Damage.text -ne "OHKO Mode")



    # MASTER QUEST #

    CreateReduxGroup -Tag "MQ" -Text "Dungeons" -Beginner -Advanced
    CreateReduxPanel
    CreateReduxRadioButton -Name "Disable"   -Max 5 -SaveTo "Dungeons" -Text "Vanilla"      -Info "All dungeons remain vanilla"  -Checked
    CreateReduxRadioButton -Name "EnableMQ"  -Max 5 -SaveTo "Dungeons" -Text "Master Quest" -Info "Patch in all Master Quest dungeons"                  -Credits "ShadowOne333"
    CreateReduxRadioButton -Name "EnableUra" -Max 5 -SaveTo "Dungeons" -Text "Ura Quest"    -Info "Patch in all Ura (Disk Drive) Master Quest dungeons" -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool) & Admentus"
    CreateReduxRadioButton -Name "Select"    -Max 5 -SaveTo "Dungeons" -Text "Select"       -Info "Select which dungeons you want from which version"   -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), ShadowOne333 & Admentus"
    CreateReduxRadioButton -Name "Randomize" -Max 5 -SaveTo "Dungeons" -Text "Randomize"    -Info "Randomize the amount of dungeons from all versions"  -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), ShadowOne333 & Admentus"



    # MASTER QUEST LOGO #

    CreateReduxGroup -Tag "MQ" -Text "Title Screen Logo" -Beginner -Advanced
    CreateReduxPanel
    CreateReduxRadioButton -Name "VanillaLogo"          -Max 4 -SaveTo "Logo" -Text "Vanilla" -Checked     -Info "Keep the original title screen logo"
    CreateReduxRadioButton -Name "MasterQuestLogo"      -Max 4 -SaveTo "Logo" -Text "Master Quest"         -Info "Use the Master Quest title screen logo"            -Credits "ShadowOne333, GhostlyDark & Admentus"
    CreateReduxRadioButton -Name "UraQuestLogo"         -Max 4 -SaveTo "Logo" -Text "Ura Quest"            -Info "Use the Ura Quest title screen logo"               -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), GhostlyDark & Admentus"
    CreateReduxRadioButton -Name "UraQuestSubtitleLogo" -Max 4 -SaveTo "Logo" -Text "Ura Quest + Subtitle" -Info "Use the Ura Quest title screen logo with subtitle" -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), GhostlyDark, Admentus & ShadowOne"



    # MASTER QUEST DUNGEONS #

    $Redux.Box.SelectMQ = CreateReduxGroup -Tag "MQ" -Text "Select - Dungeons" -Beginner -Advanced
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



    # RANDOMIZE MASTER QUEST DUNGEONS #
    $Redux.Box.RandomizeMQ = CreateReduxGroup -Tag "MQ" -Text "Randomize - Dungeons" -Beginner -Advanced
    $Items = @("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12")
    CreateReduxComboBox -Name "Minimum" -Text "Minimum" -Default 1            -Items $Items
    CreateReduxComboBox -Name "Maximum" -Text "Maximum" -Default $Items.Count -Items $Items



    if (CheckInterfaceMode -Beginner $True -Advanced $True) {
        $Redux.MQ.Minimum.Add_SelectedIndexChanged({
            if ($Redux.MQ.Maximum.SelectedIndex -lt $Redux.MQ.Minimum.SelectedIndex) { $Redux.MQ.Maximum.SelectedIndex = $Redux.MQ.Minimum.SelectedIndex }
        })
        $Redux.MQ.Maximum.Add_SelectedIndexChanged({
            if ($Redux.MQ.Maximum.SelectedIndex -lt $Redux.MQ.Minimum.SelectedIndex) { $Redux.MQ.Maximum.SelectedIndex = $Redux.MQ.Minimum.SelectedIndex }
        })
        if ($Redux.MQ.Maximum.SelectedIndex -lt $Redux.MQ.Minimum.SelectedIndex) { $Redux.MQ.Maximum.SelectedIndex = $Redux.MQ.Minimum.SelectedIndex }
    }

    if (CheckInterfaceMode -Beginner $True -Advanced $True) {
        EnableForm -Form $Redux.Box.SelectMQ -Enable $Redux.MQ.Select.Checked
        $Redux.MQ.Select.Add_CheckedChanged({ EnableForm -Form $Redux.Box.SelectMQ -Enable $Redux.MQ.Select.Checked })
        EnableForm -Form $Redux.Box.RandomizeMQ -Enable $Redux.MQ.Randomize.Checked
        $Redux.MQ.Randomize.Add_CheckedChanged({ EnableForm -Form $Redux.Box.RandomizeMQ -Enable $Redux.MQ.Randomize.Checked })
    }

}



#==============================================================================================================================================================================================
function CreateTabColors() {

    # EQUIPMENT COLORS #

    CreateReduxGroup -Tag "Colors" -Text "Equipment Colors"
    $Redux.Colors.Equipment = @()
    $Items = @("Kokiri Green", "Goron Red", "Zora Blue"); $PostItems = @("Randomized", "Custom"); $Files = ($GameFiles.Textures + "\Tunic"); $Randomize = '"Randomized" fully randomizes the colors each time the patcher is opened'
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "KokiriTunic" -Column 1 -Row 1 -Text "Kokiri Tunic Color" -Default 1 -Length 230 -Shift 40 -Items $Items -PostItems $PostItems -FilePath $Files -Info ("Select a color scheme for the Kokiri Tunic`n" + $Randomize) -Credits "Ported from Rando"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "GoronTunic"  -Column 1 -Row 2 -Text "Goron Tunic Color"  -Default 2 -Length 230 -Shift 40 -Items $Items -PostItems $PostItems -FilePath $Files -Info ("Select a color scheme for the Goron Tunic`n" + $Randomize)  -Credits "Ported from Rando"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "ZoraTunic"   -Column 1 -Row 3 -Text "Zora Tunic Color"   -Default 3 -Length 230 -Shift 40 -Items $Items -PostItems $PostItems -FilePath $Files -Info ("Select a color scheme for the Zora Tunic`n" + $Randomize)   -Credits "Ported from Rando"
    $Items = @("Silver", "Gold", "Black", "Green", "Blue", "Bronze", "Red", "Sky Blue", "Pink", "Magenta", "Orange", "Lime", "Purple", "Randomized", "Custom")
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "SilverGauntlets"   -Column 4 -Row 1 -Text "Silver Gauntlets Color"    -Default 1 -Length 230 -Shift 40 -Items $Items -Info ("Select a color scheme for the Silver Gauntlets`n" + $Randomize) -Credits "Ported from Rando"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "GoldenGauntlets"   -Column 4 -Row 2 -Text "Golden Gauntlets Color"    -Default 2 -Length 230 -Shift 40 -Items $Items -Info ("Select a color scheme for the Golden Gauntlets`n" + $Randomize) -Credits "Ported from Rando"
    $Items =  @("Red", "Green", "Blue", "Yellow", "Cyan", "Magenta", "Orange", "Gold", "Purple", "Pink", "Randomized", "Custom")
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "MirrorShieldFrame" -Column 4 -Row 3 -Text "Mirror Shield Frame Color" -Default 1 -Length 230 -Shift 40 -Items $Items -Info ("Select a color scheme for the Mirror Shield Frame`n" + $Randomize) -Warning "This option might not work for every custom player model" -Credits "Ported from Rando"

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



    # SPIN ATTACK COLORS #

    CreateSpinAttackColorOptions



    # SWORD TRAIL COLORS #

    CreateSwordTrailColorOptions



    # FAIRY COLORS #

    CreateFairyColorOptions -Name "Navi"

    if ($Settings.Core.Interface -ne 3) { return }
    CreateReduxCheckBox -Name "BetaNavi" -Text "Beta Navi Colors" -Info "Use the Beta colors for Navi" -Column 1 -Row 2
    $Redux.Colors.BetaNavi.Add_CheckedChanged({ EnableElem -Elem $Redux.Colors.Fairy -Active (!$this.checked) })
    EnableElem -Elem $Redux.Colors.Fairy -Active (!$Redux.Colors.BetaNavi.Checked)



    # MISC COLORS #

    CreateReduxGroup -Tag "Colors" -Text "Misc Colors"

    CreateReduxCheckBox -Name "PauseScreenColors" -Text "MM Pause Screen Colors" -Info "Use the Pause Screen color scheme from Majora's Mask" -Credits "Garo-Mastah"

}



#==============================================================================================================================================================================================
function CreateTabEquipment() {
    
    # EQUIPMENT #

    CreateReduxGroup    -Tag  "Equipment" -Text "Equipment Adjustments"
    CreateReduxCheckBox -Name "UnsheathSword" -Text "Unsheath Sword"        -Info "The sword is unsheathed first before immediately swinging it" -Credits "Admentus"
    CreateReduxCheckBox -Name "IronShield"    -Text "Iron Shield"           -Info "Replace the Deku Shield with the Iron Shield, which will not burn up anymore" -Warning "Some custom models do not support the new textures, but will still keep the fireproof shield" -Credits "Admentus (ported), ZombieBrainySnack (textures) & Three Pendants (Debug fireproof ROM patch)"
    CreateReduxCheckBox -Name "HerosBowIcons" -Text "Hero's Bow Icons"      -Info "Use the Hero's Bow icons for the Fairy Bow"                  -Credits "GhostlyDark (ported)"
    CreateReduxCheckBox -Name "HookshotIcon"  -Text "Termina Hookshot Icon" -Info "Use the Termina Hookshot icon for the regular Hookshot"      -Credits "GhostlyDark (ported)"
    


    CreateReduxGroup    -Tag  "Equipment" -Text "Swords and Shields"
    CreateReduxComboBox -Name "KokiriSword"   -Text "Kokiri Sword"  -Items @("Kokiri Sword")  -FilePath ($GameFiles.Textures + "\Equipment\Kokiri Sword")  -Ext @("icon", "bin") -Info "Select an alternative for the appearence of the Kokiri Sword"  -Credits "Admentus & GhostlyDark (injects) & CYB3RTR0N (beta icon)"
    CreateReduxComboBox -Name "MasterSword"   -Text "Master Sword"  -Items @("Master Sword")  -FilePath ($GameFiles.Textures + "\Equipment\Master Sword")  -Ext @("icon", "bin") -Info "Select an alternative for the appearence of the Master Sword"  -Credits "Admentus & GhostlyDark (injects) & CYB3RTR0N (beta icon)"
    CreateReduxComboBox -Name "HylianShield"  -Text "Hylian Shield" -Items @("Hylian Shield") -FilePath ($GameFiles.Textures + "\Equipment\Hylian Shield") -Ext @("icon", "bin") -Info "Select an alternative for the appearence of the Hylian Shield" -Credits "Admentus & GhostlyDark (injects), CYB3RTR0N (icons) & sanguinetti (Beta / Red Shield textures)"
    CreateReduxComboBox -Name "MirrorShield"  -Text "Mirror Shield" -Items @("Mirror Shield") -FilePath ($GameFiles.Textures + "\Equipment\Mirror Shield") -Ext @("icon", "bin") -Info "Select an alternative for the appearence of the Mirror Shield" -Credits "Admentus & GhostlyDark (injects)"



    # HITBOX #

    CreateReduxGroup  -Tag  "Hitbox" -Text "Sliders" -Height 2.7
    CreateReduxSlider -Name "KokiriSword"       -Column 1 -Row 1 -Default 3000  -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512   -Text "Kokiri Sword"   -Info "Set the length of the hitbox of the Kokiri Sword"                   -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "MasterSword"       -Column 3 -Row 1 -Default 4000  -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512   -Text "Master Sword"   -Info "Set the length of the hitbox of the Master Sword"                   -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "GiantsKnife"       -Column 5 -Row 1 -Default 5500  -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512   -Text "Giant's Knife"  -Info "Set the length of the hitbox of the Giant's Knife / Biggoron Sword" -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "BrokenGiantsKnife" -Column 1 -Row 2 -Default 1500  -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512   -Text "Broken Knife"   -Info "Set the length of the hitbox of the Broken Giant's Knife"           -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "MegatonHammer"     -Column 3 -Row 2 -Default 2500  -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512   -Text "Megaton Hammer" -Info "Set the length of the hitbox of the Megaton Hammer"                 -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "ShieldRecoil"      -Column 5 -Row 2 -Default 4552  -Min 0   -Max 8248 -Freq 512 -Small 256 -Large 512   -Text "Shield Recoil"  -Info "Set the pushback distance when getting hit while shielding"         -Credits "Admentus (ROM) & Aegiker (GameShark)"



    # UNLOCK CHILD RESTRICTIONS #

    CreateReduxGroup    -Tag  "Unlock" -Text "Unlock Child Restrictions"
    CreateReduxCheckBox -Name "Tunics"        -Text "Unlock Tunics"        -Info "Child Link is able to use the Goron Tunic and Zora Tunic`nSince you might want to walk around in style as well when you are young`nThe dialogue script will be adjusted to reflect this (only for English)" -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "MasterSword"   -Text "Unlock Master Sword"  -Info "Child Link is able to use the Master Sword`nThe Master Sword does twice as much damage as the Kokiri Sword" -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "GiantsKnife"   -Text "Unlock Giant's Knife" -Info "Child Link is able to use the Giant's Knife / Biggoron Sword`nThe Giant's Knife / Biggoron Sword does four times as much damage as the Kokiri Sword" -Credits "GhostlyDark" -Lite -Advanced -Warning "The Giant's Knife / Biggoron Sword appears as if Link if thrusting the sword through the ground"
    CreateReduxCheckBox -Name "MirrorShield"  -Text "Unlock Mirror Shield" -Info "Child Link is able to use the Mirror Shield"               -Lite -Advanced -Credits "GhostlyDark" -Warning "The Mirror Shield appears as invisible but can still reflect magic or sunlight"
    CreateReduxCheckBox -Name "Boots"         -Text "Unlock Boots"         -Info "Child Link is able to use the Iron Boots and Hover Boots"  -Lite -Advanced -Credits "GhostlyDark" -Warning "The Iron and Hover Boots appears as the Kokiri Boots"
    CreateReduxCheckBox -Name "Gauntlets"     -Text "Unlock Gauntlets"     -Info "Child Link is able to use the Silver and Golden Gauntlets" -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxComboBox -Name "MegatonHammer" -Text "Unlock Hammer"        -Info "Child Link is able to use the Megaton Hammer" -Items @("Disabled", "Unlock Only", "Show Only", "Unlock and Show") -Lite -Advanced -Credits "GhostlyDark" -Warning "The Megaton Hammer appears as invisible on custom models"
    


    # UNLOCK ADULT RESTRICTIONS #

    CreateReduxGroup    -Tag  "Unlock" -Text "Unlock Adult Restrictions"
    CreateReduxCheckBox -Name "KokiriSword"    -Text "Unlock Kokiri Sword" -Info "Adult Link is able to use the Kokiri Sword`nThe Kokiri Sword does half as much damage as the Master Sword" -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "DekuShield"     -Text "Unlock Deku Shield"  -Info "Adult Link is able to use the Deku Shield"     -Credits "GhostlyDark" -Lite -Advanced -Warning "The Deku Shield appears as invisible but can still be burned up by fire"
    CreateReduxCheckBox -Name "FairySlingshot" -Text "Unlock Slingshot"    -Info "Adult Link is able to use the Fairy Slingshot" -Credits "GhostlyDark" -Lite -Advanced -Warning "The Fairy Slingshot appears as the Fairy Bow"
    CreateReduxCheckBox -Name "Boomerang"      -Text "Unlock Boomerang"    -Info "Adult Link is able to use the Boomerang"       -Credits "GhostlyDark" -Lite -Advanced -Warning "The Boomerang appears as invisible"
    CreateReduxCheckBox -Name "CrawlHole"      -Text "Unlock Crawl Hole"   -Info "Adult Link can now crawl through holes"        -Credits "Admentus"          -Advanced -Native
    CreateReduxComboBox -Name "DekuSticks"     -Text "Unlock Deku Sticks"  -Info "Adult Link is able to use the Deku Sticks"     -Credits "GhostlyDark"       -Advanced -Warning "The Deku Sticks appears as invisible for both Child and Adult Link with this option" -Items @("Disabled", "Crash Fix Only", "Crash Fix and Unlock")



    # EQUIPMENT PREVIEWS #

    CreateReduxGroup -Tag "Equipment" -Text "Equipment Previews"
    $Last.Group.Height = (DPISize 140)

    CreateImageBox -x 40  -y 30 -w 80 -h 80  -Name "DekuShieldIconPreview"
    CreateImageBox -x 160 -y 10 -w 80 -h 120 -Name "DekuShieldPreview";      $Redux.Equipment.IronShield.Add_CheckStateChanged(      { ShowEquipmentPreview } )
    CreateImageBox -x 320 -y 30 -w 80 -h 80  -Name "HylianShieldIconPreview"
    CreateImageBox -x 440 -y 10 -w 80 -h 120 -Name "HylianShieldPreview";    $Redux.Equipment.HylianShield.Add_SelectedIndexChanged( { ShowEquipmentPreview } )
    CreateImageBox -x 600 -y 30 -w 80 -h 80  -Name "MirrorShieldIconPreview"
    CreateImageBox -x 720 -y 10 -w 80 -h 120 -Name "MirrorShieldPreview";    $Redux.Equipment.MirrorShield.Add_SelectedIndexChanged( { ShowEquipmentPreview } )
    CreateImageBox -x 840 -y 30 -w 80 -h 80  -Name "KokiriSwordIconPreview"; $Redux.Equipment.KokiriSword.Add_SelectedIndexChanged(  { ShowEquipmentPreview } )
    CreateImageBox -x 960 -y 30 -w 80 -h 80  -Name "MasterSwordIconPreview"; $Redux.Equipment.MasterSword.Add_SelectedIndexChanged(  { ShowEquipmentPreview } )
    ShowEquipmentPreview

}



#==============================================================================================================================================================================================
function CreateTabCapacity() {
    
    # CAPACITY SELECTION #

    CreateReduxGroup    -Tag  "Capacity" -Text "Capacity Selection"
    CreateReduxCheckBox -Name "EnableAmmo"   -Text "Change Ammo Capacity"       -Info "Enable changing the capacity values for ammo"
    CreateReduxCheckBox -Name "EnableWallet" -Text "Change Wallet Capacity"     -Info "Enable changing the capacity values for the wallets"
    CreateReduxCheckBox -Name "EnableDrops"  -Text "Change Item Drops Quantity" -Info "Enable changing the amount which an item drop provides"



    # AMMO CAPACITY #

    $Redux.Box.Ammo = CreateReduxGroup -Tag "Capacity" -Text "Ammo Capacity Selection"
    CreateReduxTextBox -Name "Quiver1"     -Text "Quiver (1)"      -Value 30  -Info "Set the capacity for the Quiver (Base)"           -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver2"     -Text "Quiver (2)"      -Value 40  -Info "Set the capacity for the Quiver (Upgrade 1)"      -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver3"     -Text "Quiver (3)"      -Value 50  -Info "Set the capacity for the Quiver (Upgrade 2)"      -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag1"    -Text "Bomb Bag (1)"    -Value 20  -Info "Set the capacity for the Bomb Bag (Base)"         -Credits "GhostlyDark" -Warning "The minimum value has to be 20 or higher in order to be changed`n[!] A few values are excluded to prevent issues and will automatically be set to the next possible value"
    CreateReduxTextBox -Name "BombBag2"    -Text "Bomb Bag (2)"    -Value 30  -Info "Set the capacity for the Bomb Bag (Upgrade 1)"    -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag3"    -Text "Bomb Bag (3)"    -Value 40  -Info "Set the capacity for the Bomb Bag (Upgrade 2)"    -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BulletBag1"  -Text "Bullet Bag (1)"  -Value 30  -Info "Set the capacity for the Bullet Bag (Base)"       -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BulletBag2"  -Text "Bullet Bag (2)"  -Value 40  -Info "Set the capacity for the Bullet Bag (Upgrade 1)"  -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BulletBag3"  -Text "Bullet Bag (3)"  -Value 50  -Info "Set the capacity for the Bullet Bag (Upgrade 2)"  -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuSticks1" -Text "Deku Sticks (1)" -Value 10  -Info "Set the capacity for the Deku Sticks (Base)"      -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuSticks2" -Text "Deku Sticks (2)" -Value 20  -Info "Set the capacity for the Deku Sticks (Upgrade 1)" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuSticks3" -Text "Deku Sticks (3)" -Value 30  -Info "Set the capacity for the Deku Sticks (Upgrade 2)" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuNuts1"   -Text "Deku Nuts (1)"   -Value 20  -Info "Set the capacity for the Deku Nuts (Base)"        -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuNuts2"   -Text "Deku Nuts (2)"   -Value 30  -Info "Set the capacity for the Deku Nuts (Upgrade 1)"   -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuNuts3"   -Text "Deku Nuts (3)"   -Value 40  -Info "Set the capacity for the Deku Nuts (Upgrade 2)"   -Credits "GhostlyDark"



    # WALLET CAPACITY #

    $Redux.Box.Wallet = CreateReduxGroup -Tag "Capacity" -Text "Wallet Capacity Selection"
    CreateReduxTextBox -Name "Wallet1" -Length 4 -Text "Wallet (1)" -Value 99  -Info "Set the capacity for the Wallet (Base)"      -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet2" -Length 4 -Text "Wallet (2)" -Value 200 -Info "Set the capacity for the Wallet (Upgrade 1)" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet3" -Length 4 -Text "Wallet (3)" -Value 500 -Info "Set the capacity for the Wallet (Upgrade 2)" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet4" -Length 4 -Text "Wallet (4)" -Value 500 -Info "Set the capacity for the Wallet (Upgrade 3)" -Credits "GhostlyDark" -Warning "This wallet is not obtained through regular gameplay" -Lite -Advanced



    # ITEM DROPS QUANTITY #

    $Redux.Box.Drops = CreateReduxGroup -Tag "Capacity" -Text "Item Drops Quantity Selection"
    CreateReduxTextBox -Name "Arrows1x"             -Text "Arrows (Single)"     -Value 5   -Info "Set the recovery quantity for picking up or buying Single Arrows"  -Credits "Admentus" -Row 1 -Column 1
    CreateReduxTextBox -Name "Arrows2x"             -Text "Arrows (Double)"     -Value 10  -Info "Set the recovery quantity for buying Double Arrows"                -Credits "Admentus"
    CreateReduxTextBox -Name "Arrows3x"             -Text "Arrows (Triple)"     -Value 30  -Info "Set the recovery quantity for picking up or buying Triple Arrows"  -Credits "Admentus"
    CreateReduxTextBox -Name "BulletSeeds"          -Text "Bullet Seeds"        -Value 5   -Info "Set the recovery quantity for picking up Bullet Seeds"             -Credits "Admentus"
    CreateReduxTextBox -Name "BulletSeedsShop"      -Text "Bullet Seeds (Shop)" -Value 30  -Info "Set the recovery quantity for buying Bullet Seeds"                 -Credits "Admentus"
    CreateReduxTextBox -Name "DekuSticks"           -Text "Deku Sticks"         -Value 1   -Info "Set the recovery quantity for picking up Deku Sticks"              -Credits "Admentus"
    CreateReduxTextBox -Name "Bombs1x"              -Text "Bombs (5)"           -Value 5   -Info "Set the recovery quantity for picking up or buying Bombs (5)"      -Credits "Admentus" -Row 2 -Column 1
    CreateReduxTextBox -Name "Bombs2x"              -Text "Bombs (10)"          -Value 10  -Info "Set the recovery quantity for buying Bombs (10)"                   -Credits "Admentus"
    CreateReduxTextBox -Name "Bombs3x"              -Text "Bombs (15)"          -Value 15  -Info "Set the recovery quantity for buying Bombs (15)"                   -Credits "Admentus"
    CreateReduxTextBox -Name "Bombs4x"              -Text "Bombs (20)"          -Value 20  -Info "Set the recovery quantity for buying Bombs (20)"                   -Credits "Admentus"
    CreateReduxTextBox -Name "DekuNuts1x"           -Text "Deku Nuts (5)"       -Value 5   -Info "Set the recovery quantity for pickung up or buying Deku Nuts (5)"  -Credits "Admentus"
    CreateReduxTextBox -Name "DekuNuts2x"           -Text "Deku Nuts (10)"      -Value 10  -Info "Set the recovery quantity for picking up or buying Deku Nuts (10)" -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeG"     -Length 4 -Text "Rupee (Green)"       -Value 1   -Info "Set the recovery quantity for picking up Green Rupees"             -Credits "Admentus" -Row 3 -Column 1
    CreateReduxTextBox -Name "RupeeB"     -Length 4 -Text "Rupee (Blue)"        -Value 5   -Info "Set the recovery quantity for picking up Blue Rupees"              -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeR"     -Length 4 -Text "Rupee (Red)"         -Value 20  -Info "Set the recovery quantity for picking up Red Rupees"               -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeP"     -Length 4 -Text "Rupee (Purple)"      -Value 50  -Info "Set the recovery quantity for picking up Purple Rupees"            -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeO"     -Length 4 -Text "Rupee (Gold)"        -Value 200 -Info "Set the recovery quantity for picking up Gold Rupees"              -Credits "Admentus"

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
    
    # SKIP CUTSCENES #

    CreateReduxGroup    -Tag  "Skip"             -Text "Skip Cutscenes" -Advanced
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


    CreateReduxGroup    -Tag  "Speedup"          -Text "Speedup Cutscenes"
    CreateReduxCheckBox -Name "OpeningChests"    -Text "Opening Chests"         -Info "Make all chest opening animations fast by kicking them open"                     -Credits "Ported from Better OoT"
    CreateReduxCheckBox -Name "KingZora"         -Text "King Zora"              -Info "King Zora moves quickly"                                                         -Credits "Ported from Better OoT"
    CreateReduxCheckBox -Name "OwlFlights"       -Text "Owl Flights"            -Info "Speedup the Owls Flights from Death Mountain Trial and Lake Hylia"               -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "EponaRace"        -Text "Epona Race"             -Info "The Epona race with Ingo starts faster"                                          -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "EponaEscape"      -Text "Epona Escape"           -Info "The Epona escape sequence after you won the races with Ingo"                     -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "HorsebackArchery" -Text "Horseback Archery"      -Info "The Horseback Archery mini starts and ends faster"                               -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "DoorOfTime"       -Text "Door of Time"           -Info "The Door of Time in the Temple of Time opens much faster"                        -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "DrainingTheWell"  -Text "Draining the Well"      -Info "The well in Kakariko Village drains much faster"                                 -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "Bosses"           -Text "Bosses"                 -Info "Speedup sequences related to some dungeon bosses"                                -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "RainbowBridge"    -Text "Rainbow Bridge"         -Info "Speedup the sequence where the Rainbow Bridge appears"                           -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "FairyOcarina"     -Text "Fairy Ocarina"          -Info "Speedup the sequence where Link obtains the Fairy Ocarina"                       -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "GanonTrials"      -Text "Ganon's Trials"         -Info "Skip the completion sequence of the Ganon's Castle trials"                       -Credits "Ported from Rando"
    


    # Restore CUTSCENES #

    CreateReduxGroup    -Tag  "Restore"          -Text "Restore Cutscenes"
    CreateReduxCheckBox -Name "OpeningCutscene"  -Text "Opening Cutscene"       -Info "Restore the beta introduction cutscene" -Link $Redux.Skip.OpeningCutscene        -Credits "Admentus (ROM) & CloudModding (GameShark)"



    # ANIMATIONS #

    CreateReduxGroup    -Tag  "Animation"        -Text "Link Animations"
    CreateReduxCheckBox -Name "Feminine"         -Text "Feminine Animations"    -Info "Use feminine animations for Link`nThis applies to both models`nIt works best with the Aria model" -Credits "GhostlyDark (ported) & AriaHiro64 (model)"
    $weapons = "`n`nAffected weapons:`n- Giant's Knife`n- Giant's Knife (Broken)`n- Biggoron Sword`n- Deku Stick`n- Megaton Hammer"
    CreateReduxCheckBox -Name "WeaponIdle"       -Text "2-handed Weapon Idle"   -Info ("Restore the beta animation when idly holding a two-handed weapon" + $weapons)                       -Credits "Admentus"
    CreateReduxCheckBox -Name "WeaponCrouch"     -Text "2-handed Weapon Crouch" -Info ("Restore the beta animation when crouching with a two-handed weapon" + $weapons)                     -Credits "Admentus"
    CreateReduxCheckBox -Name "WeaponAttack"     -Text "2-handed Weapon Attack" -Info ("Restore the beta animation when attacking with a two-handed weapon" + $weapons)                     -Credits "Admentus"
    CreateReduxCheckBox -Name "HoldShieldOut"    -Text "Hold Shield Out"        -Info "Restore the beta animation for Link to always holds his shield out even when his sword is sheathed"  -Credits "Admentus"
    CreateReduxCheckBox -Name "BombBag"          -Text "Bomb Bag"               -Info "Restore the beta animation for the bomb bag"                                                         -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxCheckBox -Name "BackflipAttack"   -Text "Backflip Jump Attack"   -Info "Restore the beta animation to turn the Jump Attack into a Backflip Jump Attack"                      -Credits "Admentus"
    CreateReduxCheckBox -Name "FrontflipAttack"  -Text "Frontflip Jump Attack"  -Info "Restore the beta animation to turn the Jump Attack into a Frontflip Jump Attack"                     -Credits "Admentus" -Link $Redux.Animation.BackflipAttack
    CreateReduxCheckBox -Name "FrontflipJump"    -Text "Frontflip Jump"         -Info "Replace the jumps with frontflip jumps"                                                              -Credits "SoulofDeity"
    CreateReduxCheckBox -Name "SomarsaultJump"   -Text "Somarsault Jump"        -Info "Replace the jumps with somarsault jumps"                                                             -Credits "SoulofDeity" -Link $Redux.Animation.FrontflipJump

}