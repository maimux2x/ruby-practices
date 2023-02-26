# frozen_string_literal: true

require_relative 'ls_params'
require_relative 'ls_long_formatter'
require_relative 'ls_short_formatter'
require_relative 'ls_file_outputter'

def run
  ls_params = LsParams.new(ARGV)

  if !File.exist?(ls_params.path)
    puts "#{ls_params.path}: No such file or directory"
  elsif !Dir.empty?(ls_params.path)
    ls_file_outputter = LsFileOutputter.new(ls_params)
    ls_file_outputter.output
  end
end

run
