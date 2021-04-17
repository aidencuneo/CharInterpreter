struct vmem
{
    int alloc;
    int alloc_size;
    int size;
    int * items;
};

struct vmem * newVMem(int block_size)
{
    struct vmem * pt = malloc(sizeof(struct vmem));

    pt->alloc = block_size;
    pt->alloc_size = block_size;
    pt->size = 0;
    pt->items = malloc(block_size * sizeof(int));

    return pt;
}

int vmemSize(struct vmem * pt)
{
    return pt->size;
}

int vmemIsEmpty(struct vmem * pt)
{
    return pt->size == 0;
}

void vmemAutoSize(struct vmem * pt)
{
    if (pt->size > pt->alloc - 1)
    {
        pt->alloc += pt->alloc_size;
        pt->items = realloc(pt->items, pt->alloc * sizeof(int));
    }
}

void vmemAdd(struct vmem * pt, int num)
{
    vmemAutoSize(pt);

    pt->items[pt->size++] = num;
}

int vmemGet(struct vmem * pt, int index)
{
    if (vmemIsEmpty(pt))
        return 0;

    return pt->items[index];
}

int vmemPopBottom(struct vmem * pt)
{
    vmemAutoSize(pt);

    if (vmemIsEmpty(pt))
        return 0;

    int ptr = pt->items[0];

    for (int i = 0; i < pt->size - 1; i++)
        pt->items[i] = pt->items[i + 1];

    pt->items[pt->size + 1] = 0;

    if (pt->size > 0)
        --pt->size;

    return ptr;
}
