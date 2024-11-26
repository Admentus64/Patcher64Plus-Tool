function ByteOptions() {
    
    if (IsChecked $Redux.Gameplay.NoKillFlash)              { ChangeBytes -Offset "B35573"  -Values "00" }
    if (IsChecked $Redux.Gameplay.InstantClaimCheck)        { ChangeBytes -Offset "1EB327C" -Values "00000000"; ChangeBytes -Offset "1EB32A4"  -Values "00000000" }
    if (IsChecked $Redux.Gameplay.BlackBars)                { ChangeBytes -Offset "B2ABEC"  -Values "00000000" }
    if (IsChecked $Redux.Gameplay.TextSpeed)                { ChangeBytes -Offset "B80AAB"  -Values "02" }
    
    # SOUNDS / VOICES #

    if (IsDefault -Elem $Redux.Sounds.ChildVoices -Not) {
        $file = "Voices Child\" + $Redux.Sounds.ChildVoices.Text.replace(" (default)", "") + ".bin"
        if (TestFile ($GameFiles.binaries + "\" + $file)) { PatchBytes -Offset "1FB000" -Patch $file }
    }
    if (IsDefault -Elem $Redux.Sounds.AdultVoices -Not) {
        $file = "Voices Adult\" + $Redux.Sounds.AdultVoices.Text.replace(" (default)", "") + ".bin"
        if (TestFile ($GameFiles.binaries + "\" + $file)) { PatchBytes -Offset "1A95E0" -Patch $file }
    }

    # SFX SOUND EFFECTS #

    if (IsIndex -Elem $Redux.Sounds.LowHP      -Not)   { ChangeBytes -Offset "AF0E0E" -Values (GetSFXID $Redux.SFX.LowHP.Text) }    

    # HERO MODE #

    if (IsIndex -Elem $Redux.Hero.MonsterHP -Index 3 -Not) { # Monsters
        if (IsIndex -Elem $Redux.Hero.MonsterHP) { $multi = 0 } else { [float]$multi = [float]$Redux.Hero.MonsterHP.text.split('x')[0] }

        MultiplyBytes -Offset @("1D349DF", "1BE1167")         -Factor $multi -Max 127 # Like-Like, Peehat, 
        MultiplyBytes -Offset @("1D038CB", "1D4D03B")         -Factor $multi -Max 127 # Shell Blade, Spike Ball
        MultiplyBytes -Offset @("1C141AC", "1C5EFFC")         -Factor $multi -Max 127 # Biri, Bari
        MultiplyBytes -Offset @("1C8E667", "1BBC7C4")         -Factor $multi -Max 127 # ReDead/Gibdo, Regular/Composer Poe
        MultiplyBytes -Offset @("1C19353", "1C0611B")         -Factor $multi -Max 127 # Torch Slug, Gohma Larva
        MultiplyBytes -Offset @("1C66327", "1C677FB")         -Factor $multi -Max 127 # Blue Bubble, Red Bubble
        MultiplyBytes -Offset   "1C14777"                     -Factor $multi -Max 127 # Tailpasaran
        MultiplyBytes -Offset   "1C1E0AC"                     -Factor $multi -Max 127 # Stinger
        MultiplyBytes -Offset @("1BDC69B", "1BDC70F")         -Factor $multi -Max 127 # Red Tektite, Blue Tektite
        MultiplyBytes -Offset @("1BC337C", "1C8CB8C")         -Factor $multi -Max 127 # Wallmaster, Floormaster
        MultiplyBytes -Offset @("1BDF4E7", "1BDF57B")         -Factor $multi -Max 127 # Leever, Purple Leever
        MultiplyBytes -Offset @("1C7D103", "1C7D107")         -Factor $multi -Max 127 # Big & Regular Beamos
        MultiplyBytes -Offset   "1BC3C1F"                     -Factor $multi -Max 127 # Dodongo
        MultiplyBytes -Offset   "1C9DC64"                     -Factor $multi -Max 127 # Regular/Gold Walltula
        MultiplyBytes -Offset   "1C18D8C"                     -Factor $multi -Max 127 # Skulltula
    }

    if (IsIndex -Elem $Redux.Hero.MiniBossHP -Index 3 -Not) { # Mini-Bosses
        if (IsIndex -Elem $Redux.Hero.MiniBossHP) { $multi = 0 } else { [float]$multi = [float]$Redux.Hero.MiniBossHP.text.split('x')[0] }

        MultiplyBytes -Offset @("1BA74E3", "1CC26FB", "1C9566C") -Factor $multi -Max 127 # Stalfos, Dead Hand, Poe Sisters
        MultiplyBytes -Offset @("1BEBE2F", "1BEBE3B")          -Factor $multi -Max 127 # Lizalfos, Dinolfos
        MultiplyBytes -Offset   "1EB7083"                      -Factor $multi -Max 127 # Wolfos
        MultiplyBytes -Offset   "1E9A14F"                      -Factor $multi -Max 127 # Gerudo Fighter
        MultiplyBytes -Offset   "1CAABE7"                      -Factor $multi -Max 127 # Flare Dancer

        if ($multi -eq 255 -and !$multiply) { ChangeBytes -Offset "1DC9677" -Values "FF" ChangeBytes -Offset "1DCAC07" -Values "7F"; ChangeBytes -Offset "1DCABDB" -Values "7F" }
        elseif ($multi -gt 0) {
            MultiplyBytes -Offset "1DC9677" -Factor $multi                                             
            $value = $ByteArrayGame[(GetDecimal "1DCAC07")]; $value--; $value *= $multi; $value++;
            ChangeBytes -Offset "1DCAC07" -Values $value; ChangeBytes -Offset "1DCABDB" -Values $value 
        }
        else { ChangeBytes -Offset "1DC9677" -Values "01"; ChangeBytes -Offset "1DCAC07" -Values "01"; ChangeBytes -Offset "1DCABDB" -Values "01" }
    }
    
    if (IsIndex -Elem $Redux.Hero.BossHP -Index 3 -Not) { # Bosses
        if (IsIndex -Elem $Redux.Hero.BossHP) { $multi = 0 } else { [float]$multi = [float]$Redux.Hero.BossHP.text.split('x')[0] }

        MultiplyBytes -Offset   "1BF9057"             -Factor $multi -Max 127  # Gohma
        MultiplyBytes -Offset @("1CE1163", "1CE13AF") -Factor $multi -Max 127  # Barinade
        MultiplyBytes -Offset @("1D24A23", "1D21D93") -Factor $multi -Max 127  # Twinrova
        MultiplyBytes -Offset   "1BF4F5B"             -Factor $multi -Max 127  # King Dodongo
        MultiplyBytes -Offset   "1C9E957"             -Factor $multi -Max 127  # Volvagia
        MultiplyBytes -Offset   "1CF7F8F"             -Factor $multi -Max 127  # Morpha
        MultiplyBytes -Offset   "1D4BBA4"             -Factor $multi -Max 127  # Bongo Bongo
        MultiplyBytes -Offset   "1C454B3"             -Factor $multi -Max 127 -Min 4 # Phantom Ganon
        MultiplyBytes -Offset   "1E6A57B"             -Factor $multi -Max 127 -Min 3 # Ganon
    }
    
    if     (IsText -Elem $Redux.Hero.Damage     -Compare "2x Damage")        { ChangeBytes -Offset "1B7DFEA" -Values "2BC3" }
    elseif (IsText -Elem $Redux.Hero.Damage     -Compare "4x Damage")        { ChangeBytes -Offset "1B7DFEA" -Values "2B83" }
    elseif (IsText -Elem $Redux.Hero.Damage     -Compare "8x Damage")        { ChangeBytes -Offset "1B7DFEA" -Values "2B43" }
    elseif (IsText -Elem $Redux.Hero.Damage     -Compare "OHKO Mode")        { ChangeBytes -Offset "1B7DFEA" -Values "2A03" }

    if   (IsChecked $Redux.Hero.NoBottledFairy)        { ChangeBytes -Offset "1B9A7F4"  -Values "00000000" }
    
    if (IsChecked $Redux.HeroHarder.IronKnuckle) {
        ChangeBytes -Offset "1DCA64E" -Values "0001"; ChangeBytes -Offset "1DCA48E" -Values "0820"; ChangeBytes -Offset "1DCA47A" -Values "10B0"; ChangeBytes -Offset "1DCC98C" -Values "40808080"; ChangeBytes -Offset "1DCC990" -Values "40A0" }
    if (IsChecked $Redux.HeroHarder.GohmaLarva)      { ChangeBytes -Offset "1C06A66" -Values "0000"; ChangeBytes -Offset "1C06EC2" -Values "0000"; ChangeBytes -Offset "1C07016" -Values "0006"; ChangeBytes -Offset "1C07202" -Values "40E0"; ChangeBytes -Offset "1C07286" -Values "4170"; ChangeBytes -Offset "1C073CA" -Values "4100" }
    if (IsChecked $Redux.HeroHarder.Keese)           { ChangeBytes -Offset "1BC6403" -Values "00"; ChangeBytes -Offset "1BC67EE" -Values "0000"; ChangeBytes -Offset "1BC67DE" -Values "4110"; ChangeBytes -Offset "1BC6FB2" -Values "4500"; ChangeBytes -Offset "1BC7186" -Values "4150" }
    if (IsChecked $Redux.HeroHarder.Wolfos)          { ChangeBytes -Offset "1EB88CE" -Values "0000"; ChangeBytes -Offset "1EB8C8E" -Values "D000"; ChangeBytes -Offset "1EBADFF" -Values "00" }
    if (IsChecked $Redux.HeroHarder.Lizards)         { ChangeBytes -Offset @("1BEC6E3", "1BEC707") -Values "00"; ChangeBytes -Offset @("1BEE3FA", "1BEE41E") -Values "4000"; ChangeBytes -Offset "1BEE72E" -Values "D000" }
    if (IsChecked $Redux.HeroHarder.DarkLink)        { ChangeBytes -Offset "1C0FD9F" -Values "FF" }
    if (IsChecked $Redux.HeroHarder.DeadHand)        { ChangeBytes -Offset "1CC2CA2" -Values "4080"; ChangeBytes -Offset "1CC2CAE" -Values "0029"; ChangeBytes -Offset "1CC2E22" -Values "000E"; ChangeBytes -Offset "1CC2D0A" -Values "12FA" }
    if (IsChecked $Redux.HeroHarder.Gohma)           { ChangeBytes -Offset "1BF96CA" -Values "0016"; ChangeBytes -Offset "1BFC3E6" -Values "0030"; ChangeBytes -Offset "1BFD46E" -Values "0020"; ChangeBytes -Offset "1BFD48E" -Values "000C" }
    if (IsChecked $Redux.HeroHarder.KingDodongo)     { ChangeBytes -Offset "1BF59EE" -Values "0024"; ChangeBytes -Offset "1BF2C4A" -Values "0000"
    }
    
    # RECOVERY #

    if (IsDefault $Redux.Recovery.Heart       -Not)   { ChangeBytes -Offset   "AFD14E"             -Values (Get16Bit $Redux.Recovery.Heart.Text)       }
    if (IsDefault $Redux.Recovery.Fairy       -Not)   { ChangeBytes -Offset   "1BD5ACA"            -Values (Get16Bit $Redux.Recovery.Fairy.Text)       }
    if (IsDefault $Redux.Recovery.FairyBottle -Not)   { ChangeBytes -Offset   "1B85466"            -Values (Get16Bit $Redux.Recovery.FairyBottle.Text) }
    if (IsDefault $Redux.Recovery.FairyRevive -Not)   { ChangeBytes -Offset @("1B8F31E", "1B8F2CE")-Values (Get16Bit $Redux.Recovery.FairyRevive.Text) }
    if (IsDefault $Redux.Recovery.Milk        -Not)   { ChangeBytes -Offset   "1B8502A"            -Values (Get16Bit $Redux.Recovery.Milk.Text)        }
    if (IsDefault $Redux.Recovery.RedPotion   -Not)   { ChangeBytes -Offset   "1B84FFE"            -Values (Get16Bit $Redux.Recovery.RedPotion.Text)   }

    # MAGIC #

    if (IsDefault $Redux.Magic.FireArrow   -Not)   { ChangeBytes -Offset "1B9B864" -Values (Get8Bit $Redux.Magic.FireArrow.Text)   }
    if (IsDefault $Redux.Magic.IceArrow    -Not)   { ChangeBytes -Offset "1B9B865" -Values (Get8Bit $Redux.Magic.IceArrow.Text)    }
    if (IsDefault $Redux.Magic.LightArrow  -Not)   { ChangeBytes -Offset "1B9B866" -Values (Get8Bit $Redux.Magic.LightArrow.Text)  }    

    # EQUIPMENT COLORS #

    if ($Redux.Colors.SetEquipment -ne $null) {
        if (IsColor $Redux.Colors.SetEquipment[0] -Not) { ChangeBytes -Offset "B9D1A8" -Values @($Redux.Colors.SetEquipment[0].Color.R, $Redux.Colors.SetEquipment[0].Color.G, $Redux.Colors.SetEquipment[0].Color.B) } # Kokiri Tunic
        if (IsColor $Redux.Colors.SetEquipment[1] -Not) { ChangeBytes -Offset "B9D1AB"  -Values @($Redux.Colors.SetEquipment[1].Color.R, $Redux.Colors.SetEquipment[1].Color.G, $Redux.Colors.SetEquipment[1].Color.B) } # Goron Tunic
        if (IsColor $Redux.Colors.SetEquipment[2] -Not) { ChangeBytes -Offset "B9D1AE"  -Values @($Redux.Colors.SetEquipment[2].Color.R, $Redux.Colors.SetEquipment[2].Color.G, $Redux.Colors.SetEquipment[2].Color.B) } # Zora Tunic

        if (IsColor $Redux.Colors.SetEquipment[3] -Not)   { ChangeBytes -Offset "B9D1B4" -Values @($Redux.Colors.SetEquipment[3].Color.R, $Redux.Colors.SetEquipment[3].Color.G, $Redux.Colors.SetEquipment[3].Color.B) } # Silver Gauntlets
        if (IsColor $Redux.Colors.SetEquipment[4] -Not)   { ChangeBytes -Offset "B9D1B7" -Values @($Redux.Colors.SetEquipment[4].Color.R, $Redux.Colors.SetEquipment[4].Color.G, $Redux.Colors.SetEquipment[4].Color.B) } # Golden Gauntlets
    }

    # SWORD TRAIL EFFECTS #

    if ($Redux.Colors.SetSwordTrail -ne $null) {
        if (IsColor $Redux.Colors.SetSwordTrail[0]   -Not)            { ChangeBytes -Offset "1B9A97C" -Values @($Redux.Colors.SetSwordTrail[0].Color.R, $Redux.Colors.SetSwordTrail[0].Color.G, $Redux.Colors.SetSwordTrail[0].Color.B) }
        if (IsColor $Redux.Colors.SetSwordTrail[1]   -Not)            { ChangeBytes -Offset "1B9A984" -Values @($Redux.Colors.SetSwordTrail[1].Color.R, $Redux.Colors.SetSwordTrail[1].Color.G, $Redux.Colors.SetSwordTrail[1].Color.B) }
        if (IsIndex $Redux.Colors.SwordTrailDuration -Not -Index 2)   { ChangeBytes -Offset "1B9A98C" -Values (($Redux.Colors.SwordTrailDuration.SelectedIndex) * 5) }
    }
       
    # HITBOX #

    if (IsDefault $Redux.Equipment.SwordHealth -Not) {
        $value =  (Get8Bit $Redux.Equipment.SwordHealth.Text)
        ChangeBytes -Offset "AFC1AB" -Values $value
    }

    if (IsDefault $Redux.Hitbox.KokiriSword       -Not)   { ChangeBytes -Offset "B9D288"  -Values (ConvertFloatToHex $Redux.Hitbox.KokiriSword.Value)       }
    if (IsDefault $Redux.Hitbox.MasterSword       -Not)   { ChangeBytes -Offset "B9D284"  -Values (ConvertFloatToHex $Redux.Hitbox.MasterSword.Value)       }
    if (IsDefault $Redux.Hitbox.GiantsKnife       -Not)   { ChangeBytes -Offset "B9D28C"  -Values (ConvertFloatToHex $Redux.Hitbox.GiantsKnife.Value)       }
    if (IsDefault $Redux.Hitbox.Hookshot          -Not)   { ChangeBytes -Offset "1C61773" -Values (Get8Bit $Redux.Hitbox.Hookshot.Value)                    }
    if (IsDefault $Redux.Hitbox.Longshot          -Not)   { ChangeBytes -Offset "1C6175F" -Values (Get8Bit $Redux.Hitbox.Longshot.Value)                    }
}
#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsPanel -Tabs @("Main", "Audio", "Difficulty", "Colors", "Equipment")
    ChangeModelsSelection
}
#==============================================================================================================================================================================================
function CreateTabMain() {

    # QUALITY OF LIFE #
    
    CreateReduxGroup    -Tag  "Gameplay"    -Text "Quality of Life & Adjustments" 
    CreateReduxCheckBox -Name "NoKillFlash" -Text "No Kill Flash" -Info "Disable the flashing effect when killing certain enemies like walltula etc" -Credits "Chez Cousteau (original) & Anthrogi (debug gc mq (pal))"
    CreateReduxCheckBox -Name "InstantClaimCheck" -Text "Instant Claim Check" -Info "Allows you to use the claim check immediately to get the biggoron's sword" -Credits "Randomizer (original) & Anthrogi (debug gc mq (pal))"
    CreateReduxCheckBox -Name "BlackBars" -Text "No Black Bars (Z-Targeting)" -Info "Removes the black bars shown on the top & bottom of the screen during Z-targeting" -Credits "Admentus (original) & Anthrogi (debug gc mq (pal))"
    CreateReduxCheckBox -Name "TextSpeed" -Text "2x Text Speed" -Info "Makes text go 2x as fast" -Credits "Admentus (original) & Anthrogi (debug gc mq (pal))"
}
#==============================================================================================================================================================================================
function CreateTabAudio() {
    
    # SOUNDS / VOICES #

    CreateReduxGroup    -Tag  "Sounds"             -Text "Sounds / Voices (Does Not Work Currently)"
    CreateReduxComboBox -Name "ChildVoices" -Child -Text "Child Voice" -Default "Original" -Items @("Original") -FilePath ($GameFiles.binaries + "\Voices Child")   -Info "Replace the voice used for the Child Link Model"        -Credits "`nMajora's Mask: Korey Cryderman (ported) & GhostlyDark (corrected)`nMelee Zelda: Mickey Saeed & theluigidude2007 (edits)`nAmara: Amara (ripping) & theluigidude2007 (edits)"
    CreateReduxComboBox -Name "AdultVoices" -Adult -Text "Adult Voice" -Default "Original" -Items @("Original") -FilePath ($GameFiles.binaries + "\Voices Adult")   -Info "Replace the voice used for the Adult Link Model"        -Credits "`nMajora's Mask: Korey Cryderman (ported) & GhostlyDark (corrected)`nMelee Zelda: Mickey Saeed & theluigidude2007 (edits)`nAmara: Amara (ripping) & theluigidude2007`nPeach: theluigidude2007"

    # SFX SOUND EFFECTS #

    $SFX1 = @("Default", "Disabled", "Soft Beep", "Bark", "Bomb Bounce", "Bongo Bongo Low", "Bow Twang", "Business Scrub", "Carrot Refill", "Cluck", "Great Fairy", "Drawbridge Set", "Guay", "Horse Trot", "HP Recover", "Iron Boots", "Moo", "Mweep!", 'Navi "Hey!"', "Navi Random", "Notification", "Pot Shattering", "Ribbit", "Rupee (Silver)", "Switch", "Sword Bonk", "Tambourine", "Timer", "Zelda Gasp (Adult)")
    $SFX2 = @("Default",  "Disabled", "Soft Beep", "Bark", "Business Scrub", "Carrot Refill", "Cluck", "Cockadoodledoo", "Dusk Howl", "Exploding Crate", "Explosion", "Great Fairy", "Guay", "Horse Neigh", "HP Low", "HP Recover", "Ice Shattering", "Moo", "Meweep!", 'Navi "Hello!"', "Notification", "Pot Shattering", "Redead Scream", "Ribbit", "Ruto Giggle", "Skulltula", "Tambourine", "Timer", "Zelda Gasp (Adult)")
    $SFX3 = @("Default", "Disabled", "Soft Beep", "Bark", "Bomb Bounce", "Bongo Bongo High", "Bongo Bongo Low", "Bottle Cork", "Bow Twang", "Bubble Laugh", "Carrot Refill", "Change Item", "Child Pant", "Cluck", "Deku Baba", "Drawbridge Set", "Dusk Howl", "Fanfare (Light)", "Fanfare (Medium)", "Field Shrub", "Flare Dancer Startled",
    'Ganondorf "Teh"', "Gohma Larva Croak", "Gold Skull Token", "Goron Wake", "Guay", "Gunshot", "Hammer Bonk", "Horse Trot", "HP Low", "HP Recover", "Iron Boots", "Iron Knuckle", "Moo", "Mweep!", "Notification", "Phantom Ganon Laugh", "Plant Explode", "Pot Shattering", "Redead Moan", "Ribbit", "Rupee", "Rupee (Silver)", "Ruto Crash",
    "Ruto Lift", "Ruto Thrown", "Scrub Emerge", "Shabom Bounce", "Shabom Pop", "Shellblade", "Skulltula", "Spit Nut", "Switch", "Sword Bonk", 'Talon "Hmm"', "Talon Snore", "Talon WTF", "Tambourine", "Target Enemy", "Target Neutral", "Thunder", "Timer", "Zelda Gasp (Adult)")
    
    CreateReduxComboBox -Name "LowHP" -Text "Low HP" -Items $SFX1 -Info "Set the sound effect for the low HP beeping" -Credits "Randomizer (original) & Anthrogi (debug gc mq (pal))"
}
#==============================================================================================================================================================================================
function CreateTabDifficulty() {

    # HERO MODE #

    $items1 = @("1 Monster HP","0.5x Monster HP", "1x Monster HP", "1.5x Monster HP", "2x Monster HP", "2.5x Monster HP", "3x Monster HP", "3.5x Monster HP", "4x Monster HP", "5x Monster HP")
    $items2 = @("1 Mini-Boss HP", "0.5x Mini-Boss HP", "1x Mini-Boss HP", "1.5x Mini-Boss HP", "2x Mini-Boss HP", "2.5x Mini-Boss HP", "3x Mini-Boss HP", "3.5x Mini-Boss HP", "4x Mini-Boss HP", "5x Mini-Boss HP")
    $items3 = @("1 Boss HP", "0.5x Boss HP", "1x Boss HP", "1.5x Boss HP", "2x Boss HP", "2.5x Boss HP", "3x Boss HP", "3.5x Boss HP", "4x Boss HP", "5x Boss HP")

    CreateReduxGroup    -Tag  "Hero"       -Text "Hero Mode"
    CreateReduxComboBox -Name "MonsterHP"  -Text "Monster HP"   -Items $items1 -Default 3 -Info "Set the amount of health for monsters`nDoesn't include monsters which die in 1 hit or do not work with increased hp" -Credits "Admentus (original & formula) & Anthrogi (debug gc mq (pal))"
    CreateReduxComboBox -Name "MiniBossHP" -Text "Mini-Boss HP" -Items $items2 -Default 3 -Info "Set the amount of health for mini-bosses`nSome enemies are not included" -Credits "Admentus (original & formula) & Anthrogi (debug gc mq (pal))"
    CreateReduxComboBox -Name "BossHP"     -Text "Boss HP"      -Items $items3 -Default 3 -Info "Set the amount of health for bosses`nPhantom Ganon, Ganondorf and Ganon have a max of 3x HP"          -Credits "Admentus, Marcelo20XX (original & formula) & Anthrogi (debug gc mq (pal))"
    CreateReduxComboBox -Name "Damage"     -Text "Damage"       -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage", "OHKO Mode") -Info "Set the amount of damage you receive`nOHKO Mode = You die in one hit" -Credits "Admentus (original) & Anthrogi (debug gc mq (pal))"

    CreateReduxCheckBox -Name "NoBottledFairy" -Text "No Bottled Fairies"  -Info "Fairies can no longer be put into a bottle" -Credits "Admentus (original) & Anthrogi (debug gc mq (pal))"

    CreateReduxGroup    -Tag  "HeroHarder"   -Text "Hero Mode (Harder Enemies)"
    CreateReduxCheckBox -Name "GohmaLarva"   -Text "Harder Gohma Larva"    -Info "Gohma Larvas are faster and reach further" -Credits "Euler (original) & Anthrogi (debug gc mq (pal))"
    CreateReduxCheckBox -Name "Keese"        -Text "Harder Keese"          -Info "Keese attack faster and move further, as well as not lose their fire when impacting the player" -Credits "Euler (original) & Anthrogi (debug gc mq (pal))"
    CreateReduxCheckBox -Name "Wolfos"       -Text "Harder Wolfos"         -Info "Wolfos will attack faster and do not falter from having attacks blocked`nThey also attack when z-targeting another enemy" -Credits "BilonFullHDemon (original) & Anthrogi (debug gc mq (pal))"
    CreateReduxCheckBox -Name "Lizards"      -Text "Harder Lizards"        -Info "Lizalfos & Dinolfos will attack faster and do not falter from having attacks blocked`nThey also attack when z-targeting another enemy" -Credits "Nokaubure, Euler (original) & Anthrogi (debug gc mq (pal))"
    CreateReduxCheckBox -Name "DeadHand"     -Text "Harder Dead Hand"      -Info "Dead Hands are faster and do not stay risen for long" -Credits "Euler (original) & Anthrogi (debug gc mq (pal))"
    CreateReduxCheckBox -Name "DarkLink"     -Text "Harder Dark Link"      -Info "Dark Link starts attacking you right away after spawning" -Credits "Nokaubure, BilonFullHDemon (original) & Anthrogi (debug gc mq (pal))"
    CreateReduxCheckBox -Name "IronKnuckle"  -Text "Harder Iron Knuckle"   -Info "Iron Knuckles now move faster and may use back swing more likely" -Credits "Admentus (original) & Anthrogi (debug gc mq (pal))"
    CreateReduxCheckBox -Name "Gohma"        -Text "Harder Gohma"          -Info "Gohma recovers faster from being stunned" -Credits "Euler (original) & Anthrogi (debug gc mq (pal))"
    CreateReduxCheckBox -Name "KingDodongo"  -Text "Harder King Dodongo"   -Info "King Dodongo inhales faster and is no longer stunned" -Credits "Euler (original) & Anthrogi (debug gc mq (pal))"
        
    # RECOVERY #

    CreateReduxGroup   -Tag  "Recovery"    -Text "Recovery" -Height 4
    CreateReduxTextBox -Name "Heart"       -Text "Recovery Heart" -Value 16  -Min 0 -Max 320 -Length 3 -Info "Set the amount of HP that Recovery Hearts will replenish" -Credits "Admentus, Three Pendants (original) & Anthrogi (debug gc mq (pal))"
    CreateReduxTextBox -Name "Fairy"       -Text "Fairy"          -Value 128 -Min 0 -Max 320 -Length 3 -Info "Set the amount of HP that a Fairy will replenish"                                                       -Credits "Admentus (original) & Anthrogi (debug gc mq (pal))"
    CreateReduxTextBox -Name "FairyBottle" -Text "Fairy (Bottle)" -Value 320 -Min 0 -Max 320 -Length 3 -Info "Set the amount of HP that a Bottled Fairy will replenish"                                               -Credits "Admentus, Three Pendants & Anthrogi (debug gc mq (pal))"
    CreateReduxTextBox -Name "FairyRevive" -Text "Fairy (Revive)" -Value 320 -Min 0 -Max 320 -Length 3 -Info "Set the amount of HP that a Bottled Fairy will replenish after Link died"                               -Credits "Admentus, Three Pendants & Anthrogi (debug gc mq (pal))"; $Last.Row++
    CreateReduxTextBox -Name "Milk"        -Text "Milk"           -Value 80  -Min 0 -Max 320 -Length 3 -Info "Set the amount of HP that Milk will replenish"                                                          -Credits "Admentus, Three Pendants & Anthrogi (debug gc mq (pal))"
    CreateReduxTextBox -Name "RedPotion"   -Text "Red Potion"     -Value 320 -Min 0 -Max 320 -Length 3 -Info "Set the amount of HP that a Red Potion will replenish"                                                  -Credits "Admentus, Three Pendants (original) & Anthrogi (debug gc mq (pal))"

    $Redux.Recovery.HeartLabel       = CreateLabel -X $Redux.Recovery.Heart.Left       -Y ($Redux.Recovery.Heart.Bottom       + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.Heart.text/16,       1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.FairyLabel       = CreateLabel -X $Redux.Recovery.Fairy.Left       -Y ($Redux.Recovery.Fairy.Bottom       + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.Fairy.text/16,       1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.FairyBottleLabel = CreateLabel -X $Redux.Recovery.FairyBottle.Left -Y ($Redux.Recovery.FairyBottle.Bottom + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.FairyBottle.text/16, 1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.FairyReviveLabel = CreateLabel -X $Redux.Recovery.FairyRevive.Left -Y ($Redux.Recovery.FairyRevive.Bottom + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.FairyRevive.text/16, 1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.MilkLabel        = CreateLabel -X $Redux.Recovery.Milk.Left        -Y ($Redux.Recovery.Milk.Bottom        + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.Milk.text/16,        1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.RedPotionLabel   = CreateLabel -X $Redux.Recovery.RedPotion.Left   -Y ($Redux.Recovery.RedPotion.Bottom   + (DPISize 6)) -Text ("(" + [math]::Round($Redux.Recovery.RedPotion.text/16,   1) + " Hearts)") -AddTo $Last.Group
    $Redux.Recovery.Heart.Add_TextChanged(       { if ($this.text -eq "16") { $Redux.Recovery.HeartLabel.Text       = "(1 Heart)" } else { $Redux.Recovery.HeartLabel.Text       = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )
    $Redux.Recovery.Fairy.Add_TextChanged(       { if ($this.text -eq "16") { $Redux.Recovery.FairyLabel.Text       = "(1 Heart)" } else { $Redux.Recovery.FairyLabel.Text       = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )
    $Redux.Recovery.FairyBottle.Add_TextChanged( { if ($this.text -eq "16") { $Redux.Recovery.FairyBottleLabel.Text = "(1 Heart)" } else { $Redux.Recovery.FairyBottleLabel.Text = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )
    $Redux.Recovery.FairyRevive.Add_TextChanged( { if ($this.text -eq "16") { $Redux.Recovery.FairyReviveLabel.Text = "(1 Heart)" } else { $Redux.Recovery.FairyReviveLabel.Text = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )
    $Redux.Recovery.Milk.Add_TextChanged(        { if ($this.text -eq "16") { $Redux.Recovery.MilkLabel.Text        = "(1 Heart)" } else { $Redux.Recovery.MilkLabel.Text        = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )
    $Redux.Recovery.RedPotion.Add_TextChanged(   { if ($this.text -eq "16") { $Redux.Recovery.RedPotionLabel.Text   = "(1 Heart)" } else { $Redux.Recovery.RedPotionLabel.Text   = "(" + [math]::Round($this.text/16, 1) + " Hearts)" } } )

    # MAGIC #

    CreateReduxGroup   -Tag  "Magic"       -Text "Magic Costs"
    CreateReduxTextBox -Name "FireArrow"   -Text "Fire Arrow"    -Value 4  -Max 96 -Info "Set the magic cost for using Fire Arrows´n48 is the maximum amount of the standard magic meter´n96 is the maximum amount of the double magic meter"   -Credits "Admentus (original) & Anthrogi (debug gc mq (pal))"
    CreateReduxTextBox -Name "IceArrow"    -Text "Ice Arrow"     -Value 4  -Max 96 -Info "Set the magic cost for using Ice Arrows´n48 is the maximum amount of the standard magic meter´n96 is the maximum amount of the double magic meter"    -Credits "Admentus (original) & Anthrogi (debug gc mq (pal))"
    CreateReduxTextBox -Name "LightArrow"  -Text "Light Arrow"   -Value 8  -Max 96 -Info "Set the magic cost for using Light Arrows´n48 is the maximum amount of the standard magic meter´n96 is the maximum amount of the double magic meter"  -Credits "Admentus (original) & Anthrogi (debug gc mq (pal))"
}
#==============================================================================================================================================================================================
function CreateTabColors() {
    
    # EQUIPMENT COLORS #

    CreateReduxGroup -Tag "Colors" -Text "Equipment Colors"
    $Redux.Colors.Equipment = @(); $Buttons = @(); $Redux.Colors.SetEquipment = @()
    $items1 = @("Kokiri Green", "Goron Red", "Zora Blue"); $postItems = @("Randomized", "Custom"); $Files = ($GameFiles.Textures + "\Tunic"); $Randomize = '"Randomized" fully randomizes the colors each time the patcher is opened'
    $Items2 = @("Silver", "Gold", "Black", "Green", "Blue", "Bronze", "Red", "Sky Blue", "Pink", "Magenta", "Orange", "Lime", "Purple", "Randomized", "Custom")
    $Items3 = @("Red", "Green", "Blue", "Yellow", "Cyan", "Magenta", "Orange", "Gold", "Purple", "Pink", "Randomized", "Custom")
    
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "KokiriTunic"          -Text "Kokiri Tunic"        -Default 1 -Length 230 -Items $items1 -PostItems $postItems -FilePath $Files -Info ("Select a color scheme for the Kokiri Tunic`n" + $Randomize) -Credits "Randomizer"
    $Buttons += CreateReduxButton -Tag $Buttons.Count        -Text "Kokiri Tunic"     -Info "Select the color you want for the Kokiri Tunic" -Credits "Randomizer"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "GoronTunic"           -Text "Goron Tunic"         -Default 2 -Length 230 -Items $items1 -PostItems $postItems -FilePath $Files -Info ("Select a color scheme for the Goron Tunic`n"  + $Randomize) -Credits "Randomizer"
    $Buttons += CreateReduxButton -Tag $Buttons.Count        -Text "Goron Tunic"      -Info "Select the color you want for the Goron Tunic"  -Credits "Randomizer"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "ZoraTunic"            -Text "Zora Tunic"          -Default 3 -Length 230 -Items $items1 -PostItems $postItems -FilePath $Files -Info ("Select a color scheme for the Zora Tunic`n"   + $Randomize) -Credits "Randomizer"
    $Buttons += CreateReduxButton -Tag $Buttons.Count        -Text "Zora Tunic"       -Info "Select the color you want for the Zora Tunic"   -Credits "Randomizer"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "SilverGauntlets"      -Text "Silver Gauntlets"    -Default 1 -Length 230 -Items $Items2 -Info ("Select a color scheme for the Silver Gauntlets`n" + $Randomize) -Credits "Randomizer"
    $Buttons += CreateReduxButton -Tag $Buttons.Count -Adult -Text "Silver Gaunlets"  -Info "Select the color you want for the Silver Gauntlets"           -Credits "Randomizer"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "GoldenGauntlets"      -Text "Golden Gauntlets"    -Default 2 -Length 230 -Items $Items2 -Info ("Select a color scheme for the Golden Gauntlets`n" + $Randomize) -Credits "Randomizer"
    $Buttons += CreateReduxButton -Tag $Buttons.Count -Adult -Text "Golden Gauntlets" -Info "Select the color you want for the Golden Gauntlets"           -Credits "Randomizer"
    
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "1E691B" -Name "SetKokiriTunic" -IsGame -Button $Buttons[0]
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "641400" -Name "SetGoronTunic"  -IsGame -Button $Buttons[1]
    $Redux.Colors.SetEquipment += CreateColorDialog -Color "003C64" -Name "SetZoraTunic"   -IsGame -Button $Buttons[2]
    if ($Redux.Colors.SilverGauntlets -ne $null) {
        $Redux.Colors.SetEquipment += CreateColorDialog -Color "FFFFFF" -Name "SetSilverGauntlets"   -IsGame -Button $Buttons[3]
        $Redux.Colors.SetEquipment += CreateColorDialog -Color "FECF0F" -Name "SetGoldenGauntlets"   -IsGame -Button $Buttons[4]
    }

    $Redux.Colors.EquipmentLabels = @()
    for ($i=0; $i -lt $Buttons.length; $i++) {
        if ($Buttons[$i] -eq $null) { break }
        $Buttons[$i].Add_Click({ $Redux.Colors.SetEquipment[[uint16]$this.Tag].ShowDialog(); $Redux.Colors.Equipment[[uint16]$this.Tag].Text = "Custom"; $Redux.Colors.EquipmentLabels[[uint16]$this.Tag].BackColor = $Redux.Colors.SetEquipment[[uint16]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetEquipment[[uint16]$this.Tag].Tag] = $Redux.Colors.SetEquipment[[uint16]$this.Tag].Color.Name })
        if ($i -lt 3)   { $Redux.Colors.EquipmentLabels += CreateReduxColoredLabel        -Link $Buttons[$i] -Color $Redux.Colors.SetEquipment[$i].Color }
        else            { $Redux.Colors.EquipmentLabels += CreateReduxColoredLabel        -Link $Buttons[$i] -Color $Redux.Colors.SetEquipment[$i].Color }
    }

    $Redux.Colors.Equipment[0].Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[0] -Dialog $Redux.Colors.SetEquipment[0] -Label $Redux.Colors.EquipmentLabels[0] })
    SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[0] -Dialog $Redux.Colors.SetEquipment[0] -Label $Redux.Colors.EquipmentLabels[0]
    $Redux.Colors.Equipment[1].Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[1] -Dialog $Redux.Colors.SetEquipment[1] -Label $Redux.Colors.EquipmentLabels[1] })
    SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[1] -Dialog $Redux.Colors.SetEquipment[1] -Label $Redux.Colors.EquipmentLabels[1]
    $Redux.Colors.Equipment[2].Add_SelectedIndexChanged({ SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[2] -Dialog $Redux.Colors.SetEquipment[2] -Label $Redux.Colors.EquipmentLabels[2] })
    SetTunicColorsPreset -ComboBox $Redux.Colors.Equipment[2] -Dialog $Redux.Colors.SetEquipment[2] -Label $Redux.Colors.EquipmentLabels[2]

    if ($Redux.Colors.SilverGauntlets -ne $null) {
        $Redux.Colors.Equipment[3].Add_SelectedIndexChanged({ SetGauntletsColorsPreset         -ComboBox $Redux.Colors.Equipment[3] -Dialog $Redux.Colors.SetEquipment[3] -Label $Redux.Colors.EquipmentLabels[3] })
        SetGauntletsColorsPreset         -ComboBox $Redux.Colors.Equipment[3] -Dialog $Redux.Colors.SetEquipment[3] -Label $Redux.Colors.EquipmentLabels[3]
        $Redux.Colors.Equipment[4].Add_SelectedIndexChanged({ SetGauntletsColorsPreset         -ComboBox $Redux.Colors.Equipment[4] -Dialog $Redux.Colors.SetEquipment[4] -Label $Redux.Colors.EquipmentLabels[4] })
        SetGauntletsColorsPreset         -ComboBox $Redux.Colors.Equipment[4] -Dialog $Redux.Colors.SetEquipment[4] -Label $Redux.Colors.EquipmentLabels[4]
    }

    # COLORS #
    CreateSwordTrailColorOptions -Duration
}
#==============================================================================================================================================================================================
function CreateTabEquipment() {
    
    # EQUIPMENT #

    CreateReduxGroup -Tag  "Hitbox" -Height 4.5 -Text "Equipment Adjustments"
    CreateReduxTextBox -Name "SwordHealth" -Text "Sword Durability" -Length 3 -Info "Set the amount of hits the Giant's Knife can take before it breaks" -Value 8 -Min 1 -Max 255 -Credits "Admentus (original) & Anthrogi (debug gc mq (pal))" 
    CreateReduxSlider -Name "KokiriSword" -Column 3 -Default 3000 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Kokiri Sword" -Info "Set the length of the hitbox of the Kokiri Sword" -Credits "Admentus (original) & Anthrogi (debug gc mq (pal))"
    CreateReduxSlider -Name "MasterSword" -Default 4000 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Master Sword" -Info "Set the length of the hitbox of the Master Sword" -Credits "Admentus (original) & Anthrogi (debug gc mq (pal))"
    CreateReduxSlider -Name "GiantsKnife" -Default 5500 -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512 -Text "Two-Handed Sword" -Info "Set the length of the hitbox of the Giant's_Knife/Biggoron_Sword" -Credits "Admentus (original) & Anthrogi (debug gc mq (pal))"
    CreateReduxSlider -Name "Hookshot" -Default 13  -Min 0   -Max 110  -Freq 10  -Small 5   -Large 10  -Text "Hookshot Length" -Info "Set the length of the Hookshot" -Credits "Admentus (original) & Anthrogi (debug gc mq (pal))" -Warning "Going above the default length by a certain amount can look weird"
    CreateReduxSlider -Name "Longshot" -Default 104 -Min 0   -Max 110  -Freq 10  -Small 5   -Large 10  -Text "Longshot Length" -Info "Set the length of the Longshot" -Credits "Admentus (original) & Anthrogi (debug gc mq (pal))" -Warning "Going above the default length by a certain amount can look weird"
}
