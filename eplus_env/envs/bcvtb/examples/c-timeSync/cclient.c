///////////////////////////////////////////////////////
/// \file   cclient.c
///
/// \brief  Simple simulation program to illustrate
///         implementation of a client.
///
/// \author Michael Wetter,
///         Simulation Research Group, 
///         LBNL,
///         MWetter@lbl.gov
///
/// \date   2007-01-05
///
/// This file is a simple simulation program written 
/// in C to illustrate how to implement a client.
/// The program computes $x_{k+1} = u_k$, where
/// $x_k$ is sent to the middleware and $u_k$ is read
/// from the middleware.
///
///////////////////////////////////////////////////////

#include <stdio.h>
#include <stdlib.h>
//#include <unistd.h> // for sleep 
#include "utilSocket.h"

//////////////////////////////////////////////////////
/// Main function
int main(int argc, char *argv[]){
  //////////////////////////////////////////////////////
  // Declare variables for the socket communication
  // File name used to get the port number
  const char * simCfgFilNam = "socket.cfg";
    // client error flag
  const int cliErrFla = -1;
  // Flags to exchange the status of the simulation program 
  // and of the middleware.
  int flaWri = 0;
  int flaRea = 0;
  // Number of variables to be exchanged
  const int nDblWri = 1;
  int nDblRea;
  // Arrays that contain the variables to be exchanged
  double dblValWri[1];
  double dblValRea[1];
  int i, sockfd, retVal;

  double simTimWri = 0;
  double simTimRea = 0;

  //////////////////////////////////////////////////////
  // Declare initial values
  if (argc <= 1) {
    printf("Usage: %s Initial_Double_Value\n", argv[0]);
    return(1);
  }
  // initialize value
  dblValWri[0] = atof(argv[1]);

  /////////////////////////////////////////////////////////////
  // Establish the client socket
  sockfd = establishclientsocket(simCfgFilNam);
  if (sockfd < 0){
    fprintf(stderr,"Error: Failed to obtain socket file descriptor. sockfd=%d.\n", sockfd);
    exit((sockfd)+100);
  }

  /////////////////////////////////////////////////////////////
  // Simulation loop
  dblValRea[0] = 0;
  while(1){ // loop over time step (each pass is a time step)
    /////////////////////////////////////////////////////////////
    // Sleep statement for testing
    //    sleep(2);
    /////////////////////////////////////////////////////////////
    // Exchange values
    const int retVal = exchangedoubleswithsocket(&sockfd, &flaWri, &flaRea,
						 &nDblWri, &nDblRea,
						 &simTimWri, dblValWri, 
						 &simTimRea, dblValRea);

    /////////////////////////////////////////////////////////////
    // Check flags
    if (retVal < 0){
      printf("Received value %d when reading from socket. Exit simulation.\n", retVal);
      closeipc(&sockfd);
      exit((retVal)+100);
    }
    
    if (flaRea == 1){
      printf("Received end of simulation signal from server. Exit simulation.\n");
      closeipc(&sockfd);
      exit(0);
    }
    
    if (flaRea != 0){
      printf("Received flag = %d from server. Exit simulation.\n", flaRea);
      closeipc(&sockfd);
      exit(1);
    }
    /////////////////////////////////////////////////////////////
    // Check for the correct number of double values
    if (nDblRea != 1){
      printf("Simulator received nDblRea = %d from server, but expected 1. Exit simulation.\n", 
	     nDblRea);
      closeipc(&sockfd);
      exit(1);
    }

    /////////////////////////////////////////////////////////////
    // Having obtained y_k, we compute the new state x_{k+1} = y_k
    // This is the actual simulation of the client, such as an
    // EnergyPlus time step
    dblValWri[0] = dblValRea[0];
    simTimWri += 1; // previous's time step's time
  } // end of simulation loop
}
