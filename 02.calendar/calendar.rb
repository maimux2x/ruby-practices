require 'date'
require 'optparse'

class Calender  
  def initialize(year: Date.today.year, month: Date.today.month)
    @year = year
    @month = month
  end
  
  def calender
    start_month = Date.new(@year, @month, 1)  
    end_month = Date.new(@year, @month, -1)
    
    puts "#{@month}月  #{@year}".center(20)
    
    days = ["日", "月", "火", "水", "木", "金", "土"]
    days.each do |day|
      print day.rjust(2)
    end

    print "\n"

    blank = start_month.wday
    (blank*3).times {print " "}
    
    (start_month..end_month).each do |d|
      print sprintf("%#3d", d.day)
      if d.saturday?
        print "\n"
      end

      if d == end_month
        break
      end
    end
  end
end

params = ARGV.getopts("y:", "m:")
cal = Calender.new(
  year: params["y"]&.to_i || Date.today.year,
  month: params["m"]&.to_i || Date.today.month
)
puts cal.calender

