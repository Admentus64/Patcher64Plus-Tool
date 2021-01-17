function GetSFXID([String]$SFX) {
    
    $SFX = $SFX.replace(' (default)', "")
    if     ($SFX -eq "None" -or $SFX -eq "Disabled")   { return @("00", "00") }
    elseif ($SFX -eq "Armos")                   { return @("38", "48") }     elseif ($SFX -eq "Bark")                    { return @("28", "D8") }     elseif ($SFX -eq "Bomb Bounce")             { return @("28", "2F") }
    elseif ($SFX -eq "Bongo Bongo High")        { return @("39", "51") }     elseif ($SFX -eq "Bongo Bongo Low")         { return @("39", "50") }     elseif ($SFX -eq "Bottle Cork")             { return @("28", "6C") }
    elseif ($SFX -eq "Bow Twang")               { return @("18", "30") }     elseif ($SFX -eq "Bubble Laugh")            { return @("38", "CA") }     elseif ($SFX -eq "Business Scrub")          { return @("38", "82") }
    elseif ($SFX -eq "Carrot Refill")           { return @("48", "45") }     elseif ($SFX -eq "Cartoon Fall")            { return @("28", "A0") }     elseif ($SFX -eq "Change Item")             { return @("08", "35") }
    elseif ($SFX -eq "Chest Open")              { return @("28", "20") }     elseif ($SFX -eq "Child Cringe")            { return @("68", "3A") }     elseif ($SFX -eq "Child Gasp")              { return @("68", "36") }
    elseif ($SFX -eq "Child Hurt")              { return @("68", "25") }     elseif ($SFX -eq "Child Owo")               { return @("68", "23") }     elseif ($SFX -eq "Child Pant")              { return @("68", "29") }
    elseif ($SFX -eq "Child Scream")            { return @("68", "28") }     elseif ($SFX -eq "Cluck")                   { return @("28", "12") }     elseif ($SFX -eq "Cockadoodledoo")          { return @("28", "13") }
    elseif ($SFX -eq "Cursed Attack")           { return @("68", "68") }     elseif ($SFX -eq "Cursed Scream")           { return @("68", "67") }     elseif ($SFX -eq "Deku Baba")               { return @("38", "60") }
    elseif ($SFX -eq "Drawbridge Set")          { return @("28", "0E") }     elseif ($SFX -eq "Dusk Howl")               { return @("28", "AE") }     elseif ($SFX -eq "Epona (Young)")           { return @("28", "44") }
    elseif ($SFX -eq "Exploding Crate")         { return @("28", "39") }     elseif ($SFX -eq "Explosion")               { return @("18", "0E") }     elseif ($SFX -eq "Fanfare (Light)")         { return @("48", "24") }
    elseif ($SFX -eq "Fanfare (Medium)")        { return @("48", "31") }     elseif ($SFX -eq "Field Shrub")             { return @("28", "77") }     elseif ($SFX -eq "Flare Dancer Laugh")      { return @("39", "81") }
    elseif ($SFX -eq "Flare Dancer Startled")   { return @("39", "8B") }     elseif ($SFX -eq 'Ganondorf "Teh!"')        { return @("39", "CA") }     elseif ($SFX -eq "Gohma Lava Croak")        { return @("39", "5D") }
    elseif ($SFX -eq "Gold Skull Token")        { return @("48", "43") }     elseif ($SFX -eq "Goron Wake")              { return @("38", "FC") }     elseif ($SFX -eq "Great Fairy")             { return @("68", "58") }
    elseif ($SFX -eq "Guay")                    { return @("38", "B6") }     elseif ($SFX -eq "Gunshot")                 { return @("48", "35") }     elseif ($SFX -eq "Hammer Bonk")             { return @("18", "0A") }
    elseif ($SFX -eq "Horse Neigh")             { return @("28", "05") }     elseif ($SFX -eq "Horse Trot")              { return @("28", "04") }     elseif ($SFX -eq "Hover Boots")             { return @("08", "C9") }
    elseif ($SFX -eq "HP Low")                  { return @("48", "1B") }     elseif ($SFX -eq "HP Recover")              { return @("48", "0B") }     elseif ($SFX -eq "Ice Shattering")          { return @("08", "75") }
    elseif ($SFX -eq "Ingo Wooah")              { return @("68", "54") }     elseif ($SFX -eq "Ingo Kaah!")              { return @("68", "55") }     elseif ($SFX -eq "Iron Boots")              { return @("08", "0D") }
    elseif ($SFX -eq "Iron Knuckle")            { return @("39", "29") }     elseif ($SFX -eq "Moblin Club Ground")      { return @("38", "E1") }     elseif ($SFX -eq "Moblin Club Swing")       { return @("39", "EF") }
    elseif ($SFX -eq "Moo")                     { return @("28", "DF") }     elseif ($SFX -eq "Mweep!")                  { return @("68", "7A") }     elseif ($SFX -eq 'Navi "Hello!"')           { return @("68", "44") }
    elseif ($SFX -eq 'Navi "Hey!"')             { return @("68", "5F") }     elseif ($SFX -eq "Navi Random")             { return @("68", "43") }     elseif ($SFX -eq "Notification")            { return @("48", "20") }
    elseif ($SFX -eq "Phantom Ganon Laugh")     { return @("38", "B0") }     elseif ($SFX -eq "Plant Explode")           { return @("28", "4E") }     elseif ($SFX -eq "Poe")                     { return @("38", "EC") }
    elseif ($SFX -eq "Pot Shattering")          { return @("28", "87") }     elseif ($SFX -eq "Redead Moan")             { return @("38", "E4") }     elseif ($SFX -eq "Redead Screan")           { return @("38", "E5") }
    elseif ($SFX -eq "Ribbit")                  { return @("28", "B1") }     elseif ($SFX -eq "Rupee")                   { return @("48", "03") }     elseif ($SFX -eq "Rupee (Silver)")          { return @("28", "E8") }
    elseif ($SFX -eq "Ruto Crash")              { return @("68", "60") }     elseif ($SFX -eq "Ruto Excited")            { return @("68", "61") }     elseif ($SFX -eq "Ruto Giggle")             { return @("68", "63") }
    elseif ($SFX -eq "Ruto Lift")               { return @("68", "74") }     elseif ($SFX -eq "Ruto Thrown")             { return @("68", "65") }     elseif ($SFX -eq "Ruto Wiggle")             { return @("68", "66") }
    elseif ($SFX -eq "Scrub Emerge")            { return @("38", "7C") }     elseif ($SFX -eq "Shabom Bounce")           { return @("39", "48") }     elseif ($SFX -eq "Shabom Pop")              { return @("39", "49") }
    elseif ($SFX -eq "Shellblade")              { return @("38", "49") }     elseif ($SFX -eq "Skultula")                { return @("39", "DA") }     elseif ($SFX -eq "Soft Beep")               { return @("48", "04") }
    elseif ($SFX -eq "Spike Trap")              { return @("38", "E9") }     elseif ($SFX -eq "Spit Nut")                { return @("38", "7E") }     elseif ($SFX -eq "Stalchild Attack")        { return @("38", "31") }
    elseif ($SFX -eq "Stinger Squeak")          { return @("39", "A3") }     elseif ($SFX -eq "Switch")                  { return @("28", "15") }     elseif ($SFX -eq "Sword Bonk")              { return @("18", "1A") }
    elseif ($SFX -eq "Talon Cry")               { return @("68", "53") }     elseif ($SFX -eq 'Talon "Hmm"')             { return @("68", "52") }     elseif ($SFX -eq "Talon Snore")             { return @("68", "50") }
    elseif ($SFX -eq "Talon WTF")               { return @("68", "51") }     elseif ($SFX -eq "Tambourine")              { return @("48", "42") }     elseif ($SFX -eq "Target Enemy")            { return @("48", "30") }
    elseif ($SFX -eq "Target Neutral")          { return @("48", "0C") }     elseif ($SFX -eq "Thunder")                 { return @("28", "2E") }     elseif ($SFX -eq "Timer")                   { return @("48", "1A") }
    elseif ($SFX -eq "Twinrova Bicker")         { return @("39", "E7") }     elseif ($SFX -eq "Wolfos Howl")             { return @("38", "3C") }     elseif ($SFX -eq "Zelda Gasp (Adult)")      { return @("68", "79") }
    else {
        WriteToConsole ("Could not find sound ID for: " + $SFX)
        return -1
    }

}



