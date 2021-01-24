Import-Module dbachecks

$SqlInstances = 'mssql1','mssql2','mssql3'

$SecurityChecks = 'XpCmdShellDisabled','GuestUserConnect','SaDisabled','OrphanedUser'
$PerfChecks = 'AutoClose','AutoShrink','VirtualLogFile'
$MaintChecks = 'LastFullBackup','LastGoodCheckDb','OlaInstalled'

$dbatoolsDest = @{
    SqlInstance = 'mssql1'
    Database    = 'DatabaseAdmin'
}

Set-dbcconfig -Name skip.security.sadisabled -Value $False
Set-dbcconfig -Name skip.security.guestuserconnect -Value $False

# Security - 50
Invoke-DbcCheck -SqlInstance $SqlInstances -Check $SecurityChecks -PassThru |
Convert-DbcResult -Label 'FitnessTest-Security' |
Write-DbcTable @dbatoolsDest

# Performance - 14
Invoke-DbcCheck -SqlInstance $SqlInstances -Check $PerfChecks -PassThru |
Convert-DbcResult -Label 'FitnessTest-Performance' |
Write-DbcTable @dbatoolsDest

# Maintenance - 17
Invoke-DbcCheck -SqlInstance $SqlInstances -Check $MaintChecks -PassThru |
Convert-DbcResult -Label 'FitnessTest-Maintenance' |
Write-DbcTable @dbatoolsDest

Start-DbcPowerBi -FromDatabase

## go update the database

# 33