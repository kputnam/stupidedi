package net.ppmconnect.edigen.x12
package general

import net.ppmconnect.scala.HList._

trait TableDefinition extends SegmentDefinitionGroup with LoopDefinitionGroup
trait TableInstance extends SegmentInstanceGroup with LoopInstanceGroup

/**
 * Information in the heading area pertains to the entire transaction set:
 * - Every transaction set definition will have one (and only one) heading
 *   area, composed of at least one segment
 *
 * - The heading area typically contains elements that identify each instance
 *   of a transaction set and its date. These are included to prevent replay
 *   of transaction set instances in a secure EDI environment
 *
 * - If the transaction set definition does not include a mandatory segment
 *   in the heading area, then it is possible for an instance of the transaction
 *   set to have no heading area.
 *
 * - The entire heading area comprises a segment group which is not repeated.
 **
 * Each instance of the transaction set shall be considered the parent structure
 * of the heading an summary areas enclosed within the boundaries of the transaction
 * set.
 */
trait HeaderDefinition extends TableDefinition {
  type Parent <: TransactionSetDefinition
  def parent: Parent
}

trait HeaderInstance extends TableInstance {
  def definition: HeaderDefinition

  type Parent <: TransactionSetInstance
  def parent: Parent
}

/**
 * A detail area is any looping structure between the heading area and the
 * summary area (or the SE, if no summary exists). Detail areas encompass the
 * actual body of the business transaction.
 * - There can be multiple detail areas in a transaction set definition
 * - There is no requirement for a detail area in a transaction set
 * 
 * Each instance of the transaction set and the contents of its heading area
 * shall be considered the parent structure of any and all detail areas that
 * follow the last segment of the heading area (or the ST segment if no heading
 * area exists), and preceed the first segment of the summary area (or the SE
 * segment if no summary area exists).
 *
 * The summary area is NOT defined as a parent structure to the detail area.
 */
trait DetailDefinition extends TableDefinition {
  type Parent <: HeaderDefinition
  def parent: Parent
}

trait DetailInstance extends TableInstance {
  type Definition <: DetailDefinition
  def definition: Definition

  type Parent <: HeaderInstance
  def parent: Parent
}

/**
 * Information in the summary area addresses the results of summarizations of
 * information in the detail area, or additional information about the entire
 * transaction that cannot be expressed until the heading and detail areas
 * have been generated. The summary area contains information such as control
 * totals, balance totals, hash totals, etc.
 * - The summary area is not required in a transaction set definition
 * - The entire summary area comprises a segment group which is not repeated.
 *
 **
 * Each instance of the transaction set shall be considered the parent structure
 * of the heading an summary areas enclosed within the boundaries of the transaction
 * set.
 */
trait SummaryDefinition extends TableDefinition {
  type Parent <: TransactionSetDefinition
  def parent: Parent
}

trait SummaryInstance extends TableInstance {
  type Definition <: HeaderDefinition
  def definition: Definition

  type Parent <: TransactionSetInstance
  def parent: Parent
}
