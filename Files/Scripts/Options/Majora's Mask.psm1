function PatchOptions() {
    
    # ENHANCED 16:9 WIDESCREEN #

    if (IsWidescreen)                                   { ApplyPatch -Patch "\Decompressed\widescreen.ppf" }
    if ( (IsWidescreen) -or (IsWidescreen -Patched) )   { RemoveFile $Files.dmaTable }
    if (IsWidescreen)                                   { Add-Content $Files.dmaTable "0 1 2 3 4 5 6 7 -8 -9 15 16 17 18 19 20 -21 22 -24 25 26 27 28 29 30 -652 1127 -1540 -1541 -1542 -1543 -1544 -1545 -1546 -1547 -1548 -1549 -1550 -1551 1552 1553 1554 1555 1556 1557 1558 1559 1560 1561 1562 1563 1564 1565 1566 1567" }
    if (IsWidescreen -Patched)                          { Add-Content $Files.dmaTable "0 1 2 3 4 5 6 7 -8 -9 15 16 17 18 19 20 -21 22 -24 25 26 27 28 29 30 -652 1127 -1540 -1541 -1542 -1543 1544 1545 1546 1547 1548 1549 1550 -1551 1552 1553 1554 1555 1556 1557 1558 1559 1560 1561 1562 1563 1564 1565 1566 1567" }



    # MODELS #

    if (IsChecked $Redux.Graphics.ImprovedLinkModel)    { ApplyPatch -Patch "\Decompressed\improved_link_model.ppf" }



    # DIFFICULTY #

    if (IsChecked $Redux.Hero.MasterQuest)              { ApplyPatch -Patch "\Decompressed\master_quest_remix.ppf" }

}



