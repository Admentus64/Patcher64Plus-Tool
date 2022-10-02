function ByteOptions() {
    
    if (IsChecked $Redux.Graphics.Widescreen) { ChangeBytes -Offset "8974" -Values "24 07 01 8A" }

    if (IsChecked $Redux.Damage.Extra) {
        ChangeBytes -Offset "8974"   -Values "2407018A"
        ChangeBytes -Offset "1AB5F4" -Values "0260202D0040902DAE2301888E030004AE23018C8E030008AE2301908E05000C0C0B1EAF26100010241500020055001B0000A81200551020A622017E8E05000030A400102403FFDF8E2200001480000B"
    }
    elseif (IsChecked $Redux.Damage.Double) {
        ChangeBytes -Offset "8974"   -Values "2407018A"
        ChangeBytes -Offset "1AB5F4" -Values "0260202D0040902DAE2301888E030004AE23018C8E030008AE2301908E05000C0C0B1EAF261000103C1880118318F2AC130000028E05000000421020A622017E30A400102403FFDF8E2200001480000B"
    }

    if (IsChecked $Redux.Health.Normal -Not) {
        SetHealth "432093"; SetHealth "433A53"; SetHealth "4356A7"; SetHealth "43B423"; SetHealth "43D233"; SetHealth "43EF73"; SetHealth "440973"; SetHealth "4424A7"; SetHealth "451F4F"; SetHealth "45392F"; SetHealth "45539B"; SetHealth "4574A3"; SetHealth "459B6F"; SetHealth "45BAF3"; SetHealth "4662DF"; SetHealth "469937"
        SetHealth "47681F"; SetHealth "477C4B"; SetHealth "479FCF"; SetHealth "481EEB"; SetHealth "48E9D3"; SetHealth "4904B7"; SetHealth "493633"; SetHealth "49518F"; SetHealth "4972D3"; SetHealth "498CAF"; SetHealth "49CD9F"; SetHealth "4A20E3"; SetHealth "4A2EC7"; SetHealth "4A37D7"; SetHealth "4A5B0F"; SetHealth "4A7D7F"
        SetHealth "4B3ACB"; SetHealth "4BE83F"; SetHealth "4C17DF"; SetHealth "4C477F"; SetHealth "4C771F"; SetHealth "4D0A07"; SetHealth "4D276B"; SetHealth "4D39B3"; SetHealth "4DA9F7"; SetHealth "4DFCBF"; SetHealth "4E34E7"; SetHealth "4E6CD3"; SetHealth "4E8CFF"; SetHealth "4EBEB3"; SetHealth "4F309B"; SetHealth "4F8083"
        SetHealth "4FA5E3"; SetHealth "4FD057"; SetHealth "4FF2A3"; SetHealth "501F47"; SetHealth "50768F"; SetHealth "50A7CF"; SetHealth "50C7C7"; SetHealth "50F14F"; SetHealth "5138CB"; SetHealth "51BFC3"; SetHealth "51DB17"; SetHealth "51F0E7"; SetHealth "521B83"; SetHealth "523E2B"; SetHealth "52722F"; SetHealth "52BAD7"
        SetHealth "540003"; SetHealth "542D8B"; SetHealth "5582A3"; SetHealth "55C613"; SetHealth "55E01F"; SetHealth "55EBE3"; SetHealth "56059F"; SetHealth "5623D7"; SetHealth "5677A7"; SetHealth "56C1BB"; SetHealth "56EDEF"; SetHealth "5741A7"; SetHealth "579397"; SetHealth "57A3DB"; SetHealth "57D287"; SetHealth "57DFA7"
        SetHealth "57F53F"; SetHealth "585137"; SetHealth "586A17"; SetHealth "58D293"; SetHealth "58F4C7"; SetHealth "590C9F"; SetHealth "593CB7"; SetHealth "59537F"; SetHealth "59803F"; SetHealth "5A3923"; SetHealth "5AA707"; SetHealth "5B3507"; SetHealth "5B5537"; SetHealth "5B6D33"; SetHealth "5B7FC3"; SetHealth "5BA9D3"
        SetHealth "5BBB7F"; SetHealth "5BCBB7"; SetHealth "5BE257"; SetHealth "5C0F3F"; SetHealth "5C3BD7"; SetHealth "5C7837"; SetHealth "5C785F"; SetHealth "5D0233"; SetHealth "5E6E1B"; SetHealth "5E7FFF"; SetHealth "5EE65F"; SetHealth "5F18BF"; SetHealth "5F6793"; SetHealth "5F8153"; SetHealth "5F9DA7"; SetHealth "5FCF3F"
        SetHealth "5FFECF"; SetHealth "602F67"; SetHealth "60B2BF"; SetHealth "60D2BB"; SetHealth "6101AB"; SetHealth "61A023"; SetHealth "61C033"; SetHealth "626B77"; SetHealth "633AFF"; SetHealth "63516B"; SetHealth "63579F"; SetHealth "63678F"; SetHealth "6380B7"; SetHealth "63F14F"; SetHealth "641277"; SetHealth "644517"
        SetHealth "64A423"; SetHealth "64E757"; SetHealth "64F53F"; SetHealth "6505F7"; SetHealth "6532B7"; SetHealth "655F77"; SetHealth "655F9F"; SetHealth "658C87"; SetHealth "65B947"; SetHealth "65B96F"; SetHealth "66126F"; SetHealth "668D9B"; SetHealth "668DC3"; SetHealth "668DEB"; SetHealth "66BDD7"; SetHealth "678CB3"
        SetHealth "67CFEF"; SetHealth "67E0A7"; SetHealth "680D67"; SetHealth "68547F"; SetHealth "689693"; SetHealth "68B0AF"; SetHealth "68D027"; SetHealth "691B57"; SetHealth "691B7F"; SetHealth "6993CB"; SetHealth "6A4617"; SetHealth "6A65AF"; SetHealth "6A889F"; SetHealth "6AE94F"; SetHealth "6B487F"; SetHealth "6BD333"
        SetHealth "6BEE97"; SetHealth "6CC7A3"; SetHealth "6CCF63"; SetHealth "6CDF17"; SetHealth "6D2A47"
    }
}


