$ie = New-Object -ComObject 'internetexplorer.application'
$ie.Visible= $true # Make it visible

$username = "rifat" # I used actual loginID

$password = "Kmrrhulu007k" #I used actual password

$ie.Navigate("http://10.0.0.4/") # I used actual website

While ($ie.Busy -eq $true) {Start-Sleep -Seconds 3;}

$ie.document.getElementByID("j_username").value = "$username"


$ie.document.getElementByID("j_password").value = "$password"


$Link = $ie.document.getElementByID('loginButton')
$Link.click()
