require 'discount/ratio_discount'

RSpec.describe RatioDiscount do
  let(:ratio_discount) { described_class.new(required_minimum_units: 3, discount_ratio: 0.6666) }

  describe '#initialize' do
    it 'sets required_minimum_units' do
      expect(ratio_discount.required_minimum_units).to eq(3)
    end

    it 'sets discount_ratio' do
      expect(ratio_discount.discount_ratio).to eq(0.6666)
    end
  end

  describe '#calculate_for' do
    let(:product_price) { 10.00 }

    context 'when product count is less than required minimum units' do
      it 'returns 0 discount' do
        result = ratio_discount.calculate_for(product_price, 2)
        expect(result).to eq(0)
      end
    end

    context 'when product count equals required minimum units' do
      it 'calculates discount for all units' do
        result = ratio_discount.calculate_for(product_price, 3)
        expected_discount = (product_price - (product_price * 0.6666)) * 3
        expect(result).to eq(expected_discount)
      end
    end

    context 'when product count is greater than required minimum units' do
      it 'calculates discount for all units' do
        result = ratio_discount.calculate_for(product_price, 5)
        expected_discount = (product_price - (product_price * 0.6666)) * 5
        expect(result).to eq(expected_discount)
      end
    end

    context 'with different product prices' do
      it 'calculates correct discount for higher price' do
        result = ratio_discount.calculate_for(15.00, 3)
        expected_discount = (15.00 - (15.00 * 0.6666)) * 3
        expect(result).to eq(expected_discount)
      end

      it 'calculates correct discount for lower price' do
        result = ratio_discount.calculate_for(5.00, 3)
        expected_discount = (5.00 - (5.00 * 0.6666)) * 3
        expect(result).to eq(expected_discount)
      end
    end
  end
end 