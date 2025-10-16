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
                    
                    # Create and configure virtual environment
                    echo "Setting up virtual environment..."
                    ./setup_venv.sh
                    
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
                echo '======================================================================'
                echo 'TESTING LOGIN WITH CORRECT CREDENTIALS'
                echo '======================================================================'
                script {
                    try {
                        sh '''
                            source venv/bin/activate
                            python3 test_login.py --mode correct
                        '''
                        echo '======================================================================'
                        echo 'LOGIN TEST WITH CORRECT CREDENTIALS: PASSED'
                        echo '======================================================================'
                    } catch (Exception e) {
                        echo '======================================================================'
                        echo "LOGIN TEST WITH CORRECT CREDENTIALS: FAILED - ${e.message}"
                        echo '======================================================================'
                        error('Test failed with correct credentials')
                    }
                }
            }
        }
        
        stage('Test Login - Incorrect Credentials') {
            steps {
                echo '======================================================================'
                echo 'TESTING LOGIN WITH INCORRECT CREDENTIALS'
                echo '======================================================================'
                script {
                    try {
                        sh '''
                            source venv/bin/activate
                            python3 test_login.py --mode incorrect
                        '''
                        echo '======================================================================'
                        echo 'LOGIN TEST WITH INCORRECT CREDENTIALS: PASSED (correctly rejected)'
                        echo '======================================================================'
                    } catch (Exception e) {
                        echo '======================================================================'
                        echo "LOGIN TEST WITH INCORRECT CREDENTIALS: FAILED - ${e.message}"
                        echo '======================================================================'
                        error('Test failed with incorrect credentials')
                    }
                }
            }
        }
        
        stage('Report Results') {
            steps {
                echo '======================================================================'
                echo 'ALL LOGIN TESTS COMPLETED SUCCESSFULLY'
                echo '======================================================================'
                echo 'Test Summary:'
                echo '  - Correct credentials: Access granted as expected'
                echo '  - Incorrect credentials: Access denied as expected'
                echo '======================================================================'
            }
        }
    }
    
    post {
        success {
            echo '======================================================================'
            echo 'PIPELINE COMPLETED SUCCESSFULLY!'
            echo '======================================================================'
        }
        failure {
            echo '======================================================================'
            echo 'PIPELINE FAILED - Check the logs for details'
            echo '======================================================================'
        }
        always {
            echo 'Cleaning up...'
        }
    }
}
