package net.ppmconnect.edigen.x12.parser

object TransactionSetHeaderParser {

  /** Structural type since we don't really need a class */
  type Version = {
    def number: String
    def release: Char
    def subrelease: Char
    def level: Char
    def industryId: String
  }

  /** This lets us pattern match on it */
  object Version {
    def unapply(v: Version): Option[(String, Char, Char, Char, String)] =
      Some(v.number, v.release, v.subrelease, v.level, v.industryId)
  }

  def fromVersion(version: Version): Option[TransactionSetHeaderParser] = version match {
    case Version("005", '0', '1', '0', industryId) => None
    case Version("004", '0', '1', '0', industryId) => None
    case _ => None
  }
}

trait TransactionSetHeaderParser
