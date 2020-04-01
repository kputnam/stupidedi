#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include "stupidedi/include/builtins.h"
#include "stupidedi/include/wavelet.h"

/*
 * In this particular application, the alphabet typically contains six symbols.
 * Using the files in spec/fixtures as a sample, the relative frequences of each
 * symbol are approximately:
 *
 *   I  the letter I
 *   S  the letter S
 *   A  the letter A
 *   α  graphical character
 *   *  element separator
 *   ~  segment terminator
 *   _  non-graphical character
 *   :  component separator
 *   ^  repetition separator
 *
 *   p(sᵢ = a) = 0.77332 graphical character
 *   p(sᵢ = *) = 0.17135 element separator
 *   p(sᵢ = ~) = 0.03651 segment terminator
 *   p(sᵢ = _) = 0.01284 non-graphical character (\r, \n, etc)
 *   p(sᵢ = :) = 0.00475 component separator
 *   p(sᵢ = ^) = 0.00120 repetition separator
 *
 * The Shannon entropy (H₀) of this distribution is 1.02636 compared to 2.58496,
 * which is the entropy of a uniformly random distribution of six symbols. So
 * we expect RRR sequences to provide some compression. The lower bound on
 * space required is
 *
 * Taking advantage of the fact these symbols are not i.i.d. could make higher
 * compression possible but the conditional probabilities of the next character
 * given the previous match the marginal probabilities above, at least for the
 * most common conditions.
 *
 *     p(sᵢ = a | sᵢ₋₁ = a) = 0.766936     p(sᵢ = a | sᵢ₋₁ = ~) = 0.977200
 *     p(sᵢ = * | sᵢ₋₁ = a) = 0.176897     p(sᵢ = a | sᵢ₋₁ = *) = 0.803176
 *     p(sᵢ = ~ | sᵢ₋₁ = a) = 0.036207     p(sᵢ = a | sᵢ₋₁ = :) = 0.787348
 *     p(sᵢ = _ | sᵢ₋₁ = a) = 0.014608     p(sᵢ = a | sᵢ₋₁ = a) = 0.766936
 *     p(sᵢ = : | sᵢ₋₁ = a) = 0.004844     p(sᵢ = a | sᵢ₋₁ = ^) = 0.329787
 *     p(sᵢ = ^ | sᵢ₋₁ = a) = 0.000496     p(sᵢ = a | sᵢ₋₁ = _) = 0.216350
 *
 *     p(sᵢ = a | sᵢ₋₁ = *) = 0.803176     p(sᵢ = * | sᵢ₋₁ = ^) = 0.638297
 *     p(sᵢ = * | sᵢ₋₁ = *) = 0.192412     p(sᵢ = * | sᵢ₋₁ = *) = 0.192412
 *     p(sᵢ = _ | sᵢ₋₁ = *) = 0.000074     p(sᵢ = * | sᵢ₋₁ = a) = 0.176897
 *     p(sᵢ = ^ | sᵢ₋₁ = *) = 0.004335     p(sᵢ = * | sᵢ₋₁ = :) = 0.170928
 *
 *     p(sᵢ = a | sᵢ₋₁ = ~) = 0.977200     p(sᵢ = ~ | sᵢ₋₁ = _) = 0.662512
 *     p(sᵢ = : | sᵢ₋₁ = ~) = 0.022272     p(sᵢ = ~ | sᵢ₋₁ = a) = 0.036207
 *     p(sᵢ = ^ | sᵢ₋₁ = ~) = 0.000526
 *                                         p(sᵢ = _ | sᵢ₋₁ = _) = 0.119641
 *     p(sᵢ = ~ | sᵢ₋₁ = _) = 0.662512     p(sᵢ = _ | sᵢ₋₁ = a) = 0.014608
 *     p(sᵢ = a | sᵢ₋₁ = _) = 0.216350     p(sᵢ = _ | sᵢ₋₁ = *) = 0.000074
 *     p(sᵢ = _ | sᵢ₋₁ = _) = 0.119641
 *     p(sᵢ = ^ | sᵢ₋₁ = _) = 0.001495     p(sᵢ = : | sᵢ₋₁ = :) = 0.041722
 *                                         p(sᵢ = : | sᵢ₋₁ = ~) = 0.022272
 *     p(sᵢ = a | sᵢ₋₁ = :) = 0.787348     p(sᵢ = : | sᵢ₋₁ = a) = 0.004844
 *     p(sᵢ = * | sᵢ₋₁ = :) = 0.170928
 *     p(sᵢ = : | sᵢ₋₁ = :) = 0.041722     p(sᵢ = ^ | sᵢ₋₁ = ^) = 0.031914
 *                                         p(sᵢ = ^ | sᵢ₋₁ = *) = 0.004335
 *     p(sᵢ = * | sᵢ₋₁ = ^) = 0.638297     p(sᵢ = ^ | sᵢ₋₁ = _) = 0.001495
 *     p(sᵢ = a | sᵢ₋₁ = ^) = 0.329787     p(sᵢ = ^ | sᵢ₋₁ = ~) = 0.000526
 *     p(sᵢ = ^ | sᵢ₋₁ = ^) = 0.031914     p(sᵢ = ^ | sᵢ₋₁ = a) = 0.000496
 *
 */

