require 'discount/bundle_discount'

RSpec.describe BundleDiscount do
  let(:bundle_discount) { described_class.new(required_minimum_units: 1, free_units: 1) }

  describe '#initialize' do
    it 'sets required_minimum_units' do
      expect(bundle_discount.required_minimum_units).to eq(1)
    end

    it 'sets free_units' do
      expect(bundle_discount.free_units).to eq(1)
    end
  end
end 