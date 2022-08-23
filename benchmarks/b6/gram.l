
%{

#include <stdio.h>
#include <stdlib.h>
#include "yacc.tab.h" //generated by yacc -d

extern "C" int yylex();

%}


%option noyywrap


%%
(-)?[0-9]+(\.[0-9]+)?([eE][0-9]+)?	{yylval.f = atoi(yytext);  return NUM;}
[-+=()*/\n]			{return yytext[0];}
(INR|USD|EUR)			{
					if( strcmp("USD",yytext) == 0)
						return USD;
					else if( strcmp("INR",yytext) == 0)
						return INR;
					else
						return EUR;
					 
				}
[ \t\v\f]			{;}
%%