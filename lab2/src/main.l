
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
#include "grammar.h"

void perror(const char *msg)
{  fprintf(stderr,"%d: %s\n",yylineno, msg);
}
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
{ID} {
    // printf("sending ID\n");
    return IDENTIFIER;}
[+*\n] {return EOL;} 
[ \t] {;}
[0-9]*. {
    // printf("ERROR\n");
        perror;}
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