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
                bat 'zowe profiles list zosmf'
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
                        --zosmf-profile %ZOSMF_PROFILE% --view-all-spool-content
                    """
                }
            }
        }
    }
}
