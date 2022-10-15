# frozen_string_literal: true

class Frame
  def split_frame(score)
    shots = []

    raw_score = score.split(',')

    raw_score.each do |s|
      shots << Shot.new(s).shot_to_integer
      shots << 0 if s == 'X'
    end
    frames = shots.each_slice(2).to_a
    # 10投目にストライクが含まれていた場合の考慮
    tenth_frame = frames[9..].flat_map { |frame| frame[0] == 10 ? [10] : frame }
    # 10投分の配列を作成
    frames[0..8].push(tenth_frame)
  end
end
