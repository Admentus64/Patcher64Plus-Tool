function PatchDungeonsMQ() {
    
    # BYTE PATCHING MASTER QUEST DUNGEONS
    if (IsChecked -Elem $Redux.MQ.Disable) { return }

    if (!(Test-Path -LiteralPath ($GameFiles.extracted + "\Master Quest") -PathType Container)) {
        WriteToConsole ('Error: "' + ($GameFiles.extracted + "\Master Quest") + '" was not found')
        return
    }

    UpdateStatusLabel ("Patching " + $GameType.mode + " Master Quest Dungeons...")

    if (IsChecked -Elem $Redux.MQ.Randomize) {
        $min = $Redux.MQ.Minimum.Text.replace(" (default)", "")
        $max = $Redux.MQ.Maximum.Text.replace(" (default)", "")
        $dungeons = @("InsideTheDekuTree", "DodongosCavern", "InsideJabuJabusBelly", "ForestTemple", "FireTemple", "WaterTemple", "ShadowTemple", "SpiritTemple", "IceCavern", "BottomOfTheWell", "GerudoTrainingGround", "InsideGanonsCastle")
        $Count = (Get-Random -Minimum $min -Maximum $max)
        if ($Count -gt 0) { $RandomizedDungeons = ($dungeons | Get-Random -Count $Count) }
    }

    # Title
    if ($Settings.Debug.KeepLogo -ne $True) {
        PatchBytes -Offset "1795300" -Length "19000" -Texture -Patch "Logo\Master Quest Title Logo.bin"
        PatchBytes -Offset "17AE380" -Length "700"   -Texture -Patch "Logo\Master Quest Title Copyright.bin"
        ChangeBytes -Offset "E6E266"  -Values @("64", "96", "34", "21", "FF") # THE LEGEND OF
        ChangeBytes -Offset "E6E2A6"  -Values @("14", "50", "35", "8C", "A0") # OCARINA OF TIME
        ChangeBytes -Offset "E6E2A6"  -Values @("08", "5C", "35", "8C", "98") # Title color
        ChangeBytes -Offset "E6C4BC"  -Values @("3C", "01", "43", "48", "44", "81", "30", "00", "E4", "60", "62", "D8", "E4", "60", "62", "DC", "E4", "60", "62", "E4", "E4", "64", "62", "D4", "E4", "66", "62", "E0")
        ChangeBytes -Offset "E6C764"  -Values @("3C", "01", "43", "2A", "44", "81", "50", "00", "26", "01", "7F", "FF", "24", "0A", "00", "02", "E4", "42", "62", "D8", "E4", "42", "62", "DC", "E4", "42", "62", "E4", "E4", "48", "62", "D4", "E4", "4A", "62", "E0")
        ChangeBytes -Offset "E6C9F0"  -Values @("3C", "01", "BF", "B0", "C4", "44", "62", "D4", "44", "81", "80", "00", "C4", "4A", "62", "E0", "46", "06", "22", "00", "84", "4E", "62", "CA", "26", "01", "7F", "FF", "46", "10", "54", "80", "E4", "48", "62", "D4", "25", "CF", "FF", "FF", "E4", "52", "62", "E0")
        ChangeBytes -Offset "E6CA48"  -Values @("3C", "01", "43", "48", "44", "81", "40", "00", "26", "01", "7F", "FF", "E4", "46", "62", "D4", "E4", "48", "62", "E0")
    }

    # Inside the Deku Tree
    if ( (IsChecked -Elem $Redux.MQ.InsideTheDekuTree) -or ($RandomizedDungeons -Contains "InsideTheDekuTree") ) { 
        UpdateStatusLabel "Patching MQ Dungeon: Inside the Deku Tree"
        if (!(PatchDungeon -TableOffset "BB40" -Path "Master Quest\Inside the Deku Tree\" -Length 12 -Scene "B71440")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "0") ) )    -Patch "Master Quest Chests\Inside the Deku Tree\Mainmap Chests.bin"
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "0") ) )    -Patch "Master Quest Chests\Inside the Deku Tree\Minimap Chests.bin"
    }

    # Dodongo's Cavern
    if ( (IsChecked -Elem $Redux.MQ.DodongosCavern) -or ($RandomizedDungeons -Contains "DodongosCavern") ) {
        UpdateStatusLabel "Patching MQ Dungeon: Dodongo's Cavern"
        if (!(PatchDungeon -TableOffset "B320" -Path "Master Quest\Dodongo's Cavern\" -Length 17 -Scene "B71454")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "99C") ) )  -Patch "Master Quest Chests\Dodongo's Cavern\Mainmap Chests.bin"
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "5CC") ) )  -Patch "Master Quest Chests\Dodongo's Cavern\Minimap Chests.bin"
    }

    # Inside Jabu-Jabu's Belly
    if ( (IsChecked -Elem $Redux.MQ.InsideJabuJabusBelly) -or ($RandomizedDungeons -Contains "InsideJabuJabusBelly") ) {
        UpdateStatusLabel "Patching MQ Dungeon: Inside Jabu-Jabu's Belly"
        if (!(PatchDungeon -TableOffset "BF50" -Path "Master Quest\Inside Jabu-Jabu's Belly\" -Length 16 -Scene "B71468")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "D74") ) )  -Patch "Master Quest Chests\Inside Jabu-Jabu's Belly\Mainmap Chests.bin"
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "E44") ) )  -Patch "Master Quest Chests\Inside Jabu-Jabu's Belly\Minimap Chests.bin"
    }

    # Forest Temple
    if ( (IsChecked -Elem $Redux.MQ.ForestTemple) -or ($RandomizedDungeons -Contains "ForestTemple") ) {
        UpdateStatusLabel "Patching MQ Dungeon: Forest Temple"
        if (!(PatchDungeon -TableOffset "B9C0" -Path "Master Quest\Forest Temple\" -Length 23 -Scene "B7147C")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "114C") ) ) -Patch "Master Quest Chests\Forest Temple\Mainmap Chests.bin"
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "15D8") ) ) -Patch "Master Quest Chests\Forest Temple\Minimap Chests.bin"
    }

    # Fire Temple
    if ( (IsChecked -Elem $Redux.MQ.FireTemple) -or ($RandomizedDungeons -Contains "FireTemple") ) {
        UpdateStatusLabel "Patching MQ Dungeon: Fire Temple"
        if (!(PatchDungeon -TableOffset "B800" -Path "Master Quest\Fire Temple\" -Length 27 -Scene "B71490")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "18FC") ) ) -Patch "Master Quest Chests\Fire Temple\Mainmap Chests.bin"
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "21E0") ) ) -Patch "Master Quest Chests\Fire Temple\Minimap Chests.bin"
    }

    # Water Temple
    if ( (IsChecked -Elem $Redux.MQ.WaterTemple) -or ($RandomizedDungeons -Contains "WaterTemple") ) {
        UpdateStatusLabel "Patching MQ Dungeon: Water Temple"
        if (!(PatchDungeon -TableOffset "BCA0" -Path "Master Quest\Water Temple\" -Length 23 -Scene "B714A4")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "2298") ) ) -Patch "Master Quest Chests\Water Temple\Mainmap Chests.bin"
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "32CC") ) ) -Patch "Master Quest Chests\Water Temple\Minimap Chests.bin"
    }

    # Shadow Temple
    if ( (IsChecked -Elem $Redux.MQ.ShadowTemple) -or ($RandomizedDungeons -Contains "ShadowTemple") ) {
        UpdateStatusLabel "Patching MQ Dungeon: Shadow Temple"
        if (!(PatchDungeon -TableOffset "C060" -Path "Master Quest\Shadow Temple\" -Length 23 -Scene "B714CC")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "31F8") ) ) -Patch "Master Quest Chests\Shadow Temple\Mainmap Chests.bin"
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "5518") ) ) -Patch "Master Quest Chests\Shadow Temple\Minimap Chests.bin"
    }
    
    # Spirit Temple
    if ( (IsChecked -Elem $Redux.MQ.SpiritTemple) -or ($RandomizedDungeons -Contains "SpiritTemple") ) {
        UpdateStatusLabel "Patching MQ Dungeon: Spirit Temple"
        if (!(PatchDungeon -TableOffset "C450" -Path "Master Quest\Spirit Temple\" -Length 29 -Scene "B714B8")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "2A48") ) ) -Patch "Master Quest Chests\Spirit Temple\Mainmap Chests.bin"
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "4664") ) ) -Patch "Master Quest Chests\Spirit Temple\Minimap Chests.bin"
    }

    # Ice Cavern
    if ( (IsChecked -Elem $Redux.MQ.IceCavern) -or ($RandomizedDungeons -Contains "IceCavern") ) {
        UpdateStatusLabel "Patching MQ Dungeon: Ice Cavern"
        if (!(PatchDungeon -TableOffset "C630" -Path "Master Quest\Ice Cavern\" -Length 12 -Scene "B714F4")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "3F6C") ) ) -Patch "Master Quest Chests\Ice Cavern\Mainmap Chests.bin"
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "6594") ) ) -Patch "Master Quest Chests\Ice Cavern\Minimap Chests.bin"
    }

    # Bottom of the Well
    if ( (IsChecked -Elem $Redux.MQ.BottomOfTheWell) -or ($RandomizedDungeons -Contains "BottomOfTheWell") ) { 
        UpdateStatusLabel "Patching MQ Dungeon: Bottom of the Well"
        if (!(PatchDungeon -TableOffset "CEA0" -Path "Master Quest\Bottom of the Well\" -Length 7 -Scene "B714E0")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "39A8") ) ) -Patch "Master Quest Chests\Bottom of the Well\Mainmap Chests.bin"
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "6120") ) ) -Patch "Master Quest Chests\Bottom of the Well\Minimap Chests.bin"
    }

    # Gerudo Training Ground
    if ( (IsChecked -Elem $Redux.MQ.GerudoTrainingGround) -or ($RandomizedDungeons -Contains "GerudoTrainingGround") ) {
        UpdateStatusLabel "Patching MQ Dungeon: Gerudo Training Ground"
        if (!(PatchDungeon -TableOffset "C230" -Path "Master Quest\Gerudo Training Ground\" -Length 11 -Scene "B7151C")) { return }
    }

    # Inside Ganon's Castle
    if ( (IsChecked -Elem $Redux.MQ.InsideGanonsCastle) -or ($RandomizedDungeons -Contains "InsideGanonsCastle") ) {
        UpdateStatusLabel "Patching MQ Dungeon: Inside Ganon's Castle"
        if (!(PatchDungeon -TableOffset "CCC0" -Path "Master Quest\Inside Ganon's Castle\" -Length 20 -Scene "B71544")) { return }
    }

}



#==============================================================================================================================================================================================
function CheckDungeonData([String]$Path) {
    
    if (!(Test-Path -LiteralPath $Path -PathType Container)) {
        WriteToConsole ('Error: "' + $Path + '" was not found')
        return $False
    }
    return $True

}



#==============================================================================================================================================================================================
function ExtractMQData([Boolean]$Decompress) {
    
    if (!$Decompress) { return }

    # EXTRACT MQ DATA #
    if ($GameType.mode -eq "Ocarina of Time") {
        $Path = $Paths.Games + "\Ocarina of Time\Extracted\Master Quest"
        if ( (IsChecked -Elem $Redux.MQ.Disable -Not) -and (IsChecked -Elem $Patches.Options -Active) ) { # EXTRACT MQ DUNGEON DATA #
            if ( !(Test-Path -LiteralPath $Path -PathType Container) -or ($Settings.Debug.ForceExtract -eq $True) ) {
                ApplyPatch -File $GetROM.decomp -Patch "\Decompressed\master_quest.bps" -New $GetROM.masterQuest
                $global:ByteArrayGame = [IO.File]::ReadAllBytes($GetROM.masterQuest)
                ExtractAllDungeons $Path
            }
        }
        if ($Settings.Debug.Rev0DungeonFiles -eq $True) { # EXTRACT VANILLA DUNGEON DATA DEBUG #
            $global:ByteArrayGame = [IO.File]::ReadAllBytes($GetROM.decomp)
            ExtractAllDungeons ($Path + " (Rev 0)")
        }
    }

}



#==============================================================================================================================================================================================
function ExtractDungeon([String]$Path, [String]$Offset, [int]$Length) {
    
    if ( (Test-Path -LiteralPath $Path -PathType Container) -and ($Settings.Debug.ForceExtract -eq $False) ) { return }

    $Start = Get8Bit ( (GetDecimal $Offset) )
    $End   = Get8Bit ( (GetDecimal $Start) + ($Length * 16) + 16)
    $Table = $ByteArrayGame[(GetDecimal $Start)..(GetDecimal $End)]
    CreateSubPath $Path

    ExportBytes -Offset $Start -End $End -Output ($Path + "\table.dmaTable") 
    
    for ($i=0; $i -le $Length; $i++) {
        $Start = (Get8Bit $Table[($i*16)+0]) + (Get8Bit $Table[($i*16)+1]) + (Get8Bit $Table[($i*16)+2]) + (Get8Bit $Table[($i*16)+3])
        $End   = (Get8Bit $Table[($i*16)+4]) + (Get8Bit $Table[($i*16)+5]) + (Get8Bit $Table[($i*16)+6]) + (Get8Bit $Table[($i*16)+7])
        if ($i -eq 0)   { ExportBytes -Offset $Start -End $End -Output ($Path + "\scene.zscene") }
        else            { ExportBytes -Offset $Start -End $End -Output ($Path + "\room_" + ($i-1) + ".zmap") }
    }

}



#==============================================================================================================================================================================================
function ExtractAllDungeons([String]$Path) {
    
    if (!(Test-Path -LiteralPath $Path -PathType Container)) { CreateSubPath $Path }
    ExtractDungeon -Path ($Path + "\Inside the Deku Tree")     -Offset "BB40" -Length 12
    ExtractDungeon -Path ($Path + "\Dodongo's Cavern")         -Offset "B320" -Length 17
    ExtractDungeon -Path ($Path + "\Inside Jabu-Jabu's Belly") -Offset "BF50" -Length 16
    ExtractDungeon -Path ($Path + "\Forest Temple")            -Offset "B9C0" -Length 23
    ExtractDungeon -Path ($Path + "\Fire Temple")              -Offset "B800" -Length 27
    ExtractDungeon -Path ($Path + "\Water Temple")             -Offset "BCA0" -Length 23
    ExtractDungeon -Path ($Path + "\Shadow Temple")            -Offset "C060" -Length 23
    ExtractDungeon -Path ($Path + "\Spirit Temple")            -Offset "C450" -Length 29
    ExtractDungeon -Path ($Path + "\Ice Cavern")               -Offset "C630" -Length 12
    ExtractDungeon -Path ($Path + "\Bottom of the Well")       -Offset "CEA0" -Length 7
    ExtractDungeon -Path ($Path + "\Gerudo Training Ground")   -Offset "C230" -Length 11
    ExtractDungeon -Path ($Path + "\Inside Ganon's Castle")    -Offset "CCC0" -Length 20

}



#==============================================================================================================================================================================================
function PatchDungeon([String]$TableOffset, [String]$Path, [int]$Length, [String]$Scene) {
    
    if (!(CheckDungeonData -Path ($Gamefiles.extracted + "\" + $Path))) { return $False }

    $Table = [IO.File]::ReadAllBytes($GameFiles.extracted + "\" + $Path + "table.dmaTable")
    for ($i=0; $i -le $Length; $i++) {
        $Values = @()
        for ($j=0; $j -lt 12; $j++) { $Values += Get8Bit -Value $Table[($i*16)+$j] }
        $Offset = Get16Bit -Value ( (GetDecimal -Hex $TableOffset) + ($i * 16) )
        if ($i -eq 0)   {
            PatchDungeonFile -Offset $Offset -Values $Values -Patch ($Path + "scene.zscene")
            ChangeBytes -Offset $Scene -Values @($Values[0], $Values[1], $Values[2], $Values[3], $Values[4], $Values[5], $Values[6], $Values[7]) # Update Scene Table
        }
        else { PatchDungeonFile -Offset $Offset -Values $Values -Patch ($Path + "room_" + ($i-1) + ".zmap") }
    }
    $Table = $null
    return $True

}



#==============================================================================================================================================================================================
function PatchDungeonFile([String]$Offset, [Array]$Values, [String]$Patch, [String]$Length) {
    
    ChangeBytes -Offset $Offset -Values $Values                                                                      # Update DMA Table
    PatchBytes  -Offset ($Values[0] + $Values[1] + $Values[2] + $Values[3]) -Length $Length -Patch $Patch -Extracted # Inject .zmap or .zscene

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function PatchDungeonsMQ
Export-ModuleMember -Function ExtractMQData