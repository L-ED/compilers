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
   | program operator {printf("Program call\n");}
   ;

operator:
    EOL {yylineno+=1;}
    | ops EOL {
        yylineno+=1;
        // fprintf(stdout, "Got exp\n");
        }
    | IDENTIFIER ASSIGN operator EOL {
        yylineno+=1;
        printf("found assign\n");
        }

    // | IDENTIFIER LPARENT opslist RPARENT {
    //     printf("func call\n");
    //     }


    // | IDENTIFIER LPARENT ops RPARENT {
    //     // printf("func call\n");
    //     }
    // | IDENTIFIER LPARENT ops COMMA ops RPARENT {
    //     // printf("func call\n");
    //     }
    | error EOL// {yyerror;}
    ;

// opslist: ops
//     | ops COMMA opslist {
//         printf("arglist\n");
//     }


ops: term
    | ops LXOR term {
        printf("found op\n");
        }
    | ops LOR term {
        printf("found op\n");
        }
    | ops LNOT term {
        printf("found op\n");
        }
    | ops LAND term {
        printf("found op\n");
        }

    | IDENTIFIER LPARENT opslist RPARENT {
        printf("func call\n");
        }
    // | ops COMMA ops {
    //     // printf("args\n");
    //     }
    // | LPARENT ops RPARENT {
        // printf("found parentheses\n");
        // }
    // | IDENTIFIER LPARENT ops RPARENT {
    //     // printf("func call\n");
    //     }
    ;

opslist: ops
    | ops COMMA opslist {
        printf("arglist\n");
    }

term:
    IDENTIFIER {
        printf("found id\n");
        }
    | TRUE {
        printf("found T\n");
        }
    | FALSE {
        printf("found F\n");
        }
    |
    // | LPARENT ops RPARENT {printf("found parentheses\n");}
    // | IDENTIFIER LPARENT ops RPARENT {printf("func call\n");}
    // | IDENTIFIER ASSIGN ops {printf("found assign\n");}
    // | ops COMMA ops {printf("args\n");}
    ;
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