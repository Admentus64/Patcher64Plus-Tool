function PatchOptions() {

    if ([byte]$Redux.Level.MaxBP.Text -gt 50) { ApplyPatch -Patch "Compressed\Optional\bp_menu_space.ppf" }

    if     (IsChecked $Redux.Gameplay.FastSpin)        { ApplyPatch -Patch "Compressed\Optional\fast_spin.ppf"       }
    elseif (IsChecked $Redux.Gameplay.SuperFastSpin)   { ApplyPatch -Patch "Compressed\Optional\super_fast_spin.ppf" }

}



#==============================================================================================================================================================================================
function ByteOptions() {
    
    # MAIN #

    if     (IsChecked $Redux.Graphics.Widescreen)              { ChangeBytes -Offset "8974" -Values "2407018A" }
    elseif (IsChecked $Redux.Graphics.Ultrawide)               { ChangeBytes -Offset "8974" -Values "24070206" }

    if     (IsChecked $Redux.Skip.Logo)                        { ChangeBytes -Offset "F298"  -Values "0000000024040700A44400AC" }
    if     (IsChecked $Redux.Skip.Storybook)                   { ChangeBytes -Offset "11C84" -Values "34051000"                 }
    if     (IsChecked $Redux.Skip.Demo)                        { ChangeBytes -Offset "12644" -Values "1000"                     }

    if     (IsChecked $Redux.Gameplay.FreezeTimer)             { ChangeBytes -Offset "1B80"   -Values "2400"   }
    if     (IsChecked $Redux.Gameplay.CanAlwaysEscape)         { ChangeBytes -Offset "18F6F0" -Values "2400"   }
    elseif (IsChecked $Redux.Gameplay.CanNeverEscape)          { ChangeBytes -Offset "18F6F0" -Values "1000"   }
    if     (IsChecked $Redux.Gameplay.NoHealthBars)            { ChangeBytes -Offset "16E9D8" -Values "1000"   }
    
    if (IsDefault -Elem $Redux.StarPower.RefreshHP     -Not)   { ChangeBytes -Offset "78D0FB" -Values (Get8Bit $Redux.StarPower.RefreshHP.Text); ChangeBytes -Offset "78D04B" -Values (Get8Bit $Redux.StarPower.RefreshHP.Text) }
    if (IsDefault -Elem $Redux.StarPower.RefreshFP     -Not)   { ChangeBytes -Offset "78D10B" -Values (Get8Bit $Redux.StarPower.RefreshFP.Text); ChangeBytes -Offset "78D0A3" -Values (Get8Bit $Redux.StarPower.RefreshFP.Text) }
    if (IsDefault -Elem $Redux.StarPower.StarStorm     -Not)   { ChangeBytes -Offset "79002F" -Values (Get8Bit $Redux.StarPower.StarStorm.Text)     }
    if (IsDefault -Elem $Redux.StarPower.ChildOutPower -Not)   { ChangeBytes -Offset "790863" -Values (Get8Bit $Redux.StarPower.ChillOutPower.Text) }
    if (IsDefault -Elem $Redux.StarPower.ChildOutTurns -Not)   { ChangeBytes -Offset "79085B" -Values (Get8Bit $Redux.StarPower.ChillOutTurns.Text) }
    if (IsDefault -Elem $Redux.StarPower.Smooch        -Not)   { ChangeBytes -Offset "793B8F" -Values (Get8Bit $Redux.StarPower.Smooch.Text); ChangeBytes -Offset "793B37" -Values (Get8Bit $Redux.StarPower.Smooch.Text) }

    if (IsChecked $Redux.Damage.Value2) {
        ChangeBytes -Offset "8974"   -Values "2407018A"
        ChangeBytes -Offset "1AB5F4" -Values "0260202D0040902DAE2301888E030004AE23018C8E030008AE2301908E05000C0C0B1EAF26100010241500020055001B0000A81200551020A622017E8E05000030A400102403FFDF8E2200001480000B"
    }
    elseif (IsChecked $Redux.Damage.Value3) {
        ChangeBytes -Offset "8974"   -Values "2407018A"
        ChangeBytes -Offset "1AB5F4" -Values "0260202D0040902DAE2301888E030004AE23018C8E030008AE2301908E05000C0C0B1EAF261000103C1880118318F2AC130000028E05000000421020A622017E30A400102403FFDF8E2200001480000B"
    }

    if (IsDefault $Redux.Level.MaxBP -Not) {
        $maxBP   = [byte]$Redux.Level.MaxBP.Text
        $levelBP = [Math]::Floor($maxBP / 10)
        ChangeBytes -Offset "8089B"  -Values (Get8Bit ($levelBP + $maxBP % 10)); ChangeBytes -Offset "18DC57" -Values (Get8Bit $levelBP);            ChangeBytes -Offset "18E31B" -Values (Get8Bit $levelBP)
        ChangeBytes -Offset "18DB07" -Values (Get8Bit ($levelBP * 10));          ChangeBytes -Offset "18E32B" -Values (Get8Bit ($levelBP * 10 + 1)); ChangeBytes -Offset "18E337" -Values (Get8Bit ($levelBP * 10))
        $maxBP = $levelBP = $null
    }



    # HEALTH, HEALING & DEFENSE
    # Unknown Offsets: 59537F, 59803F, 5C0F3F, 5C785F, 5F18BF, 64E757, 655F9F, 65B96F, 668DC3, 668DEB, 691B7F

    foreach ($enemy in $Files.json.enemies.targets) {
        if ($enemy.hp -is [int] -and (IsSet $enemy.hp_offset) ) { # Health
            if (IsDefault $Redux.Health[$enemy.name] -Not) {
                if ($enemy.hp_offset -is [system.Array]) {
                    foreach ($offset in $enemy.hp_offset) { ChangeBytes -Offset $offset -Values (Get8Bit $Redux.Health[$enemy.name].text) }
                }
                else { ChangeBytes -Offset $enemy.hp_offset -Values (Get8Bit $Redux.Health[$enemy.name].text) }
            }
        }

        foreach ($heal in $enemy.heal) { # Healing & Damaged
            if ($heal.value -isnot [int] -or !(IsSet $heal.offset)) { continue }
            if (IsSet $heal.type) { $type = $def.type } else { $type = "" }
            if (IsDefault $Redux.Heal[$elem] -Not) {
                if ($heal.offset -is [system.Array]) {
                    foreach ($offset in $heal.offset) { ChangeBytes -Offset $offset -Values (Get8Bit $Redux.Heal[$enemy.name + $type].text) }
                }
                else { ChangeBytes -Offset $heal.offset -Values (Get8Bit $Redux.Heal[$enemy.name + $type].text) }
            }
        }

        foreach ($def in $enemy.def) { # Defense
            if (!(IsSet $def.offset)) { continue }
            if (IsSet $def.type) { $type = $def.type } else { $type = "" }
            if ($def.value -is [int]) {
                $elem = $enemy.name + $type
                if (IsDefault $Redux.Defense[$elem] -Not) {
                    $value = [sbyte]$Redux.Defense[$elem].text
                    if ($value -lt 0) { $value = (Get32Bit ([uint32]::MaxValue + $value * (-1))) } else { $value = (Get32Bit $value) }
                    if ($def.offset -is [system.Array]) {
                        foreach ($offset in $def.offset) { ChangeBytes -Offset $offset -Values $value }
                    }
                    else { ChangeBytes -Offset $def.offset -Values $value }
                }
            }
            elseif ($def.value -is [array]) {
                foreach ($i in 0..($def.value.count-1)) {
                    $elem = $enemy.name + $type + $def.title[$i]
                    $value = [sbyte]$Redux.Defense[$elem].text
                    if ($value -lt 0) { $value = (Get32Bit ([uint32]::MaxValue + $value)) } else { $value = (Get32Bit $value) }
                    if (IsDefault $Redux.Defense[$elem] -Not) {
                        if ($def.offset -is [system.Array]) {
                            foreach ($offset in $def.offset) { ChangeBytes -Offset (AddToOffset -Hex $offset -Add (Get8Bit (8 * $i))) -Values $value }
                        }
                        else { ChangeBytes -Offset (AddToOffset -Hex $def.offset -Add (Get8Bit (8 * $i))) -Values $value }
                    }
                }
            }
        }
    }
    $elem = $name = $type = $null



    # REPLACE ITEM BLOCKS

    foreach ($item in $Files.json.blocks) {
        foreach ($block in $item.blocks) {
            if (IsDefault $Redux.Blocks[$block.id] -Not) {
                $isBadge = $False
                :compare foreach ($x in $Files.json.items) {
                    if (IsSet $x.badges) {
                        foreach ($y in $x.badges) {
                            $title = $y.title
                            if (IsSet $y.copy) { $title += " " + $y.copy }
                            if ($Redux.Blocks[$block.id].text -eq $title) {
                                $new     = $y
                                $isBadge = $True
                                break compare
                            }
                        }
                    }
                    elseif (IsSet $x.items) {
                        foreach ($y in $x.items) {
                            if ($Redux.Blocks[$block.id].text -eq $y.title) {
                                $new = $y
                                break compare
                            }
                        }
                    }
                }

                if     (!$isBadge -and $block.hidden -ne 1)   { $type = "64" }
                elseif (!$isBadge -and $block.hidden -eq 1)   { $type = "88" }
                elseif ( $isBadge -and $block.hidden -ne 1)   { $type = "AC" }
                elseif ( $isBadge -and $block.hidden -eq 1)   { $type = "D0" }

                if ($block.offset -is [system.Array]) {
                    foreach ($offset in $block.offset) {
                        ChangeBytes -Offset $offset                              -Values $type
                        ChangeBytes -Offset (AddToOffset -Hex $offset -Add "13") -Values $new.id
                    }
                }
                else {
                    ChangeBytes -Offset $block.offset                              -Values $type
                    ChangeBytes -Offset (AddToOffset -Hex $block.offset -Add "13") -Values $new.id
                }

                $type = $new = $isBadge = $title = $null
            }
        }
    }
    
    
    
    # REPLACE BADGES #

    foreach ($item in $Files.json.items) {
        if (!(IsSet $item.badges)) { continue }
        foreach ($badge in $item.badges) {
            if (IsDefault $Redux.Badges[$badge.name] -Not) {
                :compare foreach ($x in $list) {
                    if (!(IsSet $x.badges)) { continue }
                    foreach ($y in $x.badges) {
                        if ($Redux.Badges[$badge.name].text -eq $y.title) {
                            $new = $y
                            break compare
                        }
                    }
                }
                $offset = GetDecimal "62CE0"

                if (IsSet $new.msg) { # Message
                    ChangeBytes -Offset (Get32Bit ( (GetDecimal $badge.id) * 32 + $offset + 0)  ) -Values ("0026" + $new.msg)
                    ChangeBytes -Offset (Get32Bit ( (GetDecimal $badge.id) * 32 + $offset + 20) ) -Values ("0023" + $new.msg)
                    ChangeBytes -Offset (Get32Bit ( (GetDecimal $badge.id) * 32 + $offset + 16) ) -Values ("0025" + $new.msg)
                }
                else {
                    ChangeBytes -Offset (Get32Bit ( (GetDecimal $badge.id) * 32 + $offset + 0)  ) -Values "00000000"
                    ChangeBytes -Offset (Get32Bit ( (GetDecimal $badge.id) * 32 + $offset + 20) ) -Values "00000000"
                    ChangeBytes -Offset (Get32Bit ( (GetDecimal $badge.id) * 32 + $offset + 16) ) -Values "00000000"
                }

                ChangeBytes -Offset (Get32Bit ( (GetDecimal $badge.id) * 32 + $offset + 4)  ) -Values $new.icon            # Icon
                ChangeBytes -Offset (Get32Bit ( (GetDecimal $badge.id) * 32 + $offset + 26) ) -Values $new.move            # Move
                ChangeBytes -Offset (Get32Bit ( (GetDecimal $badge.id) * 32 + $offset + 12) ) -Values (Get16Bit $new.sell) # Sell
                ChangeBytes -Offset (Get32Bit ( (GetDecimal $badge.id) * 32 + $offset + 6)  ) -Values (Get16Bit $new.sort) # Sort

                $new = $null
            }
        }
    }
    


    # SET BADGE POINTS #

    foreach ($item in $Files.json.moves) {
        if ($item.onlyMoves) { continue }
        foreach ($move in $item.moves) {
            if ($move.bp -isnot [int]) { continue }
            if (IsDefault $Redux.BadgePoints[$move.name] -Not) {
                $offset = GetDecimal "6A460"
                ChangeBytes -Offset (Get32Bit ( (GetDecimal $move.id) * 20 + $offset + 18) ) -Values (Get8Bit $Redux.BadgePoints[$move.name].text)
            }
        }
    }
    


    # SET FLOWER POINTS #

    foreach ($item in $Files.json.moves) {
        if ($item.onlyBadges) { continue }
        foreach ($move in $item.moves) {
            if ($move.fp -isnot [int]) { continue }
            if (IsDefault $Redux.FlowerPoints[$move.name] -Not) {
                $offset = GetDecimal "6A460"
                ChangeBytes -Offset (Get32Bit ( (GetDecimal $move.id) * 20 + $offset + 17) ) -Values (Get8Bit $Redux.FlowerPoints[$move.name].text)
            }
        }
    }

}


