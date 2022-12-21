param (
    [parameter(Mandatory=$True)][string] $GroupName,
    [parameter(Mandatory=$True)][string] $UserName

      )


 ###For Addeing the Created User to a specific Group###


Add-ADGroupMember `
-Identity $GroupName `
-Members $UserName

##New-ADGroup "Nidaan"