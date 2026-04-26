pipeline {
    agent any

    stages {
        stage('Create Profile') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'zosmf-credentials',
                                                 usernameVariable: 'ZOSMF_USER',
                                                 passwordVariable: 'ZOSMF_PASS')]) {
                    bat """
                    zowe zosmf profile create zosmf ^
                        --host your.zosmf.host --port 443 ^
                        --user %ZOSMF_USER% --password %ZOSMF_PASS% ^
                        --reject-unauthorized false
                    """
                }
            }
        }

        stage('Submit Run JCL') {
            steps {
                bat "zowe zos-jobs submit data-set Z10791.COBDB2.JCL(DB2RUN) --zosmf-profile zosmf --view-all-spool-content"
            }
        }
    }
}
