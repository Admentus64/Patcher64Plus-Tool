@echo off
setlocal EnableDelayedExpansion

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' (
	goto:showMenu
) else (
	goto:getPrivileges
)

:getPrivileges
if [%1]==[ELEV] (shift & goto:showMenu)
setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
echo UAC.ShellExecute "!batchPath!", "ELEV", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%temp%\OEgetPrivileges.vbs"
exit /B

:showMenu
for /f %%A in ('powershell Get-ExecutionPolicy') do (set CurrentPolicy=%%A)
echo -------------------------------------------------------------------------------
echo PowerShell Execution Policy Changer
echo.
echo Current policy: %CurrentPolicy%
echo.
echo (1:) Unrestricted - All Windows PowerShell scripts can be ran.
echo (2:) RemoteSigned - Scripts must be signed by a trusted publisher to be ran.
echo (3:) AllSigned    - Only scripts by a trusted publisher can be ran.
echo (4:) Restricted   - Disable all scripts from being able to be ran.
echo (5:) Exit
echo.
set Entered=1
set /p Entered=^> 
echo.
if [%Entered%]==[1] (call:setPolicy Unrestricted)
if [%Entered%]==[2] (call:setPolicy RemoteSigned)
if [%Entered%]==[3] (call:setPolicy AllSigned)
if [%Entered%]==[4] (call:setPolicy Restricted)
goto:exit

:setPolicy
set InputValue=%~1
if [!CurrentPolicy!]==[!InputValue!] (
	echo PowerShell Execution Policy is already set to !InputValue!
) else (
	powershell Set-ExecutionPolicy !InputValue!
	for /f %%A in ('powershell Get-ExecutionPolicy') do (set CurrentPolicy=%%A)
	if [!CurrentPolicy!]==[!InputValue!] (
		echo PowerShell Execution Policy successfully changed to !InputValue!
	)
)
goto:eof

:exit
endlocal
echo.
echo Press any key to close this window.
pause >nul