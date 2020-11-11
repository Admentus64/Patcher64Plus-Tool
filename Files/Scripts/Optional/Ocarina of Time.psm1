function PatchOptionsOcarinaOfTime() {
    
    # BPS PATCHING LANGUAGE #
    if (IsSet -Elem $LanguagePatch) { # Language
        UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Language...")
        ApplyPatch -File $GetROM.decomp -Patch $LanguagePatch
    }

    # BPS PATCHING OPTIONS #
    UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Additional BPS Patch Options...")
    PatchBPSOptionsOcarinaOfTime

    $global:ByteArrayGame = [IO.File]::ReadAllBytes($GetROM.decomp)

    # BYTE PATCHING OPTIONS #
    UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Additional General Options...")
    PatchByteOptionsOcarinaOfTime

    # BYTE PATCHING REDUX #
    if ( (IsChecked $Patches.Redux -Active) -and (IsSet -Elem $GamePatch.redux.file) ) {
        UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Additional Redux Options...")
        PatchByteReduxOcarinaOfTime
    }

    # LANGUAGE BYTE PATCHING OPTIONS #
    UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Additional Language Options...")
    PatchLanguageOptionsOcarinaOfTime

    [io.file]::WriteAllBytes($GetROM.decomp, $ByteArrayGame)

}



