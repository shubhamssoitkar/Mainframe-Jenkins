pipeline {
    agent any

    stages {
        stage('Test Zowe Job') {
            steps {
                script {
                    def result = submitJobSync(
                        file: "src/jcl/compile.jcl",
                        zosmfProfile: "zosmf"
                    )
                    echo "Job submitted: ID=${result.jobId}, RC=${result.retCode}"
                }
            }
        }
    }
}
