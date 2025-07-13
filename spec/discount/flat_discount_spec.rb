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
end 