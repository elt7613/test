pipeline {
  agent {
    docker {
      image 'python:3.12-slim'
      args '-u'
    }
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Install Dependencies') {
      steps {
        sh '''
          python --version
          python -m pip install --upgrade pip
          pip install -r requirements.txt
        '''
      }
    }
    stage('Migrate DB') {
      steps {
        sh '''
          rm -f db.sqlite3 || true
          python manage.py migrate --noinput
        '''
      }
    }
    stage('Run Checks/Tests') {
      steps {
        sh '''
          python manage.py check
          # python manage.py test
        '''
      }
    }
  }
}