#include <time.h>
#include <stdio.h>

#include "lock.h"

#define MIN_DELAY 1
#define MAX_DELAY 1000

void lock(spinlock_t *mut)
{
    // TODO backoff-test-and-test-and-set lock

    // printf("backoff-test-and-test-and-set lock\n");

    int expected = 1;
    int delay = MIN_DELAY;

    while (expected != 0)
    {
        asm volatile(
            "loop: \n\t"
            "xchgl %0, %1 \n\t" // Exchange the mut value with register %0 (one)
            "testl %0, %0 \n\t" // Test if the old value was 0 (the mut was free)
            "jnz loop \n\t"     // If not zero, jump back to the beginning of the loop (mut was not free)
            : "+r"(expected), "+m"(mut->mut));
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

void unlock(spinlock_t *mut)
{
    asm volatile(
        "movl $0, %0 \n\t" // Set the mut to 0
        : "=m"(mut->mut));
}