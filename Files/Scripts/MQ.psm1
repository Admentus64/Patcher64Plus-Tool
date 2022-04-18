function PatchDungeonsOoTMQ() {
    
    if ($GameType.mode -ne "Ocarina of Time") { return }

    if (IsChecked $Redux.MQ.MasterQuestLogo) { # MQ Title with Subtitle
        PatchBytes -Offset "1795300" -Texture -Patch "Logo\mq_logo.bin"
        PatchBytes -Offset "17AE300" -Texture -Patch "Logo\mq_copyright.bin"
        ChangeBytes -Offset "E6E266" -Values "64 96 34 21 FF" # THE LEGEND OF + OCARINA OF TIME (14 50 35 8C A0)
        ChangeBytes -Offset "E6E2A6" -Values "08 5C 35 8C 98" # Overlay Title color
        ChangeBytes -Offset "E6C4BC" -Values "3C 01 43 48 44 81 30 00 E4 60 62 D8 E4 60 62 DC E4 60 62 E4 E4 64 62 D4 E4 66 62 E0"
        ChangeBytes -Offset "E6C764" -Values "3C 01 43 2A 44 81 50 00 26 01 7F FF 24 0A 00 02 E4 42 62 D8 E4 42 62 DC E4 42 62 E4 E4 48 62 D4 E4 4A 62 E0"
        ChangeBytes -Offset "E6C9F0" -Values "3C 01 BF B0 C4 44 62 D4 44 81 80 00 C4 4A 62 E0 46 06 22 00 84 4E 62 CA 26 01 7F FF 46 10 54 80 E4 48 62 D4 25 CF FF FF E4 52 62 E0"
        ChangeBytes -Offset "E6CA48" -Values "3C 01 43 48 44 81 40 00 26 01 7F FF E4 46 62 D4 E4 48 62 E0"
    }
    elseif ( (IsChecked $Redux.MQ.UraQuestLogo) -or (IsChecked $Redux.MQ.UraQuestSubtitleLogo) ) { # Ura Title
        if     (IsChecked $Redux.MQ.UraQuestLogo)           { PatchBytes -Offset "1795300" -Texture -Patch "Logo\ura_logo.bin"          } # Ura Title
        elseif (IsChecked $Redux.MQ.UraQuestSubtitleLogo)   { PatchBytes -Offset "1795300" -Texture -Patch "Logo\ura_subtitle_logo.bin" } # Ura Title + Subtitle
        PatchBytes -Offset "17AE300" -Texture -Patch "Logo\ura_copyright.bin"
        ChangeBytes -Offset "E6E266" -Values "C8 96 34 21 C8" # THE LEGEND OF + OCARINA OF TIME
        ChangeBytes -Offset "E6E2A6" -Values "64 32 35 8C 64" # Overlay Title color
        ChangeBytes -Offset "E6DE2E" -Values "96" # Title Flames color
    }

    if (IsChecked $Redux.MQ.Disable) { return }
    $dungeons = PatchDungeonsMQ

    $title = "Inside the Deku Tree" # Inside the Deku Tree
    if ($dungeons[$title] -ne "Vanilla") { 
        UpdateStatusLabel ("Patching MQ Dungeon: " + $title)
        if (!(PatchDungeon -TableOffset "BB40" -Path ($dungeons[$title] + "\" + $title + "\") -Length 12 -Scene "B71440")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "0") ) )          -Patch ("Master Quest Chests\" + $title + "\mainmap_chests.bin") # BC7E00 -> BC879C (99C)
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "0") ) )          -Patch ("Master Quest Chests\" + $title + "\minimap_chests.bin") # BF40D0 -> BF469C (5CC)
    }

    $title = "Dodongo's Cavern" # Dodongo's Cavern
    if ($dungeons[$title] -ne "Vanilla") { 
        UpdateStatusLabel ("Patching MQ Dungeon: " + $title)
        if (!(PatchDungeon -TableOffset "B320" -Path ($dungeons[$title] + "\" + $title + "\") -Length 17 -Scene "B71454")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "99C") ) )        -Patch ("Master Quest Chests\" + $title + "\mainmap_chests.bin") # BC8B74 -> BC8F4C (3D8)
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "5CC") ) )        -Patch ("Master Quest Chests\" + $title + "\minimap_chests.bin") # BF469C -> BF4F14 (878)
    }

    $title = "Inside Jabu-Jabu's Belly" # Inside Jabu-Jabu's Belly
    if ($dungeons[$title] -ne "Vanilla") { 
        UpdateStatusLabel ("Patching MQ Dungeon: " + $title)
        if (!(PatchDungeon -TableOffset "BF50" -Path ($dungeons[$title] + "\" + $title + "\") -Length 16 -Scene "B71468")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "D74") ) )        -Patch ("Master Quest Chests\" + $title + "\mainmap_chests.bin") # BC8B74 -> BC8F4C (3D8)
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "E44") ) )        -Patch ("Master Quest Chests\" + $title + "\minimap_chests.bin") # BF4F14 -> BF56A8 (794)
    }

    $title = "Forest Temple" # Forest Temple
    if ($dungeons[$title] -ne "Vanilla") { 
        UpdateStatusLabel ("Patching MQ Dungeon: " + $title)
        if (!(PatchDungeon -TableOffset "B9C0" -Path ($dungeons[$title] + "\" + $title + "\") -Length 23 -Scene "B7147C")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "114C") ) )       -Patch ("Master Quest Chests\" + $title + "\mainmap_chests.bin") # BC8F4C -> BC96FC (7B0)
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "15D8") ) )       -Patch ("Master Quest Chests\" + $title + "\minimap_chests.bin") # BF56A8 -> BF62B0 (C08)
    }

    $title = "Fire Temple" # Fire Temple
    if ($dungeons[$title] -ne "Vanilla") { 
        UpdateStatusLabel ("Patching MQ Dungeon: " + $title)
        if (!(PatchDungeon -TableOffset "B800" -Path ($dungeons[$title] + "\" + $title + "\") -Length 27 -Scene "B71490")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "18FC") ) )       -Patch ("Master Quest Chests\" + $title + "\mainmap_chests.bin") # BC96FC -> BCA098 (99C)
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "21E0") ) )       -Patch ("Master Quest Chests\" + $title + "\minimap_chests.bin") # BF62B0 -> BF739C (10EC)
    }

    $title = "Water Temple" # Water Temple
    if ($dungeons[$title] -ne "Vanilla") { 
        UpdateStatusLabel ("Patching MQ Dungeon: " + $title)
        if (!(PatchDungeon -TableOffset "BCA0" -Path ($dungeons[$title] + "\" + $title + "\") -Length 23 -Scene "B714A4")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "2298") ) )       -Patch ("Master Quest Chests\" + $title + "\mainmap_chests.bin") # BCA098 -> BCA848 (7B0)
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "32CC") ) )       -Patch ("Master Quest Chests\" + $title + "\minimap_chests.bin") # BF739C -> BF8734 (1398)
    }

    $title = "Shadow Temple" # Shadow Temple
    if ($dungeons[$title] -ne "Vanilla") { 
        UpdateStatusLabel ("Patching MQ Dungeon: " + $title)
        if (!(PatchDungeon -TableOffset "C060" -Path ($dungeons[$title] + "\" + $title + "\") -Length 23 -Scene "B714CC")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "31F8") ) )       -Patch ("Master Quest Chests\" + $title + "\mainmap_chests.bin") # BCAFF8 -> BCB7A8 (7B0)
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "5518") ) )       -Patch ("Master Quest Chests\" + $title + "\minimap_chests.bin") # BF95E8 -> BFA1F0 (C08)
    }
    
    $title = "Spirit Temple" # Spirit Temple
    if ($dungeons[$title] -ne "Vanilla") { 
        UpdateStatusLabel ("Patching MQ Dungeon: " + $title)
        if (!(PatchDungeon -TableOffset "C450" -Path ($dungeons[$title] + "\" + $title + "\") -Length 29 -Scene "B714B8")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "2A48") ) )       -Patch ("Master Quest Chests\" + $title + "\mainmap_chests.bin") # BCA848 -> BCAFF8 (7B0)
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "4664") ) )       -Patch ("Master Quest Chests\" + $title + "\minimap_chests.bin") # BF8734 -> BF95E8 (EB4)
    }
    
    $title = "Ice Cavern" # Ice Cavern
    if ($dungeons[$title] -ne "Vanilla") { 
        UpdateStatusLabel ("Patching MQ Dungeon: " + $title)
        if (!(PatchDungeon -TableOffset "C630" -Path ($dungeons[$title] + "\" + $title + "\") -Length 12 -Scene "B714F4")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "3F6C") ) )       -Patch ("Master Quest Chests\" + $title + "\mainmap_chests.bin") # BCBD6C -> BCBF60 (1F4)
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "6594") ) )       -Patch ("Master Quest Chests\" + $title + "\minimap_chests.bin") # BFA664 -> BFABBC (558)
    }

    $title = "Bottom of the Well" # Bottom of the Well
    if ($dungeons[$title] -ne "Vanilla") { 
        UpdateStatusLabel ("Patching MQ Dungeon: " + $title)
        if (!(PatchDungeon -TableOffset "CEA0" -Path ($dungeons[$title] + "\" + $title + "\") -Length 7  -Scene "B714E0")) { return }
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BC7E00") + (GetDecimal "39A8") ) )       -Patch ("Master Quest Chests\" + $title + "\mainmap_chests.bin") # BCB7A8 -> BCBD6C (5C4)
        PatchBytes -Offset ( Get24Bit ( (GetDecimal "BF40D0") + (GetDecimal "6120") ) )       -Patch ("Master Quest Chests\" + $title + "\minimap_chests.bin") # BFA1F0 -> BFA664 (474)
    }

    $title = "Gerudo Training Ground" # Gerudo Training Ground
    if ($dungeons[$title] -ne "Vanilla") { 
        UpdateStatusLabel "Patching MQ Dungeon: " + $title
        if (!(PatchDungeon -TableOffset "C230" -Path ($dungeons[$title] + "\" + $title + "\") -Length 11 -Scene "B7151C")) { return }
    }
    
    $title = "Inside Ganon's Castle" # Inside Ganon's Castle
    if ($dungeons[$title] -ne "Vanilla") { 
        UpdateStatusLabel ("Patching MQ Dungeon: " + $title)
        if (!(PatchDungeon -TableOffset "CCC0" -Path ($dungeons[$title] + "\" + $title + "\") -Length 20 -Scene "B71544")) { return }
    }

    return $dungeons

}



#==============================================================================================================================================================================================
function PatchDungeonsMQ() {
    
    # BYTE PATCHING MASTER QUEST DUNGEONS
    if (IsChecked $Redux.MQ.Disable) { return $False }

    if ( (IsChecked $Redux.MQ.Select) -or (IsChecked $Redux.MQ.EnableMQ) -or (IsChecked -Elem $Redux.MQ.Randomize)) {
        if (!(TestFile -Path ($GameFiles.extracted + "\Master Quest") -Container)) {
            WriteToConsole ('Error: "' + ($GameFiles.extracted + "\Master Quest") + '" was not found')
            return $False
        }
    }
    if ( (IsChecked $Redux.MQ.Select) -or (IsChecked $Redux.MQ.EnableUra) -or (IsChecked -Elem $Redux.MQ.Randomize)) {
        if (!(TestFile -Path ($GameFiles.extracted + "\Ura Quest") -Container)) {
            WriteToConsole ('Error: "' + ($GameFiles.extracted + "\Ura Quest") + '" was not found')
            return $False
        }
    }

    UpdateStatusLabel ("Patching " + $GameType.mode + " Master Quest Dungeons...")
    $dungeons = @{}
    $versions = @{}

    foreach ($item in $Redux.Box.SelectMQ) {
        foreach ($label in $item.controls) {
            if     ( (IsChecked $Redux.MQ.Select)    -and $label.GetType() -eq [System.Windows.Forms.Label]) { $dungeons[$label.text.replace(":", "")] = $label.ComboBox.text     }
            elseif ( (IsChecked $Redux.MQ.EnableMQ)  -and $label.GetType() -eq [System.Windows.Forms.Label]) { $dungeons[$label.text.replace(":", "")] = $label.ComboBox.items[1] }
            elseif ( (IsChecked $Redux.MQ.EnableUra) -and $label.GetType() -eq [System.Windows.Forms.Label]) { $dungeons[$label.text.replace(":", "")] = $label.ComboBox.items[2] }
            elseif ( (IsChecked $Redux.MQ.Randomize) -and $label.GetType() -eq [System.Windows.Forms.Label]) { $dungeons[$label.text.replace(":", "")] = $label.ComboBox.items[0]; $versions[$label.text.replace(":", "")] = $label.ComboBox.items }
        }
    }

    if (IsChecked $Redux.MQ.Randomize) {
        $min   = $Redux.MQ.Minimum.Text.replace(" (default)", "")
        $max   = $Redux.MQ.Maximum.Text.replace(" (default)", "")
        $count = (Get-Random -Minimum $min -Maximum $max)
        while ($count -gt 0) {
            foreach ($h in $dungeons.Keys) {
                $change = (Get-Random -Maximum 20)
                if ($change -eq 0 -and $dungeons.$h -eq "Vanilla") {
                    $dungeons.$h = $versions.$h[(Get-Random -Minimum 1 -Maximum ($versions.$h.count))]
                    WriteToConsole ("Dungeon Spoiler: " + $h + " -> " + $dungeons.$h)
                    $count--
                    break
                }
            }
        }
    }

    return $dungeons

}



#==============================================================================================================================================================================================
function CheckDungeonData([string]$Path) {
    
    if (!(TestFile -Path $Path -Container)) {
        WriteToConsole ('Error: "' + $Path + '" was not found')
        return $False
    }
    return $True

}



#==============================================================================================================================================================================================
function ExtractMQData() {
    
    if (!$PatchInfo.decompress) { return }

    # EXTRACT MQ DATA #
    if ($GameType.mode -eq "Ocarina of Time") {
        if ( ( (IsChecked -Elem $Redux.MQ.Select) -or (IsChecked -Elem $Redux.MQ.EnableMQ) -or (IsChecked -Elem $Redux.MQ.Randomize) ) -and (IsChecked $Patches.Options) ) { # EXTRACT MQ DUNGEON DATA
            if ( (CountFiles ($GameFiles.extracted + "\Master Quest")) -ne $GameType.mq_files -or $Settings.Debug.ForceExtract -eq $True) {
                if (TestFile -Path ($GameFiles.decompressed + "\Dungeons\master_quest.bps") ) {
                    WriteToConsole "Extracting Master Quest dungeon files"
                    ApplyPatch -File $GetROM.decomp -Patch "Decompressed\Dungeons\master_quest.bps" -New $GetROM.masterQuest
                    $global:ByteArrayGame = [IO.File]::ReadAllBytes($GetROM.masterQuest)
                    ExtractAllDungeons ($GameFiles.extracted + "\Master Quest")
                }
            }
        }
        if ( ( (IsChecked -Elem $Redux.MQ.Select) -or (IsChecked -Elem $Redux.MQ.EnableUra) -or (IsChecked -Elem $Redux.MQ.Randomize) ) -and (IsChecked $Patches.Options) ) { # EXTRACT URA DUNGEON DATA
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