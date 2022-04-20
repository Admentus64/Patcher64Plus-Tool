function CreateEditorDialog([int32]$Width, [int32]$Height) {
    
    $global:Editor = @{}

    # Create Dialog
    if ( (IsSet $Width) -and (IsSet $Height) )   { $Editor.Dialog = CreateDialog -Width (DPISize $Width) -Height (DPISize $Height) }
    else                                         { $Editor.Dialog = CreateDialog -Width (DPISize 900) -Height (DPISize 640) }
    $Editor.Dialog.Icon = $Files.icon.additional

    # Close Button
    $X = $Editor.Dialog.Width / 2 - (DPISize 40)
    $Y = $Editor.Dialog.Height - (DPISize 90)
    $CloseButton = CreateButton -X $X -Y $Y -Width (DPISize 80) -Height (DPISize 35) -Text "Close" -AddTo $Editor.Dialog
    $CloseButton.Add_Click( { $Editor.Dialog.Hide() })

    # Left Panel
    $Editor.ListPanel = CreatePanel -Width (DPISize 270) -Height ($Editor.Dialog.Height - (DPISize 20)) -AddTo $Editor.Dialog
    $Editor.ListPanel.BackColor = 'AliceBlue'
    $Editor.ListPanel.AutoScroll = $True
    $Editor.ListPanel.AutoScrollMargin  = New-Object System.Drawing.Size(20, 20)
    $Editor.ListPanel.AutoScrollMinSize = New-Object System.Drawing.Size(20, 900)
    $Editor.Buttons = @()

    # Right Panel
    $Editor.ContentPanel = CreatePanel -X $Editor.ListPanel.Right -Width ($Editor.Dialog.Width - $Editor.ListPanel.Width) -Height $Editor.Dialog.Height -AddTo $Editor.Dialog
    $Editor.ContentPanel.BackColor = 'AntiqueWhite'
    $Editor.Content = CreateTextBox -X (DPISize 15) -Y (DPISize 15) -Width ($Editor.ContentPanel.width - (DPISize 50)) -Height ($Editor.ContentPanel.Height - (DPISize 120)) -Multiline -Font $Fonts.Editor -AddTo $Editor.ContentPanel

    # Options Label
    $Editor.Label = CreateLabel -Y (DPISize 15) -Width $Editor.Dialog.width -Height (DPISize 15) -Font $Fonts.SmallBold -Text ($GameType.mode + " - Text Editor") -AddTo $Editor.Dialog
    $Editor.Label.AutoSize = $True
    $Editor.Label.Left = ([Math]::Floor($Editor.Dialog.Width / 2) - [Math]::Floor($Editor.Label.Width / 2))

    $list = GetMessageIDs
    $row = $column = 0
    $width = 60
    $height = 30
    foreach ($i in 0..($list.Length-1)) {
        if ($column -eq 4) {
            $row++
            $column = 0
        }

        $button = New-Object System.Windows.Forms.Button
        $button.Text = $list[$i]
        $button.Font = $Fonts.Small
        $button.Size = New-Object System.Drawing.Size((DPISize $width), (DPISize $height))
        $button.Location = New-Object System.Drawing.Size(($column * (DPISize $width) + ((DPISize 5))), ($row * (DPISize $height)))
        $button.ForeColor = "White"
        $button.BackColor = "Gray"

        $button.Add_Click( {
            $Table  = [System.IO.File]::ReadAllBytes($GameFiles.editor + "\Table Vanilla.tbl")
            $Script = [System.IO.File]::ReadAllBytes($GameFiles.editor + "\vanilla.bin")
            $Editor.Content.Text = GetMessage -Table $Table -Script $Script -ID $this.Text
            if (IsSet $Editor.LastButton) { $Editor.LastButton.BackColor = "Gray" }
            $Editor.LastButton = $this
            $this.BackColor = "DarkGray"
        } )

        $Editor.ListPanel.Controls.Add($button)

        $column++
    }

}


#==============================================================================================================================================================================================
function GetMessage($Table, $Script, [string]$ID, [switch]$HexOutput) {
    
    if (!(IsSet $Table))    { $Table  = $ByteTableArray  }
    if (!(IsSet $Script))   { $Script = $ByteScriptArray }

    for ($i=0; $i -lt $Table.length; $i+= 8) {
        $combine = CombineHex $Table[$i..($i+1)]
        if ( (GetDecimal $combine) -eq (GetDecimal $ID )) {
            $start = GetDecimal ( CombineHex @($Table[$i+5],   $Table[$i+6],   $Table[$i+7])   )
            $end   = GetDecimal ( CombineHex @($Table[$i+5+8], $Table[$i+6+8], $Table[$i+7+8]) )
            
            if ($HexOutput) { return (($Script[$start..$end]) | ForEach-Object ToString X2) }
            return [char[]]$Script[$start..$end] -join ''
        }
    }
    return -1

}



#==============================================================================================================================================================================================
function GetMessageIDs() {
    
    $table  = [System.IO.File]::ReadAllBytes($GameFiles.editor + "\Table Vanilla.tbl")
    $list = @()
    for ($i=0; $i -lt $table.length; $i+= 8) {
        if ( (CombineHex $table[$i..($i+7)]) -eq "FFFF000000000000") { break }
        else { $list += CombineHex @($table[$i], $table[$i+1]) }
    }
    return $list

}



#==============================================================================================================================================================================================
function GetMessageOffset([string]$ID) {
    
    $table  = [System.IO.File]::ReadAllBytes($GameFiles.editor + "\Table Vanilla.tbl")

    for ($i=0; $i -lt $table.length; $i+= 8) {
        if ( (Get16Bit ($table[$i] + $table[$i+1])) -eq $ID) {
            return ( CombineHex @($table[$i+5], $table[$i+6], $table[$i+7]) )
        }
    }
    return -1

}



#==============================================================================================================================================================================================
function SetMessage([string]$ID, [string]$Old, [string]$New, [switch]$ASCII) {

    $table  = [System.IO.File]::ReadAllBytes($GameFiles.editor + "\Table Vanilla.tbl")
    $script = $GameFiles.editor + "\vanilla.bin"

    for ($i=0; $i -lt $table.length; $i+= 8) {
        if ( (Get16Bit ($table[$i] + $table[$i+1])) -eq $ID) {
            $start = CombineHex @($table[$i+5],   $table[$i+6],   $table[$i+7])
            $end   = CombineHex @($table[$i+5+8], $table[$i+6+8], $table[$i+7+8])
            
            if ($ASCII) {
                $old = ($old | Format-Hex | Select-Object -Expand Bytes | ForEach-Object { '{0:x2}' -f $_ }) -join ' '
                $new = ($new | Format-Hex | Select-Object -Expand Bytes | ForEach-Object { '{0:x2}' -f $_ }) -join ' '
            }
            
            $offset = SearchBytes -File $script -Start $start -End $end -Values $old
            ChangeBytes -File $script -Offset $offset -Values $new
            return
        }
    }

}



#==============================================================================================================================================================================================

(Get-Command -Module "Editor") | % { Export-ModuleMember $_ }