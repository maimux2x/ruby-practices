# frozen_string_literal: true

require_relative 'ls_option'
require_relative 'ls_long_formatter'
require_relative 'ls_short_formatter'
require_relative 'ls_file_outputer'

option = LsOption.new
file = ARGV[0] || '.'

if !File.exist?(file)
  puts "#{file}: No such file or directory"
elsif Dir.empty?(file || Dir.getwd)
  nil
else
  formatter = option.has?(:l) ? LsLongFormatter.new : LsShortFormatter.new
  ls = LsFileOutputer.new(option, file, formatter)
  ls.output_ls
end