#==============================================================================================================================================================================================
function GetItemID([String]$Item) {
    
    $Item = $Item.replace(' (default)', "")
    if     ($Item -eq "None" -or $Item -eq "Disabled")       { return "FF" }
    elseif ($Item -eq "Ocarina of Time")   { return "00" }   elseif ($Item -eq "Deku Mask")             { return "32" }   elseif ($Item -eq "Goron Mask")   { return "33" }
    elseif ($Item -eq "Zora Mask")         { return "34" }   elseif ($Item -eq "Fierce Deity's Mask")   { return "35" }
    else {
        WriteToConsole ("Could not find item ID for : " + $Item)
        return -1
    }

}



#==============================================================================================================================================================================================
function ShowModelPreview([Object]$Dropdown, [Object]$Box, [String]$Category) {
    
    $Path = $GameFiles.previews + "\" + $Category + "\"
    $Text = $Dropdown.Text.replace(" (default)", "")
    
    if (TestFile ($Path + $Text + ".png"))   { SetBitMap -Path ($Path + $Text + ".png") -Box $Box }
    else                                     { $Box.Image = $null }

    if (IsSet $Files.json.models) {
        $global:ModelCredits = $null
        for ($i=0; $i -lt $Files.json.models.length; $i++) {
            if ($Files.json.models[$i].name -eq $Text) {
                $global:ModelCredits = $Files.json.models[$i]
                break
            }
        }

        $Credits = ""

        if (IsChecked $Redux.Graphics.MMChildLink) { $Credits += "--- Majora's Mask ---{0}Child model made by:{0}Nintendo{0}{0}Child model ported by:{0}The3DDude{0}" }
        if ( (IsChecked $Redux.Graphics.MMChildLink) -and (IsSet $ModelCredits.name) ) { $Credits += "{0}" }

        if (IsSet $ModelCredits.name) { $Credits += "--- " + $ModelCredits.name + " ---{0}" }
        if (IsSet $ModelCredits.author) {
            $Credits += "Models made by:{0}" + $ModelCredits.author + "{0}"
            if (IsSet $ModelCredits.porter) { $Credits += "{0}Models ported by:{0}" + $ModelCredits.porter + "{0}" }
        }

        if ( (IsSet $ModelCredits.child_author) -and !(IsSet $ModelCredits.author) -and !(IsChecked $Redux.Graphics.MMChildLink -Not) ) {
            $Credits += "Child model made by:{0}" + $ModelCredits.child_author + "{0}"
            if ( (IsSet $ModelCredits.child_porter) -and !(IsSet $ModelCredits.porter) ) { $Credits += "{0}Child model ported by:{0}" + $ModelCredits.child_porter + "{0}" }

            if (IsSet $ModelCredits.adult_author) { $Credits += "{0}" }
        }

        if ( (IsSet $ModelCredits.adult_author) -and !(IsSet $ModelCredits.author) ) {
            $Credits += "Adult model made by:{0}" + $ModelCredits.adult_author + "{0}"
            if ( (IsSet $ModelCredits.adult_porter) -and !(IsSet $ModelCredits.porter) ) { $Credits += "{0}Adult model ported by:{0}" + $ModelCredits.adult_porter + "{0}" }
        }

        if ( (IsSet $ModelCredits.author) -or ( (IsSet $ModelCredits.adult_author) -and (IsChecked $Redux.Graphics.MMChildLink) ) -or ( (IsSet $ModelCredits.child_author) -and (IsSet $ModelCredits.adult_author) ) ) {
            $Credits += "{0}- Child and Adult Combo"
        }
        elseif ( ( (IsSet $ModelCredits.child_author) -or (IsChecked $Redux.Graphics.MMChildLink) ) -and !(IsSet $ModelCredits.author) )   { $Credits += "{0}- Child only" }
        elseif ( (IsSet $ModelCredits.adult_author) -and !(IsSet $ModelCredits.author) )   { $Credits += "{0}- Adult only" }

        if (IsSet $ModelCredits.url) { $Credits += "{0}{0}Click to visit the modder's homepage" }

        if (IsSet $Credits)   { $PreviewToolTip.SetToolTip($Box, ([String]::Format($Credits, [Environment]::NewLine))) }
        else                  { $PreviewToolTip.RemoveAll() }
    }

}



#==============================================================================================================================================================================================
function ShowOriginalModelPreview([Object]$Box) {
    
    $global:ModelCredits = $null
    if (TestFile ($GameFiles.previews + "\Original.png"))   { SetBitMap -Path ($GameFiles.previews + "\Original.png") -Box $Box }
    else                                                    { $Box.Image = $null }
    $PreviewToolTip.SetToolTip($Redux.Graphics.ModelsPreview, ([String]::Format("Original models by: Nintendo", [Environment]::NewLine)))

}



#==============================================================================================================================================================================================
function LoadModelsList([String]$Category) {

    $path = $GameFiles.previews + "\" + $Category + "\"
    if (!(Test-Path -LiteralPath $path)) { return @("No models found?") } 

    $list = @()
    foreach ($file in Get-ChildItem -LiteralPath $path -Force) {
        if ($file.Extension -eq ".png") { $list += $file.BaseName }
    }

    return $list

}



