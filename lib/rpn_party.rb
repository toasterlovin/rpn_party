class RPNParty
  attr_reader :result

  def initialize(calculation)
    @result = nil
    @stack = []
    parse(calculation)
  end

  private

  def parse(calculation)
    tokens = tokenize(calculation)
    evaluate(tokens)
  end

  def tokenize(string)
    string.scan(/\d+|\+|\-|\*|\//).map do |token|
      case token
      when /\d+/
        token.to_i
      when /[\+\-\*\/]/
        token.to_sym
      else
        raise "Invalid input: #{token}"
      end
    end
  end

  def evaluate(arguments)
    arguments.each do |argument|
      if argument.is_a? Integer
        @stack.push argument
      elsif argument == :+
        add
      elsif argument == :-
        subtract
      elsif argument == :*
        multiply
      elsif argument == :/
        divide
      end
    end
  end

  def add
    second_value = @stack.pop
    first_value  = @stack.pop
    @result = first_value + second_value
  end

  def subtract
    second_value = @stack.pop
    first_value  = @stack.pop
    @result = first_value - second_value
  end

  def multiply
    second_value = @stack.pop
    first_value  = @stack.pop
    @result = first_value * second_value
  end

  def divide
    second_value = @stack.pop
    first_value  = @stack.pop
    @result = first_value / second_value
  end
end
