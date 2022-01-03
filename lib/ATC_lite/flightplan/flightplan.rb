# frozen_string_literal: true

module ATCLite
  module Flightplan
    # Flightplan describes the flightplan the aircraft is following.  It is made up of a sequence of paths with the
    # first element of the sequence being the current active path being followed.
    class Flightplan
      attr_reader :departure_airport, :enroute

      def initialize(departure_airport:, enroute:)
        @departure_airport = departure_airport
        @enroute = enroute
      end

      def transmit
        self
      end

      def routing(departure_airport: , enroute:)
        self
      end

      def fly_direct(waypoint)
        self
      end

      def then_as_filed
        self
      end

      def fly_heading(heading)
        self
      end

      def climb_to(altitude)
        self
      end

      def no_speed_restrictions
        self
      end
    end
  end
end

