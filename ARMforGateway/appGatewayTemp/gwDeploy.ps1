<# Connect-AzAccount
Select-AzSubscription -Subscription 'a77d2c8a-b7ca-4493-8046-38f707c7cd6f'
Set-AzContext -Subscription 'a77d2c8a-b7ca-4493-8046-38f707c7cd6f'
Get-AzSubscription
#>
param (
    [parameter(Mandatory=$True)][string] $appgwName,
    [parameter(Mandatory=$True)][string] $resourceGroupName,
    [parameter(Mandatory=$True)][string] $vnetName,
    [parameter(Mandatory=$True)][string] $subIpname,
    [parameter(Mandatory=$True)][string] $pubIPname,
    [parameter(Mandatory=$True)][string] $gatewayIPConfigurations,
    [parameter(Mandatory=$True)][string] $backendAddressPools,
    [parameter(Mandatory=$True)][string] $httpListeners,
    [parameter(Mandatory=$True)][string] $frontendIPConfigurations,
    [parameter(Mandatory=$True)][string] $requestRoutingRules,
    [parameter(Mandatory=$True)][string] $backendHttpSettingsCollection,
    [parameter(Mandatory=$True)][string] $urlPathMap,
    [parameter(Mandatory=$True)][string] $pathRuleName


    )

$temp = "update3.json"        #mention the path for the file

#show if values are passing through
Write-Host "appgw Name: " $appgwName `
$resourceGroupName `
$vnetName `
$subIpname `
$pubIPname `
$gatewayIPConfigurations `
$urlPathMap `
$requestRoutingRules



New-AzResourceGroupDeployment `
    -ResourceGroupName $resourceGroupName `
    -resourceGroupNameFromTemplate $resourceGroupName `
    -TemplateFile $temp `
    -appgwName $appgwName `
    -vnetName $vnetName `
    -subIpname $subIpname `
    -pubIPname $pubIPname `
    -gatewayIPConfigurations $gatewayIPConfigurations `
    -backendAddressPools $backendAddressPools `
    -httpListeners $httpListeners `
    -frontendIPConfigurations $frontendIPConfigurations `
    -requestRoutingRules $requestRoutingRules `
    -backendHttpSettingsCollection $backendHttpSettingsCollection `
    -urlPathMap $urlPathMap `
    -pathRuleName $pathRuleName
