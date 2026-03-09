# frozen_string_literal: true

require_relative 'entry'

class Command
  # オプションLがついているかを確認する
  # Entryの情報を持ったentriesを作成する。
  def initialize(files)
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
