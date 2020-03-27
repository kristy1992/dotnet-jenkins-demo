pipeline {
agent any
 
options {
    skipDefaultCheckout()
}
parameters{
		choice(name:'ResourceGroup',
			  choices:['RG-QED-Dev'],
			  description:'ResourceGroup Name')
		string(name: 'ResourceGroupLocation', defaultValue: 'westus', description:'ResourceGroup Location')  
	}
	

stages {
stage ('Checkout') {
        steps{
            checkout(scm)
            stash includes: '**', name: 'source', useDefaultExcludes: false
        }
    }	
		
		//Download and unzip the Artifacts
		stage('Prepare Artifacts'){
			steps{
				copyArtifacts ([fingerprintArtifacts: true, projectName: 'jenkins-pipeline-session', selector: upstream(), target:'CICD'])
				unzip([
					dir: 'CICD\\Deployment',
					glob: '',
					zipFile: getZipFileName()
				])
			}
		}

		stage('Provision Resources') {	
			steps {
				script{
					credentialId = getCredentialId()
				}
				retry(2){
					withCredentials([usernamePassword(credentialsId: credentialId, passwordVariable: 'AZURE_PASSWORD', usernameVariable: 'AZURE_USERNAME')]) {
						bat "CALL powershell.exe  -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -Command \"CICD\\deployment-azure.ps1\" -ResourceGroupName $ResourceGroup -ResourceGroupLocation $ResourceGroupLocation -AzureUserName $AZURE_USERNAME -AzurePassword $AZURE_PASSWORD -isNew \$false"
					} 
				}
			}	
		}		
 }
 

}

 String getCredentialId(){
 return 'myazure_credentials'
 }
 
 String getZipFileName(){
	return "demo-app-package.zip"
}

