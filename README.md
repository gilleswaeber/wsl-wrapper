WSL Wrapper
===========
It is a simple wrapper around the Linux subsystem for Windows available in Windows 10.
It allows to call WSL executables as if they were native Windows applications. This avoid playing with `bash -ic`.

It also contains two useful commands for converting paths: `path2wsl` and `wsl2path`.

Requirements
============
This version require the Windows 10 Creators Update and a functionnal [WSL](https://msdn.microsoft.com/commandline/wsl/about).

How to use
==========
**Note:** Usage changed since the previous version.

Put *wsl.bat* in a folder and add the folder to your PATH.

### WSL Wrapper
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

### Path conversion commands
There are two proposed linux commands for converting paths:
- `path2wsl`: Convert a Windows path to its WSL counterpart
- `wsl2path`: Convert a WSL path to its Windows counterpart

Usage: `wsl2path <path>` or `path2wsl <path>`.
These commands also accept input through STDIN, one path per line.
Note that as of the Creators Update, your Windows PATH is automatically added to your linux path. You don't need then to move these commands to linux to use them.

#### Examples
- `wsl2path '/mnt/c/Users/Admin/Desktop'` gives `C:\Users\Admin\Desktop`
- `path2wsl 'D:\Data\file.txt'` gives `/mnt/d/Data/file.txt`

You can also use them from within Windows:
- `wsl path2wsl "%SystemRoot%"` gives something like `/mnt/c/WINDOWS`
- ``ls `path2wsl "%USERPROFILE%"` `` will list contents of your home folder (assuming *ls.bat* in PATH)