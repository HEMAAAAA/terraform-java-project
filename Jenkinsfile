pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws_access_key')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_key')
        TF_VAR_public_key     = credentials('terraform-pub')  
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

        stage('Terraform Apply/Destroy') {
            steps {
                script {
                    if (params.DESTROY_INFRA) {
                        sh 'terraform destroy -auto-approve'
                    } else {
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
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
        }  // ← **THIS WAS MISSING**
    }

    post {
        always {
            archiveArtifacts artifacts: 'terraform_output.json', onlyIfSuccessful: true
            cleanWs()
        }
    }
}
