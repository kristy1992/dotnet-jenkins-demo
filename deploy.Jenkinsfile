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
   
  	
		stage('Provision Resources') {	
			steps {
				script{
					credentialId = getCredentialId()
				}
				retry(2){
					
						bat "CALL powershell.exe  -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -Command \"CICD\\deployment-azure.ps1\" -ResourceGroupName $ResourceGroup -ResourceGroupLocation $ResourceGroupLocation -AzureUserName \"kristy@nagarro.com\" -AzurePassword \"Wel@#$come@234\""
				}
			}	
		}				
 }
 

}

 String getCredentialId(){
 return 'myazure_credentials'
 }

