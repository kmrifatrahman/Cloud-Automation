#Install-Module -Name SqlServer
#Get-Module SqlServer -ListAvailable
#Install-Module -Name "dbatools"



#installing ssms

$InstallerSQL = $env:TEMP + “\SSMS-Setup-ENU.exe”; 
Invoke-WebRequest “https://aka.ms/ssmsfullsetup" -OutFile $InstallerSQL; 
start $InstallerSQL /Quiet



###Creating Database

$sql = "CREATE DATABASE [$NewDatabaseName] COLLATE SQL_Latin1_General_CP1_CI_AS;"
$cmd = New-Object Data.SqlClient.SqlCommand $sql, $con;
$cmd.ExecuteNonQuery();     
Write-Host "Database $NewDatabaseName is created!";