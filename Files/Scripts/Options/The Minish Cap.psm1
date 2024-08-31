function PatchOptions() {
    
    # VANILLA #

    if (IsChecked $Patches.Redux -Not) {

        if (IsChecked $Redux.Main.USBackportFixes) { ApplyPatch -Patch "Compressed\Optional\us_backport_fixes.ips" }

    }

}



#==============================================================================================================================================================================================
function ByteOptions() {
    
    if (IsChecked $Patches.Redux -Not) {
        
        # VANILLA #

        if     (IsDefault -Elem $Redux.Vanilla.DamageTaken -Not)                     { ChangeBytes -Offset "178BC" -Values "0078"; ChangeBytes -Offset "178C0" -Values "0348B23000782F2804D0302808D00AE0" }
        if     (IsText    -Elem $Redux.Vanilla.DamageTaken -Compare "2x Damage")     { ChangeBytes -Offset "178BE" -Values "4100" }
        elseif (IsText    -Elem $Redux.Vanilla.DamageTaken -Compare "4x Damage")     { ChangeBytes -Offset "178BE" -Values "8100" }
        elseif (IsText    -Elem $Redux.Vanilla.DamageTaken -Compare "8x Damage")     { ChangeBytes -Offset "178BE" -Values "C100" }
        elseif (IsText    -Elem $Redux.Vanilla.DamageTaken -Compare "16x Damage")    { ChangeBytes -Offset "178BE" -Values "0101" }
        elseif (IsText    -Elem $Redux.Vanilla.DamageTaken -Compare "OHKO Mode")     { ChangeBytes -Offset "178BE" -Values "8202" }

        if     (IsDefault -Elem $Redux.Vanilla.DamageDealt -Not)                     { ChangeBytes -Offset "17902" -Values "0078"; ChangeBytes -Offset "17906" -Values "107A082810D10348B2300078302804D0312808D008E0" }
        if     (IsText    -Elem $Redux.Vanilla.DamageDealt -Compare "1/2x Damage")   { ChangeBytes -Offset "17904" -Values "4108" }
        elseif (IsText    -Elem $Redux.Vanilla.DamageDealt -Compare "1/4x Damage")   { ChangeBytes -Offset "17904" -Values "8108" }
        elseif (IsText    -Elem $Redux.Vanilla.DamageDealt -Compare "1/8x Damage")   { ChangeBytes -Offset "17904" -Values "C108" }

        if (IsChecked $Redux.Vanilla.NoRecoveryHearts) {
            $offsets = @()
            for ($i=0; $i -le 55; $i++) { $offsets += Get32Bit (0x13C4 + 0x8 + $i * 0x20) }
            ChangeBytes -Offset $offsets -Values "19FC" #; ChangeBytes -Offset "FD6FC" -Values "54"
        }

        if (IsChecked $Redux.Vanilla.EasierFigurines) {
            ChangeBytes -Offset "87DC6" -Values "2C"; ChangeBytes -Offset "87DCA" -Values "2D"; ChangeBytes -Offset "87DDC" -Values "23"; ChangeBytes -Offset "87DE0" -Values "24"
            ChangeBytes -Offset "87DEC" -Values "1A"; ChangeBytes -Offset "87DF0" -Values "1B"; ChangeBytes -Offset "87DF8" -Values "11"; ChangeBytes -Offset "87DFC" -Values "12"
        }

        if (IsChecked $Redux.Vanilla.BiggoronTimer) { ChangeBytes -Offset "53098" -Values "034804494018E1214900016070470000402A00029404" }



        # GAMEPLAY #

        if (IsChecked $Redux.Gameplay.KinstoneBoost) {
            $offsets = @()
            for ($i=0; $i -le 55; $i++) {
                $offset = 0x13C4 + 0x14 + ($i * 0x20)
                $value  = $ByteArrayGame[$offset] + $ByteArrayGame[$offset+1] * 0x100
                if ($value -gt 0x8000) { $value -= 0x10000 }
                if ($value -gt 0) { $offsets += Get16Bit $offset }

            }
            for ($i=0; $i -le 55; $i++) {
                $offset = 0x13C4 + 0x16 + ($i * 0x20)
                $value  = $ByteArrayGame[$offset] + $ByteArrayGame[$offset+1] * 0x100
                if ($value -gt 0x8000) { $value -= 0x10000 }
                if ($value -gt 0) { $offsets += Get16Bit $offset }

            }
            for ($i=0; $i -le 55; $i++) {
                $offset = 0x13C4 + 0x18 + ($i * 0x20)
                $value  = $ByteArrayGame[$offset] + $ByteArrayGame[$offset+1] * 0x100
                if ($value -gt 0x8000) { $value -= 0x10000 }
                if ($value -gt 0) { $offsets += Get16Bit $offset }

            }
            ChangeBytes -Offset $offsets -Values "05" -Add
        }

        
        if (IsChecked $Redux.Gameplay.MusicHouse)      { ChangeBytes -Offset "63342" -Values "09" }
        if (IsChecked $Redux.Gameplay.RedRupeeLike)    { ChangeBytes -Offset "CC36E" -Values "F6" }



        # INTERFACE #

        if (IsChecked $Redux.Interface.SwapButtons) { ChangeBytes -Offset @("1C442", "128288") -Values "B8"; ChangeBytes -Offset @("1C446", "12828B") -Values "D0" }



        # AUDIO #

        if (IsChecked $Redux.Audio.Voices)      { PatchBytes  -Offset   "C61216"                   -Patch "tww_voices.bin" }
        if (IsChecked $Redux.Audio.LowHealth)   { ChangeBytes -Offset @("17132", "17136", "1713C") -Values "00"            }

    }



    elseif (IsChecked $Patches.Redux) {
        
        # GAMEPLAY #

        if (IsChecked $Redux.Gameplay.KinstoneBoost) {
            $offsets = @()
            for ($i=0; $i -le 55; $i++) {
                $offset = 0x137C + 0x14 + ($i * 0x20)
                $value  = $ByteArrayGame[$offset] + $ByteArrayGame[$offset+1] * 0x100
                if ($value -gt 0x8000) { $value -= 0x10000 }
                if ($value -gt 0) { $offsets += Get16Bit $offset }

            }
            for ($i=0; $i -le 55; $i++) {
                $offset = 0x137C + 0x16 + ($i * 0x20)
                $value  = $ByteArrayGame[$offset] + $ByteArrayGame[$offset+1] * 0x100
                if ($value -gt 0x8000) { $value -= 0x10000 }
                if ($value -gt 0) { $offsets += Get16Bit $offset }

            }
            for ($i=0; $i -le 55; $i++) {
                $offset = 0x137C + 0x18 + ($i * 0x20)
                $value  = $ByteArrayGame[$offset] + $ByteArrayGame[$offset+1] * 0x100
                if ($value -gt 0x8000) { $value -= 0x10000 }
                if ($value -gt 0) { $offsets += Get16Bit $offset }

            }
            ChangeBytes -Offset $offsets -Values "05" -Add
        }

      
        if (IsChecked $Redux.Gameplay.MusicHouse)      { ChangeBytes -Offset "63B9E" -Values "09" }
        if (IsChecked $Redux.Gameplay.RedRupeeLike)    { ChangeBytes -Offset "CD20E" -Values "F6" }



        # INTERFACE #

        if (IsChecked $Redux.Interface.SwapButtons) { ChangeBytes -Offset @("1C486", "129280") -Values "B8"; ChangeBytes -Offset @("1C48A", "129283") -Values "D0" }



        # AUDIO #

        if (IsChecked $Redux.Audio.Voices)      { PatchBytes  -Offset   "C66F8E"                   -Patch "tww_voices.bin" }
        if (IsChecked $Redux.Audio.LowHealth)   { ChangeBytes -Offset @("170E0", "170E4", "170EA") -Values "00"            }

    }

}



