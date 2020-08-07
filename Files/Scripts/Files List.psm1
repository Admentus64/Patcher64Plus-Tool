function SetFileParameters() {
    
    # Create a hash table.
    $global:Files = @{}
    $Files.tool = @{}
    $Files.oot = @{}
    $Files.mm = @{}
    $Files.sm64 = @{}
    $Files.json = @{}
    $Files.icon = @{}
    $Files.text = @{}



    # Store all tool files
    $Files.tool.flips                       = $Paths.Master + "\Base\flips.exe"
    $Files.tool.rn64crc                     = $Paths.Master + "\Base\rn64crc.exe"
    $Files.tool.xdelta                      = $Paths.Master + "\Base\xdelta.exe"
    $Files.tool.xdelta3                     = $Paths.Master + "\Base\xdelta3.exe"
    $Files.tool.applyPPF3                   = $Paths.Master + "\Base\ApplyPPF3.exe"

    $Files.tool.Compress                    = $Paths.Master + "\Compression\Compress.exe"
    $Files.tool.Compress32                  = $Paths.Master + "\Compression\Compress32.exe"
    $Files.tool.ndec                        = $Paths.Master + "\Compression\ndec.exe"
    $Files.tool.sm64extend                  = $Paths.Master + "\Compression\sm64extend.exe"
    $Files.tool.TabExt                      = $Paths.Master + "\Compression\TabExt.exe"
    $Files.tool.TabExt32                    = $Paths.Master + "\Compression\TabExt32.exe"
    
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
    $Files.oot.dawn_rev1                    = CheckPatchExtension -File ($Paths.Games + "\Ocarina of Time\Compressed\dawn_rev1")
    $Files.oot.dawn_rev2                    = CheckPatchExtension -File ($Paths.Games + "\Ocarina of Time\Compressed\dawn_rev2")
    $Files.oot.master_quest                 = CheckPatchExtension -File ($Paths.Games + "\Ocarina of Time\Decompressed\master_quest")
    $Files.oot.child_model                  = CheckPatchExtension -File ($Paths.Games + "\Ocarina of Time\Decompressed\Models\child_model")
    $Files.oot.adult_model                  = CheckPatchExtension -File ($Paths.Games + "\Ocarina of Time\Decompressed\Models\adult_model")
    $Files.oot.female_models                = CheckPatchExtension -File ($Paths.Games + "\Ocarina of Time\Decompressed\Models\female_models")

    $Files.oot.lens_of_truth                = $Paths.Games + "\Ocarina of Time\Textures\Lens of Truth.bin"
    $Files.oot.title_copyright              = $Paths.Games + "\Ocarina of Time\Textures\Logo\Master Quest Title Copyright.bin"
    $Files.oot.title_master_quest           = $Paths.Games + "\Ocarina of Time\Textures\Logo\Master Quest Title Logo.bin"
    $Files.oot.hud_mm_hearts                = $Paths.Games + "\Ocarina of Time\Textures\HUD\MM HUD Hearts.bin"
    $Files.oot.hud_mm_button                = $Paths.Games + "\Ocarina of Time\Textures\HUD\MM HUD Button.bin"
    $Files.oot.hud_mm_key_rupee             = $Paths.Games + "\Ocarina of Time\Textures\HUD\MM HUD Key & Rupee.bin"
    $Files.oot.file_select_1                = $Paths.Games + "\Ocarina of Time\Binaries\File Select.bin"
    $Files.oot.message_table_restore        = $Paths.Games + "\Ocarina of Time\Binaries\Message\Table Restore.bin"
    $Files.oot.message_table_girl           = $Paths.Games + "\Ocarina of Time\Binaries\Message\Table Girl.bin"
    $Files.oot.message_songs                = $Paths.Games + "\Ocarina of Time\Binaries\Message\Songs.bin"
    $Files.oot.message_mq1                  = $Paths.Games + "\Ocarina of Time\Binaries\Message\MQ Navi Action.bin"
    $Files.oot.message_mq2                  = $Paths.Games + "\Ocarina of Time\Binaries\Message\MQ Navi Door.bin"
    $Files.oot.mm_link_voices               = $Paths.Games + "\Ocarina of Time\Binaries\Voices\MM Link Voices.bin"
    $Files.oot.feminine_link_voices         = $Paths.Games + "\Ocarina of Time\Binaries\Voices\Feminine Link Voices.bin"
    $Files.oot.fire_temple_bank             = $Paths.Games + "\Ocarina of Time\Binaries\Fire Temple Theme\12AudioBankPointers.bin"
    $Files.oot.fire_temple_seq              = $Paths.Games + "\Ocarina of Time\Binaries\Fire Temple Theme\12AudioSeqPointers.bin"
    $Files.oot.fire_temple_table            = $Paths.Games + "\Ocarina of Time\Binaries\Fire Temple Theme\12AudioTablePointers.bin"
    $Files.oot.theme_fire_temple            = CheckPatchExtension -File ($Paths.Master + "\Data Extraction\Fire Temple Theme\12FireTemple")

    for ($i=1; $i -le 21; $i++) {
        if ($i -ne 6) { $Files.oot["gerudo_" + $i] = $Paths.Games + "\Ocarina of Time\Textures\Gerudo Symbols\" + $i + ".bin" }
    }



    # Store Majora's Mask files
    $Files.mm.troupe_leaders_mask           = $Paths.Games + "\Majora's Mask\Textures\Troupe Leader's Mask.yaz0"
    $Files.mm.carnival_of_time              = $Paths.Games + "\Majora's Mask\Textures\Carnival of Time.bin"
    $Files.mm.four_giant                    = $Paths.Games + "\Majora's Mask\Textures\Four Giants.bin"
    $Files.mm.lens_of_truth                 = $Paths.Games + "\Majora's Mask\Textures\Lens of Truth.bin"
    $Files.mm.romani_ranch                  = $Paths.Games + "\Majora's Mask\Textures\Romani Sign.bin"
    $Files.mm.skull_kid_beak                = $Paths.Games + "\Majora's Mask\Textures\Skull Kid Beak.bin"
    $Files.mm.message_table                 = $Paths.Games + "\Majora's Mask\Binaries\Message\Table.bin"
    $Files.mm.message_razor1                = $Paths.Games + "\Majora's Mask\Binaries\Message\Razor Sword 1.bin"
    $Files.mm.message_razor2                = $Paths.Games + "\Majora's Mask\Binaries\Message\Razor Sword 2.bin"

    $Files.mm.southern_swamp_cleared        = CheckPatchExtension -File ($Paths.Master + "\Data Extraction\Southern Swamp\southern_swamp_cleared_scene")
    $Files.mm.southern_swamp_cleared_0      = CheckPatchExtension -File ($Paths.Master + "\Data Extraction\Southern Swamp\southern_swamp_cleared_room_0")
    $Files.mm.southern_swamp_cleared_2      = CheckPatchExtension -File ($Paths.Master + "\Data Extraction\Southern Swamp\southern_swamp_cleared_room_2")
    $Files.mm.deku_palace                   = CheckPatchExtension -File ($Paths.Master + "\Data Extraction\Deku Palace\deku_palace_scene")
    $Files.mm.deku_palace_0                 = CheckPatchExtension -File ($Paths.Master + "\Data Extraction\Deku Palace\deku_palace_room_0")
    $Files.mm.deku_palace_1                 = CheckPatchExtension -File ($Paths.Master + "\Data Extraction\Deku Palace\deku_palace_room_1")
    $Files.mm.deku_palace_2                 = CheckPatchExtension -File ($Paths.Master + "\Data Extraction\Deku Palace\deku_palace_room_2")



    # Store Super Mario 64 files
    $Files.sm64.cam                         = CheckPatchExtension -File ($Paths.Games + "\Super Mario 64\Compressed\cam")
    $Files.sm64.fps                         = CheckPatchExtension -File ($Paths.Games + "\Super Mario 64\Compressed\fps")



    # Store JSON files
    $Files.json.games                       = $Paths.Games + "\Games.json"



    # Store ICO files
    $Files.icon.main                        = $Paths.Main + "\Main.ico"
    $Files.icon.gameID                      = $Paths.Main + "\GameID.ico"
    $Files.icon.credits                     = $Paths.Main + "\Credits.ico"



    # Store text files
    $Files.text.credits                     = $Paths.Main + "\Credits.txt"
    $Files.text.gameID                      = $Paths.Main + "\GameID.txt"


    # Check if all files so far exist
    CheckFilesExists -HashTable $Files.tool
    CheckFilesExists -HashTable $Files.oot
    CheckFilesExists -HashTable $Files.mm
    CheckFilesExists -HashTable $Files.sm64
    CheckFilesExists -HashTable $Files.json
    CheckFilesExists -HashTable $Files.icon



    # Store misc files
    $Files.outROM                           = $Paths.Master + "\out"
    $Files.cleanROM                         = $Paths.Master + "\clean.z64"
    $Files.cleanDecompressedROM             = $Paths.Master + "\clean-decompressed"
    $Files.decompressedROM                  = $Paths.Master + "\decompressed"
    $Files.masterQuestROM                   = $Paths.Master + "\master-quest-decompressed"

    $Files.flipscfg                         = $Paths.Master + "\Base\flipscfg.bin"
    $Files.ckey                             = $Paths.Master + "\Wii VC\common-key.bin"

    $Files.stackdump                        = $Paths.WiiVC + "\wadpacker.exe.stackdump"

    $Files.dmaTable                         = $Paths.Base + "\dmaTable.dat"
    $Files.archive                          = $Paths.Base + "\ARCHIVE.bin"
    $Files.settings                         = $Paths.Base + "\Settings.ini"



    # Clear data
    $Files.oot = $Files.mm = $Files.sm64 = $null

}



#==============================================================================================================================================================================================
function CheckFilesExists([hashtable]$HashTable) {
    
    $HashTable.GetEnumerator() | ForEach-Object {
        if ( !(Test-Path $_.value -PathType Leaf) -and (IsSet -Elem $_.value) ) { CreateErrorDialog -Error "Missing Files" -Exit }
    }

}



#==============================================================================================================================================================================================
function CheckPatchExtension([String]$File) {
    
    if (Test-Path ($File + ".bps") -PathType Leaf)      { return $File + ".bps" }
    if (Test-Path ($File + ".ips") -PathType Leaf)      { return $File + ".ips" }
    if (Test-Path ($File + ".xdelta") -PathType Leaf)   { return $File + ".xdelta" }
    if (Test-Path ($File + ".vcdiff") -PathType Leaf)   { return $File + ".vcdiff" }
    if (Test-Path ($File + ".ppf") -PathType Leaf)      { return $File + ".ppf" }
    return $File

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function SetFileParameters