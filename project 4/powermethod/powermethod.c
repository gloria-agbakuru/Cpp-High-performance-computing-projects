/****************************************************************
 *                                                              *
 * This file has been written as a sample solution to an        *
 * exercise in a course given at the CSCS-USI Summer School.    *
 * It is made freely available with the understanding that      *
 * every copy of this file must include this header and that    *
 * CSCS/USI take no responsibility for the use of the enclosed  *
 * teaching material.                                           *
 *                                                              *
 * Purpose: : Parallel matrix-vector multiplication and the     *
 *            and power method                                  *
 *                                                              *
 * Contents: C-Source                                           *
 *                                                              *
 ****************************************************************/


#include <stdio.h>
#include <mpi.h>

#include "hpc-power.h"

#include <stdlib.h>
#include <math.h>



void matVec(double* A, double* x, double* y, int N)
{
    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    // vector lies on 0
    MPI_Bcast(x, N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
    double* local = (double*)calloc(N/size, sizeof(double));
    for(int i=0; i<N/size; i++)
        for(int j=0; j<N  ; j++)
            local[i] += A[i*N + j] * x[j];
    MPI_Gather(local, N/size, MPI_DOUBLE, y, N/size, MPI_DOUBLE, 0, MPI_COMM_WORLD);
    free(local);
}

double norm(double* x, int N)
{
    double res=.0;
    for(int i=0;i<N;++i)
        res += x[i]*x[i];
    return sqrt(res);

}

double powerMethod(double* A, int n, int N) {
    int rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Status status; MPI_Request request;
    double *x = (double *) calloc(N, sizeof(double));
    if (rank == 0)
        for (int i = 0; i < N; i++)
            x[i] = (double) (rand() % 10) / 100;

    for (int i = 0; i < n; ++i) {
        if (rank == 0) {
            double l2 = norm(x, N);
            for (int k = 0; k < N; ++k)
                x[k] /= l2;
        }
        double *iter = (double *) calloc(N, sizeof(double));
        matVec(A, x, iter, N);
        if (rank == 0) {
            for (int k = 0; k < N; ++k)
                x[k] = iter[k];
        }
    }
    return norm(x, N);
}

void generateMatrix(double* A, int N)
{
    int size;
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    for(int i = 0; i < N/size; ++i)
        for(int j = 0; j < N; ++j)
            A[i*N + j] = 1.;
}

void generateNew(double* A, int N, double s)
{
    int size;
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    for(int i = 0; i < N/size; ++i)
        for(int j = 0; j < N; ++j) {
            if(i == j)
                A[i * N + j] = 2.*s;
            if (abs(i - j) == 1)
                A[i * N + j] = -s*.5;
        }
}


void print(double* A, int N, int isMat)
{
    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    if(rank == 0) {
        if(isMat) {
            for (int i = 0; i < N/size; ++i) {
                for (int j = 0; j < N; ++j) {
                    printf(A[i*N + j]);
                }
                printf("\n");
            }
        } else {
           for(int i=0;i<N/size;++i)
               printf(A[i]);
        }
    }
}

void verify(double *A, int N, int n,) {

    for (int i = 0; i < N; i++) {

        
    }

    free(x_loc);

    
    MPI_Reduce(&correct_loc, &correct, 1, MPI_INT,
                MPI_MIN, 0, MPI_COMM_WORLD);
    return correct;
}


int main (int argc, char *argv[])
{
    int my_rank, size;
    int snd_buf, rcv_buf;
    int right, left;
    int sum, i;

    MPI_Status  status;
    MPI_Request request;


    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);

    MPI_Comm_size(MPI_COMM_WORLD, &size);
    int N = 1<<12;

    double* A = (double*)calloc(N*N/size, sizeof(double)) ;//(double*)malloc(N * N/size);

    generateNew(A, N, 277.);


    double time = -hpc_timer();
    double res = powerMethod(A, 100, N);
    time += hpc_timer();


    free(A);


    /* This subproject is about to write a parallel program to
       multiply a matrix A by a vector x, and to use this routine in
       an implementation of the power method to find the absolute
       value of the largest eigenvalue of the matrix. Your code will
       call routines that we supply to generate matrices, record
       timings, and validate the answer.
    */

    MPI_Finalize();
    return 0;
}