#==============================================================================================================================================================================================
function PatchByteOptionsOcarinaOfTime() {
    
    # HERO MODE #

    if (IsText -Elem $Options.Damage -Text "OHKO Mode") {
        ChangeBytes -Offset "AE8073" -Values @("09", "04") -Interval 16
        ChangeBytes -Offset "AE8096" -Values @("82", "00")
        ChangeBytes -Offset "AE8099" -Values @("00", "00", "00")
    }
    elseif ( (IsText -Elem $Options.Damage -Text "1x Damage" -Not) -or (IsText -Elem $Options.Recovery -Text "1x Recovery" -Not) ) {
        ChangeBytes -Offset "AE8073" -Values @("09", "04") -Interval 16
        if (IsText -Elem $Options.Recovery -Text "1x Recovery") {                
            if (IsText -Elem $Options.Damage -Text "2x Damage")       { ChangeBytes -Offset "AE8096" -Values @("80", "40") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage")   { ChangeBytes -Offset "AE8096" -Values @("80", "80") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage")   { ChangeBytes -Offset "AE8096" -Values @("80", "C0") }
            ChangeBytes -Offset "AE8099" -Values @("00", "00", "00")
        }
        elseif (IsText -Elem $Options.Recovery -Text "1/2x Recovery") {               
            if (IsText -Elem $Options.Damage -Text "1x Damage")       { ChangeBytes -Offset "AE8096" -Values @("80", "40") }
            elseif (IsText -Elem $Options.Damage -Text "2x Damage")   { ChangeBytes -Offset "AE8096" -Values @("80", "80") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage")   { ChangeBytes -Offset "AE8096" -Values @("80", "C0") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage")   { ChangeBytes -Offset "AE8096" -Values @("81", "00") }
            ChangeBytes -Offset "AE8099" -Values @("10", "80", "43")
        }
        elseif (IsText -Elem $Options.Recovery -Text "1/2x Recovery") {                
            if (IsText -Elem $Options.Damage -Text "1x Damage")       { ChangeBytes -Offset "AE8096" -Values @("80", "80") }
            elseif (IsText -Elem $Options.Damage -Text "2x Damage")   { ChangeBytes -Offset "AE8096" -Values @("80", "C0") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage")   { ChangeBytes -Offset "AE8096" -Values @("81", "00") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage")   { ChangeBytes -Offset "AE8096" -Values @("81", "40") }
            ChangeBytes -Offset "AE8099" -Values @("10", "80", "83")
        }
        elseif (IsText -Elem $Options.Recovery -Text "1/2x Recovery") {                
            if (IsText -Elem $Options.Damage -Text "1x Damage")       { ChangeBytes -Offset "AE8096" -Values @("81", "40") }
            elseif (IsText -Elem $Options.Damage -Text "2x Damage")   { ChangeBytes -Offset "AE8096" -Values @("81", "80") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage")   { ChangeBytes -Offset "AE8096" -Values @("81", "C0") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage")   { ChangeBytes -Offset "AE8096" -Values @("82", "00") }
            ChangeBytes -Offset "AE8099" -Values @("10", "81", "43")
        }
    }

    if (IsText -Elem $Options.MagicUsage -Text "2x Magic Usage")      { ChangeBytes -Offset "AE84FA" -Values @("2C","40") }
    elseif (IsText -Elem $Options.MagicUsage -Text "3x Magic Usage")  { ChangeBytes -Offset "AE84FA" -Values @("2C","80") }

    <#
    if (IsText -Elem $Options.BossHP -Text "2x Boss HP") {
        ChangeBytes -Offset "C44F2B" -Values @("14") # Gohma           0xC44C30 -> 0xC4ABB0 (Length: 0x5F80) (ovl_Boss_Goma) (HP: 0A) (Mass: FF)

        ChangeBytes -Offset "C3B9FF" -Values @("18") # King Dodongo    0xC3B150 -> 0xC44C30 (Length: 0x9AE0) (ovl_Boss_Dodongo) (HP: 0C) (Mass: 00)

        # ChangeBytes -Offset "" -Values @("08") # Barinade            0xD22360 -> 0xD30B50 (Length: 0xE7F0)(ovl_Boss_Va) (HP: 04 -> 03 -> 03) (Mass: 00)
        # ChangeBytes -Offset "" -Values @("06") # Barinade        

        ChangeBytes -Offset "C91F8F" -Values @("3C") # Phantom Ganon   0xC91AD0 -> 0xC96840  (Length: 0x4D70) (ovl_Boss_Ganondrof) (HP: 1E -> 18) (Mass: 32)

        #ChangeBytes -Offset "C91B99" -Values @("1D") # Phantom Ganon 2A
        #ChangeBytes -Offset "C91C95" -Values @("1D") # Phantom Ganon
        #ChangeBytes -Offset "C922C3" -Values @("1D") # Phantom Ganon
        #ChangeBytes -Offset "C92399" -Values @("1D") # Phantom Ganon
        #ChangeBytes -Offset "C9263F" -Values @("1D") # Phantom Ganon
        #ChangeBytes -Offset "C9266B" -Values @("1D") # Phantom Ganon
        #ChangeBytes -Offset "C92AE7" -Values @("1D") # Phantom Ganon

        #ChangeBytes -Offset "C91BE1" -Values @("1D") # Phantom Ganon
        #ChangeBytes -Offset "C91C4B" -Values @("1D") # Phantom Ganon
        #ChangeBytes -Offset "C91C91" -Values @("1D") # Phantom Ganon
        #ChangeBytes -Offset "C91CCD" -Values @("1D") # Phantom Ganon
        #ChangeBytes -Offset "C91D2D" -Values @("1D") # Phantom Ganon
        #ChangeBytes -Offset "C91D8D" -Values @("1D") # Phantom Ganon
        #ChangeBytes -Offset "C91E9B" -Values @("1D") # Phantom Ganon
        #ChangeBytes -Offset "C91F83" -Values @("1D") # Phantom Ganon
        #ChangeBytes -Offset "C9200B" -Values @("1D") # Phantom Ganon
        #ChangeBytes -Offset "C920EB" -Values @("1D") # Phantom Ganon
        #ChangeBytes -Offset "C92123" -Values @("1D") # Phantom Ganon
        #ChangeBytes -Offset "C92177" -Values @("1D") # Phantom Ganon
        #ChangeBytes -Offset "C9219F" -Values @("1D") # Phantom Ganon


        ChangeBytes -Offset "CE6D2F" -Values @("30") # Volvagia        0xCE65F0 -> 0xCED920 (Length: 0x7330) (ovl_Boss_Fd) (Has HP) (HP: 18) (Mass: 32)
                                                     # Volvagia        0xD04790 -> 0xD084C0 (Length:0x3D30) (ovl_Boss_Fd2) (Has No HP, Forwards HP to Flying)

        ChangeBytes -Offset "D3B4A7" -Values @("28") # Morpha          0xD3ADF0 -> 0xD46390 (Length: 0xB5A0) (ovl_Boss_Mo) (HP: 14) (Mass: 00)

        # ChangeBytes -Offset "" -Values @("48") # Bongo Bongo         0xDA1660 -> 0xDADB80 (Length: 0xC520) (ovl_Boss_Sst) (HP: 24) (Mass: C8)

        # ChangeBytes -Offset "" -Values @("30") # Twinrova            0xD612E0 -> 0xD74360 (Length: 0x13080) (ovl_Boss_Tw) (HP: 18) (Mass: FF)

        # ChangeBytes -Offset "D7FDA3" -Values @("50") # Ganondorf     0xD7F3F0 -> 0xDA1660 (Length: 0x22270) (ovl_Boss_Ganon) (HP: 28) (Mass: 32)

        # ChangeBytes -Offset "" -Values @("3C") # Ganon               0xE826C0 -> 0xE939B0 (Length: 0x112F0) (ovl_Boss_Ganon2) (HP: 1E) (Mass: FF)
    }
    elseif (IsText -Elem $Options.BossHP -Text "3x Boss HP") {
        ChangeBytes -Offset "C44F2B" -Values @("1E") # Gohma           0xC44C30 -> 0xC4ABB0 (Length: 0x5F80) (ovl_Boss_Goma) (HP: 0A) (Mass: FF)

        ChangeBytes -Offset "C3B9FF" -Values @("24") # King Dodongo    0xC3B150 -> 0xC44C30 (Length: 0x9AE0) (ovl_Boss_Dodongo) (HP: 0C) (Mass: 00)

        # ChangeBytes -Offset "" -Values @("0C") # Barinade            0xD22360 -> 0xD30B50 (Length: 0xE7F0)(ovl_Boss_Va) (HP: 04 -> 03 -> 03) (Mass: 00)
        # ChangeBytes -Offset "" -Values @("09") # Barinade        

        ChangeBytes -Offset "C91F8F" -Values @("5A") # Phantom Ganon   0xC91AD0 -> 0xC96840  (Length: 0x4D70) (ovl_Boss_Ganondrof) (HP: 1E -> 18) (Mass: 32)

        ChangeBytes -Offset "CE6D2F" -Values @("48") # Volvagia        0xCE65F0 -> 0xCED920 (Length: 0x7330) (ovl_Boss_Fd) (Has HP) (HP: 18) (Mass: 32)
                                                     # Volvagia        0xD04790 -> 0xD084C0 (Length:0x3D30) (ovl_Boss_Fd2) (Has No HP, Forwards HP to Flying)

        ChangeBytes -Offset "D3B4A7" -Values @("3C") # Morpha          0xD3ADF0 -> 0xD46390 (Length: 0xB5A0) (ovl_Boss_Mo) (HP: 14) (Mass: 00)

        # ChangeBytes -Offset "" -Values @("6C") # Bongo Bongo         0xDA1660 -> 0xDADB80 (Length: 0xC520) (ovl_Boss_Sst) (HP: 24) (Mass: C8)

        # ChangeBytes -Offset "" -Values @("48") # Twinrova            0xD612E0 -> 0xD74360 (Length: 0x13080) (ovl_Boss_Tw) (HP: 18) (Mass: FF)

        # ChangeBytes -Offset "D7FDA3" -Values @("78") # Ganondorf     0xD7F3F0 -> 0xDA1660 (Length: 0x22270) (ovl_Boss_Ganon) (HP: 28) (Mass: 32)

        # ChangeBytes -Offset "" -Values @("5A") # Ganon               0xE826C0 -> 0xE939B0 (Length: 0x112F0) (ovl_Boss_Ganon2) (HP: 1E) (Mass: FF)
    }
    #>

    <#
    if (IsText -Elem $Options.MonsterHP -Text "2x Monster HP") {
        ChangeBytes -Offset "BFADAB" -Values("14") # Stalfos
    }
    elseif (IsText -Elem $Options.MonsterHP -Text "3x Monster HP") {
        ChangeBytes -Offset "BFADC5" -Values("1E") # Stalfos
    }
    #>
    



    # GRAPHICS #

    if (IsChecked -Elem $Options.Widescreen) {
        # 16:9 Widescreen
        if ($IsWiiVC) { ChangeBytes -Offset "B08038" -Values @("3C", "07", "3F", "E3") }

        # 16:9 Textures
        PatchBytes -Offset "28E7FB0" -Length "3A57" -Texture -Patch "Backgrounds\Bazaar.jpeg"
        PatchBytes -Offset "2DDB160" -Length "38B8" -Texture -Patch "Backgrounds\Bombchu Shop.jpeg"
        PatchBytes -Offset "2D339D0" -Length "3934" -Texture -Patch "Backgrounds\Goron Shop.jpeg"
        PatchBytes -Offset "2CD0DA0" -Length "37CF" -Texture -Patch "Backgrounds\Gravekeeper's Hut.jpeg"
        PatchBytes -Offset "3412E40" -Length "4549" -Texture -Patch "Backgrounds\Happy Mask Shop.jpeg"
        PatchBytes -Offset "2E30EF0" -Length "4313" -Texture -Patch "Backgrounds\Impa's House.jpeg"
        PatchBytes -Offset "300CD80" -Length "43AC" -Texture -Patch "Backgrounds\Kakariko House 3.jpeg"
        PatchBytes -Offset "2C8A7C0" -Length "31C6" -Texture -Patch "Backgrounds\Kakariko House.jpeg"
        PatchBytes -Offset "2D89660" -Length "3E49" -Texture -Patch "Backgrounds\Kakariko Potion Shop.jpeg"
        PatchBytes -Offset "268D430" -Length "5849" -Texture -Patch "Backgrounds\Kokiri Know-It-All-Brothers' House.jpeg"
        PatchBytes -Offset "2592490" -Length "410F" -Texture -Patch "Backgrounds\Kokiri Shop.jpeg"
        PatchBytes -Offset "2AA90C0" -Length "5D69" -Texture -Patch "Backgrounds\Kokiri Twins' House.jpeg"
        PatchBytes -Offset "2560480" -Length "5B1E" -Texture -Patch "Backgrounds\Link's House.jpeg"
        PatchBytes -Offset "2C5DA50" -Length "4B12" -Texture -Patch "Backgrounds\Lon Lon Ranch Stables.jpeg"
        PatchBytes -Offset "2E037A0" -Length "3439" -Texture -Patch "Backgrounds\Mamamu Yan's House.jpeg"
        PatchBytes -Offset "2946120" -Length "4554" -Texture -Patch "Backgrounds\Market Back Alley 1 Day.jpeg"
        PatchBytes -Offset "2A2A110" -Length "2F31" -Texture -Patch "Backgrounds\Market Back Alley 1 Night.jpeg"
        PatchBytes -Offset "296B920" -Length "41ED" -Texture -Patch "Backgrounds\Market Back Alley 2 Day.jpeg"
        PatchBytes -Offset "2A4F910" -Length "3015" -Texture -Patch "Backgrounds\Market Back Alley 2 Night.jpeg"
        PatchBytes -Offset "2991120" -Length "4AC4" -Texture -Patch "Backgrounds\Market Back Alley 3 Day.jpeg"
        PatchBytes -Offset "2A75110" -Length "366B" -Texture -Patch "Backgrounds\Market Back Alley 3 Night.jpeg"
        PatchBytes -Offset "2718370" -Length "62CE" -Texture -Patch "Backgrounds\Market Entrance Day.jpeg"
        PatchBytes -Offset "2A02360" -Length "54CC" -Texture -Patch "Backgrounds\Market Entrance Future.jpeg"
        PatchBytes -Offset "29DB370" -Length "4144" -Texture -Patch "Backgrounds\Market Entrance Night.jpeg"
        PatchBytes -Offset "2DB1430" -Length "39DF" -Texture -Patch "Backgrounds\Market Potion Shop.jpeg"
        PatchBytes -Offset "2F7B0F0" -Length "669B" -Texture -Patch "Backgrounds\Mido's House.jpeg"
        PatchBytes -Offset "2FB60E0" -Length "5517" -Texture -Patch "Backgrounds\Saria's House.jpeg"
        PatchBytes -Offset "307EAF0" -Length "428D" -Texture -Patch "Backgrounds\Temple of Time Entrance Day.jpeg"
        PatchBytes -Offset "3142AF0" -Length "3222" -Texture -Patch "Backgrounds\Temple of Time Entrance Future.jpeg"
        PatchBytes -Offset "30EDB10" -Length "2C02" -Texture -Patch "Backgrounds\Temple of Time Entrance Night.jpeg"
        PatchBytes -Offset "30A42F0" -Length "5328" -Texture -Patch "Backgrounds\Temple of Time Path Day.jpeg"
        PatchBytes -Offset "31682F0" -Length "3860" -Texture -Patch "Backgrounds\Temple of Time Path Future.jpeg"
        PatchBytes -Offset "3113310" -Length "3BC7" -Texture -Patch "Backgrounds\Temple of Time Path Night.jpeg"
        PatchBytes -Offset "2E65EA0" -Length "49E0" -Texture -Patch "Backgrounds\Tent.jpeg"
        PatchBytes -Offset "2D5B9E0" -Length "4119" -Texture -Patch "Backgrounds\Zora Shop.jpeg"
        PatchBytes -Offset "F21810"  -Length "1000" -Texture -Patch "Lens of Truth.bin"
    }

    if (IsChecked -Elem $Options.BlackBars) {
        ChangeBytes -Offset "B0F5A4" -Values @("00", "00","00", "00")
        ChangeBytes -Offset "B0F5D4" -Values @("00", "00","00", "00")
        ChangeBytes -Offset "B0F5E4" -Values @("00", "00","00", "00")
        ChangeBytes -Offset "B0F680" -Values @("00", "00","00", "00")
        ChangeBytes -Offset "B0F688" -Values @("00", "00","00", "00")
    }

    if (IsChecked -Elem $Options.SilentNavi) {
        ChangeBytes -Offset "AE7EC6" -Values @("00", "00")
        ChangeBytes -Offset "AE7EF2" -Values @("00", "00")
        ChangeBytes -Offset "C26C7E" -Values @("00", "00")
    }

    if (IsChecked -Elem $Options.ExtendedDraw)            { ChangeBytes -Offset "A9A970" -Values @("00", "01") }
    if (IsChecked -Elem $Options.ForceHiresModel)         { ChangeBytes -Offset "BE608B" -Values @("00") }



    # INTERFACE #

    if (IsChecked -Elem $Options.HudTextures) {
        PatchBytes  -Offset "1A3CA00" -Texture -Patch "HUD\MM HUD Button.bin"
        PatchBytes  -Offset "1A3C100" -Texture -Patch "HUD\MM HUD Hearts.bin"
        PatchBytes  -Offset "1A3DE00" -Texture -Patch "HUD\MM HUD Key & Rupee.bin"
    }

    if (IsChecked -Elem $Options.ButtonPositions) {
        ChangeBytes -Offset "0B57EEF" -Values @("A7")
        ChangeBytes -Offset "0B57F03" -Values @("BE")
        ChangeBytes -Offset "0B586A7" -Values @("17")
        ChangeBytes -Offset "0B589EB" -Values @("9B")
    }

    

    # COLORS

    if (IsChecked -Elem $Options.EnableTunicColors) {
        ChangeBytes -Offset "B6DA38" -IsDec -Values @($Options.SetKokiriTunicColor.Color.R, $Options.SetKokiriTunicColor.Color.G, $Options.SetKokiriTunicColor.Color.B) # Kokiri Tunic
        ChangeBytes -Offset "B6DA3B" -IsDec -Values @($Options.SetGoronTunicColor.Color.R, $Options.SetGoronTunicColor.Color.G, $Options.SetGoronTunicColor.Color.B)    # Goron Tunic
        ChangeBytes -Offset "B6DA3E" -IsDec -Values @($Options.SetZoraTunicColor.Color.R, $Options.SetZoraTunicColor.Color.G, $Options.SetZoraTunicColor.Color.B)       # Zora Tunic
    }

    if (IsChecked -Elem $Options.EnableGauntletTunics) {
        ChangeBytes -Offset "B6DA44" -IsDec -Values @($Options.SetSilverGauntletsColor.Color.R, $Options.SetSilverGauntletsColor.Color.G, $Options.SetSilverGauntletsColor.Color.B) # Silver Gauntlets
        ChangeBytes -Offset "B6DA47" -IsDec -Values @($Options.SetGoldenGauntletsColor.Color.R, $Options.SetGoldenGauntletsColor.Color.G, $Options.SetGoldenGauntletsColor.Color.B) # Golden Gauntlets
    }

    if (IsChecked -Elem $Options.MQPauseMenuColors) {
        if (IsChecked -Elem $Patches.Redux -Active) { # Cursor
            ChangeBytes -Offset "3480859"  -Values @("C8", "00", "50")
            ChangeBytes -Offset "348085F"  -Values @("FF", "00", "50")
        }
        ChangeBytes -Offset "BC784B"  -Values @("FF", "00", "32")
        ChangeBytes -Offset "BC78AB"  -Values @("FF", "00", "32")
        ChangeBytes -Offset "BC78BD"  -Values @("FF", "00", "32")
        ChangeBytes -Offset "845755"  -Values @("FF", "64")
    }



    # GAMEPLAY

    if (IsChecked -Elem $Options.EasierMinigames) {
        ChangeBytes -Offset "CC4024" -Values @("00", "00", "00", "00") # Dampe's Digging Game

        ChangeBytes -Offset "DBF428" -Values @("0C", "10", "07", "7D", "3C", "01", "42", "82", "44", "81", "40", "00", "44", "98", "90", "00", "E6", "52") # Easier Fishing
        ChangeBytes -Offset "DBF484" -Values @("00", "00", "00", "00") # Easier Fishing
        ChangeBytes -Offset "DBF4A8" -Values @("00", "00", "00", "00") # Easier Fishing

        ChangeBytes -Offset "DCBEAB" -Values @("48")                   # Adult Fish size requirement
        ChangeBytes -Offset "DCBF27" -Values @("48")                   # Adult Fish size requirement
        ChangeBytes -Offset "DCBF33" -Values @("30")                   # Child Fish size requirement
        ChangeBytes -Offset "DCBF9F" -Values @("30")                   # Child Fish size requirement

        ChangeBytes -Offset "E2E698" -Values @("80", "AA", "E2", "64") # Fixed Bombchu Bowling item order
        ChangeBytes -Offset "E2E6A0" -Values @("80", "AA", "E2", "4C") # Fixed Bombchu Bowling item order
        ChangeBytes -Offset "E2D440" -Values @("24", "19", "00", "00") # Fixed Bombchu Bowling item order
    }

    if (IsChecked -Elem $Options.FasterBlockPushing) {
        ChangeBytes -Offset "DD2B87" -Values @("80")                   # Block Speed
        ChangeBytes -Offset "DD2D27" -Values @("03")                   # Block Delay
        ChangeBytes -Offset "DD9683" -Values @("80")                   # Milk Crate Speed
        ChangeBytes -Offset "DD981F" -Values @("03")                   # Milk Crate Delay
        ChangeBytes -Offset "CE1BD0" -Values @("40", "80", "00", "00") # Amy Puzzle Speed
        ChangeBytes -Offset "CE0F0F" -Values @("03")                   # Amy Puzzle Delay
        ChangeBytes -Offset "C77CA8" -Values @("40", "80", "00", "00") # Fire Block Speed
        ChangeBytes -Offset "C770C3" -Values @("01")                   # Fire Block Delay
        ChangeBytes -Offset "CC5DBF" -Values @("01")                   # Forest Basement Puzzle Delay
        ChangeBytes -Offset "DBCF73" -Values @("01")                   # spirit Cobra Mirror Delay
        ChangeBytes -Offset "DBA233" -Values @("19")                   # Truth Spinner Speed
        ChangeBytes -Offset "DBA3A7" -Values @("00")                   # Truth Spinner Delay
    }
    
    if (IsChecked -Elem $Options.Medallions)              { ChangeBytes -Offset "E2B454"  -Values @("80", "EA", "00", "A7", "24", "01", "00", "3F", "31", "4A", "00", "3F", "00", "00", "00", "00") }
    if (IsChecked -Elem $Options.ReturnChild)             { ChangeBytes -Offset "CB6844"  -Values @("35"); ChangeBytes -Offset "253C0E2" -Values @("03") }
    if (IsChecked -Elem $Options.FixGraves)               { ChangeBytes -Offset "202039D" -Values @("20"); ChangeBytes -Offset "202043C" -Values @("24") }
    if (IsChecked -Elem $Options.DistantZTargeting)       { ChangeBytes -Offset "A987AC"  -Values @("00", "00", "00", "00") }



    # RESTORE #

    if (IsChecked -Elem $Options.CorrectRupeeColors) {
        ChangeBytes -Offset "F47EB0" -Values @("70", "6B", "BB", "3F", "FF", "FF", "EF", "3F", "68", "AD", "C3", "FD", "E6", "BF", "CD", "7F", "48", "9B", "91", "AF", "C3", "7D", "BB", "3D", "40", "0F", "58", "19", "88", "ED", "80", "AB") # Purple
        ChangeBytes -Offset "F47ED0" -Values @("D4", "C3", "F7", "49", "FF", "FF", "F7", "E1", "DD", "03", "EF", "89", "E7", "E3", "E7", "DD", "A3", "43", "D5", "C3", "DF", "85", "E7", "45", "7A", "43", "82", "83", "B4", "43", "CC", "83") # Gold
    }

    if (IsChecked -Elem $Options.CensorBlood) {
        ChangeBytes -Offset "D8D590 " -Values @("00", "78", "00", "FF", "00", "78", "00", "FF")
        ChangeBytes -Offset "E8C424 " -Values @("00", "78", "00", "FF", "00", "78", "00", "FF")
    }

    if (IsChecked -Elem $Options.RestoreCowNoseRing)      { ChangeBytes -Offset "EF3E68" -Values @("00", "00") }



    # SOUND / VOICES #

    if (IsChecked -Elem $Options.RestoreFireTemple) {
        ChangeBytes -Offset "7465"   -Values @("03", "91", "30") # DMA Table, Pointer to AudioBank
        ChangeBytes -Offset "7471"   -Values @("03", "91", "30", "00", "08", "8B", "B0", "00", "03", "91", "30") # DMA Table, Pointer to AudioSeq
        ChangeBytes -Offset "7481"   -Values @("08", "8B", "B0", "00", "4D", "9F", "40", "00", "08", "8B", "B0") # DMA Table, Pointer to AudioTable
        ChangeBytes -Offset "B2E82F" -Values @("04", "24", "A5", "91", "30") # MIPS assembly that loads AudioSeq
        ChangeBytes -Offset "B2E857" -Values @("09", "24", "A5", "8B", "B0") # MIPS assembly that loads AudioTable
        PatchBytes  -Offset "B896A0" -Patch "Fire Temple Theme\12AudioBankPointers.bin"
        PatchBytes  -Offset "B89AD0" -Patch "Fire Temple Theme\12AudioSeqPointers.bin"
        PatchBytes  -Offset "B8A1C0" -Patch "Fire Temple Theme\12AudioTablePointers.bin"
        ExportAndPatch -Path "Audiobank Fire Temple"  -Offset "D390" -Length "4CCBB0"
    }

    if (IsText -Elem $Options.Voices -Text "Majora's Mask Link Voices") {
        if (IsChecked -Elem $Options.RestoreFireTemple)   { PatchBytes -Offset "19D920" -Patch "Voices\MM Link Voices.bin" }
        else                                              { PatchBytes -Offset "18E1E0" -Patch "Voices\MM Link Voices.bin" }
    }
    elseif (IsText -Elem $Options.Voices -Text "Feminine Link Voices") {
        if (IsChecked -Elem $Options.RestoreFireTemple)   { PatchBytes -Offset "19D920" -Patch "Voices\Feminine Link Voices.bin" }
        else                                              { PatchBytes -Offset "18E1E0" -Patch "Voices\Feminine Link Voices.bin" }
    }

    if (IsText -Elem $Options.LowHPBeep -Text "Softer Beep")     { ChangeBytes -Offset "ADBA1A"  -Values @("48", "04") }
    if (IsText -Elem $Options.LowHPBeep -Text "Beep Disabled")   { ChangeBytes -Offset "ADBA1A"  -Values @("00", "00") }


    
    # AGE RESTRICTIONS #

    if (IsChecked -Elem $Options.EnableAmmoCapacity) {
        ChangeBytes -Offset "B6EC2F" -IsDec -Values @($Options.Quiver1.Text, $Options.Quiver2.Text, $Options.Quiver3.Text) -Interval 2
        ChangeBytes -Offset "B6EC37" -IsDec -Values @($Options.BombBag1.Text, $Options.BombBag2.Text, $Options.BombBag3.Text) -Interval 2
        ChangeBytes -Offset "B6EC57" -IsDec -Values @($Options.BulletBag1.Text, $Options.BulletBag2.Text, $Options.BulletBag3.Text) -Interval 2
        ChangeBytes -Offset "B6EC5F" -IsDec -Values @($Options.DekuSticks1.Text, $Options.DekuSticks2.Text, $Options.DekuSticks3.Text) -Interval 2
        ChangeBytes -Offset "B6EC67" -IsDec -Values @($Options.DekuNuts1.Text, $Options.DekuNuts2.Text, $Options.DekuNuts3.Text) -Interval 2
    }

    if (IsChecked -Elem $Options.EnableWalletCapacity) {
        $Wallet1 = Get16Bit -Value ($Options.Wallet1.Text); $Wallet2 = Get16Bit -Value ($Options.Wallet2.Text); $Wallet3 = Get16Bit -Value ($Options.Wallet3.Text)
        ChangeBytes -Offset "B6EC4C" -Values @($Wallet1.Substring(0, 2), $Wallet1.Substring(2) )
        ChangeBytes -Offset "B6EC4E" -Values @($Wallet2.Substring(0, 2), $Wallet2.Substring(2) )
        ChangeBytes -Offset "B6EC50" -Values @($Wallet3.Substring(0, 2), $Wallet3.Substring(2) )
    }

    if (IsChecked -Elem $Options.UnlockTunics)            { ChangeBytes -Offset "BC77B6" -Values @("09", "09"); ChangeBytes -Offset "BC77FE" -Values @("09", "09") }
    if (IsChecked -Elem $Options.UnlockBoots)             { ChangeBytes -Offset "BC77BA" -Values @("09", "09"); ChangeBytes -Offset "BC7801" -Values @("09", "09") }
    if (IsChecked -Elem $Options.UnlockMegatonHammer)     { ChangeBytes -Offset "BC77A3" -Values @("09"); ChangeBytes -Offset "BC77CD" -Values @("09") }
    if (IsChecked -Elem $Options.UnlockKokiriSword)       { ChangeBytes -Offset "BC77AD" -Values @("09"); ChangeBytes -Offset "BC77F7" -Values @("09") }
    if (IsChecked -Elem $Options.UnlockFairySlingshot)    { ChangeBytes -Offset "BC779A" -Values @("09"); ChangeBytes -Offset "BC77C2" -Values @("09") }
    if (IsChecked -Elem $Options.UnlockBoomerang)         { ChangeBytes -Offset "BC77A0" -Values @("09"); ChangeBytes -Offset "BC77CA" -Values @("09") }



    # OTHER #

    if (IsChecked -Elem $Options.DebugMapSelect) {
        ChangeBytes -Offset "A94994" -Values @("00", "00", "00", "00", "AE", "08", "00", "14", "34", "84", "B9", "2C", "8E", "02", "00", "18", "24", "0B", "00", "00", "AC", "8B", "00", "00")
        ChangeBytes -Offset "B67395" -Values @("B9", "E4", "00", "00", "BA", "11", "60", "80", "80", "09", "C0", "80", "80", "37", "20", "80", "80", "1C", "14", "80", "80", "1C", "14", "80", "80", "1C", "08");
    }

    if (IsChecked -Elem $Options.SubscreenDelayFix)       { ChangeBytes -Offset "B15DD0" -Values @("00", "00", "00", "00"); ChangeBytes -Offset "B12947" -Values @("03") }
    if (IsChecked -Elem $Options.DisableNaviPrompts)      { ChangeBytes -Offset "DF8B84"  -Values @("00", "00", "00", "00") }
    if (IsChecked -Elem $Options.DefaultZTargeting)       { ChangeBytes -Offset "B71E6D" -Values @("01") }
    if (IsChecked -Elem $Options.HideCredits)             { PatchBytes  -Offset "966000" -Patch "Message\Credits.bin" }



    # CUTSCENES #

    if (IsChecked -Elem $Options.SkipIntroSequence)      { ChangeBytes -Offset "B06BBA"  -Values @("00", "00") }
    if (IsChecked -Elem $Options.SkipAllMedallions)      { ChangeBytes -Offset "ACA409"  -Values @("AD"); ChangeBytes -Offset "ACA49D"  -Values @("CE") }
    if (IsChecked -Elem $Options.SkipDaruniaDance)       { ChangeBytes -Offset "22769E4" -Values @("FF", "FF", "FF", "FF") }
    if (IsChecked -Elem $Options.SpeedupOpeningChests)   { ChangeBytes -Offset "BDA2E8"  -Values @("24", "0A", "FF", "FF") }
    if (IsChecked -Elem $Options.SpeedupKingZora)        { ChangeBytes -Offset "E56924"  -Values @("00", "00", "00", "00") }
    if (IsChecked -Elem $Options.SpeedupZeldasEscape)    { ChangeBytes -Offset "1FC0CF8" -Values @("00", "00", "00", "01", "00", "21", "00", "01", "00", "02", "00", "02") }



    # Patch Dungeons Master Quest

    PatchDungeonsMQ



    # Censor Gerudo Textures

    if (IsChecked -Elem $Options.CensorGerudoTextures) {
        
        PatchBytes -Offset "E68CE8"  -Texture -Patch "Gerudo Symbols\ganondorf_cape.bin"

        # Blocks / Switches
        PatchBytes -Offset "F70350"  -Texture -Patch "Gerudo Symbols\pushing_block.bin"
        PatchBytes -Offset "F70B50"  -Texture -Patch "Gerudo Symbols\silver_gauntlets_block.bin"
        PatchBytes -Offset "13B4000" -Texture -Patch "Gerudo Symbols\golden_gauntlets_pillar.bin"
        PatchBytes -Offset "F748A0"  -Texture -Patch "Gerudo Symbols\floor_switch.bin"
        PatchBytes -Offset "F7A8A0"  -Texture -Patch "Gerudo Symbols\rusted_floor_switch.bin"
        PatchBytes -Offset "F80CB0"  -Texture -Patch "Gerudo Symbols\crystal_switch.bin"
        
        # Mirror Shield
        PatchBytes -Offset "7FD000"  -Texture -Patch "Gerudo Symbols\mirror_shield_icon.bin"
        PatchBytes -Offset "1456388" -Texture -Patch "Gerudo Symbols\mirror_shield_reflection.bin"
        PatchBytes -Offset "1616000" -Texture -Patch "Gerudo Symbols\mirror_shield_chest.bin"

        $Offset = SearchBytes -Start "F86000" -End "FBD800" -Values @("90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90")
        PatchBytes -Offset $Offset -Texture -Patch "Gerudo Symbols\mirror_shield.bin"

        # Dungeons / Areas
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
        PatchBytes -Offset "28BBCD8" -Texture -Patch "Gerudo Symbols\gerudo_training_ground_room_5.bin"
        PatchBytes -Offset "28CA728" -Texture -Patch "Gerudo Symbols\gerudo_training_ground_room_5.bin"
        PatchBytes -Offset "11FB000" -Texture -Patch "Gerudo Symbols\gerudo_training_ground_door.bin"

        $Offset = SearchBytes -Start "2AF8000" -End "2B08F40" -Values @("00", "05", "00", "11", "06", "00", "06", "4E", "06", "06", "06", "06", "11", "11", "06", "11")
        PatchBytes -Offset $Offset -Texture -Patch "Gerudo Symbols\spirit_temple_room_0_pillars.bin"
    }

}



