#include "lock.h"

#ifdef TEST_AND_SET

void lock(spinlock_t *mut)
{
    int one = 1;
    asm volatile(
        "1: \n\t"
        "xchgl %0, %1 \n\t" // Exchange the mut value with register %0 (one)
        "testl %0, %0 \n\t" // Test if the old value was 0 (the mut was free)
        "jnz 1b \n\t"       // If not zero, jump back to the beginning of the loop (mut was not free)
        : "+r"(one), "+m"(mut->flag));
}

#elif TEST_AND_TEST_AND_SET
#include <stdio.h>

void lock(spinlock_t *mut)
{
    int one = 1;
    asm volatile(
        "1: \n\t"

        "movl %1, %0 \n\t"  // Move the value of the mut to register %0 (one)
        "testl %0, %0 \n\t" // Test if the old value was 0 (the mut was free)
        "jnz 1b \n\t"       // If not zero, jump back to the beginning of the loop (mut was not free)

        "xchgl %0, %1 \n\t" // Exchange the mut value with register %0 (one)
        "testl %0, %0 \n\t" // Test if the old value was 0 (the mut was free)
        "jnz 1b \n\t"       // If not zero, jump back to the beginning of the loop (mut was not free)
        : "+r"(one), "+m"(mut->flag));
}

#elif BACKOFF_TEST_AND_TEST_AND_SET

#include <time.h>

#define MIN_DELAY 1
#define MAX_DELAY 1000

void lock(spinlock_t *mut)
{
    int expected = 1;
    int delay = MIN_DELAY;

    while (expected != 0)
    {
        asm volatile(
            "1: \n\t"
            "movl %1, %0 \n\t"  // Move the value of the mut to register %0 (one)
            "testl %0, %0 \n\t" // Test if the old value was 0 (the mut was free)
            "jnz 1b \n\t"       // If not zero, jump back to the beginning of the loop (mut was not free)

            "xchgl %0, %1 \n\t" // Exchange the mut value with register %0 (one)
            // "testl %0, %0 \n\t" // Test if the old value was 0 (the mut was free)
            // "jnz 1b \n\t"       // If not zero, jump back to the beginning of the loop (mut was not free)
            : "+r"(expected), "+m"(mut->flag));

        if (expected != 0)
        {
            struct timespec ts;
            ts.tv_nsec = delay;
            ts.tv_sec = 0;
            nanosleep(&ts, NULL);
            if (delay < MAX_DELAY)
            {
                delay *= 2;
            }
        }
    }
}

#endif

int spinlock_init(spinlock_t *mut)
{
    mut->flag = 0;
    return 0;
}

void unlock(spinlock_t *mut)
{
    asm volatile(
        "movl $0, %0 \n\t" // Set the mut to 0
        : "=m"(mut->flag));
}

int spinlock_destroy(spinlock_t *mut)
{
    (void)mut;
    return 0;
}
