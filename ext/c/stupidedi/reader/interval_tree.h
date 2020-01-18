#ifndef STUPIDEDI_INTERVAL_TREE_
#define STUPIDEDI_INTERVAL_TREE_

struct interval_tree_t {
    unsigned int length;
    unsigned int *min;
    unsigned int *max;
};

typedef struct interval_tree_t interval_tree_t;
bool interval_tree_test(const unsigned int point, interval_tree_t tree);

#endif
