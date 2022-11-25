#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct ListNode {
    struct ListNode *next;
    int val;
} ListNode;

void append(ListNode** head, int x);

void addToFront(ListNode** head, int x);