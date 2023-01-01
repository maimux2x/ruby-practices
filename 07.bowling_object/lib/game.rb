# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def initialize(all_shot)
    raw_frame = all_shot.each_slice(2).to_a
    tenth_frame = raw_frame[9..].flat_map { |frame| frame[0] == 'X' ? ['X'] : frame }
    all_frame = raw_frame[0..8].push(tenth_frame)

    @frames = all_frame.map.with_index { |record, index| Frame.new(index, record[0], record[1], record[2]) }
  end

  def output_score
    @frames.each_with_index.sum do |frame, index|
      frame.score(@frames[index + 1], @frames[index + 2])
    end
  end
end
