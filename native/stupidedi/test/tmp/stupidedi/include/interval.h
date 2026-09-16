#ifndef STUPIDEDI_INTERVAL_H_
#define STUPIDEDI_INTERVAL_H_

#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct stupidedi_interval_list_t
{
    size_t length;
    uint64_t* min;
    uint64_t* max;
} stupidedi_interval_list_t;

/* This performs a binary search on sorted disjoint intervals (sorted by each
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
stupidedi_interval_test(stupidedi_interval_list_t* tree, const uint64_t point);

#endif
