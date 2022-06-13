require 'rails_helper'

RSpec.describe HolidayFacade do
  it "creates holiday poros", :vcr do
    holiday = HolidayFacade.create_holidays
    expect(holiday[0]).to be_an_instance_of(Holiday)
  end
end
