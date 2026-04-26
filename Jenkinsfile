pipeline {
    agent any

    stages {
        stage('Check Zowe CLI') {
            steps {
                bat 'zowe --version'
            }
        }

        stage('Submit Run JCL') {
            steps {
                bat 'zowe zos-jobs submit local-file src\\jcl\\runjcl.jcl --zosmf-profile zosmf --rfj'
            }
        }
    }
}