Clear-Host
Write-Host "Starting setup script at $(Get-Date)"
$ErrorActionPreference = 'Stop'

#Installing required packages

[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
Register-PSRepository -Default -Verbose -ErrorAction 'SilentlyContinue'
#Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -ErrorAction 'SilentlyContinue'
#Install-Module -Name Az.Accounts
#Install-Module -Name Az.Sql -Force -Verbose:$false -WarningAction 'SilentlyContinue'
#Install-Module -Name Az.Storage -Force -Verbose:$false -WarningAction 'SilentlyContinue'
#Install-Module -Name Az.Resources -Force -Verbose:$false -WarningAction 'SilentlyContinue'

$resourceGroupName = (Get-AzResourceGroup | Where-Object { $_.ResourceGroupName -like "lab10-rg*" }).ResourceGroupName
$DeploymentID =  (Get-AzResourceGroup -Name $resourceGroupName).Tags["DeploymentId"]

$Location = Get-AzResourceGroup -Name $resourceGroupName | Select-Object -ExpandProperty location
$storageName = "dp500strg$DeploymentID"
$ServerName = "server$DeploymentID"
$FolderName = "C:\LabFiles\DP-500-Azure-Data-Analyst"

#(Get-Content -Path "C:\LabFiles\DP-500-Azure-Data-Analyst\Allfiles\10\parameters.json") | ForEach-Object {$_ -Replace "GET-DEPLOYMENT-ID", "$DeploymentID"} | Set-Content -Path "C:\LabFiles\DP-500-Azure-Data-Analyst\Allfiles\10\parameters.json"

#Create storage accountadmin

$StorageHT = @{  
     ResourceGroupName = $resourceGroupName
     Name              = $storageName 
     SkuName           = 'Standard_LRS'  
     Location          = $Location
     AllowBlobPublicAccess = $True
}
$StorageAccount = New-AzStorageAccount @StorageHT

Start-Sleep -s 120

#Upload .bacpac file to storage account

$SA = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageName
$Context = $SA.Context
$ContainerName = 'dp500'
New-AzStorageContainer -Name $ContainerName -Context $Context -Permission Blob  

Start-Sleep -s 5

$Blob1HT = @{  
    File             = "$($FolderName)\Allfiles\00-Setup\DatabaseBackup\AdventureWorksDW2022-DP500.bacpac"          
    Container        = $ContainerName  
    Blob             = "AdventureWorksDW2022-DP500.bacpac"  
    Context          = $Context  
    StandardBlobTier = 'Hot'
}

Set-AzStorageBlobContent @Blob1HT 

#Create SQL Database server

$SQLPassword = ConvertTo-SecureString -String 'P@ssw0rd01' -AsPlainText -Force
$SQLCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'sqladmin',$SQLPassword 

New-AzSqlServer -ServerName $ServerName -ResourceGroupName $resourceGroupName -Location $Location -SqlAdministratorCredentials $SQLCredential
Start-Sleep -s 5

New-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName -ServerName $ServerName -AllowAllAzureIPs
Start-Sleep -s 5

#Import .bacpac file

New-AzSqlDatabaseImport -ResourceGroupName $resourceGroupName -ServerName $ServerName -DatabaseName "AdventureWorksDW2022-DP500" -DatabaseMaxSizeBytes 5368709120  -StorageKeyType "StorageAccessKey" -StorageKey $(Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -StorageAccountName $storageName).Value[0] -StorageUri "https://$($storageName).blob.core.windows.net/dp500/AdventureWorksDW2022-DP500.bacpac" -Edition "Standard" -ServiceObjectiveName "S2" -AdministratorLogin "sqladmin" -AdministratorLoginPassword $(ConvertTo-SecureString -String 'P@ssw0rd01' -AsPlainText -Force)

Start-Sleep -s 5

Write-Host "Finishing setup script at $(Get-Date)"
