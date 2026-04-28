       IDENTIFICATION DIVISION.
       PROGRAM-ID. COBPGM02.

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01 WS-ACC-ID     PIC S9(9) COMP-5.
       01 WS-CUST-ID    PIC X(10).
       01 WS-BALANCE    PIC S9(9)V99 COMP-3.
       01 WS-STATUS     PIC X(10).
       01 WS-ACC-TYPE   PIC X(10).
       01 WS-OPEN-DATE  PIC X(10).
       EXEC SQL END DECLARE SECTION END-EXEC.

      * Report counters
       01 WS-TOTAL-ACCTS   PIC 9(4) VALUE 0.
       01 WS-TOTAL-BALANCE PIC S9(11)V99 COMP-3 VALUE 0.

           EXEC SQL
           DECLARE C1 CURSOR FOR
           SELECT ACC_ID, CUST_ID, BALANCE, STATUS, ACC_TYPE, OPEN_DATE
           FROM Z10791.ACCOUNT
           END-EXEC.

       PROCEDURE DIVISION.
       MAIN-PARA.
           DISPLAY "=== STARTING DB2 ACCOUNT REPORT ==="
           PERFORM OPEN-CURSOR-PARA
           PERFORM FETCH-LOOP-PARA
           PERFORM CLOSE-CURSOR-PARA
           PERFORM SUMMARY-PARA
           DISPLAY "=== END OF DB2 ACCOUNT REPORT ==="
           STOP RUN.

       OPEN-CURSOR-PARA.
           EXEC SQL
               OPEN C1
           END-EXEC.
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
                      :WS-ACC-ID,
                      :WS-CUST-ID,
                      :WS-BALANCE,
                      :WS-STATUS,
                      :WS-ACC-TYPE,
                      :WS-OPEN-DATE
              END-EXEC

              EVALUATE SQLCODE
                 WHEN 0
                    PERFORM DISPLAY-RECORD-PARA
                    ADD 1 TO WS-TOTAL-ACCTS
                    ADD WS-BALANCE TO WS-TOTAL-BALANCE
                 WHEN 100
                    DISPLAY "End of result set."
                 WHEN OTHER
                    DISPLAY "Error fetching row, SQLCODE=" SQLCODE
                    EXIT PERFORM
              END-EVALUATE
           END-PERFORM.

       DISPLAY-RECORD-PARA.
           DISPLAY "------------------------------------"
           DISPLAY "Account ID   : " WS-ACC-ID
           DISPLAY "Customer ID  : " WS-CUST-ID
           DISPLAY "Balance      : " WS-BALANCE
           DISPLAY "Status       : " WS-STATUS
           DISPLAY "Account Type : " WS-ACC-TYPE
           DISPLAY "Open Date    : " WS-OPEN-DATE.

       CLOSE-CURSOR-PARA.
           EXEC SQL
               CLOSE C1
           END-EXEC.
           DISPLAY "Cursor closed."
           .

       SUMMARY-PARA.
           DISPLAY "===================================="
           DISPLAY "TOTAL ACCOUNTS : " WS-TOTAL-ACCTS
           DISPLAY "TOTAL BALANCE  : " WS-TOTAL-BALANCE
           DISPLAY "====================================".