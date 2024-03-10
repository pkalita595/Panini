/*
 * Correct definitions of grammar synthesis functions
 */

//#include <stdlib.h>
//#include <cstdlib>
//#include <stdio.h>
#include <cstdio>
//#include "new_def.h"
//#include "yacc.tab.c"
#include "gram.h"



// using namespace std;

/*
extern "C"
{
	class Node; 
	class Stack; 
	class Node{
	  public:
	  int  val;
	  Node*  next;
	  Node(){}
	 static	Node* create(  int  val_,   Node*  next_);
	static Node* create(int  val_, Node*  next_){
	  //printf("Create() function ------- \n");	
	  void* temp= malloc( sizeof(Node)  ); 
	  //printf("before (temp)Node() ------- \n");	
	  Node* rv = new (temp)Node();
	  rv->val =  val_;
	  rv->next =  next_;
	  return rv;
	}
	

	~Node(){
	  }
	  void operator delete(void* p){ free(p); }
	};
	class Stack{
	  public:
	  Node*  head;
	  Stack(){}
	static	 Stack* create(  Node*  head_);
	static Stack* create(Node*  head_){
	  void* temp= malloc( sizeof(Stack)  ); 
	  Stack* rv = new (temp)Stack();
	  rv->head =  head_;
	  return rv;
	}
	

	~Stack(){
	  }
	  void operator delete(void* p){ free(p); }
	};

}
*/

Node* Node::create(int  val_, Node*  next_){
          void* temp= malloc( sizeof(Node)  ); 
          Node* rv = new (temp)Node();
          rv->val =  val_;
          rv->next =  next_;
          return rv;
        }




