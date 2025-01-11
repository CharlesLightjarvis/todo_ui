pipeline {
    agent any
    tools {
        nodejs 'NodeJS'
    }
    environment {
        DOCKER_TAG = getVersion()
    }
    stages {
        stage('Clone Repository') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/lightjarvis/todo-ui.git',
                        credentialsId: 'github-token' // Remplacez par l'ID de vos credentials GitHub
                    ]]
                ])
            }
        }
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        stage('Build Angular Project') {
            steps {
                sh 'npm run build'
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t lightjarvis/todo-ui:${DOCKER_TAG} .'
            }
        }
        stage('Docker Push') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub-password', variable: 'DockerHubPassword')]) {
                    sh '''
                    echo $DockerHubPassword | docker login -u lightjarvis --password-stdin
                    docker push lightjarvis/todo-ui:${DOCKER_TAG}
                    '''
                }
            }
        }
        stage('Deploy to Recipe VM') {
            steps {
                sshagent(['recipe-ssh-key']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no vm2@192.168.1.60 "docker pull lightjarvis/todo-ui:${DOCKER_TAG}"
                    ssh -o StrictHostKeyChecking=no vm2@192.168.1.60 "docker stop todo-ui || true && docker rm todo-ui || true"
                    ssh -o StrictHostKeyChecking=no vm2@192.168.1.60 "docker run -d --name todo-ui -p 8080:80 lightjarvis/todo-ui:${DOCKER_TAG}"
                    '''
                }
            }
        }
    }
}

def getVersion() {
    return sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
}
