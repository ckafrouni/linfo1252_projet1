#include <stdio.h>
#include <stdlib.h>

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


#define N_CYCLES_WRITERS 640
#define N_CYCLES_READERS 2560
#define N_CYCLES_SIM 10000

sem_t sem_reader;
sem_t sem_writer;
MUTEX_T mutex_read;
MUTEX_T mutex_write;
MUTEX_T mutex_writer_priority;
int read_count = 0;
int write_count = 0;

void simulate_work()
{
    for (int i = 0; i < N_CYCLES_SIM; i++)
        ;
}

void *writer(void *arg)
{
    (void)arg;
    for (int i = 0; i < N_CYCLES_WRITERS; i++)
    {
        MUTEX_LOCK(&mutex_write);
        write_count++;
        if (write_count == 1) {
            sem_wait(&sem_reader);
        }
        MUTEX_UNLOCK(&mutex_write);
        
        sem_wait(&sem_writer);

        simulate_work();

        sem_post(&sem_writer);
        
        MUTEX_LOCK(&mutex_write);
        write_count--;
        if (write_count == 0)
            sem_post(&sem_reader);
        MUTEX_UNLOCK(&mutex_write);
    }
    return (NULL);
}

void *reader(void *arg)
{
    (void)arg;
    for (int i = 0; i < N_CYCLES_READERS; i++)
    {
        MUTEX_LOCK(&mutex_writer_priority);
        sem_wait(&sem_reader);

        MUTEX_LOCK(&mutex_read);
        read_count++;
        if (read_count == 1)
            sem_wait(&sem_writer); // first reader locks writer
        MUTEX_UNLOCK(&mutex_read);
        
        sem_post(&sem_reader);
        MUTEX_UNLOCK(&mutex_writer_priority);

        simulate_work();

        MUTEX_LOCK(&mutex_read);
        read_count--;
        if (read_count == 0)
            sem_post(&sem_writer); // last reader unlocks writer
        MUTEX_UNLOCK(&mutex_read);
    }
    return (NULL);
}

int main(int argc, char *argv[])
{
    if (argc != 3)
    {
        printf("Usage: %s <n_readers> <n_writers>\n", argv[0]);
        return EXIT_FAILURE;
    }

    MUTEX_INIT(&mutex_read);
    MUTEX_INIT(&mutex_write);
    MUTEX_INIT(&mutex_writer_priority);
    sem_init(&sem_reader, 0, 1);
    sem_init(&sem_writer, 0, 1);

    int n_readers = strtol(argv[1], NULL, 10);
    int n_writers = strtol(argv[2], NULL, 10);

    pthread_t readers[n_readers];
    pthread_t writers[n_writers];

    for (int i = 0; i < n_readers; i++)
    {
        pthread_create(&readers[i], NULL, reader, NULL);
    }

    for (int i = 0; i < n_writers; i++)
    {
        pthread_create(&writers[i], NULL, writer, NULL);
    }

    for (int i = 0; i < n_readers; i++)
    {
        pthread_join(readers[i], NULL);
    }

    for (int i = 0; i < n_writers; i++)
    {
        pthread_join(writers[i], NULL);
    }

    sem_destroy(&sem_reader);
    sem_destroy(&sem_writer);
    MUTEX_DESTROY(&mutex_read);
    MUTEX_DESTROY(&mutex_write);
    MUTEX_DESTROY(&mutex_writer_priority);
    
    return EXIT_SUCCESS;
}