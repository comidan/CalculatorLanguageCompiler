%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror(const char *);

extern FILE *yyin;
extern char *yytext;
	
typedef struct List {
	struct List *next;
	struct List *prev;
	int value;
	char *variable;
} List;
List *list = NULL;

%}
%union {
  int value;
  char* variable;
}

%token <value> NUMBER
%token <variable> VAR
%token LEX_ERR
%token LET DECL CODE 

%type <value> exp
%type <value> oper
%type <value> decl

%left '+' '-'
%left '*' '/' 
%right OP_UMINUS

%define parse.error verbose
%start program
%%
program : exp { printf("Result: %d\n", $1); }
        | program ';' exp { printf("Result: %d\n", $3); }
        ;

exp : exp '+' exp { $$ = $1 + $3; }
    | exp '-' exp { $$ = $1 - $3; }
    | exp '*' exp { $$ = $1 * $3; }
    | exp '/' exp { $$ = $1 / $3; }
    | LET decl CODE oper'}' {
				  $$ = $4;
				  int i = 0;
                                  if (list == NULL)
                                    return -1;
                                  while(i++ < $2 && list != NULL) {
				  	list = list->prev;
					if(list != NULL)
						free(list->next);
				  }
			          if(list != NULL) {
                                    list->next=(List*) malloc(sizeof(List));
				  }
			       }
    | '-' %prec OP_UMINUS exp { $$ = -$2; }
    | NUMBER { $$ = $1; }	
    ;
decl : VAR DECL {
			if(list == NULL) {
				list = (List*) malloc(sizeof(List));
				list->prev = NULL;
			}
			else {
				list->next = (List*) malloc(sizeof(List));
				list->next->prev = list;
				list = list->next;
			}
			list->variable = $1;
			printf("Insert value of %s\n", $1);
			scanf("%d", &(list->value));
			$$ = 1;
		} 
     | VAR '=' NUMBER {
			if(list == NULL) {
				list = (List*) malloc(sizeof(List));
				list->prev = NULL;
			}
			else {
				list->next = (List*) malloc(sizeof(List));
				list->next->prev = list;
				list = list->next;
			}
			list->variable = $1;
			list->value = $3;
			$$ = 1;
		    }
     | decl ',' decl {$$ = $1 + $3;};

oper : oper '+' oper {$$ = $1 + $3;}
     | oper '-' oper {$$ = $1 - $3;}
     | oper '*' oper {$$ = $1 * $3;}
     | oper '/' oper {$$ = $1 / $3;}
     | oper '+' exp {$$ = $1 + $3;}
     | oper '-' exp {$$ = $1 - $3;}
     | oper '*' exp {$$ = $1 * $3;}
     | oper '/' exp {$$ = $1 / $3;}
     | VAR {    
                
		if(list == NULL) {
			printf("Oh parblè! Variabled %s not declared\n", $1);
			return -1;
		}
                List *temp = list;
		while(temp != NULL && strcmp(temp->variable, $1) != 0) {
			printf("%s\n", temp->variable);
			temp = temp->prev;
		}
		if(temp != NULL)
			$$ = temp->value;
		else {
			printf("Oh parblè! Variabled %s not declared\n", $1);
			return -1;
		}
	}
     ;

%%
void yyerror(const char *msg) {
  if (yychar == LEX_ERR)
    fprintf(stderr, "Lexical error: unkown keyword '%s'\n", yytext);
  else fprintf(stderr, "%s\n", msg);
}
int main(int argc, char **argv) {
  if (argc < 2) {
    fprintf(stderr, "Missing input file!\n");
  }
  yyin = fopen(argv[1], "r");
  if (yyparse()) {
    fprintf(stderr, "Source code is not correct!\n");
    return 1;
  }

  fclose(yyin);
  return 0;
}
