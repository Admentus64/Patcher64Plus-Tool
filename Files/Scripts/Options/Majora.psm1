function PatchOptionsMajorasMask() {
    
    # ENHANCED 16:9 WIDESCREEN #

    if (IsWidescreen)                                   { ApplyPatch -File $GetROM.decomp -Patch "\Decompressed\widescreen.ppf" }
    if ( (IsWidescreen) -or (IsWidescreen -Patched) )   { RemoveFile $Files.dmaTable }
    if (IsWidescreen)                                   { Add-Content $Files.dmaTable "0 1 2 3 4 5 6 7 -8 -9 15 16 17 18 19 20 -21 22 -24 25 26 27 28 29 30 -652 1127 -1540 -1541 -1542 -1543 -1544 -1545 -1546 -1547 -1548 -1549 -1550 -1551 1552 1553 1554 1555 1556 1557 1558 1559 1560 1561 1562 1563 1564 1565 1566 1567" }
    if (IsWidescreen -Patched)                          { Add-Content $Files.dmaTable "0 1 2 3 4 5 6 7 -8 -9 15 16 17 18 19 20 -21 22 -24 25 26 27 28 29 30 -652 1127 -1540 -1541 -1542 -1543 1544 1545 1546 1547 1548 1549 1550 -1551 1552 1553 1554 1555 1556 1557 1558 1559 1560 1561 1562 1563 1564 1565 1566 1567" }



    # MODELS #

    if (IsChecked $Redux.Graphics.ImprovedLinkModel)    { ApplyPatch -File $GetROM.decomp -Patch "\Decompressed\improved_link_model.ppf" }

}



