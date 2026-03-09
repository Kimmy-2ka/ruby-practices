require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/command'

class LsTest < Minitest::Test
  def test_display
    list = Command.new(['a', 'b'])
    assert_equal 'a  b', list.output
  end

  def test_Entry
    name = Entry.new("a")
    assert_equal 'a', name.to_s
  end
end
