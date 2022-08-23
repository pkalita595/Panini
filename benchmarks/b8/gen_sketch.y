%{

extern "C"
{
	int yyparse();
	int yylex(void);
	void yyerror(char *s){}
	int yywrap(void){return 1;}
}

#include <cstdio>
#include <cstdlib>
#include <stdlib.h>
#include <assert.h>
#include <cstring>
#include <string>
#include <map>
#define  BIG_SIZE 1000
#define FUN_DEF_SIZE 1000
#define ASSERT_STMT_SIZE 1000
#define FUN_STATE_SIZE 8
#define NUM_FUNS 16

using namespace std;

struct DualVal {int real; int dual;};
static std::map<std::string, DualVal> vars;

int p = 0,offset = 200,code;
int last_id;
int val;
int flag = 0;


int max(int x,int y)
{
	return  x >= y ? x : y; 
}

%}

%union
{
    struct s {
      int offset;
      int width;
    } t;
	int f; //maintains the last allocated pointer address in the current tree
    int num;
}

%token <f>  NUM 
%type <t> E T L S S1 M1 M2 M3
%type <f> H 
%%

S : K '\n'	{return 0;}
  ;

K : S1 '=' H	{
  			printf("\tassert unknown[%d] == %d;\n", p-1, $3); p = p + 2;
    }
  ; 

S1 : E ';' M3 S1 { printf("\tunknown[%d] = unknown[%d];\n", p, $4.offset); $$.offset = p; p++;}
    | E ';' {printf("\tunknown[%d] = unknown[%d];\n", p,  $1.offset); $$.offset = p; p++; }
;

E : T M1 L  {printf("\tunknown[%d] = unknown[%d];\n", p, $3.offset);$$.offset = p; p++;}
;

T : INT { printf("\tunknown[%d] = 4; //{| 4 | 8 |};\n", p); $$.width = p; p++;  }
    | REAL { printf("\tunknown[%d] = 8; // {| 4 | 8 |};\n", p); $$.width = p; p++;  }

L : VAR ',' M2 L {printf("\tunknown[%d] = unknown[%d];\n", p, $4.offset); $$.offset = p; p++;}

    | VAR {printf("\tadd(unknown[%d], unknown[%d], unknown[%d]);\n",  $<t>0.offset, $<t>0.width, p); $$.offset = p; p++;}


VAR : 'a' 
    | 'b' 
    | 'c' 
    | 'd'

INT : 'i' {};

REAL    : 'r' {};

M1: {
        if(flag) {
            printf("//flag true\n");
            printf("\tunknown[%d] = unknown[%d];\n", p, $<t>-1.offset);
            $$.offset = p;  
            p++;
        }
        else{
            printf("\tunknown[%d] = 0;\n", p);
            $$.offset = p;  
            p++;
            flag = 1;
        }
        printf("\tunknown[%d] = unknown[%d];\n",p, $<t>0.width );
        $$.width = p; p++;
    }


M2 :  {  
        printf("\tadd(unknown[%d], unknown[%d], unknown[%d]);\n",  $<t>-2.offset, $<t>-2.width, p); 
        $$.offset = p; 
        p++;

        printf("\tunknown[%d] = unknown[%d];\n", p, $<t>-2.width); 
        $$.width = p; 
        p++;
        
    }

M3 : {
        printf("\tunknown[%d] = unknown[%d];\n", p, $<t>-1.offset); 
        $$.offset = p;
        p++;
    }

H : NUM {$$ = $1; }
  ;


%%


/*
void yyerror(char *msg)
{
	fprintf(stderr,"%s\n",msg);
	exit(1);
}*/

void takeSynFun(char* str, long long id){
    char buff[500] = {'\0'};
    int i = 0;
    char filename[40] = {'\0'};
    sprintf(filename, "fun_holes_dir/%lld.sk", id);
    FILE* fp1 = fopen(filename, "r");
    while((fscanf(fp1,"%c",&buff[i]))!=EOF) //scanf and check EOF
    {
            i++;
    }
    strcat(str, buff);
    fclose(fp1);
}

char* get_fun_defs(int id,int is_first)
{
	char *fun_id = "";
	if(!is_first)
	{
		fun_id = (char *)malloc(3);
		sprintf(fun_id,"%d",id);

	}

	int curr_code = code;
	char *str = (char *)malloc(5*FUN_DEF_SIZE);
	sprintf(str,"");
	if(curr_code % 2 == 1)
	{
		sprintf(str,""
		"void add(int xReal, int yReal, ref int _out)\n"
        "{\n"
        "       int  p = 0;\n"
        "       int bnd = 1;\n"
        "       _out =  _gen(xReal,yReal, 1);  \n"
        "}\n"
        "\n",fun_id,id-1);
	}
	else
	{
        /*
		sprintf(str,""
		"void addReal%s(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       _out =  xReal + yReal;\n"
        "}\n"
        "\n",fun_id);
        */
        takeSynFun(str, 1);
	}

	return str;
}


