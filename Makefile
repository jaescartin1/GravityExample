# ============================================================================
# Name        : Makefile
# Author      : Jose Antonio Escartin
# Version     : 1.0
# Description : Execute the code with different compilers and check results
# ============================================================================

.PHONY: all clean exec compare regression

all:
	make clean
	make exec
	make compare
	make regression

clean:
	rm -f out/*.dat
	
exec:
	# $ ./execWithCompiler.sh F77_COMPILER FC_COMPILER CXX_COMPILER WORK_DIR

	make clean

	echo " VERSION               | COMPILER   | LOOP (s)    | TIME (s)    | DATE/TIME                 || NOTES\n ===================================================================================================================" > out/times.dat	

	./execWithCompiler.sh "fortran/Fortran_Serial"  "gfortran" "gfortran" "pgc++"
	./execWithCompiler.sh "fortran/Fortran_Serial"  "ifort"    "ifort"    "pgc++"
	./execWithCompiler.sh "fortran/Fortran_Serial"  "pgf77"    "pgf90"    "pgc++"
	./execWithCompiler.sh "C++/C++_Serial"          "pgf77"    "pgf90"    "g++"
	./execWithCompiler.sh "C++/C++_Serial"          "pgf77"    "pgf90"    "pgc++"                
	
	./execWithCompiler.sh "fortran/Fortran_OpenMP"  "gfortran" "gfortran" "pgc++"              
	./execWithCompiler.sh "fortran/Fortran_OpenMP"  "ifort"    "ifort"    "pgc++"
	./execWithCompiler.sh "fortran/Fortran_OpenMP"  "pgf77"    "pgf90"    "pgc++"
	./execWithCompiler.sh "C++/C++_OpenMP"          "pgf77"    "pgf90"    "g++"                  
	./execWithCompiler.sh "C++/C++_OpenMP"          "pgf77"    "pgf90"    "pgc++"                
	
	./execWithCompiler.sh "fortran/Fortran_OpenACC" "gfortran" "gfortran" "pgc++"              
##	./execWithCompiler.sh "fortran/Fortran_OpenACC" "ifort"    "ifort"    "pgc++"
	./execWithCompiler.sh "fortran/Fortran_OpenACC" "pgf77"    "pgf90"    "pgc++"
	./execWithCompiler.sh "C++/C++_OpenACC"         "pgf77"    "pgf90"    "g++"                  
	./execWithCompiler.sh "C++/C++_OpenACC"         "pgf77"    "pgf90"    "pgc++"                
	
	./execWithCompiler.sh "fortran/Fortran_CUDA"    "gfortran" "gfortran" "pgc++"              
##	./execWithCompiler.sh "fortran/Fortran_CUDA"    "ifort"    "ifort"    "pgc++"
	./execWithCompiler.sh "fortran/Fortran_CUDA"    "pgf77"    "pgf90"    "pgc++"
	./execWithCompiler.sh "C++/C++_CUDA"            "pgf77"    "pgf90"    "g++"                  
	./execWithCompiler.sh "C++/C++_CUDA"            "pgf77"    "pgf90"    "pgc++"

compare:
	# $ ./diffBetween2Files.py delta file1 file2

	./diffBetween2Files.py 1.e-4 out_ref/SunGrav_1_Domingo.dat    out/SunGrav_Serial-fortran_Domingo_gfortran.dat
	./diffBetween2Files.py 1.e-4 out_ref/SunGrav_1_Domingo.dat    out/SunGrav_Serial-fortran_Domingo_ifort.dat
	./diffBetween2Files.py 1.e-4 out_ref/SunGrav_1_Domingo.dat    out/SunGrav_Serial-fortran_Domingo_pgf77.dat
	./diffBetween2Files.py 1.e-4 out_ref/SunGrav_1_Ruben.dat      out/SunGrav_Serial-fortran_f90_gfortran.dat
	./diffBetween2Files.py 1.e-4 out_ref/SunGrav_1_Ruben.dat      out/SunGrav_Serial-fortran_f90_ifort.dat
	./diffBetween2Files.py 1.e-4 out_ref/SunGrav_1_Ruben.dat      out/SunGrav_Serial-fortran_f90_pgf90.dat
	./diffBetween2Files.py 2.e-2 out_ref/SunGrav_1_Ruben.dat      out/SunGrav_Serial-c++_g++.dat
	./diffBetween2Files.py 2.e-2 out_ref/SunGrav_1_Ruben.dat      out/SunGrav_Serial-c++_pgc++.dat
	
	./diffBetween2Files.py 1.e-2 out_ref/SunGrav_1_Domingo.dat    out/SunGrav_OpenMP-fortran_Ruben_gfortran.dat
	./diffBetween2Files.py 1.e-2 out_ref/SunGrav_1_Domingo.dat    out/SunGrav_OpenMP-fortran_Ruben_ifort.dat
	./diffBetween2Files.py 1.e-2 out_ref/SunGrav_1_Domingo.dat    out/SunGrav_OpenMP-fortran_Ruben_pgf90.dat
	./diffBetween2Files.py 1.e-4 out_ref/SunGrav_1_Ruben.dat      out/SunGrav_OpenMP-fortran_Josan_ifort.dat
	./diffBetween2Files.py 1.e-4 out_ref/SunGrav_1_Ruben.dat      out/SunGrav_OpenMP-fortran_Josan_pgf90.dat
	./diffBetween2Files.py 2.e-2 out_ref/SunGrav_1_Ruben.dat      out/SunGrav_OpenMP-c++_g++.dat
	./diffBetween2Files.py 2.e-2 out_ref/SunGrav_1_Ruben.dat      out/SunGrav_OpenMP-c++_pgc++.dat

	./diffBetween2Files.py 1.e-4 out_ref/SunGrav_1_Ruben.dat      out/SunGrav_OpenACC-fortran_gfortran.dat
##	./diffBetween2Files.py 1.e-4 out_ref/SunGrav_1_Ruben.dat      out/SunGrav_OpenACC-fortran_ifort.dat
	./diffBetween2Files.py 1.e-4 out_ref/SunGrav_1_Ruben.dat      out/SunGrav_OpenACC-fortran_pgf90.dat
	./diffBetween2Files.py 2.e-2 out_ref/SunGrav_1_Ruben.dat      out/SunGrav_OpenACC-c++_g++.dat
	./diffBetween2Files.py 2.e-2 out_ref/SunGrav_1_Ruben.dat      out/SunGrav_OpenACC-c++_pgc++.dat
	
	./diffBetween2Files.py 1.e-4 out_ref/SunGrav_1_Ruben.dat      out/SunGrav_CUDA-fortran_gfortran.dat
##	./diffBetween2Files.py 1.e-4 out_ref/SunGrav_1_Ruben.dat      out/SunGrav_CUDA-fortran_ifort.dat
	./diffBetween2Files.py 1.e-4 out_ref/SunGrav_1_Ruben.dat      out/SunGrav_CUDA-fortran_pgf90.dat	
	./diffBetween2Files.py 2.e-2 out_ref/SunGrav_1_Ruben.dat      out/SunGrav_CUDA-c++_g++.dat
	./diffBetween2Files.py 2.e-2 out_ref/SunGrav_1_Ruben.dat      out/SunGrav_CUDA-c++_pgc++.dat
	
regression:
	# $ diff new.dat gold.dat

	diff out/SunGrav_Serial-fortran_Domingo_gfortran.dat          out_gold/SunGrav_Serial-fortran_Domingo_gfortran.dat
	diff out/SunGrav_Serial-fortran_Domingo_ifort.dat             out_gold/SunGrav_Serial-fortran_Domingo_ifort.dat
	diff out/SunGrav_Serial-fortran_Domingo_pgf77.dat             out_gold/SunGrav_Serial-fortran_Domingo_pgf77.dat
	diff out/SunGrav_Serial-fortran_f90_gfortran.dat              out_gold/SunGrav_Serial-fortran_f90_gfortran.dat
	diff out/SunGrav_Serial-fortran_f90_ifort.dat                 out_gold/SunGrav_Serial-fortran_f90_ifort.dat
	diff out/SunGrav_Serial-fortran_f90_pgf90.dat                 out_gold/SunGrav_Serial-fortran_f90_pgf90.dat
	diff out/SunGrav_Serial-c++_g++.dat                           out_gold/SunGrav_Serial-c++_g++.dat
	diff out/SunGrav_Serial-c++_pgc++.dat                         out_gold/SunGrav_Serial-c++_pgc++.dat
	
	diff out/SunGrav_OpenMP-fortran_Ruben_gfortran.dat            out_gold/SunGrav_OpenMP-fortran_Ruben_gfortran.dat
	diff out/SunGrav_OpenMP-fortran_Ruben_ifort.dat               out_gold/SunGrav_OpenMP-fortran_Ruben_ifort.dat
	diff out/SunGrav_OpenMP-fortran_Ruben_pgf90.dat               out_gold/SunGrav_OpenMP-fortran_Ruben_pgf90.dat
	diff out/SunGrav_OpenMP-fortran_Josan_gfortran.dat            out_gold/SunGrav_OpenMP-fortran_Josan_gfortran.dat
	diff out/SunGrav_OpenMP-fortran_Josan_ifort.dat               out_gold/SunGrav_OpenMP-fortran_Josan_ifort.dat
	diff out/SunGrav_OpenMP-fortran_Josan_pgf90.dat               out_gold/SunGrav_OpenMP-fortran_Josan_pgf90.dat
#	diff out/SunGrav_OpenMP-c++_g++.dat                           out_gold/SunGrav_OpenMP-c++_g++.dat
#	diff out/SunGrav_OpenMP-c++_pgc++.dat                         out_gold/SunGrav_OpenMP-c++_pgc++.dat
	./diffBetween2Files.py 2.e-3 out/SunGrav_OpenMP-c++_g++.dat   out_gold/SunGrav_OpenMP-c++_g++.dat 
	./diffBetween2Files.py 6.e-3 out/SunGrav_OpenMP-c++_pgc++.dat out_gold/SunGrav_OpenMP-c++_pgc++.dat

	diff out/SunGrav_OpenACC-fortran_gfortran.dat                 out_gold/SunGrav_OpenACC-fortran_gfortran.dat
#	diff out/SunGrav_OpenACC-fortran_ifort.dat                    out_gold/SunGrav_OpenACC-fortran_ifort.dat
	diff out/SunGrav_OpenACC-fortran_pgf90.dat                    out_gold/SunGrav_OpenACC-fortran_pgf90.dat
	diff out/SunGrav_OpenACC-c++_g++.dat                          out_gold/SunGrav_OpenACC-c++_g++.dat
	diff out/SunGrav_OpenACC-c++_pgc++.dat                        out_gold/SunGrav_OpenACC-c++_pgc++.dat
	
	diff out/SunGrav_CUDA-fortran_gfortran.dat                    out_gold/SunGrav_CUDA-fortran_gfortran.dat
#	diff out/SunGrav_CUDA-fortran_ifort.dat                       out_gold/SunGrav_CUDA-fortran_ifort.dat
	diff out/SunGrav_CUDA-fortran_pgf90.dat                       out_gold/SunGrav_CUDA-fortran_pgf90.dat
	diff out/SunGrav_CUDA-c++_g++.dat                             out_gold/SunGrav_CUDA-c++_g++.dat
	diff out/SunGrav_CUDA-c++_pgc++.dat                           out_gold/SunGrav_CUDA-c++_pgc++.dat
