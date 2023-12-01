#ifndef LOCK_H
#define LOCK_H

typedef struct
{
    int flag;
} spinlock_t;

void lock(spinlock_t *mut);
void unlock(spinlock_t *mut);

#endif // LOCK_H
