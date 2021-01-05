
Stupidedi represents strings using a pointerless Huffman-shaped wavelet tree.
This allows very efficient tokenization, as finding the next delimiter can be
done in constant time. It also provides compression to fit large inputs in
memory, and doesn't require decompression to access and operate on them.

## Wavelet Tree

A wavelet tree *w* is a data structure that represents a sequence S over the
values or symbols 1..𝜎, and supports three operations:

* _access(w, i)_: returns S[i].
* _rank(w, a, i):_ returns the number of occurrences of the symbol *a* in S[1, i].
* _select(w, a, r):_ returns the position in S of the *r*-th occurrence of symbol *a*.

In relatively simple implementations, these operations have a time complexity
of O(log 𝜎). With some optimizations that depend on the entropy in S, this can
be further improved to O(H₀(S) + 1), which means increasing skew between 1s and
0s bits requires fewer steps to perform the operations.

Wavelet trees are balanced binary trees with 𝜎-1 internal nodes and 𝜎 leaf
nodes. The root node represents the full alphabet and the sequence S. Each
child node corresponds to one half of the parent's alphabet and the subsequence
that contains only those symbols. Internal nodes have a bitmap that encodes
which half of the alphabet each element of the subsequence belongs. The
sequence and the alphabet are partitioned recursively until reaching a single
symbol at a leaf node.

## Wavelet Matrix

A simple implementation of a wavelet tree might have a tree structure that has
a pointer to its left and right subtrees. As a wavelet tree has 𝜎-1 internal
nodes, these pointers consume considerable overhead.

This overhead can be reduced by concatenating all the nodes at a given level.
This is called a wavelet matrix, and it requires only one pointer for each level
in the tree, which is O(log 𝜎) levels. This still requires overhead, because we
still need to know where each node begins and ends, but it can be stored using
less space than using pointers.

We can further reduce the required space by changing how the alphabet is
partitioned. Previously this was done by sorting the alphabet and cutting at
the middle. If we assign a 0 and 1 to each half, then we can view this as
a fixed-width encoding of each symbol using ⌈lg 𝜎⌉ bits. Suppose we instead
use a variable-width Huffman encoding. This moves frequently occurring symbols
closer to the root, so the level-wise bitmaps become shorter more quickly
(leaves are not represented in the bitmaps), thus requiring less space.

Finally, using the compressed bitmap structure proposed by Ramesh, et al, the
level-wise bitmaps can be compressed.

### Bibliography

* F. Claude, G. Navarro, and A. Ordóñez. The Wavelet Matrix: An Efficient
  Wavelet Tree for Large Alphabets. *Information Systems 47*, pg 15-32, 2015.

## Compressed Bitmap (RRR)

Generally these operations depend on bitmap data structure that represents a
sequence B over the values or symbols {0, 1}, and supports three operations:

* _access(b, i)_: returns B[i].
* _rank(b, a, i):_ returns the number of occurrences of the symbol *a* in S[1, i].
* _select(b, a, r):_ returns the position in S of the *r*-th occurrence of symbol *a*.

Note the only obvious difference between this API and that of the wavelet tree
is that, in this case, the input is limited to sequences over {0, 1} rather
than an arbitrary alphabet.

In a naive implementation based on an array of machine words, *access* would
run in constant time O(1), but *rank* and *select* would be in O(i) and O(r).
That is, the time required would grow linearly as we ask about bits further
from the beginning of the bitmap. However, using some extra space on top of
the bitmap, we can achieve O(1) time on all operations.

We can also compress the *n*-bit string in O(n H₀(B)) bits of space, plus the
overhead mentioned earlier, O(n lg(t)/t) extra space where *t* is a user-chosen
parameter. That means as the bitmap length increases, so does the space
required to represent it; and also, as the skew between 0s and 1s bits
increases, the required space decreases. We can still perform the three
operations without the need to decompress the whole string.

There are exactly (n choose r) bitmaps of length n with r 1-bits. Then the
information theoretic bound on number of bits required to represent this bitmap
is ⌈lg(n choose r)⌉ bits, plus the ⌈lg(n)⌉ + ⌈lg(r)⌉ bits needed to store n and
r. The implementation chosen for this project uses

* `offsets`: nH(B)
* `classes`: n ⌈lg(t + 1)/t⌉
* `marked_ranks`: TODO
* `marked_offsets`: TODO

### Bibliography

* G. Navarro and E. Providel. Fast, Small, Simple Rank/Select on Bitmaps. In *Proc.
  11th International Symposium on Experimental Algorithms (SEA)*, LNCS 7276, pg
  295-306, 2012.
* R. Raman, V. Raman, S. Rao. Succinct Indexable Dictionaries with Applications
  to *k*-ary Trees and Multisets. In *Proc. 13th SODA*, pg 233-242.


## Huffman Model

Many implementations of Huffman coding work in a byte-wise fashion, using
a 8-bit numbers as the alphabet, so 𝜎=256. This wouldn't work for our purposes,
because our input may have more than 256 distinct symbols, and we want to be
able to handle pathological UTF-8 inputs that could have more than a million
distinct symbols. To store codes efficiently, we impose a restriction on the
maximum code length such that it fits within a machine word. While finding an
optimal length-limited encoding is impractical, we can achieve a good
approximation in O(n) time using a technique introduced by Liddel and Moffat.

Using Huffman coding introduces overhead to maintain the model which grows with
the alphabet size and input string length: O(𝜎 log n). However, we can compress
the model itself and reduce the overhead to 𝜎 log²n + O(𝜎 + log²n) bits. This is
achieved by sorting the source symbols that share the same depth in the Huffman
tree, so O(log n) increasing runs are formed in the permutation which maps an
input symbol to its code; being a permutation, the domain and range are integers
from [0..𝜎-1]. Then we use a representation of permutations that take advantage
of those increasing runs.


### Bibliography

* F. Claude, G. Navarro, and A. Ordóñez. Compressing Huffman Models on Large
  Alphabets. In *Proc. 23rd Data Compression Conference (DCC)*, pg 381-390,
  2013.

* M. Liddel and A. Moffat. Length-Restricted Coding Using Modified Probability
  Distributions. In *Proc. 24th Australasian Conference on Computer Science*,
  pg 117-124, 2001.

## Permutations

A permutation 𝛑 over *[n]* is a function that maps values 0..n-1 to other values
from 0..n-1. Permutations have inverses, 𝛑⁻¹(𝛑(i)) = i and 𝛑(𝛑⁻¹(i)) = i. They
can be represented straightforwardly with an array, where the *i*-th index
contains the value of the permutation at *i*. This requires n ⌈log n⌉ of space,
and computing 𝛑(i) can be done in O(1) time. However, computing 𝛑⁻¹(i) takes
O(n) time.

Taking advantage of consecutive strict runs that occur a permutation, e.g.
5 6 7 8 9, the permutation can be compressed to at most 𝝉H(HRuns)(1 + o(1))
+ 2𝝉lg(n/𝝉) + o(n) + O(𝝉 + 𝝆 lg 𝝉), where 𝝆 is the number of runs, 𝝉 is the
number of strict runs, and HRuns is the run lengths of the sequence of the
first element of each run in 𝛑. In this encoding, 𝛑(i) and 𝛑⁻¹(i) can be
computed in O(1 + log 𝝆) time.