#==============================================================================================================================================================================================
function PatchByteReduxOcarinaOfTime() {
    
    # INTERFACE #

    if (IsChecked -Elem $Redux.ShowFileSelectIcons)       { PatchBytes  -Offset "BAF738" -Patch "File Select.bin" }
    if (IsChecked -Elem $Redux.DPadLayoutShow)            { ChangeBytes -Offset "348086E" -Values @("01") }



     # COLORS

     if (IsChecked -Elem $Redux.EnableButtonColors) {
        ChangeBytes -Offset "3480845" -IsDec -Values @($Redux.SetAButtonColor.Color.R, $Redux.SetAButtonColor.Color.G, $Redux.SetAButtonColor.Color.B) -Interval 2 # A Button
        ChangeBytes -Offset "348084B" -IsDec -Values @($Redux.SetBButtonColor.Color.R, $Redux.SetBButtonColor.Color.G, $Redux.SetBButtonColor.Color.B) -Interval 2 # B Button
        ChangeBytes -Offset "3480851" -IsDec -Values @($Redux.SetCButtonColor.Color.R, $Redux.SetCButtonColor.Color.G, $Redux.SetCButtonColor.Color.B) -Interval 2 # C Buttons
        ChangeBytes -Offset "3480863" -IsDec -Values @($Redux.SetAButtonColor.Color.R, $Redux.SetAButtonColor.Color.G, $Redux.SetAButtonColor.Color.B) -Interval 2 # A Note Button

        ChangeBytes -Offset "BB2C8E"  -IsDec -Values @($Redux.SetAButtonColor.Color.R, $Redux.SetAButtonColor.Color.G) # Pause Screen A Note Button (Red + Green)
        ChangeBytes -Offset "BB2C92"  -IsDec -Values @($Redux.SetAButtonColor.Color.B) # Pause Screen A Note Button (Blue)

        ChangeBytes -Offset "AE9EC6"  -IsDec -Values @($Redux.SetSButtonColor.Color.R, $Redux.SetSButtonColor.Color.G) # Start Button (Red + Green)
        ChangeBytes -Offset "AE9ED8"  -IsDec -Values @(53, 238, $Redux.SetSButtonColor.Color.B) # Start Button (Blue)
    }

}



