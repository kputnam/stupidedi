package net.ppmconnect.scala

/**
 * Heterogenously typed list (compared to the usual homogenously typed lists,
 * which models lists where each element is of the same type).
 */
object HList {

  type ::[Head, Tail <: HList] = HCons[Head, Tail]

  val HNil = new HNil

  /**
   * HCons is a case class that provides deconstructor pattern matching via
   * something like HCons.unapply[H, T](as: HCons[H, T) = Some(as.head, as.tail).
   *
   * This alias lets us write prettier pattern matching syntax, like
   *   (1 :: 2 :: HNil) match { x :: y :: tail => y }
   */
  val :: = HCons

  /** Converts a product (eg, TupleN) to an hlist, preserving type information */
  def fromProduct[A](p: Product1[A]) = p._1 :: HNil
  def fromProduct[A, B](p: (A, B)) = p._1 :: p._2 :: HNil
  def fromProduct[A, B, C](p: (A, B, C)) = p._1 :: p._2 :: p._3 :: HNil
  def fromProduct[A, B, C, D](p: (A, B, C, D)) = p._1 :: p._2 :: p._3 :: p._4 :: HNil
  def fromProduct[A, B, C, D, E](p: (A, B, C, D, E)) = p._1 :: p._2 :: p._3 :: p._4 :: p._5 :: HNil
  def fromProduct[A, B, C, D, E, F](p: (A, B, C, D, E, F)) = p._1 :: p._2 :: p._3 :: p._4 :: p._5 :: p._6 :: HNil
  def fromProduct[A, B, C, D, E, F, G](p: (A, B, C, D, E, F, G)) = p._1 :: p._2 :: p._3 :: p._4 :: p._5 :: p._6 :: p._7 :: HNil
  def fromProduct[A, B, C, D, E, F, G, H](p: (A, B, C, D, E, F, G, H)) = p._1 :: p._2 :: p._3 :: p._4 :: p._5 :: p._6 :: p._7 :: p._8 :: HNil
  def fromProduct[A, B, C, D, E, F, G, H, I](p: (A, B, C, D, E, F, G, H, I)) = p._1 :: p._2 :: p._3 :: p._4 :: p._5 :: p._6 :: p._7 :: p._8 :: p._9 :: HNil
  def fromProduct[A, B, C, D, E, F, G, H, I, J](p: (A, B, C, D, E, F, G, H, I, J)) = p._1 :: p._2 :: p._3 :: p._4 :: p._5 :: p._6 :: p._7 :: p._8 :: p._9 :: p._10 :: HNil
  def fromProduct[A, B, C, D, E, F, G, H, I, J, K](p: (A, B, C, D, E, F, G, H, I, J, K)) = p._1 :: p._2 :: p._3 :: p._4 :: p._5 :: p._6 :: p._7 :: p._8 :: p._9 :: p._10 :: p._11 :: HNil
  def fromProduct[A, B, C, D, E, F, G, H, I, J, K, L](p: (A, B, C, D, E, F, G, H, I, J, K, L)) = p._1 :: p._2 :: p._3 :: p._4 :: p._5 :: p._6 :: p._7 :: p._8 :: p._9 :: p._10 :: p._11 :: p._12 :: HNil
  def fromProduct[A, B, C, D, E, F, G, H, I, J, K, L, M](p: (A, B, C, D, E, F, G, H, I, J, K, L, M)) = p._1 :: p._2 :: p._3 :: p._4 :: p._5 :: p._6 :: p._7 :: p._8 :: p._9 :: p._10 :: p._11 :: p._12 :: p._13 :: HNil
  def fromProduct[A, B, C, D, E, F, G, H, I, J, K, L, M, N](p: (A, B, C, D, E, F, G, H, I, J, K, L, M, N)) = p._1 :: p._2 :: p._3 :: p._4 :: p._5 :: p._6 :: p._7 :: p._8 :: p._9 :: p._10 :: p._11 :: p._12 :: p._13 :: p._14 :: HNil
  def fromProduct[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O](p: (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)) = p._1 :: p._2 :: p._3 :: p._4 :: p._5 :: p._6 :: p._7 :: p._8 :: p._9 :: p._10 :: p._11 :: p._12 :: p._13 :: p._14 :: p._15 :: HNil
  def fromProduct[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P](p: (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)) = p._1 :: p._2 :: p._3 :: p._4 :: p._5 :: p._6 :: p._7 :: p._8 :: p._9 :: p._10 :: p._11 :: p._12 :: p._13 :: p._14 :: p._15 :: p._16 :: HNil
  def fromProduct[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q](p: (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)) = p._1 :: p._2 :: p._3 :: p._4 :: p._5 :: p._6 :: p._7 :: p._8 :: p._9 :: p._10 :: p._11 :: p._12 :: p._13 :: p._14 :: p._15 :: p._16 :: p._17 :: HNil
  def fromProduct[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R](p: (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)) = p._1 :: p._2 :: p._3 :: p._4 :: p._5 :: p._6 :: p._7 :: p._8 :: p._9 :: p._10 :: p._11 :: p._12 :: p._13 :: p._14 :: p._15 :: p._16 :: p._17 :: p._18 :: HNil
  def fromProduct[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S](p: (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)) = p._1 :: p._2 :: p._3 :: p._4 :: p._5 :: p._6 :: p._7 :: p._8 :: p._9 :: p._10 :: p._11 :: p._12 :: p._13 :: p._14 :: p._15 :: p._16 :: p._17 :: p._18 :: p._19 :: HNil
  def fromProduct[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T](p: (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)) = p._1 :: p._2 :: p._3 :: p._4 :: p._5 :: p._6 :: p._7 :: p._8 :: p._9 :: p._10 :: p._11 :: p._12 :: p._13 :: p._14 :: p._15 :: p._16 :: p._17 :: p._18 :: p._19 :: p._20 :: HNil
  def fromProduct[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U](p: (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)) = p._1 :: p._2 :: p._3 :: p._4 :: p._5 :: p._6 :: p._7 :: p._8 :: p._9 :: p._10 :: p._11 :: p._12 :: p._13 :: p._14 :: p._15 :: p._16 :: p._17 :: p._18 :: p._19 :: p._20 :: p._21 :: HNil
  def fromProduct[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V](p: (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)) = p._1 :: p._2 :: p._3 :: p._4 :: p._5 :: p._6 :: p._7 :: p._8 :: p._9 :: p._10 :: p._11 :: p._12 :: p._13 :: p._14 :: p._15 :: p._16 :: p._17 :: p._18 :: p._19 :: p._20 :: p._21 :: p._22 :: HNil

