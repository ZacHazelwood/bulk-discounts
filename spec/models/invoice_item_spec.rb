require 'rails_helper'

RSpec.describe InvoiceItem do
  describe 'relationships' do
    it { should belong_to(:invoice) }
    it { should belong_to(:item) }
    it { should have_many(:bulk_discounts).through(:item) }
  end

  describe 'validations' do
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:status) }
  end

  describe "instance methods" do
    it "#applied_discount, determines which discount is applied" do
      # checks for correct discount when discounts have different thresholds
      merchant1 = Merchant.create!(name: "Schroeder-Jerde")
      item1 = merchant1.items.create!(name: "Qui Esse", description: "Nihil autem sit odio inventore deleniti", unit_price: 75107)
      item2 = merchant1.items.create!(name: "Autem Minima", description: "Cumque consequuntur ad", unit_price: 67076)

      customer1 = Customer.create!(first_name: "Leanne", last_name: "Braun")
      invoice1 = customer1.invoices.create!(status: "in progress", created_at: '2012-03-20 14:53:59')
      transaction1 = Transaction.create!(invoice_id: invoice1.id, credit_card_number: 4654405418249632, credit_card_expiration_date: "2/22", result: "success")

      invoice_item1 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice1.id, quantity: 5, unit_price: 13635, status: "pending")
      invoice_item2 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice1.id, quantity: 9, unit_price: 23324, status: "pending")
      invoice_item3 = InvoiceItem.create!(item_id: item2.id, invoice_id: invoice1.id, quantity: 8, unit_price: 34873, status: "pending")

      discount_1 = merchant1.bulk_discounts.create!(name: '3 at 30%', percent_discount: 0.3, threshold: 3)
      discount_2 = merchant1.bulk_discounts.create!(name: '5 at 40%', percent_discount: 0.4, threshold: 5)
      discount_3 = merchant1.bulk_discounts.create!(name: '10 at 90%', percent_discount: 0.9, threshold: 10)

      expect(invoice_item1.applied_discount).to eq(discount_2)
    end

    it "#applied_discount, determines which discount is applied" do
      # checks for correct discount when discounts share threshold
      merchant1 = Merchant.create!(name: "Schroeder-Jerde")
      item1 = merchant1.items.create!(name: "Qui Esse", description: "Nihil autem sit odio inventore deleniti", unit_price: 75107)
      item2 = merchant1.items.create!(name: "Autem Minima", description: "Cumque consequuntur ad", unit_price: 67076)

      customer1 = Customer.create!(first_name: "Leanne", last_name: "Braun")
      invoice1 = customer1.invoices.create!(status: "in progress", created_at: '2012-03-20 14:53:59')
      transaction1 = Transaction.create!(invoice_id: invoice1.id, credit_card_number: 4654405418249632, credit_card_expiration_date: "2/22", result: "success")

      invoice_item1 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice1.id, quantity: 5, unit_price: 13635, status: "pending")
      invoice_item2 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice1.id, quantity: 9, unit_price: 23324, status: "pending")
      invoice_item3 = InvoiceItem.create!(item_id: item2.id, invoice_id: invoice1.id, quantity: 8, unit_price: 34873, status: "pending")

      discount_1 = merchant1.bulk_discounts.create!(name: '3 at 30%', percent_discount: 0.3, threshold: 3)
      discount_2 = merchant1.bulk_discounts.create!(name: '3 at 40%', percent_discount: 0.4, threshold: 3)
      discount_3 = merchant1.bulk_discounts.create!(name: '10 at 90%', percent_discount: 0.9, threshold: 10)

      expect(invoice_item1.applied_discount).to eq(discount_2)
    end


    it "#applied_discount, determines which discount is applied" do
      # checks for correct discount when all discounts have the same threshold, but different percents
      merchant1 = Merchant.create!(name: "Schroeder-Jerde")
      item1 = merchant1.items.create!(name: "Qui Esse", description: "Nihil autem sit odio inventore deleniti", unit_price: 75107)
      item2 = merchant1.items.create!(name: "Autem Minima", description: "Cumque consequuntur ad", unit_price: 67076)

      customer1 = Customer.create!(first_name: "Leanne", last_name: "Braun")
      invoice1 = customer1.invoices.create!(status: "in progress", created_at: '2012-03-20 14:53:59')
      transaction1 = Transaction.create!(invoice_id: invoice1.id, credit_card_number: 4654405418249632, credit_card_expiration_date: "2/22", result: "success")

      invoice_item1 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice1.id, quantity: 5, unit_price: 13635, status: "pending")
      invoice_item2 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice1.id, quantity: 9, unit_price: 23324, status: "pending")
      invoice_item3 = InvoiceItem.create!(item_id: item2.id, invoice_id: invoice1.id, quantity: 8, unit_price: 34873, status: "pending")

      discount_1 = merchant1.bulk_discounts.create!(name: '3 at 30%', percent_discount: 0.3, threshold: 3)
      discount_2 = merchant1.bulk_discounts.create!(name: '3 at 40%', percent_discount: 0.4, threshold: 3)
      discount_3 = merchant1.bulk_discounts.create!(name: '3 at 90%', percent_discount: 0.9, threshold: 3)

      expect(invoice_item1.applied_discount).to eq(discount_3)
    end
  end
end
