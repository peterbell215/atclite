# frozen_string_literal: true

require 'latitude'

module ATCLite
  module Navigation
    # Flightplan describes the flightplan the aircraft is following.  It is made up of a sequence of paths with the
    # first element of the sequence being the current active path being followed.
    class Airport < Waypoint
      include NavigationStorage

      attr_reader :fullname, :elevation, :runways

      def initialize(name:, fullname:, elevation:, latitude:, longitude:, runways:)
        @fullname = fullname
        @elevation = elevation
        @runways = runways

        super(latitude: latitude, longitude: longitude, name: name, region: nil)
      end
    end
  end
end