#==============================================================================================================================================================================================
function SetHealth([string]$Offset) {
    
    [float]$multiplier = 1.0

    if     (IsChecked $Redux.Health.Value2)   { [float]$multiplier = 1.25 }
    elseif (IsChecked $Redux.Health.Value3)   { [float]$multiplier = 1.5  }
    elseif (IsChecked $Redux.Health.Value4)   { [float]$multiplier = 1.75 }
    elseif (IsChecked $Redux.Health.Value5)   { [float]$multiplier = 2.0  }
    elseif (IsChecked $Redux.Health.Value6)   { [float]$multiplier = 2.5  }

    MultiplyBytes -Offset $offset -Factor $multiplier

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsDialog -Columns 6 -Height 600 -Tabs @("Main", "Replace Item Blocks", "Replace Badges", "Badge Points", "Moves Cost", "Health", "Defense")

}



#==============================================================================================================================================================================================
function ApplyPreset1() {

    SetAllBlocks   -Rebalanced
    SetAllBadges   -Rebalanced
    SetAllBP       -Rebalanced
    SetAllFP       -Rebalanced
    SetAllEnemyHP  -Multi 1.25
    SetAllEnemyDEF -Add 1 -NonNull

    $Redux.Damage.Value2.Checked = $True

    $Redux.StarPower.RefreshHP

    $Redux.Level.MaxBP = 75

}



