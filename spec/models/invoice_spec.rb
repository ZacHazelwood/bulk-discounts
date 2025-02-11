require 'rails_helper'

RSpec.describe Invoice do
  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:transactions) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:status) }
  end

  let!(:merchant1) { Merchant.create!(name: "Schroeder-Jerde") }
  let!(:merchant2) { Merchant.create!(name: "Klein, Rempel and Jones") }

  let!(:item1) { merchant1.items.create!(name: "Qui Esse", description: "Nihil autem sit odio inventore deleniti", unit_price: 75107) }
  let!(:item2) { merchant1.items.create!(name: "Autem Minima", description: "Cumque consequuntur ad", unit_price: 67076) }
  let!(:item3) { merchant2.items.create!(name: "Ea Voluptatum", description: "Sunt officia", unit_price: 68723) }

  let!(:invoice1) { customer1.invoices.create!(status: "cancelled", created_at: '2012-03-20 14:53:59') }
  let!(:invoice2) { customer2.invoices.create!(status: "completed", created_at: '2012-03-21 14:53:59') }
  let!(:invoice3) { customer3.invoices.create!(status: "in progress", created_at: '2012-03-23 14:53:59') }
  let!(:invoice4) { customer4.invoices.create!(status: "completed", created_at: '2012-03-27 14:53:59') }
  let!(:invoice5) { customer5.invoices.create!(status: "completed", created_at: '2012-03-26 14:53:59') }
  let!(:invoice6) { customer5.invoices.create!(status: "in progress", created_at: '2012-03-25 14:53:59') }

  let!(:invoice_item1) { InvoiceItem.create!(item_id: item1.id, invoice_id: invoice1.id, quantity: 5, unit_price: 13635, status: "packaged") }
  let!(:invoice_item2) { InvoiceItem.create!(item_id: item1.id, invoice_id: invoice2.id, quantity: 9, unit_price: 23324, status: "pending") }
  let!(:invoice_item3) { InvoiceItem.create!(item_id: item2.id, invoice_id: invoice3.id, quantity: 8, unit_price: 34873, status: "packaged") }
  let!(:invoice_item4) { InvoiceItem.create!(item_id: item2.id, invoice_id: invoice4.id, quantity: 3, unit_price: 2196, status: "packaged") }
  let!(:invoice_item5) { InvoiceItem.create!(item_id: item2.id, invoice_id: invoice5.id, quantity: 7, unit_price: 79140, status: "shipped") }
  let!(:invoice_item6) { InvoiceItem.create!(item_id: item3.id, invoice_id: invoice6.id, quantity: 3, unit_price: 52100, status: "packaged") }

  let!(:customer1) { Customer.create!(first_name: "Leanne", last_name: "Braun") }
  let!(:customer2) { Customer.create!(first_name: "Sylvester", last_name: "Nader") }
  let!(:customer3) { Customer.create!(first_name: "Heber", last_name: "Kuhn") }
  let!(:customer4) { Customer.create!(first_name: "Mariah", last_name: "Toy") }
  let!(:customer5) { Customer.create!(first_name: "Carl", last_name: "Junior") }
  let!(:customer6) { Customer.create!(first_name: "Tony", last_name: "Bologna") }

  let!(:transaction1) { Transaction.create!(invoice_id: invoice1.id, credit_card_number: 4654405418249632, credit_card_expiration_date: "2/22", result: "success") }
  let!(:transaction2) { Transaction.create!(invoice_id: invoice2.id, credit_card_number: 4580251236515201, credit_card_expiration_date: "1/22", result: "failed") }
  let!(:transaction3) { Transaction.create!(invoice_id: invoice3.id, credit_card_number: 4354495077693036, credit_card_expiration_date: "10/22", result: "success") }
  let!(:transaction4) { Transaction.create!(invoice_id: invoice4.id, credit_card_number: 4515551623735607, credit_card_expiration_date: "4/25", result: "success") }
  let!(:transaction5) { Transaction.create!(invoice_id: invoice5.id, credit_card_number: 4844518708741275, credit_card_expiration_date: "4/23", result: "success") }
  let!(:transaction6) { Transaction.create!(invoice_id: invoice6.id, credit_card_number: 4203696133194408, credit_card_expiration_date: "5/22", result: "success") }

  describe "class methods" do

    it ".invoices_with_merchant_items(merchant)" do
      expect(Invoice.invoices_with_merchant_items(merchant1)).to include(invoice1)
      expect(Invoice.invoices_with_merchant_items(merchant1)).to include(invoice2)
      expect(Invoice.invoices_with_merchant_items(merchant1)).to include(invoice3)
      expect(Invoice.invoices_with_merchant_items(merchant1)).to include(invoice4)
      expect(Invoice.invoices_with_merchant_items(merchant1)).to include(invoice5)
      expect(Invoice.invoices_with_merchant_items(merchant1)).to_not include(invoice6)
    end

    describe '.incomplete_invoices' do
      it 'returns the invoices with items that have not yet been shipped, ordered from oldest to newest' do
        expect(Invoice.incomplete_invoices).to eq([invoice1, invoice2, invoice3, invoice6, invoice4])
      end
    end
  end

  describe "instance methods" do
    it "#invoice_customer" do
      expect(invoice1.invoice_customer).to eq("Leanne Braun")
    end

    it "#total_revenue" do
      expect(invoice1.total_revenue).to eq(68175)
    end

    it "#invoice_discount" do
      discount = merchant1.bulk_discounts.create!(name: '5 at 50%', percent_discount: 0.5, threshold: 5)

      expect(invoice1.invoice_discount).to eq(34087.5)
    end

    it "#discounted_revenue" do
      discount = merchant1.bulk_discounts.create!(name: '3 at 30%', percent_discount: 0.3, threshold: 3)

      expect(invoice1.discounted_revenue).to eq(47722.5)
      expect(invoice3.discounted_revenue).to eq(195288.8)
    end

    it "#discounted_revenue applies the highest available discount" do
      discount_1 = merchant1.bulk_discounts.create!(name: '3 at 30%', percent_discount: 0.3, threshold: 3)
      discount_2 = merchant1.bulk_discounts.create!(name: '3 at 40%', percent_discount: 0.4, threshold: 3)
      discount_3 = merchant1.bulk_discounts.create!(name: '10 at 90%', percent_discount: 0.9, threshold: 10)
      # discount_3's :threshold should not be met

      expect(invoice1.discounted_revenue).to eq(40905.0)
      expect(invoice3.discounted_revenue).to eq(167390.4)
    end
  end
end
