require 'rails_helper'

RSpec.describe 'Bulk Discount New Page' do
  it "can create a discount and display a confirmation message", :vcr do
    merchant1 = Merchant.create!(name: "Schroeder-Jerde")

    visit new_merchant_bulk_discount_path(merchant1)

    expect(page).to have_field('name')
    expect(page).to have_field('percent_discount')
    expect(page).to have_field('threshold')

    fill_in 'name', with: '3 for 30%'
    fill_in 'percent_discount', with: 0.30
    fill_in 'threshold', with: 3
    click_button("Create Discount")

    expect(current_path).to eq(merchant_bulk_discounts_path(merchant1))
    expect(page).to have_content("You have successfully created a Discount")
  end

  it "displays a message if all fields are not filled", :vcr do
    merchant1 = Merchant.create!(name: "Schroeder-Jerde")

    visit new_merchant_bulk_discount_path(merchant1)

    fill_in 'name', with: nil
    fill_in 'percent_discount', with: 0.30
    fill_in 'threshold', with: 3
    click_button("Create Discount")

    expect(current_path).to eq(new_merchant_bulk_discount_path(merchant1))
    expect(page).to have_content("Please fill out all available fields")
  end
end
