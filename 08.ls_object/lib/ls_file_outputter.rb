# frozen_string_literal: true

class LsFileOutputter
  def initialize(ls_params)
    @file_names = ls_params.glob_file_names
    @option = ls_params.option
    @formatter = @option['l'] ? LsLongFormatter.new : LsShortFormatter.new
  end

  def output
    puts @formatter.format(@file_names, @option)
  end
end
