require 'rails_helper'

RSpec.describe 'Bulk Discount Edit Page' do
  it "can edit a discount and confirm with a message" do
    merchant1 = Merchant.create!(name: "Schroeder-Jerde")
    bulk1 = merchant1.bulk_discounts.create!(name: '2 at 20%', percent_discount: 0.2, threshold: 2)

    visit edit_merchant_bulk_discount_path(merchant1, bulk1)

    expect(page).to have_field('name')
    expect(page).to have_field('percent_discount')
    expect(page).to have_field('threshold')

    fill_in 'name', with: '3 for 30%'
    fill_in 'percent_discount', with: 0.30
    fill_in 'threshold', with: 3
    click_button("Update Discount")

    expect(current_path).to eq(merchant_bulk_discount_path(merchant1, bulk1))
    expect(page).to have_content("You have successfully updated this discount")
  end

  it "displays a message if all fields are not filled" do
    merchant1 = Merchant.create!(name: "Schroeder-Jerde")
    bulk1 = merchant1.bulk_discounts.create!(name: '2 at 20%', percent_discount: 0.2, threshold: 2)

    visit edit_merchant_bulk_discount_path(merchant1, bulk1)

    fill_in 'name', with: nil
    fill_in 'percent_discount', with: 0.30
    fill_in 'threshold', with: 3
    click_button("Update Discount")

    expect(current_path).to eq(edit_merchant_bulk_discount_path(merchant1, bulk1))
    expect(page).to have_content("Please fill out all available fields")
  end
end
