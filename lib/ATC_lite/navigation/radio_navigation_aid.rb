# frozen_string_literal: true

require 'latitude'

module ATCLite
  module Navigation
    # Flightplan describes the flightplan the aircraft is following.  It is made up of a sequence of paths with the
    # first element of the sequence being the current active path being followed.
    class RadioNavigationAid < Waypoint
      include NavigationStorage

      attr_reader :fullname, :frequency, :navtype

      # Initialises a navigation aid with the key parameters
      # rubocop: disable Metrics/ParameterLists - parameters defined by the import file.  Prefer the type checking.
      def initialize(name:, fullname:, latitude:, longitude:, frequency:, navtype:, region:)
        @fullname = fullname
        @frequency = frequency
        @navtype = navtype

        super(latitude: latitude, longitude: longitude, name: name, region: region)
      end
      # rubocop: enable Metrics/ParameterLists
    end
  end
end
