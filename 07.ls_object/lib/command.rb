# frozen_string_literal: true

require_relative 'entry'
require_relative 'formatter'

class Command
  def initialize(params, pathname)
    @entries = build_entries(params, pathname)
  end

  # Entryの情報を持ったentriesを作成する。
  def build_entries(params, pathname)
    entry_names = prepare_entry_names(params, pathname)
    entry_names.map do |name|
      path = pathname.join(name)
      Entry.new(name, path)
    end
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
  def output(params)
    if params[:long]
      Formatter.new(@entries).long_format
    else
      Formatter.new(@entries).short_format
    end
  end
end
