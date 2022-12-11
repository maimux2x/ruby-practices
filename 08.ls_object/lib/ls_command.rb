# frozen_string_literal: true

require_relative 'ls_params'
require_relative 'ls_long_formatter'
require_relative 'ls_short_formatter'
require_relative 'ls_file_outputter'

ls_params = LsParams.new(ARGV)

def run(ls_params)
  option = ls_params.option
  path = ls_params.path

  if !File.exist?(path)
    puts "#{path}: No such file or directory"
  else
    return if Dir.empty?(path)

    formatter = option['l'] ? LsLongFormatter.new : LsShortFormatter.new
    file_names = ls_params.glob_file_names
    ls_file_outputter = LsFileOutputter.new(file_names, formatter)
    ls_file_outputter.output
  end
end

run(ls_params)
