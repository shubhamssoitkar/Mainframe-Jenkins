pipeline {
    agent any
    stages {
        stage('Create Profile') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'zosmf-credentials',
                                                 usernameVariable: 'ZOSMF_USER',
                                                 passwordVariable: 'ZOSMF_PASS')]) {
                    bat """
                    zowe profiles create zosmf zosmf ^
                        --host your.zosmf.host --port 443 ^
                        --user %ZOSMF_USER% --password %ZOSMF_PASS% ^
                        --reject-unauthorized false
                    """
                }
            }
        }
    }
}
