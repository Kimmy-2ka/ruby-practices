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

  def score
    total = 0
    @frames.each_with_index do |frame, i|
      next_frame = @frames[i + 1]
      total += frame.score

      if i < 9
        if frame.strike?
          total += if next_frame.strike?
                     if i == 8
                       next_frame.first_shot.score + next_frame.second_shot.score
                     else
                       next_frame.first_shot.score + @frames[i + 2].first_shot.score
                     end

                   else
                     next_frame.first_shot.score + next_frame.second_shot.score
                   end
        elsif frame.spare?
          total += next_frame.first_shot.score
        end
      end
    end
    total
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
