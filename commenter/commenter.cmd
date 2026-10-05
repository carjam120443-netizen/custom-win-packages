@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0commenter.ps1" %*
