# frozen_string_literal: true

require_relative 'entry'
require_relative 'formatter'

class Command
  def initialize(params, pathname)
    @entries = build_entries(params, pathname)
  end

  def output(params)
    formatter = Formatter.new(@entries)
    params[:long] ? formatter.long_format : formatter.short_format
  end

  private

  def build_entries(params, pathname)
    entry_names = prepare_entry_names(params, pathname)
    entry_names.map do |name|
      path = pathname.join(name)
      Entry.new(name, path)
    end
  end

  def prepare_entry_names(params, pathname)
    entry_names =
      params[:all] ? Dir.entries(pathname).sort : Dir.glob('*', base: pathname, sort: true)

    params[:reverse] ? entry_names.reverse : entry_names
  end
end
