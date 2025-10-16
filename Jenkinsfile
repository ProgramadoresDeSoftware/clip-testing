pipeline {
    agent {
        docker {
            image 'python:3.9-slim'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    
    environment {
        SITE_URL = 'https://clasesprofesores.net/login'
    }
    
    stages {
        stage('Setup') {
            steps {
                echo 'Setting up test environment'
                sh '''
                    python3 --version
                    pip3 --version
                    
                    # Install Chrome dependencies and Chrome
                    apt-get update
                    apt-get install -y wget gnupg2 unzip
                    
                    # Install Chrome
                    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
                    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
                    apt-get update
                    apt-get install -y google-chrome-stable
                    
                    # Install ChromeDriver
                    CHROME_VERSION=$(google-chrome --version | sed -E 's/.* ([0-9]+)\\..*/\\1/')
                    wget -q "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_VERSION}" -O /tmp/chromedriver_version
                    CHROMEDRIVER_VERSION=$(cat /tmp/chromedriver_version)
                    wget -q "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip" -O /tmp/chromedriver.zip
                    unzip -o /tmp/chromedriver.zip -d /usr/local/bin/
                    chmod +x /usr/local/bin/chromedriver
                    
                    # Install Python packages
                    pip3 install --no-cache-dir selenium requests
                    
                    # Verify installations
                    google-chrome --version
                    chromedriver --version
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
