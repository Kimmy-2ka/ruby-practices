# frozen_string_literal: true

require_relative 'entry'

class Formatter
  COLUMN_COUNT = 3

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
    '1' => { idx: 2, with_x: 't', without_x: 'T' },
    '2' => { idx: 1, with_x: 's', without_x: 'S' },
    '4' => { idx: 0, with_x: 's', without_x: 'S' }
  }.freeze

  def initialize(entries)
    @entries = entries
  end

  def short_format
    entries = @entries.map(&:name)
    # 行の長さを計算する
    row_count = entries.count.ceildiv(COLUMN_COUNT)
    # 列ごとの配列を作って長さを計算
    columns = build_columns(entries, row_count)
    format_table(row_count, columns)
  end

  def build_columns(entries, row_count)
    raw_columns = entries.each_slice(row_count).to_a
    pad_columns(raw_columns)
  end

  def pad_columns(raw_columns)
    column_widths = raw_columns.map { |column| column.map(&:size).max }
    raw_columns.each_with_index.map do |column, index|
      column.map { |entry| entry&.ljust(column_widths[index]) }
    end
  end

  def format_table(row_count, columns)
    row_count.times.map do |row_idx|
      columns.filter_map { |column| column[row_idx] }.join('  ').rstrip
    end.join("\n")
  end

  def long_format
    total = "合計 #{@entries.sum(&:blocks) / 2}"
    max_widths = build_max_widths

    body =
      @entries.map do |entry|
        [format_mode(entry),
         entry.nlink.to_s.rjust(max_widths[:nlink]),
         entry.user.ljust(max_widths[:user]),
         entry.group.ljust(max_widths[:group]),
         entry.size.to_s.rjust(max_widths[:size]),
         entry.mtime,
         entry.name].join(' ')
      end.join("\n")

    [total, body].join("\n")
  end

  def build_max_widths
    {
      nlink: @entries.map { |entry| entry.nlink.to_s.size }.max,
      user: @entries.map { |entry| entry.user.to_s.size }.max,
      group: @entries.map { |entry| entry.group.to_s.size }.max,
      size: @entries.map { |entry| entry.size.to_s.size }.max
    }
  end

  def format_mode(entry)
    type = FILE_TYPES[entry.type]
    permission_numbers = entry.mode.slice(-3..-1).chars
    special_flag = entry.mode.slice(-4, 1)

    permissions = build_permissions(permission_numbers, special_flag)
    [type, permissions].join
  end

  def build_permissions(permission_numbers, special_flag)
    permission_numbers.map.with_index do |number, idx|
      permission = PERMISSIONS[number]
      flag = SPECIAL_FLAGS[special_flag]

      if flag && idx == flag[:idx]
        new_execute = permission[2] == 'x' ? flag[:with_x] : flag[:without_x]
        permission.sub(/.$/, new_execute)
      else
        permission
      end
    end.join
  end
end
