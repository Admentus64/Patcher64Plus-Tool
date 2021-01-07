function PatchOptionsOcarinaOfTime() {
    
    # ENHANCED 16:9 WIDESCREEN #

    if (IsWidescreen -Experimental)   { ApplyPatch -File $GetROM.decomp -Patch "\Decompressed\widescreen.ppf" }



    # MODELS #

    if (IsChecked $Redux.Graphics.ListLinkModels) {
        if (IsChecked $Redux.Graphics.MMChildLink) {
            ApplyPatch -File $GetROM.decomp -Patch "\Decompressed\Models\mm_child.ppf"
            $Text = $Redux.Graphics.LinkModelsPlus.Text.replace(" (default)", "")
        }
        else { $Text = $Redux.Graphics.LinkModels.Text.replace(" (default)", "") }
        ApplyPatch -File $GetROM.decomp -Patch ("\Decompressed\Models\Link\" + $Text + ".ppf")
    }
    elseif (IsChecked $Redux.Graphics.ListMaleModels)     { ApplyPatch -File $GetROM.decomp -Patch ("\Decompressed\Models\Male\"   + $Redux.Graphics.MaleModels.Text.replace(" (default)", "") + ".ppf") }
    elseif (IsChecked $Redux.Graphics.ListFemaleModels)   { ApplyPatch -File $GetROM.decomp -Patch ("\Decompressed\Models\Female\" + $Redux.Graphics.FemaleModels.Text.replace(" (default)", "") + ".ppf") }
    


    # MM PAUSE SCREEN

    if (IsChecked $Redux.Text.PauseScreen)   { ApplyPatch -File $GetROM.decomp -Patch "\Decompressed\mm_pause_screen.ppf" }
    
}



#==============================================================================================================================================================================================
function ByteOptionsOcarinaOfTime() {
    
    # GAMEPLAY #

    if (IsChecked $Redux.Gameplay.EasierMinigames) {
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

    if (IsChecked $Redux.Gameplay.FasterBlockPushing) {
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
    
    if (IsChecked $Redux.Gameplay.Medallions)          { ChangeBytes -Offset "E2B454"  -Values @("80", "EA", "00", "A7", "24", "01", "00", "3F", "31", "4A", "00", "3F", "00", "00", "00", "00") }
    if (IsChecked $Redux.Gameplay.ReturnChild)         { ChangeBytes -Offset "CB6844"  -Values @("35"); ChangeBytes -Offset "253C0E2" -Values @("03") }
    if (IsChecked $Redux.Gameplay.FixGraves)           { ChangeBytes -Offset "202039D" -Values @("20"); ChangeBytes -Offset "202043C" -Values @("24") }
    if (IsChecked $Redux.Gameplay.DistantZTargeting)   { ChangeBytes -Offset "A987AC"  -Values @("00", "00", "00", "00") }



    # RESTORE #

    if (IsChecked $Redux.Restore.RupeeColors) {
        ChangeBytes -Offset "F47EB0" -Values @("70", "6B", "BB", "3F", "FF", "FF", "EF", "3F", "68", "AD", "C3", "FD", "E6", "BF", "CD", "7F", "48", "9B", "91", "AF", "C3", "7D", "BB", "3D", "40", "0F", "58", "19", "88", "ED", "80", "AB") # Purple
        ChangeBytes -Offset "F47ED0" -Values @("D4", "C3", "F7", "49", "FF", "FF", "F7", "E1", "DD", "03", "EF", "89", "E7", "E3", "E7", "DD", "A3", "43", "D5", "C3", "DF", "85", "E7", "45", "7A", "43", "82", "83", "B4", "43", "CC", "83") # Gold
    }

    if (IsChecked $Redux.Restore.Blood) {
        ChangeBytes -Offset "D8D590 " -Values @("00", "78", "00", "FF", "00", "78", "00", "FF")
        ChangeBytes -Offset "E8C424 " -Values @("00", "78", "00", "FF", "00", "78", "00", "FF")
    }

    if (IsChecked $Redux.Restore.FireTemple) {
        ChangeBytes -Offset "7465"   -Values @("03", "91", "30") # DMA Table, Pointer to AudioBank
        ChangeBytes -Offset "7471"   -Values @("03", "91", "30", "00", "08", "8B", "B0", "00", "03", "91", "30") # DMA Table, Pointer to AudioSeq
        ChangeBytes -Offset "7481"   -Values @("08", "8B", "B0", "00", "4D", "9F", "40", "00", "08", "8B", "B0") # DMA Table, Pointer to AudioTable
        ChangeBytes -Offset "B2E82F" -Values @("04", "24", "A5", "91", "30") # MIPS assembly that loads AudioSeq
        ChangeBytes -Offset "B2E857" -Values @("09", "24", "A5", "8B", "B0") # MIPS assembly that loads AudioTable
        PatchBytes  -Offset "B896A0" -Patch "Fire Temple Theme\12AudioBankPointers.bin"
        PatchBytes  -Offset "B89AD0" -Patch "Fire Temple Theme\12AudioSeqPointers.bin"
        PatchBytes  -Offset "B8A1C0" -Patch "Fire Temple Theme\12AudioTablePointers.bin"
        ExportAndPatch -Path "audiobank_fire_temple"  -Offset "D390" -Length "4CCBB0"
    }

    if (IsChecked $Redux.Restore.CowNoseRing) { ChangeBytes -Offset "EF3E68" -Values @("00", "00") }



    # OTHER #

    if (IsChecked $Redux.Other.DebugMapSelect) {
        ChangeBytes -Offset "A94994" -Values @("00", "00", "00", "00", "AE", "08", "00", "14", "34", "84", "B9", "2C", "8E", "02", "00", "18", "24", "0B", "00", "00", "AC", "8B", "00", "00")
        ChangeBytes -Offset "B67395" -Values @("B9", "E4", "00", "00", "BA", "11", "60", "80", "80", "09", "C0", "80", "80", "37", "20", "80", "80", "1C", "14", "80", "80", "1C", "14", "80", "80", "1C", "08");
    }

    if (IsChecked $Redux.Other.SubscreenDelayFix)    { ChangeBytes -Offset "B15DD0" -Values @("00", "00", "00", "00"); ChangeBytes -Offset "B12947" -Values @("03") }
    if (IsChecked $Redux.Other.DisableNaviPrompts)   { ChangeBytes -Offset "DF8B84" -Values @("00", "00", "00", "00") }
    if (IsChecked $Redux.Other.DefaultZTargeting)    { ChangeBytes -Offset "B71E6D" -Values "01" }
    if (IsChecked $Redux.Other.HideCredits)          { PatchBytes  -Offset "966000" -Patch "Message\Credits.bin" }



    # GRAPHICS #

    if ( ( (IsChecked $Redux.Graphics.Widescreen) -and $IsWiiVC) -or !(IsWidescreen -Experimental) ) {
        # 16:9 Widescreen
        if ($IsWiiVC ) { ChangeBytes -Offset "B08038" -Values @("3C", "07", "3F", "E3") }

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

    if (IsChecked $Redux.Graphics.BlackBars) {
        ChangeBytes -Offset "B0F5A4" -Values @("00", "00","00", "00")
        ChangeBytes -Offset "B0F5D4" -Values @("00", "00","00", "00")
        ChangeBytes -Offset "B0F5E4" -Values @("00", "00","00", "00")
        ChangeBytes -Offset "B0F680" -Values @("00", "00","00", "00")
        ChangeBytes -Offset "B0F688" -Values @("00", "00","00", "00")
    }

    if (IsChecked $Redux.Graphics.ExtendedDraw)      { ChangeBytes -Offset "A9A970" -Values @("00", "01") }
    if (IsChecked $Redux.Graphics.ForceHiresModel)   { ChangeBytes -Offset "BE608B" -Values @("00") }



    # INTERFACE #

    if (IsChecked $Redux.UI.HudTextures) {
        PatchBytes  -Offset "1A3CA00" -Texture -Patch "HUD\MM Button.bin"
        PatchBytes  -Offset "1A3C100" -Texture -Patch "HUD\MM Hearts.bin"
        PatchBytes  -Offset "1A3DE00" -Texture -Patch "HUD\MM Key & Rupee.bin"
    }

    if (IsChecked $Redux.UI.ButtonPositions) {
        ChangeBytes -Offset "B57EEF" -Values "A7"
        ChangeBytes -Offset "B57F03" -Values "BE"
        ChangeBytes -Offset "B586A7" -Values "17"
        ChangeBytes -Offset "B589EB" -Values "9B"
    }

    if (IsChecked $Redux.UI.CenterNaviPrompt) {
        ChangeBytes -Offset "B582DF" -Values "F6"
    }



    # SOUNDS / VOICES #
    if (IsIndex -Elem $Redux.Sounds.Voices -Not ) {
        if (IsChecked $Redux.Restore.FireTemple)   { $Offset = "19D920" }
        else                                       { $Offset = "18E1E0" }
    }
    if (IsText -Elem $Redux.Sounds.Voices -Compare "Majora's Mask")   { PatchBytes -Offset $Offset -Patch "Voices\MM Link Voices.bin" }
    if (IsText -Elem $Redux.Sounds.Voices -Compare "Feminine")        { PatchBytes -Offset $Offset -Patch "Voices\Feminine Link Voices.bin" }

    if (IsIndex -Elem $Redux.Sounds.Instrument -Not) {
        ChangeBytes -Offset "B53C7B" -Values ($Redux.Sounds.Instrument.SelectedIndex+1); ChangeBytes -Offset "B4BF6F" -Values ($Redux.Sounds.Instrument.SelectedIndex+1)
    }



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

    if (IsIndex -Elem $Redux.SFX.FileMenuCursor -Not) {
        ChangeBytes -Offset "BA165E" -Values (GetSFXID $Redux.SFX.FileMenuCursor.Text);   ChangeBytes -Offset "BA1C1A" -Values (GetSFXID $Redux.SFX.FileMenuCursor.Text);   ChangeBytes -Offset "BA2406" -Values (GetSFXID $Redux.SFX.FileMenuCursor.Text);
        ChangeBytes -Offset "BA327E" -Values (GetSFXID $Redux.SFX.FileMenuCursor.Text);   ChangeBytes -Offset "BA3936" -Values (GetSFXID $Redux.SFX.FileMenuCursor.Text);   ChangeBytes -Offset "BA77C2" -Values (GetSFXID $Redux.SFX.FileMenuCursor.Text);
        ChangeBytes -Offset "BA7886" -Values (GetSFXID $Redux.SFX.FileMenuCursor.Text);   ChangeBytes -Offset "BA7A06" -Values (GetSFXID $Redux.SFX.FileMenuCursor.Text);   ChangeBytes -Offset "BA7A6E" -Values (GetSFXID $Redux.SFX.FileMenuCursor.Text);
        ChangeBytes -Offset "BA7AE6" -Values (GetSFXID $Redux.SFX.FileMenuCursor.Text);   ChangeBytes -Offset "BA7D6A" -Values (GetSFXID $Redux.SFX.FileMenuCursor.Text);   ChangeBytes -Offset "BA8186" -Values (GetSFXID $Redux.SFX.FileMenuCursor.Text);
        ChangeBytes -Offset "BA822E" -Values (GetSFXID $Redux.SFX.FileMenuCursor.Text);   ChangeBytes -Offset "BA82A2" -Values (GetSFXID $Redux.SFX.FileMenuCursor.Text);   ChangeBytes -Offset "BAA11E" -Values (GetSFXID $Redux.SFX.FileMenuCursor.Text);
        ChangeBytes -Offset "BAE7C6" -Values (GetSFXID $Redux.SFX.FileMenuCursor.Text)
    }

    if (IsIndex -Elem $Redux.SFX.FileMenuSelect -Not) {
        ChangeBytes -Offset "BA1BBE" -Values (GetSFXID $Redux.SFX.FileMenuSelect.Text);   ChangeBytes -Offset "BA23CE" -Values (GetSFXID $Redux.SFX.FileMenuSelect.Text);   ChangeBytes -Offset "BA2956" -Values (GetSFXID $Redux.SFX.FileMenuSelect.Text);
        ChangeBytes -Offset "BA321A" -Values (GetSFXID $Redux.SFX.FileMenuSelect.Text);   ChangeBytes -Offset "BA72F6" -Values (GetSFXID $Redux.SFX.FileMenuSelect.Text);   ChangeBytes -Offset "BA8106" -Values (GetSFXID $Redux.SFX.FileMenuSelect.Text);
        ChangeBytes -Offset "BA82EE" -Values (GetSFXID $Redux.SFX.FileMenuSelect.Text);   ChangeBytes -Offset "BA9DAE" -Values (GetSFXID $Redux.SFX.FileMenuSelect.Text);   ChangeBytes -Offset "BA9EAE" -Values (GetSFXID $Redux.SFX.FileMenuSelect.Text);
        ChangeBytes -Offset "BA9FD2" -Values (GetSFXID $Redux.SFX.FileMenuSelect.Text);   ChangeBytes -Offset "BAE6D6" -Values (GetSFXID $Redux.SFX.FileMenuSelect.Text)
    }

    if (IsIndex -Elem $Redux.SFX.ZTarget    -Not)   { ChangeBytes -Offset "AE7EC6" -Values (GetSFXID $Redux.SFX.ZTarget.Text) }
    if (IsIndex -Elem $Redux.SFX.LowHP      -Not)   { ChangeBytes -Offset "ADBA1A" -Values (GetSFXID $Redux.SFX.LowHP.Text) }
    if (IsIndex -Elem $Redux.SFX.HoverBoots -Not)   { ChangeBytes -Offset "BDBD8A" -Values (GetSFXID $Redux.SFX.HoverBoots.Text) } 



    # HERO MODE #

    if (IsText -Elem $Redux.Hero.Damage -Compare "OHKO Mode") {
        ChangeBytes -Offset "AE8073" -Values @("09", "04") -Interval 16
        ChangeBytes -Offset "AE8096" -Values @("82", "00")
        ChangeBytes -Offset "AE8099" -Values @("00", "00", "00")
    }
    elseif ( (IsText -Elem $Redux.Hero.Damage -Compare "1x Damage" -Not) -or (IsText -Elem $Redux.Hero.Recovery -Compare "1x Recovery" -Not) ) {
        ChangeBytes -Offset "AE8073" -Values @("09", "04") -Interval 16
        if         (IsText -Elem $Redux.Hero.Recovery -Compare "1x Recovery") {                
            if     (IsText -Elem $Redux.Hero.Damage -Compare "2x Damage")   { ChangeBytes -Offset "AE8096" -Values @("80", "40") }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "4x Damage")   { ChangeBytes -Offset "AE8096" -Values @("80", "80") }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "8x Damage")   { ChangeBytes -Offset "AE8096" -Values @("80", "C0") }
            ChangeBytes -Offset "AE8099" -Values @("00", "00", "00")
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Compare "1/2x Recovery") {               
            if     (IsText -Elem $Redux.Hero.Damage -Compare "1x Damage")   { ChangeBytes -Offset "AE8096" -Values @("80", "40") }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "2x Damage")   { ChangeBytes -Offset "AE8096" -Values @("80", "80") }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "4x Damage")   { ChangeBytes -Offset "AE8096" -Values @("80", "C0") }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "8x Damage")   { ChangeBytes -Offset "AE8096" -Values @("81", "00") }
            ChangeBytes -Offset "AE8099" -Values @("10", "80", "43")
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Compare "1/2x Recovery") {                
            if     (IsText -Elem $Redux.Hero.Damage -Compare "1x Damage")   { ChangeBytes -Offset "AE8096" -Values @("80", "80") }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "2x Damage")   { ChangeBytes -Offset "AE8096" -Values @("80", "C0") }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "4x Damage")   { ChangeBytes -Offset "AE8096" -Values @("81", "00") }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "8x Damage")   { ChangeBytes -Offset "AE8096" -Values @("81", "40") }
            ChangeBytes -Offset "AE8099" -Values @("10", "80", "83")
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Compare "1/2x Recovery") {                
            if     (IsText -Elem $Redux.Hero.Damage -Compare "1x Damage")   { ChangeBytes -Offset "AE8096" -Values @("81", "40") }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "2x Damage")   { ChangeBytes -Offset "AE8096" -Values @("81", "80") }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "4x Damage")   { ChangeBytes -Offset "AE8096" -Values @("81", "C0") }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "8x Damage")   { ChangeBytes -Offset "AE8096" -Values @("82", "00") }
            ChangeBytes -Offset "AE8099" -Values @("10", "81", "43")
        }
    }

    if (IsText -Elem $Redux.Hero.MagicUsage -Compare "2x Magic Usage")      { ChangeBytes -Offset "AE84FA" -Values @("2C","40") }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "3x Magic Usage")  { ChangeBytes -Offset "AE84FA" -Values @("2C","80") }



    <#
    if (IsText -Elem $Redux.Hero.BossHP -Compare "2x Boss HP") {
        ChangeBytes -Offset "C44F2B" -Values "14" # Gohma           0xC44C30 -> 0xC4ABB0 (Length: 0x5F80) (ovl_Boss_Goma) (HP: 0A) (Mass: FF)
        ChangeBytes -Offset "C3B9FF" -Values "18" # King Dodongo    0xC3B150 -> 0xC44C30 (Length: 0x9AE0) (ovl_Boss_Dodongo) (HP: 0C) (Mass: 00)
        ChangeBytes -Offset "C91F8F" -Values "3C" # Phantom Ganon   0xC91AD0 -> 0xC96840 (Length: 0x4D70) (ovl_Boss_Ganondrof) (HP: 1E -> 18) (Mass: 32)
        ChangeBytes -Offset "CE6D2F" -Values "30" # Volvagia        0xCE65F0 -> 0xCED920 (Length: 0x7330) (ovl_Boss_Fd) (Has HP) (HP: 18) (Mass: 32) / 0xD04790 -> 0xD084C0 (Length:0x3D30) (ovl_Boss_Fd2) (Has No HP, Forwards HP to Flying)
        ChangeBytes -Offset "D3B4A7" -Values "28" # Morpha          0xD3ADF0 -> 0xD46390 (Length: 0xB5A0) (ovl_Boss_Mo) (HP: 14) (Mass: 00)

        #ChangeBytes -Offset "C91B99" -Values "1D" # Phantom Ganon 2A
        #ChangeBytes -Offset "C91C95" -Values "1D" # Phantom Ganon
        #ChangeBytes -Offset "C922C3" -Values "1D" # Phantom Ganon
        #ChangeBytes -Offset "C92399" -Values "1D" # Phantom Ganon
        #ChangeBytes -Offset "C9263F" -Values "1D" # Phantom Ganon
        #ChangeBytes -Offset "C9266B" -Values "1D" # Phantom Ganon
        #ChangeBytes -Offset "C92AE7" -Values "1D" # Phantom Ganon

        #ChangeBytes -Offset "C91BE1" -Values "1D" # Phantom Ganon
        #ChangeBytes -Offset "C91C4B" -Values "1D" # Phantom Ganon
        #ChangeBytes -Offset "C91C91" -Values "1D" # Phantom Ganon
        #ChangeBytes -Offset "C91CCD" -Values "1D" # Phantom Ganon
        #ChangeBytes -Offset "C91D2D" -Values "1D" # Phantom Ganon
        #ChangeBytes -Offset "C91D8D" -Values "1D" # Phantom Ganon
        #ChangeBytes -Offset "C91E9B" -Values "1D" # Phantom Ganon
        #ChangeBytes -Offset "C91F83" -Values "1D" # Phantom Ganon
        #ChangeBytes -Offset "C9200B" -Values "1D" # Phantom Ganon
        #ChangeBytes -Offset "C920EB" -Values "1D" # Phantom Ganon
        #ChangeBytes -Offset "C92123" -Values "1D" # Phantom Ganon
        #ChangeBytes -Offset "C92177" -Values "1D" # Phantom Ganon
        #ChangeBytes -Offset "C9219F" -Values "1D" # Phantom Ganon

        # ChangeBytes -Offset "" -Values "08" # Barinade            0xD22360 -> 0xD30B50 (Length: 0xE7F0)(ovl_Boss_Va) (HP: 04 -> 03 -> 03) (Mass: 00)
        # ChangeBytes -Offset "" -Values "06" # Barinade
        # ChangeBytes -Offset "" -Values "48" # Bongo Bongo         0xDA1660 -> 0xDADB80 (Length: 0xC520) (ovl_Boss_Sst) (HP: 24) (Mass: C8)
        # ChangeBytes -Offset "" -Values "30" # Twinrova            0xD612E0 -> 0xD74360 (Length: 0x13080) (ovl_Boss_Tw) (HP: 18) (Mass: FF)
        # ChangeBytes -Offset "D7FDA3" -Values "50" # Ganondorf     0xD7F3F0 -> 0xDA1660 (Length: 0x22270) (ovl_Boss_Ganon) (HP: 28) (Mass: 32)
        # ChangeBytes -Offset "" -Values "3C" # Ganon               0xE826C0 -> 0xE939B0 (Length: 0x112F0) (ovl_Boss_Ganon2) (HP: 1E) (Mass: FF)
    }
    elseif (IsText -Elem $Redux.Hero.BossHP -Compare "3x Boss HP") {
        ChangeBytes -Offset "C44F2B" -Values "1E" # Gohma           0xC44C30 -> 0xC4ABB0 (Length: 0x5F80) (ovl_Boss_Goma) (HP: 0A) (Mass: FF)
        ChangeBytes -Offset "C3B9FF" -Values "24" # King Dodongo    0xC3B150 -> 0xC44C30 (Length: 0x9AE0) (ovl_Boss_Dodongo) (HP: 0C) (Mass: 00)
        ChangeBytes -Offset "C91F8F" -Values "5A" # Phantom Ganon   0xC91AD0 -> 0xC96840 (Length: 0x4D70) (ovl_Boss_Ganondrof) (HP: 1E -> 18) (Mass: 32)
        ChangeBytes -Offset "CE6D2F" -Values "48" # Volvagia        0xCE65F0 -> 0xCED920 (Length: 0x7330) (ovl_Boss_Fd) (Has HP) (HP: 18) (Mass: 32) / 0xD04790 -> 0xD084C0 (Length:0x3D30) (ovl_Boss_Fd2) (Has No HP, Forwards HP to Flying)    
        ChangeBytes -Offset "D3B4A7" -Values "3C" # Morpha          0xD3ADF0 -> 0xD46390 (Length: 0xB5A0) (ovl_Boss_Mo) (HP: 14) (Mass: 00)

        # ChangeBytes -Offset "" -Values "0C" # Barinade            0xD22360 -> 0xD30B50 (Length: 0xE7F0)(ovl_Boss_Va) (HP: 04 -> 03 -> 03) (Mass: 00)
        # ChangeBytes -Offset "" -Values "09" # Barinade
        # ChangeBytes -Offset "" -Values "6C" # Bongo Bongo         0xDA1660 -> 0xDADB80 (Length: 0xC520) (ovl_Boss_Sst) (HP: 24) (Mass: C8)
        # ChangeBytes -Offset "" -Values "48 # Twinrova            0xD612E0 -> 0xD74360 (Length: 0x13080) (ovl_Boss_Tw) (HP: 18) (Mass: FF)
        # ChangeBytes -Offset "D7FDA3" -Values "78" # Ganondorf     0xD7F3F0 -> 0xDA1660 (Length: 0x22270) (ovl_Boss_Ganon) (HP: 28) (Mass: 32)
        # ChangeBytes -Offset "" -Values "5A" # Ganon               0xE826C0 -> 0xE939B0 (Length: 0x112F0) (ovl_Boss_Ganon2) (HP: 1E) (Mass: FF)
    }
    #>


    <#
    if (IsText -Elem $Redux.MonsterHP -Compare "2x Monster HP") {
        ChangeBytes -Offset "BFADAB" -Values("14") # Stalfos
    }
    elseif (IsText -Elem $Redux.MonsterHP -Compare "3x Monster HP") {
        ChangeBytes -Offset "BFADC5" -Values("1E") # Stalfos
    }
    #>


    
    # EQUIPMENT COLORS #

    if (IsIndex -Elem $Redux.Colors.Equipment[0] -Index 1 -Not) { ChangeBytes -Offset "B6DA38" -IsDec -Values @($Redux.Colors.SetEquipment[0].Color.R, $Redux.Colors.SetEquipment[0].Color.G, $Redux.Colors.SetEquipment[0].Color.B) } # Kokiri Tunic
    if (IsIndex -Elem $Redux.Colors.Equipment[1] -Index 2 -Not) { ChangeBytes -Offset "B6DA3B" -IsDec -Values @($Redux.Colors.SetEquipment[1].Color.R, $Redux.Colors.SetEquipment[1].Color.G, $Redux.Colors.SetEquipment[1].Color.B) } # Goron Tunic
    if (IsIndex -Elem $Redux.Colors.Equipment[2] -Index 3 -Not) { ChangeBytes -Offset "B6DA3E" -IsDec -Values @($Redux.Colors.SetEquipment[2].Color.R, $Redux.Colors.SetEquipment[2].Color.G, $Redux.Colors.SetEquipment[2].Color.B) } # Zora Tunic
    if (IsIndex -Elem $Redux.Colors.Equipment[3] -Index 1 -Not) { ChangeBytes -Offset "B6DA44" -IsDec -Values @($Redux.Colors.SetEquipment[3].Color.R, $Redux.Colors.SetEquipment[3].Color.G, $Redux.Colors.SetEquipment[3].Color.B) } # Silver Gauntlets
    if (IsIndex -Elem $Redux.Colors.Equipment[4] -Index 2 -Not) { ChangeBytes -Offset "B6DA47" -IsDec -Values @($Redux.Colors.SetEquipment[4].Color.R, $Redux.Colors.SetEquipment[4].Color.G, $Redux.Colors.SetEquipment[4].Color.B) } # Golden Gauntlets
    if (IsIndex -Elem $Redux.Colors.Equipment[5] -Index 1 -Not) { # Mirror Shield Frame
        if ( (IsIndex -Elem $Redux.Graphics.FemaleModels -Text "Saria" -Not) -or (IsIndex -Elem $Redux.Graphics.FemaleModels -Text "Hatsune Miku - Vocaloid" -Not) -or (IsIndex -Elem $Redux.Graphics.FemaleModels -Text "Princess Ruto" -Not) -or (IsIndex -Elem $Redux.Graphics.LinkModels -Text "Ocarina of Time 3D" -Not) -or (IsIndex -Elem $Redux.Graphics.LinkModels -Text "Link's Awakening" -Not) ) {
            ChangeBytes -Offset "FA7274" -IsDec -Values @($Redux.Colors.SetEquipment[5].Color.R, $Redux.Colors.SetEquipment[5].Color.G, $Redux.Colors.SetEquipment[5].Color.B)
            ChangeBytes -Offset "FA776C" -IsDec -Values @($Redux.Colors.SetEquipment[5].Color.R, $Redux.Colors.SetEquipment[5].Color.G, $Redux.Colors.SetEquipment[5].Color.B)
            ChangeBytes -Offset "FAA27C" -IsDec -Values @($Redux.Colors.SetEquipment[5].Color.R, $Redux.Colors.SetEquipment[5].Color.G, $Redux.Colors.SetEquipment[5].Color.B)
            ChangeBytes -Offset "FAC564" -IsDec -Values @($Redux.Colors.SetEquipment[5].Color.R, $Redux.Colors.SetEquipment[5].Color.G, $Redux.Colors.SetEquipment[5].Color.B)
            ChangeBytes -Offset "FAC984" -IsDec -Values @($Redux.Colors.SetEquipment[5].Color.R, $Redux.Colors.SetEquipment[5].Color.G, $Redux.Colors.SetEquipment[5].Color.B)
            ChangeBytes -Offset "FAEDD4" -IsDec -Values @($Redux.Colors.SetEquipment[5].Color.R, $Redux.Colors.SetEquipment[5].Color.G, $Redux.Colors.SetEquipment[5].Color.B)
        }
    }



    # MAGIC SPIN ATTACK COLORS #

    if (IsIndex -Elem $Redux.Colors.BlueSpinAttack -Not) {
        ChangeBytes -Offset "F15AB4" -IsDec -Values @($Redux.Colors.SetSpinAttack[0].Color.R, $Redux.Colors.SetSpinAttack[0].Color.G, $Redux.Colors.SetSpinAttack[0].Color.B)
        ChangeBytes -Offset "F15BD4" -IsDec -Values @($Redux.Colors.SetSpinAttack[1].Color.R, $Redux.Colors.SetSpinAttack[1].Color.G, $Redux.Colors.SetSpinAttack[1].Color.B)
    }

    if (IsIndex -Elem $Redux.Colors.RedSpinAttack -Index 2 -Not) {
        ChangeBytes -Offset "F16034" -IsDec -Values @($Redux.Colors.SetSpinAttack[2].Color.R, $Redux.Colors.SetSpinAttack[2].Color.G, $Redux.Colors.SetSpinAttack[2].Color.B)
        ChangeBytes -Offset "F16154" -IsDec -Values @($Redux.Colors.SetSpinAttack[3].Color.R, $Redux.Colors.SetSpinAttack[3].Color.G, $Redux.Colors.SetSpinAttack[3].Color.B)
    }



    # FAIRY COLORS #

    if (IsIndex -Elem $Redux.Colors.Fairy -Not) {
        # Idle
        ChangeBytes -Offset "B5E184" -IsDec -Values @($Redux.Colors.SetFairy[0].Color.R, $Redux.Colors.SetFairy[0].Color.G, $Redux.Colors.SetFairy[0].Color.B, 255, $Redux.Colors.SetFairy[1].Color.R, $Redux.Colors.SetFairy[1].Color.G, $Redux.Colors.SetFairy[1].Color.B, 0)

        # Interact
        ChangeBytes -Offset "B5E174" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
        ChangeBytes -Offset "B5E17C" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
        ChangeBytes -Offset "B5E18C" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
        ChangeBytes -Offset "B5E1A4" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
        ChangeBytes -Offset "B5E1AC" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
        ChangeBytes -Offset "B5E1B4" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
        ChangeBytes -Offset "B5E1C4" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
        ChangeBytes -Offset "B5E1CC" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
        ChangeBytes -Offset "B5E1D4" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)

        # NPC
        ChangeBytes -Offset "B5E194" -IsDec -Values @($Redux.Colors.SetFairy[4].Color.R, $Redux.Colors.SetFairy[4].Color.G, $Redux.Colors.SetFairy[4].Color.B, 255, $Redux.Colors.SetFairy[5].Color.R, $Redux.Colors.SetFairy[5].Color.G, $Redux.Colors.SetFairy[5].Color.B, 0)

        # Enemy, Boss
        ChangeBytes -Offset "B5E19C" -IsDec -Values @($Redux.Colors.SetFairy[6].Color.R, $Redux.Colors.SetFairy[6].Color.G, $Redux.Colors.SetFairy[6].Color.B, 255, $Redux.Colors.SetFairy[7].Color.R, $Redux.Colors.SetFairy[7].Color.G, $Redux.Colors.SetFairy[7].Color.B, 0)
        ChangeBytes -Offset "B5E1BC" -IsDec -Values @($Redux.Colors.SetFairy[6].Color.R, $Redux.Colors.SetFairy[6].Color.G, $Redux.Colors.SetFairy[6].Color.B, 255, $Redux.Colors.SetFairy[7].Color.R, $Redux.Colors.SetFairy[7].Color.G, $Redux.Colors.SetFairy[7].Color.B, 0)
    }

    

    # AMMO CAPACITY SELECTION #

    if (IsChecked $Redux.Capacity.EnableAmmo) {
        ChangeBytes -Offset "B6EC2F" -IsDec -Values @($Redux.Capacity.Quiver1.Text,     $Redux.Capacity.Quiver2.Text,     $Redux.Capacity.Quiver3.Text) -Interval 2
        ChangeBytes -Offset "B6EC37" -IsDec -Values @($Redux.Capacity.BombBag1.Text,    $Redux.Capacity.BombBag2.Text,    $Redux.Capacity.BombBag3.Text) -Interval 2
        ChangeBytes -Offset "B6EC57" -IsDec -Values @($Redux.Capacity.BulletBag1.Text,  $Redux.Capacity.BulletBag2.Text,  $Redux.Capacity.BulletBag3.Text) -Interval 2
        ChangeBytes -Offset "B6EC5F" -IsDec -Values @($Redux.Capacity.DekuSticks1.Text, $Redux.Capacity.DekuSticks2.Text, $Redux.Capacity.DekuSticks3.Text) -Interval 2
        ChangeBytes -Offset "B6EC67" -IsDec -Values @($Redux.Capacity.DekuNuts1.Text,   $Redux.Capacity.DekuNuts2.Text,   $Redux.Capacity.DekuNuts3.Text) -Interval 2
    }



    # WALLET CAPACITY SELECTION #

    if (IsChecked $Redux.Capacity.EnableWallet) {
        $Wallet1 = Get16Bit ($Redux.Capacity.Wallet1.Text); $Wallet2 = Get16Bit ($Redux.Capacity.Wallet2.Text); $Wallet3 = Get16Bit ($Redux.Capacity.Wallet3.Text)
        ChangeBytes -Offset "B6EC4C" -Values @($Wallet1.Substring(0, 2), $Wallet1.Substring(2) )
        ChangeBytes -Offset "B6EC4E" -Values @($Wallet2.Substring(0, 2), $Wallet2.Substring(2) )
        ChangeBytes -Offset "B6EC50" -Values @($Wallet3.Substring(0, 2), $Wallet3.Substring(2) )
    }



    # UNLOCK CHILD RESTRICTIONS #

    if (IsChecked $Redux.Unlock.Tunics)              { ChangeBytes -Offset "BC77B6" -Values @("09", "09"); ChangeBytes -Offset "BC77FE" -Values @("09", "09") }
    if (IsChecked $Redux.Unlock.MasterSword)         { ChangeBytes -Offset "BC77AE" -Values @("09", "09") -Interval 74 }
    if (IsChecked $Redux.Unlock.GiantsKnife)         { ChangeBytes -Offset "BC77AF" -Values @("09", "09") -Interval 74 }
    if (IsChecked $Redux.Unlock.MirrorShield)        { ChangeBytes -Offset "BC77B3" -Values @("09", "09") -Interval 73 }
    if (IsChecked $Redux.Unlock.Boots)               { ChangeBytes -Offset "BC77BA" -Values @("09", "09"); ChangeBytes -Offset "BC7801" -Values @("09", "09") }
    if (IsChecked $Redux.Unlock.MegatonHammer)       { ChangeBytes -Offset "BC77A3" -Values @("09", "09") -Interval 42 }
    

    
    # UNLOCK ADULT RESTRICTIONS #
    
    if (IsChecked $Redux.Unlock.KokiriSword)         { ChangeBytes -Offset "BC77AD" -Values @("09", "09") -Interval 74 }
    if (IsChecked $Redux.Unlock.DekuShield)          { ChangeBytes -Offset "BC77B1" -Values @("09", "09") -Interval 73 }
    if (IsChecked $Redux.Unlock.FairySlingshot)      { ChangeBytes -Offset "BC779A" -Values @("09", "09") -Interval 40 }
    if (IsChecked $Redux.Unlock.Boomerang)           { ChangeBytes -Offset "BC77A0" -Values @("09", "09") -Interval 42 }



    # CUTSCENES #

    if (IsChecked $Redux.Skip.IntroSequence)         { ChangeBytes -Offset "B06BBA"  -Values @("00", "00") }
    if (IsChecked $Redux.Skip.AllMedallions)         { ChangeBytes -Offset "ACA409"  -Values @("AD"); ChangeBytes -Offset "ACA49D"  -Values @("CE") }
    if (IsChecked $Redux.Skip.DaruniaDance)          { ChangeBytes -Offset "22769E4" -Values @("FF", "FF", "FF", "FF") }
    if (IsChecked $Redux.Skip.OpeningChests)         { ChangeBytes -Offset "BDA2E8"  -Values @("24", "0A", "FF", "FF") }
    if (IsChecked $Redux.Skip.KingZora)              { ChangeBytes -Offset "E56924"  -Values @("00", "00", "00", "00") }
    if (IsChecked $Redux.Skip.ZeldasEscape)          { ChangeBytes -Offset "1FC0CF8" -Values @("00", "00", "00", "01", "00", "21", "00", "01", "00", "02", "00", "02") }



    # MASTER QUEST #

    PatchDungeonsMQ



    # CENSOR GERUDO TEXTURES #

    if (IsChecked $Redux.Restore.GerudoTextures) {
        
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

        if ( (IsIndex -Elem $Redux.Graphics.FemaleModels -Text "Saria" -Not) -or (IsIndex -Elem $Redux.Graphics.FemaleModels -Text "Hatsune Miku - Vocaloid" -Not) -or (IsIndex -Elem $Redux.Graphics.FemaleModels -Text "Princess Ruto" -Not) -or (IsIndex -Elem $Redux.Graphics.LinkModels -Text "Ocarina of Time 3D" -Not) -or (IsIndex -Elem $Redux.Graphics.LinkModels -Text "Link's Awakening" -Not) ) {
            $Offset = SearchBytes -Start "F86000" -End "FBD800" -Values @("90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90", "90")
            PatchBytes -Offset $Offset -Texture -Patch "Gerudo Symbols\mirror_shield.bin"
        }

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
function ByteReduxOcarinaOfTime() {
    
    # INTERFACE ICONS #

    if (IsChecked $Redux.UI.ShowFileSelectIcons)   { PatchBytes  -Offset "BAF738" -Patch "File Select.bin" }
    if (IsChecked $Redux.UI.DPadLayoutShow)        { ChangeBytes -Offset "348086E" -Values "01" }



     # BUTTON COLORS #

     if (IsIndex -Elem $Redux.Colors.Buttons -Not) {
        #ChangeBytes -Offset "348085F" -Values @("FF", "00", "50") # Cursor
        #ChangeBytes -Offset "3480859" -Values @("C8", "00", "50") # Cursor

        # A Button
        ChangeBytes -Offset "3480845" -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) -Interval 2
        ChangeBytes -Offset "3480863" -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) -Interval 2 # Note Button

        # A Button - Text Cursor
        ChangeBytes -Offset "B88E81"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) -Interval 4

        # A Button - Pause Menu Cursor
        ChangeBytes -Offset "BC7849"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) -Interval 2
        ChangeBytes -Offset "BC78A9"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) -Interval 2
        ChangeBytes -Offset "BC78BB"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B) -Interval 2

        # A Button - Pause Menu Icon
        ChangeBytes -Offset "845754"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G, $Redux.Colors.SetButtons[0].Color.B)

        # A Button - Save/Death Cursor
        ChangeBytes -Offset "BBEBC2"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G) # Red + Green
        ChangeBytes -Offset "BBEBD6"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.B) # Blue
        ChangeBytes -Offset "BBEDDA"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G) # Red + Green
        ChangeBytes -Offset "BBEDDE"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.B) # Blue

        # A Button - Note
        ChangeBytes -Offset "BB299A"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G) # Red + Green
        ChangeBytes -Offset "BB299E"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.B) # Blue
        ChangeBytes -Offset "BB2C8E"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G) # Red + Green
        ChangeBytes -Offset "BB2C92"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.B) # Blue
        ChangeBytes -Offset "BB2F8A"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G) # Red + Green
        ChangeBytes -Offset "BB2F96"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.B) # Blue

        # B Button
        ChangeBytes -Offset "348084B" -IsDec -Values @($Redux.Colors.SetButtons[1].Color.R, $Redux.Colors.SetButtons[1].Color.G, $Redux.Colors.SetButtons[1].Color.B) -Interval 2

        # C Buttons
        ChangeBytes -Offset "3480851" -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) -Interval 2
        
        if ($Redux.Colors.Buttons.Text -eq "Randomized" -or $Redux.Colors.Buttons.Text -eq "Custom") {
        # C Buttons - Pause Menu Cursor
            ChangeBytes -Offset "BC7843" -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) -Interval 2
            ChangeBytes -Offset "BC7891" -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) -Interval 2
            ChangeBytes -Offset "BC78A3" -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B) -Interval 2

            # C Buttons - Pause Menu Icon
            ChangeBytes -Offset "8456FC" -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G, $Redux.Colors.SetButtons[2].Color.B)

            # C Buttons - Note Color
            ChangeBytes -Offset "BB2996" -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G) # Red + Green
            ChangeBytes -Offset "BB29A2" -IsDec -Values @($Redux.Colors.SetButtons[2].Color.B) # Blue
            ChangeBytes -Offset "BB2C8A" -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G) # Red + Green
            ChangeBytes -Offset "BB2C96" -IsDec -Values @($Redux.Colors.SetButtons[2].Color.B) # Blue
            ChangeBytes -Offset "BB2F86" -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G) # Red + Green
            ChangeBytes -Offset "BB2F9A" -IsDec -Values @($Redux.Colors.SetButtons[2].Color.B) # Blue
        }

        # Start Button
        ChangeBytes -Offset "AE9EC6" -IsDec -Values @($Redux.Colors.SetButtons[3].Color.R, $Redux.Colors.SetButtons[3].Color.G) # Red + Green
        ChangeBytes -Offset "AE9ED8" -IsDec -Values @("53", "238", $Redux.Colors.SetButtons[3].Color.B) # Blue
    }

}



