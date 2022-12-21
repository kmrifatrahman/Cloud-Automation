param(
    [parameter(Mandatory=$True)][string] $ResourceGroupName,
    [parameter(Mandatory=$True)][string] $poolIP,
    [parameter(Mandatory=$True)][string] $vnetName,
    [parameter(Mandatory=$True)][string] $subipName,
    [parameter(Mandatory=$True)][string] $pubipName
)

$temp = "testGW.bicep"        #mention the path for the file

New-AzResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -TemplateFile $temp `
    -poolIP $poolIP `
    -vnetName $vnetName `
    -subipName $subipName `
    -pubipName $pubipName
