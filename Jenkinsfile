pipeline {
    agent any

    environment {
        COBOL_DIR = "src/coboldb2"
        JCL_DIR   = "src/jcl"
        HOST      = "204.90.115.200"
        PORT      = "10443"
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
                        def cobolFiles = findFiles(glob: "${COBOL_DIR}/*.cbl")
                        cobolFiles.each { file ->
                            def pgmName = file.name.replace(".cbl","")
                            echo "Submitting compile JCL for ${pgmName}"
                            bat """
                            zowe zos-jobs submit local-file ${JCL_DIR}/COMPDB2.jcl ^
                                --vasc "PGMNAME=${pgmName}" ^
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
                    script {
                        def cobolFiles = findFiles(glob: "${COBOL_DIR}/*.cbl")
                        cobolFiles.each { file ->
                            def pgmName = file.name.replace(".cbl","")
                            echo "Submitting bind JCL for ${pgmName}"
                            bat """
                            zowe zos-jobs submit local-file ${JCL_DIR}/BINDDB2.jcl ^
                                --vasc "PGMNAME=${pgmName}" ^
                                --host %HOST% --port %PORT% ^
                                --user %ZOSMF_USER% --password %ZOSMF_PASS% ^
                                --reject-unauthorized false --view-all-spool-content
                            """
                        }
                    }
                }
            }
        }

        stage('Run Programs') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'zosmf-credentials',
                                                 usernameVariable: 'ZOSMF_USER',
                                                 passwordVariable: 'ZOSMF_PASS')]) {
                    script {
                        def cobolFiles = findFiles(glob: "${COBOL_DIR}/*.cbl")
                        cobolFiles.each { file ->
                            def pgmName = file.name.replace(".cbl","")
                            echo "Submitting run JCL for ${pgmName}"
                            bat """
                            zowe zos-jobs submit local-file ${JCL_DIR}/RUNJCL.jcl ^
                                --vasc "PGMNAME=${pgmName}" ^
                                --host %HOST% --port %PORT% ^
                                --user %ZOSMF_USER% --password %ZOSMF_PASS% ^
                                --reject-unauthorized false --view-all-spool-content
                            """
                        }
                    }
                }
            }
        }
    }
}