#==============================================================================================================================================================================================
function ByteOptionsMajorasMask() {
    
    # GAMEPLAY #
    
    if (IsChecked -Elem $Redux.Gameplay.PalaceRoute) {
        CreateSubPath  -Path ($GameFiles.extracted + "\Deku Palace")
        ExportAndPatch -Path "Deku Palace\deku_palace_scene"  -Offset "2534000" -Length "D220"
        ExportAndPatch -Path "Deku Palace\deku_palace_room_0" -Offset "2542000" -Length "11A50"
        ExportAndPatch -Path "Deku Palace\deku_palace_room_1" -Offset "2554000" -Length "E950"  -NewLength "E9B0"  -TableOffset "1F6A7" -Values "B0"
        ExportAndPatch -Path "Deku Palace\deku_palace_room_2" -Offset "2563000" -Length "124F0" -NewLength "124B0" -TableOffset "1F6B7" -Values "B0"
    }

    if (IsChecked -Elem $Redux.Gameplay.ZoraPhysics)         { PatchBytes  -Offset "65D000" -Patch "Zora Physics Fix.bin" }
    if (IsChecked -Elem $Redux.Gameplay.DistantZTargeting)   { ChangeBytes -Offset "B4E924" -Values @("00", "00", "00", "00") }



    # RESTORE #

    if (IsChecked -Elem $Redux.Restore.RomaniSign)   { PatchBytes  -Offset "26A58C0" -Texture -Patch "Romani Sign.bin" }
    if (IsChecked -Elem $Redux.Restore.Title)        { ChangeBytes -Offset "DE0C2E"  -Values @("FF", "C8", "36", "10", "98", "00") }

    if (IsChecked -Elem $Redux.Restore.RupeeColors) {
        ChangeBytes -Offset "10ED020" -Values @("70", "6B", "BB", "3F", "FF", "FF", "EF", "3F", "68", "AD", "C3", "FD", "E6", "BF", "CD", "7F", "48", "9B", "91", "AF", "C3", "7D", "BB", "3D", "40", "0F", "58", "19", "88", "ED", "80", "AB") # Purple
        ChangeBytes -Offset "10ED040" -Values @("D4", "C3", "F7", "49", "FF", "FF", "F7", "E1", "DD", "03", "EF", "89", "E7", "E3", "E7", "DD", "A3", "43", "D5", "C3", "DF", "85", "E7", "45", "7A", "43", "82", "83", "B4", "43", "CC", "83") # Gold
    }

    if (IsChecked -Elem $Redux.Restore.CowNoseRing) {
        ChangeBytes -Offset "E10270"  -Values @("00", "00")
        ChangeBytes -Offset "107F5C4" -Values @("00", "00")
    }

    if (IsChecked -Elem $Redux.Restore.SkullKid) {
        $Values = @()
        for ($i=0; $i -lt 256; $i++) {
            $Values += 0
            $Values += 1
        }
        ChangeBytes -Offset "181C820" -Values $Values
        PatchBytes  -Offset "181C620" -Texture -Patch "Skull Kid Beak.bin"
    }

    if (IsChecked -Elem $Redux.Restore.ShopMusic)           { ChangeBytes -Offset "2678007" -Values "44" }
    if (IsChecked -Elem $Redux.Restore.PieceOfHeartSound)   { ChangeBytes -Offset "BA94C8"  -Values @("10", "00") }
    if (IsChecked -Elem $Redux.Restore.MoveBomberKid)       { ChangeBytes -Offset "2DE4396" -Values @("02", "C5", "01", "18", "FB", "55", "00", "07", "2D") }



    # OTHER #

    if (IsChecked -Elem $Redux.Other.SouthernSwamp) {
        CreateSubPath  -Path ($GameFiles.extracted + "\Southern Swamp")
        ExportAndPatch -Path "Southern Swamp\southern_swamp_cleared_scene"  -Offset "1F0D000" -Length "10630"
        ExportAndPatch -Path "Southern Swamp\southern_swamp_cleared_room_0" -Offset "1F1E000" -Length "1B240" -NewLength "1B4F0" -TableOffset "1EC26"  -Values @("94", "F0")
        ExportAndPatch -Path "Southern Swamp\southern_swamp_cleared_room_2" -Offset "1F4D000" -Length "D0A0"  -NewLength "D1C0"  -TableOffset "1EC46"  -Values @("A1", "C0")
    }

    if (IsChecked -Elem $Redux.Other.AlwaysBestEnding) {
        ChangeBytes -Offset "B81CE0" -Values @("00", "00", "00", "00")
        ChangeBytes -Offset "B81D48" -Values @("00", "00", "00", "00")
        ChangeBytes -Offset "B81DB0" -Values @("00", "00", "00", "00")
        ChangeBytes -Offset "B81E18" -Values @("00", "00", "00", "00")
        ChangeBytes -Offset "B81E80" -Values @("00", "00", "00", "00")
        ChangeBytes -Offset "B81EE8" -Values @("00", "00", "00", "00")
        ChangeBytes -Offset "B81F84" -Values @("00", "00", "00", "00")
        ChangeBytes -Offset "B81FEC" -Values @("00", "00", "00", "00")
        ChangeBytes -Offset "B82054" -Values @("00", "00", "00", "00")
    }

    if (IsChecked -Elem $Redux.Other.GohtCutscene)       { ChangeBytes -Offset "F6DE89" -Values @("8D", "00", "02", "10", "00", "00", "0A") }
    if (IsChecked -Elem $Redux.Other.MushroomBottle)     { ChangeBytes -Offset "CD7C48" -Values @("1E", "6B") }
    if (IsChecked -Elem $Redux.Other.FairyFountain)      { ChangeBytes -Offset "B9133E" -Values @("01", "0F") }
    if (IsChecked -Elem $Redux.Other.HideCredits)        { PatchBytes  -Offset "B3B000" -Patch "Message\Credits.bin" }



    # GRAPHICS #

    if (IsChecked -Elem $Redux.Graphics.Widescreen) {
        if ($IsWiiVC) { # 16:9 Widescreen
            ChangeBytes -Offset "BD5D74" -Values @("3C", "07", "3F", "E3")
            ChangeBytes -Offset "CA58F5" -Values @("6C", "53", "6C", "84", "9E", "B7", "53", "6C") -Interval 2

            ChangeBytes -Offset "B9F2DF" -Values "1E" # Dungeon Map - Floors (1A -> 27)
            ChangeBytes -Offset "B9F2EF" -Values "18" # Dungeon Map - Floors (14 -> 21)
            ChangeBytes -Offset "B9F563" -Values "1E" # Dungeon Map - Offscreen Current Floor (1A -> 27)
            ChangeBytes -Offset "B9F573" -Values "18" # Dungeon Map - Offscreen Current Floor (14 -> 21)
            ChangeBytes -Offset "B9F4BB" -Values "7B" # Dungeon Map - Current Floor (6B -> 9F)
            ChangeBytes -Offset "B9F4CB" -Values "5F" # Dungeon Map - Current Floor (4F -> 83)
            

            ChangeBytes -Offset "C98467" -Values "4F" # Dungeon Map - Link Icon (3E -> 72)
            ChangeBytes -Offset "C984FB" -Values "7C" # Dungeon Map - Bos Icon (6C -> A0)

            ChangeBytes -Offset "C979E3" -Values "62" # Dungeon Map - Stray Fairy Current Number (58 -> 8C)
            ChangeBytes -Offset "C9791F" -Values "73" # Dungeon Map - Stray Fairy Slash Shadow (6B -> 9F)
            ChangeBytes -Offset "C97787" -Values "78" # Dungeon Map - Stray Fairy Max Number (74 -> A8)

            ChangeBytes -Offset "C9795B" -Values "1E" # Dungeon Map - Stray Fairy Slash (1C -> 29)
            ChangeBytes -Offset "C97993" -Values "1C" # Dungeon Map - Stray Fairy Slash (1A -> 27)
            ChangeBytes -Offset "C981F3" -Values @("1A", "35", "EF", "82", "90", "3C", "19", "00", "12", "37", "39", "82", "30", "24", "4D", "00", "08", "AE", "0D", "02", "B0") # Dungeon Map - Stray Fairy Icon (22 35 EF 82 90 3C 19 00 1A 37 39 82 30 24 4D 00 08 AE 0D 02 B0)

          # ChangeBytes -Offset "BAF2E0" -Values @("") # A Button
          # ChangeBytes -Offset "C55F14" -Values @("") # B, C-Left, C-Down, C-Right Buttons
        }

        if ($IsWiiVC -or $Settings.Debug.ChangeWidescreen -eq $True) { # 16:9 Textures
            PatchBytes -Offset "A9A000" -Length "12C00" -Texture -Patch "Widescreen\Carnival of Time.bin"
            PatchBytes -Offset "AACC00" -Length "12C00" -Texture -Patch "Widescreen\Four Giants.bin"
            PatchBytes -Offset "C74DD0" -Length "800"   -Texture -Patch "Widescreen\Lens of Truth.bin"
        }
    }

    if (IsChecked -Elem $Redux.Graphics.ExtendedDraw)     { ChangeBytes -Offset "B50874" -Values @("00", "00", "00", "00") }
    if (IsChecked -Elem $Redux.Graphics.BlackBars)        { ChangeBytes -Offset "BF72A4" -Values @("00", "00", "00", "00") }
    if (IsChecked -Elem $Redux.Graphics.PixelatedStars)   { ChangeBytes -Offset "B943FC" -Values @("10", "00") }
    if (IsChecked -Elem $Redux.Graphics.MotionBlur)       { ChangeBytes -Offset "BFB9A0" -Values @("03", "E0", "00", "08", "00", "00", "00", "00", "00") }
    if (IsChecked -Elem $Redux.Other.FlashbackOverlay)    { ChangeBytes -Offset "BFEB8C" -Values @("24", "0F", "00", "00") }



    # INTERFACE #

    if (IsChecked -Elem $Redux.UI.HudTextures)            { PatchBytes  -Offset "1EBDF60" -Texture -Patch "HUD\OoT Button.bin" }
    if (IsChecked -Elem $Redux.UI.Comma)                  { ChangeBytes -Offset "ACC660"  -Values @("00", "F3", "00", "00", "00", "00", "00", "00", "4F", "60", "00", "00", "00", "00", "00", "00", "24") }



    # SOUNDS / SFX SOUND EFFECTS #

    if (IsIndex -Elem $Redux.Sounds.LowHP -Not)                       { ChangeBytes -Offset "B97E2A" -Values (GetSFXID $Redux.Sounds.LowHP.Text) }
    if (IsIndex -Elem $Redux.Sounds.InstrumentHylian -Not -Index 1)   { ChangeBytes -Offset "51CBE"  -Values (GetInstrumentID $Redux.Sounds.InstrumentHylian.Text); ChangeBytes -Offset "C668DC" -Values (GetInstrumentID $Redux.Sounds.InstrumentHylian.Text) }
    if (IsIndex -Elem $Redux.Sounds.InstrumentDeku   -Not -Index 2)   { ChangeBytes -Offset "51CC6"  -Values (GetInstrumentID $Redux.Sounds.InstrumentDeku.Text);   ChangeBytes -Offset "C668DF" -Values (GetInstrumentID $Redux.Sounds.InstrumentDeku.Text)   }
    if (IsIndex -Elem $Redux.Sounds.InstrumentGoron  -Not -Index 3)   { ChangeBytes -Offset "51CC4"  -Values (GetInstrumentID $Redux.Sounds.InstrumentGoron.Text);  ChangeBytes -Offset "C668DD" -Values (GetInstrumentID $Redux.Sounds.InstrumentGoron.Text)  }
    if (IsIndex -Elem $Redux.Sounds.InstrumentZora   -Not -Index 4)   { ChangeBytes -Offset "51CC5"  -Values (GetInstrumentID $Redux.Sounds.InstrumentZora.Text);   ChangeBytes -Offset "C668DE" -Values (GetInstrumentID $Redux.Sounds.InstrumentZora.Text)   }



    # HERO MODE #

    if (IsText -Elem $Redux.Hero.Damage -Compare "OHKO Mode") {
        ChangeBytes -Offset "BABE7F" -Values @("09", "04") -Interval 16
        ChangeBytes -Offset "BABEA2" -Values @("2A", "00")
        ChangeBytes -Offset "BABEA5" -Values @("00", "00", "00")
    }
    elseif ( (IsText -Elem $Redux.Hero.Damage -Compare "1x Damage" -Not) -or (IsText -Elem $Redux.Hero.Recovery -Compare "1x Recovery" -Not) ) {
        ChangeBytes -Offset "BABE7F" -Values @("09", "04") -Interval 16
        if         (IsText -Elem $Redux.Hero.Recovery -Compare "1x Recovery") {
            if     (IsText -Elem $Redux.Hero.Damage -Compare "2x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("28", "40") }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "4x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("28", "80") }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "8x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("28", "C0") }
            ChangeBytes -Offset "BABEA5" -Values @("00", "00", "00")
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Compare "1/2x Recovery") {
            if     (IsText -Elem $Redux.Hero.Damage -Compare "1x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("28", "40") }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "2x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("28", "80") }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "4x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("28", "C0") }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "8x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("29", "00") }
            ChangeBytes -Offset "BABEA5" -Values @("05", "28", "43")
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Compare "1/4x Recovery") {
            if     (IsText -Elem $Redux.Hero.Damage -Compare "1x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("28", "80") }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "2x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("28", "C0") }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "4x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("29", "00") }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "8x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("29", "40") }
            ChangeBytes -Offset "BABEA5" -Values @("05", "28", "83")
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Compare "0x Recovery") {
            if     (IsText -Elem $Redux.Hero.Damage -Compare "1x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("29", "40") }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "2x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("29", "80") }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "4x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("29", "C0") }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "8x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("2A", "00") }
            ChangeBytes -Offset "BABEA5" -Values @("05", "29", "43")
        }
    }

    if     (IsText -Elem $Redux.Hero.MagicUsage -Compare "2x Magic Usage")  { ChangeBytes -Offset "BAC306" -Values @("2C","40") }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "3x Magic Usage")  { ChangeBytes -Offset "BAC306" -Values @("2C","80") }



    # TUNIC COLORS #

    if (IsChecked -Elem $Redux.Colors.EnableTunic) {
        ChangeBytes -Offset "116639C" -IsDec -Values @($Redux.Colors.SetKokiriTunic.Color.R, $Redux.Colors.SetKokiriTunic.Color.G,$Redux.Colors.SetKokiriTunic.Color.B)
        ChangeBytes -Offset "11668C4" -IsDec -Values @($Redux.Colors.SetKokiriTunic.Color.R, $Redux.Colors.SetKokiriTunic.Color.G,$Redux.Colors.SetKokiriTunic.Color.B)
        ChangeBytes -Offset "1166DCC" -IsDec -Values @($Redux.Colors.SetKokiriTunic.Color.R, $Redux.Colors.SetKokiriTunic.Color.G,$Redux.Colors.SetKokiriTunic.Color.B)
        ChangeBytes -Offset "1166FA4" -IsDec -Values @($Redux.Colors.SetKokiriTunic.Color.R, $Redux.Colors.SetKokiriTunic.Color.G,$Redux.Colors.SetKokiriTunic.Color.B)
        ChangeBytes -Offset "1167064" -IsDec -Values @($Redux.Colors.SetKokiriTunic.Color.R, $Redux.Colors.SetKokiriTunic.Color.G,$Redux.Colors.SetKokiriTunic.Color.B)
        ChangeBytes -Offset "116766C" -IsDec -Values @($Redux.Colors.SetKokiriTunic.Color.R, $Redux.Colors.SetKokiriTunic.Color.G,$Redux.Colors.SetKokiriTunic.Color.B)
        ChangeBytes -Offset "1167AE4" -IsDec -Values @($Redux.Colors.SetKokiriTunic.Color.R, $Redux.Colors.SetKokiriTunic.Color.G,$Redux.Colors.SetKokiriTunic.Color.B)
        ChangeBytes -Offset "1167D1C" -IsDec -Values @($Redux.Colors.SetKokiriTunic.Color.R, $Redux.Colors.SetKokiriTunic.Color.G,$Redux.Colors.SetKokiriTunic.Color.B)
        ChangeBytes -Offset "11681EC" -IsDec -Values @($Redux.Colors.SetKokiriTunic.Color.R, $Redux.Colors.SetKokiriTunic.Color.G,$Redux.Colors.SetKokiriTunic.Color.B)
    }

    if (IsChecked -Elem $Redux.Colors.MaskForms) {
        PatchBytes -Offset "117C780" -Length "100" -Texture -Patch "Recolor\Goron Red Tunic.bin"
        PatchBytes -Offset "1186EB8" -Length "100" -Texture -Patch "Recolor\Goron Red Tunic.bin" 

        PatchBytes -Offset "1197120" -Length "50"  -Texture -Patch "Recolor\Zora Blue Palette.bin"
        PatchBytes -Offset "119E698" -Length "50"  -Texture -Patch "Recolor\Zora Blue Palette.bin"
        PatchBytes -Offset "10FB0B0" -Length "400" -Texture -Patch "Recolor\Zora Blue Gradient.bin"
        PatchBytes -Offset "11A2228" -Length "400" -Texture -Patch "Recolor\Zora Blue Gradient.bin"
    }



    # MAGIC SPIN ATTACK COLORS #

    if (IsIndex -Elem $Redux.Colors.BlueSpinAttack -Not) {
        ChangeBytes -Offset "10B08F4" -IsDec -Values @($Redux.Colors.SetSpinAttack[0].Color.R, $Redux.Colors.SetSpinAttack[0].Color.G, $Redux.Colors.SetSpinAttack[0].Color.B)
        ChangeBytes -Offset "10B0A14" -IsDec -Values @($Redux.Colors.SetSpinAttack[1].Color.R, $Redux.Colors.SetSpinAttack[1].Color.G, $Redux.Colors.SetSpinAttack[1].Color.B)
    }

    if (IsIndex -Elem $Redux.Colors.RedSpinAttack -Index 2 -Not) {
        ChangeBytes -Offset "10B0E74" -IsDec -Values @($Redux.Colors.SetSpinAttack[2].Color.R, $Redux.Colors.SetSpinAttack[2].Color.G, $Redux.Colors.SetSpinAttack[2].Color.B)
        ChangeBytes -Offset "10B0F94" -IsDec -Values @($Redux.Colors.SetSpinAttack[3].Color.R, $Redux.Colors.SetSpinAttack[3].Color.G, $Redux.Colors.SetSpinAttack[3].Color.B)
    }



    # FAIRY COLORS #

    if (IsIndex -Elem $Redux.Colors.Fairy -Not) {
        # Idle
        ChangeBytes -Offset "C451D4" -IsDec -Values @($Redux.Colors.SetFairy[0].Color.R, $Redux.Colors.SetFairy[0].Color.G, $Redux.Colors.SetFairy[0].Color.B, 255, $Redux.Colors.SetFairy[1].Color.R, $Redux.Colors.SetFairy[1].Color.G, $Redux.Colors.SetFairy[1].Color.B, 0)

        # Interact
        ChangeBytes -Offset "C451F4" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
        ChangeBytes -Offset "C451FC" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)

        # NPC
        ChangeBytes -Offset "C451E4" -IsDec -Values @($Redux.Colors.SetFairy[4].Color.R, $Redux.Colors.SetFairy[4].Color.G, $Redux.Colors.SetFairy[4].Color.B, 255, $Redux.Colors.SetFairy[5].Color.R, $Redux.Colors.SetFairy[5].Color.G, $Redux.Colors.SetFairy[5].Color.B, 0)

        # Enemy, Boss
        ChangeBytes -Offset "C451EC" -IsDec -Values @($Redux.Colors.SetFairy[6].Color.R, $Redux.Colors.SetFairy[6].Color.G, $Redux.Colors.SetFairy[6].Color.B, 255, $Redux.Colors.SetFairy[7].Color.R, $Redux.Colors.SetFairy[7].Color.G, $Redux.Colors.SetFairy[7].Color.B, 0)
        ChangeBytes -Offset "C4520C" -IsDec -Values @($Redux.Colors.SetFairy[6].Color.R, $Redux.Colors.SetFairy[6].Color.G, $Redux.Colors.SetFairy[6].Color.B, 255, $Redux.Colors.SetFairy[7].Color.R, $Redux.Colors.SetFairy[7].Color.G, $Redux.Colors.SetFairy[7].Color.B, 0)
    }



    # AMMO CAPACITY SELECTION #

    if (IsChecked -Elem $Redux.Capacity.EnableAmmo) {
        ChangeBytes -Offset "C5834F" -IsDec -Values @($Redux.Capacity.Quiver1.Text,     $Redux.Capacity.Quiver2.Text,     $Redux.Capacity.Quiver3.Text)     -Interval 2
        ChangeBytes -Offset "C58357" -IsDec -Values @($Redux.Capacity.BombBag1.Text,    $Redux.Capacity.BombBag2.Text,    $Redux.Capacity.BombBag3.Text)    -Interval 2
        ChangeBytes -Offset "C5837F" -IsDec -Values @($Redux.Capacity.DekuSticks1.Text, $Redux.Capacity.DekuSticks1.Text, $Redux.Capacity.DekuSticks1.Text) -Interval 2
        ChangeBytes -Offset "C58387" -IsDec -Values @($Redux.Capacity.DekuNuts1.Text,   $Redux.Capacity.DekuNuts1.Text,   $Redux.Capacity.DekuNuts1.Text)   -Interval 2
    }



    # WALLET CAPACITY SELECTION #

    if (IsChecked -Elem $Redux.Capacity.EnableWallet) {
        $Wallet1 = Get16Bit ($Redux.Capacity.Wallet1.Text)
        $Wallet2 = Get16Bit ($Redux.Capacity.Wallet2.Text)
        $Wallet3 = Get16Bit ($Redux.Capacity.Wallet3.Text)
        ChangeBytes -Offset "C5836C" -Values @($Wallet1.Substring(0, 2), $Wallet1.Substring(2) )
        ChangeBytes -Offset "C5836E" -Values @($Wallet2.Substring(0, 2), $Wallet2.Substring(2) )
        ChangeBytes -Offset "C58370" -Values @($Wallet3.Substring(0, 2), $Wallet3.Substring(2) )
    }



    # EQUIPMENT #

    if (IsChecked -Elem $Redux.Gameplay.RazorSword) {
        ChangeBytes -Offset "CBA496" -Values @("00", "00") # Prevent losing hits
        ChangeBytes -Offset "BDA6B7" -Values "01"          # Keep sword after Song of Time
    }

}



