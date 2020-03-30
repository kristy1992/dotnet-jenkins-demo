Param(
	[string] $ResourceGroupLocation = $ResourceGroupLocation,
    [string] [Parameter(Mandatory=$true)] $ResourceGroupName,
	[string] [Parameter(Mandatory=$true)] $AzureUserName,
	[string] [Parameter(Mandatory=$true)] $AzurePassword,
	[bool] $isNew = $IsNew,
    [string] $StorageContainerName = $ResourceGroupName.ToLowerInvariant() + '-stageartifacts',
    [string] $TemplateFile = '..\CICD\Template\resources.json',
	[string] $skuName = "Standard_GRS",
	[string] $storageAccountName = "demo27storageaccount",
	[string] $ArtifactStagingDirectory = "..\CICD\Deployment\Artifacts"
	)
	
$OptionalParameters = New-Object -TypeName Hashtable
Set-Variable IsDeploy 'isDeploy' -Option ReadOnly -Force
$OptionalParameters.Add($IsDeploy, !$isNew)

# Convert relative paths to absolute paths if needed
$TemplateFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $TemplateFile))
$ArtifactStagingDirectory = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $ArtifactStagingDirectory))

# Login with provided credentials
$password = ConvertTo-SecureString $AzurePassword -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential($AzureUserName, $password) -ErrorAction Stop
Login-AzureRmAccount -Credential $psCred -ErrorAction Stop

if ($ResourceGroupLocation -eq $null) {
	$ResourceGroupLocation = 'westus'
}
if ($ResourceGroupName -eq $null) {
	$ResourceGroupName = 'RG-QED-Dev'
}

# Check whether resourceGroup exist and if not then create one
$resourceGroup = Get-AzureRmResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
if(!$resourceGroup)
{
	New-AzureRmResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation -Verbose -Force -ErrorAction Stop
}

if($OptionalParameters[$IsDeploy] -eq $true)
{
	# Check whether storage account exists or not
	$storageAccount = Get-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $storageAccountName -ErrorAction SilentlyContinue
	#If not exists, then create a new storage account with sku as LRS
	if(!$storageAccount)
	{
	$storageAccount = New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName `
												-Name $storageAccountName `
												-SkuName $skuName `
												-Location $ResourceGroupLocation
												}
	#retrieve the context of the storage account created or existed one
	$storageAccountContext = (Get-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName | Where-Object{$_.StorageAccountName -eq $storageAccountName }).Context
	
	# create a storage container with permission as blob for public access of the files
	New-AzureStorageContainer -Name $StorageContainerName -Context $storageAccountContext -Permission blob -ErrorAction SilentlyContinue *>&1
	
	# upload a file
	$ArtifactFilePaths = Get-ChildItem $ArtifactStagingDirectory -Recurse -File | ForEach-Object -Process {$_.FullName}
	foreach ($SourcePath in $ArtifactFilePaths) {
		$BlobName = $SourcePath.Substring($ArtifactStagingDirectory.length + 1)
		Set-AzureStorageBlobContent -File $SourcePath -Blob $BlobName -Container $StorageContainerName -Context $storageAccountContext -Force
	}
}


New-AzureRmResourceGroupDeployment -Name ('Web-APP-Demo-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
									-ResourceGroupName $ResourceGroupName `
									-TemplateFile $TemplateFile `
									@OptionalParameters `
									-Force -Verbose -ErrorAction Stop

									
									
									