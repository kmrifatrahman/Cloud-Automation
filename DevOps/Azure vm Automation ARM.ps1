Install-Module -Name Az.Resources -AllowClobber -Scope CurrentUser ##Add resourcegroup module
Install-Module -Name Azure ##Adding Azure module to import azure library
Install-Module -Name Az.Compute
Add-AzureAccount ###Add your account to the console
Connect-AZAccount -TenantID 9f9c6683-51dd-4fd8-af0d-81fdfff50250

New-AzResourceGroupDeployment -Templateuri "C:\Users\Rifat\Desktop\ARM_No_DSC.json"

Get-AzAccessToken