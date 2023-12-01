#include "sem.h"
#include "lock.h"
// #include <stdio.h>

void sem_init(sem_t *sem, int pshared, unsigned int value)
{
    (void)pshared;
    sem->value = value;
    spinlock_init(&sem->lock);
}

void sem_wait(sem_t *sem)
{
    lock(&sem->lock);
    while (sem->value <= 0) {
        // printf("Waiting for semaphore\n");
        unlock(&sem->lock);
        lock(&sem->lock);
    }
    sem->value--;
    unlock(&sem->lock);
}

void sem_post(sem_t *sem)
{
    lock(&sem->lock);
    sem->value++;
    unlock(&sem->lock);
}

int sem_destroy(sem_t *sem)
{
    (void)sem;
    return (0);
}