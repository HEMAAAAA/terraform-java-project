pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws_access_key')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_key')
    }

    parameters {
        booleanParam(name: 'DESTROY_INFRA', defaultValue: false, description: 'Check to destroy infrastructure')
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/your-repo.git'
            }
        }

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
                sh 'terraform apply -auto-approve'
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
}

