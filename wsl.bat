@echo off
REM Usage: wsl <command>
REM Example: wsl git status
set wslcmd=%*
setlocal enabledelayedexpansion
set wslcmd=!wslcmd:'='"'"'!
bash -c '!wslcmd!'