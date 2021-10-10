function SetTempFileParameters() {
    
    $Files.ckey                             = $Paths.Temp + "\common-key.bin"
    $Files.dmaTable                         = $Paths.Temp + "\dmaTable.dat"
    $Files.archive                          = $Paths.Temp + "\ARCHIVE.bin"

}



#==============================================================================================================================================================================================
function SetFileParameters() {
    
    # Create a hash table
    $global:Files = @{}
    $Files.tool = @{}
    $Files.sound = @{}
    $Files.oot = @{}
    $Files.mm = @{}
    $Files.sm64 = @{}
    $Files.json = @{}
    $Files.icon = @{}
    $Files.text = @{}



    # Store all tool files
    $Files.tool.Compress                    = (GetFilePath) + "\Files\Tools\Compression\Compress.exe"
    $Files.tool.ndec                        = (GetFilePath) + "\Files\Tools\Compression\ndec.exe"
    $Files.tool.sm64extend                  = (GetFilePath) + "\Files\Tools\Compression\sm64extend.exe"
    $Files.tool.TabExt                      = (GetFilePath) + "\Files\Tools\Compression\TabExt.exe"

    $Files.tool.applyPPF3                   = (GetFilePath) + "\Files\Tools\Patching\ApplyPPF3.exe"
    $Files.tool.flips                       = (GetFilePath) + "\Files\Tools\Patching\flips.exe"
    $Files.tool.ups                         = (GetFilePath) + "\Files\Tools\Patching\ups.exe"
    $Files.tool.xdelta                      = (GetFilePath) + "\Files\Tools\Patching\xdelta.exe"
    $Files.tool.xdelta3                     = (GetFilePath) + "\Files\Tools\Patching\xdelta3.exe"

    $Files.tool.rn64crc                     = (GetFilePath) + "\Files\Tools\Verification\rn64crc.exe"

    $Files.tool.wadpacker                   = (GetFilePath) + "\Files\Tools\Wii VC\wadpacker.exe"
    $Files.tool.wadunpacker                 = (GetFilePath) + "\Files\Tools\Wii VC\wadunpacker.exe"
    $Files.tool.wszst                       = (GetFilePath) + "\Files\Tools\Wii VC\wszst.exe"
    $Files.tool.cygcrypto                   = (GetFilePath) + "\Files\Tools\Wii VC\cygcrypto-0.9.8.dll"
    $Files.tool.cyggccs1                    = (GetFilePath) + "\Files\Tools\Wii VC\cyggcc_s-1.dll"
    $Files.tool.cygncursesw10               = (GetFilePath) + "\Files\Tools\Wii VC\cygncursesw-10.dll"
    $Files.tool.cygpng1616                  = (GetFilePath) + "\Files\Tools\Wii VC\cygpng16-16.dll"
    $Files.tool.cygwin1                     = (GetFilePath) + "\Files\Tools\Wii VC\cygwin1.dll"
    $Files.tool.cygz                        = (GetFilePath) + "\Files\Tools\Wii VC\cygz.dll"
    $Files.tool.lzss                        = (GetFilePath) + "\Files\Tools\Wii VC\lzss.exe"
    $Files.tool.romc                        = (GetFilePath) + "\Files\Tools\Wii VC\romc.exe"
    $Files.tool.romchu                      = (GetFilePath) + "\Files\Tools\Wii VC\romchu.exe"



    # Store sound files
    $Files.sound.done                       = $Paths.FullBase + "\Files\Main\Done.wav"



    # Store Ocarina of Time files
    $Files.oot.widescreen                   = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\widescreen")
    $Files.oot.master_quest                 = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\master_quest")
    $Files.oot.mm_pause_screen              = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\mm_pause_screen")
    $Files.oot.harder_child_bosses          = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\harder_child_bosses")
    $Files.oot.feminine_animations          = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\feminine_animations")
    $Files.oot.hide_equipment               = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\hide_equipment")

    $Files.oot.lens_of_truth                = $Paths.Games + "\Ocarina of Time\Textures\widescreen\lens_of_truth.bin"
    $Files.oot.title_copyright              = $Paths.Games + "\Ocarina of Time\Textures\Logo\mq_copyright.bin"
    $Files.oot.title_master_quest           = $Paths.Games + "\Ocarina of Time\Textures\Logo\mq_logo.bin"
    $Files.oot.hud_mm_heart                 = $Paths.Games + "\Ocarina of Time\Textures\HUD\mm_heart.bin"
    $Files.oot.hud_mm_button                = $Paths.Games + "\Ocarina of Time\Textures\HUD\mm_button.bin"
    $Files.oot.hud_mm_button_full           = $Paths.Games + "\Ocarina of Time\Textures\HUD\mm_button_full.bin"
    $Files.oot.hud_mm_button_small          = $Paths.Games + "\Ocarina of Time\Textures\HUD\mm_button_small.bin"
    $Files.oot.hud_oot_button_full          = $Paths.Games + "\Ocarina of Time\Textures\HUD\oot_button_full.bin"
    $Files.oot.hud_oot_button_small         = $Paths.Games + "\Ocarina of Time\Textures\HUD\oot_button_small.bin"
    $Files.oot.hud_mm_key_rupee             = $Paths.Games + "\Ocarina of Time\Textures\HUD\mm_key_rupee.bin"
    $Files.oot.hud_tatl                     = $Paths.Games + "\Ocarina of Time\Textures\HUD\tatl.bin"
    $Files.oot.hud_tael                     = $Paths.Games + "\Ocarina of Time\Textures\HUD\tael.bin"
    $Files.oot.iron_shield_front            = $Paths.Games + "\Ocarina of Time\Textures\Iron Shield\front.bin"
    $Files.oot.iron_shield_front            = $Paths.Games + "\Ocarina of Time\Textures\Iron Shield\back.bin"
    $Files.oot.iron_shield_icon             = $Paths.Games + "\Ocarina of Time\Textures\Iron Shield\icon.bin"
    $Files.oot.l_target_button              = $Paths.Games + "\Ocarina of Time\Textures\GameCube\l_pause_screen_button.bin"
    $Files.oot.l_target_icon                = $Paths.Games + "\Ocarina of Time\Textures\GameCube\l_text_icon.bin"
    $Files.oot.keaton_mask                  = $Paths.Games + "\Ocarina of Time\Textures\Keaton Mask\keaton_mask.bin"

    $Files.oot.file_select                  = $Paths.Games + "\Ocarina of Time\Binaries\file_select.bin"
    $Files.oot.frontflip_jump               = $Paths.Games + "\Ocarina of Time\Binaries\Jumps\frontflip.bin"
    $Files.oot.somarsault_jump              = $Paths.Games + "\Ocarina of Time\Binaries\Jumps\somarsault.bin"
    $Files.oot.message_credits              = $Paths.Games + "\Ocarina of Time\Binaries\Message\credits.bin"
    $Files.oot.message_female_pronouns      = $Paths.Games + "\Ocarina of Time\Binaries\Message\female_pronouns.tbl"
    $Files.oot.message_mq1                  = $Paths.Games + "\Ocarina of Time\Binaries\Message\mq_navi_action.bin"
    $Files.oot.message_mq2                  = $Paths.Games + "\Ocarina of Time\Binaries\Message\mq_navi_door.bin"
    $Files.oot.message_restore              = $Paths.Games + "\Ocarina of Time\Binaries\Message\restore.tbl"
    $Files.oot.message_ruto_confession      = $Paths.Games + "\Ocarina of Time\Binaries\Message\ruto_confession.bin"
    $Files.oot.message_songs                = $Paths.Games + "\Ocarina of Time\Binaries\Message\songs.bin"
    $Files.oot.fire_temple_bank             = $Paths.Games + "\Ocarina of Time\Binaries\Fire Temple Theme\audiobank_pointers.bin"
    $Files.oot.fire_temple_seq              = $Paths.Games + "\Ocarina of Time\Binaries\Fire Temple Theme\audioseq_pointers.bin"
    $Files.oot.fire_temple_table            = $Paths.Games + "\Ocarina of Time\Binaries\Fire Temple Theme\audiotable_pointers.bin"

    $Files.oot.theme_fire_temple            = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Export\audiobank_fire_temple")
    $Files.oot.debug_map_select             = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Export\debug_map_select")
    $Files.oot.restore_text                 = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Export\Message\restore")
    $Files.oot.redux_text                   = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Export\Message\redux")
    $Files.oot.female_pronouns_text         = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Export\Message\female_pronouns")

    $Files.oot.gerudo1                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\crystal_switch.bin"
    $Files.oot.gerudo2                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\dampe.bin"
    $Files.oot.gerudo3                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\floor_switch.bin"
    $Files.oot.gerudo4                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\forest_temple_room_11_block.bin"
    $Files.oot.gerudo5                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\forest_temple_room_11_hole.bin"
    $Files.oot.gerudo6                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\ganondorf_cape.bin"
    $Files.oot.gerudo7                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\gerudo_membership_card.bin"
    $Files.oot.gerudo8                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\gerudo_training_ground_ceiling_frame.bin"
    $Files.oot.gerudo9                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\gerudo_training_ground_door.bin"
    $Files.oot.gerudo10                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\gerudo_training_ground_room_5.bin"
    $Files.oot.gerudo11                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\gerudo_valley.bin"
    $Files.oot.gerudo12                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\golden_gauntlets_pillar.bin"
    $Files.oot.gerudo13                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\pushing_block.bin"
    $Files.oot.gerudo14                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\rusted_floor_switch.bin"
    $Files.oot.gerudo15                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\shadow_temple_room_0.bin"
    $Files.oot.gerudo16                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\silver_gauntlets_block.bin"
    $Files.oot.gerudo17                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\spirit_temple_boss.bin"
    $Files.oot.gerudo18                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\spirit_temple_room_0_elevator.bin"
    $Files.oot.gerudo19                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\spirit_temple_room_0_pillars.bin"
    $Files.oot.gerudo20                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\spirit_temple_room_10.bin"



    # Store Majora's Mask files
    $Files.mm.troupe_leaders_mask_text      = $Paths.Games + "\Majora's Mask\Textures\Icons\troupe_leaders_mask_text.yaz0"
    $Files.mm.deku_pipes_icon               = $Paths.Games + "\Majora's Mask\Textures\Icons\deku_pipes_icon.yaz0"
    $Files.mm.deku_pipes_Text               = $Paths.Games + "\Majora's Mask\Textures\Icons\deku_pipes_text.yaz0"
    $Files.mm.goron_drums_icon              = $Paths.Games + "\Majora's Mask\Textures\Icons\goron_drums_icon.yaz0"
    $Files.mm.goron_drums_text              = $Paths.Games + "\Majora's Mask\Textures\Icons\goron_drums_text.yaz0"
    $Files.mm.zora_guitar_icon              = $Paths.Games + "\Majora's Mask\Textures\Icons\zora_guitar_icon.yaz0"
    $Files.mm.zora_guitar_text              = $Paths.Games + "\Majora's Mask\Textures\Icons\zora_guitar_text.yaz0"

    $Files.mm.widescreen                    = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Decompressed\widescreen")
    $Files.mm.improved_link_model           = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Decompressed\improved_link_model")
    $Files.mm.mq_remix                      = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Decompressed\master_quest_remix")

    $Files.mm.hud_navi                      = $Paths.Games + "\Majora's Mask\Textures\HUD\navi.bin"
    
    $Files.mm.hud_mm_button_full            = $Paths.Games + "\Majora's Mask\Textures\HUD\mm_button_full.bin"
    $Files.mm.hud_mm_button_small           = $Paths.Games + "\Majora's Mask\Textures\HUD\mm_button_small.bin"
    $Files.mm.hud_oot_button                = $Paths.Games + "\Majora's Mask\Textures\HUD\oot_button.bin"
    $Files.mm.hud_oot_button_full           = $Paths.Games + "\Majora's Mask\Textures\HUD\oot_button_full.bin"
    $Files.mm.hud_oot_button_small          = $Paths.Games + "\Majora's Mask\Textures\HUD\oot_button_small.bin"
    $Files.mm.hud_oot_heart                 = $Paths.Games + "\Majora's Mask\Textures\HUD\oot_heart.bin"
    $Files.mm.hud_tael                      = $Paths.Games + "\Majora's Mask\Textures\HUD\tael.bin"
    $Files.mm.hud_tatl                      = $Paths.Games + "\Majora's Mask\Textures\HUD\tatl.bin"
    $Files.mm.hud_taya                      = $Paths.Games + "\Majora's Mask\Textures\HUD\taya.bin"

    $Files.mm.l_target_button               = $Paths.Games + "\Majora's Mask\Textures\GameCube\l_pause_screen_button.yaz0"
    $Files.mm.l_target_button               = $Paths.Games + "\Majora's Mask\Textures\GameCube\l_text_icon.bin"

    $Files.mm.carnival_of_time              = $Paths.Games + "\Majora's Mask\Textures\Widescreen\carnival_of_time.bin"
    $Files.mm.four_giant                    = $Paths.Games + "\Majora's Mask\Textures\Widescreen\four_giants.bin"
    $Files.mm.lens_of_truth                 = $Paths.Games + "\Majora's Mask\Textures\Widescreen\lens_of_truth.bin"

    $Files.mm.romani_ranch                  = $Paths.Games + "\Majora's Mask\Textures\romani_sign.bin"
    $Files.mm.skull_kid_beak                = $Paths.Games + "\Majora's Mask\Textures\skull_kid_beak.bin"

    $Files.mm.zora_physics_fix              = $Paths.Games + "\Majora's Mask\Binaries\zora_physics_fix.bin"
    $Files.mm.frontflip_jump_attack         = $Paths.Games + "\Majora's Mask\Binaries\frontflip_jump_attack.bin"

    $Files.mm.message_credits               = $Paths.Games + "\Majora's Mask\Binaries\Message\credits.bin"
    $Files.mm.message_razor_sword_1         = $Paths.Games + "\Majora's Mask\Binaries\Message\razor_sword_1.bin"
    $Files.mm.message_razor_sword_2         = $Paths.Games + "\Majora's Mask\Binaries\Message\razor_sword_2.bin"
    $Files.mm.message_razor_sword_3         = $Paths.Games + "\Majora's Mask\Binaries\Message\razor_sword_3.bin"
    $Files.mm.message_razor_sword_4         = $Paths.Games + "\Majora's Mask\Binaries\Message\razor_sword_4.bin"
    $Files.mm.message_restore               = $Paths.Games + "\Majora's Mask\Binaries\Message\restore.tbl"

    $Files.mm.southern_swamp_cleared        = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Export\Southern Swamp\southern_swamp_cleared_scene")
    $Files.mm.southern_swamp_cleared_0      = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Export\Southern Swamp\southern_swamp_cleared_room_0")
    $Files.mm.southern_swamp_cleared_2      = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Export\Southern Swamp\southern_swamp_cleared_room_2")
    $Files.mm.deku_palace                   = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Export\Deku Palace\deku_palace_scene")
    $Files.mm.deku_palace_0                 = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Export\Deku Palace\deku_palace_room_0")
    $Files.mm.deku_palace_1                 = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Export\Deku Palace\deku_palace_room_1")
    $Files.mm.deku_palace_2                 = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Export\Deku Palace\deku_palace_room_2")
    $Files.mm.restore_text                  = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Export\Message\restore")



    # Store Super Mario 64 files
    $Files.sm64.cam                         = CheckPatchExtension ($Paths.Games + "\Super Mario 64\Compressed\cam")
    $Files.sm64.fps                         = CheckPatchExtension ($Paths.Games + "\Super Mario 64\Compressed\fps")



    # Store JSON files
    $Files.json.consoles                    = $Paths.Games + "\Consoles.json"
    $Files.json.games                       = $Paths.Games + "\Games.json"
    $Files.json.regions                     = $Paths.Games + "\Regions.json"



    # Store ICO files
    $Files.icon.main                        = $Paths.Main + "\Main.ico"
    $Files.icon.settings                    = $Paths.Main + "\Settings.ico"
    $Files.icon.credits                     = $Paths.Main + "\Credits.ico"
    $Files.icon.additional                  = $Paths.Main + "\Additional.ico"



    # Store text files
    $Files.text.credits                     = $Paths.Base +"\Info\Credits.txt"
    $Files.text.gameID                      = $Paths.Main + "\GameID.txt"
    $Files.text.mainCredits                 = $Paths.Base + "\Info\Credits.txt"


    # Check if all files so far exist
    CheckFilesExists $Files.tool
    CheckFilesExists $Files.oot
    CheckFilesExists $Files.mm
    CheckFilesExists $Files.sm64
    CheckFilesExists $Files.json
    CheckFilesExists $Files.icon

    $Files.flipscfg                         = (GetFilePath) + "\Files\Tools\Patching\flipscfg.bin"
    $Files.stackdump                        = (GetFilePath) + "\Files\Tools\Wii VC\wadpacker.exe.stackdump"
    $Files.settings                         = $Paths.Settings + "\Core.ini"

    SetTempFileParameters

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
    $GetROM.downgrade                       = $Paths.Temp + "\downgraded"
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
        $GetROM.input         
    }

    if ($GetROM.in -ne $null)   { $GetROM.run = $GetROM.in }
    if (TestFile $GetROM.in )   { $global:ROMHashSum = (Get-FileHash -Algorithm MD5 -LiteralPath $GetROM.in).Hash }

    if ($Settings.Debug.CreateBPS -eq $True) {
        $Files.compBPS   = [System.IO.Path]::GetDirectoryName($GetROM.in) + "\" + [System.IO.Path]::GetFileNameWithoutExtension($GetROM.in) + "_compressed.bps"
        $Files.decompBPS = [System.IO.Path]::GetDirectoryName($GetROM.in) + "\" + [System.IO.Path]::GetFileNameWithoutExtension($GetROM.in) + "_decompressed.bps"
    }

}