#==============================================================================================================================================================================================
function CreateTabMain() {

    CreateReduxGroup    -All -Tag  "Graphics"        -Text "Graphics" -Columns 3
    CreateReduxCheckBox -All -Name "Widescreen"      -Text "16:9 Widescreen"      -Info "Adjust the aspect ratio from 4:3 to 16:9 widescreen"             -Credits "gamemasterplc & Admentus"
    CreateReduxCheckBox -All -Name "Ultrawide"       -Text "21:9 Widescreen"      -Info "Adjust the aspect ratio from 4:3 to 21:9 widescreen"             -Credits "gamemasterplc & Admentus" -Link $Redux.Graphics.Widescreen

    CreateReduxGroup    -All -Tag  "Skip"            -Text "Skip"
    CreateReduxCheckBox -All -Name "Logo"            -Text "Skip Logos"           -Info "Logos shown on booting up the game are now skipped"              -Credits "Admentus & Star Rod (Utility Tool)"
    CreateReduxCheckBox -All -Name "Storybook"       -Text "Skip Storybook Intro" -Info "The Storybook Intro shown on booting up the game is now skipped" -Credits "Admentus & Star Rod (Utility Tool)"
    CreateReduxCheckBox -All -Name "Demo"            -Text "Skip Demos"           -Info "Gameplay Demos will no longer play"                              -Credits "Admentus & Star Rod (Utility Tool)"

    CreateReduxGroup    -All -Tag  "Gameplay"        -Text "Gameplay"
    CreateReduxCheckBox -All -Name "FreezeTimer"     -Text "Freeze Game Timer"    -Info "The game timer on your save file no longer increments"           -Credits "gamemasterplc & Admentus"
    CreateReduxCheckBox -All -Name "CanAlwaysEscape" -Text "Can Always Escape"    -Info "Escaping from a battle now always succeeds"                      -Credits "gamemasterplc & Admentus"
    CreateReduxCheckBox -All -Name "CanNeverEscape"  -Text "Can Never Escape"     -Info "Escaping from a battle now never succeeds"                       -Credits "gamemasterplc & Admentus" -Link $Redux.Gameplay.CanAlwaysEscape
    CreateReduxCheckBox -All -Name "NoHealthBars"    -Text "No Health Bars"       -Info "Health Bars for enemies are never shown"                         -Credits "Admentus"
    CreateReduxCheckBox -All -Name "FastSpin"        -Text "Fast Spin"            -Info "Spinning with Z goes faster now"                                 -Credits "Admentus"
    CreateReduxCheckBox -All -Name "SuperFastSpin"   -Text "Super Fast Spin"      -Info "Spinning with Z goes a lot faster now"                           -Credits "Admentus" -Link $Redux.Gameplay.FastSpin

    CreateReduxGroup   -All -Tag  "StarPower"     -Text "Star Powers"
    CreateReduxTextBox -All -Name "RefreshHP"     -Text "Refresh (HP)"      -Value 5  -Min 1 -Max 99 -Info "Set the amount of HP that Refresh restores"        -Credits "Admentus"
    CreateReduxTextBox -All -Name "RefreshFP"     -Text "Refresh (FP)"      -Value 5  -Min 1 -Max 99 -Info "Set the amount of FP that Refresh restores"        -Credits "Admentus"
    CreateReduxTextBox -All -Name "StarStorm"     -Text "Star Storm (DMG)"  -Value 7  -Min 1 -Max 99 -Info "Set the amount of damage that Star Storm does"     -Credits "Admentus"
    CreateReduxTextBox -All -Name "ChillOutPower" -Text "Chill Out (Power)" -Value 3  -Min 1 -Max 99 -Info "Set the amount of lowered DMG that Chill Out does" -Credits "Admentus"
    CreateReduxTextBox -All -Name "ChillOutTurns" -Text "Chill Out (Turns)" -Value 4  -Min 1 -Max 99 -Info "Set the amount of how many turns Chill Out lasts"  -Credits "Admentus"
    CreateReduxTextBox -All -Name "Smooch"        -Text "Smooch (HP)"       -Value 20 -Min 1 -Max 99 -Info "Set the amount of HP that Smooch restores"         -Credits "Admentus"

    CreateReduxGroup       -All -Tag  "Damage"                         -Text "Hard Mode (Damage)"
    CreateReduxPanel
    CreateReduxRadioButton -All -Name "Value1" -Max 3 -SaveTo "Damage" -Text "1x Damage"   -Info "Keep the vanilla game difficulty"              -Checked
    CreateReduxRadioButton -All -Name "Value2" -Max 3 -SaveTo "Damage" -Text "1.5x Damage" -Info "Increases the damage dealt by enemies by 1.5x" -Credits "Skelux & Admentus"
    CreateReduxRadioButton -All -Name "Value3" -Max 3 -SaveTo "Damage" -Text "2x Damage"   -Info "Increases the damage dealt by enemies by 2x"   -Credits "Skelux & Admentus"

    CreateReduxGroup   -All -Tag  "Level" -Text "Leveling"
    CreateReduxTextBox -All -Name "MaxBP" -Text "Max BP" -Value 30 -Min 0 -Max 75 -Info "Set the maximum amount of BP you can have`nThe maximum amount will be distributed with each upgrade`nLeftover values will be added to the starting value" -Credits "Admentus" -Warning "Affects save data, so use this option on a new save file"

}


