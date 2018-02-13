module Saucy

  class Calc

    def initialize
      @value = 0
    end

    attr_reader :value

    def add(arg)
      @value += Float(arg)
    end

    def set(arg)
      @value = Float(arg)
    end

    def clear
      set(0)
    end

  end

end