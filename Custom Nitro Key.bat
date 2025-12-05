@echo off
title Custom Nitro Key

REM Admin Check (needed for the registry command so it can run the program once the computer starts)

openfiles >nul 2>nul
if errorlevel 1 (
color 04
cls
    echo You need to open this as Administrator
    echo -------------------- > "%temp%\Howtorunasadmin.txt"
    echo How to open as admin >> "%temp%\Howtorunasadmin.txt"
    echo -------------------- >> "%temp%\Howtorunasadmin.txt"
    echo. >> "%temp%\Howtorunasadmin.txt"
    echo 1. Select the installer and right click on it >> "%temp%\Howtorunasadmin.txt"
    echo 2. Select 'Run as Administrator' >> "%temp%\Howtorunasadmin.txt"
    echo 3. Click 'Yes' >> "%temp%\Howtorunasadmin.txt"
    notepad "%temp%\Howtorunasadmin.txt"
    del /f /q "%temp%\Howtorunasadmin.txt"
    exit
)

REM Main Installation menu

:main
del /f /q "%temp%\Howtorunasadmin.txt"
color 02
cls
echo Custom Nitro Key Installer
echo.
echo Press 1 To Install
echo Press 2 To Delete
echo.

set /p num="Option: "

if "%num%"=="1" (
    goto install
)

if "%num%"=="2" (
    goto delete
)

REM Error Handling

goto error

:error
cls
color 04
echo Incorrect option...
timeout /nobreak /t 2 > nul
goto main

REM Delte Function

:delete
taskkill /f /im wscript.exe /t
taskkill /f /im timeout.exe /t
del /f /q %localappdata%\NoShellNitroKey.vbs
del /f /q %localappdata%\NitroKey.bat
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "NoShellNitroKey" /f
cls
echo Deleted^!
echo.
pause
goto main


REM Install function

:install
echo.
set /p cus="Path to .exe you want to run when you press the Nitro key (Only path, no quotes): "
::vbs
set "startupPath=%localappdata%\NoShellNitroKey.vbs"
echo Set WshShell = CreateObject("WScript.Shell") > "%startupPath%"
echo WshShell.Run WshShell.ExpandEnvironmentStrings("%%USERPROFILE%%\AppData\Local\NitroKey.bat"), 0, False >> "%startupPath%"

::batch
set "batPath=%localappdata%\NitroKey.bat"

echo set TARGET^_PROCESS=NitroSense.exe > "%batPath%"
echo set CUSTOM^_BINARY=%cus% >> "%batPath%"

echo ^:mainloop >> "%batPath%"
echo tasklist ^/FI "IMAGENAME eq %%TARGET_PROCESS%%" ^| find /I "%%TARGET_PROCESS%%" ^>nul >> "%batPath%"
echo if %%errorlevel%%==0 ^( >> "%batPath%"
echo     taskkill /F /IM %%TARGET_PROCESS%% >> "%batPath%"
echo     start "" "%%CUSTOM_BINARY%%" >> "%batPath%"
echo ^) >> "%batPath%"

echo timeout /nobreak /t 1 ^>nul >> "%batPath%"

echo goto mainloop >> "%batPath%"

REM Run on startup

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "NoShellNitroKey" /t REG_SZ /d "wscript %localappdata%\NoShellNitroKey.vbs" /f

REM Start Script

wscript "%localappdata%\NoShellNitroKey.vbs"
cls
echo Installed^!
echo.
pause
goto main