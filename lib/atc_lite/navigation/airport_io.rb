# frozen_string_literal: true

module Navigation
  # Reads an FSBuild Airport file and stores the data.
  class AirportIO
    include NavigationDataIO

    FIELDS = [
      [:name, /^[0-9A-Z]{4}/],
      [:fullname, /[0-9_A-Z]+/],
      [:altitude, /[0-9]+/],
      [:latitude, LONGLAT],
      [:longitude, LONGLAT],
      [:runways, [RunwayIO]]
    ].freeze
    FIELD_SEPARATOR = ' '

    def self.parse_apts_file(name='data/apts.txt')
      self.parse_file(name, Airport)
    end
  end
end
