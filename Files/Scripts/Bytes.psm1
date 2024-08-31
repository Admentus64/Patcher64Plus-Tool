function ChangeBytes([string]$File, [byte[]]$Array, [object]$Offset, [object]$Match=$null, [object]$Values, [byte]$Repeat=0, [uint16]$Interval=1, [switch]$Add, [switch]$Subtract, [switch]$Silent) {
    
    if (IsSet $File) {
        if (!(TestFile $File)) {
            WriteToConsole ("Could not find path to file to adjust: " + $File)
            $global:WarningError = $True
            return $False
        }
    }

    if     ($Match  -is [String] -and $Match  -Like "* *")               { $matchDec  = $Match -split ' '            | foreach { [Convert]::ToByte($_, 16) } }
    elseif ($Match  -is [String])                                        { $matchDec  = $Match -split '(..)' -ne ''  | foreach { [Convert]::ToByte($_, 16) } }
    elseif ($Match  -is [Array]  -and $Match[0] -is [String])            { $matchDec  = $Match                       | foreach { [Convert]::ToByte($_, 16) } }
    else                                                                 { $matchDec  = @(); $matchDec += $Match }

    if ( (IsNumber -Number $Values) -and $Add) {
        if ($Values -lt 0) {
            $Add      = $False
            $Subtract = $True
            $values  *= -1
        }
    }
    elseif ($Values -is [Array] -and $Add) {
        if ($Values[0] -lt 0) {
            for ($i=0; $i -lt $Values.count; $i++) {
                if ($Values[$i] -lt 0) { $Values[$i] *= -1 }
            }
            $Add      = $False
            $Subtract = $True
        }
    }

    if     ($Values -is [String] -and $Values -Like "* *")               { $valuesDec = $Values -split ' '           | foreach { [Convert]::ToByte($_, 16) } }
    elseif ($Values -is [String])                                        { $valuesDec = $Values -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) } }
    elseif ($Values -is [Array]  -and $Values[0] -is [System.String])    { $valuesDec = $Values                      | foreach { [Convert]::ToByte($_, 16) } }
    else                                                                 { $valuesDec = @(); $valuesDec += $Values }
    
    if ($Repeat -gt 0) {
        if ($valuesDec -isnot [array]) {
            $tempValues  = @()
            $tempValues += $valuesDec
            $valuesDec   = $tempValues
        }
        $tempValues = $ValuesDec
        for ($i=0; $i -lt $Repeat; $i++) { $valuesDec += $tempValues }
    }

    if     ($Array.count -gt 0 -and $Array -ne $null)                    { $ByteArrayGame = $Array                                }
    elseif (IsSet $File)                                                 { $ByteArrayGame = [System.IO.File]::ReadAllBytes($File) }
    if     ($Interval -lt 1)                                             { $Interval      = 1                                     }

    # Offset
    if ($Offset -is [String]) { $Offset = $Offset -split ' ' }
    
    $offsetDec = @()
    foreach ($o in $Offset) {
        if ($o -is [string]) { $dec = GetDecimal $o } else { $dec = $o }
        if ($dec -lt 0) {
            WriteToConsole "Offset is negative, too large or not an integer!" -Error
            $global:WarningError = $True
            return $False
        }
        if ($dec -gt $ByteArrayGame.Length) {
            WriteToConsole "Offset is too large for file!" -Error
            $global:WarningError = $True
            return $False
        }
        $offsetDec += $dec
    }

    # Match
    if ($matchDec -ne $null) {
        foreach ($o in $offsetDec) {
            foreach ($i in 0..($matchDec.Length-1)) {
                try {
                    if ($ByteArrayGame[$o + $i] -ne $matchDec[$i]) { return $True }
                }
                catch {
                    WriteToConsole "Match value is negative!" -Error
                    return $False
                }
            }
        }
    }

    # Print info
    if (!$Silent) {
        if ($Offset.Count -eq 1) {
            $spaces = ""
            if ($Offset[0] -isnot [String]) { WriteToConsole ((Get32Bit $Offset[0]) + " -> Change values: " + $Values) }
            else {
                while ($Offset[0].Substring(0, 1) -eq "0") { $Offset[0] = $Offset[0].Substring(1) }
                for ($i=8; $i -gt $Offset[0].Length; $i--) { $spaces += " " }
                WriteToConsole ($Offset[0] + $spaces + "-> Change values: " + $Values)
            }
        }
        else { WriteToConsole ($Offset + "-> Change values: " + $Values) }
    }

    # Patch
    foreach ($o in $offsetDec) {
        foreach ($i in 0..($valuesDec.Length-1)) {
            if ($Settings.Debug.OverwriteChecks -eq $True -and $RunOverwriteChecks) {
                if ($OverwritechecksROM[$o + ($i * $Interval)] -ne $ByteArrayGame[$o + ($i * $Interval)]) {
                    $global:OverwriteError = $True
                    WriteToConsole ("Offset " + $Offset + " is overwritten: " + (Get8Bit $OverwritechecksROM[$o + ($i * $Interval)]) + " -> " + (Get8Bit $ByteArrayGame[$o + ($i * $Interval)])) -Error
                }
            }

            $value = $valuesDec[$i]
            do {
                if ($value -ge 255) {
                    $restValue = 255
                    $value    -= 255
                }
                else {
                    $restValue = $value
                    $value     = 0
                }

                if ($Add) {
                    if ($ByteArrayGame[$o + ($i * $Interval)] + $restValue -gt 255) {
                        $ByteArrayGame[$o + ($i * $Interval)]     += $restValue - 256
                        $ByteArrayGame[$o + ($i * $Interval) - 1] += 1
                    }
                    else { $ByteArrayGame[$o + ($i * $Interval)] += $restValue }
                }
                elseif ($Subtract) {
                    if ($ByteArrayGame[$o + ($i * $Interval)] - $restValue -lt 0) {
                        $ByteArrayGame[$o + ($i * $Interval)]     += 256 - $restValue
                        $ByteArrayGame[$o + ($i * $Interval) - 1] -= 1
                    }
                    else { $ByteArrayGame[$o + ($i * $Interval)] -= $restValue }
                }
                else { $ByteArrayGame[$o + ($i * $Interval)]  = $restValue }
            } while ($value -gt 0)
        }
    }

    # Write to File
    if (IsSet $File) { [System.IO.File]::WriteAllBytes($File, $ByteArrayGame) }
    return $True

}