#==============================================================================================================================================================================================
function ByteLanguageOcarinaOfTime() {
    
    if ( (IsChecked -Elem $Redux.Text.Vanilla -Not) -or (IsChecked -Elem $Redux.Text.Speed1x -Not) -or (IsChecked $Redux.Text.GCScheme) -or (IsLanguage $Redux.Unlock.Tunics) -or (IsLangText -Elem $Redux.Colors.Fairy -Compare "Tatl") -or (IsLangText -Elem $Redux.Colors.Fairy -Compare "Tael") ) {
        $File = $GameFiles.extracted + "\message_data_static.bin"
        ExportBytes -Offset "92D000" -Length "38130" -Output $File -Force
    }

    if (IsChecked $Redux.Text.Redux) { ApplyPatch -File $File -Patch "\Export\Message\redux.bps" }
    elseif (IsChecked $Redux.Text.Restore) {
        ChangeBytes -Offset "7596" -Values @("52", "40")
        PatchBytes  -Offset "B849EC" -Patch "Message\Table Restore Text.bin"
        ApplyPatch -File $File -Patch "\Export\Message\restore_text.bps"
    }
    elseif (IsChecked $Redux.Text.FemalePronouns) {
        ChangeBytes -Offset "7596" -Values @("52", "40")
        PatchBytes  -Offset "B849EC" -Patch "Message\Table Female Pronouns.bin"
        ApplyPatch -File $File -Patch "\Export\Message\female_pronouns.bps"
    }

    if (IsChecked $Redux.TextSpeed2x) {
        ChangeBytes -Offset "B5006F" -Values "02" # Text Speed

        if ($Redux.Language[0].checked) {
            # Correct Ruto Confession Textboxes
            $Offset = SearchBytes -File $File -Values @("1A", "41", "73", "20", "61", "20", "72", "65", "77", "61", "72", "64", "2E", "2E", "2E", "01")
            PatchBytes -File $File -Offset $Offset -Patch "Message\Ruto Confession.bin"

            # Correct Phantom Ganon Defeat Textboxes
            $Offset = SearchBytes -File $File -Values @("0C", "3C", "42", "75", "74", "20", "79", "6F", "75", "20", "68", "61", "76", "65", "20", "64")
            ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "01") ) ) -Values @("66")
            ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "5D") ) ) -Values @("66")
            ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "BA") ) ) -Values @("60")
        }
    }
    elseif (IsChecked $Redux.Text.Speed3x) {
        ChangeBytes -Offset "B5006F" -Values "03" # Text Speed

        # Correct Learning Song Textboxes
        $Offset = SearchBytes -File $File -Values @("08", "06", "3C", "50", "6C", "61", "79", "20", "75", "73", "69", "6E", "67", "20", "05")
        PatchBytes -File $File -Offset $Offset -Patch "Message\Songs.bin"

        # Correct Ruto Confession Textboxes
        $Offset = SearchBytes -File $File -Values @("1A", "41", "73", "20", "61", "20", "72", "65", "77", "61", "72", "64", "2E", "2E", "2E", "01")
        PatchBytes -File $File -Offset $Offset -Patch "Message\Ruto Confession.bin"
        
        # Correct Phantom Ganon Defeat Textboxes
        $Offset = SearchBytes -File $File -Values @("0C", "3C", "42", "75", "74", "20", "79", "6F", "75", "20", "68", "61", "76", "65", "20", "64")
        ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "01") ) ) -Values @("76")
        ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "5D") ) ) -Values @("76")
        ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "BA") ) ) -Values @("70")
    }
        
    if (IsChecked $Redux.Text.GCScheme) {
        # Z to L textures
        PatchBytes -Offset "844540"  -Texture -Patch "GameCube\L Menu.bin"
        PatchBytes -Offset "1A35680" -Texture -Patch "GameCube\L Targeting.bin"
        PatchBytes -Offset "92C200"  -Texture -Patch "GameCube\L Text.bin"

        # Hole of Z
        $Offset = SearchBytes -File $File -Values @("48", "6F", "6C", "65", "20", "6F", "66", "20", "22", "5A", "22")
        ChangeBytes -File $File -Offset $Offset -Values @("48", "6F", "6C", "65", "20", "6F", "66", "20", "22", "4C", "22")

        # GC Colors
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

    if (IsLanguage $Redux.Unlock.Tunics) {
        $Offset = SearchBytes -File $File -Values @("59", "6F", "75", "20", "67", "6F", "74", "20", "61", "20", "05", "41", "47", "6F", "72", "6F", "6E", "20", "54", "75", "6E", "69", "63")
        ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "39") ) ) -Values @("75", "6E", "69", "73", "69", "7A", "65", "2C", "20", "73", "6F", "20", "69", "74", "20", "66", "69", "74", "73", "20", "61", "64", "75", "6C", "74", "20", "61", "6E", "64")
        ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "B3") ) ) -Values @("75", "6E", "69", "73", "69", "7A", "65", "2C", "01", "73", "6F", "20", "69", "74", "20", "66", "69", "74", "73", "20", "61", "64", "75", "6C", "74", "20", "61", "6E", "64")

        $Offset = SearchBytes -File $File -Values @("41", "20", "74", "75", "6E", "69", "63", "20", "6D", "61", "64", "65", "20", "62", "79", "20", "47", "6F", "72", "6F", "6E", "73")
        ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "18") ) ) -Values @("55", "6E", "69", "2D", "20")
        ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "7A") ) ) -Values @("55", "6E", "69", "73", "69", "7A", "65", "2E", "20", "20", "20")
    }

    if (IsLangText -Elem $Redux.Colors.Fairy -Compare "Tatl") {
        do { # Tatl
            $Offset = SearchBytes -File $File -Start $Offset -Values @("4E", "61", "76", "69")
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values @("54", "61", "74", "6C") }
        } while ($Offset -gt 0)
        PatchBytes -Offset "1A3EFC0" -Texture -Patch "HUD\Tatl.bin"
    }
    elseif (IsLangText -Elem $Redux.Colors.Fairy -Compare "Tael") {
        do { # Tael
            $Offset = SearchBytes -File $File -Start $Offset -Values @("4E", "61", "76", "69")
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values @("54", "61", "65", "6C") }
        } while ($Offset -gt 0)
        PatchBytes -Offset "1A3EFC0" -Texture -Patch "HUD\Tael.bin"
    }

    if ( (IsChecked -Elem $Redux.Text.Vanilla -Not) -or (IsChecked -Elem $Redux.Text.Speed1x -Not) -or (IsChecked $Redux.Text.GCScheme) -or (IsLanguage $Redux.Unlock.Tunics) -or (IsLangText -Elem $Redux.Colors.Fairy -Compare "Tatl") -or (IsLangText -Elem $Redux.Colors.Fairy -Compare "Tael") ) {
        PatchBytes -Offset "92D000" -Patch "message_data_static.bin" -Extracted
    }

}