#==============================================================================================================================================================================================
function ChangeModelsDropdown($Dropdown) {
    
    $Redux.Graphics.LinkModels.Visible     = ($Redux.Graphics.OriginalModels.Checked  -and !$Redux.Graphics.MMChildLink.Checked) -or ($Redux.Graphics.ListLinkModels.Checked -and !$Redux.Graphics.MMChildLink.Checked)
    $Redux.Graphics.LinkModels.Enabled     = $Redux.Graphics.ListLinkModels.Checked -and !$Redux.Graphics.MMChildLink.Checked
    $Redux.Graphics.LinkModelsPlus.Visible = ($Redux.Graphics.OriginalModels.Checked  -and $Redux.Graphics.MMChildLink.Checked)  -or ($Redux.Graphics.ListLinkModels.Checked -and $Redux.Graphics.MMChildLink.Checked)
    $Redux.Graphics.LinkModelsPlus.Enabled = $Redux.Graphics.ListLinkModels.Checked -and $Redux.Graphics.MMChildLink.Checked
    $Redux.Graphics.MaleModels.Visible     = $Redux.Graphics.MaleModels.Enabled = $Redux.Graphics.ListMaleModels.Checked
    $Redux.Graphics.FemaleModels.Visible   = $Redux.Graphics.FemaleModels.Enabled = $Redux.Graphics.ListFemaleModels.Checked

    $Redux.Graphics.MMChildLink.Enabled    = $Redux.Graphics.ListLinkModels.Checked

}



#==============================================================================================================================================================================================
function ChangeModelsSelection() {
    
    # Events
    $Redux.Graphics.OriginalModels.Add_CheckedChanged({
        ChangeModelsDropdown
        ShowOriginalModelPreview $Redux.Graphics.ModelsPreview
    })

    $Redux.Graphics.ListLinkModels.Add_CheckedChanged({
        ChangeModelsDropdown
        if     (IsChecked -Elem $Redux.Graphics.MMChildLink)        { ShowModelPreview -Dropdown $Redux.Graphics.LinkModelsPlus -Box $Redux.Graphics.ModelsPreview -Category "Link+" }
        elseif (IsChecked -Elem $Redux.Graphics.MMChildLink -Not)   { ShowModelPreview -Dropdown $Redux.Graphics.LinkModels     -Box $Redux.Graphics.ModelsPreview -Category "Link" }
    })

    $Redux.Graphics.ListMaleModels.Add_CheckedChanged({
        ChangeModelsDropdown
        ShowModelPreview -Dropdown $Redux.Graphics.MaleModels -Box $Redux.Graphics.ModelsPreview -Category "\Male\"
    })

    $Redux.Graphics.ListFemaleModels.Add_CheckedChanged({
        ChangeModelsDropdown
        ShowModelPreview -Dropdown $Redux.Graphics.FemaleModels -Box $Redux.Graphics.ModelsPreview -Category "\Female\"
    })

    $Redux.Graphics.LinkModels.Add_SelectedIndexChanged({
        if (IsChecked -Elem $Redux.Graphics.ListLinkModels)     { ShowModelPreview -Dropdown $Redux.Graphics.LinkModels -Box $Redux.Graphics.ModelsPreview -Category "Link" }
    })
    $Redux.Graphics.LinkModelsPlus.Add_SelectedIndexChanged({
        if (IsChecked -Elem $Redux.Graphics.ListLinkModels)     { ShowModelPreview -Dropdown $Redux.Graphics.LinkModelsPlus -Box $Redux.Graphics.ModelsPreview -Category "Link+" }
    })
    $Redux.Graphics.MaleModels.Add_SelectedIndexChanged({
        if (IsChecked -Elem $Redux.Graphics.ListMaleModels)     { ShowModelPreview -Dropdown $Redux.Graphics.MaleModels -Box $Redux.Graphics.ModelsPreview -Category "Male" }
    })
    $Redux.Graphics.FemaleModels.Add_SelectedIndexChanged({
        if (IsChecked -Elem $Redux.Graphics.ListFemaleModels)   { ShowModelPreview -Dropdown $Redux.Graphics.FemaleModels -Box $Redux.Graphics.ModelsPreview -Category "Female" }
    })

    $Redux.Graphics.MMChildLink.Add_CheckStateChanged({
        ChangeModelsDropdown
        if     ( (IsChecked -Elem $Redux.Graphics.ListLinkModels) -and (IsChecked -Elem $Redux.Graphics.MMChildLink) )        { ShowModelPreview -Dropdown $Redux.Graphics.LinkModelsPlus -Box $Redux.Graphics.ModelsPreview -Category "Link+" }
        elseif ( (IsChecked -Elem $Redux.Graphics.ListLinkModels) -and (IsChecked -Elem $Redux.Graphics.MMChildLink -Not) )   { ShowModelPreview -Dropdown $Redux.Graphics.LinkModels -Box $Redux.Graphics.ModelsPreview -Category "Link" }
    })



    # Initial Run
    ChangeModelsDropdown

    if ($Redux.Graphics.OriginalModels.Checked) { ShowOriginalModelPreview $Redux.Graphics.ModelsPreview }
    elseif ( (IsChecked -Elem $Redux.Graphics.ListLinkModels) -and (IsChecked -Elem $Redux.Graphics.MMChildLink) )        { ShowModelPreview -Dropdown $Redux.Graphics.LinkModelsPlus -Box $Redux.Graphics.ModelsPreview -Category "Link+" }
    elseif ( (IsChecked -Elem $Redux.Graphics.ListLinkModels) -and (IsChecked -Elem $Redux.Graphics.MMChildLink -Not) )   { ShowModelPreview -Dropdown $Redux.Graphics.LinkModels -Box $Redux.Graphics.ModelsPreview -Category "Link" }
    elseif (IsChecked -Elem $Redux.Graphics.ListMaleModels)     { ShowModelPreview -Dropdown $Redux.Graphics.MaleModels   -Box $Redux.Graphics.ModelsPreview -Category "Male" }
    elseif (IsChecked -Elem $Redux.Graphics.ListFemaleModels)   { ShowModelPreview -Dropdown $Redux.Graphics.FemaleModels -Box $Redux.Graphics.ModelsPreview -Category "Female" }



    # URL
    $Redux.Graphics.ModelsPreview.add_Click({
        if (IsSet $ModelCredits.url) {
            [system.Diagnostics.Process]::start($ModelCredits.url)
        }
    })

}



#==============================================================================================================================================================================================
function GetInstrumentID([String]$SFX) {
    
    $SFX = $SFX.replace(' (default)', "")
    if     ($SFX -eq "Ocarina")             { return "34" }   elseif ($SFX -eq "Deku Pipes")     { return "5E" }   elseif ($SFX -eq "Goron Drums")       { return "5C" }
    elseif ($SFX -eq "Zora Guitar")         { return "5D" }   elseif ($SFX -eq "Female Voice")   { return "55" }   elseif ($SFX -eq "Bell")              { return "57" }
    elseif ($SFX -eq "Piano")               { return "73" }   elseif ($SFX -eq "Harp")           { return "59" }   elseif ($SFX -eq "Accordion")         { return "53" }
    elseif ($SFX -eq "Cathedral Bell")      { return "64" }   elseif ($SFX -eq "Choir")          { return "2E" }   elseif ($SFX -eq "Dodongo")           { return "51" }
    elseif ($SFX -eq "Eagle Seagull")       { return "65" }   elseif ($SFX -eq "Flute")          { return "77" }   elseif ($SFX -eq "Frog Croak")        { return "5F" }
    elseif ($SFX -eq "Giants Singing")      { return "72" }   elseif ($SFX -eq "Gong")           { return "75" }   elseif ($SFX -eq "Ikana King")        { return "78" }
    elseif ($SFX -eq "Soft Harp")           { return "54" }   elseif ($SFX -eq "Tatl")           { return "56" }   elseif ($SFX -eq "Whistling Flute")   { return "52" }
    elseif ($SFX -eq "Arguing")             { return "4F" }   elseif ($SFX -eq "Bass Guitar")    { return "74" }   elseif ($SFX -eq "Beaver")            { return "61" }
    elseif ($SFX -eq "Elder Goron Drums")   { return "71" }
    else {
        WriteToConsole ("Could not find SFX ID for : " + $Item)
        return -1
    }

}