#==============================================================================================================================================================================================
function CreateTabReplaceItemBlocks() {
    
    CreateReduxGroup -All -Tag "Blocks" -Text "Item Blocks (Presets)"
    $button = CreateReduxButton -All -Text "Reset"      -Info "Keep the vanilla items for item blocks"                                                                            -Credits "Admentus"; $button.Add_Click({ SetAllBlocks             })
    $button = CreateReduxButton -All -Text "Rebalanced" -Info "Rebalances item blocks by replacing some items with badges for a more forgiving experience on harder difficulties" -Credits "Admentus"; $button.Add_Click({ SetAllBlocks -Rebalanced })

    [System.Collections.ArrayList]$temp = @()
    foreach ($badge in $Files.json.items.badges) {
        if (IsSet $badge.copy)   { $temp.Add($badge.title + " " + $badge.copy) }
        else                     { $temp.Add($badge.title) }
    }
    $items += ($temp | sort)

    [System.Collections.ArrayList]$temp = @()
    foreach ($item in $Files.json.items.items) {
        $temp.Add($item.title)
    }
    $items += ($temp | sort)

    foreach ($item in $Files.json.blocks) {
        CreateReduxGroup -All -Tag "Blocks" -Text ("Item Blocks (" + $item.area + ")")
        foreach ($block in $item.blocks) {
            CreateReduxComboBox -All -Name $block.id -Text $block.map -Items $items -Default $block.item -Info ("Set the item for the block: " + $block.id) -Credits "Admentus"
        }
    } 

    $items = $temp = $null

}



