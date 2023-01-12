# frozen_string_literal: true

require_relative 'ls_params'
require_relative 'ls_long_formatter'
require_relative 'ls_short_formatter'
require_relative 'ls_file_outputter'

def run(ls_params)
  option = ls_params.option
  path = ls_params.path

  if !File.exist?(path)
    puts "#{path}: No such file or directory"
  elsif !Dir.empty?(path)
    ls_file_outputter = LsFileOutputter.new(ls_params)
    ls_file_outputter.output
  end
end

run(LsParams.new(ARGV))
