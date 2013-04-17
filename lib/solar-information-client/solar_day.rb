class SolarInformationClient::SolarDay
  include ActiveModel::Serializers::JSON
  include ActiveModel::Validations

  attr_accessor :solarpositions, :lat, :lng, :datetime

  def initialize(attributes = {})
    if attributes
      attributes.each do |name, value|
        if name == 'solarpositions'
          value = parse_solar_positions(value)
        end
        send("#{name}=", value)
      end
    end
  end

  def parse_solar_positions(solarpositions)
    positions = []
    solarpositions.each do |position|
      positions << SolarInformationClient::SolarPosition.new(position['solar_position'])
    end
    positions
  end

  def attributes
    {
        'solarpositions' => solarpositions,
        'lat' => lat,
        'lng' => lng,
        'datetime' => datetime
    }
  end

  def current_position
    t = Time.iso8601(datetime).getlocal
    hour = t.min > 30 ? t.hour + 1 : t.hour
    current = solarpositions.find { |position| position.hour == hour}
    return solarpositions.first if current.nil?
    current
  end

  def self.get_solar_day(lat, lng, datetime)
    response = Typhoeus::Request.new(
        get_solar_day_uri,
        params: {
            lat: lat,
            lng: lng,
            datetime: datetime
        }).run

    json = Yajl::Parser.parse(response.body)
    new(json['solar_day'])
  end

  def self.get_solar_day_uri
    "http://#{SolarInformationClient::Config.host}/api/v1/solarposition/day"
  end


end