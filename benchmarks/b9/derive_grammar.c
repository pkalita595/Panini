/* 
 * This program generate derivation coveraged string for the below grammar
 */

/*
	S : E
	E : E + F  | E - F | F
	F : F * G  | F / G | G
	G : int
*/

#include <crest.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
// #include <random.h>

long long sz = 0;
long long choices = 0;
long long prev_choices[100000];
char curr_str[100];


FILE* prev_choices_file; // file that contains derivation coverage of previous strings
FILE* terms; // output file of all produced strings


int myrandom(int i)
{
	return 1 + rand() % i;
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


// to print the coverage of given choices for current execution
void print_coverage_set(long long choices)
{
	char str[64];
	for(int i=0;i<32;i++)
	{
		if(choices & (1 << i))
			fprintf(terms," %d",i);	
	}
	fprintf(terms,"\n");
}


int S()
{
	int choice = 0;
	set_k_bit(choice);
		// return -1;
	int err = exp();
	if(err == -1)
		return -1;
	// strcat(curr_str,"\n");
	fprintf(terms,"%s\n",curr_str);
	fprintf(prev_choices_file,"%lld ",choices);
	//print_coverage_set(choices);
	return 1;
}


int exp()
{
	int choice = 0;
	CREST_int(choice); //crest int to choose randomly choose any one of the productions
	if(choice == 1)
	{
		set_k_bit(choice);
			// return -1;
		if(exp() == -1)
			return -1;
		strcat(curr_str," + ");
		return term();
	}
	else if(choice == 2)
	{
		set_k_bit(choice);
			// return -1;
		if(exp() == -1)
			return -1;
		strcat(curr_str," - ");
		return term();

	}else if(choice == 3)
	{
		set_k_bit(choice);
			// return -1;
		if(exp() == -1)
			return -1;
		strcat(curr_str," && ");
		return term();

	}else if(choice == 4)
	{
		set_k_bit(choice);
			// return -1;
		if(exp() == -1)
			return -1;
		strcat(curr_str," || ");
		return term();

	}else if(choice == 5)
	{
		set_k_bit(choice);
			// return -1;
		if(exp() == -1)
			return -1;
		strcat(curr_str," == ");
		return term();

	}
	else
	{
		choice = 6;
		set_k_bit(choice);
			// return -1;
		return term();
	}	
}



int term()
{
	int choice = 0;
	CREST_int(choice); //crest int to choose randomly choose any one of the productions
	if(choice == 7)
	{
	//	set_k_bit(choice);
			// return -1;	
        if(set_k_bit(choice))
		    return -1;
	    // printf("ending \n");
	    char* _int[64];
	    sprintf(_int," %lld ",myrandom(100));
	    strcat(curr_str,_int);

		return 1;
	}
	else if(choice == 8)
	{
	//	set_k_bit(choice);
			// return -1;	
		if(set_k_bit(choice))
			    return -1;
		// printf("ending \n");
		char* _int[64];
		sprintf(_int," true ");
		strcat(curr_str,_int);

		return 1;
	}
	
	else if(choice == 9)
	{
	//	set_k_bit(choice);
			// return -1;	
		if(set_k_bit(choice))
			    return -1;
		// printf("ending \n");
		strcat(curr_str," ( ");
		if(exp() == -1)
			return -1;
		strcat(curr_str," ) ");
		return 1;
	}

	else 
	{
        choice = 10;
	//	set_k_bit(choice);
			// return -1;	
        if(set_k_bit(choice))
		    return -1;
	    // printf("ending \n");
	    char* _int[64];
	    sprintf(_int," false ");
	    strcat(curr_str,_int);

		return 1;
	}
	
}

/*
int term()
{
	int choice = 0;
	if(set_k_bit(choice))
		return -1;
	// printf("ending \n");
	char* _int[64];
	sprintf(_int," %lld ",myrandom(100));
	strcat(curr_str,_int);
	// printf(" after ending \n");

	return 1;	
}
*/

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

int main(void) {
	srand ( time(NULL) );
	printf("main\n");
	terms =  fopen("terms","a");
	read_prev_choices();
	prev_choices_file =  fopen("prev_choices","a");
	S();
	fclose(terms);
	fclose(prev_choices_file);
	return 0;   
}
