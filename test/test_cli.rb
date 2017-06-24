require 'minitest/autorun'
require 'rpn_party/cli'
require 'open3'
require 'pty'

class CLITest < Minitest::Test
  def test_basic_operation
    PTY.spawn('bin/rpn_party') do |output, input, pid|
      pty = [output, input, pid]
      clear_welcome_message(pty)

      send_command pty, '2 3 +'
      assert_equal '5.0', get_response(pty)
    end
  end

  def test_consecutive_operations
    PTY.spawn('bin/rpn_party') do |output, input, pid|
      pty = [output, input, pid]
      clear_welcome_message(pty)

      send_command pty, '2 3 +'
      assert_equal '5.0', get_response(pty)

      send_command pty, '4 +'
      assert_equal '9.0', get_response(pty)
    end
  end

  def test_no_values_on_stack_response
    PTY.spawn('bin/rpn_party') do |output, input, pid|
      pty = [output, input, pid]
      clear_welcome_message(pty)

      send_command pty, ''
      assert_equal 'nil', get_response(pty)
    end
  end

  def test_more_than_one_value_on_stack_response
    PTY.spawn('bin/rpn_party') do |output, input, pid|
      pty = [output, input, pid]
      clear_welcome_message(pty)

      send_command pty, '2 3'
      assert_equal '2.0, 3.0', get_response(pty)
    end
  end

  def test_unrecognized_input
    PTY.spawn('bin/rpn_party') do |output, input, pid|
      pty = [output, input, pid]
      clear_welcome_message(pty)

      send_command pty, '2 3$ +'
      assert_equal "Unrecognized value/operator: '3$'. Valid inputs are numbers (0, 1, 2.5, -3, etc.), or '+', '-', '*', '/'.", get_response(pty)
    end
  end

  def test_zero_division
    PTY.spawn('bin/rpn_party') do |output, input, pid|
      pty = [output, input, pid]
      clear_welcome_message(pty)

      send_command pty, '3 0 /'
      assert_equal "Cannot divide 3.0 by 0.", get_response(pty)
    end
  end

  def test_insufficient_values_on_stack
    PTY.spawn('bin/rpn_party') do |output, input, pid|
      pty = [output, input, pid]
      clear_welcome_message(pty)

      send_command pty, '+'
      assert_equal "Could not perform addition. At least two values are required, but there are none.", get_response(pty)

      send_command pty, '3 +'
      output.gets
      assert_equal "Could not perform addition. At least two values are required, but there is only one: '3.0'.", get_response(pty)
    end
  end

  def test_quitting_on_q
    PTY.spawn('bin/rpn_party') do |output, input, pid|
      pty = [output, input, pid]
      clear_welcome_message(pty)

      send_command pty, 'q'
      assert_equal 'Goodbye!', get_response(pty)

      sleep 0.2
      assert PTY.check(pid)
    end
  end

  def test_quitting_on_eof
    PTY.spawn('bin/rpn_party') do |output, input, pid|
      pty = [output, input, pid]
      clear_welcome_message(pty)

      send_command pty, "\cD"
      assert_equal 'Goodbye!', get_response(pty)

      sleep 0.2
      assert PTY.check(pid)
    end
  end

  private

  def clear_welcome_message(pty)
    sleep 0.2
    get_response(pty)
  end

  def get_response(pty)
    sleep 0.2
    pty[0].gets.chomp
  end

  def send_command(pty, command)
    pty[1].puts command
    pty[0].gets
  end
end
