%{
#include <stdio.h>
#include <string.h>
#include "exp.parser.h"
%}
DIGIT [0-9]
ALPHA [A-Za-z_]
%option noyywrap
%%
"[let "  {return LET;}
"= ?"     {return DECL;}
"]{"     {return CODE;}
[ \t\r\n]+   {}
{DIGIT}+ { yylval.value = atoi(yytext); return NUMBER; }
"+"      { return '+'; }
"-"      { return '-'; }
"*"      { return '*'; }
"/"      { return '/'; }
";"      { return ';'; }
"?"      { return '?'; }
"="      { return '='; }
","      { return ','; }
"("      { return '('; }
")"      { return ')'; }
"["      { return '['; }
"]"      { return ']'; }
"{"      { return '{'; }
"}"      { return '}'; }
{ALPHA}+ { yylval.variable = strdup(yytext); return VAR; }
.        { return LEX_ERR; }
%%
