require 'minitest/autorun'
require 'minitest/pride'
require 'pathname'
require_relative '../lib/command'

class LsTest < Minitest::Test
  SAMPLE_PATHNAME = Pathname('test/fixtures/sample_entries')
  def test_output_without_option
    command = Command.new({}, SAMPLE_PATHNAME)
    expected = <<~TEXT.chomp
      Apple2.txt   apple.txt  diet_sparkling.txt
      Egg.txt      banana
      Frenchfries  cider
    TEXT
    assert_equal expected, command.output
  end

  def test_output_with_all_option
    command = Command.new({all: true}, SAMPLE_PATHNAME)
    expected = <<~TEXT.chomp
      .           Egg.txt      cider
      ..          Frenchfries  diet_sparkling.txt
      .melon.txt  apple.txt
      Apple2.txt  banana
    TEXT
    assert_equal expected, command.output
  end

  def test_output_with_reverse_option
    command = Command.new({reverse: true}, SAMPLE_PATHNAME)
    expected = <<~TEXT.chomp
      diet_sparkling.txt  apple.txt    Apple2.txt
      cider               Frenchfries
      banana              Egg.txt
    TEXT
    assert_equal expected, command.output
  end

  def test_output_with_long_option
    command = Command.new({long: true}, SAMPLE_PATHNAME)
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
    assert_equal expected, command.output
  end

  def test_output_with_all_and_long_option
    command = Command.new({all: true, long: true}, SAMPLE_PATHNAME)
    expected = <<~TEXT.chomp
      合計 20
      drwxr-xr-x 5 kimmy2ka kimmy2ka 4096  3月 12 18:41 .
      drwxr-xr-x 3 kimmy2ka kimmy2ka 4096  3月 12 18:41 ..
      -rw-r--r-- 1 kimmy2ka kimmy2ka    0  3月 12 18:41 .melon.txt
      -rw-r--r-T 1 kimmy2ka users       0  3月 11 21:20 Apple2.txt
      -rwS------ 1 kimmy2ka projectA    0  3月 11 21:21 Egg.txt
      drwxr-xr-t 2 kimmy2ka projectA 4096  3月 11 21:23 Frenchfries
      -rwsr-xr-x 1 kimmy2ka projectA    0  3月 11 19:59 apple.txt
      drwxrwx--- 2 kimmy2ka projectA 4096  3月 11 21:16 banana
      drwx------ 2 kimmy2ka projectA 4096  3月 11 21:17 cider
      -r--r--r-- 1 kimmy2ka projectA    0  3月 11 20:01 diet_sparkling.txt
    TEXT
    assert_equal expected, command.output
  end

  def test_output_with_different_option_order
    expected = `bin/ls -lra test/fixtures/sample_entries`
    actual = `bin/ls -arl test/fixtures/sample_entries`

    assert_equal expected, actual
  end
end
