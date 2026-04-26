pipeline {
    agent any

    environment {
        JCL_DIR = "jcl"
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
                bat "zowe zos-jobs submit data-set "Z10791.COBDB2.JCL(DB2RUN)" --view-all-spool-content"
            }
        }
    }
}
