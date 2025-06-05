#!/usr/bin/env ruby
# frozen_string_literal: true

def main
  files = Dir.glob('*').sort_by(&:downcase)
  column_count = 3
  row_count = files.count.ceildiv(column_count)
  columns = split_into_columns(files, column_count, row_count)
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
  column_widths = columns.map { |words| words.map(&:size).max || 0 }
  (0...row_count).each do |row_idx|
    columns.each_with_index do |col, col_idx|
      filename = col[row_idx]
      print "#{filename.to_s.ljust(column_widths[col_idx])}  "
    end
    print "\n"
  end
end

main
