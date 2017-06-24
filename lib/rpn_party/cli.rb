require 'rpn_party/calculator'

module RPNParty
  class CLI
    def initialize
      @calc = RPNParty::Calculator.new

      puts 'Welcome to RPNParty!'
      print '> '

      loop do
        input = gets

        if input.nil? || input.chomp == 'q'
          puts 'Goodbye!'
          exit
        end

        @calc.evaluate(input.chomp)
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
