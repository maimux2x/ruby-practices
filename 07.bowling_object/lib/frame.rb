# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot

  def initialize(first_shot, second_shot, third_shot = '0')
    @first_shot = Shot.new(first_shot).pin_to_integer
    @second_shot = Shot.new(second_shot).pin_to_integer
    @third_shot = Shot.new(third_shot).pin_to_integer
  end

  def calc_score(index, next_frame = [], another_frame = [])
    if index >= 9 || @first_shot + @second_shot != 10
      @first_shot + @second_shot + @third_shot
    elsif @first_shot != 10
      10 + next_frame.first_shot
    elsif next_frame.first_shot == 10 && index < 8
      10 + 10 + another_frame.first_shot
    else
      10 + next_frame.first_shot + next_frame.second_shot
    end
  end
end
