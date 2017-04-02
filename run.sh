	lex icodegen.l
	yacc -d icodegen.y
	gcc lex.yy.c y.tab.c -ll