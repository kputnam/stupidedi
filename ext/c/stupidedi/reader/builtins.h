#ifndef STUPIDEDI_BUILTINS_H_
#define STUPIDEDI_BUILTINS_H_

#define LIKELY(x)   (x)
#define UNLIKELY(x) (x)

#ifdef __GNUC__
#if __GNUC__ >= 3
#undef LIKELY
#undef UNLIKELY
#define LIKELY(x)   (__builtin_expect(!!(x), 1))
#define UNLIKELY(x) (__builtin_expect(!!(x), 0))
#endif
#endif

#endif
