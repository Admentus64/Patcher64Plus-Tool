function ChangeBytes([string]$File, [byte[]]$Array, [object]$Offset, [object]$Match=$null, [object]$Values, [byte]$Repeat=0, [uint16]$Interval=1, [switch]$Add, [switch]$Subtract, [switch]$Silent) {
    
    if (IsSet $File) {
        if (!(TestFile $File)) {
            WriteToConsole ("Could not find path to file to adjust: " + $File)
            $global:WarningError = $True
            return $False
        }
    }

    if ($Match -is [String]) {
        if ($Match -like "* *")   { $matchDec = $Match -split ' '           | ForEach-Object { [Convert]::ToByte($_, 16) } }
        else                      { $matchDec = $Match -split '(..)' -ne '' | ForEach-Object { [Convert]::ToByte($_, 16) } }
    }
    elseif ($Match -is [Array] -and $Match[0] -is [String])   { $matchDec =   $Match | ForEach-Object { [Convert]::ToByte($_, 16) } }
    else                                                      { $matchDec = @($Match) }

    if ($Add) {
        if ($Values -is [Array]) {
            if ($Values[0] -lt 0) {
                $Values = $Values | ForEach-Object { if ($_ -lt 0) { -$_ } else { $_ } }
                $Add      = $False
                $Subtract = $True
            }
        }
        elseif ((IsNumber -Number $Values) -and $Values -lt 0) {
            $Values   = -$Values
            $Add      = $False
            $Subtract = $True
        }
    }

    if ($Values -is [String]) {
        if ($Values -like "* *")   { $valuesDec = $Values -split ' '           | ForEach-Object { [Convert]::ToByte($_, 16) } }
        else                       { $valuesDec = $Values -split '(..)' -ne '' | ForEach-Object { [Convert]::ToByte($_, 16) } }
    }
    elseif ($Values -is [Array] -and $Values[0] -is [System.String])   { $valuesDec =   $Values | ForEach-Object { [Convert]::ToByte($_, 16) } }
    else                                                               { $valuesDec = @($Values)                                               }
    
    if ($Repeat -gt 0) {
        if ($valuesDec -isnot [array]) { $valuesDec = @($valuesDec) }
        $valuesDec *= $Repeat
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
                $currentByte  = $ByteArrayGame[$o + ($i * $Interval)]
                $originalByte = $OverwritechecksROM[$o + ($i * $Interval)]

                if ($currentByte -ne $originalByte) {
                    $global:OverwriteError = $True
                    WriteToConsole ("Offset $Offset is overwritten: " + (Get8Bit $originalByte) + " -> " + (Get8Bit $currentByte)) -Error
                }
            }

            $value     = $valuesDec[$i]
            $restValue = 0

            do {
                if ($value -ge 255) {
                    $restValue = 255
                    $value    -= 255
                }
                else {
                    $restValue = $value
                    $value     = 0
                }

                $currentByte = $ByteArrayGame[$o + ($i * $Interval)]

                if ($Add) {
                    if ($currentByte + $restValue -gt 255) {
                        $ByteArrayGame[$o + ($i * $Interval)] = ($currentByte + $restValue - 256)
                        $ByteArrayGame[$o + ($i * $Interval) - 1] += 1
                    }
                    else { $ByteArrayGame[$o + ($i * $Interval)] += $restValue }
                }
                elseif ($Subtract) {
                    if ($currentByte - $restValue -lt 0) {
                        $ByteArrayGame[$o + ($i * $Interval)] = ($currentByte + 256 - $restValue)
                        $ByteArrayGame[$o + ($i * $Interval) - 1] -= 1
                    }
                    else { $ByteArrayGame[$o + ($i * $Interval)] -= $restValue }
                }
                else { $ByteArrayGame[$o + ($i * $Interval)] = $restValue }
            } while ($value -gt 0)
        }
    }

    # Write to File
    if (IsSet $File) { [System.IO.File]::WriteAllBytes($File, $ByteArrayGame) }
    return $True

}



