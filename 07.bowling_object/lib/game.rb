# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'
require_relative 'point'

class Game
  def output_point(score)
    frame = Frame.new
    frame = frame.split_frame(score)

    point = Point.new
    point.calc_point(frame)
  end
end
