%defines
%define api.token.constructor
%define api.value.type variant
%define parse.assert
// %define api.header.include {"grammar.h"}


%{

#include <stdio.h>
#include "ast_tree.hpp"

// #include "grammar.h"
#include "lexer.h"
#include "grammar.h"


extern int yylineno;
void yyerror(const char *msg)
{  fprintf(stderr,"%d: %s\n",yylineno, msg);
}
int yylex();
int yyparse();

%}

%require "3.2"
%language "c++"

%precedence TOK_UMIN
%define parse.error verbose

%token LAND LOR LNOT LXOR
// %token <std::string> IDENTIFIER
%token IDENTIFIER
%token TRUE FALSE
%token RPARENT LPARENT 
%token COMMA
%token ASSIGN 
%token EOL

%left LOR LXOR
%left LAND
%left LNOT

// %nterm <AstTree::AstNode> operator term ops opslist

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

    | error EOL// {yyerror;}
    ;


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
    ;

opslist: ops
    | ops COMMA opslist {
        printf("arglist\n");
    }

term:
    IDENTIFIER {
        // $$ = AstTree::AstNode.CreateInstance(AstTree::ID, S1);
        printf("found id\n");
        }
    | TRUE {
        // $$ = AstTree::AstNode.CreateInstance(AstTree::True);
        printf("found T\n");
        }
    | FALSE {
        // $$ = AstTree::AstNode.CreateInstance(AstTree::False);
        printf("found F\n");
        }
    |

    ;
    
%%

// void yyerror(const char *msg)
// {  
//     fprintf(stderr,"%d: %s\n",yylineno, msg);
// }

int main( int argc, char **argv )
{

    AstTree::AstNode tree();

    ++argv, --argc; /* skip over program name */
    if ( argc > 0 )
        yyin = fopen( argv[0], "r" );
    
    else
        yyin = stdin;
    // yylex();
    // yy::parser parse;
    // parse();
    yyparse();
    printf("Parsed");

    if (argc > 0)
        fclose(yyin);

    return 0;
}