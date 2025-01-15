function ChildQuestClassicExposeOptions() {
    
    # Exclude Group
    ExcludeGroup  -Group "Unlock"       -Name "Unlock Child Restrictions"
    ExcludeGroup  -Group "Unlock"       -Name "Swords & Shields"
    ExcludeGroup  -Group "Previews"     -Name "Equipment Previews"



    # Expose Options
    ExposeOption  -Group "Graphics"     -Option "EnhancedChildQuestModel"
    ExposeOption  -Group "Equipment"    -Option "NoSlipperyBoots"
    ExposeOption  -Group "Hitbox"       -Option "MasterSword"
    ExposeOption  -Group "Hitbox"       -Option "GiantsKnife"
    ExposeOption  -Group "Hitbox"       -Option "BrokenGiantsKnife"
    ExposeOption  -Group "Hitbox"       -Option "MegatonHammer"



    # Exclude Options
    ExcludeOption -Group "Misc"         -Option "SkipCutscenes"
    ExcludeOption -Group "Gameplay"     -Option "Medallions"
    ExcludeOption -Group "Fixes"        -Option "GerudosFortress"
    ExcludeOption -Group "Fixes"        -Option "VisibleGerudoTent"
    ExcludeOption -Group "Fixes"        -Option "Dungeons"
    ExcludeOption -Group "Styles"       -Option "HairColor"
    ExcludeOption -Group "Equipment"    -Option "HideSword"
    ExcludeOption -Group "Equipment"    -Option "HideShield"
    ExcludeOption -Group "Equipment"    -Option "FunctionalWeapons"

}



#==============================================================================================================================================================================================
function ChildQuestClassicPatchOptions() {

    if (IsChecked $Redux.Graphics.EnhancedChildQuestModel)   { ApplyPatch -Patch "Decompressed\Optional\Child Quest\child_quest_classic_enhanced_model.ppf" }
    else                                                     { ApplyPatch -Patch "Decompressed\Optional\Child Quest\child_quest_classic_model.ppf"          }

}



#==============================================================================================================================================================================================
function ChildQuestClassicByteOptions() {

    # Sound
    CopyBytes   -Offset "2FDD2"  -Length "3F" -Start "2FE12" # Use Child sound IDs for Adult voice



    if (IsChecked -Elem $Redux.Graphics.EnhancedChildQuestModel) {
        # Equipment
        PatchBytes  -Offset "7F9000"  -Texture -Patch "Equipment\Kokiri Sword\Razor Sword.icon"                                                                                             # Icon:  Master Sword -> Razor Sword
        PatchBytes  -Offset "8ADC00"  -Texture -Patch "Equipment\Kokiri Sword\Razor Sword.en.label"                                                                                         # Label: Master Sword -> Razor Sword
        PatchBytes  -Offset "1793000" -Patch ("Object GI Models\Razor Sword.bin");           ChangeBytes -Offset "A674" -Values "01794560"; ChangeBytes -Offset "B6F9A4" -Values "01794560" # Model: Master Sword -> Razor Sword
        ChangeBytes -Offset "B66A1A"  -Values "0C00"; ChangeBytes -Offset "B66A1E" -Values "0C08"

        PatchBytes  -Offset "7F0000"  -Texture -Patch "Equipment\Kokiri Sword\Termina Kokiri Sword.icon"                                                                                    # Icon:  Broken Goron's Sword -> Termina Kokiri Sword
        PatchBytes  -Offset "812000"  -Texture -Patch "Equipment\Kokiri Sword\Termina Kokiri Sword.icon"                                                                                    # Icon:  Broken Giant's Knife -> Termina Kokiri Sword
        PatchBytes  -Offset "8B4000"  -Texture -Patch "Equipment\Kokiri Sword\Knife.en.label"                                                                                               # Label: Broken Giant's Knife -> Knife
        PatchBytes  -Offset "3483000" -Patch ("Object GI Models\Termina Kokiri Sword.bin")                                                                                                  # Model: Broken Giant's Knife -> Termina Kokiri Sword
        ChangeBytes -Offset "A610"    -Values "034830000348421003483000"; ChangeBytes -Offset "B6F970" -Values "0348300003484210"; ChangeBytes -Offset "B6698A" -Values "0850"

        PatchBytes  -Offset "7FA000"  -Texture -Patch "Equipment\Master Sword\Gilded Sword.icon"                                                                                            # Icon:  Biggoron Sword -> Gilded Sword
        PatchBytes  -Offset "8AE000"  -Texture -Patch "Equipment\Master Sword\Razor Longsword.en.label"                                                                                     # Label: Giant's Knife  -> Razor Longsword
        PatchBytes  -Offset "8BD400"  -Texture -Patch "Equipment\Master Sword\Gilded Sword.en.label"                                                                                        # Label: Biggoron Sword -> Gilded Sword
        PatchBytes  -Offset "347F000" -Patch ("Object GI Models\Gilded Sword.bin")                                                                                                          # Model: Giant's Knife  -> Gilded Sword
        ChangeBytes -Offset "A190"    -Values "0347F000034802A00347F000"; ChangeBytes -Offset "B6F718" -Values "0347F000034802A0"; ChangeBytes -Offset "B666DE" -Values "09E8"

        PatchBytes  -Offset "7FC000"  -Texture -Patch "Equipment\Hylian Shield\Hero's Shield.icon"                                                                                          # Icon:  Hylian Shield -> Hero's Shield
        PatchBytes  -Offset "8AE800"  -Texture -Patch "Equipment\Hylian Shield\Hero's Shield.en.label"                                                                                      # Label: Hylian Shield -> Hero's Shield
        PatchBytes  -Offset "15B9000" -Patch ("Object GI Models\Hero's Shield.bin");         ChangeBytes -Offset "9FF4" -Values "015BAEC0"; ChangeBytes -Offset "B6F63C" -Values "015BAEC0" # Model: Hylian Shield -> Hero's Shield
        ChangeBytes -Offset "B663A2"  -Values "09F0"
        
        PatchBytes  -Offset "7FD000"  -Texture -Patch "Equipment\Mirror Shield\Termina Mirror Shield.icon"                                                                                  # Icon:  Mirror Shield -> Termina Mirror Shield
        PatchBytes  -Offset "1616000" -Patch ("Object GI Models\Termina Mirror Shield.bin"); ChangeBytes -Offset "A0F4" -Values "01617C00"; ChangeBytes -Offset "B6F6CC" -Values "01617C00" # Model: Mirror Shield -> Termina Mirror Shield
        ChangeBytes -Offset "B6659A"  -Values "0770"; ChangeBytes -Offset "B6659E" -Values "0BF8"
        PatchBytes  -Offset "1456188" -Texture -Patch "Child Quest\mm_style_reflection.bin"                                                                                                 # Mirror Shield reflection
    }

    else {
        # Change equipment display lists for Child Link
        ChangeBytes -Offset "B6D74D" -Values "0210F8";            ChangeBytes -Offset "B6D78D" -Values "0210D8"; ChangeBytes -Offset "B6D7ED" -Values "0210E8" # Mirror Shield as Hylian Shield
        ChangeBytes -Offset "AF2A1F" -Values "00";                ChangeBytes -Offset "AF2A24" -Values "11";     ChangeBytes -Offset "B6D6CF" -Values "0A11"   # Show Hylian Shield as one-handed in Pause Screen
        ChangeBytes -Offset "B6D980" -Values "800F7908";          ChangeBytes -Offset "B6D679" -Values "02";     ChangeBytes -Offset "B6DC2A" -Values "02"     # Biggoron Sword as One-Handed
        ChangeBytes -Offset "B6D6E0" -Values "1401020A11";        ChangeBytes -Offset "AEFBDF" -Values "06"                                                    # Biggoron Sword as One-Handed
        ChangeBytes -Offset "AF0C38" -Values "240100FF1501";      ChangeBytes -Offset "AF0C74" -Values "240100FF1541"                                          # Show sheath for swords as Child Link
        ChangeBytes -Offset "BEDF00" -Values "00" -Repeat 0x1F                                                                                                 # Fix animation for losing sword during Ganon boss fight
    }



    # Unlock items for Child Link
    ChangeBytes -Offset "BC77B6" -Values "0909";              ChangeBytes -Offset "BC77FE" -Values "0909" # Unlock Tunics
    ChangeBytes -Offset "BC77BA" -Values "0909";              ChangeBytes -Offset "BC7801" -Values "0909" # Unlock Boots
    ChangeBytes -Offset "BC77AE" -Values "0909" -Interval 74                                              # Unlock Master Sword
    ChangeBytes -Offset "BC77AF" -Values "0909" -Interval 74; ChangeBytes -Offset "BC7811" -Values "09"   # Unlock Giant's Knife
    ChangeBytes -Offset "BC77B3" -Values "0909" -Interval 73                                              # Unlock Mirror Shield
    ChangeBytes -Offset "AEFA6C" -Values "24080000";          ChangeBytes -Offset "BC780D" -Values "0909" # Unlock Gauntlets (icons)
    ChangeBytes -Offset "BC77B4" -Values "09"                                                             # Unlock Gauntlets (text)
    ChangeBytes -Offset "BC77A3" -Values "0909" -Interval 42                                              # Unlock Megaton Hammer



    # Enable Biggoron Sword
    ChangeBytes -Offset "B71E9A" -Values "01"   # Set Biggoron Sword flag on new save file
    ChangeBytes -Offset "BB6DE4" -Values "1500" # Disable icon when Biggoron Sword flag is set



    # Hylian Shield edits
    ChangeBytes -Offset "C0D108" -Values "1100" # Hylian Shield can reflect Octorok projectiles
    ChangeBytes -Offset "EBB1F4" -Values "1100" # Hylian Shield can reflect Deku Scrub projectiles



    # Collision
    ChangeBytes -Offset @("CF4CDC", "CF4D00", "CF4D24", "CF4D48", "CF4D6C", "CF4D90", "CF4DB4", "CF4DD8", "CF4DFC", "CF4E07", "CF4E20", "CF4E44", "CF4E68") -Values (GetOoTCollision -Boomerang) -Add # Flare Dancer
    ChangeBytes -Offset "EA0814" -Values (GetOoTCollision -Slingshot -KokiriSpin -GiantSpin -MasterSpin -KokiriJump -GiantJump -MasterJump) -Add                                                      # Gerudo Guard
    ChangeBytes -Offset "CDE1E4" -Values (GetOoTCollision -Slingshot)              -Add; ChangeBytes -Offset "CE1B28" -Values (GetOoTCollision -Slingshot) -Add                                       # Poe Sister
    ChangeBytes -Offset "CE1AEC" -Values (GetOoTCollision -Slingshot)              -Add                                                                                                               # Poe Sister Painting
    ChangeBytes -Offset "ECF864" -Values (GetOoTCollision -Slingshot)              -Add                                                                                                               # Sage Barrier
    ChangeBytes -Offset "D8D4A0" -Values (GetOoTCollision -KokiriJump -KokiriSpin) -Add                                                                                                               # Ganondorf Lightball
    ChangeBytes -Offset "D85E34" -Values (GetOoTCollision -Slingshot)              -Add                                                                                                               # Ganondorf (stun)
    ChangeBytes -Offset "CA8D2C" -Values (GetOoTCollision -Slingshot)              -Add                                                                                                               # Gerudo Training Ground Eye Statue
    ChangeBytes -Offset "C88914" -Values (GetOoTCollision -Slingshot)              -Add                                                                                                               # Bomb Flower
    
    
    
    # Death Mountain Trail falling rocks
    ChangeBytes -Offset "D1C8C4" -Values "1100" # Despawn after beating Volvagia
    ChangeBytes -Offset "D1CF10" -Values "1500" # Use Adult behavior



    # Change Nocturne CS to check for medallions and both ages
    ChangeBytes -Offset "ACCD84" -Values "1100"; ChangeBytes -Offset "ACCD8E" -Values "00A6"; ChangeBytes -Offset "ACCD92" -Values "0001"; ChangeBytes -Offset "ACCD9A" -Values "0002"; ChangeBytes -Offset "ACCDA2" -Values "0004"



    # Credits
    ChangeBytes -Offset "ACAAEC" -Values "00" -Repeat 0xB # Zelda cutscene as Child
    ChangeBytes -Offset "ACA00C" -Values "35F93000"       # Fix Tunic during final scenes
    ChangeBytes -Offset "ACA02C" -Values "39092000"       # Fix Boots during final scenes



    # Testing
    ChangeBytes -Offset "B71F56" -Values "01" # Biggoron Sword on new Debug Save Slot
    ChangeBytes -Offset "B71FBB" -Values "C9" # Golden Gauntlets on new Debug Save Slot



    # Other options
    MultiplyBytes -Offset "D3B4A7" -Factor 0.5                   # Morpha's HP cut in half
    ChangeBytes   -Offset "E2B464" -Values "1100"                # Remove Light Arrows requirement for Rainbow Bridge
    CopyBytes     -Offset "96E068" -Length "D48" -Start "974600" # Fix incomplete Gerudo Fortress minimap



    # Age Checks
    ChangeBytes -Offset "C00DD0" -Values "1500";     ChangeBytes -Offset "C00E78" -Values "1500"                                                      # Purchasable tunics as Child
    ChangeBytes -Offset "DE0214" -Values "1100"                                                                                                       # Make Ice Platforms appear as Child
    ChangeBytes -Offset "C7B9C0" -Values "00000000"; ChangeBytes -Offset "C7BAEC" -Values "00000000"; ChangeBytes -Offset "C7BCA4" -Values "00000000" # Tell Sheik at Ice Cavern we are always an Adult
    ChangeBytes -Offset "B65D56" -Values "01"                                                                                                         # Nabooru Iron Knuckle cutscene as Child
    ChangeBytes -Offset "B65D5E" -Values "02"                                                                                                         # Gerudo Fortress jail cutscene as Child
    ChangeBytes -Offset "B65D15" -Values "3A02"                                                                                                       # Fix Ganon's Castle intro
    ChangeBytes -Offset "F01C7C" -Values "1500"                                                                                                       # Fix Silver Blocks
    ChangeBytes -Offset "EB7FA8" -Values "1400"                                                                                                       # Fix Spirit Temple Stone Elevator
  # ChangeBytes -Offset "AFCD2C" -Values "1400"                                                                                                       # Withered Deku Tree during Deku Sprout cutscenes (tree)
  # ChangeBytes -Offset "C7332C" -Values "1400"                                                                                                       # Withered Deku Tree during Deku Sprout cutscenes (jaw)
    ChangeBytes -Offset "D5A80C" -Values "1500"                                                                                                       # Prevent Deku Tree Sprout from disappearing after its cutscene



    # Gerudo Valley visible tent
    ChangeBytes -Offset "D215D3" -Values "128483"
    ChangeBytes -Offset "D215E1" -Values "41000724010003"
    ChangeBytes -Offset "D215EF" -Values "0410410005000000001000000F0000102503E000082C62000103E000080060102503E00008240200018483001C386200022C420001144000040000000038620003"



    # Chests
    ChangeBytes -Offset "C7BCF0" -Values "8CB91D38340800048CA21C4400000000000000000000000000000000" # Fix Serenade of Water
    ChangeBytes -Offset "DFEC3C" -Values "3C1880128F18AE8C27A500243319001000000000"                 # Fix Dampé Hookshot chest
    ChangeBytes -Offset "AE76FF" -Values "58"                                                       # Fix Deku Seeds in chests
    ChangeBytes -Offset "AE7780" -Values "1500"                                                     # Fix Magic Jars (small + large) in chests

    ChangeBytes -Offset "BEEEA6" -Values "5B80043100B6" # Fairy Bow   -> Bolero of Fire
    ChangeBytes -Offset "BEEEBE" -Values "6580073600B6" # Hookshot    -> Song of Storms
    ChangeBytes -Offset "BEF09E" -Values "5A80037000B6" # Fire Arrow  -> Minuet of Forest
    ChangeBytes -Offset "BEF0A4" -Values "6B804B71012E" # Ice Arrow   -> Light Medallion
    ChangeBytes -Offset "BEF0AA" -Values "5F80087200B6" # Light Arrow -> Prelude of Light
    if (IsChecked -Elem $Redux.Graphics.EnhancedChildQuestModel) { ChangeBytes -Offset "BEF17C" -Values "3C805ABE0149" } else { ChangeBytes -Offset "BEF17C" -Values "3C8074BE018D" } # None -> Master Sword

    ChangeBytes -Offset "BDA300" -Values "11000000" # Remove item possession check for playing long chest animation
    ChangeBytes -Offset "BEF040" -Values "F7"       # Set Recovery Hearts to short anim



    # Damage tables
    ChangeBytes -Offset "DFE765" -Values "F2"; ChangeBytes -Offset "DFE76C" -Values "F1"; ChangeBytes -Offset "DFE77A" -Values "F1"; ChangeBytes -Offset "DFE77D" -Values "F2"; ChangeBytes -Offset "DFE782" -Values "F4" # Freezard (Deku Stick, Kokiri Slash, Kokiri Spin, Kokiri Jump, Hammer Jump)
    ChangeBytes -Offset "CB4DB1" -Values "D2"; ChangeBytes -Offset "CB4DB2" -Values "D1"; ChangeBytes -Offset "CB4DB8" -Values "D1"                                                                                       # Blue Bubble (Deku Stick, Slingshot, Kokiri Slash)
    ChangeBytes -Offset "C673F9" -Values "F2"; ChangeBytes -Offset "C673FA" -Values "F1"; ChangeBytes -Offset "C67400" -Values "F1"                                                                                       # Torch Slug (Deku Stick, Slingshot, Kokiri Slash)
    ChangeBytes -Offset "D49F5E" -Values "02"; ChangeBytes -Offset "D49F61" -Values "02"; ChangeBytes -Offset "D49F62" -Values "04"; ChangeBytes -Offset "D49F6F" -Values "04"; ChangeBytes -Offset "D49F70" -Values "02" # Big Octorok (Hammer Swing, Master Slash, Giant Slash, Giant Spin, Master Spin)
    ChangeBytes -Offset "D49F72" -Values "08"; ChangeBytes -Offset "D49F73" -Values "04"; ChangeBytes -Offset "D49F76" -Values "04"                                                                                       # Big Octorok (Giant Jump, Master Jump, Hammer Jump)
    ChangeBytes -Offset "DAF295" -Values "F2"; ChangeBytes -Offset "DAF296" -Values "F1"; ChangeBytes -Offset "DAF298" -Values "F1"; ChangeBytes -Offset "DAF29C" -Values "F1"; ChangeBytes -Offset "DAF2AA" -Values "F1" # Spike (Deku Stick, Slingshot, Boomerang, Kokiri Slash, Kokiri Spin)
    ChangeBytes -Offset "DAF2AD" -Values "F2"; ChangeBytes -Offset "DAF2B2" -Values "F4"                                                                                                                                  # Spike (Kokiri Jump, Hammer Jump)
    ChangeBytes -Offset "C2F5DE" -Values "E4"                                                                                                                                                                             # Leever (Hammer Jump)
    ChangeBytes -Offset "D4759E" -Values "F1"; ChangeBytes -Offset "D475A0" -Values "11"; ChangeBytes -Offset "D475BA" -Values "D4" # Shell Blade (Slingshot, Boomerang, Hammer Jump) 
    ChangeBytes -Offset "D76516" -Values "F4"



    # Restriction tables
    ChangeBytes -Offset "B6D3AB" -Values "14" # Reuse Guard House scene restrictions table for Lakeside Laboratory



    # Great Fairy's Fountain (Double Defense) exit
    ChangeBytes -Offset "BEFD6C" -Values "0342"



    # Fix subsequent Blue Warps
    ChangeBytes -Offset "CA3D67" -Values "0810" # Forest Temple
    ChangeBytes -Offset "CA3DF2" -Values "0564" # Fire Temple
    ChangeBytes -Offset "CA3E82" -Values "060C" # Water Temple
    ChangeBytes -Offset "CA3FA2" -Values "0580" # Shadow Temple
    ChangeBytes -Offset "CA3F12" -Values "0610" # Spirit Temple

}



