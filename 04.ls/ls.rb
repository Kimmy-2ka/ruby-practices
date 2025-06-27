#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

FILE_TYPE = {
  'file' => '-',
  'directory' => 'd',
  'characterSpecial' => 'c',
  'blockSpecial' => 'b',
  'fifo' => 'p',
  'link' => 'l',
  'socket' => 's'
}.freeze
PERMISSION = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze
SPECIAL_FLAGS = {
  '1' => { index: 9, with_x: 't', without_x: 'T' },
  '2' => { index: 6, with_x: 's', without_x: 'S' },
  '4' => { index: 3, with_x: 's', without_x: 'S' }
}.freeze
COLUMN_COUNT = 3

def main
  options = ARGV.getopts('arl')
  files = prepare_files(options)
  if options['l']
    handle_long_format(files)
  else
    row_count = files.count.ceildiv(COLUMN_COUNT)
    columns = split_into_columns(files, COLUMN_COUNT, row_count)
    output_short_format(columns, row_count)
  end
end

def prepare_files(options)
  flags = options['a'] ? File::FNM_DOTMATCH : 0
  files = Dir.glob('*', flags)
  sorted_files = files.sort_by { |f| f.gsub(/[^a-z0-9]/i, '').downcase }
  options['r'] ? sorted_files.reverse : sorted_files
end

def handle_long_format(files)
  file_details = []
  total_512_blocks = 0

  files.each do |filename|
    filestat = File.stat(filename)
    total_512_blocks += filestat.blocks
    file_details << organize_file_details(filename, filestat)
  end
  output_long_format(total_512_blocks, file_details)
end

def organize_file_details(filename, filestat)
  file_permissions_string = organize_file_permission_string(filestat)
  [
    file_permissions_string,
    filestat.nlink,
    Etc.getpwuid(filestat.uid).name,
    Etc.getgrgid(filestat.gid).name,
    filestat.size,
    filestat.mtime.strftime('%b %e %H:%M'),
    filename
  ]
end

def organize_file_permission_string(filestat)
  octal_mode = filestat.mode.to_s(8)

  file_permissions = []
  file_permissions.push(FILE_TYPE[filestat.ftype])

  octal_mode.chars[-3..].each do |bit|
    file_permissions << PERMISSION[bit]
  end

  file_permissions_string = file_permissions.join

  special_permission_bits = octal_mode.slice(-4, 1)
  if special_permission_bits != '0'
    file_permissions_string =
      check_special_permissions(special_permission_bits, file_permissions_string)
  end

  file_permissions_string
end

def check_special_permissions(special_permission_bits, file_permissions_string)
  special_flag = SPECIAL_FLAGS[special_permission_bits]

  file_permissions_string[special_flag[:index]] =
    file_permissions_string[special_flag[:index]] == 'x' ? special_flag[:with_x] : special_flag[:without_x]

  file_permissions_string
end

def output_long_format(total_512_blocks, file_details)
  puts "total #{total_512_blocks / 2}"
  size_widths = file_details.map { |file_detail| file_detail[4].to_s.size }.max
  file_details.each do |file_detail|
    file_detail[4] = file_detail[4].to_s.rjust(size_widths)
    puts file_detail.join(' ')
  end
end

def split_into_columns(files, column_count, row_count)
  column_group = Array.new(column_count) { [] }
  files.each_with_index do |file, index|
    col_index = index / row_count
    column_group[col_index] << file
  end
  column_group
end

def output_short_format(columns, row_count)
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
