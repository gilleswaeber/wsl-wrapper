@echo off
REM Wrapper for the Linux subsystem for Windows wsl.ps1
REM see wsl.ps1 for more informations
REM wsl.ps1 must be placed in the same folder
REM
REM Usage: wsl <command>
REM Example: wsl "git status"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0wsl.ps1" "%*"