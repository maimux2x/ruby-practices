# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls_params'
require_relative '../lib/ls_long_formatter'
require_relative '../lib/ls_short_formatter'
require_relative '../lib/ls_file_outputter'
require_relative 'dummy_argv'

class LsTest < Minitest::Test
  def test_output_ls_no_option
    argv = DummyArgv.new({ a: false, l: false, r: false }, 'dummy')
    ls_params = LsParams.new(argv)
    ls_file_outputter = LsFileOutputter.new(ls_params)

    expected = ["blank                memo.txt             あいう.md            \n",
                "dummy.md             test.html            テスト.md            \n",
                "example.md           test.txt             \n"].join

    assert_output(expected) { ls_file_outputter.output }
  end

  def test_output_ls_a_option
    argv = DummyArgv.new({ a: true, l: false, r: false }, 'dummy')
    ls_params = LsParams.new(argv)
    ls_file_outputter = LsFileOutputter.new(ls_params)

    expected = [".                    example.md           test.txt             \n",
                "blank                memo.txt             あいう.md            \n",
                "dummy.md             test.html            テスト.md            \n"].join

    assert_output(expected) { ls_file_outputter.output }
  end

  def test_output_ls_r_option
    argv = DummyArgv.new({ a: false, l: false, r: true }, 'dummy')
    ls_params = LsParams.new(argv)
    ls_file_outputter = LsFileOutputter.new(ls_params)

    expected = ["テスト.md            test.html            dummy.md             \n",
                "あいう.md            memo.txt             blank                \n",
                "test.txt             example.md           \n"].join

    assert_output(expected) { ls_file_outputter.output }
  end

  def test_output_ls_l_option
    argv = DummyArgv.new({ a: false, l: true, r: false }, 'dummy')
    ls_params = LsParams.new(argv)
    ls_file_outputter = LsFileOutputter.new(ls_params)

    expected = <<~TEXT
      total 16
      drwxr-xr-x   2  maimux2x  staff     64  11 12 19:50  blank
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:36  dummy.md
      -rw-r--r--   1  maimux2x  staff    510  12 17 21:30  example.md
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:38  memo.txt
      -rw-r--r--   1  maimux2x  staff      0  12 18 11:03  test.html
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:39  test.txt
      -rw-r--r--   1  maimux2x  staff     66  11 12 16:33  あいう.md
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:39  テスト.md
    TEXT

    assert_output(expected) { ls_file_outputter.output }
  end

  def test_output_ls_arl_option
    argv = DummyArgv.new({ a: true, l: true, r: true }, 'dummy')
    ls_params = LsParams.new(argv)
    ls_file_outputter = LsFileOutputter.new(ls_params)

    expected = <<~TEXT
      total 16
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:39  テスト.md
      -rw-r--r--   1  maimux2x  staff     66  11 12 16:33  あいう.md
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:39  test.txt
      -rw-r--r--   1  maimux2x  staff      0  12 18 11:03  test.html
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:38  memo.txt
      -rw-r--r--   1  maimux2x  staff    510  12 17 21:30  example.md
      -rw-r--r--   1  maimux2x  staff      0  11 10 21:36  dummy.md
      drwxr-xr-x   2  maimux2x  staff     64  11 12 19:50  blank
      drwxr-xr-x  10  maimux2x  staff    320  12 18 11:03  .
    TEXT

    assert_output(expected) { ls_file_outputter.output }
  end
end
