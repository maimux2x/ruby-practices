# frozen_string_literal: true

require_relative 'add_option'

class LS
  class << self
    def current_empty?
      Dir.empty?(Dir.getwd)
    end

    def create_ary
      return true if current_empty?

      option = AddOption.new
      @first_ary =
        if option.has?('a')
          Dir.glob('*', File::FNM_DOTMATCH).sort
        else
          Dir.glob('*').sort
        end

      n = 3
      splite_ary = Rational(@first_ary.size, n).ceil

      second_ary = @first_ary.each_slice(splite_ary).to_a

      max_size = second_ary.map(&:size).max
      third_ary = second_ary.map { |ary| ary.values_at(0...max_size) }

      @result = third_ary.transpose
    end

    def output_current
      create_ary
      num = @first_ary.map(&:size).max
      @result.each do |ary|
        ary.each do |str|
          print str&.ljust(num + 5)
        end
        puts "\n"
      end
    end
  end
end

LS.output_current
