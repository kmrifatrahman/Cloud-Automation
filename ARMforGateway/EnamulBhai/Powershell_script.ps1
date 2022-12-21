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
    -TemplateFile 'ARM_No_DSC.bicep' `
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
    -TemplateFile 'ARM_Template.bicep' `
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
    


 