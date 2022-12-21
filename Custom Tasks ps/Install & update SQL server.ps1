#Install-Module SQLServer -Scope CurrentUser ##(Installing only for current user)

Install-Module -Name SqlServer

Get-Module SqlServer -ListAvailable ##To view version and available modules of SQL Servers

##Install-Module -Name SqlServer -AllowClobber ###this will overwrite the previous version of SQL modules

Update-Module -Name SqlServer -AllowClobber ##to update into new version

#Uninstall-Module -Name SqlServer ##To remove


Install-Module -Name "dbatools"

Add-SqlLogin -ServerInstance "MyServerInstance" -LoginName "rifat" -LoginType "SqlLogin" -DefaultDatabase "testDB"

Get-Service | Where-Object -Property Name -match 'MSSQL*' 

(Get-Module SqlServer).Version