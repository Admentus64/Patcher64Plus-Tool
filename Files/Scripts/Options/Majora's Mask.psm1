﻿function PrePatchOptions() {
    
    if (IsChecked $Redux.Graphics.Widescreen)          { ApplyPatch -Patch "Decompressed\Optional\widescreen.ppf"    }
    if (IsDefault $Redux.Features.OcarinaIcons -Not)   { ApplyPatch -Patch "Decompressed\Optional\ocarina_icons.ppf" }

    if ( (IsSet $LanguagePatch.DmaTable)        -and !$Patches.Redux.Checked)   { return }

    if   (IsChecked $Redux.Graphics.Widescreen)                                 { RemoveFile  $Files.dmaTable }
    if ( (IsChecked $Redux.Graphics.Widescreen) -and !$Patches.Redux.Checked)   { Add-Content $Files.dmaTable "0 1 2 3 4 5 6 7 -8 -9 15 16 17 18 19 20 -21 22 -24 25 26 27 28 29 30 -652 1127 -1540 -1541 -1542 -1543 -1544 -1545 -1546 -1547 -1548 -1549 -1550 -1551 1552 1553 1554 1555 1556 1557 1558 1559 1560 1561 1562 1563 1564 1565 1566 1567" }
    if ( (IsChecked $Redux.Graphics.Widescreen) -and  $Patches.Redux.Checked)   { Add-Content $Files.dmaTable "0 1 2 3 4 5 6 7 -8 -9 15 16 17 18 19 20 -21 22 -24 25 26 27 28 29 30 -652 1127 -1540 -1541 -1542 -1543 1544 1545 1546 1547 1548 1549 1550 -1551 1552 1553 1554 1555 1556 1557 1558 1559 1560 1561 1562 1563 1564 1565 1566 1567" }



    # SCENES #

    if (IsChecked $Redux.Gameplay.CustomScenes) {
        if (TestFile $GameFiles.scenesPatch) { ApplyPatch -Patch $GameFiles.scenesPatch -FullPath }
    }

}



#==============================================================================================================================================================================================
function PatchOptions() {
    
    # FIXES #

    if (IsChecked $Redux.Fixes.TextCommands)                { ApplyPatch -Patch "Decompressed\Optional\text_commands.ppf" }
    


    # MODELS #

    if (IsDefault -Elem $Redux.Graphics.ChildModels -Not)   { PatchModel -Category "Child" -Name $GamePatch.LoadedModelsList["Child"][$Redux.Graphics.ChildModels.SelectedIndex] }



    # DIFFICULTY #

    if (IsChecked $Redux.Hero.PiratesFortressInterior)                                           { ApplyPatch -Patch "Decompressed\Optional\pirates_fortress_interior.bps" }
    if (IsChecked $Redux.Hero.MoveGoldDust)                                                      { ApplyPatch -Patch "Decompressed\Optional\chest.ppf"                     }
    if ( (IsValue $Redux.Recovery.Heart -Value 0) -or (IsDefault $Redux.Hero.ItemDrops -Not) )   { ApplyPatch -Patch "Decompressed\Optional\no_recovery_hearts.ppf"        }
    if (IsChecked $Redux.EasyMode.OceansideSpiderHouse)                                          { ApplyPatch -Patch "Decompressed\Optional\oceanside_spider_house.ppf"    }

    

    # EQUIPMENT ADJUSTMENTS #

    if     (IsChecked $Redux.Equipment.MorePowderKegs)            { ApplyPatch -Patch "Decompressed\optional\more_powder_kegs.ppf"               }

    if     (IsIndex -Elem $Redux.Equipment.SpinAttack -Index 2)   { ApplyPatch -Patch "Decompressed\optional\smaller_spin.ppf"                   }
    elseif (IsIndex -Elem $Redux.Equipment.SpinAttack -Index 3)   { ApplyPatch -Patch "Decompressed\optional\no_quick_spin.ppf"                  }
    elseif (IsIndex -Elem $Redux.Equipment.SpinAttack -Index 4)   { ApplyPatch -Patch "Decompressed\optional\no_quick_spin_and_smaller_spin.ppf" }



    # CAPACITY #

    if (IsChecked $Redux.Capacity.EnableWallet) {
        if ($Redux.Capacity.Wallet1.Text.Length -gt 3 -or $Redux.Capacity.Wallet2.Text.Length -gt 3 -or $Redux.Capacity.Wallet3.Text.Length -gt 3 -or $Redux.Capacity.Wallet4.Text.Length -gt 3) { ApplyPatch -Patch "Decompressed\optional\four_digits_wallet.ppf" }
    }

}



