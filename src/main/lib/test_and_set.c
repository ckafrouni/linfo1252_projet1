#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#include "test_and_set.h"

void spinlock_lock(spinlock_t *lock)
{
    int one = 1;
    asm volatile(
        "loop: \n\t"
        "xchgl %0, %1 \n\t" // Exchange the lock value with register %0 (one)
        "testl %0, %0 \n\t" // Test if the old value was 0 (the lock was free)
        "jnz loop \n\t"     // If not zero, jump back to the beginning of the loop (lock was not free)
        : "+r"(one), "+m"(lock->lock));
}

void spinlock_unlock(spinlock_t *lock)
{
    asm volatile(
        "movl $0, %0 \n\t" // Set the lock to 0
        : "=m"(lock->lock));
}