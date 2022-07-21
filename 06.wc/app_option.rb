# frozen_string_literal: true

require 'optparse'

class AppOption
  def initialize
    @option = {}
    opt = OptionParser.new
    opt.on('-l') { |v| v }
    opt.on('-w') { |v| v }
    opt.on('-c') { |v| v }

    opt.parse!(ARGV, into: @option)
    @option = { l: true, w: true, c: true } if @option.empty?
  end

  def has?(key)
    @option.key?(key) &&
      @option[key] == true
  end
end
