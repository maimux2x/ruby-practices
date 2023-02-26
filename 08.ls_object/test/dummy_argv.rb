# frozen_string_literal: true

require 'optparse'

class DummyArgv
  def initialize(option, path = nil)
    @option = option
    @path = path
  end

  def getopts(*)
    { 'a' => @option[:a], 'l' => @option[:l], 'r' => @option[:r] }
  end

  def [](*)
    @path
  end
end
