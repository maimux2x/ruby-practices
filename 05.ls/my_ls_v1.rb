# frozen_string_literal: true

require 'etc'
require_relative 'app_option'

class LS
  def directory_or_file?(params)
    File.exist?(params)
  end

  def dir_empty?(params)
    Dir.empty?(params || Dir.getwd)
  end

  def get_file_names(option, params)
    option_a = option.has?(:a) ? File::FNM_DOTMATCH : 0

    return params.split if File.ftype(params) == 'file'

    file_names = if option.has?(:l)
                   Dir.glob("#{params}/*", option_a).sort
                 else
                   Dir.glob('*', option_a, base: params).sort
                 end
    file_names = file_names.reverse if option.has?(:r)
    file_names
  end

  # オプションなし、aオプション、rオプションの出力情報
  def prepare_output_file_names(file_names)
    splite_num = Rational(file_names.size, 3).ceil

    second_file_names = file_names.each_slice(splite_num).to_a

    max_size = second_file_names.map(&:size).max
    third_file_names = second_file_names.map { |name| name.values_at(0...max_size) }

    third_file_names.transpose
  end

  def output_file_names(file_names)
    results = prepare_output_file_names(file_names)
    num = file_names.map(&:size).max

    results.each do |ary|
      ary.each do |name|
        adjustment_not_ascii = name&.chars&.count { |str| !str.ascii_only? }
        print name&.ljust(num - adjustment_not_ascii + 5)
      end
      puts "\n"
    end
  end

  # lオプションの出力情報
  def get_file_desc(file_names)
    file_names.map { |desc| File::Stat.new(File.expand_path(desc).to_s) }
  end

  def output_file_desc(file_names, params)
    desc_results = get_file_desc(file_names)
    only_file_names = file_names.map { |file| file.gsub("#{params}/", '') }

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

  # 出力情報の呼び出し
  def ls_output(option, params)
    return puts "#{params}: No such file or directory" unless directory_or_file?(params)
    return if dir_empty?(params)

    file_names = get_file_names(option, params)
    if option.has?(:l)
      output_file_desc(file_names, params)
    else
      output_file_names(file_names)
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
option = AppOption.new
params = ARGV[0] || '.'
ls = LS.new
ls.ls_output(option, params)
