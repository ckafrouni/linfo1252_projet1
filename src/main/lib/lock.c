#include "lock.h"

#ifdef TEST_AND_SET

void lock(spinlock_t *mut)
{
    int reg = 1;
    while (reg == 1)
    {
        asm volatile(
            "xchgl %0, %1 \n\t"
            : "+r"(reg), "+m"(mut->flag));
    }
}

#elif TEST_AND_TEST_AND_SET
#include <stdio.h>

void lock(spinlock_t *mut)
{
    int reg = 1;
    while (reg == 1)
    {
        if (mut->flag == 0)
        {
            asm volatile(
                "xchgl %0, %1 \n\t"
                : "+r"(reg), "+m"(mut->flag));
        }
    }
}

#elif BACKOFF_TEST_AND_TEST_AND_SET

#include <time.h>

#define MIN_DELAY 1
#define MAX_DELAY 1000

struct timespec ts_btatas = {
    .tv_nsec = MIN_DELAY,
};

void lock(spinlock_t *mut)
{

    int reg = 1;
    while (reg == 1)
    {
        if (mut->flag == 0)
        {
            asm volatile(
                "xchgl %0, %1 \n\t"
                : "+r"(reg), "+m"(mut->flag));
        }
        else
        {
            nanosleep(&ts_btatas, NULL);
            if (ts_btatas.tv_nsec < MAX_DELAY)
            {
                ts_btatas.tv_nsec *= 2;
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
