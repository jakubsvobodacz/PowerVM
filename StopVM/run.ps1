using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."


# Interact with query parameters or the body of the request.
Write-Output ($request | ConvertTo-Json -depth 99)

$ResourceGroupName = $request.query.ResourceGroupName
$VMName = $request.query.VMName
$Context =  $request.query.Context
$Action = $request.query.Action

$null = Connect-AzAccount -Identity
$null = Set-AzContext $Context

$vmStatus = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName -Status
Write-output $vmStatus


<#
$name = $Request.Query.Name
if (-not $name) {
    $name = $Request.Body.Name
}

$body = "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."

if ($name) {
    $body = "Hello, $name. This HTTP triggered function executed successfully."
}
#>

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
