#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "char.h"

char * current_file;

char * tokens;
int tokens_len;

int * tokeninds;
int tokeninds_len;

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

int peek(struct stack * pt){
    if (!isEmpty(pt))
        return pt->items[pt->top];

    return 0;
}

int pop(struct stack * pt){
    if (isEmpty(pt))
        return 0;

    return pt->items[pt->top--];
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

void error(char * text, int line)
{
    int MAXLINE = 128;

    char * fullfile;
    fullfile = readfile(current_file);

    char * linepreview = malloc(MAXLINE);

    strcpy(linepreview, "");

    --line;

    int c = 0;
    for (int i = 0; i < strlen(fullfile); i++)
    {
        if (fullfile[i] == '\n')
            c++;
        else if (c == line && strlen(linepreview) < MAXLINE && fullfile[i] != 10 && fullfile[i] != 13)
            strncat(linepreview, &fullfile[i], 1);
        if (c > line + 1)
            break;
    }

    ++line;

    printf("\nProgram execution terminated:\n\n");
    printf("At %s : Line %d\n\n", current_file, line);
    printf("> %d | %s\n\n", line, linepreview);
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

int main(int argc, char ** argv)
{
    if (argc < 2) return 1;

    current_file = argv[1];

    char * buffer = 0;
    long length;
    FILE * f = fopen(current_file, "rb");

    if (f)
    {
        fseek(f, 0, SEEK_END);
        length = ftell(f);
        fseek(f, 0, SEEK_SET);
        buffer = malloc(length);
        if (buffer)
            fread(buffer, 1, length, f);
        fclose(f);
    }

    if (!buffer)
        return 0;

    // Interpreter vars
    int ptr = 0;
    struct stack * stack = newStack(4096);
    int mult = 1; // 1 or -1

    tokens = malloc(MAXIMUM_RECURSION);
    tokens[0] = 0;
    tokens_len = 0;

    tokeninds = malloc(MAXIMUM_RECURSION * sizeof(int));
    tokeninds_len = 0;

    int line = 1;
    int skipping = 0;
    int scope = 0;
    int comment = 0;

    for (int i = 0; i < length; i++)
    {
        char ch = buffer[i];
        if (!comment && ch != ' ' && ch != '\n' && ch != '\r' && ch != '#')
        {
            // printf("\n!%d |%c| > %d (%d) [", skipping, ch, scope, ptr);
            // for (int a = 0; a < stack->top + 1; a++)
            //     printf("%d,", stack->items[a]);
            // if (stack->top + 1)
            //     printf("\b");
            // printf("]\n");
        }

        if (ch == '#')
            comment = 1;
        else if (ch == '\n')
        {
            comment = 0;
            line++;
        }

        if (comment)
            continue;

        if (ch == ';')
        {
            int last_tokenind = -1;
            char last_token = popToken(&last_tokenind);

            // printf("((%c)) ", last_token);
            // printf("{%d}\n", last_tokenind);

            if (scope <= 0 || last_tokenind < 0)
                error("program is already at minimum scope", line);

            if (skipping > 0)
                skipping--;

            --scope;

            if (last_token == ':')
            {
                // i = last_tokenind - 1;

                if (ptr > 0)
                {
                    ++scope;
                    i = last_tokenind - 1;
                }
            }
            else if (last_token == '.')
            {
                i = last_tokenind - 1;

                // if (!(ptr > 0))
                // {
                //     ++scope;
                //     i = last_tokenind - 1;
                // }
                // else token = 0;
            }
        }
        else if (ch == '?' || ch == '!')
        {
            if (skipping > 0)
                ++skipping;

            pushToken(ch, i);
            ++scope;

            if (ch == '?')
            {
                if (!(ptr > 0))
                    ++skipping;
            }
            else if (ch == '!')
            {
                if (ptr > 0)
                    ++skipping;
            }
        }
        else if (ch == ':' || ch == '.')
        {
            if (skipping > 0)
                ++skipping;

            pushToken(ch, i);
            ++scope;

            if (ch == ':')
            {
                if (!(ptr > 0))
                    ++skipping;
            }
            else if (ch == '!')
            {
                if (ptr > 0)
                    ++skipping;
            }
        }
        else if (skipping)
            continue;
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

    return 0;
}
