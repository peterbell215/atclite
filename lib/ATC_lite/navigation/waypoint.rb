# frozen_string_literal: true

require 'latitude'

module ATCLite
  module Navigation
    # Flightplan describes the flightplan the aircraft is following.  It is made up of a sequence of paths with the
    # first element of the sequence being the current active path being followed.
    class Waypoint < Coordinate
      attr_reader :name

      def initialize(name:, latitude:, longitude:)
        @name = name
        super(latitude: latitude, longitude: longitude)
      end
    end
  end
end