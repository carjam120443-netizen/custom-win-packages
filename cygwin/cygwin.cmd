@echo off
setlocal
set "CYGWIN_ROOT=D:\CygwinPortable"
if not exist "%CYGWIN_ROOT%\bin\mintty.exe" (
  echo Cygwin was not found at "%CYGWIN_ROOT%".
  exit /b 2
)
start "Cygwin Terminal" "%CYGWIN_ROOT%\bin\mintty.exe" -i /Cygwin-Terminal.ico -
