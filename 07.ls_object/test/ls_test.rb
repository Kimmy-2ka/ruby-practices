require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/command'

class LsTest < Minitest::Test
  def test_output_without_option
    list = Command.new({}, 'test/fixtures/sample_entries')
    expected = <<~TEXT.chomp
      Apple2.txt   apple.txt  diet_sparkling.txt
      Egg.txt      banana
      Frenchfries  cider
    TEXT
    assert_equal expected, list.output
  end

  def test_output_with_all_option
    list = Command.new({all: true}, 'test/fixtures/sample_entries')
    expected = <<~TEXT.chomp
      .           Egg.txt      cider
      ..          Frenchfries  diet_sparkling.txt
      .melon.txt  apple.txt
      Apple2.txt  banana
    TEXT
    assert_equal expected, list.output
  end

  def test_output_with_reverse_option
    list = Command.new({reverse: true}, 'test/fixtures/sample_entries')
    expected = <<~TEXT.chomp
      diet_sparkling.txt  apple.txt    Apple2.txt
      cider               Frenchfries
      banana              Egg.txt
    TEXT
    assert_equal expected, list.output
  end

  def test_entry
    name = Entry.new("a")
    assert_equal 'a', name.to_s
  end
end