#==============================================================================================================================================================================================
function CreateTabReplaceBadges() {
    
    CreateReduxGroup -All -Tag "Badges" -Text "Badges (Presets)"
    $button = CreateReduxButton -All -Text "Reset"      -Info "Keep the vanilla badges"                                                                               -Credits "Admentus"; $button.Add_Click({ SetAllBadges             })
    $button = CreateReduxButton -All -Text "Rebalanced" -Info "Rebalances badges by replacing some for others for a more forgiving experience on harder difficulties" -Credits "Admentus"; $button.Add_Click({ SetAllBadges -Rebalanced })

    [System.Collections.ArrayList]$items = @()
    foreach ($item in $Files.json.items) {
        foreach ($badge in $item.badges) {
            if ($items -NotContains $badge.title -and $items -NotContains ($badge.title + " (unused)") ) {
                if ($item.type -eq "Unused")   { $items.Add($badge.title + " (unused)") }
                else                           { $items.Add($badge.title)               }
            }
        }
    }
    $items = $items | Sort

    foreach ($item in $Files.json.items) {
        if (!(IsSet $item.badges)) { continue }
        CreateReduxGroup -All -Tag "Badges" -Text ("Badges (" + $item.type + ")")
        foreach ($badge in $item.badges) {
            $title = $badge.title
            if (IsSet $badge.copy) { $title = $title + " " + $badge.copy }

            if ($item.type -eq "Unused") {
                $unusedItems = $items.clone()
                foreach ($i in 0..($unusedItems.count-1)) {
                    if ($unusedItems[$i] -eq ($badge.title + " (unused)")) {
                        $unusedItems[$i] = $badge.title
                        break
                    }
                }
                CreateReduxComboBox -All -Name $badge.name -Text $title -Items $unusedItems -Default $badge.title -Info ("Replace the " + $badge.title + " Badge with another badge") -Credits "Admentus"
            }
            else {
                CreateReduxComboBox -All -Name $badge.name -Text $title -Items $items       -Default $badge.title -Info ("Replace the " + $badge.title + " Badge with another badge") -Credits "Admentus"
            }
        }
    } 

    $items = $unusedItems = $title = $list = $null

}



#==============================================================================================================================================================================================
function CreateTabBadgePoints() {
    
    CreateReduxGroup -All -Tag "BadgePoints" -Text "Badge Points (Presets)"
    $button = CreateReduxButton -All -Text "Reset"      -Info "Keep the vanilla BP values for badges"                                                      -Credits "Admentus"; $button.Add_Click({ SetAllBP             })
    $button = CreateReduxButton -All -Text "Rebalanced" -Info "Rebalances the BP values for badges for a more forgiving experience on harder difficulties" -Credits "Admentus"; $button.Add_Click({ SetAllBP -Rebalanced })

    foreach ($item in $Files.json.moves) {
        if ($item.onlyMoves) { continue }
        CreateReduxGroup -All -Tag "BadgePoints" -Text ("Badge Points (" + $item.type + ")")
        foreach ($move in $item.moves) {
            if ($move.bp -is [int]) { CreateReduxTextBox -All -Name $move.name -Text $move.title -Value $move.bp -Min 0 -Max 30 -Info ("Set the BP cost for the " + $move.title + " Badge") -Credits "Admentus" }
        }
    }

    $button = $null

}



