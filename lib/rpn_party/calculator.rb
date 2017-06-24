require 'rpn_party/errors'

module RPNParty
  class Calculator
    def initialize(calculation = '')
      @stack = []
      evaluate(calculation)
    end

    def result
      if @stack.empty?
        nil
      elsif @stack.length == 1
        @stack[0]
      else
        @stack
      end
    end

    def evaluate(calculation)
      calculation.split.map do |token|
        case token
        when /\A(?:\-)?\d+(?:\.\d+)?\z/
          @stack.push token.to_f
        when /\A\+\z/
          add
        when /\A\-\z/
          subtract
        when /\A\*\z/
          multiply
        when /\A\/\z/
          divide
        else
          raise UnrecognizedInputError,
            "Unrecognized value/operator: '#{token}'. Valid inputs are numbers (0, 1, 2.5, -3, etc.), or '+', '-', '*', '/'."
        end
      end
    end

    private

    def add
      raise_if_insufficient_operands :addition

      first_value, second_value = @stack.pop(2)
      @stack.push(first_value + second_value)
    end

    def subtract
      raise_if_insufficient_operands :subtraction

      first_value, second_value = @stack.pop(2)
      @stack.push(first_value - second_value)
    end

    def multiply
      raise_if_insufficient_operands :multiplication

      first_value, second_value = @stack.pop(2)
      @stack.push(first_value * second_value)
    end

    def divide
      raise_if_insufficient_operands :division
      raise_if_second_value_is_zero

      first_value, second_value = @stack.pop(2)
      @stack.push(first_value / second_value)
    end

    def raise_if_second_value_is_zero
      return unless @stack.last.zero?

      raise ZeroDivisionError,
        "Cannot divide #{@stack[-2]} by 0."
    end

    def raise_if_insufficient_operands(operation)
      return if @stack.length >= 2

      message = if @stack.empty?
                  "Could not perform #{operation}. At least two values are required, but there are none."
                else
                  "Could not perform #{operation}. At least two values are required, but there is only one: '#{@stack.first}'."
                end
      raise InsufficientOperandsError,
        message
    end
  end
end
