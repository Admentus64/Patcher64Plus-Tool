function SetTempFileParameters() {
    
    $Files.ckey                             = $Paths.Temp + "\common-key.bin"
    $Files.dmaTable                         = $Paths.Temp + "\dmaTable.dat"
    $Files.archive                          = $Paths.Temp + "\ARCHIVE.bin"

}



#==============================================================================================================================================================================================
function SetFileParameters() {
    
    # Create a hash table
    $global:Files = @{}
    $Files.tool   = @{}
    $Files.sound  = @{}
    $Files.oot    = @{}
    $Files.mm     = @{}
    $Files.sm64   = @{}
    $Files.ge007  = @{}
    $Files.json   = @{}
    $Files.icon   = @{}
    $Files.text   = @{}



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
    $Files.tool.zzobjman                    = (GetFilePath) + "\Files\Tools\Patching\zzobjman.exe"

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

    $Files.tool.zip                         = (GetFilePath) + "\Files\Tools\Zip\7z.exe"

    $Files.tool.timidity                    = (GetFilePath) + "\Files\Tools\timidity.exe"



    # Store sound files
    $Files.sound.done                       = $Paths.FullBase + "\Files\Main\Done.wav"



    # Store Ocarina of Time files
    $Files.oot.ura_quest                    = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Dungeons\ura_quest")
    $Files.oot.master_quest                 = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Dungeons\master_quest")

    $Files.oot.feminine_animations          = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Optional\feminine_animations")
    $Files.oot.harder_child_bosses          = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Optional\harder_child_bosses")
    $Files.oot.mm_pause_screen              = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Optional\mm_pause_screen")
    $Files.oot.pots_challenge               = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Optional\pots_challenge")
    $Files.oot.widescreen_1                 = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Optional\Widescreen\widescreen_dawn_and_dusk")
    $Files.oot.widescreen_2                 = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Optional\Widescreen\widescreen_hide_geometry")
    $Files.oot.widescreen_3                 = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Optional\Widescreen\widescreen_minimum")
    $Files.oot.widescreen_4                 = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Optional\Widescreen\widescreen_redux_hotfix")
    $Files.oot.child_quest_oot              = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Optional\Child Quest\model_oot")
    $Files.oot.child_quest_mm               = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Optional\Child Quest\model_mm")
    $Files.oot.child_quest_base             = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Optional\Child Quest\baserom")
    $Files.oot.child_quest_header           = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Decompressed\Optional\Child Quest\headers")

    $Files.oot.lens_of_truth                = $Paths.Games + "\Ocarina of Time\Textures\widescreen\lens_of_truth.bin"
    $Files.oot.title_mq_copyright           = $Paths.Games + "\Ocarina of Time\Textures\Logo\mq_copyright.bin"
    $Files.oot.title_mq_logo                = $Paths.Games + "\Ocarina of Time\Textures\Logo\mq_logo.bin"
    $Files.oot.title_ura_copyright          = $Paths.Games + "\Ocarina of Time\Textures\Logo\ura_copyright.bin"
    $Files.oot.title_ura_logo               = $Paths.Games + "\Ocarina of Time\Textures\Logo\ura_logo.bin"
    
    $Files.oot.l_pause_button               = $Paths.Games + "\Ocarina of Time\Textures\GameCube\l_pause_screen_button.bin"
    $Files.oot.l_pause_button_mm            = $Paths.Games + "\Ocarina of Time\Textures\GameCube\l_pause_screen_button_mm.bin"
    $Files.oot.l_target_icon                = $Paths.Games + "\Ocarina of Time\Textures\GameCube\l_text_icon.bin"

    $Files.oot.frontflip_jump               = $Paths.Games + "\Ocarina of Time\Binaries\Jumps\frontflip.bin"
    $Files.oot.somarsault_jump              = $Paths.Games + "\Ocarina of Time\Binaries\Jumps\somarsault.bin"
    $Files.oot.message_credits              = $Paths.Games + "\Ocarina of Time\Binaries\Message\credits.bin"
    $Files.oot.fire_temple_bank             = $Paths.Games + "\Ocarina of Time\Binaries\Fire Temple Theme\audiobank_pointers.bin"
    $Files.oot.fire_temple_seq              = $Paths.Games + "\Ocarina of Time\Binaries\Fire Temple Theme\audioseq_pointers.bin"
    $Files.oot.fire_temple_table            = $Paths.Games + "\Ocarina of Time\Binaries\Fire Temple Theme\audiotable_pointers.bin"

    $Files.oot.theme_fire_temple            = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Export\audiobank_fire_temple")
    $Files.oot.debug_map_select             = CheckPatchExtension ($Paths.Games + "\Ocarina of Time\Export\debug_map_select")

    $Files.oot.improved_moon                = $Paths.Games + "\Ocarina of Time\Textures\Moon\improved_moon.bin"

    $Files.oot.gerudo1                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\crystal_switch.bin"
    $Files.oot.gerudo2                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\dampe.bin"
    $Files.oot.gerudo3                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\floor_switch.bin"
    $Files.oot.gerudo4                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\forest_temple_room_11_block.bin"
    $Files.oot.gerudo5                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\forest_temple_room_11_hole.bin"
    $Files.oot.gerudo6                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\ganondorf_cape.bin"
    $Files.oot.gerudo7                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\gerudo_membership_card.bin"
    $Files.oot.gerudo8                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\gerudo_training_ground_room_1_ceiling_frame.bin"
    $Files.oot.gerudo9                      = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\gerudo_training_ground_door.bin"
    $Files.oot.gerudo10                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\gerudo_training_ground_room_5_7.bin"
    $Files.oot.gerudo11                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\gerudo_fortress.bin"
    $Files.oot.gerudo12                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\golden_gauntlets_pillar.bin"
    $Files.oot.gerudo13                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\pushing_block.bin"
    $Files.oot.gerudo14                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\rusted_floor_switch.bin"
    $Files.oot.gerudo15                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\shadow_temple_room_0.bin"
    $Files.oot.gerudo16                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\silver_gauntlets_block.bin"
    $Files.oot.gerudo17                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\spirit_temple_boss.bin"
    $Files.oot.gerudo18                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\spirit_temple_room_0_elevator.bin"
    $Files.oot.gerudo19                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\spirit_temple_room_0_pillars.bin"
    $Files.oot.gerudo20                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\spirit_temple_room_10_20_28.bin"
    $Files.oot.gerudo21                     = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\iron_knuckle.bin"



    # Store Majora's Mask files
    $Files.mm.troupe_leaders_mask_text      = $Paths.Games + "\Majora's Mask\Textures\Icons\troupe_leaders_mask_text.yaz0"
    $Files.mm.deku_pipes_icon1              = $Paths.Games + "\Majora's Mask\Textures\Icons\deku_pipes_original_icon.yaz0"
    $Files.mm.deku_pipes_icon2              = $Paths.Games + "\Majora's Mask\Textures\Icons\deku_pipes_icon.yaz0"
    $Files.mm.deku_pipes_Text               = $Paths.Games + "\Majora's Mask\Textures\Icons\deku_pipes_text.yaz0"
    $Files.mm.goron_drums_icon              = $Paths.Games + "\Majora's Mask\Textures\Icons\goron_drums_icon.yaz0"
    $Files.mm.goron_drums_text              = $Paths.Games + "\Majora's Mask\Textures\Icons\goron_drums_text.yaz0"
    $Files.mm.zora_guitar_icon              = $Paths.Games + "\Majora's Mask\Textures\Icons\zora_guitar_icon.yaz0"
    $Files.mm.zora_guitar_text              = $Paths.Games + "\Majora's Mask\Textures\Icons\zora_guitar_text.yaz0"

    $Files.mm.widescreen                    = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Decompressed\Optional\widescreen")

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

    $Files.mm.southern_swamp_cleared        = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Export\Southern Swamp\southern_swamp_cleared_scene")
    $Files.mm.southern_swamp_cleared_0      = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Export\Southern Swamp\southern_swamp_cleared_room_0")
    $Files.mm.southern_swamp_cleared_2      = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Export\Southern Swamp\southern_swamp_cleared_room_2")
    $Files.mm.deku_palace                   = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Export\Deku Palace\deku_palace_scene")
    $Files.mm.deku_palace_0                 = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Export\Deku Palace\deku_palace_room_0")
    $Files.mm.deku_palace_1                 = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Export\Deku Palace\deku_palace_room_1")
    $Files.mm.deku_palace_2                 = CheckPatchExtension ($Paths.Games + "\Majora's Mask\Export\Deku Palace\deku_palace_room_2")



    # Store Super Mario 64 files
    $Files.sm64.cam                         = CheckPatchExtension ($Paths.Games + "\Super Mario 64\Compressed\Optional\cam")
    $Files.sm64.fps                         = CheckPatchExtension ($Paths.Games + "\Super Mario 64\Compressed\Optional\fps")
    $Files.sm64.fix_burn_smoke              = CheckPatchExtension ($Paths.Games + "\Super Mario 64\Compressed\Optional\fix_burn_smoke")



    # Store GoldenEye 007 files
    $Files.ge007.dual_eyes                  = CheckPatchExtension ($Paths.Games + "\GoldenEye 007\Compressed\Optional\dual_eyes_cooperative")
    $Files.ge007.mouse                      = CheckPatchExtension ($Paths.Games + "\GoldenEye 007\Compressed\Optional\n64_mouse")
    $Files.ge007.blood                      = CheckPatchExtension ($Paths.Games + "\GoldenEye 007\Compressed\Optional\restore_blood")



    # Store JSON files
    $Files.json.repo                        = $Paths.Master + "\repo.json"
    $Files.json.consoles                    = $Paths.Games  + "\Consoles.json"
    $Files.json.games                       = $Paths.Games  + "\Games.json"
    $Files.json.regions                     = $Paths.Games  + "\Regions.json"



    # Store ICO & PNG files
    $Files.icon.main                        = $Paths.Main + "\Main.ico"
    $Files.icon.settings                    = $Paths.Main + "\Settings.ico"
    $Files.icon.credits                     = $Paths.Main + "\Credits.ico"
    $Files.icon.additional                  = $Paths.Main + "\Additional.ico"
    $Files.icon.preview                     = $Paths.Main + "\Preview.ico"
    $Files.icon.previewButton               = $Paths.Main + "\PreviewButton.png"
    $Files.icon.wiiEnabled                  = $Paths.Main + "\Wii Enabled.png"
    $Files.icon.wiiDisabled                 = $Paths.Main + "\Wii Disabled.png"



    # Store text files
    $Files.text.credits                     = $Paths.Base + "\Info\Credits.txt"
    $Files.text.changelog                   = $Paths.Base + "\Info\Changelog.txt"
    $Files.text.mainCredits                 = $Paths.Base + "\Info\Credits.txt"
    $Files.text.gameID                      = $Paths.Main + "\GameID.txt"



    # Check if all files so far exist
    CheckFilesExists $Files.tool
    CheckFilesExists $Files.oot
    CheckFilesExists $Files.mm
    CheckFilesExists $Files.sm64
    CheckFilesExists $Files.ge007
    CheckFilesExists $Files.json
    CheckFilesExists $Files.icon

    $Files.flipscfg                         = (GetFilePath) + "\Files\Tools\Patching\flipscfg.bin"
    $Files.stackdump                        = (GetFilePath) + "\Files\Tools\Wii VC\wadpacker.exe.stackdump"
    $Files.settings                         = $Paths.Settings + "\Core.ini"

    SetTempFileParameters

}



