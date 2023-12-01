#ifndef SEM_H
#define SEM_H

#include "lock.h"

typedef struct {
    spinlock_t lock;
    int value;
} sem_t;

void sem_init(sem_t *sem, int pshared, unsigned int value);
void sem_wait(sem_t *sem);
void sem_post(sem_t *sem);
int sem_destroy(sem_t *sem);

#endif // SEM_H