#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "char.h"

char * current_file;

char * tokens;
int tokens_len;

int * tokeninds;
int tokeninds_len;

// CLI Options
int minify = 0;
int verbose = 0;

struct stack
{
    int maxsize;
    int top;
    int * items;
};

struct stack * newStack(int capacity)
{
    struct stack * pt = malloc(sizeof(struct stack));
    pt->maxsize = capacity;
    pt->top = -1;
    pt->items = malloc(capacity * sizeof(int));
    return pt;
}

int size(struct stack * pt)
{
    return pt->top + 1;
}

int isEmpty(struct stack * pt)
{
    return pt->top == -1;
}

int isFull(struct stack * pt)
{
    return pt->top == pt->maxsize - 1;
}

void push(struct stack * pt, int x)
{
    if (isFull(pt))
        exit(1);

    pt->items[++pt->top] = x;
}

int peek(struct stack * pt)
{
    if (!isEmpty(pt))
        return pt->items[pt->top];

    return 0;
}

int pop(struct stack * pt)
{
    if (isEmpty(pt))
        return 0;

    return pt->items[pt->top--];
}

int pushBottom(struct stack * pt, int x)
{
    if (isFull(pt))
        exit(1);

    for (int i = ++pt->top; i >= 0; i--)
        pt->items[i] = pt->items[i - 1];
    pt->items[0] = x;
}

int popBottom(struct stack * pt)
{
    if (isEmpty(pt))
        return 0;

    int ptr = pt->items[0];
    for (int i = 0; i < pt->top; i++)
        pt->items[i] = pt->items[i + 1];
    pt->items[pt->top] = 0;
    if (pt->top > -1)
        --pt->top;

    return ptr;
}

int charCount(char * st, char ch)
{
    int count = 0;

    for (int i = 0; st[i]; i++)
        if (st[i] == ch)
            count++;

    return count;
}

char * readfile(char * fname)
{
    char * buffer;
    long length;

    FILE * f = fopen(fname, "rb");

    if (!f) return 0;

    fseek(f, 0, SEEK_END);
    length = ftell(f);
    fseek(f, 0, SEEK_SET);

    if (!length)
    {
        fclose(f);
        return 0;
    }

    buffer = malloc(length);
    strcpy(buffer, "");

    if (buffer)
        fread(buffer, 1, length, f);

    fclose(f);

    buffer = realloc(buffer, length + 1);
    buffer[length] = '\0';

    return buffer;
}

void error(char * text, char * buffer, int pos)
{
    // int MAXLINE = 128;

    char * linepreview = malloc(5 + 1);
    linepreview[0] = buffer[pos - 2];
    linepreview[1] = buffer[pos - 1];
    linepreview[2] = buffer[pos];
    linepreview[3] = buffer[pos + 1];
    linepreview[4] = buffer[pos + 2];
    linepreview[5] = 0;

    printf("\nProgram execution terminated:\n\n");
    printf("At %s : Pos %d\n\n", current_file, pos);
    printf("> {{ %s }}\n\n", linepreview);
    printf("Error: %s\n\n", text);

    free(linepreview);

    exit(1);
}

void pushToken(char tok, int ind)
{
    tokens[tokens_len++] = tok;
    tokeninds[tokeninds_len++] = ind;
    // printf("\n]::+%d\n", tokens_len);
}

char popToken(int * ind)
{
    // printf("\n]::-%d\n", tokens_len - 1);
    if (tokens_len && tokeninds_len)
    {
        *ind = tokeninds[--tokeninds_len];
        return tokens[--tokens_len];
    }

    *ind = -1;
    return 0;
}

char * minify_code(char * code)
{
    int len = strlen(code);
    char * min = malloc(len + 1);
    min[0] = 0;
    int ind = 0;

    int comment = 0;
    int scharmode = 0; // Single quotes
    int dcharmode = 0; // Double quotes

    for (int i = 0; i < len; i++)
    {
        if (scharmode || dcharmode)
            ;
        else if (code[i] == '#')
            comment = 1;
        else if (code[i] == '\n')
            comment = 0;

        if (comment)
            continue;

        if (code[i] == '\'' && !dcharmode)
            scharmode = !scharmode;
        else if (code[i] == '"' && !scharmode)
            dcharmode = !dcharmode;

        if (!isspace(code[i]) || scharmode || dcharmode)
            min[ind++] = code[i];
    }

    min[ind] = 0;
    return min;
}

