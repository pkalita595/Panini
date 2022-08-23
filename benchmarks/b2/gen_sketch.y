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
#include <assert.h>
#include <cstring>
#include <string>
#define  BIG_SIZE 10000
#define FUN_DEF_SIZE 1000
#define ASSERT_STMT_SIZE 200
#define FUN_STATE_SIZE 4
#define NUM_FUNS 1

using namespace std;

int p = 0,offset = 200,code;
int last_id;



%}

%union
{
	int f; //maintains the last allocated pointer address in the current tree
}

%token <f>  ZERO ONE NUM
%type <f> N B R

%%
S : N '=' R '\n'    {
  			printf("\tassert unknown[%d] == %d;\n",p-1,$3);
                        for(int i=2;i<=last_id;i++)
                        {
                                printf("\tassert unknown[%d] == %d;\n",(i-1)*offset+p-1,$3);
                        }
			return 0;
  		}
  ;

N : N B		{
  			printf("\tsyn_fun_a(unknown[%d] , unknown[%d],unknown[%d] );\n", $1, $2,p);
                        for(int i=2;i<=last_id;i++)
                        {
                                printf("\tsyn_fun_a%d(unknown[%d] , unknown[%d],unknown[%d] );\n",i, (i-1)*offset+$1, (i-1)*offset+$2,(i-1)*offset+p);
                        }
                        $$ = p; //store the last allocated pointer position
                        p++;
  		}
  | B		{
			$$ = $1; /* forwarding the last allocated pointer position*/ 
		}
  ;

B : ZERO	{
  			$$ = p;
                        printf("\tunknown[%d] = %d;\n",p,$1);
                        for(int i=2;i<=last_id;i++)
                        {
                                printf("\tunknown[%d] = %d;\n",(i-1)*offset+p,$1);
                        }
                        p++;
		}
  | ONE 	{
			$$ = p;
                        printf("\tunknown[%d] = %d;\n",p,$1);
                        for(int i=2;i<=last_id;i++)
                        {
                                printf("\tunknown[%d] = %d;\n",(i-1)*offset+p,$1);
                        }
                        p++;
		}
  ;

R : NUM		{	$$ = $1; /* integer result of current input binary expression */}
  ;
%%

/*
void yyerror(char *msg)
{
	fprintf(stderr,"%s\n",msg);
	exit(1);
}
*/



void takeSynFun(char* str, long long id){
    char buff[1000] = {'\0'};
    int i = 0;
    char filename[40] = {'\0'};
    //printf("From take %d\n", id);
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
	char *str = (char *)malloc(FUN_DEF_SIZE);
	sprintf(str,"");
	if(curr_code % 2 == 1)
	{
	        sprintf(str,""
        	"void syn_fun_a%s(int x,int y,ref int _out)\n"
        "{\n"
        "       int bnd = 1;\n"
        "       _out =  _gen(x,y,1);  \n"
        "}\n"
        "\n",fun_id,id-1);
	}
	else
	{
	  /*
		sprintf(str,""
	 	"void syn_fun_a%s(int x,int y,ref int _out)\n"
		"{\n"
		"	_out =  x + y;\n"
		"}\n"
		"\n",fun_id);
	*/
	takeSynFun(str, 1);
	}
        return str;
}




//to get the assert statement to ensure Fi != Fj
char * get_assert(int i,int j)
{
        char *str = (char *)malloc(ASSERT_STMT_SIZE);
        sprintf(str,"\tassert ( equal(state[%d][0] , state[%d][0]) == 0 );",i,j);
        return str;
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

	for(int i=2;i<=last_id;i++)
	{
		strcat(F_bar_definitions,get_fun_defs(i,0));
	}
	


        //definitoins of functions to be synthesized
        printf(""

        //data strcutures to store the state of decisions taken for F and F'
        "//int[%d][%d][%d] state;\n"
        "\n"
        //sketch generator used for synthesizing code
        "generator int _gen(int x,int y,int bnd)\n"
        "{\n"
        "       assert bnd >= 0;\n"
        "       int t = ??;\n"
        "       if(t == 0) {return {|(1 | 2 | 3) |} * x;}\n"
        "       if(t == 1) {return {|(1 | 2 | 3) |} * y;}\n"
        "       int a = _gen(x,y,bnd-1);\n"
        "       int b = _gen(x,y,bnd-1);      \n"
        "       if(t == 2) {return a + b;}\n"
        "       if(t == 3) {return a - b;}\n"
        "       if(t == 4) {return a * b;}\n"
        "       else {assert b !=0 ;  return a / b;}\n"
        "}\n"
        "\n"
        "\n"

        "//-------------------------------\n"
        //functions of F
       "%s"
       "\n"
        "//----------------------------\n"
        //functions of F'
        "%s"
        //function to compare the decision state of two different functions
        "/*\n"
        "int equal(int[4] A, int[4] B)\n"
        "{\n"
        "       for(int i=0;i<4;i++)\n"
        "       {\n"
        "               if(A[i] != B[i])\n"
        "                       return 0;\n"
        "       }\n"
        "       return 1;\n"
        "} \n"
        "*/\n"
        //harness main() sketch code
        "harness int main() {\n"
        "       /*\n"
        "       for(int i=0;i<%d;i++)\n"
        "       {\n"
        "               for(int j=0;j<%d;j++)\n"
        "               {\n"
        "                       for(int k=0;k<%d;k++) \n"
        "                       {\n"
        "                               state[i][j][k] = 0;  \n"
        "                       }\n"
        "               }\n"
        "       }\n"
        "       */\n"
        //unknown array used for storing the intermediate computation during parsing at each production
        "       int BIG_SIZE = %d;\n"
        "       int[BIG_SIZE] unknown;\n"
        "\n",FUN_STATE_SIZE,NUM_FUNS,last_id,F_definitions,F_bar_definitions,last_id,NUM_FUNS,FUN_STATE_SIZE,BIG_SIZE);


        //reading the input expressions & calling yyparse() on each of the input
        system("wc input > input_stat ");
        FILE* input_stat = fopen("./input_stat","r");
        int num_exp = 0;
        fscanf(input_stat,"%d",&num_exp);
        fclose(input_stat);
        //printf("number of expression : %d\n",num_exp);
        for(int i=0;i<num_exp;i++)
        {
                yyparse();
		//printf("end of parsing\n");
        }

        

        //assert statements for F != F1
        printf(""
        "\n"
        "       return 0;\n"
        "}\n");

        return 0;
}

