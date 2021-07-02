                
$userPassword = ConvertTo-SecureString -String ${Env:myPass} -AsPlainText -Force
$dbLoginPassword = ConvertTo-SecureString -String ${Env:myPass} -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential (${Env:dbUserName}, $userPassword)

Write-Output 'Hello from the ARM Template deployment'
Write-Output ${Env:myPass}
Write-Output ${Env:dbUserName}
Write-Output ${Env:sqlInstance}

Install-Module dbatools -force

New-DbaLogin -SqlInstance ${Env:sqlInstance} `
-SqlCredential $Credential `
-Login $dbUserName `
-SecurePassword $dbLoginPassword `
-Force
 
New-DbaDbUser -SqlInstance ${Env:sqlInstance} `
-Database acq `
-SqlCredential $Credential `
-Login $dbUserName `
-Force

Add-DbaDbRoleMember -SqlInstance ${Env:sqlInstance} `
-Database acq `
-SqlCredential $Credential `
-Role db_owner `
-User  $dbUserName `
-Confirm: $false  



