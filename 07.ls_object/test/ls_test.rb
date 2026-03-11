require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/command'

class LsTest < Minitest::Test
  def test_display_with_7_entries
    list = Command.new('test/fixtures/seven_entries')
    expected = <<~TEXT.chomp
      Apple2.txt  Egg.txt  Frenchfries  apple.txt  banana  cider  diet_sparkling.txt
    TEXT
    assert_equal expected, list.output
  end

  def test_entry
    name = Entry.new("a")
    assert_equal 'a', name.to_s
  end
end
