package net.ppmconnect.edigen.x12
package interchange

import parser.TokenReader
import parser.TransactionSetHeaderParser

/** Interface common to headers of all interchange versions */
trait InterchangeHeader {
  def segmentTerminator: Char
  def elementSeparator: Char
  def componentSeparator: Char
  def repetitionSeparator: Char
}

/** Interface to parse a specific interchange header */
trait InterchangeHeaderParser {
  type T16 = Tuple16[String, String, String, String, String, String, String, String,
                     String, String, String, String, String, String, String, Char]

  /** Construct a reader capable of iterating X12 segments in a rudimentary fashion */
  def readInterchangeHeader(segmentTerminator: Char, elementSeparator: Char, unparsedInput: String, elements: T16): FunctionalGroupHeaderParser
}

/** Reader that can parse the functional group header */
/**
 * The functional identifier GS01 defines the collection of transaction sets that may be
 * included within the functional group.
 *
 * <functionalGroup> ::= <headerSegment(GS)> <transactionSet> {<transactionSet}> <trailerSegment(GE)>
 *
 * The functional group control number (GS06/GE02) in the header and trailer segments shall be
 * the same for any given group. In order to provide sufficient discrimination for the
 * acknowledgement process to operate reliably and to ensure that audit trails are not
 * ambiguous, the combination of GS01, GS02, GS03, GS06/GE02 shall, by themselves, be unique
 * within a reasonably extended time frame whose boundaries shall be defined by trading
 * partner agreement. Because at some point it may be necessary to reuse a sequence of
 * control numbers, the functional group date and time (GS04 and GS05) elements may serve as
 * an additional discriminant only to differentiate functional group identity over the longest
 * possible time frame.
 *
 * @note: Security and assurance functionality (X12.58) is not currently implemented.
 */
trait FunctionalGroupHeaderParser extends TokenReader[FunctionalGroupHeaderParser] {
  def readFunctionalGroupHeader: Option[TransactionSetHeaderParser]
}