#==============================================================================================================================================================================================
function CreateButtonColorOptions($Default=1) {
    
    # BUTTON COLORS #
    CreateReduxGroup    -Tag  "Colors"  -Height 2 -Text "Button Colors"
    CreateReduxComboBox -Name "Buttons" -Text "Button Colors:" -Items @("N64 OoT", "N64 MM", "GC OoT", "GC MM", "Randomized", "Custom") -Default $Default -Info ("Select a preset for the button colors`n" + '"Randomized" fully randomizes the colors each time the patcher is opened') -Credits "GhostlyDark (ported from Redux)"

    # Button Colors - Buttons
    $Buttons = @()
    $Buttons += CreateReduxButton -Column 1 -Row 2 -Width 100 -Tag $Buttons.Count -Text "A Button"     -Info "Select the color you want for the A button"     -Credits "GhostlyDark (ported from Redux)"
    $Buttons += CreateReduxButton -Column 2 -Row 2 -Width 100 -Tag $Buttons.Count -Text "B Button"     -Info "Select the color you want for the B button"     -Credits "GhostlyDark (ported from Redux)"
    $Buttons += CreateReduxButton -Column 3 -Row 2 -Width 100 -Tag $Buttons.Count -Text "C Buttons"    -Info "Select the color you want for the C buttons"    -Credits "GhostlyDark (ported from Redux)"
    $Buttons += CreateReduxButton -Column 4 -Row 2 -Width 100 -Tag $Buttons.Count -Text "Start Button" -Info "Select the color you want for the Start button" -Credits "GhostlyDark (ported from Redux)"

    # Button Colors - Dialogs
    $Redux.Colors.SetButtons = @()
    $Redux.Colors.SetButtons += CreateColorDialog -Color "5A5AFF" -Name "SetAButton"  -IsGame
    $Redux.Colors.SetButtons += CreateColorDialog -Color "009600" -Name "SetBButton"  -IsGame
    $Redux.Colors.SetButtons += CreateColorDialog -Color "FFA000" -Name "SetCButtons" -IsGame
    $Redux.Colors.SetButtons += CreateColorDialog -Color "C80000" -Name "SetSButton"  -IsGame

    # Button Colors - Labels
    $Redux.Colors.ButtonLabels = @()
    for ($i=0; $i -lt $Buttons.length; $i++) {
        $Buttons[$i].Add_Click({ $Redux.Colors.SetButtons[[int]$this.Tag].ShowDialog(); $Redux.Colors.Buttons.Text = "Custom"; $Redux.Colors.ButtonLabels[[int]$this.Tag].BackColor = $Redux.Colors.SetButtons[[int]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetButtons[[int]$this.Tag].Tag] = $Redux.Colors.SetButtons[[int]$this.Tag].Color.Name })
        $Redux.Colors.ButtonLabels += CreateReduxColoredLabel -Link $Buttons[$i]  -Color $Redux.Colors.SetButtons[$i].Color
    }
    
    $Redux.Colors.Buttons.Add_SelectedIndexChanged({ SetButtonColorsPreset -ComboBox $Redux.Colors.Buttons })
    SetButtonColorsPreset -ComboBox $Redux.Colors.Buttons

}



