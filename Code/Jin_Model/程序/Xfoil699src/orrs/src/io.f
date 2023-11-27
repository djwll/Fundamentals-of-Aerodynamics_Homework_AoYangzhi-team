
      SUBROUTINE READOS(FLIST,IFORM,
     &                  N,NMAX,ETA,U,S,
     &                  NRP,NWP,NHP,
     &                  RTL,WSL,HH , AR,AI,
     &                  NRX,NWX,NHX)
C----------------------------------------------------------------
C     Reads Orr-Sommerfeld data files in binary or ascii format.
C     Data is spatial amplification complex wavenumber
C           ar(Re,w,H)  ai(Re,w,H)
C     stored on a R,W,H grid
C           R = ln(Re)
C           W = ln(w) - 0.5 ln(Re)
C           H = H
C
C     Input
C       FLIST   name of text file containing file prefixes to be read
C       IFORM   -1=unknown
C                0=binary
C                1=ascii
C
C     Output
C       N(h)      number of points across BL,  i=1..N
C       NMAX      max dimension of N
C       ETA(i,h)  BL y coordinate
C       U(i,h)    velocity profile
C       S(i,h)    shear profile dU/deta
C       NRP(h)    number of RTL values, r=1..NRP
C       NWP(h)    number of WSL values, w=1..NWP
C       NHP       number of H   values, h=1..NHP
C       RTL(r,h)  R  values
C       WSL(w,h)  W  values
C       HH(h)     H  values
C       AR(r,w,h) real wavenumber
C       AI(r,w,h) imaginary wavenumber
C
C----------------------------------------------------------------
      CHARACTER*(*) FLIST
      DIMENSION N(NHX), NRP(NHX),NWP(NHX)
      DIMENSION ETA(NMAX,NHX), U(NMAX,NHX), S(NMAX,NHX)
      DIMENSION AR(NRX,NWX,NHX),AI(NRX,NWX,NHX)
      DIMENSION RTL(NRX,NHX), WSL(NWX,NHX), HH(NHX)
      CHARACTER*80 FNAME
C
      OPEN(10,FILE=FLIST,STATUS='OLD')
C
      WRITE(*,*) 'Reading...'
      DO 1000 IH=1, NHX
 5      READ(10,5000,END=1001) FNAME
 5000   FORMAT(A)
C
C------ skip comment line
        IF(INDEX('#!',FNAME(1:1)) .NE. 0) GO TO 5
C
C------ strip off leading blanks
 10     CONTINUE
        IF(FNAME(1:1).EQ.' ') THEN
         FNAME = FNAME(2:80)
         GO TO 10
        ENDIF
C
        IF(IFORM.LE.-1) THEN
C------- first assume it's an ascii file
         KFORM = 1
C
C------- try reading it as a binary
         OPEN(9,FILE=FNAME,STATUS='OLD',FORM='UNFORMATTED',ERR=1001)
         READ(9,ERR=11) NTEST, HTEST
C
         IF(NTEST.GE.1 .AND. NTEST.LE.NMAX) THEN
C-------- point index within bounds... looks like it's binary
          KFORM = 0
         ENDIF
C
 11      CLOSE(9)
C
        ELSE
         KFORM = IFORM
C
        ENDIF
C
C
        K = INDEX(FNAME,' ') - 1
C
        IF(KFORM.EQ.0) THEN
C------- binary format
         FNAME = FNAME(1:K)
         WRITE(*,*) FNAME, '   binary'
C
         OPEN(9,FILE=FNAME,STATUS='OLD',FORM='UNFORMATTED',ERR=1001)
         READ(9,ERR=1001) N(IH), HH(IH)
         READ(9) (ETA(I,IH),I=1, N(IH))
         READ(9) (U(I,IH)  ,I=1, N(IH))
         READ(9) (S(I,IH)  ,I=1, N(IH))
         READ(9) NRP(IH), NWP(IH)
         READ(9) (RTL(IR,IH),IR=1,NRP(IH))
         READ(9) (WSL(IW,IH),IW=1,NWP(IH))
C
         DO IW=1, NWP(IH)
           READ(9,END=15) (AR(IR,IW,IH),IR=1,NRP(IH))
           READ(9,END=15) (AI(IR,IW,IH),IR=1,NRP(IH))
         ENDDO
         GO TO 30
