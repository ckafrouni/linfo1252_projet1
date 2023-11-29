#ifndef TEST_AND_SET_H
#define TEST_AND_SET_H

typedef struct
{
    volatile int lock;
} spinlock_t;

void spinlock_lock(spinlock_t *lock);
void spinlock_unlock(spinlock_t *lock);

#endif // TEST_AND_SET_H
