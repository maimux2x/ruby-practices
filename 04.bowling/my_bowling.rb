# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = shots.each_slice(2).to_a
# 10投目にストライクが含まれていた場合の考慮
tenth_frame = frames[9..].flat_map { |frame| frame[0] == 10 ? [10] : frame }
# 10投分の配列を作成
frames = frames[0..8].push(tenth_frame)

# ポイントの計算
point = 0
frames.each_with_index do |frame, index|
  point +=
    if frame[0] == 10 && index < 9 # strike
      10 + frames[index + 1][0] + frames[index + 1][1]
    elsif frame.sum == 10 && index < 9 # spare
      10 + frames[index + 1][0]
    else
      frame.sum
    end
end
puts point
