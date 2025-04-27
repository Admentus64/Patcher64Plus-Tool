
function ChildQuestExposeOptions() {
    
    # Exclude Group
    ExcludeGroup  -Group "Unlock"       -Name "Remove Child Restrictions"
    ExcludeGroup  -Group "Equipment"    -Name "Swords & Shields"
    ExcludeGroup  -Group "Previews"     -Name "Equipment Previews"



    # Expose Options
    ExposeOption  -Group "Fixes"        -Option "PoacherSaw"
    ExposeOption  -Group "Graphics"     -Option "EnhancedModel"
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
    ExposeOption  -Group "Text"         -Option "Restore"



    # Exclude Options
    ExcludeOption -Group "Gameplay"     -Option "Medallions"
    ExcludeOption -Group "Gameplay"     -Option "ChildShops"
    ExcludeOption -Group "Fixes"        -Option "RemoveFishingPiracy"
    ExcludeOption -Group "Fixes"        -Option "GerudoTentFortress"
    ExcludeOption -Group "Fixes"        -Option "Dungeons"
    ExcludeOption -Group "Graphics"     -Option "ForceHiresModel"
    ExcludeOption -Group "Styles"       -Option "HairColor"
    ExcludeOption -Group "Hero"         -Option "LostWoodsOctorok"
    ExcludeOption -Group "Minigames"    -Option "LessDemandingFishing"
    ExcludeOption -Group "Minigames"    -Option "GuaranteedFishing"
    ExcludeOption -Group "Equipment"    -Option "HideSword"
    ExcludeOption -Group "Equipment"    -Option "HideShield"
    ExcludeOption -Group "Equipment"    -Option "FunctionalWeapons"
    ExcludeOption -Group "Equipment"    -Option "PowerBracelet"
    ExcludeOption -Group "Misc"         -Option "SkipCutscenes"



    # Force Options
    ForceOption   -Group "Sounds"       -Option "ChildVoices" -Values "Majora's Mask"
    ForceOption   -Group "Equipment"    -Option "HerosBow"
    ForceOption   -Group "Equipment"    -Option "Hookshot"



    # Default Option Values
    DefaultOptionValue -Group "Hitbox"  -Option "MasterSword" -Value 3500
    DefaultOptionValue -Group "Hitbox"  -Option "GiantsKnife" -Value 4000

}



#==============================================================================================================================================================================================
function ChildQuestPatchOptions() {
    
    ApplyPatch -Patch "Decompressed\Optional\Child Quest\baserom.bps"
    if (IsChecked $Redux.Graphics.EnhancedModel) { ApplyPatch -Patch "Decompressed\Optional\Child Quest\model_mm.bps" } else { ApplyPatch -Patch "Decompressed\Optional\Child Quest\model_oot.bps" }
    ApplyPatch -Patch "Decompressed\Optional\Child Quest\shooting_gallery.bps"
    ApplyPatch -Patch "Decompressed\Optional\Child Quest\headers.bps"

}