#==============================================================================================================================================================================================
function CreateOptionsOcarinaOfTime() {
    
    if ($Settings.Debug.LiteGUI -eq $False) {
        CreateOptionsDialog -Width 1060 -Height 515 -Tabs @("Audiovisual", "Difficulty", "Colors", "Equipment", "Cutscenes")
    }
    else {
        CreateOptionsDialog -Width 1060 -Height 400 -Tabs @("Audiovisual")
    }

}



#==============================================================================================================================================================================================
function CreateTabMainOcarinaOfTime() {

    # GAMEPLAY #
    CreateReduxGroup        -Tag  "Gameplay" -Text "Gameplay" 
    if ($Settings.Debug.LiteGUI -eq $False) {
        CreateReduxCheckBox -Name "FasterBlockPushing" -Checked -Text "Faster Block Pushing"   -Info "All blocks are pushed faster" -Credits "GhostlyDark (Ported from Redux)"
        CreateReduxCheckBox -Name "EasierMinigames"             -Text "Easier Minigames"       -Info "Certain minigames are made easier and faster`n- Dampe's Digging Game is first try always`n- Fishing is less random and has less demanding requirements`n-Bombchu Bowling prizes now appear in fixed order instead of random" -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "ReturnChild"                 -Text "Can Always Return"      -Info "You can always go back to being a child again before clearing the boss of the Forest Temple`nOut of the way Sheik!" -Credits "Ported from Redux"
        CreateReduxCheckBox -Name "Medallions"                  -Text "Require All Medallions" -Info "All six medallions are required for the Rainbow Bridge to appear before Ganon's Castle`nThe vanilla requirements were the Shadow and Spirit Medallions and the Light Arrows" -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "FixGraves"                   -Text "Fix Graves"             -Info "The grave holes in Kakariko Graveyard behave as in the Rev 1 revision`nThe edges no longer force Link to grab or jump over them when trying to enter" -Credits "Ported from Rando"
    }
    CreateReduxCheckBox     -Name "DistantZTargeting"           -Text "Distant Z-Targeting"    -Info "Allow to use Z-Targeting on enemies, objects and NPC's from any distance" -Credits "Admentus"
   

    # RESTORE #
    CreateReduxGroup        -Tag  "Restore" -Text "Restore / Correct / Censor"
    CreateReduxCheckBox     -Name "RupeeColors"        -Text "Correct Rupee Colors"            -Info "Corrects the colors for the Purple (50) and Golden (200) Rupees"         -Credits "GhostlyDark"
    CreateReduxCheckBox     -Name "CowNoseRing"        -Text "Restore Cow Nose Ring"           -Info "Restore the rings in the noses for Cows as seen in the Japanese release" -Credits "ShadowOne333"
    if ($Settings.Debug.LiteGUI -eq $False) {
        CreateReduxCheckBox -Name "FireTemple"         -Text "Censor Fire Temple"              -Info "Censor Fire Temple theme as used in the Rev 2 ROM" -Credits "ShadowOne333"
        CreateReduxCheckBox -Name "GerudoTextures"     -Text "Censor Gerudo Textures"          -Info "Censor Gerudo symbol textures used in the GameCube / Virtual Console releases`n- Disable the option to uncensor the Gerudo Texture used in the Master Quest dungeons`n- Player model textures such as the Mirror Shield might not get restored for specific custom models" -Credits "GhostlyDark & ShadowOne333"
    
    }
    CreateReduxCheckBox -Name "Blood"                  -Text "Censor Blood"                    -Info "Censor the green blood for Ganondorf and Ganon as used in the Rev 2 ROM" -Credits "ShadowOne333"
    
    # OTHER #
    CreateReduxGroup        -Tag  "Other" -Text "Other"
    CreateReduxCheckBox     -Name "SubscreenDelayFix"  -Text "Pause Screen Delay Fix"          -Info "Removes the delay when opening the Pause Screen" -Credits "zel"
    if ($Settings.Debug.LiteGUI -eq $False) {
        CreateReduxCheckBox -Name "DisableNaviPrompts" -Text "Remove Navi Prompts"             -Info "Navi will no longer interupt your during the first dungeon with mandatory textboxes" -Credits "Ported from Redux"
        CreateReduxCheckBox -Name "DefaultZTargeting"  -Text "Default Hold Z-Targeting"        -Info "Change the Default Z-Targeting option to Hold instead of Switch" -Credits "Ported from Redux"
        CreateReduxCheckBox -Name "HideCredits"        -Text "Hide Credits"                    -Info "Do not show the credits text during the credits sequence" -Credits "Admentus"
    }
    CreateReduxCheckBox -Name "DebugMapSelect"         -Text "Debug Map Select"                -Info "Enable the Map Select menu like in the Debug ROM`nThe File Select menu now opens the Map Select menu instead`nA separate debug save file is used" -Credits "Jared Johnson"

}



