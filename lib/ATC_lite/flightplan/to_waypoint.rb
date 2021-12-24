# frozen_string_literal: true

module ATCLite
  module Navigation
    class ToWaypoint < Path
      attr_reader :waypoint, :lower_altitude, :upper_altitude

      def initialize(waypoint:, lower_altitude:, upper_altitude:)
        super

        @waypoint = waypoint
        @lower_altitude = Altitude.new(lower_altitude)
        @upper_altitude = Altitude.new(upper_altitude)
      end

      def required_heading(aircraft)
        aircraft.position.distance_to(@waypoint) > 2 ? aircraft.position.initial_bearing_to(@waypoint) : :next_waypoint
      end
    end
  end
end