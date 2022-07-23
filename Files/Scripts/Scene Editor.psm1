function CreateSceneEditorDialog([int32]$Width, [int32]$Height, [string]$Game=$GameType.mode, [string]$Checksum) {
    
    $global:SceneEditor   = @{}
    $SceneEditor.Game     = $Game
    $SceneEditor.Checksum = $Checksum

    # Create Dialog
    $SceneEditor.Dialog           = CreateDialog -Width (DPISize 1000) -Height (DPISize 550)
    $SceneEditor.Dialog.Icon      = $Files.icon.additional
    $SceneEditor.Dialog.BackColor = 'AntiqueWhite'

    # Groups
    $SceneEditor.TopGroup    = CreateGroupBox -X (DPISize 10) -Y (DPISize 5)                                   -Width ($SceneEditor.Dialog.Width - (DPISize 30)) -Height (DPISize 100)                                -AddTo $SceneEditor.Dialog
    $SceneEditor.BottomGroup = CreateGroupBox -X (DPISize 10) -Y ($SceneEditor.TopGroup.Bottom + (DPISize 10)) -Width ($SceneEditor.Dialog.Width - (DPISize 30)) -Height ($SceneEditor.Dialog.Height - (DPISize 220)) -AddTo $SceneEditor.Dialog

    # Close Button
    $X = $SceneEditor.Dialog.Left + ($SceneEditor.Dialog.Width / 3)
    $Y = $SceneEditor.Dialog.Height - (DPISize 90)
    $CloseButton           = CreateButton -X $X -Y $Y -Width (DPISize 80) -Height (DPISize 35) -Text "Close" -AddTo $SceneEditor.Dialog
    $CloseButton.BackColor = "White"
    $CloseButton.Add_Click( { $SceneEditor.Dialog.Hide() })
    
    # Search Button
    $SearchButton = CreateButton -X ($CloseButton.Right + (DPISize 15)) -Y $CloseButton.Top -Width $CloseButton.Width -Height $CloseButton.Height -Text "Search" -AddTo $SceneEditor.Dialog
    $SearchButton.BackColor = "White"

    # Extract Button
    $ExtractButton = CreateButton -X ($SearchButton.Right + (DPISize 15)) -Y $SearchButton.Top -Width $SearchButton.Width -Height $SearchButton.Height -Text "Extract Scenes" -AddTo $SceneEditor.Dialog
    $ExtractButton.BackColor = "White"

    # Options Label
    $SceneEditor.Label = CreateLabel -Y (DPISize 15) -Width $SceneEditor.Dialog.width -Height (DPISize 15) -Font $Fonts.SmallBold -Text ($SceneEditor.Game + " - Scene Editor") -AddTo $SceneEditor.Dialog
    $SceneEditor.Label.AutoSize = $True
    $SceneEditor.Label.Left = ([Math]::Floor($SceneEditor.Dialog.Width / 2) - [Math]::Floor($SceneEditor.Label.Width / 2))

    $Files.json.sceneEditor = SetJSONFile ($Paths.Games + "\" + $SceneEditor.Game + "\Scene Editor.json")

    $ExtractButton.Add_Click({
        $global:PatchInfo     = @{}
        $PatchInfo.decompress = $True
        $global:CheckHashSum  = $SceneEditor.Checksum
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
function RunSceneEditor([string]$Game=$GameType.mode, [string]$Checksum) {
    
    CreateSceneEditorDialog -Game $Game -Checksum $Checksum
    $SceneEditor.Dialog.ShowDialog()
    if (!(TestFile ($Paths.Games + "\" + $Game + "\SceneEditor\message_data_static.bin")) -or !(TestFile ($Paths.Games + "\" + $Game + "\SceneEditor\message_data.tbl")) ) { return }
    SaveScript -Script ($Paths.Games + "\" + $Game + "\SceneEditor\message_data_static.bin") -Table ($Paths.Games + "\" + $Game + "\SceneEditor\message_data.tbl")
    CreateSubPath ($Paths.Games + "\" + $Game + "\Custom Text")
    Copy-Item -LiteralPath ($Paths.Games + "\" + $Game + "\SceneEditor\message_data_static.bin") -Destination ($Paths.Games + "\" + $Game + "\Custom Text\message_data_static.bin") -Force
    Copy-Item -LiteralPath ($Paths.Games + "\" + $Game + "\SceneEditor\message_data.tbl")        -Destination ($Paths.Games + "\" + $Game + "\Custom Text\message_data.tbl")        -Force

}



#==============================================================================================================================================================================================
function LoadScenes() {

    

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function RunSceneEditor