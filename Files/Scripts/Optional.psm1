function PatchByteOptionsOoT() {
    
    # HERO MODE #

    if (IsText -Elem $Options.Damage -Text "OKHO Mode" -Enabled) {
        ChangeBytes -Offset "AE8073" -Values @("09", "04") -Interval 16
        ChangeBytes -Offset "AE8096" -Values @("82", "00")
        ChangeBytes -Offset "AE8099" -Values @("00", "00", "00")
    }
    elseif ( (IsText -Elem $Options.Damage -Text "1x Damage" -Enabled -Not) -or (IsText -Elem $Options.Recovery -Text "1x Recovery" -Enabled -Not) ) {
        ChangeBytes -Offset "AE8073" -Values @("09", "04") -Interval 16
        if (IsText -Elem $Options.Recovery -Text "1x Recovery" -Enabled) {                
            if (IsText -Elem $Options.Damage -Text "2x Damage" -Enabled)       { ChangeBytes -Offset "AE8096" -Values @("80", "40") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage" -Enabled)   { ChangeBytes -Offset "AE8096" -Values @("80", "80") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage" -Enabled)   { ChangeBytes -Offset "AE8096" -Values @("80", "C0") }
        ChangeBytes -Offset "AE8099" -Values @("00", "00", "00")
        }
        elseif (IsText -Elem $Options.Recovery -Text "1/2x Recovery" -Enabled) {               
            if (IsText -Elem $Options.Damage -Text "1x Damage" -Enabled)       { ChangeBytes -Offset "AE8096" -Values @("80", "40") }
            elseif (IsText -Elem $Options.Damage -Text "2x Damage" -Enabled)   { ChangeBytes -Offset "AE8096" -Values @("80", "80") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage" -Enabled)   { ChangeBytes -Offset "AE8096" -Values @("80", "C0") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage" -Enabled)   { ChangeBytes -Offset "AE8096" -Values @("81", "00") }
        ChangeBytes -Offset "AE8099" -Values @("10", "80", "43")
        }
        elseif (IsText -Elem $Options.Recovery -Text "1/2x Recovery" -Enabled) {                
            if (IsText -Elem $Options.Damage -Text "1x Damage" -Enabled)       { ChangeBytes -Offset "AE8096" -Values @("80", "80") }
            elseif (IsText -Elem $Options.Damage -Text "2x Damage" -Enabled)   { ChangeBytes -Offset "AE8096" -Values @("80", "C0") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage" -Enabled)   { ChangeBytes -Offset "AE8096" -Values @("81", "00") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage" -Enabled)   { ChangeBytes -Offset "AE8096" -Values @("81", "40") }
        ChangeBytes -Offset "AE8099" -Values @("10", "80", "83")

        }
        elseif (IsText -Elem $Options.Recovery -Text "1/2x Recovery" -Enabled) {                
            if (IsText -Elem $Options.Damage -Text "1x Damage" -Enabled)       { ChangeBytes -Offset "AE8096" -Values @("81", "40") }
            elseif (IsText -Elem $Options.Damage -Text "2x Damage" -Enabled)   { ChangeBytes -Offset "AE8096" -Values @("81", "80") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage" -Enabled)   { ChangeBytes -Offset "AE8096" -Values @("81", "C0") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage" -Enabled)   { ChangeBytes -Offset "AE8096" -Values @("82", "00") }
        ChangeBytes -Offset "AE8099" -Values @("10", "81", "43")
        }
    }

    <#
    if (IsText -Elem $Options.BossHP -Text "2x Boss HP" -Enabled) {
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
    elseif (IsText -Elem $Options.BossHP -Text "3x Boss HP" -Enabled) {
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
    if (IsText -Elem $Options.MonsterHP -Text "2x Monster HP" -Enabled) {
        ChangeBytes -Offset "BFADAB" -Values("14") # Stalfos
    }
    elseif (IsText -Elem $Options.MonsterHP -Text "3x Monster HP" -Enabled) {
        ChangeBytes -Offset "BFADC5" -Values("1E") # Stalfos
    }
    #>
    



    # GRAPHICS #

    if (IsChecked -Elem $Options.WideScreen -Enabled)          { ChangeBytes -Offset "B08038" -Values @("3C", "07", "3F", "E3") }
    
    if (IsChecked -Elem $Options.WidescreenTextures -Enabled) {
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

    if (IsChecked -Elem $Options.ExtendedDraw -Enabled)        { ChangeBytes -Offset "A9A970" -Values @("00", "01") }
    if (IsChecked -Elem $Options.ForceHiresModel -Enabled)     { ChangeBytes -Offset "BE608B" -Values @("00") }

    if (IsChecked -Elem $Options.BlackBars -Enabled) {
        ChangeBytes -Offset "B0F5A4" -Values @("00", "00","00", "00")
        ChangeBytes -Offset "B0F5D4" -Values @("00", "00","00", "00")
        ChangeBytes -Offset "B0F5E4" -Values @("00", "00","00", "00")
        ChangeBytes -Offset "B0F680" -Values @("00", "00","00", "00")
        ChangeBytes -Offset "B0F688" -Values @("00", "00","00", "00")
    }

    if (IsChecked -Elem $Options.DisableLowHPSound -Enabled)   { ChangeBytes -Offset "ADBA1A"  -Values @("00", "00") }
    if (IsChecked -Elem $Options.DisableNaviPrompts -Enabled)  { ChangeBytes -Offset "DF8B84"  -Values @("00", "00", "00", "00") }



    # INTERFACE #

    if (IsChecked -Elem $Options.HudTextures -Enabled) {
        PatchBytes  -Offset "1A3CA00" -Texture -Patch "HUD\MM HUD Button.bin"
        PatchBytes  -Offset "1A3C100" -Texture -Patch "HUD\MM HUD Hearts.bin"
        PatchBytes  -Offset "1A3DE00" -Texture -Patch "HUD\MM HUD Key & Rupee.bin"
    }

    if (IsChecked -Elem $Options.ButtonPositions -Enabled) {
        ChangeBytes -Offset "0B57EEF" -Values @("A7")
        ChangeBytes -Offset "0B57F03" -Values @("BE")
        ChangeBytes -Offset "0B586A7" -Values @("17")
        ChangeBytes -Offset "0B589EB" -Values @("9B")
    }

    

    # COLORS

    if (IsChecked -Elem $Options.EnableTunicColors -Enabled) {
        ChangeBytes -Offset "B6DA38" -IsDec -Values @($Options.SetKokiriTunicColor.Color.R, $Options.SetKokiriTunicColor.Color.G, $Options.SetKokiriTunicColor.Color.B) # Kokiri Tunic
        ChangeBytes -Offset "B6DA3B" -IsDec -Values @($Options.SetGoronTunicColor.Color.R, $Options.SetGoronTunicColor.Color.G, $Options.SetGoronTunicColor.Color.B)    # Goron Tunic
        ChangeBytes -Offset "B6DA3E" -IsDec -Values @($Options.SetZoraTunicColor.Color.R, $Options.SetZoraTunicColor.Color.G, $Options.SetZoraTunicColor.Color.B)       # Zora Tunic
    }

    if (IsChecked -Elem $Options.EnableGauntletTunics -Enabled) {
        ChangeBytes -Offset "B6DA44" -IsDec -Values @($Options.SetSilverGauntletsColor.Color.R, $Options.SetSilverGauntletsColor.Color.G, $Options.SetSilverGauntletsColor.Color.B) # Silver Gauntlets
        ChangeBytes -Offset "B6DA47" -IsDec -Values @($Options.SetGoldenGauntletsColor.Color.R, $Options.SetGoldenGauntletsColor.Color.G, $Options.SetGoldenGauntletsColor.Color.B) # Golden Gauntlets
    }

    if (IsChecked -Elem $Options.MQPauseMenuColors -Enabled) {
        # Cursor
        if (IsChecked -Elem $PatchReduxCheckbox -Visible) {
            ChangeBytes -Offset "3480859"  -Values @("C8", "00", "50")
            ChangeBytes -Offset "348085F"  -Values @("FF", "00", "50")
        }
        ChangeBytes -Offset "BC784B"  -Values @("FF", "00", "32")
        ChangeBytes -Offset "BC78AB"  -Values @("FF", "00", "32")
        ChangeBytes -Offset "BC78BD"  -Values @("FF", "00", "32")
        ChangeBytes -Offset "845755"  -Values @("FF", "64")
    }



    # GAMEPLAY

    if (IsChecked -Elem $Options.Medallions -Enabled)          { ChangeBytes -Offset "E2B454" -Values @("80", "EA", "00", "A7", "24", "01", "00", "3F", "31", "4A", "00", "3F", "00", "00", "00", "00") }

    if (IsChecked -Elem $Options.ReturnChild -Enabled) {
        ChangeBytes -Offset "CB6844"  -Values @("35")
        ChangeBytes -Offset "253C0E2" -Values @("03")
    }

    if (IsChecked -Elem $Options.EasierMinigames -Enabled) {
        ChangeBytes -Offset "CC4024" -Values @("00", "00", "00", "00") # Dampe's Digging Game
        ChangeBytes -Offset "DBF428" -Values @("0C", "10", "07", "7D", "3C", "01", "42", "82", "44", "81", "40", "00", "44", "98", "90", "00", "E6", "52") # Easier Fishing
        ChangeBytes -Offset "DBF484" -Values @("00", "00", "00", "00") # Easier Fishing
        ChangeBytes -Offset "DBF4A8" -Values @("00", "00", "00", "00") # Easier Fishing
        ChangeBytes -Offset "DCBEAB" -Values @("48")                   # Adult Fish size requirement
        ChangeBytes -Offset "DCBF27" -Values @("48")                   # Adult Fish size requirement
        ChangeBytes -Offset "DCBF33" -Values @("30")                   # Child Fish size requirement
        ChangeBytes -Offset "DCBF9F" -Values @("30")                   # Child Fish size requirement
        # ChangeBytes -Offset "DB9E7C" -Values @("0C", "10", "0D", "AB", "00", "00", "00", "00") # First try truth spinner
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



    # RESTORE #

    if (IsChecked -Elem $Options.CorrectRupeeColors -Enabled) {
        ChangeBytes -Offset "F47EB0" -Values @("70", "6B", "BB", "3F", "FF", "FF", "EF", "3F", "68", "AD", "C3", "FD", "E6", "BF", "CD", "7F", "48", "9B", "91", "AF", "C3", "7D", "BB", "3D", "40", "0F", "58", "19", "88", "ED", "80", "AB") # Purple
        ChangeBytes -Offset "F47ED0" -Values @("D4", "C3", "F7", "49", "FF", "FF", "F7", "E1", "DD", "03", "EF", "89", "E7", "E3", "E7", "DD", "A3", "43", "D5", "C3", "DF", "85", "E7", "45", "7A", "43", "82", "83", "B4", "43", "CC", "83") # Gold
    }

    if (IsChecked -Elem $Options.RestoreFireTemple -Enabled) {
        ChangeBytes -Offset "7465"   -Values @("03", "91", "30") # DMA Table, Pointer to AudioBank
        ChangeBytes -Offset "7471"   -Values @("03", "91", "30", "00", "08", "8B", "B0", "00", "03", "91", "30") # DMA Table, Pointer to AudioSeq
        ChangeBytes -Offset "7481"   -Values @("08", "8B", "B0", "00", "4D", "9F", "40", "00", "08", "8B", "B0") # DMA Table, Pointer to AudioTable
        ChangeBytes -Offset "B2E82F" -Values @("04", "24", "A5", "91", "30") # MIPS assembly that loads AudioSeq
        ChangeBytes -Offset "B2E857" -Values @("09", "24", "A5", "8B", "B0") # MIPS assembly that loads AudioTable
        PatchBytes  -Offset "B896A0" -Patch "Fire Temple Theme\12AudioBankPointers.bin"
        PatchBytes  -Offset "B89AD0" -Patch "Fire Temple Theme\12AudioSeqPointers.bin"
        PatchBytes  -Offset "B8A1C0" -Patch "Fire Temple Theme\12AudioTablePointers.bin"
        ExportAndPatch -Path "Fire Temple Theme\12FireTemple"  -Offset "D390" -Length "4CCBB0"
    }

    if (IsChecked -Elem $Options.RestoreCowNoseRing -Enabled) { ChangeBytes -Offset "EF3E68" -Values @("00", "00") }



    # VOICES #

    if (IsText -Elem $Options.Voices -Text "Feminine Link Voices" -Enabled) {
        if (IsChecked -Elem $Options.RestoreFireTemple -Enabled)   { PatchBytes -Offset "19D920" -Patch "Voices\Feminine Link Voices.bin" }
        else                                                       { PatchBytes -Offset "18E1E0" -Patch "Voices\Feminine Link Voices.bin" }
    }
    elseif (IsText -Elem $Options.Voices -Text "Majora's Mask Link Voices" -Enabled) {
        if (IsChecked -Elem $Options.RestoreFireTemple -Enabled)   { PatchBytes -Offset "19D920" -Patch "Voices\MM Link Voices.bin" }
        else                                                       { PatchBytes -Offset "18E1E0" -Patch "Voices\MM Link Voices.bin" }
    }


    
    # EQUIPMENT #

    if (IsChecked -Elem $Options.EnableAmmoCapacity -Enabled) {
        ChangeBytes -Offset "B6EC2F" -IsDec -Values @($Options.Quiver1.Text, $Options.Quiver2.Text, $Options.Quiver3.Text) -Interval 2
        ChangeBytes -Offset "B6EC37" -IsDec -Values @($Options.BombBag1.Text, $Options.BombBag2.Text, $Options.BombBag3.Text) -Interval 2
        ChangeBytes -Offset "B6EC57" -IsDec -Values @($Options.BulletBag1.Text, $Options.BulletBag2.Text, $Options.BulletBag3.Text) -Interval 2
        ChangeBytes -Offset "B6EC5F" -IsDec -Values @($Options.DekuSticks1.Text, $Options.DekuSticks2.Text, $Options.DekuSticks3.Text) -Interval 2
        ChangeBytes -Offset "B6EC67" -IsDec -Values @($Options.DekuNuts1.Text, $Options.DekuNuts2.Text, $Options.DekuNuts3.Text) -Interval 2
    }

    if (IsChecked -Elem $Options.EnableWalletCapacity -Enabled) {
        $Wallet1 = Get16Bit -Value ($Options.Wallet1.Text)
        $Wallet2 = Get16Bit -Value ($Options.Wallet2.Text)
        $Wallet3 = Get16Bit -Value ($Options.Wallet3.Text)
        ChangeBytes -Offset "B6EC4C" -Values @($Wallet1.Substring(0, 2), $Wallet1.Substring(2) )
        ChangeBytes -Offset "B6EC4E" -Values @($Wallet2.Substring(0, 2), $Wallet2.Substring(2) )
        ChangeBytes -Offset "B6EC50" -Values @($Wallet3.Substring(0, 2), $Wallet3.Substring(2) )
    }

    if (IsChecked -Elem $Options.UnlockSword -Enabled) {
        ChangeBytes -Offset "BC77AD" -Values @("09")
        ChangeBytes -Offset "BC77F7" -Values @("09")
    }

    if (IsChecked -Elem $Options.UnlockTunics -Enabled) {
        ChangeBytes -Offset "BC77B6" -Values @("09", "09")
        ChangeBytes -Offset "BC77FE" -Values @("09", "09")
    }

    if (IsChecked -Elem $Options.UnlockBoots -Enabled) {
        ChangeBytes -Offset "BC77BA" -Values @("09", "09")
        ChangeBytes -Offset "BC7801" -Values @("09", "09")
    }



    # OTHER #

    if (IsChecked -Elem $Options.SubscreenDelayFix -Enabled) {
        ChangeBytes -Offset "B15DD0" -Values @("00", "00", "00", "00")
        ChangeBytes -Offset "B12947" -Values @("03")
    }

    if (IsChecked -Elem $Options.DefaultZTargeting -Enabled)       { ChangeBytes -Offset "B71E6D"  -Values @("01") }
    


    # Patch Dungeons Master Quest

    PatchDungeonsMQ



    # Censor Gerudo Textures

    if (IsChecked -Elem $Options.CensorGerudoTextures -Enabled) {
        PatchBytes -Offset "12985F0" -Texture -Patch "Gerudo Symbols\2.bin"
        PatchBytes -Offset "21B8678" -Texture -Patch "Gerudo Symbols\3.bin"
        PatchBytes -Offset "13B4000" -Texture -Patch "Gerudo Symbols\4.bin"
        PatchBytes -Offset "7FD000"  -Texture -Patch "Gerudo Symbols\5.bin"
        PatchBytes -Offset "F70350"  -Texture -Patch "Gerudo Symbols\8.bin"
        PatchBytes -Offset "F80CB0"  -Texture -Patch "Gerudo Symbols\9.bin"
        PatchBytes -Offset "11FB000" -Texture -Patch "Gerudo Symbols\10.bin"
        PatchBytes -Offset "F7A8A0"  -Texture -Patch "Gerudo Symbols\13.bin"
        PatchBytes -Offset "F71350"  -Texture -Patch "Gerudo Symbols\14.bin"
        PatchBytes -Offset "F748A0"  -Texture -Patch "Gerudo Symbols\16.bin"
        PatchBytes -Offset "E68CE8"  -Texture -Patch "Gerudo Symbols\17.bin"
        PatchBytes -Offset "F70B50"  -Texture -Patch "Gerudo Symbols\18.bin"
        PatchBytes -Offset "1456388" -Texture -Patch "Gerudo Symbols\19.bin"
        PatchBytes -Offset "1616000" -Texture -Patch "Gerudo Symbols\20.bin"
        PatchBytes -Offset "2F64E38" -Texture -Patch "Gerudo Symbols\21.bin"
        PatchBytes -Offset "2F73700" -Texture -Patch "Gerudo Symbols\21.bin"

        if ( (IsText -Elem $Options.Models -Text "Replace Adult Model Only" -Enabled) -or (IsText -Elem $Options.Models -Text "Replace Both Models" -Enabled) )   { PatchBytes -Offset "F9B318"  -Texture -Patch "Gerudo Symbols\15.bin" }
        elseif (IsText -Elem $Options.Models -Text "Change to Female Models" -Enabled)                                                                            { PatchBytes -Offset "FA0780"  -Texture -Patch "Gerudo Symbols\15.bin" }
        else                                                                                                                                                      { PatchBytes -Offset "F92280"  -Texture -Patch "Gerudo Symbols\15.bin" }

        PatchBytes -Offset "2464D88" -Texture -Patch "Gerudo Symbols\1.bin"  # Room 11 Forest Temple
        PatchBytes -Offset "28BBCD8" -Texture -Patch "Gerudo Symbols\7.bin"  # Room 5 Gerudo Training Ground
        PatchBytes -Offset "28CA728" -Texture -Patch "Gerudo Symbols\7.bin"  # Room 5 Gerudo Training Ground
        PatchBytes -Offset "2B5CDA0" -Texture -Patch "Gerudo Symbols\12.bin" # Room 10 Spirit Temple
        PatchBytes -Offset "2B9BDB8" -Texture -Patch "Gerudo Symbols\12.bin" # Room 10 Spirit Temple
        PatchBytes -Offset "2BE7920" -Texture -Patch "Gerudo Symbols\12.bin" # Room 10 Spirit Temple

        if (IsChecked -Elem $Options.MQSpiritTemple -Enabled)   { PatchBytes -Offset "2B03528" -Texture -Patch "Gerudo Symbols\11.bin" } # Room 0 Spirit Temple
        else                                                    { PatchBytes -Offset "2B03928" -Texture -Patch "Gerudo Symbols\11.bin" } # Room 0 Spirit Temple
    }

}



#==============================================================================================================================================================================================
function PatchByteReduxOoT() {

    # INTERFACE #

    if (IsChecked -Elem $Redux.ShowFileSelectIcons -Enabled) { PatchBytes  -Offset "BAF738" -Patch "File Select.bin" }
    if (IsChecked -Elem $Redux.DPadLayoutShow -Enabled)      { ChangeBytes -Offset "348086E" -Values @("01") }



     # COLORS

     if (IsChecked -Elem $Redux.EnableButtonColors -Enabled) {
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
function PatchBPSOptionsOoT() {
    
    if ( (IsText -Elem $Options.Models -Text "Replace Child Model Only" -Enabled) -or (IsText -Elem $Options.Models -Text "Replace Both Models" -Enabled) ) {
        ApplyPatch -File $Files.decompressedROM -Patch "\Decompressed\Models\child_model.ppf"
    }
    if ( (IsText -Elem $Options.Models -Text "Replace Adult Model Only" -Enabled) -or (IsText -Elem $Options.Models -Text "Replace Both Models" -Enabled)) {
        ApplyPatch -File $Files.decompressedROM -Patch "\Decompressed\Models\adult_model.ppf"
    }
    if (IsText -Elem $Options.Models -Text "Change to Female Models" -Enabled) {
        ApplyPatch -File $Files.decompressedROM -Patch "\Decompressed\Models\female_models.ppf"
    }

    if (IsChecked -Elem $Options.PauseScreen -Enabled) {
        ApplyPatch -File $Files.decompressedROM -Patch "\Decompressed\mm_pause_screen.ppf"
    }
    
}



#==============================================================================================================================================================================================
function PatchLanguageOptionsOoT() {
    
    if ( (IsChecked -Elem $Languages.TextRestore -Enabled) -or (IsChecked -Elem $Languages.TextSpeed2x -Enabled) -or (IsChecked -Elem $Languages.TextSpeed3x -Enabled) -or (IsChecked -Elem $Languages.TextDialogueColors -Enabled) -or (IsChecked -Elem $Languages.TextUnisizeTunics -Enabled)  ) {
        $File = $GameFiles.binaries + "\" + "Message\Message Data Static.bin"
        ExportBytes -Offset "92D000" -Length "38140" -Output $File
    }

    if (IsChecked -Elem $Languages.TextRestore -Enabled) {
        if (!(IsChecked -Elem $Languages.FemalePronouns -Enabled)) {
            ChangeBytes -Offset "7596" -Values @("52", "40")
            PatchBytes  -Offset "B849EC" -Patch "Message\Table Restore.bin"
        }

        if (IsChecked -Elem $PatchReduxCheckbox -Visible)  { ApplyPatch -File $File -Patch "\Data Extraction\Message\Message Data Static OoT Redux.bps" -FilesPath }
        else                                               { ApplyPatch -File $File -Patch "\Data Extraction\Message\Message Data Static OoT.bps"       -FilesPath }

        if (IsChecked -Elem $Languages.TextFemalePronouns -Enabled) {
            ChangeBytes -Offset "7596" -Values @("52", "E0")
            PatchBytes  -Offset "B849EC" -Patch "Message\Table Girl.bin"
            ApplyPatch -File $File -Patch "\Data Extraction\Message\Message Data Static Girl.bps" -FilesPath
        }

    }

    if (IsChecked -Elem $Languages.TextSpeed2x -Enabled) {
        ChangeBytes -Offset "B5006F" -Values @("02") # Text Speed

        # Correct Ruto Confession Textboxes
        $Offset = SearchBytes -File $File -Values @("1A", "41", "73", "20", "61", "20", "72", "65", "77", "61", "72", "64", "2E", "2E", "2E", "01")
        PatchBytes -File $File -Offset $Offset -Patch "Message\Ruto Confession.bin"

        # Correct Phantom Ganon Defeat Textboxes
        $Offset = SearchBytes -File $File -Values @("0C", "3C", "42", "75", "74", "20", "79", "6F", "75", "20", "68", "61", "76", "65", "20", "64")
        ChangeBytes -File $File -Offset ( Get24Bit -Value ( (GetDecimal -Hex $Offset) + (GetDecimal -Hex "1") ) ) -Values @("66")
        ChangeBytes -File $File -Offset ( Get24Bit -Value ( (GetDecimal -Hex $Offset) + (GetDecimal -Hex "5D") ) ) -Values @("66")
        ChangeBytes -File $File -Offset ( Get24Bit -Value ( (GetDecimal -Hex $Offset) + (GetDecimal -Hex "BA") ) ) -Values @("60")
    }
    elseif (IsChecked -Elem $Languages.TextSpeed3x -Enabled) {
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
        
    if (IsChecked -Elem $Languages.TextDialogueColors -Enabled) {
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

    if (IsChecked -Elem $Languages.TextUnisizeTunics -Enabled) {
        $Offset = SearchBytes -File $File -Values @("59", "6F", "75", "20", "67", "6F", "74", "20", "61", "20", "05", "41", "47", "6F", "72", "6F", "6E", "20", "54", "75", "6E", "69", "63")
        ChangeBytes -File $File -Offset ( Get24Bit -Value ( (GetDecimal -Hex $Offset) + (GetDecimal -Hex "39") ) ) -Values @("75", "6E", "69", "73", "69", "7A", "65", "2C", "20", "73", "6F", "20", "69", "74", "20", "66", "69", "74", "73", "20", "61", "64", "75", "6C", "74", "20", "61", "6E", "64")
        ChangeBytes -File $File -Offset ( Get24Bit -Value ( (GetDecimal -Hex $Offset) + (GetDecimal -Hex "B3") ) ) -Values @("75", "6E", "69", "73", "69", "7A", "65", "2C", "01", "73", "6F", "20", "69", "74", "20", "66", "69", "74", "73", "20", "61", "64", "75", "6C", "74", "20", "61", "6E", "64")

        $Offset = SearchBytes -File $File -Values @("41", "20", "74", "75", "6E", "69", "63", "20", "6D", "61", "64", "65", "20", "62", "79", "20", "47", "6F", "72", "6F", "6E", "73")
        ChangeBytes -File $File -Offset ( Get24Bit -Value ( (GetDecimal -Hex $Offset) + (GetDecimal -Hex "18") ) ) -Values @("55", "6E", "69", "2D", "20")
        ChangeBytes -File $File -Offset ( Get24Bit -Value ( (GetDecimal -Hex $Offset) + (GetDecimal -Hex "7A") ) ) -Values @("55", "6E", "69", "73", "69", "7A", "65", "2E", "20", "20", "20")
    }

    if ( (IsChecked -Elem $Languages.TextRestore -Enabled) -or (IsChecked -Elem $Languages.TextSpeed2x -Enabled) -or (IsChecked -Elem $Languages.TextSpeed3x -Enabled) -or (IsChecked -Elem $Languages.TextDialogueColors -Enabled) -or (IsChecked -Elem $Languages.TextUnisizeTunics -Enabled) ) {
        PatchBytes -Offset "92D000" -Patch ("Message\Message Data Static.bin")
    }

}



#==============================================================================================================================================================================================
function PatchByteOptionsMM() {
    
    # HERO MODE #

    if (IsText -Elem $Options.Damage -Text "OKHO Mode" -Enabled) {
        ChangeBytes -Offset "BABE7F" -Values @("09", "04") -Interval 16
        ChangeBytes -Offset "BABEA2" -Values @("2A", "00")
        ChangeBytes -Offset "BABEA5" -Values @("00", "00", "00")
    }
    elseif ( (IsText -Elem $Options.Damage -Text "1x Damage" -Enabled -Not) -or (IsText -Elem $Options.Recovery -Text "1x Recovery" -Enabled -Not) ) {
        ChangeBytes -Offset "BABE7F" -Values @("09", "04") -Interval 16
        if (IsText -Elem $Options.Recovery -Text "1x Recovery" -Enabled) {
            if (IsText -Elem $Options.Damage -Text "2x Damage" -Enabled)       { ChangeBytes -Offset "BABEA2" -Values @("28", "40") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage" -Enabled)   { ChangeBytes -Offset "BABEA2" -Values @("28", "80") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage" -Enabled)   { ChangeBytes -Offset "BABEA2" -Values @("28", "C0") }
        ChangeBytes -Elem -File $Files.decompressedROM -Offset "BABEA5" -Values @("00", "00", "00")
        }
        elseif (IsText -Elem $Options.Recovery -Text "1/2x Recovery" -Enabled) {
            if (IsText -Elem $Options.Damage -Text "1x Damage" -Enabled)       { ChangeBytes -Offset "BABEA2" -Values @("28", "40") }
            elseif (IsText -Elem $Options.Damage -Text "2x Damage" -Enabled)   { ChangeBytes -Offset "BABEA2" -Values @("28", "80") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage" -Enabled)   { ChangeBytes -Offset "BABEA2" -Values @("28", "C0") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage" -Enabled)   { ChangeBytes -Offset "BABEA2" -Values @("29", "00") }
        ChangeBytes -Offset "BABEA5" -Values @("05", "28", "43")
        }
        elseif (IsText -Elem $Options.Recovery -Text "1/4x Recovery" -Enabled) {
            if (IsText -Elem $Options.Damage -Text "1x Damage" -Enabled)       { ChangeBytes -Offset "BABEA2" -Values @("28", "80") }
            elseif (IsText -Elem $Options.Damage -Text "2x Damage" -Enabled)   { ChangeBytes -Offset "BABEA2" -Values @("28", "C0") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage" -Enabled)   { ChangeBytes -Offset "BABEA2" -Values @("29", "00") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage" -Enabled)   { ChangeBytes -Offset "BABEA2" -Values @("29", "40") }
        ChangeBytes -Offset "BABEA5" -Values @("05", "28", "83")
        }
        elseif (IsText -Elem $Options.Recovery -Text "0x Recovery" -Enabled) {
            if (IsText -Elem $Options.Damage -Text "1x Damage" -Enabled)       { ChangeBytes -Offset "BABEA2" -Values @("29", "40") }
            elseif (IsText -Elem $Options.Damage -Text "2x Damage" -Enabled)   { ChangeBytes -Offset "BABEA2" -Values @("29", "80") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage" -Enabled)   { ChangeBytes -Offset "BABEA2" -Values @("29", "C0") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage" -Enabled)   { ChangeBytes -Offset "BABEA2" -Values @("2A", "00") }
        ChangeBytes -Offset "BABEA5" -Values @("05", "29", "43")
        }
    }



    # GRAPHICS #

    if (IsChecked -Elem $Options.WideScreen -Enabled) {
        ChangeBytes -Offset "BD5D74" -Values @("3C", "07", "3F", "E3")
        ChangeBytes -Offset "CA58F5" -Values @("6C", "53", "6C", "84", "9E", "B7", "53", "6C") -Interval 2
    }

    if (IsChecked -Elem $Options.WidescreenTextures -Enabled) {
        PatchBytes -Offset "A9A000" -Length "12C00" -Texture -Patch "Carnival of Time.bin"
        PatchBytes -Offset "AACC00" -Length "12C00" -Texture -Patch "Four Giants.bin"
        PatchBytes -Offset "C74DD0" -Length "800"   -Texture -Patch "Lens of Truth.bin"
    }

    if (IsChecked -Elem $Options.ExtendedDraw -Enabled)        { ChangeBytes -Offset "B50874" -Values @("00", "00", "00", "00") }
    if (IsChecked -Elem $Options.BlackBars -Enabled)           { ChangeBytes -Offset "BF72A4" -Values @("00", "00", "00", "00") }
    if (IsChecked -Elem $Options.PixelatedStars -Enabled)      { ChangeBytes -Offset "B943FC" -Values @("10", "00") }



    # COLORS #

    if (IsChecked -Elem $Options.EnableTunicColors -Enabled) {
        ChangeBytes -Offset "116639C" -IsDec -Values @($Options.SetKokiriTunicColor.Color.R, $Options.SetKokiriTunicColor.Color.G,$Options.SetKokiriTunicColor.Color.B)
        ChangeBytes -Offset "11668C4" -IsDec -Values @($Options.SetKokiriTunicColor.Color.R, $Options.SetKokiriTunicColor.Color.G,$Options.SetKokiriTunicColor.Color.B)
        ChangeBytes -Offset "1166DCC" -IsDec -Values @($Options.SetKokiriTunicColor.Color.R, $Options.SetKokiriTunicColor.Color.G,$Options.SetKokiriTunicColor.Color.B)
        ChangeBytes -Offset "1166FA4" -IsDec -Values @($Options.SetKokiriTunicColor.Color.R, $Options.SetKokiriTunicColor.Color.G,$Options.SetKokiriTunicColor.Color.B)
        ChangeBytes -Offset "1167064" -IsDec -Values @($Options.SetKokiriTunicColor.Color.R, $Options.SetKokiriTunicColor.Color.G,$Options.SetKokiriTunicColor.Color.B)
        ChangeBytes -Offset "116766C" -IsDec -Values @($Options.SetKokiriTunicColor.Color.R, $Options.SetKokiriTunicColor.Color.G,$Options.SetKokiriTunicColor.Color.B)
        ChangeBytes -Offset "1167AE4" -IsDec -Values @($Options.SetKokiriTunicColor.Color.R, $Options.SetKokiriTunicColor.Color.G,$Options.SetKokiriTunicColor.Color.B)
        ChangeBytes -Offset "1167D1C" -IsDec -Values @($Options.SetKokiriTunicColor.Color.R, $Options.SetKokiriTunicColor.Color.G,$Options.SetKokiriTunicColor.Color.B)
        ChangeBytes -Offset "11681EC" -IsDec -Values @($Options.SetKokiriTunicColor.Color.R, $Options.SetKokiriTunicColor.Color.G,$Options.SetKokiriTunicColor.Color.B)
    }



    # GAMEPLAY
    
    if (IsChecked -Elem $Options.RestorePalaceRoute -Enabled) {
        CreateSubPath -Path ($GameFiles.binaries + "\Deku Palace")
        ExportAndPatch -Path "Deku Palace\deku_palace_scene"  -Offset "2534000" -Length "D220"  -NewLength "D230"  -TableOffset "1F687" -Values @("30")
        ExportAndPatch -Path "Deku Palace\deku_palace_room_0" -Offset "2542000" -Length "11A50"
        ExportAndPatch -Path "Deku Palace\deku_palace_room_1" -Offset "2554000" -Length "E950"  -NewLength "E9B0"  -TableOffset "1F6A7" -Values @("B0")
        ExportAndPatch -Path "Deku Palace\deku_palace_room_2" -Offset "2563000" -Length "124F0" -NewLength "124B0" -TableOffset "1F6B7" -Values @("B0")
    }

    <#
    if (IsChecked -Elem $Options.ResearchLabPlatform -Enabled) {
        CreateSubPath -Path ($GameFiles.binaries + "\Great Bay Coast")
        ExportAndPatch -Path "Great Bay Coast\great_bay_coast_scene"  -Offset "26BF000" -Length "1EDD0" -NewLength "1EEB0" -TableOffset "1F826" -Values @("DE", "B0")
        ExportAndPatch -Path "Great Bay Coast\great_bay_coast_room_0" -Offset "26DE000" -Length "1D300" -NewLength "1D2F0" -TableOffset "1F836" -Values @("B2", "F0")

        #ChangeBytes -Offset ( Get32Bit -Value ( (GetDecimal -Hex "26BF000") + (GetDecimal -Hex "190")  ) ) -Values @("02", "6D", "E0", "00", "02", "6F", "B2", "F0")
        #ChangeBytes -Offset ( Get32Bit -Value ( (GetDecimal -Hex "26BF000") + (GetDecimal -Hex "9680") ) ) -Values @("02", "6D", "E0", "00", "02", "6F", "B2", "F0")
        #ChangeBytes -Offset ( Get32Bit -Value ( (GetDecimal -Hex "26BF000") + (GetDecimal -Hex "C168") ) ) -Values @("02", "6D", "E0", "00", "02", "6F", "B2", "F0")

        #ChangeBytes -Offset ( Get32Bit -Value ( (GetDecimal -Hex "26BF000") + (GetDecimal -Hex "1A8") ) ) -Values @("02", "6D", "E0", "00", "02", "6F", "B2", "F0")
        #ChangeBytes -Offset ( Get32Bit -Value ( (GetDecimal -Hex "26BF000") + (GetDecimal -Hex "95A0") ) ) -Values @("02", "6D", "E0", "00", "02", "6F", "B2", "F0")
        #ChangeBytes -Offset ( Get32Bit -Value ( (GetDecimal -Hex "26BF000") + (GetDecimal -Hex "C088") ) ) -Values @("02", "6D", "E0", "00", "02", "6F", "B2", "F0")
    }
    #>

    <#
    if (IsChecked -Elem $Options.RanchDirtRoad -Enabled) {
        CreateSubPath -Path ($GameFiles.binaries + "\Romani Ranch")
        ExportAndPatch -Path "Romani Ranch\romani_ranch_scene"  -Offset "2690000" -Length "1C460" -NewLength "1EA90" -TableOffset "1F7E6" -Values @("EA", "90")
        ExportAndPatch -Path "Romani Ranch\romani_ranch_room_0" -Offset "26AD000" -Length "D2C0"  -NewLength "CDE0"  -TableOffset "1F7F6" -Values @("9D", "E0")
    }
    #>

    if (IsChecked -Elem $Options.ZoraPhysics -Enabled $True)   { PatchBytes -Offset "65D000" -Patch "Zora Physics Fix.bin" }



    # RESTORE

    if (IsChecked -Elem $Options.CorrectRomaniSign -Enabled)   { PatchBytes -Offset "26A58C0" -Texture -Patch "Romani Sign.bin" }
    if (IsChecked -Elem $Options.CorrectComma -Enabled)        { ChangeBytes -Offset "ACC660" -Values @("00", "F3", "00", "00", "00", "00", "00", "00", "4F", "60", "00", "00", "00", "00", "00", "00", "24") }
    if (IsChecked -Elem $Options.RestoreTitle -Enabled)        { ChangeBytes -Offset "DE0C2E" -Values @("FF", "C8", "36", "10", "98", "00") }

    if (IsChecked -Elem $Options.CorrectRupeeColors -Enabled) {
        ChangeBytes -Offset "10ED020" -Values @("70", "6B", "BB", "3F", "FF", "FF", "EF", "3F", "68", "AD", "C3", "FD", "E6", "BF", "CD", "7F", "48", "9B", "91", "AF", "C3", "7D", "BB", "3D", "40", "0F", "58", "19", "88", "ED", "80", "AB") # Purple
        ChangeBytes -Offset "10ED040" -Values @("D4", "C3", "F7", "49", "FF", "FF", "F7", "E1", "DD", "03", "EF", "89", "E7", "E3", "E7", "DD", "A3", "43", "D5", "C3", "DF", "85", "E7", "45", "7A", "43", "82", "83", "B4", "43", "CC", "83") # Gold
    }

    if (IsChecked -Elem $Options.RestoreCowNoseRing -Enabled) {
        ChangeBytes -Offset "E10270"  -Values @("00", "00")
        ChangeBytes -Offset "107F5C4" -Values @("00", "00")
    }

    if (IsChecked -Elem $Options.RestoreSkullKid -Enabled) {
        $Values = @()
        for ($i=0; $i -lt 256; $i++) {
            $Values += 0
            $Values += 1
        }
        ChangeBytes -Offset "181C820" -Values $Values
        PatchBytes  -Offset "181C620" -Texture -Patch "Skull Kid Beak.bin"
    }

    if (IsChecked -Elem $Options.RestoreShopMusic -Enabled)    { ChangeBytes -Offset "2678007" -Values @("44") }
    if (IsChecked -Elem $Options.PieceOfHeartSound -Enabled)   { ChangeBytes -Offset "BA94C8"  -Values @("10", "00") }
    if (IsChecked -Elem $Options.MoveBomberKid -Enabled)       { ChangeBytes -Offset "2DE4396" -Values @("02", "C5", "01", "18", "FB", "55", "00", "07", "2D") }



    # EQUIPMENT #

    if (IsChecked -Elem $Options.EnableAmmoCapacity -Enabled) {
        ChangeBytes -Offset "C5834F" -IsDec -Values @($Options.Quiver1.Text, $Options.Quiver2.Text, $Options.Quiver3.Text) -Interval 2
        ChangeBytes -Offset "C58357" -IsDec -Values @($Options.BombBag1.Text, $Options.BombBag2.Text, $Options.BombBag3.Text) -Interval 2
        ChangeBytes -Offset "C5837F" -IsDec -Values @($Options.DekuSticks1.Text, $Options.DekuSticks1.Text, $Options.DekuSticks1.Text) -Interval 2
        ChangeBytes -Offset "C58387" -IsDec -Values @($Options.DekuNuts1.Text, $Options.DekuNuts1.Text, $Options.DekuNuts1.Text) -Interval 2
    }

    if (IsChecked -Elem $Options.EnableWalletCapacity -Enabled) {
        $Wallet1 = Get16Bit -Value ($Options.Wallet1.Text)
        $Wallet2 = Get16Bit -Value ($Options.Wallet2.Text)
        $Wallet3 = Get16Bit -Value ($Options.Wallet3.Text)
        ChangeBytes -Offset "C5836C" -Values @($Wallet1.Substring(0, 2), $Wallet1.Substring(2) )
        ChangeBytes -Offset "C5836E" -Values @($Wallet2.Substring(0, 2), $Wallet2.Substring(2) )
        ChangeBytes -Offset "C58370" -Values @($Wallet3.Substring(0, 2), $Wallet3.Substring(2) )
    }

    if (IsChecked -Elem $Options.RazorSword -Enabled) {
        ChangeBytes -Offset "CBA496" -Values @("00", "00") # Prevent losing hits
        ChangeBytes -Offset "BDA6B7" -Values @("01")       # Keep sword after Song of Time
    }



    # OTHER #
    
    if (IsChecked -Elem $Options.FixSouthernSwamp -Enabled) {
        CreateSubPath -Path ($GameFiles.binaries + "\Southern Swamp")
        ExportAndPatch -Path "Southern Swamp\southern_swamp_cleared_scene"  -Offset "1F0D000" -Length "10630"
        ExportAndPatch -Path "Southern Swamp\southern_swamp_cleared_room_0" -Offset "1F1E000" -Length "1B240" -NewLength "1B4F0" -TableOffset "1EC26"  -Values @("94", "F0")
        ExportAndPatch -Path "Southern Swamp\southern_swamp_cleared_room_2" -Offset "1F4D000" -Length "D0A0"  -NewLength "D1C0"  -TableOffset "1EC46"  -Values @("A1", "C0")
    }

    if (IsChecked -Elem $Options.DisableLowHPSound -Enabled)   { ChangeBytes -Offset "B97E2A"  -Values @("00", "00") }
    if (IsChecked -Elem $Options.FixGohtCutscene   -Enabled)   { ChangeBytes -Offset "F6DE89"  -Values @("8D", "00", "02", "10", "00", "00", "0A") }
    if (IsChecked -Elem $Options.FixMushroomBottle -Enabled)   { ChangeBytes -Offset "CD7C48"  -Values @("1E", "6B") }
    if (IsChecked -Elem $Options.FixFairyFountain  -Enabled)   { ChangeBytes -Offset "B9133E"  -Values @("01", "0F") }

}



#==============================================================================================================================================================================================
function PatchByteReduxMM() {
    
    # D-PAD #

    if ( (IsChecked -Elem $Redux.DPadLayoutHide -Enabled) -or (IsChecked -Elem $Redux.DPadLayoutLeft -Enabled) -or (IsChecked -Elem $Redux.DPadLayoutRight -Enabled) ) {
        $Array = @()
        $Array += GetItemIDMM -Item $Redux.DPadUp.Text
        $Array += GetItemIDMM -Item $Redux.DPadRight.Text
        $Array += GetItemIDMM -Item $Redux.DPadDown.Text
        $Array += GetItemIDMM -Item $Redux.DPadLeft.Text
        ChangeBytes -Offset "3806354" -Values $Array

        if (IsChecked -Elem $Redux.DPadLayoutLeft -Enabled)        { ChangeBytes -Offset "3806364" -Values @("01", "01") }
        elseif (IsChecked -Elem $Redux.DPadLayoutRight -Enabled)   { ChangeBytes -Offset "3806364" -Values @("01", "02") }
        else                                                       { ChangeBytes -Offset "3806364" -Values "01" }
    }



    # GAMEPLAY

    if ( (IsChecked -Elem $Redux.EasierMinigames -Not) -and (IsChecked -Elem $Redux.FasterBlockPushing) )       { ChangeBytes -Offset "3806530" -Values @("9E", "45", "06", "2D", "57", "4B", "28", "62", "49", "87", "69", "FB", "0F", "79", "1B", "9F", "18", "30") }
    elseif ( (IsChecked -Elem $Redux.EasierMinigames) -and (IsChecked -Elem $Redux.FasterBlockPushing -Not) )   { ChangeBytes -Offset "3806530" -Values @("D2", "AD", "24", "8F", "0C", "58", "D0", "A8", "96", "55", "0E", "EE", "D2", "2B", "25", "EB", "08", "30") }
    elseif ( (IsChecked -Elem $Redux.EasierMinigames) -and (IsChecked -Elem $Redux.FasterBlockPushing) )        { ChangeBytes -Offset "3806530" -Values @("B7", "36", "99", "48", "85", "BF", "FF", "B1", "FB", "EB", "D8", "B1", "06", "C8", "A8", "3B", "18", "30") }
    #ChangeBytes -Offset "3806530" -Values @("00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "BE", "70")

}


#==============================================================================================================================================================================================
function PatchBPSOptionsMM() {
    
    

}



#==============================================================================================================================================================================================
function PatchLanguageOptionsMM() {
    
    if ( (IsChecked -Elem $Languages.TextRestore -Enabled) ) {
        $File = $GameFiles.binaries + "\" + "Message\Message Data Static MM.bin"
        ExportBytes -Offset "AD1000" -Length "699F0" -Output $File
    }

    if (IsChecked -Elem $Languages.TextRestore -Enabled) {
        ChangeBytes -Offset "1A6D6"  -Values @("AC", "A0")
        PatchBytes  -Offset "C5D0D8" -Patch "Message\Table.bin"
        ApplyPatch -File $File -Patch "\Data Extraction\Message\Message Data Static MM.bps" -FilesPath
        #ExportAndPatch -Path "Message\Message Data Static MM"  -Offset "AD1000" -Length "699F0"
    }

    if (IsChecked -Elem $Languages.CorrectCircusMask -Enabled) {
        PatchBytes -Offset "A2DDC4" -Length "26F" -Texture -Patch "Troupe Leader's Mask.yaz0"

        if (IsChecked -Elem $Languages.TextRestore -Enabled) {
            ChangeBytes -Offset "AD4431" -Values @("54", "72", "6F", "75", "70", "65"); ChangeBytes -Offset "B12DF0" -Values @("54", "72", "6F", "75", "70", "65"); ChangeBytes -Offset "B1BA02" -Values @("54", "72", "6F", "75", "70", "65")
            ChangeBytes -Offset "B1F741" -Values @("54", "72", "6F", "75", "70", "65"); ChangeBytes -Offset "B20924" -Values @("74", "72", "6F", "75", "70", "65"); ChangeBytes -Offset "B21504" -Values @("54", "72", "6F", "75", "70", "65")
            ChangeBytes -Offset "B22E13" -Values @("54", "72", "6F", "75", "70", "65")
        }
        else {
            ChangeBytes -Offset "AD423D" -Values @("54", "72", "6F", "75", "70", "65"); ChangeBytes -Offset "B12B60" -Values @("54", "72", "6F", "75", "70", "65"); ChangeBytes -Offset "B1B766" -Values @("54", "72", "6F", "75", "70", "65")
            ChangeBytes -Offset "B1F495" -Values @("54", "72", "6F", "75", "70", "65"); ChangeBytes -Offset "B20678" -Values @("74", "72", "6F", "75", "70", "65"); ChangeBytes -Offset "B21258" -Values @("54", "72", "6F", "75", "70", "65")
            ChangeBytes -Offset "B22B67" -Values @("54", "72", "6F", "75", "70", "65")
        }
    }

    if (IsChecked -Elem $Languages.TextRazorSword -Enabled) {
        $Offset = SearchBytes -File $File -Values @("54", "68", "69", "73", "20", "6E", "65", "77", "2C", "20", "73", "68", "61", "72", "70", "65", "72", "20", "62", "6C", "61", "64", "65")
        ChangeBytes -File $File -Offset ( Get24Bit -Value ( (GetDecimal -Hex $Offset) + (GetDecimal -Hex "38") ) ) -Values @("61", "73", "20", "6D", "75", "63", "68", "11", "79", "6F", "75", "20", "77", "61", "6E", "74", "20")

        $Offset = SearchBytes -File $File -Values @("54", "68", "65", "20", "4B", "6F", "6B", "69", "72", "69", "20", "53", "77", "6F", "72", "64", "20", "72", "65", "66", "6F", "72", "67", "65", "64")
        ChangeBytes -File $File -Offset ( Get24Bit -Value ( (GetDecimal -Hex $Offset) + (GetDecimal -Hex "30") ) ) -Values @("61", "73", "20", "6D", "75", "63", "68", "20", "79", "6F", "75", "20", "77", "61", "6E", "74", "2E", "20")

        $Offset = SearchBytes -File $File -Values @("4B", "65", "65", "70", "20", "69", "6E", "20", "6D", "69", "6E", "64", "20", "74", "68", "61", "74")
        PatchBytes  -File $File -Offset $Offset -Patch "Message\Razor Sword 1.bin"

        $Offset = SearchBytes -File $File -Values @("4E", "6F", "77", "20", "6B", "65", "65", "70", "20", "69", "6E", "20", "6D", "69", "6E", "64", "20", "74", "68", "61", "74")
        PatchBytes  -File $File -Offset $Offset -Patch "Message\Razor Sword 2.bin"
    }

    if ( (IsChecked -Elem $Languages.TextRestore -Enabled) ) {
        PatchBytes -Offset "AD1000" -Patch ("Message\Message Data Static MM.bin")
    }

}



#==============================================================================================================================================================================================
function GetItemIDMM([String]$Item) {
    
    if ($Item -eq "None")                { return "FF" }
    if ($Item -eq "Ocarina of Time")     { return "00" }
    if ($Item -eq "Deku Mask")           { return "32" }
    if ($Item -eq "Goron Mask")          { return "33" }
    if ($Item -eq "Zora Mask")           { return "34" }
    if ($Item -eq "Fierce Deity's Mask") { return "35" }

}



#==============================================================================================================================================================================================
function PatchOptionsSM64() {
    
    if ( !(IsChecked -Elem $PatchOptionsCheckbox -Visible) -or !$GamePatch.options) { return }
    UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Additional Options...")

    Copy-Item -LiteralPath $Files.ROM -Destination $Files.decompressedROM



    # BPS Patching

    if (IsChecked -Elem $Options.FPS -Enabled)                 { ApplyPatch -File $Files.decompressedROM -Patch "\Compressed\fps.bps" }
    if (IsChecked -Elem $Options.FreeCam -Enabled)             { ApplyPatch -File $Files.decompressedROM -Patch "\Compressed\cam.bps" }



    # Byte Patching

    $Global:ByteArrayGame = [IO.File]::ReadAllBytes($Files.decompressedROM)


    # HERO MODE

    if (IsText -Elem $Options.Damage -Text "2x Damage" -Enabled)       { ChangeBytes -Offset "F207" -Values @("80") }
    elseif (IsText -Elem $Options.Damage -Text "3x Damage" -Enabled)   { ChangeBytes -Offset "F207" -Values @("40") }



    # GRAPHICS #

    if (IsChecked -Elem $Options.WideScreen -Enabled) {
        ChangeBytes -Offset "3855E" -Values @("47", "40")
        ChangeBytes -Offset "35456" -Values @("46", "C0")
    }

    if (IsChecked -Elem $Options.ForceHiresModel -Enabled)     { ChangeBytes -Offset "32184" -Values @("10", "00")}
    
    if (IsChecked -Elem $Options.BlackBars -Enabled) {
        ChangeBytes -Offset "23A7" -Values @("BC", "00") -Interval 12
        ChangeBytes -Offset "248E" -Values @("00")
        ChangeBytes -Offset "2966" -Values @("00", "00") -Interval 48
        ChangeBytes -Offset "3646A" -Values @("00")
        ChangeBytes -Offset "364AA" -Values @("00")
        ChangeBytes -Offset "364F6" -Values @("00")
        ChangeBytes -Offset "36582" -Values @("00")
        ChangeBytes -Offset "3799F" -Values @("BC", "00") -Interval 12
    }



    # GAMEPLAY #
    if (IsChecked -Elem $Options.LagFix -Enabled)              { ChangeBytes -Offset "F0022" -Values @("0D") }



    [io.file]::WriteAllBytes($Files.decompressedROM, $ByteArrayGame)

}



#==============================================================================================================================================================================================
function CreateOoTOptionsContent() {
    
    CreateOptionsDialog -Width 900 -Height 650
    $ToolTip = CreateTooltip



    # HERO MODE #
    $HeroModeBox                       = CreateReduxGroup -Y 50 -Height 1 -AddTo $Options.Panel -Text "Hero Mode"

    $Options.Damage                    = CreateReduxComboBox -Column 0 -Row 1 -AddTo $HeroModeBox -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage", "OKHO Mode") -Text "Damage:" -ToolTip $ToolTip -Info "Set the amount of damage you receive`nOKHO Mode = You die in one hit" -Name "Damage"
    $Options.Recovery                  = CreateReduxComboBox -Column 2 -Row 1 -AddTo $HeroModeBox -Items @("1x Recovery", "1/2x Recovery", "1/4x Recovery", "0x Recovery") -Text "Recovery:" -ToolTip $ToolTip -Info "Set the amount health you recovery from Recovery Hearts" -Name "Recovery"
    $Options.SelectMQDungeons          = CreateReduxButton   -Column 4 -Row 1 -AddTo $HeroModeBox -Text "Set Master Quest" -ToolTip $ToolTip -Info "Select the dungeons you want from Master Quest to patch into Ocarina of Time"
    $Options.SelectMQDungeons.Add_Click( { $Options.MasterQuestDungeonsDialog.ShowDialog() } )
    #$Options.BossHP                    = CreateReduxComboBox -Column 0 -Row 2 -AddTo $HeroModeBox -Items @("1x Boss HP", "2x Boss HP", "3x Boss HP")          -Text "Boss HP:"    -ToolTip $ToolTip -Info "Set the amount of health for bosses"   -Name "BossHP"
    #$Options.MonsterHP                 = CreateReduxComboBox -Column 2 -Row 2 -AddTo $HeroModeBox -Items @("1x Monster HP", "2x Monster HP", "3x Monster HP") -Text "Monster HP:" -ToolTip $ToolTip -Info "Set the amount of health for monsters" -Name "MonsterHP"



    # GRAPHICS / Sound #
    $GraphicsBox                       = CreateReduxGroup -Y ($HeroModeBox.Bottom + 5) -Height 2 -AddTo $Options.Panel -Text "Graphics / Sound"
    
    $Options.Widescreen                = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $GraphicsBox -Text "16:9 Widescreen"        -ToolTip $ToolTip -Info "Native 16:9 widescreen display support" -Name "Widescreen"
    $Options.WidescreenTextures        = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $GraphicsBox -Text "16:9 Textures"          -ToolTip $ToolTip -Info "16:9 backgrounds and textures suitable for native 16:9 widescreen display support" -Name "WideScreenTextures"
    $Options.BlackBars                 = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $GraphicsBox -Text "No Black Bars"          -ToolTip $ToolTip -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes" -Name "BlackBars"
    $Options.ExtendedDraw              = CreateReduxCheckBox -Column 3 -Row 1 -AddTo $GraphicsBox -Text "Extended Draw Distance" -ToolTip $ToolTip -Info "Increases the game's draw distance for objects`nDoes not work on all objects" -Name "ExtendedDraw"
    $Options.ForceHiresModel           = CreateReduxCheckBox -Column 4 -Row 1 -AddTo $GraphicsBox -Text "Force Hires Link Model" -ToolTip $ToolTip -Info "Always use Link's High Resolution Model when Link is too far away" -Name "ForceHiresModel"

    $Options.Models                    = CreateReduxComboBox -Column 0 -Row 2 -AddTo $GraphicsBox -Items @("No Model Replacements", "Replace Child Model Only", "Replace Adult Model Only", "Replace Both Models", "Change to Female Models") -Text "Link's Models:" -ToolTip $ToolTip -Info "1. Replace the model for Child Link with that of Majora's Mask`n2. Replace the model for Adult Link to be Majora's Mask-styled`n3. Combine both previous options`n4. Transform Link into a female" -Name "Models"
    $Options.Voices                    = CreateReduxComboBox -Column 2 -Row 2 -AddTo $GraphicsBox -Items @("No Voice Changes", "Majora's Mask Link Voices", "Feminine Link Voices") -Text "Voice:" -ToolTip $ToolTip -Info "1. Replace the voices for Link with those used in Majora's Mask`n2. Replace the voices for Link to sound feminine" -Name "Voices"
    $Options.DisableLowHPSound         = CreateReduxCheckBox -Column 4 -Row 2 -AddTo $GraphicsBox -Text "Disable Low HP Beep"    -ToolTip $ToolTip -Info "There will be absolute silence when Link's HP is getting low" -Name "DisableLowHPSound"
    


    # INTERFACE #
    $InterfaceBox                      = CreateReduxGroup -Y ($GraphicsBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Interface"

    $Options.HudTextures               = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $InterfaceBox -Text "MM HUD Textures"                 -ToolTip $ToolTip -Info "Replaces the HUD textures with those froom Majora's Mask" -Name "HudTextures"
    $Options.ButtonPositions           = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $InterfaceBox -Text "MM Button Positions"             -ToolTip $ToolTip -Info "Positions the A and B buttons like in Majora's Mask" -Name "ButtonPositions"
    $Options.PauseScreen               = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $InterfaceBox -Text "MM Pause Screen"                 -ToolTip $ToolTip -Info "Replaces the Pause Screen textures to be styled like Majora's Mask" -Name "PauseScreen"
    


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

    $Options.FasterBlockPushing        = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $GameplayBox -Text "Faster Block Pushing"   -ToolTip $ToolTip -Info "All blocks are pushed faster" -Name "FasterBlockPushing"
    $Options.EasierMinigames           = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $GameplayBox -Text "Easier Minigames"       -ToolTip $ToolTip -Info "Certain minigames are made easier and faster`n- Dampe's Digging Game is first try always`n- Fishing is less random and has less demanding requirements" -Name "EasierMinigames"
    $Options.ReturnChild               = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $GameplayBox -Text "Can Always Return"      -ToolTip $ToolTip -Info "You can always go back to being a child again before clearing the boss of the Forest Temple`nOut of the way Sheik!" -Name "ReturnChild"
    $Options.Medallions                = CreateReduxCheckBox -Column 3 -Row 1 -AddTo $GameplayBox -Text "Require All Medallions" -ToolTip $ToolTip -Info "All six medallions are required for the Rainbow Bridge to appear before Ganon's Castle`nThe vanilla requirements were the Shadow and Spirit Medallions and the Light Arrows" -Name "Medallions"
    


    # RESTORE #
    $RestoreBox                        = CreateReduxGroup -Y ($GameplayBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Restore / Correct / Censor"

    $Options.CorrectRupeeColors        = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $RestoreBox -Text "Correct Rupee Colors"   -ToolTip $ToolTip -Info "Corrects the colors for the Purple (50) and Golden (200) Rupees" -Name "CorrectRupeeColors"
    $Options.RestoreCowNoseRing        = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $RestoreBox -Text "Restore Cow Nose Ring"  -ToolTip $ToolTip -Info "Restore the rings in the noses for Cows as seen in the Japanese release" -Name "RestoreCowNoseRing"
    $Options.RestoreFireTemple         = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $RestoreBox -Text "Restore Fire Temple"    -ToolTip $ToolTip -Info "Restore the censored Fire Temple theme used since the Rev 2 ROM" -Name "RestoreFireTemple"
    $Options.CensorGerudoTextures      = CreateReduxCheckBox -Column 3 -Row 1 -AddTo $RestoreBox -Text "Censor Gerudo Textures" -ToolTip $ToolTip -Info "Restore the censored Gerudo symbol textures used in the GameCube / Virtual Console releases`n- Disable the option to uncensor the Gerudo Texture used in the Master Quest dungeons" -Name "CensorGerudoTextures"
    


    # EQUIPMENT #
    $EquipmentBox                      = CreateReduxGroup -Y ($RestoreBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Equipment"
    
    $Options.UnlockSword               = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $EquipmentBox -Text "Unlock Kokiri Sword" -ToolTip $ToolTip -Info "Adult Link is able to use the Kokiri Sword`nThe Kokiri Sword does half as much damage as the Master Sword" -Name "UnlockSword"
    $Options.UnlockTunics              = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $EquipmentBox -Text "Unlock Tunics"       -ToolTip $ToolTip -Info "Child Link is able to use the Goron Tunic and Zora Tunic`nSince you might want to walk around in style as well when you are young" -Name "UnlockTunics"
    $Options.UnlockBoots               = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $EquipmentBox -Text "Unlock Boots"        -ToolTip $ToolTip -Info "Child Link is able to use the Iron Boots and Hover Boots" -Name "UnlockBoots"

    $Options.Capacity                  = CreateReduxButton   -Column 3 -Row 1 -AddTo $EquipmentBox -Text "Set Capacity"        -ToolTip $OptionsToolTip -Info "Select the capacity values you want for ammo and wallets"
    $Options.Capacity.Add_Click( { $Options.CapacityDialog.ShowDialog() } )



    # EVERYTHING ELSE #
    $OtherBox                          = CreateReduxGroup -Y ($EquipmentBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Other"
    
    $Options.SubscreenDelayFix         = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $OtherBox -Text "Pause Screen Delay Fix" -ToolTip $ToolTip -Info "Removes the delay when opening the Pause Screen" -Name "SubscreenDelayFix"
    $Options.DisableNaviPrompts        = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $OtherBox -Text "Remove Navi Prompts" -ToolTip $ToolTip -Info "Navi will no longer interupt your during the first dungeon with mandatory textboxes" -Name "DisableNaviPrompts"
    $Options.DefaultZTargeting         = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $OtherBox -Text "Default Hold Z-Targeting" -ToolTip $ToolTip -Info "Change the Default Z-Targeting option to Hold instead of Switch" -Name "DefaultZTargeting"



    CreateMasterQuestDungeonsDialog
    CreateCapacityDialog

    $Options.Damage.Add_SelectedIndexChanged({ $Options.Recovery.Enabled = $this.Text -ne "OKHO Mode" })
    $Options.EnableTunicColors.Add_CheckStateChanged({
        $Options.KokiriTunicColor.Enabled = $Options.GoronTunicColor.Enabled = $Options.ZoraTunicColor.Enabled = $this.Checked
        $Options.ResetAllColors.Enabled = $this.Enabled -or $Options.EnableGauntletColors.Enabled
    })
    $Options.EnableGauntletColors.Add_CheckStateChanged({
        $Options.SilverGauntletsColor.Enabled = $Options.GoldenGauntletsColor.Enabled = $this.Checked
        $Options.ResetAllColors.Enabled = $Options.EnableTunicColors.Checked -or $this.Checked
    })

    $Options.Recovery.Enabled = $Options.Damage.Text -ne "OKHO Mode"
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
function CreateOoTReduxContent() {
    
    CreateReduxDialog -Width 730 -Height 320
    $ToolTip = CreateTooltip



    # INTERFACE #
    $InterfaceBox                      = CreateReduxGroup -Y 50 -Height 1 -AddTo $Redux.Panel -Text "Interface"

    $Redux.ShowFileSelectIcons         = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $InterfaceBox -Text "Show File Select Icons" -Checked -ToolTip $ToolTip -Info "Show icons on the File Select screen to display your save file progress`n- Requires Redux patch" -Name "ShowFileSelectIcons"
    $Redux.DPadLayoutShow              = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $InterfaceBox -Text "Show D-Pad Icon"        -Checked -ToolTip $ToolTip -Info "Show the D-Pad icons ingame that display item shortcuts`n- Requires Redux patch" -Name "DPadLayoutShow"

    

    # COLORS #
    $ColorsBox                         = CreateReduxGroup -Y ($InterfaceBox.Bottom + 5) -Height 3 -AddTo $Redux.Panel -Text "Colors"

    $Redux.EnableButtonColors          = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $ColorsBox -Text "Change Button Colors"       -ToolTip $ToolTip -Info "Enable changing the color for the buttons`n- Requires Redux patch" -Name "EnableButtonColors"
    $Redux.ResetAllColors              = CreateReduxButton   -Column 1 -Row 1 -AddTo $ColorsBox -Text "Reset All Colors"           -ToolTip $ToolTip -Info "Reset all colors to their default values"

    $Redux.AButtonColor                = CreateReduxButton   -Column 0 -Row 2 -AddTo $ColorsBox -Text "Set A Button Color"         -ToolTip $ToolTip -Info "Select the color you want for the A button"
    $Redux.BButtonColor                = CreateReduxButton   -Column 1 -Row 2 -AddTo $ColorsBox -Text "Set B Button Color"         -ToolTip $ToolTip -Info "Select the color you want for the B button"
    $Redux.CButtonColor                = CreateReduxButton   -Column 2 -Row 2 -AddTo $ColorsBox -Text "Set C Button Color"         -ToolTip $ToolTip -Info "Select the color you want for the C buttons"
    $Redux.SButtonColor                = CreateReduxButton   -Column 3 -Row 2 -AddTo $ColorsBox -Text "Set Start Button Color"     -ToolTip $ToolTip -Info "Select the color you want for the Start button"

    $Redux.N64OoTColors                = CreateReduxButton   -Column 0 -Row 3 -AddTo $ColorsBox -Text "N64 OoT Button Colors"      -ToolTip $ToolTip -Info "Set the button colors to match the Nintendo 64 revision of Ocarina of Time"
    $Redux.N64MMColors                 = CreateReduxButton   -Column 1 -Row 3 -AddTo $ColorsBox -Text "N64 MM Button Colors"       -ToolTip $ToolTip -Info "Set the button colors to match the Nintendo 64 revision of Majora's mask"
    $Redux.GCOoTColors                 = CreateReduxButton   -Column 2 -Row 3 -AddTo $ColorsBox -Text "GC OoT Button Colors"       -ToolTip $ToolTip -Info "Set the button colors to match the GameCube revision of Ocarina of Time"
    $Redux.GCMMColors                  = CreateReduxButton   -Column 3 -Row 3 -AddTo $ColorsBox -Text "GC MM Button Colors"        -ToolTip $ToolTip -Info "Set the button colors to match the GameCube revision of Majora's Mask"

    $Redux.ResetAllColors.Add_Click( {
        SetButtonColors -A "5A5AFF" -B "009600" -C "FFA000" -Start "C80000"
        $Redux.SetAButtonColor.Color         = "#5A5AFF"; $Settings[$GameType.mode][$Redux.SetAButtonColor.Tag]         = $Redux.SetAButtonColor.Color.Name
        $Redux.SetBButtonColor.Color         = "#009600"; $Settings[$GameType.mode][$Redux.SetBButtonColor.Tag]         = $Redux.SetBButtonColor.Color.Name
        $Redux.SetCButtonColor.Color         = "#FFFA00"; $Settings[$GameType.mode][$Redux.SetCButtonColor.Tag]         = $Redux.SetCButtonColor.Color.Name
        $Redux.SetSButtonColor.Color         = "#C80000"; $Settings[$GameType.mode][$Redux.SetSButtonColor.Tag]         = $Redux.SetSButtonColor.Color.Name
    } )

    $Redux.AButtonColor.Add_Click(         { $Redux.SetAButtonColor.ShowDialog();         $Settings[$GameType.mode][$Redux.SetAButtonColor.Tag] = $Redux.SetAButtonColor.Color.Name } )
    $Redux.BButtonColor.Add_Click(         { $Redux.SetBButtonColor.ShowDialog();         $Settings[$GameType.mode][$Redux.SetBButtonColor.Tag] = $Redux.SetBButtonColor.Color.Name } )
    $Redux.CButtonColor.Add_Click(         { $Redux.SetCButtonColor.ShowDialog();         $Settings[$GameType.mode][$Redux.SetCButtonColor.Tag] = $Redux.SetCButtonColor.Color.Name } )
    $Redux.SButtonColor.Add_Click(         { $Redux.SetSButtonColor.ShowDialog();         $Settings[$GameType.mode][$Redux.SetSButtonColor.Tag] = $Redux.SetSButtonColor.Color.Name } )

    $Redux.N64OoTColors.Add_Click(         { SetButtonColors -A "5A5AFF" -B "009600" -C "FFA000" -Start "C80000" } )
    $Redux.N64MMColors.Add_Click(          { SetButtonColors -A "64C8FF" -B "64FF78" -C "FFF000" -Start "FF823C" } )
    $Redux.GCOoTColors.Add_Click(          { SetButtonColors -A "00C832" -B "FF1E1E" -C "FFA000" -Start "787878" } )
    $Redux.GCMMColors.Add_Click(           { SetButtonColors -A "64FF78" -B "FF6464" -C "FFF000" -Start "787878" } )



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
function CreateMMOptionsContent() {
    
    CreateOptionsDialog -Width 900 -Height 560
    $ToolTip = CreateTooltip



    # HERO MODE #
    $HeroModeBox                       = CreateReduxGroup -Y 50 -Height 1 -AddTo $Options.Panel -Text "Hero Mode"

    $Options.Damage                    = CreateReduxComboBox -Column 0 -Row 1 -AddTo $HeroModeBox -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage", "OKHO Mode") -Text "Damage:" -ToolTip $OptionsToolTip -Info "Set the amount of damage you receive`nOKHO Mode = You die in one hit" -Name "Damage"
    $Options.Recovery                  = CreateReduxComboBox -Column 2 -Row 1 -AddTo $HeroModeBox -Items @("1x Recovery", "1/2x Recovery", "1/4x Recovery", "0x Recovery") -Text "Recovery:" -ToolTip $OptionsToolTip -Info "Set the amount health you recovery from Recovery Hearts" -Name "Recovery"
    #$Options.BossHP                   = CreateReduxComboBox -Column 0 -Row 2 -AddTo $HeroModeBox -Items @("1x Boss HP", "2x Boss HP", "3x Boss HP") -Text "Boss HP:" -ToolTip $OptionsToolTip -Info "Set the amount of health for bosses" -Name "BossHP"



    # GRAPHICS #
    $GraphicsBox                       = CreateReduxGroup -Y ($HeroModeBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Graphics"
    
    $Options.Widescreen                = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $GraphicsBox -Text "16:9 Widescreen"         -ToolTip $ToolTip -Info "Native 16:9 Widescreen Display support" -Name "Widescreen"
    $Options.WidescreenTextures        = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $GraphicsBox -Text "16:9 Textures"           -ToolTip $ToolTip -Info "16:9 backgrounds and textures suitable for native 16:9 widescreen display support" -Name "WidescreenTextures"
    $Options.BlackBars                 = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $GraphicsBox -Text "No Black Bars"           -ToolTip $ToolTip -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes" -Name "BlackBars"
    $Options.ExtendedDraw              = CreateReduxCheckBox -Column 3 -Row 1 -AddTo $GraphicsBox -Text "Extended Draw Distance"  -ToolTip $ToolTip -Info "Increases the game's draw distance for objects`nDoes not work on all objects" -Name "ExtendedDraw"
    $Options.PixelatedStars            = CreateReduxCheckBox -Column 4 -Row 1 -AddTo $GraphicsBox -Text "Disable Pixelated Stars" -ToolTip $ToolTip -Info "Completely disable the stars at night-time, which are pixelated dots and do not have any textures for HD replacement" -Name "PixelatedStars"
    


    # COLORS #
    $ColorsBox                         = CreateReduxGroup -Y ($GraphicsBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Colors"
    $Options.EnableTunicColors         = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $ColorsBox -Text "Change Tunic Color"       -ToolTip $ToolTip -Info "Enable changing the color for the Hylian form Kokiri tunics" -Name "EnableTunicColors"
    $Options.KokiriTunicColor          = CreateReduxButton   -Column 1 -Row 1 -AddTo $ColorsBox -Text "Set Kokiri Tunic Color"   -ToolTip $ToolTip -Info "Select the color you want for the Kokiri Tunic"
    $Options.ResetAllColors            = CreateReduxButton   -Column 2 -Row 1 -AddTo $ColorsBox -Text "Reset Kokiri Tunic Color" -ToolTip $ToolTip -Info "Reset the  color for the Kokiri Tunic to it's default value"
    
    $Options.KokiriTunicColor.Add_Click( { $Options.SetKokiriTunicColor.ShowDialog(); $Settings[$GameType.mode][$Options.SetKokiriTunicColor.Tag] = $Options.SetKokiriTunicColor.Color.Name } )
    $Options.ResetAllColors.Add_Click( { $Settings[$GameType.mode][$Options.SetKokiriTunicColor.Tag] = $Options.SetKokiriTunicColor.Color.Name; $Options.SetKokiriTunicColor.Color = "#1E691B" } )



    # GAMEPLAY #
    $GameplayBox                       = CreateReduxGroup -Y ($ColorsBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Gameplay"

    $Options.ZoraPhysics               = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $GameplayBox -Text "Zora Physics"          -ToolTip $ToolTip -Info "Change the Zora physics when using the boomerang`nZora Link will take a step forward instead of staying on his spot" -Name "ZoraPhysics"
    $Options.RestorePalaceRoute        = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $GameplayBox -Text "Restore Palace Route"  -ToolTip $ToolTip -Info "Restore the route to the Bean Seller within the Deku Palace as seen in the Japanese release" -Name "RestorePalaceRoute"
    #$Options.ResearchLabPlatform      = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $GameplayBox -Text "Research Lab Platform" -ToolTip $ToolTip -Info "Raises the platform to access the Marine Research Lab in the Great Bay Coast as seen in the Japanese release" -Name "ResearchLabPlatform"
    #$Options.RanchDirtRoad            = CreateReduxCheckBox -Column 3 -Row 1 -AddTo $GameplayBox -Text "Ranch Dirt Road"       -ToolTip $ToolTip -Info "Restore the Romani Ranch dirt road to allow Deku Link to borrow in it as used in the Japanese release" -Name "RanchDirtRoad"



    # RESTORE #
    $RestoreBox                        = CreateReduxGroup -Y ($GameplayBox.Bottom + 5) -Height 2 -AddTo $Options.Panel -Text "Restore / Correct"

    $Options.CorrectRupeeColors        = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $RestoreBox -Text "Correct Rupee Colors"     -ToolTip $ToolTip -Info "Corrects the colors for the Purple (50) and Golden (200) Rupees" -Name "CorrectRupeeColors"
    $Options.RestoreCowNoseRing        = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $RestoreBox -Text "Restore Cow Nose Ring"    -ToolTip $ToolTip -Info "Restore the rings in the noses for Cows as seen in the Japanese release" -Name "RestoreCowNoseRing"
    $Options.CorrectRomaniSign         = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $RestoreBox -Text "Correct Romani Sign"      -ToolTip $ToolTip -Info "Replace the Romani Sign texture to display Romani's Ranch instead of Kakariko Village" -Name "CorrectRomaniSign"
    $Options.CorrectComma              = CreateReduxCheckBox -Column 3 -Row 1 -AddTo $RestoreBox -Text "Correct Comma"            -ToolTip $ToolTip -Info "Make the comma not look as awful" -Name "CorrectComma"
    $Options.RestoreTitle              = CreateReduxCheckBox -Column 4 -Row 1 -AddTo $RestoreBox -Text "Restore Title"            -ToolTip $ToolTip -Info "Restore the title logo colors as seen in the Japanese release" -Name "RestoreTitle"
    $Options.RestoreSkullKid           = CreateReduxCheckBox -Column 0 -Row 2 -AddTo $RestoreBox -Text "Restore Skull Kid"        -ToolTip $ToolTip -Info "Restore Skull Kid's face as seen in the Japanese release" -Name "RestoreSkullKid"
    $Options.RestoreShopMusic          = CreateReduxCheckBox -Column 1 -Row 2 -AddTo $RestoreBox -Text "Restore Shop Music"       -ToolTip $ToolTip -Info "Restores the Shop music intro theme as heard in the Japanese release" -Name "RestoreShopMusic"
    $Options.PieceOfHeartSound         = CreateReduxCheckBox -Column 2 -Row 2 -AddTo $RestoreBox -Text "4th Piece of Heart Sound" -ToolTip $ToolTip -Info "Restore the sound effect when collecting the fourth Piece of Heart that grants Link a new Heart Container" -Name "PieceOfHeartSound"
    $Options.MoveBomberKid             = CreateReduxCheckBox -Column 3 -Row 2 -AddTo $RestoreBox -Text "Move Bomber Kid"          -ToolTip $ToolTip -Info "Moves the Bomber at the top of the Stock Pot Inn to be behind the bell like in the original Japanese ROM" -Name "MoveBomberKid"



    # EQUIPMENT #
    $EquipmentBox                      = CreateReduxGroup -Y ($RestoreBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Equipment"
    
    $Options.RazorSword                = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $EquipmentBox -Text "Permanent Razor Sword" -ToolTip $ToolTip -Info "The Razor Sword won't get destroyed after 100 it`nYou can also keep the Razor Sword when traveling back in time" -Name "RazorSword"

    $Options.Capacity                  = CreateReduxButton   -Column 1 -Row 1 -AddTo $EquipmentBox -Text "Set Capacity"          -ToolTip $ToolTip -Info "Select the capacity values you want for ammo and wallets"
    $Options.Capacity.Add_Click( { $Options.CapacityDialog.ShowDialog() } )



    # EVERYTHING ELSE #
    $OtherBox                          = CreateReduxGroup -Y ($EquipmentBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Other"

    $Options.DisableLowHPSound         = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $OtherBox -Text "Disable Low HP Beep" -ToolTip $ToolTip -Info "There will be absolute silence when Link's HP is getting low" -Name "DisableLowHPSound"
    $Options.FixGohtCutscene           = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $OtherBox -Text "Fix Goht Cutscene"   -ToolTip $ToolTip -Info "Fix Goht's awakening cutscene so that Link no longer gets run over" -Name "FixGohtCutscene"
    $Options.FixMushroomBottle         = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $OtherBox -Text "Fix Mushroom Bottle" -ToolTip $ToolTip -Info "Fix the item reference when collecting Magical Mushrooms as Link puts away the bottle automatically due to an error" -Name "FixMushroomBottle"
    $Options.FixSouthernSwamp          = CreateReduxCheckBox -Column 3 -Row 1 -AddTo $OtherBox -Text "Fix Southern Swamp"  -ToolTip $ToolTip -Info "Fix a misplaced door after Woodfall has been cleared and you return to the Potion Shop`nThe door is slightly pushed forward after Odolwa has been defeated." -Name "FixSouthernSwamp"
    $Options.FixFairyFountain          = CreateReduxCheckBox -Column 4 -Row 1 -AddTo $OtherBox -Text "Fix Fairy Fountain"  -ToolTip $ToolTip -Info "Fix the Ikana Canyon Fairy Fountain area not displaying the correct color." -Name "FixFairyFountain"



    CreateCapacityDialog
    
    $Options.Damage.Add_SelectedIndexChanged({ $Options.Recovery.Enabled = $this.Text -ne "OKHO Mode" })
    $Options.EnableTunicColors.Add_CheckStateChanged({ $Options.KokiriTunicColor.Enabled = $Options.ResetAllColors.Enabled = $this.Checked })

    $Options.Recovery.Enabled = $Options.Damage.Text -ne "OKHO Mode"
    $Options.KokiriTunicColor.Enabled = $Options.ResetAllColors.Enabled = $Options.EnableTunicColors.Checked

    $Options.SetKokiriTunicColor       = CreateColorDialog -Red "1E" -Green "69" -Blue "1B" -Name "SetKokiriTunicColor"     -IsGame

}



#==============================================================================================================================================================================================
function CreateMMReduxContent() {

    CreateReduxDialog -Width 700 -Height 290
    $ToolTip = CreateTooltip



    # D-PAD #
    $DPadBox                           = CreateReduxGroup -Y 50 -Height 2 -AddTo $Redux.Panel -Text "D-Pad Icons Layout"
    
    $DPadPanel                         = CreateReduxPanel -Row 0 -Columns 4 -AddTo $DPadBox
    $Redux.DPadDisable                 = CreateReduxRadioButton -Column 0 -Row 0 -AddTo $DPadPanel -Checked -Disable -Text "Disable"    -ToolTip $ToolTip -Info "Completely disable the D-Pad`n- Requires Redux patch"                      -Name "DPadDisable"
    $Redux.DPadLayoutHide              = CreateReduxRadioButton -Column 1 -Row 0 -AddTo $DPadPanel          -Disable -Text "Hidden"     -ToolTip $ToolTip -Info "Hide the D-Pad icons, while they are still active`n- Requires Redux patch" -Name "DPadLayoutHide"
    $Redux.DPadLayoutLeft              = CreateReduxRadioButton -Column 2 -Row 0 -AddTo $DPadPanel          -Disable -Text "Left Side"  -ToolTip $ToolTip -Info "Show the D-Pad icons on the left side of the HUD`n- Requires Redux patch"  -Name "DPadLayoutLeft"
    $Redux.DPadLayoutRight             = CreateReduxRadioButton -Column 3 -Row 0 -AddTo $DPadPanel          -Disable -Text "Right Side" -ToolTip $ToolTip -Info "Show the D-Pad icons on the right side of the HUD`n- Requires Redux patch" -Name "DPadLayoutRight"
    $Redux.DPadLayout                  = CreateReduxButton      -Column 0 -Row 2 -AddTo $DPadBox -Text "Customize D-Pad" -ToolTip $ToolTip -Info "Customize the D-Pad Layout"
    
    $Redux.DPadLayout.Add_Click( { $Redux.DPadDialog.ShowDialog() } )



    # GAMEPLAY #
    $GameplayBox                       = CreateReduxGroup -Y ($DPadBox.Bottom + 5) -Height 1 -AddTo $Redux.Panel -Text "Gameplay"

    $Redux.FasterBlockPushing          = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $GameplayBox -Text "Faster Block Pushing"  -ToolTip $ToolTip -Info "All blocks are pushed faster" -Name "FasterBlockPushing"
    $Redux.EasierMinigames             = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $GameplayBox -Text "Easier Minigames"      -ToolTip $ToolTip -Info "Certain minigames are made easier and faster`n- Dampe's Digging Game always has two Ghost Flames on the ground and one up the ladder`n- The Gold Dog always wins the Doggy Racetrack race if you have the Mask of Truth`nOnly one fish has to be feeded in the Marine Research Lab" -Name "EasierMinigames"
    


    CreateDPadDialog

    $Redux.DPadDisable.Add_CheckedChanged({ $Redux.DPadLayout.Enabled = !$this.checked })

    $Redux.DPadLayout.Enabled = !$Redux.DPadDisable.Checked

}



#==============================================================================================================================================================================================
function CreateSM64OptionsContent() {
    
    CreateOptionsDialog -Width 550 -Height 320
    $ToolTip = CreateTooltip



     # HERO MODE #
    $HeroModeBox                       = CreateReduxGroup -Y 50 -Height 1 -AddTo $Options.Panel -Text "Hero Mode"
    
    $Options.Damage                    = CreateReduxComboBox -Column 0 -Row 1 -AddTo $HeroModeBox -Items @("1x Damage", "2x Damage", "3x Damage") -Text "Damage:" -ToolTip $OptionsToolTip -Info "Set the amount of damage you receive" -Name "Damage"



    # GRAPHICS #
    $GraphicsBox                       = CreateReduxGroup -Y ($HeroModeBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Graphics"
    
    $Options.Widescreen                = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $GraphicsBox -Text "16:9 Widescreen"         -ToolTip $ToolTip -Info "Native 16:9 Widescreen Display support" -Name "Widescreen"
    $Options.ForceHiresModel           = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $GraphicsBox -Text "Force Hires Mario Model" -ToolTip $ToolTip -Info "Always use Mario's High Resolution Model when Mario is too far away" -Name "ForceHiresModel"
    $Options.BlackBars                 = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $GraphicsBox -Text "No Black Bars"           -ToolTip $ToolTip -Info "Removes the black bars shown on the top and bottom of the screen" -Name "BlackBars"
    


    # GAMEPLAY #
    $GameplayBox                       = CreateReduxGroup -Y ($GraphicsBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Gameplay"

    $Options.FPS                       = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $GameplayBox -Text "60 FPS"        -ToolTip $ToolTip -Info "Increases the FPS from 30 to 60`nWitness Super Mario 64 in glorious 60 FPS" -Name "FPS"
    $Options.FreeCam                   = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $GameplayBox -Text "Analog Camera" -ToolTip $ToolTip -Info "Enable full 360 degrees sideways analog camera`nEnable a second emulated controller and bind the Left / Right for the Analog stick" -Name "FreeCam"
    $Options.LagFix                    = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $GameplayBox -Text "Lag Fix"       -ToolTip $ToolTip -Info "Smoothens gameplay by reducing lag" -Name "LagFix"



    $Options.FPS.Add_CheckStateChanged({ $Options.FreeCam.Enabled = !$this.Checked })
    $Options.FreeCam.Add_CheckStateChanged({ $Options.FPS.Enabled = !$this.Checked })
    $Options.FreeCam.Enabled = !$Options.FPS.Checked
    $Options.FPS.Enabled = !$Options.FreeCam.Checked

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

    if ($GameType.mode -eq "Ocarina of Time")     { $AmmoBox = CreateReduxGroup -Y ($ToggleBox.Bottom + 5) -Height 5 -AddTo $CapacityPanel -Text "Ammo Capacity Selection" }
    elseif ($GameType.mode -eq "Majora's Mask")   { $AmmoBox = CreateReduxGroup -Y ($ToggleBox.Bottom + 5) -Height 4 -AddTo $CapacityPanel -Text "Ammo Capacity Selection" }

    $Options.Quiver1                   = CreateReduxTextBox -Column 0 -Row 1 -Text "Quiver (1)"      -Value 30 -AddTo $AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Quiver (Base)`nDefault = 30"           -Name "Quiver1"
    $Options.Quiver2                   = CreateReduxTextBox -Column 1 -Row 1 -Text "Quiver (2)"      -Value 40 -AddTo $AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Quiver (Upgrade 1)`nDefault = 40"      -Name "Quiver2"
    $Options.Quiver3                   = CreateReduxTextBox -Column 2 -Row 1 -Text "Quiver (3)"      -Value 50 -AddTo $AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Quiver (Upgrade 2)`nDefault = 50"      -Name "Quiver3"

    $Options.BombBag1                  = CreateReduxTextBox -Column 0 -Row 2 -Text "Bomb Bag (1)"    -Value 20 -AddTo $AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Bomb Bag (Base)`nDefault = 20"         -Name "BombBag1"
    $Options.BombBag2                  = CreateReduxTextBox -Column 1 -Row 2 -Text "Bomb Bag (2)"    -Value 30 -AddTo $AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Bomb Bag (Upgrade 1)`nDefault = 30"    -Name "BombBag2"
    $Options.BombBag3                  = CreateReduxTextBox -Column 2 -Row 2 -Text "Bomb Bag (3)"    -Value 40 -AddTo $AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Bomb Bag (Upgrade 2)`nDefault = 40"    -Name "BombBag3"

    if ($GameType.mode -eq "Ocarina of Time") {
        $Options.BulletBag1            = CreateReduxTextBox -Column 0 -Row 3 -Text "Bullet Bag (1)"  -Value 30 -AddTo $AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Bullet Bag (Base)`nDefault = 30"       -Name "BulletBag1"
        $Options.BulletBag2            = CreateReduxTextBox -Column 1 -Row 3 -Text "Bullet Bag (2)"  -Value 40 -AddTo $AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Bullet Bag (Upgrade 1)`nDefault = 40"  -Name "BulletBag2"
        $Options.BulletBag3            = CreateReduxTextBox -Column 2 -Row 3 -Text "Bullet Bag (3)"  -Value 50 -AddTo $AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Bullet Bag (Upgrade 2)`nDefault = 50"  -Name "BulletBag3"

        $Options.DekuSticks1           = CreateReduxTextBox -Column 0 -Row 4 -Text "Deku Sticks (1)" -Value 10 -AddTo $AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Deku Sticks (Base)`nDefault = 10"      -Name "DekuSticks1"
        $Options.DekuSticks2           = CreateReduxTextBox -Column 1 -Row 4 -Text "Deku Sticks (2)" -Value 20 -AddTo $AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Deku Sticks (Upgrade 1)`nDefault = 20" -Name "DekuSticks2"
        $Options.DekuSticks3           = CreateReduxTextBox -Column 2 -Row 4 -Text "Deku Sticks (3)" -Value 30 -AddTo $AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Deku Sticks (Upgrade 2)`nDefault = 30" -Name "DekuSticks3"

        $Options.DekuNuts1             = CreateReduxTextBox -Column 0 -Row 5 -Text "Deku Nuts (1)"   -Value 20 -AddTo $AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Deku Nuts (Base)`nDefault = 20"        -Name "DekuNuts1"
        $Options.DekuNuts2             = CreateReduxTextBox -Column 1 -Row 5 -Text "Deku Nuts (2)"   -Value 30 -AddTo $AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Deku Nuts (Upgrade 1)`nDefault = 30"   -Name "DekuNuts2"
        $Options.DekuNuts3             = CreateReduxTextBox -Column 2 -Row 5 -Text "Deku Nuts (3)"   -Value 40 -AddTo $AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Deku Nuts (Upgrade 2)`nDefault = 40"   -Name "DekuNuts3"
    }
    else {
        $Options.DekuSticks1           = CreateReduxTextBox -Column 0 -Row 3 -Text "Deku Sticks (1)" -Value 10 -AddTo $AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Deku Sticks (Base)`nDefault = 10"      -Name "DekuSticks1"
        $Options.DekuNuts1             = CreateReduxTextBox -Column 0 -Row 4 -Text "Deku Nuts (1)"   -Value 20 -AddTo $AmmoBox -ToolTip $ToolTip -Info "Set the capacity for the Deku Nuts (Base)`nDefault = 20"        -Name "DekuNuts1"
    }

    $WalletBox                         = CreateReduxGroup -Y ($AmmoBox.Bottom + 5) -Height 1 -AddTo $CapacityPanel -Text "Wallet Capacity Selection"
    $Options.Wallet1                   = CreateReduxTextBox -Column 0 -Row 1 -Length 3 -Text "Wallet (1)" -Value 99  -AddTo $WalletBox -ToolTip $ToolTip -Info "Set the capacity for the Wallet (Base)`nDefault = 99"       -Name "Wallet1"
    $Options.Wallet2                   = CreateReduxTextBox -Column 1 -Row 1 -Length 3 -Text "Wallet (2)" -Value 200 -AddTo $WalletBox -ToolTip $ToolTip -Info "Set the capacity for the Wallet (Upgrade 1)`nDefault = 200" -Name "Wallet2"
    $Options.Wallet3                   = CreateReduxTextBox -Column 2 -Row 1 -Length 3 -Text "Wallet (3)" -Value 500 -AddTo $WalletBox -ToolTip $ToolTip -Info "Set the capacity for the Wallet (Upgrade 2)`nDefault = 500" -Name "Wallet3"

    ToggleAmmoCapacityOptions
    $Options.EnableAmmoCapacity.Add_CheckStateChanged({ ToggleAmmoCapacityOptions })

    ToggleWalletCapacityOptions
    $Options.EnableWalletCapacity.Add_CheckStateChanged({ ToggleWalletCapacityOptions })

}



#==============================================================================================================================================================================================
function CreateDPadDialog() {

    # Create Dialog
    $Redux.DPadDialog = CreateDialog -Width 530 -Height 400
    if (Test-Path -LiteralPath $GameFiles.icon -PathType Leaf)       { $Redux.DPadDialog.Icon = $GameFiles.icon }
    else                                                             { $Redux.DPadDialog.Icon = $null }

    # Tooltip
    $ToolTip = CreateTooltip

    # Close Button
    $CloseButton = CreateButton -X ($Redux.DPadDialog.Width / 2 - 60) -Y ($Redux.DPadDialog.Height - 90) -Width 100 -Height 35 -Text "Close" -AddTo $Redux.DPadDialog
    $CloseButton.Add_Click( {$Redux.DPadDialog.Hide()} )

    
    # Options Label
    $Label = CreateLabel -X 30 -Y 20 -Width 300 -Height 15 -Font $VCPatchFont -Text ($GameType.mode + " - Customize D-Pad") -AddTo $Redux.DPadDialog

    # Capacity
    $DPadPanel                         = CreatePanel -Width $Redux.DPadDialog.Width -Height ($Redux.DPadDialog.Height) -AddTo $Redux.DPadDialog

    # Enable checkbox
    $DPadBox                           = CreateReduxGroup -Y 50 -Height 7 -AddTo $DPadPanel -Text "D-Pad Buttons Customization"

    $Redux.DPadUp                      = CreateReduxComboBox -Column 1 -Row 1 -Length 120 -AddTo $DPadBox -Items @("None", "Ocarina of Time", "Deku Mask", "Goron Mask", "Zora Mask", "Fierce Deity's Mask") -Default 2 -Text ""    -ToolTip $OptionsToolTip -Info "Set the quick slot item for the D-Pad Up button" -Name "DPadUp"
    $Redux.DPadLeft                    = CreateReduxComboBox -Column 0 -Row 4 -Length 120 -AddTo $DPadBox -Items @("None", "Ocarina of Time", "Deku Mask", "Goron Mask", "Zora Mask", "Fierce Deity's Mask") -Default 3 -Text ""  -ToolTip $OptionsToolTip -Info "Set the quick slot item for the D-Pad Left button" -Name "DPadLeft"
    $Redux.DPadRight                   = CreateReduxComboBox -Column 2 -Row 4 -Length 120 -AddTo $DPadBox -Items @("None", "Ocarina of Time", "Deku Mask", "Goron Mask", "Zora Mask", "Fierce Deity's Mask") -Default 4 -Text "" -ToolTip $OptionsToolTip -Info "Set the quick slot item for the D-Pad Right button" -Name "DPadRight"
    $Redux.DPadDown                    = CreateReduxComboBox -Column 1 -Row 7 -Length 120 -AddTo $DPadBox -Items @("None", "Ocarina of Time", "Deku Mask", "Goron Mask", "Zora Mask", "Fierce Deity's Mask") -Default 1 -Text ""  -ToolTip $OptionsToolTip -Info "Set the quick slot item for the D-Pad Down button" -Name "DPadDown"
    
    $Image = [System.Drawing.Image]::Fromfile( ( Get-Item ($Paths.Main + "\D-Pad.png") ) )
    $PictureBox = New-Object Windows.Forms.PictureBox
    $PictureBox.Location = New-object System.Drawing.Size( ($Redux.DPadRight.Left / 2 + 5), ($Redux.DPadDown.Bottom / 4) )
    $PictureBox.Width =  $Image.Size.Width
    $PictureBox.Height =  $Image.Size.Height
    $PictureBox.Image = $Image
    $DPadBox.controls.add($PictureBox)

}



#==============================================================================================================================================================================================
function ToggleAmmoCapacityOptions() {
    
    $Options.Quiver1.Enabled     = $Options.EnableAmmoCapacity.Checked
    $Options.Quiver2.Enabled     = $Options.EnableAmmoCapacity.Checked
    $Options.Quiver3.Enabled     = $Options.EnableAmmoCapacity.Checked

    $Options.BombBag1.Enabled    = $Options.EnableAmmoCapacity.Checked
    $Options.BombBag2.Enabled    = $Options.EnableAmmoCapacity.Checked
    $Options.BombBag3.Enabled    = $Options.EnableAmmoCapacity.Checked

    $Options.DekuSticks1.Enabled = $Options.EnableAmmoCapacity.Checked
    $Options.DekuNuts1.Enabled   = $Options.EnableAmmoCapacity.Checked

    if ($GameType.mode -eq "Ocarina of Time") {
        $Options.BulletBag1.Enabled  = $Options.EnableAmmoCapacity.Checked
        $Options.BulletBag2.Enabled  = $Options.EnableAmmoCapacity.Checked
        $Options.BulletBag3.Enabled  = $Options.EnableAmmoCapacity.Checked

        $Options.DekuSticks2.Enabled = $Options.EnableAmmoCapacity.Checked
        $Options.DekuSticks3.Enabled = $Options.EnableAmmoCapacity.Checked

        $Options.DekuNuts2.Enabled   = $Options.EnableAmmoCapacity.Checked
        $Options.DekuNuts3.Enabled   = $Options.EnableAmmoCapacity.Checked
    }

}



#==============================================================================================================================================================================================
function ToggleWalletCapacityOptions() {
    
    $Options.Wallet1.Enabled = $Options.EnableWalletCapacity.Checked
    $Options.Wallet2.Enabled = $Options.EnableWalletCapacity.Checked
    $Options.Wallet3.Enabled = $Options.EnableWalletCapacity.Checked

}



#==============================================================================================================================================================================================
function SetButtonColors([String]$A, [String]$B, [String]$C, [String]$Start) {

    $Settings[$GameType.mode][$Options.SetAButtonColor.Tag] = $A;     $Options.SetAButtonColor.Color = "#" + $A
    $Settings[$GameType.mode][$Options.SetBButtonColor.Tag] = $B;     $Options.SetBButtonColor.Color = "#" + $B
    $Settings[$GameType.mode][$Options.SetCButtonColor.Tag] = $C;     $Options.SetCButtonColor.Color = "#" + $C
    $Settings[$GameType.mode][$Options.SetSButtonColor.Tag] = $Start; $Options.SetSButtonColor.Color = "#" + $Start

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function ToggleReduxOptions

Export-ModuleMember -Function PatchByteOptionsOoT
Export-ModuleMember -Function PatchByteOptionsMM
Export-ModuleMember -Function PatchByteReduxOoT
Export-ModuleMember -Function PatchByteReduxMM
Export-ModuleMember -Function PatchBPSOptionsOoT
Export-ModuleMember -Function PatchBPSOptionsMM
Export-ModuleMember -Function PatchOptionsSM64
Export-ModuleMember -Function PatchLanguageOptionsOoT
Export-ModuleMember -Function PatchLanguageOptionsMM

Export-ModuleMember -Function CreateOoTOptionsContent
Export-ModuleMember -Function CreateOoTReduxContent
Export-ModuleMember -Function CreateMMOptionsContent
Export-ModuleMember -Function CreateMMReduxContent
Export-ModuleMember -Function CreateSM64OptionsContent