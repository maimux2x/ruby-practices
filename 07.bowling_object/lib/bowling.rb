# frozen_string_literal: true

require_relative 'game'

game_score = ARGV[0]
game = Game.new
puts game.output_point(game_score)
