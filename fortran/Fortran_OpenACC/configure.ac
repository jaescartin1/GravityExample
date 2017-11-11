AC_PREREQ(2.69)
AC_INIT([Fortran_OpenACC], [1.0], [ja.escartin@gmail.com])
AM_INIT_AUTOMAKE()
  
AC_LANG([Fortran]) 
AC_PROG_FC([gfortran ifort pgf90]) 

FCFLAGS="-fcheck=all"
if test $FC == "ifort"; then
  FCFLAGS="-check all"
elif test $FC == "pgf90"; then
  FCFLAGS=""
fi 

AC_CONFIG_FILES([ Makefile
                  src/Makefile
               ])

AC_OUTPUT
