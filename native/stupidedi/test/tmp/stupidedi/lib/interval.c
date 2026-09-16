#include <stdlib.h>
#include <stdbool.h>
#include "stupidedi/include/builtins.h"
#include "stupidedi/include/interval.h"

bool
stupidedi_interval_test(stupidedi_interval_list_t* tree, const uint64_t point)
{
    size_t k, lo, hi, z;

    /* This hack speeds up searches that fall in the range covered by the first
     * few intervals. We first try a short linear search, but if the answer
     * isn't found we'll fallback to a binary search on the remaining intervals.
     *
     * Most queries are expected to be checking if ASCII-range values are
     * graphical or whitespace, which will benefit from this optimization */
    for (k = 0; k < 3 && 3 <= tree->length; ++k)
    {
        if (point <  tree->min[k]) return false;
        if (point <= tree->max[k]) return true;
    }

    /* Perform a binary search on the remaining items */
    for (lo = k, hi = tree->length - 1, z = -1; k = lo + (hi - lo) / 2, lo <= hi;)
    {
        if (tree->min[k] < point)
            if (point <= tree->max[k])
                return true;      // min[k] < point <= max[k]
            else
                lo = (z = k) + 1;  // descend right
        else if (point < tree->min[k])
            hi = k - 1;            // descend left
        else
            break;                // min[k] == point <= max[k]
    }

    if (point < tree->min[k])
        k = z;

    if (0 <= k && point <= tree->max[k])
        return true;

    return false;
}
