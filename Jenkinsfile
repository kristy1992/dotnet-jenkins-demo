pipeline {
agent any
 
options {
    skipDefaultCheckout()
}
parameters{
		choice(name:'ResourceGroup',
			  choices:['RG-QED-Dev'],
			  description:'ResourceGroup Name')
		string(name: 'ResourceGroupLocation', defaultValue: 'eastus', description:'ResourceGroup Location')  
	}
	

stages {
stage ('Checkout') {
        steps{
            checkout(scm)
            stash includes: '**', name: 'source', useDefaultExcludes: false
        }
    }
stage ('Restore Packages') {     
         steps {
             deleteDir()
             unstash 'source'
             script {
                 bat '"C:\\Program Files\\dotnet\\dotnet.exe" restore "src\\dotnet-jenkins-demo.sln" '
             }             
          }
        }

stage('Build') {
     steps {
            deleteDir()
            unstash 'source'
            dir('src\\dotnet-jenkins-demo'){
                script{
                    bat '"C:\\Program Files\\dotnet\\dotnet.exe" publish -c release -o /app --no-restore' 
                }
            }
      }
   }
   
  	
		stage('Provision Resources') {	
			steps {
				script{
					credentialId = getCredentialId()
				}
				retry(2){
					withCredentials([usernamePassword(credentialsId: credentialId, passwordVariable: 'AZURE_PASSWORD', usernameVariable: 'AZURE_USERNAME')]) {
						bat "CALL powershell.exe -Command \"CICD\\deployment-azure.ps1\" -ResourceGroupName $ResourceGroup -ResourceGroupLocation $ResourceGroupLocation -AzureUserName $AZURE_USERNAME -AzurePassword $AZURE_PASSWORD"
					} 
				}
			}	
		}				
 }
}

