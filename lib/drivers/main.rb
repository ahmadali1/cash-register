#!/usr/bin/env ruby

require_relative '../checkout'
require_relative '../product'
require_relative '../discount'
require_relative '../discount/flat_discount'
require_relative '../discount/ratio_discount'
require_relative '../discount/bundle_discount'

class CashRegisterCLI
  def initialize
    @products = {}
    @checkout = nil
  end

  def run
    display_welcome
    setup_products
    scanning_phase
  end

  private

  def display_welcome
    puts "\n" + "="*50
    puts "🎯 CASH REGISTER SYSTEM"
    puts "="*50
    puts "Welcome! Let's set up your products and start scanning."
    puts ""
  end

  def setup_products
    puts "📦 PRODUCT SETUP PHASE"
    puts "-" * 30
    
    loop do
      puts "\nEnter product details (or 'done' to finish):"
      
      code = get_input("Product Code (e.g., GR1): ").upcase
      break if code.downcase == 'done'
      
      if @products[code]
        puts "❌ Product code '#{code}' already exists. Please use a different code."
        next
      end
      
      name = get_input("Product Name (e.g., Green Tea): ")
      price = get_float_input("Price (e.g., 3.11): ")
      
      discount_rule = setup_discount_rule
      
      @products[code] = Product.new(
        code: code,
        name: name,
        price: price,
        discount_rule: discount_rule
      )
      
      puts "✅ Product '#{name}' added successfully!"
    end
    
    if @products.empty?
      puts "❌ No products added. Please add at least one product."
      setup_products
    else
      display_products_summary
    end
  end

  def setup_discount_rule
    puts "\nSelect discount type:"
    puts "1. No discount"
    puts "2. Flat discount (fixed amount off per unit)"
    puts "3. Ratio discount (percentage off per unit)"
    puts "4. Bundle discount (buy X get Y free)"
    
    choice = get_input("Choice (1-4): ").to_i
    
    case choice
    when 1
      nil
    when 2
      setup_flat_discount
    when 3
      setup_ratio_discount
    when 4
      setup_bundle_discount
    else
      puts "❌ Invalid choice. No discount will be applied."
      nil
    end
  end

  def setup_flat_discount
    required_units = get_integer_input("Minimum units required for discount: ")
    discount_amount = get_float_input("Discount amount per unit: ")
    
    FlatDiscount.new(
      required_minimum_units: required_units,
      discounted_amount: discount_amount
    )
  end

  def setup_ratio_discount
    required_units = get_integer_input("Minimum units required for discount: ")
    ratio = get_float_input("Discount ratio (0.0-1.0, e.g., 0.3333 for 33.33% off): ")
    
    RatioDiscount.new(
      required_minimum_units: required_units,
      discount_ratio: ratio
    )
  end

  def setup_bundle_discount
    required_units = get_integer_input("Buy how many units: ")
    free_units = get_integer_input("Get how many free: ")
    
    BundleDiscount.new(
      required_minimum_units: required_units,
      free_units: free_units
    )
  end

  def display_products_summary
    puts "\n📋 PRODUCTS SUMMARY"
    puts "-" * 30
    @products.each do |code, product|
      discount_info = product.discount_rule ? describe_discount(product.discount_rule) : "No discount"
      puts "#{code}: #{product.name} (€#{product.price}) - #{discount_info}"
    end
    puts ""
  end

  def describe_discount(discount)
    case discount
    when FlatDiscount
      "€#{discount.discounted_amount} off per unit (min #{discount.required_minimum_units})"
    when RatioDiscount
      "#{(discount.discount_ratio * 100).round(2)}% off per unit (min #{discount.required_minimum_units})"
    when BundleDiscount
      "Buy #{discount.required_minimum_units} get #{discount.free_units} free"
    else
      "Unknown discount"
    end
  end

  def scanning_phase
    @checkout = Checkout.new
    
    puts "🛒 SCANNING PHASE"
    puts "-" * 30
    display_help
    
    loop do
      print "\n> "
      command = gets.chomp.strip.downcase
      
      case command
      when 'help'
        display_help
      when 'products'
        display_products_summary
      when 'cart'
        display_cart
      when 'total'
        display_total
      when 'clear'
        clear_cart
      when 'quit', 'exit'
        puts "👋 Thanks for using Cash Register!"
        break
      when /^scan\s+(.+)$/
        scan_product($1.upcase)
      when /^batch\s+(.+)$/
        batch_scan($1)
      else
        puts "❌ Unknown command. Type 'help' for available commands."
      end
    end
  end

  def display_help
    puts "\n📖 AVAILABLE COMMANDS:"
    puts "scan <code>     : Add product to cart"
    puts "batch <codes>   : Scan multiple products (space-separated)"
    puts "total           : Calculate and display total"
    puts "cart            : Show current cart contents"
    puts "products        : Show all available products"
    puts "clear           : Clear cart"
    puts "help            : Show this help"
    puts "quit/exit       : Exit the application"
  end

  def scan_product(code)
    product = @products[code]
    
    if product
      @checkout.scan(product)
      puts "✅ Added: #{product.name} (€#{product.price})"
    else
      puts "❌ Product '#{code}' not found. Available products: #{@products.keys.join(', ')}"
    end
  end

  def batch_scan(codes_string)
    codes = codes_string.split(/\s+/)
    scanned_count = 0
    
    codes.each do |code|
      product = @products[code.upcase]
      if product
        @checkout.scan(product)
        scanned_count += 1
      else
        puts "⚠️  Skipped: '#{code}' (not found)"
      end
    end
    
    puts "✅ Batch scan complete: #{scanned_count} products added"
  end

  def display_cart
    if @checkout.cart.empty?
      puts "🛒 Cart is empty"
    else
      puts "\n🛒 CART CONTENTS:"
      puts "-" * 20
      
      @checkout.product_count.each do |code, count|
        product = @products[code]
        puts "#{product.name}: #{count} unit(s) @ €#{product.price} each"
      end
    end
  end

  def display_total
    if @checkout.cart.empty?
      puts "🛒 Cart is empty - Total: €0.00"
    else
      total = @checkout.total
      original_total = @checkout.cart.sum(&:price)
      discount = original_total - total
      
      puts "\n💰 TOTAL CALCULATION:"
      puts "-" * 25
      puts "Original total: €#{original_total.round(2)}"
      puts "Discount applied: €#{discount.round(2)}"
      puts "Final total: €#{total.round(2)}"
    end
  end

  def clear_cart
    @checkout = Checkout.new
    puts "🗑️  Cart cleared"
  end

  def get_input(prompt)
    print prompt
    gets.chomp.strip
  end

  def get_float_input(prompt)
    loop do
      input = get_input(prompt)
      begin
        return Float(input)
      rescue ArgumentError
        puts "❌ Please enter a valid number"
      end
    end
  end

  def get_integer_input(prompt)
    loop do
      input = get_input(prompt)
      begin
        value = Integer(input)
        return value if value > 0
        puts "❌ Please enter a positive number"
      rescue ArgumentError
        puts "❌ Please enter a valid integer"
      end
    end
  end
end

# Run the CLI if this file is executed directly
if __FILE__ == $0
  CashRegisterCLI.new.run
end 