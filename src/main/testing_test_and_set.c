#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#include "lib/test_and_set.h"

#define TOTAL_CYCLES 6400

spinlock_t lock;

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
        spinlock_lock(&lock);
        critical_section();
        spinlock_unlock(&lock);
    }
    printf("Thread %ld finished\n", pthread_self());

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
        if (pthread_create(&threads[i], NULL, thread_function, &n_threads))
        {
            fprintf(stderr, "Error creating thread %d\n", i);
            return EXIT_FAILURE;
        }
    }

    for (int i = 0; i < n_threads; i++)
    {
        if (pthread_join(threads[i], NULL))
        {
            fprintf(stderr, "Error joining thread %d\n", i);
            return EXIT_FAILURE;
        }
    }

    return EXIT_SUCCESS;
}