require 'minitest/autorun'
require 'rpn_party/cli'

class CLITest < Minitest::Test
  def test_basic_operation
    IO.popen('bin/rpn_party', 'r+') do |console|
      response = console.gets.chomp
      assert_equal 'Welcome to RPNParty!', response

      console.puts '2 3 +'
      response = console.gets.chomp
      assert_equal '5', response
    end
  end

  def test_erroneous_input
    flunk
  end

  def test_quitting_on_q
    flunk
  end

  def test_quitting_on_eof
    flunk
  end
end