stupidedi_wavelet_t*
stupidedi_wavelet_alloc(stupidedi_packed_t* a, uint8_t height)
{
    return stupidedi_wavelet_init(malloc(sizeof(stupidedi_wavelet_t)), a, height);
}

stupidedi_wavelet_t*
stupidedi_wavelet_dealloc(stupidedi_wavelet_t* w)
{
    if (w != NULL)
        free(stupidedi_wavelet_deinit(w));

    return NULL;
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
        w->rrr = stupidedi_rrr_alloc(stupidedi_packed_as_bitstr(a, NULL), 63, 512);
        w->l   = NULL;
        w->r   = NULL;
        return w;
    }

    const size_t length \
        = stupidedi_packed_length(a);

    stupidedi_rrr_builder_t* rrr_;
    rrr_ = stupidedi_rrr_builder_alloc(63, 512, length);

    stupidedi_packed_t *lb, *rb;
    lb = stupidedi_packed_alloc(length, height - 1);
    rb = stupidedi_packed_alloc(length, height - 1);

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

    w->l = (lb == 0) ? NULL : stupidedi_wavelet_alloc(lb, height - 1);
    w->r = (rb == 0) ? NULL : stupidedi_wavelet_alloc(rb, height - 1);

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

uint64_t
stupidedi_wavelet_access(const stupidedi_wavelet_t* w, size_t i)
{
    uint64_t c;
    c = 0;

    while (w != NULL)
    {
        if (stupidedi_rrr_access(w->rrr, i) == 0)
        {
            /* Its position in the left subtree is its position among 1s bits;
             * for example if this is the 4th 1-bit, then it will be the 4th
             * bit in the left subtree, index 3.since we start from zero.  */
            c = (c << 1) | 0;
            i = stupidedi_rrr_rank0(w->rrr, i) - 1;
            w = w->l;
        }
        else
        {
            /* Its position in the right subtree is its position among 0s bits;
             * for example if this is the 4th 0-bit, then it will be the 4th
             * bit in the right subtree, index 3 since we start from zero. */
            c = (c << 1) | 1;
            i = stupidedi_rrr_rank1(w->rrr, i) - 1;
            w = w->r;
        }
    }

    return c;

    /* acc(l, i)
     *      if wv - av = 1 then
     *          return av
     *      end if
     *      if Bl[i] = 0 then
     *          i <- rank0(Bl, i)
     *      else
     *          i <- rank1(Bl, i)
     *      end if
     *      return acc(l+1, i)
     */

    /*
    while (w[v] - a[v] != 1)
    {
        if (rrr_access(B[l], i) == 0)
            i = rrr_rank0(B[l], i);
        else
            i = rrr_rank1(B[l], i);

        ++l;
    }

    return a[v];
    */
}

size_t
stupidedi_wavelet_rank(const stupidedi_wavelet_t* w, uint64_t c, size_t i)
{
    /*
    stupidedi_wavelet_symbol_t min, max;
    min = tree->min;
    max = tree->max;

    uint64_t width, msb;
    width = ceil(log2(STUPIDEDI_WAVELET_SYMBOL_MAX));
    msb   = 1 << (width - 1);

    while (min != max)
    {
        if ((a & msb) == 0)
        {
            i    = stupidedi_rrr_rank0(tree->rrr, i);
            max  = min + (max - min) / 2 - 1;
            tree = tree->l;
        }
        else
        {
            i    = stupidedi_rrr_rank1(tree->rrr, i);
            min  = min + (max - min) / 2;
            tree = tree->r;
        }

        a = a << 1;
    }

    return i;
    */
    return 0;

    /* rnk(l, a, i, p)
     *      if wv - av = 1 then
     *          return i - C[a]
     *      end if
     *      if a < 2**(ceil(lg(wv-av)) - 1) then
     *          i <- rank0(Bl, i)
     *      else
     *          i <- zl + rank1(Bl, i)
     *      end if
     *      return rnk(l+1, a, i)
     */

    /*
    while (w[v] - a[v] != 1)
    {
        if (a < 2**(nbits(w[v] - a[v]) - 1))
            i = rrr_rank0(B[l], i);
        else
            i = z[l] + rrr_rank1(B[l], i);

        ++l;
    }

    return i - C[a];
    */
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
    // assert(r != 0);

    return stupidedi_wavelet_select_aux(w, c, r, (1ull << (w->height - 1)));
}

/* Return position of previous occurrence of symbol c from position i. */
size_t
stupidedi_wavelet_prev(const stupidedi_wavelet_t* w, uint64_t c, size_t r)
{
    return 0; /* TODO */
}

/* Return position of next occurrence of symbol c from position i. */
size_t
stupidedi_wavelet_next(const stupidedi_wavelet_t* w, uint64_t c, size_t r)
{
    return 0; /* TODO */
}
