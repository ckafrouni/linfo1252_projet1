#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#include <pthread.h>

#ifdef CUSTOM_MUTEX_AND_SEMAPHORE
#include "./lib/lock.h"
#include "./lib/sem.h"

#define MUTEX_T spinlock_t
#define MUTEX_INIT(l) spinlock_init(l)
#define MUTEX_LOCK(l) lock(l)
#define MUTEX_UNLOCK(l) unlock(l)
#define MUTEX_DESTROY(l) spinlock_destroy(l)
#else
#include <semaphore.h>

#define MUTEX_T pthread_mutex_t
#define MUTEX_INIT(l) pthread_mutex_init(l, NULL)
#define MUTEX_LOCK(l) pthread_mutex_lock(l)
#define MUTEX_UNLOCK(l) pthread_mutex_unlock(l)
#define MUTEX_DESTROY(l) pthread_mutex_destroy(l)
#endif

#define N 8
#define N_CYCLES 8192
#define N_CYCLES_SIM 10000
MUTEX_T mutex;
sem_t empty;
sem_t full;
int buffer[N];
int free_indexes[N];

void print_buffer()
{
    printf("[");
    for (int i = 0; i < N; i++)
    {
        if (free_indexes[i] == 1)
        {
            printf("X");
        }
        else
        {
            printf("%d", buffer[i]);
        }
        if (i < N - 1)
        {
            printf(", ");
        }
    }
    printf("]\n");
}

int produce_item(void)
{
    for (int i = 0; i < N_CYCLES_SIM; i++)
        ;
    return rand();
}

void consume_item(int item)
{
    (void)item;
    for (int i = 0; i < N_CYCLES_SIM; i++)
        ;
}

void insert_item(int item)
{
    for (int i = 0; i < N; i++)
    {
        if (free_indexes[i] == 1)
        {
            buffer[i] = item;
            free_indexes[i] = 0;
            break;
        }
    }
}

int remove_item(void)
{
    int i;
    for (i = 0; i < N; i++)
    {
        if (free_indexes[i] == 0)
        {
            free_indexes[i] = 1;
            break;
        }
    }
    return buffer[i];
}

void *producer(void * arg)
{
    int *n_cycles = (int *)arg;
    int item;
    for (int i = 0; i < *n_cycles; i++)
    {
        item = produce_item();
        sem_wait(&empty);
        MUTEX_LOCK(&mutex);
        insert_item(item);
        // print_buffer();
        MUTEX_UNLOCK(&mutex);
        sem_post(&full);
    }

    return (NULL);
}

void *consumer(void * arg)
{
    int *n_cycles = (int *)arg;
    int item;
    for (int i = 0; i < *n_cycles; i++)
    {
        sem_wait(&full);
        MUTEX_LOCK(&mutex);
        item = remove_item();
        // print_buffer();
        MUTEX_UNLOCK(&mutex);
        sem_post(&empty);
        consume_item(item);
    }

    return (NULL);
}

int main(int argc, char *argv[])
{
    if (argc != 3)
    {
        fprintf(stderr, "Usage: %s <number of consumers> <number of producers>\n", argv[0]);
        return EXIT_FAILURE;
    }

    MUTEX_INIT(&mutex);
    sem_init(&empty, 0, N); // buffer vide
    sem_init(&full, 0, 0);  // buffer vide

    for (int i = 0; i < N; i++)
    {
        free_indexes[i] = 1;
    }

    int n_consumers = strtol(argv[1], NULL, 10);
    int n_producers = strtol(argv[2], NULL, 10);

    pthread_t producers[n_producers];
    pthread_t consumers[n_consumers];

    int rest_consumer = N_CYCLES % n_consumers;
    int rest_producer = N_CYCLES % n_producers;

    int n_cycles_cons = (N_CYCLES/n_consumers);
    for (int i = 0; i < (n_consumers - 1); i++)
    {
        pthread_create(&consumers[i], NULL, consumer, &n_cycles_cons);
    }
    int n_cycles_cons_rest = n_cycles_cons + rest_consumer;

    pthread_create(&consumers[n_consumers - 1], NULL, consumer, &n_cycles_cons_rest);


    int n_cycles_prod = (N_CYCLES/n_producers);
    for (int i = 0; i < (n_producers - 1); i++)
    {
        pthread_create(&producers[i], NULL, producer, &n_cycles_prod);
    }
    int n_cycles_prod_rest = n_cycles_prod + rest_producer;
    pthread_create(&producers[n_producers - 1], NULL, producer, &n_cycles_prod_rest);

    for (int i = 0; i < n_producers; i++)
    {
        pthread_join(producers[i], NULL);
    }


    for (int i = 0; i < n_consumers; i++)
    {
        pthread_join(consumers[i], NULL);
    }


    MUTEX_DESTROY(&mutex);
    sem_destroy(&empty);
    sem_destroy(&full);

    return EXIT_SUCCESS;
}