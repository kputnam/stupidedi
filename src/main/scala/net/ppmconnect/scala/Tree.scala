package net.ppmconnect.util

/** @note: Don't use this, it's not implemented */

abstract class Tree[A] {
  /**
   * Operations:
   *   size: Int
   *   height: Int
   *   isEmpty: Boolean
   *   children: Iterable[?]
   *
   * Traversing:
   *   Depth-First
   *     PostOrder
   *     PreOrder
   *     InOrder
   *   BreadthFirst
   */

  trait Node[+B] {
    def size: Int
    def height: Int
    def isEmpty: Boolean

    def get(k: A): this.type
    def getOrElse[W >: B](k: A, default: => W): W
  }

  abstract class Empty extends Node[Nothing] {
    def size = 0
    def height = 0
    def isEmpty = true

    def get(k: A) = this
    def getOrElse[W](k: A, default: => W) = default
  }

  abstract class NonEmpty[+B] extends Node[B] {
    def key: A
    def value: B
    def isEmpty = false
  }

}

abstract class BinaryTree[A](implicit o: Ordered[A]) extends Tree[A] {
  /**
   * Operations:
   *   size: Int
   *   height: Int
   *   isEmpty: Boolean
   *
   *   isDefinedAt(searchKey: K): Boolean
   *   getOrElse(searchKey: K, default: V): V
   *
   *   get(searchKey: K): ?
   *   getOrNextSmallest(searchKey: K): ?
   *   getOrNextLargest(searchKey: K): ?
   *
   *   min: ?
   *   max: ?
   *
   *   nthLargest(n: Int): ?
   *   nthSmallest(n: Int): ?
   */
}

/** Defines optimized Node.get */
abstract class BinarySearchTree[A](implicit o: Ordered[A]) extends BinaryTree[A]

/** Defines methods to mutate the tree (add, remove) */
abstract class RedBlackTree[A](implicit o: Ordered[A]) extends BinarySearchTree[A]

/** Defines methods to mutate the tree (add, remove)*/
abstract class ScapegoatTree[A](implicit o: Ordered[A]) extends BinarySearchTree[A]