#==============================================================================================================================================================================================
function GetFilePath() {
    
    if ($ExternalScript)   { return $Paths.FullBase }
    else                   { return [System.String](Get-Location) }

}



#==============================================================================================================================================================================================
function CheckFilesExists([hashtable]$HashTable) {
    
    $FilesMissing = $False
    $HashTable.GetEnumerator() | foreach {
        if ( !(TestFile $_.value) -and (IsSet $_.value) ) {
            $FilesMissing = $True
            Write-Host "Missing file: " $_.value
        }
    }

    if ($FilesMissing) { CreateErrorDialog -Error "Missing Files" }

}



#==============================================================================================================================================================================================
function CheckPatchExtension([string]$File) {
    
    if (TestFile ($File + ".bps"))      { return $File + ".bps" }
    if (TestFile ($File + ".ips"))      { return $File + ".ips" }
    if (TestFile ($File + ".ups"))      { return $File + ".ups" }
    if (TestFile ($File + ".xdelta"))   { return $File + ".xdelta" }
    if (TestFile ($File + ".vcdiff"))   { return $File + ".vcdiff" }
    if (TestFile ($File + ".ppf"))      { return $File + ".ppf" }
    return $File

}



#==============================================================================================================================================================================================
function LoadSoundEffects([boolean]$Enable=$True) {
    
    if (!$Enable) {
        $global:Sounds = $null
        return
    }
    
    $global:Sounds = @{}
    
    $Sounds.done = New-Object System.Media.SoundPlayer
    $Sounds.done.SoundLocation = $Files.sound.done

}



#==============================================================================================================================================================================================
function PlaySound([System.Media.SoundPlayer]$Sound) {
    
    if ($Settings.Core.EnableSounds -eq $True -and $Sound -ne $null) { $Sound.playsync() } 

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function SetTempFileParameters
Export-ModuleMember -Function SetFileParameters
Export-ModuleMember -Function SetGetROM
Export-ModuleMember -Function CheckPatchExtension
Export-ModuleMember -Function LoadSoundEffects
Export-ModuleMember -Function PlaySound