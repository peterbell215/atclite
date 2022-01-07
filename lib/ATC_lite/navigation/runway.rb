# frozen_string_literal: true

require 'great-circle'

module Navigation
  # The Runway class describes a runway at a specific airport.  Note the same piece of concrete is described as
  # two runways for now.
  class Runway < Waypoint
    attr_reader :length, :heading, :ils, :altitude

    # Constructor for the Runway object
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
