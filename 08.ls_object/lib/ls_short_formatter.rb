# frozen_string_literal: true

class LsShortFormatter
  def format(ls_file_outputter)
    nested_file_names = transpose_file_names(ls_file_outputter.file_names)
    most_longest_file_name = ls_file_outputter.file_names.map(&:size).max

    nested_file_names.map do |row_files|
      row_files.map do |file_name|
        adjustment_not_ascii = file_name&.chars&.count { |str| !str.ascii_only? }
        file_name&.ljust(most_longest_file_name - adjustment_not_ascii + 5)
      end.join
    end
  end

  private

  def transpose_file_names(files)
    row_count = Rational(files.size, 3).ceil

    nested_file_names = files.each_slice(row_count).to_a

    max_size = nested_file_names.map(&:size).max

    # transposeする都合上、要素数の合わない配列の要素数が合うようにnilを埋めている
    nested_file_names = nested_file_names.map { |file_names| file_names.values_at(0...max_size) }

    nested_file_names.transpose
  end
end
