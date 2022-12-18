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

    if File.file?(@path)
      [@path]
    else
      Dir.glob("#{@path}/*", option_a)
    end
  end
end
