#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        fprintf(stderr, "Usage: %s <number of philosophers>\n", argv[0]);
        return 1;
    }

    int n_philosophers = strtol(argv[1], NULL, 10);
    printf("n philosophers : %d\n", n_philosophers);

    return 0;
}