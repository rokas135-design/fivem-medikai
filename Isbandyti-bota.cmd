@echo off
setlocal
cd /d "%~dp0"
if not exist ".venv\Scripts\python.exe" (
  echo Pirmiausia idiek projekta pagal README.md.
  pause
  exit /b 1
)
".venv\Scripts\python.exe" -m firem --data demo-bot-data bot --demo
if errorlevel 1 (
  pause
  exit /b 1
)
".venv\Scripts\python.exe" -m firem --config examples/settings.json --data demo-bot-data review-ui --open
if errorlevel 1 pause

