@echo off
cd /d "%~dp0"
if exist FreeTurn_new.exe (
    taskkill /F /IM FreeTurn.exe >nul 2>&1
    move /Y FreeTurn_new.exe FreeTurn.exe >nul 2>&1
)
powershell -Command "Start-Process 'FreeTurn.exe' -Verb RunAs"
