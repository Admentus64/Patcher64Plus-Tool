function PrePatchOptions() {
    
    # GRAPHICS #

    if (IsChecked $Redux.Graphics.Widescreen) {
        ApplyPatch -Patch "Decompressed\Optional\Widescreen\widescreen_minimum.ppf"
        if     (StrLike -Str $GamePatch.settings -Val "Dawn & Dusk")   { ApplyPatch -Patch "Decompressed\Optional\Widescreen\widescreen_dawn_and_dusk.ppf" }
        elseif ($GamePatch.backgrounds -ne 0)                          { ApplyPatch -Patch "Decompressed\Optional\Widescreen\widescreen_hide_geometry.ppf" }
    }

}



#==============================================================================================================================================================================================
function PrePatchReduxOptions() {
    
    # GRAPHICS #

    if (IsChecked $Redux.Graphics.Widescreen) { ApplyPatch -Patch "Decompressed\Optional\Widescreen\widescreen_redux_hotfix.ppf" }

}



#==============================================================================================================================================================================================
function PatchOptions() {
	
    # MODELS #

    if (IsDefault -Elem $Redux.Graphics.ChildModels -Not)   { PatchModel -Category "Child" -Name $GamePatch.LoadedModelsList["Child"][$Redux.Graphics.ChildModels.SelectedIndex] }
    if (IsDefault -Elem $Redux.Graphics.AdultModels -Not)   { PatchModel -Category "Adult" -Name $GamePatch.LoadedModelsList["Adult"][$Redux.Graphics.AdultModels.SelectedIndex] }
    if (IsChecked $Redux.Animation.Feminine)                { ApplyPatch -Patch "Decompressed\Optional\feminine_animations.ppf" }

    if (IsChecked $Redux.Restore.N64Logo)                   { ApplyPatch -Patch "Decompressed\Optional\restore_n64_logo.ppf"          } # RESTORE #
    if (IsChecked $Redux.Fixes.DodongoBombchuCrash)         { ApplyPatch -Patch "Decompressed\Optional\dodongo_bombchu_crash_fix.ppf" } # FIXES #
    if (IsChecked $Redux.Hero.PotsChallenge)                { ApplyPatch -Patch "Decompressed\Optional\pots_challenge.ppf"            } # DIFFICULTY #
    if (IsChecked $Redux.Text.PauseScreen)                  { ApplyPatch -Patch "Decompressed\Optional\mm_pause_screen.ppf"           } # TEXT



    # SCENES #

    if (IsIndex $Redux.MQ.Dungeons -Text "Custom") {
        if (TestFile $GameFiles.scenesPatch) { ApplyPatch -Patch $GameFiles.scenesPatch -FullPath }
    }



    # CAPACITY #

    if     ( (IsChecked $Redux.Capacity.DynamicWallet) ) { ApplyPatch -Patch "Decompressed\optional\dynamic_digits_wallet.ppf" }
    elseif (IsChecked $Redux.Capacity.EnableWallet) {
        if     ($Redux.Capacity.Wallet1.Text.Length -gt 4 -or $Redux.Capacity.Wallet2.Text.Length -gt 4 -or $Redux.Capacity.Wallet3.Text.Length -gt 4 -or $Redux.Capacity.Wallet4.Text.Length -gt 4)   { ApplyPatch -Patch "Decompressed\optional\dynamic_digits_wallet.ppf" }
        elseif ($Redux.Capacity.Wallet1.Text.Length -gt 3 -or $Redux.Capacity.Wallet2.Text.Length -gt 3 -or $Redux.Capacity.Wallet3.Text.Length -gt 3 -or $Redux.Capacity.Wallet4.Text.Length -gt 3)   { ApplyPatch -Patch "Decompressed\optional\four_digits_wallet.ppf"    }
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
    
    ChangeBytes -Offset "B061DF" -Values "02"

    # QUALITY OF LIFE #

    if (IsDefault $Redux.Gameplay.FasterBlockPushing -Not) {
        ChangeBytes -Offset "DD2B87" -Values "80";       ChangeBytes -Offset "DD2D27" -Values "03" # Block Speed, Delay
        ChangeBytes -Offset "DD9683" -Values "80";       ChangeBytes -Offset "DD981F" -Values "03" # Milk Crate Speed, Delay
        ChangeBytes -Offset "C77CA8" -Values "40800000"; ChangeBytes -Offset "C770C3" -Values "01" # Fire Block Speed, Delay
        ChangeBytes -Offset "CC5DBF" -Values "01";       ChangeBytes -Offset "DBCF73" -Values "01" # Forest Basement Puzzle Delay / spirit Cobra Mirror Delay
        ChangeBytes -Offset "DBA233" -Values "19";       ChangeBytes -Offset "DBA3A7" -Values "00" # Truth Spinner Speed, Delay
        if (IsIndex $Redux.Gameplay.FasterBlockPushing -Index 3) { ChangeBytes -Offset "CE1BD0" -Values "40800000"; ChangeBytes -Offset "CE0F0F" -Values "03" } # Amy Puzzle Speed, Delay
    }

    if (IsChecked $Redux.Gameplay.NoKillFlash)              { ChangeBytes -Offset "B11C33" -Values "00"                                                                                              }
    if (IsChecked $Redux.Gameplay.RemoveNaviTimer)          { ChangeBytes -Offset "C26C14" -Values "10000013"; ChangeBytes -Offset "C26C1C"  -Values "10000013"                                      }
    if (IsChecked $Redux.Gameplay.ResumeLastArea)           { ChangeBytes -Offset "B06348" -Values "0000";     ChangeBytes -Offset "B06350"  -Values "0000"                                          }
    if (IsChecked $Redux.Gameplay.InstantClaimCheck)        { ChangeBytes -Offset "ED4470" -Values "00000000"; ChangeBytes -Offset "ED4498"  -Values "00000000"                                      }
    if (IsChecked $Redux.Gameplay.ReturnChild)              { ChangeBytes -Offset "CB6844" -Values "35";       ChangeBytes -Offset "253C0E2" -Values "03"                                            }
    if (IsChecked $Redux.Gameplay.AllowWarpSongs)           { ChangeBytes -Offset "B6D3D2" -Values "00";       ChangeBytes -Offset "B6D42A"  -Values "00"                                            }
    if (IsChecked $Redux.Gameplay.AllowFaroreWind)          { ChangeBytes -Offset "B6D3D3" -Values "00";       ChangeBytes -Offset "B6D42B"  -Values "00"                                            }
    if (IsChecked $Redux.Gameplay.AllowOcarina)             { ChangeBytes -Offset "B6D346" -Values "11";       ChangeBytes -Offset "B6D33A"  -Values "51"; ChangeBytes -Offset "B6D30A" -Values "51" }
    if (IsChecked $Redux.Gameplay.FasterGoronTunic)         { ChangeBytes -Offset "ED3173" -Values "36";       ChangeBytes -Offset "ED31BB"  -Values "36"                                            }
    if (IsChecked $Redux.Gameplay.RutoNeverDisappears)      { ChangeBytes -Offset "D01EA3" -Values "00"                                                                                              }
    if (IsChecked $Redux.Gameplay.Medallions)               { ChangeBytes -Offset "E2B454" -Values "80EA00A72401003F314A003F00000000"                                                                }
    if (IsChecked $Redux.Gameplay.OpenBombchuShop)          { ChangeBytes -Offset "C6CEDC" -Values "340B0001"                                                                                        }
  # if (IsChecked $Redux.Gameplay.OpenBombchuShop)          { ChangeBytes -Offset "E2D724"  -Values "1500";    ChangeBytes -Offset "E2D898" -Values "1500"                                           } # Bomchu Bowling Alley
    if (IsChecked $Redux.Gameplay.RemoveNaviPrompts)        { ChangeBytes -Offset "DF8B84" -Values "00000000"                                                                                        }
    


    # GAMEPLAY #

	if (IsChecked $Redux.Gameplay.RunFaster) {
        ChangeBytes -Offset "B6D5B6" -Values "00EE03200300"; ChangeBytes -Offset "B6D5FA" -Values "010E03200300"; ChangeBytes -Offset "B6D664" -Values "0258"; ChangeBytes -Offset "BD2ABA" -Values "4448"
    }

    if (IsDefault $Redux.Gameplay.SpawnChild -Not)          { ChangeBytes -Offset @("B0631E", "B06342")           -Values (GetOoTEntranceIndex $Redux.Gameplay.SpawnChild.Text)                                                                         }
    if (IsDefault $Redux.Gameplay.SpawnAdult -Not)          { ChangeBytes -Offset   "B06332"                      -Values (GetOoTEntranceIndex $Redux.Gameplay.SpawnAdult.Text); ChangeBytes -Offset   "B06318"                      -Values "1000"     }
    if (IsChecked $Redux.Gameplay.ManualJump)               { ChangeBytes -Offset   "BD78C0"                      -Values "04C1";                                                ChangeBytes -Offset   "BD78E3"                      -Values "01"       }
    if (IsChecked $Redux.Gameplay.AltManualJump)            { ChangeBytes -Offset   "BD78E3"                      -Values "00"                                                                                                                          }
    if (IsChecked $Redux.Gameplay.NoShieldRecoil)           { ChangeBytes -Offset   "BD416C"                      -Values "2400"                                                                                                                        }
    if (IsChecked $Redux.Gameplay.RunWhileShielding)        { ChangeBytes -Offset   "BD7DA0"                      -Values "10000055";                                            ChangeBytes -Offset   "BD01D4"                      -Values "00000000" }
    if (IsChecked $Redux.Gameplay.PushbackAttackingWalls)   { ChangeBytes -Offset   "BDEAE0"                      -Values "2624000024850000"                                                                                                            }
    if (IsChecked $Redux.Gameplay.RemoveCrouchStab)         { ChangeBytes -Offset   "BDE374"                      -Values "1000000D"                                                                                                                    }
    if (IsChecked $Redux.Gameplay.RemoveQuickSpin)          { ChangeBytes -Offset   "C9C9E8"                      -Values "1000000E"                                                                                                                    }
    if (IsChecked $Redux.Gameplay.RemoveSpeedClamp)         { ChangeBytes -Offset   "BD9AF0"                      -Values "2400"                                                                                                                        }
    if (IsChecked $Redux.Gameplay.ChildShops)               { ChangeBytes -Offset   "C6CEB4"                      -Values "1500"                                                                                                                        }
    if (IsChecked $Redux.Gameplay.FastArrows)               { ChangeBytes -Offset @("DE178E", "DE364E", "DE552E") -Values "0010"                                                                                                                        }
    if (IsChecked $Redux.Gameplay.FastCharge)               { ChangeBytes -Offset @("C9DCE8", "C9DCF4", "C9DCFC") -Values "00000000";                                            ChangeBytes -Offset @("C9DCF0", "C9DD00", "C9DD2C") -Values "3D59999A" }


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

    if (IsChecked $Redux.Fixes.MagicMeter) {
        ChangeBytes -Offset @("AE9436", "AE96E6") -Values "3840"
        CopyBytes   -Offset   "1A3F840"           -Length "40" -Start "1A3FAC0"
        ChangeBytes -Offset   "1A3F880"           -Values (0..0x3F | ForEach-Object { 0 })
    }

    if (IsChecked $Redux.Fixes.VisibleGerudoTent) {
        ChangeBytes -Offset "D215D3" -Values "128483"
        ChangeBytes -Offset "D215E1" -Values "41000724010003"
        ChangeBytes -Offset "D215EF" -Values "0410410005000000001000000F0000102503E000082C62000103E000080060102503E00008240200018483001C386200022C420001144000040000000038620003"
    }

    if (IsChecked $Redux.Fixes.BuyableBombs)          { ChangeBytes -Offset "C00840" -Values "1000"                                                      }
    if (IsChecked $Redux.Fixes.PauseScreenDelay)      { ChangeBytes -Offset "B15DD0" -Values "00000000"                                                  } # Pause Screen Anti-Aliasing
    if (IsChecked $Redux.Fixes.PauseScreenCrash)      { ChangeBytes -Offset "B12947" -Values "03"                                                        } # Pause Screen Delay Speed
  # if (IsChecked $Redux.Fixes.ShieldBurningCrash)    { ChangeBytes -Offset "DB2732" -Values "0000"                                                      }
    if (IsChecked $Redux.Fixes.WhiteBubbleCrash)      { ChangeBytes -Offset "CB4397" -Values "00"                                                        }
    if (IsChecked $Redux.Fixes.RemoveFishingPiracy)   { ChangeBytes -Offset "DBEC80" -Values "34020000"                                                  }
    if (IsChecked $Redux.Fixes.PoacherSaw)            { ChangeBytes -Offset "AE72CC" -Values "00000000"                                                  }
    if (IsChecked $Redux.Fixes.GerudosFortress)       { CopyBytes   -Offset "96E068" -Length "D48" -Start "974600"                                       } # Minimap fix
    if (IsChecked $Redux.Fixes.AlwaysMoveKingZora)    { ChangeBytes -Offset "E55BB0" -Values "85CE8C3C"; ChangeBytes -Offset "E55BB4" -Values "844F0EDA" }
    if (IsChecked $Redux.Fixes.DeathMountainOwl)      { ChangeBytes -Offset "E304F0" -Values "240E0001"                                                  }
    if (IsChecked $Redux.Fixes.Boomerang)             { ChangeBytes -Offset "F0F718" -Values "FC41C7FFFFFFFE38"                                          }
    if (IsChecked $Redux.Fixes.TimeDoor)              { ChangeBytes -Offset "AC8608" -Values "00902025848E00A4340100430000000000000000"                  } # Fix open Temple of Time door on first visit bug
    
    

    # OTHER #

    if ( (IsIndex -Elem $Redux.Other.Select -Text "Translate Only")         -or (IsIndex $Redux.Other.Select -Text "Translate and Enable Map Select") )       { ExportAndPatch -Path "map_select" -Offset "B9FD90" -Length "EC0"; ExportAndPatch -Path "inventory_editor" -Offset "BCBF64" -Length "C8" }
    if ( (IsIndex -Elem $Redux.Other.Select -Text "Enable Map Select Only") -or (IsIndex $Redux.Other.Select -Text "Translate and Enable Map Select") )       { ChangeBytes -Offset "A94994" -Values "00000000AE0800143484B92C8E020018240B0000AC8B0000"; ChangeBytes -Offset "B67395" -Values "B9E40000BA1160808009C08080372080801C1480801C1480801C08" }
    if ( (IsIndex -Elem $Redux.Other.SkipIntro -Text "Skip Logo")           -or (IsIndex -Elem $Redux.Other.SkipIntro -Text "Skip Logo and Title Screen") )   { ChangeBytes -Offset "B9DAAC" -Values "00000000"                        }
    if ( (IsIndex -Elem $Redux.Other.SkipIntro -Text "Skip Title Screen")   -or (IsIndex -Elem $Redux.Other.SkipIntro -Text "Skip Logo and Title Screen") )   { ChangeBytes -Offset "B17237" -Values "30"                              }
    if   (IsDefault -Elem $Redux.Other.Skybox  -Not)                                                                                                          { ChangeBytes -Offset "B67722" -Values $Redux.Other.Skybox.SelectedIndex }

    if (IsChecked $Redux.Other.DefaultZTargeting)    { ChangeBytes -Offset "B71E6D" -Values "01"                                            }
    if (IsChecked $Redux.Other.DiskDrive)            { ChangeBytes -Offset "BAF1F1" -Values "26"; ChangeBytes -Offset "E6D83B" -Values "04" }



    # GRAPHICS #

    if (IsChecked $Redux.Graphics.WidescreenAlt) {
        if ($IsWiiVC ) { ChangeBytes -Offset "B08038" -Values "3C073FE3" } # 16:9 Widescreen
        if ($GamePatch.base -le 4) { # 16:9 Textures
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

    

    if (IsChecked $Redux.Graphics.GCScheme) { # Z to L + L to D-Pad textures and GC R button
        if (IsChecked $Redux.Text.PauseScreen -Lang 1) { PatchBytes -Offset "844540" -Texture -Patch "GameCube\l_pause_screen_button_mm.bin" } else { PatchBytes -Offset "844540" -Texture -Patch "GameCube\l_pause_screen_button.bin" }
        if (IsChecked $Redux.Text.PauseScreen -Lang 1) { PatchBytes -Offset "844840" -Texture -Patch "GameCube\r_pause_screen_button_mm.bin" } else { PatchBytes -Offset "844840" -Texture -Patch "GameCube\r_pause_screen_button.bin" }
	PatchBytes -Offset "92C100" -Texture -Patch "GameCube\dpad_text_icon.bin"
        PatchBytes -Offset "92C200" -Texture -Patch "GameCube\l_text_icon.bin"
        if (TestFile ($GameFiles.textures + "\GameCube\l_targeting_" + $LanguagePatch.code + ".bin")) {
            if ($LanguagePatch.l_target_jpn -eq 1) { $offset = "1A0B300" } else { $offset = "1A35680" }
            PatchBytes -Offset $offset -Texture -Patch ("GameCube\l_targeting_" + $LanguagePatch.code + ".bin")
        }
    }

    if (IsChecked $Redux.Graphics.ExtendedDraw)      { ChangeBytes -Offset   "A9A970" -Values "00 01"                                                                                                                                                  }
    if (IsChecked $Redux.Graphics.ForceHiresModel)   { ChangeBytes -Offset   "BE608B" -Values "00"                                                                                                                                                     }
    if (IsChecked $Redux.Graphics.HideDungeonIcon)   { ChangeBytes -Offset @("B6C9F8", "B6CA06", "B6CA24") -Values "FFFF"; ChangeBytes -Offset @("B6C9FC", "B6CA0A", "B6CA1A") -Values "FFFFFFFF"; ChangeBytes -Offset "B6CA10" -Values "FFFFFFFFFFFF" }
    if (IsChecked $Redux.Graphics.ImprovedMoon)      { PatchBytes  -Offset   "F3B3A0" -Texture -Patch "Moon\improved_moon.bin"                                                                                                                         }



    # INTERFACE #

    if ( (IsChecked $Redux.UI.ButtonPositions) -or (IsChecked $Redux.UI.HUD)) {
        ChangeBytes -Offset "B57F03" -Values "04" -Add # A Button / Text - X position (BA -> BE, +04)
        ChangeBytes -Offset "B586A7" -Values "0E" -Add # A Button / Text - Y position (09 -> 17, +0E)
        ChangeBytes -Offset "B57EEF" -Values "07" -Add # B Button        - X position (A0 -> A7, +07)
        ChangeBytes -Offset "B589EB" -Values "07" -Add # B Text          - X position (94 -> 9B, +07)
    }

    if ( (IsIndex -Elem $Redux.UI.BlackBars -Index 2) -or (IsIndex -Elem $Redux.UI.BlackBars -Index 4) ) { ChangeBytes -Offset   "B0F680"                                -Values "00000000" }
    if ( (IsIndex -Elem $Redux.UI.BlackBars -Index 3) -or (IsIndex -Elem $Redux.UI.BlackBars -Index 4) ) { ChangeBytes -Offset @("B0F5A4", "B0F5D4", "B0F5E4", "B0F688") -Values "00000000" }

    if (IsChecked $Redux.UI.CenterNaviPrompt)    { ChangeBytes -Offset "B582DF"  -Values "01" -Subtract }
    if (IsDefault $Redux.UI.ButtonStyle  -Not)   { PatchBytes  -Offset "1A3CA00" -Shared -Patch ("HUD\Buttons\"       + $Redux.UI.ButtonStyle.Text.replace(  " (default)", "") + ".bin") }
    if (IsDefault $Redux.UI.Rupees       -Not)   { PatchBytes  -Offset "1A3DF00" -Shared -Patch ("HUD\Rupees\"        + $Redux.UI.Rupees.Text.replace(       " (default)", "") + ".bin") }
    if (IsDefault $Redux.UI.Hearts       -Not)   { PatchBytes  -Offset "1A3C000" -Shared -Patch ("HUD\Hearts\"        + $Redux.UI.Hearts.Text.replace(       " (default)", "") + ".bin") }
    if (IsDefault $Redux.UI.Magic        -Not)   { PatchBytes  -Offset "1A3F8C0" -Shared -Patch ("HUD\Magic\"         + $Redux.UI.Magic.Text.replace(        " (default)", "") + ".bin") }
    if (IsDefault $Redux.UI.CurrentFloor -Not)   { PatchBytes  -Offset "85F980"  -Shared -Patch ("HUD\Current Floor\" + $Redux.UI.CurrentFloor.Text.replace( " (default)", "") + ".bin") }
    if (IsDefault $Redux.UI.BossFloor    -Not)   { PatchBytes  -Offset "85FB80"  -Shared -Patch ("HUD\Boss Floor\"    + $Redux.UI.BossFloor.Text.replace(    " (default)", "") + ".bin") }
    if (IsChecked $Redux.UI.DungeonKeys)         { PatchBytes  -Offset "1A3DE00" -Shared -Patch  "HUD\Keys\Majora's Mask.bin"   }
    if (IsChecked $Redux.UI.Chests)              { PatchBytes  -Offset "1A3E580" -Shared -Patch  "HUD\Chests\Majora's Mask.bin" }



    # HIDE HUD #

    if (IsChecked $Redux.Hide.AButton) {
        ChangeBytes -Offset "B586B0" -Values "00000000" # A Button (scale)
        ChangeBytes -Offset "AE7D0E" -Values "0310"     # A Button - Text (DMA)
        ChangeBytes -Offset "7540"   -Values "031000000310570003100000"
    }

    if (IsChecked $Redux.Hide.CButtons) {
        ChangeBytes -Offset @("B58504", "B5857C") -Values "241903E3"; ChangeBytes -Offset "B58DC4" -Values "240E03E4" # C-Left Button  -> Button / Icon / Ammo
        ChangeBytes -Offset @("B58510", "B58588") -Values "240F03F9"; ChangeBytes -Offset "B58C40" -Values "240602FA" # C-Down Button  -> Button / Icon / Ammo
        ChangeBytes -Offset @("B5851C", "B58594") -Values "2419030F"; ChangeBytes -Offset "B58DE0" -Values "24190310" # C-Right Button -> Button / Icon / Ammo
    }
    
    if (IsChecked $Redux.Hide.Icons) {
        ChangeBytes -Offset "B58CFC" -Values "24 0F 00 00" # Clock - Digits (scale)
        $Values = @();     for ($i=0; $i -lt 256; $i++) { $Values += 0 }; ChangeBytes -Offset "1A3E000" -Values $Values # Clock - Icon
        $Values = @();     for ($i=0; $i -lt 768; $i++) { $Values += 0 }; ChangeBytes -Offset "1A3E600" -Values $Values # Score Counter - Icon
    }

    if (IsChecked $Redux.Hide.BButton)        { ChangeBytes -Offset "B57EEC" -Values "240203A0"; ChangeBytes -Offset "B57EFC" -Values "240A03A2"; ChangeBytes -Offset "B589D4" -Values "240F0397"; ChangeBytes -Offset "B589E8" -Values "24190394" } # B Button -> Icon / Ammo / Japanese / English
    if (IsChecked $Redux.Hide.StartButton)    { ChangeBytes -Offset "B584EC" -Values "24190384"; ChangeBytes -Offset "B58490" -Values "2418037A"; ChangeBytes -Offset "B5849C" -Values "240E0378"                                                  } # Start Button   -> Button / Japanese / English
    if (IsChecked $Redux.Hide.CupButton)      { ChangeBytes -Offset "B584C0" -Values "241903FE"; ChangeBytes -Offset "B582DC" -Values "240E03F7"                                                                                                   } # C-Up Button    -> Button / Navi Text
    if (IsChecked $Redux.Hide.AreaTitle)      { ChangeBytes -Offset "BE2B10" -Values "240703A0"                                                                                                                                                    } # Area Titles
    if (IsChecked $Redux.Hide.DungeonTitle)   { ChangeBytes -Offset "AC8828" -Values "240703A0"                                                                                                                                                    } # Dungeon Titles
    if (IsChecked $Redux.Hide.Carrots)        { ChangeBytes -Offset "B58348" -Values "240F036E"                                                                                                                                                    } # Epona Carrots    
    if (IsChecked $Redux.Hide.Hearts)         { ChangeBytes -Offset "ADADEC" -Values "1000"                                                                                                                                                        } # Disable Hearts Render
    if (IsChecked $Redux.Hide.Rupees)         { ChangeBytes -Offset "AEB7B0" -Values "240C031A"; ChangeBytes -Offset "AEBC48" -Values "240D01CE"                                                                                                   } # Rupees - Icon / Rupees - Text (Y pos)
    if (IsChecked $Redux.Hide.Magic)          { ChangeBytes -Offset "B587C0" -Values "240F031A"; ChangeBytes -Offset "B587A0" -Values "240E0122"; ChangeBytes -Offset "B587B4" -Values "2419012A"                                                  } # Magic Meter / Magic Bar - Small (Y pos) / Magic Bar - Large (Y pos)
    if (IsChecked $Redux.Hide.DungeonKeys)    { ChangeBytes -Offset "AEB8AC" -Values "240F031A"; ChangeBytes -Offset "AEBA00" -Values "241901BE"                                                                                                   } # Key    - Icon / Key    - Text (Y pos)
    if (IsChecked $Redux.Hide.Credits)        { PatchBytes  -Offset "966000" -Patch "Message\credits.bin"                                                                                                                                          }



    # STYLES #

    if (IsDefault $Redux.Styles.HairColor -Not) {
        $offsetChild = $null; $folderChild = "" 
        $offsetAdult = $null; $folderAdult = ""

        if     (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Original")                      { $offsetChild = "F04A40"; $folderChild = "Ocarina of Time" }
        elseif (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Majora's Mask Eyes")            { $offsetChild = "F04A40"; $folderChild = "Ocarina of Time" }
        elseif (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Sashed")                        { $offsetChild = "F04A40"; $folderChild = "Ocarina of Time" }
        elseif (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Majora's Mask Eyes + Sashed")   { $offsetChild = "F04A40"; $folderChild = "Ocarina of Time" }
        elseif (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Majora's Mask")                 { $offsetChild = "FC3400"; $folderChild = "Majora's Mask"   }
        elseif (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Majora's Mask + OoT Eyes")      { $offsetChild = "FC3400"; $folderChild = "Majora's Mask"   }

        if     (IsIndex -Elem $Redux.Graphics.AdultModels -Text "Original")        { $offsetAdult = "F04A40"; $folderAdult = "Ocarina of Time" }
      # elseif (IsIndex -Elem $Redux.Graphics.AdultModels -Text "Majora's Mask")   { $offsetAdult = "F8DF00"; $folderAdult = "Adult Link (MM)" }

        if ($offsetChild -ne $offsetAdult) {
            if ($offsetChild -ne $null) { PatchBytes -Offset $offsetChild -Shared -Patch ("Styles\Hair\" + $folderChild + "\" + $Redux.Styles.HairColor.Text + ".bin") }
            if ($offsetAdult -ne $null) { PatchBytes -Offset $offsetAdult -Shared -Patch ("Styles\Hair\" + $folderAdult + "\" + $Redux.Styles.HairColor.Text + ".bin") }
        }
        elseif ($offsetChild -ne $null) { PatchBytes -Offset $offsetChild -Shared -Patch ("Styles\Hair\" + $folderChild + "\" + $Redux.Styles.HairColor.Text + ".bin") }
    }

    if (IsDefault $Redux.Styles.RegularChests -Not)   { PatchBytes -Offset "FEC798" -Shared -Patch ("Styles\Chests\"       + $Redux.Styles.RegularChests.Text + ".front"); PatchBytes -Offset "FED798"  -Shared -Patch ("Styles\Chests\" + $Redux.Styles.RegularChests.Text + ".back") }
    if (IsDefault $Redux.Styles.BossChests    -Not)   { PatchBytes -Offset "FEE798" -Shared -Patch ("Styles\Chests\"       + $Redux.Styles.BossChests.Text    + ".front"); PatchBytes -Offset "FEDF98"  -Shared -Patch ("Styles\Chests\" + $Redux.Styles.BossChests.Text    + ".back") }
    if (IsDefault $Redux.Styles.SmallCrates   -Not)   { PatchBytes -Offset "F7ECA0" -Shared -Patch ("Styles\Small Crates\" + $Redux.Styles.SmallCrates.Text   + ".bin") }
    if (IsDefault $Redux.Styles.Pots          -Not)   { PatchBytes -Offset "F7D8A0" -Shared -Patch ("Styles\Pots\"         + $Redux.Styles.Pots.Text          + ".bin");   PatchBytes -Offset "1738000" -Shared -Patch ("Styles\Pots\"   + $Redux.Styles.Pots.Text          + ".bin")  }


    # SOUNDS / VOICES #

    if ($GamePatch.age -eq "Child") {
        try     { $file = "Voices Child\" + $Redux.Sounds.ChildVoices.Text.replace(" (default)", "") + ".bin" }
        catch   { $file = "Voices Child\Majora's Mask.bin" }
        if (TestFile ($GameFiles.binaries + "\" + $file)) { PatchBytes -Offset "1DFC00" -Patch $file }
    }
    elseif ($GamePatch.age -eq "Adult") {
        $file = "Voices Adult\" + $Redux.Sounds.AdultVoices.Text.replace(" (default)", "") + ".bin"
        if (TestFile ($GameFiles.binaries + "\" + $file)) { PatchBytes -Offset "18E1E0" -Patch $file }
    }
    else {
        if (IsChecked $Redux.Restore.FireTemple) { $offset = "1EF340" } else { $offset = "1DFC00" }
        try     { $file = "Voices Child\" + $Redux.Sounds.ChildVoices.Text.replace(" (default)", "") + ".bin" }
        catch   { $file = "Voices Child\Majora's Mask.bin" }
        if (TestFile ($GameFiles.binaries + "\" + $file)) { PatchBytes -Offset $offset -Patch $file }

        if (IsChecked $Redux.Restore.FireTemple) { $offset = "19D920" } else { $offset = "18E1E0" }
        $file = "Voices Adult\" + $Redux.Sounds.AdultVoices.Text.replace(" (default)", "") + ".bin"
        if (TestFile ($GameFiles.binaries + "\" + $file)) { PatchBytes -Offset $offset -Patch $file }
    }

    if (IsIndex -Elem $Redux.Sounds.Instrument -Not) { ChangeBytes -Offset "B53C7B" -Values ($Redux.Sounds.Instrument.SelectedIndex+1); ChangeBytes -Offset "B4BF6F" -Values ($Redux.Sounds.Instrument.SelectedIndex+1) }



    # SFX SOUND EFFECTS #

    if (IsIndex -Elem $Redux.SFX.LowHP      -Not)   { ChangeBytes -Offset   "ADBA1A"                                                                                                                                                                  -Values (GetSFXID $Redux.SFX.LowHP.Text)      }
    if (IsIndex -Elem $Redux.SFX.Navi       -Not)   { ChangeBytes -Offset @("AE7EF2", "C26C7E")                                                                                                                                                       -Values (GetSFXID $Redux.SFX.Navi.Text)       }
    if (IsIndex -Elem $Redux.SFX.ZTarget    -Not)   { ChangeBytes -Offset   "AE7EC6"                                                                                                                                                                  -Values (GetSFXID $Redux.SFX.ZTarget.Text)    }
    if (IsIndex -Elem $Redux.SFX.HoverBoots -Not)   { ChangeBytes -Offset   "BDBD8A"                                                                                                                                                                  -Values (GetSFXID $Redux.SFX.HoverBoots.Text) }
    if (IsIndex -Elem $Redux.SFX.Horse      -Not)   { ChangeBytes -Offset @("C18832", "C18C32", "C19A7E", "C19CBE", "C1A1F2", "C1A3B6", "C1B08A", "C1B556", "C1C28A", "C1CC36", "C1EB4A", "C1F18E", "C6B136", "C6BBA2", "C1E93A", "C6B366", "C6B562") -Values (GetSFXID $Redux.SFX.Horse.Text)      }
    if (IsIndex -Elem $Redux.SFX.Nightfall  -Not)   { ChangeBytes -Offset @("AD3466", "AD7A2E")                                                                                                                                                       -Values (GetSFXID $Redux.SFX.Nightfall.Text)  }
    if (IsIndex -Elem $Redux.SFX.FileCursor -Not)   { ChangeBytes -Offset @("BA165E", "BA1C1A", "BA2406", "BA327E", "BA3936", "BA77C2", "BA7886", "BA7A06", "BA7A6E", "BA7AE6", "BA7D6A", "BA8186", "BA822E", "BA82A2", "BAA11E", "BAE7C6")           -Values (GetSFXID $Redux.SFX.FileCursor.Text) }
    if (IsIndex -Elem $Redux.SFX.FileSelect -Not)   { ChangeBytes -Offset @("BA1BBE", "BA23CE", "BA2956", "BA321A", "BA72F6", "BA8106", "BA82EE", "BA9DAE", "BA9EAE", "BA9FD2", "BAE6D6")                                                             -Values (GetSFXID $Redux.SFX.FileSelect.Text) }



    # MUSIC #

    if ($GamePatch.base -le 3) {
        if (TestFile -Path $Paths.Music -Container) {
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
        if (IsIndex -Elem $Redux.Hero.MonsterHP) { $multi = 0 } else { [float]$multi = [float]$Redux.Hero.MonsterHP.text.split('x')[0] }

        MultiplyBytes -Offset @("D74393", "C2F97F", "C0DEF8") -Factor $multi -Max 127 # Like-Like, Peehat, Octorok
        MultiplyBytes -Offset @("D463BF", "CA85DC", "DADBAF") -Factor $multi -Max 127 # Shell Blade, Mad Scrub, Spike
        MultiplyBytes -Offset @("C83647", "C83817", "C836AB") -Factor $multi -Max 127 # Moblin, Spear Moblin, Club Moblin
        MultiplyBytes -Offset @("C5F69C", "CAAF9C", "C55A78") -Factor $multi -Max 127 # Biri, Bari, Shabom
        MultiplyBytes -Offset @("CD724F", "EDC597", "C0B804") -Factor $multi -Max 127 # ReDead / Gibdo, Stalchild, Poe
        MultiplyBytes -Offset @("C6471B", "C51A9F")           -Factor $multi -Max 127 # Torch Slug, Gohma Larva
        MultiplyBytes -Offset @("CB1903", "CB2DD7")           -Factor $multi -Max 127 # Blue Bubble, Red Blue
        MultiplyBytes -Offset @("D76A07", "C5FC3F")           -Factor $multi -Max 127 # Tentacle, Tailpasaran
        MultiplyBytes -Offset @("C693CC", "EB797C")           -Factor $multi -Max 127 # Stinger (Land), Stinger (Water)
        MultiplyBytes -Offset @("C2B183", "C2B1F7")           -Factor $multi -Max 127 # Red Tektite, Blue Tektite
        MultiplyBytes -Offset @("C1097C", "CD582C")           -Factor $multi -Max 127 # Wallmaster, Floormaster
        MultiplyBytes -Offset @("C2DEE7", "C2DF4B")           -Factor $multi -Max 127 # Leever, Purple Leever
        MultiplyBytes -Offset @("CC6CA7", "CC6CAB")           -Factor $multi -Max 127 # Beamos
        MultiplyBytes -Offset @("C11177", "C599BC")           -Factor $multi -Max 127 # Dodongo, Baby Dodongo
        MultiplyBytes -Offset   "CE60C4"                      -Factor $multi -Max 127 # Gold Skulltula
        
        if ($multi -ge 2) {
            ChangeBytes -Offset "B65660" -Values "1001010110020101010101020202000000010100000001010101010100000000" # Skulltula
            ChangeBytes -Offset "DFE767" -Values "F1F0F0F1F1F0F1F222F0F0F0F0F02200000000F0F2F1F0F4F2"               # Freezard
        }
    }

    if (IsIndex -Elem $Redux.Hero.MiniBossHP -Index 3 -Not) { # Mini-Bosses
        if (IsIndex -Elem $Redux.Hero.MiniBossHP) { $multi = 0 } else { [float]$multi = [float]$Redux.Hero.MiniBossHP.text.split('x')[0] }

        MultiplyBytes -Offset @("BFADAB", "D09283", "CDE1FC") -Factor $multi -Max 127 # Stalfos, Dead Hand, Poe Sisters
        MultiplyBytes -Offset @("C3452F", "C3453B")           -Factor $multi -Max 127 # Lizalfos, Dinolfos
        MultiplyBytes -Offset   "ED80EB"                      -Factor $multi -Max 127 # Wolfos
        MultiplyBytes -Offset   "EBC8B7"                      -Factor $multi -Max 127 # Gerudo Fighter
        MultiplyBytes -Offset   "CF2667"                      -Factor $multi -Max 127 # Flare Dancer
        MultiplyBytes -Offset   "DEF87F"                      -Factor $multi -Max 127 # Skull Kid
        MultiplyBytes -Offset   "D49F50"                      -Factor $multi -Max 127 # Big Octo

        if ($multi -eq 255 -and !$multiply) { ChangeBytes -Offset "DE9A1B" -Values "FF" ChangeBytes -Offset "DEB367" -Values "7F"; ChangeBytes -Offset "DEB34F" -Values "7F" } # Iron Knuckle (phase 1), Iron Knuckle (phase 2)
        elseif ($multi -gt 0) {
            MultiplyBytes -Offset "DE9A1B" -Factor $multi                                      # Iron Knuckle (phase 1)
            $value = $ByteArrayGame[(GetDecimal "DEB367")]; $value--; $value *= $multi; $value++;
            ChangeBytes -Offset "DEB367" -Values $value; ChangeBytes -Offset "DEB34F" -Values $value # Iron Knuckle (phase 2)
        }
        else { ChangeBytes -Offset "DE9A1B" -Values "01"; ChangeBytes -Offset "DEB367" -Values "01"; ChangeBytes -Offset "DEB34F" -Values "01" } # Iron Knuckle (phase 1), Iron Knuckle (phase 2)

        # Dark Link
        if     ($multi -eq 0)     { ChangeBytes -Offset "C5B272" -Values "5143" }
        elseif ($multi -eq 0.5)   { ChangeBytes -Offset "C5B272" -Values "5103" }
        elseif ($multi -ge 2)     { ChangeBytes -Offset "C5B272" -Values "5083" }
        elseif ($multi -ge 4)     { ChangeBytes -Offset "C5B272" -Values "5043" }

    }
    
    if (IsIndex -Elem $Redux.Hero.BossHP -Index 3 -Not) { # Bosses
        if (IsIndex -Elem $Redux.Hero.BossHP) { $multi = 0 } else { [float]$multi = [float]$Redux.Hero.BossHP.text.split('x')[0] }

        MultiplyBytes -Offset   "C44F2B"            -Factor $multi -Max 127; ChangeBytes -Offset "C486CC" -Values "00000000" # Gohma
        MultiplyBytes -Offset @("D258BB", "D25B0B") -Factor $multi -Max 127                                                  # Barinade
        MultiplyBytes -Offset @("D64EFB", "D6223F") -Factor $multi -Max 127                                                  # Twinrova
        MultiplyBytes -Offset   "C3B9FF"            -Factor $multi -Max 127                                                  # King Dodongo
        MultiplyBytes -Offset   "CE6D2F"            -Factor $multi -Max 127                                                  # Volvagia
        MultiplyBytes -Offset   "D3B4A7"            -Factor $multi -Max 127                                                  # Morpha
        MultiplyBytes -Offset   "DAC824"            -Factor $multi -Max 127                                                  # Bongo Bongo
        MultiplyBytes -Offset   "D7FDA3"            -Factor $multi -Max 127                                                  # Ganondorf

        MultiplyBytes -Offset "C91F8F" -Factor $multi -Max 127 -Min 4 # Phantom Ganon (phase 1)
        $value = $ByteArrayGame[0xC91F8F]; $value -= (2 * 3 * ($ByteArrayGame[0xC91F8F] / 0x1E)); $value++
        ChangeBytes   -Offset "CAFF33" -Values $value # Phantom Ganon (phase 2)

        MultiplyBytes -Offset "E82AFB" -Factor $multi -Max 127 -Min 3 # Ganon (phase 1)
        $value = $ByteArrayGame[0xE87F2F]; $value--; $value *= ($ByteArrayGame[0xE82AFB] / 0x1E); $value++;
        
        ChangeBytes   -Offset "E87F2F" -Values $value # Ganon (phase 2)
    }
    
    if     (IsText -Elem $Redux.Hero.Damage     -Compare "2x Damage")        { ChangeBytes -Offset "BD35FA" -Values "2BC3" }
    elseif (IsText -Elem $Redux.Hero.Damage     -Compare "4x Damage")        { ChangeBytes -Offset "BD35FA" -Values "2B83" }
    elseif (IsText -Elem $Redux.Hero.Damage     -Compare "8x Damage")        { ChangeBytes -Offset "BD35FA" -Values "2B43" }
    elseif (IsText -Elem $Redux.Hero.Damage     -Compare "OHKO Mode")        { ChangeBytes -Offset "BD35FA" -Values "2A03" }
    if     (IsText -Elem $Redux.Hero.MagicUsage -Compare "2x Magic Usage")   { ChangeBytes -Offset "AE84FA" -Values "2C40" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "4x Magic Usage")   { ChangeBytes -Offset "AE84FA" -Values "2C80" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "8x Magic Usage")   { ChangeBytes -Offset "AE84FA" -Values "2CC0" }

    if (IsText -Elem $Redux.Hero.ItemDrops -Compare "Nothing") {
        $Values = @()
        for ($i=0; $i -lt 80; $i++) { $Values += 0 }
        ChangeBytes -Offset "B5D6B0" -Values $Values
    }
    elseif (IsText -Elem $Redux.Hero.ItemDrops -Compare "Only Rupees") { PatchBytes  -Offset "B5D76A"  -Patch "only_rupee_drops.bin" }

    if ( (IsValue $Redux.Recovery.Heart -Value 0) -or (IsDefault $Redux.Hero.ItemDrops -Not) )   { ChangeBytes -Offset "A895B7"  -Values "2E"       }
    if   (IsChecked $Redux.Hero.NoBottledFairy)                                                  { ChangeBytes -Offset "BF0264"  -Values "00000000" }
    
    if (IsChecked $Redux.Hero.NoFairyDrops) {
        ChangeBytes -Offset "A89662" -Values "0135"     # Drop unused Cucco Chick instead of Fairy when a Fixed Flexible Item drops
        ChangeBytes -Offset "A896A4" -Values "00003025" # Play an unused empty sound when a Fairy is drops (Fixed Flexible Item drop)
      # ChangeBytes -Offset "A89B40" -Values "1000"     # Skip Random Flexible Item drops
        ChangeBytes -Offset "A89B57" -values "00"       # Fairies only drop from Flexible Items when health is below 0
    }

    if ( (IsChecked $Redux.Hero.MiniBosses) -or (IsChecked $Redux.Hero.IronKnuckle) ) {
        ChangeBytes -Offset   "DEDA10"            -Values "4019999A"; ChangeBytes -Offset   "DEA06B"            -Values "00";       ChangeBytes -Offset "DEA072" -Values "6734"; ChangeBytes -Offset "DEA087" -Values "0024A56734" # Move Faster
        ChangeBytes -Offset @("DEA742", "DEA9C6") -Values "40"                                                                                                                                                                     # Attack Faster
        ChangeBytes -Offset   "DEA30A"            -Values "0001";     ChangeBytes -Offset @("DEA742", "DEA9C6") -Values "4100";     ChangeBytes -Offset "DEA16E" -Values "0820"
        ChangeBytes -Offset   "DEA15A"            -Values "10B0";     ChangeBytes -Offset   "DEDA10"            -Values "40808080"; ChangeBytes -Offset "DEA102" -Values "40A0"
    }

    if ( (IsChecked $Redux.Hero.Enemies)    -or (IsChecked $Redux.Hero.HandMaster)    )   { ChangeBytes -Offset   "C0F32A"            -Values "0001";     ChangeBytes -Offset   "CD2EEA"            -Values "4100"; ChangeBytes -Offset @("CD2F6E", "CD2F8E", "CD42EE", "CD435A") -Values "0000"; ChangeBytes -Offset "CD45D2" -Values "44A0"; ChangeBytes -Offset "CD46D6" -Values "41A0"; ChangeBytes -Offset "CD4A2A" -Values "000A" }
    if ( (IsChecked $Redux.Hero.Enemies)    -or (IsChecked $Redux.Hero.Octorok)       )   { ChangeBytes -Offset   "C0BEC6"            -Values "41B0";     ChangeBytes -Offset   "C0C23A"            -Values "0000"; ChangeBytes -Offset   "C0C5B6"                                -Values "44F0"; ChangeBytes -Offset "C0C8BE" -Values "450C"; ChangeBytes -Offset "C0C93A" -Values "4448"                                              }
    if ( (IsChecked $Redux.Hero.Enemies)    -or (IsChecked $Redux.Hero.GohmaLarva)    )   { ChangeBytes -Offset @("C523E6", "C5283E") -Values "0000";     ChangeBytes -Offset   "C5298A"            -Values "0006"; ChangeBytes -Offset   "C52B76"                                -Values "40E0"; ChangeBytes -Offset "C52BFA" -Values "4170"; ChangeBytes -Offset "C52D3E" -Values "4100"                                              }
    if ( (IsChecked $Redux.Hero.Enemies)    -or (IsChecked $Redux.Hero.Keese)         )   { ChangeBytes -Offset   "C13977"            -Values "00";       ChangeBytes -Offset   "C13D6E"            -Values "0000"; ChangeBytes -Offset   "C13D5E"                                -Values "4110"; ChangeBytes -Offset "C14546" -Values "4500"; ChangeBytes -Offset "C1471E" -Values "4150"                                              }
    if ( (IsChecked $Redux.Hero.Bosses)     -or (IsChecked $Redux.Hero.Gohma)         )   { ChangeBytes -Offset   "C455A7"            -Values "20";       ChangeBytes -Offset   "C482B3"            -Values "40";   ChangeBytes -Offset   "C49347"                                -Values "24";   ChangeBytes -Offset "C49367" -Values "0F";   ChangeBytes -Offset "C486CC" -Values "00000000"                                          }
    if ( (IsChecked $Redux.Hero.Enemies)    -or (IsChecked $Redux.Hero.LikeLike)      )   { ChangeBytes -Offset   "D7474E"            -Values "0014";     ChangeBytes -Offset   "D754E2"            -Values "45C8"; ChangeBytes -Offset @("D754B2", "D75572")                     -Values "1000"; ChangeBytes -Offset "D75532" -Values "4100"                                                                                           }
    if ( (IsChecked $Redux.Hero.MiniBosses) -or (IsChecked $Redux.Hero.Stalfos)       )   { ChangeBytes -Offset @("BFB35C", "BFC148") -Values "00000000"; ChangeBytes -Offset   "BFCE4F"            -Values "30";   ChangeBytes -Offset   "BFCA6F"                                -Values "20";   ChangeBytes -Offset "BFD21F" -Values "20"                                                                                             }
    if ( (IsChecked $Redux.Hero.MiniBosses) -or (IsChecked $Redux.Hero.DeadHand)      )   { ChangeBytes -Offset @("D0982E", "D099A2") -Values "4080";     ChangeBytes -Offset @("D099AE", "D09EAA") -Values "0008"; ChangeBytes -Offset   "D0983A"                                -Values "0025"; ChangeBytes -Offset "D09C26" -Values "0010"                                                                                           }
    if ( (IsChecked $Redux.Hero.Enemies)    -or (IsChecked $Redux.Hero.ReDead)        )   { ChangeBytes -Offset   "CD7A62"            -Values "02FA";     ChangeBytes -Offset   "CD7ABE"            -Values "4516"; ChangeBytes -Offset @("CD82CF", "CD84CB")                     -Values "0A";   ChangeBytes -Offset "CD973C" -Values "3FCCCCCD"                                                                                       }
    if ( (IsChecked $Redux.Hero.MiniBosses) -or (IsChecked $Redux.Hero.Wolfos)        )   { ChangeBytes -Offset   "ED9912"            -Values "0000";     ChangeBytes -Offset   "ED9CDE"            -Values "D000"; ChangeBytes -Offset   "EDBE3F"                                -Values "00"                                                                                                                                          }
    if ( (IsChecked $Redux.Hero.MiniBosses) -or (IsChecked $Redux.Hero.Lizalfos)      )   { ChangeBytes -Offset @("C34DE3", "C34E07") -Values "00";       ChangeBytes -Offset @("C36B12", "C36B36") -Values "4000"; ChangeBytes -Offset   "C36E56"                                -Values "D000"                                                                                                                                        }
    if ( (IsChecked $Redux.Hero.Enemies)    -or (IsChecked $Redux.Hero.Tektite)       )   { ChangeBytes -Offset @("C2B29A", "C2B29E") -Values "0000";     ChangeBytes -Offset   "C2B536"            -Values "40F0"; ChangeBytes -Offset @("C2B566", "C2BE9E", "C2C326")           -Values "4150"                                                                                                                                        }
    if ( (IsChecked $Redux.Hero.Bosses)     -or (IsChecked $Redux.Hero.KingDodongo)   )   { ChangeBytes -Offset   "C3CB7F"            -Values "32";       ChangeBytes -Offset   "C3CF73"            -Values "00"                                                                                                                                                                                                                        }
    if ( (IsChecked $Redux.Hero.Enemies)    -or (IsChecked $Redux.Hero.Guay)          )   { ChangeBytes -Offset   "EEE442"            -Values "4150";     ChangeBytes -Offset   "EEECBE"            -Values "4500"                                                                                                                                                                                                                      }
    if ( (IsChecked $Redux.Hero.Enemies)    -or (IsChecked $Redux.Hero.Skulltula)     )   { ChangeBytes -Offset   "C627FF"            -Values "F0"                                                                                                                                                                                                                                                                                      }
    if ( (IsChecked $Redux.Hero.Enemies)    -or (IsChecked $Redux.Hero.DekuScrub)     )   { ChangeBytes -Offset   "EBB0FA"            -Values "41B0"                                                                                                                                                                                                                                                                                    }
    if ( (IsChecked $Redux.Hero.MiniBosses) -or (IsChecked $Redux.Hero.DarkLink)      )   { ChangeBytes -Offset   "1C0FD9F"           -Values "FF"                                                                                                                                                                                                                                                                                      }
    if ( (IsChecked $Redux.Hero.MiniBosses) -or (IsChecked $Redux.Hero.GerudoFighter) )   { ChangeBytes -Offset   "EC15A5"            -Values "10"                                                                                                                                                                                                                                                                                      }
    if ( (IsChecked $Redux.Hero.MiniBosses) -or (IsChecked $Redux.Hero.FlareDancer)   )   { ChangeBytes -Offset @("CF4CD9", "CF4CFD", "CF4D21", "CF4D45", "CF4D69", "CF4D8D", "CF4DB1", "CF4DD5", "CF4DF9", "CF4E1D", "CF4E41", "CF4E65") -Values "04"                                                                                                                                                                                  }

    if (IsChecked $Redux.Hero.RefightBosses) { ChangeBytes -Offset @("C47ACC", "C40B14", "D26494", "C94A40", "D06794", "D3E400", "DA4AA8", "D68CE4") -Values "00000000" }



    # RECOVERY #

    if (IsDefault $Redux.Recovery.Heart       -Not)   { ChangeBytes -Offset   "AE6FC6"            -Values (Get16Bit $Redux.Recovery.Heart.Text)       }
    if (IsDefault $Redux.Recovery.Fairy       -Not)   { ChangeBytes -Offset   "C24BA6"            -Values (Get16Bit $Redux.Recovery.Fairy.Text)       }
    if (IsDefault $Redux.Recovery.FairyBottle -Not)   { ChangeBytes -Offset   "BEAA4A"            -Values (Get16Bit $Redux.Recovery.FairyBottle.Text) }
    if (IsDefault $Redux.Recovery.FairyRevive -Not)   { ChangeBytes -Offset @("BDF65A", "BDF60E") -Values (Get16Bit $Redux.Recovery.FairyRevive.Text) }
    if (IsDefault $Redux.Recovery.Milk        -Not)   { ChangeBytes -Offset   "BEA64A"            -Values (Get16Bit $Redux.Recovery.Milk.Text)        }
    if (IsDefault $Redux.Recovery.RedPotion   -Not)   { ChangeBytes -Offset   "BEA616"            -Values (Get16Bit $Redux.Recovery.RedPotion.Text)   }



    # MAGIC #

    if (IsDefault $Redux.Magic.FireArrow   -Not)   { ChangeBytes -Offset "BEFC10" -Values (Get8Bit $Redux.Magic.FireArrow.Text)   }
    if (IsDefault $Redux.Magic.IceArrow    -Not)   { ChangeBytes -Offset "BEFC11" -Values (Get8Bit $Redux.Magic.IceArrow.Text)    }
    if (IsDefault $Redux.Magic.LightArrow  -Not)   { ChangeBytes -Offset "BEFC12" -Values (Get8Bit $Redux.Magic.LightArrow.Text)  }
    if (IsDefault $Redux.Magic.DinsFire    -Not)   { ChangeBytes -Offset "BEFC05" -Values (Get8Bit $Redux.Magic.DinsFire.Text)    }
    if (IsDefault $Redux.Magic.FaroresWind -Not)   { ChangeBytes -Offset "BEFC03" -Values (Get8Bit $Redux.Magic.FaroresWind.Text) }
    if (IsDefault $Redux.Magic.NayrusLove  -Not)   { ChangeBytes -Offset "BEFC05" -Values (Get8Bit $Redux.Magic.NayrusLove.Text)  }
    


    # MINIGAMES #
    
    if (IsDefault $Redux.Minigames.ShootingGalleryAmmo -Not)   { ChangeBytes -Offset @("D34C13", "D35FC3") -Values (Get8Bit  $Redux.Minigames.ShootingGalleryAmmo.Text); ChangeBytes -Offset "D35DAB" -Values (Get8Bit ([byte]$Redux.Minigames.ShootingGalleryAmmo.Text + 1) ) }
    if (IsDefault $Redux.Minigames.BowlingAlleyAmmo    -Not)   { ChangeBytes -Offset   "E2DD03"            -Values (Get8Bit  $Redux.Minigames.BowlingAlleyAmmo.Text)   }
    if (IsDefault $Redux.Minigames.ArcheryRangeAmmo    -Not)   { ChangeBytes -Offset   "AE5A1F"            -Values (Get8Bit  $Redux.Minigames.ArcheryRangeAmmo.Text)   }
    if (IsDefault $Redux.Minigames.ArcheryRangeScore1  -Not)   { ChangeBytes -Offset   "E12F56"            -Values (Get16Bit $Redux.Minigames.ArcheryRangeScore1.Text) }
    if (IsDefault $Redux.Minigames.ArcheryRangeScore2  -Not)   { ChangeBytes -Offset   "E12F8E"            -Values (Get16Bit $Redux.Minigames.ArcheryRangeScore2.Text) }

    if (IsChecked $Redux.Minigames.Bowling) {
        ChangeBytes -Offset "E2E697" -Values $Redux.Minigames.Bowling1.value; ChangeBytes -Offset "E2E69B" -Values $Redux.Minigames.Bowling2.value; ChangeBytes -Offset "E2E69F" -Values $Redux.Minigames.Bowling3.value
        ChangeBytes -Offset "E2E6A3" -Values $Redux.Minigames.Bowling4.value; ChangeBytes -Offset "E2E6A7" -Values $Redux.Minigames.Bowling5.value; ChangeBytes -Offset "E2D440" -Values "24190000"
    }

    if (IsChecked $Redux.Minigames.SkullKidOcarina)        { ChangeBytes -Offset   "B781D8"                      -Values "030405"                                                                 } # Skull Kid Ocarina
    if (IsChecked $Redux.Minigames.Dampe)                  { ChangeBytes -Offset   "CC4024"                      -Values "00000000"                                                               } # Dampé's Digging Game
    if (IsChecked $Redux.Minigames.LessDemandingFishing)   { ChangeBytes -Offset @("DCBEA8", "DCBF24")           -Values "3C014248"; ChangeBytes -Offset @("DCBF30", "DCBF9C") -Values "3C014230" } # Adult Fish size requirement, Child Fish size requirement
    if (IsChecked $Redux.Minigames.GuaranteedFishing)      { ChangeBytes -Offset @("DC87A0", "DC87BC", "DC87CC") -Values "00000000"; ChangeBytes -Offset "DC8828"              -Values "01A00821" } # Remove most fish loss branches, Prevent RNG fish loss



    # EASY MODE #

    if (IsChecked $Redux.EasyMode.NoShieldSteal)          { ChangeBytes -Offset   "D74910"            -Values "1000000B"                                                    }
    if (IsChecked $Redux.EasyMode.NoTunicSteal)           { ChangeBytes -Offset   "D74964"            -Values "1000000A"                                                    }
    if (IsChecked $Redux.EasyMode.SkipStealthSequence)    { ChangeBytes -Offset   "21F60DE"           -Values "05F0"                                                        }
    if (IsChecked $Redux.EasyMode.SkipTowerEscape)        { ChangeBytes -Offset @("D82A12". "B139A2") -Values "0517"                                                        }
    if (IsChecked $Redux.EasyMode.HotRodderGoron)         { ChangeBytes -Offset @("ED289C", "ED28A4") -Values "1100"                                                        }
    if (IsChecked $Redux.EasyMode.GerudoFighterJail)      { ChangeBytes -Offset   "EBEF3B"            -Values "00"                                                          }
    if (IsDefault $Redux.EasyMode.GhostShopPoints -Not)   { ChangeBytes -Offset   "EE69CE"            -Values (Get16Bit ([int]$Redux.EasyMode.GhostShopPoints.Text * 100) ) }



    # EQUIPMENT COLORS #

    if ($Redux.Colors.SetEquipment -ne $null) {
        if (IsColor $Redux.Colors.SetEquipment[0] -Not) { # Kokiri Tunic
            ChangeBytes -Offset "B6DA38" -Values @($Redux.Colors.SetEquipment[0].Color.R, $Redux.Colors.SetEquipment[0].Color.G, $Redux.Colors.SetEquipment[0].Color.B)
            if ( (IsText -Elem $Redux.Colors.Equipment[0] -Compare "Randomized" -Not) -and (IsText -Elem $Redux.Colors.Equipment[0] -Compare "Custom" -Not) ) { PatchBytes -Offset "7FE000" -Texture -Patch ("Tunic\" + $Redux.Colors.Equipment[0].text.replace(" (default)", "") + ".bin") }
        }

        if (IsColor $Redux.Colors.SetEquipment[1] -Not) { # Goron Tunic
            ChangeBytes -Offset "B6DA3B"  -Values @($Redux.Colors.SetEquipment[1].Color.R, $Redux.Colors.SetEquipment[1].Color.G, $Redux.Colors.SetEquipment[1].Color.B) # Outfit
            ChangeBytes -Offset "16394EC" -Values @($Redux.Colors.SetEquipment[1].Color.R, $Redux.Colors.SetEquipment[1].Color.G, $Redux.Colors.SetEquipment[1].Color.B) # Shop / obtain model
            ChangeBytes -Offset "16394F4" -Values @($Redux.Colors.SetEquipment[1].Color.R, $Redux.Colors.SetEquipment[1].Color.G, $Redux.Colors.SetEquipment[1].Color.B)
            ChangeBytes -Offset "163952C" -Values @($Redux.Colors.SetEquipment[1].Color.R, $Redux.Colors.SetEquipment[1].Color.G, $Redux.Colors.SetEquipment[1].Color.B)
            ChangeBytes -Offset "1639534" -Values @($Redux.Colors.SetEquipment[1].Color.R, $Redux.Colors.SetEquipment[1].Color.G, $Redux.Colors.SetEquipment[1].Color.B)
            if ( (IsText -Elem $Redux.Colors.Equipment[1] -Compare "Randomized" -Not) -and (IsText -Elem $Redux.Colors.Equipment[1] -Compare "Custom" -Not) ) { PatchBytes -Offset "7FF000" -Texture -Patch ("Tunic\" + $Redux.Colors.Equipment[1].text.replace(" (default)", "") + ".bin") }
        }

        if (IsColor $Redux.Colors.SetEquipment[2] -Not) { # Zora Tunic
            ChangeBytes -Offset "B6DA3E"  -Values @($Redux.Colors.SetEquipment[2].Color.R, $Redux.Colors.SetEquipment[2].Color.G, $Redux.Colors.SetEquipment[2].Color.B) # Outfit
            ChangeBytes -Offset "163950C" -Values @($Redux.Colors.SetEquipment[2].Color.R, $Redux.Colors.SetEquipment[2].Color.G, $Redux.Colors.SetEquipment[2].Color.B) # Shop / obtain model
            ChangeBytes -Offset "1639514" -Values @($Redux.Colors.SetEquipment[2].Color.R, $Redux.Colors.SetEquipment[2].Color.G, $Redux.Colors.SetEquipment[2].Color.B)
            ChangeBytes -Offset "163954C" -Values @($Redux.Colors.SetEquipment[2].Color.R, $Redux.Colors.SetEquipment[2].Color.G, $Redux.Colors.SetEquipment[2].Color.B)
            ChangeBytes -Offset "1639554" -Values @($Redux.Colors.SetEquipment[2].Color.R, $Redux.Colors.SetEquipment[2].Color.G, $Redux.Colors.SetEquipment[2].Color.B)
            if ( (IsText -Elem $Redux.Colors.Equipment[2] -Compare "Randomized" -Not) -and (IsText -Elem $Redux.Colors.Equipment[2] -Compare "Custom" -Not) ) { PatchBytes -Offset "800000" -Texture -Patch ("Tunic\" + $Redux.Colors.Equipment[2].text.replace(" (default)", "") + ".bin") }
        }

        if (IsColor $Redux.Colors.SetEquipment[3] -Not)   { ChangeBytes -Offset "B6DA44" -Values @($Redux.Colors.SetEquipment[3].Color.R, $Redux.Colors.SetEquipment[3].Color.G, $Redux.Colors.SetEquipment[3].Color.B) } # Silver Gauntlets
        if (IsColor $Redux.Colors.SetEquipment[4] -Not)   { ChangeBytes -Offset "B6DA47" -Values @($Redux.Colors.SetEquipment[4].Color.R, $Redux.Colors.SetEquipment[4].Color.G, $Redux.Colors.SetEquipment[4].Color.B) } # Golden Gauntlets
        if ( (IsColor $Redux.Colors.SetEquipment[5] -Not) -and $GamePatch.LoadedModel["Adult"].mirror_shield -ne 0) { # Mirror Shield Frame
            $offset = "F86000"
            do {
                $offset = SearchBytes -Start $offset -End "FBD800" -Values "FA000000D70000"
                if ($offset -ge 0) {
                    $Offset = ( Get24Bit ( (GetDecimal $offset) + (GetDecimal "4") ) )
                    if (!(ChangeBytes -Offset $offset -Values @($Redux.Colors.SetEquipment[5].Color.R, $Redux.Colors.SetEquipment[5].Color.G, $Redux.Colors.SetEquipment[5].Color.B))) { break }
                }
            } while ($Offset -ge 0)
        }
    }

    

    # MAGIC SPIN ATTACK COLORS #

    if ($Redux.Colors.SetSpinAttack -ne $null) {
        if (IsColor $Redux.Colors.SetSpinAttack[0] -Not)   { ChangeBytes -Offset "F15AB4" -Values @($Redux.Colors.SetSpinAttack[0].Color.R, $Redux.Colors.SetSpinAttack[0].Color.G, $Redux.Colors.SetSpinAttack[0].Color.B) } # Blue Spin Attack
        if (IsColor $Redux.Colors.SetSpinAttack[1] -Not)   { ChangeBytes -Offset "F15BD4" -Values @($Redux.Colors.SetSpinAttack[1].Color.R, $Redux.Colors.SetSpinAttack[1].Color.G, $Redux.Colors.SetSpinAttack[1].Color.B) } # Blue Spin Attack
        if (IsColor $Redux.Colors.SetSpinAttack[2] -Not)   { ChangeBytes -Offset "F16034" -Values @($Redux.Colors.SetSpinAttack[2].Color.R, $Redux.Colors.SetSpinAttack[2].Color.G, $Redux.Colors.SetSpinAttack[2].Color.B) } # Red Spin Attack
        if (IsColor $Redux.Colors.SetSpinAttack[3] -Not)   { ChangeBytes -Offset "F16154" -Values @($Redux.Colors.SetSpinAttack[3].Color.R, $Redux.Colors.SetSpinAttack[3].Color.G, $Redux.Colors.SetSpinAttack[3].Color.B) } # Red Spin Attack
    }



    # SWORD TRAIL COLORS #

    if ($Redux.Colors.SetSwordTrail -ne $null) {
        if (IsColor   $Redux.Colors.SetSwordTrail[0]   -Not)   { ChangeBytes -Offset "BEFF7C" -Values @($Redux.Colors.SetSwordTrail[0].Color.R, $Redux.Colors.SetSwordTrail[0].Color.G, $Redux.Colors.SetSwordTrail[0].Color.B) }
        if (IsColor   $Redux.Colors.SetSwordTrail[1]   -Not)   { ChangeBytes -Offset "BEFF84" -Values @($Redux.Colors.SetSwordTrail[1].Color.R, $Redux.Colors.SetSwordTrail[1].Color.G, $Redux.Colors.SetSwordTrail[1].Color.B) }
        if (IsDefault $Redux.Colors.SwordTrailDuration -Not)   { ChangeBytes -Offset "BEFF8C" -Values ( $Redux.Colors.SwordTrailDuration.SelectedIndex * 5) }
    }
    


    # FAIRY COLORS #

    if (IsChecked $Redux.Colors.BetaNavi) { ChangeBytes -Offset "A96110" -Values "340F0060" }
    elseif ($Redux.Colors.SetFairy -ne $null) {
        if ( (IsColor $Redux.Colors.SetFairy[0] -Not) -or (IsColor $Redux.Colors.SetFairy[1] -Not) ) { # Idle
            ChangeBytes -Offset "B5E184"  -Values @($Redux.Colors.SetFairy[0].Color.R, $Redux.Colors.SetFairy[0].Color.G, $Redux.Colors.SetFairy[0].Color.B, 255, $Redux.Colors.SetFairy[1].Color.R, $Redux.Colors.SetFairy[1].Color.G, $Redux.Colors.SetFairy[1].Color.B, 0)
        }
        if ( (IsColor $Redux.Colors.SetFairy[2] -Not) -or (IsColor $Redux.Colors.SetFairy[3] -Not) ) { # Interact
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
        if ( (IsColor $Redux.Colors.SetFairy[4] -Not) -or (IsColor $Redux.Colors.SetFairy[5] -Not) ) { # NPC
            ChangeBytes -Offset "B5E194" -Values @($Redux.Colors.SetFairy[4].Color.R, $Redux.Colors.SetFairy[4].Color.G, $Redux.Colors.SetFairy[4].Color.B, 255, $Redux.Colors.SetFairy[5].Color.R, $Redux.Colors.SetFairy[5].Color.G, $Redux.Colors.SetFairy[5].Color.B, 0)
        }
        if ( (IsColor $Redux.Colors.SetFairy[6] -Not) -or (IsColor $Redux.Colors.SetFairy[7] -Not) ) { # Enemy, Boss
            ChangeBytes -Offset "B5E19C" -Values @($Redux.Colors.SetFairy[6].Color.R, $Redux.Colors.SetFairy[6].Color.G, $Redux.Colors.SetFairy[6].Color.B, 255, $Redux.Colors.SetFairy[7].Color.R, $Redux.Colors.SetFairy[7].Color.G, $Redux.Colors.SetFairy[7].Color.B, 0)
            ChangeBytes -Offset "B5E1BC" -Values @($Redux.Colors.SetFairy[6].Color.R, $Redux.Colors.SetFairy[6].Color.G, $Redux.Colors.SetFairy[6].Color.B, 255, $Redux.Colors.SetFairy[7].Color.R, $Redux.Colors.SetFairy[7].Color.G, $Redux.Colors.SetFairy[7].Color.B, 0)
        }
    }



    # RUPEE ICON COLORS #

    if ($Patches.Redux.Checked -and (IsChecked $Redux.Hooks.RupeeIconColors) -and $Redux.Colors.SetRupee -ne $null) {
        $Symbols = SetJSONFile ($GameFiles.base + "\symbols.json")
        if (IsColor $Redux.Colors.SetRupee[0] -Not)   { ChangeBytes -Offset (AddToOffset -Hex $Symbols.rupee_colors -Add 0) -Values @($Redux.Colors.SetRupee[0].Color.R, $Redux.Colors.SetRupee[0].Color.G, $Redux.Colors.SetRupee[0].Color.B) } # Base wallet 
        if (IsColor $Redux.Colors.SetRupee[1] -Not)   { ChangeBytes -Offset (AddToOffset -Hex $Symbols.rupee_colors -Add 3) -Values @($Redux.Colors.SetRupee[1].Color.R, $Redux.Colors.SetRupee[1].Color.G, $Redux.Colors.SetRupee[1].Color.B) } # Adult's Wallet
        if (IsColor $Redux.Colors.SetRupee[2] -Not)   { ChangeBytes -Offset (AddToOffset -Hex $Symbols.rupee_colors -Add 6) -Values @($Redux.Colors.SetRupee[2].Color.R, $Redux.Colors.SetRupee[2].Color.G, $Redux.Colors.SetRupee[2].Color.B) } # Giant's Wallet
        if (IsColor $Redux.Colors.SetRupee[3] -Not)   { ChangeBytes -Offset (AddToOffset -Hex $Symbols.rupee_colors -Add 9) -Values @($Redux.Colors.SetRupee[3].Color.R, $Redux.Colors.SetRupee[3].Color.G, $Redux.Colors.SetRupee[3].Color.B) } # Tycoon's Wallet
    }
    elseif ($Redux.Colors.RupeeVanilla.Active -and $Redux.Colors.SetRupeeVanilla -ne $null) {
        if (IsColor $Redux.Colors.SetRupeeVanilla -Not) {
            ChangeBytes -Offset "AEB766" -Values @($Redux.Colors.SetRupeeVanilla.Color.R, $Redux.Colors.SetRupeeVanilla.Color.G)
            ChangeBytes -Offset "AEB77A" -Values $Redux.Colors.SetRupeeVanilla.Color.B
        }
    }



    # MISC COLORS #

    if (IsChecked $Redux.Colors.PauseScreenColors) {
        ChangeBytes -Offset "BBF88E" -Values "978B" # Menu Title Background
        ChangeBytes -Offset "BBF892" -Values "61"   # Menu Title Background
        ChangeBytes -Offset "BBF97E" -Values "978B" # Z
        ChangeBytes -Offset "BBF982" -Values "61FF" # R
        ChangeBytes -Offset "BBFC7E" -Values "FFFF" # Unavailable Menu Title
        ChangeBytes -Offset "BBFC82" -Values "FF"   # Unavailable Menu Title
        ChangeBytes -Offset "BC793D" -Values "97"   # Z/R Highlight
        ChangeBytes -Offset "BC793F" -Values "8B"   # Z/R Highlight
        ChangeBytes -Offset "BC7941" -Values "61"   # Z/R Highlight
        ChangeBytes -Offset "BC7945" -Values "97"   # Z/R Highlight
        ChangeBytes -Offset "BC7947" -Values "8B"   # Z/R Highlight
        ChangeBytes -Offset "BC7949" -Values "61"   # Z/R Highlight
        ChangeBytes -Offset "BC7994" -Values "B4B4B4B478B4B4B4B4B4B4B478B4B4B4B4B4B4B4B4B4B4B4B4B4B4B478B4B4B4B4B4B4B478B4B4B4B4B4B4B4B4B4B4B4787878784678787878787878467878787878787878787878" # Background
    }


    
    # EQUIPMENT #

    if   ( (IsChecked $Redux.Equipment.HideSword) -and (IsChecked $Redux.Equipment.HideShield) )   { ChangeBytes -Offset "B6D758" -Values "00" -Repeat 0xBF    }
    elseif (IsChecked $Redux.Equipment.HideSword)                                                  { CopyBytes   -Offset "B6D7B8" -Length "60" -Start "B6D758" }
    elseif (IsChecked $Redux.Equipment.HideShield) {
        CopyBytes -Offset "B6D758" -Length "10" -Start "B6D768"; CopyBytes -Offset "B6D758" -Length "10" -Start "B6D778"; CopyBytes -Offset "B6D758" -Length "10" -Start "B6D788"; ChangeBytes -Offset "B6D798" -Values "00" -Repeat 0x1F
        CopyBytes -Offset "B6D7B8" -Length "10" -Start "B6D7C8"; CopyBytes -Offset "B6D7B8" -Length "10" -Start "B6D7D8"; CopyBytes -Offset "B6D7B8" -Length "10" -Start "B6D7E8"; ChangeBytes -Offset "B6D7F8" -Values "00" -Repeat 0x1F
    }

    if (IsChecked $Redux.Equipment.HerosBow) {
        PatchBytes -Offset "7C0000" -Texture -Patch "Equipment\Bow\Hero's Bow.icon"
        PatchBytes -Offset "7F5000" -Texture -Patch "Equipment\Bow\Hero's Bow Fire.icon"
        PatchBytes -Offset "7F6000" -Texture -Patch "Equipment\Bow\Hero's Bow Ice.icon"
        PatchBytes -Offset "7F7000" -Texture -Patch "Equipment\Bow\Hero's Bow Light.icon"
        if (TestFile ($GameFiles.textures + "\Equipment\Bow\Hero's Bow." + $LanguagePatch.code + ".label")) { PatchBytes -Offset "89F800" -Texture -Patch ("Equipment\Bow\Hero's Bow." + $LanguagePatch.code + ".label") }
    }
    
    if (IsChecked $Redux.Equipment.PowerBracelet) {
         $Offset = SearchBytes -Start "FBE000" -End "FEAF80" -Values "00000000000000000000000000000000000000000100010006000C0018002D01"
        if ($Offset -gt 0) { PatchBytes -Offset $Offset  -Texture -Patch ("Equipment\Bracelet\Power Bracelet.bin") }
        PatchBytes -Offset "80D000" -Texture -Patch "Equipment\Bracelet\Power Bracelet.icon"
        if (TestFile ($GameFiles.textures + "\Equipment\Bracelet\Power Bracelet." + $LanguagePatch.code + ".label")) { PatchBytes -Offset "8B2C00" -Texture -Patch ("Equipment\Bracelet\Power Bracelet." + $LanguagePatch.code + ".label") }
        PatchBytes  -Offset "1791000" -Patch "Object GI Models\Power Bracelet.bin" # Goron's Bracelet GI model
    }

    if (IsChecked $Redux.Equipment.FunctionalWeapons) {
        ChangeBytes -Offset "DFE765" -Values "F2"; ChangeBytes -Offset "DFE76C" -Values "F1"; ChangeBytes -Offset "DFE77A" -Values "F1"; ChangeBytes -Offset "DFE77D" -Values "F2"; ChangeBytes -Offset "DFE782" -Values "F4" # Freezard (Deku Stick, Kokiri Slash, Kokiri Spin, Kokiri Jump, Hammer Jump)
        ChangeBytes -Offset "CB4DB1" -Values "D2"; ChangeBytes -Offset "CB4DB2" -Values "D1"; ChangeBytes -Offset "CB4DB8" -Values "D1"                                                                                       # Blue Bubble (Deku Stick, Slingshot, Kokiri Slash)
        ChangeBytes -Offset "C673F9" -Values "F2"; ChangeBytes -Offset "C673FA" -Values "F1"; ChangeBytes -Offset "C67400" -Values "F1"                                                                                       # Torch Slug (Deku Stick, Slingshot, Kokiri Slash)
        ChangeBytes -Offset "D49F5E" -Values "02"; ChangeBytes -Offset "D49F61" -Values "02"; ChangeBytes -Offset "D49F62" -Values "04"; ChangeBytes -Offset "D49F6F" -Values "04"; ChangeBytes -Offset "D49F70" -Values "02" # Big Octorok (Hamer Swing, Master Slash, Giant Slash, Giant Spin, Master Spin)
        ChangeBytes -Offset "D49F72" -Values "08"; ChangeBytes -Offset "D49F73" -Values "04"; ChangeBytes -Offset "D49F76" -Values "04"                                                                                       # Big Octorok (Giant Jump, Master Jump, Hammer Jump)
        ChangeBytes -Offset "DAF295" -Values "F2"; ChangeBytes -Offset "DAF296" -Values "F1"; ChangeBytes -Offset "DAF298" -Values "F1"; ChangeBytes -Offset "DAF29C" -Values "F1"; ChangeBytes -Offset "DAF2AA" -Values "F1" # Spike (Deku Stick, Slingshot, Boomerang, Kokiri Slash, Kokiri Spin)
        ChangeBytes -Offset "DAF2AD" -Values "F2"; ChangeBytes -Offset "DAF2B2" -Values "F4"                                                                                                                                  # Spike (Kokiri Jump, Hammer Jump)
        ChangeBytes -Offset "D7A35D" -Values "F2"; ChangeBytes -Offset "D7A364" -Values "F1"; ChangeBytes -Offset "D7A372" -Values "F1"; ChangeBytes -Offset "D7A375" -Values "F2"; ChangeBytes -Offset "D7A37A" -Values "F4" # Anubis (Deku Stick, Kokiri Slash, Kokiri Spin, Kokiri Jump, Hammer Jump)
        ChangeBytes -Offset "C2F5DE" -Values "E4"                                                                                                                                                                             # Leever (Hammer Jump)
        ChangeBytes -Offset "D4759D" -Values "D2"; ChangeBytes -Offset "D4759E" -Values "F1"; ChangeBytes -Offset "D475A0" -Values "11"; ChangeBytes -Offset "D475BA" -Values "D4"                                            # Shellblade (Deku Stick, Slingshot, Boomerang, Hammer Jump)
        ChangeBytes -Offset "D76516" -Values "F4"                                                                                                                                                                             # Like-Like (Hammer Jump)
    }

    if (IsChecked $Redux.Equipment.NoSlipperyBoots)         { ChangeBytes -Offset "BE4E78" -Values "1500"                                          }
    if (IsChecked $Redux.Equipment.FireProofDekuShield)     { ChangeBytes -Offset "BD3C5B" -Values "00"                                            }
    if (IsChecked $Redux.Equipment.UnsheathSword)           { ChangeBytes -Offset "BD04A0" -Values "284200051440000500001025"                      }
    if (IsChecked $Redux.Equipment.Hookshot)                { PatchBytes  -Offset "7C7000" -Texture -Patch "Equipment\termina_hookshot.icon"       }
    if (IsChecked $Redux.Equipment.GoronBraceletFix)        { ChangeBytes -Offset "BB66DD" -Values "C0"; ChangeBytes -Offset "BC780C" -Values "09" }
    
    

    # SWORDS & SHIELDS #

    if (IsDefault $Redux.Equipment.KokiriSword -Not) {
        if (TestFile ($GameFiles.textures + "\Equipment\Kokiri Sword\" + $Redux.Equipment.KokiriSword.text   + ".icon"))                                  { PatchBytes -Offset "7F8000" -Texture -Patch ("Equipment\Kokiri Sword\" + $Redux.Equipment.KokiriSword.text   + ".icon")                              }
        if (TestFile ($GameFiles.textures + "\Equipment\Kokiri Sword\" + $Redux.Equipment.KokiriSword.text   + "." + $LanguagePatch.code + ".label"))     { PatchBytes -Offset "8AD800" -Texture -Patch ("Equipment\Kokiri Sword\" + $Redux.Equipment.KokiriSword.text   + "." + $LanguagePatch.code + ".label") }
    }

    if (IsDefault $Redux.Equipment.MasterSword -Not) {
        if (TestFile ($GameFiles.textures + "\Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text   + ".icon"))                                  { PatchBytes -Offset "7F9000" -Texture -Patch ("Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text   + ".icon")                              }
        if (TestFile ($GameFiles.textures + "\Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text   + "." + $LanguagePatch.code + ".label"))     { PatchBytes -Offset "8ADC00" -Texture -Patch ("Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text   + "." + $LanguagePatch.code + ".label") }
    }

    if (IsDefault $Redux.Equipment.GiantsKnife -Not) {
        if (TestFile ($GameFiles.textures + "\Equipment\Master Sword\" + $Redux.Equipment.GiantsKnife.text   + ".icon"))                                  { PatchBytes -Offset "7FA000" -Texture -Patch ("Equipment\Master Sword\" + $Redux.Equipment.GiantsKnife.text   + ".icon")                              }
        if (TestFile ($GameFiles.textures + "\Equipment\Master Sword\" + $Redux.Equipment.GiantsKnife.text   + "." + $LanguagePatch.code + ".label"))     { PatchBytes -Offset "8AE000" -Texture -Patch ("Equipment\Master Sword\" + $Redux.Equipment.GiantsKnife.text   + "." + $LanguagePatch.code + ".label") }
    }

    if (IsDefault $Redux.Equipment.BiggoronSword -Not) {
        if (TestFile ($GameFiles.textures + "\Equipment\Master Sword\" + $Redux.Equipment.BiggoronSword.text + ".icon"))                                  { PatchBytes -Offset "7FA000" -Texture -Patch ("Equipment\Master Sword\" + $Redux.Equipment.BiggoronSword.text + ".icon")                              }
        if (TestFile ($GameFiles.textures + "\Equipment\Master Sword\" + $Redux.Equipment.BiggoronSword.text + "." + $LanguagePatch.code + ".label"))     { PatchBytes -Offset "8BD000" -Texture -Patch ("Equipment\Master Sword\" + $Redux.Equipment.BiggoronSword.text + "." + $LanguagePatch.code + ".label") }
    }

    if (IsDefault $Redux.Equipment.SwordHealth -Not) {
        $value =  (Get8Bit $Redux.Equipment.SwordHealth.Text)
        ChangeBytes -Offset "AE5F2F" -Values $value; ChangeBytes -Offset "B71F4F" -Values $value; ChangeBytes -Offset "BB6823" -Values $value; ChangeBytes -Offset "AE5F0B" -Values $value; ChangeBytes -Offset "C014F3" -Values $value
    }

    if (IsDefault $Redux.Equipment.DekuShield -Not) {
        if ($ChildModel.deku_shield -ne 0) {
            if (TestFile ($GameFiles.textures + "\Equipment\Deku Shield\" + $Redux.Equipment.DekuShield.text + ".front") ) {
                $Offset = SearchBytes -Start "FBE000" -End "FEAF80" -Values "CC99E5E5DDA3EE2BDDA5E629DDA5D4DB"
                if ($Offset -gt 0)                                                                                                                      { PatchBytes -Offset $Offset  -Texture -Patch ("Equipment\Deku Shield\"   + $Redux.Equipment.DekuShield.text + ".front") }
            }
            if (TestFile ($GameFiles.textures + "\Equipment\Deku Shield\" + $Redux.Equipment.DekuShield.text + ".back") ) {
                $Offset = SearchBytes -Start "FBE000" -End "FEAF80" -Values "DC11F517F519DC57D459E4DBE4DBDC97"
                if ($Offset -gt 0)                                                                                                                      { PatchBytes -Offset $Offset  -Texture -Patch ("Equipment\Deku Shield\"   + $Redux.Equipment.DekuShield.text + ".back") }
            }
        }
        if (TestFile ($GameFiles.textures + "\Equipment\Deku Shield\" + $Redux.Equipment.DekuShield.text + ".icon"))                                    { PatchBytes -Offset "7FB000" -Texture -Patch ("Equipment\Deku Shield\"   + $Redux.Equipment.DekuShield.text + ".icon")                              }
        if (TestFile ($GameFiles.textures + "\Equipment\Deku Shield\" + $Redux.Equipment.DekuShield.text + "." + $LanguagePatch.code + ".label"))       { PatchBytes -Offset "8AE400" -Texture -Patch ("Equipment\Deku Shield\"   + $Redux.Equipment.DekuShield.text + "." + $LanguagePatch.code + ".label") }

        $file = $GameFiles.textures + "\Equipment\Deku Shield\" + $Redux.Equipment.DekuShield.text + "." + $LanguagePatch.code + ".txt"
        if (TestFile $file) {
            $content     = (Get-Content -Path $file)
            $contentFile = $GameFiles.binaries + "\Object GI Models\" + $content + ".bin"
            if (TestFile $contentFile) { PatchBytes  -Offset "1547000" -Patch ("Object GI Models\" + $content + ".bin"); ChangeBytes -Offset "9EE4" -Values "01547AA0"; ChangeBytes -Offset "B6F5B4" -Values "01547AA0"; ChangeBytes -Offset "B66186" -Values "0A88" }
        }
    }

    if (IsDefault $Redux.Equipment.HylianShield -Not) {
        if (TestFile ($GameFiles.textures + "\Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".front")) {
            PatchBytes -Offset "F03400" -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".front")
            $Offset = SearchBytes -Start "FBE000" -End "FEAF80" -Values "BE35BE77C6B9CEFBD6FDD73DDF3FDF7F" -Silent
            if ($Offset -gt 0)                                                                                                                          { PatchBytes -Offset $Offset  -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".front") }
        }

        if (TestFile ($GameFiles.textures + "\Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".back")) {
            PatchBytes -Offset "FC6E88" -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".back")
	    $Offset = SearchBytes -Start "FBE000" -End "FEAF80" -Values "B5F3ADF3ADF3B5F1C675A56F8CEB6BE5" -Silent
            if ($Offset -gt 0)                                                                                                                          { PatchBytes -Offset $Offset  -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".back") }
        }

        if (TestFile ($GameFiles.textures + "\Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".icon"))                                { PatchBytes -Offset "7FC000" -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".icon")                              }
        if (TestFile ($GameFiles.textures + "\Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + "." + $LanguagePatch.code + ".label"))   { PatchBytes -Offset "8AE800" -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + "." + $LanguagePatch.code + ".label") }

        $file = $GameFiles.textures + "\Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + "." + $LanguagePatch.code + ".txt"
        if (TestFile $file) {
            $content     = (Get-Content -Path $file)
            $contentFile = $GameFiles.binaries + "\Object GI Models\" + $content + ".bin"
            if (TestFile $contentFile) { PatchBytes  -Offset "15B9000" -Patch ("Object GI Models\" + $content + ".bin"); ChangeBytes -Offset "9FF4" -Values "015BA250"; ChangeBytes -Offset "B6F63C" -Values "015BA250"; ChangeBytes -Offset "B663A2" -Values "1238" }
        }
    }

    if (IsDefault $Redux.Equipment.MirrorShield -Not) {
        if ($GamePatch.LoadedModel["Adult"].mirror_shield -ne 0 -and (TestFile ($GameFiles.textures + "\Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".bin"))) {
            $Offset = SearchBytes -Start "F86000" -End "FBD800" -Values "9090909090909090909090909090909090909090909090909090909090909090"
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

    if (IsDefault $Redux.Hitbox.KokiriSword       -Not)   { ChangeBytes -Offset "B6DB18" -Values (ConvertFloatToHex $Redux.Hitbox.KokiriSword.Value)       }
    if (IsDefault $Redux.Hitbox.MasterSword       -Not)   { ChangeBytes -Offset "B6DB14" -Values (ConvertFloatToHex $Redux.Hitbox.MasterSword.Value)       }
    if (IsDefault $Redux.Hitbox.GiantsKnife       -Not)   { ChangeBytes -Offset "B6DB1C" -Values (ConvertFloatToHex $Redux.Hitbox.GiantsKnife.Value)       }
    if (IsDefault $Redux.Hitbox.BrokenGiantsKnife -Not)   { ChangeBytes -Offset "B7E8CC" -Values (ConvertFloatToHex $Redux.Hitbox.BrokenGiantsKnife.Value) }
    if (IsDefault $Redux.Hitbox.MegatonHammer     -Not)   { ChangeBytes -Offset "B6DB24" -Values (ConvertFloatToHex $Redux.Hitbox.MegatonHammer.Value)     }
    if (IsDefault $Redux.Hitbox.ShieldRecoil      -Not)   { ChangeBytes -Offset "BD4162" -Values (Get16Bit ($Redux.Hitbox.ShieldRecoil.Value + 45000))     }
    if (IsDefault $Redux.Hitbox.Hookshot          -Not)   { ChangeBytes -Offset "CAD3C7" -Values (Get8Bit $Redux.Hitbox.Hookshot.Value)                    }
    if (IsDefault $Redux.Hitbox.Longshot          -Not)   { ChangeBytes -Offset "CAD3B7" -Values (Get8Bit $Redux.Hitbox.Longshot.Value)                    }



    # UNLOCK CHILD RESTRICTIONS #

    if (IsChecked $Redux.Unlock.MirrorShield) {
        CopyBytes   -Offset "B6D74E" -Length "2" -Start "B6D72E"; CopyBytes -Offset "B6D756" -Length "2" -Start "B6D736"; CopyBytes -Offset "B6D78E" -Length "2" -Start "B6D76E"
        CopyBytes   -Offset "B6D796" -Length "2" -Start "B6D776"; CopyBytes -Offset "B6D7EE" -Length "2" -Start "B6D7CE"; CopyBytes -Offset "B6D7F6" -Length "2" -Start "B6D7D6"
        ChangeBytes -Offset @("BC77B3", "BC77FC") -Values "09"
    }

    if (IsChecked $Redux.Unlock.Tunics)          { ChangeBytes -Offset @("BC77B6", "BC77FE")           -Values "0909"; ChangeBytes -Offset "C00DD0" -Values "1500"; ChangeBytes -Offset "C00E78" -Values "1500" }
    if (IsChecked $Redux.Unlock.MasterSword)     { ChangeBytes -Offset @("BC77AE", "BC77F8")           -Values "09"                                                                                             }
    if (IsChecked $Redux.Unlock.GiantsKnife)     { ChangeBytes -Offset @("BC77AF", "BC77F9", "BC7811") -Values "09"                                                                                             }
    if (IsChecked $Redux.Unlock.Boots)           { ChangeBytes -Offset @("BC77BA", "BC7801")           -Values "0909"                                                                                           }
    if (IsChecked $Redux.Unlock.Gauntlets)       { ChangeBytes -Offset @("BC77B4", "BC780D", "BC780E") -Values "09"; ChangeBytes -Offset "AEFA6C" -Values "24080000"                                            }
    if (IsChecked $Redux.Unlock.MegatonHammer)   { ChangeBytes -Offset @("BC77A3", "BC77CD")           -Values "09"                                                                                             }
    

    
    # UNLOCK ADULT RESTRICTIONS #
    
    if (IsChecked $Redux.Unlock.KokiriSword)      { ChangeBytes -Offset @("BC77AD", "BC77F7") -Values "09" }
    if (IsChecked $Redux.Unlock.DekuShield)       { ChangeBytes -Offset @("BC77B1", "BC77FA") -Values "09" }
    if (IsChecked $Redux.Unlock.FairySlingshot)   { ChangeBytes -Offset @("BC779A", "BC77C2") -Values "09" }
    if (IsChecked $Redux.Unlock.Boomerang)        { ChangeBytes -Offset @("BC77A0", "BC77CA") -Values "09" }
    if (IsChecked $Redux.Unlock.DekuSticks)       { ChangeBytes -Offset @("BC7794", "BC77BC") -Values "09" }
    if (IsChecked $Redux.Unlock.CrawlHole)        { ChangeBytes -Offset   "BDAB13"            -Values "00" }



    # UNUSED #

  # ChangeBytes -Offset @("BC77B2", "BC77FB")           -Values "00" # Hylian Shield
  # ChangeBytes -Offset @("BC779B", "BC77C3", "BC77C4") -Values "00" # Ocarina
  # ChangeBytes -Offset @("BC7796", "BC77BE")           -Values "00" # Bomb
  # ChangeBytes -Offset @("BC779C", "BC77C5")           -Values "00" # Bombchu
  # ChangeBytes -Offset @("BC7795", "BC77BD")           -Values "00" # Deku Nut
  # ChangeBytes -Offset @("BC77A1", "BC77CB")           -Values "00" # Lens of Truth
  # ChangeBytes -Offset @("BC77B5", "BC77FD")           -Values "00" # Kokiri Tunic
  # ChangeBytes -Offset @("BC77B9", "BC7800")           -Values "00" # Kokiri Boots

  # ChangeBytes -Offset @("BC7799", "BC77C1")           -Values "00" # Din's Fire
  # ChangeBytes -Offset @("BC779F", "BC77C9")           -Values "00" # Farore's Wind
  # ChangeBytes -Offset @("BC77A5", "BC77CF")           -Values "00" # Nayru's Love
  # ChangeBytes -Offset @("BC77A6", "BC77A7", "BC77A8", "BC77A9", "BC77D0", "BC77D1", "BC77D2", "BC77D3", "BC77D4", "BC77D5", "BC77D6", "BC77D7", "BC77D8", "BC77D9", "BC77DA", "BC77DB", "BC77DC") -Values "00" # Bottles

  # ChangeBytes -Offset @("BC77AC", "BC7806", "BC7807", "BC7808") -Values "01" # Quiver
  # ChangeBytes -Offset @("BC77B0", "BC7809", "BC780A", "BC780B") -Values "01" # Bomb Bag
  # ChangeBytes -Offset @("BC77B8", "BC780F", "BC7810")           -Values "01" # Scale
    


    # STARTING UPGRADES #

    if (IsItem -Elem $Redux.Save.Progression -Item "Deku Stick") {
        $value = Get8Bit (($Redux.Save.DekuSticks.SelectedIndex + 1) * 2);
        ChangeBytes -Offset "B71EFD" -Values @($value, "00", "00") -Add;
        if (IsChecked $Redux.Capacity.EnableAmmo) { $value = $Redux.Capacity["DekuSticks" + ($Redux.Save.DekuSticks.SelectedIndex + 1)].Text } else { $value = $Redux.Capacity["DekuSticks" + ($Redux.Save.DekuSticks.SelectedIndex  + 1)].Default }
        ChangeBytes -Offset "B71EE8" -Values $value
    }

    if (IsItem -Elem $Redux.Save.Progression -Item "Deku Nut") {
        $value = Get8Bit (($Redux.Save.DekuNuts.SelectedIndex   + 1) * 16);
        ChangeBytes -Offset "B71EFD" -Values @($value, "00", "00") -Add;
        if (IsChecked $Redux.Capacity.EnableAmmo) { $value = $Redux.Capacity["DekuNuts" + ($Redux.Save.DekuNuts.SelectedIndex + 1)].Text } else { $value = $Redux.Capacity["DekuNuts" + ($Redux.Save.DekuNuts.SelectedIndex  + 1)].Default }
        ChangeBytes -Offset "B71EE9" -Values $value
    }
    
    if (IsItem -Elem $Redux.Save.Progression -Item "Fairy Slingshot") {
        $value = Get8Bit (($Redux.Save.BulletBag.SelectedIndex  + 1) * 64);
        ChangeBytes -Offset "B71EFD" -Values @("00", $value, "00") -Add;
        if (IsChecked $Redux.Capacity.EnableAmmo) { $value = $Redux.Capacity["BulletBag" + ($Redux.Save.BulletBag.SelectedIndex + 1)].Text } else { $value = $Redux.Capacity["BulletBag" + ($Redux.Save.BulletBag.SelectedIndex  + 1)].Default }
        ChangeBytes -Offset "B71EEE" -Values $value
    }
    
    if (IsItem -Elem $Redux.Save.Progression -Item "Fairy Bow") {
        $value = Get8Bit (($Redux.Save.Quiver.SelectedIndex     + 1) * 1);
        ChangeBytes -Offset "B71EFD" -Values @("00", "00", $value) -Add;
        if (IsChecked $Redux.Capacity.EnableAmmo) { $value = $Redux.Capacity["Quiver" + ($Redux.Save.Quiver.SelectedIndex + 1)].Text } else { $value = $Redux.Capacity["Quiver" + ($Redux.Save.Quiver.SelectedIndex  + 1)].Default }
        ChangeBytes -Offset "B71EEB" -Values $value
    }
    
    if (IsItem -Elem $Redux.Save.Progression -Item "Bomb") {
        $value = Get8Bit (($Redux.Save.BombBag.SelectedIndex    + 1) * 8);
        ChangeBytes -Offset "B71EFD" -Values @("00", "00", $value) -Add;
        if (IsChecked $Redux.Capacity.EnableAmmo) { $value = $Redux.Capacity["BombBag" + ($Redux.Save.BombBag.SelectedIndex + 1)].Text } else { $value = $Redux.Capacity["BombBag" + ($Redux.Save.BombBag.SelectedIndex  + 1)].Default }
        ChangeBytes -Offset "B71EEA" -Values $value
    }
    
    if (IsIndex   $Redux.Save.Strength -Not)    { $value = Get8Bit ($Redux.Save.Strength.SelectedIndex         * 64); ChangeBytes -Offset "B71EFD" -Values @("00", "00", $value) -Add }
    if (IsIndex   $Redux.Save.Scale    -Not)    { $value = Get8Bit ($Redux.Save.Scale.SelectedIndex            * 2);  ChangeBytes -Offset "B71EFD" -Values @("00", $value, "00") -Add }
    if (IsIndex   $Redux.Save.Wallet   -Not)    { $value = Get8Bit ($Redux.Save.Wallet.SelectedIndex           * 16); ChangeBytes -Offset "B71EFD" -Values @("00", $value, "00") -Add }
    if (IsDefault $Redux.Save.Rupees   -Not)    { $value = Get16Bit ([int]$Redux.Save.Rupees.Text);                   ChangeBytes -Offset "B71E90" -Values $value                     }

    if (IsDefault $Redux.Save.Hearts -Not)   {
        $value = Get16Bit ([int]$Redux.Save.Hearts.Text * 16); ChangeBytes -Offset "B71E8A" -Values $value; ChangeBytes -Offset "B71E8C" -Values $value; ChangeBytes -Offset "B0635E" -Values $value; ChangeBytes -Offset "B06366" -Values $value
        if ([int]$Redux.Save.Hearts.Text -lt 3) { ChangeBytes -Offset "BC6286" -Values $value }
    }

    if (IsChecked $Redux.Save.DoubleDefense)   { ChangeBytes -Offset "B71E99" -Values "01"; ChangeBytes -Offset "B71F2B" -Values $Redux.Save.Hearts.Text }
    if (IsChecked $Redux.Save.Magic)           { ChangeBytes -Offset "B71E96" -Values "01"                                                               }
    if (IsChecked $Redux.Save.DoubleMagic)     { ChangeBytes -Offset "B71E98" -Values "01"; ChangeBytes -Offset "B71E8F" -Values "60"                    }



    # ADD STARTING SAVE SLOT PROGRESSION #

    if (IsItem -Elem $Redux.Save.Progression -Item "Kokiri's Emerald")     { ChangeBytes -Offset "B71F01" -Values "04" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Goron's Ruby")         { ChangeBytes -Offset "B71F01" -Values "08" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Zora's Sapphire")      { ChangeBytes -Offset "B71F01" -Values "10" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Forest Medallion")     { ChangeBytes -Offset "B71F03" -Values "01" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Fire Medallion")       { ChangeBytes -Offset "B71F03" -Values "02" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Water Medallion")      { ChangeBytes -Offset "B71F03" -Values "04" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Shadow Medallion")     { ChangeBytes -Offset "B71F03" -Values "08" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Spirit Medallion")     { ChangeBytes -Offset "B71F03" -Values "10" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Light Medallion")      { ChangeBytes -Offset "B71F03" -Values "20" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Gerudo Card")          { ChangeBytes -Offset "B71F01" -Values "40" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Stone of Agony")       { ChangeBytes -Offset "B71F01" -Values "20" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Kokiri Sword")         { ChangeBytes -Offset "B71EF9" -Values "01" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Master Sword")         { ChangeBytes -Offset "B71EF9" -Values "02" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Giant's Knife")        { ChangeBytes -Offset "B71EF9" -Values "04" -Add; if (IsChecked $Redux.Save.BiggoronSword) { ChangeBytes -Offset "B71E9A" -Values "01" } }
    if (IsItem -Elem $Redux.Save.Progression -Item "Deku Shield")          { ChangeBytes -Offset "B71EF9" -Values "10" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Hylian Shield")        { ChangeBytes -Offset "B71EF9" -Values "20" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Mirror Shield")        { ChangeBytes -Offset "B71EF9" -Values "40" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Goron Tunic")          { ChangeBytes -Offset "B71EF8" -Values "02" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Zora Tunic")           { ChangeBytes -Offset "B71EF8" -Values "04" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Iron Boots")           { ChangeBytes -Offset "B71EF8" -Values "20" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Hover Boots")          { ChangeBytes -Offset "B71EF8" -Values "40" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Deku Stick")           { ChangeBytes -Offset "B71ED0" -Values "00" }
    if (IsItem -Elem $Redux.Save.Progression -Item "Deku Nut")             { ChangeBytes -Offset "B71ED1" -Values "01" }
    if (IsItem -Elem $Redux.Save.Progression -Item "Bomb")                 { ChangeBytes -Offset "B71ED2" -Values "02" }
    if (IsItem -Elem $Redux.Save.Progression -Item "Fairy Bow")            { ChangeBytes -Offset "B71ED3" -Values "03" }
    if (IsItem -Elem $Redux.Save.Progression -Item "Fire Arrow")           { ChangeBytes -Offset "B71ED4" -Values "04" }
    if (IsItem -Elem $Redux.Save.Progression -Item "Din's Fire")           { ChangeBytes -Offset "B71ED5" -Values "05" }
    if (IsItem -Elem $Redux.Save.Progression -Item "Fairy Slingshot")      { ChangeBytes -Offset "B71ED6" -Values "06" }
    if (IsItem -Elem $Redux.Save.Progression -Item "Fairy Ocarina")        { if (IsChecked $Redux.Save.OcarinaOfTime) { ChangeBytes -Offset "B71ED7" -Values "08" } else { ChangeBytes -Offset "B71ED7" -Values "07" } }
    if (IsItem -Elem $Redux.Save.Progression -Item "Bombchu")              { ChangeBytes -Offset "B71ED8" -Values "09"; ChangeBytes -Offset "B71EF0" -Values "32" }
    if (IsItem -Elem $Redux.Save.Progression -Item "Hookshot")             { if (IsChecked $Redux.Save.LongShot)      { ChangeBytes -Offset "B71ED9" -Values "0B" } else { ChangeBytes -Offset "B71ED9" -Values "0A" } }
    if (IsItem -Elem $Redux.Save.Progression -Item "Ice Arrow")            { ChangeBytes -Offset "B71EDA" -Values "0C" }
    if (IsItem -Elem $Redux.Save.Progression -Item "Farore's Wind")        { ChangeBytes -Offset "B71EDB" -Values "0D" }
    if (IsItem -Elem $Redux.Save.Progression -Item "Boomerang")            { ChangeBytes -Offset "B71EDC" -Values "0E" }
    if (IsItem -Elem $Redux.Save.Progression -Item "Lens of Truth")        { ChangeBytes -Offset "B71EDD" -Values "0F" }
    if (IsItem -Elem $Redux.Save.Progression -Item "Magic Bean")           { ChangeBytes -Offset "B71EDE" -Values "10"; ChangeBytes -Offset "B71EF6" -Values "0F" }
    if (IsItem -Elem $Redux.Save.Progression -Item "Megaton Hammer")       { ChangeBytes -Offset "B71EDF" -Values "11" }
    if (IsItem -Elem $Redux.Save.Progression -Item "Light Arrow")          { ChangeBytes -Offset "B71EE0" -Values "12" }
    if (IsItem -Elem $Redux.Save.Progression -Item "Nayru's Love")         { ChangeBytes -Offset "B71EE1" -Values "13" }
    if (IsItem -Elem $Redux.Save.Progression -Item "Bottle #1")            { ChangeBytes -Offset "B71EE2" -Values "14" }
    if (IsItem -Elem $Redux.Save.Progression -Item "Bottle #2")            { ChangeBytes -Offset "B71EE3" -Values "14" }
    if (IsItem -Elem $Redux.Save.Progression -Item "Bottle #3")            { ChangeBytes -Offset "B71EE4" -Values "14" }
    if (IsItem -Elem $Redux.Save.Progression -Item "Bottle #4")            { ChangeBytes -Offset "B71EE5" -Values "14" }
    if (IsItem -Elem $Redux.Save.Progression -Item "Zelda's Lullaby")      { ChangeBytes -Offset "B71F02" -Values "10" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Epona's Song")         { ChangeBytes -Offset "B71F02" -Values "20" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Saria's Song")         { ChangeBytes -Offset "B71F02" -Values "40" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Sun's Song")           { ChangeBytes -Offset "B71F02" -Values "80" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Song of Time")         { ChangeBytes -Offset "B71F01" -Values "01" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Song of Storms")       { ChangeBytes -Offset "B71F01" -Values "02" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Minuet of Forest")     { ChangeBytes -Offset "B71F03" -Values "40" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Bolero of Fire")       { ChangeBytes -Offset "B71F03" -Values "80" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Serenade of Water")    { ChangeBytes -Offset "B71F02" -Values "01" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Requiem of Spirit")    { ChangeBytes -Offset "B71F02" -Values "02" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Nocturne of Shadow")   { ChangeBytes -Offset "B71F02" -Values "04" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Prelude of Light")     { ChangeBytes -Offset "B71F02" -Values "08" -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Small Keys")           { ChangeBytes -Offset "B71F18" -Values 8 -Repeat 19      }
    if (IsItem -Elem $Redux.Save.Progression -Item "Boss Keys")            { ChangeBytes -Offset "B71F04" -Values 1 -Repeat 20 -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Compasses")            { ChangeBytes -Offset "B71F04" -Values 2 -Repeat 20 -Add }
    if (IsItem -Elem $Redux.Save.Progression -Item "Dungeon Maps")         { ChangeBytes -Offset "B71F04" -Values 4 -Repeat 20 -Add }

    if   (IsDefault $Redux.Save.TradeSequenceItem -Not)   { ChangeBytes -Offset   "B71EE6"            -Values (Get8Bit ($Redux.Save.TradeSequenceItem.SelectedIndex + 44) ) }
    if   (IsDefault $Redux.Save.Mask              -Not)   { ChangeBytes -Offset   "B71EE7"            -Values (Get8Bit ($Redux.Save.Mask.SelectedIndex              + 32) ) }
    if   (IsDefault $Redux.Save.SkullKidMinigame  -Not)   { ChangeBytes -Offset @("B71E9B", "B71F57") -Values (Get8Bit ($Redux.Save.OcarinaMinigame.SelectedIndex)        ) }
    if   (IsDefault $Redux.Save.GoldSkulltulas    -Not)   { ChangeBytes -Offset   "B71F2C"            -Values (Get8Bit ($Redux.Save.GoldSkulltulas.Text)                  ) }
    


    # REMOVE STARTING SAVE SLOT PROGRESSION #

    if (IsItem -Elem $Redux.Save.DebugProgression -Item "Small Keys")     { ChangeBytes -Offset "B71FD4" -Values 0 -Repeat 19           }
    if (IsItem -Elem $Redux.Save.DebugProgression -Item "Boss Keys")      { ChangeBytes -Offset "B71FC0" -Values 1 -Repeat 10 -Subtract }
    if (IsItem -Elem $Redux.Save.DebugProgression -Item "Compasses")      { ChangeBytes -Offset "B71FC0" -Values 2 -Repeat 10 -Subtract }
    if (IsItem -Elem $Redux.Save.DebugProgression -Item "Dungeon Maps")   { ChangeBytes -Offset "B71FC0" -Values 4 -Repeat 10 -Subtract }
    if (IsItem -Elem $Redux.Save.DebugProgression -Item "Quest Status")   { ChangeBytes -Offset "B71FBC" -Values "00 00 00 00"          }
    if (IsItem -Elem $Redux.Save.DebugProgression -Item "Items")          { ChangeBytes -Offset "B71F8C" -Values 255 -Repeat 24 }
    if (IsItem -Elem $Redux.Save.DebugProgression -Item "Equipment")      { ChangeBytes -Offset "B71FB4" -Values "11 00" }
    if (IsItem -Elem $Redud.Save.DebugProgression -Item "Upgrades")       { ChangeBytes -Offset "B71FB9" -Values "00 00 00" }



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
        if ($Redux.Capacity.Wallet1.Text.Length -gt 3 -or $Redux.Capacity.Wallet2.Text.Length -gt 3 -or $Redux.Capacity.Wallet3.Text.Length -gt 3 -or $Redux.Capacity.Wallet4.Text.Length -gt 3) { $max = 4 } else { $max = 3 }

        ChangeBytes -Offset "B6EC4C" -Values (Get16Bit $Redux.Capacity.Wallet1.Text)
        ChangeBytes -Offset "B6EC4E" -Values (Get16Bit $Redux.Capacity.Wallet2.Text)
        ChangeBytes -Offset "B6EC50" -Values (Get16Bit $Redux.Capacity.Wallet3.Text)
        ChangeBytes -Offset "B6EC52" -Values (Get16Bit $Redux.Capacity.Wallet4.Text)

        if (IsChecked -Elem $Redux.Capacity.DynamicWallet -Not) {
            if ($Redux.Capacity.Wallet1.Text.Length -le 4 -and $Redux.Capacity.Wallet2.Text.Length -le 4 -and $Redux.Capacity.Wallet3.Text.Length -le 4 -and $Redux.Capacity.Wallet4.Text.Length -le 4) {
                ChangeBytes -Offset "B6D571" -Values @( ($max - $Redux.Capacity.Wallet1.Text.Length), ($max - $Redux.Capacity.Wallet2.Text.Length), ($max - $Redux.Capacity.Wallet3.Text.Length), ($max - $Redux.Capacity.Wallet4.Text.Length) ) -Interval 2
                ChangeBytes -Offset "B6D579" -Values @(         $Redux.Capacity.Wallet1.Text.Length,          $Redux.Capacity.Wallet2.Text.Length,          $Redux.Capacity.Wallet3.Text.Length,          $Redux.Capacity.Wallet4.Text.Length)   -Interval 2
            }
        }

        if ($Redux.Capacity.Wallet4.Text -lt $Redux.Capacity.Wallet3.Text) { ChangeBytes -Offset "E5088A" -Values (Get16Bit $Redux.Capacity.Wallet3.Text) } else { ChangeBytes -Offset "E5088A" -Values (Get16Bit $Redux.Capacity.Wallet4.Text) } # Running Man
    }
    elseif (IsChecked $Redux.Misc.TycoonWallet) {
        ChangeBytes -Offset "B6EC52" -Values "03E7"
        ChangeBytes -Offset "B6D57F" -Values 3
    }



    # ITEM DROPS QUANTITY #

    if (IsChecked $Redux.Capacity.EnableDrops) {
        ChangeBytes -Offset "B6D4D1" -Values @($Redux.Capacity.Arrows5.Text,  $Redux.Capacity.Arrows10.Text, $Redux.Capacity.Arrows30.Text)                                           -Interval 2
        ChangeBytes -Offset "AE6D43" -Values   $Redux.Capacity.DekuSeedBullets5.Text
        ChangeBytes -Offset "AE6DCF" -Values   $Redux.Capacity.DekuSeedBullets30.Text
        ChangeBytes -Offset "AE675B" -Values   $Redux.Capacity.DekuStick.Text
        ChangeBytes -Offset "B6D4C9" -Values @($Redux.Capacity.ItemDrops5.Text, $Redux.Capacity.ItemDrops10.Text, $Redux.Capacity.ItemDrops20.Text, $Redux.Capacity.ItemDrops30.Text) -Interval 2
        ChangeBytes -Offset "B9CC39" -Values @($Redux.Capacity.Bombchus5.Text,  $Redux.Capacity.Bombchus30.Text)                                                                      -Interval 2
        ChangeBytes -Offset "AE6B63" -Values   $Redux.Capacity.Bombchus10.Text; ChangeBytes -Offset "AE6B8B" -Values $Redux.Capacity.Bombchus10.Text

        $RupeeG = Get16Bit $Redux.Capacity.RupeeG.Text; $RupeeB = Get16Bit $Redux.Capacity.RupeeB.Text; $RupeeR = Get16Bit $Redux.Capacity.RupeeR.Text; $RupeeP = Get16Bit $Redux.Capacity.RupeeP.Text; $RupeeO = Get16Bit $Redux.Capacity.RupeeO.Text
        ChangeBytes -Offset "B6D4DC" -Values ($RupeeG + $RupeeB + $RupeeR + $RupeeP + $RupeeO)
        ChangeBytes -Offset "DF362E" -Values (Get16Bit $Redux.Capacity.RupeeS.Text)
    }
    


    # SHOP ITEMS QUANTITY #

    $start = GetDecimal $Files.json.shopItems.item_table_start

    if (IsDefault $Redux.ShopQuantity.RecoveryHeart -Not)   { ChangeBytes -Offset ($start + 11 + 0x20 * 16) -Values ([byte]$Redux.ShopQuantity.RecoveryHeart.Text * 16) }
    if (IsDefault $Redux.ShopQuantity.Bombchus10A   -Not)   { ChangeBytes -Offset ($start + 11 + 0x20 * 21) -Values        $Redux.ShopQuantity.Bombchus10A.Text         }
    if (IsDefault $Redux.ShopQuantity.Bombchus10B   -Not)   { ChangeBytes -Offset ($start + 11 + 0x20 * 23) -Values        $Redux.ShopQuantity.Bombchus10B.Text         }
    if (IsDefault $Redux.ShopQuantity.Bombchus10C   -Not)   { ChangeBytes -Offset ($start + 11 + 0x20 * 25) -Values        $Redux.ShopQuantity.Bombchus10C.Text         }
    if (IsDefault $Redux.ShopQuantity.Bombchus10D   -Not)   { ChangeBytes -Offset ($start + 11 + 0x20 * 27) -Values        $Redux.ShopQuantity.Bombchus10D.Text         }
    if (IsDefault $Redux.ShopQuantity.Bombchus20A   -Not)   { ChangeBytes -Offset ($start + 11 + 0x20 * 22) -Values        $Redux.ShopQuantity.Bombchus20A.Text         }
    if (IsDefault $Redux.ShopQuantity.Bombchus20B   -Not)   { ChangeBytes -Offset ($start + 11 + 0x20 * 24) -Values        $Redux.ShopQuantity.Bombchus20B.Text         }
    if (IsDefault $Redux.ShopQuantity.Bombchus20C   -Not)   { ChangeBytes -Offset ($start + 11 + 0x20 * 26) -Values        $Redux.ShopQuantity.Bombchus20C.Text         }
    if (IsDefault $Redux.ShopQuantity.Bombchus20D   -Not)   { ChangeBytes -Offset ($start + 11 + 0x20 * 28) -Values        $Redux.ShopQuantity.Bombchus20D.Text         }
    if (IsDefault $Redux.ShopQuantity.Arrows10      -Not)   { ChangeBytes -Offset ($start + 11 + 0x20 * 44) -Values        $Redux.ShopQuantity.Arrows10.Text            }
    if (IsDefault $Redux.ShopQuantity.Arrows30      -Not)   { ChangeBytes -Offset ($start + 11 + 0x20 * 1)  -Values        $Redux.ShopQuantity.Arrows30.Text            }
    if (IsDefault $Redux.ShopQuantity.Arrows50      -Not)   { ChangeBytes -Offset ($start + 11 + 0x20 * 2)  -Values        $Redux.ShopQuantity.Arrows50.Text            }



    # SHOP ITEMS PRICE #
    
    if (IsDefault $Redux.ShopPrice.RecoveryHeart   -Not)   { $item = Get16Bit $Redux.ShopPrice.RecoveryHeart.Text;   ChangeBytes -Offset ($start + 8 + 0x20 * 16) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.DekuStick       -Not)   { $item = Get16Bit $Redux.ShopPrice.DekuStick.Text;       ChangeBytes -Offset ($start + 8 + 0x20 * 5)  -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.DekuNuts5       -Not)   { $item = Get16Bit $Redux.ShopPrice.DekuNuts5.Text;       ChangeBytes -Offset ($start + 8 + 0x20 * 0)  -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.DekuNuts10      -Not)   { $item = Get16Bit $Redux.ShopPrice.DekuNuts10.Text;      ChangeBytes -Offset ($start + 8 + 0x20 * 4)  -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.Bombs5A         -Not)   { $item = Get16Bit $Redux.ShopPrice.Bombs5A.Text;         ChangeBytes -Offset ($start + 8 + 0x20 * 3)  -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.Bombs5B         -Not)   { $item = Get16Bit $Redux.ShopPrice.Bombs5B.Text;         ChangeBytes -Offset ($start + 8 + 0x20 * 47) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.Bombs10         -Not)   { $item = Get16Bit $Redux.ShopPrice.Bombs10.Text;         ChangeBytes -Offset ($start + 8 + 0x20 * 6)  -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.Bombs20         -Not)   { $item = Get16Bit $Redux.ShopPrice.Bombs20.Text;         ChangeBytes -Offset ($start + 8 + 0x20 * 45) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.Bombs30         -Not)   { $item = Get16Bit $Redux.ShopPrice.Bombs30.Text;         ChangeBytes -Offset ($start + 8 + 0x20 * 46) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.Bombchus10A     -Not)   { $item = Get16Bit $Redux.ShopPrice.Bombchus10A.Text;     ChangeBytes -Offset ($start + 8 + 0x20 * 21) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.Bombchus10B     -Not)   { $item = Get16Bit $Redux.ShopPrice.Bombchus10B.Text;     ChangeBytes -Offset ($start + 8 + 0x20 * 23) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.Bombchus10C     -Not)   { $item = Get16Bit $Redux.ShopPrice.Bombchus10C.Text;     ChangeBytes -Offset ($start + 8 + 0x20 * 25) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.Bombchus10D     -Not)   { $item = Get16Bit $Redux.ShopPrice.Bombchus10D.Text;     ChangeBytes -Offset ($start + 8 + 0x20 * 27) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.Bombchus20A     -Not)   { $item = Get16Bit $Redux.ShopPrice.Bombchus20A.Text;     ChangeBytes -Offset ($start + 8 + 0x20 * 22) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.Bombchus20B     -Not)   { $item = Get16Bit $Redux.ShopPrice.Bombchus20B.Text;     ChangeBytes -Offset ($start + 8 + 0x20 * 24) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.Bombchus20C     -Not)   { $item = Get16Bit $Redux.ShopPrice.Bombchus20C.Text;     ChangeBytes -Offset ($start + 8 + 0x20 * 26) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.Bombchus20D     -Not)   { $item = Get16Bit $Redux.ShopPrice.Bombchus20D.Text;     ChangeBytes -Offset ($start + 8 + 0x20 * 28) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.DekuSeedBullets -Not)   { $item = Get16Bit $Redux.ShopPrice.DekuSeedBullets.Text; ChangeBytes -Offset ($start + 8 + 0x20 * 29) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.Arrows10        -Not)   { $item = Get16Bit $Redux.ShopPrice.Arrows10.Text;        ChangeBytes -Offset ($start + 8 + 0x20 * 44) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.Arrows30        -Not)   { $item = Get16Bit $Redux.ShopPrice.Arrows30.Text;        ChangeBytes -Offset ($start + 8 + 0x20 * 1)  -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.Arrows50        -Not)   { $item = Get16Bit $Redux.ShopPrice.Arrows50.Text;        ChangeBytes -Offset ($start + 8 + 0x20 * 2)  -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.DekuShield      -Not)   { $item = Get16Bit $Redux.ShopPrice.DekuShield.Text;      ChangeBytes -Offset ($start + 8 + 0x20 * 13) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.HylianShield    -Not)   { $item = Get16Bit $Redux.ShopPrice.HylianShield.Text;    ChangeBytes -Offset ($start + 8 + 0x20 * 12) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.GiantsKnife     -Not)   { $item = Get16Bit $Redux.ShopPrice.GiantsKnife.Text;     ChangeBytes -Offset ($start + 8 + 0x20 * 11) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.GoronTunic      -Not)   { $item = Get16Bit $Redux.ShopPrice.GoronTunic.Text;      ChangeBytes -Offset ($start + 8 + 0x20 * 14) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.ZoraTunic       -Not)   { $item = Get16Bit $Redux.ShopPrice.ZoraTunic.Text;       ChangeBytes -Offset ($start + 8 + 0x20 * 15) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.RedPotionA      -Not)   { $item = Get16Bit $Redux.ShopPrice.RedPotionA.Text;      ChangeBytes -Offset ($start + 8 + 0x20 * 8)  -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.RedPotionB      -Not)   { $item = Get16Bit $Redux.ShopPrice.RedPotionB.Text;      ChangeBytes -Offset ($start + 8 + 0x20 * 48) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.RedPotionC      -Not)   { $item = Get16Bit $Redux.ShopPrice.RedPotionC.Text;      ChangeBytes -Offset ($start + 8 + 0x20 * 49) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.GreenPotion     -Not)   { $item = Get16Bit $Redux.ShopPrice.GreenPotion.Text;     ChangeBytes -Offset ($start + 8 + 0x20 * 9)  -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.BluePotion      -Not)   { $item = Get16Bit $Redux.ShopPrice.BluePotion.Text;      ChangeBytes -Offset ($start + 8 + 0x20 * 10) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.Milk            -Not)   { $item = Get16Bit $Redux.ShopPrice.Milk.Text;            ChangeBytes -Offset ($start + 8 + 0x20 * 17) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.Fairy           -Not)   { $item = Get16Bit $Redux.ShopPrice.Fairy.Text;           ChangeBytes -Offset ($start + 8 + 0x20 * 43) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.BlueFire        -Not)   { $item = Get16Bit $Redux.ShopPrice.BlueFire.Text;        ChangeBytes -Offset ($start + 8 + 0x20 * 39) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.Bug             -Not)   { $item = Get16Bit $Redux.ShopPrice.Bug.Text;             ChangeBytes -Offset ($start + 8 + 0x20 * 40) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.Fish            -Not)   { $item = Get16Bit $Redux.ShopPrice.Fish.Text;            ChangeBytes -Offset ($start + 8 + 0x20 * 7)  -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.Poe             -Not)   { $item = Get16Bit $Redux.ShopPrice.Poe.Text;             ChangeBytes -Offset ($start + 8 + 0x20 * 42) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.BigPoe          -Not)   { $item = Get16Bit $Redux.ShopPrice.BigPoe.Text;          ChangeBytes -Offset ($start + 8 + 0x20 * 41) -Values @($item.Substring(0, 2), $item.Substring(2) ) }
    if (IsDefault $Redux.ShopPrice.WeirdEgg        -Not)   { $item = Get16Bit $Redux.ShopPrice.WeirdEgg.Text;        ChangeBytes -Offset ($start + 8 + 0x20 * 18) -Values @($item.Substring(0, 2), $item.Substring(2) ) }

    if (IsChecked $Redux.ShopPrice.FixItems) {
        ChangeBytes -Offset ($start + 12 + 0x20 * 11) -Values "010E010D" # Giant's Knife
        ChangeBytes -Offset ($start + 12 + 0x20 * 17) -Values "0110010F" # Milk
        ChangeBytes -Offset ($start + 12 + 0x20 * 18) -Values "01120111" # Weird Egg
        ChangeBytes -Offset ($start + 12 + 0x20 * 41) -Values "0113506F" # Big Poe
    }




    # SHOP ITEMS #

    $start = GetDecimal $Files.json.shopItems.shop_table_start

    if (IsDefault $Redux.Bazaar.Slot1             -Not)   { ChangeBytes -Offset ($start + 8 * 0 + 0x40 * 4) -Values (GetOoTShopItem $Redux.Bazaar.Slot1.Text)             }
    if (IsDefault $Redux.Bazaar.Slot2             -Not)   { ChangeBytes -Offset ($start + 8 * 1 + 0x40 * 4) -Values (GetOoTShopItem $Redux.Bazaar.Slot2.Text)             }
    if (IsDefault $Redux.Bazaar.Slot3             -Not)   { ChangeBytes -Offset ($start + 8 * 2 + 0x40 * 4) -Values (GetOoTShopItem $Redux.Bazaar.Slot3.Text)             }
    if (IsDefault $Redux.Bazaar.Slot4             -Not)   { ChangeBytes -Offset ($start + 8 * 3 + 0x40 * 4) -Values (GetOoTShopItem $Redux.Bazaar.Slot4.Text)             }
    if (IsDefault $Redux.Bazaar.Slot5             -Not)   { ChangeBytes -Offset ($start + 8 * 4 + 0x40 * 4) -Values (GetOoTShopItem $Redux.Bazaar.Slot5.Text)             }
    if (IsDefault $Redux.Bazaar.Slot6             -Not)   { ChangeBytes -Offset ($start + 8 * 5 + 0x40 * 4) -Values (GetOoTShopItem $Redux.Bazaar.Slot6.Text)             }
    if (IsDefault $Redux.Bazaar.Slot7             -Not)   { ChangeBytes -Offset ($start + 8 * 6 + 0x40 * 4) -Values (GetOoTShopItem $Redux.Bazaar.Slot7.Text)             }
    if (IsDefault $Redux.Bazaar.Slot8             -Not)   { ChangeBytes -Offset ($start + 8 * 7 + 0x40 * 4) -Values (GetOoTShopItem $Redux.Bazaar.Slot8.Text)             }

    if (IsDefault $Redux.Bazaar2.Slot1            -Not)   { ChangeBytes -Offset ($start + 8 * 0 + 0x40 * 5) -Values (GetOoTShopItem $Redux.Bazaar2.Slot1.Text)            }
    if (IsDefault $Redux.Bazaar2.Slot2            -Not)   { ChangeBytes -Offset ($start + 8 * 1 + 0x40 * 5) -Values (GetOoTShopItem $Redux.Bazaar2.Slot2.Text)            }
    if (IsDefault $Redux.Bazaar2.Slot3            -Not)   { ChangeBytes -Offset ($start + 8 * 2 + 0x40 * 5) -Values (GetOoTShopItem $Redux.Bazaar2.Slot3.Text)            }
    if (IsDefault $Redux.Bazaar2.Slot4            -Not)   { ChangeBytes -Offset ($start + 8 * 3 + 0x40 * 5) -Values (GetOoTShopItem $Redux.Bazaar2.Slot4.Text)            }
    if (IsDefault $Redux.Bazaar2.Slot5            -Not)   { ChangeBytes -Offset ($start + 8 * 4 + 0x40 * 5) -Values (GetOoTShopItem $Redux.Bazaar2.Slot5.Text)            }
    if (IsDefault $Redux.Bazaar2.Slot6            -Not)   { ChangeBytes -Offset ($start + 8 * 5 + 0x40 * 5) -Values (GetOoTShopItem $Redux.Bazaar2.Slot6.Text)            }
    if (IsDefault $Redux.Bazaar2.Slot7            -Not)   { ChangeBytes -Offset ($start + 8 * 6 + 0x40 * 5) -Values (GetOoTShopItem $Redux.Bazaar2.Slot7.Text)            }
    if (IsDefault $Redux.Bazaar2.Slot8            -Not)   { ChangeBytes -Offset ($start + 8 * 7 + 0x40 * 5) -Values (GetOoTShopItem $Redux.Bazaar2.Slot8.Text)            }

    if (IsDefault $Redux.MarketPotionShop.Slot1   -Not)   { ChangeBytes -Offset ($start + 8 * 0 + 0x40 * 3) -Values (GetOoTShopItem $Redux.MarketPotionShop.Slot1.Text)   }
    if (IsDefault $Redux.MarketPotionShop.Slot2   -Not)   { ChangeBytes -Offset ($start + 8 * 1 + 0x40 * 3) -Values (GetOoTShopItem $Redux.MarketPotionShop.Slot2.Text)   }
    if (IsDefault $Redux.MarketPotionShop.Slot3   -Not)   { ChangeBytes -Offset ($start + 8 * 2 + 0x40 * 3) -Values (GetOoTShopItem $Redux.MarketPotionShop.Slot3.Text)   }
    if (IsDefault $Redux.MarketPotionShop.Slot4   -Not)   { ChangeBytes -Offset ($start + 8 * 3 + 0x40 * 3) -Values (GetOoTShopItem $Redux.MarketPotionShop.Slot4.Text)   }
    if (IsDefault $Redux.MarketPotionShop.Slot5   -Not)   { ChangeBytes -Offset ($start + 8 * 4 + 0x40 * 3) -Values (GetOoTShopItem $Redux.MarketPotionShop.Slot5.Text)   }
    if (IsDefault $Redux.MarketPotionShop.Slot6   -Not)   { ChangeBytes -Offset ($start + 8 * 5 + 0x40 * 3) -Values (GetOoTShopItem $Redux.MarketPotionShop.Slot6.Text)   }
    if (IsDefault $Redux.MarketPotionShop.Slot7   -Not)   { ChangeBytes -Offset ($start + 8 * 6 + 0x40 * 3) -Values (GetOoTShopItem $Redux.MarketPotionShop.Slot7.Text)   }
    if (IsDefault $Redux.MarketPotionShop.Slot8   -Not)   { ChangeBytes -Offset ($start + 8 * 7 + 0x40 * 3) -Values (GetOoTShopItem $Redux.MarketPotionShop.Slot8.Text)   }

    if (IsDefault $Redux.KakarikoPotionShop.Slot1 -Not)   { ChangeBytes -Offset ($start + 8 * 0 + 0x40 * 1) -Values (GetOoTShopItem $Redux.KakarikoPotionShop.Slot1.Text) }
    if (IsDefault $Redux.KakarikoPotionShop.Slot2 -Not)   { ChangeBytes -Offset ($start + 8 * 1 + 0x40 * 1) -Values (GetOoTShopItem $Redux.KakarikoPotionShop.Slot2.Text) }
    if (IsDefault $Redux.KakarikoPotionShop.Slot3 -Not)   { ChangeBytes -Offset ($start + 8 * 2 + 0x40 * 1) -Values (GetOoTShopItem $Redux.KakarikoPotionShop.Slot3.Text) }
    if (IsDefault $Redux.KakarikoPotionShop.Slot4 -Not)   { ChangeBytes -Offset ($start + 8 * 3 + 0x40 * 1) -Values (GetOoTShopItem $Redux.KakarikoPotionShop.Slot4.Text) }
    if (IsDefault $Redux.KakarikoPotionShop.Slot5 -Not)   { ChangeBytes -Offset ($start + 8 * 4 + 0x40 * 1) -Values (GetOoTShopItem $Redux.KakarikoPotionShop.Slot5.Text) }
    if (IsDefault $Redux.KakarikoPotionShop.Slot6 -Not)   { ChangeBytes -Offset ($start + 8 * 5 + 0x40 * 1) -Values (GetOoTShopItem $Redux.KakarikoPotionShop.Slot6.Text) }
    if (IsDefault $Redux.KakarikoPotionShop.Slot7 -Not)   { ChangeBytes -Offset ($start + 8 * 6 + 0x40 * 1) -Values (GetOoTShopItem $Redux.KakarikoPotionShop.Slot7.Text) }
    if (IsDefault $Redux.KakarikoPotionShop.Slot8 -Not)   { ChangeBytes -Offset ($start + 8 * 7 + 0x40 * 1) -Values (GetOoTShopItem $Redux.KakarikoPotionShop.Slot8.Text) }

    if (IsDefault $Redux.BombchuShop.Slot1        -Not)   { ChangeBytes -Offset ($start + 8 * 0 + 0x40 * 2) -Values (GetOoTShopItem $Redux.BombchuShop.Slot1.Text)        }
    if (IsDefault $Redux.BombchuShop.Slot2        -Not)   { ChangeBytes -Offset ($start + 8 * 1 + 0x40 * 2) -Values (GetOoTShopItem $Redux.BombchuShop.Slot2.Text)        }
    if (IsDefault $Redux.BombchuShop.Slot3        -Not)   { ChangeBytes -Offset ($start + 8 * 2 + 0x40 * 2) -Values (GetOoTShopItem $Redux.BombchuShop.Slot3.Text)        }
    if (IsDefault $Redux.BombchuShop.Slot4        -Not)   { ChangeBytes -Offset ($start + 8 * 3 + 0x40 * 2) -Values (GetOoTShopItem $Redux.BombchuShop.Slot4.Text)        }
    if (IsDefault $Redux.BombchuShop.Slot5        -Not)   { ChangeBytes -Offset ($start + 8 * 4 + 0x40 * 2) -Values (GetOoTShopItem $Redux.BombchuShop.Slot5.Text)        }
    if (IsDefault $Redux.BombchuShop.Slot6        -Not)   { ChangeBytes -Offset ($start + 8 * 5 + 0x40 * 2) -Values (GetOoTShopItem $Redux.BombchuShop.Slot6.Text)        }
    if (IsDefault $Redux.BombchuShop.Slot7        -Not)   { ChangeBytes -Offset ($start + 8 * 6 + 0x40 * 2) -Values (GetOoTShopItem $Redux.BombchuShop.Slot7.Text)        }
    if (IsDefault $Redux.BombchuShop.Slot8        -Not)   { ChangeBytes -Offset ($start + 8 * 7 + 0x40 * 2) -Values (GetOoTShopItem $Redux.BombchuShop.Slot8.Text)        }

    if (IsDefault $Redux.KokiriShop.Slot1         -Not)   { ChangeBytes -Offset ($start + 8 * 0 + 0x40 * 0) -Values (GetOoTShopItem $Redux.KokiriShop.Slot1.Text)         }
    if (IsDefault $Redux.KokiriShop.Slot2         -Not)   { ChangeBytes -Offset ($start + 8 * 1 + 0x40 * 0) -Values (GetOoTShopItem $Redux.KokiriShop.Slot2.Text)         }
    if (IsDefault $Redux.KokiriShop.Slot3         -Not)   { ChangeBytes -Offset ($start + 8 * 2 + 0x40 * 0) -Values (GetOoTShopItem $Redux.KokiriShop.Slot3.Text)         }
    if (IsDefault $Redux.KokiriShop.Slot4         -Not)   { ChangeBytes -Offset ($start + 8 * 3 + 0x40 * 0) -Values (GetOoTShopItem $Redux.KokiriShop.Slot4.Text)         }
    if (IsDefault $Redux.KokiriShop.Slot5         -Not)   { ChangeBytes -Offset ($start + 8 * 4 + 0x40 * 0) -Values (GetOoTShopItem $Redux.KokiriShop.Slot5.Text)         }
    if (IsDefault $Redux.KokiriShop.Slot6         -Not)   { ChangeBytes -Offset ($start + 8 * 5 + 0x40 * 0) -Values (GetOoTShopItem $Redux.KokiriShop.Slot6.Text)         }
    if (IsDefault $Redux.KokiriShop.Slot7         -Not)   { ChangeBytes -Offset ($start + 8 * 6 + 0x40 * 0) -Values (GetOoTShopItem $Redux.KokiriShop.Slot7.Text)         }
    if (IsDefault $Redux.KokiriShop.Slot8         -Not)   { ChangeBytes -Offset ($start + 8 * 7 + 0x40 * 0) -Values (GetOoTShopItem $Redux.KokiriShop.Slot8.Text)         }

    if (IsDefault $Redux.GoronShop.Slot1          -Not)   { ChangeBytes -Offset ($start + 8 * 0 + 0x40 * 8) -Values (GetOoTShopItem $Redux.GoronShop.Slot1.Text)          }
    if (IsDefault $Redux.GoronShop.Slot2          -Not)   { ChangeBytes -Offset ($start + 8 * 1 + 0x40 * 8) -Values (GetOoTShopItem $Redux.GoronShop.Slot2.Text)          }
    if (IsDefault $Redux.GoronShop.Slot3          -Not)   { ChangeBytes -Offset ($start + 8 * 2 + 0x40 * 8) -Values (GetOoTShopItem $Redux.GoronShop.Slot3.Text)          }
    if (IsDefault $Redux.GoronShop.Slot4          -Not)   { ChangeBytes -Offset ($start + 8 * 3 + 0x40 * 8) -Values (GetOoTShopItem $Redux.GoronShop.Slot4.Text)          }
    if (IsDefault $Redux.GoronShop.Slot5          -Not)   { ChangeBytes -Offset ($start + 8 * 4 + 0x40 * 8) -Values (GetOoTShopItem $Redux.GoronShop.Slot5.Text)          }
    if (IsDefault $Redux.GoronShop.Slot6          -Not)   { ChangeBytes -Offset ($start + 8 * 5 + 0x40 * 8) -Values (GetOoTShopItem $Redux.GoronShop.Slot6.Text)          }
    if (IsDefault $Redux.GoronShop.Slot7          -Not)   { ChangeBytes -Offset ($start + 8 * 6 + 0x40 * 8) -Values (GetOoTShopItem $Redux.GoronShop.Slot7.Text)          }
    if (IsDefault $Redux.GoronShop.Slot8          -Not)   { ChangeBytes -Offset ($start + 8 * 7 + 0x40 * 8) -Values (GetOoTShopItem $Redux.GoronShop.Slot8.Text)          }

    if (IsDefault $Redux.ZoraShop.Slot1           -Not)   { ChangeBytes -Offset ($start + 8 * 0 + 0x40 * 7) -Values (GetOoTShopItem $Redux.ZoraShop.Slot1.Text)           }
    if (IsDefault $Redux.ZoraShop.Slot2           -Not)   { ChangeBytes -Offset ($start + 8 * 1 + 0x40 * 7) -Values (GetOoTShopItem $Redux.ZoraShop.Slot2.Text)           }
    if (IsDefault $Redux.ZoraShop.Slot3           -Not)   { ChangeBytes -Offset ($start + 8 * 2 + 0x40 * 7) -Values (GetOoTShopItem $Redux.ZoraShop.Slot3.Text)           }
    if (IsDefault $Redux.ZoraShop.Slot4           -Not)   { ChangeBytes -Offset ($start + 8 * 3 + 0x40 * 7) -Values (GetOoTShopItem $Redux.ZoraShop.Slot4.Text)           }
    if (IsDefault $Redux.ZoraShop.Slot5           -Not)   { ChangeBytes -Offset ($start + 8 * 4 + 0x40 * 7) -Values (GetOoTShopItem $Redux.ZoraShop.Slot5.Text)           }
    if (IsDefault $Redux.ZoraShop.Slot6           -Not)   { ChangeBytes -Offset ($start + 8 * 5 + 0x40 * 7) -Values (GetOoTShopItem $Redux.ZoraShop.Slot6.Text)           }
    if (IsDefault $Redux.ZoraShop.Slot7           -Not)   { ChangeBytes -Offset ($start + 8 * 6 + 0x40 * 7) -Values (GetOoTShopItem $Redux.ZoraShop.Slot7.Text)           }
    if (IsDefault $Redux.ZoraShop.Slot8           -Not)   { ChangeBytes -Offset ($start + 8 * 7 + 0x40 * 7) -Values (GetOoTShopItem $Redux.ZoraShop.Slot8.Text)           }

    
    
    # CUTSCENES #

    if (IsItem -Elem $Redux.Skip.RegularSongs -Item "Learn Regular Songs") {
        ChangeBytes -Offset "2E8E90C" -Values "000003E8000000010073003B003C003C"; ChangeBytes -Offset "2E8E91C" -Values "000000130000000C0017000000100002088BFFFF00D4001100200000FFFFFFFF"                                                   # Zelda's Lullaby
        ChangeBytes -Offset "29BEF60" -Values "000003E800000001005E000A000B000B"; ChangeBytes -Offset "29BECB0" -Values "000000130000000200D2000000090000FFFFFFFFFFFF000A003CFFFFFFFFFFFF"                                                   # Epona's Song
        ChangeBytes -Offset "332A4A4" -Values "0000003C";                         ChangeBytes -Offset "332A868" -Values "00000013000000080018000000100002088BFFFF00D3001100200000FFFFFFFF"                                                   # Sun's Song
        ChangeBytes -Offset "252FB98" -Values "000003E8000000010035003B003C003C"; ChangeBytes -Offset "252FC80" -Values "000000130000000C0019000000100002088BFFFF00D5001100200000FFFFFFFF"; ChangeBytes -Offset "1FC3B84" -Values "FFFFFFFF" # Song of Time
        ChangeBytes -Offset "3041084" -Values "0000000A";                         ChangeBytes -Offset "3041088" -Values "000000130000000200D6000000090000FFFFFFFFFFFF00BE00C8FFFFFFFFFFFF"                                                   # Song of Storms

        # Saria's Song
        ChangeBytes -Offset "20B1734" -Values "0000003C";         ChangeBytes -Offset "20B1DA8" -Values "000000130000000C0015000000100002088BFFFF00D1001100200000FFFFFFFF"; ChangeBytes -Offset "20B19C0" -Values "0000000A00000006"
        ChangeBytes -Offset "20B19C8" -Values "0011000000100000"; ChangeBytes -Offset "20B19F8" -Values "003E0011002000008000000000000000000001D4FFFFF73100000000000001D4FFFFF712"
    }

    if (IsItem -Elem $Redux.Skip.Cutscenes -Item "Learn Warp Songs") {
        # Minuet of Forest
        ChangeBytes -Offset "20AFF84" -Values "0000003C";         ChangeBytes -Offset "20B0800" -Values "000000130000000A000F000000100002088BFFFF0073001100200000FFFFFFFF"
        ChangeBytes -Offset "20AFF88" -Values "0000000A00000005"; ChangeBytes -Offset "20AFF90" -Values "0011000000100000"; ChangeBytes -Offset "20AFFC1" -Values "003E001100200000"

        # Bolero of Fire
        ChangeBytes -Offset "224B5D4" -Values "0000003C";         ChangeBytes -Offset "224D7E8" -Values "000000130000000A0010000000100002088BFFFF0074001100200000FFFFFFFF"; ChangeBytes -Offset "224B5D8" -Values "0000000A0000000B"
        ChangeBytes -Offset "224B5E0" -Values "0011000000100000"; ChangeBytes -Offset "224B610" -Values "003E001100200000";                                                 ChangeBytes -Offset "224B7F0" -Values "0000002F0000000E"; ChangeBytes -Offset @("224B7F8", "224B828", "224B858", "224B888") -Values "0000"

        # Serenade of Water
        ChangeBytes -Offset "2BEB254" -Values "0000003C";         ChangeBytes -Offset "2BEC880" -Values "00000013000000100011000000100002088BFFFF0075001100200000FFFFFFFF";         ChangeBytes -Offset "2BEB258" -Values "0000000A0000000F"; ChangeBytes -Offset "2BEB260" -Values "0011000000100000"
        ChangeBytes -Offset "2BEB290" -Values "003E001100200000"; ChangeBytes -Offset "2BEB538" -Values "00000000018A00001BBB0000FFFFFB108000011A00000330FFFFFB108000011A00000330"; ChangeBytes -Offset "2BEB530" -Values "0000002F00000006"; ChangeBytes -Offset "2BEC848" -Values "00000056000000010059002100220000"

        # Nocturne of Shadow
        ChangeBytes -Offset "1FFE458" -Values "000003E800000001002F000100020002"; ChangeBytes -Offset "1FFFDF4" -Values "0000003C"; ChangeBytes -Offset "2000FD8" -Values "000000130000000E0013000000100002088BFFFF0077001100200000FFFFFFFF"; ChangeBytes -Offset "2000128" -Values "000003E8000000010032003A003B003B"

        # Requiem of Spirit
        ChangeBytes -Offset "218AF14" -Values "0218AF14";         ChangeBytes -Offset "218C574" -Values "00000013000000080012000000100002088BFFFF0076001100200000FFFFFFFF";                                 ChangeBytes -Offset "218B478" -Values "000003E8000000010030003A003B003B"
        ChangeBytes -Offset "218AF18" -Values "0000000A0000000B"; ChangeBytes -Offset "218AF20" -Values "001100000010000040000000FFFFFAF90000000800000001FFFFFAF900000008000000010F6714080000000000000001"; ChangeBytes -Offset "218AF50" -Values "003E001100200000"

        # Prelude of Light
        ChangeBytes -Offset "252FD24" -Values "0000004A";         ChangeBytes -Offset "2531320" -Values "000000130000000E0014000000100002088BFFFF0078001100200000FFFFFFFF"; ChangeBytes -Offset "252FF10" -Values "0000002F00000009";
        ChangeBytes -Offset "252FF18" -Values "0006000000000000"; ChangeBytes -Offset "25313D0" -Values "0000005600000001003B002100220000"
    }

    if (IsItem -Elem $Redux.Skip.Cutscenes -Item "Beated Dungeon Outro") {
        ChangeBytes -Offset "2077E20" -Values "0007000100020002"; ChangeBytes -Offset "2078A10" -Values "000E001F00200020"; ChangeBytes -Offset "2079570" -Values "00800000001E0000FFFFFFFFFFFF001E0028FFFFFFFFFFFF"                           # Inside the Deku Tree
        ChangeBytes -Offset "2221E88" -Values "000C003B003C003C"; ChangeBytes -Offset "2223308" -Values "00810000003A0000"                                                                                                                     # Dodongo's Cavern
        ChangeBytes -Offset "CA3530"  -Values "00000000";         ChangeBytes -Offset "2113340" -Values "000D003B003C003C"; ChangeBytes -Offset "2113C18" -Values "00820000003A0000"; ChangeBytes -Offset "21131D0" -Values "00010000003C003C" # Inside Jabu-Jabu's Belly
        ChangeBytes -Offset "D4ED68"  -Values "0045003B003C003C"; ChangeBytes -Offset "D4ED78"  -Values "003E0000003A0000"; ChangeBytes -Offset "207B9D4" -Values "FFFFFFFF"                                                                   # Forest Temple
        ChangeBytes -Offset "2001848" -Values "001E000100020002"; ChangeBytes -Offset "D100B4"  -Values "0062003B003C003C"; ChangeBytes -Offset "D10134"  -Values "003C0000003A0000"                                                           # Fire Temple
        ChangeBytes -Offset "D5A458"  -Values "0015003B003C003C"; ChangeBytes -Offset "D5A3A8"  -Values "003D0000003A0000"; ChangeBytes -Offset "20D0D20" -Values "002900C700C800C8"                                                           # Water Temple
        ChangeBytes -Offset "D13EC8"  -Values "0061003B003C003C"; ChangeBytes -Offset "D13E18"  -Values "00410000003A0000"                                                                                                                     # Shadow Temple
        ChangeBytes -Offset "D3A0A8"  -Values "0060003B003C003C"; ChangeBytes -Offset "D39FF0"  -Values "003F0000003A0000"                                                                                                                     # Spirit Temple
    }

    if (IsItem -Elem $Redux.Skip.Cutscenes -Item "Get Light Arrow") {
        ChangeBytes -Offset "2531B40" -Values "0028000100020002"; ChangeBytes -Offset "2532FBC" -Values "0075";       ChangeBytes -Offset "2532FEA" -Values "00750080"; ChangeBytes -Offset "2533115" -Values "05"; ChangeBytes -Offset "2533141" -Values "0600060010"
        ChangeBytes -Offset "2533171" -Values "0F00110040";       ChangeBytes -Offset "25331A1" -Values "0700410065"; ChangeBytes -Offset "2533642" -Values "0050";     ChangeBytes -Offset "253389D" -Values "74"; ChangeBytes -Offset "25338A4" -Values "007200750079"
        ChangeBytes -Offset "25338BC" -Values "FFFF";             ChangeBytes -Offset "25338C2" -Values "FFFFFFFFFFFF"
        ChangeBytes -Offset "25339C2" -Values "00750076";         ChangeBytes -Offset "2533830" -Values "0031008100820082"
    }
    
    if (IsItem -Elem $Redux.Skip.Cutscenes -Item "Opening Royal Tomb") { ChangeBytes -Offset @("2025026", "2023C86") -Values "0001"; ChangeBytes -Offset @("2025159", "2023E19") -Values "02" }
    
    if (IsItem $Redux.Skip.Cutscenes -Item "Lost Woods Bullet Bag") {
        ChangeBytes -Offset "ECA900" -Values "2403C000"; ChangeBytes -Offset "ECAE90" -Values "2718FD04"; ChangeBytes -Offset "ECB618" -Values "256B00D4"
        ChangeBytes -Offset "ECAE70" -Values "00000000"; ChangeBytes -Offset "E5972C" -Values "24080001"
    }

    if (IsItem -Elem $Redux.Speedup.Cutscenes -Item "Opening Kakariko Gate") { ChangeBytes -Offset @("DD3686", "DD375E") -Values "40000000000000000000"; ChangeBytes -Offset @("DD367E", "DD3756") -Values "4000"; ChangeBytes -Offset @("DD366F", "DD3747") -Values "D0" }

    if (IsItem -Elem $Redux.Speedup.Cutscenes -Item "Ingo Epona Race") {
        ChangeBytes -Offset   "29BE9CB"                        -Values "01"   # Ingo Epona Race
        ChangeBytes -Offset @("29BE987", "29BE9CD")            -Values "02"   # Ingo Epona Race
        ChangeBytes -Offset @("1FC79E6", "1FC7F06", "1FC8556") -Values "0054" # South, East, West
        ChangeBytes -Offset   "1FC8B36"                        -Values "002A" # Front gate
    }

    if (IsItem -Elem $Redux.Speedup.Cutscenes -Item "Boss Intros & Outros") {
        ChangeBytes -Offset @("C944D8", "C94548", "C94730", "C945A8", "C94594") -Values "00000000";                                                                                                                                                                                                          # Phantom Ganon
        ChangeBytes -Offset "2F5AF84"             -Values "00000005"; ChangeBytes -Offset "2F5C7DA" -Values "00010002"; ChangeBytes -Offset "2F5C7A2" -Values "00030004"; ChangeBytes -Offset "2F5B369" -Values "09"; ChangeBytes -Offset "2F5B491" -Values "04"; ChangeBytes -Offset "2F5B559" -Values "04" # Nabooru
        ChangeBytes -Offset "2F5B621"             -Values "04";       ChangeBytes -Offset "2F5B761" -Values "07";       ChangeBytes -Offset "2F5B840" -Values "0005000100050005"                                       # Shorten white flash
        ChangeBytes -Offset "D67BA4"              -Values "1000";     ChangeBytes -Offset "D678CC"  -Values "240103A2A6010142"                                                                                         # Twinrova
        ChangeBytes -Offset "D82047"              -Values "09"                                                                                                                                                         # Ganondorf
        ChangeBytes -Offset "D82AB3"              -Values "66";       ChangeBytes -Offset "D82FAF"  -Values "65";       ChangeBytes -Offset "D82D2E"  -Values "041F";     ChangeBytes -Offset "D83142"  -Values "006B" # Zelda Descend
        ChangeBytes -Offset @("D82DD8", "D82ED4") -Values "00000000"; ChangeBytes -Offset "D82FDF"  -Values "33"                                                                                                       # Zelda Descend
        ChangeBytes -Offset "E82E0F"              -Values "04"                                                                                                                                                         # After Tower Collapse
        ChangeBytes -Offset @("E83D28", "E83B5C") -Values "00000000"; ChangeBytes -Offset "E84C80"  -Values "1000"                                                                                                     # Ganon Intro
    }

    if (IsItem -Elem $Redux.Speedup.Cutscenes -Item "Get Fairy Ocarina") { ChangeBytes -Offset "2151230" -Values "0072003C003D003D"; ChangeBytes -Offset "2151240" -Values "004A0000003A0000FFFFFFFFFFFF003C0081FFFF"; ChangeBytes -Offset "2150E20" -Values "FFFFFA4C" }

    if (IsItem -Elem $Redux.Speedup.Cutscenes -Item "Rainbow Bridge") {
        ChangeBytes -Offset "292D644" -Values "000000A0"; ChangeBytes -Offset "292D680" -Values "0002000A006C0000"; ChangeBytes -Offset "292D6E8" -Values "0027"
        ChangeBytes -Offset "292D718" -Values "0032";     ChangeBytes -Offset "292D810" -Values "0002003C";         ChangeBytes -Offset "292D924" -Values "FFFF00140096FFFF"
    }

    if (IsItem -Elem $Redux.Speedup.Cutscenes -Item "Ganon's Castle Trials") {
        ChangeBytes -Offset "31A8090" -Values "006B000100020002"; ChangeBytes -Offset "31A9E00" -Values "006E000100020002"; ChangeBytes -Offset "31A8B18" -Values "006C000100020002"
        ChangeBytes -Offset "31A9430" -Values "006D000100020002"; ChangeBytes -Offset "31AB200" -Values "0070000100020002"; ChangeBytes -Offset "31AA830" -Values "006F000100020002"
    }

    if (IsItem -Elem $Redux.Skip.Cutscenes    -Item "Opening Cutscene" )          { ChangeBytes -Offset   "B06BBA"              -Values "0000"                                                                       }
    if (IsItem -Elem $Redux.Skip.Cutscenes    -Item "Darunia Dance")              { ChangeBytes -Offset   "22769E4"             -Values "FFFFFFFF"                                                                   }
    if (IsItem -Elem $Redux.Skip.Cutscenes    -Item "Zelda's Escape")             { ChangeBytes -Offset   "1FC0CF8"             -Values "000000010021000100020002"                                                   }
    if (IsItem -Elem $Redux.Skip.Cutscenes    -Item "Swallowed by Jabu-Jabu")     { ChangeBytes -Offset   "CA0784"              -Values "0018000100020002"                                                           }
    if (IsItem -Elem $Redux.Skip.Cutscenes    -Item "Ganon's Tower Collapse")     { ChangeBytes -Offset   "33FB328"             -Values "0076000100020002"                                                           }
    if (IsItem -Elem $Redux.Skip.Cutscenes    -Item "Chamber of Sages Visits")    { ChangeBytes -Offset   "2512680"             -Values "0076000100020002"                                                           }
    if (IsItem -Elem $Redux.Skip.Cutscenes    -Item "Collected All Medallions")   { ChangeBytes -Offset   "ACA409"              -Values "AD";               ChangeBytes -Offset "ACA49D"  -Values "CE"               }
    if (IsItem -Elem $Redux.Speedup.Cutscenes -Item "Opening Chests")             { ChangeBytes -Offset   "BDA2E8"              -Values "240AFFFF"                                                                   }
    if (IsItem -Elem $Redux.Speedup.Cutscenes -Item "Moving King Zora")           { ChangeBytes -Offset   "E56924"              -Values "00000000"                                                                   }
    if (IsItem -Elem $Redux.Speedup.Cutscenes -Item "Owl Flights")                { ChangeBytes -Offset @("20E60D2", "223B6B2") -Values "0001"                                                                       }
    if (IsItem -Elem $Redux.Speedup.Cutscenes -Item "Horseback Archery")          { ChangeBytes -Offset   "21B2064"             -Values "00000002";         ChangeBytes -Offset "21B20AA" -Values "00010002"         }
    if (IsItem -Elem $Redux.Speedup.Cutscenes -Item "Draining the Well")          { ChangeBytes -Offset   "E0A010"              -Values "002A000100020002"; ChangeBytes -Offset "2001110" -Values "002B00B700B800B8" }
    if (IsItem -Elem $Redux.Speedup.Cutscenes -Item "Opening Door of Time")       { ChangeBytes -Offset   "E0A176"              -Values "0002";             ChangeBytes -Offset "E0A35A"  -Values "00010002"         }



    # RESTORE CUTSCENES #

    if (IsChecked $Redux.Restore.OpeningCutscene)   { ChangeBytes -Offset "1FB8076" -Values "23 40" }



    # ANIMATIONS #

    if     (IsChecked $Redux.Animation.WeaponIdle)        { ChangeBytes -Offset   "BEF5F2"            -Values "3428"                                                                          }
    if     (IsChecked $Redux.Animation.WeaponCrouch)      { ChangeBytes -Offset   "BEF38A"            -Values "2A10"                                                                          }
    if     (IsChecked $Redux.Animation.WeaponAttack)      { ChangeBytes -Offset   "BEFB62"            -Values "2BD8";                ChangeBytes -Offset @("BEFB66", "BEFB6A") -Values "2BE0" }
    if     (IsChecked $Redux.Animation.HoldShieldOut)     { ChangeBytes -Offset   "B6D6D7"            -Values "020A0A10"                                                                      }
    if     (IsChecked $Redux.Animation.BombBag)           { ChangeBytes -Offset   "BEF3DA"            -Values "2500";                ChangeBytes -Offset   "BEF3F2"            -Values "2508" }
    if     (IsChecked $Redux.Animation.BackflipAttack)    { ChangeBytes -Offset   "BEFB12"            -Values "29D0"                                                                          }
    elseif (IsChecked $Redux.Animation.FrontflipAttack)   { ChangeBytes -Offset   "BEFB12"            -Values "2A60"                                                                          }
    if     (IsChecked $Redux.Animation.FrontflipJump)     { PatchBytes  -Offset   "70BB00"            -Patch "Jumps\frontflip.bin"                                                            }
    elseif (IsChecked $Redux.Animation.SomarsaultJump)    { PatchBytes  -Offset   "70BB00"            -Patch "Jumps\somarsault.bin"; ChangeBytes -Offset   "F06149"            -Values "0E"   }
    if     (IsChecked $Redux.Animation.SideBackflip)      { ChangeBytes -Offset   "BEF5D6"            -Values "2988"                                                                          }
    if     (IsChecked $Redux.Animation.LinkDeathCamera)   { ChangeBytes -Offset @("BD2014", "BDF730") -Values "00000000"                                                                      }


    # MASTER QUEST #

    if ($GamePatch.base -eq 1) { PatchDungeonsOoTMQ }



    # SCRIPT #

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

    if (StrLike -Str $GamePatch.settings -Val "Master of Time") {
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

    if (IsRevert $Redux.Speedup.Cutscenes -Item "Opening Door of Time")   { ChangeBytes -Offset "CCE9A4" -Values "3C013F8044813000"                                                                                                                       }
    if (IsRevert $Redux.Hooks.FasterArmosPushing)                         { ChangeBytes -Offset "C97C68" -Values "24C8F800"; ChangeBytes -Offset "C97D68" -Values "3C013F0044814000"; ChangeBytes -Offset "C97E20" -Values "3C013F0044815000"             }
    if (IsRevert $Redux.Hooks.BlueFireArrow)                              { ChangeBytes -Offset "DB32C8" -Values "240100F0"                                                                                                                               }
    if (IsRevert $Redux.Hooks.RupeeIconColors)                            { ChangeBytes -Offset "AEB764" -Values "3C01C8FF26380008AE9802B0"; ChangeBytes -Offset "AEB778" -Values "34216400"                                                              }
    if (IsRevert $Redux.Hooks.StoneOfAgony)                               { ChangeBytes -Offset "BE4A14" -Values "4602003C";                 ChangeBytes -Offset "BE4A40" -Values "4606203C"; ChangeBytes -Offset "BE4A60" -Values "27BD002003E00008"     }
    if (IsRevert $Redux.Hooks.EmptyBombFix)                               { ChangeBytes -Offset "C0E77C" -Values "AC400428AC4D066C"                                                                                                                       }
    if (IsRevert $Redux.Hooks.WarpSongsSpeedup)                           { ChangeBytes -Offset "B10CC0" -Values "3C0100013421241C";         ChangeBytes -Offset "BEA045"  -Values "009444E7A00010"                                                       }
    if (IsRevert $Redux.Hooks.BiggoronFix)                                { ChangeBytes -Offset "ED645C" -Values "1000000DAC8E0180"                                                                                                                       }
    if (IsRevert $Redux.Hooks.DampeFix)                                   { ChangeBytes -Offset "CC4038" -Values "240C0004304A1000";         ChangeBytes -Offset "CC453E" -Values "0006"                                                                  }
    if (IsRevert $Redux.Hooks.HyruleGuardsSoftlock)                       { ChangeBytes -Offset "E24E7C" -Values "0C00863B24060001"                                                                                                                       }
    if (IsRevert $Redux.Hooks.TalonSkip)                                  { ChangeBytes -Offset "CC0038" -Values "8FA4001824090041"                                                                                                                       }
    if (IsRevert $Redux.Misc.SkipCutscenes)                               { ChangeBytes -Offset "B06C2C" -Values "A2280020A2250021"                                                                                                                       }
    if (IsRevert $Redux.Minigames.LessDemandingFishing)                   { ChangeBytes -Offset "DBF428" -Values "C652019C3C0142824481400046009100E644"; ChangeBytes -Offset "DBF484" -Values "E652019C"; ChangeBytes -Offset "DBF4A8" -Values "E648019C" }
    if (IsRevert $Redux.Minigames.GuaranteedFishing)                      { ChangeBytes -Offset "DC7090" -Values "C60A019846025102"                                                                                                                       }

}



#==============================================================================================================================================================================================
function ByteReduxOptions() {
    
    $Symbols = SetJSONFile ($GameFiles.base + "\symbols.json")
    if ($GamePatch.custom_maps -eq 1) { ChangeBytes -Offset $Symbols.CFG_CUSTOM_MAPS -Values "01" }



    # DEFAULT SETTINGS #

    if (IsDefault $Redux.Default.FPS               -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_30_FPS               -Values (Get8Bit (GetCheckedValue $Redux.Default.FPS)            ) }
    if (IsDefault $Redux.Default.ArrowToggle       -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_ARROW_TOGGLE         -Values (Get8Bit (GetCheckedValue $Redux.Default.ArrowToggle)    ) }
    if (IsDefault $Redux.Default.ShowHealth        -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_SHOW_HEALTH          -Values (Get8Bit (GetCheckedValue $Redux.Default.ShowHealth)     ) }
    if (IsDefault $Redux.Default.ChestContents     -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_CHEST_CONTENTS       -Values (Get8Bit (GetCheckedValue $Redux.Default.ChestContents)  ) }
    if (IsDefault $Redux.Default.InverseAim        -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_INVERSE_AIM          -Values (Get8Bit (GetCheckedValue $Redux.Default.InverseAim)     ) }
    if (IsDefault $Redux.Default.NoIdleCamera      -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_NO_IDLE_CAMERA       -Values (Get8Bit (GetCheckedValue $Redux.Default.NoIdleCamera)   ) }
    if (IsDefault $Redux.Default.KeepMask          -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_KEEP_MASK            -Values (Get8Bit (GetCheckedValue $Redux.Default.KeepMask)       ) }
    if (IsDefault $Redux.Default.TriSwipe          -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_TRISWIPE             -Values (Get8Bit (GetCheckedValue $Redux.Default.TriSwipe)       ) }
    
    if (IsDefault $Redux.Default.SwapItem          -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_SWAP_ITEM            -Values (Get8Bit (GetCheckedValue $Redux.Default.SwapItem)       ) }
    if (IsDefault $Redux.Default.UnequipItem       -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_UNEQUIP_ITEM         -Values (Get8Bit (GetCheckedValue $Redux.Default.UnequipItem)    ) }
    if (IsDefault $Redux.Default.UnequipGear       -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_UNEQUIP_GEAR         -Values (Get8Bit (GetCheckedValue $Redux.Default.UnequipGear)    ) }
    if (IsDefault $Redux.Default.ItemOnB           -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_ITEM_ON_B            -Values (Get8Bit (GetCheckedValue $Redux.Default.ItemOnB)        ) }
    if (IsDefault $Redux.Default.MaskAbilities     -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_MASK_ABILITIES       -Values (Get8Bit (GetCheckedValue $Redux.Default.MaskAbilities)  ) }
    if (IsDefault $Redux.Default.ExtraAbilities    -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_EXTRA_ABILITIES      -Values (Get8Bit (GetCheckedValue $Redux.Default.ExtraAbilities) ) }
    if (IsDefault $Redux.Default.RandomEnemies     -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_RANDOM_ENEMIES       -Values (Get8Bit (GetCheckedValue $Redux.Default.RandomEnemies)  ) }
    if (IsDefault $Redux.Default.CrouchStabFix     -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_CROUCH_STAB_FIX      -Values (Get8Bit (GetCheckedValue $Redux.Default.CrouchStabFix)  ) }
    if (IsDefault $Redux.Default.WeakerSwords      -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_WEAKER_SWORDS        -Values (Get8Bit (GetCheckedValue $Redux.Default.WeakerSwords)   ) }
    if (IsDefault $Redux.Default.Levitation        -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_LEVITATION           -Values (Get8Bit (GetCheckedValue $Redux.Default.Levitation)     ) }
    if (IsDefault $Redux.Default.InfiniteHP        -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_INFINITE_HP          -Values (Get8Bit (GetCheckedValue $Redux.Default.InfiniteHP)     ) }
    if (IsDefault $Redux.Default.InfiniteMP        -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_INFINITE_MP          -Values (Get8Bit (GetCheckedValue $Redux.Default.InfiniteMP)     ) }
    if (IsDefault $Redux.Default.InfiniteRupees    -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_INFINITE_RUPEES      -Values (Get8Bit (GetCheckedValue $Redux.Default.InfiniteRupees) ) }
    if (IsDefault $Redux.Default.InfiniteAmmo      -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_INFINITE_AMMO        -Values (Get8Bit (GetCheckedValue $Redux.Default.InfiniteAmmo)   ) }

    if (IsDefault $Redux.Default.Dpad              -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_DPAD                 -Values (Get8Bit $Redux.Default.Dpad.SelectedIndex)        }
    if (IsDefault $Redux.Default.ShowDPad          -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_SHOW_DPAD            -Values (Get8Bit $Redux.Default.ShowDPad.SelectedIndex)    }
    if (IsDefault $Redux.Default.HideHUD           -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_HIDE_HUD             -Values (Get8Bit $Redux.Default.HideHUD.SelectedIndex)     }
    if (IsDefault $Redux.Default.HUDLayout         -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_HUD_LAYOUT           -Values (Get8Bit $Redux.Default.HUDLayout.SelectedIndex)   }
    if (IsDefault $Redux.Default.AButtonScale      -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_A_BUTTON_SCALE       -Values (Get8Bit $Redux.Default.AButtonScale.Text)         }
    if (IsDefault $Redux.Default.BButtonScale      -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_B_BUTTON_SCALE       -Values (Get8Bit $Redux.Default.BButtonScale.Text)         }
    if (IsDefault $Redux.Default.CLeftButtonScale  -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_C_LEFT_BUTTON_SCALE  -Values (Get8Bit $Redux.Default.CLeftButtonScale.Text)     }
    if (IsDefault $Redux.Default.CDownButtonScale  -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_C_DOWN_BUTTON_SCALE  -Values (Get8Bit $Redux.Default.CDownButtonScale.Text)     }
    if (IsDefault $Redux.Default.CRightButtonScale -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_C_RIGHT_BUTTON_SCALE -Values (Get8Bit $Redux.Default.CRightButtonScale.Text)    }
    if (IsDefault $Redux.Default.DamageTaken       -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_DAMAGE_TAKEN         -Values (Get8Bit $Redux.Default.DamageTaken.SelectedIndex) }
    if (IsDefault $Redux.Default.RupeeDrain        -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_RUPEE_DRAIN          -Values (Get8Bit $Redux.Default.RupeeDrain.Text)           }
    if (IsDefault $Redux.Default.Fog               -Not)   { ChangeBytes -Offset $Symbols.CFG_DEFAULT_FOG                  -Values (Get8Bit $Redux.Default.Fog.Text)                  }



    # WIDESCREEN #

    if (IsChecked $Redux.Graphics.Widescreen) {
        $offset = SearchBytes -Start $Symbols.PAYLOAD_START -End (AddToOffset -Hex $Symbols.PAYLOAD_START -Add "1000") -Values "01 40"
        if ($offset -ge 0) {
            ChangeBytes -Offset $offset         -Values "01 A8"
            ChangeBytes -Offset $Symbols.CFG_WS -Values "01"
        }
    }



    # QUALITY OF LIFE #

    if (IsChecked $Redux.Gameplay.ResumeLastArea) { ChangeBytes -Offset $Symbols.CFG_PREVENT_GROTTO_SAVING -Values "01" }



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
    if (IsChecked $Redux.Misc.BombchuDrops)         { ChangeBytes -Offset $Symbols.BOMBCHUS_IN_LOGIC       -Values "01" }
    if (IsChecked $Redux.Misc.TycoonWallet)         { ChangeBytes -Offset $Symbols.CFG_TYCOON_WALLET       -Values "01" }
    


    # CODE HOOKS FEATURES #
    
    if (IsChecked $Redux.Hooks.BlueFireArrow) { ChangeBytes -Offset "C230C1" -Values "29"; ChangeBytes -Offset "DB38FE" -Values "EF"; ChangeBytes -Offset "C9F036" -Values "10"; ChangeBytes -Offset "DB391B" -Values "50"; ChangeBytes -Offset "DB3927" -Values "5A" }



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
        if (IsColor $Redux.Colors.SetButtons[0] -Not) { # A Button
            $values = (Get16Bit $Redux.Colors.SetButtons[0].Color.R) + (Get16Bit $Redux.Colors.SetButtons[0].Color.G) + (Get16Bit $Redux.Colors.SetButtons[0].Color.B); ChangeBytes -Offset $Symbols.CFG_A_BUTTON_COLOR -Values $values # A Button Color
            $values = (Get16Bit $Redux.Colors.SetButtons[0].Color.R) + (Get16Bit $Redux.Colors.SetButtons[0].Color.G) + (Get16Bit $Redux.Colors.SetButtons[0].Color.B); ChangeBytes -Offset $Symbols.CFG_A_NOTE_COLOR   -Values $values # Note Button

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

        if (IsColor $Redux.Colors.SetButtons[1] -Not) {
            $values = (Get16Bit $Redux.Colors.SetButtons[1].Color.R) + (Get16Bit $Redux.Colors.SetButtons[1].Color.G) + (Get16Bit $Redux.Colors.SetButtons[1].Color.B); ChangeBytes -Offset $Symbols.CFG_B_BUTTON_COLOR -Values $values # B Button 
        } 

        if (IsColor $Redux.Colors.SetButtons[2] -Not) { # C Buttons
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

        if (IsColor $Redux.Colors.SetButtons[3] -Not) { # Start Button
            ChangeBytes -Offset "AE9EC6" -Values @($Redux.Colors.SetButtons[3].Color.R, $Redux.Colors.SetButtons[3].Color.G) # Red + Green
            ChangeBytes -Offset "AE9ED8" -Values @(53, 238, $Redux.Colors.SetButtons[3].Color.B) # Blue
        }
    }



    # TUNIC COLORS #

    if ($Redux.Colors.SetExtraEquipment -ne $null) {
        if (IsColor $Redux.Colors.SetExtraEquipment[0] -Not)   { ChangeBytes -Offset $Symbols.CFG_TUNIC_MAGICIAN -Values @($Redux.Colors.SetExtraEquipment[0].Color.R, $Redux.Colors.SetExtraEquipment[0].Color.G, $Redux.Colors.SetExtraEquipment[0].Color.B) } # Magician Tunic
        if (IsColor $Redux.Colors.SetExtraEquipment[1] -Not)   { ChangeBytes -Offset $Symbols.CFG_TUNIC_GUARDIAN -Values @($Redux.Colors.SetExtraEquipment[1].Color.R, $Redux.Colors.SetExtraEquipment[1].Color.G, $Redux.Colors.SetExtraEquipment[1].Color.B) } # Guardian Tunic
        if (IsColor $Redux.Colors.SetExtraEquipment[2] -Not)   { ChangeBytes -Offset $Symbols.CFG_TUNIC_HERO     -Values @($Redux.Colors.SetExtraEquipment[2].Color.R, $Redux.Colors.SetExtraEquipment[2].Color.G, $Redux.Colors.SetExtraEquipment[2].Color.B) } # Hero Tunic
        if (IsColor $Redux.Colors.SetExtraEquipment[3] -Not)   { ChangeBytes -Offset $Symbols.CFG_TUNIC_NONE     -Values @($Redux.Colors.SetExtraEquipment[3].Color.R, $Redux.Colors.SetExtraEquipment[3].Color.G, $Redux.Colors.SetExtraEquipment[3].Color.B) } # No Tunic
        if (IsColor $Redux.Colors.SetExtraEquipment[4] -Not)   { ChangeBytes -Offset $Symbols.CFG_TUNIC_SHADOW   -Values @($Redux.Colors.SetExtraEquipment[4].Color.R, $Redux.Colors.SetExtraEquipment[4].Color.G, $Redux.Colors.SetExtraEquipment[4].Color.B) } # Shadow Tunic
    }



    # TRAIL COLORS #

    if ($Redux.Colors.SetBoomerang -ne $null) {
        if (IsColor $Redux.Colors.SetBoomerang[0] -Not)   { ChangeBytes -Offset $Symbols.CFG_BOOM_TRAIL_INNER_COLOR -Values @($Redux.Colors.SetBoomerang[0].Color.R, $Redux.Colors.SetBoomerang[0].Color.G, $Redux.Colors.SetBoomerang[0].Color.B) }
        if (IsColor $Redux.Colors.SetBoomerang[1] -Not)   { ChangeBytes -Offset $Symbols.CFG_BOOM_TRAIL_OUTER_COLOR -Values @($Redux.Colors.SetBoomerang[1].Color.R, $Redux.Colors.SetBoomerang[1].Color.G, $Redux.Colors.SetBoomerang[1].Color.B) }
    }

    if ($Redux.Colors.SetBombchu -ne $null) {
        if (IsColor $Redux.Colors.SetBombchu[0] -Not)     { ChangeBytes -Offset $Symbols.CFG_BOMBCHU_TRAIL_INNER_COLOR -Values @($Redux.Colors.SetBombchu[0].Color.R, $Redux.Colors.SetBombchu[0].Color.G, $Redux.Colors.SetBombchu[0].Color.B) }
        if (IsColor $Redux.Colors.SetBombchu[1] -Not)     { ChangeBytes -Offset $Symbols.CFG_BOMBCHU_TRAIL_OUTER_COLOR -Values @($Redux.Colors.SetBombchu[1].Color.R, $Redux.Colors.SetBombchu[1].Color.G, $Redux.Colors.SetBombchu[1].Color.B) }
    }



    # HUD COLORS #

    if ($Redux.Colors.SetHUDStats -ne $null) {
        if (IsColor $Redux.Colors.SetHUDStats[0] -Not)    { $values = (Get16Bit $Redux.Colors.SetHUDStats[0].Color.R) + (Get16Bit $Redux.Colors.SetHUDStats[0].Color.G) + (Get16Bit $Redux.Colors.SetHUDStats[0].Color.B); ChangeBytes -Offset $Symbols.CFG_HEART_COLOR -Values $values } # Hearts
        if (IsColor $Redux.Colors.SetHUDStats[1] -Not)    { $values = (Get16Bit $Redux.Colors.SetHUDStats[1].Color.R) + (Get16Bit $Redux.Colors.SetHUDStats[1].Color.G) + (Get16Bit $Redux.Colors.SetHUDStats[1].Color.B); ChangeBytes -Offset $Symbols.CFG_MAGIC_COLOR -Values $values } # Magic
    }

    if (IsChecked $Redux.Graphics.GCScheme) {
        ChangeBytes -Offset $Symbols.CFG_TEXT_CURSOR_COLOR -Values "00 00 00 C8 00 50" # Text Cursor
        ChangeBytes -Offset $Symbols.CFG_SHOP_CURSOR_COLOR -Values "00 00 00 FF 00 50" # Shop Cursor
    }
    elseif ($Redux.Colors.SetText -ne $null) {
        if (IsColor $Redux.Colors.SetText[0] -Not)    { $values = (Get16Bit $Redux.Colors.SetText[0].Color.R) + (Get16Bit $Redux.Colors.SetText[0].Color.G) + (Get16Bit $Redux.Colors.SetText[0].Color.B); ChangeBytes -Offset $Symbols.CFG_TEXT_CURSOR_COLOR -Values $values } # Text Cursor
        if (IsColor $Redux.Colors.SetText[1] -Not)    { $values = (Get16Bit $Redux.Colors.SetText[1].Color.R) + (Get16Bit $Redux.Colors.SetText[1].Color.G) + (Get16Bit $Redux.Colors.SetText[1].Color.B); ChangeBytes -Offset $Symbols.CFG_SHOP_CURSOR_COLOR -Values $values } # Shop Cursor
    }
    
}



#==============================================================================================================================================================================================
function ByteSceneOptions() {
    
    # QUALITY OF LIFE #

    if (IsDefault $Redux.Gameplay.RemoveOwls -Not) {
        PrepareMap -Scene "Hyrule Field"    -Map 0 -Header 0; RemoveObject -Name "Kaepora Gaebora"; RemoveActor -Name "Kaepora Gaebora"; RemoveActor -Name "Kaepora Gaebora"; RemoveActor -Name "Kaepora Gaebora"; RemoveActor -Name "Kaepora Gaebora"; SaveAndPatchLoadedScene
        PrepareMap -Scene "Zora's River"    -Map 0 -Header 0; RemoveObject -Name "Kaepora Gaebora"; RemoveActor -Name "Kaepora Gaebora"; SaveAndPatchLoadedScene
        PrepareMap -Scene "Lost Woods"      -Map 2 -Header 0; RemoveObject -Name "Kaepora Gaebora"; RemoveActor -Name "Kaepora Gaebora"; SaveLoadedMap
        PrepareMap -Scene "Lost Woods"      -Map 8 -Header 0; RemoveObject -Name "Kaepora Gaebora"; RemoveActor -Name "Kaepora Gaebora"; SaveAndPatchLoadedScene
        PrepareMap -Scene "Desert Colossus" -Map 0 -Header 0; RemoveObject -Name "Kaepora Gaebora"; RemoveActor -Name "Kaepora Gaebora"; SaveAndPatchLoadedScene
        PrepareMap -Scene "Hyrule Castle"   -Map 0 -Header 0; RemoveObject -Name "Kaepora Gaebora"; RemoveActor -Name "Kaepora Gaebora"; SaveAndPatchLoadedScene
        if (IsIndex $Redux.Gameplay.RemoveOwls -Index 3) {
            PrepareMap -Scene "Lake Hylia"           -Map 0 -Header 0; RemoveObject -Name "Kaepora Gaebora"; RemoveActor -Name "Kaepora Gaebora"; SaveAndPatchLoadedScene; ChangeBytes -Offset "CF8C84" -Values "1500" 
            PrepareMap -Scene "Death Mountain Trail" -Map 0 -Header 0; RemoveObject -Name "Kaepora Gaebora"; RemoveActor -Name "Kaepora Gaebora"; SaveAndPatchLoadedScene
        }
    }
    

    if (IsChecked $Redux.Gameplay.RemoveDisruptiveText) {
        PrepareMap -Scene "Shadow Temple" -Map 0 -Header 0
        ReplaceActor -Name "Dialog Spot" -Compare "4225" -Y (-1000); ReplaceActor -Name "Dialog Spot" -Compare "4226" -Y (-1000); ReplaceActor -Name "Dialog Spot" -Compare "4267" -Y (-1000); ReplaceActor -Name "Dialog Spot" -Compare "4268" -Y (-1000)
        ReplaceActor -Name "Dialog Spot" -Compare "42A9" -Y (-1000); ReplaceActor -Name "Dialog Spot" -Compare "422A" -Y (-1000); ReplaceActor -Name "Dialog Spot" -Compare "422B" -Y (-1000); ReplaceActor -Name "Dialog Spot" -Compare "42AC" -Y (-1000)
        SaveLoadedMap

        PrepareMap -Scene "Shadow Temple" -Map 2 -Header 0
        ReplaceActor -Name "Dialog Spot" -Compare "493C" -Y (-1000); ReplaceActor -Name "Dialog Spot" -Compare "4F3D" -Y (-1000)
        SaveAndPatchLoadedScene

        PrepareMap -Scene "Gerudo Training Ground" -Map 0 -Header 0
        ReplaceActor -Name "Dialog Spot" -Compare "4C2F" -Y (-1000) -CompareX (-43); ReplaceActor -Name "Dialog Spot" -Compare "4C2F" -Y (-1000) -CompareX 468; ReplaceActor -Name "Dialog Spot" -Compare "4C2F" -Y (-1000) -CompareX (-590)
        SaveLoadedMap

        PrepareMap -Scene "Gerudo Training Ground" -Map 3 -Header 0
        ReplaceActor -Name "Dialog Spot" -Compare "4DCB" -Y (-1000); ReplaceActor -Name "Dialog Spot" -Compare "4E0F" -Y (-1000)
        SaveLoadedMap

        PrepareMap -Scene "Gerudo Training Ground" -Map 6 -Header 0
        ReplaceActor -Name "Dialog Spot" -Compare "4D16" -Y (-1000) -CompareX 1483; ReplaceActor -Name "Dialog Spot" -Compare "4D16" -Y (-1000) -CompareX 1433; ReplaceActor -Name "Dialog Spot" -Compare "4D16" -Y (-1000) -CompareX 912
        SaveLoadedMap

        PrepareMap -Scene "Gerudo Training Ground" -Map 1 -Header 0; ReplaceActor -Name "Dialog Spot" -Compare "4C9F" -Y (-1000); SaveLoadedMap
        PrepareMap -Scene "Gerudo Training Ground" -Map 2 -Header 0; ReplaceActor -Name "Dialog Spot" -Compare "4E5C" -Y (-1000); SaveLoadedMap
        PrepareMap -Scene "Gerudo Training Ground" -Map 4 -Header 0; ReplaceActor -Name "Dialog Spot" -Compare "4D95" -Y (-1000); SaveLoadedMap
        PrepareMap -Scene "Gerudo Training Ground" -Map 5 -Header 0; ReplaceActor -Name "Dialog Spot" -Compare "4D59" -Y (-1000); SaveLoadedMap
        PrepareMap -Scene "Gerudo Training Ground" -Map 7 -Header 0; ReplaceActor -Name "Dialog Spot" -Compare "4C9E" -Y (-1000); SaveLoadedMap
        PrepareMap -Scene "Gerudo Training Ground" -Map 8 -Header 0; ReplaceActor -Name "Dialog Spot" -Compare "4C48" -Y (-1000); SaveLoadedMap
        PrepareMap -Scene "Gerudo Training Ground" -Map 9 -Header 0; ReplaceActor -Name "Dialog Spot" -Compare "4CDB" -Y (-1000); SaveAndPatchLoadedScene
    }



    # GAMEPLAY #

    if (IsChecked $Redux.Gameplay.ChildShops) {
        PrepareMap   -Scene "Kakariko Village" -Map 0 -Header 0
        InsertActor  -Name  "Kakariko Village" -Param "0002" -X (-234) -Y 425 -Z (-560) -YRot 0x305B # Bazaar Poster
        InsertActor  -Name  "Kakariko Village" -Param "0000" -X   126  -Y 425 -Z (-566) -YRot 0xB05B # Potion Shop Poster
        InsertObject -Name  "Kakariko Village (Adult)"
        ReplaceTransitionActor -Index 6 -Param "01BF" # Bazaar
        ReplaceTransitionActor -Index 3 -Param "01BF" # Granny's Potion Shop
        SaveLoadedMap

        PrepareMap   -Scene "Kakariko Village" -Map 0 -Header 1
        InsertActor  -Name  "Kakariko Village" -Param "0002" -X (-234) -Y 425 -Z (-560) -YRot 0x305B # Bazaar Poster
        InsertActor  -Name  "Kakariko Village" -Param "0000" -X   126  -Y 425 -Z (-566) -YRot 0xB05B # Potion Shop Poster
        InsertObject -Name  "Kakariko Village (Adult)"
        ReplaceTransitionActor -Index 6 -Param "0291" # Bazaar
        ReplaceTransitionActor -Index 3 -Param "01BF" # Granny's Potion Shop
        SaveAndPatchLoadedScene

        PrepareMap      -Scene "Guard's House" -Map 0 -Header 0
        ChangeMapFile   -Offset "48" -Values "03000470"
        ChangeSceneFile -Offset "68" -Values "02000B60"
        SaveAndPatchLoadedScene
    }



    # RESTORE #

    if (IsDefault $Redux.Restore.GerudoTextures -Not) {
        PrepareMap -Scene "Dampé's Grave & Windmill" -Map 0  -Header 0; ChangeMapFile   -Search "66888667777877888778777887788778" -Patch "Gerudo Symbols\dampe.bin"; SaveLoadedMap
        PrepareMap -Scene "Dampé's Grave & Windmill" -Map 3  -Header 0; ChangeMapFile   -Search "66888667777877888778777887788778" -Patch "Gerudo Symbols\dampe.bin"; SaveLoadedMap
        PrepareMap -Scene "Dampé's Grave & Windmill" -Map 4  -Header 0; ChangeMapFile   -Search "66888667777877888778777887788778" -Patch "Gerudo Symbols\dampe.bin"; SaveAndPatchLoadedScene
        
    if (IsIndex $Redux.Restore.GerudoTextures -Index 3) {
            PatchBytes -Offset "E68CE8"  -Texture -Patch "Gerudo Symbols\ganondorf_cape.bin"
            PatchBytes -Offset "F70350"  -Texture -Patch "Gerudo Symbols\pushing_block.bin"
            PatchBytes -Offset "F70B50"  -Texture -Patch "Gerudo Symbols\silver_gauntlets_block.bin"
            PatchBytes -Offset "F71350"  -Texture -Patch "Gerudo Symbols\forest_temple_room_11_block.bin"
            PatchBytes -Offset "F748A0"  -Texture -Patch "Gerudo Symbols\floor_switch.bin"
            PatchBytes -Offset "F7A8A0"  -Texture -Patch "Gerudo Symbols\rusted_floor_switch.bin"
            PatchBytes -Offset "F80CB0"  -Texture -Patch "Gerudo Symbols\crystal_switch.bin"
            PatchBytes -Offset "15B1000" -Texture -Patch "Gerudo Symbols\gerudo_membership_card.bin"
            PatchBytes -Offset "11FB000" -Texture -Patch "Gerudo Symbols\gerudo_training_ground_door.bin"
            PatchBytes -Offset "12985F0" -Texture -Patch "Gerudo Symbols\shadow_temple_room_0.bin"
            PatchBytes -Offset "13B4000" -Texture -Patch "Gerudo Symbols\golden_gauntlets_pillar.bin"
            PatchBytes -Offset "1636940" -Texture -Patch "Gerudo Symbols\spirit_temple_room_0_elevator.bin"
            PatchBytes -Offset "168F3A0" -Texture -Patch "Gerudo Symbols\iron_knuckle.bin"

            PrepareMap -Scene "Gerudo's Fortress"                     -Map 0  -Header 0; ChangeSceneFile -Search "62D45A5062D46B166AD47358418B41CB" -Patch "Gerudo Symbols\gerudo_fortress.bin";                             SaveAndPatchLoadedScene
            PrepareMap -Scene "Forest Temple"                         -Map 11 -Header 0; ChangeMapFile   -Search "33445455565536665577988899987777" -Patch "Gerudo Symbols\forest_temple_room_11_hole.bin";                  SaveAndPatchLoadedScene
            
            PrepareMap -Scene "Spirit Temple"                         -Map 0  -Header 0; ChangeMapFile   -Search "000500110600064E0606060611110611" -Patch "Gerudo Symbols\spirit_temple_room_0_pillars.bin";                SaveLoadedMap
            PrepareMap -Scene "Spirit Temple"                         -Map 10 -Header 0; ChangeMapFile   -Search "01010101120118010101010101013A37" -Patch "Gerudo Symbols\spirit_temple_room_10_20_28.bin";                 SaveLoadedMap
            PrepareMap -Scene "Spirit Temple"                         -Map 20 -Header 0; ChangeMapFile   -Search "01010101120118010101010101013A37" -Patch "Gerudo Symbols\spirit_temple_room_10_20_28.bin";                 SaveLoadedMap
            PrepareMap -Scene "Spirit Temple"                         -Map 28 -Header 0; ChangeMapFile   -Search "01010101120118010101010101013A37" -Patch "Gerudo Symbols\spirit_temple_room_10_20_28.bin";                 SaveAndPatchLoadedScene

            PrepareMap -Scene "Gerudo Training Ground"                -Map 1  -Header 0; ChangeMapFile   -Search "0B0C08080B08080C23150B08000C4215" -Patch "Gerudo Symbols\gerudo_training_ground_room_1_ceiling_frame.bin"; SaveLoadedMap
            PrepareMap -Scene "Gerudo Training Ground"                -Map 3  -Header 0; ChangeMapFile   -Search "0B0C08080B08080C23150B08000C4215" -Patch "Gerudo Symbols\gerudo_training_ground_room_1_ceiling_frame.bin"; SaveLoadedMap
            PrepareMap -Scene "Gerudo Training Ground"                -Map 5  -Header 0; ChangeMapFile   -Search "0C131313131D131D1D101D1013102D13" -Patch "Gerudo Symbols\gerudo_training_ground_room_5_7.bin";             SaveLoadedMap
            PrepareMap -Scene "Gerudo Training Ground"                -Map 7  -Header 0; ChangeMapFile   -Search "0C131313131D131D1D101D1013102D13" -Patch "Gerudo Symbols\gerudo_training_ground_room_5_7.bin";             SaveLoadedMap
            PrepareMap -Scene "Gerudo Training Ground"                -Map 10 -Header 0; ChangeMapFile   -Search "0B0C08080B08080C23150B08000C4215" -Patch "Gerudo Symbols\gerudo_training_ground_room_1_ceiling_frame.bin"; SaveAndPatchLoadedScene

            PrepareMap -Scene "Twinrova's Lair & Iron Knuckle's Lair" -Map 1  -Header 0; ChangeMapFile   -Search "498B498B498B498B41494989518B498B" -Patch "Gerudo Symbols\spirit_temple_boss.bin";                          SaveLoadedMap
            PrepareMap -Scene "Twinrova's Lair & Iron Knuckle's Lair" -Map 3  -Header 0; ChangeMapFile   -Search "498B498B498B498B41494989518B498B" -Patch "Gerudo Symbols\spirit_temple_boss.bin";                          SaveAndPatchLoadedScene
        }
    }

    

    # FIXES #

    if (IsChecked $Redux.Fixes.Graves)  {
        PrepareMap -Scene "Graveyard" -Map 0 -Header 0
        ChangeSceneFile -Values "20" -Search "00000200000FC000000203020CA7C200" # 202039D
        ChangeSceneFile -Values "24" -Search "0000000400000FC80000000400000FCA" # 202043C
        SaveAndPatchLoadedScene
    }

    if (IsChecked $Redux.Fixes.TimeDoor) {
        for ($i=0; $i -le 11; $i++) { PrepareMap -Scene "Temple of Time" -Map 1 -Header $i; ReplaceActor -Name "Temple of Time" -Compare "000D" -X "FFFC" }
        SaveAndPatchLoadedScene
    }

    if (IsChecked $Redux.Fixes.GerudosFortress) { PrepareMap -Scene "Gerudo's Fortress" -Map 0 -Header 0; ReplaceActor -Name "Treasure Chest" -Compare "03E0" -Param "07C0"; SaveAndPatchLoadedScene }

    if (IsChecked $Redux.Fixes.Dungeons) {
        PrepareMap   -Scene "Dodongo's Cavern" -Map 0 -Header 0
        ReplaceActor -Name "Gossip Stone" -Compare "1114" -Param "1138"
        SaveAndPatchLoadedScene

        PrepareMap -Scene "Water Temple" -Map 0 -Header 0
        if (ReplaceActor -Name "Keese" -CompareX (-1645) -X (-455) -Y 780 -Z (-431) -YRot 0) {
            ChangeSceneFile -Values "0B" -Search "00097F09800981800100000000FA2400"; ChangeSceneFile -Values "0B" -Search "00097F09810982800100000000FA2400" # 25C7221, 25C7231
            InsertObject    -Name "Keese"
            ReplaceActor    -Name "Keese" -CompareX (-1594) -X 74 -Y 780 -Z (-431) -YRot 0
            SaveLoadedMap
        }

        PrepareMap   -Scene "Water Temple" -Map 10 -Header 0
        ReplaceTransitionActor -Index 22 -Compare "0082" -Param "0084" # Master Quest door bug
        ReplaceActor -Name "Pot" -Compare "7003" -Y 860; ReplaceActor -Name "Pot" -Compare "7203" -Y 860; ReplaceActor -Name "Pot" -Compare "7403" -Y 860
        SaveAndPatchLoadedScene

        PrepareMap -Scene "Fire Temple"            -Map 13 -Header 0; ReplaceActor -Name "Navi Message"          -Compare "BFA7" -Y 4171  -YRot 22;               SaveAndPatchLoadedScene
        PrepareMap -Scene "Ice Cavern"             -Map 3  -Header 0; ReplaceActor -Name "Navi Message"          -Compare "0580" -XRot 24 -YRot 0 -ZRot 0;        SaveAndPatchLoadedScene
        PrepareMap -Scene "Shadow Temple"          -Map 21 -Header 0; ReplaceActor -Name "Information Spot"      -Compare "2084" -X (-2724) -Y (-1293) -Z (-596); SaveAndPatchLoadedScene
        PrepareMap -Scene "Gerudo Training Ground" -Map 4  -Header 0; ReplaceActor -Name "Invisible Collectable" -Compare "1093" -Y (-1000) -Z (-4000);           SaveAndPatchLoadedScene
	    PrepareMap -Scene "Spirit Temple"          -Map 5  -Header 0; ReplaceActor -Name "Information Spot"      -Compare "3C24" -Z (-1410);                      SaveAndPatchLoadedScene
    }

    if (IsChecked $Redux.Fixes.GreatFairyTextBoxes) {
        PrepareMap   -Scene "Death Mountain Crater" -Map 1 -Header 1
        ReplaceActor -Name "Dialog Spot" -New "Falling Burning Rock" -Compare "8EDC" -X 0 -Y 0 -Z 0 -XRot 0 -YRot 0 -ZRot 0 -Param "FFFF"
        SaveAndPatchLoadedScene

        PrepareMap   -Scene "Desert Colossus" -Map 0 -Header 0
        ReplaceActor -Name "Dialog Spot" -Compare "8EFF" -Param "8EDD"
        SaveAndPatchLoadedScene
    }



    # GRAPHICS #

    if (IsChecked $Redux.Graphics.OverworldSkyboxes) {
        for ($i=0; $i-le 12; $i++)   { PrepareAndSetSceneSettings -Scene "Kokiri Forest"        -Map 0 -Header $i -Skybox 1 }; SaveAndPatchLoadedScene
        for ($i=0; $i-le 2;  $i++)   { PrepareAndSetSceneSettings -Scene "Lost Woods"           -Map 0 -Header $i -Skybox 1 }; SaveAndPatchLoadedScene
        for ($i=0; $i-le 3;  $i++)   { PrepareAndSetSceneSettings -Scene "Sacred Forest Meadow" -Map 0 -Header $i -Skybox 1 }; SaveAndPatchLoadedScene
        for ($i=0; $i-le 2;  $i++)   { PrepareAndSetSceneSettings -Scene "Zora's Fountain"      -Map 0 -Header $i -Skybox 1 }; SaveAndPatchLoadedScene
                                       PrepareAndSetSceneSettings -Scene "Haunted Wasteland"    -Map 0 -Header 0  -Skybox 3;   SaveAndPatchLoadedScene
    }



    # HERO MODE #

    if (IsChecked $Redux.Hero.Arwing)     { PrepareMap -Scene "Kokiri Forest" -Map 0 -Header 0; InsertActor  -Name "Arwing" -X (-292) -Y 0 -Z (-430) -Param "0000"; SaveAndPatchLoadedScene }
    if (IsChecked $Redux.Hero.LikeLike)   { PrepareMap -Scene "Kokiri Forest" -Map 0 -Header 0; InsertObject -Name "Like-Like"; InsertActor  -Name "Like-Like" -X (-322) -Y 380 -Z (-1223) -Param "0000"; SaveAndPatchLoadedScene }

    if (IsChecked $Redux.Hero.GraveyardKeese) {
        PrepareMap -Scene "Graveyard" -Map 1 -Header 2; InsertObject -Name "Keese"
        PrepareMap -Scene "Graveyard" -Map 1 -Header 3; InsertObject -Name "Keese"; SaveAndPatchLoadedScene
    }

    if (IsChecked $Redux.Hero.LostWoodsOctorok) {
        for ($i=0; $i -le 9; $i++) {
            for ($j=0; $j -le 1; $j++) {
                PrepareMap -Scene "Lost Woods" -Map $i -Header $j
                InsertObject -Name "Octorok"
            }
            SaveLoadedMap
        }
        ChangeSceneFile -Values "07E1" -Search "006105F830FE98F380099C033E09EC04" -Start "AC00"; SaveAndPatchLoadedScene
    }

    if ( (IsChecked $Redux.Hero.Bosses) -or (IsChecked $Redux.Hero.Gohma) ) {
            PrepareMap   -Scene "Gohma's Lair" -Map 1 -Header 0
            ReplaceActor -Name "Grass Shrub" -New "Gohma Larva" -X (-121) -Y (-110) -Z (-686) -YRot 4150 -Param "0008"
            ReplaceActor -Name "Grass Shrub" -New "Gohma Larva" -X   18   -Y (-110) -Z (-510) -YRot 4150 -Param "0008"
            ReplaceActor -Name "Grass Shrub" -New "Gohma Larva" -X (-402) -Y (-110) -Z (-573) -YRot 4150 -Param "0008"
            ReplaceActor -Name "Grass Shrub" -New "Gohma Larva" -X (-385) -Y (-110) -Z (-344) -YRot 4150 -Param "0008"
            ReplaceActor -Name "Grass Shrub" -New "Gohma Larva" -X (-186) -Y (-110) -Z (-47)  -YRot 4150 -Param "0008"
            ReplaceActor -Name "Grass Shrub" -New "Gohma Larva" -X (-339) -Y (-110) -Z (-242) -YRot 4150 -Param "0008"
            ReplaceActor -Name "Grass Shrub" -New "Gohma Larva" -X   59   -Y (-110) -Z (-415) -YRot 4150 -Param "0008"
            ReplaceActor -Name "Grass Shrub" -New "Gohma Larva" -X   90   -Y (-110) -Z (-175) -YRot 4150 -Param "0008"
            SaveAndPatchLoadedScene
    }

    if ( (IsChecked $Redux.Hero.Bosses) -or (IsChecked $Redux.Hero.KingDodongo) ) {
            PrepareMap   -Scene "King Dodongo's Lair" -Map 1 -Header 0
            ReplaceObject -Name "Bomb Flower" -New "Baby Dodongo"
            ReplaceActor  -Name "Bomb Flower" -New "Baby Dodongo" -X (-574)  -Y (-1504) -Z (-3615) -Param "0000"
            ReplaceActor  -Name "Bomb Flower" -New "Baby Dodongo" -X (-1216) -Y (-1504) -Z (-3615) -Param "0000"
            ReplaceActor  -Name "Bomb Flower" -New "Baby Dodongo" -X (-1380) -Y (-1505) -Z (-3340) -Param "0000"
            ReplaceActor  -Name "Bomb Flower" -New "Baby Dodongo" -X (-380)  -Y (-1504) -Z (-3340) -Param "0000"
            SaveAndPatchLoadedScene
    }

    if ( (IsChecked $Redux.Hero.Bosses) -or (IsChecked $Redux.Hero.Barinade) ) {
            PrepareMap   -Scene "Barinade's Lair" -Map 1 -Header 0
            InsertObject -Name "Biri"
            ReplaceActor -Name "Pot" -New "Biri" -X   130  -Y 180 -Z (-340) -Param "FFFF"
            ReplaceActor -Name "Pot" -New "Biri" -X   130  -Y 180 -Z (-170) -Param "FFFF"
            ReplaceActor -Name "Pot" -New "Biri" -X (-230) -Y 180 -Z (-255) -Param "FFFF"
            ReplaceActor -Name "Pot" -New "Biri" -X (-130) -Y 180 -Z (-340) -Param "FFFF"
            ReplaceActor -Name "Pot" -New "Biri" -X (-130) -Y 180 -Z (-170) -Param "FFFF"
            ReplaceActor -Name "Pot" -New "Biri" -X   230  -Y 180 -Z (-255) -Param "FFFF"
            SaveAndPatchLoadedScene
    }

}



#==============================================================================================================================================================================================
function WholeTextOptions([string]$Script, [string]$Table) {
    
    if (IsChecked $Redux.Text.Custom) {
        if ( (TestFile ($Gamefiles.editor + "\message_data_static." + $LanguagePatch.code + ".bin") ) -and (TestFile ($Gamefiles.editor + "\message_data." + $LanguagePatch.code + ".tbl") ) ) {
            Copy-Item -LiteralPath ($Gamefiles.editor + "\message_data_static." + $LanguagePatch.code + ".bin") -Destination $Script -Force
            Copy-Item -LiteralPath ($Gamefiles.editor + "\message_data."        + $LanguagePatch.code + ".tbl") -Destination $Table  -Force
        }
        else { WriteToConsole "Custom Text could not be found." }
    }

}



#==============================================================================================================================================================================================
function ByteTextOptions() {
    
    if ($GamePatch.base -le 3) {
        if ( (IsChecked $Redux.Text.Speed3x) -or (IsChecked $Redux.Text.Instant -Lang 1) ) {
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
        
        if (IsChecked $Redux.Unlock.Tunics -Lang 1) {
            SetMessage -ID "0050" -Text "adult size, so it won't fit a kid..." -Replace "unisize, so it fits everyone."   # Goron Tunic
            SetMessage -ID "0051" -Text "adult size,<N>so it won't fit a kid." -Replace "unisize,<N>so it fits everyone." # Zora Tunic
            SetMessage -ID "00AA" -Text "Adult"                                -Replace "Uni-"                            # Goron Tunic (Shop)
	    SetMessage -ID "00AB" -Text "Adult size"                           -Replace "Unisize"                        # Zora Tunic (Shop)
        }
    }
    elseif (IsChecked $Redux.Text.Speed2x) { ChangeBytes -Offset "B5006F" -Values "02" }

    if (IsChecked $Redux.ShopPrice.FixItems) {
        # Giant's Knife
        SetMessage -ID "010D" -Replace "<DI>Giant's Knife   1000 Rupees<DC><N><N><Two Choices><G>Buy<N>Don't buy<W>"
        SetMessage -ID "010E" -Replace "<DI><R>Giant's Knife   1000 Rupees<N><W>This is a big, heavy sword just <N>like the ones Hylian Knights use.<N>It does massive damage upon your foes!<DC><Shop Description>"
        
        # Milk
        SetMessage -ID "010F" -Replace "<DI>Milk   100 Rupees<DC><N><N><Two Choices><G>Buy<N>Don't buy<W>"
        SetMessage -ID "0110" -Replace "<DI><R>Milk   100 Rupees<N><W>This is a big, heavy sword just <N>like the ones Hylian Knights use.<N>It does massive damage upon your foes!<DC><Shop Description>"

        # Weird Egg
        SetMessage -ID "0111" -Replace "<DI>Weird Egg   100 Rupees<DC><N><N><Two Choices><G>Buy<N>Don't buy<W>"
        SetMessage -ID "0112" -Replace "<DI><R>Weird Egg   100 Rupees<N><W>This is a big, heavy sword just <N>like the ones Hylian Knights use.<N>It does massive damage upon your foes!<DC><Shop Description>"

        # Big Poe
        SetMessage -ID "0113" -Replace "<DI>Big Poe   50 Rupees<DC><N><N><Two Choices><G>Buy<N>Don't buy<W>"
        SetMessage -ID "506F" -Replace "<DI><R>Big Poe   50 Rupees<N><W>This is a big, heavy sword just <N>like the ones Hylian Knights use.<N>It does massive damage upon your foes!<DC><Shop Description>"
    }

    # Shop Quantity
    if (IsDefault $Redux.ShopQuantity.RecoveryHeart -Not) {
        if     ($Redux.ShopQuantity.RecoveryHeart.Text -eq "2")    { $text = "two<N>Heart Containers"       }
        elseif ($Redux.ShopQuantity.RecoveryHeart.Text -eq "3")    { $text = "three<N>Heart Containers"     }
        elseif ($Redux.ShopQuantity.RecoveryHeart.Text -eq "4")    { $text = "four<N>Heart Containers"      }
        elseif ($Redux.ShopQuantity.RecoveryHeart.Text -eq "5")    { $text = "five<N>Heart Containers"      }
        elseif ($Redux.ShopQuantity.RecoveryHeart.Text -eq "6")    { $text = "six<N>Heart Containers"       }
        elseif ($Redux.ShopQuantity.RecoveryHeart.Text -eq "7")    { $text = "seven<N>Heart Containers"     }
        elseif ($Redux.ShopQuantity.RecoveryHeart.Text -eq "8")    { $text = "eight<N>Heart Containers"     }
        elseif ($Redux.ShopQuantity.RecoveryHeart.Text -eq "9")    { $text = "nine<N>Heart Containers"      }
        elseif ($Redux.ShopQuantity.RecoveryHeart.Text -eq "10")   { $text = "ten<N>Heart Containers"       }
        elseif ($Redux.ShopQuantity.RecoveryHeart.Text -eq "11")   { $text = "eleven<N>Heart Containers"    }
        elseif ($Redux.ShopQuantity.RecoveryHeart.Text -eq "12")   { $text = "twelve<N>Heart Containers"    }
        elseif ($Redux.ShopQuantity.RecoveryHeart.Text -eq "13")   { $text = "thirteen<N>Heart Containers"  }
        elseif ($Redux.ShopQuantity.RecoveryHeart.Text -eq "14")   { $text = "fourteen<N>Heart Containers"  }
        elseif ($Redux.ShopQuantity.RecoveryHeart.Text -eq "15")   { $text = "fifteen<N>Heart Containers"   }
        elseif ($Redux.ShopQuantity.RecoveryHeart.Text -eq "16")   { $text = "sixteen<N>Heart Containers"   }
        elseif ($Redux.ShopQuantity.RecoveryHeart.Text -eq "17")   { $text = "seventeen<N>Heart Containers" }
        elseif ($Redux.ShopQuantity.RecoveryHeart.Text -eq "18")   { $text = "eighteen<N>Heart Containers"  }
        elseif ($Redux.ShopQuantity.RecoveryHeart.Text -eq "19")   { $text = "nineteen<N>Heart Containers"  }
        elseif ($Redux.ShopQuantity.RecoveryHeart.Text -eq "20")   { $text = "twenty<N>Heart Containers"    }
        else                                                       { $text = "???<N>Heart Containers"       }
        SetMessage -ID "00AC" -Text "one<N>Heart Container" -Replace $text
    }

    if (IsDefault $Redux.Quantity.ItemDrops5 -Not) {
        $text = $Redux.Quantity.ItemDrops5.Text
        if ($Redux.Quantity.ItemDrops5.Text -eq "1") { $text += " piece" } else { $text += " pieces" }
        SetMessage -ID "007F" -Text "5 Pieces"  -Replace $text; SetMessage -ID "00B2" -Text "5 pieces"  -Replace $text
    }

    if (IsDefault $Redux.Quantity.ItemDrops10 -Not) {
        $text = $Redux.Quantity.ItemDrops10.Text
        if ($Redux.Quantity.ItemDrops10.Text -eq "1") { $text += " piece" } else { $text += " pieces" }
        SetMessage -ID "0087" -Text "10 pieces" -Replace $text; SetMessage -ID "00A2" -Text "10 pieces" -Replace $text
        SetMessage -ID "007C" -Text "10 pieces" -Replace $text; SetMessage -ID "00B1" -Text "10 pieces" -Replace $text
    }

    if (IsDefault $Redux.Quantity.ItemDrops20 -Not) {
        $text = $Redux.Quantity.ItemDrops20.Text
        if ($Redux.Quantity.ItemDrops20.Text -eq "1") { $text += " piece" } else { $text += " pieces" }
        SetMessage -ID "0006" -Text "20 pieces" -Replace $text; SetMessage -ID "001C" -Text "20 pieces" -Replace $text
    }

    if (IsDefault $Redux.Quantity.ItemDrops30 -Not) {
        $text = $Redux.Quantity.ItemDrops30.Text
        if ($Redux.Quantity.ItemDrops30.Text -eq "1") { $text += " piece" } else { $text += " pieces" }
        SetMessage -ID "001D" -Text "30 pieces" -Replace $text; SetMessage -ID "001E" -Text "30 pieces" -Replace $text
    }

    if (IsDefault $Redux.ShopQuantity.Bombs5 -Not) {
        $text = $Redux.ShopQuantity.Bombs5A.Text
        if ($Redux.ShopQuantity.Bombs5A.Text -eq "1") { $text += " piece" } else { $text += " pieces" }
        SetMessage -ID "008B" -Text "5 pieces" -Replace $text; SetMessage -ID "00A3" -Text "5 pieces" -Replace $text
        SetMessage -ID "00CA" -Text "5 pieces" -Replace $text; SetMessage -ID "00CB" -Text "5 pieces" -Replace $text
    }

    if (IsDefault $Redux.ShopQuantity.Bombchus10A    -Not)   { $text = $Redux.ShopQuantity.Bombchus10A.Text   + " Rupee"; if ($Redux.ShopQuantity.Bombchus10A.Text    -ne "1") { $text += "s" }; SetMessage -ID "008C" -Text "10 pieces"   -Replace $text; SetMessage -ID "00BC" -Text "10 pieces"   -Replace $text }
    if (IsDefault $Redux.ShopQuantity.Bombchus10B    -Not)   { $text = $Redux.ShopQuantity.Bombchus10B.Text   + " Rupee"; if ($Redux.ShopQuantity.Bombchus10B.Text    -ne "1") { $text += "s" }; SetMessage -ID "008C" -Text "10 pieces"   -Replace $text; SetMessage -ID "00BC" -Text "10 Rupees"   -Replace $text }
    if (IsDefault $Redux.ShopQuantity.Bombchus10C    -Not)   { $text = $Redux.ShopQuantity.Bombchus10C.Text   + " Rupee"; if ($Redux.ShopQuantity.Bombchus10C.Text    -ne "1") { $text += "s" }; SetMessage -ID "008C" -Text "10 pieces"   -Replace $text; SetMessage -ID "00BC" -Text "10 pieces"   -Replace $text }
    if (IsDefault $Redux.ShopQuantity.Bombchus10D    -Not)   { $text = $Redux.ShopQuantity.Bombchus10D.Text   + " Rupee"; if ($Redux.ShopQuantity.Bombchus10D.Text    -ne "1") { $text += "s" }; SetMessage -ID "008C" -Text "10 pieces"   -Replace $text; SetMessage -ID "00BC" -Text "10 pieces"   -Replace $text }
    if (IsDefault $Redux.ShopQuantity.Bombchus20A    -Not)   { $text = $Redux.ShopQuantity.Bombchus20A.Text   + " Rupee"; if ($Redux.ShopQuantity.Bombchus20A.Text    -ne "1") { $text += "s" }; SetMessage -ID "0061" -Text "20 pieces"   -Replace $text; SetMessage -ID "002A" -Text "20 pieces"   -Replace $text }
    if (IsDefault $Redux.ShopQuantity.Bombchus20B    -Not)   { $text = $Redux.ShopQuantity.Bombchus20B.Text   + " Rupee"; if ($Redux.ShopQuantity.Bombchus20B.Text    -ne "1") { $text += "s" }; SetMessage -ID "0061" -Text "20 pieces"   -Replace $text; SetMessage -ID "002A" -Text "20 pieces"   -Replace $text }
    if (IsDefault $Redux.ShopQuantity.Bombchus20C    -Not)   { $text = $Redux.ShopQuantity.Bombchus20C.Text   + " Rupee"; if ($Redux.ShopQuantity.Bombchus20C.Text    -ne "1") { $text += "s" }; SetMessage -ID "0061" -Text "20 pieces"   -Replace $text; SetMessage -ID "002A" -Text "20 pieces"   -Replace $text }
    if (IsDefault $Redux.ShopQuantity.Bombchus20D    -Not)   { $text = $Redux.ShopQuantity.Bombchus20D.Text   + " Rupee"; if ($Redux.ShopQuantity.Bombchus20D.Text    -ne "1") { $text += "s" }; SetMessage -ID "0061" -Text "20 pieces"   -Replace $text; SetMessage -ID "002A" -Text "20 pieces"   -Replace $text }
    if (IsDefault $Redux.Capacity.DekuSeedBullets30  -Not)   { $text = $Redux.Capacity.DekuSeedBullets30.Text + " Rupee"; if ($Redux.Capacity.DekuSeedBullets30.Text  -ne "1") { $text += "s" }; SetMessage -ID "00DE" -Text "30 pieces"   -Replace $text; SetMessage -ID "00DF" -Text "30 pieces"   -Replace $text }
    if (IsDefault $Redux.ShopQuantity.Arrows10       -Not)   { $text = $Redux.ShopQuantity.Arrows10.Text      + " Rupee"; if ($Redux.ShopQuantity.Arrows10.Text       -ne "1") { $text += "s" }; SetMessage -ID "008A" -Text "10 pieces"   -Replace $text; SetMessage -ID "00A0" -Text "10 pieces"   -Replace $text }
    if (IsDefault $Redux.ShopQuantity.Arrows30       -Not)   { $text = $Redux.ShopQuantity.Arrows30.Text      + " Rupee"; if ($Redux.ShopQuantity.Arrows30.Text       -ne "1") { $text += "s" }; SetMessage -ID "009B" -Text "30 pieces"   -Replace $text; SetMessage -ID "00C1" -Text "30 pieces"   -Replace $text }
    if (IsDefault $Redux.ShopQuantity.Arrows50       -Not)   { $text = $Redux.ShopQuantity.Arrows50.Text      + " Rupee"; if ($Redux.ShopQuantity.Arrows50.Text       -ne "1") { $text += "s" }; SetMessage -ID "007D" -Text "50 pieces"   -Replace $text; SetMessage -ID "00B0" -Text "50 pieces"   -Replace $text }

    # Shop Price
    if (IsDefault $Redux.ShopPrice.RecoveryHeart     -Not)   { $text = $Redux.ShopPrice.RecoveryHeart.Text     + " Rupee"; if ($Redux.ShopPrice.RecoveryHeart.Text     -ne "1") { $text += "s" }; SetMessage -ID "0095" -Text "10 Rupees"   -Replace $text; SetMessage -ID "00AC" -Text "10 Rupees"   -Replace $text }
    if (IsDefault $Redux.ShopPrice.DekuStick         -Not)   { $text = $Redux.ShopPrice.DekuStick.Text         + " Rupee"; if ($Redux.ShopPrice.DekuStick.Text         -ne "1") { $text += "s" }; SetMessage -ID "0088" -Text "10 Rupees"   -Replace $text; SetMessage -ID "00A1" -Text "10 Rupees"   -Replace $text }
    if (IsDefault $Redux.ShopPrice.DekuNuts5         -Not)   { $text = $Redux.ShopPrice.DekuNuts5.Text         + " Rupee"; if ($Redux.ShopPrice.DekuNuts5.Text         -ne "1") { $text += "s" }; SetMessage -ID "007F" -Text "5 Rupees"    -Replace $text; SetMessage -ID "00B2" -Text "5 Rupees"    -Replace $text }
    if (IsDefault $Redux.ShopPrice.DekuNuts10        -Not)   { $text = $Redux.ShopPrice.DekuNuts10.Text        + " Rupee"; if ($Redux.ShopPrice.DekuNuts10.Text        -ne "1") { $text += "s" }; SetMessage -ID "0087" -Text "10 Rupees"   -Replace $text; SetMessage -ID "00A2" -Text "10 Rupees"   -Replace $text }
    if (IsDefault $Redux.ShopPrice.Bombs5A           -Not)   { $text = $Redux.ShopPrice.Bombs5A.Text           + " Rupee"; if ($Redux.ShopPrice.Bombs5A.Text           -ne "1") { $text += "s" }; SetMessage -ID "008B" -Text "25 Rupees"   -Replace $text; SetMessage -ID "00A3" -Text "25 Rupees"   -Replace $text }
    if (IsDefault $Redux.ShopPrice.Bombs5B           -Not)   { $text = $Redux.ShopPrice.Bombs5B.Text           + " Rupee"; if ($Redux.ShopPrice.Bombs5B.Text           -ne "1") { $text += "s" }; SetMessage -ID "00CA" -Text "35 Rupees"   -Replace $text; SetMessage -ID "00CB" -Text "35 Rupees"   -Replace $text }
    if (IsDefault $Redux.ShopPrice.Bombs10           -Not)   { $text = $Redux.ShopPrice.Bombs10.Text           + " Rupee"; if ($Redux.ShopPrice.Bombs10.Text           -ne "1") { $text += "s" }; SetMessage -ID "007C" -Text "50 Rupees"   -Replace $text; SetMessage -ID "00B1" -Text "50 Rupees"   -Replace $text }
    if (IsDefault $Redux.ShopPrice.Bombs20           -Not)   { $text = $Redux.ShopPrice.Bombs20.Text           + " Rupee"; if ($Redux.ShopPrice.Bombs20.Text           -ne "1") { $text += "s" }; SetMessage -ID "0006" -Text "80 Rupees"   -Replace $text; SetMessage -ID "001C" -Text "80 Rupees"   -Replace $text }
    if (IsDefault $Redux.ShopPrice.Bombs30           -Not)   { $text = $Redux.ShopPrice.Bombs30.Text           + " Rupee"; if ($Redux.ShopPrice.Bombs30.Text           -ne "1") { $text += "s" }; SetMessage -ID "001D" -Text "120 Rupees"  -Replace $text; SetMessage -ID "001E" -Text "120 Rupees"  -Replace $text }
    if (IsDefault $Redux.ShopPrice.Bombchus10A       -Not)   { $text = $Redux.ShopPrice.Bombchus10A.Text       + " Rupee"; if ($Redux.ShopPrice.Bombchus10A.Text       -ne "1") { $text += "s" }; SetMessage -ID "008C" -Text "100 Rupees"  -Replace $text; SetMessage -ID "00BC" -Text "100 Rupees"  -Replace $text }
    if (IsDefault $Redux.ShopPrice.Bombchus10B       -Not)   { $text = $Redux.ShopPrice.Bombchus10B.Text       + " Rupee"; if ($Redux.ShopPrice.Bombchus10B.Text       -ne "1") { $text += "s" }; SetMessage -ID "008C" -Text "100 Rupees"  -Replace $text; SetMessage -ID "00BC" -Text "100 Rupees"  -Replace $text }
    if (IsDefault $Redux.ShopPrice.Bombchus10C       -Not)   { $text = $Redux.ShopPrice.Bombchus10C.Text       + " Rupee"; if ($Redux.ShopPrice.Bombchus10C.Text       -ne "1") { $text += "s" }; SetMessage -ID "008C" -Text "100 Rupees"  -Replace $text; SetMessage -ID "00BC" -Text "100 Rupees"  -Replace $text }
    if (IsDefault $Redux.ShopPrice.Bombchus10D       -Not)   { $text = $Redux.ShopPrice.Bombchus10D.Text       + " Rupee"; if ($Redux.ShopPrice.Bombchus10D.Text       -ne "1") { $text += "s" }; SetMessage -ID "008C" -Text "100 Rupees"  -Replace $text; SetMessage -ID "00BC" -Text "100 Rupees"  -Replace $text }
    if (IsDefault $Redux.ShopPrice.Bombchus20A       -Not)   { $text = $Redux.ShopPrice.Bombchus20A.Text       + " Rupee"; if ($Redux.ShopPrice.Bombchus20A.Text       -ne "1") { $text += "s" }; SetMessage -ID "0061" -Text "180 Rupees"  -Replace $text; SetMessage -ID "002A" -Text "180 Rupees"  -Replace $text }
    if (IsDefault $Redux.ShopPrice.Bombchus20B       -Not)   { $text = $Redux.ShopPrice.Bombchus20B.Text       + " Rupee"; if ($Redux.ShopPrice.Bombchus20B.Text       -ne "1") { $text += "s" }; SetMessage -ID "0061" -Text "180 Rupees"  -Replace $text; SetMessage -ID "002A" -Text "180 Rupees"  -Replace $text }
    if (IsDefault $Redux.ShopPrice.Bombchus20C       -Not)   { $text = $Redux.ShopPrice.Bombchus20C.Text       + " Rupee"; if ($Redux.ShopPrice.Bombchus20C.Text       -ne "1") { $text += "s" }; SetMessage -ID "0061" -Text "180 Rupees"  -Replace $text; SetMessage -ID "002A" -Text "180 Rupees"  -Replace $text }
    if (IsDefault $Redux.ShopPrice.Bombchus20D       -Not)   { $text = $Redux.ShopPrice.Bombchus20D.Text       + " Rupee"; if ($Redux.ShopPrice.Bombchus20D.Text       -ne "1") { $text += "s" }; SetMessage -ID "0061" -Text "180 Rupees"  -Replace $text; SetMessage -ID "002A" -Text "180 Rupees"  -Replace $text }
    if (IsDefault $Redux.ShopPrice.DekuSeedBullets30 -Not)   { $text = $Redux.ShopPrice.DekuSeedBullets30.Text + " Rupee"; if ($Redux.ShopPrice.DekuSeedBullets30.Text -ne "1") { $text += "s" }; SetMessage -ID "00DE" -Text "30 Rupees"   -Replace $text; SetMessage -ID "00DF" -Text "30 Rupees"   -Replace $text }
    if (IsDefault $Redux.ShopPrice.Arrows10          -Not)   { $text = $Redux.ShopPrice.Arrows10.Text          + " Rupee"; if ($Redux.ShopPrice.Arrows10.Text          -ne "1") { $text += "s" }; SetMessage -ID "008A" -Text "20 Rupees"   -Replace $text; SetMessage -ID "00A0" -Text "20 Rupees"   -Replace $text }
    if (IsDefault $Redux.ShopPrice.Arrows30          -Not)   { $text = $Redux.ShopPrice.Arrows30.Text          + " Rupee"; if ($Redux.ShopPrice.Arrows30.Text          -ne "1") { $text += "s" }; SetMessage -ID "009B" -Text "60 Rupees"   -Replace $text; SetMessage -ID "00C1" -Text "60 Rupees"   -Replace $text }
    if (IsDefault $Redux.ShopPrice.Arrows50          -Not)   { $text = $Redux.ShopPrice.Arrows50.Text          + " Rupee"; if ($Redux.ShopPrice.Arrows50.Text          -ne "1") { $text += "s" }; SetMessage -ID "007D" -Text "80 Rupees"   -Replace $text; SetMessage -ID "00B0" -Text "80 Rupees"   -Replace $text }
    if (IsDefault $Redux.ShopPrice.DekuShield        -Not)   { $text = $Redux.ShopPrice.DekuShield.Text        + " Rupee"; if ($Redux.ShopPrice.DekuShield.Text        -ne "1") { $text += "s" }; SetMessage -ID "0089" -Text "40 Rupees"   -Replace $text; SetMessage -ID "009F" -Text "40 Rupees"   -Replace $text }
    if (IsDefault $Redux.ShopPrice.HylianShield      -Not)   { $text = $Redux.ShopPrice.HylianShield.Text      + " Rupee"; if ($Redux.ShopPrice.HylianShield.Text      -ne "1") { $text += "s" }; SetMessage -ID "0092" -Text "80 Rupees"   -Replace $text; SetMessage -ID "00A9" -Text "80 Rupees"   -Replace $text }
    if (IsDefault $Redux.ShopPrice.GiantsKnife       -Not)   { $text = $Redux.ShopPrice.GiantsKnife.Text       + " Rupee"; if ($Redux.ShopPrice.GiantsKnife.Text       -ne "1") { $text += "s" }; SetMessage -ID "010D" -Text "1000 Rupees" -Replace $text; SetMessage -ID "010E" -Text "1000 Rupees" -Replace $text }
    if (IsDefault $Redux.ShopPrice.GoronTunic        -Not)   { $text = $Redux.ShopPrice.GoronTunic.Text        + " Rupee"; if ($Redux.ShopPrice.GoronTunic.Text        -ne "1") { $text += "s" }; SetMessage -ID "0093" -Text "200 Rupees"  -Replace $text; SetMessage -ID "00AA" -Text "200 Rupees"  -Replace $text }
    if (IsDefault $Redux.ShopPrice.ZoraTunic         -Not)   { $text = $Redux.ShopPrice.ZoraTunic.Text         + " Rupee"; if ($Redux.ShopPrice.ZoraTunic.Text         -ne "1") { $text += "s" }; SetMessage -ID "0094" -Text "300 Rupees"  -Replace $text; SetMessage -ID "00AB" -Text "300 Rupees"  -Replace $text }
    if (IsDefault $Redux.ShopPrice.RedPotionA        -Not)   { $text = $Redux.ShopPrice.RedPotionA.Text        + " Rupee"; if ($Redux.ShopPrice.RedPotionA.Text        -ne "1") { $text += "s" }; SetMessage -ID "008E" -Text "30 Rupees"   -Replace $text; SetMessage -ID "00A5" -Text "30 Rupees"   -Replace $text }
    if (IsDefault $Redux.ShopPrice.RedPotionB        -Not)   { $text = $Redux.ShopPrice.RedPotionB.Text        + " Rupee"; if ($Redux.ShopPrice.RedPotionB.Text        -ne "1") { $text += "s" }; SetMessage -ID "0062" -Text "40 Rupees"   -Replace $text; SetMessage -ID "0064" -Text "40 Rupees"   -Replace $text }
    if (IsDefault $Redux.ShopPrice.RedPotionC        -Not)   { $text = $Redux.ShopPrice.RedPotionC.Text        + " Rupee"; if ($Redux.ShopPrice.RedPotionC.Text        -ne "1") { $text += "s" }; SetMessage -ID "0063" -Text "50 Rupees"   -Replace $text; SetMessage -ID "0065" -Text "50 Rupees"   -Replace $text }
    if (IsDefault $Redux.ShopPrice.GreenPotion       -Not)   { $text = $Redux.ShopPrice.GreenPotion.Text       + " Rupee"; if ($Redux.ShopPrice.GreenPotion.Text       -ne "1") { $text += "s" }; SetMessage -ID "008F" -Text "30 Rupees"   -Replace $text; SetMessage -ID "00A6" -Text "30 Rupees"   -Replace $text }
    if (IsDefault $Redux.ShopPrice.BluePotion        -Not)   { $text = $Redux.ShopPrice.BluePotion.Text        + " Rupee"; if ($Redux.ShopPrice.BluePotion.Text        -ne "1") { $text += "s" }; SetMessage -ID "0090" -Text "60 Rupees"   -Replace $text; SetMessage -ID "00A7" -Text "60 Rupees"   -Replace $text }
    if (IsDefault $Redux.ShopPrice.Milk              -Not)   { $text = $Redux.ShopPrice.Milk.Text              + " Rupee"; if ($Redux.ShopPrice.Milk.Text              -ne "1") { $text += "s" }; SetMessage -ID "010F" -Text "100 Rupees"  -Replace $text; SetMessage -ID "0110" -Text "100 Rupees"  -Replace $text }
    if (IsDefault $Redux.ShopPrice.Fairy             -Not)   { $text = $Redux.ShopPrice.Fairy.Text             + " Rupee"; if ($Redux.ShopPrice.Fairy.Text             -ne "1") { $text += "s" }; SetMessage -ID "00B6" -Text "50 Rupees"   -Replace $text; SetMessage -ID "00B7" -Text "50 Rupees"   -Replace $text }
    if (IsDefault $Redux.ShopPrice.BlueFire          -Not)   { $text = $Redux.ShopPrice.BlueFire.Text          + " Rupee"; if ($Redux.ShopPrice.BlueFire.Text          -ne "1") { $text += "s" }; SetMessage -ID "00B8" -Text "300 Rupees"  -Replace $text; SetMessage -ID "00B9" -Text "300 Rupees"  -Replace $text }
    if (IsDefault $Redux.ShopPrice.Bug               -Not)   { $text = $Redux.ShopPrice.Bug.Text               + " Rupee"; if ($Redux.ShopPrice.Bug.Text               -ne "1") { $text += "s" }; SetMessage -ID "00BA" -Text "50 Rupees"   -Replace $text; SetMessage -ID "00BB" -Text "50 Rupees"   -Replace $text }
    if (IsDefault $Redux.ShopPrice.Fish              -Not)   { $text = $Redux.ShopPrice.Fish.Text              + " Rupee"; if ($Redux.ShopPrice.Fish.Text              -ne "1") { $text += "s" }; SetMessage -ID "007E" -Text "200 Rupees"  -Replace $text; SetMessage -ID "00B3" -Text "200 Rupees"  -Replace $text }
    if (IsDefault $Redux.ShopPrice.Poe               -Not)   { $text = $Redux.ShopPrice.Poe.Text               + " Rupee"; if ($Redux.ShopPrice.Poe.Text               -ne "1") { $text += "s" }; SetMessage -ID "506E" -Text "30 Rupees"   -Replace $text; SetMessage -ID "506D" -Text "30 Rupees"   -Replace $text }
    if (IsDefault $Redux.ShopPrice.BigPoe            -Not)   { $text = $Redux.ShopPrice.BigPoe.Text            + " Rupee"; if ($Redux.ShopPrice.BigPoe.Text            -ne "1") { $text += "s" }; SetMessage -ID "506F" -Text "50 Rupees"   -Replace $text; SetMessage -ID "0113" -Text "50 Rupees"   -Replace $text }
    if (IsDefault $Redux.ShopPrice.WeirdEgg          -Not)   { $text = $Redux.ShopPrice.WeirdEgg.Text          + " Rupee"; if ($Redux.ShopPrice.WeirdEgg.Text          -ne "1") { $text += "s" }; SetMessage -ID "0111" -Text "100 Rupees"  -Replace $text; SetMessage -ID "0112" -Text "100 Rupees"  -Replace $text }

    if (IsChecked $Redux.Text.FemalePronouns -Lang 1) {
        SetMessage -ID "10B2" -Text "You must be a nice guy!"                                                          -Replace "You must be a nice gal!"
        SetMessage -ID "10B2" -Text "Mr. Nice Guy"                                                                     -Replace "Ms. Nice Gal"
        SetMessage -ID "1070" -Text "waiting for him..."                                                               -Replace "waiting for her..."
        SetMessage -ID "2086" -Text "How'd you like to marry Malon?"                                                   -Replace "How'd you like to come work for us?"
        SetMessage -ID "301C" -Text "fella"                                                                            -Replace "lass"
        SetMessage -ID "3039" -Text "man-to-man"                                                                       -Replace "man-to-woman"
        SetMessage -ID "3042" -Text "be a<N>strong man like you"                                                       -Replace "<N>be strong like you"
        SetMessage -ID "4027" -Text @(6, 69); SetMessage -ID "4027" -Text "All right!"                                 -Replace "You're no man, so let this<N>be our little secret, ok?"
        SetMessage -ID "403E" -Text "It's me, your fiancée, <B>Ruto<W>!"                                               -Replace "It's me, your friend, <B>Ruto<W>!"
        SetMessage -ID "403E" -Text "I never forgot the vows we<N>made to each other seven years <N>ago!"              -Replace "I never forgot the<N>promise we made to<N>each other seven <N>years ago!"
        SetMessage -ID "403E" -Text "man"                                                                              -Replace "confidant"
        SetMessage -ID "403E" -Text "love"                                                                             -Replace "friendship"
        SetMessage -ID "403E" -Text "the<N>woman who is going to be your<N>wife!"                                      -Replace "the <N>woman who trusted you!"
        SetMessage -ID "4041" -Text "man I chose to be my<N>husband"                                                   -Replace "woman I chose to be <N>my confidant"
        SetMessage -ID "4046" -Text "Well, that's what I want to say, <N>but I don't think I can offer that<N>now."    -Replace "Ah! Just kidding!<N>We're friends and <N>that's more than enough."
        SetMessage -ID "404E" -Text "If you're a man, act like one!"                                                   -Replace "If you're trying to save me, act like it!"
        SetMessage -ID "507C" -Text "There he is! It's him!<N>He"                                                      -Replace "There she is! It's her!<N>She"
        SetMessage -ID "6004" -Text "I used to think that all men, <N>besides the great Ganondorf, were <N>useless..." -Replace "I used to think that <N>outsiders were nothing but <N>trouble..."
        SetMessage -ID "6035" -Text "swordsman"                                                                        -Replace "warrior"
	    SetMessage -ID "6036" -Text "handsome man...<Delay:50>I should have kept the promise<N>I made back then..."    -Replace "beautiful woman...<Delay:50>I should have had let you<N>join us back then..."
        SetMessage -ID "70F4" -Text "handsome"                                                                         -Replace "pretty"
        SetMessage -ID "7177"                                                                                          -Replace "Ah ah ah!<N>You're so funny!"

        SetMessage -ID "00E7" -Text "boy"      -Replace "girl";       SetMessage -ID "0408"; SetMessage -ID "1058" -All; SetMessage -ID "105B"; SetMessage -ID "1065"; SetMessage -ID "1096"; SetMessage -ID "109A"; SetMessage -ID "109F"; SetMessage -ID "2000"; SetMessage -ID "2041"; SetMessage -ID "2043"
        SetMessage -ID "2047" -All;                                   SetMessage -ID "2048"; SetMessage -ID "204A";      SetMessage -ID "2086"; SetMessage -ID "40AC"; SetMessage -ID "5022"; SetMessage -ID "5036"; SetMessage -ID "505B"; SetMessage -ID "505D"; SetMessage -ID "6024"
        SetMessage -ID "605D" -All;                                   SetMessage -ID "6079"; SetMessage -ID "7007" -All; SetMessage -ID "7023"; SetMessage -ID "7090"; SetMessage -ID "7174"

        SetMessage -ID "00BE" -Text "man"      -Replace "lady";       SetMessage -ID "0168"; SetMessage -ID "021C";      SetMessage -ID "2025"; SetMessage -ID "2030"; SetMessage -ID "2037"; SetMessage -ID "2085"; SetMessage -ID "407D"; SetMessage -ID "4088"; SetMessage -ID "502D"
        SetMessage -ID "502E";                                        SetMessage -ID "5041"; SetMessage -ID "505B" -All; SetMessage -ID "5081"; SetMessage -ID "6066"; SetMessage -ID "7011"; SetMessage -ID "70F4"; SetMessage -ID "70F5"; SetMessage -ID "70F7"; SetMessage -ID "70F8"

        SetMessage -ID "70A1" -Text "man"      -Replace "woman"
        SetMessage -ID "102F" -Text "real man" -Replace "real woman"; SetMessage -ID "10D7"; SetMessage -ID "301C"; SetMessage -ID "301D"; SetMessage -ID "303C"
        SetMessage -ID "301E" -Text "Brother"  -Replace "Sister";     SetMessage -ID "3027"; SetMessage -ID "3039"; SetMessage -ID "303C"; SetMessage -ID "3041"; SetMessage -ID "3045"; SetMessage -ID "3046"; SetMessage -ID "3068" -All
        SetMessage -ID "3006" -Text "brother"  -Replace "Sister";     SetMessage -ID "70E1"
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
        SetMessage -ID "109A" -Text "his"      -Replace "her";        SetMessage -ID "604A"; SetMessage -ID "109A" -All; SetMessage -ID "6048"
        SetMessage -ID "1065" -Text "him"      -Replace "her";        SetMessage -ID "1068"; SetMessage -ID "1071" -All; SetMessage -ID "109A" -All; SetMessage -ID "10D6" -All; SetMessage -ID "5034"; SetMessage -ID "6048"; SetMessage -ID "6049"; SetMessage -ID "604A"
    }

    if (IsChecked $Redux.Text.Restore -Lang 1) {
        if (TestFile ($GameFiles.textures + "\Text Labels\keaton_mask." + $LanguagePatch.code + ".label")) { PatchBytes -Offset "8A7C00" -Texture -Patch ("Text Labels\keaton_mask." + $LanguagePatch.code + ".label") }

        SetMessage -ID "0004"                                                                  -Replace "You received an Odd Potion!<N>You don't know what's going on<N>between this lady and that guy,<N>but take it to the Lost Woods!"
        SetMessage -ID "0057" -Text "<Icon:4B>"                                                -Replace "<Icon:4C>"
        SetMessage -ID "00F3" -Text "treasure <N>chest and "                                   -Replace "chest and<N>"
        SetMessage -ID "0616" -Text "try to cut it, it will bounce<N>off your blade!"          -Replace "cut it, it will burst open and<N>knock you back!"
        SetMessage -ID "109B" -Text "<DI><C>Twenty-three is number one!<W><DC><N><NS><Sound:3880>Do you think I'm a traitor?"                                                  -Replace "<DI><C>Twenty-three is number one!<W><DC><New Box><NS><Sound:3880>Do you think I'm a traitor?"
	    SetMessage -ID "10B8"                                                                  -Replace "That guy isn't here anymore.<New Box>Anybody who comes into the<N>forest will be lost.<New Box>Everybody will become a Stalfos.<N>Everybody, Stalfos.<N>So, he's not here anymore.<N>Only his saw is left. Hee hee.<New Box>That medicine is made of<N>forest mushrooms. Give it back!<N><Two Choices><G>Yes<N>No<W>"
        if (IsChecked $Redux.Text.FemalePronouns -Not) { SetMessage -ID "3006" -Text "brother" -Replace "Brother" }
        SetMessage -ID "2047" -Text "I heard that you found my dad!"                           -Replace "<NS>I heard that you found my dad!"
	    SetMessage -ID "4013" -Text "the <N>temple of Lake Hylia and has not<N>come back... "  -Replace "Lake<N>Hylia and has not come back...<N>"
        SetMessage -ID "507B" -Text @(1, 1)                                                    -Replace @(1)
        SetMessage -ID "6035" -Text "<NS>Kid, let me thank you.<N><NS>Heheheh..."              -Replace "<NS>Kid, let me thank you.<New Box><NS>Heheheh..."
	    SetMessage -ID "6041" -Text "again "                                                   -Replace ""
        SetMessage -ID "6044" -Text "a true"                                                   -Replace "the ultimate"
	    SetMessage -ID "6044" -Text "a master"                                                 -Replace "the master"
        SetMessage -ID "6046"                                                                  -Replace "Fantastic!<N>You are a true master!<N>I will give this to you.<N>Keep improving yourself!"
        SetMessage -ID "6067"                                                                  -Replace "Building a bridge over the valley<N>is a simple task for four<N>carpenters."
        SetMessage -ID "6077" -Text "Well Come!"                                               -Replace "Welcome!"
	    SetMessage -ID "7027" -Text "<NS>But with the long peace, no one<N>has seen a Sheikah around here <N>for a long time.<N><NS>However..."                               -Replace "<NS>But with the long peace, no one<N>has seen a Sheikah around here <N>for a long time.<New Box><NS>However..."
        SetMessage -ID "7074" -Text "<New Box>under water...<New Box>and even through time..."                                                                                -Replace "<New Box><NS>under water...<New Box><NS>and even through time..."
	    SetMessage -ID "7084" -Text "Thus, Ganondorf the Evil King"                            -Replace "<NS>Thus, Ganondorf the Evil King"
	    if (IsChecked $Redux.Text.FemalePronouns -Not) { SetMessage -ID "70E1" -Text "brother" -Replace "Brother" }
        SetMessage -ID "7091" -Text "<NS>I dragged you into it, too.<N><NS>Now it is time for me to make up <N>for my mistakes..."                                            -Replace "<NS>I dragged you into it, too.<New Box><NS>Now it is time for me to make up <N>for my mistakes..."
	    SetMessage -ID "70AA" -Text "Ho ho ho!"                                                -Replace "<NS>Ho ho ho!"
        SetMessage -ID "70F7" -Text "On top of that"                                           -Replace "<NS>On top of that"
    }

    if (IsIndex $Redux.Gameplay.RemoveOwls -Index 3 -Lang 1) {
        SetMessage -ID "0416"                                                                  -Replace "They say that an owl flying<N>around Hyrule is the<N>reincarnation of an ancient Sage."
        SetMessage -ID "0417"                                                                  -Replace "They say that a strange owl<N>around here, may look big and<N>heavy, but its character is rather <N>lighthearted."
    }

    if (IsChecked $Redux.Gameplay.InstantClaimCheck -Lang 1) {
        SetMessage -ID "305A" -Text "My worrrrrk is not <N>verrrry consistent, so "            -Replace "Now, I know you're <N>verrrry busy, so "
        SetMessage -ID "305C"                                                                  -Replace "Please returrrrrrn soon...<N>When you're readyyyy<N>for it, show the claim<N>agaaaain..."
    }
    
    if (IsChecked $Redux.Graphics.GCScheme) {
        if (IsChecked $Redux.Graphics.GCScheme -Lang 1) {
            SetMessage -ID "001C" -Text "press"            -Replace "use"; SetMessage -ID "001D"; SetMessage -ID "0030"; SetMessage -ID "0039" -All; SetMessage -ID "004A"; SetMessage -ID "00A3"; SetMessage -ID "00B1"; SetMessage -ID "00CB"; SetMessage -ID "70A3"; SetMessage -ID "103F" # press -> use
            SetMessage -ID "0030" -Text "Press"            -Replace "Use"; SetMessage -ID "0031"; SetMessage -ID "0032"; SetMessage -ID "0038"                                                                                                                                                # Press -> Use
            SetMessage -ID "007A" -Text "7072657373696E67" -Replace "7573696E67"                                                                                                                                                                                                              # pressing -> using

            # N64 -> GC Text phrasing adjustments
            SetMessage -ID "0031" -Text "As you hold down<N><Y><C Button><W>"                                                                                                                  -Replace "As you hold <Y><C Button><N><W>"
            SetMessage -ID "0035" -Text "Press <Y><C Button><W> to use it to <N>attack distant enemies!"                                                                                       -Replace "Then you can attack distant<N>enemies with it by using <Y><C Button><W>!"
            SetMessage -ID "0047" -Text "you can set it to <Y><C Left><W>, <Y><C Down><W><N>or <Y><C Right><W>, and then press that<N><Y><C Button> <W>to use it."                             -Replace "you can set it to and use it<N>with <Y><C Left><W>, <Y><C Down><W><N> or <Y><C Right><W>!"
            SetMessage -ID "004A" -Text "and the four <Y><C Button> Buttons<W>."                                                                                                               -Replace "and the four <Y><C Button><W>."
            SetMessage -ID "0099" -Text "press <Y><C Button> <W>to use it..."                                                                                                                  -Replace "use it with <Y><C Button><W>..."
            SetMessage -ID "009A" -Text "you can set it to <Y><C Left><W>, <Y><C Down> <W>or <Y><C Right><W>,<N>and then press <Y><C Button> <W>to use it."                                    -Replace "you can set it to and use it<N>with <Y><C Left><W>, <Y><C Down><W><N> or <Y><C Right><W>."
            SetMessage -ID "1025" -Text "You can aim while holding down<N><Y><C Button><W> and shoot by releasing the<N>button! How cool!"                                                     -Replace "You can aim while holding <N><Y><C Button><W> and shoot by releasing<N>it! How cool!"
            SetMessage -ID "1036" -Text "Once you get a <Y><C Button> Button item<W>, <N>go into the <Y>Select Item Subscreen<W> <N>and set it to one of the three<N><Y><C Button> Buttons<W>."-Replace "Once you get a <Y><C Button> item<W>, <N>go into the <Y>Select Item Subscreen<W> <N>and set it to one of the three<N><Y><C Button><W>."
            SetMessage -ID "1036" -Text " <W>buttons."                                                                                                                                         -Replace "<W>."       
	    
            # Buttons -> C Icon Only
            SetMessage -ID "103A" -Text "Button items"                                                    -Replace "items" -All
            SetMessage -ID "103A" -Text ", and<N>used by pressing those buttons."                         -Replace "<W>."
            SetMessage -ID "103A" -Text "<W>, press <Y><C Left><W>,<N><Y><C Down> <W>or <Y><C Right><W>." -Replace "<W>, use <Y><C Left><W>,<N><Y><C Down> <W>or <Y><C Right><W>."  # GC Text Finalization (A little trick to keep the other buttons intact)
            SetMessage -ID "70A3" -Text "Button <W>item."                                                 -Replace "<W>item."
	        SetMessage -ID "103E" -Text "use<N>the <Y><C Up> Button<W>?"                                  -Replace "use<N><Y><C Up><W>?"

            # Pak -> Feature	    
            SetMessage -ID "0068" -Text "If you equip a <C>Rumble Pak<W>, it<N>will"              -Replace "It causes your <C>Rumble Feature<W><N>to"
            SetMessage -ID "407C" -Text "You don't have a <R>Rumble <N>Pak<W>! With a Rumble Pak" -Replace "You don't have a <R>Rumble<N>Feature<W>! With it"
            SetMessage -ID "407D" -Text "Wow! You have a <R>Rumble Pak<W>!"                       -Replace "Wow! You have a <R>Rumble Feature<W>!"

            SetMessage -ID "0337" -Text 'Hole of "Z"'    -Replace 'Hole of "L"'
            SetMessage -ID "1035" -Text "blue icon"      -Replace "green icon"; SetMessage -ID "1037"
            SetMessage -ID "1037" -Text "<B>Action Icon" -Replace "<G>Action Icon"
        }

        SetMessage -ID "0103" -Text "<B><A Button>" -Replace "<G><A Button>"; SetMessage -ID "0103" -Text "<B>Icon"   -Replace "<G>Icon"; SetMessage -ID "0103" -Text "<B>blue" -Replace "<G>green"; SetMessage -ID "0103" -Text "<B>Action" -Replace "<G>Action" # Deku Tree - Opening a door
        SetMessage -ID "0108" -Text "<B>Action"     -Replace "<G>Action";     SetMessage -ID "0337" -Text "<B>Action" -Replace "<G>Action" -All # Deku Tree - Other Tutorials
        SetMessage -ID "1037" -Text "<B><A Button>" -Replace "<G><A Button>"

        SetMessage -ID "0066" -Text "05415354415254" -Replace "05445354415254"; SetMessage -ID "1039"; SetMessage -ID "103A"; SetMessage -ID "103B";      SetMessage -ID "103D"; SetMessage -ID "2065"; SetMessage -ID "2071"; SetMessage -ID "405A" # START
        SetMessage -ID "002E" -Text "0542A0" -Replace "0541A0";                 SetMessage -ID "004A"; SetMessage -ID "004B"; SetMessage -ID "00DD" -All; SetMessage -ID "0336"; SetMessage -ID "0338"; SetMessage -ID "0401"; SetMessage -ID "086E" # B Button
        SetMessage -ID "087C";                                                  SetMessage -ID "103B"; SetMessage -ID "1072"; SetMessage -ID "407F" -All # B Button

        SetMessage -ID "0037" -Text "05439F" -Replace "05429F"; SetMessage -ID "004A";      SetMessage -ID "004C"; SetMessage -ID "004D";      SetMessage -ID "005B";      SetMessage -ID "005C"; SetMessage -ID "0079"; SetMessage -ID "00A4";      SetMessage -ID "00CD"; SetMessage -ID "00CE"; SetMessage -ID "0108" -All; SetMessage -ID "0218"; SetMessage -ID "0337" # A Button
        SetMessage -ID "086D";                                  SetMessage -ID "086E";      SetMessage -ID "087C"; SetMessage -ID "1004" -All; SetMessage -ID "1007" -All; SetMessage -ID "103A"; SetMessage -ID "103D"; SetMessage -ID "2035" -All; SetMessage -ID "2037"; SetMessage -ID "300C"; SetMessage -ID "301C";      SetMessage -ID "3022"
        SetMessage -ID "302B" -All;                             SetMessage -ID "407F" -All; SetMessage -ID "4081"; SetMessage -ID "7004" -All
        SetMessage -ID "010C" -Text "0543209F" -Replace "0542209F"
    }

    if ( (IsChecked $Redux.Text.LinkScript) -and $Redux.Text.LinkName.Text.Count -gt 0) {
        SetMessage -ID "00D7" -Text "0F" -Replace $Redux.Text.LinkName.text;
        SetMessage -ID "00D8";      SetMessage -ID "00D9";      SetMessage -ID "00DB"; SetMessage -ID "00E2";      SetMessage -ID "00EA"; SetMessage -ID "0101";      SetMessage -ID "0102";      SetMessage -ID "011F";      SetMessage -ID "012F";      SetMessage -ID "0131";      SetMessage -ID "0132"
        SetMessage -ID "0133";      SetMessage -ID "015F";      SetMessage -ID "0162"; SetMessage -ID "0165";      SetMessage -ID "0166"; SetMessage -ID "0168";      SetMessage -ID "016A";      SetMessage -ID "016B" -All; SetMessage -ID "016C" -All; SetMessage -ID "018D";      SetMessage -ID "0198"
        SetMessage -ID "01A3";      SetMessage -ID "01AB";      SetMessage -ID "0218"; SetMessage -ID "022A";      SetMessage -ID "031F"; SetMessage -ID "0626";      SetMessage -ID "1001";      SetMessage -ID "1002";      SetMessage -ID "1005";      SetMessage -ID "100F";      SetMessage -ID "1015" -All
        SetMessage -ID "1017" -All; SetMessage -ID "1024";      SetMessage -ID "1026"; SetMessage -ID "102A" -All; SetMessage -ID "102B"; SetMessage -ID "1045";      SetMessage -ID "1047";      SetMessage -ID "1048";      SetMessage -ID "104B";      SetMessage -ID "1058" -All; SetMessage -ID "105B"
        SetMessage -ID "105C";      SetMessage -ID "1066";      SetMessage -ID "106D"; SetMessage -ID "1070";      SetMessage -ID "1075"; SetMessage -ID "107A";      SetMessage -ID "107C";      SetMessage -ID "1093";      SetMessage -ID "1094";      SetMessage -ID "1095" -All; SetMessage -ID "10A8"
        SetMessage -ID "10C0";      SetMessage -ID "2000" -All; SetMessage -ID "2005"; SetMessage -ID "2008";      SetMessage -ID "2009"; SetMessage -ID "2010";      SetMessage -ID "2018";      SetMessage -ID "2064";      SetMessage -ID "2068";      SetMessage -ID "206C";      SetMessage -ID "206D"
        SetMessage -ID "206E";      SetMessage -ID "206F";      SetMessage -ID "2074"; SetMessage -ID "2075";      SetMessage -ID "207B"; SetMessage -ID "208B";      SetMessage -ID "3031";      SetMessage -ID "3032" -All; SetMessage -ID "3036";      SetMessage -ID "3037";      SetMessage -ID "3039" -All
        SetMessage -ID "303B";      SetMessage -ID "303F";      SetMessage -ID "3040"; SetMessage -ID "3041";      SetMessage -ID "3042"; SetMessage -ID "3043";      SetMessage -ID "3062";      SetMessage -ID "4002";      SetMessage -ID "4003";      SetMessage -ID "4017";      SetMessage -ID "4024" -All
        SetMessage -ID "402B";      SetMessage -ID "402D";      SetMessage -ID "402E"; SetMessage -ID "4031";      SetMessage -ID "4036"; SetMessage -ID "403E" -All; SetMessage -ID "403F";      SetMessage -ID "4041";      SetMessage -ID "4057";      SetMessage -ID "4059";      SetMessage -ID "4089"
        SetMessage -ID "40B1";      SetMessage -ID "501B";      SetMessage -ID "501C"; SetMessage -ID "501D";      SetMessage -ID "5024"; SetMessage -ID "5031";      SetMessage -ID "5071";      SetMessage -ID "6023";      SetMessage -ID "6038";      SetMessage -ID "603A";      SetMessage -ID "603D"
        SetMessage -ID "6079" -All; SetMessage -ID "704E" -All; SetMessage -ID "704F"; SetMessage -ID "7050";      SetMessage -ID "7054"; SetMessage -ID "705A";      SetMessage -ID "705B";      SetMessage -ID "705E";      SetMessage -ID "7067";      SetMessage -ID "706D";      SetMessage -ID "706F"
        SetMessage -ID "7070";      SetMessage -ID "7075";      SetMessage -ID "707A"; SetMessage -ID "7084";      SetMessage -ID "7093"; SetMessage -ID "7095";      SetMessage -ID "70CD" -All; SetMessage -ID "70CF";      SetMessage -ID "70D1";      SetMessage -ID "70D4"
        SetMessage -ID "70D7";      SetMessage -ID "70E0";      SetMessage -ID "70E6"; SetMessage -ID "70F4";     SetMessage -ID "71A8";  SetMessage -ID "71AA";      SetMessage -ID "71AB";      SetMessage -ID "71AC";      SetMessage -ID "70DC" -Text "0F" -Replace $Redux.Text.LinkName.Text.ToUpper()
    }

    if ( (IsDefault $Redux.Text.NaviScript -Not) -and (IsDefault $Redux.Text.NaviName -Not) -and $Redux.Text.NaviName.Text.Count -gt 0) {
        if ($Redux.Text.NaviScript -ne $null) { SetMessage -ID "1000" -ASCII -Text "Navi" -Replace ($Redux.Text.NaviName.Text -replace "Тдтп", "Tatl"); SetMessage -ID "1015"; SetMessage -ID "1017" -All; SetMessage -ID "102A" -All; SetMessage -ID "103F" -All; SetMessage -ID "1099" -All; SetMessage -ID "109A" -All }
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

    if (IsChecked $Redux.Text.GoldSkulltula) {
        ChangeBytes -Offset "EC68CF" -Values "00"; ChangeBytes -Offset "EC69BF" -Values "00"; ChangeBytes -Offset "EC6A2B" -Values "00"; ChangeBytes -Offset "EC6A1C" -Values "14"
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

    if (IsChecked $Redux.Capacity.EnableAmmo -Lang 1) {
        if (StrLike -Str $GamePatch.settings -Val "Master of Time")   { $arrow3 = "99" }   else                                                              { $arrow3 = "50" }
        if (StrLike -Str $GamePatch.settings -Val "Gold Quest")       { $bomb1  = "10" }   elseif (StrLike -Str $GamePatch.settings -Val "Master of Time")   { $bomb1  = "15" }   else   { $bomb1 = "20" }
        if (StrLike -Str $GamePatch.settings -Val "Gold Quest")       { $bomb3  = "50" }   elseif (StrLike -Str $GamePatch.settings -Val "Master of Time")   { $bomb3  = "99" }   else   { $bomb3 = "40" }
        if (StrLike -Str $GamePatch.settings -Val "Master of Time")   { $nut3   = "99" }   else                                                              { $nut3   = "40" }

            SetMessage -ID "0056" -ASCII -Text "40"   -Replace $Redux.Capacity.Quiver2.text;     SetMessage -ID "0057" -ASCII -Text $arrow3 -Replace $Redux.Capacity.Quiver3.text
            SetMessage -ID "0058" -ASCII -Text $bomb1 -Replace $Redux.Capacity.BombBag1.text;    SetMessage -ID "0059" -ASCII -Text "30"    -Replace $Redux.Capacity.BombBag2.text;    SetMessage -ID "005A" -ASCII -Text $bomb3 -Replace $Redux.Capacity.BombBag3.text
            SetMessage -ID "00A7" -ASCII -Text "30"   -Replace $Redux.Capacity.DekuNuts2.text;   SetMessage -ID "00A8" -ASCII -Text $nut3   -Replace $Redux.Capacity.DekuNuts3.text

        if ($GamePatch.settings -ne "Master of Time") {
            SetMessage -ID "0007" -ASCII -Text "40"   -Replace $Redux.Capacity.BulletBag2.text;  SetMessage -ID "006C" -ASCII -Text "50"    -Replace $Redux.Capacity.BulletBag3.text
            SetMessage -ID "0037" -ASCII -Text "10"   -Replace $Redux.Capacity.DekuSticks1.text; SetMessage -ID "0090" -ASCII -Text "20"    -Replace $Redux.Capacity.DekuSticks2.text; SetMessage -ID "0091" -ASCII -Text "30"   -Replace $Redux.Capacity.DekuSticks3.text
        }
    }

    if (IsChecked $Redux.Capacity.EnableWallet) {
        if (StrLike -Str $GamePatch.settings -Val "Master of Time")   { $wallet2 = "250" } else { $wallet2 = "200" }
        if ($GamePatch.base -ne 1)                                    { $wallet3 = "999" } else { $wallet3 = "500" }
        SetMessage -ID "005E" -ASCII -Text $wallet2 -Replace $Redux.Capacity.Wallet2.Text; SetMessage -ID "005F" -ASCII -Text $wallet3 -Replace $Redux.Capacity.Wallet3.Text
    }

    if (IsChecked $Redux.Text.Milk               -Lang 1)   { SetMessage -ID "0098" -Text "Lon Lon Milk"     -Replace "Milk"                                  }
    if (IsChecked $Redux.Equipment.HerosBow      -Lang 1)   { SetMessage -ID "0031" -Text "Fairy Bow"        -Replace "Hero's Bow"                            }
    if (IsChecked $Redux.Equipment.PowerBracelet -Lang 1)   { SetMessage -ID "0079" -Text "Goron's Bracelet" -Replace "Power Bracelet"; SetMessage -ID "300C" }

    if (IsDefault $Redux.Equipment.KokiriSword -Not) {
        $file = $GameFiles.textures + "\Equipment\Kokiri Sword\" + $Redux.Equipment.KokiriSword.text + "." + $LanguagePatch.code + ".txt"
        if (TestFile $file) {
            $replace = Get-Content -Path $file
            if ($replace.length -gt 0) { SetMessage -ID "00A4" -ASCII -Text "Kokiri Sword" -Replace $replace; SetMessage -ID "10D2" }
        }
    }

    if (IsDefault $Redux.Equipment.MasterSword -Not -Lang 1) {
        $file = $GameFiles.textures + "\Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text + "." + $LanguagePatch.code + ".txt"
        if (TestFile $file) {
            if ($replace.length -gt 0) { SetMessage -ID "600C" -ASCII -Text "Master Sword" -Replace (Get-Content -Path $file); SetMessage -ID "704F"; SetMessage -ID "7051"; SetMessage -ID "7059"; SetMessage -ID "706D"; SetMessage -ID "7075"; SetMessage -ID "7081"; SetMessage -ID "7088"; SetMessage -ID "7091"; SetMessage -ID "70E8" }
        }
    }

    if (IsDefault $Redux.Equipment.GiantsKnife -Not -Lang 1) {
        $file = $GameFiles.textures + "\Equipment\Master Knife\" + $Redux.Equipment.GiantsKnife.text + "." + $LanguagePatch.code + ".txt"
        if (TestFile $file) {
            if ($replace.length -gt 0) { SetMessage -ID "000B" -ASCII -Text "Giant's Knife" -Replace (Get-Content -Path $file); SetMessage -ID "004B" }
        }
    }

    if (IsDefault $Redux.Equipment.BiggoronSword -Not -Lang 1) {
        $file = $GameFiles.textures + "\Equipment\Maste Sword\" + $Redux.Equipment.BiggoronSword.text + "." + $LanguagePatch.code + ".txt"
        if (TestFile $file) {
            if ($replace.length -gt 0) { SetMessage -ID "000A" -ASCII -Text "Biggoron's Sword" -Replace (Get-Content -Path $file); SetMessage -ID "000B"; SetMessage -ID "000C"; SetMessage -ID "0404" }
        }
    }

    if ( (IsDefault $Redux.Equipment.DekuShield -Not -Lang 1) -and $GamePatch.LoadedModel["Child"].deku_shield -ne 0) {
        $file = $GameFiles.textures + "\Equipment\Deku Shield\" + $Redux.Equipment.DekuShield.text + "." + $LanguagePatch.code + ".txt"
        if (TestFile $file) {
            if ($replace.length -gt 0) { SetMessage -ID "004C" -ASCII -Text "Deku Shield" -Replace (Get-Content -Path $file); SetMessage -ID "0089"; SetMessage -ID "009F"; SetMessage -ID "0611"; SetMessage -ID "103D"-Last; SetMessage -ID "1052"; SetMessage -ID "10CB"; SetMessage -ID "10D2" }
        }
    }

    if ( (IsDefault $Redux.Equipment.HylianShield -Not -Lang 1) -and $GamePatch.LoadedModel["Child"].hylian_shield -ne 0 -and $GamePatch.LoadedModel["Adult"].hylian_shield -ne 0) {
        $file = $GameFiles.textures + "\Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + "." + $LanguagePatch.code + ".txt"
        if (TestFile $file) {
            if ($replace.length -gt 0) { SetMessage -ID "004D" -ASCII -Text "Hylian Shield" -Replace (Get-Content -Path $file); SetMessage -ID "0092"; SetMessage -ID "009C"; SetMessage -ID "00A9"; SetMessage -ID "7013"; SetMessage -ID "7121" }
        }
    }

    if (IsChecked $Redux.Text.Instant) {
        WriteToConsole "Starting Generating Instant Text"
        if ($Files.json.textEditor -eq $null) { LoadTextEditor }
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

            SetMessage -ID $h.name -Text @(8)                             -Silent -All    # Remove all <DI>
            SetMessage -ID $h.name -Text @(9)                             -Silent -All    # Remove all <DC>
            SetMessage -ID $h.name -Text @(20, 0)                         -Silent -All    # Remove all <Wait:00>
            SetMessage -ID $h.name -Text @(20, 1)                         -Silent -All    # Remove all <Wait:01>
            SetMessage -ID $h.name -Text @(20, 2)                         -Silent -All    # Remove all <Wait:02>
            SetMessage -ID $h.name                  -Replace @(8)         -Silent -Insert # Insert <DI> to start
            SetMessage -ID $h.name -Text @(4)       -Replace @(4,  8)     -Silent -All    # Add <DI> after <New Box>
            SetMessage -ID $h.name -Text @(12, 10)  -Replace @(12, 10, 8) -Silent -All    # Add <DI> after <Delay:0A>
            SetMessage -ID $h.name -Text @(12, 20)  -Replace @(12, 20, 8) -Silent -All    # Add <DI> after <Delay:14>
            SetMessage -ID $h.name -Text @(12, 30)  -Replace @(12, 30, 8) -Silent -All    # Add <DI> after <Delay:1E>
            SetMessage -ID $h.name -Text @(12, 40)  -Replace @(12, 40, 8) -Silent -All    # Add <DI> after <Delay:28>
            SetMessage -ID $h.name -Text @(12, 60)  -Replace @(12, 60, 8) -Silent -All    # Add <DI> after <Delay:3C>
            SetMessage -ID $h.name -Text @(12, 70)  -Replace @(12, 70, 8) -Silent -All    # Add <DI> after <Delay:46>
            SetMessage -ID $h.name -Text @(12, 80)  -Replace @(12, 80, 8) -Silent -All    # Add <DI> after <Delay:50>
            SetMessage -ID $h.name -Text @(12, 90)  -Replace @(12, 90, 8) -Silent -All    # Add <DI> after <Delay:5A>
        }
        WriteToConsole "Finished Generating Instant Text"
    }

}



#==============================================================================================================================================================================================
function AdjustGUI() {
    
    EnableElem -Elem @($Redux.Unlock.DekuSticks, $Redux.UI.ButtonPositions) -Active (!$Patches.Redux.Checked)

    if ($Patches.Redux.Checked) {
        EnableElem -Elem $Redux.Colors.RupeesVanilla -Active (!$Redux.Hooks.RupeeIconColors.Checked)
        EnableElem -Elem $Redux.Box.TextColors       -Active (!$Redux.Graphics.GCScheme.Checked)
    }

    if ($Patches.Redux.Checked -and $Redux.UI.ButtonPositions -ne $null -and $Redux.Misc.OptionsMenu -ne $null) {
        if ($Redux.UI.ButtonPositions.Checked -and $Redux.Misc.OptionsMenu.SelectedIndex -ne 0) {
            $Redux.UI.ButtonPositions.Checked     = $False
            $Redux.Misc.OptionsMenu.SelectedIndex = 0
        }
        EnableElem -Elem $Redux.Misc.OptionsMenu   -Active (!$Redux.UI.ButtonPositions.checked)
        EnableElem -Elem $Redux.UI.ButtonPositions -Active ($Redux.Misc.OptionsMenu.SelectedIndex -eq 0)
    }

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    if ($Settings.Core.Lite)   { CreateOptionsPanel -Tabs @("Main", "Graphics", "Audio", "Difficulty",           "Equipment", "Capacity",               "Redux", "Language") }
    else                       { CreateOptionsPanel -Tabs @("Main", "Graphics", "Audio", "Difficulty", "Colors", "Equipment", "Capacity", "Animations", "Redux", "Language") }
    ChangeModelsSelection

}



#==============================================================================================================================================================================================
function CreateOptionsPreviews() {
    
    if ($GamePatch.models -ne 0) {
        CreatePreviewGroup -Text "Model Previews" -Height 8
        CreateImageBox -X 20  -Y 20 -W 154 -H 220 -Child -Name "Child"
        CreateImageBox -X 210 -Y 20 -W 154 -H 220 -Adult -Name "Adult"
        $global:PreviewToolTip = CreateToolTip
    }



    # STYLE PREVIEWS #

    if (!$Settings.Core.Lite) {
        CreatePreviewGroup -Text "Style Previews" -Height 9
        CreateImageBox -X 20  -Y 20  -W 163 -H 138 -Name "RegularChests"; $Redux.Styles.RegularChests.Add_SelectedIndexChanged( { ShowStylePreview } )
        CreateImageBox -X 200 -Y 20  -W 163 -H 138 -Name "BossChests";    $Redux.Styles.BossChests.Add_SelectedIndexChanged(    { ShowStylePreview } )
        CreateImageBox -X 20  -Y 170 -W 110 -H 110 -Name "SmallCrates";   $Redux.Styles.SmallCrates.Add_SelectedIndexChanged(   { ShowStylePreview } )
        CreateImageBox -X 200 -Y 170 -W 110 -H 110 -Name "Pots";          $Redux.Styles.Pots.Add_SelectedIndexChanged(          { ShowStylePreview } )
        ShowStylePreview
    }



    # HUD & MISC PREVIEWS #

    CreatePreviewGroup -Text "HUD Previews" -Height 5
    CreateImageBox -X 20  -Y 20  -W 90  -H 90 -Name "ButtonStyle";  $Redux.UI.ButtonStyle.Add_SelectedIndexChanged(  { ShowHUDPreview -IsOoT } )
    CreateImageBox -X 120 -Y 20  -W 200 -H 40 -Name "Magic";        $Redux.UI.Magic.Add_SelectedIndexChanged(        { ShowHUDPreview -IsOoT } )
    CreateImageBox -X 160 -Y 70  -W 40  -H 40 -Name "Hearts";       $Redux.UI.Hearts.Add_SelectedIndexChanged(       { ShowHUDPreview -IsOoT } )
    CreateImageBox -X 210 -Y 70  -W 40  -H 40 -Name "Rupees";       $Redux.UI.Rupees.Add_SelectedIndexChanged(       { ShowHUDPreview -IsOoT } )
    CreateImageBox -X 260 -Y 70  -W 40  -H 40 -Name "DungeonKeys";  $Redux.UI.DungeonKeys.Add_CheckStateChanged(     { ShowHUDPreview -IsOoT } )
    CreateImageBox -X 160 -Y 120 -W 40  -H 40 -Name "CurrentFloor"; $Redux.UI.CurrentFloor.Add_SelectedIndexChanged( { ShowHUDPreview -IsOoT } )
    CreateImageBox -X 210 -Y 120 -W 40  -H 40 -Name "BossFloor";    $Redux.UI.BossFloor.Add_SelectedIndexChanged(    { ShowHUDPreview -IsOoT } )
    
    CreatePreviewGroup -Text "Misc Previews" -Height 3
    CreateImageBox -X 20  -Y 20  -W 80 -H 80 -Name "ImprovedMoon"; $Redux.Graphics.ImprovedMoon.Add_CheckStateChanged( { ShowHUDPreview -IsOoT } )

    ShowHUDPreview -IsOoT



    # EQUIPMENT PREVIEWS #

    CreatePreviewGroup -Text "Equipment Previews" -Height 9
    CreateImageBox -X 20  -Y 40  -W 80 -H 80  -Child -Name "DekuShieldIcon"
    CreateImageBox -X 110 -Y 20  -W 80 -H 120 -Child -Name "DekuShield";      if ($Redux.Equipment.DekuShield   -ne $null)   { $Redux.Equipment.DekuShield.Add_SelectedIndexChanged(   { ShowEquipmentPreview } ) }
    CreateImageBox -X 200 -Y 40  -W 80 -H 80         -Name "HylianShieldIcon"
    CreateImageBox -X 290 -Y 20  -W 80 -H 120        -Name "HylianShield";    if ($Redux.Equipment.HylianShield -ne $null)   { $Redux.Equipment.HylianShield.Add_SelectedIndexChanged( { ShowEquipmentPreview } ) }
    CreateImageBox -X 20  -Y 180 -W 80 -H 80  -Adult -Name "MirrorShieldIcon"
    CreateImageBox -X 110 -Y 160 -W 80 -H 120 -Adult -Name "MirrorShield";    if ($Redux.Equipment.MirrorShield -ne $null)   { $Redux.Equipment.MirrorShield.Add_SelectedIndexChanged( { ShowEquipmentPreview } ) }
    CreateImageBox -X 200 -Y 180 -W 80 -H 80  -Child -Name "KokiriSwordIcon"; if ($Redux.Equipment.KokiriSword  -ne $null)   { $Redux.Equipment.KokiriSword.Add_SelectedIndexChanged(  { ShowEquipmentPreview } ) }
    CreateImageBox -X 290 -Y 180 -W 80 -H 80  -Adult -Name "MasterSwordIcon"; if ($Redux.Equipment.MasterSword  -ne $null)   { $Redux.Equipment.MasterSword.Add_SelectedIndexChanged(  { ShowEquipmentPreview } ) }
    ShowEquipmentPreview

}



#==============================================================================================================================================================================================
function CreatePresets() {
    
    if ($GamePatch.presets -eq 0) { return }



    # PRESETS #

    CreateReduxGroup -Tag  "Presets" -Text "Presets"
    
    $Reset         = CreateReduxButton -Width 150 -Text "Reset Options"
    $QualityOfLife = CreateReduxButton -Width 150 -Text "Quality of Life"
    $OptimalRedux  = CreateReduxButton -Width 150 -Text "Optimal Redux"
    $HeroMode      = CreateReduxButton -Width 150 -Text "Hero Mode"

    if ($GamePatch.models -ne 0) {
        $VanillaModels = CreateReduxButton -Width 150 -Text "Original Link" -Column 2
        $MajoraModels  = CreateReduxButton -Width 150 -Text "Majora's Mask Link"
        $FemaleModels  = CreateReduxButton -Width 150 -Text "Female Link"

        $VanillaModels.Add_Click( { $Redux.Graphics.ChildModels.SelectedIndex =                  $Redux.Graphics.AdultModels.SelectedIndex = 0                  ; BoxUncheck $Redux.Text.FemalePronouns; $Redux.Sounds.ChildVoices.SelectedIndex = $Redux.Sounds.AdultVoices.SelectedIndex = 0       } )
        $MajoraModels.Add_Click(  { $Redux.Graphics.ChildModels.Text          = "Majora's Mask"; $Redux.Graphics.AdultModels.Text          = "Original"         ; BoxUncheck $Redux.Text.FemalePronouns; $Redux.Sounds.ChildVoices.SelectedIndex = $Redux.Sounds.AdultVoices.SelectedIndex = 0       } )
        $FemaleModels.Add_Click(  { $Redux.Graphics.ChildModels.Text          =                  $Redux.Graphics.AdultModels.Text          = "Hatsune Miku Link"; BoxCheck   $Redux.Text.FemalePronouns; $Redux.Sounds.ChildVoices.Text          = $Redux.Sounds.AdultVoices.Text          = "Amara" } )
    }

    $Reset.Add_Click( { ResetGame } )

    $QualityOfLife.Add_Click( {
        if ($Redux.Gameplay.FasterBlockPushing -ne $null)   { $Redux.Gameplay.FasterBlockPushing.SelectedIndex = 1 }
        if ($Redux.Gameplay.RemoveOwls         -ne $null)   { $Redux.Gameplay.RemoveOwls.SelectedIndex         = 1 }
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
        BoxCheck $Redux.Fixes.GerudosFortress
        BoxCheck $Redux.Fixes.AlwaysMoveKingZora
        BoxCheck $Redux.Fixes.DeathMountainOwl
        BoxCheck $Redux.Fixes.RemoveFishingPiracy
        BoxCheck $Redux.Fixes.Boomerang

        BoxCheck $Redux.Graphics.ExtendedDraw
        BoxCheck $Redux.Graphics.ForceHiresModel
        BoxCheck $Redux.Graphics.HideDungeonIcon

        BoxCheck $Redux.Minigames.LessDemandingFishing
        BoxCheck $Redux.Minigames.GuaranteedFishing

        foreach ($option in $Redux.NativeOptions) {
            if ($option.Label -eq "16:9 Widescreen (Advanced)") {
                if ($Redux.NativeOptions[0].hidden) { BoxCheck $Redux.Graphics.WidescreenAlt } else { BoxCheck $Redux.Graphics.Widescreen }
                break
            }
        }
        
        if ($Redux.Text.Speed2x             -ne $null)   { if ($Redux.Text.Speed2x.Enabled)                { BoxCheck $Redux.Text.Speed2x             } }
        if ($Redux.Text.Restore             -ne $null)   { if ($Redux.Text.Restore.Enabled)                { BoxCheck $Redux.Text.Restore             } }
        if ($Redux.Text.GoldSkulltula       -ne $null)   { if ($Redux.Text.GoldSkulltula.Enabled)          { BoxCheck $Redux.Text.GoldSkulltula       } }
        if ($Redux.Text.EasterEggs          -ne $null)   { if ($Redux.Text.EasterEggs.Enabled)             { BoxCheck $Redux.Text.EasterEggs          } }
        if ($Redux.Fixes.Graves             -ne $null)   { if ($Redux.Fixes.Graves.Enabled)                { BoxCheck $Redux.Fixes.Graves             } }
        if ($Redux.Fixes.TimeDoor           -ne $null)   { if ($Redux.Fixes.CorrectTimeDoor.Enabled)       { BoxCheck $Redux.Fixes.TimeDoor           } }
        if ($Redux.Fixes.ChildColossusFairy -ne $null)   { if ($Redux.Fixes.ChildColossusFairy.Enabled)    { BoxCheck $Redux.Fixes.ChildColossusFairy } }
        if ($Redux.Fixes.CraterFairy        -ne $null)   { if ($Redux.Fixes.CraterFairy.Enabled)           { BoxCheck $Redux.Fixes.CraterFairy        } }
    } )

    $OptimalRedux.Add_Click( {
        BoxCheck $Redux.Misc.BombchuDrops
        BoxCheck $Redux.Hooks.RupeeIconColors
        BoxCheck $Redux.Hooks.EmptyBombFix
        BoxCheck $Redux.Hooks.ShowFileSelectIcons
        BoxCheck $Redux.Hooks.StoneOfAgony
        BoxCheck $Redux.Hooks.BiggoronFix
        BoxCheck $Redux.Hooks.DampeFix
        BoxCheck $Redux.Hooks.HyruleGuardsSoftlock
    } )

    $HeroMode.Add_Click( {
        $Redux.Hero.MonsterHP.SelectedIndex  = 4
        $Redux.Hero.MiniBossHp.SelectedIndex = 4
        $Redux.Hero.BossHP.SelectedIndex     = 4
        $Redux.Hero.Damage.SelectedIndex     = 1
        $Redux.Hero.ItemDrops.Text           = "No Hearts"
        
        BoxCheck $Redux.Hero.GraveyardKeese
        BoxCheck $Redux.Hero.LostWoodsOctorok
        BoxCheck $Redux.Hero.NoBottledFairy

        BoxCheck $Redux.Hero.GohmaLarve
        BoxCheck $Redux.Hero.Skulltula
        BoxCheck $Redux.Hero.Keese
        BoxCheck $Redux.Hero.Wolfos
        BoxCheck $Redux.Hero.Lizalfos
        BoxCheck $Redux.Hero.Stalfos
        BoxCheck $Redux.Hero.FlareDancer
        BoxCheck $Redux.Hero.DarkLink
        BoxCheck $Redux.Hero.DeadHand
        BoxCheck $Redux.Hero.GerudoFighter
        BoxCheck $Redux.Hero.IronKnuckle
        BoxCheck $Redux.Hero.Gohma
        BoxCheck $Redux.Hero.KingDodongo
        BoxCheck $Redux.Hero.Barinade

        if ($Redux.MQ.Dungeons -ne $null)   { $Redux.MQ.Dungeons.Text = "Master Quest" }
        if ($Redux.MQ.Logo     -ne $null)   { $Redux.MQ.Logo.Text     = "Master Quest" }
    } )

}



#==============================================================================================================================================================================================
function CreateTabMain() {
    
    CreatePresets



    # QUALITY OF LIFE #
    
    CreateReduxGroup    -Tag  "Gameplay"                             -Text "Quality of Life" 
    CreateReduxComboBox -Name "FasterBlockPushing"   -Exclude "Gold" -Text "Faster Block Pushing"   -Info "All blocks are pushed faster" -Items @("Disabled", "Exclude Time-Based Puzzles", "Fully Enabled")                                                  -TrueDefault 1 -Default 3 -Credits "GhostlyDark (Randomizer)"
    CreateReduxComboBox -Name "RemoveOwls"                    -Scene -Text "Remove Owls"            -Info "Kaepora Gaebora the owl will no longer interrupt Link with tutorials" -Items @("Disabled", "Exclude Shortcuts", "Fully Enabled")                                             -Credits "Admentus & GoldenMariaNova"
    CreateReduxCheckBox -Name "NoKillFlash"                          -Text "No Kill Flash"          -Info "Disable the flash effect when killing certain enemies such as the Guay or Skullwalltula"                                                                                     -Credits "Chez Cousteau"
    CreateReduxCheckBox -Name "RemoveNaviTimer"                      -Text "Remove Navi Timer"      -Info "Navi will no longer pop up with text messages during gameplay`nDoes not apply to location-triggered messages"                                                                -Credits "Admentus"
    CreateReduxCheckBox -Name "ResumeLastArea"       -Exclude "Dawn" -Text "Resume From Last Area"  -Info "Resume playing from the area you last saved in"                                                                                             -Warning "Don't save in Grottos" -Credits "Admentus (ROM) & Aegiker (RAM)"
    CreateReduxCheckBox -Name "InstantClaimCheck"    -Base 4 -Adult  -Text "Instant Claim Check"    -Info "Remove the check for waiting until the Biggoron Sword can be claimed through the Claim Check"                                                                                -Credits "Randomizer"
    CreateReduxCheckBox -Name "ReturnChild"          -Base 4 -Adult  -Text "Can Always Return"      -Info "You can always go back to being a child again before clearing the boss of the Forest Temple`nOut of the way Sheik!"                                                          -Credits "Randomizer"
    CreateReduxCheckBox -Name "AllowWarpSongs"       -Base 4         -Text "Allow Warp Songs"       -Info "Allow warp songs in Gerudo Training Ground and Ganon's Castle"                                                                                                               -Credits "Randomizer"
    CreateReduxCheckBox -Name "AllowFaroreWind"      -Base 4         -Text "Allow Farore's Wind"    -Info "Allow Farore's Wind in Gerudo Training Ground and Ganon's Castle"                                                                                                            -Credits "Randomizer"
    CreateReduxCheckBox -Name "AllowOcarina"         -Base 4         -Text "Allow Ocarina"          -Info "Allow playing the Ocarina in Granny's Potion Shop, Bombchu Bowling Alley and Archery Ranges"                                                                                 -Credits "Randomizer"
    CreateReduxCheckBox -Name "FasterGoronTunic"     -Base 4 -Adult  -Text "Faster Goron Tunic"     -Info "You only need to select a single dialogue option instead of both for Link the Goron to obtain the Goron Tunic"                                                               -Credits "Randomizer"
    CreateReduxCheckBox -Name "RutoNeverDisappears"  -Base 4 -Child  -Text "Ruto Never Disappears"  -Info "Ruto never disappears in Jabu Jabu's Belly and will remain in place when leaving the room"                                                                                   -Credits "Randomizer"
    CreateReduxCheckBox -Name "Medallions"           -Base 4 -Adult  -Text "Require All Medallions" -Info "All six medallions are required for the Rainbow Bridge to appear before Ganon's Castle`nThe vanilla requirements were the Shadow and Spirit Medallions and the Light Arrows" -Credits "Randomizer"
    CreateReduxCheckBox -Name "OpenBombchuShop"      -Base 5         -Text "Open Bombchu Shop"      -Info "The Bombchu Shop is open right away without the need to defeat King Dodongo"                                                                                                 -Credits "Randomizer"
    CreateReduxCheckBox -Name "RemoveNaviPrompts"                    -Text "Remove Navi Prompts"    -Info "Navi will no longer interrupt you with tutorial text boxes in dungeons"                                                                                                      -Credits "Admentus"
    CreateReduxCheckBox -Name "RemoveDisruptiveText"          -Scene -Text "Remove Disruptive Text" -Info "Remove disruptive text from Gerudo Training Ground and early Shadow Temple"                                                                                                  -Credits "Admentus"
    


    # GAMEPLAY #

    CreateReduxGroup    -Tag  "Gameplay"                                   -Text "Gameplay Changes" 
    $items = @("Link's House", "Temple of Time", "Hyrule Field", "Kakariko Village", "Hyrule Castle", "Ganon's Castle", "Goron City", "Zora's Domain", "Gerudo Valley", "Lon Lon Ranch", "Inside the Deku Tree", "Dodongo's Cavern", "Inside Jabu-Jabu's Belly", "Forest Temple", "Fire Temple", "Water Temple", "Shadow Temple", "Spirit Temple", "Ice Cavern", "Bottom of the Well", "Thieves' Hideout", "Gerudo's Training Ground", "Inside Ganon's Castle", "Ganon's Tower")
    CreateReduxComboBox -Name "SpawnChild" -Safe -Base 4 -Child -Default 1 -Text "Child Starting Location"    -Items $items                                                                                                                                                          -Credits "Admentus & GhostlyDark"
    CreateReduxComboBox -Name "SpawnAdult" -Safe -Base 4 -Adult -Default 2 -Text "Adult Starting Location"    -Items $items                                                                                                                                                          -Credits "Admentus & GhostlyDark"
    CreateReduxCheckBox -Name "ManualJump"                                 -Text "Manual Jump"                -Info "Press Z + A to do a Manual Jump instead of a Jump Attack`nPress B mid-air after jumping to do a Jump Attack"                                                    -Credits "Admentus (ROM) & CloudModding (RAM)"
    CreateReduxCheckbox -Name "AltManualJump"                              -Text "Alt Manual Jump"            -Info "Press Z + A to do a Manual Jump instead of a Jump Attack`nPress B mid-air after jumping to do a Jump Attack`nThis version allows you still to roll when moving" -Credits "BilonFullHDemon" -Link $Redux.Gameplay.ManualJump
    CreateReduxCheckBox -Name "NoShieldRecoil"                             -Text "No Shield Recoil"           -Info "Disable the recoil when being hit while shielding"                                                                                                              -Credits "Admentus (ROM) & Aegiker (RAM)"
    CreateReduxCheckBox -Name "RunWhileShielding"                          -Text "Run While Shielding"        -Info "Press R to shield will no longer prevent Link from moving around" -Link $Redux.Gameplay.NoShieldRecoil                                                          -Credits "Admentus (ROM) & Aegiker (RAM)"
    CreateReduxCheckBox -Name "PushbackAttackingWalls"                     -Text "Pushback Attacking Walls"   -Info "Link is getting pushed back a bit when hitting the wall with the sword"                                                                                         -Credits "Admentus (ROM) & Aegiker (RAM)"
    CreateReduxCheckBox -Name "RemoveCrouchStab"                           -Text "Remove Crouch Stab"         -Info "The Crouch Stab move is removed"                                                                                                                                -Credits "Garo-Mastah"
    CreateReduxCheckBox -Name "RemoveQuickSpin"                            -Text "Remove Magic Quick Spin"    -Info "The magic Quick Spin Attack move is removed`nIt's a regular Quick Spin Attack now instead"                                                                      -Credits "Admentus & Three Pendants"
    CreateReduxCheckBox -Name "RunFaster"                                  -Text "Run Faster"                 -Info "Faster run speed & longer jumps"                                                                                                    -Credits "Admentus & Ikey Ilex"
    CreateReduxCheckbox -Name "RemoveSpeedClamp"                           -Text "Remove Jump Speed Limit"    -Info "Removes the jumping speed limit just like in MM"                                                                                                                -Credits "Admentus (ROM) & Aegiker (RAM)"
    CreateReduxCheckbox -Name "ChildShops"                          -Child -Text "Child Shops"                -Info "Open the Potion Shop and Bazaar in Kakariko Village for Child Link"                                                                                             -Credits "Admentus"
    CreateReduxCheckBox -Name "FastArrows"                                 -Text "Less Magic Arrows Cooldown" -Info "The burst animation for Fire, Ice and Light Arrows are shorter`nAllows Link to shoot the next magic arrow a bit quicker"                                        -Credits "Anthrogi"
    CreateReduxCheckBox -Name "FastCharge"                                 -Text "Instant Lv2 Magic Spin"     -Info "Allows you to perform the Red Magic Spin Attack immediately during charge"                                                                                      -Credits "Anthrogi"


    # GAMEPLAY (UNSTABLE) #

    CreateReduxGroup    -Tag  "Gameplay"                -Text "Gameplay Changes (Unstable)" 
    CreateReduxCheckBox -Name "HookshotAnything" -Adult -Text "Hookshot Anything"   -Info "Be able to hookshot most surfaces" -Warning "Prone to softlocks, be careful" -Credits "Randomizer"
    CreateReduxCheckBox -Name "ClimbAnything"           -Text "Climb Anything"      -Info "Climb most walls in the game"      -Warning "Prone to softlocks, be careful" -Credits "Randomizer"
    CreateReduxCheckBox -Name "DistantZTargeting"       -Text "Distant Z-Targeting" -Info "Allow to use Z-Targeting on enemies, objects and NPC's from any distance"    -Credits "Admentus"



    # RESTORE #

    CreateReduxGroup    -Tag  "Restore"                  -Text "Restore / Correct / Censor"
    CreateReduxComboBox -Name "Blood"            -Base 3 -Text "Blood Color"           -Info "Change the color of blood used for several monsters, Ganondorf and Ganon`nSeveral monsters have blue or green blood, while Ganondorf/Ganon has red blood" -Items @("Default", "Red blood for monsters", "Green blood for Ganondorf/Ganon", "Change both") -Credits "ShadowOne333 & Admentus"
    CreateReduxComboBox -Name "GerudoTextures"   -Safe   -Text "Gerudo Textures"       -Info "Censor Gerudo symbol textures as they were used in the GameCube ROMs and Virtual Console versions`nAlso remove the Gerudo Symbols in Dampe's Maze as it was done in the Gateway ROM version" -Items @("Disabled", "Only Remove Dampe", "Fix And Censor")  -Credits "GhostlyDark, ShadowOne333 and GoldenMariaNova"
    CreateReduxCheckBox -Name "Blood"            -Base 6 -Text "Red Blood"             -Info "Change the color of blood used for several monsters to red"                                                                                                                                                                                               -Credits "Admentus"
    CreateReduxCheckBox -Name "RupeeColors"              -Text "Correct Rupee Colors"  -Info "Corrects the color palette for the in-game Purple (50) and Golden (200) Rupees`nIn the base game they are closer to pink and orange, this changes them to more closely match their 3D get item models"                                                    -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "CowNoseRing"              -Text "Restore Cow Nose Ring" -Info "Restore the rings in the noses for Cows as seen in the Japanese release"                                                                                                                                                                                  -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "CenterTextboxCursor"      -Text "Center Textbox Cursor" -Info "Aligns the textbox cursor to the center of the screen"                                                                                                                                                                                                    -Credits "BilonFullHDemon"
    CreateReduxCheckBox -Name "N64Logo"         	     -Text "Restore N64 Logo"  	   -Info "Fixes the appearance of the N64 intro logo as seen in the Rev 1 ROM and newer"                                                                                                                                                                            -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "FireTemple" -Safe -Base 3 -Text "Censor Fire Temple"    -Info "Censor Fire Temple theme as used in the Rev 2 ROM"                                                                                                                                                                                                        -Credits "ShadowOne333" 




    # FIXES #

    CreateReduxGroup    -Tag  "Fixes"                                    -Text "Fixes"
    CreateReduxCheckBox -Name "MagicMeter"                -Base 5        -Text "Magic Meter Fix"           -Info "Prevent fill texture from fetching garbage to avoid HD texture duplicates"                                                          -Checked -Credits "Admentus & GhostlyDark"
    CreateReduxCheckBox -Name "BuyableBombs"              -Base 5        -Text "Buyable Bombs"             -Info "You no longer need the Goron's Ruby before you can buy bombs`nOnly the Bomb Bag is required"                                                 -Credits "Admentus"
    CreateReduxCheckBox -Name "PauseScreenDelay"          -Base 5        -Text "Pause Screen Delay"        -Info "Removes the delay when opening the Pause Screen by removing the anti-aliasing"                                                       -Native -Checked -Credits "zel"
    CreateReduxCheckBox -Name "PauseScreenCrash"          -Base 5        -Text "Pause Screen Crash Fix"    -Info "Prevents the game from randomly crashing emulating a decompressed ROM upon pausing"                                                          -Checked -Credits "zel"
    CreateReduxCheckBox -Name "DodongoBombchuCrash"                      -Text "Dodongo Bombchu Crash Fix" -Info "Prevents the game from crashing when a Dodongo eats a Bombchu"                                                                               -Checked -Credits "Admentus"
    CreateReduxCheckBox -Name "WhiteBubbleCrash"                         -Text "White Bubble Crash Fix"    -Info "Prevents the game from crashing when using Din's Fire on White Bubbles"                                                                      -Checked -Credits "Randomizer"
    CreateReduxCheckBox -Name "PoacherSaw"                -Base 4 -Adult -Text "Poacher's Saw"             -Info "Obtaining the Poacher's Saw no longer prevents Link from obtaining the second Deku Nut upgrade"                                              -Checked -Credits "Randomizer"
    CreateReduxCheckBox -Name "GerudosFortress"           -Base 4 -Child -Text "Gerudo's Fortress Fixes"   -Info "Display the complete minimap and fix the Piece of Heart Chest for Gerudo's Fortress during the Child era"                                             -Credits "Admentus & GhostlyDark"
    CreateReduxCheckBox -Name "AlwaysMoveKingZora"        -Base 4 -Child -Text "Always Move King Zora"     -Info "King Zora will move aside even if the Zora Sapphire is in possession"                                                                                 -Credits "Randomizer"
    CreateReduxCheckBox -Name "DeathMountainOwl"          -Base 4 -Child -Text "Death Mountain Owl"        -Info "The Owl on top of the Death Mountain will always carry down Link regardless of having magic"                                                          -Credits "Randomizer"
    CreateReduxCheckBox -Name "RemoveFishingPiracy"       -Base 4        -Text "Remove Fishing DRM"        -Info "Removes the anti-piracy check for fishing that can cause the fish to always let go after 51 frames"                                                   -Checked -Credits "Randomizer"
    CreateReduxCheckBox -Name "Boomerang"                 -Child         -Text "Boomerang"                 -Info "Fix the gem color on the thrown boomerang"                                                                                            -Exclude "Dawn" -Credits "Aria Hiroshi 64"
    CreateReduxCheckBox -Name "VisibleGerudoTent"         -Base 4 -Child -Text "Visible Gerudo Tent"       -Info "Make the tent in Gerudo Valley during the Child era visible`nThe tent was always accessible, just invisible"                                          -Credits "Admentus"
    CreateReduxCheckBox -Name "Graves"                            -Scene -Text "Graveyard Graves"          -Info "The grave holes in Kakariko Graveyard behave as in the Rev 1 revision`nThe edges no longer force Link to grab or jump over them when trying to enter" -Credits "Admentus"
    CreateReduxCheckBox -Name "TimeDoor"                          -Scene -Text "Fix Door of Time"          -Info "Fix the positioning of the Temple of Time door, so you can not skip past it`nAlso fixes a bug where the door doesn't open on your first visit"        -Credits "Admentus & Randomizer"
    $text = "Fix issues in Dodogono's Cavern, Water Temple and Spirit Temple`n`n- Gossip Stones that won't spawn fairies (Dodongo's Cavern)`n- Unreachable hookshot spot (Raging Water Cavern)`n- Three out of bounds pots (Raging Water Cavern)`n- Restore two Keese (Central Hall)`n- Removes the non-functional Magic Jar atop the Statues in Gerudo Training Ground (Statues Challenge)"
    CreateReduxCheckBox -Name "Dungeons"                          -Scene -Text "Fix Dungeons"              -Info ($text + "`n- Navi targeting Spots in Fire Temple, Ice Cavern, Shadow Temple and Spirit Temple" )                                                      -Credits "Admentus, ZethN64, Sakura, Frostclaw, Steve(ToCoool), GoldenMariaNova & GhostlyDark (ported)"
    CreateReduxCheckBox -Name "GreatFairyTextBoxes"               -Scene -Text "Fix Great Fairy Textboxes" -Info "Fix the broken textboxes outside the Great Fairy entrances in Death Mountain Crater and Desert Colossus"                                              -Credits "Admentus"


    # OTHER #

    CreateReduxGroup    -Tag  "Other"                     -Text "Other"
    $text = "Translates the Item Selelect and Map Select menus`nEnable the Map Select menu like in the Debug ROM`nThe File Select menu now opens the Map Select menu instead`nA separate debug save file is used"
    CreateReduxComboBox -Name "Select"                    -Text "Item/Map Select" -Items @("Disable", "Translate Only", "Enable Map Select Only", "Translate and Enable Map Select")                          -Info $text -Credits "GhostlyDark, Jared Johnson & Zelda Edit"
    CreateReduxComboBox -Name "SkipIntro" -Exclude "Gold" -Text "Skip Intro"  -Default 1 -Items @("Don't Skip", "Skip Logo", "Skip Title Screen", "Skip Logo and Title Screen")                               -Info "Skip the logo, title screen or both"           -Credits "Aegiker"
    CreateReduxComboBox -Name "SkipIntro" -Expose  "Gold" -Text "Skip Intro"  -Default 2 -Items @("Don't Skip", "Skip Logo", "Skip Title Screen", "Skip Logo and Title Screen")                               -Info "Skip the logo, title screen or both"           -Credits "Aegiker"
    CreateReduxComboBox -Name "Skybox"    -Exclude "Gold" -Text "Skybox"      -Default 4 -Items @("Dawn", "Day", "Dusk", "Night", "Darkness (Dawn)", "Darkness (Day)", "Darkness (Dusk)", "Darkness (Night)") -Info "Set the skybox theme for the File Select menu" -Credits "Admentus"
    CreateReduxComboBox -Name "Skybox"    -Expose  "Gold" -Text "Skybox"      -Default 3 -Items @("Dawn", "Day", "Dusk", "Night", "Darkness (Dawn)", "Darkness (Day)", "Darkness (Dusk)", "Darkness (Night)") -Info "Set the skybox theme for the File Select menu" -Credits "Admentus"
    CreateReduxCheckBox -Name "DefaultZTargeting"         -Text "Default Hold Z-Targeting" -Info "Change the Default Z-Targeting option to Hold instead of Switch"                                                                                                  -Credits "Randomizer"
    CreateReduxCheckBox -Name "DiskDrive" -Exclude "Dawn" -Text "Enable Disk Drive Saves"  -Info "Use the Disk Drive for Save Slots" -Warning "This option disables the use of non-Disk Drive save slots"                                                           -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool) & GhostlyDark (ported)"

}



#==============================================================================================================================================================================================
function CreateTabRedux() {
    
    # MISC #

    CreateReduxGroup    -Tag  "Misc"                                                -Text "Misc Options"
    CreateReduxComboBox -Name "OptionsMenu"   -Default 4                            -Text "Options Menu"    -Items @("Disable", "Core Only", "Essentials", "Fully Enabled") -Info "Adjust how much of the Redux options are available ingame and can be used`nPress L in the Pause Screen to toggle the ingame options menu" -Credits "Admentus"
    CreateReduxComboBox -Name "SkipCutscenes" -Base 3                               -Text "Skip Cutscenes"  -Items @("Disabled", "Useful Cutscenes Excluded", "All")        -Info "Skip Cutscenes`nUseful Cutscenes Excluded keeps cutscenes intact which are useful for performing glitches`nRequires a new save to take effect" -Credits "Randomizer"
    CreateReduxCheckBox -Name "BombchuDrops"  -Exclude ("Dawn", "New Master Quest") -Text "Bombchu Drops"   -Info "Bombchus can now drop from defeated enemies, cutting grass and broken jars"                                                   -Credits "Randomizer"
    CreateReduxCheckBox -Name "BombchuDrops"  -Expose "New Master Quest"   -Checked -Text "Bombchu Drops"   -Info "Bombchus can now drop from defeated enemies, cutting grass and broken jars"                                                   -Credits "Randomizer"
    CreateReduxCheckBox -Name "TycoonWallet"                                        -Text "Tycoon's Wallet" -Info "You get the Tycoon's Wallet from one of the Gold Skulltula reward in addition`nOnly activated if you have the Giant's Wallet" -Credits "Admentus"



    # DEFAULT SETTINGS #

    CreateReduxGroup    -Tag  "Default"           -Text "Default Options Menu Settings"
    CreateReduxCheckBox -Name "FPS"               -Text "30 FPS"                                          -Info "Allows 30 FPS`nPress L and Z to toggle between 30 FPS and 20 FPS mode"
    CreateReduxCheckBox -Name "ArrowToggle"       -Text "Arrow Toggle"   -Checked                         -Info "Enables Arrow Toggle`nPress R while aiming to toggle arrow types"
    CreateReduxCheckBox -Name "ShowHealth"        -Text "Show Health"                                     -Info "Show the amount of health enemies have left in the HUD"
    CreateReduxCheckBox -Name "ChestContents"     -Text "Chest Contents"                                  -Info "Adjusts the appearance of the chest according to the contents it contains"
    CreateReduxCheckBox -Name "InverseAim"        -Text "Inverse Aim"                                     -Info "Inverse y-axis for analog controls when aiming in first-person view"
    CreateReduxCheckBox -Name "NoIdleCamera"      -Text "No Idle Camera"                                  -Info "The camera no longer moves behind Link during idle stance"
    CreateReduxCheckBox -Name "KeepMask"          -Text "Keep Mask"      -Checked                         -Info "Mask remains equipped upon entering another area"
    CreateReduxCheckBox -Name "TriSwipe"          -Text "Tri-Swipe"                                       -Info "Replaces the transition effect with a twirling Triforce animation"
    CreateReduxCheckBox -Name "SwapItem"          -Text "Swap Item"      -Checked                         -Info "Cycle with C-Up between obtained items you own"
    CreateReduxCheckBox -Name "UnequipGear"       -Text "Unequip Gear"   -Checked                         -Info "Unassign equipment by pressing A and items using the respective C button"
    CreateReduxCheckBox -Name "ItemOnB"           -Text "Item on B"                                       -Info "Assign items to the B button by pressing A"
    CreateReduxCheckBox -Name "MaskAbilities"     -Text "Mask Abilties"  -Checked                         -Info "Equipping masks grant abilities such as the Bunny Hood making Link run faster just like in Majora's Mask"
    CreateReduxCheckBox -Name "ExtraAbilities"    -Text "Extra Abilities"                                 -Info "Obtain Spiritual Stones and Medallions to earn new abilities"
    CreateReduxCheckBox -Name "RandomEnemies"     -Text "Random Enemies"                                  -Info "Multiplies the health and changes the subtype for regular enemies randomly"
    CreateReduxCheckBox -Name "CrouchStabFix"     -Text "Crouch Stab Fix"                                 -Info "The Crouch Stab move no longer keeps the last dealt damage"
    CreateReduxCheckBox -Name "WeakerSwords"      -Text "Weaker Swords"                                   -Info "Sword slashes now deal one less point of damage"
    CreateReduxCheckBox -Name "Levitation"        -Text "Levitation"                                      -Info "Hold the L button to levitate"
    CreateReduxCheckBox -Name "InfiniteHP"        -Text "Infinite HP"                                     -Info "Your Health is kept at the current maximum limit"
    CreateReduxCheckBox -Name "InfiniteMP"        -Text "Infinite MP"                                     -Info "Your Magic is kept at the current maximum limit"
    CreateReduxCheckBox -Name "InfiniteRupees"    -Text "Infinite Rupees"                                 -Info "Your Rupees is kept at the current maximum limit"
    CreateReduxCheckBox -Name "InfiniteAmmo"      -Text "Infinite Ammo"                                   -Info "Your Ammo is kept at the current maximum limit"
    CreateReduxTextBox  -Name "AButtonScale"      -Text "A Button Scale" -Value 0 -Min 0 -Max 2 -Length 1 -Info "Set the scale for the A button"
    CreateReduxTextBox  -Name "BButtonScale"      -Text "B Button Scale" -Value 0 -Min 0 -Max 7 -Length 1 -Info "Set the scale for the B button"
    CreateReduxTextBox  -Name "CLeftButtonScale"  -Text "C-Left Scale"   -Value 0 -Min 0 -Max 7 -Length 1 -Info "Set the scale for the C-Left button"
    CreateReduxTextBox  -Name "CDownButtonScale"  -Text "C-Down Scale"   -Value 0 -Min 0 -Max 7 -Length 1 -Info "Set the scale for the C-Down button"
    CreateReduxTextBox  -Name "CRightButtonScale" -Text "C-Right scale"  -Value 0 -Min 0 -Max 7 -Length 1 -Info "Set the scale for the C-Right button"
    CreateReduxTextBox  -Name "RupeeDrain"        -Text "Rupee Drain"    -Value 0 -Min 0 -Max 15          -Info "First drains rupees, then health based on set seconds`nZero disables this option"
    CreateReduxTextBox  -Name "Fog"               -Text "Fog"            -Value 0 -Min 0 -Max 15          -Info "Adjust the level of fog applied, with higher values decreasing the fog`nZero disables this option"
    CreateReduxComboBox -Name "Dpad"              -Text "D-Pad"          -Default 2 -Items @("Disabled", "Enabled", "Enabled with Dual Set")                                                                           -Info "Enable D-Pad functionality and with or without the addition to toggle between two different D-Pad layouts with L + R"
    CreateReduxComboBox -Name "ShowDPad"          -Text "D-Pad Layout"   -Default 2 -Items @("Hidden", "Left", "Right", "Bottom")                                                                                      -Info "Choose from four different options to change the D-Pad layout"
    CreateReduxComboBox -Name "HideHUD"           -Text "Hide HUD"                  -Items @("Default", "Pro", "No Buttons", "Only Health", "Hidden")                                                                  -Info "Choose from four different options to hide the HUD"
    CreateReduxComboBox -Name "HUDLayout"         -Text "HUD Layout"                -Items @("Ocarina of Time", "Majora's Mask", "Inverted A and B", "Nintendo", "Modern", "GameCube (Original)", "GameCube (Modern)") -Info "Choose from seven different layouts to change the HUD"
    CreateReduxComboBox -Name "DamageTaken"       -Text "Damage Taken"              -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage", "16x Damage", "32x Damage", "64x Damage")                             -Info "Multiplies taken damage by the chosen factor`nCan be stacked with other damage multiplication options"
    


    # CODE HOOKS FEATURES #

    CreateReduxGroup    -Tag  "Hooks"                                         -Text "Code Hook Features"
    CreateReduxCheckBox -Name "FasterArmosPushing"                   -Checked -Text "Faster Armos Pushing"     -Info "Armos statues are being pushed faster"                                                                  -Credits "Randomizer"
    CreateReduxCheckBox -Name "RupeeIconColors"                      -Checked -Text "Rupee Icon Colors"        -Info "The color of the Rupees counter icon changes depending on your wallet size"                             -Credits "Randomizer"
    CreateReduxCheckBox -Name "EmptyBombFix"         -Exclude "Dawn" -Checked -Text "Empty Bomb Fix"           -Info "Fixes Empty Bomb Glitch"                                                                                -Credits "Randomizer"
    CreateReduxCheckBox -Name "BlueFireArrow"        -Adult                   -Text "Blue Fire Arrows"         -Info "Ice Arrows have the same attributes as Blue Fire, thus the ability to melt Blue Ice and bombable walls" -Credits "Randomizer"
    CreateReduxCheckBox -Name "ShowFileSelectIcons"                           -Text "Show File Select Icons"   -Info "Show icons on the File Select screen to display your save file progress"                                -Credits "Randomizer"
    CreateReduxCheckBox -Name "StoneOfAgony"         -Base 5         -Checked -Text "Stone of Agony Indicator" -Info "The Stony of Agony uses a visual indicator in addition to rumble"                                       -Credits "Randomizer"
    CreateReduxCheckBox -Name "BiggoronFix"          -Base 4 -Adult           -Text "Biggoron Fix"             -Info "Fix bug when trying to trade in the Biggoron Sword"                                                     -Credits "Randomizer"
    CreateReduxCheckBox -Name "DampeFix"             -Base 4 -Child           -Text "Dampé Fix"                -Info "Prevent the heart piece of the Gravedigging Tour from being missable"                                   -Credits "Randomizer"
    CreateReduxCheckBox -Name "HyruleGuardsSoftlock" -Base 4 -Child           -Text "Hyrule Guards Softlock"   -Info "Fix a potential softlock when culling Hyrule Guards"                                                    -Credits "Randomizer"
    CreateReduxCheckBox -Name "WarpSongsSpeedup"     -Base 5                  -Text "Warp Songs Speedup"       -Info "Speedup the warp songs warping sequences"                                                               -Credits "Randomizer"
    CreateReduxCheckBox -Name "GoldGauntletsSpeedup" -Base 5                  -Text "Golden Gauntlets Speedup" -Info "Cutscene speed-up for throwing pillars that require Golden Gauntlets"                                   -Credits "Randomizer"
    CreateReduxCheckBox -Name "TalonSkip"            -Base 3 -Child           -Text "Skip Talon Cutscene"      -Info "Skip the cutscene after waking up Talon before entering the Castle Courtyard"                           -Credits "Randomizer"



    if ($Settings.Core.Lite) { return }



    # RAINBOW COLORS #

    CreateReduxGroup    -Tag  "Rainbow"                          -Text "Rainbow Colors"
    CreateReduxCheckBox -Name "Sword"                            -Text "Sword Trail"     -Info "Cycle through random colors for the Sword Trail"     -Credits "Randomizer"
    CreateReduxCheckBox -Name "Boomerang" -Child -Exclude "Dawn" -Text "Boomerang Trail" -Info "Cycle through random colors for the Boomerang Trail" -Credits "Randomizer"
    CreateReduxCheckBox -Name "Bombchu"          -Exclude "Dawn" -Text "Bombchu Trail"   -Info "Cycle through random colors for the Bombchu Trail"   -Credits "Randomizer"
    CreateReduxCheckBox -Name "Navi"                             -Text "Navi"            -Info "Cycle through random colors for Navi"                -Credits "Randomizer"



    # EQUIPMENT COLORS #

    CreateReduxGroup -Tag "Colors" -Text "Tunic Colors"
    $Redux.Colors.ExtraEquipment = @(); $Buttons = @(); $Redux.Colors.SetExtraEquipment = @()
    $items = @("Magician Green", "Guardian Silver", "Hero Gold", "Pajama Blue", "Shadow Purple"); $postItems = @("Randomized", "Custom"); $Files = ($GameFiles.Textures + "\Tunic"); $Randomize = '"Randomized" fully randomizes the colors each time the patcher is opened'
    $Redux.Colors.ExtraEquipment += CreateReduxComboBox -Name "MagicianTunic" -Text "Magician Tunic" -Default 1 -Length 230 -Items $items -PostItems $postItems -FilePath $Files -Info ("Select a color scheme for the upgraded Kokiri Tunic (Extra Abilities only)`n"     + $Randomize) -Credits "Admentus"
    $Buttons += CreateReduxButton -Tag $Buttons.Count -Text "Magician Tunic"  -Info "Select the color you want for the upgraded Kokiri Tunic (Extra Abilities only)"     -Credits "Admentus"
    $Redux.Colors.ExtraEquipment += CreateReduxComboBox -Name "GuardianTunic" -Text "Guardian Tunic" -Default 2 -Length 230 -Items $items -PostItems $postItems -FilePath $Files -Info ("Select a color scheme for the upgraded Goron Tunic (Extra Abilities only)`n"      + $Randomize) -Credits "Admentus"
    $Buttons += CreateReduxButton -Tag $Buttons.Count -Text "Guardian Tunic"  -Info "Select the color you want for the upgraded Goron Tunic (Extra Abilities only)"      -Credits "Admentus"
    $Redux.Colors.ExtraEquipment += CreateReduxComboBox -Name "HeroTunic"     -Text "Hero Tunic"     -Default 3 -Length 230  -Items $items -PostItems $postItems -FilePath $Files -Info ("Select a color scheme for the upgraded Zora Tunic (Extra Abilities only)`n"      + $Randomize) -Credits "Admentus"
    $Buttons += CreateReduxButton -Tag $Buttons.Count -Text "Hero Tunic"      -Info "Select the color you want for the upgraded Zora Tunic (Extra Abilities only)"       -Credits "Admentus"
    $Redux.Colors.ExtraEquipment += CreateReduxComboBox -Name "NoTunic"       -Text "No Tunic"       -Default 4 -Length 230 -Items $items -PostItems $postItems -FilePath $Files -Info ("Select a color scheme for the Unequipped Tunic`n"                                 + $Randomize) -Credits "Admentus"
    $Buttons += CreateReduxButton -Tag $Buttons.Count -Text "No Tunic"        -Info "Select the color you want for the Unequipped Tunic"                                 -Credits "Admentus"
    $Redux.Colors.ExtraEquipment += CreateReduxComboBox -Name "ShadowTunic"   -Text "Shadow Tunic"   -Default 5 -Length 230 -Items $items -PostItems $postItems -FilePath $Files -Info ("Select a color scheme for the upgraded Unequipped Tunic (Extra Abilities only)`n" + $Randomize) -Credits "Admentus"
    $Buttons += CreateReduxButton -Tag $Buttons.Count -Text "Shadow Tunic"    -Info "Select the color you want for the upgraded Unequipped Tunic (Extra Abilities only)" -Credits "Admentus"

    $Redux.Colors.SetExtraEquipment += CreateColorDialog -Color "00913C" -Name "SetMagicianTunic" -IsGame -Button $Buttons[0]
    $Redux.Colors.SetExtraEquipment += CreateColorDialog -Color "A5AFBE" -Name "SetGuardianTunic" -IsGame -Button $Buttons[1]
    $Redux.Colors.SetExtraEquipment += CreateColorDialog -Color "C8AF32" -Name "SetHeroTunic"     -IsGame -Button $Buttons[2]
    $Redux.Colors.SetExtraEquipment += CreateColorDialog -Color "64B4FF" -Name "SetNoTunic"       -IsGame -Button $Buttons[3]
    $Redux.Colors.SetExtraEquipment += CreateColorDialog -Color "503CAA" -Name "SetShadowTunic"   -IsGame -Button $Buttons[4]

    $Redux.Colors.ExtraEquipmentLabels = @()
    for ($i=0; $i -lt $Buttons.length; $i++) {
        $Buttons[$i].Add_Click({ $Redux.Colors.SetExtraEquipment[[uint16]$this.Tag].ShowDialog(); $Redux.Colors.ExtraEquipment[[uint16]$this.Tag].Text = "Custom"; $Redux.Colors.ExtraEquipmentLabels[[uint16]$this.Tag].BackColor = $Redux.Colors.SetExtraEquipment[[uint16]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetExtraEquipment[[uint16]$this.Tag].Tag] = $Redux.Colors.SetExtraEquipment[[uint16]$this.Tag].Color.Name })
        $Redux.Colors.ExtraEquipmentLabels += CreateReduxColoredLabel -Link $Buttons[$i] -Color $Redux.Colors.SetExtraEquipment[$i].Color
    }

    $Redux.Colors.ExtraEquipment[0].Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.ExtraEquipment[0] -Dialog $Redux.Colors.SetExtraEquipment[0] -Label $Redux.Colors.ExtraEquipmentLabels[0] })
                                                               SetTunicColorsPreset -ComboBox $Redux.Colors.ExtraEquipment[0] -Dialog $Redux.Colors.SetExtraEquipment[0] -Label $Redux.Colors.ExtraEquipmentLabels[0]
    $Redux.Colors.ExtraEquipment[1].Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.ExtraEquipment[1] -Dialog $Redux.Colors.SetExtraEquipment[1] -Label $Redux.Colors.ExtraEquipmentLabels[1] })
                                                               SetTunicColorsPreset -ComboBox $Redux.Colors.ExtraEquipment[1] -Dialog $Redux.Colors.SetExtraEquipment[1] -Label $Redux.Colors.ExtraEquipmentLabels[1]
    $Redux.Colors.ExtraEquipment[2].Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.ExtraEquipment[2] -Dialog $Redux.Colors.SetExtraEquipment[2] -Label $Redux.Colors.ExtraEquipmentLabels[2] })
                                                               SetTunicColorsPreset -ComboBox $Redux.Colors.ExtraEquipment[2] -Dialog $Redux.Colors.SetExtraEquipment[2] -Label $Redux.Colors.ExtraEquipmentLabels[2]
    $Redux.Colors.ExtraEquipment[3].Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.ExtraEquipment[3] -Dialog $Redux.Colors.SetExtraEquipment[3] -Label $Redux.Colors.ExtraEquipmentLabels[3] })
                                                               SetTunicColorsPreset -ComboBox $Redux.Colors.ExtraEquipment[3] -Dialog $Redux.Colors.SetExtraEquipment[3] -Label $Redux.Colors.ExtraEquipmentLabels[3]
    $Redux.Colors.ExtraEquipment[4].Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.ExtraEquipment[4] -Dialog $Redux.Colors.SetExtraEquipment[4] -Label $Redux.Colors.ExtraEquipmentLabels[4] })
                                                               SetTunicColorsPreset -ComboBox $Redux.Colors.ExtraEquipment[4] -Dialog $Redux.Colors.SetExtraEquipment[4] -Label $Redux.Colors.ExtraEquipmentLabels[4]
    
    CreateButtonColorOptions
    CreateRupeeColorOptions
    CreateHUDColorOptions
    CreateBoomerangColorOptions
    CreateBombchuColorOptions
    CreateTextColorOptions; $Redux.Box.TextColors = $Last.Group

    if ($Redux.Graphics.RupeeIconColors -ne $null) {
        $Redux.Hooks.RupeeIconColors.Add_CheckStateChanged( {
            if ($Patches.Redux.Checked) { EnableElem -Elem $Redux.Colors.RupeesVanilla -Active (!$this.checked) }
        } )
    }
    if ($Redux.Graphics.GCScheme -ne $null) {
        $Redux.Graphics.GCScheme.Add_CheckStateChanged( {
            if ($Patches.Redux.Checked) { EnableElem -Elem $Redux.Box.TextColors -Active (!$this.checked) }
        } )
    }

    if ($Redux.UI.ButtonPositions -ne $null -and $Redux.Misc.OptionsMenu -ne $null) {
        $Redux.UI.ButtonPositions.Add_CheckedChanged(     { EnableElem -Elem $Redux.Misc.OptionsMenu   -Active (!$this.checked)            } )
        $Redux.Misc.OptionsMenu.Add_SelectedIndexChanged( { EnableElem -Elem $Redux.UI.ButtonPositions -Active ($this.SelectedIndex -eq 0) } )
    }

}



#==============================================================================================================================================================================================
function CreateTabLanguage() {
    
    # DIALOGUE #

    $Redux.Box.Dialogue = CreateReduxGroup -Tag "Text" -Text "Dialogue" -Safe -Base 5
    CreateReduxComboBox -Base 1 -Name "Language" -Text "Language" -Items ($Files.json.languages.title) -Info "Patch the game with a different language"
    CreateReduxCheckBox -Base 1 -Name "Restore"        -Text "Restore Text"    -Info "Restores the text used from the GC and later revisions and applies their text and icons fixes in the game dialogue"                                        -Credits "Admentus & ShadowOne333"
    CreateReduxCheckBox -Base 1 -Name "FemalePronouns" -Text "Female Pronouns" -Info "Refer to Link as a female character"                                                                                                                       -Credits "Admentus"
    CreateReduxCheckBox         -Name "GoldSkulltula"  -Text "Gold Skulltula"  -Info "The textbox for obtaining a Gold Skulltula will no longer interrupt the gameplay`nThe English & German scripts also shows the total amount you got so far" -Credits "ShadowOne333"
    CreateReduxCheckBox -Base 4 -Name "EasterEggs"     -Text "Easter Eggs"     -Info "Adds custom Patreon Tier 3 messages into the game`nCan you find them all?" -Checked                                                                        -Credits "Admentus & Patreons"
    CreateReduxCheckBox -Base 1 -Name "Custom"         -Text "Custom"          -Info ('Insert custom dialogue found from "..\Patcher64+ Tool\Files\Games\Majora' + "'" + 's Mask\Custom Text"') -Warning "Make sure your custom script is proper and correct, or your ROM will crash`n[!] No edit will be made if the custom script is missing"



    # TEXT SPEED #

    CreateReduxGroup       -Tag  "Text"                           -Text "Text Speed"
    CreateReduxRadioButton -Name "Speed1x" -Max 4 -SaveTo "Speed" -Text "1x Text Speed" -Info "Leave the dialogue text speed at normal"               -Checked
    CreateReduxRadioButton -Name "Speed2x" -Max 4 -SaveTo "Speed" -Text "2x Text Speed" -Info "Set the dialogue text speed to be twice as fast"       -Credits "Maroc"
    CreateReduxRadioButton -Name "Speed3x" -Max 4 -SaveTo "Speed" -Text "3x Text Speed" -Info "Set the dialogue text speed to be three times as fast" -Credits "Admentus & Maroc"
    CreateReduxRadioButton -Name "Instant" -Max 4 -SaveTo "Speed" -Text "Instant Text"  -Info "Most text will be shown instantly"               -Safe -Credits "Admentus"



    # OTHER ENGLISH OPTIONS #

    CreateReduxGroup    -Tag  "Text"        -Text "Other English Options"
    CreateReduxCheckBox -Name "YeetPrompt"  -Text "Yeet Action Prompt"      -Lite -Info ('Replace the "Throw" Action Prompt with "Yeet"' + "`nYeeeeet")           -Credits "kr3z"
    CreateReduxCheckBox -Name "Fairy"       -Text "MM Fairy Text"   -Base 4       -Info ("Changes " + '"Bottled Fairy" to "Fairy"' + " as used in Majora's Mask") -Credits "GhostlyDark (ported)"
    CreateReduxCheckBox -Name "Milk"        -Text "MM Milk Text"    -Base 4       -Info ("Changes " + '"Lon Lon Milk" to "Milk"' + " as used in Majora's Mask")   -Credits "GhostlyDark (ported)"
    CreateReduxCheckBox -Name "PauseScreen" -Text "MM Pause Screen" -Base 4 -Lite -Info "Replaces the Pause Screen textures to be styled like Majora's Mask"      -Credits "CM & GhostlyDark"



    # OTHER GERMAN OPTIONS #

    CreateReduxGroup    -Lite -Tag  "Text"        -Text "Other German Options" -Base 1
    CreateReduxCheckBox -Lite -Name "CheckPrompt" -Text "Read Action Prompt" -Info 'Replace the "Lesen" Action Prompt with "Ansehen"'     -Credits "Admentus, GhostlyDark & Ticamus"
    CreateReduxCheckBox -Lite -Name "DivePrompt"  -Text "Dive Action Prompt" -Info 'Replace the "Tauchen" Action Prompt with "Abtauchen"' -Credits "Admentus, GhostlyDark & Ticamus"



    # OTHER TEXT OPTIONS #

    CreateReduxGroup    -Tag  "Text"       -Text "Other Text Options" -Lite -Safe
    if (StrLike -Str $GamePatch.settings -Val "Master of Time")   { $val = "Nite" }                                                    else   { $val   = "Navi"                   }
    if ($GamePatch.base -le 2)                                    { $items = @("Disabled", "Enabled as Female", "Enabled as Male") }   else   { $items = @("Disabled", "Enabled") }
    $names = "`n`n--- Supported Names With Textures ---`n" + "Navi`nTatl`nTaya`nТдтп`nTael`nNite`nNagi`nInfo"
    CreateReduxCheckBox -Name "LinkScript" -Text "Link Text"                                               -Info "Separate file name from Link's name in-game"  -Credits "Admentus & Third M"
    CreateReduxTextBox  -Name "LinkName"   -Text "Link Name"      -Length 8 -ASCII -Value "Link" -Width 90 -Info "Select the name for Link"                     -Credits "Admentus & Third M"      -Shift 40
    CreateReduxComboBox -Name "NaviScript" -Text ($val + " Text") -Items $items                            -Info ("Allow renaming " + $val + " and the gender") -Credits "Admentus & ShadowOne333" -Warning "Gender swap is only supported for English"
    CreateReduxTextBox  -Name "NaviName"   -Text ($val + " Name") -Length 5 -ASCII -Value $val   -Width 50 -Info ("Select the name for " + $val)                -Credits "Admentus & ShadowOne333" -Warning ('Most names do not have an unique texture label, and use a default "Info" prompt label' + $names)
    CreateReduxCheckBox -Name "NaviPrompt" -Text ($val + " Prompt")                                        -Info ("Enables the A button prompt for " + $val)    -Credits "Admentus & ShadowOne333" -Warning 'Most names do not have an unique texture prompt, and use a default "Info" prompt label'

    if ($IsFoolsDay -and $Redux.Text.LinkScript -ne $null -and !$Settings.Core.Lite) {
        $Redux.Text.LinkScript.Checked       = $True
        $Redux.Text.LinkName.Text            = "Jason"
        $Redux.Text.NaviScript.SelectedIndex = 2
        $Redux.Text.NaviName.Text            = "Cage"
    }

    if ($Redux.Text.Language   -ne $null)   { $Redux.Text.Language.Add_SelectedIndexChanged(   { UnlockLanguageContent } ) }
    if ($Redux.Text.LinkScript -ne $null)   { $Redux.Text.LinkScript.Add_CheckStateChanged(    { UnlockLanguageContent } ) }
    if ($Redux.Text.NaviScript -ne $null)   { $Redux.Text.NaviScript.Add_SelectedIndexChanged( { UnlockLanguageContent } ) }
    UnlockLanguageContent

}



#==============================================================================================================================================================================================
function UnlockLanguageContent() {
    
    if ($Redux.Text.Language -ne $null) {
        EnableElem -Elem @($Redux.Text.Restore, $Redux.Text.FemalePronouns, $Redux.Text.EasterEggs, $Redux.Text.YeetPrompt, $Redux.Text.Fairy, $Redux.Text.Milk, $Redux.Text.PauseScreen) -Active ($Redux.Text.Language.SelectedIndex -eq 0)                                  # English
        EnableElem -Elem @($Redux.Text.CheckPrompt, $Redux.Text.DivePrompt)                                                                                                               -Active ($Files.json.languages[$Redux.Text.Language.SelectedIndex].code   -eq "de") # German
        EnableElem -Elem @($Redux.Text.Instant, $Redux.Text.GoldSkulltula, $Redux.Text.LinkScript, $Redux.Text.NaviScript, $Redux.Text.NaviPrompt)                                        -Active ($Files.json.languages[$Redux.Text.Language.SelectedIndex].region -ne "J")  # Non-Japanese

        # Set max text speed in each language
        if ($Files.json.languages[$Redux.Text.Language.SelectedIndex].max_text_speed -eq 1) {
            EnableElem -Elem @($Redux.Text.Speed2x, $Redux.Text.Speed3x) -Active $False
            $Redux.Text.Speed1x.checked = $True
        }
        elseif ($Files.json.languages[$Redux.Text.Language.SelectedIndex].max_text_speed -eq 2) {
            EnableElem -Elem $Redux.Text.Speed2x -Active $True
            EnableElem -Elem $Redux.Text.Speed3x -Active $False
            if ($Redux.Text.Speed3x.checked -eq $True) { $Redux.Text.Speed2x.checked = $True }
        }
        else { EnableElem -Elem @($Redux.Text.Speed2x, $Redux.Text.Speed3x) -Active $True }
    }

    EnableElem -Elem $Redux.Text.NaviName -Active ($Redux.Text.NaviScript.SelectedIndex -gt 0 -and $Redux.Text.NaviScript.Active)
    EnableElem -Elem $Redux.Text.LinkName -Active ($Redux.Text.LinkScript.Checked             -and $Redux.Text.LinkScript.Active)

}



#==============================================================================================================================================================================================
function CreateTabGraphics() {
    
    # GRAPHICS #

    CreateReduxGroup -Tag  "Graphics" -Text "Graphics"
    if ($GamePatch.models -ne 0) {
        CreateReduxComboBox -Name "ChildModels" -Child -Text "Child Model" -Items (LoadModelsList -Category "Child") -Default "Original" -Info "Replace the child model used for Link"
        CreateReduxComboBox -Name "AdultModels" -Adult -Text "Adult Model" -Items (LoadModelsList -Category "Adult") -Default "Original" -Info "Replace the adult model used for Link"
    }
    CreateReduxCheckBox -Name "EnhancedChildQuestModel" -Base (-1) -Text "Enhanced Child Quest Model" -Info "Use an enhanced model instead for Child Quest with unique swords and shields" -Credits "Admentus"

    CreateReduxCheckBox -Name "Widescreen"        -Text "16:9 Widescreen (Advanced)"   -Info "Patch the game to be in true 16:9 widescreen with the HUD pushed to the edges"         -Safe -Native -Credits "Widescreen Patch by gamemasterplc, enhanced and ported by GhostlyDark"
    CreateReduxCheckBox -Name "WidescreenAlt"     -Text "16:9 Widescreen (Simplified)" -Info "Apply 16:9 Widescreen adjusted backgrounds and textures (as well as 16:9 Widescreen for the Wii VC)" -Credits "Aspect Ratio Fix by Admentus and 16:9 backgrounds by GhostlyDark, ShadowOne333 & CYB3RTRON" -Link $Redux.Graphics.Widescreen
    CreateReduxCheckBox -Name "ExtendedDraw"      -Text "Extended Draw Distance"       -Info "Increases the game's draw distance for objects`nDoes not work on all objects"                  -Safe -Credits "Admentus"
    CreateReduxCheckBox -Name "ForceHiresModel"   -Text "Force Hires Link Model"       -Info "Always use Link's High Resolution Model when Link is too far away"            -Exclude "Dawn & Dusk" -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "HideDungeonIcon"   -Text "Hide Dungeon Icon"            -Info "Hide dungeon icon for minimaps that do not have a dungeon entrance"                          -Base 3 -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "GCScheme"          -Text "GC Scheme"                    -Info "Replace and change the textures, dialogue and text colors to match the GameCube's scheme"            -Credits "Admentus, GhostlyDark, ShadowOne333 & GoldenMariaNova"
    CreateReduxCheckBox -Name "OverworldSkyboxes" -Text "Overworld Skyboxes"           -Info "Use day and night skyboxes for all overworld areas lacking one"                               -Scene -Credits "Admentus"
    CreateReduxCheckBox -Name "ImprovedMoon"      -Text "Improved Moon"                -Info "Replaces the moon with a nicer looking texture"                                                      -Credits "Admentus & GoldenMariaNova"

    if (!$IsWiiVC -and $Redux.Graphics.Widescreen -ne $null) {
        EnableElem -Elem @($Redux.Fixes.PauseScreenDelay, $Redux.Fixes.PauseScreenCrash) -Active (!$Redux.Graphics.Widescreen.Checked)
        $Redux.Graphics.Widescreen.Add_CheckStateChanged({ EnableElem -Elem @($Redux.Fixes.PauseScreenDelay, $Redux.Fixes.PauseScreenCrash) -Active (!$this.Checked) })
    }



    # INTERFACE #
    
    if (StrLike -Str $GamePatch.settings -Val "Gold Quest") { $val = "Gold Quest" } else { $val = "Ocarina of Time" }
    CreateReduxGroup    -Tag  "UI"               -Text "Interface"
    CreateReduxComboBox -Name "BlackBars"        -Text "Black Bars"          -Items @("Enabled", "Disabled for Z-Targeting", "Disabled for Cutscenes", "Always Disabled")                    -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes" -Credits "Admentus"
    CreateReduxComboBox -Name "ButtonStyle"      -Text "Buttons Style"       -Items "Ocarina of Time" -FilePath ($Paths.shared + "\HUD\Buttons")       -Ext "bin" -Default $val              -Info "Set the style for the HUD buttons"                                                                 -Credits "Admentus (ported), GhostlyDark (ported), Pizza (HD), Djipi, Community, Nerrel, Federelli, AndiiSyn & Syeo"
    CreateReduxComboBox -Name "Rupees"           -Text "Rupee Icon"          -Items "Ocarina of Time" -FilePath ($Paths.shared + "\HUD\Rupees")        -Ext "bin" -Default "Ocarina of Time" -Info "Set the style for the rupees icon"                                                                 -Credits "GhostlyDark (ported)"
    CreateReduxComboBox -Name "Hearts"           -Text "Heart Icons"         -Items "Ocarina of Time" -FilePath ($Paths.shared + "\HUD\Hearts")        -Ext "bin" -Default $val              -Info "Set the style for the heart icons"                                                                 -Credits "Admentus (ported), GhostlyDark (ported), AndiiSyn & Syeo"
    CreateReduxComboBox -Name "Magic"            -Text "Magic Bar"           -Items "Ocarina of Time" -FilePath ($Paths.shared + "\HUD\Magic")         -Ext "bin" -Default "Ocarina of Time" -Info "Set the style for the magic meter"                                                                 -Credits "GhostlyDark (ported), Pizza, Nerrel (HD), Zeth Alkar"
    CreateReduxComboBox -Name "CurrentFloor"     -Text "Current Floor Icon"  -Items "Ocarina of Time" -FilePath ($Paths.shared + "\HUD\Current Floor") -Ext "bin" -Default "Ocarina of Time" -Info "Set the style for the current floor icon"                                                          -Credits "Admentus (ported), GhostlyDark (ported) & GoldenMariaNova (Alternative & Triforce)"
    CreateReduxComboBox -Name "BossFloor"        -Text "Boss Floor Icon"     -Items "Ocarina of Time" -FilePath ($Paths.shared + "\HUD\Boss Floor")    -Ext "bin" -Default "Ocarina of Time" -Info "Set the style for the boss floor icon"                                                             -Credits "Admentus (ported), GhostlyDark (ported) & GoldenMariaNova (Alternative)"
    CreateReduxCheckBox -Name "DungeonKeys"      -Text "MM Key Icon"         -Info "Replace the key icon with that from Majora's Mask"          -Credits "GhostlyDark (ported)"
    CreateReduxCheckBox -Name "Chests"           -Text "MM Chests Map Icon"  -Info "Replace the chests map icons with those from Majora's Mask" -Credits "GhostlyDark (ported)"
    CreateReduxCheckBox -Name "CenterNaviPrompt" -Text "Center Navi Prompt"  -Info 'Centers the "Navi" prompt shown in the C-Up button'         -Credits "GhostlyDark (ported)"
    CreateReduxCheckBox -Name "ButtonPositions"  -Text "MM Button Positions" -Info "Positions the A and B buttons like in Majora's Mask"        -Credits "GhostlyDark (ported)"



    # HIDE HUD #

    CreateReduxGroup    -Tag  "Hide"         -Text "Hide HUD" -Lite
    CreateReduxCheckBox -Name "AButton"      -Text "Hide A Button"           -Info "Hide the A Button"                                            -Credits "Admentus"
    CreateReduxCheckBox -Name "BButton"      -Text "Hide B Button"           -Info "Hide the B Button"                                            -Credits "Admentus"
    CreateReduxCheckBox -Name "StartButton"  -Text "Hide Start Button"       -Info "Hide the Start Button"                                        -Credits "Admentus"
    CreateReduxCheckBox -Name "CUpButton"    -Text "Hide C-Up Button"        -Info "Hide the C-Up Button"                                         -Credits "Admentus"
    CreateReduxCheckBox -Name "CButtons"     -Text "Hide C Buttons"          -Info "Hide the C Button used for items"                             -Credits "Admentus"
    CreateReduxCheckBox -Name "Hearts"       -Text "Hide Hearts"             -Info "Hide the the Hearts display"                                  -Credits "Admentus"
    CreateReduxCheckBox -Name "Magic"        -Text "Hide Magic"              -Info "Hide the Magic display"                                       -Credits "Admentus"
    CreateReduxCheckBox -Name "Rupees"       -Text "Hide Rupees"             -Info "Hide the the Rupees display"                                  -Credits "Admentus"
    CreateReduxCheckBox -Name "DungeonKeys"  -Text "Hide Keys"               -Info "Hide the Keys display shown in several dungeons and areas"    -Credits "Admentus"
    CreateReduxCheckBox -Name "Carrots"      -Text "Hide Epona Carrots"      -Info "Hide the Epona Carrots display"                               -Credits "Admentus"
    CreateReduxCheckBox -Name "AreaTitle"    -Text "Hide Area Title Card"    -Info "Hide the area title that displays when entering a new area"   -Credits "Admentus"
    CreateReduxCheckBox -Name "DungeonTitle" -Text "Hide Dungeon Title Card" -Info "Hide the dungeon title that displays when entering a dungeon" -Credits "Admentus"
    CreateReduxCheckBox -Name "Icons"        -Text "Hide Icons"              -Info "Hide the Clock and Score Counter icons display"               -Credits "Admentus"
    CreateReduxCheckBox -Name "Credits"      -Text "Hide Credits"            -Info "Hide the credits text during the credits sequence"            -Credits "Admentus" -Exclude "Master"

    

    # STYLES #

    if (StrLike -Str $GamePatch.settings -Val "Gold Quest") { $val = "Gold Quest"; $hair = @("Pink") } else { $val = "Regular"; $hair = @("Blonde") }
    CreateReduxGroup    -Tag  "Styles"        -Text "Styles" -Lite
    CreateReduxComboBox -Name "RegularChests" -Text "Regular Chests" -Info "Use a different style for regular treasure chests"                                           -FilePath ($Paths.shared + "\Styles\Chests") -Default $val -Ext "front" -Items "Regular"  -Credits "Nintendo, Syeo, AndiiSyn & Rando"
    CreateReduxComboBox -Name "BossChests"    -Text "Boss Chests"    -Info "Use a different style for Boss Key treasure chests"                                          -FilePath ($Paths.shared + "\Styles\Chests")               -Ext "front" -Items "Boss OoT" -Credits "Nintendo, Syeo, AndiiSyn & Rando"
    CreateReduxComboBox -Name "SmallCrates"   -Text "Small Crates"   -Info "Use a different style for small liftable crates"                                             -FilePath ($Paths.shared + "\Styles\Small Crates")         -Ext "bin"   -Items "Regular"  -Credits "Nintendo & Rando"
    CreateReduxComboBox -Name "Pots"          -Text "Pots"           -Info "Use a different style for throwable pots"                                                    -FilePath ($Paths.shared + "\Styles\Pots")                 -Ext "bin"   -Items "Regular"  -Credits "Nintendo, Syeo & Rando"
    CreateReduxComboBox -Name "HairColor"     -Text "Hair Color"     -Info "Use a different hair color style for Link`nOnly for Ocarina of Time or Majora's Mask models" -FilePath ($Paths.shared + "\Styles\Hair\Ocarina of Time") -Ext "bin"   -Items $hair      -Credits "Third M & AndiiSyn"

}




#==============================================================================================================================================================================================
function CreateTabAudio() {
    
    # SOUNDS / VOICES #

    CreateReduxGroup    -Tag  "Sounds"             -Text "Sounds / Voices"
    CreateReduxComboBox -Name "ChildVoices" -Child -Text "Child Voice" -Default "Original" -Items @("Original") -FilePath ($GameFiles.binaries + "\Voices Child")   -Info "Replace the voice used for the Child Link Model"        -Credits "`nMajora's Mask: Korey Cryderman (ported) & GhostlyDark (corrected)`nMelee Zelda: Mickey Saeed & theluigidude2007 (edits)`nAmara: Amara (ripping) & theluigidude2007 (edits)"
    CreateReduxComboBox -Name "AdultVoices" -Adult -Text "Adult Voice" -Default "Original" -Items @("Original") -FilePath ($GameFiles.binaries + "\Voices Adult")   -Info "Replace the voice used for the Adult Link Model"        -Credits "`nMajora's Mask: Korey Cryderman (ported) & GhostlyDark (corrected)`nMelee Zelda: Mickey Saeed & theluigidude2007 (edits)`nAmara: Amara (ripping) & theluigidude2007`nPeach: theluigidude2007"
    CreateReduxComboBox -Name "Instrument"         -Text "Instrument"                      -Items @("Ocarina", "Female Voice", "Whistle", "Harp", "Organ", "Flute") -Info "Replace the sound used for playing the Ocarina of Time" -Credits "Randomizer"



    # SFX SOUND EFFECTS #

    if ($Settings.Core.Lite) { return }

    $SFX1 = @("Default", "Disabled", "Soft Beep", "Bark", "Bomb Bounce", "Bongo Bongo Low", "Bow Twang", "Business Scrub", "Carrot Refill", "Cluck", "Great Fairy", "Drawbridge Set", "Guay", "Horse Trot", "HP Recover", "Iron Boots", "Moo", "Mweep!", 'Navi "Hey!"', "Navi Random", "Notification", "Pot Shattering", "Ribbit", "Rupee (Silver)", "Switch", "Sword Bonk", "Tambourine", "Timer", "Zelda Gasp (Adult)")
    $SFX2 = @("Default",  "Disabled", "Soft Beep", "Bark", "Business Scrub", "Carrot Refill", "Cluck", "Cockadoodledoo", "Dusk Howl", "Exploding Crate", "Explosion", "Great Fairy", "Guay", "Horse Neigh", "HP Low", "HP Recover", "Ice Shattering", "Moo", "Meweep!", 'Navi "Hello!"', "Notification", "Pot Shattering", "Redead Scream", "Ribbit", "Ruto Giggle", "Skulltula", "Tambourine", "Timer", "Zelda Gasp (Adult)")
    $SFX3 = @("Default", "Disabled", "Soft Beep", "Bark", "Bomb Bounce", "Bongo Bongo High", "Bongo Bongo Low", "Bottle Cork", "Bow Twang", "Bubble Laugh", "Carrot Refill", "Change Item", "Child Pant", "Cluck", "Deku Baba", "Drawbridge Set", "Dusk Howl", "Fanfare (Light)", "Fanfare (Medium)", "Field Shrub", "Flare Dancer Startled",
    'Ganondorf "Teh"', "Gohma Larva Croak", "Gold Skull Token", "Goron Wake", "Guay", "Gunshot", "Hammer Bonk", "Horse Trot", "HP Low", "HP Recover", "Iron Boots", "Iron Knuckle", "Moo", "Mweep!", "Notification", "Phantom Ganon Laugh", "Plant Explode", "Pot Shattering", "Redead Moan", "Ribbit", "Rupee", "Rupee (Silver)", "Ruto Crash",
    "Ruto Lift", "Ruto Thrown", "Scrub Emerge", "Shabom Bounce", "Shabom Pop", "Shellblade", "Skulltula", "Spit Nut", "Switch", "Sword Bonk", 'Talon "Hmm"', "Talon Snore", "Talon WTF", "Tambourine", "Target Enemy", "Target Neutral", "Thunder", "Timer", "Zelda Gasp (Adult)")
    
    CreateReduxGroup    -Tag "SFX"         -Text "SFX Sound Effects"
    CreateReduxComboBox -Name "LowHP"      -Text "Low HP"      -Items $SFX1                                                                                                                                   -Info "Set the sound effect for the low HP beeping"                             -Credits "Randomizer"
    CreateReduxComboBox -Name "Navi"       -Text "Navi"        -Items $SFX2                                                                                                                                   -Info "Replace the sound used for Navi when she wants to tell something"        -Credits "Randomizer"
    CreateReduxComboBox -Name "ZTarget"    -Text "Z-Target"    -Items $SFX2                                                                                                                                   -Info "Replace the sound used for Z-Targeting enemies"                          -Credits "Randomizer"
    CreateReduxComboBox -Name "HoverBoots" -Text "Hover Boots" -Items @("Default", "Disabled", "Bark", "Cartoon Fall", "Flare Dancer Laugh", "Mweep!", "Shabom Pop", "Tambourine")                            -Info "Replace the sound used for the Hover Boots"                              -Credits "Randomizer" 
    CreateReduxComboBox -Name "Horse"      -Text "Horse Neigh" -Items @("Default", "Disabled", "Armos", "Child Scream", "Great Fairy", "Moo", "Mweep!", "Redead Scream", "Ruto Wiggle", "Stalchild Attack")   -Info "Replace the sound for horses when neighing"                              -Credits "Randomizer"
    CreateReduxComboBox -Name "Nightfall"  -Text "Nightfall"   -Items @("Default", "Disabled", "Cockadoodledoo", "Gold Skull Token", "Great Fairy", "Moo", "Mweep!", "Redead Moan", "Talon Snore", "Thunder") -Info "Replace the sound used when Nightfall occurs"                            -Credits "Randomizer" 
    CreateReduxComboBox -Name "FileCursor" -Text "File Cursor" -Items $SFX3                                                                                                                                   -Info "Replace the sound used when moving the cursor in the File Select menu"   -Credits "Randomizer"
    CreateReduxComboBox -Name "FileSelect" -Text "File Select" -Items $SFX3                                                                                                                                   -Info "Replace the sound used when selecting something in the File Select menu" -Credits "Randomizer"



    # MUSIC #

    if ($GamePatch.base -le 3) { MusicOptions -Default "Great Fairy's Fountain" }
    
}



#==============================================================================================================================================================================================
function CreateQuestGroups() {
    
    # DUNGEONS & LOGO #

    CreateReduxGroup -Tag "MQ" -Text "Dungeons & Logo"
    CreateReduxComboBox -Name "Dungeons" -Text "Dungeons" -Items @("Vanilla", "Master Quest", "Ura Quest", "Select", "Randomize", "Custom")                         -Info 'Select the dungeons to patch`n"Custom" patches Scene Editor generated scenes' -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), ShadowOne333 & Admentus"
    CreateReduxComboBox -Name "Logo"     -Text "Logo"     -Items @("Vanilla", "Master Quest", "Ura Quest", "New Master Quest", "Ura Quest", "Ura Quest + Subtitle") -Info "Select the logo title for the intro title screen" -Base 1                     -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool), ShadowOne333, GhostlyDark & Admentus"



    # SELECT - DUNGEONS #

    $items = @("Vanilla", "Master Quest", "Ura Quest"); $credits = "ZethN64, Sakura, Frostclaw, Steve(ToCoool), ShadowOne333 & Admentus"
    $Redux.Box.SelectMQ = CreateReduxGroup -Tag "MQ" -Text "Select - Dungeons"
    CreateReduxComboBox -Name "InsideTheDekuTree"    -Text "Inside the Deku Tree"     -Items $items -NoDefault -Shift 20 -Info "Patch Inside the Deku Tree to Master Quest"     -Credits $credits
    CreateReduxComboBox -Name "DodongosCavern"       -Text "Dodongo's Cavern"         -Items $items -NoDefault -Shift 20 -Info "Patch Dodongo's Cavern to Master Quest"         -Credits $credits
    CreateReduxComboBox -Name "InsideJabuJabusBelly" -Text "Inside Jabu-Jabu's Belly" -Items $items -NoDefault -Shift 20 -Info "Patch Inside Jabu-Jabu's Belly to Master Quest" -Credits $credits
    CreateReduxComboBox -Name "ForestTemple"         -Text "Forest Temple"            -Items $items -NoDefault -Shift 20 -Info "Patch Forest Temple to Master Quest"            -Credits $credits
    CreateReduxComboBox -Name "FireTemple"           -Text "Fire Temple"              -Items $items -NoDefault -Shift 20 -Info "Patch Fire Temple to Master Quest"              -Credits $credits
    CreateReduxComboBox -Name "WaterTemple"          -Text "Water Temple"             -Items $items -NoDefault -Shift 20 -Info "Patch Water Temple to Master Quest"             -Credits $credits
    CreateReduxComboBox -Name "ShadowTemple"         -Text "Shadow Temple"            -Items $items -NoDefault -Shift 20 -Info "Patch Shadow Temple to Master Quest"            -Credits $credits
    CreateReduxComboBox -Name "SpiritTemple"         -Text "Spirit Temple"            -Items $items -NoDefault -Shift 20 -Info "Patch Spirit Temple to Master Quest"            -Credits $credits
    CreateReduxComboBox -Name "IceCavern"            -Text "Ice Cavern"               -Items $items -NoDefault -Shift 20 -Info "Patch Ice Cavern to Master Quest"               -Credits $credits
    CreateReduxComboBox -Name "BottomOfTheWell"      -Text "Bottom of the Well"       -Items $items -NoDefault -Shift 20 -Info "Patch Bottom of the Well to Master Quest"       -Credits $credits
    CreateReduxComboBox -Name "GerudoTrainingGround" -Text "Gerudo Training Ground"   -Items $items -NoDefault -Shift 20 -Info "Patch Gerudo Training Ground to Master Quest"   -Credits $credits
    CreateReduxComboBox -Name "InsideGanonsCastle"   -Text "Inside Ganon's Castle"    -Items $items -NoDefault -Shift 20 -Info "Patch Inside Ganon's Castle to Master Quest"    -Credits $credits



    # RANDOMIZE - DUNGEONS #

    $Redux.Box.RandomizeMQ = CreateReduxGroup -Tag "MQ" -Text "Randomize - Dungeons"
    $Items = @("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12")
    CreateReduxComboBox -Name "Minimum" -Text "Minimum" -Default 1            -Items $Items
    CreateReduxComboBox -Name "Maximum" -Text "Maximum" -Default $Items.Count -Items $Items

    $Redux.MQ.Minimum.Add_SelectedIndexChanged({
        if ($Redux.MQ.Maximum.SelectedIndex -lt $Redux.MQ.Minimum.SelectedIndex) { $Redux.MQ.Maximum.SelectedIndex = $Redux.MQ.Minimum.SelectedIndex }
    })
    $Redux.MQ.Maximum.Add_SelectedIndexChanged({
        if ($Redux.MQ.Maximum.SelectedIndex -lt $Redux.MQ.Minimum.SelectedIndex) { $Redux.MQ.Maximum.SelectedIndex = $Redux.MQ.Minimum.SelectedIndex }
    })
    if ($Redux.MQ.Maximum.SelectedIndex -lt $Redux.MQ.Minimum.SelectedIndex) { $Redux.MQ.Maximum.SelectedIndex = $Redux.MQ.Minimum.SelectedIndex }
        
    EnableForm -Form $Redux.Box.SelectMQ    -Enable ($Redux.MQ.Dungeons.Text -eq "Select")
    EnableForm -Form $Redux.Box.RandomizeMQ -Enable ($Redux.MQ.Dungeons.Text -eq "Randomize")
    $Redux.MQ.Dungeons.Add_SelectedIndexChanged({
        EnableForm -Form $Redux.Box.SelectMQ    -Enable ($Redux.MQ.Dungeons.Text -eq "Select")
        EnableForm -Form $Redux.Box.RandomizeMQ -Enable ($Redux.MQ.Dungeons.Text -eq "Randomize")
    })

}



#==============================================================================================================================================================================================
function CreateTabDifficulty() {
    
    if ($GamePatch.mq -eq 1 -and !$Settings.Core.Safe) { CreateQuestGroups }

    

    # HERO MODE #

    $items1 = @("1 Monster HP","0.5x Monster HP", "1x Monster HP", "1.5x Monster HP", "2x Monster HP", "2.5x Monster HP", "3x Monster HP", "3.5x Monster HP", "4x Monster HP", "5x Monster HP")
    $items2 = @("1 Mini-Boss HP", "0.5x Mini-Boss HP", "1x Mini-Boss HP", "1.5x Mini-Boss HP", "2x Mini-Boss HP", "2.5x Mini-Boss HP", "3x Mini-Boss HP", "3.5x Mini-Boss HP", "4x Mini-Boss HP", "5x Mini-Boss HP")
    $items3 = @("1 Boss HP", "0.5x Boss HP", "1x Boss HP", "1.5x Boss HP", "2x Boss HP", "2.5x Boss HP", "3x Boss HP", "3.5x Boss HP", "4x Boss HP", "5x Boss HP")

    CreateReduxGroup    -Tag  "Hero"       -Text "Hero Mode"
    CreateReduxComboBox -Name "MonsterHP"  -Text "Monster HP"   -Items $items1 -Default 3                                                        -Info "Set the amount of health for monsters`nDoesn't include monsters which die in 1 hit already"           -Credits "Admentus"
    CreateReduxComboBox -Name "MiniBossHP" -Text "Mini-Boss HP" -Items $items2 -Default 3                                                        -Info "Set the amount of health for elite monsters and mini-bosses`nBig Octo and Dark Link are not included" -Credits "Admentus"
    CreateReduxComboBox -Name "BossHP"     -Text "Boss HP"      -Items $items3 -Default 3                                                        -Info "Set the amount of health for bosses`nPhantom Ganon, Ganondorf and Ganon have a max of 3x health"      -Credits "Admentus & Marcelo20XX"
    CreateReduxComboBox -Name "Damage"     -Text "Damage"       -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage", "OHKO Mode")        -Info "Set the amount of damage you receive`nOHKO Mode = You die in one hit"                                 -Credits "Admentus"
    CreateReduxComboBox -Name "MagicUsage" -Text "Magic Usage"  -Items @("1x Magic Usage", "2x Magic Usage", "4x Magic Usage", "8x Magic Usage") -Info "Set the amount of times magic is consumed at"                                                         -Credits "Admentus"
    CreateReduxComboBox -Name "ItemDrops"  -Text "Item Drops"   -Items @("Default", "No Hearts", "Only Rupees", "Nothing")                       -Info "Set the items that will drop from grass, pots and more"                                               -Credits "Randomizer, Admentus, Third M & BilonFullHDemon"
    
    if ($Settings.Core.Lite) {
        CreateReduxCheckBox -Name "Enemies"    -Text "Enemies"     -Info "Make some regular enemies harder with extra properties such as faster attacking or speed" -Credits "Admentus, Euler & Anthrogi"
        CreateReduxCheckBox -Name "MiniBosses" -Text "Mini-Bosses" -Info "Make some mini-bosses harder with extra properties such as faster attacking or speed"     -Credits "Admentus, Euler, Anthrogi, Nokaubure & BilonFullHDemon"
        CreateReduxCheckBox -Name "Bosses"     -Text "Bosses"      -Info "Make some bosses harder with extra properties such as faster attacking or speed"          -Credits "Admentus, Euler & Anthrogi"
    }


    # HERO MODE #

    CreateReduxGroup    -Tag  "Hero"                    -Text "Hero Mode"
    CreateReduxCheckBox -Name "Arwing"           -Scene -Text "Arwing"              -Info "Add an Arwing to Kokiri Forest"                                         -Credits "Admentus"
    CreateReduxCheckBox -Name "LikeLike"         -Scene -Text "Like-Like"           -Info "Add an Like-Like to Kokiri Forest"                                      -Credits "Admentus"
    CreateReduxCheckBox -Name "GraveyardKeese"   -Scene -Text "Graveyard Keese"     -Info "Restore the Keese that appear at the Graveyard as Adult Kink"           -Credits "Admentus"
    CreateReduxCheckBox -Name "LostWoodsOctorok" -Scene -Text "Lost Woods Octorok"  -Info "Restore the Octorok in the Lost Woods area which leads to Zora's River" -Credits "Admentus"
    CreateReduxCheckBox -Name "PotsChallenge"    -Safe  -Text "Pots Challenge"      -Info "Throw pots at your enemies to defeat them! Pots everywhere!"            -Credits "Aegiker"
    CreateReduxCheckBox -Name "NoBottledFairy"          -Text "No Bottled Fairies"  -Info "Fairies can no longer be put into a bottle"                             -Credits "Admentus & Three Pendants"
    CreateReduxCheckBox -Name "NoFairyDrops"            -Text "No Fairy Drops"      -Info "Flexible Items will no longer drop fairies"                             -Credits "Admentus"
    CreateReduxCheckBox -Name "RefightBosses"           -Text "Refight Bosses"      -Info "Bosses can be fought again after being defeated"                        -Credits "Euler" -Warning "Doesn't work on already defeated bosses prior to patching"

    CreateReduxGroup    -Tag  "Hero"          -Text "Hero Mode (Harder Enemies)" -Lite
    CreateReduxCheckBox -Name "Guay"          -Text "Guay"           -Info "Guays attack faster and move further"                                                                                                                                                                              -Credits "Anthrogi"
    CreateReduxCheckBox -Name "HandMaster"    -Text "Handmaster"     -Info "Wallmasters drop from above much quicker`nFloormasters attack faster and suffers less lag on miss or impact against player`nSmaller Floormasters jump and start chasing from further away and drain health faster" -Credits "Anthrogi"
    CreateReduxCheckBox -Name "ReDead"        -Text "ReDead"         -Info "ReDeads/Gibdos chase the player more quickly and efficiently, while also draining health faster"                                                                                                                   -Credits "Anthrogi"
    CreateReduxCheckBox -Name "LikeLike"      -Text "Like-Like"      -Info "Like-Likes move faster and notice the player from much further away"                                                                                                                                               -Credits "Anthrogi"
    CreateReduxCheckBox -Name "Octorok"       -Text "Octorok"        -Info "Octoroks appear from more distance away from the player and shoot projectiles much faster at quicker intervals"                                                                                                    -Credits "Anthrogi"
    CreateReduxCheckBox -Name "Tektite"       -Text "Tektite"        -Info "Tektites chase the player more effectively and lunge with greater reach"                                                                                                                                           -Credits "Anthrogi"
    CreateReduxCheckBox -Name "DekuScrub"     -Text "Scrub"          -Info "All enemy deku scrub variations will shoot their projectiles faster"                                                                                                                                               -Credits "Anthrogi"
    CreateReduxCheckBox -Name "GohmaLarva"    -Text "Gohma Larva"    -Info "Gohma Larvas are faster and reach further"                                                                                                                                                                         -Credits "Euler & Anthrogi"
    CreateReduxCheckBox -Name "Skulltula"     -Text "Skulltula"      -Info "Skulltula attacks hit harder"                                                                                                                                                                                      -Credits "Admentus"
    CreateReduxCheckBox -Name "Keese"         -Text "Keese"          -Info "Keese attack faster and move further, as well as not lose their fire when impacting the player"                                                                                                                    -Credits "Euler & Anthrogi"
    CreateReduxCheckBox -Name "Wolfos"        -Text "Wolfos"         -Info "Wolfos will attack faster and do not falter from having attacks blocked`nThey also attack when z-targeting another enemy"                                                                                          -Credits "BilonFullHDemon & Anthrogi"
    CreateReduxCheckBox -Name "Lizalfos"      -Text "Lizalfos"       -Info "Lizalfos/Dinolfos will attack faster and do not falter from having attacks blocked`nThey also attack when z-targeting another enemy"                                                                               -Credits "Nokaubure, Euler & Anthrogi"
    CreateReduxCheckBox -Name "Stalfos"       -Text "Stalfos"        -Info "Stalfos will attack you even not Z-Targeted and their attacks hit harder"                                                                                                                                          -Credits "Nokaubure, BilonFullHDemon & Admentus"
    CreateReduxCheckBox -Name "FlareDancer"   -Text "FlareDancer"    -Info "Flare Dancers now deal damage when running into them"                                                                                                                                                              -Credits "Euler"
    CreateReduxCheckBox -Name "DarkLink"      -Text "Dark Link"      -Info "Dark Link starts attacking you right away after spawning"                                                                                                                                                  -Base 4 -Credits "Nokaubure, BilonFullHDemon & Anthrogi"
    CreateReduxCheckBox -Name "DeadHand"      -Text "Dead Hand"      -Info "Dead Hands are faster and do not stay risen for long."                                                                                                                                                             -Credits "Euler & Anthrogi"
    CreateReduxCheckBox -Name "GerudoFighter" -Text "Gerudo Fighter" -Info "Gerudo Fighters deal twice as much damage"                                                                                                                                                                 -Base 4 -Credits "Euler"
    CreateReduxCheckBox -Name "IronKnuckle"   -Text "Iron Knuckle"   -Info "Iron Knuckles now move faster and recover from attacks faster"                                                                                                                                                     -Credits "Admentus & Anthrogi"
    CreateReduxCheckBox -Name "Gohma"         -Text "Gohma"          -Info "Gohma recovers faster from being stunned and replace objects with extra enemies in the boss arena"                                                                                                                 -Credits "Admentus, Euler & Anthrogi"
    CreateReduxCheckBox -Name "KingDodongo"   -Text "King Dodongo"   -Info "King Dodongo inhales faster and is no longer stunned and replace objects with extra enemies in the boss arena"                                                                                                     -Credits "Admentus, Euler & Anthrogi"
    CreateReduxCheckBox -Name "Barinade"      -Text "Barinade"       -Info "Replace objects with extra enemies in the boss arena"                                                                                                                                                       -Scene -Credits "Admentus"


    
    # RECOVERY #

    CreateReduxGroup   -Tag  "Recovery"    -Text "Recovery" -Height 4
    CreateReduxTextBox -Name "Heart"       -Text "Recovery Heart" -Value 16  -Min 0 -Max 320 -Length 3 -Info "Set the amount of health that Recovery Hearts will replenish`nRecovery Heart drops are removed if set to 0" -Credits "Admentus, Three Pendants & Randomizer (No Heart Drops)"
    CreateReduxTextBox -Name "Fairy"       -Text "Fairy"          -Value 128 -Min 0 -Max 320 -Length 3 -Info "Set the amount of health that a Fairy will replenish"                                                       -Credits "Admentus"
    CreateReduxTextBox -Name "FairyBottle" -Text "Fairy (Bottle)" -Value 320 -Min 0 -Max 320 -Length 3 -Info "Set the amount of health that a Bottled Fairy will replenish"                                               -Credits "Admentus & Three Pendants"
    CreateReduxTextBox -Name "FairyRevive" -Text "Fairy (Revive)" -Value 320 -Min 0 -Max 320 -Length 3 -Info "Set the amount of health that a Bottled Fairy will replenish after Link died"                               -Credits "Admentus & Three Pendants"; $Last.Row++
    CreateReduxTextBox -Name "Milk"        -Text "Milk"           -Value 80  -Min 0 -Max 320 -Length 3 -Info "Set the amount of health that Milk will replenish"                                                          -Credits "Admentus & Three Pendants"
    CreateReduxTextBox -Name "RedPotion"   -Text "Red Potion"     -Value 320 -Min 0 -Max 320 -Length 3 -Info "Set the amount of health that a Red Potion will replenish"                                                  -Credits "Admentus & Three Pendants"

    $Redux.Recovery.HeartLabel       = CreateLabel -X $Redux.Recovery.Heart.Left       -Y ($Redux.Recovery.Heart.Bottom       + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.Heart.text/16,       1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.FairyLabel       = CreateLabel -X $Redux.Recovery.Fairy.Left       -Y ($Redux.Recovery.Fairy.Bottom       + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.Fairy.text/16,       1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.FairyBottleLabel = CreateLabel -X $Redux.Recovery.FairyBottle.Left -Y ($Redux.Recovery.FairyBottle.Bottom + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.FairyBottle.text/16, 1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.FairyReviveLabel = CreateLabel -X $Redux.Recovery.FairyRevive.Left -Y ($Redux.Recovery.FairyRevive.Bottom + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.FairyRevive.text/16, 1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.MilkLabel        = CreateLabel -X $Redux.Recovery.Milk.Left        -Y ($Redux.Recovery.Milk.Bottom        + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.Milk.text/16,        1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.RedPotionLabel   = CreateLabel -X $Redux.Recovery.RedPotion.Left   -Y ($Redux.Recovery.RedPotion.Bottom   + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.RedPotion.text/16,   1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.Heart.Add_TextChanged(       { if ($this.text -eq "16") { $Redux.Recovery.HeartLabel.Text       = "(1 Heart)" } else { $Redux.Recovery.HeartLabel.Text       = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )
    $Redux.Recovery.Fairy.Add_TextChanged(       { if ($this.text -eq "16") { $Redux.Recovery.FairyLabel.Text       = "(1 Heart)" } else { $Redux.Recovery.FairyLabel.Text       = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )
    $Redux.Recovery.FairyBottle.Add_TextChanged( { if ($this.text -eq "16") { $Redux.Recovery.FairyBottleLabel.Text = "(1 Heart)" } else { $Redux.Recovery.FairyBottleLabel.Text = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )
    $Redux.Recovery.FairyRevive.Add_TextChanged( { if ($this.text -eq "16") { $Redux.Recovery.FairyReviveLabel.Text = "(1 Heart)" } else { $Redux.Recovery.FairyReviveLabel.Text = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )
    $Redux.Recovery.Milk.Add_TextChanged(        { if ($this.text -eq "16") { $Redux.Recovery.MilkLabel.Text        = "(1 Heart)" } else { $Redux.Recovery.MilkLabel.Text        = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )
    $Redux.Recovery.RedPotion.Add_TextChanged(   { if ($this.text -eq "16") { $Redux.Recovery.RedPotionLabel.Text   = "(1 Heart)" } else { $Redux.Recovery.RedPotionLabel.Text   = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )



    # MAGIC #

    CreateReduxGroup   -Tag  "Magic"       -Text "Magic Costs"
    CreateReduxTextBox -Name "FireArrow"   -Text "Fire Arrow"    -Value 4  -Max 96 -Info "Set the magic cost for using Fire Arrows´n48 is the maximum amount of the standard magic meter´n96 is the maximum amount of the double magic meter"   -Credits "Admentus"
    CreateReduxTextBox -Name "IceArrow"    -Text "Ice Arrow"     -Value 4  -Max 96 -Info "Set the magic cost for using Ice Arrows´n48 is the maximum amount of the standard magic meter´n96 is the maximum amount of the double magic meter"    -Credits "Admentus"
    CreateReduxTextBox -Name "LightArrow"  -Text "Light Arrow"   -Value 8  -Max 96 -Info "Set the magic cost for using Light Arrows´n48 is the maximum amount of the standard magic meter´n96 is the maximum amount of the double magic meter"  -Credits "Admentus"
    CreateReduxTextBox -Name "DinsFire"    -Text "Din's Fire"    -Value 12 -Max 96 -Info "Set the magic cost for using Din's Fire´n48 is the maximum amount of the standard magic meter´n96 is the maximum amount of the double magic meter"    -Credits "Admentus"
    CreateReduxTextBox -Name "FaroresWind" -Text "Farore's Wind" -Value 12 -Max 96 -Info "Set the magic cost for using Farore's Wind´n48 is the maximum amount of the standard magic meter´n96 is the maximum amount of the double magic meter" -Credits "Admentus"
    CreateReduxTextBox -Name "NayrusLove"  -Text "Nayru's Love"  -Value 24 -Max 96 -Info "Set the magic cost for using Nayru's Love´n48 is the maximum amount of the standard magic meter´n96 is the maximum amount of the double magic meter"  -Credits "Admentus"



    # MINIGAMES #

    CreateReduxGroup    -Tag  "Minigames"           -Base 5 -Text "Minigames"

    CreateReduxTextBox  -Name "ShootingGalleryAmmo" -Base 3 -Text "Shooting Gallery Ammo"   -Info "Set the amount of ammo for the shooting gallery minigames"                              -Value 15   -Min 10  -Max 50   -Length 2 -Credits "Admentus" -Shift (-20)
    CreateReduxTextBox  -Name "BowlingAlleyAmmo"    -Base 3 -Text "Bowling Alley Ammo"      -Info "Set the amount of ammo for the bombchu bowling alley minigame"                          -Value 10   -Min 5   -Max 50   -Length 2 -Credits "Admentus" -Shift (-20)
    CreateReduxTextBox  -Name "ArcheryRangeAmmo"    -Base 4 -Text "Archery Range Ammo"      -Info "Set the amount of ammo for the horseback archery range minigame"                        -Value 20   -Min 10  -Max 50   -Length 2 -Credits "Admentus" -Shift (-20)
    CreateReduxTextBox  -Name "ArcheryRangeScore1"  -Base 4 -Text "Archery Range Score (1)" -Info "Set the amount of score needed to win the Piece of Heart in the Horse Archery minigame" -Value 1000 -Min 30  -Max 2000 -Length 4 -Credits "Admentus" -Shift (-20)
    CreateReduxTextBox  -Name "ArcheryRangeScore2"  -Base 4 -Text "Archery Range Score (2)" -Info "Set the amount of score needed to win the Quiver upgrade in the Horse Archery minigame" -Value 1500 -Min 30  -Max 2000 -Length 4 -Credits "Admentus" -Shift (-20)
    CreateReduxCheckBox -Name "Dampe"               -Base 4 -Text "Dampé's Digging"         -Info "Dampé's Digging Game is always first try"                                                                                                                             -Credits "Randomizer"
    CreateReduxCheckBox -Name "SkullKidOcarina"     -Base 4 -Text "Skull Kid Ocarina"       -Info "Make each Skull Kid Ocarina Minigame round last shorter"                                                                                                              -Credits "Admentus"
    CreateReduxCheckBox -Name "LessDemandingFishing"        -Text "Less Demanding Fishing"  -Info "Fishing has less demanding size requirements and are found in smaller sizes`nEnable Redux for the full version"                                                       -Credits "Randomizer"
    CreateReduxCheckBox -Name "GuaranteedFishing"           -Text "Guaranteed Fishing"      -Info "Make fish bites guaranteed when the hook of the rod is stable and fish will no longer randomly let go when trying to reel them in`nEnable Redux for the full version" -Credits "Randomizer"
    CreateReduxCheckBox -Name "Bowling"                     -Text "Bombchu Bowling"         -Info "Bombchu Bowling prizes now appear in fixed order instead of random"                                                                       -Exclude "New Master Quest" -Credits "Randomizer"

    CreateReduxComboBox -Name "Bowling1" -Exclude "New Master Quest" -Text "Bowling Reward #1" -Items ("Piece of Heart", "Bomb Bag", "Purple Rupee", "Bombchus") -Values @("64", "28", "4C", "58") -Info "Set the first reward for the Bombchu Bowling Minigame"              -Credits "Randomizer" -Default 1
    CreateReduxComboBox -Name "Bowling2" -Exclude "New Master Quest" -Text "Bowling Reward #2" -Items ("Piece of Heart", "Bomb Bag", "Purple Rupee", "Bombchus") -Values @("64", "28", "4C", "58") -Info "Set the second reward for the Bombchu Bowling Minigame"             -Credits "Randomizer" -Default 2
    CreateReduxComboBox -Name "Bowling3" -Exclude "New Master Quest" -Text "Bowling Reward #3" -Items ("Piece of Heart", "Bomb Bag", "Purple Rupee", "Bombchus") -Values @("64", "28", "4C", "58") -Info "Set the third reward for the Bombchu Bowling Minigame"              -Credits "Randomizer" -Default 4
    CreateReduxComboBox -Name "Bowling4" -Exclude "New Master Quest" -Text "Bowling Reward #4" -Items ("Piece of Heart", "Bomb Bag", "Purple Rupee", "Bombchus") -Values @("64", "28", "4C", "58") -Info "Set the fourth reward for the Bombchu Bowling Minigame"             -Credits "Randomizer" -Default 3
    CreateReduxComboBox -Name "Bowling5" -Exclude "New Master Quest" -Text "Bowling Reward #5" -Items ("Piece of Heart", "Bomb Bag", "Purple Rupee", "Bombchus") -Values @("64", "28", "4C", "58") -Info "Set the fifth reward for the Bombchu Bowling Minigame"              -Credits "Randomizer" -Default 3

    if ($Redux.Minigames.Bowling -ne $null) {
        $Redux.Minigames.Bowling.Add_CheckedChanged({ $Redux.Minigames.Bowling1.enabled = $Redux.Minigames.Bowling2.enabled = $Redux.Minigames.Bowling3.enabled = $Redux.Minigames.Bowling4.enabled = $Redux.Minigames.Bowling5.enabled = $this.checked })
        $Redux.Minigames.Bowling1.enabled = $Redux.Minigames.Bowling2.enabled = $Redux.Minigames.Bowling3.enabled = $Redux.Minigames.Bowling4.enabled = $Redux.Minigames.Bowling5.enabled = $Redux.Minigames.Bowling.checked
    }

    if ($Redux.Minigames.ArcheryRangeScore1 -ne $null) {
        $Redux.Minigames.ArcheryRangeScore1.Add_LostFocus({
            if ([int16]$Redux.Minigames.ArcheryRangeScore2.Text -le [int16]$Redux.Minigames.ArcheryRangeScore1.Text ) {
                $value = [int16]$Redux.Minigames.ArcheryRangeScore1.Text + 1
                if ($value -gt 2000) { $value = 2000 }
                $Redux.Minigames.ArcheryRangeScore2.Text = $value
            }
        })

        $Redux.Minigames.ArcheryRangeScore2.Add_LostFocus({
            if ([int16]$Redux.Minigames.ArcheryRangeScore2.Text -le [int16]$Redux.Minigames.ArcheryRangeScore1.Text ) {
                $value = [int16]$Redux.Minigames.ArcheryRangeScore1.Text + 1
                if ($value -gt 2000) { $value = 2000 }
                $Redux.Minigames.ArcheryRangeScore2.Text = $value
            }
        })
    }



    # EASY MODE #

    CreateReduxGroup    -Tag  "EasyMode"                    -Text "Easy Mode"
    CreateReduxTextBox  -Name "GhostShopPoints"     -Base 4 -Text "Ghost Shop Points"     -Info "Set the amount of Big Poes you need to catch for the bottle reward"                 -Value 10 -Min 1 -Max 10 -Length 2 -Credits "Euler"
    CreateReduxCheckbox -Name "NoShieldSteal"               -Text "No Shield Steal"       -Info "Like-Likes will no longer steal the Deku Shield or Hylian Shield from Link"                                            -Credits "Admentus"
    CreateReduxCheckbox -Name "NoTunicSteal"                -Text "No Tunic Steal"        -Info "Like-Likes will no longer steal the Goron Tunic or Zora Tunic from Link"                                               -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "SkipStealthSequence" -Base 3 -Text "Skip Stealth Sequence" -Info "Skip the Castle Courtyard Stealth Sequence and allows you to go straight to the Inner Courtyard"                       -Credits "Randomizer"
    CreateReduxCheckBox -Name "SkipTowerEscape"     -Base 3 -Text "Skip Tower Escape"     -Info "Skip the Ganon's Tower Escape Sequence and allows you to go straight to the Ganon boss fight"                          -Credits "Randomizer"
    CreateReduxCheckBox -Name "HotRodderGoron"      -Base 5 -Text "Hot Rodder Goron"      -Info "The Hot Rodder Goron no longer needs to be stopped in a specific location before rewarding you with a bigger bomb bag" -Credits "Admentus"
    CreateReduxCheckBox -Name "GerudoFighterJail"   -Base 4 -Text "Gerudo Fighter Jail"   -Info "You're no longer send to jail when hit by the spin attack from a Gerudo Fighter"                                       -Credits "Euler"

}



#==============================================================================================================================================================================================
function CreateTabColors() {
    
    # EQUIPMENT COLORS #

    CreateReduxGroup -Tag "Colors" -Text "Equipment Colors"
    $Redux.Colors.Equipment = @(); $Buttons = @(); $Redux.Colors.SetEquipment = @()
    $items1 = @("Kokiri Green", "Goron Red", "Zora Blue"); $postItems = @("Randomized", "Custom"); $Files = ($GameFiles.Textures + "\Tunic"); $Randomize = '"Randomized" fully randomizes the colors each time the patcher is opened'
    $Items2 = @("Silver", "Gold", "Black", "Green", "Blue", "Bronze", "Red", "Sky Blue", "Pink", "Magenta", "Orange", "Lime", "Purple", "Randomized", "Custom")
    $Items3 = @("Red", "Green", "Blue", "Yellow", "Cyan", "Magenta", "Orange", "Gold", "Purple", "Pink", "Randomized", "Custom")
    if (StrLike -Str $GamePatch.settings -Val "Gold Quest") { $items = @("Gold Quest Gold", "Gold Quest Purple", "Gold Quest White") + $items1 }
    
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "KokiriTunic"                -Text "Kokiri Tunic"        -Default 1 -Length 230 -Items $items1 -PostItems $postItems -FilePath $Files -Info ("Select a color scheme for the Kokiri Tunic`n" + $Randomize) -Credits "Randomizer"
    $Buttons += CreateReduxButton -Tag $Buttons.Count        -Text "Kokiri Tunic"     -Info "Select the color you want for the Kokiri Tunic" -Credits "Randomizer"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "GoronTunic"                 -Text "Goron Tunic"         -Default 2 -Length 230 -Items $items1 -PostItems $postItems -FilePath $Files -Info ("Select a color scheme for the Goron Tunic`n"  + $Randomize) -Credits "Randomizer"
    $Buttons += CreateReduxButton -Tag $Buttons.Count        -Text "Goron Tunic"      -Info "Select the color you want for the Goron Tunic"  -Credits "Randomizer"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "ZoraTunic"                  -Text "Zora Tunic"          -Default 3 -Length 230 -Items $items1 -PostItems $postItems -FilePath $Files -Info ("Select a color scheme for the Zora Tunic`n"   + $Randomize) -Credits "Randomizer"
    $Buttons += CreateReduxButton -Tag $Buttons.Count        -Text "Zora Tunic"       -Info "Select the color you want for the Zora Tunic"   -Credits "Randomizer"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "SilverGauntlets" -Adult     -Text "Silver Gauntlets"    -Default 1 -Length 230 -Items $Items2 -Info ("Select a color scheme for the Silver Gauntlets`n" + $Randomize) -Credits "Randomizer"
    $Buttons += CreateReduxButton -Tag $Buttons.Count -Adult -Text "Silver Gaunlets"  -Info "Select the color you want for the Silver Gauntlets"           -Credits "Randomizer"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "GoldenGauntlets"   -Adult   -Text "Golden Gauntlets"    -Default 2 -Length 230 -Items $Items2 -Info ("Select a color scheme for the Golden Gauntlets`n" + $Randomize) -Credits "Randomizer"
    $Buttons += CreateReduxButton -Tag $Buttons.Count -Adult -Text "Golden Gauntlets" -Info "Select the color you want for the Golden Gauntlets"           -Credits "Randomizer"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "MirrorShieldFrame" -Adult   -Text "Mirror Shield Frame" -Default 1 -Length 230 -Items $Items3 -Info ("Select a color scheme for the Mirror Shield Frame`n" + $Randomize) -Warning "This option might not work for every custom player model" -Credits "Randomizer"
    $Buttons += CreateReduxButton -Tag $Buttons.Count -Adult -Text "Mirror Shield"    -Info "Select the color you want for the frame of the Mirror Shield" -Credits "Randomizer"
    
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "1E691B" -Name "SetKokiriTunic" -IsGame -Button $Buttons[0]
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "641400" -Name "SetGoronTunic"  -IsGame -Button $Buttons[1]
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "003C64" -Name "SetZoraTunic"   -IsGame -Button $Buttons[2]
    if ($Redux.Colors.SilverGauntlets -ne $null) {
        $Redux.Colors.SetEquipment += CreateColorDialog -Color "FFFFFF" -Name "SetSilverGauntlets"   -IsGame -Button $Buttons[3]
        $Redux.Colors.SetEquipment += CreateColorDialog -Color "FECF0F" -Name "SetGoldenGauntlets"   -IsGame -Button $Buttons[4]
        $Redux.Colors.SetEquipment += CreateColorDialog -Color "D70000" -Name "SetMirrorShieldFrame" -IsGame -Button $Buttons[5]
    }

    $Redux.Colors.EquipmentLabels = @()
    for ($i=0; $i -lt $Buttons.length; $i++) {
        if ($Buttons[$i] -eq $null) { break }
        $Buttons[$i].Add_Click({ $Redux.Colors.SetEquipment[[uint16]$this.Tag].ShowDialog(); $Redux.Colors.Equipment[[uint16]$this.Tag].Text = "Custom"; $Redux.Colors.EquipmentLabels[[uint16]$this.Tag].BackColor = $Redux.Colors.SetEquipment[[uint16]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetEquipment[[uint16]$this.Tag].Tag] = $Redux.Colors.SetEquipment[[uint16]$this.Tag].Color.Name })
        if ($i -lt 3)   { $Redux.Colors.EquipmentLabels += CreateReduxColoredLabel        -Link $Buttons[$i] -Color $Redux.Colors.SetEquipment[$i].Color }
        else            { $Redux.Colors.EquipmentLabels += CreateReduxColoredLabel -Adult -Link $Buttons[$i] -Color $Redux.Colors.SetEquipment[$i].Color }
    }

    $Redux.Colors.Equipment[0].Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[0] -Dialog $Redux.Colors.SetEquipment[0] -Label $Redux.Colors.EquipmentLabels[0] })
                                                          SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[0] -Dialog $Redux.Colors.SetEquipment[0] -Label $Redux.Colors.EquipmentLabels[0]
    $Redux.Colors.Equipment[1].Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[1] -Dialog $Redux.Colors.SetEquipment[1] -Label $Redux.Colors.EquipmentLabels[1] })
                                                          SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[1] -Dialog $Redux.Colors.SetEquipment[1] -Label $Redux.Colors.EquipmentLabels[1]
    $Redux.Colors.Equipment[2].Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[2] -Dialog $Redux.Colors.SetEquipment[2] -Label $Redux.Colors.EquipmentLabels[2] })
                                                          SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[2] -Dialog $Redux.Colors.SetEquipment[2] -Label $Redux.Colors.EquipmentLabels[2]

    if ($Redux.Colors.SilverGauntlets -ne $null) {
        $Redux.Colors.Equipment[3].Add_SelectedIndexChanged({ SetGauntletsColorsPreset         -ComboBox $Redux.Colors.Equipment[3] -Dialog $Redux.Colors.SetEquipment[3] -Label $Redux.Colors.EquipmentLabels[3] })
                                                              SetGauntletsColorsPreset         -ComboBox $Redux.Colors.Equipment[3] -Dialog $Redux.Colors.SetEquipment[3] -Label $Redux.Colors.EquipmentLabels[3]
        $Redux.Colors.Equipment[4].Add_SelectedIndexChanged({ SetGauntletsColorsPreset         -ComboBox $Redux.Colors.Equipment[4] -Dialog $Redux.Colors.SetEquipment[4] -Label $Redux.Colors.EquipmentLabels[4] })
                                                              SetGauntletsColorsPreset         -ComboBox $Redux.Colors.Equipment[4] -Dialog $Redux.Colors.SetEquipment[4] -Label $Redux.Colors.EquipmentLabels[4]
        $Redux.Colors.Equipment[5].Add_SelectedIndexChanged({ SetMirrorShieldFrameColorsPreset -ComboBox $Redux.Colors.Equipment[5] -Dialog $Redux.Colors.SetEquipment[5] -Label $Redux.Colors.EquipmentLabels[5] })
                                                              SetMirrorShieldFrameColorsPreset -ComboBox $Redux.Colors.Equipment[5] -Dialog $Redux.Colors.SetEquipment[5] -Label $Redux.Colors.EquipmentLabels[5]
    }


    # COLORS #

    CreateSpinAttackColorOptions
    CreateSwordTrailColorOptions



    # FAIRY COLORS #

    CreateFairyColorOptions -Name "Navi"
    CreateReduxCheckBox     -Name "BetaNavi" -Text "Beta Navi Colors" -Info "Use the Beta colors for Navi"
    $Redux.Colors.BetaNavi.Add_CheckedChanged({ EnableElem -Elem $Redux.Colors.Fairy -Active (!$this.checked) })
    EnableElem -Elem $Redux.Colors.Fairy -Active (!$Redux.Colors.BetaNavi.Checked)



    # RUPEE ICON COLOR #

    if (StrLike -Str $GamePatch.settings -Val "Gold Quest") { $preset = 5; $color = "FFFF00" } else { $preset = 1; $color = "C8FF64" }
    CreateRupeeVanillaColorOptions -Preset $preset -Color $color



    # MISC COLORS #

    CreateReduxGroup -Tag "Colors" -Text "Misc Colors"

    CreateReduxCheckBox -Name "PauseScreenColors" -Text "MM Pause Screen Colors" -Info "Use the Pause Screen color scheme from Majora's Mask" -Credits "Garo-Mastah"

}



#==============================================================================================================================================================================================
function CreateTabEquipment() {
    
    # UNLOCK CHILD RESTRICTIONS #

    CreateReduxGroup    -Tag  "Unlock"        -Text "Unlock Child Restrictions" -Child
    CreateReduxCheckBox -Name "Tunics"        -Text "Unlock Tunics"        -Info "Child Link is able to use the Goron Tunic and Zora Tunic`nSince you might want to walk around in style as well when you are young.`nThe dialogue script will be adjusted to reflect this (only for English)`nChild Link will be also able to purchase them aswell" -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "MasterSword"   -Text "Unlock Master Sword"  -Info "Child Link is able to use the Master Sword`nThe Master Sword does twice as much damage as the Kokiri Sword"                                          -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "GiantsKnife"   -Text "Unlock Giant's Knife" -Info "Child Link is able to use the Giant's Knife / Biggoron Sword`nThe Giant's Knife / Biggoron Sword does four times as much damage as the Kokiri Sword" -Credits "GhostlyDark" -Warning "The Giant's Knife / Biggoron Sword appears as if Link if thrusting the sword through the ground"
    CreateReduxCheckBox -Name "MirrorShield"  -Text "Unlock Mirror Shield" -Info "Child Link is able to use the Mirror Shield"                                                                                                         -Credits "GhostlyDark" -Warning "The Mirror Shield will look like the Deku Shield for Child Link"
    CreateReduxCheckBox -Name "Boots"         -Text "Unlock Boots"         -Info "Child Link is able to use the Iron Boots and Hover Boots"                                                                                            -Credits "GhostlyDark" -Warning "The Iron and Hover Boots appears as the Kokiri Boots"
    CreateReduxCheckBox -Name "Gauntlets"     -Text "Unlock Gauntlets"     -Info "Child Link is able to use the Silver and Golden Gauntlets"                                                                                           -Credits "Admentus (ROM) & Aegiker (RAM)"
    CreateReduxCheckBox -Name "MegatonHammer" -Text "Unlock Hammer"        -Info "Child Link is able to use the Megaton Hammer"                                                                                                        -Credits "GhostlyDark"



    # UNLOCK ADULT RESTRICTIONS #

    CreateReduxGroup    -Tag  "Unlock"         -Text "Unlock Adult Restrictions" -Adult
    CreateReduxCheckBox -Name "KokiriSword"    -Text "Unlock Kokiri Sword" -Info "Adult Link is able to use the Kokiri Sword`nThe Kokiri Sword does half as much damage as the Master Sword" -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "DekuShield"     -Text "Unlock Deku Shield"  -Info "Adult Link is able to use the Deku Shield"                                                                 -Credits "GhostlyDark" -Warning "The Deku Shield appears as invisible but can still be burned up by fire"
    CreateReduxCheckBox -Name "FairySlingshot" -Text "Unlock Slingshot"    -Info "Adult Link is able to use the Fairy Slingshot"                                                             -Credits "GhostlyDark" -Warning "The Fairy Slingshot appears as the Fairy Bow"
    CreateReduxCheckBox -Name "Boomerang"      -Text "Unlock Boomerang"    -Info "Adult Link is able to use the Boomerang"                                                                   -Credits "GhostlyDark" -Warning "The Boomerang appears as invisible"
    CreateReduxCheckBox -Name "DekuSticks"     -Text "Unlock Deku Sticks"  -Info "Adult Link is able to use the Deku Sticks"                                                                 -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "CrawlHole"      -Text "Unlock Crawl Hole"   -Info "Adult Link can now crawl through holes"                                                            -Native -Credits "Admentus"



    # EQUIPMENT #

    CreateReduxGroup    -Tag  "Equipment"                  -Text "Equipment Adjustments"
    CreateReduxCheckBox -Name "HideSword"                  -Text "Hide Sword"                  -Info "The sword is hidden when sheathed"                                                             -Credits "Admentus"
    CreateReduxCheckBox -Name "NoSlipperyBoots"     -Adult -Text "No Slippery Boots"           -Info "The Hover Boots are no longer slippery"                                                        -Credits "Admentus" 
    CreateReduxCheckBox -Name "HideShield"                 -Text "Hide Shield"                 -Info "The shield is hidden when sheathed"                                                            -Credits "Admentus"
    CreateReduxCheckBox -Name "UnsheathSword"              -Text "Unsheath Sword"              -Info "The sword is unsheathed first before immediately swinging it"                                  -Credits "Admentus"
    CreateReduxCheckBox -Name "FireproofDekuShield" -Child -Text "Fireproof Deku Shield"       -Info "The Deku Shield turns into an fireproof shield, which will not burn up anymore"                -Credits "Admentus (ported) & Three Pendants (ROM patch)"
    CreateReduxCheckBox -Name "FunctionalWeapons"          -Text "Functional Weapons"          -Info "All melee weapons are useable against enemies, except for obvious boss reasons"                -Credits "Admentus"
    CreateReduxCheckBox -Name "HerosBow"            -Adult -Text "Hero's Bow"                  -Info "Replace the Fairy Bow textures and text with the Hero's Bow"                                   -Credits "GhostlyDark (ported) & Admentus (dialogue)"
    CreateReduxCheckBox -Name "PowerBracelet"       -Child -Text "Power Bracelet"              -Info "Replace the Goron's Bracelet textures and text with the Power Bracelet"                        -Credits "Admentus"
    CreateReduxCheckBox -Name "Hookshot"            -Adult -Text "Termina Hookshot"            -Info "Replace the Hyrule Hookshot icon with the Termina Hookshot"                                    -Credits "GhostlyDark (ported)"
    CreateReduxCheckBox -Name "GoronBraceletFix"    -Adult -Text "Keep Goron's Bracelet Color" -Info "Prevent grayscale on Goron's Bracelet, as Adult Link isn't able to push big blocks without it" -Credits "Randomizer"
    CreateReduxTextBox  -Name "SwordHealth"         -Adult -Text "Sword Health"      -Length 3 -Info "Set the amount of hits the Giant's Knife can take before it breaks"   -Value 8 -Min 1 -Max 255 -Credits "Admentus" 

    CreateReduxGroup    -Tag  "Equipment"            -Text "Swords & Shields"
    CreateReduxComboBox -Name "KokiriSword"   -Child -Text "Kokiri Sword"     -Items @("Kokiri Sword")                      -Shift (-15) -FilePath ($GameFiles.Textures + "\Equipment\Kokiri Sword") -Ext @("icon", "bin") -Info "Select an alternative for the icon and text of the Kokiri Sword"     -Credits "Admentus (injects) & GhostlyDark (injects) & CYB3RTR0N (beta icon)"
    CreateReduxComboBox -Name "MasterSword"   -Adult -Text "Master Sword"     -Items @("Master Sword")                      -Shift (-15) -FilePath ($GameFiles.Textures + "\Equipment\Master Sword") -Ext @("icon", "bin") -Info "Select an alternative for the icon and text of the Master Sword"     -Credits "Admentus (injects) & GhostlyDark (injects) & CYB3RTR0N (beta icon)"
    CreateReduxComboBox -Name "GiantsKnife"   -Adult -Text "Giant's Knife"    -Items @("Giant's Knife", "Biggoron's Sword") -Shift (-15) -FilePath ($GameFiles.Textures + "\Equipment\Master Sword") -Ext @("icon", "bin") -Info "Select an alternative for the icon and text of the Giant's Knife"    -Credits "Admentus (injects) & GhostlyDark (injects) & CYB3RTR0N (beta icon)"
    CreateReduxComboBox -Name "BiggoronSword" -Adult -Text "Biggoron's Sword" -Items @("Biggoron's Sword", "Giant's Knife") -Shift (-15) -FilePath ($GameFiles.Textures + "\Equipment\Master Sword") -Ext @("icon", "bin") -Info "Select an alternative for the icon and text of the Biggoron's Sword" -Credits "Admentus (injects) & GhostlyDark (injects) & CYB3RTR0N (beta icon)"

    if (StrLike -Str $GamePatch.settings -Val "Dawn & Dusk") { $item = "Dawn & Dusk Shield" } elseif (StrLike -Str $GamePatch.settings -Val "Gold Quest") { $item = "Gold Quest Shield" } else { $item = "Deku Shield" }
    CreateReduxComboBox -Name "DekuShield"   -Child -Text "Deku Shield"   -Items @("Deku Shield") -Default $item -Shift (-15) -FilePath ($GameFiles.Textures + "\Equipment\Deku Shield")   -Ext @("icon", "front", "back") -Info "Select an alternative for the appearence of the Deku Shield"   -Credits "Admentus (injects) & GhostlyDark (injects), ZombieBrainySnack (textures) & LuigiBlood (texture), Feonyx (No Symbol)"
    CreateReduxComboBox -Name "HylianShield"        -Text "Hylian Shield" -Items @("Hylian Shield")              -Shift (-15) -FilePath ($GameFiles.Textures + "\Equipment\Hylian Shield") -Ext @("icon", "front", "back") -Info "Select an alternative for the appearence of the Hylian Shield" -Credits "Admentus (injects) & GhostlyDark (injects), CYB3RTR0N (icons), sanguinetti (Beta / Red Shield textures), LuigiBlood (texture) & Feonyx (No Symbol)"
    CreateReduxComboBox -Name "MirrorShield" -Adult -Text "Mirror Shield" -Items @("Mirror Shield")              -Shift (-15) -FilePath ($GameFiles.Textures + "\Equipment\Mirror Shield") -Ext @("icon", "front", "back") -Info "Select an alternative for the appearence of the Mirror Shield" -Credits "Admentus (injects) & GhostlyDark (injects)"

     

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

    CreateReduxGroup  -Tag  "Hitbox"            -Text "Sliders"
    CreateReduxSlider -Name "KokiriSword"       -Child                -Default 3000 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Kokiri Sword"    -Info "Set the length of the hitbox of the Kokiri Sword"                   -Credits "Admentus"
    CreateReduxSlider -Name "MasterSword"       -Adult                -Default 4000 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Master Sword"    -Info "Set the length of the hitbox of the Master Sword"                   -Credits "Admentus"
    CreateReduxSlider -Name "GiantsKnife"       -Adult                -Default 5500 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Giant's Knife"   -Info "Set the length of the hitbox of the Giant's Knife / Biggoron Sword" -Credits "Admentus"
    CreateReduxSlider -Name "BrokenGiantsKnife" -Adult                -Default 1500 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Broken Knife"    -Info "Set the length of the hitbox of the Broken Giant's Knife"           -Credits "Admentus"
    CreateReduxSlider -Name "MegatonHammer"     -Adult -Expose "Dawn" -Default 2500 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Megaton Hammer"  -Info "Set the length of the hitbox of the Megaton Hammer"                 -Credits "Admentus"
    CreateReduxSlider -Name "ShieldRecoil"                            -Default 4552 -Min 0   -Max 8248 -Freq 512 -Small 256 -Large 512 -Text "Shield Recoil"   -Info "Set the pushback distance when getting hit while shielding"         -Credits "Admentus (ROM) & Aegiker (RAM)"
    CreateReduxSlider -Name "Hookshot"          -Adult                -Default 13   -Min 0   -Max 110  -Freq 10  -Small 5   -Large 10  -Text "Hookshot Length" -Info "Set the length of the Hookshot"                                     -Credits "Admentus"            -Warning "Going above the default length can look weird"
    if (StrLike -Str $GamePatch.settings -Val "Gold Quest") { $val = 26 } else { $val = 104 }
    CreateReduxSlider -Name "Longshot"          -Adult                -Default $val -Min 0   -Max 110  -Freq 10  -Small 5   -Large 10  -Text "Longshot Length" -Info "Set the length of the Longshot"                                     -Credits "Admentus & AndiiSyn" -Warning "Going above the default length can look weird"

    if ($Settings.Core.Lite) { return }



    # STARTING UPGRADES #

    if (StrLike -Str $GamePatch.settings -Val "Gold Quest") { $val = 2 } elseif (StrLike -Str $GamePatch.settings -Val "Bombiwa") { $val = 5 } else { $val = 3 }
    CreateReduxGroup    -Tag  "Save"              -Text "Starting Upgrades"
    CreateReduxComboBox -Name "DekuSticks" -Child -Text "Deku Sticks"     -Items ("Standard", "Big", "Biggest")                                         -Info "Set the starting capacity upgrade level for the Deku Sticks"
    CreateReduxComboBox -Name "DekuNuts"          -Text "Deku Nuts"       -Items ("Standard", "Big", "Biggest")                                         -Info "Set the starting capacity upgrade level for the Deku Nuts"
    CreateReduxComboBox -Name "BulletBag"  -Child -Text "Bullet Seed Bag" -Items ("Standard", "Big", "Biggest")                                         -Info "Set the starting capacity upgrade level for the Bullet Seed Bag"
    CreateReduxComboBox -Name "Quiver"     -Adult -Text "Quiver"          -Items ("Standard", "Big", "Biggest")                                         -Info "Set the starting capacity upgrade level for the Quiver"
    CreateReduxComboBox -Name "BombBag"           -Text "Bomb Bag"        -Items ("Standard", "Big", "Biggest")                                         -Info "Set the starting capacity upgrade level for the Bomb Bag"
    CreateReduxComboBox -Name "Strength"          -Text "Strength"        -Items ("None", "Goron's Bracelet", "Silver Gauntlets", "Golden Gauntlets")   -Info "Set the starting capacity upgrade level for the Bracelet / Gauntlets"
    CreateReduxComboBox -Name "Scale"             -Text "Scale"           -Items ("None", "Silver Scale", "Golden Scale")                               -Info "Set the starting capacity upgrade level for the Scale"
    CreateReduxComboBox -Name "Wallet"            -Text "Wallet"          -Items ("Base Wallet", "Adult's Wallet", "Giant's Wallet", "Tycoon's Wallet") -Info "Set the starting capacity upgrade level for the Wallet" -Warning 'The "Tycoon Wallet" is unused'
    CreateReduxTextBox  -Name "Rupees"            -Text "Rupees"          -Value 0 -Min 0 -Max 9999 -Length 4                                           -Info "Start a new save file with the chosen amount of Rupees"
    CreateReduxTextBox  -Name "Hearts"            -Text "Hearts"          -Value $val -Min 1 -Max 20                                                    -Info "Start a new save file with the chosen amount of hearts"
    CreateReduxCheckBox -Name "DoubleDefense"     -Text "Double Defense"                                                                                -Info "Start a new save file with the double defense upgrade"
    CreateReduxCheckBox -Name "Magic"             -Text "Magic"                                                                                         -Info "Start a new save file with the magic meter"
    CreateReduxCheckBox -Name "DoubleMagic"       -Text "Double Magic"                                                                                  -Info "Start a new save file with the double magic upgrade"



    # ADD STARTING SAVE SLOT PROGRESSION  #

    CreateReduxGroup -Tag  "Save" -Text "Add Starting Save Slot Progression"
    [System.Collections.ArrayList]$items = @()
    $items.AddRange(@("Kokiri's Emerald", "Goron's Ruby", "Zora's Sapphire", "Forest Medallion", "Fire Medallion", "Water Medallion", "Shadow Medallion", "Spirit Medallion", "Gerudo Card", "Stone of Agony"))
    $items.AddRange(@("Kokiri Sword", "Master Sword", "Giant's Knife", "Deku Shield", "Hylian Shield", "Mirror Shield", "Goron Tunic", "Zora Tunic", "Iron Boots", "Hover Boots"))
    $items.AddRange(@("Deku Stick", "Deku Nut", "Bomb", "Fairy Bow", "Fire Arrow", "Din's Fire", "Fairy Slingshot", "Fairy Ocarina", "Bombchu", "Hookshot", "Ice Arrow", "Farore's Wind", "Boomerang", "Lens of Truth", "Magic Bean", "Megaton Hammer", "Light Arrow", "Nayru's Love", "Bottle #1", "Bottle #2", "Bottle #3", "Bottle #4"))
    $items.AddRange(@("Zelda's Lullaby", "Epona's Song", "Saria's Song", "Sun's Song", "Song of Time", "Song of Storms", "Minuet of Forest", "Bolero of Fire", "Serenade of Water", "Requiem of Spirit", "Nocturne of Shadow", "Prelude of Light"))
    $items.AddRange(@("Small Keys", "Boss Keys", "Compasses", "Dungeon Maps"))
    CreateReduxListBox -Name "Progression" -Items $items -MultiColumn -MultiSelect -Columns 4 -Rows 4
   
    CreateReduxGroup    -Tag  "Save"              -Text "Add Starting Save Slot Progression"
    CreateReduxComboBox -Name "TradeSequenceItem" -Text "Trade Sequence Item"      -Info "Start a new save file with a Trade Sequence Item" -Items @("Empty", "Pocket Egg", "Pocket Cucco", "Cojiro", "Odd Mushroom", "Odd Potion", "Poacher's Saw", "Broken Goron's Sword", "Prescription", "Eyeball Frog", "World's Finest Eye Drops", "Claim Check")
    CreateReduxComboBox -Name "Mask"              -Text "Quest Item / Mask"        -Info "Start a new save file with a  Quest Item or Mask" -Items @("Empty", "Weird Egg", "Pocket Egg", "Zelda's Letter", "Keaton Mask", "Skull Mask", "Spooky Mask", "Bunny Hood", "Goron Mask", "Zora Mask", "Gerudo Mask", "Mask of Truth", "SOLD OUT")
    CreateReduxComboBox -Name "SkullKidMinigame"  -Text "Skull Kid Minigame"       -Info "Start a new save file with the selected round of the Skull Kid Ocarina Minigame you start at" -Items @("First Round", "Second Round", "Final Round")
    CreateReduxTextBox  -Name "GoldSkulltulas"    -Text "Gold Skulltulas" -Max 100 -Info "Start a new save file with the chosen amount of Gold Skulltulas"
    CreateReduxCheckBox -Name "BiggoronSword"     -Text "Biggoron Sword"           -Info "Upgrade the Giant's Knife into the Biggoron Sword"
    CreateReduxCheckBox -Name "OcarinaOfTime"     -Text "Ocarina of Time"          -Info "Upgrade the Fairy Ocarina into the Ocarina of Time"
    CreateReduxCheckBox -Name "LongShot"          -Text "Longshot"                 -Info "Upgrade the Hookshot into the Longshot"



    # REMOVE STARTING DEBUG SAVE SLOT PROGRESSION #

    CreateReduxGroup   -Tag  "Save"             -Text "Remove Starting Debug Save Slot Progression"
    CreateReduxListBox -Name "DebugProgression" -Items @("Small Keys", "Boss Keys", "Compasses", "Dungeon Maps", "Quest Status", "Items", "Equipment", "Upgrades") -MultiColumn -MultiSelect -Columns 4 -Rows 2.2

}



#==============================================================================================================================================================================================
function CreateTabCapacity() {
    
    # CAPACITY SELECTION #

    CreateReduxGroup    -Tag  "Capacity"      -Text "Capacity Selection"
    CreateReduxCheckBox -Name "EnableAmmo"    -Text "Change Ammo Capacity"       -Info "Enable changing the capacity values for ammo"
    CreateReduxCheckBox -Name "EnableWallet"  -Text "Change Wallet Capacity"     -Info "Enable changing the capacity values for the wallets"
    CreateReduxCheckBox -Name "EnableDrops"   -Text "Change Item Drops Quantity" -Info "Enable changing the amount which an item drop provides"
    CreateReduxCheckBox -Name "EnableShop"    -Text "Change Shop Items"          -Info "Enable changing the price and quantity of buying items from shops and which items shops have to offer"
    CreateReduxCheckBox -Name "DynamicWallet" -Text "Dynamic Wallet"             -Info "Rupee digits are dynamic and do not show any leading zeroes`nThis option is automaticially used on wallets using five digits"


    # AMMO CAPACITY #

    $Redux.Box.Ammo = CreateReduxGroup -Tag "Capacity" -Text "Ammo Capacity"

    if (StrLike -Str $GamePatch.settings -Val "Master of Time") { $val = 25 } else { $val = 30 }
    CreateReduxTextBox -Name "Quiver1"     -Adult -Text "Quiver (1)"      -Value $val -Info "Set the capacity for the Quiver (Base)"           -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver2"     -Adult -Text "Quiver (2)"      -Value 40   -Info "Set the capacity for the Quiver (Upgrade 1)"      -Credits "GhostlyDark"
    if (StrLike -Str $GamePatch.settings -Val "Master of Time") { $val = 99 } else { $val = 50 }
    CreateReduxTextBox -Name "Quiver3"     -Adult -Text "Quiver (3)"      -Value $val -Info "Set the capacity for the Quiver (Upgrade 2)"      -Credits "GhostlyDark"

    if ($Redux.Capacity.Quiver1 -ne $null) { $Last.Column = 1; $Last.Row++ }
    if (StrLike -Str $GamePatch.settings -Val "Master of Time") { $val = 15 } elseif (StrLike -Str $GamePatch.settings -Val "Gold Quest") { $val = 10 } else { $val = 20 }
    CreateReduxTextBox -Name "BombBag1"           -Text "Bomb Bag (1)"    -Value $val -Info "Set the capacity for the Bomb Bag (Base)"         -Credits "GhostlyDark" -Exclude "Dawn"
    CreateReduxTextBox -Name "BombBag2"           -Text "Bomb Bag (2)"    -Value 30   -Info "Set the capacity for the Bomb Bag (Upgrade 1)"    -Credits "GhostlyDark" -Exclude "Dawn"
    if (StrLike -Str $GamePatch.settings -Val "Master of Time") { $val = 99 } elseif (StrLike -Str $GamePatch.settings -Val "Gold Quest") { $val = 50 } else { $val = 40 }
    CreateReduxTextBox -Name "BombBag3"           -Text "Bomb Bag (3)"    -Value $val -Info "Set the capacity for the Bomb Bag (Upgrade 2)"    -Credits "GhostlyDark" -Exclude "Dawn"

    $Last.Column = 1; $Last.Row++
    CreateReduxTextBox -Name "BulletBag1"  -Child -Text "Bullet Bag (1)"  -Value 30   -Info "Set the capacity for the Bullet Bag (Base)"       -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BulletBag2"  -Child -Text "Bullet Bag (2)"  -Value 40   -Info "Set the capacity for the Bullet Bag (Upgrade 1)"  -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BulletBag3"  -Child -Text "Bullet Bag (3)"  -Value 50   -Info "Set the capacity for the Bullet Bag (Upgrade 2)"  -Credits "GhostlyDark"

    if ($Redux.Capacity.BulletBag1 -ne $null) { $Last.Column = 1; $Last.Row++ }
    CreateReduxTextBox -Name "DekuSticks1" -Child -Text "Deku Sticks (1)" -Value 10   -Info "Set the capacity for the Deku Sticks (Base)"      -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuSticks2" -Child -Text "Deku Sticks (2)" -Value 20   -Info "Set the capacity for the Deku Sticks (Upgrade 1)" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuSticks3" -Child -Text "Deku Sticks (3)" -Value 30   -Info "Set the capacity for the Deku Sticks (Upgrade 2)" -Credits "GhostlyDark"

    if ($Redux.Capacity.DekuSticks1 -ne $null) { $Last.Column = 1; $Last.Row++ }
    if (StrLike -Str $GamePatch.settings -Val "Master of Time") { $val = 15 } else { $val = 20 }
    CreateReduxTextBox -Name "DekuNuts1"          -Text "Deku Nuts (1)"   -Value $val -Info "Set the capacity for the Deku Nuts (Base)"        -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuNuts2"          -Text "Deku Nuts (2)"   -Value 30   -Info "Set the capacity for the Deku Nuts (Upgrade 1)"   -Credits "GhostlyDark"
    if (StrLike -Str $GamePatch.settings -Val "Master of Time") { $val = 99 } else { $val = 40 }
    CreateReduxTextBox -Name "DekuNuts3"          -Text "Deku Nuts (3)"   -Value $val -Info "Set the capacity for the Deku Nuts (Upgrade 2)"   -Credits "GhostlyDark"



    # WALLET CAPACITY #

    $Redux.Box.Wallet = CreateReduxGroup -Tag "Capacity"    -Text "Wallet Capacity"
    CreateReduxTextBox -Name "Wallet1" -Length 5 -Max 32500 -Text "Wallet (1)" -Value 99   -Info "Set the capacity for the Wallet (Base)"                                     -Credits "GhostlyDark"
    if (StrLike -Str $GamePatch.settings -Val "Master of Time")   { $val = 250 } else { $val = 200 }
    CreateReduxTextBox -Name "Wallet2" -Length 5 -Max 32500 -Text "Wallet (2)" -Value $val -Info "Set the capacity for the Wallet (Upgrade 1)"                                -Credits "GhostlyDark" -Exclude "Dawn"
    if (StrLike -Str $GamePatch.settings -Val "Gold Quest")       { $val = 999 } else { $val = 500 }
    CreateReduxTextBox -Name "Wallet3" -Length 5 -Max 32500 -Text "Wallet (3)" -Value $val -Info "Set the capacity for the Wallet (Upgrade 2)"                                -Credits "GhostlyDark" -Exclude "Dawn"
    CreateReduxTextBox -Name "Wallet4" -Length 5 -Max 32500 -Text "Wallet (4)" -Value 999  -Info "Set the capacity for the Wallet (Upgrade 3)`nOnly obtainable through Redux" -Credits "GhostlyDark" -Exclude "Dawn"



    # ITEM DROPS QUANTITY #

    $Redux.Box.Drops = CreateReduxGroup -Tag "Capacity" -Text "Item Drops Quantity"

    CreateReduxTextBox -Name "ItemDrops5"               -Text "Item Drops (5)"    -Value 5  -Info "Set the recovery quantity for picking up Deku Sticks, Deku Nuts or Bombs (5)"  -Credits "Admentus"
    CreateReduxTextBox -Name "ItemDrops10"              -Text "Item Drops (10)"   -Value 10 -Info "Set the recovery quantity for picking up Deku Sticks, Deku Nuts or Bombs (10)" -Credits "Admentus"
    CreateReduxTextBox -Name "ItemDrops20"              -Text "Item Drops (20)"   -Value 20 -Info "Set the recovery quantity for picking up Deku Sticks, Deku Nuts or Bombs (20)" -Credits "Admentus"
    CreateReduxTextBox -Name "ItemDrops30"              -Text "Item Drops (30)"   -Value 30 -Info "Set the recovery quantity for picking up Deku Sticks, Deku Nuts or Bombs (30)" -Credits "Admentus"

    CreateReduxTextBox -Name "Arrows5"           -Adult -Text "Arrows (5)"        -Value 5  -Info "Set the recovery quantity for picking up Single Arrows (5)"                    -Credits "Admentus"
    CreateReduxTextBox -Name "Arrows10"          -Adult -Text "Arrows (10)"       -Value 10 -Info "Set the recovery quantity for picking up Double Arrows (10)"                   -Credits "Admentus"
    CreateReduxTextBox -Name "Arrows30"          -Adult -Text "Arrows (30)"       -Value 30 -Info "Set the recovery quantity for picking up Triple Arrows (30)"                   -Credits "Admentus"

    if ($Redux.Capacity.Arrows5 -ne $null) { $Last.Column = 1; $Last.Row++ }
    CreateReduxTextBox -Name "DekuStick"         -Child -Text "Deku Sticks (1)"   -Value 1  -Info "Set the recovery quantity for picking up a Deku Stick (1)"                     -Credits "Admentus"
    CreateReduxTextBox -Name "DekuSeedBullets5"  -Child -Text "Bullet Seeds (5)"  -Value 5  -Info "Set the recovery quantity for picking up Deku Seed Bullets (5)"                -Credits "Admentus"
    CreateReduxTextBox -Name "DekuSeedBullets30" -Child -Text "Bullet Seeds (30)" -Value 30 -Info "Set the recovery quantity for picking up Deku Seed Bullets (30)"               -Credits "Admentus"

    if ($Redux.Capacity.DekuStick -ne $null) { $Last.Column = 1; $Last.Row++ }
    CreateReduxTextBox -Name "Bombchus5"                -Text "Bombchus (5)"      -Value 5  -Info "Set the recovery quantity for picking up Bombchus (5)"                 -Max 50 -Credits "Admentus" -Base 5
    CreateReduxTextBox -Name "Bombchus10"               -Text "Bombchus (10)"     -Value 10 -Info "Set the recovery quantity for picking up Bombchus (10)"                -Max 50 -Credits "Admentus" -Base 5
    CreateReduxTextBox -Name "Bombchus30"               -Text "Bombchus (20)"     -Value 20 -Info "Set the recovery quantity for picking up Bombchus (20)"                -Max 50 -Credits "Admentus" -Base 5

    $Last.Column = 1; $Last.Row++
    CreateReduxTextBox -Name "RupeeG" -Length 4                   -Text "Rupee (Green)"  -Value 1   -Info "Set the recovery quantity for picking up Green Rupees"  -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeB" -Length 4 -Exclude "Master" -Text "Rupee (Blue)"   -Value 5   -Info "Set the recovery quantity for picking up Blue Rupees"   -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeR" -Length 4 -Exclude "Master" -Text "Rupee (Red)"    -Value 20  -Info "Set the recovery quantity for picking up Red Rupees"    -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeB" -Length 4 -Expose  "Master" -Text "Rupee (Blue)"   -Value 2   -Info "Set the recovery quantity for picking up Blue Rupees"   -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeR" -Length 4 -Expose  "Master" -Text "Rupee (Red)"    -Value 5   -Info "Set the recovery quantity for picking up Red Rupees"    -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeP" -Length 4                   -Text "Rupee (Purple)" -Value 50  -Info "Set the recovery quantity for picking up Purple Rupees" -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeO" -Length 4                   -Text "Rupee (Gold)"   -Value 200 -Info "Set the recovery quantity for picking up Gold Rupees"   -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeS" -Length 4                   -Text "Rupee (Silver)" -Value 5   -Info "Set the recovery quantity for picking up Silver Rupees" -Credits "Admentus"

    if ($Settings.Core.Lite) { return }



    # SHOP ITEMS QUANTITY #

    $Redux.Box.ShopQuantity = CreateReduxGroup -Tag "ShopQuantity" -Text "Shop Items Quantity"

    CreateReduxTextBox -Name "RecoveryHeart" -Text "Recovery Heart"    -Value 1  -Info "Set the quantity for buying a Recovery Heart" -Credits "Admentus" -Min 1 -Base 5 -Max 20
    CreateReduxTextBox -Name "Bombchus10A"   -Text "Bombchus (10 - A)" -Value 10 -Info "Set the quantity for buying Bombchus (10)"    -Credits "Admentus" -Min 1 -Base 5
    CreateReduxTextBox -Name "Bombchus10B"   -Text "Bombchus (10 - B)" -Value 10 -Info "Set the quantity for buying Bombchus (10)"    -Credits "Admentus" -Min 1 -Base 5
    CreateReduxTextBox -Name "Bombchus10C"   -Text "Bombchus (10 - C)" -Value 10 -Info "Set the quantity for buying Bombchus (10)"    -Credits "Admentus" -Min 1 -Base 5
    CreateReduxTextBox -Name "Bombchus10D"   -Text "Bombchus (10 - D)" -Value 10 -Info "Set the quantity for buying Bombchus (10)"    -Credits "Admentus" -Min 1 -Base 5
    CreateReduxTextBox -Name "Bombchus20A"   -Text "Bombchus (20 - A)" -Value 20 -Info "Set the quantity for buying Bombchus (20)"    -Credits "Admentus" -Min 1 -Base 5
    CreateReduxTextBox -Name "Bombchus20B"   -Text "Bombchus (20 - B)" -Value 20 -Info "Set the quantity for buying Bombchus (20)"    -Credits "Admentus" -Min 1 -Base 5
    CreateReduxTextBox -Name "Bombchus20C"   -Text "Bombchus (20 - C)" -Value 20 -Info "Set the quantity for buying Bombchus (20)"    -Credits "Admentus" -Min 1 -Base 5
    CreateReduxTextBox -Name "Bombchus20D"   -Text "Bombchus (20 - D)" -Value 20 -Info "Set the quantity for buying Bombchus (20)"    -Credits "Admentus" -Min 1 -Base 5
    CreateReduxTextBox -Name "Arrows10"      -Text "Arrows (10)"       -Value 10 -Info "Set the quantity for buying Arrows (10)"      -Credits "Admentus" -Min 1 -Adult
    CreateReduxTextBox -Name "Arrows30"      -Text "Arrows (30)"       -Value 30 -Info "Set the quantity for buying Arrows (30)"      -Credits "Admentus" -Min 1 -Adult
    CreateReduxTextBox -Name "Arrows50"      -Text "Arrows (50)"       -Value 50 -Info "Set the quantity for buying Arrows (50)"      -Credits "Admentus" -Min 1 -Adult



    # SHOP ITEMS PRICE #

    $Redux.Box.ShopPrice = CreateReduxGroup -Tag "ShopPrice" -Text "Shop Items Price"
    
    CreateReduxTextBox -Name "RecoveryHeart"     -Text "Recovery Hearts"        -Value 10   -Info "Set the price for buying a Recovery Heart"       -Credits "Admentus" -Length 4 -Base 5
    CreateReduxTextBox -Name "DekuStick"         -Text "Deku Stick"             -Value 10   -Info "Set the price for buying a Deku Stick"           -Credits "Admentus" -Length 4 -Child
    CreateReduxTextBox -Name "DekuNuts5"         -Text "Deku Nuts (5)"          -Value 5    -Info "Set the price for buying Deku Nuts (5)"          -Credits "Admentus" -Length 4
    CreateReduxTextBox -Name "DekuNuts10"        -Text "Deku Nuts (10)"         -Value 10   -Info "Set the price for buying Deku Nuts (10)"         -Credits "Admentus" -Length 4
    CreateReduxTextBox -Name "Bombs5A"           -Text "Bombs (5 - A)"          -Value 25   -Info "Set the price for buying Bombs (5)"              -Credits "Admentus" -Length 4 -Base 5
    CreateReduxTextBox -Name "Bombs5B"           -Text "Bombs (5 - B)"          -Value 35   -Info "Set the price for buying Bombs (5)"              -Credits "Admentus" -Length 4 -Base 5
    CreateReduxTextBox -Name "Bombs10"           -Text "Bombs (10)"             -Value 50   -Info "Set the price for buying Bombs (10)"             -Credits "Admentus" -Length 4 -Base 5
    CreateReduxTextBox -Name "Bombs20"           -Text "Bombs (20)"             -Value 80   -Info "Set the price for buying Bombs (20)"             -Credits "Admentus" -Length 4 -Base 5
    CreateReduxTextBox -Name "Bombs30"           -Text "Bombs (30)"             -Value 120  -Info "Set the price for buying Bombs (30)"             -Credits "Admentus" -Length 4 -Base 5
    CreateReduxTextBox -Name "Bombchus10A"       -Text "Bombchus (10 - A)"      -Value 100  -Info "Set the price for buying Bombchus (10)"          -Credits "Admentus" -Length 4 -Base 5
    CreateReduxTextBox -Name "Bombchus10B"       -Text "Bombchus (10 - B)"      -Value 100  -Info "Set the price for buying Bombchus (10)"          -Credits "Admentus" -Length 4 -Base 5
    CreateReduxTextBox -Name "Bombchus10C"       -Text "Bombchus (10 - C)"      -Value 100  -Info "Set the price for buying Bombchus (10)"          -Credits "Admentus" -Length 4 -Base 5
    CreateReduxTextBox -Name "Bombchus10D"       -Text "Bombchus (10 - D)"      -Value 100  -Info "Set the price for buying Bombchus (10)"          -Credits "Admentus" -Length 4 -Base 5
    CreateReduxTextBox -Name "Bombchus20A"       -Text "Bombchus (20 - A)"      -Value 180  -Info "Set the price for buying Bombchus (20)"          -Credits "Admentus" -Length 4 -Base 5
    CreateReduxTextBox -Name "Bombchus20B"       -Text "Bombchus (20 - B)"      -Value 180  -Info "Set the price for buying Bombchus (20)"          -Credits "Admentus" -Length 4 -Base 5
    CreateReduxTextBox -Name "Bombchus20C"       -Text "Bombchus (20 - C)"      -Value 180  -Info "Set the price for buying Bombchus (20)"          -Credits "Admentus" -Length 4 -Base 5
    CreateReduxTextBox -Name "Bombchus20D"       -Text "Bombchus (20 - D)"      -Value 180  -Info "Set the price for buying Bombchus (20)"          -Credits "Admentus" -Length 4 -Base 5
    CreateReduxTextBox -Name "DekuSeedBullets30" -Text "Bullet Seeds (30)"      -Value 30   -Info "Set the price for buying Deku Seed Bullets (30)" -Credits "Admentus" -Length 4 -Child
    CreateReduxTextBox -Name "Arrows10"          -Text "Arrows (10)"            -Value 20   -Info "Set the price for buying Arrows (10)"            -Credits "Admentus" -Length 4 -Adult
    CreateReduxTextBox -Name "Arrows30"          -Text "Arrows (30)"            -Value 60   -Info "Set the price for buying Arrows (30)"            -Credits "Admentus" -Length 4 -Adult
    CreateReduxTextBox -Name "Arrows50"          -Text "Arrows (50)"            -Value 90   -Info "Set the price for buying Arrows (50)"            -Credits "Admentus" -Length 4 -Adult
    CreateReduxTextBox -Name "DekuShield"        -Text "Deku Shield"            -Value 40   -Info "Set the price for buying a Deku Shield"          -Credits "Admentus" -Length 4 -Child
    CreateReduxTextBox -Name "HylianShield"      -Text "Hylian Shield"          -Value 80   -Info "Set the price for buying a Hylian Shield"        -Credits "Admentus" -Length 4 -Base 5
    CreateReduxTextBox -Name "GiantsKnife"       -Text "Giant's Knife"          -Value 1000 -Info "Set the price for buying a Giant's Knife"        -Credits "Admentus" -Length 4 -Base 5 -Adult
    CreateReduxTextBox -Name "GoronTunic"        -Text "Goron Tunic"            -Value 200  -Info "Set the price for buying a Goron Tunic"          -Credits "Admentus" -Length 4 -Base 5 -Adult
    CreateReduxTextBox -Name "ZoraTunic"         -Text "Zora Tunic"             -Value 300  -Info "Set the price for buying a Zora Tunic"           -Credits "Admentus" -Length 4 -Base 5 -Adult
    CreateReduxTextBox -Name "RedPotionA"        -Text "Red Potion (A)"         -Value 30   -Info "Set the price for buying a Red Potion"           -Credits "Admentus" -Length 4
    CreateReduxTextBox -Name "RedPotionB"        -Text "Red Potion (B)"         -Value 40   -Info "Set the price for buying a Red Potion"           -Credits "Admentus" -Length 4 -Base 5
    CreateReduxTextBox -Name "RedPotionC"        -Text "Red Potion (C)"         -Value 50   -Info "Set the price for buying a Red Potion"           -Credits "Admentus" -Length 4 -Base 5
    CreateReduxTextBox -Name "GreenPotion"       -Text "Green Potion"           -Value 30   -Info "Set the price for buying a Green Potion"         -Credits "Admentus" -Length 4
    CreateReduxTextBox -Name "BluePotion"        -Text "Blue Potion"            -Value 60   -Info "Set the price for buying a Blue Potion"          -Credits "Admentus" -Length 4 -Base 5
    CreateReduxTextBox -Name "Milk"              -Text "Milk"                   -Value 100  -Info "Set the price for buying Milk"                   -Credits "Admentus" -Length 4
    CreateReduxTextBox -Name "Fairy"             -Text "Fairy"                  -Value 50   -Info "Set the price for buying a Fairy"                -Credits "Admentus" -Length 4
    CreateReduxTextBox -Name "BlueFire"          -Text "Blue Fire"              -Value 300  -Info "Set the price for buying a Blue Fire"            -Credits "Admentus" -Length 4 -Base 5
    CreateReduxTextBox -Name "Bug"               -Text "Bug"                    -Value 50   -Info "Set the price for buying Bugs"                   -Credits "Admentus" -Length 4 -Base 5
    CreateReduxTextBox -Name "Fish"              -Text "Fish"                   -Value 200  -Info "Set the price for buying a Fish"                 -Credits "Admentus" -Length 4 -Base 5
    CreateReduxTextBox -Name "Poe"               -Text "Poe"                    -Value 30   -Info "Set the price for buying a Poe"                  -Credits "Admentus" -Length 4 -Base 5
    CreateReduxTextBox -Name "BigPoe"            -Text "Big Poe"                -Value 50   -Info "Set the price for buying a Big Poe"              -Credits "Admentus" -Length 4 -Base 5
    CreateReduxTextBox -Name "WeirdEgg"          -Text "Weird Egg"              -Value 100  -Info "Set the price for buying a Weird Egg"            -Credits "Admentus" -Length 4 -Base 5

    CreateReduxCheckBox -Name "FixItems" -Adult -Base 5 -Text "Fix Unused Items" -Info "Fix the textboxs for the unused items" -Credits "Admentus"


    # SHOP ITEMS #
    
    $items = @()
    foreach ($item in $Files.json.shopItems.items) {
        if ($item.hide -ne 1) { $items += $item.title }
    }
    
    $Redux.Box.Bazaar = CreateReduxGroup -Tag "Bazaar" -Text "Bazaar Items" -Base 2
    CreateReduxComboBox -Name "Slot1" -Text "Slot 1" -Info "Set the item for slot 1" -Default $Files.json.shopItems.bazaar[0] -Items $items
    CreateReduxComboBox -Name "Slot2" -Text "Slot 2" -Info "Set the item for slot 2" -Default $Files.json.shopItems.bazaar[1] -Items $items
    CreateReduxComboBox -Name "Slot3" -Text "Slot 3" -Info "Set the item for slot 3" -Default $Files.json.shopItems.bazaar[2] -Items $items
    CreateReduxComboBox -Name "Slot4" -Text "Slot 4" -Info "Set the item for slot 4" -Default $Files.json.shopItems.bazaar[3] -Items $items
    CreateReduxComboBox -Name "Slot5" -Text "Slot 5" -Info "Set the item for slot 5" -Default $Files.json.shopItems.bazaar[4] -Items $items
    CreateReduxComboBox -Name "Slot6" -Text "Slot 6" -Info "Set the item for slot 6" -Default $Files.json.shopItems.bazaar[5] -Items $items
    CreateReduxComboBox -Name "Slot7" -Text "Slot 7" -Info "Set the item for slot 7" -Default $Files.json.shopItems.bazaar[6] -Items $items
    CreateReduxComboBox -Name "Slot8" -Text "Slot 8" -Info "Set the item for slot 8" -Default $Files.json.shopItems.bazaar[7] -Items $items

    $Redux.Box.MarketPotionShop = CreateReduxGroup -Tag "MarketPotionShop" -Text "Market Potion Shop Items" -Child -Base 2
    CreateReduxComboBox -Name "Slot1" -Text "Slot 1" -Info "Set the item for slot 1" -Default $Files.json.shopItems.marketPotionShop[0] -Items $items
    CreateReduxComboBox -Name "Slot2" -Text "Slot 2" -Info "Set the item for slot 2" -Default $Files.json.shopItems.marketPotionShop[1] -Items $items
    CreateReduxComboBox -Name "Slot3" -Text "Slot 3" -Info "Set the item for slot 3" -Default $Files.json.shopItems.marketPotionShop[2] -Items $items
    CreateReduxComboBox -Name "Slot4" -Text "Slot 4" -Info "Set the item for slot 4" -Default $Files.json.shopItems.marketPotionShop[3] -Items $items
    CreateReduxComboBox -Name "Slot5" -Text "Slot 5" -Info "Set the item for slot 5" -Default $Files.json.shopItems.marketPotionShop[4] -Items $items
    CreateReduxComboBox -Name "Slot6" -Text "Slot 6" -Info "Set the item for slot 6" -Default $Files.json.shopItems.marketPotionShop[5] -Items $items
    CreateReduxComboBox -Name "Slot7" -Text "Slot 7" -Info "Set the item for slot 7" -Default $Files.json.shopItems.marketPotionShop[6] -Items $items
    CreateReduxComboBox -Name "Slot8" -Text "Slot 8" -Info "Set the item for slot 8" -Default $Files.json.shopItems.marketPotionShop[7] -Items $items

    $Redux.Box.KakarikoPotionShop = CreateReduxGroup -Tag "KakarikoPotionShop" -Text "Kakariko Potion Shop Items" -Adult -Base 2
    CreateReduxComboBox -Name "Slot1" -Text "Slot 1" -Info "Set the item for slot 1" -Default $Files.json.shopItems.kakarikoPotionShop[0] -Items $items
    CreateReduxComboBox -Name "Slot2" -Text "Slot 2" -Info "Set the item for slot 2" -Default $Files.json.shopItems.kakarikoPotionShop[1] -Items $items
    CreateReduxComboBox -Name "Slot3" -Text "Slot 3" -Info "Set the item for slot 3" -Default $Files.json.shopItems.kakarikoPotionShop[2] -Items $items
    CreateReduxComboBox -Name "Slot4" -Text "Slot 4" -Info "Set the item for slot 4" -Default $Files.json.shopItems.kakarikoPotionShop[3] -Items $items
    CreateReduxComboBox -Name "Slot5" -Text "Slot 5" -Info "Set the item for slot 5" -Default $Files.json.shopItems.kakarikoPotionShop[4] -Items $items
    CreateReduxComboBox -Name "Slot6" -Text "Slot 6" -Info "Set the item for slot 6" -Default $Files.json.shopItems.kakarikoPotionShop[5] -Items $items
    CreateReduxComboBox -Name "Slot7" -Text "Slot 7" -Info "Set the item for slot 7" -Default $Files.json.shopItems.kakarikoPotionShop[6] -Items $items
    CreateReduxComboBox -Name "Slot8" -Text "Slot 8" -Info "Set the item for slot 8" -Default $Files.json.shopItems.kakarikoPotionShop[7] -Items $items

    $Redux.Box.BombchuShop = CreateReduxGroup -Tag "BombchuShop" -Text "Bombchu Shop Items" -Base 2
    CreateReduxComboBox -Name "Slot1" -Text "Slot 1" -Info "Set the item for slot 1" -Default $Files.json.shopItems.bombchuShop[0] -Items $items
    CreateReduxComboBox -Name "Slot2" -Text "Slot 2" -Info "Set the item for slot 2" -Default $Files.json.shopItems.bombchuShop[1] -Items $items
    CreateReduxComboBox -Name "Slot3" -Text "Slot 3" -Info "Set the item for slot 3" -Default $Files.json.shopItems.bombchuShop[2] -Items $items
    CreateReduxComboBox -Name "Slot4" -Text "Slot 4" -Info "Set the item for slot 4" -Default $Files.json.shopItems.bombchuShop[3] -Items $items
    CreateReduxComboBox -Name "Slot5" -Text "Slot 5" -Info "Set the item for slot 5" -Default $Files.json.shopItems.bombchuShop[4] -Items $items
    CreateReduxComboBox -Name "Slot6" -Text "Slot 6" -Info "Set the item for slot 6" -Default $Files.json.shopItems.bombchuShop[5] -Items $items
    CreateReduxComboBox -Name "Slot7" -Text "Slot 7" -Info "Set the item for slot 7" -Default $Files.json.shopItems.bombchuShop[6] -Items $items
    CreateReduxComboBox -Name "Slot8" -Text "Slot 8" -Info "Set the item for slot 8" -Default $Files.json.shopItems.bombchuShop[7] -Items $items

    $Redux.Box.KokiriShop = CreateReduxGroup -Tag "KokiriShop" -Text "Kokiri Shop Items" -Base 2
    CreateReduxComboBox -Name "Slot1" -Text "Slot 1" -Info "Set the item for slot 1" -Default $Files.json.shopItems.kokiriShop[0] -Items $items
    CreateReduxComboBox -Name "Slot2" -Text "Slot 2" -Info "Set the item for slot 2" -Default $Files.json.shopItems.kokiriShop[1] -Items $items
    CreateReduxComboBox -Name "Slot3" -Text "Slot 3" -Info "Set the item for slot 3" -Default $Files.json.shopItems.kokiriShop[2] -Items $items
    CreateReduxComboBox -Name "Slot4" -Text "Slot 4" -Info "Set the item for slot 4" -Default $Files.json.shopItems.kokiriShop[3] -Items $items
    CreateReduxComboBox -Name "Slot5" -Text "Slot 5" -Info "Set the item for slot 5" -Default $Files.json.shopItems.kokiriShop[4] -Items $items
    CreateReduxComboBox -Name "Slot6" -Text "Slot 6" -Info "Set the item for slot 6" -Default $Files.json.shopItems.kokiriShop[5] -Items $items
    CreateReduxComboBox -Name "Slot7" -Text "Slot 7" -Info "Set the item for slot 7" -Default $Files.json.shopItems.kokiriShop[6] -Items $items
    CreateReduxComboBox -Name "Slot8" -Text "Slot 8" -Info "Set the item for slot 8" -Default $Files.json.shopItems.kokiriShop[7] -Items $items

    $Redux.Box.GoronShop = CreateReduxGroup -Tag "GoronShop" -Text "Goron Shop Items" -Base 2
    CreateReduxComboBox -Name "Slot1" -Text "Slot 1" -Info "Set the item for slot 1" -Default $Files.json.shopItems.goronShop[0] -Items $items
    CreateReduxComboBox -Name "Slot2" -Text "Slot 2" -Info "Set the item for slot 2" -Default $Files.json.shopItems.goronShop[1] -Items $items
    CreateReduxComboBox -Name "Slot3" -Text "Slot 3" -Info "Set the item for slot 3" -Default $Files.json.shopItems.goronShop[2] -Items $items
    CreateReduxComboBox -Name "Slot4" -Text "Slot 4" -Info "Set the item for slot 4" -Default $Files.json.shopItems.goronShop[3] -Items $items
    CreateReduxComboBox -Name "Slot5" -Text "Slot 5" -Info "Set the item for slot 5" -Default $Files.json.shopItems.goronShop[4] -Items $items
    CreateReduxComboBox -Name "Slot6" -Text "Slot 6" -Info "Set the item for slot 6" -Default $Files.json.shopItems.goronShop[5] -Items $items
    CreateReduxComboBox -Name "Slot7" -Text "Slot 7" -Info "Set the item for slot 7" -Default $Files.json.shopItems.goronShop[6] -Items $items
    CreateReduxComboBox -Name "Slot8" -Text "Slot 8" -Info "Set the item for slot 8" -Default $Files.json.shopItems.goronShop[7] -Items $items

    $Redux.Box.ZoraShop = CreateReduxGroup -Tag "ZoraShop" -Text "Zora Shop Items" -Base 2
    CreateReduxComboBox -Name "Slot1" -Text "Slot 1" -Info "Set the item for slot 1" -Default $Files.json.shopItems.zoraShop[0] -Items $items
    CreateReduxComboBox -Name "Slot2" -Text "Slot 2" -Info "Set the item for slot 2" -Default $Files.json.shopItems.zoraShop[1] -Items $items
    CreateReduxComboBox -Name "Slot3" -Text "Slot 3" -Info "Set the item for slot 3" -Default $Files.json.shopItems.zoraShop[2] -Items $items
    CreateReduxComboBox -Name "Slot4" -Text "Slot 4" -Info "Set the item for slot 4" -Default $Files.json.shopItems.zoraShop[3] -Items $items
    CreateReduxComboBox -Name "Slot5" -Text "Slot 5" -Info "Set the item for slot 5" -Default $Files.json.shopItems.zoraShop[4] -Items $items
    CreateReduxComboBox -Name "Slot6" -Text "Slot 6" -Info "Set the item for slot 6" -Default $Files.json.shopItems.zoraShop[5] -Items $items
    CreateReduxComboBox -Name "Slot7" -Text "Slot 7" -Info "Set the item for slot 7" -Default $Files.json.shopItems.zoraShop[6] -Items $items
    CreateReduxComboBox -Name "Slot8" -Text "Slot 8" -Info "Set the item for slot 8" -Default $Files.json.shopItems.zoraShop[7] -Items $items




    EnableForm -Form $Redux.Box.Ammo               -Enable $Redux.Capacity.EnableAmmo.Checked
    EnableForm -Form $Redux.Box.Wallet             -Enable $Redux.Capacity.EnableWallet.Checked
    EnableForm -Form $Redux.Box.Drops              -Enable $Redux.Capacity.EnableDrops.Checked
    EnableForm -Form $Redux.Box.ShopQuantity       -Enable $Redux.Capacity.EnableShop.Checked
    EnableForm -Form $Redux.Box.ShopPrice          -Enable $Redux.Capacity.EnableShop.Checked
    EnableForm -Form $Redux.Box.Bazaar             -Enable $Redux.Capacity.EnableShop.Checked
    EnableForm -Form $Redux.Box.MarketPotionShop   -Enable $Redux.Capacity.EnableShop.Checked
    EnableForm -Form $Redux.Box.KakarikoPotionShop -Enable $Redux.Capacity.EnableShop.Checked
    EnableForm -Form $Redux.Box.BombchuShop        -Enable $Redux.Capacity.EnableShop.Checked
    EnableForm -Form $Redux.Box.KokiriShop         -Enable $Redux.Capacity.EnableShop.Checked
    EnableForm -Form $Redux.Box.GoronShop          -Enable $Redux.Capacity.EnableShop.Checked
    EnableForm -Form $Redux.Box.ZoraShop           -Enable $Redux.Capacity.EnableShop.Checked
    $Redux.Capacity.EnableAmmo.Add_CheckStateChanged(   { EnableForm -Form $Redux.Box.Ammo   -Enable $Redux.Capacity.EnableAmmo.Checked   } )
    $Redux.Capacity.EnableWallet.Add_CheckStateChanged( { EnableForm -Form $Redux.Box.Wallet -Enable $Redux.Capacity.EnableWallet.Checked } )
    $Redux.Capacity.EnableDrops.Add_CheckStateChanged(  { EnableForm -Form $Redux.Box.Drops  -Enable $Redux.Capacity.EnableDrops.Checked  } )
    $Redux.Capacity.EnableShop.Add_CheckStateChanged( {
        EnableForm -Form $Redux.Box.ShopQuantity       -Enable $Redux.Capacity.EnableShop.Checked
        EnableForm -Form $Redux.Box.ShopPrice          -Enable $Redux.Capacity.EnableShop.Checked
        EnableForm -Form $Redux.Box.ShopPrice          -Enable $Redux.Capacity.EnableShop.Checked
        EnableForm -Form $Redux.Box.Bazaar             -Enable $Redux.Capacity.EnableShop.Checked
        EnableForm -Form $Redux.Box.MarketPotionShop   -Enable $Redux.Capacity.EnableShop.Checked
        EnableForm -Form $Redux.Box.KakarikoPotionShop -Enable $Redux.Capacity.EnableShop.Checked
        EnableForm -Form $Redux.Box.BombchuShop        -Enable $Redux.Capacity.EnableShop.Checked
        EnableForm -Form $Redux.Box.KokiriShop         -Enable $Redux.Capacity.EnableShop.Checked
        EnableForm -Form $Redux.Box.GoronShop          -Enable $Redux.Capacity.EnableShop.Checked
        EnableForm -Form $Redux.Box.ZoraShop           -Enable $Redux.Capacity.EnableShop.Checked
    } )

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

    $items = @("Opening Cutscene", "Collected All Medallions", "Darunia Dance", "Zelda's Escape", "Beated Dungeon Outro", "Get Light Arrow", "Learn Regular Songs", "Learn Warp Songs", "Opening Royal Tomb", "Chamber of Sages Visits", "Swallowed by Jabu-Jabu", "Ganon's Tower Collapse", "Lost Woods Bullet Bag")
    CreateReduxGroup   -Tag  "Skip"      -Text "Skip Cutscenes"
    CreateReduxListBox -Name "Cutscenes" -Items $items -MultiColumn -MultiSelect -Columns 4 -Rows 1.6 -ItemWidth 120
    


    # SPEEDUP CUTSCENES #

    $items = @("Opening Chests", "Opening Kakariko Gate", "Moving King Zora", "Owl Flights", "Ingo Epona Race", "Horseback Archery", "Opening Door of Time", "Draining the Well", "Boss Intros & Outros", "Rainbow Bridge", "Get Fairy Ocarina", "Ganon's Castle Trials")
    CreateReduxGroup   -Tag  "Speedup"   -Text "Speedup Cutscenes"
    CreateReduxListBox -Name "Cutscenes" -Items $items -MultiColumn -MultiSelect -Columns 4 -Rows 1.6 -ItemWidth 120



    # RESTORE CUTSCENES #

    CreateReduxGroup    -Tag  "Restore" -Base 1 -Text "Restore Cutscenes"
    CreateReduxCheckBox -Name "OpeningCutscene" -Text "Opening Cutscene" -Info "Restore the beta introduction cutscene" -Link $Redux.Skip.OpeningCutscene -Credits "Admentus (ROM) & CloudModding (RAM)" -Warning "This cutscene has issues in 30 FPS mode"



    # ANIMATIONS #

    $weapons = "`n`nAffected weapons:`n- Giant's Knife`n- Giant's Knife (Broken)`n- Biggoron Sword`n- Deku Stick`n- Megaton Hammer"

    CreateReduxGroup    -Tag  "Animation"       -Text "Link Animations"
    CreateReduxCheckBox -Name "Feminine"        -Text "Feminine Animations"    -Info "Use feminine animations for Link`nThis applies to both models`nIt works best with the Aria model"   -Credits "GhostlyDark (ported) & Aria Hiroshi 64 (model)"
    CreateReduxCheckBox -Name "WeaponIdle"      -Text "2-handed Weapon Idle"   -Info ("Restore the beta animation when idly holding a two-handed weapon" + $weapons)                      -Credits "Admentus"
    CreateReduxCheckBox -Name "WeaponCrouch"    -Text "2-handed Weapon Crouch" -Info ("Restore the beta animation when crouching with a two-handed weapon" + $weapons)                    -Credits "Admentus"
    CreateReduxCheckBox -Name "WeaponAttack"    -Text "2-handed Weapon Attack" -Info ("Restore the beta animation when attacking with a two-handed weapon" + $weapons)                    -Credits "Admentus"
    CreateReduxCheckBox -Name "HoldShieldOut"   -Text "Hold Shield Out"        -Info "Restore the beta animation for Link to always holds his shield out even when his sword is sheathed" -Credits "Admentus"
    CreateReduxCheckBox -Name "BombBag"         -Text "Bomb Bag"               -Info "Restore the beta animation for the bomb bag"                                                        -Credits "Admentus (ROM) & Aegiker (RAM)"
    CreateReduxCheckBox -Name "BackflipAttack"  -Text "Backflip Jump Attack"   -Info "Restore the beta animation to turn the Jump Attack into a Backflip Jump Attack"                     -Credits "Admentus"
    CreateReduxCheckBox -Name "FrontflipAttack" -Text "Frontflip Jump Attack"  -Info "Restore the beta animation to turn the Jump Attack into a Frontflip Jump Attack"                    -Credits "Admentus"    -Link $Redux.Animation.BackflipAttack
    CreateReduxCheckBox -Name "FrontflipJump"   -Text "Frontflip Jump"         -Info "Replace the jumps with frontflip jumps`nThis is a jump from Majora's Mask"                          -Credits "SoulofDeity"
    CreateReduxCheckBox -Name "SomarsaultJump"  -Text "Somarsault Jump"        -Info "Replace the jumps with somarsault jumps`nThis is a jump from Majora's Mask"                         -Credits "SoulofDeity" -Link $Redux.Animation.FrontflipJump
    CreateReduxCheckBox -Name "SideBackflip"    -Text "Side Backflip"          -Info "Replace the backflip jump with side hop jumps"                                                      -Credits "BilonFullHDemon"
    CreateReduxCheckBox -Name "LinkDeathCamera" -Text "Link Death Camera"      -Info "When Link dies, the camera will not move, just like Majora's Mask"                                  -Credits "Euler"

}
