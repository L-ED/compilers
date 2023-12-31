
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

%{
/* funcs and headers */

%}
/* definitions and templates */

DIGIT [0-9]
ID [a-zA-Z_][a-zA-Z0-9_]*

%%
[(] {printf("LPARENT, \"%s\" \n", yytext);}
[)] {printf("RPARENT, \"%s\" \n", yytext);}
[,] {printf("COMMA, \"%s\" \n", yytext);}
[=] {printf("ASSIGN, \"%s\"\n", yytext);}
"&&" {printf("LAND, \"%s\"\n", yytext);}
"||" {printf("LOR, \"%s\"\n", yytext);}
[!] {printf("LNOT, \"%s\"\n", yytext);}
"^" {printf("LXOR, \"%s\"\n", yytext);}
[T] {printf("TRUE, \"%s\"\n", yytext);}
[F] {printf("FALSE, \"%s\"\n", yytext);}
[ \t\n] {;}
{ID} {printf("IDENTIFIER, \"%s\"\n", yytext);}
[0-9]*. {printf("ERROR \n");}
%%

int main( int argc, char **argv )
{
    ++argv, --argc; /* skip over program name */
    if ( argc > 0 )
        yyin = fopen( argv[0], "r" );
    
    else
        yyin = stdin;
    yylex();
    
    if (argc > 0)
        fclose(yyin);

    return 0;
}