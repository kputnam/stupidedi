Generating X12
==============

Stupidedi has a simple interface for generating X12 documents. Once you have
defined a transaction set or implementation guide (see [Defining](Defining.md)),
you can generate well-formed documents using [`Builder::BuilderDsl`][1].

  [1]: ../../Stupidedi/Builder/BuilderDsl.html

Configuration
-------------

Minimal configuration is needed so Stupidedi can load the correct definitions to
ensure well-formedness. The configuration below links interchange version 00501
to an instance of [`InterchangeDef`][2], and links the transaction set (identified
by three elements) to an instance of [`TransactionSetDef`][3].

  [2]: ../../Stupidedi/Envelope/InterchangeDef.html
  [3]: ../../Stupidedi/Envelope/TransactionSetDef.html

    config = Stupidedi::Config.new

    # Link the "00501" value in ISA12 element to the interchange definition
    config.interchange.register("00501") do
      Stupidedi::Dictionaries::Interchanges::FiveOhOne::InterchangeDef
    end

    # Link the "005010" value is GS08 to the functional group definition
    config.functional_group.register("005010") do
      Stupidedi::Dictionaries::FunctionalGroups::FiftyTen::FunctionalGroupDef
    end

    # Link "005010X222" in GS08 or ST03, "HC" in GS01, and "837"
    # in ST01 to the implementation guide definition
    config.transaction_set.register("005010X222", "HC", "837") do
      Stupidedi::Guides::FiftyTen::X222::HC837
    end

Generating a Segment
--------------------

The [`Builder::BuilderDsl`][1] API uses `method_missing` to dynamically respond
to method calls. If the method name matches the format of a segment identifier,
a segment is constructed and added to the parse tree. The arguments to the
method call should be the elements of the segment.

    b = Stupidedi::Builder::BuilderDsl.new(config)

    b.ISA("00", "",             # authorization information
          "00", "",             # authentication information
          "ZZ", "SUBMITTER ID", # submitter identification
          "ZZ", "RECEIVER ID",  # recipient identification
          Time.now.utc,         # date
          Time.now.utc,         # time
          "^",                  # repetition separator
          "00501",              # interchange version
          "333666999",          # control number
          "1",                  # acknowledgement request
          "T",                  # usage indicator
          "~")                  # segment terminator

Alternatively, the [`#segment!`][4] method can be used to avoid the overhead of
method lookup incurred by `method_missing`.

  [4]: ../../Stupidedi/Builder/BuilderDsl.html#segment!-instance_method

### Simple Elements

Simple elements of _any_ type can be constructed from Strings (this is how X12
is parsed from a file), but certain element types can be constructed from other
types of Ruby values.

The description of each element type below pertains to the `FiftyTen` functional
group definition. The `SimpleElementDef` and `SimpleElementVal` classes define
the minimal interfaces that are extended by subclasses like `AN` and `StringVal`.
See the [`FiftyTen::ElementTypes`][5] namespace for more examples.

  [5]: ../../Stupidedi/Dictionaries/FunctionalGroups/FiftyTen/ElementTypes.html

#### Strings

String elements (declared with type `AN`) can be constructed from any value that
responds to `#to_s`. The constructed element is a [`StringVal`][6].

  [6]: ../../Stupidedi/Dictionaries/FunctionalGroups/FiftyTen/ElementTypes/StringVal.html

#### Identifiers

Identifier elements (declared with type `ID`) can be constructed from any value
that responds to `#to_s`. The constructed element is an [`IdentifierVal`][7].

  [7]: ../../Stupidedi/Dictionaries/FunctionalGroups/FiftyTen/ElementTypes/IdentifierVal.html

#### Dates

Date elements (declared with type `DT`) can be constructed from a `String` of
either six or eight characters, and from any value that responds to `#year`,
`#month`, and `#day`. This includes the `Date`, `Time`, and `DateTime` classes
included with the standard Ruby libraries. The constructed element is a [`DateVal`][8].

  [8]: ../../Stupidedi/Dictionaries/FunctionalGroups/FiftyTen/ElementTypes/DateVal.html