#==============================================================================================================================================================================================
function MultiplyBytes([string]$File, [object]$Offset, [object]$Match=$null, [float]$Factor) {
    
    if (IsSet $File) {
        if (!(TestFile $File)) {
            WriteToConsole ("Could not find path to file to adjust: " + $File) -Error
            $global:WarningError = $True
            return $False
        }
        $ByteArrayGame = [System.IO.File]::ReadAllBytes($File)
    }

    if     ($Match -is [String] -and $Match  -Like "* *")      { $matchDec = $Match -split ' '           | foreach { [Convert]::ToByte($_, 16) } }
    elseif ($Match -is [String])                               { $matchDec = $Match -split '(..)' -ne '' | foreach { [Convert]::ToByte($_, 16) } }
    elseif ($Match -is [Array]  -and $Match[0] -is [String])   { $matchDec = $Match                      | foreach { [Convert]::ToByte($_, 16) } }
    else                                                       { $matchDec = $Match }

    # Offset
    if ($Offset -is [String]) { $Offset = $Offset -split ' ' }
    
    $offsetDec = @()
    $offsets   = @()
    foreach ($o in $Offset) {
        if ($o -is [string]) { $dec = GetDecimal $o } else { $dec = $o }
        if ($dec -lt 0) {
            WriteToConsole "Offset is negative, too large or not an integer!" -Error
            $global:WarningError = $True
            return $False
        }
        if ($dec -gt $ByteArrayGame.Length) {
            WriteToConsole "Offset is too large for file!" -Error
            $global:WarningError = $True
            return $False
        }
        $offsetDec += $dec
        $offsets   += $o
    }

    # Match
    if ($matchDec -ne $null) {
        foreach ($o in $offsetDec) {
            foreach ($i in 0..($matchDec.Length-1)) {
                try {
                    if ($ByteArrayGame[$o + $i] -ne $matchDec[$i]) { return $True }
                }
                catch {
                    WriteToConsole "Match value is negative!" -Error
                    return $False
                }
            }
        }
    }

    # Patch
    for ($i=0; $i -lt $offsetDec.length; $i++) {
        if ($Factor -eq 0) {
            WriteToConsole ($offsets[$i] + " -> Set value " + (Get8Bit $ByteArrayGame[$offsetDec[$i]]) +" to: 1")
            $ByteArrayGame[$offsetDec[$i]] = 1
        }
        elseif ($ByteArrayGame[$offsetDec[$i]] -gt 0) {
            WriteToConsole ($offsets[$i] + " -> Multiplied value " + (Get8Bit $ByteArrayGame[$offsetDec[$i]]) +" by: " + $Factor)
            $ByteArrayGame[$offsetDec[$i]] *= $Factor
            if ($ByteArrayGame[$offsetDec[$i]] -eq 0) { $ByteArrayGame[$offsetDec[$i]] = 1 }
        }
    }

    # Write to File
    if (IsSet $File) { [System.IO.File]::WriteAllBytes($File, $ByteArrayGame) }
    return $True

}



