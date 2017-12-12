$ModuleLocation = (Get-ChildItem -Path $ENV:AGENT_BUILDDIRECTORY -Filter 'AzureRM.CloudCapabilities.psm1' -Recurse).FullName
Write-Host "Importing module from: $ModuleLocation"
try {
    Import-Module $ModuleLocation -Force    
}
catch {
    Write-Error "Unable to import module from $ModuleLocation" -Exception $Error[-1]
}


$DateString = (Get-Date).ToString('yyyyddMMHHmmss')
$OutputPath = "Capabilities.$DateString.json"
$Location = (Get-AzureRmLocation)[0].Location

Get-AzureRMCloudCapability `
    -Location $Location `
    -OutputPath $OutputPath `
    -IncludeComputeCapabilities `
    -IncludeStorageCapabilities `
    -Verbose

Write-Host "##vso[task.setvariable variable=OutputPath]$OutputPath"