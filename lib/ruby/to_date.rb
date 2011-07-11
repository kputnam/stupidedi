class Time
  unless method_defined?(:to_date)
    def to_date
      Date.civil(year, month, day)
    end
  end

  public :to_date
end

class String
  unless method_defined?(:to_date)
    def to_date
      Date.parse(self)
    end
  end

  public :to_date
end

class Date
  unless method_defined?(:to_date)
    def to_date
      self
    end
  end

  public :to_date

  class << self
    public :parse
  end
end