#==============================================================================================================================================================================================
function CopyBytes([string]$File, [string]$Start, [string]$Length, [string]$Offset) {
    
    if (IsSet $File) {
        if (!(TestFile $File)) {
            WriteToConsole ("Could not find path to file to adjust: " + $File) -Error
            $global:WarningError = $True
            return $False
        }
        $ByteArrayGame = [System.IO.File]::ReadAllBytes($File) 
    }

    # Offset
    $startDec  = GetDecimal $Start
    $lengthDec = GetDecimal $Length
    $offsetDec = GetDecimal $Offset
    
    if ($startDec -lt 0 -or $Length -lt 0 -or $offsetDec -lt 0) {
        WriteToConsole "lengthDec are negative, too large or not an integer!" -Error
        $global:WarningError = $True
        return $False
    }
    if ($startDec -gt $ByteArrayGame.Length -or $lengthDec -gt $ByteArrayGame.Length -or $offsetDec -gt $ByteArrayGame.Length) {
        WriteToConsole "Offsets are too large for file!" -Error
        $global:WarningError = $True
        return $False
    }

    # Patch
    WriteToConsole ($Offset + " -> Copying values: from " + $Start)
    foreach ($i in 0..($lengthDec-1)) {
        $ByteArrayGame[$offsetDec + $i]  = $ByteArrayGame[$startDec + $i]
    }

    # Write to File
    if (IsSet $File) { [System.IO.File]::WriteAllBytes($File, $ByteArrayGame) }
    return $True

}



