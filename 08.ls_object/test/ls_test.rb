# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls_option'
require_relative '../lib/ls_long_formatter'
require_relative '../lib/ls_short_formatter'
require_relative '../lib/ls_formatter'
require_relative '../lib/ls_file'

class LsFileTest < Minitest::Test
  def test_output_ls_no_option
    option = LsOption.new
    result = LsFile.new(option, 'dummy', LsShortFormatter.new)
    expected = <<~TEXT
      blank          example.md     test.txt
      dummy.js       memo.txt       あいう.md
      dummy.md       test.html      テスト.md
    TEXT

    assert_output(expected) { return result.output_ls }
  end

  def test_output_ls_a_option
    ARGV << '-a'
    option = LsOption.new

    result = LsFile.new(option, 'dummy', LsShortFormatter.new)
    expected = <<~TEXT
      .              example.md     あいう.md
      blank          memo.txt       テスト.md
      dummy.js       test.html
      dummy.md       test.txt
    TEXT

    assert_output(expected) { return result.output_ls }
  end

  def test_output_ls_r_option
    ARGV << '-r'
    option = LsOption.new

    result = LsFile.new(option, 'dummy', LsShortFormatter.new)
    expected = <<~TEXT
      テスト.md      test.html      dummy.md
      あいう.md      memo.txt       dummy.js
      test.txt       example.md     blank
    TEXT

    assert_output(expected) { return result.output_ls }
  end

  def test_output_ls_l_option
    ARGV << '-l'
    option = LsOption.new

    result = LsFile.new(option, 'dummy', LsShortFormatter.new)
    expected = <<~TEXT
      total 8
      drwxr-xr-x   2  maimux2x  staff     64  11 12 19:50  blank
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:38  dummy.js
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:36  dummy.md
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:37  example.md
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:38  memo.txt
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:37  test.html
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:39  test.txt
      -rw-r--r--   1  maimux2x  staff     66  11 12 16:33  あいう.md
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:39  テスト.md
    TEXT

    assert_output(expected) { return result.output_ls }
  end

  def test_output_ls_arl_option
    ARGV << '-arl'
    option = LsOption.new

    result = LsFile.new(option, 'dummy', LsShortFormatter.new)
    expected = <<~TEXT
      total 8
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:39  テスト.md
      -rw-r--r--   1  maimux2x  staff     66  11 12 16:33  あいう.md
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:39  test.txt
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:37  test.html
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:38  memo.txt
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:37  example.md
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:36  dummy.md
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:38  dummy.js
      drwxr-xr-x   2  maimux2x  staff     64  11 12 19:50  blank
      drwxr-xr-x  11  maimux2x  staff    352  11 12 19:50  .
    TEXT

    assert_output(expected) { return result.output_ls }
  end
end
