pipeline {
    agent any

    environment {
        JCL_DATASET = "Z10791.COBDB2.JCL(DB2RUN)"
    }

    stages {
        stage('Check Zowe CLI') {
            steps {
                bat 'zowe --version'
            }
        }

        stage('Submit Run JCL') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'zosmf-credentials',
                                                 usernameVariable: 'ZOSMF_USER',
                                                 passwordVariable: 'ZOSMF_PASS')]) {
                    bat """
                    zowe zos-jobs submit data-set %JCL_DATASET% ^
                        --host 204.90.115.200 --port 10443 ^
                        --user %ZOSMF_USER% --password %ZOSMF_PASS% ^
                        --reject-unauthorized false ^
                        --view-all-spool-content
                    """
                }
            }
        }
    }
}
