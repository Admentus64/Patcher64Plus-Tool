function ByteOptions() {
    
    $offset = SearchBytes -Start "B4E000" -End "B58000" -Values "00 02 02 04 B6 00 10 7C 03 F4 65 BF FF F8 07 FF 00 FF E0 1F C4 09 95 FE 00 91 0C A7 9B ED F8 F7 6D 23 00 DF CA 0D DC FF 7F B4 9A 6F F6 53 FD FE"
    PatchBytes -Offset $offset -Patch ("Cursors\" + $Redux.HUD.Cursors.Text.replace(" (default)", "") + ".bin") -Texture

}



#==============================================================================================================================================================================================
function CreateOptions() {
    
    CreateOptionsDialog -Columns 3 -Height 400

}



#==============================================================================================================================================================================================
function CreateTabMain() {

    CreateReduxGroup    -Tag  "HUD" -Text "Cursors"
    CreateReduxComboBox -Name "Cursors" -Text "Cursors" -Items @("GoldenEye") -FilePath ($GameFiles.textures + "\Cursors") -Ext "bin" -Default "GoldenEye" -Info "Set the style for the cursor" -Credits "GhostlyDark (injects) & Intermission (HD assets)"

    CreateReduxGroup -Tag "HUD" -Text "Cursor Previews"    $Last.Group.Height = (DPISize 140)
    CreateImageBox -x 40 -y 30 -w 90 -h 90 -Name "CursorPreview"

    $Redux.HUD.Cursors.Add_SelectedIndexChanged( {
        $path = ($GameFiles.textures + "\Cursors\" + $Redux.HUD.Cursors.Text.replace(" (default)", "") + ".png")
        if (TestFile $path)   { SetBitMap -Path $path -Box $Redux.HUD.CursorPreview -Width 90 -Height 90 }
        else                  { $Redux.HUD.CursorPreview.Image = $null }
    } )
    $path = ($GameFiles.textures + "\Cursors\" + $Redux.HUD.Cursors.Text.replace(" (default)", "") + ".png")
    if (TestFile $path)   { SetBitMap -Path $path -Box $Redux.HUD.CursorPreview -Width 90 -Height 90 }
    else                  { $Redux.HUD.CursorPreview.Image = $null }

}



#==============================================================================================================================================================================================
function CreateTabLanguage() {
    
    CreateLanguageContent

}