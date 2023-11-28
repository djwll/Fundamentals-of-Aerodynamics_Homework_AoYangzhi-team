      PROGRAM MAPPL1
      PARAMETER (NMAX=257,NRX=101,NWX=101)
      REAL ETA(NMAX), F(NMAX), U(NMAX), S(NMAX)
      REAL UTR(NMAX), UTI(NMAX)
      LOGICAL*1 FNAME(32)
      REAL AR(NRX,NWX), AI(NRX,NWX), X(NRX,NWX), Y(NRX,NWX)
      REAL RT(NRX),RTL(NRX), WS(NWX),WSL(NWX)
      CHARACTER*1 ANS
      LOGICAL LABCON, YES, MANUAL
C
      IDEV = 6
      IHARD = 0
      SIZE = 4.0
      CH = 0.020
      CHL = 0.018
C
      NH = 1
      CALL READIT(N,H,ETA,U,S,NRP,NWP,RTL,WSL,AR,AI,NRX,NWX)
      NR = NRP - 1
      NW = NWP - 1
C
      DO 10 IR=1, NRP
        RT(IR) = 10.0 ** RTL(IR)
   10 CONTINUE
C
      DO 15 IW=1, NWP
        WS(IW) = 10.0 ** WSL(IW)
   15 CONTINUE
C
      RTLMIN = RTL(1)
      RTLMAX = RTL(NRP)
C
      WRLMIN = WSL(1)   - 0.5*RTL(NRP)
      WRLMAX = WSL(NWP) - 0.5*RTL(1)
C
      ARMIN = AR(1,1)
      ARMAX = AR(1,1)
      AIMIN = AI(1,1)
      AIMAX = AI(1,1)
      DO 30 IW=1, NWP
        DO 301 IR=1, NRP
          ARMIN = AMIN1(ARMIN,AR(IR,IW))
          ARMAX = AMAX1(ARMAX,AR(IR,IW))
          AIMIN = AMIN1(AIMIN,AI(IR,IW))
          AIMAX = AMAX1(AIMAX,AI(IR,IW))
  301   CONTINUE
   30 CONTINUE
C
C
C---- log-log Rtheta-W plot exponent limits
C      I1 = INT(RTLMIN+100.001) - 100
C      I2 = INT(RTLMAX+100.999) - 100
C      J1 = INT(WRLMIN+100.001) - 100
C      J2 = INT(WRLMAX+100.999) - 100
C
      I1 = 0
      I2 = 6
      J1 = -6
      J2 = 1
C
      RTLMIN = FLOAT(I1)
      RTLMAX = FLOAT(I2)
      WRLMIN = FLOAT(J1)
      WRLMAX = FLOAT(J2)
C
CCC      SF = AMIN1( 1.0/(RTLMAX-RTLMIN) , 1.0/(WRLMAX-WRLMIN) )
      SF = 1.0/(RTLMAX-RTLMIN)
C
      DO 40 IW=1, NWP
        DO 401 IR=1, NRP
          WRL = WSL(IW) - 0.5*RTL(IR)
          X(IR,IW) = (RTL(IR)-RTLMIN) * SF
          Y(IR,IW) = (WRL    -WRLMIN) * SF
  401   CONTINUE
   40 CONTINUE
C
      CALL ASK('Enter contour parameter filename (or <cr>)^',4,FNAME)
      MANUAL = FNAME(1) .EQ. ' '
C
      CALL PLOTS(0,IHARD,IDEV)
      CALL FACTOR(SIZE)
      CALL PLOT(8.0*CH,8.0*CH,-3)
C
      DO 9000 IPASS=1, 2
C
      DO 50 I=I1, I2
        XLIN  = (FLOAT(I) -RTLMIN) * SF
        YLIN1 = (FLOAT(J1)-WRLMIN) * SF
        YLIN2 = (FLOAT(J2)-WRLMIN) * SF
        CALL NEWPEN(1)
        CALL PLOT(XLIN,YLIN1,3)
        CALL PLOT(XLIN,YLIN2,2)
C
        CALL NEWPEN(2)
        RI = FLOAT(I)
        CALL SYMBOL(XLIN-1.0*CH,YLIN1-2.5*CH,1.2*CH,'10',0.0, 2)
        CALL NUMBER(XLIN+1.4*CH,YLIN1-2.0*CH,1.0*CH,RI  ,0.0,-1)
   50 CONTINUE
