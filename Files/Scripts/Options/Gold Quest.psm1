function PatchOptions() {
    
    # GRAPHICS #

    if (IsChecked $Redux.Graphics.Widescreen)       { ApplyPatch -Patch "Decompressed\Optional\widescreen.ppf"      }
    


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
    if (IsChecked $Redux.Gameplay.RemoveCrouchStab)         { ChangeBytes -Offset "BDE374" -Values "10 00 00 0D"                                                     }
    if (IsChecked $Redux.Gameplay.ResumeLastArea)           { ChangeBytes -Offset "B06348" -Values "00 00";       ChangeBytes -Offset "B06354" -Values "00 00"       }
    if (IsChecked $Redux.Gameplay.AllowWarpSongs)           { ChangeBytes -Offset "B6D3D2" -Values "00";          ChangeBytes -Offset "B6D42A" -Values "00"          }
    if (IsChecked $Redux.Gameplay.AllowFaroreWind)          { ChangeBytes -Offset "B6D3D3" -Values "00";          ChangeBytes -Offset "B6D42B" -Values "00"          }

    if (IsIndex $Redux.Gameplay.SpawnChild -Index 1 -Not) { ChangeBytes -Offset "B0631F" -Values (GetOoTEntranceIndex $Redux.Gameplay.SpawnChild.Text) }
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

    if (IsChecked $Redux.Restore.CowNoseRing) { ChangeBytes -Offset "EF3E68" -Values "00 00" }
    


    # OTHER #

    if (IsChecked $Redux.Fixes.NaviTarget) {
        $offset = SearchBytes -Start "2ADE000" -End "2BEAA20" -Values "61 00 06 00 05 00 00 3C 24 01 11 FD A8 01 4D FB"; ChangeBytes -Offset $offset -Values "7E" # Spirit Temple
        ChangeBytes -Offset "283B14B" -Values "5C FA F3 FD AC"       # Shadow Temple
        ChangeBytes -Offset "236C059" -Values "4B FD 31 00 1E 00 16" # Fire Temple
        ChangeBytes -Offset "2C1906D" -Values "18 00 00 00 00"       # Ice Cavern
    }

    if (IsChecked $Redux.Fixes.PauseScreenDelay)      { ChangeBytes -Offset "B15DD0" -Values "00 00 00 00"             } # Pause Screen Anti-Aliasing
    if (IsChecked $Redux.Fixes.PoacherSaw)            { ChangeBytes -Offset "AE72CC" -Values "00 00 00 00"             }
    if (IsChecked $Redux.Fixes.Boomerang)             { ChangeBytes -Offset "F0F718" -Values "FC 41 C7 FF FF FF FE 38" }
    if (IsChecked $Redux.Fixes.FortressMinimap)       { CopyBytes   -Offset "96E068" -Length "D48" -Start "974600"     }
    

    # OTHER #

    if ( (IsIndex -Elem $Redux.Other.MapSelect -Text "Translate Only") -or (IsIndex $Redux.Other.MapSelect -Text "Translate and Enable") ) { ExportAndPatch -Path "map_select" -Offset "B9FD90" -Length "EC0" }
    if ( (IsIndex -Elem $Redux.Other.MapSelect -Text "Enable Only")    -or (IsIndex $Redux.Other.MapSelect -Text "Translate and Enable") ) {
        ChangeBytes -Offset "A94994" -Values "00 00 00 00 AE 08 00 14 34 84 B9 2C 8E 02 00 18 24 0B 00 00 AC 8B 00 00"
        ChangeBytes -Offset "B67395" -Values "B9 E4 00 00 BA 11 60 80 80 09 C0 80 80 37 20 80 80 1C 14 80 80 1C 14 80 80 1C 08"
    }

    if (IsChecked $Redux.Other.RemoveNaviPrompts)    { ChangeBytes -Offset "DF8B84" -Values "00 00 00 00" }
    if (IsChecked $Redux.Other.DefaultZTargeting)    { ChangeBytes -Offset "B71E6D" -Values "01" }
    if (IsChecked $Redux.Other.InstantClaimCheck)    { ChangeBytes -Offset "ED4470" -Values "00 00 00 00"; ChangeBytes -Offset "ED4498" -Values "00 00 00 00" }
    if (IsChecked $Redux.Other.ItemSelect)           { ExportAndPatch -Path "inventory_editor" -Offset "BCBF64" -Length "C8" }
    if (IsChecked $Redux.Other.DiskDrive)            { ChangeBytes -Offset "BAF1F1" -Values "26"; ChangeBytes -Offset "E6D83B" -Values "04" }

    if ( (IsIndex -Elem $Redux.Other.SkipIntro -Text "Don't Skip")        -or (IsIndex -Elem $Redux.Other.SkipIntro -Text "Skip Title Screen") )            { ChangeBytes -Offset "B9DAAC" -Values "14 20 00 04"                     }
    if ( (IsIndex -Elem $Redux.Other.SkipIntro -Text "Skip Title Screen") -or (IsIndex -Elem $Redux.Other.SkipIntro -Text "Skip Logo and Title Screen") )   { ChangeBytes -Offset "B17237" -Values "30"                              }
    if   (IsIndex -Elem $Redux.Other.Skybox    -Index 3 -Not)                                                                                               { ChangeBytes -Offset "B67722" -Values $Redux.Other.Skybox.SelectedIndex }


    # SPEED #

    if (IsValue -Elem $Redux.Gameplay.MovementSpeed -Not) { ChangeBytes -Offset "B6D5BA" -Values (Get16Bit $Redux.Gameplay.MovementSpeed.Value) }



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

    if (IsChecked $Redux.Graphics.ExtendedDraw)      { ChangeBytes -Offset "A9A970" -Values "00 01" }
    if (IsChecked $Redux.Graphics.ForceHiresModel)   { ChangeBytes -Offset "BE608B" -Values "00"    }



    # INTERFACE #

    if (IsChecked $Redux.UI.ButtonPositions) {
        ChangeBytes -Offset "B57F03" -Values "04" -Add # A Button / Text - X position (BA -> BE, +04)
        ChangeBytes -Offset "B586A7" -Values "0E" -Add # A Button / Text - Y position (09 -> 17, +0E)
        ChangeBytes -Offset "B57EEF" -Values "07" -Add # B Button        - X position (A0 -> A7, +07)
        ChangeBytes -Offset "B589EB" -Values "07" -Add # B Text          - X position (94 -> 9B, +07)
    }

    if (IsChecked $Redux.UI.GCScheme) { # Z to L + L to D-Pad textures
        if (IsChecked $Redux.Text.PauseScreen)   { PatchBytes -Offset "844540" -Texture -Patch "GameCube\l_pause_screen_button_mm.bin" }
        else                                     { PatchBytes -Offset "844540" -Texture -Patch "GameCube\l_pause_screen_button.bin" }
        PatchBytes -Offset "92C100"  -Texture -Patch "GameCube\dpad_text_icon.bin"
        PatchBytes -Offset "92C200"  -Texture -Patch "GameCube\l_text_icon.bin"
        PatchBytes -Offset "1A35680" -Texture -Patch "GameCube\l_targeting_en.bin"
    }

    if ( !((IsIndex -Elem $Redux.UI.ButtonSize -Text "Large") -and (IsIndex -Elem $Redux.UI.ButtonStyle -Text "Gold Quest")) ) {
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

    if ( (IsChecked $Redux.Hide.AButton) -or (IsChecked $Redux.Interface.Hide) ) {
        ChangeBytes -Offset "B586B0" -Values "00 00 00 00" # A Button (scale)
        ChangeBytes -Offset "AE7D0E" -Values "03 10"       # A Button - Text (DMA)
        ChangeBytes -Offset "7540"   -Values "03 10 00 00 03 10 57 00 03 10 00 00"
    } 

    if ( (IsChecked $Redux.Hide.BButton)      -or (IsChecked $Redux.Interface.Hide) )   { ChangeBytes -Offset "B57EEC" -Values "24 02 03 A0"; ChangeBytes -Offset "B57EFC" -Values "24 0A 03 A2"; ChangeBytes -Offset "B589D4" -Values "24 0F 03 97"; ChangeBytes -Offset "B589E8" -Values "24 19 03 94" } # B Button -> Icon / Ammo / Japanese / English
    if ( (IsChecked $Redux.Hide.StartButton)  -or (IsChecked $Redux.Interface.Hide) )   { ChangeBytes -Offset "B584EC" -Values "24 19 03 84"; ChangeBytes -Offset "B58490" -Values "24 18 03 7A"; ChangeBytes -Offset "B5849C" -Values "24 0E 03 78" } # Start Button   -> Button / Japanese / English
    if ( (IsChecked $Redux.Hide.CupButton)    -or (IsChecked $Redux.Interface.Hide) )   { ChangeBytes -Offset "B584C0" -Values "24 19 03 FE"; ChangeBytes -Offset "B582DC" -Values "24 0E 03 F7"                                                     } # C-Up Button    -> Button / Navi Text
    if ( (IsChecked $Redux.Hide.CLeftButton)  -or (IsChecked $Redux.Interface.Hide) )   { ChangeBytes -Offset "B58504" -Values "24 19 03 E3"; ChangeBytes -Offset "B5857C" -Values "24 19 03 E3"; ChangeBytes -Offset "B58DC4" -Values "24 0E 03 E4" } # C-Left Button  -> Button / Icon / Ammo
    if ( (IsChecked $Redux.Hide.CDownButton)  -or (IsChecked $Redux.Interface.Hide) )   { ChangeBytes -Offset "B58510" -Values "24 0F 03 F9"; ChangeBytes -Offset "B58588" -Values "24 0F 03 F9"; ChangeBytes -Offset "B58C40" -Values "24 06 02 FA" } # C-Down Button  -> Button / Icon / Ammo
    if ( (IsChecked $Redux.Hide.CRightButton) -or (IsChecked $Redux.Interface.Hide) )   { ChangeBytes -Offset "B5851C" -Values "24 19 03 0F"; ChangeBytes -Offset "B58594" -Values "24 19 03 0F"; ChangeBytes -Offset "B58DE0" -Values "24 19 03 10" } # C-Right Button -> Button / Icon / Ammo
    if ( (IsChecked $Redux.Hide.AreaTitle)    -or (IsChecked $Redux.Interface.Hide) )   { ChangeBytes -Offset "BE2B10" -Values "24 07 03 A0" } # Area Titles
    if ( (IsChecked $Redux.Hide.DungeonTitle) -or (IsChecked $Redux.Interface.Hide) )   { ChangeBytes -Offset "AC8828" -Values "24 07 03 A0" } # Dungeon Titles
    if ( (IsChecked $Redux.Hide.Carrots)      -or (IsChecked $Redux.Interface.Hide) )   { ChangeBytes -Offset "B58348" -Values "24 0F 03 6E" } # Epona Carrots    
    if ( (IsChecked $Redux.Hide.Hearts)       -or (IsChecked $Redux.Interface.Hide) )   { ChangeBytes -Offset "ADADEC" -Values "10 00"       } # Disable Hearts Render

    if ( (IsChecked $Redux.Hide.Magic) -or (IsChecked $Redux.Interface.Hide) ) {
        ChangeBytes -Offset "B587C0" -Values "24 0F 03 1A"; ChangeBytes -Offset "B587A0" -Values "24 0E 01 22"; ChangeBytes -Offset "B587B4" -Values "24 19 01 2A" # Magic Meter / Magic Bar - Small (Y pos) / Magic Bar - Large (Y pos)
    }

    if ( (IsChecked $Redux.Hide.Icons) -or (IsChecked $Redux.Interface.Hide) ) {
        ChangeBytes -Offset "B58CFC" -Values "24 0F 00 00" # Clock - Digits (scale)
        $Values = @();     for ($i=0; $i -lt 256; $i++) { $Values += 0 };     ChangeBytes -Offset "1A3E000" -Values $Values     # Clock - Icon
        $Values = @();     for ($i=0; $i -lt 768; $i++) { $Values += 0 };     ChangeBytes -Offset "1A3E600" -Values $Values     # Score Counter - Icon
    }

    if ( (IsChecked $Redux.Hide.Rupees)      -or (IsChecked $Redux.Interface.Hide) )          { ChangeBytes -Offset "AEB7B0" -Values "24 0C 03 1A"; ChangeBytes -Offset "AEBC48" -Values "24 0D 01 CE" } # Rupees - Icon / Rupees - Text (Y pos)
    if ( (IsChecked $Redux.Hide.DungeonKeys) -or (IsChecked $Redux.Interface.Hide) )          { ChangeBytes -Offset "AEB8AC" -Values "24 0F 03 1A"; ChangeBytes -Offset "AEBA00" -Values "24 19 01 BE" } # Key    - Icon / Key    - Text (Y pos)
    if ( (IsChecked $Redux.Hide.Credits)     -or (IsChecked $Redux.Interface.HideCredits) )   { PatchBytes  -Offset "966000" -Patch "Message\credits.bin" }



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

        if (IsIndex -Elem $Redux.Graphics.AdultModels -Text "Original") { $offsetAdult = "F04A40"; $folderAdult = "Ocarina of Time" }

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

    if (IsInterface -Beginner -Advanced) {
        PatchReplaceMusic -bankPointerTableStart "B899EC" -BankPointerTableEnd "B89AD0" -PointerTableStart "B89AE0" -PointerTableEnd "B8A1C0" -SeqStart "29DE0" -SeqEnd "79470"
        PatchMuteMusic -SequenceTable "B89AE0" -Sequence "29DE0" -Length 108
    }

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
        $Multiply = $True 
        if     (IsIndex -Elem $Redux.Hero.MonsterHP)                          { $multi = 0   }
        elseif (IsIndex -Elem $Redux.Hero.MonsterHP -Text "Max Monster HP")   { $multi = 255; $multiply = $False }
        else                                                                  { [float]$multi = [float]$Redux.Hero.MonsterHP.text.split('x')[0] }

        IncreaseHP -Offset "EEF780" -Value $multi -Multiply $multiply; IncreaseHP -Offset "C6471B" -Value $multi -Multiply $multiply; IncreaseHP -Offset "C51A9F" -Value $multi -Multiply $multiply # Guay, Torch Slug, Gohma Larva
        IncreaseHP -Offset "D74393" -Value $multi -Multiply $multiply; IncreaseHP -Offset "C2F97F" -Value $multi -Multiply $multiply; IncreaseHP -Offset "C0DEF8" -Value $multi -Multiply $multiply # Like-Like, Peehat, Octorok
        IncreaseHP -Offset "D463BF" -Value $multi -Multiply $multiply; IncreaseHP -Offset "CA85DC" -Value $multi -Multiply $multiply; IncreaseHP -Offset "DADBAF" -Value $multi -Multiply $multiply # Shell Blade, Mad Scrub, Spike
        IncreaseHP -Offset "C83647" -Value $multi -Multiply $multiply; IncreaseHP -Offset "C83817" -Value $value -Multiply $multiply; IncreaseHP -Offset "C836AB" -Value $multi -Multiply $multiply # Moblin, Moblin (Spear), Moblin (Club)
        IncreaseHP -Offset "C5F69C" -Value $multi -Multiply $multiply; IncreaseHP -Offset "CAAF9C" -Value $value -Multiply $multiply; IncreaseHP -Offset "C55A78" -Value $multi -Multiply $multiply # Biri, Bari, Shabom
        IncreaseHP -Offset "CD724F" -Value $multi -Multiply $multiply; IncreaseHP -Offset "EDC597" -Value $value -Multiply $multiply; IncreaseHP -Offset "C0B804" -Value $multi -Multiply $multiply # ReDead / Gibdo, Stalchild, Poe
        IncreaseHP -Offset "CB1903" -Value $multi -Multiply $multiply; IncreaseHP -Offset "CB2DD7" -Value $value -Multiply $multiply # Blue Bubble, Red Blue
        IncreaseHP -Offset "D76A07" -Value $multi -Multiply $multiply; IncreaseHP -Offset "C5FC3F" -Value $value -Multiply $multiply # Tentacle, Tailpasaran
        IncreaseHP -Offset "C693CC" -Value $multi -Multiply $multiply; IncreaseHP -Offset "EB797C" -Value $value -Multiply $multiply # Stinger (Land), Stinger (Water)
        IncreaseHP -Offset "C2B183" -Value $multi -Multiply $multiply; IncreaseHP -Offset "C2B1F7" -Value $value -Multiply $multiply # Red Tektite, Blue Tektite
        IncreaseHP -Offset "C1097C" -Value $multi -Multiply $multiply; IncreaseHP -Offset "CD582C" -Value $value -Multiply $multiply # Wallmaster, Floormaster
        IncreaseHP -Offset "C2DEE7" -Value $multi -Multiply $multiply; IncreaseHP -Offset "C2DF4B" -Value $value -Multiply $multiply # Leever (Green / Purple)
        IncreaseHP -Offset "CC6CA7" -Value $multi -Multiply $multiply; IncreaseHP -Offset "CC6CAB" -Value $value -Multiply $multiply # Beamos
        IncreaseHP -Offset "C11177" -Value $multi -Multiply $multiply; IncreaseHP -Offset "C599BC" -Value $value -Multiply $multiply # Dodongo, Baby Dodongo
        IncreaseHP -Offset "CE60C4" -Value $multi -Multiply $multiply                                                                # # Skullwalltula (Gold)
        
        if ($multi -ge 2) {
            ChangeBytes -Offset "B65660" -Values "10 01 01 01 10 02 01 01 01 01 01 02 02 02 00 00 00 01 01 00 00 00 01 01 01 01 01 01 00 00 00 00" # Skulltula
            ChangeBytes -Offset "DFE767" -Values "F1 F0 F0 F1 F1 F0 F1 F2 22 F0 F0 F0 F0 F0 22 00 00 00 00 F0 F2 F1 F0 F4 F2"                      # Freezard
            
        }
    }

    if (IsIndex -Elem $Redux.Hero.MiniBossHP -Index 3 -Not) { # Mini-Bosses
        $mulitply = $True
        if     (IsIndex -Elem $Redux.Hero.MiniBossHP)                            { $multi = 0   }
        elseif (IsIndex -Elem $Redux.Hero.MiniBossHP -Text "Max Mini-Boss HP")   { $multi = 255; $multiply = $False  }
        else                                                                     { [float]$multi = [float]$Redux.Hero.MiniBossHP.text.split('x')[0] }

        IncreaseHP -Offset "BFADAB" -Value $multi -Multiply $multiply; IncreaseHP -Offset "D09283" -Value $multi -Multiply $multiply; IncreaseHP -Offset "CDE1FC" -Value $multi -Multiply $multiply # Stalfos, Dead Hand, Poe Sisters
        IncreaseHP -Offset "C3452F" -Value $multi -Multiply $multiply; IncreaseHP -Offset "C3453B" -Value $multi -Multiply $multiply # Lizalfos, Dinolfos
        IncreaseHP -Offset "ED80EB" -Value $multi -Multiply $multiply # Wolfos
        IncreaseHP -Offset "EBC8B7" -Value $multi -Multiply $multiply # Gerudo Fighter
        IncreaseHP -Offset "CF2667" -Value $multi -Multiply $multiply # Flare Dancer
        IncreaseHP -Offset "DEF87F" -Value $multi -Multiply $multiply # Skull Kid
        IncreaseHP -Offset "D49F50" -Value $multi -Multiply $multiply # Big Octo

        if ($multi -eq 255 -and !$multiply) { ChangeBytes -Offset "DE9A1B" -Values "FF" ChangeBytes -Offset "DEB367" -Values "7F" -IsDec; ChangeBytes -Offset "DEB34F" -Values "7F" } # Iron Knuckle (phase 1), Iron Knuckle (phase 2)
        elseif ($multi -gt 0) {
            MultiplyBytes -Offset "DE9A1B" -Factor $multi                                      # Iron Knuckle (phase 1)
            $value = $ByteArrayGame[(GetDecimal "DEB367")]; $value--; $value *= $multi; $value++;
            ChangeBytes -Offset "DEB367" -Values $value -IsDec; ChangeBytes -Offset "DEB34F" -Values $value # Iron Knuckle (phase 2)
        }
        else { ChangeBytes -Offset "DE9A1B" -Values "01"; ChangeBytes -Offset "DEB367" -Values "01" -IsDec; ChangeBytes -Offset "DEB34F" -Values "01" } # Iron Knuckle (phase 1), Iron Knuckle (phase 2)
    }
    
    if (IsIndex -Elem $Redux.Hero.BossHP -Index 3 -Not) { # Bosses
        $mulitply = $True
        if     (IsIndex -Elem $Redux.Hero.BossHP)                       { $multi = 0   }
        elseif (IsIndex -Elem $Redux.Hero.BossHP -Text "Max Boss HP")   { $multi = 255; $multiply = $False   }
        else                                                            { [float]$multi = [float]$Redux.Hero.BossHP.text.split('x')[0] }

        IncreaseHP -Offset "C44F2B" -Value $multi -Multiply $multiply; ChangeBytes -Offset "C486CC" -Values "00 00 00 00" # Gohma
        IncreaseHP -Offset "D258BB" -Value $multi -Multiply $multiply; IncreaseHP  -Offset "D25B0B" -Value $multi -Multiply $multiply # Barinade
        IncreaseHP -Offset "D64EFB" -Value $multi -Multiply $multiply; IncreaseHP  -Offset "D6223F" -Value $multi -Multiply $multiply # Twinrova
        IncreaseHP -Offset "C3B9FF" -Value $multi -Multiply $multiply # King Dodongo
        IncreaseHP -Offset "CE6D2F" -Value $multi -Multiply $multiply # Volvagia
        IncreaseHP -Offset "D3B4A7" -Value $multi -Multiply $multiply # Morpha
        IncreaseHP -Offset "DAC824" -Value $multi -Multiply $multiply # Bongo Bongo
        IncreaseHP -Offset "D7FDA3" -Value $multi -Multiply $multiply # Ganondorf 
        
        if ($multi -eq 255 -and !$multiply) {
            ChangeBytes -Offset "C91F8F" -Values "FF"; ChangeBytes -Offset "CAFF33" -Values "7F" # Phantom Ganon (phase 1), Phantom Ganon (phase 2)
            ChangeBytes -Offset "E82AFB" -Values "FF"; ChangeBytes -Offset "E87F2F" -Values "7F" # Ganon (phase 1), Ganon (phase 2)
        }
        elseif ($multi -gt 0) {
            ChangeBytes -Offset "C91F8F" -Factor $multi # Phantom Ganon (phase 1)
            $value = $ByteArrayGame[(GetDecimal "C91F8F")]; $value -= (2 * 3 * $multi); $value++
            ChangeBytes -Offset "CAFF33" -Values $value # Phantom Ganon (phase 2)

            ChangeBytes -Offset "E82AFB" -Factor $multi # Ganon (phase 1)
            $value = $ByteArrayGame[(GetDecimal "E87F2F")]; $value--; $value *= $multi; $value++;
            ChangeBytes -Offset "E87F2F" -Values $value # Ganon (phase 2)
        }
        else {
            ChangeBytes -Offset "C91F8F" -Values "04"; ChangeBytes -Offset "CAFF33" -Values "03" # Phantom Ganon (phase 1), Phantom Ganon (phase 2)
            ChangeBytes -Offset "E82AFB" -Values "04"; ChangeBytes -Offset "E87F2F" -Values "03" # Ganon (phase 1), Ganon (phase 2)
        }
    }

    if (IsChecked $Redux.Hero.NoItemDrops) {
        $Values = @()
        for ($i=0; $i -lt 80; $i++) { $Values += 0 }
        ChangeBytes -Offset "B5D6B0" -Values $Values
    }

    if (IsChecked $Redux.Hero.NoRecoveryHearts)   { ChangeBytes -Offset "A895B7"  -Values "2E" }

    
    
    # EQUIPMENT COLORS #

    if (IsSet $Redux.Colors.SetEquipment) {
        if (IsDefaultColor -Elem $Redux.Colors.SetEquipment[0] -Not) { # Kokiri Tunic
            ChangeBytes -Offset "B6DA38" -Values @($Redux.Colors.SetEquipment[0].Color.R, $Redux.Colors.SetEquipment[0].Color.G, $Redux.Colors.SetEquipment[0].Color.B)
            if ( (IsText -Elem $Redux.Colors.Equipment[0] -Compare "Randomized" -Not) -and (IsText -Elem $Redux.Colors.Equipment[0] -Compare "Custom" -Not) ) { PatchBytes -Offset "7FE000"  -Texture -Patch ("Tunic\" + $Redux.Colors.Equipment[0].text.replace(" (default)", "") + ".bin") }
        }

        if (IsDefaultColor -Elem $Redux.Colors.SetEquipment[1] -Not) { # Goron Tunic
            ChangeBytes -Offset "B6DA3B" -Values @($Redux.Colors.SetEquipment[1].Color.R, $Redux.Colors.SetEquipment[1].Color.G, $Redux.Colors.SetEquipment[1].Color.B)
            if ( (IsText -Elem $Redux.Colors.Equipment[1] -Compare "Randomized" -Not) -and (IsText -Elem $Redux.Colors.Equipment[1] -Compare "Custom" -Not) ) { PatchBytes -Offset "7FF000"  -Texture -Patch ("Tunic\" + $Redux.Colors.Equipment[1].text.replace(" (default)", "") + ".bin") }
        }

        if (IsDefaultColor -Elem $Redux.Colors.SetEquipment[2] -Not) { # Zora Tunic
            ChangeBytes -Offset "B6DA3E" -Values @($Redux.Colors.SetEquipment[2].Color.R, $Redux.Colors.SetEquipment[2].Color.G, $Redux.Colors.SetEquipment[2].Color.B)
            if ( (IsText -Elem $Redux.Colors.Equipment[2] -Compare "Randomized" -Not) -and (IsText -Elem $Redux.Colors.Equipment[2] -Compare "Custom" -Not) ) { PatchBytes -Offset "800000"  -Texture -Patch ("Tunic\" + $Redux.Colors.Equipment[2].text.replace(" (default)", "") + ".bin") }
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
            ChangeBytes -Offset "B5E184" -Values @($Redux.Colors.SetFairy[0].Color.R, $Redux.Colors.SetFairy[0].Color.G, $Redux.Colors.SetFairy[0].Color.B, 255, $Redux.Colors.SetFairy[1].Color.R, $Redux.Colors.SetFairy[1].Color.G, $Redux.Colors.SetFairy[1].Color.B, 0)
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
        ChangeBytes -Offset "B71EE8" -Values $Redux.Capacity["DekuSticks" + ($Redux.Save.DekuSticks.SelectedIndex + 1)].Text # Deku Sticks
        ChangeBytes -Offset "B71EE9" -Values $Redux.Capacity["DekuNuts"   + ($Redux.Save.DekuNuts.SelectedIndex   + 1)].Text # Deku Nuts
        ChangeBytes -Offset "B71EEE" -Values $Redux.Capacity["BulletBag"  + ($Redux.Save.BulletBag.SelectedIndex  + 1)].Text # Bullet Seeds
        ChangeBytes -Offset "B71EEB" -Values $Redux.Capacity["Quiver"     + ($Redux.Save.Quiver.SelectedIndex     + 1)].Text # Arrows
        ChangeBytes -Offset "B71EEA" -Values $Redux.Capacity["BombBag"    + ($Redux.Save.BombBag.SelectedIndex    + 1)].Text # Bombs
    }

    if (IsDefault $Redux.Save.Hearts   -Not)   { $value = Get16Bit ([int]$Redux.Save.Hearts.Text * 16); ChangeBytes -Offset "B71E8A" -Values $value; ChangeBytes -Offset "B71E8C" -Values $value; ChangeBytes -Offset "B0635E" -Values $value; ChangeBytes -Offset "B06366" -Values $value }
    if (IsChecked $Redux.Save.DoubleDefense)   { ChangeBytes -Offset "B71E99" -Values "01"; ChangeBytes -Offset "B71F2B" -Values $Redux.Save.Hearts.Text }
    if (IsChecked $Redux.Save.Magic)           { ChangeBytes -Offset "B71E96" -Values "01" }
    if (IsChecked $Redux.Save.DoubleMagic)     { ChangeBytes -Offset "B71E98" -Values "01"; ChangeBytes -Offset "B71E8F" -Values "60" }



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
        ChangeBytes -Offset "B6EC2F" -Values @($Redux.Capacity.Quiver1.Text,     $Redux.Capacity.Quiver2.Text,     $Redux.Capacity.Quiver3.Text)     -Interval 2
        ChangeBytes -Offset "B6EC37" -Values @($Redux.Capacity.BombBag1.Text,    $Redux.Capacity.BombBag2.Text,    $Redux.Capacity.BombBag3.Text)    -Interval 2
        ChangeBytes -Offset "B6EC57" -Values @($Redux.Capacity.BulletBag1.Text,  $Redux.Capacity.BulletBag2.Text,  $Redux.Capacity.BulletBag3.Text)  -Interval 2
        ChangeBytes -Offset "B6EC5F" -Values @($Redux.Capacity.DekuSticks1.Text, $Redux.Capacity.DekuSticks2.Text, $Redux.Capacity.DekuSticks3.Text) -Interval 2
        ChangeBytes -Offset "B6EC67" -Values @($Redux.Capacity.DekuNuts1.Text,   $Redux.Capacity.DekuNuts2.Text,   $Redux.Capacity.DekuNuts3.Text)   -Interval 2

        # Initial Ammo
        ChangeBytes -Offset "AE6D03" -Values $Redux.Capacity.BulletBag1.Text
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

    if (IsChecked $Redux.Equipment.HerosBowIcons) {
        PatchBytes -Offset "7C0000" -Texture -Patch "Equipment\Bow\heros_bow.icon"
        PatchBytes -Offset "7F5000" -Texture -Patch "Equipment\Bow\heros_bow_fire.icon"
        PatchBytes -Offset "7F6000" -Texture -Patch "Equipment\Bow\heros_bow_ice.icon"
        PatchBytes -Offset "7F7000" -Texture -Patch "Equipment\Bow\heros_bow_light.icon"
        PatchBytes -Offset "89F800" -Texture -Patch "Equipment\Bow\heros_bow.en.label"
    }

    if (IsChecked $Redux.Equipment.FireProofDekuShield)   { ChangeBytes -Offset "BD3C5B" -Values "00" }
    if (IsChecked $Redux.Equipment.UnsheathSword)         { ChangeBytes -Offset "BD04A0" -Values "28 42 00 05 14 40 00 05 00 00 10 25" }
    if (IsChecked $Redux.Equipment.HookshotIcon)          { PatchBytes  -Offset "7C7000" -Texture -Patch "Equipment\Hookshot\termina_hookshot.icon" }



    
    # SWORDS AND SHIELDS #

    if (TestFile ($GameFiles.textures + "\Equipment\Kokiri Sword\" + $Redux.Equipment.KokiriSword.text + ".icon"))               { PatchBytes -Offset "7F8000" -Texture -Patch ("Equipment\Kokiri Sword\" + $Redux.Equipment.KokiriSword.text + ".icon")     }
    if (TestFile ($GameFiles.textures + "\Equipment\Kokiri Sword\" + $Redux.Equipment.KokiriSword.text + ".en.label"))           { PatchBytes -Offset "8AD800" -Texture -Patch ("Equipment\Kokiri Sword\" + $Redux.Equipment.KokiriSword.text + ".en.label") }

    if (TestFile ($GameFiles.textures + "\Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text + ".icon"))               { PatchBytes -Offset "7F9000" -Texture -Patch ("Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text + ".icon")     }
    if (TestFile ($GameFiles.textures + "\Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text + ".en.label"))           { PatchBytes -Offset "8ADC00" -Texture -Patch ("Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text + ".en.label") }

    if ($ChildModel.deku_shield -ne 0) {
        if (TestFile ($GameFiles.textures + "\Equipment\Deku Shield\" + $Redux.Equipment.DekuShield.text + ".front") ) {
            $Offset = SearchBytes -Start "FBE000" -End "FEAF80" -Values "CC 99 E5 E5 DD A3 EE 2B DD A5 E6 29 DD A5 D4 DB"
            if ($Offset -gt 0)                                                                                                   { PatchBytes -Offset $Offset  -Texture -Patch ("Equipment\Deku Shield\"   + $Redux.Equipment.DekuShield.text + ".front") }
        }
        if (TestFile ($GameFiles.textures + "\Equipment\Deku Shield\" + $Redux.Equipment.DekuShield.text + ".back") ) {
            $Offset = SearchBytes -Start "FBE000" -End "FEAF80" -Values "DC 11 F5 17 F5 19 DC 57 D4 59 E4 DB E4 DB DC 97"
            if ($Offset -gt 0)                                                                                                   { PatchBytes -Offset $Offset  -Texture -Patch ("Equipment\Deku Shield\"   + $Redux.Equipment.DekuShield.text + ".back") }
        }
    }
    if (TestFile ($GameFiles.textures + "\Equipment\Deku Shield\" + $Redux.Equipment.DekuShield.text + ".icon"))                 { PatchBytes -Offset "7FB000" -Texture -Patch ("Equipment\Deku Shield\"   + $Redux.Equipment.DekuShield.text + ".icon")  }
    if (TestFile ($GameFiles.textures + "\Equipment\Deku Shield\" + $Redux.Equipment.DekuShield.text + ".label"))                { PatchBytes -Offset "8AE400" -Texture -Patch ("Equipment\Deku Shield\"   + $Redux.Equipment.DekuShield.text + ".label") }

    if ($ChildModel.hylian_shield -ne 0 -and $AdultModel.hylian_shield -ne 0 -and (TestFile ($GameFiles.textures + "\Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".bin"))) {
        PatchBytes -Offset "F03400" -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".bin")
        $Offset = SearchBytes -Start "FBE000" -End "FEAF80" -Values "BE 35 BE 77 C6 B9 CE FB D6 FD D7 3D DF 3F DF 7F"
        if ($Offset -gt 0)                                                                                                       { PatchBytes -Offset $Offset  -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".bin") }
    }
    if (TestFile ($GameFiles.textures + "\Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".icon"))             { PatchBytes -Offset "7FC000" -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".icon")     }
    if (TestFile ($GameFiles.textures + "\Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".en.label"))         { PatchBytes -Offset "8AE800" -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".en.label") }

    if ($AdultModel.mirror_shield -ne 0 -and (TestFile ($GameFiles.textures + "\Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".bin"))) {
        $Offset = SearchBytes -Start "F86000" -End "FBD800" -Values "90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90"
        PatchBytes -Offset $Offset -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".bin")
        if (TestFile ($GameFiles.textures + "\Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".chest"))        { PatchBytes -Offset "1616000" -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".chest")      }
        if (TestFile ($GameFiles.textures + "\Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".reflection"))   { PatchBytes -Offset "1456388" -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".reflection") }
    }
    if (TestFile ($GameFiles.textures + "\Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".icon"))             { PatchBytes -Offset "7FD000"  -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".icon")     }
    if (TestFile ($GameFiles.textures + "\Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".en.label"))         { PatchBytes -Offset "8AEC00"  -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".en.label") }

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
    if (IsValue -Elem $Redux.Hitbox.Longshot          -Not)   { ChangeBytes -Offset "CAD3B7" -Values (Get8Bit $Redux.Hitbox.Longshot.Value)                  }



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



    # SCRIPT #

    if (IsDefault $Redux.Text.NaviPrompt -Not) {
        ChangeBytes -Offset "AE7CD8" -Values "00 00 00 00"
        PatchBytes  -Offset "8E3A80" -Texture -Patch ("Action Prompts\Navi\" + $Redux.Text.NaviPrompt.text + ".prompt")
    }

    if (IsChecked $Redux.Text.KeatonMaskFix)   { PatchBytes  -Offset "8A7C00" -Texture -Patch "Text Labels\keaton_mask.en.label" }
    if (IsChecked $Redux.Text.Fairy)           { PatchBytes  -Offset "8A4C00" -Texture -Patch "Text Labels\fairy.en.label"       }
    if (IsChecked $Redux.Text.Milk)            { PatchBytes  -Offset "8A5400" -Texture -Patch "Text Labels\milk.en.label"; PatchBytes  -Offset "8A6800" -Texture -Patch "Text Labels\milk_half.en.label" }
    if (IsIndex   $Redux.Text.NaviCUp -Not)    { PatchBytes -Offset "1A3EFC0" -Texture -Patch ("Action Prompts\Navi\" + $Redux.Text.NaviCUp.text + ".cup") }

}



#==============================================================================================================================================================================================
function ByteReduxOptions() {
    
    # INTERFACE ICONS #

    if (IsChecked $Redux.UI.ShowFileSelectIcons)   { PatchBytes  -Offset "BAF738"  -Patch "file_select.bin" }
    if (IsChecked $Redux.UI.DPadLayoutShow)        { ChangeBytes -Offset "348086E" -Values "01"             }
    if (IsChecked $Redux.UI.RupeeIconColors)       { ChangeBytes -Offset "AEB764"  -Values "26 38 00 08 AE 98 02 B0 0C 10 1C 8D AE 39 00 00 96 EC 02 52 00 40 08 21" }



     # BUTTON COLORS #

     if (IsDefaultColor -Elem $Redux.Colors.SetButtons[0] -Not) { # A Button
        ChangeBytes -Offset "3480845" -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) -Interval 2
        ChangeBytes -Offset "3480863" -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) -Interval 2 # Note Button

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

    if (IsDefaultColor -Elem $Redux.Colors.SetButtons[1] -Not) { ChangeBytes -Offset "348084B" -Values @($Redux.Colors.SetButtons[1].Color.R, $Redux.Colors.SetButtons[1].Color.G, $Redux.Colors.SetButtons[1].Color.B) -Interval 2 } # B Button 

    if (IsDefaultColor -Elem $Redux.Colors.SetButtons[2] -Not) { # C Buttons
        ChangeBytes -Offset "3480851" -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) -Interval 2
        
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
        }
    }

    if (IsDefaultColor -Elem $Redux.Colors.SetButtons[3] -Not) { # Start Button
        ChangeBytes -Offset "AE9EC6" -Values @($Redux.Colors.SetButtons[3].Color.R, $Redux.Colors.SetButtons[3].Color.G) # Red + Green
        ChangeBytes -Offset "AE9ED8" -Values @(53, 238, $Redux.Colors.SetButtons[3].Color.B) # Blue
    }



    # HUD COLORS #

    if (IsChecked $Redux.UI.GCScheme) {
        ChangeBytes -Offset "348085F" -Values "FF 00 50" # Cursor
        ChangeBytes -Offset "3480859" -Values "C8 00 50" # Cursor
    }

}



#==============================================================================================================================================================================================
function ByteLanguageOptions() {
    
    if ( (IsChecked $Redux.UI.GCScheme) -or (IsIndex -Elem $Redux.Text.NaviScript -Not) -or (IsChecked $Redux.Capacity.EnableAmmo) -or (IsChecked $Redux.Capacity.EnableWallet) -or ( (IsText -Elem $Redux.Equipment.DekuShield -Compare "Iron Shield") -and $ChildModel.deku_shield -ne 0) ) {
        $script = $GameFiles.extracted + "\message_data_static.bin"
        $table  = $GameFiles.extracted + "\message_data.tbl"
        ExportBytes -Offset "92D000" -Length "380E0" -Output $script -Force
    }
    else { return }
  
    if (IsChecked $Redux.UI.GCScheme) {
        if (IsChecked $Redux.Language[0]) { # English only
            # Hole of Z
            $offset = SearchBytes -File $script -Values "48 6F 6C 65 20 6F 66 20 22 5A 22"
            ChangeBytes -File $script -Offset $offset -Values "48 6F 6C 65 20 6F 66 20 22 4C 22"

            # GC Colors
            $offset = SearchBytes -File $script -Values "62 6C 75 65 20 69 63 6F 6E 05 40 02 00 00 54 68"
            ChangeBytes -File $script -Offset $offset -Values "67 72 65 65 6E 20 69 63 6F 6E 05 40 02"
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

    if (IsIndex -Elem $Redux.Text.NaviScript -Not) {
        $offset  = 0
        $replace = ""
        for ($i=0; $i -lt $Redux.Text.NaviScript.text.length; $i++) {
            $replace += Get8Bit ([byte]$Redux.Text.NaviScript.text[$i])
        }

        do { # Navi -> New
            $offset = SearchBytes -File $script -Start $offset -Values "4E 61 76 69"
            if ($offset -ge 0) { ChangeBytes -File $script -Offset $offset -Values $replace }
        } while ($offset -ge 0)
    }

    if (IsChecked $Redux.Capacity.EnableAmmo) {
        ChangeStringIntoDigits -File $script -Search "34 30 20 05 40 69 6E 20 74 6F 74 61 6C"    -Value $Redux.Capacity.Quiver2.Text
        ChangeStringIntoDigits -File $script -Search "35 30 05 40 21 02 00 00 1A 13"             -Value $Redux.Capacity.Quiver3.Text

        ChangeStringIntoDigits -File $script -Search "32 30 20 42 6F 6D 62 73"                   -Value $Redux.Capacity.BombBag1.Text
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

    if (IsChecked $Redux.Capacity.EnableWallet) {
        if ($Redux.Capacity.Wallet2.Text.Length -gt 3)   { $Text = "999" }
        else                                             { $Text = $Redux.Capacity.Wallet2.Text }
        ChangeStringIntoDigits -File $script -Search "32 30 30 05 40 20 05 46 52 75 70 65 65 73 05 40 2E 02 00" -Value $Text -Triple

        if ($Redux.Capacity.Wallet3.Text.Length -gt 3)   { $Text = "999" }
        else                                             { $Text = $Redux.Capacity.Wallet3.Text }
        ChangeStringIntoDigits -File $script -Search "35 30 30 05 40 20 05 46 52 75 70 65 65 73 05 40 2E 02 13" -Value $Text -Triple

        $Text = $null
    }

    if ( (IsText -Elem $Redux.Equipment.DekuShield -Compare "Iron Shield") -and $ChildModel.deku_shield -ne 0) {
        $offset = 0
        do { # Deku Shield -> Iron Shield
            $offset = SearchBytes -File $script -Start $offset -Values "44 65 6B 75 20 53 68 69 65 6C 64"
            if ($offset -ge 0) { ChangeBytes -File $script -Offset $offset -Values "49 72 6F 6E 20 53 68 69 65 6C 64" }
        } while ($offset -ge 0)
    }

    PatchBytes -Offset "92D000" -Patch "message_data_static.bin" -Extracted

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    if     (IsInterface -Beginner)      { CreateOptionsDialog -Columns 6 -Height 545 -Tabs @("Main", "Graphics", "Audio", "Difficulty") }
    elseif (IsInterface -Lite)          { CreateOptionsDialog -Columns 6 -Height 660 -Tabs @("Main", "Graphics", "Audio", "Difficulty", "Capacity") }
    elseif (IsInterface -Advanced)      { CreateOptionsDialog -Columns 6 -Height 660 -Tabs @("Main", "Graphics", "Audio", "Difficulty", "Colors", "Equipment 1", "Equipment 2", "Equipment 3", "Capacity", "Animations") }
    elseif (IsInterface -Streamlined)   { CreateOptionsDialog -Columns 6 -Height 565 -Tabs @("Main", "Graphics", "Audio", "Difficulty", "Equipment 1", "Equipment 2", "Animations") }

}



#==============================================================================================================================================================================================
function CreateTabMain() {

    # GAMEPLAY #

    CreateReduxGroup    -Tag  "Gameplay" -Text "Gameplay" 
    CreateReduxCheckBox -Name "EasierMinigames"        -Text "Easier Minigames"      -Beginner -Advanced -Info "Certain minigames are made easier and faster`n- Dampe's Digging Game is first try always`n- Fishing is less random and has less demanding requirements`n- Bombchu Bowling prizes now appear in fixed order instead of random" -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "ReturnChild"            -Text "Can Always Return"     -Beginner -Advanced -Info "You can always go back to being a child again before clearing the boss of the Forest Temple`nOut of the way Sheik!"            -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "Medallions"             -Text "Require All Medallions"          -Advanced -Info "All six medallions are required for the Rainbow Bridge to appear before Ganon's Castle`nThe vanilla requirements were the Shadow and Spirit Medallions and the Light Arrows" -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "RutoNeverDisappears"    -Text "Ruto Never Disappears" -Beginner -Advanced -Info "Ruto never disappears in Jabu Jabu's Belly and will remain in place when leaving the room"                                     -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "AlwaysMoveKingZora"     -Text "Always Move King Zora"           -Advanced -Info "King Zora will move aside even if the Zora Sapphire is in possession"                                                          -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "DistantZTargeting"      -Text "Distant Z-Targeting"             -Advanced -Info "Allow to use Z-Targeting on enemies, objects and NPC's from any distance"                                                      -Credits "Admentus"
    CreateReduxCheckBox -Name "ManualJump"             -Text "Manual Jump"               -Lite -Advanced -Info "Press Z + A to do a Manual Jump instead of a Jump Attack`nPress B mid-air after jumping to do a Jump Attack"                   -Credits "Admentus (ROM) & CloudModding (GameShark)"
    CreateReduxCheckBox -Name "NoKillFlash"            -Text "No Kill Flash"             -Lite -Advanced -Info "Disable the flash effect when killing certain enemies such as the Guay or Skullwalltula"                                       -Credits "Chez Cousteau"
    CreateReduxCheckBox -Name "NoShieldRecoil"         -Text "No Shield Recoil"          -Lite -Advanced -Info "Disable the recoil when being hit while shielding"                                                                             -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxCheckBox -Name "RunWhileShielding"      -Text "Run While Shielding"       -Lite -Advanced -Info "Press R to shield will no longer prevent Link from moving around" -Link $Redux.Gameplay.NoShieldRecoil                         -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxCheckBox -Name "PushbackAttackingWalls" -Text "Pushback Attacking Walls"  -Lite -Advanced -Info "Link is getting pushed back a bit when hitting the wall with the sword"                                                        -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxCheckBox -Name "RemoveCrouchStab"       -Text "Remove Crouch Stab"        -Lite -Advanced -Info "The Crouch Stab move is removed"                                                                                               -Credits "Garo-Mastah"
    CreateReduxCheckBox -Name "ResumeLastArea"         -Text "Resume From Last Area"                     -Info "Resume playing from the area you last saved in" -Warning "Be careful of saving in Grottos"                                     -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxCheckBox -Name "AllowWarpSongs"         -Text "Allow Warp Songs"      -Beginner -Advanced -Info "Allow warp songs in Gerudo Training Ground and Ganon's Castle"                                                                 -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "AllowFaroreWind"        -Text "Allow Farore's Wind"   -Beginner -Advanced -Info "Allow Farore's Wind in Gerudo Training Ground and Ganon's Castle"                                                              -Credits "Ported from Rando"

    $Last.Column = 1; $Last.Row++
    CreateReduxComboBox -Name "SpawnChild" -Text "Child Starting Location" -Advanced -Default 1 -Items ("Link's House", "Temple of Time", "Hyrule Field", "Kakariko Village", "Inside the Deku Tree", "Dodongo's Cavern", "Inside Jabu-Jabu's Belly", "Forest Temple", "Fire Temple", "Water Temple", "Shadow Temple", "Spirit Temple", "Ice Cavern", "Bottom of the Well", "Thieves' Hideout", "Gerudo's Training Ground", "Inside Ganon's Castle", "Ganon's Tower") -Credits "Admentus & GhostlyDark"
    CreateReduxComboBox -Name "SpawnAdult" -Text "Adult Starting Location" -Advanced -Default 2 -Items ("Link's House", "Temple of Time", "Hyrule Field", "Kakariko Village", "Inside the Deku Tree", "Dodongo's Cavern", "Inside Jabu-Jabu's Belly", "Forest Temple", "Fire Temple", "Water Temple", "Shadow Temple", "Spirit Temple", "Ice Cavern", "Bottom of the Well", "Thieves' Hideout", "Gerudo's Training Ground", "Inside Ganon's Castle", "Ganon's Tower") -Credits "Admentus & GhostlyDark"



    # RESTORE #

    CreateReduxGroup    -Tag  "Restore"     -Text "Restore / Correct / Censor"
    CreateReduxCheckBox -Name "RupeeColors" -Text "Correct Rupee Colors"             -Info "Corrects the colors for the Purple (50) and Golden (200) Rupees"         -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "CowNoseRing" -Text "Restore Cow Nose Ring"            -Info "Restore the rings in the noses for Cows as seen in the Japanese release" -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "FireTemple"  -Text "Censor Fire Temple"     -Advanced -Info "Censor Fire Temple theme as used in the Rev 2 ROM" -Credits "ShadowOne333"
    CreateReduxComboBox -Name "Blood"       -Text "Blood Color"      -Lite -Advanced -Info "Change the color of blood used for several monsters, Ganondorf and Ganon" -Items @("Default", "Red blood for monsters", "Green blood for Ganondorf/Ganon", "Change both") -Credits "ShadowOne333 & Admentus"
    


    # FIXES #

    CreateReduxGroup    -Tag  "Fixes"            -Text "Fixes"
    CreateReduxCheckBox -Name "PauseScreenDelay" -Text "Pause Screen Delay"      -Checked        -Info "Removes the delay when opening the Pause Screen by removing the anti-aliasing" -Native          -Credits "zel"
    CreateReduxCheckBox -Name "PauseScreenCrash" -Text "Pause Screen Crash Fix"  -Checked        -Info "Prevents the game from randomly crashing emulating a decompressed ROM upon pausing"             -Credits "zel"
    CreateReduxCheckBox -Name "PoacherSaw"       -Text "Poacher's Saw"           -Checked        -Info "Obtaining the Poacher's Saw no longer prevents Link from obtaining the second Deku Nut upgrade" -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "Boomerang"        -Text "Boomerang"               -Lite -Advanced -Info "Fix the gem color on the thrown boomerang"                                                      -Credits "Aria"
    CreateReduxCheckBox -Name "FortressMinimap"  -Text "Gerudo Fortress Minimap" -Lite -Advanced -Info "Display the complete minimap for the Gerudo Fortress during the Child era"                       -Credits "GhostlyDark"



    # OTHER #

    CreateReduxGroup    -Tag  "Other" -Text "Other"
    CreateReduxCheckBox -Name "RemoveNaviPrompts" -Text "Remove Navi Prompts" -Beginner -Advanced -Info "Navi will no longer interrupt you with text boxes in the first dungeon"                                 -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "DefaultZTargeting" -Text "Default Hold Z-Targeting"      -Advanced -Info "Change the Default Z-Targeting option to Hold instead of Switch"                                        -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "InstantClaimCheck" -Text "Instant Claim Check" -Beginner -Advanced -Info "Remove the check for waiting until the Biggoron Sword can be claimed through the Claim Check"           -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "ItemSelect"        -Text "Translate Item Select"         -Advanced -Info "Translates the Debug Inventory Select menu into English"                                                -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "DiskDrive"         -Text "Enable Disk Drive Saves"       -Advanced -Info "Use the Disk Drive for Save Slots" -Warning "This option disables the use of non-Disk Drive save slots" -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool) & GhostlyDark (ported)"
    
    $Last.Column = 1; $Last.Row++
    CreateReduxComboBox -Name "MapSelect" -Text "Enable Map Select"     -Items @("Disable", "Translate Only", "Enable Only", "Translate and Enable") -Info "Enable the Map Select menu like in the Debug ROM`nThe File Select menu now opens the Map Select menu instead`nA separate debug save file is used" -Credits "Jared Johnson (translated by Zelda Edit)"
    CreateReduxComboBox -Name "SkipIntro" -Text "Skip Intro" -Default 2 -Items @("Don't Skip", "Skip Logo", "Skip Title Screen", "Skip Logo and Title Screen")                               -Info "Skip the logo, title screen or both"           -Credits "Aegiker"
    CreateReduxComboBox -Name "Skybox"    -Text "Skybox"     -Default 3 -Items @("Dawn", "Day", "Dusk", "Night", "Darkness (Dawn)", "Darkness (Day)", "Darkness (Dusk)", "Darkness (Night)") -Info "Set the skybox theme for the File Select menu" -Credits "Admentus"



    # SPEED #

    CreateReduxGroup  -Tag  "Gameplay" -Text "Speed" -Height 1.2
    CreateReduxSlider -Name "MovementSpeed" -Default 650  -Min 300 -Max 1200 -Freq 50 -Small 25 -Large 50 -Text "Link's Speed" -Info "Adjust the movement speed for Link" -Credits "AndiiSyn"

}



#==============================================================================================================================================================================================
function CreateTabRedux() {
    
    # INTERFACE #

    CreateReduxGroup    -Tag  "UI" -Text "Interface Icons"
    CreateReduxCheckBox -Name "ShowFileSelectIcons" -Checked -Text "Show File Select Icons" -Info "Show icons on the File Select screen to display your save file progress"    -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "DPadLayoutShow"      -Checked -Text "Show D-Pad Icon"        -Info "Show the D-Pad icons ingame that display item shortcuts"                    -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "RupeeIconColors"     -Checked -Text "Rupee Icon Colors"      -Info "The color of the Rupees counter icon changes depending on your wallet size" -Credits "Ported from Redux"



    # BUTTON COLORS #

    CreateButtonColorOptions

}



#==============================================================================================================================================================================================
function CreateTabLanguage() {

    # SCRIPT OPTIONS #

    $Redux.Box.Text = CreateReduxGroup -Tag  "Text" -Text "Script Options"
    CreateReduxCheckBox    -Name "KeatonMaskFix" -Text "Keaton Mask Text Fix" -Info 'Fixes the grammatical typo for the "Keaton Mask"'                        -Credits "Redux"
    CreateReduxCheckBox    -Name "Fairy"         -Text "MM Fairy Text"        -Info ("Changes " + '"Bottled Fairy" to "Fairy"' + " as used in Majora's Mask") -Credits "GhostlyDark (ported)"
    CreateReduxCheckBox    -Name "Milk"          -Text "MM Milk Text"         -Info ("Changes " + '"Lon Lon Milk" to "Milk"' + " as used in Majora's Mask")   -Credits "GhostlyDark (ported)"
    CreateReduxCheckBox    -Name "PauseScreen"   -Text "MM Pause Screen"      -Info "Replaces the Pause Screen textures to be styled like Majora's Mask"      -Credits "CM & GhostlyDark"



    # OTHER TEXT OPTIONS #

    $Redux.Box.Text = CreateReduxGroup -Tag "Text" -Text "Other Text Options" -Beginner -Lite -Advanced
    CreateReduxComboBox -Name "NaviPrompt" -Text "Navi A Button Prompt" -Items @("Hidden", "Navi") -FilePath ($GameFiles.textures + "\Action Prompts\Navi") -Ext "prompt" -Info "Replace the A Button prompt for Navi"            -Credits "Aegiker & GhostlyDark (texture fix, injects)"
    CreateReduxComboBox -Name "NaviCUp"    -Text "Navi C-Up Prompt"     -Items @("Navi")           -FilePath ($GameFiles.textures + "\Action Prompts\Navi") -Ext "cup"    -Info "Replace the C-Up Buttn prompt for Navi"          -Credits "GhostlyDark (injects)"
    CreateReduxComboBox -Name "NaviScript" -Text "Navi Text"            -Items @("Navi", "Tatl", "Tael", "Taya", "Nite")                                                  -Info "Change the name for Navi in the dialogue script" -Credits "Admentus"


}



#==============================================================================================================================================================================================
function CreateTabGraphics() {
    
    # GRAPHICS #

    CreateReduxGroup -Tag  "Graphics" -Text "Graphics" -Columns 4

    $Info  = "Patch the game to be in true 16:9 widescreen with the HUD pushed to the edges."
    $Info += "`n`nKnown Issues:"
    $Info += "`n- Backgrounds are 4:3 and centered showing collisions at the sides."
    $Info += "`n- Not compatible with Redux."

    CreateReduxCheckBox -Name "Widescreen"         -Text "16:9 Widescreen (Advanced)"   -Info $Info -Beginner -Advanced -Native                                                                     -Credits "Widescreen Patch by gamemasterplc, enhanced and ported by GhostlyDark"
    CreateReduxCheckBox -Name "WidescreenAlt"      -Text "16:9 Widescreen (Simplified)" -Info "Apply 16:9 Widescreen adjusted backgrounds and textures (as well as 16:9 Widescreen for the Wii VC)" -Credits "Aspect Ratio Fix by Admentus`n16:9 backgrounds by GhostlyDark, ShadowOne333 & CYB3RTRON" -Link $Redux.Graphics.Widescreen
    CreateReduxCheckBox -Name "ExtendedDraw"       -Text "Extended Draw Distance"       -Info "Increases the game's draw distance for objects`nDoes not work on all objects"                        -Credits "Admentus"
    CreateReduxCheckBox -Name "ForceHiresModel"    -Text "Force Hires Link Model"       -Info "Always use Link's High Resolution Model when Link is too far away"                                   -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "HideEquipment"      -Text "Hide Equipment"               -Info "Hide the equipment when it is sheathed"                                                              -Credits "XModxGodX"

    $Models = LoadModelsList -Category "Child"
    CreateReduxComboBox -Name "ChildModels" -Text "Child Model" -Items (@("Original") + $Models) -Default "Original" -Info "Replace the child model used for Link" -Row 3 -Column 1
    $Models = LoadModelsList -Category "Adult"
    CreateReduxComboBox -Name "AdultModels" -Text "Adult Model" -Items (@("Original") + $Models) -Default "Original" -Info "Replace the adult model used for Link"



    # MODELS PREVIEW #

    $Redux.Graphics.ModelPreviews = CreateReduxGroup -Tag "Graphics" -Text "Model Previews"
    $Last.Group.Height = (DPISize 252)

    CreateImageBox -x 20  -y 20 -w 154 -h 220 -Name "ModelsPreviewChild"
    CreateImageBox -x 210 -y 20 -w 154 -h 220 -Name "ModelsPreviewAdult"
    $global:PreviewToolTip = CreateToolTip
    ChangeModelsSelection
    


    # INTERFACE #

    CreateReduxGroup    -Tag  "UI" -Text "Interface"
    $Last.Group.Width = $Redux.Groups[$Redux.Groups.Length-3].Width; $Last.Group.Top = $Redux.Groups[$Redux.Groups.Length-3].Bottom + 5; $Last.Width = 4;
    CreateReduxCheckBox -Name "HUD"              -Text "MM HUD Icons"        -Info "Replace the HUD icons with that from Majora's Mask"          -Beginner                    -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "Rupees"           -Text "MM Rupee Icon"       -Info "Replace the rupees icon with that from Majora's Mask"        -Lite -Advanced              -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "DungeonKeys"      -Text "MM Key Icon"         -Info "Replace the key icon with that from Majora's Mask"           -Lite -Advanced              -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "DungeonIcons"     -Text "MM Dungeon Icons"    -Info "Replace the dungeon map icons with those from Majora's Mask" -Lite -Advanced              -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "ButtonPositions"  -Text "MM Button Positions" -Info "Positions the A and B buttons like in Majora's Mask"                                      -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "CenterNaviPrompt" -Text "Center Navi Prompt"  -Info 'Centers the "Navi" prompt shown in the C-Up button'                                       -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "GCScheme"         -Text "GC Scheme"           -Info "Replace and change the textures, dialogue and text colors to match the GameCube's scheme" -Credits "Admentus, GhostlyDark, ShadowOne333 & Ported from Redux" -Warning "Dialogue changes are only available for the English language`n[!] Changing the textbox cursor color requires Redux to be enabled"
    CreateReduxComboBox -Name "BlackBars"        -Text "Black Bars"  -Items @("Enabled", "Disabled for Z-Targeting", "Disabled for Cutscenes", "Always Disabled") -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes" -Credits "Admentus"
    CreateReduxComboBox -Name "ButtonSize"       -Text "HUD Buttons"                                           -FilePath ($Paths.shared + "\Buttons")    -Ext $null -Default "Large"           -Info "Set the size for the HUD buttons"  -Credits "GhostlyDark (ported)"
    $path = $Paths.shared + "\Buttons" + "\" + $Redux.UI.ButtonSize.Text.replace(" (default)", "")
    CreateReduxComboBox -Name "ButtonStyle"      -Text "HUD Buttons" -Items @("Gold Quest", "Ocarina of Time") -FilePath $path                           -Ext "bin" -Default "Gold Quest"      -Info "Set the style for the HUD buttons"                 -Credits "GhostlyDark, Pizza (HD), Djipi, Community, Nerrel, Federelli, AndiiSyn"
    CreateReduxComboBox -Name "Hearts"           -Text "Heart Icons" -Items @("Gold Quest", "Ocarina of Time") -FilePath ($Paths.shared + "\HUD\Hearts") -Ext "bin" -Default "Gold Quest"      -Info "Set the style for the heart icons"                 -Credits "Ported by GhostlyDark & AndiiSyn"            -Lite -Advanced
    CreateReduxComboBox -Name "Magic"            -Text "Magic Bar"   -Items @("Ocarina of Time")               -FilePath ($Paths.shared + "\HUD\Magic")  -Ext "bin" -Default "Ocarina of Time" -Info "Set the style for the magic meter"                 -Credits "GhostlyDark, Pizza, Nerrel (HD), Zeth Alkar" -Lite -Advanced
    CreateReduxCheckBox -Name "Hide"             -Text "Hide Interface"                                                                                                                        -Info "Hide the whole interface"                          -Credits "Admentus"                                    -Beginner
    CreateReduxCheckBox -Name "HideCredits"      -Text "Hide Credits"                                                                                                                          -Info "Hide the credits text during the credits sequence" -Credits "Admentus"                                    -Beginner


    
    # HIDE HUD #

    CreateReduxGroup    -Tag  "Hide"         -Text "Hide HUD"                -Columns 4 -Lite -Advanced
    CreateReduxCheckBox -Name "AButton"      -Text "Hide A Button"           -Info "Hide the A Button"                                            -Credits "Admentus"
    CreateReduxCheckBox -Name "BButton"      -Text "Hide B Button"           -Info "Hide the B Button"                                            -Credits "Admentus"
    CreateReduxCheckBox -Name "StartButton"  -Text "Hide Start Button"       -Info "Hide the Start Button"                                        -Credits "Admentus"
    CreateReduxCheckBox -Name "CUpButton"    -Text "Hide C-Up Button"        -Info "Hide the C-Up Button"                                         -Credits "Admentus"
    CreateReduxCheckBox -Name "CLeftButton"  -Text "Hide C-Left Button"      -Info "Hide the C-Left Button"                                       -Credits "Admentus"
    CreateReduxCheckBox -Name "CDownButton"  -Text "Hide C-Down Button"      -Info "Hide the C-Down Button"                                       -Credits "Admentus"
    CreateReduxCheckBox -Name "CRightButton" -Text "Hide C-Right Button"     -Info "Hide the C-Right Button"                                      -Credits "Admentus"
    CreateReduxCheckBox -Name "Hearts"       -Text "Hide Hearts"             -Info "Hide the Hearts display"                                      -Credits "Admentus"
    CreateReduxCheckBox -Name "Magic"        -Text "Hide Magic"              -Info "Hide the Magic display"                                       -Credits "Admentus"
    CreateReduxCheckBox -Name "Rupees"       -Text "Hide Rupees"             -Info "Hide the the Rupees display"                                  -Credits "Admentus"
    CreateReduxCheckBox -Name "DungeonKeys"  -Text "Hide Keys"               -Info "Hide the Keys display shown in several dungeons and areas"    -Credits "Admentus"
    CreateReduxCheckBox -Name "Carrots"      -Text "Hide Epona Carrots"      -Info "Hide the Epona Carrots display"                               -Credits "Admentus"
    CreateReduxCheckBox -Name "AreaTitle"    -Text "Hide Area Title Card"    -Info "Hide the area title that displays when entering a new area"   -Credits "Admentus" 
    CreateReduxCheckBox -Name "DungeonTitle" -Text "Hide Dungeon Title Card" -Info "Hide the dungeon title that displays when entering a dungeon" -Credits "Admentus"
    CreateReduxCheckBox -Name "Icons"        -Text "Hide Icons"              -Info "Hide the Clock and Score Counter icons display"               -Credits "Admentus"
    CreateReduxCheckBox -Name "Credits"      -Text "Hide Credits"            -Info "Hide the credits text during the credits sequence"            -Credits "Admentus" -Advanced



    # STYLES #

    CreateReduxGroup    -Tag  "Styles"        -Text "Styles"         -Columns 4 -Beginner -Streamlined
    CreateReduxComboBox -Name "RegularChests" -Text "Regular Chests" -Info "Use a different style for regular treasure chests"                                           -FilePath ($Paths.shared + "\Chests")               -Ext "front" -Items @("Gold Quest") -Credits "AndiiSyn & Rando"
    CreateReduxComboBox -Name "BossChests"    -Text "Boss Chests"    -Info "Use a different style for Boss Key treasure chests"                                          -FilePath ($Paths.shared + "\Chests")               -Ext "front" -Items @("Boss OoT")   -Credits "AndiiSyn & Rando"
    CreateReduxComboBox -Name "Crates"        -Text "Small Crates"   -Info "Use a different style for small liftable crates"                                             -FilePath ($Paths.shared + "\Crates")               -Ext "bin"   -Items @("Regular")    -Credits "Rando"
    CreateReduxComboBox -Name "Pots"          -Text "Pots"           -Info "Use a different style for throwable pots"                                                    -FilePath ($Paths.shared + "\Pots")                 -Ext "bin"   -Items @("Regular")    -Credits "Rando"
    CreateReduxComboBox -Name "HairColor"     -Text "Hair Color"     -Info "Use a different hair color style for Link`nOnly for Ocarina of Time or Majora's Mask models" -FilePath ($Paths.shared + "\Hair\Ocarina of Time") -Ext "bin"   -Items @("Blonde")     -Credits "Third M & AndiiSyn"



    # HUD PREVIEWS #

    CreateReduxGroup -Tag "UI" -Text "HUD Previews"
    $Last.Group.Top    = $Redux.Graphics.ModelPreviews.Bottom + (DPISize 5)
    $Last.Group.Height = (DPISize 140)

    CreateImageBox -x 40  -y 30 -w 90  -h 90 -Name "ButtonPreview";      $Redux.UI.ButtonSize.Add_SelectedIndexChanged( { ShowHUDPreview -IsOoT } );   $Redux.UI.ButtonStyle.Add_SelectedIndexChanged( { ShowHUDPreview -IsOoT } )
    CreateImageBox -x 160 -y 35 -w 40  -h 40 -Name "HeartsPreview";      if (IsInterface -Lite -Advanced -Streamlined) { $Redux.UI.Hearts.Add_SelectedIndexChanged(   { ShowHUDPreview -IsOoT } ) }
    CreateImageBox -x 220 -y 35 -w 40  -h 40 -Name "RupeesPreview";      if (IsInterface -Lite -Advanced -Streamlined) { $Redux.UI.Rupees.Add_CheckStateChanged(      { ShowHUDPreview -IsOoT } ) }
    CreateImageBox -x 280 -y 35 -w 40  -h 40 -Name "DungeonKeysPreview"; if (IsInterface -Lite -Advanced -Streamlined) { $Redux.UI.DungeonKeys.Add_CheckStateChanged( { ShowHUDPreview -IsOoT } ) }
    CreateImageBox -x 140 -y 85 -w 200 -h 40 -Name "MagicPreview";       if (IsInterface -Lite -Advanced -Streamlined) { $Redux.UI.Magic.Add_SelectedIndexChanged(    { ShowHUDPreview -IsOoT } ) }
    
    ShowHUDPreview -IsOoT
    if (IsInterface -Beginner) { $Redux.UI.HUD.Add_CheckStateChanged( { ShowHUDPreview -IsOoT } ) }



    # STYLES #

    CreateReduxGroup    -Tag  "Styles"        -Text "Styles" -Lite -Advanced
    CreateReduxComboBox -Name "RegularChests" -Text "Regular Chests" -Info "Use a different style for regular treasure chests"                                           -FilePath ($Paths.shared + "\Chests")               -Ext "front" -Items @("Gold Quest") -Credits "AndiiSyn & Rando"
    CreateReduxComboBox -Name "BossChests"    -Text "Boss Chests"    -Info "Use a different style for Boss Key treasure chests"                                          -FilePath ($Paths.shared + "\Chests")               -Ext "front" -Items @("Boss OoT")   -Credits "AndiiSyn & Rando"
    CreateReduxComboBox -Name "Crates"        -Text "Small Crates"   -Info "Use a different style for small liftable crates"                                             -FilePath ($Paths.shared + "\Crates")               -Ext "bin"   -Items @("Regular")    -Credits "Rando"
    CreateReduxComboBox -Name "Pots"          -Text "Pots"           -Info "Use a different style for throwable pots"                                                    -FilePath ($Paths.shared + "\Pots")                 -Ext "bin"   -Items @("Regular")    -Credits "Rando"
    CreateReduxComboBox -Name "HairColor"     -Text "Hair Color"     -Info "Use a different hair color style for Link`nOnly for Ocarina of Time or Majora's Mask models" -FilePath ($Paths.shared + "\Hair\Ocarina of Time") -Ext "bin"   -Items @("Blonde")     -Credits "Third M & AndiiSyn"

}



#==============================================================================================================================================================================================
function CreateTabAudio() {
    
    # SOUNDS / VOICES #

    CreateReduxGroup    -Tag  "Sounds" -Text "Sounds / Voices"
    CreateReduxComboBox -Name "ChildVoices" -Text "Child Voice" -Default "Original" -Items @("Original") -FilePath ($GameFiles.binaries + "\Voices Child")   -Info "Replace the voice used for the Child Link Model"        -Credits "`nMajora's Mask: Korey Cryderman (ported) & GhostlyDark (corrected)`nMelee Zelda: Thiago Alcântara 6 & theluigidude2007 (edits)`nAmara: Amara (ripping) & theluigidude2007 (edits)"
    CreateReduxComboBox -Name "AdultVoices" -Text "Adult Voice" -Default "Original" -Items @("Original") -FilePath ($GameFiles.binaries + "\Voices Adult")   -Info "Replace the voice used for the Adult Link Model"        -Credits "`nMajora's Mask: Korey Cryderman (ported) & GhostlyDark (corrected)`nMelee Zelda: Thiago Alcântara 6 & theluigidude2007 (edits)`nAmara: Amara (ripping) & theluigidude2007`nPeach: theluigidude2007"
    CreateReduxComboBox -Name "Instrument"  -Text "Instrument"  -Beginner -Advanced -Items @("Ocarina", "Female Voice", "Whistle", "Harp", "Organ", "Flute") -Info "Replace the sound used for playing the Ocarina of Time" -Credits "Ported from Rando"



    # SFX SOUND EFFECTS #

    $SFX = @("Default", "Disabled", "Soft Beep", "Bark", "Bomb Bounce", "Bongo Bongo Low", "Bow Twang", "Business Scrub", "Carrot Refill", "Cluck", "Great Fairy", "Drawbridge Set", "Guay", "Horse Trot", "HP Recover", "Iron Boots", "Moo", "Mweep!", 'Navi "Hey!"', "Navi Random", "Notification", "Pot Shattering", "Ribbit", "Rupee (Silver)", "Switch", "Sword Bonk", "Tambourine", "Timer", "Zelda Gasp (Adult)")

    CreateReduxGroup    -Tag "SFX" -Text "SFX Sound Effects" -Beginner -Streamlined
    CreateReduxComboBox -Name "LowHP"      -Text "Low HP"      -Items $SFX -Info "Set the sound effect for the low HP beeping"                      -Credits "Ported from Rando"

    CreateReduxGroup    -Tag "SFX" -Text "SFX Sound Effects" -Lite -Advanced
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

    MusicOptions -Default "Great Fairy's Fountain"
    
}



#==============================================================================================================================================================================================
function CreateTabDifficulty() {
    
    # HERO MODE #

    CreateReduxGroup    -Tag  "Hero" -Text "Hero Mode"
    CreateReduxComboBox -Name "Damage"     -Text "Damage"       -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage", "OHKO Mode")        -Info "Set the amount of damage you receive`nOHKO Mode = You die in one hit"                                   -Credits "Admentus"
    CreateReduxComboBox -Name "Recovery"   -Text "Recovery"     -Items @("1x Recovery", "1/2x Recovery", "1/4x Recovery", "0x Recovery")         -Info "Set the amount health you recovery from Recovery Hearts`nRecovery Heart drops are removed if set to 0x" -Credits "Admentus & Rando (No Heart Drops)"
    CreateReduxComboBox -Name "MagicUsage" -Text "Magic Usage"  -Items @("1x Magic Usage", "2x Magic Usage", "4x Magic Usage", "8x Magic Usage") -Info "Set the amount of times magic is consumed at"                                                           -Credits "Admentus"
    $items1 = @("1 Monster HP","0.5x Monster HP", "1x Monster HP", "1.5x Monster HP", "2x Monster HP", "2.5x Monster HP", "3x Monster HP", "3.5x Monster HP", "4x Monster HP", "Max Monster HP")
    $items2 = @("1 Mini-Boss HP", "0.5x Mini-Boss HP", "1x Mini-Boss HP", "1.5x Mini-Boss HP", "2x Mini-Boss HP", "2.5x Mini-Boss HP", "3x Mini-Boss HP", "3.5x Mini-Boss HP", "4x Mini-Boss HP", "Max Mini-Boss HP")
    $items3 = @("1 Boss HP", "0.5x Boss HP", "1x Boss HP", "1.5x Boss HP", "2x Boss HP", "2.5x Boss HP", "3x Boss HP", "3.5x Boss HP", "4x Boss HP", "Max Boss HP")
    CreateReduxComboBox -Name "MonsterHP"  -Text "Monster HP"   -Items $items1 -Default 3 -Info "Set the amount of health for monsters"                       -Credits "Admentus" -Warning "Half of the enemies are missing"
    CreateReduxComboBox -Name "MiniBossHP" -Text "Mini-Boss HP" -Items $items2 -Default 3 -Info "Set the amount of health for elite monsters and mini-bosses" -Credits "Admentus" -Warning "Big Octo and Dark Link are missing"
    CreateReduxComboBox -Name "BossHP"     -Text "Boss HP"      -Items $items3 -Default 3 -Info "Set the amount of health for bosses"                         -Credits "Admentus & Marcelo20XX"
    CreateReduxCheckBox -Name "NoRecoveryHearts"  -Text "No Recovery Heart Drops" -Info "Disable Recovery Hearts from spawning from item drops"                                           -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "NoItemDrops"       -Text "No Item Drops"           -Info "Disable all items from spawning"                                                                 -Credits "Admentus & BilonFullHDemon"
    CreateReduxCheckBox -Name "HarderChildBosses" -Text "Harder Child Bosses"     -Info "Replace objects in the Child Dungeon Boss arenas with additional monsters" -Beginner -Advanced -Credits "BilonFullHDemon"

    $Redux.Hero.Damage.Add_SelectedIndexChanged({ EnableElem -Elem $Redux.Hero.Recovery -Active ($this.text -ne "OHKO Mode") })
    EnableElem -Elem ($Redux.Hero.Recovery) -Active ($Redux.Hero.Damage.text -ne "OHKO Mode")

}



#==============================================================================================================================================================================================
function CreateTabColors() {

    # EQUIPMENT COLORS #

    CreateReduxGroup -Tag "Colors" -Text "Equipment Colors"
    $Redux.Colors.Equipment = @()
    $Items = @("Gold Quest Gold", "Gold Quest Purple", "Gold Quest White", "Kokiri Green", "Goron Red", "Zora Blue"); $PostItems = @("Randomized", "Custom"); $Files = ($GameFiles.Textures + "\Tunic"); $Randomize = '"Randomized" fully randomizes the colors each time the patcher is opened'
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
function CreateTabEquipment1() {
    
    # EQUIPMENT #

    CreateReduxGroup    -Tag  "Equipment" -Text "Equipment Adjustments"
    CreateReduxCheckBox -Name "UnsheathSword"       -Text "Unsheath Sword"        -Info "The sword is unsheathed first before immediately swinging it"                   -Credits "Admentus"
    CreateReduxCheckBox -Name "FireproofDekuShield" -Text "Fireproof Deku Shield" -Info "The Deku Shield turns into an fireproof shield, which will not burn up anymore" -Credits "Admentus (ported) & Three Pendants (ROM patch)"
    CreateReduxCheckBox -Name "HerosBowIcons"       -Text "Hero's Bow Icons"      -Info "Use the Hero's Bow icons for the Fairy Bow"                                     -Credits "GhostlyDark (ported)"
    CreateReduxCheckBox -Name "HookshotIcon"        -Text "Termina Hookshot Icon" -Info "Use the Termina Hookshot icon for the regular Hookshot"                         -Credits "GhostlyDark (ported)"
    
    CreateReduxGroup    -Tag  "Equipment" -Text "Swords and Shields" -Beginner -Lite -Advanced
    CreateReduxComboBox -Name "KokiriSword"   -Text "Kokiri Sword"  -Items @("Kokiri Sword")                       -FilePath ($GameFiles.Textures + "\Equipment\Kokiri Sword")  -Ext @("icon", "bin")   -Info "Select an alternative for the appearence of the Kokiri Sword"  -Credits "Admentus & GhostlyDark (injects) & CYB3RTR0N (beta icon)"
    CreateReduxComboBox -Name "MasterSword"   -Text "Master Sword"  -Items @("Master Sword")                       -FilePath ($GameFiles.Textures + "\Equipment\Master Sword")  -Ext @("icon", "bin")   -Info "Select an alternative for the appearence of the Master Sword"  -Credits "Admentus & GhostlyDark (injects) & CYB3RTR0N (beta icon)"
    CreateReduxComboBox -Name "DekuShield"    -Text "Deku Shield"   -Items @("Gold Quest Shield", "Deku Shield")   -FilePath ($GameFiles.Textures + "\Equipment\Deku Shield")   -Ext @("icon", "front") -Info "Select an alternative for the appearence of the Deku Shield"   -Credits "Admentus & GhostlyDark (injects), ZombieBrainySnack (textures) & AndiiSyn (textures)"
    CreateReduxComboBox -Name "HylianShield"  -Text "Hylian Shield" -Items @("Gold Quest Shield", "Hylian Shield") -FilePath ($GameFiles.Textures + "\Equipment\Hylian Shield") -Ext @("icon", "bin")   -Info "Select an alternative for the appearence of the Hylian Shield" -Credits "Admentus & GhostlyDark (injects), CYB3RTR0N (icons), sanguinetti (Beta / Red Shield textures) & AndiiSyn (textures)"
    CreateReduxComboBox -Name "MirrorShield"  -Text "Mirror Shield" -Items @("Gold Quest Shield", "Mirror Shield") -FilePath ($GameFiles.Textures + "\Equipment\Mirror Shield") -Ext @("icon", "bin")   -Info "Select an alternative for the appearence of the Mirror Shield" -Credits "Admentus & GhostlyDark (injects) & AndiiSyn (textures)"



    # HITBOX #

    CreateReduxGroup  -Tag  "Hitbox" -Text "Sliders" -Height 4.2 -Beginner -Lite -Advanced
    CreateReduxSlider -Name "KokiriSword"       -Column 1 -Row 1 -Default 3000  -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Kokiri Sword"    -Info "Set the length of the hitbox of the Kokiri Sword"                   -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "MasterSword"       -Column 3 -Row 1 -Default 4000  -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Master Sword"    -Info "Set the length of the hitbox of the Master Sword"                   -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "GiantsKnife"       -Column 5 -Row 1 -Default 5500  -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Giant's Knife"   -Info "Set the length of the hitbox of the Giant's Knife / Biggoron Sword" -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "BrokenGiantsKnife" -Column 1 -Row 2 -Default 1500  -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Broken Knife"    -Info "Set the length of the hitbox of the Broken Giant's Knife"           -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "MegatonHammer"     -Column 3 -Row 2 -Default 2500  -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Megaton Hammer"  -Info "Set the length of the hitbox of the Megaton Hammer"                 -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "ShieldRecoil"      -Column 5 -Row 2 -Default 4552  -Min 0   -Max 8248 -Freq 512 -Small 256 -Large 512 -Text "Shield Recoil"   -Info "Set the pushback distance when getting hit while shielding"         -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxSlider -Name "Hookshot"          -Column 1 -Row 3 -Default 13    -Min 0   -Max 255  -Freq 16  -Small 8   -Large 16  -Text "Hookshot Length" -Info "Set the length of the Hookshot"                                     -Credits "AndiiSyn"
    CreateReduxSlider -Name "Longshot"          -Column 3 -Row 3 -Default 104   -Min 0   -Max 255  -Freq 16  -Small 8   -Large 16  -Text "Longshot Length" -Info "Set the length of the Longshot"                                     -Credits "AndiiSyn"



    # EQUIPMENT PREVIEWS #

    if (IsInterface -Streamlined) { return }

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

}



#==============================================================================================================================================================================================
function CreateTabEquipment2() {
    
    # STARTING UPGRADES #

    CreateReduxGroup    -Tag  "Save"          -Text "Starting Upgrades" -Advanced
    CreateReduxComboBox -Name "DekuSticks"    -Text "Deku Sticks" -Items ("Standard", "Big", "Biggest")
    CreateReduxComboBox -Name "DekuNuts"      -Text "Deku Nuts"   -Items ("Standard", "Big", "Biggest")
    CreateReduxComboBox -Name "BulletBag"     -Text "Bullet Bag"  -Items ("Standard", "Big", "Biggest")
    CreateReduxComboBox -Name "Quiver"        -Text "Quiver"      -Items ("Standard", "Big", "Biggest")
    CreateReduxComboBox -Name "BombBag"       -Text "Bomb Bag"    -Items ("Standard", "Big", "Biggest")
    CreateReduxComboBox -Name "Strength"      -Text "Strength"    -Items ("None", "Goron's Bracelet", "Silver Gauntlets", "Golden Gauntlets")
    CreateReduxComboBox -Name "Scale"         -Text "Scale"       -Items ("None", "Silver Scale", "Golden Scale")
    CreateReduxComboBox -Name "Wallet"        -Text "Wallet"      -Items ("Wallet", "Adult's Wallet", "Giant's Wallet", "Unused Wallet") -Warning 'The "Unused Wallet" is unused, and has issues'

    CreateReduxTextBox  -Name "Hearts"        -Text "Hearts" -Value 3 -Min 1 -Max 20 -Info "Start a new save file with the chosen amount of hearts"
    CreateReduxCheckBox -Name "DoubleDefense" -Text "Double Defense"                 -Info "Start a new save file with the double defense upgrade"
    CreateReduxCheckBox -Name "Magic"         -Text "Magic"                          -Info "Start a new save file with the magic meter"
    CreateReduxCheckBox -Name "DoubleMagic"   -Text "Double Magic"                   -Info "Start a new save file with the double magic upgrade"



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

    CreateReduxGroup    -Tag  "Unlock" -Text "Unlock Child Restrictions"
    CreateReduxCheckBox -Name "Tunics"        -Text "Unlock Tunics"        -Info "Child Link is able to use the Goron Tunic and Zora Tunic`nSince you might want to walk around in style as well when you are young`nThe dialogue script will be adjusted to reflect this (only for English)" -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "MasterSword"   -Text "Unlock Master Sword"  -Info "Child Link is able to use the Master Sword`nThe Master Sword does twice as much damage as the Kokiri Sword"       -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "GiantsKnife"   -Text "Unlock Giant's Knife" -Info "Child Link is able to use the Giant's Knife / Biggoron Sword`nThe Giant's Knife / Biggoron Sword does four times as much damage as the Kokiri Sword" -Credits "GhostlyDark" -Warning "The Giant's Knife / Biggoron Sword appears as if Link if thrusting the sword through the ground"
    CreateReduxCheckBox -Name "MirrorShield"  -Text "Unlock Mirror Shield" -Info "Child Link is able to use the Mirror Shield"                                                                      -Credits "GhostlyDark" -Warning "The Mirror Shield appears as invisible but can still reflect magic or sunlight"
    CreateReduxCheckBox -Name "Boots"         -Text "Unlock Boots"         -Info "Child Link is able to use the Iron Boots and Hover Boots"                                                         -Credits "GhostlyDark" -Warning "The Iron and Hover Boots appears as the Kokiri Boots"
    CreateReduxCheckBox -Name "Gauntlets"     -Text "Unlock Gauntlets"     -Info "Child Link is able to use the Silver and Golden Gauntlets"                                                        -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxComboBox -Name "MegatonHammer" -Text "Unlock Hammer"        -Info "Child Link is able to use the Megaton Hammer" -Items @("Disabled", "Unlock Only", "Show Only", "Unlock and Show") -Credits "GhostlyDark" -Warning "The Megaton Hammer appears as invisible on custom models"
    


    # UNLOCK ADULT RESTRICTIONS #

    CreateReduxGroup    -Tag  "Unlock" -Text "Unlock Adult Restrictions"
    CreateReduxCheckBox -Name "KokiriSword"    -Text "Unlock Kokiri Sword" -Info "Adult Link is able to use the Kokiri Sword`nThe Kokiri Sword does half as much damage as the Master Sword" -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "DekuShield"     -Text "Unlock Deku Shield"  -Info "Adult Link is able to use the Deku Shield"     -Credits "GhostlyDark" -Warning "The Deku Shield appears as invisible but can still be burned up by fire"
    CreateReduxCheckBox -Name "FairySlingshot" -Text "Unlock Slingshot"    -Info "Adult Link is able to use the Fairy Slingshot" -Credits "GhostlyDark" -Warning "The Fairy Slingshot appears as the Fairy Bow"
    CreateReduxCheckBox -Name "Boomerang"      -Text "Unlock Boomerang"    -Info "Adult Link is able to use the Boomerang"       -Credits "GhostlyDark" -Warning "The Boomerang appears as invisible"
    CreateReduxCheckBox -Name "CrawlHole"      -Text "Unlock Crawl Hole"   -Info "Adult Link can now crawl through holes"        -Credits "Admentus"    -Advanced -Native
    CreateReduxComboBox -Name "DekuSticks"     -Text "Unlock Deku Sticks"  -Info "Adult Link is able to use the Deku Sticks"     -Credits "GhostlyDark" -Advanced -Warning "The Deku Sticks appears as invisible for both Child and Adult Link with this option" -Items @("Disabled", "Crash Fix Only", "Crash Fix and Unlock")

}



#==============================================================================================================================================================================================
function CreateTabEquipment3() {
    
    # STARTING EQUIPMENT #

    CreateReduxGroup    -Tag  "Save"          -Text "Starting Equipment" -Advanced
    CreateReduxCheckBox -Name "KokiriSword"   -Text "Kokiri Sword"   -Info "Start a new save file with the Kokiri Sword"
    CreateReduxCheckBox -Name "MasterSword"   -Text "Master Sword"   -Info "Start a new save file with the Master Sword"
    CreateReduxCheckBox -Name "GiantsKnife"   -Text "Giant's Knife"  -Info "Start a new save file with the Giant's Knife"
    CreateReduxCheckBox -Name "BiggoronSword" -Text "Biggoron Sword" -Info "Start a new save file with the Biggoron Sword instead of the Giant's Knife" -Link $Redux.Save.GiantsKnife
    CreateReduxCheckBox -Name "DekuShield"    -Text "Deku Shield"    -Info "Start a new save file with the Deku Shield"
    CreateReduxCheckBox -Name "HylianShield"  -Text "Hylian Shield"  -Info "Start a new save file with the Hylian Shield"
    CreateReduxCheckBox -Name "MirrorShield"  -Text "Mirror Shield"  -Info "Start a new save file with the Mirror Shield"
    CreateReduxCheckBox -Name "GoronTunic"    -Text "Goron Tunic"    -Info "Start a new save file with the Master Sword"
    CreateReduxCheckBox -Name "ZoraTunic"     -Text "Zora Tunic"     -Info "Start a new save file with the Giant's Knife"
    CreateReduxCheckBox -Name "IronBoots"     -Text "Iron Boots"     -Info "Start a new save file with the Hylian Shield"
    CreateReduxCheckBox -Name "HoverBoots"    -Text "Hover Boots"    -Info "Start a new save file with the Mirror Shield"



    # STARTING ITEMS #

    CreateReduxGroup    -Tag  "Save"              -Text "Starting Items" -Advanced
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
    CreateReduxCheckBox -Name "NayrusLove"        -Text "Nayru's Love"        -Info "Start a new save file with Nayure's Love"

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

    CreateReduxGroup    -Tag  "Save"             -Text "Starting Songs" -Advanced
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
    CreateReduxTextBox -Name "Quiver1"     -Text "Quiver (1)"      -Value 30  -Info "Set the capacity for the Quiver (Base)"           -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver2"     -Text "Quiver (2)"      -Value 40  -Info "Set the capacity for the Quiver (Upgrade 1)"      -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver3"     -Text "Quiver (3)"      -Value 50  -Info "Set the capacity for the Quiver (Upgrade 2)"      -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag1"    -Text "Bomb Bag (1)"    -Value 20  -Info "Set the capacity for the Bomb Bag (Base)"         -Credits "GhostlyDark" -Min 10 -Warning "The minimum value has to be 20 or higher in order to be changed`n[!] A few values are excluded to prevent issues and will automatically be set to the next possible value"
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
    CreateReduxTextBox -Name "RupeeG" -Length 4 -Text "Rupee (Green)"       -Value 1   -Info "Set the recovery quantity for picking up Green Rupees"             -Credits "Admentus" -Row 3 -Column 1
    CreateReduxTextBox -Name "RupeeB" -Length 4 -Text "Rupee (Blue)"        -Value 5   -Info "Set the recovery quantity for picking up Blue Rupees"              -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeR" -Length 4 -Text "Rupee (Red)"         -Value 20  -Info "Set the recovery quantity for picking up Red Rupees"               -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeP" -Length 4 -Text "Rupee (Purple)"      -Value 50  -Info "Set the recovery quantity for picking up Purple Rupees"            -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeO" -Length 4 -Text "Rupee (Gold)"        -Value 200 -Info "Set the recovery quantity for picking up Gold Rupees"              -Credits "Admentus"

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
    CreateReduxCheckBox -Name "SideBackflip"     -Text "Side Backflip"          -Info "Replace the backflip jump with side hop jumps"                                                       -Credits "Username0713"

}