int main(int argc, char ** argv)
{
    char ** args = malloc(argc * sizeof(char *));
    int newargc = 0;

    for (int i = 1; i < argc; i++)
    {
        if (!strcmp(argv[i], "-v") || !strcmp(argv[i], "--version"))
        {
            // printf("Quokka %s\n", VERSION);
            return 0;
        }
        if (!strcmp(argv[i], "-m") || !strcmp(argv[i], "--minify"))
            minify = 1;
        if (!strcmp(argv[i], "-V") || !strcmp(argv[i], "--verbose"))
            verbose = 1;
        else
        {
            args[newargc] = argv[i];
            newargc++;
        }
    }

    if (!newargc)
        return 0;

    current_file = args[0];

    char * buffer = 0;
    long length;
    FILE * f = fopen(current_file, "rb");

    if (!f)
    {
        printf("File at path '%s' does not exist or is not accessible\n", current_file);
        return 1;
    }

    fseek(f, 0, SEEK_END);
    length = ftell(f);
    fseek(f, 0, SEEK_SET);
    buffer = malloc(length);
    if (buffer)
        fread(buffer, 1, length, f);
    fclose(f);

    if (!buffer)
        return 0;

    if (minify)
    {
        char * minified = minify_code(buffer);

        printf("%s\n", minified);

        free(minified);
        free(buffer);

        return 0;
    }

    // Interpreter vars
    int ptr = 0;
    struct stack * stack = newStack(4096);
    int mult = 1; // 1 or -1

    int line = 1;
    int skipping = 0;
    int scope = 0;
    int comment = 0;
    int scharmode = 0; // Single quotes
    int dcharmode = 0; // Double quotes

    tokens = malloc(MAXIMUM_RECURSION);
    tokens[0] = 0;
    tokens_len = 0;

    tokeninds = malloc(MAXIMUM_RECURSION * sizeof(int));
    tokeninds_len = 0;

    for (int i = 0; i < length; i++)
    {
        char ch = buffer[i];
        if (!comment && ch != ' ' && ch != '\n' && ch != '\r' && ch != '#' && verbose)
        {
            printf("\n!%d |%c| > %d (%d) [", skipping, ch, scope, ptr);
            for (int a = 0; a < stack->top + 1; a++)
                printf("%d,", stack->items[a]);
            if (stack->top + 1)
                printf("\b");
            printf("]\n");
        }

        if (scharmode || dcharmode)
            ;
        else if (ch == '#')
            comment = 1;
        else if (ch == '\n')
        {
            comment = 0;
            line++;
        }

        if (comment)
            continue;

        if (scharmode || dcharmode)
            ;
        else if (ch == ';')
        {
            int last_tokenind = -1;
            char last_token = popToken(&last_tokenind);

            // printf("((%c)) ", last_token);
            // printf("{%d}\n", last_tokenind);

            if (scope <= 0 || (
                last_tokenind < 0 && (last_token == ':' || last_token == '.')
            ))
                error("program is already at minimum scope", buffer, i);

            if (skipping > 0)
                skipping--;

            --scope;

            if (last_token == ':')
            {
                // i = last_tokenind - 1;

                if (ptr)
                {
                    // ++scope;
                    i = last_tokenind - 1;
                }
            }
            else if (last_token == '.')
            {
                // i = last_tokenind - 1;

                if (!ptr)
                {
                    // ++scope;
                    i = last_tokenind - 1;
                }
                // else token = 0;
            }
        }
        else if (ch == '?' || ch == '!')
        {
            if (skipping > 0)
            {
                ++skipping;
                continue;
            }

            pushToken(ch, i);
            ++scope;

            if (ch == '?')
            {
                if (!ptr)
                    ++skipping;
            }
            else if (ch == '!')
            {
                if (ptr)
                    ++skipping;
            }
        }
        else if (ch == ':' || ch == '.')
        {
            if (skipping > 0)
            {
                ++skipping;
                continue;
            }

            pushToken(ch, i);
            ++scope;

            if (ch == ':')
            {
                if (!ptr)
                    ++skipping;
            }
            else if (ch == '.')
            {
                if (ptr)
                    ++skipping;
            }
        }
        if (ch == '\'' && !dcharmode)
            scharmode = !scharmode;
        else if (ch == '"' && !scharmode)
            dcharmode = !dcharmode;
        else if (skipping)
            continue;
        else if (scharmode || dcharmode)
            push(stack, ch);
        else if (ch == '0')
            ptr = 0;
        else if (ch == '1')
            ptr += mult;
        else if (ch == '2')
            ptr += mult * 2;
        else if (ch == '3')
            ptr += mult * 3;
        else if (ch == '4')
            ptr += mult * 4;
        else if (ch == '5')
            ptr += mult * 5;
        else if (ch == '6')
            ptr += mult * 6;
        else if (ch == '7')
            ptr += mult * 7;
        else if (ch == '8')
            ptr += mult * 8;
        else if (ch == '9')
            ptr += mult * 9;
        else if (ch == 'a')
            ptr += mult * 10;
        else if (ch == 'b')
            ptr += mult * 11;
        else if (ch == 'c')
            ptr += mult * 12;
        else if (ch == 'd')
            ptr += mult * 13;
        else if (ch == 'e')
            ptr += mult * 14;
        else if (ch == 'f')
            ptr += mult * 15;
        else if (ch == '-')
            ptr -= pop(stack);
        else if (ch == '+')
            ptr += pop(stack);
        else if (ch == '*')
            mult = 1;
        else if (ch == '/')
            mult = -1;
        // else if (ch == '!')
        // {
        //     token = ch;
        //     ++scope;
        // }
        // else if (ch == ':')
        // {
        //     token = ch;
        //     ++scope
        // }
        // else if (ch == '.')
        // {
        //     token = ch;
        //     ++scope;
        // }
        else if (ch == 'p')
            printf("%d", ptr);
        else if (ch == 'P')
            printf("%c", ptr);
        else if (ch == '<')
            ptr = pop(stack);
        else if (ch == '>')
        {
            push(stack, ptr);
            ptr = 0;
        }
        else if (ch == '(')
            ptr = peek(stack);
        else if (ch == ')')
            push(stack, ptr);
        else if (ch == '[')
            ptr = popBottom(stack);
        else if (ch == ']')
        {
            pushBottom(stack, ptr);
            ptr = 0;
        }
        else if (ch == ',')
        {
            char * in = malloc(2);
            fgets(in, 2, stdin);
            if (*in == '\n')
                ptr = 0;
            else
                ptr = *in;
        }
        else if (ch == 'q')
        {
            exit(0);
        }
    }

    free(buffer);

    return 0;
}
