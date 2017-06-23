class RPNParty
  def initialize(calculation = '')
    @stack = []
    evaluate(calculation)
  end

  def result
    if @stack.length == 1
      @stack[0]
    else
      nil
    end
  end

  def evaluate(calculation)
    calculation.scan(/(?:\-)?\d+(?:\.\d+)?|\+|\-|\*|\//).map do |token|
      case token
      when /\d+/
        @stack.push token.to_f
      when /\+/
        add
      when /\-/
        subtract
      when /\*/
        multiply
      when /\//
        divide
      else
        raise "Invalid input: #{token}"
      end
    end
  end

  private

  def add
    first_value, second_value = @stack.pop(2)
    @stack.push(first_value + second_value)
  end

  def subtract
    first_value, second_value = @stack.pop(2)
    @stack.push(first_value - second_value)
  end

  def multiply
    first_value, second_value = @stack.pop(2)
    @stack.push(first_value * second_value)
  end

  def divide
    first_value, second_value = @stack.pop(2)

    if second_value == 0
      raise ZeroDivisionError, "Cannot divide #{first_value} by 0"
    end

    @stack.push(first_value / second_value)
  end
end
