require_relative '../discount'

class FlatDiscount < Discount
  attr_reader :discounted_amount

  def initialize(required_minimum_units:, discounted_amount:)
    super(required_minimum_units)
    @discounted_amount = discounted_amount
  end
end 