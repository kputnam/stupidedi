package net.ppmconnect.edigen.x12
package v5010.general.elements

import net.ppmconnect.edigen.x12.{general => g}

case class ElementUsage[P <: g.ElementDefinitionGroup, D <: g.ElementDefinition](definition: D, parent: P, required: Boolean, maxRepeat: Option[Int])
extends g.ElementUsage {
  type Parent = P
  type Definition = D
}

/**
 * The "X12.3 Data Element Dictionary" for 5010 encoded in Scala
 */
package object definitions {
  import types._

  val E66  = ID( "66", "Identification Code Qualifier", Some(1), Some(2))
  val E67  = AN( "67", "Identification Code",           Some(1), Some(2))
  val E93  = AN( "93", "Name",                          Some(1), Some(60))
  val E98  = ID( "98", "Entity Identifier Code",        Some(2), Some(3))
  val E706 = ID("706", "Entity Relationship Code",      Some(2), Some(2))
}

package types {
  import g.SimpleElementDefinition

  /**
   * Unspecified type, only "used" in the ISA control segment
   */
  trait NA extends SimpleElementDefinition

  /**
   * Numeric (pattern: <-?[0-9]+>)
   *   The value of a numeric element includes an implied decimal point. It is used when the
   *   position of the decimal point within the data is permanently fixed and is not transmitted
   *   with the data. The data element dictionary defines the implied number of decimal positions.
   *   For negative values, the leading minus sign (-) is used. Absence of a sign indicates a positive
   *   value.  The plus sign (+) should not be transmitted. Leading zeros should be supressed
   *   unless necessary to satisfy a minimum length requirement. The length of a numeric type element
   *   does not include the optional sign.
   */
  trait Nn extends SimpleElementDefinition
  trait N0 extends Nn
  trait N1 extends Nn
  trait N2 extends Nn
  trait N3 extends Nn
  trait N4 extends Nn
  trait N5 extends Nn
  trait N6 extends Nn
  trait N7 extends Nn
  trait N8 extends Nn
  trait N9 extends Nn

  /**
   * Decimal (pattern: <-?(([0-9]+(\.[0-9]*)?)|\.[0-9]*)(E-?[0-9]+)?>)
   *   The decimal element contains an explicit decimal point and is used for numeric values that
   *   have a varying number of decimal positions. The decimal point always appears in the character
   *   stream if the decimal point is at any place other than the right end. If the value is an
   *   integer (decimal point at the right end), the decimal point should be omitted. For negative
   *   values, the leading minus sign (-) is used. Absence of a sign indicates a positive value. The
   *   plus sign (+) shall not be transmitted. Leading zeros following the decimal point should be
   *   supressed unless necessary to satisfy a minimum length requirement. Trailing zeros following
   *   the decimal point should be supressed unless necessary to indicate precision. A base 10 exponent
   *   may be appended at the end of a decimal number. The use of triad separators (eg: 1,00,000) is
   *   expressly prohibited. The length of a decimal type element does not include the optional minus
   *   signs, decimal point, or exponent indicator E.
   */
  //trait R extends SimpleElementDefinition
  case class R(identifier: String, name: String, minLength: Option[Int], maxLength: Option[Int]) extends SimpleElementDefinition

  /**
   * Identifier (pattern: <[0-9A-Z]+ *>)
   *   The identifier element always contains a unique value from a single, predefined list of
   *   values. Trailing spaces should be supressed.
   */
  //trait ID extends SimpleElementDefinition
  case class ID(identifier: String, name: String, minLength: Option[Int], maxLength: Option[Int]) extends SimpleElementDefinition

  /**
   * String (pattern: <[[:nonspace] ]*[[:nonspace]][[:nonspace] ]*>)
   *   The string element is a sequence of any characters from the basic or extended character
   *   sets, and it contains at least one non-space character. The significant characters shall be
   *   left-justified. Leading spaces, when they occur, are presumed to be significant characters.
   *   In the actual data stream, trailing characters should be supressed.
   */
  //trait AN extends SimpleElementDefinition
  case class AN(identifier: String, name: String, minLength: Option[Int], maxLength: Option[Int]) extends SimpleElementDefinition

  /**
   * Date (pattern: <([0-9]{2}|[0-9]{4})("01" | ... "12")("01" | ... | "31")>
   *   The date element is used to express the standard date in either YYMMDD or CCYYMMDD format,
   *   in which the CC is the first two digits of the calendar year, YY is the last two digits
   *   of the calendar year, MM is the month, and DD is the day in the month.
   */
  //trait DT extends SimpleElementDefinition
  case class DT(identifier: String, name: String, minLength: Option[Int], maxLength: Option[Int]) extends SimpleElementDefinition

  /**
   * Time (pattern: <("00" | ... | "23")("00" | ... | "59")(("00" | ... | "59")[0-9]*)?>
   *   The time element is used to express time in HHMMSSd..d format, in which HH is the hour for a
   *   24-hour clock, MM is the minute, SS is the seconds, and d...d is the fractional seconds.
   *   Seconds and fractional seconds are optional. Trailing zeros should be suppressed unless
   *   necessary to satisfy a minimum length requirement or unless necessary to indicate precision.
   */
  //trait TM extends SimpleElementDefinition
  case class TM(identifier: String, name: String, minLength: Option[Int], maxLength: Option[Int]) extends SimpleElementDefinition

  /**
   * Binary
   *   The binary element is any sequence of octects ranging from 00000000 to 11111111 binary (0 to
   *   255 in decimal notation). The element type has no defined maximum length. Actual length is
   *   specified by the immediately preceeding element. The binary element type may only exist in the
   *   Binary and Security header segments.
   */
  //trait B extends SimpleElementDefinition
  case class B(identifier: String, name: String, minLength: Option[Int], maxLength: Option[Int]) extends SimpleElementDefinition
}
