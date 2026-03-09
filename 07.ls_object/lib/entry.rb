# frozen_string_literal: true

class Entry
  def initialize(name)
    @name = name
  end

  def to_s
    @name.to_s
  end
end
