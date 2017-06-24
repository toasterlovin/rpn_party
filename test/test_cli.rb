require 'minitest/autorun'
require 'rpn_party/cli'
require 'open3'
require 'pty'

class CLITest < Minitest::Test
  def test_basic_operation
    PTY.spawn('bin/rpn_party') do |output, input, pid|
      pty = [output, input, pid]

      assert_equal 'Welcome to RPNParty!', get_response(pty)

      send_command pty, '2 3 +'
      assert_equal '5.0', get_result(pty)
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

  private

  def get_response(pty)
    pty[0].gets.chomp
  end

  def send_command(pty, command)
    pty[1].puts command
    pty[0].gets
  end

  def get_result(pty)
    get_response(pty).gsub('#=> ', '')
  end
end
