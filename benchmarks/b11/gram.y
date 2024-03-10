%{

#include <cstdio>
#include <cstdlib>
#include <assert.h>
#include <cstdio>
#include <assert.h>
#include <iostream>
using namespace std;
#include "gram.h"
#define NUM_LOCALS 10

//extern "C"
//	Node* create(  int  val_,   Node*  next_);
//	Stack* Stack::create(Node*  head_);
/*  
	Node* Node::create(int  val_, Node*  next_){
	  void* temp= malloc( sizeof(Node)  ); 
	  Node* rv = new (temp)Node();
	  rv->val =  val_;
	  rv->next =  next_;
	  return rv;
	}
*/
	Stack* Stack::create(Node*  head_){
	  void* temp= malloc( sizeof(Stack)  ); 
	  Stack* rv = new (temp)Stack();
	  rv->head =  head_;
	  return rv;
	}
//commenting the definitions here as we are extracting them from llvm-extract

extern "C"
{
	int yyparse();
	int yylex(void);
	void yyerror(char *s){}
	int yywrap(void){return 1;}
	

	void syn_bipush(Stack* &stk, int *locals,int &pc ,int _var);
	void syn_istore(Stack* &stk, int *locals,int &pc ,int _var);
	void syn_istore_0(Stack* &stk, int *locals,int &pc );
	void syn_istore_1(Stack* &stk, int *locals,int &pc );
	void syn_istore_2(Stack* &stk, int *locals,int &pc );
	void syn_istore_3(Stack* &stk, int *locals,int &pc );
	void syn_if_icmple(Stack* &stk, int *locals,int &pc ,int _var);
	void syn_if_icmplt(Stack* &stk, int *locals,int &pc ,int _var);
	void syn_if_icmpne(Stack* &stk, int *locals,int &pc ,int _var);
	void syn_if_icmpeq(Stack* &stk, int *locals,int &pc ,int _var);
	void syn_if_icmpge(Stack* &stk, int *locals,int &pc ,int _var);
	void syn_if_icmpgt(Stack* &stk, int *locals,int &pc ,int _var);
	void syn_ifeq(Stack* &stk, int *locals,int &pc ,int _var);
	void syn_ifge(Stack* &stk, int *locals,int &pc ,int _var);
	void syn_ifgt(Stack* &stk, int *locals,int &pc ,int _var);
	void syn_ifle(Stack* &stk, int *locals,int &pc ,int _var);
	void syn_iflt(Stack* &stk, int *locals,int &pc ,int _var);
	void syn_ifne(Stack* &stk, int *locals,int &pc ,int _var);
	void syn_iinc(Stack* &stk, int *locals,int &pc ,int var1,int var2);
	void syn_iconst_m1(Stack* &stk, int *locals,int &pc );
	void syn_iconst_0(Stack* &stk, int *locals,int &pc );
	void syn_iconst_1(Stack* &stk, int *locals,int &pc );
	void syn_iconst_2(Stack* &stk, int *locals,int &pc );
	void syn_iconst_3(Stack* &stk, int *locals,int &pc );
	void syn_iconst_4(Stack* &stk, int *locals,int &pc );
	void syn_iconst_5(Stack* &stk, int *locals,int &pc );
	void syn_iload(Stack* &stk, int *locals,int &pc ,int _var);
	void syn_iload_0(Stack* &stk, int *locals,int &pc );
	void syn_iload_1(Stack* &stk, int *locals,int &pc );
	void syn_iload_2(Stack* &stk, int *locals,int &pc );
	void syn_iload_3(Stack* &stk, int *locals,int &pc );
	void syn_ineg(Stack* &stk, int *locals,int &pc );
	void syn_imul(Stack* &stk, int *locals,int &pc );
	void syn_iadd(Stack* &stk, int *locals,int &pc );
	void syn_isub(Stack* &stk, int *locals,int &pc );
	void syn_irem(Stack* &stk, int *locals,int &pc );
	void syn_idiv(Stack* &stk, int *locals,int &pc );

}


	Stack*  stk;// stack instance
	int locals[10]; //local variables
	int pc = 0;
    FILE* dev;
%}

%union
{
	int f; //maintains the output value
}

%token <f>  NUM bipush istore istore_0 istore_1 istore_2 istore_3 if_icmple if_icmplt if_icmpne if_icmpeq if_icmpge if_icmpgt
%token <f>  ifeq ifge ifgt ifle iflt ifne iinc iconst_m1 iconst_0 iconst_1 iconst_2 iconst_3 iconst_4 iconst_5
%token <f>  iload iload_0  iload_1  iload_2  iload_3 ineg iadd isub imul idiv irem  
%type <f> E P    

%%

S : E '\n'		{printf("%d ,%d \n",stk->head->val,pc);return 0; /*printing the output both stack and pc*/}
  ;

E : P ';' E		{;}
  | P ';'		{;}
  ;

