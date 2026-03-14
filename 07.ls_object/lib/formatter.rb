# frozen_string_literal: true

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

  # idxは特殊権限に置き換える対象がowner/group/othersのどれかを表している
  SPECIAL_FLAGS = {
    '1' => { idx: 2, with_x: 't', without_x: 'T' },  # others
    '2' => { idx: 1, with_x: 's', without_x: 'S' },  # group
    '4' => { idx: 0, with_x: 's', without_x: 'S' }   # owner
  }.freeze

  def initialize(entries)
    @entries = entries
  end

  def short_format
    names = @entries.map(&:name)
    row_count = names.count.ceildiv(COLUMN_COUNT)
    columns = names.each_slice(row_count).to_a
    padded_columns = pad_columns(columns)
    format_table(row_count, padded_columns)
  end

  def long_format
    total = "合計 #{@entries.sum(&:blocks) / 2}"
    body = format_body

    [total, body].join("\n")
  end

  private

  def pad_columns(raw_columns)
    column_widths = raw_columns.map { |column| column.map(&:size).max }
    raw_columns.each_with_index.map do |column, idx|
      column.map { |entry| entry.ljust(column_widths[idx]) }
    end
  end

  def format_table(row_count, columns)
    row_count.times.map do |idx|
      columns.filter_map { |column| column[idx] }.join('  ').rstrip
    end.join("\n")
  end

  def format_body
    max_widths = build_max_widths
    @entries.map do |entry|
      [
        format_type_and_mode(entry),
        entry.nlink.to_s.rjust(max_widths[:nlink]),
        entry.user.ljust(max_widths[:user]),
        entry.group.ljust(max_widths[:group]),
        entry.size.to_s.rjust(max_widths[:size]),
        entry.mtime.strftime('%_m月 %e %H:%M'),
        entry.name
      ].join(' ')
    end.join("\n")
  end

  def build_max_widths
    %i[nlink user group size].to_h do |key|
      width = @entries.map { |entry| entry.public_send(key).to_s.size }.max
      [key, width]
    end
  end

  def format_type_and_mode(entry)
    type = FILE_TYPES[entry.type]
    mode = format_mode(entry)

    [type, mode].join
  end

  def format_mode(entry)
    digits = entry.mode.slice(-3..-1).chars
    special_mode_bit = entry.mode.slice(-4, 1)
    special_flag = SPECIAL_FLAGS[special_mode_bit]

    digits.map.with_index do |digit, idx|
      permission = PERMISSIONS[digit]

      special_flag && idx == special_flag[:idx] ? apply_special_permission(permission, special_flag) : permission
    end.join
  end

  def apply_special_permission(permission, special_flag)
    execute_char = permission[2] == 'x' ? special_flag[:with_x] : special_flag[:without_x]
    permission.sub(/.$/, execute_char)
  end
end
