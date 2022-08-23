%{

extern "C"
{
	int yyparse();
	int yylex(void);
	void yyerror(char *s){}
	int yywrap(void){return 1;}
	void add(int x,int y,int &z);
}

#include <cstdio>
#include <cstdlib>
#include <assert.h>

FILE* dev;
int flag = 0;
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
%type <t>  INT REAL 
%type <t>  E T L S S1
%type <t> M1 M2 M3
%%
S: S1 '\n' {printf("%d\n", $1.offset);}

S1 : E ';' M3 S1  {$$.offset = $4.offset;}
  | E ';'  {$$.offset = $1.offset;}

E : T M1 L  {$$.offset = $3.offset; } /* offset*/


T : INT     {$$.width = 4;}  /* 4 / 8 */

  | REAL    {$$.width = 8;}

L : VAR ',' M2 L { $$.offset = $4.offset; }   

  | VAR    { fprintf(dev, "1\n"); add($<t>0.offset, $<t>0.width, $$.offset); }

    ;
/* productions for VAR are not counted */
VAR : 'a' 
    | 'b' 
    | 'c' 
    | 'd' 

INT : 'i' {};

REAL    : 'r' {};

M1 : {  if(flag) $$.offset = $<t>-1.offset; 
        else{
            $$.offset = 0;
            flag = 1;
        }
        $$.width = $<t>0.width;
 };

M2 : {fprintf(dev, "1\n");  add($<t>-2.offset, $<t>-2.width, $$.offset); $$.width = $<t>-2.width;}; /* add */

M3 : {$$.offset = $<t>-1.offset;}

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