#==============================================================================================================================================================================================
function PatchBPSOptionsOcarinaOfTime() {
    
    if ( (IsText -Elem $Options.Models -Text "Replace Child Model Only") -or (IsText -Elem $Options.Models -Text "Replace Both Models") ) {
        ApplyPatch -File $GetROM.decomp -Patch "\Decompressed\Models\child_model.ppf"
    }
    if ( (IsText -Elem $Options.Models -Text "Replace Adult Model Only") -or (IsText -Elem $Options.Models -Text "Replace Both Models")) {
        ApplyPatch -File $GetROM.decomp -Patch "\Decompressed\Models\adult_model.ppf"
    }
    if (IsText -Elem $Options.Models -Text "Change to Female Models") {
        ApplyPatch -File $GetROM.decomp -Patch "\Decompressed\Models\female_models.ppf"
    }

    if (IsChecked -Elem $Languages.PauseScreen) { ApplyPatch -File $GetROM.decomp -Patch "\Decompressed\mm_pause_screen.ppf" }
    
}



#==============================================================================================================================================================================================
function PatchLanguageOptionsOcarinaOfTime() {
    
    if ( (IsChecked -Elem $Languages.TextRestore) -or (IsChecked -Elem $Languages.TextSpeed2x) -or (IsChecked -Elem $Languages.TextSpeed3x) -or (IsChecked -Elem $Languages.TextDialogueColors) -or (IsLanguage -Elem $Options.UnlockTunics) ) {
        $File = $GameFiles.extracted + "\Message Data Static.bin"
        ExportBytes -Offset "92D000" -Length "38140" -Output $File -Force
    }

    if (IsChecked -Elem $Languages.TextRestore) {
        if (!(IsChecked -Elem $Languages.FemalePronouns)) {
            ChangeBytes -Offset "7596" -Values @("52", "40")
            PatchBytes  -Offset "B849EC" -Patch "Message\Table Restore.bin"
        }

        if (IsChecked -Elem $Patches.Redux -Active)   { ApplyPatch -File $File -Patch "\Data Extraction\Message\Message Data Static OoT Redux.bps" -FilesPath }
        else                                          { ApplyPatch -File $File -Patch "\Data Extraction\Message\Message Data Static OoT.bps"       -FilesPath }

        if (IsChecked -Elem $Languages.TextFemalePronouns) {
            ChangeBytes -Offset "7596" -Values @("52", "E0")
            PatchBytes  -Offset "B849EC" -Patch "Message\Table Girl.bin"
            ApplyPatch -File $File -Patch "\Data Extraction\Message\Message Data Static Girl.bps" -FilesPath
        }

    }

    if (IsChecked -Elem $Languages.TextSpeed2x) {
        ChangeBytes -Offset "B5006F" -Values @("02") # Text Speed

        if ($Languages[0].checked) {
            # Correct Ruto Confession Textboxes
            $Offset = SearchBytes -File $File -Values @("1A", "41", "73", "20", "61", "20", "72", "65", "77", "61", "72", "64", "2E", "2E", "2E", "01")
            PatchBytes -File $File -Offset $Offset -Patch "Message\Ruto Confession.bin"

            # Correct Phantom Ganon Defeat Textboxes
            $Offset = SearchBytes -File $File -Values @("0C", "3C", "42", "75", "74", "20", "79", "6F", "75", "20", "68", "61", "76", "65", "20", "64")
            ChangeBytes -File $File -Offset ( Get24Bit -Value ( (GetDecimal -Hex $Offset) + (GetDecimal -Hex "1") ) ) -Values @("66")
            ChangeBytes -File $File -Offset ( Get24Bit -Value ( (GetDecimal -Hex $Offset) + (GetDecimal -Hex "5D") ) ) -Values @("66")
            ChangeBytes -File $File -Offset ( Get24Bit -Value ( (GetDecimal -Hex $Offset) + (GetDecimal -Hex "BA") ) ) -Values @("60")
        }
    }
    elseif (IsChecked -Elem $Languages.TextSpeed3x) {
        ChangeBytes -Offset "B5006F" -Values @("03") # Text Speed

        # Correct Learning Song Textboxes
        $Offset = SearchBytes -File $File -Values @("08", "06", "3C", "50", "6C", "61", "79", "20", "75", "73", "69", "6E", "67", "20", "05")
        PatchBytes -File $File -Offset $Offset -Patch "Message\Songs.bin"

        # Correct Ruto Confession Textboxes
        $Offset = SearchBytes -File $File -Values @("1A", "41", "73", "20", "61", "20", "72", "65", "77", "61", "72", "64", "2E", "2E", "2E", "01")
        PatchBytes -File $File -Offset $Offset -Patch "Message\Ruto Confession.bin"
        
        # Correct Phantom Ganon Defeat Textboxes
        $Offset = SearchBytes -File $File -Values @("0C", "3C", "42", "75", "74", "20", "79", "6F", "75", "20", "68", "61", "76", "65", "20", "64")
        ChangeBytes -File $File -Offset ( Get24Bit -Value ( (GetDecimal -Hex $Offset) + (GetDecimal -Hex "1") ) ) -Values @("76")
        ChangeBytes -File $File -Offset ( Get24Bit -Value ( (GetDecimal -Hex $Offset) + (GetDecimal -Hex "5D") ) ) -Values @("76")
        ChangeBytes -File $File -Offset ( Get24Bit -Value ( (GetDecimal -Hex $Offset) + (GetDecimal -Hex "BA") ) ) -Values @("70")
    }
        
    if (IsChecked -Elem $Languages.TextDialogueColors) {
        $Offset = SearchBytes -File $File -Values @("62", "6C", "75", "65", "20", "69", "63", "6F", "6E", "05", "40", "02", "00", "00", "54", "68")
        ChangeBytes -File $File -Offset $Offset -Values @("67", "72", "65", "65", "6E", "20", "69", "63", "6F", "6E", "05", "40", "02")
            
        $Offset = SearchBytes -File $File -Values @("1A", "05", "44", "59", "6F", "75", "20", "63", "61", "6E", "20", "6F", "70", "65", "6E", "20")
        PatchBytes  -File $File -Offset $Offset -Patch "Message\MQ Navi Door.bin"
            
        $Offset = SearchBytes -File $File -Values @("62", "6C", "75", "65", "20", "69", "63", "6F", "6E", "20", "61", "74", "20", "74", "68", "65")
        PatchBytes  -File $File -Offset $Offset -Patch "Message\MQ Navi Action.bin"

        $Offset = "0"
        do { # A button
            $Offset = SearchBytes -File $File -Start $Offset -Values @("05", "43", "9F", "05")
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values @("05", "42") }
        } while ($Offset -gt 0)

        $Offset = "0"
        do { # A button
            $Offset = SearchBytes -File $File -Start $Offset -Values @("05", "43", "9F", "", "05", "40")
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values @("05", "42") }
        } while ($Offset -gt 0)

        $Offset = "0"
        do { # A button
            $Offset = SearchBytes -File $File -Start $Offset -Values @("05", "43", "20", "9F", "05", "44")
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values @("05", "42") }
        } while ($Offset -gt 0)

        $Offset = "0"
        do { # A button
            $Offset = SearchBytes -File $File -Start $Offset -Values @("05", "43", "41", "63", "74", "69", "6F", "6E")
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values @("05", "42") }
        } while ($Offset -gt 0)

        $Offset = "0"
        do { # B button
            $Offset = SearchBytes -File $File -Start $Offset -Values @("05", "42", "A0", "05", "40")
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values @("05", "41") }
        } while ($Offset -gt 0)

        $Offset = "0"
        do { # B button
            $Offset = SearchBytes -File $File -Start $Offset -Values @("05", "42", "A0", "20", "05", "40")
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values @("05", "41") }
        } while ($Offset -gt 0)

        $Offset = "0"
        do { # Start button
            $Offset = SearchBytes -File $File -Start $Offset -Values @("05", "41", "53", "54", "41", "52", "54", "05", "40")
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values @("05", "44") }
        } while ($Offset -gt 0)

        $Offset = "0"
        do { # Start button
            $Offset = SearchBytes -File $File -Start $Offset -Values @("05", "41", "53", "54", "41", "52", "54", "20", "05", "40")
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values @("05", "44") }
        } while ($Offset -gt 0)
    }

    if (IsLanguage -Elem $Options.UnlockTunics) {
        $Offset = SearchBytes -File $File -Values @("59", "6F", "75", "20", "67", "6F", "74", "20", "61", "20", "05", "41", "47", "6F", "72", "6F", "6E", "20", "54", "75", "6E", "69", "63")
        ChangeBytes -File $File -Offset ( Get24Bit -Value ( (GetDecimal -Hex $Offset) + (GetDecimal -Hex "39") ) ) -Values @("75", "6E", "69", "73", "69", "7A", "65", "2C", "20", "73", "6F", "20", "69", "74", "20", "66", "69", "74", "73", "20", "61", "64", "75", "6C", "74", "20", "61", "6E", "64")
        ChangeBytes -File $File -Offset ( Get24Bit -Value ( (GetDecimal -Hex $Offset) + (GetDecimal -Hex "B3") ) ) -Values @("75", "6E", "69", "73", "69", "7A", "65", "2C", "01", "73", "6F", "20", "69", "74", "20", "66", "69", "74", "73", "20", "61", "64", "75", "6C", "74", "20", "61", "6E", "64")

        $Offset = SearchBytes -File $File -Values @("41", "20", "74", "75", "6E", "69", "63", "20", "6D", "61", "64", "65", "20", "62", "79", "20", "47", "6F", "72", "6F", "6E", "73")
        ChangeBytes -File $File -Offset ( Get24Bit -Value ( (GetDecimal -Hex $Offset) + (GetDecimal -Hex "18") ) ) -Values @("55", "6E", "69", "2D", "20")
        ChangeBytes -File $File -Offset ( Get24Bit -Value ( (GetDecimal -Hex $Offset) + (GetDecimal -Hex "7A") ) ) -Values @("55", "6E", "69", "73", "69", "7A", "65", "2E", "20", "20", "20")
    }

    if ( (IsChecked -Elem $Languages.TextRestore) -or (IsChecked -Elem $Languages.TextSpeed2x) -or (IsChecked -Elem $Languages.TextSpeed3x) -or (IsChecked -Elem $Languages.TextDialogueColors) -or (IsLanguage -Elem $Options.UnlockTunics) ) {
        PatchBytes -Offset "92D000" -Patch "Message Data Static.bin" -Extracted
    }

}



