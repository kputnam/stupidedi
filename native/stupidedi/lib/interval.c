#include <stdlib.h>
#include <stdbool.h>
#include "stupidedi/include/builtins.h"
#include "stupidedi/include/interval.h"

/*
 * This performs a binary search on sorted disjoint intervals (sorted by each
 * interval's min). First it finds the largest min that's no larger than the
 * point; then it checks that point doesn't exceed that interval's max.
 *
 * Many queries will require descending all the way to a leaf.  That is because
 * once a `min` is found that is less than the point, we need to find the next
 * smallest `min`.  Doing so amounts to descending to the leftmost leaf of the
 * right subtree of the current `min`.
 *
 *           .---------62----------.
 *      .---14---.           .-----85...
 *   .-08-.    .-31-.     .-70-.
 *  04    10  20    40   67    71
 *
 * For example, if `min` is the tree above and we have a point query for 33,
 * we'll start at 62 and move to 14. While there might be an interval 14..x
 * that contains 33, there could also be 31..x or 20..x.
 *
 * For around 700 intervals (the number of codepoint ranges that cover Unicode
 * graphical characters), about 10 iterations may be required.
 *
 * Something to revisit: http://repnop.org/pd/slides/bsearch.pdf
 */
bool
stupidedi_interval_list_test(const uint32_t point, stupidedi_interval_list_t* tree)
{
    size_t k, l, r, z;

    /* This hack speeds up searches that fall in the range covered by the first
     * few intervals. We first try a short linear search, but if the answer
     * isn't found we'll fallback to a binary search on the remaining intervals.
     *
     * Most queries are expected to be checking if ASCII-range values are
     * graphical or whitespace, which will benefit from this optimization */
    for (k = 0; k < 3 && 3 <= tree->size; ++k)
    {
        if (point <  tree->min[k]) return false;
        if (point <= tree->max[k]) return true;
    }

    /* Perform a binary search on the remaining items */
    for (l = k, r = tree->size - 1, z = -1; k = l + (r - l) / 2, l <= r;)
    {
        if (UNLIKELY(tree->min[k] < point))
            if (point <= tree->max[k])
                return true;      // min[k] < point <= max[k]
            else
                l = (z = k) + 1;  // descend right
        else if (point < tree->min[k])
            r = k - 1;            // descend left
        else
            break;                // min[k] == point <= max[k]
    }

    if (point < tree->min[k])
        k = z;

    if (0 <= k && point <= tree->max[k])
        return true;

    return false;
}
