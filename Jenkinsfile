pipeline {
    agent any

    environment {
        SRC_DIR = "coboldb2"
        JCL_DIR = "jcl"
        ZOSMF_PROFILE = "zosmf"   // confirmed profile name
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
                    def files = []
                    def srcDir = new File("${env.WORKSPACE}/${SRC_DIR}")
                    if (srcDir.exists()) {
                        srcDir.eachFileMatch(~/.*\.cbl/) { f ->
                            files << f.name.replace('.cbl','')
                        }
                    }
                    env.PROGRAMS = files.join(',')
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
                            echo ">>> Building and running program: ${p}"

                            // Compile
                            bat """
                            zowe zos-jobs submit local-file %JCL_DIR%\\compile.jcl --rfj --variable DB2PGM=${p} --zosmf-profile %ZOSMF_PROFILE% > compile_${p}.json
                            for /f "tokens=2 delims=:," %%i in ('findstr JOBID compile_${p}.json') do set JOBID=%%i
                            zowe zos-jobs view job-output-by-jobid %JOBID% --zosmf-profile %ZOSMF_PROFILE%
                            """

                            // Bind
                            bat """
                            zowe zos-jobs submit local-file %JCL_DIR%\\bind.jcl --rfj --variable DB2PGM=${p} --zosmf-profile %ZOSMF_PROFILE% > bind_${p}.json
                            for /f "tokens=2 delims=:," %%i in ('findstr JOBID bind_${p}.json') do set JOBID=%%i
                            zowe zos-jobs view job-output-by-jobid %JOBID% --zosmf-profile %ZOSMF_PROFILE%
                            """

                            // Run
                            bat """
                            zowe zos-jobs submit local-file %JCL_DIR%\\run.jcl --rfj --variable DB2PGM=${p} --zosmf-profile %ZOSMF_PROFILE% > run_${p}.json
                            for /f "tokens=2 delims=:," %%i in ('findstr JOBID run_${p}.json') do set JOBID=%%i
                            zowe zos-jobs view job-output-by-jobid %JOBID% --zosmf-profile %ZOSMF_PROFILE%
                            """
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
            archiveArtifacts artifacts: '*.json', fingerprint: true
        }
    }
}
