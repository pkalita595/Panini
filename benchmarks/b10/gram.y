%{

extern "C"
{
	int yyparse();
	int yylex(void);
	void yyerror(char *s){}
	int yywrap(void){return 1;}
	void addReal(int x1, int x2, int y1, int y2, int &z);
	void subReal(int x1, int x2, int y1, int y2, int &z);
	void mulReal(int x1, int x2, int y1, int y2, int &z);
	void divideReal(int x1, int x2, int y1, int y2, int &z);
	void sinReal(int x1, int x2, int y1, int y2, int &z);
	void cosReal(int x1, int x2, int y1, int y2, int &z);
	void powReal(int x1, int x2, int y1, int y2, int &z);
	void addDual(int x1, int x2, int y1, int y2, int &z);
	void subDual(int x1, int x2, int y1, int y2, int &z);
	void mulDual(int x1, int x2, int y1, int y2, int &z);
	void divideDual(int x1, int x2, int y1, int y2, int &z);
	void sinDual(int x1, int x2, int y1, int y2, int &z);
	void cosDual(int x1, int x2, int y1, int y2, int &z);
	void powDual(int x1, int x2, int y1, int y2, int &z);
}

#include <cstdio>
#include <cstdlib>
#include <assert.h>
#include <iostream>
#include <string>
#include <map>

struct DualVal {int real; int dual;};
static std::map<std::string, DualVal> vars;
FILE* dev;
char iden[10];
int val = 0;
%}

%union
{
    struct s {
      int real;
      int dual;
    } t;
	int f; //maintains the output value
    int iden;
    std::string *s;
}

%token SIN COS
%token <f>  NUM
%type <t> C E F G K M
%token <t> OUT
%token <s> VAR 

%%

S : C '\n'	{printf("%d,%d\n",$1.real, $1.dual); return 0;}
  ;

C : D ':' M { $$.real = $3.real; $$.dual = $3.dual; };

D : NUM {val = $1;};

M : M M {$$.real = $2.real; $$.dual = $2.dual;}

  | VAR '@' E ';'  {vars[*$1].real = $3.real; vars[*$1].dual = $3.dual; 
    }
  | OUT '@' VAR ';' {$$.real = vars[*$3].real; $$.dual = vars[*$3].dual; 
    }

  | E	{$$.real = $1.real; $$.dual = $1.dual;}
;

E : E '+' F	{
            fprintf(dev, "1\n128\n ");
  			addReal($1.real, $1.dual,$3.real, $3.dual, $$.real);
  			addDual($1.real, $1.dual,$3.real, $3.dual, $$.dual);
		}
  | E '-' F	{
            fprintf(dev, "2\n256\n");
  			subReal($1.real, $1.dual,$3.real, $3.dual, $$.real);
  			subDual($1.real, $1.dual,$3.real, $3.dual, $$.dual);
		}
  | F		{$$.real = $1.real; $$.dual = $1.dual;}

  ;

F : F '*' K	{
            fprintf(dev, "4\n512\n");
  			mulReal($1.real, $1.dual,$3.real, $3.dual, $$.real);
 			mulDual($1.real, $1.dual,$3.real, $3.dual, $$.dual);
		}
  | F '/' K {
            fprintf(dev, "8\n1024\n");
  			divideReal($1.real, $1.dual,$3.real, $3.dual, $$.real);
  			divideDual($1.real, $1.dual,$3.real, $3.dual, $$.dual);
		} 
  | K		{$$.real = $1.real; $$.dual = $1.dual;}
	;

K:  G '^' NUM {
            fprintf(dev, "16\n2048\n");
            powReal($1.real, $1.dual, $3, 0, $$.real);
            powDual($1.real, $1.dual, $3, 0, $$.dual);
        }
  | SIN '(' K ')' {
            fprintf(dev, "32\n4096\n");
  			sinReal($3.real, $3.dual, 0,0, $$.real);
  			sinDual($3.real, $3.dual,0,0, $$.dual);
        }
  | COS '(' K ')' {
            fprintf(dev, "64\n8192\n");
  			cosReal($3.real, $3.dual, 0,0, $$.real);
  			cosDual($3.real, $3.dual, 0,0, $$.dual);
        }
  | G		{$$.real = $1.real; $$.dual = $1.dual;
}
  ;

G : NUM		{ $$.real = $1; $$.dual = 0; }
  | 'x'     { $$.real = val; $$.dual = 1; }
  | VAR     {$$.real = vars[*$1].real; $$.dual = vars[*$1].dual;
}
  ;


%%


int main()
{
	//parse input expression to get output
	FILE* input_stat = fopen("./input_stat","r");
    dev = fopen("getDerivation", "a");
    
	system("wc input > input_stat ");
	int num_exp = 0;
	fscanf(input_stat,"%d",&num_exp);
	//printf("number of expression : %d\n",num_exp);
	for(int i=0;i<num_exp;i++)
	{
		yyparse();
	}
	return 0;
    fclose(dev);
}


