#include "sem.h"
#include "lock.h"

void sem_init(sem_t *sem, int pshared, unsigned int value)
{
    (void)pshared;
    sem->value = value;
    spinlock_init(&sem->lock);
}

void sem_wait(sem_t *sem)
{    
    while (1) {
        lock(&sem->lock);
        if (sem->value > 0) {
            sem->value--;
            unlock(&sem->lock);
            break;
        }
        unlock(&sem->lock);
    }
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