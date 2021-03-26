function PatchOptions() {
    
    # ENHANCED 16:9 WIDESCREEN #

    if (IsWidescreen -Experimental) { ApplyPatch -Patch "Decompressed\widescreen.ppf" }



    # MODELS #

    if ( (IsChecked $Redux.Graphics.OriginalModels) -and (IsChecked $Redux.Equipment.RazorSword) ) { ApplyPatch -Patch "Decompressed\Models\razor_sword_vanilla_child.ppf" }
    if (IsChecked $Redux.Graphics.ListLinkModels) {
        if (IsChecked $Redux.Graphics.MMChildLink) {
            ApplyPatch -Patch "Decompressed\Models\mm_child.ppf"
            $Text = $Redux.Graphics.LinkModelsPlus.Text.replace(" (default)", "")
        }
        else { $Text = $Redux.Graphics.LinkModels.Text.replace(" (default)", "") }
        ApplyPatch -Patch ("Decompressed\Models\Link\" + $Text + ".ppf")
    }
    elseif (IsChecked $Redux.Graphics.ListMaleModels)     { ApplyPatch -Patch ("Decompressed\Models\Male\"   + $Redux.Graphics.MaleModels.Text.replace(" (default)", "") + ".ppf") }
    elseif (IsChecked $Redux.Graphics.ListFemaleModels)   { ApplyPatch -Patch ("Decompressed\Models\Female\" + $Redux.Graphics.FemaleModels.Text.replace(" (default)", "") + ".ppf") }



    # DIFFICULTY #

    if (IsChecked $Redux.Hero.HarderChildBosses) { ApplyPatch -Patch "Decompressed\harder_child_bosses.ppf" }



    # MM PAUSE SCREEN #

    if (IsChecked $Redux.Text.PauseScreen) { ApplyPatch -Patch "Decompressed\mm_pause_screen.ppf" }
    
}



#==============================================================================================================================================================================================
function ByteOptions() {
    
    # GAMEPLAY #

    if (IsChecked $Redux.Gameplay.EasierMinigames) {
        ChangeBytes -Offset "CC4024" -Values "00 00 00 00" # Dampe's Digging Game

        ChangeBytes -Offset "DBF428" -Values "0C 10 07 7D 3C 01 42 82 44 81 40 00 44 98 90 00 E6 52" # Easier Fishing
        ChangeBytes -Offset "DBF484" -Values "00 00 00 00" # Easier Fishing
        ChangeBytes -Offset "DBF4A8" -Values "00 00 00 00" # Easier Fishing

        ChangeBytes -Offset "DCBEAB" -Values "48"          # Adult Fish size requirement
        ChangeBytes -Offset "DCBF27" -Values "48"          # Adult Fish size requirement
        ChangeBytes -Offset "DCBF33" -Values "30"          # Child Fish size requirement
        ChangeBytes -Offset "DCBF9F" -Values "30"          # Child Fish size requirement

        ChangeBytes -Offset "E2E698" -Values "80 AA E2 64" # Fixed Bombchu Bowling item order
        ChangeBytes -Offset "E2E6A0" -Values "80 AA E2 4C" # Fixed Bombchu Bowling item order
        ChangeBytes -Offset "E2D440" -Values "24 19 00 00" # Fixed Bombchu Bowling item order
    }

    if (IsChecked $Redux.Gameplay.FasterBlockPushing) {
        ChangeBytes -Offset "DD2B87" -Values "80"          # Block Speed
        ChangeBytes -Offset "DD2D27" -Values "03"          # Block Delay
        ChangeBytes -Offset "DD9683" -Values "80"          # Milk Crate Speed
        ChangeBytes -Offset "DD981F" -Values "03"          # Milk Crate Delay
        ChangeBytes -Offset "CE1BD0" -Values "40 80 00 00" # Amy Puzzle Speed
        ChangeBytes -Offset "CE0F0F" -Values "03"          # Amy Puzzle Delay
        ChangeBytes -Offset "C77CA8" -Values "40 80 00 00" # Fire Block Speed
        ChangeBytes -Offset "C770C3" -Values "01"          # Fire Block Delay
        ChangeBytes -Offset "CC5DBF" -Values "01"          # Forest Basement Puzzle Delay
        ChangeBytes -Offset "DBCF73" -Values "01"          # spirit Cobra Mirror Delay
        ChangeBytes -Offset "DBA233" -Values "19"          # Truth Spinner Speed
        ChangeBytes -Offset "DBA3A7" -Values "00"          # Truth Spinner Delay
    }
    
    if (IsChecked $Redux.Gameplay.Medallions)          { ChangeBytes -Offset "E2B454"  -Values "80 EA 00 A7 24 01 00 3F 31 4A 00 3F 00 00 00 00" }
    if (IsChecked $Redux.Gameplay.ReturnChild)         { ChangeBytes -Offset "CB6844"  -Values "35"; ChangeBytes -Offset "253C0E2" -Values "03" }
    if (IsChecked $Redux.Gameplay.FixGraves)           { ChangeBytes -Offset "202039D" -Values "20"; ChangeBytes -Offset "202043C" -Values "24" }
    if (IsChecked $Redux.Gameplay.DistantZTargeting)   { ChangeBytes -Offset "A987AC"  -Values "00 00 00 00" }
    if (IsChecked $Redux.Gameplay.ManualJump)          { ChangeBytes -Offset "BD78C0"  -Values "04 C1"; ChangeBytes -Offset "BD78E3" -Values "01" }

    <#if (IsChecked $Redux.Gameplay.SwordBeamAttack) {
        ChangeBytes -Offset "D280"   -Values "03 47 E0 00 03 47 FA B0 03 47 E0 00"; ChangeBytes -Offset "B5EF7E" -Values "9B 70"; ChangeBytes -Offset "BEFBF0"  -Values "0C"
        ChangeBytes -Offset "B5EF70" -Values "03 47 E0 00 03 47 FA B0";             ChangeBytes -Offset "B5EF86" -Values "09 20"; ChangeBytes -Offset "BEFBF4"  -Values "0C"
        ChangeBytes -Offset "F17F00" -Values "00";                                  ChangeBytes -Offset "F17F04" -Values "00";    PatchBytes  -Offset "347E000" -Patch "Sword Beam Attack.bin"
    }#>



    # RESTORE #

    if (IsChecked $Redux.Restore.RupeeColors) {
        ChangeBytes -Offset "F47EB0" -Values "70 6B BB 3F FF FF EF 3F 68 AD C3 FD E6 BF CD 7F 48 9B 91 AF C3 7D BB 3D 40 0F 58 19 88 ED 80 AB" # Purple
        ChangeBytes -Offset "F47ED0" -Values "D4 C3 F7 49 FF FF F7 E1 DD 03 EF 89 E7 E3 E7 DD A3 43 D5 C3 DF 85 E7 45 7A 43 82 83 B4 43 CC 83" # Gold
    }

    if (IsChecked $Redux.Restore.Blood) {
        ChangeBytes -Offset "D8D590 " -Values "00 78 00 FF 00 78 00 FF"
        ChangeBytes -Offset "E8C424 " -Values "00 78 00 FF 00 78 00 FF"
    }

    if (IsChecked $Redux.Restore.FireTemple) {
        ChangeBytes -Offset "7465"   -Values "03 91 30"                         # DMA Table, Pointer to AudioBank
        ChangeBytes -Offset "7471"   -Values "03 91 30 00 08 8B B0 00 03 91 30" # DMA Table, Pointer to AudioSeq
        ChangeBytes -Offset "7481"   -Values "08 8B B0 00 4D 9F 40 00 08 8B B0" # DMA Table, Pointer to AudioTable
        ChangeBytes -Offset "B2E82F" -Values "04 24 A5 91 30"                   # MIPS assembly that loads AudioSeq
        ChangeBytes -Offset "B2E857" -Values "09 24 A5 8B B0"                   # MIPS assembly that loads AudioTable
        PatchBytes  -Offset "B896A0" -Patch "Fire Temple Theme\12AudioBankPointers.bin"
        PatchBytes  -Offset "B89AD0" -Patch "Fire Temple Theme\12AudioSeqPointers.bin"
        PatchBytes  -Offset "B8A1C0" -Patch "Fire Temple Theme\12AudioTablePointers.bin"
        ExportAndPatch -Path "audiobank_fire_temple" -Offset "D390" -Length "4CCBB0"
    }

    if (IsChecked $Redux.Restore.CowNoseRing) { ChangeBytes -Offset "EF3E68" -Values "00 00" }



    # OTHER #

    if (IsChecked $Redux.Other.DebugMapSelect) {
        ChangeBytes -Offset "A94994" -Values "00 00 00 00 AE 08 00 14 34 84 B9 2C 8E 02 00 18 24 0B 00 00 AC 8B 00 00"
        ChangeBytes -Offset "B67395" -Values "B9 E4 00 00 BA 11 60 80 80 09 C0 80 80 37 20 80 80 1C 14 80 80 1C 14 80 80 1C 08"
        ExportAndPatch -Path "debug_map_select" -Offset "B9FD90" -Length "EC0"
    }

    if (IsChecked $Redux.Other.SubscreenDelayFix)    { ChangeBytes -Offset "B15DD0" -Values "00 00 00 00"; ChangeBytes -Offset "B12947" -Values "03" }
    if (IsChecked $Redux.Other.PoacherSawFix)        { ChangeBytes -Offset "AE72CC" -Values "00 00 00 00" }
    if (IsChecked $Redux.Other.RemoveNaviPrompts)    { ChangeBytes -Offset "DF8B84" -Values "00 00 00 00" }
    if (IsChecked $Redux.Other.DefaultZTargeting)    { ChangeBytes -Offset "B71E6D" -Values "01" }
    if (IsChecked $Redux.Other.InstantClaimCheck)    { ChangeBytes -Offset "ED4470" -Values "00 00 00 00"; ChangeBytes -Offset "ED4498" -Values "00 00 00 00" }
    if (IsChecked $Redux.Other.HideCredits)          { PatchBytes  -Offset "966000" -Patch "Message\Credits.bin" }
    


    # GRAPHICS #

    if ( (IsChecked $Redux.Graphics.Widescreen) -and ($IsWiiVC -or !(IsWidescreen -Experimental) ) ) {
        # 16:9 Widescreen
        if ($IsWiiVC ) { ChangeBytes -Offset "B08038" -Values "3C 07 3F E3" }

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

    if ( (IsIndex -Elem $Redux.Graphics.BlackBars -Index 2) -or (IsIndex -Elem $Redux.Graphics.BlackBars -Index 4) ) {
        ChangeBytes -Offset "B0F680" -Values "00 00 00 00"
    }
    if ( (IsIndex -Elem $Redux.Graphics.BlackBars -Index 3) -or (IsIndex -Elem $Redux.Graphics.BlackBars -Index 4) ) {
        ChangeBytes -Offset "B0F5A4" -Values "00 00 00 00"
        ChangeBytes -Offset "B0F5D4" -Values "00 00 00 00"
        ChangeBytes -Offset "B0F5E4" -Values "00 00 00 00"
        ChangeBytes -Offset "B0F688" -Values "00 00 00 00"
    }

    if (IsChecked $Redux.Graphics.ExtendedDraw)      { ChangeBytes -Offset "A9A970" -Values "00 01" }
    if (IsChecked $Redux.Graphics.ForceHiresModel)   { ChangeBytes -Offset "BE608B" -Values "00" }



    # INTERFACE #

    if (IsChecked $Redux.UI.HudTextures) {
        PatchBytes  -Offset "1A3CA00" -Texture -Patch "HUD\MM Button.bin"
        PatchBytes  -Offset "1A3C100" -Texture -Patch "HUD\MM Hearts.bin"
        PatchBytes  -Offset "1A3DE00" -Texture -Patch "HUD\MM Key & Rupee.bin"
    }

    if (IsChecked $Redux.UI.ButtonPositions) {
        ChangeBytes -Offset "B57F03" -Values "04" -Add # A Button / Text - X position (BA -> BE, +04)
        ChangeBytes -Offset "B586A7" -Values "0E" -Add # A Button / Text - Y position (09 -> 17, +0E)
        ChangeBytes -Offset "B57EEF" -Values "07" -Add # B Button - X position (A0 -> A7, +07)
        ChangeBytes -Offset "B589EB" -Values "07" -Add # B Text   - X position (94 -> 9B, +07)
    }

    if (IsChecked $Redux.UI.CenterNaviPrompt) {
        if (IsWidescreen -Experimental)   { ChangeBytes -Offset "B582DF" -Values "5E" }
        else                              { ChangeBytes -Offset "B582DF" -Values "F6" }
    }

    if (IsChecked $Redux.UI.GCScheme) {
        # Z to L textures
        PatchBytes -Offset "844540"  -Texture -Patch "GameCube\l_pause_screen_button.bin"
        PatchBytes -Offset "92C200"  -Texture -Patch "GameCube\l_text_icon.bin"
        if (IsSet $LanguagePatch.l_target)     { PatchBytes -Offset "1A35680" -Texture -Patch $LanguagePatch.l_target }
        if (IsSet $LanguagePatch.l_target_jpn) { PatchBytes -Offset "1A0B300" -Texture -Patch $LanguagePatch.l_target.jpn }
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



    # FILE SELECT

    if (IsText -Elem $Redux.FileSelect.Music -Compare "File Select" -Not)   { ChangeBytes -Offset "BAFEE3" -Values (GetOoTMusicID -Music $Redux.FileSelect.Music.Text) }
    if (IsIndex -Elem $Redux.FileSelect.Skybox -Index 4 -Not)               { ChangeBytes -Offset "B67722" -Values $Redux.FileSelect.Skybox.SelectedIndex }
    


    # HERO MODE #

    if (IsText -Elem $Redux.Hero.Damage -Compare "OHKO Mode") {
        ChangeBytes -Offset "AE8073" -Values "09 04" -Interval 16
        ChangeBytes -Offset "AE8096" -Values "82 00"
        ChangeBytes -Offset "AE8099" -Values "00 00 00"
    }
    elseif ( (IsText -Elem $Redux.Hero.Damage -Compare "1x Damage" -Not) -or (IsText -Elem $Redux.Hero.Recovery -Compare "1x Recovery" -Not) ) {
        ChangeBytes -Offset "AE8073" -Values "09 04" -Interval 16
        if         (IsText -Elem $Redux.Hero.Recovery -Compare "1x Recovery") {                
            if     (IsText -Elem $Redux.Hero.Damage -Compare "2x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 40" }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "4x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 80" }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "8x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 C0" }
            ChangeBytes -Offset "AE8099" -Values "00 00 00"
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Compare "1/2x Recovery") {               
            if     (IsText -Elem $Redux.Hero.Damage -Compare "1x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 40" }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "2x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 80" }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "4x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 C0" }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "8x Damage")   { ChangeBytes -Offset "AE8096" -Values "81 00" }
            ChangeBytes -Offset "AE8099" -Values "10 80 43"
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Compare "1/4x Recovery") {                
            if     (IsText -Elem $Redux.Hero.Damage -Compare "1x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 80" }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "2x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 C0" }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "4x Damage")   { ChangeBytes -Offset "AE8096" -Values "81 00" }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "8x Damage")   { ChangeBytes -Offset "AE8096" -Values "81 40" }
            ChangeBytes -Offset "AE8099" -Values "10 80 83"
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Compare "0x Recovery") {                
            if     (IsText -Elem $Redux.Hero.Damage -Compare "1x Damage")   { ChangeBytes -Offset "AE8096" -Values "81 40" }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "2x Damage")   { ChangeBytes -Offset "AE8096" -Values "81 80" }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "4x Damage")   { ChangeBytes -Offset "AE8096" -Values "81 C0" }
            elseif (IsText -Elem $Redux.Hero.Damage -Compare "8x Damage")   { ChangeBytes -Offset "AE8096" -Values "82 00" }
            ChangeBytes -Offset "AE8099" -Values "10 81 43"
            ChangeBytes -Offset "A895B7" -Values "2E" # No Heart Drops
        }
    }

    if (IsText -Elem $Redux.Hero.MagicUsage -Compare "2x Magic Usage")      { ChangeBytes -Offset "AE84FA" -Values "2C","40" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "3x Magic Usage")  { ChangeBytes -Offset "AE84FA" -Values "2C","80" }

    # Monsters
    if (IsText -Elem $Redux.Hero.MonsterHP -Compare "2x Monster HP") {
        ChangeBytes -Offset "C11177" -Values "08" # Dodongo                      (HP: 04)   C10BB0 -> C13950 (Length: 2DA0) (ovl_En_Dodongo)
        ChangeBytes -Offset "C2B183" -Values "04" # Tektite         (Red)        (HP: 02)   C2B0C0 -> C2DE60 (Length: 2DA0) (ovl_En_Tite)
        ChangeBytes -Offset "C2B1F7" -Values "08" # Tektite         (Blue)       (HP: 04)
        ChangeBytes -Offset "D76A07" -Values "08" # Tentacle                     (HP: 04)   D76880 -> D78750 (Length: 1ED0) (ovl_En_Ba)
        ChangeBytes -Offset "CD724F" -Values "10" # ReDead          (Both)       (HP: 08)   CD71B0 -> CD9A60 (Length: 28B0) (ovl_En_Rd)
        ChangeBytes -Offset "EDC597" -Values "04" # Stalchild       (Small)      (HP: 02)   EDC370 -> EDDC60 (Length: 18F0) (ovl_En_Skb)
        ChangeBytes -Offset "C1097C" -Values "08" # Wallmaster                   (HP: 04)   C0F1A0 -> C10BB0 (Length: 1A10) (ovl_En_Wallmas)
        ChangeBytes -Offset "CD582C" -Values "08" # Floormaster                  (HP: 04)   CD28C0 -> CD5CA0 (Length: 33E0) (ovl_En_Floormas)
        ChangeBytes -Offset "C6471B" -Values "0C" # Torch Slug                   (HP: 06)   C64670 -> C679D0 (Length: 3360) (ovl_En_Bw)
        ChangeBytes -Offset "C51A9F" -Values "04" # Gohma Larva                  (HP: 02)   C51860 -> C544F0 (Length: 2C90) (ovl_En_Goma)
        ChangeBytes -Offset "D74393" -Values "08" # Like-Like                    (HP: 04)   D74360 -> D76880 (Length: 2520) (ovl_En_Rr)
        ChangeBytes -Offset "C2F97F" -Values "0C" # Peehat                       (HP: 06)   C2F8D0 -> C32FD0 (Length: 3700) (ovl_En_Peehat)
        ChangeBytes -Offset "C2DEE7" -Values "08" # Leever          (Green)      (HP: 04)   C2DE60 -> C2F8D0 (Length: 1A70) (ovl_En_Reeba)
        ChangeBytes -Offset "C2DF4B" -Values "28" # Leever          (Purple)     (HP: 14)
        ChangeBytes -Offset "C836AB" -Values "0C" # Moblin          (Club)       (HP: 06)   C83500 -> C87640 (Length: 4140) (ovl_En_Mb)
        ChangeBytes -Offset "CAAF9C" -Values "04" # Bari                         (HP: 02)   CA8DC0 -> CAB460 (Length: 26A0) (ovl_En_Vali)
        ChangeBytes -Offset "C693CC" -Values "04" # Stinger (Land)               (HP: 02)   C679D0 -> C69630 (Length: 1C60) (ovl_En_Eiyer)

        # Incomplete
      # ChangeBytes -Offset "" -Values "04" # Bubble                             (HP: 02)   CB1620 -> CB52F0 (Length: 3CD0) (ovl_En_Bb)
      # ChangeBytes -Offset "" -Values "02" # Guay                               (HP: 01)   EEE2F0 -> EEF990 (Length: 16A0) (ovl_En_Crow)
      # ChangeBytes -Offset "" -Values "02" # Keese                              (HP: 01)   C13950 -> C15AC0 (Length: 2170) (ovl_En_Firefly)
      # ChangeBytes -Offset "" -Values "02" # Spike                              (HP: 01)   DADB80 -> DAF4B0 (Length: 1930) (ovl_En_Ny)
      # ChangeBytes -Offset "" -Values "02" # Mad Scrub                          (HP: 01)   CA6FA0 -> CA87A0 (Length: 1800) (ovl_En_Dekunuts)
      # ChangeBytes -Offset "" -Values "02" # Biri                               (HP: 01)   C5D8E0 -> C5FBB0 (Length: 22D0) (ovl_En_Bili)
      # ChangeBytes -Offset "" -Values "02" # Stinger (Water)                    (HP: 01)   EB6140 -> EB7B40 (Length: 1A00) (ovl_En_Weiyer)
      # ChangeBytes -Offset "" -Values "02" # Peehat Larva                       (HP: 01)   C2F8D0 -> C32FD0 (Length: 3700) (ovl_En_Peehat)
      # ChangeBytes -Offset "" -Values "01" # Shell Blade                        (HP: 01)   D46390 -> D477D0 (Length: 1440) (ovl_En_Sb)
      # ChangeBytes -Offset "" -Values "04" # Skulltula                          (HP: 02)   C61A00 -> C64670 (Length: 2C70) (ovl_En_St)
      # ChangeBytes -Offset "" -Values "02" # Skullwalltula         (Regular)    (HP: 01)   CE2E80 -> CE65F0 (Length: 3770) (ovl_En_Sw)
      # ChangeBytes -Offset "" -Values "04" # Skullwalltula         (Gold)       (HP: 02)
      # ChangeBytes -Offset "" -Values "04" # Moblin                (Spear)      (HP: 02)
      # ChangeBytes -Offset "" -Values "08" # Poe                                (HP: 04)   C07B60 -> C0BCF0 (Length: 4190) (ovl_En_Poh)
      # ChangeBytes -Offset "" -Values "02" # Shabom                             (HP: 01)   C547F0 -> C55C10 (Length: 1420) (ovl_En_Bubble)
      # ChangeBytes -Offset "" -Values "02" # Tailpasaran                        (HP: 01)   C5FBB0 -> C61A00 (Length: 1E50) (ovl_En_Tp)
      # ChangeBytes -Offset "" -Values "02" # Baby Dodongo                       (HP: 01)   C57E90 -> C59D30 (Length: 1EA0) (ovl_En_Dodojr)
      # ChangeBytes -Offset "" -Values "02" # Octorok                            (HP: 01)   C0BCF0 -> C0E2D0 (Length: 25E0) (ovl_En_Okuta)
      # ChangeBytes -Offset "" -Values "04" # Big Poe                            (HP: 04)   E75040 -> E78A20 (Length: 39E0) (ovl_En_Po_Field)
      # ChangeBytes -Offset "" -Values "02" # Anubis                             (HP: 01)   D79240 -> D7A4F0 (Length: 12B0) (ovl_En_Anubice)
      # ChangeBytes -Offset "" -Values "02" # Beamos                             (HP: 01)   CC6B80 -> CC8430 (Length: 18B0) (ovl_En_Vm)
      # ChangeBytes -Offset "" -Values "04" # Armos                              (HP: 02)   C96840 -> C98C40 (Length: 2400) (ovl_En_Am)
      # ChangeBytes -Offset "DFC9A3" -Values "0C" # Freezard                     (HP: 06)   DFC970 -> DFE980 (Length: 2010) (ovl_En_Fz)
    }
    elseif (IsText -Elem $Redux.Hero.MonsterHP -Compare "3x Monster HP") {
        ChangeBytes -Offset "C11177" -Values "0C" # Dodongo                      (HP: 04)   C10BB0 -> C13950 (Length: 2DA0) (ovl_En_Dodongo)
        ChangeBytes -Offset "C2B183" -Values "06" # Tektite         (Red)        (HP: 02)   C2B0C0 -> C2DE60 (Length: 2DA0) (ovl_En_Tite)
        ChangeBytes -Offset "C2B1F7" -Values "0C" # Tektite         (Blue)       (HP: 04)
        ChangeBytes -Offset "D76A07" -Values "0C" # Tentacle                     (HP: 04)   D76880 -> D78750 (Length: 1ED0) (ovl_En_Ba)
        ChangeBytes -Offset "CD724F" -Values "18" # ReDead          (Both)       (HP: 08)   CD71B0 -> CD9A60 (Length: 28B0) (ovl_En_Rd)
        ChangeBytes -Offset "EDC597" -Values "06" # Stalchild       (Small)      (HP: 02)   EDC370 -> EDDC60 (Length: 18F0) (ovl_En_Skb)
        ChangeBytes -Offset "C1097C" -Values "0C" # Wallmaster                   (HP: 04)   C0F1A0 -> C10BB0 (Length: 1A10) (ovl_En_Wallmas)
        ChangeBytes -Offset "CD582C" -Values "0C" # Floormaster                  (HP: 04)   CD28C0 -> CD5CA0 (Length: 33E0) (ovl_En_Floormas)
        ChangeBytes -Offset "C6471B" -Values "12" # Torch Slug                   (HP: 06)   C64670 -> C679D0 (Length: 3360) (ovl_En_Bw)
        ChangeBytes -Offset "C51A9F" -Values "06" # Gohma Larva                  (HP: 02)   C51860 -> C544F0 (Length: 2C90) (ovl_En_Goma)
        ChangeBytes -Offset "D74393" -Values "0C" # Like-Like                    (HP: 04)   D74360 -> D76880 (Length: 2520) (ovl_En_Rr)
        ChangeBytes -Offset "C2F97F" -Values "12" # Peehat                       (HP: 06)   C2F8D0 -> C32FD0 (Length: 3700) (ovl_En_Peehat)
        ChangeBytes -Offset "C2DEE7" -Values "0C" # Leever          (Green)      (HP: 04)   C2DE60 -> C2F8D0 (Length: 1A70) (ovl_En_Reeba)
        ChangeBytes -Offset "C2DF4B" -Values "3C" # Leever          (Purple)     (HP: 14)
        ChangeBytes -Offset "C836AB" -Values "12" # Moblin          (Club)       (HP: 06)   C83500 -> C87640 (Length: 4140) (ovl_En_Mb)
        ChangeBytes -Offset "CAAF9C" -Values "06" # Bari                         (HP: 02)   CA8DC0 -> CAB460 (Length: 26A0) (ovl_En_Vali)
        ChangeBytes -Offset "C693CC" -Values "06" # Stinger (Land)               (HP: 02)   C679D0 -> C69630 (Length: 1C60) (ovl_En_Eiyer)
    }

    # Mini-Bosses
    if (IsText -Elem $Redux.Hero.MiniBossHP -Compare "2x Mini-Boss HP") {
        ChangeBytes -Offset "C3452F" -Values "0C" # Lizalfos                     (HP: 06)   C340D0 -> C3ABC0 (Length: 6AF0) (ovl_En_Zf)
        ChangeBytes -Offset "C3453B" -Values "18" # Dinolfos                     (HP: 0C)   C340D0 -> C3ABC0 (Length: 6AF0) (ovl_En_Zf)
        ChangeBytes -Offset "ED80EB" -Values "10" # Wolfos          (Both)       (HP: 08)   ED8060 -> EDC370 (Length: 6AF0) (ovl_En_Wf)
        ChangeBytes -Offset "BFADAB" -Values "10" # Stalfos                      (HP: 0A)   BFAC30 -> C004E0 (Length: 58B0) (ovl_En_Test)
        ChangeBytes -Offset "D09283" -Values "1C" # Dead Hand                    (HP: 0E)   D091D0 -> D0ACA0 (Length: 1AD0) (ovl_En_Dh)
        ChangeBytes -Offset "DE9A1B" -Values "3C" # Iron Knuckle    (Phase 1)    (HP: 1E)   DE98A0 -> DEDED0 (Length: 4630) (ovl_En_Ik)
        ChangeBytes -Offset "DEB34F" -Values "15" # Iron Knuckle    (Phase 2)    (HP: 0B)
        ChangeBytes -Offset "EBC8B7" -Values "28" # Gerudo Fighter               (HP: 14)   EBC840 -> EC1BF0 (Length: 53B0) (ovl_En_GeldB)
        ChangeBytes -Offset "CF2667" -Values "0A" # Flare Dancer                 (HP: 08)   CF25E0 -> CF52A0 (Length: 2CC0) (ovl_En_Fd)
        ChangeBytes -Offset "CDE1FC" -Values "14" # Poe Sisters                  (HP: 0A)   CD9A60 -> CDE750 (Length: 4CF0) (ovl_En_Po_Sisters)
        ChangeBytes -Offset "DEF87F" -Values "14" # Skullkid                     (HP: 0A)   DEF3E0 -> DF2D10 (Length: 3930) (ovl_En_Skj)

        # Unlocatable ?
      # ChangeBytes -Offset "" -Values "08" # Big Octo                           (HP: 04)   D477D0 -> D4A2E0 (Length: 2B10) (ovl_En_Bigokuta)
      # ChangeBytes -Offset "" -Values "" # Dark Link                            (HP: xx)   C5B180 -> C5D8E0 (Length: 2760) (ovl_En_Torch2)
    }
    elseif (IsText -Elem $Redux.Hero.MiniBossHP -Compare "3x Mini-Boss HP") {
        ChangeBytes -Offset "C3452F" -Values "12" # Lizalfos                     (HP: 06)   C340D0 -> C3ABC0 (Length: 6AF0) (ovl_En_Zf)
        ChangeBytes -Offset "C3453B" -Values "24" # Dinolfos                     (HP: 0C)   C340D0 -> C3ABC0 (Length: 6AF0) (ovl_En_Zf)
        ChangeBytes -Offset "ED80EB" -Values "18" # Wolfos          (Both)       (HP: 08)   ED8060 -> EDC370 (Length: 6AF0) (ovl_En_Wf)
        ChangeBytes -Offset "BFADAB" -Values "1E" # Stalfos                      (HP: 0A)   BFAC30 -> C004E0 (Length: 58B0) (ovl_En_Test)
        ChangeBytes -Offset "D09283" -Values "2A" # Dead Hand                    (HP: 0E)   D091D0 -> D0ACA0 (Length: 1AD0) (ovl_En_Dh)
        ChangeBytes -Offset "DE9A1B" -Values "5A" # Iron Knuckle    (Phase 1)    (HP: 1E)   DE98A0 -> DEDED0 (Length: 4630) (ovl_En_Ik)
        ChangeBytes -Offset "DEB34F" -Values "1F" # Iron Knuckle    (Phase 2)    (HP: 0B)
        ChangeBytes -Offset "EBC8B7" -Values "3C" # Gerudo Fighter               (HP: 14)   EBC840 -> EC1BF0 (Length: 53B0) (ovl_En_GeldB)
        ChangeBytes -Offset "CF2667" -Values "0C" # Flare Dancer                 (HP: 08)   CF25E0 -> CF52A0 (Length: 2CC0) (ovl_En_Fd)
        ChangeBytes -Offset "CDE1FC" -Values "1E" # Poe Sisters                  (HP: 0A)   CD9A60 -> CDE750 (Length: 4CF0) (ovl_En_Po_Sisters)
        ChangeBytes -Offset "DEF87F" -Values "1E" # Skullkid                     (HP: 0A)   DEF3E0 -> DF2D10 (Length: 3930) (ovl_En_Skj)
    }
    
    # Bosses
    if (IsText -Elem $Redux.Hero.BossHP -Compare "2x Boss HP") {
        ChangeBytes -Offset "C44F2B" -Values "14" # Gohma                        (HP: 0A)   C44C30 -> C4ABB0 (Length: 5F80)  (ovl_Boss_Goma)
        ChangeBytes -Offset "C486CC" -Values "00 00 00 00" # Spawn all three Gohma Larva at once
        ChangeBytes -Offset "C3B9FF" -Values "18" # King Dodongo                 (HP: 0C)   C3B150 -> C44C30 (Length: 9AE0)  (ovl_Boss_Dodongo)
        ChangeBytes -Offset "D258BB" -Values "08" # Barinade        (Phase 1)    (HP: 04)   D22360 -> D30B50 (Length: E7F0)  (ovl_Boss_Va)
        ChangeBytes -Offset "D25B0B" -Values "06" # Barinade        (Phases 4-6) (HP: 03)
        ChangeBytes -Offset "C91F8F" -Values "3C" # Phantom Ganon   (Phase 1)    (HP: 1E)   C91AD0 -> C96840 (Length: 4D70)  (ovl_Boss_Ganondrof)
        ChangeBytes -Offset "CAFF33" -Values "31" # Phantom Ganon   (Phase 2)    (HP: 19)
        ChangeBytes -Offset "CE6D2F" -Values "30" # Volvagia                     (HP: 18)   CE65F0 -> CED920 (Length: 7330)  (ovl_Boss_Fd)
        ChangeBytes -Offset "D3B4A7" -Values "28" # Morpha                       (HP: 14)   D3ADF0 -> D46390 (Length: B5A0)  (ovl_Boss_Mo)
        ChangeBytes -Offset "DAC824" -Values "48" # Bongo Bongo                  (HP: 24)   DA1660 -> DADB80 (Length: C520)  (ovl_Boss_Sst)
        ChangeBytes -Offset "D64EFB" -Values "08" # Twinrova        (Phase 1)    (HP: 04)   D612E0 -> D74360 (Length: 13080) (ovl_Boss_Tw)
        ChangeBytes -Offset "D6223F" -Values "30" # Twinrova        (Phase 2)    (HP: 18)
        ChangeBytes -Offset "D7FDA3" -Values "50" # Ganondorf                    (HP: 28)   D7F3F0 -> DA1660 (Length: 22270) (ovl_Boss_Ganon)
        ChangeBytes -Offset "E82AFB" -Values "3C" # Ganon           (Phase 1)    (HP: 1E)   E826C0 -> E939B0 (Length: 112F0) (ovl_Boss_Ganon2)
        ChangeBytes -Offset "E87F2F" -Values "29" # Ganon           (Phase 2)    (HP: 15)
    }
    elseif (IsText -Elem $Redux.Hero.BossHP -Compare "3x Boss HP") {
        ChangeBytes -Offset "C44F2B" -Values "1E" # Gohma                        (HP: 0A)   C44C30 -> C4ABB0 (Length: 5F80)  (ovl_Boss_Goma)
        ChangeBytes -Offset "C486CC" -Values "00 00 00 00" # Spawn all three Gohma Larva at once
        ChangeBytes -Offset "C3B9FF" -Values "24" # King Dodongo                 (HP: 0C)   C3B150 -> C44C30 (Length: 9AE0)  (ovl_Boss_Dodongo)
        ChangeBytes -Offset "D258BB" -Values "0C" # Barinade        (Phase 1)    (HP: 04)   D22360 -> D30B50 (Length: E7F0)  (ovl_Boss_Va)
        ChangeBytes -Offset "D25B0B" -Values "09" # Barinade        (Phases 4-6) (HP: 03)
        ChangeBytes -Offset "C91F8F" -Values "5A" # Phantom Ganon   (Phase 1)    (HP: 1E)   C91AD0 -> C96840 (Length: 4D70)  (ovl_Boss_Ganondrof)
        ChangeBytes -Offset "CAFF33" -Values "49" # Phantom Ganon   (Phase 2)    (HP: 19)
        ChangeBytes -Offset "CE6D2F" -Values "48" # Volvagia                     (HP: 18)   CE65F0 -> CED920 (Length: 7330)  (ovl_Boss_Fd)
        ChangeBytes -Offset "D3B4A7" -Values "3C" # Morpha                       (HP: 14)   D3ADF0 -> D46390 (Length: B5A0)  (ovl_Boss_Mo)
        ChangeBytes -Offset "DAC824" -Values "6C" # Bongo Bongo                  (HP: 24)   DA1660 -> DADB80 (Length: C520)  (ovl_Boss_Sst)
        ChangeBytes -Offset "D64EFB" -Values "0C" # Twinrova        (Phase 1)    (HP: 04)   D612E0 -> D74360 (Length: 13080) (ovl_Boss_Tw)
        ChangeBytes -Offset "D6223F" -Values "48" # Twinrova        (Phase 2)    (HP: 18)
        ChangeBytes -Offset "D7FDA3" -Values "78" # Ganondorf                    (HP: 28)   D7F3F0 -> DA1660 (Length: 22270) (ovl_Boss_Ganon)
        ChangeBytes -Offset "E82AFB" -Values "5A" # Ganon           (Phase 1)    (HP: 1E)   E826C0 -> E939B0 (Length: 112F0) (ovl_Boss_Ganon2)
        ChangeBytes -Offset "E87F2F" -Values "3D" # Ganon           (Phase 2)    (HP: 15)
    }

    
    
    # EQUIPMENT COLORS #

    if (IsDefaultColor -Elem $Redux.Colors.SetEquipment[0] -Not) { # Kokiri Tunic
        ChangeBytes -Offset "B6DA38" -IsDec -Values @($Redux.Colors.SetEquipment[0].Color.R, $Redux.Colors.SetEquipment[0].Color.G, $Redux.Colors.SetEquipment[0].Color.B)
        if ( (IsText -Elem $Redux.Colors.Equipment[0] -Compare "Randomized" -Not) -or (IsText -Elem $Redux.Colors.Equipment[0] -Compare "Custom" -Not) ) { PatchBytes -Offset "7FE000"  -Texture -Patch ("Tunic\" + $Redux.Colors.Equipment[0].text + ".bin") }
    }

    if (IsDefaultColor -Elem $Redux.Colors.SetEquipment[1] -Not) { # Goron Tunic
        ChangeBytes -Offset "B6DA3B" -IsDec -Values @($Redux.Colors.SetEquipment[1].Color.R, $Redux.Colors.SetEquipment[1].Color.G, $Redux.Colors.SetEquipment[1].Color.B)
        if ( (IsText -Elem $Redux.Colors.Equipment[1] -Compare "Randomized" -Not) -or (IsText -Elem $Redux.Colors.Equipment[1] -Compare "Custom" -Not) ) { PatchBytes -Offset "7FF000"  -Texture -Patch ("Tunic\" + $Redux.Colors.Equipment[1].text + ".bin") }
    }

    if (IsDefaultColor -Elem $Redux.Colors.SetEquipment[2] -Not) { # Zora Tunic
        ChangeBytes -Offset "B6DA3E" -IsDec -Values @($Redux.Colors.SetEquipment[2].Color.R, $Redux.Colors.SetEquipment[2].Color.G, $Redux.Colors.SetEquipment[2].Color.B)
        if ( (IsText -Elem $Redux.Colors.Equipment[2] -Compare "Randomized" -Not) -or (IsText -Elem $Redux.Colors.Equipment[2] -Compare "Custom" -Not) ) { PatchBytes -Offset "800000"  -Texture -Patch ("Tunic\" + $Redux.Colors.Equipment[2].text + ".bin") }
    }

    if (IsDefaultColor -Elem $Redux.Colors.SetEquipment[3] -Not)   { ChangeBytes -Offset "B6DA44" -IsDec -Values @($Redux.Colors.SetEquipment[3].Color.R, $Redux.Colors.SetEquipment[3].Color.G, $Redux.Colors.SetEquipment[3].Color.B) } # Silver Gauntlets
    if (IsDefaultColor -Elem $Redux.Colors.SetEquipment[4] -Not)   { ChangeBytes -Offset "B6DA47" -IsDec -Values @($Redux.Colors.SetEquipment[4].Color.R, $Redux.Colors.SetEquipment[4].Color.G, $Redux.Colors.SetEquipment[4].Color.B) } # Golden Gauntlets
    if ( (IsDefaultColor -Elem $Redux.Colors.SetEquipment[5] -Not) -and $ModelCredits.mirror_shield -ne 0) { # Mirror Shield Frame
        $Offset = "F86000"
        do {
            $Offset = SearchBytes -Start $Offset -End "FBD800" -Values "FA 00 00 00 D7 00 00"
            if ($Offset -ne -1) {
                $Offset = ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "4") ) )
                if (!(ChangeBytes -Offset $Offset -IsDec -Values @($Redux.Colors.SetEquipment[5].Color.R, $Redux.Colors.SetEquipment[5].Color.G, $Redux.Colors.SetEquipment[5].Color.B))) { break }
            }
        } while ($Offset -gt 0)
    }



    # MAGIC SPIN ATTACK COLORS #

    if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[0] -Not)   { ChangeBytes -Offset "F15AB4" -IsDec -Values @($Redux.Colors.SetSpinAttack[0].Color.R, $Redux.Colors.SetSpinAttack[0].Color.G, $Redux.Colors.SetSpinAttack[0].Color.B) } # Blue Spin Attack
    if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[1] -Not)   { ChangeBytes -Offset "F15BD4" -IsDec -Values @($Redux.Colors.SetSpinAttack[1].Color.R, $Redux.Colors.SetSpinAttack[1].Color.G, $Redux.Colors.SetSpinAttack[1].Color.B) } # Blue Spin Attack
    if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[2] -Not)   { ChangeBytes -Offset "F16034" -IsDec -Values @($Redux.Colors.SetSpinAttack[2].Color.R, $Redux.Colors.SetSpinAttack[2].Color.G, $Redux.Colors.SetSpinAttack[2].Color.B) } # Red Spin Attack
    if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[3] -Not)   { ChangeBytes -Offset "F16154" -IsDec -Values @($Redux.Colors.SetSpinAttack[3].Color.R, $Redux.Colors.SetSpinAttack[3].Color.G, $Redux.Colors.SetSpinAttack[3].Color.B) } # Red Spin Attack



    # SWORD TRAIL COLORS #

    if (IsDefaultColor -Elem $Redux.Colors.SetSwordTrail[0] -Not)   { ChangeBytes -Offset "BEFF7C" -IsDec -Values @($Redux.Colors.SetSwordTrail[0].Color.R, $Redux.Colors.SetSwordTrail[0].Color.G, $Redux.Colors.SetSwordTrail[0].Color.B) }
    if (IsDefaultColor -Elem $Redux.Colors.SetSwordTrail[1] -Not)   { ChangeBytes -Offset "BEFF84" -IsDec -Values @($Redux.Colors.SetSwordTrail[1].Color.R, $Redux.Colors.SetSwordTrail[1].Color.G, $Redux.Colors.SetSwordTrail[1].Color.B) }
    if (IsIndex -Elem $Redux.Colors.SwordTrailDuration -Not)        { ChangeBytes -Offset "BEFF8C" -IsDec -Values (($Redux.Colors.SwordTrailDuration.SelectedIndex+1) * 5) }

    

    # FAIRY COLORS #

    if (IsChecked -Elem $Redux.Colors.BetaNavi) { ChangeBytes -Offset "A96110" -Values "34 0F 00 60" }
    else {
        if ( (IsDefaultColor -Elem $Redux.Colors.SetFairy[0] -Not) -or (IsDefaultColor -Elem $Redux.Colors.SetFairy[1] -Not) ) { # Idle
            ChangeBytes -Offset "B5E184" -IsDec -Values @($Redux.Colors.SetFairy[0].Color.R, $Redux.Colors.SetFairy[0].Color.G, $Redux.Colors.SetFairy[0].Color.B, 255, $Redux.Colors.SetFairy[1].Color.R, $Redux.Colors.SetFairy[1].Color.G, $Redux.Colors.SetFairy[1].Color.B, 0)
        }

        if ( (IsDefaultColor -Elem $Redux.Colors.SetFairy[2] -Not) -or (IsDefaultColor -Elem $Redux.Colors.SetFairy[3] -Not) ) { # Interact
            ChangeBytes -Offset "B5E174" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E17C" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E18C" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E1A4" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E1AC" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E1B4" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E1C4" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E1CC" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
            ChangeBytes -Offset "B5E1D4" -IsDec -Values @($Redux.Colors.SetFairy[2].Color.R, $Redux.Colors.SetFairy[2].Color.G, $Redux.Colors.SetFairy[2].Color.B, 255, $Redux.Colors.SetFairy[3].Color.R, $Redux.Colors.SetFairy[3].Color.G, $Redux.Colors.SetFairy[3].Color.B, 0)
        }

        if ( (IsDefaultColor -Elem $Redux.Colors.SetFairy[4] -Not) -or (IsDefaultColor -Elem $Redux.Colors.SetFairy[5] -Not) ) { # NPC
            ChangeBytes -Offset "B5E194" -IsDec -Values @($Redux.Colors.SetFairy[4].Color.R, $Redux.Colors.SetFairy[4].Color.G, $Redux.Colors.SetFairy[4].Color.B, 255, $Redux.Colors.SetFairy[5].Color.R, $Redux.Colors.SetFairy[5].Color.G, $Redux.Colors.SetFairy[5].Color.B, 0)
        }

        if ( (IsDefaultColor -Elem $Redux.Colors.SetFairy[6] -Not) -or (IsDefaultColor -Elem $Redux.Colors.SetFairy[7] -Not) ) { # Enemy, Boss
            ChangeBytes -Offset "B5E19C" -IsDec -Values @($Redux.Colors.SetFairy[6].Color.R, $Redux.Colors.SetFairy[6].Color.G, $Redux.Colors.SetFairy[6].Color.B, 255, $Redux.Colors.SetFairy[7].Color.R, $Redux.Colors.SetFairy[7].Color.G, $Redux.Colors.SetFairy[7].Color.B, 0)
            ChangeBytes -Offset "B5E1BC" -IsDec -Values @($Redux.Colors.SetFairy[6].Color.R, $Redux.Colors.SetFairy[6].Color.G, $Redux.Colors.SetFairy[6].Color.B, 255, $Redux.Colors.SetFairy[7].Color.R, $Redux.Colors.SetFairy[7].Color.G, $Redux.Colors.SetFairy[7].Color.B, 0)
        }
    }

    

    # AMMO CAPACITY SELECTION #

    if (IsChecked $Redux.Capacity.EnableAmmo) {
        ChangeBytes -Offset "B6EC2F" -IsDec -Values @($Redux.Capacity.Quiver1.Text,     $Redux.Capacity.Quiver2.Text,     $Redux.Capacity.Quiver3.Text)     -Interval 2
        ChangeBytes -Offset "B6EC37" -IsDec -Values @($Redux.Capacity.BombBag1.Text,    $Redux.Capacity.BombBag2.Text,    $Redux.Capacity.BombBag3.Text)    -Interval 2
        ChangeBytes -Offset "B6EC57" -IsDec -Values @($Redux.Capacity.BulletBag1.Text,  $Redux.Capacity.BulletBag2.Text,  $Redux.Capacity.BulletBag3.Text)  -Interval 2
        ChangeBytes -Offset "B6EC5F" -IsDec -Values @($Redux.Capacity.DekuSticks1.Text, $Redux.Capacity.DekuSticks2.Text, $Redux.Capacity.DekuSticks3.Text) -Interval 2
        ChangeBytes -Offset "B6EC67" -IsDec -Values @($Redux.Capacity.DekuNuts1.Text,   $Redux.Capacity.DekuNuts2.Text,   $Redux.Capacity.DekuNuts3.Text)   -Interval 2
    }



    # WALLET CAPACITY SELECTION #
    
    if (IsChecked $Redux.Capacity.EnableWallet) {
        $Wallet1 = Get16Bit ($Redux.Capacity.Wallet1.Text); $Wallet2 = Get16Bit ($Redux.Capacity.Wallet2.Text); $Wallet3 = Get16Bit ($Redux.Capacity.Wallet3.Text); $Wallet4 = Get16Bit ($Redux.Capacity.Wallet4.Text)
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
        ChangeBytes -Offset "B6D579" -Values @($Redux.Capacity.Wallet1.Text.Length, $Redux.Capacity.Wallet2.Text.Length, $Redux.Capacity.Wallet3.Text.Length, $Redux.Capacity.Wallet4.Text.Length) -Interval 2

        
    }



    # EQUIPMENT #
    
    if ( (IsChecked $Redux.Equipment.RazorSword) -and ($ModelCredits.razor_sword -eq 1 -or (IsChecked $Redux.Graphics.OriginalModels) ) ) {
        ChangeBytes -Offset "BD3C5B" -Values "00" # Fireproof
        PatchBytes -Offset "7F8000" -Texture -Patch "Razor Sword\icon.bin"; PatchBytes -Offset "7FB000" -Texture -Patch "Hero's Shield\icon.bin" #; PatchBytes -Offset "7FC000" -Texture -Patch "Hero's Shield\icon.bin"
        if (IsSet $LanguagePatch.hero_shield) { PatchBytes -Offset "8AD800" -Texture -Patch $LanguagePatch.razor_sword; PatchBytes -Offset "8AE400" -Texture -Patch $LanguagePatch.hero_shield } #; PatchBytes -Offset "8AE800" -Texture -Patch $LanguagePatch.hero_shield
    }

    if (IsChecked $Redux.Equipment.IronShield -and $ModelCredits.deku_shield -ne 0) {
        ChangeBytes -Offset "BD3C5B" -Values "00" # Fireproof
        if ($ModelCredits.stone_shield -ne 0) {
            $Offset = SearchBytes -Start "FBE000" -End "FEAF80" -Values "CC 99 E5 E5 DD A3 EE 2B DD A5 E6 29 DD A5 D4 DB"; PatchBytes -Offset $Offset  -Texture -Patch "Iron Shield\front.bin" # Vanilla: FC5E88
            $Offset = SearchBytes -Start "FBE000" -End "FEAF80" -Values "DC 11 F5 17 F5 19 DC 57 D4 59 E4 DB E4 DB DC 97"; PatchBytes -Offset $Offset  -Texture -Patch "Iron Shield\back.bin"  # Vanilla: FC5688
            PatchBytes -Offset "7FB000" -Texture -Patch "Iron Shield\icon.bin"
            if (IsSet $LanguagePatch.iron_shield) { PatchBytes -Offset "8AE400" -Texture -Patch $LanguagePatch.iron_shield }
        }
    }

    if (IsChecked $Redux.Equipment.HeroShield -and $ModelCredits.hylian_shield -ne 0) {
        PatchBytes -Offset "F03400" -Texture -Patch "Hero's Shield\front.bin"; PatchBytes -Offset "7FC000" -Texture -Patch "Hero's Shield\icon.bin"
        if (IsSet $LanguagePatch.hero_shield) { PatchBytes -Offset "8AE800" -Texture -Patch $LanguagePatch.hero_shield }
    }

    if (IsChecked $Redux.Equipment.UnsheathSword)    { ChangeBytes -Offset "BD04A0"  -Values "28 42 00 05 14 40 00 05 00 00 10 25" }



    # UNLOCK CHILD RESTRICTIONS #

    if (IsChecked $Redux.Unlock.Tunics)              { ChangeBytes -Offset "BC77B6" -Values "09 09"; ChangeBytes -Offset "BC77FE" -Values "09 09" }
    if (IsChecked $Redux.Unlock.MasterSword)         { ChangeBytes -Offset "BC77AE" -Values "09 09" -Interval 74 }
    if (IsChecked $Redux.Unlock.GiantsKnife)         { ChangeBytes -Offset "BC77AF" -Values "09 09" -Interval 74 }
    if (IsChecked $Redux.Unlock.MirrorShield)        { ChangeBytes -Offset "BC77B3" -Values "09 09" -Interval 73 }
    if (IsChecked $Redux.Unlock.Boots)               { ChangeBytes -Offset "BC77BA" -Values "09 09"; ChangeBytes -Offset "BC7801" -Values "09 09" }
    if (IsChecked $Redux.Unlock.MegatonHammer)       { ChangeBytes -Offset "BC77A3" -Values "09 09" -Interval 42 }
    

    
    # UNLOCK ADULT RESTRICTIONS #
    
    if (IsChecked $Redux.Unlock.KokiriSword)         { ChangeBytes -Offset "BC77AD" -Values "09 09" -Interval 74 }
    if (IsChecked $Redux.Unlock.DekuShield)          { ChangeBytes -Offset "BC77B1" -Values "09 09" -Interval 73 }
    if (IsChecked $Redux.Unlock.FairySlingshot)      { ChangeBytes -Offset "BC779A" -Values "09 09" -Interval 40 }
    if (IsChecked $Redux.Unlock.Boomerang)           { ChangeBytes -Offset "BC77A0" -Values "09 09" -Interval 42 }



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
        ChangeBytes -Offset "2BEC848" -Values "00000056 00000001 0059 0021 0022 0000"

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
        # Inside the Deku Tree
        ChangeBytes -Offset "2077E20" -Values "00 07 00 01 00 02 00 02"; ChangeBytes -Offset "2078A10" -Values "00 0E 00 1F 00 20 00 20"; ChangeBytes -Offset "2079570" -Values "00 80 00 00 00 1E 00 00 FF FF FF FF FF FF 00 1E 00 28 FF FF FF FF FF FF"

        # Dodongo's Cavern
        ChangeBytes -Offset "2221E88" -Values "00 0C 00 3B 00 3C 00 3C"; ChangeBytes -Offset "2223308" -Values "00 81 00 00 00 3A 00 00"

        # Inside Jabu-Jabu's Belly
        ChangeBytes -Offset "CA3530"  -Values "00 00 00 00";             ChangeBytes -Offset "2113340" -Values "00 0D 00 3B 00 3C 00 3C"; ChangeBytes -Offset "2113C18" -Values "00 82 00 00 00 3A 00 00"
        ChangeBytes -Offset "21131D0" -Values "00 01 00 00 00 3C 00 3C"

        # Forest Temple
        ChangeBytes -Offset "D4ED68"  -Values "00 45 00 3B 00 3C 00 3C"; ChangeBytes -Offset "D4ED78"  -Values "00 3E 00 00 00 3A 00 00"; ChangeBytes -Offset "207B9D4" -Values "FF FF FF FF"

        # Fire Temple
        ChangeBytes -Offset "2001848" -Values "00 1E 00 01 00 02 00 02"; ChangeBytes -Offset "D100B4"  -Values "00 62 00 3B 00 3C 00 3C"; ChangeBytes -Offset "D10134"  -Values "00 3C 00 00 00 3A 00 00"

        # Water Temple
        ChangeBytes -Offset "D5A458"  -Values "00 15 00 3B 00 3C 00 3C"; ChangeBytes -Offset "D5A3A8"  -Values "00 3D 00 00 00 3A 00 00"; ChangeBytes -Offset "20D0D20" -Values "00 29 00 C7 00 C8 00 C8"

        # Shadow Temple
        ChangeBytes -Offset "D13EC8"  -Values "00 61 00 3B 00 3C 00 3C"; ChangeBytes -Offset "D13E18"  -Values "00 41 00 00 00 3A 00 00"

        # Spirit Temple
        ChangeBytes -Offset "D3A0A8"  -Values "00 60 00 3B 00 3C 00 3C"; ChangeBytes -Offset "D39FF0"  -Values "00 3F 00 00 00 3A 00 00"
    }

    if (IsChecked $Redux.Skip.Bosses) {
        # Phantom Ganon
        ChangeBytes -Offset "C944D8" -Values "00 00 00 00";  ChangeBytes -Offset "C94548" -Values "00 00 00 00";  ChangeBytes -Offset "C94730" -Values "00 00 00 00"
        ChangeBytes -Offset "C945A8" -Values "00 00 00 00";  ChangeBytes -Offset "C94594" -Values "00 00 00 00"

        # Nabooru
        ChangeBytes -Offset "2F5AF84" -Values "00 00 00 05"; ChangeBytes -Offset "2F5C7DA" -Values "00 01 00 02"; ChangeBytes -Offset "2F5C7A2" -Values "00 03 00 04"
        ChangeBytes -Offset "2F5B369" -Values "09";          ChangeBytes -Offset "2F5B491" -Values "04";          ChangeBytes -Offset "2F5B559" -Values "04"
        ChangeBytes -Offset "2F5B621" -Values "04";          ChangeBytes -Offset "2F5B761" -Values "07";          ChangeBytes -Offset "2F5B840" -Values "00 05 00 01 00 05 00 05" # Shorten white flash

        # Twinrova
        ChangeBytes -Offset "D67BA4" -Values "10 00";        ChangeBytes -Offset "D678CC" -Values "24 01 03 A2 A6 01 01 42"

        # Ganondorf
        ChangeBytes -Offset "D82047" -Values "09"

        # Zelda Descend
        ChangeBytes -Offset "D82AB3" -Values "66";           ChangeBytes -Offset "D82FAF" -Values "65";           ChangeBytes -Offset "D82D2E" -Values "04 1F"
        ChangeBytes -Offset "D83142" -Values "00 6B";        ChangeBytes -Offset "D82DD8" -Values "00 00 00 00";  ChangeBytes -Offset "D82ED4" -Values "00 00 00 00"
        ChangeBytes -Offset "D82FDF" -Values "33"

        # After Tower Collapse
        ChangeBytes -Offset "E82E0F" -Values "04"

        # Ganon Intro
        ChangeBytes -Offset "E83D28" -Values "00 00 00 00";  ChangeBytes -Offset "E83B5C" -Values "00 00 00 00";  ChangeBytes -Offset "E84C80" -Values "10 00"
    }

    if (IsChecked $Redux.Skip.LightArrow) {
        ChangeBytes -Offset "2531B40" -Values "00 28 00 01 00 02 00 02"; ChangeBytes -Offset "2532FBC" -Values "00 75";          ChangeBytes -Offset "2532FEA" -Values "00 75 00 80"
        ChangeBytes -Offset "2533115" -Values "05";                      ChangeBytes -Offset "2533141" -Values "06 00 06 00 10"; ChangeBytes -Offset "2533171" -Values "0F 00 11 00 40"
        ChangeBytes -Offset "25331A1" -Values "07 00 41 00 65";          ChangeBytes -Offset "2533642" -Values "00 50";          ChangeBytes -Offset "253389D" -Values "74"
        ChangeBytes -Offset "25338A4" -Values "00 72 00 75 00 79";       ChangeBytes -Offset "25338BC" -Values "FF FF";          ChangeBytes -Offset "25338C2" -Values "FF FF FF FF FF FF"
        ChangeBytes -Offset "25339C2" -Values "00 75 00 76";             ChangeBytes -Offset "2533830" -Values "00 31 00 81 00 82 00 82"
    }
    
    if (IsChecked $Redux.Skip.RainbowBridge) {
        ChangeBytes -Offset "292D644" -Values "00 00 00 A0"; ChangeBytes -Offset "292D680" -Values "00 02 00 0A 00 6C 00 00"; ChangeBytes -Offset "292D6E8" -Values "00 27"
        ChangeBytes -Offset "292D718" -Values "00 32";       ChangeBytes -Offset "292D810" -Values "00 02 00 3C";             ChangeBytes -Offset "292D924" -Values "FF FF 00 14 00 96 FF FF"
    }

    if (IsChecked $Redux.Skip.FairyOcarina) {
        ChangeBytes -Offset "2151230" -Values "00 72 00 3C 00 3D 00 3D"
        ChangeBytes -Offset "2151240" -Values "00 4A 00 00 00 3A 00 00 FF FF FF FF FF FF 00 3C 00 81 FF FF"
        ChangeBytes -Offset "2150E20" -Values "FF FF FA 4C"
    }

    if (IsChecked $Redux.Skip.RoyalTomb) {
        ChangeBytes -Offset "2025026" -Values "00 01"; ChangeBytes -Offset "2025159" -Values "02"
        ChangeBytes -Offset "2023C86" -Values "00 01"; ChangeBytes -Offset "2023E19" -Values "02"
    }

    if (IsChecked $Redux.Skip.GanonTrials) {
        ChangeBytes -Offset "31A8090" -Values "00 6B 00 01 00 02 00 02"; ChangeBytes -Offset "31A9E00" -Values "00 6E 00 01 00 02 00 02"; ChangeBytes -Offset "31A8B18" -Values "00 6C 00 01 00 02 00 02"
        ChangeBytes -Offset "31A9430" -Values "00 6D 00 01 00 02 00 02"; ChangeBytes -Offset "31AB200" -Values "00 70 00 01 00 02 00 02"; ChangeBytes -Offset "31AA830" -Values "00 6F 00 01 00 02 00 02"
    }
    
    if (IsChecked $Redux.Skip.DekuSeedBag) {
        ChangeBytes -Offset "ECA900" -Values "24 03 C0 00"; ChangeBytes -Offset "ECAE90" -Values "27 18 FD 04"; ChangeBytes -Offset "ECB618" -Values "25 6B 00 D4"
        ChangeBytes -Offset "ECAE70" -Values "00 00 00 00"; ChangeBytes -Offset "E5972C" -Values "24 08 00 01"
    }

    if (IsChecked $Redux.Skip.OpeningCutscene)       { ChangeBytes -Offset "B06BBA"  -Values "00 00" }
    if (IsChecked $Redux.Skip.DaruniaDance)          { ChangeBytes -Offset "22769E4" -Values "FF FF FF FF" }
    if (IsChecked $Redux.Skip.OpeningChests)         { ChangeBytes -Offset "BDA2E8"  -Values "24 0A FF FF" }
    if (IsChecked $Redux.Skip.KingZora)              { ChangeBytes -Offset "E56924"  -Values "00 00 00 00" }
    if (IsChecked $Redux.Skip.ZeldaEscape)           { ChangeBytes -Offset "1FC0CF8" -Values "00 00 00 01 00 21 00 01 00 02 00 02" }
    if (IsChecked $Redux.Skip.JabuJabu)              { ChangeBytes -Offset "CA0784"  -Values "00 18 00 01 00 02 00 02" }
    if (IsChecked $Redux.Skip.GanonTower)            { ChangeBytes -Offset "33FB328" -Values "00 76 00 01 00 02 00 02" }
    if (IsChecked $Redux.Skip.Medallions)            { ChangeBytes -Offset "2512680" -Values "00 76 00 01 00 02 00 02" }
    if (IsChecked $Redux.Skip.AllMedallions)         { ChangeBytes -Offset "ACA409"  -Values "AD";                      ChangeBytes -Offset "ACA49D"  -Values "CE" }
    if (IsChecked $Redux.Skip.EponaRace)             { ChangeBytes -Offset "29BE984" -Values "00 00 00 02";             ChangeBytes -Offset "29BE9CA" -Values "00 01 00 02" }
    if (IsChecked $Redux.Skip.HorsebackArchery)      { ChangeBytes -Offset "21B2064" -Values "00 00 00 02";             ChangeBytes -Offset "21B20AA" -Values "00 01 00 02" }
    if (IsChecked $Redux.Skip.DoorOfTime)            { ChangeBytes -Offset "E0A176"  -Values "00 02";                   ChangeBytes -Offset "E0A35A"  -Values "00 01 00 02" }
    if (IsChecked $Redux.Skip.DrainingTheWell)       { ChangeBytes -Offset "E0A010"  -Values "00 2A 00 01 00 02 00 02"; ChangeBytes -Offset "2001110" -Values "00 2B 00 B7 00 B8 00 B8" }
    


    # RESTORE CUTSCENES #

    if (IsChecked $Redux.Restore.OpeningCutscene)   { ChangeBytes -Offset "1FB8076" -Values "23 40" }



    # ANIMATIONS #

    if     (IsChecked $Redux.Animation.WeaponIdle)        { ChangeBytes -Offset "BEF5F2" -Values "34 28" }
    if     (IsChecked $Redux.Animation.WeaponCrouch)      { ChangeBytes -Offset "BEF38A" -Values "2A 10" }
    if     (IsChecked $Redux.Animation.WeaponAttack)      { ChangeBytes -Offset "BEFB62" -Values "2B D8"; ChangeBytes -Offset "BEFB66" -Values "2B E0"; ChangeBytes -Offset "BEFB6A" -Values "2B E0" }
    if     (IsChecked $Redux.Animation.BackflipAttack)    { ChangeBytes -Offset "BEFB12" -Values "29 D0" }
    elseif (IsChecked $Redux.Animation.FrontflipAttack)   { ChangeBytes -Offset "BEFB12" -Values "2A 60" }
    if     (IsChecked $Redux.Animation.FrontflipJump)     { PatchBytes -Offset "70BB00" -Patch "Jumps\Frontflip.bin" }
    elseif (IsChecked $Redux.Animation.SomarsaultJump)    { PatchBytes -Offset "70BB00" -Patch "Jumps\Somarsault.bin"; ChangeBytes -Offset "F06149" -Values "0E"  }



    # MASTER QUEST #

    PatchDungeonsOoTMQ



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
        if ($ModelCredits.mirror_shield -ne 0) {
            $Offset = SearchBytes -Start "F86000" -End "FBD800" -Values "90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90"
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

        $Offset = SearchBytes -Start "2AF8000" -End "2B08F40" -Values "00 05 00 11 06 00 06 4E 06 06 06 06 11 11 06 11"
        PatchBytes -Offset $Offset -Texture -Patch "Gerudo Symbols\spirit_temple_room_0_pillars.bin"
    }

}