#==============================================================================================================================================================================================
function CreateTabMovesCost() {
    
    CreateReduxGroup  -All -Tag "FlowerPoints" -Text "Flower Points (Presets)"
    $button = CreateReduxButton -All -Text "Reset"      -Info "Keep the vanilla FP values for moves"                                                      -Credits "Admentus"; $button.Add_Click({ SetAllFP             })
    $button = CreateReduxButton -All -Text "Rebalanced" -Info "Rebalances the FP values for moves for a more forgiving experience on harder difficulties" -Credits "Admentus"; $button.Add_Click({ SetAllFP -Rebalanced })

    foreach ($item in $Files.json.moves) {
        if ($item.onlyBadges) { continue }
        if ($item.type -eq "Goombario" -or $item.type -eq "Bombette" -or $item.type -eq "Bow" -or $item.type -eq "Sushie") { $columns = 3 } else { $columns = 0 }

        if ($item.type -eq "Star Powers")   { CreateReduxGroup -All -Tag "FlowerPoints" -Text ("Star Powers")                        -Columns $columns; $fp = "SP" }
        else                                { CreateReduxGroup -All -Tag "FlowerPoints" -Text ("Flower Points (" + $item.type + ")") -Columns $columns; $fp = "FP" }
        foreach ($move in $item.moves) {
            if ($move.fp -is [int]) { CreateReduxTextBox -All -Name $move.name -Text $move.title -Value $move.fp -Min 0 -Max 50 -Info ("Set the " + $fp + " cost for the " + $move.title + " move") -Credits "Admentus" }
        }
    }
    $button = $columns = $fp = $null

}



#==============================================================================================================================================================================================
function CreateTabHealth() {
    
    CreateReduxGroup -All -Tag "Health" -Text "Health (Presets)"
    $button = CreateReduxButton -All -Text "1x Health"    -Info "Keep the vanilla health values for enemies" -Credits "Admentus"; $button.Add_Click({ SetAllEnemyHP -Default    })
    $button = CreateReduxButton -All -Text "1.25x Health" -Info "Set the health of Enemies to 1.25x"         -Credits "Admentus"; $button.Add_Click({ SetAllEnemyHP -Multi 1.25 })
    $button = CreateReduxButton -All -Text "1.5x Health"  -Info "Set the health of Enemies to 1.5x"          -Credits "Admentus"; $button.Add_Click({ SetAllEnemyHP -Multi 1.5  })
    $button = CreateReduxButton -All -Text "1.75x Health" -Info "Set the health of Enemies to 1.75x"         -Credits "Admentus"; $button.Add_Click({ SetAllEnemyHP -Multi 1.75 })
    $button = CreateReduxButton -All -Text "2x Health"    -Info "Set the health of Enemies to 2x"            -Credits "Admentus"; $button.Add_Click({ SetAllEnemyHP -Multi 2    })
    $button = CreateReduxButton -All -Text "2.5x Health"  -Info "Set the health of Enemies to 3x"            -Credits "Admentus"; $button.Add_Click({ SetAllEnemyHP -Multi 2.5  })

    foreach ($item in $Files.json.enemies) {
        if     ($item.type -eq "Piranhas")                                    { $columns = 3 }
        elseif ($item.type -eq "Beetles" -or $item.type -eq "Bullet Bills")   { $columns = 4 }
        else                                                                  { $columns = 0 }
        CreateReduxGroup -All -Tag "Health" -Text ("Health (" + $item.type + ")") -Columns $columns
        foreach ($enemy in $item.targets) {
            if ($enemy.hp -is [int] -and (IsSet $enemy.hp_offset) ) {
                CreateReduxTextBox -All -Name $enemy.name -Text $enemy.title -Value $enemy.hp -Min 1 -Max 127 -Info ("Set the Health Points for " + $enemy.title) -Credits "Admentus"
            }
        }
    }

    CreateReduxGroup -All -Tag "Heal" -Text "Healing && Damaged"
    foreach ($item in $Files.json.enemies.targets) {
        foreach ($heal in $item.heal) {
            if ($heal.value -is [int] -and (IsSet $heal.offset) ) {
                if (IsSet $heal.type) {
                    $name = $item.title + $heal.type
                    $text = $heal.type + "`n" + $item.title
                }
                else {
                    $name = $item.title
                    $text = "Heal (" + $item.title + ")"
                }
                if     ($heal.type -eq "Damaged")      { $info = "Set the starting HP value for " + $item.title              + " due to being damaged prior to the battle" }
                elseif ($heal.type -eq "Group Heal")   { $info = "Set the power for the group heal ability for "             + $item.title }
                elseif ($heal.type -eq "Heal Time")    { $info = "Set the amount of times the heal ability can be used for " + $item.title }
                else                               { $info = "Set the power of the heal ability for "                        + $item.title }
                CreateReduxTextBox -All -Name $name -Text $text -BoxHeight 5 -Value $heal.value -Min 1 -Max 99 -Info $info -Credits "Admentus"
            }
        }
    }

    $button = $columns = $name = $text = $info = $null

}



