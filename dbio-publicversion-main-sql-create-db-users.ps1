$administratorLoginPassword = ConvertTo-SecureString -String ${Env:administratorLoginPassword} -AsPlainText -Force
$adminCredential = New-Object System.Management.Automation.PSCredential (${Env:administratorLogin}, $administratorLoginPassword)

$dbUserLogin = ${Env:dbUserLogin}
$dbUserLoginPassword = ConvertTo-SecureString -String ${Env:dbUserLoginPassword} -AsPlainText -Force

Write-Output 'Hello from the ARM Template deployment'
Write-Output $administratorLogin
Write-Output $administratorLoginPassword
Write-Output $administratorLogin
Write-Output $administratorLoginPassword
Write-Output $dbUserLogin
Write-Output $dbUserLoginPassword
Write-Output ${Env:sqlInstance}

Install-Module dbatools -force

New-DbaLogin -SqlInstance ${Env:sqlInstance} `
-SqlCredential $adminCredential `
-Login $dbUserLogin `
-SecurePassword $dbUserLoginPassword `
-Force
 
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



