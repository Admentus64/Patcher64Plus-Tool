function PrePatchOptions() {

    if (IsChecked $Redux.Graphics.Widescreen)          { ApplyPatch -Patch "Decompressed\Optional\widescreen.ppf"    }
    if (IsDefault $Redux.Features.OcarinaIcons -Not)   { ApplyPatch -Patch "Decompressed\Optional\ocarina_icons.ppf" }

    if ( (IsSet $LanguagePatch.DmaTable)        -and !$Patches.Redux.Checked)   { return }

    if   (IsChecked $Redux.Graphics.Widescreen)                                 { RemoveFile $Files.dmaTable }
    if ( (IsChecked $Redux.Graphics.Widescreen) -and !$Patches.Redux.Checked)   { Add-Content $Files.dmaTable "0 1 2 3 4 5 6 7 -8 -9 15 16 17 18 19 20 -21 22 -24 25 26 27 28 29 30 -652 1127 -1540 -1541 -1542 -1543 -1544 -1545 -1546 -1547 -1548 -1549 -1550 -1551 1552 1553 1554 1555 1556 1557 1558 1559 1560 1561 1562 1563 1564 1565 1566 1567" }
    if ( (IsChecked $Redux.Graphics.Widescreen) -and  $Patches.Redux.Checked)   { Add-Content $Files.dmaTable "0 1 2 3 4 5 6 7 -8 -9 15 16 17 18 19 20 -21 22 -24 25 26 27 28 29 30 -652 1127 -1540 -1541 -1542 -1543 1544 1545 1546 1547 1548 1549 1550 -1551 1552 1553 1554 1555 1556 1557 1558 1559 1560 1561 1562 1563 1564 1565 1566 1567" }



    # SCENES #

    if (IsChecked $Redux.Gameplay.CustomScenes) {
        if (TestFile $GameFiles.scenesPatch) { ApplyPatch -Patch $GameFiles.scenesPatch -FullPath }
    }

}