extern "C"
{

	void syn_bipush(Stack* &stk, int *locals,int &pc ,int var1) //1
	{
		Node*  n=NULL;
		n = Node::create(var1, NULL);
		n->next = stk->head;
		stk->head = n;
		pc = pc + 1;
	}

	void syn_istore(Stack* &stk, int *locals,int &pc ,int var1) //2
	{
		locals[var1] = stk->head->val;
		stk->head = stk->head->next;
		pc = pc + 1;
	}

	void syn_istore_0(Stack* &stk, int *locals,int &pc) //3
	{
		locals[0] = stk->head->val;
		stk->head = stk->head->next;
		pc = pc + 1;
	}

	void syn_istore_1(Stack* &stk, int *locals,int &pc) //4
	{
		locals[1] = stk->head->val;
		stk->head = stk->head->next;
		pc = pc + 1;
	}

	void syn_istore_2(Stack* &stk, int *locals,int &pc) //5
	{
		locals[2] = stk->head->val;
		stk->head = stk->head->next;
		pc = pc + 1;
	}

	void syn_istore_3(Stack* &stk, int *locals,int &pc) //6
	{
		locals[3] = stk->head->val;
		stk->head = stk->head->next;
		pc = pc + 1;
	}

	void syn_if_icmpeq(Stack* &stk, int *locals,int &pc,int var1) //7
	{
		int val2 = stk->head->val;
	        stk->head = stk->head->next;
		int val1 = stk->head->val;
		stk->head = stk->head->next;
		if(val1 == val2)
		{
			pc = var1;
		}	
	}

	/*
	void syn_if_icmpne(Stack* &stk, int *locals,int &pc,int var1) //8
	{
		int val2 = stk->head->val;
	        stk->head = stk->head->next;
		int val1 = stk->head->val;
		stk->head = stk->head->next;
		if(val1 != val2)
		{
			pc = var1;
		}	
	}
	*/

	void syn_if_icmplt(Stack* &stk, int *locals,int &pc,int var1) //9
	{
		int val2 = stk->head->val;
	        stk->head = stk->head->next;
		int val1 = stk->head->val;
		stk->head = stk->head->next;
		if(val1 < val2)
		{
			pc = var1;
		}	
	}

	void syn_if_icmple(Stack* &stk, int *locals,int &pc,int var1) //10
	{
		int val2 = stk->head->val;
	        stk->head = stk->head->next;
		int val1 = stk->head->val;
		stk->head = stk->head->next;
		if(val1 <= val2)
		{
			pc = var1;
		}	
	}

	void syn_if_icmpgt(Stack* &stk, int *locals,int &pc,int var1) //11
	{
		int val2 = stk->head->val;
	        stk->head = stk->head->next;
		int val1 = stk->head->val;
		stk->head = stk->head->next;
		if(val1 > val2)
		{
			pc = var1;
		}	
	}

	void syn_if_icmpge(Stack* &stk, int *locals,int &pc,int var1) //12
	{
		int val2 = stk->head->val;
	        stk->head = stk->head->next;
		int val1 = stk->head->val;
		stk->head = stk->head->next;
		if(val1 >= val2)
		{
			pc = var1;
		}	
	}

	void syn_ifeq(Stack* &stk, int *locals,int &pc,int var1) //13
	{
		int val1 = stk->head->val;
		stk->head = stk->head->next;
		if(val1 == 0)
		{
			pc = var1;
		}	
	}

	void syn_ifne(Stack* &stk, int *locals,int &pc,int var1) //14
	{
		int val1 = stk->head->val;
		stk->head = stk->head->next;
		if(val1 != 0)
		{
			pc = var1;
		}	
	}

	void syn_iflt(Stack* &stk, int *locals,int &pc,int var1) //15
	{
		int val1 = stk->head->val;
		stk->head = stk->head->next;
		if(val1 < 0)
		{
			pc = var1;
		}	
	}

	void syn_ifle(Stack* &stk, int *locals,int &pc,int var1) //16
	{
		int val1 = stk->head->val;
		stk->head = stk->head->next;
		if(val1 <= 0)
		{
			pc = var1;
		}	
	}

	void syn_ifgt(Stack* &stk, int *locals,int &pc,int var1) //17
	{
		int val1 = stk->head->val;
		stk->head = stk->head->next;
		if(val1 > 0)
		{
			pc = var1;
		}	
	}

	void syn_ifge(Stack* &stk, int *locals,int &pc,int var1) //18
	{
		int val1 = stk->head->val;
		stk->head = stk->head->next;
		if(val1 >= 0)
		{
			pc = var1;
		}	
	}

	void syn_iinc(Stack* &stk, int *locals,int &pc,int var1,int var2) //19
	{
		locals[var1] = locals[var1] + var2;
	}

	void syn_iconst_m1(Stack* &stk, int *locals,int &pc) //20
	{
		Node*  n=NULL;
		n = Node::create(-1, NULL);
		n->next = stk->head;
		stk->head = n;
		pc = pc + 1;
	}

	void syn_iconst_0(Stack* &stk, int *locals,int &pc) //21
	{
		Node*  n=NULL;
		n = Node::create(0, NULL);
		n->next = stk->head;
		stk->head = n;
		pc = pc + 1;
	}

	void syn_iconst_1(Stack* &stk, int *locals,int &pc) //22
	{
		Node*  n=NULL;
		n = Node::create(1, NULL);
		n->next = stk->head;
		stk->head = n;
		pc = pc + 1;
	}

	void syn_iconst_2(Stack* &stk, int *locals,int &pc) //23
	{
		Node*  n=NULL;
		n = Node::create(2, NULL);
		n->next = stk->head;
		stk->head = n;
		pc = pc + 1;
	}

	void syn_iconst_3(Stack* &stk, int *locals,int &pc) //24
	{
		Node*  n=NULL;
		n = Node::create(3, NULL);
		n->next = stk->head;
		stk->head = n;
		pc = pc + 1;
	}

	void syn_iconst_4(Stack* &stk, int *locals,int &pc) //25
	{
		Node*  n=NULL;
		n = Node::create(4, NULL);
		n->next = stk->head;
		stk->head = n;
		pc = pc + 1;
	}

	void syn_iconst_5(Stack* &stk, int *locals,int &pc) //26
	{
		Node*  n=NULL;
		n = Node::create(5, NULL);
		n->next = stk->head;
		stk->head = n;
		pc = pc + 1;
	}

	void syn_iload(Stack* &stk, int *locals,int &pc,int var1) //27
	{
		Node*  n=NULL;
		n = Node::create(locals[var1], NULL);
		n->next = stk->head;
		stk->head = n;
		pc = pc + 1;
	}

	void syn_iload_0(Stack* &stk, int *locals,int &pc) //28
	{
		Node*  n=NULL;
		n = Node::create(locals[0], NULL);
		n->next = stk->head;
		stk->head = n;
		pc = pc + 1;
	}

	void syn_iload_1(Stack* &stk, int *locals,int &pc) //29
	{
		Node*  n=NULL;
		n = Node::create(locals[1], NULL);
		n->next = stk->head;
		stk->head = n;
		pc = pc + 1;
	}

	void syn_iload_2(Stack* &stk, int *locals,int &pc) //30
	{
		Node*  n=NULL;
		n = Node::create(locals[2], NULL);
		n->next = stk->head;
		stk->head = n;
		pc = pc + 1;
	}

	void syn_iload_3(Stack* &stk, int *locals,int &pc) //31
	{
		Node*  n=NULL;
		n = Node::create(locals[3], NULL);
		n->next = stk->head;
		stk->head = n;
		pc = pc + 1;
	}

	void syn_ineg(Stack* &stk, int *locals,int &pc) //32
	{
		stk->head->val = -stk->head->val;
		pc = pc + 1;
	}

	void syn_iadd(Stack* &stk, int *locals,int &pc) //33
	{
		int val2 = stk->head->val;
		stk->head = stk->head->next;
		int val1 = stk->head->val;
		stk->head->val = val1 + val2;
		pc = pc + 1;
	}

	void syn_isub(Stack* &stk, int *locals,int &pc) //34
	{
		int val2 = stk->head->val;
		stk->head = stk->head->next;
		int val1 = stk->head->val;
		stk->head->val = val1 - val2;
		pc = pc + 1;
	}

	void syn_imul(Stack* &stk, int *locals,int &pc) //35
	{
		int val2 = stk->head->val;
		stk->head = stk->head->next;
		int val1 = stk->head->val;
		stk->head->val = val1 * val2;
		pc = pc + 1;
	}

	void syn_idiv(Stack* &stk, int *locals,int &pc) //36
	{
		int val2 = stk->head->val;
		stk->head = stk->head->next;
		int val1 = stk->head->val;
		stk->head->val = val1 / val2;
		pc = pc + 1;
	}

	void syn_irem(Stack* &stk, int *locals,int &pc) //37
	{
		int val2 = stk->head->val;
		stk->head = stk->head->next;
		int val1 = stk->head->val;
		stk->head->val = val1 % val2;
		pc = pc + 1;
	}

}

