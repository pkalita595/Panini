%{

extern "C"
{
	int yyparse();
	int yylex(void);
	void yyerror(char *s){}
	int yywrap(void){return 1;}
}

#include <cstdio>
#include <cstdlib>
#include <assert.h>
#include <cstring>
#define  BIG_SIZE 10000
#define FUN_STATE_SIZE 20
#define NUM_FUNS 40
#define FUN_DEF_SIZE (NUM_FUNS*1000)
#define FBAR_FUN_DEF_SIZE (FUN_DEF_SIZE * NUM_FUNS)
#define ASSERT_STMT_SIZE (NUM_FUNS *60)

int p = 0,offset = 200;
long long code;
int last_id;
int pc = 0;


%}

%union
{
	int f; //maintains the last allocated pointer address in the current tree
}

%token <f>  NUM bipush istore istore_0 istore_1 istore_2 istore_3 if_icmple if_icmplt if_icmpne if_icmpeq if_icmpge if_icmpgt
%token <f>  ifeq ifge ifgt ifle iflt ifne iinc iconst_m1 iconst_0 iconst_1 iconst_2 iconst_3 iconst_4 iconst_5
%token <f>  iload iload_0  iload_1  iload_2  iload_3 ineg iadd isub imul idiv irem  
%type <f> E Q P  

%%

S : Q '\n'	{	return 0;	}
  ;

Q : E '=' NUM ',' NUM 
  		{
			printf("\tassert stk.head.val == %d;\n",$3);
			printf("\tassert pc[1] == %d;\n",$5);
                        for(int i=2;i<=last_id;i++)
                        {
                                printf("\tassert stk_%d.head.val == %d;\n",i,$3);
				printf("\tassert pc[%d] == %d;\n",i,$5);
                        }
		}
  ;


E : P ';' E    {;}
  | P ';'      {;}
  ;


P : NUM ':' bipush NUM   {
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_bipush(stk,locals,pc[1],%d);\n",$4);
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_bipush%d(stk_%d,locals_%d,pc[%d],%d);\n",i,i,i,i,$4);
					}	
					pc = $1 + 1;
				}
			}


  | NUM ':' istore NUM  {       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_istore(stk,locals,pc[1],%d);\n",$4);
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_istore%d(stk_%d,locals_%d,pc[%d],%d);\n",i,i,i,i,$4);
					}	
					pc = $1 + 1;
				}
			}

  | NUM ':' istore_0    {       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_istore_0(stk,locals,pc[1]);\n");
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_istore_0%d(stk_%d,locals_%d,pc[%d]);\n",i,i,i,i);
					}	
					pc = $1 + 1;
				}
			}

  | NUM ':' istore_1	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_istore_1(stk,locals,pc[1]);\n");
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_istore_1%d(stk_%d,locals_%d,pc[%d]);\n",i,i,i,i);
					}	
					pc = $1 + 1;
				}
			}

  | NUM ':' istore_2 	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_istore_2(stk,locals,pc[1]);\n");
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_istore_2%d(stk_%d,locals_%d,pc[%d]);\n",i,i,i,i);
					}	
					pc = $1 + 1;
				}
			}


  | NUM ':' istore_3	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_istore_3(stk,locals,pc[1]);\n");
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_istore_3%d(stk_%d,locals_%d,pc[%d]);\n",i,i,i,i);
					}	
					pc = $1 + 1;
				}
			}


  | NUM ':' if_icmple NUM{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_if_icmple(stk,locals,pc[1],%d);\n",$4);
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_if_icmple%d(stk_%d,locals_%d,pc[%d],%d);\n",i,i,i,i,$4);
					}	
	
					pc = $4;	
					//pc = $1 + 1;
				}
			}


  | NUM ':' if_icmplt NUM{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_if_icmplt(stk,locals,pc[1],%d);\n",$4);
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_if_icmplt%d(stk_%d,locals_%d,pc[%d],%d);\n",i,i,i,i,$4);
					}
					pc = $4;	
				}
			}


  | NUM ':' if_icmpeq NUM{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_if_icmpeq(stk,locals,pc[1],%d);\n",$4);
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_if_icmpeq%d(stk_%d,locals_%d,pc[%d],%d);\n",i,i,i,i,$4);
					}
					pc = $4;	
				}
			}

  | NUM ':' if_icmpge NUM{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_if_icmpge(stk,locals,pc[1],%d);\n",$4);
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_if_icmpge%d(stk_%d,locals_%d,pc[%d],%d);\n",i,i,i,i,$4);
					}
					pc = $4;	
				}
			}


  | NUM ':' if_icmpgt NUM{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_if_icmpgt(stk,locals,pc[1],%d);\n",$4);
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_if_icmpgt%d(stk_%d,locals_%d,pc[%d],%d);\n",i,i,i,i,$4);
					}
					pc = $4;	
				}
			}


  | NUM ':' ifeq NUM	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_ifeq(stk,locals,pc[1],%d);\n",$4);
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_ifeq%d(stk_%d,locals_%d,pc[%d],%d);\n",i,i,i,i,$4);
					}
					pc = $4;	
				}
			}


  | NUM ':' ifge NUM	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_ifge(stk,locals,pc[1],%d);\n",$4);
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_ifge%d(stk_%d,locals_%d,pc[%d],%d);\n",i,i,i,i,$4);
					}
					pc = $4;	
				}
			}


  | NUM ':' ifgt NUM	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_ifgt(stk,locals,pc[1],%d);\n",$4);
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_ifgt%d(stk_%d,locals_%d,pc[%d],%d);\n",i,i,i,i,$4);
					}
					pc = $4;	
				}
			}


  | NUM ':' ifle NUM	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_ifle(stk,locals,pc[1],%d);\n",$4);
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_ifle%d(stk_%d,locals_%d,pc[%d],%d);\n",i,i,i,i,$4);
					}
					pc = $4;	
				}
			}

  | NUM ':' iflt NUM	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_iflt(stk,locals,pc[1],%d);\n",$4);
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_iflt%d(stk_%d,locals_%d,pc[%d],%d);\n",i,i,i,i,$4);
					}
					pc = $4;	
				}
			}


  | NUM ':' ifne NUM	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_ifne(stk,locals,pc[1],%d);\n",$4);
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_ifne%d(stk_%d,locals_%d,pc[%d],%d);\n",i,i,i,i,$4);
					}
					pc = $4;	
				}
			}

  
  | NUM ':' iinc NUM ',' NUM {       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_iinc(stk,locals,pc[1],%d,%d);\n",$4,$6);
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_iinc%d(stk_%d,locals_%d,pc[%d],%d,%d);\n",i,i,i,i,$4,$6);
					}
					pc = $4;	
					//pc = $1 + 1;	
				}
			}

  | NUM ':' iconst_m1	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_iconst_m1(stk,locals,pc[1]);\n");
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_iconst_m1%d(stk_%d,locals_%d,pc[%d]);\n",i,i,i,i);
					}
					pc = $1 + 1;	
				}
			}

  | NUM ':' iconst_0	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_iconst_0(stk,locals,pc[1]);\n");
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_iconst_0%d(stk_%d,locals_%d,pc[%d]);\n",i,i,i,i);
					}
					pc = $1 + 1;	
				}
			}


  | NUM ':' iconst_1	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_iconst_1(stk,locals,pc[1]);\n");
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_iconst_1%d(stk_%d,locals_%d,pc[%d]);\n",i,i,i,i);
					}
					pc = $1 + 1;	
				}
			}



  | NUM ':' iconst_2	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_iconst_2(stk,locals,pc[1]);\n");
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_iconst_2%d(stk_%d,locals_%d,pc[%d]);\n",i,i,i,i);
					}
					pc = $1 + 1;	
				}
			}


  | NUM ':' iconst_3	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_iconst_3(stk,locals,pc[1]);\n");
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_iconst_3%d(stk_%d,locals_%d,pc[%d]);\n",i,i,i,i);
					}
					pc = $1 + 1;	
				}
			}

  | NUM ':' iconst_4	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_iconst_4(stk,locals,pc[1]);\n");
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_iconst_4%d(stk_%d,locals_%d,pc[%d]);\n",i,i,i,i);
					}
					pc = $1 + 1;	
				}
			}

  | NUM ':' iconst_5	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_iconst_5(stk,locals,pc[1]);\n");
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_iconst_5%d(stk_%d,locals_%d,pc[%d]);\n",i,i,i,i);
					}
					pc = $1 + 1;	
				}
			}


  | NUM ':' iload NUM	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_iload(stk,locals,pc[1],%d);\n",$4);
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_iload%d(stk_%d,locals_%d,pc[%d],%d);\n",i,i,i,i,$4);
					}
					pc = $1 + 1;	
				}
			}


  | NUM ':' iload_0	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_iload_0(stk,locals,pc[1]);\n");
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_iload_0%d(stk_%d,locals_%d,pc[%d]);\n",i,i,i,i);
					}
					pc = $1 + 1;	
				}
			}


  | NUM ':' iload_1	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_iload_1(stk,locals,pc[1]);\n");
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_iload_1%d(stk_%d,locals_%d,pc[%d]);\n",i,i,i,i);
					}
					pc = $1 + 1;	
				}
			}


  | NUM ':' iload_2	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_iload_2(stk,locals,pc[1]);\n");
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_iload_2%d(stk_%d,locals_%d,pc[%d]);\n",i,i,i,i);
					}
					pc = $1 + 1;	
				}
			}
  | NUM ':' iload_3	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_iload_3(stk,locals,pc[1]);\n");
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_iload_3%d(stk_%d,locals_%d,pc[%d]);\n",i,i,i,i);
					}
					pc = $1 + 1;	
				}
			}

  
  | NUM ':' ineg	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_ineg(stk,locals,pc[1]);\n");
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_ineg%d(stk_%d,locals_%d,pc[%d]);\n",i,i,i,i);
					}
					pc = $1 + 1;	
				}
			}


  | NUM ':' imul	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_imul(stk,locals,pc[1]);\n");
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_imul%d(stk_%d,locals_%d,pc[%d]);\n",i,i,i,i);
					}
					pc = $1 + 1;	
				}
			}


  | NUM ':' iadd	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_iadd(stk,locals,pc[1]);\n");
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_iadd%d(stk_%d,locals_%d,pc[%d]);\n",i,i,i,i);
					}
					pc = $1 + 1;	
				}
			}

  | NUM ':' isub	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_isub(stk,locals,pc[1]);\n");
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_isub%d(stk_%d,locals_%d,pc[%d]);\n",i,i,i,i);
					}
					pc = $1 + 1;	
				}
			}

  | NUM ':' idiv	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_idiv(stk,locals,pc[1]);\n");
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_idiv%d(stk_%d,locals_%d,pc[%d]);\n",i,i,i,i);
					}
					pc = $1 + 1;	
				}
			}

  | NUM ':' irem	{       
				if($1 >= pc) 
				{
					printf("\tpc[1] = %d;\n",$1);
					printf("\tsyn_irem(stk,locals,pc[1]);\n");
					for(int i=2;i<=last_id;i++)
					{
						printf("\tpc[%d] = %d;\n",i,$1);
						printf("\tsyn_irem%d(stk_%d,locals_%d,pc[%d]);\n",i,i,i,i);
					}
					pc = $1 + 1;	
				}
			}

  ;

// O : NUM		{	$$  = $1;	}
//   ;
%%

void takeSynFun(char* str, long long id){
    char buff[500] = {'\0'};
    int i = 0;
    char filename[40] = {'\0'};
    //printf("From take %d\n", id);
    sprintf(filename, "fun_holes_dir/%lld.sk", id);
    FILE* fp1 = fopen(filename, "r");
    while((fscanf(fp1,"%c",&buff[i]))!=EOF) //scanf and check EOF
    {
            i++;
    }
    strcat(str, buff);
    fclose(fp1);
}



char* get_fun_defs(int id, int is_first)
{
	char *fun_id = "";
	if(!is_first)
	{
		fun_id = (char *)malloc(3);
		sprintf(fun_id,"%d",id);

	}

	long long curr_code = code;
	
	char *str = (char *)malloc(FUN_DEF_SIZE);
	sprintf(str,"");

	if(curr_code & 1 == 1)		//1. synthesize bipush
	{
		sprintf(str,""
		"void syn_bipush%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"       int  p = 0,bnd=0;\n"
		"	_gen(stk,locals,pc,state[%d][0],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize bipush
	{
	/*	sprintf(str,""
		"void syn_bipush%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"	Node n = new Node(val = var1,next = null);\n"
		"	n.next = stk.head;\n"
		"	stk.head = n;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
    */
    takeSynFun(str, 1);
	}

	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//2. synthesize istore index
	{
		sprintf(str+strlen(str),""
		"void syn_istore%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][1],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize istore 
	{
	/*	sprintf(str+strlen(str),""
		"void syn_istore%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"	locals[var1]  = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
    */
    takeSynFun(str+strlen(str), 2);
	}


	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//3. synthesize istore_0
	{
		sprintf(str+strlen(str),""
		"void syn_istore_0%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][2],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize istore_0
	{
    /*
		sprintf(str+strlen(str),""
		"void syn_istore_0%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"	locals[0]  = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
    */
    takeSynFun(str+strlen(str), 4);
	}

	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//4. synthesize istore_1
	{
		sprintf(str+strlen(str),""
		"void syn_istore_1%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][3],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize istore_1
	{
    /*	sprintf(str+strlen(str),""
		"void syn_istore_1%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"	locals[1]  = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
    */
    takeSynFun(str+strlen(str), 8);
	}


	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//5. synthesize istore_2
	{
		sprintf(str+strlen(str),""
		"void syn_istore_2%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][4],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize istore_2
	{
	/*
    	sprintf(str+strlen(str),""
		"void syn_istore_2%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"	locals[2]  = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
    */
    takeSynFun(str+strlen(str), 16);
	}

	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//6. synthesize istore_3
	{
		sprintf(str+strlen(str),""
		"void syn_istore_3%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][5],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize 
	{
    /*
		sprintf(str+strlen(str),""
		"void syn_istore_3%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"	locals[3]  = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
    */
    takeSynFun(str+strlen(str), 32);
	}

	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//7. synthesize syn_if_icmpeq
	{
		sprintf(str+strlen(str),""
		"void syn_if_icmpeq%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][6],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_if_icmpeq%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"	int val2 = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	int val1 = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	if(val1 == val2)\n"
		"	{\n"
		"		pc = var1;\n"
		"	}\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 64);
	}

/*
	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//8. synthesize syn_if_icmpne
	{
		sprintf(str+strlen(str),""
		"void syn_if_icmpne%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][7],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
		sprintf(str+strlen(str),""
		"void syn_if_icmpne%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"	int val2 = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	int val1 = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	if(val1 != val2)\n"
		"	{\n"
		"		pc = var1;\n"
		"	}\n"
		"}\n"
		"\n",fun_id);
	}

*/
	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//9. synthesize syn_if_icmplt
	{
		sprintf(str+strlen(str),""
		"void syn_if_icmplt%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][8],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
    /*
		sprintf(str+strlen(str),""
		"void syn_if_icmplt%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"	int val2 = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	int val1 = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	if(val1 < val2)\n"
		"	{\n"
		"		pc = var1;\n"
		"	}\n"
		"}\n"
		"\n",fun_id);
    */
    takeSynFun(str+strlen(str), 128);
	}

	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//10. synthesize syn_if_icmple
	{
		sprintf(str+strlen(str),""
		"void syn_if_icmple%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][9],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_if_icmple%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"	int val2 = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	int val1 = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	if(val1 <= val2)\n"
		"	{\n"
		"		pc = var1;\n"
		"	}\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 256);
	}

	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//11. synthesize syn_if_icmplgt
	{
		sprintf(str+strlen(str),""
		"void syn_if_icmpgt%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][10],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_if_icmpgt%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"	int val2 = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	int val1 = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	if(val1 > val2)\n"
		"	{\n"
		"		pc = var1;\n"
		"	}\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 512);
	}

	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//12. synthesize syn_if_icmpge
	{
		sprintf(str+strlen(str),""
		"void syn_if_icmpge%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][11],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_if_icmpge%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"	int val2 = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	int val1 = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	if(val1 >= val2)\n"
		"	{\n"
		"		pc = var1;\n"
		"	}\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 1024);
	}


	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//13. synthesize syn_ifeq
	{
		sprintf(str+strlen(str),""
		"void syn_ifeq%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][12],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_ifeq%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"	int val1 = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	if(val1 == 0)\n"
		"	{\n"
		"		pc = var1;\n"
		"	}\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 2048);
	}

	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//14. synthesize syn_ifne
	{
		sprintf(str+strlen(str),""
		"void syn_ifne%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][13],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_ifne%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"	int val1 = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	if(val1 != 0)\n"
		"	{\n"
		"		pc = var1;\n"
		"	}\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 4096);
	}


	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//17. synthesize syn_iflt
	{
		sprintf(str+strlen(str),""
		"void syn_iflt%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][16],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_iflt%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"	int val1 = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	if(val1 < 0)\n"
		"	{\n"
		"		pc = var1;\n"
		"	}\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 8192);
	}

	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//18. synthesize syn_ifle
	{
		sprintf(str+strlen(str),""
		"void syn_ifle%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][17],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_ifle%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"	int val1 = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	if(val1 <= 0)\n"
		"	{\n"
		"		pc = var1;\n"
		"	}\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 16384);
	}



	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//15. synthesize syn_ifgt
	{
		sprintf(str+strlen(str),""
		"void syn_ifgt%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][14],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_ifgt%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"	int val1 = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	if(val1 > 0)\n"
		"	{\n"
		"		pc = var1;\n"
		"	}\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 32768);
	}


	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//16. synthesize syn_ifge
	{
		sprintf(str+strlen(str),""
		"void syn_ifge%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][15],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_ifge%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1)\n"
		"{\n"
		"	int val1 = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	if(val1 >= 0)\n"
		"	{\n"
		"		pc = var1;\n"
		"	}\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 65536);
	}


	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//19. synthesize syn_iinc
	{
		sprintf(str+strlen(str),""
		"void syn_iinc%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1,int var2)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][18],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_iinc%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc ,int var1, int var2)\n"
		"{\n"
		"	 locals[var1] = locals[var1] + var2;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 131072);
	}

	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//20. synthesize syn_iconst_m1
	{
		sprintf(str+strlen(str),""
		"void syn_iconst_m1%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][19],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_iconst_m1%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"	Node n = new Node(val = -1, next = null);\n"
		"	n.next = stk.head;\n"
		"	stk.head = n;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 262144);
	}

	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//21. synthesize syn_iconst_0
	{
		sprintf(str+strlen(str),""
		"void syn_iconst_0%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][20],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_iconst_0%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"	Node n = new Node(val = 0, next = null);\n"
		"	n.next = stk.head;\n"
		"	stk.head = n;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 524288);
	}

	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//22. synthesize syn_iconst_1
	{
		sprintf(str+strlen(str),""
		"void syn_iconst_1%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][21],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_iconst_1%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"	Node n = new Node(val = 1, next = null);\n"
		"	n.next = stk.head;\n"
		"	stk.head = n;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 1048576);
	}

	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//23. synthesize syn_iconst_2
	{
		sprintf(str+strlen(str),""
		"void syn_iconst_2%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][22],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_iconst_2%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"	Node n = new Node(val = 2, next = null);\n"
		"	n.next = stk.head;\n"
		"	stk.head = n;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 2097152);
	}

	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//24. synthesize syn_iconst_3
	{
		sprintf(str+strlen(str),""
		"void syn_iconst_3%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][23],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_iconst_3%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"	Node n = new Node(val = 3, next = null);\n"
		"	n.next = stk.head;\n"
		"	stk.head = n;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 4194304);
	}

	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//25. synthesize syn_iconst_4
	{
		sprintf(str+strlen(str),""
		"void syn_iconst_4%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][24],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_iconst_4%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"	Node n = new Node(val = 4, next = null);\n"
		"	n.next = stk.head;\n"
		"	stk.head = n;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 8388608);
	}

	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//26. synthesize syn_iconst_5
	{
		sprintf(str+strlen(str),""
		"void syn_iconst_5%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][25],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_iconst_5%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"	Node n = new Node(val = 5, next = null);\n"
		"	n.next = stk.head;\n"
		"	stk.head = n;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 16777216);
	}

	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//27. synthesize syn_iload index
	{
		sprintf(str+strlen(str),""
		"void syn_iload%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc,int var1)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][26],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_iload%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc,int var1)\n"
		"{\n"
		"	Node n = new Node(val = locals[var1], next = null);\n"
		"	n.next = stk.head;\n"
		"	stk.head = n;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 33554432);
	}


	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//28. synthesize syn_iload_0
	{
		sprintf(str+strlen(str),""
		"void syn_iload_0%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][27],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_iload_0%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"	Node n = new Node(val = locals[0], next = null);\n"
		"	n.next = stk.head;\n"
		"	stk.head = n;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 67108864);
	}


	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//29. synthesize syn_iload_1
	{
		sprintf(str+strlen(str),""
		"void syn_iload_1%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][28],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_iload_1%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"	Node n = new Node(val = locals[1], next = null);\n"
		"	n.next = stk.head;\n"
		"	stk.head = n;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 134217728);
	}

	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//30. synthesize syn_iload_2
	{
		sprintf(str+strlen(str),""
		"void syn_iload_2%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][29],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_iload_2%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"	Node n = new Node(val = locals[2], next = null);\n"
		"	n.next = stk.head;\n"
		"	stk.head = n;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 268435456);
	}


	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//31. synthesize syn_iload_3
	{
		sprintf(str+strlen(str),""
		"void syn_iload_3%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][30],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_iload_3%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"	Node n = new Node(val = locals[3], next = null);\n"
		"	n.next = stk.head;\n"
		"	stk.head = n;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 536870912);
	}


	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//32. synthesize syn_ineg
	{
		sprintf(str+strlen(str),""
		"void syn_ineg%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][31],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_ineg%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"	stk.head.val = -stk.head.val;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 1073741824);
	}


	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//33. synthesize syn_iadd
	{
		sprintf(str+strlen(str),""
		"void syn_iadd%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][32],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_iadd%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"	int val2 = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	int val1 = stk.head.val;\n"
		"	stk.head.val = val1 + val2;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 2147483648);
	}

	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//34. synthesize syn_isub
	{
		sprintf(str+strlen(str),""
		"void syn_isub%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][33],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_isub%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"	int val2 = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	int val1 = stk.head.val;\n"
		"	stk.head.val = val1 - val2;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 4294967296);
	}

	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//35. synthesize syn_imul
	{
		sprintf(str+strlen(str),""
		"void syn_imul%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][34],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_imul%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"	int val2 = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	int val1 = stk.head.val;\n"
		"	stk.head.val = val1 * val2;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 8589934592);
	}

	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//36. synthesize syn_idiv
	{
		sprintf(str+strlen(str),""
		"void syn_idiv%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][35],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_idiv%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"	int val2 = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	int val1 = stk.head.val;\n"
		"	stk.head.val = val1 / val2;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 17179869184);
	}

	curr_code = curr_code >> 1; // devide by 2 .ie right shift
	if(curr_code & 1 == 1)		//37. synthesize syn_irem
	{
		sprintf(str+strlen(str),""
		"void syn_irem%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"       int  p = 0;\n"
		"	_gen(stk,locals,pc,state[%d][36],p,var1,var2,bnd);\n"
		"}\n"
		"\n",fun_id,id-1);
	}
	else				//do not synthesize  
	{
        /*
		sprintf(str+strlen(str),""
		"void syn_irem%s(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc)\n"
		"{\n"
		"	int val2 = stk.head.val;\n"
		"	stk.head = stk.head.next;\n"
		"	int val1 = stk.head.val;\n"
		"	stk.head.val = val1 % val2;\n"
		"	pc = pc + 1;\n"
		"}\n"
		"\n",fun_id);
        */
        takeSynFun(str+strlen(str), 34359738368);
	}

	return str;
}

//to get the assert statement to ensure Fi != Fj
char * get_assert(int i,int j)
{
	char *str = (char *)malloc(ASSERT_STMT_SIZE);
	sprintf(str,"\tassert ( ");
	for(int f=0;f<NUM_FUNS;f++)
	{
		sprintf(str+strlen(str),"(equal(state[%d][%d], state[%d][%d]) == 0) || ",i,f,j,f);
	}
	sprintf(str+strlen(str)," false );\n");
	return str; 
}

int main(int argc,char **argv)
{

	code = atoll(argv[1]);

	//get the current F_bar_id
	FILE *f_bar = fopen("last_F_bar_id","r");
	if(!f_bar)
	{
		last_id = 2; //default F_bar_id
	}
	else
	{
		fscanf(f_bar,"%d",&last_id);
		fclose(f_bar);
	}	
	//all F' definitions
	char* F_bar_definitions = (char*)malloc(100000);
	memset(F_bar_definitions,'\0',100000);

	//all F definitions
	char* F_definitions = (char*)malloc(100000);
	memset(F_definitions,'\0',100000);


	strcat(F_definitions,get_fun_defs(1,1)); //getting the F_definitions

	for(int i=2;i<=last_id;i++)
	{
		strcat(F_bar_definitions,get_fun_defs(i,0));
	}


	//printing the Node class and Stack class definitions
	printf(""

	"struct Node\n"
	"{\n"
	"	int val;\n"
	"	Node next;\n"
	"}\n"
	"\n"
	"struct Stack\n"
	"{\n"
	"	Node head;\n"
	"}\n"
	"\n"
	"int NUM_LOCALS = 100;\n"
	"//int[NUM_LOCALS] locals; // local variables\n"
	"int bnd = 1;\n"
	"//default parameter values\n"
	"int var1 = -1; \n"
	"int var2 = -1; \n"
	"int[%d] pc; //intitial Program counter\n"
	"int p = 0;\n"
	"int STATE_SIZE = 20;\n",last_id+1);

	printf("//last id : %d\n",last_id);


	//definitoins of functions to be synthesized
	printf(""

	//data strcutures to store the state of decisions taken for F and F'
	"int[%d][%d][%d] state;\n"
	"\n"
	//sketch generator used for synthesizing code
	
	"generator void _gen_istore(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc, ref int[STATE_SIZE] choices, ref int p,int var1,int var2, int bnd )\n"
	"{\n"
	"	int choice = ??(6);\n"
	"	int curr_p = p;\n"
	"	//choices[curr_p] = choice;\n"
	"	p = p+1;\n"
	"	assert bnd >= 0;\n"
	"	if(stk.head == null)\n"
	"	{\n"
	"		return;\n"
	"	}\n"
	"	if(choice == 41) //istore\n"
	"	{\n"
	"		locals[var1]  = stk.head.val;\n"
	"	}\n"
	"	else if(choice == 42) //istore_0\n"
	"	{\n"
	"		locals[0] = stk.head.val;\n"
	"	}\n"
	"	else if(choice == 43) //istore_1\n"
	"	{\n"
	"		locals[1] = stk.head.val;\n"
	"	}\n"
	"	else if(choice == 44) //istore_2\n"
	"	{\n"
	"		locals[2] = stk.head.val;\n"
	"	}\n"
	"	else //istore_3\n"
	"	{\n"
	"		//choices[curr_p] = 45;\n"
	"		locals[3] = stk.head.val;\n"
	"	}\n"
	"	stk.head = stk.head.next;\n"
	"	pc = pc + 1;\n"
	"}\n"
	"\n"
	"generator void _gen_if_icmp(ref Stack stk, ref int[NUM_LOCALS] locals,ref int pc,ref int[STATE_SIZE] choices, ref int p, int var1,int var2, int bnd )\n"
	"{\n"
	"	int val2 = stk.head.val;\n"
	"	stk.head = stk.head.next;\n"
	"	int val1 = stk.head.val;\n"
	"	stk.head = stk.head.next;\n"
	"	int choice = ??(6);\n"
	"	int curr_p = p;\n"
	"	//choices[curr_p] = choice;\n"
	"	p = p+1;\n"
	"	assert bnd >= 0;\n"
	"	if(choice == 51)	//if_icmpeq\n"
	"	{\n"
	"		if(val1 == val2)\n"
	"		{\n"
	"			pc = var1;\n"
	"		}\n"
	"	}\n"
	"	else if(choice == 52)\n"
	"	{\n"
	"		if(val1 != val2) //if_icmpne\n"
	"		{\n"
	"			pc = var1;\n"
	"		}\n"
	"	}\n"
	"	else if(choice == 53)\n"
	"	{\n"
	"		if(val1 < val2)   //if_icmplt\n"
	"			pc = var1;\n"
	"	}\n"
	"	else if(choice == 56)\n"
	"	{\n"
	"		if(val1 <= val2 )  //if_icmple\n"
	"			pc = var1;\n"
	"	}\n"
	"	else if(choice == 57)\n"
	"	{\n"
	"		if(val1 > val2)    //if_icmpgt\n"
	"			pc = var1;\n"
	"	}\n"
	"	else\n"
	"	{\n"
	"	//	choices[curr_p] = 58;\n"
	"		if(val1 >= val2)   //if_icmpge\n"
	"			pc = var1;\n"
	"	}\n"
	"}\n"
	"\n"
	"generator void _gen_if_zero(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc, ref int[STATE_SIZE] choices, ref int p,int var1,int var2, int bnd )\n"
	"{\n"
	"	int choice = ??(7);\n"
	"	int curr_p = p;\n"
	"	//choices[curr_p] = choice;\n"
	"	int val1 = stk.head.val;\n"
	"	stk.head = stk.head.next;\n"
	"	if(choice == 61)\n"
	"	{\n"
	"		if(val1 == 0)\n"
	"			pc = var1;\n"
	"	}\n"
	"	else if(choice == 62)\n"
	"	{\n"
	"		if(val1 != 0)\n"
	"			pc = var1;\n"
	"	}\n"
	"	else if(choice == 63)\n"
	"	{\n"
	"		if(val1 < 0)\n"
	"			pc = var1;\n"
	"	}\n"
	"	else if(choice == 64)\n"
	"	{\n"
	"		if(val1 <= 0)\n"
	"			pc = var1;\n"
	"	}\n"
	"	else if(choice == 65)\n"
	"	{\n"
	"		if(val1 > 0)\n"
	"			pc = var1;\n"
	"	}\n"
	"	else \n"
	"	{\n"
	"	//	choices[curr_p] = 66;\n"
	"		if(val1 >= 0)\n"
	"			pc = var1;\n"
	"	}\n"
	"}\n"
	"\n"
	"generator void _gen_iconst(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc, ref int[STATE_SIZE] choices, ref int p,int var1,int var2, int bnd )\n"
	"{\n"
	"	int choice = ??(7);\n"
	"	int curr_p = p;\n"
	"	//choices[curr_p] = choice;\n"
	"	p = p+1;\n"
	"	Node n = new Node(val = 0, next = null);\n"
	"	n.next = stk.head;\n"
	"	stk.head = n;\n"
	"	if(choice == 71)\n"
	"	{\n"
	"		stk.head.val = -1;	\n"
	"	}\n"
	"	else if(choice == 72)\n"
	"	{\n"
	"		stk.head.val = 0;\n"
	"	}\n"
	"	else if(choice == 73)\n"
	"	{\n"
	"		stk.head.val = 1;\n"
	"	}\n"
	"	else if(choice == 74)\n"
	"	{\n"
	"		stk.head.val = 2;\n"
	"	}\n"
	"	else if(choice == 75)\n"
	"	{\n"
	"		stk.head.val = 3;\n"
	"	}\n"
	"	else if(choice == 76)\n"
	"	{\n"
	"		stk.head.val = 4;\n"
	"	}\n"
	"	else\n"
	"	{\n"
	"	//	choices[curr_p] = 77;\n"
	"		stk.head.val = 5;\n"
	"	}\n"
	"	pc = pc + 1;\n"
	"}\n"
	"\n"
	"generator void _gen_iload(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc, ref int[STATE_SIZE] choices, ref int p,int var1,int var2, int bnd )\n"
	"{\n"
	"	int choice = ??(7);\n"
	"	Node n = new Node(val = 0, next = null);\n"
	"	n.next = stk.head;\n"
	"	stk.head = n;\n"
	"	int curr_p = p;\n"
	"	//choices[curr_p] = choice;\n"
	"	p = p+1;\n"
	"	if(choice == 81) 	//iload index\n"
	"	{\n"
	"		stk.head.val = locals[var1];	\n"
	"	}\n"
	"	else if(choice == 82)   //iload_0\n"
	"	{\n"
	"		stk.head.val = locals[0];\n"
	"	}\n"
	"	else if(choice == 83)	//iload_1\n"
	"	{\n"
	"		stk.head.val = locals[1];\n"
	"	}\n"
	"	else if(choice == 84)	//iload_2\n"
	"	{\n"
	"		stk.head.val = locals[2];\n"
	"	}\n"
	"	else 			//iload_3\n"
	"	{\n"
	"	//	choices[curr_p] = 85;\n"
	"		stk.head.val = locals[3];\n"
	"	}\n"
	"	pc = pc + 1;\n"
	"}\n"
	"\n"
	"generator void _gen_iarith(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc, ref int[STATE_SIZE] choices, ref int p,int var1,int var2, int bnd )\n"
	"{\n"
	"	int choice = ??(7);\n"
	"	int curr_p = p;\n"
	"	//choices[curr_p] = choice;\n"
	"	p = p+1;\n"
	"	if(choice == 91)	 //ineg\n"
	"	{\n"
	"		stk.head.val = -stk.head.val;\n"
	"	    pc = pc + 1;\n"
	"		return;\n"
	"	}\n"
	"	int val2 = stk.head.val;\n"
	"	stk.head = stk.head.next;\n"
	"	int val1 = stk.head.val;\n"
	"	if(choice == 92) 	 //iadd\n"
	"	{\n"
	"		stk.head.val  = val1 + val2;\n"
	"	}\n"
	"	else if(choice == 93) 	//isub\n"
	"	{\n"
	"		stk.head.val = val1 - val2;\n"
	"	}\n"
	"	else if(choice == 94)	//imul\n"
	"	{\n"
	"		stk.head.val = val1 * val2;\n"
	"	}\n"
	"	else if(choice == 95)	//idiv\n"
	"	{\n"
	"		assert val2 != 0;\n"
	"		stk.head.val = val1 / val2;\n"
	"	}\n"
	"	else\n"
	"	{\n"
	"		assert val2 != 0;\n"
	"	//	choices[curr_p] = 96;\n"
	"		stk.head.val = val1 % val2;\n"
	"	}	\n"
	"	pc = pc + 1;\n"
	"}\n"
	"\n"
	"generator void _gen(ref Stack stk, ref int[NUM_LOCALS] locals, ref int pc, ref int[STATE_SIZE] choices, ref int p,int var1,int var2, int bnd )\n"
	"{\n"
	"	int choice = ??(4);\n"
	"	assert bnd >= 0;\n"
	"	bnd = bnd - 1;\n"
	"	int curr_p = p;\n"
	"	//choices[curr_p] = choice;\n"
	"	p = p+1;\n"
	"	if(choice == 0) 	// syn_bipush operation\n"
	"	{	\n"
	"		Node n = new Node(val = var1,next = null);\n"
	"		n.next = stk.head;\n"
	"		stk.head = n;\n"
	"		pc = pc + 1;\n"
	"	}\n"
	"	else if(choice == 1)		//istores\n"
	"	{\n"
	"		_gen_istore(stk,locals,pc,choices,p,var1,var2,bnd);\n"
	"	}\n"
	"	else if(choice == 2)		//if_icmp\n"
	"	{\n"
	"		_gen_if_icmp(stk,locals,pc,choices,p,var1,var2,bnd);\n"
	"	}\n"
	"	else if(choice == 3)		//if_zero\n"
	"	{\n"
	"		_gen_if_zero(stk,locals,pc,choices,p,var1,var2,bnd);\n"
	"	}\n"
	"	else if(choice == 4)		//iinc\n"
	"	{\n"
	"		locals[var1] = locals[var1] + var2;\n"
	"		//pc = pc + 1;\n"
	"	}\n"
	"	else if(choice == 5)		//iconst\n"
	"	{\n"
	"		_gen_iconst(stk,locals,pc,choices,p,var1,var2,bnd);\n"
	"	}\n"
	"	else if(choice == 6)	//iloads\n"
	"	{\n"
	"		_gen_iload(stk,locals,pc,choices,p,var1,var2,bnd);\n"
	"	}\n"
	"	else			//arithmetic instructions\n"
	"	{\n"
	"	//	choices[curr_p] = 7;\n"
	"		_gen_iarith(stk,locals,pc,choices,p,var1,var2,bnd);\n"
	"	}\n"
	"}\n"
	"\n"

	"\n"
	"//-------------------------------\n"
	"\n"
	"%s"
	"\n"
	"//----------------------------\n"
	//functions of F'
	"%s"	
	//function to compare the decision state of two different functions
	"int equal(int[%d] A, int[%d] B)\n"
	"{\n"
	"	for(int i=0;i<%d;i++)\n"
	"	{\n"
	"		if(A[i] != B[i])\n"
	"			return 0;\n"
	"	}\n"
	"	return 1;\n"
	"} \n"
	"\n"
	//harness main() sketch code
	"harness int main() {\n"
	"	\n"
	"	/*for(int i=0;i<%d;i++)\n"
	"	{\n"
	"		for(int j=0;j<%d;j++)\n"
	"		{\n"
	"			for(int k=0;k<%d;k++) \n"
	"			{\n"
	"				state[i][j][k] = 0;  \n"
	"			}\n"
	"		}\n"
	"	}\n"
	"	for(int i=1;i<%d;i++)\n"
	"	{\n"
	"		pc[i] = 0;\n"
	"	}\n"
	"*/\n"
	//unknown array used for storing the intermediate computation during parsing at each production
	"	int BIG_SIZE = %d;\n"
	"	int[BIG_SIZE] unknown;\n"
	"\n",FUN_STATE_SIZE,NUM_FUNS,last_id,F_definitions,F_bar_definitions,FUN_STATE_SIZE,FUN_STATE_SIZE,FUN_STATE_SIZE,last_id,NUM_FUNS,FUN_STATE_SIZE,last_id+1,BIG_SIZE);

	//creating the stack data structure for each Fbar
	printf("\tStack stk = new Stack(head = null);\n");
	printf("\tint[NUM_LOCALS] locals;\n");
	for(int i=2;i<=last_id;i++)
	{
		printf("\tStack stk_%d = new Stack(head = null);\n",i);
		printf("\tint[NUM_LOCALS] locals_%d;\n",i);
	}	

	//reading the input expressions & calling yyparse() on each of the input
	system("wc input > input_stat ");
	FILE* input_stat = fopen("./input_stat","r");
	int num_exp = 0;
	fscanf(input_stat,"%d",&num_exp);
	fclose(input_stat);
	//printf("number of expression : %d\n",num_exp);
	for(int i=0;i<num_exp;i++)
	{
		pc = 0;
		yyparse();
		//printf("//str->head->val : %d\n",stk->head->val);
		printf("//pc : %d\n",pc);
	}

	char *assert_stmts = (char*)malloc(ASSERT_STMT_SIZE*(last_id)*(last_id-1)); //nc2 ways * 200 bytes for each pair assert
	memset(assert_stmts,'\0',ASSERT_STMT_SIZE*(last_id)*(last_id-1));
    /*
	for(int i=0;i<last_id-1;i++)
	{
		for(int j=i+1;j<last_id;j++)
		{
			strcat(assert_stmts,get_assert(i,j));
		}
	}
    */
	

	//assert statements for F != F1
	printf("%s\n"
	"\n"
	"	return 0;\n"
	"}\n",assert_stmts);

	return 0;
}
