pipeline {
    agent any

    environment {
        JCL_DIR = "jcl"
        ZOSMF_PROFILE = "zosmf"
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/shubhamssoitkar/Mainframe-Jenkins.git', branch: 'main'
            }
        }

        stage('Compile Program') {
            steps {
                script {
                    def result = submitJobSync(
                        file: "${JCL_DIR}/compile.jcl",
                        zosmfProfile: "${ZOSMF_PROFILE}"
                    )
                    echo "Compile job finished with ID: ${result.jobId}"
                    echo "Return code: ${result.retCode}"
                }
            }
        }

        stage('Bind Program') {
            steps {
                script {
                    def result = submitJobSync(
                        file: "${JCL_DIR}/bind.jcl",
                        zosmfProfile: "${ZOSMF_PROFILE}"
                    )
                    echo "Bind job finished with ID: ${result.jobId}"
                    echo "Return code: ${result.retCode}"
                }
            }
        }

        stage('Run Program') {
            steps {
                script {
                    def result = submitJobSync(
                        file: "${JCL_DIR}/run.jcl",
                        zosmfProfile: "${ZOSMF_PROFILE}"
                    )
                    echo "Run job finished with ID: ${result.jobId}"
                    echo "Return code: ${result.retCode}"
                }
            }
        }
    }
}
