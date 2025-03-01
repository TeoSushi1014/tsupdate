@echo off
chcp 65001 > nul
echo Đang kiểm tra cập nhật cho TSToolkit...
powershell.exe -ExecutionPolicy Bypass -NoProfile -InputFormat None -Command "[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; & '%~dp0UpdateChecker.ps1'" 