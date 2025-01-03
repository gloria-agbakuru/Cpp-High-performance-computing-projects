from mpi4py import MPI
import numpy as np

comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()
dims = [0, 0]
dims = MPI.Compute_dims(size, dims)
periods = [1, 1]
comm_cart = comm.Create_cart(dims, periods)
coords = comm_cart.Get_coords(rank)
east, west = comm_cart.Shift(1, -1)
north, south = comm_cart.Shift(0, 1) 


comm_cart.send(rank, dest=south)
recv_north = comm_cart.recv(source=north)

comm_cart.send(rank, dest=north)
recv_south = comm_cart.recv(source=south)

comm_cart.send(rank, dest=east)
recv_west = comm_cart.recv(source=west)

comm_cart.send(rank, dest=west)
recv_east = comm_cart.recv(source=east)

for i in range(size):
    if i == rank:
        print(f"rank {rank}, coords {coords}, "
        f"neigh E:W {east}:{west}, "
        f"neigh N:S {north}:{south}")