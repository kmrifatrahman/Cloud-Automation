# $resourceGroupName = Read-Host -Prompt "Enter the Resource Group name"
# $location = Read-Host -Prompt "Enter the location (i.e. centralus)"
# $adminUsername = Read-Host -Prompt "Enter the administrator username"
# $adminPassword = Read-Host -Prompt "Enter the administrator password" -AsSecureString
# $vmName = Read-Host -Prompt "Enter the Virtual Machine name"
# $dnsLabelPrefix=-join ( (97..122) | Get-Random -Count 12 | % {[char]$_})
# $virtualNetworkName = "${vmName}VNet"
# $networkSecurityGroupName = "${vmName}SG"
# $subnetName = "${vmName}sbnet"
# you should remove anything above  connect-azaccount part as i kept them for refarance. you might need to make some modification according to your client requirenent 
#In Windows PowerShell, check that you have AzureRM installed:

 

Get-InstalledModule -name AzureRM

 

#use command Uninstall-AzureRM to remove it.

 

#If above command doesn't work use below one

 

Get-Module -ListAvailable | Where-Object {$_.Name -like 'AzureRM*'} | Uninstall-Module

 

#Set executionPolicy to RemoteSigned for powershell

 

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

 

#Install the Az PowerShell Module in Windows PowerShell

 

Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force

 

Connect-AzAccount

 

## Create a resource group

 

<#
A resource group is a logical container where you can deploy and manage Azure Stack Hub resources. From your development kit or the Azure Stack Hub integrated system, run the following code block to create a resource group. Though we've assigned values for all the variables in this article, you can use these values or assign new ones.
#>

 

# Edit your variables, if required

 

# Create variables to store the location and resource group names
$location = Read-Host -Prompt "Enter the Location Where the Resource Group will Launch (i.e. centralus)"
$ResourceGroupName = Read-Host -Prompt "Enter the Resource Group name"

 

# Create variables to store the storage account name and the storage account SKU information
$StorageAccountName = Read-Host -Prompt "Enter the Storage Aaccount name"
$SkuName = "Standard_LRS"

 

# Create variables to store the network security group and rules names
$nsgName = Read-Host -Prompt "Enter the NSG name"
$nsgRuleSSHName = Read-Host -Prompt "Enter the Name for SSH Rule"
$nsgRuleWebName = Read-Host -Prompt "Enter the Name for Web Rule"

 

# Create variable for VM password
$VMPassword = Read-Host -Prompt "Enter the Password for the VM"

 

# End of variables - no need to edit anything past that point to deploy a single VM

 

# Create a resource group
New-AzResourceGroup `
  -Name $ResourceGroupName `
  -Location $location

 

## Create storage resources

 

# Create a storage account, and then create a storage container for the Ubuntu Server 16.04 LTS image

 

# Create a new storage account
$StorageAccount = New-AzStorageAccount `
  -Location $location `
  -ResourceGroupName $ResourceGroupName `
  -Type $SkuName `
  -Name $StorageAccountName

 

Set-AzCurrentStorageAccount `
  -StorageAccountName $storageAccountName `
  -ResourceGroupName $resourceGroupName

 

# Create a storage container to store the VM image
$containerName = 'osdisks'
$container = New-AzureStorageContainer `
  -Name $containerName `
  -Permission Blob

 


## Create networking resources

 

# Create a virtual network, a subnet, and a public IP address, resources that are used provide network connectivity to the VM

 

# Create a subnet configuration
$subnetConfig = New-AzVirtualNetworkSubnetConfig `
  -Name mySubnet `
  -AddressPrefix 192.168.1.0/24

 

# Create a virtual network
$vnet = New-AzVirtualNetwork `
  -ResourceGroupName $ResourceGroupName `
  -Location $location `
  -Name MyVnet `
  -AddressPrefix 192.168.0.0/16 `
  -Subnet $subnetConfig

 

# Create a public IP address and specify a DNS name
$pip = New-AzPublicIpAddress `
  -ResourceGroupName $ResourceGroupName `
  -Location $location `
  -AllocationMethod Static `
  -IdleTimeoutInMinutes 4 `
  -Name "mypublicdns$(Get-Random)"

 


### Create a network security group and a network security group rule

 

<#
The network security group secures the VM by using inbound and outbound rules. Create an inbound rule for port 3389 to allow incoming Remote Desktop connections and an inbound rule for port 80 to allow incoming web traffic.
#>

 

# Create an inbound network security group rule for port 22
$nsgRuleSSH = New-AzNetworkSecurityRuleConfig -Name $nsgRuleSSHName -Protocol Tcp `
-Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
-DestinationPortRange 22 -Access Allow

 

# Create an inbound network security group rule for port 80
$nsgRuleWeb = New-AzNetworkSecurityRuleConfig -Name $nsgRuleWebName -Protocol Tcp `
-Direction Inbound -Priority 1001 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
-DestinationPortRange 80 -Access Allow

 

# Create a network security group
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName -Location $location `
-Name $nsgName -SecurityRules $nsgRuleSSH,$nsgRuleWeb

 

### Create a network card for the VM

 

# The network card connects the VM to a subnet, network security group, and public IP address.

 

# Create a virtual network card and associate it with public IP address and NSG
$nic = New-AzNetworkInterface `
  -Name myNic `
  -ResourceGroupName $ResourceGroupName `
  -Location $location `
  -SubnetId $vnet.Subnets[0].Id `
  -PublicIpAddressId $pip.Id `
  -NetworkSecurityGroupId $nsg.Id

 

## Create a VM
<#
Create a VM configuration. This configuration includes the settings used when deploying the VM. For example: user credentials, size, and the VM image.
#>

 

# Define a credential object
$UserName= Read-Host -Prompt "Enter the UserName of the VM"
$securePassword = ConvertTo-SecureString $VMPassword -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($UserName, $securePassword)

 

# Create the VM configuration object
$VmName = "VirtualMachinelatest"
$VmSize = Read-Host -Prompt "Enter the VM Size (i.e. Standard B2s)"
$VirtualMachine = New-AzVMConfig `
  -VMName $VmName `
  -VMSize $VmSize

 

$VirtualMachine = Set-AzVMOperatingSystem `
  -VM $VirtualMachine `
  -Linux `
  -ComputerName "MainComputer" `
  -Credential $cred

 

$VirtualMachine = Set-AzVMSourceImage `
  -VM $VirtualMachine `
  -PublisherName "Canonical" `
  -Offer "UbuntuServer" `
  -Skus "16.04-LTS" `
  -Version "latest"

 

$osDiskName = "OsDisk"
$osDiskUri = '{0}vhds/{1}-{2}.vhd' -f `
  $StorageAccount.PrimaryEndpoints.Blob.ToString(),`
  $vmName.ToLower(), `
  $osDiskName

 

# Set the operating system disk properties on a VM
$VirtualMachine = Set-AzVMOSDisk `
  -VM $VirtualMachine `
  -Name $osDiskName `
  -VhdUri $OsDiskUri `
  -CreateOption FromImage | `
  Add-AzVMNetworkInterface -Id $nic.Id

 

# Create the VM
New-AzVM `
  -ResourceGroupName $ResourceGroupName `
-Location $location `
  -VM $VirtualMachine