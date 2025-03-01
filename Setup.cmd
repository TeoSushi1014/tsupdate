@echo off
chcp 65001 > nul
title Cài đặt TSToolkit Update Checker
color 0A

echo ===================================================
echo      Cài đặt TSToolkit Update Checker
echo ===================================================
echo.
echo Công cụ này sẽ giúp bạn thiết lập tính năng tự động
echo kiểm tra cập nhật mỗi khi mở Command Prompt (CMD).
echo.
echo Lựa chọn:
echo [1] Bật tính năng kiểm tra cập nhật
echo [2] Tắt tính năng kiểm tra cập nhật
echo [3] Kiểm tra cập nhật ngay
echo [4] Thoát
echo.

:MENU
set /p choice="Nhập lựa chọn của bạn (1-4): "

if "%choice%"=="1" goto ENABLE
if "%choice%"=="2" goto DISABLE
if "%choice%"=="3" goto CHECK
if "%choice%"=="4" goto EXIT

echo Lựa chọn không hợp lệ. Vui lòng thử lại.
goto MENU

:ENABLE
echo.
echo Đang bật tính năng kiểm tra cập nhật...
regedit /s "%~dp0enable_update_check.reg"
echo Đã bật tính năng kiểm tra cập nhật thành công!
echo Mỗi khi mở CMD, hệ thống sẽ tự động kiểm tra cập nhật.
echo.
pause
goto EXIT

:DISABLE
echo.
echo Đang tắt tính năng kiểm tra cập nhật...
regedit /s "%~dp0disable_update_check.reg"
echo Đã tắt tính năng kiểm tra cập nhật thành công!
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
echo Cảm ơn bạn đã sử dụng TSToolkit!
timeout /t 3 > nul 