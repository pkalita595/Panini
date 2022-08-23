#include <cstdio>
#include <assert.h>
#include <iostream>
using namespace std;
#include "vops.h"
#include "temp.h"
namespace ANONYMOUS{

void main__Wrapper() {
  int  _out_s15=0;
  _main(_out_s15);
}
void main__WrapperNospec() {}
void _main(int& _out) {
  bool  _out_s1=0;
  syn(0, 1, _out_s1);
  assert ((1) == (_out_s1));;
  bool  _out_s3=0;
  syn(0, 1, _out_s3);
  assert ((1) == (_out_s3));;
  bool  _out_s5=0;
  syn(1, 0, _out_s5);
  assert ((1) == (_out_s5));;
  bool  _out_s7=0;
  syn(0, 0, _out_s7);
  assert ((0) == (_out_s7));;
  _out = 0;
  return;
}
void syn(bool x, bool y, bool& _out) {
  _out = y | x;
  return;
}

}
