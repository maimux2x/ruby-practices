# frozen_string_literal: true

require 'etc'
require_relative 'app_option'

class LS
  def current_empty?
    Dir.empty?(Dir.getwd)
  end

  def check_option
    @option = AppOption.new
    check_result = Dir.glob('*', @option.has?('a') ? File::FNM_DOTMATCH : 0).sort
    check_result = check_result.reverse if @option.has?('r')
    check_result
  end

  # オプションなし、aオプション、rオプションの出力情報
  def prepare_output_name(check_option_result)
    first_ary = check_option_result
    n = 3
    splite_ary = Rational(first_ary.size, n).ceil

    second_ary = first_ary.each_slice(splite_ary).to_a

    max_size = second_ary.map(&:size).max
    third_ary = second_ary.map { |ary| ary.values_at(0...max_size) }

    third_ary.transpose
  end

  # lオプションの出力情報
  def create_current_desc(current_ary)
    desc_matelial = current_ary

    current_desc = []
    desc_matelial.each do |desc|
      current_desc.push File::Stat.new(desc.to_s)
    end
    current_desc
  end

  def output_current_desc
    raw_current_ary = check_option
    desc_result = create_current_desc(raw_current_ary)

    total_block = desc_result.map(&:blocks)
    puts "total #{total_block.sum}"

    desc_result.each_with_index do |desc, index|
      convert_file_type(desc.ftype)
      convert_permission(desc.mode.to_s(8))
      print desc.nlink,
            '  ',
            Etc.getpwuid(desc.uid).name,
            '  ',
            Etc.getgrgid(desc.gid).name,
            '  ',
            desc.size.to_s.rjust(5),
            '  ',
            desc.mtime.strftime('%_m %_d %_R'),
            '  ',
            raw_current_ary[index]
      puts "\n"
    end
  end

  # current配下の出力処理
  def output_current
    return if current_empty?

    check_option_result = check_option

    if @option.has?('l') #オプションの複数指定は次回対応
      output_current_desc
    else
      result = prepare_output_name(check_option_result)
      num = check_option_result.map(&:size).max

      result.each do |ary|
        ary.each do |str|
          print str&.ljust(num + 5)
        end
        puts "\n"
      end
    end
  end

  private

  def convert_file_type(type)
    file_type = {
      'fifo' => 'p',
      'characterSpecial' => 'c',
      'directory' => 'd',
      'blockSpecial' => 'b',
      'file' => '-',
      'link' => 'l',
      'socket' => 's'
    }

    file_type.each do |key, value|
      print value if type == key
    end
  end

  def convert_permission(mode)
    permission = {
      'rwx' => '7',
      'rw-' => '6',
      'r-x' => '5',
      'r--' => '4',
      '-wx' => '3',
      '-w-' => '2',
      '--x' => '1',
      '---' => '0'
    }

    last_num = mode.slice(-1)
    last_two_num = mode.slice(-2)
    last_three_num = mode.slice(-3)

    permission.each do |key, value|
      print key if value == last_three_num
      print key if value == last_two_num
      print key.ljust(5) if value == last_num
    end
  end
end

ls = LS.new
ls.output_current
