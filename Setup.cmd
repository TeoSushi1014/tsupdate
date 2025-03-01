@echo off
chcp 65001 > nul
title TSToolkit Update Checker Setup
color 0A

echo ===================================================
echo      TSToolkit Update Checker Setup
echo ===================================================
echo.
echo This tool will help you set up the automatic
echo update check feature every time Command Prompt (CMD) is opened.
echo.
echo Options:
echo [1] Enable update check feature
echo [2] Disable update check feature
echo [3] Check for updates now
echo [4] Exit
echo.

:MENU
set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" goto ENABLE
if "%choice%"=="2" goto DISABLE
if "%choice%"=="3" goto CHECK
if "%choice%"=="4" goto EXIT

echo Invalid choice. Please try again.
goto MENU

:ENABLE
echo.
echo Enabling update check feature...
regedit /s "%~dp0enable_update_check.reg"
echo Update check feature enabled successfully!
echo Every time CMD is opened, the system will automatically check for updates.
echo.
pause
goto EXIT

:DISABLE
echo.
echo Disabling update check feature...
regedit /s "%~dp0disable_update_check.reg"
echo Update check feature disabled successfully!
echo.
pause
goto EXIT

:CHECK
echo.
call "%~dp0CheckUpdate.cmd"
echo.
pause
goto EXIT

:EXIT
echo.
echo Thank you for using TSToolkit!
timeout /t 3 > nul 