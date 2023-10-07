function CreateTextEditorDialog() {
    
    $Files.json.textEditor   = SetJSONFile ($Paths.Games + "\" + $TextEditor.GameType.mode   + "\Text Editor.json")
    $TextEditor.languageFile = SetJSONFile ($Paths.Games + "\" + $Files.json.textEditor.game + "\Languages\Languages.json")

    # Create Dialog
    $TextEditor.Dialog           = CreateDialog -Width (DPISize 1100) -Height (DPISize 600)
    $TextEditor.Dialog.Icon      = $Files.icon.additional
    $TextEditor.Dialog.BackColor = 'AntiqueWhite'
    $TextEditor.Dialog.Add_FormClosing({ param($sender, $e) $e.Cancel = $True; CloseTextEditor })

    # Left Panel
    $TextEditor.ListPanel                   = CreatePanel -Width (DPISize 520) -Height ($TextEditor.Dialog.Height - (DPISize 75)) -AddTo $TextEditor.Dialog
    $TextEditor.ListPanel.BackColor         = 'AliceBlue'
    $TextEditor.ListPanel.AutoScroll        = $True
    $TextEditor.ListPanel.AutoScrollMargin  = New-Object System.Drawing.Size(0, 0)
    $TextEditor.ListPanel.AutoScrollMinSize = New-Object System.Drawing.Size(0, 0)

    # Status Panel
    $TextEditor.StatusPanel = CreatePanel -X (DPISize 10) -Y ($TextEditor.ListPanel.Bottom + (DPISize 7) ) -Width ($TextEditor.ListPanel.Width   - (DPISize 35) ) -Height (DPISize 25)                            -AddTo $TextEditor.Dialog
    $TextEditor.StatusLabel = CreateLabel -X (DPISize 10) -Y (DPISize 3)                                   -Width ($TextEditor.StatusPanel.Width - (DPISize 5)  ) -Height (DPISize 15) -Text "Awaiting action..." -AddTo $TextEditor.StatusPanel
    $TextEditor.StatusPanel.BackColor = 'White'
    
    # Help Window
    $button = CreateButton -X ($TextEditor.StatusPanel.Right + (DPISize 5)) -Y ($TextEditor.StatusPanel.Top - (DPISize 1)) -Width (DPISize 26) -Height (DPISize 26) -Font $Fonts.Medium -Text "?" -BackColor "White" -AddTo $TextEditor.Dialog
    $button.Add_Click({ OpenHelpDialog })

    # Right Panel
    $TextEditor.ContentPanel = CreatePanel   -X $TextEditor.ListPanel.Right                                  -Width ($TextEditor.Dialog.Width - $TextEditor.ListPanel.Width)       -Height ($TextEditor.Dialog.Height - (DPISize 280) ) -AddTo $TextEditor.Dialog
    $TextEditor.SearchBar    = CreateTextBox -X (DPISize 65)                                 -Y (DPISize 15) -Width ($TextEditor.ContentPanel.width - (DPISize 100) ) -length 50   -Font $Fonts.TextEditor                              -AddTo $TextEditor.ContentPanel
                               CreateLabel   -X ($TextEditor.SearchBar.Left - (DPISize 50) ) -Y $TextEditor.SearchBar.Top -Font $Fonts.SmallBold -Text "Search:" -AddTo $TextEditor.ContentPanel
    $TextEditor.Content      = CreateTextBox -X (DPISize 15) -Y ($TextEditor.SearchBar.Bottom + (DPISize 15)) -Width ($TextEditor.ContentPanel.width - (DPISize 50) ) -length 2000 -Height ($TextEditor.ContentPanel.Height - $TextEditor.SearchBar.Bottom - (DPISize 20) ) -Multiline -Font $Fonts.TextEditor -AddTo $TextEditor.ContentPanel
    $TextEditor.Content.Enabled = $False

    # Close Button
    $X = $TextEditor.ContentPanel.Left + ($TextEditor.ContentPanel.Width / 6)
    $Y = $TextEditor.Dialog.Height - (DPISize 170)
    $CloseButton = CreateButton -X $X -Y $Y -Width (DPISize 80) -Height (DPISize 35) -Text "Close" -AddTo $TextEditor.Dialog
    $CloseButton.Add_Click( { CloseTextEditor })
    $CloseButton.BackColor = "White"

    # Search Button
    $SearchButton = CreateButton -X ($CloseButton.Right + (DPISize 15)) -Y $CloseButton.Top -Width $CloseButton.Width -Height $CloseButton.Height -Text "Search" -AddTo $TextEditor.Dialog
    $SearchButton.BackColor = "White"

    # Extract Button
    $ExtractButton = CreateButton -X ($SearchButton.Right + (DPISize 15)) -Y $SearchButton.Top -Width $SearchButton.Width -Height $SearchButton.Height -Text "Extract Script" -AddTo $TextEditor.Dialog
    $ExtractButton.BackColor = "White"

    # Reset Button
    $ResetButton = CreateButton -X ($ExtractButton.Right + (DPISize 15)) -Y $ExtractButton.Top -Width $ExtractButton.Width -Height $ExtractButton.Height -Text "Reset Box" -AddTo $TextEditor.Dialog
    $ResetButton.BackColor = "White"

    # Options Label
    $TextEditor.Label = CreateLabel -Y (DPISize 15) -Width $TextEditor.Dialog.width -Height (DPISize 15) -Font $Fonts.SmallBold -Text ($Files.json.textEditor.game + " - Text Editor") -AddTo $TextEditor.Dialog
    $TextEditor.Label.AutoSize = $True
    $TextEditor.Label.Left = ([Math]::Floor($TextEditor.Dialog.Width / 2) - [Math]::Floor($TextEditor.Label.Width / 2))

    # Languages
    $TextEditor.languages     = @()
    $columns                  = 5
    $TextEditor.LanguagePanel = CreatePanel -X ($TextEditor.ContentPanel.Left + (DPISize 15)) -Y ($TextEditor.Dialog.Height - (DPISize 120)) -Width ($TextEditor.Dialog.Width - $TextEditor.ListPanel.Width) -Height (DPISize 100) -AddTo $TextEditor.Dialog
    $max = $TextEditor.languageFile.count + $Files.json.textEditor.hacks.count

    $row = $column = 0
    for ($i=0; $i -lt $TextEditor.languageFile.count; $i++) {
        if ($i % $Columns -ne 0) { $column++ }
        else {
            $column = 0
            $row++
        }
        $name = ("Editor.Language." + $Files.json.textEditor.parse)
        $TextEditor.languages += CreateCheckBox -IsRadio -X ($column * (DPISize 100))       -Y (($row-1) * (DPISize 30)) -Checked ($TextEditor.languageFile[$i].default -eq 1) -AddTo $TextEditor.LanguagePanel -Name $name -Max $max -SaveAs ($i+1) -SaveTo $name
        CreateLabel                                      -X $TextEditor.Languages[$i].Right -Y $TextEditor.Languages[$i].Top -Text $TextEditor.languageFile[$i].title          -AddTo $TextEditor.LanguagePanel
        $TextEditor.languages[$i].Add_CheckedChanged({
            if ($this.checked) {
                if ($LastScript -ne $null) {
                    SaveLastMessage
                    SaveScript -Script ($Paths.Games + "\" + $TextEditor.GameType.mode + "\Editor\message_data_static." + $LanguagePatch.code + ".bin") -Table ($Paths.Games + "\" + $TextEditor.GameType.mode + "\Editor\message_data." + $LanguagePatch.code + ".tbl")
                }
                $global:LanguagePatch = $TextEditor.languageFile[($this.SaveAs-1)]
                LoadMessages
            }
        })
        if ($TextEditor.languages[$i].checked) {
            $global:LanguagePatch = $TextEditor.languageFile[$i]
            LoadMessages
        }
    }

    for ($i=0; $i -lt $Files.json.textEditor.hacks.count; $i++) {
        if ($i % $Columns -ne 0) { $column++ }
        else {
            $column = 0
            $row++
        }
        $index = $i + $TextEditor.languageFile.count
        $name  = ("Editor.Language." + $Files.json.textEditor.parse)
        $TextEditor.languages += CreateCheckBox -IsRadio -X ($column * (DPISize 100))            -Y (($row-1) * (DPISize 30))                                                     -AddTo $TextEditor.LanguagePanel -Name $name -Max $max -SaveAs ($index + 1) -SaveTo $name
        CreateLabel                                      -X $TextEditor.Languages[$index].Right -Y $TextEditor.Languages[$index].Top -Text $Files.json.textEditor.hacks[$i].title -AddTo $TextEditor.LanguagePanel
        $TextEditor.languages[$index].Add_CheckedChanged({
            if ($this.checked) {
                if ($LastScript -ne $null) {
                    SaveLastMessage
                    SaveScript -Script ($Paths.Games + "\" + $TextEditor.GameType.mode + "\Editor\message_data_static." + $LanguagePatch.code + ".bin") -Table ($Paths.Games + "\" + $TextEditor.GameType.mode + "\Editor\message_data." + $LanguagePatch.code + ".tbl")
                }
                $global:LanguagePatch = $Files.json.textEditor.hacks[($this.SaveAs-1-$TextEditor.languageFile.count)]
                LoadMessages
            }
        })
        if ($TextEditor.languages[$index].checked) {
            $global:LanguagePatch = $Files.json.textEditor.hacks[$i]
            LoadMessages
        }
    }

    # Bottom Panel
    $TextEditor.TextBoxPanel = CreatePanel -X $TextEditor.ContentPanel.Left -Y $TextEditor.ContentPanel.Bottom -Width $TextEditor.ContentPanel.Width -Height ($TextEditor.Dialog.Height - $TextEditor.ContentPanel.Height) -AddTo $TextEditor.Dialog
    
    $items = @()
    $Files.json.textEditor.textboxes | foreach { $items += $_.name }
    $TextEditor.TextBoxType     = CreateComboBox        -X (DPISize 15)                                      -Y (DPISize 35)                                     -Width (DPISize 160) -Height (DPISize 20) -Items $items -Text "Type"     -AddTo $TextEditor.TextBoxPanel
    CreateLabel     -X $TextEditor.TextBoxType.Left     -Y ($TextEditor.TextBoxType.Top - (DPISize 20) )     -Font $Fonts.SmallBold -Text "Textbox Type"         -AddTo $TextEditor.TextBoxPanel

    $items = @("Dynamic", "Top", "Middle", "Bottom")
    $TextEditor.TextBoxPosition = CreateComboBox        -X ($TextEditor.TextBoxType.Right   + (DPISize 15) ) -Y $TextEditor.TextBoxType.Top                      -Width (DPISize 160) -Height (DPISize 20) -Items $items -Text "Position" -AddTo $TextEditor.TextBoxPanel
    CreateLabel     -X $TextEditor.TextBoxPosition.Left -Y ($TextEditor.TextBoxPosition.Top - (DPISize 20) ) -Font $Fonts.SmallBold -Text "Textbox Position"     -AddTo $TextEditor.TextBoxPanel

    if ($Files.json.textEditor.header -gt 0) {
        $items = @()
        $Files.json.textEditor.icons | foreach { $items += $_.name }
        $items = $items | select -Unique
        $TextEditor.TextBoxIcon   = CreateComboBox      -X $TextEditor.TextBoxType.Left                      -Y ($TextEditor.TextBoxType.Bottom + (DPISize 30) ) -Width (DPISize 160) -Height (DPISize 20) -Items $items -Text "Icon"     -AddTo $TextEditor.TextBoxPanel
        CreateLabel -X $TextEditor.TextBoxIcon.Left     -Y ($TextEditor.TextBoxIcon.Top - (DPISize 20) )     -Font $Fonts.SmallBold -Text "Textbox Icon"         -AddTo $TextEditor.TextBoxPanel
    
        $TextEditor.TextBoxRupees = CreateTextBox       -X ($TextEditor.TextBoxIcon.Right + (DPISize 15) )   -Y $TextEditor.TextBoxIcon.Top                      -Width (DPISize 60)  -Height (DPISize 15) -Length 4     -Text "0"        -AddTo $TextEditor.TextBoxPanel
        CreateLabel -X $TextEditor.TextBoxRupees.Left   -Y ($TextEditor.TextBoxRupees.Top - (DPISize 20) )   -Font $Fonts.SmallBold -Text "Textbox Rupee Cost"   -AddTo $TextEditor.TextBoxPanel

        $TextEditor.TextBoxJump   = CreateTextBox       -X ($TextEditor.TextBoxRupees.Right + (DPISize 65) ) -Y $TextEditor.TextBoxIcon.Top                      -Width (DPISize 60)  -Height (DPISize 15) -Length 4     -Text "0000"     -AddTo $TextEditor.TextBoxPanel
        CreateLabel -X $TextEditor.TextBoxJump.Left     -Y ($TextEditor.TextBoxJump.Top     - (DPISize 20) ) -Font $Fonts.SmallBold -Text "Jump to Message"      -AddTo $TextEditor.TextBoxPanel

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
    $TextEditor.Content.Add_TextChanged( {
        if ( $TextEditor.Edited[0]) { $TextEditor.Edited[1] = $True }
        if (!$TextEditor.Edited[6] -and $TextEditor.LastButton -ne $null) { $TextEditor.LastButton.Edited = $True }
    } )
    $TextEditor.TextBoxType.Add_SelectedIndexChanged(     { if ($TextEditor.Edited[0])   { $TextEditor.Edited[2] = $True } })
    $TextEditor.TextBoxPosition.Add_SelectedIndexChanged( { if ($TextEditor.Edited[0])   { $TextEditor.Edited[2] = $True } })
    $TextEditor.TextBoxType.enabled = $TextEditor.TextBoxPosition.enabled = $False

    $SearchButton.Add_Click({
        $TextEditor.Search = $True
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
            $search = ParseMessage $TextEditor.SearchBar.text.toCharArray() -Encode
            foreach ($btn in $TextEditor.ListPanel.Controls) {
                $matches = $False
                $index   = 0

                $msg = $DialogueList[$btn.text].msg
                for ($i=$msg.count-1; $i -ge $msg.count-4; $i--) {
                    if ($msg[$i] -eq [byte]$Files.json.textEditor.end) {
                        $msg = $msg[0..($i-1)]
                        break
                    }
                }

                foreach ($c in $msg) {
                    if ([byte]$c -eq [byte]$search[$index])   { $index++   }
                    elseif ($index -gt 0)                     { $index = 0 }
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
        $TextEditor.Search = $Null
    })

    $ExtractButton.Add_Click({
        RefreshScripts
        if ($Settings.Debug.ClearLog -eq $True) { Clear-Host }
        SetTextEditorTypes

        if ($GamePath -eq $null) {
            PlaySound $Sounds.done
            UpdateStatusLabel -Text "Failed! No ROM path is given." -Editor -Error
            ResetTextEditorTypes; return
        }

        # Language Patch
        $global:LanguagePatchFile = $null
        if (TestFile (CheckPatchExtension ($Paths.Games + "\" + $Files.json.textEditor.game + "\Languages\" + $LanguagePatch.code) ) ) {
            $global:LanguagePatchFile = "Languages\" + $LanguagePatch.code + (Get-Item (CheckPatchExtension ($Paths.Games + "\" + $Files.json.textEditor.game + "\Languages\" + $LanguagePatch.code) ) ).Extension
        }
        elseif (TestFile (CheckPatchExtension ($Paths.Games + "\" + $Files.json.textEditor.game + "\" + $LanguagePatch.patch) ) ) {
            $global:LanguagePatchFile = $LanguagePatch.patch + (Get-Item (CheckPatchExtension ($Paths.Games + "\" + $Files.json.textEditor.game + "\" + $LanguagePatch.patch) ) ).Extension
        }

        $global:PatchInfo     = @{}
        $PatchInfo.decompress = $True
        $global:CheckHashSum  = $Files.json.textEditor.hash
        $global:ROMFile       = SetROMParameters -Path $GamePath
        SetGetROM

        if ($IsWiiVC) {
            if (!(ExtractWADFile))    { ResetTextEditorTypes; return }   # Step A: Extract the contents of the WAD file
            if (!(CheckVCGameID))     { ResetTextEditorTypes; return }   # Step B: Check the GameID to be vanilla
            if (!(ExtractU8AppFile))  { ResetTextEditorTypes; return }   # Step C: Extract "00000005.app" file to get the ROM
            if (!(PatchVCROM))        { ResetTextEditorTypes; return }   # Step D: Do some initial patching stuff for the ROM for VC WAD files
        }

        if (!(Unpack)) {
            PlaySound $Sounds.done
            UpdateStatusLabel "Failed! Could not extract ROM." -Editor -Error
            ResetTextEditorTypes; return
        }
        if (TestFile $GetROM.run)                                                   { $global:ROMHashSum   = (Get-FileHash -Algorithm MD5 -LiteralPath $GetROM.run).Hash }
        if ($Settings.Debug.IgnoreChecksum -eq $False -and (IsSet $CheckHashsum))   { $PatchInfo.downgrade = ($ROMHashSum -ne $CheckHashSum)                             }
        if ((Get-Item -LiteralPath $GetROM.run).length/"32MB" -ne 1) {
            PlaySound $Sounds.done
            UpdateStatusLabel "Failed! The ROM should be 32 MB!" -Editor -Error
            ResetTextEditorTypes; return
        }

        ConvertROM $Command
        if (!(CompareHashSums $Command)) {
            PlaySound $Sounds.done
            UpdateStatusLabel "Failed! The ROM is an incorrect version or is broken." -Editor -Error
            ResetTextEditorTypes; return
        }

        if (!(DecompressROM)) {
            PlaySound $Sounds.done
            UpdateStatusLabel "Failed! The ROM could not be decompressed." -Editor -Error
            ResetTextEditorTypes; return
        }
        $item = DowngradeROM

        # Extract vanilla script
        if ( !(TestFile ($Paths.Games + "\" + $TextEditor.GameType.mode + "\Editor\message_data_static.ori.bin")) -or !(TestFile ($Paths.Games + "\" + $TextEditor.GameType.mode + "\Editor\message_data.ori.tbl")) ) {
            $global:ByteArrayGame = [System.IO.File]::ReadAllBytes($GetROM.decomp)
            CreateSubPath $GameFiles.editor
            $start  = CombineHex $ByteArrayGame[((GetDecimal $TextEditor.languageFile[0].script_dma)+0)..((GetDecimal $TextEditor.languageFile[0].script_dma)+3)]
            $end    = CombineHex $ByteArrayGame[((GetDecimal $TextEditor.languageFile[0].script_dma)+4)..((GetDecimal $TextEditor.languageFile[0].script_dma)+7)]
            $length = Get32Bit ( (GetDecimal $end) - (GetDecimal $start) )
            ExportBytes -Offset $start                                  -Length $length                     -Output ($Paths.Games + "\" + $Files.json.textEditor.game + "\Editor\message_data_static.ori.bin") -Force
            ExportBytes -Offset $TextEditor.languageFile[0].table_start -Length $LanguagePatch.table_length -Output ($Paths.Games + "\" + $Files.json.textEditor.game + "\Editor\message_data.ori.tbl")        -Force
        }

        if ($LanguagePatchFile -ne $null) {
            UpdateStatusLabel ("Patching " + $Files.json.textEditor.game + " Language...") -Editor
            ApplyPatch -File $GetROM.decomp -Patch ("Games\" + $Files.json.textEditor.game + "\" + $LanguagePatchFile) -FilesPath
        }

        # Extract script
        if ($LanguagePatch.script_dma -ne $null -and $LanguagePatch.table_start -ne $null -and $LanguagePatch.table_length -ne $null) {
            $global:ByteArrayGame = [System.IO.File]::ReadAllBytes($GetROM.decomp)
            CreateSubPath $GameFiles.editor
            $start  = CombineHex $ByteArrayGame[((GetDecimal $LanguagePatch.script_dma)+0)..((GetDecimal $LanguagePatch.script_dma)+3)]
            $end    = CombineHex $ByteArrayGame[((GetDecimal $LanguagePatch.script_dma)+4)..((GetDecimal $LanguagePatch.script_dma)+7)]
            $length = Get32Bit ( (GetDecimal $end) - (GetDecimal $start) )
            ExportBytes -Offset $start                     -Length $length                     -Output ($Paths.Games + "\" + $Files.json.textEditor.game + "\Editor\message_data_static." + $LanguagePatch.code + ".bin") -Force
            ExportBytes -Offset $LanguagePatch.table_start -Length $LanguagePatch.table_length -Output ($Paths.Games + "\" + $Files.json.textEditor.game + "\Editor\message_data."        + $LanguagePatch.code + ".tbl") -Force
        }

        Cleanup -SkipLanguageReset
        LoadMessages
        ResetTextEditorTypes
        PlaySound $Sounds.done
        UpdateStatusLabel -Text "Success! Script has been extracted." -Editor
    })

    $ResetButton.Add_Click({
        if (!$TextEditor.Content.Enabled) { return }
        $TextEditor.Edited[6]            = $True
        $TextEditor.Content.Text         = GetMessage -ID $TextEditor.LastButton.Text -Reset
        $TextEditor.Edited[6]            = $False
        $TextEditor.LastButton.Edited    = $False
        $TextEditor.LastButton.BackColor = "DarkGray"
    })
    
}



#==============================================================================================================================================================================================
function RunTextEditor([object]$Game=$null) {
    
    $global:TextEditor      = @{}
    $TextEditor.GameConsole = $Files.json.consoles[0]
    $TextEditor.GameType    = $Game
    CreateTextEditorDialog
    $TextEditor.Dialog.Show()

}



#==============================================================================================================================================================================================
function CloseTextEditor() {
    
    if ($TextEditor.Dialog -eq $null) { return }
    $TextEditor.Dialog.Hide()

    if ($LastScript -ne $null) {
        SaveLastMessage
        SaveScript -Script ($Paths.Games + "\" + $TextEditor.GameType.mode + "\Editor\message_data_static." + $LanguagePatch.code + ".bin") -Table ($Paths.Games + "\" + $TextEditor.GameType.mode + "\Editor\message_data." + $LanguagePatch.code + ".tbl")
    }
    
    $global:LastScript = $global:DialogueList = $global:ByteScriptArray = $global:ByteTableArray = $Files.json.textEditor = $global:TextEditor = $global:LanguagePatch = $null

}



#==============================================================================================================================================================================================
function SetTextEditorTypes() {
    
    $TextEditor.LastGameType    = $global:GameType
    $TextEditor.LastGameConsole = $global:GameConsole
    $global:GameType            = $TextEditor.GameType
    $global:GameConsole         = $TextEditor.GameConsole

}



#==============================================================================================================================================================================================
function ResetTextEditorTypes() {

    $global:GameType         = $TextEditor.LastGameType
    $global:GameConsole      = $TextEditor.LastGameConsole
    $TextEditor.LastGameType = $TextEditor.LastGameConsole = $null

}



#==============================================================================================================================================================================================
function OpenHelpDialog() {
    
    # Create Dialog
    $Dialog           = CreateDialog -Width (DPISize 750) -Height (DPISize 600)
    $Dialog.Icon      = $Files.icon.additional
    $Dialog.BackColor = 'AntiqueWhite'
    
    # Close Button
    $CloseButton           = CreateButton -X ($Dialog.Left + ($Dialog.Width / 3)) -Y ($Dialog.Height - (DPISize 90)) -Width (DPISize 90) -Height (DPISize 35) -Text "Close" -AddTo $Dialog
    $CloseButton.BackColor = "White"
    $CloseButton.Add_Click({ $Dialog.Hide() })

    # Text Box
    $textbox = CreateTextBox -X (DPISize 40) -Y (DPISize 30) -Width ($Dialog.Width - (DPISize 100)) -Height ($CloseButton.Top - (DPISize 40)) -ReadOnly -Multiline -TextFileFont -AddTo $Dialog
    AddTextFileToTextbox -TextBox $textbox -File ($Paths.Games + "\" + $TextEditor.GameType.mode + "\Guide Text Editor.txt")

    # Show Dialog
    $Dialog.ShowDialog()

}



#==============================================================================================================================================================================================
function LoadMessages() {
    
    $TextEditor.ListPanel.Controls.Clear()
    if ( (TestFile ($Paths.Games + "\" + $Files.json.textEditor.game + "\Editor\message_data_static." + $LanguagePatch.code + ".bin") ) -and (TestFile ($Paths.Games + "\" + $Files.json.textEditor.game + "\Editor\message_data." + $LanguagePatch.code + ".tbl") ) ) {
        LoadScript -Script ($Paths.Games + "\" + $Files.json.textEditor.game + "\Editor\message_data_static." + $LanguagePatch.code + ".bin") -Table ($Paths.Games + "\" + $Files.json.textEditor.game + "\Editor\message_data." + $LanguagePatch.code + ".tbl")
        $global:LastScript            = @{}
        $LastScript.entry             = "0000"
        [boolean[]]$TextEditor.Edited = @($False, $False, $False, $False, $False, $False, $False)
    }
    else { $global:LastScript = $null }
}



#==============================================================================================================================================================================================
function LoadScript([string]$Script, [string]$Table) {
    
    $global:DialogueList = @{}
    $vanillaList         = @{}
    $column              = $row = 0

    if ($TextEditor -ne $null -and $LanguagePatch.patch -ne $null -and (TestFile ($Paths.Games + "\" + $Files.json.textEditor + "\Editor\message_data_static.ori.bin")) -and (TestFile ($Paths.Games + "\" + $Files.json.textEditor + "\Editor\message_data.ori.tbl")) ) {
        $global:ByteScriptArray = [System.IO.File]::ReadAllBytes(($Paths.Games + "\" + $Files.json.textEditor.game + "\Editor\message_data_static.ori.bin"))
        $global:ByteTableArray  = [System.IO.File]::ReadAllBytes(($Paths.Games + "\" + $Files.json.textEditor.game + "\Editor\message_data.ori.tbl"))
        for ($i=0; $i -lt $ByteTableArray.count; $i+=8) {
            $item = (Get8Bit $ByteTableArray[$i]) + (Get8Bit $ByteTableArray[$i+1])
            [uint32]$start = $ByteTableArray[$i+5]   * 65536 + $ByteTableArray[$i+6]   * 256 + $ByteTableArray[$i+7]
            [uint32]$end   = $ByteTableArray[$i+5+8] * 65536 + $ByteTableArray[$i+6+8] * 256 + $ByteTableArray[$i+7+8]
            $VanillaList[$item]               = @{}
            [uint32]$vanillaList[$item].start = $start
            [uint32]$vanillaList[$item].end   = $end
            if ($vanillaList[$item].end - $vanillaList[$item].start -gt 0) { $vanillaList[$item].msg = $ByteScriptArray[$vanillaList[$item].start..($vanillaList[$item].end-1)] }
        }
    }

    [System.Collections.ArrayList]$global:ByteScriptArray = [System.IO.File]::ReadAllBytes($Script)
    $global:ByteTableArray                                = [System.IO.File]::ReadAllBytes($Table)

    for ($i=0; $i -lt $ByteTableArray.count; $i+=8) {
        $item = (Get8Bit $ByteTableArray[$i]) + (Get8Bit $ByteTableArray[$i+1])
        if ($item -eq "FFFF") { break }

        [uint32]$start = $ByteTableArray[$i+5]   * 65536 + $ByteTableArray[$i+6]   * 256 + $ByteTableArray[$i+7]
        [uint32]$end   = $ByteTableArray[$i+5+8] * 65536 + $ByteTableArray[$i+6+8] * 256 + $ByteTableArray[$i+7+8]

        if ($lastItem -ne $null) {
            if ($start -eq $DialogueList[$lastItem].start)   { $item; continue }
            if ($start -lt $DialogueList[$lastItem].start)   { $item; break    }
        }
        if ($start -ge $ByteScriptArray.count)               { $item; break    }

        if ($end -eq $start) {
            for ($j=$i+8; $j -lt $ByteTableArray.count; $j+=8) {
                [uint32]$end = $ByteTableArray[$j+5] * 65536 + $ByteTableArray[$j+6] * 256 + $ByteTableArray[$j+7]
                if ($end -ne $start) { break }
            }
            if ($end -eq $start) {
                $end = $ByteScriptArray.count
                for ($j=$ByteScriptArray.count; $j -gt $start + $Files.json.textEditor.header; $j--) {
                    if ($ByteScriptArray[$j] -eq [byte]$Files.json.textEditor.end) {
                        $end = $j + 1
                        break
                    }
                }
            }
        }
        if ($end -lt $start) {
            $end = $ByteScriptArray.count
            for ($j=$ByteScriptArray.count; $j -gt $start + $Files.json.textEditor.header; $j--) {
            if ($ByteScriptArray[$j] -eq [byte]$Files.json.textEditor.end) {
                $end = $j + 1
                 break
                }
            }
        }

        $DialogueList[$item]                                   = @{}
        [uint32]$DialogueList[$item].start                     = $start
        [uint32]$DialogueList[$item].end                       = $end
        [System.Collections.ArrayList]$DialogueList[$item].msg = $ByteScriptArray[$DialogueList[$item].start..($DialogueList[$item].end-1)]
        $DialogueList[$item].reset                             = $DialogueList[$item].msg.Clone()

        if ($Files.json.textEditor.header -gt 0) {
            if ($DialogueList[$item].msg.count -lt [byte]$Files.json.textEditor.header) {
                $DialogueList[$item] = $null
                break
            }
            [byte]$DialogueList[$item].type   = $DialogueList[$item].msg[0]
            [byte]$DialogueList[$item].pos    = $DialogueList[$item].msg[1] -shr 4
            [string]$DialogueList[$item].icon = Get8Bit $DialogueList[$item].msg[2]
            [uint16]$DialogueList[$item].cost = GetDecimal (CombineHex $DialogueList[$item].msg[5..6])
            [string]$DialogueList[$item].jump = CombineHex $DialogueList[$item].msg[3..4]
        }
        else {
            [byte]$DialogueList[$item].type =  $ByteTableArray[$i + 2] -shr 4       # Upper
            [byte]$DialogueList[$item].pos  = ($ByteTableArray[$i + 2] -shl 4) / 16 # Lower
        }

        if ($TextEditor) {
            if ($column -eq 10) {
                $row++
                $column = 0
            }
            $color = "Gray"

            if ($vanillaList.count -gt 0) {
                if     ($vanillaList[$item] -eq $null) { $color = "DarkGreen" }
                else {
                    if ($vanillaList[$item].msg.count -ne $DialogueList[$item].msg.count) { $color = "DarkGreen" }
                    else {
                        $compare = $vanillaList[$item].msg | Where { $DialogueList[$item].msg -Contains $_ }
                        if ($compare.count -ne $vanillaList[$item].msg.count) { $color = "DarkGreen" }
                    }
                }
            }

            AddMessageIDButton -ID $item -Column $column -Row $row -Color $color
            $column++;
        }
        $lastItem = $item
    }

}



#==============================================================================================================================================================================================
function SaveScript([string]$Script, [string]$Table) {
    
    if ($DialogueList -eq $null) {
        WriteToConsole ("Could not save text messages. Did it ran outside ByteLanguageOptions?" ) -Error
        return
    }

    [System.Collections.ArrayList]$tempList = @()
    [int32]$increase = 0

    for ($i=0; $i -lt $ByteTableArray.count; $i+=8) {
        if (@(Compare-Object $ByteTableArray[$i..($i+7)] @(255, 255, 0, 0, 0, 0, 0, 0) -SyncWindow 0).Length -eq 0) { break }
        $item = (Get8Bit $ByteTableArray[$i]) + (Get8Bit $ByteTableArray[$i+1])
        $curr = $ByteTableArray[$i+5]   * 65536 + $ByteTableArray[$i+6]   * 256 + $ByteTableArray[$i+7]
        $next = $ByteTableArray[$i+8+5] * 65536 + $ByteTableArray[$i+8+6] * 256 + $ByteTableArray[$i+8+7]

        if ($DialogueList[$item] -ne $null) {
            foreach ($c in $DialogueList[$item].msg) {
                $tempList.insert($tempList.count, $c)
            }

            if ($Files.json.textEditor.header -eq 0) { $ByteTableArray[$i+2] = $DialogueList[$item].type * 16 + $DialogueList[$item].pos }
            $offset    = (Get24Bit ($DialogueList[$item].start + $DialogueList[$item].msg.count + $increase) ) -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) }
            $increase += $DialogueList[$item].start - $DialogueList[$item].end + $DialogueList[$item].msg.count

            if ($next -ge $ByteScriptArray.count) { break }
            if ($next -ne 0) {
                for ($j=0; $j -lt $offset.length; $j++) { $ByteTableArray[$i + 8 + 5 + $j] = $offset[$j] }
            }
        }
        else {
            if ($next -gt $curr) {
                $nextItem = (Get8Bit $ByteTableArray[$i+8]) + (Get8Bit $ByteTableArray[$i+1+8])
                $offset = (Get24Bit ($DialogueList[$nextItem].start + $DialogueList[$item].msg.count + $increase) ) -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) }
                for ($j=0; $j -lt $offset.length; $j++) { $ByteTableArray[$i + 8 + 5 + $j] = $offset[$j] }
            }
            elseif ($curr -ne 0) {
                for ($j=0; $j -lt 3; $j++) { $ByteTableArray[$i + 5 + $j] = $ByteTableArray[$i - 8 + 5 + $j] }
            }
        }
    }
    while ($tempList.count % 16 -ne 0) { $tempList.Insert($tempList.count, 0) }

    [System.IO.File]::WriteAllBytes($Script, $tempList)
    [System.IO.File]::WriteAllBytes($Table,  $ByteTableArray)
    $increase = $tempList = $null

}



#==============================================================================================================================================================================================
function SaveLastMessage() {
    
    if ($LastScript.entry -ne $null) {
        if ($TextEditor.Edited[1])       { SetMessage -Replace $TextEditor.Content.Text -ID $LastScript.entry -Safety -ASCII -Force }
        if ($TextEditor.Edited[2])       { SetMessageBox -ID $LastScript.entry -Type $TextEditor.TextBoxType.selectedIndex -Position $TextEditor.TextBoxPosition.selectedIndex }
        if ($Files.json.textEditor.header -gt 0) {
            if ($TextEditor.Edited[3])   { SetMessageIcon   -ID $LastScript.entry -Value $TextEditor.TextBoxIcon.text             }
            if ($TextEditor.Edited[4])   { SetMessageRupees -ID $LastScript.entry -Value ([uint16]$TextEditor.TextBoxRupees.text) }
            if ($TextEditor.Edited[5])   { SetJumpToMessage -ID $LastScript.entry -Value $TextEditor.TextBoxJump.text             }
        }
        for ($i=0; $i -lt $TextEditor.Edited.count; $i++) { $TextEditor.edited[$i] = $False }
    }

}



#==============================================================================================================================================================================================
function GetMessage([string]$ID, [switch]$Reset) {
    
    if ($Files.json.textEditor -eq $null) { LoadTextEditor }

    if ($DialogueList -eq $null) {
        WriteToConsole ("Could not get message ID: " + $ID + " as the message data does not exist. Did it ran outside ByteLanguageOptions?" ) -Error
        return
    }

    if ($Reset) { $msg = $DialogueList[$ID].reset }
    else { $msg = $DialogueList[$ID].msg }

    if ($TextEditor) {
        $LastScript.entry = $ID
        
        if ($Files.json.textEditor.header -gt 0) {
            if ($DialogueList[$ID].cost -eq 65535) { $TextEditor.LastBoxRupees = 0 } else { $TextEditor.TextBoxRupees = $DialogueList[$ID].cost }
            foreach ($icon in $Files.json.textEditor.icons) {
                if ($icon.id -eq $DialogueList[$ID].icon) {
                    $TextEditor.TextBoxIcon.text = $icon.name
                    break
                }
            }
            $TextEditor.TextBoxJump.text = $DialogueList[$ID].jump
        }

        foreach ($box in $Files.json.textEditor.textboxes) {
            if ($box.id -eq $DialogueList[$ID].type) {
                $TextEditor.TextBoxType.text = $box.name
                break
            }
        }
        if ($DialogueList[$ID].pos -ge 3)   { $TextEditor.TextBoxPosition.selectedIndex = 3                      }
        else                                { $TextEditor.TextBoxPosition.selectedIndex = $DialogueList[$ID].pos }
    }
    
    $end = $msg.count - 1
    for ($i=$end; $i -ge $end-3; $i--) {
        if ($msg[$i] -eq [byte]$Files.json.textEditor.end) {
            $end = $i - 1
            break
        }
    }

    if ($end - $Files.json.texteditor.header -le 0) { return "" }

    return (ParseMessage -Text $msg[$Files.json.textEditor.header..$end]) -join ''
}



#==============================================================================================================================================================================================
function AddMessageIDButton([string]$ID, [byte]$Column, [uint16]$Row, [string]$Color="Gray") {
    
    $button           = New-Object System.Windows.Forms.Button
    $button.Text      = $ID
    $button.Font      = $Fonts.Small
    $button.Size      = New-Object System.Drawing.Size((DPISize 50), (DPISize 25))
    $button.Location  = New-Object System.Drawing.Size(($column * (DPISize 50) + ((DPISize 3))), ($row * (DPISize 25)))
    $button.ForeColor = "White"
    $button.BackColor = $Color
    Add-Member -InputObject $button -NotePropertyMembers @{ Color = $Color; Edited = $False }
    $button.Add_Click( {
        SaveLastMessage
        $TextEditor.Edited[6]    = $True
        $TextEditor.Content.Text = GetMessage -ID $this.Text
        $TextEditor.Edited[6]    = $False
        if ($TextEditor.LastButton -ne $null) {
            if ($TextEditor.LastButton.Edited)   { $TextEditor.LastButton.BackColor = "Red" }
            else                                 { $TextEditor.LastButton.BackColor = $TextEditor.LastButton.Color }
        }
        $TextEditor.LastButton          = $this
        $this.BackColor                 = "DarkGray"
        $TextEditor.TextBoxType.enabled = $TextEditor.TextBoxPosition.enabled = $True
        if ($Files.json.textEditor.header -gt 0) {
            if ($TextEditor.TextBoxIcon   -ne $null) { $TextEditor.TextBoxIcon.enabled   = $True }
            if ($TextEditor.TextBoxRupees -ne $null) { $TextEditor.TextBoxRupees.enabled = $True }
            if ($TextEditor.TextBoxJump   -ne $null) { $TextEditor.TextBoxJump.enabled   = $True }
        }
        $TextEditor.Edited[0] = $TextEditor.Content.Enabled = $True
    } )
    $TextEditor.ListPanel.Controls.Add($button)

}



#==============================================================================================================================================================================================
function GetMessageOffset([string]$ID) {
    
    if ($Files.json.textEditor -eq $null) { LoadTextEditor }

    if ($DialogueList -eq $null) {
        WriteToConsole ("Could not get message ID: " + $ID + " offset as the message data does not exist. Did it ran outside ByteLanguageOptions?" ) -Error
        return
    }

    if ($DialogueList[$ID] -ne $null) { return $DialogueList[$ID].start }
    return -1

}



#==============================================================================================================================================================================================
function GetMessageLength([string]$ID) {
    
    if ($Files.json.textEditor -eq $null) { LoadTextEditor }

    if ($DialogueList -eq $null) {
        WriteToConsole ("Could not get message ID: " + $ID + " length as the message data does not exist. Did it ran outside ByteLanguageOptions?" ) -Error
        return
    }

    if ($DialogueList[$ID] -ne $null) { return $DialogueList[$ID].end - $DialogueList[$ID].start }
    return -1

}

#==============================================================================================================================================================================================
function SetMessageBox([string]$ID, [byte]$Type, [byte]$Position) {
    
    if ($Files.json.textEditor -eq $null) { LoadTextEditor }

    if ($DialogueList -eq $null) {
        WriteToConsole ("Could not edit message ID: " + $ID + " as the message data does not exist. Did it ran outside ByteLanguageOptions?" ) -Error
        return
    }

    if ($Position -gt 3) { $Position = 3 }
    if ($Files.json.textEditor.header -gt 0) {
        $DialogueList[$ID].msg[0] = $Type
        $DialogueList[$ID].msg[1] = $Position * 16
    }
    $DialogueList[$ID].type = $Type
    $DialogueList[$ID].pos  = $Position


}

#==============================================================================================================================================================================================
function SetMessageIcon([string]$ID, [string]$Hex, [string]$Value) {
    
    if ($Files.json.textEditor -eq $null) { LoadTextEditor }

    if ($DialogueList -eq $null) {
        WriteToConsole ("Could not edit message ID: " + $ID + " as the message data does not exist. Did it ran outside ByteLanguageOptions?" ) -Error
        return
    }

    if (IsSet $Hex) {
        $DialogueList[$ID].icon = $DialogueList[$ID].msg[2] = GetDecimal $Hex
        return
    }

    foreach ($icon in $Files.json.textEditor.icons) {
        if ($icon.name -eq $TextEditor.TextBoxIcon.text) {
            $DialogueList[$ID].icon = $DialogueList[$ID].msg[2] = GetDecimal $icon.id
            break
        }
    }

}

#==============================================================================================================================================================================================
function SetMessageRupees([string]$ID, [uint16]$Value) {
    
    if ($Files.json.textEditor -eq $null) { LoadTextEditor }

    if ($DialogueList -eq $null) {
        WriteToConsole ("Could not edit message ID: " + $ID + " as the message data does not exist. Did it ran outside ByteLanguageOptions?" ) -Error
        return
    }

    if ($Value -eq 0) { $Value = 65535 }
    $value = (Get16Bit $Value)
    [byte[]]$split = $Value -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) }

    $DialogueList[$ID].msg[5] = $split[0]
    $DialogueList[$ID].msg[6] = $split[1]
    $DialogueList[$ID].cost   = $Value

}

#==============================================================================================================================================================================================
function SetJumpToMessage([string]$ID, [string]$Value) {
    
    if ($Files.json.textEditor -eq $null) { LoadTextEditor }

    if ($DialogueList -eq $null) {
        WriteToConsole ("Could not edit message ID: " + $ID + " as the message data does not exist. Did it ran outside ByteLanguageOptions?" ) -Error
        return
    }

    [byte[]]$split = $Value -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) }
    $DialogueList[$ID].msg[3] = $split[0]
    $DialogueList[$ID].msg[4] = $split[1]
    $DialogueList[$ID].jump   = $Value

}

#==============================================================================================================================================================================================
function FindMatch([byte[]]$Text, [boolean]$All) {
    
    if ($DialogueList -eq $null) {
        WriteToConsole ("Could not find match in message ID: " + $ID + " as the message data does not exist. Did it ran outside ByteLanguageOptions?" ) -Error
        return
    } 

    if ($Text.count -eq 0) { return [sbyte]-1 }

    [sbyte]$skipNext = 0
    if ($All) { [uint16[]]$match = @() }

    $c    = $Text[0]
    $skip = $False
    if ($Text.count -gt 1 -and $Files.json.textEditor.parse -eq "oot") {
        if ($c -eq 5 -or $c -eq 6 -or $c -eq 12 -or $c -eq 14 -or $c -eq 17 -or $c -eq 19 -or $c -eq 20 -or $c -eq 30 -or $c -eq 7 -or $c -eq 18 -or $c -eq 21) { $skip = $True }
    }
    elseif ($Text.count -gt 1 -and $Files.json.textEditor.parse -eq "mm") {
        if ($c -eq 20 -or $c -eq 27 -or $c -eq 28 -or $c -eq 29 -or $c -eq 30 -or $c -eq 31) { $skip = $True }
    }

    $end = $DialogueList[$ID].msg.count - 1
    for ($i=$end; $i -ge $DialogueList[$ID].msg.count-4; $i--) {
        if ($DialogueList[$ID].msg[$i] -eq [byte]$Files.json.textEditor.end) {
            $end = $i - 1
            break
        }
    }

    foreach ($i in $Files.json.textEditor.header..$end) {
        if ($Text.Count -le 3 -and !$skip) {
            if ($skipNext -gt 0) { $skipNext--; continue }
            $c = $DialogueList[$ID].msg[$i]
            
            if ($Files.json.textEditor.parse -eq "oot") {
                if ($Text.Count -eq 1) {
                    if     ($c -eq 5 -or $c -eq 6 -or $c -eq 12 -or $c -eq 14 -or $c -eq 17 -or $c -eq 19 -or $c -eq 20 -or $c -eq 30)   { $skipNext++;  continue }
                    elseif ($c -eq 7 -or $c -eq 18)                                                                                      { $skipNext+=2; continue }
                    elseif ($c -eq 21)                                                                                                   { $skipNext+=3; continue }
                }
                elseif ($Text.Count -eq 2) {
                    if     ($c -eq 7 -or $i -eq 18)                                                                                      { $skipNext++;  continue }
                    elseif ($c -eq 21)                                                                                                   { $skipNext+=2; continue }
                }
                elseif ($Text.Count -eq 3) {
                    if     ($c -eq 21)                                                                                                   { $skipNext++;  continue }
                }
            }
            elseif ($Files.json.textEditor.parse -eq "mm") {
                if ($Text.Count -eq 1) {
                    if     ($c -eq 20)                                                                                                   { $skipNext++;  continue }
                    elseif ($c -eq 27 -or $c -eq 28 -or $c -eq 29 -or $c -eq 30 -or $c -eq 31)                                           { $skipNext+=2; continue }
                }
                elseif ($Text.Count -eq 2) {
                    if     ($c -eq 27 -or $c -eq 28 -or $c -eq 29 -or $c -eq 30 -or $c -eq 31)                                           { $skipNext++;  continue }
                }
            }
        }

        $search = $True

        if ($i + $Text.count - 1 -gt $end) {
            $search = $False
            break
        }

        foreach ($j in 0..($Text.count-1)) {
            if ($DialogueList[$ID].msg[$i + $j] -ne $Text[$j]) {
                $search = $False
                break
            }
        }

        if ($search) {
            if ($All)   { $match += $i      }
            else        { return [uint16]$i }
        }
    }
    if ($All) {
        if ($match.count -eq 0) { return [sbyte]-1 }
        return $match
    }
    return [sbyte]-1

}



#==============================================================================================================================================================================================
function LoadTextEditor() {
    
    if ($Files.json.textEditor -ne $null) { return }

    $Files.json.textEditor = SetJSONFile $GameFiles.textEditor

    $start  = CombineHex $ByteArrayGame[((GetDecimal $LanguagePatch.script_dma)+0)..((GetDecimal $LanguagePatch.script_dma)+3)]
    $end    = CombineHex $ByteArrayGame[((GetDecimal $LanguagePatch.script_dma)+4)..((GetDecimal $LanguagePatch.script_dma)+7)]
    $length = Get32Bit ( (GetDecimal $end) - (GetDecimal $start) )

    ExportBytes -Offset $start                     -Length $length                     -Output ($GameFiles.extracted + "\message_data_static." + $LanguagePatch.code + ".bin") -Force
    ExportBytes -Offset $LanguagePatch.table_start -Length $LanguagePatch.table_length -Output ($GameFiles.extracted + "\message_data."        + $LanguagePatch.code + ".tbl") -Force

    $global:LastScript = @{}
    LoadScript -Script ($GameFiles.extracted + "\message_data_static." + $LanguagePatch.code + ".bin") -Table ($GameFiles.extracted + "\message_data." + $LanguagePatch.code + ".tbl")

}



#==============================================================================================================================================================================================
function SetMessage([string]$ID, [object]$Text, [object]$Replace, [string]$File="", [switch]$Full, [switch]$Insert, [switch]$Append, [switch]$All, [switch]$ASCII, [switch]$Silent, [switch]$Safety, [switch]$Force) {
    
    if ($Files.json.textEditor -eq $null) { LoadTextEditor }

    if ($DialogueList -eq $null) {
        WriteToConsole ("Could not edit message ID: " + $ID + " as the message data does not exist. Did it ran outside ByteLanguageOptions?" ) -Error
        return
    }

    if ($DialogueList[$ID] -eq $null) {
        if (!$Silent) { WriteToConsole ("Could not find message ID: " + $ID) -Error }
        return -1
    }
    $re = "^[a-fa-f 0-9]*$"
    
    if ($Text.count -eq 0 -and $Replace.count -eq 0) {
        $Replace = $LastScript.replace
        $Text    = $LastScript.text

        $match = FindMatch -Text $Text -All $All
        if ($match -eq -1) {
            if (!$Silent) { WriteToConsole ("Could not find text to edit for message ID: " + $ID) -Error }
            return -2
        }
    }
    else {
        if ($Text.count -gt 0) {
            if ($Text -match $re -and !$ASCII) {
                if     ($Text -is [System.String] -and $Text  -Like "* *")   { [byte[]]$Text = $Text -split ' '           | foreach { [Convert]::ToByte($_, 16) } }
                elseif ($Text -is [System.String])                           { [byte[]]$Text = $Text -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) } }
            }
            else {
                $parse = $False
                if ($Text -like "*<*" -and $Text -like "*>*")   { $parse = $True }
                elseif ($Force)                                 { $parse = $True }
                $Text = $Text.toCharArray()
                if ($parse)    { $Text = ParseMessage -Text $Text -Encode }
                if ($Safety)   { for ($i=0; $i -lt $Text.count; $i++) { if ($Text[$i] -gt 255) { $Text[$i] = 63 } } }
            }

            $match = FindMatch -Text $Text -All $All
            if ($match -eq -1) {
                if (!$Silent) { WriteToConsole ("Could not find text to edit for message ID: " + $ID) -Error }
                return -2
            }
        }
        else {
            [uint16]$match = $Files.json.textEditor.header
            $Text  = $DialogueList[$ID].msg[$Files.json.textEditor.header..($DialogueList[$ID].msg.count - 1)]
            for ($i=$Text.count-1; $i -ge $Text.count-4; $i--) {
                if ($Text[$i] -eq [byte]$Files.json.textEditor.end) {
                    if ($i -eq 0)   { $Text = @()              }
                    else            { $Text = $Text[0..($i-1)] }
                    break
                }
            }
        }

        if     ($File -ne "") { if (TestFile -Path ($GameFiles.binaries + "\" + $File)) { $Replace = [System.IO.File]::ReadAllBytes($GameFiles.binaries + "\" + $File) } }
        elseif ($Replace.count -gt 0) {
            if ($Replace -match $re -and !$ASCII) {
                if     ($Replace  -is [System.String] -and $Replace  -Like "* *")   { [byte[]]$Replace = $Replace -split ' '           | foreach { [Convert]::ToByte($_, 16) } }
                elseif ($Replace  -is [System.String])                              { [byte[]]$Replace = $Replace -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) } }
            }
            else {
                $parse = $False
                if ($Replace -like "*<*" -and $Replace -like "*>*")   { $parse = $True }
                elseif ($Force)                                       { $parse = $True }
                $Replace = $Replace.toCharArray()
                if ($parse)    { $Replace = ParseMessage -Text $Replace -Encode }
                if ($Safety)   { for ($i=0; $i -lt $Replace.count; $i++) { if ($Replace[$i] -gt 255) { $Replace[$i] = 63 } } }
            }
        }
        else { [byte[]]$Replace = @() }

        $LastScript.replace = $Replace
        $LastScript.text    = $Text
    }
    
    for ($i=$DialogueList[$ID].msg.count-1; $i -ge $DialogueList[$ID].msg.count-4; $i--) {
        if ($DialogueList[$ID].msg[$i] -eq [byte]$Files.json.textEditor.end) {
            $DialogueList[$ID].msg.RemoveRange($i, ($DialogueList[$ID].msg.count - $i))
            break
        }
    }
    if ($Text.count -gt ($DialogueList[$ID].msg.count - $Files.json.textEditor.header) ) {
        $DialogueList[$ID].msg.Insert($DialogueList[$ID].msg.count, [byte]$Files.json.textEditor.end)
        while ($DialogueList[$ID].msg.count % 4 -ne 0) { $DialogueList[$ID].msg.Insert($DialogueList[$ID].msg.count, 0) }
        if (!$Silent) { WriteToConsole ("Text is too long to search for message ID: " + $ID) -Error }
        return -3
    }

    if ($Insert) {
        if ($Replace.count -gt 0) { $DialogueList[$ID].msg.InsertRange($Files.json.textEditor.header, $Replace) }
    }
    elseif ($Append)   {
        if ($Replace.count -gt 0) { $DialogueList[$ID].msg.InsertRange($DialogueList[$ID].msg.count, $Replace) }
    }
    elseif (!$All) {
        if ($Text.count    -gt 0) { $DialogueList[$ID].msg.RemoveRange($match, $Text.count) }
        if ($Replace.count -gt 0) { $DialogueList[$ID].msg.InsertRange($match, $Replace)    }
    }
    else {
        [int16]$correct = 0
        foreach ($m in $match) {
            if ($Text.count    -gt 0)   { $DialogueList[$ID].msg.RemoveRange($m + $correct, $Text.count) }
            if ($Replace.count -gt 0)   { $DialogueList[$ID].msg.InsertRange($m + $correct, $Replace)    }
            $correct += $Replace.count - $Text.Count
        }
    }

    $DialogueList[$ID].msg.Insert($DialogueList[$ID].msg.count, [byte]$Files.json.textEditor.end)
    while ($DialogueList[$ID].msg.count % 4 -ne 0) { $DialogueList[$ID].msg.Insert($DialogueList[$ID].msg.count, 0) }

    if (!$Silent) {
        if ($All)   { WriteToConsole ("Changed for all text at: " + $match            + " (ID: " + $ID + ")") }
        else        { WriteToConsole ("Changed text at: "         + (Get16Bit $match) + " (ID: " + $ID + ")") }
    }
    return 1

}



#==============================================================================================================================================================================================
function ParseMessage([char[]]$Text, [switch]$Encode) {
    
    if ($Encode) { $Text = ParseMessageLanguage -Text $Text -Encode }

    if     ($Files.json.textEditor.parse -eq "oot" -and  $Encode)   { $Text = ParseMessageOoT -Text $Text -Encode }
    elseif ($Files.json.textEditor.parse -eq "oot" -and !$Encode)   { $Text = ParseMessageOoT -Text $Text         }
    elseif ($Files.json.textEditor.parse -eq "mm"  -and  $Encode)   { $Text = ParseMessageMM  -Text $Text -Encode }
    elseif ($Files.json.textEditor.parse -eq "mm"  -and !$Encode)   { $Text = ParseMessageMM  -Text $Text         }

    if (!$Encode) { $Text = ParseMessageLanguage -Text $Text }

    $global:ScriptCounter = $null
    return $Text

}



#==============================================================================================================================================================================================
function ParseMessageLanguage([char[]]$Text, [switch]$Encode) {
    
    # Language Parsing

    [System.Collections.ArrayList]$types = @()
    for ($i=0; $i -lt $LanguagePatch.encode.length; $i++) { $types += $False }
    if (!$Encode) {
        foreach ($c in $Text) {
            if ($c -eq [byte]$Files.json.textEditor.end) { break }

            for ($i=0; $i -lt $LanguagePatch.encode.length; $i++) {
                if ([char]$c -eq [char]$LanguagePatch.encode[$i]) {
                    $types[$i] = $True
                }
            }
        }
    }
    else {
        for ($i=0; $i -lt $LanguagePatch.encode.length; $i++) { $types[$i] = $True }
    }

    for ($global:ScriptCounter=0; $ScriptCounter -lt $Text.count; $global:ScriptCounter++) {
        if ($Text[$ScriptCounter] -eq [byte]$Files.json.textEditor.end) { break }

        if ($Text[$ScriptCounter] -eq 60) {
            $skip = $False
            
            for ($i=$global:ScriptCounter; $i -lt $Text.count-1; $i++) {
                if     ($Text[$i+1] -eq 60)   { $skip = $False; break }
                elseif ($Text[$i+1] -eq 62)   { $skip = $True;  break }
            }
        }
        if ($Text[$ScriptCounter] -eq 62) { $skip = $False }

        if (!$skip) {
            for ($i=0; $i -lt $LanguagePatch.encode.length; $i++) {
                if ($types[$i]) {
                    $Text = ParseMessagePart -Text $Text -Encoded @($LanguagePatch.encode[$i]) -Decoded @($LanguagePatch.decode[$i]) -Encode $Encode
                }
            }
        }
    }

    $types = $null
    return $Text

}



#==============================================================================================================================================================================================
function ParseMessageOoT([char[]]$Text, [switch]$Encode) {

    [System.Collections.ArrayList]$types = @()
    for ($i=0; $i -lt 45; $i++) { $types += $False }

    if (!$Encode) {
        foreach ($c in $Text) {
            for ($i=0; $i -lt 32; $i++) {
                if ($c -eq $i)           { $types[$i] = $True }
            }
            for ($i=32; $i -lt 45; $i++) {
                if ($c -eq ($i + 127))   { $types[$i] = $True }
            }
        }
    }
    else {
        for ($i=0; $i -lt 45; $i++) { $types[$i] = $True }
    }

    for ($global:ScriptCounter=0; $ScriptCounter -lt $Text.count; $global:ScriptCounter++) {
        # Backgrounds
        if ($types[21]) {
            $Text = ParseMessagePart -Text $Text -Encoded @(21, 0, 1,  16) -Decoded @(60, 66, 97, 99, 107, 103, 114, 111, 117, 110, 100, 58, 50, 55, 50, 62)     -Encode $Encode # 15 00 01 10 / <Background:272>    (Background)
            $Text = ParseMessagePart -Text $Text -Encoded @(21, 0, 32, 0)  -Decoded @(60, 66, 97, 99, 107, 103, 114, 111, 117, 110, 100, 58, 56, 49, 57, 50, 62) -Encode $Encode # 15 00 20 00 / <Background:8192>   (Background)
        }

        # Sound effects / Jump to
        if ($types[7])    { $Text = ParseMessagePart -Text $Text -Encoded @(7,  255, 255) -Decoded @(60, 74, 117, 109, 112,      58,  255, 255, 62) -Encode $Encode } # 07 xx xx / <Jump:xxxx> (jump)
        if ($types[18])   { $Text = ParseMessagePart -Text $Text -Encoded @(18, 255, 255) -Decoded @(60, 83, 111, 117, 110, 100, 58,  255, 255, 62) -Encode $Encode } # 12 xx xx / <Sound:xxxx> (sound)

        # Loops
        if ($types[6])    { $Text = ParseMessagePart -Text $Text -Encoded @(6,  255) -Decoded @(60, 83, 104, 105, 102, 116, 58,  255, 62) -Encode $Encode } # 06 xx / <Shift:xx> (shift)
        if ($types[12])   { $Text = ParseMessagePart -Text $Text -Encoded @(12, 255) -Decoded @(60, 68, 101, 108, 97,  121, 58,  255, 62) -Encode $Encode } # 0C xx / <Delay:xx> (box break after delay)
        if ($types[14])   { $Text = ParseMessagePart -Text $Text -Encoded @(14, 255) -Decoded @(60, 70, 97,  100, 101, 58,  255, 62)      -Encode $Encode } # 0E xx / <Fade:xx>  (end box with fade out after amount of frames)
        if ($types[17])   { $Text = ParseMessagePart -Text $Text -Encoded @(17, 255) -Decoded @(60, 87, 97,  110, 101, 58,  255, 62)      -Encode $Encode } # 11 xx / <Wane:xx>  (unused fade out and wait)
        if ($types[19])   { $Text = ParseMessagePart -Text $Text -Encoded @(19, 255) -Decoded @(60, 73, 99,  111, 110, 58,  255, 62)      -Encode $Encode } # 13 xx / <Icon:xx>  (icon)
        if ($types[20])   { $Text = ParseMessagePart -Text $Text -Encoded @(20, 255) -Decoded @(60, 87, 97,  105, 116, 58,  255, 62)      -Encode $Encode } # 14 xx / <Wait:xx>  (wait for frames to print out text)

        # Color codes
        if ($types[5]) { 
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
        }

        # Highscore values
        if ($types[30]) { 
            $Text = ParseMessagePart -Text $Text -Encoded @(30, 0) -Decoded @(60, 83, 99, 111, 114, 101, 58, 65, 114, 99,  104, 101, 114, 121, 62)                -Encode $Encode # 1E 00 / <Score:Archery>    (horseback archery score)
            $Text = ParseMessagePart -Text $Text -Encoded @(30, 1) -Decoded @(60, 83, 99, 111, 114, 101, 58, 80, 111, 101, 32,  80,  111, 105, 110, 116, 115, 62) -Encode $Encode # 1E 01 / <Score:Poe Points> (poe points)
            $Text = ParseMessagePart -Text $Text -Encoded @(30, 2) -Decoded @(60, 83, 99, 111, 114, 101, 58, 70, 105, 115, 104, 105, 110, 103, 62)                -Encode $Encode # 1E 02 / <Score:Fishing>    (largest fish)
            $Text = ParseMessagePart -Text $Text -Encoded @(30, 3) -Decoded @(60, 83, 99, 111, 114, 101, 58, 72, 111, 114, 115, 101, 32,  82,  97,  99,  101, 62) -Encode $Encode # 1E 03 / <Score:Horse Race> (horse race time)
            $Text = ParseMessagePart -Text $Text -Encoded @(30, 4) -Decoded @(60, 83, 99, 111, 114, 101, 58, 77, 97,  114, 97,  116, 104, 111, 110, 62)           -Encode $Encode # 1E 04 / <Score:Marathon>   (marathon time)
            $Text = ParseMessagePart -Text $Text -Encoded @(30, 6) -Decoded @(60, 83, 99, 111, 114, 101, 58, 68, 97,  109, 112, 101, 32,  82,  97,  99,  101, 62) -Encode $Encode # 1E 06 / <Score:Dampe Race> (Dampe race time)
        }

        # Other
        if ($types[8])    { $Text = ParseMessagePart -Text $Text -Encoded @(8)  -Decoded @(60, 68, 73,  62)                                                                     -Encode $Encode } # 08 / <DI>               (enable instantaneous text)
        if ($types[9])    { $Text = ParseMessagePart -Text $Text -Encoded @(9)  -Decoded @(60, 68, 67,  62)                                                                     -Encode $Encode } # 09 / <DC>               (disable instantaneous text)
        if ($types[10])   { $Text = ParseMessagePart -Text $Text -Encoded @(10) -Decoded @(60, 83, 104, 111, 112, 32,  68, 101, 115, 99, 114, 105, 112, 116, 105, 111, 110, 62) -Encode $Encode } # 0A / <Shop Description> (keep box open)
        if ($types[11])   { $Text = ParseMessagePart -Text $Text -Encoded @(11) -Decoded @(60, 69, 118, 101, 110, 116, 62)                                                      -Encode $Encode } # 0B / <Event>            (trigger event)
        if ($types[13])   { $Text = ParseMessagePart -Text $Text -Encoded @(13) -Decoded @(60, 80, 114, 101, 115, 115, 62)                                                      -Encode $Encode } # 0D / <Press>            (unused wait for button press)
        if ($types[15])   { $Text = ParseMessagePart -Text $Text -Encoded @(15) -Decoded @(60, 80, 108, 97,  121, 101, 114, 62)                                                 -Encode $Encode } # 0F / <Player>           (player name)
        if ($types[16])   { $Text = ParseMessagePart -Text $Text -Encoded @(16) -Decoded @(60, 79, 99,  97,  114, 105, 110, 97, 62)                                             -Encode $Encode } # 10 / <Ocarina>          (play ocarina)
        if ($types[22])   { $Text = ParseMessagePart -Text $Text -Encoded @(22) -Decoded @(60, 77, 97,  114, 97,  116, 104, 111, 110, 32,  84, 105, 109, 101, 62)               -Encode $Encode } # 16 / <Marathon Time>    (Marathon Time)
        if ($types[23])   { $Text = ParseMessagePart -Text $Text -Encoded @(23) -Decoded @(60, 82, 97,  99,  101, 32,  84,  105, 109, 101, 62)                                  -Encode $Encode } # 17 / <Race Time>        (Race Time)
        if ($types[24])   { $Text = ParseMessagePart -Text $Text -Encoded @(24) -Decoded @(60, 80, 111, 105, 110, 116, 115, 62)                                                 -Encode $Encode } # 18 / <Points>           (Points)
        if ($types[25])   { $Text = ParseMessagePart -Text $Text -Encoded @(25) -Decoded @(60, 71, 111, 108, 100, 32,  83,  107, 117, 108, 108, 116, 117, 108, 97, 115, 62)     -Encode $Encode } # 19 / <Gold Skulltulas>  (Gold Skulltulas)
        if ($types[26])   { $Text = ParseMessagePart -Text $Text -Encoded @(26) -Decoded @(60, 78, 83,  62)                                                                     -Encode $Encode } # 1A / <NS>               (prevent text skip with B)
        if ($types[27])   { $Text = ParseMessagePart -Text $Text -Encoded @(27) -Decoded @(60, 84, 119, 111, 32,  67,  104, 111, 105, 99,  101, 115, 62)                        -Encode $Encode } # 1B / <Two Choices>      (two-choice selection)
        if ($types[28])   { $Text = ParseMessagePart -Text $Text -Encoded @(28) -Decoded @(60, 84, 104, 114, 101, 101, 32,  67,  104, 111, 105, 99,  101, 115, 62)              -Encode $Encode } # 1C / <Three Choices>    (three-choice selection)
        if ($types[29])   { $Text = ParseMessagePart -Text $Text -Encoded @(29) -Decoded @(60, 70, 105, 115, 104, 32,  87,  101, 105, 103, 104, 116, 62)                        -Encode $Encode } # 1D / <Fish Weight>      (caught fish)
        if ($types[31])   { $Text = ParseMessagePart -Text $Text -Encoded @(31) -Decoded @(60, 84, 105, 109, 101, 62)                                                           -Encode $Encode } # 1F / <Time>             (world time)

        # Controller buttons
        if ($types[32])    { $Text = ParseMessagePart -Text $Text -Encoded @(159) -Decoded @(60, 65, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode } # 9F / <A Button>      (A Button)
        if ($types[33])    { $Text = ParseMessagePart -Text $Text -Encoded @(160) -Decoded @(60, 66, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode } # A0 / <B Button>      (B Button)
        if ($types[34])    { $Text = ParseMessagePart -Text $Text -Encoded @(161) -Decoded @(60, 67, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode } # A1 / <C Button>      (C Button)
        if ($types[35])    { $Text = ParseMessagePart -Text $Text -Encoded @(162) -Decoded @(60, 76, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode } # A2 / <L Button>      (L Button)
        if ($types[36])    { $Text = ParseMessagePart -Text $Text -Encoded @(163) -Decoded @(60, 82, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode } # A3 / <R Button>      (R Button)
        if ($types[37])    { $Text = ParseMessagePart -Text $Text -Encoded @(164) -Decoded @(60, 90, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode } # A4 / <Z Button>      (Z Button)
        if ($types[38])    { $Text = ParseMessagePart -Text $Text -Encoded @(165) -Decoded @(60, 67, 32,  85,  112, 62)                                            -Encode $Encode } # A5 / <C Up>          (C-Up)
        if ($types[39])    { $Text = ParseMessagePart -Text $Text -Encoded @(166) -Decoded @(60, 67, 32,  68,  111, 119, 110, 62)                                  -Encode $Encode } # A6 / <C Down>        (C-Down)
        if ($types[40])    { $Text = ParseMessagePart -Text $Text -Encoded @(167) -Decoded @(60, 67, 32,  76,  101, 102, 116, 62)                                  -Encode $Encode } # A7 / <C Left>        (C-Left)
        if ($types[41])    { $Text = ParseMessagePart -Text $Text -Encoded @(168) -Decoded @(60, 67, 32,  82,  105, 103, 104, 116, 62)                             -Encode $Encode } # A8 / <C Right>       (C-Right)
        if ($types[42])    { $Text = ParseMessagePart -Text $Text -Encoded @(169) -Decoded @(60, 84, 114, 105, 97,  110, 103, 108, 101, 62)                        -Encode $Encode } # AA / <Triangle>      (Triangle)
        if ($types[43])    { $Text = ParseMessagePart -Text $Text -Encoded @(170) -Decoded @(60, 67, 111, 110, 116, 114, 111, 108, 32,  83, 116, 105, 99, 107, 62) -Encode $Encode } # AA / <Control Stick> (Control Stick)
        if ($types[44])    { $Text = ParseMessagePart -Text $Text -Encoded @(171) -Decoded @(60, 68, 45,  80,  97,  100, 62)                                       -Encode $Encode } # AB / <D-Pad>         (D-Pad)

        # New box / line break
        if ($TextEditor.Dialog -ne $null -and $TextEditor.Search -eq $null) {
            if ($types[4])   { $Text = ParseMessagePart -Text $Text -Encoded @(4) -Decoded @(13, 10, 60, 78, 101, 119, 32, 66, 111, 120, 62, 13, 10) -Encode $Encode } # 04 / <New Box> (box break with new lines)
            if ($types[1])   { $Text = ParseMessagePart -Text $Text -Encoded @(1) -Decoded @(13, 10)                                                 -Encode $Encode } # 01 / `r`n      (new line)
        }
        else {
            if ($types[4])   { $Text = ParseMessagePart -Text $Text -Encoded @(4) -Decoded @(60, 78, 101, 119, 32,  66,  111, 120, 62)  -Encode $Encode } # 04 / <New Box> (box break)
            if ($types[1])   { $Text = ParseMessagePart -Text $Text -Encoded @(1) -Decoded @(60, 78, 62)                                -Encode $Encode } # 01 / <N>       (new line)
        }
        
    }

    $types = $null
    return $Text

}



#==============================================================================================================================================================================================
function ParseMessageMM([char[]]$Text, [switch]$Encode) {
    
    [System.Collections.ArrayList]$types = @()
    for ($i=0; $i -lt 256; $i++) { $types += $False }
    if (!$Encode) {
        foreach ($c in $Text) {
            for ($i=0; $i -lt 256; $i++) {
                if ($c -eq $i) { $types[$i] = $True }
            }
        }
    }
    else {
        for ($i=0; $i -lt 256; $i++) { $types[$i] = $True }
    }

    for ($global:ScriptCounter=0; $ScriptCounter -lt $Text.count; $global:ScriptCounter++) {
        # Loops
        if ($types[20])   { $Text = ParseMessagePart -Text $Text -Encoded @(20, 255)      -Decoded @(60, 83, 112, 97,  99,  101, 58,  255, 62)           -Encode $Encode } # 14 xx    / <Space:xx>    (print spaces)
        if ($types[27])   { $Text = ParseMessagePart -Text $Text -Encoded @(27, 255, 255) -Decoded @(60, 68, 101, 108, 97,  121, 58,  255, 255, 62)      -Encode $Encode } # 1B xx xx / <Delay:xxxx>  (delay before printing remaining text)
        if ($types[28])   { $Text = ParseMessagePart -Text $Text -Encoded @(28, 255, 255) -Decoded @(60, 75, 101, 101, 112, 58,  255, 255, 62)           -Encode $Encode } # 1C xx xx / <Keep:xxxx>   (keep text on screen beflore closing)
        if ($types[29])   { $Text = ParseMessagePart -Text $Text -Encoded @(29, 255, 255) -Decoded @(60, 69, 110, 100, 58,  255, 255, 62)                -Encode $Encode } # 1D xx xx / <End:xxxx>    (delay before ending conversation)
        if ($types[30])   { $Text = ParseMessagePart -Text $Text -Encoded @(30, 255, 255) -Decoded @(60, 83, 111, 117, 110, 100, 58,  255, 255, 62)      -Encode $Encode } # 1E xx xx / <Sound:xxxx>  (play sound effect)
        if ($types[31])   { $Text = ParseMessagePart -Text $Text -Encoded @(31, 255, 255) -Decoded @(60, 82, 101, 115, 117, 109, 101, 58,  255, 255, 62) -Encode $Encode } # 1F xx xx / <Resume:xxxx> (delay before resuming text flow)

        # Color codes
        if ($types[0])   { $Text = ParseMessagePart -Text $Text -Encoded @(0) -Decoded @(60, 87, 62) -Encode $Encode } # 00 / <W> (white)
        if ($types[1])   { $Text = ParseMessagePart -Text $Text -Encoded @(1) -Decoded @(60, 82, 62) -Encode $Encode } # 01 / <R> (red)
        if ($types[2])   { $Text = ParseMessagePart -Text $Text -Encoded @(2) -Decoded @(60, 71, 62) -Encode $Encode } # 02 / <G> (green)
        if ($types[3])   { $Text = ParseMessagePart -Text $Text -Encoded @(3) -Decoded @(60, 66, 62) -Encode $Encode } # 03 / <B> (blue)
        if ($types[4])   { $Text = ParseMessagePart -Text $Text -Encoded @(4) -Decoded @(60, 67, 62) -Encode $Encode } # 04 / <Y> (yellow)
        if ($types[5])   { $Text = ParseMessagePart -Text $Text -Encoded @(5) -Decoded @(60, 77, 62) -Encode $Encode } # 05 / <C> (turgoise / cyan / light blue)
        if ($types[6])   { $Text = ParseMessagePart -Text $Text -Encoded @(6) -Decoded @(60, 89, 62) -Encode $Encode } # 06 / <M> (pink / magenta)
        if ($types[7])   { $Text = ParseMessagePart -Text $Text -Encoded @(7) -Decoded @(60, 75, 62) -Encode $Encode } # 07 / <S> (silver)
        if ($types[8])   { $Text = ParseMessagePart -Text $Text -Encoded @(8) -Decoded @(60, 75, 62) -Encode $Encode } # 08 / <O> (orange)

        # Print
        if ($types[11])    { $Text = ParseMessagePart -Text $Text -Encoded @(11)  -Decoded @(60, 67, 114, 117, 105, 115, 101, 32,  67,  114, 117, 105, 115, 101 ,58, 72,  105, 116, 115, 62) -Encode $Encode } # 0B / <Jungle Cruise:Hits> (jungle cruise required hits)
        if ($types[13])    { $Text = ParseMessagePart -Text $Text -Encoded @(13)  -Decoded @(60, 71, 111, 108, 100, 32,  83,  107, 117, 108, 108, 116, 117, 108, 97, 115, 62)                -Encode $Encode } # 0D / <Gold Skulltulas>    (Gold Skulltulas)
        if ($types[22])    { $Text = ParseMessagePart -Text $Text -Encoded @(22)  -Decoded @(60, 80, 108, 97,  121, 101, 114, 62)                                                            -Encode $Encode } # 16 / <Player>             (player name)
        if ($types[196])   { $Text = ParseMessagePart -Text $Text -Encoded @(196) -Decoded @(60, 80, 111, 115, 116, 109, 97,  110, 62)                                                       -Encode $Encode } # C4 / <Postman>            (postman counting game)
        if ($types[199])   { $Text = ParseMessagePart -Text $Text -Encoded @(199) -Decoded @(60, 67, 108, 111, 99,  107, 32,  84,  111, 119, 101, 114, 62)                                   -Encode $Encode } # C7 / <Clock Tower>        (time until moon falls when on the clock tower)
        if ($types[200])   { $Text = ParseMessagePart -Text $Text -Encoded @(200) -Decoded @(60, 80, 108, 97,  121, 103, 114, 111, 117, 110, 100, 62)                                        -Encode $Encode } # C8 / <Playground>         (deku scrub playground)
        if ($types[202])   { $Text = ParseMessagePart -Text $Text -Encoded @(202) -Decoded @(60, 67, 108, 111, 99,  107, 84,  105, 109, 101, 62)                                             -Encode $Encode } # CA / <ClockTime>          (shows the current time of day)
        if ($types[203])   { $Text = ParseMessagePart -Text $Text -Encoded @(203) -Decoded @(60, 83, 104, 111, 111, 116, 105, 110, 103, 32,  71,  97,  108, 108, 101, 114, 121, 62)          -Encode $Encode } # CB / <Shooting Gallery>   (shooting gallery)
        if ($types[205])   { $Text = ParseMessagePart -Text $Text -Encoded @(205) -Decoded @(60, 82, 117, 112, 101, 101, 115, 62)                                                            -Encode $Encode } # CD / <Rupees>             (rupees entered or bet)
        if ($types[206])   { $Text = ParseMessagePart -Text $Text -Encoded @(206) -Decoded @(60, 82, 117, 112, 101, 101, 115, 32,  84,  111, 116, 97,  108, 62)                              -Encode $Encode } # CE / <Rupees Total>       (total rupees in bank or won by betting)
        if ($types[207])   { $Text = ParseMessagePart -Text $Text -Encoded @(207) -Decoded @(60, 84, 105, 109, 101, 62)                                                                      -Encode $Encode } # CF / <Time>               (remaining time reported by gossip stone)
        if ($types[212])   { $Text = ParseMessagePart -Text $Text -Encoded @(212) -Decoded @(60, 83, 111, 97,  114, 105, 110, 103, 62)                                                       -Encode $Encode } # D4 / <Soaring>            (song of soaring destination)
        if ($types[218])   { $Text = ParseMessagePart -Text $Text -Encoded @(219) -Decoded @(60, 67, 114, 117, 105, 115, 101, 32,  67,  114, 117, 105, 115, 101 ,62)                         -Encode $Encode } # DB / <Jungle Cruise>      (jungle cruise)
        if ($types[220])   { $Text = ParseMessagePart -Text $Text -Encoded @(220) -Decoded @(60, 76, 111, 116, 116, 101, 114, 121, 58,  87,  105, 110, 62)                                   -Encode $Encode } # DC / <Lottery:Win>        (winning lottery numbers)
        if ($types[221])   { $Text = ParseMessagePart -Text $Text -Encoded @(221) -Decoded @(60, 76, 111, 116, 116, 101, 114, 121, 62)                                                       -Encode $Encode } # DD / <Lottery>            (player lottery numbers)
        if ($types[222])   { $Text = ParseMessagePart -Text $Text -Encoded @(222) -Decoded @(60, 86, 97,  108, 117, 101, 62)                                                                 -Encode $Encode } # DE / <Value>              (item value in rupees)
        if ($types[223])   { $Text = ParseMessagePart -Text $Text -Encoded @(223) -Decoded @(60, 66, 111, 109, 98,  101, 114, 62)                                                            -Encode $Encode } # DF / <Bomber>             (bomber's code)
        if ($types[240])   { $Text = ParseMessagePart -Text $Text -Encoded @(240) -Decoded @(60, 66, 97,  110, 107, 62)                                                                      -Encode $Encode } # F0 / <Bank>               (totaal rupees in bank)
        if ($types[245])   { $Text = ParseMessagePart -Text $Text -Encoded @(245) -Decoded @(60, 84, 105, 109, 101, 114, 62)                                                                 -Encode $Encode } # F5 / <Timer>              (timer / highscore)
        if ($types[248])   { $Text = ParseMessagePart -Text $Text -Encoded @(248) -Decoded @(60, 77, 97,  103, 105, 99,  32,  66, 101, 97,  110, 62)                                         -Encode $Encode } # F8 / <Magic Bean>         (magic bean prise)

        # Display prompt
        if ($types[204])   { $Text = ParseMessagePart -Text $Text -Encoded @(204) -Decoded @(60, 80, 114, 111, 109, 112, 116, 58, 66, 97,  110, 107, 62)                -Encode $Encode } # CC / <Prompt:Bank>    (Withdraw or deposit)
        if ($types[208])   { $Text = ParseMessagePart -Text $Text -Encoded @(208) -Decoded @(60, 80, 114, 111, 109, 112, 116, 58, 66, 101, 116, 62)                     -Encode $Encode } # D0 / <Prompt:Bet>     (rupees to bet)
        if ($types[209])   { $Text = ParseMessagePart -Text $Text -Encoded @(209) -Decoded @(60, 80, 114, 111, 109, 112, 116, 58, 66, 111, 109, 98,  101, 114, 62)      -Encode $Encode } # D1 / <Prompt:Bomber>  (bomber's code)
        if ($types[213])   { $Text = ParseMessagePart -Text $Text -Encoded @(213) -Decoded @(60, 80, 114, 111, 109, 112, 116, 58, 76, 111, 116, 116, 101, 114, 121, 62) -Encode $Encode } # D5 / <Prompt:Lottery> (lottery number)

        # Scores
        if ($types[246])   { $Text = ParseMessagePart -Text $Text -Encoded @(246) -Decoded @(60, 83, 99, 111, 114, 101, 58, 83, 104, 111, 111, 116, 105, 110, 103, 32,  71,  97, 108, 108, 101, 121, 62) -Encode $Encode } # F6 / <Score:Shooting Galley> (shooting gallery highscore)
        if ($types[249])   { $Text = ParseMessagePart -Text $Text -Encoded @(249) -Decoded @(60, 83, 99, 111, 114, 101, 58, 66, 97,  108, 108, 111, 111, 110, 32,  65,  114, 99, 104, 101, 114, 121, 62) -Encode $Encode } # F9 / <Score:Balloon Archery> (balloon archery highscore)
        if ($types[250])   { $Text = ParseMessagePart -Text $Text -Encoded @(250) -Decoded @(60, 83, 99, 111, 114, 101, 58, 80, 108, 97,  121, 103, 114, 111, 117, 110, 100, 32, 49,  62)                -Encode $Encode } # FA / <Score:Playground 1>    (playground day 1 highscore)
        if ($types[251])   { $Text = ParseMessagePart -Text $Text -Encoded @(251) -Decoded @(60, 83, 99, 111, 114, 101, 58, 80, 108, 97,  121, 103, 114, 111, 117, 110, 100, 32, 50,  62)                -Encode $Encode } # FB / <Score:Playground 2>    (playground day 2 highscore)
        if ($types[252])   { $Text = ParseMessagePart -Text $Text -Encoded @(252) -Decoded @(60, 83, 99, 111, 114, 101, 58, 80, 108, 97,  121, 103, 114, 111, 117, 110, 100, 32, 51,  62)                -Encode $Encode } # FC / <Score:Playground 3>    (playground day 3 highscore)

        # Fairies
        if ($types[12])    { $Text = ParseMessagePart -Text $Text -Encoded @(12)  -Decoded @(60, 70, 97, 105, 114, 105, 101, 115, 62)         -Encode $Encode } # 0C / <Fairies>   (collected stray fairies)
        if ($types[215])   { $Text = ParseMessagePart -Text $Text -Encoded @(215) -Decoded @(60, 70, 97, 105, 114, 105, 101, 115, 58, 49, 62) -Encode $Encode } # D7 / <Fairies:1> (remaining fairies woodfall temple)
        if ($types[216])   { $Text = ParseMessagePart -Text $Text -Encoded @(216) -Decoded @(60, 70, 97, 105, 114, 105, 101, 115, 58, 50, 62) -Encode $Encode } # D8 / <Fairies:2> (remaining fairies snowhead temple)
        if ($types[217])   { $Text = ParseMessagePart -Text $Text -Encoded @(217) -Decoded @(60, 70, 97, 105, 114, 105, 101, 115, 58, 51, 62) -Encode $Encode } # D9 / <Fairies:3> (remaining fairies great bay temple)
        if ($types[218])   { $Text = ParseMessagePart -Text $Text -Encoded @(218) -Decoded @(60, 70, 97, 105, 114, 105, 101, 115, 58, 52, 62) -Encode $Encode } # DA / <Fairies:4> (remaining fairies stone tower temple)

        # Print (spider house)
        if ($types[214])   { $Text = ParseMessagePart -Text $Text -Encoded @(214) -Decoded @(32, 60, 83, 112, 105, 100, 101, 114, 32, 72, 111, 117, 115, 101, 62)         -Encode $Encode } # D6 / <Spider House>   (123456 spider house mask code)
        if ($types[225])   { $Text = ParseMessagePart -Text $Text -Encoded @(225) -Decoded @(32, 60, 83, 112, 105, 100, 101, 114, 32, 72, 111, 117, 115, 101, 58, 49, 62) -Encode $Encode } # E1 / <Spider House:1> (oceanside spider house mask color 1)
        if ($types[226])   { $Text = ParseMessagePart -Text $Text -Encoded @(226) -Decoded @(32, 60, 83, 112, 105, 100, 101, 114, 32, 72, 111, 117, 115, 101, 58, 50, 62) -Encode $Encode } # E2 / <Spider House:2> (oceanside spider house mask color 2)
        if ($types[227])   { $Text = ParseMessagePart -Text $Text -Encoded @(227) -Decoded @(32, 60, 83, 112, 105, 100, 101, 114, 32, 72, 111, 117, 115, 101, 58, 51, 62) -Encode $Encode } # E3 / <Spider House:3> (oceanside spider house mask color 3)
        if ($types[228])   { $Text = ParseMessagePart -Text $Text -Encoded @(228) -Decoded @(32, 60, 83, 112, 105, 100, 101, 114, 32, 72, 111, 117, 115, 101, 58, 52, 62) -Encode $Encode } # E4 / <Spider House:4> (oceanside spider house mask color 4)
        if ($types[229])   { $Text = ParseMessagePart -Text $Text -Encoded @(229) -Decoded @(32, 60, 83, 112, 105, 100, 101, 114, 32, 72, 111, 117, 115, 101, 58, 53, 62) -Encode $Encode } # E5 / <Spider House:5> (oceanside spider house mask color 5)
        if ($types[230])   { $Text = ParseMessagePart -Text $Text -Encoded @(230) -Decoded @(32, 60, 83, 112, 105, 100, 101, 114, 32, 72, 111, 117, 115, 101, 58, 54, 62) -Encode $Encode } # E6 / <Spider House:6> (oceanside spider house mask color 6)

        # Other
        if ($types[10])    { $Text = ParseMessagePart -Text $Text -Encoded @(10)  -Decoded @(60, 83, 108, 111, 119, 62)                                                             -Encode $Encode } # 0A / <Slow>             (slows down text)
        if ($types[19])    { $Text = ParseMessagePart -Text $Text -Encoded @(19)  -Decoded @(60, 82, 101, 115, 101, 116, 62)                                                        -Encode $Encode } # 13 / <Reset>            (reset cursor position)
        if ($types[23])    { $Text = ParseMessagePart -Text $Text -Encoded @(23)  -Decoded @(60, 68, 73,  62)                                                                       -Encode $Encode } # 17 / <DI>               (enable instantaneous text)
        if ($types[24])    { $Text = ParseMessagePart -Text $Text -Encoded @(24)  -Decoded @(60, 68, 67,  62)                                                                       -Encode $Encode } # 18 / <DC>               (disable instantaneous text)
        if ($types[26])    { $Text = ParseMessagePart -Text $Text -Encoded @(26)  -Decoded @(60, 83, 104, 111, 112, 32,  68,  101, 115, 99,  114, 105, 112, 116, 105, 111, 110, 62) -Encode $Encode } # 1A / <Shop Description> (keep box open)
        if ($types[193])   { $Text = ParseMessagePart -Text $Text -Encoded @(193) -Decoded @(60, 79, 99,  97,  114, 105, 110, 97,  62)                                              -Encode $Encode } # C1 / <Ocarina>          (ocarina song failure)
        if ($types[21])    { $Text = ParseMessagePart -Text $Text -Encoded @(21)  -Decoded @(60, 78, 83,  62)                                                                       -Encode $Encode } # 15 / <NS>               (prevent text skip with B, without sound)
        if ($types[25])    { $Text = ParseMessagePart -Text $Text -Encoded @(25)  -Decoded @(60, 78, 83,  83,  62)                                                                  -Encode $Encode } # 19 / <NSS>              (prevent text skip with B, with sound)
        if ($types[26])    { $Text = ParseMessagePart -Text $Text -Encoded @(26)  -Decoded @(60, 78, 67,  62)                                                                       -Encode $Encode } # 1A / <NC>               (prevent textbox close)
        if ($types[195])   { $Text = ParseMessagePart -Text $Text -Encoded @(195) -Decoded @(60, 84, 104, 114, 101, 101, 32,  67,  104, 111, 105, 99,  101, 115, 62)                -Encode $Encode } # C3 / <Three Choices>    (three-choice selection)
        if ($types[194])   { $Text = ParseMessagePart -Text $Text -Encoded @(194) -Decoded @(60, 84, 119, 111, 32,  67,  104, 111, 105, 99,  101, 115, 62)                          -Encode $Encode } # C2 / <Two Choices>      (two-choice selection)


        # Controller buttons
        if ($types[176])   { $Text = ParseMessagePart -Text $Text -Encoded @(176) -Decoded @(60, 65, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode } # B0 / <A Button>      (A Button)
        if ($types[177])   { $Text = ParseMessagePart -Text $Text -Encoded @(177) -Decoded @(60, 66, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode } # B1 / <B Button>      (B Button)
        if ($types[178])   { $Text = ParseMessagePart -Text $Text -Encoded @(178) -Decoded @(60, 67, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode } # B2 / <C Button>      (C Button)
        if ($types[179])   { $Text = ParseMessagePart -Text $Text -Encoded @(179) -Decoded @(60, 76, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode } # B3 / <L Button>      (L Button)
        if ($types[180])   { $Text = ParseMessagePart -Text $Text -Encoded @(180) -Decoded @(60, 82, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode } # B4 / <R Button>      (R Button)
        if ($types[181])   { $Text = ParseMessagePart -Text $Text -Encoded @(181) -Decoded @(60, 90, 32,  66,  117, 116, 116, 111, 110, 62)                        -Encode $Encode } # B5 / <Z Button>      (Z Button)
        if ($types[182])   { $Text = ParseMessagePart -Text $Text -Encoded @(182) -Decoded @(60, 67, 32,  85,  112, 62)                                            -Encode $Encode } # B6 / <C Up>          (C-Up)
        if ($types[183])   { $Text = ParseMessagePart -Text $Text -Encoded @(183) -Decoded @(60, 67, 32,  68,  111, 119, 110, 62)                                  -Encode $Encode } # B7 / <C Down>        (C-Down)
        if ($types[184])   { $Text = ParseMessagePart -Text $Text -Encoded @(184) -Decoded @(60, 67, 32,  76,  101, 102, 116, 62)                                  -Encode $Encode } # B8 / <C Left>        (C-Left)
        if ($types[185])   { $Text = ParseMessagePart -Text $Text -Encoded @(185) -Decoded @(60, 67, 32,  82,  105, 103, 104, 116, 62)                             -Encode $Encode } # B9 / <C Right>       (C-Right)
        if ($types[186])   { $Text = ParseMessagePart -Text $Text -Encoded @(186) -Decoded @(60, 84, 114, 105, 97,  110, 103, 108, 101, 62)                        -Encode $Encode } # BA / <Triangle>      (Triangle)
        if ($types[187])   { $Text = ParseMessagePart -Text $Text -Encoded @(187) -Decoded @(60, 67, 111, 110, 116, 114, 111, 108, 32,  83, 116, 105, 99, 107, 62) -Encode $Encode } # BB / <Control Stick> (Control Stick)
        if ($types[188])   { $Text = ParseMessagePart -Text $Text -Encoded @(188) -Decoded @(60, 68, 45,  80,  97,  100, 62)                                       -Encode $Encode } # BC / <D-Pad>         (D-Pad)
        if ($types[224])   { $Text = ParseMessagePart -Text $Text -Encoded @(224) -Decoded @(60, 69, 110, 100, 62)                                                 -Encode $Encode } # E0 / <End>           (End conversation)

        # New box / line break
        if ($TextEditor.Dialog -ne $null -and $TextEditor.Search -eq $null) {
            if ($types[16])   { $Text = ParseMessagePart -Text $Text -Encoded @(16) -Decoded @(13, 10, 60,  78,  101, 119, 32,  66,  111, 120, 62, 13, 10)             -Encode $Encode } # 10 / <New Box>    (box break with new lines)
            if ($types[18])   { $Text = ParseMessagePart -Text $Text -Encoded @(18) -Decoded @(13, 10, 60,  78,  101, 119, 32,  66,  111, 120, 32, 73, 73, 62, 13, 10) -Encode $Encode } # 12 / <New Box II> (box break with new lines)
            if ($types[17])   { $Text = ParseMessagePart -Text $Text -Encoded @(17) -Decoded @(13, 10)                                                                 -Encode $Encode } # 11 / `r`n         (new line)
        }
        else {
            if ($types[16])   { $Text = ParseMessagePart -Text $Text -Encoded @(16) -Decoded @(60, 78, 101, 119, 32,  66,  111, 120, 62)                               -Encode $Encode } # 10 / <New Box>    (box break)
            if ($types[18])   { $Text = ParseMessagePart -Text $Text -Encoded @(18) -Decoded @(60, 78, 101, 119, 32,  66,  111, 120, 32,  73,  73, 62)                 -Encode $Encode } # 12 / <New Box II> (box break)
            if ($types[17])   { $Text = ParseMessagePart -Text $Text -Encoded @(17) -Decoded @(60, 78, 62)                                                             -Encode $Encode } # 11 / <N>          (new line)
        }
    }

    $types = $null
    return $Text

}



#==============================================================================================================================================================================================
function ParseMessagePart([System.Collections.ArrayList]$Text, [System.Collections.ArrayList]$Encoded, [System.Collections.ArrayList]$Decoded, [boolean]$Encode=$False) {
    
    $i = $ScriptCounter

    if (!$Encode -and $Text.count -gt $i + 1 -and $TextEditor.Dialog -ne $null -and $TextEditor.Search -eq $null) {
        if ($Text[$i] -eq 13 -and $Text[$i+1] -eq 10) {
            $global:ScriptCounter = $i + 1
            return $Text
        }
    }

    if ($Encode -and $Text.count -ge $Decoded.count -and $Text.count -gt 1 -and $i -le ($Text.count - $Decoded.count)) {
        :inner for ($j=0; $j -lt $Decoded.count; $j++) {
            if ($i+$j -ge $Text.count)   { break }
            if ($Decoded[$j] -eq 255)    { $Decoded.Insert($j, 255); $j++ }
            if ($Text[$i+$j] -ne $Decoded[$j] -and $Decoded[$j] -ne 255) { break }
            if ($j -eq ($Decoded.count-1)) {
                if ($Encoded[-2] -eq 255 -or $Encoded[-1] -eq 255) {
                    [byte[]]$values   = @()
                    $regEx = '^0?[xX]?[0-9a-fA-F]*$'
                    if ($Encoded[-2] -eq 255) {
                        $value = [char]$Text[$i+$Decoded.count-5] + [char]$Text[$i+$Decoded.count-4]
                        if ($value -match $regEx)   { $Encoded[-2] = (GetDecimal $value) }
                        else                        { WriteToConsole "Text does not contain a valid hex value" -Error; break inner }
                    }
                    if ($Encoded[-1] -eq 255) {
                        $value = [char]$Text[$i+$Decoded.count-3] + [char]$Text[$i+$Decoded.count-2]
                        if ($value -match $regEx)   { $Encoded[-1] = (GetDecimal $value) }
                        else                        { WriteToConsole "Text does not contain a valid hex value" -Error; break inner }
                    }
                }
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
            if ($c -ne $Encoded[$j] -and $Encoded[$j] -ne 255) { break }
            if ($j -eq ($Encoded.count-1)) {
                if ($Decoded[-4] -eq 255 -or $Decoded[-3] -eq 255 -or $Decoded[-2] -eq 255) {
                    [byte[]]$values = @()
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
Export-ModuleMember -Function CloseTextEditor
Export-ModuleMember -Function SaveScript
Export-ModuleMember -Function LoadScript
Export-ModuleMember -Function GetMessage
Export-ModuleMember -Function GetMessageOffset
Export-ModuleMember -Function GetMessagelength
Export-ModuleMember -Function LoadTextEditor
Export-ModuleMember -Function SetMessage
Export-ModuleMember -Function SetMessageBox
Export-ModuleMember -Function SetMessagePosition
Export-ModuleMember -Function SetMessageIcon
Export-ModuleMember -Function SetMessageRupeeCost
Export-ModuleMember -Function SetJumpToMessage