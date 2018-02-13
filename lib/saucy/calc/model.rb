require "saucy/calc/state"

module Saucy
  module Calc

    class Model

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

    end

  end
end