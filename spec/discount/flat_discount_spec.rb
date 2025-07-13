require 'discount/flat_discount'

RSpec.describe FlatDiscount do
  let(:flat_discount) { described_class.new(required_minimum_units: 3, discounted_amount: 4.50) }

  describe '#initialize' do
    it 'sets required_minimum_units' do
      expect(flat_discount.required_minimum_units).to eq(3)
    end

    it 'sets discounted_amount' do
      expect(flat_discount.discounted_amount).to eq(4.50)
    end
  end

  describe '#calculate_for' do
    let(:product_price) { 10.00 }

    context 'when product count is less than required minimum units' do
      it 'returns 0 discount' do
        result = flat_discount.calculate_for(product_price, 2)
        expect(result).to eq(0)
      end
    end

    context 'when product count equals required minimum units' do
      it 'calculates discount for all units' do
        result = flat_discount.calculate_for(product_price, 3)
        expected_discount = (product_price - 4.50) * 3
        expect(result).to eq(expected_discount)
      end
    end

    context 'when product count is greater than required minimum units' do
      it 'calculates discount for all units' do
        result = flat_discount.calculate_for(product_price, 5)
        expected_discount = (product_price - 4.50) * 5
        expect(result).to eq(expected_discount)
      end
    end
  end
end 