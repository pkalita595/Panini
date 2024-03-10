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

int isFirst = 1;
int firstAssign = 1;
int p = 0,offset = 200,code;
int last_id;
int val;
int checkCount = 0;

int max(int x,int y)
{
	return  x >= y ? x : y; 
}

%}

%union
{
    struct s {
      int real;
      int dual;
    } t;
	int f; //maintains the last allocated pointer address in the current tree
    int num;
    std::string *s;
}

%token SIN COS OUT
%token <f>  NUM 
%type <f> E F G C K M
%type <t> H 
%token <s> VAR
%%

S : T '\n'	{return 0;}
  ;

T : C '=' H	{
            if(firstAssign){
                printf("\tassert unknown[%d] != unknown[%d];\n", p-2, offset+p-2);
                printf("\tassert unknown[%d] != unknown[%d];\n", p-1, offset+p-1);
                printf("\tassert unknown[%d] == ??(8);\n", offset+p-2);
                printf("\tassert unknown[%d] == ??(8);\n", offset+p-1);
            //firstAssign = 0;
            }
            else{
            ///*
  			printf("\tassert unknown[%d] == %d;\n",p-2,$3.real);
			for(int i=2;i<=last_id;i++)
			{
				printf("\tassert unknown[%d] == %d;\n",(i-1)*offset+p-2,$3.real);
			}
            printf("\tassert unknown[%d] == %d;\n",p-1,$3.dual);
			for(int i=2;i<=last_id;i++)
			{
				printf("\tassert unknown[%d] == %d;\n",(i-1)*offset+p-1,$3.dual);
			}
            //*/
            }
		}
  ; 

C : D ':' M { $$ = $3; };

M : M M {$$ = $2;}
  | VAR '@' E ';' { 
            //vars[*$1].real = $3.real; vars[*$1].dual = $3.dual;
            //$$ = p;
            vars[*$1].real = p;
			printf("\tunknown[%d] = unknown[%d];//vare\n",vars[*$1].real, $3 - 1);
			for(int i=2;i<=last_id;i++)
			{
				printf("\tunknown[%d] = unknown[%d];\n",(i-1)*offset + vars[*$1].real, (i-1)*offset +$3 - 1);
			}
			p++;

            vars[*$1].dual = p;

            //$$ = p;
			printf("\tunknown[%d] = unknown[%d];\n",vars[*$1].dual, $3);
			for(int i=2;i<=last_id;i++)
			{
				printf("\tunknown[%d] = unknown[%d];\n",(i-1)*offset+ vars[*$1].dual, (i-1)*offset +$3);
			}
			p++;

    }

  | OUT '@' VAR ';' {$$ = vars[*$3].dual + 1;}

  | E {$$ = $1;}
;

D : NUM {val = $1; if(isFirst)printf("\nint holeVal = ??;\n");}

