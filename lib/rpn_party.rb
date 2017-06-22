class RPNParty
  attr_reader :result

  def initialize(calculation)
    @result = nil
    @stack = []
    evaluate(calculation)
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
    @result = first_value + second_value
  end

  def subtract
    first_value, second_value = @stack.pop(2)
    @result = first_value - second_value
  end

  def multiply
    first_value, second_value = @stack.pop(2)
    @result = first_value * second_value
  end

  def divide
    first_value, second_value = @stack.pop(2)
    @result = first_value / second_value
  end
end
