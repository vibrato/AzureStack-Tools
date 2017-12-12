Import-Module (Get-ChildItem -Path ..\ -Filter 'AzureRM.CloudCapabilities.psm1' -Recurse).FullName

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