#==============================================================================================================================================================================================
function ChildQuestClassicByteReduxOptions() {
    
    ChangeBytes -Offset $Symbols.CFG_ALLOW_MASTER_SWORD  -Values "01"
    ChangeBytes -Offset $Symbols.CFG_ALLOW_GIANTS_KNIFE  -Values "01"
    ChangeBytes -Offset $Symbols.CFG_ALLOW_MIRROR_SHIELD -Values "01"
    ChangeBytes -Offset $Symbols.CFG_ALLOW_BOOTS         -Values "01"
    ChangeBytes -Offset $Symbols.CFG_ALLOW_TUNIC         -Values "01"

}



#==============================================================================================================================================================================================
function ChildQuestClassicByteSceneOptions() {
    
    # KAKARIKO VILLAGE #

    PrepareMap   -Scene "Kakariko Village" -Map 0 -Header 1 # Child - Night
    # Gold Skulltula (Rooftop)
    InsertActor  -Name "Skullwalltula" -X (-18) -Y 540 -Z 1800 -Param "B140" -YRot 0x8000
    SaveAndPatchLoadedScene



    # GRAVEYARD #

    PrepareMap   -Scene "Graveyard" -Map 1 -Header 0 # Child - Day
    # Reposition heart piece
    ReplaceActor -Name "Collectable" -Compare "0406" -X (-850)
    # Unlock Dampé's grave and add grave flowers
    InsertActor  -Name "Gravestone" -X (-578) -Y 120 -Z (-336) -Param "0001"
    RemoveActor  -Name "Graveyard"  -CompareX (-578) -CompareY 120 -CompareZ (-336)
    InsertActor  -Name "Uninteractable Objects" -X (-562) -Y 120 -Z (-289)
    InsertActor  -Name "Uninteractable Objects" -X (-578) -Y 120 -Z (-280)
    InsertActor  -Name "Uninteractable Objects" -X (-598) -Y 120 -Z (-287)
    # Fix Blue Warp
    InsertObject -Name "Warp Circle & Rupee Prism"
    InsertActor  -Name "Warp Portal" -X 1140 -Y 340 -Z 85 -Param "0006"
    InsertSpawnPoint -X 1140 -Y 340 -Z 85 -Param "0201" -YRot 0xC71C
    SaveLoadedMap

    PrepareMap   -Scene "Graveyard" -Map 1 -Header 1 # Child - Night
    # Reposition heart piece
    ReplaceActor -Name "Collectable" -Compare "0406" -X (-850)
    # Unlock Dampé's grave and add grave flowers
    InsertActor  -Name "Gravestone" -X (-578) -Y 120 -Z (-336) -Param "0001"
    RemoveActor  -Name "Graveyard"  -CompareX (-578) -CompareY 120 -CompareZ (-336)
    InsertActor  -Name "Uninteractable Objects" -X (-562) -Y 120 -Z (-289)
    InsertActor  -Name "Uninteractable Objects" -X (-578) -Y 120 -Z (-280)
    InsertActor  -Name "Uninteractable Objects" -X (-598) -Y 120 -Z (-287)
    # Fix Blue Warp
    InsertObject -Name "Warp Circle & Rupee Prism"
    InsertActor  -Name "Warp Portal" -X 1140 -Y 340 -Z 85 -Param "0006"
    InsertSpawnPoint -X 1140 -Y 340 -Z 85 -Param "0201" -YRot 0xC71C
    SaveAndPatchLoadedScene



    # ZORA'S RIVER #

    PrepareMap  -Scene "Zora's River" -Map 0 -Header 0 # River Road
    # Gold Skulltula (Wall, upper area)
    InsertActor -Name "Skullwalltula" -X 26   -Y 702  -Z 258     -Param "B210" -XRot 0x4000 -YRot 0x82D8
    SaveLoadedMap

    PrepareMap  -Scene "Zora's River" -Map 1 -Header 0 # Zora's Domain Entrance
    # Gold Skulltula (Adult position, lowered by 50 in height)
    InsertActor -Name "Skullwalltula" -X 2832 -Y 1005 -Z (-1466) -Param "B208" -XRot 0x4000 -YRot 0x238E
    SaveAndPatchLoadedScene



    # KOKIRI FOREST #

    PrepareMap  -Scene "Kokiri Forest" -Map 0 -Header 0 # Village
    # Gold Skulltula (Twin's House)
    InsertActor -Name "Skullwalltula" -X 1153 -Y 251 -Z 625 -Param "AD04" -XRot 0x4000 -YRot 0xE93F
    SaveLoadedMap

    PrepareMap   -Scene "Kokiri Forest" -Map 1 -Header 0 # Great Deku Tree's Meadow
    # Add Deku Tree Sprout
    InsertObject -Name "Deku Tree Sprout"
    InsertActor  -Name "Deku Tree Sprout" -X 3704 -Y (-172) -Z (-1074) -Param "1E00"
    # Fix Deku Tree Sprout cutscene
    InsertSpawnPoint -X 3608 -Y (-179) -Z (-1009) -Param "0DFF" -YRot 0x5555
    SaveAndPatchLoadedScene



    # SACRED FOREST MEADOW #

    PrepareMap   -Scene "Sacred Forest Meadow" -Map 0 -Header 0
    # Gold Skulltula (Wall)
    InsertObject -Name "Skulltulas"
    InsertActor  -Name "Skullwalltula" -X 534 -Y 289 -Z 280 -Param "AE08" -XRot 0x4000 -YRot 0xC000
    # Move Minuet spawn in front of the Temple
    ChangeSpawnPoint -Index 2 -X (-2) -Y 680 -Z (-3130)
    # Fix Blue Warp
    InsertObject -Name "Warp Circle & Rupee Prism"
    InsertActor  -Name "Warp Portal" -X 10 -Y 500 -Z (-2610) -Param "0006"
    InsertSpawnPoint -X 10 -Y 500 -Z (-2610) -Param "0201"
    SaveAndPatchLoadedScene



    # LAKE HYLIA #

    PrepareMap   -Scene "Lake Hylia" -Map 0 -Header 0
    # Reposition heart piece
    ReplaceActor -Name "Collectable" -Compare "1E06" -X (-797) -Y (-1054) -Z 3348
    # Gold Skulltula (Tree - unique position)
    InsertActor  -Name "Skullwalltula" -X (-687) -Y (-899) -Z 7535 -Param "B310" -XRot 0xC000 -YRot 0x796C -ZRot 0x0400
    # Open the entrance to Water Temple
    RemoveActor  -Name "Lake Hylia" -Compare "001F"
    RemoveActor  -Name "Lake Hylia" -Compare "011F"
    # Fix spawn exiting Water Temple
    ChangeSpawnPoint -Index 2 -X (-917) -Y (-2201) -Z 6359
    # Fix Blue Warp
    InsertObject -Name "Warp Circle & Rupee Prism"
    InsertActor  -Name "Warp Portal" -X (-1045) -Y (-1223) -Z 7460 -Param "0006"
    InsertSpawnPoint -X (-1045) -Y (-1223) -Z 7460 -Param "0200" -YRot 0x8000
    SaveAndPatchLoadedScene



    # ZORA'S DOMAIN #

    PrepareMap  -Scene "Zora's Domain" -Map 1 -Header 0
    # Gold Skulltula (Waterfall)
    InsertObject -Name "Skulltulas"
    InsertActor  -Name "Skullwalltula" -X (-10) -Y 897 -Z (-909) -Param "B240" -XRot 0x4000
    SaveAndPatchLoadedScene



    # ZORA'S FOUNTAIN #

    PrepareMap  -Scene "Zora's Fountain" -Map 0 -Header 0 # Child - Day
    # Remove ice ramp
    RemoveActor -Name "Ice Platform" -Compare "0214"
    # Ice platforms
    InsertActor -Name "Ice Platform" -X 974    -Y 20      -Z 90      -Param "0011"
    InsertActor -Name "Ice Platform" -X (-214) -Y 20      -Z (-1393) -Param "0011"
    InsertActor -Name "Ice Platform" -X 255    -Y 20      -Z (-285)  -Param "0010" -YRot 0x4000
    InsertActor -Name "Ice Platform" -X (-253) -Y 20      -Z (-834)  -Param "0012"
    InsertActor -Name "Ice Platform" -X 35     -Y 20      -Z (-1125) -Param "0012"
    InsertActor -Name "Ice Platform" -X 102    -Y 20      -Z (-628)  -Param "0012"
    InsertActor -Name "Ice Platform" -X 599    -Y 20      -Z (-87)   -Param "0023"
    # Ice platform heart piece
    InsertActor -Name "Collectable"  -X 974    -Y 30      -Z 90      -Param "0106" -YRot 0xB3E9
    # Underwater heart piece
    InsertActor -Name "Collectable"  -X (-14)  -Y (-1445) -Z 4       -Param "1406"
    # Underwater rupees
    InsertActor -Name "Collectable"  -X 68     -Y (-1382) -Z (-166)  -Param "2000"
    InsertActor -Name "Collectable"  -X 172    -Y (-1380) -Z (-35)   -Param "2100"
    InsertActor -Name "Collectable"  -X 137    -Y (-1385) -Z 130     -Param "2200"
    InsertActor -Name "Collectable"  -X (-76)  -Y (-1373) -Z 172     -Param "2300"
    InsertActor -Name "Collectable"  -X (-207) -Y (-1364) -Z 47      -Param "2400"
    InsertActor -Name "Collectable"  -X (-173) -Y (-1377) -Z (-132)  -Param "2500"
    InsertActor -Name "Collectable"  -X 242    -Y (-1209) -Z (-576)  -Param "2600"
    InsertActor -Name "Collectable"  -X 540    -Y (-1228) -Z (-124)  -Param "2700"
    InsertActor -Name "Collectable"  -X 397    -Y (-1285) -Z 318     -Param "2800"
    InsertActor -Name "Collectable"  -X (-166) -Y (-1265) -Z 428     -Param "2900"
    InsertActor -Name "Collectable"  -X (-574) -Y (-1204) -Z 163     -Param "2A00"
    InsertActor -Name "Collectable"  -X (-464) -Y (-1242) -Z (-389)  -Param "2B00"
    InsertActor -Name "Collectable"  -X 353    -Y (-1072) -Z (-934)  -Param "2C00"
    InsertActor -Name "Collectable"  -X 1032   -Y (-1025) -Z (-254)  -Param "2D00"
    InsertActor -Name "Collectable"  -X 603    -Y (-1206) -Z 466     -Param "2E00"
    InsertActor -Name "Collectable"  -X (-227) -Y (-1163) -Z 696     -Param "2F00"
    InsertActor -Name "Collectable"  -X (-874) -Y (-1095) -Z 206     -Param "3000"
    InsertActor -Name "Collectable"  -X (-857) -Y (-1082) -Z (-654)  -Param "3100"
    # Correct spawn point exiting Ice Cavern
    ChangeSpawnPoint -Index 3 -Y 101
    # Path to Gold Skulltula (Upper Area)
    InsertActor -Name "Pot"          -X 430  -Y (-280) -Z 2568 -Param "770E"
    InsertActor -Name "Pot"          -X 385  -Y (-280) -Z 2587 -Param "790E"
    InsertActor -Name "Pot"          -X 418  -Y (-280) -Z 2609 -Param "7B09"
    InsertActor -Name "Skulltula"    -X 843  -Y 38     -Z 2423 -Param "0002" -YRot 0xE4FA
    InsertActor -Name "Skulltula"    -X 681  -Y (-28)  -Z 2433 -Param "0002" -YRot 0xE000
    InsertActor -Name "Skulltula"    -X 1147 -Y 188    -Z 2177 -Param "0002" -YRot 0xE000
    InsertActor -Name "Skulltula"    -X 927  -Y 98     -Z 2248 -Param "0002" -YRot 0xE2D8
    InsertActor -Name "Skulltula"    -X 1209 -Y 1118   -Z 1682 -Param "0001"
    SaveLoadedMap

    PrepareMap  -Scene "Zora's Fountain" -Map 0 -Header 1 # Child - Night
    # Remove ice ramp
    RemoveActor -Name "Ice Platform" -Compare "0214"
    # Ice platforms
    InsertActor -Name "Ice Platform"  -X 974    -Y 20      -Z 90      -Param "0011"
    InsertActor -Name "Ice Platform"  -X (-214) -Y 20      -Z (-1393) -Param "0011"
    InsertActor -Name "Ice Platform"  -X 255    -Y 20      -Z (-285)  -Param "0010" -YRot 0x4000
    InsertActor -Name "Ice Platform"  -X (-253) -Y 20      -Z (-834)  -Param "0012"
    InsertActor -Name "Ice Platform"  -X 35     -Y 20      -Z (-1125) -Param "0012"
    InsertActor -Name "Ice Platform"  -X 102    -Y 20      -Z (-628)  -Param "0012"
    InsertActor -Name "Ice Platform"  -X 599    -Y 20      -Z (-87)   -Param "0023"
    # Ice platform heart piece
    InsertActor -Name "Collectable"   -X 974    -Y 30      -Z 90      -Param "0106" -YRot 0xB3E9
    # Underwater heart piece
    InsertActor -Name "Collectable"   -X (-14)  -Y (-1445) -Z 4       -Param "1406"
    # Underwater rupees
    InsertActor -Name "Collectable"   -X 68     -Y (-1382) -Z (-166)  -Param "2000"
    InsertActor -Name "Collectable"   -X 172    -Y (-1380) -Z (-35)   -Param "2100"
    InsertActor -Name "Collectable"   -X 137    -Y (-1385) -Z 130     -Param "2200"
    InsertActor -Name "Collectable"   -X (-76)  -Y (-1373) -Z 172     -Param "2300"
    InsertActor -Name "Collectable"   -X (-207) -Y (-1364) -Z 47      -Param "2400"
    InsertActor -Name "Collectable"   -X (-173) -Y (-1377) -Z (-132)  -Param "2500"
    InsertActor -Name "Collectable"   -X 242    -Y (-1209) -Z (-576)  -Param "2600"
    InsertActor -Name "Collectable"   -X 540    -Y (-1228) -Z (-124)  -Param "2700"
    InsertActor -Name "Collectable"   -X 397    -Y (-1285) -Z 318     -Param "2800"
    InsertActor -Name "Collectable"   -X (-166) -Y (-1265) -Z 428     -Param "2900"
    InsertActor -Name "Collectable"   -X (-574) -Y (-1204) -Z 163     -Param "2A00"
    InsertActor -Name "Collectable"   -X (-464) -Y (-1242) -Z (-389)  -Param "2B00"
    InsertActor -Name "Collectable"   -X 353    -Y (-1072) -Z (-934)  -Param "2C00"
    InsertActor -Name "Collectable"   -X 1032   -Y (-1025) -Z (-254)  -Param "2D00"
    InsertActor -Name "Collectable"   -X 603    -Y (-1206) -Z 466     -Param "2E00"
    InsertActor -Name "Collectable"   -X (-227) -Y (-1163) -Z 696     -Param "2F00"
    InsertActor -Name "Collectable"   -X (-874) -Y (-1095) -Z 206     -Param "3000"
    InsertActor -Name "Collectable"   -X (-857) -Y (-1082) -Z (-654)  -Param "3100"
    # Correct spawn point exiting Ice Cavern
    ChangeSpawnPoint -Index 3 -Y 101
    # Path to Gold Skulltula (Upper Area)
    InsertActor -Name "Pot"           -X 430  -Y (-280) -Z 2568 -Param "770E"
    InsertActor -Name "Pot"           -X 385  -Y (-280) -Z 2587 -Param "790E"
    InsertActor -Name "Pot"           -X 418  -Y (-280) -Z 2609 -Param "7B09"
    InsertActor -Name "Skulltula"     -X 843  -Y 38     -Z 2423 -Param "0002" -YRot 0xE4FA
    InsertActor -Name "Skulltula"     -X 681  -Y (-28)  -Z 2433 -Param "0002" -YRot 0xE000
    InsertActor -Name "Skulltula"     -X 1147 -Y 188    -Z 2177 -Param "0002" -YRot 0xE000
    InsertActor -Name "Skulltula"     -X 927  -Y 98     -Z 2248 -Param "0002" -YRot 0xE2D8
    InsertActor -Name "Skulltula"     -X 1209 -Y 1118   -Z 1682 -Param "0001"
    InsertActor -Name "Skullwalltula" -X 989  -Y 1063   -Z 1688 -Param "B220" -XRot 0x4000 -YRot 0x56C1
    SaveAndPatchLoadedScene



    # GERUDO VALLEY #

    PrepareMap   -Scene "Gerudo Valley" -Map 0 -Header 0
    # Remove fence
    RemoveActor  -Name "Obstacle Fence" -Compare "0000"
    # Bronze boulders and chest
    InsertActor  -Name "Bronze Boulder" -X (-1352) -Y 69  -Z 767     -Param "000B"
    InsertActor  -Name "Bronze Boulder" -X (-1291) -Y 65  -Z 787     -Param "0009"
    InsertActor  -Name "Bronze Boulder" -X (-1416) -Y 59  -Z 778     -Param "000D"
    InsertActor  -Name "Bronze Boulder" -X (-1256) -Y 55  -Z 856     -Param "0010"
    InsertObject -Name "Treasure Chest"
    InsertActor  -Name "Treasure Chest" -X (-1341) -Y 76  -Z 858     -Param "5AA0" -YRot 0xE2D8
    # Gold Skulltula (Pillar)
    InsertActor  -Name "Skullwalltula"  -X (-1329) -Y 360 -Z 309     -Param "B404" -XRot 0x31C7 -YRot 0xE4FA
    # Gold Skulltula (Wall behind Tent)
    InsertActor  -Name "Skullwalltula"  -X (-1171) -Y 160 -Z (-1225) -Param "B408" -XRot 0x4000
    # Grotto entrance
    InsertActor  -Name "Grotto Entrance" -X (-1323) -Y 15  -Z (-969) -Param "01F0" -YRot 0x9555
    SaveAndPatchLoadedScene



    # LOST WOODS #

    PrepareMap   -Scene "Lost Woods" -Map 6 -Header 0 # Tree Area
    # Gold Skulltula (Near Deku Theater, unique position)
    InsertActor  -Name "Skullwalltula" -X 772 -Y 185 -Z (-1738) -Param "AE04" -XRot 0x4000
    SaveAndPatchLoadedScene



    # DESERT COLOSSUS #

    PrepareMap   -Scene "Desert Colossus" -Map 0 -Header 0
    # Reposition heart piece
    ReplaceActor -Name "Collectable" -Compare "0D06" -X (-200) -Y 269 -Z 1180
    # Gold Skulltula (Palm Tree)
    RemoveActor  -Name "Invisible Collectable" -Compare "1A7F"
    InsertActor  -Name "Skullwalltula" -X 456    -Y 268    -Z 2332   -Param "B608" -XRot 0x4000
    # Gold Skulltula (Rock Formation)
    InsertActor  -Name "Skullwalltula" -X 1336   -Y 436    -Z (-542) -Param "B604" -XRot 0x0C17 -YRot 0x8000
    # Add gravestones because of Leevers
    InsertActor  -Name "Graveyard"     -X 1339   -Y 105    -Z (-926) -Param "0002" -XRot 0x2D83
    InsertActor  -Name "Graveyard"     -X (-450) -Y (-110) -Z 900    -Param "0002" -XRot 0x305B -YRot 0x1555
    # Fix Blue Warp
    InsertObject -Name "Warp Circle & Rupee Prism"
    InsertActor  -Name "Warp Portal" -X (-850) -Y 20 -Z (-2070) -Param "0006"
    InsertSpawnPoint -X (-850) -Y 20 -Z (-2070) -Param "0200" -YRot 0x1555
    SaveAndPatchLoadedScene



    # GERUDO'S FORTRESS #

    PrepareMap   -Scene "Gerudo's Fortress" -Map 0 -Header 0
    # Remove misplaced signpost
    RemoveActor  -Name "Square Signpost" -Compare "031A"
    # Add missing signpost object
    InsertObject -Name "Square Signpost"
    # Gold Skulltula (Fortress Wall)
    InsertObject -Name "Skulltulas"
    InsertActor  -Name "Skullwalltula" -X 1598 -Y 999 -Z (-2008) -Param "B502" -XRot 0x4000 -YRot 0xC000
    # Correct treasure chest to contain a heart piece
    ReplaceActor -Name "Treasure Chest" -Compare "03E0" -Param "07C0"
    # Be able to enter Gerudo Training Ground
    ReplaceActor -Name "Training Area Gate" -Compare "0002" -Param "003A"
    InsertActor  -Name "White Clothed Gerudo" -X 38 -Y 333 -Z (-1097) -Param "3A46" -YRot 0xC000
    # Be able to open the gate to the Haunted Wasteland
    ReplaceActor -Name "White Clothed Gerudo" -CompareX (-1224) -CompareY 93 -CompareZ (-3160) -X (-950) -Y 622 -Z (-3253) -Param "0301"
    # Add missing guard near ladder
    InsertActor  -Name "White Clothed Gerudo" -X (-857) -Y 112 -Z (-3123) -Param "0004" -YRot 0xF05B
    # Add missing guard on the way to the archery
    InsertActor  -Name "White Clothed Gerudo" -X 682 -Y 602 -Z (-307) -Param "0004" -YRot 0x8000
    # Add missing jail spawn point (fixes crash being caught if the cutscene has been triggered before)
    ChangeSpawnPoint -Index 17 -X 188 -Y 733 -Z (-2919) -YRot 0x0000
    InsertSpawnPoint           -X 188 -Y 733 -Z (-2919) -Param "0DFF"
    # Add missing patrolling guards
    InsertActor  -Name "Patrolling Gerudo" -X 56     -Y 333 -Z (-2238) -Param "0500" -ZRot 0x0002
    InsertActor  -Name "Patrolling Gerudo" -X 237    -Y 572 -Z (-949)  -Param "0500" -ZRot 0x0002
    InsertActor  -Name "Patrolling Gerudo" -X (-452) -Y 333 -Z (-1868) -Param "0A00" -YRot 0x4000 -ZRot 0x0002
    InsertActor  -Name "Patrolling Gerudo" -X 60     -Y 333 -Z (-1428) -Param "0A00" -YRot 0xC000 -ZRot 0x0002
    # Add grotto entrance
    InsertActor  -Name "Grotto Entrance"   -X 376    -Y 333 -Z (-1564) -Param "11FF" -YRot 0x4000
    # Adjust wooden flagpole YRot
    ReplaceActor -Name "Wooden Flagpole" -CompareX (-382) -CompareY 480 -CompareZ (-2237) -YRot 0xC000
    # Adjust crate Positions
    ReplaceActor -Name "Large Crate" -CompareZ (-1830) -Z (-1842)
    ReplaceActor -Name "Large Crate" -CompareZ (-1770) -Z (-1782)
    # Add missing crate containing 50 rupees
    InsertActor  -Name "Large Crate" -X 51 -Y 1113 -Z (-2997) -Param "FFFF" -XRot 0x14 -YRot 0x38E -ZRot 0x1F
    # Climbable wall in jail
    InsertObject -Name "Spirit Temple"
    InsertActor  -Name "Metal Crating Bridge" -X 80 -Y 713 -Z (-2802) -Param "00FF" -YRot 0x0400
    # Climbable wall for reaching the top of the fortress
    InsertActor  -Name "Metal Crating Bridge" -X 1050 -Y 673 -Z (-1715) -Param "00FF"
    SaveLoadedMap

    PrepareMap   -Scene "Gerudo's Fortress" -Map 1 -Header 0
    # Gold Skulltula (Target)
    InsertObject -Name "Skulltulas"
    InsertActor  -Name "Skullwalltula"        -X 3377 -Y 1734 -Z (-4935) -Param "B501" -XRot 0x4000
    # Remove airborn crate
    RemoveActor  -Name "Large Crate" -CompareY 1489
    # Add horse
    InsertActor  -Name "Rideable Horse"       -X 3705 -Y 1413 -Z (-665)  -Param "FFFF" -YRot 0xC000
    # Add guard
    InsertActor  -Name "White Clothed Gerudo" -X 3719 -Y 1413 -Z (-507)  -Param "0045" -YRot 0xC000
    SaveAndPatchLoadedScene



    # THIEVES' HIDEOUT #

    PrepareMap   -Scene "Thieves' Hideout" -Map 0 -Header 0 # Break Room - Hookshot Beams
    # Fix guard falling from the ceiling
    ReplaceActor -Name "Patrolling Gerudo" -Compare "0800" -Y (-160)
    # Add crates to get over the barricade
    InsertActor  -Name "Large Crate" -X 510 -Y 0 -Z (-3510) -Param "FFFF"
    InsertActor  -Name "Large Crate" -X 360 -Y 0 -Z (-3510) -Param "FFFF"
    SaveAndPatchLoadedScene



    # GANON'S CASTLE EXTERIOR #

    PrepareMap -Scene "Ganon's Castle Exterior" -Map 0 -Header 0
    # Change exit from Market Day 1 to Market Day 2 from Temple of Time Exterior
    ChangeExit -Index 0 -Exit "025E"
    SaveAndPatchLoadedScene



    # DEATH MOUNTAIN TRAIL #

    PrepareMap  -Scene "Death Mountain Trail" -Map 0 -Header 0
    # Remove actors to improve performance
    RemoveActor -Name "Bombable Boulder" -Compare "0007"
    RemoveActor -Name "Collectable"      -Compare "0701"
    RemoveActor -Name "Collectable"      -Compare "0A02"
    # Gold Skulltula (Near Bomb Flower)
    InsertActor -Name "Bronze Boulder" -X (-1175) -Y 1417 -Z (-803)  -Param "0009"
    InsertActor -Name "Skullwalltula"  -X (-1166) -Y 1465 -Z (-812)  -Param "B008" -XRot 0x4000 -YRot 0xD333
    # Gold Skulltula (Path to Crater)
    InsertActor -Name "Bronze Boulder" -X (-23)   -Y 2082 -Z (-3196) -Param "001A"
    InsertActor -Name "Skullwalltula"  -X 0       -Y 2123 -Z (-3196) -Param "B010" -XRot 0x4000 -YRot 0xB8E4
    SaveAndPatchLoadedScene



    # DEATH MOUNTAIN CRATER #

    PrepareMap   -Scene "Death Mountain Crater" -Map 1 -Header 0
    # Fix pots not dropping anything
    ReplaceActor -Name "Pot" -Compare "7F3F" -Param "4308"
    ReplaceActor -Name "Pot" -Compare "7F3F" -Param "4103"
    ReplaceActor -Name "Pot" -Compare "7F3F" -Param "4501"
    ReplaceActor -Name "Pot" -Compare "7F3F" -Param "470F"
    # Remember bronze boulders state
    ReplaceActor -Name "Bronze Boulder" -Compare "00FF" -Param "0015"
    ReplaceActor -Name "Bronze Boulder" -Compare "00FF" -Param "0016"
    ReplaceActor -Name "Bronze Boulder" -Compare "00FF" -Param "0017"
    ReplaceActor -Name "Bronze Boulder" -Compare "00FF" -Param "0018"
    # Remove undestructable rocks blocking off the Fire Temple entrance
    RemoveActor  -Name "Liftable Rock" -Compare "FF01"
    RemoveActor  -Name "Liftable Rock" -Compare "FF01"
    RemoveActor  -Name "Liftable Rock" -Compare "FF01"
    # Add small rocks near Fire Temple entrance, like in Adult era
    InsertActor  -Name "Liftable Rock" -X (-50) -Y 476 -Z (-714) -Param "0700"
    InsertActor  -Name "Liftable Rock" -X (-26) -Y 476 -Z (-807) -Param "0700" -YRot 0x0FA5
    InsertActor  -Name "Liftable Rock" -X 61    -Y 476 -Z (-763) -Param "0700" -YRot 0xECCD
    InsertActor  -Name "Liftable Rock" -X 71    -Y 471 -Z (-610) -Param "0700" -YRot 0xA9F5
    InsertActor  -Name "Liftable Rock" -X 79    -Y 476 -Z (-700) -Param "0700" -YRot 0xE444
    # Reposition upper heart piece
    ReplaceActor -Name "Collectable" -Compare "0806" -X 1116 -Y 379 -Z (-215)
    # Correct spawn point entering from Goron City
    ChangeSpawnPoint -Index 1  -X (-1749) -Z 26
    # Fix Blue Warp
    InsertObject -Name "Warp Circle & Rupee Prism"
    InsertActor  -Name "Warp Portal" -X 0 -Y 441 -Z 0 -Param "0006"
    InsertSpawnPoint -Y 441 -Param "0200" -YRot 0x8000 
    SaveAndPatchLoadedScene



    # GORON CITY #

    PrepareMap   -Scene "Goron City" -Map 1 -Header 0 # Darunia's Room
    # Remove Darunia Statue
    RemoveActor  -Name "Darunia's Room Statue" -Compare "FF00"
    # Remove Darunia Statue spear
    RemoveActor  -Name "Darunia's Room Statue" -Compare "0001"
    # Correct spawn point entering from crater
    ChangeSpawnPoint -Index 1 -X 47 -Y 40 -Z (-1523) -YRot 0xE889
    SaveLoadedMap

    PrepareMap   -Scene "Goron City" -Map 3 -Header 0 # City
    # Gold Skulltula (Center Platform)
    InsertObject -Name "Skulltulas"
    InsertActor  -Name "Skullwalltula" -X 1 -Y 499 -Z 165 -Param "9020" -XRot 0x4000 -YRot 0x8222
    # Adjust time blocks
    ReplaceActor -Name "Time Block" -Compare "3819" -Param "B819"
    ReplaceActor -Name "Time Block" -Compare "381A" -Y 410 -Z (-930) -Param "B81A"
    SaveAndPatchLoadedScene



    # TEMPLE OF TIME #

    PrepareMap   -Scene "Temple of Time" -Map 0 -Header 0
    # Remove Master Sword
    RemoveActor  -Name "Master Sword" -Compare "FFFF"
    # Place Master Sword in a chest
    InsertObject -Name "Treasure Chest"
    InsertActor  -Name "Treasure Chest" -X (-650) -Y 71    -Z 0   -Param "0FA0" -YRot 0xC000
    # Place Minuet of Forest in a chest
    InsertActor  -Name "Treasure Chest" -X 650    -Y 3     -Z 0   -Param "0B01" -YRot 0x4000
    SaveLoadedMap

    PrepareMap   -Scene "Temple of Time" -Map 1 -Header 0
    # Place Prelude of Light in a chest
    InsertObject -Name "Treasure Chest"
    InsertActor  -Name "Treasure Chest" -X (-390) -Y (-30) -Z 2021 -Param "0B42" -YRot 0xC000
    SaveAndPatchLoadedScene



    # MARKET (CHILD - NIGHT) #

    PrepareMap -Scene "Market (Child - Night)" -Map 0 -Header 0
    # Change exit from Temple of Time Exterior Day 0 to Ganon's Castle Exterior 0
    ChangeExit -Index 2 -Exit "013A"
    SaveAndPatchLoadedScene



    # DAMPÉ'S GRAVE & WINDMILL #

    PrepareMap   -Scene "Dampé's Grave & Windmill" -Map 5 -Header 0 # Stairs to Windmill
    # Adjust time blocks
    RemoveActor  -Name "Time Block" -Compare "B806"
    ReplaceActor -Name "Time Block" -Compare "B805" -Y (-469) -Param "3805"
    SaveLoadedMap

    PrepareMap   -Scene "Dampé's Grave & Windmill" -Map 6 -Header 0 # Windmill
    # Adjust time blocks
    RemoveActor  -Name "Time Block" -Compare "B806"
    ReplaceActor -Name "Time Block" -Compare "B805" -Y (-469) -Param "3805"
    SaveAndPatchLoadedScene



    # DODONGO'S CAVERN #
	
    PrepareMap   -Scene "Dodongo's Cavern" -Map 1 -Header 0 # Baby Dodongo Hallway
    # Make it possible for Child to reach the Gold Skulltula
    RemoveObject -Name "Blade Trap"
    RemoveObject -Name "Business Scrub"
    RemoveObject -Name "Pierre & Bonooru"
    RemoveActor  -Name "Pierre the Scarecrow Spawn" -Compare "0164"
    InsertObject -Name "Time Block"
    InsertObject -Name "Time Block Disappearance Effect"
    InsertActor  -Name "Time Block" -X 2150 -Y 0  -Z (-467) -Param "B81E"
    InsertActor  -Name "Armos"      -X 2040 -Y 13 -Z (-447) -Param "0000"
    SaveAndPatchLoadedScene



    # FOREST TEMPLE #

    PrepareMap   -Scene "Forest Temple" -Map 2 -Header 0 # Elevator Hall
    # Invert time block
    ReplaceActor -Name "Time Block" -Compare "B819" -Param "3819"
    SaveLoadedMap

    PrepareMap   -Scene "Forest Temple" -Map 7 -Header 0 # East Courtyard
    # Remove scarecrow
    RemoveObject -Name "Pierre & Bonooru"
    RemoveActor  -Name "Pierre the Scarecrow Spawn" -Compare "FFD3"
    SaveLoadedMap

    PrepareMap   -Scene "Forest Temple" -Map 11 -Header 0 # Tall Block Pushing Hall
    # Reposition upper push block
    ReplaceActor -Name "Pushable Block" -Compare "0702" -X (-1787) -Z (-1140)
    # Prevent jumping down from upper to lower push block (possible softlock)
    InsertActor  -Name "Clear Block" -X (-2027) -Y 893 -Z (-1140) -Param "FF01" -ZRot 0xC000
    # Replace Arrows (30) with Deku Seeds (30)
    ReplaceActor -Name "Treasure Chest" -Compare "8964" -Param "8D24"
    # Add clear blocks for climbing up top (0x05 and 0x07 push block switches)
    InsertObject -Name "Inside Ganon's Castle"
    InsertActor  -Name "Clear Block" -X (-1450) -Y 850  -Z (-1330) -Param "0701"
    InsertActor  -Name "Clear Block" -X (-1450) -Y 925  -Z (-1505) -Param "0501"
    InsertActor  -Name "Clear Block" -X (-1450) -Y 1000 -Z (-1330) -Param "0701"
    SaveLoadedMap

    PrepareMap   -Scene "Forest Temple" -Map 17 -Header 0 # Boss Door Shifting Hall
    # Replace Arrows (5) with 4th Empty Bottle
    ReplaceActor -Name "Treasure Chest" -Compare "592B" -Param "01EB"
    # Add pots containing Deku Seeds
    InsertActor  -Name "Pot" -X 29  -Y (-779) -Z (-2734) -Param "7A10" # 0x3D collectable flag
    InsertActor  -Name "Pot" -X 209 -Y (-779) -Z (-2734) -Param "7C10" # 0x3E collectable flag
    SaveAndPatchLoadedScene



    # FIRE TEMPLE #

    PrepareMap   -Scene "Fire Temple" -Map 1 -Header 0 -Shift # Lava Cavern
    # Reposition time block to access upper left room
    ReplaceActor -Name "Navi Block Info Spot" -Compare "3820" -CompareX 1560 -CompareY 100 -X 1639 -Y 70
    # Reach room to the right
    InsertObject -Name "Hookshot Pillar & Wall Target"
    InsertActor  -Name "Stone Hookshot Target" -X 1710 -Y 60 -Z 1360 -Param "FF00"
    SaveLoadedMap

    PrepareMap   -Scene "Fire Temple" -Map 2 -Header 0 # Boss Door Hall
    # Remove Darunia
    RemoveObject -Name "Darunia"
    RemoveActor  -Name "Darunia" -Compare "FFFF"
    # Hookshot targets to get out near the entrance
    InsertActor  -Name "Stone Hookshot Target" -X (-882)  -Y (-50)  -Z 220    -Param "FF00"
    InsertActor  -Name "Stone Hookshot Target" -X (-735)  -Y 40     -Z 145    -Param "FF00" -YRot 0x2600
    # Hookshot target to prevent being stuck in the center
    InsertActor  -Name "Stone Hookshot Target" -X (-1060) -Y (-130) -Z (-40)  -Param "FF00"
    # Clear blocks for reaching the boss door (0x0E Stone Spike Platform switch)
    InsertObject -Name "Inside Ganon's Castle"
    InsertActor  -Name "Clear Block"           -X (-1208) -Y 200    -Z 0      -Param "0E01"
    InsertActor  -Name "Clear Block"           -X (-840)  -Y 200    -Z 0      -Param "0E01"
    # Fire Temple stone block (elevator) to reach the pots
    InsertActor  -Name "Stone Blocks"          -X (-900)  -Y (-40)  -Z (-700) -Param "0001"
    SaveLoadedMap

    PrepareMap   -Scene "Fire Temple" -Map 3 -Header 0 # Flare Dancer Room - Entrance
    # Hookshot target to climb up to the chest
    InsertObject -Name "Hookshot Pillar & Wall Target"
    InsertActor  -Name "Stone Hookshot Target" -X (-361) -Y (-60) -Z (-1400) -Param "FF00"
    SaveLoadedMap

    PrepareMap   -Scene "Fire Temple" -Map 4 -Header 0 # Fire Slug Room
    # Hookshot target to climb Torch Slug places
    InsertObject -Name "Hookshot Pillar & Wall Target"
    InsertActor  -Name "Stone Hookshot Target" -X 2600 -Y 2100 -Z 750 -Param "FF00"
    # Add clear block to reach the push block
    InsertObject -Name "Inside Ganon's Castle"
    InsertActor  -Name "Clear Block" -X 2180 -Y 2260 -Z 500 -Param "FF01"
    SaveLoadedMap

    PrepareMap   -Scene "Fire Temple" -Map 5 -Header 0 # Boulder Maze
    # Remove scarecrow
    RemoveObject -Name "Pierre & Bonooru"
    RemoveActor  -Name "Pierre the Scarecrow Spawn" -Compare "017F"
    # Fire Temple stone block (elevator) for reaching the rooms above
    InsertActor  -Name "Stone Blocks" -X 1835 -Y 2930 -Z (-500) -Param "0001"
    SaveLoadedMap

    PrepareMap   -Scene "Fire Temple" -Map 10 -Header 0 # Invisible Fire Wall Maze
    # Prevent being stuck
    InsertActor  -Name "Stone Hookshot Target" -X (-1238) -Y 2660 -Z (-17) -Param "FF00"
    SaveLoadedMap

    PrepareMap   -Scene "Fire Temple" -Map 11 -Header 0 # Passthrough - Invisible Fire Wall Maze
    # Hookshot target and repositioned Time Block
    InsertActor  -Name "Stone Hookshot Target" -X (-1700) -Y 2740 -Z 280 -Param "FF00"
    ReplaceActor -Name "Navi Block Info Spot" -Compare "3021" -CompareX (-1730) -X (-1780)
    SaveLoadedMap

    PrepareMap   -Scene "Fire Temple" -Map 14 -Header 0 # Hidden Stairs Room
    # Make sure one can get back up before activating the stairs
    InsertObject -Name "Hookshot Pillar & Wall Target"
    InsertActor  -Name "Stone Hookshot Target" -X (-1825) -Y 4040 -Z (-947) -Param "FF00" -YRot 0xE000
    # Replace temporary switch with a rusty one
    ReplaceActor -Name "Switch" -Compare "3D20" -Param "3D01"
    SaveLoadedMap

    PrepareMap   -Scene "Fire Temple" -Map 16 -Header 0 # Flaming Wall of Death Room
    # Hookshot targets for reaching the upper Boulder Maze area and the Fire Wall Maze respectively
    InsertObject -Name "Hookshot Pillar & Wall Target"
    InsertActor  -Name "Stone Hookshot Target" -X 1381 -Y 2780 -Z (-740) -Param "FF00"
    InsertActor  -Name "Stone Hookshot Target" -X 440  -Y 2860 -Z 140    -Param "FF00" -XRot 0xC000
    SaveLoadedMap

    PrepareMap   -Scene "Fire Temple" -Map 18 -Header 0 # Tile Room - Entrance
    # Fix Like-Like not giving the Deku Shield back
    InsertObject -Name "Deku Shield"
    SaveLoadedMap

    PrepareMap   -Scene "Fire Temple" -Map 19 -Header 0 # Tile Room - Lava Cavern
    # Fix Like-Like not giving the Deku Shield back
    InsertObject -Name "Deku Shield"
    SaveAndPatchLoadedScene



    # WATER TEMPLE #

    PrepareMap   -Scene "Water Temple" -Map 0 -Header 0 # Central Hall
    # Remove Princess Ruto
    RemoveObject -Name "Adult Ruto"
    # Remove Scarecrow
    RemoveObject -Name "Pierre & Bonooru"
    RemoveActor  -Name "Pierre the Scarecrow Spawn" -Compare "FFD7" # Switch: 0x17
    # Lock Water Temple behind a rusty switch
    InsertObject -Name "Fire Temple"
    InsertActor  -Name "Switch"             -X (-130) -Y 777 -Z 560 -Param "1901"
    InsertActor  -Name "Sliding Metal Gate" -X (-180) -Y 780 -Z 427 -Param "1902"
    InsertActor  -Name "Sliding Metal Gate" -X (-180) -Y 900 -Z 427 -Param "1902"
    # Increase timer for the metal gate
    ReplaceActor -Name "Metal Gate"  -Compare "1153" -Param "1213"
    # Replace center level pot contents
    ReplaceActor -Name "Pot" -Compare "4403" -Param "4410" # Recovery Heart -> Deku Seeds (5)
    ReplaceActor -Name "Pot" -Compare "4603" -Param "460D" # Recovery Heart -> Deku Stick
    # Floor switch and clear block to exit lower level west corridor (0x10 Ruto switch)
    InsertActor  -Name "Switch"      -X (-1170) -Y (-263) -Z (-280) -Param "1000"
    InsertActor  -Name "Clear Block" -X (-1080) -Y 0      -Z (-120) -Param "1001"
    # Clear blocks to boss area (0x0E flooded basement puzzle)
    InsertObject -Name "Inside Ganon's Castle"
    InsertActor  -Name "Clear Block" -X (-176) -Y 800 -Z (-622)  -Param "0E01"
    InsertActor  -Name "Clear Block" -X (-176) -Y 800 -Z (-802)  -Param "0E01"
    # Clear blocks to boss key room (0x0E flooded basement puzzle)
    InsertActor  -Name "Clear Block" -X (-259) -Y 30    -Z (-1335) -Param "0E01"
    InsertActor  -Name "Clear Block" -X (-99)  -Y (-10) -Z (-1520) -Param "0E01" -XRot 0x4000
    SaveLoadedMap

    PrepareMap   -Scene "Water Temple" -Map 1 -Header 0 # Central Pillar
    # Fire Temple stone blocks (elevators) to get out of the spikes and go up
    InsertObject -Name "Fire Temple"
    InsertActor  -Name "Stone Blocks" -X (-300) -Y (-40) -Z (-287) -Param "0001"
    InsertActor  -Name "Stone Blocks" -X (-60)  -Y (-40) -Z (-287) -Param "0001"
    # Lower Gold Skulltula position
    ReplaceActor -Name "Skullwalltula" -CompareY 979 -Y 779
    SaveLoadedMap

    PrepareMap   -Scene "Water Temple" -Map 2 -Header 0 # Flooded Basement
    # Remove gates and puzzle elements
    RemoveActor  -Name "Metal Gate" -Compare "0FCE" # Switch: 0x0E
    RemoveActor  -Name "Room Timer" -Compare "3BFF" # Switch: 0x0E
    RemoveActor  -Name "Switch"     -Compare "3C03"
    RemoveActor  -Name "Metal Gate" -Compare "0FFC"
    SaveLoadedMap

    PrepareMap   -Scene "Water Temple" -Map 3 -Header 0 # Lower Level - South
    # Time block to cross the gap
    InsertObject -Name "Time Block"
    InsertObject -Name "Time Block Disappearance Effect"
    InsertActor  -Name "Time Block" -X (-1512) -Y 175 -Z 864 -Param "A11F" -YRot 0x4000 -ZRot 0x0001
    SaveLoadedMap

    PrepareMap   -Scene "Water Temple" -Map 4 -Header 0 # Mid Level - East
    # Hookshot target to get out of the water
    InsertActor  -Name "Stone Hookshot Target" -X 1375 -Y 756 -Z (-677) -Param "FF00" -XRot 0xC000
    SaveLoadedMap

    PrepareMap   -Scene "Water Temple" -Map 5 -Header 0 # Waterfall Room
    # Fire Temple platforms to get across the room
    InsertObject -Name "Fire Temple"
    InsertActor  -Name "Stone Blocks"   -X (-1703) -Y 340 -Z (-330) -Param "0001"
    InsertActor  -Name "Stone Platform" -X (-2003) -Y 660 -Z (-287) -Param "0001" -YRot 0x4000
    InsertActor  -Name "Stone Platform" -X (-1803) -Y 660 -Z (-77)  -Param "0001" -YRot 0xC000
    SaveLoadedMap

    PrepareMap   -Scene "Water Temple" -Map 6 -Header 0 # Dragon Statues Room
    # Floor switch to be able to get out of the water
    InsertActor  -Name "Switch"      -X (-3692) -Y 560  -Z (-391)  -Param "3110"
    # Clear blocks tied to the crystal switch
    InsertObject -Name "Inside Ganon's Castle"
    InsertActor  -Name "Clear Block" -X (-3180) -Y 760  -Z (-180)  -Param "3101"
    InsertActor  -Name "Clear Block" -X (-3780) -Y 800  -Z (-390)  -Param "3101"
    InsertActor  -Name "Clear Block" -X (-3320) -Y 800  -Z (-750)  -Param "3101"
    InsertActor  -Name "Clear Block" -X (-3110) -Y 1030 -Z (-1280) -Param "3101" -XRot 0x4000
    # Fix Like-Like not giving the Deku Shield back
    InsertObject -Name "Deku Shield"
    SaveLoadedMap

    PrepareMap   -Scene "Water Temple" -Map 7 -Header 0 # Longshot Room
    # Invert time block
    ReplaceActor -Name "Time Block"     -Compare "B80C" -Param "380C"
    # Replace Longshot with Golden Scale
    ReplaceActor -Name "Treasure Chest" -Compare "0127" -Param "0707"
    SaveLoadedMap

    PrepareMap   -Scene "Water Temple" -Map 8 -Header 0 # Spinning Water Room
    # Move crystal switch out of the water
    ReplaceActor -Name "Switch" -CompareX (-1463) -CompareY (-212) -CompareZ (-1833) -X (-1183) -Y 60 -Z (-1913)
    # Add switch for unlocking clear blocks in Map 0 for reaching boss door and boss key (0x0E flooded basement puzzle)
    InsertObject -Name "Fire Temple"
    InsertActor  -Name "Navi Message"       -X (-1530) -Y 260 -Z (-2260) -Param "044F"
    InsertActor  -Name "Navi Message"       -X (-1590) -Y 260 -Z (-2260) -Param "044F"
    InsertActor  -Name "Switch"             -X (-1560) -Y 260 -Z (-2210) -Param "0E00"
    InsertActor  -Name "Sliding Metal Gate" -X (-1560) -Y 260 -Z (-2160) -Param "0E01"
    SaveLoadedMap

    PrepareMap   -Scene "Water Temple" -Map 9 -Header 0 # Water Pillar Room
    # Add duplicate crystal switch to be able to get back up
    InsertActor  -Name "Switch" -X (-1080) -Y (-260) -Z (-1318) -Param "3D03"
    SaveLoadedMap

    PrepareMap   -Scene "Water Temple" -Map 12 -Header 0 # Rolling Boulder Room
    # Add target stone in case one falls into the water early
    InsertActor  -Name "Stone Hookshot Target" -X (-879) -Y 80 -Z (-2372) -Param "FF00" -XRot 0x4000
    SaveLoadedMap

    PrepareMap   -Scene "Water Temple" -Map 15 -Header 0 # Three Water Pillars Room
    # Add duplicate crystal switch to be able to get back up
    InsertActor  -Name "Switch" -X (-762) -Y (-240) -Z (-2985) -Param "3E03"
    SaveLoadedMap

    PrepareMap   -Scene "Water Temple" -Map 17 -Header 0 # Ruto Room
    # Remove Princess Ruto
    RemoveObject -Name "Adult Ruto"
    RemoveActor  -Name "Ruto (Adult)" -Compare "1004"      # Switch: 0x10
    # Replace pot contents
    ReplaceActor -Name "Pot" -Compare "4C09" -Param "4C0D" # Arrows (2x) -> Deku Stick
    SaveLoadedMap

    PrepareMap   -Scene "Water Temple" -Map 20 -Header 0 # Mid Level - South
    # Climbable Wall
    InsertObject -Name "Spirit Temple"
    InsertActor  -Name "Metal Crating Bridge" -X 660 -Y 470 -Z 130 -Param "00FF"
    SaveLoadedMap

    PrepareMap   -Scene "Water Temple" -Map 21 -Header 0 # Raging Water Cavern
    # Reposition Gold Skulltula
    ReplaceActor -Name "Skullwalltula" -CompareZ (-3469) -Z (-2869) -YRot 0x4000
    # Increase timer for the metal gate
    ReplaceActor -Name "Metal Gate" -Compare "117A" -Param "11FA"
    SaveAndPatchLoadedScene



    # SPIRIT TEMPLE #
	
    PrepareMap   -Scene "Spirit Temple" -Map 5 -Header 0 # Colossus Room
    # Remove Scarecrow
    RemoveObject -Name "Pierre & Bonooru"
    RemoveActor  -Name "Pierre the Scarecrow Spawn" -Compare "03FB"
    # Clear block near statue face (0x04 Spirit Temple Statue Face switch)
    InsertObject -Name "Inside Ganon's Castle"
    InsertActor  -Name "Clear Block" -X 60  -Y 1040 -Z (-1320) -Param "0401"
    # Create clear block staircase for reaching Adult area, after activating rusty floor switch (0x07)
    InsertActor  -Name "Clear Block" -X 655 -Y 350  -Z (-1040) -Param "0701"
    InsertActor  -Name "Clear Block" -X 655 -Y 390  -Z (-1040) -Param "0701"
    InsertActor  -Name "Clear Block" -X 655 -Y 430  -Z (-1010) -Param "0701"
    InsertActor  -Name "Clear Block" -X 655 -Y 470  -Z (-980)  -Param "0701"
    # Clear block shortcut to chain platform once it has been lowered (0x17)
    InsertActor  -Name "Clear Block" -X (-560) -Y 813   -Z (-1128) -Param "1701"
    InsertActor  -Name "Clear Block" -X (-385) -Y 888   -Z (-1128) -Param "1701"
    InsertActor  -Name "Clear Block" -X (-210) -Y 963   -Z (-1128) -Param "1701"
    SaveLoadedMap

    PrepareMap   -Scene "Spirit Temple" -Map 12 -Header 0 # Sole Room - Rolling Boulder Room
    # Fix Like-Like not giving the Deku Shield back
    InsertObject -Name "Deku Shield"
    SaveLoadedMap

    PrepareMap   -Scene "Spirit Temple" -Map 14 -Header 0 # Quicksand Room
    # Clear block for reaching the chest
    InsertObject -Name "Inside Ganon's Castle"
    InsertActor  -Name "Clear Block" -X 373 -Y 30 -Z (-1125) -Param "3101"
    SaveLoadedMap

    PrepareMap   -Scene "Spirit Temple" -Map 22 -Header 0 # Sole Room - Triforce Corridor
    RemoveObject -Name "Inside Ganon's Castle"
    RemoveObject -Name "Hookshot Pillar & Wall Target"
    RemoveActor  -Name "Stone Hookshot Target" -Compare "FFC2"
    RemoveActor  -Name "Clear Block"           -Compare "FF01"
    RemoveActor  -Name "Clear Block"           -Compare "0101"
    RemoveActor  -Name "Switch"                -Compare "3700"
    # Use the eye switch to turn off the fire
    ReplaceActor -Name "Switch"                -Param "3702"
    SaveLoadedMap

    PrepareMap   -Scene "Spirit Temple" -Map 26 -Header 0 # Rotating Mirror Statues Room
    # Time block, so Child can activate the sun switch
    InsertObject -Name "Time Block"
    InsertObject -Name "Time Block Disappearance Effect"
    InsertActor  -Name "Time Block" -X (-560) -Y 1720 -Z (-900) -Param "39FF" -ZRot 0x0003
    SaveAndPatchLoadedScene



    # BOTTOM OF THE WELL #

    PrepareMap   -Scene "Bottom of the Well" -Map 1 -Header 0 # Bottom Pit
    # Add bomb flower and grass shrub to prevent softlocks when not having strength or explosives
    InsertActor  -Name "Bomb Flower" -X (-709) -Y (-720) -Z (-797) -Param "FFFF"
    InsertActor  -Name "Grass Shrub" -X 884    -Y (-720) -Z (-793) -Param "FF01"
    SaveAndPatchLoadedScene



    # SHADOW TEMPLE #
	
    PrepareMap   -Scene "Shadow Temple" -Map 2 -Header 0 # Entrance
    # Clear blocks for crossing the first gap
    InsertObject -Name "Inside Ganon's Castle"
    InsertActor  -Name "Clear Block" -X 34     -Y (-63) -Z 295 -Param "FF01"
    InsertActor  -Name "Clear Block" -X (-142) -Y (-63) -Z 295 -Param "FF01"
    SaveLoadedMap

    PrepareMap   -Scene "Shadow Temple" -Map 6 -Header 0 # Scythe Shortcut Room
    # Lower scythe trap
    ReplaceActor -Name "Spinning Scythe Trap" -CompareY (-543) -Y (-563)
    # Reposition unreachable Silver Rupee
    ReplaceActor -Name "Silver Rupee" -CompareX 3007 -CompareY (-423) -CompareZ (-1222) -X 3220 -Y (-543) -Z (-747)
    SaveLoadedMap

    PrepareMap   -Scene "Shadow Temple" -Map 10 -Header 0 # Falling Spike Blocks Trap Room
    # Replace Arrows (10) with Deku Seeds (30)
    ReplaceActor -Name "Treasure Chest" -Compare "5945" -Param "5D25"
    # Hookshot target to get onto the push block
    InsertObject -Name "Hookshot Pillar & Wall Target"
    InsertActor  -Name "Stone Hookshot Target" -X 275 -Y (-1395) -Z 3735  -Param "FF00"
    SaveLoadedMap
	
    PrepareMap   -Scene "Shadow Temple" -Map 11 -Header 0 # Invisible Spike Room
    # Reach invisible platform in the corner
    InsertObject -Name "Hookshot Pillar & Wall Target"
    InsertActor  -Name "Stone Hookshot Target" -X 2021 -Y (-1385) -Z 1013 -Param "FF00"
    # Reach silver rupees and upper door
    InsertObject -Name "Inside Ganon's Castle"
    InsertActor  -Name "Clear Block"           -X 2084 -Y (-1203) -Z 1160 -Param "FF01" -YRot 0x9A00
    InsertActor  -Name "Clear Block"           -X 2275 -Y (-1203) -Z 869  -Param "FF01"
    InsertActor  -Name "Clear Block"           -X 2750 -Y (-1203) -Z 869  -Param "FF01"
    SaveLoadedMap

    PrepareMap   -Scene "Shadow Temple" -Map 16 -Header 0 # Invisible Scythe Room
    # Invert time block, lower it and recovery hearts
    ReplaceActor -Name "Collectable"    -Compare "2003" -CompareY (-1028) -Y (-1058)
    ReplaceActor -Name "Collectable"    -Compare "2103" -CompareY (-1028) -Y (-1058)
    ReplaceActor -Name "Time Block"     -Compare "380A" -CompareY (-1143) -Y (-1173) -Param "B80A"
    # Replace Arrows (30) with Deku Seeds (30)
    ReplaceActor -Name "Treasure Chest" -Compare "6976" -Param "6D36"
    # Lower scythe trap
    ReplaceActor -Name "Spinning Scythe Trap" -CompareY (-1143) -Y (-1183)
    SaveLoadedMap

    PrepareMap   -Scene "Shadow Temple" -Map 19 -Header 0 # Sole Room - Wind Fans Room
    # Replace Arrows (10) with Deku Seeds (30)
    ReplaceActor -Name "Treasure Chest" -Compare "6955" -Param "6D35"
    SaveLoadedMap

    PrepareMap   -Scene "Shadow Temple" -Map 21 -Header 0 # River of Death
    # Remove scarecrows
    RemoveObject -Name "Pierre & Bonooru"
    RemoveActor  -Name "Pierre the Scarecrow Spawn" -Compare "0539"
    RemoveActor  -Name "Pierre the Scarecrow Spawn" -Compare "053B"
    # Reposition Gold Skulltula
    ReplaceActor -Name "Skullwalltula" -CompareX 3881 -CompareY (-948) -CompareZ (-1495) -X 4981 -Y (-948) -Z (-1435)
    # Reach ladder
    InsertActor  -Name "Stone Hookshot Target" -X 4520 -Y (-1410) -Z (-1506) -Param "FF00"
    # Reposition Time Block to be able to backtrack
    ReplaceActor -Name "Time Block" -Compare "380C" -CompareX (-3065) -CompareY (-1363) -CompareZ (-642) -X (-2465) -Y (-1423) -Z (-804) -Param "B80C"
    SaveAndPatchLoadedScene



    # ICE CAVERN #

    PrepareMap   -Scene "Ice Cavern" -Map 3 -Header 0 # Second Open Room
    # Hookshot target and a clear block for climbing up
    InsertObject -Name  "Inside Ganon's Castle"
    InsertObject -Name  "Hookshot Pillar & Wall Target"
    InsertActor  -Name  "Stone Hookshot Target" -X 600 -Y (-60) -Z (-570) -Param "FF00" -YRot 0x1000
    InsertActor  -Name  "Clear Block"           -X 415 -Y 164   -Z (-570) -Param "FF01" -YRot 0x2000
    SaveAndPatchLoadedScene



    # GERUDO TRAINING GROUND #

    PrepareMap   -Scene "Gerudo Training Ground" -Map 0 -Header 0 # Entrance
    # Replace Arrows (10) with Deku Seeds (30)
    ReplaceActor -Name "Treasure Chest" -Compare "8947" -Param "8D27"
    SaveLoadedMap

    PrepareMap   -Scene "Gerudo Training Ground" -Map 2 -Header 0 # Hookshot Challenge
    # Remove one of the fire walls
    RemoveActor  -Name "Proximity Fire Wall" -CompareX (-1759) -CompareY 160 -CompareZ (-1921)
    # Reposition unobtainable silver rupee
    ReplaceActor -Name "Silver Rupee" -CompareX (-1579) -CompareY 236 -CompareZ (-999) -X (-1275) -Y 160 -Z (-2134)
    SaveLoadedMap

    PrepareMap   -Scene "Gerudo Training Ground" -Map 3 -Header 0 # Fake Room
    # Replace Arrows (30) with Deku Seeds (30)
    ReplaceActor -Name "Treasure Chest" -Compare "7971" -Param "7D31"
    # Reach upper area
    InsertObject -Name "Time Block"
    InsertObject -Name "Time Block Disappearance Effect"
    InsertActor  -Name "Time Block" -X (-1309) -Y 129 -Z (-2748) -Param "B81D" -YRot 0x4000 -ZRot 0x0006
    SaveLoadedMap

    PrepareMap   -Scene "Gerudo Training Ground" -Map 4 -Header 0 # Eye Statue Challenge
    # Remove scarecrow
    RemoveObject -Name "Pierre & Bonooru"
    RemoveActor  -Name "Pierre the Scarecrow Spawn" -Compare "02A8"
    # Be able to exit the center platform
    InsertObject -Name "Time Block"
    InsertObject -Name "Time Block Disappearance Effect"
    InsertActor  -Name "Time Block" -X (-375) -Y (-206) -Z (-2640) -Param "A118" -YRot 0x5000 -ZRot 0x0006
    SaveLoadedMap

    PrepareMap   -Scene "Gerudo Training Ground" -Map 5 -Header 0 # Hammer Challenge
    # Replace Arrows (10) with Deku Seeds (30)
    ReplaceActor -Name "Treasure Chest" -Compare "7952" -Param "7D32"
    SaveLoadedMap

    PrepareMap   -Scene "Gerudo Training Ground" -Map 6 -Header 0 # Lava Challenge
    # Invert time blocks
    ReplaceActor -Name "Time Block" -Compare "382C" -Param "B82C"
    ReplaceActor -Name "Time Block" -Compare "382D" -Param "B82D"
    # Reposition upper silver rupee
    ReplaceActor -Name "Silver Rupee" -CompareX 1437 -CompareY 30 -CompareZ (-2193) -X 1405 -Y (-239) -Z (-1660)
    SaveLoadedMap

    PrepareMap   -Scene "Gerudo Training Ground" -Map 8 -Header 0 # Central Crates Room
    # Replace Arrows (30) with Deku Seeds (30)
    ReplaceActor -Name "Treasure Chest" -Compare "5968" -Param "5D28"
    ReplaceActor -Name "Treasure Chest" -Compare "5969" -Param "5D29"
    # Replace Ice Arrows with Biggoron Sword
    ReplaceActor -Name "Treasure Chest" -Compare "0B2C" -Param "0AEC"
    SaveLoadedMap

    PrepareMap   -Scene "Gerudo Training Ground" -Map 10 -Header 0 # Preview Room
    # Replace Ice Trap with Light Medallion (Ice Arrows) in a large clear triggered chest
    ReplaceActor -Name "Treasure Chest" -Compare "5F82" -Param "1B22"
    # Fix Like-Like not giving the Deku Shield back
    InsertObject -Name "Deku Shield"
    SaveAndPatchLoadedScene



    # INSIDE GANON'S CASTLE #

    PrepareMap   -Scene "Inside Ganon's Castle" -Map 0 -Header 0 # Entrance
    # Fix exit
    ChangeExit   -Index 0 -Exit "023F"
    SaveLoadedMap

    PrepareMap   -Scene "Inside Ganon's Castle" -Map 3 -Header 0 # Water Trial #2
    # Reach rusted floor switch
    InsertObject -Name  "Hookshot Pillar & Wall Target"
    InsertActor  -Name  "Stone Hookshot Target" -X 2822 -Y (-380) -Z (-1175) -Param "FF00"
    InsertActor  -Name  "Stone Hookshot Target" -X 2947 -Y (-200) -Z (-1380) -Param "FF00" -XRot 0x4000
    # Reach door leading to the barrier
    InsertActor  -Name  "Stone Hookshot Target" -X 3310 -Y (-380) -Z (-945)  -Param "FF00"
    # Prevent being stuck in the push block gap
    InsertActor  -Name  "Stone Hookshot Target" -X 2829 -Y (-480) -Z (-743)  -Param "FF00"
    SaveLoadedMap

    PrepareMap   -Scene "Inside Ganon's Castle" -Map 5 -Header 0 # Forest Trial #1
    # Change up torch puzzle
    ReplaceActor -Name  "Torch" -CompareX 1140 -CompareY 310 -CompareZ 1133 -X 1250 -Y 116 -Z 1037               -YRot 0xD550
    InsertActor  -Name  "Torch"                                             -X 996  -Y 116 -Z 1187 -Param "1150" -YRot 0xD550
    SaveLoadedMap

    PrepareMap   -Scene "Inside Ganon's Castle" -Map 6 -Header 0 # Forest Trial #2
    # Time blocks near entrance
    ReplaceActor -Name  "Time Block" -Compare "3824"       -Param "B824"
    InsertActor  -Name  "Time Block" -X 1261 -Y 11 -Z 1518 -Param "B818" -YRot 0x1555 -ZRot 0x0007
    # Hookshot target near barrier door
    ReplaceActor -Name  "Silver Rupee" -CompareX 1651 -CompareY 30 -CompareZ 2021 -Y 70
    InsertActor  -Name  "Stone Hookshot Target" -X 1651 -Y (-30) -Z 2021 -Param "FF00" -YRot 0x1555
    SaveLoadedMap

    PrepareMap   -Scene "Inside Ganon's Castle" -Map 8 -Header 0 # Light Trial #1
    # Reposition upper Silver Rupee
    ReplaceActor -Name  "Silver Rupee" -CompareX (-2646) -CompareY (-120) -CompareZ (-839) -X (-2815) -Y (-270) -Z (-840)
    SaveLoadedMap

    PrepareMap   -Scene "Inside Ganon's Castle" -Map 9 -Header 0 # Light Trial #2
    # Replace Arrows (30) with Deku Seeds (30)
    ReplaceActor -Name "Treasure Chest" -Compare "596A" -Param "5D2A"
    SaveLoadedMap

    PrepareMap   -Scene "Inside Ganon's Castle" -Map 12 -Header 0 # Shadow Trial
    # Invert time blocks
    ReplaceActor -Name  "Time Block" -Compare "3821" -Param "B821"
    ReplaceActor -Name  "Time Block" -Compare "3822" -Param "B822"
    ReplaceActor -Name  "Time Block" -Compare "3823" -Param "B823"
    # Replace torches with crystal switches
    RemoveActor  -Name  "Torch" -Compare "1079"
    RemoveActor  -Name  "Torch" -Compare "107A"
    InsertActor  -Name  "Switch" -X 1291 -Y 150 -Z (-2259) -Param "7903"
    InsertActor  -Name  "Switch" -X 1980 -Y 210 -Z (-4536) -Param "7A03"
    # Fix Like-Like not giving the Deku Shield back
    InsertObject -Name "Deku Shield"
    SaveLoadedMap

    PrepareMap   -Scene "Inside Ganon's Castle" -Map 14 -Header 0 # Fire Trial
    # Add moving platform for reaching barrier door
    InsertActor  -Name  "Stone Platform" -X (-1409) -Y 20 -Z (-3551) -Param "0001" -YRot 0x1555
    SaveLoadedMap

    PrepareMap   -Scene "Inside Ganon's Castle" -Map 17 -Header 0 # Spirit Trial #1
    # Reposition upper Silver Rupee
    ReplaceActor -Name  "Silver Rupee" -CompareX (-829) -CompareY 274 -CompareZ 591 -Y 165
    SaveLoadedMap

    PrepareMap   -Scene "Inside Ganon's Castle" -Map 18 -Header 0 # Spirit Trial #2
    # Replace Arrows (10) with Large Magic Jar
    ReplaceActor -Name  "Treasure Chest" -Compare "6954" -Param "6D34"
    # Time block for reaching the web
    InsertObject -Name  "Time Block"
    InsertObject -Name  "Time Block Disappearance Effect"
    InsertActor  -Name  "Time Block" -X (-1175) -Y 110 -Z 1196 -Param "B81F" -YRot 0x2AAB -ZRot 0x0007
    SaveAndPatchLoadedScene

}