#==============================================================================================================================================================================================
function CreateOcarinaOfTimeOptionsContent() {
    
    CreateOptionsDialog -Width 1050 -Height 650
    $ToolTip = CreateTooltip



    # HERO MODE #
    $HeroModeBox                       = CreateReduxGroup -Y 50 -Height 2 -AddTo $Options.Panel -Text "Hero Mode"

    $Options.Damage                    = CreateReduxComboBox -Column 0 -Row 1 -AddTo $HeroModeBox -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage", "OHKO Mode") -Text "Damage:" -ToolTip $ToolTip -Info "Set the amount of damage you receive`nOHKO Mode = You die in one hit" -Name "Damage"
    $Options.Recovery                  = CreateReduxComboBox -Column 2 -Row 1 -AddTo $HeroModeBox -Items @("1x Recovery", "1/2x Recovery", "1/4x Recovery", "0x Recovery") -Text "Recovery:" -ToolTip $ToolTip -Info "Set the amount health you recovery from Recovery Hearts" -Name "Recovery"
    
    $Options.MagicUsage                = CreateReduxComboBox -Column 4 -Row 1 -AddTo $HeroModeBox -Items @("1x Magic Usage", "2x Magic Usage", "3x Magic Usage") -Text "Magic Usage:" -ToolTip $ToolTip -Info "Set the amount of times magic is consumed at" -Name "MagicUsage"
    #$Options.BossHP                   = CreateReduxComboBox -Column 0 -Row 2 -AddTo $HeroModeBox -Items @("1x Boss HP", "2x Boss HP", "3x Boss HP")          -Text "Boss HP:"    -ToolTip $ToolTip -Info "Set the amount of health for bosses"   -Name "BossHP"
    #$Options.MonsterHP                = CreateReduxComboBox -Column 2 -Row 2 -AddTo $HeroModeBox -Items @("1x Monster HP", "2x Monster HP", "3x Monster HP") -Text "Monster HP:" -ToolTip $ToolTip -Info "Set the amount of health for monsters" -Name "MonsterHP"
    $Options.SelectMQDungeons          = CreateReduxButton   -Column 0 -Row 2 -AddTo $HeroModeBox -Text "Set Master Quest" -ToolTip $ToolTip -Info "Select the dungeons you want from Master Quest to patch into Ocarina of Time"
    $Options.SelectMQDungeons.Add_Click( { $Options.MasterQuestDungeonsDialog.ShowDialog() } )


    # GRAPHICS / Sound #
    $GraphicsBox                       = CreateReduxGroup -Y ($HeroModeBox.Bottom + 5) -Height 2 -AddTo $Options.Panel -Text "Graphics / Sound"
    
    $Options.Widescreen                = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $GraphicsBox -Text "16:9 Widescreen"        -ToolTip $ToolTip -Info "Native 16:9 Widescreen Display support with backgrounds and textures adjusted for widescreen`nThe aspect ratio fix is only applied when patching in Wii VC mode`nUse the Widescreen hack by GlideN64 instead if running on an N64 emulator`nTexture changes are always applied" -Name "Widescreen"
    $Options.BlackBars                 = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $GraphicsBox -Text "No Black Bars"          -ToolTip $ToolTip -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes" -Name "BlackBars"
    $Options.ExtendedDraw              = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $GraphicsBox -Text "Extended Draw Distance" -ToolTip $ToolTip -Info "Increases the game's draw distance for objects`nDoes not work on all objects" -Name "ExtendedDraw"
    $Options.ForceHiresModel           = CreateReduxCheckBox -Column 3 -Row 1 -AddTo $GraphicsBox -Text "Force Hires Link Model" -ToolTip $ToolTip -Info "Always use Link's High Resolution Model when Link is too far away" -Name "ForceHiresModel"
    $Options.SilentNavi                = CreateReduxCheckBox -Column 4 -Row 1 -AddTo $GraphicsBox -Text "Silent Navi"            -ToolTip $ToolTip -Info "Navi will stay silent when calling for Link's attention" -Name "SilentNavi"


    $Options.Models                    = CreateReduxComboBox -Column 0 -Row 2 -AddTo $GraphicsBox -Items @("No Model Replacements", "Replace Child Model Only", "Replace Adult Model Only", "Replace Both Models", "Change to Female Models") -Text "Link's Models:" -ToolTip $ToolTip -Info "1. Replace the model for Child Link with that of Majora's Mask`n2. Replace the model for Adult Link to be Majora's Mask-styled`n3. Combine both previous options`n4. Transform Link into a female" -Name "Models"
    $Options.Voices                    = CreateReduxComboBox -Column 2 -Row 2 -AddTo $GraphicsBox -Items @("No Voice Changes", "Majora's Mask Link Voices", "Feminine Link Voices") -Text "Voice:" -ToolTip $ToolTip -Info "1. Replace the voices for Link with those used in Majora's Mask`n2. Replace the voices for Link to sound feminine" -Name "Voices"
    $Options.LowHPBeep                 = CreateReduxComboBox -Column 4 -Row 2 -AddTo $GraphicsBox -Items @("Default Beep", "Softer Beep", "Beep Disabled") -Text "Low HP Beep:" -ToolTip $ToolTip -Info "Set the sound effect for the low HP beeping" -Name "LowHPBeep" -Length 100



    # INTERFACE #
    $InterfaceBox                      = CreateReduxGroup -Y ($GraphicsBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Interface"

    $Options.HudTextures               = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $InterfaceBox -Text "MM HUD Textures"                 -ToolTip $ToolTip -Info "Replaces the HUD textures with those from Majora's Mask" -Name "HudTextures"
    $Options.ButtonPositions           = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $InterfaceBox -Text "MM Button Positions"             -ToolTip $ToolTip -Info "Positions the A and B buttons like in Majora's Mask" -Name "ButtonPositions"
    


    # COLORS #
    $ColorsBox                         = CreateReduxGroup -Y ($InterfaceBox.Bottom + 5) -Height 2 -AddTo $Options.Panel -Text "Colors"

    $Options.EnableTunicColors         = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $ColorsBox -Text "Change Tunic Colors"        -ToolTip $ToolTip -Info "Enable changing the color for all three tunics" -Name "EnableTunicColors"
    $Options.EnableGauntletColors      = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $ColorsBox -Text "Change Gauntlet Colors"     -ToolTip $ToolTip -Info "Enable changing the color for the Silver and Golden Gauntlets" -Name "EnableGauntletColors"
    $Options.ResetAllColors            = CreateReduxButton   -Column 2 -Row 1 -AddTo $ColorsBox -Text "Reset All Colors"           -ToolTip $ToolTip -Info "Reset all colors to their default values"

    $Options.KokiriTunicColor          = CreateReduxButton   -Column 0 -Row 2 -AddTo $ColorsBox -Text "Set Kokiri Tunic Color"     -ToolTip $ToolTip -Info "Select the color you want for the Kokiri Tunic"
    $Options.GoronTunicColor           = CreateReduxButton   -Column 1 -Row 2 -AddTo $ColorsBox -Text "Set Goron Tunic Color"      -ToolTip $ToolTip -Info "Select the color you want for the Goron Tunic"
    $Options.ZoraTunicColor            = CreateReduxButton   -Column 2 -Row 2 -AddTo $ColorsBox -Text "Set Zora Tunic Color"       -ToolTip $ToolTip -Info "Select the color you want for the Zora Tunic"

    $Options.SilverGauntletsColor      = CreateReduxButton   -Column 3 -Row 2 -AddTo $ColorsBox -Text "Set Silver Gaunlets Color"  -ToolTip $ToolTip -Info "Select the color you want for the Silver Gauntlets"
    $Options.GoldenGauntletsColor      = CreateReduxButton   -Column 4 -Row 2 -AddTo $ColorsBox -Text "Set Golden Gauntlets Color" -ToolTip $ToolTip -Info "Select the color you want for the Golden Gauntlets"

    

    $Options.KokiriTunicColor.Add_Click(     { $Options.SetKokiriTunicColor.ShowDialog();     $Settings[$GameType.mode][$Options.SetKokiriTunicColor.Tag] = $Options.SetKokiriTunicColor.Color.Name } )
    $Options.GoronTunicColor.Add_Click(      { $Options.SetGoronTunicColor.ShowDialog();      $Settings[$GameType.mode][$Options.SetGoronTunicColor.Tag]  = $Options.SetGoronTunicColor.Color.Name } )
    $Options.ZoraTunicColor.Add_Click(       { $Options.SetZoraTunicColor.ShowDialog();       $Settings[$GameType.mode][$Options.SetZoraTunicColor.Tag]   = $Options.SetZoraTunicColor.Color.Name } )

    $Options.SilverGauntletsColor.Add_Click( { $Options.SetSilverGauntletsColor.ShowDialog(); $Settings[$GameType.mode][$Options.SetSilverGauntletsColor.Tag] = $Options.SetSilverGauntletsColor.Color.Name } )
    $Options.GoldenGauntletsColor.Add_Click( { $Options.SetGoldenGauntletsColor.ShowDialog(); $Settings[$GameType.mode][$Options.SetGoldenGauntletsColor.Tag] = $Options.SetGoldenGauntletsColor.Color.Name } )

    $Options.ResetAllColors.Add_Click( {
        SetButtonColors -A "5A5AFF" -B "009600" -C "FFA000" -Start "C80000"
        $Options.SetKokiriTunicColor.Color     = "#1E691B"; $Settings[$GameType.mode][$Options.SetKokiriTunicColor.Tag]     = $Options.SetKokiriTunicColor.Color.Name
        $Options.SetGoronTunicColor.Color      = "#641400"; $Settings[$GameType.mode][$Options.SetGoronTunicColor.Tag]      = $Options.SetGoronTunicColor.Color.Name
        $Options.SetZoraTunicColor.Color       = "#003C64"; $Settings[$GameType.mode][$Options.SetZoraTunicColor.Tag]       = $Options.SetZoraTunicColor.Color.Name
        $Options.SetSilverGauntletsColor.Color = "#FFFFFF"; $Settings[$GameType.mode][$Options.SetSilverGauntletsColor.Tag] = $Options.SetSilverGauntletsColor.Color.Name
        $Options.SetGoldenGauntletsColor.Color = "#FECF0F"; $Settings[$GameType.mode][$Options.SetGoldenGauntletsColor.Tag] = $Options.SetGoldenGauntletsColor.Color.Name
    } )



    # GAMEPLAY #
    $GameplayBox                       = CreateReduxGroup -Y ($ColorsBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Gameplay"

    $Options.FasterBlockPushing        = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $GameplayBox -Checked -Text "Faster Block Pushing"   -ToolTip $ToolTip -Info "All blocks are pushed faster" -Name "FasterBlockPushing"
    $Options.EasierMinigames           = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $GameplayBox          -Text "Easier Minigames"       -ToolTip $ToolTip -Info "Certain minigames are made easier and faster`n- Dampe's Digging Game is first try always`n- Fishing is less random and has less demanding requirements`n-Bombchu Bowling prizes now appear in fixed order instead of random" -Name "EasierMinigames"
    $Options.ReturnChild               = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $GameplayBox          -Text "Can Always Return"      -ToolTip $ToolTip -Info "You can always go back to being a child again before clearing the boss of the Forest Temple`nOut of the way Sheik!" -Name "ReturnChild"
    $Options.Medallions                = CreateReduxCheckBox -Column 3 -Row 1 -AddTo $GameplayBox          -Text "Require All Medallions" -ToolTip $ToolTip -Info "All six medallions are required for the Rainbow Bridge to appear before Ganon's Castle`nThe vanilla requirements were the Shadow and Spirit Medallions and the Light Arrows" -Name "Medallions"
    $Options.FixGraves                 = CreateReduxCheckBox -Column 4 -Row 1 -AddTo $GameplayBox          -Text "Fix Graves"             -ToolTip $ToolTip -Info "The grave holes in Kakariko Graveyard behave as in the Rev 1 revision`nThe edges no longer force Link to grab or jump over them when trying to enter" -Name "FixGraves"
    $Options.DistantZTargeting         = CreateReduxCheckBox -Column 5 -Row 1 -AddTo $GameplayBox          -Text "Distant Z-Targeting"    -ToolTip $ToolTip -Info "Allow to use Z-Targeting on enemies, objects and NPC's from any distance" -Name "DistantZTargeting"



    # RESTORE #
    $RestoreBox                        = CreateReduxGroup -Y ($GameplayBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Restore / Correct / Censor"

    $Options.CorrectRupeeColors        = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $RestoreBox -Text "Correct Rupee Colors"   -ToolTip $ToolTip -Info "Corrects the colors for the Purple (50) and Golden (200) Rupees" -Name "CorrectRupeeColors"
    $Options.RestoreCowNoseRing        = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $RestoreBox -Text "Restore Cow Nose Ring"  -ToolTip $ToolTip -Info "Restore the rings in the noses for Cows as seen in the Japanese release" -Name "RestoreCowNoseRing"
    $Options.RestoreFireTemple         = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $RestoreBox -Text "Restore Fire Temple"    -ToolTip $ToolTip -Info "Restore the censored Fire Temple theme used since the Rev 2 ROM" -Name "RestoreFireTemple"
    $Options.CensorBlood               = CreateReduxCheckBox -Column 3 -Row 1 -AddTo $RestoreBox -Text "Censor Blood"           -ToolTip $ToolTip -Info "Restore the censored green blood for Ganondorf and Ganon used since the Rev 2 ROM" -Name "CensorBlood"
    $Options.CensorGerudoTextures      = CreateReduxCheckBox -Column 4 -Row 1 -AddTo $RestoreBox -Text "Censor Gerudo Textures" -ToolTip $ToolTip -Info "Restore the censored Gerudo symbol textures used in the GameCube / Virtual Console releases`n- Disable the option to uncensor the Gerudo Texture used in the Master Quest dungeons" -Name "CensorGerudoTextures"
    


    # EVERYTHING ELSE #
    $OtherBox                          = CreateReduxGroup -Y ($RestoreBox.Bottom + 5) -Height 2 -AddTo $Options.Panel -Text "Other"
    
    $Options.SubscreenDelayFix         = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $OtherBox -Text "Pause Screen Delay Fix"   -ToolTip $ToolTip -Info "Removes the delay when opening the Pause Screen" -Name "SubscreenDelayFix"
    $Options.DisableNaviPrompts        = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $OtherBox -Text "Remove Navi Prompts"      -ToolTip $ToolTip -Info "Navi will no longer interupt your during the first dungeon with mandatory textboxes" -Name "DisableNaviPrompts"
    $Options.DefaultZTargeting         = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $OtherBox -Text "Default Hold Z-Targeting" -ToolTip $ToolTip -Info "Change the Default Z-Targeting option to Hold instead of Switch" -Name "DefaultZTargeting"
    $Options.HideCredits               = CreateReduxCheckBox -Column 3 -Row 1 -AddTo $OtherBox -Text "Hide Credits"             -ToolTip $ToolTip -Info "Do not show the credits text during the credits sequence" -Name "HideCredits"
    $Options.DebugMapSelect            = CreateReduxCheckBox -Column 4 -Row 1 -AddTo $OtherBox -Text "Debug Map Select"         -ToolTip $ToolTip -Info "Enable the Map Select menu like in the Debug ROM`nThe File Select menu now opens the Map Select menu instead`nA separate debug save file is used" -Name "DebugMapSelect"

    $Options.UnlockAgeRestrictions     = CreateReduxButton   -Column 0 -Row 2 -AddTo $OtherBox -Text "Unlock Age Restrictions"  -ToolTip $OptionsToolTip -Info "Select the items and equipment you want unlocked for Child and Adult Link"
    $Options.UnlockAgeRestrictions.Add_Click( { $Options.UnlockAgeRestrictionsDialog.ShowDialog() } )

    $Options.Capacity                  = CreateReduxButton   -Column 1 -Row 2 -AddTo $OtherBox -Text "Set Capacity"             -ToolTip $OptionsToolTip -Info "Select the capacity values you want for ammo and wallets"
    $Options.Capacity.Add_Click( { $Options.CapacityDialog.ShowDialog() } )

    $Options.Cutscenes                 = CreateReduxButton   -Column 2 -Row 2 -AddTo $OtherBox -Text "Cutscenes"                -ToolTip $ToolTip -Info "Select cutscenes which are sped up or skipped"
    $Options.Cutscenes.Add_Click( { $Options.CutscenesDialog.ShowDialog() } )



    CreateMasterQuestDungeonsDialog
    CreateCapacityDialog
    CreateUnlockAgeRestrictionsDialog
    CreateCutscenesDialog

    $Options.Damage.Add_SelectedIndexChanged({ $Options.Recovery.Enabled = $this.Text -ne "OHKO Mode" })
    $Options.EnableTunicColors.Add_CheckStateChanged({
        $Options.KokiriTunicColor.Enabled = $Options.GoronTunicColor.Enabled = $Options.ZoraTunicColor.Enabled = $this.Checked
        $Options.ResetAllColors.Enabled = $this.Enabled -or $Options.EnableGauntletColors.Enabled
    })
    $Options.EnableGauntletColors.Add_CheckStateChanged({
        $Options.SilverGauntletsColor.Enabled = $Options.GoldenGauntletsColor.Enabled = $this.Checked
        $Options.ResetAllColors.Enabled = $Options.EnableTunicColors.Checked -or $this.Checked
    })

    $Options.Recovery.Enabled = $Options.Damage.Text -ne "OHKO Mode"
    $Options.KokiriTunicColor.Enabled = $Options.GoronTunicColor.Enabled = $Options.ZoraTunicColor.Enabled = $Options.EnableTunicColors.Checked
    $Options.SilverGauntletsColor.Enabled = $Options.GoldenGauntletsColor.Enabled = $Options.EnableGauntletColors.Checked
    $Options.ResetAllColors.Enabled = $Options.EnableTunicColors.Checked -or $Options.EnableGauntletColors.Checked

    $Options.SetKokiriTunicColor       = CreateColorDialog -Color "1E691B" -Name "SetKokiriTunicColor"     -IsGame
    $Options.SetGoronTunicColor        = CreateColorDialog -Color "641400" -Name "SetGoronTunicColor"      -IsGame
    $Options.SetZoraTunicColor         = CreateColorDialog -Color "003C64" -Name "SetZoraTunicColor"       -IsGame
    $Options.SetSilverGauntletsColor   = CreateColorDialog -Color "FFFFFF" -Name "SetSilverGauntletsColor" -IsGame
    $Options.SetGoldenGauntletsColor   = CreateColorDialog -Color "FECF0F" -Name "SetGoldenGauntletsColor" -IsGame

}



#==============================================================================================================================================================================================
function CreateOcarinaOfTimeReduxContent() {
    
    CreateReduxDialog -Width 730 -Height 320
    $ToolTip = CreateTooltip



    # INTERFACE #
    $InterfaceBox                      = CreateReduxGroup -Y 50 -Height 1 -AddTo $Redux.Panel -Text "Interface"

    $Redux.ShowFileSelectIcons         = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $InterfaceBox -Checked -Text "Show File Select Icons" -ToolTip $ToolTip -Info "Show icons on the File Select screen to display your save file progress" -Name "ShowFileSelectIcons"
    $Redux.DPadLayoutShow              = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $InterfaceBox -Checked -Text "Show D-Pad Icon"        -ToolTip $ToolTip -Info "Show the D-Pad icons ingame that display item shortcuts" -Name "DPadLayoutShow"

    

    # COLORS #
    $ColorsBox                         = CreateReduxGroup -Y ($InterfaceBox.Bottom + 5) -Height 3 -AddTo $Redux.Panel -Text "Colors"

    $Redux.EnableButtonColors          = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $ColorsBox -Text "Change Button Colors [!]" -ToolTip $ToolTip -Info "Enable changing the color for the buttons`n[!] Some button icon colors are still unaffected" -Name "EnableButtonColors"
    $Redux.ResetAllColors              = CreateReduxButton   -Column 1 -Row 1 -AddTo $ColorsBox -Text "Reset All Colors"         -ToolTip $ToolTip -Info "Reset all colors to their default values"

    $Redux.AButtonColor                = CreateReduxButton   -Column 0 -Row 2 -AddTo $ColorsBox -Text "Set A Button Color"       -ToolTip $ToolTip -Info "Select the color you want for the A button"
    $Redux.BButtonColor                = CreateReduxButton   -Column 1 -Row 2 -AddTo $ColorsBox -Text "Set B Button Color"       -ToolTip $ToolTip -Info "Select the color you want for the B button"
    $Redux.CButtonColor                = CreateReduxButton   -Column 2 -Row 2 -AddTo $ColorsBox -Text "Set C Button Color"       -ToolTip $ToolTip -Info "Select the color you want for the C buttons"
    $Redux.SButtonColor                = CreateReduxButton   -Column 3 -Row 2 -AddTo $ColorsBox -Text "Set Start Button Color"   -ToolTip $ToolTip -Info "Select the color you want for the Start button"

    $Redux.N64OoTColors                = CreateReduxButton   -Column 0 -Row 3 -AddTo $ColorsBox -Text "N64 OoT Button Colors"    -ToolTip $ToolTip -Info "Set the button colors to match the Nintendo 64 revision of Ocarina of Time"
    $Redux.N64MMColors                 = CreateReduxButton   -Column 1 -Row 3 -AddTo $ColorsBox -Text "N64 MM Button Colors"     -ToolTip $ToolTip -Info "Set the button colors to match the Nintendo 64 revision of Majora's mask"
    $Redux.GCOoTColors                 = CreateReduxButton   -Column 2 -Row 3 -AddTo $ColorsBox -Text "GC OoT Button Colors"     -ToolTip $ToolTip -Info "Set the button colors to match the GameCube revision of Ocarina of Time"
    $Redux.GCMMColors                  = CreateReduxButton   -Column 3 -Row 3 -AddTo $ColorsBox -Text "GC MM Button Colors"      -ToolTip $ToolTip -Info "Set the button colors to match the GameCube revision of Majora's Mask"

    $Redux.ResetAllColors.Add_Click( {
        SetButtonColors -A "5A5AFF" -B "009600" -C "FFA000" -Start "C80000"
        $Redux.SetAButtonColor.Color = "#5A5AFF"; $Settings[$GameType.mode][$Redux.SetAButtonColor.Tag] = $Redux.SetAButtonColor.Color.Name
        $Redux.SetBButtonColor.Color = "#009600"; $Settings[$GameType.mode][$Redux.SetBButtonColor.Tag] = $Redux.SetBButtonColor.Color.Name
        $Redux.SetCButtonColor.Color = "#FFFA00"; $Settings[$GameType.mode][$Redux.SetCButtonColor.Tag] = $Redux.SetCButtonColor.Color.Name
        $Redux.SetSButtonColor.Color = "#C80000"; $Settings[$GameType.mode][$Redux.SetSButtonColor.Tag] = $Redux.SetSButtonColor.Color.Name
    } )

    $Redux.AButtonColor.Add_Click( { $Redux.SetAButtonColor.ShowDialog(); $Settings[$GameType.mode][$Redux.SetAButtonColor.Tag] = $Redux.SetAButtonColor.Color.Name } )
    $Redux.BButtonColor.Add_Click( { $Redux.SetBButtonColor.ShowDialog(); $Settings[$GameType.mode][$Redux.SetBButtonColor.Tag] = $Redux.SetBButtonColor.Color.Name } )
    $Redux.CButtonColor.Add_Click( { $Redux.SetCButtonColor.ShowDialog(); $Settings[$GameType.mode][$Redux.SetCButtonColor.Tag] = $Redux.SetCButtonColor.Color.Name } )
    $Redux.SButtonColor.Add_Click( { $Redux.SetSButtonColor.ShowDialog(); $Settings[$GameType.mode][$Redux.SetSButtonColor.Tag] = $Redux.SetSButtonColor.Color.Name } )

    $Redux.N64OoTColors.Add_Click( { SetButtonColors -A "5A5AFF" -B "009600" -C "FFA000" -Start "C80000" } )
    $Redux.N64MMColors.Add_Click(  { SetButtonColors -A "64C8FF" -B "64FF78" -C "FFF000" -Start "FF823C" } )
    $Redux.GCOoTColors.Add_Click(  { SetButtonColors -A "00C832" -B "FF1E1E" -C "FFA000" -Start "787878" } )
    $Redux.GCMMColors.Add_Click(   { SetButtonColors -A "64FF78" -B "FF6464" -C "FFF000" -Start "787878" } )



    $Redux.AButtonColor.Enabled = $Redux.BButtonColor.Enabled = $Redux.CButtonColor.Enabled = $Redux.SButtonColor.Enabled = $Redux.EnableButtonColors.Enabled -and $Redux.EnableButtonColors.Checked
    $Redux.ResetAllColors.Enabled = $Redux.N64OoTColors.Enabled = $Redux.N64MMColors.Enabled = $Redux.GCOoTColors.Enabled = $Redux.GCMMColors.Enabled = $Redux.EnableButtonColors.Enabled -and $Redux.EnableButtonColors.Checked

    $Redux.EnableButtonColors.Add_CheckStateChanged({
        $Redux.AButtonColor.Enabled = $Redux.BButtonColor.Enabled = $Redux.CButtonColor.Enabled = $Redux.SButtonColor.Enabled = $Redux.EnableButtonColors.Enabled -and $Redux.EnableButtonColors.Checked
        $Redux.ResetAllColors.Enabled = $Redux.N64OoTColors.Enabled = $Redux.N64MMColors.Enabled = $Redux.GCOoTColors.Enabled = $Redux.GCMMColors.Enabled = $Redux.EnableButtonColors.Enabled -and $Redux.EnableButtonColors.Checked
    })

    $Redux.SetAButtonColor           = CreateColorDialog -Color "5A5AFF" -Name "SetAButtonColor"         -IsGame
    $Redux.SetBButtonColor           = CreateColorDialog -Color "009600" -Name "SetBButtonColor"         -IsGame
    $Redux.SetCButtonColor           = CreateColorDialog -Color "FFFA00" -Name "SetCButtonColor"         -IsGame
    $Redux.SetSButtonColor           = CreateColorDialog -Color "C80000" -Name "SetSButtonColor"         -IsGame

}



#==============================================================================================================================================================================================
function CreateMasterQuestDungeonsDialog() {
    
    # Create Dialog
    $Options.MasterQuestDungeonsDialog = CreateDialog -Width 750 -Height 320
    if (Test-Path -LiteralPath $GameFiles.icon -PathType Leaf)       { $Options.MasterQuestDungeonsDialog.Icon = $GameFiles.icon }
    else                                                             { $Options.MasterQuestDungeonsDialog.Icon = $null }

    # Tooltip
    $ToolTip = CreateTooltip

    # Close Button
    $CloseButton = CreateButton -X ($Options.MasterQuestDungeonsDialog.Width / 2 - 40) -Y ($Options.MasterQuestDungeonsDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $Options.MasterQuestDungeonsDialog
    $CloseButton.Add_Click( {$Options.MasterQuestDungeonsDialog.Hide()} )

    # Options Label
    $Label = CreateLabel -X 30 -Y 20 -Width 300 -Height 15 -Font $VCPatchFont -Text ($GameType.mode + " - Dungeons Selection") -AddTo $Options.MasterQuestDungeonsDialog

    # Master Quest Dungeons
    $Options.MasterQuestPanel          = CreatePanel -Width $Options.MasterQuestDungeonsDialog.Width -Height ($Options.MasterQuestDungeonsDialog.Height) -AddTo $Options.MasterQuestDungeonsDialog

    # Enable checkbox
    $MasterQuestBox                    = CreateReduxGroup -Y 50 -Height 1 -AddTo $Options.MasterQuestPanel -Text "Master Quest"
    $Options.MasterQuest               = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $MasterQuestBox -Text "Enable Master Quest"           -ToolTip $ToolTip -Info "Changes Ocarina of Time into Master Quest`nMaster Quest remixes the dungeons with harder challenges`nThe intro title is changed as well" -Name "MasterQuest"
    $Options.MQPauseMenuColors         = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $MasterQuestBox -Text "Pause Menu Colors"    -Checked -ToolTip $ToolTip -Info "Set the Pause Menu Colors to match Master Quest" -Name "MQPauseMenuColors"

    $Options.MQDungeonsBox             = CreateReduxGroup -Y ($MasterQuestBox.Bottom + 5) -Height 3 -AddTo $Options.MasterQuestPanel -Text "Master Quest Dungeons"
    $Options.MQInsideTheDekuTree       = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $Options.MQDungeonsBox -Text "Inside the Deku Tree"     -Checked -ToolTip $ToolTip -Info "Patch Inside the Deku Tree to Master Quest"     -Name "MQInsideTheDekuTree"
    $Options.MQDodongosCavern          = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $Options.MQDungeonsBox -Text "Dodongo's Cavern"         -Checked -ToolTip $ToolTip -Info "Patch Dodongo's Cavern to Master Quest"         -Name "MQDodongosCavern"
    $Options.MQInsideJabuJabusBelly    = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $Options.MQDungeonsBox -Text "Inside Jabu-Jabu's Belly" -Checked -ToolTip $ToolTip -Info "Patch Inside Jabu-Jabu's Belly to Master Quest" -Name "MQInsideJabuJabusBelly"
    $Options.MQForestTemple            = CreateReduxCheckBox -Column 3 -Row 1 -AddTo $Options.MQDungeonsBox -Text "Forest Temple"            -Checked -ToolTip $ToolTip -Info "Patch Forest Temple to Master Quest"            -Name "MQForestTemple"
    $Options.MQFireTemple              = CreateReduxCheckBox -Column 0 -Row 2 -AddTo $Options.MQDungeonsBox -Text "Fire Temple"              -Checked -ToolTip $ToolTip -Info "Patch Fire Temple to Master Quest"              -Name "MQFireTemple"
    $Options.MQWaterTemple             = CreateReduxCheckBox -Column 1 -Row 2 -AddTo $Options.MQDungeonsBox -Text "Water Temple"             -Checked -ToolTip $ToolTip -Info "Patch Water Temple to Master Quest"             -Name "MQWaterTemple"
    $Options.MQShadowTemple            = CreateReduxCheckBox -Column 2 -Row 2 -AddTo $Options.MQDungeonsBox -Text "Shadow Temple"            -Checked -ToolTip $ToolTip -Info "Patch Shadow Temple to Master Quest"            -Name "MQShadowTemple"
    $Options.MQSpiritTemple            = CreateReduxCheckBox -Column 3 -Row 2 -AddTo $Options.MQDungeonsBox -Text "Spirit Temple"            -Checked -ToolTip $ToolTip -Info "Patch Spirit Temple to Master Quest"            -Name "MQSpiritTemple"
    $Options.MQIceCavern               = CreateReduxCheckBox -Column 0 -Row 3 -AddTo $Options.MQDungeonsBox -Text "Ice Cavern"               -Checked -ToolTip $ToolTip -Info "Patch Ice Cavern to Master Quest"               -Name "MQIceCavern"
    $Options.MQBottomOfTheWell         = CreateReduxCheckBox -Column 1 -Row 3 -AddTo $Options.MQDungeonsBox -Text "Bottom of the Well"       -Checked -ToolTip $ToolTip -Info "Patch Bottom of the Well to Master Quest"       -Name "MQBottomOfTheWell"
    $Options.MQGerudoTrainingGround    = CreateReduxCheckBox -Column 2 -Row 3 -AddTo $Options.MQDungeonsBox -Text "Gerudo Training Ground"   -Checked -ToolTip $ToolTip -Info "Patch Gerudo Training Ground to Master Quest"   -Name "MQGerudoTrainingGround"
    $Options.MQInsideGanonsCastle      = CreateReduxCheckBox -Column 3 -Row 3 -AddTo $Options.MQDungeonsBox -Text "Inside Ganon's Castle"    -Checked -ToolTip $ToolTip -Info "Patch Inside Ganon's Castle to Master Quest"    -Name "MQInsideGanonsCastle"

    $Options.MQDungeonsBox.Enabled = $Options.MasterQuest.Checked
    $Options.MQPauseMenuColors.Enabled = $Options.MasterQuest.Checked
    $Options.MasterQuest.Add_CheckStateChanged({
        $Options.MQDungeonsBox.Enabled = $this.Checked
        $Options.MQPauseMenuColors.Enabled = $this.Checked
    })

}



#==============================================================================================================================================================================================
function CreateCapacityDialog() {

    # Create Dialog
    $Options.CapacityDialog = CreateDialog -Width 600 -Height 430
    if (Test-Path -LiteralPath $GameFiles.icon -PathType Leaf)       { $Options.CapacityDialog.Icon = $GameFiles.icon }
    else                                                             { $Options.CapacityDialog.Icon = $null }

    # Tooltip
    $ToolTip = CreateTooltip

    # Close Button
    $CloseButton = CreateButton -X ($Options.CapacityDialog.Width / 2 - 40) -Y ($Options.CapacityDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $Options.CapacityDialog
    $CloseButton.Add_Click( {$Options.CapacityDialog.Hide()} )

    # Options Label
    $Label = CreateLabel -X 30 -Y 20 -Width 300 -Height 15 -Font $VCPatchFont -Text ($GameType.mode + " - Capacity Selection") -AddTo $Options.CapacityDialog

    # Capacity
    $CapacityPanel                     = CreatePanel -Width $Options.CapacityDialog.Width -Height ($Options.CapacityDialog.Height) -AddTo $Options.CapacityDialog

    # Enable checkbox
    $ToggleBox                         = CreateReduxGroup -Y 50 -Height 1 -AddTo $CapacityPanel -Text "Global Toggle"
    $Options.EnableAmmoCapacity        = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $ToggleBox -Text "Change Ammo Capacity"   -ToolTip $ToolTip -Info "Enable changing the capacity values for ammo" -Name "EnableAmmoCapacity"
    $Options.EnableWalletCapacity      = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $ToggleBox -Text "Change Wallet Capacity" -ToolTip $ToolTip -Info "Enable changing the capacity values for the wallets" -Name "EnableWalletCapacity"

    if ($GameType.mode -eq "Ocarina of Time")     { $Options.AmmoBox = CreateReduxGroup -Y ($ToggleBox.Bottom + 5) -Height 5 -AddTo $CapacityPanel -Text "Ammo Capacity Selection" }
    elseif ($GameType.mode -eq "Majora's Mask")   { $Options.AmmoBox = CreateReduxGroup -Y ($ToggleBox.Bottom + 5) -Height 4 -AddTo $CapacityPanel -Text "Ammo Capacity Selection" }

    $Options.Quiver1                   = CreateReduxTextBox -Column 0 -Row 1 -Text "Quiver (1)"      -Value 30 -AddTo $Options.AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Quiver (Base)`nDefault = 30"           -Name "Quiver1"
    $Options.Quiver2                   = CreateReduxTextBox -Column 1 -Row 1 -Text "Quiver (2)"      -Value 40 -AddTo $Options.AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Quiver (Upgrade 1)`nDefault = 40"      -Name "Quiver2"
    $Options.Quiver3                   = CreateReduxTextBox -Column 2 -Row 1 -Text "Quiver (3)"      -Value 50 -AddTo $Options.AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Quiver (Upgrade 2)`nDefault = 50"      -Name "Quiver3"

    $Options.BombBag1                  = CreateReduxTextBox -Column 0 -Row 2 -Text "Bomb Bag (1)"    -Value 20 -AddTo $Options.AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Bomb Bag (Base)`nDefault = 20"         -Name "BombBag1"
    $Options.BombBag2                  = CreateReduxTextBox -Column 1 -Row 2 -Text "Bomb Bag (2)"    -Value 30 -AddTo $Options.AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Bomb Bag (Upgrade 1)`nDefault = 30"    -Name "BombBag2"
    $Options.BombBag3                  = CreateReduxTextBox -Column 2 -Row 2 -Text "Bomb Bag (3)"    -Value 40 -AddTo $Options.AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Bomb Bag (Upgrade 2)`nDefault = 40"    -Name "BombBag3"

    $Options.BombBag1.Add_TextChanged({
        if ($this.Text -eq "30") {
            $cursorPos = $this.SelectionStart
            $this.Text = $this.Text = "31"
            $this.SelectionStart = $cursorPos - 1
            $this.SelectionLength = 0
        }
    })

    if ($GameType.mode -eq "Ocarina of Time") {
        $Options.BulletBag1            = CreateReduxTextBox -Column 0 -Row 3 -Text "Bullet Bag (1)"  -Value 30 -AddTo $Options.AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Bullet Bag (Base)`nDefault = 30"       -Name "BulletBag1"
        $Options.BulletBag2            = CreateReduxTextBox -Column 1 -Row 3 -Text "Bullet Bag (2)"  -Value 40 -AddTo $Options.AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Bullet Bag (Upgrade 1)`nDefault = 40"  -Name "BulletBag2"
        $Options.BulletBag3            = CreateReduxTextBox -Column 2 -Row 3 -Text "Bullet Bag (3)"  -Value 50 -AddTo $Options.AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Bullet Bag (Upgrade 2)`nDefault = 50"  -Name "BulletBag3"

        $Options.DekuSticks1           = CreateReduxTextBox -Column 0 -Row 4 -Text "Deku Sticks (1)" -Value 10 -AddTo $Options.AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Deku Sticks (Base)`nDefault = 10"      -Name "DekuSticks1"
        $Options.DekuSticks2           = CreateReduxTextBox -Column 1 -Row 4 -Text "Deku Sticks (2)" -Value 20 -AddTo $Options.AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Deku Sticks (Upgrade 1)`nDefault = 20" -Name "DekuSticks2"
        $Options.DekuSticks3           = CreateReduxTextBox -Column 2 -Row 4 -Text "Deku Sticks (3)" -Value 30 -AddTo $Options.AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Deku Sticks (Upgrade 2)`nDefault = 30" -Name "DekuSticks3"

        $Options.DekuNuts1             = CreateReduxTextBox -Column 0 -Row 5 -Text "Deku Nuts (1)"   -Value 20 -AddTo $Options.AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Deku Nuts (Base)`nDefault = 20"        -Name "DekuNuts1"
        $Options.DekuNuts2             = CreateReduxTextBox -Column 1 -Row 5 -Text "Deku Nuts (2)"   -Value 30 -AddTo $Options.AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Deku Nuts (Upgrade 1)`nDefault = 30"   -Name "DekuNuts2"
        $Options.DekuNuts3             = CreateReduxTextBox -Column 2 -Row 5 -Text "Deku Nuts (3)"   -Value 40 -AddTo $Options.AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Deku Nuts (Upgrade 2)`nDefault = 40"   -Name "DekuNuts3"
    }
    else {
        $Options.DekuSticks1           = CreateReduxTextBox -Column 0 -Row 3 -Text "Deku Sticks (1)" -Value 10 -AddTo $Options.AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Deku Sticks (Base)`nDefault = 10"      -Name "DekuSticks1"
        $Options.DekuNuts1             = CreateReduxTextBox -Column 0 -Row 4 -Text "Deku Nuts (1)"   -Value 20 -AddTo $Options.AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Deku Nuts (Base)`nDefault = 20"        -Name "DekuNuts1"
    }

    $Options.WalletBox                         = CreateReduxGroup -Y ($Options.AmmoBox.Bottom + 5) -Height 1 -AddTo $CapacityPanel -Text "Wallet Capacity Selection"
    $Options.Wallet1                   = CreateReduxTextBox -Column 0 -Row 1 -Length 3 -Text "Wallet (1)" -Value 99  -AddTo $Options.WalletBox -ToolTip $ToolTip -Info "Set the capacity for the Wallet (Base)`nDefault = 99"       -Name "Wallet1"
    $Options.Wallet2                   = CreateReduxTextBox -Column 1 -Row 1 -Length 3 -Text "Wallet (2)" -Value 200 -AddTo $Options.WalletBox -ToolTip $ToolTip -Info "Set the capacity for the Wallet (Upgrade 1)`nDefault = 200" -Name "Wallet2"
    $Options.Wallet3                   = CreateReduxTextBox -Column 2 -Row 1 -Length 3 -Text "Wallet (3)" -Value 500 -AddTo $Options.WalletBox -ToolTip $ToolTip -Info "Set the capacity for the Wallet (Upgrade 2)`nDefault = 500" -Name "Wallet3"

    $Options.AmmoBox.Enabled = $Options.EnableAmmoCapacity.Checked
    $Options.EnableAmmoCapacity.Add_CheckStateChanged({ $Options.AmmoBox.Enabled = $Options.EnableAmmoCapacity.Checked })
    $Options.WalletBox.Enabled = $Options.EnableWalletCapacity.Checked
    $Options.EnableWalletCapacity.Add_CheckStateChanged({ $Options.WalletBox.Enabled = $Options.EnableWalletCapacity.Checked })

}



#==============================================================================================================================================================================================
function CreateUnlockAgeRestrictionsDialog() {
    
    # Create Dialog
    $Options.UnlockAgeRestrictionsDialog = CreateDialog -Width 600 -Height 260
    if (Test-Path -LiteralPath $GameFiles.icon -PathType Leaf) { $Options.UnlockAgeRestrictionsDialog.Icon = $GameFiles.icon }
    else                                                       { $Options.UnlockAgeRestrictionsDialog.Icon = $null }

    # Tooltip
    $ToolTip = CreateTooltip

    # Close Button
    $CloseButton = CreateButton -X ($Options.UnlockAgeRestrictionsDialog.Width / 2 - 40) -Y ($Options.UnlockAgeRestrictionsDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $Options.UnlockAgeRestrictionsDialog
    $CloseButton.Add_Click( {$Options.UnlockAgeRestrictionsDialog.Hide()} )

    # Options Label
    $Label = CreateLabel -X 30 -Y 20 -Width 300 -Height 15 -Font $VCPatchFont -Text ($GameType.mode + " - Unlock Age Restrictions") -AddTo $Options.UnlockAgeRestrictionsDialog

    # Capacity
    $UnlockAgeRestrictionsPanel             = CreatePanel -Width $Options.UnlockAgeRestrictionsDialog.Width -Height $Options.UnlockAgeRestrictionsDialog.Height -AddTo $Options.UnlockAgeRestrictionsDialog

    $Options.UnlockChildRestrictionsBox     = CreateReduxGroup -Y 50 -Height 1 -AddTo $UnlockAgeRestrictionsPanel -Text "Unlock Child Restrictions"
    $Options.UnlockTunics                   = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $Options.UnlockChildRestrictionsBox -Text "Unlock Tunics"     -ToolTip $ToolTip -Info "Child Link is able to use the Goron Tunic and Zora Tunic`nSince you might want to walk around in style as well when you are young" -Name "UnlockTunics"
    $Options.UnlockBoots                    = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $Options.UnlockChildRestrictionsBox -Text "Unlock Boots [!]"  -ToolTip $ToolTip -Info "Child Link is able to use the Iron Boots and Hover Boots`n[!] The Iron and Hover Boots appears as the Kokiri Boots"                -Name "UnlockBoots"
    $Options.UnlockMegatonHammer            = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $Options.UnlockChildRestrictionsBox -Text "Unlock Hammer [!]" -ToolTip $ToolTip -Info "Child Link is able to use the Megaton Hammer`n[!] The Megaton Hammer appears as invisible"                                         -Name "UnlockMegatonHammer"

    $Options.UnlockAdultRestrictionsBox     = CreateReduxGroup -Y ($Options.UnlockChildRestrictionsBox.Bottom + 5) -Height 1 -AddTo $UnlockAgeRestrictionsPanel -Text "Unlock Adult Restrictions"
    $Options.UnlockKokiriSword              = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $Options.UnlockAdultRestrictionsBox -Text "Unlock Kokiri Sword"  -ToolTip $ToolTip -Info "Adult Link is able to use the Kokiri Sword`nThe Kokiri Sword does half as much damage as the Master Sword"                      -Name "UnlockKokiriSword"
    $Options.UnlockFairySlingshot           = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $Options.UnlockAdultRestrictionsBox -Text "Unlock Slingshot [!]" -ToolTip $ToolTip -Info "Adult Link is able to use the Fairy Slingshot`n[!] The Fairy Slingshot appears as the Fairy Bow"                                -Name "UnlockFairySlingshot"
    $Options.UnlockBoomerang                = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $Options.UnlockAdultRestrictionsBox -Text "Unlock Boomerang [!]" -ToolTip $ToolTip -Info "Adult Link is able to use the Boomerang`n[!] The Boomerang appears as invisible"                                                -Name "UnlockBoomerang"

}



#==============================================================================================================================================================================================
function CreateCutscenesDialog() {
    
    # Create Dialog
    $Options.CutscenesDialog = CreateDialog -Width 600 -Height 260
    if (Test-Path -LiteralPath $GameFiles.icon -PathType Leaf) { $Options.CutscenesDialog.Icon = $GameFiles.icon }
    else                                                       { $Options.CutscenesDialog.Icon = $null }

    # Tooltip
    $ToolTip = CreateTooltip

    # Close Button
    $CloseButton = CreateButton -X ($Options.CutscenesDialog.Width / 2 - 40) -Y ($Options.CutscenesDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $Options.CutscenesDialog
    $CloseButton.Add_Click( {$Options.CutscenesDialog.Hide()} )

    # Options Label
    $Label = CreateLabel -X 30 -Y 20 -Width 300 -Height 15 -Font $VCPatchFont -Text ($GameType.mode + " - Skip Cutscenes") -AddTo $Options.CutscenesDialog

    # Capacity
    $CutscenesPanel                     = CreatePanel -Width $Options.CutscenesDialog.Width -Height ($Options.CutscenesDialog.Height) -AddTo $Options.CutscenesDialog

    $Options.SkipCutscenesBox          = CreateReduxGroup -Y 50 -Height 1 -AddTo $CutscenesPanel -Text "Skip Cutscenes"
    $Options.SkipIntroSequence         = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $Options.SkipCutscenesBox    -Text "Intro Sequence"     -ToolTip $ToolTip -Info "Skip the intro sequence, so you can start playing immediately"                    -Name "SkipIntroSequence"
    $Options.SkipAllMedallions         = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $Options.SkipCutscenesBox    -Text "All Medallions"     -ToolTip $ToolTip -Info "Cutscene for all medallions never triggers when leaving shadow or spirit temples" -Name "SkipAllMedallions"
    $Options.SkipDaruniaDance          = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $Options.SkipCutscenesBox    -Text "Darunia Dance"      -ToolTip $ToolTip -Info "Darunia will not dance"                                                           -Name "SkipDaruniaDance"

    $Options.SpeedupCutscenesBox       = CreateReduxGroup -Y ($Options.SkipCutscenesBox.Bottom + 5) -Height 1 -AddTo $CutscenesPanel -Text "Speed-Up Cutscenes"
    $Options.SpeedupOpeningChests      = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $Options.SpeedupCutscenesBox -Text "Opening Chests"     -ToolTip $ToolTip -Info "Make all chest opening animations fast by kicking them open"                      -Name "SpeedupOpeningChests"
    $Options.SpeedupKingZora           = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $Options.SpeedupCutscenesBox -Text "King Zora"          -ToolTip $ToolTip -Info "King Zora moves quickly"                                                          -Name "SpeedupKingZora"
    $Options.SpeedupZeldasEscape       = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $Options.SpeedupCutscenesBox -Text "Zelda's Escape"     -ToolTip $ToolTip -Info "Speed-up Zelda escaping from Hyrule Castle "                                      -Name "SpeedupZeldasEscape"

}



#==============================================================================================================================================================================================
function SetButtonColors([String]$A, [String]$B, [String]$C, [String]$Start) {

    $Settings[$GameType.mode][$Redux.SetAButtonColor.Tag] = $A;     $Redux.SetAButtonColor.Color = "#" + $A
    $Settings[$GameType.mode][$Redux.SetBButtonColor.Tag] = $B;     $Redux.SetBButtonColor.Color = "#" + $B
    $Settings[$GameType.mode][$Redux.SetCButtonColor.Tag] = $C;     $Redux.SetCButtonColor.Color = "#" + $C
    $Settings[$GameType.mode][$Redux.SetSButtonColor.Tag] = $Start; $Redux.SetSButtonColor.Color = "#" + $Start

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function PatchOptionsOcarinaOfTime
Export-ModuleMember -Function PatchByteOptionsOcarinaOfTime
Export-ModuleMember -Function PatchByteReduxOcarinaOfTime
Export-ModuleMember -Function PatchBPSOptionsOcarinaOfTime
Export-ModuleMember -Function PatchLanguageOptionsOcarinaOfTime

Export-ModuleMember -Function CreateOcarinaOfTimeOptionsContent
Export-ModuleMember -Function CreateOcarinaOfTimeReduxContent

Export-ModuleMember -Function CreateCapacityDialog