E : E '+' F	{

			printf("\taddReal(unknown[%d] , unknown[%d] , unknown[%d] , unknown[%d],unknown[%d] );\n", $1-1, $1, $3-1, $3,p);
			for(int i=2;i<=last_id;i++)
			{
				printf("\taddReal%d(unknown[%d] , unknown[%d] ,unknown[%d] ,unknown[%d],unknown[%d] );\n",i, (i-1)*offset+$1-1,(i-1)*offset+$1,  (i-1)*offset+$3-1, (i-1)*offset+$3, (i-1)*offset+p);
			}
            
            printf("bitCheck[%d] = unknown[%d] != unknown[%d];\n", checkCount++, p, offset+p);
            
			//$$ = p; //store the last allocated pointer position
			p++;

            printf("\taddDual(unknown[%d] , unknown[%d] , unknown[%d] , unknown[%d],unknown[%d] );\n", $1-1, $1, $3-1, $3,p);
			for(int i=2;i<=last_id;i++)
			{
				printf("\taddDual%d(unknown[%d] , unknown[%d] ,unknown[%d] ,unknown[%d],unknown[%d] );\n",i, (i-1)*offset+$1-1,(i-1)*offset+$1,  (i-1)*offset+$3-1, (i-1)*offset+$3, (i-1)*offset+p);
			}

            printf("bitCheck[%d] = unknown[%d] != unknown[%d];\n", checkCount++, p, offset+p);
			$$ = p; //store the last allocated pointer position
			p++;

		}
  | E '-' F	{
	
			printf("\tsubReal(unknown[%d] , unknown[%d] , unknown[%d] , unknown[%d],unknown[%d] );\n", $1-1, $1, $3-1, $3,p);
			for(int i=2;i<=last_id;i++)
			{
				printf("\tsubReal%d(unknown[%d] , unknown[%d] ,unknown[%d] ,unknown[%d],unknown[%d] );\n",i, (i-1)*offset+$1-1,(i-1)*offset+$1,  (i-1)*offset+$3-1, (i-1)*offset+$3, (i-1)*offset+p);
			}

            printf("bitCheck[%d] = unknown[%d] != unknown[%d];\n", checkCount++, p, offset+p);
			//$$ = p; //store the last allocated pointer position
			p++;

            printf("\tsubDual(unknown[%d] , unknown[%d] , unknown[%d] , unknown[%d],unknown[%d] );\n", $1-1, $1, $3-1, $3,p);
			for(int i=2;i<=last_id;i++)
			{
				printf("\tsubDual%d(unknown[%d] , unknown[%d] ,unknown[%d] ,unknown[%d],unknown[%d] );\n",i, (i-1)*offset+$1-1,(i-1)*offset+$1,  (i-1)*offset+$3-1, (i-1)*offset+$3, (i-1)*offset+p);
			}
            printf("bitCheck[%d] = unknown[%d] != unknown[%d];\n", checkCount++, p, offset+p);

			$$ = p; //store the last allocated pointer position
			p++;
		
		}

  | F		{$$ = $1; /* forwarding the last allocated pointer position*/ }
  ;

F : F '*' K	{
	        printf("\tmulReal(unknown[%d] , unknown[%d] , unknown[%d] , unknown[%d],unknown[%d] );\n", $1-1, $1, $3-1, $3,p);
			for(int i=2;i<=last_id;i++)
			{
				printf("\tmulReal%d(unknown[%d] , unknown[%d] ,unknown[%d] ,unknown[%d],unknown[%d] );\n",i, (i-1)*offset+$1-1,(i-1)*offset+$1,  (i-1)*offset+$3-1, (i-1)*offset+$3, (i-1)*offset+p);
			}

            printf("bitCheck[%d] = unknown[%d] != unknown[%d];\n", checkCount++, p, offset+p);
			//$$ = p; //store the last allocated pointer position
			p++;

            printf("\tmulDual(unknown[%d] , unknown[%d] , unknown[%d] , unknown[%d],unknown[%d] );\n", $1-1, $1, $3-1, $3,p);
			for(int i=2;i<=last_id;i++)
			{
				printf("\tmulDual%d(unknown[%d] , unknown[%d] ,unknown[%d] ,unknown[%d],unknown[%d] );\n",i, (i-1)*offset+$1-1,(i-1)*offset+$1,  (i-1)*offset+$3-1, (i-1)*offset+$3, (i-1)*offset+p);
			}

            printf("bitCheck[%d] = unknown[%d] != unknown[%d];\n", checkCount++, p, offset+p);
			$$ = p; //store the last allocated pointer position
			p++;


 		}
    
  | F '/' K     {
	        printf("\tdivideReal(unknown[%d] , unknown[%d] , unknown[%d] , unknown[%d], unknown[%d] );\n", $1-1, $1, $3-1, $3,p);
			for(int i=2;i<=last_id;i++)
			{
				printf("\tdivideReal%d(unknown[%d] , unknown[%d] ,unknown[%d] ,unknown[%d], unknown[%d] );\n",i, (i-1)*offset+$1-1,(i-1)*offset+$1,  (i-1)*offset+$3-1, (i-1)*offset+$3, (i-1)*offset+p);
			}

            printf("bitCheck[%d] = unknown[%d] != unknown[%d];\n", checkCount++, p, offset+p);
			//$$ = p; //store the last allocated pointer position
			p++;

            printf("\tdivideDual(unknown[%d] , unknown[%d] , unknown[%d] , unknown[%d], unknown[%d] );\n", $1-1, $1, $3-1, $3,p);
			for(int i=2;i<=last_id;i++)
			{
				printf("\tdivideDual%d(unknown[%d] , unknown[%d] ,unknown[%d] ,unknown[%d], unknown[%d] );\n",i, (i-1)*offset+$1-1,(i-1)*offset+$1,  (i-1)*offset+$3-1, (i-1)*offset+$3, (i-1)*offset+p);
			}

            printf("bitCheck[%d] = unknown[%d] != unknown[%d];\n", checkCount++, p, offset+p);
			$$ = p; //store the last allocated pointer position
			p++;


		} 
  | K		{$$ = $1;}
    ;
