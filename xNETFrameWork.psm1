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

    [DSCProperty(Key)]
    [String]$Version

    [DSCProperty(Mandatory)]
    [String]$SourcePath

    [DSCProperty()]
    [String]$LogFile = "c:\temp\net461install.log"

    [DSCProperty(Mandatory)]
    [PSCredential]$Credential

    [DSCProperty()]
    [Int]$SecondsToDelay = 300

    [DSCProperty()]
    [Ensure]$Ensure = 'Present'

    [DOTNet46]Get() {
        # ----- http://stackoverflow.com/questions/3487265/powershell-script-to-return-versions-of-net-framework-on-a-machine
        $Net = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse  | Get-ItemProperty -name Version,Release -EA 0 |  Where { $_.PSChildName -match '^(?!S)\p{L}' -and $_.Release -ne $Null } | Select PSChildName, Version, Release, @{
            name="Product"
            expression={
                switch($_.Release) 
                {
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

        # ----- We only care about the "Full" version not the "client" Version
        $Net = $Net | where PSChildName -eq Full

        # ----- Note: Product maps to the user friendly version.
        $This.Version = $Net.Product

        Write-Verbose "This is what is installed $($This | Out-String)"

        Return $This
    }

    [Bool]Test() 
    {
        # ----- http://stackoverflow.com/questions/3487265/powershell-script-to-return-versions-of-net-framework-on-a-machine
        $Net = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse  | Get-ItemProperty -name Version,Release -EA 0 |  Where { $_.PSChildName -match '^(?!S)\p{L}' -and $_.Release -ne $Null } | Select PSChildName, Version, Release, @{
            name="Product"
            expression={
                switch($_.Release) 
                {
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

        # ----- We only care about the "Full" version not the "client" Version
        $Net = $Net | where PSChildName -eq Full

        Write-Verbose ".Net Currently Installed : $($Net.Product)"
        Write-Verbose "Requested Version : $($This.Version)"

        if ( $Net.Product -ge $This.Version ) 
        {
            Write-Verbose "DotNET is installed at the correct version or higher"
            $NetInstalled = $True
        }
        Else {
            Write-Verbose "DotNET is not installed or is a lesser version"
            $NetInstalled = $False
        }

        if ( $This.Ensure -eq [Ensure]::Present ) 
        {
            Write-Verbose "So it needs to be installed / Updated."
            Return $NetInstalled
        }
        Else {
            Write-Verbose "And it does not need to be."
            Return -Not $NetInstalled
        }
    }

    # ----- Installs or Uninstalls .Net
    [Void]Set() 
    { 
        Write-Verbose "SourcePath : $($This.SourcePath)"
        Write-verbose "Log : $($This.LogFile)"

        # ----- Without this delay the installation of .NET is failing.
        Write-Verbose "Pausing $($This.SecondsToDelay)"
        For ( $I = 1; $I -le 100; $I++ ) {
            Write-Progress -Activity "Pausing prior to .NET install" -Status "$I% Complete" -PercentComplete $I
            Start-Sleep -Seconds ($This.SecondsToDelay / 100)
        }      

        if ( $This.Ensure -eq 'Present' ) 
        {
            Try 
            {
                Write-Verbose "Installing .Net" 
                Start-Process -FilePath $This.SourcePath -ArgumentList "/q /norestart /Log $($This.LogFile)" -Wait -Credential $This.Credential -ErrorAction Stop  
            }
            Catch
            {
                $EXceptionMessage = $_.Exception.Message
                $ExceptionType = $_.exception.GetType().fullname
                Throw "xNetFramework : Error Installing .Net`n`n     $ExceptionMessage`n`n     Exception : $ExceptionType"
            } 
        }
        else {
            Try 
            {
                Write-Verbose "Uninstalling .Net"
                Start-Process -FilePath $This.SourcePath -ArgumentList "/q /Uninstall /norestart /Log $($This.LogFile)" -Wait -Credential $This.Credential -ErrorAction Stop 
            }
            Catch
            {
                $EXceptionMessage = $_.Exception.Message
                $ExceptionType = $_.exception.GetType().fullname
                Throw "xNetFramework : Error Uninstalling .Net`n`n     $ExceptionMessage`n`n     Exception : $ExceptionType"
            } 
        }
    }
}