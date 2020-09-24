function ChangeBytes([String]$File, [String]$Offset, [Array]$Values, [int]$Interval=1, [Switch]$IsDec) {

    if ($ExternalScript) { Write-Host "Change values:" $Values }
    if (IsSet -Elem $File) { $ByteArrayGame = [IO.File]::ReadAllBytes($File) }
    if ($Interval -lt 1) { $Interval = 1 }
    [uint32]$Offset = GetDecimal -Hex $Offset

    if ($Offset -lt 0) {
        Write-Host "Offset is negative!"
        return
    }
    elseif ($Offset -gt $ByteArrayGame.Length) {
        Write-Host "Offset is too large for file!"
        return
    }

    for ($i=0; $i -lt $Values.Length; $i++) {
        if ($IsDec)   { [Byte]$Value = $Values[$i] }
        else          { [Byte]$Value = GetDecimal -Hex $Values[$i] }
        $ByteArrayGame[$Offset + ($i * $Interval)] = $Value
    }

    if (IsSet -Elem $File) { [io.file]::WriteAllBytes($File, $ByteArrayGame) }
    $File = $Offset = $Interval = $Value = $null
    $Values = $null

}



#==============================================================================================================================================================================================
function PatchBytes([String]$File, [String]$Offset, [String]$Length, [String]$Patch, [Switch]$Texture, [Switch]$Pad) {
    
    if (IsSet -Elem $File) { $ByteArrayGame = [IO.File]::ReadAllBytes($File) }
    if ($Texture) {
        $PatchByteArray = [IO.File]::ReadAllBytes($GameFiles.textures + "\" + $Patch)
        if ($ExternalScript) { Write-Host "Patch file from:" ($GameFiles.textures + "\" + $Patch) }
    }
    else {
        $PatchByteArray = [IO.File]::ReadAllBytes($GameFiles.binaries + "\" + $Patch)
        if ($ExternalScript) { Write-Host "Patch file from:" ($GameFiles.binaries + "\" + $Patch) }
    }

    [uint32]$Offset = GetDecimal -Hex $Offset

    if ($Offset -lt 0) {
        Write-Host "Offset is negative!"
        return
    }
    elseif ($Offset -gt $ByteArrayGame.Length) {
        Write-Host "Offset is too large for file!"
        return
    }

    if (IsSet -Elem $Length) {
        [uint32]$Length = GetDecimal -Hex $Length
        for ($i=0; $i -lt $Length; $i++) {
            if ($i -le $PatchByteArray.Length)   { $ByteArrayGame[$Offset + $i] = $PatchByteArray[($i)] }
            elseif ($Pad)                        { $ByteArrayGame[$Offset + $i] = 255 }
            else                                 { $ByteArrayGame[$Offset + $i] = 0 }
        }
    }
    else {
        for ($i=0; $i -lt $PatchByteArray.Length; $i++) { $ByteArrayGame[$Offset + $i] = $PatchByteArray[($i)] }
    }

    if (IsSet -Elem $File) { [io.file]::WriteAllBytes($File, $ByteArrayGame) }
    $File = $Offset = $Length = $Patch = $PatchByteArray = $null

}



#==============================================================================================================================================================================================
function ExportBytes([String]$File, [String]$Offset, [String]$End, [String]$Length, [String]$Output) {
    
    if ($ExternalScript) { Write-Host "Write file to:" $Output }
    if (IsSet -Elem $File) { $ByteArrayGame = [IO.File]::ReadAllBytes($File) }
    [uint32]$Offset = GetDecimal -Hex $Offset

    if ($Offset -lt 0) {
        Write-Host "Offset is negative!"
        return
    }
    elseif ($Offset -gt $ByteArrayGame.Length) {
        Write-Host "Offset is too large for file!"
        return
    }

    if (IsSet -Elem $End) {
        [uint32]$End = GetDecimal -Hex $End
        [io.file]::WriteAllBytes($Output, $ByteArrayGame[$Offset..($End - 1)])
    }
    elseif (IsSet -Elem $Length) {
        [uint32]$Length = GetDecimal -Hex $Length
        [io.file]::WriteAllBytes($Output, $ByteArrayGame[$Offset..($Offset + $Length - 1)])
    }

    $File = $Offset = $Length = $Output = $NewArray = $null

}



#==============================================================================================================================================================================================
function SearchBytes([String]$File, [String]$Start="0", [String]$End, [Array]$Values) {
    
    if (IsSet -Elem $File) { $ByteArrayGame = [IO.File]::ReadAllBytes($File) }

    [uint32]$Start = GetDecimal -Hex $Start
    if (IsSet -Elem $End)   { [uint32]$End = GetDecimal -Hex $End }
    else                    { [uint32]$End = $ByteArrayGame.Length }

    if ($Start -lt 0 -or $End -lt 0) {
        Write-Host "Start or end offset is negative!"
        return
    }
    elseif ($Start -gt $ByteArrayGame.Length -or $End -gt $ByteArrayGame.Length) {
        Write-Host "Start or end offset is too large for file!"
        return
    }
    elseif ($Start -gt $End) {
        Write-Host "Start offset can not be greater than end offset"
        return
    }

    for ($i=$Start; $i -lt $End; $i++) {
        $Search = $True
        for ($j=0; $j -lt $Values.Length; $j++) {
            if ($Values[$j] -ne "") {
                if ($ByteArrayGame[$i + $j] -ne (GetDecimal -Hex $Values[$j]) ) {
                    $Search = $False
                    break
                }
            }
        }
        if ($Search -eq $True) {
            if ($ExternalScript) { Write-Host "Found values at:" (Get32Bit -Value $i) }
            return Get32Bit -Value $i
        }
    }

    Write-Host "Did not find searched values"
    return -1;

}



#==============================================================================================================================================================================================
function ExportAndPatch([String]$Path, [String]$Offset, [String]$Length, [String]$NewLength, [String]$TableOffset, [Array]$Values) {

    $File = $GameFiles.binaries + "\" + $Path + ".bin"
    if (!(Test-Path -LiteralPath $File -PathType Leaf)) {
        ExportBytes -Offset $Offset -Length $Length -Output $File
        ApplyPatch -File $File -Patch ("\Data Extraction\" + $Path + ".bps") -FilesPath
    }

    if (!(IsSet -Elem $NewLength)) { $NewLength = $Length }
    if ($NewLength -lt $Length)   { PatchBytes -Offset $Offset -Patch ($Path + ".bin") -Length $Length }
    else                          { PatchBytes -Offset $Offset -Patch ($Path + ".bin") -Length $NewLength }

    if ( (IsSet -Elem $TableOffset) -and (IsSet -Elem $Values) ) {
        ChangeBytes -Offset $TableOffset -Values $Values
    }

}



#==================================================================================================================================================================================================================================================================
function GetDecimal([String]$Hex)   { return [uint32]("0x" + $Hex) }
function Get8Bit($Value)            { return '{0:X2}' -f [int]$Value }
function Get16Bit($Value)           { return '{0:X4}' -f [int]$Value }
function Get24Bit($Value)           { return '{0:X6}' -f [int]$Value }
function Get32Bit($Value)           { return '{0:X8}' -f [int]$Value }


#==============================================================================================================================================================================================

Export-ModuleMember -Function ChangeBytes
Export-ModuleMember -Function PatchBytes
Export-ModuleMember -Function ExportBytes
Export-ModuleMember -Function SearchBytes
Export-ModuleMember -Function ExportAndPatch

Export-ModuleMember -Function GetDecimal
Export-ModuleMember -Function Get8Bit
Export-ModuleMember -Function Get16Bit
Export-ModuleMember -Function Get24Bit
Export-ModuleMember -Function Get32Bit