# frozen_string_literal: true

require_relative 'shot'

class Frame
  def initialize(first_pin, second_pin = nil, third_pin = nil)
    @shots =
      [first_pin, second_pin, third_pin].compact.map { |pin| Shot.new(pin) }
  end

  def shot_scores
    @shots.map(&:score)
  end

  def score
    shot_scores.sum
  end

  def spare?
    !strike? && score == 10
  end

  def strike?
    @shots[0].score == 10
  end
end