#==============================================================================================================================================================================================
function ByteOptions() {
    
    # GAMEPLAY #
    if (IsChecked $Redux.Gameplay.ZoraPhysics)         { PatchBytes  -Offset "65D000" -Patch "Zora Physics Fix.bin" }
    if (IsChecked $Redux.Gameplay.DistantZTargeting)   { ChangeBytes -Offset "B4E924" -Values "00 00 00 00" }
    if (IsChecked $Redux.Gameplay.ManualJump)          { ChangeBytes -Offset "CB4008" -Values "04 C1"; ChangeBytes -Offset "CB402B" -Values "01"  }
    if (IsChecked $Redux.Gameplay.SwordBeamAttack)     { ChangeBytes -Offset "CD73F0" -Values "00 00"; ChangeBytes -Offset "CD73F4" -Values "00 00"  }
    if (IsChecked $Redux.Gameplay.UnsheathSword)       { ChangeBytes -Offset "CC2CE8" -Values "28 42 00 05 14 40 00 05 00 00 10 25" }



    # RESTORE #

    if (IsChecked $Redux.Restore.RomaniSign)   { PatchBytes  -Offset "26A58C0" -Texture -Patch "Romani Sign.bin" }
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
        PatchBytes  -Offset "181C620" -Texture -Patch "Skull Kid Beak.bin"
    }

    if (IsChecked $Redux.Restore.ShopMusic)           { ChangeBytes -Offset "2678007" -Values "44" }
    if (IsChecked $Redux.Restore.PieceOfHeartSound)   { ChangeBytes -Offset "BA94C8"  -Values "10 00" }
    if (IsChecked $Redux.Restore.MoveBomberKid)       { ChangeBytes -Offset "2DE4396" -Values "02 C5 01 18 FB 55 00 07 2D" }



    # OTHER #

    if (IsChecked $Redux.Other.SouthernSwamp) {
        CreateSubPath  -Path ($GameFiles.extracted + "\Southern Swamp")
        ExportAndPatch -Path "Southern Swamp\southern_swamp_cleared_scene"  -Offset "1F0D000" -Length "10630"
        ExportAndPatch -Path "Southern Swamp\southern_swamp_cleared_room_0" -Offset "1F1E000" -Length "1B240" -NewLength "1B4F0" -TableOffset "1EC26"  -Values "94 F0"
        ExportAndPatch -Path "Southern Swamp\southern_swamp_cleared_room_2" -Offset "1F4D000" -Length "D0A0"  -NewLength "D1C0"  -TableOffset "1EC46"  -Values "A1 C0"
    }

    if (IsChecked $Redux.Other.AlwaysBestEnding) {
        ChangeBytes -Offset "B81CE0" -Values "00 00 00 00"
        ChangeBytes -Offset "B81D48" -Values "00 00 00 00"
        ChangeBytes -Offset "B81DB0" -Values "00 00 00 00"
        ChangeBytes -Offset "B81E18" -Values "00 00 00 00"
        ChangeBytes -Offset "B81E80" -Values "00 00 00 00"
        ChangeBytes -Offset "B81EE8" -Values "00 00 00 00"
        ChangeBytes -Offset "B81F84" -Values "00 00 00 00"
        ChangeBytes -Offset "B81FEC" -Values "00 00 00 00"
        ChangeBytes -Offset "B82054" -Values "00 00 00 00"
    }

   

    if (IsChecked $Redux.Other.GohtCutscene)     { ChangeBytes -Offset "F6DE89" -Values "8D 00 02 10 00 00 0A" }
    if (IsChecked $Redux.Other.MushroomBottle)   { ChangeBytes -Offset "CD7C48" -Values "1E 6B" }
    if (IsChecked $Redux.Other.FairyFountain)    { ChangeBytes -Offset "B9133E" -Values "01 0F" }
    if (IsChecked $Redux.Other.HideCredits)      { PatchBytes  -Offset "B3B000" -Patch "Message\Credits.bin" }
    if (IsChecked $Redux.Other.DebugMapSelect)   { ChangeBytes -Offset "C53F44" -Values "00 C7 AD F0 00 C7 E2 D0 80 80 09 10 80 80 3D F0 00 00 00 00 80 80 1B 4C 80 80 1B 28" }



    # GRAPHICS #

    if (IsChecked $Redux.Graphics.Widescreen) {
        if ($IsWiiVC) { # 16:9 Widescreen
            ChangeBytes -Offset "BD5D74" -Values "3C 07 3F E3"
            ChangeBytes -Offset "CA58F5" -Values "6C 53 6C 84 9E B7 53 6C" -Interval 2

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
            ChangeBytes -Offset "C981F3" -Values "1A 35 EF 82 90 3C 19 00 12 37 39 82 30 24 4D 00 08 AE 0D 02 B0" # Dungeon Map - Stray Fairy Icon (22 35 EF 82 90 3C 19 00 1A 37 39 82 30 24 4D 00 08 AE 0D 02 B0)

          # ChangeBytes -Offset "BAF2E0" -Values "" # A Button
          # ChangeBytes -Offset "C55F14" -Values "" # B, C-Left, C-Down, C-Right Buttons
        }

        if ($IsWiiVC -or $Settings.Debug.ChangeWidescreen -eq $True) { # 16:9 Textures
            PatchBytes -Offset "A9A000" -Length "12C00" -Texture -Patch "Widescreen\Carnival of Time.bin"
            PatchBytes -Offset "AACC00" -Length "12C00" -Texture -Patch "Widescreen\Four Giants.bin"
            PatchBytes -Offset "C74DD0" -Length "800"   -Texture -Patch "Widescreen\Lens of Truth.bin"
        }
    }

    if (IsChecked $Redux.Graphics.ExtendedDraw)       { ChangeBytes -Offset "B50874" -Values "00 00 00 00" }
    if (IsChecked $Redux.Graphics.BlackBars)          { ChangeBytes -Offset "BF72A4" -Values "00 00 00 00" }
    if (IsChecked $Redux.Graphics.PixelatedStars)     { ChangeBytes -Offset "B943FC" -Values "10 00" }
    if (IsChecked $Redux.Graphics.MotionBlur)         { ChangeBytes -Offset "BFB9A0" -Values "03 E0 00 08 00 00 00 00 00" }
    if (IsChecked $Redux.Graphics.FlashbackOverlay)   { ChangeBytes -Offset "BFEB8C" -Values "24 0F 00 00" }



    # INTERFACE #

    if (IsChecked $Redux.UI.HudTextures) {
        PatchBytes -Offset "1EBDF60" -Texture -Patch "HUD\OoT Button.bin"
        PatchBytes -Offset "1EBD100" -Texture -Patch "HUD\OoT Hearts.bin"
    }

    if (IsChecked $Redux.UI.ButtonPositions) {
        ChangeBytes -Offset "BAF2E3" -Values "04"       -Subtract # A Button - X position (BE -> BA, -04)
        ChangeBytes -Offset "BAF393" -Values "04"       -Subtract # A Text   - X position (BE -> BA, -04)

        ChangeBytes -Offset "BAF2E7" -Values "0E"       -Subtract # A Button Scale 1 - Y position (17 -> 09, -0E)
        ChangeBytes -Offset "BAF2EF" -Values "0E"       -Subtract # A Button Scale 2 - Y position (44 -> 36, -0E)

        ChangeBytes -Offset "C55F15" -Values "07"       -Subtract # B Button - X position (A7 -> A0, -07)
        ChangeBytes -Offset "C55F05" -Values "07 00 07" -Subtract # B Text   - X position (9B -> 94, -07)
    }

    if (IsChecked $Redux.UI.CenterTatlPrompt) {
        if ( (IsWidescreen) -or (IsWidescreen -Patched) )   {
            
            foreach ($i in 0..($GamePatch.Languages.Length-1)) {
                if (IsChecked $Redux.Language[$i]) {
                    if     ($Redux.Language[$i].label -eq "English" -and (IsChecked $Redux.Script.RenameTatl) )   { $Taya = $True  }
                    elseif ($Redux.Language[$i].label -eq "German" )                                              { $Taya = $True  }
                    elseif ($Redux.Language[$i].label -eq "French" )                                              { $Taya = $True  }
                    elseif ($Redux.Language[$i].label -eq "Spanish")                                              { $Taya = $True  }
                    elseif ($Redux.Language[$i].label -eq "Russian")                                              { $Taya = $True  }
                    else                                                                                          { $Taya = $False }
                }
            }
            if ($Taya)   { ChangeBytes -Offset "BADD28" -Values "35 CE C0 78 3C 18 00 57 37 18 40 48 24 6F 00 08 AE 0F 02 A0" }
            else         { ChangeBytes -Offset "BADD28" -Values "35 CE C0 78 3C 18 00 57 37 18 80 48 24 6F 00 08 AE 0F 02 A0" }

        }
        else { ChangeBytes -Offset "BADD28" -Values "35 CE C0 78 3C 18 00 3D 37 18 40 48 24 6F 00 08 AE 0F 02 A0" }
    }

    if (IsChecked $Redux.UI.GCScheme) {
        # Z to L textures
        PatchBytes -Offset "A7B7CC"  -Texture -Patch "GameCube\L Pause Screen Button.yaz0"
        PatchBytes -Offset "AD0A80"  -Texture -Patch "GameCube\L Text Icon.bin"
        if (IsSet $LanguagePatch.l_target) { PatchBytes -Offset "1E90D00" -Texture -Patch $LanguagePatch.l_target }
    }

    

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

    if (IsChecked $Redux.Hide.Magic) { # Magic Meter and Rupees
        ChangeBytes -Offset "BA5A28" -Values "00 00 00 00"; ChangeBytes -Offset "BA5B3C" -Values "00 00 00 00"; ChangeBytes -Offset "BA5BE8" -Values "00 00 00 00"
        ChangeBytes -Offset "BA6028" -Values "00 00 00 00"; ChangeBytes -Offset "BA6520" -Values "00 00 00 00"; ChangeBytes -Offset "BB788C" -Values "00 00 00 00"
    }

    if (IsChecked $Redux.Hide.AreaTitle) { # Disable Area Title Cards
        ChangeBytes -Offset "B80A64" -Values "10 00 01 9E"; ChangeBytes -Offset "B842C0" -Values "10 00 00 04"
    }

    if (IsChecked $Redux.Hide.Clock) { # Clock
		ChangeBytes -Offset "BAFD5C" -Values "00 00 00 00"; ChangeBytes -Offset "BAFC48" -Values "00 00 00 00"; ChangeBytes -Offset "BAFDA8" -Values "00 00 00 00"; ChangeBytes -Offset "BAFD00" -Values "00 00 00 00"
		ChangeBytes -Offset "BAFD98" -Values "00 00 00 00"; ChangeBytes -Offset "C5606D" -Values "00"
    }

    if (IsChecked $Redux.Hide.CountdownTimer) { 
        ChangeBytes -Offset "BB169A" -Values "01 FF" # Disable Countdown timer background
	    ChangeBytes -Offset "C56180" -Values "01 FF 01 FF 01 FF 01 FF 01 FF 01 FF 01 FF 01 FF" # Disable Countdown timer
    }



    # SOUNDS / SFX SOUND EFFECTS #

    if (IsChecked $Redux.Sounds.DisableSFXEffect) {
        ChangeBytes -Offset "C3560C" -Values "08  06  BE  A6  AF  BF  00  1C  3C  0E  80  1E  24  E7  B4  B0" # Disable some sfx
        ChangeBytes -Offset "C45FD8" -Values "34  09  48  02  10  89  00  0C  00  00  00  00  34  09  48  07  10  89  00  09  00  00  00  00  34  09  48  2F  10  89  00 06  00  00  00  00  00  00  00  00  00  00 ","00  00  08  06  7C  35  3C  07  80  1E  00  00  00  00  00  00  48  25  03  E0  00  08  27  BD  00  20"
    }

    if (IsIndex -Elem $Redux.Sounds.LowHP -Not)                       { ChangeBytes -Offset "B97E2A" -Values (GetSFXID $Redux.Sounds.LowHP.Text) }
    if (IsIndex -Elem $Redux.Sounds.InstrumentHylian -Not -Index 1)   { ChangeBytes -Offset "51CBE"  -Values (GetMMInstrumentID $Redux.Sounds.InstrumentHylian.Text); ChangeBytes -Offset "C668DC" -Values (GetMMInstrumentID $Redux.Sounds.InstrumentHylian.Text) }
    if (IsIndex -Elem $Redux.Sounds.InstrumentDeku   -Not -Index 2)   { ChangeBytes -Offset "51CC6"  -Values (GetMMInstrumentID $Redux.Sounds.InstrumentDeku.Text);   ChangeBytes -Offset "C668DF" -Values (GetMMInstrumentID $Redux.Sounds.InstrumentDeku.Text)   }
    if (IsIndex -Elem $Redux.Sounds.InstrumentGoron  -Not -Index 3)   { ChangeBytes -Offset "51CC4"  -Values (GetMMInstrumentID $Redux.Sounds.InstrumentGoron.Text);  ChangeBytes -Offset "C668DD" -Values (GetMMInstrumentID $Redux.Sounds.InstrumentGoron.Text)  }
    if (IsIndex -Elem $Redux.Sounds.InstrumentZora   -Not -Index 4)   { ChangeBytes -Offset "51CC5"  -Values (GetMMInstrumentID $Redux.Sounds.InstrumentZora.Text);   ChangeBytes -Offset "C668DE" -Values (GetMMInstrumentID $Redux.Sounds.InstrumentZora.Text)   }



    # FILE SELECT #

    if (IsText -Elem $Redux.FileSelect.Music -Compare "File Select" -Not) { ChangeBytes -Offset "C8E2AB" -Values (GetMMMusicID -Music $Redux.FileSelect.Music.Text) }



    # HERO MODE #

    if (IsText -Elem $Redux.Hero.Damage -Compare "OHKO Mode") {
        ChangeBytes -Offset "BABE7F" -Values "09 04" -Interval 16
        ChangeBytes -Offset "BABEA2" -Values "2A 00"
        ChangeBytes -Offset "BABEA5" -Values "00 00 00"
    }
    elseif ( (IsText -Elem $Redux.Hero.Damage -Compare "1x Damage" -Not) -or (IsText -Elem $Redux.Hero.Recovery -Compare "1x Recovery" -Not) ) {
        ChangeBytes -Offset "BABE7F" -Values "09 04" -Interval 16
        if         (IsText -Elem $Redux.Hero.Recovery -Compare "1x Recovery") {
            if     (IsText -Elem $Redux.Hero.Damage -Compare "2x Damage")   { ChangeBytes -Offset "BABEA2" -Values "28 40" }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "4x Damage")   { ChangeBytes -Offset "BABEA2" -Values "28 80" }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "8x Damage")   { ChangeBytes -Offset "BABEA2" -Values "28 C0" }
            ChangeBytes -Offset "BABEA5" -Values "00 00 00"
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Compare "1/2x Recovery") {
            if     (IsText -Elem $Redux.Hero.Damage -Compare "1x Damage")   { ChangeBytes -Offset "BABEA2" -Values "28 40" }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "2x Damage")   { ChangeBytes -Offset "BABEA2" -Values "28 80" }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "4x Damage")   { ChangeBytes -Offset "BABEA2" -Values "28 C0" }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "8x Damage")   { ChangeBytes -Offset "BABEA2" -Values "29 00" }
            ChangeBytes -Offset "BABEA5" -Values "05 28 43"
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Compare "1/4x Recovery") {
            if     (IsText -Elem $Redux.Hero.Damage -Compare "1x Damage")   { ChangeBytes -Offset "BABEA2" -Values "28 80" }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "2x Damage")   { ChangeBytes -Offset "BABEA2" -Values "28 C0" }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "4x Damage")   { ChangeBytes -Offset "BABEA2" -Values "29 00" }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "8x Damage")   { ChangeBytes -Offset "BABEA2" -Values "29 40" }
            ChangeBytes -Offset "BABEA5" -Values "05 28 83"
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Compare "0x Recovery") {
            if     (IsText -Elem $Redux.Hero.Damage -Compare "1x Damage")   { ChangeBytes -Offset "BABEA2" -Values "29 40" }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "2x Damage")   { ChangeBytes -Offset "BABEA2" -Values "29 80" }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "4x Damage")   { ChangeBytes -Offset "BABEA2" -Values "29 C0" }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "8x Damage")   { ChangeBytes -Offset "BABEA2" -Values "2A 00" }
            ChangeBytes -Offset "BABEA5" -Values "05 29 43"
        }
    }

    if     (IsText -Elem $Redux.Hero.MagicUsage -Compare "2x Magic Usage")  { ChangeBytes -Offset "BAC306" -Values "2C","40" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "3x Magic Usage")  { ChangeBytes -Offset "BAC306" -Values "2C","80" }


    # Monsters
    if (IsText -Elem $Redux.Hero.MonsterHP -Compare "2x Monster HP") {
      # ChangeBytes -Offset "" -Values "08" # Dodongo                                (HP: 04)   CF0890 -> CF3910 (Length: 3080) (ovl_En_Dodongo)
      # ChangeBytes -Offset "" -Values "08" # Tektite                      (Blue)    (HP: 04)   D0DA10 -> D11150 (Length: 3740) (ovl_En_Tite)
      # ChangeBytes -Offset "" -Values "10" # ReDead                       (Both)    (HP: 08)   D4DFF0 -> D51720 (Length: 3730) (ovl_En_Rd)
      # ChangeBytes -Offset "" -Values "04" # Stalchild                    (Small)   (HP: 02)   E07530 -> E0A810 (Length: 32E0) (ovl_En_Skb)
      # ChangeBytes -Offset "" -Values "08" # Wallmaster                             (HP: 04)   CEEA30 -> CF0890 (Length: 1E60) (ovl_En_Wallmas)
      # ChangeBytes -Offset "" -Values "08" # Floormaster                            (HP: 04)   D4A850 -> D4DFF0 (Length: 37A0) (ovl_En_Floormas)
      # ChangeBytes -Offset "" -Values "08" # Like-Like                              (HP: 04)   D73FC0 -> D76710 (Length: 002750) (ovl_En_Rr)
      # ChangeBytes -Offset "" -Values "0C" # Peehat                       (Peahat)  (HP: 06)   D11150 -> D13B80 (Length: 2A30) (ovl_En_Peehat)
      # ChangeBytes -Offset "" -Values "xx" # Peahat                       (Larva)   (HP: ??)
      # ChangeBytes -Offset "" -Values "08" # Leever                       (Green)   (HP: 04)   FE1A10 -> FE3AB0 (Length: 20A0) (ovl_En_Neo_Reeba)
      # ChangeBytes -Offset "" -Values "28" # Leever                       (Purple)  (HP: 14)
      # ChangeBytes -Offset "" -Values "10" # Wolfos                       (Both)    (HP: 08)   E03090 -> E07530 (Length: 44A0) (ovl_En_Wf)

      # ChangeBytes -Offset "" -Values "xx" # Ghost                                  (HP: ??)    ->  (Length: ) (ovl_En_??)
      # ChangeBytes -Offset "" -Values "xx" # Garo                                   (HP: ??)    ->  (Length: ) (ovl_En_??)
      # ChangeBytes -Offset "" -Values "xx" # Giant Bee                              (HP: ??)   FBF8B0 -> FC0470 (Length: 0BC0) (ovl_En_Bee)
      # ChangeBytes -Offset "" -Values "xx" # Nejiron                                (HP: ??)   EA4BD0 -> EA6030 (Length: 1460) (ovl_En_Baguo)
      # ChangeBytes -Offset "" -Values "xx" # Dragonfly                              (HP: ??)   E18FF0 -> E1BE80 (Length: 2E90) (ovl_En_Grasshopper)
      # ChangeBytes -Offset "" -Values "xx" # Black Boe                              (HP: ??)   EB79B0 -> EB9520 (Length: 1B70) (ovl_En_Mkk)
      # ChangeBytes -Offset "" -Values "xx" # White Boe                              (HP: ??)    ->  (Length: ) (ovl_En_??)
      # ChangeBytes -Offset "" -Values "xx" # Real Bombchu                           (HP: ??)   EBFC30 -> EC2280 (Length: 2650) (ovl_En_Rat)
      # ChangeBytes -Offset "" -Values "xx" # Snapper                                (HP: ??)   F3C7F0 -> F3EC60 (Length: 2470) (ovl_En_Kame)
      # ChangeBytes -Offset "" -Values "xx" # Skullfish                              (HP: ??)    ->  (Length: ) (ovl_En_??)
      # ChangeBytes -Offset "" -Values "xx" # Desbreko                               (HP: ??)   E9BD60 -> E9D650 (Length: 18F0) (ovl_En_Pr)
      # ChangeBytes -Offset "" -Values "xx" # Dexihand                               (HP: ??)   F59700 -> F5BA70 (Length: 2370) (ovl_En_Wdhand)
      # ChangeBytes -Offset "" -Values "xx" # Chuchu                                 (HP: ??)   E98900 -> E9BD60 (Length: 3460) (ovl_En_Slime)
      # ChangeBytes -Offset "" -Values "xx" # Eeno                                   (HP: ??)   F7BE00 -> F7F260 (Length: 3460) (ovl_En_Snowman)
      # ChangeBytes -Offset "" -Values "xx" # Death Armos                            (HP: ??)   D26B30 -> D28AD0 (Length: 1FA0) (ovl_En_Famos)
      # ChangeBytes -Offset "" -Values "xx" # Hiploop                                (HP: ??)   F831B0 -> F86E00 (Length: 3C50) (ovl_En_Pp)
      # ChangeBytes -Offset "" -Values "xx" # Deep Python                            (HP: ??)   FC3A10 -> FC5C50 (Length: 2240) (ovl_En_Dragon)

        # Incomplete
      # ChangeBytes -Offset "" -Values "xx" # Shell Blade                            (HP: ??)   D5E0B0 -> D5F180 (Length: 10D0) (ovl_En_Sb)
      # ChangeBytes -Offset "" -Values "04" # Blue Bubble                            (HP: 02)   D3BF30 -> D3DC40 (Length: 1D10) (ovl_En_Bb)
      # ChangeBytes -Offset "" -Values "04" # Red Bubble                             (HP: 02)   D39410 -> D3B220 (Length: 1E10) (ovl_En_Bbfall)
      # ChangeBytes -Offset "" -Values "02" # Guay                                   (HP: 01)   E0D8B0 -> E0F010 (Length: 1760) (ovl_En_Crow)
      # ChangeBytes -Offset "" -Values "02" # Keese                                  (HP: 01)   CF3910 -> CF5950 (Length: 2040) (ovl_En_Firefly)
      # ChangeBytes -Offset "" -Values "02" # Mad Scrub                              (HP: 01)   D373D0 -> D39410 (Length: 2040) (ovl_En_Dekunuts)

        # Unlocatable ?
      # ChangeBytes -Offset "" -Values "02" # Skullwalltula                (Regular) (HP: 01)   D52B10 -> D56050 (Length: 3540) (ovl_En_Sw)
      # ChangeBytes -Offset "" -Values "04" # Skullwalltula                (Gold)    (HP: 02)
      # ChangeBytes -Offset "" -Values "04" # Skulltula                              (HP: 02)   D1F260 -> D21B40 (Length: 28E0) (ovl_En_St)
      # ChangeBytes -Offset "" -Values "08" # Poe                                    (HP: 04)   F919F0 -> F94E10 (Length: 3420) (ovl_En_Poh)
      # ChangeBytes -Offset "" -Values "01" # Octorok                                (HP: 01)   CE8200 -> CEB190 (Length: 2F90) (ovl_En_Okuta)
      # ChangeBytes -Offset "" -Values "01" # Beamos                                 (HP: 01)   D46430 -> D47910 (Length: 14E0) (ovl_En_Vm)
      # ChangeBytes -Offset "" -Values "04" # Armos                                  (HP: 02)   D29EE0 -> D2B540 (Length: 1660) (ovl_En_Am)
      # ChangeBytes -Offset "" -Values "0C" # Freezard                               (HP: 06)   DA5540 -> DA7A90 (Length: 2550) (ovl_En_Fz)
    }
    elseif (IsText -Elem $Redux.Hero.MonsterHP -Compare "3x Monster HP") {
        
    }

    # Mini-Bosses
    if (IsText -Elem $Redux.Hero.MiniBossHP -Compare "2x Mini-Boss HP") {
      # ChangeBytes -Offset "" -Values "xx" # Dinolfos                               (HP: ??)   D14900  -> D18B00  (Length: 4200) (ovl_En_Dinofos)
      # ChangeBytes -Offset "" -Values "xx" # Wizzrobe                               (HP: ??)   EAEE40  -> EB2AC0  (Length: 3C80) (ovl_En_Wiz)
      # ChangeBytes -Offset "" -Values "xx" # Big Poe                                (HP: ??)   FC6760  -> FCA640  (Length: 3EE0) (ovl_En_Bigpo)
      # ChangeBytes -Offset "" -Values "xx" # Garo Master                            (HP: ??)   E20590  -> E24200  (Length: 3C70) (ovl_En_Jso)
      # ChangeBytes -Offset "" -Values "3C" # Iron Knuckle                 (Phase 1) (HP: 1E)   D9C9C0  -> D9F5E0  (Length: 2C20) (ovl_En_Ik)
      # ChangeBytes -Offset "" -Values "15" # Iron Knuckle                 (Phase 2) (HP: 0B)
      # ChangeBytes -Offset "" -Values "xx" # Eyegore                                (HP: ??)   EE43E0  -> EE8C20  (Length: 4840) (ovl_En_Egol)

      # ChangeBytes -Offset "" -Values "xx" # Takkuri                                (HP: ??)   10756F0 -> 10788A0 (Length: 31B0) (ovl_En_Thiefbird)
      # ChangeBytes -Offset "" -Values "xx" # Gekko 1                                (HP: ??)   CE4170  -> CE8200  (Length: 4090) (ovl_En_Pametfrog)
      # ChangeBytes -Offset "" -Values "xx" # Gekko 2                                (HP: ??)   E91090  -> E935F0  (Length: 2560) (ovl_En_Bigpamet)
      # ChangeBytes -Offset "" -Values "xx" # Wart                                   (HP: ??)   E57260  -> E596F0  (Length: 2490) (ovl_Boss_04)
      # ChangeBytes -Offset "" -Values "xx" # Gerudo Pirate                          (HP: ??)   FEA700  -> FF0440  (Length: 5D40) (ovl_En_Kaizoku)
      # ChangeBytes -Offset "" -Values "xx" # Captain Keeta                          (HP: ??)   105ABA0 -> 105C460 (Length: 18C0) (ovl_En_Osk)
      # ChangeBytes -Offset "" -Values "xx" # Igos du Ikana                          (HP: ??)   E24DA0  -> E31C80  (Length: CEE0) (ovl_En_Knight)
      # ChangeBytes -Offset "" -Values "xx" # King's Lackeys                         (HP: ??)   ??????  -> ??????  (Length: ????) (ovl_En_??)
      # ChangeBytes -Offset "" -Values "xx" # Gomess                                 (HP: ??)   D3F160  -> D44290  (Length: 5130) (ovl_En_Death)
      # ChangeBytes -Offset "" -Values "xx" # Poe Sisters                            (HP: ??)   F7F6B0  -> F831B0  (Length: 3B00) (ovl_En_Po_Sisters)
    }
    elseif (IsText -Elem $Redux.Hero.MiniBossHP -Compare "3x Mini-Boss HP") {
        
    }

    # Bosses
    if (IsText -Elem $Redux.Hero.BossHP -Compare "2x Boss HP") {
        ChangeBytes -Offset "E424E7" -Values "28" # Odolwa                           (HP: 14)   E41A50 -> E49F30 (Length: 84E0)  (ovl_Boss_01)
        ChangeBytes -Offset "F73D90" -Values "3C" # Goht                   (Phase 1) (HP: 1E)   F6A5A0 -> F748F0 (Length: A350)  (ovl_Boss_hakugin)
        ChangeBytes -Offset "F6BF37" -Values "28" # Goht                   (Phase 2) (HP: 14)
        ChangeBytes -Offset "E50D33" -Values "14" # Gyorg                  (Phase 1) (HP: 0A)   E50180 -> E57260 (Length: 70E0)  (ovl_Boss_03)
        ChangeBytes -Offset "E4A607" -Values "28" # Twinmold                         (HP: 14)   E49F30 -> E50180 (Length: 6250)  (ovl_Boss_04)
        ChangeBytes -Offset "E60633" -Values "1C" # Majora's Mask          (Phase 1) (HP: 0E)   E5F570 -> E74630 (Length: 150C0) (ovl_Boss_07)
        ChangeBytes -Offset "E6B20B" -Values "14" # Majora's Mask          (Summon)  (HP: 0A)
        ChangeBytes -Offset "E60743" -Values "3C" # Majora's Incarnation   (Phase 2) (HP: 1E)
        ChangeBytes -Offset "E606AB" -Values "50" # Majora's Wrath         (Phase 3) (HP: 28)
        ChangeBytes -Offset "E6FA2F" -Values "0A" # Four Remains           (Assist)  (HP: 05)

        # Unlocatable ?
      # ChangeBytes -Offset "" -Values "xx" # Odolwa's Insect Minion       (Assist)  (HP: ??)    ->  (Length: ) (ovl_En_??)
      # ChangeBytes -Offset "" -Values "14" # Goht                         (Phase 3) (HP: 0A)
      # ChangeBytes -Offset "" -Values "0C" # Gyorg                        (Phase 2) (HP: 06)
    }
    elseif (IsText -Elem $Redux.Hero.BossHP -Compare "3x Boss HP") {
        ChangeBytes -Offset "E424E7" -Values "3C" # Odolwa                           (HP: 14)   E41A50 -> E49F30 (Length: 84E0)  (ovl_Boss_01)
        ChangeBytes -Offset "F73D90" -Values "5A" # Goht                   (Phase 1) (HP: 1E)   F6A5A0 -> F748F0 (Length: A350)  (ovl_Boss_hakugin)
        ChangeBytes -Offset "F6BF37" -Values "3C" # Goht                   (Phase 2) (HP: 14)
        ChangeBytes -Offset "E50D33" -Values "1E" # Gyorg                  (Phase 1) (HP: 0A)   E50180 -> E57260 (Length: 70E0)  (ovl_Boss_03)
        ChangeBytes -Offset "E4A607" -Values "3C" # Twinmold                         (HP: 14)   E49F30 -> E50180 (Length: 6250)  (ovl_Boss_04)
        ChangeBytes -Offset "E60633" -Values "2A" # Majora's Mask          (Phase 1) (HP: 0E)   E5F570 -> E74630 (Length: 150C0) (ovl_Boss_07)
        ChangeBytes -Offset "E6B20B" -Values "1E" # Majora's Mask          (Summon)  (HP: 0A)
        ChangeBytes -Offset "E60743" -Values "5A" # Majora's Incarnation   (Phase 2) (HP: 1E)
        ChangeBytes -Offset "E606AB" -Values "78" # Majora's Wrath         (Phase 3) (HP: 28)
        ChangeBytes -Offset "E6FA2F" -Values "0F" # Four Remains           (Assist)  (HP: 05)
    }



    # REMIX #

    if (IsChecked $Redux.Hero.PalaceRoute) {
        CreateSubPath  -Path ($GameFiles.extracted + "\Deku Palace")
        ExportAndPatch -Path "Deku Palace\deku_palace_scene"  -Offset "2534000" -Length "D220"
        ExportAndPatch -Path "Deku Palace\deku_palace_room_0" -Offset "2542000" -Length "11A50"
        ExportAndPatch -Path "Deku Palace\deku_palace_room_1" -Offset "2554000" -Length "E950"  -NewLength "E9B0"  -TableOffset "1F6A7" -Values "B0"
        ExportAndPatch -Path "Deku Palace\deku_palace_room_2" -Offset "2563000" -Length "124F0" -NewLength "124B0" -TableOffset "1F6B7" -Values "B0"
    }



    # TUNIC COLORS #

    if (IsIndex -Elem $Redux.Colors.KokiriTunic -Not) {
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

    if (IsChecked $Redux.Colors.MaskForms) {
        # Deku
        PatchBytes -Offset "11A9096" -Length "1C"  -Texture -Patch "Recolor\Deku Mustard Palette.bin"

        # Goron
        PatchBytes -Offset "117C780" -Length "100" -Texture -Patch "Recolor\Goron Red Tunic.bin"
        PatchBytes -Offset "1186EB8" -Length "100" -Texture -Patch "Recolor\Goron Red Tunic.bin" 
        PatchBytes -Offset "1197120" -Length "50"  -Texture -Patch "Recolor\Zora Blue Palette.bin"

        # Zora
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

    if (IsChecked $Redux.Capacity.EnableAmmo) {
        ChangeBytes -Offset "C5834F" -IsDec -Values @($Redux.Capacity.Quiver1.Text,     $Redux.Capacity.Quiver2.Text,     $Redux.Capacity.Quiver3.Text)     -Interval 2
        ChangeBytes -Offset "C58357" -IsDec -Values @($Redux.Capacity.BombBag1.Text,    $Redux.Capacity.BombBag2.Text,    $Redux.Capacity.BombBag3.Text)    -Interval 2
        ChangeBytes -Offset "C5837F" -IsDec -Values @($Redux.Capacity.DekuSticks1.Text, $Redux.Capacity.DekuSticks1.Text, $Redux.Capacity.DekuSticks1.Text) -Interval 2
        ChangeBytes -Offset "C58387" -IsDec -Values @($Redux.Capacity.DekuNuts1.Text,   $Redux.Capacity.DekuNuts1.Text,   $Redux.Capacity.DekuNuts1.Text)   -Interval 2
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


    # SCRIPT

    if (IsChecked $Redux.Script.AutoSkip) {
        ChangeBytes -Offset "BDDC14" -Values "08 06 BE DB" # Auto skip all text
        ChangeBytes -Offset "C460AC" -Values "34 19 00 60 11 F9 00 09 00 00 00 00 34 19 00 61 11 F9 00 06 00 00 00 00 34 19 00 62 11 F9 00 03 00 00 00 00 08 05 1D C9 00 00 00 00 08 05 1D C0 00 0F C8 20"
        ChangeBytes -Offset "BEDE4C" -Values "00 00 00 00" # Auto skip text (Square)
    }

    if (IsChecked $Redux.Script.Comma) { ChangeBytes -Offset "ACC660"  -Values "00 F3 00 00 00 00 00 00 4F 60 00 00 00 00 00 00 24" }

}



#==============================================================================================================================================================================================
function ByteReduxOptions() {
    
    # D-PAD #

    if ( (IsChecked $Redux.DPad.Hide) -or (IsChecked $Redux.DPad.LayoutLeft) -or (IsChecked $Redux.DPad.LayoutRight) -or (IsWidescreen -Patched) ) {
        $Array = @()
        $Array += GetMMItemID -Item $Redux.DPad.Up.Text
        $Array += GetMMItemID -Item $Redux.DPad.Right.Text
        $Array += GetMMItemID -Item $Redux.DPad.Down.Text
        $Array += GetMMItemID -Item $Redux.DPad.Left.Text
        
        if (IsWidescreen -Patched) { $Offset = "380622C" } else { $Offset = "3806354" }
        ChangeBytes -Offset $Offset -Values $Array

        if (IsWidescreen -Patched) { $Offset = "380623C" } else { $Offset = "3806364" }
        if (IsChecked $Redux.DPad.LayoutLeft)        { ChangeBytes -Offset $Offset -Values "01 01" }
        elseif (IsChecked $Redux.DPad.LayoutRight)   { ChangeBytes -Offset $Offset -Values "01 02" }
        else                                         { ChangeBytes -Offset $Offset -Values "01" }
    }



    # GAMEPLAY #

    # Minigames; Good Dampe RNG, Good Dog Race RNG & Faster Lab Fish
    # Always:    Arrow Cycling & Underwater ocarina

    if (IsWidescreen -Patched) { $Offset = "3806408" } else { $Offset = "3806530" }
    if     ( (IsChecked $Redux.Gameplay.EasierMinigames -Not) -and (IsChecked $Redux.Gameplay.FasterBlockPushing) )   { ChangeBytes -Offset $Offset -Values "9E 45 06 2D 57 4B 28 62 49 87 69 FB 0F 79 1B 9F 18 30" }
    elseif ( (IsChecked $Redux.Gameplay.EasierMinigames) -and (IsChecked $Redux.Gameplay.FasterBlockPushing -Not) )   { ChangeBytes -Offset $Offset -Values "D2 AD 24 8F 0C 58 D0 A8 96 55 0E EE D2 2B 25 EB 08 30" }
    elseif ( (IsChecked $Redux.Gameplay.EasierMinigames) -and (IsChecked $Redux.Gameplay.FasterBlockPushing) )        { ChangeBytes -Offset $Offset -Values "B7 36 99 48 85 BF FF B1 FB EB D8 B1 06 C8 A8 3B 18 30" }



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
function ByteLanguageOptions() {
    
    if ( (IsChecked $Redux.Text.Restore) -or (IsLanguage $Redux.Gameplay.RazorSword) -or (IsChecked $Redux.UI.GCScheme) -or (IsChecked -Elem $Redux.Script.RenameTatl) -or (IsText -Elem $Redux.Colors.Fairy -Compare "Navi") -or (IsText -Elem $Redux.Colors.Fairy -Compare "Tael")  -or (IsLanguage $Redux.Capacity.EnableAmmo) -or (IsLanguage $Redux.Capacity.EnableWallet)  ) {
        if ( (IsSet $LanguagePatch.script_start) -and (IsSet $LanguagePatch.script_length) ) {
            $File = $GameFiles.extracted + "\message_data_static.bin"
            ExportBytes -Offset $LanguagePatch.script_start -Length $LanguagePatch.script_length -Output $File -Force
        }
        else  { return }
    }
    else { return }

    if (IsChecked $Redux.Text.Restore) {
        ChangeBytes -Offset "1A6D6"  -Values "AC A0"
        PatchBytes  -Offset "C5D0D8" -Patch "Message\Table Restore Text.tbl"
        ApplyPatch -File $File -Patch "\Export\Message\restore_text.bps"
        PatchBytes -Offset "A2DDC4" -Length "26F" -Texture -Patch "Icons\Troupe Leader's Mask Text.yaz0" # Correct Circus Mask
    }

    if (IsChecked $Redux.Text.OcarinaIcons) {
        PatchBytes -Offset "A3B9BC" -Length "850" -Texture -Pad -Patch "Icons\Deku Pipes Icon.yaz0"  # Slingshot, ID: 0x0B
        PatchBytes -Offset "A28AF4" -Length "1AF" -Texture -Pad -Patch "Icons\Deku Pipes Text.yaz0"
        PatchBytes -Offset "A44BFC" -Length "A69" -Texture -Pad -Patch "Icons\Goron Drums Icon.yaz0" # Blue Fire, ID: 0x1C
        PatchBytes -Offset "A28204" -Length "26F" -Texture -Pad -Patch "Icons\Goron Drums Text.yaz0"
        PatchBytes -Offset "A4AAFC" -Length "999" -Texture -Pad -Patch "Icons\Zora Guitar Icon.yaz0" # Hylian Loach, ID: 0x26
        PatchBytes -Offset "A2B2B4" -Length "230" -Texture -Pad -Patch "Icons\Zora Guitar Text.yaz0"

        # Pointer Deku Pipes icon
        ChangeBytes -Offset "A36D80" -Values "00 00 4A B0"

        # Pointer Goron Drums Text
        ChangeBytes -Offset "A27674" -Values "00 00 2B A0"
        ChangeBytes -Offset "A276D0" -Values "00 00 09 C0"
    }

    if (IsChecked $Redux.UI.GCScheme) {
        if ( (IsSet  $LanguagePatch.l_target_seach) -and (IsSet  $LanguagePatch.l_target_replace) ) {
            $Offset = "0"
            do { # Z Targeting
                $Offset = SearchBytes -File $File -Start $Offset -Values $LanguagePatch.l_target_search
                if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values $LanguagePatch.l_target_replace }
            } while ($Offset -gt 0)
        }
    }

    if (IsLanguage -Elem $Redux.Gameplay.RazorSword) {
        $Offset = SearchBytes -File $File -Values "54 68 69 73 20 6E 65 77 2C 20 73 68 61 72 70 65 72 20 62 6C 61 64 65"
        ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "38") ) ) -Values "61 73 20 6D 75 63 68 11 79 6F 75 20 77 61 6E 74 20"

        $Offset = SearchBytes -File $File -Values "54 68 65 20 4B 6F 6B 69 72 69 20 53 77 6F 72 64 20 72 65 66 6F 72 67 65 64"
        ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "30") ) ) -Values "61 73 20 6D 75 63 68 20 79 6F 75 20 77 61 6E 74 2E 20"

        $Offset = SearchBytes -File $File -Values "4B 65 65 70 20 69 6E 20 6D 69 6E 64 20 74 68 61 74"
        PatchBytes -File $File -Offset $Offset -Patch "Message\Razor Sword 1.bin"

        $Offset = SearchBytes -File $File -Values "4E 6F 77 20 6B 65 65 70 20 69 6E 20 6D 69 6E 64 20 74 68 61 74"
        PatchBytes -File $File -Offset $Offset -Patch "Message\Razor Sword 2.bin"
    }

    if ( (IsChecked $Redux.Script.RenameTatl)) {
        if (IsSet $LanguagePatch.tatl) { PatchBytes -Offset "1EBFAE0" -Texture -Patch $LanguagePatch.tatl }
        if ( (IsSet  $LanguagePatch.tatl_search) -and (IsSet  $LanguagePatch.tatl_replace) ) {
            $Offset = "0"
            do { # Tatl -> Taya
                $Offset = SearchBytes -File $File -Start $Offset -Values $LanguagePatch.tatl_search
                if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values $LanguagePatch.tatl_replace }
            } while ($Offset -gt 0)
        }
    }
    elseif (IsText -Elem $Redux.Colors.Fairy -Compare "Navi") {
        PatchBytes -Offset "1EBFAE0" -Texture -Patch "HUD\Navi.bin"
        $Offset = "0"
        do { # Tatl -> Navi
            $Offset = SearchBytes -File $File -Start $Offset -Values "54 61 74 6C"
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values "4E 61 76 69" }
        } while ($Offset -gt 0)
    }
    elseif (IsText -Elem $Redux.Colors.Fairy -Compare "Tael") {
        PatchBytes -Offset "1EBFAE0" -Texture -Patch "HUD\Tael.bin"
        $Offset = "0"
        do { # Tatl -> Tael
            $Offset = SearchBytes -File $File -Start $Offset -Values "54 61 74 6C"
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values "54 61 65 6C" }
        } while ($Offset -gt 0)
    }

    if (IsLanguage $Redux.Capacity.EnableAmmo) {
        ChangeStringIntoDigits -File $File -Search "33 30 20 61 72 72 6F 77 73 00 2E" -Value $Redux.Capacity.Quiver1.Text
        ChangeStringIntoDigits -File $File -Search "34 30 20 61 72 72 6F 77 73 00"    -Value $Redux.Capacity.Quiver2.Text
        ChangeStringIntoDigits -File $File -Search "34 30 20 61 72 72 6F 77 73 00"    -Value $Redux.Capacity.Quiver2.Text
        ChangeStringIntoDigits -File $File -Search "35 30 20 61 72 72 6F 77 73 00"    -Value $Redux.Capacity.Quiver3.Text
        ChangeStringIntoDigits -File $File -Search "35 30 20 61 72 72 6F 77 73 00"    -Value $Redux.Capacity.Quiver3.Text

        ChangeStringIntoDigits -File $File -Search "32 30 20 42 6F 6D 62 73 00 21 11" -Value $Redux.Capacity.BombBag1.Text
        ChangeStringIntoDigits -File $File -Search "32 30 20 42 6F 6D 62 73 00 2E BF" -Value $Redux.Capacity.BombBag1.Text
        ChangeStringIntoDigits -File $File -Search "33 30 20 42 6F 6D 62 73 00 2E BF" -Value $Redux.Capacity.BombBag2.Text
        ChangeStringIntoDigits -File $File -Search "33 30 20 42 6F 6D 62 73 00 2E BF" -Value $Redux.Capacity.BombBag2.Text
        ChangeStringIntoDigits -File $File -Search "34 30 20 62 6F 6D 62 73"          -Value $Redux.Capacity.BombBag3.Text
        ChangeStringIntoDigits -File $File -Search "34 30 20 42 6F 6D 62 73"          -Value $Redux.Capacity.BombBag3.Text

        ChangeStringIntoDigits -File $File -Search "31 30 2C 11 73 6F 20 75 73 65"    -Value $Redux.Capacity.DekuSticks1.Text
    }

    if (IsLanguage $Redux.Capacity.EnableWallet) {
        ChangeStringIntoDigits -File $File -Search "32 30 30 20 00 6F 66 20 74 68 65 6D" -Value $Redux.Capacity.Wallet2.Text -Triple
        ChangeStringIntoDigits -File $File -Search "35 30 30 20 52 75 70 65 65 73 00 2E" -Value $Redux.Capacity.Wallet3.Text -Triple
    }

    PatchBytes -Offset $LanguagePatch.script_start -Patch "message_data_static.bin" -Extracted

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    if ($Settings.Debug.LiteGUI -eq $False) {
        CreateOptionsDialog -Width 1060 -Height 530 -Tabs @("Main", "Audiovisual", "Difficulty", "Colors", "Equipment")
    }
    else {
        CreateOptionsDialog -Width 1060 -Height 450 -Tabs @("Main", "Audiovisual", "Difficulty")
    }

    if (!$IsWiiVC) { $Redux.Graphics.Widescreen.Add_CheckStateChanged({ AdjustGUI }) }

}



