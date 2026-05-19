pipeline {
    agent any

    environment {
        APP_REPO = 'https://github.com/bagoes01/Simplest-Spring-Boot-Hello-World.git'
        APP_BRANCH = 'master'
        IMAGE_NAME = 'spring-boot-hello:local'
        REGISTRY = 'bagusajah/spring-boot-hello:local'
        KUBE_CONTEXT = 'docker-desktop'
        K8S_NAMESPACE = 'cicd-demo'
    }

    stages {
        stage('Checkout scm') {
            steps {
                checkout scm
            }
        }
        stage('Checkout app') {
            steps {
                dir('app') {
                    git branch: env.APP_BRANCH, url: env.APP_REPO
                }
                    
            }
        }
        stage('Build') {
        steps {
            dir('app') {
                sh 'mvn -B -DskipTests clean package'
            }
        }
    }

    stage('Build Image') {
        steps {
            dir('app') {
                sh 'docker build -t "$IMAGE_NAME" .'
            }
        }
    }

    stage('Push Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_TOKEN')]) {
          sh '''
            set -e
            echo "$DOCKERHUB_TOKEN" | docker login -u "$DOCKERHUB_USER" --password-stdin
            docker tag "${IMAGE_NAME}" "${REGISTRY}"
            docker push "${REGISTRY}"
          '''
        }
      }
    }

    stage('deploy') {
        steps {
            sh "kubectl config use-context ${KUBE_CONTEXT}"
            sh "kubectl apply -f k8s/namespace.yaml"
            sh "kubectl apply -f k8s/deployment.yaml"
            sh "kubectl apply -f k8s/service.yaml"
            sh "kubectl -n ${K8S_NAMESPACE} rollout status deployment/spring-boot-hello --timeout=120s"
        }
    }
}
}
