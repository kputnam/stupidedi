/**
 * HIERARCHY OF SEMANTIC LEVELS
 *
 * The following graph is a summary of the levels outlined in the rest of this file, and the
 * annotation in the right column indicates which attributes uniquely identify each instance
 * in adjacent levels.  Note that in the case of multiple detail areas, and with respect to loops
 * and segments, the transaction set must allow a means of uniquely identifying each instance.
 *                 __________________
 *                (____Interchange___)                              Interchange Sender/Receiver IDs (ISA06, ISA08) and Interchange Control Number
 *                   |          |
 *     _____________ |___    ___|___________________________
 *    (_Functional_Group_)  (__Interchange_Control_Segment__)       Application Sender/Receiver Codes (GS02, GS03) and Group Control Number (GS06)
 *              |
 *       _______|___________________
 *      (______Transaction_Set______)                               Transaction Set Code (ST01) and Control Number (ST02)
 *                |               |
 *       _________|__________    _|____________
 *      (____Heading_Area____)  (_Summary_Area_)                    Table designator
 *        |                 |     |       |
 *        |  _____________  |     |       |
 *        | (_Detail_Area_) |     |       |                         Table designator
 *        |   |     |       |     |       |
 *        |   |    _|_______|_____|_      |
 *        |   |   (______Loop_______)     |                         Loop name
 *        |   |           :        |      |
 *        |   |     ______:______  |      |
 *        |   |    (_Nested_Loop_) |      |                         Loop name
 *        |   |           |        |      |
 *       _|___|___________|________|______|_
 *      (______________Segment______________)                       Segment position number
 *                   |            |
 *         __________|__________  |
 *        (__Composite_Element__) |
 *                        |       |
 *                   _____|_______|____
 *                  (__Simple Element__)
 */
