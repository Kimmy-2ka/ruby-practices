#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

FILE_TYPES = {
  'file' => '-',
  'directory' => 'd',
  'characterSpecial' => 'c',
  'blockSpecial' => 'b',
  'fifo' => 'p',
  'link' => 'l',
  'socket' => 's'
}.freeze

PERMISSIONS = {
  '0' => { r: '-', w: '-', x: '-' },
  '1' => { r: '-', w: '-', x: 'x' },
  '2' => { r: '-', w: 'w', x: '-' },
  '3' => { r: '-', w: 'w', x: 'x' },
  '4' => { r: 'r', w: '-', x: '-' },
  '5' => { r: 'r', w: '-', x: 'x' },
  '6' => { r: 'r', w: 'w', x: '-' },
  '7' => { r: 'r', w: 'w', x: 'x' }
}.freeze

SPECIAL_FLAGS = {
  '1' => { idx: 2, with_x: 't', without_x: 'T' },
  '2' => { idx: 1, with_x: 's', without_x: 'S' },
  '4' => { idx: 0, with_x: 's', without_x: 'S' }
}.freeze

COLUMN_COUNT = 3

def main
  options = ARGV.getopts('alr')
  files = prepare_files(options)
  options['l'] ? output_long_format(files) : output_short_format(files)
end

def prepare_files(options)
  flags = options['a'] ? File::FNM_DOTMATCH : 0
  files = Dir.glob('*', flags)
  sorted_files = files.sort_by { |f| f.gsub(/[^a-z0-9]/i, '').downcase }
  options['r'] ? sorted_files.reverse : sorted_files
end

def prepare_file_details(files)
  file_details = []

  files.each do |file|
    filestat = File.stat(file)
    file_details << build_file_detail(file, filestat)
  end

  file_details
end

def build_file_detail(file, filestat)
  {
    blocks: filestat.blocks,
    permission: build_permission(filestat),
    link: filestat.nlink,
    owner_name: Etc.getpwuid(filestat.uid).name,
    group_name: Etc.getgrgid(filestat.gid).name,
    size: filestat.size,
    timestamp: filestat.mtime.strftime('%b %e %H:%M'),
    name: file
  }
end

def build_permission(filestat)
  octal_mode = filestat.mode.to_s(8)
  type = FILE_TYPES[filestat.ftype]
  special_permission_bit = octal_mode.slice(-4, 1)

  permission_chars =
    octal_mode.chars[-3..].map.with_index do |bit, idx|
      permission = PERMISSIONS[bit]
      special_flag = SPECIAL_FLAGS[special_permission_bit]
      if special_flag && special_flag[:idx] == idx
        apply_special_permission(special_flag, permission)
      else
        permission.values_at(:r, :w, :x).join
      end
    end

  [type, *permission_chars].join
end

def apply_special_permission(special_flag, permission)
  execute_char =
    permission[:x] == 'x' ? special_flag[:with_x] : special_flag[:without_x]

  "#{permission[:r]}#{permission[:w]}#{execute_char}"
end

def output_long_format(files)
  file_details = prepare_file_details(files)
  puts "total #{file_details.sum { |f| f[:blocks] } / 2}"
  widths =
    %i[link owner_name group_name size].to_h do |key|
      width = file_details.map { |file_detail| file_detail[key].to_s.size }.max
      [key, width]
    end

  file_details.each do |file_detail|
    row = [
      file_detail[:permission],
      file_detail[:link].to_s.rjust(widths[:link]),
      file_detail[:owner_name].to_s.ljust(widths[:owner_name]),
      file_detail[:group_name].to_s.ljust(widths[:group_name]),
      file_detail[:size].to_s.rjust(widths[:size]),
      file_detail[:timestamp],
      file_detail[:name]
    ]

    puts row.join(' ')
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

def output_short_format(files)
  row_count = files.count.ceildiv(COLUMN_COUNT)
  columns = split_into_columns(files, COLUMN_COUNT, row_count)
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
