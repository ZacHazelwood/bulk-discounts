require 'rails_helper'

RSpec.describe Holiday do
  it "exists and has attributes" do
    data = {name: "Holiday", date: "7/07/22"}
    holiday = Holiday.new(data)

    expect(holiday).to be_an_instance_of(Holiday)
    expect(holiday.name).to eq("Holiday")
    expect(holiday.date).to eq("7/07/22")
  end
end
