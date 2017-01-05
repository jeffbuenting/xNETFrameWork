# xNETFrameWork

The xNETFrameWork module is a DSC Resource to install the .NET Framework

## Installation

To manually install the module, download the source code and unzip the contents of the 'xNETFrameWork' directory to the '$env:ProgramFiles\WindowsPowerShell\Modules folder'.

The **xBits** module contians the following resources:

- **xBitsTransfer**: Copies a file using Bits.

## Resources

###XbitsTransfer 
Most of this information can be found on the Start-BitsTransfer Site ( https://technet.microsoft.com/en-us/library/dd819420.aspx
   )
   
- **`[String]` Version** (_Key_):  .Net Version to install. 
- **`[String]` SourcePath** (_Required_):  Full path to the .Net installation file.
- **`[String]` LogFile** (_Write_) :  Log file full path.  Default = c:\temp\net461install.log
- **`[PSCredential]` Credential** (_Write_):  Credentials used to install .NET

## Versions

## Examples