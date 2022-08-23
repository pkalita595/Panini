%{

extern "C"
{
        int yyparse();
        int yylex(void);
	void syn_fun_a(int x,int y,int &out);
        void yyerror(char *s){}
}

#include <cstdio>
#include <cstdlib>
#include <assert.h>

FILE* dev;

%}

%union
{
	int f;
}

%token <f>  ZERO ONE NUM
%type <f> N B 

%%
S : N	'\n'	{printf("%d \n",$1);return 0;}
  ;

N : N B		{fprintf(dev, "1\n"); syn_fun_a($1,$2,$$);}
  | B		{$$ = $1;}
  ;

B : ZERO	{$$ = $1;}
  | ONE 	{$$ = $1;}
  ;
%%

int main()
{
        //parse input expression to get output
        FILE* input_stat = fopen("./input_stat","rke a third 'main.cpp'");
        system("wc input > input_stat ");
        int num_exp = 0;
	dev = fopen("getDerivation", "a");
        fscanf(input_stat,"%d",&num_exp);
        //printf("number of expression : %d\n",num_exp);
        for(int i=0;i<num_exp;i++)
        {
                yyparse();
        }
	fclose(dev);
        return 0;
}