#==============================================================================================================================================================================================
function AdjustGUI() {
    
    EnableForm -Form $Redux.Box.Vanilla -Enable (!$Patches.Redux.Checked)

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsPanel



    # VANILLA #

    $Redux.Box.Vanilla = CreateReduxGroup   -Tag  "Vanilla"                                                                         -Text "Vanilla Game Options (Part of Redux)"
    CreateReduxComboBox -Name "DamageTaken" -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage", "16x Damage", "OHKO Mode") -Text "Damage Taken"       -Info "Set the amount of damage you receive`nWith OHKO Mode you die in a single hit"                    -Credits "Admentus"
    CreateReduxComboBox -Name "DamageDealt" -Items @("1x Damage", "1/2x Damage", "1/4x Damage", "1/8x Damage")                      -Text "Damage Dealt"       -Info "Set the amount of damage you deal to enemies"                                                    -Credits "Admentus"
    CreateReduxCheckBox -Name "NoRecoveryHearts"                                                                                    -Text "No Recovery Hearts" -Info "Recovery Hearts no longer have a chance to drop`nGuaranteed Pots will stop drop Recovert Hearts" -Credits "Admentus"
    CreateReduxCheckBox -Name "USBackportFixes"                                                                                     -Text "US Backport Fixes"  -Info "Restores and fixes the changes from the later released US version into the PAL version"          -Credits "Prof. 9"
    CreateReduxCheckBox -Name "EasierFigurines"                                                                                     -Text "Easier Figurines"   -Info "Doubles the chance you get a new figurine"                                                       -Credits "Admentus"
    CreateReduxCheckBox -Name "BiggoronTimer"                                                                                       -Text "Biggoron Timer"     -Info "Drastically lowers the time you have to wait for Biggoron to spit out the Mirror Shield"         -Credits "Admentus"



    # MAIN #
    
    CreateReduxGroup    -Tag  "Gameplay"        -Text "Gameplay"
    CreateReduxCheckBox -Name "KinstoneBoost"   -Text "Kinstone Boost"   -Info "Increases the droprate of Kinstone Pieces from existing sources"                         -Credits "Admentus"
    CreateReduxCheckBox -Name "MusicHouse"      -Text "Music House"      -Info "Unlocking the Music House now requires showing 10 figures to Herb instead of all 130"    -Credits "Admentus"
    CreateReduxCheckBox -Name "RedRupeeLike"    -Text "Red Rupee Like"   -Info "The Red Rupee Like now steals per 10 Rupees instead of per 20 Rupees"                    -Credits "Admentus"



    # INTERFACE #

    CreateReduxGroup    -Tag  "Interface"   -Text "Interface"
    CreateReduxCheckBox -Name "SwapButtons" -Text "Swap Buttons" -Info "Swap the A and B buttons" -Credits "Admentus"



    # AUDIO #

    CreateReduxGroup    -Tag  "Audio"     -Text "Audio"
    CreateReduxCheckBox -Name "Voices"    -Text '"The Wind Waker" Voices' -Info "Make Link's voices sound more like he does The Wind Waker instead of Ocarina of Time" -Credits "Weario"
    CreateReduxCheckBox -Name "LowHealth" -Text "No Low on Health Sound"  -Info "Remove the constant looping sound effect when you are low on health"                  -Credits "Admentus"

}