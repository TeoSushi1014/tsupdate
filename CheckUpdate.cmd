@echo off
chcp 65001 > nul
echo Checking for TSToolkit updates...
powershell.exe -ExecutionPolicy Bypass -NoProfile -InputFormat None -Command "[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; & '%~dp0UpdateChecker.ps1'" 