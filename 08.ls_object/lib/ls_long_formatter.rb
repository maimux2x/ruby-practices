# frozen_string_literal: true

require 'etc'

class LsLongFormatter
  def format(ls_file_outputter)
    long_format_data = get_long_format_data(ls_file_outputter.file_names)
    separating_file_names = ls_file_outputter.file_names.map { |f| File.basename(f) }

    total_blocks = long_format_data.map(&:blocks).sum
    total = "total #{total_blocks}" if long_format_data.size > 1

    format_result =
      long_format_data.map.with_index do |data, index|
        file_type = convert_file_type(data.ftype)
        permisson = convert_permission(data.mode.to_s(8))
        link = data.nlink.to_s.rjust(2)
        user_name = Etc.getpwuid(data.uid).name
        authority = Etc.getgrgid(data.gid).name
        file_size = data.size.to_s.rjust(5)
        datetime = data.mtime.strftime('%_m %_d %_R')
        file_name = separating_file_names[index]

        "#{file_type}#{permisson}  #{link}  #{user_name}  #{authority}  #{file_size}  #{datetime}  #{file_name}"
      end
    [total, format_result].join("\n")
  end

  private

  def get_long_format_data(file_names)
    file_names.map { |file_name| File::Stat.new(File.expand_path(file_name).to_s) }
  end

  def convert_file_type(type)
    file_types = {
      'fifo' => 'p',
      'characterSpecial' => 'c',
      'directory' => 'd',
      'blockSpecial' => 'b',
      'file' => '-',
      'link' => 'l',
      'socket' => 's'
    }

    result_file_type = file_types.filter { |file_type, _| file_type == type }.map { |_, convert_value| convert_value }
    result_file_type[0]
  end

  def convert_permission(mode)
    permissions = {
      '0' => '---',
      '1' => '--x',
      '2' => '-w-',
      '3' => '-wx',
      '4' => 'r--',
      '5' => 'r-x',
      '6' => 'rw-',
      '7' => 'rwx'
    }

    mode[-3..].chars.map { |mode_num| permissions[mode_num] }.join
  end
end
