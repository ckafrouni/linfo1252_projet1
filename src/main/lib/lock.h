#ifndef TEST_AND_SET_H
#define TEST_AND_SET_H

typedef struct
{
    volatile int mut;
} spinlock_t;

void lock(spinlock_t *mut);
void unlock(spinlock_t *mut);

#endif // TEST_AND_SET_H
