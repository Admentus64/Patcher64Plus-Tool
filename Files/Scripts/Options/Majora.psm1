function PatchOptionsMajorasMask() {
    
    if (IsChecked -Elem $Redux.Graphics.ImprovedLinkModel) { ApplyPatch -File $GetROM.decomp -Patch "\Decompressed\improved_link_model.ppf" }

}



#==============================================================================================================================================================================================
function ByteOptionsMajorasMask() {
    
    # HERO MODE #

    if (IsText -Elem $Redux.Hero.Damage -Text "OHKO Mode") {
        ChangeBytes -Offset "BABE7F" -Values @("09", "04") -Interval 16
        ChangeBytes -Offset "BABEA2" -Values @("2A", "00")
        ChangeBytes -Offset "BABEA5" -Values @("00", "00", "00")
    }
    elseif ( (IsText -Elem $Redux.Hero.Damage -Text "1x Damage" -Not) -or (IsText -Elem $Redux.Hero.Recovery -Text "1x Recovery" -Not) ) {
        ChangeBytes -Offset "BABE7F" -Values @("09", "04") -Interval 16
        if (IsText -Elem $Redux.Hero.Recovery -Text "1x Recovery") {
            if     (IsText -Elem $Redux.Hero.Damage -Text "2x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("28", "40") }
            elseif (IsText -Elem $Redux.Hero.Damage -Text "4x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("28", "80") }
            elseif (IsText -Elem $Redux.Hero.Damage -Text "8x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("28", "C0") }
            ChangeBytes -Offset "BABEA5" -Values @("00", "00", "00")
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Text "1/2x Recovery") {
            if     (IsText -Elem $Redux.Hero.Damage -Text "1x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("28", "40") }
            elseif (IsText -Elem $Redux.Hero.Damage -Text "2x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("28", "80") }
            elseif (IsText -Elem $Redux.Hero.Damage -Text "4x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("28", "C0") }
            elseif (IsText -Elem $Redux.Hero.Damage -Text "8x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("29", "00") }
            ChangeBytes -Offset "BABEA5" -Values @("05", "28", "43")
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Text "1/4x Recovery") {
            if     (IsText -Elem $Redux.Hero.Damage -Text "1x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("28", "80") }
            elseif (IsText -Elem $Redux.Hero.Damage -Text "2x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("28", "C0") }
            elseif (IsText -Elem $Redux.Hero.Damage -Text "4x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("29", "00") }
            elseif (IsText -Elem $Redux.Hero.Damage -Text "8x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("29", "40") }
            ChangeBytes -Offset "BABEA5" -Values @("05", "28", "83")
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Text "0x Recovery") {
            if     (IsText -Elem $Redux.Hero.Damage -Text "1x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("29", "40") }
            elseif (IsText -Elem $Redux.Hero.Damage -Text "2x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("29", "80") }
            elseif (IsText -Elem $Redux.Hero.Damage -Text "4x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("29", "C0") }
            elseif (IsText -Elem $Redux.Hero.Damage -Text "8x Damage")   { ChangeBytes -Offset "BABEA2" -Values @("2A", "00") }
            ChangeBytes -Offset "BABEA5" -Values @("05", "29", "43")
        }
    }

    if     (IsText -Elem $Redux.Hero.MagicUsage -Text "2x Magic Usage")  { ChangeBytes -Offset "BAC306" -Values @("2C","40") }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Text "3x Magic Usage")  { ChangeBytes -Offset "BAC306" -Values @("2C","80") }



    # GRAPHICS #

    if (IsChecked -Elem $Redux.Graphics.WideScreen) {
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

    if (IsChecked -Elem $Redux.Graphics.ExtendedDraw)     { ChangeBytes -Offset "B50874" -Values @("00", "00", "00", "00") }
    if (IsChecked -Elem $Redux.Graphics.BlackBars)        { ChangeBytes -Offset "BF72A4" -Values @("00", "00", "00", "00") }
    if (IsChecked -Elem $Redux.Graphics.PixelatedStars)   { ChangeBytes -Offset "B943FC" -Values @("10", "00") }
    if (IsIndex   -Elem $Redux.Graphics.LowHP -Not)       { ChangeBytes -Offset "B97E2A"  -Values (GetSFXID -SFX $Redux.Graphics.LowHP.Text) }



    # COLORS #

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



    # GAMEPLAY
    
    if (IsChecked -Elem $Redux.Gameplay.PalaceRoute) {
        CreateSubPath -Path ($GameFiles.extracted + "\Deku Palace")
        ExportAndPatch -Path "Deku Palace\deku_palace_scene"  -Offset "2534000" -Length "D220"
        ExportAndPatch -Path "Deku Palace\deku_palace_room_0" -Offset "2542000" -Length "11A50"
        ExportAndPatch -Path "Deku Palace\deku_palace_room_1" -Offset "2554000" -Length "E950"  -NewLength "E9B0"  -TableOffset "1F6A7" -Values @("B0")
        ExportAndPatch -Path "Deku Palace\deku_palace_room_2" -Offset "2563000" -Length "124F0" -NewLength "124B0" -TableOffset "1F6B7" -Values @("B0")
    }

    if (IsChecked -Elem $Redux.Gameplay.ZoraPhysics)         { PatchBytes  -Offset "65D000" -Patch "Zora Physics Fix.bin" }
    if (IsChecked -Elem $Redux.Gameplay.DistantZTargeting)   { ChangeBytes -Offset "B4E924" -Values @("00", "00", "00", "00") }



    # RESTORE

    if (IsChecked -Elem $Redux.Restore.RomaniSign)   { PatchBytes  -Offset "26A58C0" -Texture -Patch "Romani Sign.bin" }
    if (IsChecked -Elem $Redux.Restore.Comma)        { ChangeBytes -Offset "ACC660"  -Values @("00", "F3", "00", "00", "00", "00", "00", "00", "4F", "60", "00", "00", "00", "00", "00", "00", "24") }
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

    if (IsChecked -Elem $Redux.Restore.ShopMusic)           { ChangeBytes -Offset "2678007" -Values @("44") }
    if (IsChecked -Elem $Redux.Restore.PieceOfHeartSound)   { ChangeBytes -Offset "BA94C8"  -Values @("10", "00") }
    if (IsChecked -Elem $Redux.Restore.MoveBomberKid)       { ChangeBytes -Offset "2DE4396" -Values @("02", "C5", "01", "18", "FB", "55", "00", "07", "2D") }



    # EQUIPMENT #

    if (IsChecked -Elem $Redux.Capacity.EnableAmmo) {
        ChangeBytes -Offset "C5834F" -IsDec -Values @($Redux.Capacity.Quiver1.Text,     $Redux.Capacity.Quiver2.Text,     $Redux.Capacity.Quiver3.Text)     -Interval 2
        ChangeBytes -Offset "C58357" -IsDec -Values @($Redux.Capacity.BombBag1.Text,    $Redux.Capacity.BombBag2.Text,    $Redux.Capacity.BombBag3.Text)    -Interval 2
        ChangeBytes -Offset "C5837F" -IsDec -Values @($Redux.Capacity.DekuSticks1.Text, $Redux.Capacity.DekuSticks1.Text, $Redux.Capacity.DekuSticks1.Text) -Interval 2
        ChangeBytes -Offset "C58387" -IsDec -Values @($Redux.Capacity.DekuNuts1.Text,   $Redux.Capacity.DekuNuts1.Text,   $Redux.Capacity.DekuNuts1.Text)   -Interval 2
    }

    if (IsChecked -Elem $Redux.Capacity.EnableWallet) {
        $Wallet1 = Get16Bit -Value ($Redux.Capacity.Wallet1.Text)
        $Wallet2 = Get16Bit -Value ($Redux.Capacity.Wallet2.Text)
        $Wallet3 = Get16Bit -Value ($Redux.Capacity.Wallet3.Text)
        ChangeBytes -Offset "C5836C" -Values @($Wallet1.Substring(0, 2), $Wallet1.Substring(2) )
        ChangeBytes -Offset "C5836E" -Values @($Wallet2.Substring(0, 2), $Wallet2.Substring(2) )
        ChangeBytes -Offset "C58370" -Values @($Wallet3.Substring(0, 2), $Wallet3.Substring(2) )
    }

    if (IsChecked -Elem $Redux.Gameplay.RazorSword) {
        ChangeBytes -Offset "CBA496" -Values @("00", "00") # Prevent losing hits
        ChangeBytes -Offset "BDA6B7" -Values @("01")       # Keep sword after Song of Time
    }



    # OTHER #
    
    if (IsChecked -Elem $Redux.Other.SouthernSwamp) {
        CreateSubPath -Path ($GameFiles.extracted + "\Southern Swamp")
        ExportAndPatch -Path "Southern Swamp\southern_swamp_cleared_scene"  -Offset "1F0D000" -Length "10630"
        ExportAndPatch -Path "Southern Swamp\southern_swamp_cleared_room_0" -Offset "1F1E000" -Length "1B240" -NewLength "1B4F0" -TableOffset "1EC26"  -Values @("94", "F0")
        ExportAndPatch -Path "Southern Swamp\southern_swamp_cleared_room_2" -Offset "1F4D000" -Length "D0A0"  -NewLength "D1C0"  -TableOffset "1EC46"  -Values @("A1", "C0")
    }


    if (IsChecked -Elem $Redux.Other.GohtCutscene)     { ChangeBytes -Offset "F6DE89" -Values @("8D", "00", "02", "10", "00", "00", "0A") }
    if (IsChecked -Elem $Redux.Other.MushroomBottle)   { ChangeBytes -Offset "CD7C48" -Values @("1E", "6B") }
    if (IsChecked -Elem $Redux.Other.FairyFountain)    { ChangeBytes -Offset "B9133E" -Values @("01", "0F") }
    if (IsChecked -Elem $Redux.Other.HideCredits)         { PatchBytes  -Offset "B3B000" -Patch "Message\Credits.bin" }

}



#==============================================================================================================================================================================================
function ByteReduxMajorasMask() {
    
    # D-PAD #

    if ( (IsChecked -Elem $Redux.DPad.Hide) -or (IsChecked -Elem $Redux.DPad.LayoutLeft) -or (IsChecked -Elem $Redux.DPad.LayoutRight) ) {
        $Array = @()
        $Array += GetItemID -Item $Redux.DPad.Up.Text
        $Array += GetItemID -Item $Redux.DPad.Right.Text
        $Array += GetItemID -Item $Redux.DPad.Down.Text
        $Array += GetItemID -Item $Redux.DPad.Left.Text
        ChangeBytes -Offset "3806354" -Values $Array

        if (IsChecked -Elem $Redux.DPad.LayoutLeft)        { ChangeBytes -Offset "3806364" -Values @("01", "01") }
        elseif (IsChecked -Elem $Redux.DPad.LayoutRight)   { ChangeBytes -Offset "3806364" -Values @("01", "02") }
        else                                               { ChangeBytes -Offset "3806364" -Values "01" }
    }



    # GAMEPLAY

    if     ( (IsChecked -Elem $Redux.Gameplay.EasierMinigames -Not) -and (IsChecked -Elem $Redux.Gameplay.FasterBlockPushing) )   { ChangeBytes -Offset "3806530" -Values @("9E", "45", "06", "2D", "57", "4B", "28", "62", "49", "87", "69", "FB", "0F", "79", "1B", "9F", "18", "30") }
    elseif ( (IsChecked -Elem $Redux.Gameplay.EasierMinigames) -and (IsChecked -Elem $Redux.Gameplay.FasterBlockPushing -Not) )   { ChangeBytes -Offset "3806530" -Values @("D2", "AD", "24", "8F", "0C", "58", "D0", "A8", "96", "55", "0E", "EE", "D2", "2B", "25", "EB", "08", "30") }
    elseif ( (IsChecked -Elem $Redux.Gameplay.EasierMinigames) -and (IsChecked -Elem $Redux.Gameplay.FasterBlockPushing) )        { ChangeBytes -Offset "3806530" -Values @("B7", "36", "99", "48", "85", "BF", "FF", "B1", "FB", "EB", "D8", "B1", "06", "C8", "A8", "3B", "18", "30") }

}



#==============================================================================================================================================================================================
function ByteLanguageMajorasMask() {
    
    if ( (IsChecked -Elem $Redux.Text.Restore) -or (IsLanguage -Elem $Redux.Gameplay.RazorSword) ) {
        $File = $GameFiles.extracted + "\Message Data Static MM.bin"
        ExportBytes -Offset "AD1000" -Length "699F0" -Output $File -Force
    }

    if (IsChecked -Elem $Redux.Text.Restore) {
        ChangeBytes -Offset "1A6D6"  -Values @("AC", "A0")
        PatchBytes  -Offset "C5D0D8" -Patch "Message\Table.bin"
        ApplyPatch -File $File -Patch "\Data Extraction\Message\Message Data Static MM.bps" -FilesPath
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
        ChangeBytes -File $File -Offset ( Get24Bit -Value ( (GetDecimal -Hex $Offset) + (GetDecimal -Hex "38") ) ) -Values @("61", "73", "20", "6D", "75", "63", "68", "11", "79", "6F", "75", "20", "77", "61", "6E", "74", "20")

        $Offset = SearchBytes -File $File -Values @("54", "68", "65", "20", "4B", "6F", "6B", "69", "72", "69", "20", "53", "77", "6F", "72", "64", "20", "72", "65", "66", "6F", "72", "67", "65", "64")
        ChangeBytes -File $File -Offset ( Get24Bit -Value ( (GetDecimal -Hex $Offset) + (GetDecimal -Hex "30") ) ) -Values @("61", "73", "20", "6D", "75", "63", "68", "20", "79", "6F", "75", "20", "77", "61", "6E", "74", "2E", "20")

        $Offset = SearchBytes -File $File -Values @("4B", "65", "65", "70", "20", "69", "6E", "20", "6D", "69", "6E", "64", "20", "74", "68", "61", "74")
        PatchBytes -File $File -Offset $Offset -Patch "Message\Razor Sword 1.bin"

        $Offset = SearchBytes -File $File -Values @("4E", "6F", "77", "20", "6B", "65", "65", "70", "20", "69", "6E", "20", "6D", "69", "6E", "64", "20", "74", "68", "61", "74")
        PatchBytes -File $File -Offset $Offset -Patch "Message\Razor Sword 2.bin"
    }

    if ( (IsChecked -Elem $Redux.Text.Restore) -or (IsLanguage -Elem $Redux.Gameplay.RazorSword) ) {
        PatchBytes -Offset "AD1000" -Patch "Message Data Static MM.bin" -Extracted
    }

}



#==============================================================================================================================================================================================
function GetItemID([String]$Item) {
    
    if     ($Item -like '*None*' -or $Item -like '*Disabled*')     { return "FF" }
    elseif ($Item -like '*Ocarina of Time*')   { return "00" }     elseif ($Item -like '*Deku Mask*')         { return "32" }     elseif ($Item -like '*Goron Mask*')        { return "33" }
    elseif ($Item -like '*Zora Mask*')         { return "34" }     elseif ($Item -eq "Fierce Deity's Mask")   { return "35" }
    else {
        if ($Settings.Debug.Console -eq $True) { Write-Host ("Could not find item ID for : " + $Item) }
        return -1
    }

}



#==============================================================================================================================================================================================
function CreateOptionsMajorasMask() {
    
    CreateOptionsDialog -Width 930 -Height 520 -Tabs @("Difficulty", "Colors", "Equipment")

    $Redux.Colors.EnableTunic.Add_CheckedChanged({
        $Redux.Graphics.ImprovedLinkModel.Enabled = !$this.checked
        $Redux.Colors.KokiriTunic.Enabled = $Redux.Colors.ResetAll.Enabled = $this.Checked
    })
    $Redux.Graphics.ImprovedLinkModel.Add_CheckedChanged({
        $Redux.Colors.EnableTunic.Enabled = !$this.checked
        $Redux.Colors.KokiriTunic.Enabled = $Redux.Colors.ResetAll.Enabled = !$this.checked -and $Redux.Colors.EnableTunic.Checked
    })
    $Redux.Colors.EnableTunic.Enabled = !$Redux.Graphics.ImprovedLinkModel.Checked
    $Redux.Graphics.ImprovedLinkModel.Enabled = !$Redux.Colors.EnableTunic.Checked
    $Redux.Colors.KokiriTunic.Enabled = $Redux.Colors.ResetAll.Enabled = !$Redux.Graphics.ImprovedLinkModel.Checked -and $Redux.Colors.EnableTunic.Checked

}



#==============================================================================================================================================================================================
function CreateTabMainMajorasMask() {

    # GRAPHICS #
    CreateReduxGroup    -Tag  "Graphics" -Text "Graphics / Sound" -Height 2
    CreateReduxCheckBox -Name "Widescreen"        -Column 1 -Row 1 -Text "16:9 Widescreen"                                           -Info "Native 16:9 Widescreen Display support with backgrounds and textures adjusted for widescreen`nThe aspect ratio fix is only applied when patching in Wii VC mode`nUse the Widescreen hack by GlideN64 instead if running on an N64 emulator`nTexture changes are always applied"
    CreateReduxCheckBox -Name "BlackBars"         -Column 2 -Row 1 -Text "No Black Bars"                                             -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes"
    CreateReduxCheckBox -Name "ExtendedDraw"      -Column 3 -Row 1 -Text "Extended Draw Distance"                                    -Info "Increases the game's draw distance for objects`nDoes not work on all objects"
    CreateReduxCheckBox -Name "PixelatedStars"    -Column 4 -Row 1 -Text "Disable Pixelated Stars"                                   -Info "Completely disable the stars at night-time, which are pixelated dots and do not have any textures for HD replacement"
    CreateReduxCheckBox -Name "ImprovedLinkModel" -Column 5 -Row 1 -Text "Improved Link Model"                                       -Info "Improves the model used for Hylian Link`nCustom tunic colors are not supported with this option"
    CreateReduxComboBox -Name "LowHP"             -Column 1 -Row 2 -Text "Low HP SFX:" -Items @("Default", "Disabled", "Soft Beep")  -Info "Set the sound effect for the low HP beeping" -Length 100

    # GAMEPLAY #
    CreateReduxGroup    -Tag  "Gameplay" -Text "Gameplay" 
    CreateReduxCheckBox -Name "ZoraPhysics"       -Column 1 -Text "Zora Physics"         -Info "Change the Zora physics when using the boomerang`nZora Link will take a step forward instead of staying on his spot"
    CreateReduxCheckBox -Name "PalaceRoute"       -Column 2 -Text "Restore Palace Route" -Info "Restore the route to the Bean Seller within the Deku Palace as seen in the Japanese release"
    CreateReduxCheckBox -Name "DistantZTargeting" -Column 3 -Text "Distant Z-Targeting"  -Info "Allow to use Z-Targeting on enemies, objects and NPC's from any distance"

    # RESTORE #
    CreateReduxGroup    -Tag  "Restore" -Text "Restore / Correct" -Height 2
    CreateReduxCheckBox -Name "RupeeColors"       -Column 1 -Row 1 -Text "Correct Rupee Colors"     -Info "Corrects the colors for the Purple (50) and Golden (200) Rupees"
    CreateReduxCheckBox -Name "CowNoseRing"       -Column 2 -Row 1 -Text "Restore Cow Nose Ring"    -Info "Restore the rings in the noses for Cows as seen in the Japanese release"
    CreateReduxCheckBox -Name "RomaniSign"        -Column 3 -Row 1 -Text "Correct Romani Sign"      -Info "Replace the Romani Sign texture to display Romani's Ranch instead of Kakariko Village"
    CreateReduxCheckBox -Name "CorrectComma"      -Column 4 -Row 1 -Text "Correct Comma"            -Info "Make the comma not look as awful"
    CreateReduxCheckBox -Name "Title"             -Column 5 -Row 1 -Text "Restore Title"            -Info "Restore the title logo colors as seen in the Japanese release"
    CreateReduxCheckBox -Name "SkullKid"          -Column 1 -Row 2 -Text "Restore Skull Kid"        -Info "Restore Skull Kid's face as seen in the Japanese release"
    CreateReduxCheckBox -Name "ShopMusic"         -Column 2 -Row 2 -Text "Restore Shop Music"       -Info "Restores the Shop music intro theme as heard in the Japanese release"
    CreateReduxCheckBox -Name "PieceOfHeartSound" -Column 3 -Row 2 -Text "4th Piece of Heart Sound" -Info "Restore the sound effect when collecting the fourth Piece of Heart that grants Link a new Heart Container"
    CreateReduxCheckBox -Name "MoveBomberKid"     -Column 4 -Row 2 -Text "Move Bomber Kid"          -Info "Moves the Bomber at the top of the Stock Pot Inn to be behind the bell like in the original Japanese ROM"

    # EVERYTHING ELSE #
    CreateReduxGroup    -Tag  "Other" -Text "Other"
    CreateReduxCheckBox -Name "GohtCutscene"   -Column 1 -Row 1 -Text "Fix Goht Cutscene"   -Info "Fix Goht's awakening cutscene so that Link no longer gets run over"
    CreateReduxCheckBox -Name "MushroomBottle" -Column 2 -Row 1 -Text "Fix Mushroom Bottle" -Info "Fix the item reference when collecting Magical Mushrooms as Link puts away the bottle automatically due to an error"
    CreateReduxCheckBox -Name "SouthernSwamp"  -Column 3 -Row 1 -Text "Fix Southern Swamp"  -Info "Fix a misplaced door after Woodfall has been cleared and you return to the Potion Shop`nThe door is slightly pushed forward after Odolwa has been defeated."
    CreateReduxCheckBox -Name "FairyFountain"  -Column 4 -Row 1 -Text "Fix Fairy Fountain"  -Info "Fix the Ikana Canyon Fairy Fountain area not displaying the correct color."
    CreateReduxCheckBox -Name "HideCredits"    -Column 5 -Row 1 -Text "Hide Credits"        -Info "Do not show the credits text during the credits sequence"

}



#==============================================================================================================================================================================================
function CreateTabReduxMajorasMask() {
    
    # GAMEPLAY #
    CreateReduxGroup        -Tag  "Gameplay" -Text "Gameplay"
    CreateReduxCheckBox     -Name "FasterBlockPushing" -Column 1 -Checked -Text "Faster Block Pushing" -Info "All blocks are pushed faster"
    CreateReduxCheckBox     -Name "EasierMinigames"    -Column 2          -Text "Easier Minigames"     -Info "Certain minigames are made easier and faster`n- Dampe's Digging Game always has two Ghost Flames on the ground and one up the ladder`n- The Gold Dog always wins the Doggy Racetrack race if you have the Mask of Truth`nOnly one fish has to be feeded in the Marine Research Lab"

    # D-PAD ICONS LAYOUT #
    CreateReduxGroup       -Tag  "DPad" -Text "D-Pad Icons Layout"
    CreateReduxPanel       -Columns 4
    CreateReduxRadioButton -Name "Disable"             -Column 1          -Text "Disable"              -Info "Completely disable the D-Pad"
    CreateReduxRadioButton -Name "Hide"                -Column 2          -Text "Hidden"               -Info "Hide the D-Pad icons, while they are still active"
    CreateReduxRadioButton -Name "LayoutLeft"          -Column 3          -Text "Left Side"            -Info "Show the D-Pad icons on the left side of the HUD"
    CreateReduxRadioButton -Name "LayoutRight"         -Column 4 -Checked -Text "Right Side"           -Info "Show the D-Pad icons on the right side of the HUD"

    # D-PAD BUTTONS CUSTOMIZATION #
    $Redux.Box.DPad = CreateReduxGroup -Tag "DPad" -Text "D-Pad Buttons Customization" -Height 7
    CreateReduxComboBox     -Name "Up"                 -Column 2 -Row 1 -Length 120 -Items @("Disabled", "Ocarina of Time", "Deku Mask", "Goron Mask", "Zora Mask", "Fierce Deity's Mask") -Default 2 -Info "Set the quick slot item for the D-Pad Up button"
    CreateReduxComboBox     -Name "Left"               -Column 1 -Row 4 -Length 120 -Items @("Disabled", "Ocarina of Time", "Deku Mask", "Goron Mask", "Zora Mask", "Fierce Deity's Mask") -Default 3 -Info "Set the quick slot item for the D-Pad Left button"
    CreateReduxComboBox     -Name "Right"              -Column 3 -Row 4 -Length 120 -Items @("Disabled", "Ocarina of Time", "Deku Mask", "Goron Mask", "Zora Mask", "Fierce Deity's Mask") -Default 4 -Info "Set the quick slot item for the D-Pad Right button"
    CreateReduxComboBox     -Name "Down"               -Column 2 -Row 7 -Length 120 -Items @("Disabled", "Ocarina of Time", "Deku Mask", "Goron Mask", "Zora Mask", "Fierce Deity's Mask") -Default 1 -Info "Set the quick slot item for the D-Pad Down button"
    
    # D-Pad Buttons Customization - Image #
    $PictureBox = New-Object Windows.Forms.PictureBox
    $PictureBox.Location = New-object System.Drawing.Size( ($Redux.DPad.Right.Left / 2 + 5), ($Redux.DPad.Down.Bottom / 4) )
    $PictureBox.Image  = [System.Drawing.Image]::Fromfile( ( Get-Item ($Paths.Main + "\D-Pad.png") ) )
    $PictureBox.Width  = $PictureBox.Image.Size.Width
    $PictureBox.Height = $PictureBox.Image.Size.Height
    $Redux.Box.DPad.controls.add($PictureBox)
    


    EnableForm -Form $Redux.Box.DPad -Enable $Redux.DPad.Disable.Checked -Not
    $Redux.DPad.Disable.Add_CheckedChanged({ EnableForm -Form $Redux.Box.DPad -Enable $Redux.DPad.Disable.Checked -Not })

}



#==============================================================================================================================================================================================
function CreateTabLanguageMajorasMask() {
    
    CreateLanguageContent -Columns 3

    # ENGLISH TEXT #    
    $Redux.Box.Text = CreateReduxGroup -Tag "Text" -Text "English Text"
    CreateReduxCheckBox -Name "Restore"      -Column 1 -Text "Restore Text"        -Info "Restores and fixes the following:`n- Restore the area titles cards for those that do not have any`n- Sound effects that do not play during dialogue`n- Grammar and typo fixes"
    CreateReduxCheckBox -Name "OcarinaIcons" -Column 2 -Text "Ocarina Icons (WIP)" -Info "Restore the Ocarina Icons with their text when transformed like in the N64 Beta or 3DS version (Work-In-Progress)`nRequires the Restore Text option"
    


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
function CreateTabDifficultyMajorasMask() {
    
    # HERO MODE #
    CreateReduxGroup    -Tag  "Hero" -Text "Hero Mode"
    CreateReduxComboBox -Name "Damage"     -Column 1 -Row 1 -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage", "OHKO Mode") -Text "Damage:" -ToolTip $OptionsToolTip -Info "Set the amount of damage you receive`nOHKO Mode = You die in one hit"
    CreateReduxComboBox -Name "Recovery"   -Column 3 -Row 1 -Items @("1x Recovery", "1/2x Recovery", "1/4x Recovery", "0x Recovery") -Text "Recovery:" -ToolTip $OptionsToolTip -Info "Set the amount health you recovery from Recovery Hearts"
    CreateReduxComboBox -Name "MagicUsage" -Column 5 -Row 1 -Items @("1x Magic Usage", "2x Magic Usage", "3x Magic Usage") -Text "Magic Usage:" -Info "Set the amount of times magic is consumed at" -Length 110
    # CreateReduxComboBox -Name "BossHP"   -Column 0 -Row 2 -Items @("1x Boss HP", "2x Boss HP", "3x Boss HP") -Text "Boss HP:" -ToolTip $OptionsToolTip -Info "Set the amount of health for bosses"



    $Redux.Hero.Damage.Add_SelectedIndexChanged({ $Redux.Hero.Recovery.Enabled = $this.Text -ne "OHKO Mode" })
    $Redux.Hero.Recovery.Enabled = $Redux.Hero.Damage.Text -ne "OHKO Mode"

}



#==============================================================================================================================================================================================
function CreateTabColorsMajorasMask() {
    
    # COLORS #
    CreateReduxGroup -Tag "Colors" -Text "Colors"
    CreateReduxCheckBox  -Name "EnableTunic" -Column 1 -Text "Change Tunic Color"       -Info ("Enable changing the color for the Hylian form Kokiri tunics`nRequires the " + '"Improved Link Model"' + " option to be disabled")
    $Redux.Colors.KokiriTunic = CreateReduxButton -Column 2 -Text "Kokiri Tunic" -Width 100  -Info "Select the color you want for the Kokiri Tunic"
    $Redux.Colors.ResetAll    = CreateReduxButton -Column 3 -Text "Reset Kokiri Tunic Color" -Info "Reset the  color for the Kokiri Tunic to it's default value"
    CreateReduxCheckBox  -Name "MaskForms"   -Column 5 -Text "Recolor Mask Forms"       -Info "Recolor the clothing for Goron Link to appear in Red and Zora Link to appear in Blue"

    $Redux.Colors.SetKokiriTunic   = CreateColorDialog -Name "SetKokiriTunic" -Color "1E691B" -IsGame
    $Redux.Colors.KokiriTunicLabel = CreateReduxColoredLabel -Link $Redux.Colors.KokiriTunic -Color $Redux.Colors.SetKokiriTunic.Color



    $Redux.Colors.KokiriTunic.Add_Click( { $Redux.Colors.SetKokiriTunic.ShowDialog(); $Redux.Colors.KokiriTunicLabel.BackColor = $Redux.Colors.SetKokiriTunic.Color; $Settings[$GameType.mode][$Redux.Colors.SetKokiriTunic.Tag] = $Redux.Colors.SetKokiriTunic.Color.Name } )
    $Redux.Colors.ResetAll.Add_Click(    { $Redux.Colors.KokiriTunicLabel.BackColor = $Redux.Colors.SetKokiriTunic.Color = "#1E691B"; $Settings[$GameType.mode][$Redux.Colors.SetKokiriTunic.Tag] = $Redux.Colors.SetKokiriTunic.Color.Name } )

}



#==============================================================================================================================================================================================
function CreateTabEquipmentMajorasMask() {
    
    # CAPACITY SELECTION #
    CreateReduxGroup    -Tag  "Capacity" -Text "Capacity Selection"
    CreateReduxCheckBox -Name "EnableAmmo"   -Column 1 -Text "Change Ammo Capacity"   -Info "Enable changing the capacity values for ammo"
    CreateReduxCheckBox -Name "EnableWallet" -Column 2 -Text "Change Wallet Capacity" -Info "Enable changing the capacity values for the wallets"

    # AMMO #
    $Redux.Box.Ammo = CreateReduxGroup -Tag "Capacity" -Text "Ammo Capacity Selection" -Height 2
    CreateReduxTextBox -Name "Quiver1"     -Column 1 -Row 1           -Text "Quiver (1)"      -Value 30  -Info "Set the capacity for the Quiver (Base)`nDefault = 30"
    CreateReduxTextBox -Name "Quiver2"     -Column 2 -Row 1           -Text "Quiver (2)"      -Value 40  -Info "Set the capacity for the Quiver (Upgrade 1)`nDefault = 40"
    CreateReduxTextBox -Name "Quiver3"     -Column 3 -Row 1           -Text "Quiver (3)"      -Value 50  -Info "Set the capacity for the Quiver (Upgrade 2)`nDefault = 50"      
    CreateReduxTextBox -Name "BombBag1"    -Column 1 -Row 2           -Text "Bomb Bag (1)"    -Value 20  -Info "Set the capacity for the Bomb Bag (Base)`nDefault = 20"         
    CreateReduxTextBox -Name "BombBag2"    -Column 2 -Row 2           -Text "Bomb Bag (2)"    -Value 30  -Info "Set the capacity for the Bomb Bag (Upgrade 1)`nDefault = 30"
    CreateReduxTextBox -Name "BombBag3"    -Column 2 -Row 2           -Text "Bomb Bag (3)"    -Value 40  -Info "Set the capacity for the Bomb Bag (Upgrade 2)`nDefault = 40"
    CreateReduxTextBox -Name "DekuSticks1" -Column 4 -Row 1           -Text "Deku Sticks (1)" -Value 10  -Info "Set the capacity for the Deku Sticks (Base)`nDefault = 10"
    CreateReduxTextBox -Name "DekuNuts1"   -Column 4 -Row 2           -Text "Deku Nuts (1)"   -Value 20  -Info "Set the capacity for the Deku Nuts (Base)`nDefault = 20"

    # WALLET #
    $Redux.Box.Wallet = CreateReduxGroup -Tag "Capacity" -Text "Wallet Capacity Selection"
    CreateReduxTextBox -Name "Wallet1"     -Column 1 -Row 1 -Length 3 -Text "Wallet (1)"      -Value 99  -Info "Set the capacity for the Wallet (Base)`nDefault = 99"
    CreateReduxTextBox -Name "Wallet2"     -Column 2 -Row 1 -Length 3 -Text "Wallet (2)"      -Value 200 -Info "Set the capacity for the Wallet (Upgrade 1)`nDefault = 200"
    CreateReduxTextBox -Name "Wallet3"     -Column 3 -Row 1 -Length 3 -Text "Wallet (3)"      -Value 500 -Info "Set the capacity for the Wallet (Upgrade 2)`nDefault = 500"

    # EQUIPMENT #
    CreateReduxGroup -Tag "Gameplay" -Text "Equipment"
    CreateReduxCheckBox -Name "RazorSword" -Text "Permanent Razor Sword" -Info "The Razor Sword won't get destroyed after 100 hits`nYou can also keep the Razor Sword when traveling back in time"



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

Export-ModuleMember -Function PatchOptionsMajorasMask
Export-ModuleMember -Function ByteOptionsReduxMajorasMask
Export-ModuleMember -Function ByteReduxMajorasMask
Export-ModuleMember -Function ByteLanguageMajorasMask

Export-ModuleMember -Function CreateOptionsMajorasMask
Export-ModuleMember -Function CreateTabMainMajorasMask
Export-ModuleMember -Function CreateTabReduxMajorasMask
Export-ModuleMember -Function CreateTabLanguageMajorasMask
Export-ModuleMember -Function CreateTabDifficultyMajorasMask
Export-ModuleMember -Function CreateTabColorsMajorasMask
Export-ModuleMember -Function CreateTabEquipmentMajorasMask