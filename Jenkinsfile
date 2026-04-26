pipeline {
    agent any

    stages {
        stage('Check Zowe CLI') {
            steps {
                bat 'zowe --version'
            }
        }

        stage('Submit Test JCL') {
            steps {
                bat '''
                zowe zos-jobs submit local-file src\\jcl\\compile.jcl --zosmf-profile zosmf --rfj > result.json
                type result.json
                '''
            }
        }
    }
}