#==============================================================================================================================================================================================
function MultiplyBytes([string]$File, [object]$Offset, [object]$Match=$null, [float]$Factor, [byte]$Min=0, [byte]$Max=0) {
    
    if (IsSet $File) {
        if (!(TestFile $File)) {
            WriteToConsole ("Could not find path to file to adjust: " + $File) -Error
            $global:WarningError = $True
            return $False
        }
        $ByteArrayGame = [System.IO.File]::ReadAllBytes($File)
    }

    if ($Match -is [String]) {
        if ($Match -like "* *")   { $matchDec = $Match -split ' '           | ForEach-Object { [Convert]::ToByte($_, 16) } }
        else                      { $matchDec = $Match -split '(..)' -ne '' | ForEach-Object { [Convert]::ToByte($_, 16) } }
    }
    elseif ($Match -is [Array] -and $Match[0] -is [String])   { $matchDec =   $Match | ForEach-Object { [Convert]::ToByte($_, 16) } }
    else                                                      { $matchDec = @($Match) }

    # Offset
    if ($Offset -is [String]) { $Offset = $Offset.Split(' ') }
    
    $offsetDec = New-Object System.Collections.Generic.List[UInt32]
    $offsets   = New-Object System.Collections.Generic.List[String]
    foreach ($o in $Offset) {
        $dec = if ($o -is [string]) { GetDecimal $o } else { $o }

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

        $offsetDec.Add($dec)
        $offsets.Add($o)
    }

    # Match
    if ($matchDec -ne $null) {
        $matchLength = $matchDec.Length
        foreach ($o in $offsetDec) {
            $endIndex = $o + $matchLength - 1 
            if ($endIndex -ge $ByteArrayGame.Length) {
                WriteToConsole "Match value is negative!" -Error
                return $False
            }
        
            $matchSlice = $ByteArrayGame[$o..$endIndex]
            if ($matchSlice -join '' -ne ($matchDec -join '')) { return $True }
        }
    }

    # Patch
    for ($i=0; $i -lt $offsetDec.Count; $i++) {
        $offset    = $offsetDec[$i]
        $byteValue = $ByteArrayGame[$offset]

        if ($Factor -eq 0) {
            WriteToConsole ("$($offsets[$i]) -> Set value " + (Get8Bit $byteValue) + " to: 1")
            $ByteArrayGame[$offset] = 1
            if ($Min -gt 0 -and $ByteArrayGame[$offset] -lt $Min) { $ByteArrayGame[$offset] = $Min }
        }
        elseif ($byteValue -gt 0) {
            WriteToConsole ("$($offsets[$i]) -> Multiplied value " + (Get8Bit $byteValue) + " by: $Factor")
            $ByteArrayGame[$offset] *= $Factor
            if     ($ByteArrayGame[$offset] -eq 0)                      { $ByteArrayGame[$offset] = 1    }
            elseif ($Max -gt 0 -and $ByteArrayGame[$offset] -gt $Max)   { $ByteArrayGame[$offset] = $Max }
            elseif ($Min -gt 0 -and $ByteArrayGame[$offset] -lt $Min)   { $ByteArrayGame[$offset] = $Min }
        }
    }

    # Write to File
    if (IsSet $File) { [System.IO.File]::WriteAllBytes($File, $ByteArrayGame) }
    return $True

}



