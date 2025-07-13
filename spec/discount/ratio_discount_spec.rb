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
end 