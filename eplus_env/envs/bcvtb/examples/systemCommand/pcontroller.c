///////////////////////////////////////////////////////
/// \file   pcontroller.c
///
/// \brief  Simple program of a C controller
///         to illustrate how to call an external
///         simulation program.
///
/// \author Michael Wetter,
///         Simulation Research Group, 
///         LBNL,
///         MWetter@lbl.gov
///
/// \date   2010-04-16
///
/// This file is a small program written in C
/// to illustrate how to call an external simulation
/// program.
///
/// The program implements a proportional controller
/// that limits its output between 0 and 1.
/// The command line arguments are the control error
/// and the proportional gain. 
/// The program will write the control signal to the
/// file output.txt.
/// In case of errors, the program returns 1 as the 
/// exit signal. Otherwise it returns 0.
///
///////////////////////////////////////////////////////

#include <stdio.h>
#include <stdlib.h>

//////////////////////////////////////////////////////
/// Main function
int main(int argc, char *argv[]){
  //////////////////////////////////////////////////////
  // Variable declaration
  double e;
  double k;
  double u;
  FILE *fil;
  int nWri;
  //////////////////////////////////////////////////////
  // Check the number of arguments
  if (argc != 3) {
    printf("Usage: %s controlError proportionalGain\n", argv[0]);
    return(1);
  }
  //////////////////////////////////////////////////////
  // Compute the control action
  e = atof(argv[1]);
  k = atof(argv[2]);
  u = k*e;
  if ( u > 1.0 )
    u = 1.0;
  if ( u < 0.0 )
    u = 0.0;
  fprintf(stdout, "e = %f; \tk=%f; \tu=%f;\n", e, k, u);
  
  fil = fopen("output.txt","w");
  if (fil == NULL){
    fprintf(stderr, "Error when opening file '%s'\n", "output.txt");
    return 1;
  }
  
  nWri = fprintf(fil, "%f\n", u);
  if (nWri < 0){
    fprintf(stderr, "Error when writing to file '%s'\n", "output.txt");
    return 1;
  }
  fclose(fil);
  return 0;
}
