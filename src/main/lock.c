#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#include "lib/lock.h"

#define TOTAL_CYCLES 6400

spinlock_t mut;

void critical_section()
{
    for (int i = 0; i < 10000; i++)
        ;
}

void *thread_function(void *arg)
{
    int n = *(int *)arg;
    for (int i = 0; i < TOTAL_CYCLES / n; i++)
    {
        lock(&mut);
        critical_section();
        unlock(&mut);
    }
    return NULL;
}

int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        fprintf(stderr, "Usage: %s <number of threads>\n", argv[0]);
        return EXIT_FAILURE;
    }

    int n_threads = strtol(argv[1], NULL, 10);
    pthread_t threads[n_threads];

    for (int i = 0; i < n_threads; i++)
    {
        pthread_create(&threads[i], NULL, thread_function, &n_threads);
    }

    for (int i = 0; i < n_threads; i++)
    {
        pthread_join(threads[i], NULL);
    }

    return EXIT_SUCCESS;
}