#==============================================================================================================================================================================================
function CopyBytes([string]$File, [object]$Start, [object]$Length, [object]$Offset) {
    
    if (IsSet $File) {
        if (!(TestFile $File)) {
            WriteToConsole ("Could not find path to file to adjust: " + $File) -Error
            $global:WarningError = $True
            return $False
        }
        $ByteArrayGame = [System.IO.File]::ReadAllBytes($File) 
    }
    
    # Offset
    if ($Start  -is [string])   { $startDec  = GetDecimal $Start  } else { $startDec  = [int]$Start  }
    if ($Length -is [string])   { $lengthDec = GetDecimal $Length } else { $lengthDec = [int]$Length } 
    if ($Offset -is [string])   { $offsetDec = GetDecimal $Offset } else { $offsetDec = [int]$Offset } 
    
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
    WriteToConsole ((Get24Bit $offsetDec) + " -> Copying values: from " + (Get24Bit $startDec))
    for ($i = 0; $i -lt $lengthDec; $i++) { $ByteArrayGame[$offsetDec + $i] = $ByteArrayGame[$startDec + $i] }

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

    # Patch Length Handling
    if ($Length -is [string])                    { $lengthDec = GetDecimal $Length } else { $lengthDec = $Length }
    if ($lengthDec -le $PatchByteArray.Length)   { $lengthDec = $PatchByteArray.Length }

    # Patch Loop
    for ($i = 0; $i -lt $lengthDec; $i++) {
        if ($Settings.Debug.OverwriteChecks -eq $True -and $RunOverwriteChecks) {
            if ($OverwritechecksROM[$offsetDec + $i] -ne $ByteArrayGame[$offsetDec + $i]) {
                $global:OverwriteError = $True
                WriteToConsole ("Offset " + $Offset + " is overwritten: " + (Get8Bit $OverwritechecksROM[$offsetDec + $i]) + " -> " + (Get8Bit $ByteArrayGame[$offsetDec + $i])) -Error
            }
        }

        # Apply Patch or Padding
        if     ($i -lt $PatchByteArray.Length)   { $ByteArrayGame[$offsetDec + $i] = $PatchByteArray[$i] }
        elseif ($Pad)                            { $ByteArrayGame[$offsetDec + $i] = 255                 }
        else                                     { $ByteArrayGame[$offsetDec + $i] = 0                   }
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

    if ($values -is [String]) {
        if ($values -Like "* *")   { $values = $values -split '\s+'                               }
        else                       { $values = $values -split '(..)' | Where-Object { $_ -ne '' } }
    }
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



    $ValuesLength = $Values.Length
    $ByteArrayGameLength = $ByteArrayGame.Length

    for ($i = $Start; $i -lt $End; $i++) {
        $found = $True
        for ($j = 0; $j -lt $ValuesLength; $j++) {
            $value = $Values[$j]
            if ($value -ne "") {
                $valueDecimal = GetDecimal $value
                if ($ByteArrayGame[$i + $j] -ne $valueDecimal -and $value -ne "xx") {
                    $found = $False
                    break
                }
            }
        }

        if ($found) {
            if (!$Silent) { WriteToConsole ("Found values at: " + (Get32Bit $i)) }

            if ($Decimal)   { return $i          }
            else            { return Get32Bit $i }
        }
    }

    if (!$Silent) { WriteToConsole "Did not find searched values" -Error }
    return -1;

}



#==============================================================================================================================================================================================
function ExportAndPatch([string]$Path, [string]$Offset, [string]$Length, [string]$NewLength, [object]$TableOffset, [object]$Values) {
    
    $File = $GameFiles.extracted + "\" + $Path + ".bin"
    if ( !(TestFile $File) -or ($Settings.Debug.ForceExtract -eq $True) ) {
        ExportBytes -Offset $Offset -Length $Length -Output $File
        ApplyPatch -File $File -Patch (CheckPatchExtension -File ($GameFiles.export + "\" + $Path)) -FullPath
    }

    if (!(IsSet $NewLength))      { $NewLength = $Length }
    if ($NewLength -lt $Length)   { PatchBytes -Offset $Offset -Extracted -Patch ($Path + ".bin") -Length $Length }
    else                          { PatchBytes -Offset $Offset -Extracted -Patch ($Path + ".bin") -Length $NewLength }

    if ($TableOffset -ne $null -and $Values -ne $null) { ChangeBytes -Offset $TableOffset -Values $Values }

}



#==================================================================================================================================================================================================================================================================
function GetDecimal([string]$Hex) {
    
    $Hex = $Hex.Trim()
    if ($Hex -match '^[0-9A-Fa-f]+$') { return [uint32]("0x" + $Hex) }
    return -1

}



#==================================================================================================================================================================================================================================================================
function ConvertFloatToHex([string]$Float) {

    $bytes = [BitConverter]::GetBytes([single]$Float)
    [array]::Reverse($bytes)
    return ($bytes | ForEach-Object { "{0:X2}" -f $_ }) -join ""

}



#==================================================================================================================================================================================================================================================================
function ConvertHexToFloat([string]$Hex) {
    
    try {
        $value = [uint32]("0x" + $Hex)
        return [BitConverter]::ToSingle([BitConverter]::GetBytes($value), 0)
    }
    catch { return -1 }

}



#==================================================================================================================================================================================================================================================================
function CombineHex([string[]]$Hex) {
    
    $output = New-Object System.Text.StringBuilder
    foreach ($item in $Hex) { $null = $output.Append((Get8Bit $item)) }
    return $output.ToString()

}



#==================================================================================================================================================================================================================================================================
function IsNumber($Number) {

    $numericTypes = [Type]::GetTypeCode($Number.GetType())
    return $numericTypes -in @(3, 4, 5, 6, 7, 8, 9, 10)

}



#==================================================================================================================================================================================================================================================================
function Get8Bit([byte]$Value)                                 { return '{0:X2}' -f $Value }
function Get16Bit([uint16]$Value)                              { return '{0:X4}' -f $Value }
function Get24Bit([uint32]$Value)                              { return '{0:X6}' -f $Value }
function Get32Bit([uint32]$Value)                              { return '{0:X8}' -f $Value }
function AddToOffset([string]$Hex, [string]$Add)               { return (Get32Bit ( (GetDecimal $Hex) + (GetDecimal $Add)      ) ) }
function SubtractFromOffset([string]$Hex, [string]$Subtract)   { return (Get32Bit ( (GetDecimal $Hex) - (GetDecimal $Subtract) ) ) }



#==============================================================================================================================================================================================

(Get-Command -Module "Bytes") | % { Export-ModuleMember $_ }