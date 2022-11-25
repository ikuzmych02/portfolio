#include <stdlib.h>
#include <stdio.h>
#include <math.h>

void find_roots(double a, double b, double c, double *root1, double *root2)
{
    *root1 = (b * (-1) + sqrt((pow(b, 2) - 4 * a * c))) / (2 * a);
    *root2 = (b * (-1) - sqrt((pow(b, 2) - 4 * a * c))) / (2 * a);
}

#ifndef RunTests
int main()
{
    double root1, root2;
    find_roots(2, 10, 8, &root1, &root2);
    printf("Roots: %f, %f", root1, root2);
}
#endif