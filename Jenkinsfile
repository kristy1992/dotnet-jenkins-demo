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
			echo "${workspace}"
      }
   }
stage('Publish Artifacts') {
steps {
            deleteDir()
            unstash 'source'
			echo "Creating Artifact"
			script{
					zipFileName =  getZipFileName()
					workspace = getWorkspace(pwd())
				}
				
				dir('src\\dotnet-jenkins-demo'){
				script{
				bat '"C:\\Program Files\\dotnet\\dotnet.exe" publish --configuration Release --output  \"bin\\Release\\dotnet.jenkins.demo\" --no-restore'
				}
				}
				
				zip([ 
					dir: 'src\\dotnet-jenkins-demo\\bin\\Release\\dotnet.jenkins.demo', 
					glob: '', 
					zipFile: 'CICD\\Deployment\\Artifacts\\dotnet.jenkins.demo.zip'
				])
				echo "Artifact created"
				
				echo "Publishing Artifact"
				
				zip([
					archive: true, 
					dir: 'CICD\\Deployment', 
					glob: '', 
					zipFile: zipFileName
				])
				
				echo "Artifact published successfully"
   }   
   }
 }
}

String getWorkspace(String workspace){
	return workspace.replace("/","\\")
}

String getZipFileName(){
	return "demo-app-package.zip"
}

