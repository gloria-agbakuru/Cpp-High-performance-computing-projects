/* 
    Please include compiler name below (you may also include any other modules you would like to be loaded)

COMPILER= gnu

    Please include All compiler flags and libraries as you want them run. You can simply copy this over from the Makefile's first few lines
 
CC = cc
OPT = -O3
CFLAGS = -Wall -std=gnu99 $(OPT)
MKLROOT = /opt/intel/composer_xe_2013.1.117/mkl
LDLIBS = -lrt -Wl,--start-group $(MKLROOT)/lib/intel64/libmkl_intel_lp64.a $(MKLROOT)/lib/intel64/libmkl_sequential.a $(MKLROOT)/lib/intel64/libmkl_core.a -Wl,--end-group -lpthread -lm

*/

const char* dgemm_desc = "Naive, three-loop dgemm.";

void NaiveMM (int n, double* A, double* B, double* C, int size, int ii, int kk, int jj, int i, int k, int j)
{
  //int size, jj, kk, ii;
  for ( i = ii; i < size; ++i){
    for ( j = jj; j < size; ++j){
      for ( k = kk; k < size; ++j) {
        C[i+j*n]+= A[i+k*n]*B[k+j*n];
      }
    }

        
  }
}

void square_dgemm(int n, double* A, double* B, double* C, int size, int ii, int kk, int jj, int i, int k, int j) {
  //int size;
  for ( ii = 0; ii<n/size; ii+=size)  {
    for ( jj = 0; jj<n/size; jj+=size) {
      for ( kk=0; kk<n/size; kk+=size) {
          NaiveMM(n, A, B, C, i, j, k, ii, jj, kk, size);
        }
      }
    }

  }


/*
void square_dgemm(int n, int size, int i, int j, double* A, double* B, double* C) 
{
  */
  /* For each row i of A */
  
  
  //for (int i = 0; i < n; ++i)
    /* For each column j of B */ /*
    for (int j = 0; j < n; ++j)
      C[i+j*n] = 0;

  for (i = 0; i < n / size; i += size) {

    for (j = 0; j < n / size; j += size) {
      //for (int j =  m; j < m + size; ++j) {
        NaiveMM(n, size, i, j,  A,  B, C);
      }
    //}
  }
}    


*/

//const char* dgemm_desc = "Naive, three-loop dgemm.";
/*
void square_dgemm(int n, double* A, double* B, double* C) {
  int size;
  for (int ii = 0; ii<n; ii+=size)  {
    for (int jj = 0; jj<n; jj+=size) {
      for (int kk=0; kk<n; kk+=size) {
        NaiveMM(n, A, B, C);
        }
      }
    }

  }

*/

//const char* dgemm_desc = "Naive, three-loop dgemm.";

/* This routine performs a dgemm operation
 *  C := C + A * B
 * where A, B, and C are lda-by-lda matrices stored in column-major format.
 * On exit, A and B maintain their input values. */   
 
 /*
const char* dgemm_desc = "Naive, three-loop dgemm.";

 
void square_dgemm(int n, double* A, double* B, double* C) {
  int size;
  for (int ii = 0; ii<n/size; ii+=size)  {
    for (int jj = 0; jj<n/size; jj+=size) {
      for (int kk=0; kk<n/size; kk+=size) {
        for (int i = 0; i < size; ++i){
 //       for (i = ii; i < ii; ++i){
          for (int j = 0; j < size ; ++j){
            for (int k = 0; k < size ; ++k) {
              C[i+j*n]+= A[i+k*n]*B[k+j*n];
            }
          }
        }

      }
    }
  }
};


*/
/*
void square_dgemm(double *A, double *B, double *C, int n, int block_size)
{
	int k, j, ii, jj, i ;
	for (ii = 0; ii < n; ii += block_size)
	{
		for(jj = 0; jj < n; jj += block_size)
		{
			for (k = 0; k < n; ++k)
			{
				for (i= ii; i < ii + block_size; ++i)
				{
					for (j = jj; j < jj + block_size; ++j)
					{
						C[i*n + j] += A[i*n+k] * B[k*n+j];
					}
				}
			}
		}
	}
}
*/
//jj - ii
//kk - jj
//i - k


/*
void square_dgemm(int n, int size, int i, int j, int k, int ii, int kk, int jj, double* A, double* B, double* C) {
  for (ii = 0; ii<n/size; ii+=size)  {
    for (jj = 0; jj<n/size; jj+=size) {
      for (kk=0; kk<n/size; kk+=size) {
        for (i = 0; i < size; ++i){
 //       for (i = ii; i < ii; ++i){
          for (j = 0; j < size ; ++j){
            for (k = 0; k < size ; ++k) {
              C[i+j*n]+= A[i+k*n]*B[k+j*n];
            }
          }
        }

      }
    }
  }
};
*/

/*

void square_dgemm(int n, double* A, double* B, double* C) {
  int size;
  for (int ii = 0; ii<n/size; ii+=size)  {
    for (int jj = 0; jj<n/size; jj+=size) {
      for (int kk=0; kk<n/size; kk+=size) {
        for (int i = ii; i < ii; ++i){

          for (int j = jj; j < jj ; ++j){
            for (int k = kk; k < kk ; ++k) {
              C[i+j*n]+= A[i+k*n]*B[k+j*n];
            }
          }
        }

      }
    }
  }
};

*/

