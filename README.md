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

Transaction set specifications can be enormous, boring, and vague.
Trading partners can demand strict adherence (often to their own unique
interpretation of the specification) of the documents you generate.
However, documents they generate themselves are often non-standard
and require flexibility to parse them.

Stupidedi enables you to encode these transaction set specifications
directly in Ruby. From these specifications, it will generate a parser
to read incoming messages and a DSL to generate outgoing messages. This
approach has a huge advantage of writing a parser from scratch, which
can be error-prone and difficult to change.

Significant thought was put into the design of the library. Some of
the features are described here.

### Highly robust tokenization and parsing

Delimiters, line breaks, and out-of-band data between interchanges are
handled correctly. While many trading partners follow common conventions,
it only takes one unexpected deviation, like swapping the ":" and "~"
delimiters, to render a hand-written parser broken.

Stupidedi handles many edge cases that can only be anticipated by reading
carefully between the lines of the X12 documentation.

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
licensing, but support, maintenance, and training.

Most importantly, commercial EDI translators solve a different set
of problems. Many focus on translating between EDI and another data
format, like XML, CSV, or a relational database. This isn't particularly
productive, as you still have to unserialize the data to do
anything with it.

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

These can be accomplished using other libraries or your own code.

## Alternative libraries

Stupidedi is an opinionated library, and maybe you don't agree with
it. Here are a few alternative libraries:

* http://www.appdesign.com/x12parser/
* http://edi4r.rubyforge.org/edi4r/
* http://edival.sourceforge.net/
* http://www.edidev.com/