#==============================================================================================================================================================================================
function PatchBytes([string]$File, [object]$Offset, [object]$Length, [string]$Patch, [switch]$Texture, [switch]$Models, [switch]$Extracted, [switch]$Music, [switch]$Editor, [switch]$Temp, [switch]$Shared, [switch]$Pad, [switch]$Silent) {
    
    if (IsSet $File) {
        if (!(TestFile $File)) {
            WriteToConsole ("Could not find path to file to adjust: " + $File) -Error
            $global:WarningError = $True
            return $False
        }
        $ByteArrayGame = [System.IO.File]::ReadAllBytes($File) 
    }

    # Binary Patch File Parameter Check
    if (!(IsSet -Elem $Patch) ) {
        WriteToConsole "No binary patch file is provided" -Error
        $global:WarningError = $True
        return
    }

    # Binary Patch File Path
    if     ($Texture)     { $Patch = $GameFiles.textures  + "\" + $Patch                               }
    elseif ($Models)      { $Patch = $GameFiles.models    + "\" + $Patch                               }
    elseif ($Extracted)   { $Patch = $GameFiles.extracted + "\" + $Patch                               }
    elseif ($Music)       { $Patch = $Paths.Music         + "\" + $Patch                               }
    elseif ($Editor)      { $Patch = $Paths.Games         + "\" + $GameType.mode + "\Editor\" + $Patch }
    elseif ($Temp)        { $Patch = $Paths.Temp          + "\" + $Patch                               }
    elseif ($Shared)      { $Patch = $Paths.Shared        + "\" + $Patch                               }
    else                  { $Patch = $GameFiles.binaries  + "\" + $Patch                               }

    # Binary Patch File Exists
    if (!(TestFile $Patch)) {
        WriteToConsole ("Missing binary patch file: " + $Patch) -Error
        $global:WarningError = $True
        return
    }

    # Read Patch File
    $PatchByteArray = [IO.File]::ReadAllBytes($Patch)

    # Offset
    if ($offset -is [string]) { $offsetDec = GetDecimal $Offset } else { $offsetDec = $Offset }
    if ($offsetDec -lt 0) {
        WriteToConsole "Offset is negative, too large or not an integer!" -Error
        $global:WarningError = $True
        return
    }
    if ($offsetDec -gt $ByteArrayGame.Length) {
        WriteToConsole "Offset is too large for file!" -Error
        $global:WarningError = $True
        return
    }

    # Info
    if (!$Silent) { WriteToConsole ($Offset + " -> Patch file from: " + $Patch) }

    # Patch
    if (IsSet $Length) {
        if ($Length -is [string]) { $lengthDec = GetDecimal $Length } else { $lengthDec = $Length }
        foreach ($i in 0..($lengthDec-1)) {
            if ($Settings.Debug.OverwriteChecks -eq $True -and $RunOverwriteChecks) {
                if ($OverwritechecksROM[$o + ($i * $Interval)] -ne $ByteArrayGame[$o + ($i * $Interval)]) {
                    $global:OverwriteError = $True
                    WriteToConsole ("Offset " + $Offset + " is overwritten: " + (Get8Bit $OverwritechecksROM[$offsetDec + $i]) + " -> " + (Get8Bit $ByteArrayGame[$offsetDec + $i])) -Error
                }
            }

            if ($i -le $PatchByteArray.Length)   { $ByteArrayGame[$offsetDec + $i] = $PatchByteArray[($i)] }
            elseif ($Pad)                        { $ByteArrayGame[$offsetDec + $i] = 255 }
            else                                 { $ByteArrayGame[$offsetDec + $i] = 0 }
        }
    }
    else {
        foreach ($i in 0..($PatchByteArray.Length-1)) {
            if ($Settings.Debug.OverwriteChecks -eq $True -and $RunOverwriteChecks) {
                if ($OverwritechecksROM[$o + ($i * $Interval)] -ne $ByteArrayGame[$o + ($i * $Interval)]) {
                    $global:OverwriteError = $True
                    WriteToConsole ("Offset " + $Offset + " is overwritten: " + (Get8Bit $OverwritechecksROM[$offsetDec + $i]) + " -> " + (Get8Bit $ByteArrayGame[$offsetDec + $i])) -Error
                }
            }

            $ByteArrayGame[$offsetDec + $i] = $PatchByteArray[($i)]
        }
    }

    # Write to File
    if (IsSet $File) { [io.file]::WriteAllBytes($File, $ByteArrayGame) }

}



#==============================================================================================================================================================================================
function ExportBytes([string]$File, [Object]$Offset, [Object]$End, [Object]$Length, [string]$Output, [switch]$Force, [switch]$Silent) {
    
    if (IsSet $File) {
        if (!(TestFile $File)) {
            WriteToConsole ("Could not find path to file to adjust: " + $File) -Error
            $global:WarningError = $True
            return $False
        }
        $ByteArrayGame = [System.IO.File]::ReadAllBytes($File) 
    }

    if ( (TestFile $Output) -and ($Settings.Debug.ForceExtract -eq $False) -and !$Force) { return }

    if ($Offset -is [String]) { $offsetDec = GetDecimal $Offset } else { $offsetDec = $Offset }
    if (!$Silent) { WriteToConsole ("Write file to: " + $Output) }

    if ($offsetDec -lt 0) {
        WriteToConsole "Offset is negative!" -Error
        $global:WarningError = $True
        return
    }
    elseif ($offsetDec -gt $ByteArrayGame.Length) {
        WriteToConsole "Offset is too large for file!" -Error
        $global:WarningError = $True
        return
    }

    RemoveFile $Output
    $Path = $Output.substring(0, $Output.LastIndexOf('\'))
    $Folder = $Path.substring($Path.LastIndexOf('\') + 1)
    $Path = $Path.substring(0, $Path.LastIndexOf('\') + 1)
    if (!(TestFile -Path ($Path + $Folder) -Container)) { New-Item -Path $Path -Name $Folder -ItemType Directory }

    if (IsSet $End) {
        if ($End -is [string]) { $endDec = GetDecimal $End } else { $endDec = $End }
        [io.file]::WriteAllBytes($Output, $ByteArrayGame[$offsetDec..($endDec - 1)])
    }
    elseif (IsSet $Length) {
        if ($Length -is [String]) { $lengthDec = GetDecimal $Length } else { $lengthDec = $Length }
        [io.file]::WriteAllBytes($Output, $ByteArrayGame[$offsetDec..($offsetDec + $lengthDec - 1)])
    }

}



#==============================================================================================================================================================================================
function SearchBytes([string]$File, [object]$Start="0", [object]$End, [object]$Values, [switch]$Decimal, [switch]$Silent) {
    
    if (IsSet $File) {
        if (!(TestFile $File)) {
            WriteToConsole ("Could not find path to file to adjust: " + $File) -Error
            $global:WarningError = $True
            return -1
        }
        $ByteArrayGame = [System.IO.File]::ReadAllBytes($File) 
    }

    if     ($values -is [String] -and $values -Like "* *")   { $values = $values -split ' '           }
    elseif ($values -is [String])                            { $values = $values -split '(..)' -ne '' }
    else {
        WriteToConsole "Search values are not valid to look for" -Error
        $global:WarningError = $True
        return -1
    }

    [uint32]$Start = GetDecimal $Start
    if (IsSet $End)   { [uint32]$End = GetDecimal $End }
    else              { [uint32]$End = $ByteArrayGame.Length }

    if ($Start -lt 0 -or $End -lt 0) {
        WriteToConsole "Start or end offset is negative!" -Error
        $global:WarningError = $True
        return -1
    }
    elseif ($Start -gt $ByteArrayGame.Length -or $End -gt $ByteArrayGame.Length) {
        WriteToConsole "Start or end offset is too large for file!" -Error
        $global:WarningError = $True
        return -1
    }
    elseif ($Start -gt $End) {
        Write-Host "Start offset can not be greater than end offset"
        $global:WarningError = $True
        return -1
    }

    foreach ($i in $Start..($End-1)) {
        $found = $True
        foreach ($j in 0..($Values.Length-1)) {
            if ($Values[$j] -ne "") {
                if ($ByteArrayGame[$i + $j] -ne (GetDecimal $Values[$j]) -and $Values[$j] -ne "xx") {
                    $found = $False
                    break
                }
            }
        }
        if ($found -eq $True) {
            if (!$Silent) { WriteToConsole ("Found values at: " + (Get32Bit $i)) }
            if ($Decimal) { return $i }
            return Get32Bit $i
        }
    }

    if (!$Silent) { WriteToConsole "Did not find searched values" -Error }
    return -1;

}



#==============================================================================================================================================================================================
function ExportAndPatch([string]$Path, [string]$Offset, [string]$Length, [string]$NewLength, [string]$TableOffset, [object]$Values) {
    
    $File = $GameFiles.extracted + "\" + $Path + ".bin"
    if ( !(TestFile $File) -or ($Settings.Debug.ForceExtract -eq $True) ) {
        ExportBytes -Offset $Offset -Length $Length -Output $File
        ApplyPatch -File $File -Patch (CheckPatchExtension -File ($GameFiles.export + "\" + $Path)) -FullPath
    }

    if (!(IsSet $NewLength))      { $NewLength = $Length }
    if ($NewLength -lt $Length)   { PatchBytes -Offset $Offset -Extracted -Patch ($Path + ".bin") -Length $Length }
    else                          { PatchBytes -Offset $Offset -Extracted -Patch ($Path + ".bin") -Length $NewLength }

    if ( (IsSet $TableOffset) -and (IsSet $Values) ) {
        ChangeBytes -Offset $TableOffset -Values $Values
    }

}



#==================================================================================================================================================================================================================================================================
function GetDecimal([string]$Hex) {
    
    try     { return [uint32]("0x" + $Hex) }
    catch   { return -1 }

}



#==================================================================================================================================================================================================================================================================
function ConvertFloatToHex([string]$Float) {

    $bytes = [BitConverter]::GetBytes([single]$Float)
    $bytes = $bytes | foreach { ("{0:X2}" -f $_) }
    [array]::Reverse($bytes)
    return $bytes

}



#==================================================================================================================================================================================================================================================================
function ConvertHexToFloat([string]$Hex) {
    
    try     { return ([BitConverter]::ToSingle([BitConverter]::GetBytes([uint32]("0x" + $Hex)), 0)) }
    catch   { return -1 }

}



#==================================================================================================================================================================================================================================================================
function CombineHex([string[]]$Hex) {
    
    $output = ""
    foreach ($item in $Hex) { $output += Get8Bit $item }
    return [string]$output

}



#==================================================================================================================================================================================================================================================================
function Get8Bit([byte]$Value)                                 { return '{0:X2}' -f $Value }
function Get16Bit([uint16]$Value)                              { return '{0:X4}' -f $Value }
function Get24Bit([uint32]$Value)                              { return '{0:X6}' -f $Value }
function Get32Bit([uint32]$Value)                              { return '{0:X8}' -f $Value }
function AddToOffset([string]$Hex, [string]$Add)               { return (Get32Bit ( (GetDecimal $Hex) + (GetDecimal $Add)      ) ) }
function SubtractFromOffset([string]$Hex, [string]$Subtract)   { return (Get32Bit ( (GetDecimal $Hex) - (GetDecimal $Subtract) ) ) }
function IsNumber($Number)                                     { return $Number -is [byte] -or $Number -is [int16] -or $Number -is [int32] -or $Number -is [int64] -or $Number -is [sbyte] -or $Number -is [uint16] -or $Number -is [uint32] -or $Number -is [uint64] }



#==============================================================================================================================================================================================

(Get-Command -Module "Bytes") | % { Export-ModuleMember $_ }