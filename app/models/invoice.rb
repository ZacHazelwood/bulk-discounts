class Invoice < ApplicationRecord
  belongs_to :customer

  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  validates :status, presence: true

  enum status: {'cancelled' => 0, 'in progress' => 1, 'completed' => 2}

  def invoice_customer
    "#{customer.first_name} #{customer.last_name}"
  end

  def total_revenue
    invoice_items.sum('invoice_items.unit_price * invoice_items.quantity')
  end

  def self.incomplete_invoices
    joins(:invoice_items)
    .where.not(invoice_items: {status: 1})
    .distinct
    .order(:created_at)
  end

  def self.invoices_with_merchant_items(merchant)
    merchant.invoices.distinct(:id)
  end

  def invoice_discount
    items.joins(merchant: :bulk_discounts)
    .where('invoice_items.quantity >= bulk_discounts.threshold')
    .select('invoice_items.id, max(invoice_items.quantity * invoice_items.unit_price * bulk_discounts.percent_discount) as discount_applied')
    .group('invoice_items.id')
    .sum(&:discount_applied)
  end

  def discounted_revenue
    total_revenue - invoice_discount
  end
end
