# frozen_string_literal: true

class LsShortFormatter
  def format(file_names, option)
    separating_file_names = file_names.map { |f| File.basename(f) }.sort

    nested_file_names = configure_ls_row(option['r'] ? separating_file_names.reverse : separating_file_names)
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
    row_count = (files.size.to_f / 3.0).ceil
    nested_file_names = files.each_slice(row_count).to_a

    max_size = nested_file_names.map(&:size).max
    unified_size =
      nested_file_names.map do |file_names|
        file_count = file_names.size
        remainder = max_size - file_count

        remainder.times { file_names << nil } if remainder.positive?
        file_names
      end

    unified_size.transpose
  end
end
