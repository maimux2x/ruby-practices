# frozen_string_literal: true

class LsShortFormatter
  def output_ls(ls_params)
    sorted_files = prepare_output_file_names(ls_params.file_names)
    most_long_file_name = ls_params.file_names.map(&:size).max

    sorted_files.map do |file|
      file.map do |name|
        adjustment_not_ascii = name&.chars&.count { |str| !str.ascii_only? }
        name&.ljust(most_long_file_name - adjustment_not_ascii + 5)
      end.join
    end
  end

  private

  def prepare_output_file_names(files)
    split_num = Rational(files.size, 3).ceil

    dividing_files_to_three_array = files.each_slice(split_num).to_a

    max_size = dividing_files_to_three_array.map(&:size).max
    before_formatting_files_array = dividing_files_to_three_array.map { |name| name.values_at(0...max_size) }

    before_formatting_files_array.transpose
  end
end
