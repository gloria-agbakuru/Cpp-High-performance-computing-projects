// #include <omp.h>
#include "walltime.h"
#include <iostream>
#include <math.h>
#include <stdio.h>
#include <unistd.h>
#include <iomanip>
#include "omp.h"
//#include "mkl.h"


#define NUM_ITERATIONS 100


// Example benchmarks
// 0.008s ~0.8MB
//#define N 100000
// 0.1s ~8MB
//#define N 1000000
// 1.1s ~80MB
//#define N 10000000
// 13s ~800MB
//#define N 100000000
// 127s 16GB
#define N 1000000000
#define EPSILON 0.1

using namespace std;



int main() {

  for ( int p = 1;  p < 25;  p++){
     omp_set_num_threads(p);
      cout << "thread :" << p;

// for (int i = 0; i < NUM_ITERATIONS; i++) {

  double time_serial, time_start = 0.0;
  double *a, *b;

  // Allocate memory for the vectors as 1-D arrays
  a = new double[N];
  b = new double[N];

  //omp_set_dynamic(0);
 //omp_set_num_threads(6);
  
  #pragma omp parallel for schedule(static)// Initialize the vectors with some values
  for (int i = 0; i < N; i++) {
    a[i] = i;
    b[i] = i / 10.0;
  }

  long double alpha = 0;
  // serial execution
  // Note that we do extra iterations to reduce relative timing overhead
  time_start = wall_time();
  for (int iterations = 0; iterations < NUM_ITERATIONS; iterations++) {
    alpha = 0.0;
    for (int i = 0; i < N; i++) {
      alpha += a[i] * b[i];
    }
  }
  time_serial = wall_time() - time_start;
  //cout << "Serial execution time = " << time_serial << " sec" << endl;
  //cout << "serial: " << time_serial << " \n";
  cout << "serial: " << setprecision(5) << time_serial<< " \n";


  long double alpha_parallel = 0;
  double time_red = 0;
  double time_critical = 0;
  long double alpha_parallel_two = 0;

  //   TODO: Write parallel version (2 ways!)
  //   i.  Using reduction pragma
  //   ii. Using  critical pragma

 time_start = wall_time();

  for (int iterations = 0; iterations < NUM_ITERATIONS; iterations++) {
    alpha_parallel = 0.0;
  #pragma omp parallel for reduction(+: alpha_parallel) schedule(static)

    for (int i = 0; i < N; i++) {
      alpha_parallel += a[i] * b[i];
    }
  }
  time_red = wall_time() - time_start;


 time_start = wall_time();
  for (int iterations = 0; iterations < NUM_ITERATIONS; iterations++) {
    alpha_parallel = 0.0;
    #pragma omp parallel shared(alpha_parallel) private(alpha_parallel_two)
    {

      alpha_parallel_two = 0.0;
      #pragma omp for schedule(static) nowait
      for (int i = 0; i < N; i++) {
        alpha_parallel_two += a[i] * b[i];
      }



      #pragma omp critical
      {
        alpha_parallel += alpha_parallel_two;
      }
    }
  }
  time_critical = wall_time() - time_start;


  if ((fabs(alpha_parallel - alpha) / fabs(alpha_parallel)) > EPSILON) {
    cout << "parallel reduction: " << alpha_parallel << ", serial: " << alpha
         << "\n";
    cerr << "Alpha not yet implemented correctly!\n";
    exit(1);
  }

  /*
  cout << "Parallel dot product = " << alpha_parallel
       << " time using reduction method = " << time_red
       << " sec, time using critical method " << time_critical << " sec"
       << endl;

*/
  
     cout << "reduction: " << setprecision(5) << time_red<< " \n";
      //cout << "reduction: " << time_red << ", \n";
      //cout << "critical: " << time_critical << ". \n";
      cout << "critical: " << setprecision(5) << time_critical<< " \n";
      //cout << "reduction: " << setprecision(4) << time_red;

  // De-allocate memory
  delete[] a;
  delete[] b;
//cout<<("%d\n", omp_get_num_threads( ));


}
  return 0;
}




 