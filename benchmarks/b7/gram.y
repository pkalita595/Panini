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
#include <string.h>

FILE* dev;
%}

%union
{
	int f; //maintains the output value
    char c[10];
}

%token <c> COND
%token <f> IF  NUM THEN ELSE
%type <f> E F G X 

%%

S : X '\n'	{printf("%d \n",$1);return 0;}
  ;

X : E {$$ = $1;}
    
    | IF '(' E COND E ')' THEN E ';'  ELSE E ';' {
    

        if (!strcmp($4,"<"))
            $$ = ($3 < $5 ? $8 : $11) ;
        else if (!strcmp($4,"<="))
            $$ = ( $3 <= $5 ? $8 : $11) ;
        if (!strcmp($4,">"))
            $$ = ( $3 > $5 ? $8 : $11 );
        else if (!strcmp($4,">="))
            $$ = ( $3 >= $5 ? $8 : $11 );
        if (!strcmp($4,"=="))
            $$ = ( $3 == $5 ? $8 : $11 );
        else if (!strcmp($4,"!="))
            $$ = ( $3 != $5 ? $8 : $11 );

    }
    
;


E : E '+' F	{	
			fprintf(dev, "1\n");
  			add($1,$3,$$);
		}
  | E '-' F	{
		        fprintf(dev, "2\n");
			sub($1,$3,$$);
		}
  | F		{$$ = $1; }
  ;

F : F '*' G	{
	                fprintf(dev, "4\n");
 			mul($1,$3,$$);
		}
  | F '/' G     {
		        fprintf(dev, "8\n");
			divide($1,$3,$$);
		} 
  | G		{$$ = $1;}

G : NUM		{$$ = $1;}
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


