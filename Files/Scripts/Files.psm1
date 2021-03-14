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
    $Files.tool.Compress64                  = [System.String](Get-Location) + "\Files\Tools\Compression\Compress64.exe"
    $Files.tool.Compress32                  = [System.String](Get-Location) + "\Files\Tools\Compression\Compress32.exe"
    $Files.tool.Decompress                  = [System.String](Get-Location) + "\Files\Tools\Compression\Decompress.exe"
    $Files.tool.ndec                        = [System.String](Get-Location) + "\Files\Tools\Compression\ndec.exe"
    $Files.tool.sm64extend                  = [System.String](Get-Location) + "\Files\Tools\Compression\sm64extend.exe"
    $Files.tool.TabExt64                    = [System.String](Get-Location) + "\Files\Tools\Compression\TabExt64.exe"
    $Files.tool.TabExt32                    = [System.String](Get-Location) + "\Files\Tools\Compression\TabExt32.exe"

    $Files.tool.flips                       = [System.String](Get-Location) + "\Files\Tools\Patching\flips.exe"
    $Files.tool.ups                         = [System.String](Get-Location) + "\Files\Tools\Patching\ups.exe"
    $Files.tool.xdelta                      = [System.String](Get-Location) + "\Files\Tools\Patching\xdelta.exe"
    $Files.tool.xdelta3                     = [System.String](Get-Location) + "\Files\Tools\Patching\xdelta3.exe"
    $Files.tool.applyPPF3                   = [System.String](Get-Location) + "\Files\Tools\Patching\ApplyPPF3.exe"

    $Files.tool.rn64crc                     = [System.String](Get-Location) + "\Files\Tools\Verification\rn64crc.exe"

    $Files.tool.wadpacker                   = [System.String](Get-Location) + "\Files\Tools\Wii VC\wadpacker.exe"
    $Files.tool.wadunpacker                 = [System.String](Get-Location) + "\Files\Tools\Wii VC\wadunpacker.exe"
    $Files.tool.wszst                       = [System.String](Get-Location) + "\Files\Tools\Wii VC\wszst.exe"
    $Files.tool.cygcrypto                   = [System.String](Get-Location) + "\Files\Tools\Wii VC\cygcrypto-0.9.8.dll"
    $Files.tool.cyggccs1                    = [System.String](Get-Location) + "\Files\Tools\Wii VC\cyggcc_s-1.dll"
    $Files.tool.cygncursesw10               = [System.String](Get-Location) + "\Files\Tools\Wii VC\cygncursesw-10.dll"
    $Files.tool.cygpng1616                  = [System.String](Get-Location) + "\Files\Tools\Wii VC\cygpng16-16.dll"
    $Files.tool.cygwin1                     = [System.String](Get-Location) + "\Files\Tools\Wii VC\cygwin1.dll"
    $Files.tool.cygz                        = [System.String](Get-Location) + "\Files\Tools\Wii VC\cygz.dll"
    $Files.tool.lzss                        = [System.String](Get-Location) + "\Files\Tools\Wii VC\lzss.exe"
    $Files.tool.romc                        = [System.String](Get-Location) + "\Files\Tools\Wii VC\romc.exe"
    $Files.tool.romchu                      = [System.String](Get-Location) + "\Files\Tools\Wii VC\romchu.exe"



    # Store sound files
    $Files.sound.done                       = [System.String](Get-Location) + "\Files\Main\Done.wav"



    # Store Ocarina of Time files
    $Files.oot.widescreen                   = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\widescreen")
    $Files.oot.master_quest                 = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\master_quest")
    $Files.oot.mm_pause_screen              = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\mm_pause_screen")
    $Files.oot.harder_child_bosses          = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\harder_child_bosses")
    $Files.oot.link_model_child_mm          = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Models\mm_child")

    $Files.oot.lens_of_truth                = $Paths.Games + "\Ocarina of Time\Textures\Lens of Truth.bin"
    $Files.oot.title_copyright              = $Paths.Games + "\Ocarina of Time\Textures\Logo\Master Quest Title Copyright.bin"
    $Files.oot.title_master_quest           = $Paths.Games + "\Ocarina of Time\Textures\Logo\Master Quest Title Logo.bin"
    $Files.oot.hud_mm_hearts                = $Paths.Games + "\Ocarina of Time\Textures\HUD\MM Hearts.bin"
    $Files.oot.hud_mm_button                = $Paths.Games + "\Ocarina of Time\Textures\HUD\MM Button.bin"
    $Files.oot.hud_mm_key_rupee             = $Paths.Games + "\Ocarina of Time\Textures\HUD\MM Key & Rupee.bin"
    $Files.oot.hud_tatl                     = $Paths.Games + "\Ocarina of Time\Textures\HUD\Tatl.bin"
    $Files.oot.hud_tael                     = $Paths.Games + "\Ocarina of Time\Textures\HUD\Tael.bin"

    $Files.oot.l_target_button              = $Paths.Games + "\Ocarina of Time\Textures\GameCube\L Pause Screen Button.bin"
    $Files.oot.l_target_icon                = $Paths.Games + "\Ocarina of Time\Textures\GameCube\L Text Icon.bin"

    $Files.oot.file_select                  = $Paths.Games + "\Ocarina of Time\Binaries\File Select.bin"
    $Files.oot.message_table_restore_text   = $Paths.Games + "\Ocarina of Time\Binaries\Message\Table Restore Text.tbl"
    $Files.oot.message_table_female_text    = $Paths.Games + "\Ocarina of Time\Binaries\Message\Table Female Pronouns.tbl"
    $Files.oot.message_songs                = $Paths.Games + "\Ocarina of Time\Binaries\Message\Songs.bin"
    $Files.oot.message_mq1                  = $Paths.Games + "\Ocarina of Time\Binaries\Message\MQ Navi Action.bin"
    $Files.oot.message_mq2                  = $Paths.Games + "\Ocarina of Time\Binaries\Message\MQ Navi Door.bin"
    $Files.oot.mm_link_voices               = $Paths.Games + "\Ocarina of Time\Binaries\Voices\MM Link Voices.bin"
    $Files.oot.feminine_link_voices         = $Paths.Games + "\Ocarina of Time\Binaries\Voices\Feminine Link Voices.bin"
    $Files.oot.fire_temple_bank             = $Paths.Games + "\Ocarina of Time\Binaries\Fire Temple Theme\12AudioBankPointers.bin"
    $Files.oot.fire_temple_seq              = $Paths.Games + "\Ocarina of Time\Binaries\Fire Temple Theme\12AudioSeqPointers.bin"
    $Files.oot.fire_temple_table            = $Paths.Games + "\Ocarina of Time\Binaries\Fire Temple Theme\12AudioTablePointers.bin"
    $Files.oot.theme_fire_temple            = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Export\audiobank_fire_temple")
    $Files.oot.debug_map_select             = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Export\debug_map_select")
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

    $Files.mm.widescreen                    = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Decompressed\widescreen")
    $Files.mm.improved_link_model           = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Decompressed\improved_link_model")
    $Files.mm.mq_remix                      = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Decompressed\master_quest_remix")

    $Files.mm.hud_oot_button                = $Paths.Games + "\Majora's Mask\Textures\HUD\OoT Button.bin"
    $Files.mm.hud_oot_hearts                = $Paths.Games + "\Majora's Mask\Textures\HUD\OoT Hearts.bin"

    $Files.mm.l_target_button               = $Paths.Games + "\Majora's Mask\Textures\GameCube\L Pause Screen Button.yaz0"
    $Files.mm.l_target_button               = $Paths.Games + "\Majora's Mask\Textures\GameCube\L Text Icon.bin"

    $Files.mm.carnival_of_time              = $Paths.Games + "\Majora's Mask\Textures\Widescreen\Carnival of Time.bin"
    $Files.mm.four_giant                    = $Paths.Games + "\Majora's Mask\Textures\Widescreen\Four Giants.bin"
    $Files.mm.lens_of_truth                 = $Paths.Games + "\Majora's Mask\Textures\Widescreen\Lens of Truth.bin"

    $Files.mm.goron_red_runic               = $Paths.Games + "\Majora's Mask\Textures\Recolor\Goron Red Tunic.bin"
    $Files.mm.zora_blue_gradient            = $Paths.Games + "\Majora's Mask\Textures\Recolor\Zora Blue Gradient.bin"
    $Files.mm.zora_blue_palette             = $Paths.Games + "\Majora's Mask\Textures\Recolor\Zora Blue Palette.bin"

    $Files.mm.romani_ranch                  = $Paths.Games + "\Majora's Mask\Textures\Romani Sign.bin"
    $Files.mm.skull_kid_beak                = $Paths.Games + "\Majora's Mask\Textures\Skull Kid Beak.bin"

    $Files.mm.zora_physics_fix              = $Paths.Games + "\Majora's Mask\Binaries\Zora Physics Fix.bin"

    $Files.mm.message_table_restore_text    = $Paths.Games + "\Majora's Mask\Binaries\Message\Table Restore Text.tbl"
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

    $Files.flipscfg                         = [System.String](Get-Location) + "\Files\Tools\Patching\flipscfg.bin"
    $Files.ckey                             = [System.String](Get-Location) + "\Files\Temp\common-key.bin"
    $Files.stackdump                        = [System.String](Get-Location) + "\Files\Tools\Wii VC\wadpacker.exe.stackdump"
    $Files.dmaTable                         = [System.String](Get-Location) + "\Files\Temp\dmaTable.dat"
    $Files.archive                          = [System.String](Get-Location) + "\Files\Temp\ARCHIVE.bin"
    $Files.settings                         = $Paths.Settings + "\Core.ini"

    # Clear data
    $Files.oot = $Files.mm = $Files.sm64 = $null

}



