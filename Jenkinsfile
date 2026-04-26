pipeline {
    agent any

    environment {
        SRC_DIR = "src/coboldb2"
        JCL_DIR = "src/jcl"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Compile Programs') {
            steps {
                script {
                    def cobolFiles = findFiles(glob: "${SRC_DIR}/*.cbl")
                    cobolFiles.each { file ->
                        echo "Submitting compile JCL for ${file.name}"
                        bat """
                        zowe zos-jobs submit local-file ${JCL_DIR}/compile.jcl ^
                            --host 204.90.115.200 --port 10443 ^
                            --user %ZOSMF_USER% --password %ZOSMF_PASS% ^
                            --reject-unauthorized false --view-all-spool-content
                        """
                    }
                }
            }
        }

        stage('Bind Programs') {
            steps {
                bat """
                zowe zos-jobs submit local-file ${JCL_DIR}/bind.jcl ^
                    --host 204.90.115.200 --port 10443 ^
                    --user %ZOSMF_USER% --password %ZOSMF_PASS% ^
                    --reject-unauthorized false --view-all-spool-content
                """
            }
        }

        stage('Run Programs') {
            steps {
                bat """
                zowe zos-jobs submit local-file ${JCL_DIR}/run.jcl ^
                    --host 204.90.115.200 --port 10443 ^
                    --user %ZOSMF_USER% --password %ZOSMF_PASS% ^
                    --reject-unauthorized false --view-all-spool-content
                """
            }
        }
    }
}
