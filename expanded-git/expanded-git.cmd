@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0expanded-git.ps1" %*
exit /b %ERRORLEVEL%
