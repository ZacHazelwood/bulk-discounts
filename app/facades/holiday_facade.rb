class HolidayFacade

  def self.create_holidays
    json = HolidayService.get_holiday_data

    holidays = json.first(3).map do |data|
      Holiday.new(data)
    end
  end
end