#==============================================================================================================================================================================================
function CreateSpinAttackColorOptions() {
    
    # SPIN ATTACK COLORS #
    CreateReduxGroup    -Tag  "Colors" -Text "Magic Spin Attack Colors" -Height 2
    $Items = @("Blue", "Red", "Green", "White", "Cyan", "Magenta", "Orange", "Gold", "Purple", "Pink", "Black", "Randomized", "Custom")
    CreateReduxComboBox -Name "BlueSpinAttack" -Column 1 -Text "Blue Spin Attack Colors:" -Length 230 -Shift 70 -Items $Items -Default 1 -Info ("Select a preset for the blue spin attack colors`n" + '"Randomized" fully randomizes the colors each time the patcher is opened') -Credits "Chez Cousteau"
    CreateReduxComboBox -Name "RedSpinAttack"  -Column 4 -Text "Red Spin Attack Colors:"  -Length 230 -Shift 70 -Items $Items -Default 2 -Info ("Select a preset for the red spin attack colors`n" + '"Randomized" fully randomizes the colors each time the patcher is opened')  -Credits "Chez Cousteau"

    # Spin Attack Colors - Buttons
    $Buttons = @()
    $Buttons += CreateReduxButton -Column 3 -Row 1 -Width 100 -Tag $Buttons.Count -Text "Blue Spin (Inner)" -Info "Select the inner color you want for the blue spin attack" -Credits "Chez Cousteau"
    $Buttons += CreateReduxButton -Column 3 -Row 2 -Width 100 -Tag $Buttons.Count -Text "Blue Spin (Outer)" -Info "Select the outer color you want for the blue spin attack" -Credits "Chez Cousteau"
    $Buttons += CreateReduxButton -Column 6 -Row 1 -Width 100 -Tag $Buttons.Count -Text "Red Spin (Inner)"  -Info "Select the inner color you want for the red spin attack"  -Credits "Chez Cousteau"
    $Buttons += CreateReduxButton -Column 6 -Row 2 -Width 100 -Tag $Buttons.Count -Text "Red Spin (Outer)"  -Info "Select the outer color you want for the red spin attack"  -Credits "Chez Cousteau"

    # Spin Attack Colors - Dialogs
    $Redux.Colors.SetSpinAttack = @()
    $Redux.Colors.SetSpinAttack += CreateColorDialog -Color "0000FF" -Name "SetInnerBlueSpinAttack" -IsGame
    $Redux.Colors.SetSpinAttack += CreateColorDialog -Color "0064FF" -Name "SetOuterBlueSpinAttack" -IsGame
    $Redux.Colors.SetSpinAttack += CreateColorDialog -Color "FF0000" -Name "SetInnerRedSpinAttack"  -IsGame
    $Redux.Colors.SetSpinAttack += CreateColorDialog -Color "FF6400" -Name "SetOuterRedSpinAttack"  -IsGame

    # Spin Attack Colors - Labels
    $Redux.Colors.SpinAttackLabels = @()
    for ($i=0; $i -lt $Buttons.length; $i++) {
        $Buttons[$i].Add_Click({
            $Redux.Colors.SetSpinAttack[[int]$this.Tag].ShowDialog(); $Redux.Colors.SpinAttackLabels[[int]$this.Tag].BackColor = $Redux.Colors.SetSpinAttack[[int]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetSpinAttack[[int]$this.Tag].Tag] = $Redux.Colors.SetSpinAttack[[int]$this.Tag].Color.Name
            if ($this.Tag -lt 2)   { $Redux.Colors.BlueSpinAttack.Text = "Custom" }
            else                   { $Redux.Colors.RedSpinAttack.Text  = "Custom" }
        })
        $Redux.Colors.SpinAttackLabels += CreateReduxColoredLabel -Link $Buttons[$i]  -Color $Redux.Colors.SetSpinAttack[$i].Color
    }

    $Redux.Colors.BlueSpinAttack.Add_SelectedIndexChanged({ SetSpinAttackColorsPreset -ComboBox $Redux.Colors.BlueSpinAttack -Dialog $Redux.Colors.SetSpinAttack[0] -Label $Redux.Colors.SpinAttackLabels[0] })
    SetSpinAttackColorsPreset -ComboBox $Redux.Colors.BlueSpinAttack -Dialog $Redux.Colors.SetSpinAttack[0] -Label $Redux.Colors.SpinAttackLabels[0]
    $Redux.Colors.BlueSpinAttack.Add_SelectedIndexChanged({ SetSpinAttackColorsPreset -ComboBox $Redux.Colors.BlueSpinAttack -Dialog $Redux.Colors.SetSpinAttack[1] -Label $Redux.Colors.SpinAttackLabels[1] })
    SetSpinAttackColorsPreset -ComboBox $Redux.Colors.BlueSpinAttack -Dialog $Redux.Colors.SetSpinAttack[0] -Label $Redux.Colors.SpinAttackLabels[1]

    $Redux.Colors.RedSpinAttack.Add_SelectedIndexChanged({ SetSpinAttackColorsPreset -ComboBox $Redux.Colors.RedSpinAttack -Dialog $Redux.Colors.SetSpinAttack[2] -Label $Redux.Colors.SpinAttackLabels[2] })
    SetSpinAttackColorsPreset -ComboBox $Redux.Colors.RedSpinAttack -Dialog $Redux.Colors.SetSpinAttack[2] -Label $Redux.Colors.SpinAttackLabels[2]
    $Redux.Colors.RedSpinAttack.Add_SelectedIndexChanged({ SetSpinAttackColorsPreset -ComboBox $Redux.Colors.RedSpinAttack -Dialog $Redux.Colors.SetSpinAttack[3] -Label $Redux.Colors.SpinAttackLabels[3] })
    SetSpinAttackColorsPreset -ComboBox $Redux.Colors.RedSpinAttack -Dialog $Redux.Colors.SetSpinAttack[3] -Label $Redux.Colors.SpinAttackLabels[3]

}



#==============================================================================================================================================================================================
function CreateFairyColorOptions([String]$Name, [String]$Second, [String]$Presets="") {

    # FAIRY COLORS #
    CreateReduxGroup    -Tag  "Colors" -Text "Fairy Colors" -Height 2
    $Items = @($Name, $Second, "Tael", "Gold", "Green", "Light Blue", "Yellow", "Red", "Magenta", "Black", "Fi", "Ciela", "Epona", "Ezlo", "King of Red Lions", "Linebeck", "Loftwing", "Midna", "Phantom Zelda", "Randomized", "Custom")
    CreateReduxComboBox -Name "Fairy" -Length 230 -Shift 70 -Items $Items -Text ($name + " Colors:") -Info ("Select a color scheme for " + $name + $Presets + "`n" + '"Randomized" fully randomizes the colors each time the patcher is opened') -Credits "Ported from Rando"

    # Fairy Colors - Buttons
    $Buttons = @()
    $Buttons += CreateReduxButton -Column 3 -Row 1 -Width 100 -Tag $Buttons.Count -Text "Idle (Inner)"     -Info ("Select the color you want for the Inner Idle stance for " + $name)  -Credits "Ported from Rando"
    $Buttons += CreateReduxButton -Column 3 -Row 2 -Width 100 -Tag $Buttons.Count -Text "Idle (Outer)"     -Info ("Select the color you want for the Outer Idle stance for " + $name)  -Credits "Ported from Rando"

    $Buttons += CreateReduxButton -Column 4 -Row 1 -Width 100 -Tag $Buttons.Count -Text "Interact (Inner)" -Info ("Select the color you want for the Inner Other stance for " + $name) -Credits "Ported from Rando"
    $Buttons += CreateReduxButton -Column 4 -Row 2 -Width 100 -Tag $Buttons.Count -Text "Interact (Outer)" -Info ("Select the color you want for the Outer Other stance for " + $name) -Credits "Ported from Rando"

    $Buttons += CreateReduxButton -Column 5 -Row 1 -Width 100 -Tag $Buttons.Count -Text "NPC (Inner)"      -Info ("Select the color you want for the Inner NPC stance for " + $name)   -Credits "Ported from Rando"
    $Buttons += CreateReduxButton -Column 5 -Row 2 -Width 100 -Tag $Buttons.Count -Text "NPC (Outer)"      -Info ("Select the color you want for the Outer NPC stance for " + $name)   -Credits "Ported from Rando"

    $Buttons += CreateReduxButton -Column 6 -Row 1 -Width 100 -Tag $Buttons.Count -Text "Enemy (Inner)"    -Info ("Select the color you want for the Inner Enemy stance for " + $name) -Credits "Ported from Rando"
    $Buttons += CreateReduxButton -Column 6 -Row 2 -Width 100 -Tag $Buttons.Count -Text "Enemy (Outer)"    -Info ("Select the color you want for the Outer Enemy stance for " + $name) -Credits "Ported from Rando"

    # Fairy Colors - Info Label
    #CreateLabel -X ($Buttons[0].Left + 5) -Y ($Buttons[0].Top - 20) -Width 100 -Height 15 -Text "Inner " + $name + " Color" -Font $Fonts.SmallBold -AddTo $Last.Group
    #CreateLabel -X ($Buttons[1].Left + 5) -Y ($Buttons[0].Top - 20) -Width 100 -Height 15 -Text "Outer " + $name + " Color" -Font $Fonts.SmallBold -AddTo $Last.Group
    #CreateLabel -X ($Buttons[2].Left + 5) -Y ($Buttons[0].Top - 20) -Width 100 -Height 15 -Text "Inner " + $name + " Color" -Font $Fonts.SmallBold -AddTo $Last.Group
    #CreateLabel -X ($Buttons[3].Left + 5) -Y ($Buttons[0].Top - 20) -Width 100 -Height 15 -Text "Outer " + $name + " Color" -Font $Fonts.SmallBold -AddTo $Last.Group

    # Fairy Colors - Dialogs
    $Redux.Colors.SetFairy = @()
    $Redux.Colors.SetFairy += CreateColorDialog -Color "FFFFFF" -Name "SetFairyIdleInner"     -IsGame
    $Redux.Colors.SetFairy += CreateColorDialog -Color "0000FF" -Name "SetFairyIdleOuter"     -IsGame
    $Redux.Colors.SetFairy += CreateColorDialog -Color "FFFFFF" -Name "SetFairyInteractInner" -IsGame
    $Redux.Colors.SetFairy += CreateColorDialog -Color "0000FF" -Name "SetFairyInteractOuter" -IsGame
    $Redux.Colors.SetFairy += CreateColorDialog -Color "FFFFFF" -Name "SetFairyNPCInner"      -IsGame
    $Redux.Colors.SetFairy += CreateColorDialog -Color "0000FF" -Name "SetFairyNPCOuter"      -IsGame
    $Redux.Colors.SetFairy += CreateColorDialog -Color "FFFFFF" -Name "SetFairyEnemyInner"    -IsGame
    $Redux.Colors.SetFairy += CreateColorDialog -Color "0000FF" -Name "SetFairyEnemyOuter"    -IsGame

    # Fairy Colors - Labels
    $Redux.Colors.FairyLabels = @()
    for ($i=0; $i -lt $Buttons.length; $i++) {
        $Buttons[$i].Add_Click({ $Redux.Colors.SetFairy[[int]$this.Tag].ShowDialog(); $Redux.Colors.Fairy.Text = "Custom"; $Redux.Colors.FairyLabels[[int]$this.Tag].BackColor = $Redux.Colors.SetFairy[[int]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetFairy[[int]$this.Tag].Tag] = $Redux.Colors.SetFairy[[int]$this.Tag].Color.Name })
        $Redux.Colors.FairyLabels += CreateReduxColoredLabel -Link $Buttons[$i] -Color $Redux.Colors.SetFairy[$i].Color
    }

    $Redux.Colors.Fairy.Add_SelectedIndexChanged({ SetFairyColorsPreset -ComboBox $Redux.Colors.Fairy -Dialogs $Redux.Colors.SetFairy -Labels $Redux.Colors.FairyLabels })
    SetFairyColorsPreset -ComboBox $Redux.Colors.Fairy -Dialogs $Redux.Colors.SetFairy -Labels $Redux.Colors.FairyLabels

}



