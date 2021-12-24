# frozen_string_literal: true

require 'latitude'

module ATCLite
  module Navigation
    # Describes a navigational position on the earth.  Super class for the various navigational points loaded into
    # the system.  Don't foresee objects of this class being created.
    class Waypoint < Coordinate
      attr_reader :name, :region

      # Initializes a waypoint with key elements.
      def initialize(name:, latitude:, longitude:, region:)
        @name = name
        @region = region
        super(latitude: latitude, longitude: longitude)
      end
    end
  end
end