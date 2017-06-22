class RPNParty
  def initialize(calculation)
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

  private

  def evaluate(string)
    string.scan(/\d+|\+|\-|\*|\//).map do |token|
      case token
      when /\d+/
        @stack.push token.to_i
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
    @stack.push(first_value / second_value)
  end
end
