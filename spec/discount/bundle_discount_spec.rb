require 'discount/bundle_discount'

RSpec.describe BundleDiscount do
  let(:bundle_discount) { described_class.new(required_minimum_units: 2, free_units: 1) }

  describe '#initialize' do
    it 'sets required_minimum_units' do
      expect(bundle_discount.required_minimum_units).to eq(2)
    end

    it 'sets free_units' do
      expect(bundle_discount.free_units).to eq(1)
    end
  end

  describe '#calculate_for' do
    let(:product_price) { 10.00 }

    context 'when product count equals required minimum units' do
      it 'returns 0 discount' do
        result = bundle_discount.calculate_for(product_price, 2)
        expect(result).to eq(0)
      end
    end

    context 'when product count is greater than required minimum units' do
      it 'calculates buy-two-get-one discount for 3 items' do
        result = bundle_discount.calculate_for(product_price, 3)
        expect(result).to eq(product_price) # One item free
      end

      it 'calculates buy-two-get-one discount for 4 items' do
        result = bundle_discount.calculate_for(product_price, 4)
        expect(result).to eq(product_price) # One item free
      end

      it 'calculates buy-two-get-one discount for 5 items' do
        result = bundle_discount.calculate_for(product_price, 5)
        expect(result).to eq(product_price) # One item free
      end

      it 'calculates buy-two-get-one discount for 6 items' do
        result = bundle_discount.calculate_for(product_price, 6)
        expect(result).to eq(product_price * 2) # Two item free
      end
    end

    context 'with complex bundle scenarios' do
      let(:buy_three_get_two) { described_class.new(required_minimum_units: 3, free_units: 2) }

      it 'calculates buy-three-get-two discount for 5 items' do
        result = buy_three_get_two.calculate_for(product_price, 5)
        expect(result).to eq(product_price * 2) # Two items free
      end

      it 'calculates buy-three-get-two discount for 10 items' do
        result = buy_three_get_two.calculate_for(product_price, 10)
        expect(result).to eq(product_price * 4) # Four items free (2 complete deals)
      end
    end
  end
end