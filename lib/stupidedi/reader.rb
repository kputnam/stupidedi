# frozen_string_literal: true
module Stupidedi
  using Refinements

  module Reader
    autoload :Tokenizer,    "stupidedi/reader/tokenizer"
    autoload :SegmentDict,  "stupidedi/reader/segment_dict"
    autoload :Separators,   "stupidedi/reader/separators"
    autoload :Input,        "stupidedi/reader/input"
    autoload :Slice,        "stupidedi/reader/slice"
    autoload :Substring,    "stupidedi/reader/substring"
    autoload :NativeExt,    "stupidedi/reader/native_ext"
  end

  class << Reader
    # @group Constructors
    #########################################################################

    # @param  [String or Pathname or IO] input
    # @return [Tokenizer]
    def build(input, *args)
      if args.last.is_a?(Hash)
        keywords = {}
        keywords[:config] = args.last.delete(:config) if args.last.include?(:config)
        keywords[:strict] = args.last.delete(:config) if args.last.include?(:strict)
      else
        keywords = {}
      end

      Reader::Tokenizer.build(Reader::Input.build(input, *args), *keywords)
    end

    # @param  [String or Pathname or IO] path
    # @return [Tokenizer]
    def file(path, *args)
      if path.is_a?(String)
        build(Pathname.new(path), *args)
      else
        build(input, *args)
      end
    end

    # @endgroup
    #########################################################################
  end
end
