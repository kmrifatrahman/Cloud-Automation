Install-Module -Name Az.Compute -Scope CurrentUser
Install-Module -Name Az -Scope CurrentUser


$resourceGroupName = 'rft' 
#$location = 'southasia' 
$vmName = 'Dev'
$snapshotName = 'testPipeline'
$location = 'southeastasia' 
#param (
#    [parameter(Mandatory=$True)][string] $resourceGroupName = "rft",
#    [parameter(Mandatory=$True)][string] $location = "southeastasia",
#   [parameter(Mandatory=$True)][string] $vmName ="Dev",
#   [parameter(Mandatory=$True)][string] $snapshotName = "testPipeline"
#
#      )

$vm = Get-AzVM `
    -ResourceGroupName $resourceGroupName `
    -Name $vmName
$snapshot =  New-AzSnapshotConfig `
    -SourceUri $vm.StorageProfile.OsDisk.ManagedDisk.Id `
    -Location $location `
    -CreateOption copy
New-AzSnapshot `
    -Snapshot $snapshot `
    -SnapshotName $snapshotName `
    -ResourceGroupName $resourceGroupName
Get-AzSnapshot `
    -ResourceGroupName $resourceGroupName
