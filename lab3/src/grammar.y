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

struct Token{
    int token;
    char* name;
};

typedef struct Token Token;

union data{
    int tok;
    char* str;
    Node node;
    Token token;
};


#define YYSTYPE union data
// #define YYTOKENTYPE Token


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
        printf("| ");
    }
}

void parse_tree(Node node, int nest_counter){

    create_nesting(nest_counter);
    printf("|-<%s", node.name);
    if((node.op==Var)||(node.op==Func))
    {
        printf(", \"%s\"", node.id);
    }
    printf(">\n");

    for(int i=0;i<node.argslen;i++){
        // printf(" type %s", node.args[i].name);
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

%type <node> term uop opslist ops operator state var
%type <int> LAND LOR LNOT LXOR TRUE FALSE RPARENT LPARENT COMMA ASSIGN EOL
%type <token> IDENTIFIER
%%
/*Grammar*/
program: 
    | program operator EOL{
        printf("<PROGRAM>\n");
        parse_tree($2, 0);
        // parse_tree($2.node, 0);
    }
   ;

operator: ops
    | var ASSIGN ops {
        Node node; 
        // id;
        // char idname[] = "IDENTIFIER";
        // id.name = strdup(idname);
        // id.argslen=0;
        // id.id = strdup();
        // id.op = Var;

        node.op=Assign;
        char name[] = "ASSIGN";
        node.name = strdup(name);
        Node* arglist = (Node*)malloc(2*sizeof(Node));
        arglist[0] = $1; 
        arglist[1] = $3;
        // arglist[0] = $1.node; 
        // arglist[1] = $3.node;
        node.args = arglist;
        node.argslen=2;
        $$ = node;
        // $$.node = node;
        // printf("found assign\n");

        }

    // | error// {yyerror;}
    ;


ops: uop
    | ops LXOR uop {
        // printf("found op\n");
        Node node;
        node.op=BOP;
        char name[] = "LXOR";
        node.name = strdup(name);
        Node* arglist = (Node*)malloc(2*sizeof(Node));
        // Node* arglist = (Node*)malloc(2*sizeof(*$1.node.args));
        arglist[0] = $1; 
        arglist[1] = $3;
        // arglist[0] = $1.node; 
        // arglist[1] = $3.node;
        node.argslen=2;
        node.args = arglist;
        $$ = node;
        // $$.node = node;
        }

    | ops LOR uop {
        // printf("found op\n");
        Node node;
        node.op=BOP;
        char name[] = "LOR";
        node.name = strdup(name);
        Node* arglist = (Node*)malloc(2*sizeof(Node));
        // Node* arglist = (Node*)malloc(2*sizeof(*$1.node.args));
        arglist[0] = $1; 
        arglist[1] = $3;
        // arglist[0] = $1.node; 
        // arglist[1] = $3.node;
        node.argslen=2;
        node.args = arglist;
        $$ = node;
        // $$.node = node;
        }

    | ops LAND uop {
        // printf("found op\n");
        Node node;
        node.op=BOP;
        char name[] = "LAND";
        node.name = strdup(name);
        Node* arglist = (Node*)malloc(2*sizeof(Node));
        // Node* arglist = (Node*)malloc(2*sizeof(*$1.node.args));
        arglist[0] = $1; 
        arglist[1] = $3;
        // arglist[0] = $1.node; 
        // arglist[1] = $3.node;
        node.args = arglist;
        node.argslen=2;
        $$ = node;
        // $$.node = node;
        }
    
    // | var LPARENT opslist RPARENT {
    //     printf("func call {%s} \n", yylval.str);
    //     struct Node id;
    //     char name[] = "CALL";
    //     id.name = strdup(name);
    //     id.id = $1.id;
    //     id.op = Func;
    //     if($3.op==Arglist){
    //         id.args = $3.args;
    //         id.argslen = $3.argslen;
    //     }
    //     else{
    //         Node* arglist = (Node*)malloc(sizeof(Node));
    //         arglist[0]=$3;
    //         id.args = arglist;
    //         id.argslen = 1;
    //     }
    //     $$ = id;
    //     // id.argslen = $3.node.argslen;
    //     // id.args = $3.node.args;
    //     // $$.node = id;
    //     }

    ;

opslist: ops 
    | opslist COMMA ops {
        // printf("arglist %s and op %s\n", $1.node.name, $3.node.name);
        // if($1.node.op==Arglist){
        //     int newlen = $1.node.argslen +1; 
        //     // printf("New size is %d\n", newlen);

        //     $1.node.args = (Node*)realloc($1.node.args, newlen*sizeof(*$1.node.args));
        //     $1.node.args[newlen-1] = $3.node;
        //     $$.node = $1.node;
        // printf("arglist %s and op %s\n", $1.name, $3.name);
        if($1.op==Arglist){
            int newlen = $1.argslen +1; 
            // printf("New size is %d\n", newlen);

            $1.args = (Node*)realloc($1.args, newlen*sizeof(Node));
            $1.args[newlen-1] = $3;
            $1.argslen = newlen;
            $$ = $1;
        }
        else{
            // printf("Not arglist\n");
            Node id;
            id.name = "arglist";
            id.op = Arglist;
            Node* arglist = (Node*)malloc(2*sizeof(Node));
            // Node* arglist = (Node*)malloc(2*sizeof(*$1.node.args));
            arglist[0] = $1; 
            arglist[1] = $3;
            // arglist[0] = $1.node; 
            // arglist[1] = $3.node;
            id.args = arglist;
            id.argslen = 2;
            $$ = id;
            // $$.node = id;
        }
    }
    | {
        Node id;
        id.name = "arglist";
        id.op = Arglist;
        id.args = NULL;
        id.argslen = 0;
        $$ = id;
    }
    ;

uop: term
    | LNOT term {
        // printf("found uop\n");
        struct Node id;
        char n[]= "LNOT";
        id.name = strdup(n);
        id.argslen=1;
        id.op = UOP;
        struct Node arglist[] = {$2};
        // struct Node arglist[] = {$2.node};
        id.args = arglist;
        // $$.node = id;
        $$ = id;
        
        }
    ;

term: var
    | state
    | var LPARENT opslist RPARENT {
        // printf("func call {%s} \n", yylval.str);
        struct Node id;
        char name[] = "CALL";
        id.name = strdup(name);
        id.id = $1.id;
        id.op = Func;
        if($3.op==Arglist){
            id.args = $3.args;
            id.argslen = $3.argslen;
        }
        else{
            Node* arglist = (Node*)malloc(sizeof(Node));
            arglist[0]=$3;
            id.args = arglist;
            id.argslen = 1;
        }
        $$ = id;
        // id.argslen = $3.node.argslen;
        // id.args = $3.node.args;
        // $$.node = id;
        }
    ;

var:
    IDENTIFIER {
        // printf("found id {%s}\n", yylval.str);
        struct Node id;
        char name[] = "IDENTIFIER";
        id.name = strdup(name);
        id.argslen=0;
        id.id = strdup(yylval.str);
        id.op = Var;
        $$ = id;
    }
    ;

state:
    TRUE {
        // printf("found True");
        struct Node id;
        char n[]= "TRUE";
        id.name = strdup(n);
        id.argslen=0;
        id.op = State;
        // $$.node = id;
        $$ = id;
        }
    | FALSE {
        // printf("found False");
        struct Node id;
        char n[]= "FALSE";
        id.name = strdup(n);
        id.argslen=0;
        id.op = State;
        // $$.node = id;
        $$= id;
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