#include "lock.h"

#ifdef DEBUG
#include <stdio.h>
#endif

/**
 * TEST_AND_SET
 */
#ifdef TEST_AND_SET

void lock(spinlock_t *mut)
{
#ifdef DEBUG
    printf("test-and-set lock\n");
#endif
    int one = 1;
    asm volatile(
        "loop: \n\t"
        "xchgl %0, %1 \n\t" // Exchange the mut value with register %0 (one)
        "testl %0, %0 \n\t" // Test if the old value was 0 (the mut was free)
        "jnz loop \n\t"     // If not zero, jump back to the beginning of the loop (mut was not free)
        : "+r"(one), "+m"(mut->flag));
}

void unlock(spinlock_t *mut)
{
    asm volatile(
        "movl $0, %0 \n\t" // Set the mut to 0
        : "=m"(mut->flag));
}

#endif // TEST_AND_SET

/**
 * TEST_AND_TEST_AND_SET
 */
#ifdef TEST_AND_TEST_AND_SET

void lock(spinlock_t *mut)
{
#ifdef DEBUG
    printf("test-and-test-and-set lock\n");
#endif

    int one = 1;
    asm volatile(
        "loop: \n\t"

        "movl %1, %0 \n\t"  // Move the value of the mut to register %0 (one)
        "testl %0, %0 \n\t" // Test if the old value was 0 (the mut was free)
        "jnz loop \n\t"     // If not zero, jump back to the beginning of the loop (mut was not free)

        "xchgl %0, %1 \n\t" // Exchange the mut value with register %0 (one)
        "testl %0, %0 \n\t" // Test if the old value was 0 (the mut was free)
        "jnz loop \n\t"     // If not zero, jump back to the beginning of the loop (mut was not free)
        : "+r"(one), "+m"(mut->flag));
}

void unlock(spinlock_t *mut)
{
    asm volatile(
        "movl $0, %0 \n\t" // Set the mut to 0
        : "=m"(mut->flag));
}

#endif // TEST_AND_TEST_AND_SET

/**
 * BACKOFF_TEST_AND_TEST_AND_SET
 */
#ifdef BACKOFF_TEST_AND_TEST_AND_SET

#include <time.h>

#define MIN_DELAY 1
#define MAX_DELAY 1000

void lock(spinlock_t *mut)
{
#ifdef DEBUG
    printf("backoff-test-and-test-and-set lock\n");
#endif

    int expected = 1;
    int delay = MIN_DELAY;

    while (expected != 0)
    {
        while (mut->flag != 0)
            ;

        asm volatile(
            "loop: \n\t"
            "xchgl %0, %1 \n\t" // Exchange the mut value with register %0 (one)
            "testl %0, %0 \n\t" // Test if the old value was 0 (the mut was free)
            "jnz loop \n\t"     // If not zero, jump back to the beginning of the loop (mut was not free)
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

void unlock(spinlock_t *mut)
{
    asm volatile(
        "movl $0, %0 \n\t" // Set the mut to 0
        : "=m"(mut->flag));
}

#endif // BACKOFF_TEST_AND_TEST_AND_SET