#### Times

Time elements (declared with type `TM`) can be constructed from a `String` of
either two, four, six, or more than six characters, and from the `Time` and
`DateTime` values. The constructed element is a [`TimeVal`][9].

  [9]: ../../Stupidedi/Dictionaries/FunctionalGroups/FiftyTen/ElementTypes/TimeVal.html

#### Numbers

Numeric and decimal elements (declared with type `Nn` and `R`, respectively) can
be constructed from any value that responds to `#to_d`. The constructed element
is a [`NumericVal`][10] or [`DecimalVal`][11].

  [10]: ../../Stupidedi/Dictionaries/FunctionalGroups/FiftyTen/ElementTypes/NumericVal.html
  [11]: ../../Stupidedi/Dictionaries/FunctionalGroups/FiftyTen/ElementTypes/DecimalVal.html

### Composite Elements

Composite elements are constructed using the `#composite` method. The arguments
to the method call should be the component elements. For instance, to generate
an `HI` segment with three composite elements:

    b.HI(b.composite("ABK", "7868"),
         b.composite("ABF", "052"),
         b.composite("ABF", "E9283"))

### Repeated Elements

Repeated elements are constructed using the `#repeated` method. The arguments to
the method call should be either all simple elements or all composite elements,
according to the segment definition.

    b.AK9(b.repeated("R", "X", "E"), 1, 1, 0)

    b.IK4(b.repeated(
            b.composite(3, 1),
            b.composite(4)),
          1068, 7, "B")

Element Placeholders
--------------------

Because [`Builder::BuilderDsl`][1] builds a parse tree as segments are
generated, it can infer and validate certain information about the elements in
a segment.

### Blank Elements

Blank elements (simple, composite, and repeated) can be generated from a `nil`
argument, but you can improve readability by using `#blank`, and no-argument
calls to `#composite` and `#repeated`. These are arguably more self-documenting.

    b.AK9(nil, 1, 1, 0)
    b.AK9(b.repeated, 1, 1, 0)

    b.HI(nil, b.composite(b.blank, "052"))
    b.HI(b.composite, b.composite(b.blank, "052"))

Also, if fewer than the defined number of elements are given as arguments, the
missing arguments generate blank elements. For example, the following statements
both generate the same segment.

    b.ST("835", "1234")
    b.ST("835", "1234", b.blank)

### Default Elements

Certain elements are declared with a single value in [`#allowed_values`][13].
These are usually qualifier elements, like `NM102`, whose value adds little
readability. These values can be inferred by [`Builder::BuilderDsl`][1] when the
`#default` placeholder is used. For example, when generating the X222 837P, the
following statements generate the same segment.

    b.BHT("0019", "00", control_number, Time.now.utc, Time.now.utc, "CH")

    b.BHT(b.default, "00", control_number, Time.now.utc, Time.now.utc, "CH")

When a default value cannot be inferred, a [`ParseError`][12] is thrown. Note
that repeated and composite elements cannot be generated by `#default` -- only
simple and component elements.

  [12]: ../../Stupidedi/Exceptions/ParseError.html
  [13]: ../../Stupidedi/Schema/SimpleElementUse.html#allowed_values-instance_method

### Unused Elements

For elements that are declared to never be sent, `nil` or `#blank` will generate
the empty element; however using `#not_used` may be more self-documenting. If
`Builder::BuilderDsl` determines that the element is not declared as such, it
will raise a [`ParseError`][12]. For example the X221 835 document declares ST03
with `NOT USED`:

    b.ST("835", "1234", b.not_used)

Syntax Validation
-----------------

The parse tree that `Builder::BuilderDsl` maintains is used to ensure only
well-formed X12 is generated. This means segments occur in the correct order
and have the correct number and type of elements.

### Segment Order

