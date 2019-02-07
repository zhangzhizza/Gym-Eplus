#include "bcvtb.h"

int establishModelicaClient(const char *const docname){
  return establishclientsocket(docname);
}


int exchangeModelicaClient(int sockfd, 
			   int flaWri, int *flaRea,
			   double simTimWri,
			   double* dblValWri, size_t nDblWri,
			   double* simTimRea,
			   double* dblValRea, size_t nDblRea){
  return exchangedoubleswithsocket(&sockfd, 
				   &flaWri, flaRea,
				   &nDblWri,
				   &nDblRea,
				   &simTimWri,
				   dblValWri,
				   simTimRea,
				   dblValRea);
}

int closeModelicaClient(int sockfd){
    const int flaWri = 1;
    sendclientmessage(&sockfd, &flaWri);
    return closeipc(&sockfd);
}
