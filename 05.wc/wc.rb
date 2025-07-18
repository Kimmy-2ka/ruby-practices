#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

opts = OptionParser.new

options = { newline: false, word: false, byte: false }
opts.on('-l') { |v| options[:newline] = v }
opts.on('-w') { |v| options[:word] = v }
opts.on('-c') { |v| options[:byte] = v }
opts.parse!(ARGV)

def main(options)
  enabled_options = filter_options(options)
  files = target_files_from_commandline
  file_counts = collect_counts(files)
  print_counts(enabled_options, file_counts)
end

def filter_options(options)
  enabled_options = options.select { |_key, value| value }.keys
  enabled_options.empty? ? %i[newline word byte] : enabled_options
end

def target_files_from_commandline
  if ARGV.empty?
    [{ text: $stdin.read, filename: nil }]
  else
    ARGV.map { |file| { text: File.read(file), filename: file } }
  end
end

def collect_counts(files)
  files.map do |file|
    { counts: count_values(text: file[:text]), filename: file[:filename] }
  end
end

def count_values(text:)
  {
    newline: text.count("\n"),
    word: text.strip.split(/\s+/).count,
    byte: text.size
  }
end

def print_counts(enabled_options, file_counts)
  if file_counts.size == 1 && enabled_options.size == 1
    widths = nil
  else
    total_counts = build_total_counts(file_counts)
    widths = calculate_widths(file_counts, total_counts)
  end

  print_row(enabled_options, widths, file_counts)
  print_row(enabled_options, widths, [total_counts]) if file_counts.size > 1
end

def build_total_counts(file_counts)
  total =
    %i[newline word byte].to_h do |key|
      sum = file_counts.sum { |file_count| file_count[:counts][key] }
      [key, sum]
    end

  { counts: total, filename: 'total' }
end

def calculate_widths(file_counts, total_counts)
  # stdin入力時はファイル名がnilなので、filenameで判定を行う。
  # stdin入力時の最小幅は7、ARGVからの指定時は2とする。
  min_width = file_counts.first[:filename].nil? ? 7 : 2
  max_width = total_counts[:counts].values.map { |value| value.to_s.size }.max
  [min_width, max_width].max
end

def print_row(enabled_options, widths, target_counts)
  target_counts.each do |target_count|
    row =
      enabled_options.map do |option|
        count_value = target_count[:counts][option].to_s
        widths ? count_value.rjust(widths) : count_value
      end
    row << target_count[:filename]
    puts row.compact.join(' ')
  end
end

main(options)