#==============================================================================================================================================================================================
function ByteReduxOptions() {
    
    # INTERFACE ICONS #

    if (IsChecked $Redux.UI.ShowFileSelectIcons)   { PatchBytes  -Offset "BAF738" -Patch "File Select.bin" }
    if (IsChecked $Redux.UI.DPadLayoutShow)        { ChangeBytes -Offset "348086E" -Values "01" }



     # BUTTON COLORS #

     if (IsDefaultColor -Elem $Redux.Colors.SetButtons[0] -Not) { # A Button
        #ChangeBytes -Offset "348085F" -Values "FF 00 50" # Cursor
        #ChangeBytes -Offset "3480859" -Values "C8 00 50" # Cursor
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
        ChangeBytes -Offset "BBEBD6"  -IsDec -Values   $Redux.Colors.SetButtons[0].Color.B # Blue
        ChangeBytes -Offset "BBEDDA"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G) # Red + Green
        ChangeBytes -Offset "BBEDDE"  -IsDec -Values   $Redux.Colors.SetButtons[0].Color.B # Blue

        # A Button - Note
        ChangeBytes -Offset "BB299A"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G) # Red + Green
        ChangeBytes -Offset "BB299E"  -IsDec -Values   $Redux.Colors.SetButtons[0].Color.B # Blue
        ChangeBytes -Offset "BB2C8E"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G) # Red + Green
        ChangeBytes -Offset "BB2C92"  -IsDec -Values   $Redux.Colors.SetButtons[0].Color.B # Blue
        ChangeBytes -Offset "BB2F8A"  -IsDec -Values @($Redux.Colors.SetButtons[0].Color.R, $Redux.Colors.SetButtons[0].Color.G) # Red + Green
        ChangeBytes -Offset "BB2F96"  -IsDec -Values   $Redux.Colors.SetButtons[0].Color.B # Blue
    }

    if (IsDefaultColor -Elem $Redux.Colors.SetButtons[1] -Not) { ChangeBytes -Offset "348084B" -IsDec -Values @($Redux.Colors.SetButtons[1].Color.R, $Redux.Colors.SetButtons[1].Color.G, $Redux.Colors.SetButtons[1].Color.B) -Interval 2 } # B Button 

    if (IsDefaultColor -Elem $Redux.Colors.SetButtons[2] -Not) { # C Buttons
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
            ChangeBytes -Offset "BB29A2" -IsDec -Values   $Redux.Colors.SetButtons[2].Color.B # Blue
            ChangeBytes -Offset "BB2C8A" -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G) # Red + Green
            ChangeBytes -Offset "BB2C96" -IsDec -Values   $Redux.Colors.SetButtons[2].Color.B # Blue
            ChangeBytes -Offset "BB2F86" -IsDec -Values @($Redux.Colors.SetButtons[2].Color.R, $Redux.Colors.SetButtons[2].Color.G) # Red + Green
            ChangeBytes -Offset "BB2F9A" -IsDec -Values   $Redux.Colors.SetButtons[2].Color.B # Blue
        }
    }

    if (IsDefaultColor -Elem $Redux.Colors.SetButtons[3] -Not) { # Start Button
        ChangeBytes -Offset "AE9EC6" -IsDec -Values @($Redux.Colors.SetButtons[3].Color.R, $Redux.Colors.SetButtons[3].Color.G) # Red + Green
        ChangeBytes -Offset "AE9ED8" -IsDec -Values @("53", "238", $Redux.Colors.SetButtons[3].Color.B) # Blue
    }

}



