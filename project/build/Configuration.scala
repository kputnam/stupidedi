import sbt._

class Configuration(info: ProjectInfo) extends DefaultProject(info) {// with de.tuxed.codefellow.plugin.CodeFellowPlugin {

  val scalaToolsSnapshots = "Scala-Tools Maven2 Snapshots Repository" at
    "http://scala-tools.org/repo-snapshots"

  val specs      = "org.scala-tools.testing" % "specs_2.8.1" % "1.6.6" % "test"
  val scalacheck = "org.scala-tools.testing" % "scalacheck_2.8.1" % "1.8" % "test"
  val postgres   = "postgresql" % "postgresql" % "8.4-701.jdbc4"

  override def compileOptions = Optimise :: ExplainTypes :: Unchecked :: super.compileOptions.toList
}
