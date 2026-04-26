pipeline {
    agent any

    environment {
        SRC_DIR = "src/coboldb2"   // COBOL source folder
        JCL_DIR = "src/jcl"        // JCL folder
        ZOSMF_PROFILE = "zosmf"    // Your Zowe profile name
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
                    if (files.size() > 0) {
                        env.PROGRAMS = files.collect { it.name.replace('.cbl','') }.join(',')
                        echo "Discovered COBOL-DB2 programs: ${env.PROGRAMS}"
                    } else {
                        echo "No COBOL programs found in ${SRC_DIR}"
                        env.PROGRAMS = ""
                    }
                }
            }
        }

        stage('Build and Run Programs') {
            steps {
                script {
                    def results = []
                    if (env.PROGRAMS?.trim()) {
                        def programs = env.PROGRAMS.split(',')
                        for (p in programs) {
                            echo ">>> Processing program: ${p}"

                            def compileResult = submitJobSync(
                                file: "${JCL_DIR}/compile.jcl",
                                zosmfProfile: "${ZOSMF_PROFILE}"
                            )
                            echo "Compile job for ${p}: ID=${compileResult.jobId}, RC=${compileResult.retCode}"
                            if (compileResult.retCode.toInteger() > 4) {
                                error "Compile failed for ${p} with RC=${compileResult.retCode}"
                            }

                            def bindResult = submitJobSync(
                                file: "${JCL_DIR}/bind.jcl",
                                zosmfProfile: "${ZOSMF_PROFILE}"
                            )
                            echo "Bind job for ${p}: ID=${bindResult.jobId}, RC=${bindResult.retCode}"
                            if (bindResult.retCode.toInteger() > 4) {
                                error "Bind failed for ${p} with RC=${bindResult.retCode}"
                            }

                            def runResult = submitJobSync(
                                file: "${JCL_DIR}/run.jcl",
                                zosmfProfile: "${ZOSMF_PROFILE}"
                            )
                            echo "Run job for ${p}: ID=${runResult.jobId}, RC=${runResult.retCode}"
                            if (runResult.retCode.toInteger() > 4) {
                                error "Run failed for ${p} with RC=${runResult.retCode}"
                            }

                            results << [program: p,
                                        compileId: compileResult.jobId, compileRC: compileResult.retCode,
                                        bindId: bindResult.jobId, bindRC: bindResult.retCode,
                                        runId: runResult.jobId, runRC: runResult.retCode]
                        }
                    } else {
                        echo "Skipping build/run — no COBOL programs discovered."
                    }
                    // Save results for summary
                    currentBuild.description = results.collect { r ->
                        "${r.program}: C(${r.compileRC}) B(${r.bindRC}) R(${r.runRC})"
                    }.join(" | ")
                }
            }
        }

        stage('Summary') {
            steps {
                script {
                    echo "=== Job Summary ==="
                    echo currentBuild.description
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'src/jcl/*.jcl', fingerprint: true
        }
    }
}