#==============================================================================================================================================================================================
function PatchOptions() {
    
    # MODELS #

    if (IsDefault -Elem $Redux.Graphics.ChildModels -Not)   { PatchModel -Category "Child" -Name $Redux.Graphics.ChildModels.Text }



    # DIFFICULTY #

    if (IsChecked $Redux.Hero.RaisedResearchLabPlatform)   { ApplyPatch -Patch "Decompressed\optional\raised_research_lab_platform.ppf" }



    # CAPACITY #

    if (IsChecked $Redux.Capacity.EnableWallet) {
        if ($Redux.Capacity.Wallet1.Text.Length -gt 3 -or $Redux.Capacity.Wallet2.Text.Length -gt 3 -or $Redux.Capacity.Wallet3.Text.Length -gt 3 -or $Redux.Capacity.Wallet4.Text.Length -gt 3) { ApplyPatch -Patch "Decompressed\optional\four_digits_wallet.ppf" }
    }



    # EQUIPMENT #

    if     (IsIndex -Elem $Redux.Gameplay.SpinAttack -Index 2)   { ApplyPatch -Patch "Decompressed\optional\smaller_spin.ppf"                   }
    elseif (IsIndex -Elem $Redux.Gameplay.SpinAttack -Index 3)   { ApplyPatch -Patch "Decompressed\optional\no_quick_spin.ppf"                  }
    elseif (IsIndex -Elem $Redux.Gameplay.SpinAttack -Index 4)   { ApplyPatch -Patch "Decompressed\optional\no_quick_spin_and_smaller_spin.ppf" }

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
    
    if (IsChecked $Redux.Gameplay.FierceDeityAnywhere) {
        ChangeBytes -Offset "BA76D0"  -Values "1000";     ChangeBytes -Offset "E384D8"  -Values "284100021420"; ChangeBytes -Offset "E7A852"  -Values "CA8480A0CA84"; ChangeBytes -Offset "F4D3A4"  -Values "5441002B24060001"; ChangeBytes -Offset "10632C0" -Values "286100021020000200000000A48702C8"
        ChangeBytes -Offset "1068960" -Values "00000000"; ChangeBytes -Offset "1069B60" -Values "24080002";     ChangeBytes -Offset "2704FF7" -Values "A9";           ChangeBytes -Offset "2704FFD" -Values "A9";               ChangeBytes -Offset "C564D8"  -Values "02"
        ChangeBytes -Offset "1069B6C" -Values "2841000301014022A4E802C2A4F902CE00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    }

    if (IsChecked $Redux.Gameplay.ZoraPhysics)            { PatchBytes  -Offset "65D000"  -Patch "zora_physics_fix.bin"                             }
    if (IsChecked $Redux.Gameplay.DistantZTargeting)      { ChangeBytes -Offset "B4E924"  -Values "00000000"                                        }
    if (IsChecked $Redux.Gameplay.ManualJump)             { ChangeBytes -Offset "CB4008"  -Values "04C1"; ChangeBytes -Offset "CB402B" -Values "01" }
    if (IsChecked $Redux.Gameplay.FDSpinAttack)           { ChangeBytes -Offset "CAD780"  -Values "2400"                                            }
    if (IsChecked $Redux.Gameplay.FrontflipJump)          { ChangeBytes -Offset "1098E4D" -Values "2334D0"                                          }
    if (IsChecked $Redux.Gameplay.NoShieldRecoil)         { ChangeBytes -Offset "CAEDD0"  -Values "2400"                                            }
    if (IsChecked $Redux.Gameplay.SunSong)                { ChangeBytes -Offset "C5CE71"  -Values "02"                                              }
    if (IsChecked $Redux.Gameplay.SariaSong)              { ChangeBytes -Offset "C5CE72"  -Values "08"                                              }
    if (IsChecked $Redux.Gameplay.HookshotAnything)       { ChangeBytes -Offset "D3BA30"  -Values "00000000"                                        }
    if (IsChecked $Redux.Gameplay.NoMagicArrowCooldown)   { ChangeBytes -Offset "BAC3CD"  -Values "69"                                              }

    

    # RESTORE #

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

    if (IsChecked $Redux.Restore.RomaniSign)          { PatchBytes  -Offset "26A58C0" -Texture -Patch "romani_sign.bin" }
    if (IsChecked $Redux.Restore.Title)               { ChangeBytes -Offset "DE0C2E"  -Values "FF C8 36 10 98 00" }
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

    if (IsDefault $Redux.UI.AButtonScale -Not) {
        ChangeBytes -Offset @("BAF2D3", "BAF12F", "BAF383", "BAF2EF", "BAF14B", "BAF39F") -Values               ( ([byte]$Redux.UI.AButtonScale.Text - $Redux.UI.AButtonScale.Max - 15) * -1)     -Subtract
        ChangeBytes -Offset @("BAF2E3", "BAF2D3", "BAF13F", "BAF12F", "BAF393", "BAF383") -Values ([Math]::Round( ([byte]$Redux.UI.AButtonScale.Text - $Redux.UI.AButtonScale.Max - 15) * -0.5) ) -Add
        ChangeBytes -Offset @("BAF2E7", "BAF2EF", "BAF143", "BAF14B", "BAF397", "BAF39F") -Values ([Math]::Round( ([byte]$Redux.UI.AButtonScale.Text - $Redux.UI.AButtonScale.Max - 15) * -0.5) ) -Add
    }

    if (IsDefault $Redux.UI.BButtonScale -Not) {
        ChangeBytes -Offset "C56034"              -Values (Get16Bit       ([byte]$Redux.UI.BButtonScale.Text))                                                               # B Button Size  
        ChangeBytes -Offset "C55F24"              -Values (GetButtonScale ([byte]$Redux.UI.BButtonScale.Text))                                                               # B Button Scale                            
        ChangeBytes -Offset @("C55F15", "C55F1D") -Values ([Math]::Round( ($Redux.UI.BButtonScale.Max      - [byte]$Redux.UI.BButtonScale.Text)          * 0.5)  ) -Add      # Correct B Button coords
        ChangeBytes -Offset "C5603C"              -Values (Get16Bit       ([byte]$Redux.UI.BButtonScale.Text + 1))                                                           # B Button Icon Size                         
        ChangeBytes -Offset "C55EFC"              -Values (GetButtonScale ([byte]$Redux.UI.BButtonScale.Text + 1))                                                           # B Button Icon Scale
        ChangeBytes -Offset "C55EF9"              -Values ([Math]::Round( ($Redux.UI.BButtonScale.Max      - [byte]$Redux.UI.BButtonScale.Text      + 1) * 6)    ) -Subtract # B Button Button Text Scale
        ChangeBytes -Offset @("C56045", "C5604D") -Values ([Math]::Round( ($Redux.UI.BButtonScale.Max      - [byte]$Redux.UI.BButtonScale.Text      + 1) * 0.5)  ) -Add      # Adjust B Button Ammo coords
        ChangeBytes -Offset "C55F07"              -Values ([Math]::Round( ($Redux.UI.BButtonScale.Max      - [byte]$Redux.UI.BButtonScale.Text      + 1) * 0.75) ) -Add      # Adjust B Button Text X-coord
        ChangeBytes -Offset "C55F0B"              -Values ([Math]::Round( ($Redux.UI.BButtonScale.Max      - [byte]$Redux.UI.BButtonScale.Text      + 1) * 0.25) ) -Add      # Adjust B Button Text Y-coord
    }

    if (IsDefault $Redux.UI.CLeftButtonScale -Not) {
        ChangeBytes -Offset "C56036"              -Values (Get16Bit       ([byte]$Redux.UI.CLeftButtonScale.Text))                                                           # C-Left Button Size  
        ChangeBytes -Offset "C55F26"              -Values (GetButtonScale ([byte]$Redux.UI.CLeftButtonScale.Text))                                                           # C-Left Button Scale
        ChangeBytes -Offset @("C55F17", "C55F1F") -Values ([Math]::Round( ($Redux.UI.CLeftButtonScale.Max  - [byte]$Redux.UI.CLeftButtonScale.Text)      * 0.5)  ) -Add      # Adjust C-Left Button coords
        ChangeBytes -Offset "C5603E"              -Values (Get16Bit       ([byte]$Redux.UI.CLeftButtonScale.Text - 3))                                                       # C-Left Button Icon Size
        ChangeBytes -Offset "C55EFE"              -Values (GetButtonScale ([byte]$Redux.UI.CLeftButtonScale.Text - 3))                                                       # C-Left Button Icon Scale   
        ChangeBytes -Offset @("C56047", "C5604F") -Values ([Math]::Round( ($Redux.UI.CLeftButtonScale.Max  - [byte]$Redux.UI.CLeftButtonScale.Text  - 3) * 0.5)  ) -Add      # Adjust C-Left Button Ammo coords
    }

    if (IsDefault $Redux.UI.CDownButtonScale -Not) {
        ChangeBytes -Offset "C56038"              -Values (Get16Bit       ([byte]$Redux.UI.CDownButtonScale.Text))                                                           # C-Down Button Size  
        ChangeBytes -Offset "C55F28"              -Values (GetButtonScale ([byte]$Redux.UI.CDownButtonScale.Text))                                                           # C-Down Button Scale
        ChangeBytes -Offset @("C55F19", "C55F21") -Values ([Math]::Round( ($Redux.UI.CDownButtonScale.Max  - [byte]$Redux.UI.CDownButtonScale.Text)      * 0.5)  ) -Add      # Adjust C-Down Button coords
        ChangeBytes -Offset "C56040"              -Values (Get16Bit       ([byte]$Redux.UI.CDownButtonScale.Text - 3))                                                       # C-Down Button Icon Size
        ChangeBytes -Offset "C55F00"              -Values (GetButtonScale ([byte]$Redux.UI.CDownButtonScale.Text - 3))                                                       # C-Down Button Icon Scale   
        ChangeBytes -Offset @("C56049", "C56051") -Values ([Math]::Round( ($Redux.UI.CDownButtonScale.Max  - [byte]$Redux.UI.CDownButtonScale.Text  - 3) * 0.5)  ) -Add      # Adjust C-Down Button Ammo coords
    }

    if (IsDefault $Redux.UI.CRightButtonScale -Not) {
        ChangeBytes -Offset "C5603A"              -Values (Get16Bit       ([byte]$Redux.UI.CRightButtonScale.Text))                                                          # C-Right Button Size  
        ChangeBytes -Offset "C55F2A"              -Values (GetButtonScale ([byte]$Redux.UI.CRightButtonScale.Text))                                                          # C-Right Button Scale
        ChangeBytes -Offset @("C55F1B", "C55F23") -Values ([Math]::Round( ($Redux.UI.CRightButtonScale.Max - [byte]$Redux.UI.CRightButtonScale.Text)     * 0.5)  ) -Add      # Adjust C-Right Button coords
        ChangeBytes -Offset "C56042"              -Values (Get16Bit       ([byte]$Redux.UI.CRightButtonScale.Text - 3))                                                      # C-Right Button Icon Size
        ChangeBytes -Offset "C55F02"              -Values (GetButtonScale ([byte]$Redux.UI.CRightButtonScale.Text - 3))                                                      # C-Right Button Icon Scale   
        ChangeBytes -Offset @("C5604B", "C56053") -Values ([Math]::Round( ($Redux.UI.CRightButtonScale.Max - [byte]$Redux.UI.CRightButtonScale.Text - 3) * 0.5)  ) -Add      # Adjust C-Right Button Ammo coords
    }

    if (IsDefault -Elem $Redux.UI.Layout -Not) {
        if (IsIndex -Elem $Redux.UI.Layout -Text "Ocarina of Time") {
            ChangeBytes -Offset @("BAF2E3", "BAF2D3", "BAF13F", "BAF12F", "BAF393", "BAF383") -Values 4 -Subtract; ChangeBytes -Offset @("BAF2E7", "BAF2EF", "BAF143", "BAF14B", "BAF397", "BAF39F") -Values 14 -Subtract # A Button
            ChangeBytes -Offset @("C55F15", "C55F07", "C56045")                               -Values 7 -Subtract                                                                                                         # B Button
        }

        elseif (IsIndex -Elem $Redux.UI.Layout -Text "Nintendo") {
            ChangeBytes -Offset @("BAF2E3", "BAF2D3", "BAF13F", "BAF12F", "BAF393", "BAF383") -Values (70 - 4)  -Add;      ChangeBytes -Offset @("BAF2E7", "BAF2EF", "BAF143", "BAF14B", "BAF397", "BAF39F") -Values (23 - 14) -Add      # A Button
            ChangeBytes -Offset @("C55F15", "C55F07", "C56045")                               -Values (80 - 7)  -Add;      ChangeBytes -Offset @("C55F1D", "C55F0B", "C5604D")                               -Values 45        -Add      # B Button
            ChangeBytes -Offset @("C55F17", "C56047")                                         -Values 14        -Add;                                                                                                                    # C-Left Button
            ChangeBytes -Offset @("C55F19", "C56049")                                         -Values 30        -Add;      ChangeBytes -Offset @("C55F21", "C56051")                                         -Values 20        -Subtract # C-Down Button
            ChangeBytes -Offset @("C55F1B", "C5604B")                                         -Values 54        -Subtract; ChangeBytes -Offset @("C55F23", "C56053")                                         -Values 20        -Add      # C-Right Button
            ChangeBytes -Offset @("BADD27", "BADD2B") -Values "02" -Add; ChangeBytes -Offset @("BADD36", "BADD3A") -Values "10" -Add; ChangeBytes -Offset @("BADD37", "BADD3B") -Values "2D" -Subtract # C-Up
            ChangeBytes -Offset "BADB0B"              -Values  10  -Add;                                                              ChangeBytes -Offset "BADB13"              -Values  10  -Subtract # C-Up
        }

        elseif (IsIndex -Elem $Redux.UI.Layout -Text "Modern") {
            ChangeBytes -Offset @("BAF2E3", "BAF2D3", "BAF13F", "BAF12F", "BAF393", "BAF383") -Values (46  - 4) -Add;      ChangeBytes -Offset @("BAF2E7", "BAF2EF", "BAF143", "BAF14B", "BAF397", "BAF39F") -Values (45 - 14) -Add      # A Button
            ChangeBytes -Offset @("C55F15", "C55F07", "C56045")                               -Values (104 - 7) -Add;      ChangeBytes -Offset @("C55F1D", "C55F0B", "C5604D")                               -Values 23        -Add      # B Button
            ChangeBytes -Offset @("C55F17", "C56047")                                         -Values 10        -Subtract; ChangeBytes -Offset @("C55F1F", "C5604F")                                         -Values 20        -Add      # C-Left Button
            ChangeBytes -Offset @("C55F19", "C56049")                                         -Values 30        -Add;      ChangeBytes -Offset @("C55F21", "C56051")                                         -Values 20        -Subtract # C-Down Button
            ChangeBytes -Offset @("C55F1B", "C5604B")                                         -Values 30        -Subtract                                                                                                                # C-Right Button
            ChangeBytes -Offset @("BADD27", "BADD2B") -Values "02" -Add; ChangeBytes -Offset @("BADD36", "BADD3A") -Values "10" -Add; ChangeBytes -Offset @("BADD37", "BADD3B") -Values "2D" -Subtract # C-Up
            ChangeBytes -Offset "BADB0B"              -Values  10  -Add;                                                              ChangeBytes -Offset "BADB13"              -Values  10  -Subtract # C-Up
        }

        elseif (IsIndex -Elem $Redux.UI.Layout -Text "GameCube (Original)") {
            ChangeBytes -Offset @("BAF2E3", "BAF2D3", "BAF13F", "BAF12F", "BAF393", "BAF383") -Values (55 - 4)  -Add;      ChangeBytes -Offset @("BAF2E7", "BAF2EF", "BAF143", "BAF14B", "BAF397", "BAF39F") -Values (20 - 14) -Add      # A Button
            ChangeBytes -Offset @("C55F15", "C55F07", "C56045")                               -Values (65 - 7)  -Add;      ChangeBytes -Offset @("C55F1D", "C55F0B", "C5604D")                               -Values 40        -Add      # B Button
            ChangeBytes -Offset @("C55F17", "C56047")                                         -Values 24        -Add;      ChangeBytes -Offset @("C55F1F", "C5604F")                                         -Values 10        -Subtract # C-Left Button
            ChangeBytes -Offset @("C55F19", "C56049")                                         -Values 30        -Add;      ChangeBytes -Offset @("C55F21", "C56051")                                         -Values 20        -Subtract # C-Down Button
            ChangeBytes -Offset @("C55F1B", "C5604B")                                         -Values 11        -Add;      ChangeBytes -Offset @("C55F23", "C56053")                                         -Values 20        -Add      # C-Right Button
            ChangeBytes -Offset @("BADD27", "BADD2B") -Values 5  -Subtract # C-Up
            ChangeBytes -Offset "BADB0B"              -Values 20 -Subtract # C-Up
        }

        elseif (IsIndex -Elem $Redux.UI.Layout -Text "GameCube (Modern)") {
            ChangeBytes -Offset @("BAF2E3", "BAF2D3", "BAF13F", "BAF12F", "BAF393", "BAF383") -Values (55 - 4)  -Add;      ChangeBytes -Offset @("BAF2E7", "BAF2EF", "BAF143", "BAF14B", "BAF397", "BAF39F") -Values (20 - 14) -Add      # A Button
            ChangeBytes -Offset @("C55F15", "C55F07", "C56045")                               -Values (65 - 7)  -Add;      ChangeBytes -Offset @("C55F1D", "C55F0B", "C5604D")                               -Values 40        -Add      # B Button
            ChangeBytes -Offset @("C55F17", "C56047")                                         -Values 55        -Add;      ChangeBytes -Offset @("C55F1F", "C5604F")                                         -Values 25        -Add      # C-Left Button
            ChangeBytes -Offset @("C55F19", "C56049")                                         -Values 30        -Add;      ChangeBytes -Offset @("C55F21", "C56051")                                         -Values 20        -Subtract # C-Down Button
            ChangeBytes -Offset @("C55F1B", "C5604B")                                         -Values 20        -Subtract; ChangeBytes -Offset @("C55F23", "C56053")                                         -Values 10        -Subtract # C-Right Button
            ChangeBytes -Offset @("BADD27", "BADD2B") -Values 5  -Subtract # C-Up
            ChangeBytes -Offset "BADB0B"              -Values 20 -Subtract # C-Up
        }
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

    if (IsDefault $Redux.UI.ButtonStyle -Not)   { PatchBytes -Offset "1EBDF60" -Shared -Patch ("Buttons\" + $Redux.UI.ButtonStyle.Text.replace(" (default)", "") + ".bin") }
    if (IsChecked $Redux.UI.DungeonKeys)        { PatchBytes -Offset "1EBDD60" -Shared -Patch "HUD\Keys\Ocarina of Time.bin"   }
    if (IsDefault $Redux.UI.Rupees -Not)        { PatchBytes -Offset "1EBDE60" -Shared -Patch ("HUD\Rupees\" + $Redux.UI.Rupees.Text.replace(" (default)", "") + ".bin") }
    if (IsDefault $Redux.UI.Hearts -Not)        { PatchBytes -Offset "1EBD000" -Shared -Patch ("HUD\Hearts\" + $Redux.UI.Hearts.Text.replace(" (default)", "") + ".bin") }
    if (IsDefault $Redux.UI.Magic  -Not)        { PatchBytes -Offset "1EC1DA0" -Shared -Patch ("HUD\Magic\"  + $Redux.UI.Magic.Text.replace(" (default)", "")  + ".bin") }
    if (IsChecked $Redux.UI.BlackBars)          { ChangeBytes -Offset "BF72A4" -Values "00 00 00 00" }
    if (IsChecked $Redux.UI.HUD)                { PatchBytes -Offset "1EBD000" -Shared -Patch "HUD\Hearts\Ocarina of Time.bin"; PatchBytes -Offset "1EC1DA0" -Shared -Patch "HUD\Magic\Ocarina of Time.bin" }
    


    # EFFECTS #

    if (IsChecked $Redux.Graphics.MotionBlur)         { ChangeBytes -Offset "BFB9A0"  -Values "03 E0 00 08 00 00 00 00 00" }
    if (IsChecked $Redux.Graphics.FlashbackOverlay)   { ChangeBytes -Offset "BFEB8C"  -Values "24 0F 00 00"                }



    # HIDE (Custom edits added by Marcelo - Hide Buttons) #

    if (IsChecked $Redux.Hide.AButton) { # A Button
        ChangeBytes -Offset "BA55F8" -Values "00 00 00 00"; ChangeBytes -Offset "BA5608" -Values "00 00 00 00"; ChangeBytes -Offset "BA5A04" -Values "00 00 00 00"; ChangeBytes -Offset "BA5DA8" -Values "00 00 00 00"
        ChangeBytes -Offset "BA5FE8" -Values "00 00 00 00"; ChangeBytes -Offset "BA60A0" -Values "00 00 00 00"; ChangeBytes -Offset "BA64F0" -Values "00 00 00 00"
    }

    if (IsChecked $Redux.Hide.BButton) { # B Button
        ChangeBytes -Offset "BA5528" -Values "00 00 00 00"; ChangeBytes -Offset "BA5544" -Values "00 00 00 00"; ChangeBytes -Offset "BA5CC4" -Values "00 00 00 00"; ChangeBytes -Offset "BA5DE8" -Values "00 00 00 00"
        ChangeBytes -Offset "BA5FD8" -Values "00 00 00 00"; ChangeBytes -Offset "BA60B0" -Values "00 00 00 00"; ChangeBytes -Offset "BA6500" -Values "00 00 00 00"
    }

    if (IsChecked $Redux.Hide.CButtons) {
        ChangeBytes -Offset "BA5568" -Values "00 00 00 00"; ChangeBytes -Offset "BA5578" -Values "00 00 00 00"; ChangeBytes -Offset "BA5FF8" -Values "00 00 00 00"; ChangeBytes -Offset "BA60C0" -Values "00 00 00 00" # C-Left
        ChangeBytes -Offset "BA5598" -Values "00 00 00 00"; ChangeBytes -Offset "BA55A8" -Values "00 00 00 00"; ChangeBytes -Offset "BA6008" -Values "00 00 00 00"; ChangeBytes -Offset "BA60D0" -Values "00 00 00 00" # C-Down
        ChangeBytes -Offset "BA55C8" -Values "00 00 00 00"; ChangeBytes -Offset "BA55D8" -Values "00 00 00 00"; ChangeBytes -Offset "BA6018" -Values "00 00 00 00"; ChangeBytes -Offset "BA60E4" -Values "00 00 00 00" # C-Right
    }

    if (IsChecked $Redux.Hide.Hearts) { # Health
        ChangeBytes -Offset "BA5B28" -Values "00 00 00 00"; ChangeBytes -Offset "BA5BFC" -Values "00 00 00 00"; ChangeBytes -Offset "BA5A14" -Values "00 00 00 00"
        ChangeBytes -Offset "BA603C" -Values "00 00 00 00"; ChangeBytes -Offset "BA6530" -Values "00 00 00 00"; ChangeBytes -Offset "BB787C" -Values "00 00 00 00"
    }

    if (IsChecked $Redux.Hide.Magic) { # Magic Meter & Rupees
        ChangeBytes -Offset "BA5A28" -Values "00 00 00 00"; ChangeBytes -Offset "BA5B3C" -Values "00 00 00 00"; ChangeBytes -Offset "BA5BE8" -Values "00 00 00 00"
        ChangeBytes -Offset "BA6028" -Values "00 00 00 00"; ChangeBytes -Offset "BA6520" -Values "00 00 00 00"; ChangeBytes -Offset "BB788C" -Values "00 00 00 00"
    }

    if (IsChecked $Redux.Hide.Clock) { # Clock
		ChangeBytes -Offset "BAFD5C" -Values "00 00 00 00"; ChangeBytes -Offset "BAFC48" -Values "00 00 00 00"; ChangeBytes -Offset "BAFDA8" -Values "00 00 00 00"
		ChangeBytes -Offset "BAFD00" -Values "00 00 00 00"; ChangeBytes -Offset "BAFD98" -Values "00 00 00 00"; ChangeBytes -Offset "C5606D" -Values "00"
    }

    if (IsChecked $Redux.Hide.CountdownTimer)   { ChangeBytes -Offset "BB169A" -Values "01 FF";       ChangeBytes -Offset "C56180" -Values "01 FF 01 FF 01 FF 01 FF 01 FF 01 FF 01 FF 01 FF" } # Disable Countdown timer background / Disable Countdown timer
    if (IsChecked $Redux.Hide.AreaTitle)        { ChangeBytes -Offset "B80A64" -Values "10 00 01 9E"; ChangeBytes -Offset "B842C0" -Values "10 00 00 04"                                     } # Disable Area Title Cards
    if (IsChecked $Redux.Hide.Credits)          { PatchBytes  -Offset "B3B000" -Patch "Message\credits.bin" }



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

    PatchReplaceMusic -BankPointerTableStart "C77A60" -BankPointerTableEnd "C77B70" -PointerTableStart "C77B80" -PointerTableEnd "C78380" -SeqStart "46AF0" -SeqEnd "97F70"
    PatchMuteMusic -SequenceTable "C77B80" -Sequence "46AF0" -Length 127

    if (IsIndex -Elem $Redux.Music.FileSelect -Text $Redux.Music.FileSelect.default -Not) {
        foreach ($track in $Files.json.music.tracks) {
            if ($Redux.Music.FileSelect.Text -eq $track.title) {
                ChangeBytes -Offset "C8E2AB" -Values $track.id
                break
            }
        }
    }



    # HERO MODE #

    if (IsIndex -Elem $Redux.Hero.MonsterHP -Index 3 -Not) { # Monsters
        if (IsIndex -Elem $Redux.Hero.MonsterHP)   { $multi = 0   }
        else                                       { [float]$multi = [float]$Redux.Hero.MiniBossHP.text.split('x')[0] }
        
        MultiplyBytes -Offset "D4E07F" -Factor $multi; MultiplyBytes -Offset "E0790F" -Factor $multi; MultiplyBytes -Offset "F94A00" -Factor $multi # ReDead / Gibdo, Stalchild, Poe
        MultiplyBytes -Offset "D2F07C" -Factor $multi; MultiplyBytes -Offset "D6CFB8" -Factor $multi; MultiplyBytes -Offset "F5B7FC" -Factor $multi # Deku Baba, Wilted Deku Baba, Dexihand
        MultiplyBytes -Offset "FC3A5F" -Factor $multi; MultiplyBytes -Offset "EDBA17" -Factor $multi; MultiplyBytes -Offset "E9BD87" -Factor $multi # Deep Python, Skullfish, Desbreko
        MultiplyBytes -Offset "D47754" -Factor $multi; MultiplyBytes -Offset "D76388" -Factor $multi; MultiplyBytes -Offset "D74167" -Factor $multi # Beamos, Like Like (Weak), Like Like (Strong)
        MultiplyBytes -Offset "D13750" -Factor $multi; MultiplyBytes -Offset "D1375C" -Factor $multi # Peahat, Peahat Larva
        MultiplyBytes -Offset "D55BDC" -Factor $multi; MultiplyBytes -Offset "D55C08" -Factor $multi # Skullwalltula, Golden Skullwalltula
        MultiplyBytes -Offset "CF3514" -Factor $multi; MultiplyBytes -Offset "CF0A4B" -Factor $multi # Dodongo (Small / Big)
        MultiplyBytes -Offset "D10D3C" -Factor $multi; MultiplyBytes -Offset "D0DBDB" -Factor $multi # Red Tektite, Blue Tektite
        MultiplyBytes -Offset "CF05CC" -Factor $multi; MultiplyBytes -Offset "D4DA9C" -Factor $multi # Wallmaster, Floormaster
        MultiplyBytes -Offset "E0336B" -Factor $multi; MultiplyBytes -Offset "E07028" -Factor $multi # Gray Wolfos / White Wolfos
        MultiplyBytes -Offset "D3D9DC" -Factor $multi; MultiplyBytes -Offset "D3AFBC" -Factor $multi # Blue Bubble, Red Bubble
        MultiplyBytes -Offset "D5E0E3" -Factor $multi; MultiplyBytes -Offset "F3E82C" -Factor $multi # Shell Blade, Snapper
        MultiplyBytes -Offset "D3914C" -Factor $multi; MultiplyBytes -Offset "CEACD8" -Factor $multi # Mad Scrub, Octorok
        MultiplyBytes -Offset "F7ED78" -Factor $multi; MultiplyBytes -Offset "EC1F2C" -Factor $multi # Eeno, Real Bombchu
        MultiplyBytes -Offset "EB922C" -Factor $multi; MultiplyBytes -Offset "E9B69C" -Factor $multi # White Boe, Black Boe, Chuchu (alt: E9B66E)
        MultiplyBytes -Offset "FE1AA3" -Factor $multi; MultiplyBytes -Offset "FE1ABF" -Factor $multi # Leever (Green), Leever (Purple)
        
      # MultiplyBytes -Offset "" -Factor $multi # Ghost                               (HP: ??)    ->  (Length: ) (ovl_En_??)
      # MultiplyBytes -Offset "" -Factor $multi # Garo                                (HP: ??)   E20590 -> E24200 (Length: 3C70) (ovl_En_Jso)
      # MultiplyBytes -Offset "" -Factor $multi # Giant Bee                           (HP: ??)   FBF8B0 -> FC0470 (Length: 0BC0) (ovl_En_Bee)
      # MultiplyBytes -Offset "" -Factor $multi # Nejiron                             (HP: ??)   EA4BD0 -> EA6030 (Length: 1460) (ovl_En_Baguo)
      # MultiplyBytes -Offset "" -Factor $multi # Dragonfly                           (HP: ??)   E18FF0 -> E1BE80 (Length: 2E90) (ovl_En_Grasshopper)
      # MultiplyBytes -Offset "" -Factor $multi # Death Armos                         (HP: ??)   D26B30 -> D28AD0 (Length: 1FA0) (ovl_En_Famos)
      # MultiplyBytes -Offset "" -Factor $multi # Hiploop                             (HP: ??)   F831B0 -> F86E00 (Length: 3C50) (ovl_En_Pp)
      # MultiplyBytes -Offset "" -Factor $multi # Bio Deku Baba                       (HP: ??)   E596F0 -> E5D320 (Length: 3C30) (ovl_Boss_05)

      # MultiplyBytes -Offset "DA556F" -Factor $multi; MultiplyBytes -Offset "DA6E67" -Factor $multi # Freezard
      # MultiplyBytes -Offset "D21870" -Factor $multi; MultiplyBytes -Offset "CF56BC" -Factor $multi # Skulltula, Keese
      # MultiplyBytes -Offset "E0EE24" -Factor $multi; MultiplyBytes -Offset "EAE53C" -Factor $multi # Guay, Bad Bat
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
        MultiplyBytes -Offset "E50D33" -Factor $multi; MultiplyBytes -Offset "E54683" -Factor $multi # Gyorg
        MultiplyBytes -Offset "E4A607" -Factor $multi # Twinmold
        MultiplyBytes -Offset "E6FA2F" -Factor $multi # Four Remains
    }

    if (IsIndex -Elem $Redux.Hero.Recovery -Not) {
        ChangeBytes -Offset "BABE7F" -Values "09 04" -Interval 16
        if       ( (IsText -Elem $Redux.Hero.Recovery -Compare "0x Recovery") -or (IsText -Elem $Redux.Hero.ItemDrops -Compare "No Hearts") )   { ChangeBytes -Offset "BABEA2" -Values "29 40"; ChangeBytes -Offset "BABEA5" -Values "05 29 43" }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Compare "1/2x Recovery")                                                                 { ChangeBytes -Offset "BABEA2" -Values "28 40"; ChangeBytes -Offset "BABEA5" -Values "05 28 43" }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Compare "1/4x Recovery")                                                                 { ChangeBytes -Offset "BABEA2" -Values "28 80"; ChangeBytes -Offset "BABEA5" -Values "05 28 83" }
    }

    if     ( (IsText -Elem $Redux.Hero.Damage -Compare "1x Damage") -and ($GameType.title -like    "*Master Quest*") )   { ChangeBytes -Offset "CADEC2" -Values "2C 03" }
    elseif ( (IsText -Elem $Redux.Hero.Damage -Compare "2x Damage") -and ($GameType.title -notlike "*Master Quest*") )   { ChangeBytes -Offset "CADEC2" -Values "2B C3" }
    elseif   (IsText -Elem $Redux.Hero.Damage -Compare "4x Damage")                                                      { ChangeBytes -Offset "CADEC2" -Values "2B 83" }
    elseif   (IsText -Elem $Redux.Hero.Damage -Compare "8x Damage")                                                      { ChangeBytes -Offset "CADEC2" -Values "2B 43" }
    elseif   (IsText -Elem $Redux.Hero.Damage -Compare "OHKO Mode")                                                      { ChangeBytes -Offset "CADEC2" -Values "2A 03" }

    if     (IsText -Elem $Redux.Hero.MagicUsage -Compare "2x Magic Usage")   { ChangeBytes -Offset "BAC306" -Values "2C 40" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "4x Magic Usage")   { ChangeBytes -Offset "BAC306" -Values "2C 80" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "8x Magic Usage")   { ChangeBytes -Offset "BAC306" -Values "2C C0" }
    if     (IsText -Elem $Redux.Hero.MagicUsage -Compare "2x Item Usage")    { ChangeBytes -Offset "BABF5E" -Values "2C 40" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "4x Item Usage")    { ChangeBytes -Offset "BABF5E" -Values "2C 80" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "8x Item Usage")    { ChangeBytes -Offset "BABF5E" -Values "2C C0" }

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
            elseif ($Redux.Hero.ClockSpeed.SelectedIndex -eq 6) { ChangeBytes -Offset "BB005E" -Values "FF EC"; ChangeBytes -Offset "BC668F" -Values "1E"; ChangeBytes -Offset "BEDB8E" -Values "FF EC" }
    }

    if (IsText -Elem $Redux.Hero.ItemDrops -Compare "Nothing") {
        $Values = @()
        for ($i=0; $i -lt 80; $i++) { $Values += 0 }
        ChangeBytes -Offset "C44400" -Values $Values
    }
    elseif (IsText -Elem $Redux.Hero.ItemDrops -Compare "No Hearts")     { ChangeBytes -Offset "B3DC54" -Values "50" }
    elseif (IsText -Elem $Redux.Hero.ItemDrops -Compare "Only Rupees")   { PatchBytes  -Offset "C444B9" -Patch "only_rupee_drops.bin" }

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

    if (IsChecked $Redux.Hero.PermanentKeese)       { ChangeBytes -Offset "CF3B58" -Values "0000000000000000"; ChangeBytes -Offset "CF3B60" -Values "000000000000000000000000" }
    if (IsChecked $Redux.Hero.FasterIronKnuckles)   { ChangeBytes -Offset "D9CEEC" -Values "14400004";         ChangeBytes -Offset "D9CEFC" -Values "10400003"                 }
    if (IsChecked $Redux.Hero.LargeIronKnuckles)    { ChangeBytes -Offset "D9F21F" -Values "1D";               ChangeBytes -Offset "D9F21A" -Values "1C"                       }



    # MAGIC #

    if (IsDefault $Redux.Magic.FireArrow  -Not)   { ChangeBytes -Offset "CD7428" -Values (Get8Bit $Redux.Magic.FireArrow.Text)  }
    if (IsDefault $Redux.Magic.IceArrow   -Not)   { ChangeBytes -Offset "CD7429" -Values (Get8Bit $Redux.Magic.IceArrow.Text)   }
    if (IsDefault $Redux.Magic.LightArrow -Not)   { ChangeBytes -Offset "CD742A" -Values (Get8Bit $Redux.Magic.LightArrow.Text) }
    if (IsDefault $Redux.Magic.DekuBubble -Not)   { ChangeBytes -Offset "CD742B" -Values (Get8Bit $Redux.Magic.DekuBubble.Text) }



    # EASY MODE #

    if     (IsIndex -Elem $Redux.EasyMode.KeepBottles -Index 2)   { ChangeBytes -Offset "BDA5AB"  -Values "17" }
    elseif (IsIndex -Elem $Redux.EasyMode.KeepBottles -Index 3)   { ChangeBytes -Offset "BDA5AB"  -Values "27" }

    if (IsChecked $Redux.EasyMode.NoBlueBubbleRespawn)   { ChangeBytes -Offset "D3CEC0"  -Values "57 20 00 04"                                                      }
    if (IsChecked $Redux.EasyMode.NoTakkuriSteal)        { ChangeBytes -Offset "1075B88" -Values "10 00 00 16"; ChangeBytes -Offset "1075BE4" -Values "10 00 00 46" }
    if (IsChecked $Redux.EasyMode.NoShieldSteal)         { ChangeBytes -Offset "D7475C"  -Values "10 00 00 08"                                                      }
    if (IsChecked $Redux.EasyMode.KeepAmmo)              { ChangeBytes -Offset "BDA560"  -Values "10 00 00 0D"                                                      }



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

    if (IsSet $Redux.Colors.SetFairy) { # Colors for Tatl option
        if ( (IsDefaultColor -Elem $Redux.Colors.SetFairy[0] -Not) -or (IsDefaultColor -Elem $Redux.Colors.SetFairy[1] -Not) ) { # Idle
            ChangeBytes -Offset "C451D4" -Values @($Redux.Colors.SetFairy[0].Color.R, $Redux.Colors.SetFairy[0].Color.G, $Redux.Colors.SetFairy[0].Color.B, 255, $Redux.Colors.SetFairy[1].Color.R, $Redux.Colors.SetFairy[1].Color.G, $Redux.Colors.SetFairy[1].Color.B, 0)
			
            if (IsIndex -Elem $Redux.Colors.Fairy -Text "Tael") { # Special case for Tael's cutscene values
				# For Tatl in cutscenes, her colors are Inner FAFFE6 and Outer DCA050
                $r_in  = ConvertFloatToHex 63;  $g_in  = ConvertFloatToHex 18; $b_in  = ConvertFloatToHex 93 # 3F125D
                $r_out = ConvertFloatToHex 250; $g_out = ConvertFloatToHex 40; $b_out = ConvertFloatToHex 10 # FA280A
            }
            else {
                $r_in  = ConvertFloatToHex $Redux.Colors.SetFairy[0].Color.r; $g_in  = ConvertFloatToHex $Redux.Colors.SetFairy[0].Color.g; $b_in  = ConvertFloatToHex $Redux.Colors.SetFairy[0].Color.b
                $r_out = ConvertFloatToHex $Redux.Colors.SetFairy[1].Color.r; $g_out = ConvertFloatToHex $Redux.Colors.SetFairy[1].Color.g; $b_out = ConvertFloatToHex $Redux.Colors.SetFairy[1].Color.b
            }
            ChangeBytes -Offset "F0D228" -Values ($r_in  + $g_in  + $b_in)
            ChangeBytes -Offset "F0D258" -Values ($r_out + $g_out + $b_out)
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

    if (IsSet $Redux.Colors.SetTael) { # Colors for Tael option
        if ( (IsDefaultColor -Elem $Redux.Colors.SetTael[0] -Not) -or (IsDefaultColor -Elem $Redux.Colors.SetTael[1] -Not) ) {
            if (IsIndex -Elem $Redux.Colors.Tael -Text "Tatl") {
                $r_in  = ConvertFloatToHex 250; $g_in  = ConvertFloatToHex 255; $b_in  = ConvertFloatToHex 230 # FAFFE6
                $r_out = ConvertFloatToHex 220; $g_out = ConvertFloatToHex 160; $b_out = ConvertFloatToHex 80  # DCA050
            }
            else {
                $r_in  = ConvertFloatToHex $Redux.Colors.SetTael[0].Color.r; $g_in  = ConvertFloatToHex $Redux.Colors.SetTael[0].Color.g; $b_in  = ConvertFloatToHex $Redux.Colors.SetTael[0].Color.b
                $r_out = ConvertFloatToHex $Redux.Colors.SetTael[1].Color.r; $g_out = ConvertFloatToHex $Redux.Colors.SetTael[1].Color.g; $b_out = ConvertFloatToHex $Redux.Colors.SetTael[1].Color.b
            }
            ChangeBytes -Offset "F0D238" -Values ($r_in  + $g_in  + $b_in)
            ChangeBytes -Offset "F0D268" -Values ($r_out + $g_out + $b_out)
        }
    }
    


    # AMMO CAPACITY SELECTION #

    if (IsChecked $Redux.Capacity.EnableAmmo) {
        ChangeBytes -Offset "C5834F" -Values @( (Get8Bit $Redux.Capacity.Quiver1.Text),     (Get8Bit $Redux.Capacity.Quiver2.Text),     (Get8Bit $Redux.Capacity.Quiver3.Text)     ) -Interval 2
        ChangeBytes -Offset "C58357" -Values @( (Get8Bit $Redux.Capacity.BombBag1.Text),    (Get8Bit $Redux.Capacity.BombBag2.Text),    (Get8Bit $Redux.Capacity.BombBag3.Text)    ) -Interval 2
        ChangeBytes -Offset "C5837F" -Values @( (Get8Bit $Redux.Capacity.DekuSticks1.Text), (Get8Bit $Redux.Capacity.DekuSticks1.Text), (Get8Bit $Redux.Capacity.DekuSticks1.Text) ) -Interval 2
        ChangeBytes -Offset "C58387" -Values @( (Get8Bit $Redux.Capacity.DekuNuts1.Text),   (Get8Bit $Redux.Capacity.DekuNuts1.Text),   (Get8Bit $Redux.Capacity.DekuNuts1.Text)   ) -Interval 2
    }



    # WALLET CAPACITY SELECTION #

    if (IsChecked $Redux.Capacity.EnableWallet) {
        $max = 3
        if ($Redux.Capacity.Wallet1.Text.Length -gt 3 -or $Redux.Capacity.Wallet2.Text.Length -gt 3 -or $Redux.Capacity.Wallet3.Text.Length -gt 3 -or $Redux.Capacity.Wallet4.Text.Length -gt 3) { $max = 4 }

        $wallet = Get16Bit ($Redux.Capacity.Wallet1.Text); ChangeBytes -Offset "C5836C" -Values @($wallet.Substring(0, 2), $wallet.Substring(2) )
        $wallet = Get16Bit ($Redux.Capacity.Wallet2.Text); ChangeBytes -Offset "C5836E" -Values @($wallet.Substring(0, 2), $wallet.Substring(2) )
        $wallet = Get16Bit ($Redux.Capacity.Wallet3.Text); ChangeBytes -Offset "C58370" -Values @($wallet.Substring(0, 2), $wallet.Substring(2) )
        $wallet = Get16Bit ($Redux.Capacity.Wallet4.Text); ChangeBytes -Offset "C58372" -Values @($wallet.Substring(0, 2), $wallet.Substring(2) )

        ChangeBytes -Offset "C5625D" -Values @( ($max - $Redux.Capacity.Wallet1.Text.Length), ($max - $Redux.Capacity.Wallet2.Text.Length), ($max - $Redux.Capacity.Wallet3.Text.Length), ($max - $Redux.Capacity.Wallet4.Text.Length) ) -Interval 2
        ChangeBytes -Offset "C56265" -Values @(         $Redux.Capacity.Wallet1.Text.Length,          $Redux.Capacity.Wallet2.Text.Length,          $Redux.Capacity.Wallet3.Text.Length,          $Redux.Capacity.Wallet4.Text.Length)   -Interval 2
    }



    # EQUIPMENT #

    if ( (IsChecked $Redux.Gameplay.RazorSword) -or (IsChecked $Redux.Features.GearSwap) ) {
        ChangeBytes -Offset "CBA496" -Values "00 00" # Prevent losing hits
        ChangeBytes -Offset "BDA6B7" -Values "01"    # Keep sword after Song of Time
    }

    if (IsChecked $Redux.Gameplay.UnsheathSword)       { ChangeBytes -Offset "CC2CE8"  -Values "28 42 00 05 14 40 00 05 00 00 10 25" }
    if (IsChecked $Redux.Gameplay.SwordBeamAttack)     { ChangeBytes -Offset "CD73F0"  -Values "00 00"; ChangeBytes -Offset "CD73F4" -Values "00 00" }
    if (IsChecked $Redux.Gameplay.FixEponaSword)       { ChangeBytes -Offset "BA885C"  -Values "24 18"; ChangeBytes -Offset "BA885F"  -Values "01" }



    # HITBOX #

    if (IsValue -Elem $Redux.Equipment.KokiriSword      -Not)   { ChangeBytes -Offset "C572BC" -Values (ConvertFloatToHex $Redux.Equipment.KokiriSword.Value)      }
    if (IsValue -Elem $Redux.Equipment.RazorSword       -Not)   { ChangeBytes -Offset "C572C0" -Values (ConvertFloatToHex $Redux.Equipment.RazorSword.Value)       }
    if (IsValue -Elem $Redux.Equipment.GildedSword      -Not)   { ChangeBytes -Offset "C572C4" -Values (ConvertFloatToHex $Redux.Equipment.GildedSword.Value)      }
    if (IsValue -Elem $Redux.Equipment.GreatFairysSword -Not)   { ChangeBytes -Offset "C572C8" -Values (ConvertFloatToHex $Redux.Equipment.GreatFairysSword.Value) }
    if (IsValue -Elem $Redux.Equipment.BlastMask        -Not)   { $val = (Get16Bit $Redux.Equipment.BlastMask.Value); ChangeBytes -Offset "CAA666" -Values @($val.Substring(0, 2), $val.Substring(2)) }
    if (IsValue -Elem $Redux.Equipment.ShieldRecoil     -Not)   { ChangeBytes -Offset "CAEDC6" -Values ((Get16Bit ($Redux.Equipment.ShieldRecoil.Value + 45000)) -split '(..)' -ne '') }



    # WEAPON DAMAGE #

    if (IsDefault $Redux.Attack.KokiriSlash        -Not)   { ChangeBytes -Offset   "CD751A"            -Values (Get8Bit $Redux.Attack.KokiriSlash.Text)        }
    if (IsDefault $Redux.Attack.KokiriJump         -Not)   { ChangeBytes -Offset   "CD751B"            -Values (Get8Bit $Redux.Attack.KokiriJump.Text)         }
    if (IsDefault $Redux.Attack.KokiriSpin         -Not)   { ChangeBytes -Offset   "D3135C"            -Values (Get8Bit $Redux.Attack.KokiriSpin.Text)         }
    if (IsDefault $Redux.Attack.KokiriGreatSpin    -Not)   { ChangeBytes -Offset   "D31360"            -Values (Get8Bit $Redux.Attack.KokiriGreatSpin.Text)    }
    if (IsDefault $Redux.Attack.RazorSlash         -Not)   { ChangeBytes -Offset   "CD7522"            -Values (Get8Bit $Redux.Attack.RazorSlash.Text)         }
    if (IsDefault $Redux.Attack.RazorJump          -Not)   { ChangeBytes -Offset   "CD7523"            -Values (Get8Bit $Redux.Attack.RazorJump.Text)          }
    if (IsDefault $Redux.Attack.RazorSpin          -Not)   { ChangeBytes -Offset   "D3135D"            -Values (Get8Bit $Redux.Attack.RazorSpin.Text)          }
    if (IsDefault $Redux.Attack.RazorGreatSpin     -Not)   { ChangeBytes -Offset   "D31361"            -Values (Get8Bit $Redux.Attack.RazorGreatSpin.Text)     }
    if (IsDefault $Redux.Attack.GildedSlash        -Not)   { ChangeBytes -Offset   "CD752A"            -Values (Get8Bit $Redux.Attack.GildedSlash.Text)        }
    if (IsDefault $Redux.Attack.GildedJump         -Not)   { ChangeBytes -Offset   "CD752B"            -Values (Get8Bit $Redux.Attack.GildedJump.Text)         }
    if (IsDefault $Redux.Attack.GildedSpin         -Not)   { ChangeBytes -Offset   "D3135E"            -Values (Get8Bit $Redux.Attack.GildedSpin.Text)         }
    if (IsDefault $Redux.Attack.GildedGreatSpin    -Not)   { ChangeBytes -Offset   "D31362"            -Values (Get8Bit $Redux.Attack.GildedGreatSpin.Text)    }
    if (IsDefault $Redux.Attack.TwoHandedSlash     -Not)   { ChangeBytes -Offset   "CD7532"            -Values (Get8Bit $Redux.Attack.TwoHandedSlash.Text)     }
    if (IsDefault $Redux.Attack.TwoHandedJump      -Not)   { ChangeBytes -Offset   "CD7533"            -Values (Get8Bit $Redux.Attack.TwoHandedJump.Text)      }
    if (IsDefault $Redux.Attack.TwoHandedSpin      -Not)   { ChangeBytes -Offset   "D3135F"            -Values (Get8Bit $Redux.Attack.TwoHandedSpin.Text)      }
    if (IsDefault $Redux.Attack.TwoHandedGreatSpin -Not)   { ChangeBytes -Offset   "D31363"            -Values (Get8Bit $Redux.Attack.TwoHandedGreatSpin.Text) }
    if (IsDefault $Redux.Attack.DekuStickSlash     -Not)   { ChangeBytes -Offset   "CD753A"            -Values (Get8Bit $Redux.Attack.DekuStickSlash.Text)     }
    if (IsDefault $Redux.Attack.DekuStickJump      -Not)   { ChangeBytes -Offset   "CD753B"            -Values (Get8Bit $Redux.Attack.DekuStickJump.Text)      }
    if (IsDefault $Redux.Attack.GoronPunch         -Not)   { ChangeBytes -Offset @("CD7510", "CD7511") -Values (Get8Bit $Redux.Attack.GoronPunch.Text)         }
    if (IsDefault $Redux.Attack.ZoraPunch          -Not)   { ChangeBytes -Offset   "CD7540"            -Values (Get8Bit $Redux.Attack.ZoraPunch.Text)          }
    if (IsDefault $Redux.Attack.ZoraJump           -Not)   { ChangeBytes -Offset   "CD7541"            -Values (Get8Bit $Redux.Attack.ZoraJump.Text)           }



    # SKIP #

    if (IsChecked $Redux.Skip.BossCutscenes) {
        ChangeBytes -Offset "E425EC" -Values "00000000"                                                                                                                # Odolwa
        ChangeBytes -Offset "F6A90C" -Values "00000000"                                                                                                                # Goht
        ChangeBytes -Offset "E50DF0" -Values "00000000"                                                                                                                # Gyorg
        ChangeBytes -Offset "E4A478" -Values "1000"                                                                                                                    # Twinmold
        ChangeBytes -Offset "E60288" -Values "00000000"; ChangeBytes -Offset "E60564"  -Values "00000000"                                                              # Majora
        ChangeBytes -Offset "E575A8" -Values "00000000"; ChangeBytes -Offset "101B9FC" -Values "00000000"                                                              # Wart
        ChangeBytes -Offset "E25924" -Values "8D08331C"; ChangeBytes -Offset "E25930"  -Values "000000001500"; ChangeBytes -Offset "E5D4C8" -Values "0000000000000000" # Igos Du Ikana
        ChangeBytes -Offset "D3F2BC" -Values "1000";     ChangeBytes -Offset "D3F3F4"  -Values "00000000";     ChangeBytes -Offset "D4438C" -Values "00000000"         # Gomess
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

    if (IsChecked $Redux.Text.YeetPrompt)   { PatchBytes  -Offset "AC0D80" -Shared -Patch "Action Prompts\throw.en.prompt"              }
    if (IsChecked $Redux.Text.Comma)        { ChangeBytes -Offset "ACC660" -Values "00 F3 00 00 00 00 00 00 4F 60 00 00 00 00 00 00 24" }

}



#==============================================================================================================================================================================================
function RevertReduxOptions() {
    
    if (IsRevert $Redux.Gameplay.FasterBlockPushing) {
        ChangeBytes -Offset "E93FD0" -Values "241900058DC71CCC25F80001A6180188860201882604018A2405038428410006"; ChangeBytes -Offset "FA1930" -Values "008038258FAE002424E40168240500648DC31CCCAFA7002024060001"; ChangeBytes -Offset "D8B3F4" -Values "AFA50004948E01603C0140004480200044813000"
        ChangeBytes -Offset "E94384" -Values "241900058DC31CCC25F80001A6180188860201882604018A2405038428410006"; ChangeBytes -Offset "E8FA0C" -Values "3C014060448160003C0180A2C432707C3C0180A2C4267080";         ChangeBytes -Offset "E90F34" -Values "45002E1446002E1845002E1C46002E20"
        ChangeBytes -Offset "FD59C8" -Values "4500076046000764450007684600076C450007A4460007A8450007AC460007B0"; ChangeBytes -Offset "FE4424" -Values "3C063ECC34C6CCCD2604016C0C03FC0F3C054000";                 ChangeBytes -Offset "FD5410" -Values "3C0180B7C43007943C0180B7C4240798"
        ChangeBytes -Offset "FD5454" -Values "3C0180B7C432079C3C0180B7C42607A0";                                 ChangeBytes -Offset "CC2418" -Values "C6280AD03C013F0044818000";                                 ChangeBytes -Offset "E16944" -Values "3C06401334C63333"
        ChangeBytes -Offset "E93FBC" -Values "00808025AFBF001C"; ChangeBytes -Offset "E94370" -Values "00808025AFBF001C"; ChangeBytes -Offset "FD5688" -Values "3C0180B7C42C07A4"; ChangeBytes -Offset "FD5A04" -Values "450009D8460009DC"
    }

    if (IsRevert $Redux.Gameplay.ElegySpeedup) {
        ChangeBytes -Offset "CC2AF4"  -Values "8FA3004C861800BE24190014";         ChangeBytes -Offset "CCFEF4"  -Values "0080302500A03825";         ChangeBytes -Offset "CCFF08"  -Values "2843005B"; ChangeBytes -Offset "CCFF3C" -Values "2401000A"; ChangeBytes -Offset "D1D610"  -Values "00022C0000052C03"
        ChangeBytes -Offset "D1D620"  -Values "24060008";                         ChangeBytes -Offset "EB60B0"  -Values "AFB0002000808025AFBF0024"; ChangeBytes -Offset "EB6214"  -Values "0C03F4AD"; ChangeBytes -Offset "EB6240" -Values "0C03C761"; ChangeBytes -Offset "1029228" -Values "3C0141A0448120008E0E015C8E020160E604007091"
        ChangeBytes -Offset "1029448" -Values "3C0142208E020160448120003C0F80BC"; ChangeBytes -Offset "102945C" -Values "E6040070";                 ChangeBytes -Offset "1029734" -Values "45000AF4"
    }

    if (IsRevert $Redux.Gameplay.CritWiggle) {
        ChangeBytes -Offset "B66B6C" -Values "8463F6A628610011"; ChangeBytes -Offset "B66B78" -Values "28610011"; ChangeBytes -Offset "B66BA8" -Values "100000208463F6A6"; ChangeBytes -Offset "B66C28" -Values "8463F6A628610011"; ChangeBytes -Offset "B66D10" -Values "8739F6A6000020252B210011"
    }

    if (IsRevert $Redux.Gameplay.UnderwaterOcarina)   { ChangeBytes -Offset "BA6E54" -Values "30CF00FF29E10012"         }
    if (IsRevert $Redux.Gameplay.ClimbAnything)       { ChangeBytes -Offset "CB7D40" -Values "8C422B0C0000402530490008" }
    
}



#==============================================================================================================================================================================================
function ByteReduxOptions() {
    
    $Symbols = SetJSONFile ($GameFiles.base + "\symbols.json")



    # WIDESCREEN #

    if (IsChecked $Redux.Graphics.Widescreen) {
        $offset = SearchBytes -Start $Symbols.PAYLOAD_START -End (AddToOffset -Hex $Symbols.PAYLOAD_START -Add "1000") -Values "3C 04 00 04"
        ChangeBytes -Offset $offset -Values "3C 04 00 06"
        ChangeBytes -Offset $Symbols.CFG_WS_ENABLED -Values "01"
    }



    # D-PAD #

    if     (IsChecked $Redux.DPad.Disable)       { ChangeBytes -Offset (AddToOffset $Symbols.DPAD_CONFIG -Add "18") -Values "00 00" }
    else {
      # if (IsChecked $Redux.DPad.DualSet)       { ChangeBytes -Offset $Symbols.CFG_DUAL_DPAD_ENABLED               -Values "01"    }
        if (IsChecked $Redux.DPad.Hide)          { ChangeBytes -Offset (AddToOffset $Symbols.DPAD_CONFIG -Add "18") -Values "01 00" }
        if (IsChecked $Redux.DPad.LayoutLeft)    { ChangeBytes -Offset (AddToOffset $Symbols.DPAD_CONFIG -Add "18") -Values "01 01" }
        if (IsChecked $Redux.DPad.LayoutRight)   { ChangeBytes -Offset (AddToOffset $Symbols.DPAD_CONFIG -Add "18") -Values "01 02" }
        ChangeBytes -Offset @("BACB4C", "BACB58", "BACB64") -Values "1000" # Lens of Truth
    }



    # GAMEPLAY #

    ChangeBytes -Offset (AddToOffset $Symbols.MISC_CONFIG -Add "08") -Values "97 E2 EA E7 0B 2B 24 A0 B0 52 B5 99 94 66 AC 25 98 39 08"

    if (IsChecked $Redux.Gameplay.FlowOfTime)     { ChangeBytes -Offset $Symbols.CFG_FLOW_OF_TIME_ENABLED  -Values "01" }
    if (IsChecked $Redux.Gameplay.InstantElegy)   { ChangeBytes -Offset $Symbols.CFG_INSTANT_ELEGY_ENABLED -Values "01" }



    # FEATURES #

    if (IsDefault $Redux.Features.OcarinaIcons -Not) {
        if ($Redux.Features.OcarinaIcons.selectedIndex -eq 1)   { PatchBytes -Offset "A4AAFC" -Length "9A0" -Texture -Pad -Patch "Icons\deku_pipes_icon.yaz0"          } # Hylian Loach, ID: 0x26
        else                                                    { PatchBytes -Offset "A4AAFC" -Length "9A0" -Texture -Pad -Patch "Icons\deku_pipes_original_icon.yaz0" }
        PatchBytes  -Offset "A2B2B4" -Length "230" -Texture -Pad -Patch "Icons\deku_pipes_text.yaz0"
        ChangeBytes -Offset "CD6E32" -Values "14"                                                     # Hylian Loach is now Ocarina

        PatchBytes  -Offset "A44BFC" -Length "A70" -Texture -Pad -Patch "Icons\goron_drums_icon.yaz0" # Blue Fire, ID: 0x1C
        PatchBytes  -Offset "A28204" -Length "270" -Texture -Pad -Patch "Icons\goron_drums_text.yaz0"
        ChangeBytes -Offset "CD6E28" -Values "14"                                                     # Blue Fire is now Ocarina
        ChangeBytes -Offset "A276D0" -Values "00 00 09 C0"                                            # Pointer Goron Drums text

        PatchBytes  -Offset "A4B49C" -Length "7C0" -Texture -Pad -Patch "Icons\zora_guitar_icon.yaz0" # Granny's Drink, ID: 0x27
        PatchBytes  -Offset "A2B4E4" -Length "260" -Texture -Pad -Patch "Icons\zora_guitar_text.yaz0"
        ChangeBytes -Offset "CD6E33" -Values "14"                                                     # Granny's Drink is now Ocarina
        ChangeBytes -Offset "A36D80" -Values "00 01 45 90"                                            # Pointer Zora Guitar text box icon
        
        ChangeBytes -Offset $Symbols.CFG_OCARINA_ICONS_ENABLED -Values "01"
    }

    if (IsChecked $Redux.Features.RupeeDrain)        { ChangeBytes -Offset $Symbols.CFG_RUPEE_DRAIN                          -Values (Get8Bit $Redux.Features.RupeeDrain.Text) }
    if (IsChecked $Redux.Features.FPS)               { ChangeBytes -Offset $Symbols.CFG_FPS_ENABLED                          -Values "01"                                      }
    if (IsChecked $Redux.Features.HealthBar)         { ChangeBytes -Offset (AddToOffset -Hex $Symbols.MISC_CONFIG -Add "1A") -Values "10" -Add                                 }
    if (IsChecked $Redux.Features.HUDToggle)         { ChangeBytes -Offset $Symbols.CFG_HIDE_HUD_ENABLED                     -Values "01"                                      }
    if (IsChecked $Redux.Features.ItemsUnequip)      { ChangeBytes -Offset $Symbols.CFG_UNEQUIP_ENABLED                      -Values "01"                                      }
    if (IsChecked $Redux.Features.ItemsOnB)          { ChangeBytes -Offset $Symbols.CFG_B_BUTTON_ITEM_ENABLED                -Values "01"                                      }
    if (IsChecked $Redux.Features.GearSwap)          { ChangeBytes -Offset $Symbols.CFG_SWAP_ENABLED                         -Values "01"                                      }
    if (IsChecked $Redux.Features.SkipGuard)         { ChangeBytes -Offset $Symbols.CFG_SKIP_GUARD_ENABLED                   -Values "01"                                      }
    


    # CHEATS #

    if (IsChecked $Redux.Cheats.ClimbAnything)     { ChangeBytes -Offset "CB8810" -Values "1000"; ChangeBytes -Offset "CC69E4" -Values "00000000" }
    if (IsChecked $Redux.Cheats.InventoryEditor)   { ChangeBytes -Offset $Symbols.CFG_INVENTORY_EDITOR_ENABLED -Values "01" }
    if (IsChecked $Redux.Cheats.Health)            { ChangeBytes -Offset $Symbols.CFG_INFINITE_HEALTH          -Values "01" }
    if (IsChecked $Redux.Cheats.Magic)             { ChangeBytes -Offset $Symbols.CFG_INFINITE_MAGIC           -Values "01" }
    if (IsChecked $Redux.Cheats.Ammo)              { ChangeBytes -Offset $Symbols.CFG_INFINITE_AMMO            -Values "01" }
    if (IsChecked $Redux.Cheats.Rupees)            { ChangeBytes -Offset $Symbols.CFG_INFINITE_RUPEES          -Values "01" }



    # BUTTON COLORS #

    $offset = "380F854"

     if (IsDefaultColor -Elem $Redux.Colors.SetButtons[0] -Not) { # A Button
        ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "08") -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) # Button
        ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "88") -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) # Text Icons
        ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "58") -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)
        ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "84") -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)
        ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "90") -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)
        ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "A4") -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)
        ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "AC") -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)
        ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "B0") -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)
        ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "B4") -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)
        if ($Redux.Colors.Buttons.Text -eq "Randomized" -or $Redux.Colors.Buttons.Text -eq "Custom") {
            ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "64") -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) # Pause Outer Selection
            ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "68") -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) # Pause Outer Glow Selection
          # ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "6C") -Values @(($Redux.Colors.SetButtons[0].Color.R+20), ($Redux.Colors.SetButtons[0].Color.G+20), ($Redux.Colors.SetButtons[0].Color.B+20)) # Pause Outer Glow Selection
          # ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "70") -Values @(($Redux.Colors.SetButtons[0].Color.R-50), ($Redux.Colors.SetButtons[0].Color.G-50), ($Redux.Colors.SetButtons[0].Color.B-50)) # Pause Glow Selection
        }
    }

    if ( IsDefaultColor -Elem $Redux.Colors.SetButtons[1] -Not) { # B Button
        ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "0C") -Values @($Redux.Colors.SetButtons[1].Color.R, $Redux.Colors.SetButtons[1].Color.G, $Redux.Colors.SetButtons[1].Color.B) # Button
        ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "5C") -Values @($Redux.Colors.SetButtons[1].Color.R, $Redux.Colors.SetButtons[1].Color.G, $Redux.Colors.SetButtons[1].Color.B) # Text Icons
    }

    if (IsDefaultColor -Elem $Redux.Colors.SetButtons[2] -Not) { # C Buttons
        ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "10") -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # Buttons
        if ($Redux.Colors.Buttons.Text -ne "N64 OoT" -and $Redux.Colors.Buttons.Text -ne "N64 MM" -and $Redux.Colors.Buttons.Text -ne "GC OoT" -and $Redux.Colors.Buttons.Text -ne "GC MM") {
            ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "60") -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # Text Icons
            ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "A8") -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # to Equip
            ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "94") -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # Note
            ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "74") -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # Pause Outer Selection
            ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "7C") -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # Pause Selection
          # ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "80") -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # Pause Outer Glow Selection
          # ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "98") -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # Pause Outer Selection
        }
    }

    if (IsDefaultColor -Elem $Redux.Colors.SetButtons[3] -Not) { # Start Button
        ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "14") -Values @($Redux.Colors.SetButtons[3].Color.R, $Redux.Colors.SetButtons[3].Color.G, $Redux.Colors.SetButtons[3].Color.B) # Button
    }



    # HUD COLORS #

    if (IsSet $Redux.Colors.SetHUDStats) {
        if (IsDefaultColor -Elem $Redux.Colors.SetHUDStats[0] -Not)   { ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "30") -Values @($Redux.Colors.SetHUDStats[0].Color.R, $Redux.Colors.SetHUDStats[0].Color.G, $Redux.Colors.SetHUDStats[0].Color.B) } # Hearts
        if (IsDefaultColor -Elem $Redux.Colors.SetHUDStats[1] -Not)   { ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "34") -Values @($Redux.Colors.SetHUDStats[1].Color.R, $Redux.Colors.SetHUDStats[1].Color.G, $Redux.Colors.SetHUDStats[1].Color.B) } # Hearts
        if (IsDefaultColor -Elem $Redux.Colors.SetHUDStats[2] -Not)   { ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "38") -Values @($Redux.Colors.SetHUDStats[2].Color.R, $Redux.Colors.SetHUDStats[2].Color.G, $Redux.Colors.SetHUDStats[2].Color.B) } # Magic
        if (IsDefaultColor -Elem $Redux.Colors.SetHUDStats[3] -Not)   { ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "3C") -Values @($Redux.Colors.SetHUDStats[3].Color.R, $Redux.Colors.SetHUDStats[3].Color.G, $Redux.Colors.SetHUDStats[3].Color.B) } # Magic
        if (IsDefaultColor -Elem $Redux.Colors.SetHUDStats[4] -Not)   { ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "40") -Values @($Redux.Colors.SetHUDStats[4].Color.R, $Redux.Colors.SetHUDStats[4].Color.G, $Redux.Colors.SetHUDStats[4].Color.B) } # Minimap
    }

}



