#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COLUMN_COUNT = 3

def main
  options = ARGV.getopts('ar')
  files = prepare_files(options)
  row_count = files.count.ceildiv(COLUMN_COUNT)
  columns = split_into_columns(files, COLUMN_COUNT, row_count)
  output(columns, row_count)
end

def prepare_files(options)
  flags = options['a'] ? File::FNM_DOTMATCH : 0
  files = Dir.glob('*', flags)
  sorted_files = files.sort_by { |f| f.gsub(/[^a-z0-9]/i, '').downcase }
  options['r'] ? sorted_files.reverse : sorted_files
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
    cols = columns.filter_map.with_index do |col, col_idx|
      filename = col[row_idx]
      filename&.ljust(column_widths[col_idx])
    end
    puts cols.join('  ')
  end
end

main
