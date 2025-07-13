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
    product_count = @product_count[product.code]
    product.discount_rule.calculate_for(product.price, product_count)
  end
end