#==============================================================================================================================================================================================
function CheckLanguageOptions() {
    
    if     ( (IsChecked  $Redux.Text.Vanilla -Not)   -or (IsLanguage $Redux.Text.AdultPronouns)  -or (IsLanguage $Redux.UI.GCScheme)           -or (IsLanguage $Redux.Text.AreaTitleCards) -or (IsChecked $Redux.Text.Instant) )       { return $True }
    elseif ( (IsLanguage $Redux.Gameplay.RazorSword) -or (IsLanguage $Redux.Capacity.EnableAmmo) -or (IsLanguage $Redux.Capacity.EnableWallet) -or (IsLanguage $Redux.Text.GossipTime)     -or (IsChecked $Redux.Text.EasterEggs) )    { return $True }
    elseif ( (IsDefault $Redux.Features.OcarinaIcons -Not) -and $Patches.Redux.Checked -and $LanguagePatch.code -eq "en")                                                                                                              { return $True }
    elseif ( (IsChecked -Elem $Redux.Text.LinkScript)  -and $Redux.Text.LinkName.Text.Count -gt 0)                                                                                                                                     { return $True }
    elseif ( ( (IsDefault $Redux.Text.TatlScript -Not) -and (IsDefault $Redux.Text.TatlName -Not) -and $Redux.Text.TatlName.Text.Count -gt 0) -or (IsIndex -Elem $Redux.Text.TatlScript -Index 3) -and $LanguagePatch.code -eq "en")   { return $True }
    elseif ( ( (IsDefault $Redux.Text.TealScript -Not) -and (IsDefault $Redux.Text.TealName -Not) -and $Redux.Text.TaelName.Text.Count -gt 0) -or (IsIndex -Elem $Redux.Text.TaelScript -Index 3) -and $LanguagePatch.code -eq "en")   { return $True }
    
    return $False

}



