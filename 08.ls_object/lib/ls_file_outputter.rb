# frozen_string_literal: true

class LsFileOutputter
  def initialize(file_names, formatter)
    @formatter = formatter
    @file_names = file_names
  end

  def output
    puts @formatter.format(@file_names)
  end
end
