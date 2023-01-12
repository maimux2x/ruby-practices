# frozen_string_literal: true
require 'optparse'

class DummyArgv
  def initialize(option)
    @option = option
  end

  def getopts
    if @option[:a]
      { 'a' => true, 'l' => false, 'r' => false }
    else
      { 'a' => false, 'l' => false, 'r' => false }
    end
  end

  def glob_file_names
    if @option[:a]
      ['dummy/.', 'dummy/blank', 'dummy/dummy.md', 'dummy/example.md', 'dummy/memo.txt', 'dummy/test.html', 'dummy/test.txt', 'dummy/あいう.md',
        'dummy/テスト.md']
    else
      ['dummy/blank', 'dummy/dummy.md', 'dummy/example.md', 'dummy/memo.txt', 'dummy/test.html', 'dummy/test.txt', 'dummy/あいう.md', 'dummy/テスト.md']
    end
  end
end