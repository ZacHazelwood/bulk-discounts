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
end
