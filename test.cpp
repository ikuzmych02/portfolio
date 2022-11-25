#include <iostream>
using namespace std;

string returnSimpleWord();

int main() {
    unsigned u = 10, u2 = 42;
    cout << u2 - u << endl; // should print 32
    cout << u - u2 << endl; // should print some big number

    cout << returnSimpleWord() << endl;
    return 0;
}

string returnSimpleWord() {
    string anotherTest = "beginning: ";
    anotherTest += "Test string"; // concatenate this string to end of the other one
    return anotherTest;
}