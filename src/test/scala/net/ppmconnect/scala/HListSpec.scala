import org.scalacheck._

/**
object StringSpec extends Properties("String") {
  import Prop.forAll

  property("startsWith")  = forAll((a: String, b: String) => (a + b).startsWith(a))
  property("endsWith")    = forAll((a: String, b: String) => (a + b).endsWith(b))
  property("concat")      = forAll((a: String, b: String) => (a + b).length == a.length + b.length)
  property("substring")   = forAll((a: String, b: String) => (a + b).substring(a.length) == b)
  property("substring")   = forAll((a: String, b: String) => (a + b).substring(0, a.length) == a)
  property("substring")   = forAll((a: String, b: String, c: String) => (a + b + c).substring(a.length, a.length + b.length) == b)
  property("substring")   = forAll((a: String, b: String, c: String) => (a + b + c).substring(a.length + b.length) == c)

}*/
