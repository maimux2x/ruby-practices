# frozen_string_literal: true

require 'date'
require 'optparse'

class Calendar
  def initialize(year:, month:)
    @year = year
    @month = month
  end

  def calendar
    puts "#{@month}月 #{@year}".center(20)
    
    puts "日 月 火 水 木 金 土"
    
    start_month = Date.new(@year, @month, 1)
    end_month = Date.new(@year, @month, -1)
    
    print " " * start_month.wday * 3

    (start_month..end_month).each do |date|
      print date.day.to_s.rjust(2) + " "
      print "\n" if date.saturday?
    end
    puts "\n"
  end
end

params = ARGV.getopts("y:", "m:")
cal = Calendar.new(
  year: params["y"]&.to_i || Date.today.year,
  month: params["m"]&.to_i || Date.today.month
)
cal.calendar
