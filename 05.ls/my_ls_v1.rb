# frozen_string_literal: true

require_relative 'app_option'

class LS
  def current_empty?
    Dir.empty?(Dir.getwd)
  end

  def prepare_output
    return if current_empty?

    option = AppOption.new
    @first_ary =
      if option.has?('a')
        Dir.glob('*', File::FNM_DOTMATCH).sort
      else
        Dir.glob('*').sort
      end

    n = 3
    splite_ary = Rational(@first_ary.size, n).ceil

    second_ary = @first_ary.each_slice(splite_ary).to_a

    max_size = second_ary.map(&:size).max
    third_ary = second_ary.map { |ary| ary.values_at(0...max_size) }

    third_ary.transpose
  end

  def output_current
    result = prepare_output
    num = @first_ary.map(&:size).max

    result.each do |ary|
      ary.each do |str|
        print str&.ljust(num + 5)
      end
      puts "\n"
    end
  end
end

ls = LS.new
ls.output_current
