       IDENTIFICATION DIVISION.
       PROGRAM-ID. COBPGM01.

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.

           EXEC SQL INCLUDE SQLCA END-EXEC.

           EXEC SQL BEGIN DECLARE SECTION END-EXEC.

       01  DEPTNO            PIC X(3).
       01  DEPTNAME.
           05  DEPTNAME-LEN  PIC S9(4) COMP-5.
           05  DEPTNAME-TEXT PIC X(36).
       01  MGRNO             PIC X(6).
       01  ADMRDEPT          PIC X(3).
       01  LOCATION          PIC X(16).

           EXEC SQL END DECLARE SECTION END-EXEC.

       01  WS-TOTAL-DEPTS    PIC 9(4) VALUE 0.

           EXEC SQL
               DECLARE C1 CURSOR FOR
               SELECT DEPTNO,
                      DEPTNAME,
                      MGRNO,
                      ADMRDEPT,
                      LOCATION
               FROM IBMUSER.DEPT
           END-EXEC.

       PROCEDURE DIVISION.
       MAIN-PARA.
           DISPLAY "=== STARTING DB2 DEPT REPORT ==="
           PERFORM OPEN-CURSOR-PARA
           PERFORM FETCH-LOOP-PARA
           PERFORM CLOSE-CURSOR-PARA
           PERFORM SUMMARY-PARA
           DISPLAY "=== END OF DB2 DEPT REPORT ==="
           STOP RUN.

       OPEN-CURSOR-PARA.
           EXEC SQL
               OPEN C1
           END-EXEC
           IF SQLCODE = 0
              DISPLAY "Cursor opened successfully."
           ELSE
              DISPLAY "Error opening cursor, SQLCODE=" SQLCODE
              STOP RUN
           END-IF.

       FETCH-LOOP-PARA.
           PERFORM UNTIL SQLCODE NOT = 0
              EXEC SQL
                  FETCH C1 INTO
                      :DEPTNO,
                      :DEPTNAME,
                      :MGRNO,
                      :ADMRDEPT,
                      :LOCATION
              END-EXEC
              IF SQLCODE = 0
                 PERFORM DISPLAY-RECORD-PARA
                 ADD 1 TO WS-TOTAL-DEPTS
              END-IF
           END-PERFORM.

       DISPLAY-RECORD-PARA.
           DISPLAY "------------------------------------"
           DISPLAY "DEPTNO     : " DEPTNO
           DISPLAY "DEPTNAME   : "
                   DEPTNAME-TEXT (1:DEPTNAME-LEN)
           DISPLAY "MGRNO      : " MGRNO
           DISPLAY "ADMRDEPT   : " ADMRDEPT
           DISPLAY "LOCATION   : " LOCATION.

       CLOSE-CURSOR-PARA.
           EXEC SQL
               CLOSE C1
           END-EXEC
           DISPLAY "Cursor closed.".

       SUMMARY-PARA.
           DISPLAY "===================================="
           DISPLAY "TOTAL DEPARTMENTS : " WS-TOTAL-DEPTS
           DISPLAY "====================================".