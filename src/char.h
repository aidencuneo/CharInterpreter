#define MAXIMUM_RECURSION 100

#define C_0 "c=0;"
#define C_1 "++c;"
#define C_2 "c+=2;"
#define C_3 "c+=3;"
#define C_4 "c+=4;"
#define C_5 "c+=5;"
#define C_6 "c+=6;"
#define C_7 "c+=7;"
#define C_8 "c+=8;"
#define C_9 "c+=9;"
#define C_10 "c+=10;"
#define C_11 "c+=11;"
#define C_12 "c+=12;"
#define C_13 "c+=13;"
#define C_14 "c+=14;"
#define C_15 "c+=15;"

#define C_MINUS "c-=pop(pt);"
#define C_PLUS "c+=pop(pt);"

#define C_SEMICOLON "}"

#define C_IFTRUE "if(c>0){"
#define C_IFNOT "if(c==0){"

#define C_WHILETRUE "while(c>0){"
#define C_WHILENOT "while(c==0){"

#define C_PRINT "printf(\"%%c\",c);"
#define C_PRINTF "printf(\"%%d\",c);"

#define C_STACKPOP "c=pop(pt);"
#define C_STACKPUSH "push(pt,c);c=0;"

#define C_SOFTPOP "c=peek(pt);"
#define C_SOFTPUSH "push(pt,c);"

#define C_GETBYTE "fgets(d,2,stdin);if(d[0]=='\\n')c=0;else c=d[0];"

#define C_EXIT "return 0;"
