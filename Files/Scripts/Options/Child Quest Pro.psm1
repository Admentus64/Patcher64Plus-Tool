function ChildQuestProExposeOptions() {
    
    # Exclude Group
    ExcludeGroup  -Group "Unlock"       -Name "Unlock Child Restrictions"
    ExcludeGroup  -Group "Equipment"    -Name "Swords & Shields"
    ExcludeGroup  -Group "Previews"     -Name "Equipment Previews"



    # Expose Options
    ExposeOption  -Group "Fixes"        -Option "PoacherSaw"
    ExposeOption  -Group "Equipment"    -Option "NoSlipperyBoots"
    ExposeOption  -Group "Hitbox"       -Option "MasterSword"
    ExposeOption  -Group "Hitbox"       -Option "GiantsKnife"
    ExposeOption  -Group "Hitbox"       -Option "BrokenGiantsKnife"
    ExposeOption  -Group "Hitbox"       -Option "MegatonHammer"
    ExposeOption  -Group "Hitbox"       -Option "Hookshot"
    ExposeOption  -Group "Hitbox"       -Option "Longshot"
    ExposeOption  -Group "Save"         -Option "Quiver"
    ExposeOption  -Group "Capacity"     -Option "Quiver1"
    ExposeOption  -Group "Capacity"     -Option "Quiver2"
    ExposeOption  -Group "Capacity"     -Option "Quiver3"
    ExposeOption  -Group "Capacity"     -Option "Arrows5"
    ExposeOption  -Group "Capacity"     -Option "Arrows10"
    ExposeOption  -Group "Capacity"     -Option "Arrows30"
    ExposeOption  -Group "ShopQuantity" -Option "Arrows10"
    ExposeOption  -Group "ShopQuantity" -Option "Arrows30"
    ExposeOption  -Group "ShopQuantity" -Option "Arrows50"
    ExposeOption  -Group "ShopPrice"    -Option "Arrows10"
    ExposeOption  -Group "ShopPrice"    -Option "Arrows30"
    ExposeOption  -Group "ShopPrice"    -Option "Arrows50"



    # Exclude Options
    ExcludeOption -Group "Misc"         -Option "SkipCutscenes"
    ExcludeOption -Group "Gameplay"     -Option "Medallions"
    ExcludeOption -Group "Fixes"        -Option "GerudosFortress"
    ExcludeOption -Group "Fixes"        -Option "VisibleGerudoTent"
    ExcludeOption -Group "Fixes"        -Option "Dungeons"
    ExcludeOption -Group "Graphics"     -Option "ForceHiresModel"
    ExcludeOption -Group "Styles"       -Option "HairColor"
    ExcludeOption -Group "Equipment"    -Option "HideSword"
    ExcludeOption -Group "Equipment"    -Option "HideShield"
    ExcludeOption -Group "Equipment"    -Option "FunctionalWeapons"
    ExcludeOption -Group "Save"         -Option "BulletBag"
    ExcludeOption -Group "Save"         -Option "OcarinaOfTime"
    ExcludeOption -Group "Save"         -Option "LongShot"
    ExcludeOption -Group "Capacity"     -Option "BulletBag1"
    ExcludeOption -Group "Capacity"     -Option "BulletBag2"
    ExcludeOption -Group "Capacity"     -Option "BulletBag3"
    ExcludeOption -Group "Capacity"     -Option "DekuSeedBullets5"
    ExcludeOption -Group "Capacity"     -Option "DekuSeedBullets30"
    ExcludeOption -Group "ShopPrice"    -Option "DekuSeedBullets30"



    # Force Options
    ForceOption   -Group "Sounds"       -Option "ChildVoices"   -Values "Majora's Mask"
    ForceOption   -Group "Equipment"    -Option "PowerBracelet"
    ForceOption   -Group "Equipment"    -Option "HerosBow"



    # Default Option Values
    DefaultOptionValue -Group "Hitbox"  -Option "MasterSword" -Value 3500
    DefaultOptionValue -Group "Hitbox"  -Option "GiantsKnife" -Value 4000

}



#==============================================================================================================================================================================================
function ChildQuestProPatchOptions() {

    ApplyPatch -Patch "Decompressed\Optional\Child Quest\child_quest_pro_model.ppf"

}



