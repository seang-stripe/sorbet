# typed: true
# currently will fail in ruby and succeed in compiled mode.
class A
  class << self
    S = 1
  end
end
A::S
