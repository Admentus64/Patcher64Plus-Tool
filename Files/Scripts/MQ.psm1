function PatchDungeonsOoTMQ() {
    
    if ($GameType.mode -ne "Ocarina of Time") { return }

    if (IsIndex -Elem $Redux.MQ.Logo -Text "Vanilla + GC Copyright") { # The GC copyright is the same as OOT Master Quest, as they are on the same disk
        PatchBytes -Offset "17AE300" -Texture -Patch "Logo\mq_copyright.bin" 
    }

    if (IsIndex -Elem $Redux.MQ.Logo -Text "Master Quest") { # MQ Title with Subtitle
        PatchBytes -Offset "1795300" -Texture -Patch "Logo\mq_logo.bin"
        PatchBytes -Offset "17AE300" -Texture -Patch "Logo\mq_copyright.bin"
        ChangeBytes -Offset "E6E266" -Values "64963421FF" # THE LEGEND OF + OCARINA OF TIME (1450358CA0)
        ChangeBytes -Offset "E6E2A6" -Values "085C358C98" # Overlay Title color
        ChangeBytes -Offset "E6C4BC" -Values "3C01434844813000E46062D8E46062DCE46062E4E46462D4E46662E0"
        ChangeBytes -Offset "E6C764" -Values "3C01432A4481500026017FFF240A0002E44262D8E44262DCE44262E4E44862D4E44A62E0"
        ChangeBytes -Offset "E6C9F0" -Values "3C01BFB0C44462D444818000C44A62E046062200844E62CA26017FFF46105480E44862D425CFFFFFE45262E0"
        ChangeBytes -Offset "E6CA48" -Values "3C0143484481400026017FFFE44662D4E44862E0"
    }
    elseif   (IsIndex -Elem $Redux.MQ.Logo -Text "New Master Quest")         { PatchBytes -Offset "1795300" -Texture -Patch "Logo\nmq_logo.bin" }          # New Master Quest Title
    elseif ( (IsIndex -Elem $Redux.MQ.Logo -Text "Ura Quest") -or (IsIndex -Elem $Redux.MQ.Logo -Text "Ura Quest + Subtitle") ) { # Ura Title
        if     (IsIndex -Elem $Redux.MQ.Logo -Text "Ura Quest")              { PatchBytes -Offset "1795300" -Texture -Patch "Logo\ura_logo.bin"          } # Ura Title
        elseif (IsIndex -Elem $Redux.MQ.Logo -Text "Ura Quest + Subtitle")   { PatchBytes -Offset "1795300" -Texture -Patch "Logo\ura_subtitle_logo.bin" } # Ura Title + Subtitle
        PatchBytes -Offset "17AE300" -Texture -Patch "Logo\ura_copyright.bin"
        ChangeBytes -Offset "E6E266" -Values "C8963421C8" # THE LEGEND OF + OCARINA OF TIME
        ChangeBytes -Offset "E6E2A6" -Values "6432358C64" # Overlay Title color
        ChangeBytes -Offset "E6DE2E" -Values "96" # Title Flames color
    }

    if (IsIndex -Elem $Redux.MQ.Dungeons -Text "Custom") { return }
    PatchDungeonsMQ

    $title = "Inside the Deku Tree" # Inside the Deku Tree
    if ($DungeonList[$title] -ne "Vanilla") { 
        UpdateStatusLabel ("Patching MQ Dungeon: " + $title)
        if (!(PatchDungeon -TableOffset "BB40" -Path ($DungeonList[$title] + "\" + $title + "\") -Length 12 -Scene "B71440")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "0") ) )          -Patch ("Master Quest Chests\" + $title + "\mainmap_chests.bin") # BC7E00 -> BC879C (99C)
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "0") ) )          -Patch ("Master Quest Chests\" + $title + "\minimap_chests.bin") # BF40D0 -> BF469C (5CC)
    }

    $title = "Dodongo's Cavern" # Dodongo's Cavern
    if ($DungeonList[$title] -ne "Vanilla") { 
        UpdateStatusLabel ("Patching MQ Dungeon: " + $title)
        if (!(PatchDungeon -TableOffset "B320" -Path ($DungeonList[$title] + "\" + $title + "\") -Length 17 -Scene "B71454")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "99C") ) )        -Patch ("Master Quest Chests\" + $title + "\mainmap_chests.bin") # BC8B74 -> BC8F4C (3D8)
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "5CC") ) )        -Patch ("Master Quest Chests\" + $title + "\minimap_chests.bin") # BF469C -> BF4F14 (878)
    }

    $title = "Inside Jabu-Jabu's Belly" # Inside Jabu-Jabu's Belly
    if ($DungeonList[$title] -ne "Vanilla") { 
        UpdateStatusLabel ("Patching MQ Dungeon: " + $title)
        if (!(PatchDungeon -TableOffset "BF50" -Path ($DungeonList[$title] + "\" + $title + "\") -Length 16 -Scene "B71468")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "D74") ) )        -Patch ("Master Quest Chests\" + $title + "\mainmap_chests.bin") # BC8B74 -> BC8F4C (3D8)
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "E44") ) )        -Patch ("Master Quest Chests\" + $title + "\minimap_chests.bin") # BF4F14 -> BF56A8 (794)
    }

    $title = "Forest Temple" # Forest Temple
    if ($DungeonList[$title] -ne "Vanilla") { 
        UpdateStatusLabel ("Patching MQ Dungeon: " + $title)
        if (!(PatchDungeon -TableOffset "B9C0" -Path ($DungeonList[$title] + "\" + $title + "\") -Length 23 -Scene "B7147C")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "114C") ) )       -Patch ("Master Quest Chests\" + $title + "\mainmap_chests.bin") # BC8F4C -> BC96FC (7B0)
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "15D8") ) )       -Patch ("Master Quest Chests\" + $title + "\minimap_chests.bin") # BF56A8 -> BF62B0 (C08)
    }

    $title = "Fire Temple" # Fire Temple
    if ($DungeonList[$title] -ne "Vanilla") { 
        UpdateStatusLabel ("Patching MQ Dungeon: " + $title)
        if (!(PatchDungeon -TableOffset "B800" -Path ($DungeonList[$title] + "\" + $title + "\") -Length 27 -Scene "B71490")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "18FC") ) )       -Patch ("Master Quest Chests\" + $title + "\mainmap_chests.bin") # BC96FC -> BCA098 (99C)
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "21E0") ) )       -Patch ("Master Quest Chests\" + $title + "\minimap_chests.bin") # BF62B0 -> BF739C (10EC)
    }

    $title = "Water Temple" # Water Temple
    if ($DungeonList[$title] -ne "Vanilla") { 
        UpdateStatusLabel ("Patching MQ Dungeon: " + $title)
        if (!(PatchDungeon -TableOffset "BCA0" -Path ($DungeonList[$title] + "\" + $title + "\") -Length 23 -Scene "B714A4")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "2298") ) )       -Patch ("Master Quest Chests\" + $title + "\mainmap_chests.bin") # BCA098 -> BCA848 (7B0)
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "32CC") ) )       -Patch ("Master Quest Chests\" + $title + "\minimap_chests.bin") # BF739C -> BF8734 (1398)
    }

    $title = "Shadow Temple" # Shadow Temple
    if ($DungeonList[$title] -ne "Vanilla") { 
        UpdateStatusLabel ("Patching MQ Dungeon: " + $title)
        if (!(PatchDungeon -TableOffset "C060" -Path ($DungeonList[$title] + "\" + $title + "\") -Length 23 -Scene "B714CC")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "31F8") ) )       -Patch ("Master Quest Chests\" + $title + "\mainmap_chests.bin") # BCAFF8 -> BCB7A8 (7B0)
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "5518") ) )       -Patch ("Master Quest Chests\" + $title + "\minimap_chests.bin") # BF95E8 -> BFA1F0 (C08)
    }
    
    $title = "Spirit Temple" # Spirit Temple
    if ($DungeonList[$title] -ne "Vanilla") { 
        UpdateStatusLabel ("Patching MQ Dungeon: " + $title)
        if (!(PatchDungeon -TableOffset "C450" -Path ($DungeonList[$title] + "\" + $title + "\") -Length 29 -Scene "B714B8")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "2A48") ) )       -Patch ("Master Quest Chests\" + $title + "\mainmap_chests.bin") # BCA848 -> BCAFF8 (7B0)
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "4664") ) )       -Patch ("Master Quest Chests\" + $title + "\minimap_chests.bin") # BF8734 -> BF95E8 (EB4)
    }
    
    $title = "Ice Cavern" # Ice Cavern
    if ($DungeonList[$title] -ne "Vanilla") { 
        UpdateStatusLabel ("Patching MQ Dungeon: " + $title)
        if (!(PatchDungeon -TableOffset "C630" -Path ($DungeonList[$title] + "\" + $title + "\") -Length 12 -Scene "B714F4")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "3F6C") ) )       -Patch ("Master Quest Chests\" + $title + "\mainmap_chests.bin") # BCBD6C -> BCBF60 (1F4)
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "6594") ) )       -Patch ("Master Quest Chests\" + $title + "\minimap_chests.bin") # BFA664 -> BFABBC (558)
    }

    $title = "Bottom of the Well" # Bottom of the Well
    if ($DungeonList[$title] -ne "Vanilla") { 
        UpdateStatusLabel ("Patching MQ Dungeon: " + $title)
        if (!(PatchDungeon -TableOffset "CEA0" -Path ($DungeonList[$title] + "\" + $title + "\") -Length 7  -Scene "B714E0")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "39A8") ) )       -Patch ("Master Quest Chests\" + $title + "\mainmap_chests.bin") # BCB7A8 -> BCBD6C (5C4)
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "6120") ) )       -Patch ("Master Quest Chests\" + $title + "\minimap_chests.bin") # BFA1F0 -> BFA664 (474)
    }

    $title = "Gerudo Training Ground" # Gerudo Training Ground
    if ($DungeonList[$title] -ne "Vanilla") { 
        UpdateStatusLabel "Patching MQ Dungeon: " + $title
        if (!(PatchDungeon -TableOffset "C230" -Path ($DungeonList[$title] + "\" + $title + "\") -Length 11 -Scene "B7151C")) { return }
    }
    
    $title = "Inside Ganon's Castle" # Inside Ganon's Castle
    if ($DungeonList[$title] -ne "Vanilla") { 
        UpdateStatusLabel ("Patching MQ Dungeon: " + $title)
        if (!(PatchDungeon -TableOffset "CCC0" -Path ($DungeonList[$title] + "\" + $title + "\") -Length 20 -Scene "B71544")) { return }
    }

}



#==============================================================================================================================================================================================
function PatchDungeonsMQ() {
    
    # BYTE PATCHING MASTER QUEST DUNGEONS
    if (IsChecked $Redux.MQ.Disable) { return $False }

    if ( (IsIndex -Elem $Redux.MQ.Dungeons -Text "Select") -or (IsIndex -Elem $Redux.MQ.Dungeons -Text "Master Quest") -or (IsIndex -Elem $Redux.MQ.Dungeons -Text "Randomize") ) {
        if (!(TestFile -Path ($GameFiles.extracted + "\Master Quest") -Container)) {
            WriteToConsole ('Error: "' + ($GameFiles.extracted + "\Master Quest") + '" was not found') -Error
            return $False
        }
    }
    if ( (IsIndex -Elem $Redux.MQ.Dungeons -Text "Select") -or (IsIndex -Elem $Redux.MQ.Dungeons -Text "Ura Quest") -or (IsIndex -Elem $Redux.MQ.Dungeons -Text "Randomize") ) {
        if (!(TestFile -Path ($GameFiles.extracted + "\Ura Quest") -Container)) {
            WriteToConsole ('Error: "' + ($GameFiles.extracted + "\Ura Quest") + '" was not found') -Error
            return $False
        }
    }

    UpdateStatusLabel ("Patching " + $GameType.mode + " Master Quest Dungeons...")
    $global:DungeonList = @{}
    $versions = @{}

    foreach ($item in $Redux.Box.SelectMQ) {
        foreach ($label in $item.controls) {
            if     ( (IsIndex -Elem $Redux.MQ.Dungeons -Text "Select")       -and $label.GetType() -eq [System.Windows.Forms.Label])   { write-host 123456 $label.ComboBox.text; $DungeonList[$label.text.replace(":", "")] = $label.ComboBox.text     }
            elseif ( (IsIndex -Elem $Redux.MQ.Dungeons -Text "Vanilla")      -and $label.GetType() -eq [System.Windows.Forms.Label])   { $DungeonList[$label.text.replace(":", "")] = $label.ComboBox.items[0] }
            elseif ( (IsIndex -Elem $Redux.MQ.Dungeons -Text "Master Quest") -and $label.GetType() -eq [System.Windows.Forms.Label])   { $DungeonList[$label.text.replace(":", "")] = $label.ComboBox.items[1] }
            elseif ( (IsIndex -Elem $Redux.MQ.Dungeons -Text "Ura Quest")    -and $label.GetType() -eq [System.Windows.Forms.Label])   { $DungeonList[$label.text.replace(":", "")] = $label.ComboBox.items[2] }
            elseif ( (IsIndex -Elem $Redux.MQ.Dungeons -Text "Randomize")    -and $label.GetType() -eq [System.Windows.Forms.Label])   { $DungeonList[$label.text.replace(":", "")] = $label.ComboBox.items[0]; $versions[$label.text.replace(":", "")] = $label.ComboBox.items }
        }
    }

    if (IsIndex -Elem $Redux.MQ.Dungeons -Text "Randomize") {
        $min   = $Redux.MQ.Minimum.Text.replace(" (default)", "")
        $max   = $Redux.MQ.Maximum.Text.replace(" (default)", "")
        $count = (Get-Random -Minimum $min -Maximum $max)
        while ($count -gt 0) {
            foreach ($h in $DungeonList.Keys) {
                $change = (Get-Random -Maximum 20)
                if ($change -eq 0 -and $DungeonList.$h -eq "Vanilla") {
                    $DungeonList.$h = $versions.$h[(Get-Random -Minimum 1 -Maximum ($versions.$h.count))]
                    WriteToConsole ("Dungeon Spoiler: " + $h + " -> " + $DungeonList.$h)
                    $count--
                    break
                }
            }
        }
    }

}



#==============================================================================================================================================================================================
function CheckDungeonData([string]$Path) {
    
    if (!(TestFile -Path $Path -Container)) {
        WriteToConsole ('Error: "' + $Path + '" was not found') -Error
        return $False
    }
    return $True

}



#==============================================================================================================================================================================================
function ExtractMQData() {
    
    if (!$PatchInfo.decompress) { return }
    
    $MQHash  = (Get-FileHash -Algorithm MD5 -LiteralPath $Files.oot.master_quest).Hash
    $UraHash = (Get-FileHash -Algorithm MD5 -LiteralPath $Files.oot.ura_quest).Hash

    if ($MQHash -ne $Settings.Hashes.MQ) {
        if ($Settings.Hashes -eq $null) { $Settings.Hashes = @{} }
        $Settings.Hashes.MQ  = $MQHash
        RemovePath ($GameFiles.extracted + "\Master Quest")
    }
    if ($UraHash -ne $Settings.Hashes.Ura) {
        if ($Settings.Hashes -eq $null) { $Settings.Hashes = @{} }
        $Settings.Hashes.Ura  = $UraHash
        RemovePath ($GameFiles.extracted + "\Ura Quest")
    }

    # EXTRACT MQ DATA #
    if ($GameType.mode -eq "Ocarina of Time") {
        if ( ( (IsIndex -Elem $Redux.MQ.Dungeons -Text "Select") -or (IsIndex -Elem $Redux.MQ.Dungeons -Text "Master Quest") -or (IsIndex -Elem $Redux.MQ.Dungeons -Text "Randomize") ) -and ( (IsChecked $Patches.Options) -or ($GamePatch.mq -eq 1 -and $GamePatch.function -is [String]) ) ) { # EXTRACT MQ DUNGEON DATA
            if ( (CountFiles ($GameFiles.extracted + "\Master Quest")) -ne $GameType.mq_files -or $Settings.Debug.ForceExtract -eq $True) {
                if (TestFile -Path ($GameFiles.decompressed + "\Dungeons\master_quest.bps") ) {
                    WriteToConsole "Extracting Master Quest dungeon files"
                    ApplyPatch -File $GetROM.decomp -Patch "Decompressed\Dungeons\master_quest.bps" -New $GetROM.masterQuest
                    $global:ByteArrayGame = [IO.File]::ReadAllBytes($GetROM.masterQuest)
                    ExtractAllDungeons ($GameFiles.extracted + "\Master Quest")
                }
            }
        }

        if ( ( (IsIndex -Elem $Redux.MQ.Dungeons -Text "Select") -or (IsIndex -Elem $Redux.MQ.Dungeons -Text "Ura Quest") -or (IsIndex -Elem $Redux.MQ.Dungeons -Text "Randomize") ) -and ( (IsChecked $Patches.Options) -or ($GamePatch.mq -eq 1 -and $GamePatch.function -is [String]) ) ) { # EXTRACT URA DUNGEON DATA
            if ( (CountFiles ($GameFiles.extracted + "\Ura Quest")) -ne $GameType.mq_files -or $Settings.Debug.ForceExtract -eq $True) {
                if (TestFile -Path ($GameFiles.decompressed + "\Dungeons\ura_quest.bps") ) {
                    WriteToConsole "Extracting Ura Quest dungeon files"
                    ApplyPatch -File $GetROM.decomp -Patch "Decompressed\Dungeons\ura_quest.bps" -New $GetROM.masterQuest
                    $global:ByteArrayGame = [IO.File]::ReadAllBytes($GetROM.masterQuest)
                    ExtractAllDungeons ($GameFiles.extracted + "\Ura Quest")
                }
            }
        }
        if ($Settings.Debug.Rev0DungeonFiles -eq $True) { # EXTRACT VANILLA DUNGEON DATA DEBUG #
            $global:ByteArrayGame = [IO.File]::ReadAllBytes($GetROM.decomp)
            ExtractAllDungeons ($GameFiles.extracted + "\Vanilla Quest")
        }
    }

}



#==============================================================================================================================================================================================
function ExtractDungeon([string]$Path, [string]$Offset, [byte]$Length) {
    
    if ( (TestFile -Path $Path -Container) -and ($Settings.Debug.ForceExtract -eq $False) ) { return }

    $Start = Get24Bit ( (GetDecimal $Offset) )
    $End   = Get24Bit ( (GetDecimal $Start) + ($Length * 16) + 16)
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
function ExtractAllDungeons([string]$Path) {
    
    if (!(TestFile -Path $Path -Container)) { CreateSubPath $Path }

    if ($GameType.mode -eq "Ocarina of Time") {
        ExtractDungeon -Path ($Path + "\Inside the Deku Tree")          -Offset "BB40" -Length 12
        ExtractDungeon -Path ($Path + "\Dodongo's Cavern")              -Offset "B320" -Length 17
        ExtractDungeon -Path ($Path + "\Inside Jabu-Jabu's Belly")      -Offset "BF50" -Length 16
        ExtractDungeon -Path ($Path + "\Forest Temple")                 -Offset "B9C0" -Length 23
        ExtractDungeon -Path ($Path + "\Fire Temple")                   -Offset "B800" -Length 27
        ExtractDungeon -Path ($Path + "\Water Temple")                  -Offset "BCA0" -Length 23
        ExtractDungeon -Path ($Path + "\Shadow Temple")                 -Offset "C060" -Length 23
        ExtractDungeon -Path ($Path + "\Spirit Temple")                 -Offset "C450" -Length 29
        ExtractDungeon -Path ($Path + "\Ice Cavern")                    -Offset "C630" -Length 12
        ExtractDungeon -Path ($Path + "\Bottom of the Well")            -Offset "CEA0" -Length 7
        ExtractDungeon -Path ($Path + "\Gerudo Training Ground")        -Offset "C230" -Length 11
        ExtractDungeon -Path ($Path + "\Inside Ganon's Castle")         -Offset "CCC0" -Length 20
    }

}



#==============================================================================================================================================================================================
function PatchDungeon([string]$TableOffset, [string]$Path, [byte]$Length, [string]$Scene) {
    
    if (!(CheckDungeonData -Path ($Gamefiles.extracted + "\" + $Path))) { return $False }

    $Table = [IO.File]::ReadAllBytes($GameFiles.extracted + "\" + $Path + "table.dmaTable")
    for ($i=0; $i -le $Length; $i++) {
        $Values = @()
        for ($j=0; $j -lt 12; $j++) { $Values += Get8Bit $Table[($i*16)+$j] }
        $Offset = Get24Bit ( (GetDecimal $TableOffset) + ($i * 16) )
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
function PatchDungeonFile([string]$Offset, [Array]$Values, [string]$Patch, [string]$Length) {
    
    ChangeBytes -Offset $Offset -Values $Values                                                                      # Update DMA Table
    PatchBytes  -Offset ($Values[0] + $Values[1] + $Values[2] + $Values[3]) -Length $Length -Patch $Patch -Extracted # Inject .zmap or .zscene

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function PatchDungeonsOoTMQ
Export-ModuleMember -Function ExtractMQData