#==============================================================================================================================================================================================
function ByteLanguageOptions() {
    
    if ( (IsChecked -Elem $Redux.Text.Vanilla -Not) -or (IsChecked -Elem $Redux.Text.Speed1x -Not) -or (IsLanguage $Redux.UI.GCScheme) -or (IsLanguage $Redux.Unlock.Tunics) -or (IsText -Elem $Redux.Colors.Fairy -Compare "Tatl") -or (IsText -Elem $Redux.Colors.Fairy -Compare "Tael") -or (IsLanguage $Redux.Capacity.EnableAmmo) -or (IsLanguage $Redux.Capacity.EnableWallet)-or (IsLanguage $Redux.Equipment.IronShield -and $ModelCredits.deku_shield -ne 0) -or (IsLanguage $Redux.Equipment.HeroShield -and $ModelCredits.hylian_shield -ne 0) ) {
        if ( (IsSet $LanguagePatch.script_start) -and (IsSet $LanguagePatch.script_length) ) {
            $File = $GameFiles.extracted + "\message_data_static.bin"
            ExportBytes -Offset $LanguagePatch.script_start -Length $LanguagePatch.script_length -Output $File -Force
        }
        else  { return }
    }
    else { return }

    if (IsChecked $Redux.Text.Redux) { ApplyPatch -File $File -Patch "\Export\Message\redux.bps" }
    elseif (IsChecked $Redux.Text.Restore) {
        ChangeBytes -Offset "7596" -Values "52 40"
        PatchBytes  -Offset "B849EC" -Patch "Message\Table Restore Text.tbl"
        ApplyPatch -File $File -Patch "\Export\Message\restore_text.bps"
    }
    elseif (IsChecked $Redux.Text.FemalePronouns) {
        ChangeBytes -Offset "7596" -Values "52 40"
        PatchBytes  -Offset "B849EC" -Patch "Message\Table Female Pronouns.tbl"
        ApplyPatch -File $File -Patch "\Export\Message\female_pronouns.bps"
    }

    if (IsChecked $Redux.Text.Speed2x) {
        ChangeBytes -Offset "B5006F" -Values "02" # Text Speed

        if ($Redux.Language[0].checked) {
            # Correct Ruto Confession Textboxes
            $Offset = SearchBytes -File $File -Values "1A 41 73 20 61 20 72 65 77 61 72 64 2E 2E 2E 01"
            PatchBytes -File $File -Offset $Offset -Patch "Message\Ruto Confession.bin"

            # Correct Phantom Ganon Defeat Textboxes
            $Offset = SearchBytes -File $File -Values "0C 3C 42 75 74 20 79 6F 75 20 68 61 76 65 20 64"
            ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "01") ) ) -Values "66"
            ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "5D") ) ) -Values "66"
            ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "BA") ) ) -Values "60"
        }
    }
    elseif (IsChecked $Redux.Text.Speed3x) {
        ChangeBytes -Offset "B5006F" -Values "03" # Text Speed

        # Correct Learning Song Textboxes
        $Offset = SearchBytes -File $File -Values "08 06 3C 50 6C 61 79 20 75 73 69 6E 67 20 05"
        PatchBytes -File $File -Offset $Offset -Patch "Message\Songs.bin"

        # Correct Ruto Confession Textboxes
        $Offset = SearchBytes -File $File -Values "1A 41 73 20 61 20 72 65 77 61 72 64 2E 2E 2E 01"
        PatchBytes -File $File -Offset $Offset -Patch "Message\Ruto Confession.bin"
        
        # Correct Phantom Ganon Defeat Textboxes
        $Offset = SearchBytes -File $File -Values "0C 3C 42 75 74 20 79 6F 75 20 68 61 76 65 20 64"
        ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "01") ) ) -Values "76"
        ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "5D") ) ) -Values "76"
        ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "BA") ) ) -Values "70"
    }
        
    if (IsLanguage $Redux.UI.GCScheme) {
        # Hole of Z
        $Offset = SearchBytes -File $File -Values "48 6F 6C 65 20 6F 66 20 22 5A 22"
        ChangeBytes -File $File -Offset $Offset -Values "48 6F 6C 65 20 6F 66 20 22 4C 22"

        # GC Colors
        $Offset = SearchBytes -File $File -Values "62 6C 75 65 20 69 63 6F 6E 05 40 02 00 00 54 68"
        ChangeBytes -File $File -Offset $Offset -Values "67 72 65 65 6E 20 69 63 6F 6E 05 40 02"
            
        $Offset = SearchBytes -File $File -Values "1A 05 44 59 6F 75 20 63 61 6E 20 6F 70 65 6E 20"
        PatchBytes  -File $File -Offset $Offset -Patch "Message\MQ Navi Door.bin"
            
        $Offset = SearchBytes -File $File -Values "62 6C 75 65 20 69 63 6F 6E 20 61 74 20 74 68 65"
        PatchBytes  -File $File -Offset $Offset -Patch "Message\MQ Navi Action.bin"

        $Offset = 0
        do { # A button
            $Offset = SearchBytes -File $File -Start $Offset -Values "05 43 9F 05"
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values "05 42" }
        } while ($Offset -gt 0)

        $Offset = 0
        do { # A button
            $Offset = SearchBytes -File $File -Start $Offset -Values "05 43 9F 05 40"
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values "05 42" }
        } while ($Offset -gt 0)

        $Offset = 0
        do { # A button
            $Offset = SearchBytes -File $File -Start $Offset -Values "05 43 20 9F 05 44"
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values "05 42" }
        } while ($Offset -gt 0)

        $Offset = 0
        do { # A button
            $Offset = SearchBytes -File $File -Start $Offset -Values "05 43 41 63 74 69 6F 6E"
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values "05 42" }
        } while ($Offset -gt 0)

        $Offset = 0
        do { # B button
            $Offset = SearchBytes -File $File -Start $Offset -Values "05 42 A0 05 40"
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values "05 41" }
        } while ($Offset -gt 0)

        $Offset = 0
        do { # B button
            $Offset = SearchBytes -File $File -Start $Offset -Values "05 42 A0 20 05 40"
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values "05 41" }
        } while ($Offset -gt 0)

        $Offset = 0
        do { # Start button
            $Offset = SearchBytes -File $File -Start $Offset -Values "05 41 53 54 41 52 54 05 40"
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values "05 44" }
        } while ($Offset -gt 0)

        $Offset = 0
        do { # Start button
            $Offset = SearchBytes -File $File -Start $Offset -Values "05 41 53 54 41 52 54 20 05 40"
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values "05 44" }
        } while ($Offset -gt 0)
    }

    if (IsLanguage $Redux.Unlock.Tunics) {
        $Offset = SearchBytes -File $File -Values "59 6F 75 20 67 6F 74 20 61 20 05 41 47 6F 72 6F 6E 20 54 75 6E 69 63"
        ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "39") ) ) -Values "75 6E 69 73 69 7A 65 2C 20 73 6F 20 69 74 20 66 69 74 73 20 61 64 75 6C 74 20 61 6E 64"
        ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "B3") ) ) -Values "75 6E 69 73 69 7A 65 2C 01 73 6F 20 69 74 20 66 69 74 73 20 61 64 75 6C 74 20 61 6E 64"

        $Offset = SearchBytes -File $File -Values "41 20 74 75 6E 69 63 20 6D 61 64 65 20 62 79 20 47 6F 72 6F 6E 73"
        ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "18") ) ) -Values "55 6E 69 2D 20"
        ChangeBytes -File $File -Offset ( Get24Bit ( (GetDecimal $Offset) + (GetDecimal "7A") ) ) -Values "55 6E 69 73 69 7A 65 2E 20 20 20"
    }

    if (IsText -Elem $Redux.Colors.Fairy -Compare "Tatl") {
        $Offset = 0
        do { # Navi -> Tatl
            $Offset = SearchBytes -File $File -Start $Offset -Values "4E 61 76 69"
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values "54 61 74 6C" }
        } while ($Offset -gt 0)
        PatchBytes -Offset "1A3EFC0" -Texture -Patch "HUD\Tatl.bin"
    }
    elseif (IsText -Elem $Redux.Colors.Fairy -Compare "Tael") {
        $Offset = 0
        do { # Navi -> Tael
            $Offset = SearchBytes -File $File -Start $Offset -Values "4E 61 76 69"
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values "54 61 65 6C" }
        } while ($Offset -gt 0)
        PatchBytes -Offset "1A3EFC0" -Texture -Patch "HUD\Tael.bin"
    }

    if (IsLanguage $Redux.Capacity.EnableAmmo) {
        ChangeStringIntoDigits -File $File -Search "34 30 20 05 40 69 6E 20 74 6F 74 61 6C"    -Value $Redux.Capacity.Quiver2.Text
        ChangeStringIntoDigits -File $File -Search "35 30 05 40 21 02 00 00 1A 13"             -Value $Redux.Capacity.Quiver3.Text

        ChangeStringIntoDigits -File $File -Search "32 30 20 42 6F 6D 62 73"                   -Value $Redux.Capacity.BombBag1.Text
        ChangeStringIntoDigits -File $File -Search "33 30 05 40 21 02 00 1A 13"                -Value $Redux.Capacity.BombBag2.Text
        ChangeStringIntoDigits -File $File -Search "34 30 05 40 20 42 6F 6D 62 73"             -Value $Redux.Capacity.BombBag3.Text

        ChangeStringIntoDigits -File $File -Search "34 30 05 40 01 73 6C 69 6E 67 73 68 6F 74" -Value $Redux.Capacity.BulletBag2.Text
        ChangeStringIntoDigits -File $File -Search "35 30 05 41 20 05 40 62 75 6C 6C 65 74 73" -Value $Redux.Capacity.BulletBag3.Text

        ChangeStringIntoDigits -File $File -Search "31 30 20 73 74 69 63 6B 73"                -Value $Redux.Capacity.DekuSticks1.Text
        ChangeStringIntoDigits -File $File -Search "32 30 05 40 20 6F 66 20 74 68 65 6D"       -Value $Redux.Capacity.DekuSticks2.Text
        ChangeStringIntoDigits -File $File -Search "33 30 05 40 20 6F 66 20 74 68 65 6D"       -Value $Redux.Capacity.DekuSticks3.Text

        ChangeStringIntoDigits -File $File -Search "33 30 05 40 20 6E 75 74 73"                -Value $Redux.Capacity.DekuNuts2.Text
        ChangeStringIntoDigits -File $File -Search "34 30 05 41 20 05 40 6E 75 74 73"          -Value $Redux.Capacity.DekuNuts3.Text
    }

    if (IsLanguage $Redux.Capacity.EnableWallet) {
        if ($Redux.Capacity.Wallet2.Text.Length -gt 3)   { $Text = "999" }
        else                                             { $Text = $Redux.Capacity.Wallet2.Text }
        ChangeStringIntoDigits -File $File -Search "32 30 30 05 40 20 05 46 52 75 70 65 65 73 05 40 2E 02 00" -Value $Text -Triple

        if ($Redux.Capacity.Wallet3.Text.Length -gt 3)   { $Text = "999" }
        else                                             { $Text = $Redux.Capacity.Wallet3.Text }
        ChangeStringIntoDigits -File $File -Search "35 30 30 05 40 20 05 46 52 75 70 65 65 73 05 40 2E 02 13" -Value $Text -Triple

        $Text = $null
    }

    if (IsLanguage $Redux.Equipment.IronShield -and $ModelCredits.deku_shield -ne 0) {
        $Offset = 0
        do { # Deku Shield -> Iron Shield
            $Offset = SearchBytes -File $File -Start $Offset -Values "44 65 6B 75 20 53 68 69 65 6C 64"
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values "49 72 6F 6E 20 53 68 69 65 6C 64" }
        } while ($Offset -gt 0)
    }

    if (IsLanguage $Redux.Equipment.HeroShield -and $ModelCredits.hylian_shield -ne 0) {
        $Offset = 0
        do { # Hylian Shield -> Hero's Shield
            $Offset = SearchBytes -File $File -Start $Offset -Values "48 79 6C 69 61 6E 20 53 68 69 65 6C 64"
            if ($Offset -ne -1) { ChangeBytes -File $File -Offset $Offset -Values "48 65 72 6F 27 73 20 53 68 69 65 6C 64" }
        } while ($Offset -gt 0)
    }

    PatchBytes -Offset $LanguagePatch.script_start -Patch "message_data_static.bin" -Extracted

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    if ($Settings.Debug.LiteGUI -eq $False) {
        CreateOptionsDialog -Width 1060 -Height 560 -Tabs @("Main", "Audiovisual", "Difficulty", "Colors", "Equipment", "Animations")
    }
    else {
        CreateOptionsDialog -Width 1060 -Height 450 -Tabs @("Main", "Audiovisual", "Difficulty")
    }

    if (!$IsWiiVC) { $Redux.Graphics.Widescreen.Add_CheckStateChanged({ AdjustGUI }) }

}



