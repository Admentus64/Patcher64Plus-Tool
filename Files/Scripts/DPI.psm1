#==============================================================================================================================================================================================
#  DPI AWARENESS
#==============================================================================================================================================================================================
#  Makes the form "DPI Aware" so it can recognize when the DPI is changed.
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$Source = @"
using System;
using System.Runtime.InteropServices;
public class DPI
{
  [DllImport("user32.dll")]
  public static extern bool SetProcessDPIAware();
  public static void SetProcessAware()
  {
    SetProcessDPIAware();
  }
}
"@

# Add the code as a type definition in C# language so we can make use of it.
$RefAssem = "System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089"
Add-Type -TypeDefinition $Source -ReferencedAssemblies $RefAssem -Language 'CSharp' | Out-Null



#==============================================================================================================================================================================================
#  SWITCH TO ENABLE/DISABLE HIGH DPI SCALING
#==============================================================================================================================================================================================
#  This can be used as a switch to allow the user to enable/disable high DPI scaling.
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# $global:DisableHighDPIMode = $False

#==============================================================================================================================================================================================
#  FUNCTION TO ADJUST ACCORDING TO DPI SCALING
#==============================================================================================================================================================================================
#  Adjusts a value to scale according to the current DPI. The "$DPIMultiplier" is a global variable calculated on init.
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function DPISize($Value, [switch]$Round=$false, $Add=0, $AddX=0, $AddY=0) {
    
    # Immediately return the value if scaling is disabled.
    if ($DisableHighDPIMode) { return $Value }

    # Get the variable type so we know what to do with it.
    $ValueType = $Value.GetType().ToString()

    # Shorten this massive blob of text with a variable.
    $RMode = [System.MidpointRounding]::AwayFromZero

    # If the value fed was a string, convert it to an integer.
    if ($ValueType -eq "System.String")
    {
      # If there is a period, try to parse it as an integer.
      if (($ValueType -like "*.*") -and ($Value -as [decimal] -is [decimal]))
      {
          $Value = [Convert]::ToDecimal($Value)
          $ValueType = "System.Decimal"
      }  
      # Try to parse it as an integer.
      elseif ($Value -as [int] -is [int])
      {
          $Value = [Convert]::ToInt32($Value)
          $ValueType = "System.Int32"
      }
    }
    # The type of variable will determine the calculation method.
    switch ($ValueType) {

        # 16-Bit Integer, Aliases: Int16
        'System.Int16' {
            if (!$Round)   { $Value = [int16][Math]::Truncate($Value * $DPIMultiplier) } 
            else           { $Value = [int16][Math]::Round(($Value * $DPIMultiplier), $RMode) }
            return         ( $Value + $Add + $AddX + $AddY )
        }

        # 32-Bit Integer, Aliases: Int, Int32
        'System.Int32' {
            if (!$Round)   { $Value = [int32][Math]::Truncate($Value * $DPIMultiplier) } 
            else           { $Value = [int32][Math]::Round(($Value * $DPIMultiplier), $RMode) }
            return         ( $Value + $Add + $AddX + $AddY )
        }

        # 64-Bit Integer, Aliases: Int64, Long
        'System.Int64' {
            if (!$Round)   { $Value = [int64][Math]::Truncate($Value * $DPIMultiplier) }
            else           { $Value = [int64][Math]::Round(($Value * $DPIMultiplier), $RMode) }
            return         ( $Value + $Add + $AddX + $AddY )
        }

        # Single Float, Aliases: Single, Float
        'System.Single' {
            if (!$Round)   { $Value = [single][Math]::Truncate($Value * $DPIMultiplier) }
            else           { $Value = [single][Math]::Round(($Value * $DPIMultiplier), $RMode) }
            return         ( $Value + $Add + $AddX + $AddY )
        }

        # Double Float
        'System.Double' {
            if (!$Round)   { $Value = [double][Math]::Truncate($Value * $DPIMultiplier) }
            else           { $Value = [double][Math]::Round(($Value * $DPIMultiplier), $RMode) }
            return         ( $Value + $Add + $AddX + $AddY )
        }

        # Decimal
        'System.Decimal' {
            if (!$Round)   { $Value = [decimal]($Value * $DPIMultiplier) }
            else           { $Value = [decimal][Math]::Round(($Value * $DPIMultiplier), $RMode) }
            return         ( $Value + $Add + $AddX + $AddY )
        }

        # Drawing Size (Width, Height)
        'System.Drawing.Size' {
            if (!$Round)   { $Value = New-Object Drawing.Size([int][Math]::Truncate($Value.Width * $DPIMultiplier), [int32][Math]::Truncate($Value.Height * $DPIMultiplier)) }
            else           { $Value = New-Object Drawing.Size([int][Math]::Round(($Value.Width * $DPIMultiplier), $RMode), [int32][Math]::Round(($Value.Height * $DPIMultiplier), $RMode)) }
            return         ( New-Object Drawing.Size(($Value.Width + $Add + $AddX), ($Value.Height + $Add + $AddY)) )
        }

        # Drawing Point (X, Y)
        'System.Drawing.Point' {
            if (!$Round)   { $Value = New-Object Drawing.Point([int][Math]::Truncate($Value.X * $DPIMultiplier), [int32][Math]::Truncate($Value.Y * $DPIMultiplier)) }
            else           { $Value = New-Object Drawing.Point([int][Math]::Round(($Value.X * $DPIMultiplier), $RMode), [int32][Math]::Round(($Value.Y * $DPIMultiplier), $RMode)) }
            return         ( New-Object Drawing.Point(($Value.X + $Add + $AddX), ($Value.Y + $Add + $AddY)) )
        }

    }

}



#==============================================================================================================================================================================================
#  INITIALIZATION 
#==============================================================================================================================================================================================
#  This is where the magic happens.
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function InitializeHiDPIMode() {

    # Check to see if high DPI is disabled.
    if (!$DisableHighDPIMode) {

        # Make the application DPI Aware.
        [DPI]::SetProcessAware()
    }
    # Create a form that we can pull the DPI from.
    $DPI_Form = New-Object Windows.Forms.Form
    $Graphics = $DPI_Form.CreateGraphics();
    $DPIValue = [Convert]::ToInt32($Graphics.DpiX)
    $DPI_Form.Dispose();

    # Check to see if high DPI is disabled.
    if (!$DisableHighDPIMode) {

        # Get the multiplier derived from the DPI setting.
        $global:DPIMultiplier = ($DPIValue / 24) * 0.25

    }
}



#==============================================================================================================================================================================================

Export-ModuleMember -Function DPISize
Export-ModuleMember -Function InitializeHiDPIMode