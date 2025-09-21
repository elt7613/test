pipeline {
   agent any

   environment { 
     PORT = '8000'; 
     IMAGE = 'test-cicd:latest' 
   }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Docker Build') {
      steps {
        sh '''
          docker version
          docker build -t ${IMAGE} -f Dockerfile .
        '''
      }
    }
    stage('Smoke Test') {
      steps {
        sh '''
          set -e
          docker run -d --rm --name test-cicd-smoke -p ${PORT}:${PORT} ${IMAGE}
          for i in $(seq 1 30); do
            sleep 1
            if curl -fsS http://127.0.0.1:${PORT}/ >/dev/null 2>&1; then echo "App is healthy"; exit 0; fi
          done
          echo "Smoke test failed"; exit 1
        '''
      }
      post {
        always {
          sh 'docker rm -f test-cicd-smoke >/dev/null 2>&1 || true'
        }
      }
    }
  }
}