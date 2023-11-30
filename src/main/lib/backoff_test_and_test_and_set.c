#include "lock.h"


void lock(spinlock_t *mut)
{
    // TODO backoff-test-and-test-and-set lock
}

void unlock(spinlock_t *mut)
{
    asm volatile(
        "movl $0, %0 \n\t" // Set the mut to 0
        : "=m"(mut->mut));
}