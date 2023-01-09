using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
$body=""
$result=''
$resultok=''

# Interact with query parameters or the body of the request.
$username = 'rifat'
$pswd = 'Kmrrhulu007k'
$url = 'http://10.0.0.4/'
$req = [system.Net.WebRequest]::Create($url)

#$req.Credentials = New-Object System.Net.NetworkCredential($username, $pwd, $domain);
$req.Credentials = New-Object System.Net.NetworkCredential($username, $pswd);

try {

    $res = $req.GetResponse()
    $result = [int]$res.StatusCode
    $resultok =$res.StatusCode
}
catch [System.Net.WebException] {

    $body = $_.Exception
}
if($body -eq "")
{
    
    $body = "Status Code: $result $resultok"
}
else
{
 $body = "Can't process the request. It seems that server is down or not accessible."   
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})