pipeline {
    agent any

    environment {
        SRC_DIR = "src/coboldb2"
        JCL_DIR = "src/jcl"
        HOST    = "204.90.115.200"
        PORT    = "10443"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Compile Programs') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'zosmf-credentials',
                                                 usernameVariable: 'ZOSMF_USER',
                                                 passwordVariable: 'ZOSMF_PASS')]) {
                    script {
                        def cobolFiles = findFiles(glob: "${SRC_DIR}/*.cbl")
                        cobolFiles.each { file ->
                            echo "Submitting compile JCL for ${file.name}"
                            bat """
                            zowe zos-jobs submit local-file ${JCL_DIR}/compile.jcl ^
                                --host %HOST% --port %PORT% ^
                                --user %ZOSMF_USER% --password %ZOSMF_PASS% ^
                                --reject-unauthorized false --view-all-spool-content
                            """
                        }
                    }
                }
            }
        }

        stage('Bind Programs') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'zosmf-credentials',
                                                 usernameVariable: 'ZOSMF_USER',
                                                 passwordVariable: 'ZOSMF_PASS')]) {
                    bat """
                    zowe zos-jobs submit local-file ${JCL_DIR}/bind.jcl ^
                        --host %HOST% --port %PORT% ^
                        --user %ZOSMF_USER% --password %ZOSMF_PASS% ^
                        --reject-unauthorized false --view-all-spool-content
                    """
                }
            }
        }

        stage('Run Programs') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'zosmf-credentials',
                                                 usernameVariable: 'ZOSMF_USER',
                                                 passwordVariable: 'ZOSMF_PASS')]) {
                    bat """
                    zowe zos-jobs submit local-file ${JCL_DIR}/run.jcl ^
                        --host %HOST% --port %PORT% ^
                        --user %ZOSMF_USER% --password %ZOSMF_PASS% ^
                        --reject-unauthorized false --view-all-spool-content
                    """
                }
            }
        }
    }
}
