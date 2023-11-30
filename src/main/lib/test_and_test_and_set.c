#include "lock.h"

void lock(spinlock_t *mut)
{

    // TODO I don't know if this is indeed what is needed ??
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