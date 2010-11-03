package net.ppmconnect.edigen.x12
package interchange

object InterchangeHeader00501 extends InterchangeHeaderParser {
  /** Construct a reader capable of iterating X12 segments in a rudimentary fashion */
  def readInterchangeHeader(segmentTerminator: Char, elementSeparator: Char, unparsedInput: String, elements: T16) =
    /** @todo: This is where we would parse segments like TA1, TA3, ISB, IEA... or at least consume them */
    InterchangeHeader00501(elementSeparator,
      elements._1,  elements._2,  elements._3,  elements._4,  elements._5, elements._6,
      elements._7,  elements._8,  elements._9,  elements._10, elements._11.head, elements._12,
      elements._13, elements._14, elements._15, elements._16, segmentTerminator).
      functionalGroupHeaderParser(unparsedInput)
}

/** Models the ISA segment and potentially TA1, TA3, ISE, ISB, etc for interchange version 00501 */
case class InterchangeHeader00501(
  val elementSeparator: Char,
  val authorizationInfoQualifier: String,
  val authorizationInfo: String,
  val securityInfoQualifier: String,
  val securityInfo: String,
  val senderIdQualifier: String,
  val senderId: String,
  val receiverIdQualifier: String,
  val receiverId: String,
  val date: String,
  val time: String,
  val repetitionSeparator: Char,
  val versionNumber: String,
  val controlNumber: String,
  val acknowledgmentRequested: String,
  val usageIndicator: String,
  val componentSeparator: Char,
  val segmentTerminator: Char)
extends InterchangeHeader {
  import parser.TransactionSetHeaderParser

  /** @todo: debug logging */
  println("""ISA Interchange Header
          |  version(00501)
          |  elementSeparator(%s)
          |  componentSeparator(%s)
          |  repetitionSeparator(%s)
          |  segmentTerminator(%s)
          """.stripMargin.format(elementSeparator, componentSeparator, repetitionSeparator, segmentTerminator))
          

  def functionalGroupHeaderParser(input: String) = FunctionalGroupHeaderParser00501(input, this)

  case class FunctionalGroupHeaderParser00501(val input: String, val interchangeHeader: InterchangeHeader00501)
  extends FunctionalGroupHeaderParser {

    def advance(n: Int) = copy(input = input.substring(n))

    /** Read the GS segment and return something that can read the ST segment */
    def readFunctionalGroupHeader: Option[TransactionSetHeaderParser] = {
     (for (rest <- consumePrefix("GS" + interchangeHeader.elementSeparator);
           (gs01, rest) <- rest.readElement; rest <- rest.consumePrefix(interchangeHeader.elementSeparator);
           (gs02, rest) <- rest.readElement; rest <- rest.consumePrefix(interchangeHeader.elementSeparator);
           (gs03, rest) <- rest.readElement; rest <- rest.consumePrefix(interchangeHeader.elementSeparator);
           (gs04, rest) <- rest.readElement; rest <- rest.consumePrefix(interchangeHeader.elementSeparator);
           (gs05, rest) <- rest.readElement; rest <- rest.consumePrefix(interchangeHeader.elementSeparator);
           (gs06, rest) <- rest.readElement; rest <- rest.consumePrefix(interchangeHeader.elementSeparator);
           (gs07, rest) <- rest.readElement; rest <- rest.consumePrefix(interchangeHeader.elementSeparator);
           (gs08, rest) <- rest.readElement; rest <- rest.consumePrefix(interchangeHeader.segmentTerminator))
        yield FunctionalGroupHeader(gs01, gs02, gs03, gs04, gs05, gs06, gs07, gs08).
          transactionSetHeaderParser(rest.input, interchangeHeader)).flatMap(x => x)
    }
  }

  /** GS segment for interchange version 00501 */
  case class FunctionalGroupHeader(
    functionalIdCode: String,
    senderCode: String,
    receiverCode: String,
    date: String,
    time: String,
    controlNumber: String,
    agencyCode: String,
    versionCode: String) {

    /** @todo: debug logging */
    println("""GS Functional Group Header
            |  functionalIdCode(%s)
            |  agencyCode(%s)
            |  versionCode(%s)
            |  senderCode(%s)
            |  receiverCode(%s)
            |  dateTime(%s %s)
            |  controlNumber(%s)
            """.stripMargin.format(functionalIdCode, agencyCode, versionCode, senderCode, receiverCode, date, time, controlNumber))

    def asc =
      if (agencyCode == "X" && versionCode.length > 6)
        Some(new {
          def number = versionCode.substring(0, 3)
          def release = versionCode(3)
          def subrelease = versionCode(4)
          def level = versionCode(5)
          def industryId = versionCode.substring(6)
          override def toString = versionCode
        })
      else
        None

    /** Delegate further parsing based on the agencyCode and versionCode (ie 4010, 5010) */
    def transactionSetHeaderParser(input: String, interchangeHeader: InterchangeHeader00501) =
      asc.flatMap(TransactionSetHeaderParser.fromVersion(_))
  }

}
