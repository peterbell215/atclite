# frozen_string_literal: true

module ATCLite
  # Detqils of an aircraft
  class Aircraft
    attr_reader :callsign, :speed, :heading, :altitude, :x, :y

    attr_accessor :target_heading

    KNOTS_TO_NM_PER_SECOND = 1.0/3600.00
    TURN_RATE_PER_SECOND = 2

    def initialize(callsign: 'BA001', speed: 250.0, altitude: 1000, heading: 0.0, x: 0, y: 0)
      @callsign = callsign
      @speed = speed
      @altitude = altitude
      @target_altitude = altitude
      @climb_rate = 0
      @heading = heading
      @target_heading = heading
      @x = x
      @y = y
    end

    # standard aircraft turn is 180 degrees per min, or 2 degrees per second
    def update_heading
      return if @target_heading == @heading

      delta = (@target_heading - @heading)
      delta += 360 if delta < -180
      delta -= 360 if delta > 180

      delta = [-TURN_RATE_PER_SECOND, delta].max
      delta = [delta, TURN_RATE_PER_SECOND].min

      @heading = (@heading + delta) % 360
    end

    # calculates, given a speed over ground, the updated position.
    def update_position
      heading_in_radians = self.heading * Math::PI / 180.0
      distance_covered_in_1_s = self.speed * KNOTS_TO_NM_PER_SECOND

      @x += distance_covered_in_1_s * Math.sin(heading_in_radians)
      @y -= distance_covered_in_1_s * Math.cos(heading_in_radians)
    end
  end
end