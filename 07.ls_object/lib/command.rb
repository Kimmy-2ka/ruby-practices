# frozen_string_literal: true

require_relative 'entry'
require_relative 'formatter'

class Command
  # オプションLがついているかを確認する
  def initialize(params, pathname)
    files =
      if params[:all]
        Dir.entries(pathname)
      else
        Dir.glob('*', base: pathname)
      end.sort

    @entries = build_entries(files)
  end

  # Entryの情報を持ったentriesを作成する。
  def build_entries(files)
    entries = []
    files.each do |file|
      entry = Entry.new(file)
      entries << entry
    end
    entries
  end

  # 表示する
  def output
    Formatter.new(@entries).format
  end
end