#==============================================================================================================================================================================================
function ByteOptions() {
    
    # QUALITY OF LIFE #

    if (IsChecked $Redux.Gameplay.PermanentOwlSaves) {
      ChangeBytes -Offset "BDB990" -Values "00" -Repeat 0xB
      ChangeBytes -Offset "BDAA78" -Values "A240101426A446B80C051CC58E453CA0"
      ChangeBytes -Offset "BDCBBB" -Values "04"
      PatchBytes  -Offset "BDD90B" -Patch  "permanent_owl_saves.bin"
      ChangeBytes -Offset "BEEB78" -Values "55E100168FBF001C0C051DED020020250C051DED020020250C051DED020020250C051DED020020253C06801F24C6F6708CD93CA0240100F0532100088FBF001C10000005A0C000233C010001002D0821241800FFA038" # Don't boot back to main menu, close textbox and remove Owl Save status only after saving is completed
    }

    if (IsChecked $Redux.Gameplay.FormItems) {
        # Item
        ChangeBytes -Offset "C58950" -Values "010000000000010100010100010101"; ChangeBytes -Offset "C58978" -Values "01010101010101010101010101" # Fierce Deity
        ChangeBytes -Offset "C589C8" -Values "0101000101"                                                                                        # Goron
        ChangeBytes -Offset "C58A3A" -Values "0101000101"                                                                                        # Zora
        ChangeBytes -Offset "C58AAF" -Values "0101"                                                                                              # Deku
        
        # Slot
        ChangeBytes -Offset "CA587C" -Values "01000000000001010100010101010101000001" # Fierce Deity
        ChangeBytes -Offset "CA589A" -Values "0101000101"                             # Goron
        ChangeBytes -Offset "CA58B2" -Values "0101000101"                             # Zora
        ChangeBytes -Offset "CA58CD" -Values "0101"                                   # Deku
    }

    if (IsChecked $Redux.Gameplay.FierceDeityAnywhere) {
        ChangeBytes -Offset "BA76D0"  -Values "1000";     ChangeBytes -Offset "E384D8"  -Values "284100021420"; ChangeBytes -Offset "E7A852"  -Values "CA8480A0CA84"; ChangeBytes -Offset "F4D3A4"  -Values "5441002B24060001"; ChangeBytes -Offset "10632C0" -Values "286100021020000200000000A48702C8"
        ChangeBytes -Offset "1068960" -Values "00000000"; ChangeBytes -Offset "1069B60" -Values "24080002";     ChangeBytes -Offset "2704FF7" -Values "A9";           ChangeBytes -Offset "2704FFD" -Values "A9";               ChangeBytes -Offset "C564D8"  -Values "02"
        ChangeBytes -Offset "1069B6C" -Values "2841000301014022A4E802C2A4F902CE00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"

        # Damage Tables Sword Beam
        ChangeBytes -Offset @("CF05C5", "CF350D", "CF56DD", "D10D35", "D10D35", "D13749", "D21895", "D2B2F1", "D2F09D", "D3916D", "D3AFB5", "D3D9D5", "D4DABD", "D512F5", "D55C01", "D55C2D", "D6CFD9", "D76381", "D9F1E9", "D9F209", "DF85CD", "E07001", "E07021", "E0EE45", "E59389", "E5CE29", "E5CE49", "E5F299", "E9B695", "EA5E8D", `
        "EAE535", "EB924D", "EC1F25", "ECBE79", "F3E84D", "F7ED71", "F82DBD", "F949F9", "10489A5", "105A76D", "10785DD") -Values "01"
        ChangeBytes -Offset @("D4774D", "D5F015", "DA7845", "E1BA65", "E23C11", "E9D409", "EB27ED", "EB280D", "EDD629", "EDEC29", "EE2F59", "F666A5", "F8693D", "F9DE41", "FC6621", "FCB989", "FE3699", "FFF715", "100D425", "101D2C9") -Values "F1"
        ChangeBytes -Offset @("D5C0FD", "EE8815", "FEFCC5") -Values "E1"
    }

    if (IsChecked $Redux.Gameplay.RoyalWallet) {
        PatchBytes  -Offset "1372B70" -Patch "royal_wallet.bin"
        ChangeBytes -Offset @("1D337", "C591C7") -Values "F0"

        # Change Deku Stick upgrade into Wallet upgrade
        ChangeBytes -Offset "BA99F7" -Values "7C"   # Royal Wallet item check instead of Deku Stick (20) upgrade check
        ChangeBytes -Offset "BA99FF" -Values "04"   # Deku Stick upgrade to Wallet upgrade
        ChangeBytes -Offset "BA9A1C" -Values "1500" # No Deku Stick check
        ChangeBytes -Offset "BA9A2F" -Values "03"   # Third upgrade
        ChangeBytes -Offset "BA9A3B" -Values "00"   # Affect ammo index slot 0 (Ocarina of Time)
        ChangeBytes -Offset "BA9A47" -Values "2C"   # Ammo to set

        ChangeBytes -Offset "C51C76" -Values "FBFC0600185006001B7006001B90060019A006001BB006001A2806001BD006001AD8" # Draw Royal Wallet instead of unused Hookshot
        ChangeBytes -Offset "CD6C66" -Values "7C A0 2A 32 00 A8"                                                         # Get Item Royal Wallet instead of unused item

        ExportAndPatch -Path "girla"  -Offset "CDDC60" -Length "1B00"
      # ChangeBytes -Offset "CDEA63" -Values "7C"                                       # Give Royal Wallet instead of Mirror Shield when buying item 
      # ChangeBytes -Offset "CDE4C0" -Values "1500"                                     # Remove has no shield check
      # ChangeBytes -Offset "CDF380" -Values "00A80029800B80500001277627780000000000AC" # Royal Wallet shop item instead of unused Mirror Shield shop item
      # ChangeBytes -Offset "CDE4D8" -Values "24020001"                                 # Fanfare 2

      # ChangeBytes -Offset "D263E5" -Values "2A" # Sell Royal Wallet instead of Deku Nuts (10) at Trading Post daytime
        ChangeBytes -Offset "D26425" -Values "2A" # Sell Royal Wallet instead of Deku Nuts (10) at Trading Post nighttime

    }

    if (IsChecked $Redux.Gameplay.NoKillFlash)              { ChangeBytes -Offset "BFE043"  -Values "00"       }
    if (IsChecked $Redux.Gameplay.DisableScreenShrinking)   { ChangeBytes -Offset "EAC2DC"  -Values "00000000" }
    if (IsChecked $Redux.Gameplay.KeepDekuBubble)           { ChangeBytes -Offset "D04843"  -Values "00"       }

    


    # GAMEPLAY #

    if     (IsIndex -Elem $Redux.Gameplay.CremiaReward -Index 2)   { ChangeBytes -Offset "FF3B4C" -Values "00000000" }
    elseif (IsIndex -Elem $Redux.Gameplay.CremiaReward -Index 3)   { ChangeBytes -Offset "FF3B4C" -Values "304B0000" }

    if     (IsIndex -Elem $Redux.Gameplay.LinkJumpAttack -Text "Frontflip")        { ChangeBytes -Offset "1098721" -Values "0B"; PatchBytes  -Offset "75F1B0" -Patch "frontflip_jump_attack.bin" }
    elseif (IsIndex -Elem $Redux.Gameplay.LinkJumpAttack -Text "Beta Frontflip")   { ChangeBytes -Offset "CD72B2"  -Values "D850" }
    elseif (IsIndex -Elem $Redux.Gameplay.LinkJumpAttack -Text "Beta Backflip")    { ChangeBytes -Offset "CD72B2"  -Values "D7F0" }
    elseif (IsIndex -Elem $Redux.Gameplay.LinkJumpAttack -Text "Spin Slash")       { ChangeBytes -Offset "CD72B2"  -Values "D7E0" }
    elseif (IsIndex -Elem $Redux.Gameplay.LinkJumpAttack -Text "Zora Jumpslash")   { ChangeBytes -Offset "CD72B2"  -Values "E3F0" }

    if     (IsIndex -Elem $Redux.Gameplay.ZoraJumpAttack -Text "Beta Frontflip")   { ChangeBytes -Offset "CD72C2"  -Values "D850" }
    elseif (IsIndex -Elem $Redux.Gameplay.ZoraJumpAttack -Text "Beta Backflip")    { ChangeBytes -Offset "CD72C2"  -Values "D7F0" }
    elseif (IsIndex -Elem $Redux.Gameplay.ZoraJumpAttack -Text "Spin Slash")       { ChangeBytes -Offset "CD72C2"  -Values "D7E0" }
    
    if (IsChecked $Redux.Gameplay.ZoraPhysics)            { PatchBytes  -Offset "65D000"  -Patch "zora_physics_fix.bin"                             }
    if (IsChecked $Redux.Gameplay.DistantZTargeting)      { ChangeBytes -Offset "B4E924"  -Values "00000000"                                        }
    if (IsChecked $Redux.Gameplay.ManualJump)             { ChangeBytes -Offset "CB4008"  -Values "04C1"; ChangeBytes -Offset "CB402B" -Values "01" }
    if (IsChecked $Redux.Gameplay.FDSpinAttack)           { ChangeBytes -Offset "CAD780"  -Values "2400"                                            }
    if (IsChecked $Redux.Gameplay.FrontflipJump)          { ChangeBytes -Offset "1098E4D" -Values "2334D0"                                          }
    if (IsChecked $Redux.Gameplay.NoShieldRecoil)         { ChangeBytes -Offset "CAEDD0"  -Values "2400"                                            }
    if (IsChecked $Redux.Gameplay.LeftoverSongs)          { ChangeBytes -Offset "C5CE71"  -Values "02"; ChangeBytes -Offset "C5CE72"  -Values "08"  }
    if (IsChecked $Redux.Gameplay.AcceptBombersCode)      { ChangeBytes -Offset "1069E7F" -Values "00"                                              }



    # GAMEPLAY (UNSTABLE) #

    if (IsChecked $Redux.Gameplay.HookshotAnything)       { ChangeBytes -Offset "D3BA30"  -Values "00000000" }

    

    # RESTORE #

    if (IsChecked $Redux.Restore.RupeeColors) {
        ChangeBytes -Offset "10ED020" -Values "706BBB3FFFFFEF3F68ADC3FDE6BFCD7F489B91AFC37DBB3D400F581988ED80AB" # Purple
        ChangeBytes -Offset "10ED040" -Values "D4C3F749FFFFF7E1DD03EF89E7E3E7DDA343D5C3DF85E7457A438283B443CC83" # Gold
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
    if (IsChecked $Redux.Restore.Title)               { ChangeBytes -Offset "DE0C2E"  -Values "FFC836109800"            }
    if (IsChecked $Redux.Restore.ShopMusic)           { ChangeBytes -Offset "2678007" -Values "44"                      }
    if (IsChecked $Redux.Restore.PieceOfHeartSound)   { ChangeBytes -Offset "BA94C8"  -Values "1000"                    }
    if (IsChecked $Redux.Restore.MoveBomberKid)       { ChangeBytes -Offset "2DE4396" -Values "02C50118FB5500072D"      }



    # FIXES #

    if (IsChecked $Redux.Fixes.Geometry) { # Potion Shop door post-Odolwa in Southern Swamp
        CreateSubPath  -Path ($GameFiles.extracted + "\Southern Swamp")
        ExportAndPatch -Path "Southern Swamp\southern_swamp_cleared_scene"  -Offset "1F0D000" -Length "10630"
        ExportAndPatch -Path "Southern Swamp\southern_swamp_cleared_room_0" -Offset "1F1E000" -Length "1B240" -NewLength "1B4F0" -TableOffset "1EC26"  -Values "94F0"
        ExportAndPatch -Path "Southern Swamp\southern_swamp_cleared_room_2" -Offset "1F4D000" -Length "D0A0"  -NewLength "D1C0"  -TableOffset "1EC46"  -Values "A1C0"
    }
    
    if (IsChecked $Redux.Fixes.Cutscenes)        { ChangeBytes -Offset "F6DE89"  -Values "8D00021000000A" } # Goht running Link over
    if (IsChecked $Redux.Fixes.PictoboxDelay)    { ChangeBytes -Offset "BFC368"  -Values "00000000"       }
    if (IsChecked $Redux.Fixes.MushroomBottle)   { ChangeBytes -Offset "CD7C48"  -Values "1E6B"           }
    if (IsChecked $Redux.Fixes.FairyFountain)    { ChangeBytes -Offset "B9133E"  -Values "010F"           }



    # OTHER #

    if ( (IsIndex -Elem $Redux.Other.Select    -Text "Translate Only")         -or (IsIndex $Redux.Other.Select          -Text "Translate and Enable Map Select") )       { ExportAndPatch -Path "map_select" -Offset "C7C870" -Length "13C8"; ExportAndPatch -Path "inventory_editor" -Offset "CA6370" -Length "1E0" }
    if ( (IsIndex -Elem $Redux.Other.Select    -Text "Enable Map Select Only") -or (IsIndex $Redux.Other.Select          -Text "Translate and Enable Map Select") )       { ChangeBytes                       -Offset "C0A592" -Values "D940"     }
    if ( (IsIndex -Elem $Redux.Other.SkipIntro -Text "Skip Logo")              -or (IsIndex -Elem $Redux.Other.SkipIntro -Text "Skip Logo and Title Screen") )            { ChangeBytes                       -Offset "C7A54C" -Values "00000000" }
    if ( (IsIndex -Elem $Redux.Other.SkipIntro -Text "Skip Title Screen")      -or (IsIndex -Elem $Redux.Other.SkipIntro -Text "Skip Logo and Title Screen") )            { ChangeBytes                       -Offset "C0A566" -Values "DA00"     }

    if (IsChecked $Redux.Other.AlwaysBestEnding) {
        ChangeBytes -Offset "B81CE0" -Values "00000000"; ChangeBytes -Offset "B81D48" -Values "00000000"; ChangeBytes -Offset "B81DB0" -Values "00000000"; ChangeBytes -Offset "B81E18" -Values "00000000"; ChangeBytes -Offset "B81E80" -Values "00000000"
        ChangeBytes -Offset "B81EE8" -Values "00000000"; ChangeBytes -Offset "B81F84" -Values "00000000"; ChangeBytes -Offset "B81FEC" -Values "00000000"; ChangeBytes -Offset "B82054" -Values "00000000"
    }

    if (IsChecked $Redux.Other.BlueOctorok)         { ChangeBytes -Offset "EA118C" -Values "FFFF00" }
    if (IsChecked $Redux.Other.DefaultZTargeting)   { ChangeBytes -Offset "BDCA3D" -Values "0D"     }
    


    # GRAPHICS #

    if (IsChecked $Redux.Graphics.WidescreenAlt) {
        if ($IsWiiVC) { # 16:9 Widescreen
            ChangeBytes -Offset "BD5D74" -Values "3C073FE3"
            ChangeBytes -Offset "CA58F5" -Values "6C536C849EB7536C" -Interval 2

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
            ChangeBytes -Offset "C981F3" -Values "1A35EF82903C19001237398230244D0008AE0D02B0" # Dungeon Map - Stray Fairy Icon (22 35 EF 82 90 3C 19 00 1A 37 39 82 30 24 4D 00 08 AE 0D 02 B0)
        }

        PatchBytes -Offset "A9A000" -Length "12C00" -Texture -Patch "Widescreen\carnival_of_time.bin"
        PatchBytes -Offset "AACC00" -Length "12C00" -Texture -Patch "Widescreen\four_giants.bin"
        PatchBytes -Offset "C74DD0" -Length "800"   -Texture -Patch "Widescreen\lens_of_truth.bin"
    }

    if (IsChecked $Redux.Graphics.ExtendedDraw)     { ChangeBytes -Offset "B50874" -Values "00000000" }
    if (IsChecked $Redux.Graphics.PixelatedStars)   { ChangeBytes -Offset "B943FC" -Values "1000"     }



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
        $c_up_x = 0; $c_up_y = 0

        if (IsIndex -Elem $Redux.UI.Layout -Text "Ocarina of Time") {
            ChangeBytes -Offset @("BAF2E3", "BAF2D3", "BAF13F", "BAF12F", "BAF393", "BAF383") -Values 4 -Subtract; ChangeBytes -Offset @("BAF2E7", "BAF2EF", "BAF143", "BAF14B", "BAF397", "BAF39F") -Values 14 -Subtract # A Button
            ChangeBytes -Offset @("C55F15", "C55F07", "C56045")                               -Values 7 -Subtract                                                                                                         # B Button
        }

        elseif (IsIndex -Elem $Redux.UI.Layout -Text "Inverted A & B") {
            ChangeBytes -Offset @("BAF2E3", "BAF2D3", "BAF13F", "BAF12F", "BAF393", "BAF383") -Values 31 -Subtract; ChangeBytes -Offset @("BAF2E7", "BAF2EF", "BAF143", "BAF14B", "BAF397", "BAF39F") -Values 14 -Subtract # A Button
            ChangeBytes -Offset @("C55F15", "C55F07", "C56045")                               -Values 31 -Add;      ChangeBytes -Offset @("C55F1D", "C55F0B", "C5604D")                               -Values 14 -Add      # B Button
        }

        elseif (IsIndex -Elem $Redux.UI.Layout -Text "Nintendo") {
            ChangeBytes -Offset @("BAF2E3", "BAF2D3", "BAF13F", "BAF12F", "BAF393", "BAF383") -Values (70 - 4)  -Add;      ChangeBytes -Offset @("BAF2E7", "BAF2EF", "BAF143", "BAF14B", "BAF397", "BAF39F") -Values (23 - 14) -Add      # A Button
            ChangeBytes -Offset @("C55F15", "C55F07", "C56045")                               -Values (80 - 7)  -Add;      ChangeBytes -Offset @("C55F1D", "C55F0B", "C5604D")                               -Values 45        -Add      # B Button
            ChangeBytes -Offset @("C55F17", "C56047")                                         -Values 14        -Add;                                                                                                                    # C-Left Button
            ChangeBytes -Offset @("C55F19", "C56049")                                         -Values 30        -Add;      ChangeBytes -Offset @("C55F21", "C56051")                                         -Values 20        -Subtract # C-Down Button
            ChangeBytes -Offset @("C55F1B", "C5604B")                                         -Values 54        -Subtract; ChangeBytes -Offset @("C55F23", "C56053")                                         -Values 20        -Add      # C-Right Button
            ChangeBytes -Offset "BADB0B"                                                      -Values 10        -Add;      ChangeBytes -Offset "BADB13"                                                      -Values 10        -Subtract # C-Up
            if (IsChecked $Redux.Graphics.Widescreen)   { $c_up_x = 8;  $c_up_y = -45 }
            else                                        { $c_up_x = 35; $c_up_y = -40 }
        }

        elseif (IsIndex -Elem $Redux.UI.Layout -Text "Modern") {
            ChangeBytes -Offset @("BAF2E3", "BAF2D3", "BAF13F", "BAF12F", "BAF393", "BAF383") -Values (46  - 4) -Add;      ChangeBytes -Offset @("BAF2E7", "BAF2EF", "BAF143", "BAF14B", "BAF397", "BAF39F") -Values (45 - 14) -Add      # A Button
            ChangeBytes -Offset @("C55F15", "C55F07", "C56045")                               -Values (104 - 7) -Add;      ChangeBytes -Offset @("C55F1D", "C55F0B", "C5604D")                               -Values 23        -Add      # B Button
            ChangeBytes -Offset @("C55F17", "C56047")                                         -Values 10        -Subtract; ChangeBytes -Offset @("C55F1F", "C5604F")                                         -Values 20        -Add      # C-Left Button
            ChangeBytes -Offset @("C55F19", "C56049")                                         -Values 30        -Add;      ChangeBytes -Offset @("C55F21", "C56051")                                         -Values 20        -Subtract # C-Down Button
            ChangeBytes -Offset @("C55F1B", "C5604B")                                         -Values 30        -Subtract                                                                                                                # C-Right Button
            ChangeBytes -Offset "BADB0B"                                                      -Values 10        -Add;      ChangeBytes -Offset "BADB13"                                                      -Values 10        -Subtract # C-Up
            if (IsChecked $Redux.Graphics.Widescreen)   { $c_up_x = 8;  $c_up_y = -45 }
            else                                        { $c_up_x = 35; $c_up_y = -40 }
            
        }

        elseif (IsIndex -Elem $Redux.UI.Layout -Text "GameCube (Original)") {
            ChangeBytes -Offset @("BAF2E3", "BAF2D3", "BAF13F", "BAF12F", "BAF393", "BAF383") -Values (55 - 4)  -Add;      ChangeBytes -Offset @("BAF2E7", "BAF2EF", "BAF143", "BAF14B", "BAF397", "BAF39F") -Values (20 - 14) -Add      # A Button
            ChangeBytes -Offset @("C55F15", "C55F07", "C56045")                               -Values (62 - 7)  -Add;      ChangeBytes -Offset @("C55F1D", "C55F0B", "C5604D")                               -Values 43        -Add      # B Button
            ChangeBytes -Offset @("C55F17", "C56047")                                         -Values 21        -Add;      ChangeBytes -Offset @("C55F1F", "C5604F")                                         -Values 13        -Subtract # C-Left Button
            ChangeBytes -Offset @("C55F19", "C56049")                                         -Values 30        -Add;      ChangeBytes -Offset @("C55F21", "C56051")                                         -Values 25        -Subtract # C-Down Button
            ChangeBytes -Offset @("C55F1B", "C5604B")                                         -Values 15        -Add;      ChangeBytes -Offset @("C55F23", "C56053")                                         -Values 20        -Add      # C-Right Button
            ChangeBytes -Offset "BADB0B"                                                      -Values 25        -Subtract; ChangeBytes -Offset "BADB13"                                                      -Values 5         -Subtract # C-Up
            if (IsChecked $Redux.Graphics.Widescreen)   { $c_up_x = -26;  $c_up_y = -20 }
            else                                        { $c_up_x = -102; $c_up_y = -20 }
        }

        elseif (IsIndex -Elem $Redux.UI.Layout -Text "GameCube (Modern)") {
            ChangeBytes -Offset @("BAF2E3", "BAF2D3", "BAF13F", "BAF12F", "BAF393", "BAF383") -Values (55 - 4)  -Add;      ChangeBytes -Offset @("BAF2E7", "BAF2EF", "BAF143", "BAF14B", "BAF397", "BAF39F") -Values (20 - 14) -Add      # A Button
            ChangeBytes -Offset @("C55F15", "C55F07", "C56045")                               -Values (62 - 7)  -Add;      ChangeBytes -Offset @("C55F1D", "C55F0B", "C5604D")                               -Values 43        -Add      # B Button
            ChangeBytes -Offset @("C55F17", "C56047")                                         -Values 59        -Add;      ChangeBytes -Offset @("C55F1F", "C5604F")                                         -Values 20        -Add      # C-Left Button
            ChangeBytes -Offset @("C55F19", "C56049")                                         -Values 30        -Add;      ChangeBytes -Offset @("C55F21", "C56051")                                         -Values 25        -Subtract # C-Down Button
            ChangeBytes -Offset @("C55F1B", "C5604B")                                         -Values 23        -Subtract; ChangeBytes -Offset @("C55F23", "C56053")                                         -Values 13        -Subtract # C-Right Button
            ChangeBytes -Offset "BADB0B" -Values 25 -Subtract; ChangeBytes -Offset "BADB13" -Values 5 -Subtract # C-Up
            if (IsChecked $Redux.Graphics.Widescreen)   { $c_up_x = -26;  $c_up_y = -20 }
            else                                        { $c_up_x = -102; $c_up_y = -20 }
        }

        SetMMCUpTextCoords -X $c_up_x -Y $c_up_y
    }

    if (IsChecked $Redux.UI.CenterTatlPrompt) {
        if (IsChecked $Redux.Graphics.Widescreen) {
            if ($LanguagePatch.tatl -eq "Tatl" -and (IsIndex -Elem $Redux.Text.TatlCUp -Not) )   { $Taya = $True }
            if ($LanguagePatch.tatl -eq "Taya" )                                                 { $Taya = $True }
            else                                                                                 { $Taya = $False }
            if ($Taya)   { ChangeBytes -Offset "BADD28" -Values "35CEC0783C18005737184048246F0008AE0F02A0" }
            else         { ChangeBytes -Offset "BADD28" -Values "35CEC0783C18005737188048246F0008AE0F02A0" }

        }
        else { ChangeBytes -Offset "BADD28" -Values "35CEC0783C18003D37184048246F0008AE0F02A0" }
    }

    if (IsChecked $Redux.UI.GCScheme) { # Z to L textures
        PatchBytes -Offset "A7B7CC"  -Texture -Patch "GameCube\l_pause_screen_button.yaz0"
        PatchBytes -Offset "AD0980"  -Texture -Patch "GameCube\dpad_text_icon.bin"
        PatchBytes -Offset "AD0A80"  -Texture -Patch "GameCube\l_text_icon.bin"
        if (TestFile ($GameFiles.textures + "\GameCube\l_targeting_" + $LanguagePatch.code + ".bin")) { PatchBytes -Offset "1E90D00" -Texture -Patch ("GameCube\l_targeting_" + $LanguagePatch.code + ".bin") }
    }

    if (IsDefault $Redux.UI.ButtonStyle -Not)   { PatchBytes -Offset "1EBDF60" -Shared -Patch ("HUD\Buttons\" + $Redux.UI.ButtonStyle.Text.replace(" (default)", "") + ".bin") }
    if (IsChecked $Redux.UI.DungeonKeys)        { PatchBytes -Offset "1EBDD60" -Shared -Patch "HUD\Keys\Ocarina of Time.bin"   }
    if (IsDefault $Redux.UI.Rupees -Not)        { PatchBytes -Offset "1EBDE60" -Shared -Patch ("HUD\Rupees\" + $Redux.UI.Rupees.Text.replace(" (default)", "") + ".bin") }
    if (IsDefault $Redux.UI.Hearts -Not)        { PatchBytes -Offset "1EBD000" -Shared -Patch ("HUD\Hearts\" + $Redux.UI.Hearts.Text.replace(" (default)", "") + ".bin") }
    if (IsDefault $Redux.UI.Magic  -Not)        { PatchBytes -Offset "1EC1DA0" -Shared -Patch ("HUD\Magic\"  + $Redux.UI.Magic.Text.replace(" (default)", "")  + ".bin") }
    if (IsChecked $Redux.UI.BlackBars)          { ChangeBytes -Offset "BF72A4" -Values "00000000" }
    if (IsChecked $Redux.UI.HUD)                { PatchBytes -Offset "1EBD000" -Shared -Patch "HUD\Hearts\Ocarina of Time.bin"; PatchBytes -Offset "1EC1DA0" -Shared -Patch "HUD\Magic\Ocarina of Time.bin" }
    


    # EFFECTS #

    if (IsChecked $Redux.Graphics.MotionBlur)         { ChangeBytes -Offset "BFB9A0"  -Values "03E000080000000000" }
    if (IsChecked $Redux.Graphics.FlashbackOverlay)   { ChangeBytes -Offset "BFEB8C"  -Values "240F0000"           }
    if (IsChecked $Redux.Graphics.PreRenderFilters)   { ChangeBytes -Offset "C08498"  -Values "1100"               }



    # HIDE (Custom edits added by Marcelo - Hide Buttons) #

    if (IsChecked $Redux.Hide.AButton) { # A Button
        ChangeBytes -Offset "BA55F8" -Values "00000000"; ChangeBytes -Offset "BA5608" -Values "00000000"; ChangeBytes -Offset "BA5A04" -Values "00000000"; ChangeBytes -Offset "BA5DA8" -Values "00000000"
        ChangeBytes -Offset "BA5FE8" -Values "00000000"; ChangeBytes -Offset "BA60A0" -Values "00000000"; ChangeBytes -Offset "BA64F0" -Values "00000000"
    }

    if (IsChecked $Redux.Hide.BButton) { # B Button
        ChangeBytes -Offset "BA5528" -Values "00000000"; ChangeBytes -Offset "BA5544" -Values "00000000"; ChangeBytes -Offset "BA5CC4" -Values "00000000"; ChangeBytes -Offset "BA5DE8" -Values "00000000"
        ChangeBytes -Offset "BA5FD8" -Values "00000000"; ChangeBytes -Offset "BA60B0" -Values "00000000"; ChangeBytes -Offset "BA6500" -Values "00000000"
    }

    if (IsChecked $Redux.Hide.CButtons) {
        ChangeBytes -Offset "BA5568" -Values "00000000"; ChangeBytes -Offset "BA5578" -Values "00000000"; ChangeBytes -Offset "BA5FF8" -Values "00000000"; ChangeBytes -Offset "BA60C0" -Values "00000000" # C-Left
        ChangeBytes -Offset "BA5598" -Values "00000000"; ChangeBytes -Offset "BA55A8" -Values "00000000"; ChangeBytes -Offset "BA6008" -Values "00000000"; ChangeBytes -Offset "BA60D0" -Values "00000000" # C-Down
        ChangeBytes -Offset "BA55C8" -Values "00000000"; ChangeBytes -Offset "BA55D8" -Values "00000000"; ChangeBytes -Offset "BA6018" -Values "00000000"; ChangeBytes -Offset "BA60E4" -Values "00000000" # C-Right
    }

    if (IsChecked $Redux.Hide.Hearts) { # Health
        ChangeBytes -Offset "BA5B28" -Values "00000000"; ChangeBytes -Offset "BA5BFC" -Values "00000000"; ChangeBytes -Offset "BA5A14" -Values "00000000"
        ChangeBytes -Offset "BA603C" -Values "00000000"; ChangeBytes -Offset "BA6530" -Values "00000000"; ChangeBytes -Offset "BB787C" -Values "00000000"
    }

    if (IsChecked $Redux.Hide.Magic) { # Magic Meter & Rupees
        ChangeBytes -Offset "BA5A28" -Values "00000000"; ChangeBytes -Offset "BA5B3C" -Values "00000000"; ChangeBytes -Offset "BA5BE8" -Values "00000000"
        ChangeBytes -Offset "BA6028" -Values "00000000"; ChangeBytes -Offset "BA6520" -Values "00000000"; ChangeBytes -Offset "BB788C" -Values "00000000"
    }

    if (IsChecked $Redux.Hide.Clock) { # Clock
		ChangeBytes -Offset "BAFD5C" -Values "00000000"; ChangeBytes -Offset "BAFC48" -Values "00000000"; ChangeBytes -Offset "BAFDA8" -Values "00000000"
		ChangeBytes -Offset "BAFD00" -Values "00000000"; ChangeBytes -Offset "BAFD98" -Values "00000000"; ChangeBytes -Offset "C5606D" -Values "00"
    }

    if (IsChecked $Redux.Hide.CountdownTimer)   { ChangeBytes -Offset "BB169A" -Values "01 FF";       ChangeBytes -Offset "C56180" -Values "01 FF 01 FF 01 FF 01 FF 01 FF 01 FF 01 FF 01 FF" } # Disable Countdown timer background / Disable Countdown timer
    if (IsChecked $Redux.Hide.AreaTitle)        { ChangeBytes -Offset "B80A64" -Values "10 00 01 9E"; ChangeBytes -Offset "B842C0" -Values "10 00 00 04"                                     } # Disable Area Title Cards
    if (IsChecked $Redux.Hide.Credits)          { PatchBytes  -Offset "B3B000" -Patch "Message\credits.bin" }



    # STYLES #

    if (IsIndex -Elem $Redux.Styles.HairColor -Not) {
        $offset = $null; $folder = "" 

        if     (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Original")                    { $offset = "1160400"; $folder = "Majora's Mask"   }
        elseif (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Majora's Mask + OoT Eyes")    { $offset = "1160400"; $folder = "Majora's Mask"   }
        elseif (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Ocarina of Time")             { $offset = "1164290"; $folder = "Ocarina of Time" }
        elseif (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Ocarina of Time + MM Eyes")   { $offset = "1164290"; $folder = "Ocarina of Time" }
       #elseif (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Improved Link")               { $offset = "1160600"; $folder = "Improved Link"   }
       #elseif (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Improved Link + OoT Eyes")    { $offset = "1160600"; $folder = "Improved Link"   }
       #elseif (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Adult Link (MM)")             { $offset = "1162600"; $folder = "Majora's Mask"   }

        if ($offset -ne $null) { PatchBytes -Offset $offset -Shared -Patch ("Styles\Hair\" + $folder + "\" + $Redux.Styles.HairColor.Text + ".bin") }
    }

    if (IsDefault $Redux.Styles.RegularChests -Not)   { PatchBytes -Offset "11E3E60" -Shared -Patch ("Styles\Chests\"       + $Redux.Styles.RegularChests.Text + ".front"); PatchBytes  -Offset "11E4E60" -Shared -Patch ("Styles\Chests\" + $Redux.Styles.RegularChests.Text + ".back") }
    if (IsDefault $Redux.Styles.LeatherChests -Not)   { PatchBytes -Offset "11E5660" -Shared -Patch ("Styles\Chests\"       + $Redux.Styles.LeatherChests.Text + ".front"); PatchBytes  -Offset "11E6660" -Shared -Patch ("Styles\Chests\" + $Redux.Styles.LeatherChests.Text + ".back") }
    if (IsDefault $Redux.Styles.BossChests    -Not)   { PatchBytes -Offset "11E6E60" -Shared -Patch ("Styles\Chests\"       + $Redux.Styles.BossChests.Text    + ".front"); PatchBytes  -Offset "11E7E60" -Shared -Patch ("Styles\Chests\" + $Redux.Styles.BossChests.Text    + ".back") }
    if (IsDefault $Redux.Styles.SmallCrates   -Not)   { PatchBytes -Offset "113A2C0" -Shared -Patch ("Styles\Small Crates\" + $Redux.Styles.SmallCrates.Text   + ".bin") }
    if (IsDefault $Redux.Styles.Pots          -Not)   { PatchBytes -Offset "1138EC0" -Shared -Patch ("Styles\Pots\"         + $Redux.Styles.Pots.Text          + ".bin") }


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

    if (TestFile -Path $Paths.Music -Container) {
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

    if (IsChecked $Redux.Hero.RedTektites) {        PatchBytes  -Offset "D0DB3C" -Patch "ovl_en_tite.bin"        ChangeBytes -Offset "D10D3C" -Values "06"; ChangeBytes -Offset "D10E57" -Values "64"; ChangeBytes -Offset "D10E5B" -Values "68"; ChangeBytes -Offset "D10E5F" -Values "74"; ChangeBytes -Offset "D10E63" -Values "BC"; ChangeBytes -Offset @("D0DC6C", "D0DD08", "D0DDA0") -Values "1100"
    }

    if (IsIndex -Elem $Redux.Hero.MonsterHP -Index 3 -Not) { # Monsters
        if (IsIndex -Elem $Redux.Hero.MonsterHP) { $multi = 0 } else { [float]$multi = [float]$Redux.Hero.MonsterHP.text.split('x')[0] }
        
        MultiplyBytes -Offset @("D2F07C", "D6CFB8", "E59933") -Factor $multi -Max 127 # Deku Baba, Wilted Deku Baba, Bio Deku Baba
        MultiplyBytes -Offset @("FC3A5F", "EDBA17", "E9BD87") -Factor $multi -Max 127 # Deep Python, Skullfish, Desbreko
        MultiplyBytes -Offset @("D47754", "D76388", "D74167") -Factor $multi -Max 127 # Beamos, Like Like (Weak), Like Like (Strong)
        MultiplyBytes -Offset @("CF05CC", "D4DA9C", "D4BCAB") -Factor $multi -Max 127 # Wallmaster, Floormaster, Mini Floormaster
        MultiplyBytes -Offset @("D4E07F", "F94A00")           -Factor $multi -Max 127 # ReDead / Gibdo, Poe
        MultiplyBytes -Offset @("D13750", "D1375C")           -Factor $multi -Max 127 # Peahat, Peahat Larva
        MultiplyBytes -Offset @("D55BDC", "D55C08")           -Factor $multi -Max 127 # Skullwalltula, Golden Skullwalltula
        MultiplyBytes -Offset @("CF3514", "CF0A4B")           -Factor $multi -Max 127 # Dodongo (Small), Dodongo (Big)
        MultiplyBytes -Offset @("D10D3C", "D0DBDB")           -Factor $multi -Max 127 # Red Tektite, Blue Tektite
        MultiplyBytes -Offset @("E0336B", "E07028")           -Factor $multi -Max 127 # Wolfos, White Wolfos
        MultiplyBytes -Offset @("D3D9DC", "D3AFBC")           -Factor $multi -Max 127 # Blue Bubble, Red Bubble
        MultiplyBytes -Offset @("D5E0E3", "F3E82C")           -Factor $multi -Max 127 # Shell Blade, Snapper
        MultiplyBytes -Offset @("D3914C", "CEACD8")           -Factor $multi -Max 127 # Mad Scrub, Octorok
        MultiplyBytes -Offset @("F7ED78", "EC1F2C")           -Factor $multi -Max 127 # Eeno, Real Bombchu
        MultiplyBytes -Offset @("EB922C", "E9B69C")           -Factor $multi -Max 127 # White Boe, Black Boe, Chuchu
        MultiplyBytes -Offset @("FE1AA3", "FE1ABF")           -Factor $multi -Max 127 # Leever, Purple Leever
        MultiplyBytes -Offset @("F831D3", "E19013")           -Factor $multi -Max 127 # Hiploop, Dragonfly
        MultiplyBytes -Offset   "E205BB"                      -Factor $multi -Max 127 # Garo
        MultiplyBytes -Offset   "F5B7FC"                      -Factor $multi -Max 127 # Dexihand
        MultiplyBytes -Offset   "E0790F"                      -Factor $multi -Max 8   # Stalchild
    }

    if (IsIndex -Elem $Redux.Hero.MiniBossHP -Index 3 -Not) { # Mini-Bosses
        if (IsIndex -Elem $Redux.Hero.MiniBossHP) { $multi = 0 } else { [float]$multi = [float]$Redux.Hero.MiniBossHP.text.split('x')[0] }

        MultiplyBytes -Offset   "10785BC"             -Factor $multi -Max 127 # Takkuri
        MultiplyBytes -Offset @("CE718B",  "CE7DB8")  -Factor $multi -Max 127 # Gekko & Snapper (Gekko)
        MultiplyBytes -Offset   "D18554"              -Factor $multi -Max 127 # Dinolfos
        MultiplyBytes -Offset @("EAEFB7",  "EB10B7")  -Factor $multi -Max 127 # Ice Wizzrobe
        MultiplyBytes -Offset   "FEA75F"              -Factor $multi -Max 127 # Gerudo Pirate
        MultiplyBytes -Offset @("E9329C",  "D6A48C")  -Factor $multi -Max 127 # Gekko & Snapper (Snapper), Gekko & Mad Jelly
        MultiplyBytes -Offset @("E57387",  "E580D7")  -Factor $multi -Max 127 # Wart
        MultiplyBytes -Offset @("10706BF", "107215F") -Factor $multi -Max 127 # Captain Keeta
        MultiplyBytes -Offset @("D9F210",  "D9E3A3")  -Factor $multi -Max 127 # Iron Knuckle
        MultiplyBytes -Offset @("F82D9C",  "F7F873")  -Factor $multi -Max 127 # Poe Sisters
        MultiplyBytes -Offset   "FCA1BC"              -Factor $multi -Max 127 # Big Poe
        MultiplyBytes -Offset @("EAEF9B",  "EB10AF")  -Factor $multi -Max 127 # Fire wizzrobe
        MultiplyBytes -Offset   "EDEE3B"              -Factor $multi -Max 127 # Garo Master
        MultiplyBytes -Offset   "EE480F"              -Factor $multi -Max 127 # Eyegore
        MultiplyBytes -Offset   "D43C10"              -Factor $multi -Max 127 # Gomess
    }

    if (IsIndex -Elem $Redux.Hero.BossHP -Index 3 -Not) { # Bosses
        if (IsIndex -Elem $Redux.Hero.BossHP)   { $multi = 0 } else { [float]$multi = [float]$Redux.Hero.BossHP.text.split('x')[0] }

        MultiplyBytes -Offset @("E424E7", "E41F67")           -Factor $multi -Max 127 # Odolwa
        MultiplyBytes -Offset   "E42307"                      -Factor $multi -Max 127 # Odolwa's Insect
        MultiplyBytes -Offset @("F73D90", "F6BF37", "F6C07F") -Factor $multi -Max 127 # Goht
        MultiplyBytes -Offset @("E50D33", "E54683")           -Factor $multi -Max 127 # Gyorg
        MultiplyBytes -Offset @("E2556F", "E2828F")           -Factor $multi -Max 127 # King's Lackeys
        MultiplyBytes -Offset @("E25617", "E28277")           -Factor $multi -Max 127 # Igos du Ikana
        MultiplyBytes -Offset   "E4A607"                      -Factor $multi -Max 127 # Twinmold
        MultiplyBytes -Offset @("E60633", "E6B20B")           -Factor $multi -Max 127 # Majora's Mask
        MultiplyBytes -Offset   "E6FA2F"                      -Factor $multi -Max 127 # Four Remains
        MultiplyBytes -Offset @("E60743", "E606AB")           -Factor $multi -Max 127 # Majora's Incarnation, Majora's Wrath
    }

    if     ( (IsText -Elem $Redux.Hero.Damage -Compare "1x Damage") -and ($GameType.title -like    "*Master Quest*") )   { ChangeBytes -Offset "CADEC2" -Values "2C03" }
    elseif ( (IsText -Elem $Redux.Hero.Damage -Compare "2x Damage") -and ($GameType.title -notlike "*Master Quest*") )   { ChangeBytes -Offset "CADEC2" -Values "2BC3" }
    elseif   (IsText -Elem $Redux.Hero.Damage -Compare "4x Damage")                                                      { ChangeBytes -Offset "CADEC2" -Values "2B83" }
    elseif   (IsText -Elem $Redux.Hero.Damage -Compare "8x Damage")                                                      { ChangeBytes -Offset "CADEC2" -Values "2B43" }
    elseif   (IsText -Elem $Redux.Hero.Damage -Compare "OHKO Mode")                                                      { ChangeBytes -Offset "CADEC2" -Values "2A03" }

    if     (IsText -Elem $Redux.Hero.MagicUsage -Compare "2x Magic Usage")   { ChangeBytes -Offset "BAC306" -Values "2C40" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "4x Magic Usage")   { ChangeBytes -Offset "BAC306" -Values "2C80" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "8x Magic Usage")   { ChangeBytes -Offset "BAC306" -Values "2CC0" }
    if     (IsText -Elem $Redux.Hero.MagicUsage -Compare "2x Item Usage")    { ChangeBytes -Offset "BABF5E" -Values "2C40" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "4x Item Usage")    { ChangeBytes -Offset "BABF5E" -Values "2C80" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "8x Item Usage")    { ChangeBytes -Offset "BABF5E" -Values "2CC0" }

    if (IsChecked $Redux.Hero.NoBottledFairy) { ChangeBytes -Offset "CD7C09" -Values "00" }

    if (IsIndex -Elem $Redux.Hero.DamageEffect -Not) {
        ChangeBytes -Offset "B79A48" -Values "24"
        ChangeBytes -Offset "B79A4B" -Values (Get8Bit $Redux.Hero.DamageEffect.SelectedIndex)
    }

    if (IsIndex -Elem $Redux.Hero.ClockSpeed -Not) {
            ChangeBytes -Offset "0BC6674" -Values "3C01"; ChangeBytes -Offset "0BC6677" -Values "0114E2";           ChangeBytes -Offset "0BC667B" -Values "020026082124020000"
            ChangeBytes -Offset "0BC6685" -Values "40";   ChangeBytes -Offset "0BC6687" -Values "0200000000240200"; ChangeBytes -Offset "0BC6691" -Values "22"
            if     ($Redux.Hero.ClockSpeed.SelectedIndex -eq 1) { ChangeBytes -Offset "BB005E" -Values "0000"; ChangeBytes -Offset "BC668F" -Values "01"; ChangeBytes -Offset "BEDB8E" -Values "0000" }
            elseif ($Redux.Hero.ClockSpeed.SelectedIndex -eq 2) { ChangeBytes -Offset "BB005E" -Values "FFFF"; ChangeBytes -Offset "BC668F" -Values "02"; ChangeBytes -Offset "BEDB8E" -Values "FFFF" }
            elseif ($Redux.Hero.ClockSpeed.SelectedIndex -eq 3) { ChangeBytes -Offset "BB005E" -Values "FFFC"; ChangeBytes -Offset "BC668F" -Values "06"; ChangeBytes -Offset "BEDB8E" -Values "FFFC" }
            elseif ($Redux.Hero.ClockSpeed.SelectedIndex -eq 4) { ChangeBytes -Offset "BB005E" -Values "FFFA"; ChangeBytes -Offset "BC668F" -Values "09"; ChangeBytes -Offset "BEDB8E" -Values "FFFA" }
            elseif ($Redux.Hero.ClockSpeed.SelectedIndex -eq 5) { ChangeBytes -Offset "BB005E" -Values "FFF4"; ChangeBytes -Offset "BC668F" -Values "12"; ChangeBytes -Offset "BEDB8E" -Values "FFF4" }
            elseif ($Redux.Hero.ClockSpeed.SelectedIndex -eq 6) { ChangeBytes -Offset "BB005E" -Values "FFEC"; ChangeBytes -Offset "BC668F" -Values "1E"; ChangeBytes -Offset "BEDB8E" -Values "FFEC" }
    }

    if (IsText -Elem $Redux.Hero.ItemDrops -Compare "Nothing") {
        $Values = @()
        for ($i=0; $i -lt 80; $i++) { $Values += 0 }
        ChangeBytes -Offset "C44400" -Values $Values
    }
    elseif (IsText -Elem $Redux.Hero.ItemDrops -Compare "Only Rupees") { PatchBytes  -Offset "C444B9" -Patch "only_rupee_drops.bin" }
    
    
    if (IsChecked $Redux.Hero.PalaceRoute) {
        CreateSubPath  -Path ($GameFiles.extracted + "\Deku Palace")
        ExportAndPatch -Path "Deku Palace\deku_palace_scene"  -Offset "2534000" -Length "D220"
        ExportAndPatch -Path "Deku Palace\deku_palace_room_0" -Offset "2542000" -Length "11A50"
        ExportAndPatch -Path "Deku Palace\deku_palace_room_1" -Offset "2554000" -Length "E950"  -NewLength "E9B0"  -TableOffset "1F6A7" -Values "B0"
        ExportAndPatch -Path "Deku Palace\deku_palace_room_2" -Offset "2563000" -Length "124F0" -NewLength "124B0" -TableOffset "1F6B7" -Values "B0"
    }

    if (IsChecked $Redux.Hero.DeathIsMoonCrash) {
        ChangeBytes -Offset "0C40DF8" -Values "8FA20018240E54C0"; ChangeBytes -Offset "0C40E08" -Values "3C01000200220821"
        ChangeBytes -Offset "0C40E14" -Values "A42E887A";         ChangeBytes -Offset "0C40E1D" -Values "0E0014A02E8875A02C887F"
    }

    if (IsChecked $Redux.Hero.CloseBombShop) {
        ChangeBytes -Offset "2CB10DA" -Values "0360";     ChangeBytes -Offset "2CB1212" -Values "0360"                                                      # Move Bomb Bag to Stock Pot Inn
        ChangeBytes -Offset "E76F38"  -Values "00000000"; ChangeBytes -Offset "E772DC"  -Values "2405064A"; ChangeBytes -Offset "E77CCC" -Values "2405064A" # Disable Bomb Shop
    }
    
    if (IsChecked $Redux.Hero.IronKnuckle) {
        ChangeBytes -Offset @("D9D028", "D9D030") -Values "00000000"                                                                                                                                            # Start moving by himself
        ChangeBytes -Offset   "D9CEEC"            -Values "14400004"; ChangeBytes -Offset "D9CEFC" -Values "10400003"                                                                                           # Run faster
        ChangeBytes -Offset   "D9CF08"            -Values "00000000"; ChangeBytes -Offset "D9D05E" -Values "A849"                                                                                               # Always run
        ChangeBytes -Offset   "D9D402"            -Values "4170";     ChangeBytes -Offset "D9CD76" -Values "4316"; ChangeBytes -Offset "D9CD48" -Values "00000000"; ChangeBytes -Offset "D9DC6B" -Values "03"   # Block attacks, even armored
        ChangeBytes -Offset   "D9CE0E"            -Values "3FFC";     ChangeBytes -Offset "D9D592" -Values "4180"; ChangeBytes -Offset "D9D6CA" -Values "4060";     ChangeBytes -Offset "D9CE84" -Values "1000" # Attack faster
        ChangeBytes -Offset   "D9D362"            -Values "4000"                                                                                                                                                # Faster vertical attack but less reach
        ChangeBytes -Offset   "D9D96E"            -Values "A8A3"                                                                                                                                                # Vertical attack after double horizontal attack
        ChangeBytes -Offset   "D9DB02"            -Values "A9A0"                                                                                                                                                # Double horizontal attack after single horizontal attack
        ChangeBytes -Offset @("D9D358", "D9D564", "D9D5C0", "D9D638", "D9D6C0", "D9D74C", "D9D784", "D9D8C8", "D9D9A4", "D9DB3C") -Values "00000000"                                                            # Attack faster
    }

    if (IsChecked $Redux.Hero.Keese)      { ChangeBytes -Offset   "CF4E68"             -Values "1500"                                                                                                                                         }
    if (IsChecked $Redux.Hero.Dinolfos)   { ChangeBytes -Offset   "D14C20"             -Values "00000000"; ChangeBytes -Offset @("D15B18", "D15BE8", "D16108")                                                             -Values "1000"     }
    if (IsChecked $Redux.Hero.Wolfos)     { ChangeBytes -Offset @("E03774", "E04270" ) -Values "1000";     ChangeBytes -Offset @("E03974", "E043D0", "E048B4", "E04B18", "E05060", "E053A8", "E05578", "E05778", "E05A6C") -Values "00000000" }
    
    

    # MAGIC #

    if (IsDefault $Redux.Magic.FireArrow  -Not)   { ChangeBytes -Offset "CD7428" -Values (Get8Bit $Redux.Magic.FireArrow.Text)  }
    if (IsDefault $Redux.Magic.IceArrow   -Not)   { ChangeBytes -Offset "CD7429" -Values (Get8Bit $Redux.Magic.IceArrow.Text)   }
    if (IsDefault $Redux.Magic.LightArrow -Not)   { ChangeBytes -Offset "CD742A" -Values (Get8Bit $Redux.Magic.LightArrow.Text) }
    if (IsDefault $Redux.Magic.DekuBubble -Not)   { ChangeBytes -Offset "CD742B" -Values (Get8Bit $Redux.Magic.DekuBubble.Text) }



    # RECOVERY #

    if (IsDefault $Redux.Recovery.Heart       -Not)   { ChangeBytes -Offset   "BAA36A"            -Values (Get16Bit $Redux.Recovery.Heart.Text      ) }
    if (IsDefault $Redux.Recovery.StrayFairy  -Not)   { ChangeBytes -Offset   "F32E1A"            -Values (Get16Bit $Redux.Recovery.StrayFairy.Text ) }
    if (IsDefault $Redux.Recovery.Fairy       -Not)   { ChangeBytes -Offset   "D08106"            -Values (Get16Bit $Redux.Recovery.Fairy.Text      ) }
    if (IsDefault $Redux.Recovery.FairyRevive -Not)   { ChangeBytes -Offset @("CBACCE", "CBAC82") -Values (Get16Bit $Redux.Recovery.FairyRevive.Text) }
    if (IsDefault $Redux.Recovery.Milk        -Not)   { ChangeBytes -Offset   "CCD742"            -Values (Get16Bit $Redux.Recovery.Milk.Text       ) }
    if (IsDefault $Redux.Recovery.RedPotion   -Not)   { ChangeBytes -Offset   "CCD6EA"            -Values (Get16Bit $Redux.Recovery.RedPotion.Text  ) }



    # MINIGAMES #
    
    if (IsDefault $Redux.Minigames.TownShootingGallery1  -Not)   { ChangeBytes -Offset   "BD9FC3"            -Values (Get8Bit  $Redux.Minigames.TownShootingGallery1.Text)  }
    if (IsDefault $Redux.Minigames.TownShootingGallery2  -Not)   { ChangeBytes -Offset @("E3A17F", "E3A19F") -Values (Get8Bit  $Redux.Minigames.TownShootingGallery2.Text)  }
    if (IsDefault $Redux.Minigames.SwampShootingGallery1 -Not)   { ChangeBytes -Offset @("E39942", "E39A2E") -Values (Get16Bit $Redux.Minigames.SwampShootingGallery1.Text) }
    if (IsDefault $Redux.Minigames.SwampShootingGallery2 -Not)   { ChangeBytes -Offset @("E3901A", "E3909E") -Values (Get16Bit $Redux.Minigames.SwampShootingGallery2.Text) }



    # EASY MODE #

    if     (IsIndex -Elem $Redux.EasyMode.KeepBottles -Index 2)   { ChangeBytes -Offset "BDA5AB"  -Values "17"       }
    elseif (IsIndex -Elem $Redux.EasyMode.KeepBottles -Index 3)   { ChangeBytes -Offset "BDA5AB"  -Values "27"       }
    if     (IsChecked     $Redux.EasyMode.KeepRupees)             { ChangeBytes -Offset "BDAA70"  -Values "00000000" }

    if (IsChecked $Redux.EasyMode.NoBlueBubbleRespawn)   { ChangeBytes -Offset "D3CEC0"  -Values "57200004"                                                   }
    if (IsChecked $Redux.EasyMode.NoTakkuriSteal)        { ChangeBytes -Offset "1075B88" -Values "10000016"; ChangeBytes -Offset "1075BE4" -Values "10000046" }
    if (IsChecked $Redux.EasyMode.NoShieldSteal)         { ChangeBytes -Offset "D7475C"  -Values "10000008"                                                   }
    if (IsChecked $Redux.EasyMode.KeepAmmo)              { ChangeBytes -Offset "BDA560"  -Values "1000000D"                                                   }



    # TUNIC COLORS #

    if (IsSet $Redux.Colors.SetKokiriTunic) {
        if ( (IsColor $Redux.Colors.SetKokiriTunic -Not) -and (IsIndex -Elem $Redux.Graphics.ChildModels -Text "Original")) {
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

    if (IsChecked $Redux.Colors.RedIce) { ChangeBytes -Offset "DA5354" -Values "3C010032"; ChangeBytes -Offset "DA5368" -Values "34216400" }



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
        if (IsColor $Redux.Colors.SetSpinAttack[0] -Not)   { ChangeBytes -Offset "10B08F4" -Values @($Redux.Colors.SetSpinAttack[0].Color.R, $Redux.Colors.SetSpinAttack[0].Color.G, $Redux.Colors.SetSpinAttack[0].Color.B) } # Blue Spin Attack
        if (IsColor $Redux.Colors.SetSpinAttack[1] -Not)   { ChangeBytes -Offset "10B0A14" -Values @($Redux.Colors.SetSpinAttack[1].Color.R, $Redux.Colors.SetSpinAttack[1].Color.G, $Redux.Colors.SetSpinAttack[1].Color.B) } # Blue Spin Attack
        if (IsColor $Redux.Colors.SetSpinAttack[2] -Not)   { ChangeBytes -Offset "10B0E74" -Values @($Redux.Colors.SetSpinAttack[2].Color.R, $Redux.Colors.SetSpinAttack[2].Color.G, $Redux.Colors.SetSpinAttack[2].Color.B) } # Red Spin Attack
        if (IsColor $Redux.Colors.SetSpinAttack[3] -Not)   { ChangeBytes -Offset "10B0F94" -Values @($Redux.Colors.SetSpinAttack[3].Color.R, $Redux.Colors.SetSpinAttack[3].Color.G, $Redux.Colors.SetSpinAttack[3].Color.B) } # Red Spin Attack
    }

    # SWORD TRAIL COLORS #

    if ($Redux.Colors.SetSwordTrail -ne $null) {
        if (IsColor   $Redux.Colors.SetSwordTrail[0]   -Not)   { ChangeBytes -Offset @("CD73F8", "CD7400")           -Values @($Redux.Colors.SetSwordTrail[0].Color.R, $Redux.Colors.SetSwordTrail[0].Color.G, $Redux.Colors.SetSwordTrail[0].Color.B) }
        if (IsColor   $Redux.Colors.SetSwordTrail[1]   -Not)   { ChangeBytes -Offset @("CD73FC", "CD7404")           -Values @($Redux.Colors.SetSwordTrail[1].Color.R, $Redux.Colors.SetSwordTrail[1].Color.G, $Redux.Colors.SetSwordTrail[1].Color.B) }
        if (IsDefault $Redux.Colors.SwordTrailDuration -Not)   { ChangeBytes -Offset @("CA9FBF", "CBC2A7", "CBC46B") -Values ($Redux.Colors.SwordTrailDuration.SelectedIndex * 5); ChangeBytes -Offset "CB5CFB" -Values ($ByteArrayGame[0xCA9FBF] * 2) }
    }



    # FAIRY COLORS #

    if (IsSet $Redux.Colors.SetFairy) { # Colors for Tatl option
        if ( (IsColor $Redux.Colors.SetFairy[0] -Not) -or (IsColor $Redux.Colors.SetFairy[1] -Not) ) { # Idle
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
        if ( (IsColor $Redux.Colors.SetFairy[2] -Not) -or (IsColor $Redux.Colors.SetFairy[3] -Not) ) { # Interact
            ChangeBytes -Offset "C451F4" -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "C451FC" -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
        }
        if ( (IsColor $Redux.Colors.SetFairy[4] -Not) -or (IsColor $Redux.Colors.SetFairy[5] -Not) ) { # NPC
            ChangeBytes -Offset "C451E4" -Values @($Redux.Colors.SetFairy[4].Color.R, $Redux.Colors.SetFairy[4].Color.G, $Redux.Colors.SetFairy[4].Color.B, 255, $Redux.Colors.SetFairy[5].Color.R, $Redux.Colors.SetFairy[5].Color.G, $Redux.Colors.SetFairy[5].Color.B, 0)
        }
        if ( (IsColor $Redux.Colors.SetFairy[6] -Not) -or (IsColor $Redux.Colors.SetFairy[7] -Not) ) { # Enemy, Boss
            ChangeBytes -Offset "C451EC" -Values @($Redux.Colors.SetFairy[6].Color.R, $Redux.Colors.SetFairy[6].Color.G, $Redux.Colors.SetFairy[6].Color.B, 255, $Redux.Colors.SetFairy[7].Color.R, $Redux.Colors.SetFairy[7].Color.G, $Redux.Colors.SetFairy[7].Color.B, 0)
            ChangeBytes -Offset "C4520C" -Values @($Redux.Colors.SetFairy[6].Color.R, $Redux.Colors.SetFairy[6].Color.G, $Redux.Colors.SetFairy[6].Color.B, 255, $Redux.Colors.SetFairy[7].Color.R, $Redux.Colors.SetFairy[7].Color.G, $Redux.Colors.SetFairy[7].Color.B, 0)
        }
    }

    if (IsSet $Redux.Colors.SetTael) { # Colors for Tael option
        if ( (IsColor $Redux.Colors.SetTael[0] -Not) -or (IsColor $Redux.Colors.SetTael[1] -Not) ) {
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
        if ($Redux.Capacity.Wallet1.Text.Length -gt 3 -or $Redux.Capacity.Wallet2.Text.Length -gt 3 -or $Redux.Capacity.Wallet3.Text.Length -gt 3 -or $Redux.Capacity.Wallet4.Text.Length -gt 3) { $max = 4 } else { $max = 3 }

        ChangeBytes -Offset "C5836C" -Values (Get16Bit $Redux.Capacity.Wallet1.Text)
        ChangeBytes -Offset "C5836E" -Values (Get16Bit $Redux.Capacity.Wallet2.Text)
        ChangeBytes -Offset "C58370" -Values (Get16Bit $Redux.Capacity.Wallet3.Text)
        ChangeBytes -Offset "C58372" -Values (Get16Bit $Redux.Capacity.Wallet4.Text)

        ChangeBytes -Offset "C5625D" -Values @( ($max - $Redux.Capacity.Wallet1.Text.Length), ($max - $Redux.Capacity.Wallet2.Text.Length), ($max - $Redux.Capacity.Wallet3.Text.Length), ($max - $Redux.Capacity.Wallet4.Text.Length) ) -Interval 2
        ChangeBytes -Offset "C56265" -Values @(         $Redux.Capacity.Wallet1.Text.Length,          $Redux.Capacity.Wallet2.Text.Length,          $Redux.Capacity.Wallet3.Text.Length,          $Redux.Capacity.Wallet4.Text.Length)   -Interval 2
    }
    elseif (IsChecked $Redux.Gameplay.RoyalWallet) { ChangeBytes -Offset "C58372" -Values "03E7"; ChangeBytes -Offset "C5626B" -Values 3 }



    # EQUIPMENT ADJUSTMENTS #

    if ( (IsChecked $Redux.Equipment.PermanentRazorSword) -or (IsChecked -Elem $Redux.Features.GearSwap -Redux) ) {
        ChangeBytes -Offset "CBA496" -Values "0000" # Prevent losing hits
        ChangeBytes -Offset "BDA6B7" -Values "01"   # Keep sword after Song of Time
    }

    if (IsChecked $Redux.Equipment.MajoraMirrorShield)   { PatchBytes  -Offset "1177B00" -Texture -Patch "majora_mirror_shield.bin"                  }
    if (IsChecked $Redux.Equipment.UnsheathSword)        { ChangeBytes -Offset "CC2CE8"  -Values "284200051440000500001025"                          }
    if (IsChecked $Redux.Equipment.SwordBeamAttack)      { ChangeBytes -Offset "CD73F0"  -Values "0000"; ChangeBytes -Offset "CD73F4" -Values "0000" }
    if (IsChecked $Redux.Equipment.FixEponaSword)        { ChangeBytes -Offset "BA885C"  -Values "2418"; ChangeBytes -Offset "BA885F" -Values "01"   }



    # HITBOX #

    if (IsDefault $Redux.Equipment.KokiriSword      -Not)   { ChangeBytes -Offset "C572BC" -Values (ConvertFloatToHex $Redux.Equipment.KokiriSword.Value)      }
    if (IsDefault $Redux.Equipment.RazorSword       -Not)   { ChangeBytes -Offset "C572C0" -Values (ConvertFloatToHex $Redux.Equipment.RazorSword.Value)       }
    if (IsDefault $Redux.Equipment.GildedSword      -Not)   { ChangeBytes -Offset "C572C4" -Values (ConvertFloatToHex $Redux.Equipment.GildedSword.Value)      }
    if (IsDefault $Redux.Equipment.GreatFairysSword -Not)   { ChangeBytes -Offset "C572C8" -Values (ConvertFloatToHex $Redux.Equipment.GreatFairysSword.Value) }
    if (IsDefault $Redux.Equipment.BlastMask        -Not)   { ChangeBytes -Offset "CAA666" -Values (Get16Bit  $Redux.Equipment.BlastMask.Value)                }
    if (IsDefault $Redux.Equipment.ShieldRecoil     -Not)   { ChangeBytes -Offset "CAEDC6" -Values (Get16Bit ($Redux.Equipment.ShieldRecoil.Value + 45000) )   }
    if (IsDefault $Redux.Equipment.Hookshot         -Not)   { ChangeBytes -Offset "D3B327" -Values (Get8Bit   $Redux.Equipment.Hookshot.Value)                 }



    # WEAPON DAMAGE #

    if (IsDefault $Redux.Attack.KokiriSlash        -Not)   { ChangeBytes -Offset   "CD751A"                                -Values (Get8Bit $Redux.Attack.KokiriSlash.Text)        }
    if (IsDefault $Redux.Attack.KokiriJump         -Not)   { ChangeBytes -Offset   "CD751B"                                -Values (Get8Bit $Redux.Attack.KokiriJump.Text)         }
    if (IsDefault $Redux.Attack.KokiriSpin         -Not)   { ChangeBytes -Offset   "D3135C"                                -Values (Get8Bit $Redux.Attack.KokiriSpin.Text)         }
    if (IsDefault $Redux.Attack.KokiriGreatSpin    -Not)   { ChangeBytes -Offset   "D31360"                                -Values (Get8Bit $Redux.Attack.KokiriGreatSpin.Text)    }
    if (IsDefault $Redux.Attack.RazorSlash         -Not)   { ChangeBytes -Offset   "CD7522"                                -Values (Get8Bit $Redux.Attack.RazorSlash.Text)         }
    if (IsDefault $Redux.Attack.RazorJump          -Not)   { ChangeBytes -Offset   "CD7523"                                -Values (Get8Bit $Redux.Attack.RazorJump.Text)          }
    if (IsDefault $Redux.Attack.RazorSpin          -Not)   { ChangeBytes -Offset   "D3135D"                                -Values (Get8Bit $Redux.Attack.RazorSpin.Text)          }
    if (IsDefault $Redux.Attack.RazorGreatSpin     -Not)   { ChangeBytes -Offset   "D31361"                                -Values (Get8Bit $Redux.Attack.RazorGreatSpin.Text)     }
    if (IsDefault $Redux.Attack.GildedSlash        -Not)   { ChangeBytes -Offset   "CD752A"                                -Values (Get8Bit $Redux.Attack.GildedSlash.Text)        }
    if (IsDefault $Redux.Attack.GildedJump         -Not)   { ChangeBytes -Offset   "CD752B"                                -Values (Get8Bit $Redux.Attack.GildedJump.Text)         }
    if (IsDefault $Redux.Attack.GildedSpin         -Not)   { ChangeBytes -Offset   "D3135E"                                -Values (Get8Bit $Redux.Attack.GildedSpin.Text)         }
    if (IsDefault $Redux.Attack.GildedGreatSpin    -Not)   { ChangeBytes -Offset   "D31362"                                -Values (Get8Bit $Redux.Attack.GildedGreatSpin.Text)    }
    if (IsDefault $Redux.Attack.TwoHandedSlash     -Not)   { ChangeBytes -Offset   "CD7532"                                -Values (Get8Bit $Redux.Attack.TwoHandedSlash.Text)     }
    if (IsDefault $Redux.Attack.TwoHandedJump      -Not)   { ChangeBytes -Offset   "CD7533"                                -Values (Get8Bit $Redux.Attack.TwoHandedJump.Text)      }
    if (IsDefault $Redux.Attack.TwoHandedSpin      -Not)   { ChangeBytes -Offset   "D3135F"                                -Values (Get8Bit $Redux.Attack.TwoHandedSpin.Text)      }
    if (IsDefault $Redux.Attack.TwoHandedGreatSpin -Not)   { ChangeBytes -Offset   "D31363"                                -Values (Get8Bit $Redux.Attack.DobuleHelixSlash.Text)   }
    if (IsDefault $Redux.Attack.DobuleHelixSlash   -Not)   { ChangeBytes -Offset @("CD7518", "CD7520", "CD7528", "CD7530") -Values (Get8Bit $Redux.Attack.DoubleHelixJump.Text)    }
    if (IsDefault $Redux.Attack.DoubleHelixJump    -Not)   { ChangeBytes -Offset @("CD7519", "CD7521", "CD7529", "CD7531") -Values (Get8Bit $Redux.Attack.TwoHandedGreatSpin.Text) }
    if (IsDefault $Redux.Attack.DekuStickSlash     -Not)   { ChangeBytes -Offset   "CD753A"                                -Values (Get8Bit $Redux.Attack.DekuStickSlash.Text)     }
    if (IsDefault $Redux.Attack.DekuStickJump      -Not)   { ChangeBytes -Offset   "CD753B"                                -Values (Get8Bit $Redux.Attack.DekuStickJump.Text)      }
    if (IsDefault $Redux.Attack.GoronPunch         -Not)   { ChangeBytes -Offset @("CD7510", "CD7511")                     -Values (Get8Bit $Redux.Attack.GoronPunch.Text)         }
    if (IsDefault $Redux.Attack.ZoraPunch          -Not)   { ChangeBytes -Offset   "CD7540"                                -Values (Get8Bit $Redux.Attack.ZoraPunch.Text)          }
    if (IsDefault $Redux.Attack.ZoraJump           -Not)   { ChangeBytes -Offset   "CD7541"                                -Values (Get8Bit $Redux.Attack.ZoraJump.Text)           }



    # ANIMATION #

    if (IsChecked $Redux.Skip.TriSwipe) { ChangeBytes -Offset "C00E52" -Values "0005" }



    # SKIP #

    if (IsDefault $Redux.Skip.OpeningSequence -Not) {
        ChangeBytes -Offset "BDAB78" -Values "340ED800"; ChangeBytes -Offset "BDB880" -Values "340CD800"; ChangeBytes -Offset "BDABA1" -Values "4F"
        if (IsChecked $Redux.Gameplay.PermanentOwlSaves -Not) { ChangeBytes -Offset "BDB997" -Values "C4" }
        ChangeBytes -Offset "F22D90" -Values "1500"                                              # Skip first cycle introduction to Clock Town
        ChangeBytes -Offset "F36EBC" -Values "1500"; ChangeBytes -Offset "F37744" -Values "1100" # Skip first introduction with Happy Mask Salesman
      # PatchBytes  -Offset "BDABC7"  -Patch  "skip_first_cycle.bin" # Skip first cycle introduction to Clock Town
        if (IsIndex -Elem $Redux.Skip.OpeningSequence -Index 3) {
            ChangeBytes -Offset "C5CE24"  -Values "00"; ChangeBytes -Offset "C5CDEC" -Values "01"; ChangeBytes -Offset "C5CDF4" -Values "01";
            ChangeBytes -Offset "C5CE41"  -Values "32"; ChangeBytes -Offset "C5CE72" -Values "30"
            ChangeBytes -Offset "B80F84"  -Values "1500"                 # Skip saving when first entering clock town
            ChangeBytes -Offset "1006864" -Values "1500"                 # Tatl message skip to visit the four giants
          
            
        }
        else { ChangeBytes -Offset "BDADE7" -Values "03"; ChangeBytes -Offset "BDAB89" -Values "4F" }
    }

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
        ChangeBytes -Offset "DA1158" -Values "00000000"; ChangeBytes -Offset "E96988" -Values "00000000"
        ChangeBytes -Offset "F6279C" -Values "00000000"; ChangeBytes -Offset "F62DAC" -Values "00000000"
    }

    if (IsChecked $Redux.Skip.OpeningChests)    { ChangeBytes -Offset   "CB79D0"                                  -Values "1000"                                                    }
    if (IsChecked $Redux.Skip.BusinessScrubs)   { ChangeBytes -Offset @("F4187C", "F42584", "1054648", "1054C80") -Values "00000000"                                                }
    if (IsChecked $Redux.Skip.IronKnuckles)     { ChangeBytes -Offset   "D9D004"                                  -Values "00000000"; ChangeBytes -Offset   "D9E17C" -Values "1000" }



    # SPEEDUP #

    if (IsChecked $Redux.Speedup.LabFish) {
        ChangeBytes -Offset "F8D904" -Values "0000"; ChangeBytes -Offset "F8D907" -Values "00";   ChangeBytes -Offset "F8D91C" -Values "0000";       ChangeBytes -Offset "F8D91F" -Values "000000"
        ChangeBytes -Offset "F8D923" -Values "00";   ChangeBytes -Offset "F8D934" -Values "00";   ChangeBytes -Offset "F8D937" -Values "0000000000"; ChangeBytes -Offset "F8D958" -Values "0000"
        ChangeBytes -Offset "F8D95B" -Values "00";   ChangeBytes -Offset "F8D96C" -Values "0000"; ChangeBytes -Offset "F8D96F" -Values "000000";     ChangeBytes -Offset "F8D973" -Values "00"
        ChangeBytes -Offset "F8D984" -Values "0000"; ChangeBytes -Offset "F8D987" -Values "0000000000"
    }

    if (IsChecked $Redux.Speedup.Dampe) {
        ChangeBytes -Offset "FC86CC" -Values "000000000000000000"; ChangeBytes -Offset "FC86D6" -Values "0000000000"
        ChangeBytes -Offset "FC86DC" -Values "2408";               ChangeBytes -Offset "FC86DF" -Values "08"
    }

    if (IsChecked $Redux.Speedup.DogRace) {
        ChangeBytes -Offset "0E34608" -Values "3C18801F8318F70807"; ChangeBytes -Offset "0E34613" -Values "042418";         ChangeBytes -Offset "0E34617" -Values "092407000D5305"; ChangeBytes -Offset "0E3461F" -Values "012407"
        ChangeBytes -Offset "0E34624" -Values "30B8";               ChangeBytes -Offset "0E34627" -Values "011300000D0000"; ChangeBytes -Offset "0E3462F" -Values "00";             ChangeBytes -Offset "0E34631" -Values "05"
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

    if (IsChecked $Redux.Text.YeetPrompt)        { PatchBytes  -Offset "AC0D80" -Shared -Patch "Action Prompts\throw.en.prompt" }
    if (IsChecked $Redux.Text.Comma)             { ChangeBytes -Offset "ACC660" -Values "00F30000000000004F6000000000000024"    }
    if (IsChecked $Redux.Text.DefaultFileName)   { ChangeBytes -Offset "C8EA3C" -Values "152C312E3E3E3E3E"                      }

}



#==============================================================================================================================================================================================
function ByteReduxOptions() {
    
    # WIDESCREEN #

    if (IsChecked $Redux.Graphics.Widescreen) {
        $offset = SearchBytes -Start $Symbols.PAYLOAD_START -End (AddToOffset -Hex $Symbols.PAYLOAD_START -Add "1000") -Values "3C040004"
        ChangeBytes -Offset $offset -Values "3C 04 00 06"
        ChangeBytes -Offset $Symbols.CFG_WS_ENABLED -Values "01"
    }



    # D-PAD #

    if     (IsChecked $Redux.DPad.Disable)       { ChangeBytes -Offset (AddToOffset $Symbols.DPAD_CONFIG -Add "18") -Values "0000" }
    else {
        if (IsChecked $Redux.DPad.DualSet)       { ChangeBytes -Offset $Symbols.CFG_DUAL_DPAD_ENABLED               -Values "01"   }
        if (IsChecked $Redux.DPad.Hide)          { ChangeBytes -Offset (AddToOffset $Symbols.DPAD_CONFIG -Add "18") -Values "0100" }
        if (IsChecked $Redux.DPad.LayoutLeft)    { ChangeBytes -Offset (AddToOffset $Symbols.DPAD_CONFIG -Add "18") -Values "0101" }
        if (IsChecked $Redux.DPad.LayoutRight)   { ChangeBytes -Offset (AddToOffset $Symbols.DPAD_CONFIG -Add "18") -Values "0102" }
        ChangeBytes -Offset @("BACB4C", "BACB58", "BACB64", "CAA490", "CAA4DC", "CAA524", "CAA2EC") -Values "1000" # Don't toggle off Lens of Truth or unequip items/masks if not on C button 
    }


    
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

    if     (IsIndex -Elem $Redux.Features.CritWiggle        -Index 2)        { ChangeBytes -Offset (AddToOffset $Symbols.MISC_CONFIG -Add "18") -Values "40" -Add }
    elseif (IsIndex -Elem $Redux.Features.CritWiggle        -Index 3)        { ChangeBytes -Offset (AddToOffset $Symbols.MISC_CONFIG -Add "18") -Values "80" -Add }
    if     (IsChecked     $Redux.Features.FasterBlockPushing)                { ChangeBytes -Offset (AddToOffset $Symbols.MISC_CONFIG -Add "18") -Values "10" -Add }
    if     (IsIndex -Elem $Redux.Features.UnderwaterOcarina -Index 1 -Not)   { ChangeBytes -Offset (AddToOffset $Symbols.MISC_CONFIG -Add "18") -Values "08" -Add }
    if     (IsChecked     $Redux.Features.ArrowToggle)                       { ChangeBytes -Offset (AddToOffset $Symbols.MISC_CONFIG -Add "19") -Values "40" -Add }
    if     (IsChecked     $Redux.Features.ElegySpeedup)                      { ChangeBytes -Offset (AddToOffset $Symbols.MISC_CONFIG -Add "19") -Values "10" -Add }
    if     (IsIndex -Elem $Redux.Features.ContinuousDekuHop -Index 1 -Not)   { ChangeBytes -Offset (AddToOffset $Symbols.MISC_CONFIG -Add "19") -Values "08" -Add }
    if     (IsIndex -Elem $Redux.Features.HealthBar         -Index 1 -Not)   { ChangeBytes -Offset (AddToOffset $Symbols.MISC_CONFIG -Add "1A") -Values "40" -Add }
    if     (IsIndex -Elem $Redux.Features.BombchuDrops      -Index 1 -Not)   { ChangeBytes -Offset (AddToOffset $Symbols.MISC_CONFIG -Add "1B") -Values "40" -Add }
    if     (IsChecked     $Redux.Features.InstantTransform)                  { ChangeBytes -Offset (AddToOffset $Symbols.MISC_CONFIG -Add "1B") -Values "20" -Add }
  # if     (IsChecked     $Redux.Features.BombArrows)                        { ChangeBytes -Offset (AddToOffset $Symbols.MISC_CONFIG -Add "1B") -Values "10" -Add }
    if     (IsIndex -Elem $Redux.Features.GiantMaskAnywhere -Index 1 -Not)   { ChangeBytes -Offset (AddToOffset $Symbols.MISC_CONFIG -Add "1B") -Values "08" -Add }
    if     (IsChecked     $Redux.Features.ShortChestOpening)                 { ChangeBytes -Offset (AddToOffset $Symbols.MISC_CONFIG -Add "25") -Values "80" -Add }
    
    if (IsIndex -Elem $Redux.Features.UnderwaterOcarina -Index 1 -Not)   { ChangeBytes -Offset $Symbols.CFG_BOSS_REMAINS_UNDERWATER_OCARINA -Values ($Redux.Features.UnderwaterOcarina.SelectedIndex - 1) }
    if (IsIndex -Elem $Redux.Features.ContinuousDekuHop -Index 1 -Not)   { ChangeBytes -Offset $Symbols.CFG_BOSS_REMAINS_DEKU_HOP           -Values ($Redux.Features.ContinuousDekuHop.SelectedIndex - 1) }
    if (IsIndex -Elem $Redux.Features.HealthBar         -Index 1 -Not)   { ChangeBytes -Offset $Symbols.CFG_BOSS_REMAINS_HEALTH_BAR         -Values ($Redux.Features.HealthBar.SelectedIndex         - 1) }
    if (IsIndex -Elem $Redux.Features.BombchuDrops      -Index 1 -Not)   { ChangeBytes -Offset $Symbols.CFG_BOSS_REMAINS_BOMBCHU_DROPS      -Values ($Redux.Features.BombchuDrops.SelectedIndex      - 1) }
    if (IsIndex -Elem $Redux.Features.GiantMaskAnywhere -Index 3)        { ChangeBytes -Offset $Symbols.CFG_FIERCE_DEITY_GIANTS_MASK        -Values "01" }

    if (IsIndex -Elem $Redux.Features.ClockControl -Index 1 -Not)   { ChangeBytes -Offset $Symbols.CFG_CLOCK_CONTROL_ENABLED -Values $Redux.Features.ClockControl.SelectedIndex }
    if (IsChecked     $Redux.Features.FlowOfTime)                   { ChangeBytes -Offset $Symbols.CFG_FLOW_OF_TIME_ENABLED  -Values "01"                                       }
    if (IsChecked     $Redux.Features.InstantElegy)                 { ChangeBytes -Offset $Symbols.CFG_INSTANT_ELEGY_ENABLED -Values "01"                                       }
    if (IsChecked     $Redux.Features.RupeeDrain)                   { ChangeBytes -Offset $Symbols.CFG_RUPEE_DRAIN           -Values (Get8Bit $Redux.Features.RupeeDrain.Text)  }
    if (IsChecked     $Redux.Features.FPS)                          { ChangeBytes -Offset $Symbols.CFG_FPS_ENABLED           -Values "01"                                       }
    if (IsChecked     $Redux.Features.HUDToggle)                    { ChangeBytes -Offset $Symbols.CFG_HIDE_HUD_ENABLED      -Values "01"                                       }
    if (IsChecked     $Redux.Features.ItemsUnequip)                 { ChangeBytes -Offset $Symbols.CFG_UNEQUIP_ENABLED       -Values "01"                                       }
    if (IsChecked     $Redux.Features.ItemsOnB)                     { ChangeBytes -Offset $Symbols.CFG_B_BUTTON_ITEM_ENABLED -Values "01"                                       }
    if (IsChecked     $Redux.Features.GearSwap)                     { ChangeBytes -Offset $Symbols.CFG_SWAP_ENABLED          -Values "01"                                       }
    if (IsChecked     $Redux.Features.SkipGuard)                    { ChangeBytes -Offset $Symbols.CFG_SKIP_GUARD_ENABLED    -Values "01"                                       }
    if (IsChecked     $Redux.Features.InverseAim)                   { ChangeBytes -Offset $Symbols.CFG_INVERSE_AIM           -Values "01"                                       }
    


    # CHEATS #

    if (IsChecked $Redux.Cheats.InventoryEditor)   { ChangeBytes -Offset $Symbols.CFG_INVENTORY_EDITOR_ENABLED -Values "01" }
    if (IsChecked $Redux.Cheats.Health)            { ChangeBytes -Offset $Symbols.CFG_INFINITE_HEALTH          -Values "01" }
    if (IsChecked $Redux.Cheats.Magic)             { ChangeBytes -Offset $Symbols.CFG_INFINITE_MAGIC           -Values "01" }
    if (IsChecked $Redux.Cheats.Ammo)              { ChangeBytes -Offset $Symbols.CFG_INFINITE_AMMO            -Values "01" }
    if (IsChecked $Redux.Cheats.Rupees)            { ChangeBytes -Offset $Symbols.CFG_INFINITE_RUPEES          -Values "01" }
    if (IsChecked $Redux.Cheats.ClimbAnything)     { ChangeBytes -Offset "CB8810" -Values "1000"; ChangeBytes -Offset "CC69E4" -Values "00000000"; ChangeBytes -Offset (AddToOffset $Symbols.MISC_CONFIG -Add "1A") -Values "20" -Add }



    # BUTTON COLORS #
    
    if (IsSet $Redux.Colors.SetButtons) {
        if (IsColor $Redux.Colors.SetButtons[0] -Not) { # A Button
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

        if (IsColor $Redux.Colors.SetButtons[1] -Not) { # B Button
            ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "0C") -Values @($Redux.Colors.SetButtons[1].Color.R, $Redux.Colors.SetButtons[1].Color.G, $Redux.Colors.SetButtons[1].Color.B) # Button
            ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "5C") -Values @($Redux.Colors.SetButtons[1].Color.R, $Redux.Colors.SetButtons[1].Color.G, $Redux.Colors.SetButtons[1].Color.B) # Text Icons
        }

        if (IsColor $Redux.Colors.SetButtons[2] -Not) { # C Buttons
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

        if (IsColor $Redux.Colors.SetButtons[3] -Not) { # Start Button
            ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "14") -Values @($Redux.Colors.SetButtons[3].Color.R, $Redux.Colors.SetButtons[3].Color.G, $Redux.Colors.SetButtons[3].Color.B) # Button
    }
    }



    # HUD COLORS #

    if (IsSet $Redux.Colors.SetHUDStats) {
        if (IsColor $Redux.Colors.SetHUDStats[0] -Not)   { ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "30") -Values @($Redux.Colors.SetHUDStats[0].Color.R, $Redux.Colors.SetHUDStats[0].Color.G, $Redux.Colors.SetHUDStats[0].Color.B) } # Hearts
        if (IsColor $Redux.Colors.SetHUDStats[1] -Not)   { ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "34") -Values @($Redux.Colors.SetHUDStats[1].Color.R, $Redux.Colors.SetHUDStats[1].Color.G, $Redux.Colors.SetHUDStats[1].Color.B) } # Hearts
        if (IsColor $Redux.Colors.SetHUDStats[2] -Not)   { ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "38") -Values @($Redux.Colors.SetHUDStats[2].Color.R, $Redux.Colors.SetHUDStats[2].Color.G, $Redux.Colors.SetHUDStats[2].Color.B) } # Magic
        if (IsColor $Redux.Colors.SetHUDStats[3] -Not)   { ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "3C") -Values @($Redux.Colors.SetHUDStats[3].Color.R, $Redux.Colors.SetHUDStats[3].Color.G, $Redux.Colors.SetHUDStats[3].Color.B) } # Magic
        if (IsColor $Redux.Colors.SetHUDStats[4] -Not)   { ChangeBytes -Offset (AddToOffset $Symbols.HUD_COLOR_CONFIG -Add "40") -Values @($Redux.Colors.SetHUDStats[4].Color.R, $Redux.Colors.SetHUDStats[4].Color.G, $Redux.Colors.SetHUDStats[4].Color.B) } # Minimap
    }

}



#==============================================================================================================================================================================================
function ByteSceneOptions() {
    
    # GAMEPLAY #

    if (IsChecked $Redux.Gameplay.AdditionalSaveStatues) {
        ChangeBytes -Offset "BDAF57" -Values "4C"; ChangeBytes -Offset "BDB8C7" -Values "50" # Shift Mask C-Button tables for NES SRAM
        ChangeBytes -Offset "C5CF8C" -Values "2F23291D"                                      # Re-align second Mask C-Button table for NES SRAM
        ChangeBytes -Offset "C5CF90" -Values "68B06A60B2309A80D8903E40864084A02040AA30"      # Re-align Owl Statue save entrance table for NES SRAM
        ChangeBytes -Offset "C5CFA4" -Values "8000220030003C008C002600"                      # Extend Owl Statue save entrance table for NES SRAM -> Graveyard, Pirate's Fortress (Exterior), Woodfall Temple, Snowhead Temple, Great Bay Temple, Stone Tower Temple
      # ChangeBytes -Offset "C5CFAC" -Values "80002200"                                      # Graveyard, Pirate's Fortress (Exterior)

        PrepareMap   -Scene "Ikana Graveyard" -Map 0 -Header 0
        InsertActor  -Name "Owl Statue" -Param "000A" -X (-170) -Y (-40) -Z 820 -YRot 90
        InsertObject -Name "Owl Statue"
        SaveAndPatchLoadedScene

        PrepareMap   -Scene "Pirates' Fortress (Exterior)" -Map 0 -Header 0
        InsertActor  -Name "Owl Statue" -Param "000B" -X 640 -Y (-140) -Z (-800) -YRot 140
        InsertObject -Name "Owl Statue"
        SaveAndPatchLoadedScene

        PrepareMap   -Scene "Woodfall Temple" -Map 2 -Header 0
        ReplaceActor -Name "Pot" -New "Owl Statue" -Param "000C" -XRot 0 -YRot 315 -ZRot 0 -Compare "4210"
        InsertObject -Name "Owl Statue"
        SaveAndPatchLoadedScene

        PrepareMap   -Scene "Snowhead Temple" -Map 0 -Header 0
        InsertActor  -Name "Owl Statue" -Param "000D" -X (-140) -Y 0 -Z 1180 -YRot 135
        InsertObject -Name "Owl Statue"
        SaveAndPatchLoadedScene

        PrepareMap   -Scene "Great Bay Temple" -Map 13 -Header 0
        InsertActor  -Name "Owl Statue" -Param "000E" -X (-200) -Y (-210) -Z 2480
        InsertObject -Name "Owl Statue"
        SaveAndPatchLoadedScene

        PrepareMap   -Scene "Stone Tower Temple" -Map 0 -Header 0
        InsertActor  -Name "Owl Statue" -Param "000F" -X 340 -Y 0 -Z 90 -YRot 220
        InsertObject -Name "Owl Statue"
        SaveAndPatchLoadedScene
    }

    if (IsChecked $Redux.Gameplay.RoyalWallet) {
        PrepareMap   -Scene "Trading Post" -Map 0 -Header 0
        InsertObject -Name "Wallets"
        SaveAndPatchLoadedScene
    }



    # FIXES #

    if (IsChecked $Redux.Fixes.Geometry) {
        PrepareMap -Scene "South Clock Town" -Map 0 -Header 0
        $offset = ChangeMapFile -Values "FE7700C8FB1B000004E5F6AFEC69CA" -Search "FDFF0097FB1B000004E5" -Start "3100"              # Ramp
        $offset = ChangeMapFile -Values "0000"                                                          -Offset ($offset + 0x1352) # Wall
        $offset = ChangeMapFile -Values "0000"                                                          -Offset ($offset + 0x10)   # Wall
                  ChangeMapFile -Values "0000"                                                          -Offset ($offset + 0x30)   # Wall
        SaveAndPatchLoadedScene

        PrepareMap -Scene "Laundry Pool" -Map 0 -Header 0
        ChangeMapFile -Values "7AFFE4016300000EA6" -Search "49FFE4014E00000CC40200D1006EFFFA" -Start "1450" # Path
        ChangeMapFile -Values "7AFFE4016300001755" -Search "49FFE4014E000014AC0200D1006EFFFA" -Start "1A60" # Path
        SaveAndPatchLoadedScene

        PrepareMap -Scene "North Clock Town" -Map 0 -Header 0
        ChangeMapFile -Values "20" -Search "3078E700000000000000E30010010000" -Start "5100"; ChangeMapFile -Values "C1" -Search "CDE0F5100000070D0050E60000000000" -Start "5110" # Road
        ChangeMapFile -Values "05" -Search "0D0050E600000000000000F300000007" -Start "5120"; ChangeMapFile -Values "05" -Search "0D0050F20000000007C03CD900000000" -Start "5140" # Road
        SaveAndPatchLoadedScene

        if (IsChecked $Redux.Hero.RaisedResearchLabPlatform -Not) {
            PrepareMap -Scene "Great Bay Coast" -Map 0 -Header 0
            $offset = ChangeMapFile -Values "0F" -Search "07FFD30F3A0000089904002E920032F5" -Start "12BC0" # Research Lab Platform (0x26F0BC9)
            $offset = ChangeMapFile -Values "0F" -Offset ($offset + 0x10)
            $offset = ChangeMapFile -Values "5F" -Offset ($offset + 0x10)
                      ChangeMapFile -Values "5F" -Offset ($offset + 0x10)
            SaveAndPatchLoadedScene
        }

        PrepareMap -Scene "Ikana Canyon" -Map 0 -Header 0
        ChangeMapFile -Values "023EE003011D" -Search "011D000000000000E8FDF80CF607B800" -Start "500" # Texture on Ancient Castle of Ikana wall
        SaveAndPatchLoadedScene
    }

    if (IsChecked $Redux.Fixes.OutOfBounds) {
        PrepareMap -Scene "Path to Goron Village (Winter)" -Map 0 -Header 0
        ReplaceActor -Name "Grotto Entrance" -CompareX (-183) -CompareY 929 -CompareZ 162 -X (-1309) -Y 320 -Z 142 -YRot 0x44 -ZRot 4 -Param "0299" # Grotto
        SaveAndPatchLoadedScene

        PrepareMap -Scene "Deku Palace" -Map 2 -Header 0
        ReplaceActor -Name "Collectable" -Compare "0A00" -CompareX 16 -X (-666) # Rupee
        SaveAndPatchLoadedScene
    }

    if (IsChecked $Redux.Fixes.Cutscenes) {
        PrepareMap -Scene "North Clock Town" -Map 0 -Header 1
        ReplaceActor -Name "Old Lady From Bomb Shop" -Compare "05FF" -Param "02FF"
        ReplaceActor -Name "Old Lady From Bomb Shop" -Compare "FFFF" -Param "7FFF"
        SaveAndPatchLoadedScene

        PrepareMap -Scene "Chamber of Giants" -Map 0 -Header 4;  ReplaceActor -Name "Giant" -Param "FE08"; SaveLoadedMap
        PrepareMap -Scene "Chamber of Giants" -Map 0 -Header 5;  ReplaceActor -Name "Giant" -Param "FE08"; SaveLoadedMap
        PrepareMap -Scene "Chamber of Giants" -Map 0 -Header 6;  ReplaceActor -Name "Giant" -Param "FE08"; SaveLoadedMap
        PrepareMap -Scene "Chamber of Giants" -Map 0 -Header 7;  ReplaceActor -Name "Giant" -Param "FE08"; SaveLoadedMap
        PrepareMap -Scene "Chamber of Giants" -Map 0 -Header 8;  ReplaceActor -Name "Giant" -Param "FE08"; SaveLoadedMap
        PrepareMap -Scene "Chamber of Giants" -Map 0 -Header 9;  ReplaceActor -Name "Giant" -Param "FE08"; SaveLoadedMap
        PrepareMap -Scene "Chamber of Giants" -Map 0 -Header 10; ReplaceActor -Name "Giant" -Param "FE08"; SaveAndPatchLoadedScene
    
        PrepareMap -Scene "Mountain Village (Spring)" -Map 0 -Header 1; InsertObject -Name "Pot";          InsertObject -Name "Square Sign"; InsertObject -Name "Frog"; InsertObject -Name "Giant Bee"; SaveLoadedMap
        PrepareMap -Scene "Mountain Village (Spring)" -Map 1 -Header 1; InsertObject -Name "Gossip Stone"
        ChangeSceneFile -Values "19" -Search "0004020000020059E80E030000020059"; SaveAndPatchLoadedScene

        PrepareMap -Scene "Ikana Canyon" -Map 0 -Header 2; InsertObject -Name "Business Scrub & Deku Scrub Playground Employee"; SaveLoadedMap
        PrepareMap -Scene "Ikana Canyon" -Map 1 -Header 2; InsertObject -Name "Business Scrub & Deku Scrub Playground Employee"; SaveLoadedMap
        PrepareMap -Scene "Ikana Canyon" -Map 2 -Header 2; InsertObject -Name "Business Scrub & Deku Scrub Playground Employee"; SaveLoadedMap
        PrepareMap -Scene "Ikana Canyon" -Map 3 -Header 2; InsertObject -Name "Business Scrub & Deku Scrub Playground Employee"; SaveLoadedMap
        PrepareMap -Scene "Ikana Canyon" -Map 4 -Header 2; InsertObject -Name "Business Scrub & Deku Scrub Playground Employee"; SaveLoadedMap
        ChangeSceneFile -Values "04" -Search "00FF00FF00180851FDAD0C917CFF007F" -Start "DBD0";  ChangeSceneFile -Values "04" -Search "00FF00FF001807C8FEE80DAE78FF007F" -Start "DBE0";  ChangeSceneFile -Values "00" -Search "03FF03FF0018F93401FF068F5A7F00FF" -Start "DBF0"
        ChangeSceneFile -Values "04" -Search "00FF00FF00180851FDAD0C917CFF007F" -Start "13150"; ChangeSceneFile -Values "04" -Search "00FF00FF001807C8FEE80DAE78FF007F" -Start "13160"; ChangeSceneFile -Values "00" -Search "03FF03FF0018F93401FF068F5A7F00FF" -Start "13170"
        SaveAndPatchLoadedScene

        PrepareMap -Scene "The Moon" -Map 0 -Header 0
        ChangeSceneFile -Values "0000" -Search "FFFFFFFF00FF00000120FFFF00000000" -Start "6C0" # On the Moon entrance intro
        SaveAndPatchLoadedScene
    }



    # GRAPHICS #

    if (IsChecked $Redux.Graphics.OverworldSkyboxes) {
        for ($i=0; $i-lt 4;  $i++)   { PrepareAndSetSceneSettings -Scene "Lost Woods"                     -Map 0 -Header $i -Skybox 1 }; SaveAndPatchLoadedScene
        for ($i=0; $i-lt 2;  $i++)   { PrepareAndSetSceneSettings -Scene "Path to Mountain Village"       -Map 0 -Header $i -Skybox 1 }; SaveAndPatchLoadedScene
                                       PrepareAndSetSceneSettings -Scene "Mountain Village (Winter)"      -Map 0 -Header 0  -Skybox 1;   SaveAndPatchLoadedScene
                                       PrepareAndSetSceneSettings -Scene "Path to Goron Village (Winter)" -Map 0 -Header 0  -Skybox 1;   SaveAndPatchLoadedScene
        for ($i=0; $i-lt 2;  $i++)   { PrepareAndSetSceneSettings -Scene "Goron Racetrack"                -Map 0 -Header $i -Skybox 1 }; SaveAndPatchLoadedScene
                                       PrepareAndSetSceneSettings -Scene "Goron Village (Winter)"         -Map 0 -Header 0  -Skybox 1;   SaveAndPatchLoadedScene
        for ($i=0; $i-lt 2;  $i++)   { PrepareAndSetSceneSettings -Scene "Path to Snowhead"               -Map 0 -Header $i -Skybox 1 }; SaveAndPatchLoadedScene
        for ($i=0; $i-lt 2;  $i++)   { PrepareAndSetSceneSettings -Scene "Snowhead"                       -Map 0 -Header $i -Skybox 1 }; SaveAndPatchLoadedScene
                                       PrepareAndSetSceneSettings -Scene "Beneath the Graveyard"          -Map 0 -Header 0  -Skybox 0;   SaveAndPatchLoadedScene
        for ($i=0; $i-lt 12; $i++)   { PrepareAndSetSceneSettings -Scene "Cutscene Map"                   -Map 0 -Header $i -Skybox 0 }; SaveAndPatchLoadedScene
    }



    # HERO MODE #

    if (IsChecked $Redux.Hero.RaisedResearchLabPlatform) {
        PrepareMap -Scene "Great Bay Coast" -Map 0 -Header 0

                  ChangeSceneFile -Values "28"                                                                                     -Search "0F0F8A00075A00007F06FF0000FB3501" -Start "15D"  # 0x26BF15D
        $offset = ChangeSceneFile -Values "D8"                                                                                     -Search "F1001202340230023200007FFF0000FF" -Start "60DF" # 0x26C50DF
        $offset = ChangeSceneFile -Values "D8"                                                                                     -Offset ($offset + 0x10)                                 # 0x26C50EF
        $offset = ChangeSceneFile -Values "EC"                                                                                     -Offset ($offset + 0x50)                                 # 0x26C513F
                  ChangeSceneFile -Values "EC"                                                                                     -Offset ($offset + 0x10)                                 # 0x26C514F
        $offset = ChangeSceneFile -Values "EC10CAF51BFFEC10CAF51B002810CAF453002810CAF51B00280F3AF51BFFEC0F3AF45300280F3AF453FFEC" -Search "D310CAF51BFFD310CAF51B000F10CAF4" -Start "8B50" # 0x26C7B57
        $offset = ChangeSceneFile -Values "28"                                                                                     -Offset ($offset + 0x114)                                # 0x26C7C6B
                  ChangeSceneFile -Values "28"                                                                                     -Offset ($offset + 0x6)                                  # 0x26C7C71
                  ChangeSceneFile -Values "28"                                                                                     -Search "0F0F8A00075A00007F06FF0000FB3501" -Start "9560" # 0x26C8565

                  ChangeMapFile -Values "28" -Search "0F0F5100070010007F00002055054F00" -Start "420"   # 0x26DE425
                  ChangeMapFile -Values "28" -Search "0F0F5100070010007F0000E0C6FEA7FE" -Start "1590"  # 0x26DF599
        
        $offset = ChangeMapFile -Values "28" -Search "0F0F3A000013670400D26E00D4F45F00" -Start "12030" # 0x26F003B
        $offset = ChangeMapFile -Values "28" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "28" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "28" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "EC" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "EC" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "F8" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "1C" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "28" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "28" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "1C" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "F8" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "F8" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "1C" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "28" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "28" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "1C" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "F8" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "EC" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "EC" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "28" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "28" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "1C" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "1C" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "F8" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "F8" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "EC" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "EC" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "1C" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "1C" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "28" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "28" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "F8" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "F8" -Offset ($offset + 0x10)
        $offset = ChangeMapFile -Values "EC" -Offset ($offset + 0x10)
                  ChangeMapFile -Values "EC" -Offset ($offset + 0x10)

        $offset = ChangeMapFile -Values "0FFFEC" -Search "07FFD30F3A0000089904002E920032F5" -Start "12BC0" # 0x26F0BC9
        $offset = ChangeMapFile -Values "0FFFEC" -Offset ($offset + 0x10)                                  # 0x26F0BD9
        $offset = ChangeMapFile -Values "5FFFEC" -Offset ($offset + 0x10)                                  # 0x26F0BE9
                  ChangeMapFile -Values "5FFFEC" -Offset ($offset + 0x10)                                  # 0x26F0BF9
        
        $offset = ChangeMapFile -Values "00C4"   -Search "041C780000E6F471000F0FF500000266" -Start "144EA" # 0x26F24EA
        $offset = ChangeMapFile -Values "28"     -Offset ($offset + 0x9)                                   # 0x26F24F3
        $offset = ChangeMapFile -Values "28"     -Offset ($offset + 0x10)                                  # 0x26F2503
        $offset = ChangeMapFile -Values "00C4"   -Offset ($offset + 0x17)                                  # 0x26F251A
        $offset = ChangeMapFile -Values "28"     -Offset ($offset + 0x9)                                   # 0x26F2523
        $offset = ChangeMapFile -Values "28"     -Offset ($offset + 0x10)                                  # 0x26F2533
        $offset = ChangeMapFile -Values "28"     -Offset ($offset + 0x50)                                  # 0x26F2583
                  ChangeMapFile -Values "28"     -Offset ($offset + 0x10)                                  # 0x26F2593

        SaveAndPatchLoadedScene
    }

    if (IsChecked $Redux.Hero.MoveGoldDust) {
        PrepareMap   -Scene "Pirates' Fortress (Entrance)" -Map 0 -Header 0
        InsertActor  -Name "Treasure Chest" -Param "00C2" -X 50 -Y 220 -Z 1580 -YRot 200 -NoXRot -NoZRot
        SaveAndPatchLoadedScene

        PrepareMap   -Scene "Pirates' Fortress (Interior)" -Map 7 -Header 0
        ReplaceActor -Name "Treasure Chest" -Compare "00C3" -Param "0D43"
        SaveAndPatchLoadedScene

        ChangeBytes -Offset "FB76E7" -Values "5A"; ChangeBytes -Offset "FB76FF" -Values "04"; ChangeBytes -Offset "FB7723" -Values "5A" # Goron Race
    }

    if (IsChecked $Redux.Hero.RedTektites) {
        PrepareMap  -Scene "Path to Mountain Village" -Map 0 -Header 1
        ReplaceActor -Name "Tektite" -Compare "FFFE" -Param "FFFF"
        ReplaceActor -Name "Tektite" -Compare "FFFE" -Param "FFFF"
        ReplaceActor -Name "Tektite" -Compare "FFFE" -Param "FFFF"
        SaveAndPatchLoadedScene

        PrepareMap  -Scene "Path to Goron Village (Spring)" -Map 0 -Header 0
        ReplaceActor -Name "Tektite" -Compare "FFFE" -Param "FFFF"
        SaveAndPatchLoadedScene
    }



    # EASY MODE #

    if ( (IsChecked $Redux.EasyMode.PauseTimeDungeons)     -or (IsChecked $Redux.EasyMode.PauseTime) ) {
        for ($i=0; $i -lt 13; $i++) { PrepareAndSetMapSettings -Scene "Woodfall Temple"               -Map $i -Header 0 -TimeSpeed 0; SaveLoadedMap }
        PatchLoadedScene

        for ($i=0; $i -lt 14; $i++) { PrepareAndSetMapSettings -Scene "Snowhead Temple"               -Map $i -Header 0 -TimeSpeed 0; SaveLoadedMap }
        PatchLoadedScene

        for ($i=0; $i -lt 16; $i++) { PrepareAndSetMapSettings -Scene "Great Bay Temple"              -Map $i -Header 0 -TimeSpeed 0; SaveLoadedMap }
        PatchLoadedScene

        for ($i=0; $i -lt 12; $i++) { PrepareAndSetMapSettings -Scene "Stone Tower Temple"            -Map $i -Header 0 -TimeSpeed 0; SaveLoadedMap }
        PatchLoadedScene

        for ($i=0; $i -lt 12; $i++) { PrepareAndSetMapSettings -Scene "Stone Tower Temple (Inverted)" -Map $i -Header 0 -TimeSpeed 0; SaveLoadedMap }
        PatchLoadedScene
    }

    if ( (IsChecked $Redux.EasyMode.PauseTimeMiniDungeons) -or (IsChecked $Redux.EasyMode.PauseTime) ) {
        for ($i=0; $i -lt 14; $i++) { PrepareAndSetMapSettings -Scene "Beneath the Well"              -Map $i -Header 0 -TimeSpeed 0; SaveLoadedMap }
        PatchLoadedScene

        for ($i=0; $i -lt 10; $i++) { PrepareAndSetMapSettings -Scene "Ancient Castle of Ikana"       -Map $i -Header 0 -TimeSpeed 0; SaveLoadedMap }
        PatchLoadedScene
    }

    if ( (IsChecked $Redux.EasyMode.PauseTimeSpiderHouses) -or (IsChecked $Redux.EasyMode.PauseTime) ) {
        for ($i=0; $i -lt 6; $i++)  { PrepareAndSetMapSettings -Scene "Swamp Spider House"            -Map $i -Header 0 -TimeSpeed 0; SaveLoadedMap }
        PatchLoadedScene

        for ($i=0; $i -lt 6; $i++)  { PrepareAndSetMapSettings -Scene "Oceanside Spider House"        -Map $i -Header 0 -TimeSpeed 0; SaveLoadedMap }
        PatchLoadedScene
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
    
    # QUALITY OF LIFE #

    if (IsChecked $Redux.Gameplay.PermanentOwlSaves) {
        SetMessage -ID "0C01" -Replace "<DI>You can <R>save<W> your <R>progress<W> here.<N>When you reselect your file, my face<N>will appear by your file name.<DC><New Box><DI>This indicates that the next time<N>you reopen your file, you'll resume<N>playing at this <R>very place<W> and<N><R>time<W> with your <R>current status<W>.<DC><New Box><DI>Play the <R>Song of Time<W> to erase my<N>face from your file name again. Then<N>you start from the <R>First Day<W> again.<DC><New Box><R>Save<W> your <R>progress<W> up to this point?<N><G><Two Choices>No<N>Yes"
    }

    if (IsChecked $Redux.Gameplay.RoyalWallet) {
        if (IsChecked $Redux.Capacity.EnableWallet) { $wallet = $Redux.Capacity.Wallet4.Text } else { $wallet = "999" }
        SetMessage       -ID "00BF" -Replace ("<DI>You got a <R>Royal Wallet<W>!<DC><N><Resume:000A>This thing is bottomless!<N>It can hold up to <R>" + $wallet + " Rupees<W>.")
        SetMessageBox    -ID "00BF" -Type 2 -Position 0
        SetMessageIcon   -ID "00BF" -Hex "70"

        SetMessage       -ID "2776" -Replace ("<R>Royal Wallet: " + $Redux.Capacity.Wallet3.Text + " Rupees<W><N>A bottomless wallet that can<N>hold an insane amount of Rupees<N>inside of it!<Shop Description>")
        SetMessageRupees -ID "2776" -Value ([uint16]$Redux.Capacity.Wallet3.Text)
        SetMessageBox    -ID "2776" -Type 6 -Position 3
        SetMessageIcon   -ID "2776" -Hex "FE"
        SetMessage       -ID "2778" -Replace ("Royal Wallet: "    + $Redux.Capacity.Wallet3.Text + " Rupees<N><N><G><Two Choices>I'll buy it<N>No thanks")
        SetMessageRupees -ID "2778" -Value ([uint16]$Redux.Capacity.Wallet3.Text)
        SetMessageBox    -ID "2778" -Type 6 -Position 3
        SetMessageIcon   -ID "2778" -Hex "FE"
    }



    # GRAPHICS #

    if (IsChecked $Redux.UI.GCScheme -Lang 1) { 
        SetMessage -ID "004C" -Text "four <C><C Button><W> Buttons to play it. Press<N><B Button> to stop." -Replace "four <C><C Button><W> directions to play it.<N>Press <B Button> to stop."
        SetMessage -ID "1700" -Text "<C Button><N>Buttons. Press" -Replace "<C Button>.<N>Press"

        SetMessage -ID "001A" -Text "Press" -Replace "Use";      SetMessage -ID "0022" -All; SetMessage -ID "0028"; SetMessage -ID "0029"; SetMessage -ID "002A"; SetMessage -ID "002E"; SetMessage -ID "0034"; SetMessage -ID "0036"
        SetMessage -ID "003A"; SetMessage -ID "0041"; SetMessage -ID "0078"; SetMessage -ID "1701"; SetMessage -ID "1706"; SetMessage -ID "1709"; SetMessage -ID "170E"; SetMessage -ID "170F"; SetMessage -ID "1717"
        SetMessage -ID "171B"; SetMessage -ID "172E"

        SetMessage -ID "0014" -Text "press" -Replace "use"; SetMessage -ID "0015"; SetMessage -ID "0016"; SetMessage -ID "0017"; SetMessage -ID "0018"; SetMessage -ID "0019"; SetMessage -ID "0035"; SetMessage -ID "0200"; SetMessage -ID "09E3"
        SetMessage -ID "1F4F"

        SetMessage -ID "0078" -Text "the body of a Deku. Press <C><C Button>" -Replace "the body of a Deku. Use <C><C Button>"
        SetMessage -ID "0079" -Text "the body of a Goron. Press <C><C Button>" -Replace "the body of a Goron. Use <C><C Button>"
        SetMessage -ID "007A" -Text "the body of a Zora. Press <C><C Button>" -Replace "the body of a Zora. Use <C><C Button>"

        SetMessage -ID "0043" -Text "Press <C><C Button> <W>to look through it" -Replace "Use <C><C Button> <W>to look through it"
        SetMessage -ID "0059" -Text "then press that <N><C><C Button> <W>Button to use it." -Replace "then use <N><C><C Button><W>."
    }



    # DIFFICULTY #

    if (IsChecked $Redux.Hero.RedTektites) { SetMessage -ID "1946" -Text "Blue" -Replace "" }



    # EQUIPMENT #

    if ( (IsChecked $Redux.Equipment.PermanentRazorSword -Lang 1) -or (IsChecked -Elem $Redux.Features.GearSwap -Redux) ) {
        SetMessage -ID "0038" -Text "This new, sharper blade is a cut<N>above the rest. Use it up to<N><R>100 times <W>without dulling its<N>superior edge!"                            -Replace "This new, sharper blade is a cut<N>above the rest. Use it as much<N>as you want without dulling its<N>superior edge!"
        SetMessage -ID "0C3B" -Text "Keep in mind that after you use<N>your reforged sword <R>100 times<W>, it<N>will lose its edge and it'll be back<N>to its original sharpness..."   -Replace "This reforged blade will be <R>unbreakable<W>.<N>Ohh... Don't look at me like that.<N>Surely I would not dare conning you<N>with a flimsy weapon."
        SetMessage -ID "0C51" -Text "Now keep in mind that after<N>you've used this <R>100 times<W>, the<N>blade will lose its edge and will<N>return to its <R>original sharpness<W>." -Replace "You do not need to worry for it, as<N>this blade is <R>unbreakable<W>. What!?<N>You do not believe me? Go see it<N>for yourself then in action."
        SetMessage -ID "1785" -Text "Use it up to <R>100 times<W>."                                                                                                                     -Replace "Use it as much you want."
    }



    # LANGUAGE #

    if (IsChecked $Redux.Hero.MoveGoldDust -Lang 1) {
        SetMessage -ID "0C49" -Text "is the prize for winning<N>the <R>Patriarch's Race<W> that's held by<N>the Gorons every spring?" -Replace "has been stolen by<N>the <R>pirates at Great Bay<W>?"
        SetMessage -ID "0C4A" -Text "entering that"                                                                                   -Replace "to retrieve it back"
        SetMessage -ID "0C4B" -Text "be first prize at the<N>Goron racetrack"                                                         -Replace "be stolen by the pirates<N>of Great Bay"
    }

    if (IsChecked $Redux.Text.Restore -Lang 1) {
        # Trouple Leader's Mask
        PatchBytes -Offset "A2DDC4" -Patch "Icons\troupe_leaders_mask_text.yaz0" -Length "26F" -Texture # Correct Circus Mask
        SetMessage -ID "0083" -Text "Circus" -Replace "Trouple"; SetMessage -ID "173D"; SetMessage -ID "1FF4"; SetMessage -ID "210A"; SetMessage -ID "21B4"; SetMessage -ID "2341"

        # Retranslations
        SetMessage -ID "0804" -Replace "<Sound:398F>Actually, when I look at you,<N>it reminds me of my <R>son<W> who<N>left the house a long time ago...<New Box>Somehow, it felt as if I was<N>competing with my <R>son<W> once more,<N>so I put all my effort into it...<Reset><New Box II>Please excuse my rudeness.<New Box>I look forward to seeing you again...<N>Be careful.<End>"
        SetMessage -ID "101F" -Replace "Today, Mikau, the one person<N>whom I didn't want to know,<N>about it, found out everything.<New Box>At first, I was ashamed and<N>too sad, I couldn't help it.<Reset><New Box>At that time, I thought the<N>words Mikau said eased my heart.<New Box>But please, Mikau, I'm begging you,<N>don't do anything rash.<End>"
        SetMessage -ID "1030" -Text    "Now I can continue resting in<N>peace. I too must abide the laws<N>of ancient times and again merely<N>watch from my deep slumber." `
                              -Replace "Now the Zora Warrior's soul<N>can rest in peace...<New Box>I, too, must abide the laws<N>of ancient times, and have to<N>return again to my deep slumber..."
        # Typos and fixes
        SetMessage -ID "0089" -Text "Kamaro's Mask<W>!<DC><N>"                                   -Replace "Kamaro's Mask<W>!<DC><New Box>"
        SetMessage -ID "0089" -Text "hoped they<New Box>"                                        -Replace "hoped they<N>"
        SetMessage -ID "0097" -Text "Land"                                                       -Replace "Town"
        SetMessage -ID "0098" -Text "Land"                                                       -Replace "Town"
        SetMessage -ID "00AA" -Text "<Reset><Reset>Quick! Deliver it for her! Take it<New Box>"  -Replace "<New Box>Quick! Deliver it for her!<N>Take it "
        SetMessage -ID "0326"                                                                    -Replace "<R>Great Bay Coast<N><W>Beware of Leevers, dangerous<N>fossorial life-forms!"
        SetMessage -ID "0555" -Text "can.<N><New Box II>"                                        -Replace "can.<New Box II>"
        SetMessage -ID "0555" -Text "in the stores...<N><Reset>"                                 -Replace "in the stores...<New Box>"
        SetMessage -ID "0555" -Text "had<New Box>"                                               -Replace "had<N>"
        SetMessage -ID "061C" -Text "Is Brac working t'night?"                                   -Replace "Gon'be an all-nighter..."
        SetMessage -ID "061F" -Text "I wonder if this'll make it?"                               -Replace "Again all night!"
        SetMessage -ID "06A7" -Text "Welcome.<N><Reset><Reset>"                                  -Replace "Welcome.<New Box>"
        SetMessage -ID "06A7" -Text "you<New Box>"                                               -Replace "you<N>"
        SetMessage -ID "0849" -Text "gathering medicinal herbs"                                  -Replace "picking mushrooms"
        SetMessage -ID "0876" -Text "<N><R><Cruise Cruise:Hits><W> hits.<N>"                     -Replace " <R><Cruise Cruise:Hits><W> hits.<New Box>"
        SetMessage -ID "0876" -Text "you'll<New Box>"                                            -Replace "you'll<N>"
        SetMessage -ID "0BD0" -Text "them"                                                       -Replace "it"
        SetMessage -ID "0FA4" -Text "temperature.<N><Reset>"                                     -Replace "temperature.<New Box>"
        SetMessage -ID "0FA4" -Text "hatch<New Box>"                                             -Replace "hatch<N>"
        SetMessage -ID "14F6" -Text "<Reset><Reset>There are still swarms of<New Box>"           -Replace "<New Box>There are still swarms of<N>"
        SetMessage -ID "15E4" -Text "Town Land"                                                  -Replace "Town"
        SetMessage -ID "164B" -Text " for<N>"                                                    -Replace "<N>for "
        SetMessage -ID "1659" -Text "<N><Reset>But I'm sure I'd like any song<New Box>"          -Replace "<New Box>But I'm sure I'd like any song<N>"
        SetMessage -ID "1729" -Text "Land"                                                       -Replace "Town"
        SetMessage -ID "172A" -Text "Land"                                                       -Replace "Town"
        SetMessage -ID "1910" -Text "Dinofols"                                                   -Replace "Dinolfos"
        SetMessage -ID "194B" -Text "Wizrobe"                                                    -Replace "Wizzrobe"
        SetMessage -ID "2924" -Text "for some reason.<N>Well, we haven't even seen the<New Box>" -Replace "for some reason.<New Box>Well, we haven't even seen the<N>"
        SetMessage -ID "2974" -Text "go out yet.<N>"                                             -Replace "go out yet.<New Box>"
        SetMessage -ID "2974" -Text " I<New Box>would bring the wedding mask and<N>"             -Replace "<N>I would bring the wedding mask<N>and"
        SetMessage -ID "2AFE" -Text "<N><Reset>I can't get any milk in from the<New Box>"        -Replace "<New Box>I can't get any milk in from the<N>"
        SetMessage -ID "336C" -Text "you all you"                                                -Replace "all you"
        SetMessage -ID "3549" -Text "<N><Reset>If the doggies smell you, I don't<New Box>"       -Replace "<New Box>If the doggies smell you, I don't<N>"
        
        # Sounds
      # SetMessage -ID "00F4" -Text "<Sound:6850>"    -Replace "<Sound:6850>"
      # SetMessage -ID "00F5" -Text "<Sound:6850>"    -Replace "<Sound:6850>"
        SetMessage -ID "0859" -Text "<Sound:3901>"    -Replace "<Sound:3AC7>"
        SetMessage -ID "0868" -Text "<Sound:3901>"    -Replace "<Sound:3AC7>"
        SetMessage -ID "08E8" -Text "<Sound:2693>"    -Replace "<Sound:2963>"
        SetMessage -ID "0963" -Text "<Sound:6394>"    -Replace "<Sound:6934>"
        SetMessage -ID "0CEA" -Text "...<Sound:3AE8>" -Replace "<Sound:3AD0>..."
        SetMessage -ID "0CEF" -Text "<Sound:3AE8>"    -Replace "<Sound:3AD0>"
        SetMessage -ID "0DBC"                         -Replace "<Sound:3ABB>" -Append
        SetMessage -ID "0E14" -Text "<Sound:3AFD>"    -Replace "<Sound:38FD>"
        SetMessage -ID "0E74"                         -Replace "<Sound:38E9>" -Append
        SetMessage -ID "100D"                         -Replace "<Sound:6975>" -Append
        SetMessage -ID "100E"                         -Replace "<Sound:6974>" -Append
        SetMessage -ID "151D" -Text "<Sound:3A39>"    -Replace "<Sound:3A89>"
        SetMessage -ID "151E" -Text "<Sound:3A35>"    -Replace "<Sound:3A36>"
        for ($i=0; $i -lt 4; $i++) { SetMessage -ID "151F" -Text "<Sound:3A39>" -Replace "<Sound:3A89>" }
        SetMessage -ID "15F6"                         -Replace "<Sound:3AD2>" -Append
        SetMessage -ID "1FF8"                         -Replace "<Sound:6983>" -Append
        SetMessage -ID "208E"                         -Replace "<Sound:6845>" -Append
        SetMessage -ID "236A"                         -Replace "<Sound:6946>" -Append
        SetMessage -ID "2931"                         -Replace "<Sound:6980>" -Append
        SetMessage -ID "34A3" -Text "<Sound:6925>"    -Replace "<Sound:6952>"
    }

    if (IsChecked $Redux.Text.AdultPronouns -Lang 1) {
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

    if (IsChecked $Redux.Text.AreaTitleCards -Lang 1) {
        ChangeBytes -Offset "C5A250" -Values "02E9500002EA4CD0000B0001";         ChangeBytes -Offset "C5BA30" -Values "07104102"                                                                  # Lone Peak Shrine
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

        if (IsChecked -Elem $Redux.Fixes.Cutscenes -Not) { ChangeBytes -Offset "C5A850" -Values "02D5A00002D64FD000AF0000"; ChangeBytes -Offset "C5B7CC" -Values "67004387"; SetMessage -ID "00AF" -ASCII -Replace "The Moon"; SetMessageIcon -ID "00AF" -Hex "FE" } # The Moon
    }

    if (IsChecked $Redux.Text.EasterEggs) {
        if (TestFile ($GameFiles.Base + "\Easter Eggs.json")) {
            $json = SetJSONFile ($GameFiles.Base + "\Easter Eggs.json")
            foreach ($entry in $json) { SetMessage -ID $entry.box -Replace $entry.message }
        }
   }

    if ( (IsDefault $Redux.Text.TatlScript -Not) -and (IsDefault $Redux.Text.TatlName -Not) -and $Redux.Text.TatlName.Text.Count -gt 0) {
        SetMessage -ID "057A" -Text $LanguagePatch.tatl -Replace ($Redux.Text.TatlName.Text -replace "Тдтп", "Tatl"); SetMessage -ID "057C"; SetMessage -ID "057E"; SetMessage -ID "058E"; SetMessage -ID "0735"; SetMessage -ID "073E"; SetMessage -ID "073F"; SetMessage -ID "1F4E"
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
        SetMessage -ID "1F49" -Text "brother" -Replace "sister";     SetMessage -ID "1F4B" -Text "his" -Replace "her"; SetMessage -ID "200D" -Text "brother" -Replace "sister"; SetMessage -ID "2012" -Text "brother" -Replace "sister"; SetMessage -ID "0216" -Text "He" -Replace "She"
        SetMessage -ID "0216" -Text " he"     -Replace " she" -All;  SetMessage -ID "0229" -Text " he" -Replace " she" -All
    }

    if ( (IsChecked $Redux.Text.LinkScript) -and $Redux.Text.LinkName.Text.Count -gt 0) {
        SetMessage -ID "0462" -Text "16" -Replace $Redux.Text.LinkName.text; SetMessage -ID "046A"; SetMessage -ID "046C"; SetMessage -ID "0591"; SetMessage -ID "0593"; SetMessage -ID "059D"; SetMessage -ID "05A1"; SetMessage -ID "05A5"; SetMessage -ID "05A9"; SetMessage -ID "0710" -All; SetMessage -ID "0734" -All
        SetMessage -ID "0736"; SetMessage -ID "0800"; SetMessage -ID "0802"; SetMessage -ID "08E4"; SetMessage -ID "08E5"; SetMessage -ID "0961"; SetMessage -ID "0966"; SetMessage -ID "0967"; SetMessage -ID "0969"; SetMessage -ID "096D"; SetMessage -ID "096F"; SetMessage -ID "0971";      SetMessage -ID "102A"
        SetMessage -ID "102D"; SetMessage -ID "1030"; SetMessage -ID "1068"; SetMessage -ID "1069"; SetMessage -ID "106D"; SetMessage -ID "14DD"; SetMessage -ID "14F9"; SetMessage -ID "1F74"; SetMessage -ID "27D9"; SetMessage -ID "27DB"; SetMessage -ID "27DC"; SetMessage -ID "27DE";      SetMessage -ID "27DF"
        SetMessage -ID "27E0"; SetMessage -ID "27F0"; SetMessage -ID "27F2"; SetMessage -ID "27F6"; SetMessage -ID "28AA"; SetMessage -ID "28AB"; SetMessage -ID "28B2"; SetMessage -ID "28B3"; SetMessage -ID "28B5"; SetMessage -ID "28B6"; SetMessage -ID "3339"; SetMessage -ID "333A";
    }

    if (IsChecked $Redux.Text.GossipTime) { SetMessage -ID "20D2" -Replace "The time is currently <ClockTime>!<N>" -Insert }

    if (IsChecked $Redux.Capacity.EnableAmmo -Lang 1) {
        SetMessage -ID "0019" -ASCII -Text "10" -Replace $Redux.Capacity.DekuSticks1.text
        SetMessage -ID "178A" -ASCII -Text "30" -Replace $Redux.Capacity.Quiver1.text
        SetMessage -ID "178B" -ASCII -Text "40" -Replace $Redux.Capacity.Quiver2.text;  SetMessage -ID "0023" -ASCII -Text "40" -Replace $Redux.Capacity.Quiver2.text;
        SetMessage -ID "178C" -ASCII -Text "50" -Replace $Redux.Capacity.Quiver3.text;  SetMessage -ID "0024" -ASCII -Text "50" -Replace $Redux.Capacity.Quiver3.text;
        SetMessage -ID "178D" -ASCII -Text "20" -Replace $Redux.Capacity.BombBag1.text
        SetMessage -ID "178E" -ASCII -Text "30" -Replace $Redux.Capacity.BombBag2.text; SetMessage -ID "001C" -ASCII -Text "30" -Replace $Redux.Capacity.BombBag2.text;
        SetMessage -ID "178F" -ASCII -Text "40" -Replace $Redux.Capacity.BombBag3.text; SetMessage -ID "001D" -ASCII -Text "40" -Replace $Redux.Capacity.BombBag3.text;
    }

    if (IsChecked $Redux.Capacity.EnableWallet -Lang 1) {
        SetMessage -ID "0008" -ASCII -Text "200" -Replace $Redux.Capacity.Wallet2.text
        SetMessage -ID "0009" -ASCII -Text "500" -Replace $Redux.Capacity.Wallet3.text
    }

    if ( (IsDefault $Redux.Features.OcarinaIcons -Not) -and $Patches.Redux.Checked -and $LanguagePatch.code -eq "en") {
        if (IsChecked $Redux.UI.GCScheme)   { SetMessage -ID "1726" -Replace "<R>Deku Pipes<N><W>Loud pipes that sprout forth from<N>your Deku Scrub body.<N><New Box II>Play it with <A Button> and the four <C><C Button><W> directions.<N>Press <B Button> to stop." }
        else                                { SetMessage -ID "1726" -Replace "<R>Deku Pipes<N><W>Loud pipes that sprout forth from<N>your Deku Scrub body.<N><New Box II>Play it with <A Button> and the four <C><C Button><W><N>Buttons. Press <B Button> to stop."    }
        SetMessageIcon -ID "1726" -Hex "70"
        
        if (IsChecked $Redux.UI.GCScheme)   { SetMessage -ID "171C" -Replace "<R>Goron Drums<N><W>The traditional instrument of the<N>Goron tribe.<N><New Box II>Play it with <A Button> and the four <C><C Button><W> directions.<N>Press <B Button> to stop." }
        else                                { SetMessage -ID "171C" -Replace "<R>Goron Drums<N><W>The traditional instrument of the<N>Goron tribe.<N><New Box II>Play it with <A Button> and the four <C><C Button><W><N>Buttons. Press <B Button> to stop."    }
        SetMessageIcon -ID "171C" -Hex "64"
        
        if (IsChecked $Redux.UI.GCScheme)   { SetMessage -ID "1727" -Replace "<R>Zora Guitar<N><W>A soulful guitar from a Zora band.<N>It's overflowing with good vibes.<N><New Box II>Play it with <A Button> and the four <C><C Button><W> directions.<N>Press <B Button> to stop." }
        else                                { SetMessage -ID "1727" -Replace "<R>Zora Guitar<N><W>A soulful guitar from a Zora band.<N>It's overflowing with good vibes.<N><New Box II>Play it with <A Button> and the four <C><C Button><W><N>Buttons. Press <B Button> to stop."    }
        SetMessageIcon -ID "1727" -Hex "44"
    }

    if (IsChecked $Redux.Text.Instant) {
        WriteToConsole "Starting Generating Instant Text"
        if ($Files.json.textEditor -eq $null) { LoadTextEditor }
        :outer foreach ($h in $DialogueList.GetEnumerator()) {
            if     ($DialogueList[$h.name].msg.count -eq 0) { continue }
            elseif ( (GetDecimal $h.name) -ge 256 -and (GetDecimal $h.name) -le 329) { continue } # Area Title Cards

            SetMessage -ID $h.name -Text @(23) -Silent -All # Remove all <DI>
            SetMessage -ID $h.name -Text @(24) -Silent -All # Remove all <DC>

            if ($DialogueList[$h.name].msg[$Files.json.textEditor.header] -ne 0x1E) { SetMessage -ID $h.name -Replace @(23) -Silent -Insert } # Insert <DI> to start

            SetMessage -ID $h.name -Text @(16) -Replace @(16, 23) -Silent -All # Add <DI> after <New Box>
            SetMessage -ID $h.name -Text @(18) -Replace @(18, 23) -Silent -All # Add <DI> after <New Box II>
        }
        WriteToConsole "Finished Generating Instant Text"
    }

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    if ($Settings.Core.LiteOptions)   { CreateOptionsPanel -Tabs @("Main", "Graphics", "Audio", "Difficulty",           "Equipment",            "Redux", "Language") }
    else                              { CreateOptionsPanel -Tabs @("Main", "Graphics", "Audio", "Difficulty", "Colors", "Equipment", "Speedup", "Redux", "Language") }

    ChangeModelsSelection

}



#==============================================================================================================================================================================================
function CreateOptionsPreviews() {
    
    if ($GamePatch.models -ne 0) {
        CreatePreviewGroup -Text "Model Previews" -Height 8
        CreateImageBox -X 20 -Y 20 -W 154 -H 220 -Name "Child"
        $global:PreviewToolTip = CreateToolTip
    }



    # STYLE PREVIEWS

    if (!$Settings.Core.Lite) {
        CreatePreviewGroup -Text "Style Previews" -Height 14
        CreateImageBox -X 20  -Y 20  -W 163 -H 138 -Name "RegularChests"; $Redux.Styles.RegularChests.Add_SelectedIndexChanged( { ShowStylePreview } )
        CreateImageBox -X 200 -Y 20  -W 163 -H 138 -Name "LeatherChests"; $Redux.Styles.LeatherChests.Add_SelectedIndexChanged( { ShowStylePreview } )
        CreateImageBox -X 20  -Y 170 -W 163 -H 138 -Name "BossChests";    $Redux.Styles.BossChests.Add_SelectedIndexChanged(    { ShowStylePreview } )
        CreateImageBox -X 20  -Y 320 -W 110 -H 110 -Name "SmallCrates";   $Redux.Styles.SmallCrates.Add_SelectedIndexChanged(   { ShowStylePreview } )
        CreateImageBox -X 200 -Y 320 -W 110 -H 110 -Name "Pots";          $Redux.Styles.Pots.Add_SelectedIndexChanged(          { ShowStylePreview } )
        ShowStylePreview
    }



    # HUD PREVIEWS #

    CreatePreviewGroup -Text "HUD Previews" -Height 4
    CreateImageBox -X 20  -Y 20 -W 90  -H 90 -Name "ButtonStyle"; $Redux.UI.ButtonStyle.Add_SelectedIndexChanged( { ShowHUDPreview } )
    CreateImageBox -X 120 -Y 20 -W 200 -H 40 -Name "Magic";       $Redux.UI.Magic.Add_SelectedIndexChanged(       { ShowHUDPreview } )
    CreateImageBox -X 160 -Y 70 -W 40  -H 40 -Name "Hearts";      $Redux.UI.Hearts.Add_SelectedIndexChanged(      { ShowHUDPreview } )
    CreateImageBox -X 210 -Y 70 -W 40  -H 40 -Name "Rupees";      $Redux.UI.Rupees.Add_SelectedIndexChanged(      { ShowHUDPreview } )
    CreateImageBox -X 260 -Y 70 -W 40  -H 40 -Name "DungeonKeys"; $Redux.UI.DungeonKeys.Add_CheckStateChanged(    { ShowHUDPreview } )
    ShowHUDPreview

}



#==============================================================================================================================================================================================
function CreatePresets() {
    
    if ($GamePatch.presets -eq 0) { return }



    # PRESETS #

    CreateReduxGroup -Tag  "Presets" -Text "Presets"
    
    $Reset        = CreateReduxButton  -Width 150 -Text "Reset Options"

    $VanillaModel  = CreateReduxButton -Width 150 -Text "Original Link" -Column 3
    $ImprovedModel = CreateReduxButton -Width 150 -Text "Improved Link"

    $QualityOfLife = CreateReduxButton -Width 150 -Text "Quality of Life"
    $OptimalRedux  = CreateReduxButton -Width 150 -Text "Optimal Redux"
    $Restore       = CreateReduxButton -Width 150 -Text "Uncensor && Correct"
    $HeroMode      = CreateReduxButton -Width 150 -Text "Hero Mode"

    $Reset.Add_Click( { ResetGame } )

    $QualityOfLife.Add_Click( {
        BoxCheck $Redux.Fixes.MushroomBottle
        BoxCheck $Redux.Fixes.Geometry
        BoxCheck $Redux.Fixes.FairyFountain
        BoxCheck $Redux.Fixes.OutOfBounds
        BoxCheck $Redux.Fixes.Cutscenes
        BoxCheck $Redux.Graphics.ExtendedDraw
        
        foreach ($option in $Redux.NativeOptions) {
            if ($option.Label -eq "16:9 Widescreen (Advanced)") {
                if ($Redux.NativeOptions[0].hidden) { BoxCheck $Redux.Graphics.WidescreenAlt } else { BoxCheck $Redux.Graphics.Widescreen }
                break
            }
        }

        if ($Redux.Text.Restore        -ne $null)   { if ($Redux.Text.Restore.Enabled)          { BoxCheck $Redux.Text.Restore        } }
        if ($Redux.Text.AreaTitleCards -ne $null)   { if ($Redux.Text.AreaTitleCards.Enabled)   { BoxCheck $Redux.Text.AreaTitleCards } }
        if ($Redux.Text.EasterEggs     -ne $null)   { if ($Redux.Text.EasterEggs.Enabled)       { BoxCheck $Redux.Text.EasterEggs     } }
    } )

    $OptimalRedux.Add_Click( {
        if ($Redux.Features.CritWiggle        -ne $null)   { $Redux.Features.CritWiggle.SelectedIndex        = 2 }
        if ($Redux.Features.OcarinaIcons      -ne $null)   { $Redux.Features.OcarinaIcons.SelectedIndex      = 1 }
        if ($Redux.Features.UnderwaterOcarina -ne $null)   { $Redux.Features.UnderwaterOcarina.SelectedIndex = 1 }
        if ($Redux.Features.HealthBar         -ne $null)   { $Redux.Features.HealthBar.SelectedIndex         = 1 }
        if ($Redux.Features.ClockControl      -ne $null)   { $Redux.Features.ClockControl.SelectedIndex      = 1 }

        BoxCheck $Redux.Dpad.LayoutLeft
        BoxCheck $Redux.Dpad.DualSet
        
        BoxCheck $Redux.Features.FasterBlockPushing
        BoxCheck $Redux.Features.ElegySpeedup
        BoxCheck $Redux.Features.ArrowToggle
        BoxCheck $Redux.Features.FlowOfTime
        BoxCheck $Redux.Features.InstantElegy
        BoxCheck $Redux.Features.HUDToggle
        BoxCheck $Redux.Features.ItemsUnequip
        BoxCheck $Redux.Features.ItemsOnB
        BoxCheck $Redux.Features.GearSwap
        BoxCheck $Redux.Features.SkipGuard
    } )

    $Restore.Add_Click( {
        BoxCheck $Redux.Restore.RupeeColors
        BoxCheck $Redux.Restore.CowNoseRing
        BoxCheck $Redux.Restore.RomaniSign
        BoxCheck $Redux.Restore.Title
        BoxCheck $Redux.Restore.SkullKid
        BoxCheck $Redux.Restore.ShopMusic
        BoxCheck $Redux.Restore.PieceOfHeartSound
        BoxCheck $Redux.Restore.MoveBomberKid
        BoxCheck $Redux.Fixes.TextCommands
    } )

    $HeroMode.Add_Click( {
        $Redux.Hero.MonsterHP.SelectedIndex  = 4
        $Redux.Hero.MiniBossHp.SelectedIndex = 4
        $Redux.Hero.BossHP.SelectedIndex     = 4
        $Redux.Hero.Damage.SelectedIndex     = 1
        $Redux.Hero.ItemDrops.Text           = "No Hearts"
        
        BoxCheck $Redux.Hero.PalaceRoute
        BoxCheck $Redux.Hero.RaisedResearchLabPlatform
        BoxCheck $Redux.Hero.HarderChildBosses
        BoxCheck $Redux.Hero.DeathIsMoonCrash
        BoxCheck $Redux.Hero.CloseBombShop
        BoxCheck $Redux.Hero.MoveGoldDust
        BoxCheck $Redux.Hero.NoBottledFairy

        BoxCheck $Redux.Hero.Keese
        BoxCheck $Redux.Hero.Dinolfos
        BoxCheck $Redux.Hero.Wolfos
        BoxCheck $Redux.Hero.IronKnuckle
    } )

    $VanillaModel.Enabled  = (TestFile ($GameFiles.models + "\Child\Original.png"))
    $ImprovedModel.Enabled = (TestFile ($GameFiles.models + "\Child\Improved Link.ppf"))

    $VanillaModel.Add_Click(  { $Redux.Graphics.ChildModels.SelectedIndex = 0;     } )
    $ImprovedModel.Add_Click( { $Redux.Graphics.ChildModels.Text = "Improved Link" } )

}



#==============================================================================================================================================================================================
function CreateTabMain() {
    
    CreatePresets



    # QUALITY OF LIFE #

    CreateReduxGroup    -Tag  "Gameplay"               -Text "Quality of Life"
    CreateReduxCheckBox -Name "AdditionalSaveStatues"  -Text "Additional Save Statues"   -Info "Add an Owl Statue for saving only in Pirate's Fortress (Exterior) and Ikana Graveyard and in each of the four temples"            -Base 2 -Credits "Admentus"
    CreateReduxCheckBox -Name "PermanentOwlSaves"      -Text "Permanent Owl Saves"       -Info "Owl saves are no longer deleted"                                                                                                          -Credits "Admentus"
    CreateReduxCheckBox -Name "ZoraPhysics"            -Text "Zora Physics"              -Info "Change the Zora physics when using the boomerang`nZora Link will take a step forward instead of staying on his spot"                      -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "FormItems"              -Text "Use Items With Mask Forms" -Info "Deku Link, Goron Link and Zora Link are able to use a few items such as Bombs and Deku Sticks"                                            -Credits "bry_dawg02"
    CreateReduxCheckBox -Name "NoKillFlash"            -Text "No Kill Flash"             -Info "Disable the flash effect when killing certain enemies such as the Guay or Skullwalltula"                                                  -Credits "Euler"
    CreateReduxCheckBox -Name "FierceDeityAnywhere"    -Text "Fierce Deity Anywhere"     -Info "The Fierce Deity Mask can be used anywhere now´nApplies additional fixes to make the form more usable, such as being able to push blocks" -Credits "Randomizer"
    CreateReduxCheckBox -Name "DisableScreenShrinking" -Text "Disable Screen Shrinking"  -Info "Disables the effect of the screen shrinking just before the next day"                                                                     -Credits "Euler"
    CreateReduxCheckBox -Name "KeepDekuBubble"         -Text "Don't Burst Deku Bubble"   -Info "Holding B button will not burst the Deku Link Bubble"                                                                                     -Credits "Euler"
    CreateReduxCheckBox -Name "RoyalWallet"            -Text "Royal Wallet"              -Info "A third wallet upgrade can be bought"                                                                                              -Scene -Credits "Admentus"



    # GAMEPLAY #

    CreateReduxGroup    -Tag  "Gameplay"          -Text "Gameplay"
    CreateReduxComboBox -Name "CremiaReward"      -Text "Cremia's Reward"          -Info "Change the reward Cremia gives for protecting the carriage" -Items @("Default", "Always Hug", "Always Gold Rupee")                                                -Credits "Euler"
    CreateReduxComboBox -Name "LinkJumpAttack"    -Text "Link Jump Attack"         -Info "Set the Jump Attack animation for Link in his Hylian Form"  -Items @("Jumpslash", "Frontflip", "Beta Frontflip", "Beta Backflip", "Spin Slash", "Zora Jumpslash") -Credits "Admentus (ported), SoulofDeity & Aegiker"
    CreateReduxComboBox -Name "ZoraJumpAttack"    -Text "Zora Jump Attack"         -Info "Set the Jump Attack animation for Link in his Zora Form"    -Items @("Zora Jumpslash", "Beta Frontflip", "Beta Backflip", "Spin Slash")                           -Credits "Admentus (ported) & Aegiker"
    CreateReduxCheckBox -Name "DistantZTargeting" -Text "Distant Z-Targeting"      -Info "Allow to use Z-Targeting on enemies, objects and NPC's from any distance"                                                                                         -Credits "Admentus"
    CreateReduxCheckBox -Name "ManualJump"        -Text "Manual Jump"              -Info "Press Z + A to do a Manual Jump instead of a Jump Attack`nPress B mid-air after jumping to do a Jump Attack"                                                      -Credits "Admentus"
    CreateReduxCheckBox -Name "FDSpinAttack"      -Text "Fierce Deity Spin Attack" -Info "Allows Fierce Deity Link to perform a magic spin attack"                                                                                                          -Credits "Admentus"
    CreateReduxCheckBox -Name "FrontflipJump"     -Text "Force Frontflip Jump"     -Info "Link will always use the frontflip animation when jumping"                                                                                                        -Credits "SoulofDeity"
    CreateReduxCheckBox -Name "NoShieldRecoil"    -Text "No Shield Recoil"         -Info "Disable the recoil when being hit while shielding"                                                                                                                -Credits "Admentus"
    CreateReduxCheckBox -Name "LeftoverSongs"     -Text "Leftover Songs"           -Info "Unlocks the Sun's Song & Saria's Song when creating a new save file, which skips time to the next day or night or plays the Final Hours music theme"              -Credits "Randomizer"
    CreateReduxCheckBox -Name "AcceptBombersCode" -Text "Accept Bomber's Code"     -Info "The Bomber's secret code is always accepted, even if it's wrong"                                                                                                  -Credits "Euler"
    


    # GAMEPLAY (UNSTABLE) #

    CreateReduxGroup    -Tag  "Gameplay"         -Text "Gameplay (Unstable)" 
    CreateReduxCheckBox -Name "HookshotAnything" -Text "Hookshot Anything" -Info "Be able to hookshot most surfaces" -Warning "Prone to softlocks, be careful" -Credits "Randomizer"



    # RESTORE #

    CreateReduxGroup    -Tag  "Restore"           -Text "Restore / Correct"
    CreateReduxCheckBox -Name "RupeeColors"       -Text "Correct Rupee Colors"     -Info "Corrects the color palette for the in-game Purple (50) and Golden (200) Rupees`nIn the base game they are closer to pink and orange, this changes them to more closely match their 3D get item models" -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "CowNoseRing"       -Text "Restore Cow Nose Ring"    -Info "Restore the rings in the noses for Cows as seen in the Japanese release"                                                                                                                               -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "RomaniSign"        -Text "Correct Romani Sign"      -Info "Replace the Romani Sign texture to display Romani's Ranch instead of Kakariko Village"                                                                                                                 -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "Title"             -Text "Restore Title"            -Info "Restore the title logo colors as seen in the Japanese release"                                                                                                                                         -Credits "ShadowOne333 & Garo-Mastah"
    CreateReduxCheckBox -Name "SkullKid"          -Text "Restore Skull Kid"        -Info "Restore Skull Kid's face as seen in the Japanese release"                                                                                                                                              -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "ShopMusic"         -Text "Restore Shop Music"       -Info "Restores the Shop music intro theme as heard in the Japanese release"                                                                                                                                  -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "PieceOfHeartSound" -Text "4th Piece of Heart Sound" -Info "Restore the sound effect when collecting the fourth Piece of Heart that grants Link a new Heart Container"                                                                                             -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "MoveBomberKid"     -Text "Move Bomber Kid"          -Info "Moves the Bomber at the top of the Stock Pot Inn to be behind the bell like in the original Japanese ROM"                                                                                      -Base 1 -Credits "ShadowOne333"
    

    
    # FIXES #

    $fixes = "`n- Several gaps in Clock Town`n- Misplaced Potion Shop Door after defeating Odolwa`n- Research Lab platform in Great Bay`n- Ancient Castle of Ikana wall texture"
    CreateReduxGroup    -Tag  "Fixes"          -Text "Fixes"
    CreateReduxCheckBox -Name "TextCommands"   -Text "Fix Text Commands"          -Info "Fixes instant text, delay, and sound effect text commands not working sometimes"                                                                                                      -Credits "Qlonever"
    CreateReduxCheckBox -Name "PictoboxDelay"  -Text "Pictograph Box Delay Fix"   -Info "Photos are taken instantly with the Pictograph Box by removing the Anti-Aliasing"                                                                                            -Checked -Credits "Randomizer"
    CreateReduxCheckBox -Name "MushroomBottle" -Text "Fix Mushroom Bottle"        -Info "Fix the item reference when collecting Magical Mushrooms as Link puts away the bottle automatically due to an error"                                                                  -Credits "ozidual"
    CreateReduxCheckBox -Name "Geometry"       -Text "Fix Geometry"               -Info ("Fix misaligned gaps and seams in several places:" + $fixes)                                                                                                                   -Scene -Credits "Linkz & ShadowOne333"
    CreateReduxCheckBox -Name "FairyFountain"  -Text "Fix Fairy Fountain" -Base 1 -Info "Fix the Ikana Canyon Fairy Fountain area not displaying the correct color"                                                                                                     -Scene -Credits "Dybbles (fix) & ShadowOne333 (patch)"
    CreateReduxCheckBox -Name "OutOfBounds"    -Text "Fix Out-of-Bounds"  -Base 1 -Info "Fix a Grotto in the Road to Goron Village (Winter) and a Rupee in the Deku Palace Left Courtyard from being out-of-bounds"                                                     -Scene -Credits "Admentus"
    CreateReduxCheckBox -Name "Cutscenes"      -Text "Fix Cutscenes"      -Base 1 -Info "Fix several cutscenes:`n- Goht running Link over`n- Bomb Lady`n- Unused Chamber of Giants`n- Spring arrives in Mountain Village`n- Ikana Canyon`n- On The Moon entrance intro" -Scene -Credits "Admentus, ShadowOne333 & Chez Cousteau"



    # OTHER #

    CreateReduxGroup    -Tag  "Other"             -Text "Other"
    $text = "Translates the Item Selelect and Map Select menus`nEnable the Map Select menu like in the Debug ROM`nThe File Select menu now opens the Map Select menu instead`nA separate debug save file is used"
    CreateReduxComboBox -Name "Select"            -Text "Item/Map Select"          -Info $text                                 -Items @("Disable", "Translate Only", "Enable Map Select Only", "Translate and Enable Map Select") -Credits "Euler & GhostlyDark"
    CreateReduxComboBox -Name "SkipIntro"         -Text "Skip Intro"               -Info "Skip the logo, title screen or both" -Items @("Don't Skip", "Skip Logo", "Skip Title Screen", "Skip Logo and Title Screen")             -Credits "Euler"
    CreateReduxCheckBox -Name "AlwaysBestEnding"  -Text "Always Best Ending"       -Info "The credits sequence always includes the best ending, regardless of actual ingame progression"                                          -Credits "Marcelo20XX"
    CreateReduxCheckBox -Name "BlueOctorok"       -Text "Blue Octorok Color"       -Info "Change the color of the Blue Octorok for the Shooting Gallery Minigame into something more distinctive from the Red Octoroks"           -Credits "Admentus"
    CreateReduxCheckBox -Name "DefaultZTargeting" -Text "Default Hold Z-Targeting" -Info "Change the Default Z-Targeting option to Hold instead of Switch"                                                                        -Credits "Euler"
    


    # CUSTOM SCENES #

    CreateReduxGroup    -Tag  "Gameplay"     -Text "Custom Scenes" -Base 1 -Scene
    CreateReduxCheckBox -Name "CustomScenes" -Text "Custom Scenes" -Info "Patch in custom scenes generated by the Actor Editor`nOnly works if the Actor Editor generated a patch" -Credits "Admentus" 

}



#==============================================================================================================================================================================================
function CreateTabRedux() {
    
    # D-PAD #

    CreateReduxGroup       -Tag  "Dpad"                                -Text "D-Pad Layout"
    CreateReduxRadioButton -Name "Disable"     -Max 4 -SaveTo "Layout" -Text "Disable"    -Info "Completely disable the D-Pad"                                                                                                 -Credits "Randomizer"
    CreateReduxRadioButton -Name "Hide"        -Max 4 -SaveTo "Layout" -Text "Hidden"     -Info "Hide the D-Pad icons, while they are still active`nYou can rebind the items to the D-Pad in the pause screen"                 -Credits "Randomizer"
    CreateReduxRadioButton -Name "LayoutLeft"  -Max 4 -SaveTo "Layout" -Text "Left Side"  -Info "Show the D-Pad icons on the left side of the HUD`nYou can rebind the items to the D-Pad in the pause screen"         -Checked -Credits "Randomizer"
    CreateReduxRadioButton -Name "LayoutRight" -Max 4 -SaveTo "Layout" -Text "Right Side" -Info "Show the D-Pad icons on the right side of the HUD`nYou can rebind the items to the D-Pad in the pause screen"                 -Credits "Randomizer"
    CreateReduxCheckBox    -Name "DualSet"                             -Text "Dual Set"   -Info "Allow switching between two different D-Pad sets`nHold L and press R to swap between D-Pad layouts" -Link $Redux.Dpad.Disable -Credits "Admentus"



    # GAMEPLAY #

    $warning  = "30 FPS mode will have issues that prevent you from completing the game and certain challenges`nSwitch back to 20 FPS mode to continue these sections before returning to 30 FPS mode`n`n"
    $warning += "--- Known Issues --`n"
    $warning += "Gravity for throwing objects`nExplosion timers are shorter`nLit torches burn out faster`nTriple swing is extremely hard to perform`nEnemies move and attack faster`nMinigame timers run too fast"

    CreateReduxGroup    -Tag  "Features"           -Text "Features"
    CreateReduxComboBox -Name "CritWiggle"         -Text "Crit Wiggle"                -Info "Link no longer randomly changes direction when moving at times when his health is critical"                                                 -Items @("Disabled", "Always On", "Always Off")        -Default 3 -Credits "Randomizer"
    CreateReduxComboBox -Name "OcarinaIcons"       -Text "Ocarina Icons"              -Info "Restore the Ocarina Icons with their text when transformed like in the N64 Beta or 3DS version`nRequires the language to be set to English" -Items @("Disabled", "Enabled", "Enabled with Original Icon")     -Credits "Admentus & ShadowOne333" -Warning "Not compatible with Underwater Ocarina"
    CreateReduxComboBox -Name "GiantMaskAnywhere"  -Text "Giant Mask Anywhere"        -Info "The Giant's Mask can now be used in most open maps"                                                                                         -Items @("Disabled", "Enabled", "Enabled with Fierce Deity Mask") -Credits "Randomizer"
    CreateReduxTextBox  -Name "RupeeDrain"         -Text "Rupee Drain"                -Info "A difficulty option that drains your Rupees over time, and then your health over time`nThe value is the amount of seconds before each drain occurs"            -Shift (-16) -Length 2 -Value 0 -Min 0 -Max 10 -Credits "Admentus"
    
    $items = @("Disabled", "Enabled", "Enabled with Odolwa's Remains", "Enabled with Goht's Remains", "Enabled with Gyorg's Remains", "Enabled with Twinmold's Remains")
    CreateReduxComboBox -Name "UnderwaterOcarina"  -Text "Underwater Ocarina"         -Info "Zora Link can play the Ocarina when standing on the bottom of water" -Warning "Not compatible with Ocarina Icons"                                                        -Checked -Items $items -Credits "Randomizer"
    CreateReduxComboBox -Name "ContinuousDekuHop"  -Text "Continuous Deku Hop"        -Info "Press A while hopping across water to keep hopping"                                                                                                                                             -Items $items -Credits "Randomizer"
    CreateReduxComboBox -Name "HealthBar"          -Text "Health Bar"                 -Info "Shows the total health and remaining health of enemies and bosses as a bar when you Z-Target them"                                                                                              -Items $items -Credits "Randomizer"
    CreateReduxComboBox -Name "BombchuDrops"       -Text "Bombchu Drops"              -Info "Bombchus can now drop from defeated enemies, cutting grass and broken jars"                                                                                                                     -Items $items -Credits "Randomizer"
    CreateReduxComboBox -Name "ClockControl"       -Text "Clock Control"              -Info "Press B in the Pause Screen to bring up the Clock Control display`nUse C-Left and C-Right to set the time to advance to`nPress A to save or B to cancel`nTime is aplied when resuming the game" -Items $items -Credits "Admentus"

    CreateReduxCheckBox -Name "FasterBlockPushing" -Text "Faster Block Pushing"       -Info "All blocks are pushed faster"                                                                                                                                                                    -Checked -Credits "Randomizer"
    CreateReduxCheckBox -Name "ArrowToggle"        -Text "Arrow Toggle"               -Info "Press R while aiming to toggle between arrow types"                                                                                                                                              -Checked -Credits "Randomizer"
    CreateReduxCheckBox -Name "ElegySpeedup"       -Text "Elegy of Emptiness Speedup" -Info "The Elegy of Emptiness statue summoning cutscene is skipped after playing the song"                                                                                                              -Checked -Credits "Randomizer"
  # CreateReduxCheckBox -Name "BombArrows"         -Text "Bomb Arrows"                -Info "Shoot bombs with the bow by using both items at the same time"                                                                                                                                            -Credits "Randomizer"
    CreateReduxCheckBox -Name "InstantTransform"   -Text "Instant Transform"          -Info "Skip the transformation cutscenes when equiping or unequiping a transformation mask"                                                                                                                      -Credits "Randomizer"
    CreateReduxCheckBox -Name "ShortChestOpening"  -Text "Short Chest Opening"        -Info "All chests are opened using the short animation"                                                                                                                                                          -Credits "Randomizer"
    
    CreateReduxCheckBox -Name "FlowOfTime"         -Text "Control Flow of Time"       -Info "Hold L and press D-Pad Down to invert or restore the flow or time without having to use the Ocarina of Time"                                                                                              -Credits "Admentus"
    CreateReduxCheckBox -Name "InstantElegy"       -Text "Instant Elegy Statue"       -Info "Hold L and press D-Pad Up to summon an Elegy of Emptiness Statue without having to use the Ocarina of Time"                                                                                               -Credits "Admentus"
    CreateReduxCheckBox -Name "FPS"                -Text "30 FPS (Experimental)"      -Info "Experimental 30 FPS support`nHold L and press Z to toggle between 20 FPS and 30 FPS mode"                                                                                                                 -Credits "Admentus" -Warning $warning
    CreateReduxCheckBox -Name "HUDToggle"          -Text "HUD Toggle"                 -Info "Hold L and press B during the Pause Screen to toggle between HUD displays"                                                                                                                                -Credits "Admentus"
    CreateReduxCheckBox -Name "ItemsUnequip"       -Text "Unequip Items"              -Info "Unassign items or masks by setting them again with their respective C button"                                                                                                                             -Credits "Admentus"
    CreateReduxCheckBox -Name "ItemsOnB"           -Text "Items on B Button"          -Info "Hold L and press A to equip an item to the B button`nSome items are excluded`nPress C-Up on the Sword icon to equip the sword again"                                                                      -Credits "Admentus"
    CreateReduxCheckBox -Name "GearSwap"           -Text "Swap Gear"                  -Info "Press C-Left or C-Right on a sword or shield icon to change between equipment`nYou must have obtained the upgrades, and must not be stolen or reforged`nThis option also makes the Razor Sword permanent" -Credits "Admentus"
    CreateReduxCheckBox -Name "SkipGuard"          -Text "Skip Clock Town Guard"      -Info "The Clock Town Guard will no longer block entry to Termina Field on subsequent cycles when Hylian Link has spoken to them at least once"                                                                  -Credits "Admentus"
    CreateReduxCheckBox -Name "InverseAim"         -Text "Inverse Aim"                -Info "Inverse y-axis for analog controls when aiming in first-person view"

    CreateReduxGroup    -Tag  "Cheats"             -Text "Cheats"
    CreateReduxCheckBox -Name "InventoryEditor"    -Text "Inventory Editor"           -Info "Press the L + Z buttons when the game is paused to open the Inventory Editor" -Credits "Admentus"
    CreateReduxCheckBox -Name "Health"             -Text "Infinite Health"            -Info "Link's health is always at its maximum"                                       -Credits "Admentus"
    CreateReduxCheckBox -Name "Magic"              -Text "Infinite Magic"             -Info "Link's magic is always at its maximum"                                        -Credits "Admentus"
    CreateReduxCheckBox -Name "Ammo"               -Text "Infinite Ammo"              -Info "Link's ammo for items are always at their maximum"                            -Credits "Admentus"
    CreateReduxCheckBox -Name "Rupees"             -Text "Infinite Rupees"            -Info "Link's wallet is always filled at its maximum"                                -Credits "Admentus"
    CreateReduxCheckBox -Name "ClimbAnything"      -Text "Climb Anything"             -Info "Climb most walls in the game" -Warning "Prone to softlocks, be careful"       -Credits "Randomizer"

    if ( (IsSet $Redux.Gameplay.UnderwaterOcarina) -and (IsSet $Redux.Gameplay.OcarinaIcons) ) {
        if     ($Redux.Gameplay.UnderwaterOcarina.Checked -and $Redux.Features.OcarinaIcons.SelectedIndex -gt 0)   { $Redux.Gameplay.UnderwaterOcarina.Checked = $False; $Redux.Features.OcarinaIcons.SelectedIndex = 0 }
        elseif ($Redux.Gameplay.UnderwaterOcarina.Checked)                                                         { EnableElem -Elem $Redux.Features.OcarinaIcons      -Active $False }
        elseif ($Redux.Features.OcarinaIcons.SelectedIndex -gt 0)                                                  { EnableElem -Elem $Redux.Gameplay.UnderwaterOcarina -Active $False }

        $Redux.Gameplay.UnderwaterOcarina.Add_CheckStateChanged( { EnableElem -Elem $Redux.Features.OcarinaIcons      -Active (!$this.checked)             })
        $Redux.Features.OcarinaIcons.Add_SelectedIndexChanged(   { EnableElem -Elem $Redux.Gameplay.UnderwaterOcarina -Active (!$this.selectedIndex -ne 0) })
    }
    

    # BUTTON COLORS #
    
    CreateButtonColorOptions -Default 2
    CreateHUDColorOptions    -MM
    
}



#==============================================================================================================================================================================================
function CreateTabLanguage() {
    
    # DIALOGUE #
    
    CreateReduxGroup      -Safe -Tag  "Text"           -Text "Dialogue"
    CreateReduxComboBox -Base 1 -Name "Language"       -Text "Language"         -Info "Patch the game with a different language" -Items ($Files.json.languages.title)
    CreateReduxCheckBox -Base 1 -Name "Restore"        -Text "Restore Text"     -Info "Restranslates texts and fixes typos for text and sound effects"            -Credits "Admentus & ShadowOne333" -Checked
    CreateReduxCheckBox -Base 1 -Name "AreaTitleCards" -Text "Area Title Cards" -Info "Add area title cards to missing areas"                                     -Credits "Admentus & ShadowOne333" -Checked
    CreateReduxCheckBox -Base 1 -Name "AdultPronouns"  -Text "Adult Pronouns"   -Info "Refer to Link as an adult instead of a child"                              -Credits "Admentus"
    CreateReduxCheckBox         -Name "Instant"        -Text "Instant Text"     -Info "Most text will be shown instantly"                                         -Credits "Admentus"
    CreateReduxCheckBox         -Name "EasterEggs"     -Text "Easter Eggs"      -Info "Adds custom Patreon Tier 3 messages into the game`nCan you find them all?" -Credits "Admentus & Patreons" -Checked
    CreateReduxCheckBox -Base 1 -Name "Custom"         -Text "Custom"           -Info ('Insert custom dialogue found from "..\Patcher64+ Tool\Files\Games\Majora' + "'" + 's Mask\Custom Text"') -Warning "Make sure your custom script is proper and correct, or your ROM will crash`n[!] No edit will be made if the custom script is missing"
    
    

    # OTHER TEXT OPTIONS #

    $names = "`n`n--- Supported Names With Textures ---`n" + "Navi`nTatl`nTaya`nТдтп`nTael`nNite`nNagi`nInfo"
    CreateReduxGroup    -Tag  "Text"            -Text "Other Text Options"
    CreateReduxComboBox -Name "TatlScript"      -Lite -Text "Tatl Text" -Items @("Disabled", "Enabled as Female", "Enabled as Male") -Info "Allow renaming Tatl and the pronouns used"                                                             -Safe -Credits "Admentus & ShadowOne333"            -Warning "Gender swap is only supported for English"
    CreateReduxTextBox  -Name "TatlName"        -Lite -Text "Tatl Name" -Length 5 -ASCII -Value "Tatl" -Width 50                     -Info "Select the name used for Tatl"                                                                         -Safe -Credits "Admentus & ShadowOne333"            -Warning ('Most names do not have an unique texture label, and use a default "Info" prompt label' + $names)
    CreateReduxComboBox -Name "TaelScript"      -Lite -Text "Tael Text" -Items @("Disabled", "Enabled as Male", "Enabled as Female") -Info "Allow renaming Tael and the pronouns used"                                                             -Safe -Credits "Admentus, ShadowOne333 & kuirivito" -Warning "Gender swap is only supported for English"
    CreateReduxTextBox  -Name "TaelName"        -Lite -Text "Tael Name" -Length 5 -ASCII -Value "Tael" -Width 50                     -Info "Select the name used for Tael"                                                                         -Safe -Credits "Admentus & ShadowOne333"
    CreateReduxCheckBox -Name "LinkScript"      -Lite -Text "Link Text"                                                              -Info "Separate file name from Link's name in-game"                                                           -Safe -Credits "Admentus & Third M"
    CreateReduxTextBox  -Name "LinkName"        -Lite -Text "Link Name" -Length 8 -ASCII -Value "Link" -Width 90                     -Info "Select the name for Link in-game"                                                            -Shift 40 -Safe -Credits "Admentus & Third M"
    CreateReduxCheckBox -Name "GossipTime"            -Text "Add Gossip Stone Clock"                                                 -Info "Makes it so that the gossip stones, in addition to telling time left to moonfall, also act as a clock" -Safe -Credits "kuirivito"
    CreateReduxCheckBox -Name "YeetPrompt"      -Lite -Text "Yeet Action Prompt"                                                     -Info ('Replace the "Throw" Action Prompt with "Yeet"' + "`nYeeeeet")                                               -Credits "kr3z"
    CreateReduxCheckBox -Name "Comma"                 -Text "Better Comma"                                                           -Info "Make the comma not look as awful"                                                                            -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "DefaultFileName" -Lite -Text "Default File Name"                                                      -Info 'Set the default file name to "Link"'                                                                         -Credits "Euler"      

    if ($IsFoolsDay -and $Redux.Text.LinkScript -ne $null -and !$Settings.Core.Lite) {
        $Redux.Text.TatlScript.SelectedIndex = 2
        $Redux.Text.TatlName.Text            = "Keanu"
        $Redux.Text.TaelScript.SelectedIndex = 2
        $Redux.Text.TaelName.Text            = "Chuck"
        $Redux.Text.LinkScript.Checked       = $True
        $Redux.Text.LinkName.Text            = "Jason"
    }

    if ($Redux.Text.Language -ne $null) { $Redux.Text.Language.Add_SelectedIndexChanged({ UnlockLanguageContent }) }

    if (!$Settings.Core.Lite -and !$Settings.Core.Safe) {
        EnableElem -Elem $Redux.Text.TatlName -Active ($Redux.Text.TatlScript.SelectedIndex -ne 0)
        EnableElem -Elem $Redux.Text.TaelName -Active ($Redux.Text.TaelScript.SelectedIndex -ne 0)
        EnableElem -Elem $Redux.Text.LinkName -Active ($Redux.Text.LinkScript.Checked)
        $Redux.Text.TatlScript.Add_SelectedIndexChanged( { EnableElem -Elem $Redux.Text.TatlName -Active ($this.SelectedIndex -ne 0) } )
        $Redux.Text.TaelScript.Add_SelectedIndexChanged( { EnableElem -Elem $Redux.Text.TaelName -Active ($this.SelectedIndex -ne 0) } )
        $Redux.Text.LinkScript.Add_CheckStateChanged(    { EnableElem -Elem $Redux.Text.LinkName -Active ($this.Checked)             } )
    }

    UnlockLanguageContent

}



#==============================================================================================================================================================================================
function UnlockLanguageContent() {
    
    if ($Redux.Text.Language -eq $null) { return }

    # English options
    EnableElem -Elem @($Redux.Text.Restore, $Redux.Text.AdultPronouns, $Redux.Text.AreaTitleCards, $Redux.Text.EasterEggs, $Redux.Text.GossipTime, $Redux.Text.YeetPrompt, $Redux.Features.OcarinaIcons) -Active ($Redux.Text.Language.SelectedIndex -eq 0)

}



#==============================================================================================================================================================================================
function CreateTabGraphics() {
    
    # GRAPHICS #

    CreateReduxGroup -Tag "Graphics" -Text "Graphics"
    if ($GamePatch.models -ne 0) { CreateReduxComboBox -Name "ChildModels" -Text "Hylian Model" -Items (LoadModelsList -Category "Child") -Default "Original" -Info "Replace the Hylian model used for Link" }
    CreateReduxCheckBox -Name "Widescreen"        -Text "16:9 Widescreen (Advanced)"   -Info "Patches true 16:9 widescreen with the HUD pushed to the edges.`n`nKnown Issue: Stretched Notebook screen" -Safe -Native -Credits "Granny Story images by Nerrel, Widescreen Patch by gamemasterplc, enhanced and ported by GhostlyDark" -Base 2 -Exclude "Master Quest"
    CreateReduxCheckBox -Name "WidescreenAlt"     -Text "16:9 Widescreen (Simplified)" -Info "Apply 16:9 Widescreen adjusted backgrounds and textures (as well as 16:9 Widescreen for the Wii VC)"                    -Credits "Aspect Ratio Fix by Admentus and 16:9 backgrounds by GhostlyDark & ShadowOne333" -Link $Redux.Graphics.Widescreen
    CreateReduxCheckBox -Name "ExtendedDraw"      -Text "Extended Draw Distance"       -Info "Increases the game's draw distance for objects`nDoes not work on all objects"                                     -Safe -Credits "Admentus"
    CreateReduxCheckBox -Name "PixelatedStars"    -Text "Disable Pixelated Stars"      -Info "Completely disable stars during the night, which are pixelated dots and do not have any textures for HD replacement"    -Credits "Admentus"
    CreateReduxCheckBox -Name "OverworldSkyboxes" -Text "Overworld Skyboxes"           -Info "Use day and night skyboxes for all overworld areas lacking one`nAlso fixes broken skyboxes in some scenes"       -Scene -Credits "Admentus & GhostlyDark"
    
    if (!$IsWiiVC)   { $info = "`n`n--- WARNING ---`nDisabling cutscene effects fixes temporary issues with both Widescreen and Redux patched where garbage pixels at the edges of the screen or garbled text appears`nWorkaround: Resize the window when that happens" }
    else             { $info = "" }
    CreateReduxCheckBox -Name "MotionBlur"       -Text "Disable Motion Blur"        -Info ("Completely disable the use of motion blur in-game" + $info)                -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "FlashbackOverlay" -Text "Disable Flashback Overlay"  -Info ("Disables the overlay shown during Princess Zelda flashback scene" + $info) -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "PreRenderFilters" -Text "Disable Pre-Render Filters" -Info  "Disables the pre-render filters shown in the Pause Screen"                 -Credits "Admentus"



    # INTERFACE #

    CreateReduxGroup    -Tag  "UI" -Text "Interface"
    CreateReduxComboBox -Name "Rupees"           -Text "Rupees Icon" -Items @("Majora's Mask") -FilePath ($Paths.shared + "\HUD\Rupees") -Ext "bin" -Default "Majora's Mask" -Info "Set the style for the rupees icon"                                                                 -Credits "GhostlyDark (ported) & AndiiSyn"
    CreateReduxComboBox -Name "Hearts"           -Text "Heart Icons" -Items @("Majora's Mask") -FilePath ($Paths.shared + "\HUD\Hearts") -Ext "bin" -Default "Majora's Mask" -Info "Set the style for the heart icons"                                                                 -Credits "GhostlyDark (ported) & AndiiSyn"
    CreateReduxComboBox -Name "Magic"            -Text "Magic Bar"   -Items @("Majora's Mask") -FilePath ($Paths.shared + "\HUD\Magic")  -Ext "bin" -Default "Majora's Mask" -Info "Set the style for the magic meter"                                                                 -Credits "GhostlyDark (ported), Pizza, Nerrel (HD), Zeth Alkar"
    CreateReduxCheckBox -Name "BlackBars"        -Text "No Black Bars"                                                                                                       -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes" -Credits "Admentus"
    CreateReduxCheckBox -Name "GCScheme"         -Text "GC Scheme"                                                                                                           -Info "Replace the textures to match the GameCube's scheme"                                               -Credits "Admentus, GhostlyDark & GoldenMariaNova"
    CreateReduxCheckBox -Name "DungeonKeys"      -Text "OoT Key Icon"                                                                                                        -Info "Replace the key icon with that from Ocarina of Time"                                               -Credits "GhostlyDark (ported)"
    CreateReduxCheckBox -Name "CenterTatlPrompt" -Text "Center Tatl Prompt"                                                                                                  -Info 'Centers the "Tatl" prompt shown in the C-Up button'                                                -Credits "GhostlyDark (ported)"


    # BUTTONS #

    CreateReduxGroup    -Tag  "UI" -Text "Buttons"
    CreateReduxComboBox -Name "ButtonStyle" -Items @("Majora's Mask") -FilePath ($Paths.shared + "\HUD\Buttons") -Ext "bin" -Default "Majora's Mask" -Text "Buttons Style" -Info "Set the style for the HUD buttons"  -Credits "Admentus (ported), GhostlyDark (ported), Pizza (HD) Djipi, Community, Nerrel, Federelli, AndiiSyn"  
    $items = @("Majora's Mask", "Ocarina of Time", "Inverted A & B", "Nintendo", "Modern", "GameCube (Original)", "GameCube (Modern)")
    CreateReduxComboBox -Name "Layout"      -Items $items                                                                                            -Text "HUD Layout"    -Info "Set the layout for the HUD Buttons" -Credits "Admentus" 
    
    CreateReduxTextBox  -Name "AButtonScale"      -Text "A Button Scale" -Value 35 -Min 15 -Max 35 -Info "Set the scale of the A Button"       -Credits "Admentus"
    CreateReduxTextBox  -Name "BButtonScale"      -Text "B Button Scale" -Value 29 -Min 15 -Max 30 -Info "Set the scale of the B Button"       -Credits "Admentus"
    CreateReduxTextBox  -Name "CLeftButtonScale"  -Text "C-Left Scale"   -Value 27 -Min 15 -Max 30 -Info "Set the scale of the C-Left Button"  -Credits "Admentus"
    CreateReduxTextBox  -Name "CDownButtonScale"  -Text "C-Down Scale"   -Value 27 -Min 15 -Max 30 -Info "Set the scale of the C-Down Button"  -Credits "Admentus"
    CreateReduxTextBox  -Name "CRightButtonScale" -Text "C-Right Scale"  -Value 27 -Min 15 -Max 30 -Info "Set the scale of the C-Right Button" -Credits "Admentus"


    
    # HIDE HUD #

    CreateReduxGroup    -Tag  "Hide"           -Text "Hide HUD" -Lite
    CreateReduxCheckBox -Name "AButton"        -Text "Hide A Button"        -Info "Hide the A Button"                                                                              -Credits "Marcelo20XX"
    CreateReduxCheckBox -Name "BButton"        -Text "Hide B Button"        -Info "Hide the B Button"                                                                              -Credits "Marcelo20XX"
    CreateReduxCheckBox -Name "CButtons"       -Text "Hide C Buttons"       -Info "Hide the C Buttons"                                                                             -Credits "Marcelo20XX"
    CreateReduxCheckBox -Name "Hearts"         -Text "Hide Hearts"          -Info "Hide the Hearts display"                                                                        -Credits "Marcelo20XX"
    CreateReduxCheckBox -Name "Magic"          -Text "Hide Magic & Rupees"  -Info "Hide the Magic & Rupees display"                                                                -Credits "Marcelo20XX"
    CreateReduxCheckBox -Name "AreaTitle"      -Text "Hide Area Title Card" -Info "Hide the area title that displays when entering a new area"                                     -Credits "Marcelo20XX"
    CreateReduxCheckBox -Name "Clock"          -Text "Hide Clock"           -Info "Hide the Clock display"                                                                         -Credits "Marcelo20XX"
    CreateReduxCheckBox -Name "CountdownTimer" -Text "Hide Countdown Timer" -Info "Hide the countdown timer that displays during the final hours before the Moon will hit Termina" -Credits "Marcelo20XX"
    CreateReduxCheckBox -Name "Credits"        -Text "Hide Credits"         -Info "Do not show the credits text during the credits sequence"                                       -Credits "Admentus"



    # STYLES #

    CreateReduxGroup    -Tag  "Styles"        -Text "Styles" -Lite
    CreateReduxComboBox -Name "RegularChests" -Text "Regular Chests" -Info "Use a different style for regular treasure chests"                                           -FilePath ($Paths.shared + "\Styles\Chests")             -Ext "front" -Items @("Regular")           -Credits "Nintendo, Syeo, AndiiSyn & Rando"
    CreateReduxComboBox -Name "LeatherChests" -Text "Leather Chests" -Info "Use a different style for leathered treasure chests"                                         -FilePath ($Paths.shared + "\Styles\Chests")             -Ext "front" -Items @("Leather")           -Credits "Nintendo, Syeo, AndiiSyn & Rando"
    CreateReduxComboBox -Name "BossChests"    -Text "Boss Chests"    -Info "Use a different style for Boss Key treasure chests"                                          -FilePath ($Paths.shared + "\Styles\Chests")             -Ext "front" -Items @("Boss MM")           -Credits "Nintendo, Syeo, AndiiSyn & Rando"
    CreateReduxComboBox -Name "SmallCrates"   -Text "Small Crates"   -Info "Use a different style for small liftable crates"                                             -FilePath ($Paths.shared + "\Styles\Small Crates")       -Ext "bin"   -Items @("Regular")           -Credits "Nintendo & Rando"
    CreateReduxComboBox -Name "Pots"          -Text "Pots"           -Info "Use a different style for throwable pots"                                                    -FilePath ($Paths.shared + "\Styles\Pots")               -Ext "bin"   -Items @("Regular")           -Credits "Nintendo, Syeo & Rando"
    CreateReduxComboBox -Name "HairColor"     -Text "Hair Color"     -Info "Use a different hair color style for Link`nOnly for Ocarina of Time or Majora's Mask models" -FilePath ($Paths.shared + "\Styles\Hair\Majora's Mask") -Ext "bin"   -Items @("Default", "Blonde") -Credits "Third M & AndiiSyn"

}



#==============================================================================================================================================================================================
function CreateTabAudio() {
    
    # SOUNDS / VOICES / SFX SOUND EFFECTS #

    CreateReduxGroup    -Tag  "Sounds" -Text "Sounds / Voices / SFX Sound Effects"

    $items =  @("Ocarina", "Deku Pipes", "Goron Drums", "Zora Guitar", "Female Voice", "Bell", "Cathedral Bell", "Piano", "Soft Harp", "Harp", "Accordion", "Bass Guitar", "Flute", "Whistling Flute", "Gong", "Elder Goron Drums", "Choir", "Arguing", "Tatl", "Giants Singing", "Ikana King", "Frog Croak", "Beaver", "Eagle Seagull", "Dodongo")
    CreateReduxComboBox -Name "InstrumentHylian"  -Text "Instrument (Hylian)" -Items $items -Default 1                                                      -Info "Replace the sound used for playing the Ocarina of Time in Hylian Form" -Credits "Randomizer" -Lite
    CreateReduxComboBox -Name "InstrumentDeku"    -Text "Instrument (Deku)"   -Items $items -Default 2                                                      -Info "Replace the sound used for playing the Deku Pipes in Deku Form"        -Credits "Randomizer" -Lite
    CreateReduxComboBox -Name "InstrumentGoron"   -Text "Instrument (Goron)"  -Items $items -Default 3                                                      -Info "Replace the sound used for playing the Goron Drums in Goron Form"      -Credits "Randomizer" -Lite
    CreateReduxComboBox -Name "InstrumentZora"    -Text "Instrument (Zora)"   -Items $items -Default 4                                                      -Info "Replace the sound used for playing the Zora Guitar in Zora Form"       -Credits "Randomizer" -Lite
    CreateReduxComboBox -Name "ChildVoices"       -Text "Child Voice"         -Items @("Original") -FilePath ($GameFiles.binaries + "\Voices Child")        -Info "Replace the voice used for the Child Link Model"                       -Credits "`nMelee Zelda: Mickey Saeed`nOcarina of Time: Phantom Natsu"
    CreateReduxComboBox -Name "FierceDeityVoices" -Text "Fierce Deity Voice"  -Items @("Original") -FilePath ($GameFiles.binaries + "\Voices Fierce Deity") -Info "Replace the voice used for the Fierce Deity Link Model"                -Credits "`nOcarina of Time: Phantom Natsu"
    CreateReduxComboBox -Name "LowHP"             -Text "Low HP SFX"          -Items @("Default", "Disabled", "Soft Beep")                                  -Info "Set the sound effect for the low HP beeping"                           -Credits "Randomizer"



    # MUSIC #

    if ($GamePatch.title -like "*Master Quest*") { MusicOptions -Default "Milk Bar Latte" } else { MusicOptions }

}



#==============================================================================================================================================================================================
function CreateTabDifficulty() {
    
    # HERO MODE #

    $items1 = @("1 Monster HP","0.5x Monster HP", "1x Monster HP", "1.5x Monster HP", "2x Monster HP", "2.5x Monster HP", "3x Monster HP", "3.5x Monster HP", "4x Monster HP", "5x Monster HP")
    $items2 = @("1 Mini-Boss HP", "0.5x Mini-Boss HP", "1x Mini-Boss HP", "1.5x Mini-Boss HP", "2x Mini-Boss HP", "2.5x Mini-Boss HP", "3x Mini-Boss HP", "3.5x Mini-Boss HP", "4x Mini-Boss HP", "5x Mini-Boss HP")
    $items3 = @("1 Boss HP", "0.5x Boss HP", "1x Boss HP", "1.5x Boss HP", "2x Boss HP", "2.5x Boss HP", "3x Boss HP", "3.5x Boss HP", "4x Boss HP", "5x Boss HP")
    if ($GamePatch.title -like "*Master Quest*") { $default = 2 } else { $default = 1 }

    CreateReduxGroup    -Tag  "Hero" -Text "Hero Mode"
    CreateReduxComboBox -Name "MonsterHP"  -Text "Monster HP"   -Items $items1 -Default 3                                                        -Info "Set the amount of health for monsters"                                -Credits "Admentus & Euler"
    CreateReduxComboBox -Name "MiniBossHP" -Text "Mini-Boss HP" -Items $items2 -Default 3                                                        -Info "Set the amount of health for elite monsters and mini-bosses"          -Credits "Admentus & Euler"
    CreateReduxComboBox -Name "BossHP"     -Text "Boss HP"      -Items $items3 -Default 3                                                        -Info "Set the amount of health for bosses"                                  -Credits "Admentus & Euler"
    CreateReduxComboBox -Name "Damage"     -Text "Damage"       -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage", "OHKO Mode")        -Info "Set the amount of damage you receive`nOHKO Mode = You die in one hit" -Credits "Admentus" -Default $default
    CreateReduxComboBox -Name "MagicUsage" -Text "Magic Usage"  -Items @("1x Magic Usage", "2x Magic Usage", "4x Magic Usage", "8x Magic Usage") -Info "Set the amount of times magic is consumed at"                         -Credits "Admentus"
    
    $Redux.Hero.Damage.Add_SelectedIndexChanged({ EnableElem -Elem $Redux.Hero.Recovery -Active ($this.Text -ne "OHKO Mode") })
    EnableElem -Elem $Redux.Hero.Recovery -Active ($Redux.Hero.Damage.Text -ne "OHKO Mode")



    # HERO MODE #

    CreateReduxGroup    -Tag  "Hero" -Text "Hero Mode"
    CreateReduxComboBox -Name "Ammo"                      -Text "Ammo Usage" -Items @("1x Ammo Usage", "2x Ammo Usage", "4x Ammo Usage", "8x Ammo Usage") -Info "Set the amount of times ammo is consumed at"                                                 -Credits "Admentus"
    CreateReduxComboBox -Name "DamageEffect"              -Text "Damage Effect"               -Items @("Default", "Burn", "Freeze", "Shock", "Knockdown") -Info "Add an effect when damaged"                                                                  -Credits "Randomizer"
    CreateReduxComboBox -Name "ClockSpeed"                -Text "Clock Speed"                 -Items @("Default", "1/3", "2/3", "2x", "3x", "6x", "10x")  -Info "Set the speed at which time is progressing"                                                  -Credits "Randomizer"
    CreateReduxComboBox -Name "ItemDrops"                 -Text "Item Drops"                  -Items @("Default", "No Hearts", "Only Rupees", "Nothing")  -Info "Set the items that will drop from grass, pots and more"                                      -Credits "Admentus, Third M & BilonFullHDemon"
    CreateReduxCheckBox -Name "PalaceRoute"               -Text "Restore Palace Route"                                                     -Base 1 -Scene -Info "Restore the route to the Bean Seller within the Deku Palace as seen in the Japanese release" -Credits "ShadowOne"
    CreateReduxCheckBox -Name "PiratesFortressInterior"   -Text "Restore Pirate's Fortress"                                                -Base 1 -Scene -Info "Restore the Pirate's Fortress interior as seen in the Japanese release"                      -Credits "Admentus"
    CreateReduxCheckBox -Name "RaisedResearchLabPlatform" -Text "Raised Research Lab Platform"                                             -Base 1 -Scene -Info "Raise the platform leading up to the Research Laboratory as in the Japanese release"         -Credits "Linkz"
    CreateReduxCheckBox -Name "DeathIsMoonCrash"          -Text "Death is Moon Crash"                                                                     -Info "If you die, the moon will crash`nThere are no continues anymore"                             -Credits "Randomizer"
    CreateReduxCheckBox -Name "CloseBombShop"             -Text "Close Bomb Shop"                                                          -Base 1 -Scene -Info "The bomb shop is now closed and the bomb bag is now found somewhere else"                    -Credits "Admentus (ported) & DeathBasket (ROM hack)"
    CreateReduxCheckBox -Name "MoveGoldDust"              -Text "Move Gold Dust"                                                           -Base 1 -Scene -Info "The Goron Race now just gives an empty bottle and the Gold Dust is now found somewhere else" -Credits "Admentus"
    CreateReduxCheckBox -Name "RedTektites"               -Text "Red Tektites"                                                             -Base 1 -Scene -Info "Replace Blue Tektites with red ones once spring has arrived"                                 -Credits "Admentus"
    CreateReduxCheckBox -Name "NoBottledFairy"            -Text "No Bottled Fairies"                                                                      -Info "Fairies can no longer be put into a bottle"                                                  -Credits "Euler"
    
    CreateReduxGroup    -Tag  "Hero"        -Text "Hero Mode (Harder Enemies)"
    CreateReduxCheckBox -Name "Keese"       -Text "Keese"        -Info "Fire Keese or Ice Keese won't turn into regular Keese after hitting Link"                                                                     -Credits "Admentus"
    CreateReduxCheckBox -Name "Wolfos"      -Text "Wolfos"       -Info "Wolfos do not wait to attack and keep chasing Link"                                                                                           -Credits "Euler"
    CreateReduxCheckBox -Name "Dinolfos"    -Text "Dinolfos"     -Info "Dinolfos do not wait to attack"                                                                                                               -Credits "Euler"
    CreateReduxCheckBox -Name "IronKnuckle" -Text "Iron Knuckle" -Info "Iron Knuckles are harder`nAlways run, even armored`n`nRun faster`nAttack faster`nMove toward Link right away`nCan block attacks when armored" -Credits "Garo-Mastah & Euler"
    


    # RECOVERY #

    CreateReduxGroup   -Tag  "Recovery"    -Text "Recovery" -Height 4
    CreateReduxTextBox -Name "Heart"       -Text "Recovery Heart" -Value 16  -Min 0 -Max 320 -Length 3 -Info "Set the amount of HP that Recovery Hearts will replenish`nRecovery Heart drops are removed if set to 0" -Credits "Euler"
    CreateReduxTextBox -Name "StrayFairy"  -Text "Stray Fairy"    -Value 48  -Min 0 -Max 320 -Length 3 -Info "Set the amount of HP that a Stray Fairy will replenish"                                                 -Credits "Euler"
    CreateReduxTextBox -Name "Fairy"       -Text "Fairy (Bottle)" -Value 160 -Min 0 -Max 320 -Length 3 -Info "Set the amount of HP that a Bottled Fairy will replenish"                                               -Credits "Euler"
    CreateReduxTextBox -Name "FairyRevive" -Text "Fairy (Revive)" -Value 160 -Min 0 -Max 320 -Length 3 -Info "Set the amount of HP that a Bottled Fairy will replenish after Link died"                               -Credits "Euler"; $Last.Row++
    CreateReduxTextBox -Name "Milk"        -Text "Milk"           -Value 128 -Min 0 -Max 320 -Length 3 -Info "Set the amount of HP that Milk will replenish"                                                          -Credits "Euler"
    CreateReduxTextBox -Name "RedPotion"   -Text "Red Potion"     -Value 320 -Min 0 -Max 320 -Length 3 -Info "Set the amount of HP that a Red Potion will replenish"                                                  -Credits "Euler"

    $Redux.Recovery.HeartLabel       = CreateLabel -X $Redux.Recovery.Heart.Left       -Y ($Redux.Recovery.Heart.Bottom       + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.Heart.text/16,       1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.StrayFairyLabel  = CreateLabel -X $Redux.Recovery.StrayFairy.Left  -Y ($Redux.Recovery.StrayFairy.Bottom  + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.StrayFairy.text/16,  1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.FairyLabel       = CreateLabel -X $Redux.Recovery.Fairy.Left       -Y ($Redux.Recovery.Fairy.Bottom       + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.Fairy.text/16,       1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.FairyReviveLabel = CreateLabel -X $Redux.Recovery.FairyRevive.Left -Y ($Redux.Recovery.FairyRevive.Bottom + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.FairyRevive.text/16, 1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.MilkLabel        = CreateLabel -X $Redux.Recovery.Milk.Left        -Y ($Redux.Recovery.Milk.Bottom        + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.Milk.text/16,        1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.RedPotionLabel   = CreateLabel -X $Redux.Recovery.RedPotion.Left   -Y ($Redux.Recovery.RedPotion.Bottom   + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.RedPotion.text/16,   1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.Heart.Add_TextChanged(       { if ($this.text -eq "16") { $Redux.Recovery.HeartLabel.Text       = "(1 Heart)" } else { $Redux.Recovery.HeartLabel.Text       = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )
    $Redux.Recovery.Fairy.Add_TextChanged(       { if ($this.text -eq "16") { $Redux.Recovery.FairyLabel.Text       = "(1 Heart)" } else { $Redux.Recovery.FairyLabel.Text       = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )
    $Redux.Recovery.FairyRevive.Add_TextChanged( { if ($this.text -eq "16") { $Redux.Recovery.FairyReviveLabel.Text = "(1 Heart)" } else { $Redux.Recovery.FairyReviveLabel.Text = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )
    $Redux.Recovery.Milk.Add_TextChanged(        { if ($this.text -eq "16") { $Redux.Recovery.MilkLabel.Text        = "(1 Heart)" } else { $Redux.Recovery.MilkLabel.Text        = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )
    $Redux.Recovery.RedPotion.Add_TextChanged(   { if ($this.text -eq "16") { $Redux.Recovery.RedPotionLabel.Text   = "(1 Heart)" } else { $Redux.Recovery.RedPotionLabel.Text   = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )



    # MAGIC #

    CreateReduxGroup   -Tag  "Magic"      -Text "Magic Costs"
    CreateReduxTextBox -Name "FireArrow"  -Text "Fire Arrow"  -Value 4 -Max 96 -Info "Set the magic cost for using Fire Arrows´n48 is the maximum amount of the standard magic meter´n96 is the maximum amount of the double magic meter"  -Credits "Garo-Mastah"
    CreateReduxTextBox -Name "IceArrow"   -Text "Ice Arrow"   -Value 4 -Max 96 -Info "Set the magic cost for using Ice Arrows´n48 is the maximum amount of the standard magic meter´n96 is the maximum amount of the double magic meter"   -Credits "Garo-Mastah"
    CreateReduxTextBox -Name "LightArrow" -Text "Light Arrow" -Value 8 -Max 96 -Info "Set the magic cost for using Light Arrows´n48 is the maximum amount of the standard magic meter´n96 is the maximum amount of the double magic meter" -Credits "Garo-Mastah"
    CreateReduxTextBox -Name "DekuBubble" -Text "Deku Bubble" -Value 2 -Max 96 -Info "Set the magic cost for using Deku Bubbles´n48 is the maximum amount of the standard magic meter´n96 is the maximum amount of the double magic meter" -Credits "retroben"


    # MINIGAMES #

    CreateReduxGroup    -Tag  "Minigames"             -Text "Minigames"
    CreateReduxTextBox  -Name "TownShootingGallery1"  -Text "Town Shooting Gallery (1)"  -Info "Set the default highscore for the Town Shooting Gallery upon starting a new save slot`nThis score has to be beaten for the Quiver upgrade" -Value 39   -Min 0   -Max 49   -Length 2 -Credits "Admentus" -Shift (-35) -Width 30
    CreateReduxTextBox  -Name "TownShootingGallery2"  -Text "Town Shooting Gallery (2)"  -Info "Set the required Piece of Heart score for the Town Shooting Gallery"                                                                       -Value 50   -Min 5   -Max 50   -Length 2 -Credits "Admentus" -Shift (-35) -Width 30
    CreateReduxTextBox  -Name "SwampShootingGallery1" -Text "Swamp Shooting Gallery (1)" -Info "Set the required Quiver upgrade score for the Swamp Shooting Gallery"                                                                      -Value 2120 -Min 500 -Max 2120 -Length 4 -Credits "Admentus" -Shift (-35) -Width 30
    CreateReduxTextBox  -Name "SwampShootingGallery2" -Text "Swamp Shooting Gallery (2)" -Info "Set the required Piece of Heart score for the Swamp Shooting Gallery"                                                                      -Value 2180 -Min 550 -Max 2180 -Length 4 -Credits "Admentus" -Shift (-35) -Width 30

    if ($Redux.Minigames.TownShootingGallery1 -ne $null) {
        $Redux.Minigames.TownShootingGallery1.Add_LostFocus({
            if ([byte]$Redux.Minigames.TownShootingGallery2.Text -le [byte]$Redux.Minigames.TownShootingGallery1.Text ) {
                $value = [byte]$Redux.Minigames.TownShootingGallery1.Text
                if ($value -gt 50) { $value = 50 }
                $Redux.Minigames.TownShootingGallery2.Text = $value
            }
        })

        $Redux.Minigames.TownShootingGallery2.Add_LostFocus({
            if ([byte]$Redux.Minigames.TownShootingGallery2.Text -le [byte]$Redux.Minigames.TownShootingGallery1.Text ) {
                $value = [byte]$Redux.Minigames.TownShootingGallery1.Text + 1
                if ($value -gt 50) { $value = 50 }
                $Redux.Minigames.TownShootingGallery2.Text = $value
            }
        })
    }

    if ($Redux.Minigames.SwampShootingGallery1 -ne $null) {
        $Redux.Minigames.SwampShootingGallery1.Add_LostFocus({
            if ([int16]$Redux.Minigames.SwampShootingGallery2.Text -le [int16]$Redux.Minigames.SwampShootingGallery1.Text ) {
                $value = [int16]$Redux.Minigames.SwampShootingGallery1.Text
                if ($value -gt 2180) { $value = 2180 }
                $Redux.Minigames.SwampShootingGallery2.Text = $value
            }
        })

        $Redux.Minigames.SwampShootingGallery2.Add_LostFocus({
            if ([int16]$Redux.Minigames.SwampShootingGallery2.Text -le [int16]$Redux.Minigames.SwampShootingGallery1.Text ) {
                $value = [int16]$Redux.Minigames.SwampShootingGallery1.Text + 1
                if ($value -gt 2180) { $value = 2180 }
                $Redux.Minigames.SwampShootingGallery2.Text = $value
            }
        })
    }



    # EASY MODE #
    
    CreateReduxGroup    -Tag  "EasyMode"                  -Text "Easy Mode"
    CreateReduxComboBox -Name "KeepBottles"               -Text "Keep Bottle Contents"     -Info "Keep the contents of your bottles after rewinding time"                                  -Credits "Admentus" -Items @("Disabled", "Potions & Fairies Only", "Everything")
    CreateReduxCheckbox -Name "KeepRupees"                -Text "Keep Rupees"              -Info "Keep all Rupees after rewinding time"                                                    -Credits "Euler"
    if ($Settings.Core.Lite) {
        CreateReduxCheckbox -Name "PauseTime"             -Text "Pause Time"               -Info "Pauses the time when inside in any of the dungeons, mini-dungeons or spider houses"      -Credits "Admentus"
    }
    CreateReduxCheckbox -Name "PauseTimeDungeons"         -Text "Pause Time Dungeons"      -Info "Pauses the time when inside in any of the dungeons"                                -Lite -Credits "Admentus"
    CreateReduxCheckbox -Name "PauseTimeMiniDungeons"     -Text "Pause Time Mini-Dungeons" -Info "Pauses the time when inside in any of the mini-dungeons"                           -Lite -Credits "Admentus"
    CreateReduxCheckbox -Name "PauseTimeSpiderHouses"     -Text "Pause Time Spider Houses" -Info "Pauses the time when inside in any of the spider houses"                           -Lite -Credits "Admentus"
    CreateReduxCheckbox -Name "NoBlueBubbleRespawn"       -Text "No Blue Bubble Respawn"   -Info "Removes the respawn of the Blue Bubble monsters (until you re-enter the room)"           -Credits "Garo-Mastah"
    CreateReduxCheckbox -Name "NoTakkuriSteal"            -Text "No Takkuri Steal"         -Info "The Takkuri in Termina Field will no longer steal items from Link"                       -Credits "Admentus"
    CreateReduxCheckbox -Name "NoShieldSteal"             -Text "No Shield Steal"          -Info "Like-Likes will no longer steal the Hero's Shield from Link"                             -Credits "Admentus"
    CreateReduxCheckbox -Name "KeepAmmo"                  -Text "Keep Ammo"                -Info "Keep consumable items like ammo for items after rewinding time"                          -Credits "Admentus"
    CreateReduxCheckbox -Name "OceansideSpiderHouse"      -Text "Oceanside Spider House"   -Info "The wallet upgrade for clearing the Oceanside Spide House can now be claimed on any day" -Credits "Admentus"

}



#==============================================================================================================================================================================================
function CreateTabColors() {
    
    # TUNIC COLORS #

    CreateReduxGroup    -Tag  "Colors" -Text "Tunic Colors"
    $Colors = @("Kokiri Green", "Goron Red", "Zora Blue", "Black", "White", "Azure Blue", "Vivid Cyan", "Light Red", "Fuchsia", "Purple", "Majora Purple", "Twitch Purple", "Persian Rose", "Dirty Yellow", "Blush Pink", "Hot Pink", "Rose Pink", "Orange", "Gray", "Gold", "Silver", "Beige", "Teal", "Blood Red", "Blood Orange", "Royal Blue", "Sonic Blue", "NES Green", "Dark Green", "Lumen", "Randomized", "Custom")
    CreateReduxComboBox -Name "KokiriTunic" -Text "Kokiri Tunic" -Length 230 -Items $Colors -Info ("Select a color scheme for the Kokiri Tunic`n" + '"Randomized" fully randomizes the colors each time the patcher is opened') -Credits "Randomizer"
    $Redux.Colors.KokiriTunicButton = CreateReduxButton -Text "Kokiri Tunic" -Info "Select the color you want for the Kokiri Tunic"                                                                                             -Credits "Randomizer"
    $Redux.Colors.KokiriTunicButton.Add_Click({ $Redux.Colors.SetKokiriTunic.ShowDialog(); $Redux.Colors.KokiriTunic.Text = "Custom"; $Redux.Colors.KokiriTunicLabel.BackColor = $Redux.Colors.SetKokiriTunic.Color; $GameSettings["Colors"][$Redux.Colors.SetKokiriTunic] = $Redux.Colors.SetKokiriTunic.Color.Name })
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
    CreateReduxComboBox -Name "DekuLink"  -Text "Deku Link"  -Items @("Green") -FilePath ($GameFiles.Textures + "\Color - Deku Link")         -Info "Select a color scheme for Deku Link"  -Credits "Admentus, ShadowOne333 & Garo-Mastah"
    CreateReduxComboBox -Name "GoronLink" -Text "Goron Link" -Items @("Green") -FilePath ($GameFiles.Textures + "\Color - Goron Link")        -Info "Select a color scheme for Goron Link" -Credits "Admentus, ShadowOne333 & Garo-Mastah"
    CreateReduxComboBox -Name "ZoraLink"  -Text "Zora Link"  -Items @("Green") -FilePath ($GameFiles.Textures + "\Color - Zora Link\Palette") -Info "Select a color scheme for Zora Link"  -Credits "Admentus, ShadowOne333 & Garo-Mastah"

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

    CreateSwordTrailColorOptions
    CreateSpinAttackColorOptions
    CreateFairyColorOptions -Name "Tatl"

    # Tael Colors - Buttons, Dialogs & Labels
    $Buttons = @(); $Redux.Colors.SetTael = @()
    $items = @("Tatl", "Tael", "Navi", "Gold", "Green", "Light Blue", "Yellow", "Red", "Magenta", "Black", "Fi", "Ciela", "Epona", "Ezlo", "King of Red Lions", "Linebeck", "Loftwing", "Midna", "Phantom Zelda", "Randomized", "Custom")
    
    CreateReduxComboBox -Name "Tael" -Items $items -Default "Tael" -Text "Tael Colors" -Info ("Select a color scheme for Tael`n" + '"Randomized" fully randomizes the colors each time the patcher is opened') -Credits "By ShadowOne333"
    $Buttons += CreateReduxButton -Tag $Buttons.Count -Text "Cutscene (Inner)" -Info "Select the color you want for the Inner Idle stance for Tael" -Credits "ShadowOne333"; $Redux.Colors.SetTael += CreateColorDialog -Color "3F125D" -Name "SetTaelIdleInner" -IsGame -Button $Buttons[0]
    $Buttons += CreateReduxButton -Tag $Buttons.Count -Text "Cutscene (Outer)" -Info "Select the color you want for the Outer Idle stance for Tael" -Credits "ShadowOne333"; $Redux.Colors.SetTael += CreateColorDialog -Color "FA280A" -Name "SetTaelIdleOuter" -IsGame -Button $Buttons[1]

    $Redux.Colors.TaelLabels = @()
    for ($i=0; $i -lt $Buttons.length; $i++) {
    	$Buttons[$i].Add_Click({ $Redux.Colors.SetTael[[int16]$this.Tag].ShowDialog(); $Redux.Colors.Tael.Text = "Custom"; $Redux.Colors.TaelLabels[[int16]$this.Tag].BackColor = $Redux.Colors.SetTael[[int16]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetTael[[int16]$this.Tag].Tag] = $Redux.Colors.SetTael[[int16]$this.Tag].Color.Name })
    	$Redux.Colors.TaelLabels += CreateReduxColoredLabel -Link $Buttons[$i] -Color $Redux.Colors.SetTael[$i].Color
    }

    $Redux.Colors.Tael.Add_SelectedIndexChanged({ SetFairyColorsPreset -ComboBox $Redux.Colors.Tael -Dialogs $Redux.Colors.SetTael -Labels $Redux.Colors.TaelLabels })
    SetFairyColorsPreset -ComboBox $Redux.Colors.Tael -Dialogs $Redux.Colors.SetTael -Labels $Redux.Colors.TaelLabels

}



#==============================================================================================================================================================================================
function CreateTabEquipment() {
    
    # CAPACITY SELECTION #

    CreateReduxGroup    -Tag  "Capacity" -Text "Capacity Selection"
    CreateReduxCheckBox -Name "EnableAmmo"    -Text "Change Ammo Capacity"   -Info "Enable changing the capacity values for ammo"
    CreateReduxCheckBox -Name "EnableWallet"  -Text "Change Wallet Capacity" -Info "Enable changing the capacity values for the wallets"



    # EQUIPMENT ADJUSTMENTS #

    CreateReduxGroup    -Tag  "Equipment"           -Text "Equipment Adjustments"
    CreateReduxCheckBox -Name "PermanentRazorSword" -Text "Permanent Razor Sword"  -Info "The Razor Sword won't get destroyed after 100 hits`nYou can also keep the Razor Sword when traveling back in time" -Credits "darklord92"
    CreateReduxCheckBox -Name "UnsheathSword"       -Text "Unsheath Sword"         -Info "The sword is unsheathed first before immediately swinging it"                                                      -Credits "Admentus"
    CreateReduxCheckBox -Name "MajoraMirrorShield"  -Text "Majora's Mirror Shield" -Info "Replace the symbol on the Mirror Shield with the Majora logo"                                                      -Credits "Garo-Mastah"
    CreateReduxCheckBox -Name "SwordBeamAttack"     -Text "Sword Beam Attack"      -Info "Replaces the Spin Attack with the Sword Beam Attack`nYou can still perform the Quick Spin Attack"                  -Credits "Admentus (ported) & CloudModding (GameShark)"
    CreateReduxCheckBox -Name "FixEponaSword"       -Text "Fix Epona Sword"        -Info "Change Epona's B button behaviour to prevent you from losing your sword if you don't have the Hero's Bow"          -Credits "Randomizer"
    CreateReduxCheckBox -Name "MorePowderKegs"      -Text "More Powder Kegs"       -Info "Can carry up to five (5) Powder Kegs"                                                                              -Credits "Admentus"
    CreateReduxComboBox -Name "SpinAttack"          -Text "Spin Attack"            -Info "Make the Regular & Great Spin Attacks smaller in range, disable the Quick Great Spin or change both"               -Credits "Admentus" -Items @("Original", "Smaller Range", "No Great Quick Spin", "Both")



    #



    # HITBOX #

    CreateReduxGroup  -Tag  "Equipment" -Text "Sliders"
    CreateReduxSlider -Name "KokiriSword"      -Default 3000 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Kokiri Sword"        -Info "Set the length of the hitbox of the Kokiri Sword"           -Credits "Admentus"
    CreateReduxSlider -Name "RazorSword"       -Default 3000 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Razor Sword"         -Info "Set the length of the hitbox of the Razor Sword"            -Credits "Admentus"
    CreateReduxSlider -Name "GildedSword"      -Default 4000 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Gilded Sword"        -Info "Set the length of the hitbox of the Gilded Sword"           -Credits "Admentus"
    CreateReduxSlider -Name "GreatFairysSword" -Default 5500 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Great Fairy's Sword" -Info "Set the length of the hitbox of the Great Fairy's Sword"    -Credits "Admentus"
    CreateReduxSlider -Name "BlastMask"        -Default 310  -Min 1   -Max 1024 -Freq 64  -Small 32  -Large 64  -Text "Blast Mask"          -Info "Set the cooldown duration of the Blast Mask"                -Credits "Randomizer"
    CreateReduxSlider -Name "ShieldRecoil"     -Default 4552 -Min 0   -Max 8248 -Freq 512 -Small 256 -Large 512 -Text "Shield Recoil"       -Info "Set the pushback distance when getting hit while shielding" -Credits "Admentus"
    CreateReduxSlider -Name "Hookshot"         -Default 26   -Min 0   -Max 50   -Freq 10  -Small 5   -Large 10  -Text "Hookshot Length"     -Info "Set the length of the Hookshot"                             -Credits "Admentus" -Warning "Going above the default length can look weird"



    # WEAPON DAMAGE #

    CreateReduxGroup   -Tag  "Attack"             -Text "Weapon Damage"
    CreateReduxTextBox -Name "KokiriSlash"        -Text "Kokiri Slash"       -Info "Set the damage dealt when doing a Slash Attack with the Kokiri Sword"             -Length 2 -Value 1 -Min 1 -Max 20 -Credits "Admentus"
    CreateReduxTextBox -Name "KokiriJump"         -Text "Kokiri Jump"        -Info "Set the damage dealt when doing a Jump Attack with the Kokiri Sword"              -Length 2 -Value 2 -Min 1 -Max 20 -Credits "Admentus"
    CreateReduxTextBox -Name "KokiriSpin"         -Text "Kokiri Spin"        -Info "Set the damage dealt when doing a Spin Attack with the Kokiri Sword"              -Length 2 -Value 1 -Min 1 -Max 20 -Credits "Admentus"
    CreateReduxTextBox -Name "KokiriGreatSpin"    -Text "Kokiri Red Spin"    -Info "Set the damage dealt when doing a Great Spin Attack with the Kokiri Sword"        -Length 2 -Value 1 -Min 1 -Max 20 -Credits "Admentus"
    CreateReduxTextBox -Name "RazorSlash"         -Text "Razor Slash"        -Info "Set the damage dealt when doing a Slash Attack with the Razor Sword"              -Length 2 -Value 2 -Min 1 -Max 20 -Credits "Admentus"
    CreateReduxTextBox -Name "RazorJump"          -Text "Razor Jump"         -Info "Set the damage dealt when doing a Jump Attack with the Razor Sword"               -Length 2 -Value 4 -Min 1 -Max 20 -Credits "Admentus"
    CreateReduxTextBox -Name "RazorSpin"          -Text "Razor Spin"         -Info "Set the damage dealt when doing a Spin Attack with the Razor Sword"               -Length 2 -Value 2 -Min 1 -Max 20 -Credits "Admentus"
    CreateReduxTextBox -Name "RazorGreatSpin"     -Text "Razor Red Spin"     -Info "Set the damage dealt when doing a Great Spin Attack with the Razor Sword"         -Length 2 -Value 2 -Min 1 -Max 20 -Credits "Admentus"
    CreateReduxTextBox -Name "GildedSlash"        -Text "Gilded Slash"       -Info "Set the damage dealt when doing a Slash Attack with the Gilded Sword"             -Length 2 -Value 3 -Min 1 -Max 20 -Credits "Admentus"
    CreateReduxTextBox -Name "GildedJump"         -Text "Gilded Jump"        -Info "Set the damage dealt when doing a Jump Attack with the Gilded Sword"              -Length 2 -Value 6 -Min 1 -Max 20 -Credits "Admentus"
    CreateReduxTextBox -Name "GildedSpin"         -Text "Gilded Spin"        -Info "Set the damage dealt when doing a Spin Attack with the Gilded Sword"              -Length 2 -Value 3 -Min 1 -Max 20 -Credits "Admentus"
    CreateReduxTextBox -Name "GildedGreatSpin"    -Text "Gilded Red Spin"    -Info "Set the damage dealt when doing a Great Spin Attack with the Gilded Sword"        -Length 2 -Value 3 -Min 1 -Max 20 -Credits "Admentus"
    CreateReduxTextBox -Name "TwoHandedSlash"     -Text "2-Handed Slash"     -Info "Set the damage dealt when doing a Slash Attack with the Great Fairy's Sword"      -Length 2 -Value 4 -Min 1 -Max 20 -Credits "Admentus"
    CreateReduxTextBox -Name "TwoHandedJump"      -Text "2-Handed Jump"      -Info "Set the damage dealt when doing a Jump Attack with the Great Fairy's Sword"       -Length 2 -Value 8 -Min 1 -Max 20 -Credits "Admentus"
    CreateReduxTextBox -Name "TwoHandedSpin"      -Text "2-Handed Spin"      -Info "Set the damage dealt when doing a Spin Attack with the Great Fairy's Sword"       -Length 2 -Value 4 -Min 1 -Max 20 -Credits "Admentus"
    CreateReduxTextBox -Name "TwoHandedGreatSpin" -Text "2-Handed Red Spin"  -Info "Set the damage dealt when doing a Great Spin Attack with the Great Fairy's Sword" -Length 2 -Value 4 -Min 1 -Max 20 -Credits "Admentus"
    CreateReduxTextBox -Name "DoubleHelixSlash"   -Text "Double Helix Slash" -Info "Set the damage dealt when doing a Slash Attack with the Double Helix Sword"       -Length 2 -Value 4 -Min 1 -Max 20 -Credits "Admentus"
    CreateReduxTextBox -Name "DoubleHelixJump"    -Text "Double Helix Jump"  -Info "Set the damage dealt when doing a Jump Attack with the Double Helix Sword"        -Length 2 -Value 8 -Min 1 -Max 20 -Credits "Admentus"
    CreateReduxTextBox -Name "DekuStickSlash"     -Text "Deku Stick Slash"   -Info "Set the damage dealt when doing a Slash Attack with the Deku Stick"               -Length 2 -Value 2 -Min 1 -Max 20 -Credits "Admentus"
    CreateReduxTextBox -Name "DekuStickJump"      -Text "Deku Stick Jump"    -Info "Set the damage dealt when doing a Jump Attack the Deku Stick"                     -Length 2 -Value 4 -Min 1 -Max 20 -Credits "Admentus"
    CreateReduxTextBox -Name "GoronPunch"         -Text "Goron Punch"        -Info "Set the damage dealt when doing a Goron Punch"                                    -Length 2 -Value 2 -Min 1 -Max 20 -Credits "Admentus"
    CreateReduxTextBox -Name "ZoraPunch"          -Text "Zora Punch"         -Info "Set the damage dealt when doing a Zora Punch"                                     -Length 2 -Value 1 -Min 1 -Max 20 -Credits "Admentus"
    CreateReduxTextBox -Name "ZoraJump"           -Text "Zora Jump"          -Info "Set the damage dealt when doing a Zora Jump Attack"                               -Length 2 -Value 2 -Min 1 -Max 20 -Credits "Admentus"
    


    # AMMO #

    $Redux.Box.Ammo = CreateReduxGroup -Tag "Capacity" -Text "Ammo Capacity Selection"
    CreateReduxTextBox -Name "Quiver1"     -Text "Quiver (1)"      -Value 30  -Info "Set the capacity for the Quiver (Base)"        -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver2"     -Text "Quiver (2)"      -Value 40  -Info "Set the capacity for the Quiver (Upgrade 1)"   -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver3"     -Text "Quiver (3)"      -Value 50  -Info "Set the capacity for the Quiver (Upgrade 2)"   -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag1"    -Text "Bomb Bag (1)"    -Value 20  -Info "Set the capacity for the Bomb Bag (Base)"      -Credits "GhostlyDark" 
    CreateReduxTextBox -Name "BombBag2"    -Text "Bomb Bag (2)"    -Value 30  -Info "Set the capacity for the Bomb Bag (Upgrade 1)" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag3"    -Text "Bomb Bag (3)"    -Value 40  -Info "Set the capacity for the Bomb Bag (Upgrade 2)" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuSticks1" -Text "Deku Sticks (1)" -Value 10  -Info "Set the capacity for the Deku Sticks (Base)"   -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuNuts1"   -Text "Deku Nuts (1)"   -Value 20  -Info "Set the capacity for the Deku Nuts (Base)"     -Credits "GhostlyDark"



    # WALLET #

    $Redux.Box.Wallet = CreateReduxGroup -Tag "Capacity" -Text "Wallet Capacity Selection"
    CreateReduxTextBox -Name "Wallet1" -Length 4 -Text "Wallet (1)" -Value 99   -Info "Set the capacity for the Wallet (Base)"      -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet2" -Length 4 -Text "Wallet (2)" -Value 200  -Info "Set the capacity for the Wallet (Upgrade 1)" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet3" -Length 4 -Text "Wallet (3)" -Value 500  -Info "Set the capacity for the Wallet (Upgrade 2)" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet4" -Length 4 -Text "Wallet (4)" -Value 1000 -Info "Set the capacity for the Wallet (Upgrade 3)" -Credits "GhostlyDark" -Warning "This wallet is not obtained through regular gameplay"
    


    EnableForm -Form $Redux.Box.Ammo -Enable $Redux.Capacity.EnableAmmo.Checked
    $Redux.Capacity.EnableAmmo.Add_CheckStateChanged({ EnableForm -Form $Redux.Box.Ammo -Enable $Redux.Capacity.EnableAmmo.Checked })
    EnableForm -Form $Redux.Box.Wallet -Enable $Redux.Capacity.EnableWallet.Checked
    $Redux.Capacity.EnableWallet.Add_CheckStateChanged({ EnableForm -Form $Redux.Box.Wallet -Enable $Redux.Capacity.EnableWallet.Checked })

}



#==============================================================================================================================================================================================
function CreateTabSpeedup() {
    
    # ANIMATION #

    CreateReduxGroup    -Tag  "Animation" -Text "Animation"
    CreateReduxCheckBox -Name "TriSwipe"  -Text "Tri-Swipe" -Info "Change the scene transition animation into the tri-swipe" -Credits "Euler"



    # SKIP #

    CreateReduxGroup    -Tag  "Skip"            -Text "Skip"
    CreateReduxComboBox -Name "OpeningSequence" -Text "Opening Sequence" -Info "The the opening sequence or the first cycle"                                                     -Credits "Admentus" -Items @("Default Start", "Clock Town Start", "Skip First Cycle")
    CreateReduxCheckBox -Name "BossCutscenes"   -Text "Boss Cutscenes"   -Info "Skip the cutscenes that play during bosses and mini-bosses"                                      -Credits "Randomizer"
    CreateReduxCheckBox -Name "TatlInterrupts"  -Text "Tatl Interrupts"  -Info "Skip the cutscenes that are triggered by Tatl"                                                   -Credits "Randomizer"
    CreateReduxCheckBox -Name "OpeningChests"   -Text "Opening Chest"    -Info "Skip the cutscene for opening large chests"                                                      -Credits "Euler"
    CreateReduxCheckBox -Name "BusinessScrubs"  -Text "Business Scrubs"  -Info "Skip the cutscene for all Business Scrubs, and the Clock Town Business Scrub is already present" -Credits "Euler"
    CreateReduxCheckBox -Name "IronKnuckles"    -Text "Iron Knuckles"    -Info "Skip the cutscene when the armor breaks broken or dies"                                          -Credits "Euler"



    # SPEEDUP #

    CreateReduxGroup    -Tag  "Speedup" -Text "Speedup"
    CreateReduxCheckBox -Name "LabFish" -Text "Lab Fish"          -Info "Only one fish has to be feeded in the Marine Research Lab"                            -Credits "Randomizer"
    CreateReduxCheckBox -Name "Dampe"   -Text "Good Dampé RNG"    -Info "Dampé's Digging Game always has two Ghost Flames on the ground and one up the ladder" -Credits "Randomizer"
    CreateReduxCheckBox -Name "DogRace" -Text "Good Dog Race RNG" -Info "The Gold Dog always wins the Doggy Racetrack race if you have the Mask of Truth"      -Credits "Randomizer"



    # WALLET #

    CreateReduxGroup   -Tag  "Speedup"         -Text "Bank Deposit Rewards"
    CreateReduxTextBox -Name "Bank1" -Length 4 -Text "First Reward"  -Value 200  -Info "Set the amount of Rupees required to deposit for the first reward"                                                                               -Credits "Randomizer"
    CreateReduxTextBox -Name "Bank2" -Length 4 -Text "Second Reward" -Value 1000 -Info "Set the amount of Rupees required to deposit for the second reward"                                                                              -Credits "Randomizer"
    CreateReduxTextBox -Name "Bank3" -Length 4 -Text "Final Reward"  -Value 5000 -Info "Set the amount of Rupees required to deposit for the final reward`nThis value also changes the maximum amount that can be deposited to the bank" -Credits "Randomizer"

}