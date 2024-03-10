/* i
 * This program generate derivation coveraged string for the below grammar
 */

/*
	S : P
	P : T P | T
	T : PUSH A ;
	A : PUSH OPER  | PUSH A OPER  | NULL
	OPER : ADD | SUB | MUL | DIV | MOD 
*/

#define RANGE 20
#define NUM_LOCALS 10
#include <crest.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
// #include <random.h>

long long sz = 0;
long long choices = 0;
long long prev_choices[100000];
int pc = 0;
char curr_str[100];


FILE* prev_choices_file; // file that contains derivation coverage of previous strings
FILE* terms; // output file of all produced strings


int myrandom(int i)
{
	return 1 + rand() % i;
}

int get_local_index()
{
	return 4 + rand() % NUM_LOCALS;
}

int get_jump_label()
{	
	return rand() % pc;
}

// sets Kth bit of choices and returns whether current choice is already covered in previous derivation coverage
int set_k_bit(int k)
{
	choices = choices | (1 << k);
	for(int i=0;i<sz;i++)
	{
		if(prev_choices[i] == choices)
			return 1;
	}
	return 0;
}

int S()
{
	int choice = 0;
	if(set_k_bit(choice))
		return -1;
	int err = P(); //org
    /*
    printPUSH();
    printPUSH();
    printPUSH();
    int err = OPER();
    */
	if(err == -1)
		return -1;
	fprintf(terms,"%s \n",curr_str);
	fprintf(prev_choices_file,"%lld ",choices);
	return 1;
}


int P()
{
	int choice = 0;
	CREST_int(choice); //crest int to choose randomly choose any one of the productions
	if(choice == 1)
	{
		if(set_k_bit(choice))
			return -1;
		if(T() == -1)
			return -1;
		return P();
	}
	else
	{
		choice = 2;
		if(set_k_bit(choice))
			return -1;
		//if(T() == -1)
		//	return -1;
		return 1;
	}

}

int T()
{
	int choice = 3;
	if (set_k_bit(choice))
		return -1;
	printPUSH();
	int err = A();
	if(err == -1)
		return -1;
	return 1;
}


int A()
{
	int choice = 0;
	CREST_int(choice); //crest int to choose randomly choose any one of the productions
	if(choice == 4)
	{
		if(set_k_bit(choice))
			return -1;
		printPUSH();
		return OPER();
	}
	else if(choice == 5)
	{
		if(set_k_bit(choice))
			return -1;
		printPUSH();	
		if(A() == -1)
			return -1;
		return OPER();
	}	
	else
	{
		choice = 6;	
		if(set_k_bit(choice))
			return -1;
		return 1;
	}
}

