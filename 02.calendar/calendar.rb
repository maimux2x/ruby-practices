# frozen_string_literal: true

require 'date'
require 'optparse'

class Calender
  def initialize(year: Date.today.year, month: Date.today.month)
    @year = year
    @month = month
  end

  def calender
    puts "#{@month}月 #{@year}".center(20)
    
    puts "日 月 火 水 木 金 土"
    
    start_month = Date.new(@year, @month, 1)
    end_month = Date.new(@year, @month, -1)
    
    print " " * start_month.wday * 3

    (start_month..end_month).each do |date|
      if date.day <= 9
        print format("%# 2d", date.day)
        print " " unless date.saturday?
      else
        print format("%#-3d", date.day)
      end
      print "\n" if date.saturday?
    end
    puts "\n"
  end
end

params = ARGV.getopts("y:", "m:")
cal = Calender.new(
  year: params["y"]&.to_i || Date.today.year,
  month: params["m"]&.to_i || Date.today.month
)
cal.calender
