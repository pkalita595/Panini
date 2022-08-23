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
#define  BIG_SIZE 10000
#define FUN_DEF_SIZE 2000
#define ASSERT_STMT_SIZE 300
#define FUN_STATE_SIZE 4
#define NUM_FUNS 5

enum type {INT,BOOL,ERROR};
int p = 0,offset = 200;
int last_id;

int max(int x,int y)
{
	return  x >= y ? x : y; 
}

%}

%union
{
	int f; //maintains the last allocated pointer address in the current tree
}

%token <f> NUM TRUE FALSE EQ AND OR
%type <f> exp term T


%%



S : T '\n'    {/*printf("%d \n",$1);*/ return 0;}
  ;

T : exp '=' NUM {
    
                 printf("\tassert unknown[%d] == %d;\n",p-1,$3);
                for(int i=2;i<=last_id;i++)
                {
                    printf("\tassert unknown[%d] == %d;\n",(i-1)*offset+p-1,$3);
                }

                }
;

exp :   exp '+' term       {
                printf("\t syn_plus(unknown[%d] , unknown[%d], unknown[%d]) ;\n",  $1, $3, p);
                for(int i=2;i<=last_id;i++)
                {
                    printf("\tsyn_plus%d(unknown[%d] , unknown[%d], unknown[%d]);\n", i, (i-1)*offset+$1, (i-1)*offset+$3,(i-1)*offset+p);
                }
                $$ = p; //store the last allocated pointer position
                p++;

                           }
    |
        exp '-' term       {    
                printf("\t syn_minus(unknown[%d] , unknown[%d], unknown[%d]) ;\n", $1, $3, p);
                for(int i=2;i<=last_id;i++)
                {
                    printf("\t syn_minus%d(unknown[%d] , unknown[%d], unknown[%d]);\n", i, (i-1)*offset+$1, (i-1)*offset+$3,(i-1)*offset+p);
                }
                $$ = p; //store the last allocated pointer position
                p++;

                           }
    |

         exp AND term       { 
                printf("\t syn_and(unknown[%d] , unknown[%d], unknown[%d]) ;\n", $1, $3, p);
                for(int i=2;i<=last_id;i++)
                {
                    printf("\tsyn_and%d(unknown[%d] , unknown[%d], unknown[%d]);\n", i, (i-1)*offset+$1, (i-1)*offset+$3,(i-1)*offset+p);
                }
                $$ = p; //store the last allocated pointer position
                p++;


                            }
    |
         exp OR term       { 
                printf("\t syn_or(unknown[%d] , unknown[%d], unknown[%d]) ;\n", $1, $3, p);
                for(int i=2;i<=last_id;i++)
                {
                    printf("\tsyn_or%d(unknown[%d] , unknown[%d], unknown[%d]);\n",i, (i-1)*offset+$1, (i-1)*offset+$3,(i-1)*offset+p);
                }
                $$ = p; //store the last allocated pointer position
                p++;


                           }
    |


        exp EQ term       { 
                printf("\t  syn_eq(unknown[%d] , unknown[%d], unknown[%d]) ;\n",  $1, $3, p);
                for(int i=2;i<=last_id;i++)
                {
                    printf("\tsyn_eq%d(unknown[%d] , unknown[%d], unknown[%d]);\n", i, (i-1)*offset+$1, (i-1)*offset+$3,(i-1)*offset+p);
                }
                $$ = p; //store the last allocated pointer position
                p++;

                          }
    | 

         term             { $$ = $1; }
;

term :  TRUE            {  
                             $$ = p;
                            printf("\tunknown[%d] = %d;\n",p,BOOL);
                            for(int i=2;i<=last_id;i++)
                            {
                                printf("\tunknown[%d] = %d;\n",(i-1)*offset+p,BOOL);
                            }
                            p++;

                        }
 
term :  '(' exp ')'     {  
                            $$ = $2;
                        }
    |
        FALSE           {
                            $$ = p;
                            printf("\tunknown[%d] = %d;\n",p,BOOL);
                            for(int i=2;i<=last_id;i++)
                            {
                                printf("\tunknown[%d] = %d;\n",(i-1)*offset+p,BOOL);
                            }
                            p++;

                        }
    |
        NUM             { 
                            $$ = p;
                            printf("\tunknown[%d] = %d;\n",p,INT);
                            for(int i=2;i<=last_id;i++)
                            {
                                printf("\tunknown[%d] = %d;\n",(i-1)*offset+p,INT);
                            }
                            p++;

                        }

;

%%


/*
void yyerror(char *msg)
{
	fprintf(stderr,"%s\n",msg);
	exit(1);
}*/