#==============================================================================================================================================================================================
function WholeLanguageOptions([string]$Script, [string]$Table) {
    
    if (IsChecked $Redux.Text.Restore) {
        ApplyPatch -File $Script    -Patch "\Export\Message\restore_static.bps"
        ApplyPatch -File $Table     -Patch "\Export\Message\restore_table.bps"
        PatchBytes -Offset "A2DDC4" -Patch "Icons\troupe_leaders_mask_text.yaz0" -Length "26F" -Texture # Correct Circus Mask
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
    
    if (IsLanguage $Redux.UI.GCScheme) { SetMessage -ID "0227" -Text "5A20" -Replace "4C20"; SetMessage -ID "1912"; SetMessage -ID "191D"; SetMessage -ID "1946"; SetMessage -ID "1954" }

    if (IsLanguage -Elem $Redux.Gameplay.RazorSword) {
        SetMessage -ID "0038" -Text "This new, sharper blade is a cut<N>above the rest. Use it up to<N><R>100 times <W>without dulling its<N>superior edge!"                            -Replace "This new, sharper blade is a cut<N>above the rest. Use it as much<N>as you want without dulling its<N>superior edge!"
        SetMessage -ID "0C3B" -Text "Keep in mind that after you use<N>your reforged sword <R>100 times<W>, it<N>will lose its edge and it'll be back<N>to its original sharpness..."   -Replace "This reforged blade will be <R>unbreakable<W>.<N>Ohh... Don't look at me like that.<N>Surely I would not dare conning you<N>with a flimsy weapon."
        SetMessage -ID "0C51" -Text "Now keep in mind that after<N>you've used this <R>100 times<W>, the<N>blade will lose its edge and will<N>return to its <R>original sharpness<W>." -Replace "You do not need to worry for it, as<N>this blade is <R>unbreakable<W>. What!?<N>You do not believe me? Go see it<N>for yourself then in action."
        SetMessage -ID "1785" -Text "Use it up to <R>100 times<W>."                                                                                                                     -Replace "Use it as much you want."
    }

    if (IsLanguage -Elem $Redux.Text.AdultPronouns) {
        SetMessage -ID "0514" -Text "without an adult or<N>until you are old enough to carry" -Replace "until you are<N>capable of carrying"; SetMessage -ID "0515"
        SetMessage -ID "0514" -Text "child" -Replace "<N>defenseless Deku Scrub"; SetMessage -ID "0560"; SetMessage -ID "0561"; SetMessage -ID "0562"; SetMessage -ID "0563"; SetMessage -ID "0564"; SetMessage -ID "0565" # Guard guarding Clock Town exit (Deku Scrub)
        SetMessage -ID "0515" -Text "child" -Replace "defenseless<N>Deku Scrub"

        SetMessage -ID "0560" -Text "Until you are old enough to carry<N>a <R>weapon<W>, you cannot pass<N>through here without being<N>accompanied by an adult"  -Replace "Until you are capable of carrying<N>a <R>weapon<W>, you cannot pass<N>through here without being<N>defenseless"; SetMessage -ID "0562"; SetMessage -ID "0565"
        SetMessage -ID "0561" -Text "Until you are old enough to carry<N>a <R>weapon<W>, you cannot pass<N>through here without being <N>accompanied by an adult" -Replace "Until you are capable of carrying<N>a <R>weapon<W>, you cannot pass<N>through here without being<N>defenseless"
        SetMessage -ID "0563" -Text "Until you are old enough to carry<N>a <R>weapon<W>, you cannot pass <N>through here without being<N>accompanied an adult"    -Replace "Until you are capable of carrying<N>a <R>weapon<W>, you cannot pass<N>through here without being<N>defenseless"
        SetMessage -ID "0564" -Text "Until you are old enough to carry<N>a<R> weapon<W>, you cannot pass<N>through here without being<N>accompanied by an adult"  -Replace "Until you are capable of carrying<N>a <R>weapon<W>, you cannot pass<N>through here without being<N>defenseless"
        
        # Guard guarding Clock Town exit
        SetMessage -ID "0516" -Text "child" -Replace "teen"; SetMessage -ID "0517"; SetMessage -ID "0518"; SetMessage -ID "0519"; SetMessage -ID "0521"; SetMessage -ID "0523"; SetMessage -ID "052B"; SetMessage -ID "052D"; SetMessage -ID "0535"; SetMessage -ID "0537"; SetMessage -ID "055E"; SetMessage -ID "055F"
        SetMessage -ID "0566"; SetMessage -ID "0567"; SetMessage -ID "0568"; SetMessage -ID "0569"; SetMessage -ID "056A"; SetMessage -ID "056B"; SetMessage -ID "056C"; SetMessage -ID "056D";  SetMessage -ID "056E"; SetMessage -ID "056F"; SetMessage -ID "0570"; SetMessage -ID "0571"; SetMessage -ID "0572"; SetMessage -ID "0573"

        SetMessage -ID "04B0" -Text "child"       -Replace "adult";       SetMessage -ID "04B2"; SetMessage -ID "04B5"; SetMessage -ID "05F5"; SetMessage -ID "083C"
        SetMessage -ID "0BEA" -Text "fairy child" -Replace "fairy adult"; SetMessage -ID "0BF6"
        SetMessage -ID "33C3" -Text "child"       -Replace "youngster"
    }

    if (IsLanguage -Elem $Redux.Text.AreaTitleCards) {
        ChangeBytes -Offset "C5A250" -Values "02E9500002EA4CD0000B0001";         ChangeBytes -Offset "C5BA30" -Values "07104102"                                                                  # Lon Peak Shrine
        ChangeBytes -Offset "C5A2D0" -Values "01FCD00001FD88100010000000000000"; ChangeBytes -Offset "C5A918" -Values "0F004102"                                                                  # Barn
        ChangeBytes -Offset "C5A560" -Values "026FC00002714F9001390001";         ChangeBytes -Offset "C5B22C" -Values "3800CA143800CA14"; ChangeBytes -Offset "C5B254" -Values "3805410238054102" # Zora Cape		
        ChangeBytes -Offset "C5A6A0" -Values "02A0000002A0B8B000120001";         ChangeBytes -Offset "C5B4D8" -Values "4C054102"                                                                  # Zora Shop
        ChangeBytes -Offset "C5A3C0" -Values "022A8000022B0E9000130001";         ChangeBytes -Offset "C5AC98" -Values "1E004102"                                                                  # Deku Scrub Playground
        ChangeBytes -Offset "C5A2C0" -Values "026180000261DC5000A2000100000000"; ChangeBytes -Offset "C5B048" -Values "0E014102"                                                                  # Dampé's House
        ChangeBytes -Offset "C5A740" -Values "02B6F00002B7A01000A30001";         ChangeBytes -Offset "C5B5D4" -Values "AA00C102"                                                                  # Igos du Ikana's Throne
        ChangeBytes -Offset "C5A5E0" -Values "027B9000027C0B5000A40001";         ChangeBytes -Offset "C5B320" -Values "4000CA144001CA14"                                                          # Road to Southern Swamp
        ChangeBytes -Offset "C5A7B0" -Values "02C1900002C22BB000AC0001";         ChangeBytes -Offset "C5B6C4" -Values "5D00CA145D01C1025D024102"                                                  # Path to Goron Village (Winter)
        ChangeBytes -Offset "C5A7C0" -Values "02C2B00002C33AD000AC0001";         ChangeBytes -Offset "C5B6DC" -Values "5E00CA145E01C1025E024102"                                                  # Path to Goron Village (Spring)
        ChangeBytes -Offset "C5A790" -Values "02BFE00002C03CF000AD0000";                                                                                                                          # Path to Snowhead
        ChangeBytes -Offset "C5A710" -Values "02B2B00002B3309000AE0000";         ChangeBytes -Offset "C5B5B4" -Values "5300CA145301CA1453024A14"                                                  # Road to Ikana
        
        SetMessage -ID "000B" -ASCII -Replace "Lone Peak Shrine";       SetMessageIcon -ID "000B" -Hex "FE"
        SetMessage -ID "0010" -ASCII -Replace "Barn";                   SetMessageIcon -ID "0010" -Hex "FE"
        SetMessage -ID "0139" -ASCII -Replace "Zora Cape";              SetMessageIcon -ID "0139" -Hex "FE"
        SetMessage -ID "0012" -ASCII -Replace "Zora Shop";              SetMessageIcon -ID "0012" -Hex "FE"
        SetMessage -ID "0013" -ASCII -Replace "Deku Scrub Playground";  SetMessageIcon -ID "0013" -Hex "FE"
        SetMessage -ID "00A2" -ASCII -Replace "Dampé's House" -Force;   SetMessageIcon -ID "00A2" -Hex "FE"
        SetMessage -ID "00A3" -ASCII -Replace "Igos du Ikana's Throne"; SetMessageIcon -ID "00A3" -Hex "FE"
        SetMessage -ID "00A4" -ASCII -Replace "Road to Southern Swamp"; SetMessageIcon -ID "00A4" -Hex "FE"
        SetMessage -ID "00AC" -ASCII -Replace "Path to Goron Village";  SetMessageIcon -ID "00AC" -Hex "FE"
        SetMessage -ID "00AD" -ASCII -Replace "Path to Snowhead";       SetMessageIcon -ID "00AD" -Hex "FE"
        SetMessage -ID "00AE" -ASCII -Replace "Road to Ikana";          SetMessageIcon -ID "00AE" -Hex "FE"
        SetMessage -ID "00AF" -ASCII -Replace "The Moon";               SetMessageIcon -ID "00AF" -Hex "FE"

        if (IsChecked -Elem $Redux.Restore.OnTheMoonIntro -Not) { ChangeBytes -Offset "C5A850" -Values "02D5A00002D64FD000AF0000"; ChangeBytes -Offset "C5B7CC" -Values "67004387"; SetMessage -ID "00AF" -ASCII -Replace "The Moon"; SetMessageIcon -ID "00AF" -Hex "FE" } # The Moon
    }

    if (IsChecked $Redux.Text.EasterEggs) {
        if (TestFile ($GameFiles.Base + "\Easter Eggs.json")) {
            $json = SetJSONFile ($GameFiles.Base + "\Easter Eggs.json")
            foreach ($entry in $json) { SetMessage -ID $entry.box -Replace $entry.message }
        }
   }

    if ( (IsDefault $Redux.Text.TatlScript -Not) -and (IsDefault $Redux.Text.TatlName -Not) -and $Redux.Text.TatlName.Text.Count -gt 0) {
        SetMessage -ID "057A" -Text $LanguagePatch.tatl -Replace $Redux.Text.TatlName.Text; SetMessage -ID "057C"; SetMessage -ID "057E"; SetMessage -ID "058E"; SetMessage -ID "0735"; SetMessage -ID "073E"; SetMessage -ID "073F"; SetMessage -ID "1F4E"
        if (TestFile ($GameFiles.textures + "\Tatl\" + $Redux.Text.TatlName.Text + ".cup") )   { PatchBytes -Offset "1EBFAE0" -Texture -Patch ("Tatl\" + $Redux.Text.TatlName.Text + ".cup") }
        else                                                                                   { PatchBytes -Offset "1EBFAE0" -Texture -Patch ("Tatl\Info.cup")                              }
    }
    if ( (IsIndex -Elem $Redux.Text.TatlScript -Index 3) -and $LanguagePatch.code -eq "en") {
	    SetMessage -ID "1F43" -Text "sis"    -Replace "bro";    SetMessage -ID "1F48" -Text "S-s..." -Replace "B-b..."; SetMessage -ID "1F48" -Text "Sis"    -Replace "Bro";    SetMessage -ID "1F4A" -Text "girl" -Replace "boy"; SetMessage -ID "2009" -Text "Sis!!!" -Replace "Bro!!!"
        SetMessage -ID "2028" -Text "Sis!!!" -Replace "Bro!!!"; SetMessage -ID "202D" -Text "Sis..." -Replace "Bro..."; SetMessage -ID "2045" -Text "Sis..." -Replace "Bro..."; SetMessage -ID "2048" -Text "sis"  -Replace "bro"; SetMessage -ID "204A" -Text "sister" -Replace "brother"
    }

    if ( (IsDefault $Redux.Text.TaelScript -Not) -and (IsDefault $Redux.Text.TaelName -Not) -and $Redux.Text.TaelName.Text.Count -gt 0) {
        SetMessage -ID "0216" -Text "Tael" -Replace $Redux.Text.TaelName.Text; SetMessage -ID "0217"; SetMessage -ID "0229"; SetMessage -ID "146B"; SetMessage -ID "1F42"; SetMessage -ID "1F47"; SetMessage -ID "1F4B"; SetMessage -ID "200A"; SetMessage -ID "2011"
        SetMessage -ID "2016";                                                 SetMessage -ID "2029"; SetMessage -ID "202E"; SetMessage -ID "203B"; SetMessage -ID "203D"; SetMessage -ID "2040"; SetMessage -ID "2049"; SetMessage -ID "2080"
    }
    if ( (IsIndex -Elem $Redux.Text.TaelScript -Index 3) -and $LanguagePatch.code -eq "en") {
        SetMessage -ID "1F49" -Text "brother" -Replace "sister"; SetMessage -ID "1F4B" -Text "his" -Replace "her"; SetMessage -ID "200D" -Text "brother" -Replace "sister"; SetMessage -ID "2012" -Text "brother" -Replace "sister"
        SetMessage -ID "0216" -Text "he"      -Replace "she";    SetMessage -ID "0216" -Text "He"  -Replace "She"
    }

    if ( (IsChecked $Redux.Text.LinkScript) -and $Redux.Text.LinkName.Text.Count -gt 0) {
        SetMessage -ID "0462" -Text "16" -Replace $Redux.Text.LinkName.text; SetMessage -ID "046A"; SetMessage -ID "046C"; SetMessage -ID "0591"; SetMessage -ID "0593"; SetMessage -ID "059D"; SetMessage -ID "05A1"; SetMessage -ID "05A5"; SetMessage -ID "05A9"; SetMessage -ID "0710" -All; SetMessage -ID "0734" -All
        SetMessage -ID "0736"; SetMessage -ID "0800"; SetMessage -ID "0802"; SetMessage -ID "08E4"; SetMessage -ID "08E5"; SetMessage -ID "0961"; SetMessage -ID "0966"; SetMessage -ID "0967"; SetMessage -ID "0969"; SetMessage -ID "096D"; SetMessage -ID "096F"; SetMessage -ID "0971";      SetMessage -ID "102A"
        SetMessage -ID "102D"; SetMessage -ID "1030"; SetMessage -ID "1068"; SetMessage -ID "1069"; SetMessage -ID "106D"; SetMessage -ID "14DD"; SetMessage -ID "14F9"; SetMessage -ID "1F74"; SetMessage -ID "27D9"; SetMessage -ID "27DB"; SetMessage -ID "27DC"; SetMessage -ID "27DE";      SetMessage -ID "27DF"
        SetMessage -ID "27E0"; SetMessage -ID "27F0"; SetMessage -ID "27F2"; SetMessage -ID "27F6"; SetMessage -ID "28AA"; SetMessage -ID "28AB"; SetMessage -ID "28B2"; SetMessage -ID "28B3"; SetMessage -ID "28B5"; SetMessage -ID "28B6"; SetMessage -ID "3339"; SetMessage -ID "333A";
    }

    if (IsChecked $Redux.Text.GossipTime) { SetMessage -ID "20D2" -Replace "The time is currently <ClockTime>!<N>" -Insert }

    if (IsLanguage $Redux.Capacity.EnableAmmo) {
        SetMessage -ID "0019" -ASCII -Text "10" -Replace $Redux.Capacity.DekuSticks1.text
        SetMessage -ID "178A" -ASCII -Text "30" -Replace $Redux.Capacity.Quiver1.text
        SetMessage -ID "178B" -ASCII -Text "40" -Replace $Redux.Capacity.Quiver2.text;  SetMessage -ID "0023"
        SetMessage -ID "178C" -ASCII -Text "50" -Replace $Redux.Capacity.Quiver3.text;  SetMessage -ID "0024"
        SetMessage -ID "178D" -ASCII -Text "20" -Replace $Redux.Capacity.BombBag1.text
        SetMessage -ID "178E" -ASCII -Text "30" -Replace $Redux.Capacity.BombBag2.text; SetMessage -ID "001C"
        SetMessage -ID "178F" -ASCII -Text "40" -Replace $Redux.Capacity.BombBag3.text; SetMessage -ID "001D"
    }

    if (IsLanguage $Redux.Capacity.EnableWallet) {
        SetMessage -ID "0008" -ASCII -Text "200" -Replace $Redux.Capacity.Wallet2.text -NoParse
        SetMessage -ID "0009" -ASCII -Text "500" -Replace $Redux.Capacity.Wallet3.text -NoParse
    }

    if ( (IsDefault $Redux.Features.OcarinaIcons -Not) -and $Patches.Redux.Checked -and $LanguagePatch.code -eq "en") {
        SetMessage     -ID "1726" -Replace "<R>Deku Pipes<N><W>Loud pipes that sprout forth from<N>your Deku Scrub body.<N><New Box II>Play it with <A Button> and the four <C Button><N>Buttons. Press <B Button> to stop."
        SetMessageIcon -ID "1726" -Hex "70"
        
        SetMessage     -ID "171C" -Replace "<R>Goron Drums<N><W>The traditional instrument of the<N>Goron tribe.<N><New Box II>Play it with <A Button> and the four <C Button><N>Buttons. Press <B Button> to stop."
        SetMessageIcon -ID "171C" -Hex "64"
        
        SetMessage     -ID "1727" -Replace "<R>Zora Guitar<N><W>A soulful guitar from a Zora band.<N>It's overflowing with good vibes.<N><New Box II>Play it with <A Button> and the four <C Button><N>Buttons. Press <B Button> to stop."
        SetMessageIcon -ID "1727" -Hex "44"
    }

    if (IsChecked $Redux.Text.Instant) {
        WriteToConsole "Starting Generating Instant Text"
        :outer foreach ($h in $DialogueList.GetEnumerator()) {
            if     ($DialogueList[$h.name].msg.count -eq 0) { continue }
            elseif ( (GetDecimal $h.name) -ge 256 -and (GetDecimal $h.name) -le 329) { continue } # Area Title Cards

          # if     ($h.name -eq "108E" -or $h.name -eq "403E" -or $h.name -eq "605A" -or $h.name -eq "706C" -or $h.name -eq "70DD" -or $h.name -eq "706F" -or $h.name -eq "7091" -or $h.name -eq "7092" -or $h.name -eq "7093" -or $h.name -eq "7094" -or $h.name -eq "7095" -or $h.name -eq "7070") { continue }
          # elseif ( (GetDecimal $h.name) -ge 2157 -and (GetDecimal $h.name) -le 2172) { continue } # Learning Songs

         <# if ($h.name -ne "00B4") {
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
            } #>

            SetMessage -ID $h.name -Text @(23)                    -Silent -All    # Remove all <DI>
            SetMessage -ID $h.name -Text @(24)                    -Silent -All    # Remove all <DC>
            SetMessage -ID $h.name             -Replace @(23)     -Silent -Insert # Insert <DI> to start
            SetMessage -ID $h.name -Text @(16) -Replace @(16, 23) -Silent -All    # Add <DI> after <New Box>
            SetMessage -ID $h.name -Text @(18) -Replace @(18, 24) -Silent -All    # Add <DI> after <New Box II>
        }
        WriteToConsole "Finished Generating Instant Text"
    }

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsDialog -Columns 6 -Height 605 -Tabs @("Main", "Graphics", "Audio", "Difficulty", "Colors", "Equipment", "Speedup")

}



#==============================================================================================================================================================================================
function CreateTabMain() {
    
    # GAMEPLAY #

    CreateReduxGroup    -All -Tag  "Gameplay"             -Text "Gameplay"
    CreateReduxCheckBox -All -Name "ZoraPhysics"          -Text "Zora Physics"              -Info "Change the Zora physics when using the boomerang`nZora Link will take a step forward instead of staying on his spot"                                             -Credits "ShadowOne333"
    CreateReduxCheckBox -All -Name "DistantZTargeting"    -Text "Distant Z-Targeting"       -Info "Allow to use Z-Targeting on enemies, objects and NPC's from any distance"                                                                                        -Credits "Admentus"
    CreateReduxCheckBox -All -Name "ManualJump"           -Text "Manual Jump"               -Info "Press Z + A to do a Manual Jump instead of a Jump Attack`nPress B mid-air after jumping to do a Jump Attack"                                                     -Credits "Admentus"
    CreateReduxCheckBox -All -Name "FDSpinAttack"         -Text "Fierce Deity Spin Attack"  -Info "Allows Fierce Deity Link to perform a magic spin attack"                                                                                                         -Credits "Admentus"
    CreateReduxCheckBox -All -Name "FrontflipJump"        -Text "Force Frontflip Jump"      -Info "Link will always use the frontflip animation when jumping"                                                                                                       -Credits "SoulofDeity"
    CreateReduxCheckBox -All -Name "NoShieldRecoil"       -Text "No Shield Recoil"          -Info "Disable the recoil when being hit while shielding"                                                                                                               -Credits "Admentus"
    CreateReduxCheckBox -All -Name "FormItems"            -Text "Use Items With Mask Forms" -Info "Deku Link, Goron Link and Zora Link are able to use a few items such as Bombs and Deku Sticks"                                                                   -Credits "bry_dawg02"
    CreateReduxCheckBox -All -Name "SunSong"              -Text "Sun's Song"                -Info "Unlocks the Sun's Song when creating a new save file, which skips time to the next day or night"                                                                 -Credits "Ported from Rando"
    CreateReduxCheckBox -All -Name "SariaSong"            -Text "Saria's Song"              -Info "Unlocks Saria's Song when creating a new save file, which plays the Final Hours music theme until the next area"                                                 -Credits "Ported from Rando"
    CreateReduxCheckBox -All -Name "HookshotAnything"     -Text "Hookshot Anything"         -Info "Be able to hookshot most surfaces"                               -Warning "Prone to softlocks, be careful"                                                       -Credits "Ported from Rando"
    CreateReduxCheckBox -All -Name "NoMagicArrowCooldown" -Text "No Magic Arrow Cooldown"   -Info "Be able to shoot magic arrows without a delay between each shot" -Warning "Prone to crashes upon switching arrow types (Redux feature) to quickly"               -Credits "Ported from Rando"
    CreateReduxCheckBox -All -Name "FierceDeityAnywhere"  -Text "Fierce Deity Anywhere"     -Info "The Fierce Deity Mask can be used anywhere now´nApplies additional fixes to make the form more usable, such as being able to push blocks"                        -Credits "Ported from Rando"
    CreateReduxComboBox -All -Name "LinkJumpAttack"       -Text "Link Jump Attack"          -Info "Set the Jump Attack animation for Link in his Hylian Form" -Items @("Jumpslash", "Frontflip", "Beta Frontflip", "Beta Backflip", "Spin Slash", "Zora Jumpslash") -Credits "Admentus (ported), SoulofDeity & Aegiker"
    CreateReduxComboBox -All -Name "ZoraJumpAttack"       -Text "Zora Jump Attack"          -Info "Set the Jump Attack animation for Link in his Zora Form"   -Items @("Zora Jumpslash", "Beta Frontflip", "Beta Backflip", "Spin Slash")                           -Credits "Admentus (ported) & Aegiker"



    # RESTORE #

    CreateReduxGroup    -All -Tag  "Restore"           -Text "Restore / Correct"
    CreateReduxCheckBox -All -Name "RupeeColors"       -Text "Correct Rupee Colors"     -Info "Corrects the colors for the Purple (50) and Golden (200) Rupees"                                           -Credits "GhostlyDark"
    CreateReduxCheckBox -All -Name "CowNoseRing"       -Text "Restore Cow Nose Ring"    -Info "Restore the rings in the noses for Cows as seen in the Japanese release"                                   -Credits "ShadowOne333"
    CreateReduxCheckBox -All -Name "RomaniSign"        -Text "Correct Romani Sign"      -Info "Replace the Romani Sign texture to display Romani's Ranch instead of Kakariko Village"                     -Credits "ShadowOne333"
    CreateReduxCheckBox -All -Name "Title"             -Text "Restore Title"            -Info "Restore the title logo colors as seen in the Japanese release"                                             -Credits "ShadowOne333 & Garo-Mastah"
    CreateReduxCheckBox -All -Name "SkullKid"          -Text "Restore Skull Kid"        -Info "Restore Skull Kid's face as seen in the Japanese release"                                                  -Credits "ShadowOne333"
    CreateReduxCheckBox -All -Name "ShopMusic"         -Text "Restore Shop Music"       -Info "Restores the Shop music intro theme as heard in the Japanese release"                                      -Credits "ShadowOne333"
    CreateReduxCheckBox -All -Name "IkanaCastle"       -Text "Restore Ikana Castle"     -Info "Restore a misplaced texture on the wall of Ancient Castle of Ikana in Ikana Canyon"                        -Credits "Linkz"
    CreateReduxCheckBox -All -Name "PieceOfHeartSound" -Text "4th Piece of Heart Sound" -Info "Restore the sound effect when collecting the fourth Piece of Heart that grants Link a new Heart Container" -Credits "ShadowOne333"
    CreateReduxCheckBox -All -Name "MoveBomberKid"     -Text "Move Bomber Kid"          -Info "Moves the Bomber at the top of the Stock Pot Inn to be behind the bell like in the original Japanese ROM"  -Credits "ShadowOne333"
    CreateReduxCheckBox -All -Name "OnTheMoonIntro"    -Text "On The Moon Intro"        -Info "Restores the intro cutscene when you get to the On The Moon area"                                          -Credits "Chez Cousteau"



    # OTHER #

    CreateReduxGroup    -All -Tag  "Other"             -Text "Other"
    CreateReduxCheckBox -All -Name "PictoboxDelayFix"  -Text "Pictograph Box Delay Fix" -Info "Photos are taken instantly with the Pictograph Box by removing the Anti-Aliasing"                                                                  -Checked -Credits "Ported from Rando"
    CreateReduxCheckBox -All -Name "MushroomBottle"    -Text "Fix Mushroom Bottle"      -Info "Fix the item reference when collecting Magical Mushrooms as Link puts away the bottle automatically due to an error"                                        -Credits "ozidual"
    CreateReduxCheckBox -All -Name "ClockTown"         -Text "Fix Clock Town"           -Info "Fix misaligned gaps and seams in several places in Clock Town"                                                                                              -Credits "Linkz"
    CreateReduxCheckBox -All -Name "SouthernSwamp"     -Text "Fix Southern Swamp"       -Info "Fix a misplaced door after Woodfall has been cleared and you return to the Potion Shop`nThe door is slightly pushed forward after Odolwa has been defeated" -Credits "ShadowOne333"
    CreateReduxCheckBox -All -Name "GreatBay"          -Text "Fix Great Bay"            -Info "Fix the gap near the Research Lab platform in the Great Bay area"                                                                                           -Credits "Linkz"
    CreateReduxCheckBox -All -Name "FairyFountain"     -Text "Fix Fairy Fountain"       -Info "Fix the Ikana Canyon Fairy Fountain area not displaying the correct color"                                                                                  -Credits "Dybbles (fix) & ShadowOne333 (patch)"
    CreateReduxCheckBox -All -Name "OutOfBoundsGrotto" -Text "Fix Out-of-Bounds Grotto" -Info "Fix the out-of-bounds grotto in the Mountain Village area during winter"                                                                                    -Credits "Chez Cousteau"
    CreateReduxCheckBox -All -Name "OutOfBoundsRupee"  -Text "Fix Out-of-Bounds Rupee"  -Info "Fix the out-of-bounds Rupee in the Deku Palace Left Outer Garden area"                                                                                      -Credits "Chez Cousteau"
    CreateReduxCheckBox -All -Name "DebugMapSelect"    -Text "Debug Map Select"         -Info "Translates the Debug Map Select menu into English"                                                                                                          -Credits "GhostlyDark"
    CreateReduxCheckBox -All -Name "DebugItemSelect"   -Text "Debug Item Select"        -Info "Translates the Debug Inventory Select menu into English"                                                                                                    -Credits "GhostlyDark"
    CreateReduxCheckBox -All -Name "AlwaysBestEnding"  -Text "Always Best Ending"       -Info "The credits sequence always includes the best ending, regardless of actual ingame progression"                                                              -Credits "Marcelo20XX"

    CreateReduxGroup    -All -Tag  "Cutscenes"         -Text "Cutscene Fixes" 
    CreateReduxCheckBox -All -Name "GohtAwakening"     -Text "Goht Awakening"   -Info "Fix Goht's awakening cutscene so that Link no longer gets run over"                     -Credits "ShadowOne333"
    CreateReduxCheckBox -All -Name "BombLady"          -Text "Bomb Lady"        -Info "Fix the Bomb Lady for unused cutscenes in North Clock Town"                             -Credits "Chez Cousteau"
    CreateReduxCheckBox -All -Name "GiantsRealm"       -Text "Giant's Realm"    -Info "Fix the Giants in the unused cutscenes"                                                 -Credits "Chez Cousteau"
    CreateReduxCheckBox -All -Name "MountainVillage"   -Text "Mountain Village" -Info "Fix unloaded actors for unused cutscenes in the Spring version of the Mountain Village" -Credits "Chez Cousteau"
    CreateReduxCheckBox -All -Name "IkanaCanyon"       -Text "Ikana Canyon"     -Info "Fix transitions and unloaded actors for unused cutscenes in Ikana Canyon"               -Credits "Chez Cousteau"
    


    # CUSTOM SCENES #

    CreateReduxGroup    -Tag  "Gameplay"     -Text "Custom Scenes"
    CreateReduxCheckBox -Name "CustomScenes" -Text "Custom Scenes" -Info "Patch in custom scenes generated by the Actor Editor`nOnly works if the Actor Editor generated a patch" -Credits "Admentus"

}



#==============================================================================================================================================================================================
function CreateTabRedux() {
    
    # D-PAD #

    CreateReduxGroup       -Tag  "Dpad"        -All                         -Text "D-Pad Layout"
    CreateReduxPanel                           -All -Columns 4
    CreateReduxRadioButton -Name "Disable"     -All -Max 4 -SaveTo "Layout" -Text "Disable"    -Info "Completely disable the D-Pad"                                                                                           -Credits "Ported from Redux"
    CreateReduxRadioButton -Name "Hide"        -All -Max 4 -SaveTo "Layout" -Text "Hidden"     -Info "Hide the D-Pad icons, while they are still active`nYou can rebind the items to the D-Pad in the pause screen"           -Credits "Ported from Redux"
    CreateReduxRadioButton -Name "LayoutLeft"  -All -Max 4 -SaveTo "Layout" -Text "Left Side"  -Info "Show the D-Pad icons on the left side of the HUD`nYou can rebind the items to the D-Pad in the pause screen"   -Checked -Credits "Ported from Redux"
    CreateReduxRadioButton -Name "LayoutRight" -All -Max 4 -SaveTo "Layout" -Text "Right Side" -Info "Show the D-Pad icons on the right side of the HUD`nYou can rebind the items to the D-Pad in the pause screen"           -Credits "Ported from Redux"
  # CreateReduxCheckBox    -Name "DualSet"     -All                         -Text "Dual Set"   -Info "Allow switching between two different D-Pad sets`nPress L + R ingame to swap between layouts" -Link $Redux.Dpad.Disable -Credits "Admentus"



    # GAMEPLAY #

    $warning  = "30 FPS mode will have issues that prevent you from completing the game and certain challenges`nSwitch back to 20 FPS mode to continue these sections before returning to 30 FPS mode`n`n"
    $warning += "--- Known Issues --`n"
    $warning += "Gravity for throwing objects`nExplosion timers are shorter`nLit torches burn out faster`nTriple swing is extremely hard to perform`nBaddies act and attack faster`nMinigame timers run too fast"

    CreateReduxGroup    -All -Tag  "Gameplay"           -Text "Gameplay"
    CreateReduxCheckBox -All -Name "FasterBlockPushing" -Text "Faster Block Pushing"       -Info "All blocks are pushed faster"                                                                                                 -Checked -Credits "Ported from Redux"
    CreateReduxCheckBox -All -Name "ElegySpeedup"       -Text "Elegy of Emptiness Speedup" -Info "The Elegy of Emptiness statue summoning cutscene is skipped after playing the song"                                           -Checked -Credits "Ported from Redux"
    CreateReduxCheckBox -All -Name "CritWiggle"         -Text "Disable Crit Wiggle"        -Info "Link no longer randomly moves when his health is critical"                                                                    -Checked -Credits "Ported from Redux"
    CreateReduxCheckBox -All -Name "UnderwaterOcarina"  -Text "Underwater Ocarina"         -Info "Zora Link can play the Ocarina when standing on the bottom of water" -Warning "Not compatible with Ocarina Icons"             -Checked -Credits "Ported from Redux"
    CreateReduxCheckBox -All -Name "FlowOfTime"         -Text "Control Flow of Time"       -Info "Hold L and press D-Pad Up, Right or Left to control the flow of time`nTime can be sped up and inversed without the use of the Ocarina" -Credits "Admentus"
    CreateReduxCheckBox -All -Name "InstantElegy"       -Text "Instant Elegy Statue"       -Info "Hold L and press D-Pad Down to summon an Elegy of Emptiness Statue without the use of the Ocarina"                                     -Credits "Admentus"
    
    CreateReduxGroup    -All -Tag  "Features"       -Text "Features"
    CreateReduxComboBox -All -Name "OcarinaIcons"   -Text "Ocarina Icons"         -Info "Restore the Ocarina Icons with their text when transformed like in the N64 Beta or 3DS version`nRequires the language to be set to English" -Items @("Disabled", "Enabled", "Enabled with Original Icon") -Credits "Admentus & ShadowOne333" -Warning "Not compatible with Underwater Ocarina"
    CreateReduxTextBox  -All -Name "RupeeDrain"     -Text "Rupee Drain"           -Info "A difficulty option that drains your Rupees over time, and then your health over time`nThe value is the amount of seconds before each drain occurs"                     -Length 2 -Value 0 -Min 0 -Max 10 -Credits "Admentus"
    CreateReduxCheckBox -All -Name "FPS"            -Text "30 FPS (Experimental)" -Info "Experimental 30 FPS support`nUse L + Z to toggle between 20 FPS and 30 FPS mode"                                                                                                                          -Credits "Admentus" -Warning $warning
    CreateReduxCheckBox -All -Name "HealthBar"      -Text "Health Bar"            -Info "Shows the total health and remaining health of enemies and bosses as a bar when you Z-Target them"                                                                                                        -Credits "Ported from Rando"
    CreateReduxCheckBox -All -Name "HUDToggle"      -Text "HUD Toggle"            -Info "Toggle the HUD by using the L button`nPress L in the MAP subscreen to toggle it in its entirety`nPress L ingame to toggle the essential display"                                                          -Credits "Admentus"
    CreateReduxCheckBox -All -Name "ItemsUnequip"   -Text "Unequip Items"         -Info "Press C-Up on an equipped C Button item to unequip it from the assigned C Button"                                                                                                                         -Credits "Admentus"
    CreateReduxCheckBox -All -Name "ItemsOnB"       -Text "Items on B Button"     -Info "Press the L Button on an item in the SELECT ITEM subscreen to equip it on the B button`nSome items are excluded`nPress C-Up on the Sword icon to equip the sword again"                                   -Credits "Admentus"
    CreateReduxCheckBox -All -Name "GearSwap"       -Text "Swap Gear"             -Info "Press C-Left or C-Right on a sword or shield icon to change between equipment`nYou must have obtained the upgrades, and must not be stolen or reforged`nThis option also makes the Razor Sword permanent" -Credits "Admentus"
    CreateReduxCheckBox -All -Name "SkipGuard"      -Text "Skip Clock Town Guard" -Info "The Clock Town Guard will no longer block entry to Termina Field on subsequent cycles when Hylian Link has spoken to them at least once"                                                                  -Credits "Admentus"

    CreateReduxGroup    -All -Tag  "Cheats"          -Text "Cheats"
    CreateReduxCheckBox -All -Name "ClimbAnything"   -Text "Climb Anything"   -Info "Climb most walls in the game" -Warning "Prone to softlocks, be careful"        -Credits "Ported from Rando"
    CreateReduxCheckBox -All -Name "InventoryEditor" -Text "Inventory Editor" -Info "Press the L button in the QUEST STATUS subscreen to open the Inventory Editor" -Credits "Admentus"
    CreateReduxCheckBox -All -Name "Health"          -Text "Infinite Health"  -Info "Link's health is always at its maximum"                                        -Credits "Admentus"
    CreateReduxCheckBox -All -Name "Magic"           -Text "Infinite Magic"   -Info "Link's magic is always at its maximum"                                         -Credits "Admentus"
    CreateReduxCheckBox -All -Name "Ammo"            -Text "Infinite Ammo"    -Info "Link's ammo for items are always at their maximum"                             -Credits "Admentus"
    CreateReduxCheckBox -All -Name "Rupees"          -Text "Infinite Rupees"  -Info "Link's wallet is always filled at its maximum"                                 -Credits "Admentus"

    $warning = $null

    if ( (IsSet $Redux.Gameplay.UnderwaterOcarina) -and (IsSet $Redux.Gameplay.OcarinaIcons) ) {
        if     ($Redux.Gameplay.UnderwaterOcarina.Checked -and $Redux.Features.OcarinaIcons.SelectedIndex -gt 0)   { $Redux.Gameplay.UnderwaterOcarina.Checked = $False; $Redux.Features.OcarinaIcons.SelectedIndex = 0 }
        elseif ($Redux.Gameplay.UnderwaterOcarina.Checked)                                                         { EnableElem -Elem $Redux.Features.OcarinaIcons      -Active $False }
        elseif ($Redux.Features.OcarinaIcons.SelectedIndex -gt 0)                                                  { EnableElem -Elem $Redux.Gameplay.UnderwaterOcarina -Active $False }

        $Redux.Gameplay.UnderwaterOcarina.Add_CheckStateChanged( { EnableElem -Elem $Redux.Features.OcarinaIcons      -Active (!$this.checked)             })
        $Redux.Features.OcarinaIcons.Add_SelectedIndexChanged(   { EnableElem -Elem $Redux.Gameplay.UnderwaterOcarina -Active (!$this.selectedIndex -ne 0) })
    }
    

    # BUTTON COLORS #

    CreateButtonColorOptions -Default 2
    $Last.Half = $False
    CreateHUDColorOptions -MM
    
}



#==============================================================================================================================================================================================
function CreateTabLanguage() {
    
    if ($GamePatch.vanilla -eq 1) { CreateLanguageContent }



    # DIALOGUE #
     
    if ($GamePatch.vanilla -eq 1) {
        CreateReduxGroup       -All -Tag "Text" -Text "Dialogue"
        CreateReduxPanel       -Columns 4
        CreateReduxRadioButton -All -Name "Vanilla" -Max 4 -SaveTo "Dialogue" -Text "Vanilla Text" -Info "Keep the text as it is appeared in the original release" -Checked
        CreateReduxRadioButton -All -Name "Instant" -Max 4 -SaveTo "Dialogue" -Text "Instant Text" -Info "Most text will be shown instantly"                       -Credits "Admentus"
        CreateReduxRadioButton -All -Name "Restore" -Max 4 -SaveTo "Dialogue" -Text "Restore Text" -Info "Restores and fixes the following:`n- Restore the area titles cards for those that do not have any`n- Sound effects that do not play during dialogue`n- Grammar and typo fixes" -Credits "Redux"
        CreateReduxRadioButton -All -Name "Custom"  -Max 4 -SaveTo "Dialogue" -Text "Custom"       -Info ('Insert custom dialogue found from "..\Patcher64+ Tool\Files\Games\Majora' + "'" + 's Mask\Custom Text"') -Warning "Make sure your custom script is proper and correct, or your ROM will crash`n[!] No edit will be made if the custom script is missing"
    }

    CreateReduxCheckBox -All    -Name "AdultPronouns"  -Text "Adult Pronouns"   -Info "Refer to Link as an adult instead of a child"                              -Credits "Skilar"
    CreateReduxCheckBox -Base 1 -Name "AreaTitleCards" -Text "Area Title Cards" -Info "Add area title cards to missing areas"                                     -Credits "ShadowOne333"
    CreateReduxCheckBox -All    -Name "EasterEggs"     -Text "Easter Eggs"      -Info "Adds custom Patreon Tier 3 messages into the game`nCan you find them all?" -Credits "Admentus & Patreons" -Checked

    

    # OTHER TEXT OPTIONS #

    $names = "`n`n--- Supported Names With Textures ---`n" + "Navi`nTatl`nTaya`nТдтп`nTael`nNite`nNagi`nInfo"
    CreateReduxGroup    -All -Tag  "Text"       -Text "Other Text Options"
    CreateReduxComboBox -All -Name "TatlScript" -Text "Tatl Text" -Items @("Disabled", "Enabled as Female", "Enabled as Male") -Info "Allow renaming Tatl and the pronouns used"                                                             -Credits "Admentus & ShadowOne333"            -Warning "Gender swap is only supported for English"
    CreateReduxTextBox  -All -Name "TatlName"   -Text "Tatl Name" -Length 5 -ASCII -Value "Tatl" -Width 50                     -Info "Select the name used for Tatl"                                                                         -Credits "Admentus & ShadowOne333"            -Warning ('Most names do not have an unique texture label, and use a default "Info" prompt label' + $names)
    CreateReduxComboBox -All -Name "TaelScript" -Text "Tael Text" -Items @("Disabled", "Enabled as Male", "Enabled as Female") -Info "Allow renaming Tael and the pronouns used"                                                             -Credits "Admentus, ShadowOne333 & kuirivito" -Warning "Gender swap is only supported for English"
    CreateReduxTextBox  -All -Name "TaelName"   -Text "Tael Name" -Length 5 -ASCII -Value "Tael" -Width 50                     -Info "Select the name used for Tael"                                                                         -Credits "Admentus & ShadowOne333"
    CreateReduxCheckBox -All -Name "LinkScript" -Text "Link Text"                                                              -Info "Separate file name from Link's name in-game"                                                           -Credits "Admentus & Third M"
    CreateReduxTextBox  -All -Name "LinkName"   -Text "Link Name" -Length 8 -ASCII -Value "Link" -Width 90                     -Info "Select the name for Link in-game"                                                                      -Credits "Admentus & Third M"                 -Shift 40
    CreateReduxCheckBox -All -Name "GossipTime" -Text "Add Gossip Stone Clock"                                                 -Info "Makes it so that the gossip stones, in addition to telling time left to moonfall, also act as a clock" -Credits "kuirivito"
    CreateReduxCheckBox -All -Name "YeetPrompt" -Text "Yeet Action Prompt"                                                     -Info ('Replace the "Throw" Action Prompt with "Yeet"' + "`nYeeeeet")                                         -Credits "kr3z"
    CreateReduxCheckBox -All -Name "Comma"      -Text "Better Comma"                                                           -Info "Make the comma not look as awful"                                                                      -Credits "ShadowOne333"

    if ($GamePatch.vanilla -eq 1) {
        foreach ($i in 0.. ($Files.json.languages.length-1)) { $Redux.Language[$i].Add_CheckedChanged({ UnlockLanguageContent }) }
        UnlockLanguageContent
    }

    EnableElem -Elem $Redux.Text.TatlName -Active ($Redux.Text.TatlScript.SelectedIndex -ne 0)
    EnableElem -Elem $Redux.Text.TaelName -Active ($Redux.Text.TaelScript.SelectedIndex -ne 0)
    EnableElem -Elem $Redux.Text.LinkName -Active ($Redux.Text.LinkScript.Checked)
    $Redux.Text.TatlScript.Add_SelectedIndexChanged( { EnableElem -Elem $Redux.Text.TatlName -Active ($this.SelectedIndex -ne 0) } )
    $Redux.Text.TaelScript.Add_SelectedIndexChanged( { EnableElem -Elem $Redux.Text.TaelName -Active ($this.SelectedIndex -ne 0) } )
    $Redux.Text.LinkScript.Add_CheckStateChanged(    { EnableElem -Elem $Redux.Text.LinkName -Active ($this.Checked)             } )

}



#==============================================================================================================================================================================================
function UnlockLanguageContent() {
    
    # English options
    EnableElem -Elem @($Redux.Text.Restore, $Redux.Text.AdultPronouns, $Redux.Text.AreaTitleCards, $Redux.Text.EasterEggs, $Redux.Text.GossipTime, $Redux.Features.OcarinaIcons) -Active $Redux.Language[0].checked
    if (!$Redux.Language[0].Checked -and !$Redux.Text.Vanilla.Checked -and !$Redux.Text.Custom.Checked) { $Redux.Text.Vanilla.Checked = $True }



}



#==============================================================================================================================================================================================
function CreateTabGraphics() {
    
    # GRAPHICS #

    CreateReduxGroup    -All -Tag "Graphics"        -Text "Graphics" -Columns 4
    CreateReduxCheckBox -All -Name "Widescreen"     -Text "16:9 Widescreen (Advanced)"   -Info "Patches true 16:9 widescreen with the HUD pushed to the edges.`n`nKnown Issue: Stretched Notebook screen"    -Native -Credits "Granny Story images by Nerrel, Widescreen Patch by gamemasterplc, enhanced and ported by GhostlyDark"
    CreateReduxCheckBox -All -Name "WidescreenAlt"  -Text "16:9 Widescreen (Simplified)" -Info "Apply 16:9 Widescreen adjusted backgrounds and textures (as well as 16:9 Widescreen for the Wii VC)"                 -Credits "Aspect Ratio Fix by Admentus`n16:9 backgrounds by GhostlyDark & ShadowOne333" -Link $Redux.Graphics.Widescreen
    CreateReduxCheckBox -All -Name "ExtendedDraw"   -Text "Extended Draw Distance"       -Info "Increases the game's draw distance for objects`nDoes not work on all objects"                                        -Credits "Admentus"
    CreateReduxCheckBox -All -Name "PixelatedStars" -Text "Disable Pixelated Stars"      -Info "Completely disable stars during the night, which are pixelated dots and do not have any textures for HD replacement" -Credits "Admentus"
    
    if (!$IsWiiVC)   { $info = "`n`n--- WARNING ---`nDisabling cutscene effects fixes temporary issues with both Widescreen and Redux patched where garbage pixels at the edges of the screen or garbled text appears`nWorkaround: Resize the window when that happens" }
    else             { $info = "" }
    CreateReduxCheckBox -All -Name "MotionBlur"       -Text "Disable Motion Blur"       -Info ("Completely disable the use of motion blur in-game" + $info)                -Credits "GhostlyDark"
    CreateReduxCheckBox -All -Name "FlashbackOverlay" -Text "Disable Flashback Overlay" -Info ("Disables the overlay shown during Princess Zelda flashback scene" + $info) -Credits "GhostlyDark"

    CreateReduxComboBox -All -Name "ChildModels" -Text "Hylian Model" -Items (@("Original") + (LoadModelsList -Category "Child")) -Default "Original" -Info "Replace the Hylian model used for Link"



    # MODELS PREVIEW #

    CreateReduxGroup -All -Tag "Graphics" -Text "Model Previews"
    $Last.Group.Height = (DPISize 223)
    CreateImageBox -All -x 140  -y 25 -w 120 -h 180 -Name "ModelsPreviewChild"
    $global:PreviewToolTip = CreateToolTip
    ChangeModelsSelection



    # INTERFACE #

    CreateReduxGroup    -All -Tag  "UI" -Text "Interface" -Height 4
    $Last.Group.Width = $Redux.Groups[$Redux.Groups.Length-3].Width; $Last.Group.Top = $Redux.Groups[$Redux.Groups.Length-3].Bottom + 5; $Last.Width = 4;

    CreateReduxComboBox -All -Name "Rupees"           -Text "Rupees Icon" -Items @("Majora's Mask") -FilePath ($Paths.shared + "\HUD\Rupees") -Ext "bin" -Default "Majora's Mask" -Info "Set the style for the rupees icon"                                                                 -Credits "Ported by GhostlyDark & AndiiSyn"
    CreateReduxComboBox -All -Name "Hearts"           -Text "Heart Icons" -Items @("Majora's Mask") -FilePath ($Paths.shared + "\HUD\Hearts") -Ext "bin" -Default "Majora's Mask" -Info "Set the style for the heart icons"                                                                 -Credits "Ported by GhostlyDark & AndiiSyn"
    CreateReduxComboBox -All -Name "Magic"            -Text "Magic Bar"   -Items @("Majora's Mask") -FilePath ($Paths.shared + "\HUD\Magic")  -Ext "bin" -Default "Majora's Mask" -Info "Set the style for the magic meter"                                                                 -Credits "GhostlyDark, Pizza, Nerrel (HD), Zeth Alkar"
    CreateReduxCheckBox -All -Name "BlackBars"        -Text "No Black Bars"                                                                                                       -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes" -Credits "Admentus"
    CreateReduxCheckBox -All -Name "GCScheme"         -Text "GC Scheme"                                                                                                           -Info "Replace the textures to match the GameCube's scheme"                                               -Credits "Admentus & GhostlyDark"
    CreateReduxCheckBox -All -Name "DungeonKeys"      -Text "OoT Key Icon"                                                                                                        -Info "Replace the key icon with that from Ocarina of Time"                                               -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -All -Name "CenterTatlPrompt" -Text "Center Tatl Prompt"                                                                                                  -Info 'Centers the "Tatl" prompt shown in the C-Up button'                                                -Credits "Ported by GhostlyDark"


    # BUTTONS #

    CreateReduxGroup    -All -Tag  "UI" -Text "Buttons"
    CreateReduxComboBox -All -Name "ButtonStyle" -Items @("Majora's Mask") -FilePath ($Paths.shared + "\Buttons") -Ext "bin" -Default "Majora's Mask"           -Text "Buttons Style" -Info "Set the style for the HUD buttons"  -Credits "GhostlyDark, Pizza (HD) Djipi, Community, Nerrel, Federelli, AndiiSyn"  
    CreateReduxComboBox -All -Name "Layout"      -Items @("Majora's Mask", "Ocarina of Time", "Nintendo", "Modern", "GameCube (Original)", "GameCube (Modern)") -Text "HUD Layout"    -Info "Set the layout for the HUD Buttons" -Credits "Admentus" 
    
    CreateReduxTextBox  -All -Name "AButtonScale"      -Text "A Button Scale" -Value 35 -Min 15 -Max 35 -Info "Set the scale of the A Button"       -Credits "Admentus" -Row 2 -Column 1 
    CreateReduxTextBox  -All -Name "BButtonScale"      -Text "B Button Scale" -Value 29 -Min 15 -Max 30 -Info "Set the scale of the B Button"       -Credits "Admentus"
    CreateReduxTextBox  -All -Name "CLeftButtonScale"  -Text "C-Left Scale"   -Value 27 -Min 15 -Max 30 -Info "Set the scale of the C-Left Button"  -Credits "Admentus"
    CreateReduxTextBox  -All -Name "CDownButtonScale"  -Text "C-Down Scale"   -Value 27 -Min 15 -Max 30 -Info "Set the scale of the C-Down Button"  -Credits "Admentus"
    CreateReduxTextBox  -All -Name "CRightButtonScale" -Text "C-Right Scale"  -Value 27 -Min 15 -Max 30 -Info "Set the scale of the C-Right Button" -Credits "Admentus"


    
    # HIDE HUD #

    CreateReduxGroup    -All -Tag  "Hide"           -Text "Hide HUD"
    CreateReduxCheckBox -All -Name "AButton"        -Text "Hide A Button"        -Info "Hide the A Button"                                                                              -Credits "Marcelo20XX"
    CreateReduxCheckBox -All -Name "BButton"        -Text "Hide B Button"        -Info "Hide the B Button"                                                                              -Credits "Marcelo20XX"
    CreateReduxCheckBox -All -Name "CButtons"       -Text "Hide C Buttons"       -Info "Hide the C Buttons"                                                                             -Credits "Marcelo20XX"
    CreateReduxCheckBox -All -Name "Hearts"         -Text "Hide Hearts"          -Info "Hide the Hearts display"                                                                        -Credits "Marcelo20XX"
    CreateReduxCheckBox -All -Name "Magic"          -Text "Hide Magic & Rupees"  -Info "Hide the Magic & Rupees display"                                                                -Credits "Marcelo20XX"
    CreateReduxCheckBox -All -Name "AreaTitle"      -Text "Hide Area Title Card" -Info "Hide the area title that displays when entering a new area"                                     -Credits "Marcelo20XX"
    CreateReduxCheckBox -All -Name "Clock"          -Text "Hide Clock"           -Info "Hide the Clock display"                                                                         -Credits "Marcelo20XX"
    CreateReduxCheckBox -All -Name "CountdownTimer" -Text "Hide Countdown Timer" -Info "Hide the countdown timer that displays during the final hours before the Moon will hit Termina" -Credits "Marcelo20XX"
    CreateReduxCheckBox -All -Name "Credits"        -Text "Hide Credits"         -Info "Do not show the credits text during the credits sequence"                                       -Credits "Admentus"



    # STYLES #

    CreateReduxGroup    -All -Tag  "Styles"        -Text "Styles"         -Columns 4
    CreateReduxComboBox -All -Name "RegularChests" -Text "Regular Chests" -Info "Use a different style for regular treasure chests"                                           -FilePath ($Paths.shared + "\Chests")               -Ext "front" -Items @("Regular")           -Credits "Nintendo, Syeo, AndiiSyn & Rando"
    CreateReduxComboBox -All -Name "LeatherChests" -Text "Leather Chests" -Info "Use a different style for leathered treasure chests"                                         -FilePath ($Paths.shared + "\Chests")               -Ext "front" -Items @("Leather")           -Credits "Nintendo, Syeo, AndiiSyn & Rando"
    CreateReduxComboBox -All -Name "BossChests"    -Text "Boss Chests"    -Info "Use a different style for Boss Key treasure chests"                                          -FilePath ($Paths.shared + "\Chests")               -Ext "front" -Items @("Boss MM")           -Credits "Nintendo, Syeo, AndiiSyn & Rando"
    CreateReduxComboBox -All -Name "Crates"        -Text "Small Crates"   -Info "Use a different style for small liftable crates"                                             -FilePath ($Paths.shared + "\Crates")               -Ext "bin"   -Items @("Regular")           -Credits "Nintendo & Rando"
    CreateReduxComboBox -All -Name "Pots"          -Text "Pots"           -Info "Use a different style for throwable pots"                                                    -FilePath ($Paths.shared + "\Pots")                 -Ext "bin"   -Items @("Regular")           -Credits "Nintendo, Syeo & Rando"
    CreateReduxComboBox -All -Name "HairColor"     -Text "Hair Color"     -Info "Use a different hair color style for Link`nOnly for Ocarina of Time or Majora's Mask models" -FilePath ($Paths.shared + "\Hair\Ocarina of Time") -Ext "bin"   -Items @("Default", "Blonde") -Credits "Third M & AndiiSyn"



    # HUD PREVIEWS #

    CreateReduxGroup -All -Tag "UI" -Text "HUD Previews"
    $Last.Group.Height = (DPISize 162)

    CreateImageBox -All -x 40  -y 30 -w 90  -h 90 -Name "ButtonPreview";      $Redux.UI.ButtonStyle.Add_SelectedIndexChanged( { ShowHUDPreview } )
    CreateImageBox -All -x 220 -y 35 -w 40  -h 40 -Name "RupeesPreview";      $Redux.UI.Rupees.Add_SelectedIndexChanged(      { ShowHUDPreview } )
    CreateImageBox -All -x 160 -y 35 -w 40  -h 40 -Name "HeartsPreview";      $Redux.UI.Hearts.Add_SelectedIndexChanged(      { ShowHUDPreview } )
    CreateImageBox -All -x 140 -y 85 -w 200 -h 40 -Name "MagicPreview";       $Redux.UI.Magic.Add_SelectedIndexChanged(       { ShowHUDPreview } )
    CreateImageBox -All -x 280 -y 35 -w 40  -h 40 -Name "DungeonKeysPreview"; $Redux.UI.DungeonKeys.Add_CheckStateChanged(    { ShowHUDPreview } )
    ShowHUDPreview -IsMM

}



#==============================================================================================================================================================================================
function CreateTabAudio() {
    
    # SOUNDS / VOICES / SFX SOUND EFFECTS #

    CreateReduxGroup    -All -Tag  "Sounds" -Text "Sounds / Voices / SFX Sound Effects" -Height 3
    CreateReduxComboBox -All -Name "LowHP"             -Column 5 -Row 1 -Text "Low HP SFX" -Items @("Default", "Disabled", "Soft Beep")  -Info "Set the sound effect for the low HP beeping" -Credits "Ported from Rando"
    

    $SFX =  @("Ocarina", "Deku Pipes", "Goron Drums", "Zora Guitar", "Female Voice", "Bell", "Cathedral Bell", "Piano", "Soft Harp", "Harp", "Accordion", "Bass Guitar", "Flute", "Whistling Flute", "Gong", "Elder Goron Drums", "Choir", "Arguing", "Tatl", "Giants Singing", "Ikana King", "Frog Croak", "Beaver", "Eagle Seagull", "Dodongo")
    CreateReduxComboBox -All -Name "InstrumentHylian"  -Column 1 -Row 1 -Text "Instrument (Hylian)" -Default 1 -Items $SFX -Info "Replace the sound used for playing the Ocarina of Time in Hylian Form" -Credits "Ported from Rando"
    CreateReduxComboBox -All -Name "InstrumentDeku"    -Column 3 -Row 1 -Text "Instrument (Deku)"   -Default 2 -Items $SFX -Info "Replace the sound used for playing the Deku Pipes in Deku Form"        -Credits "Ported from Rando"
    CreateReduxComboBox -All -Name "InstrumentGoron"   -Column 1 -Row 2 -Text "Instrument (Goron)"  -Default 3 -Items $SFX -Info "Replace the sound used for playing the Goron Drums in Goron Form"      -Credits "Ported from Rando"
    CreateReduxComboBox -All -Name "InstrumentZora"    -Column 3 -Row 2 -Text "Instrument (Zora)"   -Default 4 -Items $SFX -Info "Replace the sound used for playing the Zora Guitar in Zora Form"       -Credits "Ported from Rando"
    
    CreateReduxComboBox -All -Name "ChildVoices"       -Column 1 -Row 3 -Text "Child Voice"        -Items @("Original") -FilePath ($GameFiles.binaries + "\Voices Child")        -Default "Original" -Info "Replace the voice used for the Child Link Model"        -Credits "`nOcarina of Time: Phantom Natsu"
    CreateReduxComboBox -All -Name "FierceDeityVoices" -Column 3 -Row 3 -Text "Fierce Deity Voice" -Items @("Original") -FilePath ($GameFiles.binaries + "\Voices Fierce Deity") -Default "Original" -Info "Replace the voice used for the Fierce Deity Link Model" -Credits "`nOcarina of Time: Phantom Natsu"



    # MUSIC #

    if ($GamePatch.title -like "*Master Quest*")   { MusicOptions -Default "Milk Bar Latte" }
    else                                           { MusicOptions }

}



#==============================================================================================================================================================================================
function CreateTabDifficulty() {
    
    # HERO MODE #

    $items1 = @("1 Monster HP","0.5x Monster HP", "1x Monster HP", "1.5x Monster HP", "2x Monster HP", "2.5x Monster HP", "3x Monster HP", "3.5x Monster HP", "4x Monster HP", "5x Monster HP")
    $items2 = @("1 Mini-Boss HP", "0.5x Mini-Boss HP", "1x Mini-Boss HP", "1.5x Mini-Boss HP", "2x Mini-Boss HP", "2.5x Mini-Boss HP", "3x Mini-Boss HP", "3.5x Mini-Boss HP", "4x Mini-Boss HP", "5x Mini-Boss HP")
    $items3 = @("1 Boss HP", "0.5x Boss HP", "1x Boss HP", "1.5x Boss HP", "2x Boss HP", "2.5x Boss HP", "3x Boss HP", "3.5x Boss HP", "4x Boss HP", "5x Boss HP")
    if ($GamePatch.title -like "*Master Quest*") { $default = 2 } else { $default = 1 }

    CreateReduxGroup    -All -Tag  "Hero" -Text "Hero Mode"
    CreateReduxComboBox -All -Name "MonsterHP"  -Text "Monster HP"   -Items $items1 -Default 3                                                        -Info "Set the amount of health for monsters"                                -Credits "Admentus" -Warning "Some enemies are missing"
    CreateReduxComboBox -All -Name "MiniBossHP" -Text "Mini-Boss HP" -Items $items2 -Default 3                                                        -Info "Set the amount of health for elite monsters and mini-bosses"          -Credits "Admentus" -Warning "Some Mini-bosses are missing"
    CreateReduxComboBox -All -Name "BossHP"     -Text "Boss HP"      -Items $items3 -Default 3                                                        -Info "Set the amount of health for bosses"                                  -Credits "Admentus" -Warning "Goht (phases 3) and Gyorg (phase 2) are missing"
    CreateReduxComboBox -All -Name "Damage"     -Text "Damage"       -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage", "OHKO Mode")        -Info "Set the amount of damage you receive`nOHKO Mode = You die in one hit" -Credits "Admentus" -Default $default
    CreateReduxComboBox -All -Name "Recovery"   -Text "Recovery"     -Items @("1x Recovery", "1/2x Recovery", "1/4x Recovery", "0x Recovery")         -Info "Set the amount health you recovery from Recovery Hearts"              -Credits "Admentus"
    CreateReduxComboBox -All -Name "MagicUsage" -Text "Magic Usage"  -Items @("1x Magic Usage", "2x Magic Usage", "4x Magic Usage", "8x Magic Usage") -Info "Set the amount of times magic is consumed at"                         -Credits "Admentus"
    
    $Redux.Hero.Damage.Add_SelectedIndexChanged({ EnableElem -Elem $Redux.Hero.Recovery -Active ($this.Text -ne "OHKO Mode") })
    EnableElem -Elem $Redux.Hero.Recovery -Active ($Redux.Hero.Damage.Text -ne "OHKO Mode")



    # HERO MODE #

    CreateReduxGroup    -All -Tag  "Hero" -Text "Hero Mode"
    CreateReduxComboBox -All -Name "Ammo"                      -Text "Ammo Usage" -Items @("1x Ammo Usage", "2x Ammo Usage", "4x Ammo Usage", "8x Ammo Usage") -Info "Set the amount of times ammo is consumed at"                                                 -Credits "Admentus"
    CreateReduxComboBox -All -Name "DamageEffect"              -Text "Damage Effect"               -Items @("Default", "Burn", "Freeze", "Shock", "Knockdown") -Info "Add an effect when damaged"                                                                  -Credits "Ported from Rando"
    CreateReduxComboBox -All -Name "ClockSpeed"                -Text "Clock Speed"                 -Items @("Default", "1/3", "2/3", "2x", "3x", "6x", "10x")  -Info "Set the speed at which time is progressing"                                                  -Credits "Ported from Rando"
    CreateReduxComboBox -All -Name "ItemDrops"                 -Text "Item Drops"                  -Items @("Default", "No Hearts", "Only Rupees", "Nothing")  -Info "Set the items that will drop from grass, pots and more"                                      -Credits "Admentus, Third M & BilonFullHDemon"
    CreateReduxCheckBox -All -Name "PalaceRoute"               -Text "Restore Palace Route"                                                                    -Info "Restore the route to the Bean Seller within the Deku Palace as seen in the Japanese release" -Credits "ShadowOne"
    CreateReduxCheckBox -All -Name "RaisedResearchLabPlatform" -Text "Raised Research Lab Platform"                                                            -Info "Raise the platform leading up to the Research Laboratory as in the Japanese release"         -Credits "Linkz"
    CreateReduxCheckBox -All -Name "DeathIsMoonCrash"          -Text "Death is Moon Crash"                                                                     -Info "If you die, the moon will crash`nThere are no continues anymore"                             -Credits "Ported from Rando"
    CreateReduxCheckBox      -Name "CloseBombShop"             -Text "Close Bomb Shop"                                                                         -Info "The bomb shop is now closed and the bomb bag is now found somewhere else"                    -Credits "Admentus (ported) & DeathBasket (ROM hack)"
    CreateReduxCheckBox -All -Name "PermanentKeese"            -Text "Permanent Keese"                                                                         -Info "Fire Keese or Ice Keese won't turn into regular Keese after hitting Link"                    -Credits "Garo-Mastah"
    CreateReduxCheckBox -All -Name "FasterIronKnuckles"        -Text "Faster Iron Knuckles"                                                                    -Info "Iron Knuckles now always run, even when in their armored form"                               -Credits "Garo-Mastah"
    CreateReduxCheckBox -All -Name "LargeIronKnuckles"         -Text "Large Iron Knuckles"                                                                     -Info "Iron Knuckles now now much bigger"                                                           -Credits "Garo-Mastah"



    # MAGIC #

    CreateReduxGroup   -All -Tag  "Magic"      -Text "Magic Costs"
    CreateReduxTextBox -All -Name "FireArrow"  -Text "Fire Arrow"  -Value 4 -Max 96 -Info "Set the magic cost for using Fire Arrows´n48 is the maximum amount of the standard magic meter´n96 is the maximum amount of the double magic meter"  -Credits "Garo-Mastah"
    CreateReduxTextBox -All -Name "IceArrow"   -Text "Ice Arrow"   -Value 4 -Max 96 -Info "Set the magic cost for using Ice Arrows´n48 is the maximum amount of the standard magic meter´n96 is the maximum amount of the double magic meter"   -Credits "Garo-Mastah"
    CreateReduxTextBox -All -Name "LightArrow" -Text "Light Arrow" -Value 8 -Max 96 -Info "Set the magic cost for using Light Arrows´n48 is the maximum amount of the standard magic meter´n96 is the maximum amount of the double magic meter" -Credits "Garo-Mastah"
    CreateReduxTextBox -All -Name "DekuBubble" -Text "Deku Bubble" -Value 2 -Max 96 -Info "Set the magic cost for using Deku Bubbles´n48 is the maximum amount of the standard magic meter´n96 is the maximum amount of the double magic meter" -Credits "retroben"



    # EASY MODE #

    CreateReduxGroup    -All -Tag  "EasyMode" -Text "Easy Mode"
    CreateReduxComboBox -All -Name "KeepBottles"         -Text "Keep Bottle Contents"   -Info "Keep the contents of your bottles after rewinding time"                        -Credits "Admentus" -Items @("Disabled", "Potions & Fairies Only", "Everything")
    CreateReduxCheckbox -All -Name "NoBlueBubbleRespawn" -Text "No Blue Bubble Respawn" -Info "Removes the respawn of the Blue Bubble monsters (until you re-enter the room)" -Credits "Garo-Mastah"
    CreateReduxCheckbox -All -Name "NoTakkuriSteal"      -Text "No Takkuri Steal"       -Info "The Takkuri in Termina Field will no longer steal items from Link"             -Credits "Admentus"
    CreateReduxCheckbox -All -Name "NoShieldSteal"       -Text "No Shield Steal"        -Info "Like-Likes will no longer steal the Hero's Shield from Link"                   -Credits "Admentus"
    CreateReduxCheckbox -All -Name "KeepAmmo"            -Text "Keep Ammo"              -Info "Keep consumable items like ammo for items after rewinding time"                -Credits "Admentus"

}



#==============================================================================================================================================================================================
function CreateTabColors() {
    
    # TUNIC COLORS #

    CreateReduxGroup    -All -Tag  "Colors" -Text "Tunic Colors" -Columns 5
    $Colors = @("Kokiri Green", "Goron Red", "Zora Blue", "Black", "White", "Azure Blue", "Vivid Cyan", "Light Red", "Fuchsia", "Purple", "Majora Purple", "Twitch Purple", "Persian Rose", "Dirty Yellow", "Blush Pink", "Hot Pink", "Rose Pink", "Orange", "Gray", "Gold", "Silver", "Beige", "Teal", "Blood Red", "Blood Orange", "Royal Blue", "Sonic Blue", "NES Green", "Dark Green", "Lumen", "Randomized", "Custom")
    CreateReduxComboBox -All -Name "KokiriTunic" -Column 1 -Text "Kokiri Tunic Color" -Length 230 -Shift 70 -Items $Colors -Info ("Select a color scheme for the Kokiri Tunic`n" + '"Randomized" fully randomizes the colors each time the patcher is opened') -Credits "Ported from Rando"
    $Redux.Colors.KokiriTunicButton = CreateReduxButton -All -Column 3 -Text "Kokiri Tunic" -Width 100  -Info "Select the color you want for the Kokiri Tunic" -Credits "Ported from Rando"
    $Redux.Colors.KokiriTunicButton.Add_Click({ $Redux.Colors.SetKokiriTunic.ShowDialog(); $Redux.Colors.KokiriTunic.Text = "Custom"; $Redux.Colors.KokiriTunicLabel.BackColor = $Redux.Colors.SetKokiriTunic.Color; $GameSettings["Hex"][$Redux.Colors.SetKokiriTunic] = $Redux.Colors.SetKokiriTunic.Color.Name })
    $Redux.Colors.SetKokiriTunic   = CreateColorDialog -All -Name "SetKokiriTunic" -Color "1E691B" -IsGame -Button $Redux.Colors.KokiriTunicButton
    $Redux.Colors.KokiriTunicLabel = CreateReduxColoredLabel -All -Link $Redux.Colors.KokiriTunicButton -Color $Redux.Colors.SetKokiriTunic.Color

    $Redux.Colors.KokiriTunic.Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.KokiriTunic -Dialog $Redux.Colors.SetKokiriTunic -Label $Redux.Colors.KokiriTunicLabel })
    SetTunicColorsPreset -All -ComboBox $Redux.Colors.KokiriTunic -Dialog $Redux.Colors.SetKokiriTunic -Label $Redux.Colors.KokiriTunicLabel

    $Redux.Graphics.ChildModels.Add_SelectedIndexChanged({ EnableElem -Elem @($Redux.Colors.KokiriTunic, $Redux.Colors.KokiriTunicButton) -Active ($this.selectedIndex -eq 0) })
    EnableElem -Elem @($Redux.Colors.KokiriTunic, $Redux.Colors.KokiriTunicButton) -Active ($Redux.Graphics.ChildModels.selectedIndex -eq 0)



    # MISC COLORS #

    CreateReduxGroup    -All -Tag  "Colors" -Text "Misc Colors"
    CreateReduxCheckBox -All -Name "RedIce" -Text "Red Ice" -Info "Recolors the ice blocks which can be unfrozen from blue to red" -Credits "Garo-Mastah"



    # FORM COLORS #

    CreateReduxGroup    -All -Tag  "Colors" -Text "Mask Form Colors"
    CreateReduxComboBox -All -Name "DekuLink"  -Column 1 -Text "Deku Link Color"  -Length 170 -Shift 30 -Items @("Green") -FilePath ($GameFiles.Textures + "\Color - Deku Link")         -Info "Select a color scheme for Deku Link"  -Credits "Admentus, ShadowOne333 & Garo-Mastah"
    CreateReduxComboBox -All -Name "GoronLink" -Column 3 -Text "Goron Link Color" -Length 170 -Shift 30 -Items @("Green") -FilePath ($GameFiles.Textures + "\Color - Goron Link")        -Info "Select a color scheme for Goron Link" -Credits "Admentus, ShadowOne333 & Garo-Mastah"
    CreateReduxComboBox -All -Name "ZoraLink"  -Column 5 -Text "Zora Link Color"  -Length 170 -Shift 30 -Items @("Green") -FilePath ($GameFiles.Textures + "\Color - Zora Link\Palette") -Info "Select a color scheme for Zora Link"  -Credits "Admentus, ShadowOne333 & Garo-Mastah"

    $Redux.Colors.DekuLinkLabel = CreateLabel -X ($Redux.Colors.DekuLink.Right + (DPISize 15)) -Y $Redux.Colors.DekuLink.Top -Width (DPISize 40) -Height (DPISize 20) -AddTo $Last.Group
    $Redux.Colors.DekuLink.Add_SelectedIndexChanged({ SetFormColorLabel -ComboBox $Redux.Colors.DekuLink -Label $Redux.Colors.DekuLinkLabel })
    SetFormColorLabel -ComboBox $Redux.Colors.DekuLink -Label $Redux.Colors.DekuLinkLabel

    $Redux.Colors.GoronLinkLabel = CreateLabel -X ($Redux.Colors.GoronLink.Right + (DPISize 15)) -Y $Redux.Colors.GoronLink.Top -Width (DPISize 40) -Height (DPISize 20) -AddTo $Last.Group
    $Redux.Colors.GoronLink.Add_SelectedIndexChanged({ SetFormColorLabel -ComboBox $Redux.Colors.GoronLink -Label $Redux.Colors.GoronLinkLabel })
    SetFormColorLabel -ComboBox $Redux.Colors.GoronLink -Label $Redux.Colors.GoronLinkLabel

    $Redux.Colors.ZoraLinkLabel = CreateLabel -X ($Redux.Colors.ZoraLink.Right + (DPISize 15)) -Y $Redux.Colors.ZoraLink.Top -Width (DPISize 40) -Height (DPISize 20) -AddTo $Last.Group
    $Redux.Colors.ZoraLink.Add_SelectedIndexChanged({ SetFormColorLabel -ComboBox $Redux.Colors.ZoraLink -Label $Redux.Colors.ZoraLinkLabel })
    SetFormColorLabel -ComboBox $Redux.Colors.ZoraLink -Label $Redux.Colors.ZoraLinkLabel
    


    # COLORS #

    CreateSpinAttackColorOptions
    CreateFairyColorOptions -Name "Tatl"
    $Last.Group.Height = (DPISize 140)

    $items = @("Tatl", "Tael", "Navi", "Gold", "Green", "Light Blue", "Yellow", "Red", "Magenta", "Black", "Fi", "Ciela", "Epona", "Ezlo", "King of Red Lions", "Linebeck", "Loftwing", "Midna", "Phantom Zelda", "Randomized", "Custom")
    CreateReduxComboBox -All -Name "Tael" -Column 1 -Row 3 -Length 230 -Shift 40 -Items $items -Default "Tael" -Text "Tael Colors" -Info ("Select a color scheme for Tael`n" + '"Randomized" fully randomizes the colors each time the patcher is opened') -Credits "By ShadowOne333"
    $items = $null

    # Tael Colors - Buttons
    $Buttons = @()
    $Buttons += CreateReduxButton -All -Column 3 -Row 3 -Width 100 -Tag $Buttons.Count -Text "Cutscene (Inner)" -Info "Select the color you want for the Inner Idle stance for Tael"  -Credits "ShadowOne333"
    $Buttons += CreateReduxButton -All -Column 3 -Row 4 -Width 100 -Tag $Buttons.Count -Text "Cutscene (Outer)" -Info "Select the color you want for the Outer Idle stance for Tael"  -Credits "ShadowOne333"

    # Tael Colors - Dialogs
    $Redux.Colors.SetTael = @()
    $Redux.Colors.SetTael += CreateColorDialog -All -Color "3F125D" -Name "SetTaelIdleInner" -IsGame -Button $Buttons[0]
    $Redux.Colors.SetTael += CreateColorDialog -All -Color "FA280A" -Name "SetTaelIdleOuter" -IsGame -Button $Buttons[1]

    # Tael Colors - Labels
    $Redux.Colors.TaelLabels = @()
    for ($i=0; $i -lt $Buttons.length; $i++) {
    	$Buttons[$i].Add_Click({ $Redux.Colors.SetTael[[int16]$this.Tag].ShowDialog(); $Redux.Colors.Tael.Text = "Custom"; $Redux.Colors.TaelLabels[[int16]$this.Tag].BackColor = $Redux.Colors.SetTael[[int16]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetTael[[int16]$this.Tag].Tag] = $Redux.Colors.SetTael[[int16]$this.Tag].Color.Name })
    	$Redux.Colors.TaelLabels += CreateReduxColoredLabel -All -Link $Buttons[$i] -Color $Redux.Colors.SetTael[$i].Color
    }

    $Redux.Colors.Tael.Add_SelectedIndexChanged({ SetFairyColorsPreset -ComboBox $Redux.Colors.Tael -Dialogs $Redux.Colors.SetTael -Labels $Redux.Colors.TaelLabels })
    SetFairyColorsPreset -ComboBox $Redux.Colors.Tael -Dialogs $Redux.Colors.SetTael -Labels $Redux.Colors.TaelLabels

}



