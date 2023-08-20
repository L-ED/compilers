
%option noyywrap
/* interactive bison
*/
%{
/* funcs and headers */
// #include "lexer.h"

// extern char* yylval;
// #define YYSTYPE char*

struct Node{
    // type op;
    char* name;
    struct Node* args;
};

union data{
    char* str;
    struct Node node;
};

#define YYSTYPE union data

struct Token{
    int token;
    char* name;
};

typedef struct Token Token;
// #define YYTOKENTYPE Token

#include "grammar.h"

void lex_error(const char *msg, const char *args)
{  
    fprintf(stderr,"%d: %s %s\n",yylineno, msg, args);
}

// #define YYSTYPE char*
// extern char* yylval;


%}
/* definitions and templates */

DIGIT [0-9]
ID [a-zA-Z_][a-zA-Z0-9_]*

%%
[(] {
    // printf("sending (\n");
    return LPARENT;}
[)] {
    // printf("sending )\n");
    return RPARENT;}
[,] {
    // printf("sending ,\n");
    return COMMA;}
[=] {
    // printf("sending =\n");
    return ASSIGN;}
"&&" {
    // printf("sending '&&'\n");
    return LAND;}
"||" {
    // printf("sending '||'\n");
    return LOR;}
[!] {
    // printf("sending '!'\n");
    return LNOT;}
"^" {
    // printf("sending '^'\n");
    return LXOR;}
[T] {
    // printf("sending T\n");
    return TRUE;}
[F] {
    // printf("sending F\n");
    return FALSE;}
[ \t] {;}
{ID} {
    // printf("sending ID %s\n", yytext);
    yylval.str = strdup(yytext);
    // printf("sending ID %s\n", yylval.str);
    // Token tok = IDENTIFIER;
    // tok.name = strdup(yytext);
    // return tok;
    return IDENTIFIER;
    }

[\n] {return EOL;} 
. {
    // printf("ERROR\n");
        lex_error("Unsupported character", yytext);}
%%
