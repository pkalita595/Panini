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
	int f; //maintains the output value
}

%token <f>  NUM
%type <f> E F 

%%

S : E '\n'	{printf("%d \n",$1);return 0;}
  ;


E :  '+' E E 	{	fprintf(dev, "1\n");
  			add($2,$3,$$);
		}
  |  '-' E E	{	fprintf(dev, "2\n");
			sub($2,$3,$$);
		}
  |  '*' E E	{	fprintf(dev, "4\n");
			mul($2,$3,$$);
		}
  |  '/' E E	{	fprintf(dev, "8\n");
			divide($2,$3,$$);
		}
  | F		{	$$ = $1; }
  ;


F : NUM		{$$ = $1;}
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