#==============================================================================================================================================================================================
function ChildQuestProByteOptions() {

    # Patch dungeons to MQ/Ura in advance
    PatchDungeonsOoTMQ



    # Sound
    CopyBytes   -Offset "2FDD2"  -Length "3F" -Start "2FE12"                # Use Child sound IDs for Adult voice
    PatchBytes  -Offset "18E1E0" -Patch ("Child Quest\hookshot_sfx_01.bin") # Replace Adult hookshot sound
    PatchBytes  -Offset "18FA50" -Patch ("Child Quest\hookshot_sfx_02.bin") # Replace Adult hookshot sound



    # Equipment
    PatchBytes  -Offset "7F9000"  -Texture -Patch "Equipment\Kokiri Sword\Razor Sword.icon"                                                                                             # Icon:  Master Sword -> Razor Sword
    PatchBytes  -Offset "8ADC00"  -Texture -Patch "Equipment\Kokiri Sword\Razor Sword.en.label"                                                                                         # Label: Master Sword -> Razor Sword
    PatchBytes  -Offset "3485000" -Patch ("Object GI Models\Razor Sword.bin")                                                                                                           # Model: Master Sword -> Razor Sword (from Fairy Slingshot)
    ChangeBytes -Offset "A080"    -Values "034850000348656003485000"; ChangeBytes -Offset "B6F690" -Values "0348500003486560"; ChangeBytes -Offset "B6649E" -Values "0C08"

    PatchBytes  -Offset "812000"  -Texture -Patch "Equipment\Kokiri Sword\Termina Kokiri Sword.icon"                                                                                    # Icon:  Broken Giant's Knife -> Termina Kokiri Sword
    PatchBytes  -Offset "8B4000"  -Texture -Patch "Equipment\Kokiri Sword\Knife.en.label"                                                                                               # Label: Broken Giant's Knife -> Knife

    PatchBytes  -Offset "7FA000"  -Texture -Patch "Equipment\Master Sword\Gilded Sword.icon"                                                                                            # Icon:  Biggoron Sword -> Gilded Sword
    PatchBytes  -Offset "8AE000"  -Texture -Patch "Equipment\Master Sword\Razor Longsword.en.label"                                                                                     # Label: Giant's Knife  -> Razor Longsword
    PatchBytes  -Offset "8BD400"  -Texture -Patch "Equipment\Master Sword\Gilded Sword.en.label"                                                                                        # Label: Biggoron Sword -> Gilded Sword
    PatchBytes  -Offset "347F000" -Patch ("Object GI Models\Gilded Sword.bin")                                                                                                          # Model: Giant's Knife  -> Gilded Sword (from Giant's Knife)
    ChangeBytes -Offset "A190"    -Values "0347F000034802A00347F000"; ChangeBytes -Offset "B6F718" -Values "0347F000034802A0"; ChangeBytes -Offset "B666DE" -Values "09E8"

    PatchBytes  -Offset "7FC000"  -Texture -Patch "Equipment\Hylian Shield\Hero's Shield.icon"                                                                                          # Icon:  Hylian Shield -> Hero's Shield
    PatchBytes  -Offset "8AE800"  -Texture -Patch "Equipment\Hylian Shield\Hero's Shield.en.label"                                                                                      # Label: Hylian Shield -> Hero's Shield
    PatchBytes  -Offset "15B9000" -Patch ("Object GI Models\Hero's Shield.bin");         ChangeBytes -Offset "9FF4" -Values "015BAEC0"; ChangeBytes -Offset "B6F63C" -Values "015BAEC0" # Model: Hylian Shield -> Hero's Shield
    ChangeBytes -Offset "B663A2"  -Values "09F0"
    
    PatchBytes  -Offset "7FD000"  -Texture -Patch "Equipment\Mirror Shield\Termina Mirror Shield.icon"                                                                                  # Icon:  Mirror Shield -> Termina Mirror Shield
    PatchBytes  -Offset "1616000" -Patch ("Object GI Models\Termina Mirror Shield.bin"); ChangeBytes -Offset "A0F4" -Values "01617C00"; ChangeBytes -Offset "B6F6CC" -Values "01617C00" # Model: Mirror Shield -> Termina Mirror Shield
    ChangeBytes -Offset "B6659A"  -Values "0770"; ChangeBytes -Offset "B6659E" -Values "0BF8"
    PatchBytes  -Offset "1456188" -Texture -Patch "Child Quest\mm_style_reflection.bin"                                                                                                 # Mirror Shield reflection
    
    PatchBytes  -Offset "3481000" -Patch ("Object GI Models\Hero's Bow.bin");
    ChangeBytes -Offset "A0A0"    -Values "03481000034822F003481000"; ChangeBytes -Offset "B6F6A0" -Values "03481000034822F0"; ChangeBytes -Offset "B664E6"  -Values "0C80"             # Model: Fairy Bow -> Hero's Bow



    # Hylian Shield edits
    ChangeBytes -Offset "C0D108" -Values "1100" # Hylian Shield can reflect Octorok projectiles
    ChangeBytes -Offset "EBB1F4" -Values "1100" # Hylian Shield can reflect Deku Scrub projectiles



    # Quiver
    ChangeBytes -Offset @("BB5E40", "BB60C8", "BB6288") -Values "1500"                                                                # Ignore Bullet Bag for Cursor Selection
    ChangeBytes -Offset "BB64E4" -Values "1500"                                                                                       # Show Quiver Text Label
    ChangeBytes -Offset "BC70F0" -Values "00";   ChangeBytes -Offset "BC70F8" -Values "4A"; ChangeBytes -Offset "BB6513" -Values "49" # Display Quiver in Equipment Subscreen
    ChangeBytes -Offset @("D35EC4", "D36114") -Values "1500"                                                                          # Quiver reward shooting gallery
    
    # Quiver reward lost woods
    ChangeBytes -Offset "E59376" -Values "00BE"; ChangeBytes -Offset "E59717" -Values "15"   # Loaded Object, Present Prize Model (Quiver 40) 
    ChangeBytes -Offset "E59C12" -Values "8C80"; ChangeBytes -Offset "E59C1E" -Values "8CC4" # Target Prize Approach -> Compare Swap    (Debug: 71C4 -> 71B0, 71F9 -> 71F4, Rev0: 8C94 -> ????, 8CC9 -> ????, -14, -05)
    ChangeBytes -Offset "E59C3B" -Values "30";   ChangeBytes -Offset "E59C3F" -Values "31"   # Target Prize Approach -> Reward Swap
    ChangeBytes -Offset "E59CB2" -Values "8C80"; ChangeBytes -Offset "E59CBE" -Values "8CC4" # Target Prize Give     -> Compare Swap    (Debug: 71C4 -> 71B0, 71F9 -> 71F4, Rev0: 8C94 -> ????, 8CC9 -> ????, -14, -05)
    ChangeBytes -Offset "E59CDB" -Values "31";   ChangeBytes -Offset "E59CDF" -Values "30"   # Target Prize Give     -> Reward Swap

    # Show Bow icon instead of Slingshot icon during Shooting Gallery minigame
    ChangeBytes -Offset "AE446C" -Values "1000"



    # Swap item slots
    ChangeBytes -Offset @("BC7126", "BC712E") -Values "FF" # Remove numbers from Slingshot and Bean slots
    ChangeBytes -Offset @("B6EE9A", "B6EEA4") -Values "FF" # Turn Fairy Slingshot and Magic Beans into slotless items

    ChangeBytes -Offset "B6EE9B" -Values "06" # Turn Fairy Ocarina into Fairy Slingshot (slot item)
    ChangeBytes -Offset "B6EE9F" -Values "0F" # Turn Longshot into Megaton Hammer (slot item)
    ChangeBytes -Offset "B6EEA5" -Values "0E" # Turn Megaton Hammer into Magic Bean (slot item)

    ChangeBytes -Offset "B71F92" -Values "07" # Give Fairy Ocarina instead of Fairy Slingshot on Debug save file
    ChangeBytes -Offset "B71F93" -Values "08" # Give Ocarina of Time instead of Fairy Ocarina on Debug save file
    ChangeBytes -Offset "B71F9A" -Values "11" # Give Megaton Hammer instead of Magic Beans on Debug save file
    ChangeBytes -Offset "B71F9B" -Values "0B" # Give Longshot instead of Megaton Hammer on Debug save file
    ChangeBytes -Offset "B71FA2" -Values "32" # Give Poacher's Saw instead of Pocket Egg on Debug save file
    
    ChangeBytes -Offset "B71F86" -Values "06" # Set Fairy Ocarina slot to C-Right on Debug save file
    ChangeBytes -Offset "B061C7" -Values "03" # Set Fairy Bow slot to C-Left on Debug save file as Child Link



    # Inventory Editor
    ChangeBytes -Offset   "BB3F20"            -Values "1400" # Draw item ID instead of Slingshot ammo
    ChangeBytes -Offset   "BB3F30"            -Values "1000" # Draw item ID instead of Magic Bean ammo
    ChangeBytes -Offset @("BB49B0", "BB4A70") -Values "1000" # Skip Ocarina and Hookshot slot checks
    ChangeBytes -Offset   "BB489C"            -Values "1400" # Skip Fairy Slinghshot slot check
    ChangeBytes -Offset   "BB48AC"            -Values "1000" # Skip Magic Bean slot check
    ChangeBytes -Offset   "BC70C1"            -Values "07"   # Fairy Ocarina instead of Slingshot
    ChangeBytes -Offset   "BC70C3"            -Values "08"   # Ocarina of Time only
    ChangeBytes -Offset   "BC70D1"            -Values "11"   # Megaton Hammer instead of Magic bean
    ChangeBytes -Offset   "BC70D3"            -Values "0B"   # Longshot instead of Megaton Hammer



    # Unlock items for Child Link
    ChangeBytes -Offset "BC77B6" -Values "0909";              ChangeBytes -Offset "BC77FE" -Values "0909"                                            # Unlock Tunics
    ChangeBytes -Offset "BC77BA" -Values "0909";              ChangeBytes -Offset "BC7801" -Values "0909"                                            # Unlock Boots
    ChangeBytes -Offset "BC77AE" -Values "0909" -Interval 74                                                                                         # Unlock Master Sword
    ChangeBytes -Offset "BC77AF" -Values "0909" -Interval 74; ChangeBytes -Offset "BC7811" -Values "09"                                              # Unlock Giant's Knife
    ChangeBytes -Offset "BC77B3" -Values "0909" -Interval 73                                                                                         # Unlock Mirror Shield
    ChangeBytes -Offset "AEFA6C" -Values "24080000";          ChangeBytes -Offset "BC780D" -Values "0909"; ChangeBytes -Offset "BC77B4" -Values "09" # Unlock Gauntlets
    ChangeBytes -Offset "BC77A3" -Values "0909" -Interval 42                                                                                         # Unlock Megaton Hammer
    ChangeBytes -Offset "BC779D" -Values "09";                ChangeBytes -Offset "BC77C6" -Values "0909"                                            # Unlock Hookshot
    ChangeBytes -Offset "BC77BF" -Values "09";                ChangeBytes -Offset "BC7797" -Values "09"                                              # Unlock Bow
    ChangeBytes -Offset "BC77C0" -Values "09";                ChangeBytes -Offset "BC7798" -Values "09"                                              # Unlock Fire Arrow
    ChangeBytes -Offset "BC77C8" -Values "09";                ChangeBytes -Offset "BC779E" -Values "09"                                              # Unlock Ice Arrow
    ChangeBytes -Offset "BC77CE" -Values "09";                ChangeBytes -Offset "BC77A4" -Values "09"                                              # Unlock Light Arrow
    ChangeBytes -Offset "BC7806" -Values "090909";            ChangeBytes -Offset "BC77AC" -Values "09"                                              # Unlock Quivers
    ChangeBytes -Offset @("BC77AA", "BC77EE", "BC77EF", "BC77F0", "BC77F1", "BC77F2", "BC77F3") -Values "09"                                         # Unlock several Adult Trade Sequence items and Adult Trade slot
    


    # Collision
    ChangeBytes -Offset @("CF4CDC", "CF4D00", "CF4D24", "CF4D48", "CF4D6C", "CF4D90", "CF4DB4", "CF4DD8", "CF4DFC", "CF4E07", "CF4E20", "CF4E44", "CF4E68") -Values (GetOoTCollision -Boomerang) -Add # Flare Dancer
    ChangeBytes -Offset "D8D4A0" -Values (GetOoTCollision -KokiriJump -KokiriSpin)                                                                                                               -Add # Ganondorf Lightball
    ChangeBytes -Offset "EA0814" -Values (GetOoTCollision -KokiriSpin -GiantSpin -MasterSpin -KokiriJump -GiantJump -MasterJump)                                                                 -Add # Gerudo Guard
    ChangeBytes -Offset "C91A08" -Values (GetOoTCollision -Arrow -ArrowFire -ArrowIce -ArrowLight)                                                                                               -Add # Falling Ladder (Inside the Deku Tree)
    ChangeBytes -Offset "C4930C" -Values (GetOoTCollision -Arrow -ArrowFire -ArrowIce -ArrowLight)                                                                                               -Add # Gohma (stun)



    # Set Collision check for Invisible Collectible (Bomb Soldier) from Bullet Seed to Arrow
    ChangeBytes -Offset "DE90DB" -Values "20"



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
  # ChangeBytes -Offset "E11BB4" -Values "1100"     # Remove Gerudo membership check
  # ChangeBytes -Offset "B71FB4" -Values "1111"     # Only Base Equipment on new Debug Save Slot
  # ChangeBytes -Offset "B71F56" -Values "01"       # Biggoron Sword on new Debug Save Slot
    ChangeBytes -Offset "B71FBB" -Values "C9"       # Golden Gauntlets on new Debug Save Slot
  # ChangeBytes -Offset "B06172" -Values "0008"     # Disable Light Arrows Cutscene flag, replacing with other cutscene
    ChangeBytes -Offset "B71FBC" -Values "01E3FFC0" # Remove medallions
  # ChangeBytes -Offset "B061A3" -Values "FF"; ChangeBytes -Offset @("B061B0", "B061DC") -Values "00002825" # Swordless & Shieldless



    # Other options
    CopyBytes   -Offset "96E068" -Length "D48" -Start "974600" # Fix incomplete Gerudo Fortress minimap
    ChangeBytes -Offset "A89598" -Values "1100"                # No more Deku Seed drops



    # Age Checks
    ChangeBytes -Offset "C7BAEC" -Values "13"                                                                                                         # Make Sheik appear for the Bolero of Fire as Child
    ChangeBytes -Offset "C00DD0" -Values "1500";     ChangeBytes -Offset "C00E78" -Values "1500"                                                      # Purchasable tunics as Child
    ChangeBytes -Offset "DE0214" -Values "1100"                                                                                                       # Make Ice Platforms appear as Child
    ChangeBytes -Offset "C7B9C0" -Values "00000000"; ChangeBytes -Offset "C7BAEC" -Values "00000000"; ChangeBytes -Offset "C7BCA4" -Values "00000000" # Tell Sheik at Ice Cavern we are always an Adult
    ChangeBytes -Offset "B65D56" -Values "01"                                                                                                         # Nabooru Iron Knuckle cutscene as Child
    ChangeBytes -Offset "B65D5E" -Values "02"                                                                                                         # Gerudo Fortress jail cutscene as Child
    ChangeBytes -Offset "B65D15" -Values "3A02"                                                                                                       # Fix Ganon's Castle intro
    ChangeBytes -Offset "F01C7C" -Values "1500"                                                                                                       # Fix Silver Blocks
    ChangeBytes -Offset "EB7FA8" -Values "1400"                                                                                                       # Fix Spirit Temple Stone Elevator
    ChangeBytes -Offset "ACCE48" -Values "15000000"                                                                                                   # Light Arrows cutscene as Child
    ChangeBytes -Offset "AC9914" -Values "00" -Repeat 0xB                                                                                             # Stay Child during the Light Arrows cutscene
  # ChangeBytes -Offset "EF5A48" -Values "1100"                                                                                                       # Allow Bonooru to activate the Scarecrow's Song as Child
    ChangeBytes -Offset "EF4F8C" -Values "1100"                                                                                                       # Allow Bonooru to activate the Scarecrow's Song as Child
  # ChangeBytes -Offset "AFCD2C" -Values "1400"                                                                                                       # Withered Deku Tree during Deku Sprout cutscenes (tree)
  # ChangeBytes -Offset "C7332C" -Values "1400"                                                                                                       # Withered Deku Tree during Deku Sprout cutscenes (jaw)
    ChangeBytes -Offset "D5A80C" -Values "1500"                                                                                                       # Prevent Deku Tree Sprout from disappearing after its cutscene
    ChangeBytes -Offset "A894B0" -Values "11000000"                                                                                                   # Turn Deku Seed drops into Small Arrow Bundles
    ChangeBytes -Offset "A89C64" -Values "1000"                                                                                                       # Flexible Item drop for Deku Seeds is skipped
    ChangeBytes -Offset "A89C9C" -Values "1400"                                                                                                       # Flexible Item drop for Medium Arrow Bundle is now always checked



    # Poe Collector
    ChangeBytes -Offset "EE69CE" -Values "0064" # Reduce requirements for the reward from 1.000 (0x03E8) to 100 (0x0064) points



    # Granny (Potion Shop) - Trade Prescription for Eyeball frog instead of Odd Mushroom for Odd Potion
    ChangeBytes -Offset "E2BABB" -Values "24"; ChangeBytes -Offset "E2BB3B" -Values "24"; ChangeBytes -Offset "E2BFE3" -Values "0C"
    ChangeBytes -Offset "E2C073" -Values "68"; ChangeBytes -Offset "E2C077" -Values "34"; ChangeBytes -Offset "E2C107" -Values "0C"



    # Fix trading sequence timer
    ChangeBytes -Offset "E2C5F2" -Values "012C" # Increase timer to 5 minutes (300 seconds)
    ChangeBytes -Offset "B6D465" -Values "35"   # Revert to Eyeball Frog on failure
    ChangeBytes -Offset "B6D584" -Values "0043" # Respawn at Lakeside Laboratory on failure



    # Big Poe as shop item
    ChangeBytes -Offset "C027F4" -Values "0190"                                                                                                                                                           # Higher Pricing for Big Poe
    ChangeBytes -Offset "C027FA" -Values "706B"                                                                                                                                                           # Change second text box for Big Poe
    ChangeBytes -Offset "C71FC0" -Values "0029"                                                                                                                                                           # Sell Big Poe instead of Poe at Market Potion Shop



    # Prevent Deku Seeds from being sold
    ChangeBytes -Offset "C71EF1" -Values "02" # Sell 50 arrows instead of Deku Seeds in Kokiri Shop
    ChangeBytes -Offset "DF75F3" -Values "06" # Make sure Deku Scrub in Lost Woods sells arrows



    # Gerudo Valley visible tent
    ChangeBytes -Offset "D215D3" -Values "128483"
    ChangeBytes -Offset "D215E1" -Values "41000724010003"
    ChangeBytes -Offset "D215EF" -Values "0410410005000000001000000F0000102503E000082C62000103E000080060102503E00008240200018483001C386200022C420001144000040000000038620003"



    # Chests
    ChangeBytes -Offset "C7BCF0" -Values "8CB91D38340800048CA21C4400000000000000000000000000000000" # Fix Serenade of Water
    ChangeBytes -Offset "DFEC3C" -Values "3C1880128F18AE8C27A500243319001000000000"                 # Fix Dampé Hookshot chest
    ChangeBytes -Offset "AE76FF" -Values "58"                                                       # Fix Deku Seeds in chests
    ChangeBytes -Offset "AE7780" -Values "1500"                                                     # Fix Magic Jars (small + large) in chests

    ChangeBytes -Offset "BEEEE2" -Values "6580070200B6" # Cojiro          -> Song of Storms
    ChangeBytes -Offset "BEEF48" -Values "5F80080300B6" # Odd Mushroom    -> Prelude of Light
    ChangeBytes -Offset "BEEF4E" -Values "5A80030400B6" # Odd Potion      -> Minuet of Forest
    ChangeBytes -Offset "BEEF12" -Values "6B804B48012E" # Magic Bean      -> Light Medallion
    ChangeBytes -Offset "BEEEAC" -Values "3C80333000E7" # Fairy Slingshot -> Master Sword

    ChangeBytes -Offset "BDA300" -Values "11000000" # Remove item possession check for playing long chest animation
    ChangeBytes -Offset "BEF040" -Values "F7"       # Set Recovery Hearts to short anim
    ChangeBytes -Offset "BEEF80" -Values "BD"       # Set Giant's Knife to short anim



    # Damage Tables
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
function ChildQuestProByteReduxOptions() {

    ChangeBytes -Offset $Symbols.CFG_ALLOW_MASTER_SWORD      -Values "01"
    ChangeBytes -Offset $Symbols.CFG_ALLOW_GIANTS_KNIFE      -Values "01"
    ChangeBytes -Offset $Symbols.CFG_ALLOW_MIRROR_SHIELD     -Values "01"
    ChangeBytes -Offset $Symbols.CFG_ALLOW_BOOTS             -Values "01"
    ChangeBytes -Offset $Symbols.CFG_ALLOW_TUNIC             -Values "01"
    ChangeBytes -Offset $Symbols.CFG_DEFAULT_CHILD_DPAD_DOWN -Values "06"

}



#==============================================================================================================================================================================================
function ChildQuestProByteSceneOptions() {
    
    # KAKARIKO VILLAGE #

    PrepareMap   -Scene "Kakariko Village" -Map 0 -Header 0 # Child - Day
    # Open Granny's Potion Shop
    ReplaceTransitionActor -Index 3 -Param "01BF"
    SaveLoadedMap

    PrepareMap   -Scene "Kakariko Village" -Map 0 -Header 1 # Child - Night
    # Open Granny's Potion Shop
    ReplaceTransitionActor -Index 3 -Param "01BF"
    # Gold Skulltula (Rooftop)
    InsertActor  -Name "Skullwalltula" -X (-18) -Y 540 -Z 1800 -Param "B140" -YRot 0x8000
    SaveAndPatchLoadedScene



    # GUARD'S HOUSE

    PrepareMap      -Scene "Guard's House" -Map 0 -Header 0
    # Turn Guard's House into Ghost Shop at night
    ChangeMapFile   -Offset "48" -Values "03000470"
    ChangeSceneFile -Offset "68" -Values "02000B60"
    SaveAndPatchLoadedScene



    # GRAVEYARD #

    PrepareMap   -Scene "Graveyard" -Map 0 -Header 0 # Child - Day
    # Place Poacher's Saw in a chest
    InsertObject -Name "Treasure Chest"
    InsertActor  -Name "Treasure Chest" -X 1875 -Y 100 -Z (-149) -Param "042F" -YRot 0xC000
    SaveLoadedMap

    PrepareMap   -Scene "Graveyard" -Map 0 -Header 1 # Child - Night
    # Place Poacher's Saw in a chest
    InsertObject -Name "Treasure Chest"
    InsertActor  -Name "Treasure Chest" -X 1875 -Y 100 -Z (-149) -Param "042F" -YRot 0xC000
    SaveLoadedMap

    PrepareMap   -Scene "Graveyard" -Map 1 -Header 0 # Child - Day
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
    # Remove Bean Salesman
    RemoveActor -Name "Bean Salesman" -Compare "FFFF"
    # Gold Skulltula (Wall, upper area)
    InsertActor -Name "Skullwalltula" -X 26   -Y 702  -Z 258     -Param "B210" -XRot 0x4000 -YRot 0x82D8
    SaveLoadedMap

    PrepareMap  -Scene "Zora's River" -Map 1 -Header 0 # Zora's Domain Entrance
    # Gold Skulltula (Wall, near waterfall)
    InsertActor -Name "Skullwalltula" -X 2832 -Y 1055 -Z (-1466) -Param "B208" -XRot 0x4000 -YRot 0x238E
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
    # Add Scarecrow as a shortcut
    InsertObject -Name "Pierre & Bonooru"
    InsertActor  -Name "Pierre the Scarecrow Spawn" -X (-318) -Y 120 -Z 1363 -Param "053F" -ZRot 0x0014
    # Gold Skulltula (Wall)
    InsertObject -Name "Skulltulas"
    InsertActor  -Name "Skullwalltula" -X 534 -Y 289 -Z 280 -Param "AE08" -XRot 0x4000 -YRot 0xC000
    # Fix Blue Warp
    InsertObject -Name "Warp Circle & Rupee Prism"
    InsertActor  -Name "Warp Portal" -X 10 -Y 500 -Z (-2610) -Param "0006"
    InsertSpawnPoint -X 10 -Y 500 -Z (-2610) -Param "0201"
    # Place Minuet of Forest in a chest
    InsertObject -Name "Treasure Chest"
    InsertActor  -Name "Treasure Chest" -X (-330) -Y 480 -Z (-3155) -Param "0401" -YRot 0x8000
    SaveAndPatchLoadedScene



    # LAKE HYLIA #

    PrepareMap   -Scene "Lake Hylia" -Map 0 -Header 0
    # Add rooftop Scarecrow
    InsertActor  -Name "Pierre the Scarecrow Spawn" -X (-2624) -Y (-753) -Z 3831 -Param "053D" -YRot 0x8000 -ZRot 0x0014
    # Gold Skulltula (Tree)
    InsertActor  -Name "Skullwalltula" -X (-732) -Y (-699) -Z 7445 -Param "B310" -YRot 0xA16C
    # Fire Arrows
    RemoveObject -Name "Zora" # Lake Hylia may crash with too many objects present
    InsertObject -Name "Magic Arrows"
    InsertActor  -Name "Sun Hitbox & Big Fairy" -X (-575) Y (-1233) -Z 7260 -Param "FF01" -YRot 0xC000
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
    # Golden Scale chest
    InsertObject -Name "Treasure Chest"
    InsertActor  -Name "Treasure Chest" -X 1015 -Y 906 -Z 1377 -Param "071F" -YRot 0x9C40
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
    # Golden Scale chest
    InsertObject -Name "Treasure Chest"
    InsertActor  -Name "Treasure Chest" -X 1015 -Y 906 -Z 1377 -Param "071F" -YRot 0x9C40
    SaveAndPatchLoadedScene



    # GERUDO VALLEY #

    PrepareMap   -Scene "Gerudo Valley" -Map 0 -Header 0
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

    PrepareMap    -Scene "Lost Woods" -Map 1 -Header 0 # Bullet Bag Minigame
    # Replace Bullet Bag with Quiver object
    ReplaceObject -Name "Bullet Bags" -New "Quivers"
    SaveLoadedMap

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
    # Adjust crate positions
    ReplaceActor -Name "Large Crate" -CompareZ (-1830) -Z (-1842)
    ReplaceActor -Name "Large Crate" -CompareZ (-1770) -Z (-1782)
    # Add missing crate containing 50 rupees
    InsertActor  -Name "Large Crate" -X 51 -Y 1113 -Z (-2997) -Param "FFFF" -XRot 0x14 -YRot 0x38E -ZRot 0x1F
    # Climbable wall for reaching the top of the fortress
    InsertObject -Name "Spirit Temple"
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
    # Biggoron
    InsertActor -Name "Goron" -X 820 -Y 3090 -Z (-3900) -YRot 0xA38E -Param "FFE2"
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
    # Add Sheik
    InsertObject -Name "Sheik"
    InsertActor  -Name "Sheik" -X (-340) -Y 460 -Z (-331) -Param "0007" -YRot 0xECCD
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
    # Place Razor Sword in a chest
    InsertObject -Name "Treasure Chest"
    InsertActor  -Name "Treasure Chest" -X (-650) -Y 71    -Z 0 -Param "00A0" -YRot 0xC000
    # Place Hookshot in a chest
    InsertActor  -Name "Treasure Chest" -X 650    -Y 3     -Z 0 -Param "0101" -YRot 0x4000
    SaveLoadedMap

    PrepareMap   -Scene "Temple of Time" -Map 1 -Header 0
    # Place Prelude of Light in a chest
    InsertObject -Name "Treasure Chest"
    InsertActor  -Name "Treasure Chest" -X (-390) -Y (-30) -Z 2021   -Param "03E2" -YRot 0xC000
    SaveAndPatchLoadedScene



    # CASTLE COURTYARD #

    PrepareMap   -Scene "Castle Courtyard" -Map 0 -Header 0
    # Allow arrows instead of Slingshot
	ReplaceActor -Name "Invisible Collectable" -Compare "1A81" -ZRot 0x0001
    SaveAndPatchLoadedScene



    # MARKET (CHILD - NIGHT) #

    PrepareMap -Scene "Market (Child - Night)" -Map 0 -Header 0
    # Change exit from Temple of Time Exterior Day 0 to Ganon's Castle Exterior 0
    ChangeExit -Index 2 -Exit "013A"
    SaveAndPatchLoadedScene



    # DAMPÉ'S GRAVE & WINDMILL #

    PrepareMap   -Scene "Dampé's Grave & Windmill" -Map 4 -Header 0 # Reward Room
    # Hookshot -> Song of Storms (Cojiro)
    ReplaceActor -Name "Treasure Chest" -Compare "1100" -Param "11C0"
    SaveLoadedMap

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



    # INSIDE THE DEKU TREE #

    if ($DungeonList["Inside the Deku Tree"] -eq "Vanilla") {
        PrepareMap  -Scene "Inside the Deku Tree" -Map 2 -Header 0 # Slingshot Room
        # Fairy Slingshot -> Fairy Bow
        ReplaceActor -Name "Treasure Chest" -Compare "00A1" -Param "0081"
        SaveAndPatchLoadedScene
    }

    elseif ($DungeonList["Inside the Deku Tree"] -eq "Master Quest" -or $DungeonList["Inside the Deku Tree"] -eq "Ura Quest") {
        PrepareMap  -Scene "Inside the Deku Tree" -Map 10 -Header 0 # Three Rising Pillars
        # Fairy Slingshot -> Fairy Bow
        ReplaceActor -Name "Treasure Chest" -Compare "10A6" -Param "1086"
        SaveAndPatchLoadedScene
    }



    # INSIDE JABU-JABU'S BELLY #

    if ($DungeonList["Inside Jabu-Jabu's Belly"] -eq "Master Quest") {
        PrepareMap   -Scene "Inside Jabu-Jabu's Belly" -Map 0 -Header 0 # Entrance
        # Cow switch accepting arrows
        ReplaceActor -Name "Invisible Collectable" -Compare "1915" -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "1918" -ZRot 0x0001
        SaveLoadedMap

        PrepareMap   -Scene "Inside Jabu-Jabu's Belly" -Map 1 -Header 0 # Main Hall
        # Cow switch accepting arrows
        ReplaceActor -Name "Invisible Collectable" -Compare "1904" -ZRot 0x0001
        SaveLoadedMap

        PrepareMap   -Scene "Inside Jabu-Jabu's Belly" -Map 2 -Header 0 # Ruto Meeting Room
        # Cow switch accepting arrows
        ReplaceActor -Name "Invisible Collectable" -Compare "1953" -ZRot 0x0001
        SaveLoadedMap

        PrepareMap   -Scene "Inside Jabu-Jabu's Belly" -Map 3 -Header 0 # Ruto Fallen Down Basement
        # Cow switch accepting arrows
        ReplaceActor -Name "Invisible Collectable" -Compare "1983" -CompareX (-289) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "1983" -CompareX (-282) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "1983" -CompareX (-302) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "1987" -CompareX (-361) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "1987" -CompareX (-352) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "1987" -CompareX (-364) -ZRot 0x0001
        SaveLoadedMap

        PrepareMap   -Scene "Inside Jabu-Jabu's Belly" -Map 4 -Header 0 # Room to Upper Main Hall
        # Cow switch accepting arrows
        ReplaceActor -Name "Invisible Collectable" -Compare "19BD" -ZRot 0x0001
        SaveLoadedMap

        PrepareMap   -Scene "Inside Jabu-Jabu's Belly" -Map 5 -Header 0 # Boos Door Room
        # Fix Like-Like not returning tunics
        InsertObject -Name "Tunics"
        # Cow switch accepting arrows
        ReplaceActor -Name "Invisible Collectable" -Compare "193E" -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "1968" -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "1AFD" -ZRot 0x0001
        SaveLoadedMap

        PrepareMap   -Scene "Inside Jabu-Jabu's Belly" -Map 6 -Header 0 # Giant Octo Mini-Boss
        # Cow switch accepting arrows
        ReplaceActor -Name "Invisible Collectable" -Compare "1920" -ZRot 0x0001
        SaveLoadedMap

        PrepareMap   -Scene "Inside Jabu-Jabu's Belly" -Map 11 -Header 0 # Right Fork Tentacle
        # Fix Like-Like not returning tunics
        InsertObject -Name "Tunics"
        # Cow switch accepting arrows
        ReplaceActor -Name "Invisible Collectable" -Compare "18E5" -CompareZ (-5646) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "18E5" -CompareZ (-5634) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "18E5" -CompareZ (-5659) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "19A7" -CompareZ (-5659) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "19A7" -CompareZ (-5652) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "19A7" -CompareZ (-5670) -ZRot 0x0001
        SaveLoadedMap

        PrepareMap   -Scene "Inside Jabu-Jabu's Belly" -Map 14 -Header 0 # Boomerang Hall
        # Fix Like-Like not returning tunics
        InsertObject -Name "Tunics"
        SaveAndPatchLoadedScene
    }

    elseif ($DungeonList["Inside Jabu-Jabu's Belly"] -eq "Ura Quest") {
        PrepareMap   -Scene "Inside Jabu-Jabu's Belly" -Map 0 -Header 0 # Entrance
        # Cow switch accepting arrows
        ReplaceActor -Name "Invisible Collectable" -Compare "193F" -CompareZ (-400) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "193F" -CompareZ (-994) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "193F" -CompareZ (-628) -ZRot 0x0001
        SaveLoadedMap

        PrepareMap   -Scene "Inside Jabu-Jabu's Belly" -Map 1 -Header 0 # Main Hall
        # Cow switch accepting arrows
        ReplaceActor -Name "Invisible Collectable" -Compare "193F" -CompareZ (-1807) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "193F" -CompareZ (-1798) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "193F" -CompareZ (-1505) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "193F" -CompareZ (-1856) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "190F" -CompareZ (-1710) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "190F" -CompareZ (-1685) -ZRot 0x0001
        SaveLoadedMap

        PrepareMap   -Scene "Inside Jabu-Jabu's Belly" -Map 2 -Header 0 # Ruto Meeting Room
        # Cow switch accepting arrows
        ReplaceActor -Name "Invisible Collectable" -Compare "193F" -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "1ABF" -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "1953" -ZRot 0x0001
        SaveLoadedMap

        PrepareMap   -Scene "Inside Jabu-Jabu's Belly" -Map 3 -Header 0 # Ruto Fallen Down Basement
        # Cow switch accepting arrows
        ReplaceActor -Name "Invisible Collectable" -Compare "19BF" -CompareZ (-3153) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "19BF" -CompareZ (-3530) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "1903" -ZRot 0x0001
        SaveLoadedMap

        PrepareMap   -Scene "Inside Jabu-Jabu's Belly" -Map 4 -Header 0 # Room to Upper Main Hall
        # Cow switch accepting arrows
        ReplaceActor -Name "Invisible Collectable" -Compare "193F" -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "1AFF" -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "1FFF" -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "19BD" -ZRot 0x0001
        SaveLoadedMap

        PrepareMap   -Scene "Inside Jabu-Jabu's Belly" -Map 5 -Header 0 # Boss Door Room
        # Cow switch accepting arrows
        ReplaceActor -Name "Invisible Collectable" -Compare "193F" -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "197F" -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "1AFD" -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "193E" -ZRot 0x0001
        SaveLoadedMap

        PrepareMap   -Scene "Inside Jabu-Jabu's Belly" -Map 11 -Header 0 # Right Fork Tentacle
        # Cow switch accepting arrows
        ReplaceActor -Name "Invisible Collectable" -Compare "1924" -CompareZ (-5647) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "1924" -CompareZ (-5674) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "1924" -CompareZ (-5682) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "18E5" -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "19A7" -ZRot 0x0001
        SaveLoadedMap

        PrepareMap   -Scene "Inside Jabu-Jabu's Belly" -Map 14 -Header 0 # Boomerang Hall
        # Cow switch accepting arrows
        ReplaceActor -Name "Invisible Collectable" -Compare "1ABF" -CompareZ (-2535) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "1ABF" -CompareZ (-2533) -ZRot 0x0001
        ReplaceActor -Name "Invisible Collectable" -Compare "1ABF" -CompareZ (-2253) -ZRot 0x0001
        SaveAndPatchLoadedScene
    }



    # FOREST TEMPLE #

    if ($DungeonList["Forest Temple"] -eq "Vanilla") {
        PrepareMap   -Scene "Forest Temple" -Map 2 -Header 0 # Elevator Hall
        # Invert time block
        ReplaceActor -Name "Time Block" -Compare "B819" -Param "3819"
        SaveLoadedMap

        PrepareMap   -Scene "Forest Temple" -Map 6 -Header 0 # Stalfos Mini-Boss Room
        # Fairy Bow -> Light Medallion (Magic Bean)
        ReplaceActor -Name "Treasure Chest" -Compare "B08C" -Param "B2CC"
        SaveLoadedMap

        PrepareMap   -Scene "Forest Temple" -Map 11 -Header 0 # Tall Block Pushing Hall
        # Reposition upper push block
        ReplaceActor -Name "Pushable Block" -Compare "0702" -X (-1787) -Z (-1140)
        # Prevent jumping down from upper to lower push block (possible softlock)
        InsertActor  -Name "Clear Block" -X (-2027) -Y 893 -Z (-1140) -Param "FF01" -ZRot 0xC000
        # Add clear blocks for climbing up top (0x05 and 0x07 push block switches)
        InsertObject -Name "Inside Ganon's Castle"
        InsertActor  -Name "Clear Block" -X (-1450) -Y 850  -Z (-1330) -Param "0701"
        InsertActor  -Name "Clear Block" -X (-1450) -Y 925  -Z (-1505) -Param "0501"
        InsertActor  -Name "Clear Block" -X (-1450) -Y 1000 -Z (-1330) -Param "0701"
        SaveAndPatchLoadedScene
    }

    elseif ($DungeonList["Forest Temple"] -eq "Master Quest" -or $DungeonList["Forest Temple"] -eq "Ura Quest") {
        PrepareMap   -Scene "Forest Temple" -Map 4 -Header 0 # North Elevator Hallway
        # Invert time block
        ReplaceActor -Name "Time Block"     -Compare "B820" -Param "3820"
        SaveLoadedMap

        PrepareMap   -Scene "Forest Temple" -Map 6 -Header 0 # Stalfos Mini-Boss Room
        # Invert time block
        ReplaceActor -Name "Time Block"     -Compare "B820" -Param "3820"
        # Fairy Bow -> Light Medallion (Magic Bean)
        ReplaceActor -Name "Treasure Chest" -Compare "B08C" -Param "B2CC"
        SaveLoadedMap

        PrepareMap   -Scene "Forest Temple" -Map 7 -Header 0 # East Courtyard
        # Remove time block near vines, as Child can't reach it
        RemoveActor  -Name "Time Block" -Compare "2822"
        # Invert remaining time blocks
        ReplaceActor -Name "Time Block" -Compare "A823" -Param "2823"
        ReplaceActor -Name "Time Block" -Compare "3924" -Param "B924"
        ReplaceActor -Name "Time Block" -Compare "B927" -Param "3927"
        ReplaceActor -Name "Time Block" -Compare "B928" -Param "3928"
        ReplaceActor -Name "Time Block" -Compare "2829" -Param "A829"
        SaveAndPatchLoadedScene
    }



    # FIRE TEMPLE #

    if ($DungeonList["Fire Temple"] -eq "Vanilla") {
        PrepareMap   -Scene "Fire Temple" -Map 1 -Header 0 -Shift # Lava Cavern
        # Reposition time block to access upper left room
        ReplaceActor -Name "Navi Block Info Spot" -Compare "3820" -CompareX 1560 -CompareY 100 -X 1639 -Y 70
        # Reach room to the right
        InsertActor  -Name "Torch" -X 1649 -Y 200 -Z 1419 -Param "1400"
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
        # Hookshot target for reaching the pots
        InsertActor  -Name "Stone Hookshot Target" -X (-1238) -Y 300    -Z (-725) -Param "FF00"
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 4 -Header 0 # Fire Slug Room
        # Reach Torch Slug places
        InsertActor  -Name "Torch" -X 2518 -Y 2260 -Z 698 -Param "1400"
        # Reach push block
        InsertObject -Name "Hookshot Pillar & Wall Target"
        InsertActor  -Name "Stone Hookshot Target" -X 2181 -Y 2321 -Z 274 -Param "FF02"
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
        # Replace temporary switch with a rusty one
        ReplaceActor -Name "Switch" -Compare "3D20" -Param "3D01"
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 16 -Header 0 # Flaming Wall of Death Room
        # Hookshot targets for reaching the upper Boulder Maze area and the Fire Wall Maze respectively
        InsertObject -Name "Hookshot Pillar & Wall Target"
        InsertActor  -Name "Stone Hookshot Target" -X 1446  -Y 3040 -Z (-549) -Param "FF02" -YRot 0xBF68
        InsertActor  -Name "Stone Hookshot Target" -X 354   -Y 3039 -Z 110    -Param "FF02" -YRot 0x4000
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 18 -Header 0 # Tile Room - Entrance
        # Fix Like-Like not giving the Deku Shield back
        InsertObject -Name "Deku Shield"
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 19 -Header 0 # Tile Room - Lava Cavern
        # Fix Like-Like not giving the Deku Shield back
        InsertObject -Name "Deku Shield"
        SaveAndPatchLoadedScene
    }

    elseif ($DungeonList["Fire Temple"] -eq "Master Quest" -or $DungeonList["Fire Temple"] -eq "Ura Quest") {
        PrepareMap   -Scene "Fire Temple" -Map 2 -Header 0 # Boss Door Hall
        # Remove unused objects and actors
        RemoveActor  -Name "Darunia" -Compare "FFFF" # Don't remove his object, or the boss door transition glitches out
        RemoveObject -Name "Time Block"
        RemoveObject -Name "Time Block Disappearance Effect"
        RemoveObject -Name "Skulltulas"
        RemoveObject -Name "Gold Skulltula Token"
        # Hookshot targets to get out near the entrance
        InsertActor  -Name "Stone Hookshot Target" -X (-882)  -Y (-50)  -Z 220    -Param "FF00"
        InsertActor  -Name "Stone Hookshot Target" -X (-735)  -Y 40     -Z 145    -Param "FF00" -YRot 0x2600
        # Hookshot target to prevent being stuck in the center
        InsertActor  -Name "Stone Hookshot Target" -X (-1060) -Y (-130) -Z (-40)  -Param "FF00"
        # Clear blocks for reaching the boss door (0x0E Stone Spike Platform switch)
        InsertObject -Name "Inside Ganon's Castle"
        InsertActor  -Name "Clear Block"           -X (-1208) -Y 200    -Z 0      -Param "0E01"
        InsertActor  -Name "Clear Block"           -X (-840)  -Y 200    -Z 0      -Param "0E01"
        # Hookshot target for reaching highest ground
        InsertActor  -Name "Stone Hookshot Target" -X (-1239) -Y 240    -Z (-659) -Param "FF00"
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 4 -Header 0 # Fire Slug Room
        # Reach upper area
        InsertActor  -Name "Torch" -X 2518 -Y 2260 -Z 698 -Param "1400"
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 10 -Header 0 # Invisible Fire Wall Maze
        # Prevent being stuck
        InsertActor  -Name "Stone Hookshot Target" -X (-1238) -Y 2660 -Z (-17) -Param "FF00"
        if ($DungeonList["Fire Temple"] -eq "Master Quest") {
            # Invert time blocks
            ReplaceActor -Name "Time Block"           -Compare "9837" -Param "1837"
            ReplaceActor -Name "Navi Block Info Spot" -Compare "1836" -Param "9836"
            ReplaceActor -Name "Navi Block Info Spot" -Compare "9836" -Param "1836"
        }
        # Add time block to be able to cross the fire walls from the other side
        InsertActor  -Name "Time Block" -X (-924) -Y 2800 -Z (-670) -Param "19FF" -YRot 0x2000
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 13 -Header 0 # West Tower
        # Extra hookshot target on the east side
        InsertActor  -Name "Stone Hookshot Target" -Param "3CC1" -X (-2488) -Y 4680  -Z 227
        # Extra hookshot target on the west side
        InsertActor  -Name "Stone Hookshot Target" -Param "3CC1" -X (-1800) -Y 4620  -Z 600
        # Remove Scarecrow
        RemoveObject -Name "Pierre & Bonooru"
        RemoveActor  -Name "Pierre the Scarecrow Spawn" -Compare "18FF"
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 14 -Header 0 # Hidden Stairs Room
        # Restore torches
        InsertActor  -Name "Torch" -X (-1970) -Y 4180 -Z (-808) -Param "2400" -YRot 0xE000
        InsertActor  -Name "Torch" -X (-1800) -Y 4180 -Z (-978) -Param "2400" -YRot 0xE000
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 16 -Header 0 # Flaming Wall of Death Room
        # Hookshot targets for reaching the upper Boulder Maze area and the Fire Wall Maze respectively
        InsertActor  -Name "Stone Hookshot Target" -X 1446  -Y 3040 -Z (-549) -Param "FF02" -YRot 0xBF68
        InsertActor  -Name "Stone Hookshot Target" -X 354   -Y 3039 -Z 110    -Param "FF02" -YRot 0x4000
        # Hookshot target for reaching crates
        InsertActor  -Name "Stone Hookshot Target" -X 1237  -Y 3019 -Z 149    -Param "FF02" -YRot 0xE09C
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 17 -Header 0 # Captured Goron North of Entrance
        # Fix Like-Like not dropping shields
        InsertObject -Name "Deku Shield"
        InsertObject -Name "Hylian Shield"
        SaveAndPatchLoadedScene
    }



    # WATER TEMPLE #

    PrepareMap   -Scene "Water Temple" -Map 0 -Header 0 # Central Hall
    # Remove Princess Ruto
    RemoveObject -Name "Adult Ruto"
    if ($DungeonList["Water Temple"] -eq "Master Quest" -or $DungeonList["Water Temple"] -eq "Ura Quest") {
        # Make it possible to jump over with a crate
        InsertActor -Name "Stone Hookshot Target" -X 360 -Y 439 -Z (-182) -Param "FF00" -ZRot 0x4000
    }
    SaveLoadedMap

    PrepareMap   -Scene "Water Temple" -Map 1 -Header 0 # Central Pillar
    # Be able to get out of the spikes
    InsertActor  -Name "Stone Hookshot Target" -X (-178) -Y 30 -Z (-320) -Param "FF00" -XRot 0x3E80 -YRot 0xBF68
    InsertActor  -Name "Stone Hookshot Target" -X (-181) -Y 30 -Z (-320) -Param "FF00" -XRot 0x3E80 -YRot 0x4047
    SaveLoadedMap

    PrepareMap   -Scene "Water Temple" -Map 2 -Header 0 # Flooded Basement
    # Prevent clipping through the metal gates
    if ($DungeonList["Water Temple"] -eq "Master Quest" -or $DungeonList["Water Temple"] -eq "Ura Quest") {
        ReplaceActor -Name "Metal Gate"     -Compare "1FF9" -Param "0FF9"
        ReplaceActor -Name "Metal Gate"     -Compare "1FFA" -Param "0FFA"
    }
    SaveLoadedMap

    PrepareMap   -Scene "Water Temple" -Map 6 -Header 0 # Dragon Statues Room
    if ($DungeonList["Water Temple"] -eq "Vanilla") {
        # Fix Like-Like not giving the Deku Shield back
        InsertObject -Name "Deku Shield"
    }
    elseif ($DungeonList["Water Temple"] -eq "Master Quest" -or $DungeonList["Water Temple"] -eq "Ura Quest") {
        # Lower water
        ReplaceActor -Name "Water Temple Plane" -CompareY 593 -Y 573
    }
    SaveLoadedMap

    if ($DungeonList["Water Temple"] -eq "Vanilla") {
        PrepareMap   -Scene "Water Temple" -Map 7 -Header 0 # Longshot Room
        # Invert time block
        ReplaceActor -Name "Time Block" -Compare "B80C" -Param "380C"
        SaveLoadedMap
    }

    PrepareMap   -Scene "Water Temple" -Map 12 -Header 0 # Rolling Boulder Room
    # Hookshot target to be able to get out of the upper water area
    InsertActor  -Name "Stone Hookshot Target" -X (-881) -Y 240 -Z (-2351) -Param "FF02" -XRot 0x4000
    SaveLoadedMap

    PrepareMap   -Scene "Water Temple" -Map 17 -Header 0 # Ruto Room
    # Remove Princess Ruto
    RemoveObject -Name "Adult Ruto"
    RemoveActor  -Name "Ruto (Adult)" -Compare "1004" # Switch: 0x10
    SaveAndPatchLoadedScene



    # SPIRIT TEMPLE #

    if ($DungeonList["Spirit Temple"] -eq "Master Quest" -or $DungeonList["Spirit Temple"] -eq "Ura Quest") {

        if ($DungeonList["Spirit Temple"] -eq "Ura Quest") {
            PrepareMap   -Scene "Spirit Temple" -Map 0 -Header 0 # Entrance
            # Remove Magic Beans
            RemoveActor  -Name "Bean Plant Spot" -Compare "010E" # Flag: 0x0E
            ReplaceActor -Name "Treasure Chest"  -Compare "82DF" -Param "807F" # Magic Beans -> Bombchus (10)
            # Reach upper Silver Rupee
            InsertActor  -Name "Stone Hookshot Target" -X (-212) -Y 292 -Z 634 -Param "FF02" -XRot 0x4000 -YRot 0x8000
            SaveLoadedMap
        }

        PrepareMap   -Scene "Spirit Temple" -Map 6 -Header 0 # Shortcut Room - Entrance
        # Move eye switch
        ReplaceActor -Name "Switch" -Compare "0A02" -X (-104) -Y 542 -Z (-61) -YRot 0x4000
        # Restore vanilla push block layout using flags: 0x09 and 0x0E
        RemoveActor  -Name "Pushable Block"         -Compare "09C3"
        RemoveActor  -Name "Pushable Block"         -Compare "09C7"
        RemoveActor  -Name "Pushable Block Trigger" -Compare "0009"
        RemoveActor  -Name "Silver Block (Child)"   -Compare "0009"
        RemoveActor  -Name "Pushable Block"         -Compare "3FC3"
        InsertActor  -Name "Pushable Block"         -X 340 -Y 413 -Z (-461) -Param "09C3"
        InsertActor  -Name "Pushable Block"         -X 540 -Y 413 -Z (-261) -Param "0EC3"
        InsertActor  -Name "Pushable Block"         -X 540 -Y 213 -Z (-461) -Param "09C7"
        InsertActor  -Name "Pushable Block"         -X 540 -Y 213 -Z (-61)  -Param "0EC7"
        InsertActor  -Name "Pushable Block Trigger" -X 540 -Y 213 -Z (-461) -Param "0009"
        InsertActor  -Name "Pushable Block Trigger" -X 540 -Y 213 -Z (-61)  -Param "000E"
        InsertActor  -Name "Silver Block (Child)"   -X 340 -Y 413 -Z (-461) -Param "0009"
        InsertActor  -Name "Silver Block (Child)"   -X 540 -Y 413 -Z (-261) -Param "000E"
        SaveLoadedMap
    }

    if ($DungeonList["Spirit Temple"] -eq "Vanilla") {
        PrepareMap   -Scene "Spirit Temple" -Map 12 -Header 0 # Sole Room - Rolling Boulder Room
        # Fix Like-Like not giving the Deku Shield back
        InsertObject -Name "Deku Shield"
        SaveLoadedMap
    }

    PrepareMap   -Scene "Spirit Temple" -Map 26 -Header 0 # Rotating Mirror Statues Room
    # Time block, so Child can activate the sun switch
    InsertObject -Name "Time Block"
    InsertObject -Name "Time Block Disappearance Effect"
    InsertActor  -Name "Time Block" -X (-560) -Y 1720 -Z (-900) -Param "39FF" -ZRot 0x0003
    SaveAndPatchLoadedScene



    # BOTTOM OF THE WELL #

    if ($DungeonList["Bottom of the Well"] -eq "Vanilla") {
        PrepareMap   -Scene "Bottom of the Well" -Map 1 -Header 0 # Bottom Pit
        # Add bomb flower and grass shrub to prevent softlocks when not having strength or explosives
        InsertActor  -Name "Bomb Flower" -X (-709) -Y (-720) -Z (-797) -Param "FFFF"
        InsertActor  -Name "Grass Shrub" -X 884    -Y (-720) -Z (-793) -Param "FF01"
        SaveAndPatchLoadedScene
    }



    # SHADOW TEMPLE #

    PrepareMap   -Scene "Shadow Temple" -Map 6 -Header 0 # Scythe Shortcut Room
    # Lower scythe trap
    ReplaceActor -Name "Spinning Scythe Trap" -CompareY (-543) -Y (-563)
    SaveLoadedMap

    PrepareMap   -Scene "Shadow Temple" -Map 10 -Header 0 # Falling Spike Blocks Trap Room
    # Hookshot target to get onto the push block
    InsertObject -Name "Hookshot Pillar & Wall Target"
    InsertActor  -Name "Stone Hookshot Target" -X 275 -Y (-1395) -Z 3735  -Param "FF00"
    SaveLoadedMap

    PrepareMap   -Scene "Shadow Temple" -Map 16 -Header 0 # Invisible Scythe Room
    # Invert time blocks, lower them and nearby collectables
    ReplaceActor -Name "Collectable"      -Compare "2003" -CompareY (-1028) -Y (-1058)
    ReplaceActor -Name "Collectable"      -Compare "2103" -CompareY (-1028) -Y (-1058)
    ReplaceActor -Name "Time Block"       -Compare "380A" -CompareY (-1143) -Y (-1173) -Param "B80A"
    if ($DungeonList["Shadow Temple"] -eq "Master Quest" -or $DungeonList["Shadow Temple"] -eq "Ura Quest") {
        ReplaceActor -Name "Time Block"   -Compare "3812" -CompareY (-1143) -Y (-1173) -Param "B812"
        ReplaceActor -Name "Silver Rupee" -Compare "1FC3" -CompareY (-1043) -Y (-1073)
    }
    # Lower scythe trap
    ReplaceActor -Name "Spinning Scythe Trap" -CompareY (-1143) -Y (-1183)
    SaveLoadedMap

    if ($DungeonList["Shadow Temple"] -eq "Vanilla") {
        PrepareMap   -Scene "Shadow Temple" -Map 21 -Header 0 # River of Death
        # Reach ladder
        InsertActor  -Name "Stone Hookshot Target" -X 4520 -Y (-1410) -Z (-1506) -Param "FF00"
        # Reposition Time Block to be able to backtrack
        ReplaceActor -Name "Time Block" -Compare "380C" -CompareX (-3065) -CompareY (-1363) -CompareZ (-642) -X (-2465) -Y (-1423) -Z (-804) -Param "B80C"
        SaveAndPatchLoadedScene
    }

    elseif ($DungeonList["Shadow Temple"] -eq "Master Quest" -or $DungeonList["Shadow Temple"] -eq "Ura Quest") {
        PrepareMap   -Scene "Shadow Temple" -Map 21 -Header 0 # River of Death
        # Reach ladder
        InsertActor  -Name "Stone Hookshot Target" -X 4520    -Y (-1410) -Z (-1506) -Param "FF00"
        # Insert Time Block to be able to backtrack
        InsertActor  -Name "Time Block"            -X (-2465) -Y (-1423) -Z (-804)  -Param "B8FF"
        SaveAndPatchLoadedScene
    }



    # ICE CAVERN #

    if ($DungeonList["Ice Cavern"] -eq "Vanilla") {
        PrepareMap   -Scene "Ice Cavern" -Map 3 -Header 0 # Second Open Room
        # Hookshot target and a clear block for climbing up
        InsertObject -Name "Inside Ganon's Castle"
        InsertObject -Name "Hookshot Pillar & Wall Target"
        InsertActor  -Name "Stone Hookshot Target" -X 600 -Y (-60) -Z (-570) -Param "FF00" -YRot 0x1000
        InsertActor  -Name "Clear Block"           -X 415 -Y 164   -Z (-570) -Param "FF01" -YRot 0x2000
        SaveAndPatchLoadedScene
    }

    elseif ($DungeonList["Ice Cavern"] -eq "Master Quest" -or $DungeonList["Ice Cavern"] -eq "Ura Quest") {
        PrepareMap   -Scene "Ice Cavern" -Map 3 -Header 0 # Second Open Room
        # Hookshot target for upper area
        InsertObject -Name "Hookshot Pillar & Wall Target"
        InsertActor  -Name "Stone Hookshot Target" -X 533 -Y 331 -Z (-687) -Param "FF02" -YRot 0xDEA8
        SaveLoadedMap

        PrepareMap   -Scene "Ice Cavern" -Map 5 -Header 0 # Ice Block Puzzle Room
        # Prevent getting stuck inside the clear blocks
        ReplaceActor -Name "Clear Block" -CompareX (-1465) -CompareY 50  -CompareZ (-250) -Y 0
        ReplaceActor -Name "Clear Block" -CompareX (-1364) -CompareY 50  -CompareZ (-250) -Y 0
        ReplaceActor -Name "Clear Block" -CompareX (-1394) -CompareY 100 -CompareZ (-250) -Y 50 -Z (-220) -XRot 0x4000
        InsertActor  -Name "Clear Block" -X (-1394) -Y 50 -Z (-200) -Param "2601" -XRot 0x4000
        SaveAndPatchLoadedScene
    }



    # GERUDO TRAINING GROUND #

    if ($DungeonList["Gerudo Training Ground"] -eq "Vanilla") {
        PrepareMap   -Scene "Gerudo Training Ground" -Map 6 -Header 0 # Lava Challenge
        # Invert time blocks
        ReplaceActor -Name "Time Block" -Compare "382C" -Param "B82C"
        ReplaceActor -Name "Time Block" -Compare "382D" -Param "B82D"
        SaveLoadedMap

        PrepareMap   -Scene "Gerudo Training Ground" -Map 10 -Header 0 # Preview Room
        # Fix Like-Like not giving the Deku Shield back
        InsertObject -Name "Deku Shield"
        SaveAndPatchLoadedScene
    }

    elseif ($DungeonList["Gerudo Training Ground"] -eq "Master Quest" -or $DungeonList["Gerudo Training Ground"] -eq "Ura Quest") {

        if ($DungeonList["Gerudo Training Ground"] -eq "Ura Quest") {
            PrepareMap   -Scene "Gerudo Training Ground" -Map 6 -Header 0 # Lava Challenge
            # Invert time block, increase YPos of the time block and the silver rupee for reaching the small key
            ReplaceActor -Name "Time Block"   -Compare "382D" -Param "B82D"  -CompareY (-293)                   -Y (-263)
            ReplaceActor -Name "Silver Rupee" -Compare "1FCC" -CompareX 1330 -CompareY (-185) -CompareZ (-1486) -Y (-155)
            SaveLoadedMap
        }

        PrepareMap   -Scene "Gerudo Training Ground" -Map 3 -Header 0 # Fake Room
        # Lower time block
        ReplaceActor -Name "Time Block" -Compare "38FF" -CompareY 159 -Y 129
        SaveAndPatchLoadedScene
    }



    # INSIDE GANON'S CASTLE #

    PrepareMap   -Scene "Inside Ganon's Castle" -Map 0 -Header 0 # Entrance
    # Fix exit
    ChangeExit   -Index 0 -Exit "023F"
    SaveLoadedMap

    PrepareMap   -Scene "Inside Ganon's Castle" -Map 3 -Header 0 # Water Trial #2
    # Reach rusted floor switch / upper silver rupee
    InsertObject -Name "Hookshot Pillar & Wall Target"
    InsertActor  -Name "Stone Hookshot Target" -X 2822 -Y (-380) -Z (-1175) -Param "FF00"
    InsertObject -Name "Spirit Temple"
    InsertActor  -Name "Metal Crating Bridge"  -X 2790 -Y (-165) -Z (-1319) -Param "00FF" -ZRot 0xBFEA
    # Reach door leading to the barrier
    InsertActor  -Name "Stone Hookshot Target" -X 3310 -Y (-380) -Z (-945)  -Param "FF00"
    # Prevent being stuck in the push block gap
    InsertActor  -Name "Stone Hookshot Target" -X 2829 -Y (-480) -Z (-743)  -Param "FF00"
    SaveLoadedMap

    PrepareMap   -Scene "Inside Ganon's Castle" -Map 6 -Header 0 # Forest Trial #2
    # Hookshot target near barrier door
    InsertActor  -Name "Stone Hookshot Target" -X 1742 -Y 110 -Z 2044 -Param "FF00" -YRot 0x1555
    if ($DungeonList["Inside Ganon's Castle"] -eq "Master Quest" -or $DungeonList["Inside Ganon's Castle"] -eq "Ura Quest") {
        # Hookshot target near entrance door (like vanilla)
        InsertActor  -Name "Stone Hookshot Target" -X 1169 -Y 262 -Z 1184 -Param "FF02" -YRot 0x1555
    }
    SaveLoadedMap

    if ($DungeonList["Inside Ganon's Castle"] -eq "Vanilla") {
        PrepareMap   -Scene "Inside Ganon's Castle" -Map 12 -Header 0 # Shadow Trial
        # Invert time blocks
        ReplaceActor -Name "Time Block" -Compare "3821" -Param "B821"
        ReplaceActor -Name "Time Block" -Compare "3822" -Param "B822"
        ReplaceActor -Name "Time Block" -Compare "3823" -Param "B823"
        # Fix Like-Like not giving the Deku Shield back
        InsertObject -Name "Deku Shield"
        SaveAndPatchLoadedScene
    }

    elseif ($DungeonList["Inside Ganon's Castle"] -eq "Master Quest" -or $DungeonList["Inside Ganon's Castle"] -eq "Ura Quest") {
        PrepareMap   -Scene "Inside Ganon's Castle" -Map 14 -Header 0 # Fire Trial
        # Lower topmost silver rupee
        ReplaceActor -Name "Silver Rupee" -Compare "1FC1" -CompareY 640 -Y 625
        SaveAndPatchLoadedScene
    }

}



#==============================================================================================================================================================================================
function ChildQuestProByteTextOptions() {
    
    # Items
    SetMessage -ID "0002" -Replace "<NS><DI>You obtained the <M>Song of Storms<W>!<DC><N>Its destructive power seems<N>overwhelming. Be mindful when<N>using it." # Cojiro -> Song of Storms
    SetMessage -ID "0003" -Replace "<NS><DI>You obtained the <C>Prelude of Light<W>!<DC><N>Return to the Temple of Time<N>swiftly, regardless of your<N>current location." # Odd Mushroom -> Prelude of Light
    SetMessage -ID "0004" -Replace "<NS><DI>You obtained the <G>Minuet of Forest<W>!<DC><N>The Sacred Forest Meadow and its<N>Temple are now always within<N>reach." # Odd Potion -> Minuet of Forest
    SetMessage -ID "000C" -Replace "<NS><Icon:3D><DI>You got the <R>Gilded Sword<W>!<DC><N>This blade was forged by a<N>master smith to deal<N>extra damage!" # Biggoron Sword -> Gilded Sword
    SetMessage -ID "0030" -Replace "<NS><Icon:3C><DI>You got the <G>Razor Sword<W>!<DC><N>This new, sharper blade is a cut<N>above the rest." # Fairy Slingshot -> Razor Sword
  # SetMessage -ID "0031" -ASCII -Text "Fairy Bow" -Replace "Hero's Bow"
    SetMessage -ID "0048" -Replace "<NS><Icon:6B>You received something useless,<N>very reminiscent of the<N><C>Light Medallion<W>!" # Magic Beans -> Light Medallion
    SetMessage -ID "004B" -Replace "<NS><Icon:3D><DI>You got the <R>Razor Longsword<W>!<DC><N>This legendary sword deals<N>massive damage to your foes!<N>Let's hope it won't break..." # Giant's Knife -> Razor Longsword
    SetMessage -ID "004D" -Replace "<Icon:3F><DI>You got a <C>Hero's Shield<W>!<DC><N>Switch to the <B>Equipment<N>Subscreen<W> and select this<N>shield, then equip it with <B><A Button><W>."
    SetMessage -ID "0050" -Replace "<Icon:42><DI>You got a <R>Goron Tunic<W>!<DC><N>This is a heat-resistant tunic.<N>Going to a hot place? No worry!"
    SetMessage -ID "0051" -Replace "<Icon:43><DI>You got a <B>Zora Tunic<W>!<DC><N>This is a diving suit. Wear it<N>and you won't drown underwater."
    SetMessage -ID "0057" -Text "<Icon:4B>" -Replace "<Icon:4C>" # Fix biggest quiver text box using the wrong icon
    SetMessage -ID "005B" -Replace "<NS><Icon:51><DI>You found the <B>Silver Gauntlets<W>!<DC><N>If you wore them, you would<N>feel power in your arms, the<N>power to lift big things with <B><A Button><W>!<New Box><NS><Icon:51>But, you promised to give them<N>to <R>Nabooru<W>. You should keep your<N>word..."
    SetMessage -ID "0092" -ASCII -Text "Hylian Shield" -Replace "Hero's Shield"
    SetMessage -ID "009C" -Replace "My current hot seller is the<N><C>Hero's Shield<W>, but it might be too<N>heavy for you, kid.<Event>"
    SetMessage -ID "00A9" -Replace "<DI><R>Hero's Shield   80 Rupees<N><W>This is the shield heroes use.<N>It can stand up to flame attacks!<DC><Shop Description>"
    SetMessage -ID "00AA" -Replace "<DI><R>Goron Tunic   200 Rupees<N><W>A tunic made by Gorons.<N>Protects you from heat damage.<DC><Shop Description>"
    SetMessage -ID "00AB" -Replace "<DI><R>Zora Tunic   300 Rupees<N><W>A tunic made by Zoras. Prevents<N>you from drowning underwater.<DC><Shop Description>"
    SetMessage -ID "506F" -Replace "<DI><R>Big Poe   400 Rupees<N><W>This is a bottled ghost spirit.<N>Sell it to someone who is crazy<N>about weird things like this.<DC><Shop Description>"
    SetMessage -ID "706B" -Replace "<DI>Big Poe   400 Rupees<DC><N><N><Two Choices><G>Buy<N>Don't buy<W>"



    # Graveyard
    SetMessage -ID "2028" -Append -Replace "<N>I'll find that <R>saw<W> the old man lost!" # Poacher's Saw hint



    # Zora's Domain
    SetMessage -ID "400A" -Append -Replace "<New Box>In honor of him a <R>golden artifact<W><N>has been created. It is said to<N>be hidden somewhere in<N>Zora's Fountain." # Golden Scale hint



    # Market
    SetMessage -ID "7014" -Append -Replace "<New Box>Ever since I saw that <R>ghost<W><N>in the Potion Shop...<N>A big and scary one!" # Big Poe hint



    # Guard House
    SetMessage -ID "7004" -Append -Replace "<New Box>At least I can do whatever I want<N>during <R>nighttime<W>..." # Guard - Ghost Shop hint
    SetMessage -ID "70F7" -Replace "<NS>Oh, you brought a Poe today!<New Box><NS>Hmmmm!<New Box><NS>Very interesting!<N>This is a <R>Big Poe<W>!<New Box><NS>I'll buy it for <R>50 Rupees<W>.<New Box>On top of that, I'll put <R>100<N>points <W>on your card." # Poe Collector #1
    SetMessage -ID "70F8" -Replace "<NS>Young man, you are a genuine<N><R>Ghost Hunter<W>!<New Box><NS>Is that what you expected me to<N>say? Heh heh heh!<New Box><NS>Because of you, I have extra<N>inventory of <R>Big Poes<W>.<New Box><NS>You're thinking about what I<N>would give you as a reward.<N>Heh heh.<New Box><NS>Don't worry, I didn't forget.<N>Just take this." # Poe Collector #2



    # Fire Temple
    SetMessage -ID "01A5" -Replace "<NS><C>You can see down from here...<N>Isn't that the room where we saw<N>the <W>boss door<C>?<W>"



    # Dampé chest reward
    SetMessage -ID "502D" -Replace "<NS>Hehehe, young man...<N>You were very quick to be able<N>to keep up with me! Hehehe!<N><New Box><NS>As a reward, I'm going to give<N>you my treasure.<N><New Box><NS>I'm sure it will help you!<N><New Box><NS>I live here now, so come back<N>again sometime. I'll give you<N>something cool!<N><New Box><NS>One more thing! Be careful on<N>your way back!<N>Heheheh...."



    # Medallions
    SetMessage -ID "4046" -ASCII -Text "my eternal love to you" -Replace "you my eternal respect" # Water
    SetMessage -ID "6036" -Replace "<NS>I should have kept the promise<N>I made back then...<Fade:5A>" # Spirit
    SetMessage -ID "5024" -Replace "<NS><Player>, the hero!<New Box><NS>Finally, all of us, the <R>six Sages<W>,<N>have been awakened!<N>The time for the final showdown<N>with the King of Evil has come!<New Box><NS>During the night at the market,<N>head to the <C>Temple of Time<W> to<N>find Ganon's Castle." # Rauru - All Medallions



    # Bonooru the Scarecrow
  # SetMessage -ID "40A5" -Replace "Well...not bad!<N>I will remember it for you<N>anyway!<New Box>Make sure to play it again to me!<Event>"



    # Time related dialog
    SetMessage -ID "1063" -Replace "<NS>Hey, have you seen your old<N>friends? None of them grew<N>a tiny bit since you first left,<N>did they?<New Box><NS>That's because the <G>Kokiri<W> never<N>grow up! Even after many years,<N>they're still going to be kids!" # Deku Tree Sprout
    SetMessage -ID "5025" -Replace "<NS>We Sheikah have served the<N>royalty of Hyrule from generation<N>to generation as attendants.<N>However...<New Box><NS>On that day Ganondorf<N>suddenly attacked...and<N>Hyrule Castle surrendered<N>after a short time.<New Box><NS>Ganondorf's target was one of<N>the keys to the Sacred Realm...the<N>hidden treasure of the Royal<N>Family...The Ocarina of Time!<New Box><NS>My duty bound me to take Zelda<N>out of Ganondorf's reach.<New Box><NS>When last I saw you, as we made<N>our escape from the castle, you<N>were just a lad...<New Box><NS>Now I see that you have become<N> a fine hero..." # Impa
    SetMessage -ID "600C" -Replace "<NS>Past, present, future...<New Box><NS>The Master Sword is a ship with<N>which you can sail upstream and<N>downstream through time's river...<New Box><NS>The port for that ship is in the<N>Temple of Time...<New Box><NS>Listen to this <Y>Requiem of Spirit<W>...<N>This melody will lead a child back<N>to the desert." # Sheik
    SetMessage -ID "6035" -Replace "<NS>Kid, let me thank you.<N><NS>Heheheh...look what the little<N>kid has become--a competent<N>swordsman!" # Nabooru
    SetMessage -ID "6079" -Replace "<NS>Hey, what's up, <Player>?<N>Surprised to see me?<New Box><NS>A long time in this world is<N>almost nothing to you, is it?<N>How mysterious!<New Box><NS>Even I thought that the tales of a<N>boy who could defeat the evil<N>was merely a legend.<New Box><NS><Player>, you have fully<N>matured as an adult.<Jump:607A>" # Kaepora Gaebora
    SetMessage -ID "70C9" -Replace "<NS>The two Triforce parts that I<N>could not capture on that day...<New Box><NS>I didn't expect they would be<N>hidden within you two!" # Ganondorf
    


    # Hylian Shield
    SetMessage -ID "7013" -Replace "If you plan on scaling Death<N>Mountain, buy a <C>Hero's Shield<W>.<N>You can defend yourself against<N>falling rocks with that shield."
    SetMessage -ID "7121" -ASCII -Text "Hylian Shields" -Replace "Hero's Shields"



    # Adult Trading Sequence
    SetMessage -ID "0005" -Replace "<NS><Icon:32><DI>You got the <R>Poacher's Saw<W>!<DC><N>Maybe this is useful to the<N>Master Craftsman?" # Poacher's Saw

    SetMessage -ID "3054" -Replace "<NS>That broken knife is surely my<N>worrrrrrrrrrk...<N><NS>I really want to repairrrrr it, but...<New Box><NS>But because of yesterrrrrday's<N>errrrruption, my eyes are<N>irrrrrrrritated...<New Box><NS>There are fine eyedrops in Kakariko<N>Village... You will find them if you<N>go to see the <R>Grrrrrranny<W>...<Jump:3055>" # Biggoron #1
    SetMessage -ID "0009" -Replace "<NS><Icon:34><DI>You checked in the Broken<N>Goron's Sword and received a<N><R>Prescription<W>!<DC><N>Go to Granny's Potion Shop!" # Prescription

    SetMessage -ID "504A" -Replace "I knew it!<N><Wait:01>.....<Wait:00>Interesting!<Jump:504B>" # Granny #1
    SetMessage -ID "504D" -Replace "<NS>Deliver this to that weirdo<N>at Lake Hylia...<Event>" # Granny #2
    SetMessage -ID "000D" -Replace "<NS><Icon:35><DI>You used the Prescription and<N>received an <R>Eyeball Frog<W>!<DC><N>Deliver it to the scientist<N>at Lake Hylia!" # Eyeball Frog
    SetMessage -ID "504F" -Replace "That reminds me...<N>I got something dope...<N>Wanna check out my new potion?" # Granny #3

    SetMessage -ID "4019" -Replace "<DI>Oh, wow!<DC><New Box><NS>I haven't seen an <R>Eyeball Frog<W><N>like this since forever!<Event>" # Lakeside Scientist #1
    SetMessage -ID "4000" -Replace "<NS>These eyeballs are so delicious!<N>Tonight I will cook fried eyeballs<N>for the first time in a long time!<N>Uhoy hoy hoo houy hoy!<New Box><NS>Such great stuff! Please say<N>thank you the old lady!<N>Eh? What?<Event>" # Lakeside Scientist #2

    SetMessage -ID "3058" -Replace "I've been waiting forrrrr you,<N>with tearrrrrrs in my eyes...<N>Please say hello to the old lady!" # Biggoron #2

}
