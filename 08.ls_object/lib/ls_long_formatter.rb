# frozen_string_literal: true

require 'etc'
require_relative '../lib/ls_formatter'

class LsLongFormatter < LsFormatter
  def output_ls(file)
    desc_results = get_file_desc(file.file_names)
    only_file_names = file.file_names.map { |f| f.gsub("#{file.params}/", '') }

    total_blocks = desc_results.map(&:blocks).sum
    puts "total #{total_blocks}" if desc_results.size > 1

    desc_results.each_with_index do |desc, index|
      convert_file_type(desc.ftype.to_sym)
      convert_permission(desc.mode.to_s(8))
      print [
        desc.nlink.to_s.rjust(2),
        Etc.getpwuid(desc.uid).name,
        Etc.getgrgid(desc.gid).name,
        desc.size.to_s.rjust(5),
        desc.mtime.strftime('%_m %_d %_R'),
        only_file_names[index]
      ].join('  ')
      puts "\n"
    end
  end

  private

  def get_file_desc(file_names)
    file_names.map { |desc| File::Stat.new(File.expand_path(desc).to_s) }
  end

  def convert_file_type(type)
    file_types = {
      fifo: 'p',
      characterSpecial: 'c',
      directory: 'd',
      blockSpecial: 'b',
      file: '-',
      link: 'l',
      socket: 's'
    }

    file_types.filter { |key, _| key == type }.each { |_, value| print value }
  end

  def convert_permission(mode)
    permissions = {
      'rwx' => '7',
      'rw-' => '6',
      'r-x' => '5',
      'r--' => '4',
      '-wx' => '3',
      '-w-' => '2',
      '--x' => '1',
      '---' => '0'
    }

    last_nums = mode.slice(-1)
    last_two_nums = mode.slice(-2)
    last_three_nums = mode.slice(-3)

    permissions.each do |key, value|
      print key if value == last_three_nums
      print key if value == last_two_nums
      print key.ljust(5) if value == last_nums
    end
  end
end
