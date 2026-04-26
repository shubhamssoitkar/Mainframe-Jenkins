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
                    def response = zoweSubmitJob(
                        file: "${JCL_DIR}/compile.jcl",
                        zosmfProfile: "${ZOSMF_PROFILE}"
                    )
                    echo "Compile job submitted: ${response.jobId}"
                    zoweViewJobOutput(jobId: response.jobId, zosmfProfile: "${ZOSMF_PROFILE}")
                }
            }
        }

        stage('Bind Program') {
            steps {
                script {
                    def response = zoweSubmitJob(
                        file: "${JCL_DIR}/bind.jcl",
                        zosmfProfile: "${ZOSMF_PROFILE}"
                    )
                    echo "Bind job submitted: ${response.jobId}"
                    zoweViewJobOutput(jobId: response.jobId, zosmfProfile: "${ZOSMF_PROFILE}")
                }
            }
        }

        stage('Run Program') {
            steps {
                script {
                    def response = zoweSubmitJob(
                        file: "${JCL_DIR}/run.jcl",
                        zosmfProfile: "${ZOSMF_PROFILE}"
                    )
                    echo "Run job submitted: ${response.jobId}"
                    zoweViewJobOutput(jobId: response.jobId, zosmfProfile: "${ZOSMF_PROFILE}")
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '*.jcl', fingerprint: true
        }
    }
}