class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  has_many :bulk_discounts, through: :item

  validates :quantity, presence: true
  validates :unit_price, presence: true
  validates :status, presence: true

  enum status: {'pending' => 0, 'shipped' => 1, 'packaged' => 2}

  def applied_discount
    bulk_discounts.where('threshold <= ?', quantity).order(percent_discount: :desc).first
  end
end
