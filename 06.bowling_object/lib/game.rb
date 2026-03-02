# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(pins)
    @pins = pins
    @frames = to_frames
  end

  def score
    total = 0
    @frames.each_with_index do |frame, index|
      total += frame.score

      next if last_frame?(index)

      total += strike_bonus(index) if frame.strike?
      total += @frames[index + 1].first_shot.score if frame.spare?
    end

    total
  end

  def last_frame?(index)
    index == 9
  end

  def strike_bonus(index)
    @frames[(index + 1)..(index + 2)].flat_map(&:shot_scores).take(2).sum
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