#==============================================================================================================================================================================================
function ChildQuestClassicByteTextOptions() {
    
    # Chests
    SetMessage -ID "0031" -Replace "<NS><DI>You obtained the <R>Bolero of Fire<W>!<DC><N>Finally, you may fully explore<N>the depths of the Death<N>Mountain Crater." # Fairy Bow -> Bolero of Fire
    SetMessage -ID "0036" -Replace "<NS><DI>You obtained the <M>Song of Storms<W>!<DC><N>Its destructive power seems<N>overwhelming. Be mindful when<N>using it." # Hookshot -> Song of Storms
    SetMessage -ID "0070" -Replace "<NS><DI>You obtained the <G>Minuet of Forest<W>!<DC><N>The Sacred Forest Meadow and its<N>Temple are now always within<N>reach." # Fire Arrows -> Minuet of Forest
    SetMessage -ID "0071" -Replace "<NS><Icon:6B>You received something useless,<N>very reminiscent of the<N><C>Light Medallion<W>!" # Ice Arrows -> Light Medallion
    SetMessage -ID "0072" -Replace "<NS><DI>You obtained the <C>Prelude of Light<W>!<DC><N>Return to the Temple of Time<N>swiftly, regardless of your<N>current location." # Light Arrows -> Prelude of Light

    if (IsChecked -Elem $Redux.Graphics.EnhancedChildQuestModel) {
        SetMessage -ID "00BE" -Replace "<NS><Icon:3C><DI>You got the <G>Razor Sword<W>!<DC><N>This new, sharper blade is a cut<N>above the rest."
        SetMessage -ID "000C" -Replace "<NS><Icon:3D><DI>You got the <R>Gilded Sword<W>!<DC><N>This blade was forged by a<N>master smith to deal<N>extra damage!"
    }
    else {
        SetMessage -ID "00BE" -Replace "<NS><Icon:3C><DI>You got the <G>Master Sword<W>!<DC><N>This is a treasure of the<N>chosen hero."
        SetMessage -ID "000C" -Replace "<NS><Icon:3D><DI>You got the <R>Biggoron's Sword<W>!<DC><N>This blade was forged by a<N>master smith to deal<N>extra damage!"
    }



    # Hylian Shield
    if (IsChecked -Elem $Redux.Graphics.EnhancedChildQuestModel) {
           SetMessage -ID "004D" -Replace "<Icon:3F><DI>You got a <C>Hero's Shield<W>!<DC><N>Switch to the <B>Equipment<N>Subscreen<W> and select this<N>shield, then equip it with <B><A Button><W>."
           SetMessage -ID "0092" -ASCII -Text "Hylian Shield" -Replace "Hero's Shield"
           SetMessage -ID "009C" -Replace "My current hot seller is the<N><C>Hero's Shield<W>, but it might be too<N>heavy for you, kid.<Event>"
           SetMessage -ID "00A9" -Replace "<DI><R>Hero's Shield   80 Rupees<N><W>This is the shield heroes use.<N>It can stand up to flame attacks!<DC><Shop Description>"
           SetMessage -ID "7013" -Replace "If you plan on scaling Death<N>Mountain, buy a <C>Hero's Shield<W>.<N>You can defend yourself against<N>falling rocks with that shield."
           SetMessage -ID "7121" -ASCII -Text "Hylian Shields" -Replace "Hero's Shields"
    }
    else { SetMessage -ID "009C" -Replace "My current hot seller is the<N><C>Hylian Shield<W>, but it might be too<N>heavy for you, kid.<Event>" }



    # Goron Tunic
    SetMessage -ID "0050" -Replace "<Icon:42><DI>You got a <R>Goron Tunic<W>!<DC><N>This is a heat-resistant tunic.<N>Going to a hot place? No worry!"
    SetMessage -ID "00AA" -Replace "<DI><R>Goron Tunic   200 Rupees<N><W>A tunic made by Gorons.<N>Protects you from heat damage.<DC><Shop Description>"



    # Zora Tunic
    SetMessage -ID "0051" -Replace "<Icon:43><DI>You got a <B>Zora Tunic<W>!<DC><N>This is a diving suit. Wear it<N>and you won't drown underwater."
    SetMessage -ID "00AB" -Replace "<DI><R>Zora Tunic   300 Rupees<N><W>A tunic made by Zoras. Prevents<N>you from drowning underwater.<DC><Shop Description>"



    # Time related dialog
    SetMessage -ID "1063" -Replace "<NS>Hey, have you seen your old<N>friends? None of them grew<N>a tiny bit since you first left,<N>did they?<New Box><NS>That's because the <G>Kokiri<W> never<N>grow up! Even after many years,<N>they're still going to be kids!" # Deku Tree Sprout
    SetMessage -ID "5025" -Replace "<NS>We Sheikah have served the<N>royalty of Hyrule from generation<N>to generation as attendants.<N>However...<New Box><NS>On that day Ganondorf<N>suddenly attacked...and<N>Hyrule Castle surrendered<N>after a short time.<New Box><NS>Ganondorf's target was one of<N>the keys to the Sacred Realm...the<N>hidden treasure of the Royal<N>Family...The Ocarina of Time!<New Box><NS>My duty bound me to take Zelda<N>out of Ganondorf's reach.<New Box><NS>When last I saw you, as we made<N>our escape from the castle, you<N>were just a lad...<New Box><NS>Now I see that you have become<N> a fine hero..." # Impa
    SetMessage -ID "70C9" -Replace "<NS>The two Triforce parts that I<N>could not capture on that day...<New Box><NS>I didn't expect they would be<N>hidden within you two!" # Ganondorf
    SetMessage -ID "6035" -Replace "<NS>Kid, let me thank you.<N><NS>Heheheh...look what the little<N>kid has become--a competent<N>swordsman!" # Nabooru
    SetMessage -ID "600C" -Replace "<NS>Past, present, future...<New Box><NS>The Master Sword is a ship with<N>which you can sail upstream and<N>downstream through time's river...<New Box><NS>The port for that ship is in the<N>Temple of Time...<New Box><NS>Listen to this <Y>Requiem of Spirit<W>...<N>This melody will lead a child back<N>to the desert." # Sheik
    SetMessage -ID "6079" -Replace "<NS>Hey, what's up, <Player>?<N>Surprised to see me?<New Box><NS>A long time in this world is<N>almost nothing to you, is it?<N>How mysterious!<New Box><NS>Even I thought that the tales of a<N>boy who could defeat the evil<N>was merely a legend.<New Box><NS><Player>, you have fully<N>matured as an adult.<Jump:607A>" # Kaepora Gaebora



    # Water Medallion
    SetMessage -ID "4046" -ASCII -Text "my eternal love to you" -Replace "you my eternal respect"



    # Spirit Medallion
    SetMessage -ID "6036" -Replace "<NS>I should have kept the promise<N>I made back then...<Fade:5A>"



    # All medallions cutscene (Rauru)
    SetMessage -ID "5024" -Replace "<NS><Player>, the hero!<New Box><NS>Finally, all of us, the <R>six Sages<W>,<N>have been awakened!<N>The time for the final showdown<N>with the King of Evil has come!<New Box><NS>During the night at the market,<N>head to the <C>Temple of Time<W> to<N>find Ganon's Castle."



    # Haunted Wasteland hint (Gerudo Fortress guard opening the gate)
    SetMessage -ID "6018" -Replace "The first trial is...the <R>River of<N>Sand<W>! You can't walk across this<N>river without the <R>proper boots<W>!<New Box>After you cross it, follow<N>the flags we placed there.<New Box>The second trial is...the <R>Phantom<N>Guide<W>!<New Box>Those without <R>eyes that can see<N>the truth <W>will only find themselves<N>returning here.<New Box>You are going anyway, aren't you?<N>I won't stop you...<N>Go ahead!<Event>"



    # Dampé chest reward
    SetMessage -ID "502D" -Replace "<NS>Hehehe, young man...<N>You were very quick to be able<N>to keep up with me! Hehehe!<New Box><NS>As a reward, I'm going to give<N>you my treasure.<New Box><NS>I'm sure it will help you!<New Box><NS>I live here now, so come back<N>again sometime. I'll give you<N>something cool!<New Box><NS>One more thing! Be careful on<N>your way back!<N>Heheheh...."



    # Gerudo Guard on Gerudo Valley bridge
    SetMessage -ID "6069" -Replace "The <R>Gerudo's Fortress <W>is located<N>beyond this bridge. A kid like<N>you has no business there."



    # Slingshot (Get Item)
    SetMessage -ID "0030" -Replace "<NS><Icon:06><DI>You found the <R>Fairy Slingshot<W>!<DC><N>On the <Y>Select Item Subscreen<W>,<N>you can set it to <Y><C Left><W>, <Y><C Down><W> or<Y> <C Right><W>.<New Box><NS><Icon:06>Press <Y><C Button> <W>to take it out and hold<N>it. As you hold <Y><C Button> <W>you can aim<N>with <C><Control Stick><W>. Release <Y><C Button><W> to unleash<N>a <R>Deku Seed<W>.<New Box><NS><Icon:06>If you want to shoot right<N>away, when you first press <Y><C Button><W>,<N>hold down <Y><C Button> <W>a little longer to<N>get a seed ready.<New Box><NS><Icon:06>This weapon inherits strenghts<N>of the so called <R>Fairy Bow<W>.<N>Make sure to try it out in<N>sticky situations.<N>"



    # Silver Gauntlets
    SetMessage -ID "005B" -Replace "<NS><Icon:51><DI>You found the <B>Silver Gauntlets<W>!<DC><N>If you wore them, you would<N>feel power in your arms, the<N>power to lift big things with <B><A Button><W>!<New Box><NS><Icon:51>But, you promised to give them<N>to <R>Nabooru<W>. You should keep your<N>word..."



    # Fire Temple
    SetMessage -ID "01A5" -Replace "<NS><C>You can see down from here...<N>Isn't that the room where we saw<N>the <W>boss door<C>?<W>"



    # Morpha
    SetMessage -ID "0625" -Replace "<DI>Morpha<N><C>Lure it out by standing at the<N>center of a platform and spin<N>attack to damage its <W>nucleus<C>!<W><DC>"



    # Added Water Temple Navi Message (replacing Longshot GI text)
    SetMessage -ID "014F" -Replace "<NS><C>Maybe this <W>switch <C>does more<N>than just opening this gate?<W>"

}
