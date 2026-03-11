# frozen_string_literal: true

require_relative 'entry'

class Command
  # オプションLがついているかを確認する
  def initialize(pathname)
    p pathname
    files = Dir.glob('*', 0, base: pathname, sort: true)
    @entries = build_entries(files)
  end

  def build_entries(files)
    entries = []
    files.each do |file|
      entry = Entry.new(file)
      entries << entry.to_s # テストのため一旦文字列に戻しておく
    end
    entries
  end

  # 表示する
  def output
    @entries.join('  ')
  end
end