#==============================================================================================================================================================================================
function AdjustGUI() {
    
    if ($IsWiiVC -or $Settings.Debug.LiteGUI -eq $True) { return }

    EnableElem -Elem @($Redux.Colors.Magic, $Redux.Colors.BaseMagic, $Redux.Colors.DoubleMagic) -Active (!(IsWidescreen -Patched))
    EnableElem -Elem @($Redux.DPad.Disable, $Redux.DPad.Hide, $Redux.DPad.LayoutLeft, $Redux.DPad.LayoutRight) -Active (!(IsWidescreen -Patched))
    
    if (IsWidescreen -Patched) {
        EnableElem -Elem @($Redux.DPad.Up, $Redux.DPad.Left, $Redux.DPad.Right, $Redux.DPad.Down) -Active $True
        $Redux.Graphics.MotionBlur.Checked = $Redux.Graphics.FlashbackOverlay.Checked = $True
    }
    elseif ($Redux.Dpad.Disable.Checked) { EnableElem -Elem @($Redux.DPad.Up, $Redux.DPad.Left, $Redux.DPad.Right, $Redux.DPad.Down) -Active $False }

}




#==============================================================================================================================================================================================
function CreateTabMain() {

    # GAMEPLAY #
    CreateReduxGroup    -Tag  "Gameplay" -Text "Gameplay" 
    CreateReduxCheckBox -Name "ZoraPhysics"       -Text "Zora Physics"         -Info "Change the Zora physics when using the boomerang`nZora Link will take a step forward instead of staying on his spot" -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "DistantZTargeting" -Text "Distant Z-Targeting"  -Info "Allow to use Z-Targeting on enemies, objects and NPC's from any distance"                                            -Credits "Admentus"
    CreateReduxCheckBox -Name "ManualJump"        -Text "Manual Jump"          -Info "Press Z + A to do a manual jump instead of a jump attack`nPress B mid-air after jumping to do a jump attack"         -Credits "Admentus"
    CreateReduxCheckBox -Name "SwordBeamAttack"   -Text "Sword Beam Attack"    -Info "Charging the Spin Attack will launch a Sword Beam Attack instead`nYou can still execute the Quick Spin Attack"       -Credits "Admentus (ROM hack) & CloudModding (GameShark)"

    # RESTORE #
    CreateReduxGroup    -Tag  "Restore" -Text "Restore / Correct"
    CreateReduxCheckBox -Name "RupeeColors"       -Text "Correct Rupee Colors"     -Info "Corrects the colors for the Purple (50) and Golden (200) Rupees"                                           -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "CowNoseRing"       -Text "Restore Cow Nose Ring"    -Info "Restore the rings in the noses for Cows as seen in the Japanese release"                                   -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "RomaniSign"        -Text "Correct Romani Sign"      -Info "Replace the Romani Sign texture to display Romani's Ranch instead of Kakariko Village"                     -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "Title"             -Text "Restore Title"            -Info "Restore the title logo colors as seen in the Japanese release"                                             -Credits "ShadowOne333 & Garo-Mastah"
    CreateReduxCheckBox -Name "SkullKid"          -Text "Restore Skull Kid"        -Info "Restore Skull Kid's face as seen in the Japanese release"                                                  -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "ShopMusic"         -Text "Restore Shop Music"       -Info "Restores the Shop music intro theme as heard in the Japanese release"                                      -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "PieceOfHeartSound" -Text "4th Piece of Heart Sound" -Info "Restore the sound effect when collecting the fourth Piece of Heart that grants Link a new Heart Container" -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "MoveBomberKid"     -Text "Move Bomber Kid"          -Info "Moves the Bomber at the top of the Stock Pot Inn to be behind the bell like in the original Japanese ROM"  -Credits "ShadowOne333"

    # OTHER #
    CreateReduxGroup    -Tag  "Other" -Text "Other"
    CreateReduxCheckBox -Name "GohtCutscene"     -Text "Fix Goht Cutscene"         -Info "Fix Goht's awakening cutscene so that Link no longer gets run over"                                                                                         -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "MushroomBottle"   -Text "Fix Mushroom Bottle"       -Info "Fix the item reference when collecting Magical Mushrooms as Link puts away the bottle automatically due to an error"                                        -Credits "ozidual"
    CreateReduxCheckBox -Name "SouthernSwamp"    -Text "Fix Southern Swamp"        -Info "Fix a misplaced door after Woodfall has been cleared and you return to the Potion Shop`nThe door is slightly pushed forward after Odolwa has been defeated" -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "FairyFountain"    -Text "Fix Fairy Fountain"        -Info "Fix the Ikana Canyon Fairy Fountain area not displaying the correct color"                                                                                  -Credits "Dybbles (fix) & ShadowOne333 (patch)"
    CreateReduxCheckBox -Name "AlwaysBestEnding" -Text "Always Best Ending"        -Info "The credits sequence always includes the best ending, regardless of actual ingame progression"                                                              -Credits "Marcelo20XX"
    if ($Settings.Debug.LiteGUI -eq $False) {
        CreateReduxCheckBox -Name "HideCredits"  -Text "Hide Credits"              -Info "Do not show the credits text during the credits sequence"                                                                                                   -Credits "Admentus"
    }

  # CreateReduxCheckBox -Name "DebugMapSelect"   -Text "Debug Map Select"          -Info "Enable the Map Select menu like in the Debug ROM`nThe File Select menu now opens the Map Select menu instead`nA separate debug save file is used"           -Credits "Admentus"

}



