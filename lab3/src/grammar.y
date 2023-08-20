%{
#include <stdio.h>
#include <stdlib.h>

// extern char* yylval;
// #define YYSTYPE char*

enum Type{Assign, BOP, UOP, Func, Arglist, Var, State};

struct Node{
    enum Type op;
    char* name;
    char* id;
    int argslen;
    struct Node* args;
};

typedef struct Node Node;

union data{
    int tok;
    char* str;
    Node node;
};

#define YYSTYPE union data


#include "grammar.h"
#include "lexer.h"


extern int yylineno;
void yyerror(const char *msg)
{  fprintf(stderr,"%d: %s\n",yylineno, msg);
}
int yylex();
int yyparse();

void create_nesting(int nest_counter){
    for(int i=0;i<nest_counter;i++){
        printf("|\t");
    }
}

void parse_tree(Node node, int nest_counter){

    create_nesting(nest_counter);
    printf("|-<%s", node.name);
    switch(node.op){
        case Var:
            printf(", \"%s\"", node.id);
        case Func:
            printf(", \"%s\"", node.id);
    }
    printf(">\n");

    for(int i=0;i<node.argslen;i++){
        parse_tree(node.args[i], nest_counter+1);
    }
    
}

%}

// %union{
//     char* name;
//     Node node;
// }

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
   | program operator {
        printf("<PROGRAM>\n");
        // parse_tree($$.node, 0);
    }
   ;

operator:
    EOL {yylineno+=1;}
    | ops EOL {
        yylineno+=1;
        // fprintf(stdout, "Got exp\n");
        }
    | IDENTIFIER ASSIGN operator EOL {
        // Node node;
        // node.op=Assign;
        // char name[] = "ASSIGN";
        // node.name = name;
        // Node* arglist = (Node*)malloc(2*sizeof(*$1.node.args));
        // arglist[0] = $1.node; 
        // arglist[1] = $3.node;
        // node.args = arglist;
        // node.argslen=2;
        // $$.node = node;
        
        yylineno+=1;
        printf("found assign\n");

        }

    | error EOL// {yyerror;}
    ;


ops: uop
    | ops LXOR uop {
        printf("found op\n");
        // Node node;
        // node.op=BOP;
        // char name[] = "LXOR";
        // node.name = name;
        // Node* arglist = (Node*)malloc(2*sizeof(*$1.node.args));
        // arglist[0] = $1.node; 
        // arglist[1] = $3.node;
        // node.argslen=2;
        // node.args = arglist;
        // $$.node = node;
        }

    | ops LOR uop {
        printf("found op\n");
        // Node node;
        // node.op=BOP;
        // char name[] = "LOR";
        // node.name = name;
        // Node* arglist = (Node*)malloc(2*sizeof(*$1.node.args));
        // arglist[0] = $1.node; 
        // arglist[1] = $3.node;
        // node.argslen=2;
        // node.args = arglist;
        // $$.node = node;
        }

    | ops LAND uop {
        printf("found op\n");
        // Node node;
        // node.op=BOP;
        // char name[] = "LAND";
        // node.name = name;
        // Node* arglist = (Node*)malloc(2*sizeof(*$1.node.args));
        // arglist[0] = $1.node; 
        // arglist[1] = $3.node;
        // node.args = arglist;
        // node.argslen=2;
        // $$.node = node;
        }

    // | IDENTIFIER LPARENT opslist RPARENT {
    //     printf("func call\n");
    //     }

    // | IDENTIFIER LPARENT RPARENT {
    //     printf("func call\n");
    //     }
    ;

opslist: ops
    | opslist COMMA ops {
        printf("arglist %s and op %s\n", $1.node.name, $3.node.name);
        // if($1.node.op==Arglist){
        //     int newlen = $1.node.argslen +1; 
        //     // printf("New size is %d\n", newlen);

        //     $1.node.args = (Node*)realloc($1.node.args, newlen*sizeof(*$1.node.args));
        //     // $1.node.args[newlen-1] = $3.node;
        //     // $$.node = $1.node;
        // }
        // else{
        //     // printf("Not arglist\n");
        //     Node id;
        //     id.name = "arglist";
        //     id.op = Arglist;
        //     Node* arglist = (Node*)malloc(2*sizeof(*$1.node.args));
        //     arglist[0] = $1.node; 
        //     arglist[1] = $3.node;
        //     id.args = arglist;
        //     id.argslen = 2;
        //     $$.node = id;
        // }
    }

uop: term
    | LNOT term {
        printf("found uop\n");
        // struct Node id;
        // char n[]= "LNOT";
        // id.name = n;
        // id.argslen=1;
        // id.op = UOP;
        // struct Node arglist[] = {$2.node};
        // id.args = arglist;
        // $$.node = id;
        
        }

term:
    IDENTIFIER {
        printf("found id {%s}\n", yylval.str);
        // struct Node id;
        // char name[] = "IDENTIFIER";
        // id.name = name;
        // id.argslen=0;
        // id.id = strdup(yylval.str);
        // id.op = Var;
        // $$.node = id;
        }
    | TRUE {
        printf("found True");
        // struct Node id;
        // char n[]= "TRUE";
        // id.name = n;
        // id.argslen=0;
        // id.op = State;
        // $$.node = id;
        }
    | FALSE {
        printf("found False");
        // struct Node id;
        // char n[]= "FALSE";
        // id.name = n;
        // id.argslen=0;
        // id.op = State;
        // $$.node = id;
        }

    | IDENTIFIER LPARENT opslist RPARENT {
        printf("func call {%s} {%d}\n", yylval.str, $3.tok);
        // struct Node id;
        // char name[] = "CALL";
        // id.name = name;
        // id.id = strdup(yylval.str);
        // id.op = Func;
        // id.argslen = $3.node.argslen;
        // id.args = $3.node.args;
        // $$.node = id;
        }

    | IDENTIFIER LPARENT RPARENT {
        printf("func call {%s}\n", yylval.str);
        // struct Node id;
        // char name[] = "CALL";
        // id.name = name;
        // id.argslen=0;
        // id.id = strdup(yylval.str);
        // id.op = Func;
        // id.args = NULL;
        // $$.node = id;
        }
%%


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