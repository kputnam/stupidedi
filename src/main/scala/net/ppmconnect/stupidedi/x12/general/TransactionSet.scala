package net.ppmconnect.edigen.x12
package general

import net.ppmconnect.scala.HList._

/**
 * The transaction set is a semantically meaningful unit of information exchanged between
 * trading partners. The transaction set shall consist of a transaction set header segment,
 * optionally one or more transaction security header segments, optionally one or more
 * transaction assurance header segments, one or more data segments and loop control
 * segments (if bounded loops exist) in a specified order, one transaction security value
 * for each assurance header present, one transaction security trailer segment for each
 * security header segment present, and a transaction set trailer segment.
 *
 * <transactionSet> ::= <headerSegment(ST)> <segmentGroup> {<segmentGroup>} <trailerSegment(SE)>
 *
 * The transaction set identifier (ST01) uniquely identifies the transaction set. The
 * value for the transaction set control number in the header and trailer (ST02 and SE02)
 * must be identical for any given transaction. The value of SE01 is the total number of
 * segments in the transaction set, including the ST and SE segments. The implementation
 * convention identification string identifies which implementation convention is in use
 * for the transaction set.
 *
 * @note: Security and assurance functionality (X12.58) is not currently implemented.
 */
trait TransactionSetDefinition {
  type Header <: HeaderDefinition
  def header: Header

  type Summary <: SummaryDefinition
  def summary: Summary
}

trait TransactionSetInstance {
  type Declaration <: TransactionSetDefinition
  def declaration: Declaration

  type Header <: HeaderInstance
  def header: Header

  type Summary <: SummaryInstance
  def summary: Summary
}
