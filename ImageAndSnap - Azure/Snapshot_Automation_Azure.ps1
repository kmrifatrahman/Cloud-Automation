#Install-Module -Name Az.Compute
#$resourceGroupName = 'windrnd' 
#$location = 'centralus' 
#$vmName = 'winvm'
#$snapshotName = 'mySnapshot'

param (
    [parameter(Mandatory=$True)][string] $resourceGroupName,
    [parameter(Mandatory=$True)][string] $location,
    [parameter(Mandatory=$True)][string] $vmName,
    [parameter(Mandatory=$True)][string] $snapshotName

      )
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
