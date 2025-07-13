require_relative '../discount'

class RatioDiscount < Discount
  attr_reader :discount_ratio

  def initialize(required_minimum_units:, discount_ratio:)
    super(required_minimum_units)
    @discount_ratio = discount_ratio
  end
end 