# frozen_string_literal: true

require_relative 'entry'

class Formatter
  COLUMN_COUNT = 3

  def initialize(entries)
    @entries = entries.map(&:to_s)
  end

  def format
    # 行の長さを計算する
    row_count = @entries.count.ceildiv(COLUMN_COUNT)
    # 列ごとの配列を作って長さを計算
    columns = build_columns(row_count)
    format_table(row_count, columns)
  end

  def build_columns(row_count)
    raw_columns = @entries.each_slice(row_count).to_a
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
end
