function PrePatchLanguageOptions() {

    # ENHANCED 16:9 WIDESCREEN #

    if ( (IsChecked $Redux.Graphics.Widescreen) -and !$Patches.Redux.Checked)   { ApplyPatch -Patch "Decompressed\optional\widescreen.ppf"; }
    if ( (IsSet $LanguagePatch.DmaTable)        -and !$Patches.Redux.Checked)   { return }

    if   (IsChecked $Redux.Graphics.Widescreen)                                 { RemoveFile $Files.dmaTable }
    if ( (IsChecked $Redux.Graphics.Widescreen) -and !$Patches.Redux.Checked)   { Add-Content $Files.dmaTable "0 1 2 3 4 5 6 7 -8 -9 15 16 17 18 19 20 -21 22 -24 25 26 27 28 29 30 -652 1127 -1540 -1541 -1542 -1543 -1544 -1545 -1546 -1547 -1548 -1549 -1550 -1551 1552 1553 1554 1555 1556 1557 1558 1559 1560 1561 1562 1563 1564 1565 1566 1567" }
    if ( (IsChecked $Redux.Graphics.Widescreen) -and  $Patches.Redux.Checked)   { Add-Content $Files.dmaTable "0 1 2 3 4 5 6 7 -8 -9 15 16 17 18 19 20 -21 22 -24 25 26 27 28 29 30 -652 1127 -1540 -1541 -1542 -1543 1544 1545 1546 1547 1548 1549 1550 -1551 1552 1553 1554 1555 1556 1557 1558 1559 1560 1561 1562 1563 1564 1565 1566 1567" }

}



#==============================================================================================================================================================================================
function PatchOptions() {
    
    # MODELS #

    if (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Original" -Not) {
        $file = "\Child\" + $Redux.Graphics.ChildModels.Text.replace(" (default)", "") + ".ppf" 
        if (TestFile ($GameFiles.models + $file))              { ApplyPatch -Patch ($GameFiles.models + $file) -FullPath }
    }



    # DIFFICULTY #

    if (IsChecked $Redux.Hero.MasterQuest)                     { ApplyPatch -Patch "Decompressed\optional\master_quest_remix.ppf"           }
    if (IsChecked $Redux.Hero.RaisedResearchLabPlatform)       { ApplyPatch -Patch "Decompressed\optional\raised_research_lab_platform.ppf" }



    # GAMEPLAY #

    if (IsChecked $Redux.Gameplay.FierceDeity)                 { ApplyPatch -Patch "Decompressed\optional\fda.ppf" }

}



