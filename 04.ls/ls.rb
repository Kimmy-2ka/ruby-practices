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
  if options['l']
    blocks, file_details = prepare_file_details(files)
    output_long_format(blocks, file_details)
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

def prepare_file_details(files)
  file_details = []
  blocks = 0

  files.each do |filename|
    filestat = File.stat(filename)
    blocks += filestat.blocks
    file_details << build_file_detail(filename, filestat)
  end
  [blocks, file_details]
end

def build_file_detail(filename, filestat)
  file_permissions = build_file_permissions(filestat)
  {
    permission: file_permissions,
    link: filestat.nlink,
    owner_name: Etc.getpwuid(filestat.uid).name,
    group_name: Etc.getgrgid(filestat.gid).name,
    size: filestat.size,
    timestamp: filestat.mtime.strftime('%b %e %H:%M'),
    name: filename
  }
end

def build_file_permissions(filestat)
  octal_mode = filestat.mode.to_s(8)

  file_permissions = [FILE_TYPE[filestat.ftype]]
  special_permission_bits = octal_mode.slice(-4, 1)

  octal_mode.chars[-3..].each_with_index do |bit, idx|
    permission = PERMISSIONS[bit]
    special_flag = SPECIAL_FLAGS[special_permission_bits]
    file_permissions << if special_flag && special_flag[:idx] == idx
                          update_permission(special_flag, permission)
                        else
                          permission.values_at(:r, :w, :x).join
                        end
  end

  file_permissions.join
end

def update_permission(special_flag, permission)
  updated_execute =
    permission[:x] == 'x' ? special_flag[:with_x] : special_flag[:without_x]

  "#{permission[:r]}#{permission[:w]}#{updated_execute}"
end

def output_long_format(blocks, file_details)
  puts "total #{blocks / 2}"
  link_width, owner_width, group_width, size_width =
    %i[link owner_name group_name size].map do |key|
      file_details.map { |file_detail| file_detail[key].to_s.size }.max
    end

  file_details.each do |file_detail|
    puts [
      file_detail[:permission],
      file_detail[:link].to_s.rjust(link_width),
      file_detail[:owner_name].to_s.ljust(owner_width),
      file_detail[:group_name].to_s.ljust(group_width),
      file_detail[:size].to_s.rjust(size_width),
      file_detail[:timestamp],
      file_detail[:name]
    ].join(' ')
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
