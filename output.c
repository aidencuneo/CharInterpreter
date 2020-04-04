#include <stdio.h>
#include <string.h>
#include <stdlib.h>
struct stack{int maxsize;int top;int*items;};struct stack*newStack(int capacity){struct stack*pt=(struct stack*)malloc(sizeof(struct stack));pt->maxsize=capacity;pt->top=-1;pt->items=(int*)malloc(sizeof(int)*capacity);return pt;}int size(struct stack*pt){return pt->top+1;}
int isEmpty(struct stack*pt){return pt->top==-1;}
int isFull(struct stack*pt){return pt->top==pt->maxsize-1;}
void push(struct stack*pt,int x){if(isFull(pt))exit(EXIT_FAILURE);pt->items[++pt->top]=x;}
int peek(struct stack*pt){if (!isEmpty(pt))return pt->items[pt->top];else return 0;}
int pop(struct stack*pt){if(isEmpty(pt))return 0;return pt->items[pt->top--];}
int main(int argc,char**argv){int c=0;struct stack*pt=newStack(4096);
°–κώprintf("%d",c);c+=15;++c;c=0;printf("%d",c);c+=15;++c;c+=5;printf("%d",c);c+=15;c+=10;c+=13;c+=14;return 0;}