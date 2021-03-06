# frozen_string_literal: true

module Navigation
  # Represents a segment within an airway
  class AirwaySegmentIO
    include NavigationDataIO

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
