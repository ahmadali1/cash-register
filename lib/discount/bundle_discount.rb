require_relative '../discount'

class BundleDiscount < Discount
  attr_reader :free_units

  def initialize(required_minimum_units:, free_units:)
    super(required_minimum_units)
    @free_units = free_units
  end
end 