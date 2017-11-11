# ============================================================================
# Name        : Makefile
# Author      : Jose Antonio Escartin
# Version     : 1.0
# Description : Execute the code with different compilers
# ============================================================================

.PHONY: all clean exec compare

all:
	make clean
	make exec
#	make compare

exec:
	#./execWithCompiler.sh F77_COMPILER FC_COMPILER CXX_COMPILER WORK_DIR
	
	./execWithCompiler.sh "C++/C++_Serial"          "pgf77"    "pgf90"    "g++"
	./execWithCompiler.sh "C++/C++_Serial"          "pgf77"    "pgf90"    "pgc++"                
	
	./execWithCompiler.sh "C++/C++_OpenMP"          "pgf77"    "pgf90"    "g++"                  
	./execWithCompiler.sh "C++/C++_OpenMP"          "pgf77"    "pgf90"    "pgc++"                
	
	./execWithCompiler.sh "C++/C++_OpenACC"         "pgf77"    "pgf90"    "g++"                  
	./execWithCompiler.sh "C++/C++_OpenACC"         "pgf77"    "pgf90"    "pgc++"                
	
	./execWithCompiler.sh "C++/C++_CUDA"            "pgf77"    "pgf90"    "g++"                  
	./execWithCompiler.sh "C++/C++_CUDA"            "pgf77"    "pgf90"    "pgc++"
	
	./execWithCompiler.sh "fortran/Fortran_Serial"  "gfortran" "gfortran" "pgc++"
	./execWithCompiler.sh "fortran/Fortran_Serial"  "ifort"    "ifort"    "pgc++"
	./execWithCompiler.sh "fortran/Fortran_Serial"  "pgf77"    "pgf90"    "pgc++"
	
	./execWithCompiler.sh "fortran/Fortran_OpenMP"  "gfortran" "gfortran" "pgc++"              
	./execWithCompiler.sh "fortran/Fortran_OpenMP"  "ifort"    "ifort"    "pgc++"
	./execWithCompiler.sh "fortran/Fortran_OpenMP"  "pgf77"    "pgf90"    "pgc++"
	
	./execWithCompiler.sh "fortran/Fortran_OpenACC" "gfortran" "gfortran" "pgc++"              
#	./execWithCompiler.sh "fortran/Fortran_OpenACC" "ifort"    "ifort"    "pgc++"
	./execWithCompiler.sh "fortran/Fortran_OpenACC" "pgf77"    "pgf90"    "pgc++"
	
	./execWithCompiler.sh "fortran/Fortran_CUDA"    "gfortran" "gfortran" "pgc++"              
#	./execWithCompiler.sh "fortran/Fortran_CUDA"    "ifort"    "ifort"    "pgc++"
	./execWithCompiler.sh "fortran/Fortran_CUDA"    "pgf77"    "pgf90"    "pgc++"

compare:

	diff out_ref/SunGrav_1.dat out/SunGrav_Serial-c++.dat
	
	diff out_ref/SunGrav_1.dat out/SunGrav_OpenMP-c++.dat
	
	diff out_ref/SunGrav_1.dat out/SunGrav_OpenACC-c++.dat
	
	diff out_ref/SunGrav_1.dat out/SunGrav_CUDA-c++.dat
	
	diff out_ref/SunGrav_1.dat out/SunGrav_Serial-fortran_f90.dat
	diff out_ref/SunGrav_1.dat out/SunGrav_Serial-fortran_Domingo.dat
	
	diff out_ref/SunGrav_1.dat out/SunGrav_OpenMP-fortran_Josan.dat
	diff out_ref/SunGrav_1.dat out/SunGrav_OpenMP-fortran_Ruben.dat

	diff out_ref/SunGrav_1.dat out/SunGrav_OpenACC-fortran.dat
	
	diff out_ref/SunGrav_1.dat out/SunGrav_CUDA-fortran.dat

clean:
	rm -f out/*.dat
	
	echo " VERSION               | COMPILER   | LOOP (s)    | TIME (s)    | DATE/TIME                 || NOTES\n ===================================================================================================================" > out/times.dat	
      