#==============================================================================================================================================================================================
function ChildQuestByteOptions() {
    
    # Patch dungeons to MQ/Ura in advance
    PatchDungeonsOoTMQ



    # Title Screen Logo
    PatchBytes  -Offset "1795300" -Texture -Patch "Child Quest\logo.bin"
    ChangeBytes -Offset "E6E2A6"  -Values "6432358C64" # Overlay Title color
    ChangeBytes -Offset "E6DE2E"  -Values "96"         # Title Flames color



    # 4 MB -> 5 MB when Expansion Pak is plugged in
 # ChangeBytes -Offset @("4A97", "B1A293", "B1A29F", "B1A2B3") -Values "50"; ChangeBytes -Offset @("4ABB", "4ADF", "4B07", "4B2F", "4B5F") -Values "0D"; ChangeBytes -Offset @("4AC6", "4AFE", "4B0E", "4B3A", "4B72") -Values "CCC8"
    


    # Sound
    if ($Patches.Options.Checked -and (IsChecked $Redux.Restore.FireTemple)) {
        $global:QueuedSoundData = {
            CopyBytes  -Offset "3F122"  -Length "40" -Start "3F162"               # Use Child sound IDs for Adult voice
            PatchBytes -Offset "19D920" -Patch  "Child Quest\hookshot_sfx_01.bin" # Replace Adult hookshot sound
            PatchBytes -Offset "19F190" -Patch  "Child Quest\hookshot_sfx_02.bin" # Replace Adult hookshot sound
        }
    }
    else {
        $global:QueuedSoundData = $null
        CopyBytes  -Offset "2FDD2"  -Length "3F" -Start "2FE12"               # Use Child sound IDs for Adult voice
        PatchBytes -Offset "18E1E0" -Patch  "Child Quest\hookshot_sfx_01.bin" # Replace Adult hookshot sound
        PatchBytes -Offset "18FA50" -Patch  "Child Quest\hookshot_sfx_02.bin" # Replace Adult hookshot sound
    }
    


    # Equipment
    PatchBytes  -Offset "7F9000"  -Texture -Patch "Equipment\Kokiri Sword\Razor Sword.icon"                                                                                                               # Icon:  Master Sword -> Razor Sword
    PatchBytes  -Offset "8ADC00"  -Texture -Patch "Equipment\Kokiri Sword\Razor Sword.en.label"                                                                                                           # Label: Master Sword -> Razor Sword

    PatchBytes  -Offset "812000"  -Texture -Patch "Equipment\Master Sword\Silver Sword.icon"                                                                                                              # Icon:  Broken Giant's Knife -> Silver Sword
    PatchBytes  -Offset "8B4000"  -Texture -Patch "Equipment\Kokiri Sword\Knife.en.label"                                                                                                                 # Label: Broken Giant's Knife -> Knife

    PatchBytes  -Offset "7FA000"  -Texture -Patch "Equipment\Master Sword\Gilded Sword.icon"                                                                                                              # Icon:  Biggoron Sword -> Gilded Sword
    PatchBytes  -Offset "8AE000"  -Texture -Patch "Equipment\Master Sword\Silver Sword.en.label"                                                                                                          # Label: Giant's Knife  -> Silver Sword
    PatchBytes  -Offset "8BD400"  -Texture -Patch "Equipment\Master Sword\Gilded Sword.en.label"                                                                                                          # Label: Biggoron Sword -> Gilded Sword
    
    PatchBytes  -Offset "3471000" -Patch  "Object GI Models\Gilded Sword.bin"                                                                                                                             # Model: Giant's Knife  -> Gilded Sword (from Giant's Knife, unused space to avoid compressed crashing)
    ChangeBytes -Offset "A190"    -Values "034710000347280003471000";                   ChangeBytes -Offset   "B6F718"            -Values "0347100003472800"; ChangeBytes -Offset "B666DE" -Values "09E0"
    ChangeBytes -Offset "B666B6"  -Values "7DEC06000F50"                                                                                                                                                  # Draw Grass GI Model to Giant's Knife (Silver Sword) GI Model
    ChangeBytes -Offset "BEEF80"  -Values "42"                                                                                                                                                            # Use Grass GI Model instead of Biggoron Sword GI model for Giant's Knife (Silver Sword) Get Item

    PatchBytes  -Offset "7FC000"  -Texture -Patch "Equipment\Hylian Shield\Hero's Shield.icon"                                                                                                            # Icon:  Hylian Shield -> Hero's Shield
    PatchBytes  -Offset "8AE800"  -Texture -Patch "Equipment\Hylian Shield\Hero's Shield.en.label"                                                                                                        # Label: Hylian Shield -> Hero's Shield
    PatchBytes  -Offset "15B9000" -Patch  "Object GI Models\Hero's Shield.bin";         ChangeBytes -Offset @("9FF4",   "B6F63C") -Values "015BAEC0"                                                      # Model: Hylian Shield -> Hero's Shield
    ChangeBytes -Offset "B663A2"  -Values "09F0"
    
    PatchBytes  -Offset "7FD000"  -Texture -Patch "Equipment\Mirror Shield\Termina Mirror Shield.icon"                                                                                                    # Icon:  Mirror Shield -> Termina Mirror Shield
    PatchBytes  -Offset "1616000" -Patch  "Object GI Models\Termina Mirror Shield.bin"; ChangeBytes -Offset @("A0F4",   "B6F6CC") -Values "01617C00"                                                      # Model: Mirror Shield -> Termina Mirror Shield
    ChangeBytes -Offset "B6659A"  -Values "0770";                                       ChangeBytes -Offset   "B6659E"            -Values "0BF8"
    PatchBytes  -Offset "1456188" -Texture -Patch "Child Quest\mm_style_reflection.bin"                                                                                                                   # Mirror Shield reflection
    
    PatchBytes  -Offset "3473000" -Patch  "Object GI Models\Hero's Bow.bin"                                                                                                                               # Model: Fairy Bow -> Hero's Bow (oA8)
    ChangeBytes -Offset "A0A0"    -Values "03473000034742F003473000";                   ChangeBytes -Offset   "B6F6A0"            -Values "03473000034742F0"; ChangeBytes -Offset "B664E6" -Values "0C80"
    
    PatchBytes  -Offset "15BB000" -Patch "Object GI Models\Termina Hookshot.bin"                                                                                                                          # Model: Hookshot -> Termina Hookshot
    ChangeBytes -Offset @("A006", "B6F646") -Values "C880";                             ChangeBytes -Offset   "B663C6"            -Values "0A10";             ChangeBytes -Offset "B663EA" -Values "0E48"

    PatchBytes  -Offset "80E000"  -Texture -Patch "Equipment\Bracelet\Power Bracelet.icon"                                                                                                                # Icon:  Silver Gauntlets -> Power Bracelet
    PatchBytes  -Offset "8B3000"  -Texture -Patch "Equipment\Bracelet\Power Bracelet.en.label"                                                                                                            # Icon:  Silver Gauntlets -> Power Bracelet
    PatchBytes  -Offset "80F000"  -Texture -Patch "Equipment\Bracelet\Power Bracelets.icon"                                                                                                               # Icon:  Golden Gauntlets -> Power Bracelets
    PatchBytes  -Offset "8B3400"  -Texture -Patch "Equipment\Bracelet\Power Bracelets.en.label"                                                                                                           # Icon:  Golden Gauntlets -> Power Bracelets
    PatchBytes  -Offset "173A000"          -Patch "Object GI Models\Power Bracelet.bin" -Length "1960"                                                                                                    # Model: Gauntlets        -> Power Bracelet
    ChangeBytes -Offset @("A4B4", "B6F8C4") -Values "0173ABF0";                         ChangeBytes -Offset @("B667B2", "B667D6") -Values "8228060009600000000000000000000000"



    # Equipment
    ChangeBytes -Offset   "BDE64E"            -Values "0000" # Giant's Knife will no longer break
    ChangeBytes -Offset   "BB6880"            -Values "1100" # Equip broken icon from Equipment Subscreen if it's not the Biggoron Sword
    ChangeBytes -Offset   "BB6E2B"            -Values "00"   # Show broken icon in Equipment Subscreen if it's not the Biggoron Sword
    ChangeBytes -Offset   "B71E93"            -Values "08"   # Set default Giant's Knife health on new save slot
    ChangeBytes -Offset @("C0D108", "EBB1F4") -Values "1100" # Hylian Shield can reflect Octorok & Deku Scrubprojectiles
    ChangeBytes -Offset   "AF009B"            -Values "01"   # Show bracelets from power level 1 and higher



    # Medigoron sells the Giant's Knife after Fire Temple and pulling the Master Sword
    ChangeBytes -Offset "E1F734" -Values "94620EDC304E002015C00003304F020003E000080000102515E000033C04801003E000082402000224848BF08C9800089462009C0302C82413200006000000008C88000C24030003010248241120000300000000100000012403000100601025"                   
    ChangeBytes -Offset "E1FC17" -Values "0A8FA400282401000110410010240100021041002B240100031041000800000000100000288FBF00143C0280122442A5D0944F0F0E35F80001A4580F0E3C1980AA2739FE981000001EAC99025C3C0280122442A5D094480F0E3C0A80AA254AFF3035090002A4490F0E"
    ChangeBytes -Offset "E20367" -Values "B4"; ChangeBytes -Offset "E2036B" -Values "B8"; ChangeBytes -Offset "E2036F" -Values "D0"; ChangeBytes -Offset "E20373" -Values "D4"; 



    # Quiver
    PatchBytes  -Offset   "D35E9D"            -Patch  "Child Quest\Partial\shooting_gallery_rewards.bin"      # Shooting Gallery Rewards depending on Market or Kakariko
    PatchBytes  -Offset   "D34CC7"            -Patch  "Child Quest\Partial\shooting_gallery_game.bin"         # Randomize the order of the Rupees for the Kakariko Shooting Gallery (Hero's Bow)
    ChangeBytes -Offset @("BB6BFC", "BB64E4") -Values "1000"
    ChangeBytes -Offset   "DF3217"            -Values "1E";       ChangeBytes -Offset "DF321B" -Values "50"   # Increase collision hitboxes for Horseback Archery Pots
    ChangeBytes -Offset   "DF46D4"            -Values "3F0CCCCD"; ChangeBytes -Offset "DF31B6" -Values "3E80" # Resize Horseback Archery Pots (0.55f, 0.3125f)



    # Collision
    ChangeOoTCollision -Offset @("CF4CDC", "CF4D00", "CF4D24", "CF4D48", "CF4D6C", "CF4D90", "CF4DB4", "CF4DD8", "CF4DFC", "CF4E07", "CF4E20", "CF4E44", "CF4E68") -Boomerang             # Flare Dancer
    ChangeOoTCollision -Offset   "D8D4A0"                                                                                                                          -SpinAttack -JumpSlash # Ganondorf Lightball
    ChangeOoTCollision -Offset   "EA0814"                                                                                                                          -SpinAttack -JumpSlash # Gerudo Guard
    ChangeOoTCollision -Offset   "C91A08"                                                                                                                          -Arrow                 # Falling Ladder (Inside the Deku Tree)
    ChangeOoTCollision -Offset   "C4930C"                                                                                                                          -Arrow                 # Gohma (stun)
    ChangeOoTCollision -Offset   "DE9734"                                                                                                                          -Arrow                 # Invisible Collectible for Slingshot switch interaction



    # Death Mountain Trail falling rocks
    ChangeBytes -Offset "D1C8C4" -Values "1100" # Despawn after beating Volvagia
    ChangeBytes -Offset "D1CF10" -Values "1500" # Use Adult behavior



    # Credits
    ChangeBytes -Offset "ACAAEC" -Values "00" -Repeat 0xB # Zelda cutscene as Child
    ChangeBytes -Offset "ACA00C" -Values "35F93000"       # Fix Tunic during final scenes
    ChangeBytes -Offset "ACA02C" -Values "39092000"       # Fix Boots during final scenes
    


    # Scenes and Maps
    PatchBytes  -Offset "28E3000" -Patch "Child Quest\Maps\bazaar_scene.zscene"               # Separate header for second Bazaar in Kakariko
    PatchBytes  -Offset "28E4000" -Patch "Child Quest\Maps\bazaar_room_0.zmap"
    ChangeBytes -Offset @("C2F6", "B717B6") -Values "33A0"; ChangeBytes -Offset "C306" -Values "D840"

    PatchBytes  -Offset "2271000" -Patch "Child Quest\Maps\goron_city_scene.zscene"           # Second Adult Header for Goron City after Fire Temple
    PatchBytes  -Offset "227C000" -Patch "Child Quest\Maps\goron_city_room_0.zmap"
    PatchBytes  -Offset "228F000" -Patch "Child Quest\Maps\goron_city_room_1.zmap"
    PatchBytes  -Offset "2296000" -Patch "Child Quest\Maps\goron_city_room_2.zmap"
    PatchBytes  -Offset "22A8000" -Patch "Child Quest\Maps\goron_city_room_3.zmap"
    ChangeBytes -Offset @("B776", "B71BEE") -Values "B5D0"; ChangeBytes -Offset "B786"   -Values "EB40"; ChangeBytes -Offset "B796"   -Values "52C0"; ChangeBytes -Offset "B7A6"   -Values "7A60"; ChangeBytes -Offset "B7B6" -Values "5FB0"
    ChangeBytes -Offset   "B65C92"          -Values "8580"; ChangeBytes -Offset "B71DDE" -Values "9988"; ChangeBytes -Offset "B71DE2" -Values "9148"; ChangeBytes -Offset "CF143A" -Values "7F60"

    PatchBytes  -Offset "20F2000" -Patch "Child Quest\Maps\zoras_domain_scene.zscene"         # Second Adult Header for Zora's Domain after Water Temple
    PatchBytes  -Offset "20FC000" -Patch "Child Quest\Maps\zoras_domain_room_0.zmap"
    PatchBytes  -Offset "2103000" -Patch "Child Quest\Maps\zoras_domain_room_1.zmap"
    ChangeBytes -Offset @("B566", "B71B26") -Values "BA40"; ChangeBytes -Offset "B576"   -Values "2410"; ChangeBytes -Offset "B586"   -Values "FBA0"
    ChangeBytes -Offset   "B65C82"          -Values "3F90"; ChangeBytes -Offset "B71DCE" -Values "91B8"; ChangeBytes -Offset "B71DD2" -Values "91F8"

    PatchBytes  -Offset "2020000" -Patch "Child Quest\Maps\graveyard_scene.zscene"            # Add Child Header paths into the Adult Headers
    PatchBytes  -Offset "202C000" -Patch "Child Quest\Maps\graveyard_room_0.zmap"
    PatchBytes  -Offset "202F000" -Patch "Child Quest\Maps\graveyard_room_1.zmap"
    ChangeBytes -Offset @("B487", "B71AC3") -Values "E0"
    ChangeBytes -Offset   "B65CFA"          -Values "7118"

    PatchBytes  -Offset "1FB8000" -Patch "Child Quest\Maps\hyrule_field_scene.zscene"         # Add Running Man path for Adult Header
    PatchBytes  -Offset "1FE3000" -Patch "Child Quest\Maps\hyrule_field_room_0.zmap"
    ChangeBytes -Offset @("B447", "B71A9B") -Values "80"
    ChangeBytes -Offset   "B65C6A"          -Values "3B04"

    PatchBytes  -Offset "22C6000" -Patch "Child Quest\Maps\market_day_scene.zscene"           # Add Adult Header
    PatchBytes  -Offset "22C9000" -Patch "Child Quest\Maps\market_day_room_0.zmap"
    ChangeBytes -Offset @("B7C6", "B716C6") -Values "89D0"
    ChangeBytes -Offset   "B7D6"            -Values "EB50"



    # Imported Scenes and Maps
    $sceneStart  = 0x2A01000
    $sceneEnd    = $sceneStart + (Get-Item ($GameFiles.binaries + "\Child Quest\Maps\road_to_gerudos_fortress_scene.zscene")).Length
    $mapStart    = ($sceneEnd  + 0xFFF) -band 0xFFFFF000
    $mapEnd      = $mapStart   + (Get-Item ($GameFiles.binaries + "\Child Quest\Maps\road_to_gerudos_fortress_room_0.zmap")).Length
    $sceneOffset = (Get32Bit $sceneStart) + (Get32Bit $sceneEnd)
    $mapOffset   = (Get32Bit $mapStart)   + (Get32Bit $mapEnd)
    PatchBytes  -Offset (Get32Bit $sceneStart) -Patch "Child Quest\Maps\road_to_gerudos_fortress_scene.zscene"                               # Replace Market Entrance - Ruins
    PatchBytes  -Offset (Get32Bit $mapStart)   -Patch "Child Quest\Maps\road_to_gerudos_fortress_room_0.zmap"
    ChangeBytes -Offset "C3D0"    -Values ($sceneOffset + (Get32Bit $sceneStart)); ChangeBytes -Offset "B71684" -Values $sceneOffset
    ChangeBytes -Offset "C3E0"    -Values ($mapOffset   + (Get32Bit $mapStart))
    ChangeBytes -Offset "B6FC40"  -Values "1D0081021D0081021D0081021D0081021D01C1021D01C1021D01C1021D01C1021D0241021D0241021D0241021D024102" # Relink entrances (ENTR_UNUSED_6E, ENTR_SASATEST_0, ENTR_SYOTES_0) (14, 18, 1C)
    ChangeBytes -Offset "B6D35A"  -Values "0010"                                                                                             # Remove scene restrictions
    ChangeBytes -Offset "B7168C"  -Values "019CE000019CFB00"                                                                                 # Reuse Gerudo Valley title card

    $sceneStart  = 0x3139000
    $sceneEnd    = $sceneStart + (Get-Item ($GameFiles.binaries + "\Child Quest\Maps\road_to_lake_hylia_scene.zscene")).Length
    $mapStart    = ($sceneEnd  + 0xFFF) -band 0xFFFFF000
    $mapEnd      = $mapStart   + (Get-Item ($GameFiles.binaries + "\Child Quest\Maps\road_to_lake_hylia_room_0.zmap")).Length
    $sceneOffset = (Get32Bit $sceneStart) + (Get32Bit $sceneEnd)
    $mapOffset   = (Get32Bit $mapStart)   + (Get32Bit $mapEnd)
    PatchBytes  -Offset (Get32Bit $sceneStart) -Patch "Child Quest\Maps\road_to_lake_hylia_scene.zscene"    # Replace Temple of Time Exterior - Ruins
    PatchBytes  -Offset (Get32Bit $mapStart)   -Patch "Child Quest\Maps\road_to_lake_hylia_room_0.zmap"
    ChangeBytes -Offset "CCA0"   -Values ($sceneOffset + (Get32Bit $sceneStart)); ChangeBytes -Offset "B71724" -Values $sceneOffset
    ChangeBytes -Offset "CCB0"   -Values ($mapOffset   + (Get32Bit $mapStart))
    ChangeBytes -Offset "B6FC70" -Values "250081022500810225008102250081022501C1022501C1022501C1022501C102" # Relink entrances (ENTR_SYOTES2_0, ENTR_TESTROOM_0) (20, 24)
    ChangeBytes -Offset "B6FD0C" -Values "25024102250241022502410225024102"                                 # Relink entrances (ENTR_SUTARU_0)                   (47)
    ChangeBytes -Offset "B6D37A" -Values "0010"                                                             # Remove scene restrictions
    ChangeBytes -Offset "B7172C" -Values "019BE000019BFB00"                                                 # Reuse Hyrule Field title card

    $sceneStart  = (($ByteArrayGame[0xCCB4] * 0x1000000) + ($ByteArrayGame[0xCCB5] * 0x10000) + ($ByteArrayGame[0xCCB6] * 0x100) + $ByteArrayGame[0xCCB7] + 0xFFF) -band 0xFFFFF000
    $sceneEnd    = $sceneStart + (Get-Item ($GameFiles.binaries + "\Child Quest\Maps\shortcut_grottos_scene.zscene")).Length
    $mapStart    = ($sceneEnd  + 0xFFF) -band 0xFFFFF000
    $mapEnd      = $mapStart   + (Get-Item ($GameFiles.binaries + "\Child Quest\Maps\shortcut_grottos_room_0.zmap")).Length
    $sceneOffset = (Get32Bit $sceneStart) + (Get32Bit $sceneEnd)
    $mapOffset   = (Get32Bit $mapStart)   + (Get32Bit $mapEnd)
    PatchBytes  -Offset (Get32Bit $sceneStart) -Patch "Child Quest\Maps\shortcut_grottos_scene.zscene" # Replace Market Ruins
    PatchBytes  -Offset (Get32Bit $mapStart)   -Patch "Child Quest\Maps\shortcut_grottos_room_0.zmap"
    ChangeBytes -Offset "C390"   -Values ($sceneOffset + (Get32Bit $sceneStart)); ChangeBytes -Offset "B716E8"                        -Values $sceneOffset
    ChangeBytes -Offset "C3A0"   -Values ($mapOffset   + (Get32Bit $mapStart));   ChangeBytes -Offset (Get32Bit ($sceneStart + 0x98)) -Values $mapOffset
  # ChangeBytes -Offset "B6FE40" -Values "52104102521041025210410252104102"                            # Add entrance for Kakariko Village          (ENTR_TEST01_0)                  (94)
  # ChangeBytes -Offset "B71070" -Values "5B0A41025B0A41025B0A41025B0A4102"                            # Add entrance for Lost Woods                (ENTR_BESITU_0)                  (520)
    ChangeBytes -Offset "B6FE40" -Values "55074102550741025507410255074102"                            # Add entrance for Kokiri Forest             (ENTR_TEST01_0)                  (94)
    ChangeBytes -Offset "B71070" -Values "55084102550841025508410255084102"                            # Add entrance for Kokiri Forest             (ENTR_BESITU_0)                  (520)
    ChangeBytes -Offset "B70798" -Values "25034102250341022503410225034102"                            # Add entrance for Road to Lake Hylia        (ENTR_TEST_SHOOTING_GALLERY_0)   (2EA)
    ChangeBytes -Offset "B707B0" -Values "1D0341021D0341021D0341021D034102"                            # Add entrance for Road to Gerudo's Fortress (ENTR_TEST_SHOOTING_GALLERY_0_6) (2F0)
    ChangeBytes -Offset "B6D366" -Values "00D0"                                                        # Remove scene restrictions
    ChangeBytes -Offset "B6FCF4" -Values "2200010222000102"                                            # Relink entrance (ENTR_GROTTOS_0_2) (41)
    ChangeBytes -Offset "B71258" -Values "2201010222010102"                                            # Relink entrance (ENTR_GROTTOS_1_2) (59A)
    ChangeBytes -Offset "B71268" -Values "2202010222020102"                                            # Relink entrance (ENTR_GROTTOS_2_2) (59E)
    ChangeBytes -Offset "B71278" -Values "2203010222030102"                                            # Relink entrance (ENTR_GROTTOS_3_2) (5A2)



    # Yellow Tektite
    ChangeBytes -Offset   "B5E587"            -Values "B0"   # En_Part pointer
    ChangeBytes -Offset @("9456",   "B6F00E") -Values "FFF0" # Tektite Object DMA
    PatchBytes  -Offset   "104C000"           -Patch  "Child Quest\tektite.obj"
    PatchBytes  -Offset   "C2B0C0"            -Patch  "Child Quest\tektite.ovl"
    PatchBytes  -Offset   "C02E00"            -Patch  "Child Quest\parts.ovl"



    # Header Entrances
    ChangeBytes -Offset @("B6FEBC", "B7032C", "B7033C", "B7034C", "B70560", "B70570", "B70580", "B70670", "B70680", "B70AD8", "B70AE8") -Values "20" # Market Ruins                  -> Market Day
    ChangeBytes -Offset @("B6FEC0", "B70330", "B70340", "B70350", "B70564", "B70574", "B70584", "B70674", "B70684", "B70ADC", "B70AEC") -Values "21" # Market Ruins                  -> Market Night
    ChangeBytes -Offset @("B6FCC4", "B705B0", "B705D0")                                                                                 -Values "1B" # Market Entrance Ruins         -> Market Entrance Day
    ChangeBytes -Offset @("B6FCC8", "B705B4", "B705D4")                                                                                 -Values "1C" # Market Entrance Ruins         -> Market Entrance Night
    ChangeBytes -Offset @("B701BC", "B70DC0")                                                                                           -Values "23" # Temple of Time Exterior Ruins -> Temple of Time Exterior Day
    ChangeBytes -Offset @("B701C0", "B70DC4")                                                                                           -Values "24" # Temple of Time Exterior Ruins -> Temple of Time Exterior Night
    ChangeBytes -Offset @("B6FDC8", "B6FDCC", "B6FDD0", "B6FDD4")                                                                       -Values "4D" # Hairal Niwa2 (debug)          -> Market Guard House
    ChangeBytes -Offset @("B70216", "B7021A", "B7021E", "B70222", "B705DA", "B705DE", "B705E2", "B705E6")                               -Values "81" # Don't show title area for the Lake Hylia Exit in Hyrule Field
    ChangeBytes -Offset @("B704A6", "B704AA", "B704AE", "B704B2")                                                                       -Values "81" # Don't show title area for the Gerudo's Fortress Exit in Gerudo Valley
    ChangeBytes -Offset @("B704A6", "B704AA", "B704AE", "B704B2", "B704A6", "B704AA", "B704AE", "B704B2")                               -Values "81" # Don't show title area and change scene from Grotto to Market Ruins
    


    # Clear Block
    PatchBytes  -Offset   "11D6000"           -Patch  "Child Quest\Whole\clear_block.bin"; ChangeBytes -Offset @("9746",   "B6F186") -Values "7790" # Clear Block object (oB4)
    ChangeBytes -Offset   "EE2753"            -Values "00";                                ChangeBytes -Offset   "EE2782"            -Values "1758" # Clear Block DL
    ChangeBytes -Offset   "EE2C1F"            -Values "00";                                ChangeBytes -Offset   "EE2C22"            -Values "0B00" # Shadow Path DL
    ChangeBytes -Offset @("EE2D2B", "EE2D8B") -Values "00";                                ChangeBytes -Offset @("EE2D42", "EE2D8E") -Values "15A0" # Clear Block Collision
    ChangeBytes -Offset   "EE2DB8"            -Values "0045"



    # Whole Actors
    PatchBytes  -Offset "E28800" -Patch "Child Quest\Whole\stone_blocking_well.bin"                                              # The big stone blocking the Bottom of the Well is now removed when the well is drained
    PatchBytes  -Offset "D5AFE0" -Patch "Child Quest\Whole\lake_hylia_objects.bin"                                               # Lake Hylia water sinds and restores after the Master Sword, and Lake Hylia objects can be interacted with as child
    PatchBytes  -Offset "E036D0" -Patch "Child Quest\Whole\bean_plant_spot.bin"                                                  # Make Magic Beans grow at day and shrink at night when planted after the Master Sword cutscene
    PatchBytes  -Offset "CBEFA0" -Patch "Child Quest\Whole\talon.bin"                                                            # Talon sleeps in Kakariko after sleeping in Hyrule Castle before going back to the Ranch
    PatchBytes  -Offset "D50720" -Patch "Child Quest\Whole\ingo.bin"                                                             # Ingo now changes his behaviour after the Master Sword cutscene instead of being Adult Link
    PatchBytes  -Offset "E21660" -Patch "Child Quest\Whole\ingo_gate.bin"                                                        # Ingo's Gate uses the Master Scene cutscene check instead of an age check
    PatchBytes  -Offset "E1DDC0" -Patch "Child Quest\Whole\cucco_lady.bin"                                                       # Cucco Lady gives the Pocket Egg and Cojiri after getting the bottle and then resumes with the bottle events again
    PatchBytes  -Offset "E42600" -Patch "Child Quest\Whole\windmill_man.bin"                                                     # Windmill Man either teaches the Song of Songs or letting it play to him depending on the seen cutscenes
    PatchBytes  -Offset "E09540" -Patch "Child Quest\Whole\music_staff_spot.bin"                                                 # Allow playing back the Song of Storms once it's learned
    PatchBytes  -Offset "ED2040" -Patch "Child Quest\Whole\goron_2.bin";                                                         # Gorons are changed after the Master Sword cutscene (and Biggoron requires Giant's Knife before trading Broken Goron's Sword)
    PatchBytes  -Offset "D21A90" -Patch "Child Quest\Whole\darunias_statue.bin"                                                  # Darunia's Statue is changed after the Master Sword cutscene
    PatchBytes  -Offset "CB66A0" -Patch "Child Quest\Whole\master_sword_pedestal.bin"; ChangeBytes -Offset "B5F227" -Values "90" # Prevent interaction once pulled
    PatchBytes  -Offset "DBE030" -Patch "Child Quest\Whole\fishing.bin";               ChangeBytes -Offset "B60467" -Values "A0" # Allow fishing for different conditions and reward after the Master Sword cutscene
    PatchBytes  -Offset "E51A60" -Patch "Child Quest\Whole\kokiri.bin"                                                           # Kokiri now change after the Master Sword cutscene
    PatchBytes  -Offset "E61B50" -Patch "Child Quest\Whole\mido.bin"                                                             # Mido is no longer found in his house after the Master Sword cutscene
    PatchBytes  -Offset "DFC3B0" -Patch "Child Quest\Whole\zoras_domain_ice.bin"                                                 # Zora's Domain is now frozen inbetween the Master Sword cutscene and the Water Temple
    PatchBytes  -Offset "C823F0" -Patch "Child Quest\Whole\drawbridge.bin"                                                       # Drawbridge won't close at night with Epona last used in Hyrule Field



    # Partial Actors / Other Options
    PatchBytes  -Offset   "EF17E5"                                -Patch  "Child Quest\Partial\goron_city_sliding_doors.bin"                                                                                         # Sliding Doors (Goron City) are changed after the Master Sword cutscene
    PatchBytes  -Offset   "D21588"                                -Patch  "Child Quest\Partial\gerudo_valley_objects.bin"                                                                                            # Gerudo Valley objects now uses the adult properties after the Master Sword cutscene
    PatchBytes  -Offset   "C6CB61"                                -Patch  "Child Quest\Partial\shopkeeper_goron.bin"                                                                                                 # Goron Shopkeeper adjusts dialogue after the Master Sword cutscene
    PatchBytes  -Offset   "AFD129"                                -Patch  "Child Quest\Partial\scene_table_zoras_domain.bin"                                                                                         # Don't draw the water reflections in Zora's Domain when frozen
    PatchBytes  -Offset   "CF731B"                                -Patch  "Child Quest\Partial\grotto_entrance.bin"                                                                                                  # Add extra grotto entrances
    PatchBytes  -Offset   "D7E354"                                -Patch  "Child Quest\Partial\child_malon.bin"                                                                                                      # Remove Child Malon in the Lon Lon Ranch adult header if you got Epona's Song
    PatchBytes  -Offset   "E5730D"                                -Patch  "Child Quest\Partial\close_proximity_weather.bin"                                                                                          # Fix environment light issues by removing weather mode change
    ChangeBytes -Offset @("F051F0", "F05280")                     -Values "FFDB092A005D"                                                                                                                             # Adjust Equipment Subscreen height poses
    ChangeBytes -Offset   "ABF3AC"                                -Values "14E100102508EE703C0980129529B4AC312A00201140000B000000008C8C008C24010056858200A4144100062401005510410004346D0010A48D014A100000482402FFFB" # Change Camera View in Sacred Forest Meadow depending on the Master Sword cutscene
    ChangeBytes -Offset   "BEFD6C"                                -Values "0342"                                                                                                                                     # Great Fairy's Fountain (Double Defense) exit
    ChangeBytes -Offset @("B65CA6", "B65CAE", "B65CB6", "B65CBE") -Values "02"                                                                                                                                       # Lon Lon Ranch fence exit cutscenes work for both ages
    ChangeBytes -Offset   "C8055C"                                -Values "94620EDC304E002011C00049"                                                                                                                 # Make Sheik appear as Child in the Temple of Time after the Master Sword cutscene)
    ChangeBytes -Offset   "BEDF00"                                -Values "00" -Repeat 0x1F                                                                                                                          # Fix animation for losing sword during Ganon boss fight
    ChangeBytes -Offset   "B6D9DE"                                -Values "00"                                                                                                                                       # Disable culling for Link's water reflection

    
    
    # World Map Boxes (x, w, y, h, tex)
    ChangeBytes -Offset "BC72EA" -Values "FFBD"; ChangeBytes -Offset "BC7316" -Values "0020"; ChangeBytes -Offset "BC7342" -Values "0017"; ChangeBytes -Offset "BC736E" -Values "001A"; ChangeBytes -Offset "BC73C6" -Values "74E0"  # Ganon's Castle



    # Cutscenes
    PatchBytes  -Offset "BE21E8" -Patch  "Child Quest\sword_cutscene_1.bin"; PatchBytes  -Offset "BF2AEF" -Patch  "Child Quest\sword_cutscene_2.bin" # Keep the current equipped sword in cutscenes
    ChangeBytes -Offset "C7F627" -Values "0E";                               ChangeBytes -Offset "BF0570" -Values "02"                               # Use Child Link scream sound effect and charging animation during the Bongo Bongo attack on Kakariko
    ChangeBytes -Offset "BF05F0" -Values "00";                               ChangeBytes -Offset "BF05F8" -Values "03"                               # Use Child Link animations during Ganon boss cutscene
    ChangeBytes -Offset "BF05A8" -Values "03";                               ChangeBytes -Offset "BF05B0" -Values "03"                               # Warp song animations (before, after)



    # Keep Kakariko Potion Shop Seller after Master Sword cutscene
    ChangeBytes -Offset @("C6CDF9", "C6CE35") -Values "E2"; ChangeBytes -Offset @("C6CE11", "C6CE25") -Values "03"; ChangeBytes -Offset @("C6CE3D", "C6CE65", "C6CE91", "C6CED1") -Values "41"
    ChangeBytes -Offset "C6CE98" -Values "94890EDC8FAB002C312A00205540000A24010002856C00A4240100645181"
    ChangeBytes -Offset "C6CE29" -Values "61";   ChangeBytes -Offset "C6CE05" -Values "02"; ChangeBytes -Offset "C6CE49" -Values "43"; ChangeBytes -Offset "C6CED9" -Values "8D"; ChangeBytes -Offset "C6CEDD" -Values "AE"; ChangeBytes -Offset "C6CEE1" -Values "C0"
    ChangeBytes -Offset "C6CEF9" -Values "48";   ChangeBytes -Offset "C6CEFD" -Values "18"; ChangeBytes -Offset "C6CF16" -Values "78"; ChangeBytes -Offset "C6CF19" -Values "F8"; ChangeBytes -Offset "C6CF39" -Values "F9"
    ChangeBytes -Offset "C6CF00" -Values "2718"; ChangeBytes -Offset "C6CF44" -Values "0721"



    # Item Drops
    ChangeBytes -Offset @("A894AF", "A894E7", "A894EF") -Values "10"   # Don't convert Arrows into Bullet Seeds
    ChangeBytes -Offset   "A89C9C"                      -Values "1400" # Ignore age check for Flex Arrows
    

    
    # Loot Tables
    ChangeBytes -Offset @("B5D771", "B5D78E", "B5D799", "B5D79D", "B5D7C1", "B5D843", "B5D852") -Values "08" # Replace some Bullet Seeds with Small Arrow Bundles



    # Age Checks
    ChangeBytes -Offset   "AEFA6C"                      -Values "24080000"                                                                                        # Allow Silver/Golden Gauntlets Strength as Child
    ChangeBytes -Offset @("C7B9C0", "C7BAEC", "C7BCA4") -Values "15000000"                                                                                        # Make Sheik appear as Child in the Sacred Forest Meadow, Death Mountain Crater and Ice Cavern
    ChangeBytes -Offset @("AC9245", "AC95F5", "AC9915") -Values "27"                                                                                              # Stay Child during cutscenes (Light Arrow, Rauru, Master Sword)
    ChangeBytes -Offset   "BA11AC"                      -Values "37";   ChangeBytes -Offset "BA1171" -Values "0343804302A402420E0FA44E4F181939189899" -Interval 4 # Title screen into as Child
    ChangeBytes -Offset   "C00DD0"                      -Values "1500"; ChangeBytes -Offset "C00E78" -Values "1500"                                               # Purchasable tunics as Child
    ChangeBytes -Offset   "B0631F"                      -Values "01";   ChangeBytes -Offset "B06357" -Values "04"                                                 # Turn into Child if opening a save slot as Adult instead of resetting the Adult spawn entrance
    ChangeBytes -Offset   "ACCD84"                      -Values "1100"                                                                                            # Nocturne of Shadow cutscene as Child
    ChangeBytes -Offset   "DE0214"                      -Values "1100"                                                                                            # Make Ice Platforms appear as Child
    ChangeBytes -Offset   "B65D56"                      -Values "01"                                                                                              # Nabooru Iron Knuckle cutscene as Child
    ChangeBytes -Offset   "B65D5E"                      -Values "02"                                                                                              # Gerudo Fortress jail cutscene as Child
    ChangeBytes -Offset   "B65D15"                      -Values "3A02"                                                                                            # Fix Ganon's Castle intro
    ChangeBytes -Offset   "F01C7C"                      -Values "1500"                                                                                            # Fix Silver Blocks
    ChangeBytes -Offset   "EB7FA8"                      -Values "1400"                                                                                            # Fix Spirit Temple Stone Elevator
    ChangeBytes -Offset   "ACCE48"                      -Values "15000000"                                                                                        # Light Arrows cutscene as Child
    ChangeBytes -Offset   "EF4F8C"                      -Values "1100"                                                                                            # Allow Bonooru to activate the Scarecrow's Song as Child
    ChangeBytes -Offset   "D5A80C"                      -Values "1000"                                                                                            # Prevent Deku Tree Sprout from disappearing after its cutscene
    ChangeBytes -Offset @("B061DF", "B061B3")           -Values "02";   ChangeBytes -Offset "B061A3" -Values "3C"                                                 # Master Sword & Hylian Shield equipped as Child on Debug Save Slot (also used by Title Screen and Demos)
    ChangeBytes -Offset   "CF0D20"                      -Values "1100"                                                                                            # Make Darunia appear as Child in the Fire Temple
    ChangeBytes -Offset   "EBB688"                      -Values "1100"                                                                                            # Make barbed fences appear as Child
    ChangeBytes -Offset   "E20B90"                      -Values "1500"                                                                                            # Kill the Carpenter's Son in the Lost Woods if his trade sequence part is completed
    ChangeBytes -Offset   "D5DCDC"                      -Values "1400"; ChangeBytes -Offset "EF2164" -Values "1500"                                               # Adult Malon appears as Child
    ChangeBytes -Offset   "DD592C"                      -Values "1500"; ChangeBytes -Offset "DD5990" -Values "1000"                                               # Kill the Kakariko Well Crossbeam after the attack as Child
    ChangeBytes -Offset   "EF2FA4"                      -Values "1500"                                                                                            # Don't kill Horse Race Cow reward as Child Link



    # Epona
    PatchBytes  -Offset "AD0E60"  -Patch  "Child Quest\Partial\horse.bin"                                                     # Horses do not despawn as Child except during the Learning Epona's Song cutscene
    PatchBytes  -Offset "C15AC0"  -Patch  "Child Quest\Whole\horse.bin"                                                       # Adjust rideable horses for Child Link
    PatchBytes  -Offset "C69FC0"  -Patch  "Child Quest\Whole\horse_normal.bin"                                                # Adjust normal horse locations after the Master Sword cutscene instead of an age check
    PatchBytes  -Offset "1204000" -Patch  "Child Quest\Whole\epona.bin"                                                       # MM Child Epona object (replaces oE5 to oE8)
    PatchBytes  -Offset "AD0323"  -Patch  "Child Quest\Partial\allowed_horse_scenes_1.bin"                                    # Expand allowed list of scenes for Epona to summon on
    PatchBytes  -Offset "AD0453"  -Patch  "Child Quest\Partial\allowed_horse_scenes_2.bin"                                    # Expand allowed list of scenes for Epona to summon on
  # ChangeBytes -Offset "C20CA5"  -Values "1DF6840028FF800000002500B0FF4EFDEC"                                                # Replace map & spawn coordinates for Epona
    ChangeBytes -Offset "C20FB8"  -Values "0000000045548000"                                                                  # Epona Rider Offset
    ChangeBytes -Offset "9490"    -Values "01204000012124F001204000"; ChangeBytes -Offset "B6F028" -Values "01204000012124F0" # MM Child Epona object

    ChangeBytes -Offset "C20610"  -Values "06006D440600746806005F6406004DE806007D50060043AC06002F98060035B006003D38" # Epona Animation & Skin offsets
    ChangeBytes -Offset "C20686"  -Values "A480"
    ChangeBytes -Offset "C20FEC"  -Values "06001D280600192806001B28"

    ChangeBytes -Offset   "C1FA2B"                                          -Values "05" # Epona Limbs
    ChangeBytes -Offset @("C1FD47", "C1FFAB", "C20067", "C20177", "C2026F") -Values "24" # Epona Limbs
    ChangeBytes -Offset @("C1FE03", "C1FF43", "C200B7", "C201C7", "C20257") -Values "2C" # Epona Limbs
    ChangeBytes -Offset @("C15DDB", "CF6557", "CF6733", "CF6743")           -Values "05" # Horses do not despawn as Child except during the Learning Epona's Song cutscene
    
    

    # Replace Shop Items for Kakariko Bazaar
    ChangeBytes -Offset "C71FF1" -Values "1D" # Arrows (10) to Deku Seeds (30)
    ChangeBytes -Offset "C71FF9" -Values "10" # Arrows (50) to Recovery Heart
    ChangeBytes -Offset "C72009" -Values "04" # Arrows (30) to Deku Nuts (10)



    # Trade Quest sequence
    PatchBytes  -Offset "7F0000"  -Patch  "Equipment\gold_dust.icon"     -Texture        # Icon:  Broken Goron's Sword -> Gold Dust
    PatchBytes  -Offset "8AB800"  -Patch  "Equipment\gold_dust.en.label" -Texture        # Label: Broken Goron's Sword -> Gold Dust
    PatchBytes  -Offset "3475000" -Patch  "Object GI Models\Gold Dust.bin"               # Model: Broken Goron's Sword -> Gold Dust (from Broken Sword) (oA4)
    ChangeBytes -Offset "AE5F28"  -Values "1400"                                         # Refresh Silver Sword into Gilded Sword after obtaining it from Biggoron
    ChangeBytes -Offset "A610"    -Values "034750000347614003475000"; ChangeBytes -Offset "B6F970" -Values "0347500003476140"; ChangeBytes -Offset "B6698A" -Values "0888"

    PatchBytes  -Offset "E55BA0"  -Patch "Child Quest\Whole\king_zora.bin"               # King Zora in both his Child and Adult states after the Master Sword cutscene
    PatchBytes  -Offset "EEB300"  -Patch "Child Quest\Whole\carpenters_kakariko.bin"     # Move Carpenters out of Kakariko after the Master Sword cutscene
    PatchBytes  -Offset "E0E570"  -Patch "Child Quest\Whole\master_craftsman.bin"        # Move the Master Craftsman from Kakariko to Gerudo Valley after the Master Sword cutscene



    # Chests
    ChangeBytes -Offset "AE76FF" -Values "58"   # Fix Deku Seeds in chests
    ChangeBytes -Offset "AE7780" -Values "1500" # Fix Magic Jars (small + large) in chests



    # Damage Tables
    ChangeBytes -Offset "DFE765" -Values "F2"; ChangeBytes -Offset "DFE76C" -Values "F1"; ChangeBytes -Offset "DFE77A" -Values "F1"; ChangeBytes -Offset "DFE77D" -Values "F2"; ChangeBytes -Offset "DFE782" -Values "F4" # Freezard (Deku Stick, Kokiri Slash, Kokiri Spin, Kokiri Jump, Hammer Jump)
    ChangeBytes -Offset "CB4DB1" -Values "D2"; ChangeBytes -Offset "CB4DB2" -Values "D1"; ChangeBytes -Offset "CB4DB8" -Values "D1"                                                                                       # Blue Bubble (Deku Stick, Slingshot, Kokiri Slash)
    ChangeBytes -Offset "C673F9" -Values "F2"; ChangeBytes -Offset "C673FA" -Values "F1"; ChangeBytes -Offset "C67400" -Values "F1"                                                                                       # Torch Slug (Deku Stick, Slingshot, Kokiri Slash)
    ChangeBytes -Offset "D49F5E" -Values "02"; ChangeBytes -Offset "D49F61" -Values "02"; ChangeBytes -Offset "D49F62" -Values "03"; ChangeBytes -Offset "D49F6F" -Values "03"; ChangeBytes -Offset "D49F70" -Values "02" # Big Octorok (Hammer Swing, Master Slash, Giant Slash, Giant Spin, Master Spin)
    ChangeBytes -Offset "D49F72" -Values "06"; ChangeBytes -Offset "D49F73" -Values "04"; ChangeBytes -Offset "D49F76" -Values "04"                                                                                       # Big Octorok (Giant Jump, Master Jump, Hammer Jump)
    ChangeBytes -Offset "DAF295" -Values "F2"; ChangeBytes -Offset "DAF296" -Values "F1"; ChangeBytes -Offset "DAF298" -Values "F1"; ChangeBytes -Offset "DAF29C" -Values "F1"; ChangeBytes -Offset "DAF2AA" -Values "F1" # Spike (Deku Stick, Slingshot, Boomerang, Kokiri Slash, Kokiri Spin)
    ChangeBytes -Offset "DAF2AD" -Values "F2"; ChangeBytes -Offset "DAF2B2" -Values "F4"                                                                                                                                  # Spike (Kokiri Jump, Hammer Jump)
    ChangeBytes -Offset "C2F5DE" -Values "E4"                                                                                                                                                                             # Leever (Hammer Jump)
    ChangeBytes -Offset "D4759E" -Values "F1"; ChangeBytes -Offset "D475A0" -Values "11"; ChangeBytes -Offset "D475BA" -Values "D4"                                                                                       # Shell Blade (Slingshot, Boomerang, Hammer Jump)
    ChangeBytes -Offset "D76516" -Values "F4"

    # Giant's Knife Damage Tables - Global
    ChangeBytes -Offset   "B6564A"                                                    -Values "F3"
    ChangeBytes -Offset   "B657A8"                                                    -Values "010203"
    ChangeBytes -Offset @("B65657", "B6566A", "B656AA", "B6574A", "B657EA", "B6582A") -Values "03" 
    ChangeBytes -Offset @("B65677",           "B656B7", "B65757", "B657F7", "B65837") -Values "0302"
    ChangeBytes -Offset @("B6567A", "B6569A", "B656BA", "B6575A", "B657FA", "B6583A") -Values "0604"
    
    # Giant's Knife Damage Tables - Enemies (Slash, Spin & Jump)
    ChangeBytes -Offset @("BFFC32", "BFFC3F") -Values 1 -Subtract; ChangeBytes -Offset "BFFC42" -Values 2 -Subtract # Stalfos
    ChangeBytes -Offset @("C0B816", "C0B823") -Values 1 -Subtract; ChangeBytes -Offset "C0B826" -Values 2 -Subtract # Poe
    ChangeBytes -Offset @("C0DF0A", "C0DF17") -Values 1 -Subtract; ChangeBytes -Offset "C0DF1A" -Values 2 -Subtract # Octorok
    ChangeBytes -Offset @("C1098E", "C1099B") -Values 1 -Subtract; ChangeBytes -Offset "C1099E" -Values 2 -Subtract # Wallmaster
    ChangeBytes -Offset @("C13366", "C13373") -Values 1 -Subtract; ChangeBytes -Offset "C13376" -Values 2 -Subtract # Dodongo 
    ChangeBytes -Offset @("C15826", "C15833") -Values 1 -Subtract; ChangeBytes -Offset "C15836" -Values 2 -Subtract # Keese
    ChangeBytes -Offset @("C2DBEE", "C2DBFB") -Values 1 -Subtract; ChangeBytes -Offset "C2DBFE" -Values 2 -Subtract # Tektite
    ChangeBytes -Offset @("C32BCA", "C32BD7") -Values 1 -Subtract; ChangeBytes -Offset "C32BDA" -Values 2 -Subtract # Peahat
    ChangeBytes -Offset @("C3A31E", "C3A32B") -Values 1 -Subtract; ChangeBytes -Offset "C3A32E" -Values 2 -Subtract # Wolfos
    ChangeBytes -Offset @("C5D1F2", "C5D1FF") -Values 1 -Subtract; ChangeBytes -Offset "C5D202" -Values 2 -Subtract # Dark Link
    ChangeBytes -Offset @("C5F6B2", "C5F6BF") -Values 1 -Subtract; ChangeBytes -Offset "C5F6C2" -Values 2 -Subtract # Biri
    ChangeBytes -Offset @("C6183E", "C6184B") -Values 1 -Subtract; ChangeBytes -Offset "C6184E" -Values 2 -Subtract # Tailpasaran
    ChangeBytes -Offset @("C67402", "C6740F") -Values 1 -Subtract; ChangeBytes -Offset "C67412" -Values 2 -Subtract # Torch Slug
    ChangeBytes -Offset @("C693DE", "C693EB") -Values 1 -Subtract; ChangeBytes -Offset "C693EE" -Values 2 -Subtract # Stinger (Land)
    ChangeBytes -Offset @("C870FE", "C8710B") -Values 1 -Subtract; ChangeBytes -Offset "C8710E" -Values 2 -Subtract # Spear Moblin
    ChangeBytes -Offset @("C8711E", "C8712B") -Values 1 -Subtract; ChangeBytes -Offset "C8712E" -Values 2 -Subtract # Club Moblin
    ChangeBytes -Offset @("C98932", "C9893F") -Values 1 -Subtract; ChangeBytes -Offset "C98942" -Values 2 -Subtract # Armos
    ChangeBytes -Offset @("C9C32A", "C9C337") -Values 1 -Subtract; ChangeBytes -Offset "C9C33A" -Values 2 -Subtract # Deku Baba
    ChangeBytes -Offset @("C9C34A", "C9C357") -Values 1 -Subtract; ChangeBytes -Offset "C9C35A" -Values 2 -Subtract # Big Deku Baba
    ChangeBytes -Offset @("CA85EE", "CA85FB") -Values 1 -Subtract; ChangeBytes -Offset "CA85FE" -Values 2 -Subtract # Mad Scrub
    ChangeBytes -Offset @("CAAFAE", "CAAFBB") -Values 1 -Subtract; ChangeBytes -Offset "CAAFBE" -Values 2 -Subtract # Bari
    ChangeBytes -Offset @("CB4D9A", "CB4DA7") -Values 1 -Subtract; ChangeBytes -Offset "CB4DAA" -Values 2 -Subtract # Bubble (Green)
    ChangeBytes -Offset @("CB4DBA", "CB4DC7") -Values 1 -Subtract; ChangeBytes -Offset "CB4DCA" -Values 2 -Subtract # Bubble (Red)
    ChangeBytes -Offset @("CB4DDA", "CB4DE7") -Values 1 -Subtract; ChangeBytes -Offset "CB4DEA" -Values 2 -Subtract # Bubble (White)
    ChangeBytes -Offset @("CD583E", "CD584B") -Values 1 -Subtract; ChangeBytes -Offset "CD584E" -Values 2 -Subtract # Floormaster
    ChangeBytes -Offset @("CD96B6", "CD96C3") -Values 1 -Subtract; ChangeBytes -Offset "CD96C6" -Values 2 -Subtract # ReDead / Gibdo
    ChangeBytes -Offset @("CDE20E", "CDE21B") -Values 1 -Subtract; ChangeBytes -Offset "CDE21E" -Values 2 -Subtract # Poe Sisters
    ChangeBytes -Offset @("D0AA9A", "D0AAA7") -Values 1 -Subtract; ChangeBytes -Offset "D0AAAA" -Values 2 -Subtract # Dead Hand
    ChangeBytes -Offset @("D0BA5A", "D0BA67") -Values 1 -Subtract; ChangeBytes -Offset "D0BA6A" -Values 2 -Subtract # Dead Hand (Arms)
    ChangeBytes -Offset @("D2F0BA", "D2F0C7") -Values 1 -Subtract; ChangeBytes -Offset "D2F0CA" -Values 2 -Subtract # Barinade
    ChangeBytes -Offset @("D475A6", "D475B3") -Values 1 -Subtract; ChangeBytes -Offset "D475B6" -Values 2 -Subtract # Shellblade
    ChangeBytes -Offset @("D76502", "D7650F") -Values 1 -Subtract; ChangeBytes -Offset "D76512" -Values 2 -Subtract # Like-Like
    ChangeBytes -Offset @("DAF29E", "DAF2AB") -Values 1 -Subtract; ChangeBytes -Offset "DAF2AE" -Values 2 -Subtract # Spike
    ChangeBytes -Offset @("DED80E", "DED81B") -Values 1 -Subtract; ChangeBytes -Offset "DED81E" -Values 2 -Subtract # Iron Knuckle
    ChangeBytes -Offset @("DF262E", "DF263B") -Values 1 -Subtract; ChangeBytes -Offset "DF263E" -Values 2 -Subtract # Skullkid
    ChangeBytes -Offset @("DFE76E", "DFE77B") -Values 1 -Subtract; ChangeBytes -Offset "DFE77E" -Values 2 -Subtract # Freezard
    ChangeBytes -Offset @("E7859A", "E785A7") -Values 1 -Subtract; ChangeBytes -Offset "E785AA" -Values 2 -Subtract # Big Poe
    ChangeBytes -Offset @("EB798E", "EB799B") -Values 1 -Subtract; ChangeBytes -Offset "EB799E" -Values 2 -Subtract # Stinger (Water)
    ChangeBytes -Offset @("EC15EE", "EC15FB") -Values 1 -Subtract; ChangeBytes -Offset "EC15FE" -Values 2 -Subtract # Gerudo Fighter
    ChangeBytes -Offset @("EDBE22", "EDBE2F") -Values 1 -Subtract; ChangeBytes -Offset "EDBE32" -Values 2 -Subtract # Wolfos
    ChangeBytes -Offset @("EDDA62", "EDDA6F") -Values 1 -Subtract; ChangeBytes -Offset "EDDA72" -Values 2 -Subtract # Stalchild
    ChangeBytes -Offset @("EEF792", "EEF79F") -Values 1 -Subtract; ChangeBytes -Offset "EEF7A2" -Values 2 -Subtract # Guay
    ChangeBytes -Offset "C2F5C9" -Values "E2E3"; ChangeBytes -Offset "C2F5D6" -Values "E1E3E2"; ChangeBytes -Offset "C2F5DA" -Values "E6" # Leever



    # Testing

  # ChangeBytes -Offset "C21030" -Values "40C23D71" # First Ingo Race speed from 12.625f to 6.625f
  # ChangeBytes -Offset "C16EAE" -Values "40D4"     # Second Ingo Race speed from 12.07f to 6.07f

}



#==============================================================================================================================================================================================
function ChildQuestByteReduxOptions() {
    
    ChangeBytes -Offset $Symbols.CFG_ALLOW_MASTER_SWORD  -Values "01"
    ChangeBytes -Offset $Symbols.CFG_ALLOW_GIANTS_KNIFE  -Values "01"
    ChangeBytes -Offset $Symbols.CFG_ALLOW_MIRROR_SHIELD -Values "01"
    ChangeBytes -Offset $Symbols.CFG_ALLOW_BOOTS         -Values "01"
    ChangeBytes -Offset $Symbols.CFG_ALLOW_TUNIC         -Values "01"
    ChangeBytes -Offset $Symbols.CFG_SILVER_SWORD        -Values "01"

}



#==============================================================================================================================================================================================
function ChildQuestByteSceneOptions() {
    
    # KOKIRI FOREST #
    
    PrepareMap  -Scene "Kokiri Forest" -Map 0 -Header 1 # Adult Infested - Village
    ChangeSpawnPoint                   -Index 7 -X -490  -Y 28  -Z  185  -YRot 0X4000 -Param "04FF"
    ChangeSpawnPoint                   -Index 8 -X  55   -Y 28  -Z -430  -YRot 0xC000 -Param "04FF"
    InsertActor  -Name  "Skullwalltula"         -X -1307 -Y 153 -Z  401  -YRot 0xCD83 -Param "AD02" # Gold Skulltula (Twin's House)
    InsertActor  -Name  "Skulltula (Bean Spot)" -X  1189        -Z -480               -Param "4D01"
    InsertActor  -Name  "Grotto Entrance"       -X -520  -Y 0   -Z  185  -ZRot 14     -Param "0000"
    InsertActor  -Name  "Grotto Entrance"       -X  55   -Y 0   -Z -460  -ZRot 16     -Param "0000"
    InsertActor  -Name  "Insect Group Spawner"  -X -490  -Y 68  -Z  185               -Param "5324" # Butterflies to indicate grotto entrance
    InsertActor  -Name  "Insect Group Spawner"  -X  55   -Y 68  -Z -430               -Param "5324" # Butterflies to indicate grotto entrance

    SaveLoadedMap

    PrepareMap  -Scene "Kokiri Forest" -Map 0 -Header 2 # Adult Cleansed - Village
    ChangeSpawnPoint                   -Index 7 -X -490  -Y 28  -Z  185  -YRot 0X4000 -Param "04FF"
    ChangeSpawnPoint                   -Index 8 -X  55   -Y 28  -Z -430  -YRot 0xC000 -Param "04FF"
    InsertActor  -Name  "Skullwalltula"         -X -1307 -Y 153 -Z  401  -YRot 0xCD83 -Param "AD02" # Gold Skulltula (Twin's House)
    InsertActor  -Name  "Skulltula (Bean Spot)" -X  1189        -Z -480               -Param "4D01"
    InsertActor  -Name  "Collectable"           -X -537  -Y 1   -Z  194  -ZRot 0xB6   -Param "2400"
    InsertActor  -Name  "Collectable"           -X -459  -Y 1   -Z  181               -Param "2700"
    InsertActor  -Name  "Collectable"           -X  35   -Y 1   -Z -418               -Param "2500"
    InsertActor  -Name  "Collectable"           -X  107  -Y 1   -Z -418               -Param "2600"
    InsertActor  -Name  "Collectable"           -X -364  -Y 53  -Z -783               -Param "1201"
    InsertActor  -Name  "Collectable"           -X  2    -Y 180 -Z -45                -Param "1101"
    InsertActor  -Name  "Invisible Collectable" -X -488  -Y 140 -Z  600  -YRot 0xB27D -Param "1A53"
    InsertActor  -Name  "Invisible Collectable" -X  1074        -Z -178  -ZRot 2      -Param "2A63"
    InsertActor  -Name  "Invisible Collectable" -X  1069        -Z  406               -Param "37E3"
    InsertActor  -Name  "Invisible Collectable" -X  1074        -Z -80   -ZRot 1      -Param "37E3"
    InsertActor  -Name  "Invisible Collectable" -X  188  -Y 3   -Z -198  -ZRot 1      -Param "0FE0"
    InsertActor  -Name  "Invisible Collectable" -X  548  -Y 3   -Z -158               -Param "0FE0"
    InsertActor  -Name  "Invisible Collectable" -X  364         -Z  28   -ZRot 2      -Param "0260"
    InsertActor  -Name  "Invisible Collectable" -X -747  -Y 165 -Z  951  -ZRot 1      -Param "1214"
    InsertActor  -Name  "Invisible Collectable" -X -698  -Y 166 -Z  830  -ZRot 1      -Param "1215"
    InsertActor  -Name  "Invisible Collectable" -X -677  -Y 166 -Z  899  -ZRot 1      -Param "1216"
    InsertActor  -Name  "Grotto Entrance"       -X -520  -Y 0   -Z  185  -ZRot 14     -Param "0000"
    InsertActor  -Name  "Grotto Entrance"       -X  55   -Y 0   -Z -460  -ZRot 16     -Param "0000"
    InsertActor  -Name  "Insect Group Spawner"  -X -490  -Y 68  -Z  185               -Param "5324" # Butterflies to indicate grotto entrance
    InsertActor  -Name  "Insect Group Spawner"  -X  55   -Y 68  -Z -430               -Param "5324" # Butterflies to indicate grotto entrance
    SaveLoadedMap

    PrepareMap   -Scene "Kokiri Forest" -Map 1 -Header 2 # Adult Cleansed - Deku Tree
    InsertObject -Name  "Deku Baba"
    InsertActor  -Name  "Withered Deku Baba" -X 2109 -Y -1   -Z -317  -Param "0001"
    InsertActor  -Name  "Withered Deku Baba" -X 2237 -Y -1   -Z -291  -Param "0001"
    InsertActor  -Name  "Withered Deku Baba" -X 2293 -Y -1   -Z -496  -Param "0001"
    InsertActor  -Name  "Withered Deku Baba" -X 3126 -Y -180 -Z -1555 -Param "0001"
    InsertActor  -Name  "Withered Deku Baba" -X 4129 -Y -170 -Z -548  -Param "0001"
    SaveAndPatchLoadedScene



    # LOST WOODS #

  # PrepareMap   -Scene "Lost Woods" -Map 1 -Header 0 -Shift # Child - Minigames Area
  # InsertSpawnPoint                              -X 1365 -Y -162 -Z  510  -YRot 0x8000 -Param "04FF"

    PrepareMap   -Scene "Lost Woods" -Map 1 -Header 1 -Shift # Adult - Minigames Area
  # InsertSpawnPoint                              -X 1365 -Y -162 -Z  510  -YRot 0x8000 -Param "04FF"
    InsertObject -Name  "Hint Deku Scrub"
    InsertObject -Name  "Minigame Points"
    InsertObject -Name  "Bullet Bags"
    InsertActor  -Name  "Skullkid"                -X 1123 -Y -140 -Z  340  -YRot 0x1DDE -Param "1BFF"
    ReplaceActor -Name  "Skullkid"                                      -Compare "FFFF" -Param "07FF"
    ReplaceActor -Name  "Skullkid"                                      -Compare "FFFF" -Param "0BFF"
    InsertActor  -Name  "Slingshot Deku Minigame" -X 1368 -Y  80  -Z -173               -Param "FFFF"
    InsertActor  -Name  "Invisible Collectable"   -X 1256 -Y -152 -Z  194  -ZRot 1      -Param "123F"
    InsertActor  -Name  "Invisible Collectable"   -X 1038 -Y -180 -Z  557  -ZRot 1      -Param "123F"
    InsertActor  -Name  "Invisible Collectable"   -X 1371 -Y -180 -Z  497  -ZRot 1      -Param "127F"
  # InsertActor  -Name  "Grotto Entrance"         -X 1365 -Y -162 -Z  560  -ZRot 16     -Param "0000"
  # InsertActor  -Name  "Insect Group Spawner"    -X 1355 -Y -114 -Z  525               -Param "5324" # Butterflies to indicate grotto entrance
    SaveLoadedMap

    PrepareMap   -Scene "Lost Woods" -Map 5 -Header 1 # Adult - Bridge Area
    InsertObject -Name  "Business Scrub"
    InsertActor  -Name  "Skulltula (Bean Spot)" -X -1220         -Z 935               -Param "4E01"
    InsertActor  -Name  "Grounded Sales Scrub"  -X -1137 -Y -200 -Z 2180 -YRot 0xC000 -Param "0009"
    SaveLoadedMap

    PrepareMap   -Scene "Lost Woods" -Map 6 -Header 1 # Adult - Tree Area
    InsertObject -Name  "Business Scrub"
    InsertActor  -Name  "Grounded Sales Scrub"  -X 663      -Z -1726 -YRot 0xED83
    InsertActor  -Name  "Grounded Sales Scrub"  -X 443      -Z -1357 -YRot 0x8000 -Param "0001"
    InsertActor  -Name  "Insect Group Spawner"  -X 77 -Y 28 -Z -1590              -Param "5324"
    ReplaceActor -Name  "Skullwalltula"                           -Compare "AE04" -Param "8E04"
    InsertActor  -Name  "Skulltula (Bean Spot)" -X 610      -Z -1770              -Param "4E02"
    SaveLoadedMap

    PrepareMap  -Scene "Lost Woods" -Map 9 -Header 1 # Adult - Lonely Guy Area
    InsertActor  -Name  "Skullkid" -X -951 -Y 20 -Z 52 -YRot 0xA000 -Param "17FF"
    ReplaceActor -Name  "Skullkid"                  -Compare "FFFF" -Param "03FF"
    SaveAndPatchLoadedScene



    # HYRULE FIELD #

    PrepareMap   -Scene "Hyrule Field" -Map 0 -Header 0 # Child
    ChangeExit   -Index 4 -Exit "0020"
    ChangeExit   -Index 8 -Exit "0020"
    
    PrepareMap   -Scene "Hyrule Field" -Map 0 -Header 1 # Child - Spirtual Stones
    ChangeExit   -Index 4 -Exit "0020"
    ChangeExit   -Index 8 -Exit "0020"
    
    PrepareMap   -Scene "Hyrule Field" -Map 0 -Header 2 # Adult
    ChangeExit   -Index 4 -Exit "0020"
    ChangeExit   -Index 8 -Exit "0020"
    InsertObject -Name  "Running Man"
    InsertObject -Name  "Drawbridge"
    RemoveObject -Name  "Broken Drawbridge"
    InsertActor  -Name  "Running Man" -X -5050 -Y -300 -Z 2800 -YRot 0x11C7 -Param   "0001"
    InsertActor  -Name  "Drawbridge"           -Y -10  -Z 670               -Param   "FFFF"
    RemoveActor  -Name  "Broken Drawbridge"                                 -Compare "0000"
    RemoveActor  -Name  "Broken Drawbridge"
    RemoveActor  -Name  "Broken Drawbridge"
    RemoveActor  -Name  "Broken Drawbridge"
  # RemoveActor  -Name  "Proximity Weather Effects" # Fix broken effects for entering Hyrule Castle
    SaveAndPatchLoadedScene



    # MARKET DAY #

    PrepareMap   -Scene "Market (Child - Day)" -Map 0 -Header 1 # Adult
    RemoveActor  -Name  "Market Townsfolk"   -Compare "0789" # Red Juggler
    RemoveActor  -Name  "Market Townsfolk"   -Compare "078A" # Blue Juggler
    RemoveActor  -Name  "Market Townsfolk"   -Compare "0785" # Beggar
    RemoveActor  -Name  "Market Townsfolk"   -Compare "0087" # Scientist
    RemoveActor  -Name  "Cucco-Chasing Girl" -Compare "0200"
    SaveAndPatchLoadedScene



    # KAKARIKO VILLAGE #
    
  # PrepareMap   -Scene "Kakariko Village" -Map 0 -Header 0 -Shift # Child - Day
  # InsertSpawnPoint                      -X  1386 -Y 395 -Z  1480              -YRot 0XC000 -Param "04FF"

  # PrepareMap   -Scene "Kakariko Village" -Map 0 -Header 1 # Child - Night
  # InsertSpawnPoint                      -X  1386 -Y 395 -Z  1480              -YRot 0XC000 -Param "04FF"

    PrepareMap   -Scene "Kakariko Village" -Map 0 -Header 2 -Shift # Adult - Day
  # InsertSpawnPoint                      -X  1386 -Y 395 -Z  1480              -YRot 0XC000 -Param "04FF"
    InsertObject -Name  "Soldier"
    InsertActor  -Name  "Cucco"           -X -1697 -Y 80  -Z  870               -YRot 0x127D -Param "FFFF"
    InsertActor  -Name  "Cucco"           -X  57   -Y 320 -Z -673               -YRot 0xD6C1 -Param "FFFF"
    InsertActor  -Name  "Cucco"           -X  796  -Y 80  -Z  1639              -YRot 0x4889 -Param "FFFF"
    InsertActor  -Name  "Cucco"           -X  1417 -Y 465 -Z  169                            -Param "FFFF"
    InsertActor  -Name  "Cucco"           -X -60          -Z -46                             -Param "0004"
    InsertActor  -Name  "Cucco"           -X -247  -Y 80  -Z  854               -YRot 0xDDDE -Param "0008"
    InsertActor  -Name  "Cucco"           -X  1079 -Y 80  -Z -47                -YRot 0x1F4A -Param "0008"
    InsertActor  -Name  "Large Crate"     -X -60          -Z -46   -XRot 0xFFFF -YRot 0x4000 -Param "FFFF"
    InsertActor  -Name  "Hyrule Guard"    -X -30   -Y 400 -Z -1298              -YRot 0xE39  -Param "FF05"
  # InsertActor  -Name  "Grotto Entrance" -X  1436 -Y 395 -Z  1480              -ZRot 14     -Param "0000"
    SaveLoadedMap

    PrepareMap   -Scene "Kakariko Village" -Map 0 -Header 3 # Adult - Night
  # InsertSpawnPoint                      -X  1386 -Y 395 -Z  1480              -YRot 0XC000 -Param "04FF"
    InsertObject -Name  "Soldier"
    InsertActor  -Name  "Skullwalltula"   -X -465  -Y 377 -Z -888               -YRot 0x6E39 -Param "B102"
    InsertActor  -Name  "Skullwalltula"   -X  5    -Y 686 -Z -171               -YRot 0x8000 -Param "B104"
    InsertActor  -Name  "Skullwalltula"   -X  525  -Y 295 -Z  1035 -XRot 0x4000 -YRot 0x4000 -Param "B108" # Moved on the wall of the finished Shooting Gallery
    InsertActor  -Name  "Skullwalltula"   -X -602  -Y 120 -Z  1120 -XRot 0x4000              -Param "B110"
    InsertActor  -Name  "Large Crate"     -X -60          -Z -46   -XRot 0xFFFF -YRot 0x4000 -Param "FFFF"
    InsertActor  -Name  "Hyrule Guard"    -X -30   -Y 400 -Z -1298              -YRot 0xE39  -Param "FF05"
    ReplaceActor -Name  "Greenery"                                              -ZRot 0x71   -Param "200A" -Compare "FF0A"
  # InsertActor  -Name  "Grotto Entrance" -X  1436 -Y 395 -Z  1480              -ZRot 14     -Param "0000"
    SaveAndPatchLoadedScene



    # DAMPÉ'S GRAVE & WINDMILL #

    PrepareMap   -Scene "Dampé's Grave & Windmill" -Map 5 -Header 0 # Stairs to Windmill
    RemoveActor  -Name "Time Block" -Compare "B806"
    ReplaceActor -Name "Time Block" -Compare "B805" -Y -469
    SaveLoadedMap

    PrepareMap   -Scene "Dampé's Grave & Windmill" -Map 6 -Header 0 # Windmill
    RemoveActor  -Name "Time Block" -Compare "B806"
    ReplaceActor -Name "Time Block" -Compare "B805" -Y -469
    SaveAndPatchLoadedScene 



    # GRAVEYARD #

    PrepareMap   -Scene "Graveyard" -Map 1 -Header 2 # Adult - Day
    InsertObject -Name  "Graveyard Boy"
    InsertObject -Name  "Skulltula"
    ReplaceActor -Name  "Bean Plant Spot"                                           -Param "0103" -Compare "0003" 
    InsertActor  -Name  "Graveyard Boy"         -X -474 -Y 61  -Z  447 -YRot 0x8000
    InsertActor  -Name  "Skulltula (Bean Spot)" -X -715 -Y 120 -Z -340              -Param "5101"
    RemoveActor  -Name  "Skullwalltula"                                                           -Compare "0000"
    RemoveActor  -Name  "Skullwalltula"                                                           -Compare "0000"
    RemoveActor  -Name  "Graveyard"                                                               -Compare "0001"
    SaveLoadedMap

    PrepareMap   -Scene "Graveyard" -Map 1 -Header 3 # Adult - Night
    InsertObject -Name  "Dampé"
    InsertObject -Name  "Skulltula"
    ReplaceActor -Name  "Bean Plant Spot"                                        -Compare "0003" -Param "0103"
    InsertActor  -Name  "Skulltula (Bean Spot)" -X -715 -Y 120 -Z -340                           -Param "5101"
    InsertActor  -Name  "Dampé"                 -X -476 -Y 61  -Z  434              -YRot 0x8000
    InsertActor  -Name  "Dampé's Minigame"      -X -473 -Y 60  -Z  202                           -Param "FFFF"
    InsertActor  -Name  "Dampé's Minigame"      -X -473 -Y 60  -Z  502                           -Param "FFFF"
    InsertActor  -Name  "Dampé's Minigame"      -X -409 -Y 120 -Z -234                           -Param "FFFF"
    InsertActor  -Name  "Dampé's Minigame"      -X -335 -Y 60  -Z  681                           -Param "FFFF"
    InsertActor  -Name  "Dampé's Minigame"      -X -177 -Y 120 -Z -231                           -Param "FFFF"
    InsertActor  -Name  "Dampé's Minigame"      -X  43  -Y 120 -Z -108                           -Param "FFFF"
    InsertActor  -Name  "Dampé's Minigame"      -X  48  -Y 120 -Z  222                           -Param "FFFF"
    InsertActor  -Name  "Dampé's Minigame"      -X  48  -Y 120 -Z  535                           -Param "FFFF"
    InsertActor  -Name  "Skullwalltula"         -X  156 -Y 315 -Z  795 -XRot 0x4000 -YRot 0x8000 -Param "B180"
    RemoveActor  -Name  "Skullwalltula"                                          -Compare "0000"
    RemoveActor  -Name  "Skullwalltula"                                          -Compare "0000"
    RemoveActor  -Name  "Graveyard"                                              -Compare "0001"
    SaveAndPatchLoadedScene



    # LON LON RANCH #

    PrepareMap       -Scene "Lon Lon Ranch" -Map 0 -Header 2 # Adult - Day
    ChangeSpawnPoint -Index 1                 -X  61   -Z -612  -YRot 0                 -Param "0DFF" # Epona's Song
    InsertObject     -Name  "Greenery"
    InsertObject     -Name  "Child Malon"
    InsertObject     -Name  "Skulltula"
    RemoveObject     -Name  "Rideable Brown Horse"
    InsertActor      -Name  "Greenery"        -X  1309 -Z -2241 -YRot 0xE38E -ZRot 0x6C -Param "0801" # Tree with Skulltula
    InsertActor      -Name  "Child Malon"     -X  64   -Z -567  -YRot 0x8000 -ZRot 3    -Param "FFFF"
    InsertActor      -Name  "Grotto Entrance" -X  1800 -Z  1500 -YRot 0xAAAB -ZRot 4    -Param "00FC"
    ReplaceActor     -Name  "Ingo's Gate"     -Y -50            -CompareY -40
    ReplaceActor     -Name  "Ingo's Gate"     -Y -50            -CompareY -40

    RemoveActor      -Name  "Rideable Horse" -Compare "FFFF"
    SaveLoadedMap

    PrepareMap   -Scene "Lon Lon Ranch" -Map 0 -Header 3 # Adult - Night
    InsertObject -Name  "Greenery"
    InsertActor  -Name  "Skullwalltula"   -X -2344 -Y 180 -Z  672  -XRot 0x4000 -YRot 0x599A -Param "8C01" # Cow Shed
    InsertActor  -Name  "Skullwalltula"   -X  808  -Y 48  -Z  326  -XRot 0x4000              -Param "8C02" # Corral
    InsertActor  -Name  "Skullwalltula"   -X  997  -Y 286 -Z -2698 -XRot 0x4000 -YRot 0xC000 -Param "8C04" # Talon's House
    InsertActor  -Name  "Greenery"        -X  1309        -Z -2241 -YRot 0xE38E -ZRot 0x6C   -Param "0801" # Tree with Skulltula
    InsertActor  -Name  "Grotto Entrance" -X  1800        -Z  1500 -YRot 0xAAAB -ZRot 4      -Param "00FC"
    ReplaceActor -Name  "Ingo's Gate"     -Y -50                   -CompareY -40
    ReplaceActor -Name  "Ingo's Gate"     -Y -50                   -CompareY -40
    SaveAndPatchLoadedScene



    # GUARD'S HOUSE

    PrepareMap -Scene "Guard's House" -Map 0 -Header 1 # Adult
    SetSceneSettings -WorldMap 0
    ChangeExit -Index 0 -Exit "0047"
    SaveAndPatchLoadedScene



    # DEATH MOUNTAIN TRAIL #

    PrepareMap  -Scene "Death Mountain Trail" -Map 0 -Header 1 # Adult
    InsertActor -Name  "Skulltula (Bean Spot)" -X -1610 -Y 677 -Z -735 -Param "5002"
    SaveAndPatchLoadedScene



    # DEATH MOUNTAIN CRATER #

    PrepareMap   -Scene "Death Mountain Crater" -Map 1 -Header 1 # Adult - Crater
    InsertObject -Name  "Large Crate"
    InsertObject -Name  "Skulltula"
    InsertActor  -Name  "Skulltula (Bean Spot)" -X -127 -Y 421  -Z -168                            -Param "5001"
    InsertActor  -Name  "Large Crate"           -X -950 -Y 1360 -Z  1892 -XRot 0xFFFF -YRot 0x160B -Param "7080"
    SaveAndPatchLoadedScene



    # GORON CITY #

    PrepareMap   -Scene "Goron City" -Map 0 -Header 1 # Adult - Rocks Area
    InsertObject -Name  "Skulltula"
    ReplaceActor -Name  "Large Crate" -Compare "FFFF" -Param "7040"
    SaveLoadedMap

    PrepareMap   -Scene "Goron City" -Map 0 -Header 2 # Adult Cleansed - Rocks Area
    InsertObject -Name  "Skulltula"
    ReplaceActor -Name  "Large Crate" -Compare "FFFF" -Param "7040"
    SaveLoadedMap

    PrepareMap   -Scene "Goron City" -Map 3 -Header 1 # Adult - City
    InsertActor  -Name  "Big Goron Pot" -X  3   -Y -3   -Z  20  -Param "1C1F"
    InsertActor  -Name  "Time Block"                            -Param "B819" -Compare "3819"
    InsertActor  -Name  "Time Block"            -Y  410 -Z -930 -Param "B81A" -Compare "381A"
    SaveLoadedMap

    PrepareMap   -Scene "Goron City" -Map 3 -Header 2 # Adult Cleansed - City
    RemoveActor  -Name  "Sliding Doors Goron City"              -Compare "00FF"
    RemoveActor  -Name  "Sliding Doors Goron City"              -Compare "0100"
    RemoveActor  -Name  "Goron"                                 -Compare "1C01"
    InsertActor  -Name  "Big Goron Pot" -X  3   -Y -3   -Z  20                  -Param "1C1F"
    InsertActor  -Name  "Time Block"                            -Compare "3819" -Param "B819" 
    InsertActor  -Name  "Time Block"            -Y  410 -Z -930 -Compare "381A" -Param "B81A" 
    InsertActor  -Name  "Goron"         -X  520 -Y  399 -Z  565 -YRot 0xCD83    -Param "FC00"
    SaveAndPatchLoadedScene



    # ZORA'S RIVER #

    PrepareMap   -Scene "Zora's River" -Map 0 -Header 1 # Adult - River Road
    ReplaceObject -Name  "Octorok" -New "Cucco"
    InsertObject  -Name  "Octorok"
    InsertObject  -Name  "Bean Seller"
    InsertObject  -Name  "Greenery"
    InsertObject  -Name  "Frog"
    InsertActor   -Name  "Cucco"       -X -1634 -Y 100 -Z -131  -YRot 0x1DDE            -Param "000B"
    InsertActor   -Name  "Cucco"       -X  483  -Y 570 -Z -240  -YRot 0x6666            -Param "000C"
    InsertActor   -Name  "Bean Seller" -X -717  -Y 100 -Z -312  -YRot 0xC000            -Param "FFFF"
    InsertActor   -Name  "Greenery"    -X -1690 -Y 100 -Z  554  -YRot 0x1555 -ZRot 0x72 -Param "0201" # Tree with Skulltula
    InsertActor   -Name  "Frog"        -X  990  -Y 205 -Z -1220 -YRot 0x1555
    InsertActor   -Name  "Frog"        -X  1093 -Y 205 -Z -1069 -YRot 0x98E4            -Param "0001"
    InsertActor   -Name  "Frog"        -X  1082 -Y 199 -Z -1028 -YRot 0x91C7            -Param "0003"
    InsertActor   -Name  "Frog"        -X  1169 -Y 226 -Z -1021 -YRot 0xA222            -Param "0004"
    InsertActor   -Name  "Frog"        -X  1098 -Y 194 -Z -1110 -YRot 0xA38E            -Param "0002"
    InsertActor   -Name  "Dialog Spot" -X  1000 -Y 205 -Z -1202 -YRot 0x960B            -Param "4BBB"
    InsertActor   -Name  "Frog"        -X  1122 -Y 230 -Z -980  -YRot 0x8E39            -Param "0005"
    SaveLoadedMap

    PrepareMap    -Scene "Zora's River" -Map 1 -Header 1 # Adult - Zora's Domain Entrance
    InsertObject  -Name  "Cucco"
    InsertActor   -Name  "Skullwalltula" -X 3727 -Y 647 -Z (-1609) -XRot 0x4000 -YRot 0xA000 -Param "B201"
    SaveAndPatchLoadedScene



    # ZORA'S FOUNTAIN #

    PrepareMap   -Scene "Zora's Fountain" -Map 0 -Header 0 # Child - Day
    RemoveActor  -Name  "Ice Platform" -Compare "0214" # Ice Ramp
    SaveLoadedMap
    
    PrepareMap   -Scene "Zora's Fountain" -Map 0 -Header 1 # Child - Night
    RemoveActor  -Name  "Ice Platform" -Compare "0214" # Ice Ramp
    SaveLoadedMap

    PrepareMap   -Scene "Zora's Fountain" -Map 0 -Header 2 # Adult
    InsertObject -Name  "Jabu-Jabu"
    InsertObject -Name  "Greenery"
    RemoveActor  -Name  "Ice Platform"                                                                                 -Compare "0214" # Ice Ramp
    ReplaceActor -Name  "Ice Platform"   -X  550  -Y 30  -Z -600                                        -CompareX  599 -Compare "0023" # Twin Ice Platforms
    ReplaceActor -Name  "Collectable"    -X  950  -Y 40  -Z -600                                                       -Compare "0106" # Piece of Heart
    ReplaceActor -Name  "Ice Platform"   -X  950  -Y 30  -Z -600                                        -CompareX  974 -Compare "0011" # Heart Piece Ice Platform
  # ReplaceActor -Name  "Ice Platform"   -X  320  -Y 30  -Z  95                           -Param "0011" -CompareX -185 -Compare "0001" # Big Ice Platform -> Medium Second Ice Platform
  # ReplaceActor -Name  "Ice Platform"   -X  240  -Y 5   -Z  475                          -Param "0010" -CompareX -649 -Compare "0020" # Small Ice Platform -> Medium Starting Ice Platform
    ReplaceActor -Name  "Ice Platform"   -X  140  -Y 5   -Z -275                          -Param "0010" -CompareX -649 -Compare "0020" # Small Ice Platform -> Medium Starting Ice Platform
  # ReplaceActor -Name  "Ice Platform"   -X  280  -Y 30                                                 -CompareX  255 -Compare "0010" # Fork Ice Platform
    ReplaceActor -Name  "Ice Platform"            -Y 30                                                 -CompareY  20                  # Raise remaining Ice Platforms
    ReplaceActor -Name  "Ice Platform"            -Y 30                                                 -CompareY  20
    ReplaceActor -Name  "Ice Platform"            -Y 30                                                 -CompareY  20
    ReplaceActor -Name  "Ice Platform"            -Y 30                                                 -CompareY  20
    ReplaceActor -Name  "Octorok"        -X  980         -Z -375                                        -CompareX  912
    ReplaceActor -Name  "Octorok"        -X  120         -Z  870                                        -CompareX  392
    ReplaceActor -Name  "Octorok"        -X -550         -Z -825                                        -CompareX -473
    InsertActor  -Name  "Jabu-Jabu"      -X -1445 -Y 20  -Z -48   -YRot 0xC000            -Param "FFFF"
    InsertActor  -Name  "Skullwalltula"  -X -1891 -Y 187 -Z  1911 -YRot 0x4666            -Param "B204"
    InsertActor  -Name  "Greenery"       -X  551  -Y 35  -Z  2184                         -Param "FF0B"
    InsertActor  -Name  "Greenery"       -X  386  -Y 43  -Z  2265                         -Param "FF0B"
    InsertActor  -Name  "Greenery"       -X  544  -Y 45  -Z  2373                         -Param "FF0B"
    InsertActor  -Name  "Greenery"       -X  231  -Y 52  -Z  2406                         -Param "FF0B"
    InsertActor  -Name  "Greenery"       -X  394  -Y 55  -Z  2510                         -Param "FF0B"
    InsertActor  -Name  "Greenery"       -X  167  -Y 56  -Z  2514                         -Param "FF0B"
    InsertActor  -Name  "Greenery"       -X  186  -Y 44  -Z  2222 -YRot 0x2000 -ZRot 0x72 -Param "8001"                                # Tree with Skulltula
    RemoveActor  -Name  "Ice Platform"                                                                  -CompareX -185
    RemoveActor  -Name  "Ice Platform"                                                                  -CompareX  255
    SaveAndPatchLoadedScene



    # LAKE HYLIA #

    PrepareMap   -Scene "Lake Hylia" -Map 0 -Header 0 # Child
    ChangeExit -Index 0 -Exit "0024"
    PrepareMap   -Scene "Lake Hylia" -Map 0 -Header 1 # Adult
    ChangeExit -Index 0 -Exit "0024"

    InsertActor  -Name  "Skulltula (Bean Spot)" -X -2602 -Y -1033 -Z 3617              -Param "5301"
    InsertActor  -Name  "Skullwalltula"         -X  822  -Y -1254 -Z 7188 -XRot 0x4000 -Param "B302"
    InsertActor  -Name  "Skullwalltula"         -X -2873 -Y -938  -Z 4019 -XRot 0x5555 -Param "B304"
    SaveAndPatchLoadedScene



    # GERUDO VALLEY #

    PrepareMap   -Scene "Gerudo Valley" -Map 0 -Header 0 # Child
    ChangeExit   -Index 3 -Exit "0014" # Change exit to Road to Gerudo's Fortress

    PrepareMap   -Scene "Gerudo Valley" -Map 0 -Header 1 # Adult
    ChangeExit   -Index 3 -Exit "0014" # Change exit to Road to Gerudo's Fortress
    InsertObject -Name  "Cucco"
    InsertActor  -Name  "Skulltula (Bean Spot)" -X -515  -Y -2051 -Z  110                           -Param "5401"
    InsertActor  -Name  "Skullwalltula"         -X  1707 -Y  95   -Z -227 -XRot 0x47D2 -YRot 0xE71C -Param "B402"
    InsertActor  -Name  "Large Crate"           -X -449  -Y -2051 -Z  123                           -Param "FFFF"
    InsertActor  -Name  "Cucco"                 -X  773  -Y  34   -Z -36                            -Param "0008"
    SaveAndPatchLoadedScene



    # GERUDO'S FORTRESS #

    PrepareMap   -Scene "Gerudo's Fortress" -Map 0 -Header 0 # Child
    ChangeExit   -Index 0 -Exit "0018" # Change exit to Road to Gerudo's Fortress
    PrepareMap   -Scene "Gerudo's Fortress" -Map 0 -Header 1 # Adult - Day
    ChangeExit   -Index 0 -Exit "0018" # Change exit to Road to Gerudo's Fortress
    PrepareMap   -Scene "Gerudo's Fortress" -Map 0 -Header 2 # Adult - Night
    ChangeExit   -Index 0 -Exit "0018" # Change exit to Road to Gerudo's Fortress
    SaveAndPatchLoadedScene



    # DESERT COLOSSUS #

    PrepareMap   -Scene "Desert Colossus" -Map 0 -Header 1 # Adult
    InsertObject -Name  "Kaepora Gaebora"
    InsertActor  -Name  "Kaepora Gaebora"       -X -1456 -Y 811 -Z 425 -Param "029F"
    InsertActor  -Name  "Skulltula (Bean Spot)" -X -1330 -Y 8   -Z 290 -Param "5601"
    SaveAndPatchLoadedScene



    # THIEVES' HIDEOUT #

    PrepareMap   -Scene "Thieves' Hideout" -Map 0 -Header 0 # Break Room - Hookshot Beams
    ReplaceActor -Name "Patrolling Gerudo" -Y -160 -Compare "0800" # Fix guard falling from the ceiling
    SaveAndPatchLoadedScene



    # GANON'S CASTLE EXTERIOR #

    PrepareMap -Scene "Ganon's Castle Exterior" -Map 0 -Header 0 # Change exit to Road to Gerudo's Fortress
    ChangeExit -Index 0 -Exit "001C"
  # SetMapSettings -Time 0xFFFF -TimeSpeed 10
    SaveLoadedMap

    PrepareMap -Scene "Ganon's Castle Exterior" -Map 0 -Header 1 # Change exit to Road to Gerudo's Fortress
    ChangeExit -Index 0 -Exit "001C"
  # SetMapSettings -Time 0xFFFF -TimeSpeed 10
    SaveAndPatchLoadedScene



    # DODONGO'S CAVERN #

    if ($DungeonList["Dodongo's Cavern"] -eq "Master Quest" -or $DungeonList["Dodongo's Cavern"] -eq "Ura Quest") {
        PrepareMap    -Scene "Dodongo's Cavern" -Map 8 -Header 0 # Labyrinth
        ReplaceObject -Name "Inside Ganon's Castle" -NewID "0045"
        SaveLoadedMap
    }



    # INSIDE JABU-JABU'S BELLY #

    if ($DungeonList["Inside Jabu-Jabu's Belly"] -eq "Master Quest") {
        PrepareMap   -Scene "Inside Jabu-Jabu's Belly" -Map 5 -Header 0 # Boos Door Room
        InsertObject -Name "Tunics" # Fix Like-Like not giving back the tunics
        SaveLoadedMap

        PrepareMap   -Scene "Inside Jabu-Jabu's Belly" -Map 11 -Header 0 # Right Fork Tentacle
        InsertObject -Name "Tunics" # Fix Like-Like not giving back the tunics
        SaveLoadedMap

        PrepareMap   -Scene "Inside Jabu-Jabu's Belly" -Map 14 -Header 0 # Boomerang Hall
        InsertObject -Name "Tunics" # Fix Like-Like not giving back the tunics
        SaveAndPatchLoadedScene
    }



    # FOREST TEMPLE #

    if ($DungeonList["Forest Temple"] -eq "Vanilla") {
        PrepareMap   -Scene "Forest Temple" -Map 2 -Header 0 # Elevator Hall
        ReplaceActor -Name "Time Block" -Compare "B819" -Param "3819" # Invert time block
        SaveLoadedMap

        PrepareMap   -Scene "Forest Temple" -Map 11 -Header 0 # Tall Block Pushing Hall
        InsertObject -ID   "0045"                                                                  # Clear Block
        ReplaceActor -Name "Pushable Block" -X -1787         -Z -1140 -Compare "0702"              # Reposition upper push block
        InsertActor  -Name "Clear Block"    -X -2027 -Y 893  -Z -1140 -Param   "FF01" -ZRot 0xC000 # Prevent jumping down from upper to lower push block (possible softlock)
        InsertActor  -Name "Clear Block"    -X -1450 -Y 850  -Z -1330 -Param   "0701"              # Add clear blocks for climbing up top (0x05 and 0x07 push block switches)
        InsertActor  -Name "Clear Block"    -X -1450 -Y 925  -Z -1505 -Param   "0501"
        InsertActor  -Name "Clear Block"    -X -1450 -Y 1000 -Z -1330 -Param   "0701"
        SaveAndPatchLoadedScene
    }

    elseif ($DungeonList["Forest Temple"] -eq "Master Quest" -or $DungeonList["Forest Temple"] -eq "Ura Quest") {
        PrepareMap   -Scene "Forest Temple" -Map 4 -Header 0 # North Elevator Hallway
        ReplaceActor -Name "Time Block" -Compare "B820" -Param "3820" # Invert time block
        SaveLoadedMap

        PrepareMap   -Scene "Forest Temple" -Map 6 -Header 0 # Stalfos Mini-Boss Room
        ReplaceActor -Name "Time Block" -Compare "B820" -Param "3820" # Invert time block
        SaveLoadedMap

        PrepareMap   -Scene "Forest Temple" -Map 7 -Header 0 # East Courtyard
        RemoveActor  -Name "Time Block" -Compare "2822"               # Remove time block near vines, as Child can't reach it
        ReplaceActor -Name "Time Block" -Compare "A823" -Param "2823" # Invert remaining time blocks
        ReplaceActor -Name "Time Block" -Compare "3924" -Param "B924"
        ReplaceActor -Name "Time Block" -Compare "B927" -Param "3927"
        ReplaceActor -Name "Time Block" -Compare "B928" -Param "3928"
        ReplaceActor -Name "Time Block" -Compare "2829" -Param "A829"
        SaveAndPatchLoadedScene

        PrepareMap    -Scene "Forest Temple" -Map 11 -Header 0 # Tall Block Pushing Hall
        ReplaceObject -Name "Inside Ganon's Castle" -NewID "0045"
        SaveLoadedMap

        PrepareMap    -Scene "Forest Temple" -Map 14 -Header 0 # Rotating Platforms Hall
        ReplaceObject -Name "Inside Ganon's Castle" -NewID "0045"
        SaveLoadedMap
    }



    # FIRE TEMPLE #

    if ($DungeonList["Fire Temple"] -eq "Vanilla") {
        PrepareMap   -Scene "Fire Temple" -Map 1 -Header 0 -Shift # Lava Cavern
        ReplaceActor -Name "Navi Block Info Spot" -X 1639 -Y 70          -Compare "3820" -CompareX 1560 -CompareY 100 # Reposition time block to access upper left room
        InsertActor  -Name "Torch"                -X 1649 -Y 200 -Z 1419 -Param   "1400"                              # Reach room to the right
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 2 -Header 0 # Boss Door Hall
        InsertObject -ID   "0045"                                                                      # Clear Block
        InsertActor  -Name "Stone Hookshot Target" -X -882  -Y -50  -Z  220 -Param "FF00"              # Hookshot targets to get out near the entrance
        InsertActor  -Name "Stone Hookshot Target" -X -735  -Y  40  -Z  145 -Param "FF00" -YRot 0x2600
        InsertActor  -Name "Stone Hookshot Target" -X -1060 -Y -130 -Z -40  -Param "FF00"              # Hookshot target to prevent being stuck in the center
        InsertActor  -Name "Clear Block"           -X -1208 -Y  200 -Z  0   -Param "0E01"              # Clear blocks for reaching the boss door (0x0E Stone Spike Platform switch)
        InsertActor  -Name "Clear Block"           -X -840  -Y  200 -Z  0   -Param "0E01"
        InsertActor  -Name "Stone Hookshot Target" -X -1238 -Y  300 -Z -725 -Param "FF00"              # Hookshot target for reaching the pots
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 4 -Header 0 # Fire Slug Room
        InsertObject -Name "Hookshot Pillar & Wall Target"
        InsertActor  -Name "Torch"                 -X 2518 -Y 2260 -Z 698 -Param "1400" # Reach Torch Slug places
        InsertActor  -Name "Stone Hookshot Target" -X 2181 -Y 2321 -Z 274 -Param "FF02" # Reach push block
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 10 -Header 0 # Invisible Fire Wall Maze
        InsertActor  -Name "Stone Hookshot Target" -X -1238 -Y 2660 -Z -17 -Param "FF00" # Prevent being stuck
        InsertActor  -Name "Stone Hookshot Target" -X -1240 -Y 2740 -Z  60 -Param "1001" # Prevent not being able to climb platform (0x11 Stone Spike Platform switch)
        InsertActor  -Name "Stone Hookshot Target" -X -1240 -Y 2740 -Z -60 -Param "1001" # Prevent not being able to climb platform (0x11 Stone Spike Platform switch)
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 11 -Header 0 # Passthrough - Invisible Fire Wall Maze
        InsertActor  -Name "Stone Hookshot Target" -X -1700 -Y 2740 -Z 280 -Param   "FF00"                 # Hookshot target and repositioned Time Block
        ReplaceActor -Name "Navi Block Info Spot"  -X -1780                -Compare "3021" -CompareX -1730 
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 14 -Header 0 # Hidden Stairs Room
        ReplaceActor -Name "Switch" -Compare "3D20" -Param "3D01" # Replace temporary switch with a rusty one
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 16 -Header 0 # Flaming Wall of Death Room
        InsertObject -Name "Hookshot Pillar & Wall Target"
        InsertActor  -Name "Stone Hookshot Target" -X 1446 -Y 3040 -Z -549 -Param "FF02" -YRot 0xBF68 # Hookshot targets for reaching the upper Boulder Maze area and the Fire Wall Maze respectively
        InsertActor  -Name "Stone Hookshot Target" -X 354  -Y 3039 -Z  110 -Param "FF02" -YRot 0x4000
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 18 -Header 0 # Tile Room - Entrance
        InsertObject -Name "Deku Shield" # Fix Like-Like not giving the Deku Shield back
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 19 -Header 0 # Tile Room - Lava Cavern
        InsertObject -Name "Deku Shield" # Fix Like-Like not giving the Deku Shield back
        SaveAndPatchLoadedScene
    }

    elseif ($DungeonList["Fire Temple"] -eq "Master Quest" -or $DungeonList["Fire Temple"] -eq "Ura Quest") {
        PrepareMap   -Scene "Fire Temple" -Map 0 -Header 0 # Entrance
        # Move torches slightly upwards to make reaching them less painful
        ReplaceActor -Name "Torch" -Y 170 -CompareY 160
        ReplaceActor -Name "Torch" -Y 170 -CompareY 160
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 2 -Header 0 # Boss Door Hall
        RemoveObject -Name "Time Block"                                                                # Remove unused objects and actors
        RemoveObject -Name "Time Block Disappearance Effect"
        RemoveObject -Name "Skulltula"
        RemoveObject -Name "Gold Skulltula Token"
        InsertObject -ID   "0045"                                                                      # Clear Block
        InsertActor  -Name "Stone Hookshot Target" -X -882  -Y -50  -Z  220 -Param "FF00"              # Hookshot targets to get out near the entrance
        InsertActor  -Name "Stone Hookshot Target" -X -735  -Y  40  -Z  145 -Param "FF00" -YRot 0x2600
        InsertActor  -Name "Stone Hookshot Target" -X -1060 -Y -130 -Z -40  -Param "FF00"              # Hookshot target to prevent being stuck in the center
        InsertActor  -Name "Clear Block"           -X -1208 -Y 200  -Z  0   -Param "0E01"              # Clear blocks for reaching the boss door (0x0E Stone Spike Platform switch)
        InsertActor  -Name "Clear Block"           -X -840  -Y 200  -Z  0   -Param "0E01"
        InsertActor  -Name "Stone Hookshot Target" -X -1239 -Y 240  -Z -659 -Param "FF00"              # Hookshot target for reaching highest ground
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 4 -Header 0 # Fire Slug Room
        InsertActor  -Name "Torch" -X 2518 -Y 2260 -Z 698 -Param "1400" # Reach upper area
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 10 -Header 0 # Invisible Fire Wall Maze
        InsertActor  -Name "Stone Hookshot Target" -X -1238 -Y 2660 -Z -17  -Param "FF00"              # Prevent being stuck
        InsertActor  -Name "Time Block"            -X -924  -Y 2800 -Z -670 -Param "19FF" -YRot 0x2000 # Add time block to be able to cross the fire walls from the other side
    if ($DungeonList["Fire Temple"] -eq "Master Quest") {
        ReplaceActor -Name "Time Block"                     -Compare "9837" -Param "1837"              # Invert time blocks
        ReplaceActor -Name "Navi Block Info Spot"           -Compare "1836" -Param "9836"
        ReplaceActor -Name "Navi Block Info Spot"           -Compare "9836" -Param "1836"
    }
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 13 -Header 0 # West Tower
        RemoveObject -Name "Pierre & Bonooru"
        InsertActor  -Name "Stone Hookshot Target"      -X -2488 -Y 4680 -Z 227 -Param   "3CC1" # Extra hookshot target on the east side
        InsertActor  -Name "Stone Hookshot Target"      -X -1800 -Y 4620 -Z 600 -Param   "3CC1"
        RemoveActor  -Name "Pierre the Scarecrow Spawn"                         -Compare "18FF" # Remove Scarecrow
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 14 -Header 0 # Hidden Stairs Room
        InsertActor  -Name "Torch" -X -1970 -Y 4180 -Z -808 -Param "2400" -YRot 0xE000 # Restore torches
        InsertActor  -Name "Torch" -X -1800 -Y 4180 -Z -978 -Param "2400" -YRot 0xE000
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 16 -Header 0 # Flaming Wall of Death Room
        InsertActor  -Name "Stone Hookshot Target" -X 1446 -Y 3040 -Z -549 -Param "FF02" -YRot 0xBF68 # Hookshot targets for reaching the upper Boulder Maze area and the Fire Wall Maze respectively
        InsertActor  -Name "Stone Hookshot Target" -X 354  -Y 3039 -Z  110 -Param "FF02" -YRot 0x4000
        InsertActor  -Name "Stone Hookshot Target" -X 1237 -Y 3019 -Z  149 -Param "FF02" -YRot 0xE09C # Hookshot target for reaching crates
        SaveLoadedMap

        PrepareMap   -Scene "Fire Temple" -Map 17 -Header 0 # Captured Goron North of Entrance
        InsertObject -Name "Deku Shield"   # Fix Like-Like not dropping shields
        InsertObject -Name "Hylian Shield"
        SaveAndPatchLoadedScene
    }



    # ICE CAVERN #

    if ($DungeonList["Ice Cavern"] -eq "Master Quest" -or $DungeonList["Ice Cavern"] -eq "Ura Quest") {
        PrepareMap   -Scene "Ice Cavern" -Map 1 -Header 0 # Open Room #1
        ReplaceObject -Name "Inside Ganon's Castle" -NewID "0045"
        SaveLoadedMap
    }

    if ($DungeonList["Ice Cavern"] -eq "Vanilla") {
        PrepareMap   -Scene "Ice Cavern" -Map 3 -Header 0 # Second Open Room
        InsertObject -ID   "0045"                                                                    # Clear Block
        InsertObject -Name "Hookshot Pillar & Wall Target"
        InsertActor  -Name "Stone Hookshot Target" -X 600 -Y -60  -Z -570 -Param "FF00" -YRot 0x1000 # Hookshot target and a clear block for climbing up
        InsertActor  -Name "Clear Block"           -X 415 -Y  164 -Z -570 -Param "FF01" -YRot 0x2000
        SaveAndPatchLoadedScene
    }
    elseif ($DungeonList["Ice Cavern"] -eq "Master Quest" -or $DungeonList["Ice Cavern"] -eq "Ura Quest") {
        PrepareMap   -Scene "Ice Cavern" -Map 3 -Header 0 # Second Open Room
        InsertObject -Name "Hookshot Pillar & Wall Target"
        InsertActor  -Name "Stone Hookshot Target" -X 533 -Y 331 -Z -687 -Param "FF02" -YRot 0xDEA8 # Hookshot target for upper area
        SaveLoadedMap

        PrepareMap   -Scene "Ice Cavern" -Map 5 -Header 0 # Ice Block Puzzle Room
        ReplaceObject -Name "Inside Ganon's Castle" -NewID "0045"
        ReplaceActor -Name "Clear Block" -Y 0                   -CompareX -1465 -CompareY 50  -CompareZ -250               # Prevent getting stuck inside the clear blocks
        ReplaceActor -Name "Clear Block" -Y 0                   -CompareX -1364 -CompareY 50  -CompareZ -250
        ReplaceActor -Name "Clear Block" -Y 50          -Z -220 -CompareX -1394 -CompareY 100 -CompareZ -250 -XRot 0x4000
        InsertActor  -Name "Clear Block" -X -1394 -Y 50 -Z -200 -XRot 0x4000 -Param "2601" 
        SaveAndPatchLoadedScene

        PrepareMap   -Scene "Ice Cavern" -Map 9 -Header 0 # Pillars Room
        ReplaceObject -Name "Inside Ganon's Castle" -NewID "0045"
        SaveLoadedMap
    }



    # WATER TEMPLE #

    PrepareMap -Scene "Water Temple" -Map 0 -Header 0 # Central Hall
    if ($DungeonList["Water Temple"] -eq "Master Quest" -or $DungeonList["Water Temple"] -eq "Ura Quest") {
        InsertActor -Name "Stone Hookshot Target" -X 360 -Y 439 -Z -182 -Param "FF00" -ZRot 0x4000 # Make it possible to jump over with a crate
    }
    SaveLoadedMap

    PrepareMap  -Scene "Water Temple" -Map 1 -Header 0 # Central Pillar
    InsertActor -Name "Stone Hookshot Target" -X -178 -Y 30 -Z -320 -Param "FF00" -XRot 0x3E80 -YRot 0xBF68 # Be able to get out of the spikes
    InsertActor -Name "Stone Hookshot Target" -X -181 -Y 30 -Z -320 -Param "FF00" -XRot 0x3E80 -YRot 0x4047
    SaveLoadedMap

    PrepareMap -Scene "Water Temple" -Map 2 -Header 0 # Flooded Basement
    if ($DungeonList["Water Temple"] -eq "Master Quest" -or $DungeonList["Water Temple"] -eq "Ura Quest") {
        ReplaceActor -Name "Metal Gate" -Compare "1FF9" -Param "0FF9" # Prevent clipping through the metal gates
        ReplaceActor -Name "Metal Gate" -Compare "1FFA" -Param "0FFA"
    }
    SaveLoadedMap

    PrepareMap -Scene "Water Temple" -Map 6 -Header 0 # Dragon Statues Room
    if ($DungeonList["Water Temple"] -eq "Vanilla") {
        InsertObject -Name "Deku Shield" # Fix Like-Like not giving the Deku Shield back
    }
    elseif ($DungeonList["Water Temple"] -eq "Master Quest" -or $DungeonList["Water Temple"] -eq "Ura Quest") {
        ReplaceActor -Name "Water Temple Plane" -CompareY 593 -Y 573 # Lower water
    }
    SaveLoadedMap

    if ($DungeonList["Water Temple"] -eq "Vanilla") {
        PrepareMap   -Scene "Water Temple" -Map 7 -Header 0 # Longshot Room
        ReplaceActor -Name "Time Block" -Compare "B80C" -Param "380C" # Invert time block
        SaveLoadedMap
    }

    PrepareMap  -Scene "Water Temple" -Map 12 -Header 0 # Rolling Boulder Room
    InsertActor -Name "Stone Hookshot Target" -X -881 -Y 240 -Z -2351 -Param "FF02" -XRot 0x4000 # Hookshot target to be able to get out of the upper water area
    SaveAndPatchLoadedScene



    # SHADOW TEMPLE #

    if ($DungeonList["Shadow Temple"] -eq "Master Quest" -or $DungeonList["Shadow Temple"] -eq "Ura Quest") {
        PrepareMap   -Scene "Shadow Temple" -Map 0 -Header 0 # Entrance
        ReplaceObject -Name "Inside Ganon's Castle" -NewID "0045"
        SaveLoadedMap

        PrepareMap   -Scene "Shadow Temple" -Map 2 -Header 0 # Room of Illusion
        ReplaceObject -Name "Inside Ganon's Castle" -NewID "0045"
        SaveLoadedMap
    }

    PrepareMap   -Scene "Shadow Temple" -Map 6 -Header 0 # Scythe Shortcut Room
    ReplaceActor -Name "Spinning Scythe Trap" -CompareY -543 -Y -563 # Lower scythe trap
    SaveLoadedMap

    if ($DungeonList["Shadow Temple"] -eq "Master Quest" -or $DungeonList["Shadow Temple"] -eq "Ura Quest") {
        PrepareMap   -Scene "Shadow Temple" -Map 9 -Header 0 # Guillotine Cave
        ReplaceObject -Name "Inside Ganon's Castle" -NewID "0045"
        SaveLoadedMap
    }

    PrepareMap   -Scene "Shadow Temple" -Map 10 -Header 0 # Falling Spike Blocks Trap Room
    InsertObject -Name "Hookshot Pillar & Wall Target" # Hookshot target to get onto the push block
    InsertActor  -Name "Stone Hookshot Target" -X 275 -Y -1395 -Z 3735  -Param "FF00"
    SaveLoadedMap

    if ($DungeonList["Shadow Temple"] -eq "Master Quest" -or $DungeonList["Shadow Temple"] -eq "Ura Quest") {
        PrepareMap   -Scene "Shadow Temple" -Map 11 -Header 0 # Invisible Spike Room
        ReplaceObject -Name "Inside Ganon's Castle" -NewID "0045"
        SaveLoadedMap
    }

    PrepareMap   -Scene "Shadow Temple" -Map 16 -Header 0 # Invisible Scythe Room
    ReplaceActor -Name "Collectable"          -Y -1058 -CompareY -1028 -Compare "2003" # Invert time blocks, lower them and nearby collectables
    ReplaceActor -Name "Collectable"          -Y -1058 -CompareY -1028 -Compare "2103"  
    ReplaceActor -Name "Time Block"           -Y -1173 -CompareY -1143 -Compare "380A" -Param "B80A"
    if ($DungeonList["Shadow Temple"] -eq "Master Quest" -or $DungeonList["Shadow Temple"] -eq "Ura Quest") {
        ReplaceActor -Name "Time Block"       -Y -1173 -CompareY -1143 -Compare "3812" -Param "B812"
        ReplaceActor -Name "Silver Rupee"     -Y -1073 -CompareY -1043 -Compare "1FC3"  
    }
    ReplaceActor -Name "Spinning Scythe Trap" -Y -1183 -CompareY -1143 # Lower scythe trap
    SaveLoadedMap

    PrepareMap    -Scene "Shadow Temple" -Map 21 -Header 0 # River of Death
    InsertActor   -Name "Stone Hookshot Target" -X  4520 -Y -1410 -Z -1506 -Param "FF00"                                 # Reach ladder
    InsertActor   -Name "Time Block"            -X -2465 -Y -1423 -Z -804  -Param "B8FF" -ZRot 0x0002                    # Insert time block to be able to backtrack
    if ($DungeonList["Shadow Temple"] -eq "Vanilla" -or $DungeonList["Shadow Temple"] -eq "Ura Quest") {
        ReplaceActor  -Name "Time Block"                 -Y -1393          -Param "B80C" -CompareY -1363 -Compare "380C" # Invert existing time block and lower it
	}
    SaveAndPatchLoadedScene



    # GERUDO TRAINING GROUND #

    if ($DungeonList["Gerudo Training Ground"] -eq "Vanilla") {
        PrepareMap   -Scene "Gerudo Training Ground" -Map 6 -Header 0 # Lava Challenge
        ReplaceActor -Name "Time Block" -Compare "382C" -Param "B82C" # Invert time blocks
        ReplaceActor -Name "Time Block" -Compare "382D" -Param "B82D"
        SaveLoadedMap

        PrepareMap   -Scene "Gerudo Training Ground" -Map 10 -Header 0 # Preview Room
        InsertObject -Name "Deku Shield" # Fix Like-Like not giving the Deku Shield back
        SaveAndPatchLoadedScene
    }
    elseif ($DungeonList["Gerudo Training Ground"] -eq "Master Quest" -or $DungeonList["Gerudo Training Ground"] -eq "Ura Quest") {
        if ($DungeonList["Gerudo Training Ground"] -eq "Ura Quest") {
            PrepareMap   -Scene "Gerudo Training Ground" -Map 6 -Header 0 # Lava Challenge
            ReplaceActor -Name "Time Block"   -Y -263 -Param "B82D" -Compare "382D"                -CompareY -293                 # Invert time block, increase YPos of the time block and the silver rupee for reaching the small key
            ReplaceActor -Name "Silver Rupee" -Y -155               -Compare "1FCC" -CompareX 1330 -CompareY -185 -CompareZ -1486 
            SaveLoadedMap
        }

        PrepareMap   -Scene "Gerudo Training Ground" -Map 3 -Header 0 # Fake Room
        ReplaceActor -Name "Time Block" -Compare "38FF" -CompareY 159 -Y 129 # Lower time block
        SaveAndPatchLoadedScene
    }



    # SPIRIT TEMPLE #

    if ($DungeonList["Spirit Temple"] -eq "Master Quest" -or $DungeonList["Spirit Temple"] -eq "Ura Quest") {
        PrepareMap   -Scene "Spirit Temple" -Map 2 -Header 0 # Main Corridor: East
        InsertObject -Id    "0045"
        SaveLoadedMap

        PrepareMap   -Scene "Spirit Temple" -Map 6 -Header 0 # Entrance Shortcut Room
        ReplaceActor -Name "Switch"                 -X -104 -Y 542 -Z -61  -Compare "0A02" -YRot 0x4000 # Move eye switch
        RemoveActor  -Name "Pushable Block"                                -Compare "09C3"              # Restore vanilla push block layout using flags: 0x09 and 0x0E
        RemoveActor  -Name "Pushable Block"                                -Compare "09C7"
        RemoveActor  -Name "Pushable Block Trigger"                        -Compare "0009"
        RemoveActor  -Name "Silver Block (Child)"                          -Compare "0009"
        RemoveActor  -Name "Pushable Block"                                -Compare "3FC3"
        InsertActor  -Name "Pushable Block"         -X  340 -Y 413 -Z -461 -Param   "09C3"
        InsertActor  -Name "Pushable Block"         -X  540 -Y 413 -Z -261 -Param   "0EC3"
        InsertActor  -Name "Pushable Block"         -X  540 -Y 213 -Z -461 -Param   "09C7"
        InsertActor  -Name "Pushable Block"         -X  540 -Y 213 -Z -61  -Param   "0EC7"
        InsertActor  -Name "Pushable Block Trigger" -X  540 -Y 213 -Z -461 -Param   "0009"
        InsertActor  -Name "Pushable Block Trigger" -X  540 -Y 213 -Z -61  -Param   "000E"
        InsertActor  -Name "Silver Block (Child)"   -X  340 -Y 413 -Z -461 -Param   "0009"
        InsertActor  -Name "Silver Block (Child)"   -X  540 -Y 413 -Z -261 -Param   "000E"
        SaveLoadedMap

        PrepareMap   -Scene "Spirit Temple" -Map 8 -Header 0 # Sun Face Block Pushing Room
        InsertObject -ID    "0045"
        SaveLoadedMap
    }

    if ($DungeonList["Spirit Temple"] -eq "Vanilla") {
        PrepareMap   -Scene "Spirit Temple" -Map 12 -Header 0 # Rolling Boulder Subroom
        InsertObject -Name "Deku Shield" # Fix Like-Like not giving the Deku Shield back
        SaveLoadedMap

        PrepareMap   -Scene "Spirit Temple" -Map 22 -Header 0 # Triforce Corridor: Subroom
        InsertObject -ID    "0045"
        SaveLoadedMap
    }

    PrepareMap   -Scene "Spirit Temple" -Map 26 -Header 0 # Rotating Mirror Statues Room
    InsertObject -Name "Time Block"
    InsertObject -Name "Time Block Disappearance Effect"
    InsertActor  -Name "Time Block" -X -560 -Y 1720 -Z -900 -Param "39FF" -ZRot 0x0003 # Time block, so Child can activate the sun switch
    SaveAndPatchLoadedScene



    # INSIDE GANON'S CASTLE #

    PrepareMap   -Scene "Inside Ganon's Castle" -Map 0 -Header 0 # Entrance
    ChangeExit   -Index 0 -Exit "023F" # Fix exit
    SaveLoadedMap

    PrepareMap   -Scene "Inside Ganon's Castle" -Map 3 -Header 0 # Water Trial #2
    InsertObject -Name  "Hookshot Pillar & Wall Target"
    InsertObject -Name  "Spirit Temple"
    InsertActor  -Name  "Stone Hookshot Target" -X 2822 -Y -380 -Z -1175 -Param "FF00"              # Reach rusted floor switch / upper silver rupee
    InsertActor  -Name  "Metal Crating Bridge"  -X 2790 -Y -165 -Z -1319 -Param "00FF" -ZRot 0xBFEA
    InsertActor  -Name  "Stone Hookshot Target" -X 3310 -Y -380 -Z -945  -Param "FF00"              # Reach door leading to the barrier
    InsertActor  -Name  "Stone Hookshot Target" -X 2829 -Y -480 -Z -743  -Param "FF00"              # Prevent being stuck in the push block gap
    SaveLoadedMap

    PrepareMap   -Scene "Inside Ganon's Castle" -Map 6 -Header 0 # Forest Trial #2
    InsertActor  -Name  "Stone Hookshot Target" -X 1742 -Y 110 -Z 2044 -YRot 0x1555 -Param "FF00" # Hookshot target near barrier door
    if ($DungeonList["Inside Ganon's Castle"] -eq "Master Quest" -or $DungeonList["Inside Ganon's Castle"] -eq "Ura Quest") {
        InsertObject -ID   "0045"
        InsertActor  -Name "Stone Hookshot Target" -X 1169 -Y 262 -Z 1184 -YRot 0x1555 -Param "FF02" # Hookshot target near entrance door (like vanilla)
    }
    SaveLoadedMap

    if ($DungeonList["Inside Ganon's Castle"] -eq "Vanilla") {
        PrepareMap    -Scene "Inside Ganon's Castle" -Map 12 -Header 0 # Shadow Trial
        InsertObject  -Name  "Deku Shield"                              # Fix Like-Like not giving the Deku Shield back
        InsertObject  -ID    "0045"
        ReplaceActor  -Name  "Time Block" -Compare "3821" -Param "B821" # Invert time blocks
        ReplaceActor  -Name  "Time Block" -Compare "3822" -Param "B822"
        ReplaceActor  -Name  "Time Block" -Compare "3823" -Param "B823"
        SaveAndPatchLoadedScene
    }
    elseif ($DungeonList["Inside Ganon's Castle"] -eq "Master Quest" -or $DungeonList["Inside Ganon's Castle"] -eq "Ura Quest") {
        PrepareMap    -Scene "Inside Ganon's Castle" -Map  10 -Header 0 # Fake Light Barrier
        InsertObject  -New   "0045"
        SaveLoadedMap
        
        PrepareMap    -Scene "Inside Ganon's Castle" -Map 12 -Header 0 # Shadow Trial
        InsertObject  -ID    "0045"
        SaveLoadedMap

        PrepareMap   -Scene "Inside Ganon's Castle" -Map 14 -Header 0 # Fire Trial
        ReplaceActor -Name  "Silver Rupee" -Y 625 -CompareY 640 -Compare "1FC1" # Lower topmost silver rupee
        SaveAndPatchLoadedScene

        PrepareMap    -Scene "Inside Ganon's Castle" -Map 17 -Header 0 # Spirit Trial #1
        InsertObject  -ID    "0045"
        SaveLoadedMap
    }

}



