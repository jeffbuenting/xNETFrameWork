Function Get-NetFramework {

    <#
        .Synopsis
            Gets the version of .Net Framework Installed.

        .Description
            Returns the version or versions of .NET on a computer.

        .Parameter ComputerName
            Name of the computer to check.

        .Example
            Retrieves a list of .NET Framework versions that are installed.

            Get-NetFramework

        .Link
            https://stackoverflow.com/questions/3487265/powershell-script-to-return-versions-of-net-framework-on-a-machine

        .Link
            https://blogs.msdn.microsoft.com/astebner/2005/07/12/what-net-framework-version-numbers-go-with-what-service-pack/

        .Notes
            Author : Jeff Buenting
            Date : 2017 SEP 06
    #>

    [CmdletBinding()]
    Param (
        [Parameter (ValueFromPipeline = $true)]
        [String[]]$ComputerName = $env:COMPUTERNAME
    )
      
    Process {
        Foreach ( $C in $ComputerName ) {
            Write-Verbose "Processing $C"

            $Key = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' 
            Foreach ( $K in $Key ) {
                

                Switch ($K.PSChildName) {
                    'v2.0.50727' {
                        Write-Verbose ".Net 2.0 Found"
                        $Net = 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v2.0.50727' | Get-ItemProperty -name Version | Select PSChildName, Version, Release, SP, @{name="Product";expression={ $_.Version.substring(0,3) } }
                    }

                    'v3.0' {
                        Write-Verbose ".Net 3.0 Found"

                        $Net = 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.0' | Get-ItemProperty -name Version | Select PSChildName, Version, Release, SP, @{name="Product";expression={ $_.Version.substring(0,3) } }
                    }

                    'v3.5' {
                        Write-Verbose ".Net 3.5 Found"

                        $Net = 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5' | Get-ItemProperty -name Version | Select PSChildName, Version, Release, SP, @{name="Product";expression={ $_.Version.substring(0,3) } }
                    }

                    'v4' {
                        Write-Verbose ".Net 4 found"
                   
                        $Net = 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full' | Get-ItemProperty -name Version,Release -EA 0 |  Where { $_.PSChildName -match '^(?!S)\p{L}' -and $_.Release -ne $Null } | Select PSChildName, Version, Release,SP, @{
                            name="Product"
                            expression={
                                switch -regex ($_.Release) {
                                    "378389" { [Version]"4.5" }
                                    "378675|378758" { [Version]"4.5.1" }
                                    "379893" { [Version]"4.5.2" }
                                    "393295|393297" { [Version]"4.6" }
                                    "394254|394271" { [Version]"4.6.1" }
                                    "394802|394806" { [Version]"4.6.2" }
                                    "460798" { [Version]"4.7" }
                                    {$_ -gt 460798} { [Version]"Undocumented 4.7 or higher, please update script" }
                                }
                            }
                        }
                    }
                }
            
                Write-Output $Net
            }
        }
    }
}