//to get the assert statement to ensure Fi != Fj
char * get_assert(int i,int j, char* str)
{
// 	char *str = (char *)malloc(ASSERT_STMT_SIZE * 2);
    sprintf(str,"\tassert ( equal(state[%d][0] , state[%d][0]) == 0  ||  equal(state[%d][1] , state[%d][1]) == 0 ||   equal(state[%d][2] , state[%d][2]) == 0  ||  equal(state[%d][3] , state[%d][3]) == 0  ||  equal(state[%d][4] , state[%d][4]) == 0 ||  equal(state[%d][5] , state[%d][5]) == 0 ||  equal(state[%d][6] , state[%d][6]) == 0 ||  equal(state[%d][7] , state[%d][7]) == 0 ||   equal(state[%d][8] , state[%d][8]) == 0  ||  equal(state[%d][9] , state[%d][9]) == 0  ||  equal(state[%d][10] , state[%d][10]) == 0 ||  equal(state[%d][11] , state[%d][11]) == 0 ||  equal(state[%d][12] , state[%d][12]) == 0 ||  equal(state[%d][13] , state[%d][13]) == 0  ||  equal(state[%d][14] , state[%d][14]) == 0 ||  equal(state[%d][15] , state[%d][15]) == 0);\n",i,j,i,j,i,j,i,j,i,j,i,j,i,j,i,j,i,j,i,j,i,j,i,j,i,j,i,j,i,j,i,j);
    //sprintf(str, "\tassert ( equal(state[0][7] , state[1][7]) == 0 ||     equal(state[0][13] , state[1][13]) == 0 );\n");

//	return str; 
}

int main(int argc,char **argv)
{
	code = atoi(argv[1]);

	//get the current F_bar_id
	FILE *f_bar = fopen("last_F_bar_id","r");
	if(!f_bar)
	{
		last_id = 2; //default F_bar_id
	}
	else
	{
		fscanf(f_bar,"%d",&last_id);
		fclose(f_bar);
	}	
	//all F' definitions
	char* F_bar_definitions = (char*)malloc(100000);
	memset(F_bar_definitions,'\0',100000);

	//all F' definitions
	char* F_definitions = (char*)malloc(100000);
	memset(F_definitions,'\0',100000);


	strcat(F_definitions,get_fun_defs(1,1)); //getting the F_definitions

	

	//definitoins of functions to be synthesized
	printf(""

	//data strcutures to store the state of decisions taken for F and F'
	"//int[%d][%d][%d] state;\n"
	"\n"
	//sketch generator used for synthesizing code
	"generator int _gen(int xReal, int yReal, int bnd)\n"
	"{\n"
	"	assert bnd >= 0;\n"
	"	int t = ??;\n"
	"	//int curr_p = p;\n"
	"	//choices[p++] = t;\n"
	"	if(t == 0) {return xReal;}\n"
	"	if(t == 2) {return yReal;}\n"
	"	int a = _gen(xReal, yReal,  bnd-1);\n"
	"	int b = _gen(xReal, yReal,  bnd-1);\n"
	"	if(t == 4) {return a + b;}\n"
	"	if(t == 5) {return a - b;}\n"
	"	else { return a * b;}\n"
	"}\n"
	"\n"
	"\n"
	//functions of F
	"%s"
	"\n"
	"//----------------------------\n"
	//functions of F'
	"%s"	
	//function to compare the decision state of two different functions
	"int equal(int[8] A, int[8] B)\n"
	"{\n"
	"	for(int i=0;i<8;i++)\n"
	"	{\n"
	"		if(A[i] != B[i])\n"
	"			return 0;\n"
	"	}\n"
	"	return 1;\n"
	"} \n"
	"\n"
	//harness main() sketch code
	"harness int main() {\n"
	"	\n /*"
	"	for(int i=0;i<%d;i++)\n"
	"	{\n"
	"		for(int j=0;j<%d;j++)\n"
	"		{\n"
	"			for(int k=0;k<%d;k++) \n"
	"			{\n"
	"				state[i][j][k] = 0;  \n"
	"			}\n"
	"		}\n"
	"	}\n"
	" */\n"
	//unknown array used for storing the intermediate computation during parsing at each production
	"	int BIG_SIZE = %d;\n"
	"	int[BIG_SIZE] unknown;\n"
	"\n",FUN_STATE_SIZE,NUM_FUNS,last_id,F_definitions,F_bar_definitions,last_id,NUM_FUNS,FUN_STATE_SIZE,BIG_SIZE);


	//reading the input expressions & calling yyparse() on each of the input
	system("wc input > input_stat ");
	FILE* input_stat = fopen("./input_stat","r");
	int num_exp = 0;
	fscanf(input_stat,"%d",&num_exp);
	//printf("number of expression : %d\n",num_exp);
	for(int i=0;i<num_exp;i++)
	{
		yyparse();
        flag = 0;
	}

	//assert statements for F != F1
	printf("\n"
	"\n"
	"	return 0;\n"
	"}\n");

	fclose(input_stat);
	return 0;
}
