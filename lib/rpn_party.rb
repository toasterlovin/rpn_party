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
    second_value, first_value = @stack.pop(2)
    @result = first_value + second_value
  end

  def subtract
    second_value, first_value = @stack.pop(2)
    @result = first_value - second_value
  end

  def multiply
    second_value, first_value = @stack.pop(2)
    @result = first_value * second_value
  end

  def divide
    second_value, first_value = @stack.pop(2)
    @result = first_value / second_value
  end
end
