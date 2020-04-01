#ifndef STUPIDEDI_INTERVAL_H_
#define STUPIDEDI_INTERVAL_H_

#include <stdbool.h>
#include <stdint.h>

typedef struct stupidedi_interval_list_t
{
    size_t length;
    uint64_t* min;
    uint64_t* max;
} stupidedi_interval_list_t;

bool
stupidedi_interval_test(stupidedi_interval_list_t* tree, const uint64_t point);

#endif
