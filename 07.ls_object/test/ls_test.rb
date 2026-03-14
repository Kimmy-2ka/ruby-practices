require 'minitest/autorun'
require 'minitest/pride'
require 'pathname'
require_relative '../lib/command'

class LsTest < Minitest::Test
  def test_output_without_option
    pathname = Pathname('test/fixtures/sample_entries')
    list = Command.new({}, pathname)
    expected = <<~TEXT.chomp
      Apple2.txt   apple.txt  diet_sparkling.txt
      Egg.txt      banana
      Frenchfries  cider
    TEXT
    assert_equal expected, list.output({})
  end

  def test_output_with_all_option
    pathname = Pathname('test/fixtures/sample_entries')
    list = Command.new({all: true}, pathname)
    expected = <<~TEXT.chomp
      .           Egg.txt      cider
      ..          Frenchfries  diet_sparkling.txt
      .melon.txt  apple.txt
      Apple2.txt  banana
    TEXT
    assert_equal expected, list.output({all: true})
  end

  def test_output_with_reverse_option
    pathname = Pathname('test/fixtures/sample_entries')
    list = Command.new({reverse: true}, pathname)
    expected = <<~TEXT.chomp
      diet_sparkling.txt  apple.txt    Apple2.txt
      cider               Frenchfries
      banana              Egg.txt
    TEXT
    assert_equal expected, list.output({reverse: true})
  end

  def test_output_with_list_option
    pathname = Pathname('test/fixtures/sample_entries')
    list = Command.new({long: true}, pathname)
    expected = <<~TEXT.chomp
      合計 12
      -rw-r--r-T 1 kimmy2ka users       0  3月 11 21:20 Apple2.txt
      -rwS------ 1 kimmy2ka projectA    0  3月 11 21:21 Egg.txt
      drwxr-xr-t 2 kimmy2ka projectA 4096  3月 11 21:23 Frenchfries
      -rwsr-xr-x 1 kimmy2ka projectA    0  3月 11 19:59 apple.txt
      drwxrwx--- 2 kimmy2ka projectA 4096  3月 11 21:16 banana
      drwx------ 2 kimmy2ka projectA 4096  3月 11 21:17 cider
      -r--r--r-- 1 kimmy2ka projectA    0  3月 11 20:01 diet_sparkling.txt
    TEXT
    assert_equal expected, list.output({long: true})
  end
end
