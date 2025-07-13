require 'discount'

RSpec.describe Discount do
  let(:discount) { described_class.new(3) }

  describe '#initialize' do
    it 'sets required_minimum_units' do
      expect(discount.required_minimum_units).to eq(3)
    end
  end
end