C
      DO 55 J=J1, J2
        YLIN  = (FLOAT(J) -WRLMIN) * SF
        XLIN1 = (FLOAT(I1)-RTLMIN) * SF
        XLIN2 = (FLOAT(I2)-RTLMIN) * SF
        CALL NEWPEN(1)
        CALL PLOT(XLIN1,YLIN,3)
        CALL PLOT(XLIN2,YLIN,2)
C
        CALL NEWPEN(2)
        RJ = FLOAT(J)
        CALL SYMBOL(XLIN1-4.4*CH,YLIN-0.6*CH,1.2*CH,'10',0.0, 2)
        CALL NUMBER(XLIN1-2.0*CH,YLIN-0.1*CH,1.0*CH,RJ  ,0.0,-1)
   55 CONTINUE
C
      CALL NEWPEN(3)
      XLAB = (FLOAT((I1+I2)/2) + 0.5 - RTLMIN) * SF - 1.0*CH
      YLAB = (FLOAT( J1      )       - WRLMIN) * SF - 3.7*CH
      CALL SYMBOL(XLAB       ,YLAB       ,1.7*CH,'R',0.0,1)
      CALL SYMBOL(XLAB+1.7*CH,YLAB-0.6*CH,1.2*CH,'0',0.0,1)
      CALL SYMBOL(XLAB+1.7*CH,YLAB-0.6*CH,1.2*CH,'-',0.0,1)
C
      CALL NEWPEN(3)
      XLAB = (FLOAT( I1      )       - RTLMIN) * SF - 7.2*CH
      YLAB = (FLOAT((J1+J2)/2) + 0.5 - WRLMIN) * SF - 0.9*CH
      CALL SYMBOL(XLAB       ,YLAB-0.4*CH,1.7*CH,'h'  ,0.0,1)
      CALL SYMBOL(XLAB+1.7*CH,YLAB       ,1.7*CH,'0/U',0.0,3)
      CALL SYMBOL(XLAB+1.7*CH,YLAB       ,1.7*CH,'-'  ,0.0,1)
C
      CALL NEWPEN(3)
      XLAB = 0.5*CH
      YLAB = (FLOAT(J2)-WRLMIN)*SF + 1.5*CH
      CALL SYMBOL(XLAB        ,YLAB-0.4*CH,2.2*CH,'j',0.0,1)
      IF(IPASS.EQ.1)
     &CALL SYMBOL(XLAB+ 1.8*CH,YLAB-0.4*CH,1.2*CH,'I',0.0,1)
      IF(IPASS.EQ.2)
     &CALL SYMBOL(XLAB+ 1.8*CH,YLAB-0.4*CH,1.2*CH,'R',0.0,1)
      CALL SYMBOL(XLAB+ 3.2*CH,YLAB       ,1.8*CH,'0',0.0,1)
      CALL SYMBOL(XLAB+ 3.2*CH,YLAB       ,1.8*CH,'-',0.0,1)
      CALL SYMBOL(XLAB+ 6.3*CH,YLAB,1.4*CH,'CONTOURS',0.0,8)
C
      XLAB = (FLOAT(I2)-RTLMIN)*SF - 10.0*1.5*CH
      CALL SYMBOL(XLAB       ,YLAB,1.5*CH,'H = ',0.0,4)
      CALL NUMBER(XLAB+6.0*CH,YLAB,1.5*CH, H    ,0.0,3)
C
      IF(IPASS.EQ.1) WRITE(6,*) 'ai limits:', AIMIN, AIMAX
      IF(IPASS.EQ.2) WRITE(6,*) 'ar limits:', ARMIN, ARMAX
C
      IF(.NOT.MANUAL) OPEN(19,FILE=FNAME,STATUS='OLD')
C
  800 CONTINUE
c
cc---- plot function grid
c      call newpen(1)
c      do 60 ir=1, nrp
c        call plot(x(ir,1),y(ir,1),3)
c        do 610 iw=2, nwp
c          call plot(x(ir,iw),y(ir,iw),2)
c  610   continue
c   60 continue
c      do 70 iw=1, nwp
c        call plot(x(1,iw),y(1,iw),3)
c        do 710 ir=2, nrp
c          call plot(x(ir,iw),y(ir,iw),2)
c  710   continue
c   70 continue
cc
c
      IF(MANUAL) THEN
       WRITE(6,*) ' '
       CALL ASK('Enter starting contour level^',3,ALOW)
       CALL ASK('Enter contour level increment (+/-)^',3,DA)
       CALL ASK('Enter contour line thickness (1-5)^',2,LPEN)
       CALL ASK('Add numerical labels to contours ?^',5,LABCON)
      ELSE
       READ(19,*,END=900) ALOW, DA, LPEN, LABCON
       IF(ALOW .EQ. 999.0) GO TO 900
      ENDIF
