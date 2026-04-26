pipeline {
    agent any

    environment {
        SRC_DIR = "coboldb2"
        JCL_DIR = "jcl"
        ZOSMF_PROFILE = "zosmf"
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/shubhamssoitkar/Mainframe-Jenkins.git', branch: 'main'
            }
        }

        stage('Discover COBOL Programs') {
            steps {
                script {
                    def files = findFiles(glob: "${SRC_DIR}/*.cbl")
                    env.PROGRAMS = files.collect { it.name.replace('.cbl','') }.join(',')
                    echo "Discovered COBOL-DB2 programs: ${env.PROGRAMS}"
                }
            }
        }

        stage('Build and Run Programs') {
            steps {
                script {
                    if (env.PROGRAMS?.trim()) {
                        def programs = env.PROGRAMS.split(',')
                        for (p in programs) {
                            echo ">>> Processing program: ${p}"

                            // Compile
                            def compileResult = submitJobSync(
                                file: "${JCL_DIR}/compile.jcl",
                                zosmfProfile: "${ZOSMF_PROFILE}"
                            )
                            echo "Compile job for ${p} finished: ID=${compileResult.jobId}, RC=${compileResult.retCode}"

                            // Bind
                            def bindResult = submitJobSync(
                                file: "${JCL_DIR}/bind.jcl",
                                zosmfProfile: "${ZOSMF_PROFILE}"
                            )
                            echo "Bind job for ${p} finished: ID=${bindResult.jobId}, RC=${bindResult.retCode}"

                            // Run
                            def runResult = submitJobSync(
                                file: "${JCL_DIR}/run.jcl",
                                zosmfProfile: "${ZOSMF_PROFILE}"
                            )
                            echo "Run job for ${p} finished: ID=${runResult.jobId}, RC=${runResult.retCode}"
                        }
                    } else {
                        echo "No COBOL programs found in ${SRC_DIR}"
                    }
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
