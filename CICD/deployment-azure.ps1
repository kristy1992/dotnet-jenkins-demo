Param(
	[string] $ResourceGroupLocation = $ResourceGroupLocation,
    [string] [Parameter(Mandatory=$true)] $ResourceGroupName,
	[string] [Parameter(Mandatory=$true)] $AzureUserName,
	[string] [Parameter(Mandatory=$true)] $AzurePassword,
    [string] $StorageContainerName = $ResourceGroupName.ToLowerInvariant() + '-stageartifacts',
    [string] $TemplateFile = '..\Templates\resources.json'
)

$TemplateFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, $TemplateFile))

# Login with provided credentials
$password = ConvertTo-SecureString $AzurePassword -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential($AzureUserName, $password) -ErrorAction Stop
Login-AzureRmAccount -Credential $psCred -ErrorAction Stop

# Check whether resourceGroup exist and if not then create one
$resourceGroup = Get-AzureRmResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
if(!$resourceGroup)
{
	New-AzureRmResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation -Verbose -Force -ErrorAction Stop
}

New-AzureRmResourceGroupDeployment -Name ('Web-APP-Demo-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
									-ResourceGroupName $ResourceGroupName `
									-TemplateFile $TemplateFile `
									-TemplateParameterFile $TemplateParametersFile `
									-Force -Verbose -ErrorAction Stop