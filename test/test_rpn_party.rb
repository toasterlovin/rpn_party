require 'minitest/autorun'
require 'rpn_party'

class RPNPartyTest < Minitest::Test
  def test_addition
    calc = RPNParty.new('3 3 +')
    assert_equal 6, calc.result
  end

  def test_subtraction
    calc = RPNParty.new('3 3 -')
    assert_equal 0, calc.result
  end

  def test_multiplication
    calc = RPNParty.new('3 3 *')
    assert_equal 9, calc.result
  end

  def test_division
    calc = RPNParty.new('3 3 /')
    assert_equal 1, calc.result
  end
end
