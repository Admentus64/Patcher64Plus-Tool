function PatchOptions() {

    # MODELS #

    if (IsIndex -Elem $Redux.Graphics.AdultModels -Text "Original" -Not) {
        $file = "\Adult\" + $Redux.Graphics.AdultModels.Text.replace(" (default)", "") + ".ppf"
        if (TestFile ($GameFiles.models + $file))       { ApplyPatch -Patch ($GameFiles.models + $file) -FullPath }
    }

    if (IsChecked $Redux.Animation.Feminine)            { ApplyPatch -Patch "Decompressed\Optional\feminine_animations.ppf" }
    if (IsChecked $Redux.Graphics.HideEquipment)        { ApplyPatch -Patch "Decompressed\Optional\hide_equipment.ppf"      }
    
}



#==============================================================================================================================================================================================
function ByteOptions() {

    # GAMEPLAY #

    if (IsChecked $Redux.Gameplay.FasterBlockPushing) {
        ChangeBytes -Offset "DD2B87" -Values "80";          ChangeBytes -Offset "DD2D27" -Values "03" # Block Speed, Delay
        ChangeBytes -Offset "DD9683" -Values "80";          ChangeBytes -Offset "DD981F" -Values "03" # Milk Crate Speed, Delay
        ChangeBytes -Offset "CE1BD0" -Values "40 80 00 00"; ChangeBytes -Offset "CE0F0F" -Values "03" # Amy Puzzle Speed, Delay
        ChangeBytes -Offset "C77CA8" -Values "40 80 00 00"; ChangeBytes -Offset "C770C3" -Values "01" # Fire Block Speed, Delay
        ChangeBytes -Offset "CC5DBF" -Values "01";          ChangeBytes -Offset "DBCF73" -Values "01" # Forest Basement Puzzle Delay / spirit Cobra Mirror Delay
        ChangeBytes -Offset "DBA233" -Values "19";          ChangeBytes -Offset "DBA3A7" -Values "00" # Truth Spinner Speed, Delay
    }

    if (IsChecked $Redux.Gameplay.EasierMinigames) {
        ChangeBytes -Offset "E2E698" -Values "80 AA E2 64"; ChangeBytes -Offset "E2E6A0" -Values "80 AA E2 4C"; ChangeBytes -Offset "E2D440" -Values "24 19 00 00" # Fixed Bombchu Bowling item order
    }

    if (IsChecked $Redux.Gameplay.DistantZTargeting)        { ChangeBytes -Offset "A987AC" -Values "00 00 00 00"                                                     }
    if (IsChecked $Redux.Gameplay.ManualJump)               { ChangeBytes -Offset "BD78C0" -Values "04 C1";       ChangeBytes -Offset "BD78E3" -Values "01"          }
    if (IsChecked $Redux.Gameplay.NoKillFlash)              { ChangeBytes -Offset "B11C33" -Values "00"                                                              }
    if (IsChecked $Redux.Gameplay.NoShieldRecoil)           { ChangeBytes -Offset "BD416C" -Values "24 00"                                                           }
    if (IsChecked $Redux.Gameplay.RunWhileShielding)        { ChangeBytes -Offset "BD7DA0" -Values "10 00 00 55"; ChangeBytes -Offset "BD01D4" -Values "00 00 00 00" }
    if (IsChecked $Redux.Gameplay.PushbackAttackingWalls)   { ChangeBytes -Offset "BDEAE0" -Values "26 24 00 00 24 85 00 00"                                         }
    if (IsChecked $Redux.Gameplay.RemoveCrouchStab)         { ChangeBytes -Offset "BDE374" -Values "10 00 00 0D"                                                     }



    # RESTORE #

    if (IsChecked $Redux.Restore.RupeeColors) {
        ChangeBytes -Offset "F47EB0" -Values "70 6B BB 3F FF FF EF 3F 68 AD C3 FD E6 BF CD 7F 48 9B 91 AF C3 7D BB 3D 40 0F 58 19 88 ED 80 AB" # Purple
        ChangeBytes -Offset "F47ED0" -Values "D4 C3 F7 49 FF FF F7 E1 DD 03 EF 89 E7 E3 E7 DD A3 43 D5 C3 DF 85 E7 45 7A 43 82 83 B4 43 CC 83" # Gold
    }

    if (IsChecked $Redux.Restore.CowNoseRing)   { ChangeBytes -Offset "EF3E68" -Values "00 00" }
    if (IsChecked $Redux.Restore.Blood)         { ChangeBytes -Offset "B65A40" -Values "04"; ChangeBytes -Offset "B65A44" -Values "04"; ChangeBytes -Offset "B65A4C" -Values "04"; ChangeBytes -Offset "B65A50" -Values "04" }



    # OTHER #

    if ( (IsIndex -Elem $Redux.Other.MapSelect -Text "Translate Only") -or (IsIndex $Redux.Other.MapSelect -Text "Translate and Enable") ) { ExportAndPatch -Path "map_select" -Offset "B9FD90" -Length "EC0" }
    if ( (IsIndex -Elem $Redux.Other.MapSelect -Text "Enable Only")    -or (IsIndex $Redux.Other.MapSelect -Text "Translate and Enable") ) {
        ChangeBytes -Offset "A94994" -Values "00 00 00 00 AE 08 00 14 34 84 B9 2C 8E 02 00 18 24 0B 00 00 AC 8B 00 00"
        ChangeBytes -Offset "B67395" -Values "B9 E4 00 00 BA 11 60 80 80 09 C0 80 80 37 20 80 80 1C 14 80 80 1C 14 80 80 1C 08"
    }

    if (IsChecked $Redux.Other.DefaultZTargeting)    { ChangeBytes -Offset "B71E6D" -Values "01" }
    if (IsChecked $Redux.Other.ItemSelect)           { ExportAndPatch -Path "inventory_editor" -Offset "BCBF64" -Length "C8" }
    if (IsChecked $Redux.Other.DiskDrive)            { ChangeBytes -Offset "BAF1F1" -Values "26"; ChangeBytes -Offset "E6D83B" -Values "04" }

    if ( (IsIndex -Elem $Redux.Other.SkipIntro -Text "Skip Logo")         -or (IsIndex -Elem $Redux.Other.SkipIntro -Text "Skip Logo and Title Screen") )   { ChangeBytes -Offset "B9DAAC" -Values "00 00 00 00" }
    if ( (IsIndex -Elem $Redux.Other.SkipIntro -Text "Skip Title Screen") -or (IsIndex -Elem $Redux.Other.SkipIntro -Text "Skip Logo and Title Screen") )   { ChangeBytes -Offset "B17237" -Values "30"          }
    


    # SKIP #

    if (IsChecked $Redux.Skip.OpeningCutscene) { ChangeBytes -Offset "B06BBA" -Values "00 00" }



    # SPEED #

    if (IsValue -Elem $Redux.Gameplay.MovementSpeed -Not) { ChangeBytes -Offset "B6D5BA" -Values (Get16Bit $Redux.Gameplay.MovementSpeed.Value) }



    # TEXT #

    if (IsIndex -Elem $Redux.Text.NaviPrompt -Not) {
        ChangeBytes -Offset "AE7CD8" -Values "00 00 00 00"
        PatchBytes -Offset "8E3A80"  -Texture -Patch ("Action Prompts\Navi\" + $Redux.Text.NaviPrompt.text + ".prompt")
    }

    if (IsChecked $Redux.Text.Speed2x)        { ChangeBytes -Offset "B5006F" -Values "02" }
    if (IsIndex   $Redux.Text.NaviCUp -Not)   { PatchBytes -Offset "1A3EFC0" -Texture -Patch ("Action Prompts\Navi\" + $Redux.Text.NaviCUp.text + ".cup") }



    # HERO MODE #

    if (IsText -Elem $Redux.Hero.Damage -Compare "OHKO Mode") {
        ChangeBytes -Offset "AE8073" -Values "09 04" -Interval 16
        ChangeBytes -Offset "AE8096" -Values "82 00"
        ChangeBytes -Offset "AE8099" -Values "00 00 00"
    }
    elseif ( (IsIndex -Elem $Redux.Hero.Damage -Not) -or (IsIndex -Elem $Redux.Hero.Recovery -Not) -or (IsChecked $Redux.Hero.NoRecoveryHearts) ) {
        ChangeBytes -Offset "AE8073" -Values "09 04" -Interval 16
        if       ( (IsText -Elem $Redux.Hero.Recovery -Compare "0x Recovery") -or (IsChecked $Redux.Hero.NoRecoveryHearts) ) {                
            if     (IsText -Elem $Redux.Hero.Damage   -Compare "1x Damage")   { ChangeBytes -Offset "AE8096" -Values "81 40" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "2x Damage")   { ChangeBytes -Offset "AE8096" -Values "81 80" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "4x Damage")   { ChangeBytes -Offset "AE8096" -Values "81 C0" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "8x Damage")   { ChangeBytes -Offset "AE8096" -Values "82 00" }
            ChangeBytes -Offset "AE8099" -Values "10 81 43"
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Compare "1x Recovery") {                
            if     (IsText -Elem $Redux.Hero.Damage   -Compare "2x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 40" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "4x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 80" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "8x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 C0" }
            ChangeBytes -Offset "AE8099" -Values "00 00 00"
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Compare "1/2x Recovery") {               
            if     (IsText -Elem $Redux.Hero.Damage   -Compare "1x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 40" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "2x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 80" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "4x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 C0" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "8x Damage")   { ChangeBytes -Offset "AE8096" -Values "81 00" }
            ChangeBytes -Offset "AE8099" -Values "10 80 43"
        }
        elseif     (IsText -Elem $Redux.Hero.Recovery -Compare "1/4x Recovery") {                
            if     (IsText -Elem $Redux.Hero.Damage   -Compare "1x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 80" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "2x Damage")   { ChangeBytes -Offset "AE8096" -Values "80 C0" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "4x Damage")   { ChangeBytes -Offset "AE8096" -Values "81 00" }
            elseif (IsText -Elem $Redux.Hero.Damage   -Compare "8x Damage")   { ChangeBytes -Offset "AE8096" -Values "81 40" }
            ChangeBytes -Offset "AE8099" -Values "10 80 83"
        }
    }

    if     (IsText -Elem $Redux.Hero.MagicUsage -Compare "2x Magic Usage")   { ChangeBytes -Offset "AE84FA" -Values "2C","40" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "4x Magic Usage")   { ChangeBytes -Offset "AE84FA" -Values "2C","80" }
    elseif (IsText -Elem $Redux.Hero.MagicUsage -Compare "8x Magic Usage")   { ChangeBytes -Offset "AE84FA" -Values "2C","C0" }

    if (IsChecked $Redux.Hero.NoItemDrops) {
        $Values = @()
        for ($i=0; $i -lt 80; $i++) { $Values += 0 }
        ChangeBytes -Offset "B5D6B0" -Values $Values
    }

    if     (IsChecked $Redux.Hero.NoRecoveryHearts)   { ChangeBytes -Offset "A895B7"  -Values "2E" }



    # GRAPHICS #

    if (IsChecked $Redux.Graphics.WidescreenAlt)     { ChangeBytes -Offset "B08038" -Values "3C 07 3F E3"      }
    if (IsChecked $Redux.Graphics.ExtendedDraw)      { ChangeBytes -Offset "A9A970" -Values "00 01"            }
    if (IsChecked $Redux.Graphics.ForceHiresModel)   { ChangeBytes -Offset "BE608B" -Values "00"               }
    if (IsChecked $Redux.Graphics.Chests)            { PatchBytes  -Offset "FEC798" -Shared -Patch "Chest.bin" }



    # INTERFACE #

    if (IsChecked $Redux.UI.ButtonPositions) {
        ChangeBytes -Offset "B57F03" -Values "04" -Add # A Button / Text - X position (BA -> BE, +04)
        ChangeBytes -Offset "B586A7" -Values "0E" -Add # A Button / Text - Y position (09 -> 17, +0E)
        ChangeBytes -Offset "B57EEF" -Values "07" -Add # B Button        - X position (A0 -> A7, +07)
        ChangeBytes -Offset "B589EB" -Values "07" -Add # B Text          - X position (94 -> 9B, +07)
    }

    if (IsChecked $Redux.UI.GCScheme) { # Z to L + L to D-Pad textures
        if (IsChecked $Redux.Text.PauseScreen)   { PatchBytes -Offset "844540" -Texture -Patch "GameCube\l_pause_screen_button_mm.bin" }
        else                                     { PatchBytes -Offset "844540" -Texture -Patch "GameCube\l_pause_screen_button.bin" }
        PatchBytes -Offset "92C100"  -Texture -Patch "GameCube\dpad_text_icon.bin"
        PatchBytes -Offset "92C200"  -Texture -Patch "GameCube\l_text_icon.bin"
        if (TestFile ($GameFiles.textures + "\GameCube\l_targeting_" + $LanguagePatch.code + ".bin")) {
            if ($LanguagePatch.l_target_jpn -eq 1)   { $offset = "1A0B300" }
            else                                     { $offset = "1A35680" }
            PatchBytes -Offset $offset -Texture -Patch ("GameCube\l_targeting_" + $LanguagePatch.code + ".bin")
        }
    }

    if ( !((IsIndex -Elem $Redux.UI.ButtonSize -Text "Large") -and (IsIndex -Elem $Redux.UI.ButtonStyle -Text "Ocarina of Time")) ) {
        PatchBytes -Offset "1A3CA00" -Shared -Patch ("Buttons\" + $Redux.UI.ButtonSize.Text.replace(" (default)", "") + "\" + $Redux.UI.ButtonStyle.Text.replace(" (default)", "") + ".bin")
    }

    if ( (IsIndex -Elem $Redux.UI.BlackBars -Index 2) -or (IsIndex -Elem $Redux.UI.BlackBars -Index 4) ) { ChangeBytes -Offset "B0F680" -Values "00 00 00 00" }
    if ( (IsIndex -Elem $Redux.UI.BlackBars -Index 3) -or (IsIndex -Elem $Redux.UI.BlackBars -Index 4) ) {
        ChangeBytes -Offset "B0F5A4" -Values "00 00 00 00"
        ChangeBytes -Offset "B0F5D4" -Values "00 00 00 00"
        ChangeBytes -Offset "B0F5E4" -Values "00 00 00 00"
        ChangeBytes -Offset "B0F688" -Values "00 00 00 00"
    }

    if (IsChecked $Redux.UI.DungeonIcons) {
        PatchBytes -Offset "85F980"  -Shared -Patch "HUD\Dungeon Map Link\Majora's Mask.bin"
        PatchBytes -Offset "85FB80"  -Shared -Patch "HUD\Dungeon Map Skull\Majora's Mask.bin"
        PatchBytes -Offset "1A3E580" -Shared -Patch "HUD\Dungeon Map Chest\Majora's Mask.bin"
    }

    if (IsChecked $Redux.UI.CenterNaviPrompt)    { ChangeBytes -Offset "B582DF" -Values "01" -Subtract }
    if (IsChecked $Redux.UI.Rupees)              { PatchBytes -Offset "1A3DF00" -Shared -Patch "HUD\Rupees\Majora's Mask.bin" }
    if (IsChecked $Redux.UI.DungeonKeys)         { PatchBytes -Offset "1A3DE00" -Shared -Patch "HUD\Keys\Majora's Mask.bin"   }
    if (IsDefault -Elem $Redux.UI.Hearts -Not)   { PatchBytes -Offset "1A3C000" -Shared -Patch ("HUD\Hearts\" + $Redux.UI.Hearts.Text.replace(" (default)", "") + ".bin") }
    if (IsDefault -Elem $Redux.UI.Magic  -Not)   { PatchBytes -Offset "1A3F8C0" -Shared -Patch ("HUD\Magic\"  + $Redux.UI.Magic.Text.replace(" (default)", "")  + ".bin") }



    # ANIMATIONS #

    if     (IsChecked $Redux.Animation.WeaponIdle)        { ChangeBytes -Offset "BEF5F2" -Values "34 28"                                                                                                           }
    if     (IsChecked $Redux.Animation.WeaponCrouch)      { ChangeBytes -Offset "BEF38A" -Values "2A 10"                                                                                                           }
    if     (IsChecked $Redux.Animation.WeaponAttack)      { ChangeBytes -Offset "BEFB62" -Values "2B D8";               ChangeBytes -Offset "BEFB66" -Values "2B E0"; ChangeBytes -Offset "BEFB6A" -Values "2B E0" }
    if     (IsChecked $Redux.Animation.HoldShieldOut)     { ChangeBytes -Offset "B6D6D7" -Values "02 0A 0A 10"                                                                                                     }
    if     (IsChecked $Redux.Animation.BombBag)           { ChangeBytes -Offset "BEF3DA" -Values "25 00";               ChangeBytes -Offset "BEF3F2" -Values "25 08"                                               }
    if     (IsChecked $Redux.Animation.BackflipAttack)    { ChangeBytes -Offset "BEFB12" -Values "29 D0"                                                                                                           }
    elseif (IsChecked $Redux.Animation.FrontflipAttack)   { ChangeBytes -Offset "BEFB12" -Values "2A 60"                                                                                                           }
    if     (IsChecked $Redux.Animation.FrontflipJump)     { PatchBytes  -Offset "70BB00" -Patch "Jumps\frontflip.bin"                                                                                              }
    elseif (IsChecked $Redux.Animation.SomarsaultJump)    { PatchBytes  -Offset "70BB00" -Patch "Jumps\somarsault.bin"; ChangeBytes -Offset "F06149" -Values "0E"                                                  }



    # HIDE HUD #

    if ( (IsChecked $Redux.Hide.AButton) -or (IsChecked $Redux.Hide.Interface) ) {
        ChangeBytes -Offset "B586B0" -Values "00 00 00 00" # A Button (scale)
        ChangeBytes -Offset "AE7D0E" -Values "03 10"       # A Button - Text (DMA)
        ChangeBytes -Offset "7540"   -Values "03 10 00 00 03 10 57 00 03 10 00 00"
    } 

    if ( (IsChecked $Redux.Hide.BButton)      -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "B57EEC" -Values "24 02 03 A0"; ChangeBytes -Offset "B57EFC" -Values "24 0A 03 A2"; ChangeBytes -Offset "B589D4" -Values "24 0F 03 97"; ChangeBytes -Offset "B589E8" -Values "24 19 03 94" } # B Button -> Icon / Ammo / Japanese / English
    if ( (IsChecked $Redux.Hide.StartButton)  -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "B584EC" -Values "24 19 03 84"; ChangeBytes -Offset "B58490" -Values "24 18 03 7A"; ChangeBytes -Offset "B5849C" -Values "24 0E 03 78" } # Start Button   -> Button / Japanese / English
    if ( (IsChecked $Redux.Hide.CupButton)    -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "B584C0" -Values "24 19 03 FE"; ChangeBytes -Offset "B582DC" -Values "24 0E 03 F7"                                                     } # C-Up Button    -> Button / Navi Text
    if ( (IsChecked $Redux.Hide.CLeftButton)  -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "B58504" -Values "24 19 03 E3"; ChangeBytes -Offset "B5857C" -Values "24 19 03 E3"; ChangeBytes -Offset "B58DC4" -Values "24 0E 03 E4" } # C-Left Button  -> Button / Icon / Ammo
    if ( (IsChecked $Redux.Hide.CDownButton)  -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "B58510" -Values "24 0F 03 F9"; ChangeBytes -Offset "B58588" -Values "24 0F 03 F9"; ChangeBytes -Offset "B58C40" -Values "24 06 02 FA" } # C-Down Button  -> Button / Icon / Ammo
    if ( (IsChecked $Redux.Hide.CRightButton) -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "B5851C" -Values "24 19 03 0F"; ChangeBytes -Offset "B58594" -Values "24 19 03 0F"; ChangeBytes -Offset "B58DE0" -Values "24 19 03 10" } # C-Right Button -> Button / Icon / Ammo
    if ( (IsChecked $Redux.Hide.AreaTitle)    -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "BE2B10" -Values "24 07 03 A0" } # Area Titles
    if ( (IsChecked $Redux.Hide.DungeonTitle) -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "AC8828" -Values "24 07 03 A0" } # Dungeon Titles
    if ( (IsChecked $Redux.Hide.Carrots)      -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "B58348" -Values "24 0F 03 6E" } # Epona Carrots    
    if ( (IsChecked $Redux.Hide.Hearts)       -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "ADADEC" -Values "10 00"       } # Disable Hearts Render

    if ( (IsChecked $Redux.Hide.Magic) -or (IsChecked $Redux.Hide.Interface) ) {
        ChangeBytes -Offset "B587C0" -Values "24 0F 03 1A"; ChangeBytes -Offset "B587A0" -Values "24 0E 01 22"; ChangeBytes -Offset "B587B4" -Values "24 19 01 2A" # Magic Meter / Magic Bar - Small (Y pos) / Magic Bar - Large (Y pos)
    }

    if ( (IsChecked $Redux.Hide.Icons) -or (IsChecked $Redux.Hide.Interface) ) {
        ChangeBytes -Offset "B58CFC" -Values "24 0F 00 00" # Clock - Digits (scale)
        $Values = @();     for ($i=0; $i -lt 256; $i++) { $Values += 0 };     ChangeBytes -Offset "1A3E000" -Values $Values     # Clock - Icon
        $Values = @();     for ($i=0; $i -lt 768; $i++) { $Values += 0 };     ChangeBytes -Offset "1A3E600" -Values $Values     # Score Counter - Icon
    }

    if ( (IsChecked $Redux.Hide.Rupees)      -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "AEB7B0" -Values "24 0C 03 1A"; ChangeBytes -Offset "AEBC48" -Values "24 0D 01 CE" } # Rupees - Icon / Rupees - Text (Y pos)
    if ( (IsChecked $Redux.Hide.DungeonKeys) -or (IsChecked $Redux.Hide.Interface) )   { ChangeBytes -Offset "AEB8AC" -Values "24 0F 03 1A"; ChangeBytes -Offset "AEBA00" -Values "24 19 01 BE" } # Key    - Icon / Key    - Text (Y pos)



    # MENU #

    if (IsIndex -Elem $Redux.Menu.Skybox -Index 4 -Not)   { ChangeBytes -Offset "B67722" -Values $Redux.Menu.Skybox.SelectedIndex }



    # SOUNDS / VOICES #

    $file = "Voices Adult\" + $Redux.Sounds.AdultVoices.Text.replace(" (default)", "") + ".bin"
    if (TestFile ($GameFiles.binaries + "\" + $file)) { PatchBytes -Offset "18E1E0" -Patch ($file) }

    if (IsIndex -Elem $Redux.Sounds.Instrument -Not) { ChangeBytes -Offset "B53C7B" -Values ($Redux.Sounds.Instrument.SelectedIndex+1); ChangeBytes -Offset "B4BF6F" -Values ($Redux.Sounds.Instrument.SelectedIndex+1) }



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
    

    
    # EQUIPMENT COLORS #

    if (IsSet $Redux.Colors.SetEquipment) {
        if (IsDefaultColor -Elem $Redux.Colors.SetEquipment[0] -Not) { # Kokiri Tunic
            ChangeBytes -Offset "B6DA38" -IsDec -Values @($Redux.Colors.SetEquipment[0].Color.R, $Redux.Colors.SetEquipment[0].Color.G, $Redux.Colors.SetEquipment[0].Color.B)
            if ( (IsText -Elem $Redux.Colors.Equipment[0] -Compare "Randomized" -Not) -and (IsText -Elem $Redux.Colors.Equipment[0] -Compare "Custom" -Not) ) { PatchBytes -Offset "7FE000" -Texture -Patch ("Tunic\" + $Redux.Colors.Equipment[0].text.replace(" (default)", "") + ".bin") }
        }

        if (IsDefaultColor -Elem $Redux.Colors.SetEquipment[1] -Not) { # Goron Tunic
            ChangeBytes -Offset "B6DA3B" -IsDec -Values @($Redux.Colors.SetEquipment[1].Color.R, $Redux.Colors.SetEquipment[1].Color.G, $Redux.Colors.SetEquipment[1].Color.B)
            if ( (IsText -Elem $Redux.Colors.Equipment[1] -Compare "Randomized" -Not) -and (IsText -Elem $Redux.Colors.Equipment[1] -Compare "Custom" -Not) ) { PatchBytes -Offset "7FF000" -Texture -Patch ("Tunic\" + $Redux.Colors.Equipment[1].text.replace(" (default)", "") + ".bin") }
        }

        if (IsDefaultColor -Elem $Redux.Colors.SetEquipment[2] -Not) { # Zora Tunic
            ChangeBytes -Offset "B6DA3E" -IsDec -Values @($Redux.Colors.SetEquipment[2].Color.R, $Redux.Colors.SetEquipment[2].Color.G, $Redux.Colors.SetEquipment[2].Color.B)
            if ( (IsText -Elem $Redux.Colors.Equipment[2] -Compare "Randomized" -Not) -and (IsText -Elem $Redux.Colors.Equipment[2] -Compare "Custom" -Not) ) { PatchBytes -Offset "800000" -Texture -Patch ("Tunic\" + $Redux.Colors.Equipment[2].text.replace(" (default)", "") + ".bin") }
        }

        if (IsDefaultColor -Elem $Redux.Colors.SetEquipment[3] -Not)   { ChangeBytes -Offset "B6DA44" -IsDec -Values @($Redux.Colors.SetEquipment[3].Color.R, $Redux.Colors.SetEquipment[3].Color.G, $Redux.Colors.SetEquipment[3].Color.B) } # Silver Gauntlets
        if (IsDefaultColor -Elem $Redux.Colors.SetEquipment[4] -Not)   { ChangeBytes -Offset "B6DA47" -IsDec -Values @($Redux.Colors.SetEquipment[4].Color.R, $Redux.Colors.SetEquipment[4].Color.G, $Redux.Colors.SetEquipment[4].Color.B) } # Golden Gauntlets
        if ( (IsDefaultColor -Elem $Redux.Colors.SetEquipment[5] -Not) -and $AdultModel.mirror_shield -ne 0) { # Mirror Shield Frame
            $offset = "F86000"
            do {
                $offset = SearchBytes -Start $offset -End "FBD800" -Values "FA 00 00 00 D7 00 00"
                if ($offset -ge 0) {
                    $Offset = ( Get24Bit ( (GetDecimal $offset) + (GetDecimal "4") ) )
                    if (!(ChangeBytes -Offset $offset -IsDec -Values @($Redux.Colors.SetEquipment[5].Color.R, $Redux.Colors.SetEquipment[5].Color.G, $Redux.Colors.SetEquipment[5].Color.B))) { break }
                }
            } while ($Offset -ge 0)
        }
    }

    

    # MAGIC SPIN ATTACK COLORS #

    if (IsSet $Redux.Colors.SetSpinAttack) {
        if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[0] -Not)   { ChangeBytes -Offset "F15AB4" -IsDec -Values @($Redux.Colors.SetSpinAttack[0].Color.R, $Redux.Colors.SetSpinAttack[0].Color.G, $Redux.Colors.SetSpinAttack[0].Color.B) } # Blue Spin Attack
        if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[1] -Not)   { ChangeBytes -Offset "F15BD4" -IsDec -Values @($Redux.Colors.SetSpinAttack[1].Color.R, $Redux.Colors.SetSpinAttack[1].Color.G, $Redux.Colors.SetSpinAttack[1].Color.B) } # Blue Spin Attack
        if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[2] -Not)   { ChangeBytes -Offset "F16034" -IsDec -Values @($Redux.Colors.SetSpinAttack[2].Color.R, $Redux.Colors.SetSpinAttack[2].Color.G, $Redux.Colors.SetSpinAttack[2].Color.B) } # Red Spin Attack
        if (IsDefaultColor -Elem $Redux.Colors.SetSpinAttack[3] -Not)   { ChangeBytes -Offset "F16154" -IsDec -Values @($Redux.Colors.SetSpinAttack[3].Color.R, $Redux.Colors.SetSpinAttack[3].Color.G, $Redux.Colors.SetSpinAttack[3].Color.B) } # Red Spin Attack
    }



    # SWORD TRAIL COLORS #

    if (IsSet $Redux.Colors.SetSwordTrail) {
        if (IsDefaultColor -Elem $Redux.Colors.SetSwordTrail[0] -Not)       { ChangeBytes -Offset "BEFF7C" -IsDec -Values @($Redux.Colors.SetSwordTrail[0].Color.R, $Redux.Colors.SetSwordTrail[0].Color.G, $Redux.Colors.SetSwordTrail[0].Color.B) }
        if (IsDefaultColor -Elem $Redux.Colors.SetSwordTrail[1] -Not)       { ChangeBytes -Offset "BEFF84" -IsDec -Values @($Redux.Colors.SetSwordTrail[1].Color.R, $Redux.Colors.SetSwordTrail[1].Color.G, $Redux.Colors.SetSwordTrail[1].Color.B) }
        if (IsIndex -Elem $Redux.Colors.SwordTrailDuration -Not -Index 2)   { ChangeBytes -Offset "BEFF8C" -IsDec -Values (($Redux.Colors.SwordTrailDuration.SelectedIndex) * 5) }
    }
    


    # FAIRY COLORS #

    if (IsSet $Redux.Colors.SetFairy) {
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



    # MISC COLORS #

    if (IsChecked $Redux.Colors.PauseScreenColors) {
        ChangeBytes -Offset "BBF88E" -Values "97 8B" # Menu Title Background
        ChangeBytes -Offset "BBF892" -Values "61" # Menu Title Background
        ChangeBytes -Offset "BBF97E" -Values "97 8B" # Z
        ChangeBytes -Offset "BBF982" -Values "61 FF" # R
        ChangeBytes -Offset "BBFC7E" -Values "FF FF" # Unavailable Menu Title
        ChangeBytes -Offset "BBFC82" -Values "FF" # Unavailable Menu Title
        ChangeBytes -Offset "BC793D" -Values "97" # Z/R Highlight
        ChangeBytes -Offset "BC793F" -Values "8B" # Z/R Highlight
        ChangeBytes -Offset "BC7941" -Values "61" # Z/R Highlight
        ChangeBytes -Offset "BC7945" -Values "97" # Z/R Highlight
        ChangeBytes -Offset "BC7947" -Values "8B" # Z/R Highlight
        ChangeBytes -Offset "BC7949" -Values "61" # Z/R Highlight
        ChangeBytes -Offset "BC7994" -Values "B4 B4 B4 B4 78 B4 B4 B4 B4 B4 B4 B4 78 B4 B4 B4 B4 B4 B4 B4 B4 B4 B4 B4 B4 B4 B4 B4 78 B4 B4 B4 B4 B4 B4 B4 78 B4 B4 B4 B4 B4 B4 B4 B4 B4 B4 B4 78 78 78 78 46 78 78 78 78 78 78 78 46 78 78 78 78 78 78 78 78 78 78 78" # Background
    }



    # STARTING EQUIPMENT #

    if (IsChecked $Redux.Save.MasterSword)     { ChangeBytes -Offset "B71EF8" -Values "00 02" -Add }
    if (IsChecked $Redux.Save.GiantsKnife)     { ChangeBytes -Offset "B71EF8" -Values "00 04" -Add }
    if (IsChecked $Redux.Save.BiggoronSword)   { ChangeBytes -Offset "B71EF8" -Values "00 04" -Add; ChangeBytes -Offset "B71E9A" -Values "01" }
    if (IsChecked $Redux.Save.HylianShield)    { ChangeBytes -Offset "B71EF8" -Values "00 20" -Add }
    if (IsChecked $Redux.Save.MirrorShield)    { ChangeBytes -Offset "B71EF8" -Values "00 40" -Add }
    if (IsChecked $Redux.Save.GoronTunic)      { ChangeBytes -Offset "B71EF8" -Values "02 00" -Add }
    if (IsChecked $Redux.Save.ZoraTunic)       { ChangeBytes -Offset "B71EF8" -Values "04 00" -Add }
    if (IsChecked $Redux.Save.IronBoots)       { ChangeBytes -Offset "B71EF8" -Values "20 00" -Add }
    if (IsChecked $Redux.Save.HoverBoots)      { ChangeBytes -Offset "B71EF8" -Values "40 00" -Add }



    # STARTING ITEMS #

    if (IsChecked $Redux.Save.Bomb)                     { ChangeBytes -Offset "B71ED2" -Values "02" }
    if (IsChecked $Redux.Save.FairyBow)                 { ChangeBytes -Offset "B71ED3" -Values "03" }
    if (IsChecked $Redux.Save.FireArrow)                { ChangeBytes -Offset "B71ED4" -Values "04" }
    if (IsChecked $Redux.Save.DinsFire)                 { ChangeBytes -Offset "B71ED5" -Values "05" }
    if (IsChecked $Redux.Save.OcarinaOfTime)            { ChangeBytes -Offset "B71ED7" -Values "08" }
    if (IsChecked $Redux.Save.Bombchu)                  { ChangeBytes -Offset "B71ED8" -Values "09"; ChangeBytes -Offset "B71EF0" -Values 50 -IsDec }
    if (IsChecked $Redux.Save.Hookshot)                 { ChangeBytes -Offset "B71ED9" -Values "0A" }
    if (IsChecked $Redux.Save.LongShot)                 { ChangeBytes -Offset "B71ED9" -Values "0B" }
    if (IsChecked $Redux.Save.IceArrow)                 { ChangeBytes -Offset "B71EDA" -Values "0C" }
    if (IsChecked $Redux.Save.FaroresWind)              { ChangeBytes -Offset "B71EDB" -Values "0D" }
    if (IsChecked $Redux.Save.LensOfTruth)              { ChangeBytes -Offset "B71EDD" -Values "0F" }
    if (IsChecked $Redux.Save.MegatonHammer)            { ChangeBytes -Offset "B71EDF" -Values "11" }
    if (IsChecked $Redux.Save.LightArrow)               { ChangeBytes -Offset "B71EE0" -Values "12" }
    if (IsChecked $Redux.Save.NayrusLove)               { ChangeBytes -Offset "B71EE1" -Values "13" }
    if (IsChecked $Redux.Save.Bottle1)                  { ChangeBytes -Offset "B71EE2" -Values "14" }
    if (IsChecked $Redux.Save.Bottle2)                  { ChangeBytes -Offset "B71EE3" -Values "14" }
    if (IsChecked $Redux.Save.Bottle3)                  { ChangeBytes -Offset "B71EE4" -Values "14" }
    if (IsChecked $Redux.Save.Bottle4)                  { ChangeBytes -Offset "B71EE5" -Values "14" }



    # STARTING SONGS #

    if (IsChecked $Redux.Save.ZeldasLullaby)      { ChangeBytes -Offset "B71F00" -Values "00 00 10 00" -Add }
    if (IsChecked $Redux.Save.EponasSong)         { ChangeBytes -Offset "B71F00" -Values "00 00 20 00" -Add }
    if (IsChecked $Redux.Save.SongOfTime)         { ChangeBytes -Offset "B71F00" -Values "00 01 00 00" -Add }
    if (IsChecked $Redux.Save.SongOfStorms)       { ChangeBytes -Offset "B71F00" -Values "00 02 00 00" -Add }
    if (IsChecked $Redux.Save.MinuetOfForest)     { ChangeBytes -Offset "B71F00" -Values "00 00 00 40" -Add }
    if (IsChecked $Redux.Save.BoleroOfFire)       { ChangeBytes -Offset "B71F00" -Values "00 00 00 80" -Add }
    if (IsChecked $Redux.Save.SerenadeOfWater)    { ChangeBytes -Offset "B71F00" -Values "00 00 01 00" -Add }
    if (IsChecked $Redux.Save.RequiemOfSpirit)    { ChangeBytes -Offset "B71F00" -Values "00 00 02 00" -Add }
    if (IsChecked $Redux.Save.NocturneOfShadow)   { ChangeBytes -Offset "B71F00" -Values "00 00 04 00" -Add }
    if (IsChecked $Redux.Save.PreludeOfLight)     { ChangeBytes -Offset "B71F00" -Values "00 00 08 00" -Add }



    # STARTING UPGRADES #

    if (IsChecked $Redux.Save.DekuNut)          { $value = Get8Bit (($Redux.Save.DekuNuts.SelectedIndex   + 1) * 16); ChangeBytes -Offset "B71EFD" -Values @($value, "00", "00") -Add; ChangeBytes -Offset "B71EE9" -Values $Redux.Capacity["DekuNuts" + ($Redux.Save.DekuNuts.SelectedIndex + 1)].Default -IsDec }
    if (IsChecked $Redux.Save.FairyBow)         { $value = Get8Bit (($Redux.Save.Quiver.SelectedIndex     + 1) * 1);  ChangeBytes -Offset "B71EFD" -Values @("00", "00", $value) -Add; ChangeBytes -Offset "B71EEB" -Values $Redux.Capacity["Quiver"   + ($Redux.Save.Quiver.SelectedIndex   + 1)].Default -IsDec }
    if (IsChecked $Redux.Save.Bomb)             { $value = Get8Bit (($Redux.Save.BombBag.SelectedIndex    + 1) * 8);  ChangeBytes -Offset "B71EFD" -Values @("00", "00", $value) -Add; ChangeBytes -Offset "B71EEA" -Values $Redux.Capacity["BombBag"  + ($Redux.Save.BombBag.SelectedIndex  + 1)].Default -IsDec }
    if (IsIndex   $Redux.Save.Strength -Not)    { $value = Get8Bit ($Redux.Save.Strength.SelectedIndex         * 64); ChangeBytes -Offset "B71EFD" -Values @("00", "00", $value) -Add }
    if (IsIndex   $Redux.Save.Scale    -Not)    { $value = Get8Bit ($Redux.Save.Scale.SelectedIndex            * 2);  ChangeBytes -Offset "B71EFD" -Values @("00", $value, "00") -Add }
    if (IsIndex   $Redux.Save.Wallet   -Not)    { $value = Get8Bit ($Redux.Save.Wallet.SelectedIndex           * 16); ChangeBytes -Offset "B71EFD" -Values @("00", $value, "00") -Add }

    if (IsDefault $Redux.Save.Hearts   -Not)   { $value = Get16Bit ([int]$Redux.Save.Hearts.Text * 16); ChangeBytes -Offset "B71E8A" -Values $value; ChangeBytes -Offset "B71E8C" -Values $value; ChangeBytes -Offset "B0635E" -Values $value; ChangeBytes -Offset "B06366" -Values $value }
    if (IsChecked $Redux.Save.DoubleDefense)   { ChangeBytes -Offset "B71E99" -Values "01"; ChangeBytes -Offset "B71F2B" -Values $Redux.Save.Hearts.Text -IsDec }
    if (IsChecked $Redux.Save.Magic)           { ChangeBytes -Offset "B71E96" -Values "01" }
    if (IsChecked $Redux.Save.DoubleMagic)     { ChangeBytes -Offset "B71E98" -Values "01"; ChangeBytes -Offset "B71E8F" -Values "60" }

    if (IsChecked $Redux.Capacity.EnableAmmo) {
        ChangeBytes -Offset "B71EE9" -Values $Redux.Capacity["DekuNuts" + ($Redux.Save.DekuNuts.SelectedIndex + 1)].Text -IsDec # Deku Nuts
        ChangeBytes -Offset "B71EEB" -Values $Redux.Capacity["Quiver"   + ($Redux.Save.Quiver.SelectedIndex   + 1)].Text -IsDec # Arrows
        ChangeBytes -Offset "B71EEA" -Values $Redux.Capacity["BombBag"  + ($Redux.Save.BombBag.SelectedIndex  + 1)].Text -IsDec # Bombs
    }



    # STARTING QUEST #

    if (IsChecked $Redux.Save.KokiriEmerald)         { ChangeBytes -Offset "B71F00" -Values "00 04 00 00" -Add }
    if (IsChecked $Redux.Save.GoronRuby)             { ChangeBytes -Offset "B71F00" -Values "00 08 00 00" -Add }
    if (IsChecked $Redux.Save.ZoraSapphire)          { ChangeBytes -Offset "B71F00" -Values "00 10 00 00" -Add }
    if (IsChecked $Redux.Save.ForestMedallion)       { ChangeBytes -Offset "B71F00" -Values "00 00 00 01" -Add }
    if (IsChecked $Redux.Save.FireMedallion)         { ChangeBytes -Offset "B71F00" -Values "00 00 00 02" -Add }
    if (IsChecked $Redux.Save.WaterMedallion)        { ChangeBytes -Offset "B71F00" -Values "00 00 00 04" -Add }
    if (IsChecked $Redux.Save.ShadowMedallion)       { ChangeBytes -Offset "B71F00" -Values "00 00 00 08" -Add }
    if (IsChecked $Redux.Save.SpiritMedallion)       { ChangeBytes -Offset "B71F00" -Values "00 00 00 10" -Add }
    if (IsChecked $Redux.Save.LightMedallion)        { ChangeBytes -Offset "B71F00" -Values "00 00 00 20" -Add }
    if (IsChecked $Redux.Save.GerudoCard)            { ChangeBytes -Offset "B71F00" -Values "00 40 00 00" -Add }
    if (IsChecked $Redux.Save.StoneOfAgony)          { ChangeBytes -Offset "B71F00" -Values "00 20 00 00" -Add }
    if (IsDefault $Redux.Save.GoldSkulltulas -Not)   { ChangeBytes -Offset "B71F2C" -Values (Get8Bit $Redux.Save.GoldSkulltulas.Text) }



    # STARTING DEBUG #

    if (IsChecked $Redux.Save.NoDungeonItems)   { ChangeBytes -Offset "B71FC0" -Values "00 00 00 00 00 00 00 00 00 00" }
    if (IsChecked $Redux.Save.NoDungeonKeys)    { ChangeBytes -Offset "B71FD4" -Values "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00" }
    if (IsChecked $Redux.Save.NoQuestStatus)    { ChangeBytes -Offset "B71FBC" -Values "00 00 00 00" }
    if (IsChecked $Redux.Save.NoItems)          { ChangeBytes -Offset "B71F8C" -Values "FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF" }
    if (IsChecked $Redux.Save.NoEquipment)      { ChangeBytes -Offset "B71FB4" -Values "11 00" }
    if (IsChecked $Redud.Save.NoUpgrades)       { ChangeBytes -Offset "B71FB9" -Values "00 00 00" }



    # AMMO CAPACITY #

    if (IsChecked $Redux.Capacity.EnableAmmo) {
        ChangeBytes -Offset "B6EC2F" -IsDec -Values @($Redux.Capacity.Quiver1.Text,   $Redux.Capacity.Quiver2.Text,   $Redux.Capacity.Quiver3.Text)   -Interval 2
        ChangeBytes -Offset "B6EC37" -IsDec -Values @($Redux.Capacity.BombBag1.Text,  $Redux.Capacity.BombBag2.Text,  $Redux.Capacity.BombBag3.Text)  -Interval 2
        ChangeBytes -Offset "B6EC67" -IsDec -Values @($Redux.Capacity.DekuNuts1.Text, $Redux.Capacity.DekuNuts2.Text, $Redux.Capacity.DekuNuts3.Text) -Interval 2

    }



    # WALLET CAPACITY #
    
    if (IsChecked $Redux.Capacity.EnableWallet) {
        $Wallet1 = Get16Bit $Redux.Capacity.Wallet1.Text; $Wallet2 = Get16Bit $Redux.Capacity.Wallet2.Text; $Wallet3 = Get16Bit $Redux.Capacity.Wallet3.Text; $Wallet4 = Get16Bit $Redux.Capacity.Wallet4.Text
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
        ChangeBytes -Offset "B6D579" -Values @($Redux.Capacity.Wallet1.Text.Length, $Redux.Capacity.Wallet2.Text.Length, $Redux.Capacity.Wallet3.Text.Length, $Redux.Capacity.Wallet4.Text.Length)                                       -Interval 2
    }



    # ITEM DROPS QUANTITY #

    if (IsChecked $Redux.Capacity.EnableDrops) {
        ChangeBytes -Offset "B6D4D1" -IsDec -Values @($Redux.Capacity.Arrows1x.Text,  $Redux.Capacity.Arrows2x.Text, $Redux.Capacity.Arrows3x.Text)                              -Interval 2
        ChangeBytes -Offset "B6D4C9" -IsDec -Values ($Redux.Capacity.Bombs1x.Text,    $Redux.Capacity.Bombs2x.Text,  $Redux.Capacity.Bombs3x.Text, $Redux.Capacity.Bombs4x.Text) -Interval 2
        ChangeBytes -Offset "B6D4D9" -IsDec -Values ($Redux.Capacity.DekuNuts1x.Text, $Redux.Capacity.DekuNuts2x.Text)                                                           -Interval 2
        $RupeeG = Get16Bit $Redux.Capacity.RupeeG.Text; $RupeeB = Get16Bit $Redux.Capacity.RupeeB.Text; $RupeeR = Get16Bit $Redux.Capacity.RupeeR.Text; $RupeeP = Get16Bit $Redux.Capacity.RupeeP.Text; $RupeeO = Get16Bit $Redux.Capacity.RupeeO.Text
        ChangeBytes -Offset "B6D4DC" -Values ($RupeeG + $RupeeB + $RupeeR + $RupeeP + $RupeeO)
    }



    # EQUIPMENT #

    if (IsChecked $Redux.Equipment.HerosBowIcons) {
        PatchBytes -Offset "7C0000" -Texture -Patch "Equipment\Bow\heros_bow.icon"
        PatchBytes -Offset "7F5000" -Texture -Patch "Equipment\Bow\heros_bow_fire.icon"
        PatchBytes -Offset "7F6000" -Texture -Patch "Equipment\Bow\heros_bow_ice.icon"
        PatchBytes -Offset "7F7000" -Texture -Patch "Equipment\Bow\heros_bow_light.icon"
        PatchBytes -Offset "89F800" -Texture -Patch "Equipment\Bow\heros_bow.en.label"
    }

    if (IsChecked $Redux.Equipment.UnsheathSword)         { ChangeBytes -Offset "BD04A0" -Values "28 42 00 05 14 40 00 05 00 00 10 25" }
    if (IsChecked $Redux.Equipment.HookshotIcon)          { PatchBytes  -Offset "7C7000" -Texture -Patch "Equipment\Hookshot\termina_hookshot.icon" }



    
    # SWORDS AND SHIELDS #

    if (TestFile ($GameFiles.textures + "\Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text + ".icon"))               { PatchBytes -Offset "7F9000" -Texture -Patch ("Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text + ".icon")     }
    if (TestFile ($GameFiles.textures + "\Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text + ".en.label"))           { PatchBytes -Offset "8ADC00" -Texture -Patch ("Equipment\Master Sword\" + $Redux.Equipment.MasterSword.text + ".en.label") }

    if ($AdultModel.hylian_shield -ne 0 -and (TestFile ($GameFiles.textures + "\Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".bin"))) {
        PatchBytes -Offset "F03400" -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".bin")
        $Offset = SearchBytes -Start "FBE000" -End "FEAF80" -Values "BE 35 BE 77 C6 B9 CE FB D6 FD D7 3D DF 3F DF 7F"
        if ($Offset -gt 0)                                                                                                       { PatchBytes -Offset $Offset  -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".bin")      }
    }
    if (TestFile ($GameFiles.textures + "\Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".icon"))             { PatchBytes -Offset "7FC000" -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".icon")     }
    if (TestFile ($GameFiles.textures + "\Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".en.label"))         { PatchBytes -Offset "8AE800" -Texture -Patch ("Equipment\Hylian Shield\" + $Redux.Equipment.HylianShield.text + ".en.label") }

    if ($AdultModel.mirror_shield -ne 0 -and (TestFile ($GameFiles.textures + "\Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".bin"))) {
        $Offset = SearchBytes -Start "F86000" -End "FBD800" -Values "90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90"
        PatchBytes -Offset $Offset -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".bin")
        if (TestFile ($GameFiles.textures + "\Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".chest"))        { PatchBytes -Offset "1616000" -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".chest")      }
        if (TestFile ($GameFiles.textures + "\Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".reflection"))   { PatchBytes -Offset "1456388" -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".reflection") }
    }
    if (TestFile ($GameFiles.textures + "\Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".icon"))             { PatchBytes -Offset "7FD000"  -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".icon")       }
    if (TestFile ($GameFiles.textures + "\Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + "." + ".en.label"))   { PatchBytes -Offset "8AEC00"  -Texture -Patch ("Equipment\Mirror Shield\" + $Redux.Equipment.MirrorShield.text + ".en.label")   }

    if     (IsChecked $Redux.Graphics.ListAdultMaleModels)            { $file = "Adult Male\"   + $Redux.Graphics.AdultMaleModels.Text.replace(" (default)", "")   }
    elseif (IsChecked $Redux.Graphics.ListAdultFeMaleModels)          { $file = "Adult Female\" + $Redux.Graphics.AdultFemaleModels.Text.replace(" (default)", "") }
    if     (TestFile ($GameFiles.models + "\" + $file + ".master"))   { PatchBytes -Offset "7F9000" -Models -Patch ($file + ".master") }
    if     (TestFile ($GameFiles.models + "\" + $file + ".hylian"))   { PatchBytes -Offset "7FC000" -Models -Patch ($file + ".hylian") }
    if     (TestFile ($GameFiles.models + "\" + $file + ".mirror"))   { PatchBytes -Offset "7FD000" -Models -Patch ($file + ".mirror") }

    

    # HITBOX #

    if (IsValue -Elem $Redux.Hitbox.MasterSword       -Not)   { ChangeBytes -Offset "B6DB14" -Values (ConvertFloatToHex $Redux.Hitbox.MasterSword.Value)       }
    if (IsValue -Elem $Redux.Hitbox.GiantsKnife       -Not)   { ChangeBytes -Offset "B6DB1C" -Values (ConvertFloatToHex $Redux.Hitbox.GiantsKnife.Value)       }
    if (IsValue -Elem $Redux.Hitbox.BrokenGiantsKnife -Not)   { ChangeBytes -Offset "B7E8CC" -Values (ConvertFloatToHex $Redux.Hitbox.BrokenGiantsKnife.Value) }
    if (IsValue -Elem $Redux.Hitbox.MegatonHammer     -Not)   { ChangeBytes -Offset "B6DB24" -Values (ConvertFloatToHex $Redux.Hitbox.MegatonHammer.Value)     }
    if (IsValue -Elem $Redux.Hitbox.ShieldRecoil      -Not)   { ChangeBytes -Offset "BD4162" -Values (Get16Bit ($Redux.Hitbox.ShieldRecoil.Value + 45000))     }
    if (IsValue -Elem $Redux.Hitbox.Hookshot          -Not)   { ChangeBytes -Offset "CAD3C7" -Values (Get8Bit $Redux.Hitbox.Hookshot.Value)                    }
    if (IsValue -Elem $Redux.Hitbox.Longshot          -Not)   { ChangeBytes -Offset "CAD3B7" -Values (Get8Bit $Redux.Hitbox.Longshot.Value)                    }

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    if (IsInterface -Streamlined)   { CreateOptionsDialog -Columns 6 -Height 640 -Tabs @("Main", "Graphics", "Audio", "Equipment")                               -NoLanguages }
    else                            { CreateOptionsDialog -Columns 6 -Height 735 -Tabs @("Main", "Graphics", "Audio", "Colors", "Equipment", "Save", "Capacity") -NoLanguages }

}



#==============================================================================================================================================================================================
function CreateTabMain() {

    # GAMEPLAY #

    CreateReduxGroup    -Tag  "Gameplay"               -Text "Gameplay" 
    CreateReduxCheckBox -Name "FasterBlockPushing"     -Text "Faster Block Pushing"     -Info "All blocks are pushed faster"                                                                       -Checked -Credits "GhostlyDark (Ported from Redux)"
    CreateReduxCheckBox -Name "EasierMinigames"        -Text "Easier Minigames"         -Info "Bombchu Bowling prizes now appear in fixed order instead of random"                                          -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "DistantZTargeting"      -Text "Distant Z-Targeting"      -Info "Allow to use Z-Targeting on enemies, objects and NPC's from any distance"                                    -Credits "Admentus"
    CreateReduxCheckBox -Name "ManualJump"             -Text "Manual Jump"              -Info "Press Z + A to do a Manual Jump instead of a Jump Attack`nPress B mid-air after jumping to do a Jump Attack" -Credits "Admentus (ROM) & CloudModding (GameShark)"
    CreateReduxCheckBox -Name "NoKillFlash"            -Text "No Kill Flash"            -Info "Disable the flash effect when killing certain enemies such as the Guay or Skullwalltula"                     -Credits "Chez Cousteau"
    CreateReduxCheckBox -Name "NoShieldRecoil"         -Text "No Shield Recoil"         -Info "Disable the recoil when being hit while shielding"                                                           -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxCheckBox -Name "RunWhileShielding"      -Text "Run While Shielding"      -Info "Press R to shield will no longer prevent Link from moving around" -Link $Redux.Gameplay.NoShieldRecoil       -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxCheckBox -Name "PushbackAttackingWalls" -Text "Pushback Attacking Walls" -Info "Link is getting pushed back a bit when hitting the wall with the sword"                                      -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxCheckBox -Name "RemoveCrouchStab"       -Text "Remove Crouch Stab"       -Info "The Crouch Stab move is removed"                                                                             -Credits "Garo-Mastah"



    # RESTORE #

    CreateReduxGroup    -Tag  "Restore"     -Text "Restore / Correct / Censor"
    CreateReduxCheckBox -Name "RupeeColors" -Text "Correct Rupee Colors"  -Info "Corrects the colors for the Purple (50) and Golden (200) Rupees"         -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "CowNoseRing" -Text "Restore Cow Nose Ring" -Info "Restore the rings in the noses for Cows as seen in the Japanese release" -Credits "ShadowOne333"
    CreateReduxCheckBox -Name "Blood"       -Text "Blood Color"           -Info "Change the color of blood used for several monsters"                     -Credits "Admentus"



    # OTHER #

    CreateReduxGroup    -Tag  "Other" -Text "Other"
    CreateReduxCheckBox -Name "DefaultZTargeting" -Text "Default Hold Z-Targeting" -Info "Change the Default Z-Targeting option to Hold instead of Switch"                                        -Credits "Ported from Redux"
    CreateReduxCheckBox -Name "ItemSelect"        -Text "Translate Item Select"    -Info "Translates the Debug Inventory Select menu into English"                                                -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "DiskDrive"         -Text "Enable Disk Drive Saves"  -Info "Use the Disk Drive for Save Slots" -Warning "This option disables the use of non-Disk Drive save slots" -Credits "ZethN64, Sakura, Frostclaw, Steve(ToCoool) & GhostlyDark (ported)"
    
    $Last.Column = 1; $Last.Row++
    CreateReduxComboBox -Name "MapSelect" -Text "Enable Map Select" -Items @("Disable", "Translate Only", "Enable Only", "Translate and Enable") -Info "Enable the Map Select menu like in the Debug ROM`nThe File Select menu now opens the Map Select menu instead`nA separate debug save file is used" -Credits "Jared Johnson (translated by Zelda Edit)"
    CreateReduxComboBox -Name "SkipIntro" -Text "Skip Intro"        -Items @("Don't Skip", "Skip Logo", "Skip Title Screen", "Skip Logo and Title Screen") -Info "Skip the logo, title screen or both"                                         -Credits "Aegiker"
    CreateReduxComboBox -Name "Skybox"    -Text "Skybox" -Default 4 -Items @("Dawn", "Day", "Dusk", "Night", "Darkness (Dawn)", "Darkness (Day)", "Darkness (Dusk)", "Darkness (Night)") -Info "Set the skybox theme for the File Select menu" -Credits "Admentus"



    # SKIP #

    CreateReduxGroup    -Tag  "Skip"            -Text "Skip Cutscenes"
    CreateReduxCheckBox -Name "OpeningCutscene" -Text "Opening Cutscene" -Info "Skip the introduction cutscene, so you can start playing immediately" -Credits "Ported from Better OoT"



    # SPEED #

    CreateReduxGroup  -Tag  "Gameplay" -Text "Speed" -Height 1.2
    CreateReduxSlider -Name "MovementSpeed" -Default 600  -Min 300 -Max 1200 -Freq 50 -Small 25 -Large 50 -Text "Link's Speed" -Info "Adjust the movement speed for Link" -Credits "AndiiSyn"



    # TEXT SPEED #

    CreateReduxGroup    -Tag  "Text"       -Text "Text Options"
    CreateReduxCheckBox -Name "Speed2x"    -Text "2x Text Speed"                                                                                                          -Info "Set the dialogue text speed to be twice as fast"          -Credits "Ported from Redux"
    CreateReduxComboBox -Name "NaviPrompt" -Text "Navi A Button Prompt" -Items @("Hidden", "Navi") -FilePath ($GameFiles.textures + "\Action Prompts\Navi") -Ext "prompt" -Info "Replace the A Button prompt for Navi"                     -Credits "Aegiker & GhostlyDark (texture fix, injects)"
    CreateReduxComboBox -Name "NaviCUp"    -Text "Navi C-Up Prompt"     -Items @("Nite")           -FilePath ($GameFiles.textures + "\Action Prompts\Navi") -Ext "cup"    -Info "Replace the C-Up Buttn prompt for Navi`nNot for Japanese" -Credits "GhostlyDark (injects)"



    # HERO MODE #

    CreateReduxGroup    -Tag  "Hero" -Text "Hero Mode"
    CreateReduxComboBox -Name "Damage"           -Text "Damage"      -Items @("1x Damage", "2x Damage", "4x Damage", "8x Damage", "OHKO Mode")        -Info "Set the amount of damage you receive`nOHKO Mode = You die in one hit"                                   -Credits "Admentus"
    CreateReduxComboBox -Name "Recovery"         -Text "Recovery"    -Items @("1x Recovery", "1/2x Recovery", "1/4x Recovery", "0x Recovery")         -Info "Set the amount health you recovery from Recovery Hearts`nRecovery Heart drops are removed if set to 0x" -Credits "Admentus & Rando (No Heart Drops)"
    CreateReduxComboBox -Name "MagicUsage"       -Text "Magic Usage" -Items @("1x Magic Usage", "2x Magic Usage", "4x Magic Usage", "8x Magic Usage") -Info "Set the amount of times magic is consumed at"                                                           -Credits "Admentus"
    CreateReduxCheckBox -Name "NoRecoveryHearts" -Text "No Recovery Heart Drops" -Info "Disable Recovery Hearts from spawning from item drops"                                                                                                                 -Credits "Ported from Rando"
    CreateReduxCheckBox -Name "NoItemDrops"      -Text "No Item Drops"           -Info "Disable all items from spawning"                                                                                                                                       -Credits "Admentus & BilonFullHDemon"

    $Redux.Hero.Damage.Add_SelectedIndexChanged({ EnableElem -Elem $Redux.Hero.Recovery -Active ($this.text -ne "OHKO Mode") })
    EnableElem -Elem ($Redux.Hero.Recovery) -Active ($Redux.Hero.Damage.text -ne "OHKO Mode")

}



#==============================================================================================================================================================================================
function CreateTabGraphics() {
    
    # GRAPHICS #

    CreateReduxGroup -Tag  "Graphics" -Text "Graphics" -Columns 4

    CreateReduxCheckBox -Name "WidescreenAlt"   -Text "16:9 Widescreen (Simplified)" -Info "Apply 16:9 Widescreen adjusted backgrounds and textures (as well as 16:9 Widescreen for the Wii VC)" -Credits "Aspect Ratio Fix by Admentus`n16:9 backgrounds by GhostlyDark, ShadowOne333 & CYB3RTRON"
    CreateReduxCheckBox -Name "ExtendedDraw"    -Text "Extended Draw Distance"       -Info "Increases the game's draw distance for objects`nDoes not work on all objects"                        -Credits "Admentus"
    CreateReduxCheckBox -Name "ForceHiresModel" -Text "Force Hires Link Model"       -Info "Always use Link's High Resolution Model when Link is too far away"                                   -Credits "GhostlyDark"
    CreateReduxCheckBox -Name "HideEquipment"   -Text "Hide Equipment"               -Info "Hide the equipment when it is sheathed"                                                              -Credits "XModxGodX"
    CreateReduxCheckBox -Name "Chests"          -Text "Treasure Chests"              -Info "Use a different style for treasure chests"                                                           -Credits "AndiiSyn"

    $Models = LoadModelsList -Category "Adult"
    CreateReduxComboBox -Name "AdultModels" -Text "Adult Model" -Items (@("Original") + $Models) -Default "Original" -Info "Replace the adult model used for Link"



    # MODELS PREVIEW #

    $Redux.Graphics.ModelPreviews = CreateReduxGroup -Tag "Graphics" -Text "Model Previews"
    $Last.Group.Height = (DPISize 222)

    CreateImageBox -x 115 -y 20 -w 134 -h 190 -Name "ModelsPreviewAdult"
    $global:PreviewToolTip = CreateToolTip
    ChangeModelsSelection
    


    # INTERFACE #

    CreateReduxGroup    -Tag  "UI" -Text "Interface"
    $Last.Group.Width = $Redux.Groups[$Redux.Groups.Length-3].Width; $Last.Group.Top = $Redux.Groups[$Redux.Groups.Length-3].Bottom + 5; $Last.Width = 4;
    CreateReduxCheckBox -Name "Rupees"           -Text "MM Rupee Icon"       -Info "Replace the rupees icon with that from Majora's Mask"                                     -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "DungeonKeys"      -Text "MM Key Icon"         -Info "Replace the key icon with that from Majora's Mask"                                        -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "DungeonIcons"     -Text "MM Dungeon Icons"    -Info "Replace the dungeon map icons with those from Majora's Mask"                              -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "ButtonPositions"  -Text "MM Button Positions" -Info "Positions the A and B buttons like in Majora's Mask"                                      -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "CenterNaviPrompt" -Text "Center Navi Prompt"  -Info 'Centers the "Navi" prompt shown in the C-Up button'                                       -Credits "Ported by GhostlyDark"
    CreateReduxCheckBox -Name "GCScheme"         -Text "GC Scheme"           -Info "Replace and change the textures, dialogue and text colors to match the GameCube's scheme" -Credits "Admentus, GhostlyDark, ShadowOne333 & Ported from Redux"
    CreateReduxComboBox -Name "BlackBars"        -Text "Black Bars"  -Items @("Enabled", "Disabled for Z-Targeting", "Disabled for Cutscenes", "Always Disabled") -Info "Removes the black bars shown on the top and bottom of the screen during Z-targeting and cutscenes" -Credits "Admentus"
    CreateReduxComboBox -Name "ButtonSize"       -Text "HUD Buttons"                                           -FilePath ($Paths.shared + "\Buttons")    -Ext $null -Default "Large"           -Info "Set the size for the HUD buttons"  -Credits "GhostlyDark (ported)"
    $path = $Paths.shared + "\Buttons" + "\" + $Redux.UI.ButtonSize.Text.replace(" (default)", "")
    CreateReduxComboBox -Name "ButtonStyle"      -Text "HUD Buttons" -Items @("Ocarina of Time", "Gold Quest") -FilePath $path                           -Ext "bin" -Default "Ocarina of Time" -Info "Set the style for the HUD buttons" -Credits "GhostlyDark, Pizza (HD), Djipi, Community, Nerrel, Federelli, AndiiSyn"
    CreateReduxComboBox -Name "Hearts"           -Text "Heart Icons" -Items @("Ocarina of Time", "Gold Quest") -FilePath ($Paths.shared + "\HUD\Hearts") -Ext "bin" -Default "Ocarina of Time" -Info "Set the style for the heart icons" -Credits "Ported by GhostlyDark & AndiiSyn"
    CreateReduxComboBox -Name "Magic"            -Text "Magic Bar"   -Items @("Ocarina of Time")               -FilePath ($Paths.shared + "\HUD\Magic")  -Ext "bin" -Default "Ocarina of Time" -Info "Set the style for the magic meter" -Credits "GhostlyDark, Pizza, Nerrel (HD), Zeth Alkar"



    # ANIMATIONS #

    CreateReduxGroup    -Tag  "Animation"        -Text "Link Animations"
    CreateReduxCheckBox -Name "Feminine"         -Text "Feminine Animations"    -Info "Use feminine animations for Link`nThis applies to both models`nIt works best with the Aria model" -Credits "GhostlyDark (ported) & AriaHiro64 (model)"
    $weapons = "`n`nAffected weapons:`n- Giant's Knife`n- Giant's Knife (Broken)`n- Biggoron Sword`n- Deku Stick`n- Megaton Hammer"
    CreateReduxCheckBox -Name "WeaponIdle"       -Text "2-handed Weapon Idle"   -Info ("Restore the beta animation when idly holding a two-handed weapon" + $weapons)                       -Credits "Admentus"
    CreateReduxCheckBox -Name "WeaponCrouch"     -Text "2-handed Weapon Crouch" -Info ("Restore the beta animation when crouching with a two-handed weapon" + $weapons)                     -Credits "Admentus"
    CreateReduxCheckBox -Name "WeaponAttack"     -Text "2-handed Weapon Attack" -Info ("Restore the beta animation when attacking with a two-handed weapon" + $weapons)                     -Credits "Admentus"
    CreateReduxCheckBox -Name "HoldShieldOut"    -Text "Hold Shield Out"        -Info "Restore the beta animation for Link to always holds his shield out even when his sword is sheathed"  -Credits "Admentus"
    CreateReduxCheckBox -Name "BombBag"          -Text "Bomb Bag"               -Info "Restore the beta animation for the bomb bag"                                                         -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxCheckBox -Name "BackflipAttack"   -Text "Backflip Jump Attack"   -Info "Restore the beta animation to turn the Jump Attack into a Backflip Jump Attack"                      -Credits "Admentus"
    CreateReduxCheckBox -Name "FrontflipAttack"  -Text "Frontflip Jump Attack"  -Info "Restore the beta animation to turn the Jump Attack into a Frontflip Jump Attack"                     -Credits "Admentus" -Link $Redux.Animation.BackflipAttack
    CreateReduxCheckBox -Name "FrontflipJump"    -Text "Frontflip Jump"         -Info "Replace the jumps with frontflip jumps"                                                              -Credits "SoulofDeity"
    CreateReduxCheckBox -Name "SomarsaultJump"   -Text "Somarsault Jump"        -Info "Replace the jumps with somarsault jumps"                                                             -Credits "SoulofDeity" -Link $Redux.Animation.FrontflipJump
    

    
    # HIDE HUD #

    CreateReduxGroup    -Tag  "Hide"         -Text "Hide HUD"                -Columns 4 -Beginner -Streamlined
    CreateReduxCheckBox -Name "Interface"    -Text "Hide Interface"          -Info "Hide the whole interface"                                     -Credits "Admentus"

    CreateReduxGroup    -Tag  "Hide"         -Text "Hide HUD"                -Columns 4 -Lite -Advanced
    CreateReduxCheckBox -Name "AButton"      -Text "Hide A Button"           -Info "Hide the A Button"                                            -Credits "Admentus"
    CreateReduxCheckBox -Name "BButton"      -Text "Hide B Button"           -Info "Hide the B Button"                                            -Credits "Admentus"
    CreateReduxCheckBox -Name "StartButton"  -Text "Hide Start Button"       -Info "Hide the Start Button"                                        -Credits "Admentus" 
    CreateReduxCheckBox -Name "CUpButton"    -Text "Hide C-Up Button"        -Info "Hide the C-Up Button"                                         -Credits "Admentus"
    CreateReduxCheckBox -Name "CLeftButton"  -Text "Hide C-Left Button"      -Info "Hide the C-Left Button"                                       -Credits "Admentus"
    CreateReduxCheckBox -Name "CDownButton"  -Text "Hide C-Down Button"      -Info "Hide the C-Down Button"                                       -Credits "Admentus"
    CreateReduxCheckBox -Name "CRightButton" -Text "Hide C-Right Button"     -Info "Hide the C-Right Button"                                      -Credits "Admentus"
    CreateReduxCheckBox -Name "Hearts"       -Text "Hide Hearts"             -Info "Hide the Hearts display"                                      -Credits "Admentus"
    CreateReduxCheckBox -Name "Magic"        -Text "Hide Magic"              -Info "Hide the Magic display"                                       -Credits "Admentus"
    CreateReduxCheckBox -Name "Rupees"       -Text "Hide Rupees"             -Info "Hide the the Rupees display"                                  -Credits "Admentus"
    CreateReduxCheckBox -Name "DungeonKeys"  -Text "Hide Keys"               -Info "Hide the Keys display shown in several dungeons and areas"    -Credits "Admentus"
    CreateReduxCheckBox -Name "Carrots"      -Text "Hide Epona Carrots"      -Info "Hide the Epona Carrots display"                               -Credits "Admentus"
    CreateReduxCheckBox -Name "AreaTitle"    -Text "Hide Area Title Card"    -Info "Hide the area title that displays when entering a new area"   -Credits "Admentus"
    CreateReduxCheckBox -Name "DungeonTitle" -Text "Hide Dungeon Title Card" -Info "Hide the dungeon title that displays when entering a dungeon" -Credits "Admentus"
    CreateReduxCheckBox -Name "Icons"        -Text "Hide Icons"              -Info "Hide the Clock and Score Counter icons display"               -Credits "Admentus"



    # HUD PREVIEWS #

    CreateReduxGroup -Tag "UI" -Text "HUD Previews"
    $Last.Group.Height = (DPISize 140)

    CreateImageBox -x 40  -y 30 -w 90  -h 90 -Name "ButtonPreview";      $Redux.UI.ButtonSize.Add_SelectedIndexChanged( { ShowHUDPreview -IsOoT } );   $Redux.UI.ButtonStyle.Add_SelectedIndexChanged( { ShowHUDPreview -IsOoT } )
    CreateImageBox -x 160 -y 35 -w 40  -h 40 -Name "HeartsPreview";      if (IsInterface -Lite -Advanced -Streamlined) { $Redux.UI.Hearts.Add_SelectedIndexChanged(   { ShowHUDPreview -IsOoT } ) }
    CreateImageBox -x 220 -y 35 -w 40  -h 40 -Name "RupeesPreview";      if (IsInterface -Lite -Advanced -Streamlined) { $Redux.UI.Rupees.Add_CheckStateChanged(      { ShowHUDPreview -IsOoT } ) }
    CreateImageBox -x 280 -y 35 -w 40  -h 40 -Name "DungeonKeysPreview"; if (IsInterface -Lite -Advanced -Streamlined) { $Redux.UI.DungeonKeys.Add_CheckStateChanged( { ShowHUDPreview -IsOoT } ) }
    CreateImageBox -x 140 -y 85 -w 200 -h 40 -Name "MagicPreview";       if (IsInterface -Lite -Advanced -Streamlined) { $Redux.UI.Magic.Add_SelectedIndexChanged(    { ShowHUDPreview -IsOoT } ) }
    
    ShowHUDPreview -IsOoT
    if (IsInterface -Beginner) { $Redux.UI.HUD.Add_CheckStateChanged( { ShowHUDPreview -IsOoT } ) }
    
}



#==============================================================================================================================================================================================
function CreateTabAudio() {
    
    # SOUNDS / VOICES #

    CreateReduxGroup    -Tag  "Sounds" -Text "Sounds / Voices"
    CreateReduxComboBox -Name "AdultVoices" -Text "Adult Voice" -Items @("Original") -FilePath ($GameFiles.binaries + "\Voices Adult") -Default "Original" -Info "Replace the voice used for the Adult Link Model" -Credits "`nMajora's Mask: Korey Cryderman (ported) & GhostlyDark (corrected)`nMelee Zelda: Thiago Alcântara 6 & theluigidude2007 (edits)`nAmara: Amara (ripping) & theluigidude2007`nPeach: theluigidude2007"
    CreateReduxComboBox -Name "Instrument"  -Text "Instrument"  -Items @("Ocarina", "Female", "Voice", "Whistle Harp", "Grind-Organ", "Flute") -Info "Replace the sound used for playing the Ocarina of Time" -Credits "Ported from Rando"



    # SFX SOUND EFFECTS #

    $SFX = @("Default", "Disabled", "Soft Beep", "Bark", "Bomb Bounce", "Bongo Bongo Low", "Bow Twang", "Business Scrub", "Carrot Refill", "Cluck", "Great Fairy", "Drawbridge Set", "Guay", "Horse Trot", "HP Recover", "Iron Boots", "Moo", "Mweep!", 'Navi "Hey!"', "Navi Random", "Notification", "Pot Shattering", "Ribbit", "Rupee (Silver)", "Switch", "Sword Bonk", "Tambourine", "Timer", "Zelda Gasp (Adult)")
    
    CreateReduxGroup    -Tag "SFX" -Text "SFX Sound Effects" -Beginner -Streamlined
    CreateReduxComboBox -Name "LowHP"      -Text "Low HP"      -Items $SFX -Info "Set the sound effect for the low HP beeping"                      -Credits "Ported from Rando"

    CreateReduxGroup    -Tag "SFX" -Text "SFX Sound Effects" -Lite -Advanced
    CreateReduxComboBox -Name "LowHP"      -Text "Low HP"      -Items $SFX -Info "Set the sound effect for the low HP beeping"                      -Credits "Ported from Rando"
    $SFX = @("Default",  "Disabled", "Soft Beep", "Bark", "Business Scrub", "Carrot Refill", "Cluck", "Cockadoodledoo", "Dusk Howl", "Exploding Crate", "Explosion", "Great Fairy", "Guay", "Horse Neigh", "HP Low", "HP Recover", "Ice Shattering", "Moo", "Meweep!", 'Navi "Hello!"', "Notification", "Pot Shattering", "Redead Scream", "Ribbit", "Ruto Giggle", "Skulltula", "Tambourine", "Timer", "Zelda Gasp (Adult)")
    CreateReduxComboBox -Name "Navi"       -Text "Navi"        -Items $SFX -Info "Replace the sound used for Navi when she wants to tell something" -Credits "Ported from Rando"
    CreateReduxComboBox -Name "ZTarget"    -Text "Z-Target"    -Items $SFX -Info "Replace the sound used for Z-Targeting enemies"                   -Credits "Ported from Rando"
    CreateReduxComboBox -Name "HoverBoots" -Text "Hover Boots" -Items @("Default", "Disabled", "Bark", "Cartoon Fall", "Flare Dancer Laugh", "Mweep!", "Shabom Pop", "Tambourine")                            -Info "Replace the sound used for the Hover Boots"   -Credits "Ported from Rando"
    CreateReduxComboBox -Name "Horse"      -Text "Horse Neigh" -Items @("Default", "Disabled", "Armos", "Child Scream", "Great Fairy", "Moo", "Mweep!", "Redead Scream", "Ruto Wiggle", "Stalchild Attack")   -Info "Replace the sound for horses when neighing"   -Credits "Ported from Rando"
    CreateReduxComboBox -Name "Nightfall"  -Text "Nightfall"   -Items @("Default", "Disabled", "Cockadoodledoo", "Gold Skull Token", "Great Fairy", "Moo", "Mweep!", "Redead Moan", "Talon Snore", "Thunder") -Info "Replace the sound used when Nightfall occurs" -Credits "Ported from Rando"
    $SFX = @("Default", "Disabled", "Soft Beep", "Bark", "Bomb Bounce", "Bongo Bongo High", "Bongo Bongo Low", "Bottle Cork", "Bow Twang", "Bubble Laugh", "Carrot Refill", "Change Item", "Child Pant", "Cluck", "Deku Baba", "Drawbridge Set", "Dusk Howl", "Fanfare (Light)", "Fanfare (Medium)", "Field Shrub", "Flare Dancer Startled",
    'Ganondorf "Teh"', "Gohma Larva Croak", "Gold Skull Token", "Goron Wake", "Guay", "Gunshot", "Hammer Bonk", "Horse Trot", "HP Low", "HP Recover", "Iron Boots", "Iron Knuckle", "Moo", "Mweep!", "Notification", "Phantom Ganon Laugh", "Plant Explode", "Pot Shattering", "Redead Moan", "Ribbit", "Rupee", "Rupee (Silver)", "Ruto Crash",
    "Ruto Lift", "Ruto Thrown", "Scrub Emerge", "Shabom Bounce", "Shabom Pop", "Shellblade", "Skulltula", "Spit Nut", "Switch", "Sword Bonk", 'Talon "Hmm"', "Talon Snore", "Talon WTF", "Tambourine", "Target Enemy", "Target Neutral", "Thunder", "Timer", "Zelda Gasp (Adult)")
    CreateReduxComboBox -Name "FileCursor" -Text "File Cursor" -Items $SFX -Info "Replace the sound used when moving the cursor in the File Select menu"   -Credits "Ported from Rando"
    CreateReduxComboBox -Name "FileSelect" -Text "File Select" -Items $SFX -Info "Replace the sound used when selecting something in the File Select menu" -Credits "Ported from Rando"
    
}



#==============================================================================================================================================================================================
function CreateTabColors() {

    # EQUIPMENT COLORS #

    CreateReduxGroup -Tag "Colors" -Text "Equipment Colors"
    $Redux.Colors.Equipment = @()
    $Items = @("Kokiri Green", "Goron Red", "Zora Blue"); $PostItems = @("Randomized", "Custom"); $Files = ($GameFiles.Textures + "\Tunic"); $Randomize = '"Randomized" fully randomizes the colors each time the patcher is opened'
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "KokiriTunic" -Column 1 -Row 1 -Text "Kokiri Tunic Color" -Default 1 -Length 230 -Shift 40 -Items $Items -PostItems $PostItems -FilePath $Files -Info ("Select a color scheme for the Kokiri Tunic`n" + $Randomize) -Credits "Ported from Rando"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "GoronTunic"  -Column 1 -Row 2 -Text "Goron Tunic Color"  -Default 2 -Length 230 -Shift 40 -Items $Items -PostItems $PostItems -FilePath $Files -Info ("Select a color scheme for the Goron Tunic`n" + $Randomize)  -Credits "Ported from Rando"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "ZoraTunic"   -Column 1 -Row 3 -Text "Zora Tunic Color"   -Default 3 -Length 230 -Shift 40 -Items $Items -PostItems $PostItems -FilePath $Files -Info ("Select a color scheme for the Zora Tunic`n" + $Randomize)   -Credits "Ported from Rando"
    $Items = @("Silver", "Gold", "Black", "Green", "Blue", "Bronze", "Red", "Sky Blue", "Pink", "Magenta", "Orange", "Lime", "Purple", "Randomized", "Custom")
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "SilverGauntlets"   -Column 4 -Row 1 -Text "Silver Gauntlets Color"    -Default 1 -Length 230 -Shift 40 -Items $Items -Info ("Select a color scheme for the Silver Gauntlets`n" + $Randomize) -Credits "Ported from Rando"
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "GoldenGauntlets"   -Column 4 -Row 2 -Text "Golden Gauntlets Color"    -Default 2 -Length 230 -Shift 40 -Items $Items -Info ("Select a color scheme for the Golden Gauntlets`n" + $Randomize) -Credits "Ported from Rando"
    $Items =  @("Red", "Green", "Blue", "Yellow", "Cyan", "Magenta", "Orange", "Gold", "Purple", "Pink", "Randomized", "Custom")
    $Redux.Colors.Equipment += CreateReduxComboBox -Name "MirrorShieldFrame" -Column 4 -Row 3 -Text "Mirror Shield Frame Color" -Default 1 -Length 230 -Shift 40 -Items $Items -Info ("Select a color scheme for the Mirror Shield Frame`n" + $Randomize) -Warning "This option might not work for every custom player model" -Credits "Ported from Rando"

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

    CreateFairyColorOptions -Name "Navi"



    # MISC COLORS #

    CreateReduxGroup -Tag "Colors" -Text "Misc Colors"

    CreateReduxCheckBox -Name "PauseScreenColors" -Text "MM Pause Screen Colors" -Info "Use the Pause Screen color scheme from Majora's Mask" -Credits "Garo-Mastah"

}



#==============================================================================================================================================================================================
function CreateTabEquipment() {
    
    # EQUIPMENT #

    CreateReduxGroup    -Tag  "Equipment" -Text "Equipment Adjustments"
    CreateReduxCheckBox -Name "UnsheathSword"       -Text "Unsheath Sword"        -Info "The sword is unsheathed first before immediately swinging it" -Credits "Admentus"
    CreateReduxCheckBox -Name "HerosBowIcons"       -Text "Hero's Bow Icons"      -Info "Use the Hero's Bow icons for the Fairy Bow"                   -Credits "GhostlyDark (ported)"
    CreateReduxCheckBox -Name "HookshotIcon"        -Text "Termina Hookshot Icon" -Info "Use the Termina Hookshot icon for the regular Hookshot"       -Credits "GhostlyDark (ported)"
    
    CreateReduxGroup    -Tag  "Equipment" -Text "Swords and Shields" -Beginner -Lite -Advanced
    CreateReduxComboBox -Name "MasterSword"   -Text "Master Sword"  -Items @("Master Sword")  -FilePath ($GameFiles.Textures + "\Equipment\Master Sword")  -Ext @("icon", "bin")   -Info "Select an alternative for the appearence of the Master Sword"  -Credits "Admentus & GhostlyDark (injects) & CYB3RTR0N (beta icon)"
    CreateReduxComboBox -Name "HylianShield"  -Text "Hylian Shield" -Items @("Hylian Shield") -FilePath ($GameFiles.Textures + "\Equipment\Hylian Shield") -Ext @("icon", "bin")   -Info "Select an alternative for the appearence of the Hylian Shield" -Credits "Admentus & GhostlyDark (injects), CYB3RTR0N (icons) & sanguinetti (Beta / Red Shield textures)"
    CreateReduxComboBox -Name "MirrorShield"  -Text "Mirror Shield" -Items @("Mirror Shield") -FilePath ($GameFiles.Textures + "\Equipment\Mirror Shield") -Ext @("icon", "bin")   -Info "Select an alternative for the appearence of the Mirror Shield" -Credits "Admentus & GhostlyDark (injects)"



    # HITBOX #

    CreateReduxGroup  -Tag  "Hitbox" -Text "Sliders" -Height 4.2 -Beginner -Lite -Advanced
    CreateReduxSlider -Name "MasterSword"       -Column 1 -Row 1 -Default 4000  -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512   -Text "Master Sword"    -Info "Set the length of the hitbox of the Master Sword"                   -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "GiantsKnife"       -Column 3 -Row 1 -Default 5500  -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512   -Text "Giant's Knife"   -Info "Set the length of the hitbox of the Giant's Knife / Biggoron Sword" -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "BrokenGiantsKnife" -Column 5 -Row 1 -Default 1500  -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512   -Text "Broken Knife"    -Info "Set the length of the hitbox of the Broken Giant's Knife"           -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "MegatonHammer"     -Column 1 -Row 2 -Default 2500  -Min 512 -Max 8192 -Freq 512 -Small 256 -Large 512   -Text "Megaton Hammer"  -Info "Set the length of the hitbox of the Megaton Hammer"                 -Credits "Aria Hiroshi 64"
    CreateReduxSlider -Name "ShieldRecoil"      -Column 3 -Row 2 -Default 4552  -Min 0   -Max 8248 -Freq 512 -Small 256 -Large 512   -Text "Shield Recoil"   -Info "Set the pushback distance when getting hit while shielding"         -Credits "Admentus (ROM) & Aegiker (GameShark)"
    CreateReduxSlider -Name "Hookshot"          -Column 1 -Row 3 -Default 13    -Min 0   -Max 255  -Freq 16  -Small 8   -Large 16    -Text "Hookshot Length" -Info "Set the length of the Hookshot"                                     -Credits "AndiiSyn"
    CreateReduxSlider -Name "Longshot"          -Column 3 -Row 3 -Default 26    -Min 0   -Max 255  -Freq 16  -Small 8   -Large 16    -Text "Longshot Length" -Info "Set the length of the Longshot"                                     -Credits "AndiiSyn"



    # EQUIPMENT PREVIEWS #

    if (IsInterface -Streamlined) { return }

    CreateReduxGroup -Tag "Equipment" -Text "Equipment Previews"
    $Last.Group.Height = (DPISize 140)

    CreateImageBox -x 320 -y 30 -w 80 -h 80  -Name "HylianShieldIconPreview"
    CreateImageBox -x 440 -y 10 -w 80 -h 120 -Name "HylianShieldPreview";    $Redux.Equipment.HylianShield.Add_SelectedIndexChanged( { ShowEquipmentPreview } )
    CreateImageBox -x 600 -y 30 -w 80 -h 80  -Name "MirrorShieldIconPreview"
    CreateImageBox -x 720 -y 10 -w 80 -h 120 -Name "MirrorShieldPreview";    $Redux.Equipment.MirrorShield.Add_SelectedIndexChanged( { ShowEquipmentPreview } )
    CreateImageBox -x 960 -y 30 -w 80 -h 80  -Name "MasterSwordIconPreview"; $Redux.Equipment.MasterSword.Add_SelectedIndexChanged(  { ShowEquipmentPreview } )
    ShowEquipmentPreview

}



#==============================================================================================================================================================================================
function CreateTabSave() {
    
    # STARTING EQUIPMENT #

    CreateReduxGroup    -Tag  "Save" -Text "Starting Equipment"
    CreateReduxCheckBox -Name "MasterSword"   -Text "Master Sword"   -Info "Start a new save file with the Master Sword"
    CreateReduxCheckBox -Name "GiantsKnife"   -Text "Giant's Knife"  -Info "Start a new save file with the Giant's Knife"
    CreateReduxCheckBox -Name "BiggoronSword" -Text "Biggoron Sword" -Info "Start a new save file with the Biggoron Sword instead of the Giant's Knife" -Link $Redux.Save.GiantsKnife
    CreateReduxCheckBox -Name "HylianShield"  -Text "Hylian Shield"  -Info "Start a new save file with the Hylian Shield"
    CreateReduxCheckBox -Name "MirrorShield"  -Text "Mirror Shield"  -Info "Start a new save file with the Mirror Shield"
    CreateReduxCheckBox -Name "GoronTunic"    -Text "Goron Tunic"    -Info "Start a new save file with the Master Sword"
    CreateReduxCheckBox -Name "ZoraTunic"     -Text "Zora Tunic"     -Info "Start a new save file with the Giant's Knife"
    CreateReduxCheckBox -Name "IronBoots"     -Text "Iron Boots"     -Info "Start a new save file with the Hylian Shield"
    CreateReduxCheckBox -Name "HoverBoots"    -Text "Hover Boots"    -Info "Start a new save file with the Mirror Shield"



    # STARTING ITEMS #

    CreateReduxGroup    -Tag  "Save" -Text "Starting Items"
    CreateReduxCheckBox -Name "DekuNut"           -Text "Deku Nut"            -Info "Start a new save file with Deku Nuts"
    CreateReduxCheckBox -Name "Bomb"              -Text "Bomb"                -Info "Start a new save file with Bombs"
    CreateReduxCheckBox -Name "FairyBow"          -Text "Fairy Bow"           -Info "Start a new save file with the Fairy Bow"
    CreateReduxCheckBox -Name "FireArrow"         -Text "Fire Arrow"          -Info "Start a new save file with the Fire Arrow"
    CreateReduxCheckBox -Name "DinsFire"          -Text "Din's Fire"          -Info "Start a new save file with Din's Fire"
    CreateReduxCheckBox -Name "OcarinaOfTime"     -Text "Ocarina of Time"     -Info "Start a new save file with the Ocarina of Time"
    CreateReduxCheckBox -Name "Bombchu"           -Text "Bombchu"             -Info "Start a new save file with Bombchus"
    CreateReduxCheckBox -Name "Hookshot"          -Text "Hookshot"            -Info "Start a new save file with the Hookshot"
    CreateReduxCheckBox -Name "LongShot"          -Text "Longshot"            -Info "Start a new save file with the Longshot`nThis item replaces the Hookshot" -Link $Redux.Save.Hookshot
    CreateReduxCheckBox -Name "IceArrow"          -Text "Ice Arrow"           -Info "Start a new save file with the Ice Arrow"
    CreateReduxCheckBox -Name "FaroresWind"       -Text "Farore's Wind"       -Info "Start a new save file with Farore's Wind"
    CreateReduxCheckBox -Name "LensOfTruth"       -Text "Lens of Truth"       -Info "Start a new save file with Lens of Truth"
    CreateReduxCheckBox -Name "MegatonHammer"     -Text "Megaton Hammer"      -Info "Start a new save file with the Megaton Hammer"
    CreateReduxCheckBox -Name "LightArrow"        -Text "Light Arrow"         -Info "Start a new save file with the Light Arrow"
    CreateReduxCheckBox -Name "NayrusLove"        -Text "Nayru's Love"        -Info "Start a new save file with Nayure's Love"
    CreateReduxCheckBox -Name "Bottle1"           -Text "Empty Bottle #1"     -Info "Start a new save file with the first empty bottle"
    CreateReduxCheckBox -Name "Bottle2"           -Text "Empty Bottle #2"     -Info "Start a new save file with the second empty bottle"
    CreateReduxCheckBox -Name "Bottle3"           -Text "Empty Bottle #3"     -Info "Start a new save file with the third empty bottle"
    CreateReduxCheckBox -Name "Bottle4"           -Text "Empty Bottle #4"     -Info "Start a new save file with the fourth empty bottle"



    # STARTING SONGS #

    CreateReduxGroup    -Tag  "Save" -Text "Starting Songs"
    CreateReduxCheckBox -Name "ZeldasLullaby"    -Text "Zelda's Lullaby"    -Info "Start a new save file with Zelda's Lullaby"
    CreateReduxCheckBox -Name "EponasSong"       -Text "Epona's Song"       -Info "Start a new save file with Epona's Song"
    CreateReduxCheckBox -Name "SongOfTime"       -Text "Song of Time"       -Info "Start a new save file with the Song of Time"
    CreateReduxCheckBox -Name "SongOfStorms"     -Text "Song of Storms"     -Info "Start a new save file with the Song of Storms"
    CreateReduxCheckBox -Name "MinuetOfForest"   -Text "Minuet of Forest"   -Info "Start a new save file with the Minuet of Forest"
    CreateReduxCheckBox -Name "BoleroOfFire"     -Text "Bolero of Fire"     -Info "Start a new save file with the Bolero of Fire"
    CreateReduxCheckBox -Name "SerenadeOfWater"  -Text "Serenade of Water"  -Info "Start a new save file with the Serenade of Water"
    CreateReduxCheckBox -Name "RequiemOfSpirit"  -Text "Requiem of Spirit"  -Info "Start a new save file with the Requiem of Spirit"
    CreateReduxCheckBox -Name "NocturneOfShadow" -Text "Nocturne of Shadow" -Info "Start a new save file with the Nocturne of Shadow"
    CreateReduxCheckBox -Name "PreludeOfLight"   -Text "Prelude of Light"   -Info "Start a new save file with the Prelude of Light"
    


    # STARTING UPGRADES #

    CreateReduxGroup    -Tag  "Save" -Text "Starting Upgrades"
    CreateReduxComboBox -Name "DekuNuts"   -Text "Deku Nuts"   -Items ("Standard", "Big", "Biggest")
    CreateReduxComboBox -Name "Quiver"     -Text "Quiver"      -Items ("Standard", "Big", "Biggest")
    CreateReduxComboBox -Name "BombBag"    -Text "Bomb Bag"    -Items ("Standard", "Big", "Biggest")
    CreateReduxComboBox -Name "Strength"   -Text "Strength"    -Items ("None", "Goron's Bracelet", "Silver Gauntlets", "Golden Gauntlets")
    CreateReduxComboBox -Name "Scale"      -Text "Scale"       -Items ("None", "Silver Scale", "Golden Scale")
    CreateReduxComboBox -Name "Wallet"     -Text "Wallet"      -Items ("Wallet", "Adult's Wallet", "Giant's Wallet", "Unused Wallet") -Warning 'The "Unused Wallet" is unused, and has issues'

    CreateReduxTextBox  -Name "Hearts"        -Text "Hearts" -Value 3 -Min 1 -Max 20 -Info "Start a new save file with the chosen amount of hearts"
    CreateReduxCheckBox -Name "DoubleDefense" -Text "Double Defense"                 -Info "Start a new save file with the double defense upgrade"
    CreateReduxCheckBox -Name "Magic"         -Text "Magic"                          -Info "Start a new save file with the magic meter"
    CreateReduxCheckBox -Name "DoubleMagic"   -Text "Double Magic"                   -Info "Start a new save file with the double magic upgrade"



    # STARTING QUEST #

    CreateReduxGroup    -Tag  "Save" -Text "Starting Quest Items"
    CreateReduxCheckBox -Name "KokiriEmerald"    -Text "Kokiri Emerald"           -Info "Start a new save file with Kokiri Emerald"
    CreateReduxCheckBox -Name "GoronRuby"        -Text "Goron Ruby"               -Info "Start a new save file with Goron Ruby"
    CreateReduxCheckBox -Name "ZoraSapphire"     -Text "Zora Sapphire"            -Info "Start a new save file with Zora Sapphire"
    CreateReduxCheckBox -Name "ForestMedallion"  -Text "Forest Medallion"         -Info "Start a new save file with the Forest Medallion"
    CreateReduxCheckBox -Name "FireMedallion"    -Text "Fire Medallion"           -Info "Start a new save file with the Fire Medallion"
    CreateReduxCheckBox -Name "WaterMedallion"   -Text "Water Medallion"          -Info "Start a new save file with the Water Medallion"
    CreateReduxCheckBox -Name "ShadowMedallion"  -Text "Shadow Medallion"         -Info "Start a new save file with the Shadow Medallion"
    CreateReduxCheckBox -Name "SpiritMedallion"  -Text "Spirit Medallion"         -Info "Start a new save file with the Spirit Medallion"
    CreateReduxCheckBox -Name "LightMedallion"   -Text "Light Medallion"          -Info "Start a new save file with the Light Medallion"
    CreateReduxCheckBox -Name "GerudoCard"       -Text "Gerudo Card"              -Info "Start a new save file with the Gerudo Card"
    CreateReduxCheckBox -Name "StoneOfAgony"     -Text "Stone of Agony"           -Info "Start a new save file with the Stone of Agony"
    CreateReduxTextBox  -Name "GoldSkulltulas"   -Text "Gold Skulltulas" -Max 100 -Info "Start a new save file with the chosen amount of Gold Skulltulas"
    


    # STARTING DEBUG #

    CreateReduxGroup    -Tag  "Save" -Text "Starting Debug Items"
    CreateReduxCheckBox -Name "NoDungeonItems" -Text "No Dungeon Items" -Info "Starting a new debug save file no longer grants the Dungeon Map, Compass and Boss Key for dungeons"
    CreateReduxCheckBox -Name "NoDungeonKeys"  -Text "No Dungeon Keys"  -Info "Starting a new debug save file no longer grants any small keys for dungeons"
    CreateReduxCheckBox -Name "NoQuestStatus"  -Text "No Quest Status"  -Info "Starting a new debug save file no longer grants any items from the Quest Status subscreen"
    CreateReduxCheckBox -Name "NoItems"        -Text "No Inventory"     -Info "Starting a new debug save file no longer grants any items from the Select Item subscreen"
    CreateReduxCheckBox -Name "NoEquipment"    -Text "No Equipment"     -Info "Starting a new debug save file no longer grants any items from the Equipment subscreen"
    CreateReduxCheckBox -Name "NoUpgrades"     -Text "No Equipment"     -Info "Starting a new debug save file no longer grants any upgrades from the Equipment subscreen"

}



#==============================================================================================================================================================================================
function CreateTabCapacity() {
    
    # CAPACITY SELECTION #

    CreateReduxGroup    -Tag  "Capacity" -Text "Capacity Selection"
    CreateReduxCheckBox -Name "EnableAmmo"   -Text "Change Ammo Capacity"       -Info "Enable changing the capacity values for ammo"
    CreateReduxCheckBox -Name "EnableWallet" -Text "Change Wallet Capacity"     -Info "Enable changing the capacity values for the wallets"
    CreateReduxCheckBox -Name "EnableDrops"  -Text "Change Item Drops Quantity" -Info "Enable changing the amount which an item drop provides"



    # AMMO CAPACITY #

    $Redux.Box.Ammo = CreateReduxGroup -Tag "Capacity" -Text "Ammo Capacity Selection"
    CreateReduxTextBox -Name "Quiver1"     -Text "Quiver (1)"      -Value 25 -Info "Set the capacity for the Quiver (Base)"         -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver2"     -Text "Quiver (2)"      -Value 40 -Info "Set the capacity for the Quiver (Upgrade 1)"    -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Quiver3"     -Text "Quiver (3)"      -Value 99 -Info "Set the capacity for the Quiver (Upgrade 2)"    -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag1"    -Text "Bomb Bag (1)"    -Value 15 -Info "Set the capacity for the Bomb Bag (Base)"       -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag2"    -Text "Bomb Bag (2)"    -Value 30 -Info "Set the capacity for the Bomb Bag (Upgrade 1)"  -Credits "GhostlyDark"
    CreateReduxTextBox -Name "BombBag3"    -Text "Bomb Bag (3)"    -Value 99 -Info "Set the capacity for the Bomb Bag (Upgrade 2)"  -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuNuts1"   -Text "Deku Nuts (1)"   -Value 15 -Info "Set the capacity for the Deku Nuts (Base)"      -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuNuts2"   -Text "Deku Nuts (2)"   -Value 30 -Info "Set the capacity for the Deku Nuts (Upgrade 1)" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "DekuNuts3"   -Text "Deku Nuts (3)"   -Value 99 -Info "Set the capacity for the Deku Nuts (Upgrade 2)" -Credits "GhostlyDark"



    # WALLET CAPACITY #

    $Redux.Box.Wallet = CreateReduxGroup -Tag "Capacity" -Text "Wallet Capacity Selection"
    CreateReduxTextBox -Name "Wallet1" -Length 4 -Text "Wallet (1)" -Value 99   -Info "Set the capacity for the Wallet (Base)"      -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet2" -Length 4 -Text "Wallet (2)" -Value 250  -Info "Set the capacity for the Wallet (Upgrade 1)" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet3" -Length 4 -Text "Wallet (3)" -Value 999  -Info "Set the capacity for the Wallet (Upgrade 2)" -Credits "GhostlyDark"
    CreateReduxTextBox -Name "Wallet4" -Length 4 -Text "Wallet (4)" -Value 1007 -Info "Set the capacity for the Wallet (Upgrade 3)" -Credits "GhostlyDark"



    # ITEM DROPS QUANTITY #

    $Redux.Box.Drops = CreateReduxGroup -Tag "Capacity" -Text "Item Drops Quantity Selection"
    CreateReduxTextBox -Name "Arrows1x"         -Text "Arrows (Single)"     -Value 5   -Info "Set the recovery quantity for picking up or buying Single Arrows"  -Credits "Admentus" -Row 1 -Column 1
    CreateReduxTextBox -Name "Arrows2x"         -Text "Arrows (Double)"     -Value 10  -Info "Set the recovery quantity for buying Double Arrows"                -Credits "Admentus"
    CreateReduxTextBox -Name "Arrows3x"         -Text "Arrows (Triple)"     -Value 30  -Info "Set the recovery quantity for picking up or buying Triple Arrows"  -Credits "Admentus"
    CreateReduxTextBox -Name "Bombs1x"          -Text "Bombs (5)"           -Value 5   -Info "Set the recovery quantity for picking up or buying Bombs (5)"      -Credits "Admentus" -Row 2 -Column 1
    CreateReduxTextBox -Name "Bombs2x"          -Text "Bombs (10)"          -Value 10  -Info "Set the recovery quantity for buying Bombs (10)"                   -Credits "Admentus"
    CreateReduxTextBox -Name "Bombs3x"          -Text "Bombs (15)"          -Value 15  -Info "Set the recovery quantity for buying Bombs (15)"                   -Credits "Admentus"
    CreateReduxTextBox -Name "Bombs4x"          -Text "Bombs (20)"          -Value 20  -Info "Set the recovery quantity for buying Bombs (20)"                   -Credits "Admentus"
    CreateReduxTextBox -Name "DekuNuts1x"       -Text "Deku Nuts (5)"       -Value 5   -Info "Set the recovery quantity for pickung up or buying Deku Nuts (5)"  -Credits "Admentus"
    CreateReduxTextBox -Name "DekuNuts2x"       -Text "Deku Nuts (10)"      -Value 10  -Info "Set the recovery quantity for picking up or buying Deku Nuts (10)" -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeG" -Length 4 -Text "Rupee (Green)"       -Value 1   -Info "Set the recovery quantity for picking up Green Rupees"             -Credits "Admentus" -Row 3 -Column 1
    CreateReduxTextBox -Name "RupeeB" -Length 4 -Text "Rupee (Blue)"        -Value 2   -Info "Set the recovery quantity for picking up Blue Rupees"              -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeR" -Length 4 -Text "Rupee (Red)"         -Value 5   -Info "Set the recovery quantity for picking up Red Rupees"               -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeP" -Length 4 -Text "Rupee (Purple)"      -Value 50  -Info "Set the recovery quantity for picking up Purple Rupees"            -Credits "Admentus"
    CreateReduxTextBox -Name "RupeeO" -Length 4 -Text "Rupee (Gold)"        -Value 200 -Info "Set the recovery quantity for picking up Gold Rupees"              -Credits "Admentus"



    EnableForm -Form $Redux.Box.Ammo -Enable $Redux.Capacity.EnableAmmo.Checked
    $Redux.Capacity.EnableAmmo.Add_CheckStateChanged({ EnableForm -Form $Redux.Box.Ammo -Enable $Redux.Capacity.EnableAmmo.Checked })
    EnableForm -Form $Redux.Box.Wallet -Enable $Redux.Capacity.EnableWallet.Checked
    $Redux.Capacity.EnableWallet.Add_CheckStateChanged({ EnableForm -Form $Redux.Box.Wallet -Enable $Redux.Capacity.EnableWallet.Checked })
    EnableForm -Form $Redux.Box.Drops -Enable $Redux.Capacity.EnableDrops.Checked
    $Redux.Capacity.EnableDrops.Add_CheckStateChanged({ EnableForm -Form $Redux.Box.Drops -Enable $Redux.Capacity.EnableDrops.Checked })

}