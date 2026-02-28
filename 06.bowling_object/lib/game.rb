# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(pins)
    @pins = pins
    @frames = to_frames
  end

  def play
    # 分割する
    # 合計する
  end

  def to_frames
    pins = @pins.dup
    frames = []
    9.times do
      frames << if pins.first == 'X'
                  Frame.new(pins.shift)
                else
                  first_pin, second_pin = pins.shift(2)
                  Frame.new(first_pin, second_pin)
                end
    end
    first_pin, second_pin, third_pin = pins
    frames << Frame.new(first_pin, second_pin, third_pin)
    frames
  end
end
