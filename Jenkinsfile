pipeline {
  agent { label 'python3' }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Install Dependencies') {
      steps {
        sh '''
          python3 --version
          python3 -m venv venv
          . venv/bin/activate
          pip install --upgrade pip
          pip install -r requirements.txt
        '''
      }
    }
    stage('Migrate DB') {
      steps {
        sh '''
          rm -f db.sqlite3 || true
          . venv/bin/activate
          python manage.py migrate --noinput
        '''
      }
    }
    stage('Run Checks/Tests') {
      steps {
        sh '''
          . venv/bin/activate
          python manage.py check
          # python manage.py test
        '''
      }
    }
    // Optional smoke test with teardown
    stage('Smoke Test (optional)') {
      steps {
        sh '''
          . venv/bin/activate
          (python manage.py runserver 0.0.0.0:8000 & echo $! > django.pid)
          for i in $(seq 1 20); do
            sleep 1
            curl -fsS http://127.0.0.1:8000/ || continue
            exit 0
          done
          echo "Health check failed"; exit 1
        '''
      }
      post {
        always {
          sh 'if [ -f django.pid ]; then kill $(cat django.pid) || true; rm -f django.pid; fi'
        }
      }
    }
    // stage('Deploy') { steps { ... } }
  }
}