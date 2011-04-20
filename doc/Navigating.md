Navigating the Parse Tree
=========================

Fundamentally, the [`StateMachine`][1] presents an interface for iterating the
syntax tree as if it were merely a sequence of segments. Purely syntactical
values like [`LoopVal`][2]s and [`TableVal`][3]s are hidden from the programmer.
While the interface only exposes segments and elements, the information hidden
by [`StateMachine`][1] provides an efficient means to search the parse tree for
specific segments.

For information on how to construct a parse tree programmatically, see the
document on [Generating X12](Generating.md). The [`StateMachine`][1] can be
accessed via the [`BuilderDsl#machine`][4] method. For information about how
to construct a parse tree from an input stream, see [Parsing X12](Parsing.md).

  [1]: ../../Stupidedi/Builder/StateMachine.html
  [2]: ../../Stupidedi/Values/LoopVal.html
  [3]: ../../Stupidedi/Values/TableVal.html
  [4]: ../../Stupidedi/Builder/BuilderDsl.html#machine-instance_method

One Segment at a Time
---------------------

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

You may be wondering why the [`SegmentVal`][5] is wrapped by two layers. The
first, [`Either`][8], provides a manner to distinguish error return values from
normal return values. It is more sophisticated and less error-prone than using
conventions like returning `nil` on failure, because it supports chaining, 
detailed error information can be returned, and the risk of neglecting to test
for an error is mitigated.

The [`Either`][8] value wraps an [`AbstractCursor`][7], which points to the
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
    machine.segment.each do |s|
      puts "Hello, #{s.node.id}"
    end

  [5]: ../../Stupidedi/Values/SegmentVal.html
  [6]: ../../Stupidedi/Builder/StateMachine.html#segment-instance_method
  [7]: ../../Stupidedi/Zipper/AbstractCursor.html
  [8]: ../../Stupidedi/Either.html


### Going Forward

The [`#next`][9] method returns a [`StateMachine`][1] positioned at the segment
immediately following the current segment. Optionally, you may specify how many
segments to advance, which defaults to `1`.

    # Success
    machine.next
      #=> Either.success(StateMachine[1](SegmentVal[GS](...)))

    # Success
    machine.next(3)
      #=> Either.success(StateMachine[1](SegmentVal[BHT](...)))

    # Failure
    machine.next
      #=> Either.failure("cannot move to next after last segment")

  [9]: ../../Stupidedi/Builder/Navigation.html#next-instance_method

### Going Backward

The [`#prev`][10] method returns a [`StateMachine`][1] positioned at the segment
immediately preceeding the current segment. Optionally, you may specify how many
segments to rewind, which defaults to `1`.

    # Success
    machine.prev
      #=> Either.success(StateMachine[1](SegmentVal[GS](...)))

    # Success
    machine.prev(2)
      #=> Either.success(StateMachine[1](SegmentVal[ISA](...)))

    # Failure
    machine.prev
      #=> Either.failure("cannot move to prev before first segment")

  [10]: ../../Stupidedi/Builder/Navigation.html#prev-instance_method

Accessing Elements
------------------

Elements can be accessed using the [`#element`][11] method, which accepts up to
three numeric arguments and requires at least one. Like [`#segment`][6], the
return value is a [`AbstractCursor`][7] wrapped by an [`Either`][8].

  [11]: ../../Stupidedi/Builder/Navigation.html#element-instance_method

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
component, call `#element(1, n)` which will return the `nth` `SimpleElementVal`.
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
`nth` occurrence if it exists. If the element is a repeating *composite* element,
an optional third argument can be given to select a specific component. Beware
that [`#element`][11] will raise an `ArgumentError` if, for instance, you try to
access the sixth occurrence when the element definition declares the element can
occur a maximum of five times.

Making Bigger Jumps
-------------------

### First Segment

You can position the [`StateMachine`][1] at the first segment in the parse tree
by calling [`#first`][12]. When there are no segments in the parse tree, this
method returns a failure. This will typically position the [`StateMachine`][1]
at the first `ISA` segment.

  [12]: ../../Stupidedi/Builder/Navigation.html#first-instance_method

### Last Segment

Likewise, the [`#last`][13] method will position the [`StateMachine`][1] at the
first segment in the parse tree if there is one. When the parse tree is empty,
a failure is returned instead. This will typically position the [`StateMachine`][1]
at the last `IEA` segment.

  [13]: ../../Stupidedi/Builder/Navigation.html#last-instance_method

### Searching for Segments

The [`#find`][14] method performs an efficient context-sensitive search based
on the current position. 

<iframe src="images/837P-links.png" frameborder="no" scrolling="yes" height="500" width="100%"></iframe>

*Diagram of an X222 HC 837: Professional Claim. Darker boxes represent
`SegmentVal`s, and lighter boxes represent purely syntactical nodes. Note
each segment from ST onward has a dashed line to SE, which is not drawn;
each segment from GS onward has a dashed line to GE, which is not drawn;
each segment from ISA onward has a dashed line to IEA, which is not drawn.*

  [14]: ../../Stupidedi/Builder/Navigation.html#find-instance_method

#### Element Constraints

#### Syntactic Constraints

### Chaining Method Calls

### Parent Segment

While the navigation interface presents the syntax tree as a flat sequence of
segments, the underlying tree structure makes it possible to rewind to the first
segment of a parent structure. This may be the first segment of a loop, table,
functional group, or interchange (note transaction sets are never have segments
as children).

<iframe src="images/837P-parents.png" frameborder="no" scrolling="yes" height="500" width="100%"></iframe>
