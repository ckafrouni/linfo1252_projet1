#include "lock.h"

/**
 * This is a test-and-test-and-set lock. It is a variant of the test-and-set lock.
 * 
 * It solves the problem of cache invalidation by first testing the lock value in a loop.
 * If the lock is free, it will then try to acquire it.
 * 
 * However, this lock is still not that much better than the test-and-set lock.
 * 
 * Whenever a lock is released, all other threads will try to acquire it at the same time.
 * This will cause a lot of cache invalidation by calling the xchgl instruction, and
 * periodical peaks in CPU usage.
 * 
 * The higher the number of threads, the more this problem will occur.
 * 
 * A possible solution to this problem is the backoff-test-and-test-and-set lock.
 * 
 * @param mut The spinlock to acquire
 */
void lock(spinlock_t *mut)
{
    int one = 1;
    asm volatile(
        "loop: \n\t"

        "movl %1, %0 \n\t"  // Move the value of the mut to register %0 (one)
        "testl %0, %0 \n\t" // Test if the old value was 0 (the mut was free)
        "jnz loop \n\t"     // If not zero, jump back to the beginning of the loop (mut was not free)

        "xchgl %0, %1 \n\t" // Exchange the mut value with register %0 (one)
        "testl %0, %0 \n\t" // Test if the old value was 0 (the mut was free)
        "jnz loop \n\t"     // If not zero, jump back to the beginning of the loop (mut was not free)
        : "+r"(one), "+m"(mut->mut));
}

void unlock(spinlock_t *mut)
{
    asm volatile(
        "movl $0, %0 \n\t" // Set the mut to 0
        : "=m"(mut->mut));
}