#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#ifdef CUSTOM_MUTEX_AND_SEMAPHORE
#include "../lib/lock.h"

#define MUTEX_T spinlock_t
#define MUTEX_INIT(l) spinlock_init(l)
#define MUTEX_LOCK(l) lock(l)
#define MUTEX_UNLOCK(l) unlock(l)
#define MUTEX_DESTROY(l) spinlock_destroy(l)
#else
#define MUTEX_T pthread_mutex_t
#define MUTEX_INIT(l) pthread_mutex_init(l, NULL)
#define MUTEX_LOCK(l) pthread_mutex_lock(l)
#define MUTEX_UNLOCK(l) pthread_mutex_unlock(l)
#define MUTEX_DESTROY(l) pthread_mutex_destroy(l)
#endif

#define TOTAL_CYCLES 6400

MUTEX_T mut;

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
        MUTEX_LOCK(&mut);
        critical_section();
        MUTEX_UNLOCK(&mut);
    }
    return NULL;
}

int main(int argc, char *argv[])
{
    if (argc != 2 && argc != 3)
    {
        fprintf(stderr, "Usage: %s <number of threads> <unused>\n", argv[0]);
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