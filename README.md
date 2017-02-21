WSL Wrapper
===========
It is a simple wrapper around the Linux subsystem for Windows available in Windows 10.
It allows to pipe wsl commands or redirect them to a file. If the commands output color escaped codes, they are also transmitted. It also transmits the last error status of the command.

Requirements
============
[WSL](https://msdn.microsoft.com/commandline/wsl/about) must be installed and configured.

The *bsdutil* package must be installed within wsl (for the *script* command). This can be done with
`sudo apt install bsdutils`.

If you want to call wsl.ps1 directly, you may want to [enable powershell scripts execution](https://technet.microsoft.com/en-us/library/ee176961.aspx) but this is not required. You can bypass it with the *-ExecutionPolicy Bypass* flag of powershell. The bat file will apply this flag if you use it.

How to use
==========
### Batch file
Usage: `wsl <command>`, e.g. `wsl "git status"`

### Powershell file
Usage: `powershell -file wsl.ps1 <command>`, e.g. `powershell -file wsl.ps1 "git status"`

### Command wrapper
Create a batch file with the following content and name it as the desired command, e.g. *ls.bat*. Place it in the same folder as *wsl.bat* and *wsl.ps1*.
``` batch
@"%~dp0wsl.bat" "%~n0 %*"
```
You can then call it simply with `ls` (assuming you are in the same folder or you added it to your path). You can also add parameters, e.g. `ls --color -al`.

`@` suppresses command output. `%~dp0` is the script folder including drive letter. `%~n0` is the script filename without extension. `%*` are all script arguments.

Notes
=====
3 files are created in the working folder during script execution and then destroyed. 
They are named `.script.<random id>.sh`, `.log.<random id>.txt` and `.status.<random id>.txt`. If the script fails, they can be deleted without further consequences.

Contributions are welcome.