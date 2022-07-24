# frozen_string_literal: true

require_relative 'app_option'

class WC
  def output_wc(params, option)
    wc_items = prepare_build_wc(params)
    wc_items.each do |item|
      output_results(item, option)
    end

    return unless params.length > 1

    total = calc_total(wc_items)
    output_results(total, option)
    print "total\n"
  end

  def output_stdin_wc(params, option)
    wc_items = build_wc(params.join(' '), params)

    wc_items.delete(:file)
    output_results(wc_items, option)
    puts "\n"
  end

  def prepare_build_wc(params)
    params.map do |param|
      next param unless File.exist?(param)
      next param if File.ftype(param) == 'directory'

      wc_parts = File.read(param)
      build_wc(wc_parts, param)
    end
  end

  def build_wc(wc_parts, file_name)
    {
      n_lines: wc_parts.count("\n"),
      words: wc_parts.split(' ').length,
      byte_size: wc_parts.bytesize,
      file: file_name
    }
  end

  def calc_total(wc_items)
    wc_items.each do |item|
      wc_items -= [item] if item.instance_of?(String)
    end

    {
      lines_total: wc_items.map { |wc| wc[:n_lines] }.sum,
      words_total: wc_items.map { |wc| wc[:words] }.sum,
      byte_size_total: wc_items.map { |wc| wc[:byte_size] }.sum
    }
  end

  def output_results(result, option)
    if result.instance_of?(Hash)
      print_item(result, option)
    elsif File.exist?(result)
      puts "wc: #{result}: read: Is a directory"
    else
      puts "wc: #{result}: open: No such file or directory"
    end
  end

  def print_item(result, option)
    if result.key?(:n_lines)
      lines = '%<n_lines>8s '
      words = '%<words>8s '
      byte_size = '%<byte_size>8s '
    elsif result.key?(:lines_total)
      lines = '%<lines_total>8s '
      words = '%<words_total>8s '
      byte_size = '%<byte_size_total>8s '
    end

    printf(lines, result) if option.has?(:l)
    printf(words, result) if option.has?(:w)
    printf(byte_size, result) if option.has?(:c)
    printf("%<file>s\n", result) if result.key?(:file)
  end
end

stdin_tty = $stdin.tty?
params = stdin_tty ? ARGV : $stdin.readlines

option = AppOption.new

wc = WC.new

wc.send(stdin_tty ? :output_wc : :output_stdin_wc, params, option)