#==============================================================================================================================================================================================
function CreateTabDefense() {
    
    CreateReduxGroup -All -Tag "Defense" -Text "Defense (Presets)"
    $button = CreateReduxButton -All -Text "Vanilla Defense" -Info "Keep the vanilla defense values for enemies"                                             -Credits "Admentus"; $button.Add_Click({ SetAllEnemyDEF                 })
    $button = CreateReduxButton -All -Text "+1 Defense"      -Info "Increase the defense for enemies by 1`nOnly for enemies who had a defense higher than 0" -Credits "Admentus"; $button.Add_Click({ SetAllEnemyDEF -Add 1 -NonNull })

    foreach ($enemy in $Files.json.enemies.targets) {
        if ($enemy.def.count -eq 0)              { continue }
        if ($enemy.def[0].offset.length -eq 0)   { continue }
        CreateReduxGroup -All -Tag "Defense" -Text $enemy.title
        foreach ($def in $enemy.def) {
            if (!(IsSet $def.offset)) { continue }
            if (IsSet $def.type) {
                $name = $def.type
                $text = " (" + $def.type + ")"
            }
            else { $name = $text = "" }
            if ($def.value -is [int]) {
                CreateReduxTextBox -All -Name ($enemy.name + $name) -Text ("Normal" + $text) -Value $def.value -Min (-99) -Max 99 -Length 3 -Info ("Set the Defense Points for " + $enemy.title + $text) -Credits "Admentus"
            }
            elseif ($def.value -is [array]) {
                foreach ($i in 0..($def.value.count-1)) {
                    CreateReduxTextBox -All -Name ($enemy.name + $name + $def.title[$i]) -Text ($def.title[$i] + $text) -Value $def.value[$i] -Min (-99) -Max 99 -Length 3 -Info ("Set the " + $def.title[$i] + " Defense Points for " + $enemy.title + $text) -Credits "Admentus"
                }
                if ($enemy.separate) { $Last.row++; $Last.column = 1 }
            }
        }
    }

    $name = $text = $button = $null
    
}



#==============================================================================================================================================================================================
function SetAllBlocks([switch]$Rebalanced) {
    
    foreach ($item in $Redux.Groups) {
        if ($item.tag -ne "Blocks") { continue }
        foreach ($form in $item.controls) {
            if ($form.GetType() -eq [System.Windows.Forms.ComboBox]) { $form.selectedIndex = $form.Default }
        }
    }

    if ($Rebalanced) {
        # Goomba Region
        $Redux.Blocks.KMR03_Coin.Text         = "Weak Smash Charge"
        $Redux.Blocks.KMR09_CoinA.Text        = "Weak Jump Charge"
        $Redux.Blocks.KMR09_CoinB.Text        = "Healthy Healthy"
      # $Redux.Blocks.KMR10_SleepySheep.Text  = ""

        # Koopa Fortress
      # $Redux.Blocks.TRD09_MapleSyrup.Text   = ""

        # Mt. Rugged
      # $Redux.Blocks.IWA00_SleepySheep.Text  = ""
        $Redux.Blocks.IWA03_Coin.Text         = "Defend Plus X"
      # $Redux.Blocks.IWA03_Mushroom.Text     = ""
      # $Redux.Blocks.IWA03_HoneySyrup.Text   = ""

        # Dry Dry Desert
      # $Redux.Blocks.SBK00_FrightJar.Text    = ""
        $Redux.Blocks.SBK00_Coin.Text         = "Right On!"
      # $Redux.Blocks.SBK10_ThunderRage.Text  = ""
        $Redux.Blocks.SBK14_Coin.Text         = "Damage Dodge X"
      # $Redux.Blocks.SBK14_Syrup.Text        = ""
      # $Redux.Blocks.SBK20_Mushroom.Text     = ""
      # $Redux.Blocks.SBK20_SuperShroom.Text  = ""
      # $Redux.Blocks.SBK20_UltraShroom.Text  = ""
        $Redux.Blocks.SBK22_CoinA.Text        = "Auto Jump"
        $Redux.Blocks.SBK22_CoinB.Text        = "Auto Smash"
        $Redux.Blocks.SBK22_CoinC.Text        = "Auto Multibounce"
        $Redux.Blocks.SBK22_CoinD.Text        = "Shrink Smash"
      # $Redux.Blocks.SBK22_FireFlower.Text   = ""
        $Redux.Blocks.SBK43_Coin.Text         = "Super Jump"
        $Redux.Blocks.SBK46_Coin.Text         = "Mega HP Drain"
      # $Redux.Blocks.SBK46_LifeShroom.Text   = ""
        $Redux.Blocks.SBK64_Coin.Text         = "Super Smash"

        # Forever Forest
      # $Redux.Blocks.MIM11_VoltShroom.Text   = ""

        # Gusty Gulch
        $Redux.Blocks.ARN02_CoinA.Text        = "HP Plus X"
        $Redux.Blocks.ARN02_CoinB.Text        = "HP Plus Y"
        $Redux.Blocks.ARN03_Coin.Text         = "Defend Plus Y"
      # $Redux.Blocks.ARN04_SuperShroom.Text  = ""
        $Redux.Blocks.ARN04_Coin.Text         = "Crazy Heart"

        # Tubba's Castle
      # $Redux.Blocks.DGB14_MapleSyrup.Text   = ""

        # Mt. Lavalava
        $Redux.Blocks.KZN03_CoinA.Text        = "Power Plus X"
        $Redux.Blocks.KZN03_CoinB.Text        = "HP Plus Y"
        $Redux.Blocks.KZN03_CoinC.Text        = "FP Plus Y"
        $Redux.Blocks.KZN03_CoinD.Text        = "Flower Fanatic"
      # $Redux.Blocks.KZN06_LifeShroom.Text   = ""
      # $Redux.Blocks.KZN19_SuperShroom.Text  = ""
      # $Redux.Blocks.KZN19_MapleSyrup.Text   = ""

        # Flower Fields
      # $Redux.Blocks.FLO17_ThunderRage.Text  = ""
      # $Redux.Blocks.FLO23_ShootingStar.Text = ""
        $Redux.Blocks.FLO23_Coin.Text         = "Berserker"
      # $Redux.Blocks.FLO24_DizzyDial.Text    = ""
      # $Redux.Blocks.FLO24_MapleSyrup.Text   = ""
    }

}



