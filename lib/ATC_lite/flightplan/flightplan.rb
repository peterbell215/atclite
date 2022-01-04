# frozen_string_literal: true

module ATCLite
  module Flightplan
    # Flightplan describes the flightplan the aircraft is following.  It is made up of a sequence of paths with the
    # first element of the sequence being the current active path being followed.
    class Flightplan
      attr_reader :departure_airport

      def initialize(departure_airport:, enroute:)
        @departure_airport = Navigation::Airport.lookup(departure_airport)
        @routing = Path.new(string: enroute, close_to: @departure_airport)
      end

      def desired_heading(position)
        @routing.shift(1) if position.distance_to(@routing.first) < 1.0
        position.initial_heading_to(@routing.first)
      end

      def [](index)
        @routing[index]
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

