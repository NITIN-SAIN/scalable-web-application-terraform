pipeline {

    agent any

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                checkout scm
            }
        }

        stage('Terraform Version') {
            steps {
                sh 'terraform --version'
            }
        }

        stage('Terraform Init') {
            steps {
                echo 'Initializing Terraform with S3 remote backend...'
                sh 'terraform init -input=false'
            }
        }

        stage('Terraform State Check') {
            steps {
                echo 'Checking Terraform remote state...'
                sh 'terraform state list'
            }
        }

        stage('Terraform Validate') {
            steps {
                echo 'Validating Terraform configuration...'
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                echo 'Creating Terraform execution plan...'
                sh 'terraform plan -input=false -out=tfplan'
            }
        }

        stage('Approval') {
            steps {
                input message: 'Review Terraform plan. Continue with deployment?',
                      ok: 'Deploy'
            }
        }

        stage('Terraform Apply') {
            steps {
                echo 'Applying approved Terraform plan...'
                sh 'terraform apply -input=false -auto-approve tfplan'
            }
        }

        stage('Terraform Outputs') {
            steps {
                echo 'Terraform outputs:'
                sh 'terraform output'
            }
        }
    }

    post {

        success {
            echo 'Deployment completed successfully.'
        }

        failure {
            echo 'Deployment failed. Check the Jenkins console output.'
        }

        always {
            echo 'Jenkins pipeline finished.'
        }
    }
}