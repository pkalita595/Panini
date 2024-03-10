#ifndef GRAM_H
#define GRAM_H

#include <cstring>

#include "vops.h"

class Node; 
class Stack; 
class Node{
  public:
  int  val;
  Node*  next;
  Node(){}
  static Node* create(  int  val_,   Node*  next_);
  ~Node(){
  }
  void operator delete(void* p){ free(p); }
};
class Stack{
  public:
  Node*  head;
  Stack(){}
  static Stack* create(  Node*  head_);
  ~Stack(){
  }
  void operator delete(void* p){ free(p); }
};
#endif
