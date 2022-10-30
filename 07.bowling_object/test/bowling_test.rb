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
  def test_calc_score
    frame_one = Frame.new('0', '10')
    frame_two = Frame.new('X', '0')
    frame_three = Frame.new('X', '0')
    frame_four = Frame.new('X', '0')
    frame_five = Frame.new('1', '5')
    frame_six = Frame.new('1', '9')
    frame_seven = Frame.new('1', '2')
    frame_nine = Frame.new('X', 'X', 'X')

    assert_equal 20, frame_one.calc_score(1, frame_two, frame_three)
    assert_equal 21, frame_three.calc_score(3, frame_four, frame_five)
    assert_equal 16, frame_four.calc_score(4, frame_five, frame_six)
    assert_equal 6, frame_five.calc_score(5, frame_six, frame_seven)
    assert_equal 30, frame_nine.calc_score(9)
  end
end

class GameTest < Minitest::Test
  def test_checking_strike
    game = Game.new
    assert_equal %w[X 0 X 0 X 0 X 0 X 0 X 0 X 0 X 0 X 0 X 0 X 0 X 0], game.checking_strike(%w[X X X X X X X X X X X X])
  end

  def test_tenth_frame
    game = Game.new
    assert_equal [%w[X 0], %w[X 0], %w[X 0], %w[X 0], %w[X 0], %w[X 0], %w[X 0], %w[X 0], %w[X 0], %w[X X X]], game.tenth_frame(%w[X X X X X X X X X X X X])
  end

  def test_output_score
    game = Game.new
    assert_equal 300, game.output_score(%w[X X X X X X X X X X X X])

    assert_equal 107, game.output_score(%w[0 10 1 5 0 0 0 0 X X X 5 1 8 1 0 4])
  end
end