#==============================================================================================================================================================================================
function CreateTabRedux() {
    
    # D-PAD ICONS LAYOUT #
    CreateReduxGroup -Tag  "DPad" -Text "D-Pad Layout" -Height 6 -Columns 4
    CreateReduxPanel -Columns 0.8 -Rows 4.1
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
    $PictureBox.Location = New-object System.Drawing.Size( ($Redux.DPad.Left.Right + 30), $Redux.DPad.Up.Bottom)
    SetBitmap -Path ($Paths.Main + "\D-Pad.png") -Box $PictureBox
    $PictureBox.Width  = $PictureBox.Image.Size.Width
    $PictureBox.Height = $PictureBox.Image.Size.Height
    $Last.Group.controls.add($PictureBox)
    
    EnableElem -Elem @($Redux.DPad.Up, $Redux.DPad.Left, $Redux.DPad.Right, $Redux.DPad.Down, $Redux.DPad.Reset) -Active (!$Redux.DPad.Disable.Checked)
    $Redux.DPad.Disable.Add_CheckedChanged({ EnableElem -Elem @($Redux.DPad.Up, $Redux.DPad.Left, $Redux.DPad.Right, $Redux.DPad.Down, $Redux.DPad.Reset) -Active (!$Redux.DPad.Disable.Checked) })
    $Redux.DPad.Reset.Add_Click({ $Redux.DPad.Up.SelectedIndex = 2; $Redux.DPad.Left.SelectedIndex = 3; $Redux.DPad.Right.SelectedIndex = 4; $Redux.DPad.Down.SelectedIndex = 1 })

    # GAMEPLAY #
    CreateReduxGroup        -Tag  "Gameplay" -Text "Gameplay"
    CreateReduxCheckBox     -Name "FasterBlockPushing" -Checked -Text "Faster Block Pushing" -Info "All blocks are pushed faster" -Credits "Ported from Redux"
    CreateReduxCheckBox     -Name "EasierMinigames"             -Text "Easier Minigames"     -Info "Certain minigames are made easier and faster`n- Dampe's Digging Game always has two Ghost Flames on the ground and one up the ladder`n- The Gold Dog always wins the Doggy Racetrack race if you have the Mask of Truth`nOnly one fish has to be feeded in the Marine Research Lab" -Credits "Ported from Rando"
    
    # BUTTON COLORS #
    CreateButtonColorOptions -Default 2
    
}



