# frozen_string_literal: true

module ATCLite
  module Navigation
    # Represents a segment within an airway
    class AirwaySegmentIO
      include NavigationDataImporter

      FIELDS = [
        [:airway, /^[0-9A-Z]{1,5}/],
        [:index, /[0-9]+/],
        [:waypoint, /^[0-9A-Z]{1,5}/],
        [:latitude, LONGLAT],
        [:longitude, LONGLAT],
        [:extra, [/[HLBF]/]]
      ].freeze
      FIELD_SEPARATOR = ' '
    end
  end
end
