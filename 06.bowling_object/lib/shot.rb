# frozen_string_literal: true

class Shot
  def initialize(pin)
    @pin = pin
  end

  def score
    return 10 if @pin == 'X'

    @pin.to_i
  end
end
