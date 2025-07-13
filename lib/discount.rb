class Discount
  attr_reader :required_minimum_units

  def initialize(required_minimum_units)
    @required_minimum_units = required_minimum_units
  end
end
