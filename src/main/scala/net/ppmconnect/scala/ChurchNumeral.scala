package net.ppmconnect.scala

/**
 * Basic type-level representation of non-negative integers (natural numbers)
 * @see: http://en.wikipedia.org/wiki/Church_encoding
 */
sealed trait ChurchNumeral {
  /**
   * If this were a "value-level" function:
   *   def match[T](nonZero: T, zero: T): T
   *
   * The implementation would return either the first or second
   * argument, depending on some comparison // @todo
   *
   * This programming style may seem odd, but it's how functions are
   * written in the untyped lambda calculus, which has no built-in
   * primitive types like boolean or integer. Both logic and data
   * are represented as functions.
   */
  type Match[NonZero[N <: ChurchNumeral] <: T, Zero <: T, T] <: T
}

object ChurchNumeral {

  sealed trait Successor[N <: ChurchNumeral] extends ChurchNumeral {
    type Match[NonZero[N <: ChurchNumeral] <: T, IfZero <: T, T] = NonZero[N]
    type Predecessor = N
  }

  sealed trait ChurchZero extends ChurchNumeral {
    type Match[NonZero[N <: ChurchNumeral] <: T, IfZero <: T, T] = IfZero
  }

  /** Converts type-level representation to value-level
   *    eg: implicitly[Representation[n30]].n //= 30
   */
  implicit def representation0: Representation[n0] = new Representation[n0](0)
  implicit def representationN[N <: ChurchNumeral](implicit r: Representation[N]): Representation[Successor[N]] = r.succ
  final class Representation[N <: ChurchNumeral](val n: Int) { def succ: Representation[Successor[N]] = new Representation[Successor[N]](n + 1) }

  type n0  = ChurchZero
  type n1  = Successor[n0]
  type n2  = Successor[n1]
  type n3  = Successor[n2]
  type n4  = Successor[n3]
  type n5  = Successor[n4]
  type n6  = Successor[n5]
  type n7  = Successor[n6]
  type n8  = Successor[n7]
  type n9  = Successor[n8]
  type n10 = Successor[n9]
  type n11 = Successor[n10]
  type n12 = Successor[n11]
  type n13 = Successor[n12]
  type n14 = Successor[n13]
  type n15 = Successor[n14]
  type n16 = Successor[n15]
  type n17 = Successor[n16]
  type n18 = Successor[n17]
  type n19 = Successor[n18]
  type n20 = Successor[n19]
  type n21 = Successor[n20]
  type n22 = Successor[n21]
  type n23 = Successor[n22]
  type n24 = Successor[n23]
  type n25 = Successor[n24]
  type n26 = Successor[n25]
  type n27 = Successor[n26]
  type n28 = Successor[n27]
  type n29 = Successor[n28]
  type n30 = Successor[n29]
  type n31 = Successor[n30]
  type n32 = Successor[n31]
  type n33 = Successor[n32]
  type n34 = Successor[n33]
  type n35 = Successor[n34]
  type n36 = Successor[n35]
  type n37 = Successor[n36]
  type n38 = Successor[n37]
  type n39 = Successor[n38]
  type n40 = Successor[n39]
  type n41 = Successor[n40]
  type n42 = Successor[n41]
  type n43 = Successor[n42]
  type n44 = Successor[n43]
  type n45 = Successor[n44]
  type n46 = Successor[n45]
  type n47 = Successor[n46]
  type n48 = Successor[n47]
  type n49 = Successor[n48]
  type n50 = Successor[n49]
  type n51 = Successor[n50]
  type n52 = Successor[n51]
  type n53 = Successor[n52]
  type n54 = Successor[n53]
  type n55 = Successor[n54]
  type n56 = Successor[n55]
  type n57 = Successor[n56]
  type n58 = Successor[n57]
  type n59 = Successor[n58]
  type n60 = Successor[n59]
  type n61 = Successor[n60]
  type n62 = Successor[n61]
  type n63 = Successor[n62]
  type n64 = Successor[n63]
  type n65 = Successor[n64]
  type n66 = Successor[n65]
  type n67 = Successor[n66]
  type n68 = Successor[n67]
  type n69 = Successor[n68]
  type n70 = Successor[n69]
  type n71 = Successor[n70]
  type n72 = Successor[n71]
  type n73 = Successor[n72]
  type n74 = Successor[n73]
  type n75 = Successor[n74]
  type n76 = Successor[n75]
  type n77 = Successor[n76]
  type n78 = Successor[n77]
  type n79 = Successor[n78]
  type n80 = Successor[n79]
  type n81 = Successor[n80]
  type n82 = Successor[n81]
  type n83 = Successor[n82]
  type n84 = Successor[n83]
  type n85 = Successor[n84]
  type n86 = Successor[n85]
  type n87 = Successor[n86]
  type n88 = Successor[n87]
  type n89 = Successor[n88]
  type n90 = Successor[n89]
  type n91 = Successor[n90]
  type n92 = Successor[n91]
  type n93 = Successor[n92]
  type n94 = Successor[n93]
  type n95 = Successor[n94]
  type n96 = Successor[n95]
  type n97 = Successor[n96]
  type n98 = Successor[n97]
  type n99 = Successor[n98]
}
