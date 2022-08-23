/*
 * Correct definitions of grammar
 */

extern "C"
{

	void syn_fun_a(int x,int y,int &_out)
	{
		_out = 2*x + y;
	}

	
}
