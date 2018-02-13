module Saucy
  module Calc

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
