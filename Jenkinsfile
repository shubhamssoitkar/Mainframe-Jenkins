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
                bat "zowe zos-jobs submit local-file %JCL_DIR%\\runjcl.jcl --zosmf-profile %ZOSMF_PROFILE% --rfj"
            }
        }
    }
}
