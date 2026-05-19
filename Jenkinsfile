pipeline {
    agent any

    environment {
        APP_REPO = 'https://github.com/bagoes01/Simplest-Spring-Boot-Hello-World.git'
        APP_BRANCH = 'master'
        IMAGE_NAME = 'spring-boot-hello:local'
        KUBE_CONTEXT = 'docker-desktop'
        K8S_NAMESPACE = 'cicd-demo'
    }

    stages {
        stage('checkout scm') {
            steps {
                checkout scm
            }
        }
        stage('checkout app') {
            steps {
                dir('app')
                    git branch: env.APP_BRANCH, url: env.APP_REPO
            }
        }
    }

    stage('build') {
        steps {
            dir('app') {
                sh 'mvn -B -DskipTests clean'
            }
        }
    }

    stage('build image') {
        steps {
            dir('app') {
                sh 'docker build -t "$IMAGE_NAME" .'
            }
        }
    }

    stage('deploy') {
        steps {
            sh "kubectl config use-context ${KUBE_CONTEXT}"
            sh "kubectl apply -f k8s/namespace.yaml"
            sh "kubectl apply -f k8s/deployment.yaml"
            sh "kubectl apply -f k8s/service.yaml"
            sh "kubectl -n K8S_NAMESPACE rollout status deployment/spring-boot-hello --timeput=300s"
        }
    }
    }
}