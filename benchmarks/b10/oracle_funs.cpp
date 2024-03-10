/*
 * Correct definitions of grammar
 */

#include "aux_fun.c"

extern "C"
{
    void addReal(int xReal, int xDual, int yReal, int yDual,int &_out)
    {
        _out = xReal + yReal;
    }

    void subReal(int xReal, int xDual, int yReal, int yDual,int &_out)
    {
        _out = xReal - yReal;
    }

    void mulReal(int xReal, int xDual, int yReal, int yDual,int &_out)
    {
        _out = xReal * yReal;
    }

    void divideReal(int xReal, int xDual, int yReal, int yDual,int &_out)
    {   
        int x = xReal;
        int y = yReal;
        int val = x/y;
        _out = val;
    }
    void powReal(int xReal, int xDual, int yReal, int yDual,int &_out){
         pow(xReal, yReal, _out);
    }
    void sinReal(int xReal, int xDual, int yReal, int yDual,int &_out){
        sin(xReal, _out);
    }
    void cosReal(int xReal, int xDual, int yReal, int yDual,int &_out){
        cos(xReal, _out);
    }    void addDual(int xReal, int xDual, int yReal, int yDual,int &_out)
    {
        _out = xDual + yDual;
    }
    void subDual(int xReal, int xDual, int yReal, int yDual,int &_out)
    {
        _out = xDual - yDual;
    }

    void mulDual(int xReal, int xDual, int yReal, int yDual,int &_out)
    {
        _out = xReal * yDual + xDual * yReal;
    }

    void divideDual(int xReal, int xDual, int yReal, int yDual,int &_out)
    {
        int x = (xDual * yReal - xReal * yDual);
        int y = (yReal * yReal);
        int val = x/y ;
        _out = val;
    }
    void powDual(int xReal, int xDual, int yReal, int yDual,int &_out)
    {  int a; pow(xReal, yReal - 1, a);
        _out = xDual * yReal * a;
    }
    void sinDual(int xReal, int xDual, int yReal, int yDual,int &_out)
    {
        int ans ; cos(xReal, ans);
        _out = xDual * ans;
    }
    void cosDual(int xReal, int xDual, int yReal, int yDual,int &_out)
    {
        int ans ; sin(xReal, ans);
        _out = -xDual * ans;
    }
    
}
