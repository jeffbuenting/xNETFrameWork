# xNETFrameWork

The xNETFrameWork module is a DSC Resource to install the .NET Framework

### Installation

To manually install the module, download the source code and unzip the contents of the 'xNETFrameWork' directory to the '$env:ProgramFiles\WindowsPowerShell\Modules folder'.

The **xNETFrameWork** module contians the following resources:

- **xDotNet46**: Installs .NET 4.6.1.

## Resources

###DotNet46
   )
   
- **`[String]` Version** (_Key_):  .Net Version to install. 
- **`[String]` SourcePath** (_Required_):  Full path to the .Net installation file.
- **`[String]` LogFile** (_Write_) :  Log file full path.  Default = c:\temp\net461install.log
- **`[PSCredential]` Credential** (_Write_):  Credentials used to install .NET

## Versions

### Examples

## NON DSC .Net Scripts

  - **Get-DotNetHotfixes**
    - Lists .Net Hotfixes that are installed on a computer.
	
	- **`[String[]]`ComputerName : Name of the computer to get the information from.
	