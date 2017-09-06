$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-NetFramework" {
   
    # ----- Get Function Help
    # ----- Pester to test Comment based help
    # ----- http://www.lazywinadmin.com/2016/05/using-pester-to-test-your-comment-based.html

    Context "Help" {
        $H = Help Get-NetFramework -Full
        
        # ----- Help Tests
        It "has Synopsis Help Section" {
            $H.Synopsis | Should Not BeNullorEmpty
        }

        It "has Description Help Section" {
            $H.Description | Should Not BeNullorEmpty
        }

        It "has Parameters Help Section" {
            $H.Parameters | Should Not BeNullorEmpty
        }

        # Examples
        it "Example - Count should be greater than 0"{
            $H.examples.example.code.count | Should BeGreaterthan 0
        }

        # Examples - Remarks (small description that comes with the example)
        foreach ($Example in $H.examples.example)
        {
            it "Example - Remarks on $($Example.Title)"{
                $Example.remarks | Should not BeNullOrEmpty
            }
        }

        It "has Notes Help Section" {
            $H.alertSet | Should Not BeNullorEmpty
        }
    } 

    Context Output {
        
        
        
        It "Should return a custom object" {

            Mock -CommandName Get-ChildItem -MockWith {
                $OBJ = New-Object -TypeName psobject -Property (
                    @{
                        'PSChildName' = 'v2.0.50727'
                    }
                )
            
                Return $OBJ
            }

            Mock -CommandName Get-ItemProperty -MockWith {
                $OBJ = New-Object -TypeName psobject -Property (@{
                    'Version'= '2.0.50727.4927'
                    'PSPath'= 'Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v2.0.50727'
                    'PSParentPath' = 'Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP'
                    'PSChildName' = 'v2.0.50727'
                    'PSDrive' = 'HKLM'
                    'PSProvider' = 'Microsoft.PowerShell.Core\Registry'
                })

                Return $OBJ
            }
            
            Get-NetFramework | Should beoftype 'PSObject'                       
        }

        It "Should return  2.0 .net Product number object" {

            Mock -CommandName Get-ChildItem -MockWith {
                $OBJ = New-Object -TypeName psobject -Property (
                    @{
                        'PSChildName' = 'v2.0.50727'
                    }
                )
            
                Return $OBJ
            }

            Mock -CommandName Get-ItemProperty -MockWith {
                $OBJ = New-Object -TypeName psobject -Property (@{
                    'Version'= '2.0.50727.4927'
                    'PSPath'= 'Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v2.0.50727'
                    'PSParentPath' = 'Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP'
                    'PSChildName' = 'v2.0.50727'
                    'PSDrive' = 'HKLM'
                    'PSProvider' = 'Microsoft.PowerShell.Core\Registry'
                })

                Return $OBJ
            }
            
            (Get-NetFramework).Product | Should be '2.0'                   
        }

        It "Should return  3.0 .net Product Number" {

            Mock -CommandName Get-ChildItem -MockWith {
                $OBJ = New-Object -TypeName psobject -Property (
                    @{
                        'PSChildName' = 'v3.0'
                    }
                )
            
                Return $OBJ
            }

            Mock -CommandName Get-ItemProperty -MockWith {
                $OBJ = New-Object -TypeName psobject -Property (@{
                    'Version'= '3.0.556'
                    'PSPath'= 'Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v2.0.50727'
                    'PSParentPath' = 'Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP'
                    'PSChildName' = 'v2.0.50727'
                    'PSDrive' = 'HKLM'
                    'PSProvider' = 'Microsoft.PowerShell.Core\Registry'
                })

                Return $OBJ
            }
            
            (Get-NetFramework).Product | Should be '3.0'                      
        }

         It "Should return  3.5 .net Product Number" {

            Mock -CommandName Get-ChildItem -MockWith {
                $OBJ = New-Object -TypeName psobject -Property (
                    @{
                        'PSChildName' = 'v3.5'
                    }
                )
            
                Return $OBJ
            }

            Mock -CommandName Get-ItemProperty -MockWith {
                $OBJ = New-Object -TypeName psobject -Property (@{
                    'Version'= '3.5.556'
                    'PSPath'= 'Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v2.0.50727'
                    'PSParentPath' = 'Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP'
                    'PSChildName' = 'v2.0.50727'
                    'PSDrive' = 'HKLM'
                    'PSProvider' = 'Microsoft.PowerShell.Core\Registry'
                })

                Return $OBJ
            }
            
            (Get-NetFramework).Product | Should be '3.5'                      
        }

         It "Should return  4.0 .net Product Number" {
            
            Mock -CommandName Get-ChildItem -MockWith {
                $OBJ = New-Object -TypeName psobject -Property (
                    @{
                        'PSChildName' = 'v4'
                    }
                )
            
                Return $OBJ
            }

            Mock -CommandName Get-ItemProperty -MockWith {
                $OBJ = New-Object -TypeName psobject -Property (@{
                    'Release' = '394802'
                    'PSPath' = ' Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full'
                    'PSParentPath' = 'Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4'
                    'PSChildName' = 'Full'
                    'PSDrive' = 'HKLM'
                    'PSProvider' = 'Microsoft.PowerShell.Core\Registry'
                })

                Return $OBJ
            }
            
            (Get-NetFramework -verbose).Product | Should be '4.6.2'                      
        }
    }
}
