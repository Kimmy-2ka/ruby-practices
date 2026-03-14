# frozen_string_literal: true

require 'etc'

class Entry
  attr_reader :name

  def initialize(name, path)
    @name = name
    @stat = File::Stat.new(path)
  end

  def type = @stat.ftype
  def mode = @stat.mode.to_s(8)
  def nlink = @stat.nlink
  def user = Etc.getpwuid(@stat.uid).name
  def group = Etc.getgrgid(@stat.gid).name
  def size = @stat.size
  def mtime = @stat.mtime
  def blocks = @stat.blocks
end