#==============================================================================================================================================================================================
function ByteReduxMajorasMask() {
    
    # D-PAD #

    if ( (IsChecked -Elem $Redux.DPad.Hide) -or (IsChecked -Elem $Redux.DPad.LayoutLeft) -or (IsChecked -Elem $Redux.DPad.LayoutRight) -or (IsWidescreen -Patched) ) {
        $Array = @()
        $Array += GetItemID -Item $Redux.DPad.Up.Text
        $Array += GetItemID -Item $Redux.DPad.Right.Text
        $Array += GetItemID -Item $Redux.DPad.Down.Text
        $Array += GetItemID -Item $Redux.DPad.Left.Text
        
        if (IsWidescreen -Patched) { $Offset = "380622C" } else { $Offset = "3806354" }
        ChangeBytes -Offset $Offset -Values $Array

        if (IsWidescreen -Patched) { $Offset = "380623C" } else { $Offset = "3806364" }
        if (IsChecked -Elem $Redux.DPad.LayoutLeft)        { ChangeBytes -Offset $Offset -Values @("01", "01") }
        elseif (IsChecked -Elem $Redux.DPad.LayoutRight)   { ChangeBytes -Offset $Offset -Values @("01", "02") }
        else                                               { ChangeBytes -Offset $Offset -Values "01" }
    }



    # GAMEPLAY #

    # Minigames; Good Dampe RNG, Good Dog Race RNG & Faster Lab Fish
    # Always:    Arrow Cycling & Underwater ocarina

    if (IsWidescreen -Patched) { $Offset = "3806408" } else { $Offset = "3806530" }
    if     ( (IsChecked -Elem $Redux.Gameplay.EasierMinigames -Not) -and (IsChecked -Elem $Redux.Gameplay.FasterBlockPushing) )   { ChangeBytes -Offset $Offset -Values @("9E", "45", "06", "2D", "57", "4B", "28", "62", "49", "87", "69", "FB", "0F", "79", "1B", "9F", "18", "30") }
    elseif ( (IsChecked -Elem $Redux.Gameplay.EasierMinigames) -and (IsChecked -Elem $Redux.Gameplay.FasterBlockPushing -Not) )   { ChangeBytes -Offset $Offset -Values @("D2", "AD", "24", "8F", "0C", "58", "D0", "A8", "96", "55", "0E", "EE", "D2", "2B", "25", "EB", "08", "30") }
    elseif ( (IsChecked -Elem $Redux.Gameplay.EasierMinigames) -and (IsChecked -Elem $Redux.Gameplay.FasterBlockPushing) )        { ChangeBytes -Offset $Offset -Values @("B7", "36", "99", "48", "85", "BF", "FF", "B1", "FB", "EB", "D8", "B1", "06", "C8", "A8", "3B", "18", "30") }



    # BUTTON COLORS #

     if (IsIndex -Elem $Redux.Colors.Buttons -Index 2 -Not) {
        # A Button

        if (IsWidescreen -Patched) { $Substract = 296 } else { $Substract = 0 }
        ChangeBytes -Offset (Get24Bit ( (GetDecimal "3806470") - $Substract)) -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) # Button
        ChangeBytes -Offset (Get24Bit ( (GetDecimal "38064F0") - $Substract)) -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) # Text Icons
        ChangeBytes -Offset (Get24Bit ( (GetDecimal "38064C0") - $Substract)) -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)
        ChangeBytes -Offset (Get24Bit ( (GetDecimal "38064EC") - $Substract)) -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)
        ChangeBytes -Offset (Get24Bit ( (GetDecimal "38064F8") - $Substract)) -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)
        ChangeBytes -Offset (Get24Bit ( (GetDecimal "380650C") - $Substract)) -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)
        ChangeBytes -Offset (Get24Bit ( (GetDecimal "3806514") - $Substract)) -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)
        ChangeBytes -Offset (Get24Bit ( (GetDecimal "3806518") - $Substract)) -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)
        ChangeBytes -Offset (Get24Bit ( (GetDecimal "380651C") - $Substract)) -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)
        if ($Redux.Colors.Buttons.Text -eq "Randomized" -or $Redux.Colors.Buttons.Text -eq "Custom") {
            ChangeBytes -Offset (Get24Bit ((GetDecimal "38064CC") - $Substract)) -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) # Pause Outer Selection
            ChangeBytes -Offset (Get24Bit ((GetDecimal "38064D0") - $Substract)) -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) # Pause Outer Glow Selection
          # ChangeBytes -Offset (Get24Bit ((GetDecimal "38064D4") - $Substract)) -IsDec -Values @(($Redux.Colors.SetButtons[0].Color.R+20), ($Redux.Colors.SetButtons[0].Color.G+20), ($Redux.Colors.SetButtons[0].Color.B+20)) -Overflow # Pause Outer Glow Selection
          # ChangeBytes -Offset (Get24Bit ((GetDecimal "38064D8") - $Substract)) -IsDec -Values @(($Redux.Colors.SetButtons[0].Color.R-50), ($Redux.Colors.SetButtons[0].Color.G-50), ($Redux.Colors.SetButtons[0].Color.B-50)) -Overflow # Pause Glow Selection
        }

        # B Button
        ChangeBytes -Offset (Get24Bit ((GetDecimal "3806474") - $Substract)) -IsDec -Values @($Redux.Colors.SetButtons[1].Color.R, $Redux.Colors.SetButtons[1].Color.G, $Redux.Colors.SetButtons[1].Color.B) # Button
        ChangeBytes -Offset (Get24Bit ((GetDecimal "38064C4") - $Substract)) -IsDec -Values @($Redux.Colors.SetButtons[1].Color.R, $Redux.Colors.SetButtons[1].Color.G, $Redux.Colors.SetButtons[1].Color.B) # Text Icons

        # C Buttons
        ChangeBytes -Offset ( Get24Bit ( (GetDecimal "3806478") - $Substract ) ) -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # Buttons
        if ($Redux.Colors.Buttons.Text -eq "Randomized" -or $Redux.Colors.Buttons.Text -eq "Custom") {
            ChangeBytes -Offset (Get24Bit ((GetDecimal "38064C8") - $Substract)) -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # Text Icons
            ChangeBytes -Offset (Get24Bit ((GetDecimal "3806510") - $Substract)) -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # to Equip
            ChangeBytes -Offset (Get24Bit ((GetDecimal "38064FC") - $Substract)) -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # Note
            ChangeBytes -Offset (Get24Bit ((GetDecimal "38064DC") - $Substract)) -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # Pause Outer Selection
            ChangeBytes -Offset (Get24Bit ((GetDecimal "38064E0") - $Substract)) -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # Pause Selection
          # ChangeBytes -Offset (Get24Bit ((GetDecimal "38064E8") - $Substract)) -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # Pause Outer Glow Selection
          # ChangeBytes -Offset (Get24Bit ((GetDecimal "3806500") - $Substract)) -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) # Pause Outer Selection
        }

        # Start Button
        ChangeBytes -Offset "380647C" -IsDec -Values @($Redux.Colors.SetButtons[3].Color.R, $Redux.Colors.SetButtons[3].Color.G, $Redux.Colors.SetButtons[3].Color.B) # Button
    }



    # HUD COLORS #

    if (IsIndex -Elem $Redux.Colors.Hearts -Not) {
        ChangeBytes -Offset (Get24Bit ((GetDecimal "3806498") - $Substract)) -IsDec -Values @($Redux.Colors.SetHUDStats[0].Color.R, $Redux.Colors.SetHUDStats[0].Color.G, $Redux.Colors.SetHUDStats[0].Color.B)
        ChangeBytes -Offset (Get24Bit ((GetDecimal "380649C") - $Substract)) -IsDec -Values @($Redux.Colors.SetHUDStats[1].Color.R, $Redux.Colors.SetHUDStats[1].Color.G, $Redux.Colors.SetHUDStats[1].Color.B)
    }

    if (IsIndex -Elem $Redux.Colors.Magic -Not) {
        ChangeBytes -Offset (Get24Bit ((GetDecimal "38064A0") - $Substract)) -IsDec -Values @($Redux.Colors.SetHUDStats[2].Color.R, $Redux.Colors.SetHUDStats[2].Color.G, $Redux.Colors.SetHUDStats[2].Color.B)
        ChangeBytes -Offset (Get24Bit ((GetDecimal "38064A4") - $Substract)) -IsDec -Values @($Redux.Colors.SetHUDStats[3].Color.R, $Redux.Colors.SetHUDStats[3].Color.G, $Redux.Colors.SetHUDStats[3].Color.B)
    }

    if (IsIndex -Elem $Redux.Colors.Minimap -Not) {
        ChangeBytes -Offset (Get24Bit ((GetDecimal "38064A8") - $Substract)) -IsDec -Values @($Redux.Colors.SetHUDStats[4].Color.R, $Redux.Colors.SetHUDStats[4].Color.G, $Redux.Colors.SetHUDStats[4].Color.B)
    }


}



