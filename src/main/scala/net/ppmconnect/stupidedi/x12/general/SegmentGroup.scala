package net.ppmconnect.edigen.x12
package general

import net.ppmconnect.scala.HList._

/**
 * SEGMENTS WITHIN A LOOP
 * 
 * Each instance of a loop (ie, a segment group; note that the header and summary areas
 * are segment groups as well) contains one or more segments.
 *
 * - Each segment within a loop structure is identified by its ordinal positioning within
 *   the complete transaction set definition. Each segment's order within the loop, relative
 *   to other segments within the loop, is defined by the sequential order of the ordinal
 *   positioning identfiers.
 *
 * - The beginning segment of a loop defines an instance of a loop. For any instance of a
 *   transaction set, for any loop with any area of that transaction set, the first occurence
 *   of the beginning segment of the loop will identify the first instance of the loop, the
 *   second will identify the second instance, etc.
 *
 * Each instance of a loop shall be considered the parent structure of any segments
 * enclosed within the boundaries of the loop (the first and last segments, inclusive,
 * of the loop, per the transaction set definitions).
 *
 * Each instance of a segment shall be considered the parent structure of any elements used
 * in that segment, as allowed by the segment definition.
 *
 **
 * An ordered group of segments (more than one) within a transaction set is identified as
 * a segment group. In the definition of a transaction set, segment groups are identified
 * by the following: the entire transaction set, each area of the transaction set, the segments
 * in an area not inside the loops in that area, all of the segments of a loop or nested
 * loop, and those segments in a loop not inside nested loops within that loop.
 *
 * Segments in a transaction set may be repeated as individual segments or as undelimited
 * or delimited loops.
 *
 * <segmentGroup> ::= {<segment>} | <segmentLoop> | <boundedLoop>
 * <segmentLoop>  ::= <beginningSegment> {<segment> | <segmentGroup>}
 * <boundedLoop>  ::= <loopStartSegment(LS)> <segmentLoop> {<segmentLoop>} <loopEndSegment(LE)>
 *
 * When segments are combined to form a transaction set, three characteristics shall be
 * applied to each segment in that usage: a requirement designator, a position in the
 * transaction set definition, and a maximum occurence. The ordinal positions of the segments
 * in a transaction set are explicitly specified for that transaction set. The positioning
 * shall be maintained during transmission.
 *
 * A transaction set's segment order shall be defined such that sequential processing of
 * any legitimate instance of the transaction set will result in positive identification
 * of each segment in terms of its ordinal position in the standard. Positive identification
 * shall accordingly be made on the basis of segment identifiers alone, with the exception
 * of the LS and LE segments, where the identification is made using the segment identifier
 * in conjunction with the loop ID.
 *
 * Positive identification shall not depend on a segment's requirement designator or maximum
 * occurrences.
 *
 **
 * A segment group may be repeated in a transaction set instance, if permitted by the
 * transaction set definition. Such an ordered group is called a loop. Note that each
 * instance of a loop is a segment group
 *
 * Loops are groups of two or more semantically related segments. In use, in the actual
 * data stream, a loop may appear as only the loop beginning segment. Segment loops
 * may be bounded or unbounded.
 *
 * A loop may contain a loop. This condition is referred to as nesting. In a transaction
 * set definition, a loop whose first segment appears after the first segment of an
 * immediately preceeding loop and whose last segment appears no later than the last
 * segment of that preceeding loop is a nested loop within that preceeding loop.
 *
 * HL-INITIATED LOOPS: A looping structure in a transaction set definition may begin
 * with an HL segment. When used in any transaction set instance, successive occurrences
 * of the HL structure could indicate a parent-child relationship among the occurrences.
 * the HL segment therefore allows the identification of an explicit nested loop in a
 * transaction set. This nesting is not identified in the transaction set definition, but
 * rather in the instance of the loop, in the data of the HL segment. All semantic
 * relationships that apply to nested loops will apply equally to relationships between
 * an HL-initiated parent loop and its HL-initiated child loops.
 *
 *
 * If and only if the beginning segment of a loop is Mandatory (M), then
 * the loop is also mandatory.
 *
 * The beginning segment in the loop may not occur in another position within
 * the loop, nor may it occur within a child loop.
 */
trait SegmentDefinitionGroup {
  type SegmentDefinitions <: HCons[_, _]
  def segments: SegmentDefinitions
}

trait SegmentInstanceGroup {
  type SegmentDefinitions <: HCons[_, _]
  def segments: SegmentDefinitions
}
