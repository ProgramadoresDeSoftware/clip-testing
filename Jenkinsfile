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
                    python3 --version
                    pip3 install --user selenium requests
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
