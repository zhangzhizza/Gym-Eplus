///////////////////////////////////////////////////////
/// \file   writeToConsole.c
///
/// \brief  Program that takes one integer argument
///         and writes it to the console
///
/// \author Michael Wetter,
///         Simulation Research Group, 
///         LBNL,
///         MWetter@lbl.gov
///
/// \date   2010-02-09
///
/// This file is used to illustrate how to use
/// the SystemCommand actor with multiple firing
/// rates.
/// The program takes at least one char* argument
/// and writes it to the console.
///
///////////////////////////////////////////////////////

#include <stdio.h>
#include <stdlib.h>

//////////////////////////////////////////////////////
/// Main function
int main(int argc, char *argv[]){
  //////////////////////////////////////////////////////
  int i;
  if (argc <= 1) {
    printf("Usage: %s arg\n", argv[0]);
    return(1);
  }
  for(i = 1; i < argc; i++)
    fprintf(stdout, "%s ", argv[i]);
  fprintf(stdout, "\n");
  exit(0);
}

