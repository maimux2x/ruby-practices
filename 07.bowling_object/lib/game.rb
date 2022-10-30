# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def checking_strike(game_record)
    all_shot = []

    game_record.each do |s|
      all_shot << s
      all_shot << '0' if s == 'X'
    end
    all_shot
  end

  def tenth_frame(game_record)
    all_shot = checking_strike(game_record)
    raw_frame = all_shot.each_slice(2).to_a
    tenth_frame = raw_frame[9..].flat_map { |frame| frame[0] == 'X' ? ['X'] : frame }
    raw_frame[0..8].push(tenth_frame)
  end

  def output_score(game_record)
    game = tenth_frame(game_record)

    frames = []
    game.each do |record|
      frame = Frame.new(record[0], record[1], record[2])

      frames << frame
    end

    frames.each_with_index.sum do |frame, index|
      if index < 8
        frame.calc_score(index, frames[index + 1], frames[index + 2])
      elsif index == 8
        frame.calc_score(index, frames[index + 1])
      else
        frame.calc_score(index)
      end
    end
  end
end
