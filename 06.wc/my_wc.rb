# frozen_string_literal: true

require_relative 'app_option'

class WC
  def output_wc(params, option, stdin_tty)
    wc_items = prepare_build_wc(params, stdin_tty)

    if stdin_tty
      wc_items.each do |item|
        output_results(item, option)
      end

      total = calc_total(wc_items)
      if params.length > 1
        output_results(total, option)
        print "total\n"
      end
    else
      wc_items.delete(:file)
      output_results(wc_items, option)
      puts "\n"
    end
  end

  def prepare_build_wc(params, stdin_tty)
    if stdin_tty
      params.map do |param|
        if File.exist?(param)
          wc_parts = File.read(param)
          build_wc(wc_parts, param)
        else
          param
        end
      end
    else
      wc_parts = params.join(' ')
      build_wc(wc_parts, params)
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

    option.not_has?
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
wc.output_wc(params, option, stdin_tty)
