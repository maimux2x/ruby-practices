# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def output_point(score)
    game = Frame.new
    game.frame = score

    game.calc_point
  end
end
