if(($Env:AGENT_BUILDDIRECTORY)-and(Test-Path -Path $Env:AGENT_BUILDDIRECTORY)){
    $ModuleLocation = (Get-ChildItem -Path $ENV:AGENT_BUILDDIRECTORY -Filter 'AzureRM.CloudCapabilities.psm1' -Recurse).FullName
}
else {
    $ModuleLocation = (Get-ChildItem -Path (Get-Item -Path $PSScriptRoot).Parent.FullName -Filter 'AzureRM.CloudCapabilities.psm1' -Recurse).FullName    
}

if (Test-Path $ModuleLocation -PathType Leaf){
    Write-Host "Importing module from: $ModuleLocation"
    Import-Module $ModuleLocation -Force    

    $DateString = (Get-Date).ToString('yyyyddMMHHmmss')
    $OutputPath = "Capabilities.$DateString.json"
    Write-Host "Output path is: $OutputPath"
    $Location = (Get-AzureRmLocation)[0].Location
    Write-Host "Using location: $Location"

    Get-AzureRMCloudCapability `
        -Location $Location `
        -OutputPath $OutputPath `
        -IncludeComputeCapabilities `
        -IncludeStorageCapabilities `
        -Verbose

    Write-Host "##vso[task.setvariable variable=OutputPath]$OutputPath"
}
else {
    Write-Error "Unable to find module in location: $ModuleLocation"
}