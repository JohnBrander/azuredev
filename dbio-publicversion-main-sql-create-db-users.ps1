$administratorLoginPassword = ConvertTo-SecureString -String ${Env:administratorLoginPassword} -AsPlainText -Force
$dbUserLoginPassword = ConvertTo-SecureString -String ${Env:dbUserLoginPassword} -AsPlainText -Force

$adminCredential = New-Object System.Management.Automation.PSCredential (${Env:administratorLogin}, $administratorLoginPassword)

$dbUserLogin = ${Env:dbUserLogin}

Write-Output 'Hello from the ARM Template deployment'

Write-Output ${Env:administratorLogin}
Write-Output ${Env:administratorLoginPassword}
Write-Output ${Env:dbUserLogin}
Write-Output ${Env:dbUserLoginPassword}
Write-Output ${Env:sqlInstance}

Write-Output $administratorLogin
Write-Output $administratorLoginPassword
Write-Output $dbUserLogin
Write-Output $dbUserLoginPassword

Write-Host "Encrypted dbPassword: $(ConvertFrom-SecureString $dbUserLoginPassword)"
$ClearText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($dbUserLoginPassword))
Write-Host "Original dbPassword: $ClearText"

Write-Host "Encrypted adminPassword: $(ConvertFrom-SecureString $administratorLoginPassword)"
$ClearText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($administratorLoginPassword))
Write-Host "Original adminPassword: $ClearText"

Install-Module dbatools -force

Get-DbaDbMemoryUsage -SqlInstance ${Env:sqlInstance} `
-SqlCredential $adminCredential `

    <#
New-DbaLogin -SqlInstance ${Env:sqlInstance} `
-SqlCredential $adminCredential `
-Login $dbUserLogin `
-SecurePassword $dbUserLoginPassword `
-Force #>
 
New-DbaDbUser -SqlInstance ${Env:sqlInstance} `
-Database acq `
-SqlCredential $adminCredential `
-Login $dbUserLogin `
-Force

Add-DbaDbRoleMember -SqlInstance ${Env:sqlInstance} `
-Database acq `
-SqlCredential $adminCredential `
-Role db_owner `
-User  $dbUserLogin `
-Confirm: $false  


