# frozen_string_literal: true

require_relative 'app_option'

class LS
  def current_empty?
    Dir.empty?(Dir.getwd)
  end

  def check_option
    option = AppOption.new
    check_option_ary = Dir.glob('*', option.has?('a') ? File::FNM_DOTMATCH : 0)
    option.has?('r') ? check_option_ary.sort.reverse : check_option_ary.sort
  end

  def prepare_output(check_option_result)
    first_ary = check_option_result
    n = 3
    splite_ary = Rational(first_ary.size, n).ceil

    second_ary = first_ary.each_slice(splite_ary).to_a

    max_size = second_ary.map(&:size).max
    third_ary = second_ary.map { |ary| ary.values_at(0...max_size) }

    third_ary.transpose
  end

  def output_current
    return if current_empty?

    check_option_result = check_option
    result = prepare_output(check_option_result)
    num = check_option_result.map(&:size).max

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