K : G '^' NUM	{
	        printf("\tpowReal(unknown[%d] , unknown[%d] , %d , 0, unknown[%d] );\n", $1-1, $1, $3,p);
			for(int i=2;i<=last_id;i++)
			{
				printf("\tpowReal%d(unknown[%d] , unknown[%d] , %d , 0, unknown[%d] );\n",i, (i-1)*offset+$1-1, (i-1)*offset+$1, $3, (i-1)*offset+p);
			}

            printf("bitCheck[%d] = unknown[%d] != unknown[%d];\n", checkCount++, p, offset+p);
			//$$ = p; //store the last allocated pointer position
			p++;

            	printf("\tpowDual(unknown[%d], unknown[%d], %d, 0, unknown[%d] );\n", $1-1, $1, $3, p);
			for(int i=2;i<=last_id;i++)
			{
				printf("\tpowDual%d(unknown[%d] , unknown[%d] , %d, 0, unknown[%d] );\n",i, (i-1)*offset+$1-1, (i-1)*offset+$1, $3, (i-1)*offset+p);
			}

            printf("bitCheck[%d] = unknown[%d] != unknown[%d];\n", checkCount++, p, offset+p);
			$$ = p; //store the last allocated pointer position
			p++;
 		}
    | G		{$$ = $1;}

    | SIN '(' K ')' {
            printf("\tsinReal(unknown[%d] , unknown[%d] , 0, 0,unknown[%d] );\n", $3-1, $3,p);
            for(int i=2;i<=last_id;i++)
            {
                printf("\tsinReal%d(unknown[%d] , unknown[%d] , 0, 0,unknown[%d] );\n",i, (i-1)*offset+$3-1,(i-1)*offset+$3, (i-1)*offset+p);
            }

            printf("bitCheck[%d] = unknown[%d] != unknown[%d];\n", checkCount++, p, offset+p);
            //$$ = p; //store the last allocated pointer position
            p++;

            printf("\tsinDual(unknown[%d] , unknown[%d] , 0, 0,unknown[%d] );\n", $3-1, $3,p);
            for(int i=2;i<=last_id;i++)
            {
                printf("\tsinDual%d(unknown[%d] , unknown[%d] , 0, 0,unknown[%d] );\n",i, (i-1)*offset+$3-1,(i-1)*offset+$3, (i-1)*offset+p);
            }

            printf("bitCheck[%d] = unknown[%d] != unknown[%d];\n", checkCount++, p, offset+p);
            $$ = p; //store the last allocated pointer position
            p++;

        } 
    | COS '(' K ')' {
            printf("\tcosReal(unknown[%d] , unknown[%d] , 0, 0,unknown[%d] );\n", $3-1, $3,p);
            for(int i=2;i<=last_id;i++)
            {
                printf("\tcosReal%d(unknown[%d] , unknown[%d] , 0, 0,unknown[%d] );\n",i, (i-1)*offset+$3-1,(i-1)*offset+$3, (i-1)*offset+p);
            }

            printf("bitCheck[%d] = unknown[%d] != unknown[%d];\n", checkCount++, p, offset+p);
            //$$ = p; //store the last allocated pointer position
            p++;

            printf("\tcosDual(unknown[%d] , unknown[%d] , 0, 0,unknown[%d] );\n", $3-1, $3,p);
            for(int i=2;i<=last_id;i++)
            {
                printf("\tcosDual%d(unknown[%d] , unknown[%d] , 0, 0,unknown[%d] );\n",i, (i-1)*offset+$3-1,(i-1)*offset+$3, (i-1)*offset+p);
            }

            printf("bitCheck[%d] = unknown[%d] != unknown[%d];\n", checkCount++, p, offset+p);
            $$ = p; //store the last allocated pointer position
            p++;
        } 
    ;

