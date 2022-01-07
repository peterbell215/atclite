# frozen_string_literal: true

require 'great-circle'

module Navigation
  # Describes a navigational position on the earth.  Super class for the various navigational points loaded into
  # the system.  Don't foresee objects of this class being created.
  class Waypoint < Coordinate
    attr_reader :name, :region

    # Finds an appropriate waypoint by name
    def self.lookup(name, nearest = nil)
      RadioNavigationAid.lookup(name, nearest) || Intersection.lookup(name, nearest)
    end

    # Initializes a waypoint with key elements.
    def initialize(name:, latitude:, longitude:, region:)
      @name = name
      @region = region
      super(latitude: latitude, longitude: longitude)
    end

    def desired_heading(position)
      distance = position.distance_to(self)
      distance > 1.0 ? position.initial_heading_to(self) : :next_routing
    end

    def eql?(other)
      return false if other.respond_to?(:name) && @name != other.name
      super(other)
    end
    alias == eql?

    def to_s
      "#{name}#{coordinates_to_s}"
    end

    def coordinates_to_s
      "[#{latitude.format(decimals: 4, sign: %w[N S])},#{longitude.format(decimals: 4, sign: %w[E W])}]"
    end
  end
end
