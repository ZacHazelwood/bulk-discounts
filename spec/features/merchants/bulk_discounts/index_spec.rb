require 'rails_helper'

RSpec.describe 'Bulk Discounts Index Page' do
  it "displays all discounts with their info", :vcr do
    merchant1 = Merchant.create!(name: "Schroeder-Jerde")
    bulk1 = merchant1.bulk_discounts.create!(name: '2 at 20%', percent_discount: 0.2, threshold: 2)
    bulk2 = merchant1.bulk_discounts.create!(name: '5 at 30%', percent_discount: 0.3, threshold: 5)

    visit merchant_bulk_discounts_path(merchant1)
    expect(page).to have_content("Schroeder-Jerde's Discounts")

    within ".all_discounts" do
      expect(page).to have_content("2 at 20%")
      expect(page).to have_content("Percent Discounted: 20%")
      expect(page).to have_content("Number of Items Required: 2")
      expect(page).to have_link("Details")

      expect(page).to have_content("5 at 30%")
      expect(page).to have_content("Percent Discounted: 30%")
      expect(page).to have_content("Number of Items Required: 5")

      expect(page).to_not have_content("1 at 100%")
      expect(page).to_not have_content("Percent Discounted: 100%")
      expect(page).to_not have_content("Number of Items Required: 1")
    end

    within "#discount-#{bulk1.id}" do
      expect(page).to have_link("Details")
      click_link
    end

    expect(current_path).to eq(merchant_bulk_discount_path(merchant1, bulk1))
  end

  it "has a link to create a new discount", :vcr do
    merchant1 = Merchant.create!(name: "Schroeder-Jerde")
    bulk1 = merchant1.bulk_discounts.create!(name: '2 at 20%', percent_discount: 0.2, threshold: 2)
    bulk2 = merchant1.bulk_discounts.create!(name: '5 at 30%', percent_discount: 0.3, threshold: 5)

    visit merchant_bulk_discounts_path(merchant1)
    expect(page).to have_link("Create Discount")

    click_link("Create Discount")
    expect(current_path).to eq(new_merchant_bulk_discount_path(merchant1))
  end

  it "has a link to delete a discount", :vcr do
    merchant1 = Merchant.create!(name: "Schroeder-Jerde")
    bulk1 = merchant1.bulk_discounts.create!(name: '2 at 20%', percent_discount: 0.2, threshold: 2)
    bulk2 = merchant1.bulk_discounts.create!(name: '5 at 30%', percent_discount: 0.3, threshold: 5)

    visit merchant_bulk_discounts_path(merchant1)

    within "#discount-#{bulk1.id}" do
      expect(page).to have_button("Delete Discount")
      click_button("Delete Discount")
    end

    expect(current_path).to eq(merchant_bulk_discounts_path(merchant1))

    within ".all_discounts" do
      expect(page).to_not have_content("2 at 20%")
      expect(page).to_not have_content("Percent Discounted: 20%")
      expect(page).to_not have_content("Number of Items Required: 2")

      expect(page).to have_content("5 at 30%")
      expect(page).to have_content("Percent Discounted: 30%")
      expect(page).to have_content("Number of Items Required: 5")
    end
  end

  it 'should have a section of upcoming holidays', :vcr do
    merchant1 = Merchant.create!(name: "Schroeder-Jerde")
    bulk1 = merchant1.bulk_discounts.create!(name: '2 at 20%', percent_discount: 0.2, threshold: 2)
    bulk2 = merchant1.bulk_discounts.create!(name: '5 at 30%', percent_discount: 0.3, threshold: 5)

    visit merchant_bulk_discounts_path(merchant1)

    within '#holidays' do
      expect(page).to have_content("Upcoming Holidays")
      expect(page).to have_content('Juneteenth')
      expect(page).to have_content('Independence Day')
      expect(page).to have_content('Labour Day')
    end
  end
end
