require_relative '../discount'

class BundleDiscount < Discount
  attr_reader :free_units

  # TODO: add presence and positive integer validation for free_units

  def initialize(required_minimum_units:, free_units:)
    super(required_minimum_units)
    @free_units = free_units
  end

  def calculate_for(product_price, product_count)
    return 0 if product_count <= required_minimum_units

    # Calculate how many complete deals we can make
    items_per_deal = required_minimum_units + free_units
    complete_deals = product_count / items_per_deal
    free_items = complete_deals * free_units

    # Calculate discount amount
    free_items * product_price
  end
end 