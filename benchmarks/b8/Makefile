all :  yacc.tab.c yacc.tab.h  lex.yy.c gen_sketch

yacc.tab.c yacc.tab.h : gen_sketch.y 
	bison -d --defines="yacc.tab.h" --output="yacc.tab.c" gen_sketch.y

lex.yy.c : gram.l
	flex gram.l

gen_sketch : yacc.tab.c lex.yy.c
	g++ -g yacc.tab.c lex.yy.c oracle_funs.cpp -g -o gen_sketch

clean:
	rm *.c *.h gen_sketch