#==============================================================================================================================================================================================
function SetGetROM() {

    # Store misc files
    CreatePath $Paths.Temp

    $global:GetROM = @{}
    $GetROM.romc                            = $Paths.Temp  + "\romc"
    $GetROM.clean                           = $Paths.Temp  + "\clean"
    $GetROM.cleanDecomp                     = $Paths.Temp  + "\clean-decompressed"
    $GetROM.decomp                          = $Paths.Temp  + "\decompressed"
    $GetROM.downgrade                       = $Paths.Temp  + "\downgraded"
    $GetROM.masterQuest                     = $Paths.Temp  + "\master-quest-decompressed"
    $GetROM.converted                       = $Paths.Temp  + "\converted"
    $GetROM.nes                             = $Paths.Temp  + "\rom.nes"
    $GetROM.cache                           = $Paths.Cache + "\cached_rom"
    
    if ($IsWiiVC -and (IsSet $WADFile) ) {
        if (!(IsSet $WADFile.ROM)) { $WADFile.ROM = $GetROM.nes }
        $GetROM.in            = $GetROM.patched = $WADFile.ROM
        $item                 = Get-Item $WADFile.ROM
        $GetROM.keepConvert   = $GamePath.Directory.toString() + "\" + $GamePath.BaseName.toString() + "-converted"    + $item.Extension.toString()
        $GetROM.keepDowngrade = $GamePath.Directory.toString() + "\" + $GamePath.BaseName.toString() + "-downgraded"   + $item.Extension.toString()
        $GetROM.keepDecomp    = $GamePath.Directory.toString() + "\" + $GamePath.BaseName.toString() + "-decompressed" + $item.Extension.toString()
    }
    elseif (!$IsWiiVC -and (IsSet $ROMFile) ) {
        $GetROM.in            = $ROMFile.ROM
        $GetROM.patched       = $ROMFile.Patched
        $item                 = Get-Item $ROMFile.ROM
        $GetROM.keepConvert   = $GamePath.Directory.toString() + "\" + $GamePath.BaseName.toString() + "-converted"    + $item.Extension.toString()
        $GetROM.keepDowngrade = $GamePath.Directory.toString() + "\" + $GamePath.BaseName.toString() + "-downgraded"   + $item.Extension.toString()
        $GetROM.keepDecomp    = $GamePath.Directory.toString() + "\" + $GamePath.BaseName.toString() + "-decompressed" + $item.Extension.toString()
    }
    
    if ($GetROM.in -ne $null) { $GetROM.run = $GetROM.in }

    if ($Settings.Debug.CreateCompressedBPS   -eq $True)                              { $Files.compBPS   = [System.IO.Path]::GetDirectoryName($GamePath) + "\" + [System.IO.Path]::GetFileNameWithoutExtension($GamePath) + "_compressed.bps"   }
    if ($Settings.Debug.CreateDecompressedBPS -eq $True -or (DoExtractSceneFiles) )   { $Files.decompBPS = [System.IO.Path]::GetDirectoryName($GamePath) + "\" + [System.IO.Path]::GetFileNameWithoutExtension($GamePath) + "_decompressed.bps" }  

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
function GetImageFile([string]$Path="") {
    
    if ($Path -eq "")   { return $null }
    if     (Test-Path -LiteralPath  $Path           -PathType Leaf) { return $Path          }
    if     (Test-Path -LiteralPath ($Path + ".png") -PathType Leaf) { return $Path + ".png" }
    elseif (Test-Path -LiteralPath ($Path + ".jpg") -PathType Leaf) { return $Path + ".jpg" }
    return $null

}



#==============================================================================================================================================================================================
function IsROMFile([string]$Ext="") {
    
    if ($Ext -eq ".z64" -or $Ext -eq ".n64" -or $Ext -eq ".v64" -or $Ext -eq ".sfc" -or $Ext -eq ".smc" -or $Ext -eq ".nes" -or $Ext -eq ".gbc" -or $Ext -eq ".gba") { return $True }
    return $False

}



#==============================================================================================================================================================================================
function IsPatchFile([string]$Ext="") {
    
    if ($Ext -eq ".bps" -or $Ext -eq ".ips" -or $Ext -eq ".ups" -or $Ext -eq ".ppf" -or $Ext -eq ".xdelta" -or $Ext -eq ".vcdiff") { return $True }
    return $False

}



#==============================================================================================================================================================================================
function IsZipFile([string]$Ext="") {
    
    if ($Ext -eq ".zip" -or $Ext -eq ".rar" -or $Ext -eq ".7z") { return $True }
    return $False

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function SetTempFileParameters
Export-ModuleMember -Function SetFileParameters
Export-ModuleMember -Function SetGetROM
Export-ModuleMember -Function CheckPatchExtension
Export-ModuleMember -Function LoadSoundEffects
Export-ModuleMember -Function PlaySound
Export-ModuleMember -Function GetImageFile
Export-ModuleMember -Function IsROMFile
Export-ModuleMember -Function IsPatchFile
Export-ModuleMember -Function IsZipFile