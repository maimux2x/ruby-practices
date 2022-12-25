# frozen_string_literal: true

class LsShortFormatter
  def format(file_names, option)
    separating_file_names = file_names.map { |f| File.basename(f) }.sort
    separating_file_names = separating_file_names.reverse if option['r']
    nested_file_names = build_ls_rows(separating_file_names)
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

  def build_ls_rows(files)
    row_count = (files.size.to_f / 3.0).ceil
    nested_file_names = files.each_slice(row_count).to_a

    max_size = nested_file_names.map(&:size).max
    nested_file_names =
      nested_file_names.each do |file_names|
        file_count = file_names.size
        remainder = max_size - file_count

        remainder.times { file_names << nil } if remainder.positive?
        file_names
      end

      nested_file_names.transpose
  end
end