#==============================================================================================================================================================================================
function CreateTabReduxOcarinaOfTime() {
    
    # INTERFACE #
    CreateReduxGroup    -Tag  "UI" -Text "Interface Icons"
    CreateReduxCheckBox -Name "ShowFileSelectIcons" -Column 1 -Checked -Text "Show File Select Icons" -Info "Show icons on the File Select screen to display your save file progress" -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "DPadLayoutShow"      -Column 2 -Checked -Text "Show D-Pad Icon"        -Info "Show the D-Pad icons ingame that display item shortcuts"                 -Credits "Ported from Redux"

    CreateButtonColorOptions

}



#==============================================================================================================================================================================================
function CreateTabLanguageOcarinaOfTime() {
    
    CreateLanguageContent -Columns 6

    # TEXT SPEED #
    CreateReduxGroup       -Tag  "Text" -Text "Text Speed"
    CreateReduxPanel
    CreateReduxRadioButton -Name "Speed1x" -Max 3 -SaveTo "Speed" -Column 1 -Checked -Text "1x Text Speed"   -Info "Leave the dialogue text speed at normal"
    CreateReduxRadioButton -Name "Speed2x" -Max 3 -SaveTo "Speed" -Column 2          -Text "2x Text Speed"   -Info "Set the dialogue text speed to be twice as fast"       -Credits "Ported from Redux"
    CreateReduxRadioButton -Name "Speed3x" -Max 3 -SaveTo "Speed" -Column 3          -Text "3x Text Speed"   -Info "Set the dialogue text speed to be three times as fast" -Credits "Ported from Redux"
    
    # ENGLISH TEXT #
    $Redux.Box.Dialogue = CreateReduxGroup -Tag  "Text" -Text "English Dialogue"
    CreateReduxPanel
    CreateReduxRadioButton -Name "Vanilla"        -Max 4 -SaveTo "Dialogue" -Column 1          -Text "Vanilla Text"          -Info "Keep the text as it is"
    CreateReduxRadioButton -Name "Redux"          -Max 4 -SaveTo "Dialogue" -Column 2 -Checked -Text "Redux Text"            -Info "Include the changes from the Redux script such as being able to move during the Gold Skulltula Token textboxes" -Credits "Redux"
    CreateReduxRadioButton -Name "Restore"        -Max 4 -SaveTo "Dialogue" -Column 3          -Text "Restore Text"          -Info ("Restores the text used from the GC revision and applies grammar and typo fixes`nAlso corrects some icons in the text`n" + 'Includes the changes from "Redux Text" as well') -Credits "Redux"
    CreateReduxRadioButton -Name "FemalePronouns" -Max 4 -SaveTo "Dialogue" -Column 4          -Text "Female Pronouns (WIP)" -Info "Refer to Link as a female character`nWork in Progress: Not all dialogue is fully altered yet" -Credits "Mil`n(includes Restore Text by ShadowOne)"

    $Redux.Box.Text = CreateReduxGroup -Tag  "Text" -Text "Other English Options"
    CreateReduxCheckBox    -Name "GCScheme"       -Column 1 -Text "GC Scheme"                -Info "Set the Textures and Text Dialogue Colors to match the GameCube's scheme" -Credits "Admentus & ShadowOne333"
    CreateReduxCheckBox    -Name "PauseScreen"    -Column 2 -Text "MM Pause Screen"          -Info "Replaces the Pause Screen textures to be styled like Majora's Mask"       -Credits "Garo-Mastah & CM"

    for ($i=0; $i -lt $GamePatch.languages.Length; $i++) {
        $Redux.Language[$i].Add_CheckedChanged({ UnlockLanguageContent })
    }
    UnlockLanguageContent

}



