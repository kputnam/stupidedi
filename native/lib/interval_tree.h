#ifndef STUPIDEDI_INTERVAL_TREE_
#define STUPIDEDI_INTERVAL_TREE_

typedef struct interval_tree_t {
    unsigned int size;
    unsigned int* min;
    unsigned int* max;
} interval_tree_t;

bool interval_tree_test(const unsigned int point, interval_tree_t tree);

#endif
