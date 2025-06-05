#!/usr/bin/env ruby
# frozen_string_literal: true

COLUMN_COUNT = 3

def main
  files = Dir.glob('*').sort_by(&:downcase)
  row_count = files.count.ceildiv(COLUMN_COUNT)
  columns = split_into_columns(files, COLUMN_COUNT, row_count)
  output(columns, row_count)
end

def split_into_columns(files, column_count, row_count)
  column_group = Array.new(column_count) { [] }
  files.each_with_index do |file, index|
    col_index = index / row_count
    column_group[col_index] << file
  end
  column_group
end

def output(columns, row_count)
  column_widths = columns.map { |words| words.map(&:size).max }
  row_count.times do |row_idx|
    columns.each_with_index do |col, col_idx|
      filename = col[row_idx]
      print "#{filename.ljust(column_widths[col_idx])}  " if filename
    end
    print "\n"
  end
end

main
