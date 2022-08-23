/*
 * Correct definitions of grammar
 */

extern "C"
{
    enum type {INT, BOOL, ERROR};

	void syn_plus(int x,int y,int &_out)
	{
        if ((x == INT) && (y == INT))
            _out = INT;
        else
            _out = ERROR;
	}
	
    void syn_minus(int x,int y,int &_out)
	{
        if ((x == INT) && (y == INT))
            _out = INT;
        else
            _out = ERROR;
	}

	void syn_or(int x,int y,int &_out)
	{
        if ((x == BOOL) && (y == BOOL))
            _out = BOOL;
        else
            _out = ERROR;
	}

	void syn_and(int x,int y,int &_out)
	{
        if ((x == BOOL) && (y == BOOL))
            _out = BOOL;
        else
            _out = ERROR;
	}

	void syn_eq(int x,int y,int &_out)
	{
        if ((x == y) && (x != ERROR))
            _out = BOOL;
        else
            _out = ERROR;
	}



	
}