#==============================================================================================================================================================================================
function AdjustGUI() {
    
    if ($IsWiiVC) { return }

    EnableElem @($Redux.UI.ButtonPositions)  -Active (!(IsWidescreen -Experimental))

}



#==============================================================================================================================================================================================
function CreateTabMain() {

    # GAMEPLAY #
    CreateReduxGroup        -Tag  "Gameplay" -Text "Gameplay" 
    if ($Settings.Debug.LiteGUI -eq $False) {
        CreateReduxCheckBox -Name "FasterBlockPushing" -Checked -Text "Faster Block Pushing"   -Info "All blocks are pushed faster" -Credits "GhostlyDark (Ported from Redux)"
        CreateReduxCheckBox -Name "EasierMinigames"             -Text "Easier Minigames"       -Info "Certain minigames are made easier and faster`n- Dampe's Digging Game is first try always`n- Fishing is less random and has less demanding requirements`n-Bombchu Bowling prizes now appear in fixed order instead of random" -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "ReturnChild"                 -Text "Can Always Return"      -Info "You can always go back to being a child again before clearing the boss of the Forest Temple`nOut of the way Sheik!" -Credits "Ported from Redux"
        CreateReduxCheckBox -Name "Medallions"                  -Text "Require All Medallions" -Info "All six medallions are required for the Rainbow Bridge to appear before Ganon's Castle`nThe vanilla requirements were the Shadow and Spirit Medallions and the Light Arrows" -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "FixGraves"                   -Text "Fix Graves"             -Info "The grave holes in Kakariko Graveyard behave as in the Rev 1 revision`nThe edges no longer force Link to grab or jump over them when trying to enter" -Credits "Ported from Rando"
    }
    CreateReduxCheckBox     -Name "DistantZTargeting"           -Text "Distant Z-Targeting"    -Info "Allow to use Z-Targeting on enemies, objects and NPC's from any distance"                                      -Credits "Admentus"
    CreateReduxCheckBox     -Name "ManualJump"                  -Text "Manual Jump"            -Info "Press Z + A to do a Manual Jump instead of a Jump Attack`nPress B mid-air after jumping to do a Jump Attack"   -Credits "Admentus (ROM hack) & CloudModding (GameShark)"
  # CreateReduxCheckBox     -Name "SwordBeamAttack"             -Text "Sword Beam Attack"      -Info "Charging the Spin Attack will launch a Sword Beam Attack instead`nYou can still execute the Quick Spin Attack" -Credits "fkualol"
    
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
    CreateReduxCheckBox     -Name "SubscreenDelayFix"  -Text "Pause Screen Delay Fix" -Checked -Info "Removes the delay when opening the Pause Screen" -Credits "zel"
    if ($Settings.Debug.LiteGUI -eq $False) {
        CreateReduxCheckBox -Name "PoacherSawFix"      -Text "Poacher's Saw Fix" -Checked      -Info "Obtaining the Poacher's Saw no longer prevents Link from obtaining the second Deku Nut upgrade" -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "RemoveNaviPrompts"  -Text "Remove Navi Prompts"             -Info "Navi will no longer interupt your during the first dungeon with mandatory textboxes"            -Credits "Ported from Redux"
        CreateReduxCheckBox -Name "DefaultZTargeting"  -Text "Default Hold Z-Targeting"        -Info "Change the Default Z-Targeting option to Hold instead of Switch"                                -Credits "Ported from Redux"
        CreateReduxCheckBox -Name "InstantClaimCheck"  -Text "Instant Claim Check"             -Info "Remove the check for waiting until the Biggoron Sword can be claimed through the Claim Check"   -Credits "Ported from Rando"
        CreateReduxCheckBox -Name "HideCredits"        -Text "Hide Credits"                    -Info "Do not show the credits text during the credits sequence"                                       -Credits "Admentus"
    }
    CreateReduxCheckBox -Name "DebugMapSelect"         -Text "Debug Map Select"                -Info "Enable the Map Select menu like in the Debug ROM`nThe File Select menu now opens the Map Select menu instead`nA separate debug save file is used" -Credits "Jared Johnson (translated by Zelda Edit)"
    
}



