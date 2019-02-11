WSL Wrapper
===========
It is a simple wrapper around the Linux subsystem for Windows available in Windows 10.
It allows to call WSL executables as if they were native Windows applications. This avoid playing with `bash -ic`.

It also contains two useful commands for converting paths: `path2wsl` and `wsl2path`.

Fall Creator Update (2017/10) or later
======================================
The `wsl` command, as proposed here, is now part of the OS. See https://docs.microsoft.com/windows/wsl/wsl-config.

You can create a command wrapper by creating a *.bat* file named after a linux command (e.g. `ls`, note that `ls` is aliased to a native function in Powershell) with the following contents (see tokens explanation below):
```batch
@wsl %~n0 %*
```

Tips
====
In Powershell, the escape character is the backtick `` ` `` (grave accent). Strings can be enclosed in quotes `'`, double quotes `"`, or using the pairs `@' ... '@` and `@" ... "@`. Arrays are declared with `@(1, 2, 3)`.

If pipes are not escaped, the result is piped to powershell. To use the pipe with a linux command, either escape the pipe `` `|``, or quote it `'|'`.

Avoid doing `wsl command | wsl command` as this is very likely to cause encoding issues, a BOM will get inserted unless the default Powershell settings have changed and `\n` will be converted to `\r\n`.

Similarly, use `` `>`` and `` `>`>`` to write to files unless you want to end up with UTF-16 encoded files.

### Translate paths
Those Powershell function can translate paths to/from wsl.
```powershell
# Convert path to wsl
function ConvertTo-WSLPath($path) {
	if ($path -cmatch "^(?<drive>[A-Z]):\\(?<rest>.*)$") {
		$path = '/mnt/' + ($Matches.drive.ToLower()) + '/' + $Matches.rest
	}
	$path = $path.Replace('\', '/')
	return $path
}

# Convert path from wsl
function ConvertFrom-WSLPath($path) {
	if ($path -cmatch "^/mnt/(?<drive>[a-z])/(?<rest>.*)$") {
		$path = ($Matches.drive.ToUpper()) + ':\' + $Matches.rest
	}
	$path = $path.Replace('/', '\')
	return $path
}
```

### Automatic path conversion
These functions allow to invoke WSL with the paths contained in the arguments being converted:
```powershell
# Convert paths in args and run command in wsl
#   param is an array of arguments
# Example: Invoke-WithWSL "ls" @("-al", "|", "grep", 42)
function Invoke-WithWSL($command, $param) {
	$param = $param | ForEach-Object { ConvertTo-WSLPath "$_" }
	& wsl $command $param
}

# Shortcuts
# Example: wslp ls -al -w 12 `| grep 42
function wslp ($command) {Invoke-WithWSL $command $args}
# Example: vim $profile
function vim {Invoke-WithWSL vim $args}
```

### Encoding
If using Powershell ≤ 6, it is possible to force the encoding to be UTF-8:
```powershell
# Set I/O encoding to UTF-8 without BOM
# https://github.com/PowerShell/PowerShell/issues/4681
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

# Default encoding for >/>> and all commands with an Encoding setting (sadly with BOM)
# https://stackoverflow.com/a/40098904
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
```

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