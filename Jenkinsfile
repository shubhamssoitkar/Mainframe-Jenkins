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
                bat 'zowe zos-jobs submit local-file src\\jcl\\runjcl.jcl --zosmf-profile zosmf'
            }
        }

        stage('Check Job Status') {
            steps {
                // Replace JOB12345 with your actual job ID
                bat 'zowe zos-jobs view job-status-by-jobid JOB12345 --zosmf-profile zosmf'
            }
        }
    }
}
