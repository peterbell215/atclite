# frozen_string_literal: true

require 'latitude'

module ATCLite
  module Navigation
    # Flightplan describes the flightplan the aircraft is following.  It is made up of a sequence of paths with the
    # first element of the sequence being the current active path being followed.
    class Intersection < Waypoint
      include NavigationStorage

      attr_reader :alternate_name

      def initialize(name:, alternate_name:, latitude:, longitude:, region: nil)
        @alternate_name = alternate_name

        super(latitude: latitude, longitude: longitude, name: name, region: region)
      end
    end
  end
end