C
C
C**** plot and label contours
C
      CALL NEWPEN(LPEN)
C
C---- go over contour levels
      DO 80 IA = 0, 12345
C
C------ set contour level
        ACON = ALOW + DA*FLOAT(IA)
C
C
        IF(IPASS.EQ.1) THEN
C------- skip out if outside limits
         IF((DA.GT.0.0 .AND. ACON.GT.AIMAX) .OR. 
     &      (DA.LT.0.0 .AND. ACON.LT.AIMIN)      ) GO TO 81
C
         CALL CON1(NRX,NWX,NRP,NWP,X,Y,AI,ACON,1.0,1.0)
C
C------- draw label contours on bottom, right, and top edges
         IF(LABCON) THEN
          CALL CONLAB(NRX,NWX,NRP,NWP,X,Y,AI,ACON,1.0,1.0,CHL,3,1)
          CALL CONLAB(NRX,NWX,NRP,NWP,X,Y,AI,ACON,1.0,1.0,CHL,3,2)
          CALL CONLAB(NRX,NWX,NRP,NWP,X,Y,AI,ACON,1.0,1.0,CHL,3,3)
         ENDIF
        ELSE
C------- skip out if outside limits
         IF((DA.GT.0.0 .AND. ACON.GT.ARMAX) .OR. 
     &      (DA.LT.0.0 .AND. ACON.LT.ARMIN)      ) GO TO 81
C
         CALL CON1(NRX,NWX,NRP,NWP,X,Y,AR,ACON,1.0,1.0)
C
C------- draw label contours on bottom, right, and top edges
         IF(LABCON) THEN
          CALL CONLAB(NRX,NWX,NRP,NWP,X,Y,AR,ACON,1.0,1.0,CHL,3,1)
          CALL CONLAB(NRX,NWX,NRP,NWP,X,Y,AR,ACON,1.0,1.0,CHL,3,2)
          CALL CONLAB(NRX,NWX,NRP,NWP,X,Y,AR,ACON,1.0,1.0,CHL,3,3)
         ENDIF
        ENDIF
   80 CONTINUE
   81 CONTINUE
C
      IF(MANUAL) THEN
       CALL ASK('Add more contours ?^',5,YES)
       IF(YES) GO TO 800
      ELSE
       GO TO 800
      ENDIF
C
  900 IF(IPASS.LT.2) CALL PLOT((RTLMAX-RTLMIN)*SF+12.0*CH,0.0,-3)
C
 9000 CONTINUE
C
      IF(.NOT.MANUAL) THEN
       CLOSE(19)
       CALL ASK('Hit <cr>^',1,DUMMY)
      ENDIF
C
      CALL PLOT(0.0,0.0,+999)
C
      STOP
      END


      SUBROUTINE READIT(N,H,ETA,U,S,NRP,NWP,RTL,WSL,AR,AI,NRX,NWX)
      DIMENSION ETA(1), U(1), S(1)
      DIMENSION AR(NRX,NWX), AI(NRX,NWX)
      DIMENSION RTL(NRX), WSL(NWX)
      LOGICAL*1 FNAME(32)
C
      CALL ASK('Enter map filename^',4,FNAME)
      OPEN(9,FILE=FNAME,STATUS='OLD',FORM='UNFORMATTED')
C
      READ(9) N, H
      READ(9) (ETA(I),I=1, N)
      READ(9) (U(I)  ,I=1, N)
      READ(9) (S(I)  ,I=1, N)
      READ(9) NRP, NWP
      READ(9) (RTL(IR),IR=1,NRP)
      READ(9) (WSL(IW),IW=1,NWP)
C
      DO 10 IW=1, NWP
        READ(9,END=11) (AR(IR,IW),IR=1,NRP)
        READ(9,END=11) (AI(IR,IW),IR=1,NRP)
   10 CONTINUE
      CLOSE(9)
      GO TO 90
C
   11 CONTINUE
      CLOSE(9)
      IWLAST = IW-1
      WRITE(6,*) 'Map incomplete.'
      WRITE(6,*) 'Last complete frequency index:',IWLAST
C
   90 CONTINUE
      GEO = (ETA(3)-ETA(2)) / (ETA(2)-ETA(1))
C
      WRITE(6,1050) N, H, ETA(N), GEO
 1050 FORMAT(/' n =', I4,'   H =', F7.3,
     &                   '   Ye =', F7.3,
     &                   '   dYi+1/dYi =',F6.3 /)
C
      RETURN
      END

