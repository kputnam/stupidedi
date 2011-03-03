#
# Used for numeric values that have a varying number of decimal positions. The
# value MAY contain an explicit decimal point. The decimal place always appears
# if it is at any place other than the right end. If the value is an integer,
# the decimal point should be OMITTED. For negative value, a leading minus sign
# is used. Absence of a sign indicates a positive value. The leading + sign
# should NOT be transmitted.
#
# Leading zeros should be supressed unless necessary to satisfy a minimum length
# requirement. Trailing zeros following the decimal point should be supressed
# unless necessary to indicate precision. The use of triad separators (eg 1,234)
# is PROHIBITED. The length of a decimal type does not include the optional
# leading sign or optional decimal point.
#
# @see X098 A.1.3.1.2
#

#           PATTERN = /\A[+-]?            (?# optional leading sign            )
#                      (?:
#                        (?:\d+\.?\d*)  | (?# whole with optional decimal or ..)
#                        (?:\d*?\.?\d+) ) (?# optional whole with decimal      )
#                     \Z/ix