#==============================================================================================================================================================================================
function SetAllBadges([switch]$Rebalanced) {
    
    foreach ($item in $Redux.Groups) {
        if ($item.tag -ne "Badges") { continue }
        foreach ($form in $item.controls) {
            if ($form.GetType() -eq [System.Windows.Forms.ComboBox]) { $form.selectedIndex = $form.Default }
        }
    }

    if ($Rebalanced) {
        $Redux.Badges.SlowGo.text    = "Damage Dodge"
        $Redux.Badges.AttackFXA.text = "Defend Plus"
        $Redux.Badges.AttackFXB.text = "Defend Plus"
        $Redux.Badges.AttackFXC.text = "Defend Plus"
        $Redux.Badges.AttackFXD.text = "Power Plus"
        $Redux.Badges.AttackFXE.text = "Power Plus"
    }

}



#==============================================================================================================================================================================================
function SetAllBP([switch]$Rebalanced) {
    
    foreach ($item in $Redux.Groups) {
        if ($item.tag -ne "BadgePoints") { continue }
        foreach ($form in $item.controls) {
            if ($form.GetType() -eq [System.Windows.Forms.TextBox]) { $form.text = $form.Default }
        }
    }

    if ($Rebalanced) {
        # Power
        $Redux.BadgePoints.PowerPlus.text     = "4"
        $Redux.BadgePoints.DefendPlus.text    = "4"
        $Redux.BadgePoints.AllOrNothing.text  = "2"

        # Tactics
        $Redux.BadgePoints.Peekaboo.text      = "0"
        $Redux.BadgePoints.ISpy.text          = "0"

        # Field
        $Redux.BadgePoints.FirstAttack.text   = "0"
        $Redux.BadgePoints.BumpAttack.text    = "0"
        $Redux.BadgePoints.ChillOut.text      = "0"
        $Redux.BadgePoints.SpinAttack.text    = "0"
        $Redux.BadgePoints.DizzyAttack.text   = "0"
        $Redux.BadgePoints.SpeedySpin.text    = "0"

        # Items
        $Redux.BadgePoints.MoneyMoney.text    = "3"
        $Redux.BadgePoints.RunawayPay.text    = "0"

        # Unused
        $Redux.BadgePoints.RightOn.text       = "4"
        $Redux.BadgePoints.Berserker.text     = "4"
        $Redux.BadgePoints.CrazyHeart.text    = "6"
        $Redux.BadgePoints.MegaHPDrain.text   = "6"
        $Redux.BadgePoints.FlowerFanatic.text = "6"
    }

}



#==============================================================================================================================================================================================
function SetAllFP([switch]$Rebalanced) {
    
    foreach ($item in $Redux.Groups) {
        if ($item.tag -ne "FlowerPoints") { continue }
        foreach ($form in $item.controls) {
            if ($form.GetType() -eq [System.Windows.Forms.TextBox]) { $form.text = $form.Default }
        }
    }

    if ($Rebalanced) {
        $Redux.BadgePoints.PowerJump.text  = "1"
        $Redux.BadgePoints.MegaJump.text   = "2"
    }

}



#==============================================================================================================================================================================================
function SetAllEnemyHP([single]$Multi=1, [switch]$Default) {
    
    foreach ($item in $Redux.Groups) {
        if ($item.tag -eq "Health" -or $item.tag -eq "Heal") {
            foreach ($form in $item.controls) {
                if ($form.GetType() -eq [System.Windows.Forms.TextBox]) { $form.text = [Math]::Floor([byte]$form.Default * $Multi) }
            }
        }
    }

    if (!$Default) { $Redux.Health.JrTroopa1.text = $Redux.Health.JrTroopa1.default }

}



#==============================================================================================================================================================================================
function SetAllEnemyDEF([byte]$Add=0, [switch]$NonNull) {
    
    foreach ($item in $Redux.Groups) {
        if ($item.tag -ne "Defense") { continue }
        foreach ($form in $item.controls) {
            if ($form.GetType() -eq [System.Windows.Forms.TextBox]) {
                if ($NonNull) {
                    if ($form.Default -ne "0") {
                        if (([sbyte]$form.text + $Add) -lt [sbyte]$form.Max)   { $form.text = [Math]::Floor([sbyte]$form.Default + $Add) }
                        else                                                   { $form.text = [Math]::Floor([sbyte]$form.Max)            }
                    }
                    else { $form.text = $form.Default }
                }
                else {
                    if (([sbyte]$form.text + $Add) -lt [sbyte]$form.Max)   { $form.text = [Math]::Floor([sbyte]$form.Default + $Add) }
                    else                                                   { $form.text = [Math]::Floor([sbyte]$form.Max)            }
                }
            }
        }
    }

}