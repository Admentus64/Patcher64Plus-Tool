function PatchModel([string]$Category, [string]$Name) {

    $global:ModelPatchingError = $False

    $folders = Get-ChildItem $Paths.Models
    if ($Category -eq "Child") { $folder = $GamePatch.LoadedModel["Child"].folder } else { $folder = $GamePatch.LoadedModel["Adult"].folder }
    
    $path    = $Paths.Models + "\" + $folder
    $subpath = $path + "\" + $GameType.mode + " - " + $Category
    $file    = $subpath + "\" + $Name
    
    if (TestFile ($file + ".zobj"))   {
        if     (TestFile ($file + ".txt"))                                     { $manifest = $file + ".txt" }
        elseif (TestFile ($subpath + "\Manifest\" + $GameRev.name + ".txt"))   { $manifest = $subpath + "\Manifest\" + $GameRev.name + ".txt" }
        else                                                                   { $manifest = $Paths.Models + "\Core\Manifests\" + $GameType.mode + " - " + $Category + "\" + $GameRev.name + ".txt" }

        if     (TestFile ($file + ".opt"))                                     { $optimized = $file + ".opt" }
        elseif (TestFile ($subpath + "\Manifest\Optimized.opt"))               { $optimized = $subpath + "\Manifest\Optimized.opt" }
        else                                                                   { $optimized = $Paths.Models + "\Core\Manifests\" + $GameType.mode + " - " + $Category + "\Optimized.opt" }

        write-host $manifest
        write-host $optimized

        $script = { Param([string]$Tool, [string]$Model, [string]$File, [string]$Path, [string]$Manifest, [string]$Optimized)
            & $Tool playas -i ($Model + ".zobj") -r $File -o ($Path + "\model") -m $Manifest -b $Optimized | Out-Null
        }
        Start-Job    -Name "Script" -ScriptBlock $script -ArgumentList @($Files.tool.zzobjman, $file, $GetROM.decomp, $Paths.Temp, $manifest, $optimized)
        StartJobLoop -Name "Script"

        if (TestFile ($Paths.Temp + "\model.z64")) {
            Move-Item -LiteralPath ($Paths.Temp + "\model.z64") -Destination $GetROM.decomp -Force
            WriteToConsole ("Applied ZOBJ model PlayAs: " + $Name)
        }
        else {
            WriteToConsole ("Could not patch in custom model: " + $Name) -Error
            $global:ModelPatchingError = $True
        }
    }

    elseif (TestFile ($file + ".ppf")) {
        ApplyPatch -Patch ($file + ".ppf") -FullPath
        WriteToConsole ("Applied PPF model patch: " + $Name)
    }
    else {
        WriteToConsole ("Could not find custom model to patch: " + $Name) -Error
        $global:ModelPatchingError = $True
    }

}



#==============================================================================================================================================================================================
function GetOoTShopItem([string]$Item) {
    
    foreach ($entry in $Files.json.shopItems.items) {
        if ($entry.title -eq $Item) { return (Get16Bit $entry.index) }
    }
    return "0000"

}



#==============================================================================================================================================================================================
function GetOoTCollision([switch]$DekuNut, [switch]$DekuStick, [switch]$Slingshot, [switch]$Bomb, [switch]$Boomerang, [switch]$Arrow, [switch]$HammerSwing, [switch]$Hookshot, [switch]$KokiriSlash, [switch]$MasterSlash, [switch]$GiantSlash, [switch]$ArrowFire, [switch]$ArrowIce, [switch]$ArrowLight,
[switch]$ArrowUnknown1, [switch]$ArrowUnknown2, [switch]$ArrowUnknown3, [switch]$MagicFire, [switch]$MagicIce, [switch]$MagicLight, [switch]$Shield, [switch]$MirrorRay, [switch]$KokiriSpin, [switch]$MasterSpin, [switch]$GiantSpin, [switch]$KokiriJump, [switch]$MasterJump, [switch]$GiantJump,
[switch]$Unknown1, [switch]$HammerJump, [switch]$Unknown2) {
    
    $value = 0

    if ($DekuNut)         { $value +=        0x1 }
    if ($DekuStick)       { $value +=        0x2 }
    if ($Slingshot)       { $value +=        0x4 }
    if ($Bomb)            { $value +=        0x8 }
    if ($Boomerang)       { $value +=       0x10 }
    if ($Arrow)           { $value +=       0x20 }
    if ($HammerSwing)     { $value +=       0x40 }
    if ($Hookshot)        { $value +=       0x80 }
    if ($KokiriSlash)     { $value +=      0x100 }
    if ($MasterSlash)     { $value +=      0x200 }
    if ($GiantSlash)      { $value +=      0x400 }
    if ($ArrowFire)       { $value +=      0x800 }
    if ($ArrowIce)        { $value +=     0x1000 }
    if ($ArrowLight)      { $value +=     0x2000 }
    if ($ArrowUnknown1)   { $value +=     0x4000 }
    if ($ArrowUnknown2)   { $value +=     0x8000 }
    if ($ArrowUnknown3)   { $value +=    0x10000 }
    if ($MagicFire)       { $value +=    0x20000 }
    if ($MagicIce)        { $value +=    0x40000 }
    if ($MagicLight)      { $value +=    0x80000 }
    if ($Shield)          { $value +=   0x100000 }
    if ($MirrorRay)       { $value +=   0x200000 }
    if ($KokiriSpin)      { $value +=   0x400000 }
    if ($GiantSpin)       { $value +=   0x800000 }
    if ($MasterSpin)      { $value +=  0x1000000 }
    if ($KokiriJump)      { $value +=  0x2000000 }
    if ($GiantJump)       { $value +=  0x4000000 }
    if ($MasterJump)      { $value +=  0x8000000 }
    if ($Unknown1)        { $value += 0x10000000 }
    if ($HammerJump)      { $value += 0x20000000 }
    if ($Unknown2)        { $value += 0x40000000 }

    return (Get32Bit $value)

}



#==============================================================================================================================================================================================
function GetButtonScale([byte]$Size) {

    switch ($Size) {
        31      { return Get16Bit 525  }
        30      { return Get16Bit 550  } # Official
        29      { return Get16Bit 575  } # Official
        28      { return Get16Bit 605  }
        27      { return Get16Bit 620  } # Official
        26      { return Get16Bit 640  }
        25      { return Get16Bit 660  }
        24      { return Get16Bit 680  } # Official
        23      { return Get16Bit 705  }
        22      { return Get16Bit 735  }
        21      { return Get16Bit 770  }
        20      { return Get16Bit 810  }
        19      { return Get16Bit 860  }
        18      { return Get16Bit 910  }
        17      { return Get16Bit 960  }
        16      { return Get16Bit 1020 }
        15      { return Get16Bit 1090 }
        14      { return Get16Bit 1175 }
        13      { return Get16Bit 1270 }
        12      { return Get16Bit 1370 }
        11      { return Get16Bit 1480 }
        10      { return Get16Bit 1620 }
        9       { return Get16Bit 1780 }
        Default { return Get16Bit 550  }
    }

}



#==============================================================================================================================================================================================
function SetMMCUpTextCoords([int16]$X, [int16]$Y) {

    if ($X -ne 0) {
        if (IsChecked $Redux.Graphics.Widescreen) {
            $tens = [math]::Truncate($X / 4)
            $ones = $X % 4

            while ($ones -gt 0) {
                if ($ByteArrayGame[(GetDecimal "BADD2A")] -lt 0xC0) { $ByteArrayGame[(GetDecimal "BADD2A")] += 0x40 }
                else {
                    $ByteArrayGame[(GetDecimal "BADD2A")] -= 0xC0
                    $ByteArrayGame[(GetDecimal "BADD27")] += 1;
                }
                if ($ByteArrayGame[(GetDecimal "BADD32")] -lt 0xC0) { $ByteArrayGame[(GetDecimal "BADD32")] += 0x40 }
                else {
                    $ByteArrayGame[(GetDecimal "BADD32")] -= 0xC0
                    $ByteArrayGame[(GetDecimal "BADD2F")] += 1;
                }
                $ones--
            }

            while ($ones -lt 0) {
                if ($ByteArrayGame[(GetDecimal "BADD2A")] -ge 0x40) { $ByteArrayGame[(GetDecimal "BADD2A")] -= 0x40 }
                else {
                    $ByteArrayGame[(GetDecimal "BADD2A")] += 0xC0
                    $ByteArrayGame[(GetDecimal "BADD27")] -= 1;
                }
                if ($ByteArrayGame[(GetDecimal "BADD32")] -ge 0x40) { $ByteArrayGame[(GetDecimal "BADD32")] -= 0x40 }
                else {
                    $ByteArrayGame[(GetDecimal "BADD32")] += 0xC0
                    $ByteArrayGame[(GetDecimal "BADD2F")] -= 1;
                }
                $ones++
            }

            while ($tens -gt 0) {
                $ByteArrayGame[(GetDecimal "BADD27")] += 1
                $ByteArrayGame[(GetDecimal "BADD2F")] += 1;
                $tens--
            }
            
            while ($tens -lt 0) {
                $ByteArrayGame[(GetDecimal "BADD27")] -= 1
                $ByteArrayGame[(GetDecimal "BADD2F")] -= 1;
                $tens++
            }
        }
        else {
            $tens = [math]::Truncate($X / 16)
            $ones = $X % 16

            while ($ones -gt 0) {
                if ($ByteArrayGame[(GetDecimal "BADD36")] -lt 0xF0) { $ByteArrayGame[(GetDecimal "BADD36")] += 0x10 }
                else {
                    $ByteArrayGame[(GetDecimal "BADD36")] -= 0xF0
                    $ByteArrayGame[(GetDecimal "BADD27")] += 1;
                }
                if ($ByteArrayGame[(GetDecimal "BADD3A")] -lt 0xF0) { $ByteArrayGame[(GetDecimal "BADD3A")] += 0x10 }
                else {
                    $ByteArrayGame[(GetDecimal "BADD3A")] -= 0xF0
                    $ByteArrayGame[(GetDecimal "BADD2B")] += 1;
                }
                $ones--
            }
            
            while ($ones -lt 0) {
                if ($ByteArrayGame[(GetDecimal "BADD36")] -ge 0x10) { $ByteArrayGame[(GetDecimal "BADD36")] -= 0x10 }
                else {
                    $ByteArrayGame[(GetDecimal "BADD36")] += 0xF0
                    $ByteArrayGame[(GetDecimal "BADD27")] -= 1;
                }
                if ($ByteArrayGame[(GetDecimal "BADD3A")] -ge 0x10) { $ByteArrayGame[(GetDecimal "BADD3A")] -= 0x10 }
                else {
                    $ByteArrayGame[(GetDecimal "BADD3A")] += 0xF0
                    $ByteArrayGame[(GetDecimal "BADD2B")] -= 1;
                }
                $ones++
            }
            
            while ($tens -gt 0) {
                $ByteArrayGame[(GetDecimal "BADD27")] += 1
                $ByteArrayGame[(GetDecimal "BADD2B")] += 1;
                $tens--
            }
            
            while ($tens -lt 0) {
                $ByteArrayGame[(GetDecimal "BADD27")] -= 1
                $ByteArrayGame[(GetDecimal "BADD2B")] -= 1;
                $tens++
            }
        }
    }

    if ($Y -ne 0 -and $Y -gt -0x48) {
        if (IsChecked $Redux.Graphics.Widescreen) {
            $hundreds = [math]::Truncate($Y / 100)
            $ones     = $Y % 100

            while ($ones -gt 0) {
                if ($ByteArrayGame[(GetDecimal "BADD33")] -lt 0xFF) { $ByteArrayGame[(GetDecimal "BADD33")] += 1 }
                else {
                    $ByteArrayGame[(GetDecimal "BADD33")] -= 0xFF
                    $ByteArrayGame[(GetDecimal "BADD32")] += 1;
                }
                if ($ByteArrayGame[(GetDecimal "BADD2B")] -lt 0xFF) { $ByteArrayGame[(GetDecimal "BADD2B")] += 1 }
                else {
                    $ByteArrayGame[(GetDecimal "BADD2B")] -= 0xFF
                    $ByteArrayGame[(GetDecimal "BADD2A")] += 1;
                }
                $ones--;
            }

            while ($ones -lt 0) {
                $ByteArrayGame[(GetDecimal "BADD33")]--
                $ByteArrayGame[(GetDecimal "BADD2B")]--
                $ones++;
            }

            while ($hundreds -gt 0) {
                $ByteArrayGame[(GetDecimal "BADD32")]++
                $ByteArrayGame[(GetDecimal "BADD2A")]++
                $hundreds--;
            }
        }
        else {
            $hundreds = [math]::Truncate($Y / 100)
            $ones     = $Y % 100

            while ($ones -gt 0) {
                if ($ByteArrayGame[(GetDecimal "BADD37")] -lt 0xFF) { $ByteArrayGame[(GetDecimal "BADD37")] += 1 }
                else {
                        $ByteArrayGame[(GetDecimal "BADD37")] -= 0xFF
                        $ByteArrayGame[(GetDecimal "BADD36")] += 1;
                    }
                if ($ByteArrayGame[(GetDecimal "BADD3B")] -lt 0xFF) { $ByteArrayGame[(GetDecimal "BADD3B")] += 1 }
                else {
                    $ByteArrayGame[(GetDecimal "BADD3B")] -= 0xFF
                    $ByteArrayGame[(GetDecimal "BADD3A")] += 1;
                }
                $ones--;
            }

            while ($ones -lt 0) {
                $ByteArrayGame[(GetDecimal "BADD37")]--
                $ByteArrayGame[(GetDecimal "BADD3B")]--
                $ones++;
            }

            while ($hundreds -gt 0) {
                $ByteArrayGame[(GetDecimal "BADD36")]++
                $ByteArrayGame[(GetDecimal "BADD3A")]++
                $hundreds--;
            }
        }
    }

}



#==============================================================================================================================================================================================
function GetOoTEntranceIndex([string]$Index) {

    if     ($index -eq "Link's House")               { return "00 BB" }     elseif ($index -eq "Temple of Time")             { return "05 F4" }     elseif ($index -eq "Hyrule Field")               { return "01 FD" }
    elseif ($index -eq "Hyrule Castle")              { return "01 38" }     elseif ($index -eq "Ganon's Castle")             { return "01 3A" }     elseif ($index -eq "Goron City")                 { return "01 4D" }
    elseif ($index -eq "Zora's Domain")              { return "01 08" }     elseif ($index -eq "Gerudo Valley")              { return "01 17" }     elseif ($index -eq "Lon Lon Ranch")              { return "01 57" }
    elseif ($index -eq "Kakariko Village")           { return "00 DB" }     elseif ($index -eq "Inside the Deku Tree")       { return "00 00" }     elseif ($index -eq "Dodongo's Cavern")           { return "00 04" }
    elseif ($index -eq "Inside Jabu-Jabu's Belly")   { return "00 28" }     elseif ($index -eq "Forest Temple")              { return "01 69" }     elseif ($index -eq "Fire Temple")                { return "01 65" }
    elseif ($index -eq "Water Temple")               { return "00 10" }     elseif ($index -eq "Shadow Temple")              { return "00 82" }     elseif ($index -eq "Spirit Temple")              { return "00 37" }
    elseif ($index -eq "Ice Cavern")                 { return "00 88" }     elseif ($index -eq "Bottom of the Well")         { return "00 98" }     elseif ($index -eq "Thieves' Hideout")           { return "04 86" }
    elseif ($index -eq "Gerudo's Training Ground")   { return "00 08" }     elseif ($index -eq "Inside Ganon's Castle")      { return "04 67" }     elseif ($index -eq "Ganon's Tower")              { return "04 1B" }
    else {
        WriteToConsole ("Could not find entrance index ID for: " + $index) -Error
        return -1
    }

}



#==============================================================================================================================================================================================
function GetSFXID([string]$SFX) {
    
    $SFX = $SFX.replace(' (default)', "")
    if     ($SFX -eq "None" -or $SFX -eq "Disabled")   { return "00 00" }
    elseif ($SFX -eq "Armos")                          { return "38 48" }     elseif ($SFX -eq "Bark")                    { return "28 D8" }     elseif ($SFX -eq "Bomb Bounce")             { return "28 2F" }
    elseif ($SFX -eq "Bongo Bongo High")               { return "39 51" }     elseif ($SFX -eq "Bongo Bongo Low")         { return "39 50" }     elseif ($SFX -eq "Bottle Cork")             { return "28 6C" }
    elseif ($SFX -eq "Bow Twang")                      { return "18 30" }     elseif ($SFX -eq "Bubble Laugh")            { return "38 CA" }     elseif ($SFX -eq "Business Scrub")          { return "38 82" }
    elseif ($SFX -eq "Carrot Refill")                  { return "48 45" }     elseif ($SFX -eq "Cartoon Fall")            { return "28 A0" }     elseif ($SFX -eq "Change Item")             { return "08 35" }
    elseif ($SFX -eq "Chest Open")                     { return "28 20" }     elseif ($SFX -eq "Child Cringe")            { return "68 3A" }     elseif ($SFX -eq "Child Gasp")              { return "68 36" }
    elseif ($SFX -eq "Child Hurt")                     { return "68 25" }     elseif ($SFX -eq "Child Owo")               { return "68 23" }     elseif ($SFX -eq "Child Pant")              { return "68 29" }
    elseif ($SFX -eq "Child Scream")                   { return "68 28" }     elseif ($SFX -eq "Cluck")                   { return "28 12" }     elseif ($SFX -eq "Cockadoodledoo")          { return "28 13" }
    elseif ($SFX -eq "Cursed Attack")                  { return "68 68" }     elseif ($SFX -eq "Cursed Scream")           { return "68 67" }     elseif ($SFX -eq "Deku Baba")               { return "38 60" }
    elseif ($SFX -eq "Drawbridge Set")                 { return "28 0E" }     elseif ($SFX -eq "Dusk Howl")               { return "28 AE" }     elseif ($SFX -eq "Epona (Young)")           { return "28 44" }
    elseif ($SFX -eq "Exploding Crate")                { return "28 39" }     elseif ($SFX -eq "Explosion")               { return "18 0E" }     elseif ($SFX -eq "Fanfare (Light)")         { return "48 24" }
    elseif ($SFX -eq "Fanfare (Medium)")               { return "48 31" }     elseif ($SFX -eq "Field Shrub")             { return "28 77" }     elseif ($SFX -eq "Flare Dancer Laugh")      { return "39 81" }
    elseif ($SFX -eq "Flare Dancer Startled")          { return "39 8B" }     elseif ($SFX -eq 'Ganondorf "Teh!"')        { return "39 CA" }     elseif ($SFX -eq "Gohma Lava Croak")        { return "39 5D" }
    elseif ($SFX -eq "Gold Skull Token")               { return "48 43" }     elseif ($SFX -eq "Goron Wake")              { return "38 FC" }     elseif ($SFX -eq "Great Fairy")             { return "68 58" }
    elseif ($SFX -eq "Guay")                           { return "38 B6" }     elseif ($SFX -eq "Gunshot")                 { return "48 35" }     elseif ($SFX -eq "Hammer Bonk")             { return "18 0A" }
    elseif ($SFX -eq "Horse Neigh")                    { return "28 05" }     elseif ($SFX -eq "Horse Trot")              { return "28 04" }     elseif ($SFX -eq "Hover Boots")             { return "08 C9" }
    elseif ($SFX -eq "HP Low")                         { return "48 1B" }     elseif ($SFX -eq "HP Recover")              { return "48 0B" }     elseif ($SFX -eq "Ice Shattering")          { return "08 75" }
    elseif ($SFX -eq "Ingo Wooah")                     { return "68 54" }     elseif ($SFX -eq "Ingo Kaah!")              { return "68 55" }     elseif ($SFX -eq "Iron Boots")              { return "08 0D" }
    elseif ($SFX -eq "Iron Knuckle")                   { return "39 29" }     elseif ($SFX -eq "Moblin Club Ground")      { return "38 E1" }     elseif ($SFX -eq "Moblin Club Swing")       { return "39 EF" }
    elseif ($SFX -eq "Moo")                            { return "28 DF" }     elseif ($SFX -eq "Mweep!")                  { return "68 7A" }     elseif ($SFX -eq 'Navi "Hello!"')           { return "68 44" }
    elseif ($SFX -eq 'Navi "Hey!"')                    { return "68 5F" }     elseif ($SFX -eq "Navi Random")             { return "68 43" }     elseif ($SFX -eq "Notification")            { return "48 20" }
    elseif ($SFX -eq "Phantom Ganon Laugh")            { return "38 B0" }     elseif ($SFX -eq "Plant Explode")           { return "28 4E" }     elseif ($SFX -eq "Poe")                     { return "38 EC" }
    elseif ($SFX -eq "Pot Shattering")                 { return "28 87" }     elseif ($SFX -eq "Redead Moan")             { return "38 E4" }     elseif ($SFX -eq "Redead Screan")           { return "38 E5" }
    elseif ($SFX -eq "Ribbit")                         { return "28 B1" }     elseif ($SFX -eq "Rupee")                   { return "48 03" }     elseif ($SFX -eq "Rupee (Silver)")          { return "28 E8" }
    elseif ($SFX -eq "Ruto Crash")                     { return "68 60" }     elseif ($SFX -eq "Ruto Excited")            { return "68 61" }     elseif ($SFX -eq "Ruto Giggle")             { return "68 63" }
    elseif ($SFX -eq "Ruto Lift")                      { return "68 74" }     elseif ($SFX -eq "Ruto Thrown")             { return "68 65" }     elseif ($SFX -eq "Ruto Wiggle")             { return "68 66" }
    elseif ($SFX -eq "Scrub Emerge")                   { return "38 7C" }     elseif ($SFX -eq "Shabom Bounce")           { return "39 48" }     elseif ($SFX -eq "Shabom Pop")              { return "39 49" }
    elseif ($SFX -eq "Shellblade")                     { return "38 49" }     elseif ($SFX -eq "Skultula")                { return "39 DA" }     elseif ($SFX -eq "Soft Beep")               { return "48 04" }
    elseif ($SFX -eq "Spike Trap")                     { return "38 E9" }     elseif ($SFX -eq "Spit Nut")                { return "38 7E" }     elseif ($SFX -eq "Stalchild Attack")        { return "38 31" }
    elseif ($SFX -eq "Stinger Squeak")                 { return "39 A3" }     elseif ($SFX -eq "Switch")                  { return "28 15" }     elseif ($SFX -eq "Sword Bonk")              { return "18 1A" }
    elseif ($SFX -eq "Talon Cry")                      { return "68 53" }     elseif ($SFX -eq 'Talon "Hmm"')             { return "68 52" }     elseif ($SFX -eq "Talon Snore")             { return "68 50" }
    elseif ($SFX -eq "Talon WTF")                      { return "68 51" }     elseif ($SFX -eq "Tambourine")              { return "48 42" }     elseif ($SFX -eq "Target Enemy")            { return "48 30" }
    elseif ($SFX -eq "Target Neutral")                 { return "48 0C" }     elseif ($SFX -eq "Thunder")                 { return "28 2E" }     elseif ($SFX -eq "Timer")                   { return "48 1A" }
    elseif ($SFX -eq "Twinrova Bicker")                { return "39 E7" }     elseif ($SFX -eq "Wolfos Howl")             { return "38 3C" }     elseif ($SFX -eq "Zelda Gasp (Adult)")      { return "68 79" }
    else {
        WriteToConsole ("Could not find sound ID for: " + $SFX) -Error
        return -1
    }

}



#==============================================================================================================================================================================================
function GetMMItemID([string]$Item) {
    
    $Item = $Item.replace(' (default)', "")
    if     ($Item -eq "None" -or $Item -eq "Disabled")   { return "FF" }
    elseif ($Item -eq "Ocarina of Time")                 { return "00" }   elseif ($Item -eq "Hero's Bow")               { return "01" }   elseif ($Item -eq "Fire Arrow")                 { return "02" }
    elseif ($Item -eq "Ice Arrow")                       { return "03" }   elseif ($Item -eq "Light Arrow")              { return "04" }   elseif ($Item -eq "Fairy Ocarina")              { return "05" }
    elseif ($Item -eq "Bomb")                            { return "06" }   elseif ($Item -eq "Bombchu")                  { return "07" }   elseif ($Item -eq "Deku Stick")                 { return "08" }
    elseif ($Item -eq "Deku Nut")                        { return "09" }   elseif ($Item -eq "Magic Beans")              { return "0A" }   elseif ($Item -eq "Fairy Slingshot")            { return "0B" }
    elseif ($Item -eq "Powder Keg")                      { return "0C" }   elseif ($Item -eq "Pictograph Box")           { return "0D" }   elseif ($Item -eq "Lens of Truth")              { return "0E" }
    elseif ($Item -eq "Hookshot")                        { return "0F" }   elseif ($Item -eq "Great Fairy's Sword")      { return "10" }   elseif ($Item -eq "OoT Hookshot")               { return "11" }
    elseif ($Item -eq "Deku Mask")                       { return "32" }   elseif ($Item -eq "Goron Mask")               { return "33" }   elseif ($Item -eq "Zora Mask")                  { return "34" }
    elseif ($Item -eq "Fierce Deity's Mask")             { return "35" }   elseif ($Item -eq "Mask of Truth")            { return "36" }   elseif ($Item -eq "Kafei's Mask")               { return "37" }
    elseif ($Item -eq "All-Night Mask")                  { return "38" }   elseif ($Item -eq "Bunny Hood")               { return "39" }   elseif ($Item -eq "Keaton Mask")                { return "3A" }
    elseif ($Item -eq "Garo's Mask")                     { return "3B" }   elseif ($Item -eq "Romani's Mask")            { return "3C" }   elseif ($Item -eq "Circus Leader's Mask")       { return "3D" }
    elseif ($Item -eq "Postman's Hat")                   { return "3E" }   elseif ($Item -eq "Couple's Mask")            { return "3F" }   elseif ($Item -eq "Great Fairy's Mask")         { return "40" }
    elseif ($Item -eq "Gibdo Mask")                      { return "41" }   elseif ($Item -eq "Don Gero's Mask")          { return "42" }   elseif ($Item -eq "Kamaro's Mask")              { return "43" }
    elseif ($Item -eq "Captain's hat")                   { return "44" }   elseif ($Item -eq "Stone Mask")               { return "45" }   elseif ($Item -eq "Bremen Mask")                { return "46" }
    elseif ($Item -eq "Blast Mask")                      { return "47" }   elseif ($Item -eq "Mask of Scents")           { return "48" }   elseif ($Item -eq "Giant's Mask")               { return "49" }
    elseif ($Item -eq "Hero's Bow + Fire Arrow")         { return "4A" }   elseif ($Item -eq "Hero's Bow + Ice Arrow")   { return "4B" }   elseif ($Item -eq "Hero's Bow + Light Arrow")   { return "4C" }
    elseif ($Item -eq "Kokiri Sword")                    { return "4D" }   elseif ($Item -eq "Razor Sword")              { return "4E" }   elseif ($Item -eq "Gilded Sword")               { return "4F" }
    elseif ($Item -eq "Double Helix Sword")              { return "50" }   elseif ($Item -eq "Hero's Shield")            { return "51" }   elseif ($Item -eq "Mirror Shield")              { return "52" }
    else {
        WriteToConsole ("Could not find item ID for : " + $Item) -Error
        return -1
    }

}



#==============================================================================================================================================================================================
function GetMMInstrumentID([string]$SFX) {
    
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
        WriteToConsole ("Could not find SFX ID for : " + $Item) -Error
        return -1
    }

}



#==============================================================================================================================================================================================
function PatchMuteMusic([string]$SequenceTable, [string]$Sequence, [byte]$Length) {
    
    if ( (IsChecked $Redux.MuteMusic.MuteSelected -Not) -and (IsChecked $Redux.MuteMusic.MuteAreaOnly -Not) -and (IsChecked $Redux.MuteMusic.MuteAll -Not) ) { return }

    UpdateStatusLabel "Muting Music Sequences"

    $include = $force = @()
    foreach ($i in 0..($Files.json.music.tracks.Count-1)) {
        if ( ( (!(IsSet $GameSettings["ReplaceMusic"][$Files.json.music.tracks[$i].title]) -or $GameSettings["ReplaceMusic"][$Files.json.music.tracks[$i].title] -eq "Default") -and (IsChecked $Redux.ReplaceMusic.EnableReplace) ) -or (IsChecked -Elem $Redux.ReplaceMusic.EnableReplace -Not) ) {
            if     (IsChecked $Redux.MuteMusic.MuteSelected)   { if ($Redux.MuteMusic.Tracks.GetSelected($i))       { foreach ($id in $Files.json.music.tracks[$i].id) { $include += (GetDecimal $id) }; foreach ($id in $Files.json.music.tracks[$i].muteId) { $include += (GetDecimal $id) } } }
            elseif (IsChecked $Redux.MuteMusic.MuteAreaOnly)   { if (!(IsSet $Files.json.music.tracks[$i].event))   { foreach ($id in $Files.json.music.tracks[$i].id) { $include += (GetDecimal $id) }; foreach ($id in $Files.json.music.tracks[$i].muteId) { $include += (GetDecimal $id) } } }
            elseif (IsChecked $Redux.MuteMusic.MuteAll)                                                             { foreach ($id in $Files.json.music.tracks[$i].id) { $include += (GetDecimal $id) }; foreach ($id in $Files.json.music.tracks[$i].muteId) { $include += (GetDecimal $id) } }
        }
    }

    $tableStart = GetDecimal $SequenceTable
    for ($i=1; $i -le $Length; $i++) { if ($include -contains $i) { ChangeBytes -Offset (Get24Bit ($tableStart + $i * 16) ) -Values "00 00 00 00 00 00 00 00 00 00" } }

}



    
#==============================================================================================================================================================================================
function PatchReplaceMusic([string]$BankPointerTableStart, [string]$BankPointerTableEnd, [string]$PointerTableStart, [string]$PointerTableEnd, [string]$SeqStart, [string]$SeqEnd) {

    if (IsChecked -Elem $Redux.ReplaceMusic.EnableReplace -Not) { return }

    UpdateStatusLabel "Patching Music Sequences"

    $bankPointerTable = $GameFiles.extracted + "\AudiobankPointerTable.bin"; ExportBytes -Offset $BankPointerTableStart  -End $BankPointerTableEnd -Output $bankPointerTable -Force
    $pointerTable     = $GameFiles.extracted + "\AudioPointerTable.bin";     ExportBytes -Offset $PointerTableStart      -End $PointerTableEnd     -Output $pointerTable     -Force
    $seq              = $GameFiles.extracted + "\Audioseq.bin";              ExportBytes -Offset $SeqStart               -End $SeqEnd              -Output $seq              -Force

    $bankPointerTableArray = [System.IO.File]::ReadAllBytes($bankPointerTable)
    $pointerTableArray     = [System.IO.File]::ReadAllBytes($pointerTable)

    foreach ($track in $Files.json.music.tracks) {
        if (IsSet $GameSettings["ReplaceMusic"][$track.title]) {
            if ($GameSettings["ReplaceMusic"][$track.title] -ne "Default") {
                # Music File
                foreach ($folder in (Get-ChildItem -LiteralPath $Paths.Music -Directory)) {
                    foreach ($item in (Get-ChildItem -LiteralPath ($Paths.Music + "\" + $folder.BaseName) -Directory)) {
                        if (TestFile ($Paths.Music + "\" + $folder.BaseName + "\" + $item.BaseName + "\" + $GameSettings["ReplaceMusic"][$track.title] + ".seq")) { # .seq
                            $file = $folder.BaseName + "\" + $item.BaseName + "\" + $GameSettings["ReplaceMusic"][$track.title]
                            $ext  = ".seq"
                            break
                        }
                        elseif (TestFile ($Paths.Music + "\" + $folder.BaseName + "\" + $item.BaseName + "\" + $GameSettings["ReplaceMusic"][$track.title] + ".zseq")) { # .zseq
                            $file = $folder.BaseName + "\" + $item.BaseName + "\" + $GameSettings["ReplaceMusic"][$track.title]
                            $ext  = ".zseq"
                            break
                        }
                    }
                }

                # Sequence
                foreach ($id in $track.id) {
                    $tableOffset = ( (GetDecimal $id) * 16)
                    $offset      = (Get8Bit $pointerTableArray[$tableOffset]) + (Get8Bit $pointerTableArray[$tableOffset+1]) + (Get8Bit $pointerTableArray[$tableOffset+2]) + (Get8Bit $pointerTableArray[$tableOffset+3])
                    if ( (IsChecked $Redux.Restore.FireTemple) -and (IsSet $track.size_censored) )   { PatchBytes -File $seq -Offset $offset -Length $track.size_censored -Patch ($file + $ext) -Music }
                    else                                                                             { PatchBytes -File $seq -Offset $offset -Length $track.size          -Patch ($file + $ext) -Music }

                    # Size
                    $tableOffset = Get16Bit ( (GetDecimal $id) * 16 + 6)
                    $value       = Get16Bit ( (Get-Item -LiteralPath ($Paths.Music + "\" + $file + $ext)).length )
                    ChangeBytes -File $pointerTable -Offset $tableOffset -Values $value

                    # Bank
                    if (TestFile ($Paths.Music + "\" + $file + ".meta"))   { $value = (Get-Content -Path ($Paths.Music + "\" + $file + ".meta"))[1].replace("0x", "") } # Meta
                    else                                                   { $value = ($file.Substring(($file.IndexOf('_')+1))).split("_")[0] }                         # Filename
                    if ($ext -eq $Files.json.music.conversion.ext) {
                        foreach ($conversion in $Files.json.music.conversion.bank) {
                            if ( (GetDecimal $value) -eq (GetDecimal $conversion.original) ) {
                                $value = $conversion.replace
                                break
                            }
                        }
                    }

                    $offset = (Get16Bit ( (GetDecimal $id) * 2 + 2) )
                    ChangeBytes -File $bankPointerTable -Offset $offset -Values $value
                }
            }
        }
    }

    PatchBytes -Offset $BankPointerTableStart -Patch "AudiobankPointerTable.bin" -Extracted
    PatchBytes -Offset $PointerTableStart     -Patch "AudioPointerTable.bin"     -Extracted
    PatchBytes -Offset $SeqStart              -Patch "Audioseq.bin"              -Extracted

}



#==============================================================================================================================================================================================
function MusicOptions([string]$Default="File Select") {
    
    if ($Settings.Core.SafeOptions -eq $True) { return }

    $tracks = @()
    foreach ($track in $Files.json.music.tracks) {
        if ($track.size -ne 0) { $tracks += $track.title }
    }



    # MUSIC #

    CreateReduxGroup    -Tag "Music"       -Text "Music"
    CreateReduxComboBox -Name "FileSelect" -Items $tracks -Text "File Select Theme" -Info "Set the music theme for the File Select menu" -Default $Default -Credits "Admentus"
    if (TestFile -Path $Paths.Music -Container) { $Redux.Music.Reset = CreateReduxButton -Text "Reset Replacements" }


    if (!(TestFile -Path $Paths.Music -Container)) { return }



    # MUTE MUSIC #

    CreateReduxGroup       -Tag  "MuteMusic"    -Text "Mute Music Tracks" -Height 7
    CreateReduxRadioButton -Name "EnableAll"    -Max 4 -SaveTo "Mute" -Text "Enable All Music"     -Info "Keep the music as it is"                                  -Checked -Credits "Admentus"
    CreateReduxRadioButton -Name "MuteSelected" -Max 4 -SaveTo "Mute" -Text "Mute Selected Music"  -Info "Mute the selected music from the list in the game"                 -Credits "Admentus"
    CreateReduxRadioButton -Name "MuteAreaOnly" -Max 4 -SaveTo "Mute" -Text "Mute Area Music Only" -Info "Mute only the area music in the game"                              -Credits "Admentus"
    CreateReduxRadioButton -Name "MuteAll"      -Max 4 -SaveTo "Mute" -Text "Mute All Music"       -Info "Mute all the music in the game"                                    -Credits "Admentus"
    CreateReduxListBox     -Name "Tracks"       -Items $tracks -Multicolumn -MultiSelect -Columns 4 -Rows 4 -ItemWidth 200

    EnableForm -Form $Redux.MuteMusic.Tracks -Enable $Redux.MuteMusic.MuteSelected.Checked
    $Redux.MuteMusic.MuteSelected.Add_CheckedChanged({ EnableForm -Form $Redux.MuteMusic.Tracks -Enable $this.Checked })



    # REPLACE MUSIC #

                                 CreateReduxGroup    -Tag  "ReplaceMusic"                 -Text "Replace Music Tracks" -Height 9
                                 CreateReduxCheckBox -Name "EnableReplace"                -Text "Enable Replace Music" -Info "Enables patching in music replacements"
                                 CreateReduxComboBox -Name "SelectReplace" -Items $tracks -Text "Select Replace Track" -Info "Select the ingame track that should be replaced" -NoDefault
    $Redux.ReplaceMusic.Tracks = CreateReduxListBox                        -Multicolumn -Columns 4 -Rows 4 -Row 2 -Column 1 -ItemWidth 200

    EnableElem -Elem @($Redux.ReplaceMusic.Tracks, $Redux.ReplaceMusic.SelectReplace) -Active $Redux.ReplaceMusic.EnableReplace.Checked
    $Redux.ReplaceMusic.EnableReplace.Add_CheckedChanged({ EnableElem -Elem @($Redux.ReplaceMusic.Tracks, $Redux.ReplaceMusic.SelectReplace) -Active $this.Checked })

    $Redux.Music.Preview    = CreateReduxButton -Text "Start Music Preview" -Height 50 -Row 8 -Column 2
    $Redux.Music.AuthorName = CreateLabel -X 10 -Y $Redux.Music.Preview.Top                  -Text "Nintendo" -Font $Fonts.Medium
    $Redux.Music.AuthorLink = CreateLabel -X 10 -Y ($Redux.Music.Preview.Top + (DPISize 30)) -Text "URL Link" -Font $Fonts.Medium
    
    GetReplacementTracks

    CheckAuthor
    $Redux.ReplaceMusic.Tracks.Add_SelectedIndexChanged({ CheckAuthor })
    $Redux.Music.AuthorLink.add_Click({ if (IsSet $Redux.Music.AuthorURL) { [system.Diagnostics.Process]::start($Redux.Music.AuthorURL) } })
    $Redux.Music.AuthorLink.ForeColor = "Blue"



    # RESET #

    $Redux.Music.Reset.Add_Click({

        $Redux.ReplaceMusic.Tracks.text = "Default"
        foreach ($track in $Files.json.music.tracks) { $GameSettings["ReplaceMusic"][$track.title] = "Default" }

    })



    # PREVIEW #

    $Redux.ReplaceMusic.SelectReplace.Add_SelectedIndexChanged( { GetReplacementTracks })
    $Redux.ReplaceMusic.Tracks.Add_SelectedIndexChanged( { $GameSettings["ReplaceMusic"][$Redux.ReplaceMusic.SelectReplace.text] = $Redux.ReplaceMusic.Tracks.text } )

    $Redux.Music.Preview.BackColor = "Green"
    $Redux.Music.Preview.ForeColor = "White"

    $Redux.Music.Preview.Add_Click({
        if ($this.text -eq "Start Music Preview") {
            $midiScript = {
                Param ([string]$Path, [string]$toolFile, [string]$audioBank, [string]$midiFile)
                Push-Location $path
                $task = & $toolFile -x $audioBank $midiFile | Out-Null
                Pop-Location
            }

            $midiFile  = $null
            $audioBank = $null
            foreach ($folder in (Get-ChildItem -LiteralPath $Paths.Music -Directory)) {
                foreach ($item in (Get-ChildItem -LiteralPath ($Paths.Music + "\" + $folder.BaseName) -Directory)) {
                    $file = $Paths.Music + "\" + $folder.BaseName + "\" + $item.BaseName + "\" + $Redux.ReplaceMusic.Tracks.SelectedItems

                    if ( (TestFile ($file + ".mid")) -or (TestFile ($file + ".zip")) ) {
                        if (TestFile ($file + ".meta"))   { $audioBank = (Get-Content -Path ($file + ".meta"))[1].replace("0x", "") }         # Meta
                        else                              { $audioBank = (($file + ".mid").Substring(($file.IndexOf('_')+1))).split("_")[0] } # Filename

                        if     (TestFile ($file + ".mid"))   { $midiFile  = $file + ".mid" }
                        elseif (TestFile ($file + ".zip"))   { $midiFile  = $file + ".zip#" + $Redux.ReplaceMusic.Tracks.SelectedItems + ".mid" }

                        $ext = ".seq"
                        if (TestFile ($file + ".zseq")) { $ext = ".zseq" }
                        if ($ext -eq $Files.json.music.conversion.ext) {
                            foreach ($conversion in $Files.json.music.conversion.bank) {
                                if ( (GetDecimal $audioBank) -eq (GetDecimal $conversion.original) ) {
                                    $audioBank = $conversion.replace
                                    break
                                }
                            }
                        }
                        $audioBank = "`"soundfont " + (Get8Bit (GetDecimal $audioBank)) + ".sf2`""
                        break
                    }
                }
            }
            if ( (IsSet $midiFile) -and (IsSet $audioBank) ) {
                $this.Text      = "Stop Music Preview"
                $this.BackColor = "Red"

                Start-Job -Name 'MidiPlayer' -Scriptblock $midiScript -ArgumentList @($GameFiles.banks, $Files.tool.timidity, $audioBank, $midiFile)
                $jobStatus = (Get-Job -Name "MidiPlayer").State

                $check = $false
                while ([bool](Get-Job -Name "MidiPlayer" -ea SilentlyContinue) -and $jobStatus -ne "Completed") {
                    $jobStatus = (Get-Job -Name "MidiPlayer").State
                    [Windows.Forms.Application]::DoEvents()
                    Start-Sleep -m 25
                    if (!$check) {
                        $MainDialog.Activate()
                        $Check = $true
                    }
                }
                StopJobs

                # & $Files.tool.timidity -c 

                $this.Text      = "Start Music Preview"
                $this.BackColor = "Green"
            }
        }
        else {
            StopJobs
            $this.Text      = "Start Music Preview"
            $this.BackColor = "Green"
        }
    })

}



#==============================================================================================================================================================================================
function CheckAuthor() {
    
    if (!(TestFile -Path $Paths.Music -Container)) { return; }

    if ($Redux.ReplaceMusic.Tracks.Text -eq "Default") {
        $Redux.Music.AuthorName.Text = "Nintendo"
        $Redux.Music.AuthorURL = $null
        EnableElem -Elem $Redux.Music.AuthorLink -Active $False -Hide
        return
    }

    foreach ($folder in (Get-ChildItem -LiteralPath $Paths.Music -Directory)) {
        foreach ($item in (Get-ChildItem -LiteralPath ($Paths.Music + "\" + $folder.BaseName) -Directory)) {
            if ( (TestFile ($Paths.Music + "\" + $folder.BaseName + "\" + $item.BaseName + "\" + $Redux.ReplaceMusic.Tracks.Text + ".seq")) -or (TestFile ($Paths.Music + "\" + $folder.BaseName + "\" + $item.BaseName + "\" + $Redux.ReplaceMusic.Tracks.Text + ".zseq")) ) {
                $Redux.Music.AuthorName.Text = $item.BaseName
                $Redux.Music.AuthorURL = $null
                EnableElem -Elem $Redux.Music.AuthorLink -Active $False -Hide
                foreach ($i in $Files.json.sequences) {
                    if ($i.author -eq $item.BaseName) {
                        $Redux.Music.AuthorURL = $i.url
                        EnableElem -Elem $Redux.Music.AuthorLink -Active $True -Hide
                        break
                    }
                }

                return
            }
        }
    }

}



#==============================================================================================================================================================================================
function GetReplacementTracks() {
    
    if (!(TestFile -Path $Paths.Music -Container)) {
        WriteToConsole "Music sequence files are missing" -Error
        return;
    }

    $Redux.ReplaceMusic.Tracks.items.Clear()
    $items = @()
    foreach ($track in $Files.json.music.tracks)  {
        if ($track.title -eq $Redux.ReplaceMusic.SelectReplace.text) {
            foreach ($item in Get-ChildItem -LiteralPath $Paths.Music -Recurse) {
                if ($item.extension -eq ".zseq" -or $item.extension -eq ".seq") {
                    if ($item.length -le (GetDecimal $track.size) ) {
                        $event = $False

                        $file = $item.FullName
                        $file = $file.replace(".seq", "")
                        $file = $file.replace(".zseq", "")

                        if (TestFile ($file + ".meta") ) {
                            try { $event = (Get-Content -Path ($file + ".meta") -Tail 1).ToLower() -eq "fanfare" } # Meta - fanfare / .seq / .zseq }
                            catch { WriteToConsole ("This song has an incorrect meta file: " + $item.basename) -Error }
                        }
                        else {
                            try {
                                $index = ($item.BaseName.Substring(($item.BaseName.IndexOf('_')+1))).split("_")[1]
                                $index = $index.split("-")
                                foreach ($i in $index) {
                                if ($i -eq "8" -or $i -eq "9" -or $i -eq "10") {
                                    $event = $True
                                    break
                                }
                            }
                            }
                            catch { WriteToConsole ("This song has an incorrect naming format: " + $item.basename) -Error }
                            
                        }

                        if ($item.extension -eq $Files.json.music.conversion.ext) {
                            try {
                                if (TestFile $item.FullName.replace($Files.json.music.conversion.ext, ".meta"))   { $bank = (Get-Content -Path ($item.FullName.replace($Files.json.music.conversion.ext, ".meta")))[1].replace("0x", "") } # Meta
                                else                                                                              { $bank = ($item.basename.Substring(($item.basename.IndexOf('_')+1))).split("_")[0] } # Filename

                                foreach ($conversion in $Files.json.music.conversion.bank) {
                                    if ( (GetDecimal $bank) -eq (GetDecimal $conversion.original) ) {
                                        if ( ($track.event -eq 1 -and $event) -or ($track.event -ne 1 -and !$event) ) {
                                            $items += $item.BaseName
                                            break
                                        }
                                    }
                                }
                            }
                            catch { WriteToConsole ("This song has an incorrect naming format: " + $item.basename) -Error }
                        }
                        elseif ( ($track.event -eq 1 -and $event) -or ($track.event -ne 1 -and !$event) ) { $items += $item.BaseName }
                   }
                }
            }
            break
        }
    }
    
    $Redux.ReplaceMusic.Tracks.Items.AddRange($items)
    $Redux.ReplaceMusic.Tracks.Sorted = $True
    $Redux.ReplaceMusic.Tracks.Sorted = $False
    $Redux.ReplaceMusic.Tracks.Items.Insert(0, "Default")
    
    if (IsSet $GameSettings["ReplaceMusic"][$Redux.ReplaceMusic.SelectReplace.text])   { $Redux.ReplaceMusic.Tracks.text = $GameSettings["ReplaceMusic"][$Redux.ReplaceMusic.SelectReplace.text] }
    else                                                                               { $Redux.ReplaceMusic.Tracks.selectedIndex = 0 }

}



#==============================================================================================================================================================================================
function ChangeStringIntoDigits([string]$File, [string]$Search, [string]$Value, [switch]$Triple) {
    
    $Offset = SearchBytes -File $File -Values $Search
    if ($Triple -and [int16]$Value -lt 100)       { ChangeBytes -File $File -Offset $Offset -IsDec -Values (@("48")       + [System.Text.Encoding]::Default.GetBytes($Value)) }
    elseif ($Triple -and [int16]$Value -lt 10)    { ChangeBytes -File $File -Offset $Offset -IsDec -Values (@("48", "48") + [System.Text.Encoding]::Default.GetBytes($Value)) }
    elseif (!$Triple -and [int16]$Value -lt 10)   { ChangeBytes -File $File -Offset $Offset -IsDec -Values (@("48")       + [System.Text.Encoding]::Default.GetBytes($Value)) }
    else                                          { ChangeBytes -File $File -Offset $Offset -IsDec -Values @([System.Text.Encoding]::Default.GetBytes($Value)) }

}



#==============================================================================================================================================================================================
function ShowStylePreview() {
    
    if ($Redux.Styles.RegularChests  -ne $null)   { ShowPreviewImage -Option $Redux.Styles.RegularChests.Text  -Path "Styles\Chests"       -Box $Redux.Previews.RegularChests  }
    if ($Redux.Styles.LeatherChests  -ne $null)   { ShowPreviewImage -Option $Redux.Styles.LeatherChests.Text  -Path "Styles\Chests"       -Box $Redux.Previews.LeatherChests  }
    if ($Redux.Styles.BossChests     -ne $null)   { ShowPreviewImage -Option $Redux.Styles.BossChests.Text     -Path "Styles\Chests"       -Box $Redux.Previews.BossChests     }
    if ($Redux.Styles.SmallCrates    -ne $null)   { ShowPreviewImage -Option $Redux.Styles.SmallCrates.Text    -Path "Styles\Small Crates" -Box $Redux.Previews.SmallCrates    }
    if ($Redux.Styles.Pots           -ne $null)   { ShowPreviewImage -Option $Redux.Styles.Pots.Text           -Path "Styles\Pots"         -Box $Redux.Previews.Pots           }

}



#==============================================================================================================================================================================================
function ShowHudPreview([switch]$IsOoT) {
    
    if ($Redux.UI.ButtonStyle  -ne $null)   { ShowPreviewImage -Option $Redux.UI.ButtonStyle.Text  -Path "HUD\Buttons"       -Box $Redux.Previews.ButtonStyle -Width 90  -Height 90 }
    if ($Redux.UI.Magic        -ne $null)   { ShowPreviewImage -Option $Redux.UI.Magic.Text        -Path "HUD\Magic"         -Box $Redux.Previews.Magic       -Width 200 -Height 40 }
    if ($Redux.UI.Hearts       -ne $null)   { ShowPreviewImage -Option $Redux.UI.Hearts.Text       -Path "HUD\Hearts"        -Box $Redux.Previews.Hearts       }
    if ($Redux.UI.Rupees       -ne $null)   { ShowPreviewImage -Option $Redux.UI.Rupees.Text       -Path "HUD\Rupees"        -Box $Redux.Previews.Rupees       }
    if ($Redux.UI.CurrentFloor -ne $null)   { ShowPreviewImage -Option $Redux.UI.CurrentFloor.Text -Path "HUD\Current Floor" -Box $Redux.Previews.CurrentFloor }
    if ($Redux.UI.BossFloor    -ne $null)   { ShowPreviewImage -Option $Redux.UI.BossFloor.Text    -Path "HUD\Boss Floor"    -Box $Redux.Previews.BossFloor    }

    if       ( ( (IsChecked $Redux.UI.DungeonKeys)      -or (IsChecked $Redux.UI.HUD) )      -and  $IsOoT)   { $file = "Majora's Mask"   }
    elseif   ( ( (IsChecked $Redux.UI.DungeonKeys)      -or (IsChecked $Redux.UI.HUD) )      -and !$IsOoT)   { $file = "Ocarina of Time" }
    elseif   ( ( (IsChecked $Redux.UI.DungeonKeys -Not) -or (IsChecked $Redux.UI.HUD -Not) ) -and  $IsOoT)   { $file = "Ocarina of Time" }
    elseif   ( ( (IsChecked $Redux.UI.DungeonKeys -Not) -or (IsChecked $Redux.UI.HUD -Not) ) -and !$IsOoT)   { $file = "Majora's Mask"   }
    $image = GetImageFile ($Paths.Shared + "\HUD\Keys\" + $file)
    if ($image -ne $null) { SetBitMap -Path $image -Box $Redux.Previews.DungeonKeys } else { $Redux.Previews.DungeonKeys.Image = $null }

    if ($IsOoT) {
        if (IsChecked $Redux.Graphics.ImprovedMoon) { $image = GetImageFile ($GameFiles.Textures + "\Moon\Improved Moon.png") } else { $image = GetImageFile ($GameFiles.Textures + "\Moon\Original Moon.png") } 
        if ($image -ne $null) { SetBitMap -Path $image -Box $Redux.Previews.ImprovedMoon } else { $Redux.Previews.ImprovedMoon.Image = $null }
    }
}



#==============================================================================================================================================================================================
function ShowPreviewImage([string]$Option=$null, [string]$Path="", [object]$Box=$null, [int]$Width=0, [int]$Height=0) {
    
    if ($Box -eq $null) { return }
    $image = GetImageFile ($Paths.shared + "\" + $Path + "\" + $Option.replace(" (default)", "") )
    if ($image -ne $null) { SetBitMap -Path $image -Box $Box -Width $Width -Height $Height } else { $Box.Image = $null }

}



#==============================================================================================================================================================================================
function ShowEquipmentPreview() {
    
    if ($Redux.Equipment.DekuShield   -ne $null)   { ShowEquipmentPreviewImage -Option $Redux.Equipment.DekuShield   -Equipment "Deku Shield"   -IconBox $Redux.Previews.DekuShieldIcon   -LinkBox $Redux.Previews.DekuShield   }
    if ($Redux.Equipment.HylianShield -ne $null)   { ShowEquipmentPreviewImage -Option $Redux.Equipment.HylianShield -Equipment "Hylian Shield" -IconBox $Redux.Previews.HylianShieldIcon -LinkBox $Redux.Previews.HylianShield }
    if ($Redux.Equipment.MirrorShield -ne $null)   { ShowEquipmentPreviewImage -Option $Redux.Equipment.MirrorShield -Equipment "Mirror Shield" -IconBox $Redux.Previews.MirrorShieldIcon -LinkBox $Redux.Previews.MirrorShield }

    if ($Redux.Equipment.KokiriSword  -ne $null)   { ShowEquipmentPreviewImage -Option $Redux.Equipment.KokiriSword  -Equipment "Kokiri Sword"  -IconBox $Redux.Previews.KokiriSwordIcon }
    if ($Redux.Equipment.MasterSword  -ne $null)   { ShowEquipmentPreviewImage -Option $Redux.Equipment.MasterSword  -Equipment "Master Sword"  -IconBox $Redux.Previews.MasterSwordIcon }

}



#==============================================================================================================================================================================================
function ShowEquipmentPreviewImage([object]$Option=$null, [string]$Equipment="", [object]$IconBox=$null, [object]$LinkBox=$null) {
    
    if ($IconBox -ne $null) {
        $image = GetImageFile ($Paths.shared + "\Equipment\" + $Equipment + "\"  + $Option.Text.replace(" (default)", "")  + " Icon")
        if ($image -ne $null) { SetBitMap -Path $image -Box $IconBox }
        else {
            $image = GetImageFile ($Paths.shared + "\Equipment\" + $Equipment + "\"  + $Option.Items[0].replace(" (default)", "")  + " Icon")
            if ($image -ne $null) { SetBitMap -Path $image -Box $IconBox } else { $IconBox.Image = $null }
        }
    }

    if ($LinkBox -ne $null) {
        $image = GetImageFile ($Paths.shared + "\Equipment\" + $Equipment + "\"  + $Option.Text.replace(" (default)", "") )
        if ($image -ne $null) { SetBitMap -Path $image -Box $LinkBox } else { $LinkBox.Image = $null }
    }

}



#==============================================================================================================================================================================================
function ShowModelsPreview([object]$Dropdown, [string]$Category) {
    
    if ($OptionsPreviews -eq $null) { return }
    
    $GamePatch.LoadedModel[$Category] = $Files.json.models = $null
    $Text = $GamePatch.LoadedModelsList[$Category][$Dropdown.SelectedIndex]
    
    :outer foreach ($folder in (Get-ChildItem -LiteralPath $Paths.Models -Directory)) {
        $path = $Paths.Models + "\" + $folder.BaseName + "\" + $GameType.mode + " - " + $Category + "\"
        $file = $path + $Text
    
        if ( (TestFile ($file + ".jpg") ) -or (TestFile ($file + ".png") ) -or (TestFile ($file + ".zobj") ) -or (TestFile ($file + ".ppf") ) ) {
            if (TestFile ($Paths.Models + "\" + $folder + "\models.json") )   { $Files.json.models = SetJSONFile ($Paths.Models + "\" + $folder + "\models.json") -Safe                            }
            else                                                              { WriteToConsole -Text ("Could not find JSON configuration file for " + $Category.ToLower() +" models addon") -Error }
            
            if ($Files.json.models -ne $null) {
                :inner for ($i=0; $i -lt $Files.json.models.$Category.length; $i++) {
                    if ($Files.json.models.$Category[$i].name -eq $Text) {
                        $GamePatch.LoadedModel[$Category] = $Files.json.models.$Category[$i]
                        Add-Member -InputObject $GamePatch.LoadedModel[$Category] -NotePropertyMembers @{ folder = $folder.BaseName }
                        break inner
                    }   
                }
            }

            if ($GamePatch.LoadedModel[$Category] -eq $null) {
                $GamePatch.LoadedModel[$Category] = @{}
                $GamePatch.LoadedModel[$Category].folder = $folder.BaseName
                WriteToConsole -Text ("No metadata configuration found for: " + $Text) -Error
            }

            ShowModelPreview -Box $Redux.Previews[$Category] -Path $Path -Text $Text -Category $Category -Type $GamePatch.LoadedModel[$Category]
            break outer
        }

    }

}



#==============================================================================================================================================================================================
function ShowModelPreview([object]$Box, [string]$Path, [string]$Text, [string]$Category, $Type) {
    
    if ($Type -eq $null) { return }

    $image = GetImageFile ($Path + $Text)
    if ($image -ne $null) { SetBitMap -Path $image -Box $Box }
    elseif ($Category -eq "Child" -and $GameType.mode -eq "Majora's Mask") {
        $image = GetImageFile ($Path + $Text)
        if ($image -ne $null) { SetBitMap -Path $image -Box $Box } else { $Box.Image = $null }
    }
    else { $Box.Image = $null }

    $Credits = ""

    if     (!(IsSet $Type.name))                                { $Credits += "--- Model with missing license ---{0}" }
    else                                                        { $Credits += "--- " + ($Type.name -replace '_.*$') + " ---{0}"       }
    if       (IsSet $Type.author)                               { $Credits += "{0}Made by: " + $Type.author                           }
    elseif   ($Type.author -ne 0)                               { $Credits += "{0}Made by: Unknown"                                   }
    if       (IsSet $Type.source)                               { $Credits += "{0}Source: "  + $Type.source                           }
    if       ($Type.WIP -eq 1)                                  { $Credits += "{0}This model is still Work-In-Progress"               }
    if       ($Type.WIP -eq 2)                                  { $Credits += "{0}This model is a demonstration of the final version" }
    if     ( (IsSet $Type.url) -and !(IsSet $Type.author) )     { $Credits += "{0}{0}Click to visit the source of the model"          }
    elseif ( (IsSet $Type.url) -and  (IsSet $Type.author) )     { $Credits += "{0}{0}Click to visit the modder's homepage"            }
    if       (IsSet $Type.info)                                 { $Credits += "{0}{0}" + $Type.info                                   }
    if       (IsSet $Type.license)                              { $Credits += "{0}{0}License: " + $Type.license                       }

    if ( (IsSet $Type.warning) -or $Type.deku_shield -eq 0 -or $Type.hylian_shield -eq 0 -or $Type.mirror_shield -eq 0) {
        $Credits += "{0}"
        if (IsSet $Type.warning)         { $Credits += "{0}[!] " + $Type.warning }
        if ($Type.deku_shield   -eq 0)   { $Credits += "{0}[!] " + "This model does not support Deku Shield changes"   }
        if ($Type.hylian_shield -eq 0)   { $Credits += "{0}[!] " + "This model does not support Hylian Shield changes" }
        if ($Type.mirror_shield -eq 0)   { $Credits += "{0}[!] " + "This model does not support Mirror Shield changes" }
    }

    if ($GamePatch.LoadedModel[$Category].folder -ne "Core") { $Credits += "{0}{0}This is an addon model made by a community member{0}Issues should be reported to the model author instead" }

    if (IsSet $Credits)   { $PreviewToolTip.SetToolTip($Box, ([string]::Format($Credits, [Environment]::NewLine))) }
    else                  { $PreviewToolTip.RemoveAll() }

    if (IsSet $Redux.Equipment.DekuShield)     { EnableElem -Elem $Redux.Equipment.DekuShield   -Active ($Type.deku_shield   -ne 0) }
    if (IsSet $Redux.Equipment.HylianShield)   { EnableElem -Elem $Redux.Equipment.HylianShield -Active ($Type.hylian_shield -ne 0) }
    if (IsSet $Redux.Equipment.MirrorShield)   { EnableElem -Elem $Redux.Equipment.MirrorShield -Active ($Type.mirror_shield -ne 0) }

}



#==============================================================================================================================================================================================
function LoadModelsList([string]$Category) {
    
    $list = @()

    foreach ($folder in (Get-ChildItem -LiteralPath $Paths.Models -Directory)) {
        $path = $Paths.Models + "\" + $folder.BaseName + "\" + $GameType.mode + " - " + $Category
        if (!(TestFile -Container $path)) { continue }
        foreach ($item in Get-ChildItem -LiteralPath $path -Force) { if ($item.Extension -eq ".ppf" -or $item.Extension -eq ".zobj") { $list += $item.BaseName } }
    }

    $list                                  = $list | Sort-Object | select -Unique
    $GamePatch.LoadedModelsList[$Category] = @("Original") + $list

    if ($GamePatch.LoadedModelsList[$Category].Count -eq 0) { return @("No models found?") } 

    for ($i=0; $i -lt $list.Count; $i++) { $list[$i] = $list[$i] -replace '_.*$' }
    return @("Original (default)") + $list

}



#==============================================================================================================================================================================================
function ChangeModelsSelection() {
    
    if ($GamePatch.models -eq 0) { return }

    if     ($GamePatch.age -eq "Adult")   { $GamePatch.LoadedModel["Child"] = @{}; $GamePatch.LoadedModel["Child"].deku_shield   = 1; $GamePatch.LoadedModel["Child"].hylian_shield = 1 }
    elseif ($GamePatch.age -eq "Child")   { $GamePatch.LoadedModel["Adult"] = @{}; $GamePatch.LoadedModel["Adult"].hylian_shield = 1; $GamePatch.LoadedModel["Adult"].mirror_shield = 1 }
    
    if (IsSet $Redux.Graphics.ChildModels) {
        $Redux.Graphics.ChildModels.Add_SelectedIndexChanged( { ShowModelsPreview -Dropdown $Redux.Graphics.ChildModels -Category "Child" } )
        ShowModelsPreview -Dropdown $Redux.Graphics.ChildModels -Category "Child"

        $Redux.Previews["Child"].add_Click({
            if (IsSet $GamePatch.LoadedModel["Child"].url) { $GamePatch.LoadedModel["Child"].url | foreach { [system.Diagnostics.Process]::start($_) } }
        })
    }
    if (IsSet $Redux.Graphics.AdultModels) {
        $Redux.Graphics.AdultModels.Add_SelectedIndexChanged( { ShowModelsPreview -Dropdown $Redux.Graphics.AdultModels -Category "Adult" } )
        ShowModelsPreview -Dropdown $Redux.Graphics.AdultModels -Category "Adult"

        $Redux.Previews["Adult"].add_Click({
            if (IsSet $GamePatch.LoadedModel["Adult"].url) { $GamePatch.LoadedModel["Adult"].url | foreach { [system.Diagnostics.Process]::start($_) } }
        })
    }

}



#==============================================================================================================================================================================================
function CreateButtonColorOptions($Default=1) {
    
    $items     = @("N64 OoT", "N64 MM", "GC OoT", "GC MM", "Xbox OoT", "Xbox MM", "JP PlayStation OoT", "JP PlayStation MM", "WE PlayStation OoT", "WE PlayStation MM", "N64 TML", "GC TML", "Randomized", "Custom")
    $randomize = "`n" + '"Randomized" fully randomizes the colors each time the patcher is opened'
    $buttons   = $Redux.Colors.SetButtons = $Redux.Colors.ButtonLabels = @()

    CreateReduxGroup    -Tag  "Colors"  -Text "Button Colors"
    CreateReduxComboBox -Name "Buttons" -Text "Button" -Items $items -Default $Default -Info ("Select a preset for the button colors" + $randomize) -Credits "GhostlyDark & Third M"
    $Last.Row++; $Last.Column = 1
    
    $buttons += CreateReduxButton -Tag $buttons.Count -Text "A Button"     -Info "Select the color you want for the A button"     -Credits "GhostlyDark"
    $buttons += CreateReduxButton -Tag $buttons.Count -Text "B Button"     -Info "Select the color you want for the B button"     -Credits "GhostlyDark"
    $buttons += CreateReduxButton -Tag $buttons.Count -Text "C Buttons"    -Info "Select the color you want for the C buttons"    -Credits "GhostlyDark"
    $buttons += CreateReduxButton -Tag $buttons.Count -Text "Start Button" -Info "Select the color you want for the Start button" -Credits "GhostlyDark"

    $Redux.Colors.SetButtons += CreateColorDialog -Color $GameType.default_values.a_button  -Name "SetAButton"  -IsGame -Button $buttons[0]
    $Redux.Colors.SetButtons += CreateColorDialog -Color $GameType.default_values.b_button  -Name "SetBButton"  -IsGame -Button $buttons[1]
    $Redux.Colors.SetButtons += CreateColorDialog -Color $GameType.default_values.c_buttons -Name "SetCButtons" -IsGame -Button $buttons[2]
    $Redux.Colors.SetButtons += CreateColorDialog -Color $GameType.default_values.s_button  -Name "SetSButton"  -IsGame -Button $buttons[3]

    
    for ($i=0; $i -lt $Buttons.length; $i++) {
        $buttons[$i].Add_Click({ $Redux.Colors.SetButtons[[int16]$this.Tag].ShowDialog(); $Redux.Colors.Buttons.Text = "Custom"; $Redux.Colors.ButtonLabels[[int16]$this.Tag].BackColor = $Redux.Colors.SetButtons[[int16]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetButtons[[int16]$this.Tag].Tag] = $Redux.Colors.SetButtons[[int16]$this.Tag].Color.Name })
        $Redux.Colors.ButtonLabels += CreateReduxColoredLabel -Link $buttons[$i]  -Color $Redux.Colors.SetButtons[$i].Color
    }
    
    if (IsSet $Redux.Colors.Buttons) {
        $Redux.Colors.Buttons.Add_SelectedIndexChanged({ SetButtonColorsPreset -ComboBox $Redux.Colors.Buttons })
        SetButtonColorsPreset -ComboBox $Redux.Colors.Buttons
    }

}



#==============================================================================================================================================================================================
function CreateBoomerangColorOptions($Default=1) {
    
    $randomize = "`n" + '"Randomized" fully randomizes the colors each time the patcher is opened'
    $buttons   = $Redux.Colors.SetBoomerang = $Redux.Colors.BoomerangLabels = @()

                CreateReduxGroup    -Tag  "Colors"      -Child -Exclude "Dawn" -Text "Boomerang Colors"
                CreateReduxComboBox -Name "Boomerang"   -Child -Exclude "Dawn" -Text "Boomerang"   -Info ("Select a preset for the boomerang trail colors" + $randomize) -Credits "Randomizer" -Items @("Vanilla", "Gold Quest", "Randomized", "Custom") -Default $Default
    $buttons += CreateReduxButton   -Tag $buttons.Count -Child -Exclude "Dawn" -Text "Inner Trail" -Info "Select the color you want for the inner trail"                 -Credits "Randomizer"
    $buttons += CreateReduxButton   -Tag $buttons.Count -Child -Exclude "Dawn" -Text "Outer Trail" -Info "Select the color you want for the outer trail"                 -Credits "Randomizer"

    if (!(IsSet $Redux.Colors.Boomerang)) { return }

    $Redux.Colors.SetBoomerang += CreateColorDialog -Color "FFFF64" -Name "SetInnerBoomerang" -IsGame -Button $buttons[0]
    $Redux.Colors.SetBoomerang += CreateColorDialog -Color "FFFF64" -Name "SetOuterBoomerang" -IsGame -Button $buttons[1]

    for ($i=0; $i -lt $buttons.length; $i++) {
        $buttons[$i].Add_Click({ $Redux.Colors.SetBoomerang[[int16]$this.Tag].ShowDialog(); $Redux.Colors.Boomerang.Text = "Custom"; $Redux.Colors.BoomerangLabels[[int16]$this.Tag].BackColor = $Redux.Colors.SetBoomerang[[int16]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetBoomerang[[int16]$this.Tag].Tag] = $Redux.Colors.SetBoomerang[[int16]$this.Tag].Color.Name })
        $Redux.Colors.BoomerangLabels += CreateReduxColoredLabel -Exclude "Dawn" -Link $buttons[$i]  -Color $Redux.Colors.SetBoomerang[$i].Color
    }
    
    if (IsSet $Redux.Colors.Boomerang) {
        $Redux.Colors.Boomerang.Add_SelectedIndexChanged({ SetBoomerangColorsPreset -ComboBox $Redux.Colors.Boomerang })
        SetBoomerangColorsPreset -ComboBox $Redux.Colors.Boomerang
    }

}



#==============================================================================================================================================================================================
function CreateBombchuColorOptions() {
    
    $randomize = "`n" + '"Randomized" fully randomizes the colors each time the patcher is opened'
    $buttons = $Redux.Colors.SetBombchu = $Redux.Colors.BombchuLabels = @()

                CreateReduxGroup    -Tag  "Colors"      -Exclude "Dawn" -Text "Bombchu Colors"
                CreateReduxComboBox -Name "Bombchu"     -Exclude "Dawn" -Text "Bombchu"     -Info ("Select a preset for the bombchu trail colors" + $randomize) -Credits "Randomizer" -Items @("Vanilla", "Randomized", "Custom")
    $buttons += CreateReduxButton   -Tag $buttons.Count -Exclude "Dawn" -Text "Inner Trail" -Info "Select the color you want for the inner trail"               -Credits "Randomizer"
    $buttons += CreateReduxButton   -Tag $buttons.Count -Exclude "Dawn" -Text "Outer Trail" -Info "Select the color you want for the outer trail"               -Credits "Randomizer"

    if (!(IsSet $Redux.Colors.Bombchu)) { return }

    $Redux.Colors.SetBombchu += CreateColorDialog -Color "FA0000" -Name "SetInnerBombchu" -IsGame -Button $buttons[0]
    $Redux.Colors.SetBombchu += CreateColorDialog -Color "FA0000" -Name "SetOuterBombchu" -IsGame -Button $buttons[1]

    for ($i=0; $i -lt $Buttons.length; $i++) {
        $buttons[$i].Add_Click({ $Redux.Colors.SetBombchu[[int16]$this.Tag].ShowDialog(); $Redux.Colors.Bombchu.Text = "Custom"; $Redux.Colors.BombchuLabels[[int16]$this.Tag].BackColor = $Redux.Colors.SetBombchu[[int16]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetBombchu[[int16]$this.Tag].Tag] = $Redux.Colors.SetBombchu[[int16]$this.Tag].Color.Name })
        $Redux.Colors.BombchuLabels += CreateReduxColoredLabel -Exclude "Dawn" -Link $buttons[$i]  -Color $Redux.Colors.SetBombchu[$i].Color
    }
    
    if (IsSet $Redux.Colors.Bombchu) {
        $Redux.Colors.Bombchu.Add_SelectedIndexChanged({ SetBombchuColorsPreset -ComboBox $Redux.Colors.Bombchu })
        SetBombchuColorsPreset -ComboBox $Redux.Colors.Bombchu
    }

}



#==============================================================================================================================================================================================
function CreateRupeeColorOptions() {
    
    $randomize = "`n" + '"Randomized" fully randomizes the colors each time the patcher is opened'
    $buttons   = $Redux.Colors.SetRupee = $Redux.Colors.RupeeLabels = @()

    CreateReduxGroup    -Tag  "Colors" -Text "Rupee Icon Colors"
    CreateReduxComboBox -Name "Rupees" -Text "Rupee Icon" -Items @("Redux", "Randomized", "Custom") -Info ("Select a preset for the Rupee icon colors" + $randomize) -Credits "Randomizer"
    $Last.Row++; $Last.Column = 1

    $buttons += CreateReduxButton -Tag $buttons.Count -Text "Base Wallet"     -Info "Select the color you want for the Base Wallet HUD icon"     -Credits "Randomizer"
    $buttons += CreateReduxButton -Tag $buttons.Count -Text "Adult's Wallet"  -Info "Select the color you want for the Adult's Wallet HUD icon"  -Credits "Randomizer"
    $buttons += CreateReduxButton -Tag $buttons.Count -Text "Giant's Wallet"  -Info "Select the color you want for the Giant's Wallet HUD icons" -Credits "Randomizer"
    $buttons += CreateReduxButton -Tag $buttons.Count -Text "Tycoon's Wallet" -Info "Select the color you want for the Tycoon's Wallet HUD icon" -Credits "Randomizer"
    
    $Redux.Colors.SetRupee += CreateColorDialog -Color "C8FF64" -Name "SetRupeeIcon1" -IsGame -Button $buttons[0]
    $Redux.Colors.SetRupee += CreateColorDialog -Color "8282FF" -Name "SetRupeeIcon2" -IsGame -Button $buttons[1]
    $Redux.Colors.SetRupee += CreateColorDialog -Color "FF6464" -Name "SetRupeeIcon3" -IsGame -Button $buttons[2]
    $Redux.Colors.SetRupee += CreateColorDialog -Color "FF5AFF" -Name "SetRupeeIcon4" -IsGame -Button $buttons[3]

    for ($i=0; $i -lt $Buttons.length; $i++) {
        $buttons[$i].Add_Click({ $Redux.Colors.SetRupee[[int16]$this.Tag].ShowDialog(); $Redux.Colors.Rupees.Text = "Custom"; $Redux.Colors.RupeeLabels[[int16]$this.Tag].BackColor = $Redux.Colors.SetRupee[[int16]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetRupee[[int16]$this.Tag].Tag] = $Redux.Colors.SetRupee[[int16]$this.Tag].Color.Name })
        $Redux.Colors.RupeeLabels += CreateReduxColoredLabel -Link $buttons[$i]  -Color $Redux.Colors.SetRupee[$i].Color
    }
    
    if (IsSet $Redux.Colors.Rupees) {
        $Redux.Colors.Rupees.Add_SelectedIndexChanged({ SetRupeeColorsPreset -ComboBox $Redux.Colors.Rupees })
        SetRupeeColorsPreset -ComboBox $Redux.Colors.Rupees
    }

}



#==============================================================================================================================================================================================
function CreateRupeeVanillaColorOptions($Preset=1, $Color="C8FF64") {
    
    $items     = @("Base Wallet", "Adult's Wallet", "Giant's Wallet", "Tycoon's Wallet", "Gold Quest", "Randomized", "Custom")
    $randomize = "`n" + '"Randomized" fully randomizes the colors each time the patcher is opened'

                                    CreateReduxGroup    -Tag "Colors"         -Text "Rupee Icon Color"
    $Redux.Colors.RupeesVanilla   = CreateReduxComboBox -Name "RupeesVanilla" -Text "Rupee Icon" -Items $items -Default $Preset -Info ("Select a color scheme for the Rupee Icon Color" + $randomize) -Credits "Ported from Redux"
    $button                       = CreateReduxButton                         -Text "Wallet Icon"                               -Info "Select the color you want for Rupee Icon Color"                -Credits "Ported from Redux"
    $Redux.Colors.SetRupeeVanilla = CreateColorDialog   -Name "SetRupeeIcon"  -Color $Color -IsGame -Button $button
    
    $button.Add_Click({ $Redux.Colors.SetRupeeVanilla.ShowDialog(); $Redux.Colors.RupeeVanillaLabel.BackColor = $Redux.Colors.SetRupeeVanilla.Color; $GameSettings["Colors"][$Redux.Colors.SetRupeeVanilla] = $Redux.Colors.SetRupeeVanilla.Color.Name })
    $Redux.Colors.RupeeVanillaLabel = CreateReduxColoredLabel -Link $button -Color $Redux.Colors.SetRupeeVanilla.Color
    
    if (IsSet $Redux.Colors.RupeesVanilla) {
        $Redux.Colors.RupeesVanilla.Add_SelectedIndexChanged({ SetRupeeVanillaColorsPreset -ComboBox $Redux.Colors.RupeesVanilla -Dialog $Redux.Colors.SetRupeeVanilla -Label $Redux.Colors.RupeeVanillaLabel })
        SetRupeeVanillaColorsPreset -ComboBox $Redux.Colors.RupeesVanilla -Dialog $Redux.Colors.SetRupeeVanilla -Label $Redux.Colors.RupeeVanillaLabel
    }

}



#==============================================================================================================================================================================================
function CreateSpinAttackColorOptions() {
    
    $items     = @("Blue", "Red", "Green", "White", "Cyan", "Magenta", "Orange", "Gold", "Purple", "Pink", "Black", "Randomized", "Custom")
    $randomize = "`n" + '"Randomized" fully randomizes the colors each time the patcher is opened'
    $buttons   = $Redux.Colors.SetSpinAttack = $Redux.Colors.SpinAttackLabels = @()

    CreateReduxGroup -Tag "Colors" -Text "Magic Spin Attack Colors"

                CreateReduxComboBox -Name "BlueSpinAttack" -Text "Blue Spin Attack" -Items $items -Default 1 -Info ("Select a preset for the blue spin attack colors" + $randomize) -Credits "Chez Cousteau"
    $buttons += CreateReduxButton   -Tag $buttons.Count    -Text "Blue Spin (Inner)"                         -Info "Select the inner color you want for the blue spin attack"       -Credits "Chez Cousteau"
    $buttons += CreateReduxButton   -Tag $buttons.Count    -Text "Blue Spin (Outer)"                         -Info "Select the outer color you want for the blue spin attack"       -Credits "Chez Cousteau"
    
                CreateReduxComboBox -Name "RedSpinAttack"  -Text "Red Spin Attack"  -Items $items -Default 2 -Info ("Select a preset for the red spin attack colors"  + $randomize) -Credits "Chez Cousteau"
    $buttons += CreateReduxButton   -Tag $buttons.Count    -Text "Red Spin (Inner)"                          -Info "Select the inner color you want for the red spin attack"        -Credits "Chez Cousteau"
    $buttons += CreateReduxButton   -Tag $buttons.Count    -Text "Red Spin (Outer)"                          -Info "Select the outer color you want for the red spin attack"        -Credits "Chez Cousteau"

    $Redux.Colors.SetSpinAttack += CreateColorDialog -Color "0000FF" -Name "SetInnerBlueSpinAttack" -IsGame -Button $buttons[0]
    $Redux.Colors.SetSpinAttack += CreateColorDialog -Color "0064FF" -Name "SetOuterBlueSpinAttack" -IsGame -Button $buttons[1]
    $Redux.Colors.SetSpinAttack += CreateColorDialog -Color "FF0000" -Name "SetInnerRedSpinAttack"  -IsGame -Button $buttons[2]
    $Redux.Colors.SetSpinAttack += CreateColorDialog -Color "FF6400" -Name "SetOuterRedSpinAttack"  -IsGame -Button $buttons[3]

    for ($i=0; $i -lt $Buttons.length; $i++) {
        $buttons[$i].Add_Click({
            $Redux.Colors.SetSpinAttack[[int16]$this.Tag].ShowDialog(); $Redux.Colors.SpinAttackLabels[[int16]$this.Tag].BackColor = $Redux.Colors.SetSpinAttack[[int16]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetSpinAttack[[int16]$this.Tag].Tag] = $Redux.Colors.SetSpinAttack[[int16]$this.Tag].Color.Name
            if ($this.Tag -lt 2)   { $Redux.Colors.BlueSpinAttack.Text = "Custom" }
            else                   { $Redux.Colors.RedSpinAttack.Text  = "Custom" }
        })
        $Redux.Colors.SpinAttackLabels += CreateReduxColoredLabel -Link $buttons[$i]  -Color $Redux.Colors.SetSpinAttack[$i].Color
    }

    if (IsSet $Redux.Colors.BlueSpinAttack) {
        $Redux.Colors.BlueSpinAttack.Add_SelectedIndexChanged({ SetSwordColorsPreset -ComboBox $Redux.Colors.BlueSpinAttack -Dialog $Redux.Colors.SetSpinAttack[0] -Label $Redux.Colors.SpinAttackLabels[0] })
        SetSwordColorsPreset -ComboBox $Redux.Colors.BlueSpinAttack -Dialog $Redux.Colors.SetSpinAttack[0] -Label $Redux.Colors.SpinAttackLabels[0]
        $Redux.Colors.BlueSpinAttack.Add_SelectedIndexChanged({
            SetSwordColorsPreset -ComboBox $Redux.Colors.BlueSpinAttack -Dialog $Redux.Colors.SetSpinAttack[1] -Label $Redux.Colors.SpinAttackLabels[1]
            if (IsIndex $Redux.Colors.BlueSpinAttack) { SetColor -Color "0064FF" -Dialog $Redux.Colors.SetSpinAttack[1] -Label $Redux.Colors.SpinAttackLabels[1] }
        })
        SetSwordColorsPreset -ComboBox $Redux.Colors.BlueSpinAttack -Dialog $Redux.Colors.SetSpinAttack[1] -Label $Redux.Colors.SpinAttackLabels[1]
        if (IsIndex $Redux.Colors.BlueSpinAttack) { SetColor -Color "0064FF" -Dialog $Redux.Colors.SetSpinAttack[1] -Label $Redux.Colors.SpinAttackLabels[1] }
    }

    if (IsSet $Redux.Colors.RedSpinAttack) {
        $Redux.Colors.RedSpinAttack.Add_SelectedIndexChanged({ SetSwordColorsPreset -ComboBox $Redux.Colors.RedSpinAttack -Dialog $Redux.Colors.SetSpinAttack[2] -Label $Redux.Colors.SpinAttackLabels[2] })
        SetSwordColorsPreset -ComboBox $Redux.Colors.RedSpinAttack -Dialog $Redux.Colors.SetSpinAttack[2] -Label $Redux.Colors.SpinAttackLabels[2]
        $Redux.Colors.RedSpinAttack.Add_SelectedIndexChanged({
            SetSwordColorsPreset -ComboBox $Redux.Colors.RedSpinAttack -Dialog $Redux.Colors.SetSpinAttack[3] -Label $Redux.Colors.SpinAttackLabels[3]
            if (IsIndex $Redux.Colors.RedSpinAttack -Index 2) { SetColor -Color "FF6400" -Dialog $Redux.Colors.SetSpinAttack[3] -Label $Redux.Colors.SpinAttackLabels[3] }
        })
        SetSwordColorsPreset -ComboBox $Redux.Colors.RedSpinAttack -Dialog $Redux.Colors.SetSpinAttack[3] -Label $Redux.Colors.SpinAttackLabels[3]
        if (IsIndex $Redux.Colors.RedSpinAttack -Index 2) { SetColor -Color "FF6400" -Dialog $Redux.Colors.SetSpinAttack[3] -Label $Redux.Colors.SpinAttackLabels[3] }
    }

}



#==============================================================================================================================================================================================
function CreateSwordTrailColorOptions([switch]$duration) {
    
    $items1                  = @("White", "Red", "Green", "Blue", "Cyan", "Magenta", "Orange", "Gold", "Purple", "Pink", "Randomized", "Custom")
    if ($duration) { $items2 = @("Disabled", "Short", "Long", "Very Long", "Lightsaber") }
    $randomize               = "`n" + '"Randomized" fully randomizes the colors each time the patcher is opened'
    $buttons                 = $Redux.Colors.SetSwordTrail = $Redux.Colors.SwordTrailLabels = @()

    CreateReduxGroup -Tag  "Colors" -Text "Sword Trail Colors"
                     CreateReduxComboBox -Name "SwordTrail"         -Text "Sword Trail Color"    -Items $items1 -Default 1 -Info ("Select a preset for the sword trail color" + $randomize) -Credits "Ported from Rando"
    $buttons +=      CreateReduxButton   -Tag $Buttons.Count        -Text "Trail (Inner)"                                  -Info "Select the inner color you want for the sword trail"      -Credits "Ported from Rando"
    $buttons +=      CreateReduxButton   -Tag $Buttons.Count        -Text "Trail (Outer)"                                  -Info "Select the outer color you want for the sword trail"      -Credits "Ported from Rando"
    if ($duration) { CreateReduxComboBox -Name "SwordTrailDuration" -Text "Sword Trail Duration" -Items $items2 -Default 2 -Info ("Select the duration for sword trail")                    -Credits "Ported from Rando" }

    $Redux.Colors.SetSwordTrail += CreateColorDialog -Color "FFFFFF" -Name "SetInnerSwordTrail" -IsGame -Button $Buttons[0]
    $Redux.Colors.SetSwordTrail += CreateColorDialog -Color "FFFFFF" -Name "SetOuterSwordTrail" -IsGame -Button $Buttons[1]

    for ($i=0; $i -lt $Buttons.length; $i++) {
        $Buttons[$i].Add_Click({
            $Redux.Colors.SetSwordTrail[[int16]$this.Tag].ShowDialog(); $Redux.Colors.SwordTrailLabels[[int16]$this.Tag].BackColor = $Redux.Colors.SetSwordTrail[[int16]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetSwordTrail[[int16]$this.Tag].Tag] = $Redux.Colors.SetSwordTrail[[int16]$this.Tag].Color.Name
            $Redux.Colors.SwordTrail.Text  = "Custom"
        })
        $Redux.Colors.SwordTrailLabels += CreateReduxColoredLabel -Link $Buttons[$i] -Color $Redux.Colors.SetSwordTrail[$i].Color
    }

    if (IsSet $Redux.Colors.SwordTrail) {
        $Redux.Colors.SwordTrail.Add_SelectedIndexChanged({
            if ($Redux.Colors.SwordTrail.text -ne "Custom") { SetColor -Color "FFFFFF" -Dialog $Redux.Colors.SetSwordTrail[1] -Label $Redux.Colors.SwordTrailLabels[1] }
            SetSwordColorsPreset -ComboBox $Redux.Colors.SwordTrail -Dialog $Redux.Colors.SetSwordTrail[0] -Label $Redux.Colors.SwordTrailLabels[0]
        })
        if ($Redux.Colors.SwordTrail.text -ne "Custom") { SetColor -Color "FFFFFF" -Dialog $Redux.Colors.SetSwordTrail[1] -Label $Redux.Colors.SwordTrailLabels[1] }
        SetSwordColorsPreset -ComboBox $Redux.Colors.SwordTrail -Dialog $Redux.Colors.SetSwordTrail[0] -Label $Redux.Colors.SwordTrailLabels[0]
    }

}



#==============================================================================================================================================================================================
function CreateFairyColorOptions($name) {

    # FAIRY COLORS #

    $items     = @($GameType.default_values.fairy_option1, $GameType.default_values.fairy_option2, "Tael", "Gold", "Green", "Light Blue", "Yellow", "Red", "Magenta", "Black", "Fi", "Ciela", "Epona", "Ezlo", "King of Red Lions", "Linebeck", "Loftwing", "Midna", "Phantom Zelda", "Randomized", "Custom")
    $randomize = "`n" + '"Randomized" fully randomizes the colors each time the patcher is opened'
    $buttons   = $Redux.Colors.SetFairy = $Redux.Colors.FairyLabels = @()
    
    CreateReduxGroup    -Tag  "Colors" -Text "Fairy Colors"
    CreateReduxComboBox -Name "Fairy"  -Text $name -Items $items -Info ("Select a color scheme for " + $name + $randomize) -Credits "Ported from Rando"
    $Last.Row++; $Last.Column = 1
    
    $Buttons += CreateReduxButton -Width 100 -Tag $buttons.Count -Text "Idle (Inner)"     -Info ("Select the color you want for the Inner Idle stance for "  + $name) -Credits "Ported from Rando"
    $Buttons += CreateReduxButton -Width 100 -Tag $buttons.Count -Text "Idle (Outer)"     -Info ("Select the color you want for the Outer Idle stance for "  + $name) -Credits "Ported from Rando"
    $Buttons += CreateReduxButton -Width 100 -Tag $buttons.Count -Text "Interact (Inner)" -Info ("Select the color you want for the Inner Other stance for " + $name) -Credits "Ported from Rando"
    $Buttons += CreateReduxButton -Width 100 -Tag $buttons.Count -Text "Interact (Outer)" -Info ("Select the color you want for the Outer Other stance for " + $name) -Credits "Ported from Rando"
    $Buttons += CreateReduxButton -Width 100 -Tag $buttons.Count -Text "NPC (Inner)"      -Info ("Select the color you want for the Inner NPC stance for "   + $name) -Credits "Ported from Rando"
    $Buttons += CreateReduxButton -Width 100 -Tag $buttons.Count -Text "NPC (Outer)"      -Info ("Select the color you want for the Outer NPC stance for "   + $name) -Credits "Ported from Rando"
    $Buttons += CreateReduxButton -Width 100 -Tag $buttons.Count -Text "Enemy (Inner)"    -Info ("Select the color you want for the Inner Enemy stance for " + $name) -Credits "Ported from Rando"
    $Buttons += CreateReduxButton -Width 100 -Tag $buttons.Count -Text "Enemy (Outer)"    -Info ("Select the color you want for the Outer Enemy stance for " + $name) -Credits "Ported from Rando"
    
    $Redux.Colors.SetFairy += CreateColorDialog -Color $GameType.default_values.fairy_idle1 -Name "SetFairyIdleInner"     -IsGame -Button $buttons[0]
    $Redux.Colors.SetFairy += CreateColorDialog -Color $GameType.default_values.fairy_idle2 -Name "SetFairyIdleOuter"     -IsGame -Button $buttons[1]
    $Redux.Colors.SetFairy += CreateColorDialog -Color "00FF00"                             -Name "SetFairyInteractInner" -IsGame -Button $buttons[2]
    $Redux.Colors.SetFairy += CreateColorDialog -Color "00FF00"                             -Name "SetFairyInteractOuter" -IsGame -Button $buttons[3]
    $Redux.Colors.SetFairy += CreateColorDialog -Color "9696FF"                             -Name "SetFairyNPCInner"      -IsGame -Button $buttons[4]
    $Redux.Colors.SetFairy += CreateColorDialog -Color "9696FF"                             -Name "SetFairyNPCOuter"      -IsGame -Button $buttons[5]
    $Redux.Colors.SetFairy += CreateColorDialog -Color "FFFF00"                             -Name "SetFairyEnemyInner"    -IsGame -Button $buttons[6]
    $Redux.Colors.SetFairy += CreateColorDialog -Color "C89B00"                             -Name "SetFairyEnemyOuter"    -IsGame -Button $buttons[7]
    
    for ($i=0; $i -lt $buttons.length; $i++) {
        $buttons[$i].Add_Click({ $Redux.Colors.SetFairy[[int16]$this.Tag].ShowDialog(); $Redux.Colors.Fairy.Text = "Custom"; $Redux.Colors.FairyLabels[[int16]$this.Tag].BackColor = $Redux.Colors.SetFairy[[int16]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetFairy[[int16]$this.Tag].Tag] = $Redux.Colors.SetFairy[[int16]$this.Tag].Color.Name })
        $Redux.Colors.FairyLabels += CreateReduxColoredLabel -Link $buttons[$i] -Color $Redux.Colors.SetFairy[$i].Color
    }

    if (IsSet $Redux.Colors.Fairy) {
        $Redux.Colors.Fairy.Add_SelectedIndexChanged({ SetFairyColorsPreset -ComboBox $Redux.Colors.Fairy -Dialogs $Redux.Colors.SetFairy -Labels $Redux.Colors.FairyLabels })
        SetFairyColorsPreset -ComboBox $Redux.Colors.Fairy -Dialogs $Redux.Colors.SetFairy -Labels $Redux.Colors.FairyLabels
    }

}



#==============================================================================================================================================================================================
function CreateHUDColorOptions([switch]$MM) { 

    $buttons = $Redux.Colors.SetHUDStats = $Redux.Colors.HUDStatsLabels = @()
    CreateReduxGroup -Tag "Colors" -Text "HUD Colors" -IsRedux
    
    CreateReduxComboBox -Name "Hearts"  -Text "Hearts" -Items @("Red", "Green", "Blue", "Yellow", "Randomized", "Custom")                            -Info ("Select a preset for the hearts colors`n" + '"Randomized" fully randomizes the colors each time the patcher is opened')
               $buttons += CreateReduxButton -Tag $buttons.Count -Text "Hearts (Base)"    -Info "Select the color you want for the standard hearts display" -Credits "Ported from Rando"
    if ($MM) { $buttons += CreateReduxButton -Tag $buttons.Count -Text "Hearts (Double)"  -Info "Select the color you want for the enhanced hearts display" -Credits "Ported from Rando" }

    CreateReduxComboBox -Name "Magic" -Text "Magic"  -Items @("Green", "Red", "Blue", "Purple", "Pink", "Yellow", "White", "Randomized", "Custom") -Info ("Select a preset for the magic colors`n"  + '"Randomized" fully randomizes the colors each time the patcher is opened')
               $buttons += CreateReduxButton -Tag $buttons.Count -Text "Magic (Base)"     -Info "Select the color you want for the standard magic display"  -Credits "Ported from Rando"
    if ($MM) { $buttons += CreateReduxButton -Tag $buttons.Count -Text "Magic (Infinite)" -Info "Select the color you want for the infinite magic display"  -Credits "Ported from Rando" }
    
    if ($MM) {
        CreateReduxComboBox -Name "Minimap" -Text "Minimap" -Items @("Cyan", "Green", "Red", "Blue", "Gray", "Purple", "Pink", "Yellow", "White", "Black", "Randomized", "Custom") -Info ("Select a preset for the minimap colors`n" + '"Randomized" fully randomizes the colors each time the patcher is opened')
        $buttons += CreateReduxButton -Tag $Buttons.Count -Text "Minimap" -Info "Select the color you want for the minimap" -Credits "Ported from Rando"
        
    }

    $Redux.Colors.SetHUDStats            += CreateColorDialog -Color "FF4632" -Name "SetBaseHearts"   -IsGame -Button $buttons[$Redux.Colors.SetHUDStats.Count]
    if ($MM) { $Redux.Colors.SetHUDStats += CreateColorDialog -Color "C80000" -Name "SetDoubleHearts" -IsGame -Button $buttons[$Redux.Colors.SetHUDStats.Count]  }
    $Redux.Colors.SetHUDStats            += CreateColorDialog -Color "00C800" -Name "SetBaseMagic"    -IsGame -Button $buttons[$Redux.Colors.SetHUDStats.Count]
    if ($MM) {
        $Redux.Colors.SetHUDStats += CreateColorDialog -Color "0000C8" -Name "SetInfiniteMagic" -IsGame -Button $buttons[$Redux.Colors.SetHUDStats.Count]
        $Redux.Colors.SetHUDStats += CreateColorDialog -Color "00FFFF" -Name "SetMinimap"       -IsGame -Button $buttons[$Redux.Colors.SetHUDStats.Count]
    }

    for ($i=0; $i -lt $buttons.length; $i++) {
        $buttons[$i].Add_Click({
            $Redux.Colors.SetHUDStats[[int16]$this.Tag].ShowDialog(); $Redux.Colors.HUDStatsLabels[[int16]$this.Tag].BackColor = $Redux.Colors.SetHUDStats[[int16]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetHUDStats[[int16]$this.Tag].Tag] = $Redux.Colors.SetHUDStats[[int16]$this.Tag].Color.Name
            
            if ($MM) {
                if     ($this.Tag -lt 2)   { $Redux.Colors.Hearts.Text   = "Custom" }
                elseif ($this.Tag -lt 4)   { $Redux.Colors.Magic.Text    = "Custom" }
                else                       { $Redux.Colors.Minimap.Text  = "Custom" }
            }
            else {
                if ($this.Tag -lt 1)   { $Redux.Colors.Hearts.Text = "Custom" }
                else                   { $Redux.Colors.Magic.Text  = "Custom" }
            }
        })
        $Redux.Colors.HUDStatsLabels += CreateReduxColoredLabel -Link $Buttons[$i] -Color $Redux.Colors.SetHUDStats[$i].Color
    }

    if (IsSet $Redux.Colors.Hearts) {
        $Redux.Colors.Hearts.Add_SelectedIndexChanged({ SetHeartsColorsPreset -ComboBox $Redux.Colors.Hearts -Dialog $Redux.Colors.SetHUDStats[0] -Label $Redux.Colors.HUDStatsLabels[0] })
        SetHeartsColorsPreset -ComboBox $Redux.Colors.Hearts -Dialog $Redux.Colors.SetHUDStats[0] -Label $Redux.Colors.HUDStatsLabels[0]
    }
    
    if ($MM) {
        if (IsSet $Redux.Colors.Hearts) {
            $Redux.Colors.Hearts.Add_SelectedIndexChanged({
                SetHeartsColorsPreset -ComboBox $Redux.Colors.Hearts -Dialog $Redux.Colors.SetHUDStats[1] -Label $Redux.Colors.HUDStatsLabels[1]
                if (IsIndex $Redux.Colors.Hearts) { SetColor -Color "C80000" -Dialog $Redux.Colors.SetHUDStats[1] -Label $Redux.Colors.HUDStatsLabels[1] }
            })
            SetHeartsColorsPreset -ComboBox $Redux.Colors.Hearts -Dialog $Redux.Colors.SetHUDStats[1] -Label $Redux.Colors.HUDStatsLabels[1]
            if (IsIndex $Redux.Colors.Hearts) { SetColor -Color "C80000" -Dialog $Redux.Colors.SetHUDStats[1] -Label $Redux.Colors.HUDStatsLabels[1] }
        }
    }

    if (!$MM) {
        if (IsSet $Redux.Colors.Magic) {
            $Redux.Colors.Magic.Add_SelectedIndexChanged({ SetMagicColorsPreset -ComboBox $Redux.Colors.Magic -Dialog $Redux.Colors.SetHUDStats[1] -Label $Redux.Colors.HUDStatsLabels[1] })
            SetMagicColorsPreset -ComboBox $Redux.Colors.Magic -Dialog $Redux.Colors.SetHUDStats[1] -Label $Redux.Colors.HUDStatsLabels[1]
        }
    }
    else {
        if (IsSet $Redux.Colors.Magic) {
            $Redux.Colors.Magic.Add_SelectedIndexChanged({ SetMagicColorsPreset -ComboBox $Redux.Colors.Magic -Dialog $Redux.Colors.SetHUDStats[2] -Label $Redux.Colors.HUDStatsLabels[2] })
            SetMagicColorsPreset -ComboBox $Redux.Colors.Magic -Dialog $Redux.Colors.SetHUDStats[2] -Label $Redux.Colors.HUDStatsLabels[2]
        }
    }
    
    if ($MM) {
        if (IsSet $Redux.Colors.Magic) {
            $Redux.Colors.Magic.Add_SelectedIndexChanged({
                SetMagicColorsPreset -ComboBox $Redux.Colors.Magic -Dialog $Redux.Colors.SetHUDStats[3] -Label $Redux.Colors.HUDStatsLabels[3]
                if (IsIndex $Redux.Colors.Magic) { SetColor -Color "0000C8" -Dialog $Redux.Colors.SetHUDStats[3] -Label $Redux.Colors.HUDStatsLabels[3] }
            })
            SetMagicColorsPreset -ComboBox $Redux.Colors.Magic -Dialog $Redux.Colors.SetHUDStats[3] -Label $Redux.Colors.HUDStatsLabels[3]
            if (IsIndex $Redux.Colors.Magic) { SetColor -Color "0000C8" -Dialog $Redux.Colors.SetHUDStats[3] -Label $Redux.Colors.HUDStatsLabels[3] }
        }

        if (IsSet $Redux.Colors.Minimap) {
            $Redux.Colors.Minimap.Add_SelectedIndexChanged({ SetMinimapColorsPreset -ComboBox $Redux.Colors.Minimap -Dialog $Redux.Colors.SetHUDStats[4] -Label $Redux.Colors.HUDStatsLabels[4] })
            SetMinimapColorsPreset -ComboBox $Redux.Colors.Minimap -Dialog $Redux.Colors.SetHUDStats[4] -Label $Redux.Colors.HUDStatsLabels[4]
        }
    }

}


#==============================================================================================================================================================================================
function CreateTextColorOptions() { 

    $Items     = @("Blue", "Green", "Randomized", "Custom");
    $buttons   = $Redux.Colors.SetText = $Redux.Colors.TextLabels = @()
    $randomize = '"Randomized" fully randomizes the colors each time the patcher is opened'

                CreateReduxGroup    -Tag  "Colors"      -Text "Text Cursor Colors"
                CreateReduxComboBox -Name "TextCursor"  -Text "Text Cursor" -Items $Items -Info ("Select a preset for the textbox cursor color`n" + $randomize) -Credits "Ported from Rando"
    $buttons += CreateReduxButton   -Tag $Buttons.Count -Text "Text Cursor"               -Info "Select the color you want for the textbox cursor"              -Credits "Ported from Rando"
                CreateReduxComboBox -Name "ShopCursor"  -Text "Shop Cursor" -Items $Items -Info ("Select a preset for the shop cursor color`n"    + $randomize) -Credits "Ported from Rando"
    $buttons += CreateReduxButton   -Tag $Buttons.Count -Text "Shop Cursor"               -Info "Select the color you want for the shop cursor"                 -Credits "Ported from Rando"

    $Redux.Colors.SetText += CreateColorDialog -Color "0050C8" -Name "SetTextCursor" -IsGame -Button $buttons[0]
    $Redux.Colors.SetText += CreateColorDialog -Color "0050FF" -Name "SetShopCursor" -IsGame -Button $buttons[1]

    for ($i=0; $i -lt $buttons.length; $i++) {
        $buttons[$i].Add_Click({
            $Redux.Colors.SetText[[int16]$this.Tag].ShowDialog(); $Redux.Colors.TextLabels[[int16]$this.Tag].BackColor = $Redux.Colors.SetText[[int16]$this.Tag].Color; $GameSettings["Colors"][$Redux.Colors.SetText[[int16]$this.Tag].Tag] = $Redux.Colors.SetText[[int16]$this.Tag].Color.Name
            if ($this.Tag -lt 1)   { $Redux.Colors.TextCursor.Text = "Custom" }
            else                   { $Redux.Colors.ShopCursor.Text = "Custom" }
        })
        $Redux.Colors.TextLabels += CreateReduxColoredLabel -Link $Buttons[$i]  -Color $Redux.Colors.SetText[$i].Color
    }

    if (IsSet $Redux.Colors.TextCursor) {
        $Redux.Colors.TextCursor.Add_SelectedIndexChanged({ SetTextCursorColorsPreset -ComboBox $Redux.Colors.TextCursor -Dialog $Redux.Colors.SetText[0] -Label $Redux.Colors.TextLabels[0] })
        SetTextCursorColorsPreset -ComboBox $Redux.Colors.TextCursor -Dialog $Redux.Colors.SetText[0] -Label $Redux.Colors.TextLabels[0]
    }

    if (IsSet $Redux.Colors.ShopCursor) {
        $Redux.Colors.ShopCursor.Add_SelectedIndexChanged({ SetShopCursorColorsPreset -ComboBox $Redux.Colors.ShopCursor -Dialog $Redux.Colors.SetText[1] -Label $Redux.Colors.TextLabels[1] })
        SetShopCursorColorsPreset -ComboBox $Redux.Colors.ShopCursor -Dialog $Redux.Colors.SetText[1] -Label $Redux.Colors.TextLabels[1]
    }

}



#==============================================================================================================================================================================================
function SetButtonColorsPreset([object]$ComboBox) {
    
    $Text = $ComboBox.Text.replace(' (default)', "")
    if     ($Text -eq "N64 OoT")              { SetColors -Colors @("5A5AFF", "009600", "FFA000", "C80000") -Dialogs $Redux.Colors.SetButtons -Labels $Redux.Colors.ButtonLabels }
    elseif ($Text -eq "N64 MM")               { SetColors -Colors @("64C8FF", "64FF78", "FFF000", "FF823C") -Dialogs $Redux.Colors.SetButtons -Labels $Redux.Colors.ButtonLabels }
    elseif ($Text -eq "GC OoT")               { SetColors -Colors @("00C832", "FF1E1E", "FFA000", "787878") -Dialogs $Redux.Colors.SetButtons -Labels $Redux.Colors.ButtonLabels }
    elseif ($Text -eq "GC MM")                { SetColors -Colors @("64FF78", "FF6464", "FFF000", "787878") -Dialogs $Redux.Colors.SetButtons -Labels $Redux.Colors.ButtonLabels }
    elseif ($Text -eq "Xbox OoT")             { SetColors -Colors @("00C832", "FF1E1E", "505050", "505050") -Dialogs $Redux.Colors.SetButtons -Labels $Redux.Colors.ButtonLabels }
    elseif ($Text -eq "Xbox MM")              { SetColors -Colors @("64FF78", "FF6464", "787878", "787878") -Dialogs $Redux.Colors.SetButtons -Labels $Redux.Colors.ButtonLabels }
    elseif ($Text -eq "JP PlayStation OoT")   { SetColors -Colors @("FF1E1E", "5A96FF", "505050", "505050") -Dialogs $Redux.Colors.SetButtons -Labels $Redux.Colors.ButtonLabels }
    elseif ($Text -eq "JP PlayStation MM")    { SetColors -Colors @("FF6464", "64C8FF", "787878", "787878") -Dialogs $Redux.Colors.SetButtons -Labels $Redux.Colors.ButtonLabels }
    elseif ($Text -eq "WE PlayStation OoT")   { SetColors -Colors @("5A96FF", "FF1E1E", "505050", "505050") -Dialogs $Redux.Colors.SetButtons -Labels $Redux.Colors.ButtonLabels }
    elseif ($Text -eq "WE PlayStation MM")    { SetColors -Colors @("64C8FF", "FF6464", "787878", "787878") -Dialogs $Redux.Colors.SetButtons -Labels $Redux.Colors.ButtonLabels }
    elseif ($Text -eq "N64 TML")              { SetColors -Colors @("3EB3EF", "09D131", "F5ED4D", "DA5955") -Dialogs $Redux.Colors.SetButtons -Labels $Redux.Colors.ButtonLabels }
    elseif ($Text -eq "GC TML")               { SetColors -Colors @("09D131", "DA5955", "F5ED4D", "626262") -Dialogs $Redux.Colors.SetButtons -Labels $Redux.Colors.ButtonLabels }
    elseif ($Text -eq "Randomized")           {
        $Colors = @()
        for ($i=0; $i -lt $Redux.Colors.SetButtons.length; $i++) { $Colors += SetRandomColor -Dialog $Redux.Colors.SetButtons[$i] -Label $Redux.Colors.ButtonLabels[$i] }
        WriteToConsole ("Randomize Button Colors: " + $Colors)
    }

}



#==============================================================================================================================================================================================
function SetBoomerangColorsPreset([object]$ComboBox) {
    
    $Text = $ComboBox.Text.replace(' (default)', "")
    if     ($Text -eq "Vanilla")      { SetColors -Colors @("FFFF64", "FFFF64") -Dialogs $Redux.Colors.SetBoomerang -Labels $Redux.Colors.BoomerangLabels }
    elseif ($Text -eq "Gold Quest")   { SetColors -Colors @("BBBBBB", "BBBBBB") -Dialogs $Redux.Colors.SetBoomerang -Labels $Redux.Colors.BoomerangLabels }
    elseif ($Text -eq "Randomized")   {
        $Colors = @()
        for ($i=0; $i -lt $Redux.Colors.SetBoomerang.length; $i++) { $Colors += SetRandomColor -Dialog $Redux.Colors.SetBoomerang[$i] -Label $Redux.Colors.BoomerangLabels[$i] }
        WriteToConsole ("Randomize Boomerang Trail Colors: " + $Colors)
    }

}



#==============================================================================================================================================================================================
function SetBombchuColorsPreset([object]$ComboBox) {
    
    $Text = $ComboBox.Text.replace(' (default)', "")
    if     ($Text -eq "Vanilla")      { SetColors -Colors @("FA0000", "FA0000") -Dialogs $Redux.Colors.SetBombchu -Labels $Redux.Colors.BombchuLabels }
    elseif ($Text -eq "Randomized")   {
        $Colors = @()
        for ($i=0; $i -lt $Redux.Colors.SetBombchu.length; $i++) { $Colors += SetRandomColor -Dialog $Redux.Colors.SetBombchu[$i] -Label $Redux.Colors.BombchuLabels[$i] }
        WriteToConsole ("Randomize Bombchu Trail Colors: " + $Colors)
    }

}



#==============================================================================================================================================================================================
function SetRupeeColorsPreset([object]$ComboBox) {
    
    $Text = $ComboBox.Text.replace(' (default)', "")
    if     ($Text -eq "Redux")        { SetColors -Colors @("C8FF64", "8282FF", "FF6464", "FF5AFF") -Dialogs $Redux.Colors.SetRupee -Labels $Redux.Colors.RupeeLabels }
    elseif ($Text -eq "Randomized")   {
        $Colors = @()
        for ($i=0; $i -lt $Redux.Colors.SetRupee.length; $i++) { $Colors += SetRandomColor -Dialog $Redux.Colors.SetRupee[$i] -Label $Redux.Colors.RupeeLabels[$i] }
        WriteToConsole ("Randomize Rupee Icon HUD Colors: " + $Colors)
    }

}



#==============================================================================================================================================================================================
function SetRupeeVanillaColorsPreset([object]$ComboBox) {
    
    $Text = $ComboBox.Text.replace(' (default)', "")
    if     ($Text -eq "Base Wallet")       { SetColor -Color "C8FF64" -Dialog $Redux.Colors.SetRupeeVanilla -Label $Redux.Colors.RupeeVanillaLabel }
    elseif ($Text -eq "Adult's Wallet")    { SetColor -Color "8282FF" -Dialog $Redux.Colors.SetRupeeVanilla -Label $Redux.Colors.RupeeVanillaLabel }
    elseif ($Text -eq "Giant's Wallet")    { SetColor -Color "FF6464" -Dialog $Redux.Colors.SetRupeeVanilla -Label $Redux.Colors.RupeeVanillaLabel }
    elseif ($Text -eq "Tycoon's Wallet")   { SetColor -Color "FF5AFF" -Dialog $Redux.Colors.SetRupeeVanilla -Label $Redux.Colors.RupeeVanillaLabel }
    elseif ($Text -eq "Gold Quest")        { SetColor -Color "FFFF00" -Dialog $Redux.Colors.SetRupeeVanilla -Label $Redux.Colors.RupeeVanillaLabel }
    elseif ($Text -eq "Randomized") {
        $Colors = SetRandomColor -Dialog $Redux.Colors.SetRupeeVanilla -Label $Redux.Colors.RupeeVanillaLabel
        WriteToConsole ("Randomize Rupee Icon Colors: " + $Color)
    }

}



#==============================================================================================================================================================================================
function SetFairyColorsPreset([object]$ComboBox, [Array]$Dialogs, [Array]$Labels) {
    
    $Text = $ComboBox.Text.replace(' (default)', "")
    if     ($Text -eq "Navi")                { SetFairyColors -Inner "FFFFFF" -Outer "0000FF" -Dialogs $Dialogs -Labels $Labels }
    elseif ($Text -eq "Tatl")                { SetFairyColors -Inner "FFFFE6" -Outer "DCA050" -Dialogs $Dialogs -Labels $Labels }
    elseif ($Text -eq "Tael")                { SetFairyColors -Inner "3F125D" -Outer "FA280A" -Dialogs $Dialogs -Labels $Labels }
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
        for ($i=0; $i -lt $Dialogs.length; $i++) { $Colors += SetRandomColor -Dialog $Dialogs[$i] -Label $Labels[$i] }
        WriteToConsole ("Randomize Fairy Colors: " + $Colors)
    }

}



#==============================================================================================================================================================================================
function SetFairyColors([string]$Inner, [string]$Outer, [Array]$Dialogs, [Array]$Labels) {
    
    $GameSettings["Colors"][$Dialogs[0].Tag] = $Inner; $Labels[0].BackColor = $Dialogs[0].Color = "#" + $Inner
    $GameSettings["Colors"][$Dialogs[1].Tag] = $Outer; $Labels[1].BackColor = $Dialogs[1].Color = "#" + $Outer

    if ($Dialogs.count -gt 2) {
        $GameSettings["Colors"][$Dialogs[2].Tag] = "00FF00"; $Labels[2].BackColor = $Dialogs[2].Color = "#00FF00"
        $GameSettings["Colors"][$Dialogs[3].Tag] = "00FF00"; $Labels[3].BackColor = $Dialogs[3].Color = "#00FF00"
        $GameSettings["Colors"][$Dialogs[4].Tag] = "9696FF"; $Labels[4].BackColor = $Dialogs[4].Color = "#9696FF"
        $GameSettings["Colors"][$Dialogs[5].Tag] = "9696FF"; $Labels[5].BackColor = $Dialogs[5].Color = "#9696FF"
        $GameSettings["Colors"][$Dialogs[6].Tag] = "FFFF00"; $Labels[6].BackColor = $Dialogs[6].Color = "#FFFF00"
        $GameSettings["Colors"][$Dialogs[7].Tag] = "C89B00"; $Labels[7].BackColor = $Dialogs[7].Color = "#C89B00"
    }

}



#==============================================================================================================================================================================================
function SetTunicColorsPreset([object]$ComboBox, [object]$Dialog, [object]$Label) {
    
    $text = $ComboBox.Text.replace(' (default)', "")
    if     ($text -eq "Azure Blue")           { SetColor -Color "139ED8" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Beige")                { SetColor -Color "C0A0A0" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Black")                { SetColor -Color "303030" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Blood Orange")         { SetColor -Color "FE4B03" -Dialog $Dialog -Label $Label } 
    elseif ($text -eq "Blood Red")            { SetColor -Color "830303" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Blush Pink")           { SetColor -Color "F86CF8" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Dark Green")           { SetColor -Color "002518" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Dawn & Dusk Green")    { SetColor -Color "4C9714" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Dawn & Dusk Purple")   { SetColor -Color "462640" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Dirty Yellow")         { SetColor -Color "E0D860" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Fuchsia")              { SetColor -Color "FF00FF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Gold Quest Gold")      { SetColor -Color "FFCC00" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Gold Quest Purple")    { SetColor -Color "83226C" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Gold Quest White")     { SetColor -Color "D7D7D7" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Gold")                 { SetColor -Color "D8B060" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Goron Red 3D")         { SetColor -Color "B70212" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Goron Red")            { SetColor -Color "641400" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Gray")                 { SetColor -Color "A0A0B0" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Guardian Silver")      { SetColor -Color "A5AFBE" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Hero Gold")            { SetColor -Color "C8AF32" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Hot Pink")             { SetColor -Color "FF69B4" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Kokiri Green 3D")      { SetColor -Color "1AA712" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Kokiri Green")         { SetColor -Color "1E691B" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Light Red")            { SetColor -Color "F87C6D" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Lumen")                { SetColor -Color "508CF0" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Magician Green")       { SetColor -Color "00913C" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Majora Purple")        { SetColor -Color "400040" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "NES Green")            { SetColor -Color "00D000" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Orange")               { SetColor -Color "E07940" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Pajama Blue")          { SetColor -Color "64B4FF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Persian Rose")         { SetColor -Color "FF1493" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Purple Heart")         { SetColor -Color "8A2BE2" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Purple")               { SetColor -Color "953080" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Rose Pink")            { SetColor -Color "FF90B3" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Royal Blue")           { SetColor -Color "400090" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Shadow Purple 3D")     { SetColor -Color "AF1FB7" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Shadow Purple")        { SetColor -Color "503CAA" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Silver")               { SetColor -Color "D0F0FF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Sonic Blue")           { SetColor -Color "5090E0" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Teal")                 { SetColor -Color "30D0B0" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Twitch Purple")        { SetColor -Color "6441A5" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Vivid Cyan")           { SetColor -Color "13E9D8" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "White")                { SetColor -Color "F0F0FF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Zora Blue 3D")         { SetColor -Color "0A3BAF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Zora Blue")            { SetColor -Color "003C64" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Randomized")           { SetRandomColor -Dialog $Dialog -Label $Label -Message "Randomize Tunic Color" }

}



#==============================================================================================================================================================================================
function SetGauntletsColorsPreset([object]$ComboBox, [object]$Dialog, [object]$Label) {
    
    $Text = $ComboBox.Text.replace(' (default)', "")
    if     ($text -eq "Silver")       { SetColor -Color "FFFFFF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Gold")         { SetColor -Color "FECF0F" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Black")        { SetColor -Color "000006" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Green")        { SetColor -Color "025918" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Blue")         { SetColor -Color "06025A" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Bronze")       { SetColor -Color "600602" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Red")          { SetColor -Color "FF0000" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Sky Blue")     { SetColor -Color "025DB0" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Pink")         { SetColor -Color "FA6A90" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Magenta")      { SetColor -Color "FF00FF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Orange")       { SetColor -Color "DA3800" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Lime")         { SetColor -Color "5BA806" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Purple")       { SetColor -Color "800080" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Randomized")   { SetRandomColor -Dialog $Dialog -Label $Label -Message "Randomize Gauntlets Color" }

}



#==============================================================================================================================================================================================
function SetMirrorShieldFrameColorsPreset([object]$ComboBox, [object]$Dialog, [object]$Label) {
    
    $Text = $ComboBox.Text.replace(' (default)', "")
    if     ($Text -eq "Red")          { SetColor -Color "D70000" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Green")        { SetColor -Color "00FF00" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Blue")         { SetColor -Color "0040D8" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Yellow")       { SetColor -Color "FFFF64" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Cyan")         { SetColor -Color "00FFFF" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Magenta")      { SetColor -Color "FF00FF" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Orange")       { SetColor -Color "FFA500" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Gold")         { SetColor -Color "FFD700" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Purple")       { SetColor -Color "800080" -Dialog $Dialog -Label $Label }
    elseif ($Text -eq "Pink")         { SetColor -Color "FF69B4" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Randomized")   { SetRandomColor -Dialog $Dialog -Label $Label -Message "Randomize Mirror Shield Frame Color" }

}



#==============================================================================================================================================================================================
function SetHeartsColorsPreset([object]$ComboBox, [object]$Dialog, [object]$Label) {
    
    $text = $ComboBox.Text.replace(' (default)', "")
    if     ($text -eq "Red")          { SetColor -Color "FF4632" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Green")        { SetColor -Color "46C832" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Blue")         { SetColor -Color "3246FF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Yellow")       { SetColor -Color "FFE000" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Randomized")   { SetRandomColor -Dialog $Dialog -Label $Label -Message "Randomize Hearts Color" }

}



#==============================================================================================================================================================================================
function SetTextCursorColorsPreset([object]$ComboBox, [object]$Dialog, [object]$Label) {
    
    $text = $ComboBox.Text.replace(' (default)', "")
    if     ($text -eq "Blue")         { SetColor -Color "0050C8" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Green")        { SetColor -Color "00C850" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Randomized")   { SetRandomColor -Dialog $Dialog -Label $Label -Message "Randomize Magic Color" }

}


#==============================================================================================================================================================================================
function SetShopCursorColorsPreset([object]$ComboBox, [object]$Dialog, [object]$Label) {
    
    $text = $ComboBox.Text.replace(' (default)', "")
    if     ($text -eq "Blue")         { SetColor -Color "0050FF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Green")        { SetColor -Color "00FF50" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Randomized")   { SetRandomColor -Dialog $Dialog -Label $Label -Message "Randomize Magic Color" }

}



#==============================================================================================================================================================================================
function SetMagicColorsPreset([object]$ComboBox, [object]$Dialog, [object]$Label) {
    
    $text = $ComboBox.Text.replace(' (default)', "")
    if     ($text -eq "Green")        { SetColor -Color "00C800" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Red")          { SetColor -Color "C80000" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Blue")         { SetColor -Color "0030FF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Purple")       { SetColor -Color "B000FF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Pink")         { SetColor -Color "FF00C8" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Yellow")       { SetColor -Color "FFFF00" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "White")        { SetColor -Color "FFFFFF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Randomized")   { SetRandomColor -Dialog $Dialog -Label $Label -Message "Randomize Magic Color" }

}



#==============================================================================================================================================================================================
function SetMinimapColorsPreset([object]$ComboBox, [object]$Dialog, [object]$Label) {
    
    $text = $ComboBox.Text.replace(' (default)', "")
    if     ($text -eq "Cyan")         { SetColor -Color "00FFFF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Green")        { SetColor -Color "00FF00" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Red")          { SetColor -Color "FF0000" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Blue")         { SetColor -Color "0000FF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Gray")         { SetColor -Color "808080" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Purple")       { SetColor -Color "B000FF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Pink")         { SetColor -Color "FF00C8" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Yellow")       { SetColor -Color "FFFF00" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "White")        { SetColor -Color "FFFFFF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Black")        { SetColor -Color "000000" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Randomized")   { SetRandomColor -Dialog $Dialog -Label $Label -Message "Randomize Minimap Color" }

}



#==============================================================================================================================================================================================
function SetSwordColorsPreset([object]$ComboBox, [object]$Dialog, [object]$Label) {
    
    $text = $ComboBox.Text.replace(' (default)', "")
    if     ($text -eq "Black")        { SetColor -Color "000000" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "White")        { SetColor -Color "FFFFFF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Red")          { SetColor -Color "FF0000" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Green")        { SetColor -Color "00FF00" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Blue")         { SetColor -Color "0000FF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Cyan")         { SetColor -Color "00FFFF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Magenta")      { SetColor -Color "FF00FF" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Orange")       { SetColor -Color "FFA500" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Gold")         { SetColor -Color "FFD700" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Purple")       { SetColor -Color "800080" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Pink")         { SetColor -Color "FF69B4" -Dialog $Dialog -Label $Label }
    elseif ($text -eq "Randomized")   { SetRandomColor -Dialog $Dialog -Label $Label -Message "Randomize Spin Attack Color" }

}



#==============================================================================================================================================================================================
function SetColor([string]$Color, [object]$Dialog, [object]$Label) {
    
    $GameSettings["Colors"][$Dialog.Tag] = $Color; $Label.BackColor = $Dialog.Color = "#" + $Color

}



#==============================================================================================================================================================================================
function SetRandomColor([object]$Dialog, [object]$Label, [string]$Message) {

    $green = Get8Bit -Value (Get-Random -Maximum 255)
    $red   = Get8Bit -Value (Get-Random -Maximum 255)
    $blue  = Get8Bit -Value (Get-Random -Maximum 255)
    if (IsSet $Message) { WriteToConsole ($Message + ": " + ($green + $red + $blue)) }
    SetColor -Color ($green + $red + $blue) -Dialog $Dialog -Label $Label
    return ($green + $red + $blue)

}



#==============================================================================================================================================================================================
function SetColors([Array]$Colors, [Array]$Dialogs, [Array]$Labels) {
    
    for ($i=0; $i -lt $Colors.length; $i++) {
        $GameSettings["Colors"][$Dialogs[$i].Tag] = $Colors[$i]
        $Labels[$i].BackColor = $Dialogs[$i].Color = "#" + $Colors[$i]
    }

}



#==============================================================================================================================================================================================
function SetFormColorLabel([object]$ComboBox, [object]$Label) {
    
    $text = $ComboBox.Text.replace(' (default)', "")
    if ($text -eq "Green")            { $Label.BackColor = [System.Drawing.Color]::FromArgb(30,  105, 27 ) } # 1E691B
    if ($text -eq "Red")              { $Label.BackColor = [System.Drawing.Color]::FromArgb(105, 30,  27 ) } # 961E1B
    if ($text -eq "Blue")             { $Label.BackColor = [System.Drawing.Color]::FromArgb(30,  27,  105) } # 1E1B96
    if ($text -eq "Mustard Yellow")   { $Label.BackColor = [System.Drawing.Color]::FromArgb(131, 126, 75 ) } # 837E4B
    if ($text -eq "Autumn Yellow")    { $Label.BackColor = [System.Drawing.Color]::FromArgb(105, 90,  27 ) } # 695A1B
    if ($text -eq "Dull Green")       { $Label.BackColor = [System.Drawing.Color]::FromArgb(90,  105, 27 ) } # 5A691B

}



#==============================================================================================================================================================================================

Export-ModuleMember -Function PatchModel

Export-ModuleMember -Function GetOoTShopItem
Export-ModuleMember -Function GetOoTCollision
Export-ModuleMember -Function GetButtonScale
Export-ModuleMember -Function SetMMCUpTextCoords
Export-ModuleMember -Function GetOoTEntranceIndex
Export-ModuleMember -Function GetSFXID
Export-ModuleMember -Function GetOoTMusicID
Export-ModuleMember -Function GetMMMusicID
Export-ModuleMember -Function GetMMItemID
Export-ModuleMember -Function GetMMInstrumentID

Export-ModuleMember -Function PatchMuteMusic
Export-ModuleMember -Function PatchReplaceMusic
Export-ModuleMember -Function MusicOptions
Export-ModuleMember -Function GetReplacementTracks
Export-ModuleMember -Function ChangeStringIntoDigits

Export-ModuleMember -Function ShowStylePreview
Export-ModuleMember -Function ShowHudPreview
Export-ModuleMember -Function ShowEquipmentPreview
Export-ModuleMember -Function ChangeModelsSelection
Export-ModuleMember -Function LoadModelsList

Export-ModuleMember -Function CreateButtonColorOptions
Export-ModuleMember -Function CreateBoomerangColorOptions
Export-ModuleMember -Function CreateBombchuColorOptions
Export-ModuleMember -Function CreateRupeeColorOptions
Export-ModuleMember -Function CreateRupeeVanillaColorOptions
Export-ModuleMember -Function CreateSpinAttackColorOptions
Export-ModuleMember -Function CreateSwordTrailColorOptions
Export-ModuleMember -Function CreateFairyColorOptions
Export-ModuleMember -Function CreateHUDColorOptions
Export-ModuleMember -Function CreateTextColorOptions

Export-ModuleMember -Function SetFairyColorsPreset
Export-ModuleMember -Function SetFairyColors
Export-ModuleMember -Function SetTunicColorsPreset
Export-ModuleMember -Function SetGauntletsColorsPreset
Export-ModuleMember -Function SetMirrorShieldFrameColorsPreset

Export-ModuleMember -Function SetColor
Export-ModuleMember -Function SetColors
Export-ModuleMember -Function SetFormColorLabel