#==============================================================================================================================================================================================
function ByteLanguageMajorasMask() {
    
    if ( (IsChecked $Redux.Text.Restore) -or (IsLanguage -Elem $Redux.Gameplay.RazorSword) -or (IsLangText -Elem $Redux.Colors.Fairy -Compare "Navi") -or (IsLangText -Elem $Redux.Colors.Fairy -Compare "Tael") ) {
        $File = $GameFiles.extracted + "\message_data_static.bin"
        ExportBytes -Offset "AD1000" -Length "699F0" -Output $File -Force
    }

    if (IsChecked -Elem $Redux.Text.Restore) {
        ChangeBytes -Offset "1A6D6"  -Values @("AC", "A0")
        PatchBytes  -Offset "C5D0D8" -Patch "Message\Table Restore Text.bin"
        ApplyPatch -File $File -Patch "\Export\Message\restore_text.bps"
        PatchBytes -Offset "A2DDC4" -Length "26F" -Texture -Patch "Icons\Troupe Leader's Mask Text.yaz0" # Correct Circus Mask
    }

    if (IsChecked -Elem $Redux.Text.OcarinaIcons) {
        PatchBytes -Offset "A3B9BC" -Length "850" -Texture -Pad -Patch "Icons\Deku Pipes Icon.yaz0"  # Slingshot, ID: 0x0B
        PatchBytes -Offset "A28AF4" -Length "1AF" -Texture -Pad -Patch "Icons\Deku Pipes Text.yaz0"
        PatchBytes -Offset "A44BFC" -Length "A69" -Texture -Pad -Patch "Icons\Goron Drums Icon.yaz0" # Blue Fire, ID: 0x1C
        PatchBytes -Offset "A28204" -Length "26F" -Texture -Pad -Patch "Icons\Goron Drums Text.yaz0"
        PatchBytes -Offset "A4AAFC" -Length "999" -Texture -Pad -Patch "Icons\Zora Guitar Icon.yaz0" # Hylian Loach, ID: 0x26
        PatchBytes -Offset "A2B2B4" -Length "230" -Texture -Pad -Patch "Icons\Zora Guitar Text.yaz0"

        # Pointer Deku Pipes icon
        ChangeBytes -Offset "A36D80" -Values @("00", "00", "4A", "B0")

        # Pointer Goron Drums Text
        ChangeBytes -Offset "A27674" -Values @("00", "00", "2B", "A0")
        ChangeBytes -Offset "A276D0" -Values @("00", "00", "09", "C0")
    }

    if (IsLanguage -Elem $Redux.Gameplay.RazorSword) {
        $Offset = SearchBytes -File $File -Values @("54", "68", "69", "73", "20", "6E", "65", "77", "2C", "20", "73", "68", "61", "72", "70", "65", "72", "20", "62", "6C", "61", "64", "65")
        ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "38") ) ) -Values @("61", "73", "20", "6D", "75", "63", "68", "11", "79", "6F", "75", "20", "77", "61", "6E", "74", "20")

        $Offset = SearchBytes -File $File -Values @("54", "68", "65", "20", "4B", "6F", "6B", "69", "72", "69", "20", "53", "77", "6F", "72", "64", "20", "72", "65", "66", "6F", "72", "67", "65", "64")
        ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "30") ) ) -Values @("61", "73", "20", "6D", "75", "63", "68", "20", "79", "6F", "75", "20", "77", "61", "6E", "74", "2E", "20")

        $Offset = SearchBytes -File $File -Values @("4B", "65", "65", "70", "20", "69", "6E", "20", "6D", "69", "6E", "64", "20", "74", "68", "61", "74")
        PatchBytes -File $File -Offset $Offset -Patch "Message\Razor Sword 1.bin"

        $Offset = SearchBytes -File $File -Values @("4E", "6F", "77", "20", "6B", "65", "65", "70", "20", "69", "6E", "20", "6D", "69", "6E", "64", "20", "74", "68", "61", "74")
        PatchBytes -File $File -Offset $Offset -Patch "Message\Razor Sword 2.bin"
    }

    if (IsLangText -Elem $Redux.Colors.Fairy -Compare "Navi") {
        do { # Navi
            $Offset = SearchBytes -File $File -Start $Offset -Values @("54", "61", "74", "6C")
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values @("4E", "61", "76", "69") }
        } while ($Offset -gt 0)
    }
    elseif (IsLangText -Elem $Redux.Colors.Fairy -Compare "Tael") {
        do { # Tael
            $Offset = SearchBytes -File $File -Start $Offset -Values @("54", "61", "74", "6C")
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values @("54", "61", "65", "6C") }
        } while ($Offset -gt 0)
    }

    if ( (IsChecked $Redux.Text.Restore) -or (IsLanguage -Elem $Redux.Gameplay.RazorSword) -or (IsLangText -Elem $Redux.Colors.Fairy -Compare "Navi") -or (IsLangText -Elem $Redux.Colors.Fairy -Compare "Tael")  ) {
        PatchBytes -Offset "AD1000" -Patch "message_data_static.bin" -Extracted
    }

}



