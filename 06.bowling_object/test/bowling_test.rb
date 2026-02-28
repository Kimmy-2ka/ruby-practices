# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative  '../lib/game'

class BowlingTest < Minitest::Test
  def test_slice
    pins = ['X',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'X','X','X']
    game = Game.new(pins)
    assert_equal [['X'], [0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],['X','X','X']], game.slice
  end
end
