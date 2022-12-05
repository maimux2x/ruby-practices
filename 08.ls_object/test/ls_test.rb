# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls_params'
require_relative '../lib/ls_long_formatter'
require_relative '../lib/ls_short_formatter'
require_relative '../lib/ls_file_outputter'

class LsFileOutputterTest < Minitest::Test
  def test_output_ls_no_option
    file_names = ['blank', 'dummy.md', 'example.md', 'memo.txt', 'test.html', 'test.txt', 'あいう.md', 'テスト.md']
    result = LsFileOutputter.new(file_names, LsShortFormatter.new)
    expected = <<~TEXT
      blank          memo.txt       あいう.md
      dummy.md       test.html      テスト.md
      example.md     test.txt
    TEXT

    assert_output(expected) { return result.output }
  end

  def test_output_ls_a_option
    file_names = ['.', 'blank', 'dummy.md', 'example.md', 'memo.txt', 'test.html', 'test.txt', 'あいう.md', 'テスト.md']
    result = LsFileOutputter.new(file_names, LsShortFormatter.new)
    expected = <<~TEXT
      .              example.md     test.txt
      blank          memo.txt       あいう.md
      dummy.md       test.html      テスト.md
    TEXT

    assert_output(expected) { return result.output }
  end

  def test_output_ls_r_option
    file_names = ['テスト.md', 'あいう.md', 'test.txt', 'test.html', 'memo.txt', 'example.md', 'dummy.md', 'blank']
    result = LsFileOutputter.new(file_names, LsShortFormatter.new)
    expected = <<~TEXT
      テスト.md      test.html      dummy.md
      あいう.md      memo.txt       blank
      test.txt       example.md
    TEXT

    assert_output(expected) { return result.output }
  end

  def test_output_ls_l_option
    file_names = ['dummy/blank', 'dummy/dummy.md', 'dummy/example.md', 'dummy/memo.txt', 'dummy/test.html', 'dummy/test.txt', 'dummy/あいう.md', 'dummy/テスト.md']
    result = LsFileOutputter.new(file_names, LsShortFormatter.new)
    expected = <<~TEXT
      total 8
      drwxr-xr-x   2  maimux2x  staff     64  11 12 19:50  blank
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:36  dummy.md
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:37  example.md
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:38  memo.txt
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:37  test.html
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:39  test.txt
      -rw-r--r--   1  maimux2x  staff     66  11 12 16:33  あいう.md
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:39  テスト.md
    TEXT

    assert_output(expected) { return result.output }
  end

  def test_output_ls_arl_option
    file_names = ['dummy/テスト.md', 'dummy/あいう.md', 'dummy/test.txt', 'dummy/test.html', 'dummy/memo.txt', 'dummy/example.md', 'dummy/dummy.md', 'dummy/blank',
                  'dummy/.']
    result = LsFileOutputter.new(file_names, LsShortFormatter.new)
    expected = <<~TEXT
      total 8
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:39  テスト.md
      -rw-r--r--   1  maimux2x  staff     66  11 12 16:33  あいう.md
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:39  test.txt
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:37  test.html
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:38  memo.txt
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:37  example.md
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:36  dummy.md
      drwxr-xr-x   2  maimux2x  staff     64  11 12 19:50  blank
      drwxr-xr-x  10  maimux2x  staff    320  11 25 08:38  .
    TEXT

    assert_output(expected) { return result.output }
  end
end
