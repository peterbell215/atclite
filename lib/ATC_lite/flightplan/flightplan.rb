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
        new_heading = @routing.first.desired_heading(position)
        return new_heading if new_heading != :next_routing

        @routing.shift
        @routing.first.desired_heading(position)
      end

      def current
        @routing.first
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
        routings_to_be_removed = @routing.find_index do |routing|
          routing == waypoint
        end
        @routing.shift(routings_to_be_removed)
        self
      end

      def then_as_filed
        self
      end

      def fly_heading(heading)
        @routing.unshift(FlyHeading.new(heading))
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

