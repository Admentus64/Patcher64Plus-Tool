function CreateTextEditorDialog([int32]$Width, [int32]$Height, [string]$Game=$GameType.mode, [string]$Checksum) {
    
    $global:TextEditor   = @{}
    $TextEditor.Game     = $Game
    $TextEditor.Checksum = $Checksum

    # Create Dialog
    $TextEditor.Dialog           = CreateDialog -Width (DPISize 1000) -Height (DPISize 550)
    $TextEditor.Dialog.Icon      = $Files.icon.additional
    $TextEditor.Dialog.BackColor = 'AntiqueWhite'

    # Left Panel
    $TextEditor.ListPanel                   = CreatePanel -Width (DPISize 520) -Height ($TextEditor.Dialog.Height - (DPISize 40)) -AddTo $TextEditor.Dialog
    $TextEditor.ListPanel.BackColor         = 'AliceBlue'
    $TextEditor.ListPanel.AutoScroll        = $True
    $TextEditor.ListPanel.AutoScrollMargin  = New-Object System.Drawing.Size(0, 0)
    $TextEditor.ListPanel.AutoScrollMinSize = New-Object System.Drawing.Size(0, 0)

    # Right Panel
    $TextEditor.ContentPanel = CreatePanel   -X $TextEditor.ListPanel.Right -Width ($TextEditor.Dialog.Width - $TextEditor.ListPanel.Width) -Height ($TextEditor.Dialog.Height - (DPISize 230)) -AddTo $TextEditor.Dialog
    $TextEditor.SearchBar    = CreateTextBox -X (DPISize 65)    -Y (DPISize 15)                                  -Width ($TextEditor.ContentPanel.width - (DPISize 100)) -length 50 -Font $Fonts.TextEditor -AddTo $TextEditor.ContentPanel
    CreateLabel -X ($TextEditor.SearchBar.Left - (DPISize 50) ) -Y $TextEditor.SearchBar.Top -Font $Fonts.SmallBold -Text "Search:" -AddTo $TextEditor.ContentPanel
    $TextEditor.Content      = CreateTextBox -X (DPISize 15)    -Y ($TextEditor.SearchBar.Bottom + (DPISize 15)) -Width ($TextEditor.ContentPanel.width - (DPISize 50)) -length 1000 -Height ($TextEditor.ContentPanel.Height - $TextEditor.SearchBar.Bottom - (DPISize 20) ) -Multiline -Font $Fonts.TextEditor -AddTo $TextEditor.ContentPanel

    # Close Button
    $X = $TextEditor.ContentPanel.Left + ($TextEditor.ContentPanel.Width / 6)
    $Y = $TextEditor.Dialog.Height - (DPISize 90)
    $CloseButton = CreateButton -X $X -Y $Y -Width (DPISize 80) -Height (DPISize 35) -Text "Close" -AddTo $TextEditor.Dialog
    $CloseButton.Add_Click( { $TextEditor.Dialog.Hide() })
    $CloseButton.BackColor = "White"

    # Search Button
    $SearchButton = CreateButton -X ($CloseButton.Right + (DPISize 15)) -Y $CloseButton.Top -Width $CloseButton.Width -Height $CloseButton.Height -Text "Search" -AddTo $TextEditor.Dialog
    $SearchButton.BackColor = "White"

    # Extract Button
    $ExtractButton = CreateButton -X ($SearchButton.Right + (DPISize 15)) -Y $SearchButton.Top -Width $SearchButton.Width -Height $SearchButton.Height -Text "Extract Script" -AddTo $TextEditor.Dialog
    $ExtractButton.BackColor = "White"

    # Options Label
    $TextEditor.Label = CreateLabel -Y (DPISize 15) -Width $TextEditor.Dialog.width -Height (DPISize 15) -Font $Fonts.SmallBold -Text ($TextEditor.Game + " - Text Editor") -AddTo $TextEditor.Dialog
    $TextEditor.Label.AutoSize = $True
    $TextEditor.Label.Left = ([Math]::Floor($TextEditor.Dialog.Width / 2) - [Math]::Floor($TextEditor.Label.Width / 2))

    LoadMessages

    [string]$global:ScriptLastID    = "0000"
    [uint32]$global:ScriptLastIndex = 0
    [boolean[]]$TextEditor.Edited       = @($False, $False, $False, $False, $False, $False)
    [byte]$TextEditor.LastBoxType       = 0
    [byte]$TextEditor.LastBoxPosition   = 0
    [string]$TextEditor.LastBoxIcon     = "00"
    [uint16]$TextEditor.LastBoxRupees   = 0
    [string]$TextEditor.LastBoxJump     = "0000"

    $Files.json.textEditor = SetJSONFile ($Paths.Games + "\" + $TextEditor.Game + "\Text Editor.json")

    # Bottom Panel
    $TextEditor.TextBoxPanel = CreatePanel -X $TextEditor.ContentPanel.Left -Y $TextEditor.ContentPanel.Bottom -Width $TextEditor.ContentPanel.Width -Height ($TextEditor.Dialog.Height - $TextEditor.ContentPanel.Height) -AddTo $TextEditor.Dialog
    
    $items = @()
    $Files.json.textEditor.textboxes | foreach { $items += $_.name }
    $TextEditor.TextBoxType     = CreateComboBox        -X (DPISize 15)                                  -Y (DPISize 35)                                   -Width (DPISize 160) -Height (DPISize 20) -Items $items -Text "Type"     -AddTo $TextEditor.TextBoxPanel
    CreateLabel     -X $TextEditor.TextBoxType.Left     -Y ($TextEditor.TextBoxType.Top - (DPISize 20) )     -Font $Fonts.SmallBold -Text "Textbox Type"       -AddTo $TextEditor.TextBoxPanel

    $items = @("Dynamic", "Top", "Middle", "Bottom")
    $TextEditor.TextBoxPosition = CreateComboBox        -X ($TextEditor.TextBoxType.Right   + (DPISize 15) ) -Y $TextEditor.TextBoxType.Top                        -Width (DPISize 160) -Height (DPISize 20) -Items $items -Text "Position" -AddTo $TextEditor.TextBoxPanel
    CreateLabel     -X $TextEditor.TextBoxPosition.Left -Y ($TextEditor.TextBoxPosition.Top - (DPISize 20) ) -Font $Fonts.SmallBold -Text "Textbox Position"   -AddTo $TextEditor.TextBoxPanel

    if ($Files.json.textEditor.header -gt 0) {
        $items = @()
        $Files.json.textEditor.icons | foreach { $items += $_.name }
        $items = $items | select -Unique
        $TextEditor.TextBoxIcon   = CreateComboBox      -X $TextEditor.TextBoxType.Left                      -Y ($TextEditor.TextBoxType.Bottom + (DPISize 30) )   -Width (DPISize 160) -Height (DPISize 20) -Items $items -Text "Icon"     -AddTo $TextEditor.TextBoxPanel
        CreateLabel -X $TextEditor.TextBoxIcon.Left     -Y ($TextEditor.TextBoxIcon.Top - (DPISize 20) )     -Font $Fonts.SmallBold -Text "Textbox Icon"       -AddTo $TextEditor.TextBoxPanel
    
        $TextEditor.TextBoxRupees = CreateTextBox       -X ($TextEditor.TextBoxIcon.Right + (DPISize 15) )   -Y $TextEditor.TextBoxIcon.Top                        -Width (DPISize 60)  -Height (DPISize 15) -Length 4     -Text "0"        -AddTo $TextEditor.TextBoxPanel
        CreateLabel -X $TextEditor.TextBoxRupees.Left   -Y ($TextEditor.TextBoxRupees.Top - (DPISize 20) )   -Font $Fonts.SmallBold -Text "Textbox Rupee Cost" -AddTo $TextEditor.TextBoxPanel

        $TextEditor.TextBoxJump   = CreateTextBox       -X ($TextEditor.TextBoxRupees.Right + (DPISize 65) ) -Y $TextEditor.TextBoxIcon.Top                        -Width (DPISize 60)  -Height (DPISize 15) -Length 4     -Text "0000"     -AddTo $TextEditor.TextBoxPanel
        CreateLabel -X $TextEditor.TextBoxJump.Left     -Y ($TextEditor.TextBoxJump.Top     - (DPISize 20) ) -Font $Fonts.SmallBold -Text "Jump to Message"    -AddTo $TextEditor.TextBoxPanel

        $TextEditor.TextBoxIcon.Add_SelectedIndexChanged({ if ($TextEditor.Edited[0]) { $TextEditor.Edited[3] = $True } })

        $TextEditor.TextBoxRupees.Add_TextChanged( {
            if ($TextEditor.Edited[0]) { $TextEditor.Edited[4] = $True }

            $regEx = '[^0-9]'
            if ($this.Text -cmatch $regEx) {
                $this.Text = $this.Text.ToUpper() -replace $regEx,''
                $this.Select($this.Text.Length, $this.Text.Length)
            }
            if ($this.Text -cmatch " ") {
                $this.Text = $this.Text.ToUpper() -replace " ",''
                $this.Select($this.Text.Length, $this.Text.Length)
            }
        } )

        $TextEditor.TextBoxJump.Add_TextChanged( {
            if ($TextEditor.Edited[0]) { $TextEditor.Edited[5] = $True }

            $regEx = '[^0-9a-fA-F]'
            if ($this.Text -cmatch $regEx) {
                $this.Text = $this.Text.ToUpper() -replace $regEx,''
                $this.Select($this.Text.Length, $this.Text.Length)
            }
            if ($this.Text -cmatch " ") {
                $this.Text = $this.Text.ToUpper() -replace " ",''
                $this.Select($this.Text.Length, $this.Text.Length)
            }
        } )

        $TextEditor.TextBoxIcon.enabled = $TextEditor.TextBoxRupees.enabled = $TextEditor.TextBoxJump.enabled = $False
    }
    $TextEditor.Content.Add_TextChanged(                  { if ($TextEditor.Edited[0]) { $TextEditor.Edited[1] = $True } })
    $TextEditor.TextBoxType.Add_SelectedIndexChanged(     { if ($TextEditor.Edited[0]) { $TextEditor.Edited[2] = $True } })
    $TextEditor.TextBoxPosition.Add_SelectedIndexChanged( { if ($TextEditor.Edited[0]) { $TextEditor.Edited[2] = $True } })
    $TextEditor.TextBoxType.enabled = $TextEditor.TextBoxPosition.enabled = $False

    $SearchButton.Add_Click({
        $TextEditor.ListPanel.VerticalScroll.Value = 0;
        $i      = 0
        $row    = $column = 0
        if ($TextEditor.SearchBar.text.length -eq 0) {
            foreach ($btn in $TextEditor.ListPanel.Controls) {
                if ($column -eq 10) {
                    $row++
                    $column = 0
                }
                $btn.Visible  = $True
                $btn.Location = New-Object System.Drawing.Size(($column * (DPISize 50) + ((DPISize 3))), ($row * (DPISize 25)))
                $column++
            }
        }
        else {
            $search = ParseMessage -Text ($TextEditor.SearchBar.text | Format-Hex | Select-Object -Expand Bytes) -Encode
            foreach ($btn in $TextEditor.ListPanel.Controls) {
                $start   = GetDecimal ( (Get8Bit $ByteTableArray[$i+5])   + (Get8Bit $ByteTableArray[$i+6])   + (Get8Bit $ByteTableArray[$i+7])   )
                $end     = GetDecimal ( (Get8Bit $ByteTableArray[$i+5+8]) + (Get8Bit $ByteTableArray[$i+6+8]) + (Get8Bit $ByteTableArray[$i+7+8]) )
                $message = $ByteScriptArray[($start+$Files.json.textEditor.header)..$end]
                $i      += 8

                $matches = $False
                $index = 0
                foreach ($c in $message) {
                    if     ($c -eq $search[$index])   { $index++   }
                    elseif ($index -gt 0)             { $index = 0 }
                    if ($index -eq $search.count) {
                        $matches = $True
                        break
                    }
                }

                if ($matches) {
                    if ($column -eq 10) {
                        $row++
                        $column = 0
                    }
                    $btn.Visible  = $True
                    $btn.Location = New-Object System.Drawing.Size(($column * (DPISize 50) + ((DPISize 3))), ($row * (DPISize 25)))
                    $column++
                }
                else { $btn.Visible = $False }
            }
        }
    })

    $ExtractButton.Add_Click({
        $global:PatchInfo     = @{}
        $PatchInfo.decompress = $True
        $global:CheckHashSum  = $TextEditor.Checksum
        $global:ROMFile       = SetROMParameters -Path $GamePath
        SetGetROM

        if ($IsWiiVC) {
            if (!(ExtractWADFile))    { return }   # Step A: Extract the contents of the WAD file
            if (!(CheckVCGameID))     { return }   # Step B: Check the GameID to be vanilla
            if (!(ExtractU8AppFile))  { return }   # Step C: Extract "00000005.app" file to get the ROM
            if (!(PatchVCROM))        { return }   # Step D: Do some initial patching stuff for the ROM for VC WAD files
        }

        if (!(Unpack))                                                              { UpdateStatusLabel "Failed! Could not extract ROM."; return }
        if (TestFile $GetROM.run)                                                   { $global:ROMHashSum   = (Get-FileHash -Algorithm MD5 -LiteralPath $GetROM.run).Hash }
        if ($Settings.Debug.IgnoreChecksum -eq $False -and (IsSet $CheckHashsum))   { $PatchInfo.downgrade = ($ROMHashSum -ne $CheckHashSum)                             }
        if ((Get-Item -LiteralPath $GetROM.run).length/"32MB" -ne 1)                { UpdateStatusLabel "Failed! The ROM should be 32 MB!"; return $False }

        if ($PatchInfo.run) {
            ConvertROM $Command
            if (!(CompareHashSums $Command)) { UpdateStatusLabel "Failed! The ROM is an incorrect version or is broken."; return }
        }

        if (!(DecompressROM)) { UpdateStatusLabel "Failed! The ROM could not be compressed."; return }
        $item = DowngradeROM

        # Extract script
        if ((IsSet $Files.json.languages[0].script_dma) -and (IsSet $Files.json.languages[0].table_start) -and (IsSet $Files.json.languages[0].table_length)) {
            $global:ByteArrayGame = [System.IO.File]::ReadAllBytes($GetROM.decomp)
            CreateSubPath $GameFiles.editor
            $start  = CombineHex $ByteArrayGame[((GetDecimal $Files.json.languages[0].script_dma)+0)..((GetDecimal $Files.json.languages[0].script_dma)+3)]
            $end    = CombineHex $ByteArrayGame[((GetDecimal $Files.json.languages[0].script_dma)+4)..((GetDecimal $Files.json.languages[0].script_dma)+7)]
            $length = Get32Bit ( (GetDecimal $end) - (GetDecimal $start) )
            ExportBytes -Offset $start                               -Length $length                               -Output ($GameFiles.editor + "\message_data_static.bin") -Force
            ExportBytes -Offset $Files.json.languages[0].table_start -Length $Files.json.languages[0].table_length -Output ($GameFiles.editor + "\message_data.tbl")        -Force
        }

        Cleanup
        LoadMessages
        PlaySound $Sounds.done # Play a sound when it is finished
        UpdateStatusLabel "Success! Script has been extracted."
    })

}



#==============================================================================================================================================================================================
function RunTextEditor([string]$Game=$GameType.mode, [string]$Checksum) {
    
    CreateTextEditorDialog -Game $Game -Checksum $Checksum
    $TextEditor.Dialog.ShowDialog()
    if (!(TestFile ($Paths.Games + "\" + $Game + "\Editor\message_data_static.bin")) -or !(TestFile ($Paths.Games + "\" + $Game + "\Editor\message_data.tbl")) ) { return }
    SaveLastMessage
    SaveScript -Script ($Paths.Games + "\" + $Game + "\Editor\message_data_static.bin") -Table ($Paths.Games + "\" + $Game + "\Editor\message_data.tbl")
    CreateSubPath ($Paths.Games + "\" + $Game + "\Custom Text")
    Copy-Item -LiteralPath ($Paths.Games + "\" + $Game + "\Editor\message_data_static.bin") -Destination ($Paths.Games + "\" + $Game + "\Custom Text\message_data_static.bin") -Force
    Copy-Item -LiteralPath ($Paths.Games + "\" + $Game + "\Editor\message_data.tbl")        -Destination ($Paths.Games + "\" + $Game + "\Custom Text\message_data.tbl")        -Force

}



#==============================================================================================================================================================================================
function LoadMessages() {

    if (!(TestFile ($Paths.Games + "\" + $TextEditor.Game + "\Editor\message_data_static.bin")) -or !(TestFile ($Paths.Games + "\" + $TextEditor.Game + "\Editor\message_data.tbl")) ) { return $False }
    LoadScript -Script ($Paths.Games + "\" + $TextEditor.Game + "\Editor\message_data_static.bin") -Table ($Paths.Games + "\" + $TextEditor.Game + "\Editor\message_data.tbl")
    GetMessageIDs

}



#==============================================================================================================================================================================================
function LoadScript([string]$Script, [string]$Table) {

    [System.Collections.ArrayList]$global:ByteScriptArray = [System.IO.File]::ReadAllBytes($Script)
    [System.Collections.ArrayList]$global:ByteTableArray  = [System.IO.File]::ReadAllBytes($Table)

}



#==============================================================================================================================================================================================
function SaveScript([string]$Script, [string]$Table) {

    [System.IO.File]::WriteAllBytes($Script, $ByteScriptArray)
    [System.IO.File]::WriteAllBytes($Table,  $ByteTableArray)

}



#==============================================================================================================================================================================================
function SaveLastMessage() {
    
    if (IsSet $ScriptLastID) {
        if ($TextEditor.Edited[1]) { SetMessage -Replace $TextEditor.Content.Text -ID $ScriptLastID }
        if ($TextEditor.Edited[2]) { SetMessageBox -ID $ScriptLastID -Type $TextEditor.TextBoxType.selectedIndex -Position $TextEditor.TextBoxPosition.selectedIndex }
        if ($Files.json.textEditor.header -gt 0) {
            if ($TextEditor.Edited[3]) { SetMessageIcon   -ID $ScriptLastID -Value $TextEditor.TextBoxIcon.text             }
            if ($TextEditor.Edited[4]) { SetMessageRupees -ID $ScriptLastID -Value ([uint16]$TextEditor.TextBoxRupees.text) }
            if ($TextEditor.Edited[5]) { SetJumpToMessage -ID $ScriptLastID -Value $TextEditor.TextBoxJump.text             }
        }
        for ($i=0; $i -lt $TextEditor.Edited.count; $i++) { $TextEditor.edited[$i] = $False }
    }

}


#==============================================================================================================================================================================================
function GetMessage([string]$ID) {
    
    if ( (GetDecimal $ID) -ge (GetDecimal $ScriptLastID) )   { $start = $ScriptLastIndex }
    else                                                     { $start = 0                }

    for ($i=$start; $i -lt $ByteTableArray.count; $i+=8) {
        if (@(Compare-Object $ByteTableArray[$i..($i+1)] @(255, 253) -SyncWindow 0).Length -eq 0) { break }
        $combine = CombineHex $ByteTableArray[$i..($i+1)]
        if ($combine -eq $ID) {
            $global:ScriptLastID    = $combine
            $global:ScriptLastIndex = $i
            $offset                 = GetDecimal (CombineHex $ByteTableArray[($i  +5)..($i  +7)])
            $length                 = GetDecimal (CombineHex $ByteTableArray[($i+5+8)..($i+7+8)])

            if ($TextEditor) {
                if ($Files.json.textEditor.header -gt 0) {
                    $TextEditor.LastBoxType     = $ByteScriptArray[$offset + 0]
                    $TextEditor.LastBoxPosition = $ByteScriptArray[$offset + 1] -shr 4
                    $TextEditor.LastBoxIcon     = Get8Bit $ByteScriptArray[$offset + 2]
                    $TextEditor.LastBoxRupees   = GetDecimal (CombineHex $ByteScriptArray[($offset + 5)..($offset + 6)])
                    if ($TextEditor.LastBoxRupees -eq 65535) { $TextEditor.LastBoxRupees = 0 }
                    $TextEditor.LastBoxJump     = CombineHex $ByteScriptArray[($offset + 3)..($offset + 4)]

                    foreach ($icon in $Files.json.textEditor.icons) {
                        if ($icon.id -eq $TextEditor.LastBoxIcon) {
                            $TextEditor.TextBoxIcon.text = $icon.name
                            break
                        }
                    }
                    $TextEditor.TextBoxRupees.text = $TextEditor.LastBoxRupees
                    $TextEditor.TextBoxJump.text   = $TextEditor.LastBoxJump
                }
                else {
                    $TextEditor.LastBoxType     =  $ByteTableArray[$i + 2] -shr 4       # Upper
                    $TextEditor.LastBoxPosition = ($ByteTableArray[$i + 2] -shl 4) / 16 # Lower
                }

                foreach ($box in $Files.json.textEditor.textboxes) {
                    if ($box.id -eq $TextEditor.LastBoxType) {
                        $TextEditor.TextBoxType.text = $box.name
                        break
                    }
                }
                if ($TextEditor.LastBoxPosition -ge 3)   { $TextEditor.TextBoxPosition.selectedIndex = 3 }
                else                                 { $TextEditor.TextBoxPosition.selectedIndex = GetDecimal $TextEditor.LastBoxPosition }
            }

            return [string]([char[]](ParseMessage -Text $ByteScriptArray[($offset+$Files.json.textEditor.header)..($length-1)]) -join '')
        }
    }
    return ""

}



#==============================================================================================================================================================================================
function GetMessageIDs([switch]$Generate) {
    
    $column = $row = 0
    for ($i=0; $i -lt $ByteTableArray.count; $i+=8) {
        if (@(Compare-Object $ByteTableArray[$i..($i+1)] @(255, 253) -SyncWindow 0).Length -eq 0) { break }
        $item = (Get8Bit $ByteTableArray[$i]) + (Get8Bit $ByteTableArray[$i+1])
        if ($column -eq 10) {
            $row++
            $column = 0
        }
        AddMessageIDButton -ID $item -Column $column -Row $row
        $column++;
    }

}



#==============================================================================================================================================================================================
function AddMessageIDButton([string]$ID, [byte]$Column, [uint16]$Row) {
    
    $button           = New-Object System.Windows.Forms.Button
    $button.Text      = $ID
    $button.Font      = $Fonts.Small
    $button.Size      = New-Object System.Drawing.Size((DPISize 50), (DPISize 25))
    $button.Location  = New-Object System.Drawing.Size(($column * (DPISize 50) + ((DPISize 3))), ($row * (DPISize 25)))
    $button.ForeColor = "White"
    $button.BackColor = "Gray"
    $button.Add_Click( {
        SaveLastMessage
        $TextEditor.Content.Text = GetMessage -ID $this.Text
        if (IsSet $TextEditor.LastButton) { $TextEditor.LastButton.BackColor = "Gray" }
        $TextEditor.LastButton = $this
        $this.BackColor = "DarkGray"
        $TextEditor.TextBoxType.enabled = $TextEditor.TextBoxPosition.enabled = $True
        if ($Files.json.textEditor.header -gt 0) { $TextEditor.TextBoxIcon.enabled = $TextEditor.TextBoxRupees.enabled = $TextEditor.TextBoxJump.enabled = $True }
        $TextEditor.Edited[0] = $True
    } )
    $TextEditor.ListPanel.Controls.Add($button)

}



#==============================================================================================================================================================================================
function CorrectMessageIDs([string]$ID, [int16]$Correct) {
    
    if (!(IsSet $ID)) {
        $start = $ScriptLastIndex
        $ID    = $ScriptLastID
    }
    else {
        if ( (GetDecimal $ID) -ge ($ScriptLastID) )   { $start = $ScriptLastIndex }
        else                                          { $start = 0                }
    }

    for ($i=0; $i -lt $ByteTableArray.count; $i+= 8) {
        $arr = $ByteTableArray[$i..($i+1)]
        if (@(Compare-Object $arr @(255, 253) -SyncWindow 0).Length -eq 0) { break }
        if ( (CombineHex $arr) -eq $ID) {
            $start = $i + 8
            break
        }
    }

    for ($i=$start; $i -lt $ByteTableArray.count; $i+=8) {
        if (@(Compare-Object $ByteTableArray[$i..($i+1)] @(255, 253) -SyncWindow 0).Length -eq 0) { break }
        $offset = CombineHex @($ByteTableArray[$i+5], $ByteTableArray[$i+6], $ByteTableArray[$i+7])
        $offset = (GetDecimal $offset) + $Correct
        $offset = Get24Bit $offset
        $offset = $offset -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) }
        for ($j=0; $j -lt $offset.length; $j++) { $ByteTableArray[$i + 5 + $j]  = $offset[$j] }
    }

}



#==============================================================================================================================================================================================
function GetMessageOffset([string]$ID) {
    
    if (!(IsSet $ID)) {
        $start = $ScriptLastIndex
        $ID    = $ScriptLastID
    }
    else {
        if ( (GetDecimal $ID) -ge (GetDecimal $ScriptLastID) )   { $start = $ScriptLastIndex }
        else                                                     { $start = 0                }
    }

    for ($i=$start; $i -lt $ByteTableArray.count; $i+=8) {
        if (@(Compare-Object $ByteTableArray[$i..($i+1)] @(255, 253) -SyncWindow 0).Length -eq 0) { break }
        $combine = CombineHex $ByteTableArray[$i..($i+1)]
        if ($Combine -eq $ID) {
            $global:ScriptLastID    = $combine
            $global:ScriptLastIndex = $i
            return ( CombineHex @($ByteTableArray[$i+5], $ByteTableArray[$i+6], $ByteTableArray[$i+7]) )
        }
    }
    return -1

}



#==============================================================================================================================================================================================
function GetMessageLength([string]$ID) {
    
    if (!(IsSet $ID)) {
        $start = $ScriptLastIndex
        $ID    = $ScriptLastID
    }
    else {
        if ( (GetDecimal $ID) -ge (GetDecimal $ScriptLastID) )   { $start = $ScriptLastIndex }
        else                                                     { $start = 0                }
    }

    for ($i=$start; $i -lt $ByteTableArray.count; $i+=8) {
        if (@(Compare-Object $ByteTableArray[$i..($i+1)] @(255, 253) -SyncWindow 0).Length -eq 0) { break }
        $combine = CombineHex $ByteTableArray[$i..($i+1)]
        if ( (GetDecimal $Combine) -eq (GetDecimal $ID) ) {
            $global:ScriptLastID    = $combine
            $global:ScriptLastIndex = $i
            $first = ( CombineHex @($ByteTableArray[$i+5],   $ByteTableArray[$i+6],   $ByteTableArray[$i+7])   )
            $next  = ( CombineHex @($ByteTableArray[$i+5+8], $ByteTableArray[$i+6+8], $ByteTableArray[$i+7+8]) )
            return Get24Bit (GetDecimal (SubtractFromOffset -Hex $next -Subtract $first) )
        }
    }
    return -1

}

#==============================================================================================================================================================================================
function SetMessageBox([string]$ID, [byte]$Type, [byte]$Position) {
    
    if (!(IsSet $ID)) {
        $start = $ScriptLastIndex
        $ID    = $ScriptLastID
    }
    else {
        if ( (GetDecimal $ID) -ge (GetDecimal $ScriptLastID) )   { $start = $ScriptLastIndex }
        else                                                     { $start = 0                }
    }

    for ($i=$start; $i -lt $ByteTableArray.count; $i+=8) {
        if (@(Compare-Object $ByteTableArray[$i..($i+1)] @(255, 253) -SyncWindow 0).Length -eq 0) { break }
        $combine = CombineHex $ByteTableArray[$i..($i+1)]
        if ( (GetDecimal $Combine) -eq (GetDecimal $ID) ) {
            $global:ScriptLastID            = $combine
            $global:ScriptLastIndex         = $i
            if ($Position -gt 3) { $Position = 3 }
            if ($Files.json.textEditor.header -gt 0) {
                [uint32]$offset             = GetDecimal (GetMessageOffset)
                $ByteScriptArray[$offset]   = $Type
                $ByteScriptArray[$offset+1] = $Position * 16
            }
            else { $ByteTableArray[$i+2] = $Type * 16 + $Position }
            break
        }
    }

}

#==============================================================================================================================================================================================
function SetMessageIcon([string]$ID, [string]$Value) {
    
    if (!(IsSet $ID)) {
        $start = $ScriptLastIndex
        $ID    = $ScriptLastID
    }
    else {
        if ( (GetDecimal $ID) -ge (GetDecimal $ScriptLastID) )   { $start = $ScriptLastIndex }
        else                                                     { $start = 0                }
    }

    for ($i=$start; $i -lt $ByteTableArray.count; $i+= 8) {
        if (@(Compare-Object $ByteTableArray[$i..($i+1)] @(255, 253) -SyncWindow 0).Length -eq 0) { break }
        $combine = CombineHex $ByteTableArray[$i..($i+1)]
        if ( (GetDecimal $Combine) -eq (GetDecimal $ID) ) {
            $global:ScriptLastID        = $combine
            $global:ScriptLastIndex     = $i
            [uint32]$offset             = GetDecimal (GetMessageOffset)
            foreach ($icon in $Files.json.textEditor.icons) {
                if ($icon.name -eq $TextEditor.TextBoxIcon.text) {
                    $ByteScriptArray[$offset+2] = GetDecimal $icon.id
                    break
                }
            }
            break
        }
    }

}

#==============================================================================================================================================================================================
function SetMessageRupees([string]$ID, [uint16]$Value) {
    
    if (!(IsSet $ID)) {
        $start = $ScriptLastIndex
        $ID    = $ScriptLastID
    }
    else {
        if ( (GetDecimal $ID) -ge (GetDecimal $ScriptLastID) )   { $start = $ScriptLastIndex }
        else                                                     { $start = 0                }
    }

    for ($i=$start; $i -lt $ByteTableArray.count; $i+=8) {
        if (@(Compare-Object $ByteTableArray[$i..($i+1)] @(255, 253) -SyncWindow 0).Length -eq 0) { break }
        $combine = CombineHex $ByteTableArray[$i..($i+1)]
        if ( (GetDecimal $Combine) -eq (GetDecimal $ID) ) {
            $global:ScriptLastID    = $combine
            $global:ScriptLastIndex = $i
            [uint32]$offset         = GetDecimal (GetMessageOffset)
            if ($Value -eq 0) { $Value = 65535 }
            [byte[]]$split          = (Get16Bit $Value) -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) }
            $ByteScriptArray[$offset + 5] = $split[0]
            $ByteScriptArray[$offset + 6] = $split[1]
            break
        }
    }

}

#==============================================================================================================================================================================================
function SetJumpToMessage([string]$ID, [string]$Value) {
    
    if (!(IsSet $ID)) {
        $start = $ScriptLastIndex
        $ID    = $ScriptLastID
    }
    else {
        if ( (GetDecimal $ID) -ge (GetDecimal $ScriptLastID) )   { $start = $ScriptLastIndex }
        else                                                     { $start = 0                }
    }

    for ($i=$start; $i -lt $ByteTableArray.count; $i+=8) {
        if (@(Compare-Object $ByteTableArray[$i..($i+1)] @(255, 253) -SyncWindow 0).Length -eq 0) { break }
        $combine = CombineHex $ByteTableArray[$i..($i+1)]
        if ( (GetDecimal $Combine) -eq (GetDecimal $ID) ) {
            $global:ScriptLastID    = $combine
            $global:ScriptLastIndex = $i
            [uint32]$offset         = GetDecimal (GetMessageOffset)
            [byte[]]$split          = $Value -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) }
            $ByteScriptArray[$offset + 3] = $split[0]
            $ByteScriptArray[$offset + 4] = $split[1]
            break
        }
    }

}

#==============================================================================================================================================================================================
function SetMessage([string]$ID, [object]$Text, [object]$Replace, [string]$File, [switch]$Full, [switch]$ASCII, [switch]$NoParse) {
    
    $offset = GetMessageOffset -ID $ID
    $length = GetMessageLength -ID $ID

    if ($offset -eq -1) {
        WriteToConsole ("Could not find text offset for message ID: " + $ID)
        return
    }
    if ($length -eq -1) {
        WriteToConsole ("Could not find text length for message ID: " + $ID)
        return
    }

    [uint32]$offset = GetDecimal $offset
    [uint16]$length = GetDecimal $length
    [sbyte]$match   = -1
    $re             = "^[a-fa-f 0-9]*$"
    
    if (IsSet $File) {
        if (TestFile -Path ($GameFiles.binaries + "\" + $File)) { $Replace = [System.IO.File]::ReadAllBytes($GameFiles.binaries + "\" + $File) }
    }
    elseif (IsSet $Replace) {
        if ($Replace -match $re -and !$ASCII) {
            if     ($Replace  -is [System.String] -and $Replace  -Like "* *")   { $Replace = $Replace -split ' '           | foreach { [Convert]::ToByte($_, 16) } }
            elseif ($Replace  -is [System.String])                              { $Replace = $Replace -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) } }
        }
        else {
            $Replace = ($Replace | Format-Hex | Select-Object -Expand Bytes) -split ' '
            if (!$NoParse) { $Replace = ParseMessage -Text $Replace -Encode }
        }
    }
    else {
        WriteToConsole ("No text to replace for message ID: " + $ID)
        return
    }

    if (IsSet $Text) {
        if ($Text -match $re -and !$ASCII) {
            if     ($Text  -is [System.String] -and $Text  -Like "* *")   { $Text = $Text -split ' '           | foreach { [Convert]::ToByte($_, 16) } }
            elseif ($Text  -is [System.String])                           { $Text = $Text -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) } }
        }
        else {
            $Text = ($Text | Format-Hex | Select-Object -Expand Bytes) -split ' '
            if (!$NoParse) { $Text = ParseMessage -Text $Text -Encode }
        }

        foreach ($i in ($offset+$Files.json.textEditor.header)..($offset+$length-1)) {
            $Search = $True
            foreach ($j in 0..($Text.length-1)) {
                if ($ByteScriptArray[$i + $j] -ne $Text[$j] ) {
                    $Search = $False
                    break
                }
            }
            if ($Search -eq $True) {
                [uint32]$match = $i
                break
            }
        }

        if ($match -eq -1) {
            WriteToConsole ("Could not find text to edit for message ID: " + $ID)
            return
        }
    }
    else {
        [uint32]$match = $offset
        $Text          = $ByteScriptArray[$offset..($offset+$length-1)]
        [int16]$index  = $Text.indexOf([byte]$Files.json.textEditor.end)
        if ($index -ge 0) { $Text = $Text[0..($index-1)] }
    }

    if ($Replace.count -gt $Text.count) {
        [int16]$newLength = $length
        $removed = 0
        for ($i=0; $i -lt 4; $i++) {
            $get = $offset + $newLength - 1 - $i
            if ($ByteScriptArray[$get] -eq [byte]$Files.json.textEditor.end)   { break }
            if ($ByteScriptArray[$get] -eq [byte]0)                            { $ByteScriptArray.RemoveAt($get); $removed++ }
        }
        $newLength -= $removed
        $ByteScriptArray.RemoveRange($match, $Text.count)
        $newLength -= $Text.count
        $ByteScriptArray.InsertRange($match, $Replace)
        $newLength += $Replace.count
        $diff       = (4 - ($Replace.count - $Text.count) % 4) + $removed

        while ($newLength % 4 -ne 0) { $ByteScriptArray.Insert(($offset + ++$newLength - 1), 0) }
        CorrectMessageIDs -Correct ($newLength - $length)
    }
    elseif ($Text.count -gt $Replace.count) {
        [int16]$newLength = $length
        $removed = 0
        for ($i=0; $i -lt 4; $i++) {
            $get = $offset + $newLength - 1 - $i
            if ($ByteScriptArray[$get] -eq [byte]$Files.json.textEditor.end)   { break }
            if ($ByteScriptArray[$get] -eq [byte]0)                            { $ByteScriptArray.RemoveAt($get); $removed++ }
        }
        $newLength -= $removed
        $ByteScriptArray.RemoveRange($match, $Text.count)
        $newLength -= $Text.count
        $ByteScriptArray.InsertRange($match, $Replace)
        $newLength += $Replace.count
        $diff       = (4 - ($Text.count - $Replace.count) % 4) + $removed

        while ($newLength % 4 -ne 0) { $ByteScriptArray.Insert(($offset + ++$newLength - 1), 0) }
        CorrectMessageIDs -Correct ($newLength - $length)
    }
    
    else { foreach ($i in 0..($Replace.count-1)) { $ByteScriptArray[$match + $i] = $Replace[$i] } }

    WriteToConsole ("Changed text at: " + (Get24Bit $match) + " (ID: " + $ID + ")")

}



#==============================================================================================================================================================================================
function ParseMessage([byte[]]$Text, [switch]$Encode) {
    
    if     ($Files.json.textEditor.parse -eq "oot" -and  $Encode)   { ParseMessageOoT -Text $Text -Encode }
    elseif ($Files.json.textEditor.parse -eq "oot" -and !$Encode)   { ParseMessageOoT -Text $Text         }
    elseif ($Files.json.textEditor.parse -eq "mm"  -and  $Encode)   { ParseMessageMM  -Text $Text -Encode }
    elseif ($Files.json.textEditor.parse -eq "mm"  -and !$Encode)   { ParseMessageMM  -Text $Text         }
    $global:ScriptCounter = $null

}



#==============================================================================================================================================================================================
function ParseMessageOoT([byte[]]$Text, [switch]$Encode) {
    
  # $TextEditor.IgnoreDecode2 = @(5, 6, 7, 12, 14, 17, 18, 29, 30)
  # $TextEditor.IgnoreDecode3 = @(18)
  # $TextEditor.IgnoreDecode4 = @(21)

    [int16]$index = $Text.indexOf([byte]$Files.json.textEditor.end)
    if ($index -ge 0) { $Text = $Text[0..($index-1)] }

    for ($global:ScriptCounter=0; $ScriptCounter -lt $Text.count; $global:ScriptCounter++) {
        # Backgrounds
        $Text = ParseMessagePart -Text $Text -Encoded @(21, 0,   1,   16)  -Decoded @(60, 66, 97, 99, 107, 103, 114, 111, 117, 110, 100, 58, 50,  55,  50,  62)     -Encode $Encode # 15 00 01 10 / <Background:272>    (Background)
        $Text = ParseMessagePart -Text $Text -Encoded @(21, 0,   32,  0)   -Decoded @(60, 66, 97, 99, 107, 103, 114, 111, 117, 110, 100, 58, 56,  49,  57,  50, 62) -Encode $Encode # 15 00 20 00 / <Background:8192>   (Background)

        # Sound effects / Jump to
        $Text = ParseMessagePart -Text $Text -Encoded @(7,  255, 255) -Decoded @(60, 74, 117, 109, 112, 58,  255, 255, 62)      -Encode $Encode # 07 xx xx / <Jump:xxxx> (jump)
        $Text = ParseMessagePart -Text $Text -Encoded @(18, 255, 255) -Decoded @(60, 83, 111, 117, 110, 100, 58,  255, 255, 62) -Encode $Encode # 12 xx xx / <Sound:xxxx> (sound)

        # Loops
        $Text = ParseMessagePart -Text $Text -Encoded @(6,  255) -Decoded @(60, 83, 104, 105, 102, 116, 58,, 255, 62) -Encode $Encode # 06 xx / <Shift:xx> (shift)
        $Text = ParseMessagePart -Text $Text -Encoded @(12, 255) -Decoded @(60, 68, 101, 108, 97,  121, 58,  255, 62) -Encode $Encode # 0C xx / <Delay:>   (delay)
        $Text = ParseMessagePart -Text $Text -Encoded @(14, 255) -Decoded @(60, 70, 97,  100, 101, 58,  255, 62)      -Encode $Encode # 0E xx / <Fade:xx>  (fade out)
        $Text = ParseMessagePart -Text $Text -Encoded @(17, 255) -Decoded @(60, 87, 97,  105, 116, 58,  255, 62)      -Encode $Encode # 11 xx / <Wait:xx>  (fade out and wait)
        $Text = ParseMessagePart -Text $Text -Encoded @(19, 255) -Decoded @(60, 73, 99,  111, 110, 58,  255, 62)      -Encode $Encode # 13 xx / <Icon:xx>  (icon)
        $Text = ParseMessagePart -Text $Text -Encoded @(20, 255) -Decoded @(60, 83, 112, 101, 101, 100, 58,  255, 62) -Encode $Encode # 14 xx / <Speed:xx> (text speed)
        $Text = ParseMessagePart -Text $Text -Encoded @(19)      -Decoded @(60, 73, 99,  111, 110, 62)                -Encode $Encode # 13    / <Icon>     (icon)

        # Color codes
        $Text = ParseMessagePart -Text $Text -Encoded @(5, 64) -Decoded @(60, 87, 62) -Encode $Encode # 05 40 / <W> (white)
        $Text = ParseMessagePart -Text $Text -Encoded @(5, 65) -Decoded @(60, 82, 62) -Encode $Encode # 05 41 / <R> (red)
        $Text = ParseMessagePart -Text $Text -Encoded @(5, 66) -Decoded @(60, 71, 62) -Encode $Encode # 05 42 / <G> (green)
        $Text = ParseMessagePart -Text $Text -Encoded @(5, 67) -Decoded @(60, 66, 62) -Encode $Encode # 05 43 / <B> (blue)
        $Text = ParseMessagePart -Text $Text -Encoded @(5, 68) -Decoded @(60, 67, 62) -Encode $Encode # 05 44 / <C> (turquoise / cyan / light blue)
        $Text = ParseMessagePart -Text $Text -Encoded @(5, 69) -Decoded @(60, 77, 62) -Encode $Encode # 05 45 / <M> (pink / magenta)
        $Text = ParseMessagePart -Text $Text -Encoded @(5, 70) -Decoded @(60, 89, 62) -Encode $Encode # 05 46 / <Y> (yellow)
        $Text = ParseMessagePart -Text $Text -Encoded @(5, 71) -Decoded @(60, 75, 62) -Encode $Encode # 05 47 / <K> (black / key)
        $Text = ParseMessagePart -Text $Text -Encoded @(5, 1)  -Decoded @(60, 75, 1)  -Encode $Encode # 05 01 / <O> (orange)
        $Text = ParseMessagePart -Text $Text -Encoded @(5, 5)  -Decoded @(60, 75, 5)  -Encode $Encode # 05 05 / <P> (purple)

        # Highscore values
        $Text = ParseMessagePart -Text $Text -Encoded @(30, 0) -Decoded @(60, 83, 99, 111, 114, 101, 58, 65, 114, 99,  104, 101, 114, 121, 62)                -Encode $Encode # 1E 00 / <Score:Archery>    (horseback archery score)
        $Text = ParseMessagePart -Text $Text -Encoded @(30, 1) -Decoded @(60, 83, 99, 111, 114, 101, 58, 80, 111, 101, 32,  80,  111, 105, 110, 116, 115, 62) -Encode $Encode # 1E 01 / <Score:Poe Points> (poe points)
        $Text = ParseMessagePart -Text $Text -Encoded @(30, 2) -Decoded @(60, 83, 99, 111, 114, 101, 58, 70, 105, 115, 104, 105, 110, 103, 62)                -Encode $Encode # 1E 02 / <Score:Fishing>    (largest fish)
        $Text = ParseMessagePart -Text $Text -Encoded @(30, 3) -Decoded @(60, 83, 99, 111, 114, 101, 58, 72, 111, 114, 115, 101, 32,  82,  97,  99,  101, 62) -Encode $Encode # 1E 03 / <Score:Horse Race> (horse race time)
        $Text = ParseMessagePart -Text $Text -Encoded @(30, 4) -Decoded @(60, 83, 99, 111, 114, 101, 58, 77, 97,  114, 97,  116, 104, 111, 110, 62)           -Encode $Encode # 1E 04 / <Score:Marathon>   (marathon time)
        $Text = ParseMessagePart -Text $Text -Encoded @(30, 6) -Decoded @(60, 83, 99, 111, 114, 101, 58, 68, 97,  109, 112, 101, 32,  82,  97,  99,  101, 62) -Encode $Encode # 1E 06 / <Score:Dampe Race> (Dampé race time)

        # Other
        $Text = ParseMessagePart -Text $Text -Encoded @(8)  -Decoded @(60, 68, 73,  62)                                                                     -Encode $Encode # 08 / <DI>               (enable instantaneous text)
        $Text = ParseMessagePart -Text $Text -Encoded @(9)  -Decoded @(60, 68, 67,  62)                                                                     -Encode $Encode # 09 / <DC>               (disable instantaneous text)
        $Text = ParseMessagePart -Text $Text -Encoded @(10) -Decoded @(60, 83, 104, 111, 112, 32,  68, 101, 115, 99, 114, 105, 112, 116, 105, 111, 110, 62) -Encode $Encode # 0A / <Shop Description> (keep box open)
        $Text = ParseMessagePart -Text $Text -Encoded @(11) -Decoded @(60, 69, 118, 101, 110, 116, 62)                                                      -Encode $Encode # 0B / <Event>            (trigger event)
        $Text = ParseMessagePart -Text $Text -Encoded @(13) -Decoded @(60, 80, 114, 101, 115, 115, 62)                                                      -Encode $Encode # 0D / <Press>            (wait for button press)
        $Text = ParseMessagePart -Text $Text -Encoded @(15) -Decoded @(60, 80, 108, 97,  121, 101, 114, 62)                                                 -Encode $Encode # 0F / <Player>           (player name)
        $Text = ParseMessagePart -Text $Text -Encoded @(16) -Decoded @(60, 79, 99,  97,  114, 105, 110, 97, 62)                                             -Encode $Encode # 10 / <Ocarina>          (play ocarina)
        $Text = ParseMessagePart -Text $Text -Encoded @(22) -Decoded @(60, 77, 97,  114, 97,  116, 104, 111, 110, 32,  84, 105, 109, 101, 62)               -Encode $Encode # 16 / <Marathon Time>    (Marathon Time)
        $Text = ParseMessagePart -Text $Text -Encoded @(23) -Decoded @(60, 82, 97,  99,  101, 32,  84,  105, 109, 101, 62)                                  -Encode $Encode # 17 / <Race Time>        (Race Time)
        $Text = ParseMessagePart -Text $Text -Encoded @(24) -Decoded @(60, 80, 111, 105, 110, 116, 115, 62)                                                 -Encode $Encode # 18 / <Points>           (Points)
        $Text = ParseMessagePart -Text $Text -Encoded @(25) -Decoded @(60, 71, 111, 108, 100, 32,  83,  107, 117, 108, 108, 116, 117, 108, 97, 115, 62)     -Encode $Encode # 19 / <Gold Skulltulas>  (Gold Skulltulas)
        $Text = ParseMessagePart -Text $Text -Encoded @(26) -Decoded @(60, 78, 83,  62)                                                                     -Encode $Encode # 1A / <NS>               (prevent text skip with B)
        $Text = ParseMessagePart -Text $Text -Encoded @(27) -Decoded @(60, 84, 104, 114, 101, 101, 32,  67,  104, 111, 105, 99,  101, 115, 62)              -Encode $Encode # 1B / <Three Choices>    (three-choice selection)
        $Text = ParseMessagePart -Text $Text -Encoded @(28) -Decoded @(60, 84, 119, 111, 32,  67,  104, 111, 105, 99,  101, 115, 62)                        -Encode $Encode # 1C / <Two Choices>      (two-choice selection)
        $Text = ParseMessagePart -Text $Text -Encoded @(29) -Decoded @(60, 70, 105, 115, 104, 32,  87,  101, 105, 103, 104, 116, 62)                        -Encode $Encode # 1D / <Fish Weight>      (caught fish)
        $Text = ParseMessagePart -Text $Text -Encoded @(31) -Decoded @(60, 84, 105, 109, 101, 62)                                                           -Encode $Encode # 1F / <Time>             (world time)

        # Controller buttons
        $Text = ParseMessagePart -Text $Text -Encoded @(159) -Decoded @(60, 65, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode # 9F / <A Button>      (A Button)
        $Text = ParseMessagePart -Text $Text -Encoded @(160) -Decoded @(60, 66, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode # A0 / <B Button>      (B Button)
        $Text = ParseMessagePart -Text $Text -Encoded @(161) -Decoded @(60, 67, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode # A1 / <C Button>      (C Button)
        $Text = ParseMessagePart -Text $Text -Encoded @(162) -Decoded @(60, 76, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode # A2 / <L Button>      (L Button)
        $Text = ParseMessagePart -Text $Text -Encoded @(163) -Decoded @(60, 82, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode # A3 / <R Button>      (R Button)
        $Text = ParseMessagePart -Text $Text -Encoded @(164) -Decoded @(60, 90, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode # A4 / <Z Button>      (Z Button)
        $Text = ParseMessagePart -Text $Text -Encoded @(165) -Decoded @(60, 67, 32,  85,  112, 62)                                            -Encode $Encode # A5 / <C Up>          (C-Up)
        $Text = ParseMessagePart -Text $Text -Encoded @(166) -Decoded @(60, 67, 32,  68,  111, 119, 110, 62)                                  -Encode $Encode # A6 / <C Down>        (C-Down)
        $Text = ParseMessagePart -Text $Text -Encoded @(167) -Decoded @(60, 67, 32,  76,  101, 102, 116, 62)                                  -Encode $Encode # A7 / <C Left>        (C-Left)
        $Text = ParseMessagePart -Text $Text -Encoded @(168) -Decoded @(60, 67, 32,  82,  105, 103, 104, 116, 62)                             -Encode $Encode # A8 / <C Right>       (C-Right)
        $Text = ParseMessagePart -Text $Text -Encoded @(169) -Decoded @(60, 84, 114, 105, 97,  110, 103, 108, 101, 62)                        -Encode $Encode # AA / <Triangle>      (Triangle)
        $Text = ParseMessagePart -Text $Text -Encoded @(170) -Decoded @(60, 67, 111, 110, 116, 114, 111, 108, 32,  83, 116, 105, 99, 107, 62) -Encode $Encode # AA / <Control Stick> (Control Stick)
        $Text = ParseMessagePart -Text $Text -Encoded @(171) -Decoded @(60, 68, 45,  80,  97,  100, 62)                                       -Encode $Encode # AB / <D-Pad>         (D-Pad)

        # New box / line break
        if (IsSet $TextEditor.Dialog) {
            $Text = ParseMessagePart -Text $Text -Encoded @(4) -Decoded @(13, 10, 60, 78, 101, 119, 32, 66, 111, 120, 62, 13, 10) -Encode $Encode # 04 / <New Box> (box break with new lines)
            $Text = ParseMessagePart -Text $Text -Encoded @(1) -Decoded @(13, 10)                                                 -Encode $Encode # 01 / `r`n      (new line)
        }
        else {
            $Text = ParseMessagePart -Text $Text -Encoded @(4) -Decoded @(60, 78, 101, 119, 32,  66,  111, 120, 62)  -Encode $Encode # 04 / <New Box> (box break)
            $Text = ParseMessagePart -Text $Text -Encoded @(1) -Decoded @(60, 78, 62)                                -Encode $Encode # 01 / <N>       (new line)
        }
    }
    
    return $Text

}



#==============================================================================================================================================================================================
function ParseMessageMM([byte[]]$Text, [switch]$Encode) {
    
  # $TextEditor.IgnoreDecode2 = @(20)
  # $TextEditor.IgnoreDecode3 = @(27, 28, 29, 30, 31)
  # $TextEditor.IgnoreDecode4 = $null

    [int16]$index = $Text.indexOf([byte]$Files.json.textEditor.end)
    if ($index -ge 0) { $Text = $Text[0..($index-1)] }

    for ($global:ScriptCounter=0; $ScriptCounter -lt $Text.count; $global:ScriptCounter++) {
        # Loops
        $Text = ParseMessagePart -Text $Text -Encoded @(20, 255)      -Decoded @(60, 83, 112, 97,  99,  101, 58,  255, 62)           -Encode $Encode # 14 xx    / <Space:xx>    (print spaces)
        $Text = ParseMessagePart -Text $Text -Encoded @(27, 255, 255) -Decoded @(60, 68, 101, 108, 97,  121, 58,  255, 255, 62)      -Encode $Encode # 1B xx xx / <Delay:xxxx>  (delay before printing remaining text)
        $Text = ParseMessagePart -Text $Text -Encoded @(28, 255, 255) -Decoded @(60, 75, 101, 101, 112, 58,  255, 255, 62)           -Encode $Encode # 1C xx xx / <Keep:xxxx>   (keep text on screen beflore closing)
        $Text = ParseMessagePart -Text $Text -Encoded @(29, 255, 255) -Decoded @(60, 69, 110, 100, 58,  255, 255, 62)                -Encode $Encode # 1D xx xx / <End:xxxx>    (delay before ending conversation)
        $Text = ParseMessagePart -Text $Text -Encoded @(30, 255, 255) -Decoded @(60, 83, 111, 117, 110, 100, 58,  255, 255, 62)      -Encode $Encode # 1E xx xx / <Sound:xxxx>  (play sound effect)
        $Text = ParseMessagePart -Text $Text -Encoded @(31, 255, 255) -Decoded @(60, 82, 101, 115, 117, 109, 101, 58,  255, 255, 62) -Encode $Encode # 1F xx xx / <Resume:xxxx> (delay before resuming text flow)

        # Color codes
        $Text = ParseMessagePart -Text $Text -Encoded @(0) -Decoded @(60, 87, 62) -Encode $Encode # 00 / <W> (white)
        $Text = ParseMessagePart -Text $Text -Encoded @(1) -Decoded @(60, 82, 62) -Encode $Encode # 01 / <R> (red)
        $Text = ParseMessagePart -Text $Text -Encoded @(2) -Decoded @(60, 71, 62) -Encode $Encode # 02 / <G> (green)
        $Text = ParseMessagePart -Text $Text -Encoded @(3) -Decoded @(60, 66, 62) -Encode $Encode # 03 / <B> (blue)
        $Text = ParseMessagePart -Text $Text -Encoded @(4) -Decoded @(60, 67, 62) -Encode $Encode # 04 / <Y> (yellow)
        $Text = ParseMessagePart -Text $Text -Encoded @(5) -Decoded @(60, 77, 62) -Encode $Encode # 05 / <C> (turgoise / cyan / light blue)
        $Text = ParseMessagePart -Text $Text -Encoded @(6) -Decoded @(60, 89, 62) -Encode $Encode # 06 / <M> (pink / magenta)
        $Text = ParseMessagePart -Text $Text -Encoded @(7) -Decoded @(60, 75, 62) -Encode $Encode # 07 / <S> (silver)
        $Text = ParseMessagePart -Text $Text -Encoded @(8) -Decoded @(60, 75, 62) -Encode $Encode # 08 / <O> (orange)

        # Print
        $Text = ParseMessagePart -Text $Text -Encoded @(11)  -Decoded @(60, 67, 114, 117, 105, 115, 101, 32,  67,  114, 117, 105, 115, 101 ,58, 72,  105, 116, 115, 62) -Encode $Encode # 0B / <Jungle Cruise:Hits> (jungle cruise required hits)
        $Text = ParseMessagePart -Text $Text -Encoded @(13)  -Decoded @(60, 71, 111, 108, 100, 32,  83,  107, 117, 108, 108, 116, 117, 108, 97, 115, 62)                -Encode $Encode # 0D / <Gold Skulltulas>    (Gold Skulltulas)
        $Text = ParseMessagePart -Text $Text -Encoded @(22)  -Decoded @(60, 80, 108, 97,  121, 101, 114, 62)                                                            -Encode $Encode # 16 / <Player>             (player name)
        $Text = ParseMessagePart -Text $Text -Encoded @(196) -Decoded @(60, 80, 111, 115, 116, 109, 97,  110, 62)                                                       -Encode $Encode # C4 / <Postman>            (postman counting game)
        $Text = ParseMessagePart -Text $Text -Encoded @(199) -Decoded @(60, 67, 108, 111, 99,  107, 32,  84,  111, 119, 101, 114, 62)                                   -Encode $Encode # C7 / <Clock Tower>        (time until moon falls when on the clock tower)
        $Text = ParseMessagePart -Text $Text -Encoded @(200) -Decoded @(60, 80, 108, 97,  121, 103, 114, 111, 117, 110, 100, 62)                                        -Encode $Encode # C8 / <Playground>         (deku scrub playground)
        $Text = ParseMessagePart -Text $Text -Encoded @(203) -Decoded @(60, 83, 104, 111, 111, 116, 105, 110, 103, 32,  71,  97,  108, 108, 101, 114, 121, 62)          -Encode $Encode # CB / <Shooting Gallery>   (shooting gallery)
        $Text = ParseMessagePart -Text $Text -Encoded @(205) -Decoded @(60, 82, 117, 112, 101, 101, 115, 62)                                                            -Encode $Encode # CD / <Rupees>             (rupees entered or bet)
        $Text = ParseMessagePart -Text $Text -Encoded @(206) -Decoded @(60, 84, 105, 109, 101, 62)                                                                      -Encode $Encode # CE / <Time>               (remaining time)
        $Text = ParseMessagePart -Text $Text -Encoded @(212) -Decoded @(60, 83, 111, 97,  114, 105, 110, 103, 62)                                                       -Encode $Encode # D4 / <Soaring>            (song of soaring destination)
        $Text = ParseMessagePart -Text $Text -Encoded @(218) -Decoded @(60, 67, 114, 117, 105, 115, 101, 32,  67,  114, 117, 105, 115, 101 ,62)                         -Encode $Encode # DA / <Jungle Cruise>      (jungle cruise)
        $Text = ParseMessagePart -Text $Text -Encoded @(220) -Decoded @(60, 76, 111, 116, 116, 101, 114, 121, 58,  87,  105, 110, 62)                                   -Encode $Encode # DC / <Lottery:Win>        (winning lottery numbers)
        $Text = ParseMessagePart -Text $Text -Encoded @(221) -Decoded @(60, 76, 111, 116, 116, 101, 114, 121, 62)                                                       -Encode $Encode # DD / <Lottery>            (player lottery numbers)
        $Text = ParseMessagePart -Text $Text -Encoded @(222) -Decoded @(60, 86, 97,  108, 117, 101, 62)                                                                 -Encode $Encode # DE / <Value>              (item value in rupees)
        $Text = ParseMessagePart -Text $Text -Encoded @(223) -Decoded @(60, 66, 111, 109, 98,  101, 114, 62)                                                            -Encode $Encode # DF / <Bomber>             (bomber's code)
        $Text = ParseMessagePart -Text $Text -Encoded @(240) -Decoded @(60, 66, 97,  110, 107, 62)                                                                      -Encode $Encode # F0 / <Bank>               (totaal rupees in bank)
        $Text = ParseMessagePart -Text $Text -Encoded @(245) -Decoded @(60, 84, 105, 109, 101, 114, 62)                                                                 -Encode $Encode # F5 / <Timer>              (timer / highscore)
        $Text = ParseMessagePart -Text $Text -Encoded @(248) -Decoded @(60, 77, 97,  103, 105, 99,  32,  66, 101, 97,  110, 62)                                         -Encode $Encode # F8 / <Magic Bean>         (magic bean prise)

        # Display prompt
        $Text = ParseMessagePart -Text $Text -Encoded @(204) -Decoded @(60, 80, 114, 111, 109, 112, 116, 58, 66, 97,  110, 107, 62)                -Encode $Encode # CC / <Prompt:Bank>    (Withdraw or deposit)
        $Text = ParseMessagePart -Text $Text -Encoded @(208) -Decoded @(60, 80, 114, 111, 109, 112, 116, 58, 66, 101, 116, 62)                     -Encode $Encode # D0 / <Prompt:Bet>     (rupees to bet)
        $Text = ParseMessagePart -Text $Text -Encoded @(209) -Decoded @(60, 80, 114, 111, 109, 112, 116, 58, 66, 111, 109, 98,  101, 114, 62)      -Encode $Encode # D1 / <Prompt:Bomber>  (bomber's code)
        $Text = ParseMessagePart -Text $Text -Encoded @(213) -Decoded @(60, 80, 114, 111, 109, 112, 116, 58, 76, 111, 116, 116, 101, 114, 121, 62) -Encode $Encode # D5 / <Prompt:Lottery> (lottery number)

        # Scores
        $Text = ParseMessagePart -Text $Text -Encoded @(246) -Decoded @(60, 83, 99, 111, 114, 101, 58, 83, 104, 111, 111, 116, 105, 110, 103, 32,  71,  97, 108, 108, 101, 121, 62) -Encode $Encode # F6 / <Score:Shooting Galley> (shooting gallery highscore)
        $Text = ParseMessagePart -Text $Text -Encoded @(249) -Decoded @(60, 83, 99, 111, 114, 101, 58, 66, 97,  108, 108, 111, 111, 110, 32,  65,  114, 99, 104, 101, 114, 121, 62) -Encode $Encode # F9 / <Score:Balloon Archery> (balloon archery highscore)
        $Text = ParseMessagePart -Text $Text -Encoded @(250) -Decoded @(60, 83, 99, 111, 114, 101, 58, 80, 108, 97,  121, 103, 114, 111, 117, 110, 100, 32, 49,  62)                -Encode $Encode # FA / <Score:Playground 1>    (playground day 1 highscore)
        $Text = ParseMessagePart -Text $Text -Encoded @(251) -Decoded @(60, 83, 99, 111, 114, 101, 58, 80, 108, 97,  121, 103, 114, 111, 117, 110, 100, 32, 50,  62)                -Encode $Encode # FB / <Score:Playground 2>    (playground day 2 highscore)
        $Text = ParseMessagePart -Text $Text -Encoded @(252) -Decoded @(60, 83, 99, 111, 114, 101, 58, 80, 108, 97,  121, 103, 114, 111, 117, 110, 100, 32, 51,  62)                -Encode $Encode # FC / <Score:Playground 3>    (playground day 3 highscore)

        # Fairies
        $Text = ParseMessagePart -Text $Text -Encoded @(12)  -Decoded @(60, 70, 97, 105, 114, 105, 101, 115, 62)         -Encode $Encode # 0C / <Fairies>   (collected stray fairies)
        $Text = ParseMessagePart -Text $Text -Encoded @(215) -Decoded @(60, 70, 97, 105, 114, 105, 101, 115, 58, 49, 62) -Encode $Encode # D7 / <Fairies:1> (remaining fairies woodfall temple)
        $Text = ParseMessagePart -Text $Text -Encoded @(216) -Decoded @(60, 70, 97, 105, 114, 105, 101, 115, 58, 50, 62) -Encode $Encode # D8 / <Fairies:2> (remaining fairies snowhead temple)
        $Text = ParseMessagePart -Text $Text -Encoded @(217) -Decoded @(60, 70, 97, 105, 114, 105, 101, 115, 58, 51, 62) -Encode $Encode # D9 / <Fairies:3> (remaining fairies great bay temple)
        $Text = ParseMessagePart -Text $Text -Encoded @(218) -Decoded @(60, 70, 97, 105, 114, 105, 101, 115, 58, 52, 62) -Encode $Encode # DA / <Fairies:4> (remaining fairies stone tower temple)

        # Print (spider house)
        $Text = ParseMessagePart -Text $Text -Encoded @(214) -Decoded @(32, 60, 83, 112, 105, 100, 101, 114, 32, 72, 111, 117, 115, 101, 62)         -Encode $Encode # D6 / <Spider House>   (123456 spider house mask code)
        $Text = ParseMessagePart -Text $Text -Encoded @(225) -Decoded @(32, 60, 83, 112, 105, 100, 101, 114, 32, 72, 111, 117, 115, 101, 58, 49, 62) -Encode $Encode # E1 / <Spider House:1> (oceanside spider house mask color 1)
        $Text = ParseMessagePart -Text $Text -Encoded @(226) -Decoded @(32, 60, 83, 112, 105, 100, 101, 114, 32, 72, 111, 117, 115, 101, 58, 50, 62) -Encode $Encode # E2 / <Spider House:2> (oceanside spider house mask color 2)
        $Text = ParseMessagePart -Text $Text -Encoded @(227) -Decoded @(32, 60, 83, 112, 105, 100, 101, 114, 32, 72, 111, 117, 115, 101, 58, 51, 62) -Encode $Encode # E3 / <Spider House:3> (oceanside spider house mask color 3)
        $Text = ParseMessagePart -Text $Text -Encoded @(228) -Decoded @(32, 60, 83, 112, 105, 100, 101, 114, 32, 72, 111, 117, 115, 101, 58, 52, 62) -Encode $Encode # E4 / <Spider House:4> (oceanside spider house mask color 4)
        $Text = ParseMessagePart -Text $Text -Encoded @(229) -Decoded @(32, 60, 83, 112, 105, 100, 101, 114, 32, 72, 111, 117, 115, 101, 58, 53, 62) -Encode $Encode # E5 / <Spider House:5> (oceanside spider house mask color 5)
        $Text = ParseMessagePart -Text $Text -Encoded @(230) -Decoded @(32, 60, 83, 112, 105, 100, 101, 114, 32, 72, 111, 117, 115, 101, 58, 54, 62) -Encode $Encode # E6 / <Spider House:6> (oceanside spider house mask color 6)

        # Other
        $Text = ParseMessagePart -Text $Text -Encoded @(19)  -Decoded @(60, 82, 101, 115, 101, 116, 62)                                                        -Encode $Encode # 13 / <Reset>            (reset cursor position)
        $Text = ParseMessagePart -Text $Text -Encoded @(23)  -Decoded @(60, 68, 73,  62)                                                                       -Encode $Encode # 17 / <DI>               (enable instantaneous text)
        $Text = ParseMessagePart -Text $Text -Encoded @(24)  -Decoded @(60, 68, 67,  62)                                                                       -Encode $Encode # 18 / <DC>               (disable instantaneous text)
        $Text = ParseMessagePart -Text $Text -Encoded @(26)  -Decoded @(60, 83, 104, 111, 112, 32,  68,  101, 115, 99,  114, 105, 112, 116, 105, 111, 110, 62) -Encode $Encode # 1A / <Shop Description> (keep box open)
        $Text = ParseMessagePart -Text $Text -Encoded @(193) -Decoded @(60, 79, 99,  97,  114, 105, 110, 97,  62)                                              -Encode $Encode # C1 / <Ocarina>          (ocarina song failure)
        $Text = ParseMessagePart -Text $Text -Encoded @(21)  -Decoded @(60, 78, 83,  62)                                                                       -Encode $Encode # 15 / <NS>               (prevent text skip with B, without sound)
        $Text = ParseMessagePart -Text $Text -Encoded @(25)  -Decoded @(60, 78, 83,  83,  62)                                                                  -Encode $Encode # 19 / <NSS>              (prevent text skip with B, with sound)
        $Text = ParseMessagePart -Text $Text -Encoded @(26)  -Decoded @(60, 78, 67,  62)                                                                       -Encode $Encode # 1A / <NC>               (prevent textbox close)
        $Text = ParseMessagePart -Text $Text -Encoded @(195) -Decoded @(60, 84, 104, 114, 101, 101, 32,  67,  104, 111, 105, 99,  101, 115, 62)                -Encode $Encode # C3 / <Three Choices>    (three-choice selection)
        $Text = ParseMessagePart -Text $Text -Encoded @(194) -Decoded @(60, 84, 119, 111, 32,  67,  104, 111, 105, 99,  101, 115, 62)                          -Encode $Encode # C2 / <Two Choices>      (two-choice selection)


        # Controller buttons
        $Text = ParseMessagePart -Text $Text -Encoded @(176) -Decoded @(60, 65, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode # B0 / <A Button>      (A Button)
        $Text = ParseMessagePart -Text $Text -Encoded @(177) -Decoded @(60, 66, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode # B1 / <B Button>      (B Button)
        $Text = ParseMessagePart -Text $Text -Encoded @(178) -Decoded @(60, 67, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode # B2 / <C Button>      (C Button)
        $Text = ParseMessagePart -Text $Text -Encoded @(179) -Decoded @(60, 76, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode # B3 / <L Button>      (L Button)
        $Text = ParseMessagePart -Text $Text -Encoded @(180) -Decoded @(60, 82, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode # B4 / <R Button>      (R Button)
        $Text = ParseMessagePart -Text $Text -Encoded @(181) -Decoded @(60, 90, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode # B5 / <Z Button>      (Z Button)
        $Text = ParseMessagePart -Text $Text -Encoded @(182) -Decoded @(60, 67, 32,  85,  112, 62)                                            -Encode $Encode # B6 / <C Up>          (C-Up)
        $Text = ParseMessagePart -Text $Text -Encoded @(183) -Decoded @(60, 67, 32,  68,  111, 119, 110, 62)                                  -Encode $Encode # B7 / <C Down>        (C-Down)
        $Text = ParseMessagePart -Text $Text -Encoded @(184) -Decoded @(60, 67, 32,  76,  101, 102, 116, 62)                                  -Encode $Encode # B8 / <C Left>        (C-Left)
        $Text = ParseMessagePart -Text $Text -Encoded @(185) -Decoded @(60, 67, 32,  82,  105, 103, 104, 116, 62)                             -Encode $Encode # B9 / <C Right>       (C-Right)
        $Text = ParseMessagePart -Text $Text -Encoded @(186) -Decoded @(60, 84, 114, 105, 97,  110, 103, 108, 101, 62)                        -Encode $Encode # BA / <Triangle>      (Triangle)
        $Text = ParseMessagePart -Text $Text -Encoded @(187) -Decoded @(60, 67, 111, 110, 116, 114, 111, 108, 32,  83, 116, 105, 99, 107, 62) -Encode $Encode # BB / <Control Stick> (Control Stick)
        $Text = ParseMessagePart -Text $Text -Encoded @(188) -Decoded @(60, 68, 45,  80,  97,  100, 62)                                       -Encode $Encode # BC / <D-Pad>         (D-Pad)

        # New box / line break
        if (IsSet $TextEditor.Dialog) {
            $Text = ParseMessagePart -Text $Text -Encoded @(16) -Decoded @(13, 10, 60,  78,  101, 119, 32,  66,  111, 120, 62, 13, 10)             -Encode $Encode # 10 / <New Box>    (box break with new lines)
            $Text = ParseMessagePart -Text $Text -Encoded @(18) -Decoded @(13, 10, 60,  78,  101, 119, 32,  66,  111, 120, 32, 73, 73, 62, 13, 10) -Encode $Encode # 12 / <New Box II> (box break with new lines)
            $Text = ParseMessagePart -Text $Text -Encoded @(17) -Decoded @(13, 10)                                                                 -Encode $Encode # 11 / `r`n         (new line)
        }
        else {
            $Text = ParseMessagePart -Text $Text -Encoded @(16) -Decoded @(60, 78, 101, 119, 32,  66,  111, 120, 62)                               -Encode $Encode # 10 / <New Box>    (box break)
            $Text = ParseMessagePart -Text $Text -Encoded @(18) -Decoded @(60, 78, 101, 119, 32,  66,  111, 120, 32,  73,  73, 62)                 -Encode $Encode # 12 / <New Box II> (box break)
            $Text = ParseMessagePart -Text $Text -Encoded @(17) -Decoded @(60, 78, 62)                                                             -Encode $Encode # 11 / <N>          (new line)
        }
    }

    return $Text

}



#==============================================================================================================================================================================================

function ParseMessagePart([System.Collections.ArrayList]$Text, [System.Collections.ArrayList]$Encoded, [System.Collections.ArrayList]$Decoded, [boolean]$Encode=$False) {
    
    $i= $ScriptCounter

    if ($Encode -and $Text.count -ge $Decoded.count -and $Text.count -gt 1 -and $i -le ($Text.count - $Decoded.count)) {
        :inner for ($j=0; $j -lt $Decoded.count; $j++) {
            if ($i+$j -ge $Text.count)           { break }
            if ($Decoded[$j] -eq 255)            { $Decoded.Insert($j, 255); $j+= 2 }
            if ($Text[$i+$j] -ne $Decoded[$j])   { break inner }
            if ($j -eq ($Decoded.count-1)) {
                if ($Encoded[-3] -eq 255 -or $Encoded[-2] -eq 255 -or $Encoded[-1] -eq 255) {
                    $values   = @()
                    $regEx = '^0?[xX]?[0-9a-fA-F]*$'
                    if ($Encoded[-3] -eq 255) {
                        $value = [char[]]($Text[($i+$Decoded.count-5)..($i+$Decoded.count-4)]) -join ''
                        if ($value -match $regEx)   { $Encoded[-3] = (GetDecimal $value) }
                        else                        { WriteToConsole "Text does not contain a valid hex value"; break inner }
                    }
                    if ($Encoded[-2] -eq 255) {
                        $value = [char[]]($Text[($i+$Decoded.count-4)..($i+$Decoded.count-3)]) -join ''
                        if ($value -match $regEx)   { $Encoded[-2] = (GetDecimal $value) }
                        else                        { WriteToConsole "Text does not contain a valid hex value"; break inner }
                    }
                    if ($Encoded[-1] -eq 255) {
                        $value = [char[]]($Text[($i+$Decoded.count-3)..($i+$Decoded.count-2)]) -join ''
                        if ($value -match $regEx)   { $Encoded[-1] = (GetDecimal $value) }
                        else                        { WriteToConsole "Text does not contain a valid hex value"; break inner }
                    }
                }

             <# if ($Encoded[1] -eq 255) {
                    $value = [char[]]($Text[($i+$Decoded.count-3)..($i+$Decoded.count-2)]) -join ''
                    $regEx = '^0?[xX]?[0-9a-fA-F]*$'
                    if ($value -match $regEx)   { $Encoded[-1] = GetDecimal $value }
                    else                        { WriteToConsole "Text does not contain a valid hex value" }
                } #>

                $Text.RemoveRange($i, $Decoded.count)
                $Text.InsertRange($i, $Encoded)
                $i += $Encoded.count - 1
                break inner
            }
        }
    }
    elseif (!$Encode -and $Text.count -ge $Encoded.count -and $i -le ($Text.count - $Encoded.count)) {
        :inner for ($j=0; $j-lt $Encoded.count; $j++) {
            $c = $Text[$i+$j]
         <# if ($Encoded.count -eq 1) {
                foreach ($ignore in $TextEditor.IgnoreDecode2) { if ($c -eq $ignore) {        break inner } }
                foreach ($ignore in $TextEditor.IgnoreDecode3) { if ($c -eq $ignore) { $i++;  break inner } }
                foreach ($ignore in $TextEditor.IgnoreDecode4) { if ($c -eq $ignore) { $i+=2; break inner } }
            }
            elseif ($Encoded.count -eq 2) {
                foreach ($ignore in $TextEditor.IgnoreDecode3) { if ($c -eq $ignore) {       break inner } }
                foreach ($ignore in $TextEditor.IgnoreDecode4) { if ($c -eq $ignore) { $i++; break inner } }
            }
            elseif ($Encoded.count -eq 3) {
                foreach ($ignore in $TextEditor.IgnoreDecode4) { if ($c -eq $ignore) { break inner } }
            } #>

            if ($c -ne $Encoded[$j] -and $Encoded[$j] -ne 255) { break }
            if ($j -eq ($Encoded.count-1)) {
                if ($Decoded[-4] -eq 255 -or $Decoded[-3] -eq 255 -or $Decoded[-2] -eq 255) {
                    $values = @()
                    $remove = 1
                    $enc = [system.Text.Encoding]::UTF8
                    if ($Decoded[-4] -eq 255)   { $values = $values + $Text[$i+$Encoded.count-3]; $remove++ }
                    if ($Decoded[-3] -eq 255)   { $values = $values + $Text[$i+$Encoded.count-2]; $remove++ }
                    if ($Decoded[-2] -eq 255)   { $values = $values + $Text[$i+$Encoded.count-1]; $remove++ }
                    $values  = $enc.GetBytes((CombineHex $values))
                    $values += 62
                    $Decoded.RemoveRange($Decoded.count-$remove, $remove)
                    $Decoded.InsertRange($Decoded.count, $values)
                }

                $Text.RemoveRange($i, $Encoded.count)
                $Text.InsertRange($i, $Decoded)
                $i += $Decoded.count - 1
                break inner
            }
        }
    }

    $global:ScriptCounter = $i
    return $Text

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function RunTextEditor
Export-ModuleMember -Function SaveScript
Export-ModuleMember -Function LoadScript
Export-ModuleMember -Function GetMessage
Export-ModuleMember -Function GetMessageOffset
Export-ModuleMember -Function GetMessagelength
Export-ModuleMember -Function SetMessage
Export-ModuleMember -Function SetMessageBox
Export-ModuleMember -Function SetMessagePosition
Export-ModuleMember -Function SetMessageIcon
Export-ModuleMember -Function SetMessageRupeeCost
Export-ModuleMember -Function SetJumpToMessage