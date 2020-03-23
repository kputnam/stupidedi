#include <assert.h>
#include <stdlib.h>
#include "stupidedi/include/builtins.h"
#include "stupidedi/include/uthash.h"
#include "stupidedi/include/wavelet.h"
#include "stupidedi/include/permutation.h"

/* Peter_Piper_picked_a_peck_of_pickled_peppers$
 * Pee_Pe_ced_a_ec_f_ced_ee$ triprpikpkopiklppprs
 * P_P__a____$ eeecedecfcedee iikkoikl trprpppppprs
 * _______$ PPa cdccd eeeeefeee iikkik ol rrpppppr ts
 *
 * 001010011010110100000100101001101100010110110
 * 0110010111000110101110110 11011100100100011111
 * 10100100000 11101010101011 00001001 100000000001
 * 11111110 001 01001 000001000 001101 10 11000001 10
 */

/* Wavelet Trees - A Survey
 *
 * An interesting aspect of the [49] construction is that besides using Huffman
 * shaped wavelet trees (note that in this case of already compressed bit
 * dictionaries variations in the tree shape does not seem to affect the total
 * space) a frequency based construction is applied where the wavelet tree is
 * built as an optimal Huffman prefix tree not on the frequency of appearance of
 * the symbols, but on the a-priory distribution of the queries on them.
 */

/* Engineering Rank and Select Queries on Wavelet Trees
 *
 * Julian Shun [9] describes various parallelized algorithms for constructing
 * the wavelet tree by utilizing the GPU, achieving up to a 27x speedup over the
 * sequential construction algorithm.
 *
 * If one knows the frequencies of all symbols in the alphabet, without needing
 * it to be exact, then one can build a Huffman shaped Wavelet Tree (described
 * in Section 4.2.4) and we expect it will beat out any balanced wavelet tree in
 * terms of performance. The frequencies can be found by a simple linear scan of
 * the input string before building the tree
 */

/*
 * Binary wavelet trees encode strings as a perfect binary tree of bit vectors
 * which allows O(log |Σ|) time rank and select queries, where Σ is the size of
 * the alphabet. This requires rank and select queries on each bit vector to be
 * answered in O(1) time, which is made possible using RRR sequences.
 *
 * Using ordinary bit vectors would require |S| log |Σ| bits * where |S| is the
 * string length and |Σ| is the number of symbols.
 *
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
 * The tree is defined recursively by first encoding half the alphabet as 0, and
 * the other half as 1. Group the 0-encoded symbols as one subtree and group the
 * 1-encoded symbols as the other subtree. Repeat for each subtree recursively
 * until there is only one symbol left.
 *
 * For more information, see Makris, Christos. (2012). Wavelet trees: A survey.
 * Computer Science and Information Systems. 9. 10.2298/CSIS110606004M.
 */

 /* The Wavelet Matrix - An Efficient Wavelet Tree for Large Alphabets
  *
  * 5. The Compressed Wavelet Matrix
  *
  *
  */

/*static void
huffman_encode_symbol(uint_least64_t symbol)
{
     * To obtain a code from a symbol s, we first apply π⁻¹(s). This returns the
     * position pos in π that contains s, and binary search in sR obtains the
     * length l of the code. Then we return the code c = fst[l] + pos − sR[l].
     * That is, if we know the offset (pos − sR[l]) inside a run and the first
     * code of that run (fst[l]), we know the code associated to s since all
     * codes inside a run are consecutive. For instance, to obtain the code
     * associated with symbol s8 from the Huffman tree of Figure 2, we apply
     * π−1(8) and obtain pos = 4. Binary searching sR we find that the code has
     * length l = 3. Then the code of symbol s8 is fst[l]+pos−sR[l] = 1002 +4−3
     * = 4+4−3 = 5. The time for this encoding operation is O(log log n), both
     * for computing π⁻¹ (with a downward traversal on the wavelet tree used to
     * represent the inverse of π [1]) and for binary searching sR.
     *
}*/

/*static void
huffman_decode_symbol(uint_least64_t code)
{
     * To obtain the symbol corresponding to a code c of length l we do the
     * inverse process. We compute π[pos], for pos = c − fst[l] + sR[l]. For
     * instance, to obtain the symbol associated to code c = 1012 of length l =
     * 3, we compute pos = 1012 − fst [3] + sR[3] = 1012 − 1002 + 3 = 4, and
     * then return π[4] = s8. The time complexity is also O(loglogn), dominated
     * by the time to compute π[pos] (recall that this is done via an upward
     * traversal on the wavelet tree used to represent the inverse of π [1]).
     *
}*/

