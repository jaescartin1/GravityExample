  PROGRAM basic_algorithm

    use omp_lib
    
    implicit none
    double precision rij_2,rinvdenom,fix0,pmj
    double precision pi,desplx,desply,g,ugravfix0
    double precision fix,pmi,dmy,rrr,fgravmod,g2pi
    integer index,i,j
    integer,parameter::n1=32000
    double precision, dimension (n1,2):: a,f
    double precision, dimension(n1)::ap1,ap2,ap1_2,ap2_2
    double precision, dimension(n1)::ri_2,ap1p2,ap2p2,ugrav,masa
    double precision, dimension(10000):: gi1,gi2,gi3

    character*24             :: c_fdate
    character*10             :: compiler
    character*100            :: fileOut
    integer                  :: thread_num
    real*8                   :: wtime_ini,wtime_loop_ini, wtime,wtime_loop

      wtime_ini = omp_get_wtime()

!        ******** INTEGRALES CALCULO GRAVITATORIO **************
         open(33,file='../../../in/I1I2.txt')
         do i=1,10000
            read(33,*) dmy,gi1(i),gi2(i),gi3(i)
         enddo
         close(33)
!        ********************************************************
         open(5,file='../../../in/SunEvenSetmC_1.dat')

         call getenv("FC", compiler)
         write(fileOut, '(a,a,a)') '../../../out/SunGrav_OpenMP-fortran_Ruben_', TRIM(compiler), '.dat'
         open(7,file=fileOut)

         pi=dacos(-1.d0)
         g=6.67d-08
         g2pi=g/2.d0/pi
         desplx=0.d0
         desply=0.d0
         do i=1,n1
            read(5,*) dmy,a(i,1),a(i,2),masa(i),dmy,dmy,dmy
         enddo
         do i=1,n1
            f(i,1)=0.d0
            f(i,2)=0.d0
            ugrav(i)=0.d0
         enddo

    !$omp parallel private(i,j,rinvdenom,index,fix,pmi,pmj,ugravfix0)

         !$omp master
            thread_num = omp_get_num_threads()
         !$omp end master

         !$omp do schedule(static)
         do i=1,n1
            ap1(i)=a(i,1)-desplx
            ap2(i)=a(i,2)-desply
            ap1_2(i)=ap1(i)**2
            ap2_2(i)=ap2(i)**2
            ri_2(i)=ap1_2(i)+ap2_2(i)
            ap1p2(i)=20000.d0*ap1(i)
            ap2p2(i)=2.d0*ap2(i)
         enddo
         !$omp end do

         !$omp master
            wtime_loop_ini = omp_get_wtime()
         !$omp end master

         !$omp do schedule(static) reduction(+:f,ugrav)
         do i=1,n1-1 
            do j=i+1,n1
               ! calcula la gravedad particula a particula (en realizad anillo-anillo)
               if(i.ne.j .and. i.lt.j) then
                  rinvdenom=1.d0/(ri_2(i)+ri_2(j)-ap2p2(i)*ap2(j))
                  index=1+int(min(ap1p2(i)*ap1(j)*rinvdenom,9995.d0))
                  fix=rinvdenom*sqrt(rinvdenom)
                  pmj=masa(j)*fix
                  f(i,1)=f(i,1)+pmj*(ap1(j)*gi1(index)-ap1(i)*gi2(index))
                  f(i,2)=f(i,2)+pmj*(ap2(j)-ap2(i))*gi2(index)
                  pmi=masa(i)*fix
                  f(j,1)=f(j,1)+pmi*(ap1(i)*gi1(index)-ap1(j)*gi2(index))
                  f(j,2)=f(j,2)+pmi*(ap2(i)-ap2(j))*gi2(index)
                  ugravfix0=sqrt(rinvdenom)*gi3(index)
                  ugrav(i)=ugrav(i)+masa(j)*ugravfix0
                  ugrav(j)=ugrav(j)+masa(i)*ugravfix0
               endif
            enddo
         enddo
         !$omp end do

         !$omp master
            wtime_loop = omp_get_wtime() -wtime_loop_ini
         !$omp end master

         !$omp do schedule(static)
         do i=1,n1
            f(i,1)=-g2pi*f(i,1)
            f(i,2)=-g2pi*f(i,2)
            ugrav(i)=-g2pi*ugrav(i)
         enddo
         !$omp end do

    !$omp end parallel

         do i=1,n1
            rrr=dsqrt(a(i,1)**2+a(i,2)**2)
            fgravmod=dsqrt(f(i,1)**2+f(i,2)**2)
            write(7,56) rrr,fgravmod
         enddo
56       format(2x,e12.5,2x,e12.5)

      wtime = omp_get_wtime() -wtime_ini

      call fdate(c_fdate)
      open(unit=66,file='../../../out/times.dat',action='write',position='append')
      write(66, '(a,a,g14.6,g14.6,a,a,a,i8)' )   &
                'OpenMP_Fortran: Ruben    ',     &
                compiler,                        &
                wtime_loop,                      &
                wtime,                           &
                '   ', c_fdate,                  &
                '     NUM_THREADS:', thread_num
      close(66)
         stop
       end PROGRAM basic_algorithm

