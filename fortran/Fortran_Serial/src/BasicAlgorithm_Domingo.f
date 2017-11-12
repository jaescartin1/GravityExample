         implicit none

         character*24  c_fdate
         character*10  compiler
         character*100 fileOut

         character*10  compiler_trim
         integer       ii

c        For receiving total time
         real*8 wtime_ini, wtime_loop_ini, wtime, wtime_loop
c        For receiving usera and system time
         real elapsed
         dimension elapsed(2)
c        Declare the type of etime()
         real etime


         real*8 f,ugrav,ap1,ap2,a,ap1_2,ap2_2,ri_2,ap1p2,ap2p2
         real*8 rij_2,rdenom,rinvdenom,tp,ti1,ti2,ti3,fix0,pmj,masa
         real*8 fjix,fjiy,pi,gi1,gi2,gi3,desplx,desply,g,ti1i2
         real*8 fix,pmi,fijx,fijy,dmy,rrr,fgravmod,g2pi
         integer index,i,j,n1

         parameter(n1=32000)

         dimension a(n1,2),f(n1,2),ap1(n1),ap2(n1),ap1_2(n1),ap2_2(n1)
         dimension ri_2(n1),ap1p2(n1),ap2p2(n1),ugrav(n1),masa(n1)

      common/grav/ti1i2(10000),gi1(10000),gi2(10000),gi3(10000)


         wtime_ini = etime(elapsed)


c        ******** INTEGRALES CALCULO GRAVITATORIO **************
         open(33,file='../../../in/I1I2.txt')
         call gravity
c        ********************************************************
            close(33)

            open(5,file='../../../in/SunEvenSetmC_1.dat')
            pi=dacos(-1.d0)
            g=6.67d-08
            g2pi=g/2.d0/pi
            desplx=0.d0
            desply=0.d0
         do i=1,n1
          read(5,*) dmy,a(i,1),a(i,2),masa(i),dmy,dmy,dmy
         enddo
         do i=1,n1
            f(i,1)=0.
            f(i,2)=0.
            ugrav(i)=0.
         enddo
           do i=1,n1
          ap1(i)=a(i,1)-desplx
          ap2(i)=a(i,2)-desply
          ap1_2(i)=ap1(i)**2
          ap2_2(i)=ap2(i)**2
          ri_2(i)=ap1_2(i)+ap2_2(i)
          ap1p2(i)=2.d0*ap1(i)
          ap2p2(i)=2.d0*ap2(i)
          enddo


        wtime_loop_ini = etime(elapsed)


        do i=1,n1-1 
        do j=i+1,n1
c     calcula la gravedad particula a particula (anillo a anillo)
         if(i.ne.j .and. i.lt.j) then
        rij_2=ri_2(i)+ap2_2(j)-ap2p2(i)*ap2(j)
         rdenom=ap1_2(j)+rij_2
            rinvdenom=1.d0/rdenom
          tp=ap1p2(i)*ap1(j)*rinvdenom
          if(tp.ge.0.9995) tp=0.9995
              index=1+int(tp*10000)
            ti1=gi1(index)
            ti2=gi2(index)
            ti3=gi3(index)
            fix0=dsqrt(rinvdenom)
            fix=rinvdenom*fix0
             pmj=masa(j)*fix
             fjix=ap1(j)*ti1-ap1(i)*ti2
             fjiy=(ap2(j)-ap2(i))*ti2
           f(i,1)=f(i,1)+pmj*fjix
           f(i,2)=f(i,2)+pmj*fjiy
             fix0=fix0*ti3
           ugrav(i)=ugrav(i)+masa(j)*fix0
             pmi=masa(i)*fix
           fijx=ap1(i)*ti1-ap1(j)*ti2
           fijy=(ap2(i)-ap2(j))*ti2
           f(j,1)=f(j,1)+pmi*fijx
           f(j,2)=f(j,2)+pmi*fijy
           ugrav(j)=ugrav(j)+masa(i)*fix0
          endif
         enddo
        enddo

        wtime_loop = etime(elapsed) -wtime_loop_ini

          do i=1,n1
            f(i,1)=-g2pi*f(i,1)
            f(i,2)=-g2pi*f(i,2)
            ugrav(i)=-g2pi*ugrav(i)
          enddo

       call getenv("F77", compiler)

       ii = len(compiler)
       do while (compiler(ii:ii) .eq. ' ')
          ii = ii - 1
       end do

56     format(2x,e12.5,2x,e12.5)
       write(fileOut, '(a,a,a)')
     1                '../../../out/SunGrav_Serial-fortran_Domingo_',
     2                compiler(1:ii),
     3                '.dat'
       open(55,file=fileOut)

          do i=1,n1
            rrr=dsqrt(a(i,1)**2+a(i,2)**2)
            fgravmod=dsqrt(f(i,1)**2+f(i,2)**2)
            write(55,56) rrr,fgravmod
          enddo
          close(55)

          wtime = etime(elapsed) -wtime_ini

       open(UNIT=66, FILE='../../../out/times.dat', ACCESS='append')

       call fdate(c_fdate)

       write(66, '(a,a,g14.6,g14.6,a,a)' )
     1           'Fortran_Serial: Domingo  ',
     2           compiler,
     3           wtime_loop,
     4           wtime,
     5           '   ', c_fdate
       close(66)

          stop
      end

      subroutine gravity
          real*8 tp,gi1,gi2,gi3
          integer i
          common/grav/tp(10000),gi1(10000),gi2(10000),gi3(10000)
          do i=1,10000
            read(33,*) tp(i),gi1(i),gi2(i),gi3(i)
          enddo
          return
      end
