%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h" //generated by yacc -d
%}


%option noyywrap


%%
([-])?[0-9]+(\.[0-9]+)?([eE][0-9]+)?	{yylval.f = atoi(yytext);  return NUM;}
[-+=()*/\n]			{return yytext[0];}
[ \t\v\f]			{;}
%%