#==============================================================================================================================================================================================
function CreateOptionsMajorasMask() {
    
    if ($Settings.Debug.LiteGUI -eq $False) {
        CreateOptionsDialog -Width 1060 -Height 485 -Tabs @("Audiovisual", "Difficulty", "Colors", "Equipment")
    }
    else {
        CreateOptionsDialog -Width 1060 -Height 370 -Tabs @("Audiovisual")
    }

    if ($IsWiiVC) { $Redux.Graphics.Widescreen.Add_CheckStateChanged({ AdjustGUIMajorasMask }) }

}



#==============================================================================================================================================================================================
function AdjustGUIMajorasMask() {
    
    if ($IsWiiVC -or $Settings.Debug.LiteGUI -eq $True) { return }

    $Redux.Colors.Magic.Enabled = $Redux.Colors.BaseMagic.Enabled = $Redux.Colors.DoubleMagic.Enabled = (!(IsWidescreen -Patched))
    $Redux.DPad.Disable.Enabled = $Redux.DPad.Hide.Enabled = $Redux.DPad.LayoutLeft.Enabled = $Redux.DPad.LayoutRight.Enabled = (!(IsWidescreen -Patched))
    
    if (IsWidescreen -Patched)             { $Redux.DPad.Up.Enabled = $Redux.DPad.Left.Enabled = $Redux.DPad.Right.Enabled = $Redux.DPad.Down.Enabled = $True }
    elseif ($Redux.Dpad.Disable.Checked)   { $Redux.DPad.Up.Enabled = $Redux.DPad.Left.Enabled = $Redux.DPad.Right.Enabled = $Redux.DPad.Down.Enabled = $False }

}




#==============================================================================================================================================================================================
function CreateTabMainMajorasMask() {

    # GAMEPLAY #
    CreateReduxGroup    -Tag  "Gameplay" -Text "Gameplay" 
    CreateReduxCheckBox -Name "ZoraPhysics"       -Column 1 -Text "Zora Physics"         -Info "Change the Zora physics when using the boomerang`nZora Link will take a step forward instead of staying on his spot"
    CreateReduxCheckBox -Name "PalaceRoute"       -Column 2 -Text "Restore Palace Route" -Info "Restore the route to the Bean Seller within the Deku Palace as seen in the Japanese release"
    CreateReduxCheckBox -Name "DistantZTargeting" -Column 3 -Text "Distant Z-Targeting"  -Info "Allow to use Z-Targeting on enemies, objects and NPC's from any distance"

    # RESTORE #
    CreateReduxGroup    -Tag  "Restore" -Text "Restore / Correct" -Height 2
    CreateReduxCheckBox -Name "RupeeColors"       -Column 1 -Row 1 -Text "Correct Rupee Colors"     -Info "Corrects the colors for the Purple (50) and Golden (200) Rupees"                                           -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "CowNoseRing"       -Column 2 -Row 1 -Text "Restore Cow Nose Ring"    -Info "Restore the rings in the noses for Cows as seen in the Japanese release"                                   -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "RomaniSign"        -Column 3 -Row 1 -Text "Correct Romani Sign"      -Info "Replace the Romani Sign texture to display Romani's Ranch instead of Kakariko Village"                     -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "Title"             -Column 4 -Row 1 -Text "Restore Title"            -Info "Restore the title logo colors as seen in the Japanese release"                                             -Credits "ShadowOne333 & Garo-Mastah"
    CreateReduxCheckBox -Name "SkullKid"          -Column 5 -Row 1 -Text "Restore Skull Kid"        -Info "Restore Skull Kid's face as seen in the Japanese release"                                                  -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "ShopMusic"         -Column 6 -Row 1 -Text "Restore Shop Music"       -Info "Restores the Shop music intro theme as heard in the Japanese release"                                      -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "PieceOfHeartSound" -Column 1 -Row 2 -Text "4th Piece of Heart Sound" -Info "Restore the sound effect when collecting the fourth Piece of Heart that grants Link a new Heart Container" -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "MoveBomberKid"     -Column 2 -Row 2 -Text "Move Bomber Kid"          -Info "Moves the Bomber at the top of the Stock Pot Inn to be behind the bell like in the original Japanese ROM"  -Credits "ShadowOne333"

    # EVERYTHING ELSE #
    CreateReduxGroup    -Tag  "Other" -Text "Other"
    CreateReduxCheckBox -Name "GohtCutscene"     -Column 1 -Row 1 -Text "Fix Goht Cutscene"         -Info "Fix Goht's awakening cutscene so that Link no longer gets run over"                                                                                         -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "MushroomBottle"   -Column 2 -Row 1 -Text "Fix Mushroom Bottle"       -Info "Fix the item reference when collecting Magical Mushrooms as Link puts away the bottle automatically due to an error"                                        -Credits "ozidual"
    CreateReduxCheckBox -Name "SouthernSwamp"    -Column 3 -Row 1 -Text "Fix Southern Swamp"        -Info "Fix a misplaced door after Woodfall has been cleared and you return to the Potion Shop`nThe door is slightly pushed forward after Odolwa has been defeated" -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "FairyFountain"    -Column 4 -Row 1 -Text "Fix Fairy Fountain"        -Info "Fix the Ikana Canyon Fairy Fountain area not displaying the correct color"                                                                                  -Credits "Dybbles (fix) & ShadowOne333 (patch)"
    CreateReduxCheckBox -Name "AlwaysBestEnding" -Column 5 -Row 1 -Text "Always Best Ending"        -Info "The credits sequence always includes the best ending, regardless of actual ingame progression"                                                              -Credits "Marcelo20XX"
    if ($Settings.Debug.LiteGUI -eq $False) {
        CreateReduxCheckBox -Name "HideCredits"  -Column 6 -Row 1 -Text "Hide Credits"              -Info "Do not show the credits text during the credits sequence"                                                                                                   -Credits "Admentus"
    }

}



