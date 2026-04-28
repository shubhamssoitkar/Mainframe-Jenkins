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

        stage('Upload COBOL Sources') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'zosmf-credentials',
                                                  usernameVariable: 'ZOSMF_USER',
                                                  passwordVariable: 'ZOSMF_PASS')]) {
                    script {
                        def cobolFiles = findFiles(glob: "${COBOL_DIR}/*.cbl")
                        cobolFiles.each { file ->
                            def pgmName = file.name.replace(".cbl","").toUpperCase()
                            echo "Uploading ${file.name} to Z10791.CBL(${pgmName})"
                            bat """
                            zowe files upload file-to-data-set ${file.path} "Z10791.CBL(${pgmName})" ^
                                --host %HOST% --port %PORT% ^
                                --user %ZOSMF_USER% --password %ZOSMF_PASS% ^
                                --reject-unauthorized false
                            """
                        }
                    }
                }
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
                            powershell -Command "(Get-Content ${JCL_DIR}/COMPDB2.jcl) -replace '&PGMNAME', '${pgmName}' | Set-Content ${JCL_DIR}/COMPDB2_${pgmName}.jcl"
                            zowe zos-jobs submit local-file ${JCL_DIR}/COMPDB2_${pgmName}.jcl ^
                                --host %HOST% --port %PORT% ^
                                --user %ZOSMF_USER% --password %ZOSMF_PASS% ^
                                --reject-unauthorized false --view-all-spool-content
                            del ${JCL_DIR}\\COMPDB2_${pgmName}.jcl
                            """
                        }
                    }
                }
            }
        }

        stage('Bind All Programs') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'zosmf-credentials',
                                                  usernameVariable: 'ZOSMF_USER',
                                                  passwordVariable: 'ZOSMF_PASS')]) {
                    script {
                        // Collect all COBOL program names from Git folder
                        def cobolFiles = findFiles(glob: "src/coboldb2/*.cbl")
                        def members = cobolFiles.collect { file ->
                            file.name.replace(".cbl","").toUpperCase()
                        }

                        // Build bind SYSIN dynamically
                        def bindSysin = new StringBuilder()
                        bindSysin.append("//DB2BIND JOB ,CLASS=7,MSGLEVEL=(1,1)\n")
                        bindSysin.append("//DSNTSO   EXEC PGM=IKJEFT01,REGION=0M\n")
                        bindSysin.append("//STEPLIB  DD DISP=SHR,DSN=Z10791.LOAD\n")
                        bindSysin.append("//         DD DISP=SHR,DSN=ZXP.PUBLIC.LOAD\n")
                        bindSysin.append("//         DD DISP=SHR,DSN=DSND10.SDSNLOAD\n")
                        bindSysin.append("//         DD DISP=SHR,DSN=DSND10.SDSNLOD2\n")
                        bindSysin.append("//DBRMLIB  DD DISP=SHR,DSN=Z10791.DBRMLIB\n")
                        bindSysin.append("//SYSTSPRT DD SYSOUT=*\n")
                        bindSysin.append("//SYSTSIN  DD *\n")
                        bindSysin.append("  DSN SYSTEM(DBDG)\n")
                        bindSysin.append("  BIND PLAN(Z10791) -\n")
                        members.each { pgm ->
                            bindSysin.append("       MEMBER(${pgm}) -\n")
                        }
                        bindSysin.append("       ACTION(REPLACE) ISO(CS) VALIDATE(RUN)\n")
                        bindSysin.append("  END\n")
                        bindSysin.append("/*\n")

                        // Write to JCL file
                        writeFile file: "src/jcl/BIND_ALL.jcl", text: bindSysin.toString()

                        // Submit bind job
                        bat """
                        zowe zos-jobs submit local-file src/jcl/BIND_ALL.jcl ^
                            --host %HOST% --port %PORT% ^
                            --user %ZOSMF_USER% --password %ZOSMF_PASS% ^
                            --reject-unauthorized false --view-all-spool-content
                        """
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
                            powershell -Command "(Get-Content ${JCL_DIR}/RUNJCL.jcl) -replace '&PGMNAME', '${pgmName}' | Set-Content ${JCL_DIR}/RUNJCL_${pgmName}.jcl"
                            zowe zos-jobs submit local-file ${JCL_DIR}/RUNJCL_${pgmName}.jcl ^
                                --host %HOST% --port %PORT% ^
                                --user %ZOSMF_USER% --password %ZOSMF_PASS% ^
                                --reject-unauthorized false --view-all-spool-content
                            del ${JCL_DIR}\\RUNJCL_${pgmName}.jcl
                            """
                        }
                    }
                }
            }
        }
    }

    post {
        failure {
            echo "Pipeline failed — notify team here (email/Slack integration can be added)."
        }
    }
}
