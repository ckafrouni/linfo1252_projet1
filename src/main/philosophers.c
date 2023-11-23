#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

#define N_CYCLES 10000000 // 10 millions

typedef struct
{
    int id;
    int n_philosophers;
    pthread_mutex_t *sticks;
} philosophers_arg;

void eat(int id)
{
    (void)id;
    // printf("Philosopher [%d] eats\n", id);
}

void think(int id)
{
    (void)id;
    // printf("Philosopher [%d] thinks\n", id);
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
            pthread_mutex_lock(&x->sticks[left]);
            pthread_mutex_lock(&x->sticks[right]);
        }
        else
        {
            pthread_mutex_lock(&x->sticks[right]);
            pthread_mutex_lock(&x->sticks[left]);
        }

        eat(x->id);

        pthread_mutex_unlock(&x->sticks[left]);
        pthread_mutex_unlock(&x->sticks[right]);
    }

    return (NULL);
}

int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        fprintf(stderr, "Usage: %s <number of philosophers>\n", argv[0]);
        return EXIT_FAILURE;
    }

    int n_philosophers = strtol(argv[1], NULL, 10);

    pthread_mutex_t sticks[n_philosophers];
    pthread_t philosophers[n_philosophers];
    philosophers_arg p_args[n_philosophers];

    for (int i = 0; i < n_philosophers; i++)
    {
        if (pthread_mutex_init(&sticks[i], NULL) != 0)
        {
            fprintf(stderr, "Error creating mutex %d\n", i);
        }
    }

    for (int i = 0; i < n_philosophers; i++)
    {
        p_args[i] = (philosophers_arg){
            .id = i,
            .n_philosophers = n_philosophers,
            .sticks = sticks,
        };

        if (pthread_create(&philosophers[i], NULL, philosopher, &p_args[i]) != 0)
        {
            fprintf(stderr, "Error creating philosopher thread %d\n", i);
        }
    }

    for (int i = 0; i < n_philosophers; i++)
    {
        if (pthread_join(philosophers[i], NULL) != 0)
        {
            fprintf(stderr, "Error joining philosopher thread %d\n", i);
        }
    }

    for (int i = 0; i < n_philosophers; i++)
    {
        if (pthread_mutex_destroy(&sticks[i]) != 0)
        {
            fprintf(stderr, "Error destroying mutex %d\n", i);
        }
    }

    return EXIT_SUCCESS;
}