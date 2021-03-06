class SolarInformationClient::SolarPosition
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON

  attr_accessor :hour, :azimuth, :zenith, :lat, :lng, :datetime

  validates :lat, inclusion: { in: -90..90, message: 'INVALID_LATITUDE' }
  validates :lng, inclusion: { in: -180..180, message: 'INVALID_LONGITUDE' }
  validate :valid_iso8601_date?

  self.include_root_in_json = false

  def initialize(attributes = {})
    if attributes
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

  end

  def attributes
    {
        'hour' => hour,
        'azimuth' => azimuth,
        'zenith' => zenith,
    }
  end

  def valid_iso8601_date?
    begin
      Time.iso8601(datetime).getlocal
    rescue
      errors.add(:datetime, 'INVALID_DATETIME')
      return false
    end
    true
  end

end
