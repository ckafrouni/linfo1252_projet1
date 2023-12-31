#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <string.h>

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

#define N_CYCLES 10000000 // 10 millions

typedef struct
{
    int id;
    int n_philosophers;
    MUTEX_T *sticks;
} philosophers_arg;

void eat(int id)
{
    (void)id;
}

void think(int id)
{
    (void)id;
}

void *philosopher(void *arg)
{
    philosophers_arg *x = (philosophers_arg *)arg;

    int left = x->id;
    int right = (left + 1) % x->n_philosophers;

    for (size_t i = 0; i < N_CYCLES; i++)
    {
        think(x->id);

        if (left < right)
        {
            MUTEX_LOCK(&x->sticks[left]);
            MUTEX_LOCK(&x->sticks[right]);
        }
        else
        {
            MUTEX_LOCK(&x->sticks[right]);
            MUTEX_LOCK(&x->sticks[left]);
        }

        eat(x->id);

        MUTEX_UNLOCK(&x->sticks[left]);
        MUTEX_UNLOCK(&x->sticks[right]);
    }

    return (NULL);
}

int main(int argc, char *argv[])
{    
    if (argc != 2 && argc != 3)
    {
        fprintf(stderr, "Usage: %s <number of philosophers>\n", argv[0]);
        return EXIT_FAILURE;
    }

    int n_philosophers = strtol(argv[1], NULL, 10);

    MUTEX_T sticks[n_philosophers];

    pthread_t philosophers[n_philosophers];
    philosophers_arg p_args[n_philosophers];

    for (int i = 0; i < n_philosophers; i++)
    {
        MUTEX_INIT(&sticks[i]);
    }

    for (int i = 0; i < n_philosophers; i++)
    {
        p_args[i] = (philosophers_arg){
            .id = i,
            .n_philosophers = n_philosophers,
            .sticks = sticks,
        };

        pthread_create(&philosophers[i], NULL, philosopher, &p_args[i]);
    }

    for (int i = 0; i < n_philosophers; i++)
    {
        pthread_join(philosophers[i], NULL);
    }

    for (int i = 0; i < n_philosophers; i++)
    {
        MUTEX_DESTROY(&sticks[i]);
    }

    return EXIT_SUCCESS;
}