AC_PREREQ(2.69)
AC_INIT([Fortran_OpenMP], [1.0], [ja.escartin@gmail.com])
AM_INIT_AUTOMAKE()
  
AC_LANG([Fortran]) 
AC_PROG_FC([gfortran ifort pgf90]) 
AC_OPENMP

FCFLAGS="$OPENMP_FCFLAGS -fcheck=all"
if test $FC == "ifort"; then
  FCFLAGS="$OPENMP_FCFLAGS -openmp -check all"
elif test $FC == "pgf90"; then
  FCFLAGS="$OPENMP_FCFLAGS"
fi 

AC_CONFIG_FILES([ Makefile
                  src/Makefile
               ])

AC_OUTPUT
