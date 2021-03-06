require 'minitest/autorun'
require 'rpn_party/calculator'

class CalculatorTest < Minitest::Test
  def test_addition
    calc = RPNParty::Calculator.new('3 3 +')
    assert_equal 6, calc.result
  end

  def test_subtraction
    calc = RPNParty::Calculator.new('6 3 -')
    assert_equal 3, calc.result
  end

  def test_multiplication
    calc = RPNParty::Calculator.new('3 3 *')
    assert_equal 9, calc.result
  end

  def test_division
    calc = RPNParty::Calculator.new('6 3 /')
    assert_equal 2, calc.result
  end

  def test_multi_digit_operands
    calc = RPNParty::Calculator.new('33 3 /')
    assert_equal 11, calc.result
  end

  def test_negative_operands
    calc = RPNParty::Calculator.new('-3 2 *')
    assert_equal(-6, calc.result)
  end

  def test_decimal_operands
    calc = RPNParty::Calculator.new('2.5 2 /')
    assert_equal 1.25, calc.result
  end

  def test_nested_operations
    calc = RPNParty::Calculator.new('3 3 + 3 * 3 - 3 /')
    assert_equal 5, calc.result
  end

  def test_successive_operations
    calc = RPNParty::Calculator.new('3 3 +')
    assert_equal 6, calc.result
    calc.evaluate('3 *')
    assert_equal 18, calc.result
  end

  def test_ommitting_initial_calculation
    calc = RPNParty::Calculator.new
    assert_nil calc.result
    calc.evaluate('3 3 +')
    assert_equal 6, calc.result
  end

  def test_result_when_more_than_one_numbers_are_on_stack
    calc = RPNParty::Calculator.new('2 3')
    assert_equal [2, 3], calc.result
    calc.evaluate('4 5 +')
    assert_equal [2, 3, 9], calc.result
  end

  def test_operation_with_less_than_two_numers_on_stack
    error = assert_raises RPNParty::InsufficientOperandsError do
      RPNParty::Calculator.new('+')
    end
    assert_equal "Could not perform addition. At least two values are required, but there are none.",
                 error.message

    error = assert_raises RPNParty::InsufficientOperandsError do
      RPNParty::Calculator.new('2 +')
    end
    assert_equal "Could not perform addition. At least two values are required, but there is only one: '2.0'.",
                 error.message

    error = assert_raises RPNParty::InsufficientOperandsError do
      RPNParty::Calculator.new('-')
    end
    assert_equal "Could not perform subtraction. At least two values are required, but there are none.",
                 error.message

    error = assert_raises RPNParty::InsufficientOperandsError do
      RPNParty::Calculator.new('*')
    end
    assert_equal "Could not perform multiplication. At least two values are required, but there are none.",
                 error.message

    error = assert_raises RPNParty::InsufficientOperandsError do
      RPNParty::Calculator.new('/')
    end
    assert_equal "Could not perform division. At least two values are required, but there are none.",
                 error.message
  end

  def test_does_not_allow_zero_division
    error = assert_raises ZeroDivisionError do
      RPNParty::Calculator.new('3 0 /')
    end

    assert_equal 'Cannot divide 3.0 by 0.', error.message
  end

  def test_does_not_allow_unrecognized_input
    assert_raises RPNParty::UnrecognizedInputError do
      RPNParty::Calculator.new('3h3 1 +')
    end

    assert_raises RPNParty::UnrecognizedInputError do
      RPNParty::Calculator.new('3 1 +?')
    end

    error = assert_raises RPNParty::UnrecognizedInputError do
      RPNParty::Calculator.new('3h 1 /')
    end
    assert_equal "Unrecognized value/operator: '3h'. Valid inputs are numbers (0, 1, 2.5, -3, etc.), or '+', '-', '*', '/'.",
                 error.message
  end
end