P : NUM ':' bipush NUM  {fprintf(dev, "1\n");	if($1 == pc) {syn_bipush(stk, locals, pc,$4);}}
  | NUM ':' istore NUM	{fprintf(dev, "2\n");	if($1 == pc) {syn_istore(stk, locals, pc,$4);}}
  | NUM ':' istore_0	{fprintf(dev, "4\n");	if($1 == pc) {syn_istore_0(stk, locals, pc);}}	
  | NUM ':' istore_1	{fprintf(dev, "8\n");	if($1 == pc) {syn_istore_1(stk, locals, pc);}}	
  | NUM ':' istore_2	{fprintf(dev, "16\n");	if($1 == pc) {syn_istore_2(stk, locals, pc);}}	
  | NUM ':' istore_3	{fprintf(dev, "32\n");	if($1 == pc) {syn_istore_3(stk, locals, pc);}}	
  | NUM ':' if_icmpeq NUM {fprintf(dev, "64\n");	if($1 == pc) {syn_if_icmpeq(stk, locals, pc,$4);}}
  | NUM ':' if_icmplt NUM {fprintf(dev, "128\n");	if($1 == pc) {syn_if_icmplt(stk, locals, pc,$4);}}
  | NUM ':' if_icmple NUM {fprintf(dev, "256\n");	if($1 == pc) {syn_if_icmple(stk, locals, pc,$4);}}
  | NUM ':' if_icmpgt NUM {fprintf(dev, "512\n");	if($1 == pc) {syn_if_icmpgt(stk, locals, pc,$4);}}
  | NUM ':' if_icmpge NUM {fprintf(dev, "1024\n");	if($1 == pc) {syn_if_icmpge(stk, locals, pc,$4);}}
  | NUM ':' ifeq NUM  	  {fprintf(dev, "2048\n");	if($1 == pc) {syn_ifeq(stk, locals, pc,$4);}}
  | NUM ':' ifne NUM  	  {fprintf(dev, "4096\n");	if($1 == pc) {syn_ifne(stk, locals, pc,$4);}}
  | NUM ':' iflt NUM  	  {fprintf(dev, "8192\n");	if($1 == pc) {syn_iflt(stk, locals, pc,$4);}}
  | NUM ':' ifle NUM  	  {fprintf(dev, "16384\n");	if($1 == pc) {syn_ifle(stk, locals, pc,$4);}}
  | NUM ':' ifgt NUM  	  {fprintf(dev, "32768\n");	if($1 == pc) {syn_ifgt(stk, locals, pc,$4);}}
  | NUM ':' ifge NUM  	  {fprintf(dev, "65536\n");	if($1 == pc) {syn_ifge(stk, locals, pc,$4);}}
  | NUM ':' iinc NUM ',' NUM {fprintf(dev, "131072\n");	if($1 == pc) {syn_iinc(stk, locals, pc,$4,$6);}}
  | NUM ':' iconst_m1	{fprintf(dev, "262144\n");	if($1 == pc) {syn_iconst_m1(stk, locals, pc);}}
  | NUM ':' iconst_0	{fprintf(dev, "524288\n");	if($1 == pc) {syn_iconst_0(stk, locals, pc);}}
  | NUM ':' iconst_1	{fprintf(dev, "1048576\n");	if($1 == pc) {syn_iconst_1(stk, locals, pc);}}
  | NUM ':' iconst_2	{fprintf(dev, "2097152\n");	if($1 == pc) {syn_iconst_2(stk, locals, pc);}}
  | NUM ':' iconst_3	{fprintf(dev, "4194304\n");	if($1 == pc) {syn_iconst_3(stk, locals, pc);}}
  | NUM ':' iconst_4	{fprintf(dev, "8388608\n");	if($1 == pc) {syn_iconst_4(stk, locals, pc);}}
  | NUM ':' iconst_5	{fprintf(dev, "16777216\n");	if($1 == pc) {syn_iconst_5(stk, locals, pc);}}
  | NUM ':' iload NUM	{fprintf(dev, "33554432\n");	if($1 == pc) {syn_iload(stk, locals, pc,$4);}}
  | NUM ':' iload_0 	{fprintf(dev, "67108864\n");	if($1 == pc) {syn_iload_0(stk, locals, pc);}}
  | NUM ':' iload_1	    {fprintf(dev, "134217728\n");	if($1 == pc) {syn_iload_1(stk, locals, pc);}}
  | NUM ':' iload_2 	{fprintf(dev, "268435456\n");	if($1 == pc) {syn_iload_2(stk, locals, pc);}}
  | NUM ':' iload_3 	{fprintf(dev, "536870912\n");	if($1 == pc) {syn_iload_3(stk, locals, pc);}}
  | NUM ':' ineg 	    {fprintf(dev, "1073741824\n");	if($1 == pc) {syn_ineg(stk, locals, pc);}}
  | NUM ':' iadd 	    {fprintf(dev, "2147483648\n");	if($1 == pc) {syn_iadd(stk, locals, pc);}}
  | NUM ':' isub 	    {fprintf(dev, "4294967296\n");	if($1 == pc) {syn_isub(stk, locals, pc);}}
  | NUM ':' imul 	    {fprintf(dev, "8589934592\n");	if($1 == pc) {syn_imul(stk, locals, pc);}}
  | NUM ':' idiv 	    {fprintf(dev, "17179869184\n");	if($1 == pc) {syn_idiv(stk, locals, pc);}}
  | NUM ':' irem 	    {fprintf(dev, "34359738368\n");	if($1 == pc) {syn_irem(stk, locals, pc);}}
  ;

%%

int main()
{
	//parse input expression to get output
    dev = fopen("getDerivation", "a");
	stk = Stack::create(NULL); 	
	yyparse();
    fclose(dev);
	return 0;
}
