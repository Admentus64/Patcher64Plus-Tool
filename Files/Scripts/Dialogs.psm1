function CreateLanguagesDialog() {

    # Create Dialog
    $global:LanguagesDialog = CreateDialog -Width 560 -Height 310
    $CloseButton = CreateButton -X ($LanguagesDialog.Width / 2 - 40) -Y ($LanguagesDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $LanguagesDialog
    $CloseButton.Add_Click({ $LanguagesDialog.Hide() })

    # Box
    $global:Languages = @{}
    #$global:Languages.Box = CreateGroupBox -X 15 -Y 10 -Width ($LanguagesDialog.Width - 50) -Text "Languages" -AddTo $LanguagesDialog
    $Languages.Box     = CreateReduxGroup -Y 10 -Height 2 -AddTo $LanguagesDialog -Text "Languages"
    $Languages.Panel   = CreateReduxPanel -Row 0 -Rows 2 -AddTo $Languages.Box
    $Languages.TextBox = CreateReduxGroup -Y ($Languages.Box.Bottom + 5) -Height 3 -AddTo $LanguagesDialog -Text "English Text"

}



#==============================================================================================================================================================================================
function CreateOptionsDialog([int]$Width, [int]$Height) {
    
    # Create Dialog
    if ( (IsSet -Elem $Width) -and (IsSet -Elem $Height) )   { $global:OptionsDialog = CreateDialog -Width $Width -Height $Height }
    else                                                     { $global:OptionsDialog = CreateDialog -Width 900 -Height 640 }

    # Close Button
    $CloseButton = CreateButton -X ($OptionsDialog.Width / 2 - 40) -Y ($OptionsDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $OptionsDialog
    $CloseButton.Add_Click( {$OptionsDialog.Hide() })

    # Options Label
    $global:OptionsLabel = CreateLabel -X 30 -Y 20 -Width 300 -Height 15 -Font $VCPatchFont -AddTo $OptionsDialog

    # Options
    $global:Options = @{}
    $Options.Panel = CreatePanel -Width $OptionsDialog.Width -Height $OptionsDialog.Height -AddTo $OptionsDialog

    # Icon
    if (Test-Path -LiteralPath $GameFiles.icon -PathType Leaf)       { $OptionsDialog.Icon = $GameFiles.icon }
    else                                                             { $OptionsDialog.Icon = $null }

}



#==============================================================================================================================================================================================
function CreateReduxDialog([int]$Width, [int]$Height) {
    
    # Create Dialog
    if ( (IsSet -Elem $Width) -and (IsSet -Elem $Height) )   { $global:ReduxDialog = CreateDialog -Width $Width -Height $Height }
    else                                                     { $global:ReduxDialog = CreateDialog -Width 900 -Height 640 }

    # Close Button
    $CloseButton = CreateButton -X ($ReduxDialog.Width / 2 - 40) -Y ($ReduxDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $ReduxDialog
    $CloseButton.Add_Click( {$ReduxDialog.Hide() })

    # Options Label
    $global:ReduxLabel = CreateLabel -X 30 -Y 20 -Width 300 -Height 15 -Font $VCPatchFont -AddTo $ReduxDialog

    # Options
    $global:Redux = @{}
    $Redux.Panel = CreatePanel -Width $ReduxDialog.Width -Height $ReduxDialog.Height -AddTo $ReduxDialog

    # Icon
    if (Test-Path -LiteralPath $GameFiles.icon -PathType Leaf)       { $ReduxDialog.Icon = $GameFiles.icon }
    else                                                             { $ReduxDialog.Icon = $null }

}



#==============================================================================================================================================================================================
function CreateInfoGameIDDialog() {
    
    # Create Dialog
    $global:InfoGameIDDialog = CreateDialog -Width 550 -Height 600 -Icon $Files.icon.gameID
    $CloseButton = CreateButton -X ($InfoGameIDDialog.Width / 2 - 40) -Y ($InfoGameIDDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $InfoGameIDDialog
    $CloseButton.Add_Click({ $InfoGameIDDialog.Hide() })

    # Create the version number and script name label.
    $InfoLabel = CreateLabel -X ($InfoGameIDDialog.Width / 2 - $String.Width - 100) -Y 10 -Width 200 -Height 15 -Font $VCPatchFont -Text ($ScriptName + " " + $Version + " (" + $VersionDate + ")") -AddTo $InfoGameIDDialog

    # Hash
    $Label = CreateLabel -X 40 -Y 55 -Width 120 -Height 15 -Font $VCPatchFont -Text "N64 ROM Hashsum:" -AddTo $InfoGameIDDialog
    $global:HashSumROMTextBox = CreateTextBox -X $Label.Right -Y ($Label.Top - 3) -Width ($InfoGameIDDialog.Width -$Label.Width - 100) -Height 50 -AddTo $InfoGameIDDialog
    $HashSumROMTextBox.ReadOnly = $True

    # Matching Hash
    $Label = CreateLabel -X 40 -Y ($HashSumROMTextBox.Bottom + 10) -Width 120 -Height 15 -Font $VCPatchFont -Text "Current Z64 ROM:" -AddTo $InfoGameIDDialog
    $global:MatchingROMTextBox = CreateTextBox -X $Label.Right -Y ($Label.Top - 3) -Width ($InfoGameIDDialog.Width -$Label.Width - 100) -Height 50 -Text "No ROM Selected" -AddTo $InfoGameIDDialog
    $MatchingROMTextBox.ReadOnly = $True

    # Create Text Box
    $TextBox = CreateTextBox -X 40 -Y ($MatchingROMTextBox.Bottom + 10) -Width ($InfoGameIDDialog.Width - 100) -Height ($CloseButton.Top - 120) -ReadOnly -Multiline -AddTo $InfoGameIDDialog
    AddTextFileToTextbox -TextBox $Textbox -File $Files.text.gameID

}



#==============================================================================================================================================================================================
function CreateCreditsDialog() {
    
    # Create Dialog
    $global:CreditsDialog = CreateDialog -Width 650 -Height 600 -Icon $Files.icon.credits
    $CloseButton = CreateButton -X ($CreditsDialog.Width / 2 - 40) -Y ($CreditsDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $CreditsDialog
    $CloseButton.Add_Click({ $CreditsDialog.Hide() })

    # Create the version number and script name label.
    $InfoLabel = CreateLabel -X ($CreditsDialog.Width / 2 - $String.Width - 100) -Y 10 -Width 200 -Height 15 -Font $VCPatchFont -Text ($ScriptName + " " + $Version + " (" + $VersionDate + ")") -AddTo $CreditsDialog

    # Create Text Box
    $global:CreditsTextBox = CreateTextBox -X 40 -Y 50 -Width ($CreditsDialog.Width - 100) -Height ($CloseButton.Top - 120) -ReadOnly -Multiline -AddTo $CreditsDialog

    # Support
    $SupportLabel  = CreateLabel -X 40                          -Y ($CreditsTextBox.Bottom + 10) -Width 200 -Height 15 -Font $VCPatchFont -Text ("--- Support or visit me at ---")   -AddTo $CreditsDialog

    $Discord1Label = CreateLabel -X 40                          -Y ($SupportLabel.Bottom + 2)  -Width 80  -Height 15 -Font $VCPatchFont -Text ("Discord")                          -AddTo $CreditsDialog
    $Discord2Label = CreateLabel -X $Discord1Label.Right        -Y ($SupportLabel.Bottom + 2)  -Width 140 -Height 15 -Font $URLFont     -Text ("https://discord.gg/P22GGzz")       -AddTo $CreditsDialog
    $GitHub1Label  = CreateLabel -X 40                          -Y ($Discord1Label.Bottom + 2) -Width 80  -Height 15 -Font $VCPatchFont -Text ("GitHub")                           -AddTo $CreditsDialog
    $GitHub2Label  = CreateLabel -X $GitHub1Label.Right         -Y ($Discord1Label.Bottom + 2) -Width 180 -Height 15 -Font $URLFont     -Text ("https://github.com/Admentus64")    -AddTo $CreditsDialog
    
    $Patreon1Label = CreateLabel -X ($Discord2Label.Right + 60) -Y ($SupportLabel.Bottom + 2)  -Width 80  -Height 15 -Font $VCPatchFont -Text ("Patreon")                          -AddTo $CreditsDialog
    $Patreon2Label = CreateLabel -X $Patreon1Label.Right        -Y ($SupportLabel.Bottom + 2)  -Width 145 -Height 15 -Font $URLFont     -Text ("www.patreon.com/Admentus")         -AddTo $CreditsDialog
    $PayPal1Label  = CreateLabel -X ($Discord2Label.Right + 60) -Y ($Patreon1Label.Bottom + 2) -Width 80  -Height 15 -Font $VCPatchFont -Text ("PayPal")                           -AddTo $CreditsDialog
    $PayPal2Label  = CreateLabel -X $Patreon1Label.Right        -Y ($Patreon1Label.Bottom + 2) -Width 190 -Height 15 -Font $URLFont     -Text ("www.paypal.com/paypalme/Admentus") -AddTo $CreditsDialog

    $Discord2Label.add_Click({[system.Diagnostics.Process]::start("https://discord.gg/P22GGzz")})
    $GitHub2Label.add_Click({[system.Diagnostics.Process]::start("https://github.com/Admentus64")})
    $Patreon2Label.add_Click({[system.Diagnostics.Process]::start("https://www.patreon.com/Admentus")})
    $PayPal2Label.add_Click({[system.Diagnostics.Process]::start("https://www.paypal.com/paypalme/Admentus/")})
    $Discord2Label.ForeColor = $GitHub2Label.ForeColor = $Patreon2Label.ForeColor = $PayPal2Label.ForeColor = "Blue"


}



#==============================================================================================================================================================================================
function CreateInfoDialog() {
    
    # Create Dialog
    $global:InfoDialog = CreateDialog -Width 500 -Height 550 -Icon $Icon
    $CloseButton = CreateButton -X ($InfoDialog.Width / 2 - 40) -Y ($InfoDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $InfoDialog
    $CloseButton.Add_Click({ $InfoDialog.Hide() })

    # Create the version number and script name label.
    $InfoLabel = CreateLabel -X ($InfoDialog.Width / 2 - $String.Width - 100) -Y 10 -Width 200 -Height 15 -Font $VCPatchFont -Text ($ScriptName + " " + $Version + " (" + $VersionDate + ")") -AddTo $InfoDialog

    # Create Text Box
    $global:InfoTextBox = CreateTextBox -X 40 -Y 50 -Width ($InfoDialog.Width - 100) -Height ($CloseButton.Top - 110) -ReadOnly -Multiline -AddTo $InfoDialog

    # Documentation
    $Documentation1Label  = CreateLabel -X 40                         -Y ($InfoTextBox.Bottom + 10)        -Width 150 -Height 15 -Font $VCPatchFont -Text ("--- Documentation Source ---")                                -AddTo $InfoDialog
    $Documentation2Label  = CreateLabel -X 40                         -Y ($Documentation1Label.Bottom + 2) -Width 70  -Height 15 -Font $VCPatchFont -Text ("GitHub")                                                      -AddTo $InfoDialog
    $Documentation3Label  = CreateLabel -X $Documentation2Label.Right -Y ($Documentation1Label.Bottom + 2) -Width 330 -Height 15 -Font $URLFont     -Text ("https://github.com/ShadowOne333/Zelda64-Redux-Documentation") -AddTo $InfoDialog
    
    $Documentation3Label.add_Click({[system.Diagnostics.Process]::start("https://github.com/ShadowOne333/Zelda64-Redux-Documentation")})
    $Documentation3Label.ForeColor = "Blue"

}



#==============================================================================================================================================================================================
function CreateErrorDialog([String]$Error, [Switch]$Exit) {
    
    # Create Dialog
    $ErrorDialog = CreateDialog -Width 300 -Height 200 -Icon $null

    $CloseButton = CreateButton -X ($ErrorDialog.Width / 2 - 40) -Y ($ErrorDialog.Height - 90) -Width 80 -Height 35 -Text "Close" -AddTo $ErrorDialog
    $CloseButton.Add_Click({ $ErrorDialog.Hide() })

    # Create the string that will be displayed on the window.
    $String = $ScriptName + " " + $Version + " (" + $VersionDate + ")" + "{0}{0}"

    if ($Error -eq "Missing Files")         { $String += "Neccessary files are missing.{0}" }
    elseif ($Error -eq "Missing JSON")      { $String += "Games.json or Patches.json files are missing.{0}" }
    elseif ($Error -eq "Corrupted JSON")    { $String += "Games.json or Patches.json files are corrupted.{0}" }
    elseif ($Error -eq "Missing Modules")   { $String += ".PSM1 module files are missing for import.{0}" }

    $String += "{0}"
    $String += "Please download the Patcher64+ Tool again."

    $String = [String]::Format($String, [Environment]::NewLine)

    #Create Label
    $Label = CreateLabel -X 10 -Y 10 -Width ($ErrorDialog.Width-10) -Height ($ErrorDialog.Height - 110) -Text $String -AddTo $ErrorDialog

    if (IsSet -Elem $MainDialog) { $MainDialog.Hide() }
    $ErrorDialog.ShowDialog() | Out-Null
    if ($Exit -eq $True) { Exit }

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function CreateLanguagesDialog
Export-ModuleMember -Function CreateOptionsDialog
Export-ModuleMember -Function CreateReduxDialog
Export-ModuleMember -Function CreateInfoGameIDDialog
Export-ModuleMember -Function CreateCreditsDialog
Export-ModuleMember -Function CreateInfoDialog
Export-ModuleMember -Function CreateErrorDialog