@echo off
setlocal
cd /d "%~dp0"
if not exist ".venv\Scripts\python.exe" (
  echo Pirmiausia idiek projekta pagal README.md.
  pause
  exit /b 1
)
if not exist "settings.json" (
  echo Pirmiausia sukurk settings.json pagal README.md.
  pause
  exit /b 1
)
".venv\Scripts\python.exe" -m firem bot
if errorlevel 1 (
  pause
  exit /b 1
)
".venv\Scripts\python.exe" -m firem review-ui --open
if errorlevel 1 pause