  /** @todo: This is practically useless, since the return type is too vague
  def fromTraversable[T](t: Traversable[T]): HList =
    t.foldRight(HNil: HList)((item, hlist) => HCons(item, hlist))
  */

  sealed trait HList {
    type Head
    type Tail <: HList

    def isEmpty: Boolean
    def nonEmpty: Boolean = !isEmpty

    /** Prepends an element a onto the hlist */
    def prepend[A](a: A): Prepend[A]  // hlist prepend a
    def cons[A](a: A) = prepend(a)    // hlist cons a
    def ::[A](a: A) = prepend(a)      // a :: hlist
    def +:[A](a: A) = prepend(a)      // a +: hlist
    type Prepend[A] <: HList

    /** Merges the given hlist onto the front of this hlist */
    def concat[A <: HList](as: A): Concat[A]                // as concat bs
    def ++[A <: HList](as: A) = concat(as)                  // as ++ bs
    type Concat[A <: HList] <: HList
    // @todo def :::(as) = as.concat(this)

    /** Applies a binary operator to a start value and all elements of this list, from right to left */
    def foldRight[Value, F <: Fold[Any, Value], I <: Value](f: F, i: I): FoldRight[Value, F, I]
    def \:[Value, F <: Fold[Any, Value], I <: Value](f: F, i: I) = foldRight[Value, F, I](f, i)
    type FoldRight[Value, F <: Fold[Any, Value], I <: Value] <: Value

    /** Applies a binary operator to a start value and all elements of this list, from left to right */
    def foldLeft[Value, F <: Fold[Any, Value], I <: Value](f: F, i: I): FoldLeft[Value, F, I]
    def /:[Value, F <: Fold[Any, Value], I <: Value](f: F, i: I) = foldLeft[Value, F, I](f, i)
    type FoldLeft[Value, F <: Fold[Any, Value], I <: Value] <: Value

    def reverse = foldLeft[HList, HConsFold, HNil](HConsFold, HNil)
    type Reverse[A <: HList] = A#FoldLeft[HList, HConsFold, HNil]

    type ToZipper[N <: ChurchNumeral] <: Zipper
  }

