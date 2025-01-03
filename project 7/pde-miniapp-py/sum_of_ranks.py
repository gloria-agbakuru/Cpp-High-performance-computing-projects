from mpi4py import MPI
import numpy as np

comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()


# using the pickle-based communication of generic Python objects
sum1 = comm.reduce(rank, op=MPI.SUM, root=0)

# using the fast, near C-speed, direct array data communication of buffer-provider objects
data = np.array(rank, dtype='i')
sum2 = np.empty(1, dtype='i')

# comm.Reduce(len[data, MPI.INT], sum2, op=MPI.SUM, root=0)
comm.Reduce([data, MPI.INT], sum2, op=MPI.SUM, root=0)

if rank == 0:
    print("     ")
    print("using the pickle-based communication,")
    print("sum of all ranks is - ", sum1)

    print("     ")

    print("using the faster, C-like communication,")
    print("sum of all ranks is - ", sum2[0])

    print("     ")

