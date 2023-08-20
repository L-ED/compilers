%{
#include <stdio.h>
#include "grammar.h"
#include "lexer.h"
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
    | program operator EOL{
    }
   ;

operator: ops
    | var ASSIGN ops {
        // printf("found assign\n");
        }
    ;


ops: uop
    | ops LXOR uop {
        // printf("found op\n");
        }

    | ops LOR uop {
        // printf("found op\n");
        }

    | ops LAND uop {
        // printf("found op\n");
        }
    ;

opslist: ops 
    | opslist COMMA ops {
        // printf("arglist %s and op %s\n", $1.node.name, $3.node.name);
    }
    |
    ;

uop: term
    | LNOT term {
        // printf("found uop\n");
        }
    ;

term: var
    | state
    | var LPARENT opslist RPARENT {
        // printf("func call {%s} \n", yylval.str);
        }
    ;

var:
    IDENTIFIER {
        // printf("found id {%s}\n", yylval.str);
    }
    ;

state:
    TRUE {
        // printf("found True");
        }
    | FALSE {
        // printf("found False");
        }
%%

// void yyerror(const char *msg)
// {  
//     fprintf(stderr,"%d: %s\n",yylineno, msg);
// }

int main( int argc, char **argv )
{
    ++argv, --argc; /* skip over program name */
    if ( argc > 0 )
        yyin = fopen( argv[0], "r" );
    
    else
        yyin = stdin;
    // yylex();
    yyparse();
    
    if (argc > 0)
        fclose(yyin);

    return 0;
}