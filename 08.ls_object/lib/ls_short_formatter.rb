# frozen_string_literal: true

class LsShortFormatter
  def format(file_names)
    nested_file_names = configure_ls_row(file_names)
    longest_file_name = file_names.map(&:size).max

    nested_file_names.map do |row_file_names|
      row_file_names.map do |file_name|
        next if file_name.nil?

        adjustment_not_ascii = file_name.chars.count { |char| !char.ascii_only? }
        file_name.ljust(longest_file_name - adjustment_not_ascii + 5)
      end.join
    end
  end

  private

  def configure_ls_row(files)
    row_count = Rational(files.size, 3).ceil
    nested_file_names = files.each_slice(row_count).to_a

    max_size = nested_file_names.map(&:size).max
    unified_size = nested_file_names.map { |file_names| file_names.values_at(0...max_size) }

    unified_size.transpose
  end
end
