require 'rpn_party/calculator'

module RPNParty
  class CLI
    def initialize
      @calc = RPNParty::Calculator.new

      puts 'Welcome to RPNParty!'
      print '> '

      loop do
        input = gets.chomp
        @calc.evaluate(input)
        puts @calc.result
        print '> '
      end
    end
  end
end
