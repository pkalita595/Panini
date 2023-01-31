all :  yacc.tab.c yacc.tab.h  lex.yy.c gen_sketch

yacc.tab.c yacc.tab.h : gen_sketch.y
	bison -d --defines="yacc.tab.h" --output="yacc.tab.c" gen_sketch.y

lex.yy.c : gen_sketch.l
	flex gen_sketch.l

gen_sketch : yacc.tab.c lex.yy.c
	g++ yacc.tab.c lex.yy.c -g -o gen_sketch

clean:
	rm *.c *.h gen_sketch