int OPER()
{
	int choice = 0;
	CREST_int(choice); //crest int to choose randomly choose any one of the productions
	if(choice == 7)		//istore index
	{
		char* _int[64];
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : istore",pc++);
		sprintf(_int," %lld ",get_local_index());
		strcat(curr_str,_int);
		strcat(curr_str," ; ");
	}
	else if(choice == 8)	//istore_0
	{
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : istore_0 ; ",pc++);
	}
	else if(choice == 9)	//istore_1
	{
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : istore_1 ; ",pc++);
	}
	else if(choice == 10)	//istore_2
	{
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : istore_2 ; ",pc++);
	}
	else if(choice == 11)	//istore_3
	{
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : istore_3 ; ",pc++);
	}
	else if(choice == 12) 	//if_icmpeq
	{
		char* _int[64];
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : if_icmpeq ",pc);
		sprintf(_int," %d ",get_jump_label());
		strcat(curr_str,_int);
		strcat(curr_str," ; ");
	}
	else if(choice == 13) 	//if_icmplt
	{
		char* _int[64];
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : if_icmplt ",pc);
		sprintf(_int," %d ",get_jump_label());
		strcat(curr_str,_int);
		strcat(curr_str," ; ");
	}
	else if(choice == 14) 	//if_icmple
	{
		char* _int[64];
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : if_icmple ",pc);
		sprintf(_int," %d ",get_jump_label());
		strcat(curr_str,_int);
		strcat(curr_str," ; ");
	}
	else if(choice == 15) 	//if_icmpgt
	{
		char* _int[64];
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : if_icmpgt ",pc);
		sprintf(_int," %d ",get_jump_label());
		strcat(curr_str,_int);
		strcat(curr_str," ; ");
	}
	else if(choice == 16) 	//if_icmpge
	{
		char* _int[64];
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : if_icmpge ",pc);
		sprintf(_int," %d ",get_jump_label());
		strcat(curr_str,_int);
		strcat(curr_str," ; ");
	}
	else if(choice == 17) 	//ifeq
	{
		char* _int[64];
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : ifeq ",pc);
		sprintf(_int," %d ",get_jump_label());
		strcat(curr_str,_int);
		strcat(curr_str," ; ");
	}
	else if(choice == 18) 	//ifne
	{
		char* _int[64];
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : ifne ",pc);
		sprintf(_int," %d ",get_jump_label());
		strcat(curr_str,_int);
		strcat(curr_str," ; ");
	}
	else if(choice == 19) 	//iflt
	{
		char* _int[64];
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : iflt ",pc);
		sprintf(_int," %d ",get_jump_label());
		strcat(curr_str,_int);
		strcat(curr_str," ; ");
	}
	else if(choice == 20) 	//ifle
	{
		char* _int[64];
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : ifle ",pc);
		sprintf(_int," %d ",get_jump_label());
		strcat(curr_str,_int);
		strcat(curr_str," ; ");
	}
	else if(choice == 21) 	//ifgt
	{
		char* _int[64];
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : ifgt ",pc);
		sprintf(_int," %d ",get_jump_label());
		strcat(curr_str,_int);
		strcat(curr_str," ; ");
	}
	else if(choice == 22) 	//ifge
	{
		char* _int[64];
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : ifge ",pc);
		sprintf(_int," %d ",get_jump_label());
		strcat(curr_str,_int);
		strcat(curr_str," ; ");
	}
	else if(choice == 23) 	//iinc index NUM
	{
		char* index[64];
		char* _int[64];
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : iinc  ",pc);
		sprintf(index," %d ",get_local_index());
		sprintf(_int," ,  %d ",myrandom(RANGE));
		strcat(curr_str,index);
		strcat(curr_str,_int);
		strcat(curr_str," ; ");
	}
	else if(choice == 24) 	//iconstm1
	{
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : iconst_m1 ; ",pc++);
	}
	else if(choice == 25) 	//iconst_0
	{
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : iconst_0 ; ",pc++);
	}
	else if(choice == 26) 	//iconst_1
	{
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : iconst_1 ; ",pc++);
	}
	else if(choice == 27) 	//iconst_2
	{
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : iconst_2 ; ",pc++);
	}
	else if(choice == 28) 	//iconst_3
	{
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : iconst_3 ; ",pc++);
	}
	else if(choice == 29) 	//iconst_4
	{
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : iconst_4 ; ",pc++);
	}
	else if(choice == 30) 	//iconst_5
	{
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : iconst_5 ; ",pc++);
	}
	else if(choice == 31) 	//iload index
	{
		char* _int[64];
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : iload ",pc++);
		sprintf(_int," %d ",get_local_index());
		strcat(curr_str,_int);
		strcat(curr_str," ; ");
	}
	else if(choice == 32) 	//iload_0
	{
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : iload_0 ; ",pc++);
	}
	else if(choice == 33) 	//iload_1
	{
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : iload_1 ; ",pc++);
	}
	else if(choice == 34) 	//iload_2
	{
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : iload_2 ; ",pc++);
	}
	else if(choice == 35) 	//iload_3
	{
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : iload_3 ; ",pc++);
	}
	else if(choice == 36) 	//ineg
	{
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : ineg ; ",pc++);
	}
	else if(choice == 37) 	//iadd
	{
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : iadd ; ",pc++);
	}
	else if(choice == 38) 	//isub
	{
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : isub ; ",pc++);
	}
	else if(choice == 39) 	//imul
	{
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : imul ; ",pc++);
	}
	else if(choice == 40) 	//idiv
	{
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : idiv ; ",pc++);
	}
	else if(choice == 41) 	//irem
	{
		if(set_k_bit(choice))
			return -1;
		sprintf(curr_str+strlen(curr_str),"%d : irem ; ",pc++);
	}
	return 1;
}

void printPUSH()
{
	sprintf(curr_str+strlen(curr_str),"%d : bipush ", pc++);
	char* _int[64];
	sprintf(_int," %lld ",myrandom(RANGE));
	strcat(curr_str,_int);
	strcat(curr_str," ; ");
}


void printREVERSE()
{
	strcat(curr_str," REVERSE ; ");
}


//read the previous derivation coverage from the file and store in the prev_choices array
void read_prev_choices()
{
	FILE *f = fopen("prev_choices","r");
	//error in opening
	if(!f)
		return;
	int  temp;
	while(fscanf(f,"%d ",&temp) == 1)
	{
		prev_choices[sz++] = (long long)temp;
	}
	fclose(f);
}

int main(void) 
{
	srand ( time(NULL) );
	printf("main;");
	terms =  fopen("terms","a");
	read_prev_choices();
	prev_choices_file =  fopen("prev_choices","a");
	S();
	fclose(terms);
	fclose(prev_choices_file);
	return 0;   
}
