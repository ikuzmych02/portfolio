#include "ListNode.h"



int main() {
    ListNode *head = NULL;
    ListNode *second = NULL;
    ListNode *third = NULL;
    
    head = (ListNode *) malloc(sizeof(ListNode));
    second = (ListNode *) malloc(sizeof(ListNode));
    third = (ListNode *) malloc(sizeof(ListNode));

    head->next = second;
    head->val = 0;

    second->next = third;
    second->val = 1;

    third->next = NULL;
    third->val = 2;

    ListNode** ptr = &head;
    append(ptr, 3);
    addToFront(ptr, 5);

    /**
     * Iterating through the Linked List in its entirety
    */
    ListNode *curr = head;
    while (curr != NULL) {
        printf("%d\n", curr->val);
        curr = curr->next;
    }

    printf("%d", head->next->next->val);

}

/**
 * 
 * @param head The head of the list we want to add x to
 * @param x    The value we want to add to the end of our LinkedList
*/
void append(ListNode** head, int x) {
    ListNode* newNode;
    newNode = (ListNode *) malloc(sizeof(ListNode));
    ListNode* last = *head;

    newNode->next = NULL;
    newNode->val = x;

    if (*head == NULL) {
        *head = newNode;
        return;
    }

    while (last->next != NULL) {
        last = last->next;
    }
    last->next = newNode;
    return;
}

/**
 * 
 * @param head The head of the list we want to add x to
 * @param x    The value we want to add to the end of our LinkedList
*/
void addToFront(ListNode** head, int x) {
    ListNode* newNode = (ListNode *) malloc(sizeof(ListNode));
    
    newNode->next = *head;
    newNode->val = x;
    *head = newNode;
    
    return;
}