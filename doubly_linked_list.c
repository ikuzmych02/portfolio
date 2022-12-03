#include "Helpers.h"

struct Node {
    struct Node* next;
    struct Node* prev;
    int val;
};

typedef struct Node ListNode;

/**
 * This function takes the head of a linked-list and
 * pushes a node to the front of it
 * 
 * @param head   Double-pointer to head of Linked list
 * @param val    Value of new node
 * 
*/
void push(ListNode** head, int val) {
    ListNode* newNode = (ListNode*) malloc (sizeof(ListNode));
    newNode->val = val;
    newNode->next = *head;
    newNode->prev = NULL;

    if (*head != NULL) {
        (*head)->prev = newNode;
    }
    *head = newNode;
}

/**
 * This function takes the head of a linked-list and
 * appends a node to the back of it
 * 
 * @param head   Double-pointer to head of Linked list
 * @param val    Value of new node
 * 
*/
void append(ListNode** head, int val) {
    ListNode* newNode = (ListNode*) malloc (sizeof(ListNode));
    newNode->val = val;
    if (*head == NULL) {
        newNode->next = NULL;
        newNode->prev = NULL;
        *head = newNode;
        return;
    }

    ListNode* curr = *head;
    while (curr->next != NULL) {
        curr = curr->next;
    }
    curr->next = newNode;
    newNode->prev = curr;
    return;
}

int main() {
    ListNode* head = NULL;
    push(&head, 3); // NULL <- 3 -> NULL
    push(&head, 12); // NULL <- 12 -> <- 3 -> NULL
    append(&head, 13); // NULL <- 12 -> <- 3 -> <- 13 -> NULL

    printf("%d\n", head->val); // 12
    printf("%d\n", head->next->val); // 3
    printf("%d\n", head->next->next->val); // 13

    printf("%d\n", head->next->next->prev->val); // 3
    return 0;
}