#==============================================================================================================================================================================================
function CreateTabReduxMajorasMask() {
    
    # D-PAD ICONS LAYOUT #
    CreateReduxGroup -Tag  "DPad" -Text "D-Pad Layout" -Height 6 -Columns 4
    CreateReduxPanel -Columns 0.8 -Rows 4
    CreateReduxRadioButton -Name "Disable"     -SaveTo "Layout" -Column 1 -Row 1          -Text "Disable"    -Info "Completely disable the D-Pad"                      -Credits "Ported from Redux"
    CreateReduxRadioButton -Name "Hide"        -SaveTo "Layout" -Column 1 -Row 2          -Text "Hidden"     -Info "Hide the D-Pad icons, while they are still active" -Credits "Ported from Redux"
    CreateReduxRadioButton -Name "LayoutLeft"  -SaveTo "Layout" -Column 1 -Row 3          -Text "Left Side"  -Info "Show the D-Pad icons on the left side of the HUD"  -Credits "Ported from Redux"
    CreateReduxRadioButton -Name "LayoutRight" -SaveTo "Layout" -Column 1 -Row 4 -Checked -Text "Right Side" -Info "Show the D-Pad icons on the right side of the HUD" -Credits "Ported from Redux"
    CreateReduxComboBox    -Name "Up"          -Column 2.8 -Row 1   -Length 160 -Items @("Disabled", "Ocarina of Time", "Deku Mask", "Goron Mask", "Zora Mask", "Fierce Deity's Mask") -Default 3 -Info "Set the quick slot item for the D-Pad Up button"    -Credits "Ported from Redux"
    CreateReduxComboBox    -Name "Left"        -Column 1.8 -Row 3.5 -Length 160 -Items @("Disabled", "Ocarina of Time", "Deku Mask", "Goron Mask", "Zora Mask", "Fierce Deity's Mask") -Default 4 -Info "Set the quick slot item for the D-Pad Left button"  -Credits "Ported from Redux"
    CreateReduxComboBox    -Name "Right"       -Column 3.8 -Row 3.5 -Length 160 -Items @("Disabled", "Ocarina of Time", "Deku Mask", "Goron Mask", "Zora Mask", "Fierce Deity's Mask") -Default 5 -Info "Set the quick slot item for the D-Pad Right button" -Credits "Ported from Redux"
    CreateReduxComboBox    -Name "Down"        -Column 2.8 -Row 6   -Length 160 -Items @("Disabled", "Ocarina of Time", "Deku Mask", "Goron Mask", "Zora Mask", "Fierce Deity's Mask") -Default 2 -Info "Set the quick slot item for the D-Pad Down button"  -Credits "Ported from Redux"
    $Redux.DPad.Reset = CreateReduxButton      -Column 1 -Row 5 -Height 30 -Text "Reset Layout" -Info "Reset the layout for the D-Pad"

    # D-Pad Buttons Customization - Image #
    $PictureBox = New-Object Windows.Forms.PictureBox
    $PictureBox.Location = New-object System.Drawing.Size( ($Redux.DPad.Left.Right + 20), $Redux.DPad.Up.Bottom)
    $PictureBox.Image  = [System.Drawing.Image]::Fromfile( ( Get-Item ($Paths.Main + "\D-Pad.png") ) )
    $PictureBox.Width  = $PictureBox.Image.Size.Width
    $PictureBox.Height = $PictureBox.Image.Size.Height
    $Last.Group.controls.add($PictureBox)
    
    $Redux.DPad.Up.Enabled = $Redux.DPad.Left.Enabled = $Redux.DPad.Right.Enabled = $Redux.DPad.Down.Enabled = $Redux.DPad.Reset.Enabled = !$Redux.DPad.Disable.Checked
    $Redux.DPad.Disable.Add_CheckedChanged({
        $Redux.DPad.Up.Enabled = $Redux.DPad.Left.Enabled = $Redux.DPad.Right.Enabled = $Redux.DPad.Down.Enabled = $Redux.DPad.Reset.Enabled = !$Redux.DPad.Disable.Checked
    })
    $Redux.DPad.Reset.Add_Click({ $Redux.DPad.Up.SelectedIndex = 2; $Redux.DPad.Left.SelectedIndex = 3; $Redux.DPad.Right.SelectedIndex = 4; $Redux.DPad.Down.SelectedIndex = 1 })

    # GAMEPLAY #
    CreateReduxGroup        -Tag  "Gameplay" -Text "Gameplay"
    CreateReduxCheckBox     -Name "FasterBlockPushing" -Column 1 -Row 1 -Checked -Text "Faster Block Pushing" -Info "All blocks are pushed faster" -Credits "Ported from Redux"
    CreateReduxCheckBox     -Name "EasierMinigames"    -Column 2 -Row 1          -Text "Easier Minigames"     -Info "Certain minigames are made easier and faster`n- Dampe's Digging Game always has two Ghost Flames on the ground and one up the ladder`n- The Gold Dog always wins the Doggy Racetrack race if you have the Mask of Truth`nOnly one fish has to be feeded in the Marine Research Lab" -Credits "Ported from Rando"
    
    # BUTTON COLORS #
    CreateButtonColorOptions -Default 2
    
}



#==============================================================================================================================================================================================
function CreateTabLanguageMajorasMask() {
    
    CreateLanguageContent -Columns 3

    # ENGLISH TEXT #    
    $Redux.Box.Text = CreateReduxGroup -Tag "Text" -Text "English Text"
    CreateReduxCheckBox -Name "Restore"      -Column 1 -Text "Restore Text"        -Info "Restores and fixes the following:`n- Restore the area titles cards for those that do not have any`n- Sound effects that do not play during dialogue`n- Grammar and typo fixes" -Credits "Redux"
    CreateReduxCheckBox -Name "OcarinaIcons" -Column 2 -Text "Ocarina Icons (WIP)" -Info "Restore the Ocarina Icons with their text when transformed like in the N64 Beta or 3DS version (Work-In-Progress)`nRequires the Restore Text option"                           -Credits "ShadowOne333"
    


    $Redux.Text.Restore.Add_CheckedChanged({ $Redux.Text.OcarinaIcons.Enabled = $this.checked })
    for ($i=0; $i -lt $GamePatch.languages.Length; $i++) {
        $Redux.Language[$i].Add_CheckedChanged({ UnlockLanguageContent })
    }
    UnlockLanguageContent

}



#==============================================================================================================================================================================================
function UnlockLanguageContent() {
    
    # English options
    $Redux.Box.Text.Enabled = $Patches.Options.Checked
    $Redux.Text.Restore.Enabled = $Redux.Language[0].checked
    $Redux.Text.OcarinaIcons.Enabled = $Redux.Language[0].checked -and $Redux.Text.Restore.Checked

}



#==============================================================================================================================================================================================
function CreateTabAudiovisualMajorasMask() {

    # GRAPHICS #
    CreateReduxGroup    -Tag  "Graphics" -Text "Graphics" -Height 2

    if ($WiiVC) {
        $Info = "Native 16:9 Widescreen Display support with backgrounds and textures adjusted for widescreen"
        $Credits = "`nAspect Ratio Fix by Admentus`n16:9 backgrounds by GhostlyDark & ShadowOne333"
    }
    else {
        $Info  = "Advanced native 16:9 Widescreen Display support with backgrounds and textures adjusted for widescreen"
        $Info += "`n`n--- KNOWN ISSUES ---`n"
        $Info += "- Notebook screen stretched"
        $Info += "`n`n--- CHANGE WIDESCREEN ---`n"
        $Info += "Adjust the backgrounds and textures to fit in with 16:9 Widescreen`nUse GLideN64 " + '"adjust to fit"' + " option for 16:9 widescreen"
        $Credits = "`nAspect Ratio Fix by Admentus`n16:9 backgrounds by GhostlyDark & ShadowOne333`nWidescreen Patch by gamemasterplc and corrected by GhostlyDark"
    }
   
    CreateReduxCheckBox -Name "Widescreen"        -Column 1 -Row 1 -Text "16:9 Widescreen"           -Info $Info                                                                                                                  -Credits $Credits
    CreateReduxCheckBox -Name "BlackBars"         -Column 2 -Row 1 -Text "No Black Bars"             -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes"                    -Credits "Admentus"
    CreateReduxCheckBox -Name "ExtendedDraw"      -Column 3 -Row 1 -Text "Extended Draw Distance"    -Info "Increases the game's draw distance for objects`nDoes not work on all objects"                                         -Credits "Admentus"
    CreateReduxCheckBox -Name "PixelatedStars"    -Column 4 -Row 1 -Text "Disable Pixelated Stars"   -Info "Completely disable the stars at night-time, which are pixelated dots and do not have any textures for HD replacement" -Credits "Admentus"
    CreateReduxCheckBox -Name "MotionBlur"        -Column 5 -Row 1 -Text "Disable Motion Blur"       -Info "Completely Disable the use of motion blur in-game"                                                                    -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "ImprovedLinkModel" -Column 6 -Row 1 -Text "Improved Link Model"       -Info "Improves the model used for Hylian Link`nCustom tunic colors are not supported with this option"                      -Credits "Skilarbabcock (www.youtube.com/user/skilarbabcock) & Nerrel"
    CreateReduxCheckBox -Name "FlashbackOverlay"  -Column 1 -Row 2 -Text "Disable Flashback Overlay" -Info "Disables the overlay shown during Princess Zelda flashback scene"                                                     -Credits "GhostlyDark"

    # INTERFACE #
    CreateReduxGroup    -Tag  "UI" -Text "Interface"
    CreateReduxCheckBox -Name "HudTextures"       -Column 1 -Row 1 -Text "OoT HUD Textures"          -Info "Replaces the HUD textures with those from Ocarina of Time"                                                            -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "Comma"             -Column 2 -Row 1 -Text "Better Comma"              -Info "Make the comma not look as awful"                                                                                     -Credits "ShadowOne333"

    if ($Settings.Debug.LiteGUI -eq $True) { return }

    # SOUNDS / SFX SOUND EFFECTS
    CreateReduxGroup    -Tag  "Sounds" -Text "Sounds / SFX Sound Effects" -Height 2
    CreateReduxComboBox -Name "LowHP"             -Column 5 -Row 1 -Text "Low HP SFX:"                 -Items @("Default", "Disabled", "Soft Beep")  -Info "Set the sound effect for the low HP beeping"                   -Credits "Ported from Rando"
    $SFX =  @("Ocarina", "Deku Pipes", "Goron Drums", "Zora Guitar", "Female Voice", "Bell", "Cathedral Bell", "Piano", "Soft Harp", "Harp", "Accordion", "Bass Guitar", "Flute", "Whistling Flute", "Gong", "Elder Goron Drums", "Choir", "Arguing", "Tatl", "Giants Singing", "Ikana King", "Frog Croak", "Beaver", "Eagle Seagull", "Dodongo")
    CreateReduxComboBox -Name "InstrumentHylian"  -Column 1 -Row 1 -Text "Instrument (Hylian):" -Default 1 -Shift 30 -Length 200 -Items $SFX -Info "Replace the sound used for playing the Ocarina of Time in Hylian Form" -Credits "Ported from Rando"
    CreateReduxComboBox -Name "InstrumentDeku"    -Column 3 -Row 1 -Text "Instrument (Deku):"   -Default 2 -Shift 30 -Length 200 -Items $SFX -Info "Replace the sound used for playing the Deku Pipes in Deku Form"        -Credits "Ported from Rando"
    CreateReduxComboBox -Name "InstrumentGoron"   -Column 1 -Row 2 -Text "Instrument (Goron):"  -Default 3 -Shift 30 -Length 200 -Items $SFX -Info "Replace the sound used for playing the Goron Drums in Goron Form"      -Credits "Ported from Rando"
    CreateReduxComboBox -Name "InstrumentZora"    -Column 3 -Row 2 -Text "Instrument (Zora):"   -Default 4 -Shift 30 -Length 200 -Items $SFX -Info "Replace the sound used for playing the Zora Guitar in Zora Form"       -Credits "Ported from Rando"

}