G :   NUM	{
  			$$ = p;
			printf("\tunknown[%d] = %d;\n",p,$1);
			for(int i=2;i<=last_id;i++)
			{
				printf("\tunknown[%d] = %d;\n",(i-1)*offset+p,$1);
			}
			p++;

            $$ = p;
			printf("\tunknown[%d] = 0;\n",p);
			for(int i=2;i<=last_id;i++)
			{
				printf("\tunknown[%d] = 0;\n",(i-1)*offset+p);
			}
			p++;
		}
    | 'x' {
  			$$ = p;
            if(isFirst)
			printf("\tunknown[%d] = holeVal;\n",p);
            else
			printf("\tunknown[%d] = %d;\n",p,val);
			for(int i=2;i<=last_id;i++)
			{
                if(isFirst)
				printf("\tunknown[%d] = unknown[%d];\n",(i-1)*offset+p, p);
                else
				printf("\tunknown[%d] = %d;\n",(i-1)*offset+p,val);
			}
			p++;
            //isFirst = 0;
            $$ = p;
			printf("\tunknown[%d] = 1;\n",p);
			for(int i=2;i<=last_id;i++)
			{
				printf("\tunknown[%d] = 1;\n",(i-1)*offset+p);
			}
			p++;
		}
    | VAR     {$$ = vars[*$1].dual;}
  ;

