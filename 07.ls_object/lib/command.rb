# frozen_string_literal: true

require_relative 'entry'
require_relative 'formatter'

class Command
  # オプションLがついているかを確認する
  def initialize(params, pathname)
    @entries = build_entries(params, pathname)
  end

  # Entryの情報を持ったentriesを作成する。
  def build_entries(params, pathname)
    entry_names = prepare_entry_names(params, pathname)
    entry_names.map { |name| Entry.new(name) }
  end

  def prepare_entry_names(params, pathname)
    entry_names =
      if params[:all]
        Dir.entries(pathname)
      else
        Dir.glob('*', base: pathname)
      end.sort

    params[:reverse] ? entry_names.reverse : entry_names
  end

  # 表示する
  def output
    Formatter.new(@entries).format
  end
end
