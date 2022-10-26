# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/shot'
require_relative '../lib/frame'
require_relative '../lib/game'

class ShotTest < Minitest::Test
  def test_strike
    strike = Shot.new('X')
    assert_equal 10, strike.pin_to_integer
  end

  def test_not_strike
    pin = Shot.new('1')
    assert_equal 1, pin.pin_to_integer
  end
end

class FrameTest < Minitest::Test
  def test_score_to_splite_frame
    game = Frame.new
    game.frame = '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'
    assert_equal [[0, 10], [1, 5], [0, 0], [0, 0], [10, 0], [10, 0], [10, 0], [5, 1], [8, 1], [0, 4]], game.split_frame
  end

  def test_calculate_point
    game = Frame.new
    game.frame = '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'
    assert_equal 107, game.calc_point
  end
end

class GameTest < Minitest::Test
  def test_output_game_point
    game = Game.new
    assert_equal 300, game.output_point('X,X,X,X,X,X,X,X,X,X,X,X')
  end
end
