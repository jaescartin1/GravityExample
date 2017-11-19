program basicAlgorithm

    use omp_lib
    
      implicit none

      integer, parameter       :: n          =  10000
      real*8,  parameter       :: nLim       =  9995.d0
      real*8                   :: dummy
      real*8,  dimension(n)    :: gi1,gi2,gi3

      integer, parameter       :: n1         =  32000
      real*8,  dimension(n1)   :: rrr,fgravmod

      real*8,  dimension(n1)   :: fx         =  0.d0
      real*8,  dimension(n1)   :: fy         =  0.d0
      real*8,  dimension(n1)   :: ugrav      =  0.d0
      !dir$ attributes align : 64 :: fx,fy,ugrav

      real*8,  dimension(n1,2) :: a
      real*8,  parameter       :: desplx     = 0.d0
      real*8,  parameter       :: desply     = 0.d0

      real*8,  dimension(n1)   :: ap1,ap2, ap1_2,ap2_2, ap1p2,ap2p2
      real*8,  dimension(n1)   :: ri_2,masa

      integer                  :: i,j
      real*8                   :: rinvDen
      integer                  :: ind
      real*8                   :: aux0,aux

      real*8,  parameter       :: gDiv2DivPI = -1.06156347e-8

      character*24             :: c_fdate
      character*10             :: compiler
      character*100            :: fileOut

      integer                  :: cr, cm, timer1, timer2
      integer                  :: wtime_ini, wtime_loop_ini, wtime,wtime_loop
      real*8                   :: rate

      call system_clock(count_rate=cr)
      call system_clock(count_max=cm)
      rate = REAL(cr)

      call system_clock(wtime_ini)


      ! Integrales calculo gravitatorio
      open(33,file='../../../in/I1I2.txt')
      do i=1,n
        read(33,*) dummy,gi1(i),gi2(i),gi3(i)
      enddo
      close(33)

      open(44,file='../../../in/SunEvenSetmC_1.dat')
      do i=1,n1
        read(44,*) dummy,a(i,1),a(i,2),masa(i),dummy,dummy,dummy
      enddo
      close(44)


      do i=1,n1

        ap1(i)   = a(i,1) -desplx
        ap2(i)   = a(i,2) -desply

        ap1_2(i) = ap1(i)**2
        ap2_2(i) = ap2(i)**2
        ri_2(i)  = ap1_2(i) +ap2_2(i)

        ap1p2(i) = 2.d0 *ap1(i) *n
        ap2p2(i) = 2.d0 *ap2(i)

      enddo


      call system_clock(wtime_loop_ini)


      !Calcula la gravedad particula a particula (en realidad anillo-anillo)
      do i=1,n1-1
        do j=i+1,n1

          rinvDen  = 1.d0/( ri_2(i) +ri_2(j) -ap2p2(i)*ap2(j) )
          ind      = 1 +int( min( ap1p2(i)*ap1(j)*rinvDen, nLim ) )

          aux0     = sqrt(rinvDen)
          aux      = rinvDen *aux0

          fx(i)     = fx(i)    +masa(j) *aux            *( ap1(j)*gi1(ind) -ap1(i)*gi2(ind) )
          fx(j)     = fx(j)    +masa(i) *aux            *( ap1(i)*gi1(ind) -ap1(j)*gi2(ind) )

          fy(i)     = fy(i)    +masa(j) *aux  *gi2(ind) *( ap2(j)          -ap2(i)          )
          fy(j)     = fy(j)    +masa(i) *aux  *gi2(ind) *( ap2(i)          -ap2(j)          )

          ugrav(i)  = ugrav(i) +masa(j) *aux0 *gi3(ind)
          ugrav(j)  = ugrav(j) +masa(i) *aux0 *gi3(ind)

        enddo
      enddo

      call system_clock(timer1)
      wtime_loop = timer1 -wtime_loop_ini

      do i=1,n1
 
        fx(i)       = gDiv2DivPI *fx(i)
        fy(i)       = gDiv2DivPI *fy(i)
 
        ugrav(i)    = gDiv2DivPI *ugrav(i)
 
        rrr(i)      = dsqrt( a(i,1)**2 +a(i,2)**2 )
        fgravmod(i) = dsqrt( fx(i)**2  +fy(i)**2  )
 
      enddo

      call getenv("FC", compiler)

56	  format(2x,e12.5,2x,e12.5)
      write(fileOut, '(a,a,a)') '../../../out/SunGrav_CUDA-fortran_', TRIM(compiler), '.dat'
      open(55,file=fileOut)
      do i=1,n1
        write(55,56) rrr(i),fgravmod(i)
      enddo
      close(55)

      call system_clock(timer2)
      wtime = timer2 -wtime_ini
      
      open(unit=66,file='../../../out/times.dat',action='write',position='append')

      call fdate(c_fdate)

      write(66, '(a,a,g14.6,g14.6,a,a)' )    &
                'CUDA_Fortran             ', &
                compiler,                    &
                real(wtime_loop) / rate,     &
                real(wtime     ) / rate,     &
                '   ', c_fdate
      close(66)
 
      stop

end program basicAlgorithm
