# frozen_string_literal: true

require 'optparse'

class LsParams
  attr_reader :option, :path

  def initialize(params)
    @option = params.getopts('a', 'l', 'r')
    @path = params[0] || '.'
  end

  def glob_file_names
    option_a = @option['a'] ? File::FNM_DOTMATCH : 0

    file_names =
      if File.file?(@path)
        [@path]
      elsif @option['l']
        Dir.glob("#{@path}/*", option_a).sort
      else
        Dir.glob('*', option_a, base: @path).sort
      end

    file_names = file_names.reverse if @option['r']
    file_names
  end
end
