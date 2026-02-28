# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative  '../lib/game'

class BowlingTest < Minitest::Test

  def test_strike_frame
    pins = ['X',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'X','X','X']
    game = Game.new(pins)
    assert_equal [10,0], game.to_frames[0].to_a
  end

  def test_last_frame
    pins = ['X',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'X','X','X']
    game = Game.new(pins)
    last_frame = game.to_frames[9]
    assert_equal [10,10,10], [last_frame.first_shot.score, last_frame.second_shot.score, last_frame.third_shot.score]
  end
end
