# frozen_string_literal: true

require 'latitude'

module ATCLite
  module Navigation
    # Flightplan describes the flightplan the aircraft is following.  It is made up of a sequence of paths with the
    # first element of the sequence being the current active path being followed.
    class Runway < Waypoint
      attr_reader :length, :heading, :ils, :altitude

      def initialize(name:, length:, latitude:, longitude:, heading:, ils:)
        @length = length.to_i
        @ils = ils != '---' ? ils : nil
        @heading = heading.to_i

        super(latitude: latitude, longitude: longitude, name: name, region: nil)
      end

      def eql?(other)
        super(other) && @length == other.length && @ils == other.ils && @heading == other.heading
      end
      alias == eql?
    end
  end
end