# frozen_string_literal: true

require_relative '../lib/ls_option'
require_relative 'ls_long_formatter'
require_relative '../lib/ls_short_formatter'
require_relative '../lib/ls_file'

option = LsOption.new
params = ARGV[0] || '.'

if !File.exist?(params)
  puts "#{params}: No such file or directory"
elsif Dir.empty?(params || Dir.getwd)
  puts ''
else
  ls =
    if option.has?(:l)
      LsFile.new(option, params, LsLongFormatter.new)
    else
      LsFile.new(option, params, LsShortFormatter.new)
    end
  ls.output_ls
end