#==============================================================================================================================================================================================
function SetButtonColorsPreset([Object]$ComboBox) {
    
    $Text = $ComboBox.Text.replace(' (default)', "")
    if     ($Text -eq "N64 OoT")      { SetColors -Colors @("5A5AFF", "009600", "FFA000", "C80000") -Dialogs $Redux.Colors.SetButtons -Labels $Redux.Colors.ButtonLabels }
    elseif ($Text -eq "N64 MM")       { SetColors -Colors @("64C8FF", "64FF78", "FFF000", "FF823C") -Dialogs $Redux.Colors.SetButtons -Labels $Redux.Colors.ButtonLabels }
    elseif ($Text -eq "GC OoT")       { SetColors -Colors @("00C832", "FF1E1E", "FFA000", "787878") -Dialogs $Redux.Colors.SetButtons -Labels $Redux.Colors.ButtonLabels }
    elseif ($Text -eq "GC MM")        { SetColors -Colors @("64FF78", "FF6464", "FFF000", "787878") -Dialogs $Redux.Colors.SetButtons -Labels $Redux.Colors.ButtonLabels }
    elseif ($Text -eq "Randomized")   {
        $Colors = @()
        for ($i=0; $i -lt $Redux.Colors.SetButtons.length; $i++) {
            $Green = Get8Bit -Value (Get-Random -Maximum 255)
            $Red   = Get8Bit -Value (Get-Random -Maximum 255)
            $Blue  = Get8Bit -Value (Get-Random -Maximum 255)
            $Colors += $Green + $Red + $Blue
            SetColor -Color ($Green + $Red + $Blue) -Dialog $Redux.Colors.SetButtons[$i] -Label $Redux.Colors.ButtonLabels[$i]
        }
        if ($GameSettings.Debug.Console -eq $True) { Write-Host ("Randomize Button Colors: " + $Colors) }
    }

}



#==============================================================================================================================================================================================
function SetFairyColorsPreset([Object]$ComboBox, [Array]$Dialogs, [Array]$Labels) {
    
    $Text = $ComboBox.Text.replace(' (default)', "")
    if     ($Text -eq "Navi")                { SetFairyColors -Inner "FFFFFF" -Outer "0000FF" -Dialogs $Dialogs -Labels $Labels }
   #elseif ($Text -eq "Tatl")                { SetFairyColors -Inner "FFFFFF" -Outer "C89800" -Dialogs $Dialogs -Labels $Labels }
    elseif ($Text -eq "Tatl")                { SetFairyColors -Inner "FFFFE6" -Outer "DCA050" -Dialogs $Dialogs -Labels $Labels }
    elseif ($Text -eq "Tael")                { SetFairyColors -Inner "49146C" -Outer "FF0000" -Dialogs $Dialogs -Labels $Labels }
    elseif ($Text -eq "Gold")                { SetFairyColors -Inner "FECC3C" -Outer "FEC007" -Dialogs $Dialogs -Labels $Labels }
    elseif ($Text -eq "Green")               { SetFairyColors -Inner "00FF00" -Outer "00FF00" -Dialogs $Dialogs -Labels $Labels }
    elseif ($Text -eq "Light Blue")          { SetFairyColors -Inner "9696FF" -Outer "9696FF" -Dialogs $Dialogs -Labels $Labels }
    elseif ($Text -eq "Yellow")              { SetFairyColors -Inner "FFFF00" -Outer "C89B00" -Dialogs $Dialogs -Labels $Labels }
    elseif ($Text -eq "Red")                 { SetFairyColors -Inner "FF0000" -Outer "FF0000" -Dialogs $Dialogs -Labels $Labels }
    elseif ($Text -eq "Magenta")             { SetFairyColors -Inner "FF00FF" -Outer "C8009B" -Dialogs $Dialogs -Labels $Labels }
    elseif ($Text -eq "Black")               { SetFairyColors -Inner "000000" -Outer "000000" -Dialogs $Dialogs -Labels $Labels }
    elseif ($Text -eq "Fi")                  { SetFairyColors -Inner "2C9EC4" -Outer "2C1983" -Dialogs $Dialogs -Labels $Labels }
    elseif ($Text -eq "Ciela")               { SetFairyColors -Inner "E6DE83" -Outer "C6BE5B" -Dialogs $Dialogs -Labels $Labels }
    elseif ($Text -eq "Epona")               { SetFairyColors -Inner "D14902" -Outer "551F08" -Dialogs $Dialogs -Labels $Labels }
    elseif ($Text -eq "Ezlo")                { SetFairyColors -Inner "629C5F" -Outer "3F5D37" -Dialogs $Dialogs -Labels $Labels }
    elseif ($Text -eq "King of Red Lions")   { SetFairyColors -Inner "A83317" -Outer "DED7C5" -Dialogs $Dialogs -Labels $Labels }
    elseif ($Text -eq "Linebeck")            { SetFairyColors -Inner "032660" -Outer "EFFFFF" -Dialogs $Dialogs -Labels $Labels }
    elseif ($Text -eq "Loftwing")            { SetFairyColors -Inner "D62E31" -Outer "FDE6CC" -Dialogs $Dialogs -Labels $Labels }
    elseif ($Text -eq "Midna")               { SetFairyColors -Inner "192426" -Outer "D28330" -Dialogs $Dialogs -Labels $Labels }
    elseif ($Text -eq "Phantom Zelda")       { SetFairyColors -Inner "977A6C" -Outer "6F4667" -Dialogs $Dialogs -Labels $Labels }
    elseif ($Text -eq "Randomized") {
        $Colors = @()
        for ($i=0; $i -lt $Dialogs.length; $i++) {
            $Green = Get8Bit -Value (Get-Random -Maximum 255)
            $Red   = Get8Bit -Value (Get-Random -Maximum 255)
            $Blue  = Get8Bit -Value (Get-Random -Maximum 255)
            $Colors += $Green + $Red + $Blue
            SetColor -Color ($Green + $Red + $Blue) -Dialog $Dialogs[$i] -Label $Labels[$i]
        }
        WriteToConsole ("Randomize Navi Colors: " + $Colors)
    }

}



