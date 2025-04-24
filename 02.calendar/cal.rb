#!/usr/bin/env ruby

require 'optparse'
params = {}
opt = OptionParser.new
opt.on('-m [VAL]', "月") { |m| params[:month] = m }
opt.on('-y [VAL]', "年") { |y| params[:year] = y }
opt.parse(ARGV)

require "date"
today = Date.today
if params[:month]
  target_month = params[:month].to_i
else
  target_month = today.month
end
if params[:year]
  target_year = params[:year].to_i
else
  target_year = today.year
end
first_day = Date.new(target_year, target_month, 1)
last_day = Date.new(target_year, target_month, -1)
print (first_day.strftime("%B") + " " + first_day.year.to_s).center(21)
puts
["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"].each do |weekday|
  print weekday.rjust(3)
end
puts
(first_day..last_day).each do |x|
  if first_day == x
    print "   " * first_day.wday
  end
  print x.day.to_s.rjust(3)
  if x.strftime("%a") == "Sat"
    puts
  end
end
