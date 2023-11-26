#include <stdio.h>
#include <stdlib.h>

#include <pthread.h>
#include <semaphore.h>

#define N_CYCLES_WRITERS 640
#define N_CYCLES_READERS 2560
#define N_CYCLES_SIM 10000

sem_t sem_reader;
sem_t sem_writer;
pthread_mutex_t mutex_read;
pthread_mutex_t mutex_write;
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
        pthread_mutex_lock(&mutex_write);
        write_count++;
        if (write_count == 1)
            sem_wait(&sem_reader);
        pthread_mutex_unlock(&mutex_write);

        sem_wait(&sem_writer);

        // perform action
        printf("Writing...\n");
        simulate_work();

        sem_post(&sem_writer);

        pthread_mutex_lock(&mutex_write);
        write_count--;
        if (write_count == 0)
            sem_post(&sem_reader);
        pthread_mutex_unlock(&mutex_write);
    }
    return (NULL);
}

void *reader(void *arg)
{
    (void)arg;
    for (int i = 0; i < N_CYCLES_READERS; i++)
    {
        pthread_mutex_lock(&mutex_read);
        read_count++;
        if (read_count == 1)
            sem_wait(&sem_writer); // first reader locks writer
        pthread_mutex_unlock(&mutex_read);

        // perform action
        printf("Reading...\n");
        simulate_work();

        pthread_mutex_lock(&mutex_read);
        read_count--;
        if (read_count == 0)
            sem_post(&sem_writer); // last reader unlocks writer
        pthread_mutex_unlock(&mutex_read);
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

    pthread_mutex_init(&mutex_read, NULL);
    pthread_mutex_init(&mutex_write, NULL);
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
    pthread_mutex_destroy(&mutex_read);
    pthread_mutex_destroy(&mutex_write);

    return EXIT_SUCCESS;
}