#==============================================================================================================================================================================================
function CreateTabRedux() {
    
    # INTERFACE #
    CreateReduxGroup    -Tag  "UI" -Text "Interface Icons"
    CreateReduxCheckBox -Name "ShowFileSelectIcons" -Checked -Text "Show File Select Icons" -Info "Show icons on the File Select screen to display your save file progress" -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "DPadLayoutShow"      -Checked -Text "Show D-Pad Icon"        -Info "Show the D-Pad icons ingame that display item shortcuts"                 -Credits "Ported from Redux"

    CreateButtonColorOptions

}



#==============================================================================================================================================================================================
function CreateTabLanguage() {
    
    CreateLanguageContent

    # TEXT SPEED #
    CreateReduxGroup       -Tag  "Text" -Text "Text Speed"
    CreateReduxPanel
    CreateReduxRadioButton -Name "Speed1x" -Max 3 -SaveTo "Speed" -Checked -Text "1x Text Speed"   -Info "Leave the dialogue text speed at normal"
    CreateReduxRadioButton -Name "Speed2x" -Max 3 -SaveTo "Speed"          -Text "2x Text Speed"   -Info "Set the dialogue text speed to be twice as fast"       -Credits "Ported from Redux"
    CreateReduxRadioButton -Name "Speed3x" -Max 3 -SaveTo "Speed"          -Text "3x Text Speed"   -Info "Set the dialogue text speed to be three times as fast" -Credits "Ported from Redux"
    
    # ENGLISH TEXT #
    $Redux.Box.Dialogue = CreateReduxGroup -Tag "Text" -Text "English Dialogue"
    CreateReduxPanel
    CreateReduxRadioButton -Name "Vanilla"        -Max 4 -SaveTo "Dialogue"          -Text "Vanilla Text"    -Info "Keep the text as it is"
    CreateReduxRadioButton -Name "Redux"          -Max 4 -SaveTo "Dialogue" -Checked -Text "Redux Text"      -Info "Include the changes from the Redux script such as being able to move during the Gold Skulltula Token textboxes" -Credits "Redux"
    CreateReduxRadioButton -Name "Restore"        -Max 4 -SaveTo "Dialogue"          -Text "Restore Text"    -Info ("Restores the text used from the GC revision and applies grammar and typo fixes`nAlso corrects some icons in the text`n" + 'Includes the changes from "Redux Text" as well') -Credits "Redux"
    CreateReduxRadioButton -Name "FemalePronouns" -Max 4 -SaveTo "Dialogue"          -Text "Female Pronouns" -Info "Refer to Link as a female character" -Credits "Admentus & Mil`n(includes Restore Text by ShadowOne)"

    $Redux.Box.Text = CreateReduxGroup -Tag  "Text" -Text "Other English Options"
    CreateReduxCheckBox    -Name "PauseScreen" -Text "MM Pause Screen" -Info "Replaces the Pause Screen textures to be styled like Majora's Mask" -Credits "Garo-Mastah & CM"

    for ($i=0; $i -lt $GamePatch.languages.Length; $i++) {
        $Redux.Language[$i].Add_CheckedChanged({ UnlockLanguageContent })
    }
    UnlockLanguageContent

}



