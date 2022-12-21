#Install-Module -Name Az.Resources -AllowClobber -Scope CurrentUser ##Add resourcegroup module
#Install-Module -Name Azure ##Adding Azure module to import azure library
#Install-Module -Name Az.Compute
#Add-AzureAccount ###Add your account to the console
#Connect-AZAccount -TenantID 9f9c6683-51dd-4fd8-af0d-81fdfff50250

#New-AzResourceGroupDeployment -Templateuri "C:\Users\Rifat\Desktop\new\ARM_Template.json"

#Get-AzAccessToken

### This whole script should be compiled with Azure Automation account before running "Powershell Script to execute ARM Template.ps1"###
param (
    [parameter(Mandatory=$True)][string] $resourceGroupName,
    [parameter(Mandatory=$True)][string] $location,
    [parameter(Mandatory=$True)][string] $adminUsername,
    [parameter(Mandatory=$True)][string] $adminPassword,
    [parameter(Mandatory=$True)][string] $vmName,
    [parameter(Mandatory=$True)][string] $dnsLabelPrefix,
    [parameter(Mandatory=$True)][string] $virtualNetworkName,
    [parameter(Mandatory=$True)][string] $networkSecurityGroupName,
    [parameter(Mandatory=$True)][string] $subnetName,
    [parameter(Mandatory=$True)][string] $RegistrationUrlvalue,
    [parameter(Mandatory=$True)][string] $NodeConfigurationNamevalue,
    [parameter(Mandatory=$True)][string] $registrationKeyPrivatevalue,
    [parameter(Mandatory=$True)][string] $willdscrun
      )
$adminPassword2 = $adminPassword | ConvertTo-SecureString -AsPlainText -Force

if($willdscrun -eq 'No')
{
New-AzResourceGroup -Name $resourceGroupName -Location "$location" -Force
New-AzResourceGroupDeployment `
    -ResourceGroupName $resourceGroupName `
    -TemplateFile 'ARM_No_DSC.json' `
    -adminUsername $adminUsername `
    -adminPassword $adminPassword2 `
    -dnsLabelPrefix $dnsLabelPrefix `
    -vmName $vmName `
    -virtualNetworkName $virtualNetworkName `
    -networkSecurityGroupName $networkSecurityGroupName `
    -subnetName $subnetName `
    -RegistrationUrlvalue $RegistrationUrlvalue `
    -NodeConfigurationNamevalue $NodeConfigurationNamevalue `
    -registrationKeyPrivatevalue $registrationKeyPrivatevalue -Force
}
else {


New-AzResourceGroup -Name $resourceGroupName -Location "$location" -Force
New-AzResourceGroupDeployment `
    -ResourceGroupName $resourceGroupName `
    -TemplateFile 'ARM_Template.json' `
    -adminUsername $adminUsername `
    -adminPassword $adminPassword2 `
    -dnsLabelPrefix $dnsLabelPrefix `
    -vmName $vmName `
    -virtualNetworkName $virtualNetworkName `
    -networkSecurityGroupName $networkSecurityGroupName `
    -subnetName $subnetName `
    -RegistrationUrlvalue $RegistrationUrlvalue `
    -NodeConfigurationNamevalue $NodeConfigurationNamevalue `
    -registrationKeyPrivatevalue $registrationKeyPrivatevalue -Force
}
    


 