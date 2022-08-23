%{

extern "C"
{
	int yyparse();
	int yylex(void);
	void yyerror(char *s){}
	int yywrap(void){return 1;}
	void syn_plus(int x,int y,int &z);
	void syn_minus(int x,int y,int &z);
	void syn_and(int x,int y,int &z);
	void syn_or(int x,int y,int &z);
	void syn_eq(int x,int y,int &z);
}

#include <cstdio>
#include <cstdlib>
#include <assert.h>

enum type {INT,BOOL,ERROR};

FILE* dev;
%}

%union
{
	int f; //maintains the output value
}

%token <f> NUM TRUE FALSE EQ AND OR
%type <f> exp term 

%%



S : exp '\n'	{printf("%d \n",$1);return 0;}
  ;


exp :   exp '+' term    { fprintf(dev, "1\n");
                             syn_plus($1, $3, $$);
                        }
    |
        exp '-' term    { fprintf(dev, "2\n");
                             syn_minus($1, $3, $$);
                        }
    |

         exp AND term   {fprintf(dev, "4\n");
                             syn_and($1, $3, $$);
                        }
    |
         exp OR term    {fprintf(dev, "8\n");
                             syn_or($1, $3, $$);
                        }
    |

        exp EQ term     {fprintf(dev, "16\n");
                             syn_eq($1, $3, $$);
                        }
    | 

         term             { $$ = $1; }
;

term :  TRUE            { $$ = BOOL;}
    |
        FALSE           { $$ = BOOL;}
    |
        NUM             { $$ = INT;}
    |   '(' exp ')'	{ $$ = $2; }
//    |
//        '(' exp ')'         { $$ = $1;}
;




%%

int main()
{
	//parse input expression to get output
	FILE* input_stat = fopen("./input_stat","r");
	system("wc input > input_stat ");
	int num_exp = 0;
	fscanf(input_stat,"%d",&num_exp);
    dev = fopen("getDerivation", "a");
	//printf("number of expression : %d\n",num_exp);
	for(int i=0;i<num_exp;i++)
	{
		yyparse();
	}
    fclose(dev);
	return 0;
}


