#include "walltime.h"
#include <math.h>
#include <stdlib.h>
#include <omp.h>
#define STRIDE 4096

void compute_block(int N, double up, double up_block, double up_total, double Sn, double *opt, long i) {
/*
  if (i*2 < N) {
#pragma omp task shared(up_block) private(up_total, Sn, i)
    compute_block(N, up, up_block, up_total * up_total, Sn * up_total, opt, i*2);
*/
  if (i*2 < N) {
#pragma omp task shared(up_block) firstprivate(up_total,Sn,i)
    compute_block(N, up, up_block, up_total * up_total, Sn * up_total, opt, i * 2);

    if (i*2+STRIDE < N) {
#pragma omp task shared(up_block) firstprivate(up_total,Sn,i)
      compute_block(N, up, up_block, up_total * up_total*up_block, Sn * up_total * up_block, opt, i * 2 + STRIDE);
    }
  }
  long imax = i+STRIDE < N ? i+STRIDE : N;
  for (; i < imax; ++i) {
    opt[i] = Sn;
    Sn *= up;
  }
}

int main(int argc, char *argv[]) {
  int N = 2000000000;
  double up = 1.00000001;
  double Sn = 1.00000001;
  int n;
  /* allocate memory for the recursion */
  double *opt = (double *)malloc((N + 1) * sizeof(double));

  if (opt == NULL)
    die("failed to allocate problem size");

  double time_start = wall_time();
  int N0 = N+1;
#pragma omp parallel shared(N0,up,opt) firstprivate(Sn)
  {
#pragma omp single
    {
      long i = 0;
      double up_block = 1.0;
      long imax = STRIDE < N0 ? STRIDE : N0;
      
      for (; i < imax; ++i) {
        opt[i] = Sn;
        Sn *= up;
        up_block *= up;
      }
      //compute_block(N0, Sn, i, up, up_block, up_block, opt);
      compute_block(N0, up, up_block, up_block, Sn, opt, i);
    }  
  }
  Sn = opt[N] * up;

  printf("Parallel RunTime   :  %f seconds\n", wall_time() - time_start);
  printf("Final Result Sn    :  %.17g \n", Sn);

  double temp = 0.0;
  for (n = 0; n <= N; ++n) {
    temp += opt[n] * opt[n];
  }
  printf("Result ||opt||^2_2 :  %f\n", temp / (double)N);
  printf("\n");

  return 0;
}
