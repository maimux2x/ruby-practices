# frozen_string_literal: true

require_relative 'app_option'

class WC
  def output_wc(params, option, stdin_tty)
    wc_items = params.map do |param|
      !file_exist?(param) && stdin_tty ? param : build_wc(param)
    end

    total = calc_total(wc_items)

    if stdin_tty
      wc_items.each do |item|
        output_results(item, option)
      end

      if params.length > 1
        print_total(total, option)
        print "total\n"
      end
    else
      print_total(total, option)
      puts "\n"
    end
  end

  def file_exist?(param)
    File.exist?(param)
  end

  def build_wc(param)
    wc_parts = file_exist?(param) ? File.read(param) : param
    {
      n_lines: wc_parts.count("\n"),
      words: wc_parts.split(' ').length,
      byte_size: wc_parts.bytesize,
      file: param
    }
  end

  def output_results(item, option)
    if item.instance_of?(Hash)
      print_items(item, option)
    else
      puts "wc: #{item}: open: No such file or directory"
    end
  end

  def print_items(item, option)
    printf('%<n_lines>8s ', item) if option.has?(:l) || option.not_has?
    printf('%<words>8s ', item) if option.has?(:w) || option.not_has?
    printf('%<byte_size>8s ', item) if option.has?(:c) || option.not_has?
    printf("%<file>s\n", item)
  end

  def calc_total(wc_items)
    wc_items.each_with_index do |_, index|
      wc_items -= [wc_items[index]] if wc_items[index].instance_of?(String)
    end

    {
      lines_total: wc_items.map { |wc| wc[:n_lines] }.sum,
      words_total: wc_items.map { |wc| wc[:words] }.sum,
      byte_size_total: wc_items.map { |wc| wc[:byte_size] }.sum
    }
  end

  def print_total(total, option)
    printf('%<lines_total>8s ', total) if option.has?(:l) || option.not_has?
    printf('%<words_total>8s ', total) if option.has?(:w) || option.not_has?
    printf('%<byte_size_total>8s ', total) if option.has?(:c) || option.not_has?
  end
end

stdin_tty = $stdin.tty?
params = stdin_tty ? ARGV : $stdin.readlines

option = AppOption.new

wc = WC.new
wc.output_wc(params, option, stdin_tty)
