
/*
Калькулятор вычисляет логические выражения. Символьными литералами в
данном случае являются символы T (класс токена TRUE) и F (класс токена FALSE).
Возможные действия над аргументами: конъюнкция && (класс токена LAND), дизъ-
юнкция || (класс токена LOR), строгая дизъюнкция ^ (класс токена LXOR), отри-
цание ! (класс токена LNOT).

• Идентификатор: название функций и переменных, состоящее из малень-
ких и заглавных букв латинского алфавита, цифр и подчёркиваний. Иденти-
фикатор не может начинаться с цифры. Класс токена идентификатора на-
зывается IDENTIFIER.
• Скобки: (, ). Классы токенов скобок называются LPARENT и RPARENT соответственно.
• Запятая: ,. Класс токена запятой называется COMMA. 
Запятая используется для разделения аргументов при вызове функции.
• Присваивание: =. Класс токена присваивания называется ASSIGN. 
Присваивание служит чтобы задать переменной какое-либо значение.
• Ошибка: Класс токена ошибки называется ERROR. 
Лексема, содержащая ошибку появляется если входные символы не явлюятся 
символами рассматриваемого языка.

*/

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
    printf("sending ID %s\n", yylval.str);

    return IDENTIFIER;}

[\n] {return EOL;} 
. {
    // printf("ERROR\n");
        lex_error("Unsupported character", yytext);}
%%
