# frozen_string_literal: true

require 'optparse'

class AppOption
  def initialize
    @option = ARGV.getopts('a')
  end

  def has?(key)
    @option.keys == [key] &&
      @option.values == [true]
  end
end
