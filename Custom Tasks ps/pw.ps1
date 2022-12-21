#Randomize the charecters of password

$uc =  ("ABCDEFGHIJKLMNOPQRSTUVWXYZ".tochararray() | sort {Get-Random})
$lc = ("abcdefghijklmnopqrstuvwxyz".tochararray() | sort {Get-Random})
$Ch = ("!@#$%^*".ToCharArray()| sort {Get-Random})
$No = ("1234567890*".ToCharArray() | sort {Get-Random})


#Generate random password

$All = Get-Random -Count 10 -InputObject ($uc+$lc+$Ch+$No)
$pw = $All -join("")


#printing Random Password

$n = Read-Host ("Enter NAme: ")


#using random password for user

New-ADUser `
-Name $n `
-AccountPassword (ConvertTo-SecureString -AsPlainText $pw -Force) `
-Enabled $true 



Write-Host (
"User Name: "+$n+"
Password: "+$pw
)

Get-ADUser `
-Filter * `
-Properties samAccountName | select samAccountName