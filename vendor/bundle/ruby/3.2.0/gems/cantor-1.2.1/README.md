# Cantor [![Build Status](https://secure.travis-ci.org/kputnam/cantor.png)](http://travis-ci.org/kputnam/cantor)

Fast implementation of finite and complement sets in Ruby

## Constructors

##### `Cantor.empty`
Finite set that contains no elements

##### `Cantor.build(enum)`
Finite set containing each element in `enum`, whose domain of discourse
is unrestricted
  
##### `Cantor.absolute(enum, universe)`
Finite set containing each element in `enum`, whose domain of discourse
is `universe`
  
##### `Cantor.universal`
Infinite set containing every value in the universe
  
##### `Cantor.complement(enum)`
Set containing every value except those in `enum`. Finite when `enum` is
infinite. Infinite when `enum` is finite

## Operations

* `xs.include?(x)`
* `xs.exclude?(x)`
* `xs.finite?`
* `xs.infinite?`
* `xs.empty?`
* `xs.size`
* `xs.replace(ys)`
* `~xs`
* `xs.complement`
* `xs + xs`
* `xs | ys`
* `xs.union(ys)`
* `xs - ys`
* `xs.difference(ys)`
* `xs ^ ys`
* `xs.symmetric_difference(ys)`
* `xs & ys`
* `xs.intersection(ys)`
* `xs <= ys`
* `xs.subset?(ys)`
* `xs < ys`
* `xs.proper_subset?(ys)`
* `xs >= ys`
* `xs.superset?(ys)`
* `xs > ys`
* `xs.proper_superset?(ys)`
* `xs.disjoint?(ys)`
* `xs == ys`

## Performance

Sets with a finite domain of discourse are represented using a bit string of
2<sup>U</sup> bits, where U is the size of the domain. This provides nearly
O(1) constant-time implementation using bitwise operations for all of the above
set operations.

The bit string is represented as an Integer, but as the domain grows larger
than `0.size * 8 - 2` items, the type is automatically expanded to a Bignum.
Bitwise operations on Bignums are O(U), which is still be significantly
faster than using the default Set library.

Sets with an unrestricted domain of discourse are implemented using a Hash.
Unary operations and membership tests are O(1) constant-time. Binary operations
on these sets is close to that of the default Set library.

### Benchmarks

These benchmarks aren't intended to be useful. While they indicate the
worst-case performance for Cantor, they probably don't show the worst
case for the standard Set library.

Note "Relative" indicates Cantor sets with an infinite domain of discourse.
This includes `Cantor.build`, `Cantor.universal`, and `Cantor.complement`.
"Absolute" sets are Cantor sets with a finite domain of discourse, built
from `Cantor.absolute`.

<table>
  <tbody>
    <tr>
      <td><img title="intersection" src="/benchmark/intersection.png"/></td>
      <td><img title="difference" src="/benchmark/difference.png"/></td>
    </tr>
    <tr>
      <td><img title="union" src="/benchmark/union.png"/></td>
      <td><img title="symmetric difference" src="/benchmark/sdifference.png"/></td>
    </tr>
    <tr>
      <td><img title="subset" src="/benchmark/subset.png"/></td>
      <td><img title="superset" src="/benchmark/superset.png"/></td>
    </tr>
    <tr>
      <td><img title="equality" src="/benchmark/equality.png"/></td>
      <td><img title="membership" src="/benchmark/membership.png"/></td>
    </tr>
  </tbody>
</table>