H : NUM ',' NUM		{$$.real = $1; $$.dual = $3; }
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
	if(1)
	{
		sprintf(str,""
		"void addReal(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       int  p = 0;\n"
        "       int bnd = 1;\n"
        "       _out =  _gen(xReal, xDual, yReal, yDual, 1);  \n"
        "}\n"
        "\n",fun_id,id-1);
		sprintf(str+strlen(str),""
		"void addReal2(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       _out =  xReal + yReal;\n"
        "}\n"
        "\n",fun_id);
	}

	curr_code = curr_code / 2;

	if(1)
	{
		sprintf(str+strlen(str),""
		"void subReal(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       int  p = 0;\n"
        "       int bnd = 1;\n"
        "       _out =  _gen(xReal, xDual, yReal, yDual,1);  \n"
        "}\n",fun_id,id-1);
		sprintf(str+strlen(str),""
		"void subReal2(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       _out =  xReal - yReal;\n"
        "}\n",fun_id);
        
	}

	curr_code = curr_code / 2;

	if(1)
	{
		sprintf(str+strlen(str),""
		"void mulReal(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       int  p = 0;\n"
        "       int bnd = 1;\n"
        "       _out =  _gen(xReal, xDual, yReal, yDual,1);  \n"
        "}\n",fun_id,id-1);
		sprintf(str+strlen(str),""
		"void mulReal2(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       _out =  xReal * yReal;\n"
        "}\n",fun_id);
        
	}
	

	curr_code = curr_code / 2;

	if(0)
	{
		sprintf(str+strlen(str),""
		"void divideReal(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       int  p = 0;\n"
        "       int  r = 0;\n"
        "       int bnd = 1;\n"
        "       _out =  _gen(xReal, xDual, yReal, yDual,  1)/_gen(xReal, xDual, yReal, yDual, 1);  \n"
        "}\n",fun_id,id-1, id-1);
		sprintf(str+strlen(str),""
		"void divideReal2(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       _out =  xReal / yReal;\n"
        "}\n",fun_id);
	}
    
	curr_code = curr_code / 2;


    if(1)
	{
		sprintf(str+strlen(str),""
		"void powReal(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       int  p = 0;\n"
        "       int bnd = 1;\n"
        "       _out =  _genFunPow(xReal, xDual, yReal, yDual, 1);  \n"
        "}\n",fun_id,id-1);
		sprintf(str+strlen(str),""
		"void powReal2(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "         pow(xReal, yReal, _out);\n"
        "}\n",fun_id);
	}
    
	curr_code = curr_code / 2;



    if(1)
	{
		sprintf(str+strlen(str),""
		"void sinReal(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       int  p = 0;\n"
        "       int bnd = 1;\n"
        "       _out =  _genFun(xReal, xDual, yReal, yDual,  2);  \n"
        "}\n",fun_id,id-1);
		sprintf(str+strlen(str),""
		"void sinReal2(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "        sin(xReal, _out);\n"
        "}\n",fun_id);
	}
    
	curr_code = curr_code / 2;

    if(1)
	{
		sprintf(str+strlen(str),""
		"void cosReal(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       int  p = 0;\n"
        "       int bnd = 1;\n"
        "       _out =  _genFun(xReal, xDual, yReal, yDual,  2);  \n"
        "}\n",fun_id,id-1);

		sprintf(str+strlen(str),""
		"void cosReal2(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       cos(xReal,_out);\n"
        "}\n",fun_id);
	}
    
	curr_code = curr_code / 2;

    //Dual functions
    if(1)
	{
		sprintf(str+strlen(str),""
		"void addDual(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       int  p = 0;\n"
        "       int bnd = 1;\n"
        "       _out =  _gen(xReal, xDual, yReal, yDual, 1);  \n"
        "}\n"
        "\n",fun_id,id-1);
		sprintf(str+strlen(str),""
		"void addDual2(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       _out =  xDual + yDual;\n"
        "}\n"
        "\n",fun_id);
	}

	curr_code = curr_code / 2;

	if(1)
	{
		sprintf(str+strlen(str),""
		"void subDual(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       int  p = 0;\n"
        "       int bnd = 1;\n"
        "       _out =  _gen(xReal, xDual, yReal, yDual,1);  \n"
        "}\n",fun_id,id-1);
		sprintf(str+strlen(str),""
		"void subDual2(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       _out =  xDual - yDual;\n"
        "}\n",fun_id);
	}

	curr_code = curr_code / 2;

	if(1)
	{
		sprintf(str+strlen(str),""
		"void mulDual(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       int  p = 0;\n"
        "       int bnd = 2;\n"
        "       _out =  _genMul(xReal, xDual, yReal, yDual,3);  \n"
        "}\n",fun_id,id-1);
		sprintf(str+strlen(str),""
		"void mulDual2(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       _out =  xReal * yDual + xDual * yReal;\n"
        "}\n",fun_id);
	}
	

	curr_code = curr_code / 2;

	if(0)
	{
		sprintf(str+strlen(str),""
		"void divideDual%s(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       int  p = 0;\n"
        "       int  r = 0;\n"
        "       int bnd = 2;\n"
        "       _out =  _gen(xReal, xDual, yReal, yDual, 3) / _gen(xReal, xDual, yReal, yDual, 1);  \n"
        "}\n",fun_id,id-1, id-1);
	}
	else
	{
        /*
		sprintf(str+strlen(str),""
		"void divideDual%s(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       _out =  (xDual * yReal - xReal * yDual) / (yReal * yReal);\n"
        "}\n",fun_id);
        */
        
        takeSynFun(str+strlen(str), 1024);
	}

	curr_code = curr_code / 2;

    if(1)
	{
		sprintf(str+strlen(str),""
		"void powDual(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       int  p = 0;\n"
        "       int bnd = 1;\n"
        "       _out =  _genFunPow(xReal, xDual, yReal, yDual,  3);  \n"
        "}\n",fun_id,id-1);
		sprintf(str+strlen(str),""
		"void powDual2(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       pow(xReal, yReal - 1, _out); _out =  xDual * yReal * _out;\n"
        "}\n",fun_id);
	}


	curr_code = curr_code / 2;

    if(1)
	{
		sprintf(str+strlen(str),""
		"void sinDual(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       int  p = 0;\n"
        "       int bnd = 1;\n"
        "       _out =  _genFun(xReal, xDual, yReal, yDual,  2);  \n"
        "}\n",fun_id,id-1);
		sprintf(str+strlen(str),""
		"void sinDual2(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "     cos(xReal, _out);  _out =  _out * xDual;\n"
        "}\n",fun_id);
	}
    
	curr_code = curr_code / 2;

    if(1)
	{
		sprintf(str+strlen(str),""
		"void cosDual(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "       int  p = 0;\n"
        "       int bnd = 1;\n"
        "       _out =  _genFun(xReal, xDual, yReal, yDual,  2);  \n"
        "}\n",fun_id,id-1);
		sprintf(str+strlen(str),""
		"void cosDual2(int xReal, int xDual, int yReal, int yDual, ref int _out)\n"
        "{\n"
        "     sin(xReal, _out);   _out = _out * -xDual;\n"
        "}\n",fun_id);

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

char* getCheckAssert(){
               //     printf("\tbitCheck[%d] = stk.head.val != stk_2.head.val;\n", checkCount++);
               //     printf("\tbitCheck[%d] = pc[1] != pc[2];\n", checkCount++);
    char *str = (char *)malloc(ASSERT_STMT_SIZE);
    sprintf(str,"\tassert ( ");
    for(int i = 0; i < checkCount; i++){
        sprintf(str+strlen(str), " bitCheck[%d] || ", i);
    }
    sprintf(str+strlen(str)," false );\n");
    return str;
}

int main(int argc,char **argv)
{
	code = atoi(argv[1]);

	//get the current F_bar_id
	FILE *f_bar = fopen("last_F_bar_id","r");
	if(1)
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
/*
	for(int i=2;i<=last_id;i++)
	{
		strcat(F_bar_definitions,get_fun_defs(i,0));
	}
*/	

	//definitoins of functions to be synthesized
	printf(""

	//data strcutures to store the state of decisions taken for F and F'
	"//int[%d][%d][%d] state;\n"
    "bit[1000] bitCheck;\n"
	"\n"
	//sketch generator used for synthesizing code
	"generator int _gen(int xReal, int xDual, int yReal, int yDual,int bnd)\n"
	"{\n"
	"	assert bnd >= 0;\n"
	"	int t = ??;\n"
	"	//int curr_p = p;\n"
	"	//choices[p++] = t;\n"
	"	if(t == 0) {return xReal;}\n"
	"	if(t == 1) {return xDual;}\n"
	"	if(t == 2) {return yReal;}\n"
	"	if(t == 3) {return yDual;}\n"
	"	int a = _gen(xReal, xDual, yReal, yDual,  bnd-1);\n"
	"	int b = _gen(xReal, xDual, yReal, yDual,  bnd-1);\n"
	"	if(t == 4) {return a + b;}\n"
	"	if(t == 5) {return a - b;}\n"
	"	else { return a * b;}\n"
	//"	else {assert b != 0 ; choices[curr_p]=7; /*double c = (double)a; double d = (double)b; double div = c/d; return (int)div * 10;*/ return a/b;}\n"
	"}\n"
	"\n"
	"\n"

	"//-------------------------------\n"
    //sketch generator used for synthesizing code
	"generator int _genFun(int xReal, int xDual, int yReal, int yDual,int bnd)\n"
	"{\n"
	"	assert bnd >= 0;\n"
	"	int t = ??;\n"
	"//	int curr_p = p;\n"
	"//	choices[p++] = t;\n"
	"	if(t == 0) {return xReal;}\n"
	"	if(t == 1) {return xDual;}\n"
	"	if(t == 2) {return yReal;}\n"
	"	if(t == 3) {return 1;}\n"
	"	if(t == 2) {return -1;}\n"
    	"  	if(t == 4) {int ot; sin(xReal, ot); return ot;}\n" 
    	"  	if(t == 5) {int ot; cos(xReal, ot); return ot;}\n" 
	"	int a = _genFun(xReal, xDual, yReal, yDual,  bnd-1);\n"
	"	int b = _genFun(xReal, xDual, yReal, yDual,  bnd-1);\n"
    	"//  	if(t == 6) {return pow(xReal, a);}\n"
    	//" 	if(t == 11) {return pow(xReal, b);}\n"
	//"	if(t == 10) {return -a;}\n"
	//"	if(t == 11) {return a;}\n"
	"	if(t == 7) {return a + b;}\n"
	"	if(t == 8) {return a - b;}\n"
	"	else { return a * b;}\n"
	"}\n"
	"\n"
	"\n"
    "generator int select(int a, int b, int c, int d){\n"
    "    int t = ??;\n"
    "    if(t == 1){ return a;}\n"
    "    if(t == 2){ return b;}\n"
    "    if(t == 3){ return c;}\n"
    "    if(t == 4){ return d;}\n"
    "}\n"

    "generator int _genMul2(int x, int y, int w, int z,int bnd){\n"
    "    assert bnd >= 0;\n"
    "    int t = ??;\n" 
    "    if(t == 1) { return x * y;}\n"
    "    if(t == 2) { return x + y;}\n"
    "    if(t == 3) { return x * y + w * z;}\n"
    "//    if(t == 4) { return x * y - w * z;}\n"
    "}\n"

    "generator int _genMul(int xReal, int xDual, int yReal, int yDual,int bnd)\n"
    "{\n"
    "    assert bnd >= 0;\n"
    "    int t = ??;\n"
    "    int a = select(xReal, xDual, yReal, yDual);\n"
    "    int b = select(xReal, xDual, yReal, yDual);\n"
    "    int c = select(xReal, xDual, yReal, yDual);\n"
    "    int d = select(xReal, xDual, yReal, yDual);\n"
    "    return _genMul2(a, b, c, d, 2);\n"
    "}\n"

	"//-------------------------------\n"
    //sketch generator used for synthesizing code
	"generator int _genFunPow(int xReal, int xDual, int yReal, int yDual,int bnd)\n"
	"{\n"
	"	assert bnd >= 0;\n"
	"	int t = ??;\n"
	"//	int curr_p = p;\n"
	"//	choices[p++] = t;\n"
	"	if(t == 0) {return xReal;}\n"
	"	if(t == 1) {return xDual;}\n"
	"	if(t == 2) {return yReal;}\n"
	"	if(t == 3) {return 1;}\n"
	"	if(t == 2) {return -1;}\n"
	"//  	if(t == 4) {return sin(xReal);}\n" 
    	"//  	if(t == 5) {return cos(xReal);}\n" 
	"	int a = _genFunPow(xReal, xDual, yReal, yDual,  bnd-1);\n"
	"	int b = _genFunPow(xReal, xDual, yReal, yDual,  bnd-1);\n"
    	"  	if(t == 6) {int o ; pow(xReal, a, o); return o;}\n"
    	//" 	if(t == 11) {return pow(xReal, b);}\n"
	//"	if(t == 10) {return -a;}\n"
	//"	if(t == 11) {return a;}\n"
	"	if(t == 7) {return a + b;}\n"
	"	if(t == 8) {return a - b;}\n"
	"	else { return a * b;}\n"
	"}\n"
	"\n"
	"\n"

    "void sin(int a, ref int _out){\n"
    " //  double x = (double)a;\n"
    " //  double val = x - ((x*x*x)/6.0) * 10.0;\n"
    " //  return (int)val;\n"
    "   _out= a - ((a * a * a)/6 ) ;\n"
    "}\n"
    "\n"
    "void cos(int a, ref int _out){\n"
    "   //double x = (double)a;\n"
    "   //double val = 1.0 - ((x*x)/2.0) * 10.0;\n"
    "   //return (int)val;\n"
    "    _out = 1 - ((a * a)/2);\n"
    "}\n"
    "\n"
    "void pow(int x, int y, ref int _out){\n"
    "   int val = 1;\n"
    "   if(y < 0){"
    "        y = -y;"
    "        for(int i = 0; i < y; i++) \n"
    "            val = val / x; \n"
    "        _out = val;\n"
    "   }\n"
    "   for(int i = 0; i < y; i++) val = val * x;\n"
    "   _out = val;\n"
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
        if(i == 0){
            isFirst = 0;
            firstAssign = 0;
        }
	}

	char *assert_stmts = (char*)malloc(sizeof(char) * 5000); //nc2 ways * 200 bytes for each pair assert
	//char *assert_stmts = (char*)malloc(last_id * (last_id -1) * 1000); //nc2 ways * 200 bytes for each pair assert
	//memset(assert_stmts,'\0', last_id * (last_id -1) * 1000);

    /*
    char assert_stmts[3000] = {'\0'};
    char temp[1000] = {'\0'};
	for(int i=0;i<last_id-1;i++)
	{
		for(int j=i+1;j<last_id;j++)
		{
            get_assert(i,j, temp);
			strcat(assert_stmts, temp);
		}
	}
    
	//assert statements for F != F1
	printf("\n"
	"\n"
	"	return 0;\n"
	"}\n");
    */

    //strcpy(assert_stmts, getCheckAssert());

    //assert statements for F != F1
    printf("%s\n"
    "\n"
    "   return 0;\n"
    "}\n");//,assert_stmts);


	fclose(input_stat);
	return 0;
}
