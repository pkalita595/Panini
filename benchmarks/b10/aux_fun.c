extern "C"
{
    void sin(int a, int & out){
        out = a - ((a*a*a)/6);
    } 

    void cos(int a, int & out){
        out = 1 - ((a * a)/2);
    } 

    void pow(int x, int y , int & out){
        int val = 1;
         if(y < 0){
            y = -y;
            for(int i = 0; i < y; i++) 
                val = val / x; 
            out =  val;
        }
        for(int i = 0; i < y; i++) val = val * x;
        out =  val;
    }
} 
