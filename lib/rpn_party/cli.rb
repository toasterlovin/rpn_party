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
