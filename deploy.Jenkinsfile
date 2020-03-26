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
		string(name: 'AzureUserName', defaultValue: 'kristy@nagarro.com', description:'Azure Username')  
		string(name: 'AzurePassword', defaultValue: 'Wel@#$come@234', description:'Azure Password')  
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
					
						bat "CALL powershell.exe  -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -Command \"CICD\\deployment-azure.ps1\" -ResourceGroupName $ResourceGroup -ResourceGroupLocation $ResourceGroupLocation -AzureUserName $AzureUserName -AzurePassword $AzurePassword"
				}
			}	
		}				
 }
 

}

 String getCredentialId(){
 return 'myazure_credentials'
 }

