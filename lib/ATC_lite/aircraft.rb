# frozen_string_literal: true

module ATCLite
  # Detqils of an aircraft
  class Aircraft
    attr_accessor :callsign, :speed, :altitude, :heading, :x, :y

    def initialize(callsign: 'BA001', speed: 250.0, altitude: 1000, heading: 0.0, x: 0, y: 0)
      @callsign = callsign
      @speed = speed
      @altitude = altitude
      @heading = heading
      @x = x
      @y = y
    end

    def update
      heading_in_radians = self.heading * Math::PI / 180.0
      distance_covered_in_1_s = self.speed / 3600.0

      self.x += distance_covered_in_1_s * Math.sin(heading_in_radians)
      self.y -= distance_covered_in_1_s * Math.cos(heading_in_radians)
    end
  end
end