stupidedi_wavelet_t*
stupidedi_wavelet_alloc_aux(stupidedi_bitmap_t* sequence, stupidedi_bit_idx_t size, uint_least64_t min, uint_least64_t max)
{
    if (min >= max)
        return NULL;

    stupidedi_wavelet_t* tree;
    tree = malloc(sizeof(stupidedi_wavelet_t));
    tree->alpha = min;
    tree->omega = max;
    tree->rrr   = NULL;
    tree->l     = NULL;
    tree->r     = NULL;

    stupidedi_rrr_builder_t* rrr_;
    rrr_ = stupidedi_rrr_builder_alloc(63, 512, size, NULL, NULL);

    uint_least64_t mid;
    mid    = min + (max - min) / 2;

    stupidedi_bit_idx_t nleft, nright;
    nleft  = 0;
    nright = 0;

    for (stupidedi_bit_idx_t k = 0; k < stupidedi_bitmap_size(sequence); ++k)
    {
        uint_least64_t c = stupidedi_bitmap_read_record(sequence, k);

        if (c < min || c > max)
            continue;

        if (c < mid)
        {
            stupidedi_rrr_builder_append(rrr_, 1, 0);
            ++nleft;
        }
        else
        {
            stupidedi_rrr_builder_append(rrr_, 1, 1);
            ++nright;
        }
    }

    tree->rrr = stupidedi_rrr_builder_build(rrr_);
    stupidedi_rrr_builder_free(rrr_);

    tree->l = stupidedi_wavelet_alloc_aux(sequence, nleft, min, mid-1);
    tree->r = stupidedi_wavelet_alloc_aux(sequence, nright, mid, max);

    return tree;
}

/* TODO */
stupidedi_wavelet_t*
stupidedi_wavelet_alloc(stupidedi_bitmap_t* sequence, stupidedi_wavelet_t* tree)
{
    assert(sequence != NULL);
    assert(sequence->width > 0);

    tree = stupidedi_wavelet_alloc_aux(sequence, stupidedi_bitmap_size(sequence), 0, 255);
    return tree;
}

/* TODO */
void
stupidedi_wavelet_free(stupidedi_wavelet_t* tree)
{
    return;
}

/* TODO */
void
stupidedi_wavelet_print(const stupidedi_wavelet_t* tree)
{
    return;
}

/* TODO */
stupidedi_wavelet_idx_t
stupidedi_wavelet_size(const stupidedi_wavelet_t* tree)
{
    return 0UL;
}

/* TODO */
size_t
stupidedi_wavelet_sizeof(const stupidedi_wavelet_t* tree)
{
    return sizeof(tree) + ((stupidedi_wavelet_sizeof_bits(tree) + 7) >> 3);
}

/* TODO */
uint_least64_t
stupidedi_wavelet_sizeof_bits(const stupidedi_wavelet_t* tree)
{
    return 0ULL;
}

/* access(S, i) = S[i] */
stupidedi_wavelet_symbol_t
stupidedi_wavelet_access(stupidedi_wavelet_t* tree, stupidedi_wavelet_idx_t i)
{
    stupidedi_wavelet_symbol_t min, max;
    min = tree->alpha;
    max = tree->omega;

    while (min != max)
    {
        if (stupidedi_rrr_access(tree->rrr, i))
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
    }

    return min;

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

/* rank(S, a, i) = |{j ∈ [0, i) : S[j] = a}| */
stupidedi_wavelet_idx_t
stupidedi_wavelet_rank(const stupidedi_wavelet_t* tree, stupidedi_wavelet_symbol_t a, stupidedi_wavelet_idx_t i)
{
    stupidedi_wavelet_symbol_t min, max;
    min = tree->alpha;
    max = tree->omega;

    uint_least64_t width, msb;
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

stupidedi_wavelet_idx_t
stupidedi_wavelet_select_aux(
        const stupidedi_wavelet_t* tree,
        stupidedi_wavelet_symbol_t c,
        stupidedi_wavelet_idx_t r,
        uint_least64_t mask)
{
    if (tree == NULL || mask == 0)
        return r;

    return (c & mask) == 0 ?
        stupidedi_rrr_select0(tree->rrr, stupidedi_wavelet_select_aux(tree->l, c, r, mask >> 1)) :
        stupidedi_rrr_select1(tree->rrr, stupidedi_wavelet_select_aux(tree->r, c, r, mask >> 1));
}

/* select1(S, i, a) = max{j ∈ [0, n) | rank(j, a) = i} */
stupidedi_wavelet_idx_t
stupidedi_wavelet_select(const stupidedi_wavelet_t* tree, stupidedi_wavelet_symbol_t c, stupidedi_wavelet_idx_t r)
{
    uint_least64_t width, mask;
    width = ceil(log2(STUPIDEDI_WAVELET_SYMBOL_MAX));
    mask  = 1 << (width - 1);

    return stupidedi_wavelet_select_aux(tree, c, r, mask);
}

/* Return position of previous occurrence of symbol c from position i. */
stupidedi_wavelet_idx_t
stupidedi_wavelet_prev(const stupidedi_wavelet_t* tree, stupidedi_wavelet_symbol_t c, stupidedi_wavelet_idx_t r)
{
    return 0;
}

/* Return position of next occurrence of symbol c from position i. */
stupidedi_wavelet_idx_t
stupidedi_wavelet_next(const stupidedi_wavelet_t* tree, stupidedi_wavelet_symbol_t c, stupidedi_wavelet_idx_t r)
{
    return 0;
}
