pipeline {
    agent {
        docker {
            image 'python:3.12'   // official Python image with pip + venv
        }
    }

    stages {
        stage('Checkout') {
            steps {
                // Pull code from Git
                git branch: 'main', url: 'https://github.com/elt7613/test.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    python -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Run Make Migrations') {
            steps {
                sh '''
                    . venv/bin/activate
                    python manage.py makemigrations
                '''
            }
        }

        stage('Run Migrations') {
            steps {
                sh '''
                    . venv/bin/activate
                    python manage.py migrate
                '''
            }
        }

        stage('Run Test case') {
            steps {
                sh '''
                    . venv/bin/activate
                    python test.py
                '''
            }
        }

        stage('Run Server') {
            steps {
                sh '''
                    . venv/bin/activate
                    nohup python manage.py runserver 0.0.0.0:8123 &
                '''
            }
        }
    }
}
