@echo off
REM Usage: wsl <command>
REM Example: wsl git status
set wslcmd=%*
setlocal enabledelayedexpansion
echo.rm -- "$0";!wslcmd!>wsltemp.sh
"%~dp0bash" -ic 'sed -i "s/[\r]//g" wsltemp.sh; ./wsltemp.sh'