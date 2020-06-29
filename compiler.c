#include "compiler.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char ** argv)
{
    if (argc < 3) return 1;

    char * buffer = 0;
    long length;
    FILE * f = fopen(argv[1], "rb");

    if (f)
    {
        fseek(f, 0, SEEK_END);
        length = ftell (f);
        fseek(f, 0, SEEK_SET);
        buffer = malloc (length);
        if (buffer)
            fread (buffer, 1, length, f);
        fclose(f);
    }

    if (!buffer)
        return 0;

    char * compiled = malloc(9128 + 1);
    int paused = 0;

    for (int i = 0; i < length; i++)
    {
        char ch = buffer[i];
        if (ch == '#') paused = !paused;
        else if (paused) continue;
        else if (ch == '0')
            strcat(compiled, C_0);
        else if (ch == '1')
            strcat(compiled, C_1);
        else if (ch == '2')
            strcat(compiled, C_2);
        else if (ch == '3')
            strcat(compiled, C_3);
        else if (ch == '4')
            strcat(compiled, C_4);
        else if (ch == '5')
            strcat(compiled, C_5);
        else if (ch == '6')
            strcat(compiled, C_6);
        else if (ch == '7')
            strcat(compiled, C_7);
        else if (ch == '8')
            strcat(compiled, C_8);
        else if (ch == '9')
            strcat(compiled, C_9);
        else if (ch == 'a')
            strcat(compiled, C_10);
        else if (ch == 'b')
            strcat(compiled, C_11);
        else if (ch == 'c')
            strcat(compiled, C_12);
        else if (ch == 'd')
            strcat(compiled, C_13);
        else if (ch == 'e')
            strcat(compiled, C_14);
        else if (ch == 'f')
            strcat(compiled, C_15);
        else if (ch == '-')
            strcat(compiled, C_MINUS);
        else if (ch == '+')
            strcat(compiled, C_PLUS);
        else if (ch == ';')
            strcat(compiled, C_SEMICOLON);
        else if (ch == '?')
            strcat(compiled, C_IFTRUE);
        else if (ch == '!')
            strcat(compiled, C_IFNOT);
        else if (ch == ':')
            strcat(compiled, C_WHILETRUE);
        else if (ch == '.')
            strcat(compiled, C_WHILENOT);
        else if (ch == 'p')
            strcat(compiled, C_PRINTF);
        else if (ch == 'P')
            strcat(compiled, C_PRINT);
        else if (ch == '<')
            strcat(compiled, C_STACKPOP);
        else if (ch == '>')
            strcat(compiled, C_STACKPUSH);
        else if (ch == '(')
            strcat(compiled, C_SOFTPOP);
        else if (ch == ')')
            strcat(compiled, C_SOFTPUSH);
        else if (ch == ',')
            strcat(compiled, C_GETBYTE);
        else if (ch == 'q')
            strcat(compiled, C_EXIT);
    }

    const char * fileHeaders;
    const char * fileStackStruct;
    const char * fileStart;
    const char * fileEnd;

    fileHeaders = "#include <stdio.h>\n#include <string.h>\n#include <stdlib.h>\n";
    fileStackStruct = "struct stack{int maxsize;int top;int*items;};struct stack*newStack(int capacity){struct stack*pt=(struct stack*)malloc(sizeof(struct stack));pt->maxsize=capacity;pt->top=-1;pt->items=(int*)malloc(sizeof(int)*capacity);return pt;}int size(struct stack*pt){return pt->top+1;}\nint isEmpty(struct stack*pt){return pt->top==-1;}\nint isFull(struct stack*pt){return pt->top==pt->maxsize-1;}\nvoid push(struct stack*pt,int x){if(isFull(pt))exit(EXIT_FAILURE);pt->items[++pt->top]=x;}\nint peek(struct stack*pt){if (!isEmpty(pt))return pt->items[pt->top];else return 0;}\nint pop(struct stack*pt){if(isEmpty(pt))return 0;return pt->items[pt->top--];}\n";
    fileStart = "int main(int argc,char**argv){int c=0;struct stack*pt=newStack(4096);char d[2];\n";
    fileEnd = "return 0;}";

    FILE * fp = fopen(argv[2], "w");
    fprintf(fp, fileHeaders, 1);
    fprintf(fp, fileStackStruct, 1);
    fprintf(fp, fileStart, 1);
    fprintf(fp, compiled, 1);
    fprintf(fp, fileEnd, 1);
    fclose(fp);

    free(compiled);

    return 0;
}
