# frozen_string_literal: true

class Frame
  attr_accessor :frame

  def initialize
    @frame = frame
  end

  def split_frame
    shots = []

    raw_score = @frame.split(',')

    raw_score.each do |s|
      shots << Shot.new(s).pin_to_integer
      shots << 0 if s == 'X'
    end
    frames = shots.each_slice(2).to_a
    # 10投目にストライクが含まれていた場合の考慮
    tenth_frame = frames[9..].flat_map { |frame| frame[0] == 10 ? [10] : frame }
    # 10投分の配列を作成
    frames[0..8].push(tenth_frame)
  end

  def calc_point
    frames = split_frame
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
