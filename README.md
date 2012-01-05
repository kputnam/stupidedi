# Stupidedi

Stupidedi is a high-quality library for parsing, generating, validating,
and manipulating ASC X12 EDI documents. Very roughly, it's jQuery for
EDI.

For those unfamiliar with ASC X12 EDI, it is a data format used to
encode common business documents like purchase orders, delivery
notices, and health care claims. It is similar to XML in some ways,
but precedes it by about 15 years; so if you think XML sucks, you
will love to hate EDI.

## What problem does it solve?

The motivation for developing Stupidedi was to implement HIPAA 5010
compliance for medical billing companies. This requires sending health
care claims to insurance carriers and receiving payments from them.

HIPAA transaction set specifications are enormous, boring, and vague.
These vague specifications provide ammunition for insurance carriers
to reject health care claims and deny payments. On the other hand,
carriers have little motivation to ensure the same level of conformance
in the receipts they generate, imposing a burden on payee to deal
with any deviations from the spec.

To state the problem simply, when *generating* X12 documents you need
to ensure strict conformance with tedious specifications. But when
*receiving* X12 documents you need to relax and gracefully handle
non-conforming documents.

## How does it solve the problem?

Specifications are represented as plain Ruby data structures, which
are analogous to an XML schema. Two levels of validation are achieved
by layering a DSL which performs extra validation on top of an otherwise
error-tolerant parser.

Significant thought was put into the design of the library. Some of
the features are described here.

### Highly robust tokenization and parsing

Delimiters, line breaks, and out-of-band data between interchanges are
handled correctly. While many trading partners follow common conventions,
it only takes one deviant, swapping the ":" and "~" delimiters, to render
your quick-and-dirty regexp parser useless.

### Instant feedback on error conditions

When generating EDI documents, validation is performed incrementally
on each segment. This means the instant your client code violates the
specification, an exception is thrown with a meaningful stack trace.
Other libraries only perform validation after the entire document has
been generated, while some don't perform validation at all.

### Encourages readable client code

### Highly efficient parsing and traversing

### Helps developers gain familiarity

## Why not use a commercial EDI translator?

Because enterprise software is garbage. The costs include not only
licensing, but support, maintenance, and training. Translators are
designed to convert EDI to some other format, like XML, CSV, or a
relational database. This doesn't achieve anything productive, as
we still have to unserialize the data to do anything with it.

## What doesn't it solve?

It isn't a translator. It doesn't have bells and whistles, like the
commercial EDI translators have, so it...

* Doesn't convert to/from XML, CSV, etc
* Doesn't transmit or receive files
* Doesn't do encryption
* Doesn't connect to your database
* Doesn't queue messages for delivery or receipt
* Doesn't generate acknowledgements
* Doesn't have a graphical interface

## Alternative libraries

Stupidedi is an opinionated library, and maybe you don't agree with
it. Here are a few alternative libraries:

* http://www.appdesign.com/x12parser/
* http://edi4r.rubyforge.org/edi4r/
* http://edival.sourceforge.net/
* http://www.edidev.com/
