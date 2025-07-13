class Checkout
  # Cart contains list of products and each product count in cart is stored in product_count
  attr_reader :cart, :product_count

  def initialize
    @cart = []
    @product_count = {}
  end

  def scan(product)
    @cart << product
    @product_count[product.code] = @product_count[product.code].to_i + 1

    self
  end

  def total
    total_price = cart.sum do |product|
                    product.price
                  end.round(2)

    (total_price - discount).round(2)
  end

  private

  def discount
    @product_count.sum do |product_code, count|
      product = find_product(product_code)
      next 0 if product.discount_rule.nil?

      calculate_discount_for(product).round(2)
    end
  end

  def find_product(product_code)
    cart.find{ |product| product.code == product_code }
  end

  def calculate_discount_for(product)
    case product.discount_rule
    when FlatDiscount   then flat_discount(product)
    when RatioDiscount  then ratio_discount(product)
    when BundleDiscount then buy_few_get_few_discount(product)
    else 0
    end
  end

  # TODO: Move *_discount(product) methods to Discount class. They dont belong here

  def flat_discount(product)
    if @product_count[product.code] >= product.discount_rule.required_minimum_units
      per_unit_discount = product.price - product.discount_rule.discounted_amount

      return per_unit_discount * @product_count[product.code]
    end

    0
  end

  def ratio_discount(product)
    if @product_count[product.code] >= product.discount_rule.required_minimum_units
      per_unit_discount = product.price - (product.price * product.discount_rule.discount_ratio)

      return per_unit_discount * @product_count[product.code]
    end

    0
  end

  def buy_few_get_few_discount(product)
    if @product_count[product.code] > product.discount_rule.required_minimum_units
      counter = product.discount_rule.free_units
      discounted_amount = 0

      # counters to iterate
      free_units = product.discount_rule.free_units
      chargable_units = 0

      (1..@product_count[product.code]).each do
        chargable_units = chargable_units + 1
        free_units = product.discount_rule.free_units if free_units == 0

        if chargable_units > product.discount_rule.required_minimum_units && free_units > 0
          discounted_amount = discounted_amount + product.price
          free_units = free_units - 1
          chargable_units = 0
        end
      end

      return discounted_amount
    end

    0
  end
end