#==============================================================================================================================================================================================
function CreateTabDifficultyMajorasMask() {
    
    # HERO MODE #
    CreateReduxGroup    -Tag  "Hero" -Text "Hero Mode"
    CreateReduxComboBox -Name "Damage"     -Column 1 -Row 1 -Text "Damage:"      -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage", "OHKO Mode") -Info "Set the amount of damage you receive`nOHKO Mode = You die in one hit" -Credits "Admentus"
    CreateReduxComboBox -Name "Recovery"   -Column 3 -Row 1 -Text "Recovery:"    -Items @("1x Recovery", "1/2x Recovery", "1/4x Recovery", "0x Recovery")  -Info "Set the amount health you recovery from Recovery Hearts"              -Credits "Admentus"
    CreateReduxComboBox -Name "MagicUsage" -Column 5 -Row 1 -Text "Magic Usage:" -Items @("1x Magic Usage", "2x Magic Usage", "3x Magic Usage")            -Info "Set the amount of times magic is consumed at"                         -Credits "Admentus"
   #CreateReduxComboBox -Name "BossHP"     -Column 0 -Row 2 -Text "Boss HP:"     -Items @("1x Boss HP", "2x Boss HP", "3x Boss HP")                        -Info "Set the amount of health for bosses"                                  -Credits "Admentus"
    


    $Redux.Hero.Damage.Add_SelectedIndexChanged({ $Redux.Hero.Recovery.Enabled = $this.Text -ne "OHKO Mode" })
    $Redux.Hero.Recovery.Enabled = $Redux.Hero.Damage.Text -ne "OHKO Mode"

}



#==============================================================================================================================================================================================
function CreateTabColorsMajorasMask() {
    
    # TUNIC COLORS #
    $Colors = @("Kokiri Green", "Goron Red", "Zora Blue", "Black", "White", "Azure Blue", "Vivid Cyan", "Light Red", "Fuchsia", "Purple", "Majora Purple", "Twitch Purple", "Persian Rose", "Dirty Yellow", "Blush Pink", "Hot Pink", "Rose Pink", "Orange", "Gray", "Gold", "Silver", "Beige", "Teal", "Blood Red", "Blood Orange", "Royal Blue", "Sonic Blue", "NES Green", "Dark Green", "Lumen", "Randomized", "Custom")
    CreateReduxGroup    -Tag  "Colors" -Text "Tunic Colors"
    CreateReduxComboBox -Name "KokiriTunic" -Column 1 -Text "Kokiri Tunic Color:" -Length 230 -Shift 70 -Items $Colors -Info ("Select a color scheme for the Kokiri Tunic`n" + '"Randomized" fully randomizes the colors each time the patcher is opened') -Credits "Ported from Rando"
    $Redux.Colors.KokiriTunicButton = CreateReduxButton -Column 3 -Text "Kokiri Tunic" -Width 100  -Info "Select the color you want for the Kokiri Tunic" -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "MaskForms"   -Column 6 -Text "Recolor Mask Forms"       -Info "Recolor the clothing for Goron Link to appear in Red and Zora Link to appear in Blue" -Credits "ShadowOne333 & Garo-Mastah"

    $Redux.Colors.KokiriTunicButton.Add_Click({ $Redux.Colors.SetKokiriTunic.ShowDialog(); $Redux.Colors.KokiriTunic.Text = "Custom"; $Redux.Colors.KokiriTunicLabel.BackColor = $Redux.Colors.SetKokiriTunic.Color; $GameSettings["Hex"][$Redux.Colors.SetKokiriTunic] = $Redux.Colors.SetKokiriTunic.Color.Name })
    $Redux.Colors.SetKokiriTunic   = CreateColorDialog -Name "SetKokiriTunic" -Color "1E691B" -IsGame
    $Redux.Colors.KokiriTunicLabel = CreateReduxColoredLabel -Link $Redux.Colors.KokiriTunicButton -Color $Redux.Colors.SetKokiriTunic.Color

    $Redux.Colors.KokiriTunic.Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.KokiriTunic -Dialog $Redux.Colors.SetKokiriTunic -Label $Redux.Colors.KokiriTunicLabel })
    SetTunicColorsPreset -ComboBox $Redux.Colors.KokiriTunic -Dialog $Redux.Colors.SetKokiriTunic -Label $Redux.Colors.KokiriTunicLabel

    $Redux.Graphics.ImprovedLinkModel.Add_CheckedChanged({
        $Redux.Colors.KokiriTunic.Enabled = $Redux.Colors.KokiriTunicButton.Enabled = !$this.checked
    })
    $Redux.Colors.KokiriTunic.Enabled = $Redux.Colors.KokiriTunicButton.Enabled = !$Redux.Graphics.ImprovedLinkModel.Checked



    # SPIN ATTACK COLORS #
    CreateSpinAttackColorOptions

    # FAIRY COLORS #
    CreateFairyColorOptions -Name "Tatl" -Second "Navi" -Preset ("`n" + 'Selecting the presets "Navi" or "Tael" will also change the references for "Tatl" in the dialogue')



    # HUD COLORS #
    CreateReduxGroup    -Tag  "Colors" -Text "HUD Colors" -Height 2 -IsRedux
    CreateReduxComboBox -Name "Hearts"  -Column 1 -Text "Hearts Colors:"  -Length 185 -Shift 35 -Items @("Red", "Green", "Blue", "Yellow", "Randomized", "Custom") -Info ("Select a preset for the hearts colors`n" + '"Randomized" fully randomizes the colors each time the patcher is opened')
    CreateReduxComboBox -Name "Magic"   -Column 3 -Text "Magic Colors:"   -Length 185 -Shift 35 -Items @("Green", "Red", "Blue", "Purple", "Pink", "Yellow", "White", "Randomized", "Custom") -Info ("Select a preset for the magic colors`n" + '"Randomized" fully randomizes the colors each time the patcher is opened')
    CreateReduxComboBox -Name "Minimap" -Column 5 -Text "Minimap Colors:" -Length 185 -Shift 35 -Items @("Cyan", "Green", "Red", "Blue", "Gray", "Purple", "Pink", "Yellow", "White", "Black", "Randomized", "Custom") -Info ("Select a preset for the minimap colors`n" + '"Randomized" fully randomizes the colors each time the patcher is opened')

    # Heart / Magic Colors - Buttons
    $Buttons = @()
    $Buttons += CreateReduxButton -Column 1 -Row 2 -Width 100 -Tag $Buttons.Count -Text "Hearts (Base)"   -Info "Select the color you want for the standard hearts display" -Credits "Ported from Rando"
    $Buttons += CreateReduxButton -Column 2 -Row 2 -Width 100 -Tag $Buttons.Count -Text "Hearts (Double)" -Info "Select the color you want for the enhanced hearts display" -Credits "Ported from Rando"
    $Buttons += CreateReduxButton -Column 3 -Row 2 -Width 100 -Tag $Buttons.Count -Text "Magic (Base)"    -Info "Select the color you want for the standard magic display"  -Credits "Ported from Rando"
    $Redux.Colors.BaseMagic = $Buttons[$Buttons.Length-1]
    $Buttons += CreateReduxButton -Column 4 -Row 2 -Width 100 -Tag $Buttons.Count -Text "Magic (Double)"  -Info "Select the color you want for the enhanced magic display"  -Credits "Ported from Rando"
    $Redux.Colors.DoubleMagic = $Buttons[$Buttons.Length-1]
    $Buttons += CreateReduxButton -Column 5 -Row 2 -Width 100 -Tag $Buttons.Count -Text "Minimap"         -Info "Select the color you want for the minimap"                 -Credits "Ported from Rando"

    # Heart / Magic Colors - Dialogs
    $Redux.Colors.SetHUDStats = @()
    $Redux.Colors.SetHUDStats += CreateColorDialog -Color "0000FF" -Name "SetBaseHearts"   -IsGame
    $Redux.Colors.SetHUDStats += CreateColorDialog -Color "0064FF" -Name "SetDoubleHearts" -IsGame
    $Redux.Colors.SetHUDStats += CreateColorDialog -Color "FF0000" -Name "SetBaseMagic"    -IsGame
    $Redux.Colors.SetHUDStats += CreateColorDialog -Color "FF6400" -Name "SetDoubleMagic"  -IsGame
    $Redux.Colors.SetHUDStats += CreateColorDialog -Color "00FFFF" -Name "SetMinimap"      -IsGame

    # Heart / Magic Colors - Labels
    $Redux.Colors.HUDStatsLabels = @()
    for ($i=0; $i -lt $Buttons.length; $i++) {
        $Buttons[$i].Add_Click({
            $Redux.Colors.SetHUDStats[[int]$this.Tag].ShowDialog(); $Redux.Colors.HUDStatsLabels[[int]$this.Tag].BackColor = $Redux.Colors.SetHUDStats[[int]$this.Tag].Color; $GameSettings["Hex"][$Redux.Colors.SetHUDStats[[int]$this.Tag].Tag] = $Redux.Colors.SetHUDStats[[int]$this.Tag].Color.Name
            if ($this.Tag -lt 2)       { $Redux.Colors.Hearts.Text   = "Custom" }
            elseif ($this.Tag -lt 4)   { $Redux.Colors.Magic.Text    = "Custom" }
            else                       { $Redux.Colors.Minimap.Text  = "Custom" }
        })
        $Redux.Colors.HUDStatsLabels += CreateReduxColoredLabel -Link $Buttons[$i]  -Color $Redux.Colors.SetHUDStats[$i].Color
    }

    $Redux.Colors.Hearts.Add_SelectedIndexChanged({ SetHeartsColorsPreset -ComboBox $Redux.Colors.Hearts -Dialog $Redux.Colors.SetHUDStats[0] -Label $Redux.Colors.HUDStatsLabels[0] })
    SetHeartsColorsPreset -ComboBox $Redux.Colors.Hearts -Dialog $Redux.Colors.SetHUDStats[0] -Label $Redux.Colors.HUDStatsLabels[0]
    $Redux.Colors.Hearts.Add_SelectedIndexChanged({ SetHeartsColorsPreset -ComboBox $Redux.Colors.Hearts -Dialog $Redux.Colors.SetHUDStats[1] -Label $Redux.Colors.HUDStatsLabels[1] })
    SetHeartsColorsPreset -ComboBox $Redux.Colors.Hearts -Dialog $Redux.Colors.SetHUDStats[1] -Label $Redux.Colors.HUDStatsLabels[1]

    $Redux.Colors.Magic.Add_SelectedIndexChanged({ SetMagicColorsPreset -ComboBox $Redux.Colors.Magic -Dialog $Redux.Colors.SetHUDStats[2] -Label $Redux.Colors.HUDStatsLabels[2] })
    SetMagicColorsPreset -ComboBox $Redux.Colors.Magic -Dialog $Redux.Colors.SetHUDStats[2] -Label $Redux.Colors.HUDStatsLabels[2]
    $Redux.Colors.Magic.Add_SelectedIndexChanged({ SetMagicColorsPreset -ComboBox $Redux.Colors.Magic -Dialog $Redux.Colors.SetHUDStats[3] -Label $Redux.Colors.HUDStatsLabels[3] })
    SetMagicColorsPreset -ComboBox $Redux.Colors.Magic -Dialog $Redux.Colors.SetHUDStats[3] -Label $Redux.Colors.HUDStatsLabels[3]

    $Redux.Colors.Minimap.Add_SelectedIndexChanged({ SetMinimapColorsPreset -ComboBox $Redux.Colors.Minimap -Dialog $Redux.Colors.SetHUDStats[4] -Label $Redux.Colors.HUDStatsLabels[4] })
    SetMinimapColorsPreset -ComboBox $Redux.Colors.Minimap -Dialog $Redux.Colors.SetHUDStats[4] -Label $Redux.Colors.HUDStatsLabels[4]

}



