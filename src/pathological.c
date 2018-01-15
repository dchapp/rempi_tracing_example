#include<stdlib.h>
#include<stdio.h>
#include<mpi.h>
#include<math.h>

void do_within_group_comm(int rank, int comm_size, int neighbor, int iters) {
  int i, mpi_err;
  int send_buffer = -1;
  int recv_buffer;
  MPI_Status status;
  for (i=0; i<iters; i++) {
    mpi_err = MPI_Send(&send_buffer, 1, MPI_INT, neighbor, 0, MPI_COMM_WORLD);
    mpi_err = MPI_Recv(&recv_buffer, 1, MPI_INT, neighbor, 0, MPI_COMM_WORLD, &status);
  }
  printf("Rank %d failed during within-group comm with error code %d\n", rank, mpi_err);
}

void do_between_group_comm(int rank, int comm_size) {
  int mpi_err;
  int send_buffer = -2;
  int recv_buffer;
  MPI_Status status;
  if (rank == 0) {
    mpi_err = MPI_Recv(&recv_buffer, 1, MPI_INT, 3, 0, MPI_COMM_WORLD, &status);
    printf("Rank %d received %d from rank %d\n", rank, recv_buffer, status.MPI_SOURCE);
  } 
  else if (rank == 3) {
    mpi_err = MPI_Send(&send_buffer, 1, MPI_INT, 0, 0, MPI_COMM_WORLD);
  }
  printf("Rank %d failed during between-group comm with error code %d\n", rank, mpi_err);
}

void do_comm(int rank, int comm_size) {
  // Determine neighbors
  int neighbor;
  if (rank % 2 == 0) {
    neighbor = rank + 1;
  } else {
    neighbor = rank - 1;
  }
  printf("Rank %d's neighbor is rank %d\n", rank, neighbor);
  // Determine amount of comm to do
  int iters;
  if (rank < 2) {
    iters = 10;
  } else {
    iters = 5;
  }
  // Do within-group comm
  do_within_group_comm(rank, comm_size, neighbor, iters);
  do_between_group_comm(rank, comm_size);
}


int main(int argc, char** argv) {
    int iters = atoi(argv[1]);

    int mpi_err, rank, comm_size;
    mpi_err = MPI_Init(&argc, &argv);
    mpi_err = MPI_Comm_size(MPI_COMM_WORLD, &comm_size);
    mpi_err = MPI_Comm_rank(MPI_COMM_WORLD, &rank);
   
    int i;
    for (i=0; i<iters; i++) {
        if (rank == 0) {
            printf("ITER %d\n", i);
        }
        do_comm(rank, comm_size);
    }

    mpi_err = MPI_Finalize();
    if (mpi_err != 0) {
        printf("Rank %d failed to finalize with error code %d\n", rank, mpi_err);
    }
    return 0;
}
