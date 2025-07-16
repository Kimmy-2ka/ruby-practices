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
  stdin_mode = ARGV.empty?
  counted_files = collect_counted_files(stdin_mode)
  print_counts(enabled_options, stdin_mode, counted_files)
end

def filter_options(options)
  if options.any? { |_key, value| value }
    options.select { |_key, value| value }.keys
  else
    %i[newline word byte]
  end
end

def collect_counted_files(stdin_mode)
  if stdin_mode
    [{ counts: count_values(text: $stdin.read), filename: nil }]
  else
    ARGV.map do |file|
      { counts: count_values(text: File.read(file)), filename: file }
    end
  end
end

def count_values(text:)
  {
    newline: text.count("\n"),
    word: text.split(/\s+/).count,
    byte: text.size
  }
end

def print_counts(enabled_options, stdin_mode, counted_files)
  if counted_files.size == 1 && enabled_options.size == 1
    widths = nil
  else
    total_counts = build_total_counts(counted_files)
    widths = format_widths(stdin_mode, total_counts)
  end

  print_row(enabled_options, widths, counted_files)
  print_row(enabled_options, widths, [total_counts]) unless counted_files.size == 1
end

def build_total_counts(counted_files)
  total =
    %i[newline word byte].to_h do |key|
      sum = counted_files.sum { |file| file[:counts][key] }
      [key, sum]
    end

  { counts: total, filename: 'total' }
end

def format_widths(stdin_mode, total_counts)
  min_width = stdin_mode ? 7 : 2
  max_width = total_counts[:counts].values.map { |value| value.to_s.size }.max
  [min_width, max_width].max
end

def print_row(enabled_options, widths, files)
  files.each do |file|
    row =
      enabled_options.map do |option|
        count_value = file[:counts][option].to_s
        widths ? count_value.rjust(widths) : count_value
      end
    row << file[:filename]
    puts row.compact.join(' ')
  end
end

main(options)
