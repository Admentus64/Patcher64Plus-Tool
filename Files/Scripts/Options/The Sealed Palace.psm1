function PatchOptions() {
    
    # MODELS #

    if (IsChecked $Redux.Graphics.MMAdultLink)   { ApplyPatch -Patch "Decompressed\Optional\The Sealed Palace\tsp_mm_adult_link.ppf" }
    if (IsChecked $Redux.Graphics.MMChildLink)   { ApplyPatch -Patch "Decompressed\Optional\The Sealed Palace\tsp_mm_child_link.ppf" }
    
}



#==============================================================================================================================================================================================
function ByteOptions() {

    # GAMEPLAY #

    if (IsChecked $Redux.Gameplay.ResumeLastArea) { ChangeBytes -Offset "B1F7AC" -Values "0000"; ChangeBytes -Offset "B1F7A0" -Values "0000" }



    # HERO MODE #

    if (IsChecked $Redux.Hero.NoHeartDrops) { ChangeBytes -Offset "A966C7" -Values "2E" }



    # ANIMATIONS #

    if     (IsChecked $Redux.Animation.WeaponIdle)        { ChangeBytes -Offset "1B9AA5E" -Values "34 28"                                                                                                             }
    if     (IsChecked $Redux.Animation.WeaponCrouch)      { ChangeBytes -Offset "1B9ACCE" -Values "2A 10"                                                                                                             }
    if     (IsChecked $Redux.Animation.WeaponAttack)      { ChangeBytes -Offset "1B9B892" -Values "2B D8";               ChangeBytes -Offset "1B9B896" -Values "2B E0"; ChangeBytes -Offset "1B9B89A" -Values "2B E0" }
    if     (IsChecked $Redux.Animation.HoldShieldOut)     { ChangeBytes -Offset "B9CE47"  -Values "02 0A 0A 10"                                                                                                       }
    if     (IsChecked $Redux.Animation.BackflipAttack)    { ChangeBytes -Offset "1B9B842" -Values "29 D0"                                                                                                             }
    elseif (IsChecked $Redux.Animation.FrontflipAttack)   { ChangeBytes -Offset "1B9B842" -Values "2A 60"                                                                                                             }
    if     (IsChecked $Redux.Animation.FrontflipJump)     { PatchBytes  -Offset "69A700"  -Patch "Jumps\frontflip.bin"                                                                                                }
    elseif (IsChecked $Redux.Animation.SomarsaultJump)    { PatchBytes  -Offset "69A700"  -Patch "Jumps\somarsault.bin"; ChangeBytes -Offset "1EF8149" -Values "0E"                                                   }
    if     (IsChecked $Redux.Animation.SideBackflip)      { ChangeBytes -Offset "1B9BC4A" -Values "29 88"                                                                                                             }

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsDialog -Columns 4 -Height 410 -NoLanguages
    


    # GAMEPLAY #

    CreateReduxGroup    -All -Tag  "Gameplay"       -Text "Gameplay"
    CreateReduxCheckBox -All -Name "ResumeLastArea" -Text "Resume From Last Area" -Info "Resume playing from the area you last saved in" -Warning "Don't save in Grottos" -Credits "Aegiker"



    # HERO MODE #

    CreateReduxGroup    -All -Tag  "Hero"         -Text "Hero Mode"
    CreateReduxCheckBox -All -Name "NoHeartDrops" -Text "No Heart Drops" -Info "Remove Recovery Heart drops from the game" -Credits "Admentus"



    # GRAPHICS #

    CreateReduxGroup    -All -Tag  "Graphics"    -Text "Graphics" 
    CreateReduxCheckBox -All -Name "MMChildLink" -Text "MM Child Link" -Info "Replaces the Child Link model with the one from Majora's Mask"         -Credits "Nintendo"
    CreateReduxCheckBox -All -Name "MMAdultLink" -Text "MM Adult Link" -Info "Replaces the Child Link model with the one styled after Majora's Mask" -Credits "Skilar"



    # ANIMATIONS #

    $weapons = "`n`nAffected weapons:`n- Giant's Knife`n- Giant's Knife (Broken)`n- Biggoron Sword`n- Deku Stick`n- Megaton Hammer"

    CreateReduxGroup    -Tag  "Animation"       -All -Text "Link Animations"
    CreateReduxCheckBox -Name "WeaponIdle"      -All -Text "2-handed Weapon Idle"   -Info ("Restore the beta animation when idly holding a two-handed weapon" + $weapons)                      -Credits "Admentus"
    CreateReduxCheckBox -Name "WeaponCrouch"    -All -Text "2-handed Weapon Crouch" -Info ("Restore the beta animation when crouching with a two-handed weapon" + $weapons)                    -Credits "Admentus"
    CreateReduxCheckBox -Name "WeaponAttack"    -All -Text "2-handed Weapon Attack" -Info ("Restore the beta animation when attacking with a two-handed weapon" + $weapons)                    -Credits "Admentus"
    CreateReduxCheckBox -Name "HoldShieldOut"   -All -Text "Hold Shield Out"        -Info "Restore the beta animation for Link to always holds his shield out even when his sword is sheathed" -Credits "Admentus"
    CreateReduxCheckBox -Name "BackflipAttack"  -All -Text "Backflip Jump Attack"   -Info "Restore the beta animation to turn the Jump Attack into a Backflip Jump Attack"                     -Credits "Admentus"
    CreateReduxCheckBox -Name "FrontflipAttack" -All -Text "Frontflip Jump Attack"  -Info "Restore the beta animation to turn the Jump Attack into a Frontflip Jump Attack"                    -Credits "Admentus"    -Link $Redux.Animation.BackflipAttack
    CreateReduxCheckBox -Name "FrontflipJump"   -All -Text "Frontflip Jump"         -Info "Replace the jumps with frontflip jumps`nThis is a jump from Majora's Mask"                          -Credits "SoulofDeity"
    CreateReduxCheckBox -Name "SomarsaultJump"  -All -Text "Somarsault Jump"        -Info "Replace the jumps with somarsault jumps`nThis is a jump from Majora's Mask"                         -Credits "SoulofDeity" -Link $Redux.Animation.FrontflipJump
    CreateReduxCheckBox -Name "SideBackflip"    -All -Text "Side Backflip"          -Info "Replace the backflip jump with side hop jumps"                                                      -Credits "BilonFullHDemon"

}