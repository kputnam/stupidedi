package net.ppmconnect.edigen.x12
package general

import net.ppmconnect.scala.HList._

trait SegmentDefinition extends ElementDefinitionGroup {
  def identifier: String // eg "CAS"
}

/** Segment usages are declared in loop definitions */
trait SegmentUsage {
  type Parent <: SegmentDefinitionGroup // either LoopDefinition or TableDefinition
  def parent: Parent

  def position: Int
  def name: String

  type Definition <: SegmentDefinition
  def definition: Definition

  def required: Boolean

//type MaxRepeat <: ChurchNumeral
  def maxRepeat: Option[Int]
}

trait SegmentInstance extends ElementInstanceGroup {
  type Usage <: SegmentUsage
  def usage: Usage

  type Parent <: SegmentInstanceGroup // either LoopInstance or TableInstance
  def parent: Parent
}
