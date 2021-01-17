#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include "stupidedi/include/builtins.h"
#include "stupidedi/include/wavelet.h"

typedef struct stupidedi_wavelet_t
{
  struct stupidedi_wavelet_t *l, *r;
  stupidedi_rrr_t* rrr;
  uint8_t height;
} stupidedi_wavelet_t;

/*****************************************************************************/

stupidedi_wavelet_t*
stupidedi_wavelet_alloc(void)
{
    return malloc(sizeof(stupidedi_wavelet_t));
}

stupidedi_wavelet_t*
stupidedi_wavelet_dealloc(stupidedi_wavelet_t* w)
{
    if (w != NULL)
        free(stupidedi_wavelet_deinit(w));

    return NULL;
}

stupidedi_wavelet_t*
stupidedi_wavelet_new(stupidedi_packed_t* a, uint8_t height)
{
    return stupidedi_wavelet_init(stupidedi_wavelet_alloc(), a, height);
}

stupidedi_wavelet_t*
stupidedi_wavelet_init(stupidedi_wavelet_t* w, stupidedi_packed_t* a, uint8_t height)
{
    if (height == 0)
        return NULL;

    assert(a != NULL);
    assert(w != NULL);
    w->height = height;

    if (height == 1)
    {
        w->rrr = stupidedi_rrr_new(stupidedi_packed_as_bitstr(a), 63, 512);
        w->l   = NULL;
        w->r   = NULL;
        return w;
    }

    const size_t length \
        = stupidedi_packed_length(a);

    stupidedi_rrr_builder_t* rrr_;
    rrr_ = stupidedi_rrr_builder_new(63, 512, length);

    stupidedi_packed_t *lb, *rb;
    lb = stupidedi_packed_new(length, height - 1);
    rb = stupidedi_packed_new(length, height - 1);

    /* Number of symbols belonging to left and right subtree */
    size_t nl, nr;
    nl = 0;
    nr = 0;

    /* Remove one high bit at each level of the tree */
    uint64_t head, rest;
    head = 1 << (height - 1);
    rest = head - 1;

    for (size_t k = 0; k < length; ++k)
    {
        const uint64_t c \
            = stupidedi_packed_read(a, k);

        if ((c & head) == 0)
        {
            stupidedi_rrr_builder_write(rrr_, 1, 0);
            stupidedi_packed_write(lb, nl++, (c & rest));
        }
        else
        {
            stupidedi_rrr_builder_write(rrr_, 1, 1);
            stupidedi_packed_write(rb, nr++, (c & rest));
        }
    }

    lb = (nl == 0) ?
        stupidedi_packed_dealloc(lb) :
        stupidedi_packed_resize(lb, nl);

    rb = (nr == 0) ?
        stupidedi_packed_dealloc(rb) :
        stupidedi_packed_resize(rb, nr);

    w->rrr = stupidedi_rrr_builder_to_rrr(rrr_, NULL);
    stupidedi_rrr_builder_dealloc(rrr_);

    w->l = (lb == 0) ? NULL : stupidedi_wavelet_new(lb, height - 1);
    w->r = (rb == 0) ? NULL : stupidedi_wavelet_new(rb, height - 1);

    return w;
}

stupidedi_wavelet_t*
stupidedi_wavelet_deinit(stupidedi_wavelet_t* w)
{
    if (w == NULL)
        return NULL;

    if (w->rrr) w->rrr = stupidedi_rrr_dealloc(w->rrr);
    if (w->l)   w->l   = stupidedi_wavelet_dealloc(w->l);
    if (w->r)   w->r   = stupidedi_wavelet_dealloc(w->r);

    return w;
}

/*****************************************************************************/

size_t
stupidedi_wavelet_sizeof(const stupidedi_wavelet_t* w)
{
    return (w == NULL) ? 0 : sizeof(*w) +
        (w->rrr == NULL ? 0 : stupidedi_rrr_sizeof(w->rrr)) +
        (w->l == NULL ? 0 : stupidedi_wavelet_sizeof(w->l)) +
        (w->r == NULL ? 0 : stupidedi_wavelet_sizeof(w->l));
}

size_t
stupidedi_wavelet_length(const stupidedi_wavelet_t* w)
{
    assert(w != NULL);
    assert(w->rrr != NULL);
    return stupidedi_rrr_length(w->rrr);
}

char*
stupidedi_wavelet_to_string(const stupidedi_wavelet_t* w)
{
    return NULL; /* TODO */
}

stupidedi_packed_t*
stupidedi_wavelet_to_packed(const stupidedi_wavelet_t* w)
{
    return NULL; /* TODO */
}

/*****************************************************************************/

static inline bool
choose_branch(uint64_t c, uint64_t mask)
{
    return (c & mask) == 0;
}

uint64_t
stupidedi_wavelet_access(const stupidedi_wavelet_t* w, size_t i)
{
    uint64_t c;
    c = 0;

    for (uint64_t mask = 1ull << (w->height - 1); mask != 0; mask = mask >> 1)
    {
        if (stupidedi_rrr_access(w->rrr, i) == 0)
        {
            i = stupidedi_rrr_rank0(w->rrr, i) - 1;
            c = (c << 1) | 0;
            w = w->l;
        }
        else
        {
            i = stupidedi_rrr_rank1(w->rrr, i) - 1;
            c = (c << 1) | 1;
            w = w->r;
        }
    }

    return c;
}

size_t
stupidedi_wavelet_rank(const stupidedi_wavelet_t* w, uint64_t c, size_t i)
{
    assert(w != NULL);

    for (uint64_t mask = 1ull << (w->height - 1); mask != 0; mask = mask >> 1)
    {
        size_t r;

        if ((c & mask) == 0)
        {
            r = stupidedi_rrr_rank0(w->rrr, i);
            w = w->l;
        }
        else
        {
            r = stupidedi_rrr_rank1(w->rrr, i);
            w = w->l;
        }

        if (r == 0)
            return 0;

        i = r - 1;
    }

    return i + 1;
}

static size_t
stupidedi_wavelet_select_aux(const stupidedi_wavelet_t* w, uint64_t c, size_t r, uint64_t mask)
{
    if (w == NULL)
        return r - 1;

    size_t i, j;

    if ((c & mask) == 0)
    {
        i = stupidedi_wavelet_select_aux(w->l, c, r, mask >> 1);
        j = (i == SIZE_MAX) ? SIZE_MAX : stupidedi_rrr_select0(w->rrr, i + 1);
    }
    else
    {
        i = stupidedi_wavelet_select_aux(w->r, c, r, mask >> 1);
        j = (i == SIZE_MAX) ? SIZE_MAX : stupidedi_rrr_select1(w->rrr, i + 1);
    }

    return j;
}

size_t
stupidedi_wavelet_select(const stupidedi_wavelet_t* w, uint64_t c, size_t r)
{
    assert(w != NULL);

    /* TODO: Replace recursion with iteration. Note we need to maintain a stack
     * because after determining the leaf where c belongs, we need to traverse
     * back up to the root and report c's position relative to the whole */
    return stupidedi_wavelet_select_aux(w, c, r, (1ull << (w->height - 1)));
}

size_t
stupidedi_wavelet_prev(const stupidedi_wavelet_t* w, uint64_t c, size_t r)
{
    return 0; /* TODO */
}

size_t
stupidedi_wavelet_next(const stupidedi_wavelet_t* w, uint64_t c, size_t r)
{
    return 0; /* TODO */
}
