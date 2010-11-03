package net.ppmconnect.edigen.x12
package general

import net.ppmconnect.scala.HList._

trait LoopDefinition extends SegmentDefinitionGroup {
  type Parent // <: LoopDefinition or TableDefinition
  def parent: Parent
}

trait LoopDefinitionGroup {
  type LoopDefinitions <: HList
  def loops: LoopDefinitions
}

trait LoopInstance extends SegmentInstanceGroup {
  type Definition <: LoopDefinition
  def definition: Definition

  type Parent // <: LoopInstance or TableInstance
  def parent: Parent
}

trait LoopInstanceGroup
