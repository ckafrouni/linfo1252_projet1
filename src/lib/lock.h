#ifndef LOCK_H
#define LOCK_H

typedef struct
{
    int flag;
} spinlock_t;

int spinlock_init(spinlock_t *mut);
void lock(spinlock_t *mut);
void unlock(spinlock_t *mut);
int spinlock_destroy(spinlock_t *mut);

#endif // LOCK_H