#==============================================================================================================================================================================================
function SetHealth([string]$Offset) {
    
    [float]$multiplier = 1.0

    if     (IsChecked $Redux.Health.Extra)    { [float]$multiplier = 1.5 }
    elseif (IsChecked $Redux.Health.Double)   { [float]$multiplier = 2.0 }
    elseif (IsChecked $Redux.Health.Triple)   { [float]$multiplier = 3.0 }

    MultiplyBytes -Offset $offset -Factor $multiplier
}



#==============================================================================================================================================================================================
function CreateOptions() {

    CreateOptionsDialog -Columns 4 -Height 300

    CreateReduxGroup    -Tag  "Graphics"   -All -Text "Graphics"
    CreateReduxCheckBox -Name "Widescreen" -All -Text "16:9 Widescreen" -Info "Adjust the aspect ratio from 4:3 to 16:9 widescreen" -Credits "gamemasterplc"

    CreateReduxGroup       -Tag  "Damage" -Text "Hard Mode (Damage)"
    CreateReduxPanel
    CreateReduxRadioButton -Name "Normal" -Max 3 -SaveTo "Damage" -Text "Normal Damage (1x)"  -Info "Keep the vanilla game difficulty"              -Checked
    CreateReduxRadioButton -Name "Extra"  -Max 3 -SaveTo "Damage" -Text "Extra Damage (1.5x)" -Info "Increases the damage dealt by enemies by 1.5x" -Credits "Skelux & Admentus"
    CreateReduxRadioButton -Name "Double" -Max 3 -SaveTo "Damage" -Text "Double Damage (2x)"  -Info "Increases the damage dealt by enemies by 2x"   -Credits "Skelux & Admentus"

    CreateReduxGroup       -Tag  "Health" -Text "Hard Mode (Health)"
    CreateReduxPanel
    CreateReduxRadioButton -Name "Normal" -Max 4 -SaveTo "Health" -Text "Normal Health (1x)"  -Info "Keep the vanilla health values for enemies" -Checked
    CreateReduxRadioButton -Name "Extra"  -Max 4 -SaveTo "Health" -Text "Extra Health (1.5x)" -Info "Increases the health of Enemies by 1.5x"    -Credits "Skelux & Admentus"
    CreateReduxRadioButton -Name "Double" -Max 4 -SaveTo "Health" -Text "Double Health (2x)"  -Info "Increases the health of Enemies by 2x"      -Credits "Skelux & Admentus"
    CreateReduxRadioButton -Name "Triple" -Max 4 -SaveTo "Health" -Text "Triple Health (3x)"  -Info "Increases the health of Enemies by 3x"      -Credits "Skelux & Admentus"

}