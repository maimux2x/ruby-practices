# frozen_string_literal: true

require 'optparse'

class LsOption
  def initialize
    @option = {}
    opt = OptionParser.new
    opt.on('-a') { |v| v }
    opt.on('-r') { |v| v }
    opt.on('-l') { |v| v }

    opt.parse!(ARGV, into: @option)
  end

  def has?(key)
    @option.key?(key) &&
      @option[key] == true
  end
end
