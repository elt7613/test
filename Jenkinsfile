pipeline {
    agent any

    environment {
        VENV - 'venv'
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
                bat 'python -m venv %VENV%'
                bat '%VENV%\\Scripts\\python -m pip install --upgrade pip'
                bat '%VENV%\\Scripts\\pip install -r requirements.txt'
            }
        }

        stage('Run Make Migrations') {
            steps {
                bat '%VENV%\\Scripts\\python manage.py makemigrations'
            }
        }

        stage('Run Migrations') {
            steps {
                bat '%VENV%\\Scripts\\python manage.py migrate'
            }
        }

        stage('Run Test case') {
            steps {
                bat '%VENV%\\Scripts\\python test.py'
            }
        }

        stage('Run Server') {
            steps {
                sh '%VENV%\\Scripts\\nohup python manage.py runserver 0.0.0.0:8123 &'
            }
        }
    }
}
