# frozen_string_literal: true

class LsFileOutputter
  attr_reader :file_names

  def initialize(file_names, formatter)
    @formatter = formatter
    @file_names = file_names
  end

  def output
    puts @formatter.format(self)
  end
end
