# frozen_string_literal: true

module ATCLite
  module Navigation
    # Represents a segment within an airway
    class AirwaySegment
      attr_reader :airway, :waypoint, :index, :extra

      delegate :name, :latitude, :longitude, :to_s, to: :waypoint

      # Constructor for the AirwaySegment object
      def initialize(airway:, index:, waypoint:, extra:)
        @airway = airway
        @index = index
        @waypoint = waypoint
        @extra = extra
      end

      def eql?(other)
        self.name == other.name && self.longitude == other.longitude && self.latitude == other.latitude
      end
      alias == eql?

      def coerce(other)
        other.is_a? Waypoint ? [self.waypoint, other] : [self, other]
      end
    end
  end
end