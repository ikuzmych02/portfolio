#include "Helpers.h"


int main() {
    Person* p1 = (Person*) malloc(sizeof(Person));
    p1->name = 'I';         // char* (5 byte)
    p1->age = 19;           // int  (4 bytes)
    p1->favoriteNum = 93;   // long long int  (8 bytes)

    
    printf("%d\n", sizeof(Person));
    return 0;
}



