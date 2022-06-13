class HolidayService

  def self.get_url(url)
    response = HTTParty.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.get_holiday_data
    get_url('https://date.nager.at/api/v3/NextPublicHolidays/us')
  end
end