#==============================================================================================================================================================================================
function UnlockLanguageContent() {
    
    # English options
    $Redux.Box.Dialogue.Controls.GetEnumerator() | ForEach-Object { $_.Enabled = $Redux.Language[0].Checked }
    $Redux.Box.Text.Controls.GetEnumerator() | ForEach-Object { $_.Enabled = $Redux.Language[0].Checked }

    # Set max text speed in each language
    for ($i=0; $i -lt $GamePatch.languages.Length; $i++) {
        if ($Redux.Language[$i].checked) {
            $Redux.Text.Speed1x.Enabled = $Redux.Text.Speed2x.Enabled = $Redux.Text.Speed3x.Enabled = $True
            if ($GamePatch.languages[$i].max_text_speed -lt 3) {
                $Redux.Text.Speed3x.Enabled = $False
                if ($Redux.Text.Speed3x.Checked) { $Redux.Text.Speed2x.checked = $True }
            }
            if ($GamePatch.languages[$i].max_text_speed -lt 2) {
                $Redux.Text.Speed1x.Enabled = $Redux.Text.Speed2x.Enabled = $False
            }
        }
    }

}



#==============================================================================================================================================================================================
function CreateTabAudiovisualOcarinaOfTime() {

    
    # GRAPHICS #
    CreateReduxGroup    -Tag  "Graphics" -Text "Graphics" -Columns 4 -Height 3

    if ($WiiVC) {
        $Info = "Native 16:9 Widescreen Display support with backgrounds and textures adjusted for widescreen"
        $Credits = "`nAspect Ratio Fix by Admentus`n16:9 backgrounds by GhostlyDark, ShadowOne333 & CYB3RTRON"
    }
    else {
        $Info  = "Adjust the backgrounds and textures to fit in with 16:9 Widescreen`nUse GLideN64 " + '"adjust to fit"' + " option for 16:9 widescreen"
        $Info += "`n`n--- CHANGE WIDESCREEN ---`n"
        $Info += "Advanced native 16:9 Widescreen Display"
        $Info += "`n`n--- KNOWN ISSUES ---`n"
        $Info += "- Certain HUD elements are not centered"
        
        $Credits = "`nAspect Ratio Fix by Admentus`n16:9 backgrounds by GhostlyDark, ShadowOne333 & CYB3RTRON`nWidescreen Patch by gamemasterplc and corrected by GhostlyDark"
    }


    CreateReduxCheckBox -Name "Widescreen"      -Column 1 -Row 1 -Text "16:9 Widescreen"        -Info $Info                                                                                               -Credits $Credits
    CreateReduxCheckBox -Name "BlackBars"       -Column 2 -Row 1 -Text "No Black Bars"          -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes" -Credits "Admentus"
    CreateReduxCheckBox -Name "ExtendedDraw"    -Column 3 -Row 1 -Text "Extended Draw Distance" -Info "Increases the game's draw distance for objects`nDoes not work on all objects"                      -Credits "Admentus"
    CreateReduxCheckBox -Name "ForceHiresModel" -Column 4 -Row 1 -Text "Force Hires Link Model" -Info "Always use Link's High Resolution Model when Link is too far away"                                 -Credits "GhostlyDark"
    


    # MODELS #
    CreateReduxPanel -Columns 4 -Rows 1 -Row 1
    CreateReduxRadioButton -Name "OriginalModels"   -Max 4 -SaveTo "Models" -Column 1 -Row 1 -Text "Vanilla Models" -Checked -Info "Do not change the models for Link"
    CreateReduxRadioButton -Name "ListLinkModels"   -Max 4 -SaveTo "Models" -Column 2 -Row 1 -Text "Link Models"             -Info "List all male model replacements styled after Link to play as"
    CreateReduxRadioButton -Name "ListMaleModels"   -Max 4 -SaveTo "Models" -Column 3 -Row 1 -Text "Male Models"             -Info "List all male model replacements to play as"
    CreateReduxRadioButton -Name "ListFemaleModels" -Max 4 -SaveTo "Models" -Column 4 -Row 1 -Text "Female Models"           -Info "List all female model replacements to play as"
    CreateReduxCheckBox    -Name "MMChildLink" -Column 4 -Row 3 -Text "MM Child Model" -Info "Include the MM Child Link Model"

    $Models = LoadModelsList "Link" | Sort-Object
    CreateReduxComboBox -Name "LinkModels"     -Column 1 -Row 3 -Text "Player Models:" -Items $Models -Length 240 -Default ($Models.indexOf("Majora's Mask") + 1) -Info "Replace the model(s) used for Link`nOptions include models styled after Link`nContains combined (Child + Adult) or individual (Adult) models"

    $Models = LoadModelsList "Link+" | Sort-Object
    CreateReduxComboBox -Name "LinkModelsPlus" -Column 1 -Row 3 -Text "Player Models:" -Items $Models -Length 240 -Default ($Models.indexOf("Majora's Mask") + 1) -Info "Replace the models used for Link`nOptions include models styled after Link`nAll options include the Majora's Mask Child Model"

    $Models = LoadModelsList "Male" | Sort-Object
    CreateReduxComboBox -Name "MaleModels"     -Column 1 -Row 3 -Text "Player Models:" -Items $Models -Length 240 -Default ($Models.indexOf("Mega Man") + 1) -Info "Replace the models used for Link`nOptions include custom male models"

    $Models = LoadModelsList "Female" | Sort-Object
    CreateReduxComboBox -Name "FemaleModels"   -Column 1 -Row 3 -Text "Player Models:" -Items $Models -Length 240 -Default ($Models.indexOf("Hatsune Miku - Link") + 1) -Info "Replace the models used for Link`nOptions include custom female models"

    

    # MODELS PREVIEW #
    CreateReduxGroup -Tag "Graphics" -Text "Models Preview"
    $Last.Group.Height = 165
    $Redux.Graphics.ModelsPreview = New-Object Windows.Forms.PictureBox
    $Redux.Graphics.ModelsPreview.Location = New-object System.Drawing.Size(5, 15)
    $Redux.Graphics.ModelsPreview.Width  = $Last.Group.Width - 10
    $Redux.Graphics.ModelsPreview.Height = $Last.Group.Height - 20
    $Last.Group.controls.add($Redux.Graphics.ModelsPreview)
    $global:PreviewToolTip = CreateToolTip
    ChangeModelsSelection
    
    

    # INTERFACE #
    CreateReduxGroup    -Tag  "UI" -Text "Interface"
    $Last.Group.Width = $Redux.Groups[$Redux.Groups.Length-3].Width
    $Last.Group.Top = $Redux.Groups[$Redux.Groups.Length-3].Bottom + 5
    CreateReduxCheckBox -Name "HudTextures"      -Text "MM HUD Textures"     -Info "Replaces the HUD textures with those from Majora's Mask" -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "ButtonPositions"  -Text "MM Button Positions" -Info "Positions the A and B buttons like in Majora's Mask"     -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "CenterNaviPrompt" -Text "Center Navi Prompt"  -Info 'Centers the "Navi" prompt shown in the C-Up button'      -Credits "Ported by GhostlyDark"

    # SOUNDS / VOICES #
    CreateReduxGroup    -Tag  "Sounds" -Text "Sounds / Voices"
    CreateReduxComboBox -Name "Voices"           -Column 1 -Text "Link's Voice:"       -Items @("Original", "Majora's Mask", "Feminine")  -Info "1. Keep the original voices for Link`n2. Replace the voices for Link with those used in Majora's Mask`n2. Replace the voices for Link to sound feminine" -Credits "`nMajora's Mask: Ported by Korey Cryderman and corrected by GhostlyDark`nFeminine: theluigidude2007"
    if ($Settings.Debug.LiteGUI -eq $False) {
        CreateReduxComboBox -Name "Instrument"   -Column 3 -Text "Instrument:"         -Items @("Ocarina", "Female Voice", "Whistle", "Harp", "Grind-Organ", "Flute") -Info "Replace the sound used for playing the Ocarina of Time" -Credits "Ported from Rando"
    }



    if ($Settings.Debug.LiteGUI -eq $True) { return }

    # SFX SOUND EFFECTS #
    CreateReduxGroup    -Tag "SFX" -Text "SFX Sound Effects" -Height 3
    $SFX = @("Default", "Disabled", "Soft Beep", "Bark", "Bomb Bounce", "Bongo Bongo Low", "Bow Twang", "Business Scrub", "Carrot Refill", "Cluck", "Drawbridge Set", "Guay", "Horse Trot", "HP Recover", "Iron Boots", "Moo", "Mweep!", 'Navi "Hey!"', "Navi Random", "Notification", "Pot Shattering", "Ribbit", "Rupee (Silver)", "Switch", "Sword Bonk", "Tambourine", "Timer", "Zelda Gasp (Adult)")
    CreateReduxComboBox -Name "LowHP"            -Column 1 -Row 1 -Text "Low HP:"      -Items $SFX -Info "Set the sound effect for the low HP beeping"                      -Credits "Ported from Rando"
    $SFX = @("Default",  "Disabled", "Soft Beep", "Bark", "Business Scrub", "Carrot Refill", "Cluck", "Cockadoodledoo", "Dusk Howl", "Exploding Crate", "Explosion", "Great Fairy", "Guay", "Horse Neigh", "HP Low", "HP Recover", "Ice Shattering", "Moo", "Meweep!", 'Navi "Hello!"', "Notification", "Pot Shattering", "Redead Scream", "Ribbit", "Ruto Giggle", "Skulltula", "Tambourine", "Timer", "Zelda Gasp (Adult)")
    CreateReduxComboBox -Name "Navi"             -Column 3 -Row 1 -Text "Navi:"        -Items $SFX -Info "Replace the sound used for Navi when she wants to tell something" -Credits "Ported from Rando"
    CreateReduxComboBox -Name "ZTarget"          -Column 5 -Row 1 -Text "Z-Target:"    -Items $SFX -Info "Replace the sound used for Z-Targeting enemies"                   -Credits "Ported from Rando"

    CreateReduxComboBox -Name "HoverBoots"       -Column 1 -Row 2 -Text "Hover Boots:" -Items @("Default", "Disabled", "Bark", "Cartoon Fall", "Flare Dancer Laugh", "Mweep!", "Shabom Pop", "Tambourine") -Info "Replace the sound used for the Hover Boots"                              -Credits "Ported from Rando"
    CreateReduxComboBox -Name "Horse"            -Column 3 -Row 2 -Text "Horse Neigh:" -Items @("Default", "Disabled", "Armos", "Child Scream", "Great Fairy", "Moo", "Mweep!", "Redead Scream", "Ruto Wiggle", "Stalchild Attack") -Info "Replace the sound for horses when neighing"     -Credits "Ported from Rando"
    CreateReduxComboBox -Name "Nightfall"        -Column 5 -Row 2 -Text "Nightfall:"   -Items @("Default", "Disabled", "Cockadoodledoo", "Gold Skull Token", "Great Fairy", "Moo", "Mweep!", "Redead Moan", "Talon Snore", "Thunder") -Info "Replace the sound used when Nightfall occurs" -Credits "Ported from Rando"
    $SFX = @("Default", "Disabled", "Soft Beep", "Bark", "Bomb Bounce", "Bongo Bongo High", "Bongo Bongo Low", "Bottle Cork", "Bow Twang", "Bubble Laugh", "Carrot Refill", "Change Item", "Child Pant", "Cluck", "Deku Baba", "Drawbridge Set", "Dusk Howl", "Fanfare (Light)", "Fanfare (Medium)", "Field Shrub", "Flare Dancer Startled",
    'Ganondorf "Teh"', "Gohma Larva Croak", "Gold Skull Token", "Goron Wake", "Guay", "Gunshot", "Hammer Bonk", "Horse Trot", "HP Low", "HP Recover", "Iron Boots", "Iron Knuckle", "Moo", "Mweep!", "Notification", "Phantom Ganon Laugh", "Plant Explode", "Pot Shattering", "Redead Moan", "Ribbit", "Rupee", "Rupee (Silver)", "Ruto Crash",
    "Ruto Lift", "Ruto Thrown", "Scrub Emerge", "Shabom Bounce", "Shabom Pop", "Shellblade", "Skulltula", "Spit Nut", "Switch", "Sword Bonk", 'Talon "Hmm"', "Talon Snore", "Talon WTF", "Tambourine", "Target Enemy", "Target Neutral", "Thunder", "Timer", "Zelda Gasp (Adult)")
    CreateReduxComboBox -Name "FileMenuCursor"   -Column 1 -Row 3 -Text "File Cursor:" -Items $SFX -Info "Replace the sound used when moving the cursor in the File Select menu"   -Credits "Ported from Rando"
    CreateReduxComboBox -Name "FileMenuSelect"   -Column 3 -Row 3 -Text "File Select:" -Items $SFX -Info "Replace the sound used when selecting something in the File Select menu" -Credits "Ported from Rando"

}



