v 1.4.1

  **Bug Fixes**

  * Fix missing method delegations in SimpleElementUse, ComponentElementUse, and CompositeElementUse #185
  * Fix regression in edi-obfuscate
  * Fix copy-pasted StringVal -> IdentifierVal #187
  * Fix crash in 4010 editor, wrong method called #188
  * Fix bug in RepeatedElementVal#==, incorrect comparison #190
  * Fix error message when required composite element is missing #194
  * Fix various typos in comments and descriptor strings #230 and #233

  **Added**

  * Add DSL for defining X12 grammars TransactionSets::Builder::Dsl #200
  * Add support for 5010 X12-HN277 Health Care Information Status Notification
  * Add support for 5010 X220A1-BE834 BGN05 Time Code #205
  * Add support for "02 - Birth" maintenance reason code #209

v 1.4.0

  **Bug fixes**

  * Fix ambiguous grammars (mostly due to incorrect parentheses)
  * Fix errors in `Standards::FortyTen::HC837`
  * Fix errors in `Standards::FiftyTen::BE834`
  * Fix errors in `Standards::FiftyTen::HB271`
  * Fix errors in `Standards::FiftyTen::RA820`
  * Fix parsing invalid numeric data in Ruby 2.4+. Previously `"10B"` would be read as `10.0`, and `"AB10"` would be read as `0.0` due to using bigdecimal/util's implementation of `String#to_d`
  * Fix `TimeVal` issue in all versions (not only `005010`)

  **Added**

  * Add `Stupidedi::Parser.build` as a shortcut for `Stupidedi::Parser::StateMachine.build`
  * Add many stub definitions of segments, just the segment name and no elements, which are referred to by `RA820` and others.
  * `edi-pp` can now print different formats with `--format html`, `--format x12`, and `--format tree` (default)

  **Deprecation notices**

  * Remove support for Ruby < 2.0
  * Remove workarounds for broken JRuby refinements
  * Remove `Symbol#call` and `Symbol#to_proc` refinements

  **Renamed**

  * `Stupidedi::Builder` is renamed to `Stupidedi::Parser`
  * `Stupidedi::Guides::*::GuideBuilder` is renamed to `Stupidedi::TransactionSets::Builder`
  * `Stupidedi::Versions::Interchanges` is renamed to `Stupidedi::Interchanges`
  * `Stupidedi::Versions::FunctionalGroups` is renamed to `Stupidedi::Versions`
    * Lots of common code among versions has been factored into `Stupidedi::Versions::Common`
  * Rename Guides `HC837P` and `HC837I` to `HC837`
  * Moved all grammars, including `Guides` and `Contrib`, to `Stupidedi::TransactionSets`
    * Each version now has `::Standards` and `::Implementations`
  * `Stupidedi::Schema::Auditor` is renamed to `Stupidedi::TransactionSets::Validation::Ambiguity`

  Most of these renames are not breaking changes (yet), but using the old name will print a warning:

  ```
  Stupidedi::Contrib is deprecated, use Stupidedi::TransactionSets
  Stupidedi::Guides is deprecated, use Stupidedi::TransactionSets::*::Implementations
  Stupidedi::TransactionSets::FiftyTen::Implementations::X222::HC837P is deprecated, use HC837 instead
  Stupidedi::TransactionSets::FiftyTen::Implementations::X222A1::HC837P is deprecated, use HC837 instead
  Stupidedi::TransactionSets::FiftyTen::Implementations::X223::HC837I is deprecated, use HC837 instead
  Stupidedi::Versions::Interchanges is deprecated, use Stupidedi::Interchanges instead
  Stupidedi::Versions::FunctionalGroups is deprecated, use Stupidedi::TransactionSets::*::Standards instead
  ```

  **Specs**

  * Grammar specs automatically created when a fixture is added to spec/fixtures/<version>/<name>/pass/*.x12
  * Remove support for `rcov`. Use only `simplecov` now
  * Update all specs to use `expect(value).to matcher` syntax, instead of `value.should matcher`
  * New specs to ensure element names match their `id` (eg, `E123.id == :E123`)
  * New specs to ensure segment names match their `id` (eg `ST.id == :ST`)
  * New specs to ensure `Config.hipaa`, `Config.contrib`, and `Config.default` reference valid definitions
  * New specs for `Stupidedi::TransactionSets::Validation::Ambiguity`
  * Fix fixture files that used `\n` as a segment terminator but didn't have one after `IEA`

  **Miscellaneous**

  * Create new examples in `examples/` that demonstrate undocumented `IdentifierStack`, and more
  * Made whitespace and other formatting more consistent
  * `Stupidedi::TransactionSets::Builder.build` no longer requires a `TransactionSetDef` argument
  * Fix Travis CI to build older versions of Ruby < 2.3
  * Ignore large definition files in Code Climate

v 1.3.24
  - Fix repeatability test in Navigation#iterate
  - Adds implementation of June 2014 005010X223A3 (837I)
  - Fixes misplaced 2330H and 2330I loops. Fixes names for 2310 Occurrenc…

v 1.3.23 - Jan 10, 2019
  - Fix decimal values for TimeVal being coerced incorrectly https://github.com/irobayna/stupidedi/pull/151
  - Detect ambiguous grammar automatically https://github.com/irobayna/stupidedi/pull/153

v 1.3.22
  - Re-enable EC Segment on FifyTen group

v 1.3.21 - Dec 9, 2018 ** Breaking Changes **
  - Throw exception from #iterate if segment is not repeatable (fix #126) https://github.com/irobayna/stupidedi/pull/146
  - Configurable limit of non-determinism (fixes #129) https://github.com/irobayna/stupidedi/pull/145
  - Add utility to obfuscate data in X12 files https://github.com/irobayna/stupidedi/pull/147
  - Fix potential frozen string issues in pretty_print methods https://github.com/irobayna/stupidedi/pull/148
  - Remove erroneous code mappings from element definitions

v 1.2.20 - Oct 23, 2018
  - Json Writer functionality - Traverse stupidedit internal tree to a ruby hash
  - Ruby 2.5.3 support

v 1.2.19 - Oct 8, 2018
  - EDI 276 support - Health Care Claim Status Inquiry
    X212-HR276

v 1.2.18 -
  - SH856 rework
  - PR855 support (v4010)
  - This change fixes this issue, as if decimal is an empty string, it will be changed to 0 before to_d is called on it
    https://github.com/irobayna/stupidedi/pull/132
    Update  lib/stupidedi/versions/functional_groups/004010/element_types/time_val.rb


v 1.2.17 - Aug 4, 2018
  - EDI 270 / 271 support - Health Care Eligibility Benefit Inquiry and Response
    X279-HS270
    X279-HB271
    X279A1-HS270
    X279A1-HB271

v 1.2.16 - May 27, 2018
  - Fix item #127 (https://github.com/irobayna/stupidedi/issues/127)
  - Ruby 2.5.1 support

v 1.2.15 - Dec 20, 2017
  - Gemfile Updates (fix security vulnerability CVE-2017-17042)
  - Add Ruby 2.5.0-preview1 support
  - Add 2.4.3 & 2.5.0-preview1 ruby versions to Travis CI

v 1.2.14 - June 19, 2017
  - Gemfile Updates
  - use BigDecimal string refinement only on ruby versions < 2.4
  - remove rake from gemspec
  - Add Ruby 2.4.x support

v 1.2.12 - July 29, 2016
  - Fix a few issues with immutable strings

v 1.2.2 - July 8, 2014
  - Remove definition of module Enumerable::blank? and present?
  - Add blank?, present? to Array class

v 1.2.1 - July 7, 2014
  - Don't redefine 'blank?' for Enumerable, if an implementation already (rails support)

v 1.2.0 - July 7, 2014
  - Don't redefine try, if active_support provides an implementation already (better rails support)

v 1.1.0 - June 24, 2014
  - Rspec 3.x support
  - Drop Ruby 1.8.7 support
  - Add Ruby 2.1.2 support
