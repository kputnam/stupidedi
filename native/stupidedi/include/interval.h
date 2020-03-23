#ifndef STUPIDEDI_INTERVAL_H_
#define STUPIDEDI_INTERVAL_H_

#include <stdbool.h>
#include <stdint.h>

typedef struct stupidedi_interval_list_t
{
    /* TODO */
    uint32_t size;

    /* TODO */
    uint32_t* min;

    /* TODO */
    uint32_t* max;
} stupidedi_interval_list_t;

bool
stupidedi_interval_list_test(const uint32_t point, stupidedi_interval_list_t* tree);

#endif
