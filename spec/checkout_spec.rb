require 'checkout'
require 'product'
require 'discount/flat_discount'
require 'discount/ratio_discount'
require 'discount/bundle_discount'

# Following files contains real implementation of the classes instead of mocks
# So, we can test the real implementation. So, there are more of a integration tests here.

RSpec.describe Checkout do
  let(:checkout) { subject }

  describe 'methods and attributes' do
    it { should respond_to :cart }
    it { should respond_to :product_count }
    it { should respond_to :scan }
    it { should respond_to :total }
  end

  describe '#scan' do
    before do
      checkout.scan(product1).scan(product1)
      checkout.scan(product2)
    end

    let(:product1) { Product.new(code: 'GR1') }
    let(:product2) { Product.new(code: 'SR1') }

    it 'scans and updates the cart' do
      expect(checkout.cart.length).to eq(3)
    end

    it 'scans and updates the product_count' do
      expect(checkout.product_count).to(
        eq({ 'GR1' => 2, 'SR1' => 1 })
      )
    end
  end

  describe '#total' do
    # Discount Rules to attach with products
    let(:buy_one_get_one_discount) do
      BundleDiscount.new(
        required_minimum_units: 1,
        free_units: 1
      )
    end
    let(:flat_discount) do
      FlatDiscount.new(
        required_minimum_units: 3,
        discounted_amount: 4.50
      )
    end
    let(:ratio_discount) do
      RatioDiscount.new(
        required_minimum_units: 3,
        discount_ratio: 0.6666
      )
    end

    # Products Definition
    let(:green_tea) do
      Product.new(
        code: 'GR1',
        name: 'Green Tea',
        price: 3.11,
        discount_rule: buy_one_get_one_discount
      )
    end
    let(:strawberry) do
      Product.new(
        code: 'SR1',
        name: 'Strawberry',
        price: 5.00,
        discount_rule: flat_discount
      )
    end
    let(:coffee) do
      Product.new(
        code: 'CF1',
        name: 'Coffee',
        price: 11.23,
        discount_rule: ratio_discount
      )
    end

    context 'when no discount applies' do
      before do
        checkout.scan(green_tea).scan(strawberry).scan(coffee)
      end

      it 'returns the correct total without discount' do
        expect(checkout.total).to eq(19.34)
      end
    end

    context 'when buy-one-get-one rule applies' do
      before do
        checkout.scan(green_tea).scan(green_tea).scan(green_tea).scan(green_tea)
      end

      it 'returns the correct total with buy-one-get-one discount' do
        expect(checkout.total).to eq(6.22)
      end
    end

    context 'when Flat Discount rule applies' do
      before do
        checkout.scan(strawberry).scan(strawberry).scan(strawberry)
      end

      it 'returns the correct total with flat discount' do
        expect(checkout.total).to eq(13.5)
      end
    end

    context 'when Ratio Discount rule applies' do
      before do
        checkout.scan(coffee).scan(coffee).scan(coffee)
      end

      it 'returns the correct total with ratio discount' do
        expect(checkout.total).to eq(22.46)
      end
    end

    # These test cases are explicitely mentioned in coding challenge statement
    # So, writing in an independent context here
    context 'with exptected test cases' do
      context 'with GR1,GR1' do
        before do
          checkout.scan(green_tea).scan(green_tea)
        end

        it 'returns the correct total' do
          expect(checkout.total).to eq(3.11)
        end
      end

      context 'with SR1,SR1,GR1,SR1' do
        before do
          checkout.scan(strawberry).scan(strawberry).scan(green_tea).scan(strawberry)
        end

        it 'returns the correct total' do
          expect(checkout.total).to eq(16.61)
        end
      end

      context 'with GR1,CF1,SR1,CF1,CF1' do
        before do
          checkout.scan(green_tea).scan(coffee).scan(strawberry).scan(coffee).scan(coffee)
        end

        it 'returns the correct total' do
          expect(checkout.total).to eq(30.57)
        end
      end
    end
  end
end
