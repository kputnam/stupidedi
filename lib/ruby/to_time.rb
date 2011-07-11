class Time
  unless method_defined?(:to_time)
    # @return [Time]
    def to_time
      self
    end
  end

  public :to_time

  class << self
    public :parse
  end
end

class String
  unless method_defined?(:to_time)
    def to_time
      Time.parse(self)
    end
  end

  public :to_time
end
