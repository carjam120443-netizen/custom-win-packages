@echo off
set "CYGWIN_ROOT=D:\CygwinPortable"
if not exist "%CYGWIN_ROOT%\bin\bash.exe" (
  echo Cygwin was not found at "%CYGWIN_ROOT%".
  exit /b 2
)
"%CYGWIN_ROOT%\bin\bash.exe" --login -i %*
