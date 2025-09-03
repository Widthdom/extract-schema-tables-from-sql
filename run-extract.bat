@echo off
chcp 65001 >nul
setlocal

set "OUTFILE=extracted-schema-tables.txt"

cd /d "%~dp0"

powershell -NoProfile -ExecutionPolicy Bypass -File ".\extract-schema-table.ps1" -OutFile "%OUTFILE%"

if %ERRORLEVEL% EQU 0 (
  echo -----------------------------------------
  echo Done. Wrote unique schema.table list to %OUTFILE%
  echo -----------------------------------------
) else (
  echo Something went wrong. Exit code: %ERRORLEVEL%
)

endlocal
pause