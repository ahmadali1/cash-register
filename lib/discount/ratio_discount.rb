require_relative '../discount'

class RatioDiscount < Discount
  attr_reader :discount_ratio

  def initialize(required_minimum_units:, discount_ratio:)
    super(required_minimum_units)
    @discount_ratio = discount_ratio
  end

  def calculate_for(product_price, product_count)
    return 0 if product_count < required_minimum_units

    per_unit_discount = product_price - (product_price * discount_ratio)
    per_unit_discount * product_count
  end
end 