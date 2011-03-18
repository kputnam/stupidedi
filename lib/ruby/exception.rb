require "continuation" if RUBY_VERSION >= "1.9"

class Exception
  attr_accessor :continuation

  class NoContinuationError < StandardError; end

  def continue
    unless continuation.respond_to?(:call)
      raise NoContinuationError
    end

    continuation.call
  end
end

class Object
  # @private
  def raise(type = RuntimeError, message = nil, from = caller)
    exception = case type
                when String
                  RuntimeError.exception(type)
                when Exception then type
                else type.exception(message)
                end

    callcc do |cc|
      exception.set_backtrace(from)
      exception.continuation = cc
      super exception
    end
  end
end
