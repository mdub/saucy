module Saucy

  class Calc

    def initialize
      @state = State.new
    end

    def value
      state.value
    end

    def add(arg)
      apply(:add, arg)
    end

    def set(arg)
      apply(:set, arg)
    end

    def clear
      apply(:clear)
    end

    private

    attr_reader :state

    def apply(*change)
      @state = @state.apply(*change)
    end

    class State

      def initialize(value = 0)
        @value = value
      end

      attr_reader :value

      def apply(op, *args)
        raise "Unrecognised operation: #{op.type}" unless respond_to?(op)
        send(op, *args)
      end

      def add(arg)
        State.new(value + Float(arg))
      end

      def set(arg)
        State.new(Float(arg))
      end

      def clear
        set(0)
      end

    end

  end

end