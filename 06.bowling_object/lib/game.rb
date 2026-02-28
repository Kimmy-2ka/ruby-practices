# frozen_string_literal: true

class Game
  def initialize(pins)
    @pins = pins
  end

  def play
    # 分割する
    # 合計する
  end

  # privateにするとgame.sliceのテストに通らないので、一旦コメントアウト

  def slice
    pins = @pins.dup
    frames = []
    9.times do
      frames << if pins.first == 'X'
                  [pins.shift]
                else
                  pins.shift(2)
                end
    end
    frames << pins
    frames
  end
end