#==============================================================================================================================================================================================
function CreateTabEquipmentMajorasMask() {
    
    # CAPACITY SELECTION #
    CreateReduxGroup    -Tag  "Capacity" -Text "Capacity Selection"
    CreateReduxCheckBox -Name "EnableAmmo"   -Column 1 -Text "Change Ammo Capacity"   -Info "Enable changing the capacity values for ammo"
    CreateReduxCheckBox -Name "EnableWallet" -Column 2 -Text "Change Wallet Capacity" -Info "Enable changing the capacity values for the wallets"

    # AMMO #
    $Redux.Box.Ammo = CreateReduxGroup -Tag "Capacity" -Text "Ammo Capacity Selection" -Height 2
    CreateReduxTextBox -Name "Quiver1"     -Column 1 -Row 1           -Text "Quiver (1)"      -Value 30  -Info "Set the capacity for the Quiver (Base)`nDefault = 30"        -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver2"     -Column 2 -Row 1           -Text "Quiver (2)"      -Value 40  -Info "Set the capacity for the Quiver (Upgrade 1)`nDefault = 40"   -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver3"     -Column 3 -Row 1           -Text "Quiver (3)"      -Value 50  -Info "Set the capacity for the Quiver (Upgrade 2)`nDefault = 50"   -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag1"    -Column 1 -Row 2           -Text "Bomb Bag (1)"    -Value 20  -Info "Set the capacity for the Bomb Bag (Base)`nDefault = 20"      -Credits "GhostlyDark" 
    CreateReduxTextBox -Name "BombBag2"    -Column 2 -Row 2           -Text "Bomb Bag (2)"    -Value 30  -Info "Set the capacity for the Bomb Bag (Upgrade 1)`nDefault = 30" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag3"    -Column 2 -Row 2           -Text "Bomb Bag (3)"    -Value 40  -Info "Set the capacity for the Bomb Bag (Upgrade 2)`nDefault = 40" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuSticks1" -Column 4 -Row 1           -Text "Deku Sticks (1)" -Value 10  -Info "Set the capacity for the Deku Sticks (Base)`nDefault = 10"   -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuNuts1"   -Column 4 -Row 2           -Text "Deku Nuts (1)"   -Value 20  -Info "Set the capacity for the Deku Nuts (Base)`nDefault = 20"     -Credits "GhostlyDark"

    # WALLET #
    $Redux.Box.Wallet = CreateReduxGroup -Tag "Capacity" -Text "Wallet Capacity Selection"
    CreateReduxTextBox -Name "Wallet1"     -Column 1 -Row 1 -Length 3 -Text "Wallet (1)"      -Value 99  -Info "Set the capacity for the Wallet (Base)`nDefault = 99"        -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet2"     -Column 2 -Row 1 -Length 3 -Text "Wallet (2)"      -Value 200 -Info "Set the capacity for the Wallet (Upgrade 1)`nDefault = 200"  -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet3"     -Column 3 -Row 1 -Length 3 -Text "Wallet (3)"      -Value 500 -Info "Set the capacity for the Wallet (Upgrade 2)`nDefault = 500"  -Credits "GhostlyDark"

    # EQUIPMENT #
    CreateReduxGroup -Tag "Gameplay" -Text "Equipment"
    CreateReduxCheckBox -Name "RazorSword" -Text "Permanent Razor Sword" -Info "The Razor Sword won't get destroyed after 100 hits`nYou can also keep the Razor Sword when traveling back in time" -Credits "darklord92"



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



#==============================================================================================================================================================================================

Export-ModuleMember -Function PrePatchReduxMajorasMask
Export-ModuleMember -Function PatchOptionsMajorasMask
Export-ModuleMember -Function ByteOptionsMajorasMask
Export-ModuleMember -Function ByteReduxMajorasMask
Export-ModuleMember -Function ByteLanguageMajorasMask

Export-ModuleMember -Function CreateOptionsMajorasMask
Export-ModuleMember -Function AdjustGUIMajorasMask

Export-ModuleMember -Function CreateTabMainMajorasMask
Export-ModuleMember -Function CreateTabReduxMajorasMask
Export-ModuleMember -Function CreateTabLanguageMajorasMask
Export-ModuleMember -Function CreateTabAudiovisualMajorasMask
Export-ModuleMember -Function CreateTabDifficultyMajorasMask
Export-ModuleMember -Function CreateTabColorsMajorasMask
Export-ModuleMember -Function CreateTabEquipmentMajorasMask