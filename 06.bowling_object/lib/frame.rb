# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_pin, second_pin = nil, third_pin = nil)
    @first_shot = Shot.new(first_pin)
    @second_shot = Shot.new(second_pin || 0)
    @third_shot = Shot.new(third_pin)
  end

  def to_a
    [@first_shot.score, @second_shot.score]
  end

  def total
    [@first_shot.score, @second_shot.score].sum
  end
end
