# frozen_string_literal: true

require_relative 'game'

raw_record = ARGV[0]
game_record = raw_record.split(',')

all_shot = []

game_record.each do |s|
  all_shot << s
  all_shot << '0' if s == 'X'
end

game = Game.new(all_shot)
puts game.output_score
