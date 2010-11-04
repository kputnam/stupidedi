package net.ppmconnect.edigen.x12
package general

import net.ppmconnect.scala.HList._

/** Common ancestor of SegmentDefinition and CompositeElementDefinition */
trait ElementDefinitionGroup {
  type Elements <: HList // of ElementUsage
  def elements: Elements

  /* someInput match {
   *   case CAS("..", "..")             => // type error, wrong number of args (2 for 4)
   *   case CAS("..", "..", "..", "..") => // type checks each arg with unapply's return type
   * }
   *
   * // return type roughly corresponds to ElementInstanceGroup
   * def unapply(i: Input): Option[(.., .., .., ..)]
   */
}

trait ElementInstanceGroup {
  type Elements <: HList // of ElementInstance
  def elements: Elements
}