#==============================================================================================================================================================================================
function CreateTabLanguage() {
    
    CreateLanguageContent

    # ENGLISH TEXT OPTIONS #    
    $Redux.Box.Text = CreateReduxGroup -Tag "Text" -Text "English Text Options"
    CreateReduxCheckBox -Name "Restore"      -Text "Restore Text"        -Info "Restores and fixes the following:`n- Restore the area titles cards for those that do not have any`n- Sound effects that do not play during dialogue`n- Grammar and typo fixes" -Credits "Redux"
    CreateReduxCheckBox -Name "OcarinaIcons" -Text "Ocarina Icons (WIP)" -Info "Restore the Ocarina Icons with their text when transformed like in the N64 Beta or 3DS version (Work-In-Progress)`nRequires the Restore Text option"                           -Credits "ShadowOne333"
    
    # OTHER TEXT OPTIONS #    
    $Redux.Box.Text = CreateReduxGroup -Tag "Script" -Text "Other Text Options"
    CreateReduxCheckBox -Name "RenameTatl"   -Text "Rename Tatl"        -Info "Rename Tatl to Taya (English) or Taya to Tatl (German, French or Spanish)" -Credits "Admentus & GhostlyDark"
    CreateReduxCheckBox -Name "Comma"        -Text "Better Comma"       -Info "Make the comma not look as awful"                                          -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "AutoSkip"     -Text "Auto Skip Dialogue" -Info "Automaticially advance to the next line or end it during dialogues "       -Credits "Marcelo20XX" -Warning "This option is recommended for speedrunners or experienced players only"

    $Redux.Text.Restore.Add_CheckedChanged({ EnableElem -Elem $Redux.Text.OcarinaIcons -Active $this.checked })
    for ($i=0; $i -lt $GamePatch.languages.Length; $i++) {
        $Redux.Language[$i].Add_CheckedChanged({ UnlockLanguageContent })
    }
    UnlockLanguageContent

}



