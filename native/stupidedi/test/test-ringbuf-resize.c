#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>
#include <inttypes.h>
#include "stupidedi/include/ringbuf.h"

/* Checks the ringbuf's logical contents (via peek/length) against a plain
 * array reference, after some sequence of enqueue/dequeue/resize calls. */
static int failures = 0;

static void
check(const char* label, stupidedi_ringbuf_t* q, uint64_t* expect, size_t n)
{
    size_t got_n = stupidedi_ringbuf_length(q);

    if (got_n != n)
    {
        printf("%s: length mismatch expect=%zu got=%zu ***MISMATCH***\n", label, n, got_n);
        ++failures;
        return;
    }

    for (size_t k = 0; k < n; ++k)
    {
        uint64_t got = stupidedi_ringbuf_peek(q, k);
        if (got != expect[k])
        {
            printf("%s: peek(%zu) expect=%"PRIu64" got=%"PRIu64" ***MISMATCH***\n",
                    label, k, expect[k], got);
            ++failures;
        }
    }

    printf("%s: OK (length=%zu)\n", label, n);
}

int
main(int argc, char **argv)
{
    /* Case 1: no wraparound (deq_at < enq_at), grow then shrink. */
    {
        stupidedi_ringbuf_t* q;
        q = stupidedi_ringbuf_new(10, 8, FAIL);

        uint64_t expect[10];
        for (size_t k = 0; k < 6; ++k)
        {
            stupidedi_ringbuf_enqueue(q, k + 1);
            expect[k] = k + 1;
        }

        check("case1-initial", q, expect, 6);

        stupidedi_ringbuf_resize(q, 20);
        check("case1-grow", q, expect, 6);

        /* Shrink to fewer than current length: discard oldest. */
        stupidedi_ringbuf_resize(q, 4);
        uint64_t expect_shrunk[4] = { 3, 4, 5, 6 };
        check("case1-shrink-discard", q, expect_shrunk, 4);

        stupidedi_ringbuf_free(q);
    }

    /* Case 2: wrapped (enq_at < deq_at), then grow. */
    {
        stupidedi_ringbuf_t* q;
        q = stupidedi_ringbuf_new(8, 8, FAIL);

        /* Fill, dequeue some, enqueue more so enq_at wraps past deq_at. */
        for (size_t k = 0; k < 8; ++k)
            stupidedi_ringbuf_enqueue(q, k + 1);

        for (size_t k = 0; k < 5; ++k)
            stupidedi_ringbuf_dequeue(q);

        for (size_t k = 0; k < 5; ++k)
            stupidedi_ringbuf_enqueue(q, 100 + k);

        uint64_t expect[8] = { 6, 7, 8, 100, 101, 102, 103, 104 };
        check("case2-wrapped", q, expect, 8);

        stupidedi_ringbuf_resize(q, 16);
        check("case2-grow-wrapped", q, expect, 8);

        stupidedi_ringbuf_free(q);
    }

    /* Case 3: wrapped, then shrink below current length (discard oldest). */
    {
        stupidedi_ringbuf_t* q;
        q = stupidedi_ringbuf_new(8, 8, FAIL);

        for (size_t k = 0; k < 8; ++k)
            stupidedi_ringbuf_enqueue(q, k + 1);

        for (size_t k = 0; k < 5; ++k)
            stupidedi_ringbuf_dequeue(q);

        for (size_t k = 0; k < 5; ++k)
            stupidedi_ringbuf_enqueue(q, 100 + k);

        /* Contents: 6, 7, 8, 100, 101, 102, 103, 104 (length 8) */
        stupidedi_ringbuf_resize(q, 3);
        uint64_t expect[3] = { 102, 103, 104 };
        check("case3-shrink-wrapped", q, expect, 3);

        stupidedi_ringbuf_free(q);
    }

    /* Case 4: shrink to exactly current length (no discard), wrapped. */
    {
        stupidedi_ringbuf_t* q;
        q = stupidedi_ringbuf_new(8, 8, FAIL);

        for (size_t k = 0; k < 8; ++k)
            stupidedi_ringbuf_enqueue(q, k + 1);

        for (size_t k = 0; k < 5; ++k)
            stupidedi_ringbuf_dequeue(q);

        for (size_t k = 0; k < 5; ++k)
            stupidedi_ringbuf_enqueue(q, 100 + k);

        /* Contents: 6, 7, 8, 100, 101, 102, 103, 104 (length 8) */
        stupidedi_ringbuf_resize(q, 8);
        uint64_t expect[8] = { 6, 7, 8, 100, 101, 102, 103, 104 };
        check("case4-shrink-exact-wrapped", q, expect, 8);

        stupidedi_ringbuf_free(q);
    }

    /* Case 5: shrink an empty ringbuf. */
    {
        stupidedi_ringbuf_t* q;
        q = stupidedi_ringbuf_new(10, 8, FAIL);
        stupidedi_ringbuf_resize(q, 2);

        uint64_t expect[1];
        check("case5-shrink-empty", q, expect, 0);

        /* Should still work fine afterward. */
        stupidedi_ringbuf_enqueue(q, 42);
        uint64_t expect2[1] = { 42 };
        check("case5-post-shrink-enqueue", q, expect2, 1);

        stupidedi_ringbuf_free(q);
    }

    /* Case 6: EXPAND write mode still triggers correct growth via enqueue. */
    {
        stupidedi_ringbuf_t* q;
        q = stupidedi_ringbuf_new(4, 8, EXPAND);

        uint64_t expect[10];
        for (size_t k = 0; k < 10; ++k)
        {
            stupidedi_ringbuf_enqueue(q, k + 1);
            expect[k] = k + 1;
        }

        check("case6-expand", q, expect, 10);

        stupidedi_ringbuf_free(q);
    }

    printf("\n%s\n", failures == 0 ? "ALL OK" : "FAILURES");
    return failures == 0 ? 0 : 1;
}