#==============================================================================================================================================================================================
function UnlockLanguageContent() {
    
    # English options
    EnableElem -Elem $Redux.Text.Vanilla        -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.Redux          -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.Restore        -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.FemalePronouns -Active $Redux.Language[0].Checked
    EnableElem -Elem $Redux.Text.PauseScreen    -Active $Redux.Language[0].Checked

    # Set max text speed in each language
    for ($i=0; $i -lt $GamePatch.languages.Length; $i++) {
        if ($Redux.Language[$i].checked) {
            EnableElem -Elem @($Redux.Text.Speed1x, $Redux.Text.Speed2x, $Redux.Text.Speed3x) -Active $True
            if ($GamePatch.languages[$i].max_text_speed -lt 3) {
                EnableElem -Elem $Redux.Text.Speed3x -Active $False
                if ($Redux.Text.Speed3x.Checked) { $Redux.Text.Speed2x.checked = $True }
            }
            if ($GamePatch.languages[$i].max_text_speed -lt 2) {
                EnableElem -Elem @($Redux.Text.Speed1x, $Redux.Text.Speed2x) -Active $False
            }
        }
    }

}



#==============================================================================================================================================================================================
function CreateTabAudiovisual() {

    
    # GRAPHICS #
    CreateReduxGroup -Tag  "Graphics" -Text "Graphics" -Columns 4

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


    CreateReduxCheckBox -Name "Widescreen"   -Text "16:9 Widescreen"        -Info $Info                                                                          -Credits $Credits
    CreateReduxCheckBox -Name "ExtendedDraw" -Text "Extended Draw Distance" -Info "Increases the game's draw distance for objects`nDoes not work on all objects" -Credits "Admentus"
    CreateReduxComboBox -Name "BlackBars"    -Text "No Black Bars" -Items @("Always enabled", "Disable for Z-Targeting only", "Disable for cutscenes only", "Always disabled") -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes" -Credits "Admentus"
    


    # MODELS #
    CreateReduxPanel -Columns 4 -Rows 1 -Row 1
    CreateReduxRadioButton -Name "OriginalModels"   -Max 4 -SaveTo "Models" -Column 1 -Row 1 -Text "Vanilla Models" -Checked -Info "Do not change the models for Link"
    CreateReduxRadioButton -Name "ListLinkModels"   -Max 4 -SaveTo "Models" -Column 2 -Row 1 -Text "Link Models"             -Info "List all male model replacements styled after Link to play as"
    CreateReduxRadioButton -Name "ListMaleModels"   -Max 4 -SaveTo "Models" -Column 3 -Row 1 -Text "Male Models"             -Info "List all male model replacements to play as"
    CreateReduxRadioButton -Name "ListFemaleModels" -Max 4 -SaveTo "Models" -Column 4 -Row 1 -Text "Female Models"           -Info "List all female model replacements to play as"
    CreateReduxCheckBox    -Name "MMChildLink"  -Column 3 -Row 3 -Text "MM Child Model" -Info "Include the MM Child Link Model"
    CreateReduxCheckBox -Name "ForceHiresModel" -Column 4 -Row 3 -Text "Force Hires Link Model" -Info "Always use Link's High Resolution Model when Link is too far away" -Credits "GhostlyDark"

    $Models = LoadModelsList "Link"   | Sort-Object
    CreateReduxComboBox -Name "LinkModels"      -Column 1 -Row 3 -Text "Player Models" -Items $Models -Length 240 -Default ($Models.indexOf("Majora's Mask") + 1)       -Info "Replace the model(s) used for Link`nOptions include models styled after Link`nContains combined (Child + Adult) or individual (Adult) models"
    $Models = LoadModelsList "Link+"  | Sort-Object
    CreateReduxComboBox -Name "LinkModelsPlus"  -Column 1 -Row 3 -Text "Player Models" -Items $Models -Length 240 -Default ($Models.indexOf("Majora's Mask") + 1)       -Info "Replace the models used for Link`nOptions include models styled after Link`nAll options include the Majora's Mask Child Model"
    $Models = LoadModelsList "Male"   | Sort-Object
    CreateReduxComboBox -Name "MaleModels"      -Column 1 -Row 3 -Text "Player Models" -Items $Models -Length 240 -Default ($Models.indexOf("Mega Man") + 1)            -Info "Replace the models used for Link`nOptions include custom male models"
    $Models = LoadModelsList "Female" | Sort-Object
    CreateReduxComboBox -Name "FemaleModels"    -Column 1 -Row 3 -Text "Player Models" -Items $Models -Length 240 -Default ($Models.indexOf("Hatsune Miku - Link") + 1) -Info "Replace the models used for Link`nOptions include custom female models"

    

    # MODELS PREVIEW #
    CreateReduxGroup -Tag "Graphics" -Text "Models Preview"
    $Last.Group.Height = (DPISize 161)
    $Redux.Graphics.ModelsPreview = New-Object Windows.Forms.PictureBox
    $Redux.Graphics.ModelsPreview.Location = (DPISize (New-object System.Drawing.Size(5, 15)))
    $Redux.Graphics.ModelsPreview.Width  = $Last.Group.Width - (DPISize 10)
    $Redux.Graphics.ModelsPreview.Height = $Last.Group.Height - (DPISize 20)
    $Last.Group.controls.add($Redux.Graphics.ModelsPreview)
    $global:PreviewToolTip = CreateToolTip
    ChangeModelsSelection
    
    

    # INTERFACE #
    CreateReduxGroup    -Tag  "UI" -Text "Interface"
    $Last.Group.Width = $Redux.Groups[$Redux.Groups.Length-3].Width
    $Last.Group.Top = $Redux.Groups[$Redux.Groups.Length-3].Bottom + 5
    CreateReduxCheckBox -Name "HudTextures"      -Text "MM HUD Textures"     -Info "Replaces the HUD textures with those from Majora's Mask"                                  -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "ButtonPositions"  -Text "MM Button Positions" -Info "Positions the A and B buttons like in Majora's Mask"                                      -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "CenterNaviPrompt" -Text "Center Navi Prompt"  -Info 'Centers the "Navi" prompt shown in the C-Up button'                                       -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "GCScheme"         -Text "GC Scheme"           -Info "Replace and change the textures, dialogue and text colors to match the GameCube's scheme" -Credits "Admentus, GhostlyDark & ShadowOne333" -Warning "Dialogue changes are only available for the English language"

    # SOUNDS / VOICES #
    CreateReduxGroup    -Tag  "Sounds" -Text "Sounds / Voices"
    CreateReduxComboBox -Name "Voices"         -Column 1 -Text "Link's Voice" -Items @("Original", "Majora's Mask", "Feminine")  -Info "1. Keep the original voices for Link`n2. Replace the voices for Link with those used in Majora's Mask`n2. Replace the voices for Link to sound feminine" -Credits "`nMajora's Mask: Ported by Korey Cryderman and corrected by GhostlyDark`nFeminine: theluigidude2007"
    if ($Settings.Debug.LiteGUI -eq $False) {
        CreateReduxComboBox -Name "Instrument" -Column 3 -Text "Instrument"   -Items @("Ocarina", "Female", "Voice", "Whistle Harp", "Grind-Organ", "Flute") -Info "Replace the sound used for playing the Ocarina of Time" -Credits "Ported from Rando"
    }



    if ($Settings.Debug.LiteGUI -ne $True) {

    # SFX SOUND EFFECTS #
    CreateReduxGroup    -Tag "SFX" -Text "SFX Sound Effects"
    $SFX = @("Default", "Disabled", "Soft Beep", "Bark", "Bomb Bounce", "Bongo Bongo Low", "Bow Twang", "Business Scrub", "Carrot Refill", "Cluck", "Drawbridge Set", "Guay", "Horse Trot", "HP Recover", "Iron Boots", "Moo", "Mweep!", 'Navi "Hey!"', "Navi Random", "Notification", "Pot Shattering", "Ribbit", "Rupee (Silver)", "Switch", "Sword Bonk", "Tambourine", "Timer", "Zelda Gasp (Adult)")
    CreateReduxComboBox -Name "LowHP"      -Column 1 -Row 1 -Text "Low HP"      -Items $SFX -Info "Set the sound effect for the low HP beeping"                      -Credits "Ported from Rando"
    $SFX = @("Default",  "Disabled", "Soft Beep", "Bark", "Business Scrub", "Carrot Refill", "Cluck", "Cockadoodledoo", "Dusk Howl", "Exploding Crate", "Explosion", "Great Fairy", "Guay", "Horse Neigh", "HP Low", "HP Recover", "Ice Shattering", "Moo", "Meweep!", 'Navi "Hello!"', "Notification", "Pot Shattering", "Redead Scream", "Ribbit", "Ruto Giggle", "Skulltula", "Tambourine", "Timer", "Zelda Gasp (Adult)")
    CreateReduxComboBox -Name "Navi"       -Column 3 -Row 1 -Text "Navi"        -Items $SFX -Info "Replace the sound used for Navi when she wants to tell something" -Credits "Ported from Rando"
    CreateReduxComboBox -Name "ZTarget"    -Column 5 -Row 1 -Text "Z-Target"    -Items $SFX -Info "Replace the sound used for Z-Targeting enemies"                   -Credits "Ported from Rando"

    CreateReduxComboBox -Name "HoverBoots" -Column 1 -Row 2 -Text "Hover Boots" -Items @("Default", "Disabled", "Bark", "Cartoon Fall", "Flare Dancer Laugh", "Mweep!", "Shabom Pop", "Tambourine")                            -Info "Replace the sound used for the Hover Boots"   -Credits "Ported from Rando"
    CreateReduxComboBox -Name "Horse"      -Column 3 -Row 2 -Text "Horse Neigh" -Items @("Default", "Disabled", "Armos", "Child Scream", "Great Fairy", "Moo", "Mweep!", "Redead Scream", "Ruto Wiggle", "Stalchild Attack")   -Info "Replace the sound for horses when neighing"   -Credits "Ported from Rando"
    CreateReduxComboBox -Name "Nightfall"  -Column 5 -Row 2 -Text "Nightfall"   -Items @("Default", "Disabled", "Cockadoodledoo", "Gold Skull Token", "Great Fairy", "Moo", "Mweep!", "Redead Moan", "Talon Snore", "Thunder") -Info "Replace the sound used when Nightfall occurs" -Credits "Ported from Rando"
    $SFX = @("Default", "Disabled", "Soft Beep", "Bark", "Bomb Bounce", "Bongo Bongo High", "Bongo Bongo Low", "Bottle Cork", "Bow Twang", "Bubble Laugh", "Carrot Refill", "Change Item", "Child Pant", "Cluck", "Deku Baba", "Drawbridge Set", "Dusk Howl", "Fanfare (Light)", "Fanfare (Medium)", "Field Shrub", "Flare Dancer Startled",
    'Ganondorf "Teh"', "Gohma Larva Croak", "Gold Skull Token", "Goron Wake", "Guay", "Gunshot", "Hammer Bonk", "Horse Trot", "HP Low", "HP Recover", "Iron Boots", "Iron Knuckle", "Moo", "Mweep!", "Notification", "Phantom Ganon Laugh", "Plant Explode", "Pot Shattering", "Redead Moan", "Ribbit", "Rupee", "Rupee (Silver)", "Ruto Crash",
    "Ruto Lift", "Ruto Thrown", "Scrub Emerge", "Shabom Bounce", "Shabom Pop", "Shellblade", "Skulltula", "Spit Nut", "Switch", "Sword Bonk", 'Talon "Hmm"', "Talon Snore", "Talon WTF", "Tambourine", "Target Enemy", "Target Neutral", "Thunder", "Timer", "Zelda Gasp (Adult)")
    CreateReduxComboBox -Name "FileCursor" -Column 1 -Row 3 -Text "File Cursor" -Items $SFX -Info "Replace the sound used when moving the cursor in the File Select menu"   -Credits "Ported from Rando"
    CreateReduxComboBox -Name "FileSelect" -Column 3 -Row 3 -Text "File Select" -Items $SFX -Info "Replace the sound used when selecting something in the File Select menu" -Credits "Ported from Rando"

    }

    # FILE SELECT #
    CreateReduxGroup    -Tag "FileSelect" -Text "File Select"
    $Music = @("None", "File Select", "Hyrule Field", "Market", "Kakariko Village (Child)", "Kakariko Village (Adult)", "Windmill Hut", "Hyrule Castle Courtyard", "Lon Lon Ranch", "Kokiri Forest", "Lost Woods", "Goron City", "Zora's Domain", "Gerudo Valley", "Chamber of the Sages", "Shop", "House", "Potion Shop",
    "Inside the Deku Tree", "Dodongo's Cavern", "Inside Jabu-Jabu's Belly", "Forest Temple", "Fire Temple", "Water Temple", "Ice Cavern", "Shadow Temple", "Spirit Temple", "Ganon's Castle Under Ground",
    "Battle", "Mini-Boss Battle", "Boss Battle", "Boss Battle 2", "Ganondorf Battle", "Ganon Battle", "End Credits I", "End Credits II", "End Credits III", "End Credits IV")
    CreateReduxComboBox -Name "Music"  -Column 1 -Text "Music"  -Default 2 -Items $Music -Info "Set the skybox music theme for the File Select menu" -Credits "Admentus"
    CreateReduxComboBox -Name "Skybox" -Column 3 -Text "Skybox" -Default 4 -Items @("Dawn", "Day", "Dusk", "Night", "Darkness (Dawn)", "Darkness (Day)", "Darkness (Dusk)", "Darkness (Night)") -Info "Set the skybox theme for the File Select menu" -Credits "Admentus"
    

}



