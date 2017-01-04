<#
    .Synopsis
        Installs .Net 4.6

#>

Enum Ensure {
    Present
    Absent
}

[DscResource()]
Class DotNet46 {

    [DSCProperty()]
    [ValidateSet ('Child','Full') ]
    [String]$Type = 'Full'

    [DSCProperty(Key)]
    [String]$Version

    [DSCProperty()]
    [Parameter (Mandatory = $True)]
    [String]$SourcePath

    [DSCProperty()]
    [String]$LogFile = "net461install.log"

    [DSCProperty()]
    [Parameter (Mandatory = $True)]
    [PSCredential]$Credential

    [DOTNet46]Get() {
        # ----- http://stackoverflow.com/questions/3487265/powershell-script-to-return-versions-of-net-framework-on-a-machine
        $Net = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse  | Get-ItemProperty -name Version,Release -EA 0 |  Where { $_.PSChildName -match '^(?!S)\p{L}' -and $_.Release -ne $Null } | Select PSChildName, Version, Release, @{
            name="Product"
            expression={
                switch($_.Release) {
                378389 { [Version]"4.5" }
                378675 { [Version]"4.5.1" }
                378758 { [Version]"4.5.1" }
                379893 { [Version]"4.5.2" }
                393295 { [Version]"4.6" }
                393297 { [Version]"4.6" }
                394254 { [Version]"4.6.1" }
                394271 { [Version]"4.6.1" }
                }
            }
        }

        $This.Version = $Net.Version
        $This.Type = $Net.PSChildName

        Write-Verbose "This is what is installed $($This | Out-String)"

        Return $This
    }

    [Bool]Test() {
        # ----- http://stackoverflow.com/questions/3487265/powershell-script-to-return-versions-of-net-framework-on-a-machine
        $Net = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse  | Get-ItemProperty -name Version,Release -EA 0 |  Where { $_.PSChildName -match '^(?!S)\p{L}' -and $_.Release -ne $Null } | Select PSChildName, Version, Release, @{
            name="Product"
            expression={
                switch($_.Release) {
                378389 { [Version]"4.5" }
                378675 { [Version]"4.5.1" }
                378758 { [Version]"4.5.1" }
                379893 { [Version]"4.5.2" }
                393295 { [Version]"4.6" }
                393297 { [Version]"4.6" }
                394254 { [Version]"4.6.1" }
                394271 { [Version]"4.6.1" }
                }
            }
        }

        if ( $Net.Version -ge $This.Version ) {
                Write-Verbose "DotNET is installed at the correct version or higher"
                $NetInstalled = $True
            }
            Else {
                Write-Verbose "DotNET is not installed or is a lesser version"
                $NetInstalled = $False
        }

        if ( $This.Ensure -eq [Ensure]::Present ) {
                Write-Verbose "And it needs to be."
                Return $NetInstalled
            }
            Else {
                Write-Verbose "And it does not need to be."
                Return -Not $NetInstalled
        }
    }

    [Void]Set() {
        Write-Verbose "Installing .Net"
        
        # ----- Check prereqs
        Write-Verbose "Checking if prerequisite hotfixes are installed"
        if ( ( -Not ( Get-Hotfix -ID KB2919442 -Erroraction SilentlyContinue ) )-or  ( -Not ( Get-Hotfix -ID KB2919355 -Erroraction SilentlyContinue ) ) ) {
            Throw "Error : .Net requires hotfixes KB2919442 and KB2919355 be installed."
        }

        # ----- Install
        Start-Process -FilePath $($This.SourcePath)\NDP461-KB3102436-x86-x64-AllOS-ENU.exe -ArgumentList "/q /Log $($This.LogFile)" -Wait -Credential $This.Credential -ErrorAction Stop   
                    
    }
}