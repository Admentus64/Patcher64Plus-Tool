function PatchOptionsMajorasMask() {
    
    # BPS PATCHING LANGUAGE #
    if (IsSet -Elem $LanguagePatch) { # Language
        UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Language...")
        ApplyPatch -File $GetROM.decomp -Patch $LanguagePatch
    }

    # BPS PATCHING OPTIONS #
    UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Additional BPS Patch Options...")
    PatchBPSOptionsMajorasMask

    $global:ByteArrayGame = [IO.File]::ReadAllBytes($GetROM.decomp)

    # BYTE PATCHING OPTIONS #
    UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Additional General Options...")
    PatchByteOptionsMajorasMask

    # BYTE PATCHING REDUX #
    if ( (IsChecked $Patches.Redux -Active) -and (IsSet -Elem $GamePatch.redux.file) ) {
        UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Additional Redux Options...")
        PatchByteReduxMajorasMask
    }

    # LANGUAGE BYTE PATCHING OPTIONS #
    UpdateStatusLabel -Text ("Patching " + $GameType.mode + " Additional Language Options...")
    PatchLanguageOptionsMajorasMask

    [io.file]::WriteAllBytes($GetROM.decomp, $ByteArrayGame)

}



#==============================================================================================================================================================================================
function PatchByteOptionsMajorasMask() {
    
    # HERO MODE #

    if (IsText -Elem $Options.Damage -Text "OHKO Mode") {
        ChangeBytes -Offset "BABE7F" -Values @("09", "04") -Interval 16
        ChangeBytes -Offset "BABEA2" -Values @("2A", "00")
        ChangeBytes -Offset "BABEA5" -Values @("00", "00", "00")
    }
    elseif ( (IsText -Elem $Options.Damage -Text "1x Damage" -Not) -or (IsText -Elem $Options.Recovery -Text "1x Recovery" -Not) ) {
        ChangeBytes -Offset "BABE7F" -Values @("09", "04") -Interval 16
        if (IsText -Elem $Options.Recovery -Text "1x Recovery") {
            if (IsText -Elem $Options.Damage -Text "2x Damage")       { ChangeBytes -Offset "BABEA2" -Values @("28", "40") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("28", "80") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("28", "C0") }
            ChangeBytes -Offset "BABEA5" -Values @("00", "00", "00")
        }
        elseif (IsText -Elem $Options.Recovery -Text "1/2x Recovery") {
            if (IsText -Elem $Options.Damage -Text "1x Damage")       { ChangeBytes -Offset "BABEA2" -Values @("28", "40") }
            elseif (IsText -Elem $Options.Damage -Text "2x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("28", "80") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("28", "C0") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("29", "00") }
            ChangeBytes -Offset "BABEA5" -Values @("05", "28", "43")
        }
        elseif (IsText -Elem $Options.Recovery -Text "1/4x Recovery") {
            if (IsText -Elem $Options.Damage -Text "1x Damage")       { ChangeBytes -Offset "BABEA2" -Values @("28", "80") }
            elseif (IsText -Elem $Options.Damage -Text "2x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("28", "C0") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("29", "00") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("29", "40") }
            ChangeBytes -Offset "BABEA5" -Values @("05", "28", "83")
        }
        elseif (IsText -Elem $Options.Recovery -Text "0x Recovery") {
            if (IsText -Elem $Options.Damage -Text "1x Damage")       { ChangeBytes -Offset "BABEA2" -Values @("29", "40") }
            elseif (IsText -Elem $Options.Damage -Text "2x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("29", "80") }
            elseif (IsText -Elem $Options.Damage -Text "4x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("29", "C0") }
            elseif (IsText -Elem $Options.Damage -Text "8x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("2A", "00") }
            ChangeBytes -Offset "BABEA5" -Values @("05", "29", "43")
        }
    }

    if (IsText -Elem $Options.MagicUsage -Text "2x Magic Usage")      { ChangeBytes -Offset "BAC306" -Values @("2C","40") }
    elseif (IsText -Elem $Options.MagicUsage -Text "3x Magic Usage")  { ChangeBytes -Offset "BAC306" -Values @("2C","80") }



    # GRAPHICS #

    if (IsChecked -Elem $Options.WideScreen) {
        # 16:9 Widescreen
        if ($IsWiiVC) {
            ChangeBytes -Offset "BD5D74" -Values @("3C", "07", "3F", "E3")
            ChangeBytes -Offset "CA58F5" -Values @("6C", "53", "6C", "84", "9E", "B7", "53", "6C") -Interval 2
            # ChangeBytes -Offset "BAF2E0" -Values @("") # A Button
            # ChangeBytes -Offset "C55F14" -Values @("") # B, C-Left, C-Down, C-Right Buttons
        }

        # 16:9 Textures
        PatchBytes -Offset "A9A000" -Length "12C00" -Texture -Patch "Widescreen\Carnival of Time.bin"
        PatchBytes -Offset "AACC00" -Length "12C00" -Texture -Patch "Widescreen\Four Giants.bin"
        PatchBytes -Offset "C74DD0" -Length "800"   -Texture -Patch "Widescreen\Lens of Truth.bin"
    }

    if (IsChecked -Elem $Options.ExtendedDraw)        { ChangeBytes -Offset "B50874" -Values @("00", "00", "00", "00") }
    if (IsChecked -Elem $Options.BlackBars)           { ChangeBytes -Offset "BF72A4" -Values @("00", "00", "00", "00") }
    if (IsChecked -Elem $Options.PixelatedStars)      { ChangeBytes -Offset "B943FC" -Values @("10", "00") }



    # COLORS #

    if (IsChecked -Elem $Options.EnableTunicColors) {
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

    if (IsChecked -Elem $Options.RecolorMaskForms) {
        PatchBytes -Offset "117C780" -Length "100" -Texture -Patch "Recolor\Goron Red Tunic.bin"
        PatchBytes -Offset "1186EB8" -Length "100" -Texture -Patch "Recolor\Goron Red Tunic.bin" 

        PatchBytes -Offset "1197120" -Length "50"  -Texture -Patch "Recolor\Zora Blue Palette.bin"
        PatchBytes -Offset "119E698" -Length "50"  -Texture -Patch "Recolor\Zora Blue Palette.bin"
        PatchBytes -Offset "10FB0B0" -Length "400" -Texture -Patch "Recolor\Zora Blue Gradient.bin"
        PatchBytes -Offset "11A2228" -Length "400" -Texture -Patch "Recolor\Zora Blue Gradient.bin"
    }



    # GAMEPLAY
    
    if (IsChecked -Elem $Options.RestorePalaceRoute) {
        CreateSubPath -Path ($GameFiles.binaries + "\Deku Palace")
        ExportAndPatch -Path "Deku Palace\deku_palace_scene"  -Offset "2534000" -Length "D220"
        ExportAndPatch -Path "Deku Palace\deku_palace_room_0" -Offset "2542000" -Length "11A50"
        ExportAndPatch -Path "Deku Palace\deku_palace_room_1" -Offset "2554000" -Length "E950"  -NewLength "E9B0"  -TableOffset "1F6A7" -Values @("B0")
        ExportAndPatch -Path "Deku Palace\deku_palace_room_2" -Offset "2563000" -Length "124F0" -NewLength "124B0" -TableOffset "1F6B7" -Values @("B0")
    }

    if (IsChecked -Elem $Options.ZoraPhysics)         { PatchBytes  -Offset "65D000" -Patch "Zora Physics Fix.bin" }
    if (IsChecked -Elem $Options.DistantZTargeting)   { ChangeBytes -Offset "B4E924"  -Values @("00", "00", "00", "00") }



    # RESTORE

    if (IsChecked -Elem $Options.CorrectRomaniSign)   { PatchBytes -Offset "26A58C0" -Texture -Patch "Romani Sign.bin" }
    if (IsChecked -Elem $Options.CorrectComma)        { ChangeBytes -Offset "ACC660" -Values @("00", "F3", "00", "00", "00", "00", "00", "00", "4F", "60", "00", "00", "00", "00", "00", "00", "24") }
    if (IsChecked -Elem $Options.RestoreTitle)        { ChangeBytes -Offset "DE0C2E" -Values @("FF", "C8", "36", "10", "98", "00") }

    if (IsChecked -Elem $Options.CorrectRupeeColors) {
        ChangeBytes -Offset "10ED020" -Values @("70", "6B", "BB", "3F", "FF", "FF", "EF", "3F", "68", "AD", "C3", "FD", "E6", "BF", "CD", "7F", "48", "9B", "91", "AF", "C3", "7D", "BB", "3D", "40", "0F", "58", "19", "88", "ED", "80", "AB") # Purple
        ChangeBytes -Offset "10ED040" -Values @("D4", "C3", "F7", "49", "FF", "FF", "F7", "E1", "DD", "03", "EF", "89", "E7", "E3", "E7", "DD", "A3", "43", "D5", "C3", "DF", "85", "E7", "45", "7A", "43", "82", "83", "B4", "43", "CC", "83") # Gold
    }

    if (IsChecked -Elem $Options.RestoreCowNoseRing) {
        ChangeBytes -Offset "E10270"  -Values @("00", "00")
        ChangeBytes -Offset "107F5C4" -Values @("00", "00")
    }

    if (IsChecked -Elem $Options.RestoreSkullKid) {
        $Values = @()
        for ($i=0; $i -lt 256; $i++) {
            $Values += 0
            $Values += 1
        }
        ChangeBytes -Offset "181C820" -Values $Values
        PatchBytes  -Offset "181C620" -Texture -Patch "Skull Kid Beak.bin"
    }

    if (IsChecked -Elem $Options.RestoreShopMusic)    { ChangeBytes -Offset "2678007" -Values @("44") }
    if (IsChecked -Elem $Options.PieceOfHeartSound)   { ChangeBytes -Offset "BA94C8"  -Values @("10", "00") }
    if (IsChecked -Elem $Options.MoveBomberKid)       { ChangeBytes -Offset "2DE4396" -Values @("02", "C5", "01", "18", "FB", "55", "00", "07", "2D") }



    # EQUIPMENT #

    if (IsChecked -Elem $Options.EnableAmmoCapacity) {
        ChangeBytes -Offset "C5834F" -IsDec -Values @($Options.Quiver1.Text, $Options.Quiver2.Text, $Options.Quiver3.Text) -Interval 2
        ChangeBytes -Offset "C58357" -IsDec -Values @($Options.BombBag1.Text, $Options.BombBag2.Text, $Options.BombBag3.Text) -Interval 2
        ChangeBytes -Offset "C5837F" -IsDec -Values @($Options.DekuSticks1.Text, $Options.DekuSticks1.Text, $Options.DekuSticks1.Text) -Interval 2
        ChangeBytes -Offset "C58387" -IsDec -Values @($Options.DekuNuts1.Text, $Options.DekuNuts1.Text, $Options.DekuNuts1.Text) -Interval 2
    }

    if (IsChecked -Elem $Options.EnableWalletCapacity) {
        $Wallet1 = Get16Bit -Value ($Options.Wallet1.Text)
        $Wallet2 = Get16Bit -Value ($Options.Wallet2.Text)
        $Wallet3 = Get16Bit -Value ($Options.Wallet3.Text)
        ChangeBytes -Offset "C5836C" -Values @($Wallet1.Substring(0, 2), $Wallet1.Substring(2) )
        ChangeBytes -Offset "C5836E" -Values @($Wallet2.Substring(0, 2), $Wallet2.Substring(2) )
        ChangeBytes -Offset "C58370" -Values @($Wallet3.Substring(0, 2), $Wallet3.Substring(2) )
    }

    if (IsChecked -Elem $Options.RazorSword) {
        ChangeBytes -Offset "CBA496" -Values @("00", "00") # Prevent losing hits
        ChangeBytes -Offset "BDA6B7" -Values @("01")       # Keep sword after Song of Time
    }



    # OTHER #
    
    if (IsChecked -Elem $Options.FixSouthernSwamp) {
        CreateSubPath -Path ($GameFiles.binaries + "\Southern Swamp")
        ExportAndPatch -Path "Southern Swamp\southern_swamp_cleared_scene"  -Offset "1F0D000" -Length "10630"
        ExportAndPatch -Path "Southern Swamp\southern_swamp_cleared_room_0" -Offset "1F1E000" -Length "1B240" -NewLength "1B4F0" -TableOffset "1EC26"  -Values @("94", "F0")
        ExportAndPatch -Path "Southern Swamp\southern_swamp_cleared_room_2" -Offset "1F4D000" -Length "D0A0"  -NewLength "D1C0"  -TableOffset "1EC46"  -Values @("A1", "C0")
    }

    if (IsText -Elem $Options.LowHPBeep -Text "Softer Beep")     { ChangeBytes -Offset "B97E2A"  -Values @("48", "04") }
    if (IsText -Elem $Options.LowHPBeep -Text "Beep Disabled")   { ChangeBytes -Offset "B97E2A"  -Values @("00", "00") }

    if (IsChecked -Elem $Options.FixGohtCutscene)     { ChangeBytes -Offset "F6DE89" -Values @("8D", "00", "02", "10", "00", "00", "0A") }
    if (IsChecked -Elem $Options.FixMushroomBottle)   { ChangeBytes -Offset "CD7C48" -Values @("1E", "6B") }
    if (IsChecked -Elem $Options.FixFairyFountain)    { ChangeBytes -Offset "B9133E" -Values @("01", "0F") }
    if (IsChecked -Elem $Options.HideCredits)         { PatchBytes  -Offset "B3B000" -Patch "Message\Credits.bin" }

}



#==============================================================================================================================================================================================
function PatchByteReduxMajorasMask() {
    
    # D-PAD #

    if ( (IsChecked -Elem $Redux.DPadLayoutHide) -or (IsChecked -Elem $Redux.DPadLayoutLeft) -or (IsChecked -Elem $Redux.DPadLayoutRight) ) {
        $Array = @()
        $Array += GetItemIDMM -Item $Redux.DPadUp.Text
        $Array += GetItemIDMM -Item $Redux.DPadRight.Text
        $Array += GetItemIDMM -Item $Redux.DPadDown.Text
        $Array += GetItemIDMM -Item $Redux.DPadLeft.Text
        ChangeBytes -Offset "3806354" -Values $Array

        if (IsChecked -Elem $Redux.DPadLayoutLeft)        { ChangeBytes -Offset "3806364" -Values @("01", "01") }
        elseif (IsChecked -Elem $Redux.DPadLayoutRight)   { ChangeBytes -Offset "3806364" -Values @("01", "02") }
        else                                              { ChangeBytes -Offset "3806364" -Values "01" }
    }



    # GAMEPLAY

    if ( (IsChecked -Elem $Redux.EasierMinigames -Not) -and (IsChecked -Elem $Redux.FasterBlockPushing) )       { ChangeBytes -Offset "3806530" -Values @("9E", "45", "06", "2D", "57", "4B", "28", "62", "49", "87", "69", "FB", "0F", "79", "1B", "9F", "18", "30") }
    elseif ( (IsChecked -Elem $Redux.EasierMinigames) -and (IsChecked -Elem $Redux.FasterBlockPushing -Not) )   { ChangeBytes -Offset "3806530" -Values @("D2", "AD", "24", "8F", "0C", "58", "D0", "A8", "96", "55", "0E", "EE", "D2", "2B", "25", "EB", "08", "30") }
    elseif ( (IsChecked -Elem $Redux.EasierMinigames) -and (IsChecked -Elem $Redux.FasterBlockPushing) )        { ChangeBytes -Offset "3806530" -Values @("B7", "36", "99", "48", "85", "BF", "FF", "B1", "FB", "EB", "D8", "B1", "06", "C8", "A8", "3B", "18", "30") }

}


#==============================================================================================================================================================================================
function PatchBPSOptionsMajorasMask() {
    
    if (IsChecked -Elem $Options.ImprovedLinkModel) {
        ApplyPatch -File $GetROM.decomp -Patch "\Decompressed\improved_link_model.ppf"
    }

}



#==============================================================================================================================================================================================
function PatchLanguageOptionsMajorasMask() {
    
    if ( (IsChecked -Elem $Languages.TextRestore) -or (IsLanguage -Elem $Options.RazorSword) ) {
        $File = $GameFiles.binaries + "\" + "Message\Message Data Static MM.bin"
        ExportBytes -Offset "AD1000" -Length "699F0" -Output $File -Force
    }

    if (IsChecked -Elem $Languages.TextRestore) {
        ChangeBytes -Offset "1A6D6"  -Values @("AC", "A0")
        PatchBytes  -Offset "C5D0D8" -Patch "Message\Table.bin"
        ApplyPatch -File $File -Patch "\Data Extraction\Message\Message Data Static MM.bps" -FilesPath
        PatchBytes -Offset "A2DDC4" -Length "26F" -Texture -Patch "Icons\Troupe Leader's Mask Text.yaz0" # Correct Circus Mask
    }

    if (IsChecked -Elem $Languages.OcarinaIcons) {
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

    if (IsLanguage -Elem $Options.RazorSword) {
        $Offset = SearchBytes -File $File -Values @("54", "68", "69", "73", "20", "6E", "65", "77", "2C", "20", "73", "68", "61", "72", "70", "65", "72", "20", "62", "6C", "61", "64", "65")
        ChangeBytes -File $File -Offset ( Get24Bit -Value ( (GetDecimal -Hex $Offset) + (GetDecimal -Hex "38") ) ) -Values @("61", "73", "20", "6D", "75", "63", "68", "11", "79", "6F", "75", "20", "77", "61", "6E", "74", "20")

        $Offset = SearchBytes -File $File -Values @("54", "68", "65", "20", "4B", "6F", "6B", "69", "72", "69", "20", "53", "77", "6F", "72", "64", "20", "72", "65", "66", "6F", "72", "67", "65", "64")
        ChangeBytes -File $File -Offset ( Get24Bit -Value ( (GetDecimal -Hex $Offset) + (GetDecimal -Hex "30") ) ) -Values @("61", "73", "20", "6D", "75", "63", "68", "20", "79", "6F", "75", "20", "77", "61", "6E", "74", "2E", "20")

        $Offset = SearchBytes -File $File -Values @("4B", "65", "65", "70", "20", "69", "6E", "20", "6D", "69", "6E", "64", "20", "74", "68", "61", "74")
        PatchBytes  -File $File -Offset $Offset -Patch "Message\Razor Sword 1.bin"

        $Offset = SearchBytes -File $File -Values @("4E", "6F", "77", "20", "6B", "65", "65", "70", "20", "69", "6E", "20", "6D", "69", "6E", "64", "20", "74", "68", "61", "74")
        PatchBytes  -File $File -Offset $Offset -Patch "Message\Razor Sword 2.bin"
    }

    if ( (IsChecked -Elem $Languages.TextRestore) -or (IsLanguage -Elem $Options.RazorSword) ) {
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
function CreateMajorasMaskOptionsContent() {
    
    CreateOptionsDialog -Width 930 -Height 590
    $ToolTip = CreateTooltip



    # HERO MODE #
    $HeroModeBox                       = CreateReduxGroup -Y 50 -Height 1 -AddTo $Options.Panel -Text "Hero Mode"

    $Options.Damage                    = CreateReduxComboBox -Column 0 -Row 1 -AddTo $HeroModeBox -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage", "OHKO Mode") -Text "Damage:" -ToolTip $OptionsToolTip -Info "Set the amount of damage you receive`nOHKO Mode = You die in one hit" -Name "Damage"
    $Options.Recovery                  = CreateReduxComboBox -Column 2 -Row 1 -AddTo $HeroModeBox -Items @("1x Recovery", "1/2x Recovery", "1/4x Recovery", "0x Recovery") -Text "Recovery:" -ToolTip $OptionsToolTip -Info "Set the amount health you recovery from Recovery Hearts" -Name "Recovery"
    $Options.MagicUsage                = CreateReduxComboBox -Column 4 -Row 1 -AddTo $HeroModeBox -Items @("1x Magic Usage", "2x Magic Usage", "3x Magic Usage") -Text "Magic Usage:" -ToolTip $ToolTip -Info "Set the amount of times magic is consumed at" -Name "MagicUsage" -Length 110
    #$Options.BossHP                   = CreateReduxComboBox -Column 0 -Row 2 -AddTo $HeroModeBox -Items @("1x Boss HP", "2x Boss HP", "3x Boss HP") -Text "Boss HP:" -ToolTip $OptionsToolTip -Info "Set the amount of health for bosses" -Name "BossHP"



    # GRAPHICS #
    $GraphicsBox                       = CreateReduxGroup -Y ($HeroModeBox.Bottom + 5) -Height 2 -AddTo $Options.Panel -Text "Graphics / Sound"
    
    $Options.Widescreen                = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $GraphicsBox -Text "16:9 Widescreen"                                                       -ToolTip $ToolTip -Info "Native 16:9 Widescreen Display support with backgrounds and textures adjusted for widescreen`nThe aspect ratio fix is only applied when patching in Wii VC mode`nUse the Widescreen hack by GlideN64 instead if running on an N64 emulator`nTexture changes are always applied" -Name "Widescreen"
    $Options.BlackBars                 = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $GraphicsBox -Text "No Black Bars"                                                         -ToolTip $ToolTip -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes" -Name "BlackBars"
    $Options.ExtendedDraw              = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $GraphicsBox -Text "Extended Draw Distance"                                                -ToolTip $ToolTip -Info "Increases the game's draw distance for objects`nDoes not work on all objects" -Name "ExtendedDraw"
    $Options.PixelatedStars            = CreateReduxCheckBox -Column 3 -Row 1 -AddTo $GraphicsBox -Text "Disable Pixelated Stars"                                               -ToolTip $ToolTip -Info "Completely disable the stars at night-time, which are pixelated dots and do not have any textures for HD replacement" -Name "PixelatedStars"
    $Options.ImprovedLinkModel         = CreateReduxCheckBox -Column 4 -Row 1 -AddTo $GraphicsBox -Text "Improved Link Model"                                                   -ToolTip $ToolTip -Info "Improves the model used for Hylian Link" -Name "ImprovedLinkModel"
    $Options.LowHPBeep                 = CreateReduxComboBox -Column 0 -Row 2 -AddTo $GraphicsBox -Items @("Default Beep", "Softer Beep", "Beep Disabled") -Text "Low HP Beep:" -ToolTip $ToolTip -Info "Set the sound effect for the low HP beeping" -Name "LowHPBeep" -Length 100



    # COLORS #
    $ColorsBox                         = CreateReduxGroup -Y ($GraphicsBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Colors"
    $Options.EnableTunicColors         = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $ColorsBox -Text "Change Tunic Color"       -ToolTip $ToolTip -Info "Enable changing the color for the Hylian form Kokiri tunics" -Name "EnableTunicColors"
    $Options.KokiriTunicColor          = CreateReduxButton   -Column 1 -Row 1 -AddTo $ColorsBox -Text "Set Kokiri Tunic Color"   -ToolTip $ToolTip -Info "Select the color you want for the Kokiri Tunic"
    $Options.ResetAllColors            = CreateReduxButton   -Column 2 -Row 1 -AddTo $ColorsBox -Text "Reset Kokiri Tunic Color" -ToolTip $ToolTip -Info "Reset the  color for the Kokiri Tunic to it's default value"
    $Options.RecolorMaskForms          = CreateReduxCheckBox -Column 4 -Row 1 -AddTo $ColorsBox -Text "Recolor Mask Forms"       -ToolTip $ToolTip -Info "Recolor the clothing for Goron Link to appear in Red and Zora Link to appear in Blue" -Name "RecolorMaskForms"

    $Options.KokiriTunicColor.Add_Click( { $Options.SetKokiriTunicColor.ShowDialog(); $Settings[$GameType.mode][$Options.SetKokiriTunicColor.Tag] = $Options.SetKokiriTunicColor.Color.Name } )
    $Options.ResetAllColors.Add_Click( { $Settings[$GameType.mode][$Options.SetKokiriTunicColor.Tag] = $Options.SetKokiriTunicColor.Color.Name; $Options.SetKokiriTunicColor.Color = "#1E691B" } )



    # GAMEPLAY #
    $GameplayBox                       = CreateReduxGroup -Y ($ColorsBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Gameplay"

    $Options.ZoraPhysics               = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $GameplayBox -Text "Zora Physics"         -ToolTip $ToolTip -Info "Change the Zora physics when using the boomerang`nZora Link will take a step forward instead of staying on his spot" -Name "ZoraPhysics"
    $Options.RestorePalaceRoute        = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $GameplayBox -Text "Restore Palace Route" -ToolTip $ToolTip -Info "Restore the route to the Bean Seller within the Deku Palace as seen in the Japanese release" -Name "RestorePalaceRoute"
    $Options.DistantZTargeting         = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $GameplayBox -Text "Distant Z-Targeting"  -ToolTip $ToolTip -Info "Allow to use Z-Targeting on enemies, objects and NPC's from any distance" -Name "DistantZTargeting"



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
    
    $Options.RazorSword                = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $EquipmentBox -Text "Permanent Razor Sword" -ToolTip $ToolTip -Info "The Razor Sword won't get destroyed after 100 hits`nYou can also keep the Razor Sword when traveling back in time" -Name "RazorSword"

    $Options.Capacity                  = CreateReduxButton   -Column 1 -Row 1 -AddTo $EquipmentBox -Text "Set Capacity"          -ToolTip $ToolTip -Info "Select the capacity values you want for ammo and wallets"
    $Options.Capacity.Add_Click( { $Options.CapacityDialog.ShowDialog() } )



    # EVERYTHING ELSE #
    $OtherBox                          = CreateReduxGroup -Y ($EquipmentBox.Bottom + 5) -Height 1 -AddTo $Options.Panel -Text "Other"

    $Options.FixGohtCutscene           = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $OtherBox -Text "Fix Goht Cutscene"   -ToolTip $ToolTip -Info "Fix Goht's awakening cutscene so that Link no longer gets run over" -Name "FixGohtCutscene"
    $Options.FixMushroomBottle         = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $OtherBox -Text "Fix Mushroom Bottle" -ToolTip $ToolTip -Info "Fix the item reference when collecting Magical Mushrooms as Link puts away the bottle automatically due to an error" -Name "FixMushroomBottle"
    $Options.FixSouthernSwamp          = CreateReduxCheckBox -Column 2 -Row 1 -AddTo $OtherBox -Text "Fix Southern Swamp"  -ToolTip $ToolTip -Info "Fix a misplaced door after Woodfall has been cleared and you return to the Potion Shop`nThe door is slightly pushed forward after Odolwa has been defeated." -Name "FixSouthernSwamp"
    $Options.FixFairyFountain          = CreateReduxCheckBox -Column 3 -Row 1 -AddTo $OtherBox -Text "Fix Fairy Fountain"  -ToolTip $ToolTip -Info "Fix the Ikana Canyon Fairy Fountain area not displaying the correct color." -Name "FixFairyFountain"
    $Options.HideCredits               = CreateReduxCheckBox -Column 4 -Row 1 -AddTo $OtherBox -Text "Hide Credits"        -ToolTip $ToolTip -Info "Do not show the credits text during the credits sequence" -Name "HideCredits"



    CreateCapacityDialog
    
    $Options.Damage.Add_SelectedIndexChanged({ $Options.Recovery.Enabled = $this.Text -ne "OHKO Mode" })
    $Options.EnableTunicColors.Add_CheckStateChanged({ $Options.KokiriTunicColor.Enabled = $Options.ResetAllColors.Enabled = $this.Checked })

    $Options.Recovery.Enabled = $Options.Damage.Text -ne "OHKO Mode"
    $Options.KokiriTunicColor.Enabled = $Options.ResetAllColors.Enabled = $Options.EnableTunicColors.Checked

    $Options.SetKokiriTunicColor       = CreateColorDialog -Red "1E" -Green "69" -Blue "1B" -Name "SetKokiriTunicColor" -IsGame

}



#==============================================================================================================================================================================================
function CreateMajorasMaskReduxContent() {

    CreateReduxDialog -Width 700 -Height 290
    $ToolTip = CreateTooltip



    # D-PAD #
    $DPadBox                           = CreateReduxGroup -Y 50 -Height 2 -AddTo $Redux.Panel -Text "D-Pad Icons Layout"
    
    $DPadPanel                         = CreateReduxPanel -Row 0 -Columns 4 -AddTo $DPadBox
    $Redux.DPadDisable                 = CreateReduxRadioButton -Column 0 -Row 0 -AddTo $DPadPanel          -Text "Disable"    -ToolTip $ToolTip -Info "Completely disable the D-Pad"                      -Name "DPadDisable"
    $Redux.DPadLayoutHide              = CreateReduxRadioButton -Column 1 -Row 0 -AddTo $DPadPanel          -Text "Hidden"     -ToolTip $ToolTip -Info "Hide the D-Pad icons, while they are still active" -Name "DPadLayoutHide"
    $Redux.DPadLayoutLeft              = CreateReduxRadioButton -Column 2 -Row 0 -AddTo $DPadPanel          -Text "Left Side"  -ToolTip $ToolTip -Info "Show the D-Pad icons on the left side of the HUD"  -Name "DPadLayoutLeft"
    $Redux.DPadLayoutRight             = CreateReduxRadioButton -Column 3 -Row 0 -AddTo $DPadPanel -Checked -Text "Right Side" -ToolTip $ToolTip -Info "Show the D-Pad icons on the right side of the HUD" -Name "DPadLayoutRight"
    $Redux.DPadLayout                  = CreateReduxButton      -Column 0 -Row 2 -AddTo $DPadBox -Text "Customize D-Pad" -ToolTip $ToolTip -Info "Customize the D-Pad Layout"
    
    $Redux.DPadLayout.Add_Click( { $Redux.DPadDialog.ShowDialog() } )



    # GAMEPLAY #
    $GameplayBox                       = CreateReduxGroup -Y ($DPadBox.Bottom + 5) -Height 1 -AddTo $Redux.Panel -Text "Gameplay"

    $Redux.FasterBlockPushing          = CreateReduxCheckBox -Column 0 -Row 1 -AddTo $GameplayBox -Checked -Text "Faster Block Pushing" -ToolTip $ToolTip -Info "All blocks are pushed faster" -Name "FasterBlockPushing"
    $Redux.EasierMinigames             = CreateReduxCheckBox -Column 1 -Row 1 -AddTo $GameplayBox          -Text "Easier Minigames"     -ToolTip $ToolTip -Info "Certain minigames are made easier and faster`n- Dampe's Digging Game always has two Ghost Flames on the ground and one up the ladder`n- The Gold Dog always wins the Doggy Racetrack race if you have the Mask of Truth`nOnly one fish has to be feeded in the Marine Research Lab" -Name "EasierMinigames"
    


    CreateDPadDialog

    $Redux.DPadDisable.Add_CheckedChanged({ $Redux.DPadLayout.Enabled = !$this.checked })
    $Redux.DPadLayout.Enabled = !$Redux.DPadDisable.Checked

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

Export-ModuleMember -Function PatchOptionsMajorasMask
Export-ModuleMember -Function PatchByteOptionsMajorasMask
Export-ModuleMember -Function PatchByteReduxMajorasMask
Export-ModuleMember -Function PatchBPSOptionsMajorasMask
Export-ModuleMember -Function PatchLanguageOptionsMajorasMask

Export-ModuleMember -Function CreateMajorasMaskOptionsContent
Export-ModuleMember -Function CreateMajorasMaskReduxContent