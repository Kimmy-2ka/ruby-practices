# frozen_string_literal: true

require_relative 'entry'
require_relative 'formatter'

class Command
  def initialize(params, pathname)
    @params = params
    @pathname = pathname
    @entries = build_entries
  end

  def output
    formatter = Formatter.new(@entries)
    @params[:long] ? formatter.long_format : formatter.short_format
  end

  private

  def build_entries
    names = prepare_entry_names
    names.map do |name|
      path = @pathname.join(name)
      Entry.new(name, path)
    end
  end

  def prepare_entry_names
    names =
      @params[:all] ? Dir.entries(@pathname).sort : Dir.glob('*', base: @pathname, sort: true)

    @params[:reverse] ? names.reverse : names
  end
end
