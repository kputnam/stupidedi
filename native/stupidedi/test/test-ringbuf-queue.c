#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>
#include <inttypes.h>
#include "stupidedi/include/ringbuf.h"

void
ringbuf_p(stupidedi_ringbuf_t *q)
{
    char *s;
    s = stupidedi_ringbuf_to_string(q);
    printf("%s\n", s);
    free(s);
}

int
main(int argc, char **argv)
{
    stupidedi_ringbuf_t* q;
    q = stupidedi_ringbuf_new(8, 4, EXPAND);

    ringbuf_p(q);

    for (size_t k = 0, z = 13; k < z; ++k)
    {
        stupidedi_ringbuf_enqueue(q, k);
        ringbuf_p(q);
    }

    printf("\n");
    ringbuf_p(q);
    for (size_t k = 0, z = stupidedi_ringbuf_length(q); k < z; ++k)
        printf("q[%02lu] = %"PRIu64"\n", k, stupidedi_ringbuf_peek(q, k));

    printf("\n");
    ringbuf_p(q);

    while (!stupidedi_ringbuf_empty(q))
    {
        const uint64_t x
            = stupidedi_ringbuf_dequeue(q);

        printf("dequeue: %"PRIu64"\n", x);
        ringbuf_p(q);
    }

    return 0;
}
