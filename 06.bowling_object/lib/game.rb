# frozen_string_literal: true

class Game
  def play(pins)
    # 分割する
    # 合計する
  end

  def slice(pins)
    pins = pins.dup
    frames = []
    10.times do
      frames << pins.shift(2)
    end
    frames
  end
end