#==============================================================================================================================================================================================
function SetGetROM() {

    # Store misc files
    CreatePath $Paths.Temp

    $global:GetROM = @{}
    $GetROM.romc                            = [System.String](Get-Location) + "\Files\Temp\romc"
    $GetROM.clean                           = [System.String](Get-Location) + "\Files\Temp\clean"
    $GetROM.cleanDecomp                     = [System.String](Get-Location) + "\Files\Temp\clean-decompressed"
    $GetROM.decomp                          = [System.String](Get-Location) + "\Files\Temp\decompressed"
    $GetROM.masterQuest                     = [System.String](Get-Location) + "\Files\Temp\master-quest-decompressed"
    $GetROM.nes                             = [System.String](Get-Location) + "\Files\Temp\rom.nes"

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

    if ($GetROM.in -ne $null) {
        $GetROM.run = $GetROM.in
        $global:ROMHashSum = (Get-FileHash -Algorithm MD5 $GetROM.in).Hash
    }

    if ($Settings.Debug.CreateBPS -eq $True) {
        $Files.compBPS   = [System.IO.Path]::GetDirectoryName($GetROM.in) + "\" + [System.IO.Path]::GetFileNameWithoutExtension($GetROM.in) + "_compressed.bps"
        $Files.decompBPS = [System.IO.Path]::GetDirectoryName($GetROM.in) + "\" + [System.IO.Path]::GetFileNameWithoutExtension($GetROM.in) + "_decompressed.bps"
    }

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
    
    if ($Settings.Core.EnableSounds -eq $True) { $Sound.playsync() } 

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function SetFileParameters
Export-ModuleMember -Function SetGetROM
Export-ModuleMember -Function CheckPatchExtension
Export-ModuleMember -Function LoadSoundEffects
Export-ModuleMember -Function PlaySound