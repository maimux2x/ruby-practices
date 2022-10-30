# frozen_string_literal: true

require_relative 'game'

raw_record = ARGV[0]
game_record = raw_record.split(',')
game = Game.new

puts game.output_score(game_record)
