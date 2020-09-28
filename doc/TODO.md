Optimization
* [x] Replace input[n] one-by-one with input.index(..)
* [x] Rewrite a, b, c = @a, @b, @c to three separate assignments (eliminate Array allocation)
* [x] Rewrite Regexp#=~(String) to String#=~(Regexp), which doesn't assign captures to \$1, etc
* [ ] Add stop_at parameter to linear scan NativeExt methods
* [ ] Consider using continuation passing style Tokenizer instead of Fail/Done
* [ ] Remove redundant `value.to_s` in SimpleElementDef.value implementations
* [ ] Single pass to find all delimiters, rather than one pass for each delimiter
  * [ ] NativeExt.scan(input, offset, length, "*:^~")
  * [ ] Hash["*" => [4,8,10,...], "~" => [16,22,...]]
  * [ ] InputMap.next("~*")  #=> 33
  * [ ] InputMap.advance(33)

Bugs
* [ ] TM with single-digit seconds value pretty prints as "07:58:0"

Testing
* [x] Test Tokenizer in isolation with specific inputs, composite, repetition, etc
* [*] Test Tokenizer with control characters
* [x] Port memory_profiler to Ruby 2.0 - 2.3
* [x] Test number of allocations for Slice and Substring operations
* [ ] Substring operations with unsupported character encoding
* [ ] Substring with invalid byte sequences or wrong character encoding
* [ ] Substring with UTF-8 and BOM
* [ ] Review/rewrite Quickcheck => QuickSpec

Coverage
* [ ] Code coverage for `#pretty_print(q)`, remove :nocov:
* [ ] Setup code coverage reporting https://docs.codeclimate.com/docs/travis-ci-test-coverage
* [ ] Setup code coverage reporting https://docs.travis-ci.com/user/coveralls/

Features
* [ ] Update bin/edi-obfuscate to work with tokenizer
* [ ] Detect when repeatable composite has repeatable components (ambiguity)
* [ ] Strict tokenization rules Tokenizer.build(strict: true)

Maintenance
* [ ] Parts of Stupidedi::Config belong in stupidedi-core and others in stupidedi-defs
* [ ] Split source into subdirectories per gem?
* [ ] Deal with Bundler 'gem "stupidedi", git: "..."' problems with gemspec
* [ ] Use two separate .yardopts? One for users, one for stupidedi devs
* [ ] Rake rake task for updating codepoints.h

Documentation
* [ ] Explain reading has only one-char separators, writing can have multi-char
* [ ] Effects of file/string encoding
* [ ] Dealing with Either (separate from Navigation.md)
* [ ] Using BuilderDsl
  - https://github.com/greenriver/hmis-warehouse/search?utf8=%E2%9C%93&q=BuilderDsl&type)
* [ ] How can I write my X12 to a file?
  - https://github.com/ManjuSagar/fs/blob/73535962df1f5ebbb17491ab077f6ed91d6b33b7/lib/generate_edi_file.rb#L8
* [ ] How can I read X12 from a file?
  - https://github.com/greenriver/hmis-warehouse/blob/master/app/models/health/premium_payment.rb#L76
  - https://github.com/ManjuSagar/fs/blob/73535962df1f5ebbb17491ab077f6ed91d6b33b7/lib/extracter_of_271.rb#L25
* [ ] How can I write my own grammar?
  - https://github.com/irobayna/stupidedi/compare/master...greenriver:820
  * [ ] How can I make sure it's correct?
  * [ ] How can I ensure it's not ambiguous?
  * [ ] How can I use automated fixture tests?
  * [ ] How can I contribute my grammar?
* [ ] Mention in README: building docs locally provides better details (with plugins)
* [ ] Mark @private and @nodoc after reviewing doc/_index.html
* [ ] Use @stupidedi.tagname for [project-specific tags](https://www.rubydoc.info/gems/yard/file/docs/Tags.md#Adding_Custom_Tags)
* [ ] Use @deprecated tag? Hide @deprecated from docs?
* [ ] Use @abstract on classes and methods
* [ ] Use @since <version> for each class and method?
* [ ] Use @overload for Pointer#[]
* [ ] Use (see OBJECT) to avoid repeating docs
* [ ] Use --hide-api @tag?
* [ ] Use @!parse include InstanceMethods, @!parse extend ClassMethods (?)
* [ ] Rewrite @group, @endgroup with @!group and @!endgroup
* [ ] Review specs to make sure 'Specifications' make sense in YARD (see Either)
* [ ] <code><pre>
    # @group Constructors
    #########################################################################
  not
    #########################################################################
    # @group Constructors
  </pre></code>

Misc
* [x] Rename Object#try, Object#tap, Object#bind to conform with Ruby stdlib
* [x] Remove all the crappy constants and methods in Stupdedi::Reader
