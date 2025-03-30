pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws_access_key')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_key')
	TF_PUBLIC_KEY 	      = credentials('terraform-pub')
    }

    parameters {
        booleanParam(name: 'DESTROY_INFRA', defaultValue: false, description: 'Check to destroy infrastructure')
    }

    stages {
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            when {
                expression { return !params.DESTROY_INFRA }
            }
            steps {

            sh '''
                terraform apply -var="public_key=${TF_PUBLIC_KEY}" -auto-approve
            '''

            }
        }

        stage('Terraform Output') {
            when {
                expression { return !params.DESTROY_INFRA }
            }
            steps {
                script {
                    def output = sh(script: 'terraform output -json', returnStdout: true).trim()
                    writeFile file: 'terraform_output.json', text: output
                    echo "Terraform Output Saved: terraform_output.json"
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { return params.DESTROY_INFRA }
            }
            steps {
                sh 'terraform destroy -auto-approve'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'terraform_output.json', onlyIfSuccessful: true
        }
    }
}

