#ifndef STUPIDEDI_RB_TYPES_H_
#define STUPIDEDI_RB_TYPES_H_ 1

#include <ruby.h>
#include <stdlib.h>

typedef void (*dfree_t)(void*);
typedef size_t (*dsize_t)(const void*);

extern const rb_data_type_t rb_bit_vector_t;
extern const rb_data_type_t rb_rrr_t;
extern const rb_data_type_t rb_rrr_builder_t;
extern const rb_data_type_t rb_wavelet_tree_t;

#endif