#==============================================================================================================================================================================================
function CreateTabEquipment() {
    
    # CAPACITY SELECTION #

    CreateReduxGroup    -All -Tag  "Capacity" -Text "Capacity Selection"
    CreateReduxCheckBox -All -Name "EnableAmmo"    -Text "Change Ammo Capacity"   -Info "Enable changing the capacity values for ammo"
    CreateReduxCheckBox -All -Name "EnableWallet"  -Text "Change Wallet Capacity" -Info "Enable changing the capacity values for the wallets"



    # GAMEPLAY #

    CreateReduxGroup    -All -Tag  "Gameplay"         -Text "Gameplay"
    CreateReduxCheckBox -All -Name "UnsheathSword"    -Text "Unsheath Sword"      -Info "The sword is unsheathed first before immediately swinging it"                                             -Credits "Admentus"
    CreateReduxCheckBox -All -Name "SwordBeamAttack"  -Text "Sword Beam Attack"   -Info "Replaces the Spin Attack with the Sword Beam Attack`nYou can still perform the Quick Spin Attack"         -Credits "Admentus (ROM hack) & CloudModding (GameShark)"
    CreateReduxCheckBox -All -Name "FixEponaSword"    -Text "Fix Epona Sword"     -Info "Change Epona's B button behaviour to prevent you from losing your sword if you don't have the Hero's Bow" -Credits "Ported from Rando"
    CreateReduxComboBox -All -Name "SpinAttack"       -Text "Spin Attack"         -Info "Make the Regular & Great Spin Attacks smaller in range, disable the Quick Great Spin or change both"      -Credits "Admentus" -Items @("Original", "Smaller Range", "No Great Quick Spin", "Both")



    # HITBOX #

    CreateReduxGroup  -All -Tag  "Equipment" -Text "Sliders" -Height 2.7
    CreateReduxSlider -All -Name "KokiriSword"      -Column 1 -Row 1 -Default 3000 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Kokiri Sword"        -Info "Set the length of the hitbox of the Kokiri Sword"              -Credits "Aria Hiroshi 64"
    CreateReduxSlider -All -Name "RazorSword"       -Column 3 -Row 1 -Default 3000 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Razor Sword"         -Info "Set the length of the hitbox of the Razor Sword"               -Credits "Aria Hiroshi 64"
    CreateReduxSlider -All -Name "GildedSword"      -Column 5 -Row 1 -Default 4000 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Gilded Sword"        -Info "Set the length of the hitbox of the Gilded Sword"              -Credits "Aria Hiroshi 64"
    CreateReduxSlider -All -Name "GreatFairysSword" -Column 1 -Row 2 -Default 5500 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Great Fairy's Sword" -Info "Set the length of the hitbox of the Great Fairy's Sword Knife" -Credits "Aria Hiroshi 64"
    CreateReduxSlider -All -Name "BlastMask"        -Column 3 -Row 2 -Default 310  -Min 1   -Max 1024 -Freq 64  -Small 32  -Large 64  -Text "Blast Mask"          -Info "Set the cooldown duration of the Blast Mask"                   -Credits "Ported from Rando"
    CreateReduxSlider -All -Name "ShieldRecoil"     -Column 5 -Row 2 -Default 4552 -Min 0   -Max 8248 -Freq 512 -Small 256 -Large 512 -Text "Shield Recoil"       -Info "Set the pushback distance when getting hit while shielding"    -Credits "Admentus"



    # WEAPON DAMAGE #

    CreateReduxGroup   -All -Tag  "Attack"             -Text "Weapon Damage"     -Height 4
    CreateReduxTextBox -All -Name "KokiriSlash"        -Text "Kokiri Slash"      -Info "Set the damage dealt when doing a Slash Attack with the Kokiri Sword"                              -Length 2 -Value 1 -Min 1 -Max 20 -Credits "Admentus" -Column 1 -Row 1
    CreateReduxTextBox -All -Name "KokiriJump"         -Text "Kokiri Jump"       -Info "Set the damage dealt when doing a Jump Attack with the Kokiri Sword"                               -Length 2 -Value 2 -Min 1 -Max 20 -Credits "Admentus" -Column 1 -Row 2
    CreateReduxTextBox -All -Name "KokiriSpin"         -Text "Kokiri Spin"       -Info "Set the damage dealt when doing a Spin Attack with the Kokiri Sword"                               -Length 2 -Value 1 -Min 1 -Max 20 -Credits "Admentus" -Column 1 -Row 3
    CreateReduxTextBox -All -Name "KokiriGreatSpin"    -Text "Kokiri Red Spin"   -Info "Set the damage dealt when doing a Great Spin Attack with the Kokiri Sword"                         -Length 2 -Value 1 -Min 1 -Max 20 -Credits "Admentus" -Column 1 -Row 4
    CreateReduxTextBox -All -Name "RazorSlash"         -Text "Razor Slash"       -Info "Set the damage dealt when doing a Slash Attack with the Razor Sword"                               -Length 2 -Value 2 -Min 1 -Max 20 -Credits "Admentus" -Column 2 -Row 1
    CreateReduxTextBox -All -Name "RazorJump"          -Text "Razor Jump"        -Info "Set the damage dealt when doing a Jump Attack the Razor Sword"                                     -Length 2 -Value 4 -Min 1 -Max 20 -Credits "Admentus" -Column 2 -Row 2
    CreateReduxTextBox -All -Name "RazorSpin"          -Text "Razor Spin"        -Info "Set the damage dealt when doing a Spin Attack the Razor Sword"                                     -Length 2 -Value 2 -Min 1 -Max 20 -Credits "Admentus" -Column 2 -Row 3
    CreateReduxTextBox -All -Name "RazorGreatSpin"     -Text "Razor Red Spin"    -Info "Set the damage dealt when doing a Great Spin Attack the Razor Sword"                               -Length 2 -Value 2 -Min 1 -Max 20 -Credits "Admentus" -Column 2 -Row 4
    CreateReduxTextBox -All -Name "GildedSlash"        -Text "Gilded Slash"      -Info "Set the damage dealt when doing a Slash Attack with the Gilded Sword"                              -Length 2 -Value 3 -Min 1 -Max 20 -Credits "Admentus" -Column 3 -Row 1
    CreateReduxTextBox -All -Name "GildedJump"         -Text "Gilded Jump"       -Info "Set the damage dealt when doing a Jump Attack the Gilded Sword"                                    -Length 2 -Value 6 -Min 1 -Max 20 -Credits "Admentus" -Column 3 -Row 2
    CreateReduxTextBox -All -Name "GildedSpin"         -Text "Gilded Spin"       -Info "Set the damage dealt when doing a Spin Attack the Gilded Sword"                                    -Length 2 -Value 3 -Min 1 -Max 20 -Credits "Admentus" -Column 3 -Row 3
    CreateReduxTextBox -All -Name "GildedGreatSpin"    -Text "Gilded Red Spin"   -Info "Set the damage dealt when doing a Great Spin Attack the Gilded Sword"                              -Length 2 -Value 3 -Min 1 -Max 20 -Credits "Admentus" -Column 3 -Row 4
    CreateReduxTextBox -All -Name "TwoHandedSlash"     -Text "2-Handed Slash"    -Info "Set the damage dealt when doing a Slash Attack with the Great Fairy's Sword or Fierce Deity Sword" -Length 2 -Value 4 -Min 1 -Max 20 -Credits "Admentus" -Column 4 -Row 1
    CreateReduxTextBox -All -Name "TwoHandedJump"      -Text "2-Handed Jump"     -Info "Set the damage dealt when doing a Jump Attack the Great Fairy's Sword or Fierce Deity Sword"       -Length 2 -Value 8 -Min 1 -Max 20 -Credits "Admentus" -Column 4 -Row 2
    CreateReduxTextBox -All -Name "TwoHandedSpin"      -Text "2-Handed Spin"     -Info "Set the damage dealt when doing a Spin Attack the Great Fairy's Sword or Fierce Deity Sword"       -Length 2 -Value 4 -Min 1 -Max 20 -Credits "Admentus" -Column 4 -Row 3
    CreateReduxTextBox -All -Name "TwoHandedGreatSpin" -Text "2-Handed Red Spin" -Info "Set the damage dealt when doing a Great Spin Attack the Great Fairy's Sword or Fierce Deity Sword" -Length 2 -Value 4 -Min 1 -Max 20 -Credits "Admentus" -Column 4 -Row 4
    CreateReduxTextBox -All -Name "DekuStickSlash"     -Text "Deku Stick Slash"  -Info "Set the damage dealt when doing a Slash Attack with the Deku Stick"                                -Length 2 -Value 2 -Min 1 -Max 20 -Credits "Admentus" -Column 5 -Row 1
    CreateReduxTextBox -All -Name "DekuStickJump"      -Text "Deku Stick Jump"   -Info "Set the damage dealt when doing a Jump Attack the Deku Stick"                                      -Length 2 -Value 4 -Min 1 -Max 20 -Credits "Admentus" -Column 5 -Row 2
    CreateReduxTextBox -All -Name "GoronPunch"         -Text "Goron Punch"       -Info "Set the damage dealt when doing a Goron Punch"                                                     -Length 2 -Value 2 -Min 1 -Max 20 -Credits "Admentus" -Column 6 -Row 1
    CreateReduxTextBox -All -Name "ZoraPunch"          -Text "Zora Punch"        -Info "Set the damage dealt when doing a Zora Punch"                                                      -Length 2 -Value 1 -Min 1 -Max 20 -Credits "Admentus" -Column 6 -Row 2
    CreateReduxTextBox -All -Name "ZoraJump"           -Text "Zora Jump"         -Info "Set the damage dealt when doing a Zora Jump Attack"                                                -Length 2 -Value 2 -Min 1 -Max 20 -Credits "Admentus" -Column 6 -Row 3
    


    # AMMO #

    $Redux.Box.Ammo = CreateReduxGroup -All -Tag "Capacity" -Text "Ammo Capacity Selection"
    CreateReduxTextBox -All -Name "Quiver1"     -Text "Quiver (1)"      -Value 30  -Info "Set the capacity for the Quiver (Base)"        -Credits "GhostlyDark"
    CreateReduxTextBox -All -Name "Quiver2"     -Text "Quiver (2)"      -Value 40  -Info "Set the capacity for the Quiver (Upgrade 1)"   -Credits "GhostlyDark"
    CreateReduxTextBox -All -Name "Quiver3"     -Text "Quiver (3)"      -Value 50  -Info "Set the capacity for the Quiver (Upgrade 2)"   -Credits "GhostlyDark"
    CreateReduxTextBox -All -Name "BombBag1"    -Text "Bomb Bag (1)"    -Value 20  -Info "Set the capacity for the Bomb Bag (Base)"      -Credits "GhostlyDark" 
    CreateReduxTextBox -All -Name "BombBag2"    -Text "Bomb Bag (2)"    -Value 30  -Info "Set the capacity for the Bomb Bag (Upgrade 1)" -Credits "GhostlyDark"
    CreateReduxTextBox -All -Name "BombBag3"    -Text "Bomb Bag (3)"    -Value 40  -Info "Set the capacity for the Bomb Bag (Upgrade 2)" -Credits "GhostlyDark"
    CreateReduxTextBox -All -Name "DekuSticks1" -Text "Deku Sticks (1)" -Value 10  -Info "Set the capacity for the Deku Sticks (Base)"   -Credits "GhostlyDark"
    CreateReduxTextBox -All -Name "DekuNuts1"   -Text "Deku Nuts (1)"   -Value 20  -Info "Set the capacity for the Deku Nuts (Base)"     -Credits "GhostlyDark"



    # WALLET #

    $Redux.Box.Wallet = CreateReduxGroup -All -Tag "Capacity" -Text "Wallet Capacity Selection"
    CreateReduxTextBox -All -Name "Wallet1" -Length 4 -Text "Wallet (1)" -Value 99   -Info "Set the capacity for the Wallet (Base)"      -Credits "GhostlyDark"
    CreateReduxTextBox -All -Name "Wallet2" -Length 4 -Text "Wallet (2)" -Value 200  -Info "Set the capacity for the Wallet (Upgrade 1)" -Credits "GhostlyDark"
    CreateReduxTextBox -All -Name "Wallet3" -Length 4 -Text "Wallet (3)" -Value 500  -Info "Set the capacity for the Wallet (Upgrade 2)" -Credits "GhostlyDark"
    CreateReduxTextBox -All -Name "Wallet4" -Length 4 -Text "Wallet (4)" -Value 1000 -Info "Set the capacity for the Wallet (Upgrade 3)" -Credits "GhostlyDark" -Warning "This wallet is not obtained through regular gameplay"



    # EQUIPMENT #

    CreateReduxGroup    -All -Tag  "Gameplay"   -Text "Equipment"
    CreateReduxCheckBox -All -Name "RazorSword" -Text "Permanent Razor Sword" -Info "The Razor Sword won't get destroyed after 100 hits`nYou can also keep the Razor Sword when traveling back in time" -Credits "darklord92"



    EnableForm -Form $Redux.Box.Ammo -Enable $Redux.Capacity.EnableAmmo.Checked
    $Redux.Capacity.EnableAmmo.Add_CheckStateChanged({ EnableForm -Form $Redux.Box.Ammo -Enable $Redux.Capacity.EnableAmmo.Checked })
    EnableForm -Form $Redux.Box.Wallet -Enable $Redux.Capacity.EnableWallet.Checked
    $Redux.Capacity.EnableWallet.Add_CheckStateChanged({ EnableForm -Form $Redux.Box.Wallet -Enable $Redux.Capacity.EnableWallet.Checked })

}