char* get_fun_defs(int id)
{
	char *str = (char *)malloc(FUN_DEF_SIZE);
	sprintf(str,""
        "void syn_or%d(int x,int y, ref int _out)\n"
        "{\n"
  /*      "       "
        "       int p = 0;\n"
        "       if( _gen(x,y,state[%d][0],p,1)){  \n"
        "       \t _out = 1;}\n"
        "       else {\n"
        "       \t _out = 2;"
        "}\n"
*/
        // Oracle function
        "       if ((x == BOOL) && (y == BOOL))"
        "           _out = BOOL;\n"
        "       else \n"
        "            _out = ERROR;"
        "}\n"
        "\n"
        "\n"
        "void syn_and%d(int x,int y, ref int _out)\n"
         "{\n"
/*
        "       "
        "       int p = 0;\n"
        "       if( _gen(x,y,state[%d][1],p,1)){  \n"
        "       \t _out = 1;}\n"
        "       else {\n"
        "       \t _out = 2;"
        "}\n"
*/
        "       if ((x == BOOL) && (y == BOOL))"
        "           _out = BOOL;\n"
        "       else \n"
        "            _out = ERROR;"
        
      
        "}\n"
        "\n"
        "\n"
        "void syn_eq%d(int x,int y, ref int _out)\n"
          "{\n"
        "       "
        "       int p = 0;\n"
        "       if( _gen(x,y,state[%d][2],p,1)){  \n"
        "       \t _out = 1;}\n"
        "       else {\n"
        "       \t _out = 2;"
        "}\n"        
       
        "}\n"
        "\n\n"
        "void syn_plus%d(int x,int y, ref int _out)\n"
        "{\n"
        "       "
 /*       "       int p = 0;\n"
        "       if( _gen(x,y,state[%d][3],p,1)){  \n"
        "       \t _out = 0;}\n"
        "       else {\n"
        "       \t _out = 2;"
        "}\n"
*/
        "       if ((x == INT) && (y == INT))"
        "           _out = INT;\n"
        "       else \n"
        "            _out = ERROR;"


        "}\n"
        "\n\n"
        "void syn_minus%d(int x,int y, ref int _out)\n"
        "{\n"
/*        "       "
        "       int p = 0;\n"
        "       if( _gen(x,y,state[%d][4],p,1)){  \n"
        "       \t _out = 0;}\n"
        "       else {\n"
        "       \t _out = 2;"
        "}\n"
  */
        "       if ((x == INT) && (y == INT))"
        "           _out = INT;\n"
        "       else \n"
        "            _out = ERROR;"


        "}\n"
 
        "\n\n",/*id,id-1,id,id-1,id,id-1,id,id-1,id,id-1*/ id,id,id,id-1,id,id);
	return str;
}


//to get the assert statement to ensure Fi != Fj
char * get_assert(int i,int j)
{
	char *str = (char *)malloc(ASSERT_STMT_SIZE);
	sprintf(str,"\tassert ( equal(state[%d][0] , state[%d][0]) == 0  ||  equal(state[%d][1] , state[%d][1]) == 0 ||   equal(state[%d][2] , state[%d][2]) == 0  ||  equal(state[%d][3] , state[%d][3]) == 0 ||    equal(state[%d][4] , state[%d][4]) == 0);\n",i,j,i,j,i,j,i,j,i,j);
	return str; 
}

