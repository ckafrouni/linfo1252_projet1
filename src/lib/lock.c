#include "lock.h"
#include <stdio.h>
#ifdef TAS
inline void lock(spinlock_t *mut)
{
    int is_locked = 1;
    do
    {
        asm volatile(
            "xchgl %0, %1 \n\t"
            : "+r"(is_locked), "+m"(mut->flag));
    }
    while (is_locked == 1);
}
#endif // TAS

#ifdef TTAS
inline void lock(spinlock_t *mut)
{
    int is_locked = 1;
    do
    {
        if (mut->flag == 1)
        {
            __asm__ __volatile__("pause");
        }
        __asm__ __volatile__(
            "xchgl %0, %1 \n\t"
            : "+r"(is_locked), "+m"(mut->flag)
        );
    } while (is_locked == 1);
}
#endif // TTAS

#ifdef BTTAS
#include <time.h>

#define MIN_DELAY 1
#define MAX_DELAY 1000

struct timespec ts_btatas = {
    .tv_nsec = MIN_DELAY,
};

inline void lock(spinlock_t *mut)
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
#endif // BTTAS

int spinlock_init(spinlock_t *mut)
{
    mut->flag = 0;
    return 0;
}

inline void unlock(spinlock_t *mut)
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
