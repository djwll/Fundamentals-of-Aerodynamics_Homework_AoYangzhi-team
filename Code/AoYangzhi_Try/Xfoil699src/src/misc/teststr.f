      character*40 line, tline
    1 format(a)
   10 read(*,1) line
      call trimblanks(line,tline)
      write(*,*) line,tline
      go to 10
      end

      subroutine trimblanks(instr,outstr)
C---remove blanks from string
      character ch*1, instr*(*), outstr*(*)
      outstr = ' '
      do j=1, len_trim(instr)
C    get j-th char
       ch = instr(j:j)
       if (ch .ne. " ") then
         outstr = trim(outstr) // ch
       endif
      end do
      return
      end
