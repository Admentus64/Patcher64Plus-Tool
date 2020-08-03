function ChangeBytes([String]$File, [String]$Offset, [Array]$Values, [int]$Interval=1, [Switch]$IsDec) {

    if ($ExternalScript) { Write-Host "Change values:" $Values }

    if (IsSet -Elem $File) { $ByteArrayGame = [IO.File]::ReadAllBytes($File) }
    if ($Interval -lt 1) { $Interval = 1 }
    [uint32]$Offset = GetDecimal -Hex $Offset

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
function PatchBytes([String]$File, [String]$Offset, [String]$Length, [String]$Patch, [Switch]$Texture) {

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

    if (IsSet -Elem $Length) {
        [uint32]$Length = GetDecimal -Hex $Length
        for ($i=0; $i -lt $Length; $i++) {
            if ($i -le $PatchByteArray.Length)   { $ByteArrayGame[$Offset + $i] = $PatchByteArray[($i)] }
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
function ExportAndPatch([String]$Path, [String]$Offset, [String]$Length) {

    $File = $GameFiles.binaries + "\" + $Path + ".bin"
    if (!(Test-Path -LiteralPath $File -PathType Leaf)) {
        ExportBytes -Offset $Offset -Length $Length -Output $File
        ApplyPatch -File $File -Patch ("\Data Extraction\" + $Path + ".bps") -FilesPath
    }
    PatchBytes  -Offset $Offset -Patch ($Path + ".bin")

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
Export-ModuleMember -Function ExportAndPatch

Export-ModuleMember -Function GetDecimal
Export-ModuleMember -Function Get8Bit
Export-ModuleMember -Function Get16Bit
Export-ModuleMember -Function Get24Bit
Export-ModuleMember -Function Get32Bit