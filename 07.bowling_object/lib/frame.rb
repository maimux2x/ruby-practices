# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot

  def initialize(index, first_shot, second_shot, third_shot = '0')
    @index = index
    @first_shot = Shot.new(first_shot).pin
    @second_shot = Shot.new(second_shot).pin
    @third_shot = Shot.new(third_shot).pin
  end

  def score(next_frame, another_frame)
    if tenth_frame_or_sum_is_not_ten?
      @first_shot + @second_shot + @third_shot
    elsif spare?
      10 + next_frame.first_shot
    elsif continuous_strike?(next_frame)
      10 + 10 + another_frame.first_shot
    else
      10 + next_frame.first_shot + next_frame.second_shot
    end
  end

  private

  def tenth_frame_or_sum_is_not_ten?
    @index >= 9 || @first_shot + @second_shot != 10
  end

  def spare?
    @first_shot != 10
  end

  def continuous_strike?(next_frame)
    next_frame.first_shot == 10 && @index < 8
  end
end
