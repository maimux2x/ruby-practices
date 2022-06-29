# frozen_string_literal: true

require 'etc'
require_relative 'app_option'

class LS
  def current_empty?
    Dir.empty?(Dir.getwd)
  end

  def get_file_names(option)
    file_names = Dir.glob('*', option.has?('a') ? File::FNM_DOTMATCH : 0).sort
    file_names = file_names.reverse if option.has?('r')
    file_names
  end

  # オプションなし、aオプション、rオプションの出力情報
  def prepare_output_file_names(file_names)
    first_file_names = file_names
    n = 3
    splite_num = Rational(first_file_names.size, n).ceil

    second_file_names = first_file_names.each_slice(splite_num).to_a

    max_size = second_file_names.map(&:size).max
    third_file_names = second_file_names.map { |name| name.values_at(0...max_size) }

    third_file_names.transpose
  end

  # lオプションの出力情報
  def get_file_desc(file_names)
    desc_materials = file_names

    desc_materials.map { |desc| File::Stat.new(desc.to_s) }
  end

  def output_file_desc(file_names)
    desc_results = get_file_desc(file_names)

    total_blocks = desc_results.map(&:blocks)
    puts "total #{total_blocks.sum}"

    desc_results.each_with_index do |desc, index|
      convert_file_type(desc.ftype.to_sym)
      convert_permission(desc.mode.to_s(8))
      print [
        desc.nlink,
        Etc.getpwuid(desc.uid).name,
        Etc.getgrgid(desc.gid).name,
        desc.size.to_s.rjust(5),
        desc.mtime.strftime('%_m %_d %_R'),
        file_names[index]
      ].join('  ')
      puts "\n"
    end
  end

  # current配下の出力処理
  def output_current
    return if current_empty?

    option = AppOption.new

    file_names = get_file_names(option)
    if option.has?('l') # オプション複数指定は次回対応
      output_file_desc(file_names)
    else
      results = prepare_output_file_names(file_names)
      num = file_names.map(&:size).max

      results.each do |ary|
        ary.each do |name|
          print name&.ljust(num + 5)
        end
        puts "\n"
      end
    end
  end

  private

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

ls = LS.new
ls.output_current
