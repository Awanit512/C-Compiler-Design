#include <stdio.h>
int main()
{
    int n, i;
    float factorial = 1;

    factorial = 3;

    printf("Factorial of 22: ");
    n = 22;
    /* show error if the user enters a negative integer */
    if (n < 0) {
        printf("Error! Factorial of a negative number doesn't exist.");
    }
    else {
        for(i=1; i<=n; ++i)
        {
            factorial = factorial * i;              // factorial = factorial*i;
        }
        printf("Factorial of %d is %llu", n, Factorial);
    }

    return 0;
}
