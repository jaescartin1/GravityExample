AC_PREREQ(2.69)
AC_INIT([C++_OpenMP], [1.0], [ja.escartin@gmail.com])
AM_INIT_AUTOMAKE()
  
AC_LANG([C++])
AC_PROG_CXX([g++ pgc++])

AC_SUBST([AM_CXXFLAGS], [-m64])
#AX_CXX_COMPILE_STDCXX_17

CXXFLAGS="$CXXFLAGS -std=c++0x"

AC_OPENMP
CXXFLAGS="$CXXFLAGS $OPENMP_CXXFLAGS -fopenmp -lgomp"

AC_CONFIG_FILES([ Makefile
                  src/Makefile
               ])

AC_OUTPUT
