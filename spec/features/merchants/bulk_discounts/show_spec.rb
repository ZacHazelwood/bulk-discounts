require 'rails_helper'

RSpec.describe 'Bulk Discounts Show Page' do
  it "displays one discount with it's info", :vcr do
    merchant1 = Merchant.create!(name: "Schroeder-Jerde")
    bulk1 = BulkDiscount.create!(name: '2 at 20%', percent_discount: 0.2, threshold: 2)

    visit merchant_bulk_discount_path(merchant1, bulk1)

    expect(page).to have_content("Discount Details")
    expect(page).to have_content("2 at 20%")
    expect(page).to have_content("Percent Discounted: 20%")
    expect(page).to have_content("Number of Items Required: 2")

    expect(page).to_not have_content("1 at 100%")
    expect(page).to_not have_content("Percent Discounted: 100%")
    expect(page).to_not have_content("Number of Items Required: 1")
  end
end
