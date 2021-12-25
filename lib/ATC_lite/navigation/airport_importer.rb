# frozen_string_literal: true

module ATCLite
  module Navigation
    # Reads an FSBuild Airport file and stores the data.
    class AirportImporter
      include NavigationDataImporter

      FIELDS = [
        [:name, /^[0-9A-Z]{4}/],
        [:fullname, /[0-9_A-Z]+/],
        [:elevation, /[0-9]+/],
        [:latitude, LONGLAT],
        [:longitude, LONGLAT],
        [:runways, RunwayImporter]
      ].freeze

      def self.match(string)
        RadioNavigationAidImporter.parse(string)

        self.parse_file(name, Intersection)
      end
    end
  end
end
