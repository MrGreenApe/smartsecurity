#include "mpi.h"
#include "openssl/sha.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include "openssl/des.h"
#include "openssl/rsa.h"
#include "openssl/pem.h"

#define length 1073741792

int main(int argc, char *argv[]) {
	int  numtasks, rank, len, rc,i; 
	char hostname[MPI_MAX_PROCESSOR_NAME];

	double file_gen_step1_start,file_gen_step1_stop,plain_hash_step2_start,plain_hash_step2_stop,des_step3_start,des_step3_stop,rsa_step4_start,rsa_step4_stop,cypher_hash_step5_start,cypher_hash_step5_stop;
	unsigned char master_buffer[length];
	unsigned char worker_buffer[length];
	unsigned char *hashstring=NULL;
	unsigned char finalhash[48];

	rc = MPI_Init(&argc,&argv);
	if (rc != MPI_SUCCESS) {
		printf ("Error starting MPI program. Terminating.\n");
		MPI_Abort(MPI_COMM_WORLD, rc);
	}

	MPI_Comm_size(MPI_COMM_WORLD,&numtasks);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	MPI_Get_processor_name(hostname, &len);
	printf ("Number of tasks= %d My rank= %d Running on %s\n", numtasks,rank,hostname);

	/*******  do some work *******/

	FILE *f=NULL;
	SHA512_CTX ctx;
	SHA512_CTX ctx2;
	DES_cblock key;
	DES_key_schedule schedule;

	if(rank==0)
	{
		for (i = 0; i < length; i++)
		{
			master_buffer[i]=i;
		}
	}
	
	printf ("Step1 rank= %d \n", rank);
	//step1 - file generation
	MPI_Barrier(MPI_COMM_WORLD);
	file_gen_step1_start=MPI_Wtime();

	MPI_Scatter(master_buffer,length/numtasks,MPI_CHAR,worker_buffer,length/numtasks,MPI_CHAR,0,MPI_COMM_WORLD);

	for (i = 0; i < length/numtasks; i++)
	{
		worker_buffer[i]++;
	}

	MPI_Gather(worker_buffer,length/numtasks,MPI_CHAR,master_buffer,length/numtasks,MPI_CHAR,0,MPI_COMM_WORLD);

	MPI_Barrier(MPI_COMM_WORLD);
	file_gen_step1_stop=MPI_Wtime();
	//step1
	
	if(rank==0)
	{
		f=fopen("input.plain","w");
		fwrite(master_buffer,1,length,f);
		fclose(f);
		SHA384_Init(&ctx);
		hashstring=(unsigned char*)malloc(48*numtasks);
	}

	printf ("Step2 rank= %d \n", rank);
	//step2 - hash on plain
	MPI_Barrier(MPI_COMM_WORLD);
	plain_hash_step2_start=MPI_Wtime();

	MPI_Scatter(master_buffer,length/numtasks,MPI_CHAR,worker_buffer,length/numtasks,MPI_CHAR,0,MPI_COMM_WORLD);

	SHA512_CTX localctx;
	unsigned char hash[48];
	SHA384_Init(&localctx);
	SHA384_Update(&localctx, worker_buffer, length/numtasks);
	SHA384_Final(hash, &localctx);

	MPI_Gather(hash,48,MPI_CHAR,hashstring,48,MPI_CHAR,0,MPI_COMM_WORLD);

	MPI_Barrier(MPI_COMM_WORLD);
	plain_hash_step2_stop=MPI_Wtime();
	//step2
	
	if(rank==0)
	{
		SHA384_Update(&ctx,hashstring,48*numtasks);
		SHA384_Final(finalhash,&ctx);
		FILE *h1=fopen("input.hash","w");
		fwrite(finalhash,1,48,h1);
		fclose(h1);
		DES_string_to_key("12345678", &key);
		DES_set_odd_parity(&key);
		DES_set_key_unchecked(&key, &schedule);	
	}

	printf ("Step3 rank= %d \n", rank);
	//step3 - DES encryption
	MPI_Barrier(MPI_COMM_WORLD);
	des_step3_start=MPI_Wtime();

	MPI_Scatter(master_buffer,length/numtasks,MPI_CHAR,worker_buffer,length/numtasks,MPI_CHAR,0,MPI_COMM_WORLD);

	unsigned char buf[8];
	memset(buf,0,8);
	for(i=0;i<length;i+=8)
	{
		memcpy(buf,worker_buffer,8);
		DES_ecb_encrypt((C_Block *)buf,(C_Block *)buf, &schedule, DES_ENCRYPT);
		memcpy(worker_buffer+i,buf,8);
	}

	MPI_Gather(worker_buffer,length/numtasks,MPI_CHAR,master_buffer,length/numtasks,MPI_CHAR,0,MPI_COMM_WORLD);

	MPI_Barrier(MPI_COMM_WORLD);
	des_step3_stop=MPI_Wtime();
	//step3
	
	

	MPI_Finalize();
}