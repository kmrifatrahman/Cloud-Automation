#Install-Module Az.Network

param (
    [parameter(Mandatory=$True)][string] $resourceGroupName, #Name of the resource group where the snapshot is located#
    [parameter(Mandatory=$True)][string] $snapshotName, #Name of the snapshot from where the VM will be restored/lunched#
    [parameter(Mandatory=$True)][string] $destinationResourceGroup, #Name of the resource group where the VM will be deployed#
    [parameter(Mandatory=$True)][string] $location, #Name of the location (ex: central us) where the vm will be deployed#
    [parameter(Mandatory=$True)][string] $vmName #Name of the new VM#
      )

###Getting the snapshot details.###
$snapShot = Get-AzSnapshot `
            -ResourceGroupName $resourceGroupName `
            -SnapshotName $snapshotName 
            
####Creating a new disk from the snapshot###
###create a new resource group for the new Windows VM.###
New-AzResourceGroup -Location $location `
        -Name $destinationResourceGroup

###Creating the managed disk.###
$osDisk = New-AzDisk -DiskName "${vmName}.osdisk" -Disk `
(New-AzDiskConfig -Location $location -CreateOption Copy -SourceResourceId $snapshot.Id) `
-ResourceGroupName $destinationResourceGroup

###Creating the new VM###
###Creating the subnet and virtual network###
$singleSubnet = New-AzVirtualNetworkSubnetConfig `
                -Name "${vmName}.subnet" `
                -AddressPrefix 10.0.0.0/24

$vnet = New-AzVirtualNetwork `
            -Name "${vmName}.vnet" -ResourceGroupName $destinationResourceGroup `
            -Location $location `
            -AddressPrefix 10.0.0.0/16 `
            -Subnet $singleSubnet

###Creating the network security group and an RDP rule###

$rdpRule = New-AzNetworkSecurityRuleConfig -Name myRdpRule -Description "Allow RDP" `
            -Access Allow -Protocol Tcp -Direction Inbound -Priority 110 `
            -SourceAddressPrefix Internet -SourcePortRange * `
            -DestinationAddressPrefix * -DestinationPortRange 3389 

$nsg = New-AzNetworkSecurityGroup `
            -ResourceGroupName $destinationResourceGroup `
            -Location $location `
            -Name "${vmName}.nsg" `
            -SecurityRules $rdpRule

###Create a public IP address and NIC###
$pip = New-AzPublicIpAddress `
            -Name "${vmName}.ip" -ResourceGroupName $destinationResourceGroup `
            -Location $location `
            -AllocationMethod Dynamic

            $nic = New-AzNetworkInterface -Name "${vmName}.nic" `
                    -ResourceGroupName $destinationResourceGroup `
                    -Location $location `
                    -SubnetId $vnet.Subnets[0].Id `
                    -PublicIpAddressId $pip.Id `
                    -NetworkSecurityGroupId $nsg.Id

###Setting the VM name and size###
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize "Standard_B2s"
$vm = Add-AzVMNetworkInterface -VM $vmConfig -Id $nic.Id
$vm = Set-AzVMOSDisk -VM $vm -ManagedDiskId $osDisk.Id -StorageAccountType Standard_LRS `
            -DiskSizeInGB 128 -CreateOption Attach -Windows


New-AzVM -ResourceGroupName $destinationResourceGroup -Location $location -VM $vm