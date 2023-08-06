%{
#include <stdio.h>
extern int yylineno;
void yyerror(const char *msg)
{  fprintf(stderr,"%d: %s\n",yylineno, msg);
}
int yylex();
int yyparse();
%}

%precedence TOK_UMIN
%define parse.error verbose

%token LAND LOR LNOT LXOR
%token IDENTIFIER
%token TRUE FALSE
%token RPARENT LPARENT 
%token COMMA
%token ASSIGN 
%token EOL

%left LOR LXOR
%left LAND
%left LNOT

// %start program

%%
/*Grammar*/
program: 
   | program operator
   ;

operator:
    EOL {}
    | ops EOL {
        // fprintf(stdout, "Got exp\n");
        }
    | IDENTIFIER ASSIGN ops EOL {
        // printf("found assign\n");
        }
    | error EOL// {yyerror;}
    ;

ops: term
    | ops LXOR term {
        // printf("found op\n");
        }
    | ops LOR term {
        // printf("found op\n");
        }
    | ops LNOT term {
        // printf("found op\n");
        }
    | ops LAND term {
        // printf("found op\n");
        }
    | ops COMMA ops {
        // printf("args\n");
        }
    | LPARENT ops RPARENT {
        // printf("found parentheses\n");
        }
    | IDENTIFIER LPARENT ops RPARENT {
        // printf("func call\n");
        }
    ;

term:
    IDENTIFIER {
        // printf("found id\n");
        }
    | TRUE {
        // printf("found T\n");
        }
    | FALSE {
        // printf("found F\n");
        }
    // | LPARENT ops RPARENT {printf("found parentheses\n");}
    // | IDENTIFIER LPARENT ops RPARENT {printf("func call\n");}
    // | IDENTIFIER ASSIGN ops {printf("found assign\n");}
    // | ops COMMA ops {printf("args\n");}
    ;
%%