#==============================================================================================================================================================================================
function CreateTabDifficulty() {
    
    # HERO MODE #
    CreateReduxGroup    -Tag  "Hero" -Text "Hero Mode"
    CreateReduxComboBox -Name "Damage"     -Column 1 -Row 1 -Shift 10 -Text "Damage"       -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage", "OHKO Mode") -Info "Set the amount of damage you receive`nOHKO Mode = You die in one hit"                                   -Credits "Admentus"
    CreateReduxComboBox -Name "Recovery"   -Column 3 -Row 1 -Shift 10 -Text "Recovery"     -Items @("1x Recovery", "1/2x Recovery", "1/4x Recovery", "0x Recovery")  -Info "Set the amount health you recovery from Recovery Hearts`nRecovery Heart drops are removed if set to 0x" -Credits "Admentus & Rando (No Heart Drops)"
    CreateReduxComboBox -Name "MagicUsage" -Column 5 -Row 1 -Shift 10 -Text "Magic Usage"  -Items @("1x Magic Usage", "2x Magic Usage", "3x Magic Usage")            -Info "Set the amount of times magic is consumed at"                                                           -Credits "Admentus"
    CreateReduxComboBox -Name "MonsterHP"  -Column 1 -Row 2 -Shift 10 -Text "Monster HP"   -Items @("1x Monster HP", "2x Monster HP", "3x Monster HP")               -Info "Set the amount of health for monsters"                                                                  -Credits "Admentus" -Warning "Half of the enemies are missing"
    CreateReduxComboBox -Name "MiniBossHP" -Column 3 -Row 2 -Shift 10 -Text "Mini-Boss HP" -Items @("1x Mini-Boss HP", "2x Mini-Boss HP", "3x Mini-Boss HP")         -Info "Set the amount of health for elite monsters and mini-bosses"                                            -Credits "Admentus" -Warning "Big Octo and Dark Link are missing"
    CreateReduxComboBox -Name "BossHP"     -Column 5 -Row 2 -Shift 10 -Text "Boss HP"      -Items @("1x Boss HP", "2x Boss HP", "3x Boss HP")                        -Info "Set the amount of health for bosses"                                                                    -Credits "Admentus & Marcelo20XX"
    CreateReduxCheckBox -Name "HarderChildBosses" -Column 1 -Row 3 -Text "Harder Child Bosses" -Info "Replace objects in the Child Dungeon Boss arenas with additional monsters" -Credits "BilonFullHDemon"

    $Redux.Hero.Damage.Add_SelectedIndexChanged({ EnableElem -Elem $Redux.Hero.Recovery -Active ($this.text -ne "OHKO Mode") })
    EnableElem -Elem ($Redux.Hero.Recovery) -Active ($Redux.Hero.Damage.text -ne "OHKO Mode")

    if ($Settings.Debug.LiteGUI -eq $True) { return }

    # MASTER QUEST #
    CreateReduxGroup -Tag "MQ" -Text "Master Quest"
    CreateReduxPanel
    CreateReduxRadioButton -Name "Disable"   -Max 3 -SaveTo "Dungeons" -Text "Disable" -Checked -Info "All dungeons remain vanilla"
    CreateReduxRadioButton -Name "Select"    -Max 3 -SaveTo "Dungeons" -Text "Select"           -Info "Select which dungeons you want from Master Quest" -Credits "ShadowOne333"
    CreateReduxRadioButton -Name "Randomize" -Max 3 -SaveTo "Dungeons" -Text "Randomize"        -Info "Randomize the amount of Master Quest dungeons"    -Credits "ShadowOne333"

    # MASTER QUEST DUNGEONS #
    $Redux.Box.SelectMQ = CreateReduxGroup -Tag "MQ" -Text "Select - Master Quest Dungeons"
    CreateReduxCheckBox -Name "InsideTheDekuTree"    -Text "Inside the Deku Tree"     -Checked -Info "Patch Inside the Deku Tree to Master Quest"     -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "DodongosCavern"       -Text "Dodongo's Cavern"         -Checked -Info "Patch Dodongo's Cavern to Master Quest"         -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "InsideJabuJabusBelly" -Text "Inside Jabu-Jabu's Belly" -Checked -Info "Patch Inside Jabu-Jabu's Belly to Master Quest" -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "ForestTemple"         -Text "Forest Temple"            -Checked -Info "Patch Forest Temple to Master Quest"            -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "FireTemple"           -Text "Fire Temple"              -Checked -Info "Patch Fire Temple to Master Quest"              -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "WaterTemple"          -Text "Water Temple"             -Checked -Info "Patch Water Temple to Master Quest"             -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "ShadowTemple"         -Text "Shadow Temple"            -Checked -Info "Patch Shadow Temple to Master Quest"            -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "SpiritTemple"         -Text "Spirit Temple"            -Checked -Info "Patch Spirit Temple to Master Quest"            -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "IceCavern"            -Text "Ice Cavern"               -Checked -Info "Patch Ice Cavern to Master Quest"               -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "BottomOfTheWell"      -Text "Bottom of the Well"       -Checked -Info "Patch Bottom of the Well to Master Quest"       -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "GerudoTrainingGround" -Text "Gerudo Training Ground"   -Checked -Info "Patch Gerudo Training Ground to Master Quest"   -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "InsideGanonsCastle"   -Text "Inside Ganon's Castle"    -Checked -Info "Patch Inside Ganon's Castle to Master Quest"    -Credits "ShadowOne333"

    # RANDOMIZE MASTER QUEST DUNGEONS #
    $Redux.Box.RandomizeMQ = CreateReduxGroup -Tag "MQ" -Text "Randomize - Master Quest Dungeons"
    $Items = @("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12")
    CreateReduxComboBox -Name "Minimum" -Column 1 -Shift 10 -Text "Minimum" -Default 1            -Items $Items
    CreateReduxComboBox -Name "Maximum" -Column 3 -Shift 10 -Text "Maximum" -Default $Items.Count -Items $Items

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
function CreateTabColors() {

    # EQUIPMENT COLORS #
    CreateReduxGroup -Tag "Colors" -Text "Equipment Colors"
    $Redux.Colors.Equipment = @()
    $Colors = @("Kokiri Green", "Goron Red", "Zora Blue", "Black", "White", "Azure Blue", "Vivid Cyan", "Light Red", "Fuchsia", "Purple", "Majora Purple", "Twitch Purple", "Persian Rose", "Dirty Yellow", "Blush Pink", "Hot Pink", "Rose Pink", "Orange", "Gray", "Gold", "Silver", "Beige", "Teal", "Blood Red", "Blood Orange", "Royal Blue", "Sonic Blue", "NES Green", "Dark Green", "Lumen", "Randomized", "Custom")
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "KokiriTunic"       -Column 1 -Row 1 -Text "Kokiri Tunic Color"        -Default 1 -Length 230 -Shift 70 -Items $Colors -Info ("Select a color scheme for the Kokiri Tunic`n" + '"Randomized" fully randomizes the colors each time the patcher is opened')     -Credits "Ported from Rando"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "GoronTunic"        -Column 1 -Row 2 -Text "Goron Tunic Color"         -Default 2 -Length 230 -Shift 70 -Items $Colors -Info ("Select a color scheme for the Goron Tunic`n" + '"Randomized" fully randomizes the colors each time the patcher is opened')      -Credits "Ported from Rando"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "ZoraTunic"         -Column 1 -Row 3 -Text "Zora Tunic Color"          -Default 3 -Length 230 -Shift 70 -Items $Colors -Info ("Select a color scheme for the Zora Tunic`n" + '"Randomized" fully randomizes the colors each time the patcher is opened')       -Credits "Ported from Rando"
    $Colors = @("Silver", "Gold", "Black", "Green", "Blue", "Bronze", "Red", "Sky Blue", "Pink", "Magenta", "Orange", "Lime", "Purple", "Randomized", "Custom")
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "SilverGauntlets"   -Column 4 -Row 1 -Text "Silver Gauntlets Color"    -Default 1 -Length 230 -Shift 70 -Items $Colors -Info ("Select a color scheme for the Silver Gauntlets`n" + '"Randomized" fully randomizes the colors each time the patcher is opened') -Credits "Ported from Rando"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "GoldenGauntlets"   -Column 4 -Row 2 -Text "Golden Gauntlets Color"    -Default 2 -Length 230 -Shift 70 -Items $Colors -Info ("Select a color scheme for the Golden Gauntlets`n" + '"Randomized" fully randomizes the colors each time the patcher is opened') -Credits "Ported from Rando"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "MirrorShieldFrame" -Column 4 -Row 3 -Text "Mirror Shield Frame Color" -Default 1 -Length 230 -Shift 70 -Items @("Red", "Green", "Blue", "Yellow", "Cyan", "Magenta", "Orange", "Gold", "Purple", "Pink", "Randomized", "Custom") -Info "Select a color scheme for the Mirror Shield Frame`n- This option might not work for every custom player model" -Credits "Ported from Rando"

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
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "1E691B" -Name "SetKokiriTunic"       -IsGame -Button $Buttons[0]
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "641400" -Name "SetGoronTunic"        -IsGame -Button $Buttons[1]
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "003C64" -Name "SetZoraTunic"         -IsGame -Button $Buttons[2]
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "FFFFFF" -Name "SetSilverGauntlets"   -IsGame -Button $Buttons[3]
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "FECF0F" -Name "SetGoldenGauntlets"   -IsGame -Button $Buttons[4]
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "D70000" -Name "SetMirrorShieldFrame" -IsGame -Button $Buttons[5]

    # Equipment Colors - Labels
    $Redux.Colors.EquipmentLabels = @()
    for ($i=0; $i -lt $Buttons.length; $i++) {
        $Buttons[$i].Add_Click({ $Redux.Colors.SetEquipment[[uint16]$this.Tag].ShowDialog(); $Redux.Colors.Equipment[[uint16]$this.Tag].Text = "Custom"; $Redux.Colors.EquipmentLabels[[uint16]$this.Tag].BackColor = $Redux.Colors.SetEquipment[[uint16]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetEquipment[[uint16]$this.Tag].Tag] = $Redux.Colors.SetEquipment[[uint16]$this.Tag].Color.Name })
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

    # SWORD TRAIL COLORS #
    CreateSwordTrailColorOptions

    # FAIRY COLORS #
    CreateFairyColorOptions
    CreateReduxCheckBox -Name "BetaNavi" -Text "Beta Navi Colors" -Info "Use the Beta colors for Navi" -Column 1 -Row 2

    $Redux.Colors.BetaNavi.Add_CheckedChanged({ EnableElem -Elem $Redux.Colors.Fairy -Active (!$this.checked) })
    EnableElem -Elem $Redux.Colors.Fairy -Active (!$Redux.Colors.BetaNavi.Checked)

}



#==============================================================================================================================================================================================
function CreateTabEquipment() {

    # CAPACITY SELECTION #
    CreateReduxGroup    -Tag  "Capacity" -Text "Capacity Selection" -Columns 2
    CreateReduxCheckBox -Name "EnableAmmo"    -Text "Change Ammo Capacity"   -Info "Enable changing the capacity values for ammo"
    CreateReduxCheckBox -Name "EnableWallet"  -Text "Change Wallet Capacity" -Info "Enable changing the capacity values for the wallets"

    # EQUIPMENT #
    CreateReduxGroup    -Tag  "Equipment" -Text "Equipment Adjustments"
    CreateReduxCheckBox -Name "UnsheathSword" -Text "Unsheath Sword" -Info "The sword is unsheathed first before immediately swinging it" -Credits "Admentus"
    CreateReduxCheckBox -Name "RazorSword"    -Text "Razor Sword"    -Info "Replace the Kokiri Sword with the Razor Sword and the Deku Shield with the Hero's Shield from Majora's Mask`nThe replaced Deku Shield will not burn up anymore" -Warning "This option only works for the Vanilla Child Link model" -Credits "DeadSubiter (ported) & issuelink, Zeldaboy14 and Flotonic (Debug ROM patch)"
    CreateReduxCheckBox -Name "IronShield"    -Text "Iron Shield"    -Info "Replace the Deku Shield with the Iron Shield, which will not burn up anymore" -Warning "Some custom models do not support the new textures, but will still keep the fireproof shield" -Credits "Admentus (ported), ZombieBrainySnack (textures) & Three Pendants (Debug fireproof ROM patch)" -Link $Redux.Equipment.RazorSword
    CreateReduxCheckBox -Name "HeroShield"    -Text "Hero's Shield"  -Info "Replace the Hylian Shield with the Hero's Shield"                             -Warning "Some custom models do not support this option"                                                -Credits "SoulofDeity"

    # AMMO #
    $Redux.Box.Ammo = CreateReduxGroup -Tag "Capacity" -Text "Ammo Capacity Selection"
    CreateReduxTextBox -Name "Quiver1"     -Text "Quiver (1)"      -Value 30  -Info "Set the capacity for the Quiver (Base)`nDefault = 30"           -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver2"     -Text "Quiver (2)"      -Value 40  -Info "Set the capacity for the Quiver (Upgrade 1)`nDefault = 40"      -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver3"     -Text "Quiver (3)"      -Value 50  -Info "Set the capacity for the Quiver (Upgrade 2)`nDefault = 50"      -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag1"    -Text "Bomb Bag (1)"    -Value 20  -Info "Set the capacity for the Bomb Bag (Base)`nDefault = 20"         -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag2"    -Text "Bomb Bag (2)"    -Value 30  -Info "Set the capacity for the Bomb Bag (Upgrade 1)`nDefault = 30"    -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag3"    -Text "Bomb Bag (3)"    -Value 40  -Info "Set the capacity for the Bomb Bag (Upgrade 2)`nDefault = 40"    -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BulletBag1"  -Text "Bullet Bag (1)"  -Value 30  -Info "Set the capacity for the Bullet Bag (Base)`nDefault = 30"       -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BulletBag2"  -Text "Bullet Bag (2)"  -Value 40  -Info "Set the capacity for the Bullet Bag (Upgrade 1)`nDefault = 40"  -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BulletBag3"  -Text "Bullet Bag (3)"  -Value 50  -Info "Set the capacity for the Bullet Bag (Upgrade 2)`nDefault = 50"  -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuSticks1" -Text "Deku Sticks (1)" -Value 10  -Info "Set the capacity for the Deku Sticks (Base)`nDefault = 10"      -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuSticks2" -Text "Deku Sticks (2)" -Value 20  -Info "Set the capacity for the Deku Sticks (Upgrade 1)`nDefault = 20" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuSticks3" -Text "Deku Sticks (3)" -Value 30  -Info "Set the capacity for the Deku Sticks (Upgrade 2)`nDefault = 30" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuNuts1"   -Text "Deku Nuts (1)"   -Value 20  -Info "Set the capacity for the Deku Nuts (Base)`nDefault = 20"        -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuNuts2"   -Text "Deku Nuts (2)"   -Value 30  -Info "Set the capacity for the Deku Nuts (Upgrade 1)`nDefault = 30"   -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuNuts3"   -Text "Deku Nuts (3)"   -Value 40  -Info "Set the capacity for the Deku Nuts (Upgrade 2)`nDefault = 40"   -Credits "GhostlyDark"

    # WALLET #
    $Redux.Box.Wallet = CreateReduxGroup -Tag "Capacity" -Text "Wallet Capacity Selection"
    CreateReduxTextBox -Name "Wallet1" -Length 4 -Text "Wallet (1)" -Value 99  -Info "Set the capacity for the Wallet (Base)`nDefault = 99"       -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet2" -Length 4 -Text "Wallet (2)" -Value 200 -Info "Set the capacity for the Wallet (Upgrade 1)`nDefault = 200" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet3" -Length 4 -Text "Wallet (3)" -Value 500 -Info "Set the capacity for the Wallet (Upgrade 2)`nDefault = 500" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet4" -Length 4 -Text "Wallet (4)" -Value 500 -Info "Set the capacity for the Wallet (Upgrade 3)`nDefault = 500" -Credits "GhostlyDark" -Warning "This wallet is not obtained through regular gameplay"

    # UNLOCK CHILD RESTRICTIONS #
    CreateReduxGroup    -Tag  "Unlock" -Text "Unlock Child Restrictions"
    CreateReduxCheckBox -Name "Tunics"        -Text "Unlock Tunics"        -Info "Child Link is able to use the Goron Tunic and Zora Tunic`nSince you might want to walk around in style as well when you are young`nThe dialogue script will be adjusted to reflect this (only for English)" -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "MasterSword"   -Text "Unlock Master Sword"  -Info "Child Link is able to use the Master Sword`nThe Master Sword does twice as much damage as the Kokiri Sword" -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "GiantsKnife"   -Text "Unlock Giant's Knife" -Info "Child Link is able to use the Giant's Knife / Biggoron Sword`nThe Giant's Knife / Biggoron Sword does four times as much damage as the Kokiri Sword" -Credits "GhostlyDark" -Warning "The Giant's Knife / Biggoron Sword appears as if Link if thrusting the sword through the ground"
    CreateReduxCheckBox -Name "MirrorShield"  -Text "Unlock Mirror Shield" -Info "Child Link is able to use the Mirror Shield"              -Credits "GhostlyDark" -Warning "The Mirror Shield appears as invisible but can still reflect magic or sunlight"
    CreateReduxCheckBox -Name "Boots"         -Text "Unlock Boots"         -Info "Child Link is able to use the Iron Boots and Hover Boots" -Credits "GhostlyDark" -Warning "The Iron and Hover Boots appears as the Kokiri Boots"
    CreateReduxCheckBox -Name "MegatonHammer" -Text "Unlock Hammer"        -Info "Child Link is able to use the Megaton Hammer"             -Credits "GhostlyDark" -Warning "The Megaton Hammer appears as invisible"

    # UNLOCK ADULT RESTRICTIONS #
    CreateReduxGroup    -Tag  "Unlock" -Text "Unlock Adult Restrictions"
    CreateReduxCheckBox -Name "KokiriSword"    -Text "Unlock Kokiri Sword" -Info "Adult Link is able to use the Kokiri Sword`nThe Kokiri Sword does half as much damage as the Master Sword" -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "DekuShield"     -Text "Unlock Deku Shield"  -Info "Adult Link is able to use the Deku Shield"     -Credits "GhostlyDark" -Warning "The Deku Shield appears as invisible but can still be burned up by fire"
    CreateReduxCheckBox -Name "FairySlingshot" -Text "Unlock Slingshot"    -Info "Adult Link is able to use the Fairy Slingshot" -Credits "GhostlyDark" -Warning "The Fairy Slingshot appears as the Fairy Bow"
    CreateReduxCheckBox -Name "Boomerang"      -Text "Unlock Boomerang"    -Info "Adult Link is able to use the Boomerang"       -Credits "GhostlyDark" -Warning "The Boomerang appears as invisible"



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
function CreateTabAnimations() {
    
    # SKIP CUTSCENES #
    CreateReduxGroup    -Tag  "Skip"             -Text "Skip Cutscenes"
    CreateReduxCheckBox -Name "OpeningCutscene"  -Text "Opening Cutscene"       -Info "Skip the introduction cutscene, so you can start playing immediately"            -Credits "Ported from Better OoT"
    CreateReduxCheckBox -Name "AllMedallions"    -Text "All Medallions"         -Info "Cutscene for all medallions never triggers when leaving Shadow or Spirit Temple" -Credits "Ported from Better OoT"
    CreateReduxCheckBox -Name "DaruniaDance"     -Text "Darunia Dance"          -Info "Darunia will not dance"                                                          -Credits "Ported from Better OoT"
    CreateReduxCheckBox -Name "ZeldaEscape"      -Text "Zelda's Escape"         -Info "Skip the sequence where Zelda is escaping from Hyrule Castle"                    -Credits "Ported from Better OoT"
    CreateReduxCheckBox -Name "DungeonOutro"     -Text "Dungeon Outro"          -Info "Skip the sequence after clearing a dungeon"                                      -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "LightArrow"       -Text "Light Arrow"            -Info "Skip the sequence where Link obtains the Light Arrow"                            -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "RegularSongs"     -Text "Regular Songs"          -Info "Skip the cutscenes for learning regular songs"                                   -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "WarpSongs"        -Text "Warp Songs"             -Info "Skip the cutscenes for learning warp songs"                                      -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "RoyalTomb"        -Text "Royal Tomb"             -Info "Skip the destruction scene of the Royal Tomb entrance"                           -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "ChamberOfSages"   -Text "Chamber of Sages"       -Info "Skip the Chamber of Sages after each temple"                                     -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "JabuJabu"         -Text "Jabu-Jabu"              -Info "Skip the sequence where the Jabu-Jabu swallows Link"                             -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "GanonTower"       -Text "Ganon's Tower"          -Info "Skip the collapse of Ganon's Tower"                                              -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "DekuSeedBag"      -Text "Deku Seed Bag"          -Info "Skip the sequence after obtaining the Deku Seed Bag upgrade in the Lost Woods"   -Credits "Ported from Rando"

    # SPEEDUP CUTSCENES #
    CreateReduxGroup    -Tag  "Skip"             -Text "Speed-Up Cutscenes"
    CreateReduxCheckBox -Name "OpeningChests"    -Text "Opening Chests"         -Info "Make all chest opening animations fast by kicking them open"                     -Credits "Ported from Better OoT"
    CreateReduxCheckBox -Name "KingZora"         -Text "King Zora"              -Info "King Zora moves quickly"                                                         -Credits "Ported from Better OoT"
    CreateReduxCheckBox -Name "EponaRace"        -Text "Epona Race"             -Info "The Epona race with Ingo starts faster"                                          -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "HorsebackArchery" -Text "Horseback Archery"      -Info "The Horseback Archery mini starts and ends faster"                               -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "DoorOfTime"       -Text "Door of Time"           -Info "The Door of Time in the Temple of Time opens much faster"                        -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "DrainingTheWell"  -Text "Draining the Well"      -Info "The well in Kakariko Village drains much faster"                                 -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "Bosses"           -Text "Bosses"                 -Info "Speed-up sequences related to some dungeon bosses"                               -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "RainbowBridge"    -Text "Rainbow Bridge"         -Info "Speed-up the sequence where the Rainbow Bridge appears"                          -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "FairyOcarina"     -Text "Fairy Ocarina"          -Info "Speed-up the sequence where Link obtains the Fairy Ocarina"                      -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "GanonTrials"      -Text "Ganon's Trials"         -Info "Skip the completion sequence of the Ganon's Castle trials"                       -Credits "Ported from Rando"
    
    # Restore CUTSCENES #
    CreateReduxGroup    -Tag  "Restore"          -Text "Restore Cutscenes"
    CreateReduxCheckBox -Name "OpeningCutscene"  -Text "Opening Cutscene"       -Info "Restore the beta introduction cutscene" -Link $Redux.Skip.OpeningCutscene        -Credits "Admentus (ROM hack) & CloudModding (GameShark)"

    # ANIMATIONS #
    CreateReduxGroup    -Tag  "Animation"        -Text "Link Animations"
    $weapons = "`n`nAffected weapons:`n- Giant's Knife`n- Giant's Knife (Broken)`n- Biggoron Sword`n- Deku Stick`n- Megaton Hammer"
    CreateReduxCheckBox -Name "WeaponIdle"       -Text "2-handed Weapon Idle"   -Info ("Restore the beta animation when idly holding a two-handed weapon" + $weapons)   -Credits "Admentus"
    CreateReduxCheckBox -Name "WeaponCrouch"     -Text "2-handed Weapon Crouch" -Info ("Restore the beta animation when crouching with a two-handed weapon" + $weapons) -Credits "Admentus"
    CreateReduxCheckBox -Name "WeaponAttack"     -Text "2-handed Weapon Attack" -Info ("Restore the beta animation when attacking with a two-handed weapon" + $weapons) -Credits "Admentus"
    CreateReduxCheckBox -Name "BackflipAttack"   -Text "Backflip Jump Attack"   -Info "Restore the beta animation to turn the Jump Attack into a Backflip Jump Attack"  -Credits "Admentus"
    CreateReduxCheckBox -Name "FrontflipAttack"  -Text "Frontflip Jump Attack"  -Info "Restore the beta animation to turn the Jump Attack into a Frontflip Jump Attack" -Credits "Admentus" -Link $Redux.Animation.BackflipAttack
    CreateReduxCheckBox -Name "FrontflipJump"    -Text "Frontflip Jump"         -Info "Replace the jumps with frontflip jumps"  -Credits "SoulofDeity"
    CreateReduxCheckBox -Name "SomarsaultJump"   -Text "Somarsault Jump"        -Info "Replace the jumps with somarsault jumps" -Credits "SoulofDeity" -Link $Redux.Animation.FrontflipJump

}