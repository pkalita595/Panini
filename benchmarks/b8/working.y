%{

extern "C"
{
	int yyparse();
	int yylex(void);
	void yyerror(char *s){}
	int yywrap(void){return 1;}
	void add(int x,int y,int &z);
	void sub(int x,int y,int &z);
	void mul(int x,int y,int &z);
	void divide(int x,int y,int &z);
}

#include <cstdio>
#include <cstdlib>
#include <assert.h>

FILE* dev;

%}

%union
{
     struct s {
      int width;
      int offset;
    } t;
	int f; //maintains the output value
    char str[10];
    char v;
}

%token NUM
%type <f>  E T L INT REAL S
%type <f> M1 M2 M3 M4

%%

S : E ';' M3 S  {}
  | E ';'  {$$ = $1;}

E : T M1 L  {$$ = $3; printf("E: %d\n", $$); } /* offset*/


T : INT     {$$ = 4;}  /* 4 / 8 */

  | REAL    {$$ = 8;}

L : VAR ',' M2 L { printf("a = %d\n",  $<f>0); $$ = $4; printf("doubt 1: %d \n", $3);}   

  | VAR    {printf("a = %d\n", $<f>0); $$ = $<f>0 + 4; printf("doubt 2: %d \n", $$);}

    ;

VAR : 'a' 
    | 'b'
    | 'c'
    | 'd'

INT : 'i' {};

REAL    : 'r' {};

M1 : { $$ = $<f>-1; };

M2 : {$$ = $<f>-2 + 4;}; /* add */

M3 : {$$ = $<f>-1;}

M4 : {$$ = 0;}
%%


int main()
{
	//parse input expression to get output
	FILE* input_stat = fopen("./input_stat","r");
	system("wc input > input_stat ");
	int num_exp = 1;
	//fscanf(input_stat,"%d",&num_exp);
    dev = fopen("getDerivation", "a");
	//printf("number of expression : %d\n",num_exp);
	for(int i=0;i<num_exp;i++)
	{
		yyparse();
	}
    fclose(dev);
	return 0;
}


