#!/usr/bin/env ruby

require 'optparse'
params = {}
opt = OptionParser.new
opt.on('-m [VAL]', "月") { |m| params[:month] = m }
opt.on('-y [VAL]', "年") { |y| params[:year] = y }
opt.parse(ARGV)

require "date"
today = Date.today
target_month = params[:month] ? params[:month].to_i : today.month
target_year = params[:year] ? params[:year].to_i : today.year

first_day = Date.new(target_year, target_month, 1)
last_day = Date.new(target_year, target_month, -1)

print [first_day.strftime("%B"), first_day.year.to_s].join(' ').center(21)
puts
["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"].each do |weekday|
  print weekday.rjust(3)
end
puts
print "   " * first_day.wday
(first_day..last_day).each do |x|
  print x.day.to_s.rjust(3)
  puts if x.saturday?
end
