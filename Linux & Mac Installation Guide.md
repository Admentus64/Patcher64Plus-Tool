# **Running Patcher64+ Tool on Linux / MacOS**

### **Index**

* [**Introduction**](#introdution)

* [**Install Wine**](#install-wine)

* [**Download PowerShell (x86)**](#download-powershell-x86)

* [**Download Patcher64+ Tool**](#download-patcher64+-tool)

* [**Running Patcher64+ Tool with Wine+PowerShell**](#running-patcher64+-tool-with-wine+powershell)

* [**Create an Executable Binary**](#create-an-executable-binary)

* [**Possible Errors**](#possible-errors)

-----------------

## Introduction

Patcher64+ Tool was created from the start with PowerShell for Windows. However, due to the dependance of the code on Windows.Forms for window creation, Patcher64+ Tool cannot run under the PowerShell installation for Linux and Mac. 
It could probably be made to run in it through some sort of PowerShell+Mono trickery, but it's far too complicated to even attempt.

To make this tool run on either Linux or Mac devices, we'll make use of both [Wine ("Wine Is Not an Emulator")](https://www.winehq.org/) and [PowerShell for 32-bit Windows systems](https://github.com/PowerShell/PowerShell/releases/).

This tutorial will install Wine on its latest stable version (Patcher64 was tested with Wine 8.0), Winetricks (to handle the .NET requirements for PowerShell and its Win.Forms, as well as Mono in some cases), PowerShell x86 (Only the 32-bit Windows version runs through Wine) and lastly the Patcher64+ Tool.

-----------------

## Install Wine

To install Wine, the instructions vary depending on the distribution the user is running. Here, we'll give different solutions depending on what package manager the distro uses for the most popular distributions.

If you use a 32-bit machine (x86) make sure to install only the _wine32_ option (for distros that have it), if you're on 64-bits, you can install both. Open your Linux Terminal / Console and run these commands depending on your distribution / OS:

**NOTE #1:** The `$` symbol on each command is just to visualize that they're terminal commands. The symbol should NOT be typed in!

**NOTE #2:** If you get some window prompts during the installation of the `winetricks` packages, like `dotnet452` or `mono210`, please refer to the [Possible Errors](#possible-errors) section of the Tutorial.

* **Ubuntu / Debian** (or distros with _Aptitude_ as package manager)
    ```
    $ sudo apt update
    $ sudo apt install wine32 wine64 winetricks
    $ winetricks dotnet452 mono210
    ```

* **Gentoo** (or distros with _Portage_ as package manager)
    ```
    $ sudo emerge --sync
    $ sudo emerge wine-vanilla winetricks wine-mono
    $ winetricks dotnet452
    ```

* **Arch Linux** (or distros with _pacman_ as package manager)
    ```
    $ sudo pacman -Sy
    $ sudo pacman -S wine wine-mono winetricks
    $ winetricks dotnet452
    ```
* **MacOS**

    To install Wine on a Mac computer, you will need to download and install "[Homebrew](https://brew.sh/)" on the system first. The first command installs homebrew, and the next ones run the Wine installation. 
    ```
    $ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    $ brew tap homebrew/cask-versions
    $ brew install --cask --no-quarantine && brew install winetricks
    $ winetricks dotnet452 mono210
    ```
    Homebrew could also be installed as a .pkg on MacOS, but for ease of use, we'll stick to the script method instead. Those interested can [install the .pkg from Homebrew's GitHub page](https://github.com/Homebrew/brew/releases/tag/4.1.11).  

* **Other Linux Distributions**

    The installation of Wine on other Linux (or even Mac) distributions is entirely possible, but it depends on what type of package manager the distribution uses to know what command to run for the install. In any case, be sure to search with your package manager for `wine` or `wine-stable`, `winetricks` and `wine-mono`.
    
    In case your distribution doesn't have `wine-mono` as a package, install Mono for Wine through winetricks with the command `winetricks mono210`, be sure to install .NET 4.5.2 as well with `winetricks dotnet452`.

### Confirm & Configure Wine installation

To confirm whether or not both Wine & Winetricks installed successfully in your system, run the following commands in Terminal / Console. Each one of them should give an output with the version of the program they're running:

```
$ wine --version
	wine-8.0.1
```

```
$ winetricks --version
	20230212 - sha256sum: 524c3cd602ef222da3dc644a0a741edd8bca6dfb72ba3c63998a76b82f9e77b2
```

After this, we need to make sure that the Wine Prefix is set to a Windows version compatible with PowerShell, with the earliest being Windows 7. For this, we need to run the `winecfg` command on terminal, and once the configuration window opens, check the "Windows Version" option at the bottom and make sure it says "Windows 7".

<p align="center">
<img src="https://i.imgur.com/62G7oTU.png" alt="winecfg">
</p>

If Windows 7 was already set as the version, you can leave it like that and close the window, then proceed to the next step of [downloading PowerShell](#download-powershell-x86).

However, if there was another Windows version set, like Windows XP or Vista for example, we need to change the version to "Windows 7", and then run the `winetricks` packages installations again from Terminal (the packages being `dotnet452` and/or `mono210` depending on our distribution/OS).

-----------------

## Download PowerShell x86

After installing both Wine & Winetricks, and confirm that they're running, we can continue with PowerShell.

Enter the [PowerShell's releases page on GitHUb, and download version 7.3.6](https://github.com/PowerShell/PowerShell/releases/tag/v7.3.6) (as 7.3.6 was the most recent version known to work for Patcher64 with Wine). Make sure to download exactly the .zip that ends with win-x86, like [PowerShell-7.3.6-win-x86.zip](https://github.com/PowerShell/PowerShell/releases/download/v7.3.6/PowerShell-7.3.6-win-x86.zip), downloading any other version won't work for this purpose.

After downloading the x86 zip, create a folder called "PowerShell" anywhere in your system and extract the contents of the zip into said folder. Once all the contents are inside that folder, move the entire "PowerShell" folder into the following directory:

**NOTE:** The "user" in the path **_should be changed to your username_** in your Linux/Mac OS!

`/home/user/.wine/drive_c/Program Files (x86)/PowerShell/`

Inside the PowerShell folder you should have all of the files for PowerShell to run, including the `pwsh.exe` executable, which is the one we'll run with Wine later on. For now, we'll leave that folder where it's at, and proceed with downloading Patcher64+ Tool.

Newer versions of PowerShell could work, but they haven't been tested. For those that want to try out newer versions of PowerShell for Patcher64, they can be downloaded from [PowerShell's releases page on their GitHub](https://github.com/PowerShell/PowerShell/releases/). Additionally, and for reference's sake, the earliest possible version of PowerShell in which Patcher64+ Tool can run from is PowerShell v5.1.22468.1000.

-----------------

## Download Patcher64+ Tool

Once PowerShell for Windows 32-bit (x86) has been downloaded and extracted in the right folder, we [proceed to download the latest version of Patcher64+ Tool from the GitHub repository](https://github.com/Admentus64/Patcher64Plus-Tool/releases). As of the time of writing this tutorial, the latest tested version is v22.0.0 of Patcher64.

The downloaded package should be a .7z file called "Patcher64+ Tool.7z". As with the PowerShell download, we will first create a new folder called "Patcher64+ Tool" extract the contents of this .7z into it.

Once all the contents have been extracted, we will move the "Patcher64+ Tool" folder into the same "Program Files (x86)" directory that the PowerShell folder resides in, with the final path /directory like this:

`/home/user/.wine/drive_c/Program Files (x86)/Patcher64+ Tool/`

**NOTE:** Once again, remember that the "user" in the path **_should be changed to your username_** in your Linux/Mac OS!

-----------------

## Running Patcher64+ Tool with Wine+PowerShell

Now that we have both PowerShell and Patcher64+ Tool downloaded and in their respective "Program Files (x86)" path for Wine, we will test and verify that the app can run in our system.

Open Terminal one again, and type in the following command:

    `$ WINEDEBUG=-all wine "/home/user/.wine/drive_c/Program Files (x86)/PowerShell/pwsh.exe" "/home/user/.wine/drive_c/Program Files (x86)/Patcher64+ Tool/Patcher64+ Tool.ps1"`

After running the command, you should start seeing the log information for Patcher64+ Tool in the terminal being registered, and after a few seconds, you should be greeted with this:

<p align="center">
<img src="https://i.imgur.com/OOCwFKe.png" alt="Patcher64+ Tool on Linux">
</p>

Once you see this, you have successfully run Patcher64+ Tool on Linux / Mac!

**NOTE:** If, for some reason, Patcher64+ Tool refuses to open after more than 5 minutes, please refer to the [Possible Errors](#possible-errors) section of the Tutorial.

-----------------

## Create an Executable Binary

With the previous step, you can run Patcher64+ Tool from terminal with quite the lengthy command.

If you want to make all this lenghty command into a simple one word instruction that can run from terminal, we can make either a script or an executable binary, either way works and it boils down to what distributions / OS you are using at the end of the day.

We can start by creating a simple bash script with the name `patcher64.sh`, which will encapsulate the command we run for launching Patcher64+ Tool:

    ```
    #! /bin/bash

    $ WINEDEBUG=-all wine "/home/user/.wine/drive_c/Program Files (x86)/PowerShell/pwsh.exe" "/home/user/.wine/drive_c/Program Files (x86)/Patcher64+ Tool/Patcher64+ Tool.ps1"
    ```

After creating the `patcher64.sh` script, save it and then run the following command on Terminal to give it executable permissions:

    `chmod +x patcher64.sh`

With this, you can now type `./patcher64.sh` on Terminal, and Patcher64+ Tool should launch just as if you wrote the entire command.

If you instead want the script to be recognized as an actual command when typing it in Terminal, then you can copy the script into the `/usr/local/bin` directory, like this:

`sudo cp patcher64.sh /usr/local/bin/patcher64`

Now running `patcher64` directly from Terminal without having any directory specified should open Patcher64+ Tool.

**IMPORTANT:** Do take into consideration that the `/usr/local/bin` directory isn't always configured to be the default path for local binaries made or installed by the user, as this changes from distro to distro. If this directory doesn't exist in your system, you will have to manually configure a local path for user binaries, which is out of the scope of this tutorial.

-----------------

## Possible Errors

Given how we are basically running Patcher64 through several layers, some errors are bound to happen.

* _Winetricks installations errors_

    When installing either `dotnet452` or `mono210`, it's possible that you might get the following message:

<p align="center">
<img src="https://i.imgur.com/3gTjY5z.png" alt="Winetricks error">
</p>

    This message can be ignored, simply click "OK" and the installation of the packages through winetricks should continue as normal.

* _Errors when compiling a ROM with Patcher64+ Tool_

    After getting Patcher64+ Tool to launch through Wine, and trying to compile a hack with it, it's possible that you might get some window prompts regarding an error with `flips.exe`, like in the following image:

<p align="center">
<img src="https://i.imgur.com/wqMNSgA.png" alt="flips.exe error">
</p>

    In these cases, you can simply close the prompted message and the compilation of the hack should continue as normal. It has been tested and verified that this error causes no issue on ROM compilations at all, so we can ignore these errors altogether.

* _Patcher64+ Tool refuses to run_

    In case of a failure when opening Patcher64, the most likely culprit is in PowerShell itself, and not Patcher64. In this dire case, if running the wine command through Terminal listed in [Running Patcher64+ Tool with Wine+PowerShell](#running-patcher64+-tool-with-wine+powershell) doesn't work, we need to re-enable the debugging options for Wine by removing the `WINEDEBUG=-all` portion of the command:
    
    `wine "/home/user/.wine/drive_c/Program Files (x86)/PowerShell/pwsh.exe" "/home/user/.wine/drive_c/Program Files (x86)/Patcher64+ Tool/Patcher64+ Tool.ps1"`

    After doing this, the terminal should now output a much more detailed information on what's going on when trying to run PowerShell. The output might be a bit overwhelming, but from the bunch of text being printed out, the error for launching the application will most likely appear within the very first dozen or so lines after the command runs. We might be looking for something like this to find the error:
    
	```
    Unhandled exception. System.IO.FileNotFoundException: Could not load file or assembly 'Z:\home\user\.wine\drive_c\Program Files (x86)\PowerShell\System.Runtime.dll'. Module not found.
    File name: 'Z:\home\user\.wine\drive_c\Program Files (x86)\PowerShell\System.Runtime.dll'
    wine: Unhandled exception 0xe0434352 in thread 24 at address 7B0129D6 (thread 0024), starting debugger...
	```

    In this example, Wine isn't recognizing the DLL file called "System.Runtime.dll" from within the PowerShell folder, but it other instances it can be a DLL file called "mscoree.dll".

    If this occurs on your end, you need to do the following:

    1. Redownload PowerShell with the instructions on the [Download PowerShell (x86)](#download-powershell-x86) section and make sure to overwrite the entirety of the files in the existing folder.

    1. Check which version of .NET has been installed on your system  with `winetricks uninstaller`. You should see "Microsoft .NET Framework 4.5.2" in the list of installed applications, if not, install .NET 4.5.2 by running `winetricks dotnet452` from terminal.

    1. If you have done the previous 2 steps and are still getting the error of the DLL file, you have to uninstall .NET 4.5.2 by using `winetricks uninstaller`, and then make sure to delete ANYTHING related to .NET from within the .wine folder. This includes the following folders that you'd need to remove (don't forget to rename the "user" in these paths to your username):
    ```
    /home/user/.wine/drive_c/ProgramData/NetFramework/
    /home/user/.wine/drive_c/Program Files (x86)/Microsoft.NET/
    /home/user/.wine/drive_c/windows/Microsoft.NET/
    ```
    After deleting these folders and making sure .NET 4.5.2 is NOT installed, attempt to run Patcher64 once again (it might work without .NET, happened once during testing). If it still doesn't launch, reinstall .NET 4.5.2 with `winetricks dotnet452`.
    
    Now try to run Patcher64 again after this, and it should fix the issue.

-----------------
