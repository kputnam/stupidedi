package net.ppmconnect.edigen.x12
package parser

case class StreamReader(input: String) {
  import interchange.FunctionalGroupHeaderParser

  /** Skip a string of n characters */
  def consume(n: Int): Option[StreamReader] =
    if (input.length >= n) Some(StreamReader(input.substring(n))) else None

  /** Read a string of n characters */
  def readString(n: Int): Option[(String, StreamReader)] =
    if (input.length >= n) Some(Pair(input.substring(0, n), StreamReader(input.substring(n)))) else None

  /** Read a single character */
  def readChar: Option[(Char, StreamReader)] =
    if (input.nonEmpty) Some(Pair(input.head, StreamReader(input.substring(1)))) else None

  /** Construct a reader capable of iterating X12 segments in a rudimentary fashion */
  def readInterchangeHeader: Option[FunctionalGroupHeaderParser] = {
    import interchange.InterchangeHeader00501

    /** @todo: improve data validation and error handling here */
    for (rest                     <- consumeISA;
         (elementSeparator, rest) <- rest.readChar;
         (isa01, rest) <- rest.readElement(elementSeparator);
         (isa02, rest) <- rest.readElement(elementSeparator);
         (isa03, rest) <- rest.readElement(elementSeparator);
         (isa04, rest) <- rest.readElement(elementSeparator);
         (isa05, rest) <- rest.readElement(elementSeparator);
         (isa06, rest) <- rest.readElement(elementSeparator);
         (isa07, rest) <- rest.readElement(elementSeparator);
         (isa08, rest) <- rest.readElement(elementSeparator);
         (isa09, rest) <- rest.readElement(elementSeparator);
         (isa10, rest) <- rest.readElement(elementSeparator);
         (isa11, rest) <- rest.readElement(elementSeparator);
         (isa12, rest) <- rest.readElement(elementSeparator);
         (isa13, rest) <- rest.readElement(elementSeparator);
         (isa14, rest) <- rest.readElement(elementSeparator);
         (isa15, rest) <- rest.readElement(elementSeparator);
         (isa16, rest) <- rest.readChar;
         (segmentTerminator, rest) <- rest.readChar)
      yield (isa12 match { case "00501" => InterchangeHeader00501 }).
                         //case "00401" => InterchangeHeader00401 }).
        readInterchangeHeader(segmentTerminator, elementSeparator, rest.input,
          (isa01, isa02, isa03, isa04, isa05, isa06, isa07, isa08,
           isa09, isa10, isa11, isa12, isa13, isa14, isa15, isa16))
 }

  /** Consume the next occurrence of "ISA", ignoring control characters and other rubbish
   *
   * The ASC X12 specification is silent about what happens before and/or after the
   * interchange envelope. The spec doesn't reference any larger structure, so based
   * on our experience with Emdeon, I think we can just skip to the next occurence of
   * the string "ISA" that is followed by a *valid* ISA segment.
   *
   *   http://www.x12.org/rfis/Multiple%20ISA%20and%20IEA%20Segments%20in%20a%20Single%20File.pdf
   *   "A search of the X12 standards finds no definition or reference to a 'file' construct"
   *
   */
  private def consumeISA: Option[StreamReader] = {
    var position = 0
    var buffer   = "   "

    /** The longest segment IDs are only three characters */
    while (position < input.length) {
      val character = input(position)

      if (TokenReader.isBasicCharacter(character) || TokenReader.isExtendedCharacter(character))
        buffer = buffer.substring(1) + character

      position += 1

      if (buffer.toUpperCase == "ISA")
        return Some(StreamReader(input.substring(position)))
    }

    /** Reached end of input */
    None
  }

  /** Read up to the next occurrence of elementSeparator */
  private def readElement(elementSeparator: Char): Option[(String, StreamReader)] = {
    val position = input.indexOf(elementSeparator)
    if (position >= 0)
      Some(Pair(input.substring(0, position), StreamReader(input.substring(position + 1))))
    else
      None
  }

}
