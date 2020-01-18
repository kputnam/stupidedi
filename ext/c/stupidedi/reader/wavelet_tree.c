#include <stdbool.h>
#include "wavelet_tree.h"

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

typedef char rrr_t;

void
rrr_sequence_rank(rrr_t sequence, bool symbol, int position) {
}

void
rrr_sequence_select(rrr_t sequence, bool symbol, int rank) {
}

void
wavelet_tree_rank(int symbol, int position) {
}

void
wavelet_tree_select(int symbol, int rank) {
}

void
wavelet_tree_access(int position) {
}
