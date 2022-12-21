using namespace System.Net



# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)



# Write to the Azure Functions log stream.
$body=""
$result=''
$resultfinal



# Interact with query parameters or the body of the request.
$username = 'rifat'
$pwd = 'Kmrrhulu007k'
$url = 'http://10.0.0.4/'
$req = [system.Net.WebRequest]::Create($url)
#$req.Credentials = New-Object System.Net.NetworkCredential($username, $pwd, $domain);
$req.Credentials = New-Object System.Net.NetworkCredential($username, $pwd);
try {



   $res = $req.GetResponse()
    $result = [int]$res.StatusCode   
}
catch [System.Net.WebException] {



   $body = $_.Exception
}
if($body -eq "")
{
if($result == 200)
    {
        $resultfinal = [HttpStatusCode]::OK
    }
    
    else
    {
        $resultfinal = [HttpStatusCode]::BadRequest
    }
}
else
{
     $resultfinal = [HttpStatusCode]::BadRequest
}



# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $resultfinal
    Body = $body
})