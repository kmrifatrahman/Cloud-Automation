#{#Install-Module -Name AZ
#Install-Module -Name Az.Compute
#Install-Module -Name Az.Resources} Install this module to poweshell before starting.

#Connect-AzAccount (Connect to your AZure portal)

Import-Module Az.Compute #Import required module

#$resourceGroupName = 'windrnd' 
#$location = 'centralus' 
#$vmName = 'winvm'
#$snapshotName = 'mySnapshot'

##########Take information to create snapshot##########
param (
    [parameter(Mandatory=$True)][string] $resourceGroupName, #Existing RG of the vm
    [parameter(Mandatory=$True)][string] $location,          #Region of the vm
    [parameter(Mandatory=$True)][string] $vmName,            #Name for the vm which will be copied
    [parameter(Mandatory=$True)][string] $snapshotName,      #Snapshot name
  
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
