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

  def test_multi_digit_operands
    calc = RPNParty.new('33 3 /')
    assert_equal 11, calc.result
  end

  def test_negative_operands
    calc = RPNParty.new('-3 2 *')
    assert_equal(-6, calc.result)
  end

  def test_decimal_operands
    calc = RPNParty.new('2.5 2 /')
    assert_equal 1.25, calc.result
  end

  def test_nested_operations
    calc = RPNParty.new('3 3 + 3 * 3 - 3 /')
    assert_equal 5, calc.result
  end

  def test_successive_operations
    calc = RPNParty.new('3 3 +')
    assert_equal 6, calc.result
    calc.evaluate('3 *')
    assert_equal 18, calc.result
  end

  def test_ommitting_initial_calculation
    calc = RPNParty.new
    assert_nil calc.result
    calc.evaluate('3 3 +')
    assert_equal 6, calc.result
  end

  def test_does_not_allow_zero_division
    error = assert_raises ZeroDivisionError do
      RPNParty.new('3 0 /')
    end

    assert_equal 'Cannot divide 3.0 by 0', error.message
  end
end