#==============================================================================================================================================================================================
function CreateTabSpeedup() {
    
    # SKIP #

    CreateReduxGroup    -All -Tag  "Skip" -Text "Skip"
    CreateReduxCheckBox -All -Name "BossCutscenes"  -Text "Skip Boss Cutscenes"  -Info "Skip the cutscenes that play during bosses and mini-bosses" -Credits "Ported from Rando"
    CreateReduxCheckBox -All -Name "TatlInterrupts" -Text "Skip Tatl Interrupts" -Info "Skip the cutscenes that are triggered by Tatl"              -Credits "Ported from Rando"



    # SPEEDUP #

    CreateReduxGroup    -All -Tag  "Speedup" -Text "Speedup"
    CreateReduxCheckBox -All -Name "LabFish" -Text "Faster Lab Fish"   -Info "Only one fish has to be feeded in the Marine Research Lab"                            -Credits "Ported from Rando"
    CreateReduxCheckBox -All -Name "Dampe"   -Text "Good Dampé RNG"    -Info "Dampé's Digging Game always has two Ghost Flames on the ground and one up the ladder" -Credits "Ported from Rando"
    CreateReduxCheckBox -All -Name "DogRace" -Text "Good Dog Race RNG" -Info "The Gold Dog always wins the Doggy Racetrack race if you have the Mask of Truth"      -Credits "Ported from Rando"



    # WALLET #

    CreateReduxGroup   -All -Tag  "Speedup" -Text "Bank Deposit Rewards"
    CreateReduxTextBox -All -Name "Bank1" -Length 4 -Text "First Reward"  -Value 200  -Info "Set the amount of Rupees required to deposit for the first reward"                                                                               -Credits "Ported from Rando"
    CreateReduxTextBox -All -Name "Bank2" -Length 4 -Text "Second Reward" -Value 1000 -Info "Set the amount of Rupees required to deposit for the second reward"                                                                              -Credits "Ported from Rando"
    CreateReduxTextBox -All -Name "Bank3" -Length 4 -Text "Final Reward"  -Value 5000 -Info "Set the amount of Rupees required to deposit for the final reward`nThis value also changes the maximum amount that can be deposited to the bank" -Credits "Ported from Rando"

}
