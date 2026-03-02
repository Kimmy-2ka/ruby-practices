# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/pride'
require_relative  '../lib/game'

class BowlingTest < Minitest::Test

  def test_score_1
    pins = 6,3,9,0,0,3,8,2,7,3,'X',9,1,8,0,'X',6,4,5
    game = Game.new(pins)
    assert_equal 139, game.score
  end

  def test_score_2
    pins = 6,3,9,0,0,3,8,2,7,3,'X',9,1,8,0,'X','X','X','X'
    game = Game.new(pins)
    assert_equal 164, game.score
  end

  def test_score_3
    pins = 0,10,1,5,0,0,0,0,'X','X','X',5,1,8,1,0,4
    game = Game.new(pins)
    assert_equal 107, game.score
  end

  def test_score_4
    pins = 6,3,9,0,0,3,8,2,7,3,'X',9,1,8,0,'X','X',0,0
    game = Game.new(pins)
    assert_equal 134, game.score
  end

  def test_score_5
    pins = 6,3,9,0,0,3,8,2,7,3,'X',9,1,8,0,'X','X',1,8
    game = Game.new(pins)
    assert_equal 144, game.score
  end

  def test_score_6
    pins = 'X','X','X','X','X','X','X','X','X','X','X','X'
    game = Game.new(pins)
    assert_equal 300, game.score
  end

  def test_score_7
    pins = 'X','X','X','X','X','X','X','X','X','X','X',2
    game = Game.new(pins)
    assert_equal 292, game.score
  end

  def test_score_8
    pins = 'X',0,0,'X',0,0,'X',0,0,'X',0,0,'X',0,0
    game = Game.new(pins)
    assert_equal 50, game.score
  end
end