#==============================================================================================================================================================================================
function UnlockLanguageContent() {
    
    # English options
    EnableElem -Elem $Redux.Box.Text          -Active $Patches.Options.Checked
    EnableElem -Elem $Redux.Text.Restore      -Active $Redux.Language[0].checked
    EnableElem -Elem $Redux.Text.OcarinaIcons -Active ($Redux.Language[0].checked -and $Redux.Text.Restore.Checked)

}



#==============================================================================================================================================================================================
function CreateTabAudiovisual() {

    # GRAPHICS #
    CreateReduxGroup    -Tag  "Graphics" -Text "Graphics"

    if ($IsWiiVC) {
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
   
    CreateReduxCheckBox -Name "Widescreen"        -Text "16:9 Widescreen"           -Info $Info                                                                                                                  -Credits $Credits
    CreateReduxCheckBox -Name "BlackBars"         -Text "No Black Bars"             -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes"                    -Credits "Admentus"
    CreateReduxCheckBox -Name "ExtendedDraw"      -Text "Extended Draw Distance"    -Info "Increases the game's draw distance for objects`nDoes not work on all objects"                                         -Credits "Admentus"
    CreateReduxCheckBox -Name "ImprovedLinkModel" -Text "Improved Link Model"       -Info "Improves the model used for Hylian Link`nCustom tunic colors are not supported with this option"                      -Credits "Skilarbabcock (www.youtube.com/user/skilarbabcock) & Nerrel"
    CreateReduxCheckBox -Name "PixelatedStars"    -Text "Disable Pixelated Stars"   -Info "Completely disable the stars at night-time, which are pixelated dots and do not have any textures for HD replacement" -Credits "Admentus"
    
    if (!$IsWiiVC) {
        $info = "`n`n--- WARNING ---`nDisabling cutscene effects fixes temporary issues with both Widescreen and Redux patched where garbage pixels at the edges of the screen or garbled text appears`nWorkaround: Resize the window when that happens"
    }
    else { $info = "" }
    
    CreateReduxCheckBox -Name "MotionBlur"        -Text "Disable Motion Blur"       -Info ("Completely Disable the use of motion blur in-game" + $info)                                                          -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "FlashbackOverlay"  -Text "Disable Flashback Overlay" -Info ("Disables the overlay shown during Princess Zelda flashback scene" + $info)                                           -Credits "GhostlyDark"

    # INTERFACE #
    CreateReduxGroup    -Tag  "UI" -Text "Interface"
    CreateReduxCheckBox -Name "HudTextures"      -Text "OoT HUD Textures"     -Info "Replaces the HUD textures with those from Ocarina of Time" -Credits "Ported by GhostlyDark"
  # CreateReduxCheckBox -Name "ButtonPositions"  -Text "OoT Button Positions" -Info "Positions the A and B buttons like in Ocarina of Time"     -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "CenterTatlPrompt" -Text "Center Tatl Prompt"   -Info 'Centers the "Tatl" prompt shown in the C-Up button'        -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "GCScheme"         -Text "GC Scheme"            -Info "Replace the textures to match the GameCube's scheme"       -Credits "Admentus & GhostlyDark"


    # HIDE #
    CreateReduxGroup    -Tag  "Hide" -Text "Hide HUD"
    CreateReduxCheckBox -Name "AButton"        -Text "Hide A Button"         -Info "Hide the A Button"                                                                              -Credits "Marcelo20XX"
    CreateReduxCheckBox -Name "BButton"        -Text "Hide B Button"         -Info "Hide the B Button"                                                                              -Credits "Marcelo20XX"
    CreateReduxCheckBox -Name "CButtons"       -Text "Hide C Buttons"        -Info "Hide the C Buttons"                                                                             -Credits "Marcelo20XX"
    CreateReduxCheckBox -Name "Hearts"         -Text "Hide Hearts"           -Info "Hide the Hearts display"                                                                        -Credits "Marcelo20XX"
    CreateReduxCheckBox -Name "Magic"          -Text "Hide Magic and Rupees" -Info "Hide the Magic and Rupees display"                                                              -Credits "Marcelo20XX"
    CreateReduxCheckBox -Name "AreaTitle"      -Text "Hide Area Title Card"  -Info "Hide the area title that displays when entering a new area"                                     -Credits "Marcelo20XX"
    CreateReduxCheckBox -Name "Clock"          -Text "Hide Clock"            -Info "Hide the Clock display"                                                                         -Credits "Marcelo20XX"
    CreateReduxCheckBox -Name "CountdownTimer" -Text "Hide Countdown Timer"  -Info "Hide the countdown timer that displays during the final hours before the Moon will hit Termina" -Credits "Marcelo20XX"

    if ($Settings.Debug.LiteGUI -ne $True) {

    # SOUNDS / SFX SOUND EFFECTS
    CreateReduxGroup    -Tag  "Sounds" -Text "Sounds / SFX Sound Effects" -Height 2
    CreateReduxComboBox -Name "LowHP"             -Column 5 -Row 1 -Text "Low HP SFX" -Items @("Default", "Disabled", "Soft Beep")  -Info "Set the sound effect for the low HP beeping" -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "DisableSFXEffect"  -Column 5 -Row 2 -Text "Disable SFX Effects" -Info "Remove the SFX Sound Effects for collecting rupees and solving puzzles" -Credits "Marcelo20XX"

    $SFX =  @("Ocarina", "Deku Pipes", "Goron Drums", "Zora Guitar", "Female Voice", "Bell", "Cathedral Bell", "Piano", "Soft Harp", "Harp", "Accordion", "Bass Guitar", "Flute", "Whistling Flute", "Gong", "Elder Goron Drums", "Choir", "Arguing", "Tatl", "Giants Singing", "Ikana King", "Frog Croak", "Beaver", "Eagle Seagull", "Dodongo")
    CreateReduxComboBox -Name "InstrumentHylian"  -Column 1 -Row 1 -Text "Instrument (Hylian)" -Default 1 -Shift 30 -Length 200 -Items $SFX -Info "Replace the sound used for playing the Ocarina of Time in Hylian Form" -Credits "Ported from Rando"
    CreateReduxComboBox -Name "InstrumentDeku"    -Column 3 -Row 1 -Text "Instrument (Deku)"   -Default 2 -Shift 30 -Length 200 -Items $SFX -Info "Replace the sound used for playing the Deku Pipes in Deku Form"        -Credits "Ported from Rando"
    CreateReduxComboBox -Name "InstrumentGoron"   -Column 1 -Row 2 -Text "Instrument (Goron)"  -Default 3 -Shift 30 -Length 200 -Items $SFX -Info "Replace the sound used for playing the Goron Drums in Goron Form"      -Credits "Ported from Rando"
    CreateReduxComboBox -Name "InstrumentZora"    -Column 3 -Row 2 -Text "Instrument (Zora)"   -Default 4 -Shift 30 -Length 200 -Items $SFX -Info "Replace the sound used for playing the Zora Guitar in Zora Form"       -Credits "Ported from Rando"
    
    }

    # FILE SELECT #
    CreateReduxGroup    -Tag "FileSelect" -Text "File Select"
    $Music = @("None", "File Select", "Clock Town Day 1", "Clock Town Day 2", "Clock Town Day 3", "Clock Town Cavern", "Astral Observatory", "Milk Bar Latte", "Shop", "House", "Final Hours", "The Four Giants", "Song of Healing", "Southern Swamp", "Woods of Mystery", "Court of the Deku King", "Mountain Village", "Goron Village",
    "Great Bay Coast", "Zora Hall", "Pirate's Fortress", "Ikana Valley", "Music Box House", "Ikana Castle", "Romani Ranch" , "Woodfall Temple", "Snowhead Temple", "Great Bay Temple", "Stone Tower Temple", "Stone Tower Temple Inverted", "Battle", "Mini-Boss Battle", "Boss Battle", "Majora's Mask Battle",
    "Majora's Incarnation Battle", "Majora's Wrath Battle", "Bass Practice", "Drums Practice", "Piano Practice", "The End/Credits I", "The End/Credits II")
    CreateReduxComboBox -Name "Music" -Column 1 -Text "Music" -Shift 30 -Length 200 -Default 2 -Items $Music -Info "Set the skybox music theme for the File Select menu" -Credits "Admentus"

}



#==============================================================================================================================================================================================
function CreateTabDifficulty() {
    
    # HERO MODE #
    CreateReduxGroup    -Tag  "Hero" -Text "Hero Mode"
    CreateReduxComboBox -Name "Damage"     -Column 1 -Row 1 -Shift 10 -Text "Damage"       -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage", "OHKO Mode") -Info "Set the amount of damage you receive`nOHKO Mode = You die in one hit" -Credits "Admentus"
    CreateReduxComboBox -Name "Recovery"   -Column 3 -Row 1 -Shift 10 -Text "Recovery"     -Items @("1x Recovery", "1/2x Recovery", "1/4x Recovery", "0x Recovery")  -Info "Set the amount health you recovery from Recovery Hearts"              -Credits "Admentus"
    CreateReduxComboBox -Name "MagicUsage" -Column 5 -Row 1 -Shift 10 -Text "Magic Usage"  -Items @("1x Magic Usage", "2x Magic Usage", "3x Magic Usage")            -Info "Set the amount of times magic is consumed at"                         -Credits "Admentus"
  # CreateReduxComboBox -Name "MonsterHP"  -Column 1 -Row 2 -Shift 10 -Text "Monster HP"   -Items @("1x Monster HP", "2x Monster HP", "3x Monster HP")               -Info "Set the amount of health for monsters"                                -Credits "Admentus" -Warning "Most enemies are missing"
  # CreateReduxComboBox -Name "MiniBossHP" -Column 3 -Row 2 -Shift 10 -Text "Mini-Boss HP" -Items @("1x Mini-Boss HP", "2x Mini-Boss HP", "3x Mini-Boss HP")         -Info "Set the amount of health for elite monsters and mini-bosses"          -Credits "Admentus" -Warning "Mini-bosses are missing"
    CreateReduxComboBox -Name "BossHP"     -Column 1 -Row 2 -Shift 10 -Text "Boss HP"      -Items @("1x Boss HP", "2x Boss HP", "3x Boss HP")                        -Info "Set the amount of health for bosses"                                  -Credits "Admentus" -Warning "Goht (phases 3) and Gyorg (phase 2) are missing"
    
    if ($Settings.Debug.LiteGUI -eq $True) { return }

    CreateReduxCheckBox -Name "MasterQuest" -Column 1 -Row 3 -Text "Master Quest"         -Info "Use all areas and dungeons from the Master Quest ROM hack`nThis is for advanced players who like a higher challenge`nThe structure of the walkthrough is completely re-arranged" -Credits "Admentus (ported) & DeathBasket (ROM hack)"
    CreateReduxCheckBox -Name "PalaceRoute" -Column 2 -Row 3 -Text "Restore Palace Route" -Info "Restore the route to the Bean Seller within the Deku Palace as seen in the Japanese release" -Credits "ShadowOne"



    $Redux.Hero.Damage.Add_SelectedIndexChanged({ EnableElem -Elem $Redux.Hero.Recovery -Active ($this.Text -ne "OHKO Mode") })
    EnableElem -Elem $Redux.Hero.Recovery -Active ($Redux.Hero.Damage.Text -ne "OHKO Mode")

}



#==============================================================================================================================================================================================
function CreateTabColors() {
    
    # TUNIC COLORS #
    $Colors = @("Kokiri Green", "Goron Red", "Zora Blue", "Black", "White", "Azure Blue", "Vivid Cyan", "Light Red", "Fuchsia", "Purple", "Majora Purple", "Twitch Purple", "Persian Rose", "Dirty Yellow", "Blush Pink", "Hot Pink", "Rose Pink", "Orange", "Gray", "Gold", "Silver", "Beige", "Teal", "Blood Red", "Blood Orange", "Royal Blue", "Sonic Blue", "NES Green", "Dark Green", "Lumen", "Randomized", "Custom")
    CreateReduxGroup    -Tag  "Colors" -Text "Tunic Colors"
    CreateReduxComboBox -Name "KokiriTunic" -Column 1 -Text "Kokiri Tunic Color" -Length 230 -Shift 70 -Items $Colors -Info ("Select a color scheme for the Kokiri Tunic`n" + '"Randomized" fully randomizes the colors each time the patcher is opened') -Credits "Ported from Rando"
    $Redux.Colors.KokiriTunicButton = CreateReduxButton -Column 3 -Text "Kokiri Tunic" -Width 100  -Info "Select the color you want for the Kokiri Tunic" -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "MaskForms"   -Column 6 -Text "Recolor Mask Forms"       -Info "Recolor the clothing for the transformation mask forms`n- Deku Link as Mustard Yellow`n- Goron Link as Red`n- Zora Link as Blue" -Credits "Admentus, ShadowOne333 & Garo-Mastah"

    $Redux.Colors.KokiriTunicButton.Add_Click({ $Redux.Colors.SetKokiriTunic.ShowDialog(); $Redux.Colors.KokiriTunic.Text = "Custom"; $Redux.Colors.KokiriTunicLabel.BackColor = $Redux.Colors.SetKokiriTunic.Color; $GameSettings["Hex"][$Redux.Colors.SetKokiriTunic] = $Redux.Colors.SetKokiriTunic.Color.Name })
    $Redux.Colors.SetKokiriTunic   = CreateColorDialog -Name "SetKokiriTunic" -Color "1E691B" -IsGame
    $Redux.Colors.KokiriTunicLabel = CreateReduxColoredLabel -Link $Redux.Colors.KokiriTunicButton -Color $Redux.Colors.SetKokiriTunic.Color

    $Redux.Colors.KokiriTunic.Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.KokiriTunic -Dialog $Redux.Colors.SetKokiriTunic -Label $Redux.Colors.KokiriTunicLabel })
    SetTunicColorsPreset -ComboBox $Redux.Colors.KokiriTunic -Dialog $Redux.Colors.SetKokiriTunic -Label $Redux.Colors.KokiriTunicLabel

    $Redux.Graphics.ImprovedLinkModel.Add_CheckedChanged({ EnableElem -Elem @($Redux.Colors.KokiriTunic, $Redux.Colors.KokiriTunicButton) -Active (!$this.checked) })
    EnableElem -Elem @($Redux.Colors.KokiriTunic, $Redux.Colors.KokiriTunicButton) -Active (!$Redux.Graphics.ImprovedLinkModel.Checked)

    # SPIN ATTACK COLORS #
    CreateSpinAttackColorOptions

    # FAIRY COLORS #
    CreateFairyColorOptions -Name "Tatl" -Second "Navi" -Preset ("`n" + 'Selecting the presets "Navi" or "Tael" will also change the references for "Tatl" in the dialogue')

    # HUD COLORS #
    CreateReduxGroup    -Tag  "Colors" -Text "HUD Colors" -IsRedux -Height 2
    CreateReduxComboBox -Name "Hearts"  -Column 1 -Text "Hearts Colors"  -Length 185 -Shift 35 -Items @("Red", "Green", "Blue", "Yellow", "Randomized", "Custom") -Info ("Select a preset for the hearts colors`n" + '"Randomized" fully randomizes the colors each time the patcher is opened')
    CreateReduxComboBox -Name "Magic"   -Column 3 -Text "Magic Colors"   -Length 185 -Shift 35 -Items @("Green", "Red", "Blue", "Purple", "Pink", "Yellow", "White", "Randomized", "Custom") -Info ("Select a preset for the magic colors`n" + '"Randomized" fully randomizes the colors each time the patcher is opened')
    CreateReduxComboBox -Name "Minimap" -Column 5 -Text "Minimap Colors" -Length 185 -Shift 35 -Items @("Cyan", "Green", "Red", "Blue", "Gray", "Purple", "Pink", "Yellow", "White", "Black", "Randomized", "Custom") -Info ("Select a preset for the minimap colors`n" + '"Randomized" fully randomizes the colors each time the patcher is opened')

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
            $Redux.Colors.SetHUDStats[[int16]$this.Tag].ShowDialog(); $Redux.Colors.HUDStatsLabels[[int16]$this.Tag].BackColor = $Redux.Colors.SetHUDStats[[int16]$this.Tag].Color; $GameSettings["Hex"][$Redux.Colors.SetHUDStats[[int16]$this.Tag].Tag] = $Redux.Colors.SetHUDStats[[int16]$this.Tag].Color.Name
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
function CreateTabEquipment() {
    
    # CAPACITY SELECTION #
    CreateReduxGroup    -Tag  "Capacity" -Text "Capacity Selection" -Columns 5
    CreateReduxCheckBox -Name "EnableAmmo"    -Text "Change Ammo Capacity"   -Info "Enable changing the capacity values for ammo"
    CreateReduxCheckBox -Name "EnableWallet"  -Text "Change Wallet Capacity" -Info "Enable changing the capacity values for the wallets"

    # GAMEPLAY
    CreateReduxGroup    -Tag  "Gameplay" -Text "Gameplay"
    CreateReduxCheckBox -Name "UnsheathSword" -Text "Unsheath Sword"         -Info "The sword is unsheathed first before immediately swinging it" -Credits "Admentus"

    # AMMO #
    $Redux.Box.Ammo = CreateReduxGroup -Tag "Capacity" -Text "Ammo Capacity Selection"
    CreateReduxTextBox -Name "Quiver1"     -Text "Quiver (1)"      -Value 30  -Info "Set the capacity for the Quiver (Base)`nDefault = 30"        -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver2"     -Text "Quiver (2)"      -Value 40  -Info "Set the capacity for the Quiver (Upgrade 1)`nDefault = 40"   -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver3"     -Text "Quiver (3)"      -Value 50  -Info "Set the capacity for the Quiver (Upgrade 2)`nDefault = 50"   -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag1"    -Text "Bomb Bag (1)"    -Value 20  -Info "Set the capacity for the Bomb Bag (Base)`nDefault = 20"      -Credits "GhostlyDark" 
    CreateReduxTextBox -Name "BombBag2"    -Text "Bomb Bag (2)"    -Value 30  -Info "Set the capacity for the Bomb Bag (Upgrade 1)`nDefault = 30" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag3"    -Text "Bomb Bag (3)"    -Value 40  -Info "Set the capacity for the Bomb Bag (Upgrade 2)`nDefault = 40" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuSticks1" -Text "Deku Sticks (1)" -Value 10  -Info "Set the capacity for the Deku Sticks (Base)`nDefault = 10"   -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuNuts1"   -Text "Deku Nuts (1)"   -Value 20  -Info "Set the capacity for the Deku Nuts (Base)`nDefault = 20"     -Credits "GhostlyDark"

    # WALLET #
    $Redux.Box.Wallet = CreateReduxGroup -Tag "Capacity" -Text "Wallet Capacity Selection"
    CreateReduxTextBox -Name "Wallet1" -Length 3 -Text "Wallet (1)"     -Value 99  -Info "Set the capacity for the Wallet (Base)`nDefault = 99"       -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet2" -Length 3 -Text "Wallet (2)"     -Value 200 -Info "Set the capacity for the Wallet (Upgrade 1)`nDefault = 200" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet3" -Length 3 -Text "Wallet (3)"     -Value 500 -Info "Set the capacity for the Wallet (Upgrade 2)`nDefault = 500" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet4" -Length 3 -Text "Wallet (4)"     -Value 500 -Info "Set the capacity for the Wallet (Upgrade 3)`nDefault = 500" -Credits "GhostlyDark" -Warning "This wallet is not obtained through regular gameplay"

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