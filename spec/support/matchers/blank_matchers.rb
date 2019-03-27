using Stupidedi::Refinements

RSpec::Matchers.define :be_blank do
  match do |o|
    o.blank?
  end
end
