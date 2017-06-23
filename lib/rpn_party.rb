class RPNParty
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
        raise RPNParty::UnrecognizedInput,
          "Unrecognized value/operator: '#{token}'. Valid inputs are numbers (0, 1, 2.5, -3, etc.), or '+', '-', '*', '/'."
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

class RPNParty::UnrecognizedInput < StandardError
end