C
 15      CONTINUE
         IWLAST = IW-1
         WRITE(*,*) 
     &       'Map incomplete.  Last complete frequency index:',IWLAST
C
        ELSE
C------- ascii format
         FNAME = FNAME(1:K)
         WRITE(*,*) FNAME, '   ascii'
C
         OPEN(9,FILE=FNAME,STATUS='OLD')
         READ(9,*) N(IH), HH(IH)
         READ(9,*) (ETA(I,IH),I=1, N(IH))
         READ(9,*) (U(I,IH)  ,I=1, N(IH))
         READ(9,*) (S(I,IH)  ,I=1, N(IH))
         READ(9,*) NRP(IH), NWP(IH)
         READ(9,*) (RTL(IR,IH),IR=1,NRP(IH))
         READ(9,*) (WSL(IW,IH),IW=1,NWP(IH))
C
         DO IW=1, NWP(IH)
           READ(9,*) (AR(IR,IW,IH),IR=1,NRP(IH))
           READ(9,*) (AI(IR,IW,IH),IR=1,NRP(IH))
         ENDDO
        ENDIF
C
 30     CONTINUE
        CLOSE(9)
        GEO = (ETA(3,IH)-ETA(2,IH)) / (ETA(2,IH)-ETA(1,IH))
        WRITE(*,2050) N(IH), HH(IH), ETA(N(IH),IH), GEO
 2050   FORMAT(' n =', I4,'   H =', F7.3,
     &                    '   Ye =', F7.3,
     &                    '   dYi+1/dYi =',F6.3 /)
C
        IFORM = 1
 1000 CONTINUE
      IH = NHX + 1
C
 1001 NHP = IH-1
      CLOSE(10)
      CLOSE(9)
C
C---- re-order if needed to make RTL and WSL monotonically increasing
      DO 40 IH=1, NHP
        IF(RTL(1,IH) .GT. RTL(NRP(IH),IH)) THEN
         DO IR=1, NRP(IH)/2
           IRBACK = NRP(IH)-IR+1
C
           RTEMP = RTL(IR,IH)
           RTL(IR,IH) = RTL(IRBACK,IH)
           RTL(IRBACK,IH) = RTEMP
C
           DO IW=1, NWP(IH)
             ARTEMP = AR(IR,IW,IH)
             AITEMP = AI(IR,IW,IH)
             AR(IR,IW,IH) = AR(IRBACK,IW,IH)
             AI(IR,IW,IH) = AI(IRBACK,IW,IH)
             AR(IRBACK,IW,IH) = ARTEMP
             AI(IRBACK,IW,IH) = AITEMP
           ENDDO
         ENDDO
        ENDIF
C
        IF(WSL(1,IH) .GT. WSL(NWP(IH),IH)) THEN
         DO IW=1, NWP(IH)/2
           IWBACK = NWP(IH)-IW+1
C
           WTEMP = WSL(IW,IH)
           WSL(IW,IH) = WSL(IWBACK,IH)
           WSL(IWBACK,IH) = WTEMP
C
           DO IR=1, NRP(IH)
             ARTEMP = AR(IR,IW,IH)
             AITEMP = AI(IR,IW,IH)
             AR(IR,IW,IH) = AR(IR,IWBACK,IH)
             AI(IR,IW,IH) = AI(IR,IWBACK,IH)
             AR(IR,IWBACK,IH) = ARTEMP
             AI(IR,IWBACK,IH) = AITEMP
           ENDDO
         ENDDO
C
        ENDIF
   40 CONTINUE
C
      RETURN
      END ! READOS



      SUBROUTINE WRITOS(FLIST,IFORM,
     &                  N,NMAX,ETA,U,S,
     &                  NRP,NWP,NHP,
     &                  RTL,WSL,HH , AR,AI,
     &                  NRX,NWX,NHX)
C----------------------------------------------------------------
C     Writes Orr-Sommerfeld data files in binary or ascii format.
C     Data is spatial amplification complex wavenumber
C           ar(Re,w,H)  ai(Re,w,H)
C     stored on a R,W,H grid
C           R = ln(Re)
C           W = ln(w) - 0.5 ln(Re)
C           H = H
C
C     Input
C       FLIST   name of text file containing file prefixes to be read
C       IFORM  0=binary, ascii otherwise
C       N(h)      number of points across BL,  i=1..N
C       NMAX      max dimension of N
C       ETA(i,h)  BL y coordinate
C       U(i,h)    velocity profile
C       S(i,h)    shear profile dU/deta
C       NRP(h)    number of RTL values, r=1..NRP
C       NWP(h)    number of WSL values, w=1..NWP
C       NHP       number of H   values, h=1..NHP
C       RTL(r,h)  R  values
C       WSL(w,h)  W  values
C       HH(h)     H  values
C       AR(r,w,h) real wavenumber
C       AI(r,w,h) imaginary wavenumber
C
C     Output
C       written files
C
C----------------------------------------------------------------
C
      CHARACTER*(*) FLIST
      DIMENSION N(NHX), NRP(NHX),NWP(NHX)
      DIMENSION ETA(NMAX,NHX), U(NMAX,NHX), S(NMAX,NHX)
      DIMENSION AR(NRX,NWX,NHX),AI(NRX,NWX,NHX)
      DIMENSION RTL(NRX,NHX), WSL(NWX,NHX), HH(NHX)
      CHARACTER*80 FNAME
C
      OPEN(10,FILE=FLIST,STATUS='OLD')
C
      WRITE(*,*) 'Writing...'
      DO 1000 IH=1, NHX
 5      READ(10,5000,END=1001) FNAME
 5000   FORMAT(A)
C
C------ skip comment line
        IF(INDEX('#!',FNAME(1:1)) .NE. 0) GO TO 5
C
C------ strip off leading blanks
 10     CONTINUE
        IF(FNAME(1:1).EQ.' ') THEN
         FNAME = FNAME(2:80)
         GO TO 10
        ENDIF
C
        K = INDEX(FNAME,' ') - 1
C
        IF(IFORM.EQ.0) THEN
         FNAME = FNAME(1:K) // '.bin'
         WRITE(*,*) FNAME
C
         OPEN(9,FILE=FNAME,STATUS='UNKNOWN',FORM='UNFORMATTED',ERR=1001)
         REWIND(9)
         WRITE(9,ERR=1001) N(IH), HH(IH)
         WRITE(9) (ETA(I,IH),I=1, N(IH))
         WRITE(9) (U(I,IH)  ,I=1, N(IH))
         WRITE(9) (S(I,IH)  ,I=1, N(IH))
         WRITE(9) NRP(IH), NWP(IH)
         WRITE(9) (RTL(IR,IH),IR=1,NRP(IH))
         WRITE(9) (WSL(IW,IH),IW=1,NWP(IH))
C
         DO IW=1, NWP(IH)
           WRITE(9) (AR(IR,IW,IH),IR=1,NRP(IH))
           WRITE(9) (AI(IR,IW,IH),IR=1,NRP(IH))
         ENDDO
C
        ELSE
         FNAME = FNAME(1:K)
         WRITE(*,*) FNAME
C
         OPEN(9,FILE=FNAME,STATUS='UNKNOWN')
         REWIND(9)
         WRITE(9,*) N(IH), HH(IH)
         WRITE(9,*) (ETA(I,IH),I=1, N(IH))
         WRITE(9,*) (U(I,IH)  ,I=1, N(IH))
         WRITE(9,*) (S(I,IH)  ,I=1, N(IH))
         WRITE(9,*) NRP(IH), NWP(IH)
         WRITE(9,*) (RTL(IR,IH),IR=1,NRP(IH))
         WRITE(9,*) (WSL(IW,IH),IW=1,NWP(IH))
C
         DO IW=1, NWP(IH)
           WRITE(9,*) (AR(IR,IW,IH),IR=1,NRP(IH))
           WRITE(9,*) (AI(IR,IW,IH),IR=1,NRP(IH))
         ENDDO
        ENDIF
C
        CLOSE(9)
 1000 CONTINUE
      IH = NHX + 1
C
 1001 NHP = IH-1
      CLOSE(10)
      CLOSE(9)
C
      RETURN
      END ! WRITOS




