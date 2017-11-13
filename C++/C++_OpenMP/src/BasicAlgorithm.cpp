#include <stdio.h>
#include <math.h>

#include <cmath>
#include <algorithm>

#include <iostream>
#include <iomanip>
#include <fstream>
#include <sstream>

#include <boost/format.hpp>
#include <ctime>

#include <omp.h>

#define n            10000
#define n1           32000
#define nLim         9995.
#define gDiv2DivPI  -1.06156347e-8
#define DESPLX       0.
#define DESPLY       0.

class Double {
public:
    Double(double x): value(x) {}
    const double value;
};

std::ostream & operator<< (std::ostream & stream, const Double & x) {
    // So that the log does not scream
    if (x.value == 0.) {
        stream << 0.0;
        return stream;
    }

    int exponent = std::floor(log10(std::abs(x.value)));
    double base = x.value / pow(10, exponent);

    // Transform here
    base /= 10;
    exponent += 1;

    stream << std::fixed << std::setprecision(5) << std::setw(7) << base << boost::format("E+%02d") % exponent;

    return stream;
}

void basic_algorithm(){

	int nProcessors = omp_get_max_threads();
	omp_set_num_threads(nProcessors);

	int    thread_num;
	double wtime_ini;
	#pragma omp parallel
	{
		thread_num = omp_get_num_threads();
		wtime_ini  = omp_get_wtime();
	}

    std::string line;
	double      dummy;

	// Integrales calculo gravitatorio
	double gi1[n];
	double gi2[n];
	double gi3[n];
	std::ifstream fIntegrals("../../../in/I1I2.txt");
	if(fIntegrals.is_open()) {
		long i = -1;
		while (std::getline(fIntegrals, line)) {
			std::istringstream ss(line);
			if (ss.good()) {
				i++;
				ss >> dummy >> gi1[i] >> gi2[i] >> gi3[i];
			}
		}
		fIntegrals.close();
	}

	// Info Sun model
	double a[n1][2];
	double masa[n1];
	std::ifstream fSunIn("../../../in/SunEvenSetmC_1.dat");
	if(fSunIn.is_open()) {
		long i = -1;
		while (std::getline(fSunIn, line)) {
			std::istringstream ss(line);
			if (ss.good()) {
				i++;
				ss >> dummy >> a[i][0] >> a[i][1] >> masa[i] >> dummy >> dummy >> dummy;
			}
		}
		fSunIn.close();
	}

	double wtime_loop_ini;
	double wtime_loop;
	double rrr[n1];
	double fgravmod[n1];
	#pragma omp parallel
	{
		double ap1[n1];
		double ap2[n1];
		double ap1_2[n1];
		double ap2_2[n1];
		double ri_2[n1];
		double ap1p2[n1];
		double ap2p2[n1];

        #pragma omp for
		for(long i = 0; i < n1; i++) {

			ap1[i]   = a[i][0] -DESPLX;
			ap2[i]   = a[i][1] -DESPLY;

			ap1_2[i] = ap1[i] * ap1[i];
			ap2_2[i] = ap2[i] * ap2[i];
			ri_2[i]  = ap1_2[i] +ap2_2[i];

			ap1p2[i] = 2. * ap1[i] *n;
			ap2p2[i] = 2. * ap2[i];
		}

		// Init values
		double fx[n1];
		double fy[n1];
		double ugrav[n1];

        #pragma omp for
		for (int i = 0; i < n1; i++) {
			fx[i]    = 0.;
			fy[i]    = 0.;
			ugrav[i] = 0.;
		}

		wtime_loop_ini = omp_get_wtime();

		//Calcula la gravedad particula a particula (en realidad anillo-anillo)
		double  rinvDen;
		long    ind;
		double  aux0;
		double  aux;

        #pragma omp for
		for (long i = 0; i < n1-1; i++) {
			for (long j = i; j < n1; j++) {

				rinvDen  = 1. / ( ri_2[i] +ri_2[j] - ap2p2[i] * ap2[j] );
				ind      = 1 + long( std::min( ap1p2[i] * ap1[j] * rinvDen, nLim ) );

				aux0     = sqrt(rinvDen);
				aux      = rinvDen *aux0;

				fx[i]     = fx[i]    +masa[j] *aux            *( ap1[j]*gi1[ind] -ap1[i]*gi2[ind] );
				fx[j]     = fx[j]    +masa[i] *aux            *( ap1[i]*gi1[ind] -ap1[j]*gi2[ind] );

				fy[i]     = fy[i]    +masa[j] *aux  *gi2[ind] *( ap2[j]          -ap2[i]          );
				fy[j]     = fy[j]    +masa[i] *aux  *gi2[ind] *( ap2[i]          -ap2[j]          );

				ugrav[i]  = ugrav[i] +masa[j] *aux0 *gi3[ind];
				ugrav[j]  = ugrav[j] +masa[i] *aux0 *gi3[ind];
			}
		}

		wtime_loop = omp_get_wtime() -wtime_loop_ini;

        #pragma omp for
		for (long i = 0; i < n1; i++) {

			fx[i]       = gDiv2DivPI *fx[i];
			fy[i]       = gDiv2DivPI *fy[i];

			ugrav[i]    = gDiv2DivPI *ugrav[i];

			rrr[i]      = sqrt( a[i][0] * a[i][0] + a[i][1] * a[i][1] );
			fgravmod[i] = sqrt( fx[i]   * fx[i]   + fy[i]   * fy[i]   );
		}
	}

    const char* compiler = getenv("CXX");

    char fileOut[100];
    std::sprintf(fileOut, "../../../out/SunGrav_OpenMP-c++_%s.dat", compiler);
	std::ofstream fSunOut(fileOut);
	for (long i = 0; i < n1; i++) {
		fSunOut << "   " << Double(rrr[i]) << "   " << Double(fgravmod[i]) << "\n";
	}
	fSunOut.close();

	double wtime;
	#pragma omp parallel
	{
		wtime = omp_get_wtime() - wtime_ini;
	}

	std::fstream fsTimes("../../../out/times.dat", std::fstream::in | std::fstream::out | std::fstream::app);
	fsTimes << boost::format("C++_OpenMP               ")
	        << boost::format("%-8s")        % compiler
			<< boost::format("%14.6f")      % wtime_loop
            << boost::format("%14.6f     ") % wtime
			<< __DATE__ << __TIME__
			<< boost::format("          NUM_THREADS:%8d") % thread_num
			<< boost::format("\n");
	fsTimes.close();
}

int main(void){

	basic_algorithm();

	return 0;
}
