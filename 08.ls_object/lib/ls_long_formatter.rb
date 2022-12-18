# frozen_string_literal: true

require 'etc'

class LsLongFormatter
  def format(file_names, option)
    file_names = option['r'] ? file_names.sort.reverse : file_names.sort
    long_format_elements = get_long_format_data(file_names)
    separating_file_names = file_names.map { |f| File.basename(f) }

    total_blocks = long_format_elements.map(&:blocks).sum
    total = "total #{total_blocks}" if long_format_elements.size > 1

    format_result =
      long_format_elements.map.with_index do |element, index|
        file_type = convert_file_type(element.ftype)
        permisson = convert_permission(element.mode.to_s(8))
        link = element.nlink.to_s.rjust(2)
        user_name = Etc.getpwuid(element.uid).name
        authority = Etc.getgrgid(element.gid).name
        file_size = element.size.to_s.rjust(5)
        datetime = element.mtime.strftime('%_m %_d %_R')
        file_name = separating_file_names[index]

        "#{file_type}#{permisson}  #{link}  #{user_name}  #{authority}  #{file_size}  #{datetime}  #{file_name}"
      end
    [total, format_result]
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

    file_types[type]
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
