pipeline {
    agent any
    
    environment {
        SITE_URL = 'https://clasesprofesores.net/login'
    }
    
    stages {
        stage('Setup') {
            steps {
                echo 'Setting up test environment'
                sh '''
                    # Verify Python installation
                    echo "Checking Python installation..."
                    python3 --version || { echo "ERROR: Python 3 is not installed. Please install Python 3."; exit 1; }
                    pip3 --version || { echo "ERROR: pip3 is not installed. Please install pip3."; exit 1; }
                    
                    # Install Python dependencies
                    echo "Installing Python dependencies..."
                    pip3 install --user -r requirements.txt
                    
                    # Verify Chrome installation
                    echo "Checking Google Chrome installation..."
                    if ! command -v google-chrome &> /dev/null; then
                        echo "WARNING: Google Chrome is not installed."
                        echo "Please install Google Chrome on the Jenkins agent."
                        echo "For Debian/Ubuntu: sudo apt-get install google-chrome-stable"
                        exit 1
                    fi
                    google-chrome --version
                    
                    # Verify ChromeDriver installation
                    echo "Checking ChromeDriver installation..."
                    if ! command -v chromedriver &> /dev/null; then
                        echo "WARNING: ChromeDriver is not installed."
                        echo "Please install ChromeDriver on the Jenkins agent."
                        echo "Download from: https://chromedriver.chromium.org/"
                        exit 1
                    fi
                    chromedriver --version
                    
                    echo "Environment setup completed successfully!"
                '''
            }
        }
        
        stage('Test Login - Correct Credentials') {
            steps {
                echo 'Testing login with correct credentials'
                script {
                    try {
                        sh 'python3 test_login.py --mode correct'
                        echo 'Login test with correct credentials: PASSED'
                    } catch (Exception e) {
                        echo "Login test with correct credentials: FAILED - ${e.message}"
                        error('Test failed with correct credentials')
                    }
                }
            }
        }
        
        stage('Test Login - Incorrect Credentials') {
            steps {
                echo 'Testing login with incorrect credentials'
                script {
                    try {
                        sh 'python3 test_login.py --mode incorrect'
                        echo 'Login test with incorrect credentials: PASSED (correctly rejected)'
                    } catch (Exception e) {
                        echo "Login test with incorrect credentials: FAILED - ${e.message}"
                        error('Test failed with incorrect credentials')
                    }
                }
            }
        }
        
        stage('Report Results') {
            steps {
                echo 'All login tests completed successfully'
                echo 'Test Summary:'
                echo '  - Correct credentials: Access granted as expected'
                echo '  - Incorrect credentials: Access denied as expected'
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }
        always {
            echo 'Cleaning up...'
        }
    }
}
