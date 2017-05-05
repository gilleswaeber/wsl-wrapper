WSL Wrapper
===========
It is a simple wrapper around the Linux subsystem for Windows available in Windows 10.
It allows to call WSL executables as if they were native Windows applications. This avoid playing with `bash -c`.

Requirements
============
This version require the Windows 10 Creators Update and a functionnal [WSL](https://msdn.microsoft.com/commandline/wsl/about).

How to use
==========
**Note:** Usage changed since the previous version.

Put *wsl.bat* in a folder and add the folder to your PATH.

### Batch file
Usage: `wsl <command>`, e.g. `wsl git status`

### Command wrapper
Create a batch file with the following content and name it as the desired command, e.g. *ls.bat*. Place it in the same folder as *wsl.bat*.
``` batch
@call "%~dp0wsl.bat" %~n0 %*
```
You can then call it simply with `ls` from anywhere in your system. You can also add parameters, e.g. `ls --color -al`.

If you already installed MinGW, Cygwin, Git for Windows or another utility providing linux tools, you can check which version of the command is executed with the `where` command, e.g. `where ls`.
#### Snippet explanation
`@` suppresses command output.
`%~dp0` is the script folder including drive letter.
`%~n0` is the script filename without extension.
`%*` are all script arguments.