  /** The base-case for the recursive definition of a list: the empty list */
  final class HNil extends HList with HListOps {
    type Head = Nothing
    type Tail = Nothing

    type This = HNil
    def self = this

    def isEmpty = true

    def prepend[A](a: A) = HCons(a, this)
    type Prepend[A] = A :: HNil

    def concat[A <: HList](as: A) = as
    type Concat[A <: HList] = A

    def foldRight[Value, F <: Fold[Any, Value], I <: Value](f: F, i: I) = i
    type FoldRight[Value, F <: Fold[Any, Value], I <: Value] = I

    def foldLeft[Value, F <: Fold[Any, Value], I <: Value](f: F, i: I) = i
    type FoldLeft[Value, F <: Fold[Any, Value], I <: Value] = I

    type ToZipper[N <: ChurchNumeral] = Nothing

    override def toString = "HNil"
  }

  /** The non-base case for the recursive definition of a list: one element and the rest of the list that follows it */
  final case class HCons[H, T <: HList](head: H, tail: T) extends HList with HListOps {
    type Head = H
    type Tail = T

    type This = Head :: Tail
    def self = this

    def isEmpty = false

    def prepend[A](a: A) = HCons(a, this)
    type Prepend[A] = A :: This // equivalent to HCons[A, HCons[Head, Tail]]

    def concat[A <: HList](as: A) = HCons(head, tail ++ as)
    type Concat[A <: HList] = HCons[Head, Tail#Concat[A]]

    def foldRight[Value, F <: Fold[Any, Value], I <: Value](f: F, i: I): FoldRight[Value, F, I] = f(head, tail.foldRight[Value, F, I](f, i))
    type FoldRight[Value, F <: Fold[Any, Value], I <: Value] = F#Apply[Head, tail.FoldRight[Value, F, I]]

    def foldLeft[Value, F <: Fold[Any, Value], I <: Value](f: F, i: I): FoldLeft[Value, F, I] = tail.foldLeft[Value, F, F#Apply[Head, I]](f, f(head, i))
    type FoldLeft[Value, F <: Fold[Any, Value], I <: Value] = tail.FoldLeft[Value, F, F#Apply[Head, I]]

    type ToZipper[N <: ChurchNumeral] = N#Match[PrevZipper, Zipper0[Head, Tail], Zipper]
    type PrevZipper[M <: ChurchNumeral] = ZipperN[Head, tail.ToZipper[M]]

    override def toString = head.toString + " :: " + tail.toString
  }

  trait Fold[-Elem, Value] {
    def apply[N <: Elem, Accumulator <: Value](n: N, accumulator: Accumulator): Apply[N, Accumulator]
    type Apply[N <: Elem, Accumulator <: Value] <: Value
  }

  object HConsFold extends HConsFold
  trait HConsFold extends Fold[Any, HList] {
    def apply[N, Accumulator <: HList](n: N, accumulator: Accumulator) = HCons(n, accumulator)
    type Apply[N <: Any, Accumulator <: HList] = N :: Accumulator
  }

  object Zipper {
    implicit def zipper0[H, T <: HList](as: H :: T) = new Zipper0[H, T](as)
    implicit def zipperN[H, T <: HList, Tz <: Zipper](as: H :: T)(implicit tail: T => Tz): ZipperN[H, Tz] = new ZipperN[H, Tz](as.head, tail(as.tail))
  }

  /** Operations that are defined in terms of their position within the hlist */
  sealed trait Zipper {
    type Before <: HList  // type of the hlist before the indexed position
    type After  <: HList  // type of the hlist after the indexed position
    type At               // type of the value at the indexed position

    def withIndex[R](f: (Before, At, After) => R): R

    /** Get the item at this index */
    def at = withIndex((before, at, after) => at)

    /** Drop all the items before this index */
    def drop = withIndex((before, at, after) => at :: after)

    /** Take all the items before this index */
    def take = withIndex((before, at, after) => before)

    /** Replace the item at this index with given value */
    def replace[A](x: A) = withIndex((before, at, after) => before ++ (x :: after))

    /** Remove the item at this index */
    def remove = withIndex((before, at, after) => before ++ after)

    /** Replace the item at this index with the result of applying f to it */
    def map[B](f: At => B) = withIndex((before, at, after) => before ++ (f(at) :: after))

    /** Replace the item at this index with the hlist result of applying f to it */
    def flatMap[B <: HList](f: At => B) = withIndex((before, at, after) => before ++ f(at) ++ after)

    /** Insert the given value at this index */
    def insert[A](x: A) = withIndex((before, at, after) => before ++ (x :: at :: after))

    /** Insert the given hlist at this index */
    def merge[A <: HList](x: A) = withIndex((before, at, after) => before ++ x ++ (at :: after))

    /** Return the hlist before this index and the hlist starting at this index */
    def splitAt = withIndex((before, at, after) => (before, at :: after))
  }

  /** The zipper positioned at the first element of an hlist
   *  @tparam H   type of hlist's head
   *  @tparam T   type of the rest of the hlist
   */
  final class Zipper0[H, T <: HList](val hlist: H :: T) extends Zipper {
    type Before = HNil
    type After  = T
    type At     = H
    def withIndex[R](f: (Before, At, After) => R): R = f(HNil, hlist.head, hlist.tail)
  }

  /** Zipper positioned at an index greater than zero
   *  @tparam H   ...
   *  @tparam Z   the zipper positined at the preceeding index
   */
  final class ZipperN[H, Z <: Zipper](val head: H, tail: Z) extends Zipper {
    type Before = H :: Z#Before
    type After  = Z#After
    type At     = Z#At
    def withIndex[R](f: (Before, At, After) => R): R = tail.withIndex((before, at, after) => f(HCons(head, before), at, after))
  }

  /** List-level operations common to both HNil and HCons, but not to generic HList */
  trait HListOps {
    import HListOps._

    type This <: HList
    def self: This

    /** Combines this hlist with another into a single hlist of pairs with corresponding elements */
    def zip[A <: HList, Result <: HList](as: A)(implicit hzip: HZip2[This, A, Result]): Result = hzip(self, as)

    /** Combines this hlist with two others into a single hlist of 3-tuples with corresponding elements */
    def zip[A <: HList, B <: HList, Result <: HList](as: A, bs: B)(implicit hzip: HZip3[This, A, B, Result]): Result = hzip(self, as, bs)

    /** Combines this hlist with three others into a single hlist of 4-tuples with corresponding elements */
    def zip[A <: HList, B <: HList, C <: HList, Result <: HList](as: A, bs: B, cs: C)(implicit hzip: HZip4[This, A, B, C, Result]): Result = hzip(self, as, bs, cs)

    /** Separates an hlist of pairs into two corresponding hlists */
    def unzip2[A <: HList, B <: HList](implicit hunzip: HUnzip2[A, B, This]) = hunzip(self)

    /** Separates an hlist of 3-tuples into three corresponding hlists */
    def unzip3[A <: HList, B <: HList, C <: HList](implicit hunzip: HUnzip3[A, B, C, This]) = hunzip(self)

    /** Separates an hlist of 4-tuples into four corresponding hlists */
    def unzip4[A <: HList, B <: HList, C <: HList, D <: HList](implicit hunzip: HUnzip4[A, B, C, D, This]) = hunzip(self)

    /** Applies an hlist of functions to an hlist of corresponding inputs, producing an hlist of results */
    def apply[In <: HList, Out <: HList](values: In)(implicit happly: This => In => Out): Out = happly(self)(values)

    /** Return the Zipper for the given index */
    def index[N <: ChurchNumeral](implicit zipper: This => This#ToZipper[N]) = zipper(self)

    /** Convert to a ProductN type */
    def toProduct[Result <: Product](implicit toProduct: ToProduct[This, Result]) = toProduct(self)

    /** @todo: Convert to an array */
    //def toArray[A](implicit m: ClassManifest[A]) = null

    /** @todo: Convert to a traversable */
    //def toTraversable[CC, T <: Traversable[CC]] = null
  }

  /** Companion object that defines the needed implicits for HListOps methods */
  object HListOps {
    sealed trait HZip2[A <: HList, B <: HList, Result <: HList] { def apply(as: A, bs: B): Result }
    implicit def hzip2Nil = new HZip2[HNil, HNil, HNil] { def apply(as: HNil, bs: HNil) = HNil }
    implicit def hzip2NilBs[H, T <: HList] = new HZip2[H :: T, HNil, HNil] { def apply(as: H :: T, bs: HNil) = HNil }
    implicit def hzip2AsNil[H, T <: HList] = new HZip2[HNil, H :: T, HNil] { def apply(as: HNil, bs: H :: T) = HNil }
    implicit def hzip2Cons[A, B, As <: HList, Bs <: HList, Tr <: HList](implicit hzipTail: HZip2[As, Bs, Tr]) =
      new HZip2[A :: As, B :: Bs, (A, B) :: Tr] { def apply(as: A :: As, bs: B :: Bs) = HCons((as.head, bs.head), hzipTail(as.tail, bs.tail)) }

    sealed trait HZip3[A <: HList, B <: HList, C <: HList, Result <: HList] { def apply(as: A, bs: B, cs: C): Result }
    implicit def hzip3Nil = new HZip3[HNil, HNil, HNil, HNil] { def apply(as: HNil, bs: HNil, cs: HNil) = HNil }
    implicit def hzip3AsNil[H, T <: HList] = new HZip3[H :: T, HNil, HNil, HNil] { def apply(as: H :: T, bs: HNil, cs: HNil) = HNil }
    implicit def hzip3BsNil[H, T <: HList] = new HZip3[HNil, H :: T, HNil, HNil] { def apply(as: HNil, bs: H :: T, cs: HNil) = HNil }
    implicit def hzip3CsNil[H, T <: HList] = new HZip3[HNil, HNil, H :: T, HNil] { def apply(as: HNil, bs: HNil, cs: H :: T) = HNil }
    implicit def hzip3AsBsNil[A, As <: HList, B, Bs <: HList] = new HZip3[A :: As, B :: Bs, HNil, HNil] { def apply(as: A :: As, bs: B :: Bs, cs: HNil) = HNil }
    implicit def hzip3BsCsNil[B, Bs <: HList, C, Cs <: HList] = new HZip3[HNil, B :: Bs, C :: Cs, HNil] { def apply(as: HNil, bs: B :: Bs, cs: C :: Cs) = HNil }
    implicit def hzip3Cons[A, B, C, As <: HList, Bs <: HList, Cs <: HList, Tr <: HList](implicit hzipTail: HZip3[As, Bs, Cs, Tr]) =
      new HZip3[A :: As, B :: Bs, C :: Cs, (A, B, C) :: Tr] { def apply(as: A :: As, bs: B :: Bs, cs: C :: Cs) = HCons((as.head, bs.head, cs.head), hzipTail(as.tail, bs.tail, cs.tail)) }

    sealed trait HZip4[A <: HList, B <: HList, C <: HList, D <: HList, Result <: HList] { def apply(as: A, bs: B, cs: C, ds: D): Result }
    implicit def hzip4Nil = new HZip4[HNil, HNil, HNil, HNil, HNil] { def apply(as: HNil, bs: HNil, cs: HNil, ds: HNil) = HNil }
    implicit def hzip4AsNil[H, T <: HList] = new HZip4[H :: T, HNil, HNil, HNil, HNil] { def apply(as: H :: T, bs: HNil, cs: HNil, ds: HNil) = HNil }
    implicit def hzip4BsNil[H, T <: HList] = new HZip4[HNil, H :: T, HNil, HNil, HNil] { def apply(as: HNil, bs: H :: T, cs: HNil, ds: HNil) = HNil }
    implicit def hzip4CsNil[H, T <: HList] = new HZip4[HNil, HNil, H :: T, HNil, HNil] { def apply(as: HNil, bs: HNil, cs: H :: T, ds: HNil) = HNil }
    implicit def hzip4DsNil[H, T <: HList] = new HZip4[HNil, HNil, HNil, H :: T, HNil] { def apply(as: HNil, bs: HNil, cs: HNil, ds: H :: T) = HNil }
    implicit def hzip4AsBsNil[A, As <: HList, B, Bs <: HList] = new HZip4[A :: As, B :: Bs, HNil, HNil, HNil] { def apply(as: A :: As, bs: B :: Bs, cs: HNil, ds: HNil) = HNil }
    implicit def hzip4AsCsNil[A, As <: HList, C, Cs <: HList] = new HZip4[A :: As, HNil, C :: Cs, HNil, HNil] { def apply(as: A :: As, bs: HNil, cs: C :: Cs, ds: HNil) = HNil }
    implicit def hzip4AsDsNil[A, As <: HList, D, Ds <: HList] = new HZip4[A :: As, HNil, HNil, D :: Ds, HNil] { def apply(as: A :: As, bs: HNil, cs: HNil, ds: D :: Ds) = HNil }
    implicit def hzip4BsCsNil[B, Bs <: HList, C, Cs <: HList] = new HZip4[HNil, B :: Bs, C :: Cs, HNil, HNil] { def apply(as: HNil, bs: B :: Bs, cs: C :: Cs, ds: HNil) = HNil }
    implicit def hzip4BsDsNil[B, Bs <: HList, D, Ds <: HList] = new HZip4[HNil, B :: Bs, HNil, D :: Ds, HNil] { def apply(as: HNil, bs: B :: Bs, cs: HNil, ds: D :: Ds) = HNil }
    implicit def hzip4CsDsNil[C, Cs <: HList, D, Ds <: HList] = new HZip4[HNil, HNil, C :: Cs, D :: Ds, HNil] { def apply(as: HNil, bs: HNil, cs: C :: Cs, ds: D :: Ds) = HNil }
    implicit def hzip4AsBsCsNil[A, As <: HList, B, Bs <: HList, C, Cs <: HList] = new HZip4[A :: As, B :: Bs, C :: Cs, HNil, HNil] { def apply(as: A :: As, bs: B :: Bs, cs: C :: Cs, ds: HNil) = HNil }
    implicit def hzip4AsBsDsNil[A, As <: HList, B, Bs <: HList, D, Ds <: HList] = new HZip4[A :: As, B :: Bs, HNil, D :: Ds, HNil] { def apply(as: A :: As, bs: B :: Bs, cs: HNil, ds: D :: Ds) = HNil }
    implicit def hzip4AsCsDsNil[A, As <: HList, C, Cs <: HList, D, Ds <: HList] = new HZip4[A :: As, HNil, C :: Cs, D :: Ds, HNil] { def apply(as: A :: As, bs: HNil, cs: C :: Cs, ds: D :: Ds) = HNil }
    implicit def hzip4BsCsDsNil[B, Bs <: HList, C, Cs <: HList, D, Ds <: HList] = new HZip4[HNil, B :: Bs, C :: Cs, D :: Ds, HNil] { def apply(as: HNil, bs: B :: Bs, cs: C :: Cs, ds: D :: Ds) = HNil }
    implicit def hzip4Cons[A, B, C, D, As <: HList, Bs <: HList, Cs <: HList, Ds <: HList, Tr <: HList](implicit hzipTail: HZip4[As, Bs, Cs, Ds, Tr]) =
      new HZip4[A :: As, B :: Bs, C :: Cs, D :: Ds, (A, B, C, D) :: Tr] { def apply(as: A :: As, bs: B :: Bs, cs: C :: Cs, ds: D :: Ds) = HCons((as.head, bs.head, cs.head, ds.head), hzipTail(as.tail, bs.tail, cs.tail, ds.tail)) }

    sealed trait HUnzip2[As <: HList, Bs <: HList, Ts <: HList] { def apply(ts: Ts): (As, Bs) }
    implicit def hunzip2Nil = new HUnzip2[HNil, HNil, HNil] { def apply(ts: HNil) = (HNil, HNil) }
    implicit def hunzip2Cons[A, B, Ts <: HList, As <: HList, Bs <: HList](implicit hunzipTail: HUnzip2[As, Bs, Ts]) =
      new HUnzip2[A :: As, B :: Bs, (A, B) :: Ts] { def apply(ts: (A, B) :: Ts) = { val (a, b) = hunzipTail(ts.tail); (HCons(ts.head._1, a), HCons(ts.head._2, b)) }}

    sealed trait HUnzip3[As <: HList, Bs <: HList, Cs <: HList, Ts <: HList] { def apply(ts: Ts): (As, Bs, Cs) }
    implicit def hunzip3Nil = new HUnzip3[HNil, HNil, HNil, HNil] { def apply(ts: HNil) = (HNil, HNil, HNil) }
    implicit def hunzip3Cons[A, B, C, Ts <: HList, As <: HList, Bs <: HList, Cs <: HList](implicit hunzipTail: HUnzip3[As, Bs, Cs, Ts]) =
      new HUnzip3[A :: As, B :: Bs, C :: Cs, (A, B, C) :: Ts] { def apply(ts: (A, B, C) :: Ts) = { val (a, b, c) = hunzipTail(ts.tail); (HCons(ts.head._1, a), HCons(ts.head._2, b), HCons(ts.head._3, c)) }}

    sealed trait HUnzip4[As <: HList, Bs <: HList, Cs <: HList, Ds <: HList, Ts <: HList] { def apply(ts: Ts): (As, Bs, Cs, Ds) }
    implicit def hunzip4Nil = new HUnzip4[HNil, HNil, HNil, HNil, HNil] { def apply(ts: HNil) = (HNil, HNil, HNil, HNil) }
    implicit def hunzip4Cons[A, B, C, D, Ts <: HList, As <: HList, Bs <: HList, Cs <: HList, Ds <: HList](implicit hunzipTail: HUnzip4[As, Bs, Cs, Ds, Ts]) =
      new HUnzip4[A :: As, B :: Bs, C :: Cs, D :: Ds, (A, B, C, D) :: Ts] { def apply(ts: (A, B, C, D) :: Ts) = { val (a, b, c, d) = hunzipTail(ts.tail); (HCons(ts.head._1, a), HCons(ts.head._2, b), HCons(ts.head._3, c), HCons(ts.head._4, d)) }}

    implicit def happlyNil(h: HNil): (HNil => HNil) = _ => HNil
    implicit def happlyCons[In, Out, Tf <: HList, Tin <: HList, Tout <: HList](implicit happlyTail: Tf => Tin => Tout): ((In => Out) :: Tf) => ((In :: Tin) => (Out :: Tout)) =
      functions => values => HCons(functions.head(values.head), happlyTail(functions.tail)(values.tail))

    // @todo: these would become much shorter with church-numeral-indexed hlists
    sealed trait ToProduct[A <: HList, Result <: Product] { def apply(as: A): Result }
    implicit def toProduct1[A] = new ToProduct[A :: HNil, Tuple1[A]] { def apply(as: A :: HNil) = Tuple1(as.head) }
    implicit def toProduct2[A, B] = new ToProduct[A :: B :: HNil, (A, B)] { def apply(as: A :: B :: HNil) = (as.head, as.tail.head) }
    implicit def toProduct3[A, B, C] = new ToProduct[A :: B :: C :: HNil, (A, B, C)] { def apply(as: A :: B :: C :: HNil) = (as.head, as.tail.head, as.tail.tail.head) }
    implicit def toProduct4[A, B, C, D] = new ToProduct[A :: B :: C :: D :: HNil, (A, B, C, D)] { def apply(as: A :: B :: C :: D :: HNil) = (as.head, as.tail.head, as.tail.tail.head, as.tail.tail.tail.head) }
    implicit def toProduct5[A, B, C, D, E] = new ToProduct[A :: B :: C :: D :: E :: HNil, (A, B, C, D, E)] { def apply(as: A :: B :: C :: D :: E :: HNil) = (as.head, as.tail.head, as.tail.tail.head, as.tail.tail.tail.head, as.tail.tail.tail.tail.head) }
    implicit def toProduct6[A, B, C, D, E, F] = new ToProduct[A :: B :: C :: D :: E :: F :: HNil, (A, B, C, D, E, F)] { def apply(as: A :: B :: C :: D :: E :: F :: HNil) = (as.head, as.tail.head, as.tail.tail.head, as.tail.tail.tail.head, as.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.head) }
    implicit def toProduct7[A, B, C, D, E, F, G] = new ToProduct[A :: B :: C :: D :: E :: F :: G :: HNil, (A, B, C, D, E, F, G)] { def apply(as: A :: B :: C :: D :: E :: F :: G :: HNil) = (as.head, as.tail.head, as.tail.tail.head, as.tail.tail.tail.head, as.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.head) }
    implicit def toProduct8[A, B, C, D, E, F, G, H] = new ToProduct[A :: B :: C :: D :: E :: F :: G :: H :: HNil, (A, B, C, D, E, F, G, H)] { def apply(as: A :: B :: C :: D :: E :: F :: G :: H :: HNil) = (as.head, as.tail.head, as.tail.tail.head, as.tail.tail.tail.head, as.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.head) }
    implicit def toProduct9[A, B, C, D, E, F, G, H, I] = new ToProduct[A :: B :: C :: D :: E :: F :: G :: H :: I :: HNil, (A, B, C, D, E, F, G, H, I)] { def apply(as: A :: B :: C :: D :: E :: F :: G :: H :: I :: HNil) = (as.head, as.tail.head, as.tail.tail.head, as.tail.tail.tail.head, as.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.head) }
    implicit def toProduct10[A, B, C, D, E, F, G, H, I, J] = new ToProduct[A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: HNil, (A, B, C, D, E, F, G, H, I, J)] { def apply(as: A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: HNil) = (as.head, as.tail.head, as.tail.tail.head, as.tail.tail.tail.head, as.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.head) }
    implicit def toProduct11[A, B, C, D, E, F, G, H, I, J, K] = new ToProduct[A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: HNil, (A, B, C, D, E, F, G, H, I, J, K)] { def apply(as: A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: HNil) = (as.head, as.tail.head, as.tail.tail.head, as.tail.tail.tail.head, as.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head) }
    implicit def toProduct12[A, B, C, D, E, F, G, H, I, J, K, L] = new ToProduct[A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: L :: HNil, (A, B, C, D, E, F, G, H, I, J, K, L)] { def apply(as: A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: L :: HNil) = (as.head, as.tail.head, as.tail.tail.head, as.tail.tail.tail.head, as.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head) }
    implicit def toProduct13[A, B, C, D, E, F, G, H, I, J, K, L, M] = new ToProduct[A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: L :: M :: HNil, (A, B, C, D, E, F, G, H, I, J, K, L, M)] { def apply(as: A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: L :: M :: HNil) = (as.head, as.tail.head, as.tail.tail.head, as.tail.tail.tail.head, as.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head) }
    implicit def toProduct14[A, B, C, D, E, F, G, H, I, J, K, L, M, N] = new ToProduct[A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: L :: M :: N :: HNil, (A, B, C, D, E, F, G, H, I, J, K, L, M, N)] { def apply(as: A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: L :: M :: N :: HNil) = (as.head, as.tail.head, as.tail.tail.head, as.tail.tail.tail.head, as.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head) }
    implicit def toProduct15[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O] = new ToProduct[A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: L :: M :: N :: O :: HNil, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O)] { def apply(as: A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: L :: M :: N :: O :: HNil) = (as.head, as.tail.head, as.tail.tail.head, as.tail.tail.tail.head, as.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head) }
    implicit def toProduct16[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P] = new ToProduct[A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: L :: M :: N :: O :: P :: HNil, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)] { def apply(as: A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: L :: M :: N :: O :: P :: HNil) = (as.head, as.tail.head, as.tail.tail.head, as.tail.tail.tail.head, as.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head) }
    implicit def toProduct17[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q] = new ToProduct[A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: L :: M :: N :: O :: P :: Q :: HNil, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q)] { def apply(as: A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: L :: M :: N :: O :: P :: Q :: HNil) = (as.head, as.tail.head, as.tail.tail.head, as.tail.tail.tail.head, as.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head) }
    implicit def toProduct18[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R] = new ToProduct[A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: L :: M :: N :: O :: P :: Q :: R :: HNil, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R)] { def apply(as: A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: L :: M :: N :: O :: P :: Q :: R :: HNil) = (as.head, as.tail.head, as.tail.tail.head, as.tail.tail.tail.head, as.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head) }
    implicit def toProduct19[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S] = new ToProduct[A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: L :: M :: N :: O :: P :: Q :: R :: S :: HNil, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S)] { def apply(as: A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: L :: M :: N :: O :: P :: Q :: R :: S :: HNil) = (as.head, as.tail.head, as.tail.tail.head, as.tail.tail.tail.head, as.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head) }
    implicit def toProduct20[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T] = new ToProduct[A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: L :: M :: N :: O :: P :: Q :: R :: S :: T :: HNil, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T)] { def apply(as: A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: L :: M :: N :: O :: P :: Q :: R :: S :: T :: HNil) = (as.head, as.tail.head, as.tail.tail.head, as.tail.tail.tail.head, as.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head) }
    implicit def toProduct21[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U] = new ToProduct[A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: L :: M :: N :: O :: P :: Q :: R :: S :: T :: U :: HNil, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U)] { def apply(as: A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: L :: M :: N :: O :: P :: Q :: R :: S :: T :: U :: HNil) = (as.head, as.tail.head, as.tail.tail.head, as.tail.tail.tail.head, as.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head) }
    implicit def toProduct22[A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V] = new ToProduct[A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: L :: M :: N :: O :: P :: Q :: R :: S :: T :: U :: V :: HNil, (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V)] { def apply(as: A :: B :: C :: D :: E :: F :: G :: H :: I :: J :: K :: L :: M :: N :: O :: P :: Q :: R :: S :: T :: U :: V :: HNil) = (as.head, as.tail.head, as.tail.tail.head, as.tail.tail.tail.head, as.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head, as.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.tail.head) }
  }

}
