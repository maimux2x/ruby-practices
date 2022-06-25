# frozen_string_literal: true

require 'etc'
require_relative 'app_option'

class LS
  def current_empty?
    Dir.empty?(Dir.getwd)
  end

  def create_file_name_ary(option)
    file_name_ary = Dir.glob('*', option.has?('a') ? File::FNM_DOTMATCH : 0).sort
    file_name_ary = file_name_ary.reverse if option.has?('r')
    file_name_ary
  end

  # オプションなし、aオプション、rオプションの出力情報
  def prepare_output_file_name(check_option_results)
    first_ary = check_option_results
    n = 3
    splite_ary = Rational(first_ary.size, n).ceil

    second_ary = first_ary.each_slice(splite_ary).to_a

    max_size = second_ary.map(&:size).max
    third_ary = second_ary.map { |ary| ary.values_at(0...max_size) }

    third_ary.transpose
  end

  # lオプションの出力情報
  def create_file_desc(file_names)
    desc_materials = file_names

    desc_materials.map { |desc| File::Stat.new(desc.to_s) }
  end

  def output_file_desc(option)
    file_names = create_file_name_ary(option)
    desc_results = create_file_desc(file_names)

    total_blocks = desc_results.map(&:blocks)
    puts "total #{total_blocks.sum}"

    desc_results.each_with_index do |desc, index|
      convert_file_type(desc.ftype)
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
    
    if option.has?('l') #オプション複数指定は次回対応
      output_file_desc(option)
    else
      check_option_results = create_file_name_ary(option)
      results = prepare_output_file_name(check_option_results)
      num = check_option_results.map(&:size).max

      results.each do |ary|
        ary.each do |str|
          print str&.ljust(num + 5)
        end
        puts "\n"
      end
    end
  end

  private

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

    file_types.each do |key, value|
      print value if type == key
    end
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
