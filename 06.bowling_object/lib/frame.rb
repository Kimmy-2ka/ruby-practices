# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_pin, second_pin = nil, third_pin = nil)
    @first_shot = Shot.new(first_pin)
    @second_shot = Shot.new(second_pin)
    @third_shot = Shot.new(third_pin)
  end

  def shot_scores
    [@first_shot.score, @second_shot.score, @third_shot.score].compact
  end

  def score
    shot_scores.sum
  end

  def spare?
    !strike? && [@first_shot.score, @second_shot.score].sum == 10
  end

  def strike?
    @first_shot.score == 10
  end
end
