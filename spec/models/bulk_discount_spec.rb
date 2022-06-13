require 'rails_helper'

RSpec.describe BulkDiscount do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:percent_discount) }
    it { should validate_presence_of(:threshold) }
    it { should validate_numericality_of(:threshold) }
  end

  describe 'relationships' do
    it { should belong_to(:merchant) }
  end

  describe 'instance methods' do
    it '#percent_to_integer' do
      merchant1 = Merchant.create!(name: "Schroeder-Jerde")
      bulk1 = merchant1.bulk_discounts.create!(name: '2 at 20%', percent_discount: 0.2, threshold: 2)

      expect(bulk1.percent_to_integer).to eq(20)
    end
  end
end
