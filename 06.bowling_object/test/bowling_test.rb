# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative  '../lib/game'

class BowlingTest < Minitest::Test
  def test_slice
    game = Game.new
    pins = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    assert_equal [[0,0], [0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]], game.slice(pins)
  end
end
