# Wrapper for the Linux subsystem for Windows
# Allow to pipe wsl commands, including color codes if handled
# Will create 3 temporary files in the working directory
# Will create a minimized window during the script execution
#
# Usage: powershell -file wsl.ps1 <command>
# Example: powershell -file wsl.ps1 "git status"

$in = $args -join " "
$guid = [guid]::NewGuid()

# Script file
$file = "#!/bin/bash`n"
$file+= $in
$file+= "`necho `$? > .status.$guid.txt`n"
$file | Out-File ".script.$guid.sh" -Encoding ascii -NoNewline

# Arguments for bash
$pargs = "'script -fqc ./.script.$guid.sh /dev/null |& tee .log.$guid.txt'"

$logrsize = 0
$logsize = 0

function Show-Log{
	Try{
		$logrsize = (Get-Item ".log.$guid.txt" -ErrorAction Stop).Length
		If($logrsize -gt $global:logrsize){
			$log = Get-Content ".log.$guid.txt" -Encoding UTF8 -Raw
			Write-Output $log.Substring($global:logsize);
			$global:logsize = $log.Length
			$global:logrsize = $logrsize
		}
	}
	Catch{}
}

$app = Start-Process -PassThru -WindowStyle Minimized $env:SystemRoot\System32\bash -ArgumentList '-ci', "$pargs"

# Fetch log
While(!$app.HasExited){
	Show-Log
	Start-Sleep -Milliseconds 100
}
Show-Log

$exitCode = -1;
if(Test-Path ".\.status.$guid.txt" -PathType Leaf){
	$exitCode = Get-Content ".\.status.$guid.txt";
}

Remove-Item ".\.log.$guid.txt" -ErrorAction Ignore
Remove-Item ".\.script.$guid.sh" -ErrorAction Ignore
Remove-Item ".\.status.$guid.txt" -ErrorAction Ignore
Exit $exitCode
