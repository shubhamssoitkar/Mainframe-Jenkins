pipeline {
    agent any

    environment {
        JCL_DATASET   = "Z10791.COBDB2.JCL(DB2RUN)"
        ZOSMF_PROFILE = "zosmf"
    }

    stages {
        stage('Check Zowe CLI') {
            steps {
                bat 'zowe --version'
            }
        }

        stage('Verify Profiles') {
            steps {
                // Correct syntax for Zowe CLI v3
                bat 'zowe config list profiles'
            }
        }

        stage('Submit Run JCL') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'zosmf-credentials',
                                                 usernameVariable: 'ZOSMF_USER',
                                                 passwordVariable: 'ZOSMF_PASS')]) {
                    bat """
                    zowe zos-jobs submit data-set %JCL_DATASET% ^
                        --user %ZOSMF_USER% --password %ZOSMF_PASS% ^
                        --host your.zosmf.host --port 443 ^
                        --reject-unauthorized false ^
                        --view-all-spool-content
                    """
                }
            }
        }
    }
}
