# frozen_string_literal: true

class Point
  def calc_point(frames)
    frames.each_with_index.sum do |frame, index|
      next frame.sum if index >= 9 || frame.sum != 10
      next 10 + frames[index + 1][0] if frame[0] != 10

      if frames[index + 1][0] == 10 && index < 8
        10 + 10 + frames[index + 2][0]
      else
        10 + frames[index + 1][0] + frames[index + 1][1]
      end
    end
  end
end
