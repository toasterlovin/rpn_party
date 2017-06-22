require 'minitest/autorun'
require 'rpn_party'

class RPNPartyTest < Minitest::Test
  def test_addition
    calc = RPNParty.new('3 3 +')
    assert_equal 6, calc.result
  end

  def test_subtraction
    calc = RPNParty.new('6 3 -')
    assert_equal 3, calc.result
  end

  def test_multiplication
    calc = RPNParty.new('3 3 *')
    assert_equal 9, calc.result
  end

  def test_division
    calc = RPNParty.new('6 3 /')
    assert_equal 2, calc.result
  end

  def test_nested_operations
    calc = RPNParty.new('3 3 + 3 * 3 - 3 /')
    assert_equal 5, calc.result
  end
end
