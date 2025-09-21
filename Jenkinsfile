pipeline {
   agent any

   environment { 
     PORT = '8123'
   }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Set up Python and install deps') {
      steps {
        sh '''
          set -e
          python3 --version
          python3 -m venv venv
          . venv/bin/activate
          pip install --upgrade pip
          pip install -r requirements.txt
        '''
      }
    }
    stage('Migrate & Django checks') {
      steps {
        sh '''
          set -e
          . venv/bin/activate
          rm -f db.sqlite3 || true
          python manage.py migrate --noinput
          python manage.py check --deploy
        '''
      }
    }
    stage('Smoke Test') {
      steps {
        sh '''
          set -e
          . venv/bin/activate
          (python manage.py runserver 127.0.0.1:${PORT} & echo $! > django.pid)
          # Wait up to ~20s for server
          for i in $(seq 1 20); do
            sleep 1
            if curl -fsS http://127.0.0.1:${PORT}/ >/dev/null 2>&1; then echo "App is healthy"; break; fi
            if [ "$i" -eq 20 ]; then echo "Smoke test failed"; exit 1; fi
          done
        '''
      }
      post {
        always {
          sh 'if [ -f django.pid ]; then kill $(cat django.pid) || true; rm -f django.pid; fi'
        }
      }
    }
  }
}