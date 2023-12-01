#include "sem.h"

void sem_init(sem_t *sem, int pshared, unsigned int value)
{
    (void)pshared;
    sem->value = value;
    sem->lock.flag = 0;
}

void sem_wait(sem_t *sem)
{
    lock(&sem->lock);
    while (sem->value == 0) {
        unlock(&sem->lock);
        // Allow other threads to run
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
    return (0);
}