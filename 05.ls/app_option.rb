# frozen_string_literal: true

require 'optparse'

class AppOption
  def initialize
    @option = ARGV.getopts('ar')
  end

  def has?(key)
    @option.key?(key) &&
      @option[key] == true
  end
end
