require_relative '../discount'

class FlatDiscount < Discount
  attr_reader :discounted_amount

  # TODO: add presence and positive float validation for discounted_amount

  def initialize(required_minimum_units:, discounted_amount:)
    super(required_minimum_units)
    @discounted_amount = discounted_amount
  end

  def calculate_for(product_price, product_count)
    return 0 if product_count < required_minimum_units

    per_unit_discount = product_price - discounted_amount
    per_unit_discount * product_count
  end
end 