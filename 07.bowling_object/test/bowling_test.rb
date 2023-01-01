# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/shot'
require_relative '../lib/frame'
require_relative '../lib/game'

class ShotTest < Minitest::Test
  def test_strike
    strike = Shot.new('X')
    assert_equal 10, strike.pin
  end

  def test_not_strike
    pin = Shot.new('1')
    assert_equal 1, pin.pin
  end
end

class FrameTest < Minitest::Test
  def setup
    @frame_one = Frame.new(0, '0', '10')
    @frame_two = Frame.new(1, 'X', '0')
    @frame_three = Frame.new(2, 'X', '0')
    @frame_four = Frame.new(3, 'X', '0')
    @frame_five = Frame.new(4, '1', '5')
    @frame_six = Frame.new(5, '1', '9')
    @frame_seven = Frame.new(6, '1', '2')
    @frame_ten = Frame.new(9, 'X', 'X', 'X')
  end

  def test_score
    assert_equal 20, @frame_one.score(@frame_two, @frame_three)
    assert_equal 21, @frame_three.score(@frame_four, @frame_five)
    assert_equal 16, @frame_four.score(@frame_five, @frame_six)
    assert_equal 6, @frame_five.score(@frame_six, @frame_seven)
    assert_equal 30, @frame_ten.score(nil, nil)
  end
end

class GameTest < Minitest::Test
  def test_output_score
    game = Game.new(%w[X 0 X 0 X 0 X 0 X 0 X 0 X 0 X 0 X 0 X 0 X 0 X 0])
    assert_equal 300, game.output_score

    game = Game.new(%w[0 10 1 5 0 0 0 0 X 0 X 0 X 0 5 1 8 1 0 4])
    assert_equal 107, game.output_score
  end
end
