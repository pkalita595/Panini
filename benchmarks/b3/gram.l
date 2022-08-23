
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
[ \t\v\f]			{;}
%%