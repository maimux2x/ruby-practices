# frozen_string_literal: true

require_relative '../lib/ls_formatter'

class LsShortFormatter < LsFormatter
  def output_ls(file)
    results = prepare_output_file_names(file.file_names)
    num = file.file_names.map(&:size).max

    results.each do |ary|
      ary.each do |name|
        adjustment_not_ascii = name&.chars&.count { |str| !str.ascii_only? }
        print name&.ljust(num - adjustment_not_ascii + 5)
      end
      puts "\n"
    end
  end

  private

  def prepare_output_file_names(file)
    splite_num = Rational(file.size, 3).ceil

    second_file_names = file.each_slice(splite_num).to_a

    max_size = second_file_names.map(&:size).max
    third_file_names = second_file_names.map { |name| name.values_at(0...max_size) }

    third_file_names.transpose
  end
end
