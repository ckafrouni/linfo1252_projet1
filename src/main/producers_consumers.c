#include <stdlib.h>
#include <stdio.h>
#include <malloc.h>
#include <pthread.h>
#include <semaphore.h>
#include <limits.h>

#define N 8
#define N_CYCLES 8192
#define N_CYCLES_SIM 10000
pthread_mutex_t mutex;
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
    srand(time(NULL));
    long diff = (long)INT_MAX - (long)INT_MIN;
    return (int)rand() % (diff + 1) + INT_MIN;
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
    int *n_producers = (int *)arg;
    int item;
    for (int i = 0; i < (N_CYCLES / (*n_producers)); i++)
    {
        item = produce_item();
        sem_wait(&empty);
        pthread_mutex_lock(&mutex);
        insert_item(item);
        // print_buffer();
        pthread_mutex_unlock(&mutex);
        sem_post(&full);
    }

    return (NULL);
}

void *consumer(void * arg)
{
    int *n_consumers = (int *)arg;
    int item;
    for (int i = 0; i < (N_CYCLES / (*n_consumers)); i++)
    {
        sem_wait(&full);
        pthread_mutex_lock(&mutex);
        item = remove_item();
        // print_buffer();
        pthread_mutex_unlock(&mutex);
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

    pthread_mutex_init(&mutex, NULL);
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

    for (int i = 0; i < n_producers; i++)
    {
        pthread_create(&producers[i], NULL, producer, &n_producers);
    }

    for (int i = 0; i < n_consumers; i++)
    {
        pthread_create(&consumers[i], NULL, consumer, &n_consumers);
    }

    for (int i = 0; i < n_producers; i++)
    {
        pthread_join(producers[i], NULL);
    }

    for (int i = 0; i < n_consumers; i++)
    {
        pthread_join(consumers[i], NULL);
    }

    pthread_mutex_destroy(&mutex);
    sem_destroy(&empty);
    sem_destroy(&full);

    return EXIT_SUCCESS;
}