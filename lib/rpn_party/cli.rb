require 'rpn_party/calculator'

module RPNParty
  class CLI
    def initialize
      @calc = RPNParty::Calculator.new
      repl
    end

    def repl
      puts 'Welcome to RPNParty!'
      print '> '

      loop do
        input = gets

        if input.nil? || input.chomp == 'q'
          puts 'Goodbye!'
          exit
        end

        begin
          @calc.evaluate(input.chomp)
        rescue RPNParty::UnrecognizedInputError => error
          puts error.message
        rescue ZeroDivisionError => error
          puts error.message
        rescue RPNParty::InsufficientOperandsError => error
          puts error.message
        end

        if @calc.result.nil?
          puts 'nil'
        elsif @calc.result.is_a? Array
          puts @calc.result.join(', ')
        else
          puts @calc.result
        end

        print '> '
      end
    end
  end
end