#==============================================================================================================================================================================================
function CreateTabDifficultyOcarinaOfTime() {
    
    # HERO MODE #
    CreateReduxGroup    -Tag  "Hero" -Text "Hero Mode" 
    CreateReduxComboBox -Name "Damage"     -Column 1 -Row 1 -Text "Damage:"      -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage", "OHKO Mode") -Info "Set the amount of damage you receive`nOHKO Mode = You die in one hit" -Credits "Admentus"
    CreateReduxComboBox -Name "Recovery"   -Column 3 -Row 1 -Text "Recovery:"    -Items @("1x Recovery", "1/2x Recovery", "1/4x Recovery", "0x Recovery")  -Info "Set the amount health you recovery from Recovery Hearts"              -Credits "Admentus"
    CreateReduxComboBox -Name "MagicUsage" -Column 5 -Row 1 -Text "Magic Usage:" -Items @("1x Magic Usage", "2x Magic Usage", "3x Magic Usage")            -Info "Set the amount of times magic is consumed at"                         -Credits "Admentus"
  # CreateReduxComboBox -Name "BossHP"     -Column 1 -Row 2 -Text "Boss HP:"     -Items @("1x Boss HP", "2x Boss HP", "3x Boss HP")                        -Info "Set the amount of health for bosses"                                  -Credits "Admentus"
  # CreateReduxComboBox -Name "MonsterHP"  -Column 3 -Row 2 -Text "Monster HP:"  -Items @("1x Monster HP", "2x Monster HP", "3x Monster HP")               -Info "Set the amount of health for monsters"                                -Credits "Admentus"

   if ($Settings.Debug.LiteGUI -eq $True) { return }

    # MASTER QUEST #
    CreateReduxGroup -Tag "MQ" -Text "Master Quest"
    CreateReduxPanel
    CreateReduxRadioButton -Column 1 -Name "Disable"   -Max 3 -SaveTo "Dungeons" -Text "Disable" -Checked -Info "All dungeons remain vanilla"
    CreateReduxRadioButton -Column 2 -Name "Select"    -Max 3 -SaveTo "Dungeons" -Text "Select"           -Info "Select which dungeons you want from Master Quest" -Credits "ShadowOne333"
    CreateReduxRadioButton -Column 3 -Name "Randomize" -Max 3 -SaveTo "Dungeons" -Text "Randomize"        -Info "Randomize the amount of Master Quest dungeons"    -Credits "ShadowOne333"

    # MASTER QUEST DUNGEONS #
    $Redux.Box.SelectMQ = CreateReduxGroup -Tag "MQ" -Text "Select - Master Quest Dungeons" -Height 2
    CreateReduxCheckBox -Name "InsideTheDekuTree"    -Column 1 -Row 1 -Text "Inside the Deku Tree"     -Checked -Info "Patch Inside the Deku Tree to Master Quest"     -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "DodongosCavern"       -Column 2 -Row 1 -Text "Dodongo's Cavern"         -Checked -Info "Patch Dodongo's Cavern to Master Quest"         -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "InsideJabuJabusBelly" -Column 3 -Row 1 -Text "Inside Jabu-Jabu's Belly" -Checked -Info "Patch Inside Jabu-Jabu's Belly to Master Quest" -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "ForestTemple"         -Column 4 -Row 1 -Text "Forest Temple"            -Checked -Info "Patch Forest Temple to Master Quest"            -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "FireTemple"           -Column 5 -Row 1 -Text "Fire Temple"              -Checked -Info "Patch Fire Temple to Master Quest"              -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "WaterTemple"          -Column 6 -Row 1 -Text "Water Temple"             -Checked -Info "Patch Water Temple to Master Quest"             -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "ShadowTemple"         -Column 1 -Row 2 -Text "Shadow Temple"            -Checked -Info "Patch Shadow Temple to Master Quest"            -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "SpiritTemple"         -Column 2 -Row 2 -Text "Spirit Temple"            -Checked -Info "Patch Spirit Temple to Master Quest"            -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "IceCavern"            -Column 3 -Row 2 -Text "Ice Cavern"               -Checked -Info "Patch Ice Cavern to Master Quest"               -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "BottomOfTheWell"      -Column 4 -Row 2 -Text "Bottom of the Well"       -Checked -Info "Patch Bottom of the Well to Master Quest"       -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "GerudoTrainingGround" -Column 5 -Row 2 -Text "Gerudo Training Ground"   -Checked -Info "Patch Gerudo Training Ground to Master Quest"   -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "InsideGanonsCastle"   -Column 6 -Row 2 -Text "Inside Ganon's Castle"    -Checked -Info "Patch Inside Ganon's Castle to Master Quest"    -Credits "ShadowOne333"

    # RANDOMIZE MASTER QUEST DUNGEONS #
    $Redux.Box.RandomizeMQ = CreateReduxGroup -Tag "MQ" -Text "Randomize - Master Quest Dungeons"
    $Items = @("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12")
    CreateReduxComboBox -Name "Minimum" -Column 1 -Text "Minimum:" -Default 1  -Items $Items
    CreateReduxComboBox -Name "Maximum" -Column 3 -Text "Maximum:" -Default 13 -Items $Items



    $Redux.Hero.Damage.Add_SelectedIndexChanged({ $Redux.Hero.Recovery.Enabled = $this.text -ne "OHKO Mode" })
    $Redux.Hero.Recovery.Enabled = $Redux.Hero.Damage.text -ne "OHKO Mode"

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

}



#==============================================================================================================================================================================================
function CreateTabColorsOcarinaOfTime() {

    # EQUIPMENT COLORS #
    CreateReduxGroup -Tag "Colors" -Text "Equipment Colors" -Height 3
    $Redux.Colors.Equipment = @()
    $Colors = @("Kokiri Green", "Goron Red", "Zora Blue", "Black", "White", "Azure Blue", "Vivid Cyan", "Light Red", "Fuchsia", "Purple", "Majora Purple", "Twitch Purple", "Persian Rose", "Dirty Yellow", "Blush Pink", "Hot Pink", "Rose Pink", "Orange", "Gray", "Gold", "Silver", "Beige", "Teal", "Blood Red", "Blood Orange", "Royal Blue", "Sonic Blue", "NES Green", "Dark Green", "Lumen", "Randomized", "Custom")
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "KokiriTunic"       -Column 1 -Row 1 -Text "Kokiri Tunic Color:"        -Default 1 -Length 230 -Shift 70 -Items $Colors -Info ("Select a color scheme for the Kokiri Tunic`n" + '"Randomized" fully randomizes the colors each time the patcher is opened') -Credits "Ported from Rando"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "GoronTunic"        -Column 1 -Row 2 -Text "Goron Tunic Color:"         -Default 2 -Length 230 -Shift 70 -Items $Colors -Info ("Select a color scheme for the Goron Tunic`n" + '"Randomized" fully randomizes the colors each time the patcher is opened')  -Credits "Ported from Rando"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "ZoraTunic"         -Column 1 -Row 3 -Text "Zora Tunic Color:"          -Default 3 -Length 230 -Shift 70 -Items $Colors -Info ("Select a color scheme for the Zora Tunic`n" + '"Randomized" fully randomizes the colors each time the patcher is opened')   -Credits "Ported from Rando"
    $Colors = @("Silver", "Gold", "Black", "Green", "Blue", "Bronze", "Red", "Sky Blue", "Pink", "Magenta", "Orange", "Lime", "Purple", "Randomized", "Custom")
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "SilverGauntlets"   -Column 4 -Row 1 -Text "Silver Gauntlets Color:"    -Default 1 -Length 230 -Shift 70 -Items $Colors -Info ("Select a color scheme for the Silver Gauntlets`n" + '"Randomized" fully randomizes the colors each time the patcher is opened') -Credits "Ported from Rando"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "GoldenGauntlets"   -Column 4 -Row 2 -Text "Golden Gauntlets Color:"    -Default 2 -Length 230 -Shift 70 -Items $Colors -Info ("Select a color scheme for the Golden Gauntlets`n" + '"Randomized" fully randomizes the colors each time the patcher is opened') -Credits "Ported from Rando"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "MirrorShieldFrame" -Column 4 -Row 3 -Text "Mirror Shield Frame Color:" -Default 1 -Length 230 -Shift 70 -Items @("Red", "Green", "Blue", "Yellow", "Cyan", "Magenta", "Orange", "Gold", "Purple", "Pink", "Randomized", "Custom") -Info "Select a color scheme for the Mirror Shield Frame`n- This option might not work for every custom player model" -Credits "Ported from Rando"

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
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "1E691B" -Name "SetKokiriTunic"       -IsGame
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "641400" -Name "SetGoronTunic"        -IsGame
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "003C64" -Name "SetZoraTunic"         -IsGame
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "FFFFFF" -Name "SetSilverGauntlets"   -IsGame
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "FECF0F" -Name "SetGoldenGauntlets"   -IsGame
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "D70000" -Name "SetMirrorShieldFrame" -IsGame

    # Equipment Colors - Labels
    $Redux.Colors.EquipmentLabels = @()
    for ($i=0; $i -lt $Buttons.length; $i++) {
        $Buttons[$i].Add_Click({ $Redux.Colors.SetEquipment[[int]$this.Tag].ShowDialog(); $Redux.Colors.Equipment[[int]$this.Tag].Text = "Custom"; $Redux.Colors.EquipmentLabels[[int]$this.Tag].BackColor = $Redux.Colors.SetEquipment[[int]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetEquipment[[int]$this.Tag].Tag] = $Redux.Colors.SetEquipment[[int]$this.Tag].Color.Name })
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

    # FAIRY COLORS #
    CreateFairyColorOptions -Name "Navi" -Second "Tatl" -Preset ("`n" + 'Selecting the presets "Tatl" or "Tael" will also change the references for "Navi" in the dialogue')

}



#==============================================================================================================================================================================================
function CreateTabEquipmentOcarinaOfTime() {

    # CAPACITY SELECTION #
    CreateReduxGroup    -Tag  "Capacity" -Text "Capacity Selection"
    CreateReduxCheckBox -Name "EnableAmmo"   -Column 1 -Text "Change Ammo Capacity"   -Info "Enable changing the capacity values for ammo"
    CreateReduxCheckBox -Name "EnableWallet" -Column 2 -Text "Change Wallet Capacity" -Info "Enable changing the capacity values for the wallets"

    # AMMO #
    $Redux.Box.Ammo = CreateReduxGroup -Tag "Capacity" -Text "Ammo Capacity Selection" -Height 3
    CreateReduxTextBox -Name "Quiver1"     -Column 1 -Row 1           -Text "Quiver (1)"      -Value 30  -Info "Set the capacity for the Quiver (Base)`nDefault = 30"           -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver2"     -Column 2 -Row 1           -Text "Quiver (2)"      -Value 40  -Info "Set the capacity for the Quiver (Upgrade 1)`nDefault = 40"      -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver3"     -Column 3 -Row 1           -Text "Quiver (3)"      -Value 50  -Info "Set the capacity for the Quiver (Upgrade 2)`nDefault = 50"      -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag1"    -Column 4 -Row 1           -Text "Bomb Bag (1)"    -Value 20  -Info "Set the capacity for the Bomb Bag (Base)`nDefault = 20"         -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag2"    -Column 5 -Row 1           -Text "Bomb Bag (2)"    -Value 30  -Info "Set the capacity for the Bomb Bag (Upgrade 1)`nDefault = 30"    -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag3"    -Column 6 -Row 1           -Text "Bomb Bag (3)"    -Value 40  -Info "Set the capacity for the Bomb Bag (Upgrade 2)`nDefault = 40"    -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BulletBag1"  -Column 1 -Row 2           -Text "Bullet Bag (1)"  -Value 30  -Info "Set the capacity for the Bullet Bag (Base)`nDefault = 30"       -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BulletBag2"  -Column 2 -Row 2           -Text "Bullet Bag (2)"  -Value 40  -Info "Set the capacity for the Bullet Bag (Upgrade 1)`nDefault = 40"  -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BulletBag3"  -Column 3 -Row 2           -Text "Bullet Bag (3)"  -Value 50  -Info "Set the capacity for the Bullet Bag (Upgrade 2)`nDefault = 50"  -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuSticks1" -Column 4 -Row 2           -Text "Deku Sticks (1)" -Value 10  -Info "Set the capacity for the Deku Sticks (Base)`nDefault = 10"      -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuSticks2" -Column 5 -Row 2           -Text "Deku Sticks (2)" -Value 20  -Info "Set the capacity for the Deku Sticks (Upgrade 1)`nDefault = 20" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuSticks3" -Column 6 -Row 2           -Text "Deku Sticks (3)" -Value 30  -Info "Set the capacity for the Deku Sticks (Upgrade 2)`nDefault = 30" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuNuts1"   -Column 1 -Row 3           -Text "Deku Nuts (1)"   -Value 20  -Info "Set the capacity for the Deku Nuts (Base)`nDefault = 20"        -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuNuts2"   -Column 2 -Row 3           -Text "Deku Nuts (2)"   -Value 30  -Info "Set the capacity for the Deku Nuts (Upgrade 1)`nDefault = 30"   -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuNuts3"   -Column 3 -Row 3           -Text "Deku Nuts (3)"   -Value 40  -Info "Set the capacity for the Deku Nuts (Upgrade 2)`nDefault = 40"   -Credits "GhostlyDark"

    # WALLET #
    $Redux.Box.Wallet = CreateReduxGroup -Tag "Capacity" -Text "Wallet Capacity Selection"
    CreateReduxTextBox -Name "Wallet1"     -Column 1 -Row 1 -Length 3 -Text "Wallet (1)"      -Value 99  -Info "Set the capacity for the Wallet (Base)`nDefault = 99"           -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet2"     -Column 2 -Row 1 -Length 3 -Text "Wallet (2)"      -Value 200 -Info "Set the capacity for the Wallet (Upgrade 1)`nDefault = 200"     -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet3"     -Column 3 -Row 1 -Length 3 -Text "Wallet (3)"      -Value 500 -Info "Set the capacity for the Wallet (Upgrade 2)`nDefault = 500"     -Credits "GhostlyDark"

    # UNLOCK CHILD RESTRICTIONS #
    CreateReduxGroup    -Tag  "Unlock" -Text "Unlock Child Restrictions"
    CreateReduxCheckBox -Name "Tunics"         -Column 1 -Text "Unlock Tunics"            -Info "Child Link is able to use the Goron Tunic and Zora Tunic`nSince you might want to walk around in style as well when you are young`nThe dialogue script will be adjusted to reflect this (only for English)" -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "MasterSword"    -Column 2 -Text "Unlock Master Sword"      -Info "Child Link is able to use the Master Sword`nThe Master Sword does twice as much damage as the Kokiri Sword" -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "GiantsKnife"    -Column 3 -Text "Unlock Giant's Knife [!]" -Info "Child Link is able to use the Giant's Knife / Biggoron Sword`nThe Giant's Knife / Biggoron Sword does four times as much damage as the Kokiri Sword`nThe Giant's Knife / Biggoron Sword appears as if Link if thrusting the sword through the ground" -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "MirrorShield"   -Column 4 -Text "Unlock Mirror Shield [!]" -Info "Child Link is able to use the Mirror Shield`nThe Mirror Shield appears as invisible but can still reflect magic or sunlight" -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "Boots"          -Column 5 -Text "Unlock Boots [!]"         -Info "Child Link is able to use the Iron Boots and Hover Boots`n[!] The Iron and Hover Boots appears as the Kokiri Boots"          -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "MegatonHammer"  -Column 6 -Text "Unlock Hammer [!]"        -Info "Child Link is able to use the Megaton Hammer`n[!] The Megaton Hammer appears as invisible"                                   -Credits "GhostlyDark"

    # UNLOCK ADULT RESTRICTIONS #
    CreateReduxGroup    -Tag  "Unlock" -Text "Unlock Adult Restrictions"
    CreateReduxCheckBox -Name "KokiriSword"    -Column 1 -Text "Unlock Kokiri Sword"      -Info "Adult Link is able to use the Kokiri Sword`nThe Kokiri Sword does half as much damage as the Master Sword"          -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "DekuShield"     -Column 2 -Text "Unlock Deku Shield [!]"   -Info "Adult Link is able to use the Deku Shield`nThe Deku Shield appears as invisible but can still be burned up by fire" -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "FairySlingshot" -Column 3 -Text "Unlock Slingshot [!]"     -Info "Adult Link is able to use the Fairy Slingshot`n[!] The Fairy Slingshot appears as the Fairy Bow"                    -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "Boomerang"      -Column 4 -Text "Unlock Boomerang [!]"     -Info "Adult Link is able to use the Boomerang`n[!] The Boomerang appears as invisible"                                    -Credits "GhostlyDark"



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
function CreateTabCutscenesOcarinaOfTime() {
    
    # SKIP CUTSCENES #
    CreateReduxGroup    -Tag  "Skip" -Text "Skip Cutscenes"
    CreateReduxCheckBox -Name "IntroSequence" -Column 1 -Text "Intro Sequence" -Info "Skip the intro sequence, so you can start playing immediately"                    -Credits "Ported from Better OoT"
    CreateReduxCheckBox -Name "AllMedallions" -Column 2 -Text "All Medallions" -Info "Cutscene for all medallions never triggers when leaving shadow or spirit temples" -Credits "Ported from Better OoT"
    CreateReduxCheckBox -Name "DaruniaDance"  -Column 3 -Text "Darunia Dance"  -Info "Darunia will not dance"                                                           -Credits "Ported from Better OoT"

    # SPEEDUP CUTSCENES #
    CreateReduxGroup    -Tag  "Skip" -Text "Speed-Up Cutscenes"
    CreateReduxCheckBox -Name "OpeningChests" -Column 1 -Text "Opening Chests" -Info "Make all chest opening animations fast by kicking them open" -Credits "Ported from Better OoT"
    CreateReduxCheckBox -Name "KingZora"      -Column 2 -Text "King Zora"      -Info "King Zora moves quickly"                                     -Credits "Ported from Better OoT"
    CreateReduxCheckBox -Name "ZeldasEscape"  -Column 3 -Text "Zelda's Escape" -Info "Speed-up Zelda escaping from Hyrule Castle"                  -Credits "Ported from Better OoT"      

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function PatchOptionsOcarinaOfTime
Export-ModuleMember -Function ByteOptionsOcarinaOfTime
Export-ModuleMember -Function ByteReduxOcarinaOfTime
Export-ModuleMember -Function ByteLanguageOcarinaOfTime

Export-ModuleMember -Function CreateOptionsOcarinaOfTime
Export-ModuleMember -Function CreateTabMainOcarinaOfTime
Export-ModuleMember -Function CreateTabAudiovisualOcarinaOfTime
Export-ModuleMember -Function CreateTabDifficultyOcarinaOfTime
Export-ModuleMember -Function CreateTabColorsOcarinaOfTime
Export-ModuleMember -Function CreateTabEquipmentOcarinaOfTime
Export-ModuleMember -Function CreateTabCutscenesOcarinaOfTime
Export-ModuleMember -Function CreateTabReduxOcarinaOfTime
Export-ModuleMember -Function CreateTabLanguageOcarinaOfTime