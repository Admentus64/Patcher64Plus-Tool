function SetFileParameters() {
    
    # Create a hash table
    $global:Files = @{}
    $Files.tool = @{}
    $Files.oot = @{}
    $Files.mm = @{}
    $Files.sm64 = @{}
    $Files.json = @{}
    $Files.icon = @{}
    $Files.text = @{}



    # Store all tool files
    $Files.tool.Compress64                  = $Paths.Tools + "\Compression\Compress64.exe"
    $Files.tool.Compress32                  = $Paths.Tools + "\Compression\Compress32.exe"
    $Files.tool.ndec                        = $Paths.Tools + "\Compression\ndec.exe"
    $Files.tool.sm64extend                  = $Paths.Tools + "\Compression\sm64extend.exe"
    $Files.tool.TabExt64                    = $Paths.Tools + "\Compression\TabExt64.exe"
    $Files.tool.TabExt32                    = $Paths.Tools + "\Compression\TabExt32.exe"

    $Files.tool.inpout32                    = $Paths.Tools + "\Conversion\inpout32.dll"
    $Files.tool.io                          = $Paths.Tools + "\Conversion\io.dll"
    $Files.tool.ucon64                      = $Paths.Tools + "\Conversion\ucon64.exe"

    $Files.tool.flips                       = $Paths.Tools + "\Patching\flips.exe"
    $Files.tool.ups                         = $Paths.Tools + "\Patching\ups.exe"
    $Files.tool.xdelta                      = $Paths.Tools + "\Patching\xdelta.exe"
    $Files.tool.xdelta3                     = $Paths.Tools + "\Patching\xdelta3.exe"
    $Files.tool.applyPPF3                   = $Paths.Tools + "\Patching\ApplyPPF3.exe"

    $Files.tool.rn64crc                     = $Paths.Tools + "\Verification\rn64crc.exe"

    $Files.tool.wadpacker                   = $Paths.WiiVC + "\wadpacker.exe"
    $Files.tool.wadunpacker                 = $Paths.WiiVC + "\wadunpacker.exe"
    $Files.tool.wszst                       = $Paths.WiiVC + "\wszst.exe"
    $Files.tool.cygcrypto                   = $Paths.WiiVC + "\cygcrypto-0.9.8.dll"
    $Files.tool.cyggccs1                    = $Paths.WiiVC + "\cyggcc_s-1.dll"
    $Files.tool.cygncursesw10               = $Paths.WiiVC + "\cygncursesw-10.dll"
    $Files.tool.cygpng1616                  = $Paths.WiiVC + "\cygpng16-16.dll"
    $Files.tool.cygwin1                     = $Paths.WiiVC + "\cygwin1.dll"
    $Files.tool.cygz                        = $Paths.WiiVC + "\cygz.dll"
    $Files.tool.lzss                        = $Paths.WiiVC + "\lzss.exe"
    $Files.tool.romc                        = $Paths.WiiVC + "\romc.exe"
    $Files.tool.romchu                      = $Paths.WiiVC + "\romchu.exe"



    # Store Ocarina of Time files
    $Files.oot.master_quest                 = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\master_quest")
    $Files.oot.mm_pause_screen              = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\mm_pause_screen")

    $Files.oot.link_models_3d               = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Models\Link\3d")
    $Files.oot.link_model_adult_botw        = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Models\Link\adult_botw")
    $Files.oot.link_model_adult_dark        = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Models\Link\adult_dark")
    $Files.oot.link_model_adult_fd          = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Models\Link\adult_fd")
    $Files.oot.link_model_adult_la          = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Models\Link\adult_la")
    $Files.oot.link_model_adult_mm          = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Models\Link\adult_mm")
    $Files.oot.link_models_alttp            = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Models\Link\alttp")
    $Files.oot.link_model_child_mm          = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Models\Link\child_mm")
    $Files.oot.link_model_tp                = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Models\Link\tp")

    $Files.oot.male_models_salesman         = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Models\Male\happy_mask_salesman")
    $Files.oot.male_models_mega_man         = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Models\Male\mega_man")

    $Files.oot.female_models_aria           = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Models\Female\aria_the_demon")
    $Files.oot.female_models_miku_link      = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Models\Female\hatsune_miku_link")
    $Files.oot.female_models_miku_vocaloid  = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Models\Female\hatsune_miku_vocaloid")
    $Files.oot.female_models_malon_3d       = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Models\Female\malon_3d")
    $Files.oot.female_models_malon_thicc    = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Models\Female\malon_thicc")
    $Files.oot.female_models_zelda_alttp    = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Models\Female\princess_zelda_alttp")
    $Files.oot.female_models_ruto           = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Models\Female\princess_ruto")
    $Files.oot.female_models_roll           = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Models\Female\roll")
    $Files.oot.female_models_saria          = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Models\Female\saria")

    $Files.oot.lens_of_truth                = $Paths.Games + "\Ocarina of Time\Textures\Lens of Truth.bin"
    $Files.oot.title_copyright              = $Paths.Games + "\Ocarina of Time\Textures\Logo\Master Quest Title Copyright.bin"
    $Files.oot.title_master_quest           = $Paths.Games + "\Ocarina of Time\Textures\Logo\Master Quest Title Logo.bin"
    $Files.oot.hud_mm_hearts                = $Paths.Games + "\Ocarina of Time\Textures\HUD\MM Hearts.bin"
    $Files.oot.hud_mm_button                = $Paths.Games + "\Ocarina of Time\Textures\HUD\MM Button.bin"
    $Files.oot.hud_mm_key_rupee             = $Paths.Games + "\Ocarina of Time\Textures\HUD\MM Key & Rupee.bin"
    $Files.oot.hud_tatl                     = $Paths.Games + "\Ocarina of Time\Textures\HUD\Tatl.bin"
    $Files.oot.hud_tael                     = $Paths.Games + "\Ocarina of Time\Textures\HUD\Tael.bin"

    $Files.oot.file_select                  = $Paths.Games + "\Ocarina of Time\Binaries\File Select.bin"
    $Files.oot.message_table_restore_text   = $Paths.Games + "\Ocarina of Time\Binaries\Message\Table Restore Text.bin"
    $Files.oot.message_table_female_text    = $Paths.Games + "\Ocarina of Time\Binaries\Message\Table Female Pronouns.bin"
    $Files.oot.message_songs                = $Paths.Games + "\Ocarina of Time\Binaries\Message\Songs.bin"
    $Files.oot.message_mq1                  = $Paths.Games + "\Ocarina of Time\Binaries\Message\MQ Navi Action.bin"
    $Files.oot.message_mq2                  = $Paths.Games + "\Ocarina of Time\Binaries\Message\MQ Navi Door.bin"
    $Files.oot.mm_link_voices               = $Paths.Games + "\Ocarina of Time\Binaries\Voices\MM Link Voices.bin"
    $Files.oot.feminine_link_voices         = $Paths.Games + "\Ocarina of Time\Binaries\Voices\Feminine Link Voices.bin"
    $Files.oot.fire_temple_bank             = $Paths.Games + "\Ocarina of Time\Binaries\Fire Temple Theme\12AudioBankPointers.bin"
    $Files.oot.fire_temple_seq              = $Paths.Games + "\Ocarina of Time\Binaries\Fire Temple Theme\12AudioSeqPointers.bin"
    $Files.oot.fire_temple_table            = $Paths.Games + "\Ocarina of Time\Binaries\Fire Temple Theme\12AudioTablePointers.bin"
    $Files.oot.theme_fire_temple            = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Export\audiobank_fire_temple")
    $Files.oot.restore_text                 = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Export\Message\restore_text")
    $Files.oot.redux_text                   = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Export\Message\redux")
    $Files.oot.female_pronouns_text         = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Export\Message\female_pronouns")

    $Files.oot.gerudo1                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\crystal_switch.bin"
    $Files.oot.gerudo2                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\floor_switch.bin"
    $Files.oot.gerudo3                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\forest_temple_room_11_block.bin"
    $Files.oot.gerudo4                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\forest_temple_room_11_hole.bin"
    $Files.oot.gerudo5                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\ganondorf_cape.bin"
    $Files.oot.gerudo6                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\gerudo_training_ground_door.bin"
    $Files.oot.gerudo7                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\gerudo_training_ground_room_5.bin"
    $Files.oot.gerudo8                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\gerudo_valley.bin"
    $Files.oot.gerudo9                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\golden_gauntlets_pillar.bin"
    $Files.oot.gerudo10                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\mirror_shield.bin"
    $Files.oot.gerudo11                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\mirror_shield_chest.bin"
    $Files.oot.gerudo12                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\mirror_shield_icon.bin"
    $Files.oot.gerudo13                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\mirror_shield_reflection.bin"
    $Files.oot.gerudo14                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\pushing_block.bin"
    $Files.oot.gerudo15                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\rusted_floor_switch.bin"
    $Files.oot.gerudo16                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\shadow_temple_room_0.bin"
    $Files.oot.gerudo17                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\silver_gauntlets_block.bin"
    $Files.oot.gerudo18                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\spirit_temple_boss.bin"
    $Files.oot.gerudo19                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\spirit_temple_room_0_elevator.bin"
    $Files.oot.gerudo20                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\spirit_temple_room_0_pillars.bin"
    $Files.oot.gerudo21                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\spirit_temple_room_10.bin"



    # Store Majora's Mask files
    $Files.mm.troupe_leaders_mask_text      = $Paths.Games + "\Majora's Mask\Textures\Icons\Troupe Leader's Mask Text.yaz0"
    $Files.mm.deku_pipes_icon               = $Paths.Games + "\Majora's Mask\Textures\Icons\Deku Pipes Icon.yaz0"
    $Files.mm.deku_pipes_Text               = $Paths.Games + "\Majora's Mask\Textures\Icons\Deku Pipes Text.yaz0"
    $Files.mm.goron_drums_icon              = $Paths.Games + "\Majora's Mask\Textures\Icons\Goron Drums Icon.yaz0"
    $Files.mm.goron_drums_text              = $Paths.Games + "\Majora's Mask\Textures\Icons\Goron Drums Text.yaz0"
    $Files.mm.zora_guitar_icon              = $Paths.Games + "\Majora's Mask\Textures\Icons\Zora Guitar Icon.yaz0"
    $Files.mm.zora_guitar_text              = $Paths.Games + "\Majora's Mask\Textures\Icons\Zora Guitar Text.yaz0"

    $Files.mm.hud_oot_button                = $Paths.Games + "\Majora's Mask\Textures\HUD\OoT Button.bin"

    $Files.mm.carnival_of_time              = $Paths.Games + "\Majora's Mask\Textures\Widescreen\Carnival of Time.bin"
    $Files.mm.four_giant                    = $Paths.Games + "\Majora's Mask\Textures\Widescreen\Four Giants.bin"
    $Files.mm.lens_of_truth                 = $Paths.Games + "\Majora's Mask\Textures\Widescreen\Lens of Truth.bin"

    $Files.mm.goron_red_runic               = $Paths.Games + "\Majora's Mask\Textures\Recolor\Goron Red Tunic.bin"
    $Files.mm.zora_blue_gradient            = $Paths.Games + "\Majora's Mask\Textures\Recolor\Zora Blue Gradient.bin"
    $Files.mm.zora_blue_palette             = $Paths.Games + "\Majora's Mask\Textures\Recolor\Zora Blue Palette.bin"

    $Files.mm.romani_ranch                  = $Paths.Games + "\Majora's Mask\Textures\Romani Sign.bin"
    $Files.mm.skull_kid_beak                = $Paths.Games + "\Majora's Mask\Textures\Skull Kid Beak.bin"

    $Files.mm.zora_physics_fix              = $Paths.Games + "\Majora's Mask\Binaries\Zora Physics Fix.bin"

    $Files.mm.message_table_restore_text    = $Paths.Games + "\Majora's Mask\Binaries\Message\Table Restore Text.bin"
    $Files.mm.message_razor1                = $Paths.Games + "\Majora's Mask\Binaries\Message\Razor Sword 1.bin"
    $Files.mm.message_razor2                = $Paths.Games + "\Majora's Mask\Binaries\Message\Razor Sword 2.bin"

    $Files.mm.southern_swamp_cleared        = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Export\Southern Swamp\southern_swamp_cleared_scene")
    $Files.mm.southern_swamp_cleared_0      = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Export\Southern Swamp\southern_swamp_cleared_room_0")
    $Files.mm.southern_swamp_cleared_2      = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Export\Southern Swamp\southern_swamp_cleared_room_2")
    $Files.mm.deku_palace                   = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Export\Deku Palace\deku_palace_scene")
    $Files.mm.deku_palace_0                 = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Export\Deku Palace\deku_palace_room_0")
    $Files.mm.deku_palace_1                 = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Export\Deku Palace\deku_palace_room_1")
    $Files.mm.deku_palace_2                 = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Export\Deku Palace\deku_palace_room_2")
    $Files.mm.restore_text                  = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Export\Message\restore_text")


    # Store Super Mario 64 files
    $Files.sm64.cam                         = CheckPatchExtension ($Paths.Games + "\Super Mario 64\Compressed\cam")
    $Files.sm64.fps                         = CheckPatchExtension ($Paths.Games + "\Super Mario 64\Compressed\fps")



    # Store JSON files
    $Files.json.consoles                    = $Paths.Games + "\Consoles.json"
    $Files.json.games                       = $Paths.Games + "\Games.json"



    # Store ICO files
    $Files.icon.main                        = $Paths.Main + "\Main.ico"
    $Files.icon.settings                    = $Paths.Main + "\Settings.ico"
    $Files.icon.credits                     = $Paths.Main + "\Credits.ico"
    $Files.icon.additional                  = $Paths.Main + "\Additional.ico"



    # Store text files
    $Files.text.credits                     = $Paths.Main + "\Credits.txt"
    $Files.text.gameID                      = $Paths.Main + "\GameID.txt"


    # Check if all files so far exist
    CheckFilesExists $Files.tool
    CheckFilesExists $Files.oot
    CheckFilesExists $Files.mm
    CheckFilesExists $Files.sm64
    CheckFilesExists $Files.json
    CheckFilesExists $Files.icon

    $Files.flipscfg                         = $Paths.Tools + "\Patching\flipscfg.bin"
    $Files.ckey                             = $Paths.Temp + "\common-key.bin"
    $Files.stackdump                        = $Paths.WiiVC + "\wadpacker.exe.stackdump"
    $Files.dmaTable                         = $Paths.Temp + "\dmaTable.dat"
    $Files.archive                          = $Paths.Temp + "\ARCHIVE.bin"
    $Files.settings                         = $Paths.Settings + "\Core.ini"



    # Clear data
    $Files.oot = $Files.mm = $Files.sm64 = $null

}



#==============================================================================================================================================================================================
function SetGetROM() {

    # Store misc files
    CreatePath $Paths.Temp

    $global:GetROM = @{}
    $GetROM.romc                            = $Paths.Temp + "\romc"
    $GetROM.clean                           = $Paths.Temp + "\clean"
    $GetROM.cleanDecomp                     = $Paths.Temp + "\clean-decompressed"
    $GetROM.decomp                          = $Paths.Temp + "\decompressed"
    $GetROM.masterQuest                     = $Paths.Temp + "\master-quest-decompressed"
    $GetROM.nes                             = $Paths.Temp + "\rom.nes"

    if ($IsWiiVC -and (IsSet $WADFile) ) {
        if (!(IsSet $WADFile.ROM)) { $WADFile.ROM = $GetROM.nes }
        $GetROM.in            = $GetROM.patched = $WADFile.ROM
        $GetROM.keepConvert   = $WADFile.Convert
        $GetROM.keepDowngrade = $WADFile.Downgrade
        $GetROM.keepDecomp    = $WADFile.Decomp
    }
    elseif (!$IsWiiVC -and (IsSet $ROMFile) ) {
        $GetROM.in            = $ROMFile.ROM
        $GetROM.patched       = $ROMFile.Patched
        $GetROM.keepConvert   = $ROMFile.Convert
        $GetROM.keepDowngrade = $ROMFile.Downgrade
        $GetROM.keepDecomp    = $ROMFile.Decomp
    }

    if ($GetROM.in -ne $null) {
        $GetROM.run = $GetROM.in
        $Paths.Input =  [System.IO.Path]::GetDirectoryName($GetROM.in)
        $global:ROMHashSum = (Get-FileHash -Algorithm MD5 $GetROM.in).Hash
    }

    if ($Settings.Debug.CreateBPS -eq $True) {
        $Files.compBPS   = $Paths.Input + "\compressed.bps"
        $Files.decompBPS = $Paths.Input + "\decompressed.bps"
    }

}



#==============================================================================================================================================================================================
function CheckFilesExists([hashtable]$HashTable) {
    
    $FilesMissing = $False
    $HashTable.GetEnumerator() | ForEach-Object {
        if ( !(TestFile $_.value) -and (IsSet $_.value) ) {
            $FilesMissing = $True
            Write-Host "Missing file: " $_.value
        }
    }

    if ($FilesMissing) { CreateErrorDialog -Error "Missing Files" -Exit }

}



#==============================================================================================================================================================================================
function CheckPatchExtension([String]$File) {
    
    if (TestFile ($File + ".bps"))      { return $File + ".bps" }
    if (TestFile ($File + ".ips"))      { return $File + ".ips" }
    if (TestFile ($File + ".ups"))      { return $File + ".ups" }
    if (TestFile ($File + ".xdelta"))   { return $File + ".xdelta" }
    if (TestFile ($File + ".vcdiff"))   { return $File + ".vcdiff" }
    if (TestFile ($File + ".ppf"))      { return $File + ".ppf" }
    return $File

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function SetFileParameters
Export-ModuleMember -Function SetGetROM
Export-ModuleMember -Function CheckPatchExtension