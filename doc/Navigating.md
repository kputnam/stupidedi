Navigating the Parse Tree
=========================

Fundamentally, the [`StateMachine`][1] presents an interface for iterating the
syntax tree as if it were merely a linear sequence of segments. Purely
syntactical values like [`LoopVal`][2]s and [`TableVal`][3]s are hidden from the
programmer.  While the interface only exposes segments and elements, the
information hidden by [`StateMachine`][1] provides an efficient means to search
the parse tree for specific segments.

For information on how to construct a parse tree programmatically, see the
document on [Generating X12](Generating.md). The [`StateMachine`][1] can be
accessed via the [`BuilderDsl#machine`][4] method. For information about how
to construct a parse tree from an input stream, see [Parsing X12](Parsing.md).

  [1]: Stupidedi/Builder/StateMachine.html
  [2]: Stupidedi/Values/LoopVal.html
  [3]: Stupidedi/Values/TableVal.html
  [4]: Stupidedi/Builder/BuilderDsl.html#machine-instance_method

Iterating Segments
------------------

### Current Segment

When you want to access the current [`SegmentVal`][5], use the [`#segment`][6]
method. It returns an [`AbstractCursor`][7], which is a read-only pointer to the
current segment within the parse tree, wrapped by [`Either`][8]. When the parse
tree is empty, a failure will be returned.

    # Success
    machine.segment
      #=> Either.success(#<Zipper::AbstractCursor ...>)

    # Failure
    machine.segment
      #=> Either.failure("not a segment")

You may be wondering why the [`SegmentVal`][5] is wrapped by two wrappers. The
first, [`Either`][8], provides a manner to distinguish error return values from
normal return values. It is more sophisticated and less error-prone than using
conventions like returning `nil` on failure, because it supports chaining,
detailed error information can be returned, and the risk of neglecting to test
for an error is mitigated.

This [`Either`][8] value wraps an [`AbstractCursor`][7], which points to the
[`SegmentVal`][5] via its `#node` method. Because [`SegmentVal`][5] does not
have information about its parent or siblings (it only is aware of its
`#children`), returning only a [`SegmentVal`][5] does not always provide enough
information. The [`AbstractCursor`][7], on the other hand, allows access to any
related `AbstractVal` node.

    # Success
    machine.segment.map(&:node)
      #=> Either.success(SegmentVal[IEA](...))

    machine.segment.map(&:parent).map(&:node)
      #=> Either.success(InterchangeVal[00501](...))

    # Failure
    machine.segment.map(&:node)
      #=> Either.failure("not a segment")

For another example, the current segment identifier can be accessed like any
other method of [`SegmentVal`][5].

    # When machine.segment fails, nothing is printed
    machine.segment.tap do |s|
      puts "Hello, #{s.node.id}"
    end

  [5]: Stupidedi/Values/SegmentVal.html
  [6]: Stupidedi/Builder/Navigation.html#segment-instance_method
  [7]: Stupidedi/Zipper/AbstractCursor.html
  [8]: Stupidedi/Either.html


### Going Forward

The [`#next`][9] method returns a [`StateMachine`][1] positioned at the segment
immediately following the current segment. Optionally, you may specify how many
segments to advance, which defaults to `1`. You can check if the current segment
is the last segment using the `#last?` method.

    # Success
    machine.last?
      #=> false

    machine.next
      #=> Either.success(StateMachine[1](SegmentVal[GS](...)))

    # Success
    machine.next(3)
      #=> Either.success(StateMachine[1](SegmentVal[BHT](...)))

    # Failure
    machine.last?
      #=> true

    machine.next
      #=> Either.failure("cannot move to next after last segment")

  [9]: Stupidedi/Builder/Navigation.html#next-instance_method

### Going Backward

The [`#prev`][10] method returns a [`StateMachine`][1] positioned at the segment
immediately preceeding the current segment. Optionally, you may specify how many
segments to rewind, which defaults to `1`. You can check if the current segment
is the first segment using the `#first?` method.

    # Success
    machine.first?
      #=> false

    machine.prev
      #=> Either.success(StateMachine[1](SegmentVal[GS](...)))

    # Success
    machine.prev(2)
      #=> Either.success(StateMachine[1](SegmentVal[ISA](...)))

    # Failure
    machine.first?
      #=> true

    machine.prev
      #=> Either.failure("cannot move to prev before first segment")

  [10]: Stupidedi/Builder/Navigation.html#prev-instance_method

Accessing Elements
------------------

Elements can be accessed using the [`#element`][11] method, which accepts up to
three numeric arguments and requires at least one. Like [`#segment`][6], the
return value is a [`AbstractCursor`][7] wrapped by an [`Either`][8].

  [11]: Stupidedi/Builder/Navigation.html#element-instance_method

### Simple Elements

To access the first element of the current segment, call `#element(1)`. Notice
elements are counted starting at `1`, not `0`. Beware that [`#element`][11] will
raise an `ArgumentError` if you attempt to access the fifth element of a segment
whose declaration only indicates four elements, for instance.

    # Success
    machine.element(1).map(&:node)
      #=> Either.success(Nn.value[  I16: Number of Included Functional Groups](1))

    # Error
    machine.element(3).map(&:node)
      #=> IEA has only 2 elements (ArgumentError)

### Composite Elements

If the first element of the current segment is a `CompositeElementVal`, calling
`#element(1)` will return the entire composite value. To access a specific
component, call `#element(1, n)` which will return the *nth* `SimpleElementVal`.
Beware that [`#element`][11] will raise an `ArgumentError` if you attempt, for
instance, to access the third component of a composite whose declaration only
indicates two components.

    # Success
    machine.element(5).map(&:node)
      #=> Either.success(CompositeElementVal[C023: HEALTH CARE SERVICE LOCATION INFORMATION](...))

    # Success
    machine.element(5, 1).map(&:node)
      #=> Either.success(AN.value[E1331: Place of Service Code](11))

    # Error
    machine.element(5, 4).map(&:node)
      #=> CLM05 has only 3 components (ArgumentError)

### Repeated Elements

When the first element of the current segment is a `RepeatedElementVal`, calling
`#element(1)` will return the entire sequence of element vals. To access a
specific occurrence of the element, call `#element(1, n)` which will return the
*nth* occurrence if it exists. If the element is a repeating *composite* element,
an optional third argument can be given to select a specific component. Beware
that [`#element`][11] will raise an `ArgumentError` if, for instance, you try to
access the sixth occurrence when the element definition declares the element can
occur a maximum of five times.

Taking Bigger Steps
-------------------

### First Segment

You can position the [`StateMachine`][1] at the first segment in the parse tree
by calling [`#first`][12]. When there are no segments in the parse tree, this
method returns a failure. This will typically position the [`StateMachine`][1]
at the first `ISA` segment.

    machine.first.map(&:first?)
      #=> Either.success(true)

  [12]: Stupidedi/Builder/Navigation.html#first-instance_method

### Last Segment

Likewise, the [`#last`][13] method will position the [`StateMachine`][1] at the
first segment in the parse tree if there is one. When the parse tree is empty,
a failure is returned instead. This will typically position the [`StateMachine`][1]
at the last `IEA` segment.

    machine.last.map(&:last?)
      #=> Either.success(true)

  [13]: Stupidedi/Builder/Navigation.html#last-instance_method

### Searching for Segments

The [`#find`][14] method performs an efficient context-sensitive search based
on the current position. Being context-sensitive places restrictions on which
segments are reachable from the current state, unlike iterating segments one
at a time. These restrictions prevent complicated problems, like mistakenly
finding an `NM1` segment from the next interchange because there were no more
`NM1` segments in the current interchange.

The *next* matching segment is returned, or a failure if no segments matched.
Searching for a segment that, according to the definition tree, cannot exist or
is not reachable will cause [`#find`][14] to raise an exception. To be clear,
[`#find`][14] only searches *forward* for segments, not backward.

#### Sibling Segments

<iframe src="images/837P-siblings.png" frameborder="no" scrolling="yes" height="430" width="100%"></iframe>

Segments connected directly by a horizontal dashed black line are siblings and
are reachable using [`#find`][14]. For instance, from the third `NM1`, the `N3`,
`N4`, and `REF` segments are reachable.

    # From 2000AA NM1 right one segment to N3
    machine.find(:N3)
      #=> Either.success(StateMachine[1](N3(...)))

    # Right two segments to N4
    machine.find(:N4)
      #=> Either.success(StateMachine[1](N4(...)))

    # Right three segments to REF
    machine.find(:REF)
      #=> Either.success(StateMachine[1](REF(...)))

Likewise, `N4` and `REF` are reachable from `N3`; however, the third `NM1` is
_not_ reachable from `N3` because it preceeds `N3`.

#### Uncle Segments

Segments that occur as siblings of an ancestor node are uncles (remember that
[`#find`][14] only proceeds forward). Common uncle segments are `GE` and `IEA`,
which are analogous to "closing tags" for envelope structures. Other examples
include the `IK5` and `AK9` segments from the *999 Functional Acknowledgement*
transaction set.

    # From BHT ascend twice and move left to GE
    machine.find(:GE)

    # From PRV ascend four times and move left to IEA
    machine.find(:IEA)

Uncles are relatively rare in X12 transaction sets, because most child
structures, like loops, are _not_ wrapped by segments at both ends. For instance
there are no segments in Loop 2000A that follow the child loops.

#### Nephew Segments

<iframe src="images/837P-nephews.png" frameborder="no" scrolling="yes" height="450" width="100%"></iframe>

Segments that occur as the _first_ direct child of a sibling node are nephews.
The siblings that _follow_ the first child are not directly reachable, but they
can be reached indirectly by [chaining](#Chaining_Method_Calls) two calls to
[`#find`][14]. For example, `GS` is a nephew of `ISA`, and `ST` has two nephews
named `NM1`; but `BHT` is _not_ a nephew of `GS` because it is not the first
child of its parent node.

    # From ST move left twice and down to NM1
    machine.find(:NM1)

    # From 2000A PRV move left and down to NM1
    machine.find(:NM1)

    # From 2300 CLM move left three times and down to NM1
    machine.find(:NM1)

The first-child restriction prevents potential problems of ambiguity with
certain grammars. Consider the possibility that Table 1 could be defined to
have a 1100 `PER` loop in addition to its two `NM1` loops. From the `ST`
segment, without the restriction, there would be two possibly reachable `PER`
segments.  One is the sibling of 1000A `NM1`, and the other is the 1100 `PER`
that we made up. Because [`#find`][14] returns the first matching segment, it
would return 1000A `PER` if it occurred, otherwise it would return the 1100
`PER`. The caller would have to check which one it was -- the necessity of this
test is not apparent without studying the grammar. Changing the grammar to add
Loop 1100 would break existing code. The first-child restriction solves these
problems.

#### Cousin Segments

<iframe src="images/837P-cousins.png" frameborder="no" scrolling="yes" height="470" width="100%"></iframe>

Segments that occurr as the _first_ child of a sibling of the parent node are
cousins of the current segment. Similar to the restriction on nephew segments,
siblings that follow the first child are _not_ directly reachable. For example,
the second `NM1` is a cousin of the first `NM1` and `PER` segments, the 2000AB
`NM1` is a cousin of all segments in Loop 2000AA, and each `HL` is a cousin of
all segments in Table 1.

    # From 1000A PER to 2000A HL
    machine.find(:HL)

    # From 2000BA NM1 to 2000BB NM1
    machine.find(:NM1)

You may have noticed, in some cases there are more than one cousin with the same
segment identifier -- there are three cousins of `BHT` named `HL`, for instance.
See [Element Constraints](#Element_Constraints) for information on how to find a
*specific* occurrence of `HL` segment based on its qualifier elements, or
[Chaining Method Calls](#Chaining_Method_Calls) for details on iterating each
`HL` segment, one-at-a-time.

#### Parent Segments

<iframe src="images/837P-parents.png" frameborder="no" scrolling="yes" height="450" width="100%"></iframe>

Internal knowledge of the underlying tree structure makes it possible to
*rewind* to the first segment of a parent structure, using the [`#parent`][15]
method. The parent may be the first segment of a loop, table, functional group,
or interchange, but never a transaction set, because they do not parent segments
directly.

    # From PRV up two nodes, left one node, and down to ST
    machine.parent

    # From PER left one node to NM1
    machine.parent

Traversing to the parent segment, unlike [`#find`][14], always traverses
backwards in the sequence of segments. The [`#parent`][15] method can only
rewind to the segment defined by the grammar, so it will always find the same
segment from a given starting position.

  [15]: Stupidedi/Builder/Navigation.html#parent-instance_method

#### Element Constraints

Finding the next segment by identifier alone is often not specific enough. For
example, there are several different `NM1` segments that each have a different
meaning -- one is a provider, another is the insurance company, another is the
patient, etc. In the case of `NM1`, the first element is a qualifier that
indicates the meaning. To find `NM1*QC` "Patient Name", you can iterate the
reachable `NM1` segments and stop when you find the occurrence whose first
element equals `41` or when there are no more `NM1` occurrences,

    # Find the NM1 occurrence with "41" in the first element
    position  = Either.success(machine)
    searching = true

    while searching and position.defined?
      # Move position to the next NM1 segment
      position = position.flatmap{|m| m.find(:NM1) }

      # Check the constraint
      position.tap do |nm1|
        nm1.element(1).tap do |element|
          # Stop the while loop if we found the match
          searching = element.node != "QC"
        end
      end
    end

    # Success
    searching
      #=> false
    position
      #=> Either.success(StateMachine[1](SegmentVal[NM1](...)))

    # Failure
    searching
      #=> true
    position
      #=> Either.failure("NM1 segment does not occur")

There is a much simpler and less error-prone way, however. The [`#find`][14]
method accepts a variable number of filter arguments. For instance, the above
filter can be accomplished by calling,

    machine.find(:NM1, "QC")

Multiple constraints can be specified and `#blank` or `nil` should be used to
indicate a wildcard, if needed. For instance to find the `NM1*PR` "Payer Name"
that has a certain organization name in element `NM103`,

    machine.find(:NM1, "PR", nil, "MEDICARE")

#### Syntactic Constraints

In addition to improving readability, [`#find`][14] checks the validity of your
element constraints and raises an exception when you ask for something that is
guaranteed never to occur in a valid parse tree. For instance, if you called
`#find(:NM1, "XX")` from a position where there are no reachable `NM1` segments,

    machine.find(:NM1, "XX")
      #=> NM1 segment cannot be reached from the current state (ArgumentError)

Or from a position where every reachable `NM1` segment is defined such that
`"XX"` is not allowed,

    machine.find(:NM1, "XX")
      #=> "XX" is not allowed in NM101 (ArgumentError)

  [14]: Stupidedi/Builder/Navigation.html#find-instance_method

### Chaining Method Calls

The [`Either`][8] datatype allows chaining via the [`#map`][16], [`#or`][18],
[`#flatmap`][17], and [`#tap`][19] methods. The use of each method is
demonstrated in the following examples.

#### Map

The [`#map`][16] method transforms one `Either.success` into another
`Either.success`. It leaves `Either.failure` values unaltered, passing
them through.

    result = machine.find(:REF).map do |ref|
      # When a REF segment was found, this block is
      # executed. The return value of this block is
      # wrapped by Either.success. If a REF segment
      # was not found, this block is not executed and
      # the Either.failure is propogated by #map
      ref.id
    end

    # Briefer syntax, implementing Symbol#to_proc
    machine.find(:REF).map(&:id)
      #=> Either.success(:REF)

    machine.find(:REF).map(&:id).map(&:to_s)
      #=> Either.success("REF")

    machine.find(:REF).map(&:id).map(&:to_s).map(&:length)
      #=> Either.success(3)

#### Flatmap

To transform one `Either.success` into another `Either`, which may be a success
or failure, use the [`#flatmap`][17] method. Like [`#map`][16], it also leaves
`Either.failure` values unaltered. This is an important technique to traverse
the parse tree. For instance, the following shows how to locate the "Billing
Provider Organization" of the first claim in the parse tree.

    machine.first.
      flatmap{|x| x.find(:GS)                 }.
      flatmap{|x| x.find(:ST)                 }.
      flatmap{|x| x.find(:HL, nil, nil, "20") }.
      flatmap{|x| x.find(:NM1, "85")          }.
      flatmap{|x| x.element(3)                }.
      map(&:node)
      #=> Either.success(AN.value[E1035: Billing Provider Last or Organizational Name](BEN KILDARE SERVICE))

To iterate a sequence of segments with the same identifier, use the
[`#flatmap`][17] method,

  # Find the first HL segment
  position = machine.first.
    flatmap{|x| x.find(:GS) }.
    flatmap{|x| x.find(:ST) }.
    flatmap{|x| x.find(:HL) }

  while position.defined?
    position = position.flatmap do |hl|
      # Process the HL segment
      ...

      # Find the next HL segment
      hl.find(:HL)
    end
  end

Note that the value returned by the block given to [`#flatmap`][17] must return
an instance of `Either` or a `TypeError` will be raised. The [`Object#try`][20]
method is similar to [`#flatmap`][17] in many ways.

#### Side Effects

In cases where you do not want to transform the `Either` value, but only need to
execute a side effect on `Either.success`, the [`#tap`][19] method is suitable.
On `Either.success` values, it passes the wrapped value to the block and returns
the original value, and it passes `Either.failure` values along without calling
the block.

    # Record GS06 Group Control Number
    machine.first.flatmap{|x| x.find(:GS) }.tap do |gs|
      # The return value of this block is discarded
      gs.element(6).tap do |control|
        @numbers << control.node.to_s
      end
    end #=> Either.success(StateMachine[1](SegmentVal[GS](...)))

    # Contrived example
    machine.first.
      flatmap{|x| x.find(:GS) }.tap{|x| puts "Hi, GS" }
      flatmap{|x| x.find(:ST) }.tap{|x| puts "Hi, ST" }
      #=> Either.success(StateMachine[1](SegmentVal[ST](...)))

The [`Object#tap`][21] method is similar to [`Either#tap`][19] except `#tap`
always calls the block, even on `nil`, while `#tap` does not call the block
on `Either.failure` values.

#### Error Recovery

When a method call earlier in the chain returns a `Either.failure`, the error
will be propogated through the chain unless it the [`#or`][18] method is used to
recover from the error.

    result = machine.find(:ST).map do |st|
      st.class
    end.or do |reason|
      # This block is executed if #find failed. The
      # block must return an instance of Either, or
      # a TypeError will be raised
      Either.success(FalseClass)
    end

    # Result is guaranteed to be Either.success because
    # of the block given to #or. The wrapped value then
    # is StateMachine or FalseClass
    result.defined?
      #=> true

  [16]: Stupidedi/Either.html#map-instance_method
  [17]: Stupidedi/Either.html#flatmap-instance_method
  [18]: Stupidedi/Either.html#or-instance_method
  [19]: Stupidedi/Either.html#tap-instance_method
  [20]: Object.html#try-instance_method
  [21]: Object.html#tap-instance_method