#==============================================================================================================================================================================================
function ByteOptions() {

    # GAMEPLAY #

    if (IsChecked $Redux.Gameplay.FormItems) {
        ChangeBytes -Offset "C58950" -Values "01";             ChangeBytes -Offset "C58956" -Values "01 01 00 01 01 00 01 01 01"; ChangeBytes -Offset "C58978" -Values "01 01 01 01 01 01 01 01 01 01 01 01 01"; ChangeBytes -Offset "C589C8" -Values "01 01 00 01 01"
        ChangeBytes -Offset "C58A3A" -Values "01 01 01 01 01"; ChangeBytes -Offset "C58AAE" -Values "01 01 01";                   ChangeBytes -Offset "CA587C" -Values "01";                                     ChangeBytes -Offset "CA5881" -Values "01 01 01 00 01 01 01 01 01 01 00 00 01"
        ChangeBytes -Offset "CA589A" -Values "01 01 00 01 01"; ChangeBytes -Offset "CA58B2" -Values "01 01 01 01 01";             ChangeBytes -Offset "CA58CC" -Values "01 01 01"
    }

    if     (IsIndex -Elem $Redux.Gameplay.LinkJumpAttack -Text "Frontflip")        { ChangeBytes -Offset "1098721" -Values "0B"; PatchBytes  -Offset "75F1B0" -Patch "frontflip_jump_attack.bin" }
    elseif (IsIndex -Elem $Redux.Gameplay.LinkJumpAttack -Text "Beta Frontflip")   { ChangeBytes -Offset "CD72B2"  -Values "D8 50" }
    elseif (IsIndex -Elem $Redux.Gameplay.LinkJumpAttack -Text "Beta Backflip")    { ChangeBytes -Offset "CD72B2"  -Values "D7 F0" }
    elseif (IsIndex -Elem $Redux.Gameplay.LinkJumpAttack -Text "Spin Slash")       { ChangeBytes -Offset "CD72B2"  -Values "D7 E0" }
    elseif (IsIndex -Elem $Redux.Gameplay.LinkJumpAttack -Text "Zora Jumpslash")   { ChangeBytes -Offset "CD72B2"  -Values "E3 F0" }

    if     (IsIndex -Elem $Redux.Gameplay.ZoraJumpAttack -Text "Beta Frontflip")   { ChangeBytes -Offset "CD72C2"  -Values "D8 50" }
    elseif (IsIndex -Elem $Redux.Gameplay.ZoraJumpAttack -Text "Beta Backflip")    { ChangeBytes -Offset "CD72C2"  -Values "D7 F0" }
    elseif (IsIndex -Elem $Redux.Gameplay.ZoraJumpAttack -Text "Spin Slash")       { ChangeBytes -Offset "CD72C2"  -Values "D7 E0" }
    
    if (IsChecked $Redux.Gameplay.ZoraPhysics)         { PatchBytes  -Offset "65D000"  -Patch "zora_physics_fix.bin" }
    if (IsChecked $Redux.Gameplay.DistantZTargeting)   { ChangeBytes -Offset "B4E924"  -Values "00 00 00 00"         }
    if (IsChecked $Redux.Gameplay.ManualJump)          { ChangeBytes -Offset "CB4008"  -Values "04 C1"; ChangeBytes -Offset "CB402B" -Values "01" }
    if (IsChecked $Redux.Gameplay.FDSpinAttack)        { ChangeBytes -Offset "CAD780"  -Values "24 00"     }
    if (IsChecked $Redux.Gameplay.FrontflipJump)       { ChangeBytes -Offset "1098E4D" -Values "23 34 D0"  }
    if (IsChecked $Redux.Gameplay.NoShieldRecoil)      { ChangeBytes -Offset "CAEDD0"  -Values "24 00"     }
    if (IsChecked $Redux.Gameplay.SunSong)             { ChangeBytes -Offset "C5CE71"  -Values "02"        }
    if (IsChecked $Redux.Gameplay.SariaSong)           { ChangeBytes -Offset "C5CE72"  -Values "08"        }

    

    # RESTORE #

    if (IsChecked $Redux.Restore.RomaniSign)   { PatchBytes  -Offset "26A58C0" -Texture -Patch "romani_sign.bin" }
    if (IsChecked $Redux.Restore.Title)        { ChangeBytes -Offset "DE0C2E"  -Values "FF C8 36 10 98 00" }

    if (IsChecked $Redux.Restore.RupeeColors) {
        ChangeBytes -Offset "10ED020" -Values "70 6B BB 3F FF FF EF 3F 68 AD C3 FD E6 BF CD 7F 48 9B 91 AF C3 7D BB 3D 40 0F 58 19 88 ED 80 AB" # Purple
        ChangeBytes -Offset "10ED040" -Values "D4 C3 F7 49 FF FF F7 E1 DD 03 EF 89 E7 E3 E7 DD A3 43 D5 C3 DF 85 E7 45 7A 43 82 83 B4 43 CC 83" # Gold
    }

    if (IsChecked $Redux.Restore.CowNoseRing) {
        ChangeBytes -Offset "E10270"  -Values "00 00"
        ChangeBytes -Offset "107F5C4" -Values "00 00"
    }

    if (IsChecked $Redux.Restore.SkullKid) {
        $Values = @()
        for ($i=0; $i -lt 256; $i++) {
            $Values += 0
            $Values += 1
        }
        ChangeBytes -Offset "181C820" -Values $Values
        PatchBytes  -Offset "181C620" -Texture -Patch "skull_kid_beak.bin"
    }

    if (IsChecked $Redux.Restore.ShopMusic)           { ChangeBytes -Offset "2678007" -Values "44"                }
    if (IsChecked $Redux.Restore.IkanaCastle)         { ChangeBytes -Offset "2055505" -Values "02 3E E0 03 01 1D" }
    if (IsChecked $Redux.Restore.PieceOfHeartSound)   { ChangeBytes -Offset "BA94C8"  -Values "10 00"             }
    if (IsChecked $Redux.Restore.MoveBomberKid)       { ChangeBytes -Offset "2DE4396" -Values "02 C5 01 18 FB 55 00 07 2D" }
    if (IsChecked $Redux.Restore.OnTheMoonIntro)      { ChangeBytes -Offset "2D5A6CE" -Values "00 00"             }



    # OTHER #

    if (IsChecked $Redux.Other.ClockTown) {
        ChangeBytes -Offset "2E5F200" -Values "FE 77"; ChangeBytes -Offset "2E5F203" -Values "C8";    ChangeBytes -Offset "2E5F20A" -Values "F6 AF EC 69 CA"     # South Clock Town - Ramp                                              
        ChangeBytes -Offset "2E60552" -Values "00 00"; ChangeBytes -Offset "2E60562" -Values "00 00"; ChangeBytes -Offset "2E60592" -Values "00 00"              # South Clock Town - Wall
        ChangeBytes -Offset "2E7F451" -Values "7A";    ChangeBytes -Offset "2E7F455" -Values "63";    ChangeBytes -Offset "2E7F458" -Values "0E A6"              # Laundry Pool - Path
        ChangeBytes -Offset "2E7FA61" -Values "7A";    ChangeBytes -Offset "2E7FA65" -Values "63";    ChangeBytes -Offset "2E7FA68" -Values "17 55"              # Laundry Pool - Path
        ChangeBytes -Offset "2E33106" -Values "20";    ChangeBytes -Offset "2E3311E" -Values "C1";    ChangeBytes -Offset "2E33125" -Values "05 05" -Interval 32 # North Clock Town - Road           
    }

    if (IsChecked $Redux.Other.SouthernSwamp) {
        CreateSubPath  -Path ($GameFiles.extracted + "\Southern Swamp")
        ExportAndPatch -Path "Southern Swamp\southern_swamp_cleared_scene"  -Offset "1F0D000" -Length "10630"
        ExportAndPatch -Path "Southern Swamp\southern_swamp_cleared_room_0" -Offset "1F1E000" -Length "1B240" -NewLength "1B4F0" -TableOffset "1EC26"  -Values "94 F0"
        ExportAndPatch -Path "Southern Swamp\southern_swamp_cleared_room_2" -Offset "1F4D000" -Length "D0A0"  -NewLength "D1C0"  -TableOffset "1EC46"  -Values "A1 C0"
    }

    if (IsChecked $Redux.Other.DebugMapSelect) {
        # ChangeBytes -Offset "C53F44" -Values "00 C7 AD F0 00 C7 E2 D0 80 80 09 10 80 80 3D F0 00 00 00 00 80 80 1B 4C 80 80 1B 28"
        ExportAndPatch -Path "map_select" -Offset "C7C870" -Length "13C8"
    }

    if (IsChecked $Redux.Other.AlwaysBestEnding) {
        ChangeBytes -Offset "B81CE0" -Values "00 00 00 00"; ChangeBytes -Offset "B81D48" -Values "00 00 00 00"; ChangeBytes -Offset "B81DB0" -Values "00 00 00 00"; ChangeBytes -Offset "B81E18" -Values "00 00 00 00"; ChangeBytes -Offset "B81E80" -Values "00 00 00 00"
        ChangeBytes -Offset "B81EE8" -Values "00 00 00 00"; ChangeBytes -Offset "B81F84" -Values "00 00 00 00"; ChangeBytes -Offset "B81FEC" -Values "00 00 00 00"; ChangeBytes -Offset "B82054" -Values "00 00 00 00"
    }

    if (IsChecked $Redux.Other.PictoboxDelayFix)    { ChangeBytes -Offset "BFC368"  -Values "00 00 00 00"              }
    if (IsChecked $Redux.Other.MushroomBottle)      { ChangeBytes -Offset "CD7C48"  -Values "1E 6B"                    }
    if (IsChecked $Redux.Other.GreatBay)            { ChangeBytes -Offset "26F0BC9" -Values "0F 0F 5F 5F" -Interval 16 }
    if (IsChecked $Redux.Other.FairyFountain)       { ChangeBytes -Offset "B9133E"  -Values "01 0F"                    }
    if (IsChecked $Redux.Other.OutOfBoundsGrotto)   { ChangeBytes -Offset "2C2306A" -Values "FE DA 00 8B 00 A1"        }
    if (IsChecked $Redux.Other.OutOfBoundsRupee)    { $offset = SearchBytes -Start "2563000" -End "2564000" -Values "00 10 00 00 03 3C 00 07 00 7F 00 7F 0A 00 00 0E"; ChangeBytes -Offset $offset -Values "FD 66" }
    if (IsChecked $Redux.Other.DebugItemSelect)     { ExportAndPatch -Path "inventory_editor" -Offset "CA6370" -Length "1E0" }
    


    # CUTSCENES

    if (IsChecked $Redux.Cutscenes.GiantsRealm) {
        ChangeBytes -Offset "2D91403" -Values "08"; ChangeBytes -Offset "2D91463" -Values "08"; ChangeBytes -Offset "2D914C3" -Values "08"; ChangeBytes -Offset "2D91523" -Values "08"
        ChangeBytes -Offset "2D91583" -Values "08"; ChangeBytes -Offset "2D915E3" -Values "08"; ChangeBytes -Offset "2D91647" -Values "08"
    }

    if (IsChecked $Redux.Cutscenes.MountainVillage) {
        ChangeBytes -Offset "2BDD649" -Values "0C";          ChangeBytes -Offset "2BDD665" -Values "F9"; ChangeBytes -Offset "2BDD669" -Values "FC"
        ChangeBytes -Offset "2BDD674" -Values "00 BC 01 EB"; ChangeBytes -Offset "2BFC281" -Values "43"; ChangeBytes -Offset "2BDA927" -Values "19"
    }

    if (IsChecked $Redux.Cutscenes.IkanaCanyon) {
        ChangeBytes -Offset "2043BD0" -Values "04 04 00" -Interval 16; ChangeBytes -Offset "2049150" -Values "04 04 00" -Interval 16
        ChangeBytes -Offset "2055A09" -Values "08"; ChangeBytes -Offset "2055A2E" -Values "01 E5"; ChangeBytes -Offset "207F1E9" -Values "08"; ChangeBytes -Offset "207F20E" -Values "01 E5"; ChangeBytes -Offset "2080239" -Values "08"; ChangeBytes -Offset "208025E" -Values "01 E5"
        ChangeBytes -Offset "20841A9" -Values "08"; ChangeBytes -Offset "20841C6" -Values "01 E5"; ChangeBytes -Offset "2087359" -Values "08"; ChangeBytes -Offset "208737E" -Values "01 E5"
    }

    if (IsChecked $Redux.Cutscenes.GohtAwakening)     { ChangeBytes -Offset "F6DE89" -Values "8D 00 02 10 00 00 0A" }
    if (IsChecked $Redux.Cutscenes.BombLady)          { ChangeBytes -Offset "2E2E3E6" -Values "02 7F" -Interval 16 }



    # GRAPHICS #

    if (IsChecked $Redux.Graphics.WidescreenAlt) {
        if ($IsWiiVC) { # 16:9 Widescreen
            ChangeBytes -Offset "BD5D74" -Values "3C 07 3F E3"
            ChangeBytes -Offset "CA58F5" -Values "6C 53 6C 84 9E B7 53 6C" -Interval 2

            ChangeBytes -Offset "B9F2DF" -Values "1E" # Dungeon Map - Floors (1A -> 27)
            ChangeBytes -Offset "B9F2EF" -Values "18" # Dungeon Map - Floors (14 -> 21)
            ChangeBytes -Offset "B9F563" -Values "1E" # Dungeon Map - Offscreen Current Floor (1A -> 27)
            ChangeBytes -Offset "B9F573" -Values "18" # Dungeon Map - Offscreen Current Floor (14 -> 21)
            ChangeBytes -Offset "B9F4BB" -Values "7B" # Dungeon Map - Current Floor (6B -> 9F)
            ChangeBytes -Offset "B9F4CB" -Values "5F" # Dungeon Map - Current Floor (4F -> 83)
            ChangeBytes -Offset "B9F88B" -Values "80" # Dungeon Map - Map Display (90 -> C4)
            

            ChangeBytes -Offset "C98467" -Values "4F" # Dungeon Map - Link Icon (3E -> 72)
            ChangeBytes -Offset "C984FB" -Values "7C" # Dungeon Map - Bos Icon (6C -> A0)

            ChangeBytes -Offset "C979E3" -Values "62" # Dungeon Map - Stray Fairy Current Number (58 -> 8C)
            ChangeBytes -Offset "C9791F" -Values "73" # Dungeon Map - Stray Fairy Slash Shadow (6B -> 9F)
            ChangeBytes -Offset "C97787" -Values "78" # Dungeon Map - Stray Fairy Max Number (74 -> A8)

            ChangeBytes -Offset "C9795B" -Values "1E" # Dungeon Map - Stray Fairy Slash (1C -> 29)
            ChangeBytes -Offset "C97993" -Values "1C" # Dungeon Map - Stray Fairy Slash (1A -> 27)
            ChangeBytes -Offset "C981F3" -Values "1A 35 EF 82 90 3C 19 00 12 37 39 82 30 24 4D 00 08 AE 0D 02 B0" # Dungeon Map - Stray Fairy Icon (22 35 EF 82 90 3C 19 00 1A 37 39 82 30 24 4D 00 08 AE 0D 02 B0)
        }

        PatchBytes -Offset "A9A000" -Length "12C00" -Texture -Patch "Widescreen\carnival_of_time.bin"
        PatchBytes -Offset "AACC00" -Length "12C00" -Texture -Patch "Widescreen\four_giants.bin"
        PatchBytes -Offset "C74DD0" -Length "800"   -Texture -Patch "Widescreen\lens_of_truth.bin"
    }

    if (IsIndex -Elem $Redux.Styles.HairColor -Not) {
        $offset = -1; $folder = "" 

        if     (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Original")                    { $offset = "1160400"; $folder = "Majora's Mask"   }
        elseif (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Majora's Mask + OoT Eyes")    { $offset = "1160400"; $folder = "Majora's Mask"   }
        elseif (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Ocarina of Time")             { $offset = "1164290"; $folder = "Ocarina of Time" }
        elseif (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Ocarina of Time + MM Eyes")   { $offset = "1164290"; $folder = "Ocarina of Time" }
       #elseif (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Improved Link")               { $offset = "1160600"; $folder = "Improved Link"   }
       #elseif (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Improved Link + OoT Eyes")    { $offset = "1160600"; $folder = "Improved Link"   }
       #elseif (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Adult Link (MM)")             { $offset = "1162600"; $folder = "Majora's Mask"   }

        if ($offset -gt -1) { PatchBytes -Offset $offset -Shared -Patch ("Hair\" + $folder + "\" + $Redux.Styles.HairColor.Text + ".bin") }
    }

    if (IsChecked $Redux.Graphics.ExtendedDraw)     { ChangeBytes -Offset "B50874"  -Values "00 00 00 00"      }
    if (IsChecked $Redux.Graphics.PixelatedStars)   { ChangeBytes -Offset "B943FC"  -Values "10 00"            }



    # INTERFACE #

    if ( !((IsIndex -Elem $Redux.UI.ButtonSize -Text "Large") -and (IsIndex -Elem $Redux.UI.ButtonStyle -Text "Majora's Mask")) ) {
        PatchBytes -Offset "1EBDF60" -Shared -Patch ("Buttons\" + $Redux.UI.ButtonSize.Text.replace(" (default)", "") + "\" + $Redux.UI.ButtonStyle.Text.replace(" (default)", "") + ".bin")
    }

    

    if (IsChecked $Redux.UI.CenterTatlPrompt) {
        if (IsChecked $Redux.Graphics.Widescreen) {
            foreach ($i in 0..($GamePatch.Languages.Length-1)) {
                if (IsChecked $Redux.Language[$i]) {
                    if ($LanguagePatch.tatl -eq "Tatl" -and (IsIndex -Elem $Redux.Text.TatlCUp -Not) )   { $Taya = $True }
                    if ($LanguagePatch.tatl -eq "Taya" )                                                 { $Taya = $True }
                    else                                                                                 { $Taya = $False }
                }
            }
            if ($Taya)   { ChangeBytes -Offset "BADD28" -Values "35 CE C0 78 3C 18 00 57 37 18 40 48 24 6F 00 08 AE 0F 02 A0" }
            else         { ChangeBytes -Offset "BADD28" -Values "35 CE C0 78 3C 18 00 57 37 18 80 48 24 6F 00 08 AE 0F 02 A0" }

        }
        else { ChangeBytes -Offset "BADD28" -Values "35 CE C0 78 3C 18 00 3D 37 18 40 48 24 6F 00 08 AE 0F 02 A0" }
    }

    if (IsChecked $Redux.UI.GCScheme) {
        # Z to L textures
        PatchBytes -Offset "A7B7CC"  -Texture -Patch "GameCube\l_pause_screen_button.yaz0"
        PatchBytes -Offset "AD0980"  -Texture -Patch "GameCube\dpad_text_icon.bin"
        PatchBytes -Offset "AD0A80"  -Texture -Patch "GameCube\l_text_icon.bin"
        if (TestFile ($GameFiles.textures + "\GameCube\l_targeting_" + $LanguagePatch.code + ".bin")) { PatchBytes -Offset "1E90D00" -Texture -Patch ("GameCube\l_targeting_" + $LanguagePatch.code + ".bin") }
    }

    <#if (IsChecked $Redux.UI.ButtonPositions) {
        ChangeBytes -Offset "BAF2E3" -Values "04"       -Subtract # A Button         - X position (BE -> BA, -04)   ChangeBytes -Offset "BAF393" -Values "04"       -Subtract # A Text           - X position (BE -> BA, -04)
        ChangeBytes -Offset "C55F15" -Values "07"       -Subtract # B Button         - X position (A7 -> A0, -07)   ChangeBytes -Offset "C55F05" -Values "07 00 07" -Subtract # B Text           - X position (9B -> 94, -07)
    }#>

    if ( (IsChecked $Redux.UI.HUD) -or (IsChecked $Redux.UI.Rupees)      )   { PatchBytes -Offset "1EBDE60" -Shared -Patch "HUD\Rupees\Ocarina of Time.bin" }
    if ( (IsChecked $Redux.UI.HUD) -or (IsChecked $Redux.UI.DungeonKeys) )   { PatchBytes -Offset "1EBDD60" -Shared -Patch "HUD\Keys\Ocarina of Time.bin"   }
    if   (IsDefault -Elem $Redux.UI.Hearts -Not)                             { PatchBytes -Offset "1EBD000" -Shared -Patch ("HUD\Hearts\" + $Redux.UI.Hearts.Text.replace(" (default)", "") + ".bin") }
    if   (IsDefault -Elem $Redux.UI.Magic  -Not)                             { PatchBytes -Offset "1EC1DA0" -Shared -Patch ("HUD\Magic\"  + $Redux.UI.Magic.Text.replace(" (default)", "")  + ".bin") }
    if   (IsChecked $Redux.UI.BlackBars)                                     { ChangeBytes -Offset "BF72A4" -Values "00 00 00 00" }
    if   (IsChecked $Redux.UI.HUD)                                           { PatchBytes -Offset "1EBD000" -Shared -Patch "HUD\Hearts\Ocarina of Time.bin"; PatchBytes -Offset "1EC1DA0" -Shared -Patch "HUD\Magic\Ocarina of Time.bin" }
    


    # EFFECTS #

    if (IsChecked $Redux.Graphics.MotionBlur)         { ChangeBytes -Offset "BFB9A0"  -Values "03 E0 00 08 00 00 00 00 00" }
    if (IsChecked $Redux.Graphics.FlashbackOverlay)   { ChangeBytes -Offset "BFEB8C"  -Values "24 0F 00 00"                }



    # HIDE (Custom edits added by Marcelo - Hide Buttons) #

    if ( (IsChecked $Redux.Hide.AButton) -or (IsChecked $Redux.Hide.Everything) ) { # A Button
        ChangeBytes -Offset "BA55F8" -Values "00 00 00 00"; ChangeBytes -Offset "BA5608" -Values "00 00 00 00"; ChangeBytes -Offset "BA5A04" -Values "00 00 00 00"; ChangeBytes -Offset "BA5DA8" -Values "00 00 00 00"
        ChangeBytes -Offset "BA5FE8" -Values "00 00 00 00"; ChangeBytes -Offset "BA60A0" -Values "00 00 00 00"; ChangeBytes -Offset "BA64F0" -Values "00 00 00 00"
    }

    if ( (IsChecked $Redux.Hide.BButton) -or (IsChecked $Redux.Hide.Everything) ) { # B Button
        ChangeBytes -Offset "BA5528" -Values "00 00 00 00"; ChangeBytes -Offset "BA5544" -Values "00 00 00 00"; ChangeBytes -Offset "BA5CC4" -Values "00 00 00 00"; ChangeBytes -Offset "BA5DE8" -Values "00 00 00 00"
        ChangeBytes -Offset "BA5FD8" -Values "00 00 00 00"; ChangeBytes -Offset "BA60B0" -Values "00 00 00 00"; ChangeBytes -Offset "BA6500" -Values "00 00 00 00"
    }

    if ( (IsChecked $Redux.Hide.CButtons) -or (IsChecked $Redux.Hide.Everything) ) {
        ChangeBytes -Offset "BA5568" -Values "00 00 00 00"; ChangeBytes -Offset "BA5578" -Values "00 00 00 00"; ChangeBytes -Offset "BA5FF8" -Values "00 00 00 00"; ChangeBytes -Offset "BA60C0" -Values "00 00 00 00" # C-Left
        ChangeBytes -Offset "BA5598" -Values "00 00 00 00"; ChangeBytes -Offset "BA55A8" -Values "00 00 00 00"; ChangeBytes -Offset "BA6008" -Values "00 00 00 00"; ChangeBytes -Offset "BA60D0" -Values "00 00 00 00" # C-Down
        ChangeBytes -Offset "BA55C8" -Values "00 00 00 00"; ChangeBytes -Offset "BA55D8" -Values "00 00 00 00"; ChangeBytes -Offset "BA6018" -Values "00 00 00 00"; ChangeBytes -Offset "BA60E4" -Values "00 00 00 00" # C-Right
    }

    if ( (IsChecked $Redux.Hide.Hearts) -or (IsChecked $Redux.Hide.Everything) ) { # Health
        ChangeBytes -Offset "BA5B28" -Values "00 00 00 00"; ChangeBytes -Offset "BA5BFC" -Values "00 00 00 00"; ChangeBytes -Offset "BA5A14" -Values "00 00 00 00"
        ChangeBytes -Offset "BA603C" -Values "00 00 00 00"; ChangeBytes -Offset "BA6530" -Values "00 00 00 00"; ChangeBytes -Offset "BB787C" -Values "00 00 00 00"
    }

    if ( (IsChecked $Redux.Hide.Magic) -or (IsChecked $Redux.Hide.Everything) ) { # Magic Meter and Rupees
        ChangeBytes -Offset "BA5A28" -Values "00 00 00 00"; ChangeBytes -Offset "BA5B3C" -Values "00 00 00 00"; ChangeBytes -Offset "BA5BE8" -Values "00 00 00 00"
        ChangeBytes -Offset "BA6028" -Values "00 00 00 00"; ChangeBytes -Offset "BA6520" -Values "00 00 00 00"; ChangeBytes -Offset "BB788C" -Values "00 00 00 00"
    }

    if ( (IsChecked $Redux.Hide.Clock) -or (IsChecked $Redux.Hide.Everything) ) { # Clock
		ChangeBytes -Offset "BAFD5C" -Values "00 00 00 00"; ChangeBytes -Offset "BAFC48" -Values "00 00 00 00"; ChangeBytes -Offset "BAFDA8" -Values "00 00 00 00"
		ChangeBytes -Offset "BAFD00" -Values "00 00 00 00"; ChangeBytes -Offset "BAFD98" -Values "00 00 00 00"; ChangeBytes -Offset "C5606D" -Values "00"
    }

    if ( (IsChecked $Redux.Hide.CountdownTimer) -or (IsChecked $Redux.Hide.Everything) )   { ChangeBytes -Offset "BB169A" -Values "01 FF";       ChangeBytes -Offset "C56180" -Values "01 FF 01 FF 01 FF 01 FF 01 FF 01 FF 01 FF 01 FF" } # Disable Countdown timer background / Disable Countdown timer
    if ( (IsChecked $Redux.Hide.AreaTitle)      -or (IsChecked $Redux.Hide.Everything) )   { ChangeBytes -Offset "B80A64" -Values "10 00 01 9E"; ChangeBytes -Offset "B842C0" -Values "10 00 00 04"                                     } # Disable Area Title Cards
    if   (IsChecked $Redux.Hide.Credits)                                                   { PatchBytes  -Offset "B3B000" -Patch "Message\credits.bin" }



    # STYLES #

    if (IsDefault $Redux.Styles.RegularChests -Not)   { PatchBytes -Offset "11E3E60" -Shared -Patch ("Chests\" + $Redux.Styles.RegularChests.Text + ".front"); PatchBytes  -Offset "11E4E60" -Shared -Patch ("Chests\" + $Redux.Styles.RegularChests.Text + ".back") }
    if (IsDefault $Redux.Styles.LeatherChests -Not)   { PatchBytes -Offset "11E5660" -Shared -Patch ("Chests\" + $Redux.Styles.LeatherChests.Text + ".front"); PatchBytes  -Offset "11E6660" -Shared -Patch ("Chests\" + $Redux.Styles.LeatherChests.Text + ".back") }
    if (IsDefault $Redux.Styles.BossChests    -Not)   { PatchBytes -Offset "11E6E60" -Shared -Patch ("Chests\" + $Redux.Styles.BossChests.Text    + ".front"); PatchBytes  -Offset "11E7E60" -Shared -Patch ("Chests\" + $Redux.Styles.BossChests.Text    + ".back") }
    if (IsDefault $Redux.Styles.Crates        -Not)   { PatchBytes -Offset "113A2C0" -Shared -Patch ("Crates\" + $Redux.Styles.Crates.Text        + ".bin") }
    if (IsDefault $Redux.Styles.Pots          -Not)   { PatchBytes -Offset "1138EC0" -Shared -Patch ("Pots\"   + $Redux.Styles.Pots.Text          + ".bin") }


    # SOUNDS / VOICES / SFX SOUND EFFECTS #

    if (IsDefault $Redux.Sounds.LowHP            -Not)   { ChangeBytes -Offset "B97E2A" -Values (GetSFXID $Redux.Sounds.LowHP.Text) }
    if (IsDefault $Redux.Sounds.InstrumentHylian -Not)   { ChangeBytes -Offset "51CBE"  -Values (GetMMInstrumentID $Redux.Sounds.InstrumentHylian.Text); ChangeBytes -Offset "C668DC" -Values (GetMMInstrumentID $Redux.Sounds.InstrumentHylian.Text) }
    if (IsDefault $Redux.Sounds.InstrumentDeku   -Not)   { ChangeBytes -Offset "51CC6"  -Values (GetMMInstrumentID $Redux.Sounds.InstrumentDeku.Text);   ChangeBytes -Offset "C668DF" -Values (GetMMInstrumentID $Redux.Sounds.InstrumentDeku.Text)   }
    if (IsDefault $Redux.Sounds.InstrumentGoron  -Not)   { ChangeBytes -Offset "51CC4"  -Values (GetMMInstrumentID $Redux.Sounds.InstrumentGoron.Text);  ChangeBytes -Offset "C668DD" -Values (GetMMInstrumentID $Redux.Sounds.InstrumentGoron.Text)  }
    if (IsDefault $Redux.Sounds.InstrumentZora   -Not)   { ChangeBytes -Offset "51CC5"  -Values (GetMMInstrumentID $Redux.Sounds.InstrumentZora.Text);   ChangeBytes -Offset "C668DE" -Values (GetMMInstrumentID $Redux.Sounds.InstrumentZora.Text)   }

    $file = "Voices Child\" + $Redux.Sounds.ChildVoices.Text.replace(" (default)", "") + ".bin"
    if (TestFile ($GameFiles.binaries + "\" + $file)) { PatchBytes -Offset "1FA5A0" -Patch ($file) }

    $file = "Voices Fierce Deity\" + $Redux.Sounds.FierceDeityVoices.Text.replace(" (default)", "") + ".bin"
    if (TestFile ($GameFiles.binaries + "\" + $file)) { PatchBytes -Offset "1BA2E0" -Patch ($file) }



    # MUSIC #

    if (IsAdvanced) {
        PatchReplaceMusic -BankPointerTableStart "C77A60" -BankPointerTableEnd "C77B70" -PointerTableStart "C77B80" -PointerTableEnd "C78380" -SeqStart "46AF0" -SeqEnd "97F70"
        PatchMuteMusic -SequenceTable "C77B80" -Sequence "46AF0" -Length 127
    }

    if (IsIndex -Elem $Redux.Music.FileSelect -Text $Redux.Music.FileSelect.default -Not) {
        foreach ($track in $Files.json.music.tracks) {
            if ($Redux.Music.FileSelect.Text -eq $track.title) {
                ChangeBytes -Offset "C8E2AB" -Values $track.id
                break
            }
        }
    }



    # HERO MODE #

    if (IsText -Elem $Redux.Hero.Damage -Compare "OHKO Mode") {
        ChangeBytes -Offset "BABE7F" -Values "09 04" -Interval 16
        ChangeBytes -Offset "BABEA2" -Values "2A 00"
        ChangeBytes -Offset "BABEA5" -Values "00 00 00"
    }
    elseif ( (IsIndex -Elem $Redux.Hero.Damage -Not) -or (IsIndex -Elem $Redux.Hero.Recovery -Not) -or (IsChecked $Redux.Hero.NoRecoveryHearts) ) {
        ChangeBytes -Offset "BABE7F" -Values "09 04" -Interval 16
        if       ( (IsText -Elem $Redux.Hero.Recovery -Compare "0x Recovery") -or (IsChecked $Redux.Hero.NoRecoveryHearts) ) {
            if     (IsText -Elem $Redux.Hero.Damage   -Compare "1x Damage")   { ChangeBytes -Offset "BABEA2" -Values "29 40" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "2x Damage")   { ChangeBytes -Offset "BABEA2" -Values "29 80" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "4x Damage")   { ChangeBytes -Offset "BABEA2" -Values "29 C0" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "8x Damage")   { ChangeBytes -Offset "BABEA2" -Values "2A 00" }
            ChangeBytes -Offset "BABEA5" -Values "05 29 43"
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Compare "1x Recovery") {
            if     (IsText -Elem $Redux.Hero.Damage   -Compare "2x Damage")   { ChangeBytes -Offset "BABEA2" -Values "28 40" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "4x Damage")   { ChangeBytes -Offset "BABEA2" -Values "28 80" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "8x Damage")   { ChangeBytes -Offset "BABEA2" -Values "28 C0" }
            ChangeBytes -Offset "BABEA5" -Values "00 00 00"
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Compare "1/2x Recovery") {
            if     (IsText -Elem $Redux.Hero.Damage   -Compare "1x Damage")   { ChangeBytes -Offset "BABEA2" -Values "28 40" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "2x Damage")   { ChangeBytes -Offset "BABEA2" -Values "28 80" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "4x Damage")   { ChangeBytes -Offset "BABEA2" -Values "28 C0" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "8x Damage")   { ChangeBytes -Offset "BABEA2" -Values "29 00" }
            ChangeBytes -Offset "BABEA5" -Values "05 28 43"
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Compare "1/4x Recovery") {
            if     (IsText -Elem $Redux.Hero.Damage   -Compare "1x Damage")   { ChangeBytes -Offset "BABEA2" -Values "28 80" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "2x Damage")   { ChangeBytes -Offset "BABEA2" -Values "28 C0" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "4x Damage")   { ChangeBytes -Offset "BABEA2" -Values "29 00" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "8x Damage")   { ChangeBytes -Offset "BABEA2" -Values "29 40" }
            ChangeBytes -Offset "BABEA5" -Values "05 28 83"
        }
    }

    if     (IsText -Elem $Redux.Hero.MagicUsage -Compare "2x Magic Usage")   { ChangeBytes -Offset "BAC306" -Values "2C","40" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "4x Magic Usage")   { ChangeBytes -Offset "BAC306" -Values "2C","80" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "8x Magic Usage")   { ChangeBytes -Offset "BAC306" -Values "2C","C0" }
    if     (IsText -Elem $Redux.Hero.MagicUsage -Compare "2x Item Usage")    { ChangeBytes -Offset "BABF5E" -Values "2C","40" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "4x Item Usage")    { ChangeBytes -Offset "BABF5E" -Values "2C","80" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "8x Item Usage")    { ChangeBytes -Offset "BABF5E" -Values "2C","C0" }

    if (IsIndex -Elem $Redux.Hero.MonsterHP -Index 3 -Not) { # Monsters
        if (IsIndex -Elem $Redux.Hero.MonsterHP)   { $multi = 0   }
        else                                       { [float]$multi = [float]$Redux.Hero.MiniBossHP.text.split('x')[0] }
        
        MultiplyBytes -Offset "D4E07F" -Factor $multi; MultiplyBytes -Offset "E0790F" -Factor $multi; MultiplyBytes -Offset "F94A00" -Factor $multi # ReDead / Gibdo, Stalchild, Poe
        MultiplyBytes -Offset "D2F07C" -Factor $multi; MultiplyBytes -Offset "D6CFB8" -Factor $multi; MultiplyBytes -Offset "F5B7FC" -Factor $multi # Deku Baba, Wilted Deku Baba, Dexihand
        MultiplyBytes -Offset "D55BDC" -Factor $multi; MultiplyBytes -Offset "D55C08" -Factor $multi # Skullwalltula, Golden Skullwalltula
        MultiplyBytes -Offset "CF3514" -Factor $multi; MultiplyBytes -Offset "CF0A4B" -Factor $multi # Dodongo (Small / Big)
        MultiplyBytes -Offset "D10D3C" -Factor $multi; MultiplyBytes -Offset "D0DBDB" -Factor $multi # Red Tektite, Blue Tektite
        MultiplyBytes -Offset "CF05CC" -Factor $multi; MultiplyBytes -Offset "D4DA9C" -Factor $multi # Wallmaster, Floormaster
        MultiplyBytes -Offset "D13750" -Factor $multi; MultiplyBytes -Offset "D1375C" -Factor $multi # Peahat, Peahat Larva
        MultiplyBytes -Offset "E0336B" -Factor $multi; MultiplyBytes -Offset "E07028" -Factor $multi # Wolfos
        MultiplyBytes -Offset "D3D9DC" -Factor $multi; MultiplyBytes -Offset "D3AFBC" -Factor $multi # Blue Bubble, Red Bubble
        MultiplyBytes -Offset "EAE53C" -Factor $multi; MultiplyBytes -Offset "E0EE24" -Factor $multi # Bad Bat, Guay
        MultiplyBytes -Offset "D47754" -Factor $multi; MultiplyBytes -Offset "D76388" -Factor $multi # Beamos, Like-Like
        MultiplyBytes -Offset "D5E0E3" -Factor $multi; MultiplyBytes -Offset "F3E82C" -Factor $multi # Shell Blade, Snapper
        MultiplyBytes -Offset "D3914C" -Factor $multi; MultiplyBytes -Offset "CEACD8" -Factor $multi # Mad Scrub, Octorok
        MultiplyBytes -Offset "F7ED78" -Factor $multi; MultiplyBytes -Offset "EC1F2C" -Factor $multi # Eeno, Real Bombchu
        MultiplyBytes -Offset "EB922C" -Factor $multi; MultiplyBytes -Offset "E9B69C" -Factor $multi # White Boe, Black Boe, Chuchu (alt: E9B66E)

      # MultiplyBytes -Offset "" -Factor $multi # Leever                    (Green)   (HP: 04)   FE1A10 -> FE3AB0 (Length: 20A0) (ovl_En_Neo_Reeba)
      # MultiplyBytes -Offset "" -Factor $multi # Leever                    (Purple)  (HP: 14)
      # MultiplyBytes -Offset "" -Factor $multi # Ghost                               (HP: ??)    ->  (Length: ) (ovl_En_??)
      # MultiplyBytes -Offset "" -Factor $multi # Garo                                (HP: ??)   E20590 -> E24200 (Length: 3C70) (ovl_En_Jso)
      # MultiplyBytes -Offset "" -Factor $multi # Giant Bee                           (HP: ??)   FBF8B0 -> FC0470 (Length: 0BC0) (ovl_En_Bee)
      # MultiplyBytes -Offset "" -Factor $multi # Nejiron                             (HP: ??)   EA4BD0 -> EA6030 (Length: 1460) (ovl_En_Baguo)
      # MultiplyBytes -Offset "" -Factor $multi # Dragonfly                           (HP: ??)   E18FF0 -> E1BE80 (Length: 2E90) (ovl_En_Grasshopper)
      # MultiplyBytes -Offset "" -Factor $multi # Skullfish                           (HP: ??)   EDB9F0 -> EDD810 (Length: 1E20) (ovl_En_Pr2)
      # MultiplyBytes -Offset "" -Factor $multi # Desbreko                            (HP: ??)   E9BD60 -> E9D650 (Length: 18F0) (ovl_En_Pr)
      # MultiplyBytes -Offset "" -Factor $multi # Death Armos                         (HP: ??)   D26B30 -> D28AD0 (Length: 1FA0) (ovl_En_Famos)
      # MultiplyBytes -Offset "" -Factor $multi # Hiploop                             (HP: ??)   F831B0 -> F86E00 (Length: 3C50) (ovl_En_Pp)
      # MultiplyBytes -Offset "" -Factor $multi # Deep Python                         (HP: ??)   FC3A10 -> FC5C50 (Length: 2240) (ovl_En_Dragon)
      # MultiplyBytes -Offset "" -Factor $multi # Bio Deku Baba                       (HP: ??)   E596F0 -> E5D320 (Length: 3C30) (ovl_Boss_05)

      # MultiplyBytes -Offset "DA556F" -Factor $multi; ChangeBytes -Offset "DA6E67" -Factor $multi # Freezard
      # MultiplyBytes -Offset "D21870" -Factor $multi; ChangeBytes -Offset "CF56BC" -Factor $multi # Skulltula, Keese
      # MultiplyBytes -Offset "D2B2F8" -Factor $multi # Armos (alt: D2B29E)
    }

    if (IsIndex -Elem $Redux.Hero.MiniBossHP -Index 3 -Not) { # Mini-Bosses
        if (IsIndex -Elem $Redux.Hero.MiniBossHP)   { $multi = 0   }
        else                                        { [float]$multi = [float]$Redux.Hero.MiniBossHP.text.split('x')[0] }

        ChangeBytes -Offset "E57387" -Factor $multi; ChangeBytes -Offset "FCA1BC"  -Factor $multi; ChangeBytes -Offset "D43C10" -Factor $multi # Wart, Big Poe, Gomess
        ChangeBytes -Offset "CE718B" -Factor $multi; ChangeBytes -Offset "CE7DB8"  -Factor $multi # Gekko & Snapper (Gekko)
        ChangeBytes -Offset "E9329C" -Factor $multi; ChangeBytes -Offset "D6A48C"  -Factor $multi # Gekko & Snapper (Snapper), Gekko & Mad Jelly
        ChangeBytes -Offset "F82D9C" -Factor $multi; ChangeBytes -Offset "F7F873"  -Factor $multi # Poe Sisters
        ChangeBytes -Offset "D18554" -Factor $multi; ChangeBytes -Offset "10785BC" -Factor $multi # Dinolfos, Takkuri
        ChangeBytes -Offset "D9F210" -Factor $multi # Iron Knuckle (phase 1, phase 2 unknown, D9C9C0-> D9F5E0 Length: 2C20 File: ovl_En_Ik)

      # MultiplyBytes -Offset -Factor $multi # Wizzrobe                               (HP: ??)   EAEE40  -> EB2AC0  (Length: 3C80) (ovl_En_Wiz)
      # MultiplyBytes -Offset -Factor $multi # Garo Master                            (HP: ??)   E20590  -> E24200  (Length: 3C70) (ovl_En_jso2)
      # MultiplyBytes -Offset -Factor $multi # Eyegore                                (HP: ??)   EE43E0  -> EE8C20  (Length: 4840) (ovl_En_Egol)
      # MultiplyBytes -Offset -Factor $multi # Gerudo Pirate                          (HP: ??)   FEA700  -> FF0440  (Length: 5D40) (ovl_En_Kaizoku)
      # MultiplyBytes -Offset -Factor $multi # Captain Keeta                          (HP: ??)   105ABA0 -> 105C460 (Length: 18C0) (ovl_En_Osk)
      # MultiplyBytes -Offset -Factor $multi # Igos du Ikana                          (HP: ??)   E24DA0  -> E31C80  (Length: CEE0) (ovl_En_Knight)
      # MultiplyBytes -Offset -Factor $multi # King's Lackeys                         (HP: ??)   ??????  -> ??????  (Length: ????) (ovl_En_??)
    }

    if (IsIndex -Elem $Redux.Hero.BossHP -Index 3 -Not) { # Bosses
        if (IsIndex -Elem $Redux.Hero.BossHP)   { $multi = 0   }
        else                                    { [float]$multi = [float]$Redux.Hero.MiniBossHP.text.split('x')[0] }

        MultiplyBytes -Offset "F73D90" -Factor $multi; MultiplyBytes -Offset "F6BF37" -Factor $multi # Goht (phase 3 missing, file: Boss_Hakugin)
        MultiplyBytes -Offset "E60633" -Factor $multi; MultiplyBytes -Offset "E6B20B" -Factor $multi # Majora's Mask (phase 1), Majora's Mask (phase 2)
        MultiplyBytes -Offset "E60743" -Factor $multi; MultiplyBytes -Offset "E606AB" -Factor $multi # Majora's Incarnation, Majora's Wrath
        MultiplyBytes -Offset "E424E7" -Factor $multi # Odolwa
        MultiplyBytes -Offset "E50D33" -Factor $multi # Gyorg (phase 2 missing, file: Boss_03)
        MultiplyBytes -Offset "E4A607" -Factor $multi # Twinmold
        MultiplyBytes -Offset "E6FA2F" -Factor $multi # Four Remains
    }

    if (IsIndex -Elem $Redux.Hero.DamageEffect -Not) {
        ChangeBytes -Offset "B79A48" -Values "24"
        ChangeBytes -Offset "B79A4B" -Values $Redux.Hero.DamageEffect.SelectedIndex
    }

    if (IsIndex -Elem $Redux.Hero.ClockSpeed -Not) {
            ChangeBytes -Offset "0BC6674" -Values "3C 01"; ChangeBytes -Offset "0BC6677" -Values "01 14 E2";                ChangeBytes -Offset "0BC667B" -Values "02 00 26 08 21 24 02 00 00"
            ChangeBytes -Offset "0BC6685" -Values "40";    ChangeBytes -Offset "0BC6687" -Values "02 00 00 00 00 24 02 00"; ChangeBytes -Offset "0BC6691" -Values "22"
            if     ($Redux.Hero.ClockSpeed.SelectedIndex -eq 1) { ChangeBytes -Offset "BB005E" -Values "00 00"; ChangeBytes -Offset "BC668F" -Values "01"; ChangeBytes -Offset "BEDB8E" -Values "00 00" }
            elseif ($Redux.Hero.ClockSpeed.SelectedIndex -eq 2) { ChangeBytes -Offset "BB005E" -Values "FF FF"; ChangeBytes -Offset "BC668F" -Values "02"; ChangeBytes -Offset "BEDB8E" -Values "FF FF" }
            elseif ($Redux.Hero.ClockSpeed.SelectedIndex -eq 3) { ChangeBytes -Offset "BB005E" -Values "FF FC"; ChangeBytes -Offset "BC668F" -Values "06"; ChangeBytes -Offset "BEDB8E" -Values "FF FC" }
            elseif ($Redux.Hero.ClockSpeed.SelectedIndex -eq 4) { ChangeBytes -Offset "BB005E" -Values "FF FA"; ChangeBytes -Offset "BC668F" -Values "09"; ChangeBytes -Offset "BEDB8E" -Values "FF FA" }
            elseif ($Redux.Hero.ClockSpeed.SelectedIndex -eq 5) { ChangeBytes -Offset "BB005E" -Values "FF F4"; ChangeBytes -Offset "BC668F" -Values "12"; ChangeBytes -Offset "BEDB8E" -Values "FF F4" }
    }

    if (IsChecked $Redux.Hero.NoItemDrops) {
        $Values = @()
        for ($i=0; $i -lt 80; $i++) { $Values += 0 }
        ChangeBytes -Offset "C44400" -Values $Values
    }

    if (IsChecked $Redux.Hero.PalaceRoute) {
        CreateSubPath  -Path ($GameFiles.extracted + "\Deku Palace")
        ExportAndPatch -Path "Deku Palace\deku_palace_scene"  -Offset "2534000" -Length "D220"
        ExportAndPatch -Path "Deku Palace\deku_palace_room_0" -Offset "2542000" -Length "11A50"
        ExportAndPatch -Path "Deku Palace\deku_palace_room_1" -Offset "2554000" -Length "E950"  -NewLength "E9B0"  -TableOffset "1F6A7" -Values "B0"
        ExportAndPatch -Path "Deku Palace\deku_palace_room_2" -Offset "2563000" -Length "124F0" -NewLength "124B0" -TableOffset "1F6B7" -Values "B0"
    }

    if (IsChecked $Redux.Hero.DeathIsMoonCrash) {
        ChangeBytes -Offset "0C40DF8" -Values "8F A2 00 18 24 0E 54 C0"; ChangeBytes -Offset "0C40E08" -Values "3C 01 00 02 00 22 08 21"
        ChangeBytes -Offset "0C40E14" -Values "A4 2E 88 7A";             ChangeBytes -Offset "0C40E1D" -Values "0E 00 14 A0 2E 88 75 A0 2C 88 7F"
    }

    if (IsChecked $Redux.Hero.CloseBombShop) {
        ChangeBytes -Offset "2CB10DA" -Values "03 60";       ChangeBytes -Offset "2CB1212" -Values "03 60"                                                           # Move Bomb Bag to Stock Pot Inn
        ChangeBytes -Offset "E76F38"  -Values "00 00 00 00"; ChangeBytes -Offset "E772DC"  -Values "24 05 06 4A"; ChangeBytes -Offset "E77CCC" -Values "24 05 06 4A" # Disable Bomb Shop
    }

    if (IsChecked $Redux.Hero.NoRecoveryHearts) { ChangeBytes -Offset "B3DC54" -Values "50" }



    # EASY MODE #

    if (IsChecked $Redux.EasyMode.NoBlueBubbleRespawn) { ChangeBytes -Offset "D3CEC0" -Values "57 20 00 04" }



    # TUNIC COLORS #

    if (IsSet $Redux.Colors.SetKokiriTunic) {
        if ( (IsDefaultColor -Elem $Redux.Colors.SetKokiriTunic -Not) -and (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Original")) {
            ChangeBytes -Offset "116639C" -Values @($Redux.Colors.SetKokiriTunic.Color.R, $Redux.Colors.SetKokiriTunic.Color.G,$Redux.Colors.SetKokiriTunic.Color.B)
            ChangeBytes -Offset "11668C4" -Values @($Redux.Colors.SetKokiriTunic.Color.R, $Redux.Colors.SetKokiriTunic.Color.G,$Redux.Colors.SetKokiriTunic.Color.B)
            ChangeBytes -Offset "1166DCC" -Values @($Redux.Colors.SetKokiriTunic.Color.R, $Redux.Colors.SetKokiriTunic.Color.G,$Redux.Colors.SetKokiriTunic.Color.B)
            ChangeBytes -Offset "1166FA4" -Values @($Redux.Colors.SetKokiriTunic.Color.R, $Redux.Colors.SetKokiriTunic.Color.G,$Redux.Colors.SetKokiriTunic.Color.B)
            ChangeBytes -Offset "1167064" -Values @($Redux.Colors.SetKokiriTunic.Color.R, $Redux.Colors.SetKokiriTunic.Color.G,$Redux.Colors.SetKokiriTunic.Color.B)
            ChangeBytes -Offset "116766C" -Values @($Redux.Colors.SetKokiriTunic.Color.R, $Redux.Colors.SetKokiriTunic.Color.G,$Redux.Colors.SetKokiriTunic.Color.B)
            ChangeBytes -Offset "1167AE4" -Values @($Redux.Colors.SetKokiriTunic.Color.R, $Redux.Colors.SetKokiriTunic.Color.G,$Redux.Colors.SetKokiriTunic.Color.B)
            ChangeBytes -Offset "1167D1C" -Values @($Redux.Colors.SetKokiriTunic.Color.R, $Redux.Colors.SetKokiriTunic.Color.G,$Redux.Colors.SetKokiriTunic.Color.B)
            ChangeBytes -Offset "11681EC" -Values @($Redux.Colors.SetKokiriTunic.Color.R, $Redux.Colors.SetKokiriTunic.Color.G,$Redux.Colors.SetKokiriTunic.Color.B)
        }
    }



    # MISC COLORS

    if (IsChecked $Redux.Colors.RedIce) { ChangeBytes -Offset "DA5354" -Values "3C 01 00 32"; ChangeBytes -Offset "DA5368" -Values "34 21 64 00" }



    # MASK FORM COLORS #

    if (IsIndex -Elem $Redux.Colors.DekuLink -Not) {
        $file = $Redux.Colors.DekuLink.Text.replace(" (default)", "")
        PatchBytes -Offset "11A9096" -Length "1C"  -Texture -Patch ("Color - Deku Link\" + $file + ".bin")
    }

    if (IsIndex -Elem $Redux.Colors.GoronLink -Not) {
        $file = $Redux.Colors.GoronLink.Text.replace(" (default)", "")
        PatchBytes -Offset "117C780" -Length "100" -Texture -Patch ("Color - Goron Link\" + $file + ".bin"); PatchBytes -Offset "1186EB8" -Length "100" -Texture -Patch ("Color - Goron Link\" + $file + ".bin")
    }

    if (IsIndex -Elem $Redux.Colors.ZoraLink -Not) {
        $file = $Redux.Colors.ZoraLink.Text.replace(" (default)", "")
        PatchBytes -Offset "1197120" -Length "50"  -Texture -Patch ("Color - Zora Link\Palette\" + $file + ".bin");  PatchBytes -Offset "119E698" -Length "50"  -Texture -Patch ("Color - Zora Link\Palette\" + $file + ".bin")
        PatchBytes -Offset "10FB0B0" -Length "400" -Texture -Patch ("Color - Zora Link\Gradient\" + $file + ".bin"); PatchBytes -Offset "11A2228" -Length "400" -Texture -Patch ("Color - Zora Link\Gradient\" + $file + ".bin")
    }



    # MAGIC SPIN ATTACK COLORS #

    if (IsSet $Redux.Colors.SetSwordTrail) {
        if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[0] -Not)   { ChangeBytes -Offset "10B08F4" -Values @($Redux.Colors.SetSpinAttack[0].Color.R, $Redux.Colors.SetSpinAttack[0].Color.G, $Redux.Colors.SetSpinAttack[0].Color.B) } # Blue Spin Attack
        if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[1] -Not)   { ChangeBytes -Offset "10B0A14" -Values @($Redux.Colors.SetSpinAttack[1].Color.R, $Redux.Colors.SetSpinAttack[1].Color.G, $Redux.Colors.SetSpinAttack[1].Color.B) } # Blue Spin Attack
        if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[2] -Not)   { ChangeBytes -Offset "10B0E74" -Values @($Redux.Colors.SetSpinAttack[2].Color.R, $Redux.Colors.SetSpinAttack[2].Color.G, $Redux.Colors.SetSpinAttack[2].Color.B) } # Red Spin Attack
        if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[3] -Not)   { ChangeBytes -Offset "10B0F94" -Values @($Redux.Colors.SetSpinAttack[3].Color.R, $Redux.Colors.SetSpinAttack[3].Color.G, $Redux.Colors.SetSpinAttack[3].Color.B) } # Red Spin Attack
    }



    # FAIRY COLORS #

    if (IsSet $Redux.Colors.SetFairy) {
        if ( (IsDefaultColor -Elem $Redux.Colors.SetFairy[0] -Not) -or (IsDefaultColor -Elem $Redux.Colors.SetFairy[1] -Not) ) { # Idle
            ChangeBytes -Offset "C451D4" -Values @($Redux.Colors.SetFairy[0].Color.R, $Redux.Colors.SetFairy[0].Color.G, $Redux.Colors.SetFairy[0].Color.B, 255, $Redux.Colors.SetFairy[1].Color.R, $Redux.Colors.SetFairy[1].Color.G, $Redux.Colors.SetFairy[1].Color.B, 0)
        }
        if ( (IsDefaultColor -Elem $Redux.Colors.SetFairy[2] -Not) -or (IsDefaultColor -Elem $Redux.Colors.SetFairy[3] -Not) ) { # Interact
            ChangeBytes -Offset "C451F4" -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "C451FC" -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
        }
        if ( (IsDefaultColor -Elem $Redux.Colors.SetFairy[4] -Not) -or (IsDefaultColor -Elem $Redux.Colors.SetFairy[5] -Not) ) { # NPC
            ChangeBytes -Offset "C451E4" -Values @($Redux.Colors.SetFairy[4].Color.R, $Redux.Colors.SetFairy[4].Color.G, $Redux.Colors.SetFairy[4].Color.B, 255, $Redux.Colors.SetFairy[5].Color.R, $Redux.Colors.SetFairy[5].Color.G, $Redux.Colors.SetFairy[5].Color.B, 0)
        }
        if ( (IsDefaultColor -Elem $Redux.Colors.SetFairy[6] -Not) -or (IsDefaultColor -Elem $Redux.Colors.SetFairy[7] -Not) ) { # Enemy, Boss
            ChangeBytes -Offset "C451EC" -Values @($Redux.Colors.SetFairy[6].Color.R, $Redux.Colors.SetFairy[6].Color.G, $Redux.Colors.SetFairy[6].Color.B, 255, $Redux.Colors.SetFairy[7].Color.R, $Redux.Colors.SetFairy[7].Color.G, $Redux.Colors.SetFairy[7].Color.B, 0)
            ChangeBytes -Offset "C4520C" -Values @($Redux.Colors.SetFairy[6].Color.R, $Redux.Colors.SetFairy[6].Color.G, $Redux.Colors.SetFairy[6].Color.B, 255, $Redux.Colors.SetFairy[7].Color.R, $Redux.Colors.SetFairy[7].Color.G, $Redux.Colors.SetFairy[7].Color.B, 0)
        }
    }



    # AMMO CAPACITY SELECTION #

    if (IsChecked $Redux.Capacity.EnableAmmo) {
        ChangeBytes -Offset "C5834F" -Values @($Redux.Capacity.Quiver1.Text,     $Redux.Capacity.Quiver2.Text,     $Redux.Capacity.Quiver3.Text)     -Interval 2
        ChangeBytes -Offset "C58357" -Values @($Redux.Capacity.BombBag1.Text,    $Redux.Capacity.BombBag2.Text,    $Redux.Capacity.BombBag3.Text)    -Interval 2
        ChangeBytes -Offset "C5837F" -Values @($Redux.Capacity.DekuSticks1.Text, $Redux.Capacity.DekuSticks1.Text, $Redux.Capacity.DekuSticks1.Text) -Interval 2
        ChangeBytes -Offset "C58387" -Values @($Redux.Capacity.DekuNuts1.Text,   $Redux.Capacity.DekuNuts1.Text,   $Redux.Capacity.DekuNuts1.Text)   -Interval 2
    }



    # WALLET CAPACITY SELECTION #

    if (IsChecked $Redux.Capacity.EnableWallet) {
        $Wallet1 = Get16Bit ($Redux.Capacity.Wallet1.Text); $Wallet2 = Get16Bit ($Redux.Capacity.Wallet2.Text); $Wallet3 = Get16Bit ($Redux.Capacity.Wallet3.Text); $Wallet4 = Get16Bit ($Redux.Capacity.Wallet4.Text)
        ChangeBytes -Offset "C5836C" -Values @($Wallet1.Substring(0, 2), $Wallet1.Substring(2) )
        ChangeBytes -Offset "C5836E" -Values @($Wallet2.Substring(0, 2), $Wallet2.Substring(2) )
        ChangeBytes -Offset "C58370" -Values @($Wallet3.Substring(0, 2), $Wallet3.Substring(2) )
        ChangeBytes -Offset "C58372" -Values @($Wallet4.Substring(0, 2), $Wallet4.Substring(2) )

        ChangeBytes -Offset "C5625D" -Values @( (3 - $Redux.Capacity.Wallet1.Text.Length), (3 - $Redux.Capacity.Wallet2.Text.Length), (3 - $Redux.Capacity.Wallet3.Text.Length), (3 - $Redux.Capacity.Wallet4.Text.Length) ) -Interval 2
        ChangeBytes -Offset "C56265" -Values @($Redux.Capacity.Wallet1.Text.Length, $Redux.Capacity.Wallet2.Text.Length, $Redux.Capacity.Wallet3.Text.Length, $Redux.Capacity.Wallet4.Text.Length) -Interval 2
    }



    # EQUIPMENT #

    if (IsChecked $Redux.Gameplay.RazorSword) {
        ChangeBytes -Offset "CBA496" -Values "00 00" # Prevent losing hits
        ChangeBytes -Offset "BDA6B7" -Values "01"    # Keep sword after Song of Time
    }

    if (IsChecked $Redux.Gameplay.UnsheathSword)       { ChangeBytes -Offset "CC2CE8"  -Values "28 42 00 05 14 40 00 05 00 00 10 25" }
    if (IsChecked $Redux.Gameplay.SwordBeamAttack)     { ChangeBytes -Offset "CD73F0"  -Values "00 00"; ChangeBytes -Offset "CD73F4" -Values "00 00" }
    if (IsChecked $Redux.Gameplay.FixEponaSword)       { ChangeBytes -Offset "BA885C"  -Values "24 18"; ChangeBytes -Offset "BA885F"  -Values "01" }



    # HITBOX #

    if (IsValue -Elem $Redux.Equipment.KokiriSword      -Not)   { ChangeBytes -Offset "C572BC" -Values (ConvertFloatToHex $Redux.Equipment.KokiriSword.Value) }
    if (IsValue -Elem $Redux.Equipment.RazorSword       -Not)   { ChangeBytes -Offset "C572C0" -Values (ConvertFloatToHex $Redux.Equipment.RazorSword.Value) }
    if (IsValue -Elem $Redux.Equipment.GildedSword      -Not)   { ChangeBytes -Offset "C572C4" -Values (ConvertFloatToHex $Redux.Equipment.GildedSword.Value) }
    if (IsValue -Elem $Redux.Equipment.GreatFairysSword -Not)   { ChangeBytes -Offset "C572C8" -Values (ConvertFloatToHex $Redux.Equipment.GreatFairysSword.Value) }
    if (IsValue -Elem $Redux.Equipment.BlastMask        -Not)   { $blast = (Get16Bit $Redux.Equipment.BlastMask.Value); ChangeBytes -Offset "CAA666" -Values @($blast.Substring(0, 2), $blast.Substring(2)) }
    if (IsValue -Elem $Redux.Equipment.ShieldRecoil     -Not)   { ChangeBytes -Offset "CAEDC6" -Values ((Get16Bit ($Redux.Equipment.ShieldRecoil.Value + 45000)) -split '(..)' -ne '') }



    # SKIP #

    if (IsChecked $Redux.Skip.BossCutscenes) {
        ChangeBytes -Offset "E425EC" -Values "00 00 00 00"                                                                                                                            # Odolwa
        ChangeBytes -Offset "F6A90C" -Values "00 00 00 00"                                                                                                                            # Goht
        ChangeBytes -Offset "E50DF0" -Values "00 00 00 00"                                                                                                                            # Gyorg
        ChangeBytes -Offset "E4A478" -Values "10 00"                                                                                                                                  # Twinmold
        ChangeBytes -Offset "E60288" -Values "00 00 00 00"; ChangeBytes -Offset "E60564"  -Values "00 00 00 00"                                                                       # Majora
        ChangeBytes -Offset "E575A8" -Values "00 00 00 00"; ChangeBytes -Offset "101B9FC" -Values "00 00 00 00"                                                                       # Wart
        ChangeBytes -Offset "E25924" -Values "8D 08 33 1C"; ChangeBytes -Offset "E25930"  -Values "00 00 00 00 15 00"; ChangeBytes -Offset "E5D4C8" -Values "00 00 00 00 00 00 00 00" # Igos Du Ikana
        ChangeBytes -Offset "D3F2BC" -Values "10 00";       ChangeBytes -Offset "D3F3F4"  -Values "00 00 00 00";       ChangeBytes -Offset "D4438C" -Values "00 00 00 00"             # Gomess

    }

    if (IsChecked $Redux.Skip.TatlInterrupts) {
        ChangeBytes -Offset "DA1158" -Values "00 00 00 00"; ChangeBytes -Offset "E96988" -Values "00 00 00 00"
        ChangeBytes -Offset "F6279C" -Values "00 00 00 00"; ChangeBytes -Offset "F62DAC" -Values "00 00 00 00"
    }



    # SPEEDUP #

    if (IsChecked $Redux.Speedup.LabFish) {
        ChangeBytes -Offset "F8D904" -Values "00 00"; ChangeBytes -Offset "F8D907" -Values "00";    ChangeBytes -Offset "F8D91C" -Values "00 00";          ChangeBytes -Offset "F8D91F" -Values "00 00 00"
        ChangeBytes -Offset "F8D923" -Values "00";    ChangeBytes -Offset "F8D934" -Values "00";    ChangeBytes -Offset "F8D937" -Values "00 00 00 00 00"; ChangeBytes -Offset "F8D958" -Values "00 00"
        ChangeBytes -Offset "F8D95B" -Values "00";    ChangeBytes -Offset "F8D96C" -Values "00 00"; ChangeBytes -Offset "F8D96F" -Values "00 00 00";       ChangeBytes -Offset "F8D973" -Values "00"
        ChangeBytes -Offset "F8D984" -Values "00 00"; ChangeBytes -Offset "F8D987" -Values "00 00 00 00 00"
    }

    if (IsChecked $Redux.Speedup.Dampe) {
        ChangeBytes -Offset "FC86CC" -Values "00 00 00 00 00 00 00 00 00"; ChangeBytes -Offset "FC86D6" -Values "00 00 00 00 00"
        ChangeBytes -Offset "FC86DC" -Values "24 08";                      ChangeBytes -Offset "FC86DF" -Values "08"
    }

    if (IsChecked $Redux.Speedup.DogRace) {
        ChangeBytes -Offset "0E34608" -Values "3C 18 80 1F 83 18 F7 08 07"; ChangeBytes -Offset "0E34613" -Values "04 24 18";             ChangeBytes -Offset "0E34617" -Values "09 24 07 00 0D 53 05"; ChangeBytes -Offset "0E3461F" -Values "01 24 07"
        ChangeBytes -Offset "0E34624" -Values "30 B8";                      ChangeBytes -Offset "0E34627" -Values "01 13 00 00 0D 00 00"; ChangeBytes -Offset "0E3462F" -Values "00";                   ChangeBytes -Offset "0E34631" -Values "05"
    }

    if (IsText -Elem $Redux.Speedup.Bank1 -Compare $Redux.Speedup.Bank1.default -Not) {
        $Bank1 = Get16Bit ($Redux.Speedup.Bank1.Text)
        ChangeBytes -Offset "ECCA56" -Values @($Bank1.Substring(0, 2), $Bank1.Substring(2) ); ChangeBytes -Offset "ECCA66" -Values @($Bank1.Substring(0, 2), $Bank1.Substring(2) )
    }

    if (IsText -Elem $Redux.Speedup.Bank2 -Compare $Redux.Speedup.Bank2.default -Not) {
        $Bank2 = Get16Bit ($Redux.Speedup.Bank2.Text)
        ChangeBytes -Offset "ECCA5E" -Values @($Bank2.Substring(0, 2), $Bank2.Substring(2) ); ChangeBytes -Offset "ECCA6E" -Values @($Bank2.Substring(0, 2), $Bank2.Substring(2) )
        ChangeBytes -Offset "ECCAA2" -Values @($Bank2.Substring(0, 2), $Bank2.Substring(2) ); ChangeBytes -Offset "ECCAB2" -Values @($Bank2.Substring(0, 2), $Bank2.Substring(2) )
    }

    if (IsText -Elem $Redux.Speedup.Bank3 -Compare $Redux.Speedup.Bank3.default -Not) {
        $Bank3 = Get16Bit ($Redux.Speedup.Bank3.Text)
        ChangeBytes -Offset "ECCAAA" -Values @($Bank3.Substring(0, 2), $Bank3.Substring(2) ); ChangeBytes -Offset "ECCABA" -Values @($Bank3.Substring(0, 2), $Bank3.Substring(2) )
        ChangeBytes -Offset "ECCAEE" -Values @($Bank3.Substring(0, 2), $Bank3.Substring(2) ); ChangeBytes -Offset "ECCD2A" -Values @($Bank3.Substring(0, 2), $Bank3.Substring(2) )
    }



    # SCRIPT

    if (IsIndex $Redux.Text.TatlCUp -Not) {
        if     ($Redux.Text.TatlCUp.text -eq "Override" -and $LanguagePatch.tatl -eq "Tatl")   { $tatl = "Taya"                   }
        elseif ($Redux.Text.TatlCUp.text -eq "Override" -and $LanguagePatch.tatl -ne "Tatl")   { $tatl = "Tatl"                   }
        else                                                                                   { $tatl = $Redux.Text.TatlCUp.text }
        PatchBytes -Offset "1EBFAE0" -Texture -Patch ("Tatl\" + $tatl + ".cup")
    }

    if (IsChecked $Redux.Text.Comma) { ChangeBytes -Offset "ACC660"  -Values "00 F3 00 00 00 00 00 00 4F 60 00 00 00 00 00 00 24" }

}



#==============================================================================================================================================================================================
function ByteReduxOptions() {
    
    # D-PAD #

    $offset = SearchBytes -Start "3800000" -End "380F000" -Values "44 50 41 44 00 00 00 00"

    if (IsIndex -Elem $Redux.DPad.Up.SelectedIndex -Text "Deku Mask" -Not) {
        GetMMItemID -Item $Redux.DPad.Up.Text
        $offset2 = AddToOffset -Hex $offset -Add "8"
        ChangeBytes -Offset $Offset -Values $Array
    }

    if (IsIndex -Elem $Redux.DPad.Right.SelectedIndex -Text "Zora Mask" -Not) {
        GetMMItemID -Item $Redux.DPad.Right.Text
        $offset2 = AddToOffset -Hex $offset -Add "9"
        ChangeBytes -Offset $Offset -Values $Array
    }

    if (IsIndex -Elem $Redux.DPad.Down.SelectedIndex -Text "Ocarina of Time" -Not) {
        GetMMItemID -Item $Redux.DPad.Down.Text
        $offset2 = AddToOffset -Hex $offset -Add "A"
        ChangeBytes -Offset $Offset -Values $Array
    }

    if (IsIndex -Elem $Redux.DPad.Left.SelectedIndex -Text "Goron Mask" -Not) {
        GetMMItemID -Item $Redux.DPad.Left.Text
        $offset2 = AddToOffset -Hex $offset -Add "B"
        ChangeBytes -Offset $offset2 -Values $Array
    }

    if ( (IsChecked $Redux.DPad.Disable) -or (IsChecked $Redux.DPad.Hide) -or (IsChecked $Redux.DPad.LayoutRight) ) {
        $offset2 = AddToOffset -Hex $offset -Add "18"
        if (IsChecked $Redux.DPad.Disable)           { ChangeBytes -Offset $offset2 -Values "00 00" }
        elseif (IsChecked $Redux.DPad.Hide)          { ChangeBytes -Offset $offset2 -Values "01 00" }
        elseif (IsChecked $Redux.DPad.LayoutRight)   { ChangeBytes -Offset $offset2 -Values "01 02" }
        
    }



    # GAMEPLAY #

    if ( (IsChecked $Redux.Gameplay.FasterBlockPushing) -or (IsChecked $Redux.Gameplay.ElegySpeedup) -or (IsChecked $Redux.Gameplay.FierceDeity) ) {
        $Offset = SearchBytes -Start "3800000" -End "380F000" -Values "4D 49 53 43"
        $Offset = AddToOffset -Hex $offset -Add "8"
    }

    if (IsChecked $Redux.Gameplay.NewRedux) {
        if ( (IsChecked $Redux.Gameplay.FasterBlockPushing)      -or (IsChecked $Redux.Gameplay.ElegySpeedup -Not) -or (IsChecked $Redux.Gameplay.FierceDeity -Not) )   { ChangeBytes -Offset $Offset -Values "60 51 9B D1 13 52 85 41 46 21 F2 4C 5B 84 F6 FB 18 31" }
        if ( (IsChecked $Redux.Gameplay.FasterBlockPushing -Not) -or (IsChecked $Redux.Gameplay.ElegySpeedup)      -or (IsChecked $Redux.Gameplay.FierceDeity -Not) )   { ChangeBytes -Offset $Offset -Values "E7 B0 BC 19 D9 F2 F8 E1 BE 72 B8 84 76 81 3D 4D 08 39" }
        if ( (IsChecked $Redux.Gameplay.FasterBlockPushing -Not) -or (IsChecked $Redux.Gameplay.ElegySpeedup -Not) -or (IsChecked $Redux.Gameplay.FierceDeity) )        { ChangeBytes -Offset $Offset -Values "33 01 DF 74 A3 82 2C 25 44 BA 18 2D 42 F9 EA 98 08 31" }
        if ( (IsChecked $Redux.Gameplay.FasterBlockPushing)      -or (IsChecked $Redux.Gameplay.ElegySpeedup)      -or (IsChecked $Redux.Gameplay.FierceDeity -Not) )   { ChangeBytes -Offset $Offset -Values "CD 99 74 F8 83 8F DE FF 6C C0 31 8F 0B 66 44 E8 18 39" }
        if ( (IsChecked $Redux.Gameplay.FasterBlockPushing)      -or (IsChecked $Redux.Gameplay.ElegySpeedup -Not) -or (IsChecked $Redux.Gameplay.FierceDeity) )        { ChangeBytes -Offset $Offset -Values "96 43 6E A8 EB 1C 9A 13 E8 C2 75 C7 BD 51 F0 22 18 31" }
        if ( (IsChecked $Redux.Gameplay.FasterBlockPushing)      -or (IsChecked $Redux.Gameplay.ElegySpeedup)      -or (IsChecked $Redux.Gameplay.FierceDeity) )        { ChangeBytes -Offset $Offset -Values "44 BE 70 0E DA 58 AC E9 64 C1 E6 2C 06 96 81 6A 18 39" }
        if ( (IsChecked $Redux.Gameplay.FasterBlockPushing -Not) -or (IsChecked $Redux.Gameplay.ElegySpeedup)      -or (IsChecked $Redux.Gameplay.FierceDeity) )        { ChangeBytes -Offset $Offset -Values "CE B5 4B C3 1D 42 85 33 FB 47 A4 70 6A 2F F0 1F 08 39" }
        if ( (IsChecked $Redux.Gameplay.FasterBlockPushing)      -or (IsChecked $Redux.Gameplay.ElegySpeedup)      -or (IsChecked $Redux.Gameplay.FierceDeity) )        { ChangeBytes -Offset $Offset -Values "44 BE 70 0E DA 58 AC E9 64 C1 E6 2C 06 96 81 6A 18 39" }
    }
    else {
        if (IsChecked $Redux.Gameplay.FasterBlockPushing) { ChangeBytes -Offset $Offset -Values "9E 45 06 2D 57 4B 28 62 49 87 69 FB 0F 79 1B 9F 18 30" }
    }


    # BUTTON COLORS #

     if (IsDefaultColor -Elem $Redux.Colors.SetButtons[0] -Not) { # A Button
        $offset = SearchBytes -Start "3800000" -End "380F000" -Values "48 55 44 43" # Old Redux: 3806470
        $offset = AddToOffset -Hex $Offset -Add "8"

        ChangeBytes -Offset (AddToOffset $offset -Add "00") -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) # Button
        ChangeBytes -Offset (AddToOffset $offset -Add "80") -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) # Text Icons
        ChangeBytes -Offset (AddToOffset $offset -Add "50") -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)
        ChangeBytes -Offset (AddToOffset $offset -Add "7C") -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)
        ChangeBytes -Offset (AddToOffset $offset -Add "88") -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)
        ChangeBytes -Offset (AddToOffset $offset -Add "9C") -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)
        ChangeBytes -Offset (AddToOffset $offset -Add "A4") -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)
        ChangeBytes -Offset (AddToOffset $offset -Add "A8") -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)
        ChangeBytes -Offset (AddToOffset $offset -Add "AC") -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)
        if ($Redux.Colors.Buttons.Text -eq "Randomized" -or $Redux.Colors.Buttons.Text -eq "Custom") {
            ChangeBytes -Offset (AddToOffset $offset -Add "5C") -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) # Pause Outer Selection
            ChangeBytes -Offset (AddToOffset $offset -Add "60") -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) # Pause Outer Glow Selection
          # ChangeBytes -Offset (AddToOffset $offset -Add "64") -Values @(($Redux.Colors.SetButtons[0].Color.R+20), ($Redux.Colors.SetButtons[0].Color.G+20), ($Redux.Colors.SetButtons[0].Color.B+20)) # Pause Outer Glow Selection
          # ChangeBytes -Offset (AddToOffset $offset -Add "68") -Values @(($Redux.Colors.SetButtons[0].Color.R-50), ($Redux.Colors.SetButtons[0].Color.G-50), ($Redux.Colors.SetButtons[0].Color.B-50)) # Pause Glow Selection
        }
    }

    if ( IsDefaultColor -Elem $Redux.Colors.SetButtons[1] -Not) { # B Button
        ChangeBytes -Offset (AddToOffset $offset -Add "04") -Values @($Redux.Colors.SetButtons[1].Color.R, $Redux.Colors.SetButtons[1].Color.G, $Redux.Colors.SetButtons[1].Color.B) # Button
        ChangeBytes -Offset (AddToOffset $offset -Add "54") -Values @($Redux.Colors.SetButtons[1].Color.R, $Redux.Colors.SetButtons[1].Color.G, $Redux.Colors.SetButtons[1].Color.B) # Text Icons
    }

    if (IsDefaultColor -Elem $Redux.Colors.SetButtons[2] -Not) { # C Buttons
        ChangeBytes -Offset (AddToOffset $offset -Add "08") -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # Buttons
        if ($Redux.Colors.Buttons.Text -eq "Randomized" -or $Redux.Colors.Buttons.Text -eq "Custom") {
            ChangeBytes -Offset (AddToOffset $offset -Add "58") -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # Text Icons
            ChangeBytes -Offset (AddToOffset $offset -Add "A0") -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # to Equip
            ChangeBytes -Offset (AddToOffset $offset -Add "8C") -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # Note
            ChangeBytes -Offset (AddToOffset $offset -Add "6C") -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # Pause Outer Selection
            ChangeBytes -Offset (AddToOffset $offset -Add "70") -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # Pause Selection
          # ChangeBytes -Offset (AddToOffset $offset -Add "78") -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # Pause Outer Glow Selection
          # ChangeBytes -Offset (AddToOffset $offset -Add "90") -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # Pause Outer Selection
        }
    }

    if (IsDefaultColor -Elem $Redux.Colors.SetButtons[3] -Not) { # Start Button
        ChangeBytes -Offset (AddToOffset $offset -Add "0C") -Values @($Redux.Colors.SetButtons[3].Color.R, $Redux.Colors.SetButtons[3].Color.G, $Redux.Colors.SetButtons[3].Color.B) # Button
    }



    # HUD COLORS #

    if (IsSet $Redux.Colors.SetHUDStats) {
        if (IsDefaultColor -Elem $Redux.Colors.SetHUDStats[0] -Not)   { ChangeBytes -Offset (AddToOffset $offset -Add "28") -Values @($Redux.Colors.SetHUDStats[0].Color.R, $Redux.Colors.SetHUDStats[0].Color.G, $Redux.Colors.SetHUDStats[0].Color.B) } # Hearts
        if (IsDefaultColor -Elem $Redux.Colors.SetHUDStats[1] -Not)   { ChangeBytes -Offset (AddToOffset $offset -Add "2C") -Values @($Redux.Colors.SetHUDStats[1].Color.R, $Redux.Colors.SetHUDStats[1].Color.G, $Redux.Colors.SetHUDStats[1].Color.B) } # Hearts
        if (IsDefaultColor -Elem $Redux.Colors.SetHUDStats[2] -Not)   { ChangeBytes -Offset (AddToOffset $offset -Add "30") -Values @($Redux.Colors.SetHUDStats[2].Color.R, $Redux.Colors.SetHUDStats[2].Color.G, $Redux.Colors.SetHUDStats[2].Color.B) } # Magic
        if (IsDefaultColor -Elem $Redux.Colors.SetHUDStats[3] -Not)   { ChangeBytes -Offset (AddToOffset $Offset -Add "34") -Values @($Redux.Colors.SetHUDStats[3].Color.R, $Redux.Colors.SetHUDStats[3].Color.G, $Redux.Colors.SetHUDStats[3].Color.B) } # Magic
        if (IsDefaultColor -Elem $Redux.Colors.SetHUDStats[4] -Not)   { ChangeBytes -Offset (AddToOffset $offset -Add "38") -Values @($Redux.Colors.SetHUDStats[4].Color.R, $Redux.Colors.SetHUDStats[4].Color.G, $Redux.Colors.SetHUDStats[4].Color.B) } # Minimap
    }

}



#==============================================================================================================================================================================================
function CheckLanguageOptions() {
    
    if     ( (IsChecked  $Redux.Text.Vanilla -Not)   -or (IsLanguage $Redux.Text.AdultPronouns) -or (IsChecked $Redux.UI.GCScheme) )                                                          { return $True }
    elseif ( (IsLanguage $Redux.Gameplay.RazorSword) -or (IsIndex $Redux.Text.TatlScript -Not)  -or (IsLanguage $Redux.Capacity.EnableAmmo) -or (IsLanguage $Redux.Capacity.EnableWallet) )   { return $True }

}



#==============================================================================================================================================================================================
function WholeLanguageOptions() {
    
    $script = $GameFiles.extracted + "\message_data_static.bin"
    $table  = $GameFiles.extracted + "\message_data.tbl"

    if (IsChecked $Redux.Text.Restore) {
        ApplyPatch  -File $script -Patch "\Export\Message\restore_static.bps"
        ApplyPatch -File $table   -Patch "\Export\Message\restore_table.bps"
        PatchBytes  -Offset "A2DDC4" -Length "26F" -Texture -Patch "Icons\troupe_leaders_mask_text.yaz0" # Correct Circus Mask
    }
    elseif (IsChecked $Redux.Text.MasterQuest) {
        ApplyPatch -File $script -Patch "\Export\Message\master_quest_static.bps"
        ApplyPatch -File $table  -Patch "\Export\Message\master_quest_table.bps"
    }
    elseif (IsChecked $Redux.Text.Custom) {
        if ( (TestFile ($Gamefiles.customText + "\message_data_static.bin") ) -and (TestFile ($Gamefiles.customText + "\message_data.tbl") ) ) {
            Copy-Item -LiteralPath ($Gamefiles.customText + "\message_data_static.bin") -Destination ($GameFiles.extracted + "\message_data_static.bin") -Force
            Copy-Item -LiteralPath ($Gamefiles.customText + "\message_data.tbl")        -Destination ($GameFiles.extracted + "\message_data.tbl")        -Force
        }
        else { WriteToConsole "Custom Text could not be found." }
    }

}



#==============================================================================================================================================================================================
function ByteLanguageOptions() {
    
    if (IsChecked $Redux.Text.OcarinaIcons) {
        PatchBytes -Offset "A3B9BC" -Length "850" -Texture -Pad -Patch "Icons\deku_pipes_icon.yaz0"  # Slingshot, ID: 0x0B
        PatchBytes -Offset "A28AF4" -Length "1AF" -Texture -Pad -Patch "Icons\deku_pipes_text.yaz0"
        PatchBytes -Offset "A44BFC" -Length "A69" -Texture -Pad -Patch "Icons\goron_drums_icon.yaz0" # Blue Fire, ID: 0x1C
        PatchBytes -Offset "A28204" -Length "26F" -Texture -Pad -Patch "Icons\goron_drums_text.yaz0"
        PatchBytes -Offset "A4AAFC" -Length "999" -Texture -Pad -Patch "Icons\zora_guitar_icon.yaz0" # Hylian Loach, ID: 0x26
        PatchBytes -Offset "A2B2B4" -Length "230" -Texture -Pad -Patch "Icons\zora_guitar_text.yaz0"

        ChangeBytes -Offset "A36D80" -Values "00 00 4A B0"                                                     # Pointer Deku Pipes icon
        ChangeBytes -Offset "A27674" -Values "00 00 2B A0"; ChangeBytes -Offset "A276D0" -Values "00 00 09 C0" # Pointer Goron Drums Text
    }

    if (IsChecked $Redux.UI.GCScheme) {
        SetMessage -ID "0227" -Text "5A20" -Replace "4C20"; SetMessage -ID "1912" -Text "5A20" -Replace "4C20"; SetMessage -ID "191D" -Text "5A20" -Replace "4C20"; SetMessage -ID "1946" -Text "5A20" -Replace "4C20"; SetMessage -ID "1954" -Text "5A20" -Replace "4C20"
    }

    if (IsLanguage -Elem $Redux.Gameplay.RazorSword) {
        SetMessage -ID "0038" -Text "This new, sharper blade is a cut<N>above the rest. Use it up to<N><R>100 times <W>without dulling its<N>superior edge!"                            -Replace "This new, sharper blade is a cut<N>above the rest. Use it as much<N>as you want without dulling it's<N>superior edge!"
        SetMessage -ID "0C3B" -Text "Keep in mind that after you use<N>your reforged sword <R>100 times<W>, it<N>will lose its edge and it'll be back<N>to its original sharpness..."   -Replace "This reforged blade will be unbreakable.<N>Ohh... Don't look at me like that.<N>Surely I would not dare conning you<N>with a flimsy weapon."
        SetMessage -ID "0C51" -Text "Now keep in mind that after<N>you've used this <R>100 times<W>, the<N>blade will lose its edge and will<N>return to its <R>original sharpness<W>." -Replace "You do not need to worry for it, as<N>this blade is unbreakable. What!?<N>You do not believe me? Go see it<N>for yourself then in action."
        SetMessage -ID "1785" -Text "Use it up to <R>100 times<W>."                                                                                                                     -Replace "Use it as much you want."
    }

    if (IsLanguage -Elem $Redux.Text.AdultPronouns) {
        SetMessage -ID "04B0" -Text "6368696C64" -Replace "796F756E67206D616E"; SetMessage -ID "04B2" -Text "6368696C64" -Replace "796F756E67206D616E"; SetMessage -ID "04B5" -Text "6368696C64" -Replace "796F756E67206D616E"

        SetMessage -ID "0514" -Text "6368696C64" -Replace "<N>defenseless Deku Scrub"; SetMessage -ID "0514" -Text "without an adult or<N>until you are old enough to carry" -Replace "until you are<N>capeable of carrying" # Guard guarding Clock Town exit (Deku Scrub)
        SetMessage -ID "0515" -Text "6368696C64" -Replace "defenseless<N>Deku Scrub";  SetMessage -ID "0515" -Text "without an adult or<N>until you are old enough to carry" -Replace "until you are<N>capeable of carrying"

        SetMessage -ID "0516" -Text "6368696C64" -Replace "7465656E"; SetMessage -ID "0517" -Text "6368696C64" -Replace "7465656E"; SetMessage -ID "0518" -Text "6368696C64" -Replace "7465656E"; SetMessage -ID "0519" -Text "6368696C64" -Replace "7465656E"; SetMessage -ID "0521" -Text "6368696C64" -Replace "7465656E"; SetMessage -ID "0523" -Text "6368696C64" -Replace "7465656E" # Guard guarding Clock Town exit
        SetMessage -ID "052B" -Text "6368696C64" -Replace "7465656E"; SetMessage -ID "052D" -Text "6368696C64" -Replace "7465656E"; SetMessage -ID "0535" -Text "6368696C64" -Replace "7465656E"; SetMessage -ID "0537" -Text "6368696C64" -Replace "7465656E"; SetMessage -ID "055E" -Text "6368696C64" -Replace "7465656E"; SetMessage -ID "055F" -Text "6368696C64" -Replace "7465656E"
        
        SetMessage -ID "0560" -Text "6368696C64" -Replace "<N>defenseless Deku Scrub"; SetMessage -ID "0560" -Text "Until you are old enough to carry<N>a <R>weapon<W>, you cannot pass<N>through here without being<N>accompanied by an adult" -Replace "Until you are capeable of carrying<N>a <R>weapon<W>, you cannot pass<N>through here without being<N>so defenseless" # Guard guarding Clock Town exit (Deku Scrub)
        SetMessage -ID "0561" -Text "6368696C64" -Replace "<N>defenseless Deku Scrub"; SetMessage -ID "0561" -Text "Until you are old enough to carry<N>a <R>weapon<W>, you cannot pass<N>through here without being<N>accompanied by an adult" -Replace "Until you are capeable of carrying<N>a <R>weapon<W>, you cannot pass<N>through here without being<N>so defenseless"
        SetMessage -ID "0562" -Text "6368696C64" -Replace "<N>defenseless Deku Scrub"; SetMessage -ID "0562" -Text "Until you are old enough to carry<N>a <R>weapon<W>, you cannot pass<N>through here without being<N>accompanied by an adult" -Replace "Until you are capeable of carrying<N>a <R>weapon<W>, you cannot pass<N>through here without being<N>so defenseless"
        SetMessage -ID "0563" -Text "6368696C64" -Replace "<N>defenseless Deku Scrub"; SetMessage -ID "0563" -Text "Until you are old enough to carry<N>a <R>weapon<W>, you cannot pass<N>through here without being<N>accompanied by an adult" -Replace "Until you are capeable of carrying<N>a <R>weapon<W>, you cannot pass<N>through here without being<N>so defenseless"
        SetMessage -ID "0564" -Text "6368696C64" -Replace "<N>defenseless Deku Scrub"; SetMessage -ID "0564" -Text "Until you are old enough to carry<N>a <R>weapon<W>, you cannot pass<N>through here without being<N>accompanied by an adult" -Replace "Until you are capeable of carrying<N>a <R>weapon<W>, you cannot pass<N>through here without being<N>so defenseless"
        SetMessage -ID "0565" -Text "6368696C64" -Replace "defenseless<N>Deku Scrub";  SetMessage -ID "0565" -Text "Until you are old enough to carry<N>a <R>weapon<W>, you cannot pass<N>through here without being<N>accompanied by an adult" -Replace "Until you are capeable of carrying<N>a <R>weapon<W>, you cannot pass<N>through here without being<N>so defenseless"

        SetMessage -ID "0566" -Text "6368696C64" -Replace "7465656E"; SetMessage -ID "0567" -Text "6368696C64" -Replace "7465656E"; SetMessage -ID "0568" -Text "6368696C64" -Replace "7465656E"; SetMessage -ID "0569" -Text "6368696C64" -Replace "7465656E"; SetMessage -ID "056A" -Text "6368696C64" -Replace "7465656E"; SetMessage -ID "056B" -Text "6368696C64" -Replace "7465656E" # Guard guarding Clock Town exit
        SetMessage -ID "056C" -Text "6368696C64" -Replace "7465656E"; SetMessage -ID "056D" -Text "6368696C64" -Replace "7465656E"; SetMessage -ID "056E" -Text "6368696C64" -Replace "7465656E"; SetMessage -ID "056F" -Text "6368696C64" -Replace "7465656E"; SetMessage -ID "0570" -Text "6368696C64" -Replace "7465656E"; SetMessage -ID "0571" -Text "6368696C64" -Replace "7465656E"
        SetMessage -ID "0572" -Text "6368696C64" -Replace "7465656E"; SetMessage -ID "0573" -Text "6368696C64" -Replace "7465656E" # Guard guarding Clock Town exit

        SetMessage -ID "05F5" -Text "6368696C64" -Replace "796F756E67206D616E"; SetMessage -ID "083C" -Text "6368696C64" -Replace "796F756E67206D616E"; SetMessage -ID "0BEA" -Text "fairy child" -Replace "young fairy man"; SetMessage -ID "0BEA" -Text "6368696C64" -Replace "796F756E67206D616E"; SetMessage -ID "0BF6" -Text "fairy child" -Replace "young fairy man"
        SetMessage -ID "33C3" -Text "6368696C64" -Replace "796F756E6773746572"
    }

    if (IsIndex -Elem $Redux.Text.TatlScript -Not) {
        if     ($Redux.Text.TatlScript.text -eq "Override" -and $LanguagePatch.tatl -eq "Tatl")   { $replace = "Taya"                      }
        elseif ($Redux.Text.TatlScript.text -eq "Override" -and $LanguagePatch.tatl -ne "Tatl")   { $replace = "Tatl"                      }
        else                                                                                      { $replace = $Redux.Text.TatlScript.text }

        SetMessage -ID "057A" -Text $LanguagePatch.tatl -Replace $replace -NoParse
        SetMessage -ID "057C" -Text $LanguagePatch.tatl -Replace $replace -NoParse
        SetMessage -ID "057E" -Text $LanguagePatch.tatl -Replace $replace -NoParse
        SetMessage -ID "058E" -Text $LanguagePatch.tatl -Replace $replace -NoParse
        SetMessage -ID "0735" -Text $LanguagePatch.tatl -Replace $replace -NoParse
        SetMessage -ID "073E" -Text $LanguagePatch.tatl -Replace $replace -NoParse
        SetMessage -ID "073F" -Text $LanguagePatch.tatl -Replace $replace -NoParse
        SetMessage -ID "1F4E" -Text $LanguagePatch.tatl -Replace $replace -NoParse
    }

    if (IsLanguage $Redux.Capacity.EnableAmmo) {
        SetMessage -ID "0019" -ASCII -NoParse -Text "10" -Replace $Redux.Capacity.DekuSticks1.text
        SetMessage -ID "178A" -ASCII -NoParse -Text "30" -Replace $Redux.Capacity.Quiver1.text
        SetMessage -ID "178B" -ASCII -NoParse -Text "40" -Replace $Redux.Capacity.Quiver2.text;  SetMessage -ID "0023" -ASCII -NoParse -Text "40" -Replace $Redux.Capacity.Quiver2.text
        SetMessage -ID "178C" -ASCII -NoParse -Text "50" -Replace $Redux.Capacity.Quiver3.text;  SetMessage -ID "0024" -ASCII -NoParse -Text "50" -Replace $Redux.Capacity.Quiver3.text
        SetMessage -ID "178D" -ASCII -NoParse -Text "20" -Replace $Redux.Capacity.BombBag1.text
        SetMessage -ID "178E" -ASCII -NoParse -Text "30" -Replace $Redux.Capacity.BombBag2.text; SetMessage -ID "001C" -ASCII -NoParse -Text "30" -Replace $Redux.Capacity.BombBag2.text
        SetMessage -ID "178F" -ASCII -NoParse -Text "40" -Replace $Redux.Capacity.BombBag3.text; SetMessage -ID "001D" -ASCII -NoParse -Text "40" -Replace $Redux.Capacity.BombBag3.text
    }

    if (IsLanguage $Redux.Capacity.EnableWallet) {
        SetMessage -ID "0008" -ASCII -Text "200" -Replace $Redux.Capacity.Wallet2.text -NoParse
        SetMessage -ID "0009" -ASCII -Text "500" -Replace $Redux.Capacity.Wallet3.text -NoParse
    }

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    if (IsSimple)   { CreateOptionsDialog -Columns 6 -Height 540 -Tabs @("Main", "Graphics", "Audio", "Difficulty", "Equipment", "Speedup")           }
    else            { CreateOptionsDialog -Columns 6 -Height 605 -Tabs @("Main", "Graphics", "Audio", "Difficulty", "Colors", "Equipment", "Speedup") }

    if (IsSet $Redux.Graphics.Widescreen) { $Redux.Graphics.Widescreen.Add_CheckedChanged({ AdjustGUI }) }

}



#==============================================================================================================================================================================================
function AdjustGUI() {
    
    if (IsAdvanced) {
        EnableElem -Elem @($Redux.Colors.Magic, $Redux.Colors.BaseMagic, $Redux.Colors.InfiniteMagic) -Active (!( (IsChecked $Redux.Graphics.Widescreen) -and $Patches.Redux.Checked))
    }
    EnableElem -Elem @($Redux.DPad.LayoutLeft, $Redux.DPad.LayoutRight)                               -Active (!( (IsChecked $Redux.Graphics.Widescreen) -and $Patches.Redux.Checked))
    
    if ( (IsChecked $Redux.Graphics.Widescreen) -and $Patches.Redux.Checked)   { EnableElem -Elem @($Redux.DPad.Up, $Redux.DPad.Left, $Redux.DPad.Right, $Redux.DPad.Down) -Active $True }
    elseif ($Redux.Dpad.Disable.Checked)                                       { EnableElem -Elem @($Redux.DPad.Up, $Redux.DPad.Left, $Redux.DPad.Right, $Redux.DPad.Down) -Active $False }

    if ( (IsChecked $Redux.Graphics.Widescreen) -and $Patches.Redux.Checked -and ($Redux.DPad.LayoutLeft.Checked -or $Redux.DPad.LayoutRight.Checked) ) { $Redux.DPad.Hide.Checked = $True }

}




#==============================================================================================================================================================================================
function CreateTabMain() {
    
    # GAMEPLAY #

    CreateReduxGroup    -Tag  "Gameplay"          -Text "Gameplay"
    CreateReduxCheckBox -Name "ZoraPhysics"       -Text "Zora Physics"              -Info "Change the Zora physics when using the boomerang`nZora Link will take a step forward instead of staying on his spot"                                             -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "DistantZTargeting" -Text "Distant Z-Targeting"       -Info "Allow to use Z-Targeting on enemies, objects and NPC's from any distance"                                                                              -Advanced -Credits "Admentus"
    CreateReduxCheckBox -Name "ManualJump"        -Text "Manual Jump"               -Info "Press Z + A to do a Manual Jump instead of a Jump Attack`nPress B mid-air after jumping to do a Jump Attack"                                                     -Credits "Admentus"
    CreateReduxCheckBox -Name "FDSpinAttack"      -Text "Fierce Deity Spin Attack"  -Info "Allows Fierce Deity Link to perform a magic spin attack"                                                                                                         -Credits "Admentus"
    CreateReduxCheckBox -Name "FrontflipJump"     -Text "Force Frontflip Jump"      -Info "Link will always use the frontflip animation when jumping"                                                                                                       -Credits "SoulofDeity"
    CreateReduxCheckBox -Name "NoShieldRecoil"    -Text "No Shield Recoil"          -Info "Disable the recoil when being hit while shielding"                                                                                                               -Credits "Admentus"
    CreateReduxCheckBox -Name "FormItems"         -Text "Use Items With Mask Forms" -Info "Deku Link, Goron Link and Zora Link are able to use a few items such as Bombs and Deku Sticks"                                                                   -Credits "Firebreather"
    CreateReduxCheckBox -Name "SunSong"           -Text "Sun's Song"                -Info "Unlocks the Sun's Song when creating a new save file, which skips time to the next day or night"                                                                 -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "SariaSong"         -Text "Saria's Song"              -Info "Unlocks Saria's Song when creating a new save file, which plays the Final Hours music theme until the next area"                                                 -Credits "Ported from Rando"
    CreateReduxComboBox -Name "LinkJumpAttack"    -Text "Link Jump Attack"          -Info "Set the Jump Attack animation for Link in his Hylian Form" -Items @("Jumpslash", "Frontflip", "Beta Frontflip", "Beta Backflip", "Spin Slash", "Zora Jumpslash") -Credits "Admentus (ported), SoulofDeity & Aegiker"
    CreateReduxComboBox -Name "ZoraJumpAttack"    -Text "Zora Jump Attack"          -Info "Set the Jump Attack animation for Link in his Zora Form"   -Items @("Zora Jumpslash", "Beta Frontflip", "Beta Backflip", "Spin Slash")                           -Credits "Admentus (ported) & Aegiker"



    # RESTORE #

    CreateReduxGroup    -Tag  "Restore"           -Text "Restore / Correct"
    CreateReduxCheckBox -Name "RupeeColors"       -Text "Correct Rupee Colors"     -Info "Corrects the colors for the Purple (50) and Golden (200) Rupees"                                           -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "CowNoseRing"       -Text "Restore Cow Nose Ring"    -Info "Restore the rings in the noses for Cows as seen in the Japanese release"                                   -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "RomaniSign"        -Text "Correct Romani Sign"      -Info "Replace the Romani Sign texture to display Romani's Ranch instead of Kakariko Village"                     -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "Title"             -Text "Restore Title"            -Info "Restore the title logo colors as seen in the Japanese release"                                             -Credits "ShadowOne333 & Garo-Mastah"
    CreateReduxCheckBox -Name "SkullKid"          -Text "Restore Skull Kid"        -Info "Restore Skull Kid's face as seen in the Japanese release"                                                  -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "ShopMusic"         -Text "Restore Shop Music"       -Info "Restores the Shop music intro theme as heard in the Japanese release"                                      -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "IkanaCastle"       -Text "Restore Ikana Castle"     -Info "Restore a misplaced texture on the wall of Ancient Castle of Ikana in Ikana Canyon"                        -Credits "Linkz"
    CreateReduxCheckBox -Name "PieceOfHeartSound" -Text "4th Piece of Heart Sound" -Info "Restore the sound effect when collecting the fourth Piece of Heart that grants Link a new Heart Container" -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "MoveBomberKid"     -Text "Move Bomber Kid"          -Info "Moves the Bomber at the top of the Stock Pot Inn to be behind the bell like in the original Japanese ROM"  -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "OnTheMoonIntro"    -Text "On The Moon Intro"        -Info "Restores the intro cutscene when you get to the On The Moon area"                                          -Credits "Chez Cousteau"



    # OTHER #

    CreateReduxGroup    -Tag  "Other"             -Text "Other"
    CreateReduxCheckBox -Name "PictoboxDelayFix"  -Text "Pictograph Box Delay Fix" -Info "Photos are taken instantly with the Pictograph Box by removing the Anti-Aliasing"                                                                  -Checked -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "MushroomBottle"    -Text "Fix Mushroom Bottle"      -Info "Fix the item reference when collecting Magical Mushrooms as Link puts away the bottle automatically due to an error"                                        -Credits "ozidual"
    CreateReduxCheckBox -Name "ClockTown"         -Text "Fix Clock Town"           -Info "Fix misaligned gaps and seams in several places in Clock Town"                                                                                              -Credits "Linkz"
    CreateReduxCheckBox -Name "SouthernSwamp"     -Text "Fix Southern Swamp"       -Info "Fix a misplaced door after Woodfall has been cleared and you return to the Potion Shop`nThe door is slightly pushed forward after Odolwa has been defeated" -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "GreatBay"          -Text "Fix Great Bay"            -Info "Fix the gap near the Research Lab platform in the Great Bay area"                                                                                           -Credits "Linkz"
    CreateReduxCheckBox -Name "FairyFountain"     -Text "Fix Fairy Fountain"       -Info "Fix the Ikana Canyon Fairy Fountain area not displaying the correct color"                                                                                  -Credits "Dybbles (fix) & ShadowOne333 (patch)"
    CreateReduxCheckBox -Name "OutOfBoundsGrotto" -Text "Fix Out-of-Bounds Grotto" -Info "Fix the out-of-bounds grotto in the Mountain Village area during winter"                                                                          -Advanced -Credits "Chez Cousteau"
    CreateReduxCheckBox -Name "OutOfBoundsRupee"  -Text "Fix Out-of-Bounds Rupee"  -Info "Fix the out-of-bounds Rupee in the Deku Palace Left Outer Garden area"                                                                            -Advanced -Credits "Chez Cousteau"
    CreateReduxCheckBox -Name "AlwaysBestEnding"  -Text "Always Best Ending"       -Info "The credits sequence always includes the best ending, regardless of actual ingame progression"                                                              -Credits "Marcelo20XX"
    CreateReduxCheckBox -Name "DebugMapSelect"    -Text "Debug Map Select"         -Info "Translates the Debug Map Select menu into English"                                                                                                          -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "DebugItemSelect"   -Text "Debug Item Select"        -Info "Translates the Debug Inventory Select menu into English"                                                                                                    -Credits "GhostlyDark"

    CreateReduxGroup    -Tag  "Cutscenes"         -Text "Cutscene Fixes"   -Advanced
    CreateReduxCheckBox -Name "GohtAwakening"     -Text "Goht Awakening"   -Info "Fix Goht's awakening cutscene so that Link no longer gets run over"                     -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "BombLady"          -Text "Bomb Lady"        -Info "Fix the Bomb Lady for unused cutscenes in North Clock Town"                             -Credits "Chez Cousteau"
    CreateReduxCheckBox -Name "GiantsRealm"       -Text "Giant's Realm"    -Info "Fix the Giants in the unused cutscenes"                                                 -Credits "Chez Cousteau"
    CreateReduxCheckBox -Name "MountainVillage"   -Text "Mountain Village" -Info "Fix unloaded actors for unused cutscenes in the Spring version of the Mountain Village" -Credits "Chez Cousteau"
    CreateReduxCheckBox -Name "IkanaCanyon"       -Text "Ikana Canyon"     -Info "Fix transitions and unloaded actors for unused cutscenes in Ikana Canyon"               -Credits "Chez Cousteau"
    
}



#==============================================================================================================================================================================================
function CreateTabRedux() {
    
    # D-PAD ICONS LAYOUT #

    CreateReduxGroup -Tag  "DPad" -Text "D-Pad Layout" -Height 6 -Columns 4
    CreateReduxPanel -Columns 0.8 -Rows 4.1
    CreateReduxRadioButton -Name "Disable"     -SaveTo "Layout" -Column 1 -Row 1          -Text "Disable"    -Info "Completely disable the D-Pad"                      -Credits "Ported from Redux"
    CreateReduxRadioButton -Name "Hide"        -SaveTo "Layout" -Column 1 -Row 2          -Text "Hidden"     -Info "Hide the D-Pad icons, while they are still active" -Credits "Ported from Redux"
    CreateReduxRadioButton -Name "LayoutLeft"  -SaveTo "Layout" -Column 1 -Row 3 -Checked -Text "Left Side"  -Info "Show the D-Pad icons on the left side of the HUD"  -Credits "Ported from Redux"
    CreateReduxRadioButton -Name "LayoutRight" -SaveTo "Layout" -Column 1 -Row 4          -Text "Right Side" -Info "Show the D-Pad icons on the right side of the HUD" -Credits "Ported from Redux"
    $Items = @("Disabled", "Ocarina of Time", "Hero's Bow", "Pictograph Box", "Deku Mask", "Goron Mask", "Zora Mask", "Fierce Deity's Mask", "Bunny Hood")
    CreateReduxComboBox    -Name "Up"          -Column 2.95 -Row 1   -Length 160 -Items $Items -Default "Deku Mask"       -Info "Set the quick slot item for the D-Pad Up button"    -Credits "Ported from Redux"
    CreateReduxComboBox    -Name "Left"        -Column 1.95 -Row 3.5 -Length 160 -Items $Items -Default "Goron Mask"      -Info "Set the quick slot item for the D-Pad Left button"  -Credits "Ported from Redux"
    CreateReduxComboBox    -Name "Right"       -Column 3.95 -Row 3.5 -Length 160 -Items $Items -Default "Zora Mask"       -Info "Set the quick slot item for the D-Pad Right button" -Credits "Ported from Redux"
    CreateReduxComboBox    -Name "Down"        -Column 2.95 -Row 6   -Length 160 -Items $Items -Default "Ocarina of Time" -Info "Set the quick slot item for the D-Pad Down button"  -Credits "Ported from Redux"
    $Redux.DPad.Reset = CreateReduxButton      -Column 1    -Row 5   -Height 30  -Text "Reset Layout" -Info "Reset the layout for the D-Pad"



    # D-Pad Buttons Customization - Image #

    $PictureBox = CreateImageBox -x 390 -y 40 -w 128 -h 128
    SetBitmap -Path ($Paths.Main + "\D-Pad.png") -Box $PictureBox
    EnableElem -Elem @($Redux.DPad.Up, $Redux.DPad.Left, $Redux.DPad.Right, $Redux.DPad.Down, $Redux.DPad.Reset) -Active (!$Redux.DPad.Disable.Checked)
    $Redux.DPad.Disable.Add_CheckedChanged({ EnableElem -Elem @($Redux.DPad.Up, $Redux.DPad.Left, $Redux.DPad.Right, $Redux.DPad.Down, $Redux.DPad.Reset) -Active (!$Redux.DPad.Disable.Checked) })
    $Redux.DPad.Reset.Add_Click({ $Redux.DPad.Up.SelectedIndex = 2; $Redux.DPad.Left.SelectedIndex = 3; $Redux.DPad.Right.SelectedIndex = 4; $Redux.DPad.Down.SelectedIndex = 1 })



    # GAMEPLAY #

    CreateReduxGroup    -Tag  "Gameplay" -Text "Gameplay"
    $Last.Width = 2
    CreateReduxCheckBox -Name "AltRedux"           -Advanced -Text "Old Redux"                  -Info "Uses the older outdated version of Redux"                                           -Credits "Maroc (fixed by GhostlyDark, adjusted by Admentus)" -Warning "Only use the older outdated version if you run into issues with the newer updated Redux version"
    CreateReduxCheckBox -Name "FasterBlockPushing" -Checked  -Text "Faster Block Pushing"       -Info "All blocks are pushed faster"                                                       -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "ElegySpeedup"       -Checked  -Text "Elegy of Emptiness Speedup" -Info "The Elegy of Emptiness statue summoning cutscene is skipped after playing the song" -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "FierceDeity"                  -Text "Fierce Deity Anywhere"      -Info "The Fierce Deity Mask can be used anywhere now"                                     -Credits "Ported from Redux"

    if (IsAdvanced) {
        EnableElem -Elem @($Redux.Gameplay.ElegySpeedup, $Redux.Gameplay.FierceDeity) -Active (!$Redux.Gameplay.AltRedux.Checked)
        $Redux.Gameplay.AltRedux.Add_CheckedChanged({ EnableElem -Elem @($Redux.Gameplay.ElegySpeedup, $Redux.Gameplay.FierceDeity) -Active (!$Redux.Gameplay.AltRedux.Checked) })
    }



    # HERO #

    CreateReduxGroup    -Tag  "Hero" -Text "Hero Mode"
    CreateReduxCheckBox -Name "MasterQuest" -Text "Master Quest"-Info "Use all areas and dungeons from the Master Quest ROM hack`nThis is for advanced players who like a higher challenge`nThe structure of the walkthrough is completely re-arranged" -Credits "Admentus (ported) & DeathBasket (ROM hack)"

    $Redux.Hero.MasterQuest.Add_CheckStateChanged({
        if ($Redux.Hero.MasterQuest.Checked) {
            $Redux.Hero.CloseBombShop.Checked = $True
            $Redux.Text.MasterQuest.Checked   = $True
        }
    })



    # BUTTON COLORS #

    CreateButtonColorOptions -Default 2
    
}



#==============================================================================================================================================================================================
function CreateTabLanguage() {
    
    CreateLanguageContent



    # ENGLISH TEXT OPTIONS #
     
    CreateReduxGroup -Tag "Text" -Text "English Text Options"
    CreateReduxPanel -Columns 4
    CreateReduxRadioButton -Name "Vanilla"     -Checked  -Max 4 -SaveTo "Dialogue" -Text "Vanilla Text"      -Info "Keep the text as it is"
    CreateReduxRadioButton -Name "Restore"               -Max 4 -SaveTo "Dialogue" -Text "Restore Text"      -Info "Restores and fixes the following:`n- Restore the area titles cards for those that do not have any`n- Sound effects that do not play during dialogue`n- Grammar and typo fixes" -Credits "Redux"
    CreateReduxRadioButton -Name "MasterQuest" -Advanced -Max 4 -SaveTo "Dialogue" -Text "Master Quest Text" -Info "Uses the script from the Master Quest ROM hack`nAlso disables buying items from the Bomb Shop`nBest used along with the Master Quest difficulty option"                        -Credits "Admentus (ported) & DeathBasket (ROM hack)"
    CreateReduxRadioButton -Name "Custom"      -Advanced -Max 4 -SaveTo "Dialogue" -Text "Custom"            -Info ('Insert custom dialogue found from "..\Patcher64+ Tool\Files\Games\Majora' + "'" + 's Mask\Custom Text"') -Warning "Make sure your custom script is proper and correct, or your ROM will crash`n[!] No edit will be made if the custom script is missing"

    CreateReduxCheckBox -Name "AdultPronouns" -Text "Adult Pronouns"      -Info "Refer to Link as an adult instead of a child"                                                                                                        -Credits "Skilar"
    CreateReduxCheckBox -Name "OcarinaIcons"  -Text "Ocarina Icons (WIP)" -Info "Restore the Ocarina Icons with their text when transformed like in the N64 Beta or 3DS version (Work-In-Progress)`nRequires the Restore Text option" -Credits "ShadowOne333" -Advanced



    # OTHER TEXT OPTIONS #

    CreateReduxGroup    -Tag  "Text"       -Text "Other Text Options"
    CreateReduxCheckBox -Name "Comma"      -Text "Better Comma"     -Info "Make the comma not look as awful"                                                                                                                     -Credits "ShadowOne333"
    CreateReduxComboBox -Name "TatlCUp"    -Text "Tatl C-Up Prompt" -Items @("Default", "Override", "Tatl", "Taya") -FilePath ($GameFiles.textures + "\Tatl") -Ext "cup" -Info "Replace the C-Up Button prompt for Tatl"         -Credits "GhostlyDark (injects)"
    CreateReduxComboBox -Name "TatlScript" -Text "Tatl Text"        -Items @("Default", "Override", "Tatl", "Taya", "Tael", "Navi", "Nite")                              -Info "Change the name for Navi in the dialogue script" -Credits "Admentus & GhostlyDark"


    $Redux.Text.Restore.Add_CheckedChanged({ EnableElem -Elem $Redux.Text.OcarinaIcons -Active $this.checked })
    foreach ($i in 0.. ($Files.json.languages.length-1)) { $Redux.Language[$i].Add_CheckedChanged({ UnlockLanguageContent }) }
    UnlockLanguageContent

}



#==============================================================================================================================================================================================
function UnlockLanguageContent() {
    
    # English options
    EnableElem -Elem $Redux.Text.Vanilla       -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.Restore       -Active $Redux.Language[0].checked
    EnableElem -Elem $Redux.Text.MasterQuest   -Active $Redux.Language[0].checked
    EnableElem -Elem $Redux.Text.Custom        -Active $Redux.Language[0].checked
    EnableElem -Elem $Redux.Text.AdultPronouns -Active $Redux.Language[0].checked
    EnableElem -Elem $Redux.Text.OcarinaIcons  -Active ($Redux.Language[0].checked -and $Redux.Text.Restore.Checked)

}



#==============================================================================================================================================================================================
function CreateTabGraphics() {
    
    # GRAPHICS #

    $info  = "Patch the game to be in true 16:9 widescreen with the HUD pushed to the edges.`n`nKnown Issues:`n- Notebook screen stretched`n- D-Pad icons causing issues if combined with Redux (force hidden)"

    CreateReduxGroup -Tag "Graphics" -Text "Graphics" -Columns 4
    CreateReduxCheckBox -Name "Widescreen"       -Text "16:9 Widescreen (Advanced)"   -Info $info                                                                                                          -Native -Credits "Granny Story images by Nerrel, Widescreen Patch by gamemasterplc, enhanced and ported by GhostlyDark"
    CreateReduxCheckBox -Name "WidescreenAlt"    -Text "16:9 Widescreen (Simplified)" -Info "Apply 16:9 Widescreen adjusted backgrounds and textures (as well as 16:9 Widescreen for the Wii VC)"                  -Credits "Aspect Ratio Fix by Admentus`n16:9 backgrounds by GhostlyDark & ShadowOne333" -Link $Redux.Graphics.Widescreen
    CreateReduxCheckBox -Name "ExtendedDraw"     -Text "Extended Draw Distance"       -Info "Increases the game's draw distance for objects`nDoes not work on all objects"                                         -Credits "Admentus"
    CreateReduxCheckBox -Name "PixelatedStars"   -Text "Disable Pixelated Stars"      -Info "Completely disable the stars at night-time, which are pixelated dots and do not have any textures for HD replacement" -Credits "Admentus"
    
    if (!$IsWiiVC)   { $info = "`n`n--- WARNING ---`nDisabling cutscene effects fixes temporary issues with both Widescreen and Redux patched where garbage pixels at the edges of the screen or garbled text appears`nWorkaround: Resize the window when that happens" }
    else             { $info = "" }
    CreateReduxCheckBox -Name "MotionBlur"       -Text "Disable Motion Blur"          -Info ("Completely d isable the use of motion blur in-game" + $info)                                                         -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "FlashbackOverlay" -Text "Disable Flashback Overlay"    -Info ("Disables the overlay shown during Princess Zelda flashback scene" + $info)                                           -Credits "GhostlyDark"

    $models = LoadModelsList -Category "Child"
    CreateReduxComboBox -Name "ChildModels" -Text "Hylian Model" -Items (@("Original") + $models) -Default "Original" -Info "Replace the Hylian model used for Link"

    $info = $models = $null



    # MODELS PREVIEW #

    CreateReduxGroup -Tag "Graphics" -Text "Model Previews"
    $Last.Group.Height = (DPISize 223)
    CreateImageBox -x 140  -y 25 -w 120 -h 180 -Name "ModelsPreviewChild"
    $global:PreviewToolTip = CreateToolTip
    ChangeModelsSelection



    # INTERFACE #

    CreateReduxGroup    -Tag  "UI" -Text "Interface"
    $Last.Group.Width = $Redux.Groups[$Redux.Groups.Length-3].Width; $Last.Group.Top = $Redux.Groups[$Redux.Groups.Length-3].Bottom + 5; $Last.Width = 4;
    CreateReduxCheckBox -Name "HUD"              -Text "OoT HUD Icons"                                                                                                       -Info "Replace the HUD icons with that from Ocarina of Time"                                    -Simple   -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "Rupees"           -Text "OoT Rupee Icon"                                                                                                      -Info "Replace the rupees icon with that from Ocarina of Time"                                  -Advanced -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "DungeonKeys"      -Text "OoT Key Icon"                                                                                                        -Info "Replace the key icon with that from Ocarina of Time"                                     -Advanced -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "CenterTatlPrompt" -Text "Center Tatl Prompt"                                                                                                  -Info 'Centers the "Tatl" prompt shown in the C-Up button'                                                -Credits "Ported by GhostlyDark"
    CreateReduxComboBox -Name "ButtonSize"       -Text "HUD Buttons" -Row 2 -Column 1          -FilePath ($Paths.shared + "\Buttons")    -Ext $null -Default "Large"         -Info "Set the size for the HUD buttons"                                                                  -Credits "GhostlyDark (ported)" 
    $path = $Paths.shared + "\Buttons" + "\" + $Redux.UI.ButtonSize.Text.replace(" (default)", "")
    CreateReduxComboBox -Name "ButtonStyle"      -Text "HUD Buttons" -Items @("Majora's Mask") -FilePath $path                           -Ext "bin" -Default "Majora's Mask" -Info "Set the style for the HUD buttons"                                                                 -Credits "GhostlyDark, Pizza (HD) Djipi, Community, Nerrel, Federelli, AndiiSyn"
    CreateReduxComboBox -Name "Hearts"           -Text "Heart Icons" -Items @("Majora's Mask") -FilePath ($Paths.shared + "\HUD\Hearts") -Ext "bin" -Default "Majora's Mask" -Info "Set the style for the heart icons"                                                       -Advanced -Credits "Ported by GhostlyDark & AndiiSyn"
    CreateReduxComboBox -Name "Magic"            -Text "Magic Bar"   -Items @("Majora's Mask") -FilePath ($Paths.shared + "\HUD\Magic")  -Ext "bin" -Default "Majora's Mask" -Info "Set the style for the magic meter"                                                       -Advanced -Credits "GhostlyDark, Pizza, Nerrel (HD), Zeth Alkar"
    CreateReduxCheckBox -Name "BlackBars"        -Text "No Black Bars"                                                                                                       -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes" -Credits "Admentus"
    CreateReduxCheckBox -Name "GCScheme"         -Text "GC Scheme"                                                                                                           -Info "Replace the textures to match the GameCube's scheme"                                               -Credits "Admentus & GhostlyDark"

    $path = $null


    
    # HIDE HUD #

    CreateReduxGroup    -Tag  "Hide"           -Text "Hide HUD"
    CreateReduxCheckBox -Name "Everything"     -Text "Hide Interface"        -Info "Hide the whole interface"                                                                       -Credits "Marcelo20XX" -Simple
    CreateReduxCheckBox -Name "AButton"        -Text "Hide A Button"         -Info "Hide the A Button"                                                                              -Credits "Marcelo20XX" -Advanced
    CreateReduxCheckBox -Name "BButton"        -Text "Hide B Button"         -Info "Hide the B Button"                                                                              -Credits "Marcelo20XX" -Advanced
    CreateReduxCheckBox -Name "CButtons"       -Text "Hide C Buttons"        -Info "Hide the C Buttons"                                                                             -Credits "Marcelo20XX" -Advanced
    CreateReduxCheckBox -Name "Hearts"         -Text "Hide Hearts"           -Info "Hide the Hearts display"                                                                        -Credits "Marcelo20XX" -Advanced
    CreateReduxCheckBox -Name "Magic"          -Text "Hide Magic and Rupees" -Info "Hide the Magic and Rupees display"                                                              -Credits "Marcelo20XX" -Advanced
    CreateReduxCheckBox -Name "AreaTitle"      -Text "Hide Area Title Card"  -Info "Hide the area title that displays when entering a new area"                                     -Credits "Marcelo20XX" -Advanced
    CreateReduxCheckBox -Name "Clock"          -Text "Hide Clock"            -Info "Hide the Clock display"                                                                         -Credits "Marcelo20XX" -Advanced
    CreateReduxCheckBox -Name "CountdownTimer" -Text "Hide Countdown Timer"  -Info "Hide the countdown timer that displays during the final hours before the Moon will hit Termina" -Credits "Marcelo20XX" -Advanced
    CreateReduxCheckBox -Name "Credits"        -Text "Hide Credits"          -Info "Do not show the credits text during the credits sequence"                                       -Credits "Admentus"



    # STYLES #

    CreateReduxGroup    -Tag  "Styles"        -Text "Styles"         -Columns 4
    CreateReduxComboBox -Name "RegularChests" -Text "Regular Chests" -Info "Use a different style for regular treasure chests"                                           -FilePath ($Paths.shared + "\Chests")               -Ext "front" -Items @("Regular")           -Credits "AndiiSyn & Rando"
    CreateReduxComboBox -Name "LeatherChests" -Text "Leather Chests" -Info "Use a different style for leathered treasure chests"                                         -FilePath ($Paths.shared + "\Chests")               -Ext "front" -Items @("Leather")           -Credits "AndiiSyn & Rando"
    CreateReduxComboBox -Name "BossChests"    -Text "Boss Chests"    -Info "Use a different style for Boss Key treasure chests"                                          -FilePath ($Paths.shared + "\Chests")               -Ext "front" -Items @("Boss MM")           -Credits "AndiiSyn & Rando"
    CreateReduxComboBox -Name "Crates"        -Text "Small Crates"   -Info "Use a different style for small liftable crates"                                             -FilePath ($Paths.shared + "\Crates")               -Ext "bin"   -Items @("Regular")           -Credits "Rando"
    CreateReduxComboBox -Name "Pots"          -Text "Pots"           -Info "Use a different style for throwable pots"                                                    -FilePath ($Paths.shared + "\Pots")                 -Ext "bin"   -Items @("Regular")           -Credits "Rando"
    CreateReduxComboBox -Name "HairColor"     -Text "Hair Color"     -Info "Use a different hair color style for Link`nOnly for Ocarina of Time or Majora's Mask models" -FilePath ($Paths.shared + "\Hair\Ocarina of Time") -Ext "bin"   -Items @("Default", "Blonde") -Credits "Third M & AndiiSyn"



    # HUD PREVIEWS #

    CreateReduxGroup -Tag "UI" -Text "HUD Previews"
    $Last.Group.Height = (DPISize 162)

    CreateImageBox -x 40  -y 30 -w 90  -h 90 -Name "ButtonPreview";      $Redux.UI.ButtonSize.Add_SelectedIndexChanged( { ShowHUDPreview -IsMM } ); $Redux.UI.ButtonStyle.Add_SelectedIndexChanged( { ShowHUDPreview } )
    CreateImageBox -x 160 -y 35 -w 40  -h 40 -Name "HeartsPreview";      if (IsAdvanced) { $Redux.UI.Hearts.Add_SelectedIndexChanged(   { ShowHUDPreview } ) }
    CreateImageBox -x 220 -y 35 -w 40  -h 40 -Name "RupeesPreview";      if (IsAdvanced) { $Redux.UI.Rupees.Add_CheckStateChanged(      { ShowHUDPreview } ) }
    CreateImageBox -x 280 -y 35 -w 40  -h 40 -Name "DungeonKeysPreview"; if (IsAdvanced) { $Redux.UI.DungeonKeys.Add_CheckStateChanged( { ShowHUDPreview } ) }
    CreateImageBox -x 140 -y 85 -w 200 -h 40 -Name "MagicPreview";       if (IsAdvanced) { $Redux.UI.Magic.Add_SelectedIndexChanged(    { ShowHUDPreview } ) }
    ShowHUDPreview -IsMM
    if (IsSimple) { $Redux.UI.HUD.Add_CheckStateChanged( { ShowHUDPreview } ) }

}



#==============================================================================================================================================================================================
function CreateTabAudio() {
    
    # SOUNDS / VOICES / SFX SOUND EFFECTS #

    CreateReduxGroup    -Tag  "Sounds" -Text "Sounds / Voices / SFX Sound Effects" -Height 3
    CreateReduxComboBox -Name "LowHP"             -Column 5 -Row 1 -Text "Low HP SFX" -Items @("Default", "Disabled", "Soft Beep")  -Info "Set the sound effect for the low HP beeping" -Credits "Ported from Rando"
    

    $SFX =  @("Ocarina", "Deku Pipes", "Goron Drums", "Zora Guitar", "Female Voice", "Bell", "Cathedral Bell", "Piano", "Soft Harp", "Harp", "Accordion", "Bass Guitar", "Flute", "Whistling Flute", "Gong", "Elder Goron Drums", "Choir", "Arguing", "Tatl", "Giants Singing", "Ikana King", "Frog Croak", "Beaver", "Eagle Seagull", "Dodongo")
    CreateReduxComboBox -Name "InstrumentHylian"  -Column 1 -Row 1 -Text "Instrument (Hylian)" -Default 1 -Items $SFX -Info "Replace the sound used for playing the Ocarina of Time in Hylian Form" -Credits "Ported from Rando"
    CreateReduxComboBox -Name "InstrumentDeku"    -Column 3 -Row 1 -Text "Instrument (Deku)"   -Default 2 -Items $SFX -Info "Replace the sound used for playing the Deku Pipes in Deku Form"        -Credits "Ported from Rando"
    CreateReduxComboBox -Name "InstrumentGoron"   -Column 1 -Row 2 -Text "Instrument (Goron)"  -Default 3 -Items $SFX -Info "Replace the sound used for playing the Goron Drums in Goron Form"      -Credits "Ported from Rando"
    CreateReduxComboBox -Name "InstrumentZora"    -Column 3 -Row 2 -Text "Instrument (Zora)"   -Default 4 -Items $SFX -Info "Replace the sound used for playing the Zora Guitar in Zora Form"       -Credits "Ported from Rando"
    
    CreateReduxComboBox -Name "ChildVoices"       -Column 1 -Row 3 -Text "Child Voice"        -Items @("Original") -FilePath ($GameFiles.binaries + "\Voices Child")        -Default "Original" -Info "Replace the voice used for the Child Link Model"        -Credits "`nOcarina of Time: Phantom Natsu"
    CreateReduxComboBox -Name "FierceDeityVoices" -Column 3 -Row 3 -Text "Fierce Deity Voice" -Items @("Original") -FilePath ($GameFiles.binaries + "\Voices Fierce Deity") -Default "Original" -Info "Replace the voice used for the Fierce Deity Link Model" -Credits "`nOcarina of Time: Phantom Natsu"



    # MUSIC #

    MusicOptions
    
}



#==============================================================================================================================================================================================
function CreateTabDifficulty() {
    
    # HERO MODE #

    $items1 = @("1 Monster HP","0.5x Monster HP", "1x Monster HP", "1.5x Monster HP", "2x Monster HP", "2.5x Monster HP", "3x Monster HP", "3.5x Monster HP", "4x Monster HP", "5x Monster HP")
    $items2 = @("1 Mini-Boss HP", "0.5x Mini-Boss HP", "1x Mini-Boss HP", "1.5x Mini-Boss HP", "2x Mini-Boss HP", "2.5x Mini-Boss HP", "3x Mini-Boss HP", "3.5x Mini-Boss HP", "4x Mini-Boss HP", "5x Mini-Boss HP")
    $items3 = @("1 Boss HP", "0.5x Boss HP", "1x Boss HP", "1.5x Boss HP", "2x Boss HP", "2.5x Boss HP", "3x Boss HP", "3.5x Boss HP", "4x Boss HP", "5x Boss HP")

    CreateReduxGroup    -Tag  "Hero" -Text "Hero Mode"
    CreateReduxComboBox -Name "Damage"     -Text "Damage"       -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage", "OHKO Mode")        -Info "Set the amount of damage you receive`nOHKO Mode = You die in one hit" -Credits "Admentus"
    CreateReduxComboBox -Name "Recovery"   -Text "Recovery"     -Items @("1x Recovery", "1/2x Recovery", "1/4x Recovery", "0x Recovery")         -Info "Set the amount health you recovery from Recovery Hearts"              -Credits "Admentus"
    CreateReduxComboBox -Name "MagicUsage" -Text "Magic Usage"  -Items @("1x Magic Usage", "2x Magic Usage", "4x Magic Usage", "8x Magic Usage") -Info "Set the amount of times magic is consumed at"                         -Credits "Admentus"
    CreateReduxComboBox -Name "MonsterHP"  -Text "Monster HP"   -Items $items1 -Default 3 -Info "Set the amount of health for monsters"                                                                                       -Credits "Admentus" -Warning "Some enemies are missing"
    CreateReduxComboBox -Name "MiniBossHP" -Text "Mini-Boss HP" -Items $items2 -Default 3 -Info "Set the amount of health for elite monsters and mini-bosses"                                                                 -Credits "Admentus" -Warning "Some Mini-bosses are missing"
    CreateReduxComboBox -Name "BossHP"     -Text "Boss HP"      -Items $items3 -Default 3 -Info "Set the amount of health for bosses"                                                                                         -Credits "Admentus" -Warning "Goht (phases 3) and Gyorg (phase 2) are missing"
    
    $items1 = $items2= $items3 = $null

    $Redux.Hero.Damage.Add_SelectedIndexChanged({ EnableElem -Elem $Redux.Hero.Recovery -Active ($this.Text -ne "OHKO Mode") })
    EnableElem -Elem $Redux.Hero.Recovery -Active ($Redux.Hero.Damage.Text -ne "OHKO Mode")

    CreateReduxComboBox -Name "Ammo"     -Column 1 -Row 3 -Text "Ammo Usage" -Items @("1x Ammo Usage", "2x Ammo Usage", "4x Ammo Usage", "8x Ammo Usage") -Info "Set the amount of times ammo is consumed at"                                                                        -Credits "Admentus"
    CreateReduxComboBox -Name "DamageEffect"              -Text "Damage Effect"               -Items @("Default", "Burn", "Freeze", "Shock", "Knockdown") -Info "Add an effect when damaged"                                                                                         -Credits "Ported from Rando"
    CreateReduxComboBox -Name "ClockSpeed"                -Text "Clock Speed"                 -Items @("Default", "1/3", "2/3", "2x", "3x", "6x")         -Info "Set the speed at which time is progressing"                                                                         -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "NoRecoveryHearts"          -Text "No Recovery Heart Drops"                                                                 -Info "Disable Recovery Hearts from spawning from item drops"                                                              -Credits "Admentus"
    CreateReduxCheckBox -Name "NoItemDrops"               -Text "No Item Drops"                                                                           -Info "Disable all items from spawning"                                                                                    -Credits "Admentus & BilonFullHDemon"
    CreateReduxCheckBox -Name "PalaceRoute"               -Text "Restore Palace Route"                                                                    -Info "Restore the route to the Bean Seller within the Deku Palace as seen in the Japanese release"                        -Credits "ShadowOne"
    CreateReduxCheckBox -Name "RaisedResearchLabPlatform" -Text "Raised Research Lab Platform"                                                            -Info "Raise the platform leading up to the Research Laboratory as in the Japanese release"                                -Credits "Linkz"
    CreateReduxCheckBox -Name "DeathIsMoonCrash"          -Text "Death is Moon Crash"                                                                     -Info "If you die, the moon will crash`nThere are no continues anymore"                                                    -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "CloseBombShop"             -Text "Close Bomb Shop"                                                                         -Info "The bomb shop is now closed just like in the Master Quest ROM hack`nThe first bomb bag is now found somewhere else" -Credits "Admentus (ported) & DeathBasket (ROM hack)"



    # EASY MODE #

    CreateReduxGroup    -Tag  "EasyMode" -Text "Easy Mode"
    CreateReduxCheckbox -Name "NoBlueBubbleRespawn" -Text "No Blue Bubble Respawn" -Info "Removes the respawn of the Blue Bubble monsters (until you re-enter the room)" -Credits "Garo-Mastah"

}



#==============================================================================================================================================================================================
function CreateTabColors() {
    
    # TUNIC COLORS #

    CreateReduxGroup    -Tag  "Colors" -Text "Tunic Colors" -Columns 5
    $Colors = @("Kokiri Green", "Goron Red", "Zora Blue", "Black", "White", "Azure Blue", "Vivid Cyan", "Light Red", "Fuchsia", "Purple", "Majora Purple", "Twitch Purple", "Persian Rose", "Dirty Yellow", "Blush Pink", "Hot Pink", "Rose Pink", "Orange", "Gray", "Gold", "Silver", "Beige", "Teal", "Blood Red", "Blood Orange", "Royal Blue", "Sonic Blue", "NES Green", "Dark Green", "Lumen", "Randomized", "Custom")
    CreateReduxComboBox -Name "KokiriTunic" -Column 1 -Text "Kokiri Tunic Color" -Length 230 -Shift 70 -Items $Colors -Info ("Select a color scheme for the Kokiri Tunic`n" + '"Randomized" fully randomizes the colors each time the patcher is opened') -Credits "Ported from Rando"
    $Redux.Colors.KokiriTunicButton = CreateReduxButton -Column 3 -Text "Kokiri Tunic" -Width 100  -Info "Select the color you want for the Kokiri Tunic" -Credits "Ported from Rando"
    $Redux.Colors.KokiriTunicButton.Add_Click({ $Redux.Colors.SetKokiriTunic.ShowDialog(); $Redux.Colors.KokiriTunic.Text = "Custom"; $Redux.Colors.KokiriTunicLabel.BackColor = $Redux.Colors.SetKokiriTunic.Color; $GameSettings["Hex"][$Redux.Colors.SetKokiriTunic] = $Redux.Colors.SetKokiriTunic.Color.Name })
    $Redux.Colors.SetKokiriTunic   = CreateColorDialog -Name "SetKokiriTunic" -Color "1E691B" -IsGame -Button $Redux.Colors.KokiriTunicButton
    $Redux.Colors.KokiriTunicLabel = CreateReduxColoredLabel -Link $Redux.Colors.KokiriTunicButton -Color $Redux.Colors.SetKokiriTunic.Color

    $Redux.Colors.KokiriTunic.Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.KokiriTunic -Dialog $Redux.Colors.SetKokiriTunic -Label $Redux.Colors.KokiriTunicLabel })
    SetTunicColorsPreset -ComboBox $Redux.Colors.KokiriTunic -Dialog $Redux.Colors.SetKokiriTunic -Label $Redux.Colors.KokiriTunicLabel

    $Redux.Graphics.ChildModels.Add_SelectedIndexChanged({ EnableElem -Elem @($Redux.Colors.KokiriTunic, $Redux.Colors.KokiriTunicButton) -Active ($this.selectedIndex -eq 0) })
    EnableElem -Elem @($Redux.Colors.KokiriTunic, $Redux.Colors.KokiriTunicButton) -Active ($Redux.Graphics.ChildModels.selectedIndex -eq 0)



    # MISC COLORS #

    CreateReduxGroup    -Tag  "Colors" -Text "Misc Colors"
    CreateReduxCheckBox -Name "RedIce" -Text "Red Ice" -Info "Recolors the ice blocks which can be unfrozen from blue to red" -Credits "Garo-Mastah"



    # FORM COLORS #

    CreateReduxGroup    -Tag  "Colors" -Text "Mask Form Colors"
    CreateReduxComboBox -Name "DekuLink"  -Column 1 -Text "Deku Link Color"  -Length 170 -Shift 30 -Items @("Green") -FilePath ($GameFiles.Textures + "\Color - Deku Link")         -Info "Select a color scheme for Deku Link"  -Credits "Admentus, ShadowOne333 & Garo-Mastah"
    CreateReduxComboBox -Name "GoronLink" -Column 3 -Text "Goron Link Color" -Length 170 -Shift 30 -Items @("Green") -FilePath ($GameFiles.Textures + "\Color - Goron Link")        -Info "Select a color scheme for Goron Link" -Credits "Admentus, ShadowOne333 & Garo-Mastah"
    CreateReduxComboBox -Name "ZoraLink"  -Column 5 -Text "Zora Link Color"  -Length 170 -Shift 30 -Items @("Green") -FilePath ($GameFiles.Textures + "\Color - Zora Link\Palette") -Info "Select a color scheme for Zora Link"  -Credits "Admentus, ShadowOne333 & Garo-Mastah"

    $Redux.Colors.DekuLinkLabel = CreateLabel -X ($Redux.Colors.DekuLink.Right + (DPISize 15)) -Y $Redux.Colors.DekuLink.Top -Width (DPISize 40) -Height (DPISize 20) -AddTo $Last.Group
    $Redux.Colors.DekuLink.Add_SelectedIndexChanged({ SetFormColorLabel -ComboBox $Redux.Colors.DekuLink -Label $Redux.Colors.DekuLinkLabel })
    SetFormColorLabel -ComboBox $Redux.Colors.DekuLink -Label $Redux.Colors.DekuLinkLabel

    $Redux.Colors.GoronLinkLabel = CreateLabel -X ($Redux.Colors.GoronLink.Right + (DPISize 15)) -Y $Redux.Colors.GoronLink.Top -Width (DPISize 40) -Height (DPISize 20) -AddTo $Last.Group
    $Redux.Colors.GoronLink.Add_SelectedIndexChanged({ SetFormColorLabel -ComboBox $Redux.Colors.GoronLink -Label $Redux.Colors.GoronLinkLabel })
    SetFormColorLabel -ComboBox $Redux.Colors.GoronLink -Label $Redux.Colors.GoronLinkLabel

    $Redux.Colors.ZoraLinkLabel = CreateLabel -X ($Redux.Colors.ZoraLink.Right + (DPISize 15)) -Y $Redux.Colors.ZoraLink.Top -Width (DPISize 40) -Height (DPISize 20) -AddTo $Last.Group
    $Redux.Colors.ZoraLink.Add_SelectedIndexChanged({ SetFormColorLabel -ComboBox $Redux.Colors.ZoraLink -Label $Redux.Colors.ZoraLinkLabel })
    SetFormColorLabel -ComboBox $Redux.Colors.ZoraLink -Label $Redux.Colors.ZoraLinkLabel
    


    # SPIN ATTACK COLORS #

    CreateSpinAttackColorOptions



    # FAIRY COLORS #

    CreateFairyColorOptions -Name "Tatl"



    # HUD COLORS #

    CreateReduxGroup    -Tag  "Colors" -Text "HUD Colors" -IsRedux -Height 2
    CreateReduxComboBox -Name "Hearts"  -Column 1 -Text "Hearts Colors"  -Length 220 -Items @("Red", "Green", "Blue", "Yellow", "Randomized", "Custom") -Info ("Select a preset for the hearts colors`n" + '"Randomized" fully randomizes the colors each time the patcher is opened')
    CreateReduxComboBox -Name "Magic"   -Column 3 -Text "Magic Colors"   -Length 220 -Items @("Green", "Red", "Blue", "Purple", "Pink", "Yellow", "White", "Randomized", "Custom") -Info ("Select a preset for the magic colors`n" + '"Randomized" fully randomizes the colors each time the patcher is opened')
    CreateReduxComboBox -Name "Minimap" -Column 5 -Text "Minimap Colors" -Length 220 -Items @("Cyan", "Green", "Red", "Blue", "Gray", "Purple", "Pink", "Yellow", "White", "Black", "Randomized", "Custom") -Info ("Select a preset for the minimap colors`n" + '"Randomized" fully randomizes the colors each time the patcher is opened')

    # Heart / Magic Colors - Buttons
    $Buttons = @()
    $Buttons += CreateReduxButton -Column 1 -Row 2 -Width 100 -Tag $Buttons.Count -Text "Hearts (Base)"    -Info "Select the color you want for the standard hearts display" -Credits "Ported from Rando"
    $Buttons += CreateReduxButton -Column 2 -Row 2 -Width 100 -Tag $Buttons.Count -Text "Hearts (Double)"  -Info "Select the color you want for the enhanced hearts display" -Credits "Ported from Rando"
    $Buttons += CreateReduxButton -Column 3 -Row 2 -Width 100 -Tag $Buttons.Count -Text "Magic (Base)"     -Info "Select the color you want for the standard magic display"  -Credits "Ported from Rando"
    $Redux.Colors.BaseMagic = $Buttons[$Buttons.Length-1]
    $Buttons += CreateReduxButton -Column 4 -Row 2 -Width 100 -Tag $Buttons.Count -Text "Magic (Infinite)" -Info "Select the color you want for the infinite magic display"  -Credits "Ported from Rando"
    $Redux.Colors.InfiniteMagic = $Buttons[$Buttons.Length-1]
    $Buttons += CreateReduxButton -Column 5 -Row 2 -Width 100 -Tag $Buttons.Count -Text "Minimap"          -Info "Select the color you want for the minimap"                 -Credits "Ported from Rando"

    # Heart / Magic Colors - Dialogs
    $Redux.Colors.SetHUDStats = @()
    $Redux.Colors.SetHUDStats += CreateColorDialog -Color "FF4632" -Name "SetBaseHearts"    -IsGame -Button $Buttons[0]
    $Redux.Colors.SetHUDStats += CreateColorDialog -Color "C80000" -Name "SetDoubleHearts"  -IsGame -Button $Buttons[1]
    $Redux.Colors.SetHUDStats += CreateColorDialog -Color "00C800" -Name "SetBaseMagic"     -IsGame -Button $Buttons[2]
    $Redux.Colors.SetHUDStats += CreateColorDialog -Color "0000C8" -Name "SetInfiniteMagic" -IsGame -Button $Buttons[3]
    $Redux.Colors.SetHUDStats += CreateColorDialog -Color "00FFFF" -Name "SetMinimap"       -IsGame -Button $Buttons[4]

    # Heart / Magic Colors - Labels
    $Redux.Colors.HUDStatsLabels = @()
    for ($i=0; $i -lt $Buttons.length; $i++) {
        $Buttons[$i].Add_Click({
            $Redux.Colors.SetHUDStats[[int16]$this.Tag].ShowDialog(); $Redux.Colors.HUDStatsLabels[[int16]$this.Tag].BackColor = $Redux.Colors.SetHUDStats[[int16]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetHUDStats[[int16]$this.Tag].Tag] = $Redux.Colors.SetHUDStats[[int16]$this.Tag].Color.Name
            if     ($this.Tag -lt 2)   { $Redux.Colors.Hearts.Text   = "Custom" }
            elseif ($this.Tag -lt 4)   { $Redux.Colors.Magic.Text    = "Custom" }
            else                       { $Redux.Colors.Minimap.Text  = "Custom" }
        })
        $Redux.Colors.HUDStatsLabels += CreateReduxColoredLabel -Link $Buttons[$i] -Color $Redux.Colors.SetHUDStats[$i].Color
    }

    $Redux.Colors.Hearts.Add_SelectedIndexChanged({ SetHeartsColorsPreset -ComboBox $Redux.Colors.Hearts -Dialog $Redux.Colors.SetHUDStats[0] -Label $Redux.Colors.HUDStatsLabels[0] })
    SetHeartsColorsPreset -ComboBox $Redux.Colors.Hearts -Dialog $Redux.Colors.SetHUDStats[0] -Label $Redux.Colors.HUDStatsLabels[0]
    $Redux.Colors.Hearts.Add_SelectedIndexChanged({
        SetHeartsColorsPreset -ComboBox $Redux.Colors.Hearts -Dialog $Redux.Colors.SetHUDStats[1] -Label $Redux.Colors.HUDStatsLabels[1]
        if (IsIndex $Redux.Colors.Hearts) { SetColor -Color "C80000" -Dialog $Redux.Colors.SetHUDStats[1] -Label $Redux.Colors.HUDStatsLabels[1] }
    })
    SetHeartsColorsPreset -ComboBox $Redux.Colors.Hearts -Dialog $Redux.Colors.SetHUDStats[1] -Label $Redux.Colors.HUDStatsLabels[1]
    if (IsIndex $Redux.Colors.Hearts) { SetColor -Color "C80000" -Dialog $Redux.Colors.SetHUDStats[1] -Label $Redux.Colors.HUDStatsLabels[1] }

    $Redux.Colors.Magic.Add_SelectedIndexChanged({ SetMagicColorsPreset -ComboBox $Redux.Colors.Magic -Dialog $Redux.Colors.SetHUDStats[2] -Label $Redux.Colors.HUDStatsLabels[2] })
    SetMagicColorsPreset -ComboBox $Redux.Colors.Magic -Dialog $Redux.Colors.SetHUDStats[2] -Label $Redux.Colors.HUDStatsLabels[2]
    $Redux.Colors.Magic.Add_SelectedIndexChanged({
        SetMagicColorsPreset -ComboBox $Redux.Colors.Magic -Dialog $Redux.Colors.SetHUDStats[3] -Label $Redux.Colors.HUDStatsLabels[3]
        if (IsIndex $Redux.Colors.Magic) { SetColor -Color "0000C8" -Dialog $Redux.Colors.SetHUDStats[3] -Label $Redux.Colors.HUDStatsLabels[3] }
    })
    SetMagicColorsPreset -ComboBox $Redux.Colors.Magic -Dialog $Redux.Colors.SetHUDStats[3] -Label $Redux.Colors.HUDStatsLabels[3]
    if (IsIndex $Redux.Colors.Magic) { SetColor -Color "0000C8" -Dialog $Redux.Colors.SetHUDStats[3] -Label $Redux.Colors.HUDStatsLabels[3] }

    $Redux.Colors.Minimap.Add_SelectedIndexChanged({ SetMinimapColorsPreset -ComboBox $Redux.Colors.Minimap -Dialog $Redux.Colors.SetHUDStats[4] -Label $Redux.Colors.HUDStatsLabels[4] })
    SetMinimapColorsPreset -ComboBox $Redux.Colors.Minimap -Dialog $Redux.Colors.SetHUDStats[4] -Label $Redux.Colors.HUDStatsLabels[4]

}



#==============================================================================================================================================================================================
function CreateTabEquipment() {
    
    # CAPACITY SELECTION #

    CreateReduxGroup    -Tag  "Capacity" -Text "Capacity Selection" -Columns 3 -Advanced
    CreateReduxCheckBox -Name "EnableAmmo"    -Text "Change Ammo Capacity"   -Info "Enable changing the capacity values for ammo"
    CreateReduxCheckBox -Name "EnableWallet"  -Text "Change Wallet Capacity" -Info "Enable changing the capacity values for the wallets"



    # GAMEPLAY #

    CreateReduxGroup    -Tag  "Gameplay"        -Text "Gameplay"
    CreateReduxCheckBox -Name "UnsheathSword"   -Text "Unsheath Sword"    -Info "The sword is unsheathed first before immediately swinging it"                                             -Credits "Admentus"
    CreateReduxCheckBox -Name "SwordBeamAttack" -Text "Sword Beam Attack" -Info "Replaces the Spin Attack with the Sword Beam Attack`nYou can still perform the Quick Spin Attack"         -Credits "Admentus (ROM hack) & CloudModding (GameShark)"
    CreateReduxCheckBox -Name "FixEponaSword"   -Text "Fix Epona Sword"   -Info "Change Epona's B button behaviour to prevent you from losing your sword if you don't have the Hero's Bow" -Credits "Ported from Rando"



    # HITBOX #

    CreateReduxGroup  -Tag  "Equipment" -Text "Sliders" -Height 2.7 -Advanced
    CreateReduxSlider -Name "KokiriSword"      -Column 1 -Row 1 -Default 3000 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Kokiri Sword"        -Info "Set the length of the hitbox of the Kokiri Sword"              -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "RazorSword"       -Column 3 -Row 1 -Default 3000 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Razor Sword"         -Info "Set the length of the hitbox of the Razor Sword"               -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "GildedSword"      -Column 5 -Row 1 -Default 4000 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Gilded Sword"        -Info "Set the length of the hitbox of the Gilded Sword"              -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "GreatFairysSword" -Column 1 -Row 2 -Default 5500 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Great Fairy's Sword" -Info "Set the length of the hitbox of the Great Fairy's Sword Knife" -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "BlastMask"        -Column 3 -Row 2 -Default 310  -Min 1   -Max 1024 -Freq 64  -Small 32  -Large 64  -Text "Blast Mask"          -Info "Set the cooldown duration of the Blast Mask"                   -Credits "Ported from Rando"
    CreateReduxSlider -Name "ShieldRecoil"     -Column 5 -Row 2 -Default 4552 -Min 0   -Max 8248 -Freq 512 -Small 256 -Large 512 -Text "Shield Recoil"       -Info "Set the pushback distance when getting hit while shielding"    -Credits "Admentus"

    

    # AMMO #

    $Redux.Box.Ammo = CreateReduxGroup -Tag "Capacity" -Text "Ammo Capacity Selection" -Advanced
    CreateReduxTextBox -Name "Quiver1"     -Text "Quiver (1)"      -Value 30  -Info "Set the capacity for the Quiver (Base)"        -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver2"     -Text "Quiver (2)"      -Value 40  -Info "Set the capacity for the Quiver (Upgrade 1)"   -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver3"     -Text "Quiver (3)"      -Value 50  -Info "Set the capacity for the Quiver (Upgrade 2)"   -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag1"    -Text "Bomb Bag (1)"    -Value 20  -Info "Set the capacity for the Bomb Bag (Base)"      -Credits "GhostlyDark" 
    CreateReduxTextBox -Name "BombBag2"    -Text "Bomb Bag (2)"    -Value 30  -Info "Set the capacity for the Bomb Bag (Upgrade 1)" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag3"    -Text "Bomb Bag (3)"    -Value 40  -Info "Set the capacity for the Bomb Bag (Upgrade 2)" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuSticks1" -Text "Deku Sticks (1)" -Value 10  -Info "Set the capacity for the Deku Sticks (Base)"   -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuNuts1"   -Text "Deku Nuts (1)"   -Value 20  -Info "Set the capacity for the Deku Nuts (Base)"     -Credits "GhostlyDark"



    # WALLET #

    $Redux.Box.Wallet = CreateReduxGroup -Tag "Capacity" -Text "Wallet Capacity Selection" -Advanced
    CreateReduxTextBox -Name "Wallet1" -Length 3 -Text "Wallet (1)" -Value 99  -Info "Set the capacity for the Wallet (Base)"      -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet2" -Length 3 -Text "Wallet (2)" -Value 200 -Info "Set the capacity for the Wallet (Upgrade 1)" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet3" -Length 3 -Text "Wallet (3)" -Value 500 -Info "Set the capacity for the Wallet (Upgrade 2)" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet4" -Length 3 -Text "Wallet (4)" -Value 500 -Info "Set the capacity for the Wallet (Upgrade 3)" -Credits "GhostlyDark" -Warning "This wallet is not obtained through regular gameplay" -Advanced



    # EQUIPMENT #

    CreateReduxGroup    -Tag "Gameplay"    -Text "Equipment"
    CreateReduxCheckBox -Name "RazorSword" -Text "Permanent Razor Sword" -Info "The Razor Sword won't get destroyed after 100 hits`nYou can also keep the Razor Sword when traveling back in time" -Credits "darklord92"



    if (IsAdvanced) {
        EnableForm -Form $Redux.Box.Ammo -Enable $Redux.Capacity.EnableAmmo.Checked
        $Redux.Capacity.EnableAmmo.Add_CheckStateChanged({ EnableForm -Form $Redux.Box.Ammo -Enable $Redux.Capacity.EnableAmmo.Checked })
        EnableForm -Form $Redux.Box.Wallet -Enable $Redux.Capacity.EnableWallet.Checked
        $Redux.Capacity.EnableWallet.Add_CheckStateChanged({ EnableForm -Form $Redux.Box.Wallet -Enable $Redux.Capacity.EnableWallet.Checked })

        $Redux.Capacity.BombBag1.Add_TextChanged({
            if ($this.Text -eq "30") {
                $cursorPos = $this.SelectionStart
                $this.Text = $this.Text = "31"
                $this.SelectionStart = $cursorPos - 1
                $this.SelectionLength = 0
            }
        })
    }

}



#==============================================================================================================================================================================================
function CreateTabSpeedup() {
    
    # SKIP #

    CreateReduxGroup    -Tag  "Skip" -Text "Skip"
    CreateReduxCheckBox -Name "BossCutscenes"  -Text "Skip Boss Cutscenes" -Info "Skip the cutscenes that play during bosses and mini-bosses" -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "TatlInterrupts" -Text "Skip Tatl Interrupts" -Info "Skip the cutscenes that are triggered by Tatl"             -Credits "Ported from Rando"



    # SPEEDUP #

    CreateReduxGroup    -Tag  "Speedup" -Text "Speedup"
    CreateReduxCheckBox -Name "LabFish" -Text "Faster Lab Fish"   -Info "Only one fish has to be feeded in the Marine Research Lab"                            -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "Dampe"   -Text "Good Dampé RNG"    -Info "Dampe's Digging Game always has two Ghost Flames on the ground and one up the ladder" -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "DogRace" -Text "Good Dog Race RNG" -Info "The Gold Dog always wins the Doggy Racetrack race if you have the Mask of Truth"      -Credits "Ported from Rando"



    # WALLET #

    CreateReduxGroup   -Tag  "Speedup" -Text "Bank Deposit Rewards"
    CreateReduxTextBox -Name "Bank1" -Length 4 -Text "First Reward"  -Value 200  -Info "Set the amount of Rupees required to deposit for the first reward"                                                                               -Credits "Ported from Rando"
    CreateReduxTextBox -Name "Bank2" -Length 4 -Text "Second Reward" -Value 1000 -Info "Set the amount of Rupees required to deposit for the second reward"                                                                              -Credits "Ported from Rando"
    CreateReduxTextBox -Name "Bank3" -Length 4 -Text "Final Reward"  -Value 5000 -Info "Set the amount of Rupees required to deposit for the final reward`nThis value also changes the maximum amount that can be deposited to the bank" -Credits "Ported from Rando"

}