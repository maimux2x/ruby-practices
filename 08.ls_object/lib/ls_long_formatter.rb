# frozen_string_literal: true

require 'etc'

class LsLongFormatter
  def output_ls(file)
    desc_results = get_file_desc(file.file_names)
    separating_file_names = file.file_names.map { |f| f.gsub("#{file.file}/", '') }

    total_blocks = desc_results.map(&:blocks).sum
    puts "total #{total_blocks}" if desc_results.size > 1

    desc_results.map.with_index do |desc, index|
      file_type = convert_file_type(desc.ftype)
      permisson = convert_permission(desc.mode.to_s(8))
      link = desc.nlink.to_s.rjust(2)
      user_name = Etc.getpwuid(desc.uid).name
      authority = Etc.getgrgid(desc.gid).name
      file_size = desc.size.to_s.rjust(5)
      datetime = desc.mtime.strftime('%_m %_d %_R')
      file_name = separating_file_names[index]

      "#{file_type[0]}#{permisson}  #{link}  #{user_name}  #{authority}  #{file_size}  #{datetime}  #{file_name}"
    end
  end

  private

  def get_file_desc(file_names)
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

    file_types.filter { |key, _| key == type }.map { |_, value| value }
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
