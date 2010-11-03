package net.ppmconnect.edigen.x12
package general

import net.ppmconnect.scala.HList._
import net.ppmconnect.scala.ChurchNumeral._

/** Abstract ancestor of Simple- and Composite- ElementDefinitions */
sealed trait ElementDefinition {
  def name: String
  def identifier: String // eg "479" or "C001"

  /* someInput match {
   *   case C004("..", "..", List(xs), "..") => // type error, third arg is not a repeating element
   *   case C004("..", "..", "..", "..")     => 
   * }
   *
   * // return type roughly corresponds to ElementInstance
   * def unapply(i: Input): Option[(.., .., .., ..)]
   */
}

/**
 * Simple elements are the smallest unit of data (think native types)
 */
trait SimpleElementDefinition extends ElementDefinition {
  def minLength: Option[Int]
  def maxLength: Option[Int]
}

/**
 * Composite elements consist of two or more elements preceeded by a data element separator. In
 * use, in the actual data stream, a composite element may appear as only one component element.
 * Each component element within the composite element, except the last, is followed by a component
 * element separator. The final component element is followed by the next element separator or the
 * segment terminator. Trailing component element separators shall be supressed. Composite elements
 * are defined in a directory. The directory defines each composite element by its name, purpose,
 * reference identifier, and included component elements in a specified sequence.
 */
trait CompositeElementDefinition extends ElementDefinition with ElementDefinitionGroup

/** Element usages are declared in segment definitions and composite element definitions */
trait ElementUsage {
  def required: Boolean // Mandatory or Optional
//def referenceDesignator: String // eg "GS03" or "REF04-01"

//type MaxRepeat <: ChurchNumeral
  def maxRepeat: Option[Int]

  type Definition <: ElementDefinition
  def definition: Definition

  type Parent <: ElementDefinitionGroup // either CompositeElementDefinition or SegmentDefinition
  def parent: Parent
}

trait ElementInstance {
  def toString: String

  type Usage <: ElementUsage
  def usage: Usage

  type Parent <: ElementInstanceGroup // either CompositeElementInstance or SegmentInstance
  def parent: Parent
}
