# frozen_string_literal: true

module ATCLite
  module Navigation
    # Represents a segment within an airway
    class AirwaySegment
      attr_reader :airway, :waypoint, :index, :extra

      delegate :latitude, :longitude, to: :waypoint

      # Constructor for the AirwaySegment object
      def initialize(airway:, index:, waypoint:, extra:)
        @airway = airway
        @index = index
        @waypoint = waypoint
        @extra = extra
      end
    end
  end
end