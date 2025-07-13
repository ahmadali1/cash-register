class Discount
  attr_reader :required_minimum_units

  def initialize(required_minimum_units)
    @required_minimum_units = required_minimum_units
  end

  def calculate_for(product_price, product_count)
    raise NotImplementedError, "#{self.class} must implement #calculate_for"
  end
end
