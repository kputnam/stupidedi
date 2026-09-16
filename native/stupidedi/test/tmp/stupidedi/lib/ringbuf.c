#include <math.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdlib.h>
#include "stupidedi/include/packed.h"
#include "stupidedi/include/ringbuf.h"

#define MIN(a,b) ((a) < (b) ? (a) : (b))
#define MAX(a,b) ((a) > (b) ? (a) : (b))

typedef struct stupidedi_ringbuf_t
{
    /* Location of next write */
    size_t enq_at;

    /* Location of next read  */
    size_t deq_at;

    write_mode mode;

    /* O(n) */
    stupidedi_packed_t* data;
} stupidedi_ringbuf_t;

/*****************************************************************************/

stupidedi_ringbuf_t*
stupidedi_ringbuf_alloc(void)
{
    return malloc(sizeof(stupidedi_ringbuf_t));
}

stupidedi_ringbuf_t*
stupidedi_ringbuf_free(stupidedi_ringbuf_t* q)
{
    if (q != NULL)
        free(stupidedi_ringbuf_deinit(q));
    return NULL;
}

stupidedi_ringbuf_t*
stupidedi_ringbuf_new(size_t capacity, size_t width, write_mode mode)
{
    return stupidedi_ringbuf_init(stupidedi_ringbuf_alloc(), capacity, width, mode);
}

stupidedi_ringbuf_t*
stupidedi_ringbuf_init(stupidedi_ringbuf_t* q, size_t capacity, size_t width, write_mode mode)
{
    assert(q != NULL);

    q->enq_at = 0;
    q->deq_at = 0;
    q->mode = mode;
    q->data = stupidedi_packed_new(capacity + 1, width); /* TODO: No need to initialize elements */

    return q;
}

stupidedi_ringbuf_t*
stupidedi_ringbuf_deinit(stupidedi_ringbuf_t* q)
{
    if (q == NULL)
        return q;

    if (q->data != NULL)
        q->data = stupidedi_packed_free(q->data);

    return q;
}

stupidedi_ringbuf_t*
stupidedi_ringbuf_copy(const stupidedi_ringbuf_t* src, stupidedi_ringbuf_t* dst)
{
    if (src == dst)
        return dst;

    if (dst != NULL)
        stupidedi_ringbuf_deinit(dst);
    else
    {
        dst = stupidedi_ringbuf_alloc();
        assert(dst != NULL);
    }

    dst->enq_at = src->enq_at;
    dst->deq_at = src->deq_at;
    dst->mode = src->mode;
    dst->data = NULL;
    stupidedi_packed_copy(src->data, dst->data);

    return dst;
}

stupidedi_ringbuf_t*
stupidedi_ringbuf_resize(stupidedi_ringbuf_t* q, const size_t new_capacity)
{
    const size_t old_capacity =
        stupidedi_ringbuf_capacity(q);

    if (new_capacity == old_capacity)
        return q;

    if (new_capacity > old_capacity)
    {
        const size_t delta =
            new_capacity - old_capacity;

        /* Extending the length of a vector preserves the original items. */
        q->data = stupidedi_packed_resize(q->data, new_capacity + 1);

        if (q->enq_at < q->deq_at)
        {
            /*  [FGHIJ ... ABCDE] => [IJ ... ABCDEFGH]
             *        ^e   ^d           ^e   ^d
             *
             *  [FGHIJ ... ABCDE] => [ ...   ABCDEFGHIJ ... ]
             *        ^e   ^d                ^d        ^e
             */

            /* Move items at front of W into Z until Z is full */
            for (size_t k = 0; k < q->enq_at && k < delta; ++k)
                stupidedi_packed_write(q->data, old_capacity + k + 1,
                        stupidedi_packed_read(q->data, k));

            /* Move remaining items at back of W to the front of W */
            for (size_t k = delta; k < q->enq_at; ++k)
                stupidedi_packed_write(q->data, k - delta,
                        stupidedi_packed_read(q->data, k));

            if (delta <= q->enq_at)
                q->enq_at -= delta;
            else
                q->enq_at += old_capacity + 1;
        }
    }
    else if (new_capacity < old_capacity)
    {
        /* If there isn't enough remaining capacity to store all the elements,
         * the oldest items will be discarded. Keep the newest `keep` items,
         * read out in logical (oldest-to-newest) order via peek/length, which
         * already account for wraparound -- this avoids re-deriving the same
         * index arithmetic here. */
        const size_t length = stupidedi_ringbuf_length(q);
        const size_t keep   = MIN(length, new_capacity);
        const size_t skip   = length - keep;

        if (keep == 0)
        {
            q->data = stupidedi_packed_resize(q->data, new_capacity + 1);
        }
        else
        {
            stupidedi_packed_t* data;
            data = stupidedi_packed_new(new_capacity + 1, stupidedi_packed_width(q->data));

            for (size_t k = 0; k < keep; ++k)
                stupidedi_packed_write(data, k,
                        stupidedi_ringbuf_peek(q, skip + k));

            q->data = stupidedi_packed_free(q->data);
            q->data = data;
        }

        q->deq_at = 0;
        q->enq_at = keep;
    }

    return q;
}

/*****************************************************************************/

size_t
stupidedi_ringbuf_sizeof(const stupidedi_ringbuf_t* q)
{
    return (q == NULL) ? 0 : sizeof(*q) + stupidedi_packed_sizeof(q->data);
}

size_t
stupidedi_ringbuf_length(const stupidedi_ringbuf_t* q)
{
    assert(q != NULL);

    if (q->deq_at <= q->enq_at)
        /* [ ... d ... e ... ]
         *       ^^^^^^        */
        return q->enq_at - q->deq_at;

    /* [ ... e ... d ... ]
     *  ^^^^^      ^^^^^^^ */
    return stupidedi_packed_length(q->data) - q->deq_at + q->enq_at;
}

size_t
stupidedi_ringbuf_capacity(const stupidedi_ringbuf_t* q)
{
    assert(q != NULL);
    return stupidedi_packed_length(q->data) - 1;
}

uint64_t*
stupidedi_ringbuf_to_array(const stupidedi_ringbuf_t* q)
{
    return NULL; /* TODO */
}

char*
stupidedi_ringbuf_to_string(const stupidedi_ringbuf_t* q)
{
    char *data, *str;
    data = stupidedi_packed_to_string(q->data);

    size_t e, d, len;
    d = q->deq_at * (stupidedi_packed_width(q->data) + 1);
    e = q->enq_at * (stupidedi_packed_width(q->data) + 1);

    if (d > 0) --d; data[d] = '<';
    if (e > 0) --e; data[e] = '>';

    len = strlen(data) + 128;
    str = malloc(len);

    int n;
    n = sprintf(str, "mode=%u, capacity=%04lu, length=%04lu, deq_at=%04lu, enq_at=%04lu: %s",
            q->mode, stupidedi_ringbuf_capacity(q), stupidedi_ringbuf_length(q), q->deq_at, q->enq_at, data);

    free(data);

    if (n == len)
    {
        str[n-1] = '.';
        str[n-2] = '.';
        str[n-3] = '.';
    }

    str[n] = '\0';

    return str;
}

/*****************************************************************************/

stupidedi_ringbuf_t*
stupidedi_ringbuf_clear(stupidedi_ringbuf_t* q)
{
    assert(q != NULL);
    q->enq_at = 0;
    q->deq_at = 0;

    return q;
}

bool
stupidedi_ringbuf_empty(stupidedi_ringbuf_t* q)
{
    assert(q != NULL);
    return q->deq_at == q->enq_at;
}

uint64_t
stupidedi_ringbuf_peek(stupidedi_ringbuf_t* q, size_t i)
{
    assert(q != NULL);
    assert(i < stupidedi_ringbuf_length(q));

    i += q->deq_at;

    /* This can only happen when enq_at > deq_at */
    if (i >= stupidedi_packed_length(q->data))
        i -= stupidedi_packed_length(q->data);

    return stupidedi_packed_read(q->data, i);
}

uint64_t
stupidedi_ringbuf_dequeue(stupidedi_ringbuf_t* q)
{
    assert(q != NULL);
    assert(0 < stupidedi_ringbuf_length(q));

    const size_t i
        = q->deq_at;

    q->deq_at ++;

    // ------- 10 --------
    // ---- cap 9 --------
    // 0 1 2 3 4 5 6 7 8 9
    if (q->deq_at >= stupidedi_packed_length(q->data))
        q->deq_at -= stupidedi_packed_length(q->data);

    return stupidedi_packed_read(q->data, i);
}

size_t
stupidedi_ringbuf_enqueue(stupidedi_ringbuf_t* q, uint64_t value)
{
    assert(q != NULL);

    size_t enq_at;
    enq_at = q->enq_at;

    if (++enq_at >= stupidedi_packed_length(q->data))
        enq_at = 0;

    if (enq_at == q->deq_at)
    {
        switch (q->mode)
        {
            case FAIL:
                assert(false);
                //return 0;
            case EXPAND:
                stupidedi_ringbuf_resize(q, 2 * stupidedi_ringbuf_capacity(q));
                stupidedi_packed_write(q->data, q->enq_at, value);
                if (++q->enq_at >= stupidedi_packed_length(q->data))
                    q->enq_at = 0;
                break;
            case OVERWRITE:
                stupidedi_packed_write(q->data, q->enq_at, value);
                q->enq_at = enq_at;
                if (++q->deq_at >= stupidedi_packed_length(q->data))
                    q->deq_at = 0;
                break;
        }
    }
    else
    {
        stupidedi_packed_write(q->data, q->enq_at, value);
        q->enq_at = enq_at;
    }

    return 1;
}
