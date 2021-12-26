# frozen_string_literal: true

require 'latitude'

module ATCLite
  module Navigation
    include NavigationStorage

    # Flightplan describes the flightplan the aircraft is following.  It is made up of a sequence of paths with the
    # first element of the sequence being the current active path being followed.
    class Airport < Waypoint
      include NavigationStorage

      attr_reader :fullname, :altitude, :runways

      # Constructor for the Airport object
      def initialize(name:, fullname:, altitude:, latitude:, longitude:, runways:)
        @fullname = fullname
        @altitude = Altitude.new(altitude)
        @runways = runways

        super(latitude: latitude, longitude: longitude, name: name, region: nil)
      end
    end
  end
end