#==============================================================================================================================================================================================
function ChildQuestByteTextOptions() {
    
    # Items
    SetMessage -ID "0009" -Text "Broken <N>Goron's Sword"                                    -Replace "Gold<N>Dust"
    SetMessage -ID "005C" -Text "<NS><Icon:52><DI>You found the <B>Golden Gauntlets<W>!<DC>" -Replace "<NS><Icon:52><DI>You got another <B>Power Bracelet<W>!<DC>"
    SetMessage -ID "0092" -Text "Hylian Shield"                                              -Replace "Hero's Shield" -ASCII

    SetMessage -ID "0008" -Replace "<NS><Icon:33><DI>You traded the Poacher's Saw<N>for some high quality <R>Gold Dust<W>!<DC><N>Bring it to a master smith to<N>reforge a sword with it!"
    SetMessage -ID "000B" -Replace "<NS><Icon:3D><DI>You got the Silver Sword<N>reforged into the <R>Gilded Sword<W>!<DC><N>This blade was forged by a<N>master smith for great power!"   # Biggoron Sword -> Gilded Sword (Giant's Knife / Silver Sword)
    SetMessage -ID "000C" -Replace "<NS><Icon:3D><DI>You handed in the Claim Check<N>and got the <R>Gilded Sword<W>!<DC><N>This blade was forged by a<N>master smith for great power!"    # Biggoron Sword -> Gilded Sword (Claim Check)
    SetMessage -ID "004B" -Replace "<NS><Icon:55><DI>You got the <R>Silver Sword<W>!<DC><N>This blade was forged by an<N>expert smith to have a wider<N>slash range with decent power!"    # Giant's Knife  -> Silver Sword
    SetMessage -ID "004D" -Replace "<Icon:3F><DI>You got a <C>Hero's Shield<W>!<DC><N>Switch to the <B>Equipment<N>Subscreen<W> and select this<N>shield, then equip it with <B><A Button><W>."
    SetMessage -ID "0050" -Replace "<Icon:42><DI>You got a <R>Goron Tunic<W>!<DC><N>This is a heat-resistant tunic.<N>Going to a hot place? No worry!"
    SetMessage -ID "0051" -Replace "<Icon:43><DI>You got a <B>Zora Tunic<W>!<DC><N>This is a diving suit. Wear it<N>and you won't drown underwater."
    SetMessage -ID "005B" -Replace "<NS><Icon:51><DI>You found the <B>Power Bracelet<W>!<DC><N>If you wore it, you would<N>feel immense power to lift<N>heavy objects with <B><A Button><W>!<New Box><NS><Icon:51>You did promise to<N>give it to <R>Nabooru<W> however...<N>You should keep your word..."
    SetMessage -ID "009C" -Replace "My current hot seller is the<N><C>Hero's Shield<W>, but it might be too<N>heavy for you, kid.<Event>"
    SetMessage -ID "00A9" -Replace "<DI><R>Hero's Shield   80 Rupees<N><W>This is the shield heroes use.<N>It can stand up to flame attacks!<DC><Shop Description>"
    SetMessage -ID "00AA" -Replace "<DI><R>Goron Tunic   200 Rupees<N><W>A tunic made by Gorons.<N>Protects you from heat damage.<DC><Shop Description>"
    SetMessage -ID "00AB" -Replace "<DI><R>Zora Tunic   300 Rupees<N><W>A tunic made by Zoras. Prevents<N>you from drowning underwater.<DC><Shop Description>"



    # Hints
    SetMessage -ID "0220" -Replace "<DI>If you want to succeed, you<N>must possess the powers to<N><B>move<W> and <R>reflect<W>.<DC>" # Spirit Temple (right)
    SetMessage -ID "0221" -Replace "<DI>If you want to proceed, you<N>must collect the treasures<N>of both past and future.<DC>"      # Spirit Temple (left)
    SetMessage -ID "0237" -Text "silver" -Replace "powerful" -ASCII                                                                   # Gerudo Training Ground



    # Hylian Shield
    SetMessage -ID "7013" -Replace "If you plan on scaling Death<N>Mountain, buy a <C>Hero's Shield<W>.<N>You can defend yourself against<N>falling rocks with that shield."
    SetMessage -ID "7121" -Replace "Hero's Shields" -Text "Hylian Shields" -ASCII



    # Signpost & Doors
    SetMessage -ID "7068" -Replace "<C>Closed for the foreseeable future.<N>Awaiting the return of evil spirits.<W>" -NewID "023D"
    SetMessage -ID "7069" -Replace "<DI><Shift:41>Just ahead:<N><Shift:37><R>Ganon's Castle<W><N><Shift:23>Dangerous! Stay away!<DC>" -NewID "0346"; SetMessageBox -ID "7069" -Type 1
    SetMessage -ID "032C" -Replace "<DI><Shift:23>Open for Business:<N><Shift:3C><R>Ghost Shop<W><DC>"



    # Enemies
    SetMessage -ID "060B" -Replace "<DI>Yellow Tektite<N><C>Be careful not to get stunned<N>by it when it hits you!<W><DC>"



    # Silver Gauntlets
    SetMessage -ID "015A" -Text "Silver Gauntlets"   -Replace "Power Bracelet"        # Get Item
    SetMessage -ID "6024" -Text "Silver<N>Gauntlets" -Replace "Power<N>Bracelet"      # Nabooru
    SetMessage -ID "6024" -Text "Silver Gauntlets"   -Replace "Power Bracelet"   -All # Nabooru
    SetMessage -ID "6024" -Text "equip them"         -Replace "equip it"         -All # Nabooru
    SetMessage -ID "6026" -Text "Silver Gauntlets"   -Replace "Power Bracelet"        # Nabooru



    # Fire Temple
    SetMessage -ID "01A5" -Replace "<NS><C>You can see down from here...<N>Isn't that the room where we saw<N>the <W>boss door<C>?<W>"



    # Giant's Knife
    SetMessage -ID "304E" -Replace "Oh. I am closed right now. All of<N>the gorons are missing. I would<N>love to re-open the shop if you<N>could bring everyone back safely."



    # Medallions
    SetMessage -ID "704F" -Text "Look at yourself...!"                                  -Replace "You haven't aged a bit..."                                                                                                                          # Remove Rauru alerting Link of his new age
    SetMessage -ID "7050"                                                               -Replace "<NS><Shift:0F><C>Look <Player>!<N><W><Shift:1E><C>You look older now!!<N><W><Shift:1D><C>Wait... You still look the same?<W>"                       # Navi thinking Link grew up in the Chamber of Sages
    SetMessage -ID "7051" -Text "you are old enough,<N>the time has come for you to<N>" -Replace "Ganondorf's evil has<N>spread, the time has come for you<N>to "                                                                                     # Raura explaining Link was sealed
    SetMessage -ID "4046"                                                               -Replace "<NS>I wanted us together...<N>Fullfilling the vows that we once<N>made to each other.<New Box><NS>But time and destiny<N>chose a different path..." # Water
    SetMessage -ID "6036"                                                               -Replace "<NS>I should have kept the promise<N>I made back then...<Fade:5A>"                                                                                  # Spirit



    # Time related dialog
    SetMessage -ID "1063" -Replace "<NS>Hey, have you seen your old<N>friends? None of them recognized<N>you, did they?<New Box><NS>That's because the <G>Kokiri<W> never<N>grow up! Even after seven years,<N>they're still kids!" # Deku Tree Sprout
    SetMessage -ID "1064" -Text "you have grown up!" -Replace "you left the forest!" # Deku Tree Sprout
    SetMessage -ID "600C" -Replace "<NS>Past, present, future...<New Box><NS>The Master Sword is a ship with<N>which you can sail upstream and<N>downstream through time's river...<New Box><NS>The port for that ship is in the<N>Temple of Time...<New Box><NS>Despite your age and inability<N>to travel back, you must not falter<N>and do what it takes to become<N>a true hero...<New Box><NS>Listen to this <Y>Requiem of Spirit<W>...<N>This melody will lead you back<N>to the desert." # Requiem
    SetMessage -ID "6035" -Replace "<NS>Kid, let me thank you.<N><NS>Heheheh...look what the little<N>kid has become--a competent<N>swordsman!" # Nabooru
    SetMessage -ID "6079" -Replace "<NS>Hey, what's up, <Player>?<N>Surprised to see me?<New Box><NS>A long time in this world is<N>almost nothing to you, is it?<N>How mysterious!<New Box><NS>Even I thought that the tales of a<N>boy who could defeat the evil<N>was merely a legend.<New Box><NS><Player>, you have fully<N>matured as the Hero of Time.<Jump:607A>" # Kaepora Gaebora
    SetMessage -ID "7054" -Text "It looks like you won't be<N>able to use some of the <W>weapons<C><N>you found as a kid anymore..." -Replace "It appears you can't use the<N>Master Sword, but got a different<N>weapon instead..." # Navi after Light Medallion
    SetMessage -ID "7074" -Text "and even through time..." -Replace "across sand...<New Box>and even into the darkest<N>of dungeons..." # Prelude
    SetMessage -ID "7078" -Text "Master" -Replace "Razor" -ASCII

    

    # Adult Trading Sequence
    SetMessage -ID "3053" -Replace "My Brotherrrr...<N>Opened a new storrrre...<N>It's Medigoron's Blade<N>Storrrrrrrre...<New Box>He has the talent, but he is<N>so stubborrrrrn....<New Box>All the blades he makes, arrrre<N>flawed through lack of<N>materrrrial quality....<New Box>If you everrrr get your hands on<N>both his sworrrrrd and some gold<N>dust, I can reforrrrge it into the<N>strrrrrrongest blade for you...."
    SetMessage -ID "3054" -Replace "<NS>That <R>Silverrrr Sword<W> could use some<N>worrrrrrrrrrk...<N><NS>I really want to reforrrrge it, but..." -Text "<NS>That broken knife is surely my <N>worrrrrrrrrrk...<N><NS>I really want to repairrrrr it, but..."
    SetMessage -ID "601B" -Replace "Good kid! Thanks!<N>I won't have to visit Goron City<N>anymore so feel free to have this.<N>Get yourself a new sword with it."
    SetMessage -ID "606E" -Text "My Biggoron tool broke, so I was<N>going to Goron City to get it<N>repaired." -Replace "My spare saw broke, so I was<N>going to Goron City to forge a<N>new one with some high quality<N><R>Gold Dust<W> I have."
    


    # Kokiri
    SetMessage -ID "1052" -Replace "Hi, boy! You seem like you<N>know how to handle one of<N>our Deku Shields."
    SetMessage -ID "105D" -Replace "<NS>It would be awesome to be<N>strong like you, boy! I really want<N>to be strong like you!<New Box><NS>I want to be strong enough so<N>I can beat up the Deku Scrubs, but...<JUMP:105E>"



    # Darunia
    SetMessage -ID "3039" -Text "so big since I last<N>" -Replace "stronger since I<N>last "



    # Ruto
    $text    = "I never forgot the vows we<N>made to each other seven years <N>ago!<New Box><NS>You're a terrible man to have <N>kept me waiting for these seven<N>long years..."
    $replace = "Which is what I would like to say...<N>But it seems time didn't pass for you.<N>How come you are still a child?<New Box>How can fate be this cruel to us.<N>Seven long years..."
    SetMessage -ID "403E" -Text $text -Replace $replace



    # Mister
    SetMessage -ID "1053" -ASCII -Text "mister" -Replace "boy"
    SetMessage -ID "1055" -ASCII -Text "mister" -Replace "boy"
    SetMessage -ID "1057" -ASCII -Text "mister" -Replace "boy"
    SetMessage -ID "1058" -ASCII -Text "mister" -Replace "little guy"
    SetMessage -ID "105A" -ASCII -Text "mister" -Replace "boy"
    SetMessage -ID "105B" -ASCII -Text "Mister" -Replace "Little guy"
    SetMessage -ID "1073" -ASCII -Text "mister" -Replace "boy"
    SetMessage -ID "1076" -ASCII -Text "mister" -Replace "boy"
    SetMessage -ID "4093" -ASCII -Text "mister" -Replace "boy"



    # Young man
    SetMessage -ID "0168" -ASCII -Text "young man" -Replace "young one"
    SetMessage -ID "021C" -ASCII -Text "Young man" -Replace "young lad"
    SetMessage -ID "2025" -ASCII -Text "young man" -Replace "young lad"
    SetMessage -ID "2030" -ASCII -Text "young man" -Replace "young lad"
    SetMessage -ID "2037" -ASCII -Text "young man" -Replace "young lad"
    SetMessage -ID "2085" -ASCII -Text "young man" -Replace "young lad"
    SetMessage -ID "407D" -ASCII -Text "young man" -Replace "young lad"
    SetMessage -ID "4088" -ASCII -Text "young man" -Replace "young lad"
    SetMessage -ID "502D" -ASCII -Text "young man" -Replace "young one"
    SetMessage -ID "502E" -ASCII -Text "young man" -Replace "young one"
    SetMessage -ID "5041" -ASCII -Text "young man" -Replace "young one"
    SetMessage -ID "6066" -ASCII -Text "young man" -Replace "young lad"
    SetMessage -ID "7011" -ASCII -Text "young man" -Replace "young lad"
    SetMessage -ID "70F4" -ASCII -Text "young man" -Replace "young lad" -All
    SetMessage -ID "70F5" -ASCII -Text "young man" -Replace "young lad"
    SetMessage -ID "70F8" -ASCII -Text "Young man" -Replace "Young lad"

}