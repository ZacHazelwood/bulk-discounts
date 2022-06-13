require 'rails_helper'
require './app/services/holiday_service'

RSpec.describe HolidayService do
  describe "holiday endpoint" do
    it "gets holiday data from endpoint", :vcr do
      json = HolidayService.get_holiday_data
      expect(json[0]).to have_key(:name)
    end
  end
end