#==============================================================================================================================================================================================
function SetFairyColors([String]$Inner, [String]$Outer, [Array]$Dialogs, [Array]$Labels) {
    
    $GameSettings["Colors"][$Dialogs[0].Tag] = $Inner;   $Labels[0].BackColor = $Dialogs[0].Color = "#" + $Inner
    $GameSettings["Colors"][$Dialogs[1].Tag] = $Outer;   $Labels[1].BackColor = $Dialogs[1].Color = "#" + $Outer
    $GameSettings["Colors"][$Dialogs[2].Tag] = "00FF00"; $Labels[2].BackColor = $Dialogs[2].Color = "#00FF00"
    $GameSettings["Colors"][$Dialogs[3].Tag] = "00FF00"; $Labels[3].BackColor = $Dialogs[3].Color = "#00FF00"
    $GameSettings["Colors"][$Dialogs[4].Tag] = "9696FF"; $Labels[4].BackColor = $Dialogs[4].Color = "#9696FF"
    $GameSettings["Colors"][$Dialogs[5].Tag] = "9696FF"; $Labels[5].BackColor = $Dialogs[5].Color = "#9696FF"
    $GameSettings["Colors"][$Dialogs[6].Tag] = "FFFF00"; $Labels[6].BackColor = $Dialogs[6].Color = "#FFFF00"
    $GameSettings["Colors"][$Dialogs[7].Tag] = "C89B00"; $Labels[7].BackColor = $Dialogs[7].Color = "#C89B00"

}


#==============================================================================================================================================================================================
function SetTunicColorsPreset([Object]$ComboBox, [Object]$Dialog, [Object]$Label) {
    
    $Text = $ComboBox.Text.replace(' (default)', "")
    if     ($Text -eq "Kokiri Green")    { SetColor -Color "1E691B" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Goron Red")       { SetColor -Color "641400" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Zora Blue")       { SetColor -Color "003C64" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Black")           { SetColor -Color "303030" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "White")           { SetColor -Color "F0F0FF" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Azure Blue")      { SetColor -Color "139ED8" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Vivid Cyan")      { SetColor -Color "13E9D8" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Light Red")       { SetColor -Color "F87C6D" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Fuchsia")         { SetColor -Color "FF00FF" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Purple")          { SetColor -Color "953080" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Majora Purple")   { SetColor -Color "400040" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Twitch Purple")   { SetColor -Color "6441A5" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Purple Heart")    { SetColor -Color "8A2BE2" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Persian Rose")    { SetColor -Color "FF1493" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Dirty Yellow")    { SetColor -Color "E0D860" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Blush Pink")      { SetColor -Color "F86CF8" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Hot Pink")        { SetColor -Color "FF69B4" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Rose Pink")       { SetColor -Color "FF90B3" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Orange")          { SetColor -Color "E07940" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Gray")            { SetColor -Color "A0A0B0" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Gold")            { SetColor -Color "D8B060" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Silver")          { SetColor -Color "D0F0FF" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Beige")           { SetColor -Color "C0A0A0" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Teal")            { SetColor -Color "30D0B0" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Blood Red")       { SetColor -Color "830303" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Blood Orange")    { SetColor -Color "FE4B03" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Royal Blue")      { SetColor -Color "400090" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Sonic Blue")      { SetColor -Color "5090E0" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "NES Green")       { SetColor -Color "00D000" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Dark Green")      { SetColor -Color "002518" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Lumen")           { SetColor -Color "508CF0" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Randomized") {
        $Green = Get8Bit -Value (Get-Random -Maximum 255)
        $Red   = Get8Bit -Value (Get-Random -Maximum 255)
        $Blue  = Get8Bit -Value (Get-Random -Maximum 255)
        WriteToConsole ("Randomize Tunic Color: " + ($Green + $Red + $Blue))
        SetColor -Color ($Green + $Red + $Blue) -Dialog $Dialog -Label $Label
    }

}



#==============================================================================================================================================================================================
function SetGauntletsColorsPreset([Object]$ComboBox, [Object]$Dialog, [Object]$Label) {
    
    $Text = $ComboBox.Text.replace(' (default)', "")
    if     ($Text -eq "Silver")     { SetColor -Color "FFFFFF" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Gold")       { SetColor -Color "FECF0F" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Black")      { SetColor -Color "000006" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Green")      { SetColor -Color "025918" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Blue")       { SetColor -Color "06025A" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Bronze")     { SetColor -Color "600602" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Red")        { SetColor -Color "FF0000" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Sky Blue")   { SetColor -Color "025DB0" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Pink")       { SetColor -Color "FA6A90" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Magenta")    { SetColor -Color "FF00FF" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Orange")     { SetColor -Color "DA3800" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Lime")       { SetColor -Color "5BA806" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Purple")     { SetColor -Color "800080" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Randomized") {
        $Green = Get8Bit -Value (Get-Random -Maximum 255)
        $Red   = Get8Bit -Value (Get-Random -Maximum 255)
        $Blue  = Get8Bit -Value (Get-Random -Maximum 255)
        WriteToConsole ("Randomize Gauntlets Color: " + ($Green + $Red + $Blue))
        SetColor -Color ($Green + $Red + $Blue) -Dialog $Dialog -Label $Label
    }

}


#==============================================================================================================================================================================================
function SetMirrorShieldFrameColorsPreset([Object]$ComboBox, [Object]$Dialog, [Object]$Label) {
    
    $Text = $ComboBox.Text.replace(' (default)', "")
    if     ($Text -eq "Red")        { SetColor -Color "D70000" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Green")      { SetColor -Color "00FF00" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Blue")       { SetColor -Color "0040D8" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Yellow")     { SetColor -Color "FFFF64" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Cyan")       { SetColor -Color "00FFFF" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Magenta")    { SetColor -Color "FF00FF" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Orange")     { SetColor -Color "FFA500" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Gold")       { SetColor -Color "FFD700" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Purple")     { SetColor -Color "800080" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Pink")       { SetColor -Color "FF69B4" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Randomized") {
        $Green = Get8Bit -Value (Get-Random -Maximum 255)
        $Red   = Get8Bit -Value (Get-Random -Maximum 255)
        $Blue  = Get8Bit -Value (Get-Random -Maximum 255)
        WriteToConsole ("Randomize Mirror Shield Frame Color: " + ($Green + $Red + $Blue))
        SetColor -Color ($Green + $Red + $Blue) -Dialog $Dialog -Label $Label
    }

}



#==============================================================================================================================================================================================
function SetHeartsColorsPreset([Object]$ComboBox, [Object]$Dialog, [Object]$Label) {
    
    $Text = $ComboBox.Text.replace(' (default)', "")
    if     ($Text -eq "Red")        { SetColor -Color "FF4632" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Green")      { SetColor -Color "46C832" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Blue")       { SetColor -Color "3246FF" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Yellow")     { SetColor -Color "FFE000" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Randomized") {
        $Green = Get8Bit -Value (Get-Random -Maximum 255)
        $Red   = Get8Bit -Value (Get-Random -Maximum 255)
        $Blue  = Get8Bit -Value (Get-Random -Maximum 255)
        WriteToConsole ("Randomize Hearts Color: " + ($Green + $Red + $Blue))
        SetColor -Color ($Green + $Red + $Blue) -Dialog $Dialog -Label $Label
    }

}



#==============================================================================================================================================================================================
function SetMagicColorsPreset([Object]$ComboBox, [Object]$Dialog, [Object]$Label) {
    
    $Text = $ComboBox.Text.replace(' (default)', "")
    if     ($Text -eq "Green")      { SetColor -Color "00C800" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Red")        { SetColor -Color "C80000" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Blue")       { SetColor -Color "0030FF" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Purple")     { SetColor -Color "B000FF" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Pink")       { SetColor -Color "FF00C8" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Yellow")     { SetColor -Color "FFFF00" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "White")      { SetColor -Color "FFFFFF" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Randomized") {
        $Green = Get8Bit -Value (Get-Random -Maximum 255)
        $Red   = Get8Bit -Value (Get-Random -Maximum 255)
        $Blue  = Get8Bit -Value (Get-Random -Maximum 255)
        WriteToConsole ("Randomize Magic Color: " + ($Green + $Red + $Blue))
        SetColor -Color ($Green + $Red + $Blue) -Dialog $Dialog -Label $Label
    }

}



#==============================================================================================================================================================================================
function SetMinimapColorsPreset([Object]$ComboBox, [Object]$Dialog, [Object]$Label) {
    
    $Text = $ComboBox.Text.replace(' (default)', "")
    if     ($Text -eq "Cyan")       { SetColor -Color "00FFFF" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Green")      { SetColor -Color "00FF00" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Red")        { SetColor -Color "FF0000" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Blue")       { SetColor -Color "0000FF" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Gray")       { SetColor -Color "808080" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Purple")     { SetColor -Color "B000FF" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Pink")       { SetColor -Color "FF00C8" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Yellow")     { SetColor -Color "FFFF00" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "White")      { SetColor -Color "FFFFFF" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Black")      { SetColor -Color "000000" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Randomized") {
        $Green = Get8Bit -Value (Get-Random -Maximum 255)
        $Red   = Get8Bit -Value (Get-Random -Maximum 255)
        $Blue  = Get8Bit -Value (Get-Random -Maximum 255)
        WriteToConsole ("Randomize Magic Color: " + ($Green + $Red + $Blue))
        SetColor -Color ($Green + $Red + $Blue) -Dialog $Dialog -Label $Label
    }

}



#==============================================================================================================================================================================================
function SetSpinAttackColorsPreset([Object]$ComboBox, [Object]$Dialog, [Object]$Label) {
    
    $Text = $ComboBox.Text.replace(' (default)', "")
    if     ($Text -eq "Black")      { SetColor -Color "000000" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "White")      { SetColor -Color "FFFFFF" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Red")        { SetColor -Color "FF0000" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Green")      { SetColor -Color "00FF00" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Blue")       { SetColor -Color "0000FF" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Cyan")       { SetColor -Color "00FFFF" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Magenta")    { SetColor -Color "FF00FF" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Orange")     { SetColor -Color "FFA500" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Gold")       { SetColor -Color "FFD700" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Purple")     { SetColor -Color "800080" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Pink")       { SetColor -Color "FF69B4" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Randomized") {
        $Green = Get8Bit -Value (Get-Random -Maximum 255)
        $Red   = Get8Bit -Value (Get-Random -Maximum 255)
        $Blue  = Get8Bit -Value (Get-Random -Maximum 255)
        WriteToConsole ("Randomize Spin Attack Color: " + ($Green + $Red + $Blue))
        SetColor -Color ($Green + $Red + $Blue) -Dialog $Dialog -Label $Label
    }

}



#==============================================================================================================================================================================================
function SetColor([String]$Color, [Object]$Dialog, [Object]$Label) {
    
    $GameSettings["Colors"][$Dialog.Tag] = $Color; $Label.BackColor = $Dialog.Color = "#" + $Color

}



#==============================================================================================================================================================================================
function SetColors([Array]$Colors, [Array]$Dialogs, [Array]$Labels) {
    
    for ($i=0; $i -lt $Colors.length; $i++) {
        $GameSettings["Colors"][$Dialogs[$i].Tag] = $Colors[$i]
        $Labels[$i].BackColor = $Dialogs[$i].Color = "#" + $Colors[$i]
    }

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function GetSFXID
Export-ModuleMember -Function GetItemID
Export-ModuleMember -Function GetInstrumentsID

Export-ModuleMember -Function ShowModelPreview
Export-ModuleMember -Function ChangeModelsSelection
Export-ModuleMember -Function LoadModelsList

Export-ModuleMember -Function CreateButtonColorOptions
Export-ModuleMember -Function CreateSpinAttackColorOptions
Export-ModuleMember -Function CreateFairyColorOptions

Export-ModuleMember -Function SetButtonColorsPreset
Export-ModuleMember -Function SetFairyColorsPreset
Export-ModuleMember -Function SetFairyColors
Export-ModuleMember -Function SetTunicColorsPreset
Export-ModuleMember -Function SetGauntletsColorsPreset
Export-ModuleMember -Function SetMirrorShieldFrameColorsPreset

Export-ModuleMember -Function SetHeartsColorsPreset
Export-ModuleMember -Function SetMagicColorsPreset
Export-ModuleMember -Function SetMinimapColorsPreset
Export-ModuleMember -Function SetSpinAttackColorsPreset

Export-ModuleMember -Function SetColor
Export-ModuleMember -Function SetColors