The order in which segments may occur is defined by the [`TransactionSetDef`][3]
and [`InterchangeDef`][2]. Internally, an instance of [`Builder::StateMachine`][14]
is used to both incrementally build the parse tree and keep track of which
segments can occur from the given state. The `#successors` method will return
one or more [`InstructionTable`][15] values that enumerate the segments that may
occur in the current state:

    pp b.sucessors

    [InstructionTable(
      1: Instruction[REF: Subscriber Secon..](pop: 0, drop: 0),
      2: Instruction[REF: Property and Cas..](pop: 0, drop: 0),
      3: Instruction[PER: Property and Cas..](pop: 0, drop: 3),
      4: Instruction[NM1: Subscriber Name   ](pop: 1, drop: 0, push: LoopState),
      5: Instruction[NM1: Payer Name        ](pop: 1, drop: 0, push: LoopState),
      6: Instruction[CLM: Claim Informatio..](pop: 1, drop: 2, push: LoopState),
      7: Instruction[ HL: Subscriber Hiera..](pop: 2, drop: 0, push: LoopState),
      8: Instruction[ HL: Billing Provider..](pop: 3, drop: 0, push: TableState),
      9: Instruction[ HL: Subscriber Hiera..](pop: 3, drop: 0, push: TableState),
     10: Instruction[ HL: Patient Hierachi..](pop: 3, drop: 0, push: TableState),
     11: Instruction[ SE: Transaction Set ..](pop: 3, drop: 4, push: TableState),
     12: Instruction[ ST](pop: 4, drop: 0, push: TransactionSetState),
     13: Instruction[ GE: Functional Group..](pop: 4, drop: 2),
     14: Instruction[ GS](pop: 5, drop: 0, push: FunctionalGroupState),
     15: Instruction[IEA: Interchange Cont..](pop: 5, drop: 2),
     16: Instruction[ISA](pop: 6, drop: 0, push: InterchangeState))]

  [14]: ../../Stupidedi/Builder/StateMachine.html
  [15]: ../../Stupidedi/Builder/InstructionTable.html

The above output pertains to the X222 837 implementation guide. The output shows
a single active `InstructionTable` and the segments it is able to accept. For
more information about how the parser works, see the [Parser Design Document][16].
Attempting to generate a segment that is not a member of at least one of the
instruction tables will cause a [`ParseError`][12] to be raised.

    b.N3("SUITE 111", "1234 OCEAN BLVD")
    #=> Segment N3 cannot occur here (Stupidedi::Exceptions::ParseError)

  [16]: design/Parser.md

### Element Types

The [`InterchangeDef`][2] or [`TransactionSetDef`][3] classes both respond to
`#segment_dict`, which allows looking up a `SegmentDef` by segment identifier.
The `SegmentDef` indicates the number of elements and their types (composite,
repeated, simple).  This information allows `Builder::BuilderDsl` to raise a
[`ParseError`][12] on the following conditions:

Generating a composite element instead of a simple or repeated element:

    b.NM1(b.composite(nil, "B"), nil)
      #=> NM101 is a simple element (Stupidedi::Exceptions::ParseError)

Generating a simple element instead of a repeated or composite element:

    b.REF(nil, nil, nil, "D")
      #=> REF04 is a composite element (Stupidedi::Exceptions::ParseError)
    b.DMG(nil, nil, nil, nli, "E")
      #=> DMG05 is a repeatable element (Stupiedi::Exceptions::ParseError)
    b.DMG(nil, nil, nil, nil, b.repeated("E"))
      #=> DMG05 is a composite element (Stupidedi::Exceptions::ParseError)

Generating a repeated element instead of a composite or simple element:

    b.NM1(b.repeated("A", "B"))
      #=> NM101 is a simple element (Stupidedi::Exceptions::ParseError)

Generating too many elements:

    b.N3(nil, nil, nil)
      #=> N3 has only 4 elements (Stupidedi::Exceptions::ParseError)
    b.REF(nil, nil, nil, b.composite("A", "B", "C", "D", "E", "F", "G"))
      #=> REF04 has only 6 components (Stupidedi::Exceptions::ParseError)