int main()
{

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
	
	for(int i=2;i<=last_id;i++)
	{
		strcat(F_bar_definitions,get_fun_defs(i));
	}
	

	//definitoins of functions to be synthesized
	printf(""
    //"bool cond;\n"
	//Macro for INT , BOOL and ERROR
    "#define INT 0\n"
    "#define BOOL 1\n"
    "#define ERROR 2\n"

    //data strcutures to store the state of decisions taken for F and F'
	"int[%d][%d][%d] state;\n"
	"\n"
	//sketch generator used for synthesizing code
	"generator bit _gen(int x,int  y,ref int[4] choices,ref int p,int bnd)\n"
	"{\n"
	"	assert bnd >= 0;\n"
	"	int t = ??;\n"
	"	int curr_p = p;\n"
	"	choices[p++] = t;\n"
	"	if(t == 0) {return (x == INT);}\n"
	"	if(t == 1) {return (x == BOOL);}\n"
	"	if(t == 2) {return (y == INT);}\n"
	"	if(t == 3) {return (y == BOOL);}\n"	
   	"	if(t == 4) {return (x != ERROR);}\n"
/*	"	if(t == 5) {return (y != ERROR);}\n"
	"	if(t == 6) {return (x == ERROR);}\n"
	"	if(t == 7) {return (y == ERROR);}\n"
	"	if(t == 8) {return (x != INT);}\n"
	"	if(t == 9) {return (x != BOOL);}\n"
	"	if(t == 10) {return (y != INT);}\n"
	"	if(t == 11) {return (y != BOOL);}\n"
	"	if(t == 12) {return (x != y);}\n"
*/
	"	if(t == 5) {return (x == y);}\n"
    	"	bit a = _gen(x,y,choices,p,bnd-1);\n"
	"	bit b = _gen(x,y,choices,p,bnd-1);\n"
	"	if(t == 6) {return a || b;}\n"
	"	else {\n"
	"	choices[curr_p] = 7;\n"
	"	return a && b;}\n"
	"}\n"
	"\n"
	"\n"

	"//-------------------------------\n"

	//functions of F
        "void syn_or(int x,int y, ref int _out)\n"
        "{\n"
  /*      "       "
        "       int p = 0;\n"
        "       if( _gen(x,y,state[0][0],p,1)){  \n"
        "       \t _out = 1;}\n"
        "       else {\n"
        "       \t _out = 2;"
        "}\n"
    */
        "       if ((x == BOOL) && (y == BOOL))"
        "           _out = BOOL;\n"
        "       else \n"
        "            _out = ERROR;"

        "}\n"
        "\n"
        "\n"
        "void syn_and(int x,int y, ref int _out)\n"
        "{\n"
/*        "       "
        "       int p = 0;\n"
        "       if( _gen(x,y,state[0][1],p,1)){  \n"
        "       \t _out = 1;}\n"
        "       else {\n"
        "       \t _out = 2;"
       "}\n"
*/ 
        "       if ((x == BOOL) && (y == BOOL))"
        "           _out = BOOL;\n"
        "       else \n"
        "            _out = ERROR;"

 
       "}\n"
        "\n"
        "\n"
        "void syn_eq(int x,int y, ref int _out)\n"
        "{\n"
        "       "
        "       int p = 0;\n"
        "       if( _gen(x,y,state[0][2],p,1)){  \n"
        "       \t _out = 1;}\n"
        "       else {\n"
        "       \t _out = 2;"
        "}\n"
        "}\n"
         "\n\n"
        "void syn_plus(int x,int y, ref int _out)\n"
        "{\n"
/*        "       "
        "       int p = 0;\n"
        "       if( _gen(x,y,state[0][3],p,1)){  \n"
        "       \t _out = 0;}\n"
        "       else {\n"
        "       \t _out = 2;"

        "}\n"
*/
        "       if ((x == INT) && (y == INT))"
        "           _out = INT;\n"
        "       else \n"
        "            _out = ERROR;"


        "}\n"
         "\n\n"
        "void syn_minus(int x,int y,ref int _out)\n"
        "{\n"
        "       "
/*
        "       int p = 0;\n"
        "       if( _gen(x,y,state[0][4],p,1)){  \n"
        "       \t _out = 0;}\n"
        "       else {\n"
        "       \t _out = 2;"

        "}\n"
*/

        "       if ((x == INT) && (y == INT))"
        "           _out = INT;\n"
        "       else \n"
        "            _out = ERROR;"

        "}\n"
         "\n\n"
	"//----------------------------\n"
	//functions of F'
	"%s"	
	//function to compare the decision state of two different functions
	"int equal(int[4] A, int[4] B)\n"
	"{\n"
	"	for(int i=0;i<4;i++)\n"
	"	{\n"
	"		if(A[i] != B[i])\n"
	"			return 0;\n"
	"	}\n"
	"	return 1;\n"
	"} \n"
	"\n"
	//harness main() sketch code
	"harness int main() {\n"
	"	\n"
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
	"\n"
	//unknown array used for storing the intermediate computation during parsing at each production
	"	int BIG_SIZE = %d;\n"
	"	int[BIG_SIZE] unknown;\n"
	"\n",FUN_STATE_SIZE,NUM_FUNS,last_id,F_bar_definitions,last_id,NUM_FUNS,FUN_STATE_SIZE,BIG_SIZE);


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
	}

	char *assert_stmts = (char*)malloc(100*(last_id)*(last_id-1)); //nc2 ways * 200 bytes for each pair assert
	memset(assert_stmts,'\0',100*(last_id)*(last_id-1));
	for(int i=0;i<last_id-1;i++)
	{
		for(int j=i+1;j<last_id;j++)
		{
			strcat(assert_stmts,get_assert(i,j));
		}
	}

	//assert statements for F != F1
	printf("%s\n"
	"\n"
	"	return 0;\n"
	"}\n",assert_stmts);

	return 0;
}
