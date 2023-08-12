# lexer:
# 	flex --header-file=./inc/lexer.h -o ./src/lexer.c ./src/main.l
# 	gcc ./src/lexer.c -o lexer

lexer:
	bison ./src/grammar.y --defines=./inc/grammar.h -o ./src/grammar.c
	flex --header-file=./inc/lexer.h -o ./src/lexer.c ./src/main.l
	g++ ./src/grammar.c ./src/lexer.c -o parser -I ./inc/