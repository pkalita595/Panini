/*
 * Correct definitions of grammar
 */

extern "C"
{

	void add(int x,int y,int &_out)
	{
		_out = x + y;
	}

	void sub(int x,int y,int &_out)
	{
		_out = x - y;
	}


	void mul(int x,int y,int &_out)
	{
		_out = x * y;
	}


	void divide(int x,int y,int &_out)
	{
		_out = x / y;
	}
	
}
