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

        stage('Submit Run JCL') {
            steps {
                bat "zowe zos-jobs submit data-set %JCL_DATASET% --zosmf-profile %ZOSMF_PROFILE% --view-all-spool-content"
            }
        }
    }
}
