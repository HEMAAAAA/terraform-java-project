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

        stage('Terraform Apply') {
            when { 
                expression { !params.DESTROY_INFRA } 
            }
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }

        stage('Capture Outputs') {
            when { 
                allOf {
                    expression { !params.DESTROY_INFRA }
                    expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' } 
                }
            }
            steps {
                script {
                    sh 'mkdir -p tf_outputs'
                    def output = sh(script: 'terraform output -json 2>/dev/null || echo "{}"', returnStdout: true).trim()
                    writeFile file: 'tf_outputs/terraform.json', text: output
                }
            }
        }

        stage('Terraform Destroy') {
            when { 
                expression { params.DESTROY_INFRA } 
            }
            steps {
                sh 'terraform destroy -auto-approve'
            }
        }
    }

    post {
        success {
            script {
                if (!params.DESTROY_INFRA && fileExists('tf_outputs/terraform.json')) {
                    archiveArtifacts artifacts: 'tf_outputs/terraform.json'
                }
            }
        }
    }
}
