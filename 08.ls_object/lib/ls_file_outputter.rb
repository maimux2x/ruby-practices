# frozen_string_literal: true

class LsFileOutputter
  def initialize(file_names, option, formatter)
    @file_names = file_names
    @option = option
    @formatter = formatter
  end

  def output
    puts @formatter.format(@file_names, @option)
  end
end
