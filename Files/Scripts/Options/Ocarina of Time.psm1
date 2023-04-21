function PrePatchOptions() {
    
    # GRAPHICS #

    if (IsChecked $Redux.Graphics.Widescreen) {
        ApplyPatch -Patch "Decompressed\Optional\widescreen_minimum.ppf"
        if     ($GamePatch.settings -eq "Dawn & Dusk")   { ApplyPatch -Patch "Decompressed\Optional\widescreen_dawn_and_dusk.ppf" }
        elseif ($GamePatch.backgrounds -ne 0)            { ApplyPatch -Patch "Decompressed\Optional\widescreen_hide_geometry.ppf" }
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

    if (IsDefault -Elem $Redux.Graphics.ChildModels -Not)   { PatchModel -Category "Child" -Name $Redux.Graphics.ChildModels.Text }
    if (IsDefault -Elem $Redux.Graphics.AdultModels -Not)   { PatchModel -Category "Adult" -Name $Redux.Graphics.AdultModels.Text }

    if ( ( (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Original") -or (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Majora's Mask Eyes") ) -and ( (IsIndex -Elem $Redux.Unlock.MegatonHammer -Index 3) -or (IsIndex -Elem $Redux.Unlock.MegatonHammer -Index 4) ) ) {
        ApplyPatch -Patch "Decompressed\Optional\vanilla_child_megaton_hammer.ppf"
    }

    if (IsChecked $Redux.Animation.Feminine)            { ApplyPatch -Patch "Decompressed\Optional\feminine_animations.ppf" }



    # DIFFICULTY #

    if (IsChecked $Redux.Hero.HarderChildBosses)        { ApplyPatch -Patch "Decompressed\Optional\harder_child_bosses.ppf" }
    if (IsChecked $Redux.Hero.PotsChallenge)            { ApplyPatch -Patch "Decompressed\Optional\pots_challenge.ppf"      }
    


    # MM PAUSE SCREEN #

    if (IsChecked $Redux.Text.PauseScreen)              { ApplyPatch -Patch "Decompressed\Optional\mm_pause_screen.ppf" }



    # SCENES #

    if (IsChecked $Redux.MQ.Custom) {
        if (TestFile $GameFiles.scenesPatch) { ApplyPatch -Patch $GameFiles.scenesPatch -FullPath }
    }
    
}



#==============================================================================================================================================================================================
function ByteDMAOptions() {
    
    if (IsChecked $Redux.Hero.PotsChallenge) {
        ChangeBytes -Offset "D290" -Values "000000003C0F8001A1E60FA0080E326BAFBF00143C0F800191EF0FA0240E003D51CF0005240701110C0094FC00000000080E289D000000003C0F801291EEA66425CE0001A1EEA664240EFFFFAFAE0028"
        ChangeBytes -Offset "D2E0" -Values "0C0094FC00000000080E289D000000000C0204BC000000000802053C0000000000000000818D008C3C18800193180FA02419003D5319000125AD0030000000000000000000000000080E32C800000000"
    }

}



#==============================================================================================================================================================================================
function ByteOptions() {
    
    if     ($GamePatch.settings -eq "Master of Time")   { $ChildModel = @{}; $ChildModel.deku_shield   = 1; $ChildModel.hylian_shield = 1 }
    elseif ($GamePatch.settings -eq "Dawn & Dusk")      { $AdultModel = @{}; $AdultModel.hylian_shield = 1; $AdultModel.mirror_shield = 1 }


    # QUALITY OF LIFE #

    if (IsIndex $Redux.Gameplay.FasterBlockPushing -Index 1 -Not) {
        ChangeBytes -Offset "DD2B87" -Values "80";       ChangeBytes -Offset "DD2D27" -Values "03" # Block Speed, Delay
        ChangeBytes -Offset "DD9683" -Values "80";       ChangeBytes -Offset "DD981F" -Values "03" # Milk Crate Speed, Delay
        ChangeBytes -Offset "C77CA8" -Values "40800000"; ChangeBytes -Offset "C770C3" -Values "01" # Fire Block Speed, Delay
        ChangeBytes -Offset "CC5DBF" -Values "01";       ChangeBytes -Offset "DBCF73" -Values "01" # Forest Basement Puzzle Delay / spirit Cobra Mirror Delay
        ChangeBytes -Offset "DBA233" -Values "19";       ChangeBytes -Offset "DBA3A7" -Values "00" # Truth Spinner Speed, Delay
        if (IsIndex $Redux.Gameplay.FasterBlockPushing -Index 3) { ChangeBytes -Offset "CE1BD0" -Values "40800000"; ChangeBytes -Offset "CE0F0F" -Values "03" } # Amy Puzzle Speed, Delay
    }

    if (IsChecked $Redux.Gameplay.NoKillFlash)              { ChangeBytes -Offset "B11C33" -Values "00"                                                                                             }
    if (IsChecked $Redux.Gameplay.RemoveNaviTimer)          { ChangeBytes -Offset "C26C14" -Values "10000013"; ChangeBytes -Offset "C26C1C" -Values "10000013"                                      }
    if (IsChecked $Redux.Gameplay.ResumeLastArea)           { ChangeBytes -Offset "B06348" -Values "0000";     ChangeBytes -Offset "B06350" -Values "0000"                                          }
    if (IsChecked $Redux.Gameplay.InstantClaimCheck)        { ChangeBytes -Offset "ED4470" -Values "00000000"; ChangeBytes -Offset "ED4498" -Values "00000000"                                      }
    if (IsChecked $Redux.Gameplay.ReturnChild)              { ChangeBytes -Offset "CB6844" -Values "35";       ChangeBytes -Offset "253C0E2" -Values "03"                                           }
    if (IsChecked $Redux.Gameplay.AllowWarpSongs)           { ChangeBytes -Offset "B6D3D2" -Values "00";       ChangeBytes -Offset "B6D42A" -Values "00"                                            }
    if (IsChecked $Redux.Gameplay.AllowFaroreWind)          { ChangeBytes -Offset "B6D3D3" -Values "00";       ChangeBytes -Offset "B6D42B" -Values "00"                                            }
    if (IsChecked $Redux.Gameplay.AllowOcarina)             { ChangeBytes -Offset "B6D346" -Values "11";       ChangeBytes -Offset "B6D33A" -Values "51"; ChangeBytes -Offset "B6D30A" -Values "51" }
    if (IsChecked $Redux.Gameplay.FasterGoronTunic)         { ChangeBytes -Offset "ED3173" -Values "36";       ChangeBytes -Offset "ED31BB" -Values "36"                                            }
    if (IsChecked $Redux.Gameplay.RutoNeverDisappears)      { ChangeBytes -Offset "D01EA3" -Values "00"                                                                                             }
    if (IsChecked $Redux.Gameplay.Medallions)               { ChangeBytes -Offset "E2B454" -Values "80EA00A72401003F314A003F00000000"                                                               }
    if (IsChecked $Redux.Gameplay.OpenBombchuShop)          { ChangeBytes -Offset "C6CEDC" -Values "340B0001"                                                                                       }
    if (IsChecked $Redux.Gameplay.RemoveNaviPrompts)        { ChangeBytes -Offset "DF8B84" -Values "00000000"                                                                                       }
    


    # GAMEPLAY #

    if (IsIndex $Redux.Gameplay.SpawnChild -Index 1 -Not)   { ChangeBytes -Offset "B0631E" -Values (GetOoTEntranceIndex $Redux.Gameplay.SpawnChild.Text)       }
    if (IsIndex $Redux.Gameplay.SpawnAdult -Index 2 -Not)   { ChangeBytes -Offset "B06332" -Values (GetOoTEntranceIndex $Redux.Gameplay.SpawnAdult.Text)       }
    if (IsChecked $Redux.Gameplay.ManualJump)               { ChangeBytes -Offset "BD78C0" -Values "04C1";     ChangeBytes -Offset "BD78E3" -Values "01"       }
    if (IsChecked $Redux.Gameplay.AltManualJump)            { ChangeBytes -Offset "BD78E3" -Values "00"                                                        }
    if (IsChecked $Redux.Gameplay.NoShieldRecoil)           { ChangeBytes -Offset "BD416C" -Values "2400"                                                      }
    if (IsChecked $Redux.Gameplay.RunWhileShielding)        { ChangeBytes -Offset "BD7DA0" -Values "10000055"; ChangeBytes -Offset "BD01D4" -Values "00000000" }
    if (IsChecked $Redux.Gameplay.PushbackAttackingWalls)   { ChangeBytes -Offset "BDEAE0" -Values "2624000024850000"                                          }
    if (IsChecked $Redux.Gameplay.RemoveCrouchStab)         { ChangeBytes -Offset "BDE374" -Values "1000000D"                                                  }
    if (IsChecked $Redux.Gameplay.RemoveQuickSpin)          { ChangeBytes -Offset "C9C9E8" -Values "1000000E"                                                  }
    if (IsChecked $Redux.Gameplay.RemoveSpeedClamp)         { ChangeBytes -Offset "BD9AF0" -Values "2400"                                                      }
    if (IsChecked $Redux.Gameplay.NoMagicArrowCooldown)     { ChangeBytes -Offset "AE85C9" -Values "62"                                                        }
    


    # GAMEPLAY (UNSTABLE) #

    if (IsChecked $Redux.Gameplay.HookshotAnything)    { ChangeBytes -Offset "AAA60E" -Values "24002400" }
    if (IsChecked $Redux.Gameplay.ClimbAnything)       { ChangeBytes -Offset "AAA394" -Values "34020004" }
    if (IsChecked $Redux.Gameplay.DistantZTargeting)   { ChangeBytes -Offset "A987AC" -Values "00000000" }



    # RESTORE #

    if ( (IsIndex -Elem $Redux.Restore.Blood -Index 2) -or (IsIndex -Elem $Redux.Restore.Blood -Index 4) -or (IsChecked $Redux.Restore.RedBlood) ) {
        ChangeBytes -Offset "B65A40" -Values "04"; ChangeBytes -Offset "B65A44" -Values "04"; ChangeBytes -Offset "B65A4C" -Values "04"; ChangeBytes -Offset "B65A50" -Values "04"
    }
    if ( (IsIndex -Elem $Redux.Restore.Blood -Index 3) -or (IsIndex -Elem $Redux.Restore.Blood -Index 4) ) {
        ChangeBytes -Offset "D8D590" -Values "00 78 00 FF 00 78 00 FF"; ChangeBytes -Offset "E8C424" -Values "00 78 00 FF 00 78 00 FF"
    }

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

    if (IsChecked $Redux.Restore.CowNoseRing)           { ChangeBytes -Offset "EF3E68" -Values "00 00"        }
    if (IsChecked $Redux.Restore.CenterTextboxCursor)   { ChangeBytes -Offset "B5883B" -Values "04" -Subtract }
    
    

    # FIXES #

    if (IsChecked $Redux.Fixes.BuyableBombs)           { ChangeBytes -Offset "C00840" -Values "1000"                                                      }
    if (IsChecked $Redux.Fixes.PauseScreenDelay)       { ChangeBytes -Offset "B15DD0" -Values "00000000"                                                  } # Pause Screen Anti-Aliasing
    if (IsChecked $Redux.Fixes.PauseScreenCrash)       { ChangeBytes -Offset "B12947" -Values "03"                                                        } # Pause Screen Delay Speed
    if (IsChecked $Redux.Fixes.WhiteBubbleCrash)       { ChangeBytes -Offset "CB4397" -Values "00"                                                        }
    if (IsChecked $Redux.Fixes.RemoveFishingPiracy)    { ChangeBytes -Offset "DBEC80" -Values "34020000"                                                  }
    if (IsChecked $Redux.Fixes.PoacherSaw)             { ChangeBytes -Offset "AE72CC" -Values "00000000"                                                  }
    if (IsChecked $Redux.Fixes.FortressMinimap)        { CopyBytes   -Offset "96E068" -Length "D48" -Start "974600"                                       }
    if (IsChecked $Redux.Fixes.AlwaysMoveKingZora)     { ChangeBytes -Offset "E55BB0" -Values "85CE8C3C"; ChangeBytes -Offset "E55BB4" -Values "844F0EDA" }
    if (IsChecked $Redux.Fixes.DeathMountainOwl)       { ChangeBytes -Offset "E304F0" -Values "240E0001"                                                  }
    if (IsChecked $Redux.Fixes.SpiritTempleMirrors)    { ChangeBytes -Offset "E45678" -Values "0000";     ChangeBytes -Offset "E4567B" -Values "00"       }
    if (IsChecked $Redux.Fixes.Boomerang)              { ChangeBytes -Offset "F0F718" -Values "FC41C7FFFFFFFE38"                                          }



    # OTHER #

    if ( (IsIndex -Elem $Redux.Other.MapSelect -Text "Translate Only") -or (IsIndex $Redux.Other.MapSelect -Text "Translate and Enable") ) { ExportAndPatch -Path "map_select" -Offset "B9FD90" -Length "EC0" }
    if ( (IsIndex -Elem $Redux.Other.MapSelect -Text "Enable Only")    -or (IsIndex $Redux.Other.MapSelect -Text "Translate and Enable") ) {
        ChangeBytes -Offset "A94994" -Values "00 00 00 00 AE 08 00 14 34 84 B9 2C 8E 02 00 18 24 0B 00 00 AC 8B 00 00"
        ChangeBytes -Offset "B67395" -Values "B9 E4 00 00 BA 11 60 80 80 09 C0 80 80 37 20 80 80 1C 14 80 80 1C 14 80 80 1C 08"
    }

    if ( (IsIndex   -Elem $Redux.Other.SkipIntro -Text "Skip Logo")         -or (IsIndex -Elem $Redux.Other.SkipIntro -Text "Skip Logo and Title Screen") )   { ChangeBytes -Offset "B9DAAC" -Values "00000000"                        }
    if ( (IsIndex   -Elem $Redux.Other.SkipIntro -Text "Skip Title Screen") -or (IsIndex -Elem $Redux.Other.SkipIntro -Text "Skip Logo and Title Screen") )   { ChangeBytes -Offset "B17237" -Values "30"                              }
    if   (IsDefault -Elem $Redux.Other.Skybox    -Not)                                                                                                        { ChangeBytes -Offset "B67722" -Values $Redux.Other.Skybox.SelectedIndex }

    if (IsChecked $Redux.Other.DefaultZTargeting)    { ChangeBytes -Offset "B71E6D" -Values "01"                                                        }
    if (IsChecked $Redux.Other.ItemSelect)           { ExportAndPatch -Path "inventory_editor" -Offset "BCBF64" -Length "C8"                            }
    if (IsChecked $Redux.Other.DiskDrive)            { ChangeBytes -Offset "BAF1F1" -Values "26";       ChangeBytes -Offset "E6D83B" -Values "04"       }



    # GRAPHICS #

    if (IsChecked $Redux.Graphics.WidescreenAlt) {
        # 16:9 Widescreen
        if ($IsWiiVC ) { ChangeBytes -Offset "B08038" -Values "3C 07 3F E3" }
        if ($GamePatch.settings -eq "Master of Time" -or $GamePatch.settings -eq "Dusk & Dusk") { return }

        # 16:9 Textures
        if ($GamePatch.vanilla -le 4) {
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

    if (IsChecked $Redux.Graphics.HideDungeonIcon) {
        ChangeBytes -Offset "B6C9F8" -Values "FFFF";         ChangeBytes -Offset "B6C9FC" -Values "FFFFFFFF"; ChangeBytes -Offset "B6CA06" -Values "FFFF"; ChangeBytes -Offset "B6CA0A" -Values "FFFFFFFF"
        ChangeBytes -Offset "B6CA10" -Values "FFFFFFFFFFFF"; ChangeBytes -Offset "B6CA1A" -Values "FFFFFFFF"; ChangeBytes -Offset "B6CA24" -Values "FFFF"
    }

    if (IsChecked $Redux.Graphics.GCScheme) { # Z to L + L to D-Pad textures
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

    if (IsChecked $Redux.Graphics.ExtendedDraw)      { ChangeBytes -Offset "A9A970" -Values "00 01" }
    if (IsChecked $Redux.Graphics.ForceHiresModel)   { ChangeBytes -Offset "BE608B" -Values "00"    }



    # INTERFACE #

    if ( (IsChecked $Redux.UI.ButtonPositions) -or (IsChecked $Redux.UI.HUD)) {
        ChangeBytes -Offset "B57F03" -Values "04" -Add # A Button / Text - X position (BA -> BE, +04)
        ChangeBytes -Offset "B586A7" -Values "0E" -Add # A Button / Text - Y position (09 -> 17, +0E)
        ChangeBytes -Offset "B57EEF" -Values "07" -Add # B Button        - X position (A0 -> A7, +07)
        ChangeBytes -Offset "B589EB" -Values "07" -Add # B Text          - X position (94 -> 9B, +07)
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

    if (IsChecked $Redux.UI.DungeonIcons) {
        PatchBytes -Offset "85F980"  -Shared -Patch "HUD\Dungeon Map Link\Majora's Mask.bin"
        PatchBytes -Offset "85FB80"  -Shared -Patch "HUD\Dungeon Map Skull\Majora's Mask.bin"
        PatchBytes -Offset "1A3E580" -Shared -Patch "HUD\Dungeon Map Chest\Majora's Mask.bin"
    }

    if (IsChecked $Redux.UI.CenterNaviPrompt)   { ChangeBytes -Offset "B582DF"  -Values "01" -Subtract }
    if (IsChecked $Redux.UI.DungeonKeys)        { PatchBytes  -Offset "1A3DE00" -Shared -Patch "HUD\Keys\Majora's Mask.bin"   }
    if (IsDefault $Redux.UI.Rupees -Not)        { PatchBytes  -Offset "1A3DF00" -Shared -Patch ("HUD\Rupees\" + $Redux.UI.Rupees.Text.replace(" (default)", "") + ".bin") }
    if (IsDefault $Redux.UI.Hearts -Not)        { PatchBytes  -Offset "1A3C000" -Shared -Patch ("HUD\Hearts\" + $Redux.UI.Hearts.Text.replace(" (default)", "") + ".bin") }
    if (IsDefault $Redux.UI.Magic  -Not)        { PatchBytes  -Offset "1A3F8C0" -Shared -Patch ("HUD\Magic\"  + $Redux.UI.Magic.Text.replace(" (default)", "")  + ".bin") }



    # HIDE HUD #

    if (IsChecked $Redux.Hide.AButton) {
        ChangeBytes -Offset "B586B0" -Values "00 00 00 00" # A Button (scale)
        ChangeBytes -Offset "AE7D0E" -Values "03 10"       # A Button - Text (DMA)
        ChangeBytes -Offset "7540"   -Values "03 10 00 00 03 10 57 00 03 10 00 00"
    }

    if (IsChecked $Redux.Hide.CButtons) {
        ChangeBytes -Offset "B58504" -Values "24 19 03 E3"; ChangeBytes -Offset "B5857C" -Values "24 19 03 E3"; ChangeBytes -Offset "B58DC4" -Values "24 0E 03 E4" # C-Left Button  -> Button / Icon / Ammo
        ChangeBytes -Offset "B58510" -Values "24 0F 03 F9"; ChangeBytes -Offset "B58588" -Values "24 0F 03 F9"; ChangeBytes -Offset "B58C40" -Values "24 06 02 FA" # C-Down Button  -> Button / Icon / Ammo
        ChangeBytes -Offset "B5851C" -Values "24 19 03 0F"; ChangeBytes -Offset "B58594" -Values "24 19 03 0F"; ChangeBytes -Offset "B58DE0" -Values "24 19 03 10" # C-Right Button -> Button / Icon / Ammo
    }

    if (IsChecked $Redux.Hide.Magic) {
        ChangeBytes -Offset "B587C0" -Values "24 0F 03 1A"; ChangeBytes -Offset "B587A0" -Values "24 0E 01 22"; ChangeBytes -Offset "B587B4" -Values "24 19 01 2A" # Magic Meter / Magic Bar - Small (Y pos) / Magic Bar - Large (Y pos)
    }

    if (IsChecked $Redux.Hide.Icons) {
        ChangeBytes -Offset "B58CFC" -Values "24 0F 00 00" # Clock - Digits (scale)
        $Values = @();     for ($i=0; $i -lt 256; $i++) { $Values += 0 };     ChangeBytes -Offset "1A3E000" -Values $Values     # Clock - Icon
        $Values = @();     for ($i=0; $i -lt 768; $i++) { $Values += 0 };     ChangeBytes -Offset "1A3E600" -Values $Values     # Score Counter - Icon
    }

    if (IsChecked $Redux.Hide.BButton)        { ChangeBytes -Offset "B57EEC" -Values "24 02 03 A0"; ChangeBytes -Offset "B57EFC" -Values "24 0A 03 A2"; ChangeBytes -Offset "B589D4" -Values "24 0F 03 97"; ChangeBytes -Offset "B589E8" -Values "24 19 03 94" } # B Button -> Icon / Ammo / Japanese / English
    if (IsChecked $Redux.Hide.StartButton)    { ChangeBytes -Offset "B584EC" -Values "24 19 03 84"; ChangeBytes -Offset "B58490" -Values "24 18 03 7A"; ChangeBytes -Offset "B5849C" -Values "24 0E 03 78" } # Start Button   -> Button / Japanese / English
    if (IsChecked $Redux.Hide.CupButton)      { ChangeBytes -Offset "B584C0" -Values "24 19 03 FE"; ChangeBytes -Offset "B582DC" -Values "24 0E 03 F7"                                                     } # C-Up Button    -> Button / Navi Text
    if (IsChecked $Redux.Hide.AreaTitle)      { ChangeBytes -Offset "BE2B10" -Values "24 07 03 A0" } # Area Titles
    if (IsChecked $Redux.Hide.DungeonTitle)   { ChangeBytes -Offset "AC8828" -Values "24 07 03 A0" } # Dungeon Titles
    if (IsChecked $Redux.Hide.Carrots)        { ChangeBytes -Offset "B58348" -Values "24 0F 03 6E" } # Epona Carrots    
    if (IsChecked $Redux.Hide.Hearts)         { ChangeBytes -Offset "ADADEC" -Values "10 00"       } # Disable Hearts Render
    if (IsChecked $Redux.Hide.Rupees)         { ChangeBytes -Offset "AEB7B0" -Values "24 0C 03 1A"; ChangeBytes -Offset "AEBC48" -Values "24 0D 01 CE" } # Rupees - Icon / Rupees - Text (Y pos)
    if (IsChecked $Redux.Hide.DungeonKeys)    { ChangeBytes -Offset "AEB8AC" -Values "24 0F 03 1A"; ChangeBytes -Offset "AEBA00" -Values "24 19 01 BE" } # Key    - Icon / Key    - Text (Y pos)
    if (IsChecked $Redux.Hide.Credits)        { PatchBytes  -Offset "966000" -Patch "Message\credits.bin"                                              }



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

    if (IsDefault $Redux.Styles.RegularChests -Not)   { PatchBytes -Offset "FEC798" -Shared -Patch ("Chests\" + $Redux.Styles.RegularChests.Text + ".front"); PatchBytes -Offset "FED798"  -Shared -Patch ("Chests\" + $Redux.Styles.RegularChests.Text + ".back") }
    if (IsDefault $Redux.Styles.BossChests    -Not)   { PatchBytes -Offset "FEE798" -Shared -Patch ("Chests\" + $Redux.Styles.BossChests.Text    + ".front"); PatchBytes -Offset "FEDF98"  -Shared -Patch ("Chests\" + $Redux.Styles.BossChests.Text    + ".back") }
    if (IsDefault $Redux.Styles.Crates        -Not)   { PatchBytes -Offset "F7ECA0" -Shared -Patch ("Crates\" + $Redux.Styles.Crates.Text        + ".bin") }
    if (IsDefault $Redux.Styles.Pots          -Not)   { PatchBytes -Offset "F7D8A0" -Shared -Patch ("Pots\"   + $Redux.Styles.Pots.Text          + ".bin");   PatchBytes -Offset "1738000" -Shared -Patch ("Pots\"   + $Redux.Styles.Pots.Text          + ".bin")  }


    # SOUNDS / VOICES #

    if ($GamePatch.age -eq "Child") {
        $file = "Voices Child\" + $Redux.Sounds.ChildVoices.Text.replace(" (default)", "") + ".bin"
        if (TestFile ($GameFiles.binaries + "\" + $file)) { PatchBytes -Offset "1DFC00" -Patch $file }
    }
    elseif ($GamePatch.age -eq "Adult") {
        $file = "Voices Adult\" + $Redux.Sounds.AdultVoices.Text.replace(" (default)", "") + ".bin"
        if (TestFile ($GameFiles.binaries + "\" + $file)) { PatchBytes -Offset "18E1E0" -Patch $file }
    }
    else {
        if (IsChecked $Redux.Restore.FireTemple) { $offset = "1EF340" } else { $offset = "1DFC00" }
        $file = "Voices Child\" + $Redux.Sounds.ChildVoices.Text.replace(" (default)", "") + ".bin"
        if (TestFile ($GameFiles.binaries + "\" + $file)) { PatchBytes -Offset $offset -Patch $file }

        if (IsChecked $Redux.Restore.FireTemple) { $offset = "19D920" } else { $offset = "18E1E0" }
        $file = "Voices Adult\" + $Redux.Sounds.AdultVoices.Text.replace(" (default)", "") + ".bin"
        if (TestFile ($GameFiles.binaries + "\" + $file)) { PatchBytes -Offset $offset -Patch $file }
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

    if ($GamePatch.vanilla -le 3) {
        if (IsChecked $Redux.Restore.FireTemple) {
            PatchReplaceMusic -bankPointerTableStart "B899EC" -BankPointerTableEnd "B89AD0" -PointerTableStart "B89AE0" -PointerTableEnd "B8A1C0" -SeqStart "39130" -SeqEnd "88BB0"
            PatchMuteMusic -SequenceTable "B89AE0" -Sequence "29DE0" -Length 108
        }
        else {
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

        if ($multi -gt 3) { $multi = 3 }

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

    if     (IsText -Elem $Redux.Hero.MagicUsage -Compare "2x Magic Usage")   { ChangeBytes -Offset "AE84FA" -Values "2C 40" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "4x Magic Usage")   { ChangeBytes -Offset "AE84FA" -Values "2C 80" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "8x Magic Usage")   { ChangeBytes -Offset "AE84FA" -Values "2C C0" }

    if (IsChecked $Redux.Hero.GraveyardKeese) {
        ChangeBytes -Offset "202F389" -Values "0E"; ChangeBytes -Offset "202F3BB" -Values "0D"; ChangeBytes -Offset "202F3DD" -Values "13"; ChangeBytes -Offset "202F3EB" -Values "03"; ChangeBytes -Offset "202F3ED" -Values "13"; ChangeBytes -Offset "202F3FB" -Values "03"
        ChangeBytes -Offset "202F3FD" -Values "13"; ChangeBytes -Offset "202F40B" -Values "03"; ChangeBytes -Offset "202F40D" -Values "13"; ChangeBytes -Offset "202F41B" -Values "03"; ChangeBytes -Offset "202F41D" -Values "13"; ChangeBytes -Offset "202F42B" -Values "03"
        ChangeBytes -Offset "202F779" -Values "0E"; ChangeBytes -Offset "202F7AB" -Values "0D"; ChangeBytes -Offset "202F7CD" -Values "13"; ChangeBytes -Offset "202F7DB" -Values "03"; ChangeBytes -Offset "202F7DD" -Values "13"; ChangeBytes -Offset "202F7EB" -Values "03"
        ChangeBytes -Offset "202F7ED" -Values "13"; ChangeBytes -Offset "202F7FB" -Values "03"; ChangeBytes -Offset "202F7FD" -Values "13"; ChangeBytes -Offset "202F80B" -Values "03"; ChangeBytes -Offset "202F80D" -Values "13"; ChangeBytes -Offset "202F81B" -Values "03"
    }

    if (IsChecked $Redux.Hero.LostWoodsOctorok) {
        ChangeBytes -Offset "2150C95" -Values "07 E1" # Child
        ChangeBytes -Offset "2157031" -Values "0C"; ChangeBytes -Offset "215706F" -Values "07"; ChangeBytes -Offset "21570F1" -Values "07"; ChangeBytes -Offset "215A031" -Values "0C"; ChangeBytes -Offset "215A06F" -Values "07"; ChangeBytes -Offset "215A151" -Values "07" # Child
        ChangeBytes -Offset "2163031" -Values "0C"; ChangeBytes -Offset "216306F" -Values "07"; ChangeBytes -Offset "2163151" -Values "07"; ChangeBytes -Offset "2168031" -Values "0C"; ChangeBytes -Offset "216806F" -Values "07"; ChangeBytes -Offset "2168191" -Values "07" # Child
        ChangeBytes -Offset "216E031" -Values "0C"; ChangeBytes -Offset "216E06F" -Values "07"; ChangeBytes -Offset "216E0F1" -Values "07"; ChangeBytes -Offset "2171031" -Values "0C"; ChangeBytes -Offset "217106F" -Values "07"; ChangeBytes -Offset "2171121" -Values "07" # Child
        ChangeBytes -Offset "2178031" -Values "0C"; ChangeBytes -Offset "217806F" -Values "07"; ChangeBytes -Offset "2178141" -Values "07"; ChangeBytes -Offset "217C031" -Values "0C"; ChangeBytes -Offset "217C06F" -Values "07"; ChangeBytes -Offset "217C131" -Values "07" # Adult
        ChangeBytes -Offset "217F031" -Values "0C"; ChangeBytes -Offset "217F06F" -Values "07"; ChangeBytes -Offset "217F161" -Values "07"; ChangeBytes -Offset "2182031" -Values "0C"; ChangeBytes -Offset "218206F" -Values "07"; ChangeBytes -Offset "21820F1" -Values "07" # Adult
    }

    if (IsText -Elem $Redux.Hero.ItemDrops -Compare "Nothing") {
        $Values = @()
        for ($i=0; $i -lt 80; $i++) { $Values += 0 }
        ChangeBytes -Offset "B5D6B0" -Values $Values
    }
    elseif (IsText -Elem $Redux.Hero.ItemDrops -Compare "Only Rupees") { PatchBytes  -Offset "B5D76A"  -Patch "only_rupee_drops.bin" }

    if   ( (IsValue $Redux.Recovery.Hearts -Value 0) -or (IsDefault $Redux.Hero.ItemDrops -Not) )   { ChangeBytes -Offset "A895B7"  -Values "2E"       }
    if     (IsChecked $Redux.Hero.NoBottledFairy)                                                   { ChangeBytes -Offset "BF0264"  -Values "00000000" }
    if     (IsChecked $Redux.Hero.Arwing)                                                           { ChangeBytes -Offset "2081086" -Values "0002";     ChangeBytes -Offset "2081114" -Values "013B"; ChangeBytes -Offset "2081122" -Values "0000" }
    elseif (IsChecked $Redux.Hero.LikeLike)                                                         { ChangeBytes -Offset "2081086" -Values "00D4";     ChangeBytes -Offset "2081114" -Values "00DD"; ChangeBytes -Offset "2081122" -Values "0000" }
    
    if     ( (IsChecked $Redux.Hero.HarderStalfos)           -and (IsDefault $Redux.Hero.HarderStalfos      -Not) )   { ChangeBytes -Offset "BFB35C"  -Values "00000000"; ChangeBytes -Offset "BFC148" -Values "00000000" }
    elseif ( (IsChecked $Redux.Hero.HarderStalfos      -Not) -and (IsDefault $Redux.Hero.HarderStalfos      -Not) )   { ChangeBytes -Offset "BFB35C"  -Values "11E00005"; ChangeBytes -Offset "BFC148" -Values "11200005" }
    if     ( (IsChecked $Redux.Hero.HarderWolfos)            -and (IsDefault $Redux.Hero.HarderWolfos       -Not) )   { ChangeBytes -Offset "EDBE3F"  -Values "00" }
    elseif ( (IsChecked $Redux.Hero.HarderWolfos       -Not) -and (IsDefault $Redux.Hero.HarderWolfos       -Not) )   { ChangeBytes -Offset "EDBE3F"  -Values "15" }
    if     ( (IsChecked $Redux.Hero.HarderGohma)             -and (IsDefault $Redux.Hero.HarderKeese        -Not) )   { ChangeBytes -Offset "C455A7"  -Values "20"; ChangeBytes -Offset "C482B3" -Values "40"; ChangeBytes -Offset "C49347" -Values "24"; ChangeBytes -Offset "C49367" -Values "0F" }
    elseif ( (IsChecked $Redux.Hero.HarderGohma        -Not) -and (IsDefault $Redux.Hero.HarderKeese        -Not) )   { ChangeBytes -Offset "C455A7"  -Values "46"; ChangeBytes -Offset "C482B3" -Values "96"; ChangeBytes -Offset "C49347" -Values "5A"; ChangeBytes -Offset "C49367" -Values "28" }
    if     ( (IsChecked $Redux.Hero.HarderKingDodongo)       -and (IsDefault $Redux.Hero.HarderKingDodongo  -Not) )   { ChangeBytes -Offset "C3CB7F"  -Values "32"; ChangeBytes -Offset "C3CF73" -Values "00"; ChangeBytes -Offset "C3CE5E" -Values "FFFF" }
    elseif ( (IsChecked $Redux.Hero.HarderKingDodongo  -Not) -and (IsDefault $Redux.Hero.HarderKingDodongo  -Not) )   { ChangeBytes -Offset "C3CB7F"  -Values "64"; ChangeBytes -Offset "C3CF73" -Values "64"; ChangeBytes -Offset "C3CE5E" -Values "FFFE" }
    if     ( (IsChecked $Redux.Hero.AggressiveDarkLink)      -and (IsDefault $Redux.Hero.AggressiveDarkLink -Not) )   { ChangeBytes -Offset "C5C39F"  -Values "70" }
    elseif ( (IsChecked $Redux.Hero.AggressiveDarkLink -Not) -and (IsDefault $Redux.Hero.AggressiveDarkLink -Not) )   { ChangeBytes -Offset "C5C39F"  -Values "01" }

    if ( (IsChecked $Redux.Hero.HarderKeese) -and (IsDefault $Redux.Hero.HarderKeese -Not) ) {
        ChangeBytes -Offset "C1495A" -Values "0014"; ChangeBytes -Offset "C1496A" -Values "0014"; ChangeBytes -Offset "C149AE" -Values "0014"; ChangeBytes -Offset "C149E6" -Values "0014"
        ChangeBytes -Offset "C13968" -Values "00000000000000000000000000000000"
    }
    elseif ( (IsChecked $Redux.Hero.HarderKeese -Not) -and (IsDefault $Redux.Hero.HarderKeese -Not) ) {
        ChangeBytes -Offset "C1495A" -Values "01AA"; ChangeBytes -Offset "C1496A" -Values "01AA"; ChangeBytes -Offset "C149AE" -Values "01AA"; ChangeBytes -Offset "C149E6" -Values "01AA"
        ChangeBytes -Offset "C13968" -Values "A08001A8A08001A9A099011703E00008"
    }
    


    # RECOVERY #

    if (IsDefault $Redux.Recovery.Heart       -Not)   { ChangeBytes -Offset "AE6FC6" -Values (Get16Bit $Redux.Recovery.Heart.Text      ) }
    if (IsDefault $Redux.Recovery.Fairy       -Not)   { ChangeBytes -Offset "BEAA4A" -Values (Get16Bit $Redux.Recovery.Fairy.Text      ) }
    if (IsDefault $Redux.Recovery.FairyRevive -Not)   { ChangeBytes -Offset "BDF65A" -Values (Get16Bit $Redux.Recovery.FairyRevive.Text) }
    if (IsDefault $Redux.Recovery.Milk        -Not)   { ChangeBytes -Offset "BEA64A" -Values (Get16Bit $Redux.Recovery.Milk.Text       ) }
    if (IsDefault $Redux.Recovery.RedPotion   -Not)   { ChangeBytes -Offset "BEA616" -Values (Get16Bit $Redux.Recovery.RedPotion.Text  ) }



    # MAGIC #

    if (IsDefault $Redux.Magic.FireArrow   -Not)   { ChangeBytes -Offset "BEFC10" -Values (Get8Bit $Redux.Magic.FireArrow.Text)   }
    if (IsDefault $Redux.Magic.IceArrow    -Not)   { ChangeBytes -Offset "BEFC11" -Values (Get8Bit $Redux.Magic.IceArrow.Text)    }
    if (IsDefault $Redux.Magic.LightArrow  -Not)   { ChangeBytes -Offset "BEFC12" -Values (Get8Bit $Redux.Magic.LightArrow.Text)  }
    if (IsDefault $Redux.Magic.DinsFire    -Not)   { ChangeBytes -Offset "BEFC05" -Values (Get8Bit $Redux.Magic.DinsFire.Text)    }
    if (IsDefault $Redux.Magic.FaroresWind -Not)   { ChangeBytes -Offset "BEFC03" -Values (Get8Bit $Redux.Magic.FaroresWind.Text) }
    if (IsDefault $Redux.Magic.NayrusLove  -Not)   { ChangeBytes -Offset "BEFC05" -Values (Get8Bit $Redux.Magic.NayrusLove.Text)  }
    


    # MINIGAMES #

    if (IsChecked $Redux.Minigames.FishSize) {
        ChangeBytes -Offset "DCBEA8" -Values "3C014248"; ChangeBytes -Offset "DCBF24" -Values "3C014248"                                                  # Adult Fish size requirement
        ChangeBytes -Offset "DCBF30" -Values "3C014230"; ChangeBytes -Offset "DCBF9C" -Values "3C014230"                                                  # Child Fish size requirement
    }

    if (IsChecked $Redux.Minigames.FishLoss) {
        ChangeBytes -Offset "DC87A0" -Values "00000000"; ChangeBytes -Offset "DC87BC" -Values "00000000"; ChangeBytes -Offset "DC87CC" -Values "00000000" # Remove most fish loss branches
        ChangeBytes -Offset "DC8828" -Values "01A00821"                                                                                                   # Prevent RNG fish loss
    }
    
    if (IsChecked $Redux.Minigames.Bowling) {
        ChangeBytes -Offset "E2E697" -Values $Redux.Minigames.Bowling1.value; ChangeBytes -Offset "E2E69B" -Values $Redux.Minigames.Bowling2.value; ChangeBytes -Offset "E2E69F" -Values $Redux.Minigames.Bowling3.value
        ChangeBytes -Offset "E2E6A3" -Values $Redux.Minigames.Bowling4.value; ChangeBytes -Offset "E2E6A7" -Values $Redux.Minigames.Bowling5.value; ChangeBytes -Offset "E2D440" -Values "24190000"
    }

  # if (IsChecked $Redux.Minigames.Ocarina)   { ChangeBytes -Offset "DF2204" -Values "24030002" } # Skullkid Ocarina
    if (IsChecked $Redux.Minigames.Dampe)     { ChangeBytes -Offset "CC4024" -Values "00000000" } # Dampé's Digging Game
    


    # EASY MODE #

    if (IsChecked $Redux.EasyMode.NoShieldSteal)         { ChangeBytes -Offset "D74910"  -Values "1000000B"                                          }
    if (IsChecked $Redux.EasyMode.NoTunicSteal)          { ChangeBytes -Offset "D74964"  -Values "1000000A"                                          }
    if (IsChecked $Redux.EasyMode.SkipStealthSequence)   { ChangeBytes -Offset "21F60DE" -Values "05F0"                                              }
    if (IsChecked $Redux.EasyMode.SkipTowerEscape)       { ChangeBytes -Offset "D82A12"  -Values "0517"; ChangeBytes -Offset "B139A2" -Values "0517" }
    if (IsChecked $Redux.EasyMode.HotRodderGoron)        { ChangeBytes -Offset "ED289C"  -Values "1100"; ChangeBytes -Offset "ED28A4" -Values "1100" }



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

    if (IsChecked $Redux.Scenes.NaviTarget) {
        $offset = SearchBytes -Start "2ADE000" -End "2BEAA20" -Values "61 00 06 00 05 00 00 3C 24 01 11 FD A8 01 4D FB"; ChangeBytes -Offset $offset -Values "7E" # Spirit Temple
        ChangeBytes -Offset "283B14B" -Values "5C FA F3 FD AC"       # Shadow Temple
        ChangeBytes -Offset "236C059" -Values "4B FD 31 00 1E 00 16" # Fire Temple
        ChangeBytes -Offset "2C1906D" -Values "18 00 00 00 00"       # Ice Cavern
    }

    if (IsChecked $Redux.Scenes.DodongosCavernGossipStone) { ChangeBytes -Offset "1F281FE" -Values "38" }



    # SCENE ADJUSTMENTS #

    if (IsChecked $Redux.Scenes.MuteOwls) {
        ChangeBytes -Offset "1FE30CF" -Values "00";    ChangeBytes -Offset "1FE30DF" -Values "00";    ChangeBytes -Offset "1FE30EE" -Values "00 00"; ChangeBytes -Offset "1FE30FE" -Values "00 00"
        ChangeBytes -Offset "205909E" -Values "00 00"; ChangeBytes -Offset "21630CE" -Values "00 00"; ChangeBytes -Offset "217F0DE" -Values "00 00"; ChangeBytes -Offset "21A008E" -Values "00 00"; ChangeBytes -Offset "220F073" -Values "00"
    }

    if (IsChecked $Redux.Scenes.OverworldSkyboxes) {
        ChangeBytes -Offset "206F054" -Values "01"; ChangeBytes -Offset "207BC4C" -Values "01"; ChangeBytes -Offset "207BF5C" -Values "01"; ChangeBytes -Offset "207C264" -Values "01"; ChangeBytes -Offset "207C394" -Values "01" # Kokiri Forest
        ChangeBytes -Offset "207C4B4" -Values "01"; ChangeBytes -Offset "207C5DC" -Values "01"; ChangeBytes -Offset "207C78C" -Values "01"; ChangeBytes -Offset "207C93C" -Values "01"; ChangeBytes -Offset "207CAE4" -Values "01" # Kokiri Forest
        ChangeBytes -Offset "207CBC4" -Values "01"; ChangeBytes -Offset "207CCA4" -Values "01"; ChangeBytes -Offset "207CE74" -Values "01"                                                                                         # Kokiri Forest
        ChangeBytes -Offset "214604C" -Values "01"; ChangeBytes -Offset "2151D4C" -Values "01"; ChangeBytes -Offset "21520E4" -Values "01"                                                                                         # Lost Woods
        ChangeBytes -Offset "20AC044" -Values "01"; ChangeBytes -Offset "20B2814" -Values "01"; ChangeBytes -Offset "20B2A3C" -Values "01"; ChangeBytes -Offset "20B2B1C" -Values "01"                                             # Sacred Meadow
        ChangeBytes -Offset "2110044" -Values "01"; ChangeBytes -Offset "21143AC" -Values "01"; ChangeBytes -Offset "211458C" -Values "01"                                                                                         # Zora's Fountain
        ChangeBytes -Offset "21DC04C" -Values "03"                                                                                                                                                                                 # Haunted Wasteland
    }

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

    if ($Redux.Colors.SetEquipment -ne $null) {
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

    if ($Redux.Colors.SetSpinAttack -ne $null) {
        if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[0] -Not)   { ChangeBytes -Offset "F15AB4" -Values @($Redux.Colors.SetSpinAttack[0].Color.R, $Redux.Colors.SetSpinAttack[0].Color.G, $Redux.Colors.SetSpinAttack[0].Color.B) } # Blue Spin Attack
        if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[1] -Not)   { ChangeBytes -Offset "F15BD4" -Values @($Redux.Colors.SetSpinAttack[1].Color.R, $Redux.Colors.SetSpinAttack[1].Color.G, $Redux.Colors.SetSpinAttack[1].Color.B) } # Blue Spin Attack
        if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[2] -Not)   { ChangeBytes -Offset "F16034" -Values @($Redux.Colors.SetSpinAttack[2].Color.R, $Redux.Colors.SetSpinAttack[2].Color.G, $Redux.Colors.SetSpinAttack[2].Color.B) } # Red Spin Attack
        if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[3] -Not)   { ChangeBytes -Offset "F16154" -Values @($Redux.Colors.SetSpinAttack[3].Color.R, $Redux.Colors.SetSpinAttack[3].Color.G, $Redux.Colors.SetSpinAttack[3].Color.B) } # Red Spin Attack
    }



    # SWORD TRAIL COLORS #

    if ($Redux.Colors.SetSwordTrail -ne $null) {
        if (IsDefaultColor -Elem $Redux.Colors.SetSwordTrail[0] -Not)       { ChangeBytes -Offset "BEFF7C" -Values @($Redux.Colors.SetSwordTrail[0].Color.R, $Redux.Colors.SetSwordTrail[0].Color.G, $Redux.Colors.SetSwordTrail[0].Color.B) }
        if (IsDefaultColor -Elem $Redux.Colors.SetSwordTrail[1] -Not)       { ChangeBytes -Offset "BEFF84" -Values @($Redux.Colors.SetSwordTrail[1].Color.R, $Redux.Colors.SetSwordTrail[1].Color.G, $Redux.Colors.SetSwordTrail[1].Color.B) }
        if (IsIndex -Elem $Redux.Colors.SwordTrailDuration -Not -Index 2)   { ChangeBytes -Offset "BEFF8C" -Values (($Redux.Colors.SwordTrailDuration.SelectedIndex) * 5) }
    }
    


    # FAIRY COLORS #

    if (IsChecked -Elem $Redux.Colors.BetaNavi) { ChangeBytes -Offset "A96110" -Values "34 0F 00 60" }
    elseif ($Redux.Colors.SetFairy -ne $null) {
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

    if ($Patches.Redux.Checked -and (IsChecked $Redux.Hooks.RupeeIconColors) -and $Redux.Colors.SetRupee -ne $null) {
        $Symbols = SetJSONFile ($GameFiles.base + "\symbols.json")
        if (IsDefaultColor -Elem $Redux.Colors.SetRupee[0] -Not)   { ChangeBytes -Offset (AddToOffset -Hex $Symbols.rupee_colors -Add 0) -Values @($Redux.Colors.SetRupee[0].Color.R, $Redux.Colors.SetRupee[0].Color.G, $Redux.Colors.SetRupee[0].Color.B) } # Base wallet 
        if (IsDefaultColor -Elem $Redux.Colors.SetRupee[1] -Not)   { ChangeBytes -Offset (AddToOffset -Hex $Symbols.rupee_colors -Add 3) -Values @($Redux.Colors.SetRupee[1].Color.R, $Redux.Colors.SetRupee[1].Color.G, $Redux.Colors.SetRupee[1].Color.B) } # Adult's Wallet
        if (IsDefaultColor -Elem $Redux.Colors.SetRupee[2] -Not)   { ChangeBytes -Offset (AddToOffset -Hex $Symbols.rupee_colors -Add 6) -Values @($Redux.Colors.SetRupee[2].Color.R, $Redux.Colors.SetRupee[2].Color.G, $Redux.Colors.SetRupee[2].Color.B) } # Giant's Wallet
        if (IsDefaultColor -Elem $Redux.Colors.SetRupee[3] -Not)   { ChangeBytes -Offset (AddToOffset -Hex $Symbols.rupee_colors -Add 9) -Values @($Redux.Colors.SetRupee[3].Color.R, $Redux.Colors.SetRupee[3].Color.G, $Redux.Colors.SetRupee[3].Color.B) } # Tycoon's Wallet
        $Symbols = $null
    }
    elseif ($Redux.Colors.RupeeVanilla.Active -and $Redux.Colors.SetRupeeVanilla -ne $null) {
        if (IsDefaultColor -Elem $Redux.Colors.SetRupeeVanilla -Not) {
            ChangeBytes -Offset "AEB766" -Values @($Redux.Colors.SetRupeeVanilla.Color.R, $Redux.Colors.SetRupeeVanilla.Color.G)
            ChangeBytes -Offset "AEB77A" -Values $Redux.Colors.SetRupeeVanilla.Color.B
        }
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
    if (IsDefault $Redux.Save.Rupees   -Not)    { $value = Get16Bit ([int]$Redux.Save.Rupees.Text);                   ChangeBytes -Offset "B71E90" -Values $value                     }

    if (IsChecked $Redux.Capacity.EnableAmmo) {
        ChangeBytes -Offset "B71EE8" -Values (Get8Bit ($Redux.Capacity["DekuSticks" + ($Redux.Save.DekuSticks.SelectedIndex + 1)].Text) ) # Deku Sticks
        ChangeBytes -Offset "B71EE9" -Values (Get8Bit ($Redux.Capacity["DekuNuts"   + ($Redux.Save.DekuNuts.SelectedIndex   + 1)].Text) ) # Deku Nuts
        ChangeBytes -Offset "B71EEE" -Values (Get8Bit ($Redux.Capacity["BulletBag"  + ($Redux.Save.BulletBag.SelectedIndex  + 1)].Text) ) # Bullet Seeds
        ChangeBytes -Offset "B71EEB" -Values (Get8Bit ($Redux.Capacity["Quiver"     + ($Redux.Save.Quiver.SelectedIndex     + 1)].Text) ) # Arrows
        ChangeBytes -Offset "B71EEA" -Values (Get8Bit ($Redux.Capacity["BombBag"    + ($Redux.Save.BombBag.SelectedIndex    + 1)].Text) ) # Bombs
    }

    if (IsDefault $Redux.Save.Hearts -Not)   {
        $value = Get16Bit ([int]$Redux.Save.Hearts.Text * 16); ChangeBytes -Offset "B71E8A" -Values $value; ChangeBytes -Offset "B71E8C" -Values $value; ChangeBytes -Offset "B0635E" -Values $value; ChangeBytes -Offset "B06366" -Values $value
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
        
        # Upgrade Checks
        ChangeBytes -Offset "ED288B" -Values (Get8Bit $Redux.Capacity.BombBag1.Text); ChangeBytes -Offset "ED295B" -Values (Get8Bit $Redux.Capacity.BombBag2.Text); ChangeBytes -Offset "E2EEFB" -Values (Get8Bit $Redux.Capacity.BombBag2.Text)

        # Initial Ammo
        ChangeBytes -Offset "AE6D03" -Values (Get8Bit $Redux.Capacity.BulletBag1.Text)
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
    elseif (IsChecked $Redux.Misc.TycoonWallet) { ChangeBytes -Offset "B6D57F" -Values "03" }



    # ITEM DROPS QUANTITY #

    if (IsChecked $Redux.Capacity.EnableDrops) {
        ChangeBytes -Offset "B6D4D1" -Values @($Redux.Capacity.Arrows1x.Text,  $Redux.Capacity.Arrows2x.Text, $Redux.Capacity.Arrows3x.Text)                              -Interval 2
        ChangeBytes -Offset "AE6D43" -Values $Redux.Capacity.BulletSeeds1x.Text
        ChangeBytes -Offset "AE6DCF" -Values $Redux.Capacity.BulletSeeds2x.Text
        ChangeBytes -Offset "AE675B" -Values $Redux.Capacity.DekuSticks1x.Text
        ChangeBytes -Offset "B6D4C9" -Values ($Redux.Capacity.Bombs1x.Text,    $Redux.Capacity.Bombs2x.Text,  $Redux.Capacity.Bombs3x.Text, $Redux.Capacity.Bombs4x.Text) -Interval 2
        ChangeBytes -Offset "B6D4D9" -Values ($Redux.Capacity.DekuNuts1x.Text, $Redux.Capacity.DekuNuts2x.Text)                                                           -Interval 2
        ChangeBytes -Offset "B9CC39" -Values ($Redux.Capacity.Bombchus1x.Text, $Redux.Capacity.Bombchus3x.Text)                                                           -Interval 2
        ChangeBytes -Offset "AE6B63" -Values $Redux.Capacity.Bombchus2x.Text;  ChangeBytes -Offset "AE6B8B" -Values $Redux.Capacity.Bombchus2x.Text

        $RupeeG = Get16Bit $Redux.Capacity.RupeeG.Text; $RupeeB = Get16Bit $Redux.Capacity.RupeeB.Text; $RupeeR = Get16Bit $Redux.Capacity.RupeeR.Text; $RupeeP = Get16Bit $Redux.Capacity.RupeeP.Text; $RupeeO = Get16Bit $Redux.Capacity.RupeeO.Text
        ChangeBytes -Offset "B6D4DC" -Values ($RupeeG + $RupeeB + $RupeeR + $RupeeP + $RupeeO)
        ChangeBytes -Offset "DF362E" -Values (Get16Bit $Redux.Capacity.RupeeS.Text)
    }



    # EQUIPMENT #

    if (IsChecked $Redux.Equipment.HerosBow) {
        PatchBytes -Offset "7C0000" -Texture -Patch "Equipment\Bow\heros_bow.icon"
        PatchBytes -Offset "7F5000" -Texture -Patch "Equipment\Bow\heros_bow_fire.icon"
        PatchBytes -Offset "7F6000" -Texture -Patch "Equipment\Bow\heros_bow_ice.icon"
        PatchBytes -Offset "7F7000" -Texture -Patch "Equipment\Bow\heros_bow_light.icon"
        if (TestFile ($GameFiles.textures + "\Equipment\Bow\heros_bow." + $LanguagePatch.code + ".label")) { PatchBytes -Offset "89F800" -Texture -Patch ("Equipment\Bow\heros_bow." + $LanguagePatch.code + ".label") }
    }

    if (IsDefault $Redux.Equipment.GiantKnifeHealth -Not) {
        $value =  (Get8Bit $Redux.Equipment.GiantKnifeHealth.Text)
        ChangeBytes -Offset "AE5F0B" -Values $value; ChangeBytes -Offset "C014F3" -Values $value; ChangeBytes -Offset "B71F4F" -Values $value
    }

    if (IsChecked $Redux.Equipment.FireProofDekuShield)     { ChangeBytes -Offset "BD3C5B" -Values "00"                                            }
    if (IsChecked $Redux.Equipment.UnsheathSword)           { ChangeBytes -Offset "BD04A0" -Values "28 42 00 05 14 40 00 05 00 00 10 25"           }
    if (IsChecked $Redux.Equipment.Hookshot)                { PatchBytes  -Offset "7C7000" -Texture -Patch "Equipment\termina_hookshot.icon"       }
    if (IsChecked $Redux.Equipment.GoronBraceletFix)        { ChangeBytes -Offset "BB66DD" -Values "C0"; ChangeBytes -Offset "BC780C" -Values "09" }
    
    

    # SWORDS & SHIELDS #

    if (IsDefault $Redux.Equipment.KokiriSword -Not) {
        if (TestFile ($GameFiles.textures + "\Equipment\Kokiri Sword\" + $Redux.Equipment.KokiriSword.text + ".icon"))                                    { PatchBytes -Offset "7F8000" -Texture -Patch ("Equipment\Kokiri Sword\" + $Redux.Equipment.KokiriSword.text + ".icon")                              }
        if (TestFile ($GameFiles.textures + "\Equipment\Kokiri Sword\" + $Redux.Equipment.KokiriSword.text + "." + $LanguagePatch.code + ".label"))       { PatchBytes -Offset "8AD800" -Texture -Patch ("Equipment\Kokiri Sword\" + $Redux.Equipment.KokiriSword.text + "." + $LanguagePatch.code + ".label") }
    }

    if (IsDefault $Redux.Equipment.MasterSword -Not) {
        if (TestFile ($GameFiles.textures + "\Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text + ".icon"))                                    { PatchBytes -Offset "7F9000" -Texture -Patch ("Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text + ".icon")                              }
        if (TestFile ($GameFiles.textures + "\Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text + "." + $LanguagePatch.code + ".label"))       { PatchBytes -Offset "8ADC00" -Texture -Patch ("Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text + "." + $LanguagePatch.code + ".label") }
    }

    if (IsDefault $Redux.Equipment.GiantsKnife -Not) {
        if (TestFile ($GameFiles.textures + "\Equipment\Master Sword\" + $Redux.Equipment.GiantsKnife.text + ".icon"))                                    { PatchBytes -Offset "7FA000" -Texture -Patch ("Equipment\Master Sword\" + $Redux.Equipment.GiantsKnife.text + ".icon")                              }
        if (TestFile ($GameFiles.textures + "\Equipment\Master Sword\" + $Redux.Equipment.GiantsKnife.text + "." + $LanguagePatch.code + ".label"))       { PatchBytes -Offset "8AE000" -Texture -Patch ("Equipment\Master Sword\" + $Redux.Equipment.GiantsKnife.text + "." + $LanguagePatch.code + ".label") }
    }

    if (IsDefault $Redux.Equipment.BiggoronSword -Not) {
        if (TestFile ($GameFiles.textures + "\Equipment\Master Sword\" + $Redux.Equipment.BiggoronSword.text + ".icon"))                                  { PatchBytes -Offset "7FA000" -Texture -Patch ("Equipment\Master Sword\" + $Redux.Equipment.BiggoronSword.text + ".icon")                              }
        if (TestFile ($GameFiles.textures + "\Equipment\Master Sword\" + $Redux.Equipment.BiggoronSword.text + "." + $LanguagePatch.code + ".label"))     { PatchBytes -Offset "8BD000" -Texture -Patch ("Equipment\Master Sword\" + $Redux.Equipment.BiggoronSword.text + "." + $LanguagePatch.code + ".label") }
    }

    if (IsDefault $Redux.Equipment.SwordHealth -Not) {
        ChangeBytes -Offset "AE5F2F" -Values (Get8Bit $Redux.Equipment.SwordHealth.Text); ChangeBytes -Offset "B71F4F" -Values (Get8Bit $Redux.Equipment.SwordHealth.Text); ChangeBytes -Offset "BB6823" -Values (Get8Bit $Redux.Equipment.SwordHealth.Text)
    }

    if (IsDefault $Redux.Equipment.DekuShield -Not) {
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
        if (TestFile ($GameFiles.textures + "\Equipment\Deku Shield\" + $Redux.Equipment.DekuShield.text + ".icon"))                                    { PatchBytes -Offset "7FB000" -Texture -Patch ("Equipment\Deku Shield\"   + $Redux.Equipment.DekuShield.text + ".icon")                              }
        if (TestFile ($GameFiles.textures + "\Equipment\Deku Shield\" + $Redux.Equipment.DekuShield.text + "." + $LanguagePatch.code + ".label"))       { PatchBytes -Offset "8AE400" -Texture -Patch ("Equipment\Deku Shield\"   + $Redux.Equipment.DekuShield.text + "." + $LanguagePatch.code + ".label") }
    }

    if (IsDefault $Redux.Equipment.HylianShield -Not) {
        if (TestFile ($GameFiles.textures + "\Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".front")) {
            PatchBytes -Offset "F03400" -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".front")
            $Offset = SearchBytes -Start "FBE000" -End "FEAF80" -Values "BE 35 BE 77 C6 B9 CE FB D6 FD D7 3D DF 3F DF 7F"
            if ($Offset -gt 0)                                                                                                                          { PatchBytes -Offset $Offset  -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".front") }
        }

        if (TestFile ($GameFiles.textures + "\Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".back") ) {
            $Offset = SearchBytes -Start "FBE000" -End "FEAF80" -Values "B5 F3 AD F3 AD F3 B5 F1 C6 75 A5 6F 8C EB 6B E5"
            if ($Offset -gt 0)                                                                                                                          { PatchBytes -Offset $Offset  -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".back") }
        }

        if (TestFile ($GameFiles.textures + "\Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".icon"))                                { PatchBytes -Offset "7FC000" -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".icon")                              }
        if (TestFile ($GameFiles.textures + "\Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + "." + $LanguagePatch.code + ".label"))   { PatchBytes -Offset "8AE800" -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + "." + $LanguagePatch.code + ".label") }
    }

    if (IsDefault $Redux.Equipment.MirrorShield -Not) {
        if ($AdultModel.mirror_shield -ne 0 -and (TestFile ($GameFiles.textures + "\Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".bin"))) {
            $Offset = SearchBytes -Start "F86000" -End "FBD800" -Values "90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90"
            PatchBytes -Offset $Offset -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".bin")
            if (TestFile ($GameFiles.textures + "\Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".chest"))                           { PatchBytes -Offset "1616000" -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".chest")      }
            if (TestFile ($GameFiles.textures + "\Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".reflection"))                      { PatchBytes -Offset "1456388" -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".reflection") }
        }
        if (TestFile ($GameFiles.textures + "\Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".icon"))                                { PatchBytes -Offset "7FD000"  -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".icon")                              }
        if (TestFile ($GameFiles.textures + "\Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + "." + $LanguagePatch.code + ".label"))   { PatchBytes -Offset "8AEC00"  -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + "." + $LanguagePatch.code + ".label") }
    }

    if     (IsChecked $Redux.Graphics.ListAdultMaleModels)            { $file = "Adult Male\"   + $Redux.Graphics.AdultMaleModels.Text.replace(" (default)",   "") }
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
        ChangeBytes -Offset "C944D8"  -Values "00 00 00 00";  ChangeBytes -Offset "C94548"  -Values "00 00 00 00"; ChangeBytes -Offset "C94730" -Values "00 00 00 00";  ChangeBytes -Offset "C945A8" -Values "00 00 00 00"; ChangeBytes -Offset "C94594" -Values "00 00 00 00"                                     # Phantom Ganon
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

    if ($GamePatch.vanilla -eq 1) { $dungeons = PatchDungeonsOoTMQ }



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
        PatchBytes -Offset $Offset   -Texture -Patch "Gerudo Symbols\spirit_temple_room_0_pillars.bin"
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

    if (IsChecked $Redux.Text.NaviPrompt) {
        ChangeBytes -Offset "AE7CD8" -Values "00 00 00 00"
        PatchBytes  -Offset "8E3A80" -Texture -Patch ("Action Prompts\Navi\Navi.prompt")
    }
    
    if (IsChecked $Redux.Text.YeetPrompt)    { PatchBytes -Offset "8E3900" -Shared  -Patch "Action Prompts\throw.en.prompt" }
    if (IsChecked $Redux.Text.CheckPrompt)   { PatchBytes -Offset "8E2D00" -Texture -Patch "Action Prompts\check.de.prompt" }
    if (IsChecked $Redux.Text.DivePrompt)    { PatchBytes -Offset "8E3600" -Texture -Patch "Action Prompts\dive.de.prompt"  }

}



#==============================================================================================================================================================================================
function RevertReduxOptions() {
    
    $Symbols = SetJSONFile ($GameFiles.base + "\symbols.json")
    $payload = $Symbols.PAYLOAD_START + $Symbols.PAYLOAD_END + $Symbols.PAYLOAD_START

    if ($GamePatch.settings -eq "Master of Time") {
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

    if (IsRevert $Redux.Speedup.DoorOfTime)           { ChangeBytes -Offset "CCE9A4" -Values "3C013F8044813000"                                                                                                                       }
    if (IsRevert $Redux.Hooks.FishLarger)             { ChangeBytes -Offset "DBF428" -Values "C652019C3C0142824481400046009100E644"; ChangeBytes -Offset "DBF484" -Values "E652019C"; ChangeBytes -Offset "DBF4A8" -Values "E648019C" }
    if (IsRevert $Redux.Hooks.FishBites)              { ChangeBytes -Offset "DC7090" -Values "C60A019846025102"                                                                                                                       }
    if (IsRevert $Redux.Hooks.BlueFireArrow)          { ChangeBytes -Offset "DB32C8" -Values "240100F0"                                                                                                                               }
    if (IsRevert $Redux.Hooks.RupeeIconColors)        { ChangeBytes -Offset "AEB764" -Values "3C01C8FF26380008AE9802B0"; ChangeBytes -Offset "AEB778" -Values "34216400"                                                              }
    if (IsRevert $Redux.Hooks.StoneOfAgony)           { ChangeBytes -Offset "BE4A14" -Values "4602003C";                 ChangeBytes -Offset "BE4A40" -Values "4606203C"; ChangeBytes -Offset "BE4A60" -Values "27BD002003E00008"     }
    if (IsRevert $Redux.Hooks.EmptyBombFix)           { ChangeBytes -Offset "C0E77C" -Values "AC400428AC4D066C"                                                                                                                       }
    if (IsRevert $Redux.Hooks.WarpSongsSpeedup)       { ChangeBytes -Offset "B10CC0" -Values "3C0100013421241C";         ChangeBytes -Offset "BEA045"  -Values "009444E7A00010"                                                       }
    if (IsRevert $Redux.Hooks.BiggoronFix)            { ChangeBytes -Offset "ED645C" -Values "1000000DAC8E0180"                                                                                                                       }
    if (IsRevert $Redux.Hooks.DampeFix)               { ChangeBytes -Offset "CC4038" -Values "240C0004304A1000";         ChangeBytes -Offset "CC453E" -Values "0006"                                                                  }
    if (IsRevert $Redux.Hooks.HyruleGuardsSoftlock)   { ChangeBytes -Offset "E24E7C" -Values "0C00863B24060001"                                                                                                                       }
    if (IsRevert $Redux.Hooks.TalonSkip)              { ChangeBytes -Offset "CC0038" -Values "8FA4001824090041"                                                                                                                       }
    if (IsRevert $Redux.Misc.SkipCutscenes)           { ChangeBytes -Offset "B06C2C" -Values "A2280020A2250021"                                                                                                                       }

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



    # MISC #
    
    if (IsDefault $Redux.Misc.SkipCutscenes -Not) {
        ChangeBytes -Offset "1FE30CE" -Values "014B"; ChangeBytes -Offset "1FE30DE" -Values "014B"; ChangeBytes -Offset "1FE30EE" -Values "014B"; ChangeBytes -Offset "205909E" -Values "003F"; ChangeBytes -Offset "2059094" -Values "80"; ChangeBytes -Offset "DD3538" -Values "34190000"
        $values = "0165000109B600080A2400800A4200400ACE00010ACF00800AE800800B3F00200ED400100ED500200ED600180EDA00080EDC00800EDD00200EE000800EE700300EED00A10EF900010F0A00040F0F00400F2100060EE200010EE300FF0EE800010EE900FB0EEA00070EEB00FF0F08000800A70020"
        if (IsIndex $Redux.Misc.SkipCutscenes -Index 3) {
            $values += "012C00080F1A0004"
        }
        ChangeBytes -Offset $Symbols.INITIAL_SAVE_DATA -Values $values
    }

    if (IsDefault $Redux.Misc.OptionsMenu -Not)     { ChangeBytes -Offset $Symbols.CFG_OPTIONS_MENU        -Values $Redux.Misc.OptionsMenu.SelectedIndex }
    if (IsChecked $Redux.Misc.FastBunnyHood)        { ChangeBytes -Offset $Symbols.FAST_BUNNY_HOOD_ENABLED -Values "01" }
    if (IsChecked $Redux.Misc.BombchuDrops)         { ChangeBytes -Offset $Symbols.BOMBCHUS_IN_LOGIC       -Values "01" }
    if (IsChecked $Redux.Misc.TycoonWallet)         { ChangeBytes -Offset $Symbols.CFG_TYCOON_WALLET       -Values "01" }
    


    # CODE HOOKS FEATURES #
    
    if (IsChecked $Redux.Hooks.BlueFireArrow) { ChangeBytes -Offset "C230C1" -Values "29"; ChangeBytes -Offset "DB38FE" -Values "EF"; ChangeBytes -Offset "C9F036" -Values "10"; ChangeBytes -Offset "DB391B" -Values "50"; ChangeBytes -Offset "DB3927" -Values "5A" }
    


    # BUTTON ACTIVATIONS #

    if (IsChecked $Redux.Misc.HUDToggle)      { ChangeBytes -Offset $Symbols.CFG_HIDE_HUD_ENABLED         -Values "01" }
    if (IsChecked $Redux.Misc.GearUnequip)    { ChangeBytes -Offset $Symbols.CFG_UNEQUIP_GEAR_ENABLED     -Values "01" }
    if (IsChecked $Redux.Misc.ItemsUnequip)   { ChangeBytes -Offset $Symbols.CFG_UNEQUIP_ITEM_ENABLED     -Values "01" }
    if (IsChecked $Redux.Misc.ItemsOnB)       { ChangeBytes -Offset $Symbols.CFG_B_BUTTON_ITEM_ENABLED    -Values "01" }
    if (IsChecked $Redux.Misc.ItemsSwap)      { ChangeBytes -Offset $Symbols.CFG_SWAP_ITEM_ENABLED        -Values "01" }



    # CHEATS #

    if (IsChecked $Redux.Cheats.InventoryEditor)   { ChangeBytes -Offset $Symbols.CFG_INVENTORY_EDITOR_ENABLED -Values "01" }
    if (IsChecked $Redux.Cheats.Health)            { ChangeBytes -Offset $Symbols.CFG_INFINITE_HEALTH          -Values "01" }
    if (IsChecked $Redux.Cheats.Magic)             { ChangeBytes -Offset $Symbols.CFG_INFINITE_MAGIC           -Values "01" }
    if (IsChecked $Redux.Cheats.Ammo)              { ChangeBytes -Offset $Symbols.CFG_INFINITE_AMMO            -Values "01" }
    if (IsChecked $Redux.Cheats.Rupees)            { ChangeBytes -Offset $Symbols.CFG_INFINITE_RUPEES          -Values "01" }



    # AGE RESTRICTIONS #

    if   (IsChecked $Redux.Unlock.KokiriSword)                                                { ChangeBytes -Offset $Symbols.CFG_ALLOW_KOKIRI_SWORD  -Values "01" }
    if   (IsChecked $Redux.Unlock.MasterSword)                                                { ChangeBytes -Offset $Symbols.CFG_ALLOW_MASTER_SWORD  -Values "01" }
    if ( (IsChecked $Redux.Unlock.GiantsKnife) -or (IsChecked $Redux.Hero.PotsChallenge) )    { ChangeBytes -Offset $Symbols.CFG_ALLOW_GIANTS_KNIFE  -Values "01" }
    if   (IsChecked $Redux.Unlock.DekuShield)                                                 { ChangeBytes -Offset $Symbols.CFG_ALLOW_DEKU_SHIELD   -Values "01" }
    if   (IsChecked $Redux.Unlock.MirrorShield)                                               { ChangeBytes -Offset $Symbols.CFG_ALLOW_MIRROR_SHIELD -Values "01" }
    if   (IsChecked $Redux.Unlock.Boots)                                                      { ChangeBytes -Offset $Symbols.CFG_ALLOW_BOOTS         -Values "01" }
    if   (IsChecked $Redux.Unlock.Tunics)                                                     { ChangeBytes -Offset $Symbols.CFG_ALLOW_TUNIC         -Values "01" }



    # RAINBOW COLORS #

    if (IsChecked $Redux.Rainbow.Sword)       { ChangeBytes -offset $Symbols.CFG_RAINBOW_SWORD_INNER_ENABLED         -Values "01 01"                   }
    if (IsChecked $Redux.Rainbow.Boomerang)   { ChangeBytes -offset $Symbols.CFG_RAINBOW_BOOM_TRAIL_INNER_ENABLED    -Values "01 01"                   }
    if (IsChecked $Redux.Rainbow.Bombchu)     { ChangeBytes -offset $Symbols.CFG_RAINBOW_BOMBCHU_TRAIL_INNER_ENABLED -Values "01 01"                   }
    if (IsChecked $Redux.Rainbow.Navi)        { ChangeBytes -offset $Symbols.CFG_RAINBOW_NAVI_IDLE_INNER_ENABLED     -Values "01 01 01 01 01 01 01 01" }



    # BUTTON COLORS #

    if ($Redux.Colors.SetButtons -ne $null) {
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
        } 

        if (IsDefaultColor -Elem $Redux.Colors.SetButtons[2] -Not) { # C Buttons
            ChangeBytes -Offset $Symbols.CFG_C_BUTTON_COLOR -Values ( (Get16Bit $Redux.Colors.SetButtons[2].Color.R) + (Get16Bit $Redux.Colors.SetButtons[2].Color.G) + (Get16Bit $Redux.Colors.SetButtons[2].Color.B) )

            if ($Redux.Colors.Buttons.Text -ne "N64 OoT" -and $Redux.Colors.Buttons.Text -ne "N64 MM" -and $Redux.Colors.Buttons.Text -ne "GC OoT" -and $Redux.Colors.Buttons.Text -ne "GC MM") {
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
                ChangeBytes -Offset $Symbols.CFG_C_NOTE_COLOR -Values ( (Get16Bit $Redux.Colors.SetButtons[2].Color.R) + (Get16Bit $Redux.Colors.SetButtons[2].Color.G) + (Get16Bit $Redux.Colors.SetButtons[2].Color.B) )
            }
        }

        if (IsDefaultColor -Elem $Redux.Colors.SetButtons[3] -Not) { # Start Button
            ChangeBytes -Offset "AE9EC6" -Values @($Redux.Colors.SetButtons[3].Color.R, $Redux.Colors.SetButtons[3].Color.G) # Red + Green
            ChangeBytes -Offset "AE9ED8" -Values @(53, 238, $Redux.Colors.SetButtons[3].Color.B) # Blue
        }
    }
    


    # TRAIL COLORS #

    if ($Redux.Colors.SetBoomerang -ne $null) {
        if (IsDefaultColor -Elem $Redux.Colors.SetBoomerang[0] -Not)   { ChangeBytes -Offset $Symbols.CFG_BOOM_TRAIL_INNER_COLOR -Values @($Redux.Colors.SetBoomerang[0].Color.R, $Redux.Colors.SetBoomerang[0].Color.G, $Redux.Colors.SetBoomerang[0].Color.B) }
        if (IsDefaultColor -Elem $Redux.Colors.SetBoomerang[1] -Not)   { ChangeBytes -Offset $Symbols.CFG_BOOM_TRAIL_OUTER_COLOR -Values @($Redux.Colors.SetBoomerang[1].Color.R, $Redux.Colors.SetBoomerang[1].Color.G, $Redux.Colors.SetBoomerang[1].Color.B) }
    }

    if ($Redux.Colors.SetBombchu -ne $null) {
        if (IsDefaultColor -Elem $Redux.Colors.SetBombchu[0] -Not)     { ChangeBytes -Offset $Symbols.CFG_BOMBCHU_TRAIL_INNER_COLOR -Values @($Redux.Colors.SetBombchu[0].Color.R, $Redux.Colors.SetBombchu[0].Color.G, $Redux.Colors.SetBombchu[0].Color.B) }
        if (IsDefaultColor -Elem $Redux.Colors.SetBombchu[1] -Not)     { ChangeBytes -Offset $Symbols.CFG_BOMBCHU_TRAIL_OUTER_COLOR -Values @($Redux.Colors.SetBombchu[1].Color.R, $Redux.Colors.SetBombchu[1].Color.G, $Redux.Colors.SetBombchu[1].Color.B) }
    }



    # HUD COLORS #

    if ($Redux.Colors.SetHUDStats -ne $null) {
        if (IsDefaultColor -Elem $Redux.Colors.SetHUDStats[0] -Not)    { $values = (Get16Bit $Redux.Colors.SetHUDStats[0].Color.R) + (Get16Bit $Redux.Colors.SetHUDStats[0].Color.G) + (Get16Bit $Redux.Colors.SetHUDStats[0].Color.B); ChangeBytes -Offset $Symbols.CFG_HEART_COLOR -Values $values } # Hearts
        if (IsDefaultColor -Elem $Redux.Colors.SetHUDStats[1] -Not)    { $values = (Get16Bit $Redux.Colors.SetHUDStats[1].Color.R) + (Get16Bit $Redux.Colors.SetHUDStats[1].Color.G) + (Get16Bit $Redux.Colors.SetHUDStats[1].Color.B); ChangeBytes -Offset $Symbols.CFG_MAGIC_COLOR -Values $values } # Magic
    }

    if (IsChecked $Redux.Graphics.GCScheme) {
        ChangeBytes -Offset $Symbols.CFG_TEXT_CURSOR_COLOR -Values "00 00 00 C8 00 50" # Text Cursor
        ChangeBytes -Offset $Symbols.CFG_SHOP_CURSOR_COLOR -Values "00 00 00 FF 00 50" # Shop Cursor
    }
    elseif ($Redux.Colors.SetText -ne $null) {
        if (IsDefaultColor -Elem $Redux.Colors.SetText[0] -Not)    { $values = (Get16Bit $Redux.Colors.SetText[0].Color.R) + (Get16Bit $Redux.Colors.SetText[0].Color.G) + (Get16Bit $Redux.Colors.SetText[0].Color.B); ChangeBytes -Offset $Symbols.CFG_TEXT_CURSOR_COLOR -Values $values } # Text Cursor
        if (IsDefaultColor -Elem $Redux.Colors.SetText[1] -Not)    { $values = (Get16Bit $Redux.Colors.SetText[1].Color.R) + (Get16Bit $Redux.Colors.SetText[1].Color.G) + (Get16Bit $Redux.Colors.SetText[1].Color.B); ChangeBytes -Offset $Symbols.CFG_SHOP_CURSOR_COLOR -Values $values } # Shop Cursor
    }
    
}


#==============================================================================================================================================================================================
<#function ByteSceneOptions() {
    
    LoadScene  -Scene  "Hyrule Field"
    LoadMap    -Map    0
    LoadHeader -Header 0

}#>



#==============================================================================================================================================================================================
function CheckLanguageOptions() {
    
    if     ( (IsChecked  $Redux.Text.Vanilla -Not)   -or (IsChecked  $Redux.Text.Speed1x  -Not) -or (IsChecked  $Redux.Graphics.GCScheme) )                                                   { return $True }
    elseif ( (IsLanguage $Redux.Unlock.Tunics)       -or (IsLanguage $Redux.Equipment.HerosBow) -or (IsLanguage $Redux.Capacity.EnableAmmo) -or (IsLanguage $Redux.Capacity.EnableWallet) )   { return $True }
    elseif ( (IsChecked  $Redux.Text.FemalePronouns) -or (IsChecked  $Redux.Text.TypoFixes)     -or (IsChecked  $Redux.Text.GoldSkulltula)  -or (IsChecked  $Redux.Text.Instant) )            { return $True }
    elseif ( (IsChecked -Elem $Redux.Text.LinkScript)      -and $Redux.Text.LinkName.Text.Count -gt 0)                                                                                        { return $True }
    elseif ( (IsDefault -Elem $Redux.Text.NaviScript -Not) -and $Redux.Text.NaviName.Text.Count -gt 0 -and (IsDefault $Redux.Text.NaviName -Not) )                                            { return $True }

    elseif ($LanguagePatch.code -eq "en") {
        if     ( (IsDefault $Redux.Equipment.KokiriSword  -Not) -or (IsDefault $Redux.Equipment.MasterSword   -Not) )                        { return $True }
        elseif ( (IsDefault $Redux.Equipment.GiantsKnife  -Not) -or (IsDefault $Redux.Equipment.BiggoronSword -Not) )                        { return $True }
        elseif ( (IsDefault $Redux.Equipment.DekuShield   -Not) -and $ChildModel.deku_shield -ne 0)                                          { return $True }
        elseif ( (IsDefault $Redux.Equipment.HylianShield -Not) -and $ChildModel.hylian_shield -ne 0 -and $AdultModel.hylian_shield -ne 0)   { return $True }
        elseif (IsIndex -Elem $Redux.Text.NaviScript -Index 3)                                                                               { return $True }
    }

    return $False

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
    
    if ($GamePatch.vanilla -le 3) {
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

        if (IsChecked $Redux.Graphics.GCScheme) {
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
    }
    elseif (IsChecked $Redux.Text.Speed2x) { ChangeBytes -Offset "B5006F" -Values "02" }

    if ( (IsChecked $Redux.Text.LinkScript) -and $Redux.Text.LinkName.Text.Count -gt 0) {
        SetMessage -ID "00D7" -Text "0F" -Replace $Redux.Text.LinkName.text;
        SetMessage -ID "00D8";      SetMessage -ID "00D9";      SetMessage -ID "00DB";      SetMessage -ID "00E2"; SetMessage -ID "00EA";      SetMessage -ID "0101"; SetMessage -ID "0102";      SetMessage -ID "011F";      SetMessage -ID "012F";      SetMessage -ID "0131"; SetMessage -ID "0132"
        SetMessage -ID "0133";      SetMessage -ID "015F";      SetMessage -ID "0162";      SetMessage -ID "0165"; SetMessage -ID "0166";      SetMessage -ID "0168"; SetMessage -ID "016A";      SetMessage -ID "016B" -All; SetMessage -ID "016C" -All; SetMessage -ID "018D"; SetMessage -ID "0198"
        SetMessage -ID "01A3";      SetMessage -ID "01AB";      SetMessage -ID "0218";      SetMessage -ID "022A"; SetMessage -ID "031F";      SetMessage -ID "0626"; SetMessage -ID "1001";      SetMessage -ID "1001";      SetMessage -ID "1002";      SetMessage -ID "1005"; SetMessage -ID "100F"
        SetMessage -ID "1015" -All; SetMessage -ID "1017" -All; SetMessage -ID "1024";      SetMessage -ID "1026"; SetMessage -ID "102A" -All; SetMessage -ID "102B"; SetMessage -ID "1045";      SetMessage -ID "1047";      SetMessage -ID "1048";      SetMessage -ID "104B"; SetMessage -ID "1058" -All
        SetMessage -ID "105B";      SetMessage -ID "105C";      SetMessage -ID "1066";      SetMessage -ID "106D"; SetMessage -ID "1070";      SetMessage -ID "1075"; SetMessage -ID "107A";      SetMessage -ID "107C";      SetMessage -ID "1093";      SetMessage -ID "1094"; SetMessage -ID "1095" -All
        SetMessage -ID "10A8";      SetMessage -ID "10C0";      SetMessage -ID "2000" -All; SetMessage -ID "2005"; SetMessage -ID "2008";      SetMessage -ID "2009"; SetMessage -ID "2010";      SetMessage -ID "2018";      SetMessage -ID "2064";      SetMessage -ID "2068"; SetMessage -ID "206C"
        SetMessage -ID "206D";      SetMessage -ID "206E";      SetMessage -ID "206F";      SetMessage -ID "2074"; SetMessage -ID "2075";      SetMessage -ID "207B"; SetMessage -ID "208B";      SetMessage -ID "3031";      SetMessage -ID "3032" -All; SetMessage -ID "3036"; SetMessage -ID "3037"
        SetMessage -ID "3039" -All; SetMessage -ID "303B";      SetMessage -ID "303F";      SetMessage -ID "3040"; SetMessage -ID "3041";      SetMessage -ID "3042"; SetMessage -ID "3043";      SetMessage -ID "3062";      SetMessage -ID "4002";      SetMessage -ID "4003"; SetMessage -ID "4017"
        SetMessage -ID "4024" -All; SetMessage -ID "402B";      SetMessage -ID "402D";      SetMessage -ID "402E"; SetMessage -ID "4031";      SetMessage -ID "4036"; SetMessage -ID "403E" -All; SetMessage -ID "403F";      SetMessage -ID "4041";      SetMessage -ID "4057"; SetMessage -ID "4059"
        SetMessage -ID "4089";      SetMessage -ID "40B1";      SetMessage -ID "501B";      SetMessage -ID "501C"; SetMessage -ID "501D";      SetMessage -ID "5024"; SetMessage -ID "5031";      SetMessage -ID "5071";      SetMessage -ID "6023";      SetMessage -ID "6038"; SetMessage -ID "603A"
        SetMessage -ID "603D";      SetMessage -ID "6079" -All; SetMessage -ID "704E" -All; SetMessage -ID "704F"; SetMessage -ID "7050";      SetMessage -ID "7054"; SetMessage -ID "705A";      SetMessage -ID "705B";      SetMessage -ID "705E";      SetMessage -ID "7067"; SetMessage -ID "706D"
        SetMessage -ID "706F";      SetMessage -ID "7070";      SetMessage -ID "7075";      SetMessage -ID "707A"; SetMessage -ID "7084";      SetMessage -ID "7093"; SetMessage -ID "7095";      SetMessage -ID "70CD" -All; SetMessage -ID "70CF";      SetMessage -ID "70D1"; SetMessage -ID "70D4"
        SetMessage -ID "70D7";      SetMessage -ID "70E0";      SetMessage -ID "70E6";      SetMessage -ID "70F4"; SetMessage -ID "71A8";      SetMessage -ID "71AA"; SetMessage -ID "71AB";      SetMessage -ID "71AC"
        SetMessage -ID "70DC" -Text "0F" -Replace $Redux.Text.LinkName.Text.ToUpper()
    }

    if ( (IsDefault $Redux.Text.NaviScript -Not) -and (IsDefault $Redux.Text.NaviName -Not) -and $Redux.Text.NaviName.Text.Count -gt 0) {
        if ($Redux.Text.NaviScript -ne $null) {
            SetMessage -ID "1000" -Text "4E617669" -Replace $Redux.Text.NaviName.text -NoParse; SetMessage -ID "1015"; SetMessage -ID "1017"; SetMessage -ID "1017"; SetMessage -ID "1017"; SetMessage -ID "103F"
            SetMessage -ID "103F";                                                              SetMessage -ID "1099"; SetMessage -ID "1099"; SetMessage -ID "109A"; SetMessage -ID "109A"; SetMessage -ID "109A"
        }
        if (TestFile ($GameFiles.textures + "\Action Prompts\Navi\" + $Redux.Text.NaviName.Text + ".cup") ) {
            if (IsChecked $Redux.Text.NaviPrompt) { PatchBytes  -Offset "8E3A80" -Texture -Patch ("Action Prompts\Navi\" + $Redux.Text.NaviName.text + ".prompt") }
            PatchBytes -Offset "1A3EFC0" -Texture -Patch ("Action Prompts\Navi\" + $Redux.Text.NaviName.text + ".cup")
        }
        else {
            if (IsChecked $Redux.Text.NaviPrompt) { PatchBytes  -Offset "8E3A80" -Texture -Patch "Action Prompts\Navi\Info.prompt" } 
            PatchBytes -Offset "1A3EFC0" -Texture -Patch "Action Prompts\Navi\Info.cup"
        }
    }
    if ( (IsIndex -Elem $Redux.Text.NaviScript -Index 3) -and $LanguagePatch.code -eq "en") { SetMessage -ID "1017" -Text "her" -Replace "his"; SetMessage -ID "103F" -Text "her" -Replace "him" }

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

   if (IsChecked $Redux.Text.EasterEggs) {
        if (TestFile ($GameFiles.Base + "\Easter Eggs.json")) {
            $json = SetJSONFile ($GameFiles.Base + "\Easter Eggs.json")
            foreach ($entry in $json) { SetMessage -ID $entry.box -Replace $entry.message }
        }
   }

    if (IsLanguage $Redux.Capacity.EnableAmmo) {
        if ($GamePatch.settings -eq "Master of Time")   { $arrow3 = "99" }   else                                                { $arrow3 = "50" }
        if ($GamePatch.settings -eq "Gold Quest")       { $bomb1  = "10" }   elseif ($GamePatch.settings -eq "Master of Time")   { $bomb1  = "15" }   else   { $bomb1 = "20" }
        if ($GamePatch.settings -eq "Gold Quest")       { $bomb3  = "50" }   elseif ($GamePatch.settings -eq "Master of Time")   { $bomb3  = "99" }   else   { $bomb3 = "40" }
        if ($GamePatch.settings -eq "Master of Time")   { $nut3   = "99" }   else                                                { $nut3   = "40" }

        SetMessage -ID "0056" -ASCII -Text "40"   -Replace $Redux.Capacity.Quiver2.text;   SetMessage -ID "0057" -ASCII -Text $arrow3 -Replace $Redux.Capacity.Quiver3.text
        SetMessage -ID "0058" -ASCII -Text $bomb1 -Replace $Redux.Capacity.BombBag1.text;  SetMessage -ID "0059" -ASCII -Text "30"    -Replace $Redux.Capacity.BombBag2.text;    SetMessage -ID "005A" -Text $bomb3 -Replace $Redux.Capacity.BombBag3.text
        SetMessage -ID "00A7" -ASCII -Text "30"   -Replace $Redux.Capacity.DekuNuts2.text; SetMessage -ID "00A8" -ASCII -Text $nut3   -Replace $Redux.Capacity.DekuNuts3.text

        if ($GamePatch.settings -ne "Master of Time") {
            SetMessage -ID "0007" -ASCII -Text "40" -Replace $Redux.Capacity.BulletBag2.text;  SetMessage -ID "006C" -ASCII -Text "50" -Replace $Redux.Capacity.BulletBag3.text
            SetMessage -ID "0037" -ASCII -Text "10" -Replace $Redux.Capacity.DekuSticks1.text; SetMessage -ID "0090" -ASCII -Text "20" -Replace $Redux.Capacity.DekuSticks2.text; SetMessage -ID "0091" -Text "30" -Replace $Redux.Capacity.DekuSticks3.text
        }
    }

    if (IsLanguage $Redux.Capacity.EnableWallet) {
        if ($GamePatch.settings -eq "Master of Time")   { $wallet2 = "250" } else { $wallet2 = "200" }
        if ($GamePatch.vanilla  -ne 1)                  { $wallet3 = "999" } else { $wallet3 = "500" }
        SetMessage -ID "005E" -ASCII -Text $wallet2 -Replace $Redux.Capacity.Wallet2.Text -NoParse; SetMessage -ID "005F" -ASCII -Text $wallet3 -Replace $Redux.Capacity.Wallet3.Text -NoParse
    }

    if (IsLanguage $Redux.Equipment.HerosBow) { SetMessage -ID "0031" -Text "Fairy Bow" -Replace "Hero's Bow" }

    if ( (IsDefault $Redux.Equipment.KokiriSword -Not) -and $LanguagePatch.code -eq "en") {
        $replace = $null
        if     (IsText -Elem $Redux.Equipment.KokiriSword -Compare "Kokiri Sword")   { $replace = "Kokiri Sword" }
        elseif (IsText -Elem $Redux.Equipment.KokiriSword -Compare "Knife")          { $replace = "Knife"        }
        elseif (IsText -Elem $Redux.Equipment.KokiriSword -Compare "Razor Sword")    { $replace = "Razor Sword"  }
        if ($replace -ne $null) { SetMessage -ID "00A4" -Text "Kokiri Sword" -Replace $replace -NoParse; SetMessage -ID "10D2" }
    }

    if ( (IsDefault $Redux.Equipment.MasterSword -Not) -and $LanguagePatch.code -eq "en") {
        $replace = $null
        if     (IsText -Elem $Redux.Equipment.MasterSword -Compare "Master Sword")          { $replace = "Master Sword"        }
        elseif (IsText -Elem $Redux.Equipment.MasterSword -Compare "Gilded Sword")          { $replace = "Gilded Sword"        }
        elseif (IsText -Elem $Redux.Equipment.MasterSword -Compare "Great Fairy's Sword")   { $replace = "Great Fairy's Sword" }
        elseif (IsText -Elem $Redux.Equipment.MasterSword -Compare "Double Helix Sword")    { $replace = "Double Helix Sword"  }
        elseif (IsText -Elem $Redux.Equipment.MasterSword -Compare "Razor Longsword")       { $replace = "Razor Longsword"     }
        if ($replace -ne $null) { SetMessage -ID "600C" -Text "Master Sword" -Replace $replace -NoParse; SetMessage -ID "704F"; SetMessage -ID "7051"; SetMessage -ID "7059"; SetMessage -ID "706D"; SetMessage -ID "7075"; SetMessage -ID "7081"; SetMessage -ID "7088"; SetMessage -ID "7091"; SetMessage -ID "70E8" }
    }

    if ( (IsDefault $Redux.Equipment.GiantsKnife -Not) -and $LanguagePatch.code -eq "en") {
        $replace = $null
        if     (IsText -Elem $Redux.Equipment.GiantsKnife -Compare "Giant's Knife")         { $replace = "Giant's Knife"       }
        elseif (IsText -Elem $Redux.Equipment.GiantsKnife -Compare "Biggoron Sword")        { $replace = "Biggoron Sword"      }
        elseif (IsText -Elem $Redux.Equipment.GiantsKnife -Compare "Gilded Sword")          { $replace = "Gilded Sword"        }
        elseif (IsText -Elem $Redux.Equipment.GiantsKnife -Compare "Great Fairy's Sword")   { $replace = "Great Fairy's Sword" }
        elseif (IsText -Elem $Redux.Equipment.GiantsKnife -Compare "Double Helix Sword")    { $replace = "Double Helix Sword"  }
        elseif (IsText -Elem $Redux.Equipment.GiantsKnife -Compare "Razor Longsword")       { $replace = "Razor Longsword"     }
        if ($replace -ne $null) { SetMessage -ID "000B" -Text "Giant's Knife" -Replace $replace -NoParse; SetMessage -ID "004B" }
    }

    if ( (IsDefault $Redux.Equipment.BiggoronSword -Not) -and $LanguagePatch.code -eq "en") {
        $replace = $null
        if     (IsText -Elem $Redux.Equipment.BiggoronSword -Compare "Giant's Knife")         { $replace = "Giant's Knife"       }
        elseif (IsText -Elem $Redux.Equipment.BiggoronSword -Compare "Biggoron Sword")        { $replace = "Biggoron Sword"      }
        elseif (IsText -Elem $Redux.Equipment.BiggoronSword -Compare "Gilded Sword")          { $replace = "Gilded Sword"        }
        elseif (IsText -Elem $Redux.Equipment.BiggoronSword -Compare "Great Fairy's Sword")   { $replace = "Great Fairy's Sword" }
        elseif (IsLang -Elem $Redux.Equipment.BiggoronSword -Compare "Double Helix Sword")    { $replace = "Double Helix Sword"  }
        elseif (IsText -Elem $Redux.Equipment.BiggoronSword -Compare "Razor Longsword")       { $replace = "Razor Longsword"     }
        if ($replace -ne $null) { SetMessage -ID "000A" -Text "Biggoron's Sword" -Replace $replace -NoParse; SetMessage -ID "000B"; SetMessage -ID "000C"; SetMessage -ID "0404" }
    }

    if ( (IsDefault $Redux.Equipment.DekuShield -Not) -and $ChildModel.deku_shield -ne 0 -and $LanguagePatch.code -eq "en") {
        $replace = $null
        if     (IsText -Elem $Redux.Equipment.DekuShield -Compare "Deku Shield")          { $replace = "Deku Shield"   }
        elseif (IsText -Elem $Redux.Equipment.DekuShield -Compare "Wooden Shield")        { $replace = "Wooden Shield" }
        elseif (IsText -Elem $Redux.Equipment.DekuShield -Compare "Dawn & Dusk Shield")   { $replace = "Wooden Shield" }
        elseif (IsText -Elem $Redux.Equipment.DekuShield -Compare "Iron Shield")          { $replace = "Iron Shield"   }
        if ($replace -ne $null) { SetMessage -ID "004C" -Text "Deku Shield" -Replace $replace -NoParse; SetMessage -ID "0089"; SetMessage -ID "009F"; SetMessage -ID "0611"; SetMessage -ID "103D"-Last; SetMessage -ID "1052"; SetMessage -ID "10CB"; SetMessage -ID "10D2" }
    }

    if ( (IsDefault $Redux.Equipment.HylianShield -Not) -and $ChildModel.hylian_shield -ne 0 -and $AdultModel.hylian_shield -ne 0 -and $LanguagePatch.code -eq "en") {
        $replace = $null
        if     (IsText -Elem $Redux.Equipment.HylianShield -Compare "Hylian Shield")   { $replace = "Hylian Shield" }
        elseif (IsText -Elem $Redux.Equipment.HylianShield -Compare "Hero's Shield")   { $replace = "Hero's Shield" }
        elseif (IsText -Elem $Redux.Equipment.HylianShield -Compare "Red Shield")      { $replace = "Red Shield"    }
        elseif (IsText -Elem $Redux.Equipment.HylianShield -Compare "Metal Shield")    { $replace = "Metal Shield"  }
        if ($replace -ne $null) { SetMessage -ID "004D" -Text "Hylian Shield" -Replace $replace -NoParse; SetMessage -ID "0092"; SetMessage -ID "009C"; SetMessage -ID "00A9"; SetMessage -ID "7013"; SetMessage -ID "7121" }
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
    
    EnableElem -Elem @($Redux.Unlock.DekuSticks, $Redux.UI.ButtonPositions) -Active $Patches.Redux.Checked

    if ($Patches.Redux.Checked) {
        EnableElem -Elem $Redux.Colors.RupeesVanilla -Active (!$Redux.Hooks.RupeeIconColors.Checked)
        EnableForm -Form $Redux.Box.TextColors       -Enable (!$Redux.Graphics.GCScheme.Checked)
    }

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    if ($GamePatch.vanilla -eq 1)   { CreateOptionsDialog -Columns 6 -Height 600 -Tabs @("Main", "Graphics", "Audio", "Difficulty", "Scenes", "Colors", "Equipment", "Capacity", "Animations") }
    else                            { CreateOptionsDialog -Columns 6 -Height 600 -Tabs @("Main", "Graphics", "Audio", "Difficulty",           "Colors", "Equipment", "Capacity", "Animations") }

}



#==============================================================================================================================================================================================
function CreateTabMain() {
    
    # PRESETS #

    CreateReduxGroup -Tag  "Presets" -All -Text "Presets" -Rows 2
    
    $Reset        = CreateReduxButton  -All -Text "Reset Options"      -Row 1 -Column 1

    $QualityOfLife = CreateReduxButton -All -Text "Quality of Life"    -Row 1 -Column 4
    $OptimalRedux  = CreateReduxButton -All -Text "Optimal Redux"      -Row 1 -Column 5
    $HeroMode      = CreateReduxButton -All -Text "Hero Mode"          -Row 1 -Column 6

    $VanillaModels = CreateReduxButton -All -Text "Original Link"      -Row 2 -Column 4
    $MajoraModels  = CreateReduxButton -All -Text "Majora's Mask Link" -Row 2 -Column 5
    $FemaleModels  = CreateReduxButton -All -Text "Female Link"        -Row 2 -Column 6

    $Reset.Add_Click( { ResetGame } )

    $QualityOfLife.Add_Click( {
        if ($Redux.Gameplay.FasterBlockPushing -ne $null) { $Redux.Gameplay.FasterBlockPushing.SelectedIndex = 2 }
        BoxCheck $Redux.Gameplay.RemoveNaviTimer
        BoxCheck $Redux.Gameplay.ResumeLastArea
        BoxCheck $Redux.Gameplay.InstantClaimCheck
        BoxCheck $Redux.Gameplay.ReturnChild
        BoxCheck $Redux.Gameplay.AllowWarpSongs
        BoxCheck $Redux.Gameplay.AllowFaroreWind
        BoxCheck $Redux.Gameplay.AllowOcarina
        BoxCheck $Redux.Gameplay.RutoNeverDisappears
        BoxCheck $Redux.Gameplay.Medallions
        BoxCheck $Redux.Gameplay.RemoveNaviPrompts
        BoxCheck $Redux.Restore.RupeeColors
        BoxCheck $Redux.Restore.CowNoseRing
        BoxCheck $Redux.Restore.CenterTextboxCursor

        BoxCheck $Redux.Fixes.PauseScreenDelay
        BoxCheck $Redux.Fixes.PauseScreenCrash
        BoxCheck $Redux.Fixes.WhiteBubbleCrash
        BoxCheck $Redux.Fixes.PoacherSaw
        BoxCheck $Redux.Fixes.FortressMinimap
        BoxCheck $Redux.Fixes.AlwaysMoveKingZora
        BoxCheck $Redux.Fixes.DeathMountainOwl
        BoxCheck $Redux.Fixes.RemoveFishingPiracy
        BoxCheck $Redux.Fixes.Boomerang

        if ($Redux.Graphics.Widescreen -eq $null) { BoxCheck $Redux.Graphics.WidescreenAlt } else { BoxCheck $Redux.Graphics.Widescreen }
        BoxCheck $Redux.Graphics.ExtendedDraw
        BoxCheck $Redux.Graphics.ForceHiresModel
        BoxCheck $Redux.Graphics.HideDungeonIcon

        if ($Redux.Text.Speed2x       -ne $null)   { if ($Redux.Text.Speed2x.Enabled)         { BoxCheck $Redux.Text.Speed2x       } }
        if ($Redux.Text.Restore       -ne $null)   { if ($Redux.Text.Restore.Enabled)         { BoxCheck $Redux.Text.Restore       } }
        if ($Redux.Text.TypoFixes     -ne $null)   { if ($Redux.Text.TypoFixes.Enabled)       { BoxCheck $Redux.Text.TypoFixes     } }
        if ($Redux.Text.GoldSkulltula -ne $null)   { if ($Redux.Text.GoldSkulltula.Enabled)   { BoxCheck $Redux.Text.GoldSkulltula } }
        if ($Redux.Text.EasterEggs    -ne $null)   { if ($Redux.Text.EasterEggs.Enabled)      { BoxCheck $Redux.Text.EasterEggs    } }

        if ($Redux.Scenes.MuteOwls           -ne $null)   { if ($Redux.Scenes.MuteOwls.Enabled)             { BoxCheck $Redux.Scenes.MuteOwls           } }
        if ($Redux.Scenes.Graves             -ne $null)   { if ($Redux.Scenes.Graves.Enabled)               { BoxCheck $Redux.Scenes.Graves             } }
        if ($Redux.Scenes.CorrectTimeDoor    -ne $null)   { if ($Redux.Scenes.CorrectTimeDoor.Enabled)      { BoxCheck $Redux.Scenes.CorrectTimeDoor    } }
        if ($Redux.Scenes.ChildColossusFairy -ne $null)   { if ($Redux.Scenes.ChildColossusFairy.Enabled)   { BoxCheck $Redux.Scenes.ChildColossusFairy } }
        if ($Redux.Scenes.CraterFairy        -ne $null)   { if ($Redux.Scenes.CraterFairy.Enabled)          { BoxCheck $Redux.Scenes.CraterFairy        } }
    } )

    $OptimalRedux.Add_Click( {
        BoxCheck $Redux.Misc.FastBunnyHood
        BoxCheck $Redux.Misc.BombchuDrops
        BoxCheck $Redux.Hooks.FishLarger
        BoxCheck $Redux.Hooks.FishBites
        BoxCheck $Redux.Hooks.RupeeIconColors
        BoxCheck $Redux.Hooks.EmptyBombFix
        BoxCheck $Redux.Hooks.ShowFileSelectIcons
        BoxCheck $Redux.Hooks.StoneOfAgony
        BoxCheck $Redux.Hooks.BiggoronFix
        BoxCheck $Redux.Hooks.DampeFix
        BoxCheck $Redux.Hooks.HyruleGuardsSoftlock
    } )

    $HeroMode.Add_Click( {
        $Redux.Hero.MonsterHP.SelectedIndex  = 5
        $Redux.Hero.MiniBossHp.SelectedIndex = 5
        $Redux.Hero.BossHP.SelectedIndex     = 5
        $Redux.Hero.Damage.SelectedIndex     = 2
        $Redux.Hero.ItemDrops.Text           = "No Hearts"
        
        BoxCheck $Redux.Hero.GraveyardKeese
        BoxCheck $Redux.Hero.LostWoodsOctorok
        BoxCheck $Redux.Hero.HarderChildBosses
        BoxCheck $Redux.Hero.NoBottledFairy
        BoxCheck $Redux.Hero.HarderStalfos
        BoxCheck $Redux.Hero.HarderWolfos
        BoxCheck $Redux.Hero.AggressiveDarkLink

        BoxCheck $Redux.MQ.EnableMQ
        BoxCheck $Redux.MQ.MasterQuestLogo
    } )

    $VanillaModels.Enabled = (TestFile ($GameFiles.models + "\Child\Original.png"))          -and (TestFile ($GameFiles.models + "\Adult\Original.png"))
    $MajoraModels.Enabled  = (TestFile ($GameFiles.models + "\Child\Majora's Mask.ppf"))     -and (TestFile ($GameFiles.models + "\Adult\Majora's Mask.ppf"))
    $FemaleModels.Enabled  = (TestFile ($GameFiles.models + "\Child\Hatsune Miku Link.ppf")) -and (TestFile ($GameFiles.models + "\Adult\Hatsune Miku Link.ppf"))

    $VanillaModels.Add_Click( { $Redux.Graphics.ChildModels.SelectedIndex = 0;          $Redux.Graphics.AdultModels.SelectedIndex = 0         ; BoxUncheck $Redux.Text.FemalePronouns; $Redux.Sounds.ChildVoices.SelectedIndex = 0; $Redux.Sounds.AdultVoices.SelectedIndex = 0 } )
    $MajoraModels.Add_Click(  { $Redux.Graphics.ChildModels.Text = "Majora's Mask";     $Redux.Graphics.AdultModels.Text = "Majora's Mask"    ; BoxUncheck $Redux.Text.FemalePronouns; $Redux.Sounds.ChildVoices.Text = "Amara";    $Redux.Sounds.AdultVoices.Text = "Amara" } )
    $FemaleModels.Add_Click(  { $Redux.Graphics.ChildModels.Text = "Hatsune Miku Link"; $Redux.Graphics.AdultModels.Text = "Hatsune Miku Link"; BoxCheck   $Redux.Text.FemalePronouns; $Redux.Sounds.ChildVoices.Text = "Amara";    $Redux.Sounds.AdultVoices.Text = "Amara" } )



    # QUALITY OF LIFE #
    
    CreateReduxGroup    -Tag  "Gameplay"            -All                                           -Text "Quality of Life" 
    CreateReduxComboBox -Name "FasterBlockPushing"  -All -Exclude "Gold" -Default 3                -Text "Faster Block Pushing"   -Info "All blocks are pushed faster" -Items @("Disabled", "Exclude Time-Based Puzzles", "Fully Enabled")                                                                            -Credits "GhostlyDark (Ported from Redux)"
    CreateReduxComboBox -Name "FasterBlockPushing"  -All -Exclude "Gold" -Default 3                -Text "Faster Block Pushing"   -Info "All blocks are pushed faster" -Items @("Disabled", "Exclude Time-Based Puzzles", "Fully Enabled")                                                                            -Credits "GhostlyDark (Ported from Redux)"
    CreateReduxCheckBox -Name "NoKillFlash"         -All                                           -Text "No Kill Flash"          -Info "Disable the flash effect when killing certain enemies such as the Guay or Skullwalltula"                                                                                     -Credits "Chez Cousteau"
    CreateReduxCheckBox -Name "RemoveNaviTimer"     -All                                           -Text "Remove Navi Timer"      -Info "Navi will no longer pop up with text messages during gameplay`nDoes not apply to location-triggered messages"                                                                -Credits "Admentus"
    CreateReduxCheckBox -Name "ResumeLastArea"      -All -Exclude "Dawn"                           -Text "Resume From Last Area"  -Info "Resume playing from the area you last saved in" -Warning "Don't save in Grottos"                                                                                             -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxCheckBox -Name "InstantClaimCheck"   -Base 4                                        -Text "Instant Claim Check"    -Info "Remove the check for waiting until the Biggoron Sword can be claimed through the Claim Check"                                                                                -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "ReturnChild"         -Base 4                                        -Text "Can Always Return"      -Info "You can always go back to being a child again before clearing the boss of the Forest Temple`nOut of the way Sheik!"                                                          -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "AllowWarpSongs"      -Base 4                                        -Text "Allow Warp Songs"       -Info "Allow warp songs in Gerudo Training Ground and Ganon's Castle"                                                                                                               -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "AllowFaroreWind"     -Base 4                                        -Text "Allow Farore's Wind"    -Info "Allow Farore's Wind in Gerudo Training Ground and Ganon's Castle"                                                                                                            -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "AllowOcarina"        -Base 4                                        -Text "Allow Ocarina"          -Info "Allow playing the Ocarina in Granny's Potion Shop, Bombchu Bowling Alley and Archery Ranges"                                                                                 -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "FasterGoronTunic"    -Base 4                                        -Text "Faster Goron Tunic"     -Info "You only need to select a single dialogue option instead of both for Link the Goron to obtain the Goron Tunic"                                                               -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "RutoNeverDisappears" -Base 4                                        -Text "Ruto Never Disappears"  -Info "Ruto never disappears in Jabu Jabu's Belly and will remain in place when leaving the room"                                                                                   -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "Medallions"          -Base 4                                        -Text "Require All Medallions" -Info "All six medallions are required for the Rainbow Bridge to appear before Ganon's Castle`nThe vanilla requirements were the Shadow and Spirit Medallions and the Light Arrows" -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "OpenBombchuShop"     -Base 5                                        -Text "Open Bombchu Shop"      -Info "The Bombchu Shop is open right away without the need to defeat King Dodongo"                                                                                                 -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "RemoveNaviPrompts"                                                  -Text "Remove Navi Prompts"    -Info "Navi will no longer interrupt you with tutorial text boxes in dungeons"                                                                                                      -Credits "Ported from Redux"
    


    # GAMEPLAY #

    CreateReduxGroup    -Tag  "Gameplay"               -All               -Text "Gameplay Changes" 
    CreateReduxComboBox -Name "SpawnChild"             -Base 4 -Default 1 -Text "Child Starting Location"  -Items ("Link's House", "Temple of Time", "Hyrule Field", "Kakariko Village", "Inside the Deku Tree", "Dodongo's Cavern", "Inside Jabu-Jabu's Belly", "Forest Temple", "Fire Temple", "Water Temple", "Shadow Temple", "Spirit Temple", "Ice Cavern", "Bottom of the Well", "Thieves' Hideout", "Gerudo's Training Ground", "Inside Ganon's Castle", "Ganon's Tower") -Credits "Admentus & GhostlyDark"
    CreateReduxComboBox -Name "SpawnAdult"             -Base 4 -Default 2 -Text "Adult Starting Location"  -Items ("Link's House", "Temple of Time", "Hyrule Field", "Kakariko Village", "Inside the Deku Tree", "Dodongo's Cavern", "Inside Jabu-Jabu's Belly", "Forest Temple", "Fire Temple", "Water Temple", "Shadow Temple", "Spirit Temple", "Ice Cavern", "Bottom of the Well", "Thieves' Hideout", "Gerudo's Training Ground", "Inside Ganon's Castle", "Ganon's Tower") -Credits "Admentus & GhostlyDark"
    CreateReduxCheckBox -Name "NoMagicArrowCooldown"   -Adult             -Text "No Magic Arrow Cooldown"  -Info "Be able to shoot magic arrows without a delay between each shot" -Warning "Prone to crashes upon switching arrow types (Redux feature) to quickly"              -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "ManualJump"             -All               -Text "Manual Jump"              -Info "Press Z + A to do a Manual Jump instead of a Jump Attack`nPress B mid-air after jumping to do a Jump Attack"                                                    -Credits "Admentus (ROM) & CloudModding (GameShark)"
    CreateReduxCheckbox -Name "AltManualJump"          -All               -Text "Alt Manual Jump"          -Info "Press Z + A to do a Manual Jump instead of a Jump Attack`nPress B mid-air after jumping to do a Jump Attack`nThis version allows you still to roll when moving" -Credits "BilonFullHDemon" -Link $Redux.Gameplay.ManualJump
    CreateReduxCheckBox -Name "NoShieldRecoil"         -All               -Text "No Shield Recoil"         -Info "Disable the recoil when being hit while shielding"                                                                                                              -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxCheckBox -Name "RunWhileShielding"      -All               -Text "Run While Shielding"      -Info "Press R to shield will no longer prevent Link from moving around" -Link $Redux.Gameplay.NoShieldRecoil                                                          -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxCheckBox -Name "PushbackAttackingWalls" -All               -Text "Pushback Attacking Walls" -Info "Link is getting pushed back a bit when hitting the wall with the sword"                                                                                         -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxCheckBox -Name "RemoveCrouchStab"       -All               -Text "Remove Crouch Stab"       -Info "The Crouch Stab move is removed"                                                                                                                                -Credits "Garo-Mastah"
    CreateReduxCheckBox -Name "RemoveQuickSpin"        -All               -Text "Remove Magic Quick Spin"  -Info "The magic Quick Spin Attack move is removed`nIt's a regular Quick Spin Attack now instead"                                                                      -Credits "Admentus & Three Pendants"
    CreateReduxCheckbox -Name "RemoveSpeedClamp"       -All               -Text "Remove Jump Speed Limit"  -Info "Removes the jumping speed limit just like in MM"                                                                                                                -Credits "Admentus (ROM) & Aegiker (GameShark)"
    


    # GAMEPLAY (UNSTABLE) #

    CreateReduxGroup    -Tag  "Gameplay"          -All   -Text "Gameplay Changes (Unstable)" 
    CreateReduxCheckBox -Name "HookshotAnything"  -Adult -Text "Hookshot Anything"   -Info "Be able to hookshot most surfaces"                                       -Warning "Prone to softlocks, be careful" -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "ClimbAnything"     -All   -Text "Climb Anything"      -Info "Climb most walls in the game"                                            -Warning "Prone to softlocks, be careful" -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "DistantZTargeting" -All   -Text "Distant Z-Targeting" -Info "Allow to use Z-Targeting on enemies, objects and NPC's from any distance"                                          -Credits "Admentus"



    # RESTORE #

    CreateReduxGroup    -Tag  "Restore"             -All    -Text "Restore / Correct / Censor"
    CreateReduxComboBox -Name "Blood"               -Base 3 -Text "Blood Color"            -Info "Change the color of blood used for several monsters, Ganondorf and Ganon`nSeveral monsters have blue or green blood, while Ganondorf/Ganon has red blood" -Items @("Default", "Red blood for monsters", "Green blood for Ganondorf/Ganon", "Change both")                  -Credits "ShadowOne333 & Admentus"
    CreateReduxCheckBox -Name "Blood"               -Base 6 -Text "Red Blood"              -Info "Change the color of blood used for several monsters to red"                                                                                                                                                                                                                -Credits "Admentus"
    CreateReduxCheckBox -Name "RupeeColors"         -All    -Text "Correct Rupee Colors"   -Info "Corrects the colors for the Purple (50) and Golden (200) Rupees"                                                                                                                                                                                                           -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "CowNoseRing"         -All    -Text "Restore Cow Nose Ring"  -Info "Restore the rings in the noses for Cows as seen in the Japanese release"                                                                                                                                                                                                   -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "CenterTextboxCursor" -All    -Text "Center Textbox Cursor"  -Info "Aligns the textbox cursor to the center of the screen"                                                                                                                                                                                                                     -Credits "BilonFullHDemon"
    CreateReduxCheckBox -Name "FireTemple"          -Base 3 -Text "Censor Fire Temple"     -Info "Censor Fire Temple theme as used in the Rev 2 ROM"                                                                                                                                                                                                                         -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "GerudoTextures"      -Base 2 -Text "Censor Gerudo Textures" -Info "Censor Gerudo symbol textures used in the GameCube / Virtual Console releases`n- Disable the option to uncensor the Gerudo Texture used in the Master Quest dungeons`n- Player model textures such as the Mirror Shield might not get restored for specific custom models" -Credits "GhostlyDark & ShadowOne333"



    # FIXES #

    CreateReduxGroup    -Tag  "Fixes"                -All                      -Text "Fixes"
    CreateReduxCheckBox -Name "BuyableBombs"         -Base 5                   -Text "Buyable Bombs"                       -Info "You no longer need the Goron's Ruby before you can buy bombs`nOnly the Bomb Bag is required"        -Credits "Admentus"
    CreateReduxCheckBox -Name "PauseScreenDelay"     -Base 5                   -Text "Pause Screen Delay"         -Checked -Info "Removes the delay when opening the Pause Screen by removing the anti-aliasing"              -Native -Credits "zel"
    CreateReduxCheckBox -Name "PauseScreenCrash"     -Base 5                   -Text "Pause Screen Crash Fix"     -Checked -Info "Prevents the game from randomly crashing emulating a decompressed ROM upon pausing"                 -Credits "zel"
    CreateReduxCheckBox -Name "WhiteBubbleCrash"     -All                      -Text "White Bubble Crash"         -Checked -Info "Prevents the game from crashing when using Din's Fire on White Bubbles"                             -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "PoacherSaw"           -Base 4                   -Text "Poacher's Saw"              -Checked -Info "Obtaining the Poacher's Saw no longer prevents Link from obtaining the second Deku Nut upgrade"     -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "FortressMinimap"      -Base 4                   -Text "Gerudo Fortress Minimap"             -Info "Display the complete minimap for the Gerudo Fortress during the Child era"                          -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "AlwaysMoveKingZora"   -Base 4                   -Text "Always Move King Zora"               -Info "King Zora will move aside even if the Zora Sapphire is in possession"                               -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "DeathMountainOwl"     -Base 4                   -Text "Death Mountain Owl"                  -Info "The Owl on top of the Death Mountain will always carry down Link regardless of having magic"        -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "SpiritTempleMirrors"  -Base 4                   -Text "Spirit Temple Mirrors"               -Info "Fix a broken effect with the mirrors in the Spirit Temple"                                          -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool) & GhostlyDark (ported)"
    CreateReduxCheckBox -Name "RemoveFishingPiracy"  -Base 4                   -Text "Remove Fishing Anti-Piracy" -Checked -Info "Removes the anti-piracy check for fishing that can cause the fish to always let go after 51 frames" -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "Boomerang"            -Child -Exclude "Dawn"   -Text "Boomerang"                           -Info "Fix the gem color on the thrown boomerang"                                                          -Credits "Aria"



    # OTHER #

    CreateReduxGroup    -Tag  "Other"             -All                 -Text "Other"
    CreateReduxComboBox -Name "MapSelect"         -All                 -Text "Enable Map Select"     -Items @("Disable", "Translate Only", "Enable Only", "Translate and Enable") -Info "Enable the Map Select menu like in the Debug ROM`nThe File Select menu now opens the Map Select menu instead`nA separate debug save file is used" -Credits "Jared Johnson (translated by Zelda Edit)"
    CreateReduxComboBox -Name "SkipIntro"         -All -Exclude "Gold" -Text "Skip Intro" -Default 1 -Items @("Don't Skip", "Skip Logo", "Skip Title Screen", "Skip Logo and Title Screen")                               -Info "Skip the logo, title screen or both"           -Credits "Aegiker"
    CreateReduxComboBox -Name "SkipIntro"              -Expose  "Gold" -Text "Skip Intro" -Default 2 -Items @("Don't Skip", "Skip Logo", "Skip Title Screen", "Skip Logo and Title Screen")                               -Info "Skip the logo, title screen or both"           -Credits "Aegiker"
    CreateReduxComboBox -Name "Skybox"            -All -Exclude "Gold" -Text "Skybox"     -Default 4 -Items @("Dawn", "Day", "Dusk", "Night", "Darkness (Dawn)", "Darkness (Day)", "Darkness (Dusk)", "Darkness (Night)") -Info "Set the skybox theme for the File Select menu" -Credits "Admentus"
    CreateReduxComboBox -Name "Skybox"                 -Expose  "Gold" -Text "Skybox"     -Default 3 -Items @("Dawn", "Day", "Dusk", "Night", "Darkness (Dawn)", "Darkness (Day)", "Darkness (Dusk)", "Darkness (Night)") -Info "Set the skybox theme for the File Select menu" -Credits "Admentus"
    CreateReduxCheckBox -Name "ItemSelect"        -All                 -Text "Translate Item Select"    -Info "Translates the Debug Inventory Select menu into English"                                                                                                         -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "DefaultZTargeting" -All                 -Text "Default Hold Z-Targeting" -Info "Change the Default Z-Targeting option to Hold instead of Switch"                                                                                                 -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "DiskDrive"         -All -Exclude "Dawn" -Text "Enable Disk Drive Saves"  -Info "Use the Disk Drive for Save Slots" -Warning "This option disables the use of non-Disk Drive save slots"                                                          -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool) & GhostlyDark (ported)"

}



#==============================================================================================================================================================================================
function CreateTabRedux() {
    
    # MISC #

    CreateReduxGroup    -Tag  "Misc"          -All                                       -Text "Misc Options"
    CreateReduxComboBox -Name "OptionsMenu"   -All -Default 4                            -Text "Options Menu"    -Items @("Disable", "Core Only", "Essentials", "Fully Enabled") -Info "Adjust how much of the Redux options are available ingame and can be used" -Credits "Admentus"
    CreateReduxComboBox -Name "SkipCutscenes" -Base 3                                    -Text "Skip Cutscenes" -Items @("Disabled", "Useful Cutscenes Excluded", "All") -Info "Skip Cutscenes`nUseful Cutscenes Excluded keeps cutscenes intact which are useful for performing glitches`nRequires a new save to take effect" -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "FastBunnyHood" -Child                            -Checked -Text "Fast Bunny Hood" -Info "The Bunny Hood makes Link run faster just like in Majora's Mask"                                                                   -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "BombchuDrops"  -All -Exclude ("Dawn", "New Master Quest") -Text "Bombchu Drops"   -Info "Bombchus can now drop from defeated enemies, cutting grass and broken jars"                                                                -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "BombchuDrops"  -Expose "New Master Quest"        -Checked -Text "Bombchu Drops"   -Info "Bombchus can now drop from defeated enemies, cutting grass and broken jars"                                                                -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "TycoonWallet"  -All                                       -Text "Tycoon's Wallet" -Info "You get the Tycoon's Wallet from one of the Gold Skulltula reward in addition`nOnly activated if you have the Giant's Wallet"              -Credits "Admentus"
    


    # CODE HOOKS FEATURES #

    CreateReduxGroup    -Tag  "Hooks"                -All                          -Text "Code Hook Features"
    CreateReduxCheckBox -Name "FishLarger"           -Base 5                       -Text "Larger Fish"              -Info "Fish are now larger"                                                                                    -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "FishBites"            -Base 5                       -Text "Guaranteed Fish Bites"    -Info "Make fish bites guaranteed when the hook of the rod is stable"                                          -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "RupeeIconColors"      -All                 -Checked -Text "Rupee Icon Colors"        -Info "The color of the Rupees counter icon changes depending on your wallet size"                             -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "EmptyBombFix"         -All -Exclude "Dawn" -Checked -Text "Empty Bomb Fix"           -Info "Fixes Empty Bomb Glitch"                                                                                -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "BlueFireArrow"        -Adult                        -Text "Blue Fire Arrows"         -Info "Ice Arrows have the same attributes as Blue Fire, thus the ability to melt Blue Ice and bombable walls" -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "ShowFileSelectIcons"  -All                 -Checked -Text "Show File Select Icons"   -Info "Show icons on the File Select screen to display your save file progress"                                -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "StoneOfAgony"         -Base 5              -Checked -Text "Stone of Agony Indicator" -Info "The Stony of Agony uses a visual indicator in addition to rumble"                                       -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "BiggoronFix"          -Base 4                       -Text "Biggoron Fix"             -Info "Fix bug when trying to trade in the Biggoron Sword"                                                     -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "DampeFix"             -Base 4                       -Text "Dampé Fix"                -Info "Prevent the heart piece of the Gravedigging Tour from being missable"                                   -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "HyruleGuardsSoftlock" -Base 4                       -Text "Hyrule Guards Softlock"   -Info "Fix a potential softlock when culling Hyrule Guards"                                                    -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "WarpSongsSpeedup"     -Base 5                       -Text "Warp Songs Speedup"       -Info "Speedup the warp songs warping sequences"                                                               -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "GoldGauntletsSpeedup" -Base 5                       -Text "Gold Gauntlets Speedup"   -Info "Cutscene speed-up for throwing pillars that require Golden Gauntlets"                                   -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "TalonSkip"            -Base 3                       -Text "Skip Talon Cutscene"      -Info "Skip the cutscene after waking up Talon before entering the Castle Courtyard"                           -Credits "Ported from Redux"



    # RAINBOW COLORS #

    CreateReduxGroup    -Tag  "Rainbow"   -All                   -Text "Rainbow Colors"
    CreateReduxCheckBox -Name "Sword"     -All                   -Text "Sword Trail"     -Info "Cycle through random colors for the Sword Trail"     -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "Boomerang" -Child -Exclude "Dawn" -Text "Boomerang Trail" -Info "Cycle through random colors for the Boomerang Trail" -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "Bombchu"   -All   -Exclude "Dawn" -Text "Bombchu Trail"   -Info "Cycle through random colors for the Bombchu Trail"   -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "Navi"      -All                   -Text "Navi"            -Info "Cycle through random colors for Navi"                -Credits "Ported from Redux"



    # COLORS #

    CreateButtonColorOptions
    CreateRupeeColorOptions
    CreateHUDColorOptions
    CreateBoomerangColorOptions
    CreateBombchuColorOptions
    $Last.Half = $False; CreateTextColorOptions; $Redux.Box.TextColors = $Last.Group

    if ($Redux.Graphics.RupeeIconColors -ne $null)   { $Redux.Hooks.RupeeIconColors.Add_CheckStateChanged( { EnableElem -Elem $Redux.Colors.RupeesVanilla -Active (!$this.checked) } ) }
    if ($Redux.Graphics.GCScheme        -ne $null)   { $Redux.Graphics.GCScheme.Add_CheckStateChanged(     { EnableForm -Form $Redux.Box.TextColors       -Enable (!$this.checked) } ) }
    
}



#==============================================================================================================================================================================================
function CreateTabLanguage() {
    
    if ($GamePatch.vanilla -eq 1) { CreateLanguageContent }



    # TEXT SPEED #

    CreateReduxGroup -Tag "Text"           -All -Text "Text Speed"
    CreateReduxPanel                       -All
    CreateReduxRadioButton -Name "Speed1x" -All -Max 4 -SaveTo "Speed" -Text "1x Text Speed" -Info "Leave the dialogue text speed at normal"               -Checked
    CreateReduxRadioButton -Name "Speed2x" -All -Max 4 -SaveTo "Speed" -Text "2x Text Speed" -Info "Set the dialogue text speed to be twice as fast"       -Credits "Ported from Redux"
    CreateReduxRadioButton -Name "Speed3x"      -Max 4 -SaveTo "Speed" -Text "3x Text Speed" -Info "Set the dialogue text speed to be three times as fast" -Credits "Ported from Redux"
    CreateReduxRadioButton -Name "Instant"      -Max 4 -SaveTo "Speed" -Text "Instant Text"  -Info "Most text will be shown instantly"                     -Credits "Admentus"
    


    # DIALOGUE #

    $Redux.Box.Dialogue = CreateReduxGroup -Tag "Text" -All -Text "Dialogue"
    CreateReduxPanel                       -All
    CreateReduxRadioButton -Name "Vanilla" -All                     -Max 4 -SaveTo "Dialogue" -Text "Vanilla Text"  -Checked -Info "Keep the text as it is"
    CreateReduxRadioButton -Name "Restore"                          -Max 4 -SaveTo "Dialogue" -Text "Restore Text"           -Info ("Restores the text used from the GC revision and applies grammar and typo fixes`nCorrects some icons in the text and includes the changes from" + ' "Redux Text"') -Credits "Redux"
    CreateReduxRadioButton -Name "Beta"                             -Max 4 -SaveTo "Dialogue" -Text "Beta Text"              -Info "Restores the text as was used in the Ura Quest Beta version"                                                                                                       -Credits "ZethN64, Sakura, Frostclaw & Steve(ToCoool)"
    CreateReduxRadioButton -Name "MMoT"    -Expose "Master of Time" -Max 4 -SaveTo "Dialogue" -Text "Malon's Master of Time" -Info ("Use the script dialogue from the Malon's Master of Time version`nIt's recommended to use the " + '"Malon Red"' + " model for the best immersive experience")      -Credits "Luna Romana"
    CreateReduxRadioButton -Name "Custom"  -All                     -Max 4 -SaveTo "Dialogue" -Text "Custom"                 -Info 'Insert custom dialogue found from "..\Patcher64+ Tool\Files\Games\Ocarina of Time\Custom Text"' -Warning "ROM crashes if the script is not proper`n[!] Won't be applied if the custom script is missing"
   
    $Last.Row++; $Last.Column = 1
    CreateReduxCheckBox -Name "FemalePronouns" -Text "Female Pronouns" -Info "Refer to Link as a female character"                                                                                                                       -Credits "Admentus & Mil"
    CreateReduxCheckBox -Name "TypoFixes"      -Text "Typo Fixes"      -Info "Include the typo fixes from the Redux script"                                                                                                              -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "GoldSkulltula"  -Text "Gold Skulltula"  -Info "The textbox for obtaining a Gold Skulltula will no longer interrupt the gameplay`nThe English & German scripts also shows the total amount you got so far" -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "EasterEggs"     -Text "Easter Eggs"     -Info "Adds custom Patreon Tier 3 messages into the game`nCan you find them all?" -Checked                                                                        -Credits "Admentus & Patreons"



    # OTHER ENGLISH OPTIONS #

    CreateReduxGroup    -Tag  "Text"          -All  -Text "Other English Options"
    CreateReduxCheckBox -Name "YeetPrompt"    -All  -Text "Yeet Action Prompt"     -Info ('Replace the "Throw" Action Prompt with "Yeet"' + "`nYeeeeet")           -Credits "kr3z"
    CreateReduxCheckBox -Name "Fairy"         -Base 4 -Text "MM Fairy Text"        -Info ("Changes " + '"Bottled Fairy" to "Fairy"' + " as used in Majora's Mask") -Credits "GhostlyDark (ported)"
    CreateReduxCheckBox -Name "Milk"          -Base 4 -Text "MM Milk Text"         -Info ("Changes " + '"Lon Lon Milk" to "Milk"' + " as used in Majora's Mask")   -Credits "GhostlyDark (ported)"
    CreateReduxCheckBox -Name "KeatonMaskFix" -Base 4 -Text "Keaton Mask Text Fix" -Info 'Fixes the grammatical typo for the "Keaton Mask"'                        -Credits "Redux"
    CreateReduxCheckBox -Name "PauseScreen"   -Base 4 -Text "MM Pause Screen"      -Info "Replaces the Pause Screen textures to be styled like Majora's Mask"      -Credits "CM & GhostlyDark"



    # OTHER GERMAN OPTIONS #

    CreateReduxGroup    -Tag  "Text"        -Text "Other German Options"
    CreateReduxCheckBox -Name "CheckPrompt" -Text "Read Action Prompt" -Info 'Replace the "Lesen" Action Prompt with "Ansehen"'     -Credits "Admentus, GhostlyDark & Ticamus"
    CreateReduxCheckBox -Name "DivePrompt"  -Text "Dive Action Prompt" -Info 'Replace the "Tauchen" Action Prompt with "Abtauchen"' -Credits "Admentus, GhostlyDark & Ticamus"



    # OTHER TEXT OPTIONS #

    CreateReduxGroup    -All -Tag  "Text"       -Text "Other Text Options"
    if ($GamePatch.settings -eq "Master of Time")   { $val = "Nite" }                                                    else   { $val   = "Navi"                   }
    if ($GamePatch.vanilla  -eq 1)                  { $items = @("Disabled", "Enabled as Female", "Enabled as Male") }   else   { $items = @("Disabled", "Enabled") }
    $names = "`n`n--- Supported Names With Textures ---`n" + "Navi`nTatl`nTaya`nТдтп`nTael`nNite`nNagi`nInfo"
    CreateReduxCheckBox -All -Name "LinkScript" -Text "Link Text"                                               -Info "Separate file name from Link's name in-game"  -Credits "Admentus & Third M"
    CreateReduxTextBox  -All -Name "LinkName"   -Text "Link Name"      -Length 8 -ASCII -Value "Link" -Width 90 -Info "Select the name for Link"                     -Credits "Admentus & Third M"      -Shift 40
    CreateReduxComboBox -All -Name "NaviScript" -Text ($val + " Text") -Items $items                            -Info ("Allow renaming " + $val + " and the gender") -Credits "Admentus & ShadowOne333" -Warning "Gender swap is only supported for English"
    CreateReduxTextBox  -All -Name "NaviName"   -Text ($val + " Name") -Length 5 -ASCII -Value $val   -Width 50 -Info ("Select the name for " + $val)                -Credits "Admentus & ShadowOne333" -Warning ('Most names do not have an unique texture label, and use a default "Info" prompt label' + $names)
    CreateReduxCheckBox -All -Name "NaviPrompt" -Text ($val + " Prompt")                                        -Info ("Enables the A button prompt for " + $val)    -Credits "Admentus & ShadowOne333" -Warning 'Most names do not have an unique texture prompt, and use a default "Info" prompt label'
    $val = $items = $null

    if ($GamePatch.vanilla -eq 1) {
        foreach ($i in 0.. ($Files.json.languages.count-1)) { $Redux.Language[$i].Add_CheckedChanged({ UnlockLanguageContent }) }
        UnlockLanguageContent
    }

    $Redux.Text.NaviScript.Add_SelectedIndexChanged( { UnlockLanguageContent } )
    $Redux.Text.LinkScript.Add_CheckStateChanged(    { UnlockLanguageContent } )

}



#==============================================================================================================================================================================================
function UnlockLanguageContent() {
    
    # English options
    EnableElem -Elem $Redux.Text.Restore        -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.Beta           -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.FemalePronouns -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.TypoFixes      -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.EasterEggs     -Active $Redux.Language[0].Checked
    
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
            EnableElem -Elem @($Redux.Text.Instant, $Redux.Text.GoldSkulltula, $Redux.Text.LinkScript, $Redux.Text.NaviScript, $Redux.Text.NaviPrompt) -Active ($Files.json.languages[$i].region -ne "J")

            EnableElem -Elem $Redux.Text.NaviName -Active ($Redux.Text.NaviScript.SelectedIndex -ne 0 -and $Redux.Text.NaviScript.Enabled)
            EnableElem -Elem $Redux.Text.LinkName -Active ($Redux.Text.LinkScript.Checked             -and $Redux.Text.LinkScript.Enabled)
        }
    }

}



#==============================================================================================================================================================================================
function CreateTabGraphics() {
    
    # GRAPHICS #

    CreateReduxGroup -Tag  "Graphics" -All -Text "Graphics" -Columns 4 -Height 3
    CreateReduxCheckBox -Name "Widescreen"      -All    -Text "16:9 Widescreen (Advanced)"   -Info "Patch the game to be in true 16:9 widescreen with the HUD pushed to the edges"                       -Native -Credits "Widescreen Patch by gamemasterplc, enhanced and ported by GhostlyDark"
    CreateReduxCheckBox -Name "WidescreenAlt"   -All    -Text "16:9 Widescreen (Simplified)" -Info "Apply 16:9 Widescreen adjusted backgrounds and textures (as well as 16:9 Widescreen for the Wii VC)" -Credits "Aspect Ratio Fix by Admentus`n16:9 backgrounds by GhostlyDark, ShadowOne333 & CYB3RTRON" -Link $Redux.Graphics.Widescreen
    CreateReduxCheckBox -Name "ExtendedDraw"    -All    -Text "Extended Draw Distance"       -Info "Increases the game's draw distance for objects`nDoes not work on all objects"                        -Credits "Admentus"
    CreateReduxCheckBox -Name "ForceHiresModel" -All    -Text "Force Hires Link Model"       -Info "Always use Link's High Resolution Model when Link is too far away" -Exclude "Dawn & Dusk"            -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "HideDungeonIcon" -Base 3 -Text "Hide Dungeon Icon"            -Info "Hide dungeon icon for minimaps that do not have a dungeon entrance"                                  -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "GCScheme"        -All    -Text "GC Scheme"                    -Info "Replace and change the textures, dialogue and text colors to match the GameCube's scheme"            -Credits "Admentus, GhostlyDark, ShadowOne333 & Ported from Redux"
    

    if (!$IsWiiVC) {
        EnableElem -Elem @($Redux.Fixes.PauseScreenDelay, $Redux.Fixes.PauseScreenCrash) -Active (!$Redux.Graphics.Widescreen.Checked)
        $Redux.Graphics.Widescreen.Add_CheckStateChanged({ EnableElem -Elem @($Redux.Fixes.PauseScreenDelay, $Redux.Fixes.PauseScreenCrash) -Active (!$this.Checked) })
    }



    # MDOELS #

    $Last.Column = 1; $Last.Row = 3
    $models = LoadModelsList -Category "Child"
    CreateReduxComboBox -Name "ChildModels" -Child -Text "Child Model" -Items (@("Original") + $models) -Default "Original" -Info "Replace the child model used for Link"
    $models = LoadModelsList -Category "Adult"
    CreateReduxComboBox -Name "AdultModels" -Adult -Text "Adult Model" -Items (@("Original") + $models) -Default "Original" -Info "Replace the adult model used for Link"
    $info = $models = $null

    $Redux.Graphics.ModelPreviews = CreateReduxGroup -Tag "Graphics" -All -Text "Model Previews"
    $Last.Group.Height = (DPISize 252)

    CreateImageBox -x 20  -y 20 -w 154 -h 220 -Child -Name "ModelsPreviewChild"
    CreateImageBox -x 210 -y 20 -w 154 -h 220 -Adult -Name "ModelsPreviewAdult"
    $global:PreviewToolTip = CreateToolTip
    ChangeModelsSelection
    


    # INTERFACE #
    
    CreateReduxGroup -Tag  "UI" -All -Text "Interface" -Height 4
    $Last.Group.Width = $Redux.Groups[$Redux.Groups.Length-3].Width; $Last.Group.Top = $Redux.Groups[$Redux.Groups.Length-3].Bottom + 5; $Last.Width = 4
    if ($GamePatch.settings -eq "Gold Quest") { $val = "Gold Quest" } else { $val = "Ocarina of Time" }

    CreateReduxComboBox -Name "BlackBars"        -All -Text "Black Bars"  -Items @("Enabled", "Disabled for Z-Targeting", "Disabled for Cutscenes", "Always Disabled") -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes"    -Credits "Admentus"
    CreateReduxComboBox -Name "ButtonSize"       -All -Text "HUD Buttons"                          -FilePath ($Paths.shared + "\Buttons")    -Ext $null -Default "Large"           -Info "Set the size for the HUD buttons"                                                         -Credits "GhostlyDark (ported)"
    $path = $Paths.shared + "\Buttons" + "\" + $Redux.UI.ButtonSize.Text.replace(" (default)", "")
    CreateReduxComboBox -Name "ButtonStyle"      -All -Text "HUD Buttons" -Items "Ocarina of Time" -FilePath $path                           -Ext "bin" -Default $val              -Info "Set the style for the HUD buttons"                                                        -Credits "GhostlyDark (ported), Admentus (ported), Pizza (HD), Djipi, Community, Nerrel, Federelli, AndiiSyn & Syeo"
    CreateReduxComboBox -Name "Rupees"           -All -Text "Rupee Icon"  -Items "Ocarina of Time" -FilePath ($Paths.shared + "\HUD\Rupees") -Ext "bin" -Default "Ocarina of Time" -Info "Set the style for the rupees icon"                                                        -Credits "Ported by GhostlyDark"
    CreateReduxComboBox -Name "Hearts"           -All -Text "Heart Icons" -Items "Ocarina of Time" -FilePath ($Paths.shared + "\HUD\Hearts") -Ext "bin" -Default $val              -Info "Set the style for the heart icons"                                                        -Credits "GhostlyDark (ported), Admentus (ported), AndiiSyn & Syeo"
    CreateReduxComboBox -Name "Magic"            -All -Text "Magic Bar"   -Items "Ocarina of Time" -FilePath ($Paths.shared + "\HUD\Magic")  -Ext "bin" -Default "Ocarina of Time" -Info "Set the style for the magic meter"                                                        -Credits "GhostlyDark (ported), Pizza, Nerrel (HD), Zeth Alkar"
    CreateReduxCheckBox -Name "CenterNaviPrompt" -All -Text "Center Navi Prompt"                                                                                                   -Info 'Centers the "Navi" prompt shown in the C-Up button'                                       -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "DungeonKeys"      -All -Text "MM Key Icon"                                                                                                          -Info "Replace the key icon with that from Majora's Mask"                                        -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "DungeonIcons"     -All -Text "MM Dungeon Icons"                                                                                                     -Info "Replace the dungeon map icons with those from Majora's Mask"                              -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "ButtonPositions"  -All -Text "MM Button Positions"                                                                                                  -Info "Positions the A and B buttons like in Majora's Mask"                                      -Credits "Ported by GhostlyDark"
    
    

    # HIDE HUD #

    CreateReduxGroup    -Tag  "Hide"         -All -Text "Hide HUD"
    CreateReduxCheckBox -Name "AButton"      -All -Text "Hide A Button"           -Info "Hide the A Button"                                            -Credits "Admentus"
    CreateReduxCheckBox -Name "BButton"      -All -Text "Hide B Button"           -Info "Hide the B Button"                                            -Credits "Admentus"
    CreateReduxCheckBox -Name "StartButton"  -All -Text "Hide Start Button"       -Info "Hide the Start Button"                                        -Credits "Admentus"
    CreateReduxCheckBox -Name "CUpButton"    -All -Text "Hide C-Up Button"        -Info "Hide the C-Up Button"                                         -Credits "Admentus"
    CreateReduxCheckBox -Name "CButtons"     -All -Text "Hide C Buttons"          -Info "Hide the C Button used for items"                             -Credits "Admentus"
    CreateReduxCheckBox -Name "Magic"        -All -Text "Hide Magic"              -Info "Hide the Magic display"                                       -Credits "Admentus"
    CreateReduxCheckBox -Name "Rupees"       -All -Text "Hide Rupees"             -Info "Hide the the Rupees display"                                  -Credits "Admentus"
    CreateReduxCheckBox -Name "DungeonKeys"  -All -Text "Hide Keys"               -Info "Hide the Keys display shown in several dungeons and areas"    -Credits "Admentus"
    CreateReduxCheckBox -Name "Carrots"      -All -Text "Hide Epona Carrots"      -Info "Hide the Epona Carrots display"                               -Credits "Admentus"
    CreateReduxCheckBox -Name "AreaTitle"    -All -Text "Hide Area Title Card"    -Info "Hide the area title that displays when entering a new area"   -Credits "Admentus"
    CreateReduxCheckBox -Name "DungeonTitle" -All -Text "Hide Dungeon Title Card" -Info "Hide the dungeon title that displays when entering a dungeon" -Credits "Admentus"
    CreateReduxCheckBox -Name "Icons"        -All -Text "Hide Icons"              -Info "Hide the Clock and Score Counter icons display"               -Credits "Admentus"
    CreateReduxCheckBox -Name "Credits"      -All -Text "Hide Credits"            -Info "Hide the credits text during the credits sequence"            -Credits "Admentus" -Exclude "Master"

    

    # STYLES #

    CreateReduxGroup    -Tag  "Styles"        -All -Text "Styles"         -Columns 4
    if ($GamePatch.settings -eq "Gold Quest") { $val = "Gold Quest" } else { $val = "Regular" }
    CreateReduxComboBox -Name "RegularChests" -All -Text "Regular Chests" -Info "Use a different style for regular treasure chests"                                           -FilePath ($Paths.shared + "\Chests") -Default $val -Ext "front" -Items "Regular"              -Credits "Nintendo, Syeo, AndiiSyn & Rando"
    CreateReduxComboBox -Name "BossChests"    -All -Text "Boss Chests"    -Info "Use a different style for Boss Key treasure chests"                                          -FilePath ($Paths.shared + "\Chests")               -Ext "front" -Items "Boss OoT"             -Credits "Nintendo, Syeo, AndiiSyn & Rando"
    CreateReduxComboBox -Name "Crates"        -All -Text "Small Crates"   -Info "Use a different style for small liftable crates"                                             -FilePath ($Paths.shared + "\Crates")               -Ext "bin"   -Items "Regular"              -Credits "Nintendo & Rando"
    CreateReduxComboBox -Name "Pots"          -All -Text "Pots"           -Info "Use a different style for throwable pots"                                                    -FilePath ($Paths.shared + "\Pots")                 -Ext "bin"   -Items "Regular"              -Credits "Nintendo, Syeo & Rando"
    CreateReduxComboBox -Name "HairColor"     -All -Text "Hair Color"     -Info "Use a different hair color style for Link`nOnly for Ocarina of Time or Majora's Mask models" -FilePath ($Paths.shared + "\Hair\Ocarina of Time") -Ext "bin"   -Items @("Default", "Blonde") -Credits "Third M & AndiiSyn"



    # HUD PREVIEWS #

    CreateReduxGroup -Tag "UI" -All -Text "HUD Previews"
    $Last.Group.Height = (DPISize 140)

    CreateImageBox -x 40  -y 30 -w 90  -h 90 -All -Name "ButtonPreview";      $Redux.UI.ButtonSize.Add_SelectedIndexChanged( { ShowHUDPreview -IsOoT } ); $Redux.UI.ButtonStyle.Add_SelectedIndexChanged( { ShowHUDPreview -IsOoT } )
    CreateImageBox -x 220 -y 35 -w 40  -h 40 -All -Name "RupeesPreview";      $Redux.UI.Rupees.Add_SelectedIndexChanged(     { ShowHUDPreview -IsOoT } )
    CreateImageBox -x 160 -y 35 -w 40  -h 40 -All -Name "HeartsPreview";      $Redux.UI.Hearts.Add_SelectedIndexChanged(     { ShowHUDPreview -IsOoT } )
    CreateImageBox -x 140 -y 85 -w 200 -h 40 -All -Name "MagicPreview";       $Redux.UI.Magic.Add_SelectedIndexChanged(      { ShowHUDPreview -IsOoT } )
    CreateImageBox -x 280 -y 35 -w 40  -h 40 -All -Name "DungeonKeysPreview"; $Redux.UI.DungeonKeys.Add_CheckStateChanged(   { ShowHUDPreview -IsOoT } )
    ShowHUDPreview -IsOoT

}




#==============================================================================================================================================================================================
function CreateTabAudio() {
    
    # SOUNDS / VOICES #

    CreateReduxGroup    -Tag  "Sounds"      -All   -Text "Sounds / Voices"
    CreateReduxComboBox -Name "ChildVoices" -Child -Text "Child Voice" -Default "Original" -Items @("Original") -FilePath ($GameFiles.binaries + "\Voices Child")   -Info "Replace the voice used for the Child Link Model"    -Credits "`nMajora's Mask: Korey Cryderman (ported) & GhostlyDark (corrected)`nMelee Zelda: Mickey Devi & theluigidude2007 (edits)`nAmara: Amara (ripping) & theluigidude2007 (edits)"
    CreateReduxComboBox -Name "AdultVoices" -Adult -Text "Adult Voice" -Default "Original" -Items @("Original") -FilePath ($GameFiles.binaries + "\Voices Adult")   -Info "Replace the voice used for the Adult Link Model"    -Credits "`nMajora's Mask: Korey Cryderman (ported) & GhostlyDark (corrected)`nMelee Zelda: Mickey Devi & theluigidude2007 (edits)`nAmara: Amara (ripping) & theluigidude2007`nPeach: theluigidude2007"
    CreateReduxComboBox -Name "Instrument"  -All   -Text "Instrument"                      -Items @("Ocarina", "Female Voice", "Whistle", "Harp", "Organ", "Flute") -Info "Replace the sound used for playing the Ocarina of Time" -Credits "Ported from Rando"



    # SFX SOUND EFFECTS #

    $SFX1 = @("Default", "Disabled", "Soft Beep", "Bark", "Bomb Bounce", "Bongo Bongo Low", "Bow Twang", "Business Scrub", "Carrot Refill", "Cluck", "Great Fairy", "Drawbridge Set", "Guay", "Horse Trot", "HP Recover", "Iron Boots", "Moo", "Mweep!", 'Navi "Hey!"', "Navi Random", "Notification", "Pot Shattering", "Ribbit", "Rupee (Silver)", "Switch", "Sword Bonk", "Tambourine", "Timer", "Zelda Gasp (Adult)")
    $SFX2 = @("Default",  "Disabled", "Soft Beep", "Bark", "Business Scrub", "Carrot Refill", "Cluck", "Cockadoodledoo", "Dusk Howl", "Exploding Crate", "Explosion", "Great Fairy", "Guay", "Horse Neigh", "HP Low", "HP Recover", "Ice Shattering", "Moo", "Meweep!", 'Navi "Hello!"', "Notification", "Pot Shattering", "Redead Scream", "Ribbit", "Ruto Giggle", "Skulltula", "Tambourine", "Timer", "Zelda Gasp (Adult)")
    $SFX3 = @("Default", "Disabled", "Soft Beep", "Bark", "Bomb Bounce", "Bongo Bongo High", "Bongo Bongo Low", "Bottle Cork", "Bow Twang", "Bubble Laugh", "Carrot Refill", "Change Item", "Child Pant", "Cluck", "Deku Baba", "Drawbridge Set", "Dusk Howl", "Fanfare (Light)", "Fanfare (Medium)", "Field Shrub", "Flare Dancer Startled",
    'Ganondorf "Teh"', "Gohma Larva Croak", "Gold Skull Token", "Goron Wake", "Guay", "Gunshot", "Hammer Bonk", "Horse Trot", "HP Low", "HP Recover", "Iron Boots", "Iron Knuckle", "Moo", "Mweep!", "Notification", "Phantom Ganon Laugh", "Plant Explode", "Pot Shattering", "Redead Moan", "Ribbit", "Rupee", "Rupee (Silver)", "Ruto Crash",
    "Ruto Lift", "Ruto Thrown", "Scrub Emerge", "Shabom Bounce", "Shabom Pop", "Shellblade", "Skulltula", "Spit Nut", "Switch", "Sword Bonk", 'Talon "Hmm"', "Talon Snore", "Talon WTF", "Tambourine", "Target Enemy", "Target Neutral", "Thunder", "Timer", "Zelda Gasp (Adult)")
    
    CreateReduxGroup    -Tag "SFX"         -All -Text "SFX Sound Effects"
    CreateReduxComboBox -Name "LowHP"      -All -Text "Low HP"      -Items $SFX1                                                                                                                                   -Info "Set the sound effect for the low HP beeping"                             -Credits "Ported from Rando"
    CreateReduxComboBox -Name "Navi"       -All -Text "Navi"        -Items $SFX2                                                                                                                                   -Info "Replace the sound used for Navi when she wants to tell something"        -Credits "Ported from Rando"
    CreateReduxComboBox -Name "ZTarget"    -All -Text "Z-Target"    -Items $SFX2                                                                                                                                   -Info "Replace the sound used for Z-Targeting enemies"                          -Credits "Ported from Rando"
    CreateReduxComboBox -Name "HoverBoots" -All -Text "Hover Boots" -Items @("Default", "Disabled", "Bark", "Cartoon Fall", "Flare Dancer Laugh", "Mweep!", "Shabom Pop", "Tambourine")                            -Info "Replace the sound used for the Hover Boots"                              -Credits "Ported from Rando" 
    CreateReduxComboBox -Name "Horse"      -All -Text "Horse Neigh" -Items @("Default", "Disabled", "Armos", "Child Scream", "Great Fairy", "Moo", "Mweep!", "Redead Scream", "Ruto Wiggle", "Stalchild Attack")   -Info "Replace the sound for horses when neighing"                              -Credits "Ported from Rando"
    CreateReduxComboBox -Name "Nightfall"  -All -Text "Nightfall"   -Items @("Default", "Disabled", "Cockadoodledoo", "Gold Skull Token", "Great Fairy", "Moo", "Mweep!", "Redead Moan", "Talon Snore", "Thunder") -Info "Replace the sound used when Nightfall occurs"                            -Credits "Ported from Rando" 
    CreateReduxComboBox -Name "FileCursor" -All -Text "File Cursor" -Items $SFX3                                                                                                                                   -Info "Replace the sound used when moving the cursor in the File Select menu"   -Credits "Ported from Rando"
    CreateReduxComboBox -Name "FileSelect" -All -Text "File Select" -Items $SFX3                                                                                                                                   -Info "Replace the sound used when selecting something in the File Select menu" -Credits "Ported from Rando"



    # MUSIC #

    if ($GamePatch.vanilla -le 3) { MusicOptions -Default "Great Fairy's Fountain" }
    
}



#==============================================================================================================================================================================================
function CreateTabDifficulty() {
    
    # HERO MODE #

    $items1 = @("1 Monster HP","0.5x Monster HP", "1x Monster HP", "1.5x Monster HP", "2x Monster HP", "2.5x Monster HP", "3x Monster HP", "3.5x Monster HP", "4x Monster HP", "5x Monster HP")
    $items2 = @("1 Mini-Boss HP", "0.5x Mini-Boss HP", "1x Mini-Boss HP", "1.5x Mini-Boss HP", "2x Mini-Boss HP", "2.5x Mini-Boss HP", "3x Mini-Boss HP", "3.5x Mini-Boss HP", "4x Mini-Boss HP", "5x Mini-Boss HP")
    $items3 = @("1 Boss HP", "0.5x Boss HP", "1x Boss HP", "1.5x Boss HP", "2x Boss HP", "2.5x Boss HP", "3x Boss HP", "3.5x Boss HP", "4x Boss HP", "5x Boss HP")

    CreateReduxGroup    -Tag  "Hero"       -All -Text "Hero Mode"
    CreateReduxComboBox -Name "MonsterHP"  -All -Text "Monster HP"   -Items $items1 -Default 3                                                        -Info "Set the amount of health for monsters`nDoesn't include monsters which die in 1 hit already"           -Credits "Admentus"
    CreateReduxComboBox -Name "MiniBossHP" -All -Text "Mini-Boss HP" -Items $items2 -Default 3                                                        -Info "Set the amount of health for elite monsters and mini-bosses`nBig Octo and Dark Link are not included" -Credits "Admentus"
    CreateReduxComboBox -Name "BossHP"     -All -Text "Boss HP"      -Items $items3 -Default 3                                                        -Info "Set the amount of health for bosses`nPhantom Ganon, Ganondorf and Ganon have a max of 3x HP"          -Credits "Admentus & Marcelo20XX"
    CreateReduxComboBox -Name "Damage"     -All -Text "Damage"       -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage", "OHKO Mode")        -Info "Set the amount of damage you receive`nOHKO Mode = You die in one hit"                                 -Credits "Admentus"
    CreateReduxComboBox -Name "MagicUsage" -All -Text "Magic Usage"  -Items @("1x Magic Usage", "2x Magic Usage", "4x Magic Usage", "8x Magic Usage") -Info "Set the amount of times magic is consumed at"                                                         -Credits "Admentus"
    CreateReduxComboBox -Name "ItemDrops"  -All -Text "Item Drops"   -Items @("Default", "No Hearts", "Only Rupees", "Nothing")                       -Info "Set the items that will drop from grass, pots and more"                                               -Credits "Ported from Rando, Admentus, Third M & BilonFullHDemon"
    


    # HERO MODE #

    CreateReduxGroup    -Tag  "Hero"               -All    -Text "Hero Mode"
    CreateReduxCheckBox -Name "Arwing"                     -Text "Arwing"               -Info "Replaces the Rock-Lifting Kokiri Kid with an Arwing in Kokiri Forest"                                -Credits "Admentus"
    CreateReduxCheckBox -Name "LikeLike"                   -Text "Like-Like"            -Info "Replaces the Rock-Lifting Kokiri Kid with a Like-Like in Kokiri Forest"                              -Credits "Admentus" -Link $Redux.Hero.Arwing
    CreateReduxCheckBox -Name "GraveyardKeese"             -Text "Graveyard Keese"      -Info "Extends the object list for Adult Link so the Keese appear at the Graveyard"                         -Credits "salvador235"
    CreateReduxCheckBox -Name "LostWoodsOctorok"           -Text "Lost Woods Octorok"   -Info "Add an Octorok actor in the Lost Woods area which leads to Zora's River"                             -Credits "Chez Cousteau"
    CreateReduxCheckBox -Name "HarderChildBosses"          -Text "Harder Child Bosses"  -Info "Replace objects in the Child Dungeon Boss arenas with additional monsters"                           -Credits "BilonFullHDemon"
    CreateReduxCheckBox -Name "PotsChallenge"      -All    -Text "Pots Challenge"       -Info "Throw pots at your enemies to defeat them! Pots everywhere!"                                         -Credits "Aegiker"
    CreateReduxCheckBox -Name "NoBottledFairy"     -All    -Text "No Bottled Fairies"   -Info "Fairies can no longer be put into a bottle"                                                          -Credits "Admentus & Three Pendants"

    CreateReduxCheckBox -Name "HarderStalfos"      -All    -Exclude "New Master Quest" -Text "Harder Stalfos"       -Info "Stalfos will attack you even not Z-Targeted"                                           -Credits "BilonFullHDemon"
    CreateReduxCheckBox -Name "HarderWolfos"       -All    -Exclude "New Master Quest" -Text "Harder Wolfos"        -Info "Wolfos will attack you even not Z-Targeted"                                            -Credits "BilonFullHDemon"
    CreateReduxCheckBox -Name "HarderKeese"        -All    -Exclude "New Master Quest" -Text "Harder Keese"         -Info "Keese attack earlier and faster between attacks, and will not lose their fire"         -Credits "Euler"
    CreateReduxCheckBox -Name "HarderGohma"        -All    -Exclude "New Master Quest" -Text "Harder Gohma"         -Info "Gohma recovers faster from being stunned and has a smaller window of exposure"         -Credits "Euler"
    CreateReduxCheckBox -Name "HarderKingDodongo"  -All    -Exclude "New Master Quest" -Text "Harder King Dodongo"  -Info "King Dodongo inhales faster, receives half damage from bombs and is no longer stunned" -Credits "Euler"
    CreateReduxCheckBox -Name "AggressiveDarkLink" -Base 4 -Exclude "New Master Quest" -Text "Aggressive Dark Link" -Info "Dark Link starts attacking you right away after spawning"                              -Credits "BilonFullHDemon"
    
    CreateReduxCheckBox -Name "HarderStalfos"      -Expose "New Master Quest" -Checked -Text "Harder Stalfos"       -Info "Stalfos will attack you even not Z-Targeted"                                           -Credits "BilonFullHDemon"
    CreateReduxCheckBox -Name "HarderWolfos"       -Expose "New Master Quest" -Checked -Text "Harder Wolfos"        -Info "Wolfos will attack you even not Z-Targeted"                                            -Credits "BilonFullHDemon"
    CreateReduxCheckBox -Name "HarderKeese"        -Expose "New Master Quest" -Checked -Text "Harder Keese"         -Info "Keese attack earlier and faster between attacks, and will not lose their fire"         -Credits "Euler"
    CreateReduxCheckBox -Name "HarderGohma"        -Expose "New Master Quest" -Checked -Text "Harder Gohma"         -Info "Gohma recovers faster from being stunned and has a smaller window of exposure"         -Credits "Euler"
    CreateReduxCheckBox -Name "HarderKingDodongo"  -Expose "New Master Quest" -Checked -Text "Harder King Dodongo"  -Info "King Dodongo inhales faster, receives half damage from bombs and is no longer stunned" -Credits "Euler"
    CreateReduxCheckBox -Name "AggressiveDarkLink" -Expose "New Master Quest" -Checked -Text "Aggressive Dark Link" -Info "Dark Link starts attacking you right away after spawning"                              -Credits "BilonFullHDemon"


    
    # RECOVERY #

    CreateReduxGroup   -Tag  "Recovery"    -All -Text "Recovery" -Height 1.6
    CreateReduxTextBox -Name "Heart"       -All -Text "Recovery Heart" -Value 16  -Min 0 -Max 320 -Length 3 -Info "Set the amount of HP that Recovery Hearts will replenish`nRecovery Heart drops are removed if set to 0" -Credits "Admentus, Three Pendants & Rando (No Heart Drops)"
    CreateReduxTextBox -Name "Fairy"       -All -Text "Fairy (Bottle)" -Value 320 -Min 0 -Max 320 -Length 3 -Info "Set the amount of HP that a Bottled Fairy will replenish"                                               -Credits "Admentus & Three Pendants"
    CreateReduxTextBox -Name "FairyRevive" -All -Text "Fairy (Revive)" -Value 320 -Min 0 -Max 320 -Length 3 -Info "Set the amount of HP that a Bottled Fairy will replenish after Link died"                               -Credits "Admentus & Three Pendants"
    CreateReduxTextBox -Name "Milk"        -All -Text "Milk"           -Value 80  -Min 0 -Max 320 -Length 3 -Info "Set the amount of HP that Milk will replenish"                                                          -Credits "Admentus & Three Pendants"
    CreateReduxTextBox -Name "RedPotion"   -All -Text "Red Potion"     -Value 320 -Min 0 -Max 320 -Length 3 -Info "Set the amount of HP that a Red Potion will replenish"                                                  -Credits "Admentus & Three Pendants"

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



    # MAGIC #

    CreateReduxGroup   -All -Tag  "Magic"       -Text "Magic Costs"
    CreateReduxTextBox -All -Name "FireArrow"   -Text "Fire Arrow"    -Value 4  -Max 96 -Info "Set the magic cost for using Fire Arrows´n48 is the maximum amount of the standard magic meter´n96 is the maximum amount of the double magic meter"   -Credits "Admentus"
    CreateReduxTextBox -All -Name "IceArrow"    -Text "Ice Arrow"     -Value 4  -Max 96 -Info "Set the magic cost for using Ice Arrows´n48 is the maximum amount of the standard magic meter´n96 is the maximum amount of the double magic meter"    -Credits "Admentus"
    CreateReduxTextBox -All -Name "LightArrow"  -Text "Light Arrow"   -Value 8  -Max 96 -Info "Set the magic cost for using Light Arrows´n48 is the maximum amount of the standard magic meter´n96 is the maximum amount of the double magic meter"  -Credits "Admentus"
    CreateReduxTextBox -All -Name "DinsFire"    -Text "Din's Fire"    -Value 12 -Max 96 -Info "Set the magic cost for using Din's Fire´n48 is the maximum amount of the standard magic meter´n96 is the maximum amount of the double magic meter"    -Credits "Admentus"
    CreateReduxTextBox -All -Name "FaroresWind" -Text "Farore's Wind" -Value 12 -Max 96 -Info "Set the magic cost for using Farore's Wind´n48 is the maximum amount of the standard magic meter´n96 is the maximum amount of the double magic meter" -Credits "Admentus"
    CreateReduxTextBox -All -Name "NayrusLove"  -Text "Nayru'sLove"   -Value 24 -Max 96 -Info "Set the magic cost for using Nayru's Love´n48 is the maximum amount of the standard magic meter´n96 is the maximum amount of the double magic meter"  -Credits "Admentus"



    # MINIGAMES #

    CreateReduxGroup    -Tag  "Minigames" -Base 5 -Text "Minigames"
    CreateReduxCheckBox -Name "Dampe"     -Base 4 -Text "Dampé's Digging"         -Info "Dampé's Digging Game is always first try"                         -Credits "Ported from Rando"
  # CreateReduxCheckBox -Name "Ocarina"   -Base 4 -Text "Skullkid Ocarina"        -Info "You only need to clear the first round to get the Piece of Heart" -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "FishSize"  -Base 5 -Text "Lower Fish Requirements" -Info "Fishing has less demanding size requirements"                     -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "FishLoss"  -Base 5 -Text "No Fish RNG Loss"        -Info "Fish no longer randomly let go when trying to reel them in"       -Credits "Ported from Rando"
    
    CreateReduxCheckBox -Name "Bowling"   -Base 5 -Exclude "New Master Quest" -Text "Bombchu Bowling"                                                                                                       -Info "Bombchu Bowling prizes now appear in fixed order instead of random" -Credits "Ported from Rando"
    CreateReduxComboBox -Name "Bowling1"  -Base 5 -Exclude "New Master Quest" -Text "Bowling Reward #1" -Items ("Piece of Heart", "Bomb Bag", "Purple Rupee", "Bombchus") -Values @("64", "28", "4C", "58") -Info "Set the first reward for the Bombchu Bowling Minigame"              -Credits "Ported from Rando" -Default 1 -Column 1 -Row 2
    CreateReduxComboBox -Name "Bowling2"  -Base 5 -Exclude "New Master Quest" -Text "Bowling Reward #2" -Items ("Piece of Heart", "Bomb Bag", "Purple Rupee", "Bombchus") -Values @("64", "28", "4C", "58") -Info "Set the second reward for the Bombchu Bowling Minigame"             -Credits "Ported from Rando" -Default 2
    CreateReduxComboBox -Name "Bowling3"  -Base 5 -Exclude "New Master Quest" -Text "Bowling Reward #3" -Items ("Piece of Heart", "Bomb Bag", "Purple Rupee", "Bombchus") -Values @("64", "28", "4C", "58") -Info "Set the third reward for the Bombchu Bowling Minigame"              -Credits "Ported from Rando" -Default 4
    CreateReduxComboBox -Name "Bowling4"  -Base 5 -Exclude "New Master Quest" -Text "Bowling Reward #4" -Items ("Piece of Heart", "Bomb Bag", "Purple Rupee", "Bombchus") -Values @("64", "28", "4C", "58") -Info "Set the fourth reward for the Bombchu Bowling Minigame"             -Credits "Ported from Rando" -Default 3
    CreateReduxComboBox -Name "Bowling5"  -Base 5 -Exclude "New Master Quest" -Text "Bowling Reward #5" -Items ("Piece of Heart", "Bomb Bag", "Purple Rupee", "Bombchus") -Values @("64", "28", "4C", "58") -Info "Set the fifth reward for the Bombchu Bowling Minigame"              -Credits "Ported from Rando" -Default 3

    if ($Redux.Minigames.Bowling -ne $null) {
        $Redux.Minigames.Bowling.Add_CheckedChanged({ $Redux.Minigames.Bowling1.enabled = $Redux.Minigames.Bowling2.enabled = $Redux.Minigames.Bowling3.enabled = $Redux.Minigames.Bowling4.enabled = $Redux.Minigames.Bowling5.enabled = $this.checked })
        $Redux.Minigames.Bowling1.enabled = $Redux.Minigames.Bowling2.enabled = $Redux.Minigames.Bowling3.enabled = $Redux.Minigames.Bowling4.enabled = $Redux.Minigames.Bowling5.enabled = $Redux.Minigames.Bowling.checked
    }



    # EASY MODE #

    CreateReduxGroup    -Tag  "EasyMode"            -All    -Text "Easy Mode"
    CreateReduxCheckbox -Name "NoShieldSteal"       -All    -Text "No Shield Steal"       -Info "Like-Likes will no longer steal the Deku Shield or Hylian Shield from Link"                                            -Credits "Admentus"
    CreateReduxCheckbox -Name "NoTunicSteal"        -All    -Text "No Tunic Steal"        -Info "Like-Likes will no longer steal the Goron Tunic or Zora Tunic from Link"                                               -Credits "GhostlyDark (ported from Redux)"
    CreateReduxCheckBox -Name "SkipStealthSequence" -Base 3 -Text "Skip Stealth Sequence" -Info "Skip the Castle Courtyard Stealth Sequence and allows you to go straight to the Inner Courtyard"                       -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "SkipTowerEscape"     -Base 3 -Text "Skip Tower Escape"     -Info "Skip the Ganon's Tower Escape Sequence and allows you to go straight to the Ganon boss fight"                          -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "HotRodderGoron"      -Base 5 -Text "Hot Rodder Goron"      -Info "The Hot Rodder Goron no longer needs to be stopped in a specific location before rewarding you with a bigger bomb bag" -Credits "Admentus"
    
}


#==============================================================================================================================================================================================
function CreateTabScenes() {
    
    # MASTER QUEST #

    CreateReduxGroup -Tag "MQ" -Text "Scenes & Dungeons"
    CreateReduxPanel
    CreateReduxRadioButton -Name "Disable"   -Max 6 -SaveTo "Dungeons" -Text "Vanilla"      -Info "All dungeons remain vanilla"                                                                            -Checked
    CreateReduxRadioButton -Name "EnableMQ"  -Max 6 -SaveTo "Dungeons" -Text "Master Quest" -Info "Patch in all Master Quest dungeons"                                                                     -Credits "ShadowOne333"
    CreateReduxRadioButton -Name "EnableUra" -Max 6 -SaveTo "Dungeons" -Text "Ura Quest"    -Info "Patch in all Ura (Disk Drive) Master Quest dungeons"                                                    -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool) & Admentus"
    CreateReduxRadioButton -Name "Select"    -Max 6 -SaveTo "Dungeons" -Text "Select"       -Info "Select which dungeons you want from which version"                                                      -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), ShadowOne333 & Admentus"
    CreateReduxRadioButton -Name "Randomize" -Max 6 -SaveTo "Dungeons" -Text "Randomize"    -Info "Randomize the amount of dungeons from all versions"                                                     -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), ShadowOne333 & Admentus"
    CreateReduxRadioButton -Name "Custom"    -Max 6 -SaveTo "Dungeons" -Text "Custom"       -Info "Patch in custom scenes generated by the Actor Editor`nOnly works if the Actor Editor generated a patch" -Credits "Admentus"



    # MASTER QUEST LOGO #

    CreateReduxGroup -Tag "MQ" -Text "Title Screen Logo"
    CreateReduxPanel
    CreateReduxRadioButton -Name "VanillaLogo"          -Max 5 -SaveTo "Logo" -Text "Vanilla"              -Info "Keep the original title screen logo"               -Checked
    CreateReduxRadioButton -Name "MasterQuestLogo"      -Max 5 -SaveTo "Logo" -Text "Master Quest"         -Info "Use the Master Quest title screen logo"            -Credits "ShadowOne333, GhostlyDark & Admentus"
    CreateReduxRadioButton -Name "NewMasterQuestLogo"   -Max 5 -SaveTo "Logo" -Text "New Master Quest"     -Info "Use the Neq Master Quest title screen logo"        -Credits "Euler"
    CreateReduxRadioButton -Name "UraQuestLogo"         -Max 5 -SaveTo "Logo" -Text "Ura Quest"            -Info "Use the Ura Quest title screen logo"               -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), GhostlyDark & Admentus"
    CreateReduxRadioButton -Name "UraQuestSubtitleLogo" -Max 5 -SaveTo "Logo" -Text "Ura Quest + Subtitle" -Info "Use the Ura Quest title screen logo with subtitle" -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), ShadowOne333, GhostlyDark & Admentus"



    # SELECT - DUNGEONS #

    $Redux.Box.SelectMQ = CreateReduxGroup -Tag "MQ" -Text "Select - Dungeons"
    $items   = @("Vanilla", "Master Quest", "Ura Quest")
    $credits = "ZethN64, Sakura, Frostclaw, Steve(ToCoool), ShadowOne333 & Admentus"
    CreateReduxComboBox -Name "InsideTheDekuTree"    -Text "Inside the Deku Tree"     -Items $items -NoDefault -Info "Patch Inside the Deku Tree to Master Quest"     -Credits $credits
    CreateReduxComboBox -Name "DodongosCavern"       -Text "Dodongo's Cavern"         -Items $items -NoDefault -Info "Patch Dodongo's Cavern to Master Quest"         -Credits $credits
    CreateReduxComboBox -Name "InsideJabuJabusBelly" -Text "Inside Jabu-Jabu's Belly" -Items $items -NoDefault -Info "Patch Inside Jabu-Jabu's Belly to Master Quest" -Credits $credits
    CreateReduxComboBox -Name "ForestTemple"         -Text "Forest Temple"            -Items $items -NoDefault -Info "Patch Forest Temple to Master Quest"            -Credits $credits
    CreateReduxComboBox -Name "FireTemple"           -Text "Fire Temple"              -Items $items -NoDefault -Info "Patch Fire Temple to Master Quest"              -Credits $credits
    CreateReduxComboBox -Name "WaterTemple"          -Text "Water Temple"             -Items $items -NoDefault -Info "Patch Water Temple to Master Quest"             -Credits $credits
    CreateReduxComboBox -Name "ShadowTemple"         -Text "Shadow Temple"            -Items $items -NoDefault -Info "Patch Shadow Temple to Master Quest"            -Credits $credits
    CreateReduxComboBox -Name "SpiritTemple"         -Text "Spirit Temple"            -Items $items -NoDefault -Info "Patch Spirit Temple to Master Quest"            -Credits $credits
    CreateReduxComboBox -Name "IceCavern"            -Text "Ice Cavern"               -Items $items -NoDefault -Info "Patch Ice Cavern to Master Quest"               -Credits $credits
    CreateReduxComboBox -Name "BottomOfTheWell"      -Text "Bottom of the Well"       -Items $items -NoDefault -Info "Patch Bottom of the Well to Master Quest"       -Credits $credits
    CreateReduxComboBox -Name "GerudoTrainingGround" -Text "Gerudo Training Ground"   -Items $items -NoDefault -Info "Patch Gerudo Training Ground to Master Quest"   -Credits $credits
    CreateReduxComboBox -Name "InsideGanonsCastle"   -Text "Inside Ganon's Castle"    -Items $items -NoDefault -Info "Patch Inside Ganon's Castle to Master Quest"    -Credits $credits



    # RANDOMIZE - DUNGEONS #

    $Redux.Box.RandomizeMQ = CreateReduxGroup -Tag "MQ" -Text "Randomize - Dungeons"
    $Items = @("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12")
    CreateReduxComboBox -Name "Minimum" -Text "Minimum" -Default 1            -Items $Items
    CreateReduxComboBox -Name "Maximum" -Text "Maximum" -Default $Items.Count -Items $Items



    # VANILLA DUNGEON ADJUSTMENTS #

    $Redux.Box.VanillaDungeons = CreateReduxGroup -Tag "Scenes" -Text "Vanilla Dungeon Adjustements"
    CreateReduxCheckBox -Name "DodongosCavernGossipStone" -Text "Dodongo's Cavern Gossip Stone" -Info "Fix the Gossip Stones in Dodongo's Cavern so that a fairy can be spawned from them"                                                  -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "WaterTempleActors"         -Text "Add Water Temple Actors"       -Info "Add several actors in the Water Temple`nUnreachable hookshot spot in room 22, three out of bounds pots, restore two Keese in room 1" -Credits "Chez Cousteau"
    CreateReduxCheckBox -Name "RemoveDisruptiveText"      -Text "Remove Disruptive Text"        -Info "Remove disruptive text from Gerudo Training Ground and early Shadow Temple"                                                          -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "NaviTarget"                -Text "Navi Targettable Spots"        -Info "Fix several spots in dungeons which Navi could not target for Link"                                                                  -Credits "Chez Cousteau"



    # SCENE ADJUSTMENTS #

    $Redux.Box.Scenes = CreateReduxGroup -Tag "Scenes" -Text "Scene Adjustements"
    CreateReduxCheckBox -Name "MuteOwls"           -Text "Mute Owls"                    -Info "Kaepora Gaebora the owl will no longer interrupt Link with tutorials"                                                                                 -Credits "Chez Cousteau"
    CreateReduxCheckBox -Name "OverworldSkyboxes"  -Text "Overworld Skyboxes"           -Info "Use day and night skyboxes for all overworld areas lacking one"                                                                                       -Credits "Admentus (ported) & BrianMp16 (AR Code)"
    CreateReduxCheckBox -Name "Graves"             -Text "Graveyard Graves"             -Info "The grave holes in Kakariko Graveyard behave as in the Rev 1 revision`nThe edges no longer force Link to grab or jump over them when trying to enter" -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "VisibleGerudoTent"  -Text "Visible Gerudo Tent"          -Info "Make the tent in the Gerudo Valley during the Child era visible`nThe tent was always accessible, just invisible"                                      -Credits "Chez Cousteau" -Warning "Makes the bridge for Child Link broken"
    CreateReduxCheckBox -Name "CorrectTimeDoor"    -Text "Correct Door of Time Coords"  -Info "Fix the positioning of the Temple of Time door, so you can not skip past it"                                                                          -Credits "Chez Cousteau"
    CreateReduxCheckBox -Name "OpenTimeDoor"       -Text "Fix Door of Time Unlock"      -Info "Fix Door of Time not opening on first visit"                                                                                                          -Credits "Rando"
    CreateReduxCheckBox -Name "ChildColossusFairy" -Text "Fix Child Colossus Fairy"     -Info 'Fix "...???" textbox outside Child Colossus Fairy to use the right flag and disappear once the wall is destroyed'                                     -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "CraterFairy"        -Text "Fix Crater Fairy"             -Info 'Remove the "...???" textbox outside the Crater Fairy'                                                                                                 -Credits "Ported from Rando"

    

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
    EnableForm -Form $Redux.Box.Scenes -Enable (!$Redux.MQ.Custom.Checked)
    $Redux.MQ.Custom.Add_CheckedChanged({ EnableForm -Form $Redux.Box.Scenes -Enable (!$Redux.MQ.Custom.Checked) })

}



#==============================================================================================================================================================================================
function CreateTabColors() {
    
    # EQUIPMENT COLORS #

    CreateReduxGroup -Tag "Colors" -All -Text "Equipment Colors"
    $Redux.Colors.Equipment = @()
    $items = @("Kokiri Green", "Goron Red", "Zora Blue"); $postItems = @("Randomized", "Custom"); $Files = ($GameFiles.Textures + "\Tunic"); $Randomize = '"Randomized" fully randomizes the colors each time the patcher is opened'
    if ($GamePatch.settings -eq "Gold Quest") { $items = @("Gold Quest Gold", "Gold Quest Purple", "Gold Quest White") + $items }
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "KokiriTunic" -Column 1 -Row 1 -All -Text "Kokiri Tunic Color" -Default 1 -Length 230 -Shift 40 -Items $items -PostItems $postItems -FilePath $Files -Info ("Select a color scheme for the Kokiri Tunic`n" + $Randomize) -Credits "Ported from Rando"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "GoronTunic"  -Column 1 -Row 2 -All -Text "Goron Tunic Color"  -Default 2 -Length 230 -Shift 40 -Items $items -PostItems $postItems -FilePath $Files -Info ("Select a color scheme for the Goron Tunic`n"  + $Randomize) -Credits "Ported from Rando"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "ZoraTunic"   -Column 1 -Row 3 -All -Text "Zora Tunic Color"   -Default 3 -Length 230 -Shift 40 -Items $items -PostItems $postItems -FilePath $Files -Info ("Select a color scheme for the Zora Tunic`n"   + $Randomize) -Credits "Ported from Rando"
    $Items = @("Silver", "Gold", "Black", "Green", "Blue", "Bronze", "Red", "Sky Blue", "Pink", "Magenta", "Orange", "Lime", "Purple", "Randomized", "Custom")
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "SilverGauntlets"   -Column 4 -Row 1 -Adult -Text "Silver Gauntlets Color"    -Default 1 -Length 230 -Shift 40 -Items $Items -Info ("Select a color scheme for the Silver Gauntlets`n" + $Randomize) -Credits "Ported from Rando"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "GoldenGauntlets"   -Column 4 -Row 2 -Adult -Text "Golden Gauntlets Color"    -Default 2 -Length 230 -Shift 40 -Items $Items -Info ("Select a color scheme for the Golden Gauntlets`n" + $Randomize) -Credits "Ported from Rando"
    $Items =  @("Red", "Green", "Blue", "Yellow", "Cyan", "Magenta", "Orange", "Gold", "Purple", "Pink", "Randomized", "Custom")
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "MirrorShieldFrame" -Column 4 -Row 3 -Adult -Text "Mirror Shield Frame Color" -Default 1 -Length 230 -Shift 40 -Items $Items -Info ("Select a color scheme for the Mirror Shield Frame`n" + $Randomize) -Warning "This option might not work for every custom player model" -Credits "Ported from Rando"
    $items = $null

    # Equipment Colors - Buttons
    $Buttons = @()
    $Buttons += CreateReduxButton -Column 3 -Row 1 -Tag $Buttons.Count -Width 100 -All   -Text "Kokiri Tunic"     -Info "Select the color you want for the Kokiri Tunic" -Credits "Ported from Rando"
    $Buttons += CreateReduxButton -Column 3 -Row 2 -Tag $Buttons.Count -Width 100 -All   -Text "Goron Tunic"      -Info "Select the color you want for the Goron Tunic"  -Credits "Ported from Rando"
    $Buttons += CreateReduxButton -Column 3 -Row 3 -Tag $Buttons.Count -Width 100 -All   -Text "Zora Tunic"       -Info "Select the color you want for the Zora Tunic"   -Credits "Ported from Rando"
    if ($Redux.Colors.SilverGauntlets -ne $null) {
        $Buttons += CreateReduxButton -Column 6 -Row 1 -Tag $Buttons.Count -Width 100 -Adult -Text "Silver Gaunlets"  -Info "Select the color you want for the Silver Gauntlets"           -Credits "Ported from Rando"
        $Buttons += CreateReduxButton -Column 6 -Row 2 -Tag $Buttons.Count -Width 100 -Adult -Text "Golden Gauntlets" -Info "Select the color you want for the Golden Gauntlets"           -Credits "Ported from Rando"
        $Buttons += CreateReduxButton -Column 6 -Row 3 -Tag $Buttons.Count -Width 100 -Adult -Text "Mirror Shield"    -Info "Select the color you want for the frame of the Mirror Shield" -Credits "Ported from Rando"
    }

    # Equipment Colors - Dialogs
    $Redux.Colors.SetEquipment = @()
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "1E691B" -Name "SetKokiriTunic" -IsGame -Button $Buttons[0]
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "641400" -Name "SetGoronTunic"  -IsGame -Button $Buttons[1]
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "003C64" -Name "SetZoraTunic"   -IsGame -Button $Buttons[2]
    if ($Redux.Colors.SilverGauntlets -ne $null) {
        $Redux.Colors.SetEquipment += CreateColorDialog -Color "FFFFFF" -Name "SetSilverGauntlets"   -IsGame -Button $Buttons[3]
        $Redux.Colors.SetEquipment += CreateColorDialog -Color "FECF0F" -Name "SetGoldenGauntlets"   -IsGame -Button $Buttons[4]
        $Redux.Colors.SetEquipment += CreateColorDialog -Color "D70000" -Name "SetMirrorShieldFrame" -IsGame -Button $Buttons[5]
    }

    # Equipment Colors - Labels
    $Redux.Colors.EquipmentLabels = @()
    for ($i=0; $i -lt $Buttons.length; $i++) {
        $Buttons[$i].Add_Click({ $Redux.Colors.SetEquipment[[uint16]$this.Tag].ShowDialog(); $Redux.Colors.Equipment[[uint16]$this.Tag].Text = "Custom"; $Redux.Colors.EquipmentLabels[[uint16]$this.Tag].BackColor = $Redux.Colors.SetEquipment[[uint16]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetEquipment[[uint16]$this.Tag].Tag] = $Redux.Colors.SetEquipment[[uint16]$this.Tag].Color.Name })
        if ($i -lt 3)   { $Redux.Colors.EquipmentLabels += CreateReduxColoredLabel -All   -Link $Buttons[$i]  -Color $Redux.Colors.SetEquipment[$i].Color }
        else            { $Redux.Colors.EquipmentLabels += CreateReduxColoredLabel -Adult -Link $Buttons[$i]  -Color $Redux.Colors.SetEquipment[$i].Color }
    }

    $Redux.Colors.Equipment[0].Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[0] -Dialog $Redux.Colors.SetEquipment[0] -Label $Redux.Colors.EquipmentLabels[0] })
    SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[0] -Dialog $Redux.Colors.SetEquipment[0] -Label $Redux.Colors.EquipmentLabels[0]
    $Redux.Colors.Equipment[1].Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[1] -Dialog $Redux.Colors.SetEquipment[1] -Label $Redux.Colors.EquipmentLabels[1] })
    SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[1] -Dialog $Redux.Colors.SetEquipment[1] -Label $Redux.Colors.EquipmentLabels[1]
    $Redux.Colors.Equipment[2].Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[2] -Dialog $Redux.Colors.SetEquipment[2] -Label $Redux.Colors.EquipmentLabels[2] })
    SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[2] -Dialog $Redux.Colors.SetEquipment[2] -Label $Redux.Colors.EquipmentLabels[2]

    if ($Redux.Colors.SilverGauntlets -ne $null) {
        $Redux.Colors.Equipment[3].Add_SelectedIndexChanged({ SetGauntletsColorsPreset -ComboBox $Redux.Colors.Equipment[3] -Dialog $Redux.Colors.SetEquipment[3] -Label $Redux.Colors.EquipmentLabels[3] })
        SetGauntletsColorsPreset -ComboBox $Redux.Colors.Equipment[5] -Dialog $Redux.Colors.SetEquipment[5] -Label $Redux.Colors.EquipmentLabels[5]
        $Redux.Colors.Equipment[4].Add_SelectedIndexChanged({ SetGauntletsColorsPreset -ComboBox $Redux.Colors.Equipment[4] -Dialog $Redux.Colors.SetEquipment[4] -Label $Redux.Colors.EquipmentLabels[4] })
        SetGauntletsColorsPreset -ComboBox $Redux.Colors.Equipment[4] -Dialog $Redux.Colors.SetEquipment[4] -Label $Redux.Colors.EquipmentLabels[4]

        $Redux.Colors.Equipment[5].Add_SelectedIndexChanged({ SetMirrorShieldFrameColorsPreset -ComboBox $Redux.Colors.Equipment[5] -Dialog $Redux.Colors.SetEquipment[5] -Label $Redux.Colors.EquipmentLabels[5] })
        SetMirrorShieldFrameColorsPreset -ComboBox $Redux.Colors.Equipment[5] -Dialog $Redux.Colors.SetEquipment[5] -Label $Redux.Colors.EquipmentLabels[5]
    }


    # COLORS #

    CreateSpinAttackColorOptions
    CreateSwordTrailColorOptions



    # FAIRY COLORS #

    CreateFairyColorOptions -Name "Navi"

    CreateReduxCheckBox -Name "BetaNavi" -All -Text "Beta Navi Colors" -Info "Use the Beta colors for Navi" -Column 1 -Row 2
    $Redux.Colors.BetaNavi.Add_CheckedChanged({ EnableElem -Elem $Redux.Colors.Fairy -Active (!$this.checked) })
    EnableElem -Elem $Redux.Colors.Fairy -Active (!$Redux.Colors.BetaNavi.Checked)



    # RUPEE ICON COLOR #

    if ($GamePatch.settings -eq "Gold Quest") { $preset = 5; $color = "FFFF00" } else { $preset = 1; $color = "C8FF64" }
    CreateRupeeVanillaColorOptions -Preset $preset -Color $color
    $preset = $color = $null



    # MISC COLORS #

    CreateReduxGroup -Tag "Colors" -Text "Misc Colors"

    CreateReduxCheckBox -Name "PauseScreenColors" -All -Text "MM Pause Screen Colors" -Info "Use the Pause Screen color scheme from Majora's Mask" -Credits "Garo-Mastah"

}



#==============================================================================================================================================================================================
function CreateTabEquipment() {
    
    # UNLOCK CHILD RESTRICTIONS #

    CreateReduxGroup    -Tag  "Unlock"        -Child -Text "Unlock Child Restrictions"
    CreateReduxCheckBox -Name "Tunics"        -Child -Text "Unlock Tunics"        -Info "Child Link is able to use the Goron Tunic and Zora Tunic`nSince you might want to walk around in style as well when you are young`nThe dialogue script will be adjusted to reflect this (only for English)" -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "MasterSword"   -Child -Text "Unlock Master Sword"  -Info "Child Link is able to use the Master Sword`nThe Master Sword does twice as much damage as the Kokiri Sword"                                          -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "GiantsKnife"   -Child -Text "Unlock Giant's Knife" -Info "Child Link is able to use the Giant's Knife / Biggoron Sword`nThe Giant's Knife / Biggoron Sword does four times as much damage as the Kokiri Sword" -Credits "GhostlyDark" -Warning "The Giant's Knife / Biggoron Sword appears as if Link if thrusting the sword through the ground"
    CreateReduxCheckBox -Name "MirrorShield"  -Child -Text "Unlock Mirror Shield" -Info "Child Link is able to use the Mirror Shield"                                                                                                         -Credits "GhostlyDark" -Warning "The Mirror Shield appears as invisible but can still reflect magic or sunlight"
    CreateReduxCheckBox -Name "Boots"         -Child -Text "Unlock Boots"         -Info "Child Link is able to use the Iron Boots and Hover Boots"                                                                                            -Credits "GhostlyDark" -Warning "The Iron and Hover Boots appears as the Kokiri Boots"
    CreateReduxCheckBox -Name "Gauntlets"     -Child -Text "Unlock Gauntlets"     -Info "Child Link is able to use the Silver and Golden Gauntlets"                                                                                           -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxComboBox -Name "MegatonHammer" -Child -Text "Unlock Hammer"        -Info "Child Link is able to use the Megaton Hammer" -Items @("Disabled", "Unlock Only", "Show Only", "Unlock and Show")                                    -Credits "GhostlyDark" -Warning "The Megaton Hammer appears as invisible on custom models"


    # UNLOCK ADULT RESTRICTIONS #

    CreateReduxGroup    -Tag  "Unlock"         -Adult -Text "Unlock Adult Restrictions"
    CreateReduxCheckBox -Name "KokiriSword"    -Adult -Text "Unlock Kokiri Sword" -Info "Adult Link is able to use the Kokiri Sword`nThe Kokiri Sword does half as much damage as the Master Sword" -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "DekuShield"     -Adult -Text "Unlock Deku Shield"  -Info "Adult Link is able to use the Deku Shield"                                                                 -Credits "GhostlyDark" -Warning "The Deku Shield appears as invisible but can still be burned up by fire"
    CreateReduxCheckBox -Name "FairySlingshot" -Adult -Text "Unlock Slingshot"    -Info "Adult Link is able to use the Fairy Slingshot"                                                             -Credits "GhostlyDark" -Warning "The Fairy Slingshot appears as the Fairy Bow"
    CreateReduxCheckBox -Name "Boomerang"      -Adult -Text "Unlock Boomerang"    -Info "Adult Link is able to use the Boomerang"                                                                   -Credits "GhostlyDark" -Warning "The Boomerang appears as invisible"
    CreateReduxCheckBox -Name "DekuSticks"     -Adult -Text "Unlock Deku Sticks"  -Info "Adult Link is able to use the Deku Sticks"                                                                 -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "CrawlHole"      -Adult -Text "Unlock Crawl Hole"   -Info "Adult Link can now crawl through holes"                                                            -Native -Credits "Admentus"



    # EQUIPMENT #

    CreateReduxGroup    -Tag  "Equipment"           -All     -Text "Equipment Adjustments"
    CreateReduxCheckBox -Name "UnsheathSword"       -All     -Text "Unsheath Sword"              -Info "The sword is unsheathed first before immediately swinging it"                                  -Credits "Admentus"
    CreateReduxCheckBox -Name "FireproofDekuShield" -Base 4  -Text "Fireproof Deku Shield"       -Info "The Deku Shield turns into an fireproof shield, which will not burn up anymore"                -Credits "Admentus (ported) & Three Pendants (ROM patch)"
    CreateReduxCheckBox -Name "HerosBow"            -Adult   -Text "Hero's Bow"                  -Info "Replace the Fairy Bow icon and text with the Hero's Bow"                                       -Credits "GhostlyDark (ported textures) & Admentus (dialogue)"
    CreateReduxCheckBox -Name "Hookshot"            -Adult   -Text "Termina Hookshot"            -Info "Replace the Hyrule Hookshot icon with the Termina Hookshot"                                    -Credits "GhostlyDark (ported textures)"
    CreateReduxCheckBox -Name "GoronBraceletFix"    -Adult   -Text "Keep Goron's Bracelet Color" -Info "Prevent grayscale on Goron's Bracelet, as Adult Link isn't able to push big blocks without it" -Credits "Ported from Redux"
    CreateReduxTextBox  -Name "GiantKnifeHealth"    -Adult   -Text "Knife Durability"            -Info "Set the durability strength of the Giant's Knife" -Value 8 -Min 1 -Max 255                     -Credits "Admentus"
    
    CreateReduxGroup    -Tag  "Equipment"     -All   -Text "Swords & Shields"
    CreateReduxComboBox -Name "KokiriSword"   -Child -Text "Kokiri Sword"     -Items @("Kokiri Sword")                      -FilePath ($GameFiles.Textures + "\Equipment\Kokiri Sword")  -Ext @("icon", "bin")   -Info "Select an alternative for the icon and text of the Kokiri Sword"     -Credits "Admentus (injects) & GhostlyDark (injects) & CYB3RTR0N (beta icon)"
    CreateReduxComboBox -Name "MasterSword"   -Adult -Text "Master Sword"     -Items @("Master Sword")                      -FilePath ($GameFiles.Textures + "\Equipment\Master Sword")  -Ext @("icon", "bin")   -Info "Select an alternative for the icon and text of the Master Sword"     -Credits "Admentus (injects) & GhostlyDark (injects) & CYB3RTR0N (beta icon)"
    CreateReduxComboBox -Name "GiantsKnife"   -Adult -Text "Giant's Knife"    -Items @("Giant's Knife", "Biggoron's Sword") -FilePath ($GameFiles.Textures + "\Equipment\Master Sword")  -Ext @("icon", "bin")   -Info "Select an alternative for the icon and text of the Giant's Knife"    -Credits "Admentus (injects) & GhostlyDark (injects) & CYB3RTR0N (beta icon)"
    CreateReduxComboBox -Name "BiggoronSword" -Adult -Text "Biggoron's Sword" -Items @("Biggoron's Sword", "Giant's Knife") -FilePath ($GameFiles.Textures + "\Equipment\Master Sword")  -Ext @("icon", "bin")   -Info "Select an alternative for the icon and text of the Biggoron's Sword" -Credits "Admentus (injects) & GhostlyDark (injects) & CYB3RTR0N (beta icon)"
    CreateReduxTextBox  -Name "SwordHealth"   -Adult -Text "Sword Health"     -Value 8 -Min 1 -Max 255 -Length 3                                                                                                 -Info "Set the amount of hits the Giant's Knife can take before it breaks"  -Credits "Admentus"

    if ($GamePatch.settings -eq "Dawn & Dusk") { $item = "Dawn & Dusk Shield" } elseif ($GamePatch.settings -eq "Gold Quest") { $item = "Gold Quest Shield" } else { $item = "Deku Shield" }
    
    CreateReduxComboBox -Name "DekuShield"    -Child -Text "Deku Shield"      -Items @("Deku Shield") -Default $item        -FilePath ($GameFiles.Textures + "\Equipment\Deku Shield")   -Ext @("icon", "front") -Info "Select an alternative for the appearence of the Deku Shield"         -Credits "Admentus (injects) & GhostlyDark (injects), ZombieBrainySnack (textures) & LuigiBlood (texture)" -Column 1 -Row 3
    CreateReduxComboBox -Name "HylianShield"  -All   -Text "Hylian Shield"    -Items @("Hylian Shield")                     -FilePath ($GameFiles.Textures + "\Equipment\Hylian Shield") -Ext @("icon", "bin")   -Info "Select an alternative for the appearence of the Hylian Shield"       -Credits "Admentus (injects) & GhostlyDark (injects), CYB3RTR0N (icons), sanguinetti (Beta / Red Shield textures) & LuigiBlood (texture)"
    CreateReduxComboBox -Name "MirrorShield"  -Adult -Text "Mirror Shield"    -Items @("Mirror Shield")                     -FilePath ($GameFiles.Textures + "\Equipment\Mirror Shield") -Ext @("icon", "bin")   -Info "Select an alternative for the appearence of the Mirror Shield"       -Credits "Admentus (injects) & GhostlyDark (injects)"

    if ($Redux.Equipment.GiantsKnife -ne $null) {
        $Redux.Equipment.GiantsKnife.Add_SelectedIndexChanged( {
            if ($this.text.replace(" (default)", "") -eq $Redux.Equipment.BiggoronSword.text.replace(" (default)", "") ) {
                $this.selectedIndex = 0
                $Redux.Equipment.BiggoronSword.selectedIndex = 0
            }
        } )

        $Redux.Equipment.BiggoronSword.Add_SelectedIndexChanged( {
            if ($Redux.Equipment.GiantsKnife.text.replace(" (default)", "") -eq $this.text.replace(" (default)", "") ) {
                $Redux.Equipment.GiantsKnife.selectedIndex = 0
                $this.selectedIndex = 0
            }
        } )

        if ($Redux.Equipment.GiantsKnife.text.replace(" (default)", "")  -eq $Redux.Equipment.BiggoronSword.text.replace(" (default)", "") ) {
            $Redux.Equipment.GiantsKnife.selectedIndex = 0
            $Redux.Equipment.BiggoronSword.selectedIndex = 0
        }
    }



    # HITBOX #

    CreateReduxGroup  -Tag  "Hitbox"            -All -Text "Sliders" -Height 4.2
    CreateReduxSlider -Name "KokiriSword"       -Child                 -Column 1 -Row 1 -Default 3000 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Kokiri Sword"    -Info "Set the length of the hitbox of the Kokiri Sword"                   -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "MasterSword"       -Adult                 -Column 3 -Row 1 -Default 4000 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Master Sword"    -Info "Set the length of the hitbox of the Master Sword"                   -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "GiantsKnife"       -Adult                 -Column 5 -Row 1 -Default 5500 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Giant's Knife"   -Info "Set the length of the hitbox of the Giant's Knife / Biggoron Sword" -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "BrokenGiantsKnife" -Adult                 -Column 1 -Row 2 -Default 1500 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Broken Knife"    -Info "Set the length of the hitbox of the Broken Giant's Knife"           -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "MegatonHammer"     -Adult -Expose "Dawn"  -Column 3 -Row 2 -Default 2500 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Megaton Hammer"  -Info "Set the length of the hitbox of the Megaton Hammer"                 -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "ShieldRecoil"      -All                   -Column 5 -Row 2 -Default 4552 -Min 0   -Max 8248 -Freq 512 -Small 256 -Large 512 -Text "Shield Recoil"   -Info "Set the pushback distance when getting hit while shielding"         -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxSlider -Name "Hookshot"          -Adult                 -Column 1 -Row 3 -Default 13   -Min 0   -Max 255  -Freq 16  -Small 8   -Large 16  -Text "Hookshot Length" -Info "Set the length of the Hookshot"                                     -Credits "AndiiSyn"
    CreateReduxSlider -Name "Longshot"          -Adult -Exclude "Gold" -Column 3 -Row 3 -Default 26   -Min 0   -Max 255  -Freq 16  -Small 8   -Large 16  -Text "Longshot Length" -Info "Set the length of the Longshot"                                     -Credits "AndiiSyn"
    CreateReduxSlider -Name "Longshot"                 -Expose  "Gold" -Column 3 -Row 3 -Default 104  -Min 0   -Max 255  -Freq 16  -Small 8   -Large 16  -Text "Longshot Length" -Info "Set the length of the Longshot"                                     -Credits "AndiiSyn"



    # EQUIPMENT PREVIEWS #

    CreateReduxGroup -Tag "Equipment" -All -Text "Equipment Previews"
    $Last.Group.Height = (DPISize 140)

    CreateImageBox -x 40  -y 30 -w 80 -h 80  -Child -Name "DekuShieldIconPreview"
    CreateImageBox -x 160 -y 10 -w 80 -h 120 -Child -Name "DekuShieldPreview";      if ($Redux.Equipment.DekuShield   -ne $null)   { $Redux.Equipment.DekuShield.Add_SelectedIndexChanged(   { ShowEquipmentPreview } ) }
    CreateImageBox -x 320 -y 30 -w 80 -h 80  -All   -Name "HylianShieldIconPreview"
    CreateImageBox -x 440 -y 10 -w 80 -h 120 -All   -Name "HylianShieldPreview";    if ($Redux.Equipment.HylianShield -ne $null)   { $Redux.Equipment.HylianShield.Add_SelectedIndexChanged( { ShowEquipmentPreview } ) }
    CreateImageBox -x 600 -y 30 -w 80 -h 80  -Adult -Name "MirrorShieldIconPreview"
    CreateImageBox -x 720 -y 10 -w 80 -h 120 -Adult -Name "MirrorShieldPreview";    if ($Redux.Equipment.MirrorShield -ne $null)   { $Redux.Equipment.MirrorShield.Add_SelectedIndexChanged( { ShowEquipmentPreview } ) }
    CreateImageBox -x 840 -y 30 -w 80 -h 80  -Child -Name "KokiriSwordIconPreview"; if ($Redux.Equipment.KokiriSword  -ne $null)   { $Redux.Equipment.KokiriSword.Add_SelectedIndexChanged(  { ShowEquipmentPreview } ) }
    CreateImageBox -x 960 -y 30 -w 80 -h 80  -Adult -Name "MasterSwordIconPreview"; if ($Redux.Equipment.MasterSword  -ne $null)   { $Redux.Equipment.MasterSword.Add_SelectedIndexChanged(  { ShowEquipmentPreview } ) }
    ShowEquipmentPreview



    # STARTING UPGRADES #

    CreateReduxGroup    -Tag  "Save"          -All                               -Text "Starting Upgrades"
    CreateReduxComboBox -Name "DekuSticks"    -Child                             -Text "Deku Sticks"     -Items ("Standard", "Big", "Biggest")                                         -Info "Set the starting capacity upgrade level for the Deku Sticks"
    CreateReduxComboBox -Name "DekuNuts"      -All                               -Text "Deku Nuts"       -Items ("Standard", "Big", "Biggest")                                         -Info "Set the starting capacity upgrade level for the Deku Nuts"
    CreateReduxComboBox -Name "BulletBag"     -Child                             -Text "Bullet Seed Bag" -Items ("Standard", "Big", "Biggest")                                         -Info "Set the starting capacity upgrade level for the Bullet Seed Bag"
    CreateReduxComboBox -Name "Quiver"        -Adult                             -Text "Quiver"          -Items ("Standard", "Big", "Biggest")                                         -Info "Set the starting capacity upgrade level for the Quiver"
    CreateReduxComboBox -Name "BombBag"       -All                               -Text "Bomb Bag"        -Items ("Standard", "Big", "Biggest")                                         -Info "Set the starting capacity upgrade level for the Bomb Bag"
    CreateReduxComboBox -Name "Strength"      -All                               -Text "Strength"        -Items ("None", "Goron's Bracelet", "Silver Gauntlets", "Golden Gauntlets")   -Info "Set the starting capacity upgrade level for the Bracelet / Gauntlets"
    CreateReduxComboBox -Name "Scale"         -All                               -Text "Scale"           -Items ("None", "Silver Scale", "Golden Scale")                               -Info "Set the starting capacity upgrade level for the Scale"
    CreateReduxComboBox -Name "Wallet"        -All                               -Text "Wallet"          -Items ("Base Wallet", "Adult's Wallet", "Giant's Wallet", "Tycoon's Wallet") -Info "Set the starting capacity upgrade level for the Wallet" -Warning 'The "Tycoon Wallet" is unused and has issues'
    CreateReduxTextBox  -Name "Rupees"        -All                               -Text "Rupees"          -Value 0 -Min 0 -Max 9999 -Length 4                                           -Info "Start a new save file with the chosen amount of Rupees"
    CreateReduxTextBox  -Name "Hearts"        -All -Exclude @("Gold", "Bombiwa") -Text "Hearts"          -Value 3 -Min 1 -Max 20                                                       -Info "Start a new save file with the chosen amount of hearts"
    CreateReduxTextBox  -Name "Hearts"             -Expose  "Gold"               -Text "Hearts"          -Value 2 -Min 1 -Max 20                                                       -Info "Start a new save file with the chosen amount of hearts"
    CreateReduxTextBox  -Name "Hearts"             -Expose  "Bombiwa"            -Text "Hearts"          -Value 5 -Min 1 -Max 20                                                       -Info "Start a new save file with the chosen amount of hearts"
    CreateReduxCheckBox -Name "DoubleDefense" -All                               -Text "Double Defense"                                                                                -Info "Start a new save file with the double defense upgrade"
    CreateReduxCheckBox -Name "Magic"         -All                               -Text "Magic"                                                                                         -Info "Start a new save file with the magic meter"
    CreateReduxCheckBox -Name "DoubleMagic"   -All                               -Text "Double Magic"                                                                                  -Info "Start a new save file with the double magic upgrade"



    # STARTING QUEST #

    CreateReduxGroup    -Tag  "Save"            -All -Text "Starting Quest Items"
    CreateReduxCheckBox -Name "KokiriEmerald"   -All -Text "Kokiri Emerald"           -Info "Start a new save file with Kokiri Emerald"
    CreateReduxCheckBox -Name "GoronRuby"       -All -Text "Goron Ruby"               -Info "Start a new save file with Goron Ruby"
    CreateReduxCheckBox -Name "ZoraSapphire"    -All -Text "Zora Sapphire"            -Info "Start a new save file with Zora Sapphire"
    CreateReduxCheckBox -Name "ForestMedallion" -All -Text "Forest Medallion"         -Info "Start a new save file with the Forest Medallion"
    CreateReduxCheckBox -Name "FireMedallion"   -All -Text "Fire Medallion"           -Info "Start a new save file with the Fire Medallion"
    CreateReduxCheckBox -Name "WaterMedallion"  -All -Text "Water Medallion"          -Info "Start a new save file with the Water Medallion"
    CreateReduxCheckBox -Name "ShadowMedallion" -All -Text "Shadow Medallion"         -Info "Start a new save file with the Shadow Medallion"
    CreateReduxCheckBox -Name "SpiritMedallion" -All -Text "Spirit Medallion"         -Info "Start a new save file with the Spirit Medallion"
    CreateReduxCheckBox -Name "LightMedallion"  -All -Text "Light Medallion"          -Info "Start a new save file with the Light Medallion"
    CreateReduxCheckBox -Name "GerudoCard"      -All -Text "Gerudo Card"              -Info "Start a new save file with the Gerudo Card"
    CreateReduxCheckBox -Name "StoneOfAgony"    -All -Text "Stone of Agony"           -Info "Start a new save file with the Stone of Agony"
    CreateReduxTextBox  -Name "GoldSkulltulas"  -All -Text "Gold Skulltulas" -Max 100 -Info "Start a new save file with the chosen amount of Gold Skulltulas"



    # STARTING DEBUG #

    CreateReduxGroup    -Tag  "Save"           -All -Text "Starting Debug Items"
    CreateReduxCheckBox -Name "NoDungeonItems" -All -Text "No Dungeon Items" -Info "Starting a new debug save file no longer grants the Dungeon Map, Compass and Boss Key for dungeons"
    CreateReduxCheckBox -Name "NoDungeonKeys"  -All -Text "No Dungeon Keys"  -Info "Starting a new debug save file no longer grants any small keys for dungeons"
    CreateReduxCheckBox -Name "NoQuestStatus"  -All -Text "No Quest Status"  -Info "Starting a new debug save file no longer grants any items from the Quest Status subscreen"
    CreateReduxCheckBox -Name "NoItems"        -All -Text "No Inventory"     -Info "Starting a new debug save file no longer grants any items from the Select Item subscreen"
    CreateReduxCheckBox -Name "NoEquipment"    -All -Text "No Equipment"     -Info "Starting a new debug save file no longer grants any items from the Equipment subscreen"
    CreateReduxCheckBox -Name "NoUpgrades"     -All -Text "No Upgrades"      -Info "Starting a new debug save file no longer grants any upgrades from the Equipment subscreen"



    # STARTING EQUIPMENT #

    CreateReduxGroup    -Tag  "Save"          -All   -Text "Starting Equipment"
    CreateReduxCheckBox -Name "KokiriSword"   -Child -Text "Kokiri Sword"   -Info "Start a new save file with the Kokiri Sword"
    CreateReduxCheckBox -Name "MasterSword"   -Adult -Text "Master Sword"   -Info "Start a new save file with the Master Sword"
    CreateReduxCheckBox -Name "GiantsKnife"   -Adult -Text "Giant's Knife"  -Info "Start a new save file with the Giant's Knife"
    CreateReduxCheckBox -Name "BiggoronSword" -Adult -Text "Biggoron Sword" -Info "Start a new save file with the Biggoron Sword instead of the Giant's Knife" -Link $Redux.Save.GiantsKnife
    CreateReduxCheckBox -Name "DekuShield"    -Child -Text "Deku Shield"    -Info "Start a new save file with the Deku Shield"
    CreateReduxCheckBox -Name "HylianShield"  -All   -Text "Hylian Shield"  -Info "Start a new save file with the Hylian Shield"
    CreateReduxCheckBox -Name "MirrorShield"  -Adult -Text "Mirror Shield"  -Info "Start a new save file with the Mirror Shield"
    CreateReduxCheckBox -Name "GoronTunic"    -Adult -Text "Goron Tunic"    -Info "Start a new save file with the Goron Tunic"
    CreateReduxCheckBox -Name "ZoraTunic"     -Adult -Text "Zora Tunic"     -Info "Start a new save file with the Zora Tunic"
    CreateReduxCheckBox -Name "IronBoots"     -Adult -Text "Iron Boots"     -Info "Start a new save file with the Iron Boots"
    CreateReduxCheckBox -Name "HoverBoots"    -Adult -Text "Hover Boots"    -Info "Start a new save file with the Hover Boots"



    # STARTING ITEMS #

    CreateReduxGroup    -Tag  "Save"              -All   -Text "Starting Items"
    CreateReduxCheckBox -Name "DekuStick"         -Child -Text "Deku Stick"          -Info "Start a new save file with Deku Sticks"
    CreateReduxCheckBox -Name "DekuNut"           -All   -Text "Deku Nut"            -Info "Start a new save file with Deku Nuts"
    CreateReduxCheckBox -Name "Bomb"              -All   -Text "Bomb"                -Info "Start a new save file with Bombs"
    CreateReduxCheckBox -Name "FairyBow"          -Adult -Text "Fairy Bow"           -Info "Start a new save file with the Fairy Bow"
    CreateReduxCheckBox -Name "FireArrow"         -Adult -Text "Fire Arrow"          -Info "Start a new save file with the Fire Arrow"
    CreateReduxCheckBox -Name "DinsFire"          -All   -Text "Din's Fire"          -Info "Start a new save file with Din's Fire"

    CreateReduxCheckBox -Name "FairySlingshot"    -Child -Text "Fairy Slingshot"     -Info "Start a new save file with the Fairy Slingshot"
    CreateReduxCheckBox -Name "FairyOcarina"      -All   -Text "Fairy Ocarina"       -Info "Start a new save file with the Fairy Ocarina"
    CreateReduxCheckBox -Name "Bombchu"           -All   -Text "Bombchu"             -Info "Start a new save file with Bombchus"
    CreateReduxCheckBox -Name "Hookshot"          -Adult -Text "Hookshot"            -Info "Start a new save file with the Hookshot"
    CreateReduxCheckBox -Name "IceArrow"          -Adult -Text "Ice Arrow"           -Info "Start a new save file with the Ice Arrow"
    CreateReduxCheckBox -Name "FaroresWind"       -All   -Text "Farore's Wind"       -Info "Start a new save file with Farore's Wind"

    CreateReduxCheckBox -Name "Boomerang"         -Child -Text "Boomerang"           -Info "Start a new save file with Boomerang"
    CreateReduxCheckBox -Name "LensOfTruth"       -All   -Text "Lens of Truth"       -Info "Start a new save file with Lens of Truth"
    CreateReduxCheckBox -Name "MagicBean"         -Child -Text "Magic Bean"          -Info "Start a new save file with Magic Beans"
    CreateReduxCheckBox -Name "MegatonHammer"     -All   -Text "Megaton Hammer"      -Info "Start a new save file with the Megaton Hammer"
    CreateReduxCheckBox -Name "LightArrow"        -Adult -Text "Light Arrow"         -Info "Start a new save file with the Light Arrow"
    CreateReduxCheckBox -Name "NayrusLove"        -All   -Text "Nayru's Love"        -Info "Start a new save file with Nayru's Love"

    CreateReduxCheckBox -Name "Bottle1"           -All   -Text "Empty Bottle #1"     -Info "Start a new save file with the first empty bottle"
    CreateReduxCheckBox -Name "Bottle2"           -All   -Text "Empty Bottle #2"     -Info "Start a new save file with the second empty bottle"
    CreateReduxCheckBox -Name "Bottle3"           -All   -Text "Empty Bottle #3"     -Info "Start a new save file with the third empty bottle"
    CreateReduxCheckBox -Name "Bottle4"           -All   -Text "Empty Bottle #4"     -Info "Start a new save file with the fourth empty bottle"

    CreateReduxCheckBox -Name "OcarinaOfTime"     -All   -Text "Ocarina of Time"     -Info "Start a new save file with the Ocarina of Time`nThis item replaces the Fairy Ocarina" -Link $Redux.Save.FairyOcarina
    CreateReduxCheckBox -Name "LongShot"          -Adult -Text "Longshot"            -Info "Start a new save file with the Longshot`nThis item replaces the Hookshot"             -Link $Redux.Save.Hookshot
    CreateReduxComboBox -Name "TradeSequenceItem" -Adult -Text "Trade Sequence Item" -Info "Start a new save file with a Trade Sequence Item" -Items @("Empty", "Pocket Egg", "Pocket Cucco", "Cojiro", "Odd Mushroom", "Odd Potion", "Poacher's Saw", "Broken Goron's Sword", "Prescription", "Eyeball Frog", "World's Finest Eye Drops", "Claim Check")
    CreateReduxComboBox -Name "Mask"              -Child -Text "Quest Item / Mask"   -Info "Start a new save file with a  Quest Item or Mask" -Items @("Empty", "Weird Egg", "Pocket Egg", "Zelda's Letter", "Keaton Mask", "Skull Mask", "Spooky Mask", "Bunny Hood", "Goron Mask", "Zora Mask", "Gerudo Mask", "Mask of Truth", "SOLD OUT")
    


    # STARTING SONGS #

    CreateReduxGroup    -Tag  "Save"             -All -Text "Starting Songs"
    CreateReduxCheckBox -Name "ZeldasLullaby"    -All -Text "Zelda's Lullaby"    -Info "Start a new save file with Zelda's Lullaby"
    CreateReduxCheckBox -Name "EponasSong"       -All -Text "Epona's Song"       -Info "Start a new save file with Epona's Song"
    CreateReduxCheckBox -Name "SariasSong"       -All -Text "Saria's Song"       -Info "Start a new save file with Saria's Song"
    CreateReduxCheckBox -Name "SunsSong"         -All -Text "Sun's Song"         -Info "Start a new save file with the Sun's Song"
    CreateReduxCheckBox -Name "SongOfTime"       -All -Text "Song of Time"       -Info "Start a new save file with the Song of Time"
    CreateReduxCheckBox -Name "SongOfStorms"     -All -Text "Song of Storms"     -Info "Start a new save file with the Song of Storms"

    CreateReduxCheckBox -Name "MinuetOfForest"   -All -Text "Minuet of Forest"   -Info "Start a new save file with the Minuet of Forest"
    CreateReduxCheckBox -Name "BoleroOfFire"     -All -Text "Bolero of Fire"     -Info "Start a new save file with the Bolero of Fire"
    CreateReduxCheckBox -Name "SerenadeOfWater"  -All -Text "Serenade of Water"  -Info "Start a new save file with the Serenade of Water"
    CreateReduxCheckBox -Name "RequiemOfSpirit"  -All -Text "Requiem of Spirit"  -Info "Start a new save file with the Requiem of Spirit"
    CreateReduxCheckBox -Name "NocturneOfShadow" -All -Text "Nocturne of Shadow" -Info "Start a new save file with the Nocturne of Shadow"
    CreateReduxCheckBox -Name "PreludeOfLight"   -All -Text "Prelude of Light"   -Info "Start a new save file with the Prelude of Light"

}



#==============================================================================================================================================================================================
function CreateTabCapacity() {
    
    # CAPACITY SELECTION #

    CreateReduxGroup    -Tag  "Capacity"     -All -Text "Capacity Selection"
    CreateReduxCheckBox -Name "EnableAmmo"   -All -Text "Change Ammo Capacity"       -Info "Enable changing the capacity values for ammo"
    CreateReduxCheckBox -Name "EnableWallet" -All -Text "Change Wallet Capacity"     -Info "Enable changing the capacity values for the wallets"
    CreateReduxCheckBox -Name "EnableDrops"  -All -Text "Change Item Drops Quantity" -Info "Enable changing the amount which an item drop provides"



    # AMMO CAPACITY #

    $Redux.Box.Ammo = CreateReduxGroup -Tag "Capacity" -All                           -Text "Ammo Capacity Selection"
    CreateReduxTextBox -Name "Quiver1"     -All -Exclude "Master"                     -Text "Quiver (1)"      -Value 30 -Info "Set the capacity for the Quiver (Base)"           -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver1"          -Expose  "Master"                     -Text "Quiver (1)"      -Value 25 -Info "Set the capacity for the Quiver (Base)"           -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver2"     -All                                       -Text "Quiver (2)"      -Value 40 -Info "Set the capacity for the Quiver (Upgrade 1)"      -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver3"     -All -Exclude "Master"                     -Text "Quiver (3)"      -Value 50 -Info "Set the capacity for the Quiver (Upgrade 2)"      -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver3"          -Expose  "Master"                     -Text "Quiver (3)"      -Value 99 -Info "Set the capacity for the Quiver (Upgrade 2)"      -Credits "GhostlyDark"

    CreateReduxTextBox -Name "BombBag1"    -All -Exclude  @("Master", "Gold", "Dawn") -Text "Bomb Bag (1)"    -Value 20 -Info "Set the capacity for the Bomb Bag (Base)"         -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag1"         -Expose  "Master"                     -Text "Bomb Bag (1)"    -Value 15 -Info "Set the capacity for the Bomb Bag (Base)"         -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag1"         -Expose  "Gold"                       -Text "Bomb Bag (1)"    -Value 10 -Info "Set the capacity for the Bomb Bag (Base)"         -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag2"    -All -Exclude "Dawn"                       -Text "Bomb Bag (2)"    -Value 30 -Info "Set the capacity for the Bomb Bag (Upgrade 1)"    -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag3"    -All -Exclude  @("Master", "Gold", "Dawn") -Text "Bomb Bag (3)"    -Value 40 -Info "Set the capacity for the Bomb Bag (Upgrade 2)"    -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag3"         -Expose  "Master"                     -Text "Bomb Bag (3)"    -Value 99 -Info "Set the capacity for the Bomb Bag (Upgrade 2)"    -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag3"         -Expose  "Gold"                       -Text "Bomb Bag (3)"    -Value 50 -Info "Set the capacity for the Bomb Bag (Upgrade 2)"    -Credits "GhostlyDark"

    CreateReduxTextBox -Name "BulletBag1"  -Child                                     -Text "Bullet Bag (1)"  -Value 30 -Info "Set the capacity for the Bullet Bag (Base)"       -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BulletBag2"  -Child                                     -Text "Bullet Bag (2)"  -Value 40 -Info "Set the capacity for the Bullet Bag (Upgrade 1)"  -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BulletBag3"  -Child                                     -Text "Bullet Bag (3)"  -Value 50 -Info "Set the capacity for the Bullet Bag (Upgrade 2)"  -Credits "GhostlyDark"

    CreateReduxTextBox -Name "DekuSticks1" -Child                                     -Text "Deku Sticks (1)" -Value 10 -Info "Set the capacity for the Deku Sticks (Base)"      -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuSticks2" -Child                                     -Text "Deku Sticks (2)" -Value 20 -Info "Set the capacity for the Deku Sticks (Upgrade 1)" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuSticks3" -Child                                     -Text "Deku Sticks (3)" -Value 30 -Info "Set the capacity for the Deku Sticks (Upgrade 2)" -Credits "GhostlyDark"

    CreateReduxTextBox -Name "DekuNuts1"   -All -Exclude "Master"                     -Text "Deku Nuts (1)"   -Value 20 -Info "Set the capacity for the Deku Nuts (Base)"        -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuNuts1"        -Expose  "Master"                     -Text "Deku Nuts (1)"   -Value 15 -Info "Set the capacity for the Deku Nuts (Base)"        -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuNuts2"   -All                                       -Text "Deku Nuts (2)"   -Value 30 -Info "Set the capacity for the Deku Nuts (Upgrade 1)"   -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuNuts3"   -All -Exclude "Master"                     -Text "Deku Nuts (3)"   -Value 40 -Info "Set the capacity for the Deku Nuts (Upgrade 2)"   -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuNuts3"        -Expose  "Master"                     -Text "Deku Nuts (3)"   -Value 99 -Info "Set the capacity for the Deku Nuts (Upgrade 2)"   -Credits "GhostlyDark"



    # WALLET CAPACITY #

    $Redux.Box.Wallet = CreateReduxGroup -Tag "Capacity" -All         -Text "Wallet Capacity Selection"
    CreateReduxTextBox -Name "Wallet1" -Length 4 -All                 -Text "Wallet (1)" -Value 99  -Info "Set the capacity for the Wallet (Base)"      -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet2" -Length 4 -All                 -Text "Wallet (2)" -Value 200 -Info "Set the capacity for the Wallet (Upgrade 1)" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet3" -Length 4 -All -Exclude "Gold" -Text "Wallet (3)" -Value 500 -Info "Set the capacity for the Wallet (Upgrade 2)" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet3" -Length 4      -Expose  "Gold" -Text "Wallet (3)" -Value 999 -Info "Set the capacity for the Wallet (Upgrade 2)" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet4" -Length 4 -All -Exclude "Gold" -Text "Wallet (4)" -Value 500 -Info "Set the capacity for the Wallet (Upgrade 3)" -Credits "GhostlyDark" -Warning "This wallet is not obtained through regular gameplay"
    CreateReduxTextBox -Name "Wallet4" -Length 4      -Expose  "Gold" -Text "Wallet (4)" -Value 999 -Info "Set the capacity for the Wallet (Upgrade 3)" -Credits "GhostlyDark" -Warning "This wallet is not obtained through regular gameplay"



    # ITEM DROPS QUANTITY #

    $Redux.Box.Drops = CreateReduxGroup -Tag "Capacity" -All           -Text "Item Drops Quantity Selection"
    CreateReduxTextBox -Name "Arrows1x"         -Adult                 -Text "Arrows (Single)"     -Value 5   -Info "Set the recovery quantity for picking up or buying Single Arrows"      -Credits "Admentus" -Row 1 -Column 1
    CreateReduxTextBox -Name "Arrows2x"         -Adult                 -Text "Arrows (Double)"     -Value 10  -Info "Set the recovery quantity for pickung up or buying Double Arrows"      -Credits "Admentus"
    CreateReduxTextBox -Name "Arrows3x"         -Adult                 -Text "Arrows (Triple)"     -Value 30  -Info "Set the recovery quantity for pickung up or buying Triple Arrows"      -Credits "Admentus"
    CreateReduxTextBox -Name "BulletSeeds1x"    -Child                 -Text "Bullet Seeds (5)"    -Value 5   -Info "Set the recovery quantity for pickung up or buying Bullet Seeds (5)"   -Credits "Admentus"
    CreateReduxTextBox -Name "BulletSeeds2x"    -Child                 -Text "Bullet Seeds (30)"   -Value 30  -Info "Set the recovery quantity for pickung up or buying Bullet Seeds (30)"  -Credits "Admentus"
    CreateReduxTextBox -Name "DekuSticks1x"     -Child                 -Text "Deku Sticks (1)"     -Value 1   -Info "Set the recovery quantity for pickung up or buying up Deku Sticks (1)" -Credits "Admentus"
    CreateReduxTextBox -Name "Bombs1x"          -All -Exclude "Dawn"   -Text "Bombs (5)"           -Value 5   -Info "Set the recovery quantity for picking up or buying Bombs (5)"          -Credits "Admentus" -Row 2 -Column 1
    CreateReduxTextBox -Name "Bombs2x"          -All -Exclude "Dawn"   -Text "Bombs (10)"          -Value 10  -Info "Set the recovery quantity for pickung up or buying Bombs (10)"         -Credits "Admentus"
    CreateReduxTextBox -Name "Bombs3x"          -All -Exclude "Dawn"   -Text "Bombs (15)"          -Value 15  -Info "Set the recovery quantity for pickung up or buying Bombs (15)"         -Credits "Admentus"
    CreateReduxTextBox -Name "Bombs4x"          -All -Exclude "Dawn"   -Text "Bombs (20)"          -Value 20  -Info "Set the recovery quantity for pickung up or buying Bombs (20)"         -Credits "Admentus"
    CreateReduxTextBox -Name "DekuNuts1x"       -All                   -Text "Deku Nuts (5)"       -Value 5   -Info "Set the recovery quantity for pickung up or buying Deku Nuts (5)"      -Credits "Admentus"
    CreateReduxTextBox -Name "DekuNuts2x"       -All                   -Text "Deku Nuts (10)"      -Value 10  -Info "Set the recovery quantity for picking up or buying Deku Nuts (10)"     -Credits "Admentus"
    CreateReduxTextBox -Name "Bombchus1x"       -All -Exclude "Dawn"   -Text "Bombchus (5)"        -Value 5   -Info "Set the recovery quantity for picking up or buying Bombchus (5)"       -Credits "Admentus" -Max 50
    CreateReduxTextBox -Name "Bombchus2x"       -All -Exclude "Dawn"   -Text "Bombchus (10)"       -Value 10  -Info "Set the recovery quantity for picking up or buying Bombchus (10)"      -Credits "Admentus" -Max 50
    CreateReduxTextBox -Name "Bombchus3x"       -All -Exclude "Dawn"   -Text "Bombchus (20)"       -Value 20  -Info "Set the recovery quantity for picking up or buying Bombchus (20)"      -Credits "Admentus" -Max 50

    CreateReduxTextBox -Name "RupeeG" -Length 4 -All -Exclude "Master" -Text "Rupee (Green)"       -Value 1   -Info "Set the recovery quantity for picking up Green Rupees"                 -Credits "Admentus" -Row 4 -Column 1
    CreateReduxTextBox -Name "RupeeB" -Length 4 -All -Exclude "Master" -Text "Rupee (Blue)"        -Value 5   -Info "Set the recovery quantity for picking up Blue Rupees"                  -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeR" -Length 4 -All -Exclude "Master" -Text "Rupee (Red)"         -Value 20  -Info "Set the recovery quantity for picking up Red Rupees"                   -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeG" -Length 4      -Expose  "Master" -Text "Rupee (Green)"       -Value 1   -Info "Set the recovery quantity for picking up Green Rupees"                 -Credits "Admentus" -Row 4 -Column 1
    CreateReduxTextBox -Name "RupeeB" -Length 4      -Expose  "Master" -Text "Rupee (Blue)"        -Value 2   -Info "Set the recovery quantity for picking up Blue Rupees"                  -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeR" -Length 4      -Expose  "Master" -Text "Rupee (Red)"         -Value 5   -Info "Set the recovery quantity for picking up Red Rupees"                   -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeP" -Length 4 -All                   -Text "Rupee (Purple)"      -Value 50  -Info "Set the recovery quantity for picking up Purple Rupees"                -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeO" -Length 4 -All                   -Text "Rupee (Gold)"        -Value 200 -Info "Set the recovery quantity for picking up Gold Rupees"                  -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeS" -Length 4 -All                   -Text "Rupee (Silver)"      -Value 5   -Info "Set the recovery quantity for picking up Silver Rupees"                -Credits "Admentus"

    EnableForm -Form $Redux.Box.Ammo -Enable $Redux.Capacity.EnableAmmo.Checked
    $Redux.Capacity.EnableAmmo.Add_CheckStateChanged({ EnableForm -Form $Redux.Box.Ammo -Enable $Redux.Capacity.EnableAmmo.Checked })
    EnableForm -Form $Redux.Box.Wallet -Enable $Redux.Capacity.EnableWallet.Checked
    $Redux.Capacity.EnableWallet.Add_CheckStateChanged({ EnableForm -Form $Redux.Box.Wallet -Enable $Redux.Capacity.EnableWallet.Checked })
    EnableForm -Form $Redux.Box.Drops -Enable $Redux.Capacity.EnableDrops.Checked
    $Redux.Capacity.EnableDrops.Add_CheckStateChanged({ EnableForm -Form $Redux.Box.Drops -Enable $Redux.Capacity.EnableDrops.Checked })

    if ($Redux.Capacity.BombBag1 -ne $null) {
        $Redux.Capacity.BombBag3.Add_LostFocus({
            if ([byte]$Redux.Capacity.BombBag3.Text -le [byte]$Redux.Capacity.BombBag2.Text ) {
                $value = [byte]$Redux.Capacity.BombBag2.Text + 1
                if ($value -gt 99) { $value = 99 }
                $this.Text = $value
            }
        })

        $Redux.Capacity.BombBag2.Add_LostFocus({
            if ([byte]$Redux.Capacity.BombBag2.Text -le [byte]$Redux.Capacity.BombBag1.Text ) {
                $value = [byte]$Redux.Capacity.BombBag1.Text + 1
                if ($value -gt 99) { $value = 99 }
                $this.Text = $value
            }

            if ([byte]$Redux.Capacity.BombBag2.Text -ge [byte]$Redux.Capacity.BombBag3.Text) {
                $value = [byte]$Redux.Capacity.BombBag2.Text + 1
                if ($value -gt 99) { $value = 99 }
                $Redux.Capacity.BombBag3.Text = $value
            }
        })

        $Redux.Capacity.BombBag1.Add_LostFocus({
            if ([byte]$Redux.Capacity.BombBag1.Text -ge [byte]$Redux.Capacity.BombBag2.Text) {
                $value = [byte]$Redux.Capacity.BombBag1.Text + 1
                if ($value -gt 99) { $value = 99 }
                $Redux.Capacity.BombBag2.Text = $value
            }

            if ([byte]$Redux.Capacity.BombBag1.Text -ge [byte]$Redux.Capacity.BombBag3.Text) {
                $value = [byte]$Redux.Capacity.BombBag1.Text + 1
                if ($value -gt 99) { $value = 99 }
                $Redux.Capacity.BombBag3.Text = $value
            }

            if ([byte]$Redux.Capacity.BombBag2.Text -ge [byte]$Redux.Capacity.BombBag3.Text) {
                $value = [byte]$Redux.Capacity.BombBag2.Text + 1
                if ($value -gt 99) { $value = 99 }
                $Redux.Capacity.BombBag3.Text = $value
            }
        })
    }

}



#==============================================================================================================================================================================================
function CreateTabAnimations() {
    
    # SKIP CUTSCENES #

    CreateReduxGroup    -Tag  "Skip"             -Text "Skip Cutscenes"
    CreateReduxCheckBox -Name "OpeningCutscene"  -Text "Opening Cutscene" -Info "Skip the introduction cutscene, so you can start playing immediately"            -Credits "Ported from Better OoT"
    CreateReduxCheckBox -Name "AllMedallions"    -Text "All Medallions"   -Info "Cutscene for all medallions never triggers when leaving Shadow or Spirit Temple" -Credits "Ported from Better OoT"
    CreateReduxCheckBox -Name "DaruniaDance"     -Text "Darunia Dance"    -Info "Darunia will not dance"                                                          -Credits "Ported from Better OoT"
    CreateReduxCheckBox -Name "ZeldaEscape"      -Text "Zelda's Escape"   -Info "Skip the sequence where Zelda is escaping from Hyrule Castle"                    -Credits "Ported from Better OoT"
    CreateReduxCheckBox -Name "DungeonOutro"     -Text "Dungeon Outro"    -Info "Skip the sequence after clearing a dungeon"                                      -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "LightArrow"       -Text "Light Arrow"      -Info "Skip the sequence where Link obtains the Light Arrow"                            -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "RegularSongs"     -Text "Regular Songs"    -Info "Skip the cutscenes for learning regular songs"                                   -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "WarpSongs"        -Text "Warp Songs"       -Info "Skip the cutscenes for learning warp songs"                                      -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "RoyalTomb"        -Text "Royal Tomb"       -Info "Skip the destruction scene of the Royal Tomb entrance"                           -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "ChamberOfSages"   -Text "Chamber of Sages" -Info "Skip the Chamber of Sages after each temple"                                     -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "JabuJabu"         -Text "Jabu-Jabu"        -Info "Skip the sequence where the Jabu-Jabu swallows Link"                             -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "GanonTower"       -Text "Ganon's Tower"    -Info "Skip the collapse of Ganon's Tower"                                              -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "DekuSeedBag"      -Text "Deku Seed Bag"    -Info "Skip the sequence after obtaining the Deku Seed Bag upgrade in the Lost Woods"   -Credits "Ported from Rando"
        


    # SPEEDUP CUTSCENES #

    CreateReduxGroup    -Tag  "Speedup"          -Text "Speedup Cutscenes"
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
    CreateReduxCheckBox -Name "OpeningCutscene"  -Text "Opening Cutscene" -Info "Restore the beta introduction cutscene" -Link $Redux.Skip.OpeningCutscene -Credits "Admentus (ROM) & CloudModding (GameShark)" -Warning "This cutscene has issues in 30 FPS mode"



    # ANIMATIONS #

    $weapons = "`n`nAffected weapons:`n- Giant's Knife`n- Giant's Knife (Broken)`n- Biggoron Sword`n- Deku Stick`n- Megaton Hammer"

    CreateReduxGroup    -Tag  "Animation"       -All -Text "Link Animations"
    CreateReduxCheckBox -Name "Feminine"        -All -Text "Feminine Animations"    -Info "Use feminine animations for Link`nThis applies to both models`nIt works best with the Aria model"   -Credits "GhostlyDark (ported) & AriaHiro64 (model)"
    CreateReduxCheckBox -Name "WeaponIdle"      -All -Text "2-handed Weapon Idle"   -Info ("Restore the beta animation when idly holding a two-handed weapon" + $weapons)                      -Credits "Admentus"
    CreateReduxCheckBox -Name "WeaponCrouch"    -All -Text "2-handed Weapon Crouch" -Info ("Restore the beta animation when crouching with a two-handed weapon" + $weapons)                    -Credits "Admentus"
    CreateReduxCheckBox -Name "WeaponAttack"    -All -Text "2-handed Weapon Attack" -Info ("Restore the beta animation when attacking with a two-handed weapon" + $weapons)                    -Credits "Admentus"
    CreateReduxCheckBox -Name "HoldShieldOut"   -All -Text "Hold Shield Out"        -Info "Restore the beta animation for Link to always holds his shield out even when his sword is sheathed" -Credits "Admentus"
    CreateReduxCheckBox -Name "BombBag"         -All -Text "Bomb Bag"               -Info "Restore the beta animation for the bomb bag"                                                        -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxCheckBox -Name "BackflipAttack"  -All -Text "Backflip Jump Attack"   -Info "Restore the beta animation to turn the Jump Attack into a Backflip Jump Attack"                     -Credits "Admentus"
    CreateReduxCheckBox -Name "FrontflipAttack" -All -Text "Frontflip Jump Attack"  -Info "Restore the beta animation to turn the Jump Attack into a Frontflip Jump Attack"                    -Credits "Admentus"    -Link $Redux.Animation.BackflipAttack
    CreateReduxCheckBox -Name "FrontflipJump"   -All -Text "Frontflip Jump"         -Info "Replace the jumps with frontflip jumps`nThis is a jump from Majora's Mask"                          -Credits "SoulofDeity"
    CreateReduxCheckBox -Name "SomarsaultJump"  -All -Text "Somarsault Jump"        -Info "Replace the jumps with somarsault jumps`nThis is a jump from Majora's Mask"                         -Credits "SoulofDeity" -Link $Redux.Animation.FrontflipJump
    CreateReduxCheckBox -Name "SideBackflip"    -All -Text "Side Backflip"          -Info "Replace the backflip jump with side hop jumps"                                                      -Credits "BilonFullHDemon"

}
