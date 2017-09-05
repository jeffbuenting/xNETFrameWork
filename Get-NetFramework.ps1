Function Get-NetFramework {

    <#
        .Synopsis
            Gets the version of .Net Framework Installed.

        .Description
            Returns the version or versions of .NET on a computer.

        .Parameter ComputerName
            Name of the computer to check.

        .Link
            .Net 4.0

            https://stackoverflow.com/questions/3487265/powershell-script-to-return-versions-of-net-framework-on-a-machine
    #>

    [CmdletBindig()]
    Param (
        [Parameter (ValueFromPipeline = $true)]
        [String[]]$ComputerName = $env:COMPUTERNAME
    )
        
    Process {
        Foreach ( $C in $ComputerName ) {
            Write-Verbose "Processing $C"

            # ----- version 2.0

            # ----- Version 3.0

            # ----- Version 4.0 and above
            if ( Test-Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' ) {

                $Net = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse  | Get-ItemProperty -name Version,Release -EA 0 |  Where { $_.PSChildName -match '^(?!S)\p{L}' -and $_.Release -ne $Null } | Select PSChildName, Version, Release, @{
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

        Write-Output $Net.Product
    }
}