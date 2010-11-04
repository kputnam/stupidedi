package net.ppmconnect.edigen.x12
package parser

import interchange.InterchangeHeader

object TokenReader {
  /**
   * All data element values, except the binary data element, shall be constructed using
   * the character sets specified below. Note: The X12 standards are graphic-character
   * oriented, so any common character encoding schemes may be used as long as a common
   * mapping is available. [X12.6 § 3.3 Character Sets].
   *
   * For implementations compliant with this guide, either the entire extended character
   * set must be acceptable, or the entired extended character set must not be used. In
   * the absence of a specific trading partner agreement to the contrary, trading partners
   * will assume that the extended character set is acceptable. [...] Users should note
   * that characters in the extended character set, as well as the basic character set,
   * may be used as delimiters only when they do not occur in the data [X222 § B.1.1.2.3]
   */
  val BasicCharacterSet    = """ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!"&'()*+,-./:;?= """
  val ExtendedCharacterSet = """abcdefghijklmnopqrstuvwxyz%@[]_{}\|<>~^`#$ÀÁÂÄàáâäÈÉÊèéêëÌÍÎìíîïÒÓÔÖòóôöÙÚÛÜùúûüÇçÑñ¿¡"""

  def isBasicCharacter(c: Char) = BasicCharacterSet contains c
  def isExtendedCharacter(c: Char) = ExtendedCharacterSet contains c
}

/** Reader capable of iterating X12 segments in a rudimentary fashion
 *
 * While there are two sets of 'control characters' defined in [X222 § B.1.1.2.4],
 * there is no explanation of when these characters are used, nor are there any
 * references to this table elswhere in the X222 document. For what it's worth,
 * i.e. next to nothing, the X12 committee states that characters like CR and LF
 * are outside the scope of their standards:
 *   http://x12.org/rfis/Use%20of%20Carriage%20Return%20Line%20Feed.pdf
 *
 * This causes a pretty big headache when trying to parse the contents. We can no
 * longer use typical parsing techniques, like regular expressions, directly on the
 * input stream. Trying to match the string "ISA" with a regular expresison would
 * look like /[:ignore-chars:]*I[:ignore-chars:]*S[:ignore-chars]*A/, because there
 * may be these non-data characters anywhere in the stream.
 *
 * In practice, these manifest as 80-character line wrapping or line wrapping just
 * after each segment terminator (~). So we could write a pre-processor that strips
 * all that out. But that causes some new problems -- the actual parser wants to
 * report errors or progress using the offset within the input stream, but those
 * offsets only make sense with the pre-processed input. If we ever need to adjust
 * the pre-processor (and I'm betting that we will), the old byte offsets will become
 * meaningless. So we'd either need to store the pre-processed input permanently, or
 * remember which version of the pre-processor was used... and there's more problems
 * with doing that.
 *
 * So instead, we preserve the offsets from the original input, and skip over the
 * non-data bits as we consume the input. We still can't use regular expressions, but
 * we don't need them. The operations needed to read "tokens" are all implemented
 * in this trait.
 */
trait TokenReader[+T] { this: T =>

  def input: String
  def advance(n: Int): T
  def interchangeHeader: InterchangeHeader

  /** Help the compiler: T implies TokenReader[T] */
  implicit def enrichT[S >: T](t: S) = t.asInstanceOf[TokenReader[T]]

  implicit def enrichChar(c: Char) = new {
    def isBasic: Boolean = TokenReader.isBasicCharacter(c)
    def isExtended: Boolean = TokenReader.isExtendedCharacter(c)
    def isDelimiter: Boolean =
      c == interchangeHeader.elementSeparator   ||
      c == interchangeHeader.segmentTerminator  ||
      c == interchangeHeader.componentSeparator ||
      c == interchangeHeader.repetitionSeparator
  }

  implicit def enrichBoolean(b: Boolean) = new {
    /** Convert `true' to Some(f) and `false' to None */
    def asOption[T](f: => T): Option[T] = if (b) Some(f) else None
  }

  final def isEmpty: Boolean = input.isEmpty
  final def nonEmpty: Boolean = input.nonEmpty

  /** Consume c if it is directly in front of the cursor */
  final def consumePrefix(c: Char): Option[T] =
    (input.head == c) asOption advance(1)

  /** Consume s if it is directly in front of the cursor */
  final def consumePrefix(s: String): Option[T] = {
    var position = 0
    var buffer   = ""

    if (s.exists(_.isDelimiter)) {
      /** Consume delimiters because our search string contains delimeters */
      while (position < input.length && buffer.length < s.length) {
        val character = input(position)

        if (character.isBasic || character.isExtended || character.isDelimiter)
          buffer += character

        position += 1
      }

      (buffer == s) asOption advance(position)
    }
    else {
      /** Stop searching when we read a delimiter */
      while (position < input.length) {
        val character = input(position)

        if (character.isBasic || character.isExtended)
          buffer += character

        position += 1

        if (buffer.length == s.length || character.isDelimiter)
          return (buffer == s) asOption advance(position)
      }

      None
    }
  }

  /** Consume input, including c, from here to the occurrence of c */
  final def consume(c: Char): Option[T] = {
    val position = input.indexOf(c)
    (position >= 0) asOption advance(position + 1)
  }

  /** Consume input, including s, from here to the next occurrence of s */
  final def consume(s: String): Option[T] = {
    var position = 0
    var buffer   = " " * s.length

    while (position < input.length) {
      val character = input(position)

      if (character.isBasic || character.isExtended)
        buffer  = buffer.substring(1) + character
      position += 1

      if (buffer == s)
        return Some(advance(position))
    }

    None
  }

  /**
   * Read the next element (which may be an empty string) and don't consume the delimiter
   *  @return Pair("2U", T("*93994~REF*2W*39394~..."))
   */
  final def readElement: Option[(String, T)] = {
    var position = 0
    var buffer   = ""

    while (position < input.length && !input(position).isDelimiter) {
      val character = input(position)

      if (character.isBasic || character.isExtended)
        buffer += character
      position += 1
    }

    (position < input.length) asOption Pair(buffer, advance(position))
  }

  /**
   * Read the next segment ID and don't consume the delimiter
   *  @return Pair("REF", T("*2U*923592~REF*2W*3939~..."))
   */
  final def readSegmentId: Option[(String, T)] = {
    var position = 0
    var buffer   = ""

    /** Don't consume more than three characters */
    while (position < input.length && buffer.length <= 3 && !input(position).isDelimiter) {
      val character = input(position)

      if (character.isBasic || character.isExtended)
        buffer += character
      position += 1
    }

    (buffer.length >= 2 && position < input.length && input(position).isDelimiter) asOption Pair(buffer, advance(position))
  }

  /** Consume input up to and including the IEA's segmentTerminator */
  final def consumeInterchange: Option[StreamReader] = {
    for ((segmentId, rest) <- readSegmentId; rest <- rest.consume(interchangeHeader.segmentTerminator))
      return if (segmentId == "IEA")
               Some(StreamReader(rest.input))
             else
               rest.consumeInterchange

    /** No more segments */
    return None
  }

  /**
   * Read the entire segment's raw string representation, and consume the segmentTerminator.
   *  @return Pair("ST*837*0021*005010X222", T("BHT*0019*..."))
   *
   * Note that without a given segment definition, it isn't possible to unambiguously parse an
   * input string as a segment, because the repetitionSeparator ambiguously can indicate that
   * a simple element /or/ composite element was repeated. Without referencing the segment, we
   * don't know which elements are simple or composite, nor can we deduce anything from the
   * maximum repeat count on each element
   */
  final def readSegment: Option[(String, T)] =
    for ((id, rest) <- readSegmentId; rest <- rest.consume(interchangeHeader.segmentTerminator))
      yield Pair(input.substring(0, input.length - rest.